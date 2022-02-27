use core::cell::{Cell, UnsafeCell};

use crate::{spinlock::SpinLock, process::{myproc, proc_manager}};


// Long-term locks for processes
pub struct SleepLock<T> {
    lock: SpinLock<()>,
    locked: Cell<bool>,
    data: UnsafeCell<T>,

    // For debugging
    name: &'static str, // name of lock
    pid: Cell<usize>,         // process holding lock
}

unsafe impl<T: Send> Sync for SleepLock<T> {}

impl<T> SleepLock<T> {
    pub const fn new(data: T, name: &'static str) -> Self {
        Self {
            lock: SpinLock::new((), "sleeplock"),
            locked: Cell::new(false),
            name,
            data: UnsafeCell::new(data),
            pid: Cell::new(0),
        }
    }

    pub fn holding(&self) -> bool {
        let l = self.lock.lock();
        let p = unsafe { &mut *myproc() };
        return self.locked.get() && p.pid == self.pid.get();
    }

    pub fn acquire(&self) {
        self.lock.acquire();

        let p = unsafe { &mut *myproc() };
        while self.locked.get() {
            p.sleep(self.locked.as_ptr() as usize, &self.lock)
        }

        self.locked.set(true);
        self.pid.set(p.pid);

        self.lock.release();
    }

    pub fn release(&self) {
        self.lock.acquire();

        self.locked.set(false);
        self.pid.set(0);

        unsafe {
            proc_manager.wakeup(self.locked.as_ptr() as usize);
        }
        
        self.lock.release();
    }
}