use super::{bio::BCACHE, FSMAGIC};

// Disk layout:
// [ boot block | super block | log | inode blocks |
//                                          free bit map | data blocks]
//
// mkfs computes the super block and builds an initial file system. The
// super block describes the disk layout:

pub static mut SB: SuperBlock = SuperBlock::new();

#[repr(C)]
pub struct SuperBlock {
    pub magic: u32,         // Must be FSMAGIC
    pub size: u32,          // Size of file system image (blocks)
    pub nblocks: u32,       // Number of data blocks
    pub ninodes: u32,       // Number of inodes
    pub nlog: u32,          // Number of log blocks
    pub logstart: u32,      // Block number of first log block
    pub inodestart: u32,    // block number of first inode block
    pub bmapstart: u32,     // block number of first free map block
}

impl SuperBlock {
    pub const fn new() -> Self {
        Self {
            magic: 0,
            size: 0,
            nblocks: 0,
            ninodes: 0,
            nlog: 0,
            logstart: 0,
            inodestart: 0,
            bmapstart: 0,
        }
    }

    // Read the super block.
    pub unsafe fn read(&mut self, dev: u32) {
        let b = BCACHE.bread(dev, 1);
        core::ptr::copy_nonoverlapping(
            b.data.as_ptr() as *const SuperBlock,
            self as *mut SuperBlock,
            1
        );
    }

    pub fn check_magic(&self) {
        if self.magic != FSMAGIC {
            panic!("invalid file system");
        }
    }
}