#![no_std]
#![no_main]
#![feature(panic_info_message)]

use mm::pg_round_up;
use riscv::r_fp;

use crate::{process::{proc_manager, mycpu}, trap::trap_init_hart, mm::{kinit, kvminit, kvminithart, pg_round_down}, uart::uartinit};

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

        uartinit();
        println!("xv6-rust is booting");
        kinit();
        kvminit();
        // turn on paging
        kvminithart();
        // initialize kstack

        unsafe { process::proc_manager.proc_init(); }
        trap_init_hart();
        unsafe { proc_manager.user_init(); }
	} else {
		return
    }

    unsafe {
        let cpu = &mut *mycpu();
        println!("{:?}", cpu);
        cpu.scheduler();
    }

	// println!("xv6-rust kernel is booting");

	// Now see if we can read stuff:
	// Usually we can use #[test] modules in Rust, but it would convolute the
	// task at hand. So, we'll just add testing snippets.
	loop {
		if let Some(c) = uart::uartgetc() {
			match c {
				8 => {
					// This is a backspace, so we essentially have
					// to write a space and backup again:
					print!("{}{}{}", 8 as char, ' ', 8 as char);
				},
				  10 | 13 => {
					  // Newline or carriage-return
					  println!();
				  },
				  0x1b => {
					  // Those familiar with ANSI escape sequences
					  // knows that this is one of them. The next
					  // thing we should get is the left bracket [
					  // These are multi-byte sequences, so we can take
					  // a chance and get from UART ourselves.
					  // Later, we'll button this up.
					  if let Some(next_byte) = uart::uartgetc() {
						  if next_byte == 91 {
							  // This is a right bracket! We're on our way!
							  if let Some(b) = uart::uartgetc() {
								  match b as char {
									  'A' => {
										  println!("That's the up arrow!");
									  },
									  'B' => {
										  println!("That's the down arrow!");
									  },
									  'C' => {
										  println!("That's the right arrow!");
									  },
									  'D' => {
										  println!("That's the left arrow!");
									  },
									  _ => {
										  println!("That's something else.....");
									  }
								  }
							  }
						  }
					  }
				  },
				  _ => {
					  print!("{}", c as char);
				  }
			}
		}
	}
}
