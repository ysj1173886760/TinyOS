use crate::{fs::{File, Inode, begin_op, create, FileType, InodeType, end_op, namei, ITABLE, FTABLE}, consts::param::{NOFILE, MAXPATH, NDEV}, process::myproc};

use super::{argint, argstr, O_CREATE, O_RDONLY, O_WRONLY, O_RDWR, O_TRUNC};

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
pub fn argfd(n: usize, pfd: Option<&mut usize>) -> Option<&mut File> {
    let mut fd = 0;
    if argint(n, &mut fd).is_err() {
        return None
    }

    let fd = fd as usize;
    if fd >= NOFILE {
        return None
    }

    let p = unsafe { &mut *myproc() };
    if p.ofile[fd].is_null() {
        return  None
    }

    if pfd.is_some() {
        *pfd.unwrap() = fd;
    }

    Some(unsafe { &mut *p.ofile[fd] })
}

// Allocate a file descriptor for the gived file
// Takes over file reference from caller on success
pub fn fdalloc(f: &mut File) -> Result<usize, &'static str> {
    let p = unsafe { &mut *myproc() };

    for fd in 0..NOFILE {
        if p.ofile[fd].is_null() {
            p.ofile[fd] = f as *mut File;
            return Ok(fd);
        }
    }

    Err("failed to allocate fd")
}

pub fn sys_open() -> Result<usize, &'static str> {
    let mut path: [u8; MAXPATH] = [0; MAXPATH];
    let mut omode = 0;

    let n = argstr(0, &mut path, MAXPATH)?;
    argint(1, &mut omode)?;

    begin_op();

    let ip;
    if (omode & O_CREATE) != 0 {
        match create(&path, InodeType::File, 0, 0) {
            Some(i) => {
                ip = i;
            }
            None => {
                end_op();
                return Err("failed to create file");
            }
        }
    } else {
        match namei(&path) {
            Some(i) => {
                ip = i;
            }
            None => {
                end_op();
                return Err("failed to find file");
            }
        }
        ip.ilock();
        if (ip.itype == InodeType::Directory) && (omode != O_RDONLY) {
            unsafe { ITABLE.iunlockput(ip) };
            end_op();
            return Err("reading directory");
        }
    }

    if ip.itype == InodeType::Device && ip.major >= NDEV as u16 {
        unsafe { ITABLE.iunlockput(ip) };
        end_op();
        return Err("wrong dev major");
    }

    let mut f;
    match unsafe { FTABLE.filealloc() } {
        Some(file) => {
            f = file;
        }
        None => {
            unsafe { ITABLE.iunlockput(ip) };
            end_op();
            return Err("failed to alloc file");
        }
    }

    let mut fd = 0;
    match fdalloc(f) {
        Ok(tmp) => {
            fd = tmp;
        }
        Err(err) => {
            unsafe { FTABLE.fileclose(f) };
            unsafe { ITABLE.iunlockput(ip) };
            end_op();
            return Err("failed to alloc file");
        }
    }

    if ip.itype == InodeType::Device {
        f.ftype = FileType::Device;
        f.major = ip.major;
    } else {
        f.ftype = FileType::Inode;
        f.off = 0;
    }

    f.ip = ip as *mut Inode;
    f.readable = (omode & O_WRONLY) == 0;
    f.writable = (omode & O_WRONLY) != 0 || (omode & O_RDWR) != 0;

    if (omode & O_TRUNC) != 0 && ip.itype == InodeType::File {
        ip.itrunc();
    }

    ip.iunlock();
    end_op();
    
    Ok(fd)
}