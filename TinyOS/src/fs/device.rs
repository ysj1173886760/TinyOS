use crate::consts::param::NDEV;

pub struct Device {
    pub read: fn(user_dst: bool, dst: usize, n: usize)
        -> Result<usize, &'static str>,
    pub write: fn(user_src: bool, src: usize, n: usize)
        -> Result<usize, &'static str>,
}

pub static mut DEVSW: [Option<Device>; NDEV] = [
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
    None,
];