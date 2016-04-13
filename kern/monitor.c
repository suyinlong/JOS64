// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/dwarf.h>
#include <kern/kdebug.h>
#include <kern/dwarf_api.h>
#include <kern/trap.h>
#include <kern/mmutils.h>
#include <kern/disasm/disasm.h>

#define CMDBUF_SIZE	80	// enough for one VGA text line


struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "backtrace", "Backtrace", mon_backtrace },
	{ "pinfo", "Display kernel page information", mon_mm_pinfo},
	{ "showmaps", "Display the mappings within the range", mon_mm_showmaps},
	{ "setmap", "Set the mapping permission", mon_mm_setmap},
	{ "dumpmem", "Dump memory at virtual or physical address", mon_mm_dumpmem},
	{ "binfo", "Show the BlockInfo entries", mon_mm_binfo},
	{ "bmalloc", "Malloc a contiguous block", mon_mm_bmalloc},
	{ "bfree", "Free a contiguous block", mon_mm_bfree},
	{ "bsplit", "Split a contiguous block into equal pieces", mon_mm_bsplit},
	{ "bcoalesce", "Coalesce several blocks into one block", mon_mm_bcoalesce},
	{ "u", "Debug command u", disasm_u},
	{ "s", "Debug command s", disasm_s},
	{ "c", "Debug command c", disasm_c},
	{ "einfo", "Display environment information", mon_mm_einfo},
	{ "fputest", "Test the FPU instructions", mon_mm_fputest},
	{ "snapshottest", "Test the Snapshot features", mon_mm_snapshottest},
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	// Your code here.
	int i;
	uint32_t arg;				// argument
	uint64_t rbp, rip;			// rbp and rip
	struct Ripdebuginfo info;	// backtrace info structure

	cprintf("\033[41;36mStack backtrace:\033[0m\n");

	// read rbp and rip from register
	// call debuginfo_rip to get backtrace information
	rbp = read_rbp();
	read_rip(rip);
	debuginfo_rip(rip, &info);

	while (rbp != 0) {
		// print stack and debug information
		cprintf("  rbp %016x  rip %016x\n", rbp, rip);
		cprintf("       %s:%d: ", info.rip_file, info.rip_line);
		for (i = 0; i < info.rip_fn_namelen; i++)
			cprintf("%c", info.rip_fn_name[i]);
		cprintf("+%016x", rip - info.rip_fn_addr);
		cprintf("  args:%d ", info.rip_fn_narg);
		for (i = 0; i < info.rip_fn_narg; i++)
			cprintf(" %016x", *((uint32_t *) (rbp - (i + 1) * 4)));
		cprintf("\n");
		// backtrace to upper level
		rip = *((uint64_t *) (rbp + 8));
		rbp = *((uint64_t *) rbp);
		debuginfo_rip(rip, &info);
	}

	return 0;
}



/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");

	if (tf != NULL) {
		//print_trapframe(tf);
		cprintf("\033[0;33mReturn to kernel monitor due to: %s\033[0m\n", (tf->tf_trapno == 1) ? "Debug" : ((tf->tf_trapno == 3) ? "Breakpoint" : "\033[0;31mUnknown"));
	}

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
