use crate::{uart::{uartputc_sync, uartputc, uartinit}, spinlock::SpinLock, process::{either_copyin, myproc, either_copyout, Proc, proc_manager}, fs::{DEVSW, Device}};

pub const BACKSPACE: u8 = 0x8;
pub const INPUT_BUF: usize = 128;

#[inline]
pub const fn C(x: u8) -> u8 {
    x - b'@'
}

//
// send one character to the uart.
// called by printf, and to echo input characters,
// but not from write().
//
pub fn consputc(c: u8) {
    if c == 8 {
        uartputc_sync(8);
        uartputc_sync(32);
        uartputc_sync(8);
    } else {
        uartputc_sync(c);
    }
}

//
// user write()s to the console go here.
//
pub fn consolewrite(user_src: bool, src: usize, n: usize)
    -> Result<usize, &'static str> {
    for i in 0..n {
        let mut c: u8 = 0;
        if either_copyin(&mut c as *mut u8, user_src, src + i, 1).is_err() {
            return Ok(i);
        }
        uartputc(c);
    }

    return Ok(n);
}

//
// user read()s from the console go here.
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
pub fn consoleread(user_dst: bool, mut dst: usize, mut n: usize) 
    -> Result<usize, &'static str> {
    unsafe {
        let target = n;
        CONSOLE.lock.acquire();
        
        while n > 0 {
            // wait until interrupt handler has put some
            // input into cons.buffer
            let p = unsafe { &mut *myproc() };
            while (CONSOLE.r == CONSOLE.w) {
                if p.killed {
                    CONSOLE.lock.release();
                    return Err("process killed");
                }
                p.sleep(&CONSOLE.r as *const _ as usize, &CONSOLE.lock);
            }

            CONSOLE.r += 1;
            let c = CONSOLE.buf[CONSOLE.r % INPUT_BUF];

            if c == C(68) { // end of file
                if n < target {
                    // save ^D for next time, to make sure
                    // caller gets a 0-byte result
                    CONSOLE.r -= 1;
                }
                break;
            }

            // copy the input byte to the user-space buffer
            if either_copyout(user_dst, dst, &c as *const u8, 1).is_err() {
                break;
            }

            dst += 1;
            n -= 1;

            if c == b'\n' {
                // a whole line has arrived
                // return to the user-level read
                break;
            }
        }
        CONSOLE.lock.release();

        Ok(target - n)
    }
}

pub struct Console {
    lock: SpinLock<()>,

    // input
    buf: [u8; INPUT_BUF],
    r: usize,   // read index
    w: usize,   // write index
    e: usize,   // edit index
}

pub static mut CONSOLE: Console = Console::new();

impl Console {
    const fn new() -> Self {
        Self {
            lock: SpinLock::new((), "cons"),
            buf: [0; INPUT_BUF],
            r: 0,
            w: 0,
            e: 0,
        }
    }
}

pub fn consoleinit() {
    uartinit();

    let console = 1;
    // connect read and write system calls
    // to console read and console write
    unsafe {
        DEVSW[console] = Some(Device{ read: consoleread, write: consolewrite} );
    }
}

//
// the console input interrupt handler.
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
pub fn consoleintr(mut c: u8) {
    unsafe {
        CONSOLE.lock.acquire();

        if c == C(b'P') {
            // print process list
            panic!("not implemented");
            // procdump()
        } else if c == C(b'U') {
            // kill line
            while CONSOLE.e != CONSOLE.w &&
                CONSOLE.buf[(CONSOLE.e - 1) % INPUT_BUF] != b'\n' {
                CONSOLE.e -= 1;
                consputc(BACKSPACE)
            }
        } else if c == BACKSPACE || c == b'\x7f' {
            // back space
            if CONSOLE.e != CONSOLE.w {
                CONSOLE.e -= 1;
                consputc(BACKSPACE)
            }
        } else {
            if c != 0 && CONSOLE.e - CONSOLE.r < INPUT_BUF {
                if c == b'\r' {
                    c = b'\n';
                }

                // echo back to the user
                consputc(c);

                // store for consumption by consoleread()
                CONSOLE.e += 1;
                CONSOLE.buf[CONSOLE.e % INPUT_BUF] = c;

                if c == b'\n' || c == C(b'D') ||
                    CONSOLE.e == CONSOLE.r + INPUT_BUF {
                    // wake up consoleread() if a whole line (or end-of-file)
                    // has arrived.
                    CONSOLE.w = CONSOLE.e;
                    unsafe { proc_manager.wakeup(&CONSOLE.r as *const _ as usize) };
                }
            }
        }

        CONSOLE.lock.release();
    }
}