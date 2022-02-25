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
#[inline]
pub fn r_tp() -> usize {
    unsafe {
        let x: usize;
        asm!("mv {}, tp", out(reg) x);
        return x;
    }
}

#[inline]
pub fn w_tp(x: usize) {
    unsafe {
        asm!("mv tp, {}", in(reg) x);
    }
}

// Machine Status Register, mstatus

pub const MSTATUS_MPP_MASK: usize = 3 << 11;
pub const MSTATUS_MPP_M: usize = 3 << 11;
pub const MSTATUS_MPP_S: usize = 1 << 11;
pub const MSTATUS_MPP_U: usize = 0 << 11;
pub const MSTATUS_MIE: usize = 1 << 3;

#[inline]
pub fn r_mstatus() -> usize {
    unsafe {
        let x: usize;
        asm!("csrr {}, mstatus", out(reg) x);
        return x;
    }
}

#[inline]
pub fn w_mstatus(x: usize) {
    unsafe {
        asm!("csrw mstatus, {}", in(reg) x);
    }
}

#[inline]
pub fn w_mepc(x: usize) {
    unsafe {
        asm!("csrw mepc, {}", in(reg) x);
    }
}

// supervisor address translation and protection;
// holds the address of the page table.
#[inline]
pub fn w_satp(x: usize) {
    unsafe {
        asm!("csrw satp, {}", in(reg) x);
    }
}

#[inline]
pub fn r_satp() -> usize {
    unsafe {
        let x: usize;
        asm!("csrr {}, satp", out(reg) x);
        return x;
    }
}

// Machine Exception Delegation
#[inline]
pub fn r_medeleg() -> usize {
    unsafe {
        let x: usize;
        asm!("csrr {}, medeleg", out(reg) x);
        return x;
    }
}

#[inline]
pub fn w_medeleg(x: usize) {
    unsafe {
        asm!("csrw medeleg, {}", in(reg) x);
    }
}

// Machine Interrupt Delegation
#[inline]
pub fn r_mideleg() -> usize {
    unsafe {
        let x: usize;
        asm!("csrr {}, mideleg", out(reg) x);
        return x;
    }
}

#[inline]
pub fn w_mideleg(x: usize) {
    unsafe {
        asm!("csrw mideleg, {}", in(reg) x);
    }
}

// supervisor Interrupt Enable
pub const SIE_SEIE: usize = 1 << 9; // external
pub const SIE_STIE: usize = 1 << 5; // timer
pub const SIE_SSIE: usize = 1 << 1; // software

#[inline]
pub fn r_sie() -> usize {
    unsafe {
        let x: usize;
        asm!("csrr {}, sie", out(reg) x);
        return x;
    }
}

#[inline]
pub fn w_sie(x: usize) {
    unsafe {
        asm!("csrw sie, {}", in(reg) x);
    }
}

#[inline]
pub fn w_pmpcfg0(x: usize) {
    unsafe {
        asm!("csrw pmpcfg0, {}", in(reg) x);
    }
}

#[inline]
pub fn w_pmpaddr0(x: usize) {
    unsafe {
        asm!("csrw pmpaddr0, {}", in(reg) x);
    }
}

// which hard (core) is this?
#[inline]
pub fn r_mhartid() -> usize {
    unsafe {
        let x: usize;
        asm!("csrr {}, mhartid", out(reg) x);
        return x;
    }
}

// flush the TLB.
#[inline]
pub fn sfence_vma() {
    // the zero, zero means flush all TLB entries.
    unsafe {
        asm!("sfence.vma zero, zero");
    }
}