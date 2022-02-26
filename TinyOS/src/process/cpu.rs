use crate::consts::param::NCPU;
use crate::riscv;

use super::{Context, Proc};

use core::ptr;

const DEFAULT: Cpu = Cpu::new();
static mut CPUS: [Cpu; NCPU] = [DEFAULT; NCPU];

// lifetime specifier really annoys me, i will use raw pointer first
pub struct Cpu {
    pub noff: u8,
    pub intena: bool,
    pub context: Context,
    pub proc: *mut Proc,
}

impl Cpu {
    const fn new() -> Cpu {
        Cpu {
            noff: 0,
            intena: false,
            context: Context::new(),
            proc: ptr::null_mut(),
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