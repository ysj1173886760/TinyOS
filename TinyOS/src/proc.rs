use crate::consts::param::NCPU;
use crate::riscv;

static mut CPUS: [Cpu; NCPU] = [Cpu::new(); NCPU];

#[derive(Copy, Clone)]
pub struct Cpu {
    pub noff: u8,
    pub intena: bool,
}

impl Cpu {
    const fn new() -> Cpu {
        Cpu {
            noff: 0,
            intena: false,
        }
    }
}

pub fn cpuid() -> usize {
    return riscv::r_tp();
}

pub fn mycpu() -> *mut Cpu {
    unsafe {
        let id = cpuid();
        return &mut CPUS[id];
    }
}