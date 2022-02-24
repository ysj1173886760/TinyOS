use crate::riscv;
use crate::kmain;
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