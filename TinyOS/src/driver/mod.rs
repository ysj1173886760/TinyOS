pub use virtio_disk::DISK;
pub use console::{consoleinit, consoleintr, consoleread, consolewrite, consputc};

mod virtio_disk;
mod console;