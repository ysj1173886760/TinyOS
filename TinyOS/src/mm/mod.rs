pub use kalloc::{kalloc, kcount, kfree, kinit};
pub use kbox::KBox;

mod kalloc;
mod pagetable;
mod kbox;

const PGSIZE: usize = 4096;
const PGSHIFT: usize = 12;

#[inline]
fn pg_round_up(addr: usize) -> usize {
    (addr + PGSIZE - 1) & !(PGSIZE - 1)
}

#[inline]
fn pg_round_down(addr: usize) -> usize {
    addr & !(PGSIZE - 1)
}