use crate::{consts::{memlayout::{UART0, VIRTIO0, PLIC, KERNBASE, PHYSTOP, TRAMPOLINE, TRAPFRAME, KSTACK}, param::{NPROC, KSTACKPAGE}}, riscv::{w_satp, sfence_vma}};

use super::{PageTable, kfree, PGSIZE, pagetable::PteFlag, kalloc, pg_round_up};
use super::KBox;

static mut kernel_pagetable: PageTable = PageTable::empty();

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
pub unsafe fn freewalk(pgtbl: *mut PageTable) {
    for i in 0..512 {
        let entry = &mut (*pgtbl).data[i];
        if entry.is_page_table() {
            let child = entry.as_page_table();
            freewalk(child);
            entry.write_zero();
        } else if entry.is_valid() {
            // we shouldn't touch the leaf since all of it has already been freed
            panic!("freewalk: leaf");
        }
    }
    // free the current pagetable now
    kfree(pgtbl as usize);
}

// Free user memory pages,
// then free page-table pages.
pub fn uvm_free(pgtbl: *mut PageTable, sz: usize) {
    if sz > 0 {
        unsafe {
            (*pgtbl).uvm_unmap(0, pg_round_up(sz) / PGSIZE, true)
        }
    }
    unsafe {
        freewalk(pgtbl);
    }
}

// the kernel's page table.

extern "C" {
    fn etext();
    fn trampoline();
}

// add a mapping to the kernel page table.
// only used when booting.
// does not flush TLB or enable paging.
pub fn kvmmap(va: usize, pa: usize, size: usize, perm: usize) {
    // crate::println!("kvm_map va:{:#x} pa:{:#x} size:{}", va, pa, size);

    unsafe {
        if let Err(err) = kernel_pagetable.map_pages(va, size, pa, perm) {
            panic!("kvmmap {}", err);
        }
    }
}

pub fn kvminit() {
    crate::println!("initializing direct mapping");
    // uart registers
    kvmmap(UART0, UART0, PGSIZE, PteFlag::R as usize | PteFlag::W as usize);

    // virtio mmio disk interface
    kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PteFlag::R as usize | PteFlag::W as usize);

    // PLIC
    kvmmap(PLIC, PLIC, 0x400000, PteFlag::R as usize | PteFlag::W as usize);

    // map kernel text executable and read-only.
    kvmmap(KERNBASE, KERNBASE, etext as usize - KERNBASE, PteFlag::R as usize | PteFlag::X as usize);

    // map kernel data and the physical RAM we'll make use of.
    kvmmap(etext as usize, etext as usize, PHYSTOP - etext as usize, PteFlag::R as usize | PteFlag::W as usize);

    // map the trampoline for trap entry/exit to
    // the highest virtual address in the kernel.
    kvmmap(TRAMPOLINE, trampoline as usize, PGSIZE, PteFlag::R as usize | PteFlag::X as usize);

    // map kernel stacks
    proc_mapstacks();
}

pub fn kvminithart() {
    unsafe {
        w_satp(kernel_pagetable.as_satp());
    }
    sfence_vma();
}

pub fn proc_mapstacks() {
    crate::println!("mapping kernel stasks");
    for i in 0..NPROC {
        for j in 0..KSTACKPAGE {
            match kalloc() {
                Some(pa) => {
                    kvmmap(KSTACK(i) + j * PGSIZE, pa, PGSIZE, PteFlag::R as usize | PteFlag::W as usize);
                },
                None => {
                    panic!("proc_mapstacks");
                }
            }
        }
    }
}

// Free a process's page table, and free the
// physical memory it refers to.
// We guarantee pagetable is valid
pub fn free_pagetable(mut pagetable: KBox<PageTable>, sz: usize) {
    pagetable.uvm_unmap(TRAMPOLINE, 1, false);
    pagetable.uvm_unmap(TRAPFRAME, 1, false);
    uvm_free(pagetable.into_raw(), sz);
}