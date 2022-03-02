use array_macro::array;

use crate::{sleeplock::SleepLock, spinlock::SpinLock, consts::param::NINODE, fs::log::{log_write, LOG}};

use super::{NDIRECT, BSIZE, superblock::{SuperBlock, SB}, bio::BCACHE, bitmap::{bfree, balloc}, NINDIRECT};

/// On disk inode structure
#[repr(C)]
pub struct DInode {
    _type: FileType,// File type
    major: u16,     // Major device number (T_DEVICE only)
    minor: u16,     // Minor device number (T_DEVICE only)
    nlink: u16,     // Number of links to inode in file system
    size: u32,      // Size of file (bytes)
    addrs: [u32; NDIRECT + 1],  // data block address
}

impl DInode {
    fn zero(&mut self) {
        self._type = FileType::Empty;
        self.major = 0;
        self.minor = 0;
        self.nlink = 0;
        self.size = 0;
        for i in 0..NDIRECT + 1 {
            self.addrs[i] = 0;
        }
    }
}

/// Inodes per block
pub const IPB: u32 = (BSIZE / core::mem::size_of::<DInode>()) as u32;

/// Block containing inode i
#[inline]
pub fn IBLOCK(i: u32, sb: &SuperBlock) -> u32 {
    i / IPB + sb.inodestart
}

/// Bitmap bits per block
pub const BPB: u32 = BSIZE as u32 * 8;

/// Block of free map containing bit for block b
#[inline]
pub fn BBLOCK(b: u32, sb: &SuperBlock) -> u32 {
    b / BPB as u32 + sb.bmapstart
}

// Inodes.
//
// An inode describes a single unnamed file.
// The inode disk structure holds metadata: the file's type,
// its size, the number of links referring to it, and the
// list of blocks holding the file's content.
//
// The inodes are laid out sequentially on disk at
// sb.startinode. Each inode has a number, indicating its
// position on the disk.
//
// The kernel keeps a table of in-use inodes in memory
// to provide a place for synchronizing access
// to inodes used by multiple processes. The in-memory
// inodes include book-keeping information that is
// not stored on disk: ip->ref and ip->valid.
//
// An inode and its in-memory representation go through a
// sequence of states before they can be used by the
// rest of the file system code.
//
// * Allocation: an inode is allocated if its type (on disk)
//   is non-zero. ialloc() allocates, and iput() frees if
//   the reference and link counts have fallen to zero.
//
// * Referencing in table: an entry in the inode table
//   is free if ip->ref is zero. Otherwise ip->ref tracks
//   the number of in-memory pointers to the entry (open
//   files and current directories). iget() finds or
//   creates a table entry and increments its ref; iput()
//   decrements ref.
//
// * Valid: the information (type, size, &c) in an inode
//   table entry is only correct when ip->valid is 1.
//   ilock() reads the inode from
//   the disk and sets ip->valid, while iput() clears
//   ip->valid if ip->ref has fallen to zero.
//
// * Locked: file system code may only examine and modify
//   the information in an inode and its content if it
//   has first locked the inode.
//
// Thus a typical sequence is:
//   ip = iget(dev, inum)
//   ilock(ip)
//   ... examine and modify ip->xxx ...
//   iunlock(ip)
//   iput(ip)
//
// ilock() is separate from iget() so that system calls can
// get a long-term reference to an inode (as for an open file)
// and only lock it for short periods (e.g., in read()).
// The separation also helps avoid deadlock and races during
// pathname lookup. iget() increments ip->ref so that the inode
// stays in the table and pointers to it remain valid.
//
// Many internal file system functions expect the caller to
// have locked the inodes involved; this lets callers create
// multi-step atomic operations.
//
// The itable.lock spin-lock protects the allocation of itable
// entries. Since ip->ref indicates whether an entry is free,
// and ip->dev and ip->inum indicate which i-node an entry
// holds, one must hold itable.lock while using any of those fields.
//
// An ip->lock sleep-lock protects all ip-> fields other than ref,
// dev, and inum.  One must hold ip->lock in order to
// read or write that inode's ip->valid, ip->size, ip->type, &c.

#[repr(u16)]
#[derive(Clone, Copy, PartialEq, Eq)]
pub enum FileType {
    Empty = 0,
    Directory = 1,
    File = 2,
    Device = 3,
}

// in-memory copy of an inode
pub struct Inode {
    // protected by itable
    dev: u32,       // device number
    inum: u32,      // inode number
    refcnt: u32,    // reference count
    lock: SleepLock<()>, // protect everything below here
    valid: bool,    // inode has been read from disk

    // copy of disk inode
    _type: FileType,// File type
    major: u16,     // Major device number (T_DEVICE only)
    minor: u16,     // Minor device number (T_DEVICE only)
    nlink: u16,     // Number of links to inode in file system
    size: u32,      // Size of file (bytes)
    addrs: [u32; NDIRECT + 1],  // data block address
}

pub struct Stat {
    dev: u32,   // File System's disk device
    ino: u32,   // Inode number
    _type: FileType, // Type of file
    nlink: u16, // Number of links to file
    size: u32,  // Size of file in bytes
}

impl Stat {
    pub fn new() -> Self {
        Self {
            dev: 0,
            ino: 0,
            _type: FileType::Empty,
            nlink: 0,
            size: 0,
        }
    }

    pub fn from_inode(ip: &Inode) -> Self {
        Self {
            dev: ip.dev,
            ino: ip.inum,
            _type: ip._type,
            nlink: ip.nlink,
            size: ip.size,
        }
    }
}

pub struct ITable {
    lock: SpinLock<()>,
    inode: [Inode; NINODE],
}

pub static mut ITABLE: ITable = ITable::new();

impl ITable {
    const fn new() -> Self {
        Self {
            lock: SpinLock::new((), "itable"),
            inode: array![_ => Inode::new(); NINODE],
        }
    }

    // Find the inode with number inum on device dev
    // and return the in-memory copy. Does not lock
    // the inode and does not read it from disk.
    pub fn iget(&mut self, dev: u32, inum: u32) -> &mut Inode {
        self.lock.acquire();

        let mut empty = None;
        // is the inode already in the table?
        for i in 0..self.inode.len() {
            if self.inode[i].refcnt > 0 &&
                self.inode[i].dev == dev &&
                self.inode[i].inum == inum {
                // increase the refcnt and return it
                self.inode[i].refcnt += 1;
                self.lock.release();
                return &mut self.inode[i];
            }
            
            // remember empty slot
            if empty.is_none() && 
                self.inode[i].refcnt == 0 {
                empty = Some(i);
            }
        }
        
        if empty.is_none() {
            panic!("iget: no inodes");
        }

        // Recycle an inode entry
        let idx = empty.unwrap();
        self.inode[idx].dev = dev;
        self.inode[idx].inum = inum;
        self.inode[idx].refcnt = 1;
        self.inode[idx].valid = false;

        self.lock.release();

        &mut self.inode[idx]
    }

    // Increment reference count for ip
    // Returns ip to enable ip = idup(ip1) idiom
    // Since ip is always the same, so we don't returns it
    pub fn idup(&self, ip: &mut Inode) {
        self.lock.acquire();
        ip.refcnt += 1;
        self.lock.release();
    }

    // Drop a reference to an in-memory inode.
    // If that was the last reference, the inode table entry can
    // be recycled.
    // If that was the last reference and the inode has no links
    // to it, free the inode (and its content) on disk.
    // All calls to iput() must be inside a transaction in
    // case it has to free the inode.
    pub fn iput(&self, ip: &mut Inode) {
        self.lock.acquire();

        if ip.refcnt == 1 &&
            ip.valid &&
            ip.nlink == 0 {
            // inode has no links and no other references: truncate and free.

            // we are the only one who has this icache
            // normally, we should hold the ip->lock while
            // reading valid and nlink
            // but now we know there can't have others accessing 
            // the same data as the same time

            // ip->ref == 1 means no other process can have ip locked,
            // so this acquiresleep() won't block (or deadlock).
            // ip.lock must hold before we release the itable lock
            // because someone may come in and increase the refcnt
            // then we may free a node used by others

            // but we can't use itable->lock to manage this critical section
            // even if semantically it could.
            // because we will do disk operations while freeing inode
            // which may cause context switch.
            // we can't hold the spinlock during some operation that could wait
            // thus we have to use ip->lock to protect critical section

            ip.lock.acquire();

            self.lock.release();

            ip.itrunc();
            // type = 0 in disk indicate this inode is free
            ip._type = FileType::Empty;
            ip.iupdate();

            ip.valid = false;

            ip.lock.release();

            self.lock.acquire();
            // is that means we may get an inode which has been freed
        }

        ip.refcnt -= 1;
        self.lock.release();
    }

    // Common idiom: unlock then put
    pub fn iunlockput(&self, ip: &mut Inode) {
        ip.iunlock();
        self.iput(ip);
    }

}

impl Inode {
    const fn new() -> Self {
        Self {
            dev: 0,
            inum: 0,
            refcnt: 0,
            lock: SleepLock::new((), "inode"),
            valid: false,
            _type: FileType::Empty,
            major: 0,
            minor: 0,
            nlink: 0,
            size: 0,
            addrs: [0; NDIRECT + 1],
        }
    }

    // Lock the given inode
    // Reads the inode from disk if necessary
    pub fn ilock(&mut self) {
        // rust helps us guarantee the ip is valid
        if self.refcnt < 1 {
            panic!("ilock");
        }

        self.lock.acquire();
        
        if !self.valid {
            unsafe {
                let b = BCACHE.bread(self.dev, IBLOCK(self.inum, &SB));
                let dip = &mut *((b.data.as_mut_ptr()
                    as *mut DInode)
                    .add((self.inum % IPB) as usize));
                self._type = dip._type;
                self.major = dip.major;
                self.minor = dip.minor;
                self.nlink = dip.nlink;
                self.size = dip.size;
                core::ptr::copy_nonoverlapping(
                    dip.addrs.as_ptr(), 
                    self.addrs.as_mut_ptr(),
                    dip.addrs.len()
                );
                BCACHE.brelse(b);
                self.valid = true;

                if self._type == FileType::Empty {
                    panic!("ilock: no type");
                }
            }
        }
    }

    // Unlock the given inode
    pub fn iunlock(&self) {
        if !self.lock.holding() || self.refcnt < 1 {
            panic!("iunlock");
        }

        self.lock.release();
    }

    // Copy a modified in-memory inode to disk
    // Must be called after every change to an ip->xxx filed
    // that lives on disk
    // Caller must hold ip->lock
    pub fn iupdate(&mut self) {
        if !self.lock.holding() {
            panic!("itrunc");
        }

        unsafe {
            let b = BCACHE.bread(self.dev, IBLOCK(self.inum, &SB));
            // convert disk contect to dinode
            let dip = &mut *((b.data.as_mut_ptr()
                as *mut DInode)
                .add((self.inum % IPB) as usize));
            dip._type = self._type;
            dip.major = self.major;
            dip.minor = self.minor;
            dip.nlink = self.nlink;
            dip.size = self.size;
            core::ptr::copy_nonoverlapping(
                self.addrs.as_ptr(), 
                dip.addrs.as_mut_ptr(),
                self.addrs.len()
            );
            // log the change
            log_write(b);
            BCACHE.brelse(b);
        }
    }

    // Truncate inode (discart contents)
    // Caller must hold ip->lock
    pub fn itrunc(&mut self) {
        if !self.lock.holding() {
            panic!("itrunc");
        }

        for i in 0..NDIRECT {
            if self.addrs[i] != 0 {
                bfree(self.dev, self.addrs[i]);
                self.addrs[i] = 0;
            }
        }

        // free the indirect node
        if self.addrs[NDIRECT] != 0 {
            let b = unsafe { 
                BCACHE.bread(self.dev, self.addrs[NDIRECT])
            };
            let a = unsafe {
                &mut *(b.data.as_mut_ptr() as *mut [u32; NINDIRECT])
            };
            
            for j in 0..NINDIRECT {
                if a[j] != 0 {
                    bfree(self.dev, a[j]);
                }
            }

            unsafe {
                BCACHE.brelse(b);
            }
            bfree(self.dev, self.addrs[NDIRECT]);
        }

        self.size = 0;
        self.iupdate();
    }

    // Inode content
    //
    // The content (data) associated with each inode is stored
    // in blocks on the disk. The first NDIRECT block numbers
    // are listed in ip->addrs[].  The next NINDIRECT blocks are
    // listed in block ip->addrs[NDIRECT].

    // Return the disk block address of the nth block in inode ip.
    // If there is no such block, bmap allocates one.
    pub fn bmap(&mut self, bn: u32) -> u32 {
        let mut bn = bn as usize;
        if bn < NDIRECT {
            if self.addrs[bn] == 0 {
                self.addrs[bn] = balloc(self.dev);
            }
            return self.addrs[bn];
        }
        bn -= NDIRECT;

        if bn < NINDIRECT {

        }

        panic!("bmap: out of range");
    }

}

// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
pub fn ialloc(dev: u32, _type: FileType) -> &'static mut Inode {
    unsafe {
        for inum in 1..SB.ninodes {
            let b = BCACHE.bread(dev, IBLOCK(inum, &SB));
            // convert disk contect to dinode
            let dip = &mut *((b.data.as_mut_ptr()
                as *mut DInode)
                .add((inum % IPB) as usize));
            
            // a free inode
            if dip._type == FileType::Empty {
                dip.zero();
                dip._type = _type;
                // mark it allocated on the disk
                log_write(b);   
                BCACHE.brelse(b);
                return ITABLE.iget(dev, inum);
            }

            BCACHE.brelse(b);
        }
    }
    panic!("ialloc: no inodes");
}