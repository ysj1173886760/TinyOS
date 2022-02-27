use crate::{mm::{KBox, PageTable, PteFlag, PGSIZE, kalloc, uvm_free, kfree}, spinlock::SpinLock};
use super::{TrapFrame, Context, fork_ret, proc_manager, mycpu};
use crate::consts::memlayout::{TRAMPOLINE, TRAPFRAME};

use core::ptr;

#[derive(PartialEq, Eq)]
pub enum ProcState {
    UNUSED,
    USED,
    SLEEPING,
    RUNNABLE,
    RUNNING,
    ZOMBIE,
}

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
        self.context.set_ra(fork_ret as usize); 
        self.context.set_sp(self.kstack + PGSIZE);
    }

    // Free a process's page table, and free the
    // physical memory it refers to.
    pub fn free_pagetable(&mut self) {
        let pagetable = self.pagetable.take();
        match pagetable {
            Some(mut pgtbl) => {
                pgtbl.uvm_unmap(TRAMPOLINE, 1, false);
                pgtbl.uvm_unmap(TRAPFRAME, 1, false);
                uvm_free(pgtbl.into_raw(), self.sz);
            },
            None => {},
        }
    }

    // free a proc structure and the data hanging from it,
    // including user pages.
    // p->lock must be held.
    pub fn free(&mut self) {
        if !self.trapframe.is_null() {
            kfree(self.trapframe as usize);
            self.trapframe = ptr::null_mut();
        }

        self.free_pagetable();

        self.sz = 0;
        self.pid = 0;
        self.name[0] = 0;
        self.channel = 0;
        self.killed = false;
        self.state = ProcState::UNUSED;
    }

    // Set up first user process.
    pub fn user_init(&mut self) {
        // allocate one user page and copy init's instructions
        // and data into it.
        self.pagetable.as_mut().unwrap().uvminit(&INITCODE);
        self.sz = PGSIZE;

        // prepare for the very first return from kernel
        let trapframe = unsafe {&mut *self.trapframe};
        trapframe.epc = 0;      // user program counter
        trapframe.sp = PGSIZE;  // user stack pointer

        let init_name = b"initcode\0";
        unsafe {
            ptr::copy_nonoverlapping(init_name.as_ptr(), self.name.as_mut_ptr(), init_name.len());
        }

        //TODO: set current working directory

        self.state = ProcState::RUNNABLE;
    }

    pub fn exit(&mut self, status: i32) {
        if unsafe { proc_manager.is_init_proc(&self) } {
            panic!("init exiting");
        }

        panic!("todo exit");
    }

    pub fn check_exit(&mut self, status: i32) {
        if self.killed {
            self.exit(status);
        }
    }

    // Atomically release lock and sleep on chan.
    // Reacquires lock when awakened.
    pub fn sleep<T>(&mut self, channel: usize, lock: &SpinLock<T>) {
        // Must acquire p->lock in order to
        // change p->state and then call sched.
        // Once we hold p->lock, we can be
        // guaranteed that we won't miss any wakeup
        // (wakeup locks p->lock),
        // so it's okay to release lk.

        self.lock.acquire();
        lock.release();

        // Go to sleep
        self.channel = channel;
        self.state = ProcState::SLEEPING;

        // we are holding the lock when calling mycpu
        let cpu = unsafe { &mut *mycpu() };
        cpu.sched();

        // Tidy up
        self.channel = 0;

        // reacquire the original lock
        self.lock.release();
        lock.acquire();
    }
}

static INITCODE: [u8; 51] = [
    0x17, 0x05, 0x00, 0x00, 0x13, 0x05, 0x05, 0x02,
    0x97, 0x05, 0x00, 0x00, 0x93, 0x85, 0x05, 0x02,
    0x9d, 0x48, 0x73, 0x00, 0x00, 0x00, 0x89, 0x48,
    0x73, 0x00, 0x00, 0x00, 0xef, 0xf0, 0xbf, 0xff,
    0x2f, 0x69, 0x6e, 0x69, 0x74, 0x00, 0x00, 0x01,
    0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00   
];