; boot.asm
BITS 16
org 0x7c00

start:
    ; Enable A20 line
    in al, 0x64
    test al, 2
    jnz start
    mov al, 0xD1
    out 0x64, al

    ; Switch to protected mode
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp CODE_SEG:init_pm

[BITS 32]
init_pm:
    ; Set up segments
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000 ; Setup stack

    ; Load the kernel
    mov ebx, 0x100000 ; Load address for the kernel (1MB)
    mov dh, 1         ; Number of sectors to load
    mov dl, 0         ; Drive number (floppy)
    call load_kernel

    ; Switch to long mode (64-bit)
    mov ecx, cr4
    or ecx, 0x20
    mov cr4, ecx

    mov ecx, cr0
    or ecx, 0x80000000
    mov cr0, ecx

    ; Enable long mode
    mov edx, cr3
    mov eax, 0xC0000080
    rdmsr
    or eax, 0x100
    wrmsr

    jmp CODE_SEG64:init_long_mode

[BITS 64]
init_long_mode:
    mov ax, DATA_SEG64
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; Call kernel main function
    extern kernel_main
    call kernel_main

hang:
    jmp hang

load_kernel:
    mov ah, 0x02
    int 0x13
    jc load_kernel
    ret

gdt_start:
    dq 0               ; Null descriptor
    dq 0x00CF9A000000FFFF ; Code segment
    dq 0x00CF92000000FFFF ; Data segment

gdt64_code:
    dq 0x00AF9A000000FFFF ; 64-bit code segment
gdt64_data:
    dq 0x00AF92000000FFFF ; 64-bit data segment

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt64_code - gdt_start
DATA_SEG equ gdt64_data - gdt_start
CODE_SEG64 equ gdt64_code - gdt_start
DATA_SEG64 equ gdt64_data - gdt_start

welcome_message db 'PINGU OS 64-bit', 0

times 510-($-$$) db 0
dw 0xAA55
