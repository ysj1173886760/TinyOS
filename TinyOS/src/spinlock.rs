use core::ptr;
use core::sync::atomic::AtomicBool;
use core::sync::atomic::Ordering;

use crate::riscv;
use crate::proc;

pub struct SpinLock {
    locked: AtomicBool,
    
    // For debugging
    name: &'static str,
    cpu: *mut proc::Cpu,
}

impl SpinLock {
    fn new(name: &'static str) -> Self {
        SpinLock {
            locked: AtomicBool::new(false),
            name: name,
            cpu: ptr::null_mut(),
        }
    }

    fn acquire(&mut self) {
        push_off();
        if self.holding() {
            panic!("acquire");
        }
        while self.locked.compare_exchange(false, true, Ordering::Acquire, Ordering::Relaxed).is_err() {}
        // i think we don't need memory fence here, since we are using acquire semantic
        self.cpu = proc::mycpu();
    }

    fn release(&mut self) {
        if !self.holding() {
            panic!("release");
        }

        self.cpu = ptr::null_mut();
        self.locked.store(false, Ordering::Release);
        pop_off();
    }

    fn holding(&self) -> bool {
        return self.locked.load(Ordering::Relaxed) && self.cpu == proc::mycpu();
    }
}

fn push_off() {
    let old = riscv::intr_get();
    riscv::intr_off();
    let mut cpu;
    unsafe {
        cpu = *proc::mycpu();
    }
    if cpu.noff == 0 {
        cpu.intena = old;
    }
    cpu.noff += 1;
}

fn pop_off() {
    let mut cpu;
    unsafe {
        cpu = *proc::mycpu();
    }
    
    // we shouldn't turn on interrupt until noff is 0
    if riscv::intr_get() {
        panic!("pop_off - interruptible");
    }

    if cpu.noff < 1 {
        panic!("pop_off")
    }

    cpu.noff -= 1;
    if cpu.noff == 0 && cpu.intena {
        riscv::intr_on();
    }
}