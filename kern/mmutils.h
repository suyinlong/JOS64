

int mm_pageinfo(int argc, char **argv, struct Trapframe *tf);
int mm_showmaps(int argc, char **argv, struct Trapframe *tf);
int mm_setmap(int argc, char **argv, struct Trapframe *tf);
int mm_dumpmem(int argc, char **argv, struct Trapframe *tf);
uint64_t mm_gethex(const char *str);

extern pml4e_t *boot_pml4e;        // Kernel's initial page directory
extern physaddr_t boot_cr3;        // Physical address of boot time page directory
pte_t *pml4e_walk(pml4e_t *pml4e, const void *va, int create);
extern size_t npages;

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

