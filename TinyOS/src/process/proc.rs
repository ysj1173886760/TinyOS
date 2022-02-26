use crate::{mm::{KBox, PageTable, PteFlag, PGSIZE, kalloc}, spinlock::SpinLock};
use super::{TrapFrame, Context};
use crate::consts::memlayout::{TRAMPOLINE, TRAPFRAME};

use core::ptr;

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
pub struct Proc {
    pub lock: SpinLock<()>,

    // p->lock must be held when using these:
    pub state: ProcState,
    pub channel: usize,
    pub pid: usize,
    pub killed: bool,

    // wait_lock must be held when using this:
    // struct proc *parent

    // these are private to the process, so p->lock need not be held
    pub kstack: usize,
    pub sz: usize,
    pub pagetable: Option<KBox<PageTable>>,
    pub trapframe: *mut TrapFrame,
    pub context: Context,
    pub name: [u8; 16],
}

impl Proc {
    pub const fn new() -> Self {
        Self {
            lock: SpinLock::new((), "proc"),
            state: ProcState::UNUSED,
            channel: 0,
            pid: 0,
            kstack: 0,
            sz: 0,
            pagetable: None,
            trapframe: ptr::null_mut(),
            context: Context::new(),
            name: [0; 16],
            killed: false,
        }
    }

    // Create a user page table for a given process,
    // with no user memory, but with trampoline pages.
    pub fn create_proc_pagetable(&mut self) -> Result<(), &'static str> {
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

        //TODO: handle the failure and free the memory
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
                            self.trapframe as usize, 
                            PteFlag::R as usize | PteFlag::W as usize)
                            .expect("failed to map trapframe");
        
        self.pagetable = Some(pagetable);
        Ok(())
    }

    pub fn alloc_trapframe(&mut self) -> Result<(), &'static str> {
        match kalloc() {
            Some(ptr) => {
                self.trapframe = ptr as *mut TrapFrame;
                Ok(())
            },
            None => {
                Err("failed to alloc trapframe")
            }
        }
    }

    pub fn init_context(&mut self) {
        self.context.clear();
        // TODO: add forkret
        // self.context.ra = forkret
        self.context.set_sp(self.kstack + PGSIZE);
    }
}
