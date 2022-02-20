// uart.rs
// UART routines and driver

use core::convert::TryInto;
use core::fmt::Write;
use core::fmt;

const RHR: usize = 0;
const THR: usize = 0;
const IER: usize = 1;
const FCR: usize = 2;
const ISR: usize = 2;
const LCR: usize = 3;
const LSR: usize = 5;

// const IER_RX_ENABLE: u8 = 1 << 0;
// const IER_TX_ENABLE: u8 = 1 << 1;
// const FCR_FIFO_ENABLE: u8 = 1 << 0;
// const FCR_FIFO_CLEAR: u8 = 3 << 1;
// const LCR_EIGHT_BITS: u8 = 3 << 0;
// const LCR_BAUD_LATCH: u8 = 1 << 7;
// const LSR_RX_READY: u8 = 1 << 0;
// const LSR_TX_IDLE: u8 = 1 << 5;

pub struct Uart {
	base_address: usize,
}

impl Write for Uart {
	fn write_str(&mut self, out: &str) -> fmt::Result {
		for c in out.bytes() {
			self.put(c);
		}
		Ok(())
	}
}

impl Uart {
	pub fn new(base_address: usize) -> Self {
		Uart {
			base_address
		}
	}

	pub fn init(&mut self) {
		let ptr = self.base_address as *mut u8;
		unsafe {

			// disable interrupts
			ptr.add(IER).write_volatile(0x00);

			// special mode to set baud rate
			ptr.add(LCR).write_volatile(0x80);

			// LSB for baud rate of 38.4k
			ptr.add(0).write_volatile(0x03);

			// MSB for baud rate of 38.4k
			ptr.add(1).write_volatile(0x00);

			// leave set-baud mode
			// and set word length to 8 bits, no parity
			ptr.add(LCR).write_volatile(0x07);

			// reset and enable FIFOs.
			ptr.add(FCR).write_volatile(0x01);

			// enable receive interrupts
			ptr.add(IER).write_volatile(0x01);
		}
	}

	pub fn put(&mut self, c: u8) {
		let ptr = self.base_address as *mut u8;
		unsafe {
			ptr.add(THR).write_volatile(c);
		}
	}

	pub fn get(&mut self) -> Option<u8> {
		let ptr = self.base_address as *mut u8;
		unsafe {
			if ptr.add(5).read_volatile() & 1 == 0 {
				// The DR bit is 0, meaning no data
				None
			}
			else {
				// The DR bit is 1, meaning data!
				Some(ptr.add(0).read_volatile())
			}
		}
	}
}