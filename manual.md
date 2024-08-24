bootloader comfile => nasm -f bin -o boot.bin boot.asm

kernel comfile(GCC) => x86_64-elf-gcc -ffreestanding -m64 -c kernel.cpp -o kernel.o
x86_64-elf-ld -o kernel.bin -Ttext 0x100000 kernel.o --oformat binary

Combining bootloaders and kernels => cat boot.bin kernel.bin > os_image.bin

Execute using QMEU => qemu-system-x86_64 -drive format=raw,file=os_image.bin
