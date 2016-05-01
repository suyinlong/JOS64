// User-level IPC library routines

#include <inc/lib.h>

// Receive a value via IPC and return it.
// If 'pg' is nonnull, then any page sent by the sender will be mapped at
//	that address.
// If 'from_env_store' is nonnull, then store the IPC sender's envid in
//	*from_env_store.
// If 'perm_store' is nonnull, then store the IPC sender's page permission
//	in *perm_store (this is nonzero iff a page was successfully
//	transferred to 'pg').
// If the system call fails, then store 0 in *fromenv and *perm (if
//	they're nonnull) and return the error.
// Otherwise, return the value sent by the sender
//
// Hint:
//   Use 'thisenv' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
	// LAB 4: Your code here.
	// Modify to use queue so that no whiles are used in ipc_send/recv
	// Instead use sleep and wake up
	uint64_t r15;
	int r;
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

ipc_recv_dequeue:
	if ((r = sys_ipc_recv(page)) < 0) {
		if (from_env_store != NULL)
			*from_env_store = 0;
		if (perm_store != NULL)
			*perm_store = 0;
		return r;
	}

	if (thisenv->env_ipc_recving == 1)
		// haven't dequeue, so goes back to dequeue
		goto ipc_recv_dequeue;

	if (from_env_store != NULL)
		*from_env_store = thisenv->env_ipc_from;

	if (perm_store != NULL)
		*perm_store = thisenv->env_ipc_perm;

	return thisenv->env_ipc_value;
}

// Send 'val' (and 'pg' with 'perm', if 'pg' is nonnull) to 'toenv'.
// This function keeps trying until it succeeds.
// It should panic() on any error other than -E_IPC_NOT_RECV.
//
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	// Modify to use queue so that no whiles are used in ipc_send/recv
	// Instead use sleep and wake up
	int r;
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	// old code: while style
	// while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
	// 	sys_yield();

	// new code:
	// two-phase send procedure

	// first phase, enqueue and try to wake up the receiver if possible
	r = sys_ipc_try_send(to_env, val, page, perm);

	if (r != 0)
		return r;

	// second phase, write the data to the receiver
	r = sys_ipc_try_send_2(to_env, val, page, perm);
	return r;
}

// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
}
