use crate::fs::{superblock::SB, bio::BCACHE, inode::{BBLOCK, BPB}, log::log_write, bzero};

/// allocate a zeroed disk block
pub fn balloc(dev: u32) -> u32 {
    let mut b = 0;
    let block_num = unsafe { SB.size };
    while b < block_num {
        unsafe {
            let bp = BCACHE.bread(dev, BBLOCK(b, &SB));
            let mut bi = 0;
            while bi < BPB && b + bi < block_num {
                let m = 1 << (bi % 8);
                
                // is block free?
                if (bp.data[(bi / 8) as usize] & m) == 0 {
                    // mark block in use
                    bp.data[(bi / 8) as usize] |= m;
                    log_write(bp);
                    BCACHE.brelse(bp);
                    bzero(dev, b + bi);
                    
                    return b + bi;
                }
                bi += 1;
            }
            BCACHE.brelse(bp);
            b += BPB;
        }
    }
    panic!("balloc: out of blocks");
}

/// free a disk block
pub fn bfree(dev: u32, b: u32) {
    unsafe {
        let bp = BCACHE.bread(dev, BBLOCK(b, &SB));
        let bi = b % BPB;
        let m = 1 << (bi % 8);
        if (bp.data[(bi / 8) as usize] & m) == 0 {
            panic!("freeing free block");
        }

        bp.data[(bi / 8) as usize] &= !m;
        log_write(bp);
        BCACHE.brelse(bp);
    }
}