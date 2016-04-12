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

// rewrite by Yinlong Su @ Apr 7th
// add data to table
#define TRAPHANDLER(num, istrap, name, user)					\
.text;															\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */				\
	name:			/* function starts here */					\
	pushq $(num);												\
	jmp _alltraps;												\
.data;															\
	.quad num, istrap, name, user


/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */

// rewrite by Yinlong Su @ Apr 7th
// add data to table
#define TRAPHANDLER_NOEC(num, istrap, name, user)	\
.text;												\
	.globl name;									\
	.type name, @function;							\
	.align 2;										\
	name:											\
	pushq $0;										\
	pushq $(num);									\
	jmp _alltraps;									\
.data;												\
	.quad num, istrap, name, user


/*
 * Lab 3: Your code here for generating entry points for the different traps.
   Find the PUSHA,POPA macros in kern/macro.h. Since amd64 doesn't support
   pusha,popa so you will find these macros handy.
 */

// added by Yinlong Su @ Apr 7th
// symbol : entry_array (used by trap_init() in trap.c)
.data
	.globl entry_array
	entry_array:

	// Macros are referred from inc/trap.h
	// See Intel IA-32 Developer's Manual Table 5-1
	TRAPHANDLER_NOEC(T_DIVIDE, 0, __trap_divide, 0)
	TRAPHANDLER_NOEC(T_DEBUG, 0, __trap_debug, 0)
	TRAPHANDLER_NOEC(T_NMI, 0, __trap_nmi, 0)
	TRAPHANDLER_NOEC(T_BRKPT, 0, __trap_brkpt, 3)
	TRAPHANDLER_NOEC(T_OFLOW, 0, __trap_oflow, 0)
	TRAPHANDLER_NOEC(T_BOUND, 0, __trap_bound, 0)
	TRAPHANDLER_NOEC(T_ILLOP, 0, __trap_illop, 0)
	TRAPHANDLER_NOEC(T_DEVICE, 0, __trap_device, 0)
	TRAPHANDLER(T_DBLFLT, 0,__trap_dblflt, 0)
	//TRAPHANDLER_NOEC(__trap_coproc, T_COPROC)
	TRAPHANDLER(T_TSS, 0, __trap_tss, 0)
	TRAPHANDLER(T_SEGNP, 0, __trap_segnp, 0)
	TRAPHANDLER(T_STACK, 0, __trap_stack, 0)
	TRAPHANDLER(T_GPFLT, 0, __trap_gpflt, 0)
	TRAPHANDLER(T_PGFLT, 0, __trap_pgflt, 0)
	//TRAPHANDLER_NOEC(T_RES, 0, __trap_res, 0)
	TRAPHANDLER_NOEC(T_FPERR, 0, __trap_fperr, 0)
	TRAPHANDLER(T_ALIGN, 0, __trap_align, 0)
	TRAPHANDLER_NOEC(T_MCHK, 0, __trap_mchk, 0)
	TRAPHANDLER_NOEC(T_SIMDERR, 0, __trap_simderr, 0)
	TRAPHANDLER_NOEC(T_SYSCALL, 0, __trap_syscall, 3)

	// note: modified for LAB4
	TRAPHANDLER_NOEC(IRQ_OFFSET + IRQ_TIMER, 0, __irq_timer, 0)
	TRAPHANDLER_NOEC(IRQ_OFFSET + IRQ_KBD, 0, __irq_kbd, 0)
	TRAPHANDLER_NOEC(IRQ_OFFSET + IRQ_SERIAL, 0, __irq_serial, 0)
	TRAPHANDLER_NOEC(IRQ_OFFSET + IRQ_SPURIOUS, 0, __irq_spurious, 0)
	TRAPHANDLER_NOEC(IRQ_OFFSET + IRQ_IDE, 0, __irq_ide, 0)
	TRAPHANDLER_NOEC(IRQ_OFFSET + IRQ_ERROR, 0, __irq_error, 0)

// added by Yinlong Su @ Apr 7th
// end flag of entry_array
.data
	.quad 0, 0, 0, 0

/*
 * Lab 3: Your code here for _alltraps
 *
 * Hint: Be sure to review the x64 calling convention from lab1
 *       for how to pass a pointer to the trapframe.
 */
.text
.globl _alltraps
_alltraps:
	subq $16, %rsp
	movw %ds, 8(%rsp)
	movw %es, 0(%rsp)

	PUSHA

	subq $512, %rsp
	fxsave (%rsp)

	movq $GD_KD, %rax
	movq %rax, %ds
	movq %rax, %es
	movq %rsp, %rdi

	call trap

	fxrstor (%rsp)
	addq $512, %rsp

	POPA_

	movw 0(%rsp), %es
	movw 8(%rsp), %ds
	addq $16, %rsp
	iret
