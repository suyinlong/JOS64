
int mon_mm_pinfo(int argc, char **argv, struct Trapframe *tf);
int mon_mm_showmaps(int argc, char **argv, struct Trapframe *tf);
int mon_mm_setmap(int argc, char **argv, struct Trapframe *tf);
int mon_mm_dumpmem(int argc, char **argv, struct Trapframe *tf);

int mon_mm_binfo(int argc, char **argv, struct Trapframe *tf);
int mon_mm_bmalloc(int argc, char **argv, struct Trapframe *tf);
int mon_mm_bfree(int argc, char **argv, struct Trapframe *tf);
int mon_mm_bsplit(int argc, char **argv, struct Trapframe *tf);
int mon_mm_bcoalesce(int argc, char **argv, struct Trapframe *tf);

int mon_mm_einfo(int argc, char **argv, struct Trapframe *tf);

int mon_mm_fputest(int argc, char **argv, struct Trapframe *tf);
int mon_mm_snapshottest(int argc, char **argv, struct Trapframe *tf);
int mon_mm_ehandlertest(int argc, char **argv, struct Trapframe *tf);
int mon_mm_forktest(int argc, char **argv, struct Trapframe *tf);
int mon_mm_schedtest(int argc, char **argv, struct Trapframe *tf);
int mon_mm_matrixtest(int argc, char **argv, struct Trapframe *tf);
int mon_mm_powerseriestest(int argc, char **argv, struct Trapframe *tf);
int mon_mm_ipctest(int argc, char **argv, struct Trapframe *tf);

pte_t *pml4e_walk(pml4e_t *pml4e, const void *va, int create);


/* This macro takes a kernel virtual address -- an address that points above
 * KERNBASE, where the machine's maximum 256MB of physical memory is mapped --
 * and returns the corresponding physical address.  It panics if you pass it a
 * non-kernel virtual address.
 */
#define PADDR(kva)                      \
({                              \
    physaddr_t __m_kva = (physaddr_t) (kva);        \
    if (__m_kva < KERNBASE)                 \
        panic("PADDR called with invalid kva %08lx", __m_kva);\
    __m_kva - KERNBASE;                 \
})

/* This macro takes a physical address and returns the corresponding kernel
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa)                       \
({                              \
    physaddr_t __m_pa = (pa);               \
    uint32_t __m_ppn = PPN(__m_pa);\
    if (__m_ppn >= npages)                  \
        panic("KADDR called with invalid pa %08lx", __m_pa);\
    (void*) ((uint64_t)(__m_pa + KERNBASE));                \
})

