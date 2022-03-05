use crate::{process::{myproc, Proc, proc_manager, ProcState}, consts::param::NOFILE, fs::{FTABLE, ITABLE}};

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

    // TODO: wait lock here
    np.lock.acquire();
    np.state = ProcState::RUNNABLE;
    np.lock.release();
    
    crate::println!("fork ret");
    Ok(pid)
}