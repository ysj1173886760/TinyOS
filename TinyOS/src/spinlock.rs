use core::cell::{UnsafeCell, Cell};
use core::sync::atomic::AtomicBool;
use core::sync::atomic::Ordering;
use core::sync::atomic::fence;
use core::ops::{Deref, DerefMut, Drop};

use crate::{riscv, backtrace};
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

// the reason we have to turn off interrupt in SpinLock is that
// this is short time lock, we should release it as sonn as we quit the 
// critical section. And we don't want to get interrupted by timer which 
// will cause the situation where we will hold the short time lock for
// a long time.
// another reason is the holding the lock should be the semantic of process
// instead of cpu, but we are storing the related information in CPU structure
// the only way to achieve both of above requirement is don't switch process
// while holding spinlock. So we should turn off the interrupts here

// essentially here what it means is only when data protected by lock can safely move ownership though thread,
// can the lock shared between threads. whoever successfully acquire the lock will have the ownership of data
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
            crate::println!("{}", self.name);
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

#[no_mangle]
pub fn alarm() {
    crate::println!("here");
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