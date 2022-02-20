use core::sync::atomic::AtomicPtr;

pub struct SpinLock {
    locked: bool,
    
    // For debugging
    name: &'static str,
    cpu: AtomicPtr<Cpu>,
}

impl SpinLock {
    fn acquire(&self) {

    }
}

fn push_off() {
    
}

fn pop_off() {

}