#ifndef JOS_INC_SPINLOCK_H
#define JOS_INC_SPINLOCK_H

#include <inc/types.h>

// Comment this to disable spinlock debugging
#define DEBUG_SPINLOCK

#define GLOCK_LOCKNUM	4

#define GLOCK_PGA_N	0
#define GLOCK_CON_N	1
#define GLOCK_SCH_N	2
#define GLOCK_IPC_N	3

#define GLOCK_PGA	0x01
#define GLOCK_CON	0x02
#define GLOCK_SCH	0x04
#define GLOCK_IPC	0x08

// Mutual exclusion lock.
struct spinlock {
	unsigned locked;       // Is the lock held?

#ifdef DEBUG_SPINLOCK
	// For debugging:
	char *name;            // Name of lock.
	struct CpuInfo *cpu;   // The CPU holding the lock.
	uintptr_t pcs[10];     // The call stack (an array of program counters)
	                       // that locked the lock.
#endif
};

void __spin_initlock(struct spinlock *lk, char *name);
void spin_lock(struct spinlock *lk);
void spin_unlock(struct spinlock *lk);

#define spin_initlock(lock)   __spin_initlock(lock, #lock)

extern struct spinlock kernel_lock;
extern struct spinlock g_locks[];

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
}

static inline void lock_g(int mask) {
	if (mask & GLOCK_PGA)
		spin_lock(&g_locks[GLOCK_PGA_N]);
	if (mask & GLOCK_CON)
		spin_lock(&g_locks[GLOCK_CON_N]);
	if (mask & GLOCK_SCH)
		spin_lock(&g_locks[GLOCK_SCH_N]);
	if (mask & GLOCK_IPC)
		spin_lock(&g_locks[GLOCK_IPC_N]);
}
static inline void unlock_g(int mask) {
	if (mask & GLOCK_PGA)
		spin_unlock(&g_locks[GLOCK_PGA_N]);
	if (mask & GLOCK_CON)
		spin_unlock(&g_locks[GLOCK_CON_N]);
	if (mask & GLOCK_SCH)
		spin_unlock(&g_locks[GLOCK_SCH_N]);
	if (mask & GLOCK_IPC)
		spin_unlock(&g_locks[GLOCK_IPC_N]);
	asm volatile("pause");
}

#endif
