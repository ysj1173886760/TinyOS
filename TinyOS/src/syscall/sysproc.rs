use crate::{process::{myproc, Proc, proc_manager, ProcState, wait_lock}, consts::param::NOFILE, fs::{FTABLE, ITABLE}};

use super::{argint, argaddr};

// Create a new process, copying the parent.
// Sets up child kernel stack to return as if from fork() system call.
pub fn sys_fork() -> Result<usize, &'static str> {
    let p = unsafe { &mut *myproc() };

    // Allocate process.
    let np;
    match unsafe { proc_manager.allocproc() } {
        Some(newp) => {
            np = newp;
        }
        None => {
            return Err("failed to alloc proc");
        }
    }

    // Copy user memory from parent to child.
    if np.pagetable.as_mut().unwrap().uvm_copy(p.pagetable.as_mut().unwrap(), p.sz).is_err() {
        np.free();
        np.lock.release();
        return Err("failed to copy pagetable");
    }

    np.sz = p.sz;

    // copy saved user registers
    let new_trapframe = unsafe { &mut *np.trapframe };
    let old_trapframe = unsafe { &mut *p.trapframe };
    new_trapframe.copy_from(&old_trapframe);

    new_trapframe.a0 = 0;

    for i in 0..NOFILE {
        if !p.ofile[i].is_null() {
            let f = unsafe { &mut *p.ofile[i] };
            unsafe { FTABLE.filedup(f) };
            np.ofile[i] = p.ofile[i];
        }
    }
    let cwd = unsafe { &mut *p.cwd };
    unsafe { ITABLE.idup(cwd) };
    np.cwd = p.cwd;

    // TODO: copy name here
    let pid = np.pid;

    np.lock.release();

    // must holding wait_lock to change parent filed
    // because p might get killed when we were trying to fork
    // so we need to reparent new process to initproc
    wait_lock.acquire();
    np.parent = p as *mut Proc;
    wait_lock.release();

    np.lock.acquire();
    np.state = ProcState::RUNNABLE;
    np.lock.release();
    
    Ok(pid)
}

pub fn sys_exit() -> Result<(), &'static str> {
    let mut n = 0;
    argint(0, &mut n)?;
    let p = unsafe { &mut *myproc() };
    p.exit(n);

    // we can't reach here
    return Ok(())
}

pub fn sys_wait() -> Result<usize, &'static str> {
    let p = unsafe { &mut *myproc() };
    let mut addr = 0;
    argaddr(0, &mut addr)?;

    return unsafe { proc_manager.wait(p, addr) };
}

pub fn sys_sbrk() -> Result<usize, &'static str> {
    let p = unsafe { &mut *myproc() };
    let mut n = 0;
    argint(0, &mut n)?;

    let addr = p.sz;
    if !p.growproc(n) {
        return Err("failed to grow proc");
    }

    return Ok(addr);
}

pub fn sys_kill() -> Result<usize, &'static str> {
    let mut pid = 0;
    argint(0, &mut pid)?;

    let pid = pid as usize;
    if unsafe { proc_manager.kill(pid) } {
        return Ok(0);
    }

    return Err("failed to kill proc");
}

pub fn sys_getpid() -> Result<usize, &'static str> {
    let p = unsafe { &mut *myproc() };
    return Ok(p.pid);
}