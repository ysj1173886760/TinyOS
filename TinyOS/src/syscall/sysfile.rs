use core::any::Any;

use crate::{fs::{File, Inode, begin_op, create, FileType, InodeType, end_op, namei, ITABLE, FTABLE, DIRSIZ, nameiparent, strcmp, DirEntry}, consts::param::{NOFILE, MAXPATH, NDEV}, process::myproc};

use super::{argint, argstr, O_CREATE, O_RDONLY, O_WRONLY, O_RDWR, O_TRUNC, argaddr};

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

pub fn sys_open() -> Result<usize, &'static str> {
    let mut path: [u8; MAXPATH] = [0; MAXPATH];
    let mut omode = 0;

    let n = argstr(0, &mut path, MAXPATH)?;
    argint(1, &mut omode)?;

    begin_op();

    let ip;
    let omode = omode as u32;
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
    let p = unsafe { &mut *myproc() };
    match p.fdalloc(f) {
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

pub fn sys_mknod() -> Result<(), &'static str> {
    let mut path: [u8; MAXPATH] = [0; MAXPATH];
    let mut major = 0;
    let mut minor = 0;
    begin_op();
    if argstr(0, &mut path, MAXPATH).is_err() {
        end_op();
        return Err("failed to get argument");
    }
    if argint(1, &mut major).is_err() {
        end_op();
        return Err("failed to get argument");
    }
    if argint(2, &mut minor).is_err() {
        end_op();
        return Err("failed to get argument");
    }

    let ip;
    match create(&path, InodeType::Device, major as u16, minor as u16) {
        Some(i) => {
            ip = i;
        }
        None => {
            end_op();
            return Err("failed to create device");
        }
    }
    unsafe { ITABLE.iunlockput(ip) };
    end_op();

    Ok(())
}

pub fn sys_dup() -> Result<usize, &'static str> {
    let f;
    match argfd(0, None) {
        Some(file) => {
            f = file;
        }
        None => {
            return Err("failed to get fd");
        }
    }

    let p = unsafe { &mut *myproc() };
    let fd = p.fdalloc(f)?;
    unsafe { FTABLE.filedup(f) };

    Ok(fd)
}

pub fn sys_read() -> Result<usize, &'static str> {
    let f;
    match argfd(0, None) {
        Some(file) => {
            f = file;
        }
        None => {
            return Err("failed to get fd");
        }
    }

    let mut n = 0;
    argint(2, &mut n)?;
    let mut p = 0;
    argaddr(1, &mut p)?;

    f.fileread(p, n as usize)
}

pub fn sys_write() -> Result<usize, &'static str> {
    let f;
    match argfd(0, None) {
        Some(file) => {
            f = file;
        }
        None => {
            return Err("failed to get fd");
        }
    }

    let mut n = 0;
    argint(2, &mut n)?;
    let mut p = 0;
    argaddr(1, &mut p)?;

    f.filewrite(p, n as usize)
}

pub fn sys_close() -> Result<(), &'static str> {
    let f;
    let mut fd = 0;
    match argfd(0, Some(&mut fd)) {
        Some(file) => {
            f = file;
        }
        None => {
            return Err("failed to get fd");
        }
    }
    let p = unsafe { &mut *myproc() };
    unsafe { FTABLE.fileclose(f) };
    p.ofile[fd] = core::ptr::null_mut();

    return Ok(());
}

// Create the path new as a link to the same inode as old
pub fn sys_link() -> Result<(), &'static str> {
    let mut name: [u8; DIRSIZ] = [0; DIRSIZ];
    let mut new: [u8; MAXPATH] = [0; MAXPATH];
    let mut old: [u8; MAXPATH] = [0; MAXPATH];

    argstr(0, &mut old, MAXPATH)?;
    argstr(1, &mut new, MAXPATH)?;

    begin_op();
    
    let ip;
    match namei(&old) {
        Some(i) => ip = i,
        None => {
            end_op();
            return Err("failed to find inode corresponding to old");
        }
    }

    ip.ilock();
    if ip.itype == InodeType::Directory {
        // you can't have multiple reference to a single directory
        unsafe { ITABLE.iunlockput(ip); }
        end_op();
        return Err("failed link to a directory")
    }

    ip.nlink += 1;
    // update inode to disk
    ip.iupdate();
    ip.iunlock();

    let dp;
    // i doubt that do we really need to do this here?
    // TODO: simplify the error handling here
    match nameiparent(&new, &mut name) {
        Some(i) => dp = i,
        None => {
            ip.ilock();
            ip.nlink -= 1;
            ip.iupdate();
            unsafe { ITABLE.iunlockput(ip); }
            end_op();
            return Err("failed to find parent")
        }
    }

    dp.ilock();
    if dp.dev != ip.dev || !dp.dirlink(&name, ip.inum) {
        unsafe { ITABLE.iunlockput(dp); }
        ip.ilock();
        ip.nlink -= 1;
        ip.iupdate();
        unsafe { ITABLE.iunlockput(ip); }
        end_op();
        return Err("failed link the file")
    }

    unsafe {
        ITABLE.iunlockput(dp);
        ITABLE.iput(ip);
    }

    end_op();

    Ok(())
}

// unlink the file. i.e. delete the file
pub fn sys_unlink() -> Result<(), &'static str> {
    let mut name: [u8; DIRSIZ] = [0; DIRSIZ];
    let mut path: [u8; MAXPATH] = [0; MAXPATH];

    argstr(0, &mut path, MAXPATH)?;

    begin_op();

    let dp;
    match nameiparent(&path, &mut name) {
        Some(i) => dp = i,
        None => {
            end_op();
            return Err("failed to find parent");
        }
    }
    dp.ilock();

    // cannot unlink "." or ".."
    if strcmp(&name, b".") ||
       strcmp(&name, b"..") {
        unsafe { ITABLE.iunlockput(dp); }
        end_op();
        return Err("cannot unlink \".\" or \"..\"");
    }

    let ip;
    let mut poff = 0;
    // trick the compiler here
    unsafe {
        let shadow = &mut *(&dp as *const _ as *mut Inode);
        match shadow.dirloopup(&name, Some(&mut poff)) {
            Some(i) => ip = i,
            None => {
                unsafe { ITABLE.iunlockput(dp); }
                end_op();
                return Err("failed to find file");
            }
        }
    }
    ip.ilock();

    if ip.nlink < 1 {
        panic!("unlink: nlink < 1");
    }
    if ip.itype == InodeType::Directory && !ip.isDirEmpty() {
        // we shouldn't delete a directory that contains file
        unsafe { 
            ITABLE.iunlockput(ip);
            ITABLE.iunlockput(dp); 
        }
        end_op();
        return Err("failed to unlink non-empty directory");
    }

    // read the dir entry
    // FIXME: is this step necessary?
    // this is just a double check that we have this file
    // but we have already read it before
    let mut dir_entry = DirEntry::new();
    let dir_size = core::mem::size_of::<DirEntry>();

    // trick the compiler here
    unsafe {
        let shadow = &mut *(&dp as *const _ as *mut Inode);
        if shadow.writei(false,
                    &dir_entry as *const _ as usize, 
                    poff as usize, dir_size)
            .expect("unlink: writei") != dir_size {
            panic!("unlink: writei");
        }
    }
    
    ip.nlink -= 1;
    ip.iupdate();

    // remove the refcnt from child to parent
    if ip.itype == InodeType::Directory {
        dp.nlink -= 1;
        dp.iupdate();
    }

    unsafe {
        ITABLE.iunlockput(dp);
        ITABLE.iunlockput(ip);
    }

    end_op();

    Ok(())
}

pub fn sys_mkdir() -> Result<(), &'static str> {
    let mut path: [u8; MAXPATH] = [0; MAXPATH];
    argstr(0, &mut path, MAXPATH)?;

    begin_op();

    let ip;
    match create(&path, InodeType::Directory, 0, 0) {
        Some(i) => ip = i,
        None => {
            end_op();
            return Err("failed to create directory");
        }
    }
    unsafe { ITABLE.iunlockput(ip); }
    end_op();

    Ok(())
}

pub fn sys_chdir() -> Result<(), &'static str> {
    let mut path: [u8; MAXPATH] = [0; MAXPATH];
    let p = unsafe { &mut *myproc() };
    let ip;

    argstr(0, &mut path, MAXPATH)?;

    begin_op();
    match namei(&path) {
        Some(i) => ip = i,
        None => {
            end_op();
            return Err("failed to find path");
        }
    }

    ip.ilock();
    if ip.itype != InodeType::Directory {
        unsafe { ITABLE.iunlockput(ip) };
        end_op();
        return Err("path is not a directory");
    }

    ip.iunlock();
    unsafe {
        ITABLE.iput(&mut *p.cwd);
    }
    // keep in mind that iput should be wrapped into transaction
    end_op();

    p.cwd = ip;

    Ok(())
}

pub fn sys_fstat() -> Result<(), &'static str> {
    let mut f;
    let mut addr = 0;

    match argfd(0, None) {
        Some(file) => f = file,
        None => {
            return Err("failed to get argument");
        }
    }

    argaddr(1, &mut addr)?;

    if !f.filestat(addr) {
        return Err("failed to get file status");
    }

    Ok(())
}