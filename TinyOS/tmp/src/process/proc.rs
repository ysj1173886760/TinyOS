use array_macro::array;

use crate::{mm::{KBox, PageTable, PteFlag, PGSIZE, kalloc, uvm_free, kfree}, spinlock::SpinLock, fs::{Inode, namei, File, FTABLE, begin_op, ITABLE, end_op}, consts::param::NOFILE};
use super::{TrapFrame, Context, fork_ret, proc_manager, mycpu, wait_lock};
use crate::consts::memlayout::{TRAMPOLINE, TRAPFRAME};

use core::ptr;

#[derive(PartialEq, Eq, Debug)]
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
    pub xstate: i32,    // exit status to be returned to parent's wait

    // wait_lock must be held when using this:
    pub parent: *mut Proc,
    // struct proc *parent

    // these are private to the process, so p->lock need not be held
    pub kstack: usize,
    pub sz: usize,
    pub pagetable: Option<KBox<PageTable>>,
    pub trapframe: *mut TrapFrame,
    pub context: Context,
    pub name: [u8; 16],
    // because our Inode stays in Itable
    // which is a static variable
    pub cwd: *mut Inode,
    // Open files
    // i really don't want to use lifetime specifier here
    // so use raw pointer directly
    pub ofile: [*mut File; NOFILE],
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
            cwd: ptr::null_mut(),
            ofile: array![_ => core::ptr::null_mut(); NOFILE],
            parent: ptr::null_mut(),
            xstate: 0,
        }
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
        self.name = [0; 16];
        self.channel = 0;
        self.killed = false;
        self.state = ProcState::UNUSED;
        self.xstate = 0;
        self.parent = ptr::null_mut();
        self.channel = 0;
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

        let cwd = b"/\0";
        self.cwd = namei(cwd).unwrap() as *mut Inode;

        self.state = ProcState::RUNNABLE;
    }

    // Exit the current process.  Does not return.
    // An exited process remains in the zombie state
    // until its parent calls wait().
    pub fn exit(&mut self, status: i32) {
        if unsafe { proc_manager.is_init_proc(&self) } {
            panic!("init exiting");
        }

        // close all open files
        for fd in 0..NOFILE {
            if !self.ofile[fd].is_null() {
                let f = unsafe { &mut *self.ofile[fd] };
                unsafe { FTABLE.fileclose(f) };
                self.ofile[fd] = ptr::null_mut();
            }
        }

        // free the reference to cwd
        begin_op();
        let cwd = unsafe { &mut *self.cwd };
        unsafe { ITABLE.iput(cwd) };
        end_op();
        self.cwd = ptr::null_mut();

        wait_lock.acquire();

        // give any children to init
        unsafe { proc_manager.reparent(self as *mut Proc) };
        
        // Parent might be sleeping in wait
        unsafe { proc_manager.wakeup(self.parent as usize) };

        self.lock.acquire();

        self.xstate = status;
        self.state = ProcState::ZOMBIE;

        wait_lock.release();

        // Jump into the scheduler, never to return
        let c = unsafe { &mut *mycpu() };
        c.sched();

        panic!("zombie exit");
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

    // Grow or shrink user memory by n bytes
    // Return 0 on Success, -1 on failure
    pub fn growproc(&mut self, n: i32) -> bool {
        let mut sz = self.sz;
        if n > 0 {
            sz = self.pagetable.as_mut().unwrap().uvm_alloc(sz, sz + n as usize);
            if sz == 0 {
                return false;
            }
        } else if n < 0 {
            let new_sz = n as i64 + (sz as i64);
            if new_sz < 0 {
                return false;
            }
            sz = self.pagetable.as_mut().unwrap().uvm_dealloc(sz, new_sz as usize);
        }

        self.sz = sz;
        true
    }

    // Allocate a file descriptor for the gived file
    // Takes over file reference from caller on success
    pub fn fdalloc(&mut self, f: &mut File) -> Result<usize, &'static str> {
        for fd in 0..NOFILE {
            if self.ofile[fd].is_null() {
                self.ofile[fd] = f as *mut File;
                return Ok(fd);
            }
        }

        Err("failed to allocate fd")
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