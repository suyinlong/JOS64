/*
* @Author: Yinlong Su
* @Date:   2016-04-13 22:41:26
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-04-13 23:00:02
*/

// Fork performance test

#include <inc/lib.h>

envid_t dumbfork(void);

void umain(int argc, char **argv) {
    envid_t who;
    uint64_t tick1, tick2, tick3;
    uint64_t a, b, c, d;
    // dumbfork
    asm volatile("rdtsc;":"=a"(a),"=d"(b));
    who = dumbfork();
    asm volatile("rdtsc;":"=a"(c),"=d"(d));
    sys_yield();
    if (!who)
        return;
    sys_yield();
    tick1 = (((uint64_t)c) | ((uint64_t)d << 32)) - (((uint64_t)a) | ((uint64_t)b << 32));
    // fork
    asm volatile("rdtsc;":"=a"(a),"=d"(b));
    who = fork();
    asm volatile("rdtsc;":"=a"(c),"=d"(d));
    sys_yield();
    if (!who)
        return;
    sys_yield();
    tick2 = (((uint64_t)c) | ((uint64_t)d << 32)) - (((uint64_t)a) | ((uint64_t)b << 32));
    // sfork
    asm volatile("rdtsc;":"=a"(a),"=d"(b));
    who = sfork();
    asm volatile("rdtsc;":"=a"(c),"=d"(d));
    sys_yield();
    if (!who)
        return;
    sys_yield();
    tick3 = (((uint64_t)c) | ((uint64_t)d << 32)) - (((uint64_t)a) | ((uint64_t)b << 32));

    cprintf("\033[0;34m [dumbfork: %d]    [fork: %d]    [sfork: %d]\033[0m\n", tick1, tick2, tick3);
}

void
duppage(envid_t dstenv, void *addr)
{
    int r;

    // This is NOT what you should do in your fork.
    if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
        panic("sys_page_alloc: %e", r);
    if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
        panic("sys_page_map: %e", r);
    memmove(UTEMP, addr, PGSIZE);
    if ((r = sys_page_unmap(0, UTEMP)) < 0)
        panic("sys_page_unmap: %e", r);
}

envid_t
dumbfork(void)
{
    envid_t envid;
    uint8_t *addr;
    int r;
    extern unsigned char end[];

    // Allocate a new child environment.
    // The kernel will initialize it with a copy of our register state,
    // so that the child will appear to have called sys_exofork() too -
    // except that in the child, this "fake" call to sys_exofork()
    // will return 0 instead of the envid of the child.
    envid = sys_exofork();
    if (envid < 0)
        panic("sys_exofork: %e", envid);
    if (envid == 0) {
        // We're the child.
        // The copied value of the global variable 'thisenv'
        // is no longer valid (it refers to the parent!).
        // Fix it and return 0.
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // We're the parent.
    // Eagerly copy our entire address space into the child.
    // This is NOT what you should do in your fork implementation.
    for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
        duppage(envid, addr);

    // Also copy the stack we are currently running on.
    duppage(envid, ROUNDDOWN(&addr, PGSIZE));

    // Start the child environment running
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
        panic("sys_env_set_status: %e", r);

    return envid;
}

