#include <stddef.h>
#include <stdint.h>

#if defined(__linux__)
    #error "This code must be compiled with a cross-compiler"
#elif !defined(__i386)
    #error "This code must be compiled with a x86-elf compiler"
#endif

volatile uint16_t* vga_buffer = (uint16_t*)0xB8000; // write to this memory location to to display text (x86's VGA textmode buffer)

// default char size
const int VGA_COLS = 80;
const int VGA_ROWS = 25;

int term_col = 0;
int term_row = 0;
uint8_t term_color = 0x0F; // white on black

void term_init() {
    //clear the textmode buffer
    for (int col = 0; col < VGA_COLS; col++) {
        for (int row = 0; row < VGA_ROWS; row++) {
            const size_t index = (VGA_COLS * row) + col;
            // Entries in the VGA buffer take the binary form BBBBFFFFCCCCCCCC, where:
			// - B is the background color
			// - F is the foreground color
			// - C is the ASCII character
            vga_buffer[index] = ((uint16_t)term_color << 8) | ' '; // set to a blank char
        }
    }
}

void term_putc(char c) {
    switch (c) {
        case '\n':
            term_col = 0;
            term_row++;
            break;

        default:
            const size_t index = (VGA_COLS * term_row) + term_col;
            vga_buffer[index] = ((uint16_t)term_color << 8) | c;
            term_col++;
            break;
    }

    if (term_col >= VGA_COLS) {
        term_row++;
        term_col = 0;
    }

    if (term_row >= VGA_ROWS) {
        term_row = 0;
        term_col = 0;
    }
}

void term_print(char *str) {
    for (size_t i = 0; str[i] != '\0'; i++) {
        term_putc(str[i]);
    }
}

void kernel_main() {
    term_init();

    term_print("Hello, World!\n");
    term_print("Welcome to the kernel.\n");
}