use array_macro::array;
use crate::{spinlock::SpinLock, mm::{PGSIZE, PGSHIFT}, consts::memlayout::VIRTIO0, process::{proc_manager, myproc}, fs::{Buf, BSIZE}};
use core::{ptr, sync::atomic::{fence, Ordering}};

const NUM: usize = 8;

const VIRTIO_MMIO_MAGIC_VALUE: usize = 0x000;
const VIRTIO_MMIO_VERSION: usize = 0x004;
const VIRTIO_MMIO_DEVICE_ID: usize = 0x008;
const VIRTIO_MMIO_VENDOR_ID: usize = 0x00c;
const VIRTIO_MMIO_DEVICE_FEATURES: usize = 0x010;
const VIRTIO_MMIO_DRIVER_FEATURES: usize = 0x020;
const VIRTIO_MMIO_GUEST_PAGE_SIZE: usize = 0x028;
const VIRTIO_MMIO_QUEUE_SEL: usize = 0x030;
const VIRTIO_MMIO_QUEUE_NUM_MAX: usize = 0x034;
const VIRTIO_MMIO_QUEUE_NUM: usize = 0x038;
const VIRTIO_MMIO_QUEUE_ALIGN: usize = 0x03c;
const VIRTIO_MMIO_QUEUE_PFN: usize = 0x040;
const VIRTIO_MMIO_QUEUE_READY: usize = 0x044; 
const VIRTIO_MMIO_QUEUE_NOTIFY: usize = 0x050;
const VIRTIO_MMIO_INTERRUPT_STATUS: usize = 0x060;
const VIRTIO_MMIO_INTERRUPT_ACK: usize = 0x064;
const VIRTIO_MMIO_STATUS: usize = 0x070;

// virtio status register bits, from qemu's virtio_config.h
const VIRTIO_CONFIG_S_ACKNOWLEDGE: u32 = 1;
const VIRTIO_CONFIG_S_DRIVER: u32 = 2;
const VIRTIO_CONFIG_S_DRIVER_OK: u32 = 4;
const VIRTIO_CONFIG_S_FEATURES_OK: u32 = 8;

// device feature bits
const VIRTIO_BLK_F_RO: u8 = 5;              // disk is read-only
const VIRTIO_BLK_F_SCSI: u8 = 7;            // supports scsi command passthru
const VIRTIO_BLK_F_CONFIG_WCE: u8 = 11;     // writeback mode available in config
const VIRTIO_BLK_F_MQ: u8 = 12;             // support more than one vq
const VIRTIO_F_ANY_LAYOUT: u8 = 27;
const VIRTIO_RING_F_INDIRECT_DESC: u8 = 28;
const VIRTIO_RING_F_EVENT_IDX: u8 = 29;

pub static mut DISK: Disk = Disk::new();

// from xv6
// the virtio driver and device mostly communicate through a set of
// structures in RAM. pages[] allocates that memory. pages[] is a
// global (instead of calls to kalloc()) because it must consist of
// two contiguous pages of page-aligned physical memory.

// pages[] is divided into three regions (descriptors, avail, and
// used), as explained in Section 2.6 of the virtio specification
// for the legacy interface.
// https://docs.oasis-open.org/virtio/virtio/v1.1/virtio-v1.1.pdf

// the first region of pages[] is a set (not a ring) of DMA
// descriptors, with which the driver tells the device where to read
// and write individual disk operations. there are NUM descriptors.
// most commands consist of a "chain" (a linked list) of a couple of
// these descriptors.

// next is a ring in which the driver writes descriptor numbers
// that the driver would like the device to process.  it only
// includes the head descriptor of each chain. the ring has
// NUM elements.

// finally a ring in which the device writes descriptor numbers that
// the device has finished processing (just the head of each chain).
// there are NUM used ring entries.
// points into pages[].
#[repr(C, align(4096))]
pub struct Disk {
    // first page
    pad1: Pad,
    desc: [Descriptor; NUM],
    avail: Avail,
    // second page
    pad2: Pad,
    used: Used,
    // our own book-keeping
    pad3: Pad,
    free: [bool; NUM],  // is a descriptor free?
    used_idx: u16,      // we've looked this for in used[2..NUM]

    // track info about in-flight operations,
    // for use when completion interrupt arrives.
    // indexed by first descriptor index of chain.
    info: [Info; NUM],

    // disk command headers
    // one-for-one with descriptors, for convenience
    ops: [BlkReq; NUM],

    lock: SpinLock<()>,
}

#[repr(C)]
struct Info {
    // disk rw op stores the sleep channel in it.
    // disk intr op retrieves it to wake up the waiting proc
    buf_channel: Option<usize>,
    status: u8,
}

// align to 4096
#[repr(C, align(4096))]
struct Pad();

#[repr(C)]
struct Descriptor {
    addr: u64,
    len: u32,
    flags: u16,
    next: u16,
}

const VRING_DESC_F_NEXT: u16 = 1;
const VRING_DESC_F_WRITE: u32 = 2;

// the (entire) avail ring, from the spec
#[repr(C)]
struct Avail {
    flags: u16,         // always zero
    idx: u16,           // driver will write ring[idx] next
    ring: [u16; NUM],   // descriptor numbers of chain heads
    unused: u16,
}

#[repr(C)]
struct Used {
    flags: u16,     // always zero
    idx: u16,       // device increments when it add a ring[] entry
    ring: [UsedElem; NUM],
}

// one entry in the "used" ring, with which the
// device tells the driver about completed requests.
#[repr(C)]
struct UsedElem {
    id: u32,    // index of start of completed descriptor chain
    len: u32,
}

const VIRTIO_BLK_T_IN: u32 = 0;
const VIRTIO_BLK_T_OUT: u32 = 1;

// the format of the first descriptor in a disk request.
// to be followed by two more descriptors containing
// the block, and a one-byte status.
#[repr(C)]
struct BlkReq {
    _type: u32,
    reserved: u32,
    sector: u64,
}

impl Disk {
    const fn new() -> Self {
        Self {
            pad1: Pad::new(),
            desc: array![_ => Descriptor::new(); NUM],
            avail: Avail::new(),
            pad2: Pad::new(),
            used: Used::new(),
            pad3: Pad::new(),
            free: [false; NUM],
            used_idx: 0,
            info: array![_ => Info::new(); NUM],
            ops: array![_ => BlkReq::new(); NUM],
            lock: SpinLock::new((), "disk"),
        }
    }

    pub fn init(&mut self) {
        // check padding here
        assert_eq!((&self.desc as *const _ as usize) % PGSIZE, 0);
        assert_eq!((&self.used as *const _ as usize) % PGSIZE, 0);
        assert_eq!((&self.free as *const _ as usize) % PGSIZE, 0);

        if read_offset(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
           read_offset(VIRTIO_MMIO_VERSION) != 1 ||
           read_offset(VIRTIO_MMIO_DEVICE_ID) != 2 ||
           read_offset(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551 {
            panic!("could not find virtio disk");
        }

        let mut status = VIRTIO_CONFIG_S_ACKNOWLEDGE;
        write_offset(VIRTIO_MMIO_STATUS, status);
        status |= VIRTIO_CONFIG_S_DRIVER;
        write_offset(VIRTIO_MMIO_STATUS, status);

        // negotiate features
        let mut features: u32 = read_offset(VIRTIO_MMIO_DEVICE_FEATURES);
        features &= !(1 << VIRTIO_BLK_F_RO);
        features &= !(1 << VIRTIO_BLK_F_SCSI);
        features &= !(1 << VIRTIO_BLK_F_CONFIG_WCE);
        features &= !(1 << VIRTIO_BLK_F_MQ);
        features &= !(1 << VIRTIO_F_ANY_LAYOUT);
        features &= !(1 << VIRTIO_RING_F_EVENT_IDX);
        features &= !(1 << VIRTIO_RING_F_INDIRECT_DESC);
        write_offset(VIRTIO_MMIO_DRIVER_FEATURES, features);

        // tell device that feature negotiation is complete
        status |= VIRTIO_CONFIG_S_FEATURES_OK;
        write_offset(VIRTIO_MMIO_STATUS, status);

        // tell device we're completely ready
        status |= VIRTIO_CONFIG_S_DRIVER_OK;
        write_offset(VIRTIO_MMIO_STATUS, status);

        // initialize queue 0
        write_offset(VIRTIO_MMIO_QUEUE_SEL, 0);
        let max = read_offset(VIRTIO_MMIO_QUEUE_NUM_MAX);

        if max == 0 {
            panic!("virtio disk has no queue 0");
        }

        if max < NUM as u32 {
            panic!("virtio disk max queue too short");
        }

        write_offset(VIRTIO_MMIO_QUEUE_NUM, NUM as u32);
        let pfn = u32::try_from((self as *const Disk as usize) >> PGSHIFT).unwrap();
        write_offset(VIRTIO_MMIO_QUEUE_PFN, pfn);

        // desc = pages -- num * virtq_desc
        // i think it's pages + 0x80 here
        // avail = pages + 0x40 -- 2 * uint16, then num * uint16
        // used = pages + 4096 -- 2 * uint16, then num * vRingUsedElem
        
        // set all NUM descriptors free
        self.free.iter_mut().for_each(|f| *f = true);
    }

    // find a free descriptor, mark it non-free, return it's index
    fn alloc_desc(&mut self) -> Option<usize> {
        for i in 0..NUM {
            if self.free[i] {
                self.free[i] = false;
                return Some(i);
            }
        }
        return None;
    }

    // mark a descriptor as free
    fn free_desc(&mut self, i: usize) {
        if i >= NUM {
            panic!("free_desc 1");
        }
        if self.free[i] {
            panic!("free_desc 2");
        }
        self.desc[i].addr = 0;
        self.desc[i].len = 0;
        self.desc[i].flags = 0;
        self.desc[i].next = 0;
        self.free[i] = true;

        unsafe {
            proc_manager.wakeup(&self.free[0] as *const bool as usize);
        }
    }

    // free a chain of descriptors
    fn free_chan(&mut self, mut i: usize) {
        loop {
            let flag = self.desc[i].flags;
            let nxt = self.desc[i].next;

            self.free_desc(i);

            if (flag & VRING_DESC_F_NEXT) != 0 {
                i = nxt as usize;
            } else {
                break;
            }
        }
    }

    // allocate three descriptors (they need not to be contiguous)
    // disk transfers always use three descriptors
    fn alloc3_desc(&mut self, idx: &mut [usize; 3]) -> bool {
        for i in 0..3 {
            match self.alloc_desc() {
                Some(id) => idx[i] = id,
                None => {
                    for j in 0..i {
                        self.free_desc(idx[j]);
                    }
                    return false;
                }
            }
        }
        return true;
    }

    pub fn rw(&mut self, buf: &mut Buf, write: bool) {
        let sector = (buf.blockno as usize * (BSIZE / 512)) as u64;

        self.lock.acquire();
        // the spec's Section 5.2 says that legacy block operations use
        // three descriptors: one for type/reserved/sector, one for the
        // data, one for a 1-byte status result.

        // allocate the three descriptors.
        let mut idx: [usize; 3] = [0; 3];
        loop {
            if self.alloc3_desc(&mut idx) {
                break;
            } else {
                let p = unsafe { &mut *myproc() };
                p.sleep(&self.free[0] as *const _ as usize, &self.lock);
            }
        }

        // format the three descriptors
        // qemu's virtio-blk.c reads them
        let buf0 = &mut self.ops[idx[0]];
        if write {
            buf0._type = VIRTIO_BLK_T_OUT;  // write the disk
        } else {
            buf0._type = VIRTIO_BLK_T_IN;   // read the disk
        }

        buf0.reserved = 0;
        buf0.sector = sector;

        self.desc[idx[0]].addr = buf0 as *const _ as u64;
        self.desc[idx[0]].len = core::mem::size_of::<BlkReq>() as u32;
        self.desc[idx[0]].flags = VRING_DESC_F_NEXT;
        self.desc[idx[0]].next = idx[1] as u16;

        self.desc[idx[1]].addr = buf.data.as_ptr() as u64;
        self.desc[idx[1]].len = BSIZE as u32;
        
        if write {
            self.desc[idx[1]].flags = 0;
        } else {
            self.desc[idx[1]].flags = VRING_DESC_F_WRITE as u16;
        }
        self.desc[idx[1]].flags |= VRING_DESC_F_NEXT as u16;
        self.desc[idx[1]].next = idx[2] as u16;

        self.info[idx[0]].status = 0xff;
        self.desc[idx[2]].addr = &self.info[idx[0]].status as *const _ as u64;
        self.desc[idx[2]].len = 1;
        self.desc[idx[2]].flags = VRING_DESC_F_WRITE as u16;
        self.desc[idx[2]].next = 0;

        // record struct buf for virtio_disk_intr
        buf.disk = true;
        self.info[idx[0]].buf_channel = Some(buf as *mut _ as usize);

        // tell the device the first index in our chain of descriptors
        self.avail.ring[self.avail.idx as usize % NUM] = idx[0] as u16;

        fence(Ordering::SeqCst);

        // tell the device another avail ring entry is available
        self.avail.idx += 1;

        fence(Ordering::SeqCst);

        write_offset(VIRTIO_MMIO_QUEUE_NOTIFY, 0);

        // wait for virtio_disk_intr to say request has finished
        // i wonder will compiler will optimize this?
        // i think the answer is no, because fence will prevent compiler optimizing across it
        while buf.disk {
            let p = unsafe { &mut *myproc() };
            // sleep on this buffer
            p.sleep(buf as *mut _ as usize, &self.lock);
        }

        self.info[idx[0]].buf_channel = None;
        self.free_chan(idx[0]);

        self.lock.release();
    }

    // called by the interrupt handler
    pub fn intr(&mut self) {
        self.lock.acquire();

        // the device won't raise another interrupt until we tell it
        // we've seen this interrupt, which the following line does.
        // this may race with the device writing new entries to
        // the "used" ring, in which case we may process the new
        // completion entries in this interrupt, and have nothing to do
        // in the next interrupt, which is harmless.
        write_offset(VIRTIO_MMIO_INTERRUPT_ACK, read_offset(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3);

        fence(Ordering::SeqCst);

        // the device increments disk.used->idx when it
        // adds an entry to the used ring

        while self.used_idx != self.used.idx {
            fence(Ordering::SeqCst);
            let id = self.used.ring[self.used_idx as usize % NUM].id;

            if self.info[id as usize].status != 0 {
                panic!("virtio_disk_intr status")
            }

            let addr = self.info[id as usize].buf_channel.expect("failed to find buffer addr");
            let b = unsafe { &mut *(addr as *mut Buf) };
            b.disk = false; // disk is done with buf
            
            // wakeup the waiting process
            unsafe {
                proc_manager.wakeup(addr);
            }

            self.used_idx += 1;
        }

        self.lock.release();
    }

}

impl Pad {
    const fn new() -> Self {
        Self {}
    }
}

impl Descriptor {
    const fn new() -> Self {
        Self {
            addr: 0,
            len: 0,
            flags: 0,
            next: 0,
        }
    }
}

impl Avail {
    const fn new() -> Self {
        Self {
            flags: 0,
            idx: 0,
            ring: [0; NUM],
            unused: 0,
        }
    }
}

impl Used {
    const fn new() -> Self {
        Self {
            flags: 0,
            idx: 0,
            ring: array![_ => UsedElem::new(); NUM],
        }
    }
}

impl UsedElem {
    const fn new() -> Self {
        Self {
            id: 0,
            len: 0,
        }
    }
}

impl Info {
    const fn new() -> Self {
        Self {
            buf_channel: None,
            status: 0,
        }
    }
}

impl BlkReq {
    const fn new() -> Self {
        Self {
            _type: 0,
            reserved: 0,
            sector: 0,
        }
    }
}

#[inline]
fn read(addr: usize) -> u32 {
    unsafe {
        ptr::read_volatile(addr as *mut u32)
    }
}

#[inline]
fn read_offset(offset: usize) -> u32 {
    unsafe {
        ptr::read_volatile((VIRTIO0 + offset) as *mut u32)
    }
}

#[inline]
fn write(addr: usize, value: u32) {
    unsafe {
        ptr::write_volatile(addr as *mut u32, value);
    }
}

#[inline]
fn write_offset(offset: usize, value: u32) {
    unsafe {
        ptr::write_volatile((VIRTIO0 + offset) as *mut u32, value);
    }
}