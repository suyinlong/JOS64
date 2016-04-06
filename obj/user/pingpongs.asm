
obj/user/pingpongs.debug:     file format elf64-x86-64


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
  80003c:	e8 b6 01 00 00       	callq  8001f7 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	41 56                	push   %r14
  800049:	41 55                	push   %r13
  80004b:	41 54                	push   %r12
  80004d:	53                   	push   %rbx
  80004e:	48 83 ec 20          	sub    $0x20,%rsp
  800052:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800055:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	envid_t who;
	uint32_t i;

	i = 0;
  800059:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	if ((who = sfork()) != 0) {
  800060:	48 b8 e8 21 80 00 00 	movabs $0x8021e8,%rax
  800067:	00 00 00 
  80006a:	ff d0                	callq  *%rax
  80006c:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80006f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800072:	85 c0                	test   %eax,%eax
  800074:	0f 84 87 00 00 00    	je     800101 <umain+0xbe>
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  80007a:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800081:	00 00 00 
  800084:	48 8b 18             	mov    (%rax),%rbx
  800087:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	48 89 da             	mov    %rbx,%rdx
  800096:	89 c6                	mov    %eax,%esi
  800098:	48 bf a0 3c 80 00 00 	movabs $0x803ca0,%rdi
  80009f:	00 00 00 
  8000a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a7:	48 b9 cf 03 80 00 00 	movabs $0x8003cf,%rcx
  8000ae:	00 00 00 
  8000b1:	ff d1                	callq  *%rcx
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000b3:	8b 5d d8             	mov    -0x28(%rbp),%ebx
  8000b6:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  8000bd:	00 00 00 
  8000c0:	ff d0                	callq  *%rax
  8000c2:	89 da                	mov    %ebx,%edx
  8000c4:	89 c6                	mov    %eax,%esi
  8000c6:	48 bf ba 3c 80 00 00 	movabs $0x803cba,%rdi
  8000cd:	00 00 00 
  8000d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d5:	48 b9 cf 03 80 00 00 	movabs $0x8003cf,%rcx
  8000dc:	00 00 00 
  8000df:	ff d1                	callq  *%rcx
		ipc_send(who, 0, 0, 0);
  8000e1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8000e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ee:	be 00 00 00 00       	mov    $0x0,%esi
  8000f3:	89 c7                	mov    %eax,%edi
  8000f5:	48 b8 df 22 80 00 00 	movabs $0x8022df,%rax
  8000fc:	00 00 00 
  8000ff:	ff d0                	callq  *%rax
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800101:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  800105:	ba 00 00 00 00       	mov    $0x0,%edx
  80010a:	be 00 00 00 00       	mov    $0x0,%esi
  80010f:	48 89 c7             	mov    %rax,%rdi
  800112:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  800119:	00 00 00 
  80011c:	ff d0                	callq  *%rax
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80011e:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800125:	00 00 00 
  800128:	48 8b 00             	mov    (%rax),%rax
  80012b:	44 8b b0 c8 00 00 00 	mov    0xc8(%rax),%r14d
  800132:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800139:	00 00 00 
  80013c:	4c 8b 28             	mov    (%rax),%r13
  80013f:	44 8b 65 d8          	mov    -0x28(%rbp),%r12d
  800143:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80014a:	00 00 00 
  80014d:	8b 18                	mov    (%rax),%ebx
  80014f:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
  80015b:	45 89 f1             	mov    %r14d,%r9d
  80015e:	4d 89 e8             	mov    %r13,%r8
  800161:	44 89 e1             	mov    %r12d,%ecx
  800164:	89 da                	mov    %ebx,%edx
  800166:	89 c6                	mov    %eax,%esi
  800168:	48 bf d0 3c 80 00 00 	movabs $0x803cd0,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	49 ba cf 03 80 00 00 	movabs $0x8003cf,%r10
  80017e:	00 00 00 
  800181:	41 ff d2             	callq  *%r10
		if (val == 10)
  800184:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80018b:	00 00 00 
  80018e:	8b 00                	mov    (%rax),%eax
  800190:	83 f8 0a             	cmp    $0xa,%eax
  800193:	75 02                	jne    800197 <umain+0x154>
			return;
  800195:	eb 53                	jmp    8001ea <umain+0x1a7>
		++val;
  800197:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80019e:	00 00 00 
  8001a1:	8b 00                	mov    (%rax),%eax
  8001a3:	8d 50 01             	lea    0x1(%rax),%edx
  8001a6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001ad:	00 00 00 
  8001b0:	89 10                	mov    %edx,(%rax)
		ipc_send(who, 0, 0, 0);
  8001b2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8001b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8001bf:	be 00 00 00 00       	mov    $0x0,%esi
  8001c4:	89 c7                	mov    %eax,%edi
  8001c6:	48 b8 df 22 80 00 00 	movabs $0x8022df,%rax
  8001cd:	00 00 00 
  8001d0:	ff d0                	callq  *%rax
		if (val == 10)
  8001d2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001d9:	00 00 00 
  8001dc:	8b 00                	mov    (%rax),%eax
  8001de:	83 f8 0a             	cmp    $0xa,%eax
  8001e1:	75 02                	jne    8001e5 <umain+0x1a2>
			return;
  8001e3:	eb 05                	jmp    8001ea <umain+0x1a7>
	}
  8001e5:	e9 17 ff ff ff       	jmpq   800101 <umain+0xbe>

}
  8001ea:	48 83 c4 20          	add    $0x20,%rsp
  8001ee:	5b                   	pop    %rbx
  8001ef:	41 5c                	pop    %r12
  8001f1:	41 5d                	pop    %r13
  8001f3:	41 5e                	pop    %r14
  8001f5:	5d                   	pop    %rbp
  8001f6:	c3                   	retq   

00000000008001f7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001f7:	55                   	push   %rbp
  8001f8:	48 89 e5             	mov    %rsp,%rbp
  8001fb:	48 83 ec 10          	sub    $0x10,%rsp
  8001ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800202:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800206:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  80020d:	00 00 00 
  800210:	ff d0                	callq  *%rax
  800212:	48 98                	cltq   
  800214:	25 ff 03 00 00       	and    $0x3ff,%eax
  800219:	48 89 c2             	mov    %rax,%rdx
  80021c:	48 89 d0             	mov    %rdx,%rax
  80021f:	48 c1 e0 03          	shl    $0x3,%rax
  800223:	48 01 d0             	add    %rdx,%rax
  800226:	48 c1 e0 05          	shl    $0x5,%rax
  80022a:	48 89 c2             	mov    %rax,%rdx
  80022d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800234:	00 00 00 
  800237:	48 01 c2             	add    %rax,%rdx
  80023a:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800241:	00 00 00 
  800244:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800247:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80024b:	7e 14                	jle    800261 <libmain+0x6a>
		binaryname = argv[0];
  80024d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800251:	48 8b 10             	mov    (%rax),%rdx
  800254:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80025b:	00 00 00 
  80025e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800261:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800265:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800268:	48 89 d6             	mov    %rdx,%rsi
  80026b:	89 c7                	mov    %eax,%edi
  80026d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800274:	00 00 00 
  800277:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800279:	48 b8 87 02 80 00 00 	movabs $0x800287,%rax
  800280:	00 00 00 
  800283:	ff d0                	callq  *%rax
}
  800285:	c9                   	leaveq 
  800286:	c3                   	retq   

0000000000800287 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800287:	55                   	push   %rbp
  800288:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80028b:	48 b8 3a 27 80 00 00 	movabs $0x80273a,%rax
  800292:	00 00 00 
  800295:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800297:	bf 00 00 00 00       	mov    $0x0,%edi
  80029c:	48 b8 e6 19 80 00 00 	movabs $0x8019e6,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
}
  8002a8:	5d                   	pop    %rbp
  8002a9:	c3                   	retq   

00000000008002aa <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002aa:	55                   	push   %rbp
  8002ab:	48 89 e5             	mov    %rsp,%rbp
  8002ae:	48 83 ec 10          	sub    $0x10,%rsp
  8002b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8002b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002bd:	8b 00                	mov    (%rax),%eax
  8002bf:	8d 48 01             	lea    0x1(%rax),%ecx
  8002c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002c6:	89 0a                	mov    %ecx,(%rdx)
  8002c8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002cb:	89 d1                	mov    %edx,%ecx
  8002cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002d1:	48 98                	cltq   
  8002d3:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8002d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002db:	8b 00                	mov    (%rax),%eax
  8002dd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002e2:	75 2c                	jne    800310 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8002e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e8:	8b 00                	mov    (%rax),%eax
  8002ea:	48 98                	cltq   
  8002ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002f0:	48 83 c2 08          	add    $0x8,%rdx
  8002f4:	48 89 c6             	mov    %rax,%rsi
  8002f7:	48 89 d7             	mov    %rdx,%rdi
  8002fa:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  800301:	00 00 00 
  800304:	ff d0                	callq  *%rax
		b->idx = 0;
  800306:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80030a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800310:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800314:	8b 40 04             	mov    0x4(%rax),%eax
  800317:	8d 50 01             	lea    0x1(%rax),%edx
  80031a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80031e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800321:	c9                   	leaveq 
  800322:	c3                   	retq   

0000000000800323 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800323:	55                   	push   %rbp
  800324:	48 89 e5             	mov    %rsp,%rbp
  800327:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80032e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800335:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80033c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800343:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80034a:	48 8b 0a             	mov    (%rdx),%rcx
  80034d:	48 89 08             	mov    %rcx,(%rax)
  800350:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800354:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800358:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80035c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800360:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800367:	00 00 00 
	b.cnt = 0;
  80036a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800371:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800374:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80037b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800382:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800389:	48 89 c6             	mov    %rax,%rsi
  80038c:	48 bf aa 02 80 00 00 	movabs $0x8002aa,%rdi
  800393:	00 00 00 
  800396:	48 b8 82 07 80 00 00 	movabs $0x800782,%rax
  80039d:	00 00 00 
  8003a0:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8003a2:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8003a8:	48 98                	cltq   
  8003aa:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003b1:	48 83 c2 08          	add    $0x8,%rdx
  8003b5:	48 89 c6             	mov    %rax,%rsi
  8003b8:	48 89 d7             	mov    %rdx,%rdi
  8003bb:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  8003c2:	00 00 00 
  8003c5:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8003c7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003cd:	c9                   	leaveq 
  8003ce:	c3                   	retq   

00000000008003cf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003cf:	55                   	push   %rbp
  8003d0:	48 89 e5             	mov    %rsp,%rbp
  8003d3:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003da:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003e1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003e8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003ef:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003f6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003fd:	84 c0                	test   %al,%al
  8003ff:	74 20                	je     800421 <cprintf+0x52>
  800401:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800405:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800409:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80040d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800411:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800415:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800419:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80041d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800421:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800428:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80042f:	00 00 00 
  800432:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800439:	00 00 00 
  80043c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800440:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800447:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80044e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800455:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80045c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800463:	48 8b 0a             	mov    (%rdx),%rcx
  800466:	48 89 08             	mov    %rcx,(%rax)
  800469:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80046d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800471:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800475:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800479:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800480:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800487:	48 89 d6             	mov    %rdx,%rsi
  80048a:	48 89 c7             	mov    %rax,%rdi
  80048d:	48 b8 23 03 80 00 00 	movabs $0x800323,%rax
  800494:	00 00 00 
  800497:	ff d0                	callq  *%rax
  800499:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80049f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004a5:	c9                   	leaveq 
  8004a6:	c3                   	retq   

00000000008004a7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a7:	55                   	push   %rbp
  8004a8:	48 89 e5             	mov    %rsp,%rbp
  8004ab:	53                   	push   %rbx
  8004ac:	48 83 ec 38          	sub    $0x38,%rsp
  8004b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004b8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004bc:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8004bf:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8004c3:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004ca:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004ce:	77 3b                	ja     80050b <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d0:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8004d3:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004d7:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004de:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e3:	48 f7 f3             	div    %rbx
  8004e6:	48 89 c2             	mov    %rax,%rdx
  8004e9:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004ec:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004ef:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f7:	41 89 f9             	mov    %edi,%r9d
  8004fa:	48 89 c7             	mov    %rax,%rdi
  8004fd:	48 b8 a7 04 80 00 00 	movabs $0x8004a7,%rax
  800504:	00 00 00 
  800507:	ff d0                	callq  *%rax
  800509:	eb 1e                	jmp    800529 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80050b:	eb 12                	jmp    80051f <printnum+0x78>
			putch(padc, putdat);
  80050d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800511:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800514:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800518:	48 89 ce             	mov    %rcx,%rsi
  80051b:	89 d7                	mov    %edx,%edi
  80051d:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80051f:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800523:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800527:	7f e4                	jg     80050d <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800529:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80052c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800530:	ba 00 00 00 00       	mov    $0x0,%edx
  800535:	48 f7 f1             	div    %rcx
  800538:	48 89 d0             	mov    %rdx,%rax
  80053b:	48 ba c8 3e 80 00 00 	movabs $0x803ec8,%rdx
  800542:	00 00 00 
  800545:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800549:	0f be d0             	movsbl %al,%edx
  80054c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800554:	48 89 ce             	mov    %rcx,%rsi
  800557:	89 d7                	mov    %edx,%edi
  800559:	ff d0                	callq  *%rax
}
  80055b:	48 83 c4 38          	add    $0x38,%rsp
  80055f:	5b                   	pop    %rbx
  800560:	5d                   	pop    %rbp
  800561:	c3                   	retq   

0000000000800562 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800562:	55                   	push   %rbp
  800563:	48 89 e5             	mov    %rsp,%rbp
  800566:	48 83 ec 1c          	sub    $0x1c,%rsp
  80056a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80056e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800571:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800575:	7e 52                	jle    8005c9 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800577:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057b:	8b 00                	mov    (%rax),%eax
  80057d:	83 f8 30             	cmp    $0x30,%eax
  800580:	73 24                	jae    8005a6 <getuint+0x44>
  800582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800586:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80058a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058e:	8b 00                	mov    (%rax),%eax
  800590:	89 c0                	mov    %eax,%eax
  800592:	48 01 d0             	add    %rdx,%rax
  800595:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800599:	8b 12                	mov    (%rdx),%edx
  80059b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80059e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a2:	89 0a                	mov    %ecx,(%rdx)
  8005a4:	eb 17                	jmp    8005bd <getuint+0x5b>
  8005a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005aa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005ae:	48 89 d0             	mov    %rdx,%rax
  8005b1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005bd:	48 8b 00             	mov    (%rax),%rax
  8005c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005c4:	e9 a3 00 00 00       	jmpq   80066c <getuint+0x10a>
	else if (lflag)
  8005c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005cd:	74 4f                	je     80061e <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d3:	8b 00                	mov    (%rax),%eax
  8005d5:	83 f8 30             	cmp    $0x30,%eax
  8005d8:	73 24                	jae    8005fe <getuint+0x9c>
  8005da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005de:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e6:	8b 00                	mov    (%rax),%eax
  8005e8:	89 c0                	mov    %eax,%eax
  8005ea:	48 01 d0             	add    %rdx,%rax
  8005ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f1:	8b 12                	mov    (%rdx),%edx
  8005f3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fa:	89 0a                	mov    %ecx,(%rdx)
  8005fc:	eb 17                	jmp    800615 <getuint+0xb3>
  8005fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800602:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800606:	48 89 d0             	mov    %rdx,%rax
  800609:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80060d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800611:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800615:	48 8b 00             	mov    (%rax),%rax
  800618:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80061c:	eb 4e                	jmp    80066c <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80061e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800622:	8b 00                	mov    (%rax),%eax
  800624:	83 f8 30             	cmp    $0x30,%eax
  800627:	73 24                	jae    80064d <getuint+0xeb>
  800629:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800631:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800635:	8b 00                	mov    (%rax),%eax
  800637:	89 c0                	mov    %eax,%eax
  800639:	48 01 d0             	add    %rdx,%rax
  80063c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800640:	8b 12                	mov    (%rdx),%edx
  800642:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800645:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800649:	89 0a                	mov    %ecx,(%rdx)
  80064b:	eb 17                	jmp    800664 <getuint+0x102>
  80064d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800651:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800655:	48 89 d0             	mov    %rdx,%rax
  800658:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80065c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800660:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800664:	8b 00                	mov    (%rax),%eax
  800666:	89 c0                	mov    %eax,%eax
  800668:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80066c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800670:	c9                   	leaveq 
  800671:	c3                   	retq   

0000000000800672 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800672:	55                   	push   %rbp
  800673:	48 89 e5             	mov    %rsp,%rbp
  800676:	48 83 ec 1c          	sub    $0x1c,%rsp
  80067a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80067e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800681:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800685:	7e 52                	jle    8006d9 <getint+0x67>
		x=va_arg(*ap, long long);
  800687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068b:	8b 00                	mov    (%rax),%eax
  80068d:	83 f8 30             	cmp    $0x30,%eax
  800690:	73 24                	jae    8006b6 <getint+0x44>
  800692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800696:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80069a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069e:	8b 00                	mov    (%rax),%eax
  8006a0:	89 c0                	mov    %eax,%eax
  8006a2:	48 01 d0             	add    %rdx,%rax
  8006a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a9:	8b 12                	mov    (%rdx),%edx
  8006ab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b2:	89 0a                	mov    %ecx,(%rdx)
  8006b4:	eb 17                	jmp    8006cd <getint+0x5b>
  8006b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006be:	48 89 d0             	mov    %rdx,%rax
  8006c1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006cd:	48 8b 00             	mov    (%rax),%rax
  8006d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d4:	e9 a3 00 00 00       	jmpq   80077c <getint+0x10a>
	else if (lflag)
  8006d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006dd:	74 4f                	je     80072e <getint+0xbc>
		x=va_arg(*ap, long);
  8006df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e3:	8b 00                	mov    (%rax),%eax
  8006e5:	83 f8 30             	cmp    $0x30,%eax
  8006e8:	73 24                	jae    80070e <getint+0x9c>
  8006ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ee:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f6:	8b 00                	mov    (%rax),%eax
  8006f8:	89 c0                	mov    %eax,%eax
  8006fa:	48 01 d0             	add    %rdx,%rax
  8006fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800701:	8b 12                	mov    (%rdx),%edx
  800703:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800706:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070a:	89 0a                	mov    %ecx,(%rdx)
  80070c:	eb 17                	jmp    800725 <getint+0xb3>
  80070e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800712:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800716:	48 89 d0             	mov    %rdx,%rax
  800719:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80071d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800721:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800725:	48 8b 00             	mov    (%rax),%rax
  800728:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80072c:	eb 4e                	jmp    80077c <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80072e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800732:	8b 00                	mov    (%rax),%eax
  800734:	83 f8 30             	cmp    $0x30,%eax
  800737:	73 24                	jae    80075d <getint+0xeb>
  800739:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800745:	8b 00                	mov    (%rax),%eax
  800747:	89 c0                	mov    %eax,%eax
  800749:	48 01 d0             	add    %rdx,%rax
  80074c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800750:	8b 12                	mov    (%rdx),%edx
  800752:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800755:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800759:	89 0a                	mov    %ecx,(%rdx)
  80075b:	eb 17                	jmp    800774 <getint+0x102>
  80075d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800761:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800765:	48 89 d0             	mov    %rdx,%rax
  800768:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80076c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800770:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800774:	8b 00                	mov    (%rax),%eax
  800776:	48 98                	cltq   
  800778:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80077c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800780:	c9                   	leaveq 
  800781:	c3                   	retq   

0000000000800782 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800782:	55                   	push   %rbp
  800783:	48 89 e5             	mov    %rsp,%rbp
  800786:	41 54                	push   %r12
  800788:	53                   	push   %rbx
  800789:	48 83 ec 60          	sub    $0x60,%rsp
  80078d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800791:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800795:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800799:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80079d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8007a1:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8007a5:	48 8b 0a             	mov    (%rdx),%rcx
  8007a8:	48 89 08             	mov    %rcx,(%rax)
  8007ab:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007af:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007b3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007b7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  8007bb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007bf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007c3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007c7:	0f b6 00             	movzbl (%rax),%eax
  8007ca:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  8007cd:	eb 29                	jmp    8007f8 <vprintfmt+0x76>
			if (ch == '\0')
  8007cf:	85 db                	test   %ebx,%ebx
  8007d1:	0f 84 ad 06 00 00    	je     800e84 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  8007d7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007db:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007df:	48 89 d6             	mov    %rdx,%rsi
  8007e2:	89 df                	mov    %ebx,%edi
  8007e4:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  8007e6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007ee:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007f2:	0f b6 00             	movzbl (%rax),%eax
  8007f5:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  8007f8:	83 fb 25             	cmp    $0x25,%ebx
  8007fb:	74 05                	je     800802 <vprintfmt+0x80>
  8007fd:	83 fb 1b             	cmp    $0x1b,%ebx
  800800:	75 cd                	jne    8007cf <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800802:	83 fb 1b             	cmp    $0x1b,%ebx
  800805:	0f 85 ae 01 00 00    	jne    8009b9 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  80080b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800812:	00 00 00 
  800815:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  80081b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80081f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800823:	48 89 d6             	mov    %rdx,%rsi
  800826:	89 df                	mov    %ebx,%edi
  800828:	ff d0                	callq  *%rax
			putch('[', putdat);
  80082a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80082e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800832:	48 89 d6             	mov    %rdx,%rsi
  800835:	bf 5b 00 00 00       	mov    $0x5b,%edi
  80083a:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  80083c:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800842:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800847:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80084b:	0f b6 00             	movzbl (%rax),%eax
  80084e:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800851:	eb 32                	jmp    800885 <vprintfmt+0x103>
					putch(ch, putdat);
  800853:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800857:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80085b:	48 89 d6             	mov    %rdx,%rsi
  80085e:	89 df                	mov    %ebx,%edi
  800860:	ff d0                	callq  *%rax
					esc_color *= 10;
  800862:	44 89 e0             	mov    %r12d,%eax
  800865:	c1 e0 02             	shl    $0x2,%eax
  800868:	44 01 e0             	add    %r12d,%eax
  80086b:	01 c0                	add    %eax,%eax
  80086d:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800870:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800873:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800876:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80087b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80087f:	0f b6 00             	movzbl (%rax),%eax
  800882:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800885:	83 fb 3b             	cmp    $0x3b,%ebx
  800888:	74 05                	je     80088f <vprintfmt+0x10d>
  80088a:	83 fb 6d             	cmp    $0x6d,%ebx
  80088d:	75 c4                	jne    800853 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  80088f:	45 85 e4             	test   %r12d,%r12d
  800892:	75 15                	jne    8008a9 <vprintfmt+0x127>
					color_flag = 0x07;
  800894:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80089b:	00 00 00 
  80089e:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  8008a4:	e9 dc 00 00 00       	jmpq   800985 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  8008a9:	41 83 fc 1d          	cmp    $0x1d,%r12d
  8008ad:	7e 69                	jle    800918 <vprintfmt+0x196>
  8008af:	41 83 fc 25          	cmp    $0x25,%r12d
  8008b3:	7f 63                	jg     800918 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  8008b5:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8008bc:	00 00 00 
  8008bf:	8b 00                	mov    (%rax),%eax
  8008c1:	25 f8 00 00 00       	and    $0xf8,%eax
  8008c6:	89 c2                	mov    %eax,%edx
  8008c8:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8008cf:	00 00 00 
  8008d2:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  8008d4:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  8008d8:	44 89 e0             	mov    %r12d,%eax
  8008db:	83 e0 04             	and    $0x4,%eax
  8008de:	c1 f8 02             	sar    $0x2,%eax
  8008e1:	89 c2                	mov    %eax,%edx
  8008e3:	44 89 e0             	mov    %r12d,%eax
  8008e6:	83 e0 02             	and    $0x2,%eax
  8008e9:	09 c2                	or     %eax,%edx
  8008eb:	44 89 e0             	mov    %r12d,%eax
  8008ee:	83 e0 01             	and    $0x1,%eax
  8008f1:	c1 e0 02             	shl    $0x2,%eax
  8008f4:	09 c2                	or     %eax,%edx
  8008f6:	41 89 d4             	mov    %edx,%r12d
  8008f9:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800900:	00 00 00 
  800903:	8b 00                	mov    (%rax),%eax
  800905:	44 89 e2             	mov    %r12d,%edx
  800908:	09 c2                	or     %eax,%edx
  80090a:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800911:	00 00 00 
  800914:	89 10                	mov    %edx,(%rax)
  800916:	eb 6d                	jmp    800985 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800918:	41 83 fc 27          	cmp    $0x27,%r12d
  80091c:	7e 67                	jle    800985 <vprintfmt+0x203>
  80091e:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800922:	7f 61                	jg     800985 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800924:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80092b:	00 00 00 
  80092e:	8b 00                	mov    (%rax),%eax
  800930:	25 8f 00 00 00       	and    $0x8f,%eax
  800935:	89 c2                	mov    %eax,%edx
  800937:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80093e:	00 00 00 
  800941:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800943:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800947:	44 89 e0             	mov    %r12d,%eax
  80094a:	83 e0 04             	and    $0x4,%eax
  80094d:	c1 f8 02             	sar    $0x2,%eax
  800950:	89 c2                	mov    %eax,%edx
  800952:	44 89 e0             	mov    %r12d,%eax
  800955:	83 e0 02             	and    $0x2,%eax
  800958:	09 c2                	or     %eax,%edx
  80095a:	44 89 e0             	mov    %r12d,%eax
  80095d:	83 e0 01             	and    $0x1,%eax
  800960:	c1 e0 06             	shl    $0x6,%eax
  800963:	09 c2                	or     %eax,%edx
  800965:	41 89 d4             	mov    %edx,%r12d
  800968:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80096f:	00 00 00 
  800972:	8b 00                	mov    (%rax),%eax
  800974:	44 89 e2             	mov    %r12d,%edx
  800977:	09 c2                	or     %eax,%edx
  800979:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800980:	00 00 00 
  800983:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800985:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800989:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80098d:	48 89 d6             	mov    %rdx,%rsi
  800990:	89 df                	mov    %ebx,%edi
  800992:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800994:	83 fb 6d             	cmp    $0x6d,%ebx
  800997:	75 1b                	jne    8009b4 <vprintfmt+0x232>
					fmt ++;
  800999:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  80099e:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  80099f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8009a6:	00 00 00 
  8009a9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  8009af:	e9 cb 04 00 00       	jmpq   800e7f <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  8009b4:	e9 83 fe ff ff       	jmpq   80083c <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b9:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009bd:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009c4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009cb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009d2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009dd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009e1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009e5:	0f b6 00             	movzbl (%rax),%eax
  8009e8:	0f b6 d8             	movzbl %al,%ebx
  8009eb:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8009ee:	83 f8 55             	cmp    $0x55,%eax
  8009f1:	0f 87 5a 04 00 00    	ja     800e51 <vprintfmt+0x6cf>
  8009f7:	89 c0                	mov    %eax,%eax
  8009f9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a00:	00 
  800a01:	48 b8 f0 3e 80 00 00 	movabs $0x803ef0,%rax
  800a08:	00 00 00 
  800a0b:	48 01 d0             	add    %rdx,%rax
  800a0e:	48 8b 00             	mov    (%rax),%rax
  800a11:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a13:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a17:	eb c0                	jmp    8009d9 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a19:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a1d:	eb ba                	jmp    8009d9 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a1f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a26:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a29:	89 d0                	mov    %edx,%eax
  800a2b:	c1 e0 02             	shl    $0x2,%eax
  800a2e:	01 d0                	add    %edx,%eax
  800a30:	01 c0                	add    %eax,%eax
  800a32:	01 d8                	add    %ebx,%eax
  800a34:	83 e8 30             	sub    $0x30,%eax
  800a37:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a3a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a3e:	0f b6 00             	movzbl (%rax),%eax
  800a41:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a44:	83 fb 2f             	cmp    $0x2f,%ebx
  800a47:	7e 0c                	jle    800a55 <vprintfmt+0x2d3>
  800a49:	83 fb 39             	cmp    $0x39,%ebx
  800a4c:	7f 07                	jg     800a55 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a4e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a53:	eb d1                	jmp    800a26 <vprintfmt+0x2a4>
			goto process_precision;
  800a55:	eb 58                	jmp    800aaf <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800a57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5a:	83 f8 30             	cmp    $0x30,%eax
  800a5d:	73 17                	jae    800a76 <vprintfmt+0x2f4>
  800a5f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a63:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a66:	89 c0                	mov    %eax,%eax
  800a68:	48 01 d0             	add    %rdx,%rax
  800a6b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a6e:	83 c2 08             	add    $0x8,%edx
  800a71:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a74:	eb 0f                	jmp    800a85 <vprintfmt+0x303>
  800a76:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a7a:	48 89 d0             	mov    %rdx,%rax
  800a7d:	48 83 c2 08          	add    $0x8,%rdx
  800a81:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a85:	8b 00                	mov    (%rax),%eax
  800a87:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a8a:	eb 23                	jmp    800aaf <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800a8c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a90:	79 0c                	jns    800a9e <vprintfmt+0x31c>
				width = 0;
  800a92:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a99:	e9 3b ff ff ff       	jmpq   8009d9 <vprintfmt+0x257>
  800a9e:	e9 36 ff ff ff       	jmpq   8009d9 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800aa3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800aaa:	e9 2a ff ff ff       	jmpq   8009d9 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800aaf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ab3:	79 12                	jns    800ac7 <vprintfmt+0x345>
				width = precision, precision = -1;
  800ab5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ab8:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800abb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800ac2:	e9 12 ff ff ff       	jmpq   8009d9 <vprintfmt+0x257>
  800ac7:	e9 0d ff ff ff       	jmpq   8009d9 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800acc:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ad0:	e9 04 ff ff ff       	jmpq   8009d9 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ad5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad8:	83 f8 30             	cmp    $0x30,%eax
  800adb:	73 17                	jae    800af4 <vprintfmt+0x372>
  800add:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ae1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae4:	89 c0                	mov    %eax,%eax
  800ae6:	48 01 d0             	add    %rdx,%rax
  800ae9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aec:	83 c2 08             	add    $0x8,%edx
  800aef:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800af2:	eb 0f                	jmp    800b03 <vprintfmt+0x381>
  800af4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800af8:	48 89 d0             	mov    %rdx,%rax
  800afb:	48 83 c2 08          	add    $0x8,%rdx
  800aff:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b03:	8b 10                	mov    (%rax),%edx
  800b05:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0d:	48 89 ce             	mov    %rcx,%rsi
  800b10:	89 d7                	mov    %edx,%edi
  800b12:	ff d0                	callq  *%rax
			break;
  800b14:	e9 66 03 00 00       	jmpq   800e7f <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800b19:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1c:	83 f8 30             	cmp    $0x30,%eax
  800b1f:	73 17                	jae    800b38 <vprintfmt+0x3b6>
  800b21:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b28:	89 c0                	mov    %eax,%eax
  800b2a:	48 01 d0             	add    %rdx,%rax
  800b2d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b30:	83 c2 08             	add    $0x8,%edx
  800b33:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b36:	eb 0f                	jmp    800b47 <vprintfmt+0x3c5>
  800b38:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b3c:	48 89 d0             	mov    %rdx,%rax
  800b3f:	48 83 c2 08          	add    $0x8,%rdx
  800b43:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b47:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b49:	85 db                	test   %ebx,%ebx
  800b4b:	79 02                	jns    800b4f <vprintfmt+0x3cd>
				err = -err;
  800b4d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b4f:	83 fb 10             	cmp    $0x10,%ebx
  800b52:	7f 16                	jg     800b6a <vprintfmt+0x3e8>
  800b54:	48 b8 40 3e 80 00 00 	movabs $0x803e40,%rax
  800b5b:	00 00 00 
  800b5e:	48 63 d3             	movslq %ebx,%rdx
  800b61:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b65:	4d 85 e4             	test   %r12,%r12
  800b68:	75 2e                	jne    800b98 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800b6a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b72:	89 d9                	mov    %ebx,%ecx
  800b74:	48 ba d9 3e 80 00 00 	movabs $0x803ed9,%rdx
  800b7b:	00 00 00 
  800b7e:	48 89 c7             	mov    %rax,%rdi
  800b81:	b8 00 00 00 00       	mov    $0x0,%eax
  800b86:	49 b8 8d 0e 80 00 00 	movabs $0x800e8d,%r8
  800b8d:	00 00 00 
  800b90:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b93:	e9 e7 02 00 00       	jmpq   800e7f <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b98:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba0:	4c 89 e1             	mov    %r12,%rcx
  800ba3:	48 ba e2 3e 80 00 00 	movabs $0x803ee2,%rdx
  800baa:	00 00 00 
  800bad:	48 89 c7             	mov    %rax,%rdi
  800bb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb5:	49 b8 8d 0e 80 00 00 	movabs $0x800e8d,%r8
  800bbc:	00 00 00 
  800bbf:	41 ff d0             	callq  *%r8
			break;
  800bc2:	e9 b8 02 00 00       	jmpq   800e7f <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bc7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bca:	83 f8 30             	cmp    $0x30,%eax
  800bcd:	73 17                	jae    800be6 <vprintfmt+0x464>
  800bcf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bd3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd6:	89 c0                	mov    %eax,%eax
  800bd8:	48 01 d0             	add    %rdx,%rax
  800bdb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bde:	83 c2 08             	add    $0x8,%edx
  800be1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800be4:	eb 0f                	jmp    800bf5 <vprintfmt+0x473>
  800be6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bea:	48 89 d0             	mov    %rdx,%rax
  800bed:	48 83 c2 08          	add    $0x8,%rdx
  800bf1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bf5:	4c 8b 20             	mov    (%rax),%r12
  800bf8:	4d 85 e4             	test   %r12,%r12
  800bfb:	75 0a                	jne    800c07 <vprintfmt+0x485>
				p = "(null)";
  800bfd:	49 bc e5 3e 80 00 00 	movabs $0x803ee5,%r12
  800c04:	00 00 00 
			if (width > 0 && padc != '-')
  800c07:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c0b:	7e 3f                	jle    800c4c <vprintfmt+0x4ca>
  800c0d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c11:	74 39                	je     800c4c <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c13:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c16:	48 98                	cltq   
  800c18:	48 89 c6             	mov    %rax,%rsi
  800c1b:	4c 89 e7             	mov    %r12,%rdi
  800c1e:	48 b8 39 11 80 00 00 	movabs $0x801139,%rax
  800c25:	00 00 00 
  800c28:	ff d0                	callq  *%rax
  800c2a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c2d:	eb 17                	jmp    800c46 <vprintfmt+0x4c4>
					putch(padc, putdat);
  800c2f:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c33:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3b:	48 89 ce             	mov    %rcx,%rsi
  800c3e:	89 d7                	mov    %edx,%edi
  800c40:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c42:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c46:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c4a:	7f e3                	jg     800c2f <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c4c:	eb 37                	jmp    800c85 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800c4e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c52:	74 1e                	je     800c72 <vprintfmt+0x4f0>
  800c54:	83 fb 1f             	cmp    $0x1f,%ebx
  800c57:	7e 05                	jle    800c5e <vprintfmt+0x4dc>
  800c59:	83 fb 7e             	cmp    $0x7e,%ebx
  800c5c:	7e 14                	jle    800c72 <vprintfmt+0x4f0>
					putch('?', putdat);
  800c5e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c66:	48 89 d6             	mov    %rdx,%rsi
  800c69:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c6e:	ff d0                	callq  *%rax
  800c70:	eb 0f                	jmp    800c81 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800c72:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c76:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7a:	48 89 d6             	mov    %rdx,%rsi
  800c7d:	89 df                	mov    %ebx,%edi
  800c7f:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c81:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c85:	4c 89 e0             	mov    %r12,%rax
  800c88:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c8c:	0f b6 00             	movzbl (%rax),%eax
  800c8f:	0f be d8             	movsbl %al,%ebx
  800c92:	85 db                	test   %ebx,%ebx
  800c94:	74 10                	je     800ca6 <vprintfmt+0x524>
  800c96:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c9a:	78 b2                	js     800c4e <vprintfmt+0x4cc>
  800c9c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ca0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ca4:	79 a8                	jns    800c4e <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ca6:	eb 16                	jmp    800cbe <vprintfmt+0x53c>
				putch(' ', putdat);
  800ca8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb0:	48 89 d6             	mov    %rdx,%rsi
  800cb3:	bf 20 00 00 00       	mov    $0x20,%edi
  800cb8:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cba:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cbe:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cc2:	7f e4                	jg     800ca8 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800cc4:	e9 b6 01 00 00       	jmpq   800e7f <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800cc9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ccd:	be 03 00 00 00       	mov    $0x3,%esi
  800cd2:	48 89 c7             	mov    %rax,%rdi
  800cd5:	48 b8 72 06 80 00 00 	movabs $0x800672,%rax
  800cdc:	00 00 00 
  800cdf:	ff d0                	callq  *%rax
  800ce1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ce5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce9:	48 85 c0             	test   %rax,%rax
  800cec:	79 1d                	jns    800d0b <vprintfmt+0x589>
				putch('-', putdat);
  800cee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf6:	48 89 d6             	mov    %rdx,%rsi
  800cf9:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800cfe:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d04:	48 f7 d8             	neg    %rax
  800d07:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d0b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d12:	e9 fb 00 00 00       	jmpq   800e12 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d17:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d1b:	be 03 00 00 00       	mov    $0x3,%esi
  800d20:	48 89 c7             	mov    %rax,%rdi
  800d23:	48 b8 62 05 80 00 00 	movabs $0x800562,%rax
  800d2a:	00 00 00 
  800d2d:	ff d0                	callq  *%rax
  800d2f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d33:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d3a:	e9 d3 00 00 00       	jmpq   800e12 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800d3f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d43:	be 03 00 00 00       	mov    $0x3,%esi
  800d48:	48 89 c7             	mov    %rax,%rdi
  800d4b:	48 b8 72 06 80 00 00 	movabs $0x800672,%rax
  800d52:	00 00 00 
  800d55:	ff d0                	callq  *%rax
  800d57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d5f:	48 85 c0             	test   %rax,%rax
  800d62:	79 1d                	jns    800d81 <vprintfmt+0x5ff>
				putch('-', putdat);
  800d64:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d68:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d6c:	48 89 d6             	mov    %rdx,%rsi
  800d6f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d74:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d7a:	48 f7 d8             	neg    %rax
  800d7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800d81:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d88:	e9 85 00 00 00       	jmpq   800e12 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800d8d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d91:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d95:	48 89 d6             	mov    %rdx,%rsi
  800d98:	bf 30 00 00 00       	mov    $0x30,%edi
  800d9d:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d9f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800da3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800da7:	48 89 d6             	mov    %rdx,%rsi
  800daa:	bf 78 00 00 00       	mov    $0x78,%edi
  800daf:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800db1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db4:	83 f8 30             	cmp    $0x30,%eax
  800db7:	73 17                	jae    800dd0 <vprintfmt+0x64e>
  800db9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800dbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dc0:	89 c0                	mov    %eax,%eax
  800dc2:	48 01 d0             	add    %rdx,%rax
  800dc5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dc8:	83 c2 08             	add    $0x8,%edx
  800dcb:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dce:	eb 0f                	jmp    800ddf <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800dd0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dd4:	48 89 d0             	mov    %rdx,%rax
  800dd7:	48 83 c2 08          	add    $0x8,%rdx
  800ddb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ddf:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800de2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800de6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ded:	eb 23                	jmp    800e12 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800def:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800df3:	be 03 00 00 00       	mov    $0x3,%esi
  800df8:	48 89 c7             	mov    %rax,%rdi
  800dfb:	48 b8 62 05 80 00 00 	movabs $0x800562,%rax
  800e02:	00 00 00 
  800e05:	ff d0                	callq  *%rax
  800e07:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e0b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e12:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e17:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e1a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e1d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e21:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e25:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e29:	45 89 c1             	mov    %r8d,%r9d
  800e2c:	41 89 f8             	mov    %edi,%r8d
  800e2f:	48 89 c7             	mov    %rax,%rdi
  800e32:	48 b8 a7 04 80 00 00 	movabs $0x8004a7,%rax
  800e39:	00 00 00 
  800e3c:	ff d0                	callq  *%rax
			break;
  800e3e:	eb 3f                	jmp    800e7f <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e48:	48 89 d6             	mov    %rdx,%rsi
  800e4b:	89 df                	mov    %ebx,%edi
  800e4d:	ff d0                	callq  *%rax
			break;
  800e4f:	eb 2e                	jmp    800e7f <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e51:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e59:	48 89 d6             	mov    %rdx,%rsi
  800e5c:	bf 25 00 00 00       	mov    $0x25,%edi
  800e61:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e63:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e68:	eb 05                	jmp    800e6f <vprintfmt+0x6ed>
  800e6a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e6f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e73:	48 83 e8 01          	sub    $0x1,%rax
  800e77:	0f b6 00             	movzbl (%rax),%eax
  800e7a:	3c 25                	cmp    $0x25,%al
  800e7c:	75 ec                	jne    800e6a <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  800e7e:	90                   	nop
		}
	}
  800e7f:	e9 37 f9 ff ff       	jmpq   8007bb <vprintfmt+0x39>
    va_end(aq);
}
  800e84:	48 83 c4 60          	add    $0x60,%rsp
  800e88:	5b                   	pop    %rbx
  800e89:	41 5c                	pop    %r12
  800e8b:	5d                   	pop    %rbp
  800e8c:	c3                   	retq   

0000000000800e8d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e8d:	55                   	push   %rbp
  800e8e:	48 89 e5             	mov    %rsp,%rbp
  800e91:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e98:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e9f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ea6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ead:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800eb4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ebb:	84 c0                	test   %al,%al
  800ebd:	74 20                	je     800edf <printfmt+0x52>
  800ebf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ec3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ec7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ecb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ecf:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ed3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ed7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800edb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800edf:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ee6:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800eed:	00 00 00 
  800ef0:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ef7:	00 00 00 
  800efa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800efe:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f05:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f0c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f13:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f1a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f21:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f28:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f2f:	48 89 c7             	mov    %rax,%rdi
  800f32:	48 b8 82 07 80 00 00 	movabs $0x800782,%rax
  800f39:	00 00 00 
  800f3c:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f3e:	c9                   	leaveq 
  800f3f:	c3                   	retq   

0000000000800f40 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f40:	55                   	push   %rbp
  800f41:	48 89 e5             	mov    %rsp,%rbp
  800f44:	48 83 ec 10          	sub    $0x10,%rsp
  800f48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f4b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f53:	8b 40 10             	mov    0x10(%rax),%eax
  800f56:	8d 50 01             	lea    0x1(%rax),%edx
  800f59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f5d:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f64:	48 8b 10             	mov    (%rax),%rdx
  800f67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6b:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f6f:	48 39 c2             	cmp    %rax,%rdx
  800f72:	73 17                	jae    800f8b <sprintputch+0x4b>
		*b->buf++ = ch;
  800f74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f78:	48 8b 00             	mov    (%rax),%rax
  800f7b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f83:	48 89 0a             	mov    %rcx,(%rdx)
  800f86:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f89:	88 10                	mov    %dl,(%rax)
}
  800f8b:	c9                   	leaveq 
  800f8c:	c3                   	retq   

0000000000800f8d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f8d:	55                   	push   %rbp
  800f8e:	48 89 e5             	mov    %rsp,%rbp
  800f91:	48 83 ec 50          	sub    $0x50,%rsp
  800f95:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f99:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f9c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800fa0:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800fa4:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800fa8:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fac:	48 8b 0a             	mov    (%rdx),%rcx
  800faf:	48 89 08             	mov    %rcx,(%rax)
  800fb2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fb6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fba:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fbe:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fc2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fc6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800fca:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800fcd:	48 98                	cltq   
  800fcf:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800fd3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fd7:	48 01 d0             	add    %rdx,%rax
  800fda:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fde:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fe5:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800fea:	74 06                	je     800ff2 <vsnprintf+0x65>
  800fec:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ff0:	7f 07                	jg     800ff9 <vsnprintf+0x6c>
		return -E_INVAL;
  800ff2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff7:	eb 2f                	jmp    801028 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ff9:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ffd:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801001:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801005:	48 89 c6             	mov    %rax,%rsi
  801008:	48 bf 40 0f 80 00 00 	movabs $0x800f40,%rdi
  80100f:	00 00 00 
  801012:	48 b8 82 07 80 00 00 	movabs $0x800782,%rax
  801019:	00 00 00 
  80101c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80101e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801022:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801025:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801028:	c9                   	leaveq 
  801029:	c3                   	retq   

000000000080102a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80102a:	55                   	push   %rbp
  80102b:	48 89 e5             	mov    %rsp,%rbp
  80102e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801035:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80103c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801042:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801049:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801050:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801057:	84 c0                	test   %al,%al
  801059:	74 20                	je     80107b <snprintf+0x51>
  80105b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80105f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801063:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801067:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80106b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80106f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801073:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801077:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80107b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801082:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801089:	00 00 00 
  80108c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801093:	00 00 00 
  801096:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80109a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010a1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010a8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010af:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010b6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010bd:	48 8b 0a             	mov    (%rdx),%rcx
  8010c0:	48 89 08             	mov    %rcx,(%rax)
  8010c3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010c7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010cb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010cf:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010d3:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010da:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010e1:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010e7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010ee:	48 89 c7             	mov    %rax,%rdi
  8010f1:	48 b8 8d 0f 80 00 00 	movabs $0x800f8d,%rax
  8010f8:	00 00 00 
  8010fb:	ff d0                	callq  *%rax
  8010fd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801103:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801109:	c9                   	leaveq 
  80110a:	c3                   	retq   

000000000080110b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80110b:	55                   	push   %rbp
  80110c:	48 89 e5             	mov    %rsp,%rbp
  80110f:	48 83 ec 18          	sub    $0x18,%rsp
  801113:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801117:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80111e:	eb 09                	jmp    801129 <strlen+0x1e>
		n++;
  801120:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801124:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801129:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112d:	0f b6 00             	movzbl (%rax),%eax
  801130:	84 c0                	test   %al,%al
  801132:	75 ec                	jne    801120 <strlen+0x15>
		n++;
	return n;
  801134:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801137:	c9                   	leaveq 
  801138:	c3                   	retq   

0000000000801139 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801139:	55                   	push   %rbp
  80113a:	48 89 e5             	mov    %rsp,%rbp
  80113d:	48 83 ec 20          	sub    $0x20,%rsp
  801141:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801145:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801149:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801150:	eb 0e                	jmp    801160 <strnlen+0x27>
		n++;
  801152:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801156:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80115b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801160:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801165:	74 0b                	je     801172 <strnlen+0x39>
  801167:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116b:	0f b6 00             	movzbl (%rax),%eax
  80116e:	84 c0                	test   %al,%al
  801170:	75 e0                	jne    801152 <strnlen+0x19>
		n++;
	return n;
  801172:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801175:	c9                   	leaveq 
  801176:	c3                   	retq   

0000000000801177 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801177:	55                   	push   %rbp
  801178:	48 89 e5             	mov    %rsp,%rbp
  80117b:	48 83 ec 20          	sub    $0x20,%rsp
  80117f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801183:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801187:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80118f:	90                   	nop
  801190:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801194:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801198:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80119c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011a0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011a4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011a8:	0f b6 12             	movzbl (%rdx),%edx
  8011ab:	88 10                	mov    %dl,(%rax)
  8011ad:	0f b6 00             	movzbl (%rax),%eax
  8011b0:	84 c0                	test   %al,%al
  8011b2:	75 dc                	jne    801190 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011b8:	c9                   	leaveq 
  8011b9:	c3                   	retq   

00000000008011ba <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011ba:	55                   	push   %rbp
  8011bb:	48 89 e5             	mov    %rsp,%rbp
  8011be:	48 83 ec 20          	sub    $0x20,%rsp
  8011c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8011ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ce:	48 89 c7             	mov    %rax,%rdi
  8011d1:	48 b8 0b 11 80 00 00 	movabs $0x80110b,%rax
  8011d8:	00 00 00 
  8011db:	ff d0                	callq  *%rax
  8011dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011e3:	48 63 d0             	movslq %eax,%rdx
  8011e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ea:	48 01 c2             	add    %rax,%rdx
  8011ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011f1:	48 89 c6             	mov    %rax,%rsi
  8011f4:	48 89 d7             	mov    %rdx,%rdi
  8011f7:	48 b8 77 11 80 00 00 	movabs $0x801177,%rax
  8011fe:	00 00 00 
  801201:	ff d0                	callq  *%rax
	return dst;
  801203:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801207:	c9                   	leaveq 
  801208:	c3                   	retq   

0000000000801209 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801209:	55                   	push   %rbp
  80120a:	48 89 e5             	mov    %rsp,%rbp
  80120d:	48 83 ec 28          	sub    $0x28,%rsp
  801211:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801215:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801219:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80121d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801221:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801225:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80122c:	00 
  80122d:	eb 2a                	jmp    801259 <strncpy+0x50>
		*dst++ = *src;
  80122f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801233:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801237:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80123b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80123f:	0f b6 12             	movzbl (%rdx),%edx
  801242:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801244:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801248:	0f b6 00             	movzbl (%rax),%eax
  80124b:	84 c0                	test   %al,%al
  80124d:	74 05                	je     801254 <strncpy+0x4b>
			src++;
  80124f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801254:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801259:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801261:	72 cc                	jb     80122f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801263:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801267:	c9                   	leaveq 
  801268:	c3                   	retq   

0000000000801269 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801269:	55                   	push   %rbp
  80126a:	48 89 e5             	mov    %rsp,%rbp
  80126d:	48 83 ec 28          	sub    $0x28,%rsp
  801271:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801275:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801279:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80127d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801281:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801285:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80128a:	74 3d                	je     8012c9 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80128c:	eb 1d                	jmp    8012ab <strlcpy+0x42>
			*dst++ = *src++;
  80128e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801292:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801296:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80129a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80129e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012a2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012a6:	0f b6 12             	movzbl (%rdx),%edx
  8012a9:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012ab:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012b0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012b5:	74 0b                	je     8012c2 <strlcpy+0x59>
  8012b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012bb:	0f b6 00             	movzbl (%rax),%eax
  8012be:	84 c0                	test   %al,%al
  8012c0:	75 cc                	jne    80128e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8012c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c6:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d1:	48 29 c2             	sub    %rax,%rdx
  8012d4:	48 89 d0             	mov    %rdx,%rax
}
  8012d7:	c9                   	leaveq 
  8012d8:	c3                   	retq   

00000000008012d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012d9:	55                   	push   %rbp
  8012da:	48 89 e5             	mov    %rsp,%rbp
  8012dd:	48 83 ec 10          	sub    $0x10,%rsp
  8012e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012e9:	eb 0a                	jmp    8012f5 <strcmp+0x1c>
		p++, q++;
  8012eb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f9:	0f b6 00             	movzbl (%rax),%eax
  8012fc:	84 c0                	test   %al,%al
  8012fe:	74 12                	je     801312 <strcmp+0x39>
  801300:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801304:	0f b6 10             	movzbl (%rax),%edx
  801307:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130b:	0f b6 00             	movzbl (%rax),%eax
  80130e:	38 c2                	cmp    %al,%dl
  801310:	74 d9                	je     8012eb <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801312:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801316:	0f b6 00             	movzbl (%rax),%eax
  801319:	0f b6 d0             	movzbl %al,%edx
  80131c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801320:	0f b6 00             	movzbl (%rax),%eax
  801323:	0f b6 c0             	movzbl %al,%eax
  801326:	29 c2                	sub    %eax,%edx
  801328:	89 d0                	mov    %edx,%eax
}
  80132a:	c9                   	leaveq 
  80132b:	c3                   	retq   

000000000080132c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80132c:	55                   	push   %rbp
  80132d:	48 89 e5             	mov    %rsp,%rbp
  801330:	48 83 ec 18          	sub    $0x18,%rsp
  801334:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801338:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80133c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801340:	eb 0f                	jmp    801351 <strncmp+0x25>
		n--, p++, q++;
  801342:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801347:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80134c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801351:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801356:	74 1d                	je     801375 <strncmp+0x49>
  801358:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135c:	0f b6 00             	movzbl (%rax),%eax
  80135f:	84 c0                	test   %al,%al
  801361:	74 12                	je     801375 <strncmp+0x49>
  801363:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801367:	0f b6 10             	movzbl (%rax),%edx
  80136a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136e:	0f b6 00             	movzbl (%rax),%eax
  801371:	38 c2                	cmp    %al,%dl
  801373:	74 cd                	je     801342 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801375:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80137a:	75 07                	jne    801383 <strncmp+0x57>
		return 0;
  80137c:	b8 00 00 00 00       	mov    $0x0,%eax
  801381:	eb 18                	jmp    80139b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801383:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801387:	0f b6 00             	movzbl (%rax),%eax
  80138a:	0f b6 d0             	movzbl %al,%edx
  80138d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801391:	0f b6 00             	movzbl (%rax),%eax
  801394:	0f b6 c0             	movzbl %al,%eax
  801397:	29 c2                	sub    %eax,%edx
  801399:	89 d0                	mov    %edx,%eax
}
  80139b:	c9                   	leaveq 
  80139c:	c3                   	retq   

000000000080139d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80139d:	55                   	push   %rbp
  80139e:	48 89 e5             	mov    %rsp,%rbp
  8013a1:	48 83 ec 0c          	sub    $0xc,%rsp
  8013a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013a9:	89 f0                	mov    %esi,%eax
  8013ab:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013ae:	eb 17                	jmp    8013c7 <strchr+0x2a>
		if (*s == c)
  8013b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b4:	0f b6 00             	movzbl (%rax),%eax
  8013b7:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013ba:	75 06                	jne    8013c2 <strchr+0x25>
			return (char *) s;
  8013bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c0:	eb 15                	jmp    8013d7 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cb:	0f b6 00             	movzbl (%rax),%eax
  8013ce:	84 c0                	test   %al,%al
  8013d0:	75 de                	jne    8013b0 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8013d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013d7:	c9                   	leaveq 
  8013d8:	c3                   	retq   

00000000008013d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013d9:	55                   	push   %rbp
  8013da:	48 89 e5             	mov    %rsp,%rbp
  8013dd:	48 83 ec 0c          	sub    $0xc,%rsp
  8013e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013e5:	89 f0                	mov    %esi,%eax
  8013e7:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013ea:	eb 13                	jmp    8013ff <strfind+0x26>
		if (*s == c)
  8013ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f0:	0f b6 00             	movzbl (%rax),%eax
  8013f3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013f6:	75 02                	jne    8013fa <strfind+0x21>
			break;
  8013f8:	eb 10                	jmp    80140a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013fa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801403:	0f b6 00             	movzbl (%rax),%eax
  801406:	84 c0                	test   %al,%al
  801408:	75 e2                	jne    8013ec <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80140a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80140e:	c9                   	leaveq 
  80140f:	c3                   	retq   

0000000000801410 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801410:	55                   	push   %rbp
  801411:	48 89 e5             	mov    %rsp,%rbp
  801414:	48 83 ec 18          	sub    $0x18,%rsp
  801418:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80141c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80141f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801423:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801428:	75 06                	jne    801430 <memset+0x20>
		return v;
  80142a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142e:	eb 69                	jmp    801499 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801430:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801434:	83 e0 03             	and    $0x3,%eax
  801437:	48 85 c0             	test   %rax,%rax
  80143a:	75 48                	jne    801484 <memset+0x74>
  80143c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801440:	83 e0 03             	and    $0x3,%eax
  801443:	48 85 c0             	test   %rax,%rax
  801446:	75 3c                	jne    801484 <memset+0x74>
		c &= 0xFF;
  801448:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80144f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801452:	c1 e0 18             	shl    $0x18,%eax
  801455:	89 c2                	mov    %eax,%edx
  801457:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80145a:	c1 e0 10             	shl    $0x10,%eax
  80145d:	09 c2                	or     %eax,%edx
  80145f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801462:	c1 e0 08             	shl    $0x8,%eax
  801465:	09 d0                	or     %edx,%eax
  801467:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80146a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80146e:	48 c1 e8 02          	shr    $0x2,%rax
  801472:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801475:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801479:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80147c:	48 89 d7             	mov    %rdx,%rdi
  80147f:	fc                   	cld    
  801480:	f3 ab                	rep stos %eax,%es:(%rdi)
  801482:	eb 11                	jmp    801495 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801484:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801488:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80148b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80148f:	48 89 d7             	mov    %rdx,%rdi
  801492:	fc                   	cld    
  801493:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801495:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801499:	c9                   	leaveq 
  80149a:	c3                   	retq   

000000000080149b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80149b:	55                   	push   %rbp
  80149c:	48 89 e5             	mov    %rsp,%rbp
  80149f:	48 83 ec 28          	sub    $0x28,%rsp
  8014a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014c7:	0f 83 88 00 00 00    	jae    801555 <memmove+0xba>
  8014cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d5:	48 01 d0             	add    %rdx,%rax
  8014d8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014dc:	76 77                	jbe    801555 <memmove+0xba>
		s += n;
  8014de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e2:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ea:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f2:	83 e0 03             	and    $0x3,%eax
  8014f5:	48 85 c0             	test   %rax,%rax
  8014f8:	75 3b                	jne    801535 <memmove+0x9a>
  8014fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fe:	83 e0 03             	and    $0x3,%eax
  801501:	48 85 c0             	test   %rax,%rax
  801504:	75 2f                	jne    801535 <memmove+0x9a>
  801506:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150a:	83 e0 03             	and    $0x3,%eax
  80150d:	48 85 c0             	test   %rax,%rax
  801510:	75 23                	jne    801535 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801512:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801516:	48 83 e8 04          	sub    $0x4,%rax
  80151a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80151e:	48 83 ea 04          	sub    $0x4,%rdx
  801522:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801526:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80152a:	48 89 c7             	mov    %rax,%rdi
  80152d:	48 89 d6             	mov    %rdx,%rsi
  801530:	fd                   	std    
  801531:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801533:	eb 1d                	jmp    801552 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801535:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801539:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80153d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801541:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801545:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801549:	48 89 d7             	mov    %rdx,%rdi
  80154c:	48 89 c1             	mov    %rax,%rcx
  80154f:	fd                   	std    
  801550:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801552:	fc                   	cld    
  801553:	eb 57                	jmp    8015ac <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801555:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801559:	83 e0 03             	and    $0x3,%eax
  80155c:	48 85 c0             	test   %rax,%rax
  80155f:	75 36                	jne    801597 <memmove+0xfc>
  801561:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801565:	83 e0 03             	and    $0x3,%eax
  801568:	48 85 c0             	test   %rax,%rax
  80156b:	75 2a                	jne    801597 <memmove+0xfc>
  80156d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801571:	83 e0 03             	and    $0x3,%eax
  801574:	48 85 c0             	test   %rax,%rax
  801577:	75 1e                	jne    801597 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801579:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157d:	48 c1 e8 02          	shr    $0x2,%rax
  801581:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801584:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801588:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80158c:	48 89 c7             	mov    %rax,%rdi
  80158f:	48 89 d6             	mov    %rdx,%rsi
  801592:	fc                   	cld    
  801593:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801595:	eb 15                	jmp    8015ac <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801597:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80159f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015a3:	48 89 c7             	mov    %rax,%rdi
  8015a6:	48 89 d6             	mov    %rdx,%rsi
  8015a9:	fc                   	cld    
  8015aa:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015b0:	c9                   	leaveq 
  8015b1:	c3                   	retq   

00000000008015b2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015b2:	55                   	push   %rbp
  8015b3:	48 89 e5             	mov    %rsp,%rbp
  8015b6:	48 83 ec 18          	sub    $0x18,%rsp
  8015ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015c2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015ca:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d2:	48 89 ce             	mov    %rcx,%rsi
  8015d5:	48 89 c7             	mov    %rax,%rdi
  8015d8:	48 b8 9b 14 80 00 00 	movabs $0x80149b,%rax
  8015df:	00 00 00 
  8015e2:	ff d0                	callq  *%rax
}
  8015e4:	c9                   	leaveq 
  8015e5:	c3                   	retq   

00000000008015e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015e6:	55                   	push   %rbp
  8015e7:	48 89 e5             	mov    %rsp,%rbp
  8015ea:	48 83 ec 28          	sub    $0x28,%rsp
  8015ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801602:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801606:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80160a:	eb 36                	jmp    801642 <memcmp+0x5c>
		if (*s1 != *s2)
  80160c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801610:	0f b6 10             	movzbl (%rax),%edx
  801613:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801617:	0f b6 00             	movzbl (%rax),%eax
  80161a:	38 c2                	cmp    %al,%dl
  80161c:	74 1a                	je     801638 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80161e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801622:	0f b6 00             	movzbl (%rax),%eax
  801625:	0f b6 d0             	movzbl %al,%edx
  801628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162c:	0f b6 00             	movzbl (%rax),%eax
  80162f:	0f b6 c0             	movzbl %al,%eax
  801632:	29 c2                	sub    %eax,%edx
  801634:	89 d0                	mov    %edx,%eax
  801636:	eb 20                	jmp    801658 <memcmp+0x72>
		s1++, s2++;
  801638:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80163d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801642:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801646:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80164a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80164e:	48 85 c0             	test   %rax,%rax
  801651:	75 b9                	jne    80160c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801653:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801658:	c9                   	leaveq 
  801659:	c3                   	retq   

000000000080165a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80165a:	55                   	push   %rbp
  80165b:	48 89 e5             	mov    %rsp,%rbp
  80165e:	48 83 ec 28          	sub    $0x28,%rsp
  801662:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801666:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801669:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80166d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801671:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801675:	48 01 d0             	add    %rdx,%rax
  801678:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80167c:	eb 15                	jmp    801693 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80167e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801682:	0f b6 10             	movzbl (%rax),%edx
  801685:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801688:	38 c2                	cmp    %al,%dl
  80168a:	75 02                	jne    80168e <memfind+0x34>
			break;
  80168c:	eb 0f                	jmp    80169d <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80168e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801693:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801697:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80169b:	72 e1                	jb     80167e <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80169d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016a1:	c9                   	leaveq 
  8016a2:	c3                   	retq   

00000000008016a3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016a3:	55                   	push   %rbp
  8016a4:	48 89 e5             	mov    %rsp,%rbp
  8016a7:	48 83 ec 34          	sub    $0x34,%rsp
  8016ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016b3:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016bd:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016c4:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016c5:	eb 05                	jmp    8016cc <strtol+0x29>
		s++;
  8016c7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d0:	0f b6 00             	movzbl (%rax),%eax
  8016d3:	3c 20                	cmp    $0x20,%al
  8016d5:	74 f0                	je     8016c7 <strtol+0x24>
  8016d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016db:	0f b6 00             	movzbl (%rax),%eax
  8016de:	3c 09                	cmp    $0x9,%al
  8016e0:	74 e5                	je     8016c7 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e6:	0f b6 00             	movzbl (%rax),%eax
  8016e9:	3c 2b                	cmp    $0x2b,%al
  8016eb:	75 07                	jne    8016f4 <strtol+0x51>
		s++;
  8016ed:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016f2:	eb 17                	jmp    80170b <strtol+0x68>
	else if (*s == '-')
  8016f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f8:	0f b6 00             	movzbl (%rax),%eax
  8016fb:	3c 2d                	cmp    $0x2d,%al
  8016fd:	75 0c                	jne    80170b <strtol+0x68>
		s++, neg = 1;
  8016ff:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801704:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80170b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80170f:	74 06                	je     801717 <strtol+0x74>
  801711:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801715:	75 28                	jne    80173f <strtol+0x9c>
  801717:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171b:	0f b6 00             	movzbl (%rax),%eax
  80171e:	3c 30                	cmp    $0x30,%al
  801720:	75 1d                	jne    80173f <strtol+0x9c>
  801722:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801726:	48 83 c0 01          	add    $0x1,%rax
  80172a:	0f b6 00             	movzbl (%rax),%eax
  80172d:	3c 78                	cmp    $0x78,%al
  80172f:	75 0e                	jne    80173f <strtol+0x9c>
		s += 2, base = 16;
  801731:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801736:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80173d:	eb 2c                	jmp    80176b <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80173f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801743:	75 19                	jne    80175e <strtol+0xbb>
  801745:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801749:	0f b6 00             	movzbl (%rax),%eax
  80174c:	3c 30                	cmp    $0x30,%al
  80174e:	75 0e                	jne    80175e <strtol+0xbb>
		s++, base = 8;
  801750:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801755:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80175c:	eb 0d                	jmp    80176b <strtol+0xc8>
	else if (base == 0)
  80175e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801762:	75 07                	jne    80176b <strtol+0xc8>
		base = 10;
  801764:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80176b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176f:	0f b6 00             	movzbl (%rax),%eax
  801772:	3c 2f                	cmp    $0x2f,%al
  801774:	7e 1d                	jle    801793 <strtol+0xf0>
  801776:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177a:	0f b6 00             	movzbl (%rax),%eax
  80177d:	3c 39                	cmp    $0x39,%al
  80177f:	7f 12                	jg     801793 <strtol+0xf0>
			dig = *s - '0';
  801781:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801785:	0f b6 00             	movzbl (%rax),%eax
  801788:	0f be c0             	movsbl %al,%eax
  80178b:	83 e8 30             	sub    $0x30,%eax
  80178e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801791:	eb 4e                	jmp    8017e1 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801793:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801797:	0f b6 00             	movzbl (%rax),%eax
  80179a:	3c 60                	cmp    $0x60,%al
  80179c:	7e 1d                	jle    8017bb <strtol+0x118>
  80179e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a2:	0f b6 00             	movzbl (%rax),%eax
  8017a5:	3c 7a                	cmp    $0x7a,%al
  8017a7:	7f 12                	jg     8017bb <strtol+0x118>
			dig = *s - 'a' + 10;
  8017a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ad:	0f b6 00             	movzbl (%rax),%eax
  8017b0:	0f be c0             	movsbl %al,%eax
  8017b3:	83 e8 57             	sub    $0x57,%eax
  8017b6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017b9:	eb 26                	jmp    8017e1 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bf:	0f b6 00             	movzbl (%rax),%eax
  8017c2:	3c 40                	cmp    $0x40,%al
  8017c4:	7e 48                	jle    80180e <strtol+0x16b>
  8017c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ca:	0f b6 00             	movzbl (%rax),%eax
  8017cd:	3c 5a                	cmp    $0x5a,%al
  8017cf:	7f 3d                	jg     80180e <strtol+0x16b>
			dig = *s - 'A' + 10;
  8017d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d5:	0f b6 00             	movzbl (%rax),%eax
  8017d8:	0f be c0             	movsbl %al,%eax
  8017db:	83 e8 37             	sub    $0x37,%eax
  8017de:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017e4:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017e7:	7c 02                	jl     8017eb <strtol+0x148>
			break;
  8017e9:	eb 23                	jmp    80180e <strtol+0x16b>
		s++, val = (val * base) + dig;
  8017eb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017f0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017f3:	48 98                	cltq   
  8017f5:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017fa:	48 89 c2             	mov    %rax,%rdx
  8017fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801800:	48 98                	cltq   
  801802:	48 01 d0             	add    %rdx,%rax
  801805:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801809:	e9 5d ff ff ff       	jmpq   80176b <strtol+0xc8>

	if (endptr)
  80180e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801813:	74 0b                	je     801820 <strtol+0x17d>
		*endptr = (char *) s;
  801815:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801819:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80181d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801820:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801824:	74 09                	je     80182f <strtol+0x18c>
  801826:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80182a:	48 f7 d8             	neg    %rax
  80182d:	eb 04                	jmp    801833 <strtol+0x190>
  80182f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801833:	c9                   	leaveq 
  801834:	c3                   	retq   

0000000000801835 <strstr>:

char * strstr(const char *in, const char *str)
{
  801835:	55                   	push   %rbp
  801836:	48 89 e5             	mov    %rsp,%rbp
  801839:	48 83 ec 30          	sub    $0x30,%rsp
  80183d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801841:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801845:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801849:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80184d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801851:	0f b6 00             	movzbl (%rax),%eax
  801854:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801857:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80185b:	75 06                	jne    801863 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  80185d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801861:	eb 6b                	jmp    8018ce <strstr+0x99>

    len = strlen(str);
  801863:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801867:	48 89 c7             	mov    %rax,%rdi
  80186a:	48 b8 0b 11 80 00 00 	movabs $0x80110b,%rax
  801871:	00 00 00 
  801874:	ff d0                	callq  *%rax
  801876:	48 98                	cltq   
  801878:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80187c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801880:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801884:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801888:	0f b6 00             	movzbl (%rax),%eax
  80188b:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  80188e:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801892:	75 07                	jne    80189b <strstr+0x66>
                return (char *) 0;
  801894:	b8 00 00 00 00       	mov    $0x0,%eax
  801899:	eb 33                	jmp    8018ce <strstr+0x99>
        } while (sc != c);
  80189b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80189f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018a2:	75 d8                	jne    80187c <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  8018a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018a8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b0:	48 89 ce             	mov    %rcx,%rsi
  8018b3:	48 89 c7             	mov    %rax,%rdi
  8018b6:	48 b8 2c 13 80 00 00 	movabs $0x80132c,%rax
  8018bd:	00 00 00 
  8018c0:	ff d0                	callq  *%rax
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	75 b6                	jne    80187c <strstr+0x47>

    return (char *) (in - 1);
  8018c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ca:	48 83 e8 01          	sub    $0x1,%rax
}
  8018ce:	c9                   	leaveq 
  8018cf:	c3                   	retq   

00000000008018d0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018d0:	55                   	push   %rbp
  8018d1:	48 89 e5             	mov    %rsp,%rbp
  8018d4:	53                   	push   %rbx
  8018d5:	48 83 ec 48          	sub    $0x48,%rsp
  8018d9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018dc:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018df:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018e3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018e7:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018eb:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018ef:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018f2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018f6:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018fa:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018fe:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801902:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801906:	4c 89 c3             	mov    %r8,%rbx
  801909:	cd 30                	int    $0x30
  80190b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  80190f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801913:	74 3e                	je     801953 <syscall+0x83>
  801915:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80191a:	7e 37                	jle    801953 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80191c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801920:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801923:	49 89 d0             	mov    %rdx,%r8
  801926:	89 c1                	mov    %eax,%ecx
  801928:	48 ba a0 41 80 00 00 	movabs $0x8041a0,%rdx
  80192f:	00 00 00 
  801932:	be 23 00 00 00       	mov    $0x23,%esi
  801937:	48 bf bd 41 80 00 00 	movabs $0x8041bd,%rdi
  80193e:	00 00 00 
  801941:	b8 00 00 00 00       	mov    $0x0,%eax
  801946:	49 b9 f5 39 80 00 00 	movabs $0x8039f5,%r9
  80194d:	00 00 00 
  801950:	41 ff d1             	callq  *%r9

	return ret;
  801953:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801957:	48 83 c4 48          	add    $0x48,%rsp
  80195b:	5b                   	pop    %rbx
  80195c:	5d                   	pop    %rbp
  80195d:	c3                   	retq   

000000000080195e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80195e:	55                   	push   %rbp
  80195f:	48 89 e5             	mov    %rsp,%rbp
  801962:	48 83 ec 20          	sub    $0x20,%rsp
  801966:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80196a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80196e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801972:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801976:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197d:	00 
  80197e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801984:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198a:	48 89 d1             	mov    %rdx,%rcx
  80198d:	48 89 c2             	mov    %rax,%rdx
  801990:	be 00 00 00 00       	mov    $0x0,%esi
  801995:	bf 00 00 00 00       	mov    $0x0,%edi
  80199a:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  8019a1:	00 00 00 
  8019a4:	ff d0                	callq  *%rax
}
  8019a6:	c9                   	leaveq 
  8019a7:	c3                   	retq   

00000000008019a8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019a8:	55                   	push   %rbp
  8019a9:	48 89 e5             	mov    %rsp,%rbp
  8019ac:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019b0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b7:	00 
  8019b8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019be:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ce:	be 00 00 00 00       	mov    $0x0,%esi
  8019d3:	bf 01 00 00 00       	mov    $0x1,%edi
  8019d8:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  8019df:	00 00 00 
  8019e2:	ff d0                	callq  *%rax
}
  8019e4:	c9                   	leaveq 
  8019e5:	c3                   	retq   

00000000008019e6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019e6:	55                   	push   %rbp
  8019e7:	48 89 e5             	mov    %rsp,%rbp
  8019ea:	48 83 ec 10          	sub    $0x10,%rsp
  8019ee:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f4:	48 98                	cltq   
  8019f6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019fd:	00 
  8019fe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a04:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a0f:	48 89 c2             	mov    %rax,%rdx
  801a12:	be 01 00 00 00       	mov    $0x1,%esi
  801a17:	bf 03 00 00 00       	mov    $0x3,%edi
  801a1c:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  801a23:	00 00 00 
  801a26:	ff d0                	callq  *%rax
}
  801a28:	c9                   	leaveq 
  801a29:	c3                   	retq   

0000000000801a2a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a2a:	55                   	push   %rbp
  801a2b:	48 89 e5             	mov    %rsp,%rbp
  801a2e:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a32:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a39:	00 
  801a3a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a40:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a46:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a50:	be 00 00 00 00       	mov    $0x0,%esi
  801a55:	bf 02 00 00 00       	mov    $0x2,%edi
  801a5a:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  801a61:	00 00 00 
  801a64:	ff d0                	callq  *%rax
}
  801a66:	c9                   	leaveq 
  801a67:	c3                   	retq   

0000000000801a68 <sys_yield>:

void
sys_yield(void)
{
  801a68:	55                   	push   %rbp
  801a69:	48 89 e5             	mov    %rsp,%rbp
  801a6c:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a70:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a77:	00 
  801a78:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a84:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a89:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8e:	be 00 00 00 00       	mov    $0x0,%esi
  801a93:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a98:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  801a9f:	00 00 00 
  801aa2:	ff d0                	callq  *%rax
}
  801aa4:	c9                   	leaveq 
  801aa5:	c3                   	retq   

0000000000801aa6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801aa6:	55                   	push   %rbp
  801aa7:	48 89 e5             	mov    %rsp,%rbp
  801aaa:	48 83 ec 20          	sub    $0x20,%rsp
  801aae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ab1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ab5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ab8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801abb:	48 63 c8             	movslq %eax,%rcx
  801abe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac5:	48 98                	cltq   
  801ac7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ace:	00 
  801acf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad5:	49 89 c8             	mov    %rcx,%r8
  801ad8:	48 89 d1             	mov    %rdx,%rcx
  801adb:	48 89 c2             	mov    %rax,%rdx
  801ade:	be 01 00 00 00       	mov    $0x1,%esi
  801ae3:	bf 04 00 00 00       	mov    $0x4,%edi
  801ae8:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  801aef:	00 00 00 
  801af2:	ff d0                	callq  *%rax
}
  801af4:	c9                   	leaveq 
  801af5:	c3                   	retq   

0000000000801af6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801af6:	55                   	push   %rbp
  801af7:	48 89 e5             	mov    %rsp,%rbp
  801afa:	48 83 ec 30          	sub    $0x30,%rsp
  801afe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b05:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b08:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b0c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b10:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b13:	48 63 c8             	movslq %eax,%rcx
  801b16:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b1d:	48 63 f0             	movslq %eax,%rsi
  801b20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b27:	48 98                	cltq   
  801b29:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b2d:	49 89 f9             	mov    %rdi,%r9
  801b30:	49 89 f0             	mov    %rsi,%r8
  801b33:	48 89 d1             	mov    %rdx,%rcx
  801b36:	48 89 c2             	mov    %rax,%rdx
  801b39:	be 01 00 00 00       	mov    $0x1,%esi
  801b3e:	bf 05 00 00 00       	mov    $0x5,%edi
  801b43:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  801b4a:	00 00 00 
  801b4d:	ff d0                	callq  *%rax
}
  801b4f:	c9                   	leaveq 
  801b50:	c3                   	retq   

0000000000801b51 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b51:	55                   	push   %rbp
  801b52:	48 89 e5             	mov    %rsp,%rbp
  801b55:	48 83 ec 20          	sub    $0x20,%rsp
  801b59:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b5c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b67:	48 98                	cltq   
  801b69:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b70:	00 
  801b71:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b77:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b7d:	48 89 d1             	mov    %rdx,%rcx
  801b80:	48 89 c2             	mov    %rax,%rdx
  801b83:	be 01 00 00 00       	mov    $0x1,%esi
  801b88:	bf 06 00 00 00       	mov    $0x6,%edi
  801b8d:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  801b94:	00 00 00 
  801b97:	ff d0                	callq  *%rax
}
  801b99:	c9                   	leaveq 
  801b9a:	c3                   	retq   

0000000000801b9b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b9b:	55                   	push   %rbp
  801b9c:	48 89 e5             	mov    %rsp,%rbp
  801b9f:	48 83 ec 10          	sub    $0x10,%rsp
  801ba3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ba9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bac:	48 63 d0             	movslq %eax,%rdx
  801baf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb2:	48 98                	cltq   
  801bb4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bbb:	00 
  801bbc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc8:	48 89 d1             	mov    %rdx,%rcx
  801bcb:	48 89 c2             	mov    %rax,%rdx
  801bce:	be 01 00 00 00       	mov    $0x1,%esi
  801bd3:	bf 08 00 00 00       	mov    $0x8,%edi
  801bd8:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  801bdf:	00 00 00 
  801be2:	ff d0                	callq  *%rax
}
  801be4:	c9                   	leaveq 
  801be5:	c3                   	retq   

0000000000801be6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801be6:	55                   	push   %rbp
  801be7:	48 89 e5             	mov    %rsp,%rbp
  801bea:	48 83 ec 20          	sub    $0x20,%rsp
  801bee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bf5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bfc:	48 98                	cltq   
  801bfe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c05:	00 
  801c06:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c0c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c12:	48 89 d1             	mov    %rdx,%rcx
  801c15:	48 89 c2             	mov    %rax,%rdx
  801c18:	be 01 00 00 00       	mov    $0x1,%esi
  801c1d:	bf 09 00 00 00       	mov    $0x9,%edi
  801c22:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  801c29:	00 00 00 
  801c2c:	ff d0                	callq  *%rax
}
  801c2e:	c9                   	leaveq 
  801c2f:	c3                   	retq   

0000000000801c30 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c30:	55                   	push   %rbp
  801c31:	48 89 e5             	mov    %rsp,%rbp
  801c34:	48 83 ec 20          	sub    $0x20,%rsp
  801c38:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c3b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c46:	48 98                	cltq   
  801c48:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c4f:	00 
  801c50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c5c:	48 89 d1             	mov    %rdx,%rcx
  801c5f:	48 89 c2             	mov    %rax,%rdx
  801c62:	be 01 00 00 00       	mov    $0x1,%esi
  801c67:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c6c:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  801c73:	00 00 00 
  801c76:	ff d0                	callq  *%rax
}
  801c78:	c9                   	leaveq 
  801c79:	c3                   	retq   

0000000000801c7a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c7a:	55                   	push   %rbp
  801c7b:	48 89 e5             	mov    %rsp,%rbp
  801c7e:	48 83 ec 20          	sub    $0x20,%rsp
  801c82:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c85:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c89:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c8d:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c90:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c93:	48 63 f0             	movslq %eax,%rsi
  801c96:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c9d:	48 98                	cltq   
  801c9f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801caa:	00 
  801cab:	49 89 f1             	mov    %rsi,%r9
  801cae:	49 89 c8             	mov    %rcx,%r8
  801cb1:	48 89 d1             	mov    %rdx,%rcx
  801cb4:	48 89 c2             	mov    %rax,%rdx
  801cb7:	be 00 00 00 00       	mov    $0x0,%esi
  801cbc:	bf 0c 00 00 00       	mov    $0xc,%edi
  801cc1:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  801cc8:	00 00 00 
  801ccb:	ff d0                	callq  *%rax
}
  801ccd:	c9                   	leaveq 
  801cce:	c3                   	retq   

0000000000801ccf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ccf:	55                   	push   %rbp
  801cd0:	48 89 e5             	mov    %rsp,%rbp
  801cd3:	48 83 ec 10          	sub    $0x10,%rsp
  801cd7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801cdb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cdf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce6:	00 
  801ce7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ced:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cf8:	48 89 c2             	mov    %rax,%rdx
  801cfb:	be 01 00 00 00       	mov    $0x1,%esi
  801d00:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d05:	48 b8 d0 18 80 00 00 	movabs $0x8018d0,%rax
  801d0c:	00 00 00 
  801d0f:	ff d0                	callq  *%rax
}
  801d11:	c9                   	leaveq 
  801d12:	c3                   	retq   

0000000000801d13 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801d13:	55                   	push   %rbp
  801d14:	48 89 e5             	mov    %rsp,%rbp
  801d17:	48 83 ec 30          	sub    $0x30,%rsp
  801d1b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801d1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d23:	48 8b 00             	mov    (%rax),%rax
  801d26:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801d2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d2e:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d32:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)))
  801d35:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d38:	83 e0 02             	and    $0x2,%eax
  801d3b:	85 c0                	test   %eax,%eax
  801d3d:	74 23                	je     801d62 <pgfault+0x4f>
  801d3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d43:	48 c1 e8 0c          	shr    $0xc,%rax
  801d47:	48 89 c2             	mov    %rax,%rdx
  801d4a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d51:	01 00 00 
  801d54:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d58:	25 00 08 00 00       	and    $0x800,%eax
  801d5d:	48 85 c0             	test   %rax,%rax
  801d60:	75 2a                	jne    801d8c <pgfault+0x79>
		panic("fail check at fork pgfault");
  801d62:	48 ba cb 41 80 00 00 	movabs $0x8041cb,%rdx
  801d69:	00 00 00 
  801d6c:	be 1d 00 00 00       	mov    $0x1d,%esi
  801d71:	48 bf e6 41 80 00 00 	movabs $0x8041e6,%rdi
  801d78:	00 00 00 
  801d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d80:	48 b9 f5 39 80 00 00 	movabs $0x8039f5,%rcx
  801d87:	00 00 00 
  801d8a:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801d8c:	ba 07 00 00 00       	mov    $0x7,%edx
  801d91:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d96:	bf 00 00 00 00       	mov    $0x0,%edi
  801d9b:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  801da2:	00 00 00 
  801da5:	ff d0                	callq  *%rax

	addr = ROUNDDOWN(addr, PGSIZE);
  801da7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801daf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801db3:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801db9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memmove(PFTEMP, addr, PGSIZE);
  801dbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc1:	ba 00 10 00 00       	mov    $0x1000,%edx
  801dc6:	48 89 c6             	mov    %rax,%rsi
  801dc9:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801dce:	48 b8 9b 14 80 00 00 	movabs $0x80149b,%rax
  801dd5:	00 00 00 
  801dd8:	ff d0                	callq  *%rax

	sys_page_map(0, (void *)PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W);
  801dda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dde:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801de4:	48 89 c1             	mov    %rax,%rcx
  801de7:	ba 00 00 00 00       	mov    $0x0,%edx
  801dec:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801df1:	bf 00 00 00 00       	mov    $0x0,%edi
  801df6:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  801dfd:	00 00 00 
  801e00:	ff d0                	callq  *%rax
	sys_page_unmap(0, PFTEMP);
  801e02:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e07:	bf 00 00 00 00       	mov    $0x0,%edi
  801e0c:	48 b8 51 1b 80 00 00 	movabs $0x801b51,%rax
  801e13:	00 00 00 
  801e16:	ff d0                	callq  *%rax
	//panic("pgfault not implemented");
}
  801e18:	c9                   	leaveq 
  801e19:	c3                   	retq   

0000000000801e1a <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801e1a:	55                   	push   %rbp
  801e1b:	48 89 e5             	mov    %rsp,%rbp
  801e1e:	48 83 ec 20          	sub    $0x20,%rsp
  801e22:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e25:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uintptr_t)pn * PGSIZE);
  801e28:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801e2b:	48 c1 e0 0c          	shl    $0xc,%rax
  801e2f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	// note: modified for LAB 5, supporting PTE_SHARE
	if (uvpt[pn] & PTE_SHARE) {
  801e33:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e3a:	01 00 00 
  801e3d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e40:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e44:	25 00 04 00 00       	and    $0x400,%eax
  801e49:	48 85 c0             	test   %rax,%rax
  801e4c:	74 55                	je     801ea3 <duppage+0x89>
		if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL))) < 0)
  801e4e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e55:	01 00 00 
  801e58:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e5b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e5f:	25 07 0e 00 00       	and    $0xe07,%eax
  801e64:	89 c6                	mov    %eax,%esi
  801e66:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801e6a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e71:	41 89 f0             	mov    %esi,%r8d
  801e74:	48 89 c6             	mov    %rax,%rsi
  801e77:	bf 00 00 00 00       	mov    $0x0,%edi
  801e7c:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  801e83:	00 00 00 
  801e86:	ff d0                	callq  *%rax
  801e88:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801e8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e8f:	79 08                	jns    801e99 <duppage+0x7f>
			return r;
  801e91:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e94:	e9 e1 00 00 00       	jmpq   801f7a <duppage+0x160>
		return 0;
  801e99:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9e:	e9 d7 00 00 00       	jmpq   801f7a <duppage+0x160>
	}

	// note: here we must set ~PTE_W and PTE_COW such that parent process can get correct pid
	if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  801ea3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eaa:	01 00 00 
  801ead:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801eb0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eb4:	25 05 06 00 00       	and    $0x605,%eax
  801eb9:	80 cc 08             	or     $0x8,%ah
  801ebc:	89 c6                	mov    %eax,%esi
  801ebe:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801ec2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ec5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ec9:	41 89 f0             	mov    %esi,%r8d
  801ecc:	48 89 c6             	mov    %rax,%rsi
  801ecf:	bf 00 00 00 00       	mov    $0x0,%edi
  801ed4:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  801edb:	00 00 00 
  801ede:	ff d0                	callq  *%rax
  801ee0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801ee3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801ee7:	79 08                	jns    801ef1 <duppage+0xd7>
		return r;
  801ee9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801eec:	e9 89 00 00 00       	jmpq   801f7a <duppage+0x160>

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  801ef1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ef8:	01 00 00 
  801efb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801efe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f02:	83 e0 02             	and    $0x2,%eax
  801f05:	48 85 c0             	test   %rax,%rax
  801f08:	75 1b                	jne    801f25 <duppage+0x10b>
  801f0a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f11:	01 00 00 
  801f14:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f17:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f1b:	25 00 08 00 00       	and    $0x800,%eax
  801f20:	48 85 c0             	test   %rax,%rax
  801f23:	74 50                	je     801f75 <duppage+0x15b>
		if ((r = sys_page_map(0, addr, 0, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  801f25:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f2c:	01 00 00 
  801f2f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f32:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f36:	25 05 06 00 00       	and    $0x605,%eax
  801f3b:	80 cc 08             	or     $0x8,%ah
  801f3e:	89 c1                	mov    %eax,%ecx
  801f40:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f48:	41 89 c8             	mov    %ecx,%r8d
  801f4b:	48 89 d1             	mov    %rdx,%rcx
  801f4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f53:	48 89 c6             	mov    %rax,%rsi
  801f56:	bf 00 00 00 00       	mov    $0x0,%edi
  801f5b:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  801f62:	00 00 00 
  801f65:	ff d0                	callq  *%rax
  801f67:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801f6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f6e:	79 05                	jns    801f75 <duppage+0x15b>
			return r;
  801f70:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f73:	eb 05                	jmp    801f7a <duppage+0x160>
	//panic("duppage not implemented");
	return 0;
  801f75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f7a:	c9                   	leaveq 
  801f7b:	c3                   	retq   

0000000000801f7c <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801f7c:	55                   	push   %rbp
  801f7d:	48 89 e5             	mov    %rsp,%rbp
  801f80:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	int r;
	envid_t envid;
	int i, j, k, l, ptx = 0;
  801f84:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	set_pgfault_handler(pgfault);
  801f8b:	48 bf 13 1d 80 00 00 	movabs $0x801d13,%rdi
  801f92:	00 00 00 
  801f95:	48 b8 09 3b 80 00 00 	movabs $0x803b09,%rax
  801f9c:	00 00 00 
  801f9f:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801fa1:	b8 07 00 00 00       	mov    $0x7,%eax
  801fa6:	cd 30                	int    $0x30
  801fa8:	89 45 e0             	mov    %eax,-0x20(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801fab:	8b 45 e0             	mov    -0x20(%rbp),%eax

	if ((envid = sys_exofork()) < 0)
  801fae:	89 45 e8             	mov    %eax,-0x18(%rbp)
  801fb1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801fb5:	79 08                	jns    801fbf <fork+0x43>
		return envid;
  801fb7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801fba:	e9 27 02 00 00       	jmpq   8021e6 <fork+0x26a>
	else if (envid == 0) {
  801fbf:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801fc3:	75 46                	jne    80200b <fork+0x8f>
		thisenv = &envs[ENVX(sys_getenvid())];
  801fc5:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  801fcc:	00 00 00 
  801fcf:	ff d0                	callq  *%rax
  801fd1:	25 ff 03 00 00       	and    $0x3ff,%eax
  801fd6:	48 63 d0             	movslq %eax,%rdx
  801fd9:	48 89 d0             	mov    %rdx,%rax
  801fdc:	48 c1 e0 03          	shl    $0x3,%rax
  801fe0:	48 01 d0             	add    %rdx,%rax
  801fe3:	48 c1 e0 05          	shl    $0x5,%rax
  801fe7:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801fee:	00 00 00 
  801ff1:	48 01 c2             	add    %rax,%rdx
  801ff4:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801ffb:	00 00 00 
  801ffe:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802001:	b8 00 00 00 00       	mov    $0x0,%eax
  802006:	e9 db 01 00 00       	jmpq   8021e6 <fork+0x26a>
	}

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80200b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80200e:	ba 07 00 00 00       	mov    $0x7,%edx
  802013:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802018:	89 c7                	mov    %eax,%edi
  80201a:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  802021:	00 00 00 
  802024:	ff d0                	callq  *%rax
  802026:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802029:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80202d:	79 08                	jns    802037 <fork+0xbb>
		return r;
  80202f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802032:	e9 af 01 00 00       	jmpq   8021e6 <fork+0x26a>

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  802037:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80203e:	e9 49 01 00 00       	jmpq   80218c <fork+0x210>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  802043:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802046:	8d 90 ff ff ff 07    	lea    0x7ffffff(%rax),%edx
  80204c:	85 c0                	test   %eax,%eax
  80204e:	0f 48 c2             	cmovs  %edx,%eax
  802051:	c1 f8 1b             	sar    $0x1b,%eax
  802054:	89 c2                	mov    %eax,%edx
  802056:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80205d:	01 00 00 
  802060:	48 63 d2             	movslq %edx,%rdx
  802063:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802067:	83 e0 01             	and    $0x1,%eax
  80206a:	48 85 c0             	test   %rax,%rax
  80206d:	75 0c                	jne    80207b <fork+0xff>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  80206f:	81 45 ec 00 00 00 08 	addl   $0x8000000,-0x14(%rbp)
			continue;
  802076:	e9 0d 01 00 00       	jmpq   802188 <fork+0x20c>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  80207b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  802082:	e9 f4 00 00 00       	jmpq   80217b <fork+0x1ff>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  802087:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80208a:	8d 90 ff ff 03 00    	lea    0x3ffff(%rax),%edx
  802090:	85 c0                	test   %eax,%eax
  802092:	0f 48 c2             	cmovs  %edx,%eax
  802095:	c1 f8 12             	sar    $0x12,%eax
  802098:	89 c2                	mov    %eax,%edx
  80209a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8020a1:	01 00 00 
  8020a4:	48 63 d2             	movslq %edx,%rdx
  8020a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ab:	83 e0 01             	and    $0x1,%eax
  8020ae:	48 85 c0             	test   %rax,%rax
  8020b1:	75 0c                	jne    8020bf <fork+0x143>
				ptx += NPDENTRIES * NPTENTRIES;
  8020b3:	81 45 ec 00 00 04 00 	addl   $0x40000,-0x14(%rbp)
				continue;
  8020ba:	e9 b8 00 00 00       	jmpq   802177 <fork+0x1fb>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  8020bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8020c6:	e9 9f 00 00 00       	jmpq   80216a <fork+0x1ee>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  8020cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020ce:	8d 90 ff 01 00 00    	lea    0x1ff(%rax),%edx
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	0f 48 c2             	cmovs  %edx,%eax
  8020d9:	c1 f8 09             	sar    $0x9,%eax
  8020dc:	89 c2                	mov    %eax,%edx
  8020de:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020e5:	01 00 00 
  8020e8:	48 63 d2             	movslq %edx,%rdx
  8020eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ef:	83 e0 01             	and    $0x1,%eax
  8020f2:	48 85 c0             	test   %rax,%rax
  8020f5:	75 09                	jne    802100 <fork+0x184>
					ptx += NPTENTRIES;
  8020f7:	81 45 ec 00 02 00 00 	addl   $0x200,-0x14(%rbp)
					continue;
  8020fe:	eb 66                	jmp    802166 <fork+0x1ea>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  802100:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  802107:	eb 54                	jmp    80215d <fork+0x1e1>
					if ((uvpt[ptx] & PTE_P) != 0)
  802109:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802110:	01 00 00 
  802113:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802116:	48 63 d2             	movslq %edx,%rdx
  802119:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80211d:	83 e0 01             	and    $0x1,%eax
  802120:	48 85 c0             	test   %rax,%rax
  802123:	74 30                	je     802155 <fork+0x1d9>
						if (ptx != VPN(UXSTACKTOP - PGSIZE))
  802125:	81 7d ec ff f7 0e 00 	cmpl   $0xef7ff,-0x14(%rbp)
  80212c:	74 27                	je     802155 <fork+0x1d9>
							if ((r = duppage(envid, ptx)) < 0)
  80212e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802131:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802134:	89 d6                	mov    %edx,%esi
  802136:	89 c7                	mov    %eax,%edi
  802138:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  80213f:	00 00 00 
  802142:	ff d0                	callq  *%rax
  802144:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802147:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80214b:	79 08                	jns    802155 <fork+0x1d9>
								return r;
  80214d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802150:	e9 91 00 00 00       	jmpq   8021e6 <fork+0x26a>
					ptx++;
  802155:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  802159:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  80215d:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
  802164:	7e a3                	jle    802109 <fork+0x18d>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  802166:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  80216a:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
  802171:	0f 8e 54 ff ff ff    	jle    8020cb <fork+0x14f>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  802177:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80217b:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
  802182:	0f 8e ff fe ff ff    	jle    802087 <fork+0x10b>
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		return r;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  802188:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80218c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802190:	0f 84 ad fe ff ff    	je     802043 <fork+0xc7>
			}
		}
	}

	extern void _pgfault_upcall();
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  802196:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802199:	48 be 74 3b 80 00 00 	movabs $0x803b74,%rsi
  8021a0:	00 00 00 
  8021a3:	89 c7                	mov    %eax,%edi
  8021a5:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  8021ac:	00 00 00 
  8021af:	ff d0                	callq  *%rax
  8021b1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8021b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8021b8:	79 05                	jns    8021bf <fork+0x243>
		return r;
  8021ba:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8021bd:	eb 27                	jmp    8021e6 <fork+0x26a>
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8021bf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8021c2:	be 02 00 00 00       	mov    $0x2,%esi
  8021c7:	89 c7                	mov    %eax,%edi
  8021c9:	48 b8 9b 1b 80 00 00 	movabs $0x801b9b,%rax
  8021d0:	00 00 00 
  8021d3:	ff d0                	callq  *%rax
  8021d5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8021d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8021dc:	79 05                	jns    8021e3 <fork+0x267>
		return r;
  8021de:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8021e1:	eb 03                	jmp    8021e6 <fork+0x26a>

	return envid;
  8021e3:	8b 45 e8             	mov    -0x18(%rbp),%eax
	//panic("fork not implemented");
}
  8021e6:	c9                   	leaveq 
  8021e7:	c3                   	retq   

00000000008021e8 <sfork>:

// Challenge!
int
sfork(void)
{
  8021e8:	55                   	push   %rbp
  8021e9:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8021ec:	48 ba f1 41 80 00 00 	movabs $0x8041f1,%rdx
  8021f3:	00 00 00 
  8021f6:	be a7 00 00 00       	mov    $0xa7,%esi
  8021fb:	48 bf e6 41 80 00 00 	movabs $0x8041e6,%rdi
  802202:	00 00 00 
  802205:	b8 00 00 00 00       	mov    $0x0,%eax
  80220a:	48 b9 f5 39 80 00 00 	movabs $0x8039f5,%rcx
  802211:	00 00 00 
  802214:	ff d1                	callq  *%rcx

0000000000802216 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802216:	55                   	push   %rbp
  802217:	48 89 e5             	mov    %rsp,%rbp
  80221a:	48 83 ec 30          	sub    $0x30,%rsp
  80221e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802222:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802226:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  80222a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80222e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  802232:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802237:	75 0e                	jne    802247 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  802239:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  802240:	00 00 00 
  802243:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  802247:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80224b:	48 89 c7             	mov    %rax,%rdi
  80224e:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  802255:	00 00 00 
  802258:	ff d0                	callq  *%rax
  80225a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80225d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802261:	79 27                	jns    80228a <ipc_recv+0x74>
		if (from_env_store != NULL)
  802263:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802268:	74 0a                	je     802274 <ipc_recv+0x5e>
			*from_env_store = 0;
  80226a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  802274:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802279:	74 0a                	je     802285 <ipc_recv+0x6f>
			*perm_store = 0;
  80227b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80227f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  802285:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802288:	eb 53                	jmp    8022dd <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  80228a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80228f:	74 19                	je     8022aa <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  802291:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  802298:	00 00 00 
  80229b:	48 8b 00             	mov    (%rax),%rax
  80229e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8022a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a8:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  8022aa:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8022af:	74 19                	je     8022ca <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  8022b1:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8022b8:	00 00 00 
  8022bb:	48 8b 00             	mov    (%rax),%rax
  8022be:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8022c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022c8:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  8022ca:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8022d1:	00 00 00 
  8022d4:	48 8b 00             	mov    (%rax),%rax
  8022d7:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  8022dd:	c9                   	leaveq 
  8022de:	c3                   	retq   

00000000008022df <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022df:	55                   	push   %rbp
  8022e0:	48 89 e5             	mov    %rsp,%rbp
  8022e3:	48 83 ec 30          	sub    $0x30,%rsp
  8022e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022ea:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8022ed:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8022f1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8022f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8022fc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802301:	75 10                	jne    802313 <ipc_send+0x34>
		page = (void *)KERNBASE;
  802303:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  80230a:	00 00 00 
  80230d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  802311:	eb 0e                	jmp    802321 <ipc_send+0x42>
  802313:	eb 0c                	jmp    802321 <ipc_send+0x42>
		sys_yield();
  802315:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  80231c:	00 00 00 
  80231f:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  802321:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802324:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802327:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80232b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80232e:	89 c7                	mov    %eax,%edi
  802330:	48 b8 7a 1c 80 00 00 	movabs $0x801c7a,%rax
  802337:	00 00 00 
  80233a:	ff d0                	callq  *%rax
  80233c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80233f:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  802343:	74 d0                	je     802315 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  802345:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802349:	74 2a                	je     802375 <ipc_send+0x96>
		panic("error on ipc send procedure");
  80234b:	48 ba 07 42 80 00 00 	movabs $0x804207,%rdx
  802352:	00 00 00 
  802355:	be 49 00 00 00       	mov    $0x49,%esi
  80235a:	48 bf 23 42 80 00 00 	movabs $0x804223,%rdi
  802361:	00 00 00 
  802364:	b8 00 00 00 00       	mov    $0x0,%eax
  802369:	48 b9 f5 39 80 00 00 	movabs $0x8039f5,%rcx
  802370:	00 00 00 
  802373:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  802375:	c9                   	leaveq 
  802376:	c3                   	retq   

0000000000802377 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802377:	55                   	push   %rbp
  802378:	48 89 e5             	mov    %rsp,%rbp
  80237b:	48 83 ec 14          	sub    $0x14,%rsp
  80237f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  802382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802389:	eb 5e                	jmp    8023e9 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80238b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802392:	00 00 00 
  802395:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802398:	48 63 d0             	movslq %eax,%rdx
  80239b:	48 89 d0             	mov    %rdx,%rax
  80239e:	48 c1 e0 03          	shl    $0x3,%rax
  8023a2:	48 01 d0             	add    %rdx,%rax
  8023a5:	48 c1 e0 05          	shl    $0x5,%rax
  8023a9:	48 01 c8             	add    %rcx,%rax
  8023ac:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8023b2:	8b 00                	mov    (%rax),%eax
  8023b4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8023b7:	75 2c                	jne    8023e5 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8023b9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8023c0:	00 00 00 
  8023c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c6:	48 63 d0             	movslq %eax,%rdx
  8023c9:	48 89 d0             	mov    %rdx,%rax
  8023cc:	48 c1 e0 03          	shl    $0x3,%rax
  8023d0:	48 01 d0             	add    %rdx,%rax
  8023d3:	48 c1 e0 05          	shl    $0x5,%rax
  8023d7:	48 01 c8             	add    %rcx,%rax
  8023da:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8023e0:	8b 40 08             	mov    0x8(%rax),%eax
  8023e3:	eb 12                	jmp    8023f7 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023e5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023e9:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8023f0:	7e 99                	jle    80238b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8023f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f7:	c9                   	leaveq 
  8023f8:	c3                   	retq   

00000000008023f9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8023f9:	55                   	push   %rbp
  8023fa:	48 89 e5             	mov    %rsp,%rbp
  8023fd:	48 83 ec 08          	sub    $0x8,%rsp
  802401:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802405:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802409:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802410:	ff ff ff 
  802413:	48 01 d0             	add    %rdx,%rax
  802416:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80241a:	c9                   	leaveq 
  80241b:	c3                   	retq   

000000000080241c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80241c:	55                   	push   %rbp
  80241d:	48 89 e5             	mov    %rsp,%rbp
  802420:	48 83 ec 08          	sub    $0x8,%rsp
  802424:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802428:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80242c:	48 89 c7             	mov    %rax,%rdi
  80242f:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  802436:	00 00 00 
  802439:	ff d0                	callq  *%rax
  80243b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802441:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802445:	c9                   	leaveq 
  802446:	c3                   	retq   

0000000000802447 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802447:	55                   	push   %rbp
  802448:	48 89 e5             	mov    %rsp,%rbp
  80244b:	48 83 ec 18          	sub    $0x18,%rsp
  80244f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802453:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80245a:	eb 6b                	jmp    8024c7 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80245c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80245f:	48 98                	cltq   
  802461:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802467:	48 c1 e0 0c          	shl    $0xc,%rax
  80246b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80246f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802473:	48 c1 e8 15          	shr    $0x15,%rax
  802477:	48 89 c2             	mov    %rax,%rdx
  80247a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802481:	01 00 00 
  802484:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802488:	83 e0 01             	and    $0x1,%eax
  80248b:	48 85 c0             	test   %rax,%rax
  80248e:	74 21                	je     8024b1 <fd_alloc+0x6a>
  802490:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802494:	48 c1 e8 0c          	shr    $0xc,%rax
  802498:	48 89 c2             	mov    %rax,%rdx
  80249b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024a2:	01 00 00 
  8024a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024a9:	83 e0 01             	and    $0x1,%eax
  8024ac:	48 85 c0             	test   %rax,%rax
  8024af:	75 12                	jne    8024c3 <fd_alloc+0x7c>
			*fd_store = fd;
  8024b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024b9:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c1:	eb 1a                	jmp    8024dd <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024c3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024c7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8024cb:	7e 8f                	jle    80245c <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8024cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024d1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8024d8:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8024dd:	c9                   	leaveq 
  8024de:	c3                   	retq   

00000000008024df <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8024df:	55                   	push   %rbp
  8024e0:	48 89 e5             	mov    %rsp,%rbp
  8024e3:	48 83 ec 20          	sub    $0x20,%rsp
  8024e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8024ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8024f2:	78 06                	js     8024fa <fd_lookup+0x1b>
  8024f4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8024f8:	7e 07                	jle    802501 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024ff:	eb 6c                	jmp    80256d <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802501:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802504:	48 98                	cltq   
  802506:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80250c:	48 c1 e0 0c          	shl    $0xc,%rax
  802510:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802514:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802518:	48 c1 e8 15          	shr    $0x15,%rax
  80251c:	48 89 c2             	mov    %rax,%rdx
  80251f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802526:	01 00 00 
  802529:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80252d:	83 e0 01             	and    $0x1,%eax
  802530:	48 85 c0             	test   %rax,%rax
  802533:	74 21                	je     802556 <fd_lookup+0x77>
  802535:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802539:	48 c1 e8 0c          	shr    $0xc,%rax
  80253d:	48 89 c2             	mov    %rax,%rdx
  802540:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802547:	01 00 00 
  80254a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80254e:	83 e0 01             	and    $0x1,%eax
  802551:	48 85 c0             	test   %rax,%rax
  802554:	75 07                	jne    80255d <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802556:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80255b:	eb 10                	jmp    80256d <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80255d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802561:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802565:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802568:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80256d:	c9                   	leaveq 
  80256e:	c3                   	retq   

000000000080256f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80256f:	55                   	push   %rbp
  802570:	48 89 e5             	mov    %rsp,%rbp
  802573:	48 83 ec 30          	sub    $0x30,%rsp
  802577:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80257b:	89 f0                	mov    %esi,%eax
  80257d:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802580:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802584:	48 89 c7             	mov    %rax,%rdi
  802587:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  80258e:	00 00 00 
  802591:	ff d0                	callq  *%rax
  802593:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802597:	48 89 d6             	mov    %rdx,%rsi
  80259a:	89 c7                	mov    %eax,%edi
  80259c:	48 b8 df 24 80 00 00 	movabs $0x8024df,%rax
  8025a3:	00 00 00 
  8025a6:	ff d0                	callq  *%rax
  8025a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025af:	78 0a                	js     8025bb <fd_close+0x4c>
	    || fd != fd2)
  8025b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b5:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8025b9:	74 12                	je     8025cd <fd_close+0x5e>
		return (must_exist ? r : 0);
  8025bb:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8025bf:	74 05                	je     8025c6 <fd_close+0x57>
  8025c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025c4:	eb 05                	jmp    8025cb <fd_close+0x5c>
  8025c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cb:	eb 69                	jmp    802636 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8025cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025d1:	8b 00                	mov    (%rax),%eax
  8025d3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025d7:	48 89 d6             	mov    %rdx,%rsi
  8025da:	89 c7                	mov    %eax,%edi
  8025dc:	48 b8 38 26 80 00 00 	movabs $0x802638,%rax
  8025e3:	00 00 00 
  8025e6:	ff d0                	callq  *%rax
  8025e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ef:	78 2a                	js     80261b <fd_close+0xac>
		if (dev->dev_close)
  8025f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f5:	48 8b 40 20          	mov    0x20(%rax),%rax
  8025f9:	48 85 c0             	test   %rax,%rax
  8025fc:	74 16                	je     802614 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8025fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802602:	48 8b 40 20          	mov    0x20(%rax),%rax
  802606:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80260a:	48 89 d7             	mov    %rdx,%rdi
  80260d:	ff d0                	callq  *%rax
  80260f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802612:	eb 07                	jmp    80261b <fd_close+0xac>
		else
			r = 0;
  802614:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80261b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80261f:	48 89 c6             	mov    %rax,%rsi
  802622:	bf 00 00 00 00       	mov    $0x0,%edi
  802627:	48 b8 51 1b 80 00 00 	movabs $0x801b51,%rax
  80262e:	00 00 00 
  802631:	ff d0                	callq  *%rax
	return r;
  802633:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802636:	c9                   	leaveq 
  802637:	c3                   	retq   

0000000000802638 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802638:	55                   	push   %rbp
  802639:	48 89 e5             	mov    %rsp,%rbp
  80263c:	48 83 ec 20          	sub    $0x20,%rsp
  802640:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802643:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802647:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80264e:	eb 41                	jmp    802691 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802650:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802657:	00 00 00 
  80265a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80265d:	48 63 d2             	movslq %edx,%rdx
  802660:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802664:	8b 00                	mov    (%rax),%eax
  802666:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802669:	75 22                	jne    80268d <dev_lookup+0x55>
			*dev = devtab[i];
  80266b:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802672:	00 00 00 
  802675:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802678:	48 63 d2             	movslq %edx,%rdx
  80267b:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80267f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802683:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802686:	b8 00 00 00 00       	mov    $0x0,%eax
  80268b:	eb 60                	jmp    8026ed <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80268d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802691:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802698:	00 00 00 
  80269b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80269e:	48 63 d2             	movslq %edx,%rdx
  8026a1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026a5:	48 85 c0             	test   %rax,%rax
  8026a8:	75 a6                	jne    802650 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8026aa:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8026b1:	00 00 00 
  8026b4:	48 8b 00             	mov    (%rax),%rax
  8026b7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026bd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8026c0:	89 c6                	mov    %eax,%esi
  8026c2:	48 bf 30 42 80 00 00 	movabs $0x804230,%rdi
  8026c9:	00 00 00 
  8026cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d1:	48 b9 cf 03 80 00 00 	movabs $0x8003cf,%rcx
  8026d8:	00 00 00 
  8026db:	ff d1                	callq  *%rcx
	*dev = 0;
  8026dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026e1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8026e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8026ed:	c9                   	leaveq 
  8026ee:	c3                   	retq   

00000000008026ef <close>:

int
close(int fdnum)
{
  8026ef:	55                   	push   %rbp
  8026f0:	48 89 e5             	mov    %rsp,%rbp
  8026f3:	48 83 ec 20          	sub    $0x20,%rsp
  8026f7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026fa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802701:	48 89 d6             	mov    %rdx,%rsi
  802704:	89 c7                	mov    %eax,%edi
  802706:	48 b8 df 24 80 00 00 	movabs $0x8024df,%rax
  80270d:	00 00 00 
  802710:	ff d0                	callq  *%rax
  802712:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802715:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802719:	79 05                	jns    802720 <close+0x31>
		return r;
  80271b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271e:	eb 18                	jmp    802738 <close+0x49>
	else
		return fd_close(fd, 1);
  802720:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802724:	be 01 00 00 00       	mov    $0x1,%esi
  802729:	48 89 c7             	mov    %rax,%rdi
  80272c:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  802733:	00 00 00 
  802736:	ff d0                	callq  *%rax
}
  802738:	c9                   	leaveq 
  802739:	c3                   	retq   

000000000080273a <close_all>:

void
close_all(void)
{
  80273a:	55                   	push   %rbp
  80273b:	48 89 e5             	mov    %rsp,%rbp
  80273e:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802742:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802749:	eb 15                	jmp    802760 <close_all+0x26>
		close(i);
  80274b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80274e:	89 c7                	mov    %eax,%edi
  802750:	48 b8 ef 26 80 00 00 	movabs $0x8026ef,%rax
  802757:	00 00 00 
  80275a:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80275c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802760:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802764:	7e e5                	jle    80274b <close_all+0x11>
		close(i);
}
  802766:	c9                   	leaveq 
  802767:	c3                   	retq   

0000000000802768 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802768:	55                   	push   %rbp
  802769:	48 89 e5             	mov    %rsp,%rbp
  80276c:	48 83 ec 40          	sub    $0x40,%rsp
  802770:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802773:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802776:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80277a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80277d:	48 89 d6             	mov    %rdx,%rsi
  802780:	89 c7                	mov    %eax,%edi
  802782:	48 b8 df 24 80 00 00 	movabs $0x8024df,%rax
  802789:	00 00 00 
  80278c:	ff d0                	callq  *%rax
  80278e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802791:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802795:	79 08                	jns    80279f <dup+0x37>
		return r;
  802797:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80279a:	e9 70 01 00 00       	jmpq   80290f <dup+0x1a7>
	close(newfdnum);
  80279f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027a2:	89 c7                	mov    %eax,%edi
  8027a4:	48 b8 ef 26 80 00 00 	movabs $0x8026ef,%rax
  8027ab:	00 00 00 
  8027ae:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8027b0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027b3:	48 98                	cltq   
  8027b5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027bb:	48 c1 e0 0c          	shl    $0xc,%rax
  8027bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8027c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027c7:	48 89 c7             	mov    %rax,%rdi
  8027ca:	48 b8 1c 24 80 00 00 	movabs $0x80241c,%rax
  8027d1:	00 00 00 
  8027d4:	ff d0                	callq  *%rax
  8027d6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8027da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027de:	48 89 c7             	mov    %rax,%rdi
  8027e1:	48 b8 1c 24 80 00 00 	movabs $0x80241c,%rax
  8027e8:	00 00 00 
  8027eb:	ff d0                	callq  *%rax
  8027ed:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8027f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f5:	48 c1 e8 15          	shr    $0x15,%rax
  8027f9:	48 89 c2             	mov    %rax,%rdx
  8027fc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802803:	01 00 00 
  802806:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80280a:	83 e0 01             	and    $0x1,%eax
  80280d:	48 85 c0             	test   %rax,%rax
  802810:	74 73                	je     802885 <dup+0x11d>
  802812:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802816:	48 c1 e8 0c          	shr    $0xc,%rax
  80281a:	48 89 c2             	mov    %rax,%rdx
  80281d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802824:	01 00 00 
  802827:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80282b:	83 e0 01             	and    $0x1,%eax
  80282e:	48 85 c0             	test   %rax,%rax
  802831:	74 52                	je     802885 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802833:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802837:	48 c1 e8 0c          	shr    $0xc,%rax
  80283b:	48 89 c2             	mov    %rax,%rdx
  80283e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802845:	01 00 00 
  802848:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80284c:	25 07 0e 00 00       	and    $0xe07,%eax
  802851:	89 c1                	mov    %eax,%ecx
  802853:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802857:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80285b:	41 89 c8             	mov    %ecx,%r8d
  80285e:	48 89 d1             	mov    %rdx,%rcx
  802861:	ba 00 00 00 00       	mov    $0x0,%edx
  802866:	48 89 c6             	mov    %rax,%rsi
  802869:	bf 00 00 00 00       	mov    $0x0,%edi
  80286e:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  802875:	00 00 00 
  802878:	ff d0                	callq  *%rax
  80287a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80287d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802881:	79 02                	jns    802885 <dup+0x11d>
			goto err;
  802883:	eb 57                	jmp    8028dc <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802885:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802889:	48 c1 e8 0c          	shr    $0xc,%rax
  80288d:	48 89 c2             	mov    %rax,%rdx
  802890:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802897:	01 00 00 
  80289a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80289e:	25 07 0e 00 00       	and    $0xe07,%eax
  8028a3:	89 c1                	mov    %eax,%ecx
  8028a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028ad:	41 89 c8             	mov    %ecx,%r8d
  8028b0:	48 89 d1             	mov    %rdx,%rcx
  8028b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8028b8:	48 89 c6             	mov    %rax,%rsi
  8028bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8028c0:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  8028c7:	00 00 00 
  8028ca:	ff d0                	callq  *%rax
  8028cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d3:	79 02                	jns    8028d7 <dup+0x16f>
		goto err;
  8028d5:	eb 05                	jmp    8028dc <dup+0x174>

	return newfdnum;
  8028d7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028da:	eb 33                	jmp    80290f <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8028dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028e0:	48 89 c6             	mov    %rax,%rsi
  8028e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8028e8:	48 b8 51 1b 80 00 00 	movabs $0x801b51,%rax
  8028ef:	00 00 00 
  8028f2:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8028f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028f8:	48 89 c6             	mov    %rax,%rsi
  8028fb:	bf 00 00 00 00       	mov    $0x0,%edi
  802900:	48 b8 51 1b 80 00 00 	movabs $0x801b51,%rax
  802907:	00 00 00 
  80290a:	ff d0                	callq  *%rax
	return r;
  80290c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80290f:	c9                   	leaveq 
  802910:	c3                   	retq   

0000000000802911 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802911:	55                   	push   %rbp
  802912:	48 89 e5             	mov    %rsp,%rbp
  802915:	48 83 ec 40          	sub    $0x40,%rsp
  802919:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80291c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802920:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802924:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802928:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80292b:	48 89 d6             	mov    %rdx,%rsi
  80292e:	89 c7                	mov    %eax,%edi
  802930:	48 b8 df 24 80 00 00 	movabs $0x8024df,%rax
  802937:	00 00 00 
  80293a:	ff d0                	callq  *%rax
  80293c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80293f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802943:	78 24                	js     802969 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802945:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802949:	8b 00                	mov    (%rax),%eax
  80294b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80294f:	48 89 d6             	mov    %rdx,%rsi
  802952:	89 c7                	mov    %eax,%edi
  802954:	48 b8 38 26 80 00 00 	movabs $0x802638,%rax
  80295b:	00 00 00 
  80295e:	ff d0                	callq  *%rax
  802960:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802963:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802967:	79 05                	jns    80296e <read+0x5d>
		return r;
  802969:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296c:	eb 76                	jmp    8029e4 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80296e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802972:	8b 40 08             	mov    0x8(%rax),%eax
  802975:	83 e0 03             	and    $0x3,%eax
  802978:	83 f8 01             	cmp    $0x1,%eax
  80297b:	75 3a                	jne    8029b7 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80297d:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  802984:	00 00 00 
  802987:	48 8b 00             	mov    (%rax),%rax
  80298a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802990:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802993:	89 c6                	mov    %eax,%esi
  802995:	48 bf 4f 42 80 00 00 	movabs $0x80424f,%rdi
  80299c:	00 00 00 
  80299f:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a4:	48 b9 cf 03 80 00 00 	movabs $0x8003cf,%rcx
  8029ab:	00 00 00 
  8029ae:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029b5:	eb 2d                	jmp    8029e4 <read+0xd3>
	}
	if (!dev->dev_read)
  8029b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029bb:	48 8b 40 10          	mov    0x10(%rax),%rax
  8029bf:	48 85 c0             	test   %rax,%rax
  8029c2:	75 07                	jne    8029cb <read+0xba>
		return -E_NOT_SUPP;
  8029c4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029c9:	eb 19                	jmp    8029e4 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8029cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029cf:	48 8b 40 10          	mov    0x10(%rax),%rax
  8029d3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8029d7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029db:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8029df:	48 89 cf             	mov    %rcx,%rdi
  8029e2:	ff d0                	callq  *%rax
}
  8029e4:	c9                   	leaveq 
  8029e5:	c3                   	retq   

00000000008029e6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8029e6:	55                   	push   %rbp
  8029e7:	48 89 e5             	mov    %rsp,%rbp
  8029ea:	48 83 ec 30          	sub    $0x30,%rsp
  8029ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8029f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a00:	eb 49                	jmp    802a4b <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a05:	48 98                	cltq   
  802a07:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a0b:	48 29 c2             	sub    %rax,%rdx
  802a0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a11:	48 63 c8             	movslq %eax,%rcx
  802a14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a18:	48 01 c1             	add    %rax,%rcx
  802a1b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a1e:	48 89 ce             	mov    %rcx,%rsi
  802a21:	89 c7                	mov    %eax,%edi
  802a23:	48 b8 11 29 80 00 00 	movabs $0x802911,%rax
  802a2a:	00 00 00 
  802a2d:	ff d0                	callq  *%rax
  802a2f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802a32:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a36:	79 05                	jns    802a3d <readn+0x57>
			return m;
  802a38:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a3b:	eb 1c                	jmp    802a59 <readn+0x73>
		if (m == 0)
  802a3d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a41:	75 02                	jne    802a45 <readn+0x5f>
			break;
  802a43:	eb 11                	jmp    802a56 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a45:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a48:	01 45 fc             	add    %eax,-0x4(%rbp)
  802a4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4e:	48 98                	cltq   
  802a50:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a54:	72 ac                	jb     802a02 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802a56:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a59:	c9                   	leaveq 
  802a5a:	c3                   	retq   

0000000000802a5b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802a5b:	55                   	push   %rbp
  802a5c:	48 89 e5             	mov    %rsp,%rbp
  802a5f:	48 83 ec 40          	sub    $0x40,%rsp
  802a63:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a66:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a6a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a6e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a72:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a75:	48 89 d6             	mov    %rdx,%rsi
  802a78:	89 c7                	mov    %eax,%edi
  802a7a:	48 b8 df 24 80 00 00 	movabs $0x8024df,%rax
  802a81:	00 00 00 
  802a84:	ff d0                	callq  *%rax
  802a86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a8d:	78 24                	js     802ab3 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a93:	8b 00                	mov    (%rax),%eax
  802a95:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a99:	48 89 d6             	mov    %rdx,%rsi
  802a9c:	89 c7                	mov    %eax,%edi
  802a9e:	48 b8 38 26 80 00 00 	movabs $0x802638,%rax
  802aa5:	00 00 00 
  802aa8:	ff d0                	callq  *%rax
  802aaa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab1:	79 05                	jns    802ab8 <write+0x5d>
		return r;
  802ab3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab6:	eb 75                	jmp    802b2d <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ab8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802abc:	8b 40 08             	mov    0x8(%rax),%eax
  802abf:	83 e0 03             	and    $0x3,%eax
  802ac2:	85 c0                	test   %eax,%eax
  802ac4:	75 3a                	jne    802b00 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802ac6:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  802acd:	00 00 00 
  802ad0:	48 8b 00             	mov    (%rax),%rax
  802ad3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ad9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802adc:	89 c6                	mov    %eax,%esi
  802ade:	48 bf 6b 42 80 00 00 	movabs $0x80426b,%rdi
  802ae5:	00 00 00 
  802ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  802aed:	48 b9 cf 03 80 00 00 	movabs $0x8003cf,%rcx
  802af4:	00 00 00 
  802af7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802af9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802afe:	eb 2d                	jmp    802b2d <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b04:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b08:	48 85 c0             	test   %rax,%rax
  802b0b:	75 07                	jne    802b14 <write+0xb9>
		return -E_NOT_SUPP;
  802b0d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b12:	eb 19                	jmp    802b2d <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b18:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b1c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b20:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b24:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b28:	48 89 cf             	mov    %rcx,%rdi
  802b2b:	ff d0                	callq  *%rax
}
  802b2d:	c9                   	leaveq 
  802b2e:	c3                   	retq   

0000000000802b2f <seek>:

int
seek(int fdnum, off_t offset)
{
  802b2f:	55                   	push   %rbp
  802b30:	48 89 e5             	mov    %rsp,%rbp
  802b33:	48 83 ec 18          	sub    $0x18,%rsp
  802b37:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b3a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b3d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b41:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b44:	48 89 d6             	mov    %rdx,%rsi
  802b47:	89 c7                	mov    %eax,%edi
  802b49:	48 b8 df 24 80 00 00 	movabs $0x8024df,%rax
  802b50:	00 00 00 
  802b53:	ff d0                	callq  *%rax
  802b55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5c:	79 05                	jns    802b63 <seek+0x34>
		return r;
  802b5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b61:	eb 0f                	jmp    802b72 <seek+0x43>
	fd->fd_offset = offset;
  802b63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b67:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b6a:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802b6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b72:	c9                   	leaveq 
  802b73:	c3                   	retq   

0000000000802b74 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802b74:	55                   	push   %rbp
  802b75:	48 89 e5             	mov    %rsp,%rbp
  802b78:	48 83 ec 30          	sub    $0x30,%rsp
  802b7c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b7f:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b82:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b86:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b89:	48 89 d6             	mov    %rdx,%rsi
  802b8c:	89 c7                	mov    %eax,%edi
  802b8e:	48 b8 df 24 80 00 00 	movabs $0x8024df,%rax
  802b95:	00 00 00 
  802b98:	ff d0                	callq  *%rax
  802b9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba1:	78 24                	js     802bc7 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ba3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba7:	8b 00                	mov    (%rax),%eax
  802ba9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bad:	48 89 d6             	mov    %rdx,%rsi
  802bb0:	89 c7                	mov    %eax,%edi
  802bb2:	48 b8 38 26 80 00 00 	movabs $0x802638,%rax
  802bb9:	00 00 00 
  802bbc:	ff d0                	callq  *%rax
  802bbe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc5:	79 05                	jns    802bcc <ftruncate+0x58>
		return r;
  802bc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bca:	eb 72                	jmp    802c3e <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802bcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd0:	8b 40 08             	mov    0x8(%rax),%eax
  802bd3:	83 e0 03             	and    $0x3,%eax
  802bd6:	85 c0                	test   %eax,%eax
  802bd8:	75 3a                	jne    802c14 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802bda:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  802be1:	00 00 00 
  802be4:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802be7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bed:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bf0:	89 c6                	mov    %eax,%esi
  802bf2:	48 bf 88 42 80 00 00 	movabs $0x804288,%rdi
  802bf9:	00 00 00 
  802bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  802c01:	48 b9 cf 03 80 00 00 	movabs $0x8003cf,%rcx
  802c08:	00 00 00 
  802c0b:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c12:	eb 2a                	jmp    802c3e <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c18:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c1c:	48 85 c0             	test   %rax,%rax
  802c1f:	75 07                	jne    802c28 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c21:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c26:	eb 16                	jmp    802c3e <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c2c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c30:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c34:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802c37:	89 ce                	mov    %ecx,%esi
  802c39:	48 89 d7             	mov    %rdx,%rdi
  802c3c:	ff d0                	callq  *%rax
}
  802c3e:	c9                   	leaveq 
  802c3f:	c3                   	retq   

0000000000802c40 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c40:	55                   	push   %rbp
  802c41:	48 89 e5             	mov    %rsp,%rbp
  802c44:	48 83 ec 30          	sub    $0x30,%rsp
  802c48:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c4b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c4f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c53:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c56:	48 89 d6             	mov    %rdx,%rsi
  802c59:	89 c7                	mov    %eax,%edi
  802c5b:	48 b8 df 24 80 00 00 	movabs $0x8024df,%rax
  802c62:	00 00 00 
  802c65:	ff d0                	callq  *%rax
  802c67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c6e:	78 24                	js     802c94 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c74:	8b 00                	mov    (%rax),%eax
  802c76:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c7a:	48 89 d6             	mov    %rdx,%rsi
  802c7d:	89 c7                	mov    %eax,%edi
  802c7f:	48 b8 38 26 80 00 00 	movabs $0x802638,%rax
  802c86:	00 00 00 
  802c89:	ff d0                	callq  *%rax
  802c8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c92:	79 05                	jns    802c99 <fstat+0x59>
		return r;
  802c94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c97:	eb 5e                	jmp    802cf7 <fstat+0xb7>
	if (!dev->dev_stat)
  802c99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c9d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ca1:	48 85 c0             	test   %rax,%rax
  802ca4:	75 07                	jne    802cad <fstat+0x6d>
		return -E_NOT_SUPP;
  802ca6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cab:	eb 4a                	jmp    802cf7 <fstat+0xb7>
	stat->st_name[0] = 0;
  802cad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cb1:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802cb4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cb8:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802cbf:	00 00 00 
	stat->st_isdir = 0;
  802cc2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cc6:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802ccd:	00 00 00 
	stat->st_dev = dev;
  802cd0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cd4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cd8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802cdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce3:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ce7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ceb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802cef:	48 89 ce             	mov    %rcx,%rsi
  802cf2:	48 89 d7             	mov    %rdx,%rdi
  802cf5:	ff d0                	callq  *%rax
}
  802cf7:	c9                   	leaveq 
  802cf8:	c3                   	retq   

0000000000802cf9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802cf9:	55                   	push   %rbp
  802cfa:	48 89 e5             	mov    %rsp,%rbp
  802cfd:	48 83 ec 20          	sub    $0x20,%rsp
  802d01:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d05:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d0d:	be 00 00 00 00       	mov    $0x0,%esi
  802d12:	48 89 c7             	mov    %rax,%rdi
  802d15:	48 b8 e7 2d 80 00 00 	movabs $0x802de7,%rax
  802d1c:	00 00 00 
  802d1f:	ff d0                	callq  *%rax
  802d21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d28:	79 05                	jns    802d2f <stat+0x36>
		return fd;
  802d2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2d:	eb 2f                	jmp    802d5e <stat+0x65>
	r = fstat(fd, stat);
  802d2f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d36:	48 89 d6             	mov    %rdx,%rsi
  802d39:	89 c7                	mov    %eax,%edi
  802d3b:	48 b8 40 2c 80 00 00 	movabs $0x802c40,%rax
  802d42:	00 00 00 
  802d45:	ff d0                	callq  *%rax
  802d47:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802d4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4d:	89 c7                	mov    %eax,%edi
  802d4f:	48 b8 ef 26 80 00 00 	movabs $0x8026ef,%rax
  802d56:	00 00 00 
  802d59:	ff d0                	callq  *%rax
	return r;
  802d5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802d5e:	c9                   	leaveq 
  802d5f:	c3                   	retq   

0000000000802d60 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802d60:	55                   	push   %rbp
  802d61:	48 89 e5             	mov    %rsp,%rbp
  802d64:	48 83 ec 10          	sub    $0x10,%rsp
  802d68:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d6b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802d6f:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802d76:	00 00 00 
  802d79:	8b 00                	mov    (%rax),%eax
  802d7b:	85 c0                	test   %eax,%eax
  802d7d:	75 1d                	jne    802d9c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802d7f:	bf 01 00 00 00       	mov    $0x1,%edi
  802d84:	48 b8 77 23 80 00 00 	movabs $0x802377,%rax
  802d8b:	00 00 00 
  802d8e:	ff d0                	callq  *%rax
  802d90:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  802d97:	00 00 00 
  802d9a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802d9c:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802da3:	00 00 00 
  802da6:	8b 00                	mov    (%rax),%eax
  802da8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802dab:	b9 07 00 00 00       	mov    $0x7,%ecx
  802db0:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802db7:	00 00 00 
  802dba:	89 c7                	mov    %eax,%edi
  802dbc:	48 b8 df 22 80 00 00 	movabs $0x8022df,%rax
  802dc3:	00 00 00 
  802dc6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802dc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dcc:	ba 00 00 00 00       	mov    $0x0,%edx
  802dd1:	48 89 c6             	mov    %rax,%rsi
  802dd4:	bf 00 00 00 00       	mov    $0x0,%edi
  802dd9:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  802de0:	00 00 00 
  802de3:	ff d0                	callq  *%rax
}
  802de5:	c9                   	leaveq 
  802de6:	c3                   	retq   

0000000000802de7 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802de7:	55                   	push   %rbp
  802de8:	48 89 e5             	mov    %rsp,%rbp
  802deb:	48 83 ec 20          	sub    $0x20,%rsp
  802def:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802df3:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802df6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dfa:	48 89 c7             	mov    %rax,%rdi
  802dfd:	48 b8 0b 11 80 00 00 	movabs $0x80110b,%rax
  802e04:	00 00 00 
  802e07:	ff d0                	callq  *%rax
  802e09:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e0e:	7e 0a                	jle    802e1a <open+0x33>
		return -E_BAD_PATH;
  802e10:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e15:	e9 a5 00 00 00       	jmpq   802ebf <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802e1a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e1e:	48 89 c7             	mov    %rax,%rdi
  802e21:	48 b8 47 24 80 00 00 	movabs $0x802447,%rax
  802e28:	00 00 00 
  802e2b:	ff d0                	callq  *%rax
  802e2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e34:	79 08                	jns    802e3e <open+0x57>
		return r;
  802e36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e39:	e9 81 00 00 00       	jmpq   802ebf <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802e3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e42:	48 89 c6             	mov    %rax,%rsi
  802e45:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802e4c:	00 00 00 
  802e4f:	48 b8 77 11 80 00 00 	movabs $0x801177,%rax
  802e56:	00 00 00 
  802e59:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802e5b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e62:	00 00 00 
  802e65:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802e68:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e72:	48 89 c6             	mov    %rax,%rsi
  802e75:	bf 01 00 00 00       	mov    $0x1,%edi
  802e7a:	48 b8 60 2d 80 00 00 	movabs $0x802d60,%rax
  802e81:	00 00 00 
  802e84:	ff d0                	callq  *%rax
  802e86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e8d:	79 1d                	jns    802eac <open+0xc5>
		fd_close(fd, 0);
  802e8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e93:	be 00 00 00 00       	mov    $0x0,%esi
  802e98:	48 89 c7             	mov    %rax,%rdi
  802e9b:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  802ea2:	00 00 00 
  802ea5:	ff d0                	callq  *%rax
		return r;
  802ea7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eaa:	eb 13                	jmp    802ebf <open+0xd8>
	}

	return fd2num(fd);
  802eac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb0:	48 89 c7             	mov    %rax,%rdi
  802eb3:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  802eba:	00 00 00 
  802ebd:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802ebf:	c9                   	leaveq 
  802ec0:	c3                   	retq   

0000000000802ec1 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802ec1:	55                   	push   %rbp
  802ec2:	48 89 e5             	mov    %rsp,%rbp
  802ec5:	48 83 ec 10          	sub    $0x10,%rsp
  802ec9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802ecd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ed1:	8b 50 0c             	mov    0xc(%rax),%edx
  802ed4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802edb:	00 00 00 
  802ede:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802ee0:	be 00 00 00 00       	mov    $0x0,%esi
  802ee5:	bf 06 00 00 00       	mov    $0x6,%edi
  802eea:	48 b8 60 2d 80 00 00 	movabs $0x802d60,%rax
  802ef1:	00 00 00 
  802ef4:	ff d0                	callq  *%rax
}
  802ef6:	c9                   	leaveq 
  802ef7:	c3                   	retq   

0000000000802ef8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802ef8:	55                   	push   %rbp
  802ef9:	48 89 e5             	mov    %rsp,%rbp
  802efc:	48 83 ec 30          	sub    $0x30,%rsp
  802f00:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f04:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f08:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802f0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f10:	8b 50 0c             	mov    0xc(%rax),%edx
  802f13:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f1a:	00 00 00 
  802f1d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802f1f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f26:	00 00 00 
  802f29:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f2d:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802f31:	be 00 00 00 00       	mov    $0x0,%esi
  802f36:	bf 03 00 00 00       	mov    $0x3,%edi
  802f3b:	48 b8 60 2d 80 00 00 	movabs $0x802d60,%rax
  802f42:	00 00 00 
  802f45:	ff d0                	callq  *%rax
  802f47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f4e:	79 05                	jns    802f55 <devfile_read+0x5d>
		return r;
  802f50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f53:	eb 26                	jmp    802f7b <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802f55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f58:	48 63 d0             	movslq %eax,%rdx
  802f5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f5f:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802f66:	00 00 00 
  802f69:	48 89 c7             	mov    %rax,%rdi
  802f6c:	48 b8 9b 14 80 00 00 	movabs $0x80149b,%rax
  802f73:	00 00 00 
  802f76:	ff d0                	callq  *%rax

	return r;
  802f78:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802f7b:	c9                   	leaveq 
  802f7c:	c3                   	retq   

0000000000802f7d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802f7d:	55                   	push   %rbp
  802f7e:	48 89 e5             	mov    %rsp,%rbp
  802f81:	48 83 ec 30          	sub    $0x30,%rsp
  802f85:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f89:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f8d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802f91:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802f98:	00 
  802f99:	76 08                	jbe    802fa3 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802f9b:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802fa2:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802fa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa7:	8b 50 0c             	mov    0xc(%rax),%edx
  802faa:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802fb1:	00 00 00 
  802fb4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802fb6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802fbd:	00 00 00 
  802fc0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fc4:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  802fc8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fcc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fd0:	48 89 c6             	mov    %rax,%rsi
  802fd3:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802fda:	00 00 00 
  802fdd:	48 b8 9b 14 80 00 00 	movabs $0x80149b,%rax
  802fe4:	00 00 00 
  802fe7:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802fe9:	be 00 00 00 00       	mov    $0x0,%esi
  802fee:	bf 04 00 00 00       	mov    $0x4,%edi
  802ff3:	48 b8 60 2d 80 00 00 	movabs $0x802d60,%rax
  802ffa:	00 00 00 
  802ffd:	ff d0                	callq  *%rax
  802fff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803002:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803006:	79 05                	jns    80300d <devfile_write+0x90>
		return r;
  803008:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300b:	eb 03                	jmp    803010 <devfile_write+0x93>

	return r;
  80300d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803010:	c9                   	leaveq 
  803011:	c3                   	retq   

0000000000803012 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803012:	55                   	push   %rbp
  803013:	48 89 e5             	mov    %rsp,%rbp
  803016:	48 83 ec 20          	sub    $0x20,%rsp
  80301a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80301e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803022:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803026:	8b 50 0c             	mov    0xc(%rax),%edx
  803029:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803030:	00 00 00 
  803033:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803035:	be 00 00 00 00       	mov    $0x0,%esi
  80303a:	bf 05 00 00 00       	mov    $0x5,%edi
  80303f:	48 b8 60 2d 80 00 00 	movabs $0x802d60,%rax
  803046:	00 00 00 
  803049:	ff d0                	callq  *%rax
  80304b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80304e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803052:	79 05                	jns    803059 <devfile_stat+0x47>
		return r;
  803054:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803057:	eb 56                	jmp    8030af <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803059:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80305d:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  803064:	00 00 00 
  803067:	48 89 c7             	mov    %rax,%rdi
  80306a:	48 b8 77 11 80 00 00 	movabs $0x801177,%rax
  803071:	00 00 00 
  803074:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803076:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80307d:	00 00 00 
  803080:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803086:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80308a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803090:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803097:	00 00 00 
  80309a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8030a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030a4:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8030aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030af:	c9                   	leaveq 
  8030b0:	c3                   	retq   

00000000008030b1 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8030b1:	55                   	push   %rbp
  8030b2:	48 89 e5             	mov    %rsp,%rbp
  8030b5:	48 83 ec 10          	sub    $0x10,%rsp
  8030b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030bd:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8030c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030c4:	8b 50 0c             	mov    0xc(%rax),%edx
  8030c7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8030ce:	00 00 00 
  8030d1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8030d3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8030da:	00 00 00 
  8030dd:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8030e0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8030e3:	be 00 00 00 00       	mov    $0x0,%esi
  8030e8:	bf 02 00 00 00       	mov    $0x2,%edi
  8030ed:	48 b8 60 2d 80 00 00 	movabs $0x802d60,%rax
  8030f4:	00 00 00 
  8030f7:	ff d0                	callq  *%rax
}
  8030f9:	c9                   	leaveq 
  8030fa:	c3                   	retq   

00000000008030fb <remove>:

// Delete a file
int
remove(const char *path)
{
  8030fb:	55                   	push   %rbp
  8030fc:	48 89 e5             	mov    %rsp,%rbp
  8030ff:	48 83 ec 10          	sub    $0x10,%rsp
  803103:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803107:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80310b:	48 89 c7             	mov    %rax,%rdi
  80310e:	48 b8 0b 11 80 00 00 	movabs $0x80110b,%rax
  803115:	00 00 00 
  803118:	ff d0                	callq  *%rax
  80311a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80311f:	7e 07                	jle    803128 <remove+0x2d>
		return -E_BAD_PATH;
  803121:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803126:	eb 33                	jmp    80315b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803128:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80312c:	48 89 c6             	mov    %rax,%rsi
  80312f:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  803136:	00 00 00 
  803139:	48 b8 77 11 80 00 00 	movabs $0x801177,%rax
  803140:	00 00 00 
  803143:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803145:	be 00 00 00 00       	mov    $0x0,%esi
  80314a:	bf 07 00 00 00       	mov    $0x7,%edi
  80314f:	48 b8 60 2d 80 00 00 	movabs $0x802d60,%rax
  803156:	00 00 00 
  803159:	ff d0                	callq  *%rax
}
  80315b:	c9                   	leaveq 
  80315c:	c3                   	retq   

000000000080315d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80315d:	55                   	push   %rbp
  80315e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803161:	be 00 00 00 00       	mov    $0x0,%esi
  803166:	bf 08 00 00 00       	mov    $0x8,%edi
  80316b:	48 b8 60 2d 80 00 00 	movabs $0x802d60,%rax
  803172:	00 00 00 
  803175:	ff d0                	callq  *%rax
}
  803177:	5d                   	pop    %rbp
  803178:	c3                   	retq   

0000000000803179 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803179:	55                   	push   %rbp
  80317a:	48 89 e5             	mov    %rsp,%rbp
  80317d:	53                   	push   %rbx
  80317e:	48 83 ec 38          	sub    $0x38,%rsp
  803182:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803186:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80318a:	48 89 c7             	mov    %rax,%rdi
  80318d:	48 b8 47 24 80 00 00 	movabs $0x802447,%rax
  803194:	00 00 00 
  803197:	ff d0                	callq  *%rax
  803199:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80319c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031a0:	0f 88 bf 01 00 00    	js     803365 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031aa:	ba 07 04 00 00       	mov    $0x407,%edx
  8031af:	48 89 c6             	mov    %rax,%rsi
  8031b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8031b7:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  8031be:	00 00 00 
  8031c1:	ff d0                	callq  *%rax
  8031c3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031ca:	0f 88 95 01 00 00    	js     803365 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8031d0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8031d4:	48 89 c7             	mov    %rax,%rdi
  8031d7:	48 b8 47 24 80 00 00 	movabs $0x802447,%rax
  8031de:	00 00 00 
  8031e1:	ff d0                	callq  *%rax
  8031e3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031ea:	0f 88 5d 01 00 00    	js     80334d <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031f4:	ba 07 04 00 00       	mov    $0x407,%edx
  8031f9:	48 89 c6             	mov    %rax,%rsi
  8031fc:	bf 00 00 00 00       	mov    $0x0,%edi
  803201:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  803208:	00 00 00 
  80320b:	ff d0                	callq  *%rax
  80320d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803210:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803214:	0f 88 33 01 00 00    	js     80334d <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80321a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80321e:	48 89 c7             	mov    %rax,%rdi
  803221:	48 b8 1c 24 80 00 00 	movabs $0x80241c,%rax
  803228:	00 00 00 
  80322b:	ff d0                	callq  *%rax
  80322d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803231:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803235:	ba 07 04 00 00       	mov    $0x407,%edx
  80323a:	48 89 c6             	mov    %rax,%rsi
  80323d:	bf 00 00 00 00       	mov    $0x0,%edi
  803242:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  803249:	00 00 00 
  80324c:	ff d0                	callq  *%rax
  80324e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803251:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803255:	79 05                	jns    80325c <pipe+0xe3>
		goto err2;
  803257:	e9 d9 00 00 00       	jmpq   803335 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80325c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803260:	48 89 c7             	mov    %rax,%rdi
  803263:	48 b8 1c 24 80 00 00 	movabs $0x80241c,%rax
  80326a:	00 00 00 
  80326d:	ff d0                	callq  *%rax
  80326f:	48 89 c2             	mov    %rax,%rdx
  803272:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803276:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80327c:	48 89 d1             	mov    %rdx,%rcx
  80327f:	ba 00 00 00 00       	mov    $0x0,%edx
  803284:	48 89 c6             	mov    %rax,%rsi
  803287:	bf 00 00 00 00       	mov    $0x0,%edi
  80328c:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  803293:	00 00 00 
  803296:	ff d0                	callq  *%rax
  803298:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80329b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80329f:	79 1b                	jns    8032bc <pipe+0x143>
		goto err3;
  8032a1:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8032a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032a6:	48 89 c6             	mov    %rax,%rsi
  8032a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ae:	48 b8 51 1b 80 00 00 	movabs $0x801b51,%rax
  8032b5:	00 00 00 
  8032b8:	ff d0                	callq  *%rax
  8032ba:	eb 79                	jmp    803335 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8032bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032c0:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8032c7:	00 00 00 
  8032ca:	8b 12                	mov    (%rdx),%edx
  8032cc:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8032ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8032d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032dd:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8032e4:	00 00 00 
  8032e7:	8b 12                	mov    (%rdx),%edx
  8032e9:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8032eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032ef:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8032f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032fa:	48 89 c7             	mov    %rax,%rdi
  8032fd:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  803304:	00 00 00 
  803307:	ff d0                	callq  *%rax
  803309:	89 c2                	mov    %eax,%edx
  80330b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80330f:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803311:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803315:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803319:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80331d:	48 89 c7             	mov    %rax,%rdi
  803320:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  803327:	00 00 00 
  80332a:	ff d0                	callq  *%rax
  80332c:	89 03                	mov    %eax,(%rbx)
	return 0;
  80332e:	b8 00 00 00 00       	mov    $0x0,%eax
  803333:	eb 33                	jmp    803368 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803335:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803339:	48 89 c6             	mov    %rax,%rsi
  80333c:	bf 00 00 00 00       	mov    $0x0,%edi
  803341:	48 b8 51 1b 80 00 00 	movabs $0x801b51,%rax
  803348:	00 00 00 
  80334b:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  80334d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803351:	48 89 c6             	mov    %rax,%rsi
  803354:	bf 00 00 00 00       	mov    $0x0,%edi
  803359:	48 b8 51 1b 80 00 00 	movabs $0x801b51,%rax
  803360:	00 00 00 
  803363:	ff d0                	callq  *%rax
    err:
	return r;
  803365:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803368:	48 83 c4 38          	add    $0x38,%rsp
  80336c:	5b                   	pop    %rbx
  80336d:	5d                   	pop    %rbp
  80336e:	c3                   	retq   

000000000080336f <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80336f:	55                   	push   %rbp
  803370:	48 89 e5             	mov    %rsp,%rbp
  803373:	53                   	push   %rbx
  803374:	48 83 ec 28          	sub    $0x28,%rsp
  803378:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80337c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803380:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  803387:	00 00 00 
  80338a:	48 8b 00             	mov    (%rax),%rax
  80338d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803393:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803396:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80339a:	48 89 c7             	mov    %rax,%rdi
  80339d:	48 b8 fe 3b 80 00 00 	movabs $0x803bfe,%rax
  8033a4:	00 00 00 
  8033a7:	ff d0                	callq  *%rax
  8033a9:	89 c3                	mov    %eax,%ebx
  8033ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033af:	48 89 c7             	mov    %rax,%rdi
  8033b2:	48 b8 fe 3b 80 00 00 	movabs $0x803bfe,%rax
  8033b9:	00 00 00 
  8033bc:	ff d0                	callq  *%rax
  8033be:	39 c3                	cmp    %eax,%ebx
  8033c0:	0f 94 c0             	sete   %al
  8033c3:	0f b6 c0             	movzbl %al,%eax
  8033c6:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8033c9:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8033d0:	00 00 00 
  8033d3:	48 8b 00             	mov    (%rax),%rax
  8033d6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8033dc:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8033df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033e2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8033e5:	75 05                	jne    8033ec <_pipeisclosed+0x7d>
			return ret;
  8033e7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8033ea:	eb 4f                	jmp    80343b <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8033ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033ef:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8033f2:	74 42                	je     803436 <_pipeisclosed+0xc7>
  8033f4:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8033f8:	75 3c                	jne    803436 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8033fa:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  803401:	00 00 00 
  803404:	48 8b 00             	mov    (%rax),%rax
  803407:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80340d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803410:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803413:	89 c6                	mov    %eax,%esi
  803415:	48 bf b3 42 80 00 00 	movabs $0x8042b3,%rdi
  80341c:	00 00 00 
  80341f:	b8 00 00 00 00       	mov    $0x0,%eax
  803424:	49 b8 cf 03 80 00 00 	movabs $0x8003cf,%r8
  80342b:	00 00 00 
  80342e:	41 ff d0             	callq  *%r8
	}
  803431:	e9 4a ff ff ff       	jmpq   803380 <_pipeisclosed+0x11>
  803436:	e9 45 ff ff ff       	jmpq   803380 <_pipeisclosed+0x11>
}
  80343b:	48 83 c4 28          	add    $0x28,%rsp
  80343f:	5b                   	pop    %rbx
  803440:	5d                   	pop    %rbp
  803441:	c3                   	retq   

0000000000803442 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803442:	55                   	push   %rbp
  803443:	48 89 e5             	mov    %rsp,%rbp
  803446:	48 83 ec 30          	sub    $0x30,%rsp
  80344a:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80344d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803451:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803454:	48 89 d6             	mov    %rdx,%rsi
  803457:	89 c7                	mov    %eax,%edi
  803459:	48 b8 df 24 80 00 00 	movabs $0x8024df,%rax
  803460:	00 00 00 
  803463:	ff d0                	callq  *%rax
  803465:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803468:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80346c:	79 05                	jns    803473 <pipeisclosed+0x31>
		return r;
  80346e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803471:	eb 31                	jmp    8034a4 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803473:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803477:	48 89 c7             	mov    %rax,%rdi
  80347a:	48 b8 1c 24 80 00 00 	movabs $0x80241c,%rax
  803481:	00 00 00 
  803484:	ff d0                	callq  *%rax
  803486:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80348a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80348e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803492:	48 89 d6             	mov    %rdx,%rsi
  803495:	48 89 c7             	mov    %rax,%rdi
  803498:	48 b8 6f 33 80 00 00 	movabs $0x80336f,%rax
  80349f:	00 00 00 
  8034a2:	ff d0                	callq  *%rax
}
  8034a4:	c9                   	leaveq 
  8034a5:	c3                   	retq   

00000000008034a6 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8034a6:	55                   	push   %rbp
  8034a7:	48 89 e5             	mov    %rsp,%rbp
  8034aa:	48 83 ec 40          	sub    $0x40,%rsp
  8034ae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034b2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8034b6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8034ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034be:	48 89 c7             	mov    %rax,%rdi
  8034c1:	48 b8 1c 24 80 00 00 	movabs $0x80241c,%rax
  8034c8:	00 00 00 
  8034cb:	ff d0                	callq  *%rax
  8034cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8034d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034d5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8034d9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8034e0:	00 
  8034e1:	e9 92 00 00 00       	jmpq   803578 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8034e6:	eb 41                	jmp    803529 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8034e8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8034ed:	74 09                	je     8034f8 <devpipe_read+0x52>
				return i;
  8034ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f3:	e9 92 00 00 00       	jmpq   80358a <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8034f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803500:	48 89 d6             	mov    %rdx,%rsi
  803503:	48 89 c7             	mov    %rax,%rdi
  803506:	48 b8 6f 33 80 00 00 	movabs $0x80336f,%rax
  80350d:	00 00 00 
  803510:	ff d0                	callq  *%rax
  803512:	85 c0                	test   %eax,%eax
  803514:	74 07                	je     80351d <devpipe_read+0x77>
				return 0;
  803516:	b8 00 00 00 00       	mov    $0x0,%eax
  80351b:	eb 6d                	jmp    80358a <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80351d:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  803524:	00 00 00 
  803527:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803529:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80352d:	8b 10                	mov    (%rax),%edx
  80352f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803533:	8b 40 04             	mov    0x4(%rax),%eax
  803536:	39 c2                	cmp    %eax,%edx
  803538:	74 ae                	je     8034e8 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80353a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80353e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803542:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803546:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80354a:	8b 00                	mov    (%rax),%eax
  80354c:	99                   	cltd   
  80354d:	c1 ea 1b             	shr    $0x1b,%edx
  803550:	01 d0                	add    %edx,%eax
  803552:	83 e0 1f             	and    $0x1f,%eax
  803555:	29 d0                	sub    %edx,%eax
  803557:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80355b:	48 98                	cltq   
  80355d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803562:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803564:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803568:	8b 00                	mov    (%rax),%eax
  80356a:	8d 50 01             	lea    0x1(%rax),%edx
  80356d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803571:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803573:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803578:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80357c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803580:	0f 82 60 ff ff ff    	jb     8034e6 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803586:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80358a:	c9                   	leaveq 
  80358b:	c3                   	retq   

000000000080358c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80358c:	55                   	push   %rbp
  80358d:	48 89 e5             	mov    %rsp,%rbp
  803590:	48 83 ec 40          	sub    $0x40,%rsp
  803594:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803598:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80359c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8035a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035a4:	48 89 c7             	mov    %rax,%rdi
  8035a7:	48 b8 1c 24 80 00 00 	movabs $0x80241c,%rax
  8035ae:	00 00 00 
  8035b1:	ff d0                	callq  *%rax
  8035b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035bb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035bf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035c6:	00 
  8035c7:	e9 8e 00 00 00       	jmpq   80365a <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8035cc:	eb 31                	jmp    8035ff <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8035ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035d6:	48 89 d6             	mov    %rdx,%rsi
  8035d9:	48 89 c7             	mov    %rax,%rdi
  8035dc:	48 b8 6f 33 80 00 00 	movabs $0x80336f,%rax
  8035e3:	00 00 00 
  8035e6:	ff d0                	callq  *%rax
  8035e8:	85 c0                	test   %eax,%eax
  8035ea:	74 07                	je     8035f3 <devpipe_write+0x67>
				return 0;
  8035ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f1:	eb 79                	jmp    80366c <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8035f3:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  8035fa:	00 00 00 
  8035fd:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8035ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803603:	8b 40 04             	mov    0x4(%rax),%eax
  803606:	48 63 d0             	movslq %eax,%rdx
  803609:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360d:	8b 00                	mov    (%rax),%eax
  80360f:	48 98                	cltq   
  803611:	48 83 c0 20          	add    $0x20,%rax
  803615:	48 39 c2             	cmp    %rax,%rdx
  803618:	73 b4                	jae    8035ce <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80361a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80361e:	8b 40 04             	mov    0x4(%rax),%eax
  803621:	99                   	cltd   
  803622:	c1 ea 1b             	shr    $0x1b,%edx
  803625:	01 d0                	add    %edx,%eax
  803627:	83 e0 1f             	and    $0x1f,%eax
  80362a:	29 d0                	sub    %edx,%eax
  80362c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803630:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803634:	48 01 ca             	add    %rcx,%rdx
  803637:	0f b6 0a             	movzbl (%rdx),%ecx
  80363a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80363e:	48 98                	cltq   
  803640:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803644:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803648:	8b 40 04             	mov    0x4(%rax),%eax
  80364b:	8d 50 01             	lea    0x1(%rax),%edx
  80364e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803652:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803655:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80365a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80365e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803662:	0f 82 64 ff ff ff    	jb     8035cc <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803668:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80366c:	c9                   	leaveq 
  80366d:	c3                   	retq   

000000000080366e <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80366e:	55                   	push   %rbp
  80366f:	48 89 e5             	mov    %rsp,%rbp
  803672:	48 83 ec 20          	sub    $0x20,%rsp
  803676:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80367a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80367e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803682:	48 89 c7             	mov    %rax,%rdi
  803685:	48 b8 1c 24 80 00 00 	movabs $0x80241c,%rax
  80368c:	00 00 00 
  80368f:	ff d0                	callq  *%rax
  803691:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803695:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803699:	48 be c6 42 80 00 00 	movabs $0x8042c6,%rsi
  8036a0:	00 00 00 
  8036a3:	48 89 c7             	mov    %rax,%rdi
  8036a6:	48 b8 77 11 80 00 00 	movabs $0x801177,%rax
  8036ad:	00 00 00 
  8036b0:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8036b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036b6:	8b 50 04             	mov    0x4(%rax),%edx
  8036b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036bd:	8b 00                	mov    (%rax),%eax
  8036bf:	29 c2                	sub    %eax,%edx
  8036c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036c5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8036cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036cf:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8036d6:	00 00 00 
	stat->st_dev = &devpipe;
  8036d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036dd:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8036e4:	00 00 00 
  8036e7:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8036ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036f3:	c9                   	leaveq 
  8036f4:	c3                   	retq   

00000000008036f5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8036f5:	55                   	push   %rbp
  8036f6:	48 89 e5             	mov    %rsp,%rbp
  8036f9:	48 83 ec 10          	sub    $0x10,%rsp
  8036fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803701:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803705:	48 89 c6             	mov    %rax,%rsi
  803708:	bf 00 00 00 00       	mov    $0x0,%edi
  80370d:	48 b8 51 1b 80 00 00 	movabs $0x801b51,%rax
  803714:	00 00 00 
  803717:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803719:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80371d:	48 89 c7             	mov    %rax,%rdi
  803720:	48 b8 1c 24 80 00 00 	movabs $0x80241c,%rax
  803727:	00 00 00 
  80372a:	ff d0                	callq  *%rax
  80372c:	48 89 c6             	mov    %rax,%rsi
  80372f:	bf 00 00 00 00       	mov    $0x0,%edi
  803734:	48 b8 51 1b 80 00 00 	movabs $0x801b51,%rax
  80373b:	00 00 00 
  80373e:	ff d0                	callq  *%rax
}
  803740:	c9                   	leaveq 
  803741:	c3                   	retq   

0000000000803742 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803742:	55                   	push   %rbp
  803743:	48 89 e5             	mov    %rsp,%rbp
  803746:	48 83 ec 20          	sub    $0x20,%rsp
  80374a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80374d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803750:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803753:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803757:	be 01 00 00 00       	mov    $0x1,%esi
  80375c:	48 89 c7             	mov    %rax,%rdi
  80375f:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  803766:	00 00 00 
  803769:	ff d0                	callq  *%rax
}
  80376b:	c9                   	leaveq 
  80376c:	c3                   	retq   

000000000080376d <getchar>:

int
getchar(void)
{
  80376d:	55                   	push   %rbp
  80376e:	48 89 e5             	mov    %rsp,%rbp
  803771:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803775:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803779:	ba 01 00 00 00       	mov    $0x1,%edx
  80377e:	48 89 c6             	mov    %rax,%rsi
  803781:	bf 00 00 00 00       	mov    $0x0,%edi
  803786:	48 b8 11 29 80 00 00 	movabs $0x802911,%rax
  80378d:	00 00 00 
  803790:	ff d0                	callq  *%rax
  803792:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803795:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803799:	79 05                	jns    8037a0 <getchar+0x33>
		return r;
  80379b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80379e:	eb 14                	jmp    8037b4 <getchar+0x47>
	if (r < 1)
  8037a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037a4:	7f 07                	jg     8037ad <getchar+0x40>
		return -E_EOF;
  8037a6:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8037ab:	eb 07                	jmp    8037b4 <getchar+0x47>
	return c;
  8037ad:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8037b1:	0f b6 c0             	movzbl %al,%eax
}
  8037b4:	c9                   	leaveq 
  8037b5:	c3                   	retq   

00000000008037b6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8037b6:	55                   	push   %rbp
  8037b7:	48 89 e5             	mov    %rsp,%rbp
  8037ba:	48 83 ec 20          	sub    $0x20,%rsp
  8037be:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037c1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8037c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037c8:	48 89 d6             	mov    %rdx,%rsi
  8037cb:	89 c7                	mov    %eax,%edi
  8037cd:	48 b8 df 24 80 00 00 	movabs $0x8024df,%rax
  8037d4:	00 00 00 
  8037d7:	ff d0                	callq  *%rax
  8037d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e0:	79 05                	jns    8037e7 <iscons+0x31>
		return r;
  8037e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e5:	eb 1a                	jmp    803801 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8037e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037eb:	8b 10                	mov    (%rax),%edx
  8037ed:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8037f4:	00 00 00 
  8037f7:	8b 00                	mov    (%rax),%eax
  8037f9:	39 c2                	cmp    %eax,%edx
  8037fb:	0f 94 c0             	sete   %al
  8037fe:	0f b6 c0             	movzbl %al,%eax
}
  803801:	c9                   	leaveq 
  803802:	c3                   	retq   

0000000000803803 <opencons>:

int
opencons(void)
{
  803803:	55                   	push   %rbp
  803804:	48 89 e5             	mov    %rsp,%rbp
  803807:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80380b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80380f:	48 89 c7             	mov    %rax,%rdi
  803812:	48 b8 47 24 80 00 00 	movabs $0x802447,%rax
  803819:	00 00 00 
  80381c:	ff d0                	callq  *%rax
  80381e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803821:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803825:	79 05                	jns    80382c <opencons+0x29>
		return r;
  803827:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80382a:	eb 5b                	jmp    803887 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80382c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803830:	ba 07 04 00 00       	mov    $0x407,%edx
  803835:	48 89 c6             	mov    %rax,%rsi
  803838:	bf 00 00 00 00       	mov    $0x0,%edi
  80383d:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  803844:	00 00 00 
  803847:	ff d0                	callq  *%rax
  803849:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80384c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803850:	79 05                	jns    803857 <opencons+0x54>
		return r;
  803852:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803855:	eb 30                	jmp    803887 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803857:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80385b:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803862:	00 00 00 
  803865:	8b 12                	mov    (%rdx),%edx
  803867:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803869:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80386d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803874:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803878:	48 89 c7             	mov    %rax,%rdi
  80387b:	48 b8 f9 23 80 00 00 	movabs $0x8023f9,%rax
  803882:	00 00 00 
  803885:	ff d0                	callq  *%rax
}
  803887:	c9                   	leaveq 
  803888:	c3                   	retq   

0000000000803889 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803889:	55                   	push   %rbp
  80388a:	48 89 e5             	mov    %rsp,%rbp
  80388d:	48 83 ec 30          	sub    $0x30,%rsp
  803891:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803895:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803899:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80389d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8038a2:	75 07                	jne    8038ab <devcons_read+0x22>
		return 0;
  8038a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a9:	eb 4b                	jmp    8038f6 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8038ab:	eb 0c                	jmp    8038b9 <devcons_read+0x30>
		sys_yield();
  8038ad:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  8038b4:	00 00 00 
  8038b7:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8038b9:	48 b8 a8 19 80 00 00 	movabs $0x8019a8,%rax
  8038c0:	00 00 00 
  8038c3:	ff d0                	callq  *%rax
  8038c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038cc:	74 df                	je     8038ad <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8038ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d2:	79 05                	jns    8038d9 <devcons_read+0x50>
		return c;
  8038d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d7:	eb 1d                	jmp    8038f6 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8038d9:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8038dd:	75 07                	jne    8038e6 <devcons_read+0x5d>
		return 0;
  8038df:	b8 00 00 00 00       	mov    $0x0,%eax
  8038e4:	eb 10                	jmp    8038f6 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8038e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e9:	89 c2                	mov    %eax,%edx
  8038eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038ef:	88 10                	mov    %dl,(%rax)
	return 1;
  8038f1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8038f6:	c9                   	leaveq 
  8038f7:	c3                   	retq   

00000000008038f8 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038f8:	55                   	push   %rbp
  8038f9:	48 89 e5             	mov    %rsp,%rbp
  8038fc:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803903:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80390a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803911:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803918:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80391f:	eb 76                	jmp    803997 <devcons_write+0x9f>
		m = n - tot;
  803921:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803928:	89 c2                	mov    %eax,%edx
  80392a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80392d:	29 c2                	sub    %eax,%edx
  80392f:	89 d0                	mov    %edx,%eax
  803931:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803934:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803937:	83 f8 7f             	cmp    $0x7f,%eax
  80393a:	76 07                	jbe    803943 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80393c:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803943:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803946:	48 63 d0             	movslq %eax,%rdx
  803949:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80394c:	48 63 c8             	movslq %eax,%rcx
  80394f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803956:	48 01 c1             	add    %rax,%rcx
  803959:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803960:	48 89 ce             	mov    %rcx,%rsi
  803963:	48 89 c7             	mov    %rax,%rdi
  803966:	48 b8 9b 14 80 00 00 	movabs $0x80149b,%rax
  80396d:	00 00 00 
  803970:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803972:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803975:	48 63 d0             	movslq %eax,%rdx
  803978:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80397f:	48 89 d6             	mov    %rdx,%rsi
  803982:	48 89 c7             	mov    %rax,%rdi
  803985:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  80398c:	00 00 00 
  80398f:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803991:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803994:	01 45 fc             	add    %eax,-0x4(%rbp)
  803997:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80399a:	48 98                	cltq   
  80399c:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8039a3:	0f 82 78 ff ff ff    	jb     803921 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8039a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039ac:	c9                   	leaveq 
  8039ad:	c3                   	retq   

00000000008039ae <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8039ae:	55                   	push   %rbp
  8039af:	48 89 e5             	mov    %rsp,%rbp
  8039b2:	48 83 ec 08          	sub    $0x8,%rsp
  8039b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8039ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039bf:	c9                   	leaveq 
  8039c0:	c3                   	retq   

00000000008039c1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8039c1:	55                   	push   %rbp
  8039c2:	48 89 e5             	mov    %rsp,%rbp
  8039c5:	48 83 ec 10          	sub    $0x10,%rsp
  8039c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8039d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d5:	48 be d2 42 80 00 00 	movabs $0x8042d2,%rsi
  8039dc:	00 00 00 
  8039df:	48 89 c7             	mov    %rax,%rdi
  8039e2:	48 b8 77 11 80 00 00 	movabs $0x801177,%rax
  8039e9:	00 00 00 
  8039ec:	ff d0                	callq  *%rax
	return 0;
  8039ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039f3:	c9                   	leaveq 
  8039f4:	c3                   	retq   

00000000008039f5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8039f5:	55                   	push   %rbp
  8039f6:	48 89 e5             	mov    %rsp,%rbp
  8039f9:	53                   	push   %rbx
  8039fa:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803a01:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803a08:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803a0e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803a15:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803a1c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803a23:	84 c0                	test   %al,%al
  803a25:	74 23                	je     803a4a <_panic+0x55>
  803a27:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803a2e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803a32:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803a36:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803a3a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803a3e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803a42:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803a46:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803a4a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803a51:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803a58:	00 00 00 
  803a5b:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803a62:	00 00 00 
  803a65:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803a69:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803a70:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803a77:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803a7e:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  803a85:	00 00 00 
  803a88:	48 8b 18             	mov    (%rax),%rbx
  803a8b:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  803a92:	00 00 00 
  803a95:	ff d0                	callq  *%rax
  803a97:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803a9d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803aa4:	41 89 c8             	mov    %ecx,%r8d
  803aa7:	48 89 d1             	mov    %rdx,%rcx
  803aaa:	48 89 da             	mov    %rbx,%rdx
  803aad:	89 c6                	mov    %eax,%esi
  803aaf:	48 bf e0 42 80 00 00 	movabs $0x8042e0,%rdi
  803ab6:	00 00 00 
  803ab9:	b8 00 00 00 00       	mov    $0x0,%eax
  803abe:	49 b9 cf 03 80 00 00 	movabs $0x8003cf,%r9
  803ac5:	00 00 00 
  803ac8:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803acb:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803ad2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803ad9:	48 89 d6             	mov    %rdx,%rsi
  803adc:	48 89 c7             	mov    %rax,%rdi
  803adf:	48 b8 23 03 80 00 00 	movabs $0x800323,%rax
  803ae6:	00 00 00 
  803ae9:	ff d0                	callq  *%rax
	cprintf("\n");
  803aeb:	48 bf 03 43 80 00 00 	movabs $0x804303,%rdi
  803af2:	00 00 00 
  803af5:	b8 00 00 00 00       	mov    $0x0,%eax
  803afa:	48 ba cf 03 80 00 00 	movabs $0x8003cf,%rdx
  803b01:	00 00 00 
  803b04:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803b06:	cc                   	int3   
  803b07:	eb fd                	jmp    803b06 <_panic+0x111>

0000000000803b09 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803b09:	55                   	push   %rbp
  803b0a:	48 89 e5             	mov    %rsp,%rbp
  803b0d:	48 83 ec 10          	sub    $0x10,%rsp
  803b11:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803b15:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803b1c:	00 00 00 
  803b1f:	48 8b 00             	mov    (%rax),%rax
  803b22:	48 85 c0             	test   %rax,%rax
  803b25:	75 3a                	jne    803b61 <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  803b27:	ba 07 00 00 00       	mov    $0x7,%edx
  803b2c:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803b31:	bf 00 00 00 00       	mov    $0x0,%edi
  803b36:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  803b3d:	00 00 00 
  803b40:	ff d0                	callq  *%rax
  803b42:	85 c0                	test   %eax,%eax
  803b44:	75 1b                	jne    803b61 <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803b46:	48 be 74 3b 80 00 00 	movabs $0x803b74,%rsi
  803b4d:	00 00 00 
  803b50:	bf 00 00 00 00       	mov    $0x0,%edi
  803b55:	48 b8 30 1c 80 00 00 	movabs $0x801c30,%rax
  803b5c:	00 00 00 
  803b5f:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803b61:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803b68:	00 00 00 
  803b6b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b6f:	48 89 10             	mov    %rdx,(%rax)
}
  803b72:	c9                   	leaveq 
  803b73:	c3                   	retq   

0000000000803b74 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803b74:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803b77:	48 a1 08 80 80 00 00 	movabs 0x808008,%rax
  803b7e:	00 00 00 
	call *%rax
  803b81:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  803b83:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  803b86:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803b8d:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  803b8e:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  803b95:	00 
	pushq %rbx		// push utf_rip into new stack
  803b96:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  803b97:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  803b9e:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  803ba1:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  803ba5:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  803ba9:	4c 8b 3c 24          	mov    (%rsp),%r15
  803bad:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803bb2:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803bb7:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803bbc:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803bc1:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803bc6:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803bcb:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803bd0:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803bd5:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803bda:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803bdf:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803be4:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803be9:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803bee:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803bf3:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  803bf7:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  803bfb:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  803bfc:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803bfd:	c3                   	retq   

0000000000803bfe <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803bfe:	55                   	push   %rbp
  803bff:	48 89 e5             	mov    %rsp,%rbp
  803c02:	48 83 ec 18          	sub    $0x18,%rsp
  803c06:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803c0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c0e:	48 c1 e8 15          	shr    $0x15,%rax
  803c12:	48 89 c2             	mov    %rax,%rdx
  803c15:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c1c:	01 00 00 
  803c1f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c23:	83 e0 01             	and    $0x1,%eax
  803c26:	48 85 c0             	test   %rax,%rax
  803c29:	75 07                	jne    803c32 <pageref+0x34>
		return 0;
  803c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  803c30:	eb 53                	jmp    803c85 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803c32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c36:	48 c1 e8 0c          	shr    $0xc,%rax
  803c3a:	48 89 c2             	mov    %rax,%rdx
  803c3d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c44:	01 00 00 
  803c47:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c4b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c53:	83 e0 01             	and    $0x1,%eax
  803c56:	48 85 c0             	test   %rax,%rax
  803c59:	75 07                	jne    803c62 <pageref+0x64>
		return 0;
  803c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  803c60:	eb 23                	jmp    803c85 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c66:	48 c1 e8 0c          	shr    $0xc,%rax
  803c6a:	48 89 c2             	mov    %rax,%rdx
  803c6d:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c74:	00 00 00 
  803c77:	48 c1 e2 04          	shl    $0x4,%rdx
  803c7b:	48 01 d0             	add    %rdx,%rax
  803c7e:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c82:	0f b7 c0             	movzwl %ax,%eax
}
  803c85:	c9                   	leaveq 
  803c86:	c3                   	retq   
