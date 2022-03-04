use crate::{consts::param::{MAXPATH, MAXARG}, mm::{PGSIZE, free_pagetable, PageTable, KBox, pg_round_up}, process::{myproc, proc_manager, create_proc_pagetable}, fs::{begin_op, namei, end_op, ITABLE}};

use super::{elf::{ELFHeader, ELF_MAGIC, ProgramHeader, ELF_PROG_LOAD}, strlen};

pub fn exec(path: &mut [u8; MAXPATH], 
            argv: &mut [Option<[u8; PGSIZE]>; MAXARG]) 
            -> Result<u32, &'static str> {
    let mut ustack: [usize; MAXARG] = [0; MAXARG];
    let p = unsafe { &mut *myproc() };
    let mut sz = 0;

    begin_op();

    let ip;
    match namei(path) {
        Some(i) => {
            ip = i;
        }
        None => {
            end_op();
            return Err("failed to find elf file");
        }
    }

    ip.ilock();

    // FIXME: error handling here really sucks
    let elf = ELFHeader::new();
    // check ELF header
    let elf_size = core::mem::size_of::<ELFHeader>();
    match ip.readi(false, &elf as *const _ as usize, 0, elf_size) {
        Ok(size) => {
            if size != elf_size {
                unsafe { ITABLE.iunlockput(ip) };
                return Err("failed to read elf file");
            }
        },
        Err(err) => {
            unsafe { ITABLE.iunlockput(ip) };
            return Err("failed to read elf file");
        }
    }

    if elf.magic != ELF_MAGIC {
        unsafe { ITABLE.iunlockput(ip) };
        return Err("unmatch elf magic");
    }

    let mut pagetable;
    match create_proc_pagetable(p) {
        Ok(pgtbl) => {
            pagetable = pgtbl;
        }
        _ => {
            unsafe { ITABLE.iunlockput(ip) };
            return Err("failed to create pagetable");
        }
    }

    // load program into memory
    let mut off = elf.phoff as usize;
    let ph_size = core::mem::size_of::<ProgramHeader>();
    for i in 0..elf.phnum {
        let ph = ProgramHeader::new();
        match ip.readi(false, &ph as *const _ as usize, off, ph_size) {
            Ok(size) => {
                if size != ph_size {
                    free_pagetable(pagetable, sz);
                    unsafe { ITABLE.iunlockput(ip) };
                    return Err("failed to read program header");
                }
            }
            _ => {
                free_pagetable(pagetable, sz);
                unsafe { ITABLE.iunlockput(ip) };
                return Err("failed to read program header");
            }
        }

        if ph._type != ELF_PROG_LOAD {
            continue;
        }

        if ph.memsz < ph.filesz {
            free_pagetable(pagetable, sz);
            unsafe { ITABLE.iunlockput(ip) };
            return Err("file corruption");
        }

        if ph.vaddr + ph.memsz < ph.vaddr {
            free_pagetable(pagetable, sz);
            unsafe { ITABLE.iunlockput(ip) };
            return Err("file corruption");
        }

        let sz1 = pagetable.uvm_alloc(sz, (ph.vaddr + ph.memsz) as usize);
        // which is oldsz
        if sz1 == 0 {
            free_pagetable(pagetable, sz);
            unsafe { ITABLE.iunlockput(ip) };
            return Err("failed to allocate memory");
        }
        sz = sz1;

        if (ph.vaddr as usize % PGSIZE) != 0 {
            free_pagetable(pagetable, sz);
            unsafe { ITABLE.iunlockput(ip) };
            return Err("failed to align vaddr");
        }

        if !pagetable.loadseg(ph.vaddr as usize, ip, ph.off as usize, ph.filesz as usize) {
            free_pagetable(pagetable, sz);
            unsafe { ITABLE.iunlockput(ip) };
            return Err("failed to load seg");
        }

        off += ph_size;
    }

    // i can't see the reason why we are using transaction here
    // i see. anyone who might call iput should be wrapped in transaction
    // because iput may freeing inode and thus changing disk
    unsafe { ITABLE.iunlockput(ip) };
    end_op();

    let oldsz = p.sz;

    // Allocate two pages at the next page boundary
    // Use the second as the user stack
    sz = pg_round_up(sz);

    let sz1 = pagetable.uvm_alloc(sz, sz + 2 * PGSIZE);
    if sz1 == 0 {
        free_pagetable(pagetable, sz);
        return Err("failed to allocate memory 2");
    }

    sz = sz1;
    // make pte invalid
    // for guard page
    pagetable.uvm_clear(sz - 2 * PGSIZE);
    let mut sp = sz;
    let stackbase = sp - PGSIZE;

    // push argument strings, prepare rest of stack in ustack
    let mut argc = 0;
    while argv[argc].is_some() {
        let len = strlen(argv[argc].as_ref().unwrap()) + 1;
        sp -= len;
        sp -= sp % 16;  // riscv sp must be 16 aligned

        if sp < stackbase {
            free_pagetable(pagetable, sz);
            return Err("stackpointer overflow");
        }
        if pagetable.copyout(sp, argv[argc].as_ref().unwrap() as *const u8, len).is_err() {
            free_pagetable(pagetable, sz);
            return Err("failed to intialize argument");
        }

        ustack[argc] = sp;
        argc += 1;
    }
    ustack[argc] = 0;

    // push the array of argv[] pointers
    sp -= (argc + 1) * core::mem::size_of::<usize>();
    sp -= sp % 16;

    if sp < stackbase {
        free_pagetable(pagetable, sz);
        return Err("stackpointer overflow");
    }
    if pagetable.copyout(
        sp,
        ustack.as_ptr() as *const u8,
        (argc + 1) * core::mem::size_of::<usize>()
    ).is_err() {
        free_pagetable(pagetable, sz);
        return Err("failed to intialize ustack");
    }

    // arguments to user main(argc, argv)
    // argc is returned via the system call return
    // value, which goes in a0
    let trapframe = unsafe { &mut *p.trapframe };
    trapframe.a1 = sp;
    
    // TODO: save program name for debugging

    // commit to user image
    let oldpagetable = p.pagetable.take();
    p.pagetable = Some(pagetable);
    p.sz = sz;
    trapframe.epc = elf.entry as usize;  // initial program counter = main
    trapframe.sp = sp;  // initial stack pointer
    free_pagetable(oldpagetable.unwrap(), oldsz);

    return Ok(argc as u32);
}