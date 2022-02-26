use crate::consts::{riscv::{MAXVA, SATP_SV39, SV39FLAGLEN}};
use super::{PGSHIFT, pg_round_down, KBox, PGSIZE, kfree, kalloc};
use core::ptr;

#[repr(usize)]
pub enum PteFlag {
    V = 1 << 0,
    R = 1 << 1,
    W = 1 << 2,
    X = 1 << 3,
    U = 1 << 4,
    G = 1 << 5,
    A = 1 << 6,
    D = 1 << 7,
}

// transparent allow us to convert entry to data
#[derive(Debug)]
#[derive(Clone, Copy)]
#[repr(transparent)]
pub struct PageTableEntry {
    data: usize,
}

impl PageTableEntry {
    #[inline]
    pub fn is_valid(&self) -> bool {
        self.data & (PteFlag::V as usize) > 0
    }

    #[inline]
    pub fn is_user(&self) -> bool {
        self.data & (PteFlag::U as usize) > 0
    }

    #[inline]
    pub fn flags(&self) -> usize {
        self.data & 0x3FF
    }

    // because pa-entrys will either have X flag(text), or have W flag(data)
    // if an entry only has valid flag, then it means this entry is pointing to another pagetable, but not pa
    #[inline]
    pub fn is_page_table(&self) -> bool {
        self.is_valid() && (self.data & (PteFlag::X as usize | PteFlag::R as usize | PteFlag::W as usize)) == 0
    }

    #[inline]
    pub fn as_page_table(&self) -> *mut PageTable {
        ((self.data >> SV39FLAGLEN) << PGSHIFT) as *mut PageTable
    }

    #[inline]
    pub fn as_pa(&self) -> usize {
        ((self.data >> SV39FLAGLEN) << PGSHIFT) as usize
    }

    #[inline]
    pub fn write_zero(&mut self) {
        self.data = 0;
    }

    #[inline]
    pub fn write(&mut self, pa: usize) {
        self.data = ((pa >> PGSHIFT) << SV39FLAGLEN) | (PteFlag::V as usize);
    }

    #[inline]
    pub fn write_perm(&mut self, pa: usize, perm: usize) {
        self.data = ((pa >> PGSHIFT) << SV39FLAGLEN) | (perm | PteFlag::V as usize);
    }

}

const PXMASK: usize = 0x1FF;

#[inline]
fn px_shift(level: usize) -> usize {
    PGSHIFT + (9 * level)
}

#[inline]
fn px(level: usize, va: usize) -> usize {
    (va >> px_shift(level)) & PXMASK
}

#[repr(C, align(4096))]
pub struct PageTable {
    pub data: [PageTableEntry; 512],
}

impl PageTable {
    pub const fn empty() -> Self {
        Self {
            data: [PageTableEntry { data: 0 }; 512],
        }
    }

    pub fn clear(&mut self) {
        for pte in self.data.iter_mut() {
            pte.write_zero();
        }
    }

    pub unsafe fn as_satp(&self) -> usize {
        // a trap here, you shouldn't use &self's address, instead, you should use self's address
        // because self is a reference it's self
        SATP_SV39 | ((self as *const _ as usize) >> PGSHIFT)
    }

    // Return the address of the PTE in page table pagetable
    // that corresponds to virtual address va.  If alloc!=0,
    // create any required page-table pages.
    //
    // The risc-v Sv39 scheme has three levels of page-table
    // pages. A page-table page contains 512 64-bit PTEs.
    // A 64-bit virtual address is split into five fields:
    //   39..63 -- must be zero.
    //   30..38 -- 9 bits of level-2 index.
    //   21..29 -- 9 bits of level-1 index.
    //   12..20 -- 9 bits of level-0 index.
    //    0..11 -- 12 bits of byte offset within the page.
    pub fn walk(&mut self, va: usize, alloc: bool) -> Option<&mut PageTableEntry> {
        if va > MAXVA {
            panic!("walk");
        }

        let mut pgtbl = self;
        for level in (1..=2).rev() {
            let pte = &mut pgtbl.data[px(level, va)];
            if pte.is_valid() {
                unsafe {
                    pgtbl = &mut *pte.as_page_table();
                }
            } else {
                if !alloc {
                    return None;
                }
                match KBox::<PageTable>::new() {
                    Some(mut new_page_table) => {
                        new_page_table.clear();
                        unsafe {
                            // we have to move the ownership and convert it to pointer
                            // otherwise, new_page_table will be destructed when leaving the scope
                            let ptr = new_page_table.into_raw();
                            pgtbl = &mut *ptr;
                            pte.write(ptr as usize);
                        }
                    },
                    None => return None,
                }
            }
        }
        Some(&mut pgtbl.data[px(0, va)])
    }

    // Look up a virtual address, return the physical address,
    // or 0 if not mapped.
    // Can only be used to look up user pages.
    pub fn walkaddr(&mut self, va: usize) -> Result<usize, &'static str> {
        if va > MAXVA {
            panic!("walkaddr");
        }

        let pte = self.walk(va, false);
        match pte {
            None => Err("failed to find va"),
            Some(entry) => {
                if !entry.is_valid() {
                    return Err("pte is not valid");
                }
                if !entry.is_user() {
                    return Err("pte is not user pages");
                }
                Ok(entry.as_pa())
            },
        }
    }

    // Create PTEs for virtual addresses starting at va that refer to
    // physical addresses starting at pa. va and size might not
    // be page-aligned. Returns 0 on success, -1 if walk() couldn't
    // allocate a needed page-table page.
    pub fn map_pages(&mut self, va: usize, size: usize, mut pa: usize, perm: usize) -> Result<(), &'static str> {
        if size == 0 {
            panic!("mappages: size");
        }

        let mut a = pg_round_down(va);
        let last = pg_round_down(va + size - 1);

        loop {
            let pte;
            match self.walk(a, true) {
                Some(entry) => pte = entry,
                None => return Err("walk failed"),
            }

            if pte.is_valid() {
                panic!("mappages: remap");
            }

            pte.write_perm(pa, perm);

            if a == last {
                break;
            }

            a += PGSIZE;
            pa += PGSIZE;
        }

        Ok(())
    }

    // create an empty user page table.
    // returns 0 if out of memory.
    pub fn uvm_create() -> Option<KBox<PageTable>> {
        match KBox::<PageTable>::new() {
            Some(mut pgtbl) => {
                pgtbl.clear();
                Some(pgtbl)
            },
            None => None,
        }
    }

    // Remove npages of mappings starting from va. va must be
    // page-aligned. The mappings must exist.
    // Optionally free the physical memory.
    pub fn uvm_unmap(&mut self, va: usize, npages: usize, do_free: bool) {
        if va % PGSIZE != 0 {
            panic!("uvmunmap: page not aligned");
        }

        let mut a = va;
        while a < va + npages * PGSIZE {
            let pte = self.walk(a, false);
            
            match pte {
                Some(entry) => {
                    if !entry.is_valid() {
                        panic!("uvmunmap: not mapped");
                    }
                    if entry.flags() == PteFlag::V as usize {
                        panic!("uvmunmap: not leaf");
                    }
                    if do_free {
                        kfree(entry.as_pa());
                    }
                    entry.write_zero();
                },
                None => {
                    panic!("uvmunmap: walk");
                }
            }

            a += PGSIZE;
        }
    }

    fn print_helper(&self, level: usize) {
        for i in 0..self.data.len() {
            if self.data[i].is_valid() {
                crate::print!("{} ", i);
                for j in 0..(3 - level) {
                    crate::print!("..");
                }
                crate::println!("{:#x}", self.data[i].as_pa());

                if level > 0 {
                    unsafe {
                        (*self.data[i].as_page_table()).print_helper(level - 1);
                    }
                }
            }
        }
    }

    pub fn print(&self) {
        self.print_helper(2);
    }

    pub fn uvminit(&mut self, code: &[u8]) {
        if code.len() >= PGSIZE {
            panic!("inituvm: more than a page");
        }

        match kalloc() {
            Some(ptr) => {
                unsafe {
                    // memset to zero
                    ptr::write_bytes(ptr as *mut u8, 0, PGSIZE);
                }
                self.map_pages(0, PGSIZE, ptr, PteFlag::R as usize |
                                                                PteFlag::W as usize |
                                                                PteFlag::X as usize |
                                                                PteFlag::U as usize);
                unsafe {
                    // copy the code
                    ptr::copy_nonoverlapping(code.as_ptr(), ptr as *mut u8, code.len());
                }
            },
            None => {
                panic!("failed to allocate page for initcode");
            }
        }
    }
}