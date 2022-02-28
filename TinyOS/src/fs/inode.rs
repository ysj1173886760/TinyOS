use crate::sleeplock::SleepLock;

use super::{NDIRECT, BSIZE, superblock::SuperBlock};

/// On disk inode structure
#[repr(C)]
pub struct DInode {
    _type: u16,     // File type
    major: u16,     // Major device number (T_DEVICE only)
    minor: u16,     // Minor device number (T_DEVICE only)
    nlink: u16,     // Number of links to inode in file system
    size: u32,      // Size of file (bytes)
    addrs: [u32; NDIRECT + 1],  // data block address
}

/// Inodes per block
pub const IPB: usize = BSIZE / core::mem::size_of::<DInode>();

/// Block containing inode i
#[inline]
pub fn IBLOCK(i: usize, sb: &SuperBlock) -> usize {
    i / IPB + sb.inodestart as usize
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

// in-memory copy of an inode
pub struct Inode {
    dev: u32,       // device number
    inum: u32,      // inode number
    refcnt: u32,    // reference count
    lock: SleepLock<()>, // protect everything below here
    valid: bool,    // inode has been read from disk

    // copy of disk inode
    _type: u16,     // File type
    major: u16,     // Major device number (T_DEVICE only)
    minor: u16,     // Minor device number (T_DEVICE only)
    nlink: u16,     // Number of links to inode in file system
    size: u32,      // Size of file (bytes)
    addrs: [u32; NDIRECT + 1],  // data block address
}