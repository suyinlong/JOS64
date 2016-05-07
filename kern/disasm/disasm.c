/*
* @Author: Yinlong Su
* @Date:   2016-04-10 21:08:19
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-05-02 11:45:25
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