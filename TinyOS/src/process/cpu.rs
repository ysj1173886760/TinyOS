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

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
pub fn cpuid() -> usize {
    return riscv::r_tp();
}

// Return this CPU's cpu struct.
// Interrupts must be disabled.
pub fn mycpu() -> *mut Cpu {
    unsafe {
        let id = cpuid();
        return &mut CPUS[id];
    }
}