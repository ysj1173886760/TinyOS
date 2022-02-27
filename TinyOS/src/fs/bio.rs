use crate::sleeplock::SleepLock;
use core::ptr;

pub const BSIZE: usize = 1024;

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
}

impl Buf {
    fn new() -> Self {
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
}