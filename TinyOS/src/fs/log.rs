use crate::{consts::param::LOGSIZE, spinlock::SpinLock};

use super::{superblock::SuperBlock, BSIZE, bio::BCACHE};

// Simple logging that allows concurrent FS system calls.
//
// A log transaction contains the updates of multiple FS system
// calls. The logging system only commits when there are
// no FS system calls active. Thus there is never
// any reasoning required about whether a commit might
// write an uncommitted system call's updates to disk.
//
// A system call should call begin_op()/end_op() to mark
// its start and end. Usually begin_op() just increments
// the count of in-progress FS system calls and returns.
// But if it thinks the log is close to running out, it
// sleeps until the last outstanding end_op() commits.
//
// The log is a physical re-do log containing disk blocks.
// The on-disk log format:
//   header block, containing block #s for block A, B, C, ...
//   block A
//   block B
//   block C
//   ...
// Log appends are synchronous.

// Contents of the header block, used for both the on-disk header block
// and to keep track in memory of logged block# before commit.

pub static mut LOG: Log = Log::new();

#[repr(C)]
pub struct LogHeader {
    n: u32,
    block: [u32; LOGSIZE],
}

#[repr(C)]
pub struct Log {
    pub lock: SpinLock<()>,
    pub start: u32,
    pub size: u32,
    pub outstanding: u32,
    pub committing: u32,
    pub dev: u32,
    pub lh: LogHeader,
}

impl LogHeader {
    const fn new() -> Self {
        Self {
            n: 0,
            block: [0; LOGSIZE],
        }
    }
}

impl Log {
    const fn new() -> Self {
        Self {
            lock: SpinLock::new((), "log"),
            start: 0,
            size: 0,
            outstanding: 0,
            committing: 0,
            dev: 0,
            lh: LogHeader::new(),
        }
    }

    pub fn initlog(&mut self, dev: u32, sb: &SuperBlock) {
        if core::mem::size_of::<LogHeader>() >= BSIZE {
            panic!("initlog: too big logheader");
        }
        self.start = sb.logstart;
        self.size = sb.nlog;
        self.dev = dev;
        // TODO: recover from log
    }

    // Copy committed blocks from log to their home location
    pub fn install_trans(&self, recovering: bool) {
        let mut tail = 0;
        while tail < self.lh.n {
            unsafe {
                // read log block
                let lbuf = BCACHE.bread(self.dev, self.start + tail + 1);
                // read dst
                let dbuf = BCACHE.bread(self.dev, self.lh.block[tail as usize]);
                
                // ptr is *mut u8, so we shall pass size of data here
                core::ptr::copy_nonoverlapping(
                    lbuf.data.as_ptr(),
                    dbuf.data.as_mut_ptr(),
                    lbuf.data.len()
                );

                // write dst to disk
                dbuf.bwrite();

                if !recovering {
                    BCACHE.bunpin(dbuf);
                }

                BCACHE.brelse(lbuf);
                BCACHE.brelse(dbuf);
            }
        }
    }
}