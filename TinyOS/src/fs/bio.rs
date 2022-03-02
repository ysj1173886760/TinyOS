use crate::{sleeplock::SleepLock, spinlock::SpinLock, consts::param::NBUF, driver::DISK};
use array_macro::array;
use core::ptr;
use super::BSIZE;

// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.

pub static mut BCACHE: BCache = BCache::new();

pub struct Buf {
    pub valid: bool,    // has data been read from disk
    pub disk: bool,     // does disk "own" buf?
    pub dev: u32,
    pub blockno: u32,
    pub lock: SleepLock<()>,
    pub refcnt: usize,
    // construct unsafe double-linked list
    // TODO: build a safer double-linked list (in rust style)
    pub prev: *mut Buf,
    pub next: *mut Buf,
    pub data: [u8; BSIZE],
    // only data is protected by sleeplock
    // other metadata is protected by bcache.lock
}

pub struct BCache {
    lock: SpinLock<()>,
    buf: [Buf; NBUF],
    head: Buf,
}

// we guarantee here that we will will lock to ensure thread-safety
unsafe impl Sync for BCache {}

impl BCache {
    const fn new() -> Self {
        Self {
            lock: SpinLock::new((), "bcache"),
            buf: array![_ => Buf::new(); NBUF],
            head: Buf::new(),
        }
    }

    pub fn binit(&mut self) {
        self.head.prev = &mut self.head as *mut Buf;
        self.head.next = &mut self.head as *mut Buf;

        // create linked list of buffers
        for i in 0..NBUF {
            self.buf[i].next = self.head.next;
            self.buf[i].prev = &mut self.head as *mut Buf;

            let b = unsafe { &mut *self.head.next };
            b.prev = &mut self.buf[i] as *mut Buf;
            self.head.next = &mut self.buf[i] as *mut Buf;
        }
    }

    // Look through buffer cache for block on device dev.
    // If not found, allocate a buffer.
    // In either case, return locked buffer.
    pub fn bget(&mut self, dev: u32, blockno: u32) -> &mut Buf {
        self.lock.acquire();

        // is the block already cached?
        let mut cur = self.head.next;
        while cur != &mut self.head as *mut Buf {
            let b = unsafe { &mut *cur };
            if b.dev == dev && b.blockno == blockno {
                b.refcnt += 1;
                self.lock.release();
                b.lock.acquire();
                return b;
            }
            cur = b.next;
        }
        
        // Not cached
        // Recycle the least recently used buffer
        let mut cur = self.head.next;
        while cur != &mut self.head as *mut Buf {
            let b = unsafe { &mut *cur };
            if b.refcnt == 0 {
                b.dev = dev;
                b.blockno = blockno;
                b.valid = false;
                b.refcnt = 1;
                self.lock.release();
                b.lock.acquire();
                return b;
            }
            cur = b.next;
        }

        panic!("bget: no buffers");
    }

    // Return a locked buf with the contents of the indicated block
    pub fn bread(&mut self, dev: u32, blockno: u32) -> &mut Buf {
        let b = self.bget(dev, blockno);
        if !b.valid {
            unsafe {
                DISK.rw(b, false);
            }
            b.valid = true;
        }

        return b;
    }

    // release a locked buffer
    // move to the head of the most recently used list
    pub fn brelse(&mut self, buf: &mut Buf) {
        if !buf.lock.holding() {
            panic!("brelse");
        }

        buf.lock.release();
        self.lock.acquire();

        buf.refcnt -= 1;
        if buf.refcnt == 0 {
            // no one is waiting for it
            let prev = unsafe { &mut *buf.next };
            let next = unsafe { &mut *buf.prev };
            next.prev = buf.prev;
            prev.next = buf.next;

            buf.next = self.head.next;
            buf.prev = &mut self.head as *mut Buf;
            
            let next = unsafe { &mut *self.head.next };
            next.prev = buf as *mut Buf;
            self.head.next = buf as *mut Buf;
        }

        self.lock.release();
    }

    pub fn bpin(&mut self, buf: &mut Buf) {
        self.lock.acquire();
        buf.refcnt += 1;
        self.lock.release();
    }
    
    pub fn bunpin(&mut self, buf: &mut Buf) {
        self.lock.acquire();
        buf.refcnt -= 1;
        self.lock.release();
    }
}

impl Buf {
    const fn new() -> Self {
        Self {
            valid: false,
            disk: false,
            dev: 0,
            blockno: 0,
            lock: SleepLock::new((), "buf"),
            refcnt: 0,
            prev: ptr::null_mut(),
            next: ptr::null_mut(),
            data: [0; BSIZE],
        }
    }

    // write b's contents to disk. Must be locked
    pub fn bwrite(&mut self) {
        if !self.lock.holding() {
            panic!("bwrite");
        }

        unsafe {
            DISK.rw(self, true);
        }
    }
}