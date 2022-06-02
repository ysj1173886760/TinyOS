use crate::consts::memlayout::{CLINT_MTIME, CLINT_MTIMECMP};
use crate::consts::param::NCPU;
use crate::riscv::{self, w_mscratch, w_mtvec, w_mstatus, r_mstatus, MSTATUS_MIE, r_mie, w_mie, MIE_MTIE};
use crate::kmain;
use crate::riscv::r_mhartid;
use core::arch::asm;

static mut timer_scratch: [[usize; 5]; NCPU] = [[0; 5]; NCPU];

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
    unsafe {timerinit();}

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
unsafe fn timerinit() {
    // each CPU has a separate source of timer interrupts.
    let id = r_mhartid();

    // ask the CLINT for a timer interrupt.
    let interval = 1000000;
    core::ptr::write_volatile(CLINT_MTIMECMP(id) as *mut usize, CLINT_MTIME + interval);

    // prepare information in scratch[] for timervec.
    // scratch[0..2] : space for timervec to save registers.
    // scratch[3] : address of CLINT MTIMECMP register.
    // scratch[4] : desired interval (in cycles) between timer interrupts.
    let scratch = timer_scratch[id].as_ptr();
    timer_scratch[id][3] = CLINT_MTIMECMP(id);
    timer_scratch[id][4] = interval;
    w_mscratch(scratch as usize);

    extern "C" {
        fn timervec();
    }
    // set the machine-mode trap handler
    w_mtvec(timervec as usize);

    // enable machine-mode interrupts
    w_mstatus(r_mstatus() | MSTATUS_MIE);

    // enable machine-mode timer interrupts
    w_mie(r_mie() | MIE_MTIE);
}