use crate::{consts::param::{LOGSIZE, MAXOPBLOCKS}, spinlock::SpinLock, process::{myproc, proc_manager, Proc}};

use super::{superblock::SuperBlock, BSIZE, bio::BCACHE, Buf};

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
    pub committing: bool,
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
            committing: false,
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
        for tail in 0..self.lh.n {
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

                // log_write increases it's refcnt
                if !recovering {
                    BCACHE.bunpin(dbuf);
                }

                BCACHE.brelse(lbuf);
                BCACHE.brelse(dbuf);
            }
        }
    }

    // Read the log header from disk into the in-memory log header
    pub fn read_head(&mut self) {
        let b = unsafe { BCACHE.bread(self.dev, self.start) };
        let lh = unsafe { &mut *(b.data.as_ptr() as *mut LogHeader) };
        self.lh.n = lh.n;
        for i in 0..self.lh.n as usize {
            self.lh.block[i] = lh.block[i];
        }
        unsafe { BCACHE.brelse(b) };
    }

    // Write in-memory log header to disk.
    // This is the true point at which the
    // current transaction commits.
    pub fn write_head(&self) {
        let b = unsafe { BCACHE.bread(self.dev, self.start) };
        let lh = unsafe { &mut *(b.data.as_ptr() as *mut LogHeader) };
        lh.n = self.lh.n;
        for i in 0..self.lh.n as usize {
            lh.block[i] = self.lh.block[i];
        }
        unsafe {
            b.bwrite();
            BCACHE.brelse(b);
        }
    }

    pub fn recover_from_log(&mut self) {
        self.read_head();

        // if committed, copy from log to disk
        self.install_trans(true);

        // clear the log
        self.lh.n = 0;
        self.write_head();
    }

    // copy modified blocks from cache to log
    pub fn write_log(&mut self) {
        for tail in 0..self.lh.n {
            unsafe {
                // log block
                let to= BCACHE.bread(self.dev, self.start + tail + 1);
                // cache block
                let from = BCACHE.bread(self.dev, self.lh.block[tail as usize]);
                core::ptr::copy(
                    from.data.as_ptr(),
                    to.data.as_mut_ptr(),
                    from.data.len()
                );
                to.bwrite();
                BCACHE.brelse(from);
                BCACHE.brelse(to);
            }
        }
    }

    pub fn commit(&mut self) {
        if self.lh.n > 0 {
            // write modified blocks from cache to log
            self.write_log();

            // write header to disk -- the real commit
            self.write_head();

            // now install writes to home locations
            self.install_trans(false);

            // erase the transaction from the log
            self.lh.n = 0;
            self.write_head();
        }
    }
}

// called at the start of each FS system call.
pub fn begin_op() {
    // totally unsafe
    // whatever, chaos is principle
    unsafe {
        LOG.lock.acquire();
        let p = &mut *myproc();
        loop {
            if LOG.committing {
                p.sleep(&LOG as *const _ as usize, &LOG.lock);
            } else if LOG.lh.n + (LOG.outstanding + 1) * MAXOPBLOCKS as u32 > LOGSIZE as u32 {
                // this op might exhaust log space; wait for commit
                p.sleep(&LOG as *const _ as usize, &LOG.lock);
            } else {
                LOG.outstanding += 1;
                LOG.lock.release();
                break;
            }
        }
    }
}

// called at the end of each FS system call.
// commits if this was the last outstanding operation
pub fn end_op() {
    let mut do_commit = false;
    unsafe {
        LOG.lock.acquire();
        LOG.outstanding -= 1;

        if LOG.committing {
            panic!("log.committing");
        }

        if LOG.outstanding == 0 {
            do_commit = true;
            LOG.committing = true;
        } else {
            // begin_op() may be waiting for log space,
            // and decrementing log.outstanding has decreased
            // the amount of reserved space.
            proc_manager.wakeup(&LOG as *const _ as usize);
        }
        LOG.lock.release();

        if do_commit {
            // call commit w/o holding locks, since not allowed
            // to sleep with locks.
            LOG.commit();
            LOG.lock.acquire();
            LOG.committing = false;
            proc_manager.wakeup(&LOG as *const _ as usize);
            LOG.lock.release();
        }
    }
}

// Caller has modified b->data and is done with the buffer.
// Record the block number and pin in the cache by increasing refcnt.
// commit()/write_log() will do the disk write.
//
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
pub fn log_write(b: &mut Buf) {
    unsafe {
        LOG.lock.acquire();
        if LOG.lh.n >= LOGSIZE as u32 || LOG.lh.n >= LOG.size - 1 {
            panic!("too big a transaction");
        }
        if LOG.outstanding < 1 {
            panic!("log_write outside of trans");
        }

        let mut i = 0;

        // log absorption
        while i < LOG.lh.n as usize {
            if LOG.lh.block[i] == b.blockno {
                break;
            }
            i += 1;
        }
        LOG.lh.block[i] = b.blockno;

        // add new block to log?
        if i == LOG.lh.n as usize {
            // pin the buffer to prevent it from writing to disk
            // unpin will be called in install_transaction
            BCACHE.bpin(b);
            LOG.lh.n += 1;
        }

        LOG.lock.release();
    }
}