
obj/user/idle.debug:     file format elf64-x86-64


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
  80003c:	e8 36 00 00 00       	callq  800077 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	binaryname = "idle";
  800052:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800059:	00 00 00 
  80005c:	48 ba 20 35 80 00 00 	movabs $0x803520,%rdx
  800063:	00 00 00 
  800066:	48 89 10             	mov    %rdx,(%rax)
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800069:	48 b8 c2 02 80 00 00 	movabs $0x8002c2,%rax
  800070:	00 00 00 
  800073:	ff d0                	callq  *%rax
	}
  800075:	eb f2                	jmp    800069 <umain+0x26>

0000000000800077 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800077:	55                   	push   %rbp
  800078:	48 89 e5             	mov    %rsp,%rbp
  80007b:	48 83 ec 10          	sub    $0x10,%rsp
  80007f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800082:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800086:	48 b8 84 02 80 00 00 	movabs $0x800284,%rax
  80008d:	00 00 00 
  800090:	ff d0                	callq  *%rax
  800092:	48 98                	cltq   
  800094:	25 ff 03 00 00       	and    $0x3ff,%eax
  800099:	48 89 c2             	mov    %rax,%rdx
  80009c:	48 89 d0             	mov    %rdx,%rax
  80009f:	48 c1 e0 03          	shl    $0x3,%rax
  8000a3:	48 01 d0             	add    %rdx,%rax
  8000a6:	48 c1 e0 05          	shl    $0x5,%rax
  8000aa:	48 89 c2             	mov    %rax,%rdx
  8000ad:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000b4:	00 00 00 
  8000b7:	48 01 c2             	add    %rax,%rdx
  8000ba:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000c1:	00 00 00 
  8000c4:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	7e 14                	jle    8000e1 <libmain+0x6a>
		binaryname = argv[0];
  8000cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000d1:	48 8b 10             	mov    (%rax),%rdx
  8000d4:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000db:	00 00 00 
  8000de:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000e8:	48 89 d6             	mov    %rdx,%rsi
  8000eb:	89 c7                	mov    %eax,%edi
  8000ed:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000f4:	00 00 00 
  8000f7:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000f9:	48 b8 07 01 80 00 00 	movabs $0x800107,%rax
  800100:	00 00 00 
  800103:	ff d0                	callq  *%rax
}
  800105:	c9                   	leaveq 
  800106:	c3                   	retq   

0000000000800107 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800107:	55                   	push   %rbp
  800108:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80010b:	48 b8 ae 08 80 00 00 	movabs $0x8008ae,%rax
  800112:	00 00 00 
  800115:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800117:	bf 00 00 00 00       	mov    $0x0,%edi
  80011c:	48 b8 40 02 80 00 00 	movabs $0x800240,%rax
  800123:	00 00 00 
  800126:	ff d0                	callq  *%rax
}
  800128:	5d                   	pop    %rbp
  800129:	c3                   	retq   

000000000080012a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80012a:	55                   	push   %rbp
  80012b:	48 89 e5             	mov    %rsp,%rbp
  80012e:	53                   	push   %rbx
  80012f:	48 83 ec 48          	sub    $0x48,%rsp
  800133:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800136:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800139:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80013d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800141:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800145:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800149:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80014c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800150:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800154:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800158:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80015c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800160:	4c 89 c3             	mov    %r8,%rbx
  800163:	cd 30                	int    $0x30
  800165:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  800169:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80016d:	74 3e                	je     8001ad <syscall+0x83>
  80016f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800174:	7e 37                	jle    8001ad <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800176:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80017a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80017d:	49 89 d0             	mov    %rdx,%r8
  800180:	89 c1                	mov    %eax,%ecx
  800182:	48 ba 2f 35 80 00 00 	movabs $0x80352f,%rdx
  800189:	00 00 00 
  80018c:	be 23 00 00 00       	mov    $0x23,%esi
  800191:	48 bf 4c 35 80 00 00 	movabs $0x80354c,%rdi
  800198:	00 00 00 
  80019b:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a0:	49 b9 69 1b 80 00 00 	movabs $0x801b69,%r9
  8001a7:	00 00 00 
  8001aa:	41 ff d1             	callq  *%r9

	return ret;
  8001ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001b1:	48 83 c4 48          	add    $0x48,%rsp
  8001b5:	5b                   	pop    %rbx
  8001b6:	5d                   	pop    %rbp
  8001b7:	c3                   	retq   

00000000008001b8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001b8:	55                   	push   %rbp
  8001b9:	48 89 e5             	mov    %rsp,%rbp
  8001bc:	48 83 ec 20          	sub    $0x20,%rsp
  8001c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001d7:	00 
  8001d8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001e4:	48 89 d1             	mov    %rdx,%rcx
  8001e7:	48 89 c2             	mov    %rax,%rdx
  8001ea:	be 00 00 00 00       	mov    $0x0,%esi
  8001ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f4:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  8001fb:	00 00 00 
  8001fe:	ff d0                	callq  *%rax
}
  800200:	c9                   	leaveq 
  800201:	c3                   	retq   

0000000000800202 <sys_cgetc>:

int
sys_cgetc(void)
{
  800202:	55                   	push   %rbp
  800203:	48 89 e5             	mov    %rsp,%rbp
  800206:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80020a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800211:	00 
  800212:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800218:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80021e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800223:	ba 00 00 00 00       	mov    $0x0,%edx
  800228:	be 00 00 00 00       	mov    $0x0,%esi
  80022d:	bf 01 00 00 00       	mov    $0x1,%edi
  800232:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  800239:	00 00 00 
  80023c:	ff d0                	callq  *%rax
}
  80023e:	c9                   	leaveq 
  80023f:	c3                   	retq   

0000000000800240 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800240:	55                   	push   %rbp
  800241:	48 89 e5             	mov    %rsp,%rbp
  800244:	48 83 ec 10          	sub    $0x10,%rsp
  800248:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80024b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80024e:	48 98                	cltq   
  800250:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800257:	00 
  800258:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80025e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800264:	b9 00 00 00 00       	mov    $0x0,%ecx
  800269:	48 89 c2             	mov    %rax,%rdx
  80026c:	be 01 00 00 00       	mov    $0x1,%esi
  800271:	bf 03 00 00 00       	mov    $0x3,%edi
  800276:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  80027d:	00 00 00 
  800280:	ff d0                	callq  *%rax
}
  800282:	c9                   	leaveq 
  800283:	c3                   	retq   

0000000000800284 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800284:	55                   	push   %rbp
  800285:	48 89 e5             	mov    %rsp,%rbp
  800288:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80028c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800293:	00 
  800294:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80029a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8002aa:	be 00 00 00 00       	mov    $0x0,%esi
  8002af:	bf 02 00 00 00       	mov    $0x2,%edi
  8002b4:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
}
  8002c0:	c9                   	leaveq 
  8002c1:	c3                   	retq   

00000000008002c2 <sys_yield>:

void
sys_yield(void)
{
  8002c2:	55                   	push   %rbp
  8002c3:	48 89 e5             	mov    %rsp,%rbp
  8002c6:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002ca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002d1:	00 
  8002d2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e8:	be 00 00 00 00       	mov    $0x0,%esi
  8002ed:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002f2:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  8002f9:	00 00 00 
  8002fc:	ff d0                	callq  *%rax
}
  8002fe:	c9                   	leaveq 
  8002ff:	c3                   	retq   

0000000000800300 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800300:	55                   	push   %rbp
  800301:	48 89 e5             	mov    %rsp,%rbp
  800304:	48 83 ec 20          	sub    $0x20,%rsp
  800308:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80030b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80030f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800312:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800315:	48 63 c8             	movslq %eax,%rcx
  800318:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80031c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80031f:	48 98                	cltq   
  800321:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800328:	00 
  800329:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80032f:	49 89 c8             	mov    %rcx,%r8
  800332:	48 89 d1             	mov    %rdx,%rcx
  800335:	48 89 c2             	mov    %rax,%rdx
  800338:	be 01 00 00 00       	mov    $0x1,%esi
  80033d:	bf 04 00 00 00       	mov    $0x4,%edi
  800342:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  800349:	00 00 00 
  80034c:	ff d0                	callq  *%rax
}
  80034e:	c9                   	leaveq 
  80034f:	c3                   	retq   

0000000000800350 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800350:	55                   	push   %rbp
  800351:	48 89 e5             	mov    %rsp,%rbp
  800354:	48 83 ec 30          	sub    $0x30,%rsp
  800358:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80035b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80035f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800362:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800366:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80036a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036d:	48 63 c8             	movslq %eax,%rcx
  800370:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800374:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800377:	48 63 f0             	movslq %eax,%rsi
  80037a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80037e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800381:	48 98                	cltq   
  800383:	48 89 0c 24          	mov    %rcx,(%rsp)
  800387:	49 89 f9             	mov    %rdi,%r9
  80038a:	49 89 f0             	mov    %rsi,%r8
  80038d:	48 89 d1             	mov    %rdx,%rcx
  800390:	48 89 c2             	mov    %rax,%rdx
  800393:	be 01 00 00 00       	mov    $0x1,%esi
  800398:	bf 05 00 00 00       	mov    $0x5,%edi
  80039d:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  8003a4:	00 00 00 
  8003a7:	ff d0                	callq  *%rax
}
  8003a9:	c9                   	leaveq 
  8003aa:	c3                   	retq   

00000000008003ab <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003ab:	55                   	push   %rbp
  8003ac:	48 89 e5             	mov    %rsp,%rbp
  8003af:	48 83 ec 20          	sub    $0x20,%rsp
  8003b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c1:	48 98                	cltq   
  8003c3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003ca:	00 
  8003cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003d7:	48 89 d1             	mov    %rdx,%rcx
  8003da:	48 89 c2             	mov    %rax,%rdx
  8003dd:	be 01 00 00 00       	mov    $0x1,%esi
  8003e2:	bf 06 00 00 00       	mov    $0x6,%edi
  8003e7:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  8003ee:	00 00 00 
  8003f1:	ff d0                	callq  *%rax
}
  8003f3:	c9                   	leaveq 
  8003f4:	c3                   	retq   

00000000008003f5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003f5:	55                   	push   %rbp
  8003f6:	48 89 e5             	mov    %rsp,%rbp
  8003f9:	48 83 ec 10          	sub    $0x10,%rsp
  8003fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800400:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800403:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800406:	48 63 d0             	movslq %eax,%rdx
  800409:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80040c:	48 98                	cltq   
  80040e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800415:	00 
  800416:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80041c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800422:	48 89 d1             	mov    %rdx,%rcx
  800425:	48 89 c2             	mov    %rax,%rdx
  800428:	be 01 00 00 00       	mov    $0x1,%esi
  80042d:	bf 08 00 00 00       	mov    $0x8,%edi
  800432:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  800439:	00 00 00 
  80043c:	ff d0                	callq  *%rax
}
  80043e:	c9                   	leaveq 
  80043f:	c3                   	retq   

0000000000800440 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800440:	55                   	push   %rbp
  800441:	48 89 e5             	mov    %rsp,%rbp
  800444:	48 83 ec 20          	sub    $0x20,%rsp
  800448:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80044b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80044f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800453:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800456:	48 98                	cltq   
  800458:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80045f:	00 
  800460:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800466:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80046c:	48 89 d1             	mov    %rdx,%rcx
  80046f:	48 89 c2             	mov    %rax,%rdx
  800472:	be 01 00 00 00       	mov    $0x1,%esi
  800477:	bf 09 00 00 00       	mov    $0x9,%edi
  80047c:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  800483:	00 00 00 
  800486:	ff d0                	callq  *%rax
}
  800488:	c9                   	leaveq 
  800489:	c3                   	retq   

000000000080048a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80048a:	55                   	push   %rbp
  80048b:	48 89 e5             	mov    %rsp,%rbp
  80048e:	48 83 ec 20          	sub    $0x20,%rsp
  800492:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800495:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800499:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80049d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004a0:	48 98                	cltq   
  8004a2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004a9:	00 
  8004aa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004b0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004b6:	48 89 d1             	mov    %rdx,%rcx
  8004b9:	48 89 c2             	mov    %rax,%rdx
  8004bc:	be 01 00 00 00       	mov    $0x1,%esi
  8004c1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004c6:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  8004cd:	00 00 00 
  8004d0:	ff d0                	callq  *%rax
}
  8004d2:	c9                   	leaveq 
  8004d3:	c3                   	retq   

00000000008004d4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004d4:	55                   	push   %rbp
  8004d5:	48 89 e5             	mov    %rsp,%rbp
  8004d8:	48 83 ec 20          	sub    $0x20,%rsp
  8004dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004e3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004e7:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004ed:	48 63 f0             	movslq %eax,%rsi
  8004f0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004f7:	48 98                	cltq   
  8004f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004fd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800504:	00 
  800505:	49 89 f1             	mov    %rsi,%r9
  800508:	49 89 c8             	mov    %rcx,%r8
  80050b:	48 89 d1             	mov    %rdx,%rcx
  80050e:	48 89 c2             	mov    %rax,%rdx
  800511:	be 00 00 00 00       	mov    $0x0,%esi
  800516:	bf 0c 00 00 00       	mov    $0xc,%edi
  80051b:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  800522:	00 00 00 
  800525:	ff d0                	callq  *%rax
}
  800527:	c9                   	leaveq 
  800528:	c3                   	retq   

0000000000800529 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800529:	55                   	push   %rbp
  80052a:	48 89 e5             	mov    %rsp,%rbp
  80052d:	48 83 ec 10          	sub    $0x10,%rsp
  800531:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800535:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800539:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800540:	00 
  800541:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800547:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80054d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800552:	48 89 c2             	mov    %rax,%rdx
  800555:	be 01 00 00 00       	mov    $0x1,%esi
  80055a:	bf 0d 00 00 00       	mov    $0xd,%edi
  80055f:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  800566:	00 00 00 
  800569:	ff d0                	callq  *%rax
}
  80056b:	c9                   	leaveq 
  80056c:	c3                   	retq   

000000000080056d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80056d:	55                   	push   %rbp
  80056e:	48 89 e5             	mov    %rsp,%rbp
  800571:	48 83 ec 08          	sub    $0x8,%rsp
  800575:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800579:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80057d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800584:	ff ff ff 
  800587:	48 01 d0             	add    %rdx,%rax
  80058a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80058e:	c9                   	leaveq 
  80058f:	c3                   	retq   

0000000000800590 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800590:	55                   	push   %rbp
  800591:	48 89 e5             	mov    %rsp,%rbp
  800594:	48 83 ec 08          	sub    $0x8,%rsp
  800598:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80059c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005a0:	48 89 c7             	mov    %rax,%rdi
  8005a3:	48 b8 6d 05 80 00 00 	movabs $0x80056d,%rax
  8005aa:	00 00 00 
  8005ad:	ff d0                	callq  *%rax
  8005af:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8005b5:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8005b9:	c9                   	leaveq 
  8005ba:	c3                   	retq   

00000000008005bb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005bb:	55                   	push   %rbp
  8005bc:	48 89 e5             	mov    %rsp,%rbp
  8005bf:	48 83 ec 18          	sub    $0x18,%rsp
  8005c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8005c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005ce:	eb 6b                	jmp    80063b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8005d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005d3:	48 98                	cltq   
  8005d5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8005db:	48 c1 e0 0c          	shl    $0xc,%rax
  8005df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e7:	48 c1 e8 15          	shr    $0x15,%rax
  8005eb:	48 89 c2             	mov    %rax,%rdx
  8005ee:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8005f5:	01 00 00 
  8005f8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005fc:	83 e0 01             	and    $0x1,%eax
  8005ff:	48 85 c0             	test   %rax,%rax
  800602:	74 21                	je     800625 <fd_alloc+0x6a>
  800604:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800608:	48 c1 e8 0c          	shr    $0xc,%rax
  80060c:	48 89 c2             	mov    %rax,%rdx
  80060f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800616:	01 00 00 
  800619:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80061d:	83 e0 01             	and    $0x1,%eax
  800620:	48 85 c0             	test   %rax,%rax
  800623:	75 12                	jne    800637 <fd_alloc+0x7c>
			*fd_store = fd;
  800625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800629:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80062d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800630:	b8 00 00 00 00       	mov    $0x0,%eax
  800635:	eb 1a                	jmp    800651 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800637:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80063b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80063f:	7e 8f                	jle    8005d0 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800641:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800645:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80064c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800651:	c9                   	leaveq 
  800652:	c3                   	retq   

0000000000800653 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800653:	55                   	push   %rbp
  800654:	48 89 e5             	mov    %rsp,%rbp
  800657:	48 83 ec 20          	sub    $0x20,%rsp
  80065b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80065e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800662:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800666:	78 06                	js     80066e <fd_lookup+0x1b>
  800668:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80066c:	7e 07                	jle    800675 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80066e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800673:	eb 6c                	jmp    8006e1 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800675:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800678:	48 98                	cltq   
  80067a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800680:	48 c1 e0 0c          	shl    $0xc,%rax
  800684:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800688:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80068c:	48 c1 e8 15          	shr    $0x15,%rax
  800690:	48 89 c2             	mov    %rax,%rdx
  800693:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80069a:	01 00 00 
  80069d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006a1:	83 e0 01             	and    $0x1,%eax
  8006a4:	48 85 c0             	test   %rax,%rax
  8006a7:	74 21                	je     8006ca <fd_lookup+0x77>
  8006a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006ad:	48 c1 e8 0c          	shr    $0xc,%rax
  8006b1:	48 89 c2             	mov    %rax,%rdx
  8006b4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006bb:	01 00 00 
  8006be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006c2:	83 e0 01             	and    $0x1,%eax
  8006c5:	48 85 c0             	test   %rax,%rax
  8006c8:	75 07                	jne    8006d1 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006cf:	eb 10                	jmp    8006e1 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8006d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006d9:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8006dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006e1:	c9                   	leaveq 
  8006e2:	c3                   	retq   

00000000008006e3 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006e3:	55                   	push   %rbp
  8006e4:	48 89 e5             	mov    %rsp,%rbp
  8006e7:	48 83 ec 30          	sub    $0x30,%rsp
  8006eb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8006ef:	89 f0                	mov    %esi,%eax
  8006f1:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006f8:	48 89 c7             	mov    %rax,%rdi
  8006fb:	48 b8 6d 05 80 00 00 	movabs $0x80056d,%rax
  800702:	00 00 00 
  800705:	ff d0                	callq  *%rax
  800707:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80070b:	48 89 d6             	mov    %rdx,%rsi
  80070e:	89 c7                	mov    %eax,%edi
  800710:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  800717:	00 00 00 
  80071a:	ff d0                	callq  *%rax
  80071c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80071f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800723:	78 0a                	js     80072f <fd_close+0x4c>
	    || fd != fd2)
  800725:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800729:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80072d:	74 12                	je     800741 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80072f:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800733:	74 05                	je     80073a <fd_close+0x57>
  800735:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800738:	eb 05                	jmp    80073f <fd_close+0x5c>
  80073a:	b8 00 00 00 00       	mov    $0x0,%eax
  80073f:	eb 69                	jmp    8007aa <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800741:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800745:	8b 00                	mov    (%rax),%eax
  800747:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80074b:	48 89 d6             	mov    %rdx,%rsi
  80074e:	89 c7                	mov    %eax,%edi
  800750:	48 b8 ac 07 80 00 00 	movabs $0x8007ac,%rax
  800757:	00 00 00 
  80075a:	ff d0                	callq  *%rax
  80075c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80075f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800763:	78 2a                	js     80078f <fd_close+0xac>
		if (dev->dev_close)
  800765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800769:	48 8b 40 20          	mov    0x20(%rax),%rax
  80076d:	48 85 c0             	test   %rax,%rax
  800770:	74 16                	je     800788 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800776:	48 8b 40 20          	mov    0x20(%rax),%rax
  80077a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80077e:	48 89 d7             	mov    %rdx,%rdi
  800781:	ff d0                	callq  *%rax
  800783:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800786:	eb 07                	jmp    80078f <fd_close+0xac>
		else
			r = 0;
  800788:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80078f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800793:	48 89 c6             	mov    %rax,%rsi
  800796:	bf 00 00 00 00       	mov    $0x0,%edi
  80079b:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  8007a2:	00 00 00 
  8007a5:	ff d0                	callq  *%rax
	return r;
  8007a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007aa:	c9                   	leaveq 
  8007ab:	c3                   	retq   

00000000008007ac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8007ac:	55                   	push   %rbp
  8007ad:	48 89 e5             	mov    %rsp,%rbp
  8007b0:	48 83 ec 20          	sub    $0x20,%rsp
  8007b4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8007b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8007bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8007c2:	eb 41                	jmp    800805 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8007c4:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007cb:	00 00 00 
  8007ce:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007d1:	48 63 d2             	movslq %edx,%rdx
  8007d4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007d8:	8b 00                	mov    (%rax),%eax
  8007da:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8007dd:	75 22                	jne    800801 <dev_lookup+0x55>
			*dev = devtab[i];
  8007df:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007e6:	00 00 00 
  8007e9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007ec:	48 63 d2             	movslq %edx,%rdx
  8007ef:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8007f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007f7:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8007fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ff:	eb 60                	jmp    800861 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800801:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800805:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80080c:	00 00 00 
  80080f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800812:	48 63 d2             	movslq %edx,%rdx
  800815:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800819:	48 85 c0             	test   %rax,%rax
  80081c:	75 a6                	jne    8007c4 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80081e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800825:	00 00 00 
  800828:	48 8b 00             	mov    (%rax),%rax
  80082b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800831:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800834:	89 c6                	mov    %eax,%esi
  800836:	48 bf 60 35 80 00 00 	movabs $0x803560,%rdi
  80083d:	00 00 00 
  800840:	b8 00 00 00 00       	mov    $0x0,%eax
  800845:	48 b9 a2 1d 80 00 00 	movabs $0x801da2,%rcx
  80084c:	00 00 00 
  80084f:	ff d1                	callq  *%rcx
	*dev = 0;
  800851:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800855:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80085c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800861:	c9                   	leaveq 
  800862:	c3                   	retq   

0000000000800863 <close>:

int
close(int fdnum)
{
  800863:	55                   	push   %rbp
  800864:	48 89 e5             	mov    %rsp,%rbp
  800867:	48 83 ec 20          	sub    $0x20,%rsp
  80086b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80086e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800872:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800875:	48 89 d6             	mov    %rdx,%rsi
  800878:	89 c7                	mov    %eax,%edi
  80087a:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  800881:	00 00 00 
  800884:	ff d0                	callq  *%rax
  800886:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800889:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80088d:	79 05                	jns    800894 <close+0x31>
		return r;
  80088f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800892:	eb 18                	jmp    8008ac <close+0x49>
	else
		return fd_close(fd, 1);
  800894:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800898:	be 01 00 00 00       	mov    $0x1,%esi
  80089d:	48 89 c7             	mov    %rax,%rdi
  8008a0:	48 b8 e3 06 80 00 00 	movabs $0x8006e3,%rax
  8008a7:	00 00 00 
  8008aa:	ff d0                	callq  *%rax
}
  8008ac:	c9                   	leaveq 
  8008ad:	c3                   	retq   

00000000008008ae <close_all>:

void
close_all(void)
{
  8008ae:	55                   	push   %rbp
  8008af:	48 89 e5             	mov    %rsp,%rbp
  8008b2:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8008b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008bd:	eb 15                	jmp    8008d4 <close_all+0x26>
		close(i);
  8008bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008c2:	89 c7                	mov    %eax,%edi
  8008c4:	48 b8 63 08 80 00 00 	movabs $0x800863,%rax
  8008cb:	00 00 00 
  8008ce:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8008d0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008d4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8008d8:	7e e5                	jle    8008bf <close_all+0x11>
		close(i);
}
  8008da:	c9                   	leaveq 
  8008db:	c3                   	retq   

00000000008008dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8008dc:	55                   	push   %rbp
  8008dd:	48 89 e5             	mov    %rsp,%rbp
  8008e0:	48 83 ec 40          	sub    $0x40,%rsp
  8008e4:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8008e7:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8008ea:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8008ee:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008f1:	48 89 d6             	mov    %rdx,%rsi
  8008f4:	89 c7                	mov    %eax,%edi
  8008f6:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  8008fd:	00 00 00 
  800900:	ff d0                	callq  *%rax
  800902:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800905:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800909:	79 08                	jns    800913 <dup+0x37>
		return r;
  80090b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80090e:	e9 70 01 00 00       	jmpq   800a83 <dup+0x1a7>
	close(newfdnum);
  800913:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800916:	89 c7                	mov    %eax,%edi
  800918:	48 b8 63 08 80 00 00 	movabs $0x800863,%rax
  80091f:	00 00 00 
  800922:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800924:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800927:	48 98                	cltq   
  800929:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80092f:	48 c1 e0 0c          	shl    $0xc,%rax
  800933:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800937:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80093b:	48 89 c7             	mov    %rax,%rdi
  80093e:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  800945:	00 00 00 
  800948:	ff d0                	callq  *%rax
  80094a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80094e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800952:	48 89 c7             	mov    %rax,%rdi
  800955:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  80095c:	00 00 00 
  80095f:	ff d0                	callq  *%rax
  800961:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800965:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800969:	48 c1 e8 15          	shr    $0x15,%rax
  80096d:	48 89 c2             	mov    %rax,%rdx
  800970:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800977:	01 00 00 
  80097a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80097e:	83 e0 01             	and    $0x1,%eax
  800981:	48 85 c0             	test   %rax,%rax
  800984:	74 73                	je     8009f9 <dup+0x11d>
  800986:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098a:	48 c1 e8 0c          	shr    $0xc,%rax
  80098e:	48 89 c2             	mov    %rax,%rdx
  800991:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800998:	01 00 00 
  80099b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80099f:	83 e0 01             	and    $0x1,%eax
  8009a2:	48 85 c0             	test   %rax,%rax
  8009a5:	74 52                	je     8009f9 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8009a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ab:	48 c1 e8 0c          	shr    $0xc,%rax
  8009af:	48 89 c2             	mov    %rax,%rdx
  8009b2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009b9:	01 00 00 
  8009bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009c0:	25 07 0e 00 00       	and    $0xe07,%eax
  8009c5:	89 c1                	mov    %eax,%ecx
  8009c7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cf:	41 89 c8             	mov    %ecx,%r8d
  8009d2:	48 89 d1             	mov    %rdx,%rcx
  8009d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009da:	48 89 c6             	mov    %rax,%rsi
  8009dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8009e2:	48 b8 50 03 80 00 00 	movabs $0x800350,%rax
  8009e9:	00 00 00 
  8009ec:	ff d0                	callq  *%rax
  8009ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009f5:	79 02                	jns    8009f9 <dup+0x11d>
			goto err;
  8009f7:	eb 57                	jmp    800a50 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009fd:	48 c1 e8 0c          	shr    $0xc,%rax
  800a01:	48 89 c2             	mov    %rax,%rdx
  800a04:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a0b:	01 00 00 
  800a0e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a12:	25 07 0e 00 00       	and    $0xe07,%eax
  800a17:	89 c1                	mov    %eax,%ecx
  800a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a1d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a21:	41 89 c8             	mov    %ecx,%r8d
  800a24:	48 89 d1             	mov    %rdx,%rcx
  800a27:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2c:	48 89 c6             	mov    %rax,%rsi
  800a2f:	bf 00 00 00 00       	mov    $0x0,%edi
  800a34:	48 b8 50 03 80 00 00 	movabs $0x800350,%rax
  800a3b:	00 00 00 
  800a3e:	ff d0                	callq  *%rax
  800a40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a47:	79 02                	jns    800a4b <dup+0x16f>
		goto err;
  800a49:	eb 05                	jmp    800a50 <dup+0x174>

	return newfdnum;
  800a4b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a4e:	eb 33                	jmp    800a83 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800a50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a54:	48 89 c6             	mov    %rax,%rsi
  800a57:	bf 00 00 00 00       	mov    $0x0,%edi
  800a5c:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  800a63:	00 00 00 
  800a66:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800a68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a6c:	48 89 c6             	mov    %rax,%rsi
  800a6f:	bf 00 00 00 00       	mov    $0x0,%edi
  800a74:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  800a7b:	00 00 00 
  800a7e:	ff d0                	callq  *%rax
	return r;
  800a80:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800a83:	c9                   	leaveq 
  800a84:	c3                   	retq   

0000000000800a85 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a85:	55                   	push   %rbp
  800a86:	48 89 e5             	mov    %rsp,%rbp
  800a89:	48 83 ec 40          	sub    $0x40,%rsp
  800a8d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800a90:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800a94:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a98:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800a9c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a9f:	48 89 d6             	mov    %rdx,%rsi
  800aa2:	89 c7                	mov    %eax,%edi
  800aa4:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  800aab:	00 00 00 
  800aae:	ff d0                	callq  *%rax
  800ab0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ab3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ab7:	78 24                	js     800add <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ab9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abd:	8b 00                	mov    (%rax),%eax
  800abf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ac3:	48 89 d6             	mov    %rdx,%rsi
  800ac6:	89 c7                	mov    %eax,%edi
  800ac8:	48 b8 ac 07 80 00 00 	movabs $0x8007ac,%rax
  800acf:	00 00 00 
  800ad2:	ff d0                	callq  *%rax
  800ad4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ad7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800adb:	79 05                	jns    800ae2 <read+0x5d>
		return r;
  800add:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ae0:	eb 76                	jmp    800b58 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800ae2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae6:	8b 40 08             	mov    0x8(%rax),%eax
  800ae9:	83 e0 03             	and    $0x3,%eax
  800aec:	83 f8 01             	cmp    $0x1,%eax
  800aef:	75 3a                	jne    800b2b <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800af1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800af8:	00 00 00 
  800afb:	48 8b 00             	mov    (%rax),%rax
  800afe:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800b04:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800b07:	89 c6                	mov    %eax,%esi
  800b09:	48 bf 7f 35 80 00 00 	movabs $0x80357f,%rdi
  800b10:	00 00 00 
  800b13:	b8 00 00 00 00       	mov    $0x0,%eax
  800b18:	48 b9 a2 1d 80 00 00 	movabs $0x801da2,%rcx
  800b1f:	00 00 00 
  800b22:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800b24:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b29:	eb 2d                	jmp    800b58 <read+0xd3>
	}
	if (!dev->dev_read)
  800b2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b2f:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b33:	48 85 c0             	test   %rax,%rax
  800b36:	75 07                	jne    800b3f <read+0xba>
		return -E_NOT_SUPP;
  800b38:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800b3d:	eb 19                	jmp    800b58 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800b3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b43:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b47:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800b4b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b4f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800b53:	48 89 cf             	mov    %rcx,%rdi
  800b56:	ff d0                	callq  *%rax
}
  800b58:	c9                   	leaveq 
  800b59:	c3                   	retq   

0000000000800b5a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b5a:	55                   	push   %rbp
  800b5b:	48 89 e5             	mov    %rsp,%rbp
  800b5e:	48 83 ec 30          	sub    $0x30,%rsp
  800b62:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800b65:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800b69:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800b74:	eb 49                	jmp    800bbf <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b79:	48 98                	cltq   
  800b7b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800b7f:	48 29 c2             	sub    %rax,%rdx
  800b82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b85:	48 63 c8             	movslq %eax,%rcx
  800b88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b8c:	48 01 c1             	add    %rax,%rcx
  800b8f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800b92:	48 89 ce             	mov    %rcx,%rsi
  800b95:	89 c7                	mov    %eax,%edi
  800b97:	48 b8 85 0a 80 00 00 	movabs $0x800a85,%rax
  800b9e:	00 00 00 
  800ba1:	ff d0                	callq  *%rax
  800ba3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800ba6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800baa:	79 05                	jns    800bb1 <readn+0x57>
			return m;
  800bac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800baf:	eb 1c                	jmp    800bcd <readn+0x73>
		if (m == 0)
  800bb1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800bb5:	75 02                	jne    800bb9 <readn+0x5f>
			break;
  800bb7:	eb 11                	jmp    800bca <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800bb9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bbc:	01 45 fc             	add    %eax,-0x4(%rbp)
  800bbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bc2:	48 98                	cltq   
  800bc4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800bc8:	72 ac                	jb     800b76 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800bca:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800bcd:	c9                   	leaveq 
  800bce:	c3                   	retq   

0000000000800bcf <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800bcf:	55                   	push   %rbp
  800bd0:	48 89 e5             	mov    %rsp,%rbp
  800bd3:	48 83 ec 40          	sub    $0x40,%rsp
  800bd7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bda:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800bde:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800be2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800be6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800be9:	48 89 d6             	mov    %rdx,%rsi
  800bec:	89 c7                	mov    %eax,%edi
  800bee:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  800bf5:	00 00 00 
  800bf8:	ff d0                	callq  *%rax
  800bfa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c01:	78 24                	js     800c27 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c07:	8b 00                	mov    (%rax),%eax
  800c09:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c0d:	48 89 d6             	mov    %rdx,%rsi
  800c10:	89 c7                	mov    %eax,%edi
  800c12:	48 b8 ac 07 80 00 00 	movabs $0x8007ac,%rax
  800c19:	00 00 00 
  800c1c:	ff d0                	callq  *%rax
  800c1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c25:	79 05                	jns    800c2c <write+0x5d>
		return r;
  800c27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c2a:	eb 75                	jmp    800ca1 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c30:	8b 40 08             	mov    0x8(%rax),%eax
  800c33:	83 e0 03             	and    $0x3,%eax
  800c36:	85 c0                	test   %eax,%eax
  800c38:	75 3a                	jne    800c74 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c3a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c41:	00 00 00 
  800c44:	48 8b 00             	mov    (%rax),%rax
  800c47:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c4d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c50:	89 c6                	mov    %eax,%esi
  800c52:	48 bf 9b 35 80 00 00 	movabs $0x80359b,%rdi
  800c59:	00 00 00 
  800c5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c61:	48 b9 a2 1d 80 00 00 	movabs $0x801da2,%rcx
  800c68:	00 00 00 
  800c6b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c6d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c72:	eb 2d                	jmp    800ca1 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c78:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c7c:	48 85 c0             	test   %rax,%rax
  800c7f:	75 07                	jne    800c88 <write+0xb9>
		return -E_NOT_SUPP;
  800c81:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c86:	eb 19                	jmp    800ca1 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800c88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c8c:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c90:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c94:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c98:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c9c:	48 89 cf             	mov    %rcx,%rdi
  800c9f:	ff d0                	callq  *%rax
}
  800ca1:	c9                   	leaveq 
  800ca2:	c3                   	retq   

0000000000800ca3 <seek>:

int
seek(int fdnum, off_t offset)
{
  800ca3:	55                   	push   %rbp
  800ca4:	48 89 e5             	mov    %rsp,%rbp
  800ca7:	48 83 ec 18          	sub    $0x18,%rsp
  800cab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800cae:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800cb1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800cb5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800cb8:	48 89 d6             	mov    %rdx,%rsi
  800cbb:	89 c7                	mov    %eax,%edi
  800cbd:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  800cc4:	00 00 00 
  800cc7:	ff d0                	callq  *%rax
  800cc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ccc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cd0:	79 05                	jns    800cd7 <seek+0x34>
		return r;
  800cd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cd5:	eb 0f                	jmp    800ce6 <seek+0x43>
	fd->fd_offset = offset;
  800cd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cdb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800cde:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800ce1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce6:	c9                   	leaveq 
  800ce7:	c3                   	retq   

0000000000800ce8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800ce8:	55                   	push   %rbp
  800ce9:	48 89 e5             	mov    %rsp,%rbp
  800cec:	48 83 ec 30          	sub    $0x30,%rsp
  800cf0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800cf3:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cf6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cfa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800cfd:	48 89 d6             	mov    %rdx,%rsi
  800d00:	89 c7                	mov    %eax,%edi
  800d02:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  800d09:	00 00 00 
  800d0c:	ff d0                	callq  *%rax
  800d0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d15:	78 24                	js     800d3b <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d1b:	8b 00                	mov    (%rax),%eax
  800d1d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d21:	48 89 d6             	mov    %rdx,%rsi
  800d24:	89 c7                	mov    %eax,%edi
  800d26:	48 b8 ac 07 80 00 00 	movabs $0x8007ac,%rax
  800d2d:	00 00 00 
  800d30:	ff d0                	callq  *%rax
  800d32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d39:	79 05                	jns    800d40 <ftruncate+0x58>
		return r;
  800d3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d3e:	eb 72                	jmp    800db2 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d44:	8b 40 08             	mov    0x8(%rax),%eax
  800d47:	83 e0 03             	and    $0x3,%eax
  800d4a:	85 c0                	test   %eax,%eax
  800d4c:	75 3a                	jne    800d88 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800d4e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d55:	00 00 00 
  800d58:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d5b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d61:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d64:	89 c6                	mov    %eax,%esi
  800d66:	48 bf b8 35 80 00 00 	movabs $0x8035b8,%rdi
  800d6d:	00 00 00 
  800d70:	b8 00 00 00 00       	mov    $0x0,%eax
  800d75:	48 b9 a2 1d 80 00 00 	movabs $0x801da2,%rcx
  800d7c:	00 00 00 
  800d7f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800d81:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d86:	eb 2a                	jmp    800db2 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800d88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d8c:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d90:	48 85 c0             	test   %rax,%rax
  800d93:	75 07                	jne    800d9c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800d95:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d9a:	eb 16                	jmp    800db2 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800d9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800da0:	48 8b 40 30          	mov    0x30(%rax),%rax
  800da4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800da8:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800dab:	89 ce                	mov    %ecx,%esi
  800dad:	48 89 d7             	mov    %rdx,%rdi
  800db0:	ff d0                	callq  *%rax
}
  800db2:	c9                   	leaveq 
  800db3:	c3                   	retq   

0000000000800db4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800db4:	55                   	push   %rbp
  800db5:	48 89 e5             	mov    %rsp,%rbp
  800db8:	48 83 ec 30          	sub    $0x30,%rsp
  800dbc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800dbf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dc3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800dc7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800dca:	48 89 d6             	mov    %rdx,%rsi
  800dcd:	89 c7                	mov    %eax,%edi
  800dcf:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  800dd6:	00 00 00 
  800dd9:	ff d0                	callq  *%rax
  800ddb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800de2:	78 24                	js     800e08 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800de4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de8:	8b 00                	mov    (%rax),%eax
  800dea:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800dee:	48 89 d6             	mov    %rdx,%rsi
  800df1:	89 c7                	mov    %eax,%edi
  800df3:	48 b8 ac 07 80 00 00 	movabs $0x8007ac,%rax
  800dfa:	00 00 00 
  800dfd:	ff d0                	callq  *%rax
  800dff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e06:	79 05                	jns    800e0d <fstat+0x59>
		return r;
  800e08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e0b:	eb 5e                	jmp    800e6b <fstat+0xb7>
	if (!dev->dev_stat)
  800e0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e11:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e15:	48 85 c0             	test   %rax,%rax
  800e18:	75 07                	jne    800e21 <fstat+0x6d>
		return -E_NOT_SUPP;
  800e1a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e1f:	eb 4a                	jmp    800e6b <fstat+0xb7>
	stat->st_name[0] = 0;
  800e21:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e25:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800e28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e2c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800e33:	00 00 00 
	stat->st_isdir = 0;
  800e36:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e3a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800e41:	00 00 00 
	stat->st_dev = dev;
  800e44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e48:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e4c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800e53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e57:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e5b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e5f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800e63:	48 89 ce             	mov    %rcx,%rsi
  800e66:	48 89 d7             	mov    %rdx,%rdi
  800e69:	ff d0                	callq  *%rax
}
  800e6b:	c9                   	leaveq 
  800e6c:	c3                   	retq   

0000000000800e6d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800e6d:	55                   	push   %rbp
  800e6e:	48 89 e5             	mov    %rsp,%rbp
  800e71:	48 83 ec 20          	sub    $0x20,%rsp
  800e75:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e79:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e81:	be 00 00 00 00       	mov    $0x0,%esi
  800e86:	48 89 c7             	mov    %rax,%rdi
  800e89:	48 b8 5b 0f 80 00 00 	movabs $0x800f5b,%rax
  800e90:	00 00 00 
  800e93:	ff d0                	callq  *%rax
  800e95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e9c:	79 05                	jns    800ea3 <stat+0x36>
		return fd;
  800e9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ea1:	eb 2f                	jmp    800ed2 <stat+0x65>
	r = fstat(fd, stat);
  800ea3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ea7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eaa:	48 89 d6             	mov    %rdx,%rsi
  800ead:	89 c7                	mov    %eax,%edi
  800eaf:	48 b8 b4 0d 80 00 00 	movabs $0x800db4,%rax
  800eb6:	00 00 00 
  800eb9:	ff d0                	callq  *%rax
  800ebb:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800ebe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ec1:	89 c7                	mov    %eax,%edi
  800ec3:	48 b8 63 08 80 00 00 	movabs $0x800863,%rax
  800eca:	00 00 00 
  800ecd:	ff d0                	callq  *%rax
	return r;
  800ecf:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ed2:	c9                   	leaveq 
  800ed3:	c3                   	retq   

0000000000800ed4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ed4:	55                   	push   %rbp
  800ed5:	48 89 e5             	mov    %rsp,%rbp
  800ed8:	48 83 ec 10          	sub    $0x10,%rsp
  800edc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800edf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800ee3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800eea:	00 00 00 
  800eed:	8b 00                	mov    (%rax),%eax
  800eef:	85 c0                	test   %eax,%eax
  800ef1:	75 1d                	jne    800f10 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ef3:	bf 01 00 00 00       	mov    $0x1,%edi
  800ef8:	48 b8 04 34 80 00 00 	movabs $0x803404,%rax
  800eff:	00 00 00 
  800f02:	ff d0                	callq  *%rax
  800f04:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800f0b:	00 00 00 
  800f0e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f10:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f17:	00 00 00 
  800f1a:	8b 00                	mov    (%rax),%eax
  800f1c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800f1f:	b9 07 00 00 00       	mov    $0x7,%ecx
  800f24:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f2b:	00 00 00 
  800f2e:	89 c7                	mov    %eax,%edi
  800f30:	48 b8 6c 33 80 00 00 	movabs $0x80336c,%rax
  800f37:	00 00 00 
  800f3a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800f3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f40:	ba 00 00 00 00       	mov    $0x0,%edx
  800f45:	48 89 c6             	mov    %rax,%rsi
  800f48:	bf 00 00 00 00       	mov    $0x0,%edi
  800f4d:	48 b8 a3 32 80 00 00 	movabs $0x8032a3,%rax
  800f54:	00 00 00 
  800f57:	ff d0                	callq  *%rax
}
  800f59:	c9                   	leaveq 
  800f5a:	c3                   	retq   

0000000000800f5b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800f5b:	55                   	push   %rbp
  800f5c:	48 89 e5             	mov    %rsp,%rbp
  800f5f:	48 83 ec 20          	sub    $0x20,%rsp
  800f63:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f67:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  800f6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6e:	48 89 c7             	mov    %rax,%rdi
  800f71:	48 b8 de 2a 80 00 00 	movabs $0x802ade,%rax
  800f78:	00 00 00 
  800f7b:	ff d0                	callq  *%rax
  800f7d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f82:	7e 0a                	jle    800f8e <open+0x33>
		return -E_BAD_PATH;
  800f84:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800f89:	e9 a5 00 00 00       	jmpq   801033 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  800f8e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f92:	48 89 c7             	mov    %rax,%rdi
  800f95:	48 b8 bb 05 80 00 00 	movabs $0x8005bb,%rax
  800f9c:	00 00 00 
  800f9f:	ff d0                	callq  *%rax
  800fa1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fa4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fa8:	79 08                	jns    800fb2 <open+0x57>
		return r;
  800faa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fad:	e9 81 00 00 00       	jmpq   801033 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  800fb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb6:	48 89 c6             	mov    %rax,%rsi
  800fb9:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  800fc0:	00 00 00 
  800fc3:	48 b8 4a 2b 80 00 00 	movabs $0x802b4a,%rax
  800fca:	00 00 00 
  800fcd:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  800fcf:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fd6:	00 00 00 
  800fd9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800fdc:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800fe2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe6:	48 89 c6             	mov    %rax,%rsi
  800fe9:	bf 01 00 00 00       	mov    $0x1,%edi
  800fee:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  800ff5:	00 00 00 
  800ff8:	ff d0                	callq  *%rax
  800ffa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ffd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801001:	79 1d                	jns    801020 <open+0xc5>
		fd_close(fd, 0);
  801003:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801007:	be 00 00 00 00       	mov    $0x0,%esi
  80100c:	48 89 c7             	mov    %rax,%rdi
  80100f:	48 b8 e3 06 80 00 00 	movabs $0x8006e3,%rax
  801016:	00 00 00 
  801019:	ff d0                	callq  *%rax
		return r;
  80101b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80101e:	eb 13                	jmp    801033 <open+0xd8>
	}

	return fd2num(fd);
  801020:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801024:	48 89 c7             	mov    %rax,%rdi
  801027:	48 b8 6d 05 80 00 00 	movabs $0x80056d,%rax
  80102e:	00 00 00 
  801031:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  801033:	c9                   	leaveq 
  801034:	c3                   	retq   

0000000000801035 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801035:	55                   	push   %rbp
  801036:	48 89 e5             	mov    %rsp,%rbp
  801039:	48 83 ec 10          	sub    $0x10,%rsp
  80103d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801041:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801045:	8b 50 0c             	mov    0xc(%rax),%edx
  801048:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80104f:	00 00 00 
  801052:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801054:	be 00 00 00 00       	mov    $0x0,%esi
  801059:	bf 06 00 00 00       	mov    $0x6,%edi
  80105e:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  801065:	00 00 00 
  801068:	ff d0                	callq  *%rax
}
  80106a:	c9                   	leaveq 
  80106b:	c3                   	retq   

000000000080106c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80106c:	55                   	push   %rbp
  80106d:	48 89 e5             	mov    %rsp,%rbp
  801070:	48 83 ec 30          	sub    $0x30,%rsp
  801074:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801078:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80107c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801080:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801084:	8b 50 0c             	mov    0xc(%rax),%edx
  801087:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80108e:	00 00 00 
  801091:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801093:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80109a:	00 00 00 
  80109d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8010a1:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8010a5:	be 00 00 00 00       	mov    $0x0,%esi
  8010aa:	bf 03 00 00 00       	mov    $0x3,%edi
  8010af:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  8010b6:	00 00 00 
  8010b9:	ff d0                	callq  *%rax
  8010bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010c2:	79 05                	jns    8010c9 <devfile_read+0x5d>
		return r;
  8010c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c7:	eb 26                	jmp    8010ef <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8010c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010cc:	48 63 d0             	movslq %eax,%rdx
  8010cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010d3:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8010da:	00 00 00 
  8010dd:	48 89 c7             	mov    %rax,%rdi
  8010e0:	48 b8 6e 2e 80 00 00 	movabs $0x802e6e,%rax
  8010e7:	00 00 00 
  8010ea:	ff d0                	callq  *%rax

	return r;
  8010ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8010ef:	c9                   	leaveq 
  8010f0:	c3                   	retq   

00000000008010f1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8010f1:	55                   	push   %rbp
  8010f2:	48 89 e5             	mov    %rsp,%rbp
  8010f5:	48 83 ec 30          	sub    $0x30,%rsp
  8010f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801101:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  801105:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80110c:	00 
  80110d:	76 08                	jbe    801117 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  80110f:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  801116:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801117:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111b:	8b 50 0c             	mov    0xc(%rax),%edx
  80111e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801125:	00 00 00 
  801128:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80112a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801131:	00 00 00 
  801134:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801138:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  80113c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801140:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801144:	48 89 c6             	mov    %rax,%rsi
  801147:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  80114e:	00 00 00 
  801151:	48 b8 6e 2e 80 00 00 	movabs $0x802e6e,%rax
  801158:	00 00 00 
  80115b:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80115d:	be 00 00 00 00       	mov    $0x0,%esi
  801162:	bf 04 00 00 00       	mov    $0x4,%edi
  801167:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  80116e:	00 00 00 
  801171:	ff d0                	callq  *%rax
  801173:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801176:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80117a:	79 05                	jns    801181 <devfile_write+0x90>
		return r;
  80117c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80117f:	eb 03                	jmp    801184 <devfile_write+0x93>

	return r;
  801181:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  801184:	c9                   	leaveq 
  801185:	c3                   	retq   

0000000000801186 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801186:	55                   	push   %rbp
  801187:	48 89 e5             	mov    %rsp,%rbp
  80118a:	48 83 ec 20          	sub    $0x20,%rsp
  80118e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801192:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801196:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119a:	8b 50 0c             	mov    0xc(%rax),%edx
  80119d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011a4:	00 00 00 
  8011a7:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8011a9:	be 00 00 00 00       	mov    $0x0,%esi
  8011ae:	bf 05 00 00 00       	mov    $0x5,%edi
  8011b3:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  8011ba:	00 00 00 
  8011bd:	ff d0                	callq  *%rax
  8011bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011c6:	79 05                	jns    8011cd <devfile_stat+0x47>
		return r;
  8011c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011cb:	eb 56                	jmp    801223 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8011cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011d1:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8011d8:	00 00 00 
  8011db:	48 89 c7             	mov    %rax,%rdi
  8011de:	48 b8 4a 2b 80 00 00 	movabs $0x802b4a,%rax
  8011e5:	00 00 00 
  8011e8:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8011ea:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011f1:	00 00 00 
  8011f4:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8011fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011fe:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801204:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80120b:	00 00 00 
  80120e:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801214:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801218:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80121e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801223:	c9                   	leaveq 
  801224:	c3                   	retq   

0000000000801225 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801225:	55                   	push   %rbp
  801226:	48 89 e5             	mov    %rsp,%rbp
  801229:	48 83 ec 10          	sub    $0x10,%rsp
  80122d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801231:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801234:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801238:	8b 50 0c             	mov    0xc(%rax),%edx
  80123b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801242:	00 00 00 
  801245:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801247:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80124e:	00 00 00 
  801251:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801254:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801257:	be 00 00 00 00       	mov    $0x0,%esi
  80125c:	bf 02 00 00 00       	mov    $0x2,%edi
  801261:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  801268:	00 00 00 
  80126b:	ff d0                	callq  *%rax
}
  80126d:	c9                   	leaveq 
  80126e:	c3                   	retq   

000000000080126f <remove>:

// Delete a file
int
remove(const char *path)
{
  80126f:	55                   	push   %rbp
  801270:	48 89 e5             	mov    %rsp,%rbp
  801273:	48 83 ec 10          	sub    $0x10,%rsp
  801277:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80127b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127f:	48 89 c7             	mov    %rax,%rdi
  801282:	48 b8 de 2a 80 00 00 	movabs $0x802ade,%rax
  801289:	00 00 00 
  80128c:	ff d0                	callq  *%rax
  80128e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801293:	7e 07                	jle    80129c <remove+0x2d>
		return -E_BAD_PATH;
  801295:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80129a:	eb 33                	jmp    8012cf <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80129c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a0:	48 89 c6             	mov    %rax,%rsi
  8012a3:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8012aa:	00 00 00 
  8012ad:	48 b8 4a 2b 80 00 00 	movabs $0x802b4a,%rax
  8012b4:	00 00 00 
  8012b7:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8012b9:	be 00 00 00 00       	mov    $0x0,%esi
  8012be:	bf 07 00 00 00       	mov    $0x7,%edi
  8012c3:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  8012ca:	00 00 00 
  8012cd:	ff d0                	callq  *%rax
}
  8012cf:	c9                   	leaveq 
  8012d0:	c3                   	retq   

00000000008012d1 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8012d1:	55                   	push   %rbp
  8012d2:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8012d5:	be 00 00 00 00       	mov    $0x0,%esi
  8012da:	bf 08 00 00 00       	mov    $0x8,%edi
  8012df:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  8012e6:	00 00 00 
  8012e9:	ff d0                	callq  *%rax
}
  8012eb:	5d                   	pop    %rbp
  8012ec:	c3                   	retq   

00000000008012ed <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8012ed:	55                   	push   %rbp
  8012ee:	48 89 e5             	mov    %rsp,%rbp
  8012f1:	53                   	push   %rbx
  8012f2:	48 83 ec 38          	sub    $0x38,%rsp
  8012f6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8012fa:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8012fe:	48 89 c7             	mov    %rax,%rdi
  801301:	48 b8 bb 05 80 00 00 	movabs $0x8005bb,%rax
  801308:	00 00 00 
  80130b:	ff d0                	callq  *%rax
  80130d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801310:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801314:	0f 88 bf 01 00 00    	js     8014d9 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80131a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80131e:	ba 07 04 00 00       	mov    $0x407,%edx
  801323:	48 89 c6             	mov    %rax,%rsi
  801326:	bf 00 00 00 00       	mov    $0x0,%edi
  80132b:	48 b8 00 03 80 00 00 	movabs $0x800300,%rax
  801332:	00 00 00 
  801335:	ff d0                	callq  *%rax
  801337:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80133a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80133e:	0f 88 95 01 00 00    	js     8014d9 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801344:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801348:	48 89 c7             	mov    %rax,%rdi
  80134b:	48 b8 bb 05 80 00 00 	movabs $0x8005bb,%rax
  801352:	00 00 00 
  801355:	ff d0                	callq  *%rax
  801357:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80135a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80135e:	0f 88 5d 01 00 00    	js     8014c1 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801364:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801368:	ba 07 04 00 00       	mov    $0x407,%edx
  80136d:	48 89 c6             	mov    %rax,%rsi
  801370:	bf 00 00 00 00       	mov    $0x0,%edi
  801375:	48 b8 00 03 80 00 00 	movabs $0x800300,%rax
  80137c:	00 00 00 
  80137f:	ff d0                	callq  *%rax
  801381:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801384:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801388:	0f 88 33 01 00 00    	js     8014c1 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80138e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801392:	48 89 c7             	mov    %rax,%rdi
  801395:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  80139c:	00 00 00 
  80139f:	ff d0                	callq  *%rax
  8013a1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013a9:	ba 07 04 00 00       	mov    $0x407,%edx
  8013ae:	48 89 c6             	mov    %rax,%rsi
  8013b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8013b6:	48 b8 00 03 80 00 00 	movabs $0x800300,%rax
  8013bd:	00 00 00 
  8013c0:	ff d0                	callq  *%rax
  8013c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8013c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8013c9:	79 05                	jns    8013d0 <pipe+0xe3>
		goto err2;
  8013cb:	e9 d9 00 00 00       	jmpq   8014a9 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8013d4:	48 89 c7             	mov    %rax,%rdi
  8013d7:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  8013de:	00 00 00 
  8013e1:	ff d0                	callq  *%rax
  8013e3:	48 89 c2             	mov    %rax,%rdx
  8013e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013ea:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8013f0:	48 89 d1             	mov    %rdx,%rcx
  8013f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f8:	48 89 c6             	mov    %rax,%rsi
  8013fb:	bf 00 00 00 00       	mov    $0x0,%edi
  801400:	48 b8 50 03 80 00 00 	movabs $0x800350,%rax
  801407:	00 00 00 
  80140a:	ff d0                	callq  *%rax
  80140c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80140f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801413:	79 1b                	jns    801430 <pipe+0x143>
		goto err3;
  801415:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  801416:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80141a:	48 89 c6             	mov    %rax,%rsi
  80141d:	bf 00 00 00 00       	mov    $0x0,%edi
  801422:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  801429:	00 00 00 
  80142c:	ff d0                	callq  *%rax
  80142e:	eb 79                	jmp    8014a9 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801430:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801434:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  80143b:	00 00 00 
  80143e:	8b 12                	mov    (%rdx),%edx
  801440:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801442:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801446:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80144d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801451:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801458:	00 00 00 
  80145b:	8b 12                	mov    (%rdx),%edx
  80145d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80145f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801463:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80146a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146e:	48 89 c7             	mov    %rax,%rdi
  801471:	48 b8 6d 05 80 00 00 	movabs $0x80056d,%rax
  801478:	00 00 00 
  80147b:	ff d0                	callq  *%rax
  80147d:	89 c2                	mov    %eax,%edx
  80147f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801483:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801485:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801489:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80148d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801491:	48 89 c7             	mov    %rax,%rdi
  801494:	48 b8 6d 05 80 00 00 	movabs $0x80056d,%rax
  80149b:	00 00 00 
  80149e:	ff d0                	callq  *%rax
  8014a0:	89 03                	mov    %eax,(%rbx)
	return 0;
  8014a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a7:	eb 33                	jmp    8014dc <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8014a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014ad:	48 89 c6             	mov    %rax,%rsi
  8014b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8014b5:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  8014bc:	00 00 00 
  8014bf:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8014c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c5:	48 89 c6             	mov    %rax,%rsi
  8014c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8014cd:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  8014d4:	00 00 00 
  8014d7:	ff d0                	callq  *%rax
    err:
	return r;
  8014d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8014dc:	48 83 c4 38          	add    $0x38,%rsp
  8014e0:	5b                   	pop    %rbx
  8014e1:	5d                   	pop    %rbp
  8014e2:	c3                   	retq   

00000000008014e3 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8014e3:	55                   	push   %rbp
  8014e4:	48 89 e5             	mov    %rsp,%rbp
  8014e7:	53                   	push   %rbx
  8014e8:	48 83 ec 28          	sub    $0x28,%rsp
  8014ec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014f0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8014f4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8014fb:	00 00 00 
  8014fe:	48 8b 00             	mov    (%rax),%rax
  801501:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801507:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80150a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150e:	48 89 c7             	mov    %rax,%rdi
  801511:	48 b8 86 34 80 00 00 	movabs $0x803486,%rax
  801518:	00 00 00 
  80151b:	ff d0                	callq  *%rax
  80151d:	89 c3                	mov    %eax,%ebx
  80151f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801523:	48 89 c7             	mov    %rax,%rdi
  801526:	48 b8 86 34 80 00 00 	movabs $0x803486,%rax
  80152d:	00 00 00 
  801530:	ff d0                	callq  *%rax
  801532:	39 c3                	cmp    %eax,%ebx
  801534:	0f 94 c0             	sete   %al
  801537:	0f b6 c0             	movzbl %al,%eax
  80153a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80153d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801544:	00 00 00 
  801547:	48 8b 00             	mov    (%rax),%rax
  80154a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801550:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801553:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801556:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801559:	75 05                	jne    801560 <_pipeisclosed+0x7d>
			return ret;
  80155b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80155e:	eb 4f                	jmp    8015af <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  801560:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801563:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801566:	74 42                	je     8015aa <_pipeisclosed+0xc7>
  801568:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80156c:	75 3c                	jne    8015aa <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80156e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801575:	00 00 00 
  801578:	48 8b 00             	mov    (%rax),%rax
  80157b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801581:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801584:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801587:	89 c6                	mov    %eax,%esi
  801589:	48 bf e3 35 80 00 00 	movabs $0x8035e3,%rdi
  801590:	00 00 00 
  801593:	b8 00 00 00 00       	mov    $0x0,%eax
  801598:	49 b8 a2 1d 80 00 00 	movabs $0x801da2,%r8
  80159f:	00 00 00 
  8015a2:	41 ff d0             	callq  *%r8
	}
  8015a5:	e9 4a ff ff ff       	jmpq   8014f4 <_pipeisclosed+0x11>
  8015aa:	e9 45 ff ff ff       	jmpq   8014f4 <_pipeisclosed+0x11>
}
  8015af:	48 83 c4 28          	add    $0x28,%rsp
  8015b3:	5b                   	pop    %rbx
  8015b4:	5d                   	pop    %rbp
  8015b5:	c3                   	retq   

00000000008015b6 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8015b6:	55                   	push   %rbp
  8015b7:	48 89 e5             	mov    %rsp,%rbp
  8015ba:	48 83 ec 30          	sub    $0x30,%rsp
  8015be:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015c1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8015c5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015c8:	48 89 d6             	mov    %rdx,%rsi
  8015cb:	89 c7                	mov    %eax,%edi
  8015cd:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  8015d4:	00 00 00 
  8015d7:	ff d0                	callq  *%rax
  8015d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015e0:	79 05                	jns    8015e7 <pipeisclosed+0x31>
		return r;
  8015e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015e5:	eb 31                	jmp    801618 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8015e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015eb:	48 89 c7             	mov    %rax,%rdi
  8015ee:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  8015f5:	00 00 00 
  8015f8:	ff d0                	callq  *%rax
  8015fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8015fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801602:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801606:	48 89 d6             	mov    %rdx,%rsi
  801609:	48 89 c7             	mov    %rax,%rdi
  80160c:	48 b8 e3 14 80 00 00 	movabs $0x8014e3,%rax
  801613:	00 00 00 
  801616:	ff d0                	callq  *%rax
}
  801618:	c9                   	leaveq 
  801619:	c3                   	retq   

000000000080161a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80161a:	55                   	push   %rbp
  80161b:	48 89 e5             	mov    %rsp,%rbp
  80161e:	48 83 ec 40          	sub    $0x40,%rsp
  801622:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801626:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80162a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80162e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801632:	48 89 c7             	mov    %rax,%rdi
  801635:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  80163c:	00 00 00 
  80163f:	ff d0                	callq  *%rax
  801641:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801645:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801649:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80164d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801654:	00 
  801655:	e9 92 00 00 00       	jmpq   8016ec <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80165a:	eb 41                	jmp    80169d <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80165c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801661:	74 09                	je     80166c <devpipe_read+0x52>
				return i;
  801663:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801667:	e9 92 00 00 00       	jmpq   8016fe <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80166c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801674:	48 89 d6             	mov    %rdx,%rsi
  801677:	48 89 c7             	mov    %rax,%rdi
  80167a:	48 b8 e3 14 80 00 00 	movabs $0x8014e3,%rax
  801681:	00 00 00 
  801684:	ff d0                	callq  *%rax
  801686:	85 c0                	test   %eax,%eax
  801688:	74 07                	je     801691 <devpipe_read+0x77>
				return 0;
  80168a:	b8 00 00 00 00       	mov    $0x0,%eax
  80168f:	eb 6d                	jmp    8016fe <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801691:	48 b8 c2 02 80 00 00 	movabs $0x8002c2,%rax
  801698:	00 00 00 
  80169b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80169d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a1:	8b 10                	mov    (%rax),%edx
  8016a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a7:	8b 40 04             	mov    0x4(%rax),%eax
  8016aa:	39 c2                	cmp    %eax,%edx
  8016ac:	74 ae                	je     80165c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8016ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016b6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8016ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016be:	8b 00                	mov    (%rax),%eax
  8016c0:	99                   	cltd   
  8016c1:	c1 ea 1b             	shr    $0x1b,%edx
  8016c4:	01 d0                	add    %edx,%eax
  8016c6:	83 e0 1f             	and    $0x1f,%eax
  8016c9:	29 d0                	sub    %edx,%eax
  8016cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016cf:	48 98                	cltq   
  8016d1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8016d6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8016d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016dc:	8b 00                	mov    (%rax),%eax
  8016de:	8d 50 01             	lea    0x1(%rax),%edx
  8016e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8016e7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8016f4:	0f 82 60 ff ff ff    	jb     80165a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8016fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016fe:	c9                   	leaveq 
  8016ff:	c3                   	retq   

0000000000801700 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801700:	55                   	push   %rbp
  801701:	48 89 e5             	mov    %rsp,%rbp
  801704:	48 83 ec 40          	sub    $0x40,%rsp
  801708:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80170c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801710:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801714:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801718:	48 89 c7             	mov    %rax,%rdi
  80171b:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  801722:	00 00 00 
  801725:	ff d0                	callq  *%rax
  801727:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80172b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80172f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801733:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80173a:	00 
  80173b:	e9 8e 00 00 00       	jmpq   8017ce <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801740:	eb 31                	jmp    801773 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801742:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174a:	48 89 d6             	mov    %rdx,%rsi
  80174d:	48 89 c7             	mov    %rax,%rdi
  801750:	48 b8 e3 14 80 00 00 	movabs $0x8014e3,%rax
  801757:	00 00 00 
  80175a:	ff d0                	callq  *%rax
  80175c:	85 c0                	test   %eax,%eax
  80175e:	74 07                	je     801767 <devpipe_write+0x67>
				return 0;
  801760:	b8 00 00 00 00       	mov    $0x0,%eax
  801765:	eb 79                	jmp    8017e0 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801767:	48 b8 c2 02 80 00 00 	movabs $0x8002c2,%rax
  80176e:	00 00 00 
  801771:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801773:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801777:	8b 40 04             	mov    0x4(%rax),%eax
  80177a:	48 63 d0             	movslq %eax,%rdx
  80177d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801781:	8b 00                	mov    (%rax),%eax
  801783:	48 98                	cltq   
  801785:	48 83 c0 20          	add    $0x20,%rax
  801789:	48 39 c2             	cmp    %rax,%rdx
  80178c:	73 b4                	jae    801742 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80178e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801792:	8b 40 04             	mov    0x4(%rax),%eax
  801795:	99                   	cltd   
  801796:	c1 ea 1b             	shr    $0x1b,%edx
  801799:	01 d0                	add    %edx,%eax
  80179b:	83 e0 1f             	and    $0x1f,%eax
  80179e:	29 d0                	sub    %edx,%eax
  8017a0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017a4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8017a8:	48 01 ca             	add    %rcx,%rdx
  8017ab:	0f b6 0a             	movzbl (%rdx),%ecx
  8017ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017b2:	48 98                	cltq   
  8017b4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8017b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017bc:	8b 40 04             	mov    0x4(%rax),%eax
  8017bf:	8d 50 01             	lea    0x1(%rax),%edx
  8017c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c6:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8017c9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017d2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8017d6:	0f 82 64 ff ff ff    	jb     801740 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8017dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017e0:	c9                   	leaveq 
  8017e1:	c3                   	retq   

00000000008017e2 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8017e2:	55                   	push   %rbp
  8017e3:	48 89 e5             	mov    %rsp,%rbp
  8017e6:	48 83 ec 20          	sub    $0x20,%rsp
  8017ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8017f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f6:	48 89 c7             	mov    %rax,%rdi
  8017f9:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  801800:	00 00 00 
  801803:	ff d0                	callq  *%rax
  801805:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801809:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80180d:	48 be f6 35 80 00 00 	movabs $0x8035f6,%rsi
  801814:	00 00 00 
  801817:	48 89 c7             	mov    %rax,%rdi
  80181a:	48 b8 4a 2b 80 00 00 	movabs $0x802b4a,%rax
  801821:	00 00 00 
  801824:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801826:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80182a:	8b 50 04             	mov    0x4(%rax),%edx
  80182d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801831:	8b 00                	mov    (%rax),%eax
  801833:	29 c2                	sub    %eax,%edx
  801835:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801839:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80183f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801843:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80184a:	00 00 00 
	stat->st_dev = &devpipe;
  80184d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801851:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801858:	00 00 00 
  80185b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801862:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801867:	c9                   	leaveq 
  801868:	c3                   	retq   

0000000000801869 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801869:	55                   	push   %rbp
  80186a:	48 89 e5             	mov    %rsp,%rbp
  80186d:	48 83 ec 10          	sub    $0x10,%rsp
  801871:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801875:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801879:	48 89 c6             	mov    %rax,%rsi
  80187c:	bf 00 00 00 00       	mov    $0x0,%edi
  801881:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  801888:	00 00 00 
  80188b:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80188d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801891:	48 89 c7             	mov    %rax,%rdi
  801894:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  80189b:	00 00 00 
  80189e:	ff d0                	callq  *%rax
  8018a0:	48 89 c6             	mov    %rax,%rsi
  8018a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8018a8:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  8018af:	00 00 00 
  8018b2:	ff d0                	callq  *%rax
}
  8018b4:	c9                   	leaveq 
  8018b5:	c3                   	retq   

00000000008018b6 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8018b6:	55                   	push   %rbp
  8018b7:	48 89 e5             	mov    %rsp,%rbp
  8018ba:	48 83 ec 20          	sub    $0x20,%rsp
  8018be:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8018c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018c4:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8018c7:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8018cb:	be 01 00 00 00       	mov    $0x1,%esi
  8018d0:	48 89 c7             	mov    %rax,%rdi
  8018d3:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  8018da:	00 00 00 
  8018dd:	ff d0                	callq  *%rax
}
  8018df:	c9                   	leaveq 
  8018e0:	c3                   	retq   

00000000008018e1 <getchar>:

int
getchar(void)
{
  8018e1:	55                   	push   %rbp
  8018e2:	48 89 e5             	mov    %rsp,%rbp
  8018e5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8018e9:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8018ed:	ba 01 00 00 00       	mov    $0x1,%edx
  8018f2:	48 89 c6             	mov    %rax,%rsi
  8018f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8018fa:	48 b8 85 0a 80 00 00 	movabs $0x800a85,%rax
  801901:	00 00 00 
  801904:	ff d0                	callq  *%rax
  801906:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801909:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80190d:	79 05                	jns    801914 <getchar+0x33>
		return r;
  80190f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801912:	eb 14                	jmp    801928 <getchar+0x47>
	if (r < 1)
  801914:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801918:	7f 07                	jg     801921 <getchar+0x40>
		return -E_EOF;
  80191a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80191f:	eb 07                	jmp    801928 <getchar+0x47>
	return c;
  801921:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801925:	0f b6 c0             	movzbl %al,%eax
}
  801928:	c9                   	leaveq 
  801929:	c3                   	retq   

000000000080192a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80192a:	55                   	push   %rbp
  80192b:	48 89 e5             	mov    %rsp,%rbp
  80192e:	48 83 ec 20          	sub    $0x20,%rsp
  801932:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801935:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801939:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80193c:	48 89 d6             	mov    %rdx,%rsi
  80193f:	89 c7                	mov    %eax,%edi
  801941:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  801948:	00 00 00 
  80194b:	ff d0                	callq  *%rax
  80194d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801950:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801954:	79 05                	jns    80195b <iscons+0x31>
		return r;
  801956:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801959:	eb 1a                	jmp    801975 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80195b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80195f:	8b 10                	mov    (%rax),%edx
  801961:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801968:	00 00 00 
  80196b:	8b 00                	mov    (%rax),%eax
  80196d:	39 c2                	cmp    %eax,%edx
  80196f:	0f 94 c0             	sete   %al
  801972:	0f b6 c0             	movzbl %al,%eax
}
  801975:	c9                   	leaveq 
  801976:	c3                   	retq   

0000000000801977 <opencons>:

int
opencons(void)
{
  801977:	55                   	push   %rbp
  801978:	48 89 e5             	mov    %rsp,%rbp
  80197b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80197f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801983:	48 89 c7             	mov    %rax,%rdi
  801986:	48 b8 bb 05 80 00 00 	movabs $0x8005bb,%rax
  80198d:	00 00 00 
  801990:	ff d0                	callq  *%rax
  801992:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801995:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801999:	79 05                	jns    8019a0 <opencons+0x29>
		return r;
  80199b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80199e:	eb 5b                	jmp    8019fb <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8019a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a4:	ba 07 04 00 00       	mov    $0x407,%edx
  8019a9:	48 89 c6             	mov    %rax,%rsi
  8019ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8019b1:	48 b8 00 03 80 00 00 	movabs $0x800300,%rax
  8019b8:	00 00 00 
  8019bb:	ff d0                	callq  *%rax
  8019bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019c4:	79 05                	jns    8019cb <opencons+0x54>
		return r;
  8019c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019c9:	eb 30                	jmp    8019fb <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8019cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019cf:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8019d6:	00 00 00 
  8019d9:	8b 12                	mov    (%rdx),%edx
  8019db:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8019dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8019e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019ec:	48 89 c7             	mov    %rax,%rdi
  8019ef:	48 b8 6d 05 80 00 00 	movabs $0x80056d,%rax
  8019f6:	00 00 00 
  8019f9:	ff d0                	callq  *%rax
}
  8019fb:	c9                   	leaveq 
  8019fc:	c3                   	retq   

00000000008019fd <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8019fd:	55                   	push   %rbp
  8019fe:	48 89 e5             	mov    %rsp,%rbp
  801a01:	48 83 ec 30          	sub    $0x30,%rsp
  801a05:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a09:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a0d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801a11:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a16:	75 07                	jne    801a1f <devcons_read+0x22>
		return 0;
  801a18:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1d:	eb 4b                	jmp    801a6a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801a1f:	eb 0c                	jmp    801a2d <devcons_read+0x30>
		sys_yield();
  801a21:	48 b8 c2 02 80 00 00 	movabs $0x8002c2,%rax
  801a28:	00 00 00 
  801a2b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801a2d:	48 b8 02 02 80 00 00 	movabs $0x800202,%rax
  801a34:	00 00 00 
  801a37:	ff d0                	callq  *%rax
  801a39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a40:	74 df                	je     801a21 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801a42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a46:	79 05                	jns    801a4d <devcons_read+0x50>
		return c;
  801a48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a4b:	eb 1d                	jmp    801a6a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801a4d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801a51:	75 07                	jne    801a5a <devcons_read+0x5d>
		return 0;
  801a53:	b8 00 00 00 00       	mov    $0x0,%eax
  801a58:	eb 10                	jmp    801a6a <devcons_read+0x6d>
	*(char*)vbuf = c;
  801a5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a5d:	89 c2                	mov    %eax,%edx
  801a5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a63:	88 10                	mov    %dl,(%rax)
	return 1;
  801a65:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a6a:	c9                   	leaveq 
  801a6b:	c3                   	retq   

0000000000801a6c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801a6c:	55                   	push   %rbp
  801a6d:	48 89 e5             	mov    %rsp,%rbp
  801a70:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801a77:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801a7e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801a85:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801a8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801a93:	eb 76                	jmp    801b0b <devcons_write+0x9f>
		m = n - tot;
  801a95:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801a9c:	89 c2                	mov    %eax,%edx
  801a9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa1:	29 c2                	sub    %eax,%edx
  801aa3:	89 d0                	mov    %edx,%eax
  801aa5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801aa8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aab:	83 f8 7f             	cmp    $0x7f,%eax
  801aae:	76 07                	jbe    801ab7 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801ab0:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801ab7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aba:	48 63 d0             	movslq %eax,%rdx
  801abd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac0:	48 63 c8             	movslq %eax,%rcx
  801ac3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801aca:	48 01 c1             	add    %rax,%rcx
  801acd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801ad4:	48 89 ce             	mov    %rcx,%rsi
  801ad7:	48 89 c7             	mov    %rax,%rdi
  801ada:	48 b8 6e 2e 80 00 00 	movabs $0x802e6e,%rax
  801ae1:	00 00 00 
  801ae4:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801ae6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ae9:	48 63 d0             	movslq %eax,%rdx
  801aec:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801af3:	48 89 d6             	mov    %rdx,%rsi
  801af6:	48 89 c7             	mov    %rax,%rdi
  801af9:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801b00:	00 00 00 
  801b03:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801b05:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b08:	01 45 fc             	add    %eax,-0x4(%rbp)
  801b0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b0e:	48 98                	cltq   
  801b10:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801b17:	0f 82 78 ff ff ff    	jb     801a95 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801b1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801b20:	c9                   	leaveq 
  801b21:	c3                   	retq   

0000000000801b22 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801b22:	55                   	push   %rbp
  801b23:	48 89 e5             	mov    %rsp,%rbp
  801b26:	48 83 ec 08          	sub    $0x8,%rsp
  801b2a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801b2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b33:	c9                   	leaveq 
  801b34:	c3                   	retq   

0000000000801b35 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b35:	55                   	push   %rbp
  801b36:	48 89 e5             	mov    %rsp,%rbp
  801b39:	48 83 ec 10          	sub    $0x10,%rsp
  801b3d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b49:	48 be 02 36 80 00 00 	movabs $0x803602,%rsi
  801b50:	00 00 00 
  801b53:	48 89 c7             	mov    %rax,%rdi
  801b56:	48 b8 4a 2b 80 00 00 	movabs $0x802b4a,%rax
  801b5d:	00 00 00 
  801b60:	ff d0                	callq  *%rax
	return 0;
  801b62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b67:	c9                   	leaveq 
  801b68:	c3                   	retq   

0000000000801b69 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b69:	55                   	push   %rbp
  801b6a:	48 89 e5             	mov    %rsp,%rbp
  801b6d:	53                   	push   %rbx
  801b6e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801b75:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801b7c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801b82:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801b89:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801b90:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801b97:	84 c0                	test   %al,%al
  801b99:	74 23                	je     801bbe <_panic+0x55>
  801b9b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801ba2:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801ba6:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801baa:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801bae:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801bb2:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801bb6:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801bba:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801bbe:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801bc5:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801bcc:	00 00 00 
  801bcf:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801bd6:	00 00 00 
  801bd9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801bdd:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801be4:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801beb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801bf2:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801bf9:	00 00 00 
  801bfc:	48 8b 18             	mov    (%rax),%rbx
  801bff:	48 b8 84 02 80 00 00 	movabs $0x800284,%rax
  801c06:	00 00 00 
  801c09:	ff d0                	callq  *%rax
  801c0b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801c11:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801c18:	41 89 c8             	mov    %ecx,%r8d
  801c1b:	48 89 d1             	mov    %rdx,%rcx
  801c1e:	48 89 da             	mov    %rbx,%rdx
  801c21:	89 c6                	mov    %eax,%esi
  801c23:	48 bf 10 36 80 00 00 	movabs $0x803610,%rdi
  801c2a:	00 00 00 
  801c2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c32:	49 b9 a2 1d 80 00 00 	movabs $0x801da2,%r9
  801c39:	00 00 00 
  801c3c:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801c3f:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801c46:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801c4d:	48 89 d6             	mov    %rdx,%rsi
  801c50:	48 89 c7             	mov    %rax,%rdi
  801c53:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  801c5a:	00 00 00 
  801c5d:	ff d0                	callq  *%rax
	cprintf("\n");
  801c5f:	48 bf 33 36 80 00 00 	movabs $0x803633,%rdi
  801c66:	00 00 00 
  801c69:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6e:	48 ba a2 1d 80 00 00 	movabs $0x801da2,%rdx
  801c75:	00 00 00 
  801c78:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801c7a:	cc                   	int3   
  801c7b:	eb fd                	jmp    801c7a <_panic+0x111>

0000000000801c7d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801c7d:	55                   	push   %rbp
  801c7e:	48 89 e5             	mov    %rsp,%rbp
  801c81:	48 83 ec 10          	sub    $0x10,%rsp
  801c85:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c88:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  801c8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c90:	8b 00                	mov    (%rax),%eax
  801c92:	8d 48 01             	lea    0x1(%rax),%ecx
  801c95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c99:	89 0a                	mov    %ecx,(%rdx)
  801c9b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c9e:	89 d1                	mov    %edx,%ecx
  801ca0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca4:	48 98                	cltq   
  801ca6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  801caa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cae:	8b 00                	mov    (%rax),%eax
  801cb0:	3d ff 00 00 00       	cmp    $0xff,%eax
  801cb5:	75 2c                	jne    801ce3 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  801cb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cbb:	8b 00                	mov    (%rax),%eax
  801cbd:	48 98                	cltq   
  801cbf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cc3:	48 83 c2 08          	add    $0x8,%rdx
  801cc7:	48 89 c6             	mov    %rax,%rsi
  801cca:	48 89 d7             	mov    %rdx,%rdi
  801ccd:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801cd4:	00 00 00 
  801cd7:	ff d0                	callq  *%rax
		b->idx = 0;
  801cd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cdd:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  801ce3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce7:	8b 40 04             	mov    0x4(%rax),%eax
  801cea:	8d 50 01             	lea    0x1(%rax),%edx
  801ced:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cf1:	89 50 04             	mov    %edx,0x4(%rax)
}
  801cf4:	c9                   	leaveq 
  801cf5:	c3                   	retq   

0000000000801cf6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801cf6:	55                   	push   %rbp
  801cf7:	48 89 e5             	mov    %rsp,%rbp
  801cfa:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801d01:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801d08:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  801d0f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801d16:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801d1d:	48 8b 0a             	mov    (%rdx),%rcx
  801d20:	48 89 08             	mov    %rcx,(%rax)
  801d23:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801d27:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801d2b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801d2f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  801d33:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801d3a:	00 00 00 
	b.cnt = 0;
  801d3d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801d44:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  801d47:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  801d4e:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801d55:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  801d5c:	48 89 c6             	mov    %rax,%rsi
  801d5f:	48 bf 7d 1c 80 00 00 	movabs $0x801c7d,%rdi
  801d66:	00 00 00 
  801d69:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  801d70:	00 00 00 
  801d73:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  801d75:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  801d7b:	48 98                	cltq   
  801d7d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801d84:	48 83 c2 08          	add    $0x8,%rdx
  801d88:	48 89 c6             	mov    %rax,%rsi
  801d8b:	48 89 d7             	mov    %rdx,%rdi
  801d8e:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801d95:	00 00 00 
  801d98:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  801d9a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  801da0:	c9                   	leaveq 
  801da1:	c3                   	retq   

0000000000801da2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801da2:	55                   	push   %rbp
  801da3:	48 89 e5             	mov    %rsp,%rbp
  801da6:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  801dad:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  801db4:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  801dbb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801dc2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801dc9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801dd0:	84 c0                	test   %al,%al
  801dd2:	74 20                	je     801df4 <cprintf+0x52>
  801dd4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801dd8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801ddc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801de0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801de4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801de8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801dec:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801df0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801df4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  801dfb:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  801e02:	00 00 00 
  801e05:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801e0c:	00 00 00 
  801e0f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e13:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801e1a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801e21:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801e28:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801e2f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801e36:	48 8b 0a             	mov    (%rdx),%rcx
  801e39:	48 89 08             	mov    %rcx,(%rax)
  801e3c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801e40:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801e44:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801e48:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  801e4c:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  801e53:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801e5a:	48 89 d6             	mov    %rdx,%rsi
  801e5d:	48 89 c7             	mov    %rax,%rdi
  801e60:	48 b8 f6 1c 80 00 00 	movabs $0x801cf6,%rax
  801e67:	00 00 00 
  801e6a:	ff d0                	callq  *%rax
  801e6c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  801e72:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801e78:	c9                   	leaveq 
  801e79:	c3                   	retq   

0000000000801e7a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801e7a:	55                   	push   %rbp
  801e7b:	48 89 e5             	mov    %rsp,%rbp
  801e7e:	53                   	push   %rbx
  801e7f:	48 83 ec 38          	sub    $0x38,%rsp
  801e83:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801e87:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801e8b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801e8f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801e92:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  801e96:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801e9a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801e9d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801ea1:	77 3b                	ja     801ede <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801ea3:	8b 45 d0             	mov    -0x30(%rbp),%eax
  801ea6:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801eaa:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  801ead:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eb1:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb6:	48 f7 f3             	div    %rbx
  801eb9:	48 89 c2             	mov    %rax,%rdx
  801ebc:	8b 7d cc             	mov    -0x34(%rbp),%edi
  801ebf:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801ec2:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  801ec6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eca:	41 89 f9             	mov    %edi,%r9d
  801ecd:	48 89 c7             	mov    %rax,%rdi
  801ed0:	48 b8 7a 1e 80 00 00 	movabs $0x801e7a,%rax
  801ed7:	00 00 00 
  801eda:	ff d0                	callq  *%rax
  801edc:	eb 1e                	jmp    801efc <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801ede:	eb 12                	jmp    801ef2 <printnum+0x78>
			putch(padc, putdat);
  801ee0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801ee4:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801ee7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eeb:	48 89 ce             	mov    %rcx,%rsi
  801eee:	89 d7                	mov    %edx,%edi
  801ef0:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801ef2:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  801ef6:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  801efa:	7f e4                	jg     801ee0 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801efc:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801eff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f03:	ba 00 00 00 00       	mov    $0x0,%edx
  801f08:	48 f7 f1             	div    %rcx
  801f0b:	48 89 d0             	mov    %rdx,%rax
  801f0e:	48 ba 08 38 80 00 00 	movabs $0x803808,%rdx
  801f15:	00 00 00 
  801f18:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  801f1c:	0f be d0             	movsbl %al,%edx
  801f1f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801f23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f27:	48 89 ce             	mov    %rcx,%rsi
  801f2a:	89 d7                	mov    %edx,%edi
  801f2c:	ff d0                	callq  *%rax
}
  801f2e:	48 83 c4 38          	add    $0x38,%rsp
  801f32:	5b                   	pop    %rbx
  801f33:	5d                   	pop    %rbp
  801f34:	c3                   	retq   

0000000000801f35 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801f35:	55                   	push   %rbp
  801f36:	48 89 e5             	mov    %rsp,%rbp
  801f39:	48 83 ec 1c          	sub    $0x1c,%rsp
  801f3d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801f41:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  801f44:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801f48:	7e 52                	jle    801f9c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  801f4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4e:	8b 00                	mov    (%rax),%eax
  801f50:	83 f8 30             	cmp    $0x30,%eax
  801f53:	73 24                	jae    801f79 <getuint+0x44>
  801f55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f59:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801f5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f61:	8b 00                	mov    (%rax),%eax
  801f63:	89 c0                	mov    %eax,%eax
  801f65:	48 01 d0             	add    %rdx,%rax
  801f68:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f6c:	8b 12                	mov    (%rdx),%edx
  801f6e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801f71:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f75:	89 0a                	mov    %ecx,(%rdx)
  801f77:	eb 17                	jmp    801f90 <getuint+0x5b>
  801f79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f7d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801f81:	48 89 d0             	mov    %rdx,%rax
  801f84:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801f88:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f8c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801f90:	48 8b 00             	mov    (%rax),%rax
  801f93:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801f97:	e9 a3 00 00 00       	jmpq   80203f <getuint+0x10a>
	else if (lflag)
  801f9c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801fa0:	74 4f                	je     801ff1 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  801fa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa6:	8b 00                	mov    (%rax),%eax
  801fa8:	83 f8 30             	cmp    $0x30,%eax
  801fab:	73 24                	jae    801fd1 <getuint+0x9c>
  801fad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801fb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb9:	8b 00                	mov    (%rax),%eax
  801fbb:	89 c0                	mov    %eax,%eax
  801fbd:	48 01 d0             	add    %rdx,%rax
  801fc0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801fc4:	8b 12                	mov    (%rdx),%edx
  801fc6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801fc9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801fcd:	89 0a                	mov    %ecx,(%rdx)
  801fcf:	eb 17                	jmp    801fe8 <getuint+0xb3>
  801fd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801fd9:	48 89 d0             	mov    %rdx,%rax
  801fdc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801fe0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801fe4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801fe8:	48 8b 00             	mov    (%rax),%rax
  801feb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801fef:	eb 4e                	jmp    80203f <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  801ff1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ff5:	8b 00                	mov    (%rax),%eax
  801ff7:	83 f8 30             	cmp    $0x30,%eax
  801ffa:	73 24                	jae    802020 <getuint+0xeb>
  801ffc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802000:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802004:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802008:	8b 00                	mov    (%rax),%eax
  80200a:	89 c0                	mov    %eax,%eax
  80200c:	48 01 d0             	add    %rdx,%rax
  80200f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802013:	8b 12                	mov    (%rdx),%edx
  802015:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802018:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80201c:	89 0a                	mov    %ecx,(%rdx)
  80201e:	eb 17                	jmp    802037 <getuint+0x102>
  802020:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802024:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802028:	48 89 d0             	mov    %rdx,%rax
  80202b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80202f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802033:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802037:	8b 00                	mov    (%rax),%eax
  802039:	89 c0                	mov    %eax,%eax
  80203b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80203f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802043:	c9                   	leaveq 
  802044:	c3                   	retq   

0000000000802045 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802045:	55                   	push   %rbp
  802046:	48 89 e5             	mov    %rsp,%rbp
  802049:	48 83 ec 1c          	sub    $0x1c,%rsp
  80204d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802051:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802054:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802058:	7e 52                	jle    8020ac <getint+0x67>
		x=va_arg(*ap, long long);
  80205a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80205e:	8b 00                	mov    (%rax),%eax
  802060:	83 f8 30             	cmp    $0x30,%eax
  802063:	73 24                	jae    802089 <getint+0x44>
  802065:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802069:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80206d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802071:	8b 00                	mov    (%rax),%eax
  802073:	89 c0                	mov    %eax,%eax
  802075:	48 01 d0             	add    %rdx,%rax
  802078:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80207c:	8b 12                	mov    (%rdx),%edx
  80207e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802081:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802085:	89 0a                	mov    %ecx,(%rdx)
  802087:	eb 17                	jmp    8020a0 <getint+0x5b>
  802089:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80208d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802091:	48 89 d0             	mov    %rdx,%rax
  802094:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802098:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80209c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8020a0:	48 8b 00             	mov    (%rax),%rax
  8020a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8020a7:	e9 a3 00 00 00       	jmpq   80214f <getint+0x10a>
	else if (lflag)
  8020ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8020b0:	74 4f                	je     802101 <getint+0xbc>
		x=va_arg(*ap, long);
  8020b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b6:	8b 00                	mov    (%rax),%eax
  8020b8:	83 f8 30             	cmp    $0x30,%eax
  8020bb:	73 24                	jae    8020e1 <getint+0x9c>
  8020bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8020c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c9:	8b 00                	mov    (%rax),%eax
  8020cb:	89 c0                	mov    %eax,%eax
  8020cd:	48 01 d0             	add    %rdx,%rax
  8020d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020d4:	8b 12                	mov    (%rdx),%edx
  8020d6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8020d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020dd:	89 0a                	mov    %ecx,(%rdx)
  8020df:	eb 17                	jmp    8020f8 <getint+0xb3>
  8020e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8020e9:	48 89 d0             	mov    %rdx,%rax
  8020ec:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8020f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020f4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8020f8:	48 8b 00             	mov    (%rax),%rax
  8020fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8020ff:	eb 4e                	jmp    80214f <getint+0x10a>
	else
		x=va_arg(*ap, int);
  802101:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802105:	8b 00                	mov    (%rax),%eax
  802107:	83 f8 30             	cmp    $0x30,%eax
  80210a:	73 24                	jae    802130 <getint+0xeb>
  80210c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802110:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802114:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802118:	8b 00                	mov    (%rax),%eax
  80211a:	89 c0                	mov    %eax,%eax
  80211c:	48 01 d0             	add    %rdx,%rax
  80211f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802123:	8b 12                	mov    (%rdx),%edx
  802125:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802128:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80212c:	89 0a                	mov    %ecx,(%rdx)
  80212e:	eb 17                	jmp    802147 <getint+0x102>
  802130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802134:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802138:	48 89 d0             	mov    %rdx,%rax
  80213b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80213f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802143:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802147:	8b 00                	mov    (%rax),%eax
  802149:	48 98                	cltq   
  80214b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80214f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802153:	c9                   	leaveq 
  802154:	c3                   	retq   

0000000000802155 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802155:	55                   	push   %rbp
  802156:	48 89 e5             	mov    %rsp,%rbp
  802159:	41 54                	push   %r12
  80215b:	53                   	push   %rbx
  80215c:	48 83 ec 60          	sub    $0x60,%rsp
  802160:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802164:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802168:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80216c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802170:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802174:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802178:	48 8b 0a             	mov    (%rdx),%rcx
  80217b:	48 89 08             	mov    %rcx,(%rax)
  80217e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802182:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802186:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80218a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  80218e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802192:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802196:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80219a:	0f b6 00             	movzbl (%rax),%eax
  80219d:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  8021a0:	eb 29                	jmp    8021cb <vprintfmt+0x76>
			if (ch == '\0')
  8021a2:	85 db                	test   %ebx,%ebx
  8021a4:	0f 84 ad 06 00 00    	je     802857 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  8021aa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8021ae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8021b2:	48 89 d6             	mov    %rdx,%rsi
  8021b5:	89 df                	mov    %ebx,%edi
  8021b7:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  8021b9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8021bd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021c1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8021c5:	0f b6 00             	movzbl (%rax),%eax
  8021c8:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  8021cb:	83 fb 25             	cmp    $0x25,%ebx
  8021ce:	74 05                	je     8021d5 <vprintfmt+0x80>
  8021d0:	83 fb 1b             	cmp    $0x1b,%ebx
  8021d3:	75 cd                	jne    8021a2 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  8021d5:	83 fb 1b             	cmp    $0x1b,%ebx
  8021d8:	0f 85 ae 01 00 00    	jne    80238c <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  8021de:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  8021e5:	00 00 00 
  8021e8:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  8021ee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8021f2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8021f6:	48 89 d6             	mov    %rdx,%rsi
  8021f9:	89 df                	mov    %ebx,%edi
  8021fb:	ff d0                	callq  *%rax
			putch('[', putdat);
  8021fd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802201:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802205:	48 89 d6             	mov    %rdx,%rsi
  802208:	bf 5b 00 00 00       	mov    $0x5b,%edi
  80220d:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  80220f:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  802215:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80221a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80221e:	0f b6 00             	movzbl (%rax),%eax
  802221:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  802224:	eb 32                	jmp    802258 <vprintfmt+0x103>
					putch(ch, putdat);
  802226:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80222a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80222e:	48 89 d6             	mov    %rdx,%rsi
  802231:	89 df                	mov    %ebx,%edi
  802233:	ff d0                	callq  *%rax
					esc_color *= 10;
  802235:	44 89 e0             	mov    %r12d,%eax
  802238:	c1 e0 02             	shl    $0x2,%eax
  80223b:	44 01 e0             	add    %r12d,%eax
  80223e:	01 c0                	add    %eax,%eax
  802240:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  802243:	8d 43 d0             	lea    -0x30(%rbx),%eax
  802246:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  802249:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80224e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802252:	0f b6 00             	movzbl (%rax),%eax
  802255:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  802258:	83 fb 3b             	cmp    $0x3b,%ebx
  80225b:	74 05                	je     802262 <vprintfmt+0x10d>
  80225d:	83 fb 6d             	cmp    $0x6d,%ebx
  802260:	75 c4                	jne    802226 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  802262:	45 85 e4             	test   %r12d,%r12d
  802265:	75 15                	jne    80227c <vprintfmt+0x127>
					color_flag = 0x07;
  802267:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  80226e:	00 00 00 
  802271:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  802277:	e9 dc 00 00 00       	jmpq   802358 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  80227c:	41 83 fc 1d          	cmp    $0x1d,%r12d
  802280:	7e 69                	jle    8022eb <vprintfmt+0x196>
  802282:	41 83 fc 25          	cmp    $0x25,%r12d
  802286:	7f 63                	jg     8022eb <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  802288:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  80228f:	00 00 00 
  802292:	8b 00                	mov    (%rax),%eax
  802294:	25 f8 00 00 00       	and    $0xf8,%eax
  802299:	89 c2                	mov    %eax,%edx
  80229b:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  8022a2:	00 00 00 
  8022a5:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  8022a7:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  8022ab:	44 89 e0             	mov    %r12d,%eax
  8022ae:	83 e0 04             	and    $0x4,%eax
  8022b1:	c1 f8 02             	sar    $0x2,%eax
  8022b4:	89 c2                	mov    %eax,%edx
  8022b6:	44 89 e0             	mov    %r12d,%eax
  8022b9:	83 e0 02             	and    $0x2,%eax
  8022bc:	09 c2                	or     %eax,%edx
  8022be:	44 89 e0             	mov    %r12d,%eax
  8022c1:	83 e0 01             	and    $0x1,%eax
  8022c4:	c1 e0 02             	shl    $0x2,%eax
  8022c7:	09 c2                	or     %eax,%edx
  8022c9:	41 89 d4             	mov    %edx,%r12d
  8022cc:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  8022d3:	00 00 00 
  8022d6:	8b 00                	mov    (%rax),%eax
  8022d8:	44 89 e2             	mov    %r12d,%edx
  8022db:	09 c2                	or     %eax,%edx
  8022dd:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  8022e4:	00 00 00 
  8022e7:	89 10                	mov    %edx,(%rax)
  8022e9:	eb 6d                	jmp    802358 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  8022eb:	41 83 fc 27          	cmp    $0x27,%r12d
  8022ef:	7e 67                	jle    802358 <vprintfmt+0x203>
  8022f1:	41 83 fc 2f          	cmp    $0x2f,%r12d
  8022f5:	7f 61                	jg     802358 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  8022f7:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  8022fe:	00 00 00 
  802301:	8b 00                	mov    (%rax),%eax
  802303:	25 8f 00 00 00       	and    $0x8f,%eax
  802308:	89 c2                	mov    %eax,%edx
  80230a:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802311:	00 00 00 
  802314:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  802316:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  80231a:	44 89 e0             	mov    %r12d,%eax
  80231d:	83 e0 04             	and    $0x4,%eax
  802320:	c1 f8 02             	sar    $0x2,%eax
  802323:	89 c2                	mov    %eax,%edx
  802325:	44 89 e0             	mov    %r12d,%eax
  802328:	83 e0 02             	and    $0x2,%eax
  80232b:	09 c2                	or     %eax,%edx
  80232d:	44 89 e0             	mov    %r12d,%eax
  802330:	83 e0 01             	and    $0x1,%eax
  802333:	c1 e0 06             	shl    $0x6,%eax
  802336:	09 c2                	or     %eax,%edx
  802338:	41 89 d4             	mov    %edx,%r12d
  80233b:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802342:	00 00 00 
  802345:	8b 00                	mov    (%rax),%eax
  802347:	44 89 e2             	mov    %r12d,%edx
  80234a:	09 c2                	or     %eax,%edx
  80234c:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802353:	00 00 00 
  802356:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  802358:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80235c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802360:	48 89 d6             	mov    %rdx,%rsi
  802363:	89 df                	mov    %ebx,%edi
  802365:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  802367:	83 fb 6d             	cmp    $0x6d,%ebx
  80236a:	75 1b                	jne    802387 <vprintfmt+0x232>
					fmt ++;
  80236c:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  802371:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  802372:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802379:	00 00 00 
  80237c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  802382:	e9 cb 04 00 00       	jmpq   802852 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  802387:	e9 83 fe ff ff       	jmpq   80220f <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  80238c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802390:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802397:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80239e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8023a5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8023ac:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8023b0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8023b4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8023b8:	0f b6 00             	movzbl (%rax),%eax
  8023bb:	0f b6 d8             	movzbl %al,%ebx
  8023be:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8023c1:	83 f8 55             	cmp    $0x55,%eax
  8023c4:	0f 87 5a 04 00 00    	ja     802824 <vprintfmt+0x6cf>
  8023ca:	89 c0                	mov    %eax,%eax
  8023cc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8023d3:	00 
  8023d4:	48 b8 30 38 80 00 00 	movabs $0x803830,%rax
  8023db:	00 00 00 
  8023de:	48 01 d0             	add    %rdx,%rax
  8023e1:	48 8b 00             	mov    (%rax),%rax
  8023e4:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8023e6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8023ea:	eb c0                	jmp    8023ac <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8023ec:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8023f0:	eb ba                	jmp    8023ac <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8023f2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8023f9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8023fc:	89 d0                	mov    %edx,%eax
  8023fe:	c1 e0 02             	shl    $0x2,%eax
  802401:	01 d0                	add    %edx,%eax
  802403:	01 c0                	add    %eax,%eax
  802405:	01 d8                	add    %ebx,%eax
  802407:	83 e8 30             	sub    $0x30,%eax
  80240a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80240d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802411:	0f b6 00             	movzbl (%rax),%eax
  802414:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802417:	83 fb 2f             	cmp    $0x2f,%ebx
  80241a:	7e 0c                	jle    802428 <vprintfmt+0x2d3>
  80241c:	83 fb 39             	cmp    $0x39,%ebx
  80241f:	7f 07                	jg     802428 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802421:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802426:	eb d1                	jmp    8023f9 <vprintfmt+0x2a4>
			goto process_precision;
  802428:	eb 58                	jmp    802482 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  80242a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80242d:	83 f8 30             	cmp    $0x30,%eax
  802430:	73 17                	jae    802449 <vprintfmt+0x2f4>
  802432:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802436:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802439:	89 c0                	mov    %eax,%eax
  80243b:	48 01 d0             	add    %rdx,%rax
  80243e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802441:	83 c2 08             	add    $0x8,%edx
  802444:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802447:	eb 0f                	jmp    802458 <vprintfmt+0x303>
  802449:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80244d:	48 89 d0             	mov    %rdx,%rax
  802450:	48 83 c2 08          	add    $0x8,%rdx
  802454:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802458:	8b 00                	mov    (%rax),%eax
  80245a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80245d:	eb 23                	jmp    802482 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  80245f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802463:	79 0c                	jns    802471 <vprintfmt+0x31c>
				width = 0;
  802465:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80246c:	e9 3b ff ff ff       	jmpq   8023ac <vprintfmt+0x257>
  802471:	e9 36 ff ff ff       	jmpq   8023ac <vprintfmt+0x257>

		case '#':
			altflag = 1;
  802476:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80247d:	e9 2a ff ff ff       	jmpq   8023ac <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  802482:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802486:	79 12                	jns    80249a <vprintfmt+0x345>
				width = precision, precision = -1;
  802488:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80248b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80248e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802495:	e9 12 ff ff ff       	jmpq   8023ac <vprintfmt+0x257>
  80249a:	e9 0d ff ff ff       	jmpq   8023ac <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80249f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8024a3:	e9 04 ff ff ff       	jmpq   8023ac <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8024a8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024ab:	83 f8 30             	cmp    $0x30,%eax
  8024ae:	73 17                	jae    8024c7 <vprintfmt+0x372>
  8024b0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024b4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024b7:	89 c0                	mov    %eax,%eax
  8024b9:	48 01 d0             	add    %rdx,%rax
  8024bc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8024bf:	83 c2 08             	add    $0x8,%edx
  8024c2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8024c5:	eb 0f                	jmp    8024d6 <vprintfmt+0x381>
  8024c7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024cb:	48 89 d0             	mov    %rdx,%rax
  8024ce:	48 83 c2 08          	add    $0x8,%rdx
  8024d2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8024d6:	8b 10                	mov    (%rax),%edx
  8024d8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8024dc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8024e0:	48 89 ce             	mov    %rcx,%rsi
  8024e3:	89 d7                	mov    %edx,%edi
  8024e5:	ff d0                	callq  *%rax
			break;
  8024e7:	e9 66 03 00 00       	jmpq   802852 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8024ec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024ef:	83 f8 30             	cmp    $0x30,%eax
  8024f2:	73 17                	jae    80250b <vprintfmt+0x3b6>
  8024f4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024fb:	89 c0                	mov    %eax,%eax
  8024fd:	48 01 d0             	add    %rdx,%rax
  802500:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802503:	83 c2 08             	add    $0x8,%edx
  802506:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802509:	eb 0f                	jmp    80251a <vprintfmt+0x3c5>
  80250b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80250f:	48 89 d0             	mov    %rdx,%rax
  802512:	48 83 c2 08          	add    $0x8,%rdx
  802516:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80251a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80251c:	85 db                	test   %ebx,%ebx
  80251e:	79 02                	jns    802522 <vprintfmt+0x3cd>
				err = -err;
  802520:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802522:	83 fb 10             	cmp    $0x10,%ebx
  802525:	7f 16                	jg     80253d <vprintfmt+0x3e8>
  802527:	48 b8 80 37 80 00 00 	movabs $0x803780,%rax
  80252e:	00 00 00 
  802531:	48 63 d3             	movslq %ebx,%rdx
  802534:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802538:	4d 85 e4             	test   %r12,%r12
  80253b:	75 2e                	jne    80256b <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  80253d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802541:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802545:	89 d9                	mov    %ebx,%ecx
  802547:	48 ba 19 38 80 00 00 	movabs $0x803819,%rdx
  80254e:	00 00 00 
  802551:	48 89 c7             	mov    %rax,%rdi
  802554:	b8 00 00 00 00       	mov    $0x0,%eax
  802559:	49 b8 60 28 80 00 00 	movabs $0x802860,%r8
  802560:	00 00 00 
  802563:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802566:	e9 e7 02 00 00       	jmpq   802852 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80256b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80256f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802573:	4c 89 e1             	mov    %r12,%rcx
  802576:	48 ba 22 38 80 00 00 	movabs $0x803822,%rdx
  80257d:	00 00 00 
  802580:	48 89 c7             	mov    %rax,%rdi
  802583:	b8 00 00 00 00       	mov    $0x0,%eax
  802588:	49 b8 60 28 80 00 00 	movabs $0x802860,%r8
  80258f:	00 00 00 
  802592:	41 ff d0             	callq  *%r8
			break;
  802595:	e9 b8 02 00 00       	jmpq   802852 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80259a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80259d:	83 f8 30             	cmp    $0x30,%eax
  8025a0:	73 17                	jae    8025b9 <vprintfmt+0x464>
  8025a2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025a6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025a9:	89 c0                	mov    %eax,%eax
  8025ab:	48 01 d0             	add    %rdx,%rax
  8025ae:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025b1:	83 c2 08             	add    $0x8,%edx
  8025b4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025b7:	eb 0f                	jmp    8025c8 <vprintfmt+0x473>
  8025b9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025bd:	48 89 d0             	mov    %rdx,%rax
  8025c0:	48 83 c2 08          	add    $0x8,%rdx
  8025c4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025c8:	4c 8b 20             	mov    (%rax),%r12
  8025cb:	4d 85 e4             	test   %r12,%r12
  8025ce:	75 0a                	jne    8025da <vprintfmt+0x485>
				p = "(null)";
  8025d0:	49 bc 25 38 80 00 00 	movabs $0x803825,%r12
  8025d7:	00 00 00 
			if (width > 0 && padc != '-')
  8025da:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8025de:	7e 3f                	jle    80261f <vprintfmt+0x4ca>
  8025e0:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8025e4:	74 39                	je     80261f <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  8025e6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8025e9:	48 98                	cltq   
  8025eb:	48 89 c6             	mov    %rax,%rsi
  8025ee:	4c 89 e7             	mov    %r12,%rdi
  8025f1:	48 b8 0c 2b 80 00 00 	movabs $0x802b0c,%rax
  8025f8:	00 00 00 
  8025fb:	ff d0                	callq  *%rax
  8025fd:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802600:	eb 17                	jmp    802619 <vprintfmt+0x4c4>
					putch(padc, putdat);
  802602:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802606:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80260a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80260e:	48 89 ce             	mov    %rcx,%rsi
  802611:	89 d7                	mov    %edx,%edi
  802613:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802615:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802619:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80261d:	7f e3                	jg     802602 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80261f:	eb 37                	jmp    802658 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  802621:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802625:	74 1e                	je     802645 <vprintfmt+0x4f0>
  802627:	83 fb 1f             	cmp    $0x1f,%ebx
  80262a:	7e 05                	jle    802631 <vprintfmt+0x4dc>
  80262c:	83 fb 7e             	cmp    $0x7e,%ebx
  80262f:	7e 14                	jle    802645 <vprintfmt+0x4f0>
					putch('?', putdat);
  802631:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802635:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802639:	48 89 d6             	mov    %rdx,%rsi
  80263c:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802641:	ff d0                	callq  *%rax
  802643:	eb 0f                	jmp    802654 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  802645:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802649:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80264d:	48 89 d6             	mov    %rdx,%rsi
  802650:	89 df                	mov    %ebx,%edi
  802652:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802654:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802658:	4c 89 e0             	mov    %r12,%rax
  80265b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80265f:	0f b6 00             	movzbl (%rax),%eax
  802662:	0f be d8             	movsbl %al,%ebx
  802665:	85 db                	test   %ebx,%ebx
  802667:	74 10                	je     802679 <vprintfmt+0x524>
  802669:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80266d:	78 b2                	js     802621 <vprintfmt+0x4cc>
  80266f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802673:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802677:	79 a8                	jns    802621 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802679:	eb 16                	jmp    802691 <vprintfmt+0x53c>
				putch(' ', putdat);
  80267b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80267f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802683:	48 89 d6             	mov    %rdx,%rsi
  802686:	bf 20 00 00 00       	mov    $0x20,%edi
  80268b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80268d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802691:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802695:	7f e4                	jg     80267b <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  802697:	e9 b6 01 00 00       	jmpq   802852 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80269c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8026a0:	be 03 00 00 00       	mov    $0x3,%esi
  8026a5:	48 89 c7             	mov    %rax,%rdi
  8026a8:	48 b8 45 20 80 00 00 	movabs $0x802045,%rax
  8026af:	00 00 00 
  8026b2:	ff d0                	callq  *%rax
  8026b4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8026b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026bc:	48 85 c0             	test   %rax,%rax
  8026bf:	79 1d                	jns    8026de <vprintfmt+0x589>
				putch('-', putdat);
  8026c1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8026c5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026c9:	48 89 d6             	mov    %rdx,%rsi
  8026cc:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8026d1:	ff d0                	callq  *%rax
				num = -(long long) num;
  8026d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d7:	48 f7 d8             	neg    %rax
  8026da:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8026de:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8026e5:	e9 fb 00 00 00       	jmpq   8027e5 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8026ea:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8026ee:	be 03 00 00 00       	mov    $0x3,%esi
  8026f3:	48 89 c7             	mov    %rax,%rdi
  8026f6:	48 b8 35 1f 80 00 00 	movabs $0x801f35,%rax
  8026fd:	00 00 00 
  802700:	ff d0                	callq  *%rax
  802702:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  802706:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80270d:	e9 d3 00 00 00       	jmpq   8027e5 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  802712:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802716:	be 03 00 00 00       	mov    $0x3,%esi
  80271b:	48 89 c7             	mov    %rax,%rdi
  80271e:	48 b8 45 20 80 00 00 	movabs $0x802045,%rax
  802725:	00 00 00 
  802728:	ff d0                	callq  *%rax
  80272a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80272e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802732:	48 85 c0             	test   %rax,%rax
  802735:	79 1d                	jns    802754 <vprintfmt+0x5ff>
				putch('-', putdat);
  802737:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80273b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80273f:	48 89 d6             	mov    %rdx,%rsi
  802742:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802747:	ff d0                	callq  *%rax
				num = -(long long) num;
  802749:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274d:	48 f7 d8             	neg    %rax
  802750:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  802754:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80275b:	e9 85 00 00 00       	jmpq   8027e5 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  802760:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802764:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802768:	48 89 d6             	mov    %rdx,%rsi
  80276b:	bf 30 00 00 00       	mov    $0x30,%edi
  802770:	ff d0                	callq  *%rax
			putch('x', putdat);
  802772:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802776:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80277a:	48 89 d6             	mov    %rdx,%rsi
  80277d:	bf 78 00 00 00       	mov    $0x78,%edi
  802782:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  802784:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802787:	83 f8 30             	cmp    $0x30,%eax
  80278a:	73 17                	jae    8027a3 <vprintfmt+0x64e>
  80278c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802790:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802793:	89 c0                	mov    %eax,%eax
  802795:	48 01 d0             	add    %rdx,%rax
  802798:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80279b:	83 c2 08             	add    $0x8,%edx
  80279e:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8027a1:	eb 0f                	jmp    8027b2 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  8027a3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8027a7:	48 89 d0             	mov    %rdx,%rax
  8027aa:	48 83 c2 08          	add    $0x8,%rdx
  8027ae:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8027b2:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8027b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8027b9:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8027c0:	eb 23                	jmp    8027e5 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8027c2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027c6:	be 03 00 00 00       	mov    $0x3,%esi
  8027cb:	48 89 c7             	mov    %rax,%rdi
  8027ce:	48 b8 35 1f 80 00 00 	movabs $0x801f35,%rax
  8027d5:	00 00 00 
  8027d8:	ff d0                	callq  *%rax
  8027da:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8027de:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8027e5:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8027ea:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8027ed:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8027f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027f4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8027f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027fc:	45 89 c1             	mov    %r8d,%r9d
  8027ff:	41 89 f8             	mov    %edi,%r8d
  802802:	48 89 c7             	mov    %rax,%rdi
  802805:	48 b8 7a 1e 80 00 00 	movabs $0x801e7a,%rax
  80280c:	00 00 00 
  80280f:	ff d0                	callq  *%rax
			break;
  802811:	eb 3f                	jmp    802852 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802813:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802817:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80281b:	48 89 d6             	mov    %rdx,%rsi
  80281e:	89 df                	mov    %ebx,%edi
  802820:	ff d0                	callq  *%rax
			break;
  802822:	eb 2e                	jmp    802852 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802824:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802828:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80282c:	48 89 d6             	mov    %rdx,%rsi
  80282f:	bf 25 00 00 00       	mov    $0x25,%edi
  802834:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  802836:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80283b:	eb 05                	jmp    802842 <vprintfmt+0x6ed>
  80283d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802842:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802846:	48 83 e8 01          	sub    $0x1,%rax
  80284a:	0f b6 00             	movzbl (%rax),%eax
  80284d:	3c 25                	cmp    $0x25,%al
  80284f:	75 ec                	jne    80283d <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  802851:	90                   	nop
		}
	}
  802852:	e9 37 f9 ff ff       	jmpq   80218e <vprintfmt+0x39>
    va_end(aq);
}
  802857:	48 83 c4 60          	add    $0x60,%rsp
  80285b:	5b                   	pop    %rbx
  80285c:	41 5c                	pop    %r12
  80285e:	5d                   	pop    %rbp
  80285f:	c3                   	retq   

0000000000802860 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802860:	55                   	push   %rbp
  802861:	48 89 e5             	mov    %rsp,%rbp
  802864:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80286b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  802872:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802879:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802880:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802887:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80288e:	84 c0                	test   %al,%al
  802890:	74 20                	je     8028b2 <printfmt+0x52>
  802892:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802896:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80289a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80289e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8028a2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8028a6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8028aa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8028ae:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8028b2:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8028b9:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8028c0:	00 00 00 
  8028c3:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8028ca:	00 00 00 
  8028cd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8028d1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8028d8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8028df:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8028e6:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8028ed:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8028f4:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8028fb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802902:	48 89 c7             	mov    %rax,%rdi
  802905:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  80290c:	00 00 00 
  80290f:	ff d0                	callq  *%rax
	va_end(ap);
}
  802911:	c9                   	leaveq 
  802912:	c3                   	retq   

0000000000802913 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802913:	55                   	push   %rbp
  802914:	48 89 e5             	mov    %rsp,%rbp
  802917:	48 83 ec 10          	sub    $0x10,%rsp
  80291b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80291e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  802922:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802926:	8b 40 10             	mov    0x10(%rax),%eax
  802929:	8d 50 01             	lea    0x1(%rax),%edx
  80292c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802930:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  802933:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802937:	48 8b 10             	mov    (%rax),%rdx
  80293a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80293e:	48 8b 40 08          	mov    0x8(%rax),%rax
  802942:	48 39 c2             	cmp    %rax,%rdx
  802945:	73 17                	jae    80295e <sprintputch+0x4b>
		*b->buf++ = ch;
  802947:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80294b:	48 8b 00             	mov    (%rax),%rax
  80294e:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802952:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802956:	48 89 0a             	mov    %rcx,(%rdx)
  802959:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80295c:	88 10                	mov    %dl,(%rax)
}
  80295e:	c9                   	leaveq 
  80295f:	c3                   	retq   

0000000000802960 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802960:	55                   	push   %rbp
  802961:	48 89 e5             	mov    %rsp,%rbp
  802964:	48 83 ec 50          	sub    $0x50,%rsp
  802968:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80296c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80296f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802973:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802977:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80297b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80297f:	48 8b 0a             	mov    (%rdx),%rcx
  802982:	48 89 08             	mov    %rcx,(%rax)
  802985:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802989:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80298d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802991:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802995:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802999:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80299d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8029a0:	48 98                	cltq   
  8029a2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8029a6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029aa:	48 01 d0             	add    %rdx,%rax
  8029ad:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8029b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8029b8:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8029bd:	74 06                	je     8029c5 <vsnprintf+0x65>
  8029bf:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8029c3:	7f 07                	jg     8029cc <vsnprintf+0x6c>
		return -E_INVAL;
  8029c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029ca:	eb 2f                	jmp    8029fb <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8029cc:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8029d0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8029d4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8029d8:	48 89 c6             	mov    %rax,%rsi
  8029db:	48 bf 13 29 80 00 00 	movabs $0x802913,%rdi
  8029e2:	00 00 00 
  8029e5:	48 b8 55 21 80 00 00 	movabs $0x802155,%rax
  8029ec:	00 00 00 
  8029ef:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8029f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029f5:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8029f8:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8029fb:	c9                   	leaveq 
  8029fc:	c3                   	retq   

00000000008029fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8029fd:	55                   	push   %rbp
  8029fe:	48 89 e5             	mov    %rsp,%rbp
  802a01:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802a08:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802a0f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802a15:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802a1c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802a23:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802a2a:	84 c0                	test   %al,%al
  802a2c:	74 20                	je     802a4e <snprintf+0x51>
  802a2e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802a32:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802a36:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802a3a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802a3e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802a42:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802a46:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802a4a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802a4e:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802a55:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802a5c:	00 00 00 
  802a5f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802a66:	00 00 00 
  802a69:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802a6d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802a74:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802a7b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802a82:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802a89:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802a90:	48 8b 0a             	mov    (%rdx),%rcx
  802a93:	48 89 08             	mov    %rcx,(%rax)
  802a96:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a9a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a9e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802aa2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802aa6:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802aad:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802ab4:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802aba:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802ac1:	48 89 c7             	mov    %rax,%rdi
  802ac4:	48 b8 60 29 80 00 00 	movabs $0x802960,%rax
  802acb:	00 00 00 
  802ace:	ff d0                	callq  *%rax
  802ad0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802ad6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802adc:	c9                   	leaveq 
  802add:	c3                   	retq   

0000000000802ade <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802ade:	55                   	push   %rbp
  802adf:	48 89 e5             	mov    %rsp,%rbp
  802ae2:	48 83 ec 18          	sub    $0x18,%rsp
  802ae6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802aea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802af1:	eb 09                	jmp    802afc <strlen+0x1e>
		n++;
  802af3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802af7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802afc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b00:	0f b6 00             	movzbl (%rax),%eax
  802b03:	84 c0                	test   %al,%al
  802b05:	75 ec                	jne    802af3 <strlen+0x15>
		n++;
	return n;
  802b07:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b0a:	c9                   	leaveq 
  802b0b:	c3                   	retq   

0000000000802b0c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802b0c:	55                   	push   %rbp
  802b0d:	48 89 e5             	mov    %rsp,%rbp
  802b10:	48 83 ec 20          	sub    $0x20,%rsp
  802b14:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b18:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802b1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b23:	eb 0e                	jmp    802b33 <strnlen+0x27>
		n++;
  802b25:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802b29:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802b2e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802b33:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802b38:	74 0b                	je     802b45 <strnlen+0x39>
  802b3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3e:	0f b6 00             	movzbl (%rax),%eax
  802b41:	84 c0                	test   %al,%al
  802b43:	75 e0                	jne    802b25 <strnlen+0x19>
		n++;
	return n;
  802b45:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b48:	c9                   	leaveq 
  802b49:	c3                   	retq   

0000000000802b4a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802b4a:	55                   	push   %rbp
  802b4b:	48 89 e5             	mov    %rsp,%rbp
  802b4e:	48 83 ec 20          	sub    $0x20,%rsp
  802b52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802b62:	90                   	nop
  802b63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b67:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802b6b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802b6f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b73:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802b77:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802b7b:	0f b6 12             	movzbl (%rdx),%edx
  802b7e:	88 10                	mov    %dl,(%rax)
  802b80:	0f b6 00             	movzbl (%rax),%eax
  802b83:	84 c0                	test   %al,%al
  802b85:	75 dc                	jne    802b63 <strcpy+0x19>
		/* do nothing */;
	return ret;
  802b87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802b8b:	c9                   	leaveq 
  802b8c:	c3                   	retq   

0000000000802b8d <strcat>:

char *
strcat(char *dst, const char *src)
{
  802b8d:	55                   	push   %rbp
  802b8e:	48 89 e5             	mov    %rsp,%rbp
  802b91:	48 83 ec 20          	sub    $0x20,%rsp
  802b95:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b99:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802b9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba1:	48 89 c7             	mov    %rax,%rdi
  802ba4:	48 b8 de 2a 80 00 00 	movabs $0x802ade,%rax
  802bab:	00 00 00 
  802bae:	ff d0                	callq  *%rax
  802bb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802bb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb6:	48 63 d0             	movslq %eax,%rdx
  802bb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bbd:	48 01 c2             	add    %rax,%rdx
  802bc0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bc4:	48 89 c6             	mov    %rax,%rsi
  802bc7:	48 89 d7             	mov    %rdx,%rdi
  802bca:	48 b8 4a 2b 80 00 00 	movabs $0x802b4a,%rax
  802bd1:	00 00 00 
  802bd4:	ff d0                	callq  *%rax
	return dst;
  802bd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802bda:	c9                   	leaveq 
  802bdb:	c3                   	retq   

0000000000802bdc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802bdc:	55                   	push   %rbp
  802bdd:	48 89 e5             	mov    %rsp,%rbp
  802be0:	48 83 ec 28          	sub    $0x28,%rsp
  802be4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802be8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802bf0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802bf8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802bff:	00 
  802c00:	eb 2a                	jmp    802c2c <strncpy+0x50>
		*dst++ = *src;
  802c02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c06:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c0a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c0e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c12:	0f b6 12             	movzbl (%rdx),%edx
  802c15:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802c17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c1b:	0f b6 00             	movzbl (%rax),%eax
  802c1e:	84 c0                	test   %al,%al
  802c20:	74 05                	je     802c27 <strncpy+0x4b>
			src++;
  802c22:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802c27:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802c2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c30:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c34:	72 cc                	jb     802c02 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802c36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802c3a:	c9                   	leaveq 
  802c3b:	c3                   	retq   

0000000000802c3c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802c3c:	55                   	push   %rbp
  802c3d:	48 89 e5             	mov    %rsp,%rbp
  802c40:	48 83 ec 28          	sub    $0x28,%rsp
  802c44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c48:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c4c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802c50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c54:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802c58:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802c5d:	74 3d                	je     802c9c <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802c5f:	eb 1d                	jmp    802c7e <strlcpy+0x42>
			*dst++ = *src++;
  802c61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c65:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c69:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c6d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c71:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802c75:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802c79:	0f b6 12             	movzbl (%rdx),%edx
  802c7c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802c7e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802c83:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802c88:	74 0b                	je     802c95 <strlcpy+0x59>
  802c8a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c8e:	0f b6 00             	movzbl (%rax),%eax
  802c91:	84 c0                	test   %al,%al
  802c93:	75 cc                	jne    802c61 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802c95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c99:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802c9c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ca0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ca4:	48 29 c2             	sub    %rax,%rdx
  802ca7:	48 89 d0             	mov    %rdx,%rax
}
  802caa:	c9                   	leaveq 
  802cab:	c3                   	retq   

0000000000802cac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802cac:	55                   	push   %rbp
  802cad:	48 89 e5             	mov    %rsp,%rbp
  802cb0:	48 83 ec 10          	sub    $0x10,%rsp
  802cb4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802cb8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802cbc:	eb 0a                	jmp    802cc8 <strcmp+0x1c>
		p++, q++;
  802cbe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802cc3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802cc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ccc:	0f b6 00             	movzbl (%rax),%eax
  802ccf:	84 c0                	test   %al,%al
  802cd1:	74 12                	je     802ce5 <strcmp+0x39>
  802cd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cd7:	0f b6 10             	movzbl (%rax),%edx
  802cda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cde:	0f b6 00             	movzbl (%rax),%eax
  802ce1:	38 c2                	cmp    %al,%dl
  802ce3:	74 d9                	je     802cbe <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802ce5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ce9:	0f b6 00             	movzbl (%rax),%eax
  802cec:	0f b6 d0             	movzbl %al,%edx
  802cef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf3:	0f b6 00             	movzbl (%rax),%eax
  802cf6:	0f b6 c0             	movzbl %al,%eax
  802cf9:	29 c2                	sub    %eax,%edx
  802cfb:	89 d0                	mov    %edx,%eax
}
  802cfd:	c9                   	leaveq 
  802cfe:	c3                   	retq   

0000000000802cff <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802cff:	55                   	push   %rbp
  802d00:	48 89 e5             	mov    %rsp,%rbp
  802d03:	48 83 ec 18          	sub    $0x18,%rsp
  802d07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d0f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802d13:	eb 0f                	jmp    802d24 <strncmp+0x25>
		n--, p++, q++;
  802d15:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802d1a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d1f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802d24:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d29:	74 1d                	je     802d48 <strncmp+0x49>
  802d2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d2f:	0f b6 00             	movzbl (%rax),%eax
  802d32:	84 c0                	test   %al,%al
  802d34:	74 12                	je     802d48 <strncmp+0x49>
  802d36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d3a:	0f b6 10             	movzbl (%rax),%edx
  802d3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d41:	0f b6 00             	movzbl (%rax),%eax
  802d44:	38 c2                	cmp    %al,%dl
  802d46:	74 cd                	je     802d15 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802d48:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d4d:	75 07                	jne    802d56 <strncmp+0x57>
		return 0;
  802d4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d54:	eb 18                	jmp    802d6e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802d56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d5a:	0f b6 00             	movzbl (%rax),%eax
  802d5d:	0f b6 d0             	movzbl %al,%edx
  802d60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d64:	0f b6 00             	movzbl (%rax),%eax
  802d67:	0f b6 c0             	movzbl %al,%eax
  802d6a:	29 c2                	sub    %eax,%edx
  802d6c:	89 d0                	mov    %edx,%eax
}
  802d6e:	c9                   	leaveq 
  802d6f:	c3                   	retq   

0000000000802d70 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802d70:	55                   	push   %rbp
  802d71:	48 89 e5             	mov    %rsp,%rbp
  802d74:	48 83 ec 0c          	sub    $0xc,%rsp
  802d78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d7c:	89 f0                	mov    %esi,%eax
  802d7e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802d81:	eb 17                	jmp    802d9a <strchr+0x2a>
		if (*s == c)
  802d83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d87:	0f b6 00             	movzbl (%rax),%eax
  802d8a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802d8d:	75 06                	jne    802d95 <strchr+0x25>
			return (char *) s;
  802d8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d93:	eb 15                	jmp    802daa <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802d95:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d9e:	0f b6 00             	movzbl (%rax),%eax
  802da1:	84 c0                	test   %al,%al
  802da3:	75 de                	jne    802d83 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802da5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802daa:	c9                   	leaveq 
  802dab:	c3                   	retq   

0000000000802dac <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802dac:	55                   	push   %rbp
  802dad:	48 89 e5             	mov    %rsp,%rbp
  802db0:	48 83 ec 0c          	sub    $0xc,%rsp
  802db4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802db8:	89 f0                	mov    %esi,%eax
  802dba:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802dbd:	eb 13                	jmp    802dd2 <strfind+0x26>
		if (*s == c)
  802dbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dc3:	0f b6 00             	movzbl (%rax),%eax
  802dc6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802dc9:	75 02                	jne    802dcd <strfind+0x21>
			break;
  802dcb:	eb 10                	jmp    802ddd <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802dcd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802dd2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dd6:	0f b6 00             	movzbl (%rax),%eax
  802dd9:	84 c0                	test   %al,%al
  802ddb:	75 e2                	jne    802dbf <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802ddd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802de1:	c9                   	leaveq 
  802de2:	c3                   	retq   

0000000000802de3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802de3:	55                   	push   %rbp
  802de4:	48 89 e5             	mov    %rsp,%rbp
  802de7:	48 83 ec 18          	sub    $0x18,%rsp
  802deb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802def:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802df2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802df6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802dfb:	75 06                	jne    802e03 <memset+0x20>
		return v;
  802dfd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e01:	eb 69                	jmp    802e6c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802e03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e07:	83 e0 03             	and    $0x3,%eax
  802e0a:	48 85 c0             	test   %rax,%rax
  802e0d:	75 48                	jne    802e57 <memset+0x74>
  802e0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e13:	83 e0 03             	and    $0x3,%eax
  802e16:	48 85 c0             	test   %rax,%rax
  802e19:	75 3c                	jne    802e57 <memset+0x74>
		c &= 0xFF;
  802e1b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802e22:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e25:	c1 e0 18             	shl    $0x18,%eax
  802e28:	89 c2                	mov    %eax,%edx
  802e2a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e2d:	c1 e0 10             	shl    $0x10,%eax
  802e30:	09 c2                	or     %eax,%edx
  802e32:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e35:	c1 e0 08             	shl    $0x8,%eax
  802e38:	09 d0                	or     %edx,%eax
  802e3a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  802e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e41:	48 c1 e8 02          	shr    $0x2,%rax
  802e45:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802e48:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e4c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e4f:	48 89 d7             	mov    %rdx,%rdi
  802e52:	fc                   	cld    
  802e53:	f3 ab                	rep stos %eax,%es:(%rdi)
  802e55:	eb 11                	jmp    802e68 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802e57:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e5b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e5e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e62:	48 89 d7             	mov    %rdx,%rdi
  802e65:	fc                   	cld    
  802e66:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  802e68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e6c:	c9                   	leaveq 
  802e6d:	c3                   	retq   

0000000000802e6e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802e6e:	55                   	push   %rbp
  802e6f:	48 89 e5             	mov    %rsp,%rbp
  802e72:	48 83 ec 28          	sub    $0x28,%rsp
  802e76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e7a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e7e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802e82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e86:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802e8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e8e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802e92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e96:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802e9a:	0f 83 88 00 00 00    	jae    802f28 <memmove+0xba>
  802ea0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ea4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ea8:	48 01 d0             	add    %rdx,%rax
  802eab:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802eaf:	76 77                	jbe    802f28 <memmove+0xba>
		s += n;
  802eb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eb5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802eb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ebd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802ec1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ec5:	83 e0 03             	and    $0x3,%eax
  802ec8:	48 85 c0             	test   %rax,%rax
  802ecb:	75 3b                	jne    802f08 <memmove+0x9a>
  802ecd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed1:	83 e0 03             	and    $0x3,%eax
  802ed4:	48 85 c0             	test   %rax,%rax
  802ed7:	75 2f                	jne    802f08 <memmove+0x9a>
  802ed9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802edd:	83 e0 03             	and    $0x3,%eax
  802ee0:	48 85 c0             	test   %rax,%rax
  802ee3:	75 23                	jne    802f08 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802ee5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee9:	48 83 e8 04          	sub    $0x4,%rax
  802eed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ef1:	48 83 ea 04          	sub    $0x4,%rdx
  802ef5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802ef9:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802efd:	48 89 c7             	mov    %rax,%rdi
  802f00:	48 89 d6             	mov    %rdx,%rsi
  802f03:	fd                   	std    
  802f04:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802f06:	eb 1d                	jmp    802f25 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802f08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f0c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802f10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f14:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802f18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f1c:	48 89 d7             	mov    %rdx,%rdi
  802f1f:	48 89 c1             	mov    %rax,%rcx
  802f22:	fd                   	std    
  802f23:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802f25:	fc                   	cld    
  802f26:	eb 57                	jmp    802f7f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802f28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f2c:	83 e0 03             	and    $0x3,%eax
  802f2f:	48 85 c0             	test   %rax,%rax
  802f32:	75 36                	jne    802f6a <memmove+0xfc>
  802f34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f38:	83 e0 03             	and    $0x3,%eax
  802f3b:	48 85 c0             	test   %rax,%rax
  802f3e:	75 2a                	jne    802f6a <memmove+0xfc>
  802f40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f44:	83 e0 03             	and    $0x3,%eax
  802f47:	48 85 c0             	test   %rax,%rax
  802f4a:	75 1e                	jne    802f6a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802f4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f50:	48 c1 e8 02          	shr    $0x2,%rax
  802f54:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  802f57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f5b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f5f:	48 89 c7             	mov    %rax,%rdi
  802f62:	48 89 d6             	mov    %rdx,%rsi
  802f65:	fc                   	cld    
  802f66:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802f68:	eb 15                	jmp    802f7f <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802f6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f6e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f72:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802f76:	48 89 c7             	mov    %rax,%rdi
  802f79:	48 89 d6             	mov    %rdx,%rsi
  802f7c:	fc                   	cld    
  802f7d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  802f7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802f83:	c9                   	leaveq 
  802f84:	c3                   	retq   

0000000000802f85 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802f85:	55                   	push   %rbp
  802f86:	48 89 e5             	mov    %rsp,%rbp
  802f89:	48 83 ec 18          	sub    $0x18,%rsp
  802f8d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f91:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f95:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  802f99:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f9d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802fa1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fa5:	48 89 ce             	mov    %rcx,%rsi
  802fa8:	48 89 c7             	mov    %rax,%rdi
  802fab:	48 b8 6e 2e 80 00 00 	movabs $0x802e6e,%rax
  802fb2:	00 00 00 
  802fb5:	ff d0                	callq  *%rax
}
  802fb7:	c9                   	leaveq 
  802fb8:	c3                   	retq   

0000000000802fb9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802fb9:	55                   	push   %rbp
  802fba:	48 89 e5             	mov    %rsp,%rbp
  802fbd:	48 83 ec 28          	sub    $0x28,%rsp
  802fc1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fc5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fc9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  802fcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  802fd5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fd9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  802fdd:	eb 36                	jmp    803015 <memcmp+0x5c>
		if (*s1 != *s2)
  802fdf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fe3:	0f b6 10             	movzbl (%rax),%edx
  802fe6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fea:	0f b6 00             	movzbl (%rax),%eax
  802fed:	38 c2                	cmp    %al,%dl
  802fef:	74 1a                	je     80300b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  802ff1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff5:	0f b6 00             	movzbl (%rax),%eax
  802ff8:	0f b6 d0             	movzbl %al,%edx
  802ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fff:	0f b6 00             	movzbl (%rax),%eax
  803002:	0f b6 c0             	movzbl %al,%eax
  803005:	29 c2                	sub    %eax,%edx
  803007:	89 d0                	mov    %edx,%eax
  803009:	eb 20                	jmp    80302b <memcmp+0x72>
		s1++, s2++;
  80300b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803010:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  803015:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803019:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80301d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803021:	48 85 c0             	test   %rax,%rax
  803024:	75 b9                	jne    802fdf <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  803026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80302b:	c9                   	leaveq 
  80302c:	c3                   	retq   

000000000080302d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80302d:	55                   	push   %rbp
  80302e:	48 89 e5             	mov    %rsp,%rbp
  803031:	48 83 ec 28          	sub    $0x28,%rsp
  803035:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803039:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80303c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  803040:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803044:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803048:	48 01 d0             	add    %rdx,%rax
  80304b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80304f:	eb 15                	jmp    803066 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  803051:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803055:	0f b6 10             	movzbl (%rax),%edx
  803058:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80305b:	38 c2                	cmp    %al,%dl
  80305d:	75 02                	jne    803061 <memfind+0x34>
			break;
  80305f:	eb 0f                	jmp    803070 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  803061:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803066:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80306a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80306e:	72 e1                	jb     803051 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  803070:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803074:	c9                   	leaveq 
  803075:	c3                   	retq   

0000000000803076 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  803076:	55                   	push   %rbp
  803077:	48 89 e5             	mov    %rsp,%rbp
  80307a:	48 83 ec 34          	sub    $0x34,%rsp
  80307e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803082:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803086:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803089:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  803090:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803097:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803098:	eb 05                	jmp    80309f <strtol+0x29>
		s++;
  80309a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80309f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030a3:	0f b6 00             	movzbl (%rax),%eax
  8030a6:	3c 20                	cmp    $0x20,%al
  8030a8:	74 f0                	je     80309a <strtol+0x24>
  8030aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030ae:	0f b6 00             	movzbl (%rax),%eax
  8030b1:	3c 09                	cmp    $0x9,%al
  8030b3:	74 e5                	je     80309a <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8030b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030b9:	0f b6 00             	movzbl (%rax),%eax
  8030bc:	3c 2b                	cmp    $0x2b,%al
  8030be:	75 07                	jne    8030c7 <strtol+0x51>
		s++;
  8030c0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8030c5:	eb 17                	jmp    8030de <strtol+0x68>
	else if (*s == '-')
  8030c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030cb:	0f b6 00             	movzbl (%rax),%eax
  8030ce:	3c 2d                	cmp    $0x2d,%al
  8030d0:	75 0c                	jne    8030de <strtol+0x68>
		s++, neg = 1;
  8030d2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8030d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8030de:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8030e2:	74 06                	je     8030ea <strtol+0x74>
  8030e4:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8030e8:	75 28                	jne    803112 <strtol+0x9c>
  8030ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030ee:	0f b6 00             	movzbl (%rax),%eax
  8030f1:	3c 30                	cmp    $0x30,%al
  8030f3:	75 1d                	jne    803112 <strtol+0x9c>
  8030f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030f9:	48 83 c0 01          	add    $0x1,%rax
  8030fd:	0f b6 00             	movzbl (%rax),%eax
  803100:	3c 78                	cmp    $0x78,%al
  803102:	75 0e                	jne    803112 <strtol+0x9c>
		s += 2, base = 16;
  803104:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  803109:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  803110:	eb 2c                	jmp    80313e <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  803112:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803116:	75 19                	jne    803131 <strtol+0xbb>
  803118:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80311c:	0f b6 00             	movzbl (%rax),%eax
  80311f:	3c 30                	cmp    $0x30,%al
  803121:	75 0e                	jne    803131 <strtol+0xbb>
		s++, base = 8;
  803123:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803128:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80312f:	eb 0d                	jmp    80313e <strtol+0xc8>
	else if (base == 0)
  803131:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803135:	75 07                	jne    80313e <strtol+0xc8>
		base = 10;
  803137:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80313e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803142:	0f b6 00             	movzbl (%rax),%eax
  803145:	3c 2f                	cmp    $0x2f,%al
  803147:	7e 1d                	jle    803166 <strtol+0xf0>
  803149:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80314d:	0f b6 00             	movzbl (%rax),%eax
  803150:	3c 39                	cmp    $0x39,%al
  803152:	7f 12                	jg     803166 <strtol+0xf0>
			dig = *s - '0';
  803154:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803158:	0f b6 00             	movzbl (%rax),%eax
  80315b:	0f be c0             	movsbl %al,%eax
  80315e:	83 e8 30             	sub    $0x30,%eax
  803161:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803164:	eb 4e                	jmp    8031b4 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803166:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80316a:	0f b6 00             	movzbl (%rax),%eax
  80316d:	3c 60                	cmp    $0x60,%al
  80316f:	7e 1d                	jle    80318e <strtol+0x118>
  803171:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803175:	0f b6 00             	movzbl (%rax),%eax
  803178:	3c 7a                	cmp    $0x7a,%al
  80317a:	7f 12                	jg     80318e <strtol+0x118>
			dig = *s - 'a' + 10;
  80317c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803180:	0f b6 00             	movzbl (%rax),%eax
  803183:	0f be c0             	movsbl %al,%eax
  803186:	83 e8 57             	sub    $0x57,%eax
  803189:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80318c:	eb 26                	jmp    8031b4 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80318e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803192:	0f b6 00             	movzbl (%rax),%eax
  803195:	3c 40                	cmp    $0x40,%al
  803197:	7e 48                	jle    8031e1 <strtol+0x16b>
  803199:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80319d:	0f b6 00             	movzbl (%rax),%eax
  8031a0:	3c 5a                	cmp    $0x5a,%al
  8031a2:	7f 3d                	jg     8031e1 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8031a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031a8:	0f b6 00             	movzbl (%rax),%eax
  8031ab:	0f be c0             	movsbl %al,%eax
  8031ae:	83 e8 37             	sub    $0x37,%eax
  8031b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8031b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031b7:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8031ba:	7c 02                	jl     8031be <strtol+0x148>
			break;
  8031bc:	eb 23                	jmp    8031e1 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8031be:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031c3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8031c6:	48 98                	cltq   
  8031c8:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8031cd:	48 89 c2             	mov    %rax,%rdx
  8031d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031d3:	48 98                	cltq   
  8031d5:	48 01 d0             	add    %rdx,%rax
  8031d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8031dc:	e9 5d ff ff ff       	jmpq   80313e <strtol+0xc8>

	if (endptr)
  8031e1:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8031e6:	74 0b                	je     8031f3 <strtol+0x17d>
		*endptr = (char *) s;
  8031e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031ec:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031f0:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8031f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031f7:	74 09                	je     803202 <strtol+0x18c>
  8031f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031fd:	48 f7 d8             	neg    %rax
  803200:	eb 04                	jmp    803206 <strtol+0x190>
  803202:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803206:	c9                   	leaveq 
  803207:	c3                   	retq   

0000000000803208 <strstr>:

char * strstr(const char *in, const char *str)
{
  803208:	55                   	push   %rbp
  803209:	48 89 e5             	mov    %rsp,%rbp
  80320c:	48 83 ec 30          	sub    $0x30,%rsp
  803210:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803214:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  803218:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80321c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803220:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  803224:	0f b6 00             	movzbl (%rax),%eax
  803227:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  80322a:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80322e:	75 06                	jne    803236 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  803230:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803234:	eb 6b                	jmp    8032a1 <strstr+0x99>

    len = strlen(str);
  803236:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80323a:	48 89 c7             	mov    %rax,%rdi
  80323d:	48 b8 de 2a 80 00 00 	movabs $0x802ade,%rax
  803244:	00 00 00 
  803247:	ff d0                	callq  *%rax
  803249:	48 98                	cltq   
  80324b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80324f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803253:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803257:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80325b:	0f b6 00             	movzbl (%rax),%eax
  80325e:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  803261:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803265:	75 07                	jne    80326e <strstr+0x66>
                return (char *) 0;
  803267:	b8 00 00 00 00       	mov    $0x0,%eax
  80326c:	eb 33                	jmp    8032a1 <strstr+0x99>
        } while (sc != c);
  80326e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  803272:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803275:	75 d8                	jne    80324f <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  803277:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80327b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80327f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803283:	48 89 ce             	mov    %rcx,%rsi
  803286:	48 89 c7             	mov    %rax,%rdi
  803289:	48 b8 ff 2c 80 00 00 	movabs $0x802cff,%rax
  803290:	00 00 00 
  803293:	ff d0                	callq  *%rax
  803295:	85 c0                	test   %eax,%eax
  803297:	75 b6                	jne    80324f <strstr+0x47>

    return (char *) (in - 1);
  803299:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80329d:	48 83 e8 01          	sub    $0x1,%rax
}
  8032a1:	c9                   	leaveq 
  8032a2:	c3                   	retq   

00000000008032a3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8032a3:	55                   	push   %rbp
  8032a4:	48 89 e5             	mov    %rsp,%rbp
  8032a7:	48 83 ec 30          	sub    $0x30,%rsp
  8032ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8032b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8032bf:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8032c4:	75 0e                	jne    8032d4 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  8032c6:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8032cd:	00 00 00 
  8032d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  8032d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032d8:	48 89 c7             	mov    %rax,%rdi
  8032db:	48 b8 29 05 80 00 00 	movabs $0x800529,%rax
  8032e2:	00 00 00 
  8032e5:	ff d0                	callq  *%rax
  8032e7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8032ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8032ee:	79 27                	jns    803317 <ipc_recv+0x74>
		if (from_env_store != NULL)
  8032f0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8032f5:	74 0a                	je     803301 <ipc_recv+0x5e>
			*from_env_store = 0;
  8032f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032fb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  803301:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803306:	74 0a                	je     803312 <ipc_recv+0x6f>
			*perm_store = 0;
  803308:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80330c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803312:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803315:	eb 53                	jmp    80336a <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  803317:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80331c:	74 19                	je     803337 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  80331e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803325:	00 00 00 
  803328:	48 8b 00             	mov    (%rax),%rax
  80332b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803331:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803335:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  803337:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80333c:	74 19                	je     803357 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  80333e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803345:	00 00 00 
  803348:	48 8b 00             	mov    (%rax),%rax
  80334b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803351:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803355:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  803357:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80335e:	00 00 00 
  803361:	48 8b 00             	mov    (%rax),%rax
  803364:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  80336a:	c9                   	leaveq 
  80336b:	c3                   	retq   

000000000080336c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80336c:	55                   	push   %rbp
  80336d:	48 89 e5             	mov    %rsp,%rbp
  803370:	48 83 ec 30          	sub    $0x30,%rsp
  803374:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803377:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80337a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80337e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803381:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803385:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803389:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80338e:	75 10                	jne    8033a0 <ipc_send+0x34>
		page = (void *)KERNBASE;
  803390:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803397:	00 00 00 
  80339a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  80339e:	eb 0e                	jmp    8033ae <ipc_send+0x42>
  8033a0:	eb 0c                	jmp    8033ae <ipc_send+0x42>
		sys_yield();
  8033a2:	48 b8 c2 02 80 00 00 	movabs $0x8002c2,%rax
  8033a9:	00 00 00 
  8033ac:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  8033ae:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8033b1:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8033b4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033bb:	89 c7                	mov    %eax,%edi
  8033bd:	48 b8 d4 04 80 00 00 	movabs $0x8004d4,%rax
  8033c4:	00 00 00 
  8033c7:	ff d0                	callq  *%rax
  8033c9:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8033cc:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  8033d0:	74 d0                	je     8033a2 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  8033d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033d6:	74 2a                	je     803402 <ipc_send+0x96>
		panic("error on ipc send procedure");
  8033d8:	48 ba e0 3a 80 00 00 	movabs $0x803ae0,%rdx
  8033df:	00 00 00 
  8033e2:	be 49 00 00 00       	mov    $0x49,%esi
  8033e7:	48 bf fc 3a 80 00 00 	movabs $0x803afc,%rdi
  8033ee:	00 00 00 
  8033f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f6:	48 b9 69 1b 80 00 00 	movabs $0x801b69,%rcx
  8033fd:	00 00 00 
  803400:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  803402:	c9                   	leaveq 
  803403:	c3                   	retq   

0000000000803404 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803404:	55                   	push   %rbp
  803405:	48 89 e5             	mov    %rsp,%rbp
  803408:	48 83 ec 14          	sub    $0x14,%rsp
  80340c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80340f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803416:	eb 5e                	jmp    803476 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803418:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80341f:	00 00 00 
  803422:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803425:	48 63 d0             	movslq %eax,%rdx
  803428:	48 89 d0             	mov    %rdx,%rax
  80342b:	48 c1 e0 03          	shl    $0x3,%rax
  80342f:	48 01 d0             	add    %rdx,%rax
  803432:	48 c1 e0 05          	shl    $0x5,%rax
  803436:	48 01 c8             	add    %rcx,%rax
  803439:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80343f:	8b 00                	mov    (%rax),%eax
  803441:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803444:	75 2c                	jne    803472 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803446:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80344d:	00 00 00 
  803450:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803453:	48 63 d0             	movslq %eax,%rdx
  803456:	48 89 d0             	mov    %rdx,%rax
  803459:	48 c1 e0 03          	shl    $0x3,%rax
  80345d:	48 01 d0             	add    %rdx,%rax
  803460:	48 c1 e0 05          	shl    $0x5,%rax
  803464:	48 01 c8             	add    %rcx,%rax
  803467:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80346d:	8b 40 08             	mov    0x8(%rax),%eax
  803470:	eb 12                	jmp    803484 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803472:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803476:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80347d:	7e 99                	jle    803418 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80347f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803484:	c9                   	leaveq 
  803485:	c3                   	retq   

0000000000803486 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803486:	55                   	push   %rbp
  803487:	48 89 e5             	mov    %rsp,%rbp
  80348a:	48 83 ec 18          	sub    $0x18,%rsp
  80348e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803492:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803496:	48 c1 e8 15          	shr    $0x15,%rax
  80349a:	48 89 c2             	mov    %rax,%rdx
  80349d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8034a4:	01 00 00 
  8034a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034ab:	83 e0 01             	and    $0x1,%eax
  8034ae:	48 85 c0             	test   %rax,%rax
  8034b1:	75 07                	jne    8034ba <pageref+0x34>
		return 0;
  8034b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b8:	eb 53                	jmp    80350d <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8034ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034be:	48 c1 e8 0c          	shr    $0xc,%rax
  8034c2:	48 89 c2             	mov    %rax,%rdx
  8034c5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8034cc:	01 00 00 
  8034cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8034d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034db:	83 e0 01             	and    $0x1,%eax
  8034de:	48 85 c0             	test   %rax,%rax
  8034e1:	75 07                	jne    8034ea <pageref+0x64>
		return 0;
  8034e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e8:	eb 23                	jmp    80350d <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8034ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034ee:	48 c1 e8 0c          	shr    $0xc,%rax
  8034f2:	48 89 c2             	mov    %rax,%rdx
  8034f5:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8034fc:	00 00 00 
  8034ff:	48 c1 e2 04          	shl    $0x4,%rdx
  803503:	48 01 d0             	add    %rdx,%rax
  803506:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80350a:	0f b7 c0             	movzwl %ax,%eax
}
  80350d:	c9                   	leaveq 
  80350e:	c3                   	retq   
