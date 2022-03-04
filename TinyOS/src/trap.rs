use crate::{consts::{memlayout::{TRAMPOLINE, TRAPFRAME, UART0_IRQ, VIRTIO0_IRQ}}, riscv::{w_stvec, SSTATUS_SPP, r_sstatus, r_sepc, r_scause, intr_on, r_stval, intr_off, r_satp, r_tp, SSTATUS_SPIE, w_sstatus, w_sepc, intr_get, w_sip, r_sip}, process::{myproc, cpuid, mycpu}, mm::PGSIZE, plic::{plic_claim, plic_complete}, uart::uartintr, driver::DISK, syscall::syscall};

extern "C" {
    fn kernelvec();
    fn uservec();
    fn userret();
    fn trampoline();
}

pub fn trap_init_hart() {

    w_stvec(kernelvec as usize);
}

enum ScauseType {
    Unknown,
    IntSSoft,
    IntSExt,
    Ecall,
}

const INTERRUPT: usize = 0x8000000000000000;
const INTERRUPT_S_SOFT: usize = INTERRUPT + 1;
const INTERRUPT_S_EXT: usize = INTERRUPT + 9;

fn get_scause() -> ScauseType {
    match r_scause() {
        8 => ScauseType::Ecall,
        INTERRUPT_S_SOFT => ScauseType::IntSSoft,
        INTERRUPT_S_EXT => ScauseType::IntSExt,
        _ => ScauseType::Unknown
    }
}

//
// handle an interrupt, exception, or system call from user space.
// called from trampoline.S
//
#[no_mangle]
pub extern fn usertrap() {
    if (r_sstatus() & SSTATUS_SPP) != 0 {
        panic!("usertrap: not from user mode");
    }

    // send interrupts and exceptions to kerneltrap
    // since we're now in the kernel
    w_stvec(kernelvec as usize);
    
    let p = unsafe { &mut *myproc() };
    // save user program counter
    unsafe {
        (&mut (*p.trapframe)).epc = r_sepc();
    }

    match get_scause() {
        ScauseType::Ecall => {
            // system call

            p.check_exit(-1);

            // sepc points to the ecall instruction,
            // but we want to return to the next instruction.
            unsafe {
                (&mut (*p.trapframe)).epc += 4;
            }

            // an interrupt will change sstatus &c registers,
            // so don't enable until done with those registers.
            intr_on();

            syscall();
        }

        ScauseType::IntSExt => {
            handle_plic();
        }

        ScauseType::IntSSoft => {
            handle_timer();

            p.check_exit(-1);

            // then yield the cpu
            unsafe {
                (&mut *mycpu()).yield_proc();
            }
        }

        ScauseType::Unknown => {
            crate::println!("usertrap(): unexpected scause {:#x} pid={}", r_scause(), p.pid);
            crate::println!("            sepc={:#x} stval={:#x}", r_sepc(), r_stval());
            p.killed = true;
        }
    }

    p.check_exit(-1);

    usertrapret();
}

//
// return to user space
//
pub fn usertrapret() {
    let p = unsafe { &mut *myproc() };

    // we're about to switch the destination of traps from
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts and exception to trampoline.S
    w_stvec(TRAMPOLINE + (uservec as usize - trampoline as usize));

    // set up trapframe values that uservec will need when
    // the process next re-enters the kernel.
    let trapframe = unsafe { &mut *p.trapframe };
    trapframe.kernel_satp = r_satp();           // kernel page table
    trapframe.kernel_sp = p.kstack + PGSIZE;    // process's kernel stack
    trapframe.kernel_trap = usertrap as usize;
    trapframe.kernel_hartid = r_tp();           // hartid for cpuid()

    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Previlege mode to User
    let mut x = r_sstatus();
    x &= !SSTATUS_SPP;  // clear SPP to 0 for user mode
    x |= SSTATUS_SPIE;  // enable interrupts in user mode
    w_sstatus(x);

    // set S Exception Program Counter 
    w_sepc(trapframe.epc);

    // tell trampoline.S the user page table to switch to
    let satp = unsafe { p.pagetable.as_ref().unwrap().as_satp() };
    let dis = userret as usize - trampoline as usize;
    let userret_virt: extern "C" fn(usize, usize) -> ! =
        unsafe { core::mem::transmute(TRAMPOLINE + dis) };
    // jump to trampoline.S at the top of memory, which 
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    userret_virt(TRAPFRAME, satp);
}

// interrupts and exceptions from kernel code go here via kernelvec,
// on whatever the current kernel stack is.
#[no_mangle]
pub extern fn kerneltrap() {
    let sepc = r_sepc();
    let sstatus = r_sstatus();
    let scause = r_scause();

    if (sstatus & SSTATUS_SPP) == 0 {
        panic!("kerneltrap: not from supervisor mode");
    }

    if intr_get() {
        panic!("kerneltrap: interrupts enabled");
    }

    // handle device interrupt here
    match get_scause() {
        ScauseType::Ecall => {
            panic!("ecall from supervisor mode");
        }

        ScauseType::IntSExt => {
            handle_plic();
        }

        ScauseType::IntSSoft => {
            handle_timer();
            // in kernel mode, we may not have running proc, so we need to check here
            
            // yield proc will help us checking whether we should yield
            unsafe {
                (&mut *mycpu()).yield_proc();
            }
        }

        ScauseType::Unknown => {
            crate::println!("kerneltrap(): unexpected scause {:#x}", r_scause());
            crate::println!("              sepc={:#x} stval={:#x}", r_sepc(), r_stval());
            panic!("kerneltrap(): unknown trap type");
        }
    }

    w_sepc(sepc);
    w_sstatus(sstatus);
}

fn handle_timer() {
    // software interrupt from a machine-mode timer interrupt,
    // forwarded by timervec in kernelvec.S.

    if cpuid() == 0 {
        // TODO: tick here
    }

    // acknowledge the software interrupt by clearing
    // the SSIP bit in sip.
    w_sip(r_sip() & !2);
}

fn handle_plic() {
    // this is a supervisor external interrupt, via PLIC.

    let irq = plic_claim();
    if irq as usize == UART0_IRQ {
        uartintr();
    } else if irq as usize == VIRTIO0_IRQ {
        unsafe { DISK.intr() }
    } else if irq != 0 {
        crate::println!("unexpected interrupt irq {}", irq);
    }

    if irq != 0 {
        plic_complete(irq);
    }
}