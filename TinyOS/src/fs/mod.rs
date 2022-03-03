pub use bio::{Buf};
pub use inode::Inode;

use self::{superblock::SB, log::{LOG, log_write}, bio::BCACHE, inode::{BBLOCK, BPB}};

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
    let b = unsafe { BCACHE.bread(dev, bno) };
    // TODO: use memset
    for i in 0..b.data.len() {
        b.data[i] = 0;
    }
    log_write(b);
    unsafe { BCACHE.brelse(b) };
}
