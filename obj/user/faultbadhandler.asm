
obj/user/faultbadhandler.debug:     file format elf64-x86-64


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
  80003c:	e8 4f 00 00 00       	callq  800090 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800052:	ba 07 00 00 00       	mov    $0x7,%edx
  800057:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80005c:	bf 00 00 00 00       	mov    $0x0,%edi
  800061:	48 b8 19 03 80 00 00 	movabs $0x800319,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
	sys_env_set_pgfault_upcall(0, (void*) 0xDeadBeef);
  80006d:	be ef be ad de       	mov    $0xdeadbeef,%esi
  800072:	bf 00 00 00 00       	mov    $0x0,%edi
  800077:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  80007e:	00 00 00 
  800081:	ff d0                	callq  *%rax
	*(int*)0 = 0;
  800083:	b8 00 00 00 00       	mov    $0x0,%eax
  800088:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  80008e:	c9                   	leaveq 
  80008f:	c3                   	retq   

0000000000800090 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800090:	55                   	push   %rbp
  800091:	48 89 e5             	mov    %rsp,%rbp
  800094:	48 83 ec 10          	sub    $0x10,%rsp
  800098:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80009b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80009f:	48 b8 9d 02 80 00 00 	movabs $0x80029d,%rax
  8000a6:	00 00 00 
  8000a9:	ff d0                	callq  *%rax
  8000ab:	48 98                	cltq   
  8000ad:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b2:	48 89 c2             	mov    %rax,%rdx
  8000b5:	48 89 d0             	mov    %rdx,%rax
  8000b8:	48 c1 e0 03          	shl    $0x3,%rax
  8000bc:	48 01 d0             	add    %rdx,%rax
  8000bf:	48 c1 e0 05          	shl    $0x5,%rax
  8000c3:	48 89 c2             	mov    %rax,%rdx
  8000c6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000cd:	00 00 00 
  8000d0:	48 01 c2             	add    %rax,%rdx
  8000d3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000da:	00 00 00 
  8000dd:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000e4:	7e 14                	jle    8000fa <libmain+0x6a>
		binaryname = argv[0];
  8000e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000ea:	48 8b 10             	mov    (%rax),%rdx
  8000ed:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000f4:	00 00 00 
  8000f7:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800101:	48 89 d6             	mov    %rdx,%rsi
  800104:	89 c7                	mov    %eax,%edi
  800106:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80010d:	00 00 00 
  800110:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800112:	48 b8 20 01 80 00 00 	movabs $0x800120,%rax
  800119:	00 00 00 
  80011c:	ff d0                	callq  *%rax
}
  80011e:	c9                   	leaveq 
  80011f:	c3                   	retq   

0000000000800120 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800120:	55                   	push   %rbp
  800121:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800124:	48 b8 c7 08 80 00 00 	movabs $0x8008c7,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800130:	bf 00 00 00 00       	mov    $0x0,%edi
  800135:	48 b8 59 02 80 00 00 	movabs $0x800259,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
}
  800141:	5d                   	pop    %rbp
  800142:	c3                   	retq   

0000000000800143 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800143:	55                   	push   %rbp
  800144:	48 89 e5             	mov    %rsp,%rbp
  800147:	53                   	push   %rbx
  800148:	48 83 ec 48          	sub    $0x48,%rsp
  80014c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80014f:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800152:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800156:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80015a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80015e:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800162:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800165:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800169:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80016d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800171:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800175:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800179:	4c 89 c3             	mov    %r8,%rbx
  80017c:	cd 30                	int    $0x30
  80017e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  800182:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800186:	74 3e                	je     8001c6 <syscall+0x83>
  800188:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80018d:	7e 37                	jle    8001c6 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80018f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800193:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800196:	49 89 d0             	mov    %rdx,%r8
  800199:	89 c1                	mov    %eax,%ecx
  80019b:	48 ba 4a 35 80 00 00 	movabs $0x80354a,%rdx
  8001a2:	00 00 00 
  8001a5:	be 23 00 00 00       	mov    $0x23,%esi
  8001aa:	48 bf 67 35 80 00 00 	movabs $0x803567,%rdi
  8001b1:	00 00 00 
  8001b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b9:	49 b9 82 1b 80 00 00 	movabs $0x801b82,%r9
  8001c0:	00 00 00 
  8001c3:	41 ff d1             	callq  *%r9

	return ret;
  8001c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001ca:	48 83 c4 48          	add    $0x48,%rsp
  8001ce:	5b                   	pop    %rbx
  8001cf:	5d                   	pop    %rbp
  8001d0:	c3                   	retq   

00000000008001d1 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001d1:	55                   	push   %rbp
  8001d2:	48 89 e5             	mov    %rsp,%rbp
  8001d5:	48 83 ec 20          	sub    $0x20,%rsp
  8001d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001e9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001f0:	00 
  8001f1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001fd:	48 89 d1             	mov    %rdx,%rcx
  800200:	48 89 c2             	mov    %rax,%rdx
  800203:	be 00 00 00 00       	mov    $0x0,%esi
  800208:	bf 00 00 00 00       	mov    $0x0,%edi
  80020d:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  800214:	00 00 00 
  800217:	ff d0                	callq  *%rax
}
  800219:	c9                   	leaveq 
  80021a:	c3                   	retq   

000000000080021b <sys_cgetc>:

int
sys_cgetc(void)
{
  80021b:	55                   	push   %rbp
  80021c:	48 89 e5             	mov    %rsp,%rbp
  80021f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800223:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80022a:	00 
  80022b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800231:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800237:	b9 00 00 00 00       	mov    $0x0,%ecx
  80023c:	ba 00 00 00 00       	mov    $0x0,%edx
  800241:	be 00 00 00 00       	mov    $0x0,%esi
  800246:	bf 01 00 00 00       	mov    $0x1,%edi
  80024b:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  800252:	00 00 00 
  800255:	ff d0                	callq  *%rax
}
  800257:	c9                   	leaveq 
  800258:	c3                   	retq   

0000000000800259 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800259:	55                   	push   %rbp
  80025a:	48 89 e5             	mov    %rsp,%rbp
  80025d:	48 83 ec 10          	sub    $0x10,%rsp
  800261:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800264:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800267:	48 98                	cltq   
  800269:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800270:	00 
  800271:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800277:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80027d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800282:	48 89 c2             	mov    %rax,%rdx
  800285:	be 01 00 00 00       	mov    $0x1,%esi
  80028a:	bf 03 00 00 00       	mov    $0x3,%edi
  80028f:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  800296:	00 00 00 
  800299:	ff d0                	callq  *%rax
}
  80029b:	c9                   	leaveq 
  80029c:	c3                   	retq   

000000000080029d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80029d:	55                   	push   %rbp
  80029e:	48 89 e5             	mov    %rsp,%rbp
  8002a1:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8002a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002ac:	00 
  8002ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002be:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c3:	be 00 00 00 00       	mov    $0x0,%esi
  8002c8:	bf 02 00 00 00       	mov    $0x2,%edi
  8002cd:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  8002d4:	00 00 00 
  8002d7:	ff d0                	callq  *%rax
}
  8002d9:	c9                   	leaveq 
  8002da:	c3                   	retq   

00000000008002db <sys_yield>:

void
sys_yield(void)
{
  8002db:	55                   	push   %rbp
  8002dc:	48 89 e5             	mov    %rsp,%rbp
  8002df:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002e3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002ea:	00 
  8002eb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002f1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800301:	be 00 00 00 00       	mov    $0x0,%esi
  800306:	bf 0b 00 00 00       	mov    $0xb,%edi
  80030b:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  800312:	00 00 00 
  800315:	ff d0                	callq  *%rax
}
  800317:	c9                   	leaveq 
  800318:	c3                   	retq   

0000000000800319 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800319:	55                   	push   %rbp
  80031a:	48 89 e5             	mov    %rsp,%rbp
  80031d:	48 83 ec 20          	sub    $0x20,%rsp
  800321:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800324:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800328:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80032b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80032e:	48 63 c8             	movslq %eax,%rcx
  800331:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800335:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800338:	48 98                	cltq   
  80033a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800341:	00 
  800342:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800348:	49 89 c8             	mov    %rcx,%r8
  80034b:	48 89 d1             	mov    %rdx,%rcx
  80034e:	48 89 c2             	mov    %rax,%rdx
  800351:	be 01 00 00 00       	mov    $0x1,%esi
  800356:	bf 04 00 00 00       	mov    $0x4,%edi
  80035b:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  800362:	00 00 00 
  800365:	ff d0                	callq  *%rax
}
  800367:	c9                   	leaveq 
  800368:	c3                   	retq   

0000000000800369 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800369:	55                   	push   %rbp
  80036a:	48 89 e5             	mov    %rsp,%rbp
  80036d:	48 83 ec 30          	sub    $0x30,%rsp
  800371:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800374:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800378:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80037b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80037f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800383:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800386:	48 63 c8             	movslq %eax,%rcx
  800389:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80038d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800390:	48 63 f0             	movslq %eax,%rsi
  800393:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800397:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80039a:	48 98                	cltq   
  80039c:	48 89 0c 24          	mov    %rcx,(%rsp)
  8003a0:	49 89 f9             	mov    %rdi,%r9
  8003a3:	49 89 f0             	mov    %rsi,%r8
  8003a6:	48 89 d1             	mov    %rdx,%rcx
  8003a9:	48 89 c2             	mov    %rax,%rdx
  8003ac:	be 01 00 00 00       	mov    $0x1,%esi
  8003b1:	bf 05 00 00 00       	mov    $0x5,%edi
  8003b6:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  8003bd:	00 00 00 
  8003c0:	ff d0                	callq  *%rax
}
  8003c2:	c9                   	leaveq 
  8003c3:	c3                   	retq   

00000000008003c4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003c4:	55                   	push   %rbp
  8003c5:	48 89 e5             	mov    %rsp,%rbp
  8003c8:	48 83 ec 20          	sub    $0x20,%rsp
  8003cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003da:	48 98                	cltq   
  8003dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003e3:	00 
  8003e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003f0:	48 89 d1             	mov    %rdx,%rcx
  8003f3:	48 89 c2             	mov    %rax,%rdx
  8003f6:	be 01 00 00 00       	mov    $0x1,%esi
  8003fb:	bf 06 00 00 00       	mov    $0x6,%edi
  800400:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  800407:	00 00 00 
  80040a:	ff d0                	callq  *%rax
}
  80040c:	c9                   	leaveq 
  80040d:	c3                   	retq   

000000000080040e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80040e:	55                   	push   %rbp
  80040f:	48 89 e5             	mov    %rsp,%rbp
  800412:	48 83 ec 10          	sub    $0x10,%rsp
  800416:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800419:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80041c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80041f:	48 63 d0             	movslq %eax,%rdx
  800422:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800425:	48 98                	cltq   
  800427:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80042e:	00 
  80042f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800435:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80043b:	48 89 d1             	mov    %rdx,%rcx
  80043e:	48 89 c2             	mov    %rax,%rdx
  800441:	be 01 00 00 00       	mov    $0x1,%esi
  800446:	bf 08 00 00 00       	mov    $0x8,%edi
  80044b:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  800452:	00 00 00 
  800455:	ff d0                	callq  *%rax
}
  800457:	c9                   	leaveq 
  800458:	c3                   	retq   

0000000000800459 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800459:	55                   	push   %rbp
  80045a:	48 89 e5             	mov    %rsp,%rbp
  80045d:	48 83 ec 20          	sub    $0x20,%rsp
  800461:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800464:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800468:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80046c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80046f:	48 98                	cltq   
  800471:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800478:	00 
  800479:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80047f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800485:	48 89 d1             	mov    %rdx,%rcx
  800488:	48 89 c2             	mov    %rax,%rdx
  80048b:	be 01 00 00 00       	mov    $0x1,%esi
  800490:	bf 09 00 00 00       	mov    $0x9,%edi
  800495:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  80049c:	00 00 00 
  80049f:	ff d0                	callq  *%rax
}
  8004a1:	c9                   	leaveq 
  8004a2:	c3                   	retq   

00000000008004a3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8004a3:	55                   	push   %rbp
  8004a4:	48 89 e5             	mov    %rsp,%rbp
  8004a7:	48 83 ec 20          	sub    $0x20,%rsp
  8004ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004ae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8004b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004b9:	48 98                	cltq   
  8004bb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004c2:	00 
  8004c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004cf:	48 89 d1             	mov    %rdx,%rcx
  8004d2:	48 89 c2             	mov    %rax,%rdx
  8004d5:	be 01 00 00 00       	mov    $0x1,%esi
  8004da:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004df:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  8004e6:	00 00 00 
  8004e9:	ff d0                	callq  *%rax
}
  8004eb:	c9                   	leaveq 
  8004ec:	c3                   	retq   

00000000008004ed <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004ed:	55                   	push   %rbp
  8004ee:	48 89 e5             	mov    %rsp,%rbp
  8004f1:	48 83 ec 20          	sub    $0x20,%rsp
  8004f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800500:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800503:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800506:	48 63 f0             	movslq %eax,%rsi
  800509:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80050d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800510:	48 98                	cltq   
  800512:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800516:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80051d:	00 
  80051e:	49 89 f1             	mov    %rsi,%r9
  800521:	49 89 c8             	mov    %rcx,%r8
  800524:	48 89 d1             	mov    %rdx,%rcx
  800527:	48 89 c2             	mov    %rax,%rdx
  80052a:	be 00 00 00 00       	mov    $0x0,%esi
  80052f:	bf 0c 00 00 00       	mov    $0xc,%edi
  800534:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  80053b:	00 00 00 
  80053e:	ff d0                	callq  *%rax
}
  800540:	c9                   	leaveq 
  800541:	c3                   	retq   

0000000000800542 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800542:	55                   	push   %rbp
  800543:	48 89 e5             	mov    %rsp,%rbp
  800546:	48 83 ec 10          	sub    $0x10,%rsp
  80054a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80054e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800552:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800559:	00 
  80055a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800560:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800566:	b9 00 00 00 00       	mov    $0x0,%ecx
  80056b:	48 89 c2             	mov    %rax,%rdx
  80056e:	be 01 00 00 00       	mov    $0x1,%esi
  800573:	bf 0d 00 00 00       	mov    $0xd,%edi
  800578:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  80057f:	00 00 00 
  800582:	ff d0                	callq  *%rax
}
  800584:	c9                   	leaveq 
  800585:	c3                   	retq   

0000000000800586 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800586:	55                   	push   %rbp
  800587:	48 89 e5             	mov    %rsp,%rbp
  80058a:	48 83 ec 08          	sub    $0x8,%rsp
  80058e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800592:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800596:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80059d:	ff ff ff 
  8005a0:	48 01 d0             	add    %rdx,%rax
  8005a3:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8005a7:	c9                   	leaveq 
  8005a8:	c3                   	retq   

00000000008005a9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8005a9:	55                   	push   %rbp
  8005aa:	48 89 e5             	mov    %rsp,%rbp
  8005ad:	48 83 ec 08          	sub    $0x8,%rsp
  8005b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8005b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005b9:	48 89 c7             	mov    %rax,%rdi
  8005bc:	48 b8 86 05 80 00 00 	movabs $0x800586,%rax
  8005c3:	00 00 00 
  8005c6:	ff d0                	callq  *%rax
  8005c8:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8005ce:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8005d2:	c9                   	leaveq 
  8005d3:	c3                   	retq   

00000000008005d4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005d4:	55                   	push   %rbp
  8005d5:	48 89 e5             	mov    %rsp,%rbp
  8005d8:	48 83 ec 18          	sub    $0x18,%rsp
  8005dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8005e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005e7:	eb 6b                	jmp    800654 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8005e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005ec:	48 98                	cltq   
  8005ee:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8005f4:	48 c1 e0 0c          	shl    $0xc,%rax
  8005f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800600:	48 c1 e8 15          	shr    $0x15,%rax
  800604:	48 89 c2             	mov    %rax,%rdx
  800607:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80060e:	01 00 00 
  800611:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800615:	83 e0 01             	and    $0x1,%eax
  800618:	48 85 c0             	test   %rax,%rax
  80061b:	74 21                	je     80063e <fd_alloc+0x6a>
  80061d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800621:	48 c1 e8 0c          	shr    $0xc,%rax
  800625:	48 89 c2             	mov    %rax,%rdx
  800628:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80062f:	01 00 00 
  800632:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800636:	83 e0 01             	and    $0x1,%eax
  800639:	48 85 c0             	test   %rax,%rax
  80063c:	75 12                	jne    800650 <fd_alloc+0x7c>
			*fd_store = fd;
  80063e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800642:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800646:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800649:	b8 00 00 00 00       	mov    $0x0,%eax
  80064e:	eb 1a                	jmp    80066a <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800650:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800654:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800658:	7e 8f                	jle    8005e9 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80065a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800665:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80066a:	c9                   	leaveq 
  80066b:	c3                   	retq   

000000000080066c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80066c:	55                   	push   %rbp
  80066d:	48 89 e5             	mov    %rsp,%rbp
  800670:	48 83 ec 20          	sub    $0x20,%rsp
  800674:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800677:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80067b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80067f:	78 06                	js     800687 <fd_lookup+0x1b>
  800681:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800685:	7e 07                	jle    80068e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800687:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80068c:	eb 6c                	jmp    8006fa <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80068e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800691:	48 98                	cltq   
  800693:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800699:	48 c1 e0 0c          	shl    $0xc,%rax
  80069d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8006a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006a5:	48 c1 e8 15          	shr    $0x15,%rax
  8006a9:	48 89 c2             	mov    %rax,%rdx
  8006ac:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8006b3:	01 00 00 
  8006b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006ba:	83 e0 01             	and    $0x1,%eax
  8006bd:	48 85 c0             	test   %rax,%rax
  8006c0:	74 21                	je     8006e3 <fd_lookup+0x77>
  8006c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006c6:	48 c1 e8 0c          	shr    $0xc,%rax
  8006ca:	48 89 c2             	mov    %rax,%rdx
  8006cd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006d4:	01 00 00 
  8006d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006db:	83 e0 01             	and    $0x1,%eax
  8006de:	48 85 c0             	test   %rax,%rax
  8006e1:	75 07                	jne    8006ea <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006e8:	eb 10                	jmp    8006fa <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8006ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006f2:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8006f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006fa:	c9                   	leaveq 
  8006fb:	c3                   	retq   

00000000008006fc <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006fc:	55                   	push   %rbp
  8006fd:	48 89 e5             	mov    %rsp,%rbp
  800700:	48 83 ec 30          	sub    $0x30,%rsp
  800704:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800708:	89 f0                	mov    %esi,%eax
  80070a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80070d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800711:	48 89 c7             	mov    %rax,%rdi
  800714:	48 b8 86 05 80 00 00 	movabs $0x800586,%rax
  80071b:	00 00 00 
  80071e:	ff d0                	callq  *%rax
  800720:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800724:	48 89 d6             	mov    %rdx,%rsi
  800727:	89 c7                	mov    %eax,%edi
  800729:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800730:	00 00 00 
  800733:	ff d0                	callq  *%rax
  800735:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800738:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80073c:	78 0a                	js     800748 <fd_close+0x4c>
	    || fd != fd2)
  80073e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800742:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800746:	74 12                	je     80075a <fd_close+0x5e>
		return (must_exist ? r : 0);
  800748:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80074c:	74 05                	je     800753 <fd_close+0x57>
  80074e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800751:	eb 05                	jmp    800758 <fd_close+0x5c>
  800753:	b8 00 00 00 00       	mov    $0x0,%eax
  800758:	eb 69                	jmp    8007c3 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80075a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80075e:	8b 00                	mov    (%rax),%eax
  800760:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800764:	48 89 d6             	mov    %rdx,%rsi
  800767:	89 c7                	mov    %eax,%edi
  800769:	48 b8 c5 07 80 00 00 	movabs $0x8007c5,%rax
  800770:	00 00 00 
  800773:	ff d0                	callq  *%rax
  800775:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800778:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80077c:	78 2a                	js     8007a8 <fd_close+0xac>
		if (dev->dev_close)
  80077e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800782:	48 8b 40 20          	mov    0x20(%rax),%rax
  800786:	48 85 c0             	test   %rax,%rax
  800789:	74 16                	je     8007a1 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80078b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078f:	48 8b 40 20          	mov    0x20(%rax),%rax
  800793:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800797:	48 89 d7             	mov    %rdx,%rdi
  80079a:	ff d0                	callq  *%rax
  80079c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80079f:	eb 07                	jmp    8007a8 <fd_close+0xac>
		else
			r = 0;
  8007a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8007a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007ac:	48 89 c6             	mov    %rax,%rsi
  8007af:	bf 00 00 00 00       	mov    $0x0,%edi
  8007b4:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  8007bb:	00 00 00 
  8007be:	ff d0                	callq  *%rax
	return r;
  8007c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007c3:	c9                   	leaveq 
  8007c4:	c3                   	retq   

00000000008007c5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8007c5:	55                   	push   %rbp
  8007c6:	48 89 e5             	mov    %rsp,%rbp
  8007c9:	48 83 ec 20          	sub    $0x20,%rsp
  8007cd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8007d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8007d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8007db:	eb 41                	jmp    80081e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8007dd:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007e4:	00 00 00 
  8007e7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007ea:	48 63 d2             	movslq %edx,%rdx
  8007ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007f1:	8b 00                	mov    (%rax),%eax
  8007f3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8007f6:	75 22                	jne    80081a <dev_lookup+0x55>
			*dev = devtab[i];
  8007f8:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007ff:	00 00 00 
  800802:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800805:	48 63 d2             	movslq %edx,%rdx
  800808:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80080c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800810:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800813:	b8 00 00 00 00       	mov    $0x0,%eax
  800818:	eb 60                	jmp    80087a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80081a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80081e:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800825:	00 00 00 
  800828:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80082b:	48 63 d2             	movslq %edx,%rdx
  80082e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800832:	48 85 c0             	test   %rax,%rax
  800835:	75 a6                	jne    8007dd <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800837:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80083e:	00 00 00 
  800841:	48 8b 00             	mov    (%rax),%rax
  800844:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80084a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80084d:	89 c6                	mov    %eax,%esi
  80084f:	48 bf 78 35 80 00 00 	movabs $0x803578,%rdi
  800856:	00 00 00 
  800859:	b8 00 00 00 00       	mov    $0x0,%eax
  80085e:	48 b9 bb 1d 80 00 00 	movabs $0x801dbb,%rcx
  800865:	00 00 00 
  800868:	ff d1                	callq  *%rcx
	*dev = 0;
  80086a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80086e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  800875:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80087a:	c9                   	leaveq 
  80087b:	c3                   	retq   

000000000080087c <close>:

int
close(int fdnum)
{
  80087c:	55                   	push   %rbp
  80087d:	48 89 e5             	mov    %rsp,%rbp
  800880:	48 83 ec 20          	sub    $0x20,%rsp
  800884:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800887:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80088b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80088e:	48 89 d6             	mov    %rdx,%rsi
  800891:	89 c7                	mov    %eax,%edi
  800893:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  80089a:	00 00 00 
  80089d:	ff d0                	callq  *%rax
  80089f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008a6:	79 05                	jns    8008ad <close+0x31>
		return r;
  8008a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008ab:	eb 18                	jmp    8008c5 <close+0x49>
	else
		return fd_close(fd, 1);
  8008ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008b1:	be 01 00 00 00       	mov    $0x1,%esi
  8008b6:	48 89 c7             	mov    %rax,%rdi
  8008b9:	48 b8 fc 06 80 00 00 	movabs $0x8006fc,%rax
  8008c0:	00 00 00 
  8008c3:	ff d0                	callq  *%rax
}
  8008c5:	c9                   	leaveq 
  8008c6:	c3                   	retq   

00000000008008c7 <close_all>:

void
close_all(void)
{
  8008c7:	55                   	push   %rbp
  8008c8:	48 89 e5             	mov    %rsp,%rbp
  8008cb:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8008cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008d6:	eb 15                	jmp    8008ed <close_all+0x26>
		close(i);
  8008d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008db:	89 c7                	mov    %eax,%edi
  8008dd:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  8008e4:	00 00 00 
  8008e7:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8008e9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008ed:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8008f1:	7e e5                	jle    8008d8 <close_all+0x11>
		close(i);
}
  8008f3:	c9                   	leaveq 
  8008f4:	c3                   	retq   

00000000008008f5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8008f5:	55                   	push   %rbp
  8008f6:	48 89 e5             	mov    %rsp,%rbp
  8008f9:	48 83 ec 40          	sub    $0x40,%rsp
  8008fd:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800900:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800903:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  800907:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80090a:	48 89 d6             	mov    %rdx,%rsi
  80090d:	89 c7                	mov    %eax,%edi
  80090f:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800916:	00 00 00 
  800919:	ff d0                	callq  *%rax
  80091b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80091e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800922:	79 08                	jns    80092c <dup+0x37>
		return r;
  800924:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800927:	e9 70 01 00 00       	jmpq   800a9c <dup+0x1a7>
	close(newfdnum);
  80092c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80092f:	89 c7                	mov    %eax,%edi
  800931:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  800938:	00 00 00 
  80093b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80093d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800940:	48 98                	cltq   
  800942:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800948:	48 c1 e0 0c          	shl    $0xc,%rax
  80094c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800950:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800954:	48 89 c7             	mov    %rax,%rdi
  800957:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  80095e:	00 00 00 
  800961:	ff d0                	callq  *%rax
  800963:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800967:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80096b:	48 89 c7             	mov    %rax,%rdi
  80096e:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  800975:	00 00 00 
  800978:	ff d0                	callq  *%rax
  80097a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80097e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800982:	48 c1 e8 15          	shr    $0x15,%rax
  800986:	48 89 c2             	mov    %rax,%rdx
  800989:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800990:	01 00 00 
  800993:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800997:	83 e0 01             	and    $0x1,%eax
  80099a:	48 85 c0             	test   %rax,%rax
  80099d:	74 73                	je     800a12 <dup+0x11d>
  80099f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a3:	48 c1 e8 0c          	shr    $0xc,%rax
  8009a7:	48 89 c2             	mov    %rax,%rdx
  8009aa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009b1:	01 00 00 
  8009b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009b8:	83 e0 01             	and    $0x1,%eax
  8009bb:	48 85 c0             	test   %rax,%rax
  8009be:	74 52                	je     800a12 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8009c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c4:	48 c1 e8 0c          	shr    $0xc,%rax
  8009c8:	48 89 c2             	mov    %rax,%rdx
  8009cb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009d2:	01 00 00 
  8009d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009d9:	25 07 0e 00 00       	and    $0xe07,%eax
  8009de:	89 c1                	mov    %eax,%ecx
  8009e0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e8:	41 89 c8             	mov    %ecx,%r8d
  8009eb:	48 89 d1             	mov    %rdx,%rcx
  8009ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f3:	48 89 c6             	mov    %rax,%rsi
  8009f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8009fb:	48 b8 69 03 80 00 00 	movabs $0x800369,%rax
  800a02:	00 00 00 
  800a05:	ff d0                	callq  *%rax
  800a07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a0e:	79 02                	jns    800a12 <dup+0x11d>
			goto err;
  800a10:	eb 57                	jmp    800a69 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800a12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a16:	48 c1 e8 0c          	shr    $0xc,%rax
  800a1a:	48 89 c2             	mov    %rax,%rdx
  800a1d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a24:	01 00 00 
  800a27:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a2b:	25 07 0e 00 00       	and    $0xe07,%eax
  800a30:	89 c1                	mov    %eax,%ecx
  800a32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a36:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a3a:	41 89 c8             	mov    %ecx,%r8d
  800a3d:	48 89 d1             	mov    %rdx,%rcx
  800a40:	ba 00 00 00 00       	mov    $0x0,%edx
  800a45:	48 89 c6             	mov    %rax,%rsi
  800a48:	bf 00 00 00 00       	mov    $0x0,%edi
  800a4d:	48 b8 69 03 80 00 00 	movabs $0x800369,%rax
  800a54:	00 00 00 
  800a57:	ff d0                	callq  *%rax
  800a59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a60:	79 02                	jns    800a64 <dup+0x16f>
		goto err;
  800a62:	eb 05                	jmp    800a69 <dup+0x174>

	return newfdnum;
  800a64:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a67:	eb 33                	jmp    800a9c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800a69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a6d:	48 89 c6             	mov    %rax,%rsi
  800a70:	bf 00 00 00 00       	mov    $0x0,%edi
  800a75:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  800a7c:	00 00 00 
  800a7f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800a81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a85:	48 89 c6             	mov    %rax,%rsi
  800a88:	bf 00 00 00 00       	mov    $0x0,%edi
  800a8d:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  800a94:	00 00 00 
  800a97:	ff d0                	callq  *%rax
	return r;
  800a99:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800a9c:	c9                   	leaveq 
  800a9d:	c3                   	retq   

0000000000800a9e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a9e:	55                   	push   %rbp
  800a9f:	48 89 e5             	mov    %rsp,%rbp
  800aa2:	48 83 ec 40          	sub    $0x40,%rsp
  800aa6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800aa9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800aad:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ab1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800ab5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800ab8:	48 89 d6             	mov    %rdx,%rsi
  800abb:	89 c7                	mov    %eax,%edi
  800abd:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800ac4:	00 00 00 
  800ac7:	ff d0                	callq  *%rax
  800ac9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800acc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ad0:	78 24                	js     800af6 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ad2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad6:	8b 00                	mov    (%rax),%eax
  800ad8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800adc:	48 89 d6             	mov    %rdx,%rsi
  800adf:	89 c7                	mov    %eax,%edi
  800ae1:	48 b8 c5 07 80 00 00 	movabs $0x8007c5,%rax
  800ae8:	00 00 00 
  800aeb:	ff d0                	callq  *%rax
  800aed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800af0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800af4:	79 05                	jns    800afb <read+0x5d>
		return r;
  800af6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800af9:	eb 76                	jmp    800b71 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800afb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aff:	8b 40 08             	mov    0x8(%rax),%eax
  800b02:	83 e0 03             	and    $0x3,%eax
  800b05:	83 f8 01             	cmp    $0x1,%eax
  800b08:	75 3a                	jne    800b44 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800b0a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b11:	00 00 00 
  800b14:	48 8b 00             	mov    (%rax),%rax
  800b17:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800b1d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800b20:	89 c6                	mov    %eax,%esi
  800b22:	48 bf 97 35 80 00 00 	movabs $0x803597,%rdi
  800b29:	00 00 00 
  800b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b31:	48 b9 bb 1d 80 00 00 	movabs $0x801dbb,%rcx
  800b38:	00 00 00 
  800b3b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800b3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b42:	eb 2d                	jmp    800b71 <read+0xd3>
	}
	if (!dev->dev_read)
  800b44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b48:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b4c:	48 85 c0             	test   %rax,%rax
  800b4f:	75 07                	jne    800b58 <read+0xba>
		return -E_NOT_SUPP;
  800b51:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800b56:	eb 19                	jmp    800b71 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800b58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b5c:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b60:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800b64:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b68:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800b6c:	48 89 cf             	mov    %rcx,%rdi
  800b6f:	ff d0                	callq  *%rax
}
  800b71:	c9                   	leaveq 
  800b72:	c3                   	retq   

0000000000800b73 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b73:	55                   	push   %rbp
  800b74:	48 89 e5             	mov    %rsp,%rbp
  800b77:	48 83 ec 30          	sub    $0x30,%rsp
  800b7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800b7e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800b82:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800b8d:	eb 49                	jmp    800bd8 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b92:	48 98                	cltq   
  800b94:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800b98:	48 29 c2             	sub    %rax,%rdx
  800b9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b9e:	48 63 c8             	movslq %eax,%rcx
  800ba1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ba5:	48 01 c1             	add    %rax,%rcx
  800ba8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800bab:	48 89 ce             	mov    %rcx,%rsi
  800bae:	89 c7                	mov    %eax,%edi
  800bb0:	48 b8 9e 0a 80 00 00 	movabs $0x800a9e,%rax
  800bb7:	00 00 00 
  800bba:	ff d0                	callq  *%rax
  800bbc:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800bbf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800bc3:	79 05                	jns    800bca <readn+0x57>
			return m;
  800bc5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bc8:	eb 1c                	jmp    800be6 <readn+0x73>
		if (m == 0)
  800bca:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800bce:	75 02                	jne    800bd2 <readn+0x5f>
			break;
  800bd0:	eb 11                	jmp    800be3 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800bd2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bd5:	01 45 fc             	add    %eax,-0x4(%rbp)
  800bd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bdb:	48 98                	cltq   
  800bdd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800be1:	72 ac                	jb     800b8f <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800be3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800be6:	c9                   	leaveq 
  800be7:	c3                   	retq   

0000000000800be8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800be8:	55                   	push   %rbp
  800be9:	48 89 e5             	mov    %rsp,%rbp
  800bec:	48 83 ec 40          	sub    $0x40,%rsp
  800bf0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bf3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800bf7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bfb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800bff:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800c02:	48 89 d6             	mov    %rdx,%rsi
  800c05:	89 c7                	mov    %eax,%edi
  800c07:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800c0e:	00 00 00 
  800c11:	ff d0                	callq  *%rax
  800c13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c1a:	78 24                	js     800c40 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c20:	8b 00                	mov    (%rax),%eax
  800c22:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c26:	48 89 d6             	mov    %rdx,%rsi
  800c29:	89 c7                	mov    %eax,%edi
  800c2b:	48 b8 c5 07 80 00 00 	movabs $0x8007c5,%rax
  800c32:	00 00 00 
  800c35:	ff d0                	callq  *%rax
  800c37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c3e:	79 05                	jns    800c45 <write+0x5d>
		return r;
  800c40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c43:	eb 75                	jmp    800cba <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c49:	8b 40 08             	mov    0x8(%rax),%eax
  800c4c:	83 e0 03             	and    $0x3,%eax
  800c4f:	85 c0                	test   %eax,%eax
  800c51:	75 3a                	jne    800c8d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c53:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c5a:	00 00 00 
  800c5d:	48 8b 00             	mov    (%rax),%rax
  800c60:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c66:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c69:	89 c6                	mov    %eax,%esi
  800c6b:	48 bf b3 35 80 00 00 	movabs $0x8035b3,%rdi
  800c72:	00 00 00 
  800c75:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7a:	48 b9 bb 1d 80 00 00 	movabs $0x801dbb,%rcx
  800c81:	00 00 00 
  800c84:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c86:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c8b:	eb 2d                	jmp    800cba <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c91:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c95:	48 85 c0             	test   %rax,%rax
  800c98:	75 07                	jne    800ca1 <write+0xb9>
		return -E_NOT_SUPP;
  800c9a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c9f:	eb 19                	jmp    800cba <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800ca1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca5:	48 8b 40 18          	mov    0x18(%rax),%rax
  800ca9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800cad:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cb1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800cb5:	48 89 cf             	mov    %rcx,%rdi
  800cb8:	ff d0                	callq  *%rax
}
  800cba:	c9                   	leaveq 
  800cbb:	c3                   	retq   

0000000000800cbc <seek>:

int
seek(int fdnum, off_t offset)
{
  800cbc:	55                   	push   %rbp
  800cbd:	48 89 e5             	mov    %rsp,%rbp
  800cc0:	48 83 ec 18          	sub    $0x18,%rsp
  800cc4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800cc7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800cca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800cce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800cd1:	48 89 d6             	mov    %rdx,%rsi
  800cd4:	89 c7                	mov    %eax,%edi
  800cd6:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800cdd:	00 00 00 
  800ce0:	ff d0                	callq  *%rax
  800ce2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ce5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ce9:	79 05                	jns    800cf0 <seek+0x34>
		return r;
  800ceb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cee:	eb 0f                	jmp    800cff <seek+0x43>
	fd->fd_offset = offset;
  800cf0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cf4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800cf7:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800cfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cff:	c9                   	leaveq 
  800d00:	c3                   	retq   

0000000000800d01 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800d01:	55                   	push   %rbp
  800d02:	48 89 e5             	mov    %rsp,%rbp
  800d05:	48 83 ec 30          	sub    $0x30,%rsp
  800d09:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800d0c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d0f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d13:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800d16:	48 89 d6             	mov    %rdx,%rsi
  800d19:	89 c7                	mov    %eax,%edi
  800d1b:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800d22:	00 00 00 
  800d25:	ff d0                	callq  *%rax
  800d27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d2e:	78 24                	js     800d54 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d34:	8b 00                	mov    (%rax),%eax
  800d36:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d3a:	48 89 d6             	mov    %rdx,%rsi
  800d3d:	89 c7                	mov    %eax,%edi
  800d3f:	48 b8 c5 07 80 00 00 	movabs $0x8007c5,%rax
  800d46:	00 00 00 
  800d49:	ff d0                	callq  *%rax
  800d4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d52:	79 05                	jns    800d59 <ftruncate+0x58>
		return r;
  800d54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d57:	eb 72                	jmp    800dcb <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d5d:	8b 40 08             	mov    0x8(%rax),%eax
  800d60:	83 e0 03             	and    $0x3,%eax
  800d63:	85 c0                	test   %eax,%eax
  800d65:	75 3a                	jne    800da1 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800d67:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d6e:	00 00 00 
  800d71:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d74:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d7a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d7d:	89 c6                	mov    %eax,%esi
  800d7f:	48 bf d0 35 80 00 00 	movabs $0x8035d0,%rdi
  800d86:	00 00 00 
  800d89:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8e:	48 b9 bb 1d 80 00 00 	movabs $0x801dbb,%rcx
  800d95:	00 00 00 
  800d98:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800d9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d9f:	eb 2a                	jmp    800dcb <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800da1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800da5:	48 8b 40 30          	mov    0x30(%rax),%rax
  800da9:	48 85 c0             	test   %rax,%rax
  800dac:	75 07                	jne    800db5 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800dae:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800db3:	eb 16                	jmp    800dcb <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800db5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800db9:	48 8b 40 30          	mov    0x30(%rax),%rax
  800dbd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dc1:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800dc4:	89 ce                	mov    %ecx,%esi
  800dc6:	48 89 d7             	mov    %rdx,%rdi
  800dc9:	ff d0                	callq  *%rax
}
  800dcb:	c9                   	leaveq 
  800dcc:	c3                   	retq   

0000000000800dcd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800dcd:	55                   	push   %rbp
  800dce:	48 89 e5             	mov    %rsp,%rbp
  800dd1:	48 83 ec 30          	sub    $0x30,%rsp
  800dd5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800dd8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ddc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800de0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800de3:	48 89 d6             	mov    %rdx,%rsi
  800de6:	89 c7                	mov    %eax,%edi
  800de8:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800def:	00 00 00 
  800df2:	ff d0                	callq  *%rax
  800df4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800df7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dfb:	78 24                	js     800e21 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800dfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e01:	8b 00                	mov    (%rax),%eax
  800e03:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e07:	48 89 d6             	mov    %rdx,%rsi
  800e0a:	89 c7                	mov    %eax,%edi
  800e0c:	48 b8 c5 07 80 00 00 	movabs $0x8007c5,%rax
  800e13:	00 00 00 
  800e16:	ff d0                	callq  *%rax
  800e18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e1f:	79 05                	jns    800e26 <fstat+0x59>
		return r;
  800e21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e24:	eb 5e                	jmp    800e84 <fstat+0xb7>
	if (!dev->dev_stat)
  800e26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2a:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e2e:	48 85 c0             	test   %rax,%rax
  800e31:	75 07                	jne    800e3a <fstat+0x6d>
		return -E_NOT_SUPP;
  800e33:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e38:	eb 4a                	jmp    800e84 <fstat+0xb7>
	stat->st_name[0] = 0;
  800e3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e3e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800e41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e45:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800e4c:	00 00 00 
	stat->st_isdir = 0;
  800e4f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e53:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800e5a:	00 00 00 
	stat->st_dev = dev;
  800e5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e61:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e65:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800e6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e70:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e78:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800e7c:	48 89 ce             	mov    %rcx,%rsi
  800e7f:	48 89 d7             	mov    %rdx,%rdi
  800e82:	ff d0                	callq  *%rax
}
  800e84:	c9                   	leaveq 
  800e85:	c3                   	retq   

0000000000800e86 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800e86:	55                   	push   %rbp
  800e87:	48 89 e5             	mov    %rsp,%rbp
  800e8a:	48 83 ec 20          	sub    $0x20,%rsp
  800e8e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e92:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9a:	be 00 00 00 00       	mov    $0x0,%esi
  800e9f:	48 89 c7             	mov    %rax,%rdi
  800ea2:	48 b8 74 0f 80 00 00 	movabs $0x800f74,%rax
  800ea9:	00 00 00 
  800eac:	ff d0                	callq  *%rax
  800eae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800eb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800eb5:	79 05                	jns    800ebc <stat+0x36>
		return fd;
  800eb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eba:	eb 2f                	jmp    800eeb <stat+0x65>
	r = fstat(fd, stat);
  800ebc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ec0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ec3:	48 89 d6             	mov    %rdx,%rsi
  800ec6:	89 c7                	mov    %eax,%edi
  800ec8:	48 b8 cd 0d 80 00 00 	movabs $0x800dcd,%rax
  800ecf:	00 00 00 
  800ed2:	ff d0                	callq  *%rax
  800ed4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800ed7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eda:	89 c7                	mov    %eax,%edi
  800edc:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  800ee3:	00 00 00 
  800ee6:	ff d0                	callq  *%rax
	return r;
  800ee8:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800eeb:	c9                   	leaveq 
  800eec:	c3                   	retq   

0000000000800eed <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800eed:	55                   	push   %rbp
  800eee:	48 89 e5             	mov    %rsp,%rbp
  800ef1:	48 83 ec 10          	sub    $0x10,%rsp
  800ef5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ef8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800efc:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f03:	00 00 00 
  800f06:	8b 00                	mov    (%rax),%eax
  800f08:	85 c0                	test   %eax,%eax
  800f0a:	75 1d                	jne    800f29 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800f0c:	bf 01 00 00 00       	mov    $0x1,%edi
  800f11:	48 b8 1d 34 80 00 00 	movabs $0x80341d,%rax
  800f18:	00 00 00 
  800f1b:	ff d0                	callq  *%rax
  800f1d:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800f24:	00 00 00 
  800f27:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f29:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f30:	00 00 00 
  800f33:	8b 00                	mov    (%rax),%eax
  800f35:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800f38:	b9 07 00 00 00       	mov    $0x7,%ecx
  800f3d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f44:	00 00 00 
  800f47:	89 c7                	mov    %eax,%edi
  800f49:	48 b8 85 33 80 00 00 	movabs $0x803385,%rax
  800f50:	00 00 00 
  800f53:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800f55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f59:	ba 00 00 00 00       	mov    $0x0,%edx
  800f5e:	48 89 c6             	mov    %rax,%rsi
  800f61:	bf 00 00 00 00       	mov    $0x0,%edi
  800f66:	48 b8 bc 32 80 00 00 	movabs $0x8032bc,%rax
  800f6d:	00 00 00 
  800f70:	ff d0                	callq  *%rax
}
  800f72:	c9                   	leaveq 
  800f73:	c3                   	retq   

0000000000800f74 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800f74:	55                   	push   %rbp
  800f75:	48 89 e5             	mov    %rsp,%rbp
  800f78:	48 83 ec 20          	sub    $0x20,%rsp
  800f7c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f80:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  800f83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f87:	48 89 c7             	mov    %rax,%rdi
  800f8a:	48 b8 f7 2a 80 00 00 	movabs $0x802af7,%rax
  800f91:	00 00 00 
  800f94:	ff d0                	callq  *%rax
  800f96:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f9b:	7e 0a                	jle    800fa7 <open+0x33>
		return -E_BAD_PATH;
  800f9d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800fa2:	e9 a5 00 00 00       	jmpq   80104c <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  800fa7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800fab:	48 89 c7             	mov    %rax,%rdi
  800fae:	48 b8 d4 05 80 00 00 	movabs $0x8005d4,%rax
  800fb5:	00 00 00 
  800fb8:	ff d0                	callq  *%rax
  800fba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fc1:	79 08                	jns    800fcb <open+0x57>
		return r;
  800fc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fc6:	e9 81 00 00 00       	jmpq   80104c <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  800fcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fcf:	48 89 c6             	mov    %rax,%rsi
  800fd2:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  800fd9:	00 00 00 
  800fdc:	48 b8 63 2b 80 00 00 	movabs $0x802b63,%rax
  800fe3:	00 00 00 
  800fe6:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  800fe8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fef:	00 00 00 
  800ff2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800ff5:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fff:	48 89 c6             	mov    %rax,%rsi
  801002:	bf 01 00 00 00       	mov    $0x1,%edi
  801007:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  80100e:	00 00 00 
  801011:	ff d0                	callq  *%rax
  801013:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801016:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80101a:	79 1d                	jns    801039 <open+0xc5>
		fd_close(fd, 0);
  80101c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801020:	be 00 00 00 00       	mov    $0x0,%esi
  801025:	48 89 c7             	mov    %rax,%rdi
  801028:	48 b8 fc 06 80 00 00 	movabs $0x8006fc,%rax
  80102f:	00 00 00 
  801032:	ff d0                	callq  *%rax
		return r;
  801034:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801037:	eb 13                	jmp    80104c <open+0xd8>
	}

	return fd2num(fd);
  801039:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80103d:	48 89 c7             	mov    %rax,%rdi
  801040:	48 b8 86 05 80 00 00 	movabs $0x800586,%rax
  801047:	00 00 00 
  80104a:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  80104c:	c9                   	leaveq 
  80104d:	c3                   	retq   

000000000080104e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80104e:	55                   	push   %rbp
  80104f:	48 89 e5             	mov    %rsp,%rbp
  801052:	48 83 ec 10          	sub    $0x10,%rsp
  801056:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80105a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105e:	8b 50 0c             	mov    0xc(%rax),%edx
  801061:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801068:	00 00 00 
  80106b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80106d:	be 00 00 00 00       	mov    $0x0,%esi
  801072:	bf 06 00 00 00       	mov    $0x6,%edi
  801077:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  80107e:	00 00 00 
  801081:	ff d0                	callq  *%rax
}
  801083:	c9                   	leaveq 
  801084:	c3                   	retq   

0000000000801085 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801085:	55                   	push   %rbp
  801086:	48 89 e5             	mov    %rsp,%rbp
  801089:	48 83 ec 30          	sub    $0x30,%rsp
  80108d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801091:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801095:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801099:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109d:	8b 50 0c             	mov    0xc(%rax),%edx
  8010a0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8010a7:	00 00 00 
  8010aa:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8010ac:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8010b3:	00 00 00 
  8010b6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8010ba:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8010be:	be 00 00 00 00       	mov    $0x0,%esi
  8010c3:	bf 03 00 00 00       	mov    $0x3,%edi
  8010c8:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  8010cf:	00 00 00 
  8010d2:	ff d0                	callq  *%rax
  8010d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010db:	79 05                	jns    8010e2 <devfile_read+0x5d>
		return r;
  8010dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010e0:	eb 26                	jmp    801108 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8010e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010e5:	48 63 d0             	movslq %eax,%rdx
  8010e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010ec:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8010f3:	00 00 00 
  8010f6:	48 89 c7             	mov    %rax,%rdi
  8010f9:	48 b8 87 2e 80 00 00 	movabs $0x802e87,%rax
  801100:	00 00 00 
  801103:	ff d0                	callq  *%rax

	return r;
  801105:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  801108:	c9                   	leaveq 
  801109:	c3                   	retq   

000000000080110a <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80110a:	55                   	push   %rbp
  80110b:	48 89 e5             	mov    %rsp,%rbp
  80110e:	48 83 ec 30          	sub    $0x30,%rsp
  801112:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801116:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80111a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  80111e:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801125:	00 
  801126:	76 08                	jbe    801130 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  801128:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80112f:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801134:	8b 50 0c             	mov    0xc(%rax),%edx
  801137:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80113e:	00 00 00 
  801141:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  801143:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80114a:	00 00 00 
  80114d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801151:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  801155:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801159:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80115d:	48 89 c6             	mov    %rax,%rsi
  801160:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  801167:	00 00 00 
  80116a:	48 b8 87 2e 80 00 00 	movabs $0x802e87,%rax
  801171:	00 00 00 
  801174:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801176:	be 00 00 00 00       	mov    $0x0,%esi
  80117b:	bf 04 00 00 00       	mov    $0x4,%edi
  801180:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  801187:	00 00 00 
  80118a:	ff d0                	callq  *%rax
  80118c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80118f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801193:	79 05                	jns    80119a <devfile_write+0x90>
		return r;
  801195:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801198:	eb 03                	jmp    80119d <devfile_write+0x93>

	return r;
  80119a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80119d:	c9                   	leaveq 
  80119e:	c3                   	retq   

000000000080119f <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80119f:	55                   	push   %rbp
  8011a0:	48 89 e5             	mov    %rsp,%rbp
  8011a3:	48 83 ec 20          	sub    $0x20,%rsp
  8011a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8011af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b3:	8b 50 0c             	mov    0xc(%rax),%edx
  8011b6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011bd:	00 00 00 
  8011c0:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8011c2:	be 00 00 00 00       	mov    $0x0,%esi
  8011c7:	bf 05 00 00 00       	mov    $0x5,%edi
  8011cc:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  8011d3:	00 00 00 
  8011d6:	ff d0                	callq  *%rax
  8011d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011df:	79 05                	jns    8011e6 <devfile_stat+0x47>
		return r;
  8011e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011e4:	eb 56                	jmp    80123c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8011e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ea:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8011f1:	00 00 00 
  8011f4:	48 89 c7             	mov    %rax,%rdi
  8011f7:	48 b8 63 2b 80 00 00 	movabs $0x802b63,%rax
  8011fe:	00 00 00 
  801201:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801203:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80120a:	00 00 00 
  80120d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801213:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801217:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80121d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801224:	00 00 00 
  801227:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80122d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801231:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801237:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80123c:	c9                   	leaveq 
  80123d:	c3                   	retq   

000000000080123e <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80123e:	55                   	push   %rbp
  80123f:	48 89 e5             	mov    %rsp,%rbp
  801242:	48 83 ec 10          	sub    $0x10,%rsp
  801246:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80124a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80124d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801251:	8b 50 0c             	mov    0xc(%rax),%edx
  801254:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80125b:	00 00 00 
  80125e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801260:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801267:	00 00 00 
  80126a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80126d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801270:	be 00 00 00 00       	mov    $0x0,%esi
  801275:	bf 02 00 00 00       	mov    $0x2,%edi
  80127a:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  801281:	00 00 00 
  801284:	ff d0                	callq  *%rax
}
  801286:	c9                   	leaveq 
  801287:	c3                   	retq   

0000000000801288 <remove>:

// Delete a file
int
remove(const char *path)
{
  801288:	55                   	push   %rbp
  801289:	48 89 e5             	mov    %rsp,%rbp
  80128c:	48 83 ec 10          	sub    $0x10,%rsp
  801290:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801294:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801298:	48 89 c7             	mov    %rax,%rdi
  80129b:	48 b8 f7 2a 80 00 00 	movabs $0x802af7,%rax
  8012a2:	00 00 00 
  8012a5:	ff d0                	callq  *%rax
  8012a7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8012ac:	7e 07                	jle    8012b5 <remove+0x2d>
		return -E_BAD_PATH;
  8012ae:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8012b3:	eb 33                	jmp    8012e8 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8012b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b9:	48 89 c6             	mov    %rax,%rsi
  8012bc:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8012c3:	00 00 00 
  8012c6:	48 b8 63 2b 80 00 00 	movabs $0x802b63,%rax
  8012cd:	00 00 00 
  8012d0:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8012d2:	be 00 00 00 00       	mov    $0x0,%esi
  8012d7:	bf 07 00 00 00       	mov    $0x7,%edi
  8012dc:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  8012e3:	00 00 00 
  8012e6:	ff d0                	callq  *%rax
}
  8012e8:	c9                   	leaveq 
  8012e9:	c3                   	retq   

00000000008012ea <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8012ea:	55                   	push   %rbp
  8012eb:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8012ee:	be 00 00 00 00       	mov    $0x0,%esi
  8012f3:	bf 08 00 00 00       	mov    $0x8,%edi
  8012f8:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  8012ff:	00 00 00 
  801302:	ff d0                	callq  *%rax
}
  801304:	5d                   	pop    %rbp
  801305:	c3                   	retq   

0000000000801306 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801306:	55                   	push   %rbp
  801307:	48 89 e5             	mov    %rsp,%rbp
  80130a:	53                   	push   %rbx
  80130b:	48 83 ec 38          	sub    $0x38,%rsp
  80130f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801313:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  801317:	48 89 c7             	mov    %rax,%rdi
  80131a:	48 b8 d4 05 80 00 00 	movabs $0x8005d4,%rax
  801321:	00 00 00 
  801324:	ff d0                	callq  *%rax
  801326:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801329:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80132d:	0f 88 bf 01 00 00    	js     8014f2 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801333:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801337:	ba 07 04 00 00       	mov    $0x407,%edx
  80133c:	48 89 c6             	mov    %rax,%rsi
  80133f:	bf 00 00 00 00       	mov    $0x0,%edi
  801344:	48 b8 19 03 80 00 00 	movabs $0x800319,%rax
  80134b:	00 00 00 
  80134e:	ff d0                	callq  *%rax
  801350:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801353:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801357:	0f 88 95 01 00 00    	js     8014f2 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80135d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801361:	48 89 c7             	mov    %rax,%rdi
  801364:	48 b8 d4 05 80 00 00 	movabs $0x8005d4,%rax
  80136b:	00 00 00 
  80136e:	ff d0                	callq  *%rax
  801370:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801373:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801377:	0f 88 5d 01 00 00    	js     8014da <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80137d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801381:	ba 07 04 00 00       	mov    $0x407,%edx
  801386:	48 89 c6             	mov    %rax,%rsi
  801389:	bf 00 00 00 00       	mov    $0x0,%edi
  80138e:	48 b8 19 03 80 00 00 	movabs $0x800319,%rax
  801395:	00 00 00 
  801398:	ff d0                	callq  *%rax
  80139a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80139d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8013a1:	0f 88 33 01 00 00    	js     8014da <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8013a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ab:	48 89 c7             	mov    %rax,%rdi
  8013ae:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  8013b5:	00 00 00 
  8013b8:	ff d0                	callq  *%rax
  8013ba:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013c2:	ba 07 04 00 00       	mov    $0x407,%edx
  8013c7:	48 89 c6             	mov    %rax,%rsi
  8013ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8013cf:	48 b8 19 03 80 00 00 	movabs $0x800319,%rax
  8013d6:	00 00 00 
  8013d9:	ff d0                	callq  *%rax
  8013db:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8013de:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8013e2:	79 05                	jns    8013e9 <pipe+0xe3>
		goto err2;
  8013e4:	e9 d9 00 00 00       	jmpq   8014c2 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8013ed:	48 89 c7             	mov    %rax,%rdi
  8013f0:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  8013f7:	00 00 00 
  8013fa:	ff d0                	callq  *%rax
  8013fc:	48 89 c2             	mov    %rax,%rdx
  8013ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801403:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  801409:	48 89 d1             	mov    %rdx,%rcx
  80140c:	ba 00 00 00 00       	mov    $0x0,%edx
  801411:	48 89 c6             	mov    %rax,%rsi
  801414:	bf 00 00 00 00       	mov    $0x0,%edi
  801419:	48 b8 69 03 80 00 00 	movabs $0x800369,%rax
  801420:	00 00 00 
  801423:	ff d0                	callq  *%rax
  801425:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801428:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80142c:	79 1b                	jns    801449 <pipe+0x143>
		goto err3;
  80142e:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  80142f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801433:	48 89 c6             	mov    %rax,%rsi
  801436:	bf 00 00 00 00       	mov    $0x0,%edi
  80143b:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  801442:	00 00 00 
  801445:	ff d0                	callq  *%rax
  801447:	eb 79                	jmp    8014c2 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801449:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144d:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801454:	00 00 00 
  801457:	8b 12                	mov    (%rdx),%edx
  801459:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80145b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801466:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80146a:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801471:	00 00 00 
  801474:	8b 12                	mov    (%rdx),%edx
  801476:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801478:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80147c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801483:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801487:	48 89 c7             	mov    %rax,%rdi
  80148a:	48 b8 86 05 80 00 00 	movabs $0x800586,%rax
  801491:	00 00 00 
  801494:	ff d0                	callq  *%rax
  801496:	89 c2                	mov    %eax,%edx
  801498:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80149c:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80149e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8014a2:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8014a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014aa:	48 89 c7             	mov    %rax,%rdi
  8014ad:	48 b8 86 05 80 00 00 	movabs $0x800586,%rax
  8014b4:	00 00 00 
  8014b7:	ff d0                	callq  *%rax
  8014b9:	89 03                	mov    %eax,(%rbx)
	return 0;
  8014bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c0:	eb 33                	jmp    8014f5 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8014c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014c6:	48 89 c6             	mov    %rax,%rsi
  8014c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8014ce:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  8014d5:	00 00 00 
  8014d8:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8014da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014de:	48 89 c6             	mov    %rax,%rsi
  8014e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8014e6:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  8014ed:	00 00 00 
  8014f0:	ff d0                	callq  *%rax
    err:
	return r;
  8014f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8014f5:	48 83 c4 38          	add    $0x38,%rsp
  8014f9:	5b                   	pop    %rbx
  8014fa:	5d                   	pop    %rbp
  8014fb:	c3                   	retq   

00000000008014fc <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8014fc:	55                   	push   %rbp
  8014fd:	48 89 e5             	mov    %rsp,%rbp
  801500:	53                   	push   %rbx
  801501:	48 83 ec 28          	sub    $0x28,%rsp
  801505:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801509:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80150d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801514:	00 00 00 
  801517:	48 8b 00             	mov    (%rax),%rax
  80151a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801520:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  801523:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801527:	48 89 c7             	mov    %rax,%rdi
  80152a:	48 b8 9f 34 80 00 00 	movabs $0x80349f,%rax
  801531:	00 00 00 
  801534:	ff d0                	callq  *%rax
  801536:	89 c3                	mov    %eax,%ebx
  801538:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80153c:	48 89 c7             	mov    %rax,%rdi
  80153f:	48 b8 9f 34 80 00 00 	movabs $0x80349f,%rax
  801546:	00 00 00 
  801549:	ff d0                	callq  *%rax
  80154b:	39 c3                	cmp    %eax,%ebx
  80154d:	0f 94 c0             	sete   %al
  801550:	0f b6 c0             	movzbl %al,%eax
  801553:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  801556:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80155d:	00 00 00 
  801560:	48 8b 00             	mov    (%rax),%rax
  801563:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801569:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80156c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80156f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801572:	75 05                	jne    801579 <_pipeisclosed+0x7d>
			return ret;
  801574:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801577:	eb 4f                	jmp    8015c8 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  801579:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80157c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80157f:	74 42                	je     8015c3 <_pipeisclosed+0xc7>
  801581:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801585:	75 3c                	jne    8015c3 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801587:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80158e:	00 00 00 
  801591:	48 8b 00             	mov    (%rax),%rax
  801594:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80159a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80159d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015a0:	89 c6                	mov    %eax,%esi
  8015a2:	48 bf fb 35 80 00 00 	movabs $0x8035fb,%rdi
  8015a9:	00 00 00 
  8015ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b1:	49 b8 bb 1d 80 00 00 	movabs $0x801dbb,%r8
  8015b8:	00 00 00 
  8015bb:	41 ff d0             	callq  *%r8
	}
  8015be:	e9 4a ff ff ff       	jmpq   80150d <_pipeisclosed+0x11>
  8015c3:	e9 45 ff ff ff       	jmpq   80150d <_pipeisclosed+0x11>
}
  8015c8:	48 83 c4 28          	add    $0x28,%rsp
  8015cc:	5b                   	pop    %rbx
  8015cd:	5d                   	pop    %rbp
  8015ce:	c3                   	retq   

00000000008015cf <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8015cf:	55                   	push   %rbp
  8015d0:	48 89 e5             	mov    %rsp,%rbp
  8015d3:	48 83 ec 30          	sub    $0x30,%rsp
  8015d7:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015da:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8015de:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015e1:	48 89 d6             	mov    %rdx,%rsi
  8015e4:	89 c7                	mov    %eax,%edi
  8015e6:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  8015ed:	00 00 00 
  8015f0:	ff d0                	callq  *%rax
  8015f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015f9:	79 05                	jns    801600 <pipeisclosed+0x31>
		return r;
  8015fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015fe:	eb 31                	jmp    801631 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  801600:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801604:	48 89 c7             	mov    %rax,%rdi
  801607:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  80160e:	00 00 00 
  801611:	ff d0                	callq  *%rax
  801613:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  801617:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80161b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80161f:	48 89 d6             	mov    %rdx,%rsi
  801622:	48 89 c7             	mov    %rax,%rdi
  801625:	48 b8 fc 14 80 00 00 	movabs $0x8014fc,%rax
  80162c:	00 00 00 
  80162f:	ff d0                	callq  *%rax
}
  801631:	c9                   	leaveq 
  801632:	c3                   	retq   

0000000000801633 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801633:	55                   	push   %rbp
  801634:	48 89 e5             	mov    %rsp,%rbp
  801637:	48 83 ec 40          	sub    $0x40,%rsp
  80163b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80163f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801643:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801647:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164b:	48 89 c7             	mov    %rax,%rdi
  80164e:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  801655:	00 00 00 
  801658:	ff d0                	callq  *%rax
  80165a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80165e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801662:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801666:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80166d:	00 
  80166e:	e9 92 00 00 00       	jmpq   801705 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  801673:	eb 41                	jmp    8016b6 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801675:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80167a:	74 09                	je     801685 <devpipe_read+0x52>
				return i;
  80167c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801680:	e9 92 00 00 00       	jmpq   801717 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801685:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801689:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168d:	48 89 d6             	mov    %rdx,%rsi
  801690:	48 89 c7             	mov    %rax,%rdi
  801693:	48 b8 fc 14 80 00 00 	movabs $0x8014fc,%rax
  80169a:	00 00 00 
  80169d:	ff d0                	callq  *%rax
  80169f:	85 c0                	test   %eax,%eax
  8016a1:	74 07                	je     8016aa <devpipe_read+0x77>
				return 0;
  8016a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a8:	eb 6d                	jmp    801717 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8016aa:	48 b8 db 02 80 00 00 	movabs $0x8002db,%rax
  8016b1:	00 00 00 
  8016b4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8016b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ba:	8b 10                	mov    (%rax),%edx
  8016bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c0:	8b 40 04             	mov    0x4(%rax),%eax
  8016c3:	39 c2                	cmp    %eax,%edx
  8016c5:	74 ae                	je     801675 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8016c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016cf:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8016d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d7:	8b 00                	mov    (%rax),%eax
  8016d9:	99                   	cltd   
  8016da:	c1 ea 1b             	shr    $0x1b,%edx
  8016dd:	01 d0                	add    %edx,%eax
  8016df:	83 e0 1f             	and    $0x1f,%eax
  8016e2:	29 d0                	sub    %edx,%eax
  8016e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016e8:	48 98                	cltq   
  8016ea:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8016ef:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8016f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f5:	8b 00                	mov    (%rax),%eax
  8016f7:	8d 50 01             	lea    0x1(%rax),%edx
  8016fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016fe:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801700:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801705:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801709:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80170d:	0f 82 60 ff ff ff    	jb     801673 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801713:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801717:	c9                   	leaveq 
  801718:	c3                   	retq   

0000000000801719 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801719:	55                   	push   %rbp
  80171a:	48 89 e5             	mov    %rsp,%rbp
  80171d:	48 83 ec 40          	sub    $0x40,%rsp
  801721:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801725:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801729:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80172d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801731:	48 89 c7             	mov    %rax,%rdi
  801734:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  80173b:	00 00 00 
  80173e:	ff d0                	callq  *%rax
  801740:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801744:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801748:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80174c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801753:	00 
  801754:	e9 8e 00 00 00       	jmpq   8017e7 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801759:	eb 31                	jmp    80178c <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80175b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80175f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801763:	48 89 d6             	mov    %rdx,%rsi
  801766:	48 89 c7             	mov    %rax,%rdi
  801769:	48 b8 fc 14 80 00 00 	movabs $0x8014fc,%rax
  801770:	00 00 00 
  801773:	ff d0                	callq  *%rax
  801775:	85 c0                	test   %eax,%eax
  801777:	74 07                	je     801780 <devpipe_write+0x67>
				return 0;
  801779:	b8 00 00 00 00       	mov    $0x0,%eax
  80177e:	eb 79                	jmp    8017f9 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801780:	48 b8 db 02 80 00 00 	movabs $0x8002db,%rax
  801787:	00 00 00 
  80178a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80178c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801790:	8b 40 04             	mov    0x4(%rax),%eax
  801793:	48 63 d0             	movslq %eax,%rdx
  801796:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80179a:	8b 00                	mov    (%rax),%eax
  80179c:	48 98                	cltq   
  80179e:	48 83 c0 20          	add    $0x20,%rax
  8017a2:	48 39 c2             	cmp    %rax,%rdx
  8017a5:	73 b4                	jae    80175b <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8017a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ab:	8b 40 04             	mov    0x4(%rax),%eax
  8017ae:	99                   	cltd   
  8017af:	c1 ea 1b             	shr    $0x1b,%edx
  8017b2:	01 d0                	add    %edx,%eax
  8017b4:	83 e0 1f             	and    $0x1f,%eax
  8017b7:	29 d0                	sub    %edx,%eax
  8017b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017bd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8017c1:	48 01 ca             	add    %rcx,%rdx
  8017c4:	0f b6 0a             	movzbl (%rdx),%ecx
  8017c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017cb:	48 98                	cltq   
  8017cd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8017d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017d5:	8b 40 04             	mov    0x4(%rax),%eax
  8017d8:	8d 50 01             	lea    0x1(%rax),%edx
  8017db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017df:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8017e2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017eb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8017ef:	0f 82 64 ff ff ff    	jb     801759 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8017f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017f9:	c9                   	leaveq 
  8017fa:	c3                   	retq   

00000000008017fb <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8017fb:	55                   	push   %rbp
  8017fc:	48 89 e5             	mov    %rsp,%rbp
  8017ff:	48 83 ec 20          	sub    $0x20,%rsp
  801803:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801807:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80180b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80180f:	48 89 c7             	mov    %rax,%rdi
  801812:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  801819:	00 00 00 
  80181c:	ff d0                	callq  *%rax
  80181e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801822:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801826:	48 be 0e 36 80 00 00 	movabs $0x80360e,%rsi
  80182d:	00 00 00 
  801830:	48 89 c7             	mov    %rax,%rdi
  801833:	48 b8 63 2b 80 00 00 	movabs $0x802b63,%rax
  80183a:	00 00 00 
  80183d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80183f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801843:	8b 50 04             	mov    0x4(%rax),%edx
  801846:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80184a:	8b 00                	mov    (%rax),%eax
  80184c:	29 c2                	sub    %eax,%edx
  80184e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801852:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801858:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80185c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801863:	00 00 00 
	stat->st_dev = &devpipe;
  801866:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80186a:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801871:	00 00 00 
  801874:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80187b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801880:	c9                   	leaveq 
  801881:	c3                   	retq   

0000000000801882 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801882:	55                   	push   %rbp
  801883:	48 89 e5             	mov    %rsp,%rbp
  801886:	48 83 ec 10          	sub    $0x10,%rsp
  80188a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80188e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801892:	48 89 c6             	mov    %rax,%rsi
  801895:	bf 00 00 00 00       	mov    $0x0,%edi
  80189a:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  8018a1:	00 00 00 
  8018a4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8018a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018aa:	48 89 c7             	mov    %rax,%rdi
  8018ad:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  8018b4:	00 00 00 
  8018b7:	ff d0                	callq  *%rax
  8018b9:	48 89 c6             	mov    %rax,%rsi
  8018bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8018c1:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  8018c8:	00 00 00 
  8018cb:	ff d0                	callq  *%rax
}
  8018cd:	c9                   	leaveq 
  8018ce:	c3                   	retq   

00000000008018cf <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8018cf:	55                   	push   %rbp
  8018d0:	48 89 e5             	mov    %rsp,%rbp
  8018d3:	48 83 ec 20          	sub    $0x20,%rsp
  8018d7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8018da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018dd:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8018e0:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8018e4:	be 01 00 00 00       	mov    $0x1,%esi
  8018e9:	48 89 c7             	mov    %rax,%rdi
  8018ec:	48 b8 d1 01 80 00 00 	movabs $0x8001d1,%rax
  8018f3:	00 00 00 
  8018f6:	ff d0                	callq  *%rax
}
  8018f8:	c9                   	leaveq 
  8018f9:	c3                   	retq   

00000000008018fa <getchar>:

int
getchar(void)
{
  8018fa:	55                   	push   %rbp
  8018fb:	48 89 e5             	mov    %rsp,%rbp
  8018fe:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801902:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801906:	ba 01 00 00 00       	mov    $0x1,%edx
  80190b:	48 89 c6             	mov    %rax,%rsi
  80190e:	bf 00 00 00 00       	mov    $0x0,%edi
  801913:	48 b8 9e 0a 80 00 00 	movabs $0x800a9e,%rax
  80191a:	00 00 00 
  80191d:	ff d0                	callq  *%rax
  80191f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801922:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801926:	79 05                	jns    80192d <getchar+0x33>
		return r;
  801928:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80192b:	eb 14                	jmp    801941 <getchar+0x47>
	if (r < 1)
  80192d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801931:	7f 07                	jg     80193a <getchar+0x40>
		return -E_EOF;
  801933:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801938:	eb 07                	jmp    801941 <getchar+0x47>
	return c;
  80193a:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80193e:	0f b6 c0             	movzbl %al,%eax
}
  801941:	c9                   	leaveq 
  801942:	c3                   	retq   

0000000000801943 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801943:	55                   	push   %rbp
  801944:	48 89 e5             	mov    %rsp,%rbp
  801947:	48 83 ec 20          	sub    $0x20,%rsp
  80194b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80194e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801952:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801955:	48 89 d6             	mov    %rdx,%rsi
  801958:	89 c7                	mov    %eax,%edi
  80195a:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  801961:	00 00 00 
  801964:	ff d0                	callq  *%rax
  801966:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801969:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80196d:	79 05                	jns    801974 <iscons+0x31>
		return r;
  80196f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801972:	eb 1a                	jmp    80198e <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801974:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801978:	8b 10                	mov    (%rax),%edx
  80197a:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801981:	00 00 00 
  801984:	8b 00                	mov    (%rax),%eax
  801986:	39 c2                	cmp    %eax,%edx
  801988:	0f 94 c0             	sete   %al
  80198b:	0f b6 c0             	movzbl %al,%eax
}
  80198e:	c9                   	leaveq 
  80198f:	c3                   	retq   

0000000000801990 <opencons>:

int
opencons(void)
{
  801990:	55                   	push   %rbp
  801991:	48 89 e5             	mov    %rsp,%rbp
  801994:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801998:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80199c:	48 89 c7             	mov    %rax,%rdi
  80199f:	48 b8 d4 05 80 00 00 	movabs $0x8005d4,%rax
  8019a6:	00 00 00 
  8019a9:	ff d0                	callq  *%rax
  8019ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019b2:	79 05                	jns    8019b9 <opencons+0x29>
		return r;
  8019b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b7:	eb 5b                	jmp    801a14 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8019b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019bd:	ba 07 04 00 00       	mov    $0x407,%edx
  8019c2:	48 89 c6             	mov    %rax,%rsi
  8019c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8019ca:	48 b8 19 03 80 00 00 	movabs $0x800319,%rax
  8019d1:	00 00 00 
  8019d4:	ff d0                	callq  *%rax
  8019d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019dd:	79 05                	jns    8019e4 <opencons+0x54>
		return r;
  8019df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e2:	eb 30                	jmp    801a14 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8019e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019e8:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8019ef:	00 00 00 
  8019f2:	8b 12                	mov    (%rdx),%edx
  8019f4:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8019f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019fa:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801a01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a05:	48 89 c7             	mov    %rax,%rdi
  801a08:	48 b8 86 05 80 00 00 	movabs $0x800586,%rax
  801a0f:	00 00 00 
  801a12:	ff d0                	callq  *%rax
}
  801a14:	c9                   	leaveq 
  801a15:	c3                   	retq   

0000000000801a16 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801a16:	55                   	push   %rbp
  801a17:	48 89 e5             	mov    %rsp,%rbp
  801a1a:	48 83 ec 30          	sub    $0x30,%rsp
  801a1e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a22:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a26:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801a2a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a2f:	75 07                	jne    801a38 <devcons_read+0x22>
		return 0;
  801a31:	b8 00 00 00 00       	mov    $0x0,%eax
  801a36:	eb 4b                	jmp    801a83 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801a38:	eb 0c                	jmp    801a46 <devcons_read+0x30>
		sys_yield();
  801a3a:	48 b8 db 02 80 00 00 	movabs $0x8002db,%rax
  801a41:	00 00 00 
  801a44:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801a46:	48 b8 1b 02 80 00 00 	movabs $0x80021b,%rax
  801a4d:	00 00 00 
  801a50:	ff d0                	callq  *%rax
  801a52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a59:	74 df                	je     801a3a <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801a5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a5f:	79 05                	jns    801a66 <devcons_read+0x50>
		return c;
  801a61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a64:	eb 1d                	jmp    801a83 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801a66:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801a6a:	75 07                	jne    801a73 <devcons_read+0x5d>
		return 0;
  801a6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a71:	eb 10                	jmp    801a83 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801a73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a76:	89 c2                	mov    %eax,%edx
  801a78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a7c:	88 10                	mov    %dl,(%rax)
	return 1;
  801a7e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a83:	c9                   	leaveq 
  801a84:	c3                   	retq   

0000000000801a85 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801a85:	55                   	push   %rbp
  801a86:	48 89 e5             	mov    %rsp,%rbp
  801a89:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801a90:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801a97:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801a9e:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801aa5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801aac:	eb 76                	jmp    801b24 <devcons_write+0x9f>
		m = n - tot;
  801aae:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801ab5:	89 c2                	mov    %eax,%edx
  801ab7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aba:	29 c2                	sub    %eax,%edx
  801abc:	89 d0                	mov    %edx,%eax
  801abe:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801ac1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ac4:	83 f8 7f             	cmp    $0x7f,%eax
  801ac7:	76 07                	jbe    801ad0 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801ac9:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801ad0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ad3:	48 63 d0             	movslq %eax,%rdx
  801ad6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad9:	48 63 c8             	movslq %eax,%rcx
  801adc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801ae3:	48 01 c1             	add    %rax,%rcx
  801ae6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801aed:	48 89 ce             	mov    %rcx,%rsi
  801af0:	48 89 c7             	mov    %rax,%rdi
  801af3:	48 b8 87 2e 80 00 00 	movabs $0x802e87,%rax
  801afa:	00 00 00 
  801afd:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801aff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b02:	48 63 d0             	movslq %eax,%rdx
  801b05:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801b0c:	48 89 d6             	mov    %rdx,%rsi
  801b0f:	48 89 c7             	mov    %rax,%rdi
  801b12:	48 b8 d1 01 80 00 00 	movabs $0x8001d1,%rax
  801b19:	00 00 00 
  801b1c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b1e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b21:	01 45 fc             	add    %eax,-0x4(%rbp)
  801b24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b27:	48 98                	cltq   
  801b29:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801b30:	0f 82 78 ff ff ff    	jb     801aae <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801b39:	c9                   	leaveq 
  801b3a:	c3                   	retq   

0000000000801b3b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801b3b:	55                   	push   %rbp
  801b3c:	48 89 e5             	mov    %rsp,%rbp
  801b3f:	48 83 ec 08          	sub    $0x8,%rsp
  801b43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801b47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b4c:	c9                   	leaveq 
  801b4d:	c3                   	retq   

0000000000801b4e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b4e:	55                   	push   %rbp
  801b4f:	48 89 e5             	mov    %rsp,%rbp
  801b52:	48 83 ec 10          	sub    $0x10,%rsp
  801b56:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801b5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b62:	48 be 1a 36 80 00 00 	movabs $0x80361a,%rsi
  801b69:	00 00 00 
  801b6c:	48 89 c7             	mov    %rax,%rdi
  801b6f:	48 b8 63 2b 80 00 00 	movabs $0x802b63,%rax
  801b76:	00 00 00 
  801b79:	ff d0                	callq  *%rax
	return 0;
  801b7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b80:	c9                   	leaveq 
  801b81:	c3                   	retq   

0000000000801b82 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b82:	55                   	push   %rbp
  801b83:	48 89 e5             	mov    %rsp,%rbp
  801b86:	53                   	push   %rbx
  801b87:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801b8e:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801b95:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801b9b:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801ba2:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801ba9:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801bb0:	84 c0                	test   %al,%al
  801bb2:	74 23                	je     801bd7 <_panic+0x55>
  801bb4:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801bbb:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801bbf:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801bc3:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801bc7:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801bcb:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801bcf:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801bd3:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801bd7:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801bde:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801be5:	00 00 00 
  801be8:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801bef:	00 00 00 
  801bf2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801bf6:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801bfd:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801c04:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801c0b:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801c12:	00 00 00 
  801c15:	48 8b 18             	mov    (%rax),%rbx
  801c18:	48 b8 9d 02 80 00 00 	movabs $0x80029d,%rax
  801c1f:	00 00 00 
  801c22:	ff d0                	callq  *%rax
  801c24:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801c2a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801c31:	41 89 c8             	mov    %ecx,%r8d
  801c34:	48 89 d1             	mov    %rdx,%rcx
  801c37:	48 89 da             	mov    %rbx,%rdx
  801c3a:	89 c6                	mov    %eax,%esi
  801c3c:	48 bf 28 36 80 00 00 	movabs $0x803628,%rdi
  801c43:	00 00 00 
  801c46:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4b:	49 b9 bb 1d 80 00 00 	movabs $0x801dbb,%r9
  801c52:	00 00 00 
  801c55:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801c58:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801c5f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801c66:	48 89 d6             	mov    %rdx,%rsi
  801c69:	48 89 c7             	mov    %rax,%rdi
  801c6c:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  801c73:	00 00 00 
  801c76:	ff d0                	callq  *%rax
	cprintf("\n");
  801c78:	48 bf 4b 36 80 00 00 	movabs $0x80364b,%rdi
  801c7f:	00 00 00 
  801c82:	b8 00 00 00 00       	mov    $0x0,%eax
  801c87:	48 ba bb 1d 80 00 00 	movabs $0x801dbb,%rdx
  801c8e:	00 00 00 
  801c91:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801c93:	cc                   	int3   
  801c94:	eb fd                	jmp    801c93 <_panic+0x111>

0000000000801c96 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801c96:	55                   	push   %rbp
  801c97:	48 89 e5             	mov    %rsp,%rbp
  801c9a:	48 83 ec 10          	sub    $0x10,%rsp
  801c9e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ca1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  801ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca9:	8b 00                	mov    (%rax),%eax
  801cab:	8d 48 01             	lea    0x1(%rax),%ecx
  801cae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cb2:	89 0a                	mov    %ecx,(%rdx)
  801cb4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801cb7:	89 d1                	mov    %edx,%ecx
  801cb9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cbd:	48 98                	cltq   
  801cbf:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  801cc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cc7:	8b 00                	mov    (%rax),%eax
  801cc9:	3d ff 00 00 00       	cmp    $0xff,%eax
  801cce:	75 2c                	jne    801cfc <putch+0x66>
		sys_cputs(b->buf, b->idx);
  801cd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cd4:	8b 00                	mov    (%rax),%eax
  801cd6:	48 98                	cltq   
  801cd8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cdc:	48 83 c2 08          	add    $0x8,%rdx
  801ce0:	48 89 c6             	mov    %rax,%rsi
  801ce3:	48 89 d7             	mov    %rdx,%rdi
  801ce6:	48 b8 d1 01 80 00 00 	movabs $0x8001d1,%rax
  801ced:	00 00 00 
  801cf0:	ff d0                	callq  *%rax
		b->idx = 0;
  801cf2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cf6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  801cfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d00:	8b 40 04             	mov    0x4(%rax),%eax
  801d03:	8d 50 01             	lea    0x1(%rax),%edx
  801d06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d0a:	89 50 04             	mov    %edx,0x4(%rax)
}
  801d0d:	c9                   	leaveq 
  801d0e:	c3                   	retq   

0000000000801d0f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801d0f:	55                   	push   %rbp
  801d10:	48 89 e5             	mov    %rsp,%rbp
  801d13:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801d1a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801d21:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  801d28:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801d2f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801d36:	48 8b 0a             	mov    (%rdx),%rcx
  801d39:	48 89 08             	mov    %rcx,(%rax)
  801d3c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801d40:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801d44:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801d48:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  801d4c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801d53:	00 00 00 
	b.cnt = 0;
  801d56:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801d5d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  801d60:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  801d67:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801d6e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  801d75:	48 89 c6             	mov    %rax,%rsi
  801d78:	48 bf 96 1c 80 00 00 	movabs $0x801c96,%rdi
  801d7f:	00 00 00 
  801d82:	48 b8 6e 21 80 00 00 	movabs $0x80216e,%rax
  801d89:	00 00 00 
  801d8c:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  801d8e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  801d94:	48 98                	cltq   
  801d96:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801d9d:	48 83 c2 08          	add    $0x8,%rdx
  801da1:	48 89 c6             	mov    %rax,%rsi
  801da4:	48 89 d7             	mov    %rdx,%rdi
  801da7:	48 b8 d1 01 80 00 00 	movabs $0x8001d1,%rax
  801dae:	00 00 00 
  801db1:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  801db3:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  801db9:	c9                   	leaveq 
  801dba:	c3                   	retq   

0000000000801dbb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801dbb:	55                   	push   %rbp
  801dbc:	48 89 e5             	mov    %rsp,%rbp
  801dbf:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  801dc6:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  801dcd:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  801dd4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801ddb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801de2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801de9:	84 c0                	test   %al,%al
  801deb:	74 20                	je     801e0d <cprintf+0x52>
  801ded:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801df1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801df5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801df9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801dfd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801e01:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801e05:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801e09:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801e0d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  801e14:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  801e1b:	00 00 00 
  801e1e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801e25:	00 00 00 
  801e28:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e2c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801e33:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801e3a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801e41:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801e48:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801e4f:	48 8b 0a             	mov    (%rdx),%rcx
  801e52:	48 89 08             	mov    %rcx,(%rax)
  801e55:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801e59:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801e5d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801e61:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  801e65:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  801e6c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801e73:	48 89 d6             	mov    %rdx,%rsi
  801e76:	48 89 c7             	mov    %rax,%rdi
  801e79:	48 b8 0f 1d 80 00 00 	movabs $0x801d0f,%rax
  801e80:	00 00 00 
  801e83:	ff d0                	callq  *%rax
  801e85:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  801e8b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801e91:	c9                   	leaveq 
  801e92:	c3                   	retq   

0000000000801e93 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801e93:	55                   	push   %rbp
  801e94:	48 89 e5             	mov    %rsp,%rbp
  801e97:	53                   	push   %rbx
  801e98:	48 83 ec 38          	sub    $0x38,%rsp
  801e9c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ea0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801ea4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ea8:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801eab:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  801eaf:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801eb3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801eb6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801eba:	77 3b                	ja     801ef7 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801ebc:	8b 45 d0             	mov    -0x30(%rbp),%eax
  801ebf:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801ec3:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  801ec6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eca:	ba 00 00 00 00       	mov    $0x0,%edx
  801ecf:	48 f7 f3             	div    %rbx
  801ed2:	48 89 c2             	mov    %rax,%rdx
  801ed5:	8b 7d cc             	mov    -0x34(%rbp),%edi
  801ed8:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801edb:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  801edf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ee3:	41 89 f9             	mov    %edi,%r9d
  801ee6:	48 89 c7             	mov    %rax,%rdi
  801ee9:	48 b8 93 1e 80 00 00 	movabs $0x801e93,%rax
  801ef0:	00 00 00 
  801ef3:	ff d0                	callq  *%rax
  801ef5:	eb 1e                	jmp    801f15 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801ef7:	eb 12                	jmp    801f0b <printnum+0x78>
			putch(padc, putdat);
  801ef9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801efd:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801f00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f04:	48 89 ce             	mov    %rcx,%rsi
  801f07:	89 d7                	mov    %edx,%edi
  801f09:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801f0b:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  801f0f:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  801f13:	7f e4                	jg     801ef9 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801f15:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801f18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f21:	48 f7 f1             	div    %rcx
  801f24:	48 89 d0             	mov    %rdx,%rax
  801f27:	48 ba 28 38 80 00 00 	movabs $0x803828,%rdx
  801f2e:	00 00 00 
  801f31:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  801f35:	0f be d0             	movsbl %al,%edx
  801f38:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801f3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f40:	48 89 ce             	mov    %rcx,%rsi
  801f43:	89 d7                	mov    %edx,%edi
  801f45:	ff d0                	callq  *%rax
}
  801f47:	48 83 c4 38          	add    $0x38,%rsp
  801f4b:	5b                   	pop    %rbx
  801f4c:	5d                   	pop    %rbp
  801f4d:	c3                   	retq   

0000000000801f4e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801f4e:	55                   	push   %rbp
  801f4f:	48 89 e5             	mov    %rsp,%rbp
  801f52:	48 83 ec 1c          	sub    $0x1c,%rsp
  801f56:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801f5a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  801f5d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801f61:	7e 52                	jle    801fb5 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  801f63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f67:	8b 00                	mov    (%rax),%eax
  801f69:	83 f8 30             	cmp    $0x30,%eax
  801f6c:	73 24                	jae    801f92 <getuint+0x44>
  801f6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f72:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801f76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f7a:	8b 00                	mov    (%rax),%eax
  801f7c:	89 c0                	mov    %eax,%eax
  801f7e:	48 01 d0             	add    %rdx,%rax
  801f81:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f85:	8b 12                	mov    (%rdx),%edx
  801f87:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801f8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f8e:	89 0a                	mov    %ecx,(%rdx)
  801f90:	eb 17                	jmp    801fa9 <getuint+0x5b>
  801f92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f96:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801f9a:	48 89 d0             	mov    %rdx,%rax
  801f9d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801fa1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801fa5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801fa9:	48 8b 00             	mov    (%rax),%rax
  801fac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801fb0:	e9 a3 00 00 00       	jmpq   802058 <getuint+0x10a>
	else if (lflag)
  801fb5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801fb9:	74 4f                	je     80200a <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  801fbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fbf:	8b 00                	mov    (%rax),%eax
  801fc1:	83 f8 30             	cmp    $0x30,%eax
  801fc4:	73 24                	jae    801fea <getuint+0x9c>
  801fc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fca:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801fce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd2:	8b 00                	mov    (%rax),%eax
  801fd4:	89 c0                	mov    %eax,%eax
  801fd6:	48 01 d0             	add    %rdx,%rax
  801fd9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801fdd:	8b 12                	mov    (%rdx),%edx
  801fdf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801fe2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801fe6:	89 0a                	mov    %ecx,(%rdx)
  801fe8:	eb 17                	jmp    802001 <getuint+0xb3>
  801fea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fee:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801ff2:	48 89 d0             	mov    %rdx,%rax
  801ff5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801ff9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ffd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802001:	48 8b 00             	mov    (%rax),%rax
  802004:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802008:	eb 4e                	jmp    802058 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80200a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80200e:	8b 00                	mov    (%rax),%eax
  802010:	83 f8 30             	cmp    $0x30,%eax
  802013:	73 24                	jae    802039 <getuint+0xeb>
  802015:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802019:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80201d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802021:	8b 00                	mov    (%rax),%eax
  802023:	89 c0                	mov    %eax,%eax
  802025:	48 01 d0             	add    %rdx,%rax
  802028:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80202c:	8b 12                	mov    (%rdx),%edx
  80202e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802031:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802035:	89 0a                	mov    %ecx,(%rdx)
  802037:	eb 17                	jmp    802050 <getuint+0x102>
  802039:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80203d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802041:	48 89 d0             	mov    %rdx,%rax
  802044:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802048:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80204c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802050:	8b 00                	mov    (%rax),%eax
  802052:	89 c0                	mov    %eax,%eax
  802054:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802058:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80205c:	c9                   	leaveq 
  80205d:	c3                   	retq   

000000000080205e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80205e:	55                   	push   %rbp
  80205f:	48 89 e5             	mov    %rsp,%rbp
  802062:	48 83 ec 1c          	sub    $0x1c,%rsp
  802066:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80206a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80206d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802071:	7e 52                	jle    8020c5 <getint+0x67>
		x=va_arg(*ap, long long);
  802073:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802077:	8b 00                	mov    (%rax),%eax
  802079:	83 f8 30             	cmp    $0x30,%eax
  80207c:	73 24                	jae    8020a2 <getint+0x44>
  80207e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802082:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802086:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80208a:	8b 00                	mov    (%rax),%eax
  80208c:	89 c0                	mov    %eax,%eax
  80208e:	48 01 d0             	add    %rdx,%rax
  802091:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802095:	8b 12                	mov    (%rdx),%edx
  802097:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80209a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80209e:	89 0a                	mov    %ecx,(%rdx)
  8020a0:	eb 17                	jmp    8020b9 <getint+0x5b>
  8020a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020a6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8020aa:	48 89 d0             	mov    %rdx,%rax
  8020ad:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8020b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020b5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8020b9:	48 8b 00             	mov    (%rax),%rax
  8020bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8020c0:	e9 a3 00 00 00       	jmpq   802168 <getint+0x10a>
	else if (lflag)
  8020c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8020c9:	74 4f                	je     80211a <getint+0xbc>
		x=va_arg(*ap, long);
  8020cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020cf:	8b 00                	mov    (%rax),%eax
  8020d1:	83 f8 30             	cmp    $0x30,%eax
  8020d4:	73 24                	jae    8020fa <getint+0x9c>
  8020d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020da:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8020de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e2:	8b 00                	mov    (%rax),%eax
  8020e4:	89 c0                	mov    %eax,%eax
  8020e6:	48 01 d0             	add    %rdx,%rax
  8020e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020ed:	8b 12                	mov    (%rdx),%edx
  8020ef:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8020f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020f6:	89 0a                	mov    %ecx,(%rdx)
  8020f8:	eb 17                	jmp    802111 <getint+0xb3>
  8020fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020fe:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802102:	48 89 d0             	mov    %rdx,%rax
  802105:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802109:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80210d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802111:	48 8b 00             	mov    (%rax),%rax
  802114:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802118:	eb 4e                	jmp    802168 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80211a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80211e:	8b 00                	mov    (%rax),%eax
  802120:	83 f8 30             	cmp    $0x30,%eax
  802123:	73 24                	jae    802149 <getint+0xeb>
  802125:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802129:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80212d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802131:	8b 00                	mov    (%rax),%eax
  802133:	89 c0                	mov    %eax,%eax
  802135:	48 01 d0             	add    %rdx,%rax
  802138:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80213c:	8b 12                	mov    (%rdx),%edx
  80213e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802141:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802145:	89 0a                	mov    %ecx,(%rdx)
  802147:	eb 17                	jmp    802160 <getint+0x102>
  802149:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80214d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802151:	48 89 d0             	mov    %rdx,%rax
  802154:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802158:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80215c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802160:	8b 00                	mov    (%rax),%eax
  802162:	48 98                	cltq   
  802164:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802168:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80216c:	c9                   	leaveq 
  80216d:	c3                   	retq   

000000000080216e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80216e:	55                   	push   %rbp
  80216f:	48 89 e5             	mov    %rsp,%rbp
  802172:	41 54                	push   %r12
  802174:	53                   	push   %rbx
  802175:	48 83 ec 60          	sub    $0x60,%rsp
  802179:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80217d:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802181:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802185:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802189:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80218d:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802191:	48 8b 0a             	mov    (%rdx),%rcx
  802194:	48 89 08             	mov    %rcx,(%rax)
  802197:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80219b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80219f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8021a3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  8021a7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8021ab:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021af:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8021b3:	0f b6 00             	movzbl (%rax),%eax
  8021b6:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  8021b9:	eb 29                	jmp    8021e4 <vprintfmt+0x76>
			if (ch == '\0')
  8021bb:	85 db                	test   %ebx,%ebx
  8021bd:	0f 84 ad 06 00 00    	je     802870 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  8021c3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8021c7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8021cb:	48 89 d6             	mov    %rdx,%rsi
  8021ce:	89 df                	mov    %ebx,%edi
  8021d0:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  8021d2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8021d6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021da:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8021de:	0f b6 00             	movzbl (%rax),%eax
  8021e1:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  8021e4:	83 fb 25             	cmp    $0x25,%ebx
  8021e7:	74 05                	je     8021ee <vprintfmt+0x80>
  8021e9:	83 fb 1b             	cmp    $0x1b,%ebx
  8021ec:	75 cd                	jne    8021bb <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  8021ee:	83 fb 1b             	cmp    $0x1b,%ebx
  8021f1:	0f 85 ae 01 00 00    	jne    8023a5 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  8021f7:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  8021fe:	00 00 00 
  802201:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  802207:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80220b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80220f:	48 89 d6             	mov    %rdx,%rsi
  802212:	89 df                	mov    %ebx,%edi
  802214:	ff d0                	callq  *%rax
			putch('[', putdat);
  802216:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80221a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80221e:	48 89 d6             	mov    %rdx,%rsi
  802221:	bf 5b 00 00 00       	mov    $0x5b,%edi
  802226:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  802228:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  80222e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  802233:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802237:	0f b6 00             	movzbl (%rax),%eax
  80223a:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  80223d:	eb 32                	jmp    802271 <vprintfmt+0x103>
					putch(ch, putdat);
  80223f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802243:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802247:	48 89 d6             	mov    %rdx,%rsi
  80224a:	89 df                	mov    %ebx,%edi
  80224c:	ff d0                	callq  *%rax
					esc_color *= 10;
  80224e:	44 89 e0             	mov    %r12d,%eax
  802251:	c1 e0 02             	shl    $0x2,%eax
  802254:	44 01 e0             	add    %r12d,%eax
  802257:	01 c0                	add    %eax,%eax
  802259:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  80225c:	8d 43 d0             	lea    -0x30(%rbx),%eax
  80225f:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  802262:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  802267:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80226b:	0f b6 00             	movzbl (%rax),%eax
  80226e:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  802271:	83 fb 3b             	cmp    $0x3b,%ebx
  802274:	74 05                	je     80227b <vprintfmt+0x10d>
  802276:	83 fb 6d             	cmp    $0x6d,%ebx
  802279:	75 c4                	jne    80223f <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  80227b:	45 85 e4             	test   %r12d,%r12d
  80227e:	75 15                	jne    802295 <vprintfmt+0x127>
					color_flag = 0x07;
  802280:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802287:	00 00 00 
  80228a:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  802290:	e9 dc 00 00 00       	jmpq   802371 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  802295:	41 83 fc 1d          	cmp    $0x1d,%r12d
  802299:	7e 69                	jle    802304 <vprintfmt+0x196>
  80229b:	41 83 fc 25          	cmp    $0x25,%r12d
  80229f:	7f 63                	jg     802304 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  8022a1:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  8022a8:	00 00 00 
  8022ab:	8b 00                	mov    (%rax),%eax
  8022ad:	25 f8 00 00 00       	and    $0xf8,%eax
  8022b2:	89 c2                	mov    %eax,%edx
  8022b4:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  8022bb:	00 00 00 
  8022be:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  8022c0:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  8022c4:	44 89 e0             	mov    %r12d,%eax
  8022c7:	83 e0 04             	and    $0x4,%eax
  8022ca:	c1 f8 02             	sar    $0x2,%eax
  8022cd:	89 c2                	mov    %eax,%edx
  8022cf:	44 89 e0             	mov    %r12d,%eax
  8022d2:	83 e0 02             	and    $0x2,%eax
  8022d5:	09 c2                	or     %eax,%edx
  8022d7:	44 89 e0             	mov    %r12d,%eax
  8022da:	83 e0 01             	and    $0x1,%eax
  8022dd:	c1 e0 02             	shl    $0x2,%eax
  8022e0:	09 c2                	or     %eax,%edx
  8022e2:	41 89 d4             	mov    %edx,%r12d
  8022e5:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  8022ec:	00 00 00 
  8022ef:	8b 00                	mov    (%rax),%eax
  8022f1:	44 89 e2             	mov    %r12d,%edx
  8022f4:	09 c2                	or     %eax,%edx
  8022f6:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  8022fd:	00 00 00 
  802300:	89 10                	mov    %edx,(%rax)
  802302:	eb 6d                	jmp    802371 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  802304:	41 83 fc 27          	cmp    $0x27,%r12d
  802308:	7e 67                	jle    802371 <vprintfmt+0x203>
  80230a:	41 83 fc 2f          	cmp    $0x2f,%r12d
  80230e:	7f 61                	jg     802371 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  802310:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802317:	00 00 00 
  80231a:	8b 00                	mov    (%rax),%eax
  80231c:	25 8f 00 00 00       	and    $0x8f,%eax
  802321:	89 c2                	mov    %eax,%edx
  802323:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  80232a:	00 00 00 
  80232d:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  80232f:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  802333:	44 89 e0             	mov    %r12d,%eax
  802336:	83 e0 04             	and    $0x4,%eax
  802339:	c1 f8 02             	sar    $0x2,%eax
  80233c:	89 c2                	mov    %eax,%edx
  80233e:	44 89 e0             	mov    %r12d,%eax
  802341:	83 e0 02             	and    $0x2,%eax
  802344:	09 c2                	or     %eax,%edx
  802346:	44 89 e0             	mov    %r12d,%eax
  802349:	83 e0 01             	and    $0x1,%eax
  80234c:	c1 e0 06             	shl    $0x6,%eax
  80234f:	09 c2                	or     %eax,%edx
  802351:	41 89 d4             	mov    %edx,%r12d
  802354:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  80235b:	00 00 00 
  80235e:	8b 00                	mov    (%rax),%eax
  802360:	44 89 e2             	mov    %r12d,%edx
  802363:	09 c2                	or     %eax,%edx
  802365:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  80236c:	00 00 00 
  80236f:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  802371:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802375:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802379:	48 89 d6             	mov    %rdx,%rsi
  80237c:	89 df                	mov    %ebx,%edi
  80237e:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  802380:	83 fb 6d             	cmp    $0x6d,%ebx
  802383:	75 1b                	jne    8023a0 <vprintfmt+0x232>
					fmt ++;
  802385:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  80238a:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  80238b:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802392:	00 00 00 
  802395:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  80239b:	e9 cb 04 00 00       	jmpq   80286b <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  8023a0:	e9 83 fe ff ff       	jmpq   802228 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  8023a5:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8023a9:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8023b0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8023b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8023be:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8023c5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8023c9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8023cd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8023d1:	0f b6 00             	movzbl (%rax),%eax
  8023d4:	0f b6 d8             	movzbl %al,%ebx
  8023d7:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8023da:	83 f8 55             	cmp    $0x55,%eax
  8023dd:	0f 87 5a 04 00 00    	ja     80283d <vprintfmt+0x6cf>
  8023e3:	89 c0                	mov    %eax,%eax
  8023e5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8023ec:	00 
  8023ed:	48 b8 50 38 80 00 00 	movabs $0x803850,%rax
  8023f4:	00 00 00 
  8023f7:	48 01 d0             	add    %rdx,%rax
  8023fa:	48 8b 00             	mov    (%rax),%rax
  8023fd:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8023ff:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802403:	eb c0                	jmp    8023c5 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802405:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802409:	eb ba                	jmp    8023c5 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80240b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802412:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802415:	89 d0                	mov    %edx,%eax
  802417:	c1 e0 02             	shl    $0x2,%eax
  80241a:	01 d0                	add    %edx,%eax
  80241c:	01 c0                	add    %eax,%eax
  80241e:	01 d8                	add    %ebx,%eax
  802420:	83 e8 30             	sub    $0x30,%eax
  802423:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802426:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80242a:	0f b6 00             	movzbl (%rax),%eax
  80242d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802430:	83 fb 2f             	cmp    $0x2f,%ebx
  802433:	7e 0c                	jle    802441 <vprintfmt+0x2d3>
  802435:	83 fb 39             	cmp    $0x39,%ebx
  802438:	7f 07                	jg     802441 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80243a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80243f:	eb d1                	jmp    802412 <vprintfmt+0x2a4>
			goto process_precision;
  802441:	eb 58                	jmp    80249b <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  802443:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802446:	83 f8 30             	cmp    $0x30,%eax
  802449:	73 17                	jae    802462 <vprintfmt+0x2f4>
  80244b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80244f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802452:	89 c0                	mov    %eax,%eax
  802454:	48 01 d0             	add    %rdx,%rax
  802457:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80245a:	83 c2 08             	add    $0x8,%edx
  80245d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802460:	eb 0f                	jmp    802471 <vprintfmt+0x303>
  802462:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802466:	48 89 d0             	mov    %rdx,%rax
  802469:	48 83 c2 08          	add    $0x8,%rdx
  80246d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802471:	8b 00                	mov    (%rax),%eax
  802473:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802476:	eb 23                	jmp    80249b <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  802478:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80247c:	79 0c                	jns    80248a <vprintfmt+0x31c>
				width = 0;
  80247e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802485:	e9 3b ff ff ff       	jmpq   8023c5 <vprintfmt+0x257>
  80248a:	e9 36 ff ff ff       	jmpq   8023c5 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  80248f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802496:	e9 2a ff ff ff       	jmpq   8023c5 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  80249b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80249f:	79 12                	jns    8024b3 <vprintfmt+0x345>
				width = precision, precision = -1;
  8024a1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8024a4:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8024a7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8024ae:	e9 12 ff ff ff       	jmpq   8023c5 <vprintfmt+0x257>
  8024b3:	e9 0d ff ff ff       	jmpq   8023c5 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8024b8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8024bc:	e9 04 ff ff ff       	jmpq   8023c5 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8024c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024c4:	83 f8 30             	cmp    $0x30,%eax
  8024c7:	73 17                	jae    8024e0 <vprintfmt+0x372>
  8024c9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024cd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024d0:	89 c0                	mov    %eax,%eax
  8024d2:	48 01 d0             	add    %rdx,%rax
  8024d5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8024d8:	83 c2 08             	add    $0x8,%edx
  8024db:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8024de:	eb 0f                	jmp    8024ef <vprintfmt+0x381>
  8024e0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024e4:	48 89 d0             	mov    %rdx,%rax
  8024e7:	48 83 c2 08          	add    $0x8,%rdx
  8024eb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8024ef:	8b 10                	mov    (%rax),%edx
  8024f1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8024f5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8024f9:	48 89 ce             	mov    %rcx,%rsi
  8024fc:	89 d7                	mov    %edx,%edi
  8024fe:	ff d0                	callq  *%rax
			break;
  802500:	e9 66 03 00 00       	jmpq   80286b <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  802505:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802508:	83 f8 30             	cmp    $0x30,%eax
  80250b:	73 17                	jae    802524 <vprintfmt+0x3b6>
  80250d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802511:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802514:	89 c0                	mov    %eax,%eax
  802516:	48 01 d0             	add    %rdx,%rax
  802519:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80251c:	83 c2 08             	add    $0x8,%edx
  80251f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802522:	eb 0f                	jmp    802533 <vprintfmt+0x3c5>
  802524:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802528:	48 89 d0             	mov    %rdx,%rax
  80252b:	48 83 c2 08          	add    $0x8,%rdx
  80252f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802533:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802535:	85 db                	test   %ebx,%ebx
  802537:	79 02                	jns    80253b <vprintfmt+0x3cd>
				err = -err;
  802539:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80253b:	83 fb 10             	cmp    $0x10,%ebx
  80253e:	7f 16                	jg     802556 <vprintfmt+0x3e8>
  802540:	48 b8 a0 37 80 00 00 	movabs $0x8037a0,%rax
  802547:	00 00 00 
  80254a:	48 63 d3             	movslq %ebx,%rdx
  80254d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802551:	4d 85 e4             	test   %r12,%r12
  802554:	75 2e                	jne    802584 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  802556:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80255a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80255e:	89 d9                	mov    %ebx,%ecx
  802560:	48 ba 39 38 80 00 00 	movabs $0x803839,%rdx
  802567:	00 00 00 
  80256a:	48 89 c7             	mov    %rax,%rdi
  80256d:	b8 00 00 00 00       	mov    $0x0,%eax
  802572:	49 b8 79 28 80 00 00 	movabs $0x802879,%r8
  802579:	00 00 00 
  80257c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80257f:	e9 e7 02 00 00       	jmpq   80286b <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802584:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802588:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80258c:	4c 89 e1             	mov    %r12,%rcx
  80258f:	48 ba 42 38 80 00 00 	movabs $0x803842,%rdx
  802596:	00 00 00 
  802599:	48 89 c7             	mov    %rax,%rdi
  80259c:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a1:	49 b8 79 28 80 00 00 	movabs $0x802879,%r8
  8025a8:	00 00 00 
  8025ab:	41 ff d0             	callq  *%r8
			break;
  8025ae:	e9 b8 02 00 00       	jmpq   80286b <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8025b3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025b6:	83 f8 30             	cmp    $0x30,%eax
  8025b9:	73 17                	jae    8025d2 <vprintfmt+0x464>
  8025bb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025bf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025c2:	89 c0                	mov    %eax,%eax
  8025c4:	48 01 d0             	add    %rdx,%rax
  8025c7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025ca:	83 c2 08             	add    $0x8,%edx
  8025cd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025d0:	eb 0f                	jmp    8025e1 <vprintfmt+0x473>
  8025d2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025d6:	48 89 d0             	mov    %rdx,%rax
  8025d9:	48 83 c2 08          	add    $0x8,%rdx
  8025dd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025e1:	4c 8b 20             	mov    (%rax),%r12
  8025e4:	4d 85 e4             	test   %r12,%r12
  8025e7:	75 0a                	jne    8025f3 <vprintfmt+0x485>
				p = "(null)";
  8025e9:	49 bc 45 38 80 00 00 	movabs $0x803845,%r12
  8025f0:	00 00 00 
			if (width > 0 && padc != '-')
  8025f3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8025f7:	7e 3f                	jle    802638 <vprintfmt+0x4ca>
  8025f9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8025fd:	74 39                	je     802638 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  8025ff:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802602:	48 98                	cltq   
  802604:	48 89 c6             	mov    %rax,%rsi
  802607:	4c 89 e7             	mov    %r12,%rdi
  80260a:	48 b8 25 2b 80 00 00 	movabs $0x802b25,%rax
  802611:	00 00 00 
  802614:	ff d0                	callq  *%rax
  802616:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802619:	eb 17                	jmp    802632 <vprintfmt+0x4c4>
					putch(padc, putdat);
  80261b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80261f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802623:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802627:	48 89 ce             	mov    %rcx,%rsi
  80262a:	89 d7                	mov    %edx,%edi
  80262c:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80262e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802632:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802636:	7f e3                	jg     80261b <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802638:	eb 37                	jmp    802671 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  80263a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80263e:	74 1e                	je     80265e <vprintfmt+0x4f0>
  802640:	83 fb 1f             	cmp    $0x1f,%ebx
  802643:	7e 05                	jle    80264a <vprintfmt+0x4dc>
  802645:	83 fb 7e             	cmp    $0x7e,%ebx
  802648:	7e 14                	jle    80265e <vprintfmt+0x4f0>
					putch('?', putdat);
  80264a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80264e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802652:	48 89 d6             	mov    %rdx,%rsi
  802655:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80265a:	ff d0                	callq  *%rax
  80265c:	eb 0f                	jmp    80266d <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  80265e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802662:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802666:	48 89 d6             	mov    %rdx,%rsi
  802669:	89 df                	mov    %ebx,%edi
  80266b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80266d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802671:	4c 89 e0             	mov    %r12,%rax
  802674:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802678:	0f b6 00             	movzbl (%rax),%eax
  80267b:	0f be d8             	movsbl %al,%ebx
  80267e:	85 db                	test   %ebx,%ebx
  802680:	74 10                	je     802692 <vprintfmt+0x524>
  802682:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802686:	78 b2                	js     80263a <vprintfmt+0x4cc>
  802688:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80268c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802690:	79 a8                	jns    80263a <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802692:	eb 16                	jmp    8026aa <vprintfmt+0x53c>
				putch(' ', putdat);
  802694:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802698:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80269c:	48 89 d6             	mov    %rdx,%rsi
  80269f:	bf 20 00 00 00       	mov    $0x20,%edi
  8026a4:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8026a6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8026aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026ae:	7f e4                	jg     802694 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  8026b0:	e9 b6 01 00 00       	jmpq   80286b <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8026b5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8026b9:	be 03 00 00 00       	mov    $0x3,%esi
  8026be:	48 89 c7             	mov    %rax,%rdi
  8026c1:	48 b8 5e 20 80 00 00 	movabs $0x80205e,%rax
  8026c8:	00 00 00 
  8026cb:	ff d0                	callq  *%rax
  8026cd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8026d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d5:	48 85 c0             	test   %rax,%rax
  8026d8:	79 1d                	jns    8026f7 <vprintfmt+0x589>
				putch('-', putdat);
  8026da:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8026de:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026e2:	48 89 d6             	mov    %rdx,%rsi
  8026e5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8026ea:	ff d0                	callq  *%rax
				num = -(long long) num;
  8026ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f0:	48 f7 d8             	neg    %rax
  8026f3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8026f7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8026fe:	e9 fb 00 00 00       	jmpq   8027fe <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  802703:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802707:	be 03 00 00 00       	mov    $0x3,%esi
  80270c:	48 89 c7             	mov    %rax,%rdi
  80270f:	48 b8 4e 1f 80 00 00 	movabs $0x801f4e,%rax
  802716:	00 00 00 
  802719:	ff d0                	callq  *%rax
  80271b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80271f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802726:	e9 d3 00 00 00       	jmpq   8027fe <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  80272b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80272f:	be 03 00 00 00       	mov    $0x3,%esi
  802734:	48 89 c7             	mov    %rax,%rdi
  802737:	48 b8 5e 20 80 00 00 	movabs $0x80205e,%rax
  80273e:	00 00 00 
  802741:	ff d0                	callq  *%rax
  802743:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802747:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274b:	48 85 c0             	test   %rax,%rax
  80274e:	79 1d                	jns    80276d <vprintfmt+0x5ff>
				putch('-', putdat);
  802750:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802754:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802758:	48 89 d6             	mov    %rdx,%rsi
  80275b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802760:	ff d0                	callq  *%rax
				num = -(long long) num;
  802762:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802766:	48 f7 d8             	neg    %rax
  802769:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  80276d:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  802774:	e9 85 00 00 00       	jmpq   8027fe <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  802779:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80277d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802781:	48 89 d6             	mov    %rdx,%rsi
  802784:	bf 30 00 00 00       	mov    $0x30,%edi
  802789:	ff d0                	callq  *%rax
			putch('x', putdat);
  80278b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80278f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802793:	48 89 d6             	mov    %rdx,%rsi
  802796:	bf 78 00 00 00       	mov    $0x78,%edi
  80279b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80279d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8027a0:	83 f8 30             	cmp    $0x30,%eax
  8027a3:	73 17                	jae    8027bc <vprintfmt+0x64e>
  8027a5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027a9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8027ac:	89 c0                	mov    %eax,%eax
  8027ae:	48 01 d0             	add    %rdx,%rax
  8027b1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8027b4:	83 c2 08             	add    $0x8,%edx
  8027b7:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8027ba:	eb 0f                	jmp    8027cb <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  8027bc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8027c0:	48 89 d0             	mov    %rdx,%rax
  8027c3:	48 83 c2 08          	add    $0x8,%rdx
  8027c7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8027cb:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8027ce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8027d2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8027d9:	eb 23                	jmp    8027fe <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8027db:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027df:	be 03 00 00 00       	mov    $0x3,%esi
  8027e4:	48 89 c7             	mov    %rax,%rdi
  8027e7:	48 b8 4e 1f 80 00 00 	movabs $0x801f4e,%rax
  8027ee:	00 00 00 
  8027f1:	ff d0                	callq  *%rax
  8027f3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8027f7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8027fe:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  802803:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802806:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802809:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80280d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802811:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802815:	45 89 c1             	mov    %r8d,%r9d
  802818:	41 89 f8             	mov    %edi,%r8d
  80281b:	48 89 c7             	mov    %rax,%rdi
  80281e:	48 b8 93 1e 80 00 00 	movabs $0x801e93,%rax
  802825:	00 00 00 
  802828:	ff d0                	callq  *%rax
			break;
  80282a:	eb 3f                	jmp    80286b <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80282c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802830:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802834:	48 89 d6             	mov    %rdx,%rsi
  802837:	89 df                	mov    %ebx,%edi
  802839:	ff d0                	callq  *%rax
			break;
  80283b:	eb 2e                	jmp    80286b <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80283d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802841:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802845:	48 89 d6             	mov    %rdx,%rsi
  802848:	bf 25 00 00 00       	mov    $0x25,%edi
  80284d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80284f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802854:	eb 05                	jmp    80285b <vprintfmt+0x6ed>
  802856:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80285b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80285f:	48 83 e8 01          	sub    $0x1,%rax
  802863:	0f b6 00             	movzbl (%rax),%eax
  802866:	3c 25                	cmp    $0x25,%al
  802868:	75 ec                	jne    802856 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  80286a:	90                   	nop
		}
	}
  80286b:	e9 37 f9 ff ff       	jmpq   8021a7 <vprintfmt+0x39>
    va_end(aq);
}
  802870:	48 83 c4 60          	add    $0x60,%rsp
  802874:	5b                   	pop    %rbx
  802875:	41 5c                	pop    %r12
  802877:	5d                   	pop    %rbp
  802878:	c3                   	retq   

0000000000802879 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802879:	55                   	push   %rbp
  80287a:	48 89 e5             	mov    %rsp,%rbp
  80287d:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802884:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80288b:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802892:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802899:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8028a0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8028a7:	84 c0                	test   %al,%al
  8028a9:	74 20                	je     8028cb <printfmt+0x52>
  8028ab:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8028af:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8028b3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8028b7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8028bb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8028bf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8028c3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8028c7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8028cb:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8028d2:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8028d9:	00 00 00 
  8028dc:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8028e3:	00 00 00 
  8028e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8028ea:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8028f1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8028f8:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8028ff:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  802906:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80290d:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  802914:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80291b:	48 89 c7             	mov    %rax,%rdi
  80291e:	48 b8 6e 21 80 00 00 	movabs $0x80216e,%rax
  802925:	00 00 00 
  802928:	ff d0                	callq  *%rax
	va_end(ap);
}
  80292a:	c9                   	leaveq 
  80292b:	c3                   	retq   

000000000080292c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80292c:	55                   	push   %rbp
  80292d:	48 89 e5             	mov    %rsp,%rbp
  802930:	48 83 ec 10          	sub    $0x10,%rsp
  802934:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802937:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80293b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80293f:	8b 40 10             	mov    0x10(%rax),%eax
  802942:	8d 50 01             	lea    0x1(%rax),%edx
  802945:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802949:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80294c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802950:	48 8b 10             	mov    (%rax),%rdx
  802953:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802957:	48 8b 40 08          	mov    0x8(%rax),%rax
  80295b:	48 39 c2             	cmp    %rax,%rdx
  80295e:	73 17                	jae    802977 <sprintputch+0x4b>
		*b->buf++ = ch;
  802960:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802964:	48 8b 00             	mov    (%rax),%rax
  802967:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80296b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80296f:	48 89 0a             	mov    %rcx,(%rdx)
  802972:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802975:	88 10                	mov    %dl,(%rax)
}
  802977:	c9                   	leaveq 
  802978:	c3                   	retq   

0000000000802979 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802979:	55                   	push   %rbp
  80297a:	48 89 e5             	mov    %rsp,%rbp
  80297d:	48 83 ec 50          	sub    $0x50,%rsp
  802981:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802985:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802988:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80298c:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802990:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802994:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802998:	48 8b 0a             	mov    (%rdx),%rcx
  80299b:	48 89 08             	mov    %rcx,(%rax)
  80299e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8029a2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8029a6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8029aa:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8029ae:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029b2:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8029b6:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8029b9:	48 98                	cltq   
  8029bb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8029bf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029c3:	48 01 d0             	add    %rdx,%rax
  8029c6:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8029ca:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8029d1:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8029d6:	74 06                	je     8029de <vsnprintf+0x65>
  8029d8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8029dc:	7f 07                	jg     8029e5 <vsnprintf+0x6c>
		return -E_INVAL;
  8029de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029e3:	eb 2f                	jmp    802a14 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8029e5:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8029e9:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8029ed:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8029f1:	48 89 c6             	mov    %rax,%rsi
  8029f4:	48 bf 2c 29 80 00 00 	movabs $0x80292c,%rdi
  8029fb:	00 00 00 
  8029fe:	48 b8 6e 21 80 00 00 	movabs $0x80216e,%rax
  802a05:	00 00 00 
  802a08:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802a0a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a0e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802a11:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802a14:	c9                   	leaveq 
  802a15:	c3                   	retq   

0000000000802a16 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802a16:	55                   	push   %rbp
  802a17:	48 89 e5             	mov    %rsp,%rbp
  802a1a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802a21:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802a28:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802a2e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802a35:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802a3c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802a43:	84 c0                	test   %al,%al
  802a45:	74 20                	je     802a67 <snprintf+0x51>
  802a47:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802a4b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802a4f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802a53:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802a57:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802a5b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802a5f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802a63:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802a67:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802a6e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802a75:	00 00 00 
  802a78:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802a7f:	00 00 00 
  802a82:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802a86:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802a8d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802a94:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802a9b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802aa2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802aa9:	48 8b 0a             	mov    (%rdx),%rcx
  802aac:	48 89 08             	mov    %rcx,(%rax)
  802aaf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802ab3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802ab7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802abb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802abf:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802ac6:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802acd:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802ad3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802ada:	48 89 c7             	mov    %rax,%rdi
  802add:	48 b8 79 29 80 00 00 	movabs $0x802979,%rax
  802ae4:	00 00 00 
  802ae7:	ff d0                	callq  *%rax
  802ae9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802aef:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802af5:	c9                   	leaveq 
  802af6:	c3                   	retq   

0000000000802af7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802af7:	55                   	push   %rbp
  802af8:	48 89 e5             	mov    %rsp,%rbp
  802afb:	48 83 ec 18          	sub    $0x18,%rsp
  802aff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802b03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b0a:	eb 09                	jmp    802b15 <strlen+0x1e>
		n++;
  802b0c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802b10:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802b15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b19:	0f b6 00             	movzbl (%rax),%eax
  802b1c:	84 c0                	test   %al,%al
  802b1e:	75 ec                	jne    802b0c <strlen+0x15>
		n++;
	return n;
  802b20:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b23:	c9                   	leaveq 
  802b24:	c3                   	retq   

0000000000802b25 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802b25:	55                   	push   %rbp
  802b26:	48 89 e5             	mov    %rsp,%rbp
  802b29:	48 83 ec 20          	sub    $0x20,%rsp
  802b2d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b31:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802b35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b3c:	eb 0e                	jmp    802b4c <strnlen+0x27>
		n++;
  802b3e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802b42:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802b47:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802b4c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802b51:	74 0b                	je     802b5e <strnlen+0x39>
  802b53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b57:	0f b6 00             	movzbl (%rax),%eax
  802b5a:	84 c0                	test   %al,%al
  802b5c:	75 e0                	jne    802b3e <strnlen+0x19>
		n++;
	return n;
  802b5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b61:	c9                   	leaveq 
  802b62:	c3                   	retq   

0000000000802b63 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802b63:	55                   	push   %rbp
  802b64:	48 89 e5             	mov    %rsp,%rbp
  802b67:	48 83 ec 20          	sub    $0x20,%rsp
  802b6b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b6f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802b73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b77:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802b7b:	90                   	nop
  802b7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b80:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802b84:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802b88:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b8c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802b90:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802b94:	0f b6 12             	movzbl (%rdx),%edx
  802b97:	88 10                	mov    %dl,(%rax)
  802b99:	0f b6 00             	movzbl (%rax),%eax
  802b9c:	84 c0                	test   %al,%al
  802b9e:	75 dc                	jne    802b7c <strcpy+0x19>
		/* do nothing */;
	return ret;
  802ba0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802ba4:	c9                   	leaveq 
  802ba5:	c3                   	retq   

0000000000802ba6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802ba6:	55                   	push   %rbp
  802ba7:	48 89 e5             	mov    %rsp,%rbp
  802baa:	48 83 ec 20          	sub    $0x20,%rsp
  802bae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bb2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802bb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bba:	48 89 c7             	mov    %rax,%rdi
  802bbd:	48 b8 f7 2a 80 00 00 	movabs $0x802af7,%rax
  802bc4:	00 00 00 
  802bc7:	ff d0                	callq  *%rax
  802bc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802bcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bcf:	48 63 d0             	movslq %eax,%rdx
  802bd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd6:	48 01 c2             	add    %rax,%rdx
  802bd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bdd:	48 89 c6             	mov    %rax,%rsi
  802be0:	48 89 d7             	mov    %rdx,%rdi
  802be3:	48 b8 63 2b 80 00 00 	movabs $0x802b63,%rax
  802bea:	00 00 00 
  802bed:	ff d0                	callq  *%rax
	return dst;
  802bef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802bf3:	c9                   	leaveq 
  802bf4:	c3                   	retq   

0000000000802bf5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802bf5:	55                   	push   %rbp
  802bf6:	48 89 e5             	mov    %rsp,%rbp
  802bf9:	48 83 ec 28          	sub    $0x28,%rsp
  802bfd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c01:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c05:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802c09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c0d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802c11:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802c18:	00 
  802c19:	eb 2a                	jmp    802c45 <strncpy+0x50>
		*dst++ = *src;
  802c1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c23:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c27:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c2b:	0f b6 12             	movzbl (%rdx),%edx
  802c2e:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802c30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c34:	0f b6 00             	movzbl (%rax),%eax
  802c37:	84 c0                	test   %al,%al
  802c39:	74 05                	je     802c40 <strncpy+0x4b>
			src++;
  802c3b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802c40:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802c45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c49:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c4d:	72 cc                	jb     802c1b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802c4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802c53:	c9                   	leaveq 
  802c54:	c3                   	retq   

0000000000802c55 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802c55:	55                   	push   %rbp
  802c56:	48 89 e5             	mov    %rsp,%rbp
  802c59:	48 83 ec 28          	sub    $0x28,%rsp
  802c5d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c61:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c65:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802c69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c6d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802c71:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802c76:	74 3d                	je     802cb5 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802c78:	eb 1d                	jmp    802c97 <strlcpy+0x42>
			*dst++ = *src++;
  802c7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c82:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c86:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c8a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802c8e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802c92:	0f b6 12             	movzbl (%rdx),%edx
  802c95:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802c97:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802c9c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802ca1:	74 0b                	je     802cae <strlcpy+0x59>
  802ca3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ca7:	0f b6 00             	movzbl (%rax),%eax
  802caa:	84 c0                	test   %al,%al
  802cac:	75 cc                	jne    802c7a <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802cae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb2:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802cb5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cbd:	48 29 c2             	sub    %rax,%rdx
  802cc0:	48 89 d0             	mov    %rdx,%rax
}
  802cc3:	c9                   	leaveq 
  802cc4:	c3                   	retq   

0000000000802cc5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802cc5:	55                   	push   %rbp
  802cc6:	48 89 e5             	mov    %rsp,%rbp
  802cc9:	48 83 ec 10          	sub    $0x10,%rsp
  802ccd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802cd1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802cd5:	eb 0a                	jmp    802ce1 <strcmp+0x1c>
		p++, q++;
  802cd7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802cdc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802ce1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ce5:	0f b6 00             	movzbl (%rax),%eax
  802ce8:	84 c0                	test   %al,%al
  802cea:	74 12                	je     802cfe <strcmp+0x39>
  802cec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cf0:	0f b6 10             	movzbl (%rax),%edx
  802cf3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf7:	0f b6 00             	movzbl (%rax),%eax
  802cfa:	38 c2                	cmp    %al,%dl
  802cfc:	74 d9                	je     802cd7 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802cfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d02:	0f b6 00             	movzbl (%rax),%eax
  802d05:	0f b6 d0             	movzbl %al,%edx
  802d08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d0c:	0f b6 00             	movzbl (%rax),%eax
  802d0f:	0f b6 c0             	movzbl %al,%eax
  802d12:	29 c2                	sub    %eax,%edx
  802d14:	89 d0                	mov    %edx,%eax
}
  802d16:	c9                   	leaveq 
  802d17:	c3                   	retq   

0000000000802d18 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802d18:	55                   	push   %rbp
  802d19:	48 89 e5             	mov    %rsp,%rbp
  802d1c:	48 83 ec 18          	sub    $0x18,%rsp
  802d20:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d24:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d28:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802d2c:	eb 0f                	jmp    802d3d <strncmp+0x25>
		n--, p++, q++;
  802d2e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802d33:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d38:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802d3d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d42:	74 1d                	je     802d61 <strncmp+0x49>
  802d44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d48:	0f b6 00             	movzbl (%rax),%eax
  802d4b:	84 c0                	test   %al,%al
  802d4d:	74 12                	je     802d61 <strncmp+0x49>
  802d4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d53:	0f b6 10             	movzbl (%rax),%edx
  802d56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5a:	0f b6 00             	movzbl (%rax),%eax
  802d5d:	38 c2                	cmp    %al,%dl
  802d5f:	74 cd                	je     802d2e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802d61:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d66:	75 07                	jne    802d6f <strncmp+0x57>
		return 0;
  802d68:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6d:	eb 18                	jmp    802d87 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802d6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d73:	0f b6 00             	movzbl (%rax),%eax
  802d76:	0f b6 d0             	movzbl %al,%edx
  802d79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d7d:	0f b6 00             	movzbl (%rax),%eax
  802d80:	0f b6 c0             	movzbl %al,%eax
  802d83:	29 c2                	sub    %eax,%edx
  802d85:	89 d0                	mov    %edx,%eax
}
  802d87:	c9                   	leaveq 
  802d88:	c3                   	retq   

0000000000802d89 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802d89:	55                   	push   %rbp
  802d8a:	48 89 e5             	mov    %rsp,%rbp
  802d8d:	48 83 ec 0c          	sub    $0xc,%rsp
  802d91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d95:	89 f0                	mov    %esi,%eax
  802d97:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802d9a:	eb 17                	jmp    802db3 <strchr+0x2a>
		if (*s == c)
  802d9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802da0:	0f b6 00             	movzbl (%rax),%eax
  802da3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802da6:	75 06                	jne    802dae <strchr+0x25>
			return (char *) s;
  802da8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dac:	eb 15                	jmp    802dc3 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802dae:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802db3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802db7:	0f b6 00             	movzbl (%rax),%eax
  802dba:	84 c0                	test   %al,%al
  802dbc:	75 de                	jne    802d9c <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802dbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dc3:	c9                   	leaveq 
  802dc4:	c3                   	retq   

0000000000802dc5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802dc5:	55                   	push   %rbp
  802dc6:	48 89 e5             	mov    %rsp,%rbp
  802dc9:	48 83 ec 0c          	sub    $0xc,%rsp
  802dcd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dd1:	89 f0                	mov    %esi,%eax
  802dd3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802dd6:	eb 13                	jmp    802deb <strfind+0x26>
		if (*s == c)
  802dd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ddc:	0f b6 00             	movzbl (%rax),%eax
  802ddf:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802de2:	75 02                	jne    802de6 <strfind+0x21>
			break;
  802de4:	eb 10                	jmp    802df6 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802de6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802deb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802def:	0f b6 00             	movzbl (%rax),%eax
  802df2:	84 c0                	test   %al,%al
  802df4:	75 e2                	jne    802dd8 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802df6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802dfa:	c9                   	leaveq 
  802dfb:	c3                   	retq   

0000000000802dfc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802dfc:	55                   	push   %rbp
  802dfd:	48 89 e5             	mov    %rsp,%rbp
  802e00:	48 83 ec 18          	sub    $0x18,%rsp
  802e04:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e08:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802e0b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802e0f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e14:	75 06                	jne    802e1c <memset+0x20>
		return v;
  802e16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e1a:	eb 69                	jmp    802e85 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802e1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e20:	83 e0 03             	and    $0x3,%eax
  802e23:	48 85 c0             	test   %rax,%rax
  802e26:	75 48                	jne    802e70 <memset+0x74>
  802e28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2c:	83 e0 03             	and    $0x3,%eax
  802e2f:	48 85 c0             	test   %rax,%rax
  802e32:	75 3c                	jne    802e70 <memset+0x74>
		c &= 0xFF;
  802e34:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802e3b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e3e:	c1 e0 18             	shl    $0x18,%eax
  802e41:	89 c2                	mov    %eax,%edx
  802e43:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e46:	c1 e0 10             	shl    $0x10,%eax
  802e49:	09 c2                	or     %eax,%edx
  802e4b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e4e:	c1 e0 08             	shl    $0x8,%eax
  802e51:	09 d0                	or     %edx,%eax
  802e53:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  802e56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5a:	48 c1 e8 02          	shr    $0x2,%rax
  802e5e:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802e61:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e65:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e68:	48 89 d7             	mov    %rdx,%rdi
  802e6b:	fc                   	cld    
  802e6c:	f3 ab                	rep stos %eax,%es:(%rdi)
  802e6e:	eb 11                	jmp    802e81 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802e70:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e74:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e77:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e7b:	48 89 d7             	mov    %rdx,%rdi
  802e7e:	fc                   	cld    
  802e7f:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  802e81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e85:	c9                   	leaveq 
  802e86:	c3                   	retq   

0000000000802e87 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802e87:	55                   	push   %rbp
  802e88:	48 89 e5             	mov    %rsp,%rbp
  802e8b:	48 83 ec 28          	sub    $0x28,%rsp
  802e8f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e93:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e97:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802e9b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e9f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802ea3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802eab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eaf:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802eb3:	0f 83 88 00 00 00    	jae    802f41 <memmove+0xba>
  802eb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ebd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ec1:	48 01 d0             	add    %rdx,%rax
  802ec4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802ec8:	76 77                	jbe    802f41 <memmove+0xba>
		s += n;
  802eca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ece:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802ed2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ed6:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802eda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ede:	83 e0 03             	and    $0x3,%eax
  802ee1:	48 85 c0             	test   %rax,%rax
  802ee4:	75 3b                	jne    802f21 <memmove+0x9a>
  802ee6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eea:	83 e0 03             	and    $0x3,%eax
  802eed:	48 85 c0             	test   %rax,%rax
  802ef0:	75 2f                	jne    802f21 <memmove+0x9a>
  802ef2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ef6:	83 e0 03             	and    $0x3,%eax
  802ef9:	48 85 c0             	test   %rax,%rax
  802efc:	75 23                	jne    802f21 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802efe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f02:	48 83 e8 04          	sub    $0x4,%rax
  802f06:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f0a:	48 83 ea 04          	sub    $0x4,%rdx
  802f0e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802f12:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802f16:	48 89 c7             	mov    %rax,%rdi
  802f19:	48 89 d6             	mov    %rdx,%rsi
  802f1c:	fd                   	std    
  802f1d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802f1f:	eb 1d                	jmp    802f3e <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802f21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f25:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802f29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f2d:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802f31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f35:	48 89 d7             	mov    %rdx,%rdi
  802f38:	48 89 c1             	mov    %rax,%rcx
  802f3b:	fd                   	std    
  802f3c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802f3e:	fc                   	cld    
  802f3f:	eb 57                	jmp    802f98 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802f41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f45:	83 e0 03             	and    $0x3,%eax
  802f48:	48 85 c0             	test   %rax,%rax
  802f4b:	75 36                	jne    802f83 <memmove+0xfc>
  802f4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f51:	83 e0 03             	and    $0x3,%eax
  802f54:	48 85 c0             	test   %rax,%rax
  802f57:	75 2a                	jne    802f83 <memmove+0xfc>
  802f59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f5d:	83 e0 03             	and    $0x3,%eax
  802f60:	48 85 c0             	test   %rax,%rax
  802f63:	75 1e                	jne    802f83 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802f65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f69:	48 c1 e8 02          	shr    $0x2,%rax
  802f6d:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  802f70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f74:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f78:	48 89 c7             	mov    %rax,%rdi
  802f7b:	48 89 d6             	mov    %rdx,%rsi
  802f7e:	fc                   	cld    
  802f7f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802f81:	eb 15                	jmp    802f98 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802f83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f87:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f8b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802f8f:	48 89 c7             	mov    %rax,%rdi
  802f92:	48 89 d6             	mov    %rdx,%rsi
  802f95:	fc                   	cld    
  802f96:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  802f98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802f9c:	c9                   	leaveq 
  802f9d:	c3                   	retq   

0000000000802f9e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802f9e:	55                   	push   %rbp
  802f9f:	48 89 e5             	mov    %rsp,%rbp
  802fa2:	48 83 ec 18          	sub    $0x18,%rsp
  802fa6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802faa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802fae:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  802fb2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802fb6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802fba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fbe:	48 89 ce             	mov    %rcx,%rsi
  802fc1:	48 89 c7             	mov    %rax,%rdi
  802fc4:	48 b8 87 2e 80 00 00 	movabs $0x802e87,%rax
  802fcb:	00 00 00 
  802fce:	ff d0                	callq  *%rax
}
  802fd0:	c9                   	leaveq 
  802fd1:	c3                   	retq   

0000000000802fd2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802fd2:	55                   	push   %rbp
  802fd3:	48 89 e5             	mov    %rsp,%rbp
  802fd6:	48 83 ec 28          	sub    $0x28,%rsp
  802fda:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fde:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fe2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  802fe6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  802fee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ff2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  802ff6:	eb 36                	jmp    80302e <memcmp+0x5c>
		if (*s1 != *s2)
  802ff8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ffc:	0f b6 10             	movzbl (%rax),%edx
  802fff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803003:	0f b6 00             	movzbl (%rax),%eax
  803006:	38 c2                	cmp    %al,%dl
  803008:	74 1a                	je     803024 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80300a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80300e:	0f b6 00             	movzbl (%rax),%eax
  803011:	0f b6 d0             	movzbl %al,%edx
  803014:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803018:	0f b6 00             	movzbl (%rax),%eax
  80301b:	0f b6 c0             	movzbl %al,%eax
  80301e:	29 c2                	sub    %eax,%edx
  803020:	89 d0                	mov    %edx,%eax
  803022:	eb 20                	jmp    803044 <memcmp+0x72>
		s1++, s2++;
  803024:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803029:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80302e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803032:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803036:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80303a:	48 85 c0             	test   %rax,%rax
  80303d:	75 b9                	jne    802ff8 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80303f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803044:	c9                   	leaveq 
  803045:	c3                   	retq   

0000000000803046 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  803046:	55                   	push   %rbp
  803047:	48 89 e5             	mov    %rsp,%rbp
  80304a:	48 83 ec 28          	sub    $0x28,%rsp
  80304e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803052:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  803055:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  803059:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80305d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803061:	48 01 d0             	add    %rdx,%rax
  803064:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  803068:	eb 15                	jmp    80307f <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80306a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80306e:	0f b6 10             	movzbl (%rax),%edx
  803071:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803074:	38 c2                	cmp    %al,%dl
  803076:	75 02                	jne    80307a <memfind+0x34>
			break;
  803078:	eb 0f                	jmp    803089 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80307a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80307f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803083:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803087:	72 e1                	jb     80306a <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  803089:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80308d:	c9                   	leaveq 
  80308e:	c3                   	retq   

000000000080308f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80308f:	55                   	push   %rbp
  803090:	48 89 e5             	mov    %rsp,%rbp
  803093:	48 83 ec 34          	sub    $0x34,%rsp
  803097:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80309b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80309f:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8030a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8030a9:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8030b0:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8030b1:	eb 05                	jmp    8030b8 <strtol+0x29>
		s++;
  8030b3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8030b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030bc:	0f b6 00             	movzbl (%rax),%eax
  8030bf:	3c 20                	cmp    $0x20,%al
  8030c1:	74 f0                	je     8030b3 <strtol+0x24>
  8030c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030c7:	0f b6 00             	movzbl (%rax),%eax
  8030ca:	3c 09                	cmp    $0x9,%al
  8030cc:	74 e5                	je     8030b3 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8030ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030d2:	0f b6 00             	movzbl (%rax),%eax
  8030d5:	3c 2b                	cmp    $0x2b,%al
  8030d7:	75 07                	jne    8030e0 <strtol+0x51>
		s++;
  8030d9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8030de:	eb 17                	jmp    8030f7 <strtol+0x68>
	else if (*s == '-')
  8030e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030e4:	0f b6 00             	movzbl (%rax),%eax
  8030e7:	3c 2d                	cmp    $0x2d,%al
  8030e9:	75 0c                	jne    8030f7 <strtol+0x68>
		s++, neg = 1;
  8030eb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8030f0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8030f7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8030fb:	74 06                	je     803103 <strtol+0x74>
  8030fd:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  803101:	75 28                	jne    80312b <strtol+0x9c>
  803103:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803107:	0f b6 00             	movzbl (%rax),%eax
  80310a:	3c 30                	cmp    $0x30,%al
  80310c:	75 1d                	jne    80312b <strtol+0x9c>
  80310e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803112:	48 83 c0 01          	add    $0x1,%rax
  803116:	0f b6 00             	movzbl (%rax),%eax
  803119:	3c 78                	cmp    $0x78,%al
  80311b:	75 0e                	jne    80312b <strtol+0x9c>
		s += 2, base = 16;
  80311d:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  803122:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  803129:	eb 2c                	jmp    803157 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80312b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80312f:	75 19                	jne    80314a <strtol+0xbb>
  803131:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803135:	0f b6 00             	movzbl (%rax),%eax
  803138:	3c 30                	cmp    $0x30,%al
  80313a:	75 0e                	jne    80314a <strtol+0xbb>
		s++, base = 8;
  80313c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803141:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803148:	eb 0d                	jmp    803157 <strtol+0xc8>
	else if (base == 0)
  80314a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80314e:	75 07                	jne    803157 <strtol+0xc8>
		base = 10;
  803150:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803157:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80315b:	0f b6 00             	movzbl (%rax),%eax
  80315e:	3c 2f                	cmp    $0x2f,%al
  803160:	7e 1d                	jle    80317f <strtol+0xf0>
  803162:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803166:	0f b6 00             	movzbl (%rax),%eax
  803169:	3c 39                	cmp    $0x39,%al
  80316b:	7f 12                	jg     80317f <strtol+0xf0>
			dig = *s - '0';
  80316d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803171:	0f b6 00             	movzbl (%rax),%eax
  803174:	0f be c0             	movsbl %al,%eax
  803177:	83 e8 30             	sub    $0x30,%eax
  80317a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80317d:	eb 4e                	jmp    8031cd <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80317f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803183:	0f b6 00             	movzbl (%rax),%eax
  803186:	3c 60                	cmp    $0x60,%al
  803188:	7e 1d                	jle    8031a7 <strtol+0x118>
  80318a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80318e:	0f b6 00             	movzbl (%rax),%eax
  803191:	3c 7a                	cmp    $0x7a,%al
  803193:	7f 12                	jg     8031a7 <strtol+0x118>
			dig = *s - 'a' + 10;
  803195:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803199:	0f b6 00             	movzbl (%rax),%eax
  80319c:	0f be c0             	movsbl %al,%eax
  80319f:	83 e8 57             	sub    $0x57,%eax
  8031a2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031a5:	eb 26                	jmp    8031cd <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8031a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031ab:	0f b6 00             	movzbl (%rax),%eax
  8031ae:	3c 40                	cmp    $0x40,%al
  8031b0:	7e 48                	jle    8031fa <strtol+0x16b>
  8031b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031b6:	0f b6 00             	movzbl (%rax),%eax
  8031b9:	3c 5a                	cmp    $0x5a,%al
  8031bb:	7f 3d                	jg     8031fa <strtol+0x16b>
			dig = *s - 'A' + 10;
  8031bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031c1:	0f b6 00             	movzbl (%rax),%eax
  8031c4:	0f be c0             	movsbl %al,%eax
  8031c7:	83 e8 37             	sub    $0x37,%eax
  8031ca:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8031cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031d0:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8031d3:	7c 02                	jl     8031d7 <strtol+0x148>
			break;
  8031d5:	eb 23                	jmp    8031fa <strtol+0x16b>
		s++, val = (val * base) + dig;
  8031d7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031dc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8031df:	48 98                	cltq   
  8031e1:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8031e6:	48 89 c2             	mov    %rax,%rdx
  8031e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031ec:	48 98                	cltq   
  8031ee:	48 01 d0             	add    %rdx,%rax
  8031f1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8031f5:	e9 5d ff ff ff       	jmpq   803157 <strtol+0xc8>

	if (endptr)
  8031fa:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8031ff:	74 0b                	je     80320c <strtol+0x17d>
		*endptr = (char *) s;
  803201:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803205:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803209:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80320c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803210:	74 09                	je     80321b <strtol+0x18c>
  803212:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803216:	48 f7 d8             	neg    %rax
  803219:	eb 04                	jmp    80321f <strtol+0x190>
  80321b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80321f:	c9                   	leaveq 
  803220:	c3                   	retq   

0000000000803221 <strstr>:

char * strstr(const char *in, const char *str)
{
  803221:	55                   	push   %rbp
  803222:	48 89 e5             	mov    %rsp,%rbp
  803225:	48 83 ec 30          	sub    $0x30,%rsp
  803229:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80322d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  803231:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803235:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803239:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80323d:	0f b6 00             	movzbl (%rax),%eax
  803240:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  803243:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803247:	75 06                	jne    80324f <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  803249:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80324d:	eb 6b                	jmp    8032ba <strstr+0x99>

    len = strlen(str);
  80324f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803253:	48 89 c7             	mov    %rax,%rdi
  803256:	48 b8 f7 2a 80 00 00 	movabs $0x802af7,%rax
  80325d:	00 00 00 
  803260:	ff d0                	callq  *%rax
  803262:	48 98                	cltq   
  803264:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  803268:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80326c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803270:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803274:	0f b6 00             	movzbl (%rax),%eax
  803277:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  80327a:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80327e:	75 07                	jne    803287 <strstr+0x66>
                return (char *) 0;
  803280:	b8 00 00 00 00       	mov    $0x0,%eax
  803285:	eb 33                	jmp    8032ba <strstr+0x99>
        } while (sc != c);
  803287:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80328b:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80328e:	75 d8                	jne    803268 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  803290:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803294:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803298:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80329c:	48 89 ce             	mov    %rcx,%rsi
  80329f:	48 89 c7             	mov    %rax,%rdi
  8032a2:	48 b8 18 2d 80 00 00 	movabs $0x802d18,%rax
  8032a9:	00 00 00 
  8032ac:	ff d0                	callq  *%rax
  8032ae:	85 c0                	test   %eax,%eax
  8032b0:	75 b6                	jne    803268 <strstr+0x47>

    return (char *) (in - 1);
  8032b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032b6:	48 83 e8 01          	sub    $0x1,%rax
}
  8032ba:	c9                   	leaveq 
  8032bb:	c3                   	retq   

00000000008032bc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8032bc:	55                   	push   %rbp
  8032bd:	48 89 e5             	mov    %rsp,%rbp
  8032c0:	48 83 ec 30          	sub    $0x30,%rsp
  8032c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8032d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8032d8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8032dd:	75 0e                	jne    8032ed <ipc_recv+0x31>
		page = (void *)KERNBASE;
  8032df:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8032e6:	00 00 00 
  8032e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  8032ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032f1:	48 89 c7             	mov    %rax,%rdi
  8032f4:	48 b8 42 05 80 00 00 	movabs $0x800542,%rax
  8032fb:	00 00 00 
  8032fe:	ff d0                	callq  *%rax
  803300:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803303:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803307:	79 27                	jns    803330 <ipc_recv+0x74>
		if (from_env_store != NULL)
  803309:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80330e:	74 0a                	je     80331a <ipc_recv+0x5e>
			*from_env_store = 0;
  803310:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803314:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  80331a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80331f:	74 0a                	je     80332b <ipc_recv+0x6f>
			*perm_store = 0;
  803321:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803325:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  80332b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80332e:	eb 53                	jmp    803383 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  803330:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803335:	74 19                	je     803350 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  803337:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80333e:	00 00 00 
  803341:	48 8b 00             	mov    (%rax),%rax
  803344:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80334a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80334e:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  803350:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803355:	74 19                	je     803370 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803357:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80335e:	00 00 00 
  803361:	48 8b 00             	mov    (%rax),%rax
  803364:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80336a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80336e:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  803370:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803377:	00 00 00 
  80337a:	48 8b 00             	mov    (%rax),%rax
  80337d:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803383:	c9                   	leaveq 
  803384:	c3                   	retq   

0000000000803385 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803385:	55                   	push   %rbp
  803386:	48 89 e5             	mov    %rsp,%rbp
  803389:	48 83 ec 30          	sub    $0x30,%rsp
  80338d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803390:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803393:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803397:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  80339a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80339e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8033a2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8033a7:	75 10                	jne    8033b9 <ipc_send+0x34>
		page = (void *)KERNBASE;
  8033a9:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8033b0:	00 00 00 
  8033b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  8033b7:	eb 0e                	jmp    8033c7 <ipc_send+0x42>
  8033b9:	eb 0c                	jmp    8033c7 <ipc_send+0x42>
		sys_yield();
  8033bb:	48 b8 db 02 80 00 00 	movabs $0x8002db,%rax
  8033c2:	00 00 00 
  8033c5:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  8033c7:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8033ca:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8033cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033d4:	89 c7                	mov    %eax,%edi
  8033d6:	48 b8 ed 04 80 00 00 	movabs $0x8004ed,%rax
  8033dd:	00 00 00 
  8033e0:	ff d0                	callq  *%rax
  8033e2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8033e5:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  8033e9:	74 d0                	je     8033bb <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  8033eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033ef:	74 2a                	je     80341b <ipc_send+0x96>
		panic("error on ipc send procedure");
  8033f1:	48 ba 00 3b 80 00 00 	movabs $0x803b00,%rdx
  8033f8:	00 00 00 
  8033fb:	be 49 00 00 00       	mov    $0x49,%esi
  803400:	48 bf 1c 3b 80 00 00 	movabs $0x803b1c,%rdi
  803407:	00 00 00 
  80340a:	b8 00 00 00 00       	mov    $0x0,%eax
  80340f:	48 b9 82 1b 80 00 00 	movabs $0x801b82,%rcx
  803416:	00 00 00 
  803419:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  80341b:	c9                   	leaveq 
  80341c:	c3                   	retq   

000000000080341d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80341d:	55                   	push   %rbp
  80341e:	48 89 e5             	mov    %rsp,%rbp
  803421:	48 83 ec 14          	sub    $0x14,%rsp
  803425:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803428:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80342f:	eb 5e                	jmp    80348f <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803431:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803438:	00 00 00 
  80343b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80343e:	48 63 d0             	movslq %eax,%rdx
  803441:	48 89 d0             	mov    %rdx,%rax
  803444:	48 c1 e0 03          	shl    $0x3,%rax
  803448:	48 01 d0             	add    %rdx,%rax
  80344b:	48 c1 e0 05          	shl    $0x5,%rax
  80344f:	48 01 c8             	add    %rcx,%rax
  803452:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803458:	8b 00                	mov    (%rax),%eax
  80345a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80345d:	75 2c                	jne    80348b <ipc_find_env+0x6e>
			return envs[i].env_id;
  80345f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803466:	00 00 00 
  803469:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80346c:	48 63 d0             	movslq %eax,%rdx
  80346f:	48 89 d0             	mov    %rdx,%rax
  803472:	48 c1 e0 03          	shl    $0x3,%rax
  803476:	48 01 d0             	add    %rdx,%rax
  803479:	48 c1 e0 05          	shl    $0x5,%rax
  80347d:	48 01 c8             	add    %rcx,%rax
  803480:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803486:	8b 40 08             	mov    0x8(%rax),%eax
  803489:	eb 12                	jmp    80349d <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80348b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80348f:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803496:	7e 99                	jle    803431 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803498:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80349d:	c9                   	leaveq 
  80349e:	c3                   	retq   

000000000080349f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80349f:	55                   	push   %rbp
  8034a0:	48 89 e5             	mov    %rsp,%rbp
  8034a3:	48 83 ec 18          	sub    $0x18,%rsp
  8034a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8034ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034af:	48 c1 e8 15          	shr    $0x15,%rax
  8034b3:	48 89 c2             	mov    %rax,%rdx
  8034b6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8034bd:	01 00 00 
  8034c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034c4:	83 e0 01             	and    $0x1,%eax
  8034c7:	48 85 c0             	test   %rax,%rax
  8034ca:	75 07                	jne    8034d3 <pageref+0x34>
		return 0;
  8034cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d1:	eb 53                	jmp    803526 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8034d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034d7:	48 c1 e8 0c          	shr    $0xc,%rax
  8034db:	48 89 c2             	mov    %rax,%rdx
  8034de:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8034e5:	01 00 00 
  8034e8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8034f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f4:	83 e0 01             	and    $0x1,%eax
  8034f7:	48 85 c0             	test   %rax,%rax
  8034fa:	75 07                	jne    803503 <pageref+0x64>
		return 0;
  8034fc:	b8 00 00 00 00       	mov    $0x0,%eax
  803501:	eb 23                	jmp    803526 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803503:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803507:	48 c1 e8 0c          	shr    $0xc,%rax
  80350b:	48 89 c2             	mov    %rax,%rdx
  80350e:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803515:	00 00 00 
  803518:	48 c1 e2 04          	shl    $0x4,%rdx
  80351c:	48 01 d0             	add    %rdx,%rax
  80351f:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803523:	0f b7 c0             	movzwl %ax,%eax
}
  803526:	c9                   	leaveq 
  803527:	c3                   	retq   
