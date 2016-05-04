// System call stubs.

#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
	int64_t ret;

	// Generic system call: pass system call number in AX,
	// up to five parameters in DX, CX, BX, DI, SI.
	// Interrupt kernel with T_SYSCALL.
	//
	// The "volatile" tells the assembler not to optimize
	// this instruction away just because we don't use the
	// return value.
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
		: "=a" (ret)
		: "i" (T_SYSCALL),
		  "a" (num),
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
		panic("syscall %d returned %d (> 0)", num, ret);

	return ret;
}
/*
static inline int64_t
fast_syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5) {
	// int64_t ret;
	uint64_t es, ds, rip, cs;
	cprintf("in syscall\n");

	// asm volatile("movw %%es, %0\n"
	// 	"movw %%ds, %1\n"
	// 	"movw %%cs, %2\n"
	// 	: "=m"(es),
	// 	  "=m"(ds),
	// 	  "=m"(cs));
	// cprintf("before es, ds, cs %x %x %x\n", es, ds, cs);
	syscall(SYS_env_print_trapframe, 1, 0,0,0,0,0);
	asm volatile("syscall\n");
		// : "=a" (ret)
		// : "a" (num),
		//   "d" (a1),
		//   "b" (a2),
		//   "D" (a3)
		// : "cc", "memory");
	cprintf("syscall returns\n");
	cprintf("hello\n");cprintf("hello\n");cprintf("hello\n");cprintf("hello\n");cprintf("hello\n");cprintf("hello\n");cprintf("hello\n");cprintf("hello\n");cprintf("hello\n");cprintf("hello\n");
	// if (check && ret > 0)
	// 	panic("sysenter %d returned %d (> 0)", num, ret);

	return 0;
}
*/
void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
}

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
}

int
sys_ipc_try_send_2(envid_t envid, uint64_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send_2, 0, envid, value, (uint64_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 0, (uint64_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int
sys_e1000_transmit(void *addr, size_t len)
{
	return syscall(SYS_e1000_transmit, (uint64_t)addr, len, 0, 0, 0, 0);
}

int
sys_e1000_receive(void *addr, int *len)
{
	return syscall(SYS_e1000_receive, (uint64_t)addr, (uint64_t)len, 0, 0, 0, 0);
}

int
sys_env_save(envid_t envid, struct EnvSnapshot *ess)
{
	return syscall(SYS_env_save, 1, envid, (uint64_t)ess, 0, 0, 0);
}

int
sys_env_load(envid_t envid, struct EnvSnapshot *ess)
{
	return syscall(SYS_env_load, 1, envid, (uint64_t)ess, 0, 0, 0);
}

void *
sys_b_malloc(size_t n)
{
	return (void *)syscall(SYS_b_malloc, 0, n, 0, 0, 0, 0);
}

void
sys_b_free(void *va)
{
	syscall(SYS_b_free, 0, (uint64_t)va, 0, 0, 0, 0);
	return;
}

int
sys_env_set_exception_upcall(envid_t env, int trapno, void *upcall)
{
	return syscall(SYS_env_set_exception_upcall, 1, env, trapno, (uint64_t)upcall, 0, 0);
}

uint64_t
sys_sipc_try_send(envid_t envid, uint64_t value)
{
	return syscall(SYS_sipc_try_send, 0, envid, value, 0, 0, 0);
}

uint64_t
sys_sipc_try_send_2(envid_t envid, uint64_t value)
{
	return syscall(SYS_sipc_try_send_2, 0, envid, value, 0, 0, 0);
}

uint64_t
sys_sipc_recv(envid_t envid)
{
	return syscall(SYS_sipc_recv, 0, envid, 0, 0, 0, 0);
}

int sys_exec(uint64_t rip, uint64_t rsp, void *ph, uint64_t phnum) {
	return syscall(SYS_exec, 1, rip, rsp, (uint64_t)ph, phnum, 0);
}