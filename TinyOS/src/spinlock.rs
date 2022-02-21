use core::ptr;
use core::sync::atomic::AtomicBool;
use core::sync::atomic::Ordering;

use crate::print;
use crate::println;
use crate::riscv;
use crate::proc;

pub struct SpinLock {
    locked: AtomicBool,
    
    // For debugging
    name: &'static str,
    cpu_id: usize,
}

impl SpinLock {
    pub const fn new(name: &'static str) -> Self {
        SpinLock {
            locked: AtomicBool::new(false),
            name: name,
            cpu_id: 0,
        }
    }

    pub fn acquire(&mut self) {
        push_off();
        if self.holding() {
            panic!("acquire");
        }
        while self.locked.compare_exchange(false, true, Ordering::Acquire, Ordering::Relaxed).is_err() {}
        // i think we don't need memory fence here, since we are using acquire semantic
        self.cpu_id = proc::cpuid();
        // i didn't reset lock->cpu_id here, because we will only read cpu_id when we acquired the lock
    }

    pub fn release(&mut self) {
        if !self.holding() {
            panic!("release");
        }

        self.locked.store(false, Ordering::Release);
        pop_off();
    }

    fn holding(&self) -> bool {
        return self.locked.load(Ordering::Relaxed) && self.cpu_id == proc::cpuid();
    }
}

fn push_off() {
    let old = riscv::intr_get();
    riscv::intr_off();
    let mut cpu;
    unsafe {
        cpu = &mut *proc::mycpu();
    }
    if cpu.noff == 0 {
        cpu.intena = old;
    }
    cpu.noff += 1;
}

fn pop_off() {
    let mut cpu;
    unsafe {
        cpu = &mut *proc::mycpu();
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