
obj/user/dumbfork.debug:     file format elf64-x86-64


Disassembly of section .text:

0000000000800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	movabs $USTACKTOP, %rax
  800020:	48 b8 00 e0 7f ef 00 	movabs $0xef7fe000,%rax
  800027:	00 00 00 
	cmpq %rax,%rsp
  80002a:	48 39 c4             	cmp    %rax,%rsp
	jne args_exist
  80002d:	75 04                	jne    800033 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushq $0
  80002f:	6a 00                	pushq  $0x0
	pushq $0
  800031:	6a 00                	pushq  $0x0

0000000000800033 <args_exist>:

args_exist:
	movq 8(%rsp), %rsi
  800033:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
	movq (%rsp), %rdi
  800038:	48 8b 3c 24          	mov    (%rsp),%rdi
	call libmain
  80003c:	e8 1c 03 00 00       	callq  80035d <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

envid_t dumbfork(void);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t who;
	int i;

	// fork a child process
	who = dumbfork();
  800052:	48 b8 03 02 80 00 00 	movabs $0x800203,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800068:	eb 4f                	jmp    8000b9 <umain+0x76>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  80006a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80006e:	74 0c                	je     80007c <umain+0x39>
  800070:	48 b8 00 38 80 00 00 	movabs $0x803800,%rax
  800077:	00 00 00 
  80007a:	eb 0a                	jmp    800086 <umain+0x43>
  80007c:	48 b8 07 38 80 00 00 	movabs $0x803807,%rax
  800083:	00 00 00 
  800086:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800089:	48 89 c2             	mov    %rax,%rdx
  80008c:	89 ce                	mov    %ecx,%esi
  80008e:	48 bf 0d 38 80 00 00 	movabs $0x80380d,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 b9 49 06 80 00 00 	movabs $0x800649,%rcx
  8000a4:	00 00 00 
  8000a7:	ff d1                	callq  *%rcx
		sys_yield();
  8000a9:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  8000b0:	00 00 00 
  8000b3:	ff d0                	callq  *%rax

	// fork a child process
	who = dumbfork();

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  8000b5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000b9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000bd:	74 07                	je     8000c6 <umain+0x83>
  8000bf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8000c4:	eb 05                	jmp    8000cb <umain+0x88>
  8000c6:	b8 14 00 00 00       	mov    $0x14,%eax
  8000cb:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000ce:	7f 9a                	jg     80006a <umain+0x27>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
		sys_yield();
	}
}
  8000d0:	c9                   	leaveq 
  8000d1:	c3                   	retq   

00000000008000d2 <duppage>:

void
duppage(envid_t dstenv, void *addr)
{
  8000d2:	55                   	push   %rbp
  8000d3:	48 89 e5             	mov    %rsp,%rbp
  8000d6:	48 83 ec 20          	sub    $0x20,%rsp
  8000da:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8000dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8000e1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8000e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e8:	ba 07 00 00 00       	mov    $0x7,%edx
  8000ed:	48 89 ce             	mov    %rcx,%rsi
  8000f0:	89 c7                	mov    %eax,%edi
  8000f2:	48 b8 20 1d 80 00 00 	movabs $0x801d20,%rax
  8000f9:	00 00 00 
  8000fc:	ff d0                	callq  *%rax
  8000fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800101:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800105:	79 30                	jns    800137 <duppage+0x65>
		panic("sys_page_alloc: %e", r);
  800107:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80010a:	89 c1                	mov    %eax,%ecx
  80010c:	48 ba 1f 38 80 00 00 	movabs $0x80381f,%rdx
  800113:	00 00 00 
  800116:	be 20 00 00 00       	mov    $0x20,%esi
  80011b:	48 bf 32 38 80 00 00 	movabs $0x803832,%rdi
  800122:	00 00 00 
  800125:	b8 00 00 00 00       	mov    $0x0,%eax
  80012a:	49 b8 10 04 80 00 00 	movabs $0x800410,%r8
  800131:	00 00 00 
  800134:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800137:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80013b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80013e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  800144:	b9 00 00 40 00       	mov    $0x400000,%ecx
  800149:	ba 00 00 00 00       	mov    $0x0,%edx
  80014e:	89 c7                	mov    %eax,%edi
  800150:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  800157:	00 00 00 
  80015a:	ff d0                	callq  *%rax
  80015c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80015f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800163:	79 30                	jns    800195 <duppage+0xc3>
		panic("sys_page_map: %e", r);
  800165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800168:	89 c1                	mov    %eax,%ecx
  80016a:	48 ba 42 38 80 00 00 	movabs $0x803842,%rdx
  800171:	00 00 00 
  800174:	be 22 00 00 00       	mov    $0x22,%esi
  800179:	48 bf 32 38 80 00 00 	movabs $0x803832,%rdi
  800180:	00 00 00 
  800183:	b8 00 00 00 00       	mov    $0x0,%eax
  800188:	49 b8 10 04 80 00 00 	movabs $0x800410,%r8
  80018f:	00 00 00 
  800192:	41 ff d0             	callq  *%r8
	memmove(UTEMP, addr, PGSIZE);
  800195:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800199:	ba 00 10 00 00       	mov    $0x1000,%edx
  80019e:	48 89 c6             	mov    %rax,%rsi
  8001a1:	bf 00 00 40 00       	mov    $0x400000,%edi
  8001a6:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8001b2:	be 00 00 40 00       	mov    $0x400000,%esi
  8001b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001bc:	48 b8 cb 1d 80 00 00 	movabs $0x801dcb,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
  8001c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001cf:	79 30                	jns    800201 <duppage+0x12f>
		panic("sys_page_unmap: %e", r);
  8001d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001d4:	89 c1                	mov    %eax,%ecx
  8001d6:	48 ba 53 38 80 00 00 	movabs $0x803853,%rdx
  8001dd:	00 00 00 
  8001e0:	be 25 00 00 00       	mov    $0x25,%esi
  8001e5:	48 bf 32 38 80 00 00 	movabs $0x803832,%rdi
  8001ec:	00 00 00 
  8001ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f4:	49 b8 10 04 80 00 00 	movabs $0x800410,%r8
  8001fb:	00 00 00 
  8001fe:	41 ff d0             	callq  *%r8
}
  800201:	c9                   	leaveq 
  800202:	c3                   	retq   

0000000000800203 <dumbfork>:

envid_t
dumbfork(void)
{
  800203:	55                   	push   %rbp
  800204:	48 89 e5             	mov    %rsp,%rbp
  800207:	48 83 ec 20          	sub    $0x20,%rsp
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80020b:	b8 07 00 00 00       	mov    $0x7,%eax
  800210:	cd 30                	int    $0x30
  800212:	89 45 e8             	mov    %eax,-0x18(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  800215:	8b 45 e8             	mov    -0x18(%rbp),%eax
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
  800218:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (envid < 0)
  80021b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021f:	79 30                	jns    800251 <dumbfork+0x4e>
		panic("sys_exofork: %e", envid);
  800221:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800224:	89 c1                	mov    %eax,%ecx
  800226:	48 ba 66 38 80 00 00 	movabs $0x803866,%rdx
  80022d:	00 00 00 
  800230:	be 37 00 00 00       	mov    $0x37,%esi
  800235:	48 bf 32 38 80 00 00 	movabs $0x803832,%rdi
  80023c:	00 00 00 
  80023f:	b8 00 00 00 00       	mov    $0x0,%eax
  800244:	49 b8 10 04 80 00 00 	movabs $0x800410,%r8
  80024b:	00 00 00 
  80024e:	41 ff d0             	callq  *%r8
	if (envid == 0) {
  800251:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800255:	75 46                	jne    80029d <dumbfork+0x9a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  800257:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  80025e:	00 00 00 
  800261:	ff d0                	callq  *%rax
  800263:	25 ff 03 00 00       	and    $0x3ff,%eax
  800268:	48 63 d0             	movslq %eax,%rdx
  80026b:	48 89 d0             	mov    %rdx,%rax
  80026e:	48 c1 e0 03          	shl    $0x3,%rax
  800272:	48 01 d0             	add    %rdx,%rax
  800275:	48 c1 e0 05          	shl    $0x5,%rax
  800279:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800280:	00 00 00 
  800283:	48 01 c2             	add    %rax,%rdx
  800286:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80028d:	00 00 00 
  800290:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	e9 be 00 00 00       	jmpq   80035b <dumbfork+0x158>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80029d:	48 c7 45 e0 00 00 80 	movq   $0x800000,-0x20(%rbp)
  8002a4:	00 
  8002a5:	eb 26                	jmp    8002cd <dumbfork+0xca>
		duppage(envid, addr);
  8002a7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8002ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ae:	48 89 d6             	mov    %rdx,%rsi
  8002b1:	89 c7                	mov    %eax,%edi
  8002b3:	48 b8 d2 00 80 00 00 	movabs $0x8000d2,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8002bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002c3:	48 05 00 10 00 00    	add    $0x1000,%rax
  8002c9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8002cd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8002d1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002d8:	00 00 00 
  8002db:	48 39 c2             	cmp    %rax,%rdx
  8002de:	72 c7                	jb     8002a7 <dumbfork+0xa4>
		duppage(envid, addr);

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  8002e0:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8002e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8002e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ec:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8002f2:	48 89 c2             	mov    %rax,%rdx
  8002f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002f8:	48 89 d6             	mov    %rdx,%rsi
  8002fb:	89 c7                	mov    %eax,%edi
  8002fd:	48 b8 d2 00 80 00 00 	movabs $0x8000d2,%rax
  800304:	00 00 00 
  800307:	ff d0                	callq  *%rax

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  800309:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80030c:	be 02 00 00 00       	mov    $0x2,%esi
  800311:	89 c7                	mov    %eax,%edi
  800313:	48 b8 15 1e 80 00 00 	movabs $0x801e15,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
  80031f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800322:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800326:	79 30                	jns    800358 <dumbfork+0x155>
		panic("sys_env_set_status: %e", r);
  800328:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	48 ba 76 38 80 00 00 	movabs $0x803876,%rdx
  800334:	00 00 00 
  800337:	be 4c 00 00 00       	mov    $0x4c,%esi
  80033c:	48 bf 32 38 80 00 00 	movabs $0x803832,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	49 b8 10 04 80 00 00 	movabs $0x800410,%r8
  800352:	00 00 00 
  800355:	41 ff d0             	callq  *%r8

	return envid;
  800358:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80035b:	c9                   	leaveq 
  80035c:	c3                   	retq   

000000000080035d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80035d:	55                   	push   %rbp
  80035e:	48 89 e5             	mov    %rsp,%rbp
  800361:	48 83 ec 10          	sub    $0x10,%rsp
  800365:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800368:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80036c:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
  800378:	48 98                	cltq   
  80037a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80037f:	48 89 c2             	mov    %rax,%rdx
  800382:	48 89 d0             	mov    %rdx,%rax
  800385:	48 c1 e0 03          	shl    $0x3,%rax
  800389:	48 01 d0             	add    %rdx,%rax
  80038c:	48 c1 e0 05          	shl    $0x5,%rax
  800390:	48 89 c2             	mov    %rax,%rdx
  800393:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80039a:	00 00 00 
  80039d:	48 01 c2             	add    %rax,%rdx
  8003a0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003a7:	00 00 00 
  8003aa:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003b1:	7e 14                	jle    8003c7 <libmain+0x6a>
		binaryname = argv[0];
  8003b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b7:	48 8b 10             	mov    (%rax),%rdx
  8003ba:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8003c1:	00 00 00 
  8003c4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ce:	48 89 d6             	mov    %rdx,%rsi
  8003d1:	89 c7                	mov    %eax,%edi
  8003d3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003da:	00 00 00 
  8003dd:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003df:	48 b8 ed 03 80 00 00 	movabs $0x8003ed,%rax
  8003e6:	00 00 00 
  8003e9:	ff d0                	callq  *%rax
}
  8003eb:	c9                   	leaveq 
  8003ec:	c3                   	retq   

00000000008003ed <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003ed:	55                   	push   %rbp
  8003ee:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003f1:	48 b8 ce 22 80 00 00 	movabs $0x8022ce,%rax
  8003f8:	00 00 00 
  8003fb:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003fd:	bf 00 00 00 00       	mov    $0x0,%edi
  800402:	48 b8 60 1c 80 00 00 	movabs $0x801c60,%rax
  800409:	00 00 00 
  80040c:	ff d0                	callq  *%rax
}
  80040e:	5d                   	pop    %rbp
  80040f:	c3                   	retq   

0000000000800410 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800410:	55                   	push   %rbp
  800411:	48 89 e5             	mov    %rsp,%rbp
  800414:	53                   	push   %rbx
  800415:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80041c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800423:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800429:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800430:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800437:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80043e:	84 c0                	test   %al,%al
  800440:	74 23                	je     800465 <_panic+0x55>
  800442:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800449:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80044d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800451:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800455:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800459:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80045d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800461:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800465:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80046c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800473:	00 00 00 
  800476:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80047d:	00 00 00 
  800480:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800484:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80048b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800492:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800499:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8004a0:	00 00 00 
  8004a3:	48 8b 18             	mov    (%rax),%rbx
  8004a6:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  8004ad:	00 00 00 
  8004b0:	ff d0                	callq  *%rax
  8004b2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004b8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004bf:	41 89 c8             	mov    %ecx,%r8d
  8004c2:	48 89 d1             	mov    %rdx,%rcx
  8004c5:	48 89 da             	mov    %rbx,%rdx
  8004c8:	89 c6                	mov    %eax,%esi
  8004ca:	48 bf 98 38 80 00 00 	movabs $0x803898,%rdi
  8004d1:	00 00 00 
  8004d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d9:	49 b9 49 06 80 00 00 	movabs $0x800649,%r9
  8004e0:	00 00 00 
  8004e3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004e6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004ed:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004f4:	48 89 d6             	mov    %rdx,%rsi
  8004f7:	48 89 c7             	mov    %rax,%rdi
  8004fa:	48 b8 9d 05 80 00 00 	movabs $0x80059d,%rax
  800501:	00 00 00 
  800504:	ff d0                	callq  *%rax
	cprintf("\n");
  800506:	48 bf bb 38 80 00 00 	movabs $0x8038bb,%rdi
  80050d:	00 00 00 
  800510:	b8 00 00 00 00       	mov    $0x0,%eax
  800515:	48 ba 49 06 80 00 00 	movabs $0x800649,%rdx
  80051c:	00 00 00 
  80051f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800521:	cc                   	int3   
  800522:	eb fd                	jmp    800521 <_panic+0x111>

0000000000800524 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800524:	55                   	push   %rbp
  800525:	48 89 e5             	mov    %rsp,%rbp
  800528:	48 83 ec 10          	sub    $0x10,%rsp
  80052c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80052f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800533:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800537:	8b 00                	mov    (%rax),%eax
  800539:	8d 48 01             	lea    0x1(%rax),%ecx
  80053c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800540:	89 0a                	mov    %ecx,(%rdx)
  800542:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800545:	89 d1                	mov    %edx,%ecx
  800547:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80054b:	48 98                	cltq   
  80054d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800551:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800555:	8b 00                	mov    (%rax),%eax
  800557:	3d ff 00 00 00       	cmp    $0xff,%eax
  80055c:	75 2c                	jne    80058a <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80055e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800562:	8b 00                	mov    (%rax),%eax
  800564:	48 98                	cltq   
  800566:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80056a:	48 83 c2 08          	add    $0x8,%rdx
  80056e:	48 89 c6             	mov    %rax,%rsi
  800571:	48 89 d7             	mov    %rdx,%rdi
  800574:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  80057b:	00 00 00 
  80057e:	ff d0                	callq  *%rax
		b->idx = 0;
  800580:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800584:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80058a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80058e:	8b 40 04             	mov    0x4(%rax),%eax
  800591:	8d 50 01             	lea    0x1(%rax),%edx
  800594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800598:	89 50 04             	mov    %edx,0x4(%rax)
}
  80059b:	c9                   	leaveq 
  80059c:	c3                   	retq   

000000000080059d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80059d:	55                   	push   %rbp
  80059e:	48 89 e5             	mov    %rsp,%rbp
  8005a1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005a8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005af:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8005b6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005bd:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005c4:	48 8b 0a             	mov    (%rdx),%rcx
  8005c7:	48 89 08             	mov    %rcx,(%rax)
  8005ca:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005ce:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005d2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005d6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8005da:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005e1:	00 00 00 
	b.cnt = 0;
  8005e4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005eb:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8005ee:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005f5:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005fc:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800603:	48 89 c6             	mov    %rax,%rsi
  800606:	48 bf 24 05 80 00 00 	movabs $0x800524,%rdi
  80060d:	00 00 00 
  800610:	48 b8 fc 09 80 00 00 	movabs $0x8009fc,%rax
  800617:	00 00 00 
  80061a:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80061c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800622:	48 98                	cltq   
  800624:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80062b:	48 83 c2 08          	add    $0x8,%rdx
  80062f:	48 89 c6             	mov    %rax,%rsi
  800632:	48 89 d7             	mov    %rdx,%rdi
  800635:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  80063c:	00 00 00 
  80063f:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800641:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800647:	c9                   	leaveq 
  800648:	c3                   	retq   

0000000000800649 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800649:	55                   	push   %rbp
  80064a:	48 89 e5             	mov    %rsp,%rbp
  80064d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800654:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80065b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800662:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800669:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800670:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800677:	84 c0                	test   %al,%al
  800679:	74 20                	je     80069b <cprintf+0x52>
  80067b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80067f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800683:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800687:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80068b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80068f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800693:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800697:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80069b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8006a2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006a9:	00 00 00 
  8006ac:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006b3:	00 00 00 
  8006b6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006ba:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006c1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006c8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8006cf:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006d6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006dd:	48 8b 0a             	mov    (%rdx),%rcx
  8006e0:	48 89 08             	mov    %rcx,(%rax)
  8006e3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006e7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006eb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006ef:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8006f3:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006fa:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800701:	48 89 d6             	mov    %rdx,%rsi
  800704:	48 89 c7             	mov    %rax,%rdi
  800707:	48 b8 9d 05 80 00 00 	movabs $0x80059d,%rax
  80070e:	00 00 00 
  800711:	ff d0                	callq  *%rax
  800713:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800719:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80071f:	c9                   	leaveq 
  800720:	c3                   	retq   

0000000000800721 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800721:	55                   	push   %rbp
  800722:	48 89 e5             	mov    %rsp,%rbp
  800725:	53                   	push   %rbx
  800726:	48 83 ec 38          	sub    $0x38,%rsp
  80072a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80072e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800732:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800736:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800739:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80073d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800741:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800744:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800748:	77 3b                	ja     800785 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80074a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80074d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800751:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800754:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800758:	ba 00 00 00 00       	mov    $0x0,%edx
  80075d:	48 f7 f3             	div    %rbx
  800760:	48 89 c2             	mov    %rax,%rdx
  800763:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800766:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800769:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80076d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800771:	41 89 f9             	mov    %edi,%r9d
  800774:	48 89 c7             	mov    %rax,%rdi
  800777:	48 b8 21 07 80 00 00 	movabs $0x800721,%rax
  80077e:	00 00 00 
  800781:	ff d0                	callq  *%rax
  800783:	eb 1e                	jmp    8007a3 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800785:	eb 12                	jmp    800799 <printnum+0x78>
			putch(padc, putdat);
  800787:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80078b:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80078e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800792:	48 89 ce             	mov    %rcx,%rsi
  800795:	89 d7                	mov    %edx,%edi
  800797:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800799:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80079d:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007a1:	7f e4                	jg     800787 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007a3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8007af:	48 f7 f1             	div    %rcx
  8007b2:	48 89 d0             	mov    %rdx,%rax
  8007b5:	48 ba 88 3a 80 00 00 	movabs $0x803a88,%rdx
  8007bc:	00 00 00 
  8007bf:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007c3:	0f be d0             	movsbl %al,%edx
  8007c6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	48 89 ce             	mov    %rcx,%rsi
  8007d1:	89 d7                	mov    %edx,%edi
  8007d3:	ff d0                	callq  *%rax
}
  8007d5:	48 83 c4 38          	add    $0x38,%rsp
  8007d9:	5b                   	pop    %rbx
  8007da:	5d                   	pop    %rbp
  8007db:	c3                   	retq   

00000000008007dc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007dc:	55                   	push   %rbp
  8007dd:	48 89 e5             	mov    %rsp,%rbp
  8007e0:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007e8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8007eb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007ef:	7e 52                	jle    800843 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f5:	8b 00                	mov    (%rax),%eax
  8007f7:	83 f8 30             	cmp    $0x30,%eax
  8007fa:	73 24                	jae    800820 <getuint+0x44>
  8007fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800800:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800804:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800808:	8b 00                	mov    (%rax),%eax
  80080a:	89 c0                	mov    %eax,%eax
  80080c:	48 01 d0             	add    %rdx,%rax
  80080f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800813:	8b 12                	mov    (%rdx),%edx
  800815:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800818:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081c:	89 0a                	mov    %ecx,(%rdx)
  80081e:	eb 17                	jmp    800837 <getuint+0x5b>
  800820:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800824:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800828:	48 89 d0             	mov    %rdx,%rax
  80082b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80082f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800833:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800837:	48 8b 00             	mov    (%rax),%rax
  80083a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80083e:	e9 a3 00 00 00       	jmpq   8008e6 <getuint+0x10a>
	else if (lflag)
  800843:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800847:	74 4f                	je     800898 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084d:	8b 00                	mov    (%rax),%eax
  80084f:	83 f8 30             	cmp    $0x30,%eax
  800852:	73 24                	jae    800878 <getuint+0x9c>
  800854:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800858:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80085c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800860:	8b 00                	mov    (%rax),%eax
  800862:	89 c0                	mov    %eax,%eax
  800864:	48 01 d0             	add    %rdx,%rax
  800867:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086b:	8b 12                	mov    (%rdx),%edx
  80086d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800870:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800874:	89 0a                	mov    %ecx,(%rdx)
  800876:	eb 17                	jmp    80088f <getuint+0xb3>
  800878:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800880:	48 89 d0             	mov    %rdx,%rax
  800883:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800887:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80088f:	48 8b 00             	mov    (%rax),%rax
  800892:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800896:	eb 4e                	jmp    8008e6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089c:	8b 00                	mov    (%rax),%eax
  80089e:	83 f8 30             	cmp    $0x30,%eax
  8008a1:	73 24                	jae    8008c7 <getuint+0xeb>
  8008a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008af:	8b 00                	mov    (%rax),%eax
  8008b1:	89 c0                	mov    %eax,%eax
  8008b3:	48 01 d0             	add    %rdx,%rax
  8008b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ba:	8b 12                	mov    (%rdx),%edx
  8008bc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c3:	89 0a                	mov    %ecx,(%rdx)
  8008c5:	eb 17                	jmp    8008de <getuint+0x102>
  8008c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008cb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008cf:	48 89 d0             	mov    %rdx,%rax
  8008d2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008da:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008de:	8b 00                	mov    (%rax),%eax
  8008e0:	89 c0                	mov    %eax,%eax
  8008e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008ea:	c9                   	leaveq 
  8008eb:	c3                   	retq   

00000000008008ec <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ec:	55                   	push   %rbp
  8008ed:	48 89 e5             	mov    %rsp,%rbp
  8008f0:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008f8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008fb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008ff:	7e 52                	jle    800953 <getint+0x67>
		x=va_arg(*ap, long long);
  800901:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800905:	8b 00                	mov    (%rax),%eax
  800907:	83 f8 30             	cmp    $0x30,%eax
  80090a:	73 24                	jae    800930 <getint+0x44>
  80090c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800910:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800914:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800918:	8b 00                	mov    (%rax),%eax
  80091a:	89 c0                	mov    %eax,%eax
  80091c:	48 01 d0             	add    %rdx,%rax
  80091f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800923:	8b 12                	mov    (%rdx),%edx
  800925:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800928:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092c:	89 0a                	mov    %ecx,(%rdx)
  80092e:	eb 17                	jmp    800947 <getint+0x5b>
  800930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800934:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800938:	48 89 d0             	mov    %rdx,%rax
  80093b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80093f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800943:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800947:	48 8b 00             	mov    (%rax),%rax
  80094a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80094e:	e9 a3 00 00 00       	jmpq   8009f6 <getint+0x10a>
	else if (lflag)
  800953:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800957:	74 4f                	je     8009a8 <getint+0xbc>
		x=va_arg(*ap, long);
  800959:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095d:	8b 00                	mov    (%rax),%eax
  80095f:	83 f8 30             	cmp    $0x30,%eax
  800962:	73 24                	jae    800988 <getint+0x9c>
  800964:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800968:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80096c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800970:	8b 00                	mov    (%rax),%eax
  800972:	89 c0                	mov    %eax,%eax
  800974:	48 01 d0             	add    %rdx,%rax
  800977:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097b:	8b 12                	mov    (%rdx),%edx
  80097d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800980:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800984:	89 0a                	mov    %ecx,(%rdx)
  800986:	eb 17                	jmp    80099f <getint+0xb3>
  800988:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800990:	48 89 d0             	mov    %rdx,%rax
  800993:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800997:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80099f:	48 8b 00             	mov    (%rax),%rax
  8009a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009a6:	eb 4e                	jmp    8009f6 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ac:	8b 00                	mov    (%rax),%eax
  8009ae:	83 f8 30             	cmp    $0x30,%eax
  8009b1:	73 24                	jae    8009d7 <getint+0xeb>
  8009b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bf:	8b 00                	mov    (%rax),%eax
  8009c1:	89 c0                	mov    %eax,%eax
  8009c3:	48 01 d0             	add    %rdx,%rax
  8009c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ca:	8b 12                	mov    (%rdx),%edx
  8009cc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d3:	89 0a                	mov    %ecx,(%rdx)
  8009d5:	eb 17                	jmp    8009ee <getint+0x102>
  8009d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009db:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009df:	48 89 d0             	mov    %rdx,%rax
  8009e2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ee:	8b 00                	mov    (%rax),%eax
  8009f0:	48 98                	cltq   
  8009f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009fa:	c9                   	leaveq 
  8009fb:	c3                   	retq   

00000000008009fc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009fc:	55                   	push   %rbp
  8009fd:	48 89 e5             	mov    %rsp,%rbp
  800a00:	41 54                	push   %r12
  800a02:	53                   	push   %rbx
  800a03:	48 83 ec 60          	sub    $0x60,%rsp
  800a07:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a0b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a0f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a13:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a17:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a1b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a1f:	48 8b 0a             	mov    (%rdx),%rcx
  800a22:	48 89 08             	mov    %rcx,(%rax)
  800a25:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a29:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a2d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a31:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  800a35:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a39:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a3d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a41:	0f b6 00             	movzbl (%rax),%eax
  800a44:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  800a47:	eb 29                	jmp    800a72 <vprintfmt+0x76>
			if (ch == '\0')
  800a49:	85 db                	test   %ebx,%ebx
  800a4b:	0f 84 ad 06 00 00    	je     8010fe <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  800a51:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a59:	48 89 d6             	mov    %rdx,%rsi
  800a5c:	89 df                	mov    %ebx,%edi
  800a5e:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  800a60:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a64:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a68:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a6c:	0f b6 00             	movzbl (%rax),%eax
  800a6f:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  800a72:	83 fb 25             	cmp    $0x25,%ebx
  800a75:	74 05                	je     800a7c <vprintfmt+0x80>
  800a77:	83 fb 1b             	cmp    $0x1b,%ebx
  800a7a:	75 cd                	jne    800a49 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800a7c:	83 fb 1b             	cmp    $0x1b,%ebx
  800a7f:	0f 85 ae 01 00 00    	jne    800c33 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  800a85:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800a8c:	00 00 00 
  800a8f:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  800a95:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a99:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9d:	48 89 d6             	mov    %rdx,%rsi
  800aa0:	89 df                	mov    %ebx,%edi
  800aa2:	ff d0                	callq  *%rax
			putch('[', putdat);
  800aa4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aac:	48 89 d6             	mov    %rdx,%rsi
  800aaf:	bf 5b 00 00 00       	mov    $0x5b,%edi
  800ab4:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800ab6:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800abc:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800ac1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ac5:	0f b6 00             	movzbl (%rax),%eax
  800ac8:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800acb:	eb 32                	jmp    800aff <vprintfmt+0x103>
					putch(ch, putdat);
  800acd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad5:	48 89 d6             	mov    %rdx,%rsi
  800ad8:	89 df                	mov    %ebx,%edi
  800ada:	ff d0                	callq  *%rax
					esc_color *= 10;
  800adc:	44 89 e0             	mov    %r12d,%eax
  800adf:	c1 e0 02             	shl    $0x2,%eax
  800ae2:	44 01 e0             	add    %r12d,%eax
  800ae5:	01 c0                	add    %eax,%eax
  800ae7:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800aea:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800aed:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800af0:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800af5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800af9:	0f b6 00             	movzbl (%rax),%eax
  800afc:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800aff:	83 fb 3b             	cmp    $0x3b,%ebx
  800b02:	74 05                	je     800b09 <vprintfmt+0x10d>
  800b04:	83 fb 6d             	cmp    $0x6d,%ebx
  800b07:	75 c4                	jne    800acd <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800b09:	45 85 e4             	test   %r12d,%r12d
  800b0c:	75 15                	jne    800b23 <vprintfmt+0x127>
					color_flag = 0x07;
  800b0e:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800b15:	00 00 00 
  800b18:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800b1e:	e9 dc 00 00 00       	jmpq   800bff <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800b23:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800b27:	7e 69                	jle    800b92 <vprintfmt+0x196>
  800b29:	41 83 fc 25          	cmp    $0x25,%r12d
  800b2d:	7f 63                	jg     800b92 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800b2f:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800b36:	00 00 00 
  800b39:	8b 00                	mov    (%rax),%eax
  800b3b:	25 f8 00 00 00       	and    $0xf8,%eax
  800b40:	89 c2                	mov    %eax,%edx
  800b42:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800b49:	00 00 00 
  800b4c:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800b4e:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800b52:	44 89 e0             	mov    %r12d,%eax
  800b55:	83 e0 04             	and    $0x4,%eax
  800b58:	c1 f8 02             	sar    $0x2,%eax
  800b5b:	89 c2                	mov    %eax,%edx
  800b5d:	44 89 e0             	mov    %r12d,%eax
  800b60:	83 e0 02             	and    $0x2,%eax
  800b63:	09 c2                	or     %eax,%edx
  800b65:	44 89 e0             	mov    %r12d,%eax
  800b68:	83 e0 01             	and    $0x1,%eax
  800b6b:	c1 e0 02             	shl    $0x2,%eax
  800b6e:	09 c2                	or     %eax,%edx
  800b70:	41 89 d4             	mov    %edx,%r12d
  800b73:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800b7a:	00 00 00 
  800b7d:	8b 00                	mov    (%rax),%eax
  800b7f:	44 89 e2             	mov    %r12d,%edx
  800b82:	09 c2                	or     %eax,%edx
  800b84:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800b8b:	00 00 00 
  800b8e:	89 10                	mov    %edx,(%rax)
  800b90:	eb 6d                	jmp    800bff <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800b92:	41 83 fc 27          	cmp    $0x27,%r12d
  800b96:	7e 67                	jle    800bff <vprintfmt+0x203>
  800b98:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800b9c:	7f 61                	jg     800bff <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800b9e:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800ba5:	00 00 00 
  800ba8:	8b 00                	mov    (%rax),%eax
  800baa:	25 8f 00 00 00       	and    $0x8f,%eax
  800baf:	89 c2                	mov    %eax,%edx
  800bb1:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800bb8:	00 00 00 
  800bbb:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800bbd:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800bc1:	44 89 e0             	mov    %r12d,%eax
  800bc4:	83 e0 04             	and    $0x4,%eax
  800bc7:	c1 f8 02             	sar    $0x2,%eax
  800bca:	89 c2                	mov    %eax,%edx
  800bcc:	44 89 e0             	mov    %r12d,%eax
  800bcf:	83 e0 02             	and    $0x2,%eax
  800bd2:	09 c2                	or     %eax,%edx
  800bd4:	44 89 e0             	mov    %r12d,%eax
  800bd7:	83 e0 01             	and    $0x1,%eax
  800bda:	c1 e0 06             	shl    $0x6,%eax
  800bdd:	09 c2                	or     %eax,%edx
  800bdf:	41 89 d4             	mov    %edx,%r12d
  800be2:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800be9:	00 00 00 
  800bec:	8b 00                	mov    (%rax),%eax
  800bee:	44 89 e2             	mov    %r12d,%edx
  800bf1:	09 c2                	or     %eax,%edx
  800bf3:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800bfa:	00 00 00 
  800bfd:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800bff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c03:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c07:	48 89 d6             	mov    %rdx,%rsi
  800c0a:	89 df                	mov    %ebx,%edi
  800c0c:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800c0e:	83 fb 6d             	cmp    $0x6d,%ebx
  800c11:	75 1b                	jne    800c2e <vprintfmt+0x232>
					fmt ++;
  800c13:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800c18:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800c19:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800c20:	00 00 00 
  800c23:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800c29:	e9 cb 04 00 00       	jmpq   8010f9 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800c2e:	e9 83 fe ff ff       	jmpq   800ab6 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800c33:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c37:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c3e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c45:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c4c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c53:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c57:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c5b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c5f:	0f b6 00             	movzbl (%rax),%eax
  800c62:	0f b6 d8             	movzbl %al,%ebx
  800c65:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c68:	83 f8 55             	cmp    $0x55,%eax
  800c6b:	0f 87 5a 04 00 00    	ja     8010cb <vprintfmt+0x6cf>
  800c71:	89 c0                	mov    %eax,%eax
  800c73:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c7a:	00 
  800c7b:	48 b8 b0 3a 80 00 00 	movabs $0x803ab0,%rax
  800c82:	00 00 00 
  800c85:	48 01 d0             	add    %rdx,%rax
  800c88:	48 8b 00             	mov    (%rax),%rax
  800c8b:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c8d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c91:	eb c0                	jmp    800c53 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c93:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c97:	eb ba                	jmp    800c53 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c99:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ca0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ca3:	89 d0                	mov    %edx,%eax
  800ca5:	c1 e0 02             	shl    $0x2,%eax
  800ca8:	01 d0                	add    %edx,%eax
  800caa:	01 c0                	add    %eax,%eax
  800cac:	01 d8                	add    %ebx,%eax
  800cae:	83 e8 30             	sub    $0x30,%eax
  800cb1:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800cb4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cb8:	0f b6 00             	movzbl (%rax),%eax
  800cbb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cbe:	83 fb 2f             	cmp    $0x2f,%ebx
  800cc1:	7e 0c                	jle    800ccf <vprintfmt+0x2d3>
  800cc3:	83 fb 39             	cmp    $0x39,%ebx
  800cc6:	7f 07                	jg     800ccf <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cc8:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ccd:	eb d1                	jmp    800ca0 <vprintfmt+0x2a4>
			goto process_precision;
  800ccf:	eb 58                	jmp    800d29 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800cd1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd4:	83 f8 30             	cmp    $0x30,%eax
  800cd7:	73 17                	jae    800cf0 <vprintfmt+0x2f4>
  800cd9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cdd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce0:	89 c0                	mov    %eax,%eax
  800ce2:	48 01 d0             	add    %rdx,%rax
  800ce5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ce8:	83 c2 08             	add    $0x8,%edx
  800ceb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cee:	eb 0f                	jmp    800cff <vprintfmt+0x303>
  800cf0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cf4:	48 89 d0             	mov    %rdx,%rax
  800cf7:	48 83 c2 08          	add    $0x8,%rdx
  800cfb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cff:	8b 00                	mov    (%rax),%eax
  800d01:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800d04:	eb 23                	jmp    800d29 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800d06:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d0a:	79 0c                	jns    800d18 <vprintfmt+0x31c>
				width = 0;
  800d0c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d13:	e9 3b ff ff ff       	jmpq   800c53 <vprintfmt+0x257>
  800d18:	e9 36 ff ff ff       	jmpq   800c53 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800d1d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d24:	e9 2a ff ff ff       	jmpq   800c53 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800d29:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d2d:	79 12                	jns    800d41 <vprintfmt+0x345>
				width = precision, precision = -1;
  800d2f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d32:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d35:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d3c:	e9 12 ff ff ff       	jmpq   800c53 <vprintfmt+0x257>
  800d41:	e9 0d ff ff ff       	jmpq   800c53 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d46:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d4a:	e9 04 ff ff ff       	jmpq   800c53 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d4f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d52:	83 f8 30             	cmp    $0x30,%eax
  800d55:	73 17                	jae    800d6e <vprintfmt+0x372>
  800d57:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d5b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d5e:	89 c0                	mov    %eax,%eax
  800d60:	48 01 d0             	add    %rdx,%rax
  800d63:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d66:	83 c2 08             	add    $0x8,%edx
  800d69:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d6c:	eb 0f                	jmp    800d7d <vprintfmt+0x381>
  800d6e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d72:	48 89 d0             	mov    %rdx,%rax
  800d75:	48 83 c2 08          	add    $0x8,%rdx
  800d79:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d7d:	8b 10                	mov    (%rax),%edx
  800d7f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d87:	48 89 ce             	mov    %rcx,%rsi
  800d8a:	89 d7                	mov    %edx,%edi
  800d8c:	ff d0                	callq  *%rax
			break;
  800d8e:	e9 66 03 00 00       	jmpq   8010f9 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800d93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d96:	83 f8 30             	cmp    $0x30,%eax
  800d99:	73 17                	jae    800db2 <vprintfmt+0x3b6>
  800d9b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800da2:	89 c0                	mov    %eax,%eax
  800da4:	48 01 d0             	add    %rdx,%rax
  800da7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800daa:	83 c2 08             	add    $0x8,%edx
  800dad:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800db0:	eb 0f                	jmp    800dc1 <vprintfmt+0x3c5>
  800db2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800db6:	48 89 d0             	mov    %rdx,%rax
  800db9:	48 83 c2 08          	add    $0x8,%rdx
  800dbd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dc1:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800dc3:	85 db                	test   %ebx,%ebx
  800dc5:	79 02                	jns    800dc9 <vprintfmt+0x3cd>
				err = -err;
  800dc7:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800dc9:	83 fb 10             	cmp    $0x10,%ebx
  800dcc:	7f 16                	jg     800de4 <vprintfmt+0x3e8>
  800dce:	48 b8 00 3a 80 00 00 	movabs $0x803a00,%rax
  800dd5:	00 00 00 
  800dd8:	48 63 d3             	movslq %ebx,%rdx
  800ddb:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ddf:	4d 85 e4             	test   %r12,%r12
  800de2:	75 2e                	jne    800e12 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800de4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800de8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dec:	89 d9                	mov    %ebx,%ecx
  800dee:	48 ba 99 3a 80 00 00 	movabs $0x803a99,%rdx
  800df5:	00 00 00 
  800df8:	48 89 c7             	mov    %rax,%rdi
  800dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800e00:	49 b8 07 11 80 00 00 	movabs $0x801107,%r8
  800e07:	00 00 00 
  800e0a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e0d:	e9 e7 02 00 00       	jmpq   8010f9 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e12:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e16:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1a:	4c 89 e1             	mov    %r12,%rcx
  800e1d:	48 ba a2 3a 80 00 00 	movabs $0x803aa2,%rdx
  800e24:	00 00 00 
  800e27:	48 89 c7             	mov    %rax,%rdi
  800e2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2f:	49 b8 07 11 80 00 00 	movabs $0x801107,%r8
  800e36:	00 00 00 
  800e39:	41 ff d0             	callq  *%r8
			break;
  800e3c:	e9 b8 02 00 00       	jmpq   8010f9 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e41:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e44:	83 f8 30             	cmp    $0x30,%eax
  800e47:	73 17                	jae    800e60 <vprintfmt+0x464>
  800e49:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e4d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e50:	89 c0                	mov    %eax,%eax
  800e52:	48 01 d0             	add    %rdx,%rax
  800e55:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e58:	83 c2 08             	add    $0x8,%edx
  800e5b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e5e:	eb 0f                	jmp    800e6f <vprintfmt+0x473>
  800e60:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e64:	48 89 d0             	mov    %rdx,%rax
  800e67:	48 83 c2 08          	add    $0x8,%rdx
  800e6b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e6f:	4c 8b 20             	mov    (%rax),%r12
  800e72:	4d 85 e4             	test   %r12,%r12
  800e75:	75 0a                	jne    800e81 <vprintfmt+0x485>
				p = "(null)";
  800e77:	49 bc a5 3a 80 00 00 	movabs $0x803aa5,%r12
  800e7e:	00 00 00 
			if (width > 0 && padc != '-')
  800e81:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e85:	7e 3f                	jle    800ec6 <vprintfmt+0x4ca>
  800e87:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e8b:	74 39                	je     800ec6 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e8d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e90:	48 98                	cltq   
  800e92:	48 89 c6             	mov    %rax,%rsi
  800e95:	4c 89 e7             	mov    %r12,%rdi
  800e98:	48 b8 b3 13 80 00 00 	movabs $0x8013b3,%rax
  800e9f:	00 00 00 
  800ea2:	ff d0                	callq  *%rax
  800ea4:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ea7:	eb 17                	jmp    800ec0 <vprintfmt+0x4c4>
					putch(padc, putdat);
  800ea9:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ead:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800eb1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb5:	48 89 ce             	mov    %rcx,%rsi
  800eb8:	89 d7                	mov    %edx,%edi
  800eba:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ebc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ec0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ec4:	7f e3                	jg     800ea9 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ec6:	eb 37                	jmp    800eff <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800ec8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ecc:	74 1e                	je     800eec <vprintfmt+0x4f0>
  800ece:	83 fb 1f             	cmp    $0x1f,%ebx
  800ed1:	7e 05                	jle    800ed8 <vprintfmt+0x4dc>
  800ed3:	83 fb 7e             	cmp    $0x7e,%ebx
  800ed6:	7e 14                	jle    800eec <vprintfmt+0x4f0>
					putch('?', putdat);
  800ed8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800edc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee0:	48 89 d6             	mov    %rdx,%rsi
  800ee3:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ee8:	ff d0                	callq  *%rax
  800eea:	eb 0f                	jmp    800efb <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800eec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef4:	48 89 d6             	mov    %rdx,%rsi
  800ef7:	89 df                	mov    %ebx,%edi
  800ef9:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800efb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800eff:	4c 89 e0             	mov    %r12,%rax
  800f02:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800f06:	0f b6 00             	movzbl (%rax),%eax
  800f09:	0f be d8             	movsbl %al,%ebx
  800f0c:	85 db                	test   %ebx,%ebx
  800f0e:	74 10                	je     800f20 <vprintfmt+0x524>
  800f10:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f14:	78 b2                	js     800ec8 <vprintfmt+0x4cc>
  800f16:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f1a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f1e:	79 a8                	jns    800ec8 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f20:	eb 16                	jmp    800f38 <vprintfmt+0x53c>
				putch(' ', putdat);
  800f22:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f2a:	48 89 d6             	mov    %rdx,%rsi
  800f2d:	bf 20 00 00 00       	mov    $0x20,%edi
  800f32:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f34:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f38:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f3c:	7f e4                	jg     800f22 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800f3e:	e9 b6 01 00 00       	jmpq   8010f9 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f43:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f47:	be 03 00 00 00       	mov    $0x3,%esi
  800f4c:	48 89 c7             	mov    %rax,%rdi
  800f4f:	48 b8 ec 08 80 00 00 	movabs $0x8008ec,%rax
  800f56:	00 00 00 
  800f59:	ff d0                	callq  *%rax
  800f5b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f63:	48 85 c0             	test   %rax,%rax
  800f66:	79 1d                	jns    800f85 <vprintfmt+0x589>
				putch('-', putdat);
  800f68:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f70:	48 89 d6             	mov    %rdx,%rsi
  800f73:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f78:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7e:	48 f7 d8             	neg    %rax
  800f81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f85:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f8c:	e9 fb 00 00 00       	jmpq   80108c <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f91:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f95:	be 03 00 00 00       	mov    $0x3,%esi
  800f9a:	48 89 c7             	mov    %rax,%rdi
  800f9d:	48 b8 dc 07 80 00 00 	movabs $0x8007dc,%rax
  800fa4:	00 00 00 
  800fa7:	ff d0                	callq  *%rax
  800fa9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800fad:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fb4:	e9 d3 00 00 00       	jmpq   80108c <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800fb9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fbd:	be 03 00 00 00       	mov    $0x3,%esi
  800fc2:	48 89 c7             	mov    %rax,%rdi
  800fc5:	48 b8 ec 08 80 00 00 	movabs $0x8008ec,%rax
  800fcc:	00 00 00 
  800fcf:	ff d0                	callq  *%rax
  800fd1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800fd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd9:	48 85 c0             	test   %rax,%rax
  800fdc:	79 1d                	jns    800ffb <vprintfmt+0x5ff>
				putch('-', putdat);
  800fde:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fe2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe6:	48 89 d6             	mov    %rdx,%rsi
  800fe9:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800fee:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ff0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff4:	48 f7 d8             	neg    %rax
  800ff7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800ffb:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801002:	e9 85 00 00 00       	jmpq   80108c <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  801007:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80100b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80100f:	48 89 d6             	mov    %rdx,%rsi
  801012:	bf 30 00 00 00       	mov    $0x30,%edi
  801017:	ff d0                	callq  *%rax
			putch('x', putdat);
  801019:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80101d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801021:	48 89 d6             	mov    %rdx,%rsi
  801024:	bf 78 00 00 00       	mov    $0x78,%edi
  801029:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80102b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80102e:	83 f8 30             	cmp    $0x30,%eax
  801031:	73 17                	jae    80104a <vprintfmt+0x64e>
  801033:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801037:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80103a:	89 c0                	mov    %eax,%eax
  80103c:	48 01 d0             	add    %rdx,%rax
  80103f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801042:	83 c2 08             	add    $0x8,%edx
  801045:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801048:	eb 0f                	jmp    801059 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  80104a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80104e:	48 89 d0             	mov    %rdx,%rax
  801051:	48 83 c2 08          	add    $0x8,%rdx
  801055:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801059:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80105c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801060:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801067:	eb 23                	jmp    80108c <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801069:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80106d:	be 03 00 00 00       	mov    $0x3,%esi
  801072:	48 89 c7             	mov    %rax,%rdi
  801075:	48 b8 dc 07 80 00 00 	movabs $0x8007dc,%rax
  80107c:	00 00 00 
  80107f:	ff d0                	callq  *%rax
  801081:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801085:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80108c:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801091:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801094:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801097:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80109b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80109f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010a3:	45 89 c1             	mov    %r8d,%r9d
  8010a6:	41 89 f8             	mov    %edi,%r8d
  8010a9:	48 89 c7             	mov    %rax,%rdi
  8010ac:	48 b8 21 07 80 00 00 	movabs $0x800721,%rax
  8010b3:	00 00 00 
  8010b6:	ff d0                	callq  *%rax
			break;
  8010b8:	eb 3f                	jmp    8010f9 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010be:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010c2:	48 89 d6             	mov    %rdx,%rsi
  8010c5:	89 df                	mov    %ebx,%edi
  8010c7:	ff d0                	callq  *%rax
			break;
  8010c9:	eb 2e                	jmp    8010f9 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010cb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010cf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010d3:	48 89 d6             	mov    %rdx,%rsi
  8010d6:	bf 25 00 00 00       	mov    $0x25,%edi
  8010db:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010dd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010e2:	eb 05                	jmp    8010e9 <vprintfmt+0x6ed>
  8010e4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010e9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010ed:	48 83 e8 01          	sub    $0x1,%rax
  8010f1:	0f b6 00             	movzbl (%rax),%eax
  8010f4:	3c 25                	cmp    $0x25,%al
  8010f6:	75 ec                	jne    8010e4 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  8010f8:	90                   	nop
		}
	}
  8010f9:	e9 37 f9 ff ff       	jmpq   800a35 <vprintfmt+0x39>
    va_end(aq);
}
  8010fe:	48 83 c4 60          	add    $0x60,%rsp
  801102:	5b                   	pop    %rbx
  801103:	41 5c                	pop    %r12
  801105:	5d                   	pop    %rbp
  801106:	c3                   	retq   

0000000000801107 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801107:	55                   	push   %rbp
  801108:	48 89 e5             	mov    %rsp,%rbp
  80110b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801112:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801119:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801120:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801127:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80112e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801135:	84 c0                	test   %al,%al
  801137:	74 20                	je     801159 <printfmt+0x52>
  801139:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80113d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801141:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801145:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801149:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80114d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801151:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801155:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801159:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801160:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801167:	00 00 00 
  80116a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801171:	00 00 00 
  801174:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801178:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80117f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801186:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80118d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801194:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80119b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8011a2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8011a9:	48 89 c7             	mov    %rax,%rdi
  8011ac:	48 b8 fc 09 80 00 00 	movabs $0x8009fc,%rax
  8011b3:	00 00 00 
  8011b6:	ff d0                	callq  *%rax
	va_end(ap);
}
  8011b8:	c9                   	leaveq 
  8011b9:	c3                   	retq   

00000000008011ba <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011ba:	55                   	push   %rbp
  8011bb:	48 89 e5             	mov    %rsp,%rbp
  8011be:	48 83 ec 10          	sub    $0x10,%rsp
  8011c2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8011c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8011c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011cd:	8b 40 10             	mov    0x10(%rax),%eax
  8011d0:	8d 50 01             	lea    0x1(%rax),%edx
  8011d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d7:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011de:	48 8b 10             	mov    (%rax),%rdx
  8011e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011e9:	48 39 c2             	cmp    %rax,%rdx
  8011ec:	73 17                	jae    801205 <sprintputch+0x4b>
		*b->buf++ = ch;
  8011ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f2:	48 8b 00             	mov    (%rax),%rax
  8011f5:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8011f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011fd:	48 89 0a             	mov    %rcx,(%rdx)
  801200:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801203:	88 10                	mov    %dl,(%rax)
}
  801205:	c9                   	leaveq 
  801206:	c3                   	retq   

0000000000801207 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801207:	55                   	push   %rbp
  801208:	48 89 e5             	mov    %rsp,%rbp
  80120b:	48 83 ec 50          	sub    $0x50,%rsp
  80120f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801213:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801216:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80121a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80121e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801222:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801226:	48 8b 0a             	mov    (%rdx),%rcx
  801229:	48 89 08             	mov    %rcx,(%rax)
  80122c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801230:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801234:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801238:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80123c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801240:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801244:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801247:	48 98                	cltq   
  801249:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80124d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801251:	48 01 d0             	add    %rdx,%rax
  801254:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801258:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80125f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801264:	74 06                	je     80126c <vsnprintf+0x65>
  801266:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80126a:	7f 07                	jg     801273 <vsnprintf+0x6c>
		return -E_INVAL;
  80126c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801271:	eb 2f                	jmp    8012a2 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801273:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801277:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80127b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80127f:	48 89 c6             	mov    %rax,%rsi
  801282:	48 bf ba 11 80 00 00 	movabs $0x8011ba,%rdi
  801289:	00 00 00 
  80128c:	48 b8 fc 09 80 00 00 	movabs $0x8009fc,%rax
  801293:	00 00 00 
  801296:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801298:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80129c:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80129f:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8012a2:	c9                   	leaveq 
  8012a3:	c3                   	retq   

00000000008012a4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012a4:	55                   	push   %rbp
  8012a5:	48 89 e5             	mov    %rsp,%rbp
  8012a8:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8012af:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8012b6:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8012bc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012c3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012ca:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012d1:	84 c0                	test   %al,%al
  8012d3:	74 20                	je     8012f5 <snprintf+0x51>
  8012d5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012d9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012dd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012e1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012e5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012e9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012ed:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012f1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012f5:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012fc:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801303:	00 00 00 
  801306:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80130d:	00 00 00 
  801310:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801314:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80131b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801322:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801329:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801330:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801337:	48 8b 0a             	mov    (%rdx),%rcx
  80133a:	48 89 08             	mov    %rcx,(%rax)
  80133d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801341:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801345:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801349:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80134d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801354:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80135b:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801361:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801368:	48 89 c7             	mov    %rax,%rdi
  80136b:	48 b8 07 12 80 00 00 	movabs $0x801207,%rax
  801372:	00 00 00 
  801375:	ff d0                	callq  *%rax
  801377:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80137d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801383:	c9                   	leaveq 
  801384:	c3                   	retq   

0000000000801385 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801385:	55                   	push   %rbp
  801386:	48 89 e5             	mov    %rsp,%rbp
  801389:	48 83 ec 18          	sub    $0x18,%rsp
  80138d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801391:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801398:	eb 09                	jmp    8013a3 <strlen+0x1e>
		n++;
  80139a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80139e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a7:	0f b6 00             	movzbl (%rax),%eax
  8013aa:	84 c0                	test   %al,%al
  8013ac:	75 ec                	jne    80139a <strlen+0x15>
		n++;
	return n;
  8013ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013b1:	c9                   	leaveq 
  8013b2:	c3                   	retq   

00000000008013b3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013b3:	55                   	push   %rbp
  8013b4:	48 89 e5             	mov    %rsp,%rbp
  8013b7:	48 83 ec 20          	sub    $0x20,%rsp
  8013bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013ca:	eb 0e                	jmp    8013da <strnlen+0x27>
		n++;
  8013cc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013d0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013d5:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013da:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8013df:	74 0b                	je     8013ec <strnlen+0x39>
  8013e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e5:	0f b6 00             	movzbl (%rax),%eax
  8013e8:	84 c0                	test   %al,%al
  8013ea:	75 e0                	jne    8013cc <strnlen+0x19>
		n++;
	return n;
  8013ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013ef:	c9                   	leaveq 
  8013f0:	c3                   	retq   

00000000008013f1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013f1:	55                   	push   %rbp
  8013f2:	48 89 e5             	mov    %rsp,%rbp
  8013f5:	48 83 ec 20          	sub    $0x20,%rsp
  8013f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801401:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801405:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801409:	90                   	nop
  80140a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801412:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801416:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80141a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80141e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801422:	0f b6 12             	movzbl (%rdx),%edx
  801425:	88 10                	mov    %dl,(%rax)
  801427:	0f b6 00             	movzbl (%rax),%eax
  80142a:	84 c0                	test   %al,%al
  80142c:	75 dc                	jne    80140a <strcpy+0x19>
		/* do nothing */;
	return ret;
  80142e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801432:	c9                   	leaveq 
  801433:	c3                   	retq   

0000000000801434 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801434:	55                   	push   %rbp
  801435:	48 89 e5             	mov    %rsp,%rbp
  801438:	48 83 ec 20          	sub    $0x20,%rsp
  80143c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801440:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801444:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801448:	48 89 c7             	mov    %rax,%rdi
  80144b:	48 b8 85 13 80 00 00 	movabs $0x801385,%rax
  801452:	00 00 00 
  801455:	ff d0                	callq  *%rax
  801457:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80145a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80145d:	48 63 d0             	movslq %eax,%rdx
  801460:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801464:	48 01 c2             	add    %rax,%rdx
  801467:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80146b:	48 89 c6             	mov    %rax,%rsi
  80146e:	48 89 d7             	mov    %rdx,%rdi
  801471:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  801478:	00 00 00 
  80147b:	ff d0                	callq  *%rax
	return dst;
  80147d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801481:	c9                   	leaveq 
  801482:	c3                   	retq   

0000000000801483 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801483:	55                   	push   %rbp
  801484:	48 89 e5             	mov    %rsp,%rbp
  801487:	48 83 ec 28          	sub    $0x28,%rsp
  80148b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80148f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801493:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801497:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80149b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80149f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8014a6:	00 
  8014a7:	eb 2a                	jmp    8014d3 <strncpy+0x50>
		*dst++ = *src;
  8014a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ad:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014b1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014b5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014b9:	0f b6 12             	movzbl (%rdx),%edx
  8014bc:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014c2:	0f b6 00             	movzbl (%rax),%eax
  8014c5:	84 c0                	test   %al,%al
  8014c7:	74 05                	je     8014ce <strncpy+0x4b>
			src++;
  8014c9:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014ce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014db:	72 cc                	jb     8014a9 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014e1:	c9                   	leaveq 
  8014e2:	c3                   	retq   

00000000008014e3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014e3:	55                   	push   %rbp
  8014e4:	48 89 e5             	mov    %rsp,%rbp
  8014e7:	48 83 ec 28          	sub    $0x28,%rsp
  8014eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014f3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8014ff:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801504:	74 3d                	je     801543 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801506:	eb 1d                	jmp    801525 <strlcpy+0x42>
			*dst++ = *src++;
  801508:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801510:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801514:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801518:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80151c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801520:	0f b6 12             	movzbl (%rdx),%edx
  801523:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801525:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80152a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80152f:	74 0b                	je     80153c <strlcpy+0x59>
  801531:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801535:	0f b6 00             	movzbl (%rax),%eax
  801538:	84 c0                	test   %al,%al
  80153a:	75 cc                	jne    801508 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80153c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801540:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801543:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801547:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154b:	48 29 c2             	sub    %rax,%rdx
  80154e:	48 89 d0             	mov    %rdx,%rax
}
  801551:	c9                   	leaveq 
  801552:	c3                   	retq   

0000000000801553 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801553:	55                   	push   %rbp
  801554:	48 89 e5             	mov    %rsp,%rbp
  801557:	48 83 ec 10          	sub    $0x10,%rsp
  80155b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80155f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801563:	eb 0a                	jmp    80156f <strcmp+0x1c>
		p++, q++;
  801565:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80156a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80156f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801573:	0f b6 00             	movzbl (%rax),%eax
  801576:	84 c0                	test   %al,%al
  801578:	74 12                	je     80158c <strcmp+0x39>
  80157a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157e:	0f b6 10             	movzbl (%rax),%edx
  801581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801585:	0f b6 00             	movzbl (%rax),%eax
  801588:	38 c2                	cmp    %al,%dl
  80158a:	74 d9                	je     801565 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80158c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801590:	0f b6 00             	movzbl (%rax),%eax
  801593:	0f b6 d0             	movzbl %al,%edx
  801596:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159a:	0f b6 00             	movzbl (%rax),%eax
  80159d:	0f b6 c0             	movzbl %al,%eax
  8015a0:	29 c2                	sub    %eax,%edx
  8015a2:	89 d0                	mov    %edx,%eax
}
  8015a4:	c9                   	leaveq 
  8015a5:	c3                   	retq   

00000000008015a6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8015a6:	55                   	push   %rbp
  8015a7:	48 89 e5             	mov    %rsp,%rbp
  8015aa:	48 83 ec 18          	sub    $0x18,%rsp
  8015ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015b6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8015ba:	eb 0f                	jmp    8015cb <strncmp+0x25>
		n--, p++, q++;
  8015bc:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015c1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015c6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8015cb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015d0:	74 1d                	je     8015ef <strncmp+0x49>
  8015d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d6:	0f b6 00             	movzbl (%rax),%eax
  8015d9:	84 c0                	test   %al,%al
  8015db:	74 12                	je     8015ef <strncmp+0x49>
  8015dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e1:	0f b6 10             	movzbl (%rax),%edx
  8015e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e8:	0f b6 00             	movzbl (%rax),%eax
  8015eb:	38 c2                	cmp    %al,%dl
  8015ed:	74 cd                	je     8015bc <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015ef:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015f4:	75 07                	jne    8015fd <strncmp+0x57>
		return 0;
  8015f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fb:	eb 18                	jmp    801615 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801601:	0f b6 00             	movzbl (%rax),%eax
  801604:	0f b6 d0             	movzbl %al,%edx
  801607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160b:	0f b6 00             	movzbl (%rax),%eax
  80160e:	0f b6 c0             	movzbl %al,%eax
  801611:	29 c2                	sub    %eax,%edx
  801613:	89 d0                	mov    %edx,%eax
}
  801615:	c9                   	leaveq 
  801616:	c3                   	retq   

0000000000801617 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801617:	55                   	push   %rbp
  801618:	48 89 e5             	mov    %rsp,%rbp
  80161b:	48 83 ec 0c          	sub    $0xc,%rsp
  80161f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801623:	89 f0                	mov    %esi,%eax
  801625:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801628:	eb 17                	jmp    801641 <strchr+0x2a>
		if (*s == c)
  80162a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162e:	0f b6 00             	movzbl (%rax),%eax
  801631:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801634:	75 06                	jne    80163c <strchr+0x25>
			return (char *) s;
  801636:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80163a:	eb 15                	jmp    801651 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80163c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801641:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801645:	0f b6 00             	movzbl (%rax),%eax
  801648:	84 c0                	test   %al,%al
  80164a:	75 de                	jne    80162a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80164c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801651:	c9                   	leaveq 
  801652:	c3                   	retq   

0000000000801653 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801653:	55                   	push   %rbp
  801654:	48 89 e5             	mov    %rsp,%rbp
  801657:	48 83 ec 0c          	sub    $0xc,%rsp
  80165b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80165f:	89 f0                	mov    %esi,%eax
  801661:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801664:	eb 13                	jmp    801679 <strfind+0x26>
		if (*s == c)
  801666:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166a:	0f b6 00             	movzbl (%rax),%eax
  80166d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801670:	75 02                	jne    801674 <strfind+0x21>
			break;
  801672:	eb 10                	jmp    801684 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801674:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801679:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80167d:	0f b6 00             	movzbl (%rax),%eax
  801680:	84 c0                	test   %al,%al
  801682:	75 e2                	jne    801666 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801684:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801688:	c9                   	leaveq 
  801689:	c3                   	retq   

000000000080168a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80168a:	55                   	push   %rbp
  80168b:	48 89 e5             	mov    %rsp,%rbp
  80168e:	48 83 ec 18          	sub    $0x18,%rsp
  801692:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801696:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801699:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80169d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016a2:	75 06                	jne    8016aa <memset+0x20>
		return v;
  8016a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a8:	eb 69                	jmp    801713 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8016aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ae:	83 e0 03             	and    $0x3,%eax
  8016b1:	48 85 c0             	test   %rax,%rax
  8016b4:	75 48                	jne    8016fe <memset+0x74>
  8016b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ba:	83 e0 03             	and    $0x3,%eax
  8016bd:	48 85 c0             	test   %rax,%rax
  8016c0:	75 3c                	jne    8016fe <memset+0x74>
		c &= 0xFF;
  8016c2:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8016c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016cc:	c1 e0 18             	shl    $0x18,%eax
  8016cf:	89 c2                	mov    %eax,%edx
  8016d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016d4:	c1 e0 10             	shl    $0x10,%eax
  8016d7:	09 c2                	or     %eax,%edx
  8016d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016dc:	c1 e0 08             	shl    $0x8,%eax
  8016df:	09 d0                	or     %edx,%eax
  8016e1:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8016e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e8:	48 c1 e8 02          	shr    $0x2,%rax
  8016ec:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016f6:	48 89 d7             	mov    %rdx,%rdi
  8016f9:	fc                   	cld    
  8016fa:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016fc:	eb 11                	jmp    80170f <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8016fe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801702:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801705:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801709:	48 89 d7             	mov    %rdx,%rdi
  80170c:	fc                   	cld    
  80170d:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80170f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801713:	c9                   	leaveq 
  801714:	c3                   	retq   

0000000000801715 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801715:	55                   	push   %rbp
  801716:	48 89 e5             	mov    %rsp,%rbp
  801719:	48 83 ec 28          	sub    $0x28,%rsp
  80171d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801721:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801725:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801729:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80172d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801731:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801735:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801739:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80173d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801741:	0f 83 88 00 00 00    	jae    8017cf <memmove+0xba>
  801747:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80174f:	48 01 d0             	add    %rdx,%rax
  801752:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801756:	76 77                	jbe    8017cf <memmove+0xba>
		s += n;
  801758:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801760:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801764:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801768:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80176c:	83 e0 03             	and    $0x3,%eax
  80176f:	48 85 c0             	test   %rax,%rax
  801772:	75 3b                	jne    8017af <memmove+0x9a>
  801774:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801778:	83 e0 03             	and    $0x3,%eax
  80177b:	48 85 c0             	test   %rax,%rax
  80177e:	75 2f                	jne    8017af <memmove+0x9a>
  801780:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801784:	83 e0 03             	and    $0x3,%eax
  801787:	48 85 c0             	test   %rax,%rax
  80178a:	75 23                	jne    8017af <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80178c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801790:	48 83 e8 04          	sub    $0x4,%rax
  801794:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801798:	48 83 ea 04          	sub    $0x4,%rdx
  80179c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017a0:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8017a4:	48 89 c7             	mov    %rax,%rdi
  8017a7:	48 89 d6             	mov    %rdx,%rsi
  8017aa:	fd                   	std    
  8017ab:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017ad:	eb 1d                	jmp    8017cc <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8017af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017bb:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c3:	48 89 d7             	mov    %rdx,%rdi
  8017c6:	48 89 c1             	mov    %rax,%rcx
  8017c9:	fd                   	std    
  8017ca:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017cc:	fc                   	cld    
  8017cd:	eb 57                	jmp    801826 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017d3:	83 e0 03             	and    $0x3,%eax
  8017d6:	48 85 c0             	test   %rax,%rax
  8017d9:	75 36                	jne    801811 <memmove+0xfc>
  8017db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017df:	83 e0 03             	and    $0x3,%eax
  8017e2:	48 85 c0             	test   %rax,%rax
  8017e5:	75 2a                	jne    801811 <memmove+0xfc>
  8017e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017eb:	83 e0 03             	and    $0x3,%eax
  8017ee:	48 85 c0             	test   %rax,%rax
  8017f1:	75 1e                	jne    801811 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f7:	48 c1 e8 02          	shr    $0x2,%rax
  8017fb:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8017fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801802:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801806:	48 89 c7             	mov    %rax,%rdi
  801809:	48 89 d6             	mov    %rdx,%rsi
  80180c:	fc                   	cld    
  80180d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80180f:	eb 15                	jmp    801826 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801811:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801815:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801819:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80181d:	48 89 c7             	mov    %rax,%rdi
  801820:	48 89 d6             	mov    %rdx,%rsi
  801823:	fc                   	cld    
  801824:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801826:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80182a:	c9                   	leaveq 
  80182b:	c3                   	retq   

000000000080182c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80182c:	55                   	push   %rbp
  80182d:	48 89 e5             	mov    %rsp,%rbp
  801830:	48 83 ec 18          	sub    $0x18,%rsp
  801834:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801838:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80183c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801840:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801844:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801848:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80184c:	48 89 ce             	mov    %rcx,%rsi
  80184f:	48 89 c7             	mov    %rax,%rdi
  801852:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  801859:	00 00 00 
  80185c:	ff d0                	callq  *%rax
}
  80185e:	c9                   	leaveq 
  80185f:	c3                   	retq   

0000000000801860 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801860:	55                   	push   %rbp
  801861:	48 89 e5             	mov    %rsp,%rbp
  801864:	48 83 ec 28          	sub    $0x28,%rsp
  801868:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80186c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801870:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801878:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80187c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801880:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801884:	eb 36                	jmp    8018bc <memcmp+0x5c>
		if (*s1 != *s2)
  801886:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80188a:	0f b6 10             	movzbl (%rax),%edx
  80188d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801891:	0f b6 00             	movzbl (%rax),%eax
  801894:	38 c2                	cmp    %al,%dl
  801896:	74 1a                	je     8018b2 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801898:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80189c:	0f b6 00             	movzbl (%rax),%eax
  80189f:	0f b6 d0             	movzbl %al,%edx
  8018a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a6:	0f b6 00             	movzbl (%rax),%eax
  8018a9:	0f b6 c0             	movzbl %al,%eax
  8018ac:	29 c2                	sub    %eax,%edx
  8018ae:	89 d0                	mov    %edx,%eax
  8018b0:	eb 20                	jmp    8018d2 <memcmp+0x72>
		s1++, s2++;
  8018b2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018b7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018c8:	48 85 c0             	test   %rax,%rax
  8018cb:	75 b9                	jne    801886 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d2:	c9                   	leaveq 
  8018d3:	c3                   	retq   

00000000008018d4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018d4:	55                   	push   %rbp
  8018d5:	48 89 e5             	mov    %rsp,%rbp
  8018d8:	48 83 ec 28          	sub    $0x28,%rsp
  8018dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018e0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8018e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018ef:	48 01 d0             	add    %rdx,%rax
  8018f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018f6:	eb 15                	jmp    80190d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018fc:	0f b6 10             	movzbl (%rax),%edx
  8018ff:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801902:	38 c2                	cmp    %al,%dl
  801904:	75 02                	jne    801908 <memfind+0x34>
			break;
  801906:	eb 0f                	jmp    801917 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801908:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80190d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801911:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801915:	72 e1                	jb     8018f8 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80191b:	c9                   	leaveq 
  80191c:	c3                   	retq   

000000000080191d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80191d:	55                   	push   %rbp
  80191e:	48 89 e5             	mov    %rsp,%rbp
  801921:	48 83 ec 34          	sub    $0x34,%rsp
  801925:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801929:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80192d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801930:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801937:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80193e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80193f:	eb 05                	jmp    801946 <strtol+0x29>
		s++;
  801941:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801946:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194a:	0f b6 00             	movzbl (%rax),%eax
  80194d:	3c 20                	cmp    $0x20,%al
  80194f:	74 f0                	je     801941 <strtol+0x24>
  801951:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801955:	0f b6 00             	movzbl (%rax),%eax
  801958:	3c 09                	cmp    $0x9,%al
  80195a:	74 e5                	je     801941 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80195c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801960:	0f b6 00             	movzbl (%rax),%eax
  801963:	3c 2b                	cmp    $0x2b,%al
  801965:	75 07                	jne    80196e <strtol+0x51>
		s++;
  801967:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80196c:	eb 17                	jmp    801985 <strtol+0x68>
	else if (*s == '-')
  80196e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801972:	0f b6 00             	movzbl (%rax),%eax
  801975:	3c 2d                	cmp    $0x2d,%al
  801977:	75 0c                	jne    801985 <strtol+0x68>
		s++, neg = 1;
  801979:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80197e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801985:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801989:	74 06                	je     801991 <strtol+0x74>
  80198b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80198f:	75 28                	jne    8019b9 <strtol+0x9c>
  801991:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801995:	0f b6 00             	movzbl (%rax),%eax
  801998:	3c 30                	cmp    $0x30,%al
  80199a:	75 1d                	jne    8019b9 <strtol+0x9c>
  80199c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a0:	48 83 c0 01          	add    $0x1,%rax
  8019a4:	0f b6 00             	movzbl (%rax),%eax
  8019a7:	3c 78                	cmp    $0x78,%al
  8019a9:	75 0e                	jne    8019b9 <strtol+0x9c>
		s += 2, base = 16;
  8019ab:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8019b0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8019b7:	eb 2c                	jmp    8019e5 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8019b9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019bd:	75 19                	jne    8019d8 <strtol+0xbb>
  8019bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c3:	0f b6 00             	movzbl (%rax),%eax
  8019c6:	3c 30                	cmp    $0x30,%al
  8019c8:	75 0e                	jne    8019d8 <strtol+0xbb>
		s++, base = 8;
  8019ca:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019cf:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8019d6:	eb 0d                	jmp    8019e5 <strtol+0xc8>
	else if (base == 0)
  8019d8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019dc:	75 07                	jne    8019e5 <strtol+0xc8>
		base = 10;
  8019de:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e9:	0f b6 00             	movzbl (%rax),%eax
  8019ec:	3c 2f                	cmp    $0x2f,%al
  8019ee:	7e 1d                	jle    801a0d <strtol+0xf0>
  8019f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f4:	0f b6 00             	movzbl (%rax),%eax
  8019f7:	3c 39                	cmp    $0x39,%al
  8019f9:	7f 12                	jg     801a0d <strtol+0xf0>
			dig = *s - '0';
  8019fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ff:	0f b6 00             	movzbl (%rax),%eax
  801a02:	0f be c0             	movsbl %al,%eax
  801a05:	83 e8 30             	sub    $0x30,%eax
  801a08:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a0b:	eb 4e                	jmp    801a5b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a11:	0f b6 00             	movzbl (%rax),%eax
  801a14:	3c 60                	cmp    $0x60,%al
  801a16:	7e 1d                	jle    801a35 <strtol+0x118>
  801a18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1c:	0f b6 00             	movzbl (%rax),%eax
  801a1f:	3c 7a                	cmp    $0x7a,%al
  801a21:	7f 12                	jg     801a35 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a27:	0f b6 00             	movzbl (%rax),%eax
  801a2a:	0f be c0             	movsbl %al,%eax
  801a2d:	83 e8 57             	sub    $0x57,%eax
  801a30:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a33:	eb 26                	jmp    801a5b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a39:	0f b6 00             	movzbl (%rax),%eax
  801a3c:	3c 40                	cmp    $0x40,%al
  801a3e:	7e 48                	jle    801a88 <strtol+0x16b>
  801a40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a44:	0f b6 00             	movzbl (%rax),%eax
  801a47:	3c 5a                	cmp    $0x5a,%al
  801a49:	7f 3d                	jg     801a88 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4f:	0f b6 00             	movzbl (%rax),%eax
  801a52:	0f be c0             	movsbl %al,%eax
  801a55:	83 e8 37             	sub    $0x37,%eax
  801a58:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a5b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a5e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a61:	7c 02                	jl     801a65 <strtol+0x148>
			break;
  801a63:	eb 23                	jmp    801a88 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a65:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a6a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a6d:	48 98                	cltq   
  801a6f:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a74:	48 89 c2             	mov    %rax,%rdx
  801a77:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a7a:	48 98                	cltq   
  801a7c:	48 01 d0             	add    %rdx,%rax
  801a7f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a83:	e9 5d ff ff ff       	jmpq   8019e5 <strtol+0xc8>

	if (endptr)
  801a88:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a8d:	74 0b                	je     801a9a <strtol+0x17d>
		*endptr = (char *) s;
  801a8f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a93:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a97:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a9e:	74 09                	je     801aa9 <strtol+0x18c>
  801aa0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aa4:	48 f7 d8             	neg    %rax
  801aa7:	eb 04                	jmp    801aad <strtol+0x190>
  801aa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801aad:	c9                   	leaveq 
  801aae:	c3                   	retq   

0000000000801aaf <strstr>:

char * strstr(const char *in, const char *str)
{
  801aaf:	55                   	push   %rbp
  801ab0:	48 89 e5             	mov    %rsp,%rbp
  801ab3:	48 83 ec 30          	sub    $0x30,%rsp
  801ab7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801abb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801abf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ac3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ac7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801acb:	0f b6 00             	movzbl (%rax),%eax
  801ace:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801ad1:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801ad5:	75 06                	jne    801add <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801ad7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801adb:	eb 6b                	jmp    801b48 <strstr+0x99>

    len = strlen(str);
  801add:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ae1:	48 89 c7             	mov    %rax,%rdi
  801ae4:	48 b8 85 13 80 00 00 	movabs $0x801385,%rax
  801aeb:	00 00 00 
  801aee:	ff d0                	callq  *%rax
  801af0:	48 98                	cltq   
  801af2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801af6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801afa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801afe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b02:	0f b6 00             	movzbl (%rax),%eax
  801b05:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801b08:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b0c:	75 07                	jne    801b15 <strstr+0x66>
                return (char *) 0;
  801b0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b13:	eb 33                	jmp    801b48 <strstr+0x99>
        } while (sc != c);
  801b15:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b19:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b1c:	75 d8                	jne    801af6 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801b1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b22:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b2a:	48 89 ce             	mov    %rcx,%rsi
  801b2d:	48 89 c7             	mov    %rax,%rdi
  801b30:	48 b8 a6 15 80 00 00 	movabs $0x8015a6,%rax
  801b37:	00 00 00 
  801b3a:	ff d0                	callq  *%rax
  801b3c:	85 c0                	test   %eax,%eax
  801b3e:	75 b6                	jne    801af6 <strstr+0x47>

    return (char *) (in - 1);
  801b40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b44:	48 83 e8 01          	sub    $0x1,%rax
}
  801b48:	c9                   	leaveq 
  801b49:	c3                   	retq   

0000000000801b4a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b4a:	55                   	push   %rbp
  801b4b:	48 89 e5             	mov    %rsp,%rbp
  801b4e:	53                   	push   %rbx
  801b4f:	48 83 ec 48          	sub    $0x48,%rsp
  801b53:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b56:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b59:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b5d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b61:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b65:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b69:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b6c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b70:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b74:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b78:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b7c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b80:	4c 89 c3             	mov    %r8,%rbx
  801b83:	cd 30                	int    $0x30
  801b85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801b89:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b8d:	74 3e                	je     801bcd <syscall+0x83>
  801b8f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b94:	7e 37                	jle    801bcd <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b96:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b9a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b9d:	49 89 d0             	mov    %rdx,%r8
  801ba0:	89 c1                	mov    %eax,%ecx
  801ba2:	48 ba 60 3d 80 00 00 	movabs $0x803d60,%rdx
  801ba9:	00 00 00 
  801bac:	be 23 00 00 00       	mov    $0x23,%esi
  801bb1:	48 bf 7d 3d 80 00 00 	movabs $0x803d7d,%rdi
  801bb8:	00 00 00 
  801bbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc0:	49 b9 10 04 80 00 00 	movabs $0x800410,%r9
  801bc7:	00 00 00 
  801bca:	41 ff d1             	callq  *%r9

	return ret;
  801bcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bd1:	48 83 c4 48          	add    $0x48,%rsp
  801bd5:	5b                   	pop    %rbx
  801bd6:	5d                   	pop    %rbp
  801bd7:	c3                   	retq   

0000000000801bd8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801bd8:	55                   	push   %rbp
  801bd9:	48 89 e5             	mov    %rsp,%rbp
  801bdc:	48 83 ec 20          	sub    $0x20,%rsp
  801be0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801be4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801be8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf7:	00 
  801bf8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bfe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c04:	48 89 d1             	mov    %rdx,%rcx
  801c07:	48 89 c2             	mov    %rax,%rdx
  801c0a:	be 00 00 00 00       	mov    $0x0,%esi
  801c0f:	bf 00 00 00 00       	mov    $0x0,%edi
  801c14:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  801c1b:	00 00 00 
  801c1e:	ff d0                	callq  *%rax
}
  801c20:	c9                   	leaveq 
  801c21:	c3                   	retq   

0000000000801c22 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c22:	55                   	push   %rbp
  801c23:	48 89 e5             	mov    %rsp,%rbp
  801c26:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c2a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c31:	00 
  801c32:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c38:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c3e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c43:	ba 00 00 00 00       	mov    $0x0,%edx
  801c48:	be 00 00 00 00       	mov    $0x0,%esi
  801c4d:	bf 01 00 00 00       	mov    $0x1,%edi
  801c52:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  801c59:	00 00 00 
  801c5c:	ff d0                	callq  *%rax
}
  801c5e:	c9                   	leaveq 
  801c5f:	c3                   	retq   

0000000000801c60 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c60:	55                   	push   %rbp
  801c61:	48 89 e5             	mov    %rsp,%rbp
  801c64:	48 83 ec 10          	sub    $0x10,%rsp
  801c68:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c6e:	48 98                	cltq   
  801c70:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c77:	00 
  801c78:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c7e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c84:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c89:	48 89 c2             	mov    %rax,%rdx
  801c8c:	be 01 00 00 00       	mov    $0x1,%esi
  801c91:	bf 03 00 00 00       	mov    $0x3,%edi
  801c96:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  801c9d:	00 00 00 
  801ca0:	ff d0                	callq  *%rax
}
  801ca2:	c9                   	leaveq 
  801ca3:	c3                   	retq   

0000000000801ca4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ca4:	55                   	push   %rbp
  801ca5:	48 89 e5             	mov    %rsp,%rbp
  801ca8:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801cac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb3:	00 
  801cb4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cc5:	ba 00 00 00 00       	mov    $0x0,%edx
  801cca:	be 00 00 00 00       	mov    $0x0,%esi
  801ccf:	bf 02 00 00 00       	mov    $0x2,%edi
  801cd4:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  801cdb:	00 00 00 
  801cde:	ff d0                	callq  *%rax
}
  801ce0:	c9                   	leaveq 
  801ce1:	c3                   	retq   

0000000000801ce2 <sys_yield>:

void
sys_yield(void)
{
  801ce2:	55                   	push   %rbp
  801ce3:	48 89 e5             	mov    %rsp,%rbp
  801ce6:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801cea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf1:	00 
  801cf2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cfe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d03:	ba 00 00 00 00       	mov    $0x0,%edx
  801d08:	be 00 00 00 00       	mov    $0x0,%esi
  801d0d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d12:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  801d19:	00 00 00 
  801d1c:	ff d0                	callq  *%rax
}
  801d1e:	c9                   	leaveq 
  801d1f:	c3                   	retq   

0000000000801d20 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d20:	55                   	push   %rbp
  801d21:	48 89 e5             	mov    %rsp,%rbp
  801d24:	48 83 ec 20          	sub    $0x20,%rsp
  801d28:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d2f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d32:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d35:	48 63 c8             	movslq %eax,%rcx
  801d38:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d3f:	48 98                	cltq   
  801d41:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d48:	00 
  801d49:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d4f:	49 89 c8             	mov    %rcx,%r8
  801d52:	48 89 d1             	mov    %rdx,%rcx
  801d55:	48 89 c2             	mov    %rax,%rdx
  801d58:	be 01 00 00 00       	mov    $0x1,%esi
  801d5d:	bf 04 00 00 00       	mov    $0x4,%edi
  801d62:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  801d69:	00 00 00 
  801d6c:	ff d0                	callq  *%rax
}
  801d6e:	c9                   	leaveq 
  801d6f:	c3                   	retq   

0000000000801d70 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d70:	55                   	push   %rbp
  801d71:	48 89 e5             	mov    %rsp,%rbp
  801d74:	48 83 ec 30          	sub    $0x30,%rsp
  801d78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d7f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d82:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d86:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d8a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d8d:	48 63 c8             	movslq %eax,%rcx
  801d90:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d94:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d97:	48 63 f0             	movslq %eax,%rsi
  801d9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da1:	48 98                	cltq   
  801da3:	48 89 0c 24          	mov    %rcx,(%rsp)
  801da7:	49 89 f9             	mov    %rdi,%r9
  801daa:	49 89 f0             	mov    %rsi,%r8
  801dad:	48 89 d1             	mov    %rdx,%rcx
  801db0:	48 89 c2             	mov    %rax,%rdx
  801db3:	be 01 00 00 00       	mov    $0x1,%esi
  801db8:	bf 05 00 00 00       	mov    $0x5,%edi
  801dbd:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  801dc4:	00 00 00 
  801dc7:	ff d0                	callq  *%rax
}
  801dc9:	c9                   	leaveq 
  801dca:	c3                   	retq   

0000000000801dcb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801dcb:	55                   	push   %rbp
  801dcc:	48 89 e5             	mov    %rsp,%rbp
  801dcf:	48 83 ec 20          	sub    $0x20,%rsp
  801dd3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dd6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801dda:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801de1:	48 98                	cltq   
  801de3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dea:	00 
  801deb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801df1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801df7:	48 89 d1             	mov    %rdx,%rcx
  801dfa:	48 89 c2             	mov    %rax,%rdx
  801dfd:	be 01 00 00 00       	mov    $0x1,%esi
  801e02:	bf 06 00 00 00       	mov    $0x6,%edi
  801e07:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  801e0e:	00 00 00 
  801e11:	ff d0                	callq  *%rax
}
  801e13:	c9                   	leaveq 
  801e14:	c3                   	retq   

0000000000801e15 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e15:	55                   	push   %rbp
  801e16:	48 89 e5             	mov    %rsp,%rbp
  801e19:	48 83 ec 10          	sub    $0x10,%rsp
  801e1d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e20:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e23:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e26:	48 63 d0             	movslq %eax,%rdx
  801e29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e2c:	48 98                	cltq   
  801e2e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e35:	00 
  801e36:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e3c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e42:	48 89 d1             	mov    %rdx,%rcx
  801e45:	48 89 c2             	mov    %rax,%rdx
  801e48:	be 01 00 00 00       	mov    $0x1,%esi
  801e4d:	bf 08 00 00 00       	mov    $0x8,%edi
  801e52:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  801e59:	00 00 00 
  801e5c:	ff d0                	callq  *%rax
}
  801e5e:	c9                   	leaveq 
  801e5f:	c3                   	retq   

0000000000801e60 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e60:	55                   	push   %rbp
  801e61:	48 89 e5             	mov    %rsp,%rbp
  801e64:	48 83 ec 20          	sub    $0x20,%rsp
  801e68:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e6b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e6f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e76:	48 98                	cltq   
  801e78:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e7f:	00 
  801e80:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e86:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e8c:	48 89 d1             	mov    %rdx,%rcx
  801e8f:	48 89 c2             	mov    %rax,%rdx
  801e92:	be 01 00 00 00       	mov    $0x1,%esi
  801e97:	bf 09 00 00 00       	mov    $0x9,%edi
  801e9c:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  801ea3:	00 00 00 
  801ea6:	ff d0                	callq  *%rax
}
  801ea8:	c9                   	leaveq 
  801ea9:	c3                   	retq   

0000000000801eaa <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801eaa:	55                   	push   %rbp
  801eab:	48 89 e5             	mov    %rsp,%rbp
  801eae:	48 83 ec 20          	sub    $0x20,%rsp
  801eb2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801eb5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801eb9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ebd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec0:	48 98                	cltq   
  801ec2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ec9:	00 
  801eca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ed0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ed6:	48 89 d1             	mov    %rdx,%rcx
  801ed9:	48 89 c2             	mov    %rax,%rdx
  801edc:	be 01 00 00 00       	mov    $0x1,%esi
  801ee1:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ee6:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  801eed:	00 00 00 
  801ef0:	ff d0                	callq  *%rax
}
  801ef2:	c9                   	leaveq 
  801ef3:	c3                   	retq   

0000000000801ef4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ef4:	55                   	push   %rbp
  801ef5:	48 89 e5             	mov    %rsp,%rbp
  801ef8:	48 83 ec 20          	sub    $0x20,%rsp
  801efc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801eff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f03:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f07:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f0a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f0d:	48 63 f0             	movslq %eax,%rsi
  801f10:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f17:	48 98                	cltq   
  801f19:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f1d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f24:	00 
  801f25:	49 89 f1             	mov    %rsi,%r9
  801f28:	49 89 c8             	mov    %rcx,%r8
  801f2b:	48 89 d1             	mov    %rdx,%rcx
  801f2e:	48 89 c2             	mov    %rax,%rdx
  801f31:	be 00 00 00 00       	mov    $0x0,%esi
  801f36:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f3b:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  801f42:	00 00 00 
  801f45:	ff d0                	callq  *%rax
}
  801f47:	c9                   	leaveq 
  801f48:	c3                   	retq   

0000000000801f49 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f49:	55                   	push   %rbp
  801f4a:	48 89 e5             	mov    %rsp,%rbp
  801f4d:	48 83 ec 10          	sub    $0x10,%rsp
  801f51:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f59:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f60:	00 
  801f61:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f67:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f72:	48 89 c2             	mov    %rax,%rdx
  801f75:	be 01 00 00 00       	mov    $0x1,%esi
  801f7a:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f7f:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  801f86:	00 00 00 
  801f89:	ff d0                	callq  *%rax
}
  801f8b:	c9                   	leaveq 
  801f8c:	c3                   	retq   

0000000000801f8d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801f8d:	55                   	push   %rbp
  801f8e:	48 89 e5             	mov    %rsp,%rbp
  801f91:	48 83 ec 08          	sub    $0x8,%rsp
  801f95:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f99:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f9d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801fa4:	ff ff ff 
  801fa7:	48 01 d0             	add    %rdx,%rax
  801faa:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801fae:	c9                   	leaveq 
  801faf:	c3                   	retq   

0000000000801fb0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801fb0:	55                   	push   %rbp
  801fb1:	48 89 e5             	mov    %rsp,%rbp
  801fb4:	48 83 ec 08          	sub    $0x8,%rsp
  801fb8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801fbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc0:	48 89 c7             	mov    %rax,%rdi
  801fc3:	48 b8 8d 1f 80 00 00 	movabs $0x801f8d,%rax
  801fca:	00 00 00 
  801fcd:	ff d0                	callq  *%rax
  801fcf:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801fd5:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801fd9:	c9                   	leaveq 
  801fda:	c3                   	retq   

0000000000801fdb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801fdb:	55                   	push   %rbp
  801fdc:	48 89 e5             	mov    %rsp,%rbp
  801fdf:	48 83 ec 18          	sub    $0x18,%rsp
  801fe3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801fe7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fee:	eb 6b                	jmp    80205b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ff0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ff3:	48 98                	cltq   
  801ff5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ffb:	48 c1 e0 0c          	shl    $0xc,%rax
  801fff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802003:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802007:	48 c1 e8 15          	shr    $0x15,%rax
  80200b:	48 89 c2             	mov    %rax,%rdx
  80200e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802015:	01 00 00 
  802018:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80201c:	83 e0 01             	and    $0x1,%eax
  80201f:	48 85 c0             	test   %rax,%rax
  802022:	74 21                	je     802045 <fd_alloc+0x6a>
  802024:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802028:	48 c1 e8 0c          	shr    $0xc,%rax
  80202c:	48 89 c2             	mov    %rax,%rdx
  80202f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802036:	01 00 00 
  802039:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80203d:	83 e0 01             	and    $0x1,%eax
  802040:	48 85 c0             	test   %rax,%rax
  802043:	75 12                	jne    802057 <fd_alloc+0x7c>
			*fd_store = fd;
  802045:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802049:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80204d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802050:	b8 00 00 00 00       	mov    $0x0,%eax
  802055:	eb 1a                	jmp    802071 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802057:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80205b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80205f:	7e 8f                	jle    801ff0 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802065:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80206c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802071:	c9                   	leaveq 
  802072:	c3                   	retq   

0000000000802073 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802073:	55                   	push   %rbp
  802074:	48 89 e5             	mov    %rsp,%rbp
  802077:	48 83 ec 20          	sub    $0x20,%rsp
  80207b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80207e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802082:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802086:	78 06                	js     80208e <fd_lookup+0x1b>
  802088:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80208c:	7e 07                	jle    802095 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80208e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802093:	eb 6c                	jmp    802101 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802095:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802098:	48 98                	cltq   
  80209a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020a0:	48 c1 e0 0c          	shl    $0xc,%rax
  8020a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8020a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020ac:	48 c1 e8 15          	shr    $0x15,%rax
  8020b0:	48 89 c2             	mov    %rax,%rdx
  8020b3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020ba:	01 00 00 
  8020bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020c1:	83 e0 01             	and    $0x1,%eax
  8020c4:	48 85 c0             	test   %rax,%rax
  8020c7:	74 21                	je     8020ea <fd_lookup+0x77>
  8020c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020cd:	48 c1 e8 0c          	shr    $0xc,%rax
  8020d1:	48 89 c2             	mov    %rax,%rdx
  8020d4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020db:	01 00 00 
  8020de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e2:	83 e0 01             	and    $0x1,%eax
  8020e5:	48 85 c0             	test   %rax,%rax
  8020e8:	75 07                	jne    8020f1 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8020ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020ef:	eb 10                	jmp    802101 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8020f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020f9:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8020fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802101:	c9                   	leaveq 
  802102:	c3                   	retq   

0000000000802103 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802103:	55                   	push   %rbp
  802104:	48 89 e5             	mov    %rsp,%rbp
  802107:	48 83 ec 30          	sub    $0x30,%rsp
  80210b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80210f:	89 f0                	mov    %esi,%eax
  802111:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802114:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802118:	48 89 c7             	mov    %rax,%rdi
  80211b:	48 b8 8d 1f 80 00 00 	movabs $0x801f8d,%rax
  802122:	00 00 00 
  802125:	ff d0                	callq  *%rax
  802127:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80212b:	48 89 d6             	mov    %rdx,%rsi
  80212e:	89 c7                	mov    %eax,%edi
  802130:	48 b8 73 20 80 00 00 	movabs $0x802073,%rax
  802137:	00 00 00 
  80213a:	ff d0                	callq  *%rax
  80213c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80213f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802143:	78 0a                	js     80214f <fd_close+0x4c>
	    || fd != fd2)
  802145:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802149:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80214d:	74 12                	je     802161 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80214f:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802153:	74 05                	je     80215a <fd_close+0x57>
  802155:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802158:	eb 05                	jmp    80215f <fd_close+0x5c>
  80215a:	b8 00 00 00 00       	mov    $0x0,%eax
  80215f:	eb 69                	jmp    8021ca <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802161:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802165:	8b 00                	mov    (%rax),%eax
  802167:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80216b:	48 89 d6             	mov    %rdx,%rsi
  80216e:	89 c7                	mov    %eax,%edi
  802170:	48 b8 cc 21 80 00 00 	movabs $0x8021cc,%rax
  802177:	00 00 00 
  80217a:	ff d0                	callq  *%rax
  80217c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80217f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802183:	78 2a                	js     8021af <fd_close+0xac>
		if (dev->dev_close)
  802185:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802189:	48 8b 40 20          	mov    0x20(%rax),%rax
  80218d:	48 85 c0             	test   %rax,%rax
  802190:	74 16                	je     8021a8 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802192:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802196:	48 8b 40 20          	mov    0x20(%rax),%rax
  80219a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80219e:	48 89 d7             	mov    %rdx,%rdi
  8021a1:	ff d0                	callq  *%rax
  8021a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021a6:	eb 07                	jmp    8021af <fd_close+0xac>
		else
			r = 0;
  8021a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8021af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021b3:	48 89 c6             	mov    %rax,%rsi
  8021b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8021bb:	48 b8 cb 1d 80 00 00 	movabs $0x801dcb,%rax
  8021c2:	00 00 00 
  8021c5:	ff d0                	callq  *%rax
	return r;
  8021c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021ca:	c9                   	leaveq 
  8021cb:	c3                   	retq   

00000000008021cc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8021cc:	55                   	push   %rbp
  8021cd:	48 89 e5             	mov    %rsp,%rbp
  8021d0:	48 83 ec 20          	sub    $0x20,%rsp
  8021d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8021db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021e2:	eb 41                	jmp    802225 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8021e4:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8021eb:	00 00 00 
  8021ee:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021f1:	48 63 d2             	movslq %edx,%rdx
  8021f4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f8:	8b 00                	mov    (%rax),%eax
  8021fa:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8021fd:	75 22                	jne    802221 <dev_lookup+0x55>
			*dev = devtab[i];
  8021ff:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802206:	00 00 00 
  802209:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80220c:	48 63 d2             	movslq %edx,%rdx
  80220f:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802213:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802217:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80221a:	b8 00 00 00 00       	mov    $0x0,%eax
  80221f:	eb 60                	jmp    802281 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802221:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802225:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80222c:	00 00 00 
  80222f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802232:	48 63 d2             	movslq %edx,%rdx
  802235:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802239:	48 85 c0             	test   %rax,%rax
  80223c:	75 a6                	jne    8021e4 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80223e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802245:	00 00 00 
  802248:	48 8b 00             	mov    (%rax),%rax
  80224b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802251:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802254:	89 c6                	mov    %eax,%esi
  802256:	48 bf 90 3d 80 00 00 	movabs $0x803d90,%rdi
  80225d:	00 00 00 
  802260:	b8 00 00 00 00       	mov    $0x0,%eax
  802265:	48 b9 49 06 80 00 00 	movabs $0x800649,%rcx
  80226c:	00 00 00 
  80226f:	ff d1                	callq  *%rcx
	*dev = 0;
  802271:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802275:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80227c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802281:	c9                   	leaveq 
  802282:	c3                   	retq   

0000000000802283 <close>:

int
close(int fdnum)
{
  802283:	55                   	push   %rbp
  802284:	48 89 e5             	mov    %rsp,%rbp
  802287:	48 83 ec 20          	sub    $0x20,%rsp
  80228b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80228e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802292:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802295:	48 89 d6             	mov    %rdx,%rsi
  802298:	89 c7                	mov    %eax,%edi
  80229a:	48 b8 73 20 80 00 00 	movabs $0x802073,%rax
  8022a1:	00 00 00 
  8022a4:	ff d0                	callq  *%rax
  8022a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ad:	79 05                	jns    8022b4 <close+0x31>
		return r;
  8022af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b2:	eb 18                	jmp    8022cc <close+0x49>
	else
		return fd_close(fd, 1);
  8022b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022b8:	be 01 00 00 00       	mov    $0x1,%esi
  8022bd:	48 89 c7             	mov    %rax,%rdi
  8022c0:	48 b8 03 21 80 00 00 	movabs $0x802103,%rax
  8022c7:	00 00 00 
  8022ca:	ff d0                	callq  *%rax
}
  8022cc:	c9                   	leaveq 
  8022cd:	c3                   	retq   

00000000008022ce <close_all>:

void
close_all(void)
{
  8022ce:	55                   	push   %rbp
  8022cf:	48 89 e5             	mov    %rsp,%rbp
  8022d2:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8022d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022dd:	eb 15                	jmp    8022f4 <close_all+0x26>
		close(i);
  8022df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e2:	89 c7                	mov    %eax,%edi
  8022e4:	48 b8 83 22 80 00 00 	movabs $0x802283,%rax
  8022eb:	00 00 00 
  8022ee:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8022f0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022f4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8022f8:	7e e5                	jle    8022df <close_all+0x11>
		close(i);
}
  8022fa:	c9                   	leaveq 
  8022fb:	c3                   	retq   

00000000008022fc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8022fc:	55                   	push   %rbp
  8022fd:	48 89 e5             	mov    %rsp,%rbp
  802300:	48 83 ec 40          	sub    $0x40,%rsp
  802304:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802307:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80230a:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80230e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802311:	48 89 d6             	mov    %rdx,%rsi
  802314:	89 c7                	mov    %eax,%edi
  802316:	48 b8 73 20 80 00 00 	movabs $0x802073,%rax
  80231d:	00 00 00 
  802320:	ff d0                	callq  *%rax
  802322:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802325:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802329:	79 08                	jns    802333 <dup+0x37>
		return r;
  80232b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80232e:	e9 70 01 00 00       	jmpq   8024a3 <dup+0x1a7>
	close(newfdnum);
  802333:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802336:	89 c7                	mov    %eax,%edi
  802338:	48 b8 83 22 80 00 00 	movabs $0x802283,%rax
  80233f:	00 00 00 
  802342:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802344:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802347:	48 98                	cltq   
  802349:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80234f:	48 c1 e0 0c          	shl    $0xc,%rax
  802353:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802357:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80235b:	48 89 c7             	mov    %rax,%rdi
  80235e:	48 b8 b0 1f 80 00 00 	movabs $0x801fb0,%rax
  802365:	00 00 00 
  802368:	ff d0                	callq  *%rax
  80236a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80236e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802372:	48 89 c7             	mov    %rax,%rdi
  802375:	48 b8 b0 1f 80 00 00 	movabs $0x801fb0,%rax
  80237c:	00 00 00 
  80237f:	ff d0                	callq  *%rax
  802381:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802389:	48 c1 e8 15          	shr    $0x15,%rax
  80238d:	48 89 c2             	mov    %rax,%rdx
  802390:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802397:	01 00 00 
  80239a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80239e:	83 e0 01             	and    $0x1,%eax
  8023a1:	48 85 c0             	test   %rax,%rax
  8023a4:	74 73                	je     802419 <dup+0x11d>
  8023a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023aa:	48 c1 e8 0c          	shr    $0xc,%rax
  8023ae:	48 89 c2             	mov    %rax,%rdx
  8023b1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023b8:	01 00 00 
  8023bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023bf:	83 e0 01             	and    $0x1,%eax
  8023c2:	48 85 c0             	test   %rax,%rax
  8023c5:	74 52                	je     802419 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8023c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cb:	48 c1 e8 0c          	shr    $0xc,%rax
  8023cf:	48 89 c2             	mov    %rax,%rdx
  8023d2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023d9:	01 00 00 
  8023dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023e0:	25 07 0e 00 00       	and    $0xe07,%eax
  8023e5:	89 c1                	mov    %eax,%ecx
  8023e7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8023eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ef:	41 89 c8             	mov    %ecx,%r8d
  8023f2:	48 89 d1             	mov    %rdx,%rcx
  8023f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8023fa:	48 89 c6             	mov    %rax,%rsi
  8023fd:	bf 00 00 00 00       	mov    $0x0,%edi
  802402:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  802409:	00 00 00 
  80240c:	ff d0                	callq  *%rax
  80240e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802411:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802415:	79 02                	jns    802419 <dup+0x11d>
			goto err;
  802417:	eb 57                	jmp    802470 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802419:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80241d:	48 c1 e8 0c          	shr    $0xc,%rax
  802421:	48 89 c2             	mov    %rax,%rdx
  802424:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80242b:	01 00 00 
  80242e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802432:	25 07 0e 00 00       	and    $0xe07,%eax
  802437:	89 c1                	mov    %eax,%ecx
  802439:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80243d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802441:	41 89 c8             	mov    %ecx,%r8d
  802444:	48 89 d1             	mov    %rdx,%rcx
  802447:	ba 00 00 00 00       	mov    $0x0,%edx
  80244c:	48 89 c6             	mov    %rax,%rsi
  80244f:	bf 00 00 00 00       	mov    $0x0,%edi
  802454:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  80245b:	00 00 00 
  80245e:	ff d0                	callq  *%rax
  802460:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802463:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802467:	79 02                	jns    80246b <dup+0x16f>
		goto err;
  802469:	eb 05                	jmp    802470 <dup+0x174>

	return newfdnum;
  80246b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80246e:	eb 33                	jmp    8024a3 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802470:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802474:	48 89 c6             	mov    %rax,%rsi
  802477:	bf 00 00 00 00       	mov    $0x0,%edi
  80247c:	48 b8 cb 1d 80 00 00 	movabs $0x801dcb,%rax
  802483:	00 00 00 
  802486:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802488:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80248c:	48 89 c6             	mov    %rax,%rsi
  80248f:	bf 00 00 00 00       	mov    $0x0,%edi
  802494:	48 b8 cb 1d 80 00 00 	movabs $0x801dcb,%rax
  80249b:	00 00 00 
  80249e:	ff d0                	callq  *%rax
	return r;
  8024a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024a3:	c9                   	leaveq 
  8024a4:	c3                   	retq   

00000000008024a5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8024a5:	55                   	push   %rbp
  8024a6:	48 89 e5             	mov    %rsp,%rbp
  8024a9:	48 83 ec 40          	sub    $0x40,%rsp
  8024ad:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024b0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024b4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024b8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024bc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024bf:	48 89 d6             	mov    %rdx,%rsi
  8024c2:	89 c7                	mov    %eax,%edi
  8024c4:	48 b8 73 20 80 00 00 	movabs $0x802073,%rax
  8024cb:	00 00 00 
  8024ce:	ff d0                	callq  *%rax
  8024d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024d7:	78 24                	js     8024fd <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024dd:	8b 00                	mov    (%rax),%eax
  8024df:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024e3:	48 89 d6             	mov    %rdx,%rsi
  8024e6:	89 c7                	mov    %eax,%edi
  8024e8:	48 b8 cc 21 80 00 00 	movabs $0x8021cc,%rax
  8024ef:	00 00 00 
  8024f2:	ff d0                	callq  *%rax
  8024f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024fb:	79 05                	jns    802502 <read+0x5d>
		return r;
  8024fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802500:	eb 76                	jmp    802578 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802502:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802506:	8b 40 08             	mov    0x8(%rax),%eax
  802509:	83 e0 03             	and    $0x3,%eax
  80250c:	83 f8 01             	cmp    $0x1,%eax
  80250f:	75 3a                	jne    80254b <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802511:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802518:	00 00 00 
  80251b:	48 8b 00             	mov    (%rax),%rax
  80251e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802524:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802527:	89 c6                	mov    %eax,%esi
  802529:	48 bf af 3d 80 00 00 	movabs $0x803daf,%rdi
  802530:	00 00 00 
  802533:	b8 00 00 00 00       	mov    $0x0,%eax
  802538:	48 b9 49 06 80 00 00 	movabs $0x800649,%rcx
  80253f:	00 00 00 
  802542:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802544:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802549:	eb 2d                	jmp    802578 <read+0xd3>
	}
	if (!dev->dev_read)
  80254b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80254f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802553:	48 85 c0             	test   %rax,%rax
  802556:	75 07                	jne    80255f <read+0xba>
		return -E_NOT_SUPP;
  802558:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80255d:	eb 19                	jmp    802578 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80255f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802563:	48 8b 40 10          	mov    0x10(%rax),%rax
  802567:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80256b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80256f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802573:	48 89 cf             	mov    %rcx,%rdi
  802576:	ff d0                	callq  *%rax
}
  802578:	c9                   	leaveq 
  802579:	c3                   	retq   

000000000080257a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80257a:	55                   	push   %rbp
  80257b:	48 89 e5             	mov    %rsp,%rbp
  80257e:	48 83 ec 30          	sub    $0x30,%rsp
  802582:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802585:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802589:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80258d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802594:	eb 49                	jmp    8025df <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802596:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802599:	48 98                	cltq   
  80259b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80259f:	48 29 c2             	sub    %rax,%rdx
  8025a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a5:	48 63 c8             	movslq %eax,%rcx
  8025a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025ac:	48 01 c1             	add    %rax,%rcx
  8025af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025b2:	48 89 ce             	mov    %rcx,%rsi
  8025b5:	89 c7                	mov    %eax,%edi
  8025b7:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  8025be:	00 00 00 
  8025c1:	ff d0                	callq  *%rax
  8025c3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8025c6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8025ca:	79 05                	jns    8025d1 <readn+0x57>
			return m;
  8025cc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025cf:	eb 1c                	jmp    8025ed <readn+0x73>
		if (m == 0)
  8025d1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8025d5:	75 02                	jne    8025d9 <readn+0x5f>
			break;
  8025d7:	eb 11                	jmp    8025ea <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8025d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025dc:	01 45 fc             	add    %eax,-0x4(%rbp)
  8025df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e2:	48 98                	cltq   
  8025e4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8025e8:	72 ac                	jb     802596 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8025ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025ed:	c9                   	leaveq 
  8025ee:	c3                   	retq   

00000000008025ef <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8025ef:	55                   	push   %rbp
  8025f0:	48 89 e5             	mov    %rsp,%rbp
  8025f3:	48 83 ec 40          	sub    $0x40,%rsp
  8025f7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025fa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8025fe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802602:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802606:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802609:	48 89 d6             	mov    %rdx,%rsi
  80260c:	89 c7                	mov    %eax,%edi
  80260e:	48 b8 73 20 80 00 00 	movabs $0x802073,%rax
  802615:	00 00 00 
  802618:	ff d0                	callq  *%rax
  80261a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802621:	78 24                	js     802647 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802623:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802627:	8b 00                	mov    (%rax),%eax
  802629:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80262d:	48 89 d6             	mov    %rdx,%rsi
  802630:	89 c7                	mov    %eax,%edi
  802632:	48 b8 cc 21 80 00 00 	movabs $0x8021cc,%rax
  802639:	00 00 00 
  80263c:	ff d0                	callq  *%rax
  80263e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802641:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802645:	79 05                	jns    80264c <write+0x5d>
		return r;
  802647:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264a:	eb 75                	jmp    8026c1 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80264c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802650:	8b 40 08             	mov    0x8(%rax),%eax
  802653:	83 e0 03             	and    $0x3,%eax
  802656:	85 c0                	test   %eax,%eax
  802658:	75 3a                	jne    802694 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80265a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802661:	00 00 00 
  802664:	48 8b 00             	mov    (%rax),%rax
  802667:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80266d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802670:	89 c6                	mov    %eax,%esi
  802672:	48 bf cb 3d 80 00 00 	movabs $0x803dcb,%rdi
  802679:	00 00 00 
  80267c:	b8 00 00 00 00       	mov    $0x0,%eax
  802681:	48 b9 49 06 80 00 00 	movabs $0x800649,%rcx
  802688:	00 00 00 
  80268b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80268d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802692:	eb 2d                	jmp    8026c1 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802698:	48 8b 40 18          	mov    0x18(%rax),%rax
  80269c:	48 85 c0             	test   %rax,%rax
  80269f:	75 07                	jne    8026a8 <write+0xb9>
		return -E_NOT_SUPP;
  8026a1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026a6:	eb 19                	jmp    8026c1 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8026a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ac:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026b0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8026b4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026b8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026bc:	48 89 cf             	mov    %rcx,%rdi
  8026bf:	ff d0                	callq  *%rax
}
  8026c1:	c9                   	leaveq 
  8026c2:	c3                   	retq   

00000000008026c3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8026c3:	55                   	push   %rbp
  8026c4:	48 89 e5             	mov    %rsp,%rbp
  8026c7:	48 83 ec 18          	sub    $0x18,%rsp
  8026cb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026ce:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026d1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026d8:	48 89 d6             	mov    %rdx,%rsi
  8026db:	89 c7                	mov    %eax,%edi
  8026dd:	48 b8 73 20 80 00 00 	movabs $0x802073,%rax
  8026e4:	00 00 00 
  8026e7:	ff d0                	callq  *%rax
  8026e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f0:	79 05                	jns    8026f7 <seek+0x34>
		return r;
  8026f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f5:	eb 0f                	jmp    802706 <seek+0x43>
	fd->fd_offset = offset;
  8026f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026fb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8026fe:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802701:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802706:	c9                   	leaveq 
  802707:	c3                   	retq   

0000000000802708 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802708:	55                   	push   %rbp
  802709:	48 89 e5             	mov    %rsp,%rbp
  80270c:	48 83 ec 30          	sub    $0x30,%rsp
  802710:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802713:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802716:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80271a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80271d:	48 89 d6             	mov    %rdx,%rsi
  802720:	89 c7                	mov    %eax,%edi
  802722:	48 b8 73 20 80 00 00 	movabs $0x802073,%rax
  802729:	00 00 00 
  80272c:	ff d0                	callq  *%rax
  80272e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802731:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802735:	78 24                	js     80275b <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802737:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80273b:	8b 00                	mov    (%rax),%eax
  80273d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802741:	48 89 d6             	mov    %rdx,%rsi
  802744:	89 c7                	mov    %eax,%edi
  802746:	48 b8 cc 21 80 00 00 	movabs $0x8021cc,%rax
  80274d:	00 00 00 
  802750:	ff d0                	callq  *%rax
  802752:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802755:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802759:	79 05                	jns    802760 <ftruncate+0x58>
		return r;
  80275b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80275e:	eb 72                	jmp    8027d2 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802764:	8b 40 08             	mov    0x8(%rax),%eax
  802767:	83 e0 03             	and    $0x3,%eax
  80276a:	85 c0                	test   %eax,%eax
  80276c:	75 3a                	jne    8027a8 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80276e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802775:	00 00 00 
  802778:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80277b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802781:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802784:	89 c6                	mov    %eax,%esi
  802786:	48 bf e8 3d 80 00 00 	movabs $0x803de8,%rdi
  80278d:	00 00 00 
  802790:	b8 00 00 00 00       	mov    $0x0,%eax
  802795:	48 b9 49 06 80 00 00 	movabs $0x800649,%rcx
  80279c:	00 00 00 
  80279f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8027a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027a6:	eb 2a                	jmp    8027d2 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8027a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ac:	48 8b 40 30          	mov    0x30(%rax),%rax
  8027b0:	48 85 c0             	test   %rax,%rax
  8027b3:	75 07                	jne    8027bc <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8027b5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027ba:	eb 16                	jmp    8027d2 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8027bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027c0:	48 8b 40 30          	mov    0x30(%rax),%rax
  8027c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027c8:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8027cb:	89 ce                	mov    %ecx,%esi
  8027cd:	48 89 d7             	mov    %rdx,%rdi
  8027d0:	ff d0                	callq  *%rax
}
  8027d2:	c9                   	leaveq 
  8027d3:	c3                   	retq   

00000000008027d4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8027d4:	55                   	push   %rbp
  8027d5:	48 89 e5             	mov    %rsp,%rbp
  8027d8:	48 83 ec 30          	sub    $0x30,%rsp
  8027dc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027df:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027e3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027e7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027ea:	48 89 d6             	mov    %rdx,%rsi
  8027ed:	89 c7                	mov    %eax,%edi
  8027ef:	48 b8 73 20 80 00 00 	movabs $0x802073,%rax
  8027f6:	00 00 00 
  8027f9:	ff d0                	callq  *%rax
  8027fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802802:	78 24                	js     802828 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802804:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802808:	8b 00                	mov    (%rax),%eax
  80280a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80280e:	48 89 d6             	mov    %rdx,%rsi
  802811:	89 c7                	mov    %eax,%edi
  802813:	48 b8 cc 21 80 00 00 	movabs $0x8021cc,%rax
  80281a:	00 00 00 
  80281d:	ff d0                	callq  *%rax
  80281f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802822:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802826:	79 05                	jns    80282d <fstat+0x59>
		return r;
  802828:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80282b:	eb 5e                	jmp    80288b <fstat+0xb7>
	if (!dev->dev_stat)
  80282d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802831:	48 8b 40 28          	mov    0x28(%rax),%rax
  802835:	48 85 c0             	test   %rax,%rax
  802838:	75 07                	jne    802841 <fstat+0x6d>
		return -E_NOT_SUPP;
  80283a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80283f:	eb 4a                	jmp    80288b <fstat+0xb7>
	stat->st_name[0] = 0;
  802841:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802845:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802848:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80284c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802853:	00 00 00 
	stat->st_isdir = 0;
  802856:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80285a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802861:	00 00 00 
	stat->st_dev = dev;
  802864:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802868:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80286c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802873:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802877:	48 8b 40 28          	mov    0x28(%rax),%rax
  80287b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80287f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802883:	48 89 ce             	mov    %rcx,%rsi
  802886:	48 89 d7             	mov    %rdx,%rdi
  802889:	ff d0                	callq  *%rax
}
  80288b:	c9                   	leaveq 
  80288c:	c3                   	retq   

000000000080288d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80288d:	55                   	push   %rbp
  80288e:	48 89 e5             	mov    %rsp,%rbp
  802891:	48 83 ec 20          	sub    $0x20,%rsp
  802895:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802899:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80289d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a1:	be 00 00 00 00       	mov    $0x0,%esi
  8028a6:	48 89 c7             	mov    %rax,%rdi
  8028a9:	48 b8 7b 29 80 00 00 	movabs $0x80297b,%rax
  8028b0:	00 00 00 
  8028b3:	ff d0                	callq  *%rax
  8028b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028bc:	79 05                	jns    8028c3 <stat+0x36>
		return fd;
  8028be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c1:	eb 2f                	jmp    8028f2 <stat+0x65>
	r = fstat(fd, stat);
  8028c3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ca:	48 89 d6             	mov    %rdx,%rsi
  8028cd:	89 c7                	mov    %eax,%edi
  8028cf:	48 b8 d4 27 80 00 00 	movabs $0x8027d4,%rax
  8028d6:	00 00 00 
  8028d9:	ff d0                	callq  *%rax
  8028db:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8028de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e1:	89 c7                	mov    %eax,%edi
  8028e3:	48 b8 83 22 80 00 00 	movabs $0x802283,%rax
  8028ea:	00 00 00 
  8028ed:	ff d0                	callq  *%rax
	return r;
  8028ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8028f2:	c9                   	leaveq 
  8028f3:	c3                   	retq   

00000000008028f4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8028f4:	55                   	push   %rbp
  8028f5:	48 89 e5             	mov    %rsp,%rbp
  8028f8:	48 83 ec 10          	sub    $0x10,%rsp
  8028fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8028ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802903:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  80290a:	00 00 00 
  80290d:	8b 00                	mov    (%rax),%eax
  80290f:	85 c0                	test   %eax,%eax
  802911:	75 1d                	jne    802930 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802913:	bf 01 00 00 00       	mov    $0x1,%edi
  802918:	48 b8 ea 36 80 00 00 	movabs $0x8036ea,%rax
  80291f:	00 00 00 
  802922:	ff d0                	callq  *%rax
  802924:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  80292b:	00 00 00 
  80292e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802930:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802937:	00 00 00 
  80293a:	8b 00                	mov    (%rax),%eax
  80293c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80293f:	b9 07 00 00 00       	mov    $0x7,%ecx
  802944:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80294b:	00 00 00 
  80294e:	89 c7                	mov    %eax,%edi
  802950:	48 b8 52 36 80 00 00 	movabs $0x803652,%rax
  802957:	00 00 00 
  80295a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80295c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802960:	ba 00 00 00 00       	mov    $0x0,%edx
  802965:	48 89 c6             	mov    %rax,%rsi
  802968:	bf 00 00 00 00       	mov    $0x0,%edi
  80296d:	48 b8 89 35 80 00 00 	movabs $0x803589,%rax
  802974:	00 00 00 
  802977:	ff d0                	callq  *%rax
}
  802979:	c9                   	leaveq 
  80297a:	c3                   	retq   

000000000080297b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80297b:	55                   	push   %rbp
  80297c:	48 89 e5             	mov    %rsp,%rbp
  80297f:	48 83 ec 20          	sub    $0x20,%rsp
  802983:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802987:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  80298a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80298e:	48 89 c7             	mov    %rax,%rdi
  802991:	48 b8 85 13 80 00 00 	movabs $0x801385,%rax
  802998:	00 00 00 
  80299b:	ff d0                	callq  *%rax
  80299d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8029a2:	7e 0a                	jle    8029ae <open+0x33>
		return -E_BAD_PATH;
  8029a4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8029a9:	e9 a5 00 00 00       	jmpq   802a53 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8029ae:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8029b2:	48 89 c7             	mov    %rax,%rdi
  8029b5:	48 b8 db 1f 80 00 00 	movabs $0x801fdb,%rax
  8029bc:	00 00 00 
  8029bf:	ff d0                	callq  *%rax
  8029c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029c8:	79 08                	jns    8029d2 <open+0x57>
		return r;
  8029ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029cd:	e9 81 00 00 00       	jmpq   802a53 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8029d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d6:	48 89 c6             	mov    %rax,%rsi
  8029d9:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8029e0:	00 00 00 
  8029e3:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  8029ea:	00 00 00 
  8029ed:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8029ef:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029f6:	00 00 00 
  8029f9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8029fc:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802a02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a06:	48 89 c6             	mov    %rax,%rsi
  802a09:	bf 01 00 00 00       	mov    $0x1,%edi
  802a0e:	48 b8 f4 28 80 00 00 	movabs $0x8028f4,%rax
  802a15:	00 00 00 
  802a18:	ff d0                	callq  *%rax
  802a1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a21:	79 1d                	jns    802a40 <open+0xc5>
		fd_close(fd, 0);
  802a23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a27:	be 00 00 00 00       	mov    $0x0,%esi
  802a2c:	48 89 c7             	mov    %rax,%rdi
  802a2f:	48 b8 03 21 80 00 00 	movabs $0x802103,%rax
  802a36:	00 00 00 
  802a39:	ff d0                	callq  *%rax
		return r;
  802a3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3e:	eb 13                	jmp    802a53 <open+0xd8>
	}

	return fd2num(fd);
  802a40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a44:	48 89 c7             	mov    %rax,%rdi
  802a47:	48 b8 8d 1f 80 00 00 	movabs $0x801f8d,%rax
  802a4e:	00 00 00 
  802a51:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802a53:	c9                   	leaveq 
  802a54:	c3                   	retq   

0000000000802a55 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802a55:	55                   	push   %rbp
  802a56:	48 89 e5             	mov    %rsp,%rbp
  802a59:	48 83 ec 10          	sub    $0x10,%rsp
  802a5d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802a61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a65:	8b 50 0c             	mov    0xc(%rax),%edx
  802a68:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a6f:	00 00 00 
  802a72:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802a74:	be 00 00 00 00       	mov    $0x0,%esi
  802a79:	bf 06 00 00 00       	mov    $0x6,%edi
  802a7e:	48 b8 f4 28 80 00 00 	movabs $0x8028f4,%rax
  802a85:	00 00 00 
  802a88:	ff d0                	callq  *%rax
}
  802a8a:	c9                   	leaveq 
  802a8b:	c3                   	retq   

0000000000802a8c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802a8c:	55                   	push   %rbp
  802a8d:	48 89 e5             	mov    %rsp,%rbp
  802a90:	48 83 ec 30          	sub    $0x30,%rsp
  802a94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a98:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a9c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802aa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa4:	8b 50 0c             	mov    0xc(%rax),%edx
  802aa7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aae:	00 00 00 
  802ab1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802ab3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aba:	00 00 00 
  802abd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ac1:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802ac5:	be 00 00 00 00       	mov    $0x0,%esi
  802aca:	bf 03 00 00 00       	mov    $0x3,%edi
  802acf:	48 b8 f4 28 80 00 00 	movabs $0x8028f4,%rax
  802ad6:	00 00 00 
  802ad9:	ff d0                	callq  *%rax
  802adb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ade:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae2:	79 05                	jns    802ae9 <devfile_read+0x5d>
		return r;
  802ae4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae7:	eb 26                	jmp    802b0f <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802ae9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aec:	48 63 d0             	movslq %eax,%rdx
  802aef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802af3:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802afa:	00 00 00 
  802afd:	48 89 c7             	mov    %rax,%rdi
  802b00:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  802b07:	00 00 00 
  802b0a:	ff d0                	callq  *%rax

	return r;
  802b0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802b0f:	c9                   	leaveq 
  802b10:	c3                   	retq   

0000000000802b11 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802b11:	55                   	push   %rbp
  802b12:	48 89 e5             	mov    %rsp,%rbp
  802b15:	48 83 ec 30          	sub    $0x30,%rsp
  802b19:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b1d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b21:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802b25:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802b2c:	00 
  802b2d:	76 08                	jbe    802b37 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802b2f:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802b36:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802b37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3b:	8b 50 0c             	mov    0xc(%rax),%edx
  802b3e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b45:	00 00 00 
  802b48:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802b4a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b51:	00 00 00 
  802b54:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b58:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  802b5c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b64:	48 89 c6             	mov    %rax,%rsi
  802b67:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802b6e:	00 00 00 
  802b71:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  802b78:	00 00 00 
  802b7b:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802b7d:	be 00 00 00 00       	mov    $0x0,%esi
  802b82:	bf 04 00 00 00       	mov    $0x4,%edi
  802b87:	48 b8 f4 28 80 00 00 	movabs $0x8028f4,%rax
  802b8e:	00 00 00 
  802b91:	ff d0                	callq  *%rax
  802b93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9a:	79 05                	jns    802ba1 <devfile_write+0x90>
		return r;
  802b9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9f:	eb 03                	jmp    802ba4 <devfile_write+0x93>

	return r;
  802ba1:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802ba4:	c9                   	leaveq 
  802ba5:	c3                   	retq   

0000000000802ba6 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802ba6:	55                   	push   %rbp
  802ba7:	48 89 e5             	mov    %rsp,%rbp
  802baa:	48 83 ec 20          	sub    $0x20,%rsp
  802bae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bb2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802bb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bba:	8b 50 0c             	mov    0xc(%rax),%edx
  802bbd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bc4:	00 00 00 
  802bc7:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802bc9:	be 00 00 00 00       	mov    $0x0,%esi
  802bce:	bf 05 00 00 00       	mov    $0x5,%edi
  802bd3:	48 b8 f4 28 80 00 00 	movabs $0x8028f4,%rax
  802bda:	00 00 00 
  802bdd:	ff d0                	callq  *%rax
  802bdf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be6:	79 05                	jns    802bed <devfile_stat+0x47>
		return r;
  802be8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802beb:	eb 56                	jmp    802c43 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802bed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bf1:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802bf8:	00 00 00 
  802bfb:	48 89 c7             	mov    %rax,%rdi
  802bfe:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  802c05:	00 00 00 
  802c08:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802c0a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c11:	00 00 00 
  802c14:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802c1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c1e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802c24:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c2b:	00 00 00 
  802c2e:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802c34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c38:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802c3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c43:	c9                   	leaveq 
  802c44:	c3                   	retq   

0000000000802c45 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802c45:	55                   	push   %rbp
  802c46:	48 89 e5             	mov    %rsp,%rbp
  802c49:	48 83 ec 10          	sub    $0x10,%rsp
  802c4d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c51:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802c54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c58:	8b 50 0c             	mov    0xc(%rax),%edx
  802c5b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c62:	00 00 00 
  802c65:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802c67:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c6e:	00 00 00 
  802c71:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802c74:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c77:	be 00 00 00 00       	mov    $0x0,%esi
  802c7c:	bf 02 00 00 00       	mov    $0x2,%edi
  802c81:	48 b8 f4 28 80 00 00 	movabs $0x8028f4,%rax
  802c88:	00 00 00 
  802c8b:	ff d0                	callq  *%rax
}
  802c8d:	c9                   	leaveq 
  802c8e:	c3                   	retq   

0000000000802c8f <remove>:

// Delete a file
int
remove(const char *path)
{
  802c8f:	55                   	push   %rbp
  802c90:	48 89 e5             	mov    %rsp,%rbp
  802c93:	48 83 ec 10          	sub    $0x10,%rsp
  802c97:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c9f:	48 89 c7             	mov    %rax,%rdi
  802ca2:	48 b8 85 13 80 00 00 	movabs $0x801385,%rax
  802ca9:	00 00 00 
  802cac:	ff d0                	callq  *%rax
  802cae:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802cb3:	7e 07                	jle    802cbc <remove+0x2d>
		return -E_BAD_PATH;
  802cb5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802cba:	eb 33                	jmp    802cef <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802cbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cc0:	48 89 c6             	mov    %rax,%rsi
  802cc3:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802cca:	00 00 00 
  802ccd:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  802cd4:	00 00 00 
  802cd7:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802cd9:	be 00 00 00 00       	mov    $0x0,%esi
  802cde:	bf 07 00 00 00       	mov    $0x7,%edi
  802ce3:	48 b8 f4 28 80 00 00 	movabs $0x8028f4,%rax
  802cea:	00 00 00 
  802ced:	ff d0                	callq  *%rax
}
  802cef:	c9                   	leaveq 
  802cf0:	c3                   	retq   

0000000000802cf1 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802cf1:	55                   	push   %rbp
  802cf2:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802cf5:	be 00 00 00 00       	mov    $0x0,%esi
  802cfa:	bf 08 00 00 00       	mov    $0x8,%edi
  802cff:	48 b8 f4 28 80 00 00 	movabs $0x8028f4,%rax
  802d06:	00 00 00 
  802d09:	ff d0                	callq  *%rax
}
  802d0b:	5d                   	pop    %rbp
  802d0c:	c3                   	retq   

0000000000802d0d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802d0d:	55                   	push   %rbp
  802d0e:	48 89 e5             	mov    %rsp,%rbp
  802d11:	53                   	push   %rbx
  802d12:	48 83 ec 38          	sub    $0x38,%rsp
  802d16:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802d1a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802d1e:	48 89 c7             	mov    %rax,%rdi
  802d21:	48 b8 db 1f 80 00 00 	movabs $0x801fdb,%rax
  802d28:	00 00 00 
  802d2b:	ff d0                	callq  *%rax
  802d2d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d30:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d34:	0f 88 bf 01 00 00    	js     802ef9 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d3e:	ba 07 04 00 00       	mov    $0x407,%edx
  802d43:	48 89 c6             	mov    %rax,%rsi
  802d46:	bf 00 00 00 00       	mov    $0x0,%edi
  802d4b:	48 b8 20 1d 80 00 00 	movabs $0x801d20,%rax
  802d52:	00 00 00 
  802d55:	ff d0                	callq  *%rax
  802d57:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d5a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d5e:	0f 88 95 01 00 00    	js     802ef9 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802d64:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802d68:	48 89 c7             	mov    %rax,%rdi
  802d6b:	48 b8 db 1f 80 00 00 	movabs $0x801fdb,%rax
  802d72:	00 00 00 
  802d75:	ff d0                	callq  *%rax
  802d77:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d7e:	0f 88 5d 01 00 00    	js     802ee1 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d88:	ba 07 04 00 00       	mov    $0x407,%edx
  802d8d:	48 89 c6             	mov    %rax,%rsi
  802d90:	bf 00 00 00 00       	mov    $0x0,%edi
  802d95:	48 b8 20 1d 80 00 00 	movabs $0x801d20,%rax
  802d9c:	00 00 00 
  802d9f:	ff d0                	callq  *%rax
  802da1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802da4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802da8:	0f 88 33 01 00 00    	js     802ee1 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802dae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802db2:	48 89 c7             	mov    %rax,%rdi
  802db5:	48 b8 b0 1f 80 00 00 	movabs $0x801fb0,%rax
  802dbc:	00 00 00 
  802dbf:	ff d0                	callq  *%rax
  802dc1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802dc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dc9:	ba 07 04 00 00       	mov    $0x407,%edx
  802dce:	48 89 c6             	mov    %rax,%rsi
  802dd1:	bf 00 00 00 00       	mov    $0x0,%edi
  802dd6:	48 b8 20 1d 80 00 00 	movabs $0x801d20,%rax
  802ddd:	00 00 00 
  802de0:	ff d0                	callq  *%rax
  802de2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802de5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802de9:	79 05                	jns    802df0 <pipe+0xe3>
		goto err2;
  802deb:	e9 d9 00 00 00       	jmpq   802ec9 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802df0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802df4:	48 89 c7             	mov    %rax,%rdi
  802df7:	48 b8 b0 1f 80 00 00 	movabs $0x801fb0,%rax
  802dfe:	00 00 00 
  802e01:	ff d0                	callq  *%rax
  802e03:	48 89 c2             	mov    %rax,%rdx
  802e06:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e0a:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802e10:	48 89 d1             	mov    %rdx,%rcx
  802e13:	ba 00 00 00 00       	mov    $0x0,%edx
  802e18:	48 89 c6             	mov    %rax,%rsi
  802e1b:	bf 00 00 00 00       	mov    $0x0,%edi
  802e20:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  802e27:	00 00 00 
  802e2a:	ff d0                	callq  *%rax
  802e2c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e33:	79 1b                	jns    802e50 <pipe+0x143>
		goto err3;
  802e35:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  802e36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e3a:	48 89 c6             	mov    %rax,%rsi
  802e3d:	bf 00 00 00 00       	mov    $0x0,%edi
  802e42:	48 b8 cb 1d 80 00 00 	movabs $0x801dcb,%rax
  802e49:	00 00 00 
  802e4c:	ff d0                	callq  *%rax
  802e4e:	eb 79                	jmp    802ec9 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802e50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e54:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802e5b:	00 00 00 
  802e5e:	8b 12                	mov    (%rdx),%edx
  802e60:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802e62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e66:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802e6d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e71:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802e78:	00 00 00 
  802e7b:	8b 12                	mov    (%rdx),%edx
  802e7d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802e7f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e83:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802e8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e8e:	48 89 c7             	mov    %rax,%rdi
  802e91:	48 b8 8d 1f 80 00 00 	movabs $0x801f8d,%rax
  802e98:	00 00 00 
  802e9b:	ff d0                	callq  *%rax
  802e9d:	89 c2                	mov    %eax,%edx
  802e9f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ea3:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802ea5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ea9:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802ead:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802eb1:	48 89 c7             	mov    %rax,%rdi
  802eb4:	48 b8 8d 1f 80 00 00 	movabs $0x801f8d,%rax
  802ebb:	00 00 00 
  802ebe:	ff d0                	callq  *%rax
  802ec0:	89 03                	mov    %eax,(%rbx)
	return 0;
  802ec2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec7:	eb 33                	jmp    802efc <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  802ec9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ecd:	48 89 c6             	mov    %rax,%rsi
  802ed0:	bf 00 00 00 00       	mov    $0x0,%edi
  802ed5:	48 b8 cb 1d 80 00 00 	movabs $0x801dcb,%rax
  802edc:	00 00 00 
  802edf:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  802ee1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ee5:	48 89 c6             	mov    %rax,%rsi
  802ee8:	bf 00 00 00 00       	mov    $0x0,%edi
  802eed:	48 b8 cb 1d 80 00 00 	movabs $0x801dcb,%rax
  802ef4:	00 00 00 
  802ef7:	ff d0                	callq  *%rax
    err:
	return r;
  802ef9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802efc:	48 83 c4 38          	add    $0x38,%rsp
  802f00:	5b                   	pop    %rbx
  802f01:	5d                   	pop    %rbp
  802f02:	c3                   	retq   

0000000000802f03 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802f03:	55                   	push   %rbp
  802f04:	48 89 e5             	mov    %rsp,%rbp
  802f07:	53                   	push   %rbx
  802f08:	48 83 ec 28          	sub    $0x28,%rsp
  802f0c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f10:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802f14:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802f1b:	00 00 00 
  802f1e:	48 8b 00             	mov    (%rax),%rax
  802f21:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802f27:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802f2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f2e:	48 89 c7             	mov    %rax,%rdi
  802f31:	48 b8 6c 37 80 00 00 	movabs $0x80376c,%rax
  802f38:	00 00 00 
  802f3b:	ff d0                	callq  *%rax
  802f3d:	89 c3                	mov    %eax,%ebx
  802f3f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f43:	48 89 c7             	mov    %rax,%rdi
  802f46:	48 b8 6c 37 80 00 00 	movabs $0x80376c,%rax
  802f4d:	00 00 00 
  802f50:	ff d0                	callq  *%rax
  802f52:	39 c3                	cmp    %eax,%ebx
  802f54:	0f 94 c0             	sete   %al
  802f57:	0f b6 c0             	movzbl %al,%eax
  802f5a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802f5d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802f64:	00 00 00 
  802f67:	48 8b 00             	mov    (%rax),%rax
  802f6a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802f70:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802f73:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f76:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802f79:	75 05                	jne    802f80 <_pipeisclosed+0x7d>
			return ret;
  802f7b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f7e:	eb 4f                	jmp    802fcf <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802f80:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f83:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802f86:	74 42                	je     802fca <_pipeisclosed+0xc7>
  802f88:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802f8c:	75 3c                	jne    802fca <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802f8e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802f95:	00 00 00 
  802f98:	48 8b 00             	mov    (%rax),%rax
  802f9b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802fa1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802fa4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fa7:	89 c6                	mov    %eax,%esi
  802fa9:	48 bf 13 3e 80 00 00 	movabs $0x803e13,%rdi
  802fb0:	00 00 00 
  802fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb8:	49 b8 49 06 80 00 00 	movabs $0x800649,%r8
  802fbf:	00 00 00 
  802fc2:	41 ff d0             	callq  *%r8
	}
  802fc5:	e9 4a ff ff ff       	jmpq   802f14 <_pipeisclosed+0x11>
  802fca:	e9 45 ff ff ff       	jmpq   802f14 <_pipeisclosed+0x11>
}
  802fcf:	48 83 c4 28          	add    $0x28,%rsp
  802fd3:	5b                   	pop    %rbx
  802fd4:	5d                   	pop    %rbp
  802fd5:	c3                   	retq   

0000000000802fd6 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802fd6:	55                   	push   %rbp
  802fd7:	48 89 e5             	mov    %rsp,%rbp
  802fda:	48 83 ec 30          	sub    $0x30,%rsp
  802fde:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fe1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802fe5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802fe8:	48 89 d6             	mov    %rdx,%rsi
  802feb:	89 c7                	mov    %eax,%edi
  802fed:	48 b8 73 20 80 00 00 	movabs $0x802073,%rax
  802ff4:	00 00 00 
  802ff7:	ff d0                	callq  *%rax
  802ff9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ffc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803000:	79 05                	jns    803007 <pipeisclosed+0x31>
		return r;
  803002:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803005:	eb 31                	jmp    803038 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803007:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80300b:	48 89 c7             	mov    %rax,%rdi
  80300e:	48 b8 b0 1f 80 00 00 	movabs $0x801fb0,%rax
  803015:	00 00 00 
  803018:	ff d0                	callq  *%rax
  80301a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80301e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803022:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803026:	48 89 d6             	mov    %rdx,%rsi
  803029:	48 89 c7             	mov    %rax,%rdi
  80302c:	48 b8 03 2f 80 00 00 	movabs $0x802f03,%rax
  803033:	00 00 00 
  803036:	ff d0                	callq  *%rax
}
  803038:	c9                   	leaveq 
  803039:	c3                   	retq   

000000000080303a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80303a:	55                   	push   %rbp
  80303b:	48 89 e5             	mov    %rsp,%rbp
  80303e:	48 83 ec 40          	sub    $0x40,%rsp
  803042:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803046:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80304a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80304e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803052:	48 89 c7             	mov    %rax,%rdi
  803055:	48 b8 b0 1f 80 00 00 	movabs $0x801fb0,%rax
  80305c:	00 00 00 
  80305f:	ff d0                	callq  *%rax
  803061:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803065:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803069:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80306d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803074:	00 
  803075:	e9 92 00 00 00       	jmpq   80310c <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80307a:	eb 41                	jmp    8030bd <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80307c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803081:	74 09                	je     80308c <devpipe_read+0x52>
				return i;
  803083:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803087:	e9 92 00 00 00       	jmpq   80311e <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80308c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803090:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803094:	48 89 d6             	mov    %rdx,%rsi
  803097:	48 89 c7             	mov    %rax,%rdi
  80309a:	48 b8 03 2f 80 00 00 	movabs $0x802f03,%rax
  8030a1:	00 00 00 
  8030a4:	ff d0                	callq  *%rax
  8030a6:	85 c0                	test   %eax,%eax
  8030a8:	74 07                	je     8030b1 <devpipe_read+0x77>
				return 0;
  8030aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8030af:	eb 6d                	jmp    80311e <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8030b1:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  8030b8:	00 00 00 
  8030bb:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8030bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c1:	8b 10                	mov    (%rax),%edx
  8030c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c7:	8b 40 04             	mov    0x4(%rax),%eax
  8030ca:	39 c2                	cmp    %eax,%edx
  8030cc:	74 ae                	je     80307c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8030ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030d6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8030da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030de:	8b 00                	mov    (%rax),%eax
  8030e0:	99                   	cltd   
  8030e1:	c1 ea 1b             	shr    $0x1b,%edx
  8030e4:	01 d0                	add    %edx,%eax
  8030e6:	83 e0 1f             	and    $0x1f,%eax
  8030e9:	29 d0                	sub    %edx,%eax
  8030eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030ef:	48 98                	cltq   
  8030f1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8030f6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8030f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030fc:	8b 00                	mov    (%rax),%eax
  8030fe:	8d 50 01             	lea    0x1(%rax),%edx
  803101:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803105:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803107:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80310c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803110:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803114:	0f 82 60 ff ff ff    	jb     80307a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80311a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80311e:	c9                   	leaveq 
  80311f:	c3                   	retq   

0000000000803120 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803120:	55                   	push   %rbp
  803121:	48 89 e5             	mov    %rsp,%rbp
  803124:	48 83 ec 40          	sub    $0x40,%rsp
  803128:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80312c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803130:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803134:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803138:	48 89 c7             	mov    %rax,%rdi
  80313b:	48 b8 b0 1f 80 00 00 	movabs $0x801fb0,%rax
  803142:	00 00 00 
  803145:	ff d0                	callq  *%rax
  803147:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80314b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80314f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803153:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80315a:	00 
  80315b:	e9 8e 00 00 00       	jmpq   8031ee <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803160:	eb 31                	jmp    803193 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803162:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803166:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80316a:	48 89 d6             	mov    %rdx,%rsi
  80316d:	48 89 c7             	mov    %rax,%rdi
  803170:	48 b8 03 2f 80 00 00 	movabs $0x802f03,%rax
  803177:	00 00 00 
  80317a:	ff d0                	callq  *%rax
  80317c:	85 c0                	test   %eax,%eax
  80317e:	74 07                	je     803187 <devpipe_write+0x67>
				return 0;
  803180:	b8 00 00 00 00       	mov    $0x0,%eax
  803185:	eb 79                	jmp    803200 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803187:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  80318e:	00 00 00 
  803191:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803193:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803197:	8b 40 04             	mov    0x4(%rax),%eax
  80319a:	48 63 d0             	movslq %eax,%rdx
  80319d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a1:	8b 00                	mov    (%rax),%eax
  8031a3:	48 98                	cltq   
  8031a5:	48 83 c0 20          	add    $0x20,%rax
  8031a9:	48 39 c2             	cmp    %rax,%rdx
  8031ac:	73 b4                	jae    803162 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8031ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031b2:	8b 40 04             	mov    0x4(%rax),%eax
  8031b5:	99                   	cltd   
  8031b6:	c1 ea 1b             	shr    $0x1b,%edx
  8031b9:	01 d0                	add    %edx,%eax
  8031bb:	83 e0 1f             	and    $0x1f,%eax
  8031be:	29 d0                	sub    %edx,%eax
  8031c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8031c4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8031c8:	48 01 ca             	add    %rcx,%rdx
  8031cb:	0f b6 0a             	movzbl (%rdx),%ecx
  8031ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031d2:	48 98                	cltq   
  8031d4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8031d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031dc:	8b 40 04             	mov    0x4(%rax),%eax
  8031df:	8d 50 01             	lea    0x1(%rax),%edx
  8031e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031e6:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8031e9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8031ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031f2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8031f6:	0f 82 64 ff ff ff    	jb     803160 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8031fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803200:	c9                   	leaveq 
  803201:	c3                   	retq   

0000000000803202 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803202:	55                   	push   %rbp
  803203:	48 89 e5             	mov    %rsp,%rbp
  803206:	48 83 ec 20          	sub    $0x20,%rsp
  80320a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80320e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803212:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803216:	48 89 c7             	mov    %rax,%rdi
  803219:	48 b8 b0 1f 80 00 00 	movabs $0x801fb0,%rax
  803220:	00 00 00 
  803223:	ff d0                	callq  *%rax
  803225:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803229:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80322d:	48 be 26 3e 80 00 00 	movabs $0x803e26,%rsi
  803234:	00 00 00 
  803237:	48 89 c7             	mov    %rax,%rdi
  80323a:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  803241:	00 00 00 
  803244:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803246:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80324a:	8b 50 04             	mov    0x4(%rax),%edx
  80324d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803251:	8b 00                	mov    (%rax),%eax
  803253:	29 c2                	sub    %eax,%edx
  803255:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803259:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80325f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803263:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80326a:	00 00 00 
	stat->st_dev = &devpipe;
  80326d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803271:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  803278:	00 00 00 
  80327b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803282:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803287:	c9                   	leaveq 
  803288:	c3                   	retq   

0000000000803289 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803289:	55                   	push   %rbp
  80328a:	48 89 e5             	mov    %rsp,%rbp
  80328d:	48 83 ec 10          	sub    $0x10,%rsp
  803291:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803295:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803299:	48 89 c6             	mov    %rax,%rsi
  80329c:	bf 00 00 00 00       	mov    $0x0,%edi
  8032a1:	48 b8 cb 1d 80 00 00 	movabs $0x801dcb,%rax
  8032a8:	00 00 00 
  8032ab:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8032ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032b1:	48 89 c7             	mov    %rax,%rdi
  8032b4:	48 b8 b0 1f 80 00 00 	movabs $0x801fb0,%rax
  8032bb:	00 00 00 
  8032be:	ff d0                	callq  *%rax
  8032c0:	48 89 c6             	mov    %rax,%rsi
  8032c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8032c8:	48 b8 cb 1d 80 00 00 	movabs $0x801dcb,%rax
  8032cf:	00 00 00 
  8032d2:	ff d0                	callq  *%rax
}
  8032d4:	c9                   	leaveq 
  8032d5:	c3                   	retq   

00000000008032d6 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8032d6:	55                   	push   %rbp
  8032d7:	48 89 e5             	mov    %rsp,%rbp
  8032da:	48 83 ec 20          	sub    $0x20,%rsp
  8032de:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8032e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032e4:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8032e7:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8032eb:	be 01 00 00 00       	mov    $0x1,%esi
  8032f0:	48 89 c7             	mov    %rax,%rdi
  8032f3:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  8032fa:	00 00 00 
  8032fd:	ff d0                	callq  *%rax
}
  8032ff:	c9                   	leaveq 
  803300:	c3                   	retq   

0000000000803301 <getchar>:

int
getchar(void)
{
  803301:	55                   	push   %rbp
  803302:	48 89 e5             	mov    %rsp,%rbp
  803305:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803309:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80330d:	ba 01 00 00 00       	mov    $0x1,%edx
  803312:	48 89 c6             	mov    %rax,%rsi
  803315:	bf 00 00 00 00       	mov    $0x0,%edi
  80331a:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  803321:	00 00 00 
  803324:	ff d0                	callq  *%rax
  803326:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803329:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80332d:	79 05                	jns    803334 <getchar+0x33>
		return r;
  80332f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803332:	eb 14                	jmp    803348 <getchar+0x47>
	if (r < 1)
  803334:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803338:	7f 07                	jg     803341 <getchar+0x40>
		return -E_EOF;
  80333a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80333f:	eb 07                	jmp    803348 <getchar+0x47>
	return c;
  803341:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803345:	0f b6 c0             	movzbl %al,%eax
}
  803348:	c9                   	leaveq 
  803349:	c3                   	retq   

000000000080334a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80334a:	55                   	push   %rbp
  80334b:	48 89 e5             	mov    %rsp,%rbp
  80334e:	48 83 ec 20          	sub    $0x20,%rsp
  803352:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803355:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803359:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80335c:	48 89 d6             	mov    %rdx,%rsi
  80335f:	89 c7                	mov    %eax,%edi
  803361:	48 b8 73 20 80 00 00 	movabs $0x802073,%rax
  803368:	00 00 00 
  80336b:	ff d0                	callq  *%rax
  80336d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803370:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803374:	79 05                	jns    80337b <iscons+0x31>
		return r;
  803376:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803379:	eb 1a                	jmp    803395 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80337b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337f:	8b 10                	mov    (%rax),%edx
  803381:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803388:	00 00 00 
  80338b:	8b 00                	mov    (%rax),%eax
  80338d:	39 c2                	cmp    %eax,%edx
  80338f:	0f 94 c0             	sete   %al
  803392:	0f b6 c0             	movzbl %al,%eax
}
  803395:	c9                   	leaveq 
  803396:	c3                   	retq   

0000000000803397 <opencons>:

int
opencons(void)
{
  803397:	55                   	push   %rbp
  803398:	48 89 e5             	mov    %rsp,%rbp
  80339b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80339f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8033a3:	48 89 c7             	mov    %rax,%rdi
  8033a6:	48 b8 db 1f 80 00 00 	movabs $0x801fdb,%rax
  8033ad:	00 00 00 
  8033b0:	ff d0                	callq  *%rax
  8033b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b9:	79 05                	jns    8033c0 <opencons+0x29>
		return r;
  8033bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033be:	eb 5b                	jmp    80341b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8033c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033c4:	ba 07 04 00 00       	mov    $0x407,%edx
  8033c9:	48 89 c6             	mov    %rax,%rsi
  8033cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8033d1:	48 b8 20 1d 80 00 00 	movabs $0x801d20,%rax
  8033d8:	00 00 00 
  8033db:	ff d0                	callq  *%rax
  8033dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033e4:	79 05                	jns    8033eb <opencons+0x54>
		return r;
  8033e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e9:	eb 30                	jmp    80341b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8033eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ef:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8033f6:	00 00 00 
  8033f9:	8b 12                	mov    (%rdx),%edx
  8033fb:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8033fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803401:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803408:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80340c:	48 89 c7             	mov    %rax,%rdi
  80340f:	48 b8 8d 1f 80 00 00 	movabs $0x801f8d,%rax
  803416:	00 00 00 
  803419:	ff d0                	callq  *%rax
}
  80341b:	c9                   	leaveq 
  80341c:	c3                   	retq   

000000000080341d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80341d:	55                   	push   %rbp
  80341e:	48 89 e5             	mov    %rsp,%rbp
  803421:	48 83 ec 30          	sub    $0x30,%rsp
  803425:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803429:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80342d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803431:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803436:	75 07                	jne    80343f <devcons_read+0x22>
		return 0;
  803438:	b8 00 00 00 00       	mov    $0x0,%eax
  80343d:	eb 4b                	jmp    80348a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80343f:	eb 0c                	jmp    80344d <devcons_read+0x30>
		sys_yield();
  803441:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  803448:	00 00 00 
  80344b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80344d:	48 b8 22 1c 80 00 00 	movabs $0x801c22,%rax
  803454:	00 00 00 
  803457:	ff d0                	callq  *%rax
  803459:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80345c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803460:	74 df                	je     803441 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803462:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803466:	79 05                	jns    80346d <devcons_read+0x50>
		return c;
  803468:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80346b:	eb 1d                	jmp    80348a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80346d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803471:	75 07                	jne    80347a <devcons_read+0x5d>
		return 0;
  803473:	b8 00 00 00 00       	mov    $0x0,%eax
  803478:	eb 10                	jmp    80348a <devcons_read+0x6d>
	*(char*)vbuf = c;
  80347a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347d:	89 c2                	mov    %eax,%edx
  80347f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803483:	88 10                	mov    %dl,(%rax)
	return 1;
  803485:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80348a:	c9                   	leaveq 
  80348b:	c3                   	retq   

000000000080348c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80348c:	55                   	push   %rbp
  80348d:	48 89 e5             	mov    %rsp,%rbp
  803490:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803497:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80349e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8034a5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8034ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034b3:	eb 76                	jmp    80352b <devcons_write+0x9f>
		m = n - tot;
  8034b5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8034bc:	89 c2                	mov    %eax,%edx
  8034be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c1:	29 c2                	sub    %eax,%edx
  8034c3:	89 d0                	mov    %edx,%eax
  8034c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8034c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034cb:	83 f8 7f             	cmp    $0x7f,%eax
  8034ce:	76 07                	jbe    8034d7 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8034d0:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8034d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034da:	48 63 d0             	movslq %eax,%rdx
  8034dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e0:	48 63 c8             	movslq %eax,%rcx
  8034e3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8034ea:	48 01 c1             	add    %rax,%rcx
  8034ed:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8034f4:	48 89 ce             	mov    %rcx,%rsi
  8034f7:	48 89 c7             	mov    %rax,%rdi
  8034fa:	48 b8 15 17 80 00 00 	movabs $0x801715,%rax
  803501:	00 00 00 
  803504:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803506:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803509:	48 63 d0             	movslq %eax,%rdx
  80350c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803513:	48 89 d6             	mov    %rdx,%rsi
  803516:	48 89 c7             	mov    %rax,%rdi
  803519:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  803520:	00 00 00 
  803523:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803525:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803528:	01 45 fc             	add    %eax,-0x4(%rbp)
  80352b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80352e:	48 98                	cltq   
  803530:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803537:	0f 82 78 ff ff ff    	jb     8034b5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80353d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803540:	c9                   	leaveq 
  803541:	c3                   	retq   

0000000000803542 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803542:	55                   	push   %rbp
  803543:	48 89 e5             	mov    %rsp,%rbp
  803546:	48 83 ec 08          	sub    $0x8,%rsp
  80354a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80354e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803553:	c9                   	leaveq 
  803554:	c3                   	retq   

0000000000803555 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803555:	55                   	push   %rbp
  803556:	48 89 e5             	mov    %rsp,%rbp
  803559:	48 83 ec 10          	sub    $0x10,%rsp
  80355d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803561:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803565:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803569:	48 be 32 3e 80 00 00 	movabs $0x803e32,%rsi
  803570:	00 00 00 
  803573:	48 89 c7             	mov    %rax,%rdi
  803576:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  80357d:	00 00 00 
  803580:	ff d0                	callq  *%rax
	return 0;
  803582:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803587:	c9                   	leaveq 
  803588:	c3                   	retq   

0000000000803589 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803589:	55                   	push   %rbp
  80358a:	48 89 e5             	mov    %rsp,%rbp
  80358d:	48 83 ec 30          	sub    $0x30,%rsp
  803591:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803595:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803599:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  80359d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8035a5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8035aa:	75 0e                	jne    8035ba <ipc_recv+0x31>
		page = (void *)KERNBASE;
  8035ac:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8035b3:	00 00 00 
  8035b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  8035ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035be:	48 89 c7             	mov    %rax,%rdi
  8035c1:	48 b8 49 1f 80 00 00 	movabs $0x801f49,%rax
  8035c8:	00 00 00 
  8035cb:	ff d0                	callq  *%rax
  8035cd:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8035d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8035d4:	79 27                	jns    8035fd <ipc_recv+0x74>
		if (from_env_store != NULL)
  8035d6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8035db:	74 0a                	je     8035e7 <ipc_recv+0x5e>
			*from_env_store = 0;
  8035dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035e1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  8035e7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8035ec:	74 0a                	je     8035f8 <ipc_recv+0x6f>
			*perm_store = 0;
  8035ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8035f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035fb:	eb 53                	jmp    803650 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  8035fd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803602:	74 19                	je     80361d <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  803604:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80360b:	00 00 00 
  80360e:	48 8b 00             	mov    (%rax),%rax
  803611:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803617:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80361b:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  80361d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803622:	74 19                	je     80363d <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803624:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80362b:	00 00 00 
  80362e:	48 8b 00             	mov    (%rax),%rax
  803631:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803637:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80363b:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  80363d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803644:	00 00 00 
  803647:	48 8b 00             	mov    (%rax),%rax
  80364a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803650:	c9                   	leaveq 
  803651:	c3                   	retq   

0000000000803652 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803652:	55                   	push   %rbp
  803653:	48 89 e5             	mov    %rsp,%rbp
  803656:	48 83 ec 30          	sub    $0x30,%rsp
  80365a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80365d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803660:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803664:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803667:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80366b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  80366f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803674:	75 10                	jne    803686 <ipc_send+0x34>
		page = (void *)KERNBASE;
  803676:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  80367d:	00 00 00 
  803680:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803684:	eb 0e                	jmp    803694 <ipc_send+0x42>
  803686:	eb 0c                	jmp    803694 <ipc_send+0x42>
		sys_yield();
  803688:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  80368f:	00 00 00 
  803692:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803694:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803697:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80369a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80369e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036a1:	89 c7                	mov    %eax,%edi
  8036a3:	48 b8 f4 1e 80 00 00 	movabs $0x801ef4,%rax
  8036aa:	00 00 00 
  8036ad:	ff d0                	callq  *%rax
  8036af:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8036b2:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  8036b6:	74 d0                	je     803688 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  8036b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8036bc:	74 2a                	je     8036e8 <ipc_send+0x96>
		panic("error on ipc send procedure");
  8036be:	48 ba 39 3e 80 00 00 	movabs $0x803e39,%rdx
  8036c5:	00 00 00 
  8036c8:	be 49 00 00 00       	mov    $0x49,%esi
  8036cd:	48 bf 55 3e 80 00 00 	movabs $0x803e55,%rdi
  8036d4:	00 00 00 
  8036d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8036dc:	48 b9 10 04 80 00 00 	movabs $0x800410,%rcx
  8036e3:	00 00 00 
  8036e6:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  8036e8:	c9                   	leaveq 
  8036e9:	c3                   	retq   

00000000008036ea <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8036ea:	55                   	push   %rbp
  8036eb:	48 89 e5             	mov    %rsp,%rbp
  8036ee:	48 83 ec 14          	sub    $0x14,%rsp
  8036f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8036f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8036fc:	eb 5e                	jmp    80375c <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8036fe:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803705:	00 00 00 
  803708:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80370b:	48 63 d0             	movslq %eax,%rdx
  80370e:	48 89 d0             	mov    %rdx,%rax
  803711:	48 c1 e0 03          	shl    $0x3,%rax
  803715:	48 01 d0             	add    %rdx,%rax
  803718:	48 c1 e0 05          	shl    $0x5,%rax
  80371c:	48 01 c8             	add    %rcx,%rax
  80371f:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803725:	8b 00                	mov    (%rax),%eax
  803727:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80372a:	75 2c                	jne    803758 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80372c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803733:	00 00 00 
  803736:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803739:	48 63 d0             	movslq %eax,%rdx
  80373c:	48 89 d0             	mov    %rdx,%rax
  80373f:	48 c1 e0 03          	shl    $0x3,%rax
  803743:	48 01 d0             	add    %rdx,%rax
  803746:	48 c1 e0 05          	shl    $0x5,%rax
  80374a:	48 01 c8             	add    %rcx,%rax
  80374d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803753:	8b 40 08             	mov    0x8(%rax),%eax
  803756:	eb 12                	jmp    80376a <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803758:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80375c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803763:	7e 99                	jle    8036fe <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803765:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80376a:	c9                   	leaveq 
  80376b:	c3                   	retq   

000000000080376c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80376c:	55                   	push   %rbp
  80376d:	48 89 e5             	mov    %rsp,%rbp
  803770:	48 83 ec 18          	sub    $0x18,%rsp
  803774:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80377c:	48 c1 e8 15          	shr    $0x15,%rax
  803780:	48 89 c2             	mov    %rax,%rdx
  803783:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80378a:	01 00 00 
  80378d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803791:	83 e0 01             	and    $0x1,%eax
  803794:	48 85 c0             	test   %rax,%rax
  803797:	75 07                	jne    8037a0 <pageref+0x34>
		return 0;
  803799:	b8 00 00 00 00       	mov    $0x0,%eax
  80379e:	eb 53                	jmp    8037f3 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8037a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037a4:	48 c1 e8 0c          	shr    $0xc,%rax
  8037a8:	48 89 c2             	mov    %rax,%rdx
  8037ab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8037b2:	01 00 00 
  8037b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8037bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c1:	83 e0 01             	and    $0x1,%eax
  8037c4:	48 85 c0             	test   %rax,%rax
  8037c7:	75 07                	jne    8037d0 <pageref+0x64>
		return 0;
  8037c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ce:	eb 23                	jmp    8037f3 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8037d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037d4:	48 c1 e8 0c          	shr    $0xc,%rax
  8037d8:	48 89 c2             	mov    %rax,%rdx
  8037db:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8037e2:	00 00 00 
  8037e5:	48 c1 e2 04          	shl    $0x4,%rdx
  8037e9:	48 01 d0             	add    %rdx,%rax
  8037ec:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8037f0:	0f b7 c0             	movzwl %ax,%eax
}
  8037f3:	c9                   	leaveq 
  8037f4:	c3                   	retq   
