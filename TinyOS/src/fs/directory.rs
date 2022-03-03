use crate::{consts::param::ROOTDEV, process::myproc};

use super::{file::DIRSIZ, inode::{Inode, ITABLE, FileType}, ROOTINO};

// Paths

// Copy the next path element from path into name.
// Return a pointer to the element following the copied one.
// The returned path has no leading slashes,
// so the caller can check *path=='\0' to see if the name is the last one.
// If no name to remove, return 0.
//
// Examples:
//   skipelem("a/bb/c", name) = "bb/c", setting name = "a"
//   skipelem("///a//bb", name) = "bb", setting name = "a"
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
pub fn skipelem(path: &[u8], mut cur: usize, name: &mut [u8; DIRSIZ]) -> usize {
    while path[cur] == b'/' {
        cur += 1;
    }

    if path[cur] == 0 {
        return 0;
    }

    let start = cur;
    while path[cur] != b'/' && path[cur] != 0 {
        cur += 1;
    }

    let mut count = cur - start;

    // we shouldn't allow that long path name
    if count >= name.len() {
        count = name.len() - 1;
    }
    unsafe {
        core::ptr::copy(
            path.as_ptr().add(start),
            name.as_mut_ptr(),
            count
        );
    }
    name[count] = 0;

    // skip succeeding /
    while path[cur] == b'/' {
        cur += 1;
    }
    cur
}

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
pub fn namex(path: &[u8], name: &mut [u8; DIRSIZ], nameiparent: bool)
    -> Option<&'static mut Inode> {
    let mut ip;
    if path[0] == b'/' {
        ip = unsafe { ITABLE.iget(ROOTDEV, ROOTINO) };
    } else {
        let proc = unsafe { &mut *myproc() };
        unsafe { 
            if proc.cwd.is_null() {
                panic!("failed to get cwd");
            }
            let cwd = &mut *proc.cwd;
            ITABLE.idup(cwd);
            ip = cwd;
        }
    }

    let mut cur = 0;
    loop {
        cur = skipelem(path, cur, name);
        if cur == 0 {
            break;
        }

        ip.ilock();
        if ip._type != FileType::Directory {
            unsafe { ITABLE.iunlockput(ip); }
            return None;
        }
        if nameiparent && path[cur] == b'\0' {
            // Stop one level early
            ip.iunlock();
            return Some(ip);
        }
        let next = ip.dirloopup(name, None);
        if next.is_none() {
            unsafe { ITABLE.iunlockput_leak(ip); }
            return None;
        }

        unsafe { ITABLE.iunlockput_leak(ip); }
        ip = next.unwrap();
    }

    if nameiparent {
        unsafe { ITABLE.iput(ip) };
        return None;
    }
    
    Some(ip)
}

pub fn namei(path: &[u8]) -> Option<&'static mut Inode> {
    let mut name = [0; DIRSIZ];
    return namex(path, &mut name, false);
}

pub fn nameiparent(path: &[u8], name: &mut [u8; DIRSIZ])
    -> Option<&'static mut Inode> {
    return namex(path, name, true);
}