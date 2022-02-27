use core::ptr;

use crate::{consts::memlayout::{PLIC, UART0_IRQ, VIRTIO0_IRQ, PLIC_SENABLE, PLIC_SPRIORITY, PLIC_SCLAIM}, process::cpuid};

#[inline]
fn write_volatile(addr: usize, value: u32) {
    unsafe {
        // write_volatile is aimed for IO mapping
        ptr::write_volatile(addr as *mut u32, value);
    }
}

#[inline]
fn read_volatile(addr: usize) -> u32 {
    unsafe {
        ptr::read_volatile(addr as *mut u32)
    }
}

pub fn plicinit() {
    // set desired IRQ priorities non-zero (otherwise disabled).
    write_volatile(PLIC  + UART0_IRQ * 4, 1);
    write_volatile(PLIC + VIRTIO0_IRQ * 4, 1);
}

pub fn plicinithart() {
    let hart = cpuid();
    // set uart's enable bit for this hart's S-mode. 
    write_volatile(PLIC_SENABLE(hart), (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ));

    // set this hart's S-mode priority threshold to 0.
    write_volatile(PLIC_SPRIORITY(hart), 0)
}

// ask the PLIC what interrupt we should serve.
pub fn plic_claim() -> u32 {
    let hart = cpuid();
    read_volatile(PLIC_SCLAIM(hart))
}

// tell the PLIC we've served this IRQ
pub fn plic_complete(irq: u32) {
    let hart = cpuid();
    write_volatile(PLIC_SCLAIM(hart), irq);
}