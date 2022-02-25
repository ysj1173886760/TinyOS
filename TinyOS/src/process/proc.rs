use crate::mm::{KBox, PageTable};
use super::{TrapFrame, Context};

use core::ptr;

pub enum ProcState {
    UNUSED,
    USED,
    SLEEPING,
    RUNNABLE,
    RUNNING,
    ZOMBIE,
}

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
        }
    }

    // Create a user page table for a given process,
    // with no user memory, but with trampoline pages.
    pub fn create_proc_pagetable(&mut self) {
        

    }
}