use core::ptr;
use crate::consts::memlayout::UART0;
use crate::driver::consoleintr;
use crate::process::{proc_manager, myproc};
use crate::spinlock::{self, push_off, pop_off};

const RHR: usize = 0;
const THR: usize = 0;
const IER: usize = 1;
const FCR: usize = 2;
const ISR: usize = 2;
const LCR: usize = 3;
const LSR: usize = 5;

const IER_RX_ENABLE: u8 = 1 << 0;
const IER_TX_ENABLE: u8 = 1 << 1;
const FCR_FIFO_ENABLE: u8 = 1 << 0;
const FCR_FIFO_CLEAR: u8 = 3 << 1;
const LCR_EIGHT_BITS: u8 = 3 << 0;
const LCR_BAUD_LATCH: u8 = 1 << 7;
const LSR_RX_READY: u8 = 1 << 0;
const LSR_TX_IDLE: u8 = 1 << 5;

const UART_TX_BUF_SIZE: usize = 32;

static uart_tx_lock: spinlock::SpinLock<()> = spinlock::SpinLock::new((), "uart");

static mut uart_tx_w: usize = 0;
static mut uart_tx_r: usize = 0;

static mut uart_tx_buf: [u8; UART_TX_BUF_SIZE] = [0; UART_TX_BUF_SIZE];

macro_rules! Reg {
	($reg: expr) => {
		UART0 + $reg
	};
}

macro_rules! ReadReg {
	($reg: expr) => {
		unsafe {
			ptr::read_volatile(Reg!($reg) as *const u8)
		}
	};
}

macro_rules! WriteReg {
	($reg: expr, $value: expr) => {
		unsafe {
			ptr::write_volatile(Reg!($reg) as *mut u8, $value);
		}
	}
}

pub fn uartinit() {
	// disable interrupts
	WriteReg!(IER, 0x00);

	// special mode to set baud rate
	WriteReg!(LCR, LCR_BAUD_LATCH);

	// LSB for baud rate of 38.4k
	WriteReg!(0, 0x03);

	// MSB for baud rate of 38.4k
	WriteReg!(1, 0x00);

	// leave set-baud mode
	// and set word length to 8 bits, no parity
	WriteReg!(LCR, LCR_EIGHT_BITS);

	// reset and enable FIFOs.
	WriteReg!(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);

	// enable receive interrupts
	WriteReg!(IER, IER_TX_ENABLE | IER_RX_ENABLE);
}

// add a character to the output buffer and tell the
// UART to start sending if it isn't already.
// blocks if the output buffer is full.
// because it may block, it can't be called
// from interrupts; it's only suitable for use
// by write().
pub fn uartputc(c: u8) {
	uart_tx_lock.acquire();

	// TODO: handle panic here?

	unsafe {
		loop {
			if uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE {
				// buffer is full
				// wait for uartstart() to open up space in the buffer
				let p = unsafe { &mut *myproc() };
				p.sleep(&uart_tx_r as *const _ as usize, &uart_tx_lock);
			} else {
				uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
				uart_tx_w += 1;
				uartstart();
				uart_tx_lock.release();
				return;
			}
		}
	}
}

// alternate version of uartputc() that doesn't 
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
pub fn uartputc_sync(c: u8) {
	push_off();

	while (ReadReg!(LSR) & LSR_TX_IDLE) == 0 {}
	WriteReg!(THR, c);

	pop_off();
}

// if the UART is idle, and a character is waiting
// in the transmit buffer, send it.
// caller must hold uart_tx_lock.
// called from both the top- and bottom-half.
fn uartstart() {
	unsafe {
		loop {
			if uart_tx_w == uart_tx_r {
				// transmit buffer is empty
				return;
			}

			if (ReadReg!(LSR) & LSR_TX_IDLE) == 0 {
				// the UART transmit holding register is full,
				// so we cannot give it another byte.
				// it will interrupt when it's ready for a new byte.
				return;
			}

			let c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
			uart_tx_r += 1;

			// maybe uartputc is waiting for space in the buffer
			proc_manager.wakeup(&uart_tx_r as *const _ as usize);

			WriteReg!(THR, c);
		}
	}
}

// read one input character from the UART
// return -1 if none is waiting
pub fn uartgetc() -> Option<u8> {
	if ReadReg!(LSR) & 0x01 == 0 {
		None
	} else {
		Some(ReadReg!(RHR))
	}
}

// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
pub fn uartintr() {
	loop {
		match uartgetc() {
			Some(c) => {
				consoleintr(c);
			}
			None => {
				break;
			}
		}
	}

	// send buffered characters
	uart_tx_lock.acquire();
	uartstart();
	uart_tx_lock.release();
}