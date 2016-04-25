/*
* @Author: Yinlong Su
* @Date:   2016-04-13 19:28:50
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-04-13 20:41:21
*/

// User Exception Handler Test

// Set user's divide-by-zero, illegal opcode, general protection fault handler
// Then cause those troubles
//
// Yinlong Su
// April 13, 2016
//

#include <inc/lib.h>

#define T_DIVIDE     0      // divide error
#define T_ILLOP      6      // illegal opcode
#define T_GPFLT     13      // general protection fault

int zero;

void divide_handler(struct UTrapframe *utf) {
    double dzero;
    cprintf("\033[0;31mOops! Divide-by-zero!\033[0m\n");

    cprintf("Converting an integer to double...\n");
    dzero = (double) zero;
}

void illop_handler(struct UTrapframe *utf) {
    cprintf("\033[0;31mOops! Illegal opcode!\033[0m\n");

    cprintf("Loading the kernel's TSS selector into the DS register...\n");
    asm volatile("movw $0x28,%ax; movw %ax,%ds");
}

void gpflt_handler(struct UTrapframe *utf) {
    cprintf("\033[0;31mOops! General protection fault!\033[0m\n");

    cprintf("\033[0;33mDestroying the environment...\033[0m\n");
    sys_env_destroy(thisenv->env_id);
}

void umain(int argc, char **argv) {
    zero = 0;
    // set exception handlers
    set_exception_handler(T_DIVIDE, divide_handler);
    set_exception_handler(T_ILLOP, illop_handler);
    set_exception_handler(T_GPFLT, gpflt_handler);
    // try to cause some troubles
    cprintf("Calculating 1/0...\n");
    cprintf("1/0 is %08x!\n", 1/zero);
}
