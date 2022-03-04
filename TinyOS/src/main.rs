#![no_std]
#![no_main]
#![feature(panic_info_message)]
#![allow(non_snake_case)]

use mm::pg_round_up;
use riscv::r_fp;

use crate::{process::{proc_manager, mycpu}, trap::trap_init_hart, mm::{kinit, kvminit, kvminithart, pg_round_down}, uart::uartinit, driver::{consoleinit, DISK}, plic::{plicinit, plicinithart}, fs::BCACHE};

core::arch::global_asm!(include_str!("asm/entry.S"));
core::arch::global_asm!(include_str!("asm/kernelvec.S"));
core::arch::global_asm!(include_str!("asm/trampoline.S"));
core::arch::global_asm!(include_str!("asm/swtch.S"));

mod consts;
mod uart;
mod process;
mod riscv;
mod spinlock;
mod printf;
mod mm;
mod init_core;
mod trap;
mod plic;
mod sleeplock;
mod driver;
mod fs;
mod syscall;

// ///////////////////////////////////
// / LANGUAGE STRUCTURES / FUNCTIONS
// ///////////////////////////////////
#[no_mangle]
extern "C" fn eh_personality() {}

#[panic_handler]
fn panic(info: &core::panic::PanicInfo) -> ! {
	print!("Aborting: ");
	if let Some(p) = info.location() {
		println!(
				"line {}, file {}: {}",
				p.line(),
				p.file(),
				info.message().unwrap()
				);
	} else {
		println!("no information available.");
	}
	abort();
}

#[no_mangle]
extern "C"
fn abort() -> ! {
	loop {
		unsafe {
			core::arch::asm!("wfi");
		}
	}
}

pub fn backtrace() {
    let mut fp = r_fp();
    let upper_bound = pg_round_up(fp);
    let lower_bound = pg_round_down(fp);

    crate::println!("backtrace:");

    // when the current frame is at the top of the page, then we don't need to print ra any more
    while fp < upper_bound && fp > lower_bound {
        let ra_addr = fp - 8;
        unsafe {
            println!("{:#x}", *(ra_addr as *mut usize));
            fp = *((fp - 16) as *mut usize);
        }
    }
}

// ///////////////////////////////////
// / ENTRY POINT
// ///////////////////////////////////
#[no_mangle]
fn kmain() {
    // init procedure is here
	if process::cpuid() == 0 {
		consoleinit();
        println!("xv6-rust is booting");
        kinit();
        kvminit();
        // turn on paging
        kvminithart();
        // initialize kstack
        unsafe { process::proc_manager.proc_init(); }
        trap_init_hart();
		// set up interrupt controller
		plicinit();
		// ask PLIC for device interrupts
		plicinithart();
		// initialize buffer cache
		unsafe { BCACHE.binit(); }
		unsafe { DISK.init(); }
        unsafe { proc_manager.user_init(); }
	} else {
		return
    }

    unsafe {
        let cpu = &mut *mycpu();
        println!("{:?}", cpu);
        cpu.scheduler();
    }

	unreachable!();
}
