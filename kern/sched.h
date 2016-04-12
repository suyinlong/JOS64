/* See COPYRIGHT for copyright information. */

#ifndef JOS_KERN_SCHED_H
#define JOS_KERN_SCHED_H
#ifndef JOS_KERNEL
# error "This is a JOS kernel header; user programs should not #include it"
#endif

#define PRI_DEF         20
#define NSCH            40

void sched_init(void);
void sched_enqueue(int priority, struct Env *env);
void sched_free(struct Env *env);

// This function does not return.
void sched_yield(void) __attribute__((noreturn));

#endif	// !JOS_KERN_SCHED_H
