/*
* @Author: Yinlong Su
* @Date:   2016-04-01 09:08:45
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-04-13 13:04:23
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
int mm_binfo(int pflag);

struct BlockInfo *bis = NULL, *bis_end = NULL;       // Block Info start & end address

extern size_t npages;                   // Amount of physical memory (in pages)
extern size_t npages_basemem;           // Amount of base memory (in pages)
extern struct PageInfo *pages;          // Physical page state array
extern struct PageInfo *page_free_list; // Free list of physical pages

extern struct BlockInfo *boot_bis;

int b_ring = 3; // set the block malloc/free environment (0 = kernel, 3 = user)

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
// Remove <p> contiguous pages from page_free_list, starting from <pp>
// Return the next page after the <p> contiguous pages
// Typically, p = 512 (2MB)
// When a 2MB page is alloced, 512 pages should be removed from
// page_free_list. We keep the pp_link in the removed entries so
// that the page_incref() page_decref() can change the reference #
// in the same block.
struct PageInfo *page_contiguous_alloc(struct PageInfo *pp, size_t p) {
    int k = 1;
    struct PageInfo *prev, *current, *before, *after = NULL;
    //cprintf("p_c_a: p %d pp %x pp next %x page_free_list %x", p, pp, pp->pp_link, page_free_list);
    if (pp) {
        // remove p entries from page_free_list, starting from pp
        prev = NULL;
        current = page_free_list;
        while (current != pp) {
            prev = current;
            current = current->pp_link;
        }
        before = prev;
        while (k < p) {
            prev = current;
            current = current->pp_link;
            k++;
        }
        after = current->pp_link;
        current->pp_link = NULL;
        if (before)
            before->pp_link = after;
        else
            page_free_list = after;
    }
    //cprintf(" -> %x\n", page_free_list);
    return after;
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
//
// Apr 7th: Replace the old version of page_init()
//          provided by Xunyu Yao
void page_free_list_reorder() {
    size_t i;
    struct PageInfo* last = NULL;
    page_free_list = NULL;
    for (i = npages - 1; i > 0; i--) {
        if (page2pa(&pages[i]) >= PADDR(KERNBASE + IOPHYSMEM) && page2pa(&pages[i]) < PADDR(ptr_boot_alloc(0)))
            continue;
        if (page2pa(&pages[i]) == MPENTRY_PADDR)
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
            *pdep = PDE_ADDR(pa + i * PGSIZE) | PTE_USER | PTE_PS;
            //cprintf("va %x *pdep %x\n", va + i * PGSIZE, *pdep);
            i += PDE_PS_PGNUM;
        }
        else {
            //cprintf("alloc 4KB from %x (offset %d)\n", current, b_offset);
            // walk to pml4e use 1
            ptep = pml4e_walk(pml4e, (void *)(va + i * PGSIZE), 1);
            *ptep = PTE_ADDR(pa + i * PGSIZE) | PTE_USER;
            //cprintf("va: %x *ptep %x\n", va + i * PGSIZE, *ptep);
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
void *b_malloc(size_t n) {
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

    // contiguous alloc the pages
    struct PageInfo *current = pp, *next = NULL;
    size_t c = p;
    while (c > 0) {
        next = page_contiguous_alloc(current, BLOCK_PGNUM(c));
        page_incref(current, BLOCK_PGNUM(c));
        c -= BLOCK_PGNUM(c);
        current = next;
    }

    //cprintf("b_malloc: n: %d nn: %d p: %d pp: %x\n", n, nn, p, pp);

    // find free virtual address space
    void *va = bi_block(nn), *pa = (void *)page2pa(pp);

    // map the virtual address to physical address in page table
    page_update(p, va, pa, 1);

    // save the mapping in our BlockInfo
    bi_insert(va, va + nn, pa, BIE_U);
    //cprintf("b_malloc: va: %x pa: %x\n", va, pa);
    return va;
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// Free a physical contigous block at virtual address <va>
void b_free(void *va) {
    pml4e_t* pml4e = KADDR(rcr3());
    pte_t *ptep = NULL;
    struct BlockInfo *bie = bi_lookup(va);
    // no entry match, return
    if (bie == bis_end || bie->start != va)
        return;
    void *start = va, *end = bie->end;

    int flag = 0, c = 0;
    // remove all the pages in this block, pages can be 2MB or 4KB
    while (va < end) {
        ptep = pml4e_walk(pml4e, va, 0);
        flag = (*ptep & PTE_PS);
        page_remove(pml4e, va);
        if (flag)
            va += PDE_PS_PGSIZE;
        else
            va += PGSIZE;
        c++;
    }

    bi_delete(start, end, BIE_U);
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
int b_split(void *va, int split, void **ptr) {
    // split number too small or is not 2^k
    if (split < 2 || (split & (split - 1)))
        return -1;
    struct BlockInfo *bie = bi_lookup(va);
    // no entry match, return
    if (bie == bis_end || bie->start != va)
        return -2;
    // split number too big
    if ((bie->end - bie->start) / PGSIZE < split)
        return -3;
    // try to split a kernel mapping
    if (!(bie->perm & BIE_U))
        return -4;

    int i;
    pml4e_t* pml4e = KADDR(rcr3());
    uint64_t block_size = bie->end - bie->start, unit_size = block_size / split;
    void *pa = bie->addr;
    if (block_size > PDE_PS_PGSIZE && unit_size < PDE_PS_PGSIZE) {
        // Split from 2MB pages to 4KB pages
        // first free the block, then remap it with only 4KB pages
        struct PageInfo *pp = page_lookup(pml4e, va, NULL);

        b_free(va);
        page_free_list_reorder();

        struct PageInfo *current = pp, *next = NULL;
        size_t c = block_size / PGSIZE;
        while (c > 0) {
            next = page_contiguous_alloc(current, 1);
            page_incref(current, 1);
            c -= 1;
            current = next;
        }
        page_update(block_size / PGSIZE, va, pa, 0);
    }
    // remove the old mapping in BlockInfo
    bi_delete(va, va + block_size, BIE_U);
    for (i = 0; i < split; i++) {
        // insert the new mappings
        bi_insert(va, va + unit_size, pa, BIE_U);
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
// Check: the pointers should be valid (in BlockInfo)
//        the pointer address spaces is contigous
//
// Note: If coalesce blocks to bigger than or equal to 2MB,
//       this function will try to use 2MB page when possible.
void *b_coalesce(int coalesce, void **ptr) {
    // coalesce too small
    if (coalesce < 2)
        return NULL;
    struct BlockInfo *bie = bi_lookup(ptr[0]);
    // no entry match, return
    if (bie == bis_end || bie->start != ptr[0])
        return NULL;

    pml4e_t* pml4e = KADDR(rcr3());
    void *base_va = bie->start, *base_pa = bie->addr;
    void *va = base_va;
    void *pa = base_pa;
    int i;
    for (i = 0; i < coalesce; i++) {
        bie = bi_lookup(ptr[i]);
        // Condition 1 & 2: the pointer is valid in BlockInfo
        // Condition 3 & 4: the virtual and physical address is contiguous
        if (bie == bis_end || bie->start != ptr[i] || va != bie->start || pa != bie->addr)
            return NULL;
        va = bie->end;
        pa = bie->addr + (bie->end - bie->start);
    }
    struct PageInfo *pp = page_lookup(pml4e, ptr[0], NULL);

    // free all the sub-blocks
    for (i = coalesce - 1; i >= 0; i--)
        b_free(ptr[i]);

    page_free_list_reorder();
    // contiguous alloc the pages
    struct PageInfo *current = pp, *next = NULL;
    void *c_va = base_va;
    size_t c = (va - base_va) / PGSIZE, a = 0, b = 0;;
    while (c > 0) {
        if ((uint64_t)c_va % PDE_PS_PGSIZE == 0) {
            next = page_contiguous_alloc(current, BLOCK_PGNUM(c));
            page_incref(current, BLOCK_PGNUM(c));
            c -= BLOCK_PGNUM(c);
            c_va += PDE_PS_PGSIZE;
        }
        else {
            next = page_contiguous_alloc(current, 1);
            page_incref(current, 1);
            c -= BLOCK_PGNUM(1);
            c_va += PGSIZE;
        }
        current = next;
    }
    // update the page table
    page_update((va - base_va) / PGSIZE, base_va, base_pa, 1);
    // insert the new mapping
    bi_insert(base_va, va, base_pa, BIE_U);
    return ptr[0];
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// Init the BlockInfo structure
// bis points to the base address of BlockInfo
// bis_end points to the end of BlockInfo
void bi_init() {
    bis = boot_bis;
    memset(bis, 0, BLOCK_NUMBER * sizeof(struct BlockInfo));
    bis_end = bis;
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// Find the insert point of virtual address <start> in BlockInfo
struct BlockInfo *bi_lookup(void *start) {
    struct BlockInfo *bie = bis;

    while (bie < bis_end && start >= bie->end)
        bie++;
    return bie;
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// Insert a mapping into BlockInfo
// <start> is the start virtual address
// <end> is the end virtual address
// <addr> is the start physical address
// <perm> is the permission
int bi_insert(void *start, void *end, void *addr, uint8_t perm) {
    struct BlockInfo *bie = NULL;
    // check if the BlockInfo is full
    if (bis_end == bis + BLOCK_NUMBER * sizeof(struct BlockInfo))
        return -E_NO_MEM;
    // first remove the mapping within the range
    bi_delete(start, end, perm);
    // find the insert point
    bie = bi_lookup(start);
    if (bie != bis_end)
        memmove((bie + 1), bie, (bis_end - bie) * sizeof(struct BlockInfo));
    bis_end ++;

    bie->start = start;
    bie->end = end;
    bie->addr = addr;
    bie->perm = perm;
    //cprintf("bi_insert @ %x: start %x end %x addr %x perm %d\n", bie, start, end, addr, perm);
    return 0;
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// Delete a mapping into BlockInfo
// <start> is the start virtual address
// <end> is the end virtual address
// <perm> is the permission
int bi_delete(void *start, void *end, uint8_t perm) {
    //cprintf("bi_delete @ %x: start %x end %x perm %d\n", 0, start, end, perm);
    struct BlockInfo *bie = NULL;

    bie = bi_lookup(start);

    while (bie != bis_end && bie->start < end) {
        if (bie->end <= end) {
            // bie within the range, remove the whole entry
            memmove(bie, (bie + 1), (bis_end - 1 - bie) * sizeof(struct BlockInfo));
            bis_end--;
            bis_end->start = 0;
            bis_end->end = 0;
            bis_end->addr = 0;
            bis_end->perm = 0;
        }
        else {
            // bie is partial within the range, modify the addr and start field
            bie->addr += end - bie->start;
            bie->start = end;
            break;
        }
    }

    return 0;
}

// --------------------------------------------------------------
// For challenge 4 of lab 2
// --------------------------------------------------------------
// Find a free and contigous virtual space of <n> bytes in BlockInfo
void *bi_block(size_t n) {
    void *va = (b_ring == 0) ? (void *)BLOCK_K_START : (void *)BLOCK_U_START;
    struct BlockInfo *bie = bi_lookup(va);

    if (bie == bis_end || bie->start >= va + n)
        return va;

    do {
        va += BLOCK_ALIGN(n / PGSIZE);
        bie = bi_lookup(va);
    } while (bie != bis_end && bie->start < va + n);

    //cprintf("bi_block: va: %x bie: %x bis_end: %x\n", va, bie, bis_end);
    //cprintf("          start: %x end: %x addr: %x perm: %d\n", bie->start, bie->end, bie->addr, bie->perm);
    return va;
}

void check_b_utils() {
    void *cp1, *cp2, *cp3, *cp4, *cp5;
    struct BlockInfo *bie1, *bie2, *bie3;
    void *ptr[8];

    b_ring = 0;

    cp1 = cp2 = cp3 = cp4 = cp5 = 0;
    bie1 = bie2 = bie3 = 0;
    ptr[0] = ptr[1] = ptr[2] = ptr[3] = ptr[4] = ptr[5] = ptr[6] = ptr[7] = 0;

    // should be 0 block in current memory
    assert(mm_binfo(0) == 0);

    // malloc cp1 as 32KB (8 pages, 4KB per page)
    // malloc cp2 as  8MB (4 pages, 2MB per page)
    assert(cp1 = b_malloc(PGSIZE * 8));
    assert(cp2 = b_malloc(PDE_PS_PGSIZE * 4));

    // should be 2 blocks in current memory
    assert(mm_binfo(0) == 2);

    // check the page numbers, should be 8 and 4
    assert(mm_showmaps((uint64_t)cp1, (uint64_t)cp1 + PGSIZE * 8, 0) == 8);
    assert(mm_showmaps((uint64_t)cp2, (uint64_t)cp2 + PDE_PS_PGSIZE * 4, 0) == 4);

    bie1 = bi_lookup(cp1);
    bie2 = bi_lookup(cp2);
    // should have correct entries in BlockInfo
    assert(bie1 != bis_end && bie1->start == cp1 && bie1->end == bie1->start + PGSIZE * 8);
    assert(bie2 != bis_end && bie2->start == cp2 && bie2->end == bie2->start + PDE_PS_PGSIZE * 4);

    // split 32KB into 8 pieces, the block number should be 9 (8+1), the page number of block 1 should be 8 (no change)
    b_split(cp1, 8, ptr);
    assert(mm_binfo(0) == 9);
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
    bie1 = bi_lookup(ptr[0]);
    assert(bie1 != bis_end && bie1->start == ptr[0] && bie1->end == bie1->start + PGSIZE);
    bie2 = bi_lookup(ptr[1]);
    assert(bie2 != bis_end && bie2->start == ptr[1] && bie2->start == bie1->end && bie2->end == bie2->start + PGSIZE);
    bie3 = bi_lookup(ptr[2]);
    assert(bie3 != bis_end && bie3->start == ptr[2] && bie3->start == bie2->end && bie3->end == bie3->start + PGSIZE);
    bie1 = bi_lookup(ptr[3]);
    assert(bie1 != bis_end && bie1->start == ptr[3] && bie1->start == bie3->end && bie1->end == bie1->start + PGSIZE);
    bie2 = bi_lookup(ptr[4]);
    assert(bie2 != bis_end && bie2->start == ptr[4] && bie2->start == bie1->end && bie2->end == bie2->start + PGSIZE);
    bie3 = bi_lookup(ptr[5]);
    assert(bie3 != bis_end && bie3->start == ptr[5] && bie3->start == bie2->end && bie3->end == bie3->start + PGSIZE);
    bie1 = bi_lookup(ptr[6]);
    assert(bie1 != bis_end && bie1->start == ptr[6] && bie1->start == bie3->end && bie1->end == bie1->start + PGSIZE);
    bie2 = bi_lookup(ptr[7]);
    assert(bie2 != bis_end && bie2->start == ptr[7] && bie2->start == bie1->end && bie2->end == bie2->start + PGSIZE);

    // coalesce the block as 3 pages, 2 pages and 3 pages
    assert(cp3 = b_coalesce(3, &ptr[0]));
    assert(cp4 = b_coalesce(2, &ptr[3]));
    assert(cp5 = b_coalesce(3, &ptr[5]));
    // the block number should be 4 (3 + 1)
    assert(mm_binfo(0) == 4);
    // the page number in 3 blocks should be 3, 2, 3
    assert(mm_showmaps((uint64_t)cp3, (uint64_t)cp3 + PGSIZE * 3, 0) == 3);
    assert(mm_showmaps((uint64_t)cp4, (uint64_t)cp4 + PGSIZE * 2, 0) == 2);
    assert(mm_showmaps((uint64_t)cp5, (uint64_t)cp5 + PGSIZE * 3, 0) == 3);
    // check the validity and continuousness
    bie1 = bi_lookup(cp3);
    assert(bie1 != bis_end && bie1->start == cp3 && bie1->end == bie1->start + PGSIZE * 3);
    bie2 = bi_lookup(cp4);
    assert(bie2 != bis_end && bie2->start == cp4 && bie2->start == bie1->end && bie2->end == bie2->start + PGSIZE * 2);
    bie3 = bi_lookup(cp5);
    assert(bie3 != bis_end && bie3->start == cp5 && bie3->start == bie2->end && bie3->end == bie3->start + PGSIZE * 3);
    // coalesce the 3 blocks to 1, the block number should be 2, the page number should be 8
    ptr[0] = cp3; ptr[1] = cp4; ptr[2] = cp5;
    assert(cp3 = b_coalesce(3, &ptr[0]));
    assert(mm_binfo(0) == 2);
    assert(mm_showmaps((uint64_t)cp3, (uint64_t)cp3 + PGSIZE * 8, 0) == 8);
    // check the validity and continuousness
    bie1 = bi_lookup(cp3);
    assert(bie1 != bis_end && bie1->start == cp3 && bie1->end == bie1->start + PGSIZE * 8);

    // now split 8MB into 8 pieces
    // since the unit size will be 1MB, the 2MB pages will be disassembled into 4KB pages
    // the block number should be 9 (1+8)
    // the page number should be 512 * 4 = 2048
    b_split(cp2, 8, ptr);
    assert(mm_binfo(0) == 9);
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
    bie1 = bi_lookup(ptr[0]);
    assert(bie1 != bis_end && bie1->start == ptr[0] && bie1->end == bie1->start + PDE_PS_PGSIZE / 2);
    bie2 = bi_lookup(ptr[1]);
    assert(bie2 != bis_end && bie2->start == ptr[1] && bie2->start == bie1->end && bie2->end == bie2->start + PDE_PS_PGSIZE / 2);
    bie3 = bi_lookup(ptr[2]);
    assert(bie3 != bis_end && bie3->start == ptr[2] && bie3->start == bie2->end && bie3->end == bie3->start + PDE_PS_PGSIZE / 2);
    bie1 = bi_lookup(ptr[3]);
    assert(bie1 != bis_end && bie1->start == ptr[3] && bie1->start == bie3->end && bie1->end == bie1->start + PDE_PS_PGSIZE / 2);
    bie2 = bi_lookup(ptr[4]);
    assert(bie2 != bis_end && bie2->start == ptr[4] && bie2->start == bie1->end && bie2->end == bie2->start + PDE_PS_PGSIZE / 2);
    bie3 = bi_lookup(ptr[5]);
    assert(bie3 != bis_end && bie3->start == ptr[5] && bie3->start == bie2->end && bie3->end == bie3->start + PDE_PS_PGSIZE / 2);
    bie1 = bi_lookup(ptr[6]);
    assert(bie1 != bis_end && bie1->start == ptr[6] && bie1->start == bie3->end && bie1->end == bie1->start + PDE_PS_PGSIZE / 2);
    bie2 = bi_lookup(ptr[7]);
    assert(bie2 != bis_end && bie2->start == ptr[7] && bie2->start == bie1->end && bie2->end == bie2->start + PDE_PS_PGSIZE / 2);

    // coalesce the block as 1/8, 5/8, 2/8
    assert(cp3 = ptr[0]);
    assert(cp4 = b_coalesce(5, &ptr[1]));
    assert(cp5 = b_coalesce(2, &ptr[6]));
    // the block number should be 4
    assert(mm_binfo(0) == 4);
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
    bie1 = bi_lookup(cp3);
    assert(bie1 != bis_end && bie1->start == cp3 && bie1->end == bie1->start + PDE_PS_PGSIZE / 2);
    bie2 = bi_lookup(cp4);
    assert(bie2 != bis_end && bie2->start == cp4 && bie2->start == bie1->end && bie2->end == bie2->start + PDE_PS_PGSIZE / 2 * 5);
    bie3 = bi_lookup(cp5);
    assert(bie3 != bis_end && bie3->start == cp5 && bie3->start == bie2->end && bie3->end == bie3->start + PDE_PS_PGSIZE / 2 * 2);
    // coalesce the 3 blocks to 1, the block number should be 2, the page number should become 4
    ptr[0] = cp3; ptr[1] = cp4; ptr[2] = cp5;
    assert(cp3 = b_coalesce(3, &ptr[0]));
    assert(mm_binfo(0) == 2);
    assert(mm_showmaps((uint64_t)cp3, (uint64_t)cp3 + PDE_PS_PGSIZE * 4, 0) == 4);
    // check the validity and continuousness
    bie1 = bi_lookup(cp3);
    assert(bie1 != bis_end && bie1->start == cp3 && bie1->end == bie1->start + PDE_PS_PGSIZE * 4);
    // free the blocks*/
    b_free(cp1);
    b_free(cp2);

    // after free the blocks, the block number should be 0, and page number in blocks should be 0
    assert(mm_binfo(0) == 0);
    assert(mm_showmaps((uint64_t)cp1, (uint64_t)cp1 + PGSIZE * 8, 0) == 0);
    assert(mm_showmaps((uint64_t)cp2, (uint64_t)cp2 + PDE_PS_PGSIZE * 4, 0) == 0);

    cprintf("check_b_utils() succeeded!\n");

    b_ring = 3;

    return;

}
