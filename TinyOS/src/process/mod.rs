pub use cpu::{Cpu, cpuid, mycpu};
pub use context::Context;
pub use trapframe::TrapFrame;
pub use proc::{Proc, ProcState};

use crate::{consts::{param::NPROC, memlayout::KSTACK}, spinlock::SpinLock};

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
            unsafe {
                self.proc[i].kstack = KSTACK(i);
            }
        }
    }
}