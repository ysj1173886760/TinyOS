pub use kalloc::{kalloc, kcount, kfree, kinit};
pub use kbox::KBox;
pub use pagetable::{PageTable, PteFlag};
pub use vm::{kvminit, kvminithart, uvm_free, free_pagetable};

mod kalloc;
mod pagetable;
mod kbox;
mod vm;

pub const PGSIZE: usize = 4096;
pub const PGSHIFT: usize = 12;

#[inline]
pub fn pg_round_up(addr: usize) -> usize {
    (addr + PGSIZE - 1) & !(PGSIZE - 1)
}

#[inline]
pub fn pg_round_down(addr: usize) -> usize {
    addr & !(PGSIZE - 1)
}