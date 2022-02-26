use core::ptr::null_mut;

pub use cpu::{Cpu, cpuid, mycpu};
pub use context::Context;
pub use trapframe::TrapFrame;
pub use proc::{Proc, ProcState};

use crate::{consts::{param::NPROC, memlayout::KSTACK}, spinlock::{SpinLock, push_off, pop_off}, mm::kfree};

mod proc;
mod cpu;
mod context;
mod trapframe;

pub static mut proc_manager: ProcManager = ProcManager::new();

pub struct ProcManager {
    proc: [Proc; NPROC],
    pid_lock: SpinLock<usize>,
}

const DEFAULT: Proc = Proc::new();

impl ProcManager {
    const fn new() -> Self {
        Self {
            proc: [DEFAULT; NPROC],
            pid_lock: SpinLock::new(0, "nextpid"),
        }
    }

    // initialize kstack
    pub fn proc_init(&mut self) {
        for i in 0..NPROC {
            self.proc[i].kstack = KSTACK(i);
        }
    }

    pub fn allocpid(&self) -> usize {
        let mut pid = 0;

        let mut r = self.pid_lock.lock();
        pid = *r;
        *r += 1;

        pid
    }

    // Look in the process table for an UNUSED proc.
    // If found, initialize state required to run in the kernel,
    // and return with p->lock held.
    // If there are no free procs, or a memory allocation fails, return 0.
    pub fn allocproc(&mut self) -> Option<&mut Proc> {
        for i in 0..NPROC {
            let p = &mut self.proc[i];
            
            // because we are returning the p with p->lock held, so we cann't use spinlock guard here
            // maybe we can transfer the ownership of lock
            p.lock.acquire();
            match p.state {
                ProcState::UNUSED => {
                    // initialize the state

                    // this is intentionally written code.
                    // because rust cann't detect that we won't have the mutable reference across the loop
                    // it though that we have borrowed p with lifetime as long as self
                    // a simple way to bypass this is return &mut self.proc[i] instead return p
                    // thus p won't have such long lifetime across loop, and we won't met compile error
                    // but another problem is we are allocating pid then assign it, which the compiler think we may have use after free problem
                    // so we need to take the reference again
                    let pid = self.allocpid();
                    let p = &mut self.proc[i];
                    p.pid = pid;
                    p.state = ProcState::USED;
                    
                    // allocate a trapframe page
                    if p.alloc_trapframe() != Ok(()) {
                        p.free();
                        p.lock.release();
                        return None;
                    }

                    // An empty user page table
                    if p.create_proc_pagetable() != Ok(()) {
                        p.free();
                        p.lock.release();
                        return None;
                    }

                    // set up new context to start executing at forkret,
                    // which returns to user space
                    p.init_context();

                    return Some(p);
                }
                _ => {}
            }
            p.lock.release();
        }
        None
    }

    pub fn user_init(&mut self) {
        let p = self.allocproc().expect("failed to alloc first process");

    }

    // find a runnable process
    // used in scheduler
    // return with p->lock held
    pub fn get_runnable(&mut self) -> Option<&mut Proc> {
        for i in 0..self.proc.len() {
            let p = &mut self.proc[i];
            p.lock.acquire();
            match p.state {
                ProcState::RUNNABLE => {
                    return Some(&mut self.proc[i]);
                },
                _ => {},
            }
            p.lock.release();
        }

        None
    }

}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
fn fork_ret() {
    static mut first: bool = true;

    // Still holding p->lock from scheduler.
    // release lock here
    let p = unsafe { & *myproc() };
    p.lock.release();

    unsafe {
        if first {
            // File system initialization must be run in the context of a
            // regular process (e.g., because it calls sleep), and thus cannot
            // be run from main().
            first = false;
        }
    }

    // user_trap_ret();
}

// Return the current struct proc *, or zero if none.
pub fn myproc() -> *mut Proc {
    unsafe {
        push_off();
        let cpu = mycpu();
        let proc = (*cpu).proc;
        pop_off();
        return proc;
    }
}