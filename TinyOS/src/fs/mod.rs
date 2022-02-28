pub use bio::{Buf};

use self::superblock::SB;

pub const BSIZE: usize = 1024;
pub const FSMAGIC: u32 = 0x10203040;
pub const NDIRECT: usize = 12;
pub const NINDIRECT: usize = BSIZE / core::mem::size_of::<u32>();
pub const MAXFILE: usize = NDIRECT + NINDIRECT;

mod bio;
mod superblock;
mod log;

pub fn fsinit(dev: u32) {
    unsafe {
        SB.read(dev);
        SB.check_magic();
    }
    // TODO: init log
}