/*
* @Author: Yinlong Su
* @Date:   2016-05-04 17:03:01
* @Last Modified by:   Yinlong Su
* @Last Modified time: 2016-05-04 18:05:10
*/

// exec
// I delete some comments (same with spawn.c)

#include <inc/lib.h>
#include <inc/elf.h>

#define EXECTEMP   0xe0000000 // our exec temp region
#define UTEMP2USTACK(addr)  ((void*) (addr) + (USTACKTOP - PGSIZE) - UTEMP)
#define UTEMP2          (UTEMP + PGSIZE)
#define UTEMP3          (UTEMP2 + PGSIZE)

// Helper functions for exec.
// Modify the init_stack, add one argument
static int init_stack(envid_t child, const char **argv, uintptr_t *init_esp, uint64_t stack);
static int map_segment(envid_t child, uintptr_t va, size_t memsz,
               int fd, size_t filesz, off_t fileoffset, int perm);

int exec(const char *prog, const char **argv) {
    unsigned char elf_buf[512];
    uintptr_t tf_rsp = 0;

    int fd, i, r;
    struct Elf *elf;
    struct Proghdr *ph;
    int perm;

    if ((r = open(prog, O_RDONLY)) < 0)
        return r;
    fd = r;

    // Read elf header
    elf = (struct Elf*) elf_buf;
    if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
        || elf->e_magic != ELF_MAGIC) {
        close(fd);
        cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
        return -E_NOT_EXEC;
    }

    // Set up program segments as defined in ELF header.
    uint64_t tmp = EXECTEMP;
    ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
    for (i = 0; i < elf->e_phnum; i++, ph++) {
        if (ph->p_type != ELF_PROG_LOAD)
            continue;
        perm = PTE_P | PTE_U;
        if (ph->p_flags & ELF_PROG_FLAG_WRITE)
            perm |= PTE_W;
        if ((r = map_segment(0, PGOFF(ph->p_va) + tmp, ph->p_memsz,
                     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
            goto error;
        tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
    }
    close(fd);
    fd = -1;

    if ((r = init_stack(0, argv, &tf_rsp, tmp)) < 0)
        return r;
    // Syscall to exec
    if (sys_exec(elf->e_entry, tf_rsp, (void *)(elf_buf + elf->e_phoff), elf->e_phnum) < 0)
        goto error;
    return 0;

error:
    sys_env_destroy(0);
    close(fd);
    return r;
}

int execl(const char *prog, const char *arg0, ...) {
    int argc = 0;
    va_list vl;
    va_start(vl, arg0);
    while(va_arg(vl, void *) != NULL)
        argc++;
    va_end(vl);

    const char *argv[argc+2];
    argv[0] = arg0;
    argv[argc+1] = NULL;

    va_start(vl, arg0);
    unsigned i;
    for(i=0;i<argc;i++)
        argv[i+1] = va_arg(vl, const char *);
    va_end(vl);
    return exec(prog, argv);
}

static int init_stack(envid_t child, const char **argv, uintptr_t *init_esp, uint64_t stack) {
    size_t string_size;
    int argc, i, r;
    char *string_store;
    uintptr_t *argv_store;

    string_size = 0;
    for (argc = 0; argv[argc] != 0; argc++)
        string_size += strlen(argv[argc]) + 1;

    string_store = (char*) UTEMP + PGSIZE - string_size;
    argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));

    if ((void*) (argv_store - 2) < (void*) UTEMP)
        return -E_NO_MEM;

    if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
        return r;

    for (i = 0; i < argc; i++) {
        argv_store[i] = UTEMP2USTACK(string_store);
        strcpy(string_store, argv[i]);
        string_store += strlen(argv[i]) + 1;
    }
    argv_store[argc] = 0;
    assert(string_store == (char*)UTEMP + PGSIZE);

    argv_store[-1] = UTEMP2USTACK(argv_store);
    argv_store[-2] = argc;

    *init_esp = UTEMP2USTACK(&argv_store[-2]);

    // After completing the stack, map it into the child's address space
    // and unmap it from ours!
    // use the argument stack
    if ((r = sys_page_map(0, UTEMP, child, (void*) stack, PTE_P | PTE_U | PTE_W)) < 0)
        goto error;
    if ((r = sys_page_unmap(0, UTEMP)) < 0)
        goto error;

    return 0;

error:
    sys_page_unmap(0, UTEMP);
    return r;
}

static int map_segment(envid_t child, uintptr_t va, size_t memsz,
    int fd, size_t filesz, off_t fileoffset, int perm) {
    int i, r;
    void *blk;

    if ((i = PGOFF(va))) {
        va -= i;
        memsz += i;
        filesz += i;
        fileoffset -= i;
    }

    for (i = 0; i < memsz; i += PGSIZE) {
        if (i >= filesz) {
            // allocate a blank page
            if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
                return r;
        } else {
            // from file
            if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
                return r;
            if ((r = seek(fd, fileoffset + i)) < 0)
                return r;
            if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
                return r;
            if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
                panic("exec: sys_page_map data: %e", r);
            sys_page_unmap(0, UTEMP);
        }
    }
    return 0;
}
