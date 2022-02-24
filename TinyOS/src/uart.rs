use core::ptr;
use crate::consts::memlayout::UART0;
use crate::spinlock;

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

static uart_tx_w: usize = 0;
static uart_tx_r: usize = 0;

static uart_tx_buf: [u8; UART_TX_BUF_SIZE] = [0; UART_TX_BUF_SIZE];

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

pub fn uartputc(c: u8) {
	while (ReadReg!(LSR) & (1 << 5)) == 0 {}
	WriteReg!(THR, c);
}

pub fn uartgetc() -> Option<u8> {
	if ReadReg!(5) & 1 == 0 {
		None
	} else {
		Some(ReadReg!(0))
	}
}