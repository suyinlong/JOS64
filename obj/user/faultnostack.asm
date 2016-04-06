
obj/user/faultnostack.debug:     file format elf64-x86-64


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
  80003c:	e8 39 00 00 00       	callq  80007a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800052:	48 be 70 05 80 00 00 	movabs $0x800570,%rsi
  800059:	00 00 00 
  80005c:	bf 00 00 00 00       	mov    $0x0,%edi
  800061:	48 b8 8d 04 80 00 00 	movabs $0x80048d,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
	*(int*)0 = 0;
  80006d:	b8 00 00 00 00       	mov    $0x0,%eax
  800072:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  800078:	c9                   	leaveq 
  800079:	c3                   	retq   

000000000080007a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007a:	55                   	push   %rbp
  80007b:	48 89 e5             	mov    %rsp,%rbp
  80007e:	48 83 ec 10          	sub    $0x10,%rsp
  800082:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800085:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800089:	48 b8 87 02 80 00 00 	movabs $0x800287,%rax
  800090:	00 00 00 
  800093:	ff d0                	callq  *%rax
  800095:	48 98                	cltq   
  800097:	25 ff 03 00 00       	and    $0x3ff,%eax
  80009c:	48 89 c2             	mov    %rax,%rdx
  80009f:	48 89 d0             	mov    %rdx,%rax
  8000a2:	48 c1 e0 03          	shl    $0x3,%rax
  8000a6:	48 01 d0             	add    %rdx,%rax
  8000a9:	48 c1 e0 05          	shl    $0x5,%rax
  8000ad:	48 89 c2             	mov    %rax,%rdx
  8000b0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000b7:	00 00 00 
  8000ba:	48 01 c2             	add    %rax,%rdx
  8000bd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000c4:	00 00 00 
  8000c7:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000ce:	7e 14                	jle    8000e4 <libmain+0x6a>
		binaryname = argv[0];
  8000d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000d4:	48 8b 10             	mov    (%rax),%rdx
  8000d7:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000de:	00 00 00 
  8000e1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000eb:	48 89 d6             	mov    %rdx,%rsi
  8000ee:	89 c7                	mov    %eax,%edi
  8000f0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000f7:	00 00 00 
  8000fa:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000fc:	48 b8 0a 01 80 00 00 	movabs $0x80010a,%rax
  800103:	00 00 00 
  800106:	ff d0                	callq  *%rax
}
  800108:	c9                   	leaveq 
  800109:	c3                   	retq   

000000000080010a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010a:	55                   	push   %rbp
  80010b:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80010e:	48 b8 3b 09 80 00 00 	movabs $0x80093b,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80011a:	bf 00 00 00 00       	mov    $0x0,%edi
  80011f:	48 b8 43 02 80 00 00 	movabs $0x800243,%rax
  800126:	00 00 00 
  800129:	ff d0                	callq  *%rax
}
  80012b:	5d                   	pop    %rbp
  80012c:	c3                   	retq   

000000000080012d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80012d:	55                   	push   %rbp
  80012e:	48 89 e5             	mov    %rsp,%rbp
  800131:	53                   	push   %rbx
  800132:	48 83 ec 48          	sub    $0x48,%rsp
  800136:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800139:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80013c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800140:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800144:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800148:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80014c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80014f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800153:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800157:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80015b:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80015f:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800163:	4c 89 c3             	mov    %r8,%rbx
  800166:	cd 30                	int    $0x30
  800168:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  80016c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800170:	74 3e                	je     8001b0 <syscall+0x83>
  800172:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800177:	7e 37                	jle    8001b0 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800179:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80017d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800180:	49 89 d0             	mov    %rdx,%r8
  800183:	89 c1                	mov    %eax,%ecx
  800185:	48 ba 2a 36 80 00 00 	movabs $0x80362a,%rdx
  80018c:	00 00 00 
  80018f:	be 23 00 00 00       	mov    $0x23,%esi
  800194:	48 bf 47 36 80 00 00 	movabs $0x803647,%rdi
  80019b:	00 00 00 
  80019e:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a3:	49 b9 f6 1b 80 00 00 	movabs $0x801bf6,%r9
  8001aa:	00 00 00 
  8001ad:	41 ff d1             	callq  *%r9

	return ret;
  8001b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001b4:	48 83 c4 48          	add    $0x48,%rsp
  8001b8:	5b                   	pop    %rbx
  8001b9:	5d                   	pop    %rbp
  8001ba:	c3                   	retq   

00000000008001bb <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001bb:	55                   	push   %rbp
  8001bc:	48 89 e5             	mov    %rsp,%rbp
  8001bf:	48 83 ec 20          	sub    $0x20,%rsp
  8001c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001da:	00 
  8001db:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001e1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001e7:	48 89 d1             	mov    %rdx,%rcx
  8001ea:	48 89 c2             	mov    %rax,%rdx
  8001ed:	be 00 00 00 00       	mov    $0x0,%esi
  8001f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f7:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  8001fe:	00 00 00 
  800201:	ff d0                	callq  *%rax
}
  800203:	c9                   	leaveq 
  800204:	c3                   	retq   

0000000000800205 <sys_cgetc>:

int
sys_cgetc(void)
{
  800205:	55                   	push   %rbp
  800206:	48 89 e5             	mov    %rsp,%rbp
  800209:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80020d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800214:	00 
  800215:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80021b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800221:	b9 00 00 00 00       	mov    $0x0,%ecx
  800226:	ba 00 00 00 00       	mov    $0x0,%edx
  80022b:	be 00 00 00 00       	mov    $0x0,%esi
  800230:	bf 01 00 00 00       	mov    $0x1,%edi
  800235:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	callq  *%rax
}
  800241:	c9                   	leaveq 
  800242:	c3                   	retq   

0000000000800243 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800243:	55                   	push   %rbp
  800244:	48 89 e5             	mov    %rsp,%rbp
  800247:	48 83 ec 10          	sub    $0x10,%rsp
  80024b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80024e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800251:	48 98                	cltq   
  800253:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80025a:	00 
  80025b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800261:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800267:	b9 00 00 00 00       	mov    $0x0,%ecx
  80026c:	48 89 c2             	mov    %rax,%rdx
  80026f:	be 01 00 00 00       	mov    $0x1,%esi
  800274:	bf 03 00 00 00       	mov    $0x3,%edi
  800279:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  800280:	00 00 00 
  800283:	ff d0                	callq  *%rax
}
  800285:	c9                   	leaveq 
  800286:	c3                   	retq   

0000000000800287 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800287:	55                   	push   %rbp
  800288:	48 89 e5             	mov    %rsp,%rbp
  80028b:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80028f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800296:	00 
  800297:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80029d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ad:	be 00 00 00 00       	mov    $0x0,%esi
  8002b2:	bf 02 00 00 00       	mov    $0x2,%edi
  8002b7:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  8002be:	00 00 00 
  8002c1:	ff d0                	callq  *%rax
}
  8002c3:	c9                   	leaveq 
  8002c4:	c3                   	retq   

00000000008002c5 <sys_yield>:

void
sys_yield(void)
{
  8002c5:	55                   	push   %rbp
  8002c6:	48 89 e5             	mov    %rsp,%rbp
  8002c9:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002cd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002d4:	00 
  8002d5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002db:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8002eb:	be 00 00 00 00       	mov    $0x0,%esi
  8002f0:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002f5:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  8002fc:	00 00 00 
  8002ff:	ff d0                	callq  *%rax
}
  800301:	c9                   	leaveq 
  800302:	c3                   	retq   

0000000000800303 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800303:	55                   	push   %rbp
  800304:	48 89 e5             	mov    %rsp,%rbp
  800307:	48 83 ec 20          	sub    $0x20,%rsp
  80030b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80030e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800312:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800315:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800318:	48 63 c8             	movslq %eax,%rcx
  80031b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80031f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800322:	48 98                	cltq   
  800324:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80032b:	00 
  80032c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800332:	49 89 c8             	mov    %rcx,%r8
  800335:	48 89 d1             	mov    %rdx,%rcx
  800338:	48 89 c2             	mov    %rax,%rdx
  80033b:	be 01 00 00 00       	mov    $0x1,%esi
  800340:	bf 04 00 00 00       	mov    $0x4,%edi
  800345:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  80034c:	00 00 00 
  80034f:	ff d0                	callq  *%rax
}
  800351:	c9                   	leaveq 
  800352:	c3                   	retq   

0000000000800353 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800353:	55                   	push   %rbp
  800354:	48 89 e5             	mov    %rsp,%rbp
  800357:	48 83 ec 30          	sub    $0x30,%rsp
  80035b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80035e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800362:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800365:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800369:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80036d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800370:	48 63 c8             	movslq %eax,%rcx
  800373:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800377:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80037a:	48 63 f0             	movslq %eax,%rsi
  80037d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800381:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800384:	48 98                	cltq   
  800386:	48 89 0c 24          	mov    %rcx,(%rsp)
  80038a:	49 89 f9             	mov    %rdi,%r9
  80038d:	49 89 f0             	mov    %rsi,%r8
  800390:	48 89 d1             	mov    %rdx,%rcx
  800393:	48 89 c2             	mov    %rax,%rdx
  800396:	be 01 00 00 00       	mov    $0x1,%esi
  80039b:	bf 05 00 00 00       	mov    $0x5,%edi
  8003a0:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  8003a7:	00 00 00 
  8003aa:	ff d0                	callq  *%rax
}
  8003ac:	c9                   	leaveq 
  8003ad:	c3                   	retq   

00000000008003ae <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003ae:	55                   	push   %rbp
  8003af:	48 89 e5             	mov    %rsp,%rbp
  8003b2:	48 83 ec 20          	sub    $0x20,%rsp
  8003b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c4:	48 98                	cltq   
  8003c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003cd:	00 
  8003ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003da:	48 89 d1             	mov    %rdx,%rcx
  8003dd:	48 89 c2             	mov    %rax,%rdx
  8003e0:	be 01 00 00 00       	mov    $0x1,%esi
  8003e5:	bf 06 00 00 00       	mov    $0x6,%edi
  8003ea:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  8003f1:	00 00 00 
  8003f4:	ff d0                	callq  *%rax
}
  8003f6:	c9                   	leaveq 
  8003f7:	c3                   	retq   

00000000008003f8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003f8:	55                   	push   %rbp
  8003f9:	48 89 e5             	mov    %rsp,%rbp
  8003fc:	48 83 ec 10          	sub    $0x10,%rsp
  800400:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800403:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800406:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800409:	48 63 d0             	movslq %eax,%rdx
  80040c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80040f:	48 98                	cltq   
  800411:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800418:	00 
  800419:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80041f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800425:	48 89 d1             	mov    %rdx,%rcx
  800428:	48 89 c2             	mov    %rax,%rdx
  80042b:	be 01 00 00 00       	mov    $0x1,%esi
  800430:	bf 08 00 00 00       	mov    $0x8,%edi
  800435:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  80043c:	00 00 00 
  80043f:	ff d0                	callq  *%rax
}
  800441:	c9                   	leaveq 
  800442:	c3                   	retq   

0000000000800443 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800443:	55                   	push   %rbp
  800444:	48 89 e5             	mov    %rsp,%rbp
  800447:	48 83 ec 20          	sub    $0x20,%rsp
  80044b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80044e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800452:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800456:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800459:	48 98                	cltq   
  80045b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800462:	00 
  800463:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800469:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80046f:	48 89 d1             	mov    %rdx,%rcx
  800472:	48 89 c2             	mov    %rax,%rdx
  800475:	be 01 00 00 00       	mov    $0x1,%esi
  80047a:	bf 09 00 00 00       	mov    $0x9,%edi
  80047f:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  800486:	00 00 00 
  800489:	ff d0                	callq  *%rax
}
  80048b:	c9                   	leaveq 
  80048c:	c3                   	retq   

000000000080048d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80048d:	55                   	push   %rbp
  80048e:	48 89 e5             	mov    %rsp,%rbp
  800491:	48 83 ec 20          	sub    $0x20,%rsp
  800495:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800498:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80049c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004a3:	48 98                	cltq   
  8004a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004ac:	00 
  8004ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004b9:	48 89 d1             	mov    %rdx,%rcx
  8004bc:	48 89 c2             	mov    %rax,%rdx
  8004bf:	be 01 00 00 00       	mov    $0x1,%esi
  8004c4:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004c9:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
}
  8004d5:	c9                   	leaveq 
  8004d6:	c3                   	retq   

00000000008004d7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004d7:	55                   	push   %rbp
  8004d8:	48 89 e5             	mov    %rsp,%rbp
  8004db:	48 83 ec 20          	sub    $0x20,%rsp
  8004df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004ea:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004f0:	48 63 f0             	movslq %eax,%rsi
  8004f3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004fa:	48 98                	cltq   
  8004fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800500:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800507:	00 
  800508:	49 89 f1             	mov    %rsi,%r9
  80050b:	49 89 c8             	mov    %rcx,%r8
  80050e:	48 89 d1             	mov    %rdx,%rcx
  800511:	48 89 c2             	mov    %rax,%rdx
  800514:	be 00 00 00 00       	mov    $0x0,%esi
  800519:	bf 0c 00 00 00       	mov    $0xc,%edi
  80051e:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  800525:	00 00 00 
  800528:	ff d0                	callq  *%rax
}
  80052a:	c9                   	leaveq 
  80052b:	c3                   	retq   

000000000080052c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80052c:	55                   	push   %rbp
  80052d:	48 89 e5             	mov    %rsp,%rbp
  800530:	48 83 ec 10          	sub    $0x10,%rsp
  800534:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800538:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80053c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800543:	00 
  800544:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80054a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800550:	b9 00 00 00 00       	mov    $0x0,%ecx
  800555:	48 89 c2             	mov    %rax,%rdx
  800558:	be 01 00 00 00       	mov    $0x1,%esi
  80055d:	bf 0d 00 00 00       	mov    $0xd,%edi
  800562:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  800569:	00 00 00 
  80056c:	ff d0                	callq  *%rax
}
  80056e:	c9                   	leaveq 
  80056f:	c3                   	retq   

0000000000800570 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  800570:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  800573:	48 a1 08 80 80 00 00 	movabs 0x808008,%rax
  80057a:	00 00 00 
	call *%rax
  80057d:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  80057f:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  800582:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  800589:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  80058a:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  800591:	00 
	pushq %rbx		// push utf_rip into new stack
  800592:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  800593:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  80059a:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  80059d:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  8005a1:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  8005a5:	4c 8b 3c 24          	mov    (%rsp),%r15
  8005a9:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8005ae:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8005b3:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8005b8:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8005bd:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8005c2:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8005c7:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8005cc:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8005d1:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8005d6:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8005db:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8005e0:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8005e5:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8005ea:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8005ef:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  8005f3:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  8005f7:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  8005f8:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8005f9:	c3                   	retq   

00000000008005fa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8005fa:	55                   	push   %rbp
  8005fb:	48 89 e5             	mov    %rsp,%rbp
  8005fe:	48 83 ec 08          	sub    $0x8,%rsp
  800602:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800606:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80060a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800611:	ff ff ff 
  800614:	48 01 d0             	add    %rdx,%rax
  800617:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80061b:	c9                   	leaveq 
  80061c:	c3                   	retq   

000000000080061d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80061d:	55                   	push   %rbp
  80061e:	48 89 e5             	mov    %rsp,%rbp
  800621:	48 83 ec 08          	sub    $0x8,%rsp
  800625:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800629:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80062d:	48 89 c7             	mov    %rax,%rdi
  800630:	48 b8 fa 05 80 00 00 	movabs $0x8005fa,%rax
  800637:	00 00 00 
  80063a:	ff d0                	callq  *%rax
  80063c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800642:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800646:	c9                   	leaveq 
  800647:	c3                   	retq   

0000000000800648 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800648:	55                   	push   %rbp
  800649:	48 89 e5             	mov    %rsp,%rbp
  80064c:	48 83 ec 18          	sub    $0x18,%rsp
  800650:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800654:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80065b:	eb 6b                	jmp    8006c8 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80065d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800660:	48 98                	cltq   
  800662:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800668:	48 c1 e0 0c          	shl    $0xc,%rax
  80066c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800670:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800674:	48 c1 e8 15          	shr    $0x15,%rax
  800678:	48 89 c2             	mov    %rax,%rdx
  80067b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800682:	01 00 00 
  800685:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800689:	83 e0 01             	and    $0x1,%eax
  80068c:	48 85 c0             	test   %rax,%rax
  80068f:	74 21                	je     8006b2 <fd_alloc+0x6a>
  800691:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800695:	48 c1 e8 0c          	shr    $0xc,%rax
  800699:	48 89 c2             	mov    %rax,%rdx
  80069c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006a3:	01 00 00 
  8006a6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006aa:	83 e0 01             	and    $0x1,%eax
  8006ad:	48 85 c0             	test   %rax,%rax
  8006b0:	75 12                	jne    8006c4 <fd_alloc+0x7c>
			*fd_store = fd;
  8006b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006ba:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8006bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c2:	eb 1a                	jmp    8006de <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8006c4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8006c8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8006cc:	7e 8f                	jle    80065d <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8006ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8006d9:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8006de:	c9                   	leaveq 
  8006df:	c3                   	retq   

00000000008006e0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8006e0:	55                   	push   %rbp
  8006e1:	48 89 e5             	mov    %rsp,%rbp
  8006e4:	48 83 ec 20          	sub    $0x20,%rsp
  8006e8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8006eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8006ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8006f3:	78 06                	js     8006fb <fd_lookup+0x1b>
  8006f5:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8006f9:	7e 07                	jle    800702 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800700:	eb 6c                	jmp    80076e <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800702:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800705:	48 98                	cltq   
  800707:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80070d:	48 c1 e0 0c          	shl    $0xc,%rax
  800711:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800715:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800719:	48 c1 e8 15          	shr    $0x15,%rax
  80071d:	48 89 c2             	mov    %rax,%rdx
  800720:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800727:	01 00 00 
  80072a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80072e:	83 e0 01             	and    $0x1,%eax
  800731:	48 85 c0             	test   %rax,%rax
  800734:	74 21                	je     800757 <fd_lookup+0x77>
  800736:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80073a:	48 c1 e8 0c          	shr    $0xc,%rax
  80073e:	48 89 c2             	mov    %rax,%rdx
  800741:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800748:	01 00 00 
  80074b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80074f:	83 e0 01             	and    $0x1,%eax
  800752:	48 85 c0             	test   %rax,%rax
  800755:	75 07                	jne    80075e <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800757:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80075c:	eb 10                	jmp    80076e <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80075e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800762:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800766:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  800769:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80076e:	c9                   	leaveq 
  80076f:	c3                   	retq   

0000000000800770 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800770:	55                   	push   %rbp
  800771:	48 89 e5             	mov    %rsp,%rbp
  800774:	48 83 ec 30          	sub    $0x30,%rsp
  800778:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80077c:	89 f0                	mov    %esi,%eax
  80077e:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800781:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800785:	48 89 c7             	mov    %rax,%rdi
  800788:	48 b8 fa 05 80 00 00 	movabs $0x8005fa,%rax
  80078f:	00 00 00 
  800792:	ff d0                	callq  *%rax
  800794:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800798:	48 89 d6             	mov    %rdx,%rsi
  80079b:	89 c7                	mov    %eax,%edi
  80079d:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  8007a4:	00 00 00 
  8007a7:	ff d0                	callq  *%rax
  8007a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007b0:	78 0a                	js     8007bc <fd_close+0x4c>
	    || fd != fd2)
  8007b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007b6:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8007ba:	74 12                	je     8007ce <fd_close+0x5e>
		return (must_exist ? r : 0);
  8007bc:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8007c0:	74 05                	je     8007c7 <fd_close+0x57>
  8007c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007c5:	eb 05                	jmp    8007cc <fd_close+0x5c>
  8007c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8007cc:	eb 69                	jmp    800837 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8007ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d2:	8b 00                	mov    (%rax),%eax
  8007d4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8007d8:	48 89 d6             	mov    %rdx,%rsi
  8007db:	89 c7                	mov    %eax,%edi
  8007dd:	48 b8 39 08 80 00 00 	movabs $0x800839,%rax
  8007e4:	00 00 00 
  8007e7:	ff d0                	callq  *%rax
  8007e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007f0:	78 2a                	js     80081c <fd_close+0xac>
		if (dev->dev_close)
  8007f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8007fa:	48 85 c0             	test   %rax,%rax
  8007fd:	74 16                	je     800815 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8007ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800803:	48 8b 40 20          	mov    0x20(%rax),%rax
  800807:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80080b:	48 89 d7             	mov    %rdx,%rdi
  80080e:	ff d0                	callq  *%rax
  800810:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800813:	eb 07                	jmp    80081c <fd_close+0xac>
		else
			r = 0;
  800815:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80081c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800820:	48 89 c6             	mov    %rax,%rsi
  800823:	bf 00 00 00 00       	mov    $0x0,%edi
  800828:	48 b8 ae 03 80 00 00 	movabs $0x8003ae,%rax
  80082f:	00 00 00 
  800832:	ff d0                	callq  *%rax
	return r;
  800834:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800837:	c9                   	leaveq 
  800838:	c3                   	retq   

0000000000800839 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800839:	55                   	push   %rbp
  80083a:	48 89 e5             	mov    %rsp,%rbp
  80083d:	48 83 ec 20          	sub    $0x20,%rsp
  800841:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800844:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  800848:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80084f:	eb 41                	jmp    800892 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  800851:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800858:	00 00 00 
  80085b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80085e:	48 63 d2             	movslq %edx,%rdx
  800861:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800865:	8b 00                	mov    (%rax),%eax
  800867:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80086a:	75 22                	jne    80088e <dev_lookup+0x55>
			*dev = devtab[i];
  80086c:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800873:	00 00 00 
  800876:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800879:	48 63 d2             	movslq %edx,%rdx
  80087c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  800880:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800884:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800887:	b8 00 00 00 00       	mov    $0x0,%eax
  80088c:	eb 60                	jmp    8008ee <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80088e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800892:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800899:	00 00 00 
  80089c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80089f:	48 63 d2             	movslq %edx,%rdx
  8008a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8008a6:	48 85 c0             	test   %rax,%rax
  8008a9:	75 a6                	jne    800851 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8008ab:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8008b2:	00 00 00 
  8008b5:	48 8b 00             	mov    (%rax),%rax
  8008b8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8008be:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8008c1:	89 c6                	mov    %eax,%esi
  8008c3:	48 bf 58 36 80 00 00 	movabs $0x803658,%rdi
  8008ca:	00 00 00 
  8008cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d2:	48 b9 2f 1e 80 00 00 	movabs $0x801e2f,%rcx
  8008d9:	00 00 00 
  8008dc:	ff d1                	callq  *%rcx
	*dev = 0;
  8008de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008e2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8008e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8008ee:	c9                   	leaveq 
  8008ef:	c3                   	retq   

00000000008008f0 <close>:

int
close(int fdnum)
{
  8008f0:	55                   	push   %rbp
  8008f1:	48 89 e5             	mov    %rsp,%rbp
  8008f4:	48 83 ec 20          	sub    $0x20,%rsp
  8008f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8008fb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8008ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800902:	48 89 d6             	mov    %rdx,%rsi
  800905:	89 c7                	mov    %eax,%edi
  800907:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  80090e:	00 00 00 
  800911:	ff d0                	callq  *%rax
  800913:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800916:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80091a:	79 05                	jns    800921 <close+0x31>
		return r;
  80091c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80091f:	eb 18                	jmp    800939 <close+0x49>
	else
		return fd_close(fd, 1);
  800921:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800925:	be 01 00 00 00       	mov    $0x1,%esi
  80092a:	48 89 c7             	mov    %rax,%rdi
  80092d:	48 b8 70 07 80 00 00 	movabs $0x800770,%rax
  800934:	00 00 00 
  800937:	ff d0                	callq  *%rax
}
  800939:	c9                   	leaveq 
  80093a:	c3                   	retq   

000000000080093b <close_all>:

void
close_all(void)
{
  80093b:	55                   	push   %rbp
  80093c:	48 89 e5             	mov    %rsp,%rbp
  80093f:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  800943:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80094a:	eb 15                	jmp    800961 <close_all+0x26>
		close(i);
  80094c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80094f:	89 c7                	mov    %eax,%edi
  800951:	48 b8 f0 08 80 00 00 	movabs $0x8008f0,%rax
  800958:	00 00 00 
  80095b:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80095d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800961:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800965:	7e e5                	jle    80094c <close_all+0x11>
		close(i);
}
  800967:	c9                   	leaveq 
  800968:	c3                   	retq   

0000000000800969 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800969:	55                   	push   %rbp
  80096a:	48 89 e5             	mov    %rsp,%rbp
  80096d:	48 83 ec 40          	sub    $0x40,%rsp
  800971:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800974:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800977:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80097b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80097e:	48 89 d6             	mov    %rdx,%rsi
  800981:	89 c7                	mov    %eax,%edi
  800983:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  80098a:	00 00 00 
  80098d:	ff d0                	callq  *%rax
  80098f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800992:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800996:	79 08                	jns    8009a0 <dup+0x37>
		return r;
  800998:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80099b:	e9 70 01 00 00       	jmpq   800b10 <dup+0x1a7>
	close(newfdnum);
  8009a0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8009a3:	89 c7                	mov    %eax,%edi
  8009a5:	48 b8 f0 08 80 00 00 	movabs $0x8008f0,%rax
  8009ac:	00 00 00 
  8009af:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8009b1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8009b4:	48 98                	cltq   
  8009b6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8009bc:	48 c1 e0 0c          	shl    $0xc,%rax
  8009c0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8009c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009c8:	48 89 c7             	mov    %rax,%rdi
  8009cb:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  8009d2:	00 00 00 
  8009d5:	ff d0                	callq  *%rax
  8009d7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8009db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8009df:	48 89 c7             	mov    %rax,%rdi
  8009e2:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  8009e9:	00 00 00 
  8009ec:	ff d0                	callq  *%rax
  8009ee:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8009f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f6:	48 c1 e8 15          	shr    $0x15,%rax
  8009fa:	48 89 c2             	mov    %rax,%rdx
  8009fd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800a04:	01 00 00 
  800a07:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a0b:	83 e0 01             	and    $0x1,%eax
  800a0e:	48 85 c0             	test   %rax,%rax
  800a11:	74 73                	je     800a86 <dup+0x11d>
  800a13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a17:	48 c1 e8 0c          	shr    $0xc,%rax
  800a1b:	48 89 c2             	mov    %rax,%rdx
  800a1e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a25:	01 00 00 
  800a28:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a2c:	83 e0 01             	and    $0x1,%eax
  800a2f:	48 85 c0             	test   %rax,%rax
  800a32:	74 52                	je     800a86 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a38:	48 c1 e8 0c          	shr    $0xc,%rax
  800a3c:	48 89 c2             	mov    %rax,%rdx
  800a3f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a46:	01 00 00 
  800a49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a4d:	25 07 0e 00 00       	and    $0xe07,%eax
  800a52:	89 c1                	mov    %eax,%ecx
  800a54:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800a58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5c:	41 89 c8             	mov    %ecx,%r8d
  800a5f:	48 89 d1             	mov    %rdx,%rcx
  800a62:	ba 00 00 00 00       	mov    $0x0,%edx
  800a67:	48 89 c6             	mov    %rax,%rsi
  800a6a:	bf 00 00 00 00       	mov    $0x0,%edi
  800a6f:	48 b8 53 03 80 00 00 	movabs $0x800353,%rax
  800a76:	00 00 00 
  800a79:	ff d0                	callq  *%rax
  800a7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a82:	79 02                	jns    800a86 <dup+0x11d>
			goto err;
  800a84:	eb 57                	jmp    800add <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800a86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a8a:	48 c1 e8 0c          	shr    $0xc,%rax
  800a8e:	48 89 c2             	mov    %rax,%rdx
  800a91:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a98:	01 00 00 
  800a9b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a9f:	25 07 0e 00 00       	and    $0xe07,%eax
  800aa4:	89 c1                	mov    %eax,%ecx
  800aa6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800aaa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800aae:	41 89 c8             	mov    %ecx,%r8d
  800ab1:	48 89 d1             	mov    %rdx,%rcx
  800ab4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab9:	48 89 c6             	mov    %rax,%rsi
  800abc:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac1:	48 b8 53 03 80 00 00 	movabs $0x800353,%rax
  800ac8:	00 00 00 
  800acb:	ff d0                	callq  *%rax
  800acd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ad0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ad4:	79 02                	jns    800ad8 <dup+0x16f>
		goto err;
  800ad6:	eb 05                	jmp    800add <dup+0x174>

	return newfdnum;
  800ad8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800adb:	eb 33                	jmp    800b10 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800add:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ae1:	48 89 c6             	mov    %rax,%rsi
  800ae4:	bf 00 00 00 00       	mov    $0x0,%edi
  800ae9:	48 b8 ae 03 80 00 00 	movabs $0x8003ae,%rax
  800af0:	00 00 00 
  800af3:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800af5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800af9:	48 89 c6             	mov    %rax,%rsi
  800afc:	bf 00 00 00 00       	mov    $0x0,%edi
  800b01:	48 b8 ae 03 80 00 00 	movabs $0x8003ae,%rax
  800b08:	00 00 00 
  800b0b:	ff d0                	callq  *%rax
	return r;
  800b0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800b10:	c9                   	leaveq 
  800b11:	c3                   	retq   

0000000000800b12 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800b12:	55                   	push   %rbp
  800b13:	48 89 e5             	mov    %rsp,%rbp
  800b16:	48 83 ec 40          	sub    $0x40,%rsp
  800b1a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800b1d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800b21:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b25:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800b29:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800b2c:	48 89 d6             	mov    %rdx,%rsi
  800b2f:	89 c7                	mov    %eax,%edi
  800b31:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  800b38:	00 00 00 
  800b3b:	ff d0                	callq  *%rax
  800b3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b44:	78 24                	js     800b6a <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b4a:	8b 00                	mov    (%rax),%eax
  800b4c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800b50:	48 89 d6             	mov    %rdx,%rsi
  800b53:	89 c7                	mov    %eax,%edi
  800b55:	48 b8 39 08 80 00 00 	movabs $0x800839,%rax
  800b5c:	00 00 00 
  800b5f:	ff d0                	callq  *%rax
  800b61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b68:	79 05                	jns    800b6f <read+0x5d>
		return r;
  800b6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b6d:	eb 76                	jmp    800be5 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800b6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b73:	8b 40 08             	mov    0x8(%rax),%eax
  800b76:	83 e0 03             	and    $0x3,%eax
  800b79:	83 f8 01             	cmp    $0x1,%eax
  800b7c:	75 3a                	jne    800bb8 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800b7e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b85:	00 00 00 
  800b88:	48 8b 00             	mov    (%rax),%rax
  800b8b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800b91:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800b94:	89 c6                	mov    %eax,%esi
  800b96:	48 bf 77 36 80 00 00 	movabs $0x803677,%rdi
  800b9d:	00 00 00 
  800ba0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba5:	48 b9 2f 1e 80 00 00 	movabs $0x801e2f,%rcx
  800bac:	00 00 00 
  800baf:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800bb1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bb6:	eb 2d                	jmp    800be5 <read+0xd3>
	}
	if (!dev->dev_read)
  800bb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bbc:	48 8b 40 10          	mov    0x10(%rax),%rax
  800bc0:	48 85 c0             	test   %rax,%rax
  800bc3:	75 07                	jne    800bcc <read+0xba>
		return -E_NOT_SUPP;
  800bc5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800bca:	eb 19                	jmp    800be5 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800bcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bd0:	48 8b 40 10          	mov    0x10(%rax),%rax
  800bd4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800bd8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bdc:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800be0:	48 89 cf             	mov    %rcx,%rdi
  800be3:	ff d0                	callq  *%rax
}
  800be5:	c9                   	leaveq 
  800be6:	c3                   	retq   

0000000000800be7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800be7:	55                   	push   %rbp
  800be8:	48 89 e5             	mov    %rsp,%rbp
  800beb:	48 83 ec 30          	sub    $0x30,%rsp
  800bef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800bf2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800bf6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800bfa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800c01:	eb 49                	jmp    800c4c <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800c03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c06:	48 98                	cltq   
  800c08:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800c0c:	48 29 c2             	sub    %rax,%rdx
  800c0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c12:	48 63 c8             	movslq %eax,%rcx
  800c15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c19:	48 01 c1             	add    %rax,%rcx
  800c1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800c1f:	48 89 ce             	mov    %rcx,%rsi
  800c22:	89 c7                	mov    %eax,%edi
  800c24:	48 b8 12 0b 80 00 00 	movabs $0x800b12,%rax
  800c2b:	00 00 00 
  800c2e:	ff d0                	callq  *%rax
  800c30:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800c33:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c37:	79 05                	jns    800c3e <readn+0x57>
			return m;
  800c39:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c3c:	eb 1c                	jmp    800c5a <readn+0x73>
		if (m == 0)
  800c3e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c42:	75 02                	jne    800c46 <readn+0x5f>
			break;
  800c44:	eb 11                	jmp    800c57 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c49:	01 45 fc             	add    %eax,-0x4(%rbp)
  800c4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c4f:	48 98                	cltq   
  800c51:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800c55:	72 ac                	jb     800c03 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800c57:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800c5a:	c9                   	leaveq 
  800c5b:	c3                   	retq   

0000000000800c5c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800c5c:	55                   	push   %rbp
  800c5d:	48 89 e5             	mov    %rsp,%rbp
  800c60:	48 83 ec 40          	sub    $0x40,%rsp
  800c64:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800c67:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800c6b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c6f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800c73:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800c76:	48 89 d6             	mov    %rdx,%rsi
  800c79:	89 c7                	mov    %eax,%edi
  800c7b:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  800c82:	00 00 00 
  800c85:	ff d0                	callq  *%rax
  800c87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c8e:	78 24                	js     800cb4 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c94:	8b 00                	mov    (%rax),%eax
  800c96:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c9a:	48 89 d6             	mov    %rdx,%rsi
  800c9d:	89 c7                	mov    %eax,%edi
  800c9f:	48 b8 39 08 80 00 00 	movabs $0x800839,%rax
  800ca6:	00 00 00 
  800ca9:	ff d0                	callq  *%rax
  800cab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cb2:	79 05                	jns    800cb9 <write+0x5d>
		return r;
  800cb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cb7:	eb 75                	jmp    800d2e <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800cb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cbd:	8b 40 08             	mov    0x8(%rax),%eax
  800cc0:	83 e0 03             	and    $0x3,%eax
  800cc3:	85 c0                	test   %eax,%eax
  800cc5:	75 3a                	jne    800d01 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800cc7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800cce:	00 00 00 
  800cd1:	48 8b 00             	mov    (%rax),%rax
  800cd4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800cda:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800cdd:	89 c6                	mov    %eax,%esi
  800cdf:	48 bf 93 36 80 00 00 	movabs $0x803693,%rdi
  800ce6:	00 00 00 
  800ce9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cee:	48 b9 2f 1e 80 00 00 	movabs $0x801e2f,%rcx
  800cf5:	00 00 00 
  800cf8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800cfa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cff:	eb 2d                	jmp    800d2e <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800d01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d05:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d09:	48 85 c0             	test   %rax,%rax
  800d0c:	75 07                	jne    800d15 <write+0xb9>
		return -E_NOT_SUPP;
  800d0e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d13:	eb 19                	jmp    800d2e <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800d15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d19:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d1d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d21:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d25:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800d29:	48 89 cf             	mov    %rcx,%rdi
  800d2c:	ff d0                	callq  *%rax
}
  800d2e:	c9                   	leaveq 
  800d2f:	c3                   	retq   

0000000000800d30 <seek>:

int
seek(int fdnum, off_t offset)
{
  800d30:	55                   	push   %rbp
  800d31:	48 89 e5             	mov    %rsp,%rbp
  800d34:	48 83 ec 18          	sub    $0x18,%rsp
  800d38:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800d3b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800d3e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d42:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800d45:	48 89 d6             	mov    %rdx,%rsi
  800d48:	89 c7                	mov    %eax,%edi
  800d4a:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  800d51:	00 00 00 
  800d54:	ff d0                	callq  *%rax
  800d56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d5d:	79 05                	jns    800d64 <seek+0x34>
		return r;
  800d5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d62:	eb 0f                	jmp    800d73 <seek+0x43>
	fd->fd_offset = offset;
  800d64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d68:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800d6b:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800d6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d73:	c9                   	leaveq 
  800d74:	c3                   	retq   

0000000000800d75 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800d75:	55                   	push   %rbp
  800d76:	48 89 e5             	mov    %rsp,%rbp
  800d79:	48 83 ec 30          	sub    $0x30,%rsp
  800d7d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800d80:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d83:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d87:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800d8a:	48 89 d6             	mov    %rdx,%rsi
  800d8d:	89 c7                	mov    %eax,%edi
  800d8f:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  800d96:	00 00 00 
  800d99:	ff d0                	callq  *%rax
  800d9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800da2:	78 24                	js     800dc8 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800da4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da8:	8b 00                	mov    (%rax),%eax
  800daa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800dae:	48 89 d6             	mov    %rdx,%rsi
  800db1:	89 c7                	mov    %eax,%edi
  800db3:	48 b8 39 08 80 00 00 	movabs $0x800839,%rax
  800dba:	00 00 00 
  800dbd:	ff d0                	callq  *%rax
  800dbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dc6:	79 05                	jns    800dcd <ftruncate+0x58>
		return r;
  800dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800dcb:	eb 72                	jmp    800e3f <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800dcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd1:	8b 40 08             	mov    0x8(%rax),%eax
  800dd4:	83 e0 03             	and    $0x3,%eax
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	75 3a                	jne    800e15 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800ddb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800de2:	00 00 00 
  800de5:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800de8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800dee:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800df1:	89 c6                	mov    %eax,%esi
  800df3:	48 bf b0 36 80 00 00 	movabs $0x8036b0,%rdi
  800dfa:	00 00 00 
  800dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  800e02:	48 b9 2f 1e 80 00 00 	movabs $0x801e2f,%rcx
  800e09:	00 00 00 
  800e0c:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800e0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e13:	eb 2a                	jmp    800e3f <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800e15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e19:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e1d:	48 85 c0             	test   %rax,%rax
  800e20:	75 07                	jne    800e29 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800e22:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e27:	eb 16                	jmp    800e3f <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2d:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e35:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800e38:	89 ce                	mov    %ecx,%esi
  800e3a:	48 89 d7             	mov    %rdx,%rdi
  800e3d:	ff d0                	callq  *%rax
}
  800e3f:	c9                   	leaveq 
  800e40:	c3                   	retq   

0000000000800e41 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800e41:	55                   	push   %rbp
  800e42:	48 89 e5             	mov    %rsp,%rbp
  800e45:	48 83 ec 30          	sub    $0x30,%rsp
  800e49:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e4c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e50:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e54:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e57:	48 89 d6             	mov    %rdx,%rsi
  800e5a:	89 c7                	mov    %eax,%edi
  800e5c:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  800e63:	00 00 00 
  800e66:	ff d0                	callq  *%rax
  800e68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e6f:	78 24                	js     800e95 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e75:	8b 00                	mov    (%rax),%eax
  800e77:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e7b:	48 89 d6             	mov    %rdx,%rsi
  800e7e:	89 c7                	mov    %eax,%edi
  800e80:	48 b8 39 08 80 00 00 	movabs $0x800839,%rax
  800e87:	00 00 00 
  800e8a:	ff d0                	callq  *%rax
  800e8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e93:	79 05                	jns    800e9a <fstat+0x59>
		return r;
  800e95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e98:	eb 5e                	jmp    800ef8 <fstat+0xb7>
	if (!dev->dev_stat)
  800e9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9e:	48 8b 40 28          	mov    0x28(%rax),%rax
  800ea2:	48 85 c0             	test   %rax,%rax
  800ea5:	75 07                	jne    800eae <fstat+0x6d>
		return -E_NOT_SUPP;
  800ea7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800eac:	eb 4a                	jmp    800ef8 <fstat+0xb7>
	stat->st_name[0] = 0;
  800eae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eb2:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800eb5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eb9:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800ec0:	00 00 00 
	stat->st_isdir = 0;
  800ec3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ec7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800ece:	00 00 00 
	stat->st_dev = dev;
  800ed1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ed5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ed9:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800ee0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ee4:	48 8b 40 28          	mov    0x28(%rax),%rax
  800ee8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eec:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800ef0:	48 89 ce             	mov    %rcx,%rsi
  800ef3:	48 89 d7             	mov    %rdx,%rdi
  800ef6:	ff d0                	callq  *%rax
}
  800ef8:	c9                   	leaveq 
  800ef9:	c3                   	retq   

0000000000800efa <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800efa:	55                   	push   %rbp
  800efb:	48 89 e5             	mov    %rsp,%rbp
  800efe:	48 83 ec 20          	sub    $0x20,%rsp
  800f02:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f06:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0e:	be 00 00 00 00       	mov    $0x0,%esi
  800f13:	48 89 c7             	mov    %rax,%rdi
  800f16:	48 b8 e8 0f 80 00 00 	movabs $0x800fe8,%rax
  800f1d:	00 00 00 
  800f20:	ff d0                	callq  *%rax
  800f22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f29:	79 05                	jns    800f30 <stat+0x36>
		return fd;
  800f2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f2e:	eb 2f                	jmp    800f5f <stat+0x65>
	r = fstat(fd, stat);
  800f30:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f37:	48 89 d6             	mov    %rdx,%rsi
  800f3a:	89 c7                	mov    %eax,%edi
  800f3c:	48 b8 41 0e 80 00 00 	movabs $0x800e41,%rax
  800f43:	00 00 00 
  800f46:	ff d0                	callq  *%rax
  800f48:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800f4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f4e:	89 c7                	mov    %eax,%edi
  800f50:	48 b8 f0 08 80 00 00 	movabs $0x8008f0,%rax
  800f57:	00 00 00 
  800f5a:	ff d0                	callq  *%rax
	return r;
  800f5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800f5f:	c9                   	leaveq 
  800f60:	c3                   	retq   

0000000000800f61 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800f61:	55                   	push   %rbp
  800f62:	48 89 e5             	mov    %rsp,%rbp
  800f65:	48 83 ec 10          	sub    $0x10,%rsp
  800f69:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f6c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800f70:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f77:	00 00 00 
  800f7a:	8b 00                	mov    (%rax),%eax
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	75 1d                	jne    800f9d <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800f80:	bf 01 00 00 00       	mov    $0x1,%edi
  800f85:	48 b8 fc 34 80 00 00 	movabs $0x8034fc,%rax
  800f8c:	00 00 00 
  800f8f:	ff d0                	callq  *%rax
  800f91:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800f98:	00 00 00 
  800f9b:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f9d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800fa4:	00 00 00 
  800fa7:	8b 00                	mov    (%rax),%eax
  800fa9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800fac:	b9 07 00 00 00       	mov    $0x7,%ecx
  800fb1:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800fb8:	00 00 00 
  800fbb:	89 c7                	mov    %eax,%edi
  800fbd:	48 b8 64 34 80 00 00 	movabs $0x803464,%rax
  800fc4:	00 00 00 
  800fc7:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800fc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fcd:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd2:	48 89 c6             	mov    %rax,%rsi
  800fd5:	bf 00 00 00 00       	mov    $0x0,%edi
  800fda:	48 b8 9b 33 80 00 00 	movabs $0x80339b,%rax
  800fe1:	00 00 00 
  800fe4:	ff d0                	callq  *%rax
}
  800fe6:	c9                   	leaveq 
  800fe7:	c3                   	retq   

0000000000800fe8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800fe8:	55                   	push   %rbp
  800fe9:	48 89 e5             	mov    %rsp,%rbp
  800fec:	48 83 ec 20          	sub    $0x20,%rsp
  800ff0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ff4:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  800ff7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ffb:	48 89 c7             	mov    %rax,%rdi
  800ffe:	48 b8 6b 2b 80 00 00 	movabs $0x802b6b,%rax
  801005:	00 00 00 
  801008:	ff d0                	callq  *%rax
  80100a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80100f:	7e 0a                	jle    80101b <open+0x33>
		return -E_BAD_PATH;
  801011:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801016:	e9 a5 00 00 00       	jmpq   8010c0 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80101b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80101f:	48 89 c7             	mov    %rax,%rdi
  801022:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  801029:	00 00 00 
  80102c:	ff d0                	callq  *%rax
  80102e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801031:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801035:	79 08                	jns    80103f <open+0x57>
		return r;
  801037:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80103a:	e9 81 00 00 00       	jmpq   8010c0 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80103f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801043:	48 89 c6             	mov    %rax,%rsi
  801046:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80104d:	00 00 00 
  801050:	48 b8 d7 2b 80 00 00 	movabs $0x802bd7,%rax
  801057:	00 00 00 
  80105a:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80105c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801063:	00 00 00 
  801066:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801069:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80106f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801073:	48 89 c6             	mov    %rax,%rsi
  801076:	bf 01 00 00 00       	mov    $0x1,%edi
  80107b:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  801082:	00 00 00 
  801085:	ff d0                	callq  *%rax
  801087:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80108a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80108e:	79 1d                	jns    8010ad <open+0xc5>
		fd_close(fd, 0);
  801090:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801094:	be 00 00 00 00       	mov    $0x0,%esi
  801099:	48 89 c7             	mov    %rax,%rdi
  80109c:	48 b8 70 07 80 00 00 	movabs $0x800770,%rax
  8010a3:	00 00 00 
  8010a6:	ff d0                	callq  *%rax
		return r;
  8010a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ab:	eb 13                	jmp    8010c0 <open+0xd8>
	}

	return fd2num(fd);
  8010ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b1:	48 89 c7             	mov    %rax,%rdi
  8010b4:	48 b8 fa 05 80 00 00 	movabs $0x8005fa,%rax
  8010bb:	00 00 00 
  8010be:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  8010c0:	c9                   	leaveq 
  8010c1:	c3                   	retq   

00000000008010c2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8010c2:	55                   	push   %rbp
  8010c3:	48 89 e5             	mov    %rsp,%rbp
  8010c6:	48 83 ec 10          	sub    $0x10,%rsp
  8010ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8010ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d2:	8b 50 0c             	mov    0xc(%rax),%edx
  8010d5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8010dc:	00 00 00 
  8010df:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8010e1:	be 00 00 00 00       	mov    $0x0,%esi
  8010e6:	bf 06 00 00 00       	mov    $0x6,%edi
  8010eb:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  8010f2:	00 00 00 
  8010f5:	ff d0                	callq  *%rax
}
  8010f7:	c9                   	leaveq 
  8010f8:	c3                   	retq   

00000000008010f9 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8010f9:	55                   	push   %rbp
  8010fa:	48 89 e5             	mov    %rsp,%rbp
  8010fd:	48 83 ec 30          	sub    $0x30,%rsp
  801101:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801105:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801109:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80110d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801111:	8b 50 0c             	mov    0xc(%rax),%edx
  801114:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80111b:	00 00 00 
  80111e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801120:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801127:	00 00 00 
  80112a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80112e:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801132:	be 00 00 00 00       	mov    $0x0,%esi
  801137:	bf 03 00 00 00       	mov    $0x3,%edi
  80113c:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  801143:	00 00 00 
  801146:	ff d0                	callq  *%rax
  801148:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80114b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80114f:	79 05                	jns    801156 <devfile_read+0x5d>
		return r;
  801151:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801154:	eb 26                	jmp    80117c <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801156:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801159:	48 63 d0             	movslq %eax,%rdx
  80115c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801160:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801167:	00 00 00 
  80116a:	48 89 c7             	mov    %rax,%rdi
  80116d:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  801174:	00 00 00 
  801177:	ff d0                	callq  *%rax

	return r;
  801179:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80117c:	c9                   	leaveq 
  80117d:	c3                   	retq   

000000000080117e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80117e:	55                   	push   %rbp
  80117f:	48 89 e5             	mov    %rsp,%rbp
  801182:	48 83 ec 30          	sub    $0x30,%rsp
  801186:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80118a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80118e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  801192:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801199:	00 
  80119a:	76 08                	jbe    8011a4 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  80119c:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8011a3:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8011a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a8:	8b 50 0c             	mov    0xc(%rax),%edx
  8011ab:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011b2:	00 00 00 
  8011b5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8011b7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011be:	00 00 00 
  8011c1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011c5:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  8011c9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011d1:	48 89 c6             	mov    %rax,%rsi
  8011d4:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8011db:	00 00 00 
  8011de:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  8011e5:	00 00 00 
  8011e8:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8011ea:	be 00 00 00 00       	mov    $0x0,%esi
  8011ef:	bf 04 00 00 00       	mov    $0x4,%edi
  8011f4:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  8011fb:	00 00 00 
  8011fe:	ff d0                	callq  *%rax
  801200:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801203:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801207:	79 05                	jns    80120e <devfile_write+0x90>
		return r;
  801209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80120c:	eb 03                	jmp    801211 <devfile_write+0x93>

	return r;
  80120e:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  801211:	c9                   	leaveq 
  801212:	c3                   	retq   

0000000000801213 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801213:	55                   	push   %rbp
  801214:	48 89 e5             	mov    %rsp,%rbp
  801217:	48 83 ec 20          	sub    $0x20,%rsp
  80121b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801223:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801227:	8b 50 0c             	mov    0xc(%rax),%edx
  80122a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801231:	00 00 00 
  801234:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801236:	be 00 00 00 00       	mov    $0x0,%esi
  80123b:	bf 05 00 00 00       	mov    $0x5,%edi
  801240:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  801247:	00 00 00 
  80124a:	ff d0                	callq  *%rax
  80124c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80124f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801253:	79 05                	jns    80125a <devfile_stat+0x47>
		return r;
  801255:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801258:	eb 56                	jmp    8012b0 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80125a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80125e:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801265:	00 00 00 
  801268:	48 89 c7             	mov    %rax,%rdi
  80126b:	48 b8 d7 2b 80 00 00 	movabs $0x802bd7,%rax
  801272:	00 00 00 
  801275:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801277:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80127e:	00 00 00 
  801281:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801287:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80128b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801291:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801298:	00 00 00 
  80129b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8012a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a5:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8012ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b0:	c9                   	leaveq 
  8012b1:	c3                   	retq   

00000000008012b2 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8012b2:	55                   	push   %rbp
  8012b3:	48 89 e5             	mov    %rsp,%rbp
  8012b6:	48 83 ec 10          	sub    $0x10,%rsp
  8012ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012be:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8012c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c5:	8b 50 0c             	mov    0xc(%rax),%edx
  8012c8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012cf:	00 00 00 
  8012d2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8012d4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012db:	00 00 00 
  8012de:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8012e1:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8012e4:	be 00 00 00 00       	mov    $0x0,%esi
  8012e9:	bf 02 00 00 00       	mov    $0x2,%edi
  8012ee:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  8012f5:	00 00 00 
  8012f8:	ff d0                	callq  *%rax
}
  8012fa:	c9                   	leaveq 
  8012fb:	c3                   	retq   

00000000008012fc <remove>:

// Delete a file
int
remove(const char *path)
{
  8012fc:	55                   	push   %rbp
  8012fd:	48 89 e5             	mov    %rsp,%rbp
  801300:	48 83 ec 10          	sub    $0x10,%rsp
  801304:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801308:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130c:	48 89 c7             	mov    %rax,%rdi
  80130f:	48 b8 6b 2b 80 00 00 	movabs $0x802b6b,%rax
  801316:	00 00 00 
  801319:	ff d0                	callq  *%rax
  80131b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801320:	7e 07                	jle    801329 <remove+0x2d>
		return -E_BAD_PATH;
  801322:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801327:	eb 33                	jmp    80135c <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801329:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132d:	48 89 c6             	mov    %rax,%rsi
  801330:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801337:	00 00 00 
  80133a:	48 b8 d7 2b 80 00 00 	movabs $0x802bd7,%rax
  801341:	00 00 00 
  801344:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801346:	be 00 00 00 00       	mov    $0x0,%esi
  80134b:	bf 07 00 00 00       	mov    $0x7,%edi
  801350:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  801357:	00 00 00 
  80135a:	ff d0                	callq  *%rax
}
  80135c:	c9                   	leaveq 
  80135d:	c3                   	retq   

000000000080135e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80135e:	55                   	push   %rbp
  80135f:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801362:	be 00 00 00 00       	mov    $0x0,%esi
  801367:	bf 08 00 00 00       	mov    $0x8,%edi
  80136c:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  801373:	00 00 00 
  801376:	ff d0                	callq  *%rax
}
  801378:	5d                   	pop    %rbp
  801379:	c3                   	retq   

000000000080137a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80137a:	55                   	push   %rbp
  80137b:	48 89 e5             	mov    %rsp,%rbp
  80137e:	53                   	push   %rbx
  80137f:	48 83 ec 38          	sub    $0x38,%rsp
  801383:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801387:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80138b:	48 89 c7             	mov    %rax,%rdi
  80138e:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  801395:	00 00 00 
  801398:	ff d0                	callq  *%rax
  80139a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80139d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8013a1:	0f 88 bf 01 00 00    	js     801566 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ab:	ba 07 04 00 00       	mov    $0x407,%edx
  8013b0:	48 89 c6             	mov    %rax,%rsi
  8013b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8013b8:	48 b8 03 03 80 00 00 	movabs $0x800303,%rax
  8013bf:	00 00 00 
  8013c2:	ff d0                	callq  *%rax
  8013c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8013c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8013cb:	0f 88 95 01 00 00    	js     801566 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8013d1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8013d5:	48 89 c7             	mov    %rax,%rdi
  8013d8:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  8013df:	00 00 00 
  8013e2:	ff d0                	callq  *%rax
  8013e4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8013e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8013eb:	0f 88 5d 01 00 00    	js     80154e <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8013f5:	ba 07 04 00 00       	mov    $0x407,%edx
  8013fa:	48 89 c6             	mov    %rax,%rsi
  8013fd:	bf 00 00 00 00       	mov    $0x0,%edi
  801402:	48 b8 03 03 80 00 00 	movabs $0x800303,%rax
  801409:	00 00 00 
  80140c:	ff d0                	callq  *%rax
  80140e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801411:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801415:	0f 88 33 01 00 00    	js     80154e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80141b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141f:	48 89 c7             	mov    %rax,%rdi
  801422:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  801429:	00 00 00 
  80142c:	ff d0                	callq  *%rax
  80142e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801432:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801436:	ba 07 04 00 00       	mov    $0x407,%edx
  80143b:	48 89 c6             	mov    %rax,%rsi
  80143e:	bf 00 00 00 00       	mov    $0x0,%edi
  801443:	48 b8 03 03 80 00 00 	movabs $0x800303,%rax
  80144a:	00 00 00 
  80144d:	ff d0                	callq  *%rax
  80144f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801452:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801456:	79 05                	jns    80145d <pipe+0xe3>
		goto err2;
  801458:	e9 d9 00 00 00       	jmpq   801536 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80145d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801461:	48 89 c7             	mov    %rax,%rdi
  801464:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  80146b:	00 00 00 
  80146e:	ff d0                	callq  *%rax
  801470:	48 89 c2             	mov    %rax,%rdx
  801473:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801477:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80147d:	48 89 d1             	mov    %rdx,%rcx
  801480:	ba 00 00 00 00       	mov    $0x0,%edx
  801485:	48 89 c6             	mov    %rax,%rsi
  801488:	bf 00 00 00 00       	mov    $0x0,%edi
  80148d:	48 b8 53 03 80 00 00 	movabs $0x800353,%rax
  801494:	00 00 00 
  801497:	ff d0                	callq  *%rax
  801499:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80149c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8014a0:	79 1b                	jns    8014bd <pipe+0x143>
		goto err3;
  8014a2:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8014a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014a7:	48 89 c6             	mov    %rax,%rsi
  8014aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8014af:	48 b8 ae 03 80 00 00 	movabs $0x8003ae,%rax
  8014b6:	00 00 00 
  8014b9:	ff d0                	callq  *%rax
  8014bb:	eb 79                	jmp    801536 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8014bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c1:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8014c8:	00 00 00 
  8014cb:	8b 12                	mov    (%rdx),%edx
  8014cd:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8014cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8014da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014de:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8014e5:	00 00 00 
  8014e8:	8b 12                	mov    (%rdx),%edx
  8014ea:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8014ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014f0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8014f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fb:	48 89 c7             	mov    %rax,%rdi
  8014fe:	48 b8 fa 05 80 00 00 	movabs $0x8005fa,%rax
  801505:	00 00 00 
  801508:	ff d0                	callq  *%rax
  80150a:	89 c2                	mov    %eax,%edx
  80150c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801510:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801512:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801516:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80151a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80151e:	48 89 c7             	mov    %rax,%rdi
  801521:	48 b8 fa 05 80 00 00 	movabs $0x8005fa,%rax
  801528:	00 00 00 
  80152b:	ff d0                	callq  *%rax
  80152d:	89 03                	mov    %eax,(%rbx)
	return 0;
  80152f:	b8 00 00 00 00       	mov    $0x0,%eax
  801534:	eb 33                	jmp    801569 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  801536:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80153a:	48 89 c6             	mov    %rax,%rsi
  80153d:	bf 00 00 00 00       	mov    $0x0,%edi
  801542:	48 b8 ae 03 80 00 00 	movabs $0x8003ae,%rax
  801549:	00 00 00 
  80154c:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  80154e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801552:	48 89 c6             	mov    %rax,%rsi
  801555:	bf 00 00 00 00       	mov    $0x0,%edi
  80155a:	48 b8 ae 03 80 00 00 	movabs $0x8003ae,%rax
  801561:	00 00 00 
  801564:	ff d0                	callq  *%rax
    err:
	return r;
  801566:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801569:	48 83 c4 38          	add    $0x38,%rsp
  80156d:	5b                   	pop    %rbx
  80156e:	5d                   	pop    %rbp
  80156f:	c3                   	retq   

0000000000801570 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801570:	55                   	push   %rbp
  801571:	48 89 e5             	mov    %rsp,%rbp
  801574:	53                   	push   %rbx
  801575:	48 83 ec 28          	sub    $0x28,%rsp
  801579:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80157d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801581:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801588:	00 00 00 
  80158b:	48 8b 00             	mov    (%rax),%rax
  80158e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801594:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  801597:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159b:	48 89 c7             	mov    %rax,%rdi
  80159e:	48 b8 7e 35 80 00 00 	movabs $0x80357e,%rax
  8015a5:	00 00 00 
  8015a8:	ff d0                	callq  *%rax
  8015aa:	89 c3                	mov    %eax,%ebx
  8015ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015b0:	48 89 c7             	mov    %rax,%rdi
  8015b3:	48 b8 7e 35 80 00 00 	movabs $0x80357e,%rax
  8015ba:	00 00 00 
  8015bd:	ff d0                	callq  *%rax
  8015bf:	39 c3                	cmp    %eax,%ebx
  8015c1:	0f 94 c0             	sete   %al
  8015c4:	0f b6 c0             	movzbl %al,%eax
  8015c7:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8015ca:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8015d1:	00 00 00 
  8015d4:	48 8b 00             	mov    (%rax),%rax
  8015d7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8015dd:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8015e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015e3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8015e6:	75 05                	jne    8015ed <_pipeisclosed+0x7d>
			return ret;
  8015e8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8015eb:	eb 4f                	jmp    80163c <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8015ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015f0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8015f3:	74 42                	je     801637 <_pipeisclosed+0xc7>
  8015f5:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8015f9:	75 3c                	jne    801637 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8015fb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801602:	00 00 00 
  801605:	48 8b 00             	mov    (%rax),%rax
  801608:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80160e:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801611:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801614:	89 c6                	mov    %eax,%esi
  801616:	48 bf db 36 80 00 00 	movabs $0x8036db,%rdi
  80161d:	00 00 00 
  801620:	b8 00 00 00 00       	mov    $0x0,%eax
  801625:	49 b8 2f 1e 80 00 00 	movabs $0x801e2f,%r8
  80162c:	00 00 00 
  80162f:	41 ff d0             	callq  *%r8
	}
  801632:	e9 4a ff ff ff       	jmpq   801581 <_pipeisclosed+0x11>
  801637:	e9 45 ff ff ff       	jmpq   801581 <_pipeisclosed+0x11>
}
  80163c:	48 83 c4 28          	add    $0x28,%rsp
  801640:	5b                   	pop    %rbx
  801641:	5d                   	pop    %rbp
  801642:	c3                   	retq   

0000000000801643 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801643:	55                   	push   %rbp
  801644:	48 89 e5             	mov    %rsp,%rbp
  801647:	48 83 ec 30          	sub    $0x30,%rsp
  80164b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80164e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801652:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801655:	48 89 d6             	mov    %rdx,%rsi
  801658:	89 c7                	mov    %eax,%edi
  80165a:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  801661:	00 00 00 
  801664:	ff d0                	callq  *%rax
  801666:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801669:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80166d:	79 05                	jns    801674 <pipeisclosed+0x31>
		return r;
  80166f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801672:	eb 31                	jmp    8016a5 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  801674:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801678:	48 89 c7             	mov    %rax,%rdi
  80167b:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  801682:	00 00 00 
  801685:	ff d0                	callq  *%rax
  801687:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80168b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801693:	48 89 d6             	mov    %rdx,%rsi
  801696:	48 89 c7             	mov    %rax,%rdi
  801699:	48 b8 70 15 80 00 00 	movabs $0x801570,%rax
  8016a0:	00 00 00 
  8016a3:	ff d0                	callq  *%rax
}
  8016a5:	c9                   	leaveq 
  8016a6:	c3                   	retq   

00000000008016a7 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8016a7:	55                   	push   %rbp
  8016a8:	48 89 e5             	mov    %rsp,%rbp
  8016ab:	48 83 ec 40          	sub    $0x40,%rsp
  8016af:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016b3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016b7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8016bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bf:	48 89 c7             	mov    %rax,%rdi
  8016c2:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  8016c9:	00 00 00 
  8016cc:	ff d0                	callq  *%rax
  8016ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8016d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016d6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8016da:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8016e1:	00 
  8016e2:	e9 92 00 00 00       	jmpq   801779 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8016e7:	eb 41                	jmp    80172a <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8016e9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8016ee:	74 09                	je     8016f9 <devpipe_read+0x52>
				return i;
  8016f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f4:	e9 92 00 00 00       	jmpq   80178b <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8016f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801701:	48 89 d6             	mov    %rdx,%rsi
  801704:	48 89 c7             	mov    %rax,%rdi
  801707:	48 b8 70 15 80 00 00 	movabs $0x801570,%rax
  80170e:	00 00 00 
  801711:	ff d0                	callq  *%rax
  801713:	85 c0                	test   %eax,%eax
  801715:	74 07                	je     80171e <devpipe_read+0x77>
				return 0;
  801717:	b8 00 00 00 00       	mov    $0x0,%eax
  80171c:	eb 6d                	jmp    80178b <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80171e:	48 b8 c5 02 80 00 00 	movabs $0x8002c5,%rax
  801725:	00 00 00 
  801728:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80172a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172e:	8b 10                	mov    (%rax),%edx
  801730:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801734:	8b 40 04             	mov    0x4(%rax),%eax
  801737:	39 c2                	cmp    %eax,%edx
  801739:	74 ae                	je     8016e9 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80173b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80173f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801743:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801747:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80174b:	8b 00                	mov    (%rax),%eax
  80174d:	99                   	cltd   
  80174e:	c1 ea 1b             	shr    $0x1b,%edx
  801751:	01 d0                	add    %edx,%eax
  801753:	83 e0 1f             	and    $0x1f,%eax
  801756:	29 d0                	sub    %edx,%eax
  801758:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80175c:	48 98                	cltq   
  80175e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  801763:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  801765:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801769:	8b 00                	mov    (%rax),%eax
  80176b:	8d 50 01             	lea    0x1(%rax),%edx
  80176e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801772:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801774:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801779:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80177d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801781:	0f 82 60 ff ff ff    	jb     8016e7 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801787:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80178b:	c9                   	leaveq 
  80178c:	c3                   	retq   

000000000080178d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80178d:	55                   	push   %rbp
  80178e:	48 89 e5             	mov    %rsp,%rbp
  801791:	48 83 ec 40          	sub    $0x40,%rsp
  801795:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801799:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80179d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8017a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a5:	48 89 c7             	mov    %rax,%rdi
  8017a8:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  8017af:	00 00 00 
  8017b2:	ff d0                	callq  *%rax
  8017b4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8017b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017bc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8017c0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8017c7:	00 
  8017c8:	e9 8e 00 00 00       	jmpq   80185b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8017cd:	eb 31                	jmp    801800 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8017cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d7:	48 89 d6             	mov    %rdx,%rsi
  8017da:	48 89 c7             	mov    %rax,%rdi
  8017dd:	48 b8 70 15 80 00 00 	movabs $0x801570,%rax
  8017e4:	00 00 00 
  8017e7:	ff d0                	callq  *%rax
  8017e9:	85 c0                	test   %eax,%eax
  8017eb:	74 07                	je     8017f4 <devpipe_write+0x67>
				return 0;
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f2:	eb 79                	jmp    80186d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8017f4:	48 b8 c5 02 80 00 00 	movabs $0x8002c5,%rax
  8017fb:	00 00 00 
  8017fe:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801800:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801804:	8b 40 04             	mov    0x4(%rax),%eax
  801807:	48 63 d0             	movslq %eax,%rdx
  80180a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80180e:	8b 00                	mov    (%rax),%eax
  801810:	48 98                	cltq   
  801812:	48 83 c0 20          	add    $0x20,%rax
  801816:	48 39 c2             	cmp    %rax,%rdx
  801819:	73 b4                	jae    8017cf <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80181b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80181f:	8b 40 04             	mov    0x4(%rax),%eax
  801822:	99                   	cltd   
  801823:	c1 ea 1b             	shr    $0x1b,%edx
  801826:	01 d0                	add    %edx,%eax
  801828:	83 e0 1f             	and    $0x1f,%eax
  80182b:	29 d0                	sub    %edx,%eax
  80182d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801831:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801835:	48 01 ca             	add    %rcx,%rdx
  801838:	0f b6 0a             	movzbl (%rdx),%ecx
  80183b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80183f:	48 98                	cltq   
  801841:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801845:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801849:	8b 40 04             	mov    0x4(%rax),%eax
  80184c:	8d 50 01             	lea    0x1(%rax),%edx
  80184f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801853:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801856:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80185b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80185f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801863:	0f 82 64 ff ff ff    	jb     8017cd <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801869:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80186d:	c9                   	leaveq 
  80186e:	c3                   	retq   

000000000080186f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80186f:	55                   	push   %rbp
  801870:	48 89 e5             	mov    %rsp,%rbp
  801873:	48 83 ec 20          	sub    $0x20,%rsp
  801877:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80187b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80187f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801883:	48 89 c7             	mov    %rax,%rdi
  801886:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  80188d:	00 00 00 
  801890:	ff d0                	callq  *%rax
  801892:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801896:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80189a:	48 be ee 36 80 00 00 	movabs $0x8036ee,%rsi
  8018a1:	00 00 00 
  8018a4:	48 89 c7             	mov    %rax,%rdi
  8018a7:	48 b8 d7 2b 80 00 00 	movabs $0x802bd7,%rax
  8018ae:	00 00 00 
  8018b1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8018b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018b7:	8b 50 04             	mov    0x4(%rax),%edx
  8018ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018be:	8b 00                	mov    (%rax),%eax
  8018c0:	29 c2                	sub    %eax,%edx
  8018c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018c6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8018cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018d0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8018d7:	00 00 00 
	stat->st_dev = &devpipe;
  8018da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018de:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8018e5:	00 00 00 
  8018e8:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8018ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f4:	c9                   	leaveq 
  8018f5:	c3                   	retq   

00000000008018f6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018f6:	55                   	push   %rbp
  8018f7:	48 89 e5             	mov    %rsp,%rbp
  8018fa:	48 83 ec 10          	sub    $0x10,%rsp
  8018fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801902:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801906:	48 89 c6             	mov    %rax,%rsi
  801909:	bf 00 00 00 00       	mov    $0x0,%edi
  80190e:	48 b8 ae 03 80 00 00 	movabs $0x8003ae,%rax
  801915:	00 00 00 
  801918:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80191a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80191e:	48 89 c7             	mov    %rax,%rdi
  801921:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  801928:	00 00 00 
  80192b:	ff d0                	callq  *%rax
  80192d:	48 89 c6             	mov    %rax,%rsi
  801930:	bf 00 00 00 00       	mov    $0x0,%edi
  801935:	48 b8 ae 03 80 00 00 	movabs $0x8003ae,%rax
  80193c:	00 00 00 
  80193f:	ff d0                	callq  *%rax
}
  801941:	c9                   	leaveq 
  801942:	c3                   	retq   

0000000000801943 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801943:	55                   	push   %rbp
  801944:	48 89 e5             	mov    %rsp,%rbp
  801947:	48 83 ec 20          	sub    $0x20,%rsp
  80194b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80194e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801951:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801954:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801958:	be 01 00 00 00       	mov    $0x1,%esi
  80195d:	48 89 c7             	mov    %rax,%rdi
  801960:	48 b8 bb 01 80 00 00 	movabs $0x8001bb,%rax
  801967:	00 00 00 
  80196a:	ff d0                	callq  *%rax
}
  80196c:	c9                   	leaveq 
  80196d:	c3                   	retq   

000000000080196e <getchar>:

int
getchar(void)
{
  80196e:	55                   	push   %rbp
  80196f:	48 89 e5             	mov    %rsp,%rbp
  801972:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801976:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80197a:	ba 01 00 00 00       	mov    $0x1,%edx
  80197f:	48 89 c6             	mov    %rax,%rsi
  801982:	bf 00 00 00 00       	mov    $0x0,%edi
  801987:	48 b8 12 0b 80 00 00 	movabs $0x800b12,%rax
  80198e:	00 00 00 
  801991:	ff d0                	callq  *%rax
  801993:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801996:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80199a:	79 05                	jns    8019a1 <getchar+0x33>
		return r;
  80199c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80199f:	eb 14                	jmp    8019b5 <getchar+0x47>
	if (r < 1)
  8019a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019a5:	7f 07                	jg     8019ae <getchar+0x40>
		return -E_EOF;
  8019a7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8019ac:	eb 07                	jmp    8019b5 <getchar+0x47>
	return c;
  8019ae:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8019b2:	0f b6 c0             	movzbl %al,%eax
}
  8019b5:	c9                   	leaveq 
  8019b6:	c3                   	retq   

00000000008019b7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8019b7:	55                   	push   %rbp
  8019b8:	48 89 e5             	mov    %rsp,%rbp
  8019bb:	48 83 ec 20          	sub    $0x20,%rsp
  8019bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019c2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8019c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019c9:	48 89 d6             	mov    %rdx,%rsi
  8019cc:	89 c7                	mov    %eax,%edi
  8019ce:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  8019d5:	00 00 00 
  8019d8:	ff d0                	callq  *%rax
  8019da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019e1:	79 05                	jns    8019e8 <iscons+0x31>
		return r;
  8019e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e6:	eb 1a                	jmp    801a02 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8019e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019ec:	8b 10                	mov    (%rax),%edx
  8019ee:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8019f5:	00 00 00 
  8019f8:	8b 00                	mov    (%rax),%eax
  8019fa:	39 c2                	cmp    %eax,%edx
  8019fc:	0f 94 c0             	sete   %al
  8019ff:	0f b6 c0             	movzbl %al,%eax
}
  801a02:	c9                   	leaveq 
  801a03:	c3                   	retq   

0000000000801a04 <opencons>:

int
opencons(void)
{
  801a04:	55                   	push   %rbp
  801a05:	48 89 e5             	mov    %rsp,%rbp
  801a08:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801a0c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801a10:	48 89 c7             	mov    %rax,%rdi
  801a13:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  801a1a:	00 00 00 
  801a1d:	ff d0                	callq  *%rax
  801a1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a26:	79 05                	jns    801a2d <opencons+0x29>
		return r;
  801a28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a2b:	eb 5b                	jmp    801a88 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a31:	ba 07 04 00 00       	mov    $0x407,%edx
  801a36:	48 89 c6             	mov    %rax,%rsi
  801a39:	bf 00 00 00 00       	mov    $0x0,%edi
  801a3e:	48 b8 03 03 80 00 00 	movabs $0x800303,%rax
  801a45:	00 00 00 
  801a48:	ff d0                	callq  *%rax
  801a4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a51:	79 05                	jns    801a58 <opencons+0x54>
		return r;
  801a53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a56:	eb 30                	jmp    801a88 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801a58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a5c:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801a63:	00 00 00 
  801a66:	8b 12                	mov    (%rdx),%edx
  801a68:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801a6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a6e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801a75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a79:	48 89 c7             	mov    %rax,%rdi
  801a7c:	48 b8 fa 05 80 00 00 	movabs $0x8005fa,%rax
  801a83:	00 00 00 
  801a86:	ff d0                	callq  *%rax
}
  801a88:	c9                   	leaveq 
  801a89:	c3                   	retq   

0000000000801a8a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801a8a:	55                   	push   %rbp
  801a8b:	48 89 e5             	mov    %rsp,%rbp
  801a8e:	48 83 ec 30          	sub    $0x30,%rsp
  801a92:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a96:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a9a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801a9e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801aa3:	75 07                	jne    801aac <devcons_read+0x22>
		return 0;
  801aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  801aaa:	eb 4b                	jmp    801af7 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801aac:	eb 0c                	jmp    801aba <devcons_read+0x30>
		sys_yield();
  801aae:	48 b8 c5 02 80 00 00 	movabs $0x8002c5,%rax
  801ab5:	00 00 00 
  801ab8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801aba:	48 b8 05 02 80 00 00 	movabs $0x800205,%rax
  801ac1:	00 00 00 
  801ac4:	ff d0                	callq  *%rax
  801ac6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ac9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801acd:	74 df                	je     801aae <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801acf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ad3:	79 05                	jns    801ada <devcons_read+0x50>
		return c;
  801ad5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad8:	eb 1d                	jmp    801af7 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801ada:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801ade:	75 07                	jne    801ae7 <devcons_read+0x5d>
		return 0;
  801ae0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae5:	eb 10                	jmp    801af7 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801ae7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aea:	89 c2                	mov    %eax,%edx
  801aec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801af0:	88 10                	mov    %dl,(%rax)
	return 1;
  801af2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801af7:	c9                   	leaveq 
  801af8:	c3                   	retq   

0000000000801af9 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801af9:	55                   	push   %rbp
  801afa:	48 89 e5             	mov    %rsp,%rbp
  801afd:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801b04:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801b0b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801b12:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b20:	eb 76                	jmp    801b98 <devcons_write+0x9f>
		m = n - tot;
  801b22:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801b29:	89 c2                	mov    %eax,%edx
  801b2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2e:	29 c2                	sub    %eax,%edx
  801b30:	89 d0                	mov    %edx,%eax
  801b32:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801b35:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b38:	83 f8 7f             	cmp    $0x7f,%eax
  801b3b:	76 07                	jbe    801b44 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801b3d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801b44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b47:	48 63 d0             	movslq %eax,%rdx
  801b4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b4d:	48 63 c8             	movslq %eax,%rcx
  801b50:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801b57:	48 01 c1             	add    %rax,%rcx
  801b5a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801b61:	48 89 ce             	mov    %rcx,%rsi
  801b64:	48 89 c7             	mov    %rax,%rdi
  801b67:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  801b6e:	00 00 00 
  801b71:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801b73:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b76:	48 63 d0             	movslq %eax,%rdx
  801b79:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801b80:	48 89 d6             	mov    %rdx,%rsi
  801b83:	48 89 c7             	mov    %rax,%rdi
  801b86:	48 b8 bb 01 80 00 00 	movabs $0x8001bb,%rax
  801b8d:	00 00 00 
  801b90:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b92:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b95:	01 45 fc             	add    %eax,-0x4(%rbp)
  801b98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b9b:	48 98                	cltq   
  801b9d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801ba4:	0f 82 78 ff ff ff    	jb     801b22 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801baa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801bad:	c9                   	leaveq 
  801bae:	c3                   	retq   

0000000000801baf <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801baf:	55                   	push   %rbp
  801bb0:	48 89 e5             	mov    %rsp,%rbp
  801bb3:	48 83 ec 08          	sub    $0x8,%rsp
  801bb7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801bbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc0:	c9                   	leaveq 
  801bc1:	c3                   	retq   

0000000000801bc2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801bc2:	55                   	push   %rbp
  801bc3:	48 89 e5             	mov    %rsp,%rbp
  801bc6:	48 83 ec 10          	sub    $0x10,%rsp
  801bca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801bd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bd6:	48 be fa 36 80 00 00 	movabs $0x8036fa,%rsi
  801bdd:	00 00 00 
  801be0:	48 89 c7             	mov    %rax,%rdi
  801be3:	48 b8 d7 2b 80 00 00 	movabs $0x802bd7,%rax
  801bea:	00 00 00 
  801bed:	ff d0                	callq  *%rax
	return 0;
  801bef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf4:	c9                   	leaveq 
  801bf5:	c3                   	retq   

0000000000801bf6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801bf6:	55                   	push   %rbp
  801bf7:	48 89 e5             	mov    %rsp,%rbp
  801bfa:	53                   	push   %rbx
  801bfb:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801c02:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801c09:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801c0f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801c16:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801c1d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801c24:	84 c0                	test   %al,%al
  801c26:	74 23                	je     801c4b <_panic+0x55>
  801c28:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801c2f:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801c33:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801c37:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801c3b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801c3f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801c43:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801c47:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801c4b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801c52:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801c59:	00 00 00 
  801c5c:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801c63:	00 00 00 
  801c66:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801c6a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801c71:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801c78:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801c7f:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801c86:	00 00 00 
  801c89:	48 8b 18             	mov    (%rax),%rbx
  801c8c:	48 b8 87 02 80 00 00 	movabs $0x800287,%rax
  801c93:	00 00 00 
  801c96:	ff d0                	callq  *%rax
  801c98:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801c9e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801ca5:	41 89 c8             	mov    %ecx,%r8d
  801ca8:	48 89 d1             	mov    %rdx,%rcx
  801cab:	48 89 da             	mov    %rbx,%rdx
  801cae:	89 c6                	mov    %eax,%esi
  801cb0:	48 bf 08 37 80 00 00 	movabs $0x803708,%rdi
  801cb7:	00 00 00 
  801cba:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbf:	49 b9 2f 1e 80 00 00 	movabs $0x801e2f,%r9
  801cc6:	00 00 00 
  801cc9:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ccc:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801cd3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801cda:	48 89 d6             	mov    %rdx,%rsi
  801cdd:	48 89 c7             	mov    %rax,%rdi
  801ce0:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  801ce7:	00 00 00 
  801cea:	ff d0                	callq  *%rax
	cprintf("\n");
  801cec:	48 bf 2b 37 80 00 00 	movabs $0x80372b,%rdi
  801cf3:	00 00 00 
  801cf6:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfb:	48 ba 2f 1e 80 00 00 	movabs $0x801e2f,%rdx
  801d02:	00 00 00 
  801d05:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d07:	cc                   	int3   
  801d08:	eb fd                	jmp    801d07 <_panic+0x111>

0000000000801d0a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801d0a:	55                   	push   %rbp
  801d0b:	48 89 e5             	mov    %rsp,%rbp
  801d0e:	48 83 ec 10          	sub    $0x10,%rsp
  801d12:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d15:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  801d19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d1d:	8b 00                	mov    (%rax),%eax
  801d1f:	8d 48 01             	lea    0x1(%rax),%ecx
  801d22:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d26:	89 0a                	mov    %ecx,(%rdx)
  801d28:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d2b:	89 d1                	mov    %edx,%ecx
  801d2d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d31:	48 98                	cltq   
  801d33:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  801d37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d3b:	8b 00                	mov    (%rax),%eax
  801d3d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801d42:	75 2c                	jne    801d70 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  801d44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d48:	8b 00                	mov    (%rax),%eax
  801d4a:	48 98                	cltq   
  801d4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d50:	48 83 c2 08          	add    $0x8,%rdx
  801d54:	48 89 c6             	mov    %rax,%rsi
  801d57:	48 89 d7             	mov    %rdx,%rdi
  801d5a:	48 b8 bb 01 80 00 00 	movabs $0x8001bb,%rax
  801d61:	00 00 00 
  801d64:	ff d0                	callq  *%rax
		b->idx = 0;
  801d66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d6a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  801d70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d74:	8b 40 04             	mov    0x4(%rax),%eax
  801d77:	8d 50 01             	lea    0x1(%rax),%edx
  801d7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d7e:	89 50 04             	mov    %edx,0x4(%rax)
}
  801d81:	c9                   	leaveq 
  801d82:	c3                   	retq   

0000000000801d83 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801d83:	55                   	push   %rbp
  801d84:	48 89 e5             	mov    %rsp,%rbp
  801d87:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801d8e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801d95:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  801d9c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801da3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801daa:	48 8b 0a             	mov    (%rdx),%rcx
  801dad:	48 89 08             	mov    %rcx,(%rax)
  801db0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801db4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801db8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801dbc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  801dc0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801dc7:	00 00 00 
	b.cnt = 0;
  801dca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801dd1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  801dd4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  801ddb:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801de2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  801de9:	48 89 c6             	mov    %rax,%rsi
  801dec:	48 bf 0a 1d 80 00 00 	movabs $0x801d0a,%rdi
  801df3:	00 00 00 
  801df6:	48 b8 e2 21 80 00 00 	movabs $0x8021e2,%rax
  801dfd:	00 00 00 
  801e00:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  801e02:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  801e08:	48 98                	cltq   
  801e0a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801e11:	48 83 c2 08          	add    $0x8,%rdx
  801e15:	48 89 c6             	mov    %rax,%rsi
  801e18:	48 89 d7             	mov    %rdx,%rdi
  801e1b:	48 b8 bb 01 80 00 00 	movabs $0x8001bb,%rax
  801e22:	00 00 00 
  801e25:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  801e27:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  801e2d:	c9                   	leaveq 
  801e2e:	c3                   	retq   

0000000000801e2f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801e2f:	55                   	push   %rbp
  801e30:	48 89 e5             	mov    %rsp,%rbp
  801e33:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  801e3a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  801e41:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  801e48:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801e4f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801e56:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801e5d:	84 c0                	test   %al,%al
  801e5f:	74 20                	je     801e81 <cprintf+0x52>
  801e61:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801e65:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801e69:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801e6d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801e71:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801e75:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801e79:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801e7d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801e81:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  801e88:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  801e8f:	00 00 00 
  801e92:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801e99:	00 00 00 
  801e9c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801ea0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801ea7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801eae:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801eb5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801ebc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801ec3:	48 8b 0a             	mov    (%rdx),%rcx
  801ec6:	48 89 08             	mov    %rcx,(%rax)
  801ec9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801ecd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801ed1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801ed5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  801ed9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  801ee0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801ee7:	48 89 d6             	mov    %rdx,%rsi
  801eea:	48 89 c7             	mov    %rax,%rdi
  801eed:	48 b8 83 1d 80 00 00 	movabs $0x801d83,%rax
  801ef4:	00 00 00 
  801ef7:	ff d0                	callq  *%rax
  801ef9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  801eff:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801f05:	c9                   	leaveq 
  801f06:	c3                   	retq   

0000000000801f07 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801f07:	55                   	push   %rbp
  801f08:	48 89 e5             	mov    %rsp,%rbp
  801f0b:	53                   	push   %rbx
  801f0c:	48 83 ec 38          	sub    $0x38,%rsp
  801f10:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801f14:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801f18:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801f1c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801f1f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  801f23:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801f27:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801f2a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801f2e:	77 3b                	ja     801f6b <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801f30:	8b 45 d0             	mov    -0x30(%rbp),%eax
  801f33:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801f37:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  801f3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f43:	48 f7 f3             	div    %rbx
  801f46:	48 89 c2             	mov    %rax,%rdx
  801f49:	8b 7d cc             	mov    -0x34(%rbp),%edi
  801f4c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801f4f:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  801f53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f57:	41 89 f9             	mov    %edi,%r9d
  801f5a:	48 89 c7             	mov    %rax,%rdi
  801f5d:	48 b8 07 1f 80 00 00 	movabs $0x801f07,%rax
  801f64:	00 00 00 
  801f67:	ff d0                	callq  *%rax
  801f69:	eb 1e                	jmp    801f89 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801f6b:	eb 12                	jmp    801f7f <printnum+0x78>
			putch(padc, putdat);
  801f6d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801f71:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801f74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f78:	48 89 ce             	mov    %rcx,%rsi
  801f7b:	89 d7                	mov    %edx,%edi
  801f7d:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801f7f:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  801f83:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  801f87:	7f e4                	jg     801f6d <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801f89:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801f8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f90:	ba 00 00 00 00       	mov    $0x0,%edx
  801f95:	48 f7 f1             	div    %rcx
  801f98:	48 89 d0             	mov    %rdx,%rax
  801f9b:	48 ba 08 39 80 00 00 	movabs $0x803908,%rdx
  801fa2:	00 00 00 
  801fa5:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  801fa9:	0f be d0             	movsbl %al,%edx
  801fac:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801fb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb4:	48 89 ce             	mov    %rcx,%rsi
  801fb7:	89 d7                	mov    %edx,%edi
  801fb9:	ff d0                	callq  *%rax
}
  801fbb:	48 83 c4 38          	add    $0x38,%rsp
  801fbf:	5b                   	pop    %rbx
  801fc0:	5d                   	pop    %rbp
  801fc1:	c3                   	retq   

0000000000801fc2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801fc2:	55                   	push   %rbp
  801fc3:	48 89 e5             	mov    %rsp,%rbp
  801fc6:	48 83 ec 1c          	sub    $0x1c,%rsp
  801fca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801fce:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  801fd1:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801fd5:	7e 52                	jle    802029 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  801fd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fdb:	8b 00                	mov    (%rax),%eax
  801fdd:	83 f8 30             	cmp    $0x30,%eax
  801fe0:	73 24                	jae    802006 <getuint+0x44>
  801fe2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fe6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801fea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fee:	8b 00                	mov    (%rax),%eax
  801ff0:	89 c0                	mov    %eax,%eax
  801ff2:	48 01 d0             	add    %rdx,%rax
  801ff5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ff9:	8b 12                	mov    (%rdx),%edx
  801ffb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801ffe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802002:	89 0a                	mov    %ecx,(%rdx)
  802004:	eb 17                	jmp    80201d <getuint+0x5b>
  802006:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80200a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80200e:	48 89 d0             	mov    %rdx,%rax
  802011:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802015:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802019:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80201d:	48 8b 00             	mov    (%rax),%rax
  802020:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802024:	e9 a3 00 00 00       	jmpq   8020cc <getuint+0x10a>
	else if (lflag)
  802029:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80202d:	74 4f                	je     80207e <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80202f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802033:	8b 00                	mov    (%rax),%eax
  802035:	83 f8 30             	cmp    $0x30,%eax
  802038:	73 24                	jae    80205e <getuint+0x9c>
  80203a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80203e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802042:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802046:	8b 00                	mov    (%rax),%eax
  802048:	89 c0                	mov    %eax,%eax
  80204a:	48 01 d0             	add    %rdx,%rax
  80204d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802051:	8b 12                	mov    (%rdx),%edx
  802053:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802056:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80205a:	89 0a                	mov    %ecx,(%rdx)
  80205c:	eb 17                	jmp    802075 <getuint+0xb3>
  80205e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802062:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802066:	48 89 d0             	mov    %rdx,%rax
  802069:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80206d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802071:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802075:	48 8b 00             	mov    (%rax),%rax
  802078:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80207c:	eb 4e                	jmp    8020cc <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80207e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802082:	8b 00                	mov    (%rax),%eax
  802084:	83 f8 30             	cmp    $0x30,%eax
  802087:	73 24                	jae    8020ad <getuint+0xeb>
  802089:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80208d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802091:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802095:	8b 00                	mov    (%rax),%eax
  802097:	89 c0                	mov    %eax,%eax
  802099:	48 01 d0             	add    %rdx,%rax
  80209c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020a0:	8b 12                	mov    (%rdx),%edx
  8020a2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8020a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020a9:	89 0a                	mov    %ecx,(%rdx)
  8020ab:	eb 17                	jmp    8020c4 <getuint+0x102>
  8020ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8020b5:	48 89 d0             	mov    %rdx,%rax
  8020b8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8020bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020c0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8020c4:	8b 00                	mov    (%rax),%eax
  8020c6:	89 c0                	mov    %eax,%eax
  8020c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8020cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8020d0:	c9                   	leaveq 
  8020d1:	c3                   	retq   

00000000008020d2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8020d2:	55                   	push   %rbp
  8020d3:	48 89 e5             	mov    %rsp,%rbp
  8020d6:	48 83 ec 1c          	sub    $0x1c,%rsp
  8020da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8020de:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8020e1:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8020e5:	7e 52                	jle    802139 <getint+0x67>
		x=va_arg(*ap, long long);
  8020e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020eb:	8b 00                	mov    (%rax),%eax
  8020ed:	83 f8 30             	cmp    $0x30,%eax
  8020f0:	73 24                	jae    802116 <getint+0x44>
  8020f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8020fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020fe:	8b 00                	mov    (%rax),%eax
  802100:	89 c0                	mov    %eax,%eax
  802102:	48 01 d0             	add    %rdx,%rax
  802105:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802109:	8b 12                	mov    (%rdx),%edx
  80210b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80210e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802112:	89 0a                	mov    %ecx,(%rdx)
  802114:	eb 17                	jmp    80212d <getint+0x5b>
  802116:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80211a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80211e:	48 89 d0             	mov    %rdx,%rax
  802121:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802125:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802129:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80212d:	48 8b 00             	mov    (%rax),%rax
  802130:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802134:	e9 a3 00 00 00       	jmpq   8021dc <getint+0x10a>
	else if (lflag)
  802139:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80213d:	74 4f                	je     80218e <getint+0xbc>
		x=va_arg(*ap, long);
  80213f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802143:	8b 00                	mov    (%rax),%eax
  802145:	83 f8 30             	cmp    $0x30,%eax
  802148:	73 24                	jae    80216e <getint+0x9c>
  80214a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80214e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802152:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802156:	8b 00                	mov    (%rax),%eax
  802158:	89 c0                	mov    %eax,%eax
  80215a:	48 01 d0             	add    %rdx,%rax
  80215d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802161:	8b 12                	mov    (%rdx),%edx
  802163:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802166:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80216a:	89 0a                	mov    %ecx,(%rdx)
  80216c:	eb 17                	jmp    802185 <getint+0xb3>
  80216e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802172:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802176:	48 89 d0             	mov    %rdx,%rax
  802179:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80217d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802181:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802185:	48 8b 00             	mov    (%rax),%rax
  802188:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80218c:	eb 4e                	jmp    8021dc <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80218e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802192:	8b 00                	mov    (%rax),%eax
  802194:	83 f8 30             	cmp    $0x30,%eax
  802197:	73 24                	jae    8021bd <getint+0xeb>
  802199:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80219d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8021a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a5:	8b 00                	mov    (%rax),%eax
  8021a7:	89 c0                	mov    %eax,%eax
  8021a9:	48 01 d0             	add    %rdx,%rax
  8021ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021b0:	8b 12                	mov    (%rdx),%edx
  8021b2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8021b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021b9:	89 0a                	mov    %ecx,(%rdx)
  8021bb:	eb 17                	jmp    8021d4 <getint+0x102>
  8021bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8021c5:	48 89 d0             	mov    %rdx,%rax
  8021c8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8021cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021d0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8021d4:	8b 00                	mov    (%rax),%eax
  8021d6:	48 98                	cltq   
  8021d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8021dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8021e0:	c9                   	leaveq 
  8021e1:	c3                   	retq   

00000000008021e2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8021e2:	55                   	push   %rbp
  8021e3:	48 89 e5             	mov    %rsp,%rbp
  8021e6:	41 54                	push   %r12
  8021e8:	53                   	push   %rbx
  8021e9:	48 83 ec 60          	sub    $0x60,%rsp
  8021ed:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8021f1:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8021f5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8021f9:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8021fd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802201:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802205:	48 8b 0a             	mov    (%rdx),%rcx
  802208:	48 89 08             	mov    %rcx,(%rax)
  80220b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80220f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802213:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802217:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  80221b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80221f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802223:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802227:	0f b6 00             	movzbl (%rax),%eax
  80222a:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  80222d:	eb 29                	jmp    802258 <vprintfmt+0x76>
			if (ch == '\0')
  80222f:	85 db                	test   %ebx,%ebx
  802231:	0f 84 ad 06 00 00    	je     8028e4 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  802237:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80223b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80223f:	48 89 d6             	mov    %rdx,%rsi
  802242:	89 df                	mov    %ebx,%edi
  802244:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  802246:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80224a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80224e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802252:	0f b6 00             	movzbl (%rax),%eax
  802255:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  802258:	83 fb 25             	cmp    $0x25,%ebx
  80225b:	74 05                	je     802262 <vprintfmt+0x80>
  80225d:	83 fb 1b             	cmp    $0x1b,%ebx
  802260:	75 cd                	jne    80222f <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  802262:	83 fb 1b             	cmp    $0x1b,%ebx
  802265:	0f 85 ae 01 00 00    	jne    802419 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  80226b:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802272:	00 00 00 
  802275:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  80227b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80227f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802283:	48 89 d6             	mov    %rdx,%rsi
  802286:	89 df                	mov    %ebx,%edi
  802288:	ff d0                	callq  *%rax
			putch('[', putdat);
  80228a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80228e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802292:	48 89 d6             	mov    %rdx,%rsi
  802295:	bf 5b 00 00 00       	mov    $0x5b,%edi
  80229a:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  80229c:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  8022a2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8022a7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8022ab:	0f b6 00             	movzbl (%rax),%eax
  8022ae:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8022b1:	eb 32                	jmp    8022e5 <vprintfmt+0x103>
					putch(ch, putdat);
  8022b3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8022b7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8022bb:	48 89 d6             	mov    %rdx,%rsi
  8022be:	89 df                	mov    %ebx,%edi
  8022c0:	ff d0                	callq  *%rax
					esc_color *= 10;
  8022c2:	44 89 e0             	mov    %r12d,%eax
  8022c5:	c1 e0 02             	shl    $0x2,%eax
  8022c8:	44 01 e0             	add    %r12d,%eax
  8022cb:	01 c0                	add    %eax,%eax
  8022cd:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  8022d0:	8d 43 d0             	lea    -0x30(%rbx),%eax
  8022d3:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  8022d6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8022db:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8022df:	0f b6 00             	movzbl (%rax),%eax
  8022e2:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8022e5:	83 fb 3b             	cmp    $0x3b,%ebx
  8022e8:	74 05                	je     8022ef <vprintfmt+0x10d>
  8022ea:	83 fb 6d             	cmp    $0x6d,%ebx
  8022ed:	75 c4                	jne    8022b3 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  8022ef:	45 85 e4             	test   %r12d,%r12d
  8022f2:	75 15                	jne    802309 <vprintfmt+0x127>
					color_flag = 0x07;
  8022f4:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  8022fb:	00 00 00 
  8022fe:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  802304:	e9 dc 00 00 00       	jmpq   8023e5 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  802309:	41 83 fc 1d          	cmp    $0x1d,%r12d
  80230d:	7e 69                	jle    802378 <vprintfmt+0x196>
  80230f:	41 83 fc 25          	cmp    $0x25,%r12d
  802313:	7f 63                	jg     802378 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  802315:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  80231c:	00 00 00 
  80231f:	8b 00                	mov    (%rax),%eax
  802321:	25 f8 00 00 00       	and    $0xf8,%eax
  802326:	89 c2                	mov    %eax,%edx
  802328:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  80232f:	00 00 00 
  802332:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  802334:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  802338:	44 89 e0             	mov    %r12d,%eax
  80233b:	83 e0 04             	and    $0x4,%eax
  80233e:	c1 f8 02             	sar    $0x2,%eax
  802341:	89 c2                	mov    %eax,%edx
  802343:	44 89 e0             	mov    %r12d,%eax
  802346:	83 e0 02             	and    $0x2,%eax
  802349:	09 c2                	or     %eax,%edx
  80234b:	44 89 e0             	mov    %r12d,%eax
  80234e:	83 e0 01             	and    $0x1,%eax
  802351:	c1 e0 02             	shl    $0x2,%eax
  802354:	09 c2                	or     %eax,%edx
  802356:	41 89 d4             	mov    %edx,%r12d
  802359:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802360:	00 00 00 
  802363:	8b 00                	mov    (%rax),%eax
  802365:	44 89 e2             	mov    %r12d,%edx
  802368:	09 c2                	or     %eax,%edx
  80236a:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802371:	00 00 00 
  802374:	89 10                	mov    %edx,(%rax)
  802376:	eb 6d                	jmp    8023e5 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  802378:	41 83 fc 27          	cmp    $0x27,%r12d
  80237c:	7e 67                	jle    8023e5 <vprintfmt+0x203>
  80237e:	41 83 fc 2f          	cmp    $0x2f,%r12d
  802382:	7f 61                	jg     8023e5 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  802384:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  80238b:	00 00 00 
  80238e:	8b 00                	mov    (%rax),%eax
  802390:	25 8f 00 00 00       	and    $0x8f,%eax
  802395:	89 c2                	mov    %eax,%edx
  802397:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  80239e:	00 00 00 
  8023a1:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  8023a3:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  8023a7:	44 89 e0             	mov    %r12d,%eax
  8023aa:	83 e0 04             	and    $0x4,%eax
  8023ad:	c1 f8 02             	sar    $0x2,%eax
  8023b0:	89 c2                	mov    %eax,%edx
  8023b2:	44 89 e0             	mov    %r12d,%eax
  8023b5:	83 e0 02             	and    $0x2,%eax
  8023b8:	09 c2                	or     %eax,%edx
  8023ba:	44 89 e0             	mov    %r12d,%eax
  8023bd:	83 e0 01             	and    $0x1,%eax
  8023c0:	c1 e0 06             	shl    $0x6,%eax
  8023c3:	09 c2                	or     %eax,%edx
  8023c5:	41 89 d4             	mov    %edx,%r12d
  8023c8:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  8023cf:	00 00 00 
  8023d2:	8b 00                	mov    (%rax),%eax
  8023d4:	44 89 e2             	mov    %r12d,%edx
  8023d7:	09 c2                	or     %eax,%edx
  8023d9:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  8023e0:	00 00 00 
  8023e3:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  8023e5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8023e9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8023ed:	48 89 d6             	mov    %rdx,%rsi
  8023f0:	89 df                	mov    %ebx,%edi
  8023f2:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  8023f4:	83 fb 6d             	cmp    $0x6d,%ebx
  8023f7:	75 1b                	jne    802414 <vprintfmt+0x232>
					fmt ++;
  8023f9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  8023fe:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  8023ff:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802406:	00 00 00 
  802409:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  80240f:	e9 cb 04 00 00       	jmpq   8028df <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  802414:	e9 83 fe ff ff       	jmpq   80229c <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  802419:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80241d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802424:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80242b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802432:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802439:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80243d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802441:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802445:	0f b6 00             	movzbl (%rax),%eax
  802448:	0f b6 d8             	movzbl %al,%ebx
  80244b:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80244e:	83 f8 55             	cmp    $0x55,%eax
  802451:	0f 87 5a 04 00 00    	ja     8028b1 <vprintfmt+0x6cf>
  802457:	89 c0                	mov    %eax,%eax
  802459:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802460:	00 
  802461:	48 b8 30 39 80 00 00 	movabs $0x803930,%rax
  802468:	00 00 00 
  80246b:	48 01 d0             	add    %rdx,%rax
  80246e:	48 8b 00             	mov    (%rax),%rax
  802471:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  802473:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802477:	eb c0                	jmp    802439 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802479:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80247d:	eb ba                	jmp    802439 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80247f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802486:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802489:	89 d0                	mov    %edx,%eax
  80248b:	c1 e0 02             	shl    $0x2,%eax
  80248e:	01 d0                	add    %edx,%eax
  802490:	01 c0                	add    %eax,%eax
  802492:	01 d8                	add    %ebx,%eax
  802494:	83 e8 30             	sub    $0x30,%eax
  802497:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80249a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80249e:	0f b6 00             	movzbl (%rax),%eax
  8024a1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8024a4:	83 fb 2f             	cmp    $0x2f,%ebx
  8024a7:	7e 0c                	jle    8024b5 <vprintfmt+0x2d3>
  8024a9:	83 fb 39             	cmp    $0x39,%ebx
  8024ac:	7f 07                	jg     8024b5 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8024ae:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8024b3:	eb d1                	jmp    802486 <vprintfmt+0x2a4>
			goto process_precision;
  8024b5:	eb 58                	jmp    80250f <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  8024b7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024ba:	83 f8 30             	cmp    $0x30,%eax
  8024bd:	73 17                	jae    8024d6 <vprintfmt+0x2f4>
  8024bf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024c3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024c6:	89 c0                	mov    %eax,%eax
  8024c8:	48 01 d0             	add    %rdx,%rax
  8024cb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8024ce:	83 c2 08             	add    $0x8,%edx
  8024d1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8024d4:	eb 0f                	jmp    8024e5 <vprintfmt+0x303>
  8024d6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024da:	48 89 d0             	mov    %rdx,%rax
  8024dd:	48 83 c2 08          	add    $0x8,%rdx
  8024e1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8024e5:	8b 00                	mov    (%rax),%eax
  8024e7:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8024ea:	eb 23                	jmp    80250f <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  8024ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8024f0:	79 0c                	jns    8024fe <vprintfmt+0x31c>
				width = 0;
  8024f2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8024f9:	e9 3b ff ff ff       	jmpq   802439 <vprintfmt+0x257>
  8024fe:	e9 36 ff ff ff       	jmpq   802439 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  802503:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80250a:	e9 2a ff ff ff       	jmpq   802439 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  80250f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802513:	79 12                	jns    802527 <vprintfmt+0x345>
				width = precision, precision = -1;
  802515:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802518:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80251b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802522:	e9 12 ff ff ff       	jmpq   802439 <vprintfmt+0x257>
  802527:	e9 0d ff ff ff       	jmpq   802439 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80252c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802530:	e9 04 ff ff ff       	jmpq   802439 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802535:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802538:	83 f8 30             	cmp    $0x30,%eax
  80253b:	73 17                	jae    802554 <vprintfmt+0x372>
  80253d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802541:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802544:	89 c0                	mov    %eax,%eax
  802546:	48 01 d0             	add    %rdx,%rax
  802549:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80254c:	83 c2 08             	add    $0x8,%edx
  80254f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802552:	eb 0f                	jmp    802563 <vprintfmt+0x381>
  802554:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802558:	48 89 d0             	mov    %rdx,%rax
  80255b:	48 83 c2 08          	add    $0x8,%rdx
  80255f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802563:	8b 10                	mov    (%rax),%edx
  802565:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802569:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80256d:	48 89 ce             	mov    %rcx,%rsi
  802570:	89 d7                	mov    %edx,%edi
  802572:	ff d0                	callq  *%rax
			break;
  802574:	e9 66 03 00 00       	jmpq   8028df <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  802579:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80257c:	83 f8 30             	cmp    $0x30,%eax
  80257f:	73 17                	jae    802598 <vprintfmt+0x3b6>
  802581:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802585:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802588:	89 c0                	mov    %eax,%eax
  80258a:	48 01 d0             	add    %rdx,%rax
  80258d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802590:	83 c2 08             	add    $0x8,%edx
  802593:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802596:	eb 0f                	jmp    8025a7 <vprintfmt+0x3c5>
  802598:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80259c:	48 89 d0             	mov    %rdx,%rax
  80259f:	48 83 c2 08          	add    $0x8,%rdx
  8025a3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025a7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8025a9:	85 db                	test   %ebx,%ebx
  8025ab:	79 02                	jns    8025af <vprintfmt+0x3cd>
				err = -err;
  8025ad:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8025af:	83 fb 10             	cmp    $0x10,%ebx
  8025b2:	7f 16                	jg     8025ca <vprintfmt+0x3e8>
  8025b4:	48 b8 80 38 80 00 00 	movabs $0x803880,%rax
  8025bb:	00 00 00 
  8025be:	48 63 d3             	movslq %ebx,%rdx
  8025c1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8025c5:	4d 85 e4             	test   %r12,%r12
  8025c8:	75 2e                	jne    8025f8 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  8025ca:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8025ce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8025d2:	89 d9                	mov    %ebx,%ecx
  8025d4:	48 ba 19 39 80 00 00 	movabs $0x803919,%rdx
  8025db:	00 00 00 
  8025de:	48 89 c7             	mov    %rax,%rdi
  8025e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e6:	49 b8 ed 28 80 00 00 	movabs $0x8028ed,%r8
  8025ed:	00 00 00 
  8025f0:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8025f3:	e9 e7 02 00 00       	jmpq   8028df <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8025f8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8025fc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802600:	4c 89 e1             	mov    %r12,%rcx
  802603:	48 ba 22 39 80 00 00 	movabs $0x803922,%rdx
  80260a:	00 00 00 
  80260d:	48 89 c7             	mov    %rax,%rdi
  802610:	b8 00 00 00 00       	mov    $0x0,%eax
  802615:	49 b8 ed 28 80 00 00 	movabs $0x8028ed,%r8
  80261c:	00 00 00 
  80261f:	41 ff d0             	callq  *%r8
			break;
  802622:	e9 b8 02 00 00       	jmpq   8028df <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  802627:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80262a:	83 f8 30             	cmp    $0x30,%eax
  80262d:	73 17                	jae    802646 <vprintfmt+0x464>
  80262f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802633:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802636:	89 c0                	mov    %eax,%eax
  802638:	48 01 d0             	add    %rdx,%rax
  80263b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80263e:	83 c2 08             	add    $0x8,%edx
  802641:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802644:	eb 0f                	jmp    802655 <vprintfmt+0x473>
  802646:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80264a:	48 89 d0             	mov    %rdx,%rax
  80264d:	48 83 c2 08          	add    $0x8,%rdx
  802651:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802655:	4c 8b 20             	mov    (%rax),%r12
  802658:	4d 85 e4             	test   %r12,%r12
  80265b:	75 0a                	jne    802667 <vprintfmt+0x485>
				p = "(null)";
  80265d:	49 bc 25 39 80 00 00 	movabs $0x803925,%r12
  802664:	00 00 00 
			if (width > 0 && padc != '-')
  802667:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80266b:	7e 3f                	jle    8026ac <vprintfmt+0x4ca>
  80266d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802671:	74 39                	je     8026ac <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  802673:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802676:	48 98                	cltq   
  802678:	48 89 c6             	mov    %rax,%rsi
  80267b:	4c 89 e7             	mov    %r12,%rdi
  80267e:	48 b8 99 2b 80 00 00 	movabs $0x802b99,%rax
  802685:	00 00 00 
  802688:	ff d0                	callq  *%rax
  80268a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80268d:	eb 17                	jmp    8026a6 <vprintfmt+0x4c4>
					putch(padc, putdat);
  80268f:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802693:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802697:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80269b:	48 89 ce             	mov    %rcx,%rsi
  80269e:	89 d7                	mov    %edx,%edi
  8026a0:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8026a2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8026a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026aa:	7f e3                	jg     80268f <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8026ac:	eb 37                	jmp    8026e5 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  8026ae:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8026b2:	74 1e                	je     8026d2 <vprintfmt+0x4f0>
  8026b4:	83 fb 1f             	cmp    $0x1f,%ebx
  8026b7:	7e 05                	jle    8026be <vprintfmt+0x4dc>
  8026b9:	83 fb 7e             	cmp    $0x7e,%ebx
  8026bc:	7e 14                	jle    8026d2 <vprintfmt+0x4f0>
					putch('?', putdat);
  8026be:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8026c2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026c6:	48 89 d6             	mov    %rdx,%rsi
  8026c9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8026ce:	ff d0                	callq  *%rax
  8026d0:	eb 0f                	jmp    8026e1 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  8026d2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8026d6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026da:	48 89 d6             	mov    %rdx,%rsi
  8026dd:	89 df                	mov    %ebx,%edi
  8026df:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8026e1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8026e5:	4c 89 e0             	mov    %r12,%rax
  8026e8:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8026ec:	0f b6 00             	movzbl (%rax),%eax
  8026ef:	0f be d8             	movsbl %al,%ebx
  8026f2:	85 db                	test   %ebx,%ebx
  8026f4:	74 10                	je     802706 <vprintfmt+0x524>
  8026f6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8026fa:	78 b2                	js     8026ae <vprintfmt+0x4cc>
  8026fc:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802700:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802704:	79 a8                	jns    8026ae <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802706:	eb 16                	jmp    80271e <vprintfmt+0x53c>
				putch(' ', putdat);
  802708:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80270c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802710:	48 89 d6             	mov    %rdx,%rsi
  802713:	bf 20 00 00 00       	mov    $0x20,%edi
  802718:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80271a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80271e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802722:	7f e4                	jg     802708 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  802724:	e9 b6 01 00 00       	jmpq   8028df <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  802729:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80272d:	be 03 00 00 00       	mov    $0x3,%esi
  802732:	48 89 c7             	mov    %rax,%rdi
  802735:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  80273c:	00 00 00 
  80273f:	ff d0                	callq  *%rax
  802741:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802749:	48 85 c0             	test   %rax,%rax
  80274c:	79 1d                	jns    80276b <vprintfmt+0x589>
				putch('-', putdat);
  80274e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802752:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802756:	48 89 d6             	mov    %rdx,%rsi
  802759:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80275e:	ff d0                	callq  *%rax
				num = -(long long) num;
  802760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802764:	48 f7 d8             	neg    %rax
  802767:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80276b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802772:	e9 fb 00 00 00       	jmpq   802872 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  802777:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80277b:	be 03 00 00 00       	mov    $0x3,%esi
  802780:	48 89 c7             	mov    %rax,%rdi
  802783:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  80278a:	00 00 00 
  80278d:	ff d0                	callq  *%rax
  80278f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  802793:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80279a:	e9 d3 00 00 00       	jmpq   802872 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  80279f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027a3:	be 03 00 00 00       	mov    $0x3,%esi
  8027a8:	48 89 c7             	mov    %rax,%rdi
  8027ab:	48 b8 d2 20 80 00 00 	movabs $0x8020d2,%rax
  8027b2:	00 00 00 
  8027b5:	ff d0                	callq  *%rax
  8027b7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8027bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027bf:	48 85 c0             	test   %rax,%rax
  8027c2:	79 1d                	jns    8027e1 <vprintfmt+0x5ff>
				putch('-', putdat);
  8027c4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027c8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027cc:	48 89 d6             	mov    %rdx,%rsi
  8027cf:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8027d4:	ff d0                	callq  *%rax
				num = -(long long) num;
  8027d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027da:	48 f7 d8             	neg    %rax
  8027dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  8027e1:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8027e8:	e9 85 00 00 00       	jmpq   802872 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  8027ed:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027f1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027f5:	48 89 d6             	mov    %rdx,%rsi
  8027f8:	bf 30 00 00 00       	mov    $0x30,%edi
  8027fd:	ff d0                	callq  *%rax
			putch('x', putdat);
  8027ff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802803:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802807:	48 89 d6             	mov    %rdx,%rsi
  80280a:	bf 78 00 00 00       	mov    $0x78,%edi
  80280f:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  802811:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802814:	83 f8 30             	cmp    $0x30,%eax
  802817:	73 17                	jae    802830 <vprintfmt+0x64e>
  802819:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80281d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802820:	89 c0                	mov    %eax,%eax
  802822:	48 01 d0             	add    %rdx,%rax
  802825:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802828:	83 c2 08             	add    $0x8,%edx
  80282b:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80282e:	eb 0f                	jmp    80283f <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  802830:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802834:	48 89 d0             	mov    %rdx,%rax
  802837:	48 83 c2 08          	add    $0x8,%rdx
  80283b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80283f:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802842:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  802846:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80284d:	eb 23                	jmp    802872 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80284f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802853:	be 03 00 00 00       	mov    $0x3,%esi
  802858:	48 89 c7             	mov    %rax,%rdi
  80285b:	48 b8 c2 1f 80 00 00 	movabs $0x801fc2,%rax
  802862:	00 00 00 
  802865:	ff d0                	callq  *%rax
  802867:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80286b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  802872:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  802877:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80287a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80287d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802881:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802885:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802889:	45 89 c1             	mov    %r8d,%r9d
  80288c:	41 89 f8             	mov    %edi,%r8d
  80288f:	48 89 c7             	mov    %rax,%rdi
  802892:	48 b8 07 1f 80 00 00 	movabs $0x801f07,%rax
  802899:	00 00 00 
  80289c:	ff d0                	callq  *%rax
			break;
  80289e:	eb 3f                	jmp    8028df <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8028a0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028a4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028a8:	48 89 d6             	mov    %rdx,%rsi
  8028ab:	89 df                	mov    %ebx,%edi
  8028ad:	ff d0                	callq  *%rax
			break;
  8028af:	eb 2e                	jmp    8028df <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8028b1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8028b5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8028b9:	48 89 d6             	mov    %rdx,%rsi
  8028bc:	bf 25 00 00 00       	mov    $0x25,%edi
  8028c1:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8028c3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8028c8:	eb 05                	jmp    8028cf <vprintfmt+0x6ed>
  8028ca:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8028cf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8028d3:	48 83 e8 01          	sub    $0x1,%rax
  8028d7:	0f b6 00             	movzbl (%rax),%eax
  8028da:	3c 25                	cmp    $0x25,%al
  8028dc:	75 ec                	jne    8028ca <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  8028de:	90                   	nop
		}
	}
  8028df:	e9 37 f9 ff ff       	jmpq   80221b <vprintfmt+0x39>
    va_end(aq);
}
  8028e4:	48 83 c4 60          	add    $0x60,%rsp
  8028e8:	5b                   	pop    %rbx
  8028e9:	41 5c                	pop    %r12
  8028eb:	5d                   	pop    %rbp
  8028ec:	c3                   	retq   

00000000008028ed <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8028ed:	55                   	push   %rbp
  8028ee:	48 89 e5             	mov    %rsp,%rbp
  8028f1:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8028f8:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8028ff:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802906:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80290d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802914:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80291b:	84 c0                	test   %al,%al
  80291d:	74 20                	je     80293f <printfmt+0x52>
  80291f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802923:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802927:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80292b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80292f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802933:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802937:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80293b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80293f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802946:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80294d:	00 00 00 
  802950:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  802957:	00 00 00 
  80295a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80295e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  802965:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80296c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  802973:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80297a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802981:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  802988:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80298f:	48 89 c7             	mov    %rax,%rdi
  802992:	48 b8 e2 21 80 00 00 	movabs $0x8021e2,%rax
  802999:	00 00 00 
  80299c:	ff d0                	callq  *%rax
	va_end(ap);
}
  80299e:	c9                   	leaveq 
  80299f:	c3                   	retq   

00000000008029a0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8029a0:	55                   	push   %rbp
  8029a1:	48 89 e5             	mov    %rsp,%rbp
  8029a4:	48 83 ec 10          	sub    $0x10,%rsp
  8029a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8029ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8029af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b3:	8b 40 10             	mov    0x10(%rax),%eax
  8029b6:	8d 50 01             	lea    0x1(%rax),%edx
  8029b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029bd:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8029c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029c4:	48 8b 10             	mov    (%rax),%rdx
  8029c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029cb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8029cf:	48 39 c2             	cmp    %rax,%rdx
  8029d2:	73 17                	jae    8029eb <sprintputch+0x4b>
		*b->buf++ = ch;
  8029d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029d8:	48 8b 00             	mov    (%rax),%rax
  8029db:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8029df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029e3:	48 89 0a             	mov    %rcx,(%rdx)
  8029e6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8029e9:	88 10                	mov    %dl,(%rax)
}
  8029eb:	c9                   	leaveq 
  8029ec:	c3                   	retq   

00000000008029ed <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8029ed:	55                   	push   %rbp
  8029ee:	48 89 e5             	mov    %rsp,%rbp
  8029f1:	48 83 ec 50          	sub    $0x50,%rsp
  8029f5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8029f9:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8029fc:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802a00:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802a04:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802a08:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802a0c:	48 8b 0a             	mov    (%rdx),%rcx
  802a0f:	48 89 08             	mov    %rcx,(%rax)
  802a12:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a16:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a1a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a1e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802a22:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a26:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802a2a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802a2d:	48 98                	cltq   
  802a2f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802a33:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a37:	48 01 d0             	add    %rdx,%rax
  802a3a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802a3e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802a45:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802a4a:	74 06                	je     802a52 <vsnprintf+0x65>
  802a4c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802a50:	7f 07                	jg     802a59 <vsnprintf+0x6c>
		return -E_INVAL;
  802a52:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a57:	eb 2f                	jmp    802a88 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802a59:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802a5d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802a61:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802a65:	48 89 c6             	mov    %rax,%rsi
  802a68:	48 bf a0 29 80 00 00 	movabs $0x8029a0,%rdi
  802a6f:	00 00 00 
  802a72:	48 b8 e2 21 80 00 00 	movabs $0x8021e2,%rax
  802a79:	00 00 00 
  802a7c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802a7e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a82:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802a85:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802a88:	c9                   	leaveq 
  802a89:	c3                   	retq   

0000000000802a8a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802a8a:	55                   	push   %rbp
  802a8b:	48 89 e5             	mov    %rsp,%rbp
  802a8e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802a95:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802a9c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802aa2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802aa9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802ab0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802ab7:	84 c0                	test   %al,%al
  802ab9:	74 20                	je     802adb <snprintf+0x51>
  802abb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802abf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802ac3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802ac7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802acb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802acf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802ad3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802ad7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802adb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802ae2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802ae9:	00 00 00 
  802aec:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802af3:	00 00 00 
  802af6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802afa:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802b01:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802b08:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802b0f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802b16:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802b1d:	48 8b 0a             	mov    (%rdx),%rcx
  802b20:	48 89 08             	mov    %rcx,(%rax)
  802b23:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802b27:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802b2b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802b2f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802b33:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802b3a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802b41:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802b47:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802b4e:	48 89 c7             	mov    %rax,%rdi
  802b51:	48 b8 ed 29 80 00 00 	movabs $0x8029ed,%rax
  802b58:	00 00 00 
  802b5b:	ff d0                	callq  *%rax
  802b5d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802b63:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802b69:	c9                   	leaveq 
  802b6a:	c3                   	retq   

0000000000802b6b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802b6b:	55                   	push   %rbp
  802b6c:	48 89 e5             	mov    %rsp,%rbp
  802b6f:	48 83 ec 18          	sub    $0x18,%rsp
  802b73:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802b77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b7e:	eb 09                	jmp    802b89 <strlen+0x1e>
		n++;
  802b80:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802b84:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802b89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b8d:	0f b6 00             	movzbl (%rax),%eax
  802b90:	84 c0                	test   %al,%al
  802b92:	75 ec                	jne    802b80 <strlen+0x15>
		n++;
	return n;
  802b94:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b97:	c9                   	leaveq 
  802b98:	c3                   	retq   

0000000000802b99 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802b99:	55                   	push   %rbp
  802b9a:	48 89 e5             	mov    %rsp,%rbp
  802b9d:	48 83 ec 20          	sub    $0x20,%rsp
  802ba1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ba5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802ba9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bb0:	eb 0e                	jmp    802bc0 <strnlen+0x27>
		n++;
  802bb2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802bb6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802bbb:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802bc0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802bc5:	74 0b                	je     802bd2 <strnlen+0x39>
  802bc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bcb:	0f b6 00             	movzbl (%rax),%eax
  802bce:	84 c0                	test   %al,%al
  802bd0:	75 e0                	jne    802bb2 <strnlen+0x19>
		n++;
	return n;
  802bd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bd5:	c9                   	leaveq 
  802bd6:	c3                   	retq   

0000000000802bd7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802bd7:	55                   	push   %rbp
  802bd8:	48 89 e5             	mov    %rsp,%rbp
  802bdb:	48 83 ec 20          	sub    $0x20,%rsp
  802bdf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802be3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802be7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802beb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802bef:	90                   	nop
  802bf0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802bf8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802bfc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c00:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802c04:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802c08:	0f b6 12             	movzbl (%rdx),%edx
  802c0b:	88 10                	mov    %dl,(%rax)
  802c0d:	0f b6 00             	movzbl (%rax),%eax
  802c10:	84 c0                	test   %al,%al
  802c12:	75 dc                	jne    802bf0 <strcpy+0x19>
		/* do nothing */;
	return ret;
  802c14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802c18:	c9                   	leaveq 
  802c19:	c3                   	retq   

0000000000802c1a <strcat>:

char *
strcat(char *dst, const char *src)
{
  802c1a:	55                   	push   %rbp
  802c1b:	48 89 e5             	mov    %rsp,%rbp
  802c1e:	48 83 ec 20          	sub    $0x20,%rsp
  802c22:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c26:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802c2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c2e:	48 89 c7             	mov    %rax,%rdi
  802c31:	48 b8 6b 2b 80 00 00 	movabs $0x802b6b,%rax
  802c38:	00 00 00 
  802c3b:	ff d0                	callq  *%rax
  802c3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802c40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c43:	48 63 d0             	movslq %eax,%rdx
  802c46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c4a:	48 01 c2             	add    %rax,%rdx
  802c4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c51:	48 89 c6             	mov    %rax,%rsi
  802c54:	48 89 d7             	mov    %rdx,%rdi
  802c57:	48 b8 d7 2b 80 00 00 	movabs $0x802bd7,%rax
  802c5e:	00 00 00 
  802c61:	ff d0                	callq  *%rax
	return dst;
  802c63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802c67:	c9                   	leaveq 
  802c68:	c3                   	retq   

0000000000802c69 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802c69:	55                   	push   %rbp
  802c6a:	48 89 e5             	mov    %rsp,%rbp
  802c6d:	48 83 ec 28          	sub    $0x28,%rsp
  802c71:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c75:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c79:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802c7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c81:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802c85:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802c8c:	00 
  802c8d:	eb 2a                	jmp    802cb9 <strncpy+0x50>
		*dst++ = *src;
  802c8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c93:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c97:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c9b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c9f:	0f b6 12             	movzbl (%rdx),%edx
  802ca2:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802ca4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ca8:	0f b6 00             	movzbl (%rax),%eax
  802cab:	84 c0                	test   %al,%al
  802cad:	74 05                	je     802cb4 <strncpy+0x4b>
			src++;
  802caf:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802cb4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802cb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cbd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802cc1:	72 cc                	jb     802c8f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802cc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802cc7:	c9                   	leaveq 
  802cc8:	c3                   	retq   

0000000000802cc9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802cc9:	55                   	push   %rbp
  802cca:	48 89 e5             	mov    %rsp,%rbp
  802ccd:	48 83 ec 28          	sub    $0x28,%rsp
  802cd1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cd5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cd9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802cdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802ce5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802cea:	74 3d                	je     802d29 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802cec:	eb 1d                	jmp    802d0b <strlcpy+0x42>
			*dst++ = *src++;
  802cee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802cf6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802cfa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cfe:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802d02:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802d06:	0f b6 12             	movzbl (%rdx),%edx
  802d09:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802d0b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802d10:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d15:	74 0b                	je     802d22 <strlcpy+0x59>
  802d17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d1b:	0f b6 00             	movzbl (%rax),%eax
  802d1e:	84 c0                	test   %al,%al
  802d20:	75 cc                	jne    802cee <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802d22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d26:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802d29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d31:	48 29 c2             	sub    %rax,%rdx
  802d34:	48 89 d0             	mov    %rdx,%rax
}
  802d37:	c9                   	leaveq 
  802d38:	c3                   	retq   

0000000000802d39 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802d39:	55                   	push   %rbp
  802d3a:	48 89 e5             	mov    %rsp,%rbp
  802d3d:	48 83 ec 10          	sub    $0x10,%rsp
  802d41:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d45:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802d49:	eb 0a                	jmp    802d55 <strcmp+0x1c>
		p++, q++;
  802d4b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d50:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802d55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d59:	0f b6 00             	movzbl (%rax),%eax
  802d5c:	84 c0                	test   %al,%al
  802d5e:	74 12                	je     802d72 <strcmp+0x39>
  802d60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d64:	0f b6 10             	movzbl (%rax),%edx
  802d67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d6b:	0f b6 00             	movzbl (%rax),%eax
  802d6e:	38 c2                	cmp    %al,%dl
  802d70:	74 d9                	je     802d4b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802d72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d76:	0f b6 00             	movzbl (%rax),%eax
  802d79:	0f b6 d0             	movzbl %al,%edx
  802d7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d80:	0f b6 00             	movzbl (%rax),%eax
  802d83:	0f b6 c0             	movzbl %al,%eax
  802d86:	29 c2                	sub    %eax,%edx
  802d88:	89 d0                	mov    %edx,%eax
}
  802d8a:	c9                   	leaveq 
  802d8b:	c3                   	retq   

0000000000802d8c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802d8c:	55                   	push   %rbp
  802d8d:	48 89 e5             	mov    %rsp,%rbp
  802d90:	48 83 ec 18          	sub    $0x18,%rsp
  802d94:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d98:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d9c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802da0:	eb 0f                	jmp    802db1 <strncmp+0x25>
		n--, p++, q++;
  802da2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802da7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802dac:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802db1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802db6:	74 1d                	je     802dd5 <strncmp+0x49>
  802db8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dbc:	0f b6 00             	movzbl (%rax),%eax
  802dbf:	84 c0                	test   %al,%al
  802dc1:	74 12                	je     802dd5 <strncmp+0x49>
  802dc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dc7:	0f b6 10             	movzbl (%rax),%edx
  802dca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dce:	0f b6 00             	movzbl (%rax),%eax
  802dd1:	38 c2                	cmp    %al,%dl
  802dd3:	74 cd                	je     802da2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802dd5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802dda:	75 07                	jne    802de3 <strncmp+0x57>
		return 0;
  802ddc:	b8 00 00 00 00       	mov    $0x0,%eax
  802de1:	eb 18                	jmp    802dfb <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802de3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802de7:	0f b6 00             	movzbl (%rax),%eax
  802dea:	0f b6 d0             	movzbl %al,%edx
  802ded:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df1:	0f b6 00             	movzbl (%rax),%eax
  802df4:	0f b6 c0             	movzbl %al,%eax
  802df7:	29 c2                	sub    %eax,%edx
  802df9:	89 d0                	mov    %edx,%eax
}
  802dfb:	c9                   	leaveq 
  802dfc:	c3                   	retq   

0000000000802dfd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802dfd:	55                   	push   %rbp
  802dfe:	48 89 e5             	mov    %rsp,%rbp
  802e01:	48 83 ec 0c          	sub    $0xc,%rsp
  802e05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e09:	89 f0                	mov    %esi,%eax
  802e0b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e0e:	eb 17                	jmp    802e27 <strchr+0x2a>
		if (*s == c)
  802e10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e14:	0f b6 00             	movzbl (%rax),%eax
  802e17:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802e1a:	75 06                	jne    802e22 <strchr+0x25>
			return (char *) s;
  802e1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e20:	eb 15                	jmp    802e37 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802e22:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e2b:	0f b6 00             	movzbl (%rax),%eax
  802e2e:	84 c0                	test   %al,%al
  802e30:	75 de                	jne    802e10 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802e32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e37:	c9                   	leaveq 
  802e38:	c3                   	retq   

0000000000802e39 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802e39:	55                   	push   %rbp
  802e3a:	48 89 e5             	mov    %rsp,%rbp
  802e3d:	48 83 ec 0c          	sub    $0xc,%rsp
  802e41:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e45:	89 f0                	mov    %esi,%eax
  802e47:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e4a:	eb 13                	jmp    802e5f <strfind+0x26>
		if (*s == c)
  802e4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e50:	0f b6 00             	movzbl (%rax),%eax
  802e53:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802e56:	75 02                	jne    802e5a <strfind+0x21>
			break;
  802e58:	eb 10                	jmp    802e6a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802e5a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e63:	0f b6 00             	movzbl (%rax),%eax
  802e66:	84 c0                	test   %al,%al
  802e68:	75 e2                	jne    802e4c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802e6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e6e:	c9                   	leaveq 
  802e6f:	c3                   	retq   

0000000000802e70 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802e70:	55                   	push   %rbp
  802e71:	48 89 e5             	mov    %rsp,%rbp
  802e74:	48 83 ec 18          	sub    $0x18,%rsp
  802e78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e7c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802e7f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802e83:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e88:	75 06                	jne    802e90 <memset+0x20>
		return v;
  802e8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e8e:	eb 69                	jmp    802ef9 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802e90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e94:	83 e0 03             	and    $0x3,%eax
  802e97:	48 85 c0             	test   %rax,%rax
  802e9a:	75 48                	jne    802ee4 <memset+0x74>
  802e9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea0:	83 e0 03             	and    $0x3,%eax
  802ea3:	48 85 c0             	test   %rax,%rax
  802ea6:	75 3c                	jne    802ee4 <memset+0x74>
		c &= 0xFF;
  802ea8:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802eaf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802eb2:	c1 e0 18             	shl    $0x18,%eax
  802eb5:	89 c2                	mov    %eax,%edx
  802eb7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802eba:	c1 e0 10             	shl    $0x10,%eax
  802ebd:	09 c2                	or     %eax,%edx
  802ebf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ec2:	c1 e0 08             	shl    $0x8,%eax
  802ec5:	09 d0                	or     %edx,%eax
  802ec7:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  802eca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ece:	48 c1 e8 02          	shr    $0x2,%rax
  802ed2:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802ed5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ed9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802edc:	48 89 d7             	mov    %rdx,%rdi
  802edf:	fc                   	cld    
  802ee0:	f3 ab                	rep stos %eax,%es:(%rdi)
  802ee2:	eb 11                	jmp    802ef5 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802ee4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ee8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802eeb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802eef:	48 89 d7             	mov    %rdx,%rdi
  802ef2:	fc                   	cld    
  802ef3:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  802ef5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802ef9:	c9                   	leaveq 
  802efa:	c3                   	retq   

0000000000802efb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802efb:	55                   	push   %rbp
  802efc:	48 89 e5             	mov    %rsp,%rbp
  802eff:	48 83 ec 28          	sub    $0x28,%rsp
  802f03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f0b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802f0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802f17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802f1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f23:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f27:	0f 83 88 00 00 00    	jae    802fb5 <memmove+0xba>
  802f2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f31:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f35:	48 01 d0             	add    %rdx,%rax
  802f38:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f3c:	76 77                	jbe    802fb5 <memmove+0xba>
		s += n;
  802f3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f42:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802f46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f4a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802f4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f52:	83 e0 03             	and    $0x3,%eax
  802f55:	48 85 c0             	test   %rax,%rax
  802f58:	75 3b                	jne    802f95 <memmove+0x9a>
  802f5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f5e:	83 e0 03             	and    $0x3,%eax
  802f61:	48 85 c0             	test   %rax,%rax
  802f64:	75 2f                	jne    802f95 <memmove+0x9a>
  802f66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f6a:	83 e0 03             	and    $0x3,%eax
  802f6d:	48 85 c0             	test   %rax,%rax
  802f70:	75 23                	jne    802f95 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802f72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f76:	48 83 e8 04          	sub    $0x4,%rax
  802f7a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f7e:	48 83 ea 04          	sub    $0x4,%rdx
  802f82:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802f86:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802f8a:	48 89 c7             	mov    %rax,%rdi
  802f8d:	48 89 d6             	mov    %rdx,%rsi
  802f90:	fd                   	std    
  802f91:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802f93:	eb 1d                	jmp    802fb2 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802f95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f99:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802f9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fa1:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802fa5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fa9:	48 89 d7             	mov    %rdx,%rdi
  802fac:	48 89 c1             	mov    %rax,%rcx
  802faf:	fd                   	std    
  802fb0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802fb2:	fc                   	cld    
  802fb3:	eb 57                	jmp    80300c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802fb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fb9:	83 e0 03             	and    $0x3,%eax
  802fbc:	48 85 c0             	test   %rax,%rax
  802fbf:	75 36                	jne    802ff7 <memmove+0xfc>
  802fc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc5:	83 e0 03             	and    $0x3,%eax
  802fc8:	48 85 c0             	test   %rax,%rax
  802fcb:	75 2a                	jne    802ff7 <memmove+0xfc>
  802fcd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fd1:	83 e0 03             	and    $0x3,%eax
  802fd4:	48 85 c0             	test   %rax,%rax
  802fd7:	75 1e                	jne    802ff7 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802fd9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fdd:	48 c1 e8 02          	shr    $0x2,%rax
  802fe1:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  802fe4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fec:	48 89 c7             	mov    %rax,%rdi
  802fef:	48 89 d6             	mov    %rdx,%rsi
  802ff2:	fc                   	cld    
  802ff3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802ff5:	eb 15                	jmp    80300c <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802ff7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ffb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fff:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803003:	48 89 c7             	mov    %rax,%rdi
  803006:	48 89 d6             	mov    %rdx,%rsi
  803009:	fc                   	cld    
  80300a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80300c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803010:	c9                   	leaveq 
  803011:	c3                   	retq   

0000000000803012 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  803012:	55                   	push   %rbp
  803013:	48 89 e5             	mov    %rsp,%rbp
  803016:	48 83 ec 18          	sub    $0x18,%rsp
  80301a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80301e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803022:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803026:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80302a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80302e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803032:	48 89 ce             	mov    %rcx,%rsi
  803035:	48 89 c7             	mov    %rax,%rdi
  803038:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  80303f:	00 00 00 
  803042:	ff d0                	callq  *%rax
}
  803044:	c9                   	leaveq 
  803045:	c3                   	retq   

0000000000803046 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  803046:	55                   	push   %rbp
  803047:	48 89 e5             	mov    %rsp,%rbp
  80304a:	48 83 ec 28          	sub    $0x28,%rsp
  80304e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803052:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803056:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80305a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80305e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  803062:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803066:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80306a:	eb 36                	jmp    8030a2 <memcmp+0x5c>
		if (*s1 != *s2)
  80306c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803070:	0f b6 10             	movzbl (%rax),%edx
  803073:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803077:	0f b6 00             	movzbl (%rax),%eax
  80307a:	38 c2                	cmp    %al,%dl
  80307c:	74 1a                	je     803098 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80307e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803082:	0f b6 00             	movzbl (%rax),%eax
  803085:	0f b6 d0             	movzbl %al,%edx
  803088:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80308c:	0f b6 00             	movzbl (%rax),%eax
  80308f:	0f b6 c0             	movzbl %al,%eax
  803092:	29 c2                	sub    %eax,%edx
  803094:	89 d0                	mov    %edx,%eax
  803096:	eb 20                	jmp    8030b8 <memcmp+0x72>
		s1++, s2++;
  803098:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80309d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8030a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030a6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8030aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8030ae:	48 85 c0             	test   %rax,%rax
  8030b1:	75 b9                	jne    80306c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8030b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030b8:	c9                   	leaveq 
  8030b9:	c3                   	retq   

00000000008030ba <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8030ba:	55                   	push   %rbp
  8030bb:	48 89 e5             	mov    %rsp,%rbp
  8030be:	48 83 ec 28          	sub    $0x28,%rsp
  8030c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030c6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8030c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8030cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030d5:	48 01 d0             	add    %rdx,%rax
  8030d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8030dc:	eb 15                	jmp    8030f3 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8030de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e2:	0f b6 10             	movzbl (%rax),%edx
  8030e5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8030e8:	38 c2                	cmp    %al,%dl
  8030ea:	75 02                	jne    8030ee <memfind+0x34>
			break;
  8030ec:	eb 0f                	jmp    8030fd <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8030ee:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8030f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f7:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8030fb:	72 e1                	jb     8030de <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8030fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803101:	c9                   	leaveq 
  803102:	c3                   	retq   

0000000000803103 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  803103:	55                   	push   %rbp
  803104:	48 89 e5             	mov    %rsp,%rbp
  803107:	48 83 ec 34          	sub    $0x34,%rsp
  80310b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80310f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803113:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803116:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80311d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803124:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803125:	eb 05                	jmp    80312c <strtol+0x29>
		s++;
  803127:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80312c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803130:	0f b6 00             	movzbl (%rax),%eax
  803133:	3c 20                	cmp    $0x20,%al
  803135:	74 f0                	je     803127 <strtol+0x24>
  803137:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80313b:	0f b6 00             	movzbl (%rax),%eax
  80313e:	3c 09                	cmp    $0x9,%al
  803140:	74 e5                	je     803127 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803142:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803146:	0f b6 00             	movzbl (%rax),%eax
  803149:	3c 2b                	cmp    $0x2b,%al
  80314b:	75 07                	jne    803154 <strtol+0x51>
		s++;
  80314d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803152:	eb 17                	jmp    80316b <strtol+0x68>
	else if (*s == '-')
  803154:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803158:	0f b6 00             	movzbl (%rax),%eax
  80315b:	3c 2d                	cmp    $0x2d,%al
  80315d:	75 0c                	jne    80316b <strtol+0x68>
		s++, neg = 1;
  80315f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803164:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80316b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80316f:	74 06                	je     803177 <strtol+0x74>
  803171:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  803175:	75 28                	jne    80319f <strtol+0x9c>
  803177:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80317b:	0f b6 00             	movzbl (%rax),%eax
  80317e:	3c 30                	cmp    $0x30,%al
  803180:	75 1d                	jne    80319f <strtol+0x9c>
  803182:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803186:	48 83 c0 01          	add    $0x1,%rax
  80318a:	0f b6 00             	movzbl (%rax),%eax
  80318d:	3c 78                	cmp    $0x78,%al
  80318f:	75 0e                	jne    80319f <strtol+0x9c>
		s += 2, base = 16;
  803191:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  803196:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80319d:	eb 2c                	jmp    8031cb <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80319f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031a3:	75 19                	jne    8031be <strtol+0xbb>
  8031a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031a9:	0f b6 00             	movzbl (%rax),%eax
  8031ac:	3c 30                	cmp    $0x30,%al
  8031ae:	75 0e                	jne    8031be <strtol+0xbb>
		s++, base = 8;
  8031b0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031b5:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8031bc:	eb 0d                	jmp    8031cb <strtol+0xc8>
	else if (base == 0)
  8031be:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031c2:	75 07                	jne    8031cb <strtol+0xc8>
		base = 10;
  8031c4:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8031cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031cf:	0f b6 00             	movzbl (%rax),%eax
  8031d2:	3c 2f                	cmp    $0x2f,%al
  8031d4:	7e 1d                	jle    8031f3 <strtol+0xf0>
  8031d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031da:	0f b6 00             	movzbl (%rax),%eax
  8031dd:	3c 39                	cmp    $0x39,%al
  8031df:	7f 12                	jg     8031f3 <strtol+0xf0>
			dig = *s - '0';
  8031e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031e5:	0f b6 00             	movzbl (%rax),%eax
  8031e8:	0f be c0             	movsbl %al,%eax
  8031eb:	83 e8 30             	sub    $0x30,%eax
  8031ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031f1:	eb 4e                	jmp    803241 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8031f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031f7:	0f b6 00             	movzbl (%rax),%eax
  8031fa:	3c 60                	cmp    $0x60,%al
  8031fc:	7e 1d                	jle    80321b <strtol+0x118>
  8031fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803202:	0f b6 00             	movzbl (%rax),%eax
  803205:	3c 7a                	cmp    $0x7a,%al
  803207:	7f 12                	jg     80321b <strtol+0x118>
			dig = *s - 'a' + 10;
  803209:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80320d:	0f b6 00             	movzbl (%rax),%eax
  803210:	0f be c0             	movsbl %al,%eax
  803213:	83 e8 57             	sub    $0x57,%eax
  803216:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803219:	eb 26                	jmp    803241 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80321b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80321f:	0f b6 00             	movzbl (%rax),%eax
  803222:	3c 40                	cmp    $0x40,%al
  803224:	7e 48                	jle    80326e <strtol+0x16b>
  803226:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80322a:	0f b6 00             	movzbl (%rax),%eax
  80322d:	3c 5a                	cmp    $0x5a,%al
  80322f:	7f 3d                	jg     80326e <strtol+0x16b>
			dig = *s - 'A' + 10;
  803231:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803235:	0f b6 00             	movzbl (%rax),%eax
  803238:	0f be c0             	movsbl %al,%eax
  80323b:	83 e8 37             	sub    $0x37,%eax
  80323e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803241:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803244:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803247:	7c 02                	jl     80324b <strtol+0x148>
			break;
  803249:	eb 23                	jmp    80326e <strtol+0x16b>
		s++, val = (val * base) + dig;
  80324b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803250:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803253:	48 98                	cltq   
  803255:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80325a:	48 89 c2             	mov    %rax,%rdx
  80325d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803260:	48 98                	cltq   
  803262:	48 01 d0             	add    %rdx,%rax
  803265:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  803269:	e9 5d ff ff ff       	jmpq   8031cb <strtol+0xc8>

	if (endptr)
  80326e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  803273:	74 0b                	je     803280 <strtol+0x17d>
		*endptr = (char *) s;
  803275:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803279:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80327d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  803280:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803284:	74 09                	je     80328f <strtol+0x18c>
  803286:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80328a:	48 f7 d8             	neg    %rax
  80328d:	eb 04                	jmp    803293 <strtol+0x190>
  80328f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803293:	c9                   	leaveq 
  803294:	c3                   	retq   

0000000000803295 <strstr>:

char * strstr(const char *in, const char *str)
{
  803295:	55                   	push   %rbp
  803296:	48 89 e5             	mov    %rsp,%rbp
  803299:	48 83 ec 30          	sub    $0x30,%rsp
  80329d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032a1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8032a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032a9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8032ad:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8032b1:	0f b6 00             	movzbl (%rax),%eax
  8032b4:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8032b7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8032bb:	75 06                	jne    8032c3 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8032bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032c1:	eb 6b                	jmp    80332e <strstr+0x99>

    len = strlen(str);
  8032c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032c7:	48 89 c7             	mov    %rax,%rdi
  8032ca:	48 b8 6b 2b 80 00 00 	movabs $0x802b6b,%rax
  8032d1:	00 00 00 
  8032d4:	ff d0                	callq  *%rax
  8032d6:	48 98                	cltq   
  8032d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8032dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032e0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8032e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8032e8:	0f b6 00             	movzbl (%rax),%eax
  8032eb:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8032ee:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8032f2:	75 07                	jne    8032fb <strstr+0x66>
                return (char *) 0;
  8032f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f9:	eb 33                	jmp    80332e <strstr+0x99>
        } while (sc != c);
  8032fb:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8032ff:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803302:	75 d8                	jne    8032dc <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  803304:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803308:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80330c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803310:	48 89 ce             	mov    %rcx,%rsi
  803313:	48 89 c7             	mov    %rax,%rdi
  803316:	48 b8 8c 2d 80 00 00 	movabs $0x802d8c,%rax
  80331d:	00 00 00 
  803320:	ff d0                	callq  *%rax
  803322:	85 c0                	test   %eax,%eax
  803324:	75 b6                	jne    8032dc <strstr+0x47>

    return (char *) (in - 1);
  803326:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80332a:	48 83 e8 01          	sub    $0x1,%rax
}
  80332e:	c9                   	leaveq 
  80332f:	c3                   	retq   

0000000000803330 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803330:	55                   	push   %rbp
  803331:	48 89 e5             	mov    %rsp,%rbp
  803334:	48 83 ec 10          	sub    $0x10,%rsp
  803338:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  80333c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803343:	00 00 00 
  803346:	48 8b 00             	mov    (%rax),%rax
  803349:	48 85 c0             	test   %rax,%rax
  80334c:	75 3a                	jne    803388 <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  80334e:	ba 07 00 00 00       	mov    $0x7,%edx
  803353:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803358:	bf 00 00 00 00       	mov    $0x0,%edi
  80335d:	48 b8 03 03 80 00 00 	movabs $0x800303,%rax
  803364:	00 00 00 
  803367:	ff d0                	callq  *%rax
  803369:	85 c0                	test   %eax,%eax
  80336b:	75 1b                	jne    803388 <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  80336d:	48 be 70 05 80 00 00 	movabs $0x800570,%rsi
  803374:	00 00 00 
  803377:	bf 00 00 00 00       	mov    $0x0,%edi
  80337c:	48 b8 8d 04 80 00 00 	movabs $0x80048d,%rax
  803383:	00 00 00 
  803386:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803388:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80338f:	00 00 00 
  803392:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803396:	48 89 10             	mov    %rdx,(%rax)
}
  803399:	c9                   	leaveq 
  80339a:	c3                   	retq   

000000000080339b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80339b:	55                   	push   %rbp
  80339c:	48 89 e5             	mov    %rsp,%rbp
  80339f:	48 83 ec 30          	sub    $0x30,%rsp
  8033a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8033af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8033b7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8033bc:	75 0e                	jne    8033cc <ipc_recv+0x31>
		page = (void *)KERNBASE;
  8033be:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8033c5:	00 00 00 
  8033c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  8033cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033d0:	48 89 c7             	mov    %rax,%rdi
  8033d3:	48 b8 2c 05 80 00 00 	movabs $0x80052c,%rax
  8033da:	00 00 00 
  8033dd:	ff d0                	callq  *%rax
  8033df:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8033e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033e6:	79 27                	jns    80340f <ipc_recv+0x74>
		if (from_env_store != NULL)
  8033e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033ed:	74 0a                	je     8033f9 <ipc_recv+0x5e>
			*from_env_store = 0;
  8033ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  8033f9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033fe:	74 0a                	je     80340a <ipc_recv+0x6f>
			*perm_store = 0;
  803400:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803404:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  80340a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80340d:	eb 53                	jmp    803462 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  80340f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803414:	74 19                	je     80342f <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  803416:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80341d:	00 00 00 
  803420:	48 8b 00             	mov    (%rax),%rax
  803423:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803429:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80342d:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  80342f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803434:	74 19                	je     80344f <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803436:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80343d:	00 00 00 
  803440:	48 8b 00             	mov    (%rax),%rax
  803443:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803449:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80344d:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  80344f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803456:	00 00 00 
  803459:	48 8b 00             	mov    (%rax),%rax
  80345c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803462:	c9                   	leaveq 
  803463:	c3                   	retq   

0000000000803464 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803464:	55                   	push   %rbp
  803465:	48 89 e5             	mov    %rsp,%rbp
  803468:	48 83 ec 30          	sub    $0x30,%rsp
  80346c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80346f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803472:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803476:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803479:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80347d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803481:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803486:	75 10                	jne    803498 <ipc_send+0x34>
		page = (void *)KERNBASE;
  803488:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  80348f:	00 00 00 
  803492:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803496:	eb 0e                	jmp    8034a6 <ipc_send+0x42>
  803498:	eb 0c                	jmp    8034a6 <ipc_send+0x42>
		sys_yield();
  80349a:	48 b8 c5 02 80 00 00 	movabs $0x8002c5,%rax
  8034a1:	00 00 00 
  8034a4:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  8034a6:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8034a9:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8034ac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8034b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034b3:	89 c7                	mov    %eax,%edi
  8034b5:	48 b8 d7 04 80 00 00 	movabs $0x8004d7,%rax
  8034bc:	00 00 00 
  8034bf:	ff d0                	callq  *%rax
  8034c1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8034c4:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  8034c8:	74 d0                	je     80349a <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  8034ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8034ce:	74 2a                	je     8034fa <ipc_send+0x96>
		panic("error on ipc send procedure");
  8034d0:	48 ba e0 3b 80 00 00 	movabs $0x803be0,%rdx
  8034d7:	00 00 00 
  8034da:	be 49 00 00 00       	mov    $0x49,%esi
  8034df:	48 bf fc 3b 80 00 00 	movabs $0x803bfc,%rdi
  8034e6:	00 00 00 
  8034e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ee:	48 b9 f6 1b 80 00 00 	movabs $0x801bf6,%rcx
  8034f5:	00 00 00 
  8034f8:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  8034fa:	c9                   	leaveq 
  8034fb:	c3                   	retq   

00000000008034fc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8034fc:	55                   	push   %rbp
  8034fd:	48 89 e5             	mov    %rsp,%rbp
  803500:	48 83 ec 14          	sub    $0x14,%rsp
  803504:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803507:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80350e:	eb 5e                	jmp    80356e <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803510:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803517:	00 00 00 
  80351a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80351d:	48 63 d0             	movslq %eax,%rdx
  803520:	48 89 d0             	mov    %rdx,%rax
  803523:	48 c1 e0 03          	shl    $0x3,%rax
  803527:	48 01 d0             	add    %rdx,%rax
  80352a:	48 c1 e0 05          	shl    $0x5,%rax
  80352e:	48 01 c8             	add    %rcx,%rax
  803531:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803537:	8b 00                	mov    (%rax),%eax
  803539:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80353c:	75 2c                	jne    80356a <ipc_find_env+0x6e>
			return envs[i].env_id;
  80353e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803545:	00 00 00 
  803548:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354b:	48 63 d0             	movslq %eax,%rdx
  80354e:	48 89 d0             	mov    %rdx,%rax
  803551:	48 c1 e0 03          	shl    $0x3,%rax
  803555:	48 01 d0             	add    %rdx,%rax
  803558:	48 c1 e0 05          	shl    $0x5,%rax
  80355c:	48 01 c8             	add    %rcx,%rax
  80355f:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803565:	8b 40 08             	mov    0x8(%rax),%eax
  803568:	eb 12                	jmp    80357c <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80356a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80356e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803575:	7e 99                	jle    803510 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803577:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80357c:	c9                   	leaveq 
  80357d:	c3                   	retq   

000000000080357e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80357e:	55                   	push   %rbp
  80357f:	48 89 e5             	mov    %rsp,%rbp
  803582:	48 83 ec 18          	sub    $0x18,%rsp
  803586:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80358a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80358e:	48 c1 e8 15          	shr    $0x15,%rax
  803592:	48 89 c2             	mov    %rax,%rdx
  803595:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80359c:	01 00 00 
  80359f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035a3:	83 e0 01             	and    $0x1,%eax
  8035a6:	48 85 c0             	test   %rax,%rax
  8035a9:	75 07                	jne    8035b2 <pageref+0x34>
		return 0;
  8035ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b0:	eb 53                	jmp    803605 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8035b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b6:	48 c1 e8 0c          	shr    $0xc,%rax
  8035ba:	48 89 c2             	mov    %rax,%rdx
  8035bd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035c4:	01 00 00 
  8035c7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8035cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d3:	83 e0 01             	and    $0x1,%eax
  8035d6:	48 85 c0             	test   %rax,%rax
  8035d9:	75 07                	jne    8035e2 <pageref+0x64>
		return 0;
  8035db:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e0:	eb 23                	jmp    803605 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035e6:	48 c1 e8 0c          	shr    $0xc,%rax
  8035ea:	48 89 c2             	mov    %rax,%rdx
  8035ed:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035f4:	00 00 00 
  8035f7:	48 c1 e2 04          	shl    $0x4,%rdx
  8035fb:	48 01 d0             	add    %rdx,%rax
  8035fe:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803602:	0f b7 c0             	movzwl %ax,%eax
}
  803605:	c9                   	leaveq 
  803606:	c3                   	retq   
