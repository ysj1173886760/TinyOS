use core::ops::DerefMut;
use core::{ptr::NonNull, ops::Deref};
use core::mem;

use crate::mm::{kalloc, kfree};

#[derive(Debug)]
pub struct KBox<T>(NonNull<T>);

impl<T> KBox<T> {
    pub fn new() -> Option<KBox<T>> {
        match kalloc() {
            // we can guarantee the unwrap will succeed, because kalloc has returned a valid pointer to us
            Some(ptr) => Some(Self(NonNull::new(ptr as *mut T).unwrap())),
            None => None,
        }
    }

    pub fn into_raw(self) -> *mut T {
        let ptr = self.0.as_ptr();
        mem::forget(self);
        ptr
    }
}

impl<T> Deref for KBox<T> {
    type Target = T;

    fn deref(&self) -> &T {
        unsafe {
            self.0.as_ref()
        }
    }
}

impl<T> DerefMut for KBox<T> {
    fn deref_mut(&mut self) -> &mut T {
        unsafe {
            self.0.as_mut()
        }
    }
}

impl<T> Drop for KBox<T> {
    fn drop(&mut self) {
        kfree(self.0.as_ptr() as usize);
    }
}