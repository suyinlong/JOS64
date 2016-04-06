#include <inc/mmu.h>
#include <inc/x86.h>
#include <inc/assert.h>

#include <kern/pmap.h>
#include <kern/trap.h>
#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/env.h>
#include <kern/syscall.h>
#include <kern/sched.h>
#include <kern/kclock.h>
#include <kern/picirq.h>
#include <kern/cpu.h>
#include <kern/spinlock.h>

extern uintptr_t gdtdesc_64;
static struct Taskstate ts;
extern struct Segdesc gdt[];
extern long gdt_pd;

/* For debugging, so print_trapframe can distinguish between printing
 * a saved trapframe and printing the current trapframe and print some
 * additional information in the latter case.
 */
static struct Trapframe *last_tf;

/* Interrupt descriptor table.  (Must be built at run time because
 * shifted function addresses can't be represented in relocation records.)
 */
struct Gatedesc idt[256] = { { 0 } };
struct Pseudodesc idt_pd = {0,0};


static const char *trapname(int trapno)
{
	static const char * const excnames[] = {
		"Divide error",
		"Debug",
		"Non-Maskable Interrupt",
		"Breakpoint",
		"Overflow",
		"BOUND Range Exceeded",
		"Invalid Opcode",
		"Device Not Available",
		"Double Fault",
		"Coprocessor Segment Overrun",
		"Invalid TSS",
		"Segment Not Present",
		"Stack Fault",
		"General Protection",
		"Page Fault",
		"(unknown trap)",
		"x87 FPU Floating-Point Error",
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
		return "Hardware Interrupt";
	return "(unknown trap)";
}


void
trap_init(void)
{
	extern struct Segdesc gdt[];

	// LAB 3: Your code here.

	// declarations of trap handlers
	extern void __trap_divide();
	extern void __trap_debug();
	extern void __trap_nmi();
	extern void __trap_brkpt();
	extern void __trap_oflow();
	extern void __trap_bound();
	extern void __trap_illop();
	extern void __trap_device();
	extern void __trap_dblflt();
	//extern void __trap_coproc();
	extern void __trap_tss();
	extern void __trap_segnp();
	extern void __trap_stack();
	extern void __trap_gpflt();
	extern void __trap_pgflt();
	//extern void __trap_res();
	extern void __trap_fperr();
	extern void __trap_align();
	extern void __trap_mchk();
	extern void __trap_simderr();
	extern void __trap_syscall();

	// set gate descriptors - LAB4 version
	SETGATE(idt[T_DIVIDE], 0, GD_KT, __trap_divide, 0);
	SETGATE(idt[T_DEBUG], 0, GD_KT, __trap_debug, 0);
	SETGATE(idt[T_NMI], 0, GD_KT, __trap_nmi, 0);
	SETGATE(idt[T_BRKPT], 0, GD_KT, __trap_brkpt, 3);
	SETGATE(idt[T_OFLOW], 0, GD_KT, __trap_oflow, 0);
	SETGATE(idt[T_BOUND], 0, GD_KT, __trap_bound, 0);
	SETGATE(idt[T_ILLOP], 0, GD_KT, __trap_illop, 0);
	SETGATE(idt[T_DEVICE], 0, GD_KT, __trap_device, 0);
	SETGATE(idt[T_DBLFLT], 0, GD_KT, __trap_dblflt, 0);
	//SETGATE(idt[T_COPROC], 0, GD_KT, __trap_coproc, 0);
	SETGATE(idt[T_TSS], 0, GD_KT, __trap_tss, 0);
	SETGATE(idt[T_SEGNP], 0, GD_KT, __trap_segnp, 0);
	SETGATE(idt[T_STACK], 0, GD_KT, __trap_stack, 0);
	SETGATE(idt[T_GPFLT], 0, GD_KT, __trap_gpflt, 0);
	SETGATE(idt[T_PGFLT], 0, GD_KT, __trap_pgflt, 0);
	//SETGATE(idt[T_RES], 0, GD_KT, __trap_res, 0);
	SETGATE(idt[T_FPERR], 0, GD_KT, __trap_fperr, 0);
	SETGATE(idt[T_ALIGN], 0, GD_KT, __trap_align, 0);
	SETGATE(idt[T_MCHK], 0, GD_KT, __trap_mchk, 0);
	SETGATE(idt[T_SIMDERR], 0, GD_KT, __trap_simderr, 0);
	SETGATE(idt[T_SYSCALL], 0, GD_KT, __trap_syscall, 3);

	// note: code below is added for LAB4
	extern void __irq_timer();
	extern void __irq_kbd();
	extern void __irq_serial();
	extern void __irq_spurious();
	extern void __irq_ide();
	extern void __irq_error();

	SETGATE(idt[IRQ_OFFSET + IRQ_TIMER], 0, GD_KT, __irq_timer, 0);
	SETGATE(idt[IRQ_OFFSET + IRQ_KBD], 0, GD_KT, __irq_kbd, 0);
	SETGATE(idt[IRQ_OFFSET + IRQ_SERIAL], 0, GD_KT, __irq_serial, 0);
	SETGATE(idt[IRQ_OFFSET + IRQ_SPURIOUS], 0, GD_KT, __irq_spurious, 0);
	SETGATE(idt[IRQ_OFFSET + IRQ_IDE], 0, GD_KT, __irq_ide, 0);
	SETGATE(idt[IRQ_OFFSET + IRQ_ERROR], 0, GD_KT, __irq_error, 0);

	/*
	// note: not sure what happened here but must modify to LAB4 version
	// set gate descriptors: see IA-32 Manual Table 5-1
	SETGATE(idt[T_DIVIDE], 1, GD_KT, __trap_divide, 0);
	SETGATE(idt[T_DEBUG], 1, GD_KT, __trap_debug, 0);
	SETGATE(idt[T_NMI], 0, GD_KT, __trap_nmi, 0);
	SETGATE(idt[T_BRKPT], 1, GD_KT, __trap_brkpt, 3);
	SETGATE(idt[T_OFLOW], 1, GD_KT, __trap_oflow, 0);
	SETGATE(idt[T_BOUND], 1, GD_KT, __trap_bound, 0);
	SETGATE(idt[T_ILLOP], 1, GD_KT, __trap_illop, 0);
	SETGATE(idt[T_DEVICE], 1, GD_KT, __trap_device, 0);
	SETGATE(idt[T_DBLFLT], 1, GD_KT, __trap_dblflt, 0);
	//SETGATE(idt[T_COPROC], 1, GD_KT, __trap_coproc, 0);
	SETGATE(idt[T_TSS], 1, GD_KT, __trap_tss, 0);
	SETGATE(idt[T_SEGNP], 1, GD_KT, __trap_segnp, 0);
	SETGATE(idt[T_STACK], 1, GD_KT, __trap_stack, 0);
	SETGATE(idt[T_GPFLT], 1, GD_KT, __trap_gpflt, 0);
	SETGATE(idt[T_PGFLT], 1, GD_KT, __trap_pgflt, 0);
	//SETGATE(idt[T_RES], 1, GD_KT, __trap_res, 0);
	SETGATE(idt[T_FPERR], 1, GD_KT, __trap_fperr, 0);
	SETGATE(idt[T_ALIGN], 1, GD_KT, __trap_align, 0);
	SETGATE(idt[T_MCHK], 1, GD_KT, __trap_mchk, 0);
	SETGATE(idt[T_SIMDERR], 1, GD_KT, __trap_simderr, 0);
	SETGATE(idt[T_SYSCALL], 0, GD_KT, __trap_syscall, 3);
	*/

	idt_pd.pd_lim = sizeof(idt)-1;
	idt_pd.pd_base = (uint64_t)idt;
	// Per-CPU setup
	trap_init_percpu();
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
	// The example code here sets up the Task State Segment (TSS) and
	// the TSS descriptor for CPU 0. But it is incorrect if we are
	// running on other CPUs because each CPU has its own kernel stack.
	// Fix the code so that it works for all CPUs.
	//
	// Hints:
	//   - The macro "thiscpu" always refers to the current CPU's
	//     struct CpuInfo;
	//   - The ID of the current CPU is given by cpunum() or
	//     thiscpu->cpu_id;
	//   - Use "thiscpu->cpu_ts" as the TSS for the current CPU,
	//     rather than the global "ts" variable;
	//   - Use gdt[(GD_TSS0 >> 3) + 2*i] for CPU i's TSS descriptor;
	//   - You mapped the per-CPU kernel stacks in mem_init_mp()
	//
	// ltr sets a 'busy' flag in the TSS selector, so if you
	// accidentally load the same TSS on more than one CPU, you'll
	// get a triple fault.  If you set up an individual CPU's TSS
	// wrong, you may not get a fault until you try to return from
	// user space on that CPU.
	//
	// LAB 4: Your code here:

	// note: calculate gdt_index for further use
	int idx = (GD_TSS0 >> 3) + 2 * thiscpu->cpu_id;

	// note: modified from original given code
	thiscpu->cpu_ts.ts_esp0 = KSTACKTOP - thiscpu->cpu_id * (KSTKSIZE + KSTKGAP);
	SETTSS((struct SystemSegdesc64 *)(&gdt[idx]), STS_T64A, (uint64_t)(&thiscpu->cpu_ts),sizeof(struct Taskstate), 0);
	ltr(idx << 3);

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	//ts.ts_esp0 = KSTACKTOP;

	// Initialize the TSS slot of the gdt.
	//SETTSS((struct SystemSegdesc64 *)((gdt_pd>>16)+40),STS_T64A, (uint64_t) (&ts),sizeof(struct Taskstate), 0);
	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	//ltr(GD_TSS0);

	// Load the IDT
	lidt(&idt_pd);
}

void
print_trapframe(struct Trapframe *tf)
{
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
		cprintf("  cr2  0x%08x\n", rcr2());
	cprintf("  err  0x%08x", tf->tf_err);
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
	cprintf("  rip  0x%08x\n", tf->tf_rip);
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
	if ((tf->tf_cs & 3) != 0) {
		cprintf("  rsp  0x%08x\n", tf->tf_rsp);
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
	}
}

void
print_regs(struct PushRegs *regs)
{
	cprintf("  r15  0x%08x\n", regs->reg_r15);
	cprintf("  r14  0x%08x\n", regs->reg_r14);
	cprintf("  r13  0x%08x\n", regs->reg_r13);
	cprintf("  r12  0x%08x\n", regs->reg_r12);
	cprintf("  r11  0x%08x\n", regs->reg_r11);
	cprintf("  r10  0x%08x\n", regs->reg_r10);
	cprintf("  r9  0x%08x\n", regs->reg_r9);
	cprintf("  r8  0x%08x\n", regs->reg_r8);
	cprintf("  rdi  0x%08x\n", regs->reg_rdi);
	cprintf("  rsi  0x%08x\n", regs->reg_rsi);
	cprintf("  rbp  0x%08x\n", regs->reg_rbp);
	cprintf("  rbx  0x%08x\n", regs->reg_rbx);
	cprintf("  rdx  0x%08x\n", regs->reg_rdx);
	cprintf("  rcx  0x%08x\n", regs->reg_rcx);
	cprintf("  rax  0x%08x\n", regs->reg_rax);
}

static void
trap_dispatch(struct Trapframe *tf)
{
	// Handle processor exceptions.
	// LAB 3: Your code here.
	switch(tf->tf_trapno) {
		case T_PGFLT:
			page_fault_handler(tf);
			return;
		case T_BRKPT:
			monitor(tf);
			return;
		case T_SYSCALL:
			tf->tf_regs.reg_rax = syscall(tf->tf_regs.reg_rax, tf->tf_regs.reg_rdx, tf->tf_regs.reg_rcx,
					tf->tf_regs.reg_rbx, tf->tf_regs.reg_rdi, tf->tf_regs.reg_rsi);
			return;
		default:
			break;
	}

	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
		cprintf("Spurious interrupt on irq 7\n");
		print_trapframe(tf);
		return;
	}

	// Handle clock interrupts. Don't forget to acknowledge the
	// interrupt using lapic_eoi() before calling the scheduler!
	// LAB 4: Your code here.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
		lapic_eoi();
		sched_yield();
		return;
	}

	// Handle keyboard and serial interrupts.
	// LAB 5: Your code here.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_KBD) {
		kbd_intr();
		return;
	}

	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SERIAL) {
		serial_intr();
		return;
	}

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
	if (tf->tf_cs == GD_KT)
		panic("unhandled trap in kernel");
	else {
		env_destroy(curenv);
		return;
	}
}

void
trap(struct Trapframe *tf)
{
    //struct Trapframe *tf = &tf_;
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");

	// Halt the CPU if some other CPU has called panic()
	extern char *panicstr;
	if (panicstr)
		asm volatile("hlt");

	// Re-acqurie the big kernel lock if we were halted in
	// sched_yield()
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
		lock_kernel();
	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));

	if ((tf->tf_cs & 3) == 3) {
		// Trapped from user mode.
		// Acquire the big kernel lock before doing any
		// serious kernel work.
		// LAB 4: Your code here.
		lock_kernel();

		assert(curenv);

		// Garbage collect if current enviroment is a zombie
		if (curenv->env_status == ENV_DYING) {
			env_free(curenv);
			curenv = NULL;
			sched_yield();
		}

		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		curenv->env_tf = *tf;
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
	}

	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNING)
		env_run(curenv);
	else
		sched_yield();
}


void
page_fault_handler(struct Trapframe *tf)
{
	uint64_t fault_va;

	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	if((tf->tf_cs & 3) == 0)
		panic("page_fault: kernel-mode");

	// We've already handled kernel-mode exceptions, so if we get here,
	// the page fault happened in user mode.

	// Call the environment's page fault upcall, if one exists.  Set up a
	// page fault stack frame on the user exception stack (below
	// UXSTACKTOP), then branch to curenv->env_pgfault_upcall.
	//
	// The page fault upcall might cause another page fault, in which case
	// we branch to the page fault upcall recursively, pushing another
	// page fault stack frame on top of the user exception stack.
	//
	// The trap handler needs one word of scratch space at the top of the
	// trap-time stack in order to return.  In the non-recursive case, we
	// don't have to worry about this because the top of the regular user
	// stack is free.  In the recursive case, this means we have to leave
	// an extra word between the current top of the exception stack and
	// the new stack frame because the exception stack _is_ the trap-time
	// stack.
	//
	//
	// If there's no page fault upcall, the environment didn't allocate a
	// page for its exception stack or can't write to it, or the exception
	// stack overflows, then destroy the environment that caused the fault.
	// Note that the grade script assumes you will first check for the page
	// fault upcall and print the "user fault va" message below if there is
	// none.  The remaining three checks can be combined into a single test.
	//
	// Hints:
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	if(curenv->env_pgfault_upcall != NULL) {
		struct UTrapframe *utf;

		// allocate memory for another trap-frame
		utf = (struct UTrapframe *)(UXSTACKTOP - sizeof(struct UTrapframe));
		if(tf->tf_rsp >= UXSTACKTOP - PGSIZE && tf->tf_rsp < UXSTACKTOP)
			utf = (struct UTrapframe *)(tf->tf_rsp - sizeof(struct UTrapframe) - 8);
		user_mem_assert(curenv, utf, sizeof(struct UTrapframe), PTE_U | PTE_W);

		// store current trap-frame information
		utf->utf_fault_va = fault_va;
		utf->utf_err = tf->tf_err;
		utf->utf_regs = tf->tf_regs;
		utf->utf_rip = tf->tf_rip;
		utf->utf_rsp = tf->tf_rsp;
		utf->utf_eflags = tf->tf_eflags;

		// modify trap-frame to run env_pgfault_upcall
		tf->tf_rip = (uintptr_t)curenv->env_pgfault_upcall;
		tf->tf_rsp = (uintptr_t)utf;
		env_run(curenv);
	}

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
		curenv->env_id, fault_va, tf->tf_rip);
	print_trapframe(tf);
	env_destroy(curenv);
}

