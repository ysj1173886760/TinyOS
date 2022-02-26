use core::cell::{UnsafeCell, Cell};
use core::sync::atomic::AtomicBool;
use core::sync::atomic::Ordering;
use core::sync::atomic::fence;
use core::ops::{Deref, DerefMut, Drop};

use crate::riscv;
use crate::process::{cpuid, mycpu};

#[derive(Debug)]
pub struct SpinLock<T> {
    locked: AtomicBool,
    data: UnsafeCell<T>,
    
    // For debugging
    name: &'static str,
    // we need interior mutability here
    cpu_id: Cell<isize>,
}

unsafe impl<T: Send> Sync for SpinLock<T> {}

impl<T> SpinLock<T> {
    pub const fn new(data: T, name: &'static str) -> SpinLock<T> {
        SpinLock {
            locked: AtomicBool::new(false),
            name: name,
            cpu_id: Cell::new(-1),
            data: UnsafeCell::new(data),
        }
    }
}

impl<T> SpinLock<T> {
    pub fn holding(&self) -> bool {
        return self.locked.load(Ordering::Relaxed) && self.cpu_id.get() == cpuid() as isize;
    }

    pub fn acquire(&self) {
        push_off();
        if self.holding() {
            panic!("acquire");
        }
        while self.locked.compare_exchange(false, true, Ordering::Acquire, Ordering::Relaxed).is_err() {}

        // use memory fence anyway
        fence(Ordering::SeqCst);

        self.cpu_id.set(cpuid() as isize);
        // i didn't reset lock->cpu_id here, because we will only read cpu_id when we acquired the lock
    }

    pub fn release(&self) {
        if !self.holding() {
            panic!("release");
        }

        // exactly xv6 order here
        self.cpu_id.set(-1);
        fence(Ordering::SeqCst);
        self.locked.store(false, Ordering::Release);
        pop_off();
    }

    pub fn lock(&self) -> SpinLockGuard<T> {
        self.acquire();
        SpinLockGuard {
            spinlock: &self,
            data: unsafe { &mut *self.data.get() }
        }
    }

    // leak the data, only when we guarantee the resource will be accessed by single thread can we use this
    pub fn leak(&self) -> &mut T {
        unsafe { &mut *self.data.get() }
    }
}

pub struct SpinLockGuard<'a, T: 'a> {
    spinlock: &'a SpinLock<T>,
    data: &'a mut T,
}

impl<'a, T> Deref for SpinLockGuard<'a, T> {
    type Target = T;
    fn deref(&self) -> &T {
        &*self.data
    }
}

impl<'a, T> DerefMut for SpinLockGuard<'a, T> {
    fn deref_mut(&mut self) -> &mut T {
        &mut *self.data
    }
}

impl<'a, T> Drop for SpinLockGuard<'a, T> {
    fn drop(&mut self) {
        self.spinlock.release();
    }
}

pub fn push_off() {
    let old = riscv::intr_get();
    riscv::intr_off();
    let mut cpu;
    unsafe {
        cpu = &mut *mycpu();
    }
    if cpu.noff == 0 {
        cpu.intena = old;
    }
    cpu.noff += 1;
}

pub fn pop_off() {
    let mut cpu;
    unsafe {
        cpu = &mut *mycpu();
    }
    
    // we shouldn't turn on interrupt until noff is 0
    if riscv::intr_get() {
        panic!("pop_off - interruptible");
    }

    if cpu.noff < 1 {
        panic!("pop_off")
    }

    cpu.noff -= 1;
    if cpu.noff == 0 && cpu.intena {
        riscv::intr_on();
    }
}