#!/bin/bash

# Set up directories
BOOT_DIR="./boot"
KERNEL_DIR="./kernel"

# Output files
BOOT_BIN="boot.bin"
KERNEL_OBJ="kernel.o"
KERNEL_BIN="kernel.bin"
OS_IMAGE="os_image.bin"

# Clean up old builds
rm -f $BOOT_BIN $KERNEL_OBJ $KERNEL_BIN $OS_IMAGE

# Build the bootloader
echo "Building bootloader..."
nasm -f bin -o $BOOT_BIN $BOOT_DIR/boot.asm
if [ $? -ne 0 ]; then
    echo "Error: Bootloader build failed."
    exit 1
fi

# Build the kernel
echo "Building kernel..."
x86_64-elf-gcc -ffreestanding -m64 -c $KERNEL_DIR/kernel.cpp -o $KERNEL_OBJ
if [ $? -ne 0 ]; then
    echo "Error: Kernel build failed."
    exit 1
fi

x86_64-elf-ld -o $KERNEL_BIN -Ttext 0x100000 $KERNEL_OBJ --oformat binary
if [ $? -ne 0 ]; then
    echo "Error: Kernel linking failed."
    exit 1
fi

# Combine the bootloader and kernel into a single OS image
echo "Creating OS image..."
cat $BOOT_BIN $KERNEL_BIN > $OS_IMAGE
if [ $? -ne 0 ]; then
    echo "Error: OS image creation failed."
    exit 1
fi

echo "Build complete. You can now run the OS using QEMU:"
echo "qemu-system-x86_64 -drive format=raw,file=$OS_IMAGE"
