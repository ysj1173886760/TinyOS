use crate::{mm::{KBox, PageTable, PteFlag, PGSIZE}, spinlock::SpinLock, consts::memlayout::KSTACK};
use super::{TrapFrame, Context};
use crate::consts::memlayout::TRAMPOLINE;

use crate::{consts::param::NPROC};

use core::ptr;

const DEFAULT: Proc = Proc::new();
pub static mut proc: [Proc; NPROC] = [DEFAULT; NPROC];
pub static mut pid_lock: SpinLock<usize> = SpinLock::new(0, "nextpid");

#[derive(Debug)]
pub enum ProcState {
    UNUSED,
    USED,
    SLEEPING,
    RUNNABLE,
    RUNNING,
    ZOMBIE,
}

#[derive(Debug)]
pub struct ProcData {
    pub state: ProcState,
    pub channel: usize,
    pub pid: usize,
    pub kstack: usize,
    pub sz: usize,
    pub pagetable: Option<KBox<PageTable>>,
    pub tf: *mut TrapFrame,
    pub context: Context,
    pub name: [u8; 16],
    pub killed: bool,
}

impl ProcData {
    const fn new() -> Self {
        Self {
            state: ProcState::UNUSED,
            channel: 0,
            pid: 0,
            kstack: 0,
            sz: 0,
            pagetable: None,
            tf: ptr::null_mut(),
            context: Context::new(),
            name: [0; 16],
            killed: false,
        }
    }

    // Create a user page table for a given process,
    // with no user memory, but with trampoline pages.
    pub fn create_proc_pagetable(&mut self) {
        let mut pagetable;
        match PageTable::uvm_create() {
            Some(pgtbl) => pagetable = pgtbl,
            None => {
                // TODO: should handle the err to the caller
                panic!("failed to create proc pagetable");
            }
        }

        extern "C" {
            fn trampoline();
        }

        // map the trampoline code (for system call return)
        // at the highest user virtual address.
        // only the supervisor uses it, on the way
        // to/from user space, so not PTE_U.
        pagetable.map_pages(TRAMPOLINE, PGSIZE, trampoline as usize, PteFlag::R as usize | PteFlag::X as usize);
    }
}

#[derive(Debug)]
pub struct Proc {
    pub lock: SpinLock<ProcData>,
}

impl Proc {
    pub const fn new() -> Self {
        Self {
            lock: SpinLock::new(ProcData::new(), "proc"),
        }
    }
}

// initialize the proc table at boot time.
// initialize kstack
pub fn procinit() {
    for i in 0..NPROC {
        unsafe {
            proc[i].lock.leak().kstack = KSTACK(i);
        }
    }
}