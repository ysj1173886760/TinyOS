use crate::{process::{myproc, mycpu}, trap, spinlock::{pop_off, push_off}};

use self::{exec::sys_exec, sysfile::{sys_open, sys_mknod, sys_dup, sys_write, sys_read, sys_close, sys_link, sys_unlink, sys_mkdir, sys_chdir}, sysproc::{sys_fork, sys_wait, sys_exit, sys_sbrk, sys_kill, sys_getpid}};

mod exec;
mod elf;
mod sysfile;
mod sysproc;

pub const O_RDONLY: u32 = 0x000;
pub const O_WRONLY: u32 = 0x001;
pub const O_RDWR: u32 = 0x002;
pub const O_CREATE: u32 = 0x200;
pub const O_TRUNC: u32 = 0x400;

// System call numbers
pub const SYS_fork  : usize =  1;
pub const SYS_exit  : usize =  2;
pub const SYS_wait  : usize =  3;
pub const SYS_pipe  : usize =  4;
pub const SYS_read  : usize =  5;
pub const SYS_kill  : usize =  6;
pub const SYS_exec  : usize =  7;
pub const SYS_fstat : usize =  8;
pub const SYS_chdir : usize =  9;
pub const SYS_dup   : usize = 10;
pub const SYS_getpid: usize = 11;
pub const SYS_sbrk  : usize = 12;
pub const SYS_sleep : usize = 13;
pub const SYS_uptime: usize = 14;
pub const SYS_open  : usize = 15;
pub const SYS_write : usize = 16;
pub const SYS_mknod : usize = 17;
pub const SYS_unlink: usize = 18;
pub const SYS_link  : usize = 19;
pub const SYS_mkdir : usize = 20;
pub const SYS_close : usize = 21;

// Fetch the uint64 at addr from the current process
pub fn fetchaddr(addr: usize, ip: &mut usize) -> bool {
    let p = unsafe { &mut *myproc() };
    let size = core::mem::size_of::<usize>();
    if addr >= p.sz || addr + size >= p.sz {
        return false;
    }
    if p.pagetable
        .as_mut()
        .expect("failed to find pagetable")
        .copyin(ip as *mut _ as *mut u8, addr, size).is_err() {
        return false;
    }
    true
}

// Fetch the nul-terminated string at addr from the current process.
// Returns length of string, not including nul, or -1 for error.
pub fn fetchstr(addr: usize, buf: &mut [u8], max: usize)
    -> Result<usize, &'static str> {
    let p = unsafe { &mut *myproc() };
    match p.pagetable
        .as_mut()
        .expect("failed to find pagetable")
        .copyinstr(buf.as_mut_ptr(), addr, max) {
        Err(err) => {
            Err(err)
        }
        Ok(()) => {
            Ok(strlen(buf))
        }
    }
}

pub fn argraw(n: usize) -> usize {
    let p = unsafe { &mut *myproc() };
    let trapframe = unsafe { & *p.trapframe };
    match n {
        0 => trapframe.a0,
        1 => trapframe.a1,
        2 => trapframe.a2,
        3 => trapframe.a3,
        4 => trapframe.a4,
        5 => trapframe.a5,
        _ => {
            panic!("argraw");
        }
    }
}

// Fetch the nth 32-bit system call argument.
pub fn argint(n: usize, ip: &mut i32)
    -> Result<(), &'static str> {
    *ip = argraw(n) as i32;
    Ok(())
}

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
pub fn argaddr(n: usize, ip: &mut usize)
    -> Result<(), &'static str> {
    *ip = argraw(n);
    Ok(())
}

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
pub fn argstr(n: usize, buf: &mut [u8], max: usize) 
    -> Result<usize, &'static str> {
    let mut addr = 0;
    argaddr(n, &mut addr);
    fetchstr(addr, buf, max)
}

fn strlen(str: &[u8]) -> usize {
    let mut cur = 0;
    while str[cur] != 0 {
        cur += 1;
    }
    return cur;
}

// handle everything here
pub fn syscall() {
    let p = unsafe { &mut *myproc() };
    let trapframe = unsafe { &mut *p.trapframe };
    
    // crate::println!("{} {:?} kernel sp {:#x}", core::str::from_utf8(&p.name).unwrap(), p.trapframe, trapframe.kernel_sp);

    let num = trapframe.a7;
    match num {
        SYS_fork => {
            match sys_fork() {
                Ok(pid) => {
                    trapframe.a0 = pid;
                }
                Err(_) => {
                    trapframe.a0 = usize::MAX;
                }
            }
        }
        SYS_exit => {
            match sys_exit() {
                Ok(()) => {
                    trapframe.a0 = 0;
                }
                Err(_) => {
                    trapframe.a0 = usize::MAX;
                }
            }
        }
        SYS_wait => {
            match sys_wait() {
                Ok(pid) => {
                    trapframe.a0 = pid;
                }
                Err(_) => {
                    trapframe.a0 = usize::MAX;
                }
            }
        }
        SYS_pipe => {
            panic!("not implemented {}", num);
        }
        SYS_read=> {
            match sys_read() {
                Ok(size) => {
                    trapframe.a0 = size;
                }
                Err(_) => {
                    trapframe.a0 = usize::MAX;
                }
            }
        }
        SYS_kill => {
            match sys_kill() {
                Ok(res) => {
                    trapframe.a0 = res;
                }
                Err(str) => {
                    trapframe.a0 = usize::MAX;
                }
            }
        }
        SYS_exec => {
            match sys_exec() {
                Ok(argc) => {
                    trapframe.a0 = argc;
                }
                Err(str) => {
                    // crate::println!("exec error: {}", str);
                    trapframe.a0 = usize::MAX;
                }
            }
        }
        SYS_fstat => {
            panic!("not implemented {}", num);
        }
        SYS_chdir => {
            match sys_chdir() {
                Ok(()) => {
                    trapframe.a0 = 0;
                }
                Err(str) => {
                    trapframe.a0 = usize::MAX;
                }
            }
        }
        SYS_dup => {
            match sys_dup() {
                Ok(fd) => {
                    trapframe.a0 = fd;
                }
                Err(_) => {
                    trapframe.a0 = usize::MAX;
                }
            }
        }
        SYS_getpid => {
            match sys_getpid() {
                Ok(pid) => {
                    trapframe.a0 = pid;
                }
                Err(_) => {
                    trapframe.a0 = usize::MAX;
                }
            }
        }
        SYS_sbrk => {
            match sys_sbrk() {
                Ok(addr) => {
                    trapframe.a0 = addr;
                }
                Err(_) => {
                    trapframe.a0 = usize::MAX;
                }
            }
        }
        SYS_sleep => {
            panic!("not implemented {}", num);
        }
        SYS_uptime => {
            panic!("not implemented {}", num);
        }
        SYS_open => {
            match sys_open() {
                Ok(fd) => {
                    trapframe.a0 = fd;
                }
                Err(_) => {
                    trapframe.a0 = usize::MAX;
                }
            }
        }
        SYS_write => {
            match sys_write() {
                Ok(size) => {
                    trapframe.a0 = size;
                }
                Err(err) => {
                    crate::println!("sys write err: {}", err);
                    trapframe.a0 = usize::MAX;
                }
            }
        }
        SYS_mknod => {
            match sys_mknod() {
                Ok(()) => {
                    trapframe.a0 = 0;
                }
                Err(_) => {
                    trapframe.a0 = usize::MAX;
                }
            }
        }
        SYS_unlink => {
            match sys_unlink() {
                Ok(()) => {
                    trapframe.a0 = 0;
                }
                Err(_) => {
                    trapframe.a0 = usize::MAX;
                }
            }
        }
        SYS_link => {
            match sys_link() {
                Ok(()) => {
                    trapframe.a0 = 0;
                }
                Err(_) => {
                    trapframe.a0 = usize::MAX;
                }
            }
        }
        SYS_mkdir => {
            match sys_mkdir() {
                Ok(()) => {
                    trapframe.a0 = 0;
                }
                Err(_) => {
                    trapframe.a0 = usize::MAX;
                }
            }
        }
        SYS_close => {
            match sys_close() {
                Ok(()) => {
                    trapframe.a0 = 0;
                }
                Err(_) => {
                    trapframe.a0 = usize::MAX;
                }
            }
        }
        _ => {
            crate::println!("{} {:?} unknown sys call {}", p.pid, p.name, num);
            // hopefully it will convert this to -1
            trapframe.a0 = usize::MAX;
        }
    }
}