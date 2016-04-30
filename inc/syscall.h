#ifndef JOS_INC_SYSCALL_H
#define JOS_INC_SYSCALL_H

/* system call numbers */
enum {
	SYS_cputs = 0,
	SYS_cgetc,
	SYS_getenvid,
	SYS_env_destroy,
	SYS_page_alloc,
	SYS_page_map,
	SYS_page_unmap,
	SYS_exofork,
	SYS_env_set_status,
	SYS_env_set_trapframe,
	SYS_env_set_pgfault_upcall,
	SYS_yield,
	SYS_ipc_try_send,
	SYS_ipc_recv,
	SYS_time_msec,
	SYS_e1000_transmit,
	SYS_e1000_receive,
	SYS_env_save,
	SYS_env_load,
	SYS_b_malloc,
	SYS_b_free,
	SYS_env_set_exception_upcall,
	SYS_sipc_try_send,
	SYS_sipc_recv,
	SYS_ipc_try_send_2,
	NSYSCALLS
};

#endif /* !JOS_INC_SYSCALL_H */
