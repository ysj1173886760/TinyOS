// use core::ptr::{self, NonNull};

// use crate::spinlock::SpinLock;

// // indicate that the page is aligned to 4096
// pub trait PageAligned {}

// extern "C" {
//     // first address after kernel.
//     // defined by kernel.ld.
//     fn end();
// }

// #[repr(C)]
// pub struct Frame {
//     next: Option<NonNull<Frame>>,
// }

// // indicate that our frame is always page-aligned
// impl PageAligned for Frame{}

// impl Frame {
//     // convert raw addr to frame
//     unsafe fn new(pa: usize) -> NonNull<Frame> {
//         let frame_ptr = pa as *mut Frame;
//         // construct the frame at frame_ptr
//         ptr::write(frame_ptr, Frame{ next: None });
//         // construct the NonullPtr pointing to the frame we previously created
//         NonNull::new(frame_ptr).unwrap()
//     }

//     fn set(&mut self, value: Option<NonNull<Frame>>) {
//         self.next = value;
//     }

//     fn take_next(&mut self) -> Option<NonNull<Frame>> {
//         self.next
//     }
// }

// unsafe impl Send for Frame {}

// unsafe impl Sync for Frame {}

// type FrameList = Frame;

// struct Kmem {
//     lock: SpinLock,
//     frameList: FrameList,
// }

// static KMEM: Kmem = Kmem {
//     lock: SpinLock::new("kmem"),
//     frameList: FrameList { next: None }
// };

// unsafe fn free_range(start_addr: usize, end_addr: usize) {
//     let start = super::pg_round_up(start_addr);
//     for pa in (start_addr..end_addr).step_by(super::PGSIZE) {
//         kfree(Frame::new(pa));
//     }
// }

// pub fn kinit() {
//     crate::println!("kinit: end={:#x}", end as usize);
//     unsafe {
//         free_range(end as usize, crate::consts::memlayout::PHYSTOP)
//     }
// }

// pub fn kfree(frame: NonNull<Frame>) {
//     KMEM.lock.acquire();
//     unsafe {
//         frame.as_mut().set(KMEM.frameList.take_next());
//     }
//     KMEM.frameList.set(Some(frame));
//     KMEM.lock.release();
// }

// pub fn kalloc() -> Option<NonNull<Frame>> {
    // KMEM.lock.acquire();
    // let frame = KMEM.frameList.take_next();
    // if let Some(mut frame_ptr) = frame {
    //     unsafe {
    //         KMEM.frameList.set(frame_ptr.as_mut().take_next())
    //     }
    // }

    // KMEM.lock.release();

    // match frame {
    //     Some(frame_ptr) => Some(frame_ptr),
    //     None => None,
    // }
// }