pub use bio::{Buf, BCACHE};
pub use inode::{Inode, ITABLE, InodeType};
pub use device::{DEVSW, Device};
pub use log::{begin_op, end_op};
pub use directory::{namei};
pub use file::{File, FileType, FTABLE};

use self::{superblock::SB, log::{LOG, log_write}, inode::{BBLOCK, BPB, ialloc}, directory::{DIRSIZ, nameiparent}};

pub const BSIZE: usize = 1024;
pub const FSMAGIC: u32 = 0x10203040;
pub const NDIRECT: usize = 12;
pub const NINDIRECT: usize = BSIZE / core::mem::size_of::<u32>();
pub const MAXFILE: usize = NDIRECT + NINDIRECT;

// root i-number
pub const ROOTINO: u32 = 1;

#[inline]
pub fn major(dev: usize) -> usize {
    dev >> 16 & 0xFFFF
}

#[inline]
pub fn minor(dev: usize) -> usize {
    dev & 0xFFFF
}

#[inline]
pub fn mkdev(m: usize, n: usize) -> usize {
    m << 16 | n
}

mod bio;
mod superblock;
mod log;
mod inode;
mod file;
mod bitmap;
mod device;
mod directory;

pub fn fsinit(dev: u32) {
    unsafe {
        SB.read(dev);
        SB.check_magic();
        LOG.initlog(dev, &SB);
    }
}

/// zero a block
pub fn bzero(dev: u32, bno: u32) {
    unsafe {
        let b = BCACHE.bread(dev, bno);
        core::ptr::write_bytes(b.data.as_mut_ptr(), 0, b.data.len());
        log_write(b);
        BCACHE.brelse(b);
    }
}

pub fn create(path: &[u8], itype: InodeType, major: u16, minor: u16) -> Option<&'static mut Inode> {
    let mut name = [0u8; DIRSIZ];

    let dp;
    match nameiparent(path, &mut name) {
        Some(i) => {
            dp = i;
        }
        None => {
            return None
        }
    }

    dp.ilock();

    {
        match dp.dirloopup(&name, None) {
            Some(i) => {
                // file existing
                unsafe { ITABLE.iunlockput_leak(dp) };
                i.ilock();

                if itype == InodeType::File && (i.itype == InodeType::File || i.itype == InodeType::Device) {
                    return Some(unsafe {&mut *(i as *mut Inode)});
                    // return Some(i);
                }
                unsafe { ITABLE.iunlockput(i) };
                return None
            }
            None => {}
        }
    }

    let ip = ialloc(dp.dev, itype);

    ip.ilock();
    ip.major = major;
    ip.minor = minor;
    ip.nlink = 1;
    ip.iupdate();

    if itype == InodeType::Directory {  // create . and .. entries
        dp.nlink += 1; // for ".."
        dp.iupdate();
        // No ip.nlink++ for ".": avoid cyclic ref count
        if !ip.dirlink(b".\0", ip.inum) || !ip.dirlink(b"..\0", dp.inum) {
            panic!("create dots");
        }
    }

    if !dp.dirlink(&name, ip.inum) {
        panic!("create dir link");
    }

    unsafe { ITABLE.iunlockput(dp) };

    return Some(ip);
}

pub fn strcmp(lhs: &[u8], rhs: &[u8]) -> bool {
    core::str::from_utf8(lhs) == core::str::from_utf8(rhs)
}

pub fn strclone(str: &[u8]) -> [u8; DIRSIZ] {
    let mut res = [0; DIRSIZ];
    for cur in 0..str.len() {
        if cur >= DIRSIZ {
            break;
        }
        res[cur] = str[cur];
    }
    res
}