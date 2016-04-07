// for large page size support
#define PDE_PS_FLAG 0x02

#define PDE_PS_PGNUM (1 << 9)
#define PDE_PS_PGSIZE (PGSIZE << 9)

#define PDPE_PS_PGNUM (1 << 18)
#define PDPE_PS_PGSIZE (PGSIZE << 18)

#define PDE_ADDR(pde)   ((physaddr_t) (pde) & ~0x1FFFFF)

// for continuous block support
#define BLOCK_PGNUM(p) ((p >= PDE_PS_PGNUM) ? PDE_PS_PGNUM : 1)
#define BLOCK_ALIGN(p) ((p >= PDE_PS_PGNUM) ? PDE_PS_PGSIZE : PGSIZE)

typedef void* (*funcPtr)(uint32_t);

#define BLOCK_NUMBER 65535

#define BIE_U 0x004

#define BLOCK_U_START 0x9000000000

struct BlockInfo {
    void *start;
    void *end;
    void *addr;
    uint8_t perm;
};

struct PageInfo *page_contiguous_block(size_t p);
struct PageInfo *page_contiguous_alloc(struct PageInfo *pp, size_t p);
void page_incref(struct PageInfo* pp, size_t p);
void page_free_list_reorder();
void page_update(size_t p, void *va, void *pa, int flag);

void *b_malloc(size_t n);
void b_free(void *va);
int b_split(void *va, int split, void **ptr);
void *b_coalesce(int coalesce, void **ptr);

void bi_init();
struct BlockInfo *bi_lookup(void *start);
int bi_insert(void *start, void *end, void *addr, uint8_t perm);
int bi_delete(void *start, void *end, uint8_t perm);
void *bi_block(size_t n);

void check_b_utils();

extern funcPtr ptr_boot_alloc;

