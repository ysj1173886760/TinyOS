use core::sync::atomic::AtomicPtr;
use core::ptr;
pub struct SpinLock {
    locked: bool,
    
    // For debugging
    name: &'static str,
    cpu: AtomicPtr<Cpu>,
}

impl SpinLock {
    fn new(name: &'static str) -> Self {
        SpinLock {
            locked: false,
            name: name,
            cpu: AtomicPtr::new(ptr::null_mut()),
        }
    }

    fn acquire(&self) {

    }
    fn release(&self) {

    }
    fn holding(&self) -> bool {
        return self.locked && self.cpu == mycpu();
    }
}

fn push_off() {

}

fn pop_off() {

}