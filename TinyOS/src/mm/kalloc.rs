use core::ptr::{self, NonNull};

// indicate that the page is aligned to 4096
pub trait PageAligned {}

extern "C" {
    // first address after kernel.
    // defined by virt.lds.
    pub static mut end: [u8; 0];
}

#[repr(C)]
struct Frame {
    next: Option<NonNull<Frame>>,
}

// indicate that our frame is always page-aligned
impl PageAligned for Frame{}

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
