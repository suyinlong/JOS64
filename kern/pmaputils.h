#define ALLOC_FREE 0
#define ALLOC_ALIGN 1

#define PDE_PS_FLAG 0x02
#define PDE_PS_PGNUM (1 << 9)
#define PDE_PS_PGSIZE (PGSIZE << 9)
#define PDPE_PS_PGNUM (1 << 18)
#define PDPE_PS_PGSIZE (PGSIZE << 18)
#define PDE_ADDR(pde)   ((physaddr_t) (pde) & ~0x1FFFFF)

#define BLOCK_ALIGN(p) ((p >= PDPE_PS_PGNUM) ? PDPE_PS_PGSIZE : ((p >= PDE_PS_PGNUM) ? PDE_PS_PGSIZE : PGSIZE))

typedef void* (*funcPtr)(uint32_t);

#define VM_NUMBER 65535

#define VME_U 0x01

#define VM_U_START 0x1000000000

struct VirtualMap {
    void *start;
    void *end;
    void *addr;
    uint8_t perm;
};

struct PageInfo *page_contiguous_block(size_t p);
struct PageInfo *page_contiguous_alloc(size_t p);
void page_incref(struct PageInfo* pp, size_t p);
void page_free_list_reorder();
void page_update(size_t p, void *va, void *pa, int flag);

void *c_malloc(size_t n);
void c_free(void *va);
int c_split(void *va, int split, void **ptr);
void *c_coalesce(int coalesce, void **ptr);

void vm_init();
struct VirtualMap *vm_lookup(void *start);
int vm_insert(void *start, void *end, void *addr, uint8_t perm);
int vm_delete(void *start, uint8_t perm);
void *vm_block(size_t n);

void check_c_utils();

extern funcPtr ptr_boot_alloc;

