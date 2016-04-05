/*
* @Author: Yinlong Su
* @Date:   2016-03-25 18:54:33
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-04-04 21:48:09
*/

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/dwarf.h>
#include <kern/kdebug.h>
#include <kern/dwarf_api.h>
#include <kern/mmutils.h>
#include <kern/pmaputils.h>

extern pml4e_t *boot_pml4e;        // Kernel's initial page directory
extern physaddr_t boot_cr3;        // Physical address of boot time page directory
extern size_t npages;
extern struct PageInfo *pages;
extern struct VirtualMap *vms;
extern struct VirtualMap *vms_end;

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
        cprintf("  Virual address: 0x%016x", va);
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

int mm_pageinfo() {
    pml4e_t* pml4ep = boot_pml4e;
    pdpe_t *pdpep = NULL;
    pde_t *pdep = NULL;
    pte_t *ptep = NULL;
    uint64_t info_cr3 = rcr3(), info_cr4 = rcr4();
    cprintf("PGSIZE: %d, boot_pml4e: 0x%016x, CR3: 0x%016x, CR4: 0x%016x\n", PGSIZE, boot_pml4e, info_cr3, info_cr4);
    cprintf("struct PageInfo: 0x%016x\n", pages);

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
                            //cprintf("  Found pgdirp item @ %d : %016x!\n", k, pgdirp[k]);
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
    cprintf("Total: %d pml4 entries, %d pdp entries, %d pd entries and %d pt entries.\n", pml4e_c, pdpe_c, pde_c, pte_c);
    cprintf("       %d 1GB pages, %d 2MB pages, %d 4KB pages (%d pages in total).\n", pdpe_p, pde_p, pte_p, pdpe_p + pde_p + pte_p);
    cprintf("       %d pages are used for paging translation.\n", 1 + pml4e_c + pdpe_c - pdpe_p + pde_c - pde_p);

    return 0;
}

int mm_showmaps(uint64_t start, uint64_t end, int pflag) {
    if (pflag) cprintf("Show maps: [0x%016x - 0x%016x]\n", start, end);

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
        cprintf("Found %d mappings within the range [0x%016x - 0x%016x].\n", count, start, end);
    else
        cprintf("No mapping within the range.\n");
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
        cprintf("No mapping affected.\n");
    else
        cprintf("%d mapping(s) affected.\n", count);

    return 0;
}

int mm_dumpmem(uint64_t start, uint64_t end) {
    cprintf("Dump memory from virtual address 0x%016x to 0x%016x:", start, end);
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

int mm_vmap() {
    int count = 0;
    struct VirtualMap *vme = vms;
    cprintf("Virtual Map\n");
    while (vme != vms_end) {
        count++;
        cprintf("  # Start: 0x%016x End: %016x PAddr: %016x Perm: %d\n", vme->start, vme->end, vme->addr, vme->perm);
        vme++;
    }
    return count;
}

int mon_mm_pageinfo(int argc, char **argv, struct Trapframe *tf) {
    return mm_pageinfo();
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
    return -1;
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

    return -1;
}

int mon_mm_dumpmem(int argc, char **argv, struct Trapframe *tf) {
    if (argc != 4 || argv[1][0] != '-' || argv[2][0] != '0' || argv[2][1] != 'x' || argv[3][0] != '0' || argv[3][1] != 'x')
        goto bad_input_dumpmem;
    if (argv[1][1] != 'p' && argv[1][1] != 'v')
        goto bad_input_dumpmem;

    uint64_t start = mm_gethex(argv[2] + 2), end = mm_gethex(argv[3] + 2);

    if (argv[1][1] == 'p') {
        cprintf("Dump memory from physical address 0x%016x to 0x%016x\n", start, end);
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

    return -1;
}

int mon_mm_vmap(int argc, char **argv, struct Trapframe *tf) {
    mm_vmap();
    return 0;
}