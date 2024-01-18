// We declare the 'kernel_main' label as being external to this file.
// That's because it's the name of the main C function in 'kernel.c'.
.extern kernel_main

// We declare the 'start' label as global (accessible from outside this file), since the linker will need to know where it is.
.global start