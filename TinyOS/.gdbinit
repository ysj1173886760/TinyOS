set confirm off
set architecture riscv:rv64
target remote 127.0.0.1:1234
symbol-file ./target/riscv64gc-unknown-none-elf/debug/tiny_os