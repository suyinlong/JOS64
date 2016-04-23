/*
* @Author: Yinlong Su
* @Date:   2016-04-21 10:35:06
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-04-23 13:23:41
*/

// Power series

#include <inc/lib.h>

#define MAX_N_COEFFICIENTS  6

// Opcodes on stream
enum {
    STREAM_READ,    // read a coefficient from stream
    STREAM_SPLIT,   // split the stream
    STREAM_END      // kill the stream
};

// Parameter for creating a special stream (sum, multiply, substitution)
struct StreamDesc {
    envid_t id[2];
    uint32_t num;
    uint32_t delay;
};

// Some FPU functions from my fputest.c
uint16_t old_cw;

static void fpu_init() {
    asm("finit;");

    // save old control word of FPU
    uint16_t old_cw;
    asm("fstcw %0;":"=m"(old_cw));

    // set rounding control to round down
    uint16_t new_cw = (old_cw & 0xF3FF) | 0x400;
    asm("fldcw %0;"::"m"(new_cw));
}

static void fpu_restore() {
    // restore old control word of FPU
    asm("fldcw %0;"::"m"(old_cw));
}

static void double2int(double *c, int64_t *i) {
    double op = *c;
    int64_t x;

    asm("fldl %0;"::"m"(op));
    asm("fistpq %0;":"=m"(x));

    *i = x;
}

static void int2double(int64_t *i, double *c) {
    int64_t x = *i;
    double op;

    asm("fildl %0;"::"m"(x));
    asm("fstpl %0;":"=m"(op));

    *c = op;
}

static void chs(double *c) {
    double op = *c;

    asm("fldl %0;"::"m"(op));
    asm("fchs;");
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
static void mul(double *a, double *b, double *c) {
    double op1 = *a, p1 = 0.0, op2 = *b, p2 = 0.0, op, p3;

    asm("fldl %0;"::"m"(op1));
    asm("fmull %0;"::"m"(op2));
    asm("fstpl %0;":"=m"(op));

    *c = op;
}

static void div(double *a, double *b, double *c) {
    double op1 = *a, p1 = 0.0, op2 = *b, p2 = 0.0, op, p3;

    asm("fldl %0;"::"m"(op1));
    asm("fdivl %0;"::"m"(op2));
    asm("fstpl %0;":"=m"(op));

    *c = op;
}

// *************************************
// Basic stream functions
// *************************************

// try to read a coefficient from stream
// use SIPC to send a STREAM_READ opcode
static void stream_readfrom(envid_t eid, double *buffer) {
    uint64_t r;
    sipc_send(eid, STREAM_READ);
    r = sipc_recv(eid, NULL);
    *buffer = *((double *)&r);
}

// write a coefficient to stream
// use SIPC to send a coefficient back
static void stream_writeto(envid_t eid, double *buffer) {
    uint64_t r = *((uint64_t *)buffer);
    sipc_send(eid, r);
}

// init a stream
// use fork to create a new environment
// the stream type and descriptor need to be specified
static envid_t stream_init(void (*type)(void *), void *desc) {
    envid_t child = fork();

    if (child < 0)
        panic("fork error (stream_init): %e", child);
    else if (child == 0) {
        type(desc);
        exit();
    }
    return child;
}

// stream cycle  wait for a opcode and execute
// OPCODE = STREAM_READ
//          Return the sender eid
//          STREAM_SPLIT
//          Split a new stream then send back the child eid
//          STREAM_END
//          Return 0
static envid_t stream_cycle() {
    envid_t req_eid, child;
    int32_t req;
    //cprintf("stream_cycle: %08x in cycle\n", sys_getenvid());
    while (1) {
        req = sipc_recv(0, &req_eid);
        //cprintf("  [cycle]: %08x recv %d from %08x\n", sys_getenvid(), req, req_eid);
        if (req == STREAM_READ) {
            return req_eid;
        } else if (req == STREAM_SPLIT) {
            child = fork();
            if (child < 0)
                panic("fork error (stream_cycle): %e", child);
            else if (child > 0) {
                //cprintf("stream_cycle: %08x fork child %08x\n", sys_getenvid(), child);
                sipc_send(req_eid, child);
            }
        } else if (req == STREAM_END) {
            return 0;
        }
    }
}

// split stream eid
// use SIPC to send STREAM_SPLIT opcode
static envid_t stream_split(envid_t eid) {
    envid_t child;
    //cprintf("  [split]: %08x request %08x to split\n", sys_getenvid(), eid);
    sipc_send(eid, STREAM_SPLIT);
    child = sipc_recv(eid, NULL);
    //cprintf("  [split]: %08x recv from %08x child %08x\n", sys_getenvid(), eid, child);
    return child;
}

// end stream
// use SIPC to send STREAM_END to e1, e2, e3
// then exit
static void stream_end(envid_t e1, envid_t e2, envid_t e3) {
    if (e1)
        sipc_send(e1, STREAM_END);
    if (e2)
        sipc_send(e2, STREAM_END);
    if (e3)
        sipc_send(e3, STREAM_END);
    sys_yield();
    exit();
}

// ***************************************
// Special Stream Functions
// Note: We handle STREAM_END opcode in these functions
//       coz different phases have different substreams.
//       JOS has very limitted capacity of running envs,
//       so we need to create as few envs as possible.
// ***************************************


// Sum Stream: S = F + G
// F and G come from desciptor
void sumStream(void *desc) {
    envid_t target;
    double sum, a0, a1;
    struct StreamDesc *d = (struct StreamDesc *)desc;

    while (1) {
        // handle STREAM_READ or STREAM_END
        if ((target = stream_cycle()) == 0)
            stream_end(d->id[0], d->id[1], 0);

        stream_readfrom(d->id[0], &a0);
        stream_readfrom(d->id[1], &a1);
        add(&a0, &a1, &sum);
        stream_writeto(target, &sum);
    }
}

void delayStream(void *desc) {
    envid_t target;
    int i;
    double a = 0.0f;
    struct StreamDesc *d = (struct StreamDesc *)desc;
    // first send d->delay number of 0
    for (i = 0; i < d->delay; i++) {
        if ((target = stream_cycle()) == 0)
            stream_end(d->id[0], 0, 0);
        stream_writeto(target, &a);
    }
    // then send d->id[0]
    if ((target = stream_cycle()) == 0)
        stream_end(d->id[0], 0, 0);
    stream_readfrom(d->id[0], &a);
    stream_writeto(target, &a);
}


// P = F G
// P0 + xP' = F0G0 + x (F0G'+G0F') + x^2 F'G'
void multiplyStream(void *desc) {
    double f0, g0, f0g0, f1, g1, f0g1, g0f1, f0g1_g0f1, m, f1g1;
    struct StreamDesc *d = (struct StreamDesc *)desc;
    envid_t F = d->id[0], F1, G = d->id[1], G1, M, target;

    if ((target = stream_cycle()) == 0)
        stream_end(F, G, 0);
    stream_readfrom(F, &f0);
    stream_readfrom(G, &g0);
    mul(&f0, &g0, &f0g0);
    stream_writeto(target, &f0g0);

    // try to read an opcode first coz we don't want to split
    // too many unnecessary envs...
    if ((target = stream_cycle()) == 0)
        stream_end(F, G, 0);

    F1 = stream_split(F);
    G1 = stream_split(G);

    M = stream_init(multiplyStream, desc);

    stream_readfrom(G1, &g1);
    stream_readfrom(F1, &f1);
    mul(&f0, &g1, &f0g1);
    mul(&g0, &f1, &g0f1);
    add(&f0g1, &g0f1, &f0g1_g0f1);

    stream_writeto(target, &f0g1_g0f1);

    while (1) {
        // handle STREAM_READ or STREAM_END
        // only need to close F1, G1 and M
        // since F and G is controlled by M
        if ((target = stream_cycle()) == 0)
            stream_end(F1, G1, M);

        stream_readfrom(G1, &g1);
        stream_readfrom(F1, &f1);
        stream_readfrom(M, &m);
        mul(&f0, &g1, &f0g1);
        mul(&g0, &f1, &g0f1);
        add(&f0g1, &g0f1, &f0g1_g0f1);
        add(&f0g1_g0f1, &m, &f1g1);

        stream_writeto(target, &f1g1);
    }
}

// S = F (G)
// S0 + xS' = F0 + x G' F'(G)
//
// S0 = F0 + G0 * F'(G)[0]   so it is an infinite problem
void substitutionStream(void *desc) {
    double f0, g0, m;
    int64_t temp;
    struct StreamDesc *d = (struct StreamDesc *)desc;
    envid_t F = d->id[0], G1 = d->id[1], G2, M, target;

    if ((target = stream_cycle()) == 0)
        stream_end(F, G1, 0);
    stream_readfrom(F, &f0);
    stream_writeto(target, &f0);

    // try to read an opcode first coz we don't want to split
    // too many unnecessary envs...
    if ((target = stream_cycle()) == 0)
        stream_end(F, G1, 0);
    G2 = stream_split(G1);
    stream_readfrom(G2, &g0);
    // Note: If g0 is not 0, then this is an infinite problem,
    //       the recurision won't stop

    M = stream_init(substitutionStream, desc);
    d->id[0] = M;
    d->id[1] = G2;
    M = stream_init(multiplyStream, desc);

    while (1) {
        stream_readfrom(M, &m);
        stream_writeto(target, &m);
        // handle STREAM_READ or STREAM_END
        // only need to close M
        // since M' and G2 is controlled by M
        //       F  and G1 is controlled by M'
        if ((target = stream_cycle()) == 0)
            stream_end(M, 0, 0);
    }
}

// sin Stream
void sinStream(void *desc) {
    int64_t n, ti;
    double cur = 1.0f, zero = 0.0f, td;
    envid_t target;

    for (n = 0; ; n++) {
        if ((target = stream_cycle()) == 0)
            stream_end(0, 0, 0);
        if (n & 1) {
            if (n > 1) {
                chs(&cur);
                ti = n;
                int2double(&ti, &td);
                div(&cur, &td, &cur);
                ti = n - 1;
                int2double(&ti, &td);
                div(&cur, &td, &cur);
            }
            stream_writeto(target, &cur);
        } else {
            stream_writeto(target, &zero);
        }
    }
}

// poly Stream
void polyStream(void *desc) {
    double one = 1.0f, zero = 0.0f;
    envid_t target;

    if ((target = stream_cycle()) == 0)
        stream_end(0, 0, 0);
    stream_writeto(target, &zero);
    if ((target = stream_cycle()) == 0)
        stream_end(0, 0, 0);
    stream_writeto(target, &one);
    if ((target = stream_cycle()) == 0)
        stream_end(0, 0, 0);
    stream_writeto(target, &zero);
    if ((target = stream_cycle()) == 0)
        stream_end(0, 0, 0);
    stream_writeto(target, &one);

    while (1) {
        if ((target = stream_cycle()) == 0)
            stream_end(0, 0, 0);
        stream_writeto(target, &zero);
    }
}

void umain(int argc, char **argv) {
    envid_t root;
    envid_t ids[2];
    struct StreamDesc desc;

    double r, b = 10000000000.0f;
    double coefficients[MAX_N_COEFFICIENTS];
    int64_t ri, i = 0;

    fpu_init();

    desc.num = 2;
    desc.delay = 0;
    desc.id[0] = stream_init(sinStream, NULL);
    desc.id[1] = stream_init(polyStream, NULL);

    root = stream_init(substitutionStream, (void *)(&desc));

    for (i = 0; i < MAX_N_COEFFICIENTS; i++) {
        stream_readfrom(root, &r);
        coefficients[i] = r;
    }

    cprintf("Cleaning...\n");
    sipc_send(root, STREAM_END);

    for (i = 0; i < MAX_N_COEFFICIENTS; i++) {
        r = coefficients[i];
        cprintf("    \033[0;33mC[%d]: ", i);

        double2int(&r, &ri);
        if (ri < 0) {
            cprintf("-");
            chs(&r);
            double2int(&r, &ri);
        } else {
            cprintf("+");
        }
        cprintf("%d.", ri);
        mul(&r, &b, &r);
        double2int(&r, &ri);
        cprintf("%010d\033[0m\n", ri % 10000000000);
    }

    fpu_restore();
}