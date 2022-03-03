use crate::{spinlock::SpinLock, uart::uartputc, driver::consputc};

use core::fmt::{self, Write};

struct Pr {
	lock: SpinLock<()>,
}

impl fmt::Write for Pr {
	fn write_str(&mut self, s: &str) -> fmt::Result {
		for byte in s.bytes() {
			consputc(byte);
		}
		Ok(())
	}
}

static mut PR: Pr = Pr {
	lock: SpinLock::new((), "print")
};

pub fn _print(args: fmt::Arguments) {
	unsafe {
		let guard = PR.lock.lock();
		PR.write_fmt(args).expect("print error");
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
		$crate::print!("\n")
	});
	($fmt:expr) => ({
		$crate::print!(concat!($fmt, "\n"))
	});
	($fmt:expr, $($args:tt)+) => ({
		$crate::print!(concat!($fmt, "\n"), $($args)+)
	});
}
