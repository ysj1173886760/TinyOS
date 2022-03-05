use core::ptr::null_mut;
use core::ptr;

pub use cpu::{Cpu, cpuid, mycpu};
pub use context::Context;
pub use trapframe::TrapFrame;
pub use proc::{Proc, ProcState};

use crate::{consts::{param::{NPROC, ROOTDEV}, memlayout::{KSTACK, TRAMPOLINE, TRAPFRAME}}, spinlock::{SpinLock, push_off, pop_off}, mm::{kfree, PageTable, KBox, PGSIZE, PteFlag}, trap::usertrapret, driver::DISK, fs::fsinit};

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
                    if let Ok(pagetable) = create_proc_pagetable(p) {
                        p.pagetable = Some(pagetable);
                    } else {
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
        p.user_init();
        p.state = ProcState::RUNNABLE;
        p.lock.release();
    }

    // find a runnable process
    // used in scheduler
    // return with p->lock held
    pub fn get_runnable(&mut self, last: &mut usize) -> Option<&mut Proc> {
        // search a round
        for i in 0..self.proc.len() {
            let cur = (*last + i) % self.proc.len();
            let p = &mut self.proc[cur];
            p.lock.acquire();
            match p.state {
                ProcState::RUNNABLE => {
                    // update last
                    *last = (cur + 1) % self.proc.len();
                    return Some(&mut self.proc[cur]);
                },
                _ => {},
            }
            p.lock.release();
        }

        // reset last
        *last = 0;
        None
    }

    // check if the process is the init_proc
    fn is_init_proc(&self, p: &Proc) -> bool {
        ptr::eq(&self.proc[0], p)
    }

    // Wake up all processes sleeping on chan.
    // Must be called without any p->lock.
    // FIXME: should we check whether the process is current process
    pub fn wakeup(&mut self, channel: usize) {
        for p in self.proc.iter_mut() {
            let guard = p.lock.lock();
            if p.state == ProcState::SLEEPING && p.channel == channel {
                p.state = ProcState::RUNNABLE;
            }
            drop(guard);
        }
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
            fsinit(ROOTDEV);
            first = false;
        }
    }

    usertrapret();
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

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
pub fn either_copyout(user_dst: bool, dst: usize, src: *const u8, len: usize)
    -> Result<(), &'static str> {
    let p = unsafe { &mut *myproc() };
    if user_dst {
        return p.pagetable
            .as_mut()
            .expect("failed to find pagetable")
            .copyout(dst, src, len);
    } else {
        unsafe {
            core::ptr::copy(
                src,
                dst as *mut u8,
                len
            );
        }
        return Ok(());
    }
}

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
pub fn either_copyin(dst: *mut u8, user_src: bool, src: usize, len: usize)
    -> Result<(), &'static str> {
    let p = unsafe { &mut *myproc() };
    if user_src {
        return p.pagetable
            .as_mut()
            .expect("failed to find pagetable")
            .copyin(dst, src, len);
    } else {
        unsafe {
            core::ptr::copy(
                src as *const u8,
                dst,
                len
            );
        }
        return Ok(());
    }
}

// Create a user page table for a given process,
// with no user memory, but with trampoline pages.
pub fn create_proc_pagetable(p: &Proc) -> Result<KBox<PageTable>, &'static str> {
    let mut pagetable;
    match PageTable::uvm_create() {
        Some(pgtbl) => pagetable = pgtbl,
        None => {
            return Err("failed to allocate new pagetable");
        }
    }

    extern "C" {
        fn trampoline();
    }

    // map the trampoline code (for system call return)
    // at the highest user virtual address.
    // only the supervisor uses it, on the way
    // to/from user space, so not PTE_U.
    pagetable.map_pages( TRAMPOLINE,
                        PGSIZE, 
                        trampoline as usize, 
                        PteFlag::R as usize | PteFlag::X as usize)
                        .expect("failed to map trampoline");

    // map the trapframe just below TRAMPOLINE, for trampoline.S.
    pagetable.map_pages(TRAPFRAME, 
                        PGSIZE, 
                        p.trapframe as usize, 
                        PteFlag::R as usize | PteFlag::W as usize)
                        .expect("failed to map trapframe");
    
    Ok(pagetable)
}
