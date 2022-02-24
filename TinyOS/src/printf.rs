use crate::{spinlock::SpinLock, uart::uartputc};

use core::fmt::{self, Write};

struct Pr {
	lock: SpinLock,
}

impl fmt::Write for Pr {
	fn write_str(&mut self, s: &str) -> fmt::Result {
		for byte in s.bytes() {
			uartputc(byte);
		}
		Ok(())
	}
}

static mut PR: Pr = Pr {
	lock: SpinLock::new("print")
};

pub fn _print(args: fmt::Arguments) {
	unsafe {
		PR.lock.acquire();
		PR.write_fmt(args).expect("print error");
		PR.lock.release();
	}
}

#[macro_export]
macro_rules! print
{
	($($args:tt)+) => ({
		$crate::printf::_print(format_args!($($args)+))
	});
}

#[macro_export]
macro_rules! println
{
	() => ({
		print!("\n")
	});
	($fmt:expr) => ({
		print!(concat!($fmt, "\n"))
	});
	($fmt:expr, $($args:tt)+) => ({
		print!(concat!($fmt, "\n"), $($args)+)
	});
}
