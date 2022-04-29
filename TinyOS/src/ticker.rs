use crate::{spinlock::SpinLock, process::{proc_manager, myproc}};

pub struct Ticker {
    ticks: usize,
    lock: SpinLock<()>,
}

pub static mut ticker: Ticker = Ticker::new();

impl Ticker {
    const fn new() -> Self {
        Self {
            ticks: 0,
            lock: SpinLock::new((), "time"),
        }
    }

    pub unsafe fn tick(&mut self) {
        let guard = self.lock.lock();
        self.ticks += 1;
        proc_manager.wakeup(&self as *const _ as usize);
    }

    pub unsafe fn sleep(&mut self, n: usize) -> Result<(), &'static str> {
        self.lock.acquire();

        let ticks0 = self.ticks;

        while self.ticks - ticks0 < n {
            let p = &mut *myproc();
            if p.killed {
                self.lock.release();
                return Err("process is dead");
            }

            // wait for next tick
            // why don't we just wait for the tick number
            // because tick number might be very large
            // thus process might sleep forever
            p.sleep(&self as *const _ as usize, &self.lock);
        }

        self.lock.release();
        Ok(())
    }

    pub fn uptime(&self) -> Result<usize, &'static str> {
        let guard = self.lock.lock();
        return Ok(self.ticks);
    }
}