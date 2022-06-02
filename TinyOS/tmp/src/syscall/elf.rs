// Format of an ELF executable file

// "\x7FELF" in little endian
pub const ELF_MAGIC: u32 = 0x464c457F;

// File header
#[repr(C)]
pub struct ELFHeader {
    pub magic: u32, // must equal ELF_MAGIC
    pub elf: [u8; 12],
    pub _type: u16,
    pub machine: u16,
    pub version: u32,
    pub entry: u64,
    pub phoff: u64,
    pub flags: u32,
    pub ehsize: u16,
    pub phentsize: u16,
    pub phnum: u16,
    pub shentsize: u16,
    pub shnum: u16,
    pub shstrndx: u16,
}

impl ELFHeader {
    pub fn new() -> Self {
        Self {
            magic: 0,
            elf: [0; 12],
            _type: 0,
            machine: 0,
            version: 0,
            entry: 0,
            phoff: 0,
            flags: 0,
            ehsize: 0,
            phentsize: 0,
            phnum: 0,
            shentsize: 0,
            shnum: 0,
            shstrndx: 0,
        }
    }
}

// Program section header
#[repr(C)]
pub struct ProgramHeader {
    pub _type: u32,
    pub flags: u32,
    pub off: u64,
    pub vaddr: u64,
    pub paddr: u64,
    pub filesz: u64,
    pub memsz: u64,
    pub align: u64,
}

impl ProgramHeader {
    pub fn new() -> Self {
        Self {
            _type: 0,
            flags: 0,
            off: 0,
            vaddr: 0,
            paddr: 0,
            filesz: 0,
            memsz: 0,
            align: 0,
        }
    }
}

// Values for Proghdr type
pub const ELF_PROG_LOAD: u32 = 1;

// Flag bits for Proghdr flags
pub const ELF_PROG_FLAG_EXEC: u32 = 1;
pub const ELF_PROG_FLAG_WRITE: u32 = 2;
pub const ELF_PROG_FLAG_READ: u32 = 4;