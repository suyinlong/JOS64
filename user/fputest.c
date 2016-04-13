/*
* @Author: Yinlong Su
* @Date:   2016-04-12 14:53:35
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-04-12 22:50:14
*/

// FPU test

// Note: It seems that fldl instruction load more than 64 bits of data into the FPU stack.
//       The last 'l' of fldl indicate the data is double (64 bits), but I found that the
//       data on memory space after the 64 bits is also loaded.
//       My original add/sub/mul/div/mod declare the variable as:
//           double op1 = *a, op2 = *b, op;
//       But the result is all wrong! That is because the partial data of op2 is loaded
//       into op1. I tried to use <long double> or change to instruction between flds, fldt
//       but it doesn't work. So I have to add some stupid padding, now the declaration
//       looks like:
//           double op1 = *a, p1 = 0.0, op2 = *b, p2 = 0.0, op, p3;
//
//

#include <inc/lib.h>

void pi(double *c) {
    double op;

    asm("fldpi;");
    asm("fstpl %0;":"=m"(op));

    *c = op;
}

void double2int(double *c, int64_t *i) {
    double op = *c;
    int64_t x;

    asm("fldl %0;"::"m"(op));
    asm("fistp %0;":"=m"(x));

    *i = x;
}

void int2double(int64_t *i, double *c) {
    int64_t x = *i;
    double op;

    asm("fildl %0;"::"m"(x));
    asm("fstpl %0;":"=m"(op));

    *c = op;
}

void sqr(double *c) {
    double op = *c;

    asm("fldl %0;"::"m"(op));
    asm("fscale;");
    asm("fstpl %0;":"=m"(op));

    *c = op;
}

void abs(double *c) {
    double op = *c;

    asm("fldl %0;"::"m"(op));
    asm("fabs;");
    asm("fstpl %0;":"=m"(op));

    *c = op;
}

void sqrt(double *c) {
    double op = *c;

    asm("fldl %0;"::"m"(op));
    asm("fsqrt;");
    asm("fstpl %0;":"=m"(op));

    *c = op;
}

void add(double *a, double *b, double *c) {
    double op1 = *a, p1 = 0.0, op2 = *b, p2 = 0.0, op, p3;

    asm("fldl %0;"::"m"(op1));
    asm("faddl %0;"::"m"(op2));
    asm("fstpl %0;":"=m"(op));

    *c = op;
}

void sub(double *a, double *b, double *c) {
    double op1 = *a, p1 = 0.0, op2 = *b, p2 = 0.0, op, p3;

    asm("fldl %0;"::"m"(op1));
    asm("fsubl %0;"::"m"(op2));
    asm("fstpl %0;":"=m"(op));

    *c = op;
}

void mul(double *a, double *b, double *c) {
    double op1 = *a, p1 = 0.0, op2 = *b, p2 = 0.0, op, p3;

    asm("fldl %0;"::"m"(op1));
    asm("fmull %0;"::"m"(op2));
    asm("fstpl %0;":"=m"(op));

    *c = op;
}

void div(double *a, double *b, double *c) {
    double op1 = *a, p1 = 0.0, op2 = *b, p2 = 0.0, op, p3;

    asm("fldl %0;"::"m"(op1));
    asm("fdivl %0;"::"m"(op2));
    asm("fstpl %0;":"=m"(op));

    *c = op;
}

void mod(double *a, double *b, double *c) {
    double op1 = *a, p1 = 0.0, op2 = *b, p2 = 0.0, op, p3;

    asm("fldl %0;"::"m"(op2));
    asm("fldl %0;"::"m"(op1));
    asm("fprem;");
    asm("fstpl %0;":"=m"(op));

    *c = op;

    asm("fstpl %0;":"=m"(op));
}

void
umain(int argc, char **argv)
{

    asm("finit;");

    // save old control word of FPU
    uint16_t old_cw;
    asm("fstcw %0;":"=m"(old_cw));

    // set rounding control to round down
    uint16_t new_cw = (old_cw & 0xF3FF) | 0x400;
    asm("fldcw %0;"::"m"(new_cw));

    double fpu_pi, c, t, base = 10.0;
    int64_t x, i;

    // get PI from FPU
    pi(&fpu_pi);

    cprintf("\033[43;30mFPU PI = ");

    double2int(&fpu_pi, &x);
    cprintf("%d.", x);

    c = fpu_pi;
    for (i = 1; i <= 20; i++) {
        int2double(&x, &t);
        sub(&c, &t, &c);
        mul(&c, &base, &c);
        double2int(&c, &x);
        cprintf("%d", x);
    }
    cprintf("\033[0m\n");

    // restore old control word of FPU
    asm("fldcw %0;"::"m"(old_cw));
}
