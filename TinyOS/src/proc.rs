use crate::consts::param::NCPU;
use crate::riscv;
use core::sync::atomic::AtomicPtr;

static mut CPUS: [Cpu; NCPU] = [Cpu::new(); NCPU];

#[derive(Copy, Clone)]
pub struct Cpu {
    noff: u8,
    intena: bool,
}

impl Cpu {
    const fn new() -> Cpu {
        Cpu {
            noff: 0,
            intena: false,
        }
    }
}

pub unsafe fn cpuid() -> usize {
    return riscv::r_tp();
}

pub fn mycpu() -> AtomicPtr<Cpu> {
    unsafe {
        let id = cpuid();
        return AtomicPtr::new(&mut CPUS[id]);
    }
}