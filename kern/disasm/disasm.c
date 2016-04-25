/*
* @Author: Yinlong Su
* @Date:   2016-04-10 21:08:19
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-04-11 00:06:08
*/

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/kdebug.h>
#include <kern/trap.h>
#include <kern/pmap.h>
#include <kern/env.h>
#include <kern/disasm/disasm.h>

static uint64_t d_sstep = 1;
static uint64_t d_eflag = 0;
static uint64_t d_eip = 0;
static uint64_t d_nextflag = 0;

int disasm_u(int argc, char **argv, struct Trapframe *tf) {
    if (!tf) {
        cprintf(DISASM_ERR_INVALIDCMD);
        return 0;
    }

    char *endptr = NULL;

    uint64_t va = (argc == 3) ? strtol(argv[1], &endptr, 0) : tf->tf_rip;
    if (*endptr != '\0')
        return 0;

    uint64_t ic = (argc == 3) ? strtol(argv[2], &endptr, 0) : ((argc == 2) ? strtol(argv[1], &endptr, 0) : 1);
    if (*endptr != '\0')
        return 0;

    cprintf("va 0x%016x ic %d\n", va, ic);

    uint8_t mahc[DISASM_MAH_BUFFER];
    char asmc[DISASM_ASM_BUFFER];
    memset(mahc, 0, DISASM_MAH_BUFFER);
    memset(asmc, 0, DISASM_ASM_BUFFER);

    memcpy((void *)mahc, (void *)va, DISASM_MAH_BUFFER);

    cprintf("%s\n", asmc);

    return 0;
}

int disasm_s(int argc, char **argv, struct Trapframe *tf) {
    if (!tf) {
        cprintf(DISASM_ERR_INVALIDCMD);
        return 0;
    }

    tf->tf_eflags |= 0x100;

    return -1;
}

int disasm_c(int argc, char **argv, struct Trapframe *tf) {
    if (!tf) {
        cprintf(DISASM_ERR_INVALIDCMD);
        return 0;
    }

    tf->tf_eflags &= ~0x100;

    return -1;
}