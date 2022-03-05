use core::arch::asm;

// Supervisor Status Register, sstatus
pub const SSTATUS_SPP: usize = 1 << 8;  // Previous mode, 1=Supervisor, 0=User
pub const SSTATUS_SPIE: usize = 1 << 5; // Supervisor Previous Interrupt Enable
pub const SSTATUS_UPIE: usize = 1 << 4; // User Previous Interrupt Enable
pub const SSTATUS_SIE: usize = 1 << 1;  // Supervisor Interrupt Enable
pub const SSTATUS_UIE: usize = 1 << 0;  // User Interrupt Enable

#[inline]
pub fn r_sstatus() -> usize {
    unsafe {
        let ret: usize;
        asm!("csrr {}, sstatus", out(reg) ret);
        ret
    }
}

#[inline]
pub fn w_sstatus(x: usize) {
    unsafe {
        asm!("csrw sstatus, {}", in(reg) x);
    }
}

// disable device interrupts
pub fn intr_off() {
    w_sstatus(r_sstatus() & !SSTATUS_SIE);
}

// enable device interrupts
pub fn intr_on() {
    w_sstatus(r_sstatus() | SSTATUS_SIE);
}

pub fn intr_get() -> bool {
    let x: usize = r_sstatus();
    return (x & SSTATUS_SIE) != 0;
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

// Machine-mode interrupt Enable
pub const MIE_MEIE: usize = 1 << 11;    // external
pub const MIE_MTIE: usize = 1 << 7;     // timer
pub const MIE_MSIE: usize = 1 << 3;     // software

#[inline]
pub fn r_mie() -> usize {
    unsafe {
        let x: usize;
        asm!("csrr {}, mie", out(reg) x);
        return x;
    }
}

#[inline]
pub fn w_mie(x: usize) {
    unsafe {
        asm!("csrw mie, {}", in(reg) x);
    }
}

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

// Supervisor Trap-Vector Base Address
// low two bits are mode.
#[inline]
pub fn w_stvec(x: usize) {
    unsafe {
        asm!("csrw stvec, {}", in(reg) x);
    }
}

#[inline]
pub fn r_stvec() -> usize {
    unsafe {
        let x;
        asm!("csrr {}, stvec", out(reg) x);
        return x;
    }
}

// Machine-mode interrupt vector
#[inline]
pub fn w_mtvec(x: usize) {
    unsafe {
        asm!("csrw mtvec, {}", in(reg) x);
    }
}

#[inline]
pub fn r_mtvec() -> usize {
    unsafe {
        let x;
        asm!("csrr {}, mtvec", out(reg) x);
        return x;
    }
}

// supervisor exception program counter, holds the
// instruction address to which a return from
// exception will go.
#[inline]
pub fn w_sepc(x: usize) {
    unsafe {
        asm!("csrw sepc, {}", in(reg) x);
    }
}

#[inline]
pub fn r_sepc() -> usize {
    unsafe {
        let x;
        asm!("csrr {}, sepc", out(reg) x);
        return x;
    }
}

#[inline]
pub fn r_sp() -> usize {
    unsafe {
        let x;
        asm!("mv {}, sp", out(reg) x);
        return x;
    }
}

// supervisor trap cause
#[inline]
pub fn r_scause() -> usize {
    unsafe {
        let x;
        asm!("csrr {}, scause", out(reg) x);
        return x;
    }
}

// supervisor trap value
#[inline]
pub fn r_stval() -> usize {
    unsafe {
        let x;
        asm!("csrr {}, stval", out(reg) x);
        return x;
    }
}

#[inline]
pub fn r_fp() -> usize {
    unsafe {
        let x;
        asm!("mv {}, s0", out(reg) x);
        return x;
    }
}

// Supervisor Interrupt Pending
#[inline]
pub fn w_sip(x: usize) {
    unsafe {
        asm!("csrw sip, {}", in(reg) x);
    }
}

#[inline]
pub fn r_sip() -> usize {
    unsafe {
        let x;
        asm!("csrr {}, sip", out(reg) x);
        return x;
    }
}

#[inline]
pub fn w_mscratch(x: usize) {
    unsafe {
        asm!("csrw mscratch, {}", in(reg) x);
    }
}