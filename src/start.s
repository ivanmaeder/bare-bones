// .extern = declare a symbol defined in another module/file (kernel.c)
.extern kernel_main

// .global = declare a symbol and make it visible to other modules or files (e.g., for linking)
.global start

// bootloader info for GRUB, using the Multiboot standard
// https://wiki.osdev.org/Multiboot
// 
/* According to https://stackoverflow.com/questions/34183799/how-does-this-assembly-bootloader-code-work
 a Multiboot kernel must contain these fields, 4-byte aligned, within the first 8kB:
   - the magic number
   - flags
   - checksum
 
 More information: https://www.gnu.org/software/grub/manual/multiboot/multiboot.html#The-magic-fields-of-Multiboot-header
 */
.set MB_MAGIC, 0x1BADB002 // GRUB uses this to detect the kernel's location
.set MB_FLAGS, (1 << 0) | (1 << 1) // tell GRUB to 1) load modules on page boundaries (4kB in size), and 2) provide a memory map
.set MB_CHECKSUM, (0 - (MB_MAGIC + MB_FLAGS))

// Multiboot header
.section .multiboot
    .align 4 // align the following on multiples of 4 bytes
    // use the constants in executable mode
    .long MB_MAGIC
    .long MB_FLAGS
    .long MB_CHECKSUM

.section .bss
    .align 16
    stack_bottom:
        .skip 4096 // allocate a 4kB stack
    stack_top:

// this is the assembly to run when the kernel is loaded
.section .text
    start: // this is the same "start" as above
        // all we need to do is set up the stack
        mov $stack_top, %esp // set the stack pointer to the top of the stack; on x86 a stacks grow downward

        call kernel_main // this is the same "kernel_main" mentioned above

        // at this point, if the C code returns, we just want to hang
        hang:
            cli // disable CPU interrupts
            hlt // halt the CPU
            jmp hang // jump to "hang" (and try again)
