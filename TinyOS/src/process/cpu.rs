use crate::process::{proc_manager, ProcState, myproc};
use crate::{consts::param::NCPU, riscv::intr_on};
use crate::riscv::{self, intr_get};

use super::{Context, Proc};

use core::ptr;

const DEFAULT: Cpu = Cpu::new();
static mut CPUS: [Cpu; NCPU] = [DEFAULT; NCPU];

// lifetime specifier really annoys me, i will use raw pointer first
#[derive(Debug)]
pub struct Cpu {
    pub noff: u8,
    pub intena: bool,
    pub context: Context,
    pub proc: *mut Proc,
}

impl Cpu {
    const fn new() -> Cpu {
        Cpu {
            noff: 0,
            intena: false,
            context: Context::new(),
            proc: ptr::null_mut(),
        }
    }

    pub unsafe fn scheduler(&mut self) -> ! {
        extern "C" {
            fn swtch(old: *mut Context, new: *mut Context);
        }

        let mut last = 0;
        loop {
            // Avoid deadlock by ensuring that devices can interrupt.
            intr_on();
            match proc_manager.get_runnable(&mut last) {
                Some(p) => {
                    // Switch to chosen process.  It is the process's job
                    // to release its lock and then reacquire it
                    // before jumping back to us.
                    p.state = ProcState::RUNNING;
                    self.proc = p as *mut Proc;
                    // crate::println!("running {}", p.pid);
                    swtch(&mut self.context as *mut Context,
                          &mut p.context as *mut Context);
                    
                    // Process is done running for now.
                    // It should have changed it's p->state before coming back
                    self.proc = ptr::null_mut();
                    p.lock.release();
                }
                None => {},
            }
        }
    }

    // Switch to scheduler.  Must hold only p->lock
    // and have changed proc->state. Saves and restores
    // intena because intena is a property of this
    // kernel thread, not this CPU. It should
    // be proc->intena and proc->noff, but that would
    // break in the few places where a lock is held but
    // there's no process.
    pub fn sched(&mut self) {
        extern "C" {
            fn swtch(old: *mut Context, new: *mut Context);
        }

        let p = unsafe { &mut *myproc() };

        if !p.lock.holding() {
            panic!("sched p->lock");
        }

        // only hold p->lock, we ensure this property by checking noff
        if self.noff != 1 {
            panic!("sched locks");
        }

        if p.state == ProcState::RUNNING {
            panic!("sched running");
        }

        if intr_get() {
            panic!("sched interruptible");
        }

        let intena = self.intena;
        unsafe {
            swtch(&mut p.context as *mut Context, &mut self.context as *mut Context);
        }
        self.intena = intena;
    }

    // Give up the CPU for one scheduling round.
    pub fn yield_cpu(&mut self) {
        let p = unsafe { &mut *self.proc };
        p.lock.acquire();
        p.state = ProcState::RUNNABLE;
        self.sched();
        p.lock.release();
    }

    pub fn yield_proc(&mut self) {
        if !self.proc.is_null() {
            let p = unsafe { &mut *self.proc };
            p.lock.acquire();
            if p.state == ProcState::RUNNING {
                p.state = ProcState::RUNNABLE;
                self.sched();
            }
            p.lock.release();
        }

    }
}

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
pub fn cpuid() -> usize {
    return riscv::r_tp();
}

// Return this CPU's cpu struct.
// Interrupts must be disabled.
pub fn mycpu() -> *mut Cpu {
    if intr_get() {
        panic!("calling mycpu with interrupt enabled");
    }
    unsafe {
        let id = cpuid();
        return &mut CPUS[id];
    }
}