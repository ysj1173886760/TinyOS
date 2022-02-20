// sstatus
const SSTATUS_SIE: usize = 1 << 1;

use core::arch::asm;

#[inline]
unsafe fn r_sstatus() -> usize {
    let ret: usize;
    asm!("csrr {}, sstatus", out(reg) ret);
    ret
}

#[inline]
unsafe fn w_sstatus(x: usize) {
    asm!("csrw sstatus, {}", in(reg) x);
}

// disable device interrupts
pub fn intr_off() {
    unsafe {
        w_sstatus(r_sstatus() & !SSTATUS_SIE);
    }
}

// enable device interrupts
pub fn intr_on() {
    unsafe {
        w_sstatus(r_sstatus() | SSTATUS_SIE);
    }
}

pub fn intr_get() -> bool {
    unsafe {
        let x: usize = r_sstatus();
        return (x & SSTATUS_SIE) != 0;
    }
}

// read and write tp, the thread pointer, which holds
// this core's hartid (core number), the index into cpus[]
pub fn r_tp() -> usize {
    unsafe {
        let x: usize;
        asm!("mv {}, tp", out(reg) x);
        return x;
    }
}

pub fn w_tp(x: usize) {
    unsafe {
        asm!("mv tp, {}", in(reg) x);
    }
}