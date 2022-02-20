use crate::consts::param::NCPU;
use crate::riscv;

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

pub unsafe fn cpu_id() -> usize {
    return riscv::r_tp();
}