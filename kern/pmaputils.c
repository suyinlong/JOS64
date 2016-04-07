/*
* @Author: Yinlong Su
* @Date:   2016-04-01 09:08:45
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-04-06 23:19:01
*/

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>
#include <inc/error.h>

#include <kern/pmap.h>
#include <kern/pmaputils.h>

int mm_showmaps(uint64_t start, uint64_t end, int pflag);
int mm_vmap();

struct VirtualMap *vms, *vms_end;       // Virtual map start & end address

extern size_t npages;                   // Amount of physical memory (in pages)
extern size_t npages_basemem;           // Amount of base memory (in pages)
extern struct PageInfo *pages;          // Physical page state array
extern struct PageInfo *page_free_list; // Free list of physical pages

// --------------------------------------------------------------
// For challenge 1, 4 of lab 2
// --------------------------------------------------------------
// check if there exist a contiguous block of <p> pages
// these p pages should also be aligned
// normally p = 1 (4KB, which is trivial),
//              512 (2MB, with PDE.PS=1),
//              262144 (1GB, with PDPE.PS=1, unlikely)
struct PageInfo *page_contiguous_block(size_t p) {
    // no free memory
    if (!page_free_list)
        return NULL;
    // just one page
    if (p == 1)
        return page_free_list;

    struct PageInfo *first = page_free_list, *prev = first, *current = prev->pp_link;
    size_t k = 1;

    while (k < p) {
        if (!current)
            return NULL;
        // Condition 1: need to be contiguous
        // Condition 2: start address need to be aligned to PDE_PS_PGSIZE (>=2MB) or PGSIZE (<2MB)
        if ((uint64_t)current - (uint64_t)prev != sizeof(struct PageInfo) ||
            (uint64_t)page2kva(first) % BLOCK_ALIGN(p) != 0) {

            first = current;
            k = 1;
        }
        else
            k++;
        prev = current;
        current = current->pp_link;
    }

    if (k == p) {
        // From first, n contiguous pages should be alloc into one entry
        //    *** Note: page_free_list is unordered, this means we
        //    ***       may actually have n contiguous pages but not
        //    ***       n contiguous entries in page_free_list
        //    ***                                             Yinlong Su
        //cprintf("block pp: %x va: %x pa: %x\n", first, page2kva(first), page2pa(first));
        //memset(page2kva(first), 0, p * PGSIZE);
        return first;
    }
    else
        return NULL;
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// Remove <p> contiguous pages from page_free_list, starting from pp
// Typically, p = 512 (2MB)
// When a 2MB page is alloced, 512 pages should be removed from
// page_free_list. We keep the pp_link in the removed entries so
// that the page_incref() page_decref() can change the reference #
// in the same block.
struct PageInfo *page_contiguous_alloc(size_t p) {
    struct PageInfo *pp = page_contiguous_block(p);
    int k = 1;
    //cprintf("p_c_a: p %d pp %x pp next %x page_free_list %x", p, pp, pp->pp_link, page_free_list);
    if (pp) {
        // remove p entries from page_free_list, starting from pp
        struct PageInfo *prev = NULL, *current = page_free_list;
        while (current != pp) {
            prev = current;
            current = current->pp_link;
        }
        struct PageInfo *before = prev;
        while (k < p) {
            prev = current;
            current = current->pp_link;
            k++;
        }
        struct PageInfo *after = current->pp_link;
        current->pp_link = NULL;
        if (before)
            before->pp_link = after;
        else
            page_free_list = after;
    }
    //cprintf(" -> %x\n", page_free_list);
    return pp;
}

// --------------------------------------------------------------
// For challenge 1, 4 of lab 2
// --------------------------------------------------------------
// Increment the reference count on <p> page entries,
// starting from <pp>
void page_incref(struct PageInfo* pp, size_t p)
{
    size_t k = 0;
    while (pp && k < p) {
        pp->pp_ref++;
        k++;
        pp = pp->pp_link;
    }
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// The page free list may be unordered. When we need to alloc
// a contigous page bigger than 4KB, reorder the free list first
// then find the contigous block
void page_free_list_reorder() {
    size_t i;
    struct PageInfo* last = NULL;
    page_free_list = NULL;
    for (i = npages - 1; i > 0; i--) {
        if (i >= npages_basemem && i < ((uint64_t)ptr_boot_alloc(0) - KERNBASE) / PGSIZE)
            continue;
        if (pages[i].pp_ref)
            continue;
        pages[i].pp_link = page_free_list;
        page_free_list = &pages[i];


    }
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// In the page tables, map virtual address to physical address
// <p> is page number (contigous)
// <va> is start virtual address
// <pa> is start physical address
// <flag> is PDE.PS flag (2MB enable)
//
// Note: The input va and pa is not necessary to be aligned to
//       PDE_PS_PGSIZE (if the block > 2MB). But it is only when the
//       addresses are aligned to PDE_PS_PGSIZE that the 2MB page
//       will be alloced
void page_update(size_t p, void *va, void *pa, int flag) {
    pte_t *ptep;
    pde_t *pdep;
    pml4e_t* pml4e = KADDR(rcr3());

    uint64_t i = 0;
    while (i < p) {
        if (flag && p - i >= PDE_PS_PGNUM && (uint64_t)(va + i * PGSIZE) % PDE_PS_PGSIZE == 0) {
            //cprintf("alloc 2MB from %x (offset %d)\n", current, b_offset);
            // walk to pml4e use PDE_PS_FLAG | 1
            pdep = pml4e_walk(pml4e, (void *)(va + i * PGSIZE), 1 | PDE_PS_FLAG);
            *pdep = PDE_ADDR(pa + i * PGSIZE) | PTE_W | PTE_U | PTE_P | PTE_PS;
            //cprintf("va %x *pdep %d\n", va + b_offset * PGSIZE, *pdep);
            i += PDE_PS_PGNUM;
        }
        else {
            //cprintf("alloc 4KB from %x (offset %d)\n", current, b_offset);
            // walk to pml4e use 1
            ptep = pml4e_walk(pml4e, (void *)(va + i * PGSIZE), 1);
            *ptep = PTE_ADDR(pa + i * PGSIZE) | PTE_W | PTE_U | PTE_P;
            i += 1;
        }
    }
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// Malloc a physical contigous block of <n> bytes
//
// The length will be round up to 2^k
void *c_malloc(size_t n) {
    struct PageInfo *pp;
    size_t nn = PGSIZE, p = 1;

    // ROUNDUP nn to 2^k
    while (nn < n) {
        nn <<= 1;
        p <<= 1;
    }

    // reorder page free list
    page_free_list_reorder();
    // find contiguous physical pages
    pp = page_contiguous_block(p);
    if (!pp)
        return NULL;
    page_contiguous_alloc(p);
    page_incref(pp, p);

    //cprintf("c_malloc: n: %d nn: %d p: %d pp: %x\n", n, nn, p, pp);

    // find free virtual address space
    void *va = vm_block(nn), *pa = (void *)page2pa(pp);

    // map the virtual address to physical address in page table
    page_update(p, va, pa, 1);

    // save the mapping in our VirtualMap
    vm_insert(va, va + nn, pa, VME_U);
    //cprintf("c_malloc: va: %x pa: %x\n", va, pa);
    return va;
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// Free a physical contigous block at virtual address <va>
//
// The length will be round up to 2^k
void c_free(void *va) {
    pml4e_t* pml4e = KADDR(rcr3());
    pte_t *ptep = NULL;
    struct VirtualMap *vme = vm_lookup(va);
    // no entry match, return
    if (vme == vms_end || vme->start != va)
        return;
    void *end = vme->end;

    int flag = 0;
    // remove all the pages in this block, pages can be 2MB or 4KB
    while (va < end) {
        ptep = pml4e_walk(pml4e, va, 0);
        flag = (*ptep & PTE_PS);
        page_remove(pml4e, va);
        if (flag)
            va += PDE_PS_PGSIZE;
        else
            va += PGSIZE;
    }
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// Split a physical contigous block at virtual address <va>
// into <split> pieces, the pointer of the result will be saved
// in <ptr>
//
// Note: User should make sure <ptr> can hold <split> pointers.
//       When split a block bigger than or equal to 2MB into
//       pieces that smaller than 2MB, the pages of this block
//       will be disassembled to 4KB normal pages
int c_split(void *va, int split, void **ptr) {
    // split number too small or is not 2^k
    if (split < 2 || (split & (split - 1)))
        return -1;
    struct VirtualMap *vme = vm_lookup(va);
    // no entry match, return
    if (vme == vms_end || vme->start != va)
        return -2;
    // split number too big
    if ((vme->end - vme->start) / PGSIZE < split)
        return -3;
    // try to split a kernel mapping
    if (!(vme->perm & VME_U))
        return -4;

    int i;
    pml4e_t* pml4e = KADDR(rcr3());
    pte_t *ptep;
    uint64_t block_size = vme->end - vme->start, unit_size = block_size / split;
    void *pa = vme->addr;
    if (block_size > PDE_PS_PGSIZE && unit_size < PDE_PS_PGSIZE) {
        // Split from 2MB pages to 4KB pages
        // first free the block, then remap it with only 4KB pages
        //cprintf("oversize split\n");
        c_free(va);
        page_update(block_size / PGSIZE, va, pa, 0);
    }
    // remove the old mapping in VirtualMap
    vm_delete(va, VME_U);
    for (i = 0; i < split; i++) {
        // insert the new mappings
        vm_insert(va, va + unit_size, pa, VME_U);
        ptr[i] = va;
        va += unit_size;
        pa += unit_size;
    }
    return 0;
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// Coalesce <coalesce> physical contigous blocks in the pointer
// array <ptr>
//
// Check: the pointers should be valid (in VirtualMap)
//        the pointer address spaces is contigous
//
// Note: If coalesce blocks to bigger than or equal to 2MB,
//       this function will try to use 2MB page when possible.
void *c_coalesce(int coalesce, void **ptr) {
    // coalesce too small
    if (coalesce < 2)
        return NULL;
    struct VirtualMap *vme = vm_lookup(ptr[0]);
    // no entry match, return
    if (vme == vms_end || vme->start != ptr[0])
        return NULL;

    void *base_va = vme->start, *base_pa = vme->addr;
    void *va = base_va;
    void *pa = base_pa;
    int i;
    for (i = 0; i < coalesce; i++) {
        vme = vm_lookup(ptr[i]);
        // Condition 1 & 2: the pointer is valid in VirtualMap
        // Condition 3 & 4: the virtual and physical address is contigous
        if (vme == vms_end || vme->start != ptr[i] || va != vme->start || pa != vme->addr)
            return NULL;
        va = vme->end;
        pa = vme->addr + (vme->end - vme->start);
    }
    // free all the sub-blocks
    for (i = 0; i < coalesce; i++)
        c_free(ptr[i]);
    // realloc the new block, try to use 2MB pages
    page_update((va - base_va) / PGSIZE, base_va, base_pa, 1);
    // insert the new mapping
    vm_insert(base_va, va, base_pa, VME_U);
    return ptr[0];
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// Init the VirtualMap structure
// vms points to the base address of VirtualMap
// vms_end points to the end of VirtualMap
void vm_init() {
    vms = (void *)pages + npages * sizeof(struct PageInfo);
    memset(vms, 0, VM_NUMBER * sizeof(struct VirtualMap));
    vms_end = vms;
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// Find the insert point of virtual address <start> in VirtualMap
struct VirtualMap *vm_lookup(void *start) {
    struct VirtualMap *vme = vms;

    while (vme < vms_end && start >= vme->end)
        vme++;
    return vme;
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// Insert a mapping into VirtualMap
// <start> is the start virtual address
// <end> is the end virtual address
// <addr> is the start physical address
// <perm> is the permission
int vm_insert(void *start, void *end, void *addr, uint8_t perm) {
    struct VirtualMap *vme = NULL;
    // check if the VirtualMap is full
    if (vms_end == vms + VM_NUMBER * sizeof(struct VirtualMap))
        return -E_NO_MEM;
    // find the insert point
    vme = vm_lookup(start);
    if (vme != vms_end)
        memmove((vme + 1), vme, (vms_end - vme) * sizeof(struct VirtualMap));
    vms_end ++;

    vme->start = start;
    vme->end = end;
    vme->addr = addr;
    vme->perm = perm;
    //cprintf("vm_insert @ %x: start %x end %x addr %x perm %d\n", vme, start, end, addr, perm);
    return 0;
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// Delete a mapping into VirtualMap
// <start> is the start virtual address
// <perm> is the permission
int vm_delete(void *start, uint8_t perm) {
    //cprintf("vm_delete @ %x: start %x end %x perm %d\n", 0, start, end, perm);
    struct VirtualMap *vme = NULL;

    vme = vm_lookup(start);
    // check if the entry is the target
    if (vme != vms_end && vme->start == start) {
        memmove(vme, (vme + 1), (vms_end - 1 - vme) * sizeof(struct VirtualMap));
        vms_end--;
        vms_end->start = 0;
        vms_end->end = 0;
        vms_end->addr = 0;
        vms_end->perm = 0;
    }

    return 0;
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// Find a free and contigous virtual space of <n> bytes in VirtualMap
void *vm_block(size_t n) {
    void *va = (void *)VM_U_START;
    struct VirtualMap *vme = vm_lookup(va);

    if (vme == vms_end || vme->start >= va + n)
        return va;

    do {
        va += BLOCK_ALIGN(n / PGSIZE);
        vme = vm_lookup(va);
    } while (vme != vms_end && vme->start < va + n);

    //cprintf("vm_block: va: %x vme: %x vms_end: %x\n", va, vme, vms_end);
    //cprintf("          start: %x end: %x addr: %x perm: %d\n", vme->start, vme->end, vme->addr, vme->perm);

    return va;
}

void check_c_utils() {
    void *cp1, *cp2, *cp3, *cp4, *cp5;
    struct VirtualMap *vme1, *vme2, *vme3;
    void *ptr[8];

    cp1 = cp2 = cp3 = cp4 = cp5 = 0;
    vme1 = vme2 = vme3 = 0;
    ptr[0] = ptr[1] = ptr[2] = ptr[3] = ptr[4] = ptr[5] = ptr[6] = ptr[7] = 0;

    // malloc cp1 as 32KB (8 pages, 4KB per page)
    // malloc cp2 as  8MB (4 pages, 2MB per page)
    assert(cp1 = c_malloc(PGSIZE * 8));
    assert(cp2 = c_malloc(PDE_PS_PGSIZE * 4));

    // check the page numbers, should be 8 and 4
    assert(mm_showmaps((uint64_t)cp1, (uint64_t)cp1 + PGSIZE * 8, 0) == 8);
    assert(mm_showmaps((uint64_t)cp2, (uint64_t)cp2 + PDE_PS_PGSIZE * 4, 0) == 4);

    vme1 = vm_lookup(cp1);
    vme2 = vm_lookup(cp2);
    // should have correct entries in VirtualMap
    assert(vme1 != vms_end && vme1->start == cp1 && vme1->end == vme1->start + PGSIZE * 8);
    assert(vme2 != vms_end && vme2->start == cp2 && vme2->end == vme2->start + PDE_PS_PGSIZE * 4);

    // split 32KB into 8 pieces, the page number should be 8 (no change)
    c_split(cp1, 8, ptr);
    assert(mm_showmaps((uint64_t)cp1, (uint64_t)cp1 + PGSIZE * 8, 0) == 8);

    // check the pointer array
    assert(ptr[0]);
    assert(ptr[1] && ptr[1] != ptr[0]);
    assert(ptr[2] && ptr[2] != ptr[1] && ptr[2] != ptr[0]);
    assert(ptr[3] && ptr[3] != ptr[2] && ptr[3] != ptr[1] && ptr[3] != ptr[0]);
    assert(ptr[4] && ptr[4] != ptr[3] && ptr[4] != ptr[2] && ptr[4] != ptr[1] && ptr[4] != ptr[0]);
    assert(ptr[5] && ptr[5] != ptr[4] && ptr[5] != ptr[3] && ptr[5] != ptr[2] && ptr[5] != ptr[1] && ptr[5] != ptr[0]);
    assert(ptr[6] && ptr[6] != ptr[5] && ptr[6] != ptr[4] && ptr[6] != ptr[3] && ptr[6] != ptr[2] && ptr[6] != ptr[1] && ptr[6] != ptr[0]);
    assert(ptr[7] && ptr[7] != ptr[6] && ptr[7] != ptr[5] && ptr[7] != ptr[4] && ptr[7] != ptr[3] && ptr[7] != ptr[2] && ptr[7] != ptr[1] && ptr[7] != ptr[0]);

    // check the validity and continuousness
    vme1 = vm_lookup(ptr[0]);
    assert(vme1 != vms_end && vme1->start == ptr[0] && vme1->end == vme1->start + PGSIZE);
    vme2 = vm_lookup(ptr[1]);
    assert(vme2 != vms_end && vme2->start == ptr[1] && vme2->start == vme1->end && vme2->end == vme2->start + PGSIZE);
    vme3 = vm_lookup(ptr[2]);
    assert(vme3 != vms_end && vme3->start == ptr[2] && vme3->start == vme2->end && vme3->end == vme3->start + PGSIZE);
    vme1 = vm_lookup(ptr[3]);
    assert(vme1 != vms_end && vme1->start == ptr[3] && vme1->start == vme3->end && vme1->end == vme1->start + PGSIZE);
    vme2 = vm_lookup(ptr[4]);
    assert(vme2 != vms_end && vme2->start == ptr[4] && vme2->start == vme1->end && vme2->end == vme2->start + PGSIZE);
    vme3 = vm_lookup(ptr[5]);
    assert(vme3 != vms_end && vme3->start == ptr[5] && vme3->start == vme2->end && vme3->end == vme3->start + PGSIZE);
    vme1 = vm_lookup(ptr[6]);
    assert(vme1 != vms_end && vme1->start == ptr[6] && vme1->start == vme3->end && vme1->end == vme1->start + PGSIZE);
    vme2 = vm_lookup(ptr[7]);
    assert(vme2 != vms_end && vme2->start == ptr[7] && vme2->start == vme1->end && vme2->end == vme2->start + PGSIZE);

    // coalesce the block as 3 pages, 2 pages and 3 pages
    assert(cp3 = c_coalesce(3, &ptr[0]));
    assert(cp4 = c_coalesce(2, &ptr[3]));
    assert(cp5 = c_coalesce(3, &ptr[5]));
    // the page number in 3 blocks should be 3, 2, 3
    assert(mm_showmaps((uint64_t)cp3, (uint64_t)cp3 + PGSIZE * 3, 0) == 3);
    assert(mm_showmaps((uint64_t)cp4, (uint64_t)cp4 + PGSIZE * 2, 0) == 2);
    assert(mm_showmaps((uint64_t)cp5, (uint64_t)cp5 + PGSIZE * 3, 0) == 3);
    // check the validity and continuousness
    vme1 = vm_lookup(cp3);
    assert(vme1 != vms_end && vme1->start == cp3 && vme1->end == vme1->start + PGSIZE * 3);
    vme2 = vm_lookup(cp4);
    assert(vme2 != vms_end && vme2->start == cp4 && vme2->start == vme1->end && vme2->end == vme2->start + PGSIZE * 2);
    vme3 = vm_lookup(cp5);
    assert(vme3 != vms_end && vme3->start == cp5 && vme3->start == vme2->end && vme3->end == vme3->start + PGSIZE * 3);
    // coalesce the 3 blocks to 1, the page number should be 8
    ptr[0] = cp3; ptr[1] = cp4; ptr[2] = cp5;
    assert(cp3 = c_coalesce(3, &ptr[0]));
    assert(mm_showmaps((uint64_t)cp3, (uint64_t)cp3 + PGSIZE * 8, 0) == 8);
    // check the validity and continuousness
    vme1 = vm_lookup(cp3);
    assert(vme1 != vms_end && vme1->start == cp3 && vme1->end == vme1->start + PGSIZE * 8);

    // now split 8MB into 8 pieces
    // since the unit size will be 1MB, the 2MB pages will be disassembled into 4KB pages
    // the page number should be 512 * 4 = 2048
    c_split(cp2, 8, ptr);
    assert(mm_showmaps((uint64_t)cp2, (uint64_t)cp2 + PDE_PS_PGSIZE * 4, 0) == 2048);
    // check the pointer array
    assert(ptr[0]);
    assert(ptr[1] && ptr[1] != ptr[0]);
    assert(ptr[2] && ptr[2] != ptr[1] && ptr[2] != ptr[0]);
    assert(ptr[3] && ptr[3] != ptr[2] && ptr[3] != ptr[1] && ptr[3] != ptr[0]);
    assert(ptr[4] && ptr[4] != ptr[3] && ptr[4] != ptr[2] && ptr[4] != ptr[1] && ptr[4] != ptr[0]);
    assert(ptr[5] && ptr[5] != ptr[4] && ptr[5] != ptr[3] && ptr[5] != ptr[2] && ptr[5] != ptr[1] && ptr[5] != ptr[0]);
    assert(ptr[6] && ptr[6] != ptr[5] && ptr[6] != ptr[4] && ptr[6] != ptr[3] && ptr[6] != ptr[2] && ptr[6] != ptr[1] && ptr[6] != ptr[0]);
    assert(ptr[7] && ptr[7] != ptr[6] && ptr[7] != ptr[5] && ptr[7] != ptr[4] && ptr[7] != ptr[3] && ptr[7] != ptr[2] && ptr[7] != ptr[1] && ptr[7] != ptr[0]);

    // check the validity and continuousness
    vme1 = vm_lookup(ptr[0]);
    assert(vme1 != vms_end && vme1->start == ptr[0] && vme1->end == vme1->start + PDE_PS_PGSIZE / 2);
    vme2 = vm_lookup(ptr[1]);
    assert(vme2 != vms_end && vme2->start == ptr[1] && vme2->start == vme1->end && vme2->end == vme2->start + PDE_PS_PGSIZE / 2);
    vme3 = vm_lookup(ptr[2]);
    assert(vme3 != vms_end && vme3->start == ptr[2] && vme3->start == vme2->end && vme3->end == vme3->start + PDE_PS_PGSIZE / 2);
    vme1 = vm_lookup(ptr[3]);
    assert(vme1 != vms_end && vme1->start == ptr[3] && vme1->start == vme3->end && vme1->end == vme1->start + PDE_PS_PGSIZE / 2);
    vme2 = vm_lookup(ptr[4]);
    assert(vme2 != vms_end && vme2->start == ptr[4] && vme2->start == vme1->end && vme2->end == vme2->start + PDE_PS_PGSIZE / 2);
    vme3 = vm_lookup(ptr[5]);
    assert(vme3 != vms_end && vme3->start == ptr[5] && vme3->start == vme2->end && vme3->end == vme3->start + PDE_PS_PGSIZE / 2);
    vme1 = vm_lookup(ptr[6]);
    assert(vme1 != vms_end && vme1->start == ptr[6] && vme1->start == vme3->end && vme1->end == vme1->start + PDE_PS_PGSIZE / 2);
    vme2 = vm_lookup(ptr[7]);
    assert(vme2 != vms_end && vme2->start == ptr[7] && vme2->start == vme1->end && vme2->end == vme2->start + PDE_PS_PGSIZE / 2);

    // coalesce the block as 1/8, 5/8, 2/8
    assert(cp3 = ptr[0]);
    assert(cp4 = c_coalesce(5, &ptr[1]));
    assert(cp5 = c_coalesce(2, &ptr[6]));
    // the page number in 3 blocks should be:
    // block 1 (1/8): 1MB block, 256 pages (4KB)
    // block 2 (5/8): 5MB block, 256 pages (4KB) [coz the first 1MB is not aligned to 2MB]
    //                         +   2 pages (2MB) [aligned]
    //                         = 258 pages       (with different sizes)
    // block 3 (2/8): 2MB block,   1 page        [aligned]
    assert(mm_showmaps((uint64_t)cp3, (uint64_t)cp3 + PDE_PS_PGSIZE / 2, 0) == 256);
    assert(mm_showmaps((uint64_t)cp4, (uint64_t)cp4 + PDE_PS_PGSIZE / 2 * 5, 0) == 258);
    assert(mm_showmaps((uint64_t)cp5, (uint64_t)cp5 + PDE_PS_PGSIZE / 2 * 2, 0) == 1);
    // check the validity and continuousness
    vme1 = vm_lookup(cp3);
    assert(vme1 != vms_end && vme1->start == cp3 && vme1->end == vme1->start + PDE_PS_PGSIZE / 2);
    vme2 = vm_lookup(cp4);
    assert(vme2 != vms_end && vme2->start == cp4 && vme2->start == vme1->end && vme2->end == vme2->start + PDE_PS_PGSIZE / 2 * 5);
    vme3 = vm_lookup(cp5);
    assert(vme3 != vms_end && vme3->start == cp5 && vme3->start == vme2->end && vme3->end == vme3->start + PDE_PS_PGSIZE / 2 * 2);
    // coalesce the 3 blocks to 1, the page number should become 4
    ptr[0] = cp3; ptr[1] = cp4; ptr[2] = cp5;
    assert(cp3 = c_coalesce(3, &ptr[0]));
    assert(mm_showmaps((uint64_t)cp3, (uint64_t)cp3 + PDE_PS_PGSIZE * 4, 0) == 4);
    // check the validity and continuousness
    vme1 = vm_lookup(cp3);
    assert(vme1 != vms_end && vme1->start == cp3 && vme1->end == vme1->start + PDE_PS_PGSIZE * 4);
    // free the blocks
    c_free(cp1);
    c_free(cp2);

    cprintf("check_c_utils() succeeded!\n");
    return;

}