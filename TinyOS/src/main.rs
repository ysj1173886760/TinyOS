#![no_std]
#![no_main]
#![feature(panic_info_message)]

core::arch::global_asm!(include_str!("asm/entry.S"));

mod consts;
mod uart;
mod proc;
mod riscv;
mod spinlock;
mod printf;
mod mm;
mod init_core;

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

// ///////////////////////////////////
// / ENTRY POINT
// ///////////////////////////////////
#[no_mangle]
fn kmain() {
	if proc::cpuid() == 0 {
		mm::kalloc::kinit();
		uart::uartinit();
	}
	println!("current cpu id is {}", proc::cpuid());

	if proc::cpuid() != 0 {
		return
	}
	println!("we have {} page now", mm::kalloc::kcount());
	let frame = mm::kalloc::kalloc().unwrap();
	println!("we have {} page now", mm::kalloc::kcount());
	mm::kalloc::kfree(frame);
	println!("we have {} page now", mm::kalloc::kcount());

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
