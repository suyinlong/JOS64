/*
* @Author: Yinlong Su
* @Date:   2016-03-25 18:54:33
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-05-04 14:58:10
*/

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>
#include <inc/env.h>

#include <kern/console.h>
#include <kern/env.h>
#include <kern/monitor.h>
#include <kern/dwarf.h>
#include <kern/kdebug.h>
#include <kern/sched.h>
#include <kern/dwarf_api.h>
#include <kern/mmutils.h>
#include <kern/pmaputils.h>


extern pml4e_t *boot_pml4e;        // Kernel's initial page directory
extern physaddr_t boot_cr3;        // Physical address of boot time page directory
extern size_t npages;

extern struct BlockInfo *bis;
extern struct BlockInfo *bis_end;

extern struct Env *envs;

uint64_t mm_getdec(const char *str) {
    uint64_t x = 0;

    while (*str != '\0') {
        x *= 10;
        if (str[0] >= '0' && str[0] <= '9')
            x += str[0] - '0';
        str++;
    }

    return x;
}

uint64_t mm_gethex(const char *str) {
    uint64_t x = 0;

    while (*str != '\0') {
        x *= 16;
        if (str[0] >= '0' && str[0] <= '9')
            x += str[0] - '0';
        else if (str[0] >= 'a' && str[0] <= 'f')
            x += str[0] - 'a' + 10;
        else if (str[0] >= 'A' && str[0] <= 'F')
            x += str[0] - 'A' + 10;
        str++;
    }

    return x;
}

void mm_printmap(pte_t *ptep, const void *va) {
    uint64_t flag;
    if (ptep) {
        cprintf("    Virual address: 0x%016x", va);
        cprintf(" Physical address: 0x%016x", PTE_ADDR(*ptep));
        cprintf(" Flag:");

        flag = *ptep & 0xfff;
        if (flag & PTE_P) cprintf(" PTE_P");
        if (flag & PTE_W) cprintf(" | PTE_W");
        if (flag & PTE_U) cprintf(" | PTE_U");
        if (flag & PTE_PWT) cprintf(" | PTE_PWT");
        if (flag & PTE_PCD) cprintf(" | PTE_PCD");
        if (flag & PTE_A) cprintf(" | PTE_A");
        if (flag & PTE_D) cprintf(" | PTE_D");
        if (flag & PTE_PS) cprintf(" | PTE_PS");

        //cprintf(" PTEP: 0x%016x", ptep);
        cprintf("\n");
    }
}

int mm_pinfo() {
    pml4e_t* pml4ep = boot_pml4e;
    pdpe_t *pdpep = NULL;
    pde_t *pdep = NULL;
    pte_t *ptep = NULL;
    uint64_t info_cr3 = rcr3(), info_cr4 = rcr4();
    cprintf("  PGSIZE: %d, boot_pml4e: 0x%016x, CR3: 0x%016x, CR4: 0x%016x\n", PGSIZE, boot_pml4e, info_cr3, info_cr4);

    uint64_t pml4e_c = 0, pdpe_c = 0, pde_c = 0, pte_c = 0;
    uint64_t pdpe_p = 0, pde_p = 0, pte_p = 0;
    uint64_t i, j, k, l;
    void *va;
    for (i = 0; i < PGSIZE / sizeof(pml4e_t); i++) {
        if (pml4ep[i]) {
            pml4e_c ++;
            //cprintf("Found pml4ep item @ %d : %016x!\n", i, pml4ep[i]);
            //continue;
            pdpep = (pdpe_t *)KADDR(PTE_ADDR(pml4ep[i]));
            for (j = 0; j < PGSIZE / sizeof(pdpe_t); j++) {
                if (pdpep[j]) {
                    pdpe_c ++;
                    //cprintf(" Found pdpep item @ %d : %016x!\n", j, pdpep[j]);
                    //continue;
                    if (pdpep[j] & PTE_PS) {
                        pdpe_p ++;
                        continue;
                    }
                    pdep = (pde_t *)KADDR(PTE_ADDR(pdpep[j]));
                    for (k  = 0; k < PGSIZE / sizeof(pde_t); k++) {
                        if (pdep[k]) {
                            pde_c ++;
                            //cprintf("  Found pgdirp item @ %d : %016x!\n", k, pdep[k]);
                            //continue;
                            if (pdep[k] & PTE_PS) {
                                pde_p ++;
                                continue;
                            }
                            ptep = (pte_t *)KADDR(PTE_ADDR(pdep[k]));
                            for (l = 0; l < PGSIZE / sizeof(pte_t); l++) {
                                if (ptep[l]) {
                                    pte_c ++;
                                    pte_p ++;
                                    //cprintf("   Found ptep item @ %d, %d : %016x!\n", k, l, ptep[l]);
                                }
                            }

                        }
                    }
                }
            }
        }
    }
    cprintf("  Total: \033[0;33m%d\033[0m pml4 entries, \033[0;33m%d\033[0m pdp entries, \033[0;33m%d\033[0m pd entries and \033[0;33m%d\033[0m pt entries.\n", pml4e_c, pdpe_c, pde_c, pte_c);
    cprintf("         \033[0;33m%d\033[0m 1GB pages, \033[0;33m%d\033[0m 2MB pages, \033[0;33m%d\033[0m 4KB pages (\033[0;33m%d\033[0m pages in total).\n", pdpe_p, pde_p, pte_p, pdpe_p + pde_p + pte_p);
    cprintf("         \033[0;33m%d\033[0m pages are used for paging translation.\n", 1 + pml4e_c + pdpe_c - pdpe_p + pde_c - pde_p);

    return 0;
}

int mm_showmaps(uint64_t start, uint64_t end, int pflag) {
    if (pflag) cprintf("  Show maps: [0x%016x - 0x%016x]\n", start, end);

    pml4e_t* pml4e = boot_pml4e;
    pte_t *ptep = NULL;
    uint64_t va, count = 0;
    for (va = start; va < end; va += PGSIZE) {
        ptep = pml4e_walk(pml4e, (void *)va, 0);
        if (ptep && (*ptep & PTE_P)) {
            count++;
            if (pflag) mm_printmap(ptep, (void *)va);
            if (*ptep & PTE_PS)
                va += (PGSIZE << 9) - PGSIZE;
        }
    }

    if (!pflag)
        return count;

    if (count)
        cprintf("  Found \033[0;33m%d\033[0m mappings within the range [0x%016x - 0x%016x].\n", count, start, end);
    else
        cprintf("  No mapping within the range.\n");
    return count;
}

int mm_setmap(uint64_t start, uint64_t end, uint64_t setflag, uint64_t clrflag) {
    uint64_t va, count = 0, value;
    pml4e_t* pml4e = boot_pml4e;
    pte_t *ptep = NULL;

    for (va = start; va < end; va += PGSIZE)
        if ((ptep = pml4e_walk(pml4e, (void *)va, 0))) {
            count++;
            value = *ptep;
            *ptep |= setflag;
            *ptep &= ~clrflag;
            mm_printmap(ptep, (void *)va);
            if (value & PTE_PS)
                va += (PGSIZE << 9) - PGSIZE;
        }

    if (!count)
        cprintf("  No mapping affected.\n");
    else
        cprintf("  %d mapping(s) affected.\n", count);

    return 0;
}

int mm_dumpmem(uint64_t start, uint64_t end) {
    cprintf("  Dump memory from virtual address 0x%016x to 0x%016x:", start, end);
    uint64_t va = 0;
    for (va = ROUNDDOWN(start, 0x10); va < ROUNDUP(end, 0x10); va++) {
        if (va % 0x1000 == 0) cprintf("\n  ------------------------------------------------------------------");
        if (va % 0x10 == 0) cprintf("\n  %016x |", va);
        if (va < start || va >= end) cprintf(" ..");
        else cprintf(" %02x", *((uint8_t *)va));
    }

    cprintf("\n");
    return 0;
}

int mm_binfo(int pflag) {
    int count = 0;
    struct BlockInfo *bie = bis;
    if (!bie) {
        if (pflag)
            cprintf("  \033[0;31mWarning: BlockInfo structure not initialized. Please check the c_block_flag.\033[0m\n");
        return -1;
    }
    if (pflag)
        cprintf("  Block Info:\n");
    while (bie != bis_end) {
        count++;
        if (pflag)
            cprintf("  # Start: 0x%016x End: 0x%016x PAddr: 0x%016x Perm: %d\n", bie->start, bie->end, bie->addr, bie->perm);
        bie++;
    }
    if (pflag) {
        if (count)
            cprintf("  Found \033[0;33m%d\033[0m blocks.\n", count);
        else
            cprintf("  Found no block.\n");
    }
    return count;
}

int mm_bmalloc(size_t n) {
    void *va = b_malloc(n);
    if (va) {
        cprintf("  Malloc: \033[0;33m0x%016x\033[0m\n", va);
        struct BlockInfo *bie = bi_lookup(va);
        cprintf("        [ 0x%016x - 0x%016x ] @ physaddr 0x%016x, %d pages\n", bie->start, bie->end, bie->addr, mm_showmaps((uint64_t)bie->start, (uint64_t)bie->end, 0));
        return 0;
    }
    else {
        cprintf("  \033[0;31mCan not malloc.\033[0m\n");
        return -1;
    }
}

int mm_bfree(void* va) {
    b_free(va);
    cprintf("  Free: \033[0;33m0x%016x\033[0m\n", va);
    return 0;
}

int mm_bsplit(void *va, int split) {
    if (split > 64) {
        cprintf("  \033[0;31mSplit number too large.\033[0m\n");
        return -1;
    }
    struct BlockInfo *bie = bi_lookup(va);
    void *start = bie->start, *end = bie->end;
    void *ptr[64];
    cprintf("  Split [ 0x%016x - 0x%016x ] into %d pieces.\n", start, end, split);
    int r = b_split(va, split, &ptr[0]), i = 0;

    switch (r) {
        case 0:
        cprintf("      ");
        for (i = 0; i < split; i++)
            cprintf(" 0x%016x", ptr[i]);
        cprintf("\n");
        break;

        case -1:
        cprintf("  \033[0;31mSplit number too small or is not a power-to-two number.\033[0m\n");
        break;

        case -2:
        cprintf("  \033[0;31mTarget block does not exist.\033[0m\n");
        break;

        case -3:
        cprintf("  \033[0;31mSplit number too large.\033[0m\n");
        break;

        case -4:
        cprintf("  \033[0;31mPermission denied.\033[0m\n");
        break;
    }
    return r;
}

int mm_bcoalesce(int coalesce, void **ptr) {
    void *va = b_coalesce(coalesce, &ptr[0]);
    if (va)
        cprintf("  Coalesce: \033[0;33m0x%016x\033[0m\n", va);
    else
        cprintf("  \033[0;31mCoalesce failed.\033[0m\n");
    return 0;
}

int mm_einfo(int pflag) {
    int count = 0, i;
    if (pflag)
        cprintf("  Environment Info:\n");
    for (i = 0; i < NENV; i++) {
        if (envs[i].env_status != ENV_FREE) {
            count ++;
            cprintf("  # ");
            cprintf("ID: %08x ", envs[i].env_id);
            cprintf("PID: %08x ", envs[i].env_parent_id);
            cprintf("TYPE: %s ", envs[i].env_type == ENV_TYPE_USER ? "USER" :
                (envs[i].env_type == ENV_TYPE_FS ? "-FS-" : "-NS-"));
            cprintf("RUNS: %4d ", envs[i].env_runs);
            cprintf("CPU: %d ", envs[i].env_cpunum);
            cprintf("PRIORITY: %2d ", envs[i].priority);
            cprintf("STATUS: %s ",
                envs[i].env_status == ENV_DYING ? "DYING" :
                    (envs[i].env_status == ENV_RUNNABLE ? "RUNNABLE" :
                        (envs[i].env_status == ENV_RUNNING ? "RUNNING" :
                            (envs[i].env_status == ENV_NOT_RUNNABLE ? "NOT_RUNNABLE" : "ERROR"))));
            cprintf("%s", envs[i].env_ipc_recving ? "IPC_RECVING " : "");
            cprintf("%s", envs[i].env_ipc_sending ? "IPC_SENDING " : "");
            cprintf("\n");
        }
    }

    if (pflag) {
        if (count)
            cprintf("  Found \033[0;33m%d\033[0m environments.\n", count);
        else
            cprintf("  Found no environment.\n");
    }
    return count;
}

int mon_mm_pinfo(int argc, char **argv, struct Trapframe *tf) {
    return mm_pinfo();
}

int mon_mm_showmaps(int argc, char **argv, struct Trapframe *tf) {
    if (argc < 2 || argc > 3 || argv[1][0] != '0' || argv[1][1] != 'x')
        goto bad_input_showmaps;

    uint64_t start = ROUNDDOWN(mm_gethex(argv[1] + 2), PGSIZE), end = start + PGSIZE;
    if (argc == 3) {
        if (argv[2][0] != '0' || argv[2][1] != 'x')
            goto bad_input_showmaps;
        else
            end = ROUNDUP(mm_gethex(argv[2] + 2), PGSIZE);
    }

    return mm_showmaps(start, end, 1);

bad_input_showmaps:
    cprintf("Usage: showmaps START_ADDRESS [END_ADDRESS]\n");
    cprintf("Example: showmaps 0x8000a00000 0x8000c00000\n\n");
    cprintf("ADDRESS: Use virtual address, hex presentation\n");
    return 0;
}

int mon_mm_setmap(int argc, char **argv, struct Trapframe *tf) {
    if (argc == 1 || argv[1][0] != '0' || argv[1][1] != 'x')
        goto bad_input_setmaps;

    uint64_t start = ROUNDDOWN(mm_gethex(argv[1] + 2), PGSIZE), end = start + PGSIZE, va, count;
    pml4e_t* pml4e = boot_pml4e;
    pte_t *ptep = NULL;

    if (argc == 2) {
        if ((ptep = pml4e_walk(pml4e, (void *)start, 0)))
            mm_printmap(ptep, (void *)start);
        else {
            cprintf("Error: There is no mapping of 0x%016x.\n", start);
        }
        return 0;
    }

    uint64_t k = 2;
    if (argv[2][0] == '0' && argv[2][1] == 'x') {
        end = ROUNDUP(mm_gethex(argv[2] + 2), PGSIZE);
        k = 3;
    }
    if (argc == 3) {
        count = 0;
        for (va = start; va < end; va += PGSIZE)
            if ((ptep = pml4e_walk(pml4e, (void *)va, 0))) {
                count++;
                mm_printmap(ptep, (void *)va);
            }
        if (!count)
            cprintf("Error: There is no mapping within range [0x%016x - 0x%016x].\n", start, end);
        return 0;
    }

    uint64_t setflag = 0, clrflag = 0, value;
    uint64_t *type = NULL;
    while (k < argc) {
        if ((strcmp(argv[k], "-set") == 0))
            type = &setflag;
        else if ((strcmp(argv[k], "-clr") == 0))
            type = &clrflag;
        else {
            if (type == NULL)
                goto bad_input_setmaps;
            if ((strcmp(argv[k], "PTE_P") == 0))
                *type |= PTE_P;
            else if ((strcmp(argv[k], "PTE_W") == 0))
                *type |= PTE_W;
            else if ((strcmp(argv[k], "PTE_U") == 0))
                *type |= PTE_U;
            else if ((strcmp(argv[k], "PTE_PWT") == 0))
                *type |= PTE_PWT;
            else if ((strcmp(argv[k], "PTE_PCD") == 0))
                *type |= PTE_PCD;
            else if ((strcmp(argv[k], "PTE_A") == 0))
                *type |= PTE_A;
            else if ((strcmp(argv[k], "PTE_D") == 0))
                *type |= PTE_D;
            else if ((strcmp(argv[k], "PTE_PS") == 0))
                *type |= PTE_PS;
        }
        k++;
    }
    if (setflag & clrflag)
        goto bad_input_setmaps;

    return mm_setmap(start, end, setflag, clrflag);

bad_input_setmaps:
    cprintf("Usage: setmap START_ADDRESS [END_ADDRESS] [OPERATION 1] [FLAG 1] [FLAG 2] [...] [OPERATION 2] [FLAG 1] [FLAG 2] [...]\n");
    cprintf("Example: setmap 0x8000a00000 0x8000c00000 -set PTE_W -clr PTE_D PTE_PCD\n\n");
    cprintf("ADDRESS: Use virtual address, hex presentation\n\n");
    cprintf("Operations:\n");
    cprintf("  -set\tset the mapping entry of FLAG 1, FLAG 2, ...\n");
    cprintf("  -clr\tclear the mapping entry of FLAG 1, FLAG 2, ...\n\n");
    cprintf("Flags:\n");
    cprintf("  PTE_P\tPresent\n");
    cprintf("  PTE_W\tWriteable\n");
    cprintf("  PTE_U\tUser\n");
    cprintf("  PTE_PWT\tWrite-Through\n");
    cprintf("  PTE_PCD\tCache-Disable\n");
    cprintf("  PTE_A\tAccessed\n");
    cprintf("  PTE_D\tDirty\n");
    cprintf("  PTE_PS\tPage Size\n\n");
    cprintf("The same flag cannot be in operation set and clr at the same time.\n");
    return 0;
}

int mon_mm_dumpmem(int argc, char **argv, struct Trapframe *tf) {
    if (argc != 4 || argv[1][0] != '-' || argv[2][0] != '0' || argv[2][1] != 'x' || argv[3][0] != '0' || argv[3][1] != 'x')
        goto bad_input_dumpmem;
    if (argv[1][1] != 'p' && argv[1][1] != 'v')
        goto bad_input_dumpmem;

    uint64_t start = mm_gethex(argv[2] + 2), end = mm_gethex(argv[3] + 2);

    if (argv[1][1] == 'p') {
        cprintf("  Dump memory from physical address 0x%016x to 0x%016x\n", start, end);
        start = (uint64_t)KADDR(start);
        end = (uint64_t)KADDR(end);
    }

    return mm_dumpmem(start, end);

bad_input_dumpmem:
    cprintf("Usage: dumpmem TYPE START_ADDRESS END_ADDRESS\n");
    cprintf("Example: dumpmem -v 0x8000a00000 0x8000a01000\n\n");
    cprintf("ADDRESS: Use virtual or physical address, hex presentation\n\n");
    cprintf("Types:\n");
    cprintf("  -v\tuse virtual address\n");
    cprintf("  -p\tuse physical address\n");
    return 0;
}

int mon_mm_binfo(int argc, char **argv, struct Trapframe *tf) {
    mm_binfo(1);
    return 0;
}

int mon_mm_bmalloc(int argc, char **argv, struct Trapframe *tf) {
    if (argc != 2)
        goto bad_input_bmalloc;
    int n = mm_getdec(argv[1]);
    return mm_bmalloc(n);

bad_input_bmalloc:
    cprintf("Usage: bmalloc BLOCK_SIZE\n");
    cprintf("Example: bmalloc 16384\n");
    return 0;
}

int mon_mm_bfree(int argc, char **argv, struct Trapframe *tf) {
    if (argc != 2 || argv[1][0] != '0' || argv[1][1] != 'x')
        goto bad_input_bfree;
    uint64_t va = mm_gethex(argv[1] + 2);
    return mm_bfree((void *)va);

bad_input_bfree:
    cprintf("Usage: bfree BLOCK_ADDRESS\n");
    cprintf("Example: bfree 0x9000000000\n");
    cprintf("ADDRESS: Use virtual address, hex presentation\n");
    return 0;
}

int mon_mm_bsplit(int argc, char **argv, struct Trapframe *tf) {
    if (argc != 3 || argv[1][0] != '0' || argv[1][1] != 'x')
        goto bad_input_bsplit;
    uint64_t va = mm_gethex(argv[1] + 2), split = mm_getdec(argv[2]);

    return mm_bsplit((void *)va, (int)split);

bad_input_bsplit:
    cprintf("Usage: bsplit BLOCK_ADDRESS SPLIT_NUMBER\n");
    cprintf("Example: bsplit 0x9000000000 8\n");
    cprintf("ADDRESS: Use virtual address, hex presentation\n");
    return 0;
}

int mon_mm_bcoalesce(int argc, char **argv, struct Trapframe *tf) {
    if (argc < 2)
        goto bad_input_bcoalesce;

    uint64_t coalesce = mm_getdec(argv[1]);
    if (argc != coalesce + 2)
        goto bad_input_bcoalesce;
    if (coalesce > 64) {
        cprintf("  \033[0;31mCoalesce number too large.\033[0m\n");
        return -1;
    }

    uint64_t i;
    void *ptr[64];
    for (i = 2; i < coalesce + 2; i++) {
        if (argv[i][0] != '0' || argv[i][1] != 'x')
            goto bad_input_bcoalesce;
        ptr[i - 2] = (void *)mm_gethex(argv[i] + 2);
    }
    return mm_bcoalesce(coalesce, ptr);

bad_input_bcoalesce:
    cprintf("Usage: bcoalesce COALESCE_NUMBER BLOCK_ADDRESS_1 ... BLOCK_ADDRESS_N\n");
    cprintf("Example: bcoalesce 4 0x9000000000 0x9000001000 0x9000002000 0x9000003000\n");
    cprintf("ADDRESS: Use virtual address, hex presentation\n");
    return 0;
}

int mon_mm_einfo(int argc, char **argv, struct Trapframe *tf) {
    mm_einfo(1);
    return 0;
}

int mon_mm_fputest(int argc, char **argv, struct Trapframe *tf) {
    ENV_CREATE(user_fputest, ENV_TYPE_USER, 15);
    sched_yield();
    return 0;
}

int mon_mm_snapshottest(int argc, char **argv, struct Trapframe *tf) {
    ENV_CREATE(user_snapshottest, ENV_TYPE_USER, PRI_DEF);
    sched_yield();
    return 0;
}

int mon_mm_ehandlertest(int argc, char **argv, struct Trapframe *tf) {
    ENV_CREATE(user_ehandlertest, ENV_TYPE_USER, PRI_DEF);
    sched_yield();
    return 0;
}

int mon_mm_forktest(int argc, char **argv, struct Trapframe *tf) {
    ENV_CREATE(user_forktest, ENV_TYPE_USER, PRI_DEF);
    sched_yield();
    return 0;
}

int mon_mm_schedtest(int argc, char **argv, struct Trapframe *tf) {
    ENV_CREATE(user_printa, ENV_TYPE_USER, PRI_DEF);
    ENV_CREATE(user_printb, ENV_TYPE_USER, PRI_DEF - 10);
    ENV_CREATE(user_printd, ENV_TYPE_USER, PRI_DEF + 10);
    sched_yield();
    return 0;
}

int mon_mm_matrixtest(int argc, char **argv, struct Trapframe *tf) {
    ENV_CREATE(user_matrix, ENV_TYPE_USER, PRI_DEF);
    sched_yield();
    return 0;
}

int mon_mm_powerseriestest(int argc, char **argv, struct Trapframe *tf) {
    ENV_CREATE(user_powerseries, ENV_TYPE_USER, PRI_DEF);
    sched_yield();
    return 0;
}

int mon_mm_ipctest(int argc, char **argv, struct Trapframe *tf) {
    ENV_CREATE(user_ipctest, ENV_TYPE_USER, PRI_DEF);
    sched_yield();
    return 0;
}

int mon_mm_idetest(int argc, char **argv, struct Trapframe *tf) {
    ENV_CREATE(user_idetest, ENV_TYPE_USER, PRI_DEF);
    sched_yield();
    return 0;
}

int mon_mm_linktest(int argc, char **argv, struct Trapframe *tf) {
    ENV_CREATE(user_linktest, ENV_TYPE_USER, PRI_DEF);
    sched_yield();
    return 0;
}