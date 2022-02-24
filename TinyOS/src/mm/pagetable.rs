use crate::consts::riscv::{MAXVA, SATP_SV39, SV39FLAGLEN};

use super::{PGSHIFT, pg_round_down};

// use bitflags::bitflags;

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
#[derive(Clone, Copy)]
#[repr(transparent)]
struct PageTableEntry {
    data: usize,
}

impl PageTableEntry {
    #[inline]
    fn is_valid(&self) -> bool {
        self.data & (PteFlag::V as usize) > 0
    }

    #[inline]
    fn as_page_table(&self) -> *mut PageTable {
        ((self.data >> SV39FLAGLEN) << PGSHIFT) as *mut PageTable
    }

    #[inline]
    fn write_zero(&mut self) {
        self.data = 0;
    }

    #[inline]
    fn write(&mut self, pa: usize) {
        self.data = ((pa >> PGSHIFT) << SV39FLAGLEN) | (PteFlag::V as usize);
    }

    #[inline]
    fn write_perm(&mut self, pa: usize, perm: usize) {
        self.data = ((pa >> PGSHIFT) << SV39FLAGLEN) | (perm | PteFlag::V as usize);
    }

}

#[repr(C, align(4096))]
pub struct PageTable {
    data: [PageTableEntry; 512],
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
        SATP_SV39 | ((&self as *const _ as usize) >> PGSHIFT)
    }

    pub fn map_pages(
        &mut self,
        va: usize,
        size: usize,
        pa: usize,
        perm: usize,
    ) -> Result<(), &'static str> {
        let last = va + size;
        Ok(())
    }

    pub fn walk(&self, va: usize, alloc: bool) {

    }
}