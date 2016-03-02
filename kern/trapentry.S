/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>
#include <kern/macro.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushq $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushq $0;							\
	pushq $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
   Find the PUSHA,POPA macros in kern/macro.h. Since amd64 doesn't support
   pusha,popa so you will find these macros handy.
 */

	// Macros are referred from inc/trap.h
	// See Intel IA-32 Developer's Manual Table 5-1
	TRAPHANDLER_NOEC(__trap_divide, T_DIVIDE)
	TRAPHANDLER_NOEC(__trap_debug, T_DEBUG)
	TRAPHANDLER_NOEC(__trap_nmi, T_NMI)
	TRAPHANDLER_NOEC(__trap_brkpt, T_BRKPT)
	TRAPHANDLER_NOEC(__trap_oflow, T_OFLOW)
	TRAPHANDLER_NOEC(__trap_bound, T_BOUND)
	TRAPHANDLER_NOEC(__trap_illop, T_ILLOP)
	TRAPHANDLER_NOEC(__trap_device, T_DEVICE)
	TRAPHANDLER(__trap_dblflt, T_DBLFLT)
	//TRAPHANDLER_NOEC(__trap_coproc, T_COPROC)
	TRAPHANDLER(__trap_tss, T_TSS)
	TRAPHANDLER(__trap_segnp, T_SEGNP)
	TRAPHANDLER(__trap_stack, T_STACK)
	TRAPHANDLER(__trap_gpflt, T_GPFLT)
	TRAPHANDLER(__trap_pgflt, T_PGFLT)
	//TRAPHANDLER_NOEC(__trap_res, T_RES)
	TRAPHANDLER_NOEC(__trap_fperr, T_FPERR)
	TRAPHANDLER(__trap_align, T_ALIGN)
	TRAPHANDLER_NOEC(__trap_mchk, T_MCHK)
	TRAPHANDLER_NOEC(__trap_simderr, T_SIMDERR)
	TRAPHANDLER_NOEC(__trap_syscall, T_SYSCALL)

/*
 * Lab 3: Your code here for _alltraps
 *
 * Hint: Be sure to review the x64 calling convention from lab1
 *       for how to pass a pointer to the trapframe.
 */
.globl _alltraps
_alltraps:
	subq $16, %rsp
	movw %ds, 8(%rsp)
	movw %es, 0(%rsp)

	PUSHA

	movq $GD_KD, %rax
	movq %rax, %ds
	movq %rax, %es
	movq %rsp, %rdi

	call trap

	POPA_

	movw 0(%rsp), %es
	movw 8(%rsp), %ds
	addq $16, %rsp
	iret
