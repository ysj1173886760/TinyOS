// Directory is a file containing a sequence of dirent structures
pub const DIRSIZ: usize = 14;

pub struct DirEntry {
    inum: u16,
    name: [u8; DIRSIZ],
}