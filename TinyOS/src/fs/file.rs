// Directory is a file containing a sequence of dirent structures
pub const DIRSIZ: usize = 14;

#[repr(C)]
pub struct DirEntry {
    pub inum: u16,
    pub name: [u8; DIRSIZ],
}

impl DirEntry {
    pub fn new() -> Self {
        Self {
            inum: 0,
            name: [0; DIRSIZ],
        }
    }
}