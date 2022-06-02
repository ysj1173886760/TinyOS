#[repr(C)]
pub struct TrapFrame {
    /*   0 */ pub kernel_satp: usize,   // kernel page table
    /*   8 */ pub kernel_sp: usize,     // top of process's kernel stack
    /*  16 */ pub kernel_trap: usize,   // usertrap()
    /*  24 */ pub epc: usize,           // saved user program counter
    /*  32 */ pub kernel_hartid: usize, // saved kernel tp
    /*  40 */ pub ra: usize,
    /*  48 */ pub sp: usize,
    /*  56 */ pub gp: usize,
    /*  64 */ pub tp: usize,
    /*  72 */ pub t0: usize,
    /*  80 */ pub t1: usize,
    /*  88 */ pub t2: usize,
    /*  96 */ pub s0: usize,
    /* 104 */ pub s1: usize,
    /* 112 */ pub a0: usize,
    /* 120 */ pub a1: usize,
    /* 128 */ pub a2: usize,
    /* 136 */ pub a3: usize,
    /* 144 */ pub a4: usize,
    /* 152 */ pub a5: usize,
    /* 160 */ pub a6: usize,
    /* 168 */ pub a7: usize,
    /* 176 */ pub s2: usize,
    /* 184 */ pub s3: usize,
    /* 192 */ pub s4: usize,
    /* 200 */ pub s5: usize,
    /* 208 */ pub s6: usize,
    /* 216 */ pub s7: usize,
    /* 224 */ pub s8: usize,
    /* 232 */ pub s9: usize,
    /* 240 */ pub s10: usize,
    /* 248 */ pub s11: usize,
    /* 256 */ pub t3: usize,
    /* 264 */ pub t4: usize,
    /* 272 */ pub t5: usize,
    /* 280 */ pub t6: usize,
}

impl TrapFrame {
    pub fn copy_from(&mut self, old: &TrapFrame) {
        self.ra = old.ra;
        self.sp = old.sp;
        self.gp = old.gp;
        self.tp = old.tp;
        self.t0 = old.t0;
        self.t1 = old.t1;
        self.t2 = old.t2;
        self.s0 = old.s0;
        self.s1 = old.s1;
        self.a0 = old.a0;
        self.a1 = old.a1;
        self.a2 = old.a2;
        self.a3 = old.a3;
        self.a4 = old.a4;
        self.a5 = old.a5;
        self.a6 = old.a6;
        self.a7 = old.a7;
        self.s2 = old.s2;
        self.s3 = old.s3;
        self.s4 = old.s4;
        self.s5 = old.s5;
        self.s6 = old.s6;
        self.s7 = old.s7;
        self.s8 = old.s8;
        self.s9 = old.s9;
        self.s1 = old.s1;
        self.s1 = old.s1;
        self.t3 = old.t3;
        self.t4 = old.t4;
        self.t5 = old.t5;
        self.t6 = old.t6;
        self.kernel_satp = old.kernel_satp;
        self.kernel_sp = old.kernel_sp;
        self.kernel_trap = old.kernel_trap;
        self.epc = old.epc;
        self.kernel_hartid = old.kernel_hartid;
    }

}