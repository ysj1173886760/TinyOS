use crate::consts::memlayout::{CLINT_MTIME, CLINT_MTIMECMP};
use crate::riscv;
use crate::kmain;
use crate::riscv::r_mhartid;
use core::arch::asm;


// entry.S jumps here in machine mode on stack0.
#[no_mangle]
pub fn init_core() -> ! {
    // set M Previous Privilege mode to Supervisor, for mret.
    let mut x = riscv::r_mstatus();
    x &= !riscv::MSTATUS_MPP_MASK;
    x |= riscv::MSTATUS_MPP_S;
    riscv::w_mstatus(x);

    // set M Exception Program Counter to main, for mret.
    // requires gcc -mcmodel=medany
    riscv::w_mepc(kmain as usize);

    // disable paging for now.
    riscv::w_satp(0);

    // delegate all interrupts and exceptions to supervisor mode.
    riscv::w_medeleg(0xffff);
    riscv::w_mideleg(0xffff);
    riscv::w_sie(riscv::r_sie() | riscv::SIE_SEIE | riscv::SIE_STIE | riscv::SIE_SSIE);

    // configure Physical Memory Protection to give supervisor mode
    // access to all of physical memory.
    riscv::w_pmpaddr0(0x3fffffffffffff);
    riscv::w_pmpcfg0(0xf);

    // ask for clock interrupts.
    // TODO: initialize timer
    // timerinit();

    // keep each CPU's hartid in its tp register, for cpuid().
    let id = riscv::r_mhartid();
    riscv::w_tp(id);

    // switch to supervisor mode and jump to main().
    unsafe {
        asm!("mret");
    }
    loop {}
}

// set up to receive timer interrupts in machine mode,
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
fn timerinit() {
    // each CPU has a separate source of timer interrupts.
    let id = r_mhartid();

    // ask the CLINT for a timer interrupt.
    let interval = 1000000;
    unsafe {
        core::ptr::write_volatile(CLINT_MTIMECMP(id) as *mut usize, CLINT_MTIME + interval);
    }

    // prepare information in scratch[] for timervec.
    // scratch[0..2] : space for timervec to save registers.
    // scratch[3] : address of CLINT MTIMECMP register.
    // scratch[4] : desired interval (in cycles) between timer interrupts.
}