use array_macro::array;

use crate::{spinlock::SpinLock, consts::param::{NFILE, NDEV}, process::myproc};

use super::{Inode, log::{begin_op, end_op}, inode::{ITABLE, Stat}, device::{DEVSW, Device}};

#[derive(PartialEq, Eq, Clone, Copy)]
pub enum FileType {
    None = 0,
    Pipe = 1,
    Inode = 2,
    Device = 3,
}

pub struct File {
    ftype: FileType,
    refcnt: usize,
    readable: bool,
    writable: bool,
    // TODO: implement pipe here
    // Inode and Device
    ip: Option<&'static mut Inode>,
    off: usize,
    // Device
    major: u16,
}

pub struct FileTable {
    lock: SpinLock<()>,
    file: [File; NFILE],
}

impl FileTable {
    pub fn new() -> Self {
        Self {
            lock: SpinLock::new((), "ftable"),
            file: array![_ => File::new(); NFILE],
        }
    }

    // Allocate a file structure
    pub fn filealloc(&mut self) -> Option<&mut File> {
        self.lock.acquire();
        for f in 0..NFILE {
            if self.file[f].refcnt == 0 {
                self.file[f].refcnt = 1;
                self.lock.release();
                return Some(&mut self.file[f]);
            }
        }
        self.lock.release();
        None
    }

    // Increment ref count for file f
    // since input and output it's same, so we don't return here
    pub fn filedup(&mut self, f: &mut File) {
        self.lock.acquire();
        if f.refcnt < 1 {
            panic!("filedup");
        }
        f.refcnt += 1;
        self.lock.release();
    }

    // Close file f. Decrement ref count, close when reached 0
    pub fn filecose(&mut self, f: &mut File) {
        self.lock.acquire();
        if f.refcnt < 1 {
            panic!("fileclose");
        }
        f.refcnt -= 1;
        if f.refcnt > 0 {
            self.lock.release();
            return;
        }

        // otherwise, we close file
        let ip = f.ip.take();
        let ftype = f.ftype;
        self.lock.release();

        if ftype == FileType::Pipe {
            panic!("not implemented");
        } else if ftype == FileType::Inode ||
                  ftype == FileType::Device {
            begin_op();
            unsafe { ITABLE.iput(ip.unwrap()) };
            end_op();
        }
    }

}

impl File {
    pub fn new() -> Self {
        Self {
            ftype: FileType::None,
            refcnt: 0,
            readable: false,
            writable: false,
            ip: None,
            off: 0,
            major: 0,
        }
    }

    // Get metadata about file f
    // addr is a user virtual address, pointing to a struct stat
    pub fn filestat(&mut self, addr: usize) -> bool {
        let p = unsafe { &mut *myproc() };
        if self.ftype == FileType::Inode ||
            self.ftype == FileType::Device {
            let st = self.get_stat();
            if p.pagetable
                .as_mut()
                .expect("failed to find pagetable")
                .copyout(
                    addr,
                    &st as *const _ as *const u8,
                    core::mem::size_of::<Stat>(),
                ).is_err() {
                return false;
            }
            return true;
        }
        false
    }

    // helper function for filestat
    fn get_stat(&mut self) -> Stat {
        let ip = self.ip.as_mut().expect("failed to get inode");
        (*ip).ilock();
        let st = Stat::from_inode(ip);
        (*ip).iunlock();

        return st;
    }

    // Read from file f
    // addr is a user virtual address
    pub fn fileread(&mut self, addr: usize, n: usize)
        -> Result<usize, &'static str> {
        if !self.readable {
            return Err("file is un-readable");
        }

        match self.ftype {
            FileType::Pipe => {
                panic!("not implemented");
            }
            FileType::Inode => {
                let ip = self.ip.as_mut().expect("failed to get inode");
                ip.ilock();
                match ip.readi(true, addr, self.off, n) {
                    Ok(off) => {
                        self.off += off;
                        return Ok(off);
                    },
                    Err(err) => {
                        return Err(err);
                    }
                }
            }
            FileType::Device => {
                if self.major < 0 || 
                    self.major >= NDEV as u16 || 
                    unsafe { !DEVSW[self.major as usize].is_none() } {
                    return Err("wrong major");
                }
                let read = unsafe { 
                    DEVSW[self.major as usize].as_ref().unwrap().read
                };
                return read(true, addr, n);
            }
            _ => {
                panic!("fileread");
            }
        }
    }
}
