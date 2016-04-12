#include <inc/assert.h>
#include <inc/x86.h>
#include <kern/spinlock.h>
#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/monitor.h>

#define SCH_QUEUE_ACT   0
#define SCH_QUEUE_EXP   1
#define NSCH			40

void sched_halt(void);

// ****************************************************
// Chellange 2 of Lab 4
// O(1) Scheduler: Two arrays of runqueues: active, expired
//
extern void *schedqueue;
uint64_t *sched_act_queue = NULL, *sched_exp_queue = NULL;

// Initial the runqueues
void sched_init(void) {
	if (!schedqueue)
		panic("sched_init failed. Schedule queue is empty.");
	sched_act_queue = (uint64_t *)schedqueue;
	sched_exp_queue = (sched_act_queue + NSCH);
	int i;
	for (i = 0; i < NSCH; i++) {
		*(sched_act_queue + i) = 0;
		*(sched_exp_queue + i) = 0;
	}
}

// enqueue an environment into the exipred queue
void sched_enqueue(int priority, struct Env *env) {
	struct Env *e = (struct Env *)(*(sched_exp_queue + priority));
	if (!e) {
		*(sched_exp_queue + priority) = (uint64_t) env;
		return;
	}
	while (e->pri_link)
		e = e->pri_link;
	e->pri_link = env;
}

// dequeue an environment from the active queue
struct Env *sched_dequeue(int priority) {
	struct Env *env = (struct Env *)(*(sched_act_queue + priority));
	if (!env)
		return NULL;
	*(sched_act_queue + priority) = (uint64_t) env->pri_link;
	env->pri_link = NULL;
	return env;
}

// swap two queues
void sched_swapqueue() {
	uint64_t *t = sched_act_queue;
	sched_act_queue = sched_exp_queue;
	sched_exp_queue = t;
}

// when an environment is freed, remove it from runqueue
void sched_free(struct Env *env) {
	struct Env *e;

	if (!env)
		return;

	e = (struct Env *)(*(sched_exp_queue + env->priority));
	if (e) {
		if (e == env)
			*(sched_exp_queue + env->priority) = (uint64_t) env->pri_link;
		else {
			while (e && e->pri_link != env)
				e = e->pri_link;
			if (e)
				e->pri_link = env->pri_link;
		}
	}

	e = (struct Env *)(*(sched_act_queue + env->priority));
	if (e) {
		if (e == env)
			*(sched_act_queue + env->priority) = (uint64_t) env->pri_link;
		else {
			while (e && e->pri_link != env)
				e = e->pri_link;
			if (e)
				e->pri_link = env->pri_link;
		}
	}

	env->pri_link = NULL;
}

// Choose a user environment to run and run it.
void
sched_yield(void)
{
	// Implement simple round-robin scheduling.
	//
	// Search through 'envs' for an ENV_RUNNABLE environment in
	// circular fashion starting just after the env this CPU was
	// last running.  Switch to the first such environment found.
	//
	// If no envs are runnable, but the environment previously
	// running on this CPU is still ENV_RUNNING, it's okay to
	// choose that environment.
	//
	// Never choose an environment that's currently running on
	// another CPU (env_status == ENV_RUNNING). If there are
	// no runnable environments, simply drop through to the code
	// below to halt the cpu.

	// LAB 4: Your code here.
	/*
	struct Env *idle;
	int i, count;

	idle = thiscpu->cpu_env;
	if (idle != NULL)
		i = ENVX(idle->env_id);
	for (count = 0; count < NENV; count++) {
		i = (i + 1) % NENV;
		if (envs[i].env_status == ENV_RUNNABLE) {
			env_run(&envs[i]);
			return;
		}
	}

	if (idle && idle->env_status == ENV_RUNNING)
		env_run(idle);
	*/

	// ****************************************************
	// Chellange 2 of Lab 4
	// O(1) scheduler

	struct Env *target;
	int i, swap = 0;

	while (swap == 0) {
		for (i = 0; i < NSCH; i++) {
			// try to find a runnable environment
			target = sched_dequeue(i);
			if (target && target->env_status == ENV_RUNNABLE) {
				// move the environment into the expired runqueue then run it
				sched_enqueue(i, target);
				env_run(target);
				return;
			}
		}
		 // if no runnable environment in the active runqueue
		 // swap the active and expired runqueues and scan again
		sched_swapqueue();
		swap = 1;
	}

	target = thiscpu->cpu_env;
	if (target && target->env_status == ENV_RUNNING)
		env_run(target);


	// sched_halt never returns
	sched_halt();
}

// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
		while (1)
			monitor(NULL);
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
	lcr3(PADDR(boot_pml4e));

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);

	// Release the big kernel lock as if we were "leaving" the kernel
	//unlock_kernel();
	//cprintf("unlock in sched_halt()\n");
	unlock_g(GLOCK_PGA | GLOCK_SCH);

	// Reset stack pointer, enable interrupts and then halt.
	asm volatile (
		"movq $0, %%rbp\n"
		"movq %0, %%rsp\n"
		"pushq $0\n"
		"pushq $0\n"
		"sti\n"
		"hlt\n"
		: : "a" (thiscpu->cpu_ts.ts_esp0));
}

