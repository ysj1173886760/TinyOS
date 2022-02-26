use core::ptr::{self, NonNull};

use crate::spinlock::SpinLock;

extern "C" {
    // first address after kernel.
    // defined by kernel.ld.
    fn end();
}

#[repr(C)]
pub struct Frame {
    next: Option<NonNull<Frame>>,
}

impl Frame {
    // convert raw addr to frame
    unsafe fn new(pa: usize) -> NonNull<Frame> {
        let frame_ptr = pa as *mut Frame;
        // construct the frame at frame_ptr
        ptr::write(frame_ptr, Frame{ next: None });
        // construct the NonullPtr pointing to the frame we previously created
        NonNull::new(frame_ptr).unwrap()
    }

    fn set(&mut self, value: Option<NonNull<Frame>>) {
        self.next = value;
    }

    fn take_next(&mut self) -> Option<NonNull<Frame>> {
        self.next
    }
}

unsafe impl Send for Frame {}

type FrameList = Frame;

static KMEM: SpinLock<FrameList> = SpinLock::new(FrameList { next: None }, "kmem");

unsafe fn free_range(start_addr: usize, end_addr: usize) {
    let start_addr = super::pg_round_up(start_addr);
    for pa in (start_addr..end_addr).step_by(super::PGSIZE) {
        kfree(pa);
    }
}

pub fn kinit() {
    crate::println!("kinit: end={:#x}", end as usize);
    unsafe {
        free_range(end as usize, crate::consts::memlayout::PHYSTOP)
    }
}

pub fn kfree(ptr: usize) {
    let mut head = KMEM.lock();
    // we need to convert frame to mutable
    unsafe {
        let mut frame: NonNull<Frame> = Frame::new(ptr);
        frame.as_mut().set(head.take_next());
        head.set(Some(frame));
    }
}

pub fn kalloc() -> Option<usize> {
    let mut head = KMEM.lock();
    let frame = head.take_next();
    if let Some(mut frame_ptr) = frame {
        unsafe {
            head.set(frame_ptr.as_mut().take_next())
        }
    }

    match frame {
        Some(frame_ptr) => Some(frame_ptr.as_ptr() as usize),
        None => None,
    }
}

pub fn kcount() -> usize {
    let head = KMEM.lock();
    let mut current = &*head;
    let mut count = 0;
    while let Some(frame) = current.next {
        count += 1;
        unsafe {
            current = frame.as_ref();
        }
    }
    count
}