
obj/user/spin.debug:     file format elf64-x86-64


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
  80003c:	e8 07 01 00 00       	callq  800148 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  800052:	48 bf e0 3b 80 00 00 	movabs $0x803be0,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((env = fork()) == 0) {
  80006d:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  800074:	00 00 00 
  800077:	ff d0                	callq  *%rax
  800079:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800080:	75 1d                	jne    80009f <umain+0x5c>
		cprintf("I am the child.  Spinning...\n");
  800082:	48 bf 08 3c 80 00 00 	movabs $0x803c08,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
		while (1)
			/* do nothing */;
  80009d:	eb fe                	jmp    80009d <umain+0x5a>
	}

	cprintf("I am the parent.  Running the child...\n");
  80009f:	48 bf 28 3c 80 00 00 	movabs $0x803c28,%rdi
  8000a6:	00 00 00 
  8000a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ae:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  8000b5:	00 00 00 
  8000b8:	ff d2                	callq  *%rdx
	sys_yield();
  8000ba:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
	sys_yield();
  8000c6:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  8000cd:	00 00 00 
  8000d0:	ff d0                	callq  *%rax
	sys_yield();
  8000d2:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  8000d9:	00 00 00 
  8000dc:	ff d0                	callq  *%rax
	sys_yield();
  8000de:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	callq  *%rax
	sys_yield();
  8000ea:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  8000f1:	00 00 00 
  8000f4:	ff d0                	callq  *%rax
	sys_yield();
  8000f6:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	callq  *%rax
	sys_yield();
  800102:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  800109:	00 00 00 
  80010c:	ff d0                	callq  *%rax
	sys_yield();
  80010e:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax

	cprintf("I am the parent.  Killing the child...\n");
  80011a:	48 bf 50 3c 80 00 00 	movabs $0x803c50,%rdi
  800121:	00 00 00 
  800124:	b8 00 00 00 00       	mov    $0x0,%eax
  800129:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  800130:	00 00 00 
  800133:	ff d2                	callq  *%rdx
	sys_env_destroy(env);
  800135:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800138:	89 c7                	mov    %eax,%edi
  80013a:	48 b8 37 19 80 00 00 	movabs $0x801937,%rax
  800141:	00 00 00 
  800144:	ff d0                	callq  *%rax
}
  800146:	c9                   	leaveq 
  800147:	c3                   	retq   

0000000000800148 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800148:	55                   	push   %rbp
  800149:	48 89 e5             	mov    %rsp,%rbp
  80014c:	48 83 ec 10          	sub    $0x10,%rsp
  800150:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800153:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800157:	48 b8 7b 19 80 00 00 	movabs $0x80197b,%rax
  80015e:	00 00 00 
  800161:	ff d0                	callq  *%rax
  800163:	48 98                	cltq   
  800165:	25 ff 03 00 00       	and    $0x3ff,%eax
  80016a:	48 89 c2             	mov    %rax,%rdx
  80016d:	48 89 d0             	mov    %rdx,%rax
  800170:	48 c1 e0 03          	shl    $0x3,%rax
  800174:	48 01 d0             	add    %rdx,%rax
  800177:	48 c1 e0 05          	shl    $0x5,%rax
  80017b:	48 89 c2             	mov    %rax,%rdx
  80017e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800185:	00 00 00 
  800188:	48 01 c2             	add    %rax,%rdx
  80018b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800192:	00 00 00 
  800195:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800198:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80019c:	7e 14                	jle    8001b2 <libmain+0x6a>
		binaryname = argv[0];
  80019e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a2:	48 8b 10             	mov    (%rax),%rdx
  8001a5:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001ac:	00 00 00 
  8001af:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001b9:	48 89 d6             	mov    %rdx,%rsi
  8001bc:	89 c7                	mov    %eax,%edi
  8001be:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001c5:	00 00 00 
  8001c8:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001ca:	48 b8 d8 01 80 00 00 	movabs $0x8001d8,%rax
  8001d1:	00 00 00 
  8001d4:	ff d0                	callq  *%rax
}
  8001d6:	c9                   	leaveq 
  8001d7:	c3                   	retq   

00000000008001d8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d8:	55                   	push   %rbp
  8001d9:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001dc:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  8001e3:	00 00 00 
  8001e6:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ed:	48 b8 37 19 80 00 00 	movabs $0x801937,%rax
  8001f4:	00 00 00 
  8001f7:	ff d0                	callq  *%rax
}
  8001f9:	5d                   	pop    %rbp
  8001fa:	c3                   	retq   

00000000008001fb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001fb:	55                   	push   %rbp
  8001fc:	48 89 e5             	mov    %rsp,%rbp
  8001ff:	48 83 ec 10          	sub    $0x10,%rsp
  800203:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800206:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80020a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020e:	8b 00                	mov    (%rax),%eax
  800210:	8d 48 01             	lea    0x1(%rax),%ecx
  800213:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800217:	89 0a                	mov    %ecx,(%rdx)
  800219:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80021c:	89 d1                	mov    %edx,%ecx
  80021e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800222:	48 98                	cltq   
  800224:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022c:	8b 00                	mov    (%rax),%eax
  80022e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800233:	75 2c                	jne    800261 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800235:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800239:	8b 00                	mov    (%rax),%eax
  80023b:	48 98                	cltq   
  80023d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800241:	48 83 c2 08          	add    $0x8,%rdx
  800245:	48 89 c6             	mov    %rax,%rsi
  800248:	48 89 d7             	mov    %rdx,%rdi
  80024b:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  800252:	00 00 00 
  800255:	ff d0                	callq  *%rax
		b->idx = 0;
  800257:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80025b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800261:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800265:	8b 40 04             	mov    0x4(%rax),%eax
  800268:	8d 50 01             	lea    0x1(%rax),%edx
  80026b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80026f:	89 50 04             	mov    %edx,0x4(%rax)
}
  800272:	c9                   	leaveq 
  800273:	c3                   	retq   

0000000000800274 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800274:	55                   	push   %rbp
  800275:	48 89 e5             	mov    %rsp,%rbp
  800278:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80027f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800286:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80028d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800294:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80029b:	48 8b 0a             	mov    (%rdx),%rcx
  80029e:	48 89 08             	mov    %rcx,(%rax)
  8002a1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002a5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002a9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002ad:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8002b1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002b8:	00 00 00 
	b.cnt = 0;
  8002bb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002c2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8002c5:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002cc:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002d3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002da:	48 89 c6             	mov    %rax,%rsi
  8002dd:	48 bf fb 01 80 00 00 	movabs $0x8001fb,%rdi
  8002e4:	00 00 00 
  8002e7:	48 b8 d3 06 80 00 00 	movabs $0x8006d3,%rax
  8002ee:	00 00 00 
  8002f1:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8002f3:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002f9:	48 98                	cltq   
  8002fb:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800302:	48 83 c2 08          	add    $0x8,%rdx
  800306:	48 89 c6             	mov    %rax,%rsi
  800309:	48 89 d7             	mov    %rdx,%rdi
  80030c:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  800313:	00 00 00 
  800316:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800318:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80031e:	c9                   	leaveq 
  80031f:	c3                   	retq   

0000000000800320 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800320:	55                   	push   %rbp
  800321:	48 89 e5             	mov    %rsp,%rbp
  800324:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80032b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800332:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800339:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800340:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800347:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80034e:	84 c0                	test   %al,%al
  800350:	74 20                	je     800372 <cprintf+0x52>
  800352:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800356:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80035a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80035e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800362:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800366:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80036a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80036e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800372:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800379:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800380:	00 00 00 
  800383:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80038a:	00 00 00 
  80038d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800391:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800398:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80039f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8003a6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003ad:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003b4:	48 8b 0a             	mov    (%rdx),%rcx
  8003b7:	48 89 08             	mov    %rcx,(%rax)
  8003ba:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003be:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003c2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003c6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8003ca:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003d1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003d8:	48 89 d6             	mov    %rdx,%rsi
  8003db:	48 89 c7             	mov    %rax,%rdi
  8003de:	48 b8 74 02 80 00 00 	movabs $0x800274,%rax
  8003e5:	00 00 00 
  8003e8:	ff d0                	callq  *%rax
  8003ea:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8003f0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003f6:	c9                   	leaveq 
  8003f7:	c3                   	retq   

00000000008003f8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f8:	55                   	push   %rbp
  8003f9:	48 89 e5             	mov    %rsp,%rbp
  8003fc:	53                   	push   %rbx
  8003fd:	48 83 ec 38          	sub    $0x38,%rsp
  800401:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800405:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800409:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80040d:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800410:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800414:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800418:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80041b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80041f:	77 3b                	ja     80045c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800421:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800424:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800428:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80042b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042f:	ba 00 00 00 00       	mov    $0x0,%edx
  800434:	48 f7 f3             	div    %rbx
  800437:	48 89 c2             	mov    %rax,%rdx
  80043a:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80043d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800440:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800444:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800448:	41 89 f9             	mov    %edi,%r9d
  80044b:	48 89 c7             	mov    %rax,%rdi
  80044e:	48 b8 f8 03 80 00 00 	movabs $0x8003f8,%rax
  800455:	00 00 00 
  800458:	ff d0                	callq  *%rax
  80045a:	eb 1e                	jmp    80047a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80045c:	eb 12                	jmp    800470 <printnum+0x78>
			putch(padc, putdat);
  80045e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800462:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800465:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800469:	48 89 ce             	mov    %rcx,%rsi
  80046c:	89 d7                	mov    %edx,%edi
  80046e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800470:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800474:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800478:	7f e4                	jg     80045e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80047a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80047d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800481:	ba 00 00 00 00       	mov    $0x0,%edx
  800486:	48 f7 f1             	div    %rcx
  800489:	48 89 d0             	mov    %rdx,%rax
  80048c:	48 ba 68 3e 80 00 00 	movabs $0x803e68,%rdx
  800493:	00 00 00 
  800496:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80049a:	0f be d0             	movsbl %al,%edx
  80049d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a5:	48 89 ce             	mov    %rcx,%rsi
  8004a8:	89 d7                	mov    %edx,%edi
  8004aa:	ff d0                	callq  *%rax
}
  8004ac:	48 83 c4 38          	add    $0x38,%rsp
  8004b0:	5b                   	pop    %rbx
  8004b1:	5d                   	pop    %rbp
  8004b2:	c3                   	retq   

00000000008004b3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004b3:	55                   	push   %rbp
  8004b4:	48 89 e5             	mov    %rsp,%rbp
  8004b7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004bf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8004c2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004c6:	7e 52                	jle    80051a <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cc:	8b 00                	mov    (%rax),%eax
  8004ce:	83 f8 30             	cmp    $0x30,%eax
  8004d1:	73 24                	jae    8004f7 <getuint+0x44>
  8004d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004df:	8b 00                	mov    (%rax),%eax
  8004e1:	89 c0                	mov    %eax,%eax
  8004e3:	48 01 d0             	add    %rdx,%rax
  8004e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ea:	8b 12                	mov    (%rdx),%edx
  8004ec:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f3:	89 0a                	mov    %ecx,(%rdx)
  8004f5:	eb 17                	jmp    80050e <getuint+0x5b>
  8004f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004ff:	48 89 d0             	mov    %rdx,%rax
  800502:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800506:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80050a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80050e:	48 8b 00             	mov    (%rax),%rax
  800511:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800515:	e9 a3 00 00 00       	jmpq   8005bd <getuint+0x10a>
	else if (lflag)
  80051a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80051e:	74 4f                	je     80056f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800524:	8b 00                	mov    (%rax),%eax
  800526:	83 f8 30             	cmp    $0x30,%eax
  800529:	73 24                	jae    80054f <getuint+0x9c>
  80052b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800537:	8b 00                	mov    (%rax),%eax
  800539:	89 c0                	mov    %eax,%eax
  80053b:	48 01 d0             	add    %rdx,%rax
  80053e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800542:	8b 12                	mov    (%rdx),%edx
  800544:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800547:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054b:	89 0a                	mov    %ecx,(%rdx)
  80054d:	eb 17                	jmp    800566 <getuint+0xb3>
  80054f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800553:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800557:	48 89 d0             	mov    %rdx,%rax
  80055a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80055e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800562:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800566:	48 8b 00             	mov    (%rax),%rax
  800569:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80056d:	eb 4e                	jmp    8005bd <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80056f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800573:	8b 00                	mov    (%rax),%eax
  800575:	83 f8 30             	cmp    $0x30,%eax
  800578:	73 24                	jae    80059e <getuint+0xeb>
  80057a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800586:	8b 00                	mov    (%rax),%eax
  800588:	89 c0                	mov    %eax,%eax
  80058a:	48 01 d0             	add    %rdx,%rax
  80058d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800591:	8b 12                	mov    (%rdx),%edx
  800593:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800596:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059a:	89 0a                	mov    %ecx,(%rdx)
  80059c:	eb 17                	jmp    8005b5 <getuint+0x102>
  80059e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a6:	48 89 d0             	mov    %rdx,%rax
  8005a9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b5:	8b 00                	mov    (%rax),%eax
  8005b7:	89 c0                	mov    %eax,%eax
  8005b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005c1:	c9                   	leaveq 
  8005c2:	c3                   	retq   

00000000008005c3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005c3:	55                   	push   %rbp
  8005c4:	48 89 e5             	mov    %rsp,%rbp
  8005c7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005cf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005d2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005d6:	7e 52                	jle    80062a <getint+0x67>
		x=va_arg(*ap, long long);
  8005d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dc:	8b 00                	mov    (%rax),%eax
  8005de:	83 f8 30             	cmp    $0x30,%eax
  8005e1:	73 24                	jae    800607 <getint+0x44>
  8005e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ef:	8b 00                	mov    (%rax),%eax
  8005f1:	89 c0                	mov    %eax,%eax
  8005f3:	48 01 d0             	add    %rdx,%rax
  8005f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fa:	8b 12                	mov    (%rdx),%edx
  8005fc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800603:	89 0a                	mov    %ecx,(%rdx)
  800605:	eb 17                	jmp    80061e <getint+0x5b>
  800607:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80060f:	48 89 d0             	mov    %rdx,%rax
  800612:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800616:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80061a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80061e:	48 8b 00             	mov    (%rax),%rax
  800621:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800625:	e9 a3 00 00 00       	jmpq   8006cd <getint+0x10a>
	else if (lflag)
  80062a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80062e:	74 4f                	je     80067f <getint+0xbc>
		x=va_arg(*ap, long);
  800630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800634:	8b 00                	mov    (%rax),%eax
  800636:	83 f8 30             	cmp    $0x30,%eax
  800639:	73 24                	jae    80065f <getint+0x9c>
  80063b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	8b 00                	mov    (%rax),%eax
  800649:	89 c0                	mov    %eax,%eax
  80064b:	48 01 d0             	add    %rdx,%rax
  80064e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800652:	8b 12                	mov    (%rdx),%edx
  800654:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800657:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065b:	89 0a                	mov    %ecx,(%rdx)
  80065d:	eb 17                	jmp    800676 <getint+0xb3>
  80065f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800663:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800667:	48 89 d0             	mov    %rdx,%rax
  80066a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80066e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800672:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800676:	48 8b 00             	mov    (%rax),%rax
  800679:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80067d:	eb 4e                	jmp    8006cd <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80067f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800683:	8b 00                	mov    (%rax),%eax
  800685:	83 f8 30             	cmp    $0x30,%eax
  800688:	73 24                	jae    8006ae <getint+0xeb>
  80068a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800696:	8b 00                	mov    (%rax),%eax
  800698:	89 c0                	mov    %eax,%eax
  80069a:	48 01 d0             	add    %rdx,%rax
  80069d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a1:	8b 12                	mov    (%rdx),%edx
  8006a3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006aa:	89 0a                	mov    %ecx,(%rdx)
  8006ac:	eb 17                	jmp    8006c5 <getint+0x102>
  8006ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b6:	48 89 d0             	mov    %rdx,%rax
  8006b9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c5:	8b 00                	mov    (%rax),%eax
  8006c7:	48 98                	cltq   
  8006c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006d1:	c9                   	leaveq 
  8006d2:	c3                   	retq   

00000000008006d3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006d3:	55                   	push   %rbp
  8006d4:	48 89 e5             	mov    %rsp,%rbp
  8006d7:	41 54                	push   %r12
  8006d9:	53                   	push   %rbx
  8006da:	48 83 ec 60          	sub    $0x60,%rsp
  8006de:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006e2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006e6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006ea:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006ee:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006f2:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006f6:	48 8b 0a             	mov    (%rdx),%rcx
  8006f9:	48 89 08             	mov    %rcx,(%rax)
  8006fc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800700:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800704:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800708:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  80070c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800710:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800714:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800718:	0f b6 00             	movzbl (%rax),%eax
  80071b:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  80071e:	eb 29                	jmp    800749 <vprintfmt+0x76>
			if (ch == '\0')
  800720:	85 db                	test   %ebx,%ebx
  800722:	0f 84 ad 06 00 00    	je     800dd5 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  800728:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80072c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800730:	48 89 d6             	mov    %rdx,%rsi
  800733:	89 df                	mov    %ebx,%edi
  800735:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  800737:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80073b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80073f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800743:	0f b6 00             	movzbl (%rax),%eax
  800746:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  800749:	83 fb 25             	cmp    $0x25,%ebx
  80074c:	74 05                	je     800753 <vprintfmt+0x80>
  80074e:	83 fb 1b             	cmp    $0x1b,%ebx
  800751:	75 cd                	jne    800720 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800753:	83 fb 1b             	cmp    $0x1b,%ebx
  800756:	0f 85 ae 01 00 00    	jne    80090a <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  80075c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800763:	00 00 00 
  800766:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  80076c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800770:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800774:	48 89 d6             	mov    %rdx,%rsi
  800777:	89 df                	mov    %ebx,%edi
  800779:	ff d0                	callq  *%rax
			putch('[', putdat);
  80077b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80077f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800783:	48 89 d6             	mov    %rdx,%rsi
  800786:	bf 5b 00 00 00       	mov    $0x5b,%edi
  80078b:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  80078d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800793:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800798:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80079c:	0f b6 00             	movzbl (%rax),%eax
  80079f:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8007a2:	eb 32                	jmp    8007d6 <vprintfmt+0x103>
					putch(ch, putdat);
  8007a4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007a8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007ac:	48 89 d6             	mov    %rdx,%rsi
  8007af:	89 df                	mov    %ebx,%edi
  8007b1:	ff d0                	callq  *%rax
					esc_color *= 10;
  8007b3:	44 89 e0             	mov    %r12d,%eax
  8007b6:	c1 e0 02             	shl    $0x2,%eax
  8007b9:	44 01 e0             	add    %r12d,%eax
  8007bc:	01 c0                	add    %eax,%eax
  8007be:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  8007c1:	8d 43 d0             	lea    -0x30(%rbx),%eax
  8007c4:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  8007c7:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8007cc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007d0:	0f b6 00             	movzbl (%rax),%eax
  8007d3:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8007d6:	83 fb 3b             	cmp    $0x3b,%ebx
  8007d9:	74 05                	je     8007e0 <vprintfmt+0x10d>
  8007db:	83 fb 6d             	cmp    $0x6d,%ebx
  8007de:	75 c4                	jne    8007a4 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  8007e0:	45 85 e4             	test   %r12d,%r12d
  8007e3:	75 15                	jne    8007fa <vprintfmt+0x127>
					color_flag = 0x07;
  8007e5:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8007ec:	00 00 00 
  8007ef:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  8007f5:	e9 dc 00 00 00       	jmpq   8008d6 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  8007fa:	41 83 fc 1d          	cmp    $0x1d,%r12d
  8007fe:	7e 69                	jle    800869 <vprintfmt+0x196>
  800800:	41 83 fc 25          	cmp    $0x25,%r12d
  800804:	7f 63                	jg     800869 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800806:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80080d:	00 00 00 
  800810:	8b 00                	mov    (%rax),%eax
  800812:	25 f8 00 00 00       	and    $0xf8,%eax
  800817:	89 c2                	mov    %eax,%edx
  800819:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800820:	00 00 00 
  800823:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800825:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800829:	44 89 e0             	mov    %r12d,%eax
  80082c:	83 e0 04             	and    $0x4,%eax
  80082f:	c1 f8 02             	sar    $0x2,%eax
  800832:	89 c2                	mov    %eax,%edx
  800834:	44 89 e0             	mov    %r12d,%eax
  800837:	83 e0 02             	and    $0x2,%eax
  80083a:	09 c2                	or     %eax,%edx
  80083c:	44 89 e0             	mov    %r12d,%eax
  80083f:	83 e0 01             	and    $0x1,%eax
  800842:	c1 e0 02             	shl    $0x2,%eax
  800845:	09 c2                	or     %eax,%edx
  800847:	41 89 d4             	mov    %edx,%r12d
  80084a:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800851:	00 00 00 
  800854:	8b 00                	mov    (%rax),%eax
  800856:	44 89 e2             	mov    %r12d,%edx
  800859:	09 c2                	or     %eax,%edx
  80085b:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800862:	00 00 00 
  800865:	89 10                	mov    %edx,(%rax)
  800867:	eb 6d                	jmp    8008d6 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800869:	41 83 fc 27          	cmp    $0x27,%r12d
  80086d:	7e 67                	jle    8008d6 <vprintfmt+0x203>
  80086f:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800873:	7f 61                	jg     8008d6 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800875:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80087c:	00 00 00 
  80087f:	8b 00                	mov    (%rax),%eax
  800881:	25 8f 00 00 00       	and    $0x8f,%eax
  800886:	89 c2                	mov    %eax,%edx
  800888:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80088f:	00 00 00 
  800892:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800894:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800898:	44 89 e0             	mov    %r12d,%eax
  80089b:	83 e0 04             	and    $0x4,%eax
  80089e:	c1 f8 02             	sar    $0x2,%eax
  8008a1:	89 c2                	mov    %eax,%edx
  8008a3:	44 89 e0             	mov    %r12d,%eax
  8008a6:	83 e0 02             	and    $0x2,%eax
  8008a9:	09 c2                	or     %eax,%edx
  8008ab:	44 89 e0             	mov    %r12d,%eax
  8008ae:	83 e0 01             	and    $0x1,%eax
  8008b1:	c1 e0 06             	shl    $0x6,%eax
  8008b4:	09 c2                	or     %eax,%edx
  8008b6:	41 89 d4             	mov    %edx,%r12d
  8008b9:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8008c0:	00 00 00 
  8008c3:	8b 00                	mov    (%rax),%eax
  8008c5:	44 89 e2             	mov    %r12d,%edx
  8008c8:	09 c2                	or     %eax,%edx
  8008ca:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8008d1:	00 00 00 
  8008d4:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  8008d6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008da:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008de:	48 89 d6             	mov    %rdx,%rsi
  8008e1:	89 df                	mov    %ebx,%edi
  8008e3:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  8008e5:	83 fb 6d             	cmp    $0x6d,%ebx
  8008e8:	75 1b                	jne    800905 <vprintfmt+0x232>
					fmt ++;
  8008ea:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  8008ef:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  8008f0:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8008f7:	00 00 00 
  8008fa:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800900:	e9 cb 04 00 00       	jmpq   800dd0 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800905:	e9 83 fe ff ff       	jmpq   80078d <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  80090a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80090e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800915:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80091c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800923:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80092a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80092e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800932:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800936:	0f b6 00             	movzbl (%rax),%eax
  800939:	0f b6 d8             	movzbl %al,%ebx
  80093c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80093f:	83 f8 55             	cmp    $0x55,%eax
  800942:	0f 87 5a 04 00 00    	ja     800da2 <vprintfmt+0x6cf>
  800948:	89 c0                	mov    %eax,%eax
  80094a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800951:	00 
  800952:	48 b8 90 3e 80 00 00 	movabs $0x803e90,%rax
  800959:	00 00 00 
  80095c:	48 01 d0             	add    %rdx,%rax
  80095f:	48 8b 00             	mov    (%rax),%rax
  800962:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800964:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800968:	eb c0                	jmp    80092a <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80096a:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80096e:	eb ba                	jmp    80092a <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800970:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800977:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80097a:	89 d0                	mov    %edx,%eax
  80097c:	c1 e0 02             	shl    $0x2,%eax
  80097f:	01 d0                	add    %edx,%eax
  800981:	01 c0                	add    %eax,%eax
  800983:	01 d8                	add    %ebx,%eax
  800985:	83 e8 30             	sub    $0x30,%eax
  800988:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80098b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80098f:	0f b6 00             	movzbl (%rax),%eax
  800992:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800995:	83 fb 2f             	cmp    $0x2f,%ebx
  800998:	7e 0c                	jle    8009a6 <vprintfmt+0x2d3>
  80099a:	83 fb 39             	cmp    $0x39,%ebx
  80099d:	7f 07                	jg     8009a6 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099f:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009a4:	eb d1                	jmp    800977 <vprintfmt+0x2a4>
			goto process_precision;
  8009a6:	eb 58                	jmp    800a00 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  8009a8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ab:	83 f8 30             	cmp    $0x30,%eax
  8009ae:	73 17                	jae    8009c7 <vprintfmt+0x2f4>
  8009b0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009b4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b7:	89 c0                	mov    %eax,%eax
  8009b9:	48 01 d0             	add    %rdx,%rax
  8009bc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009bf:	83 c2 08             	add    $0x8,%edx
  8009c2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009c5:	eb 0f                	jmp    8009d6 <vprintfmt+0x303>
  8009c7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009cb:	48 89 d0             	mov    %rdx,%rax
  8009ce:	48 83 c2 08          	add    $0x8,%rdx
  8009d2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009d6:	8b 00                	mov    (%rax),%eax
  8009d8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009db:	eb 23                	jmp    800a00 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  8009dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009e1:	79 0c                	jns    8009ef <vprintfmt+0x31c>
				width = 0;
  8009e3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009ea:	e9 3b ff ff ff       	jmpq   80092a <vprintfmt+0x257>
  8009ef:	e9 36 ff ff ff       	jmpq   80092a <vprintfmt+0x257>

		case '#':
			altflag = 1;
  8009f4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009fb:	e9 2a ff ff ff       	jmpq   80092a <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800a00:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a04:	79 12                	jns    800a18 <vprintfmt+0x345>
				width = precision, precision = -1;
  800a06:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a09:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a0c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a13:	e9 12 ff ff ff       	jmpq   80092a <vprintfmt+0x257>
  800a18:	e9 0d ff ff ff       	jmpq   80092a <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a21:	e9 04 ff ff ff       	jmpq   80092a <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a26:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a29:	83 f8 30             	cmp    $0x30,%eax
  800a2c:	73 17                	jae    800a45 <vprintfmt+0x372>
  800a2e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a32:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a35:	89 c0                	mov    %eax,%eax
  800a37:	48 01 d0             	add    %rdx,%rax
  800a3a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a3d:	83 c2 08             	add    $0x8,%edx
  800a40:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a43:	eb 0f                	jmp    800a54 <vprintfmt+0x381>
  800a45:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a49:	48 89 d0             	mov    %rdx,%rax
  800a4c:	48 83 c2 08          	add    $0x8,%rdx
  800a50:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a54:	8b 10                	mov    (%rax),%edx
  800a56:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5e:	48 89 ce             	mov    %rcx,%rsi
  800a61:	89 d7                	mov    %edx,%edi
  800a63:	ff d0                	callq  *%rax
			break;
  800a65:	e9 66 03 00 00       	jmpq   800dd0 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800a6a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6d:	83 f8 30             	cmp    $0x30,%eax
  800a70:	73 17                	jae    800a89 <vprintfmt+0x3b6>
  800a72:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a76:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a79:	89 c0                	mov    %eax,%eax
  800a7b:	48 01 d0             	add    %rdx,%rax
  800a7e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a81:	83 c2 08             	add    $0x8,%edx
  800a84:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a87:	eb 0f                	jmp    800a98 <vprintfmt+0x3c5>
  800a89:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a8d:	48 89 d0             	mov    %rdx,%rax
  800a90:	48 83 c2 08          	add    $0x8,%rdx
  800a94:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a98:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a9a:	85 db                	test   %ebx,%ebx
  800a9c:	79 02                	jns    800aa0 <vprintfmt+0x3cd>
				err = -err;
  800a9e:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800aa0:	83 fb 10             	cmp    $0x10,%ebx
  800aa3:	7f 16                	jg     800abb <vprintfmt+0x3e8>
  800aa5:	48 b8 e0 3d 80 00 00 	movabs $0x803de0,%rax
  800aac:	00 00 00 
  800aaf:	48 63 d3             	movslq %ebx,%rdx
  800ab2:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ab6:	4d 85 e4             	test   %r12,%r12
  800ab9:	75 2e                	jne    800ae9 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800abb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800abf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac3:	89 d9                	mov    %ebx,%ecx
  800ac5:	48 ba 79 3e 80 00 00 	movabs $0x803e79,%rdx
  800acc:	00 00 00 
  800acf:	48 89 c7             	mov    %rax,%rdi
  800ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad7:	49 b8 de 0d 80 00 00 	movabs $0x800dde,%r8
  800ade:	00 00 00 
  800ae1:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ae4:	e9 e7 02 00 00       	jmpq   800dd0 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af1:	4c 89 e1             	mov    %r12,%rcx
  800af4:	48 ba 82 3e 80 00 00 	movabs $0x803e82,%rdx
  800afb:	00 00 00 
  800afe:	48 89 c7             	mov    %rax,%rdi
  800b01:	b8 00 00 00 00       	mov    $0x0,%eax
  800b06:	49 b8 de 0d 80 00 00 	movabs $0x800dde,%r8
  800b0d:	00 00 00 
  800b10:	41 ff d0             	callq  *%r8
			break;
  800b13:	e9 b8 02 00 00       	jmpq   800dd0 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1b:	83 f8 30             	cmp    $0x30,%eax
  800b1e:	73 17                	jae    800b37 <vprintfmt+0x464>
  800b20:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b24:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b27:	89 c0                	mov    %eax,%eax
  800b29:	48 01 d0             	add    %rdx,%rax
  800b2c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b2f:	83 c2 08             	add    $0x8,%edx
  800b32:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b35:	eb 0f                	jmp    800b46 <vprintfmt+0x473>
  800b37:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b3b:	48 89 d0             	mov    %rdx,%rax
  800b3e:	48 83 c2 08          	add    $0x8,%rdx
  800b42:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b46:	4c 8b 20             	mov    (%rax),%r12
  800b49:	4d 85 e4             	test   %r12,%r12
  800b4c:	75 0a                	jne    800b58 <vprintfmt+0x485>
				p = "(null)";
  800b4e:	49 bc 85 3e 80 00 00 	movabs $0x803e85,%r12
  800b55:	00 00 00 
			if (width > 0 && padc != '-')
  800b58:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b5c:	7e 3f                	jle    800b9d <vprintfmt+0x4ca>
  800b5e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b62:	74 39                	je     800b9d <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b64:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b67:	48 98                	cltq   
  800b69:	48 89 c6             	mov    %rax,%rsi
  800b6c:	4c 89 e7             	mov    %r12,%rdi
  800b6f:	48 b8 8a 10 80 00 00 	movabs $0x80108a,%rax
  800b76:	00 00 00 
  800b79:	ff d0                	callq  *%rax
  800b7b:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b7e:	eb 17                	jmp    800b97 <vprintfmt+0x4c4>
					putch(padc, putdat);
  800b80:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b84:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8c:	48 89 ce             	mov    %rcx,%rsi
  800b8f:	89 d7                	mov    %edx,%edi
  800b91:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b93:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b97:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b9b:	7f e3                	jg     800b80 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9d:	eb 37                	jmp    800bd6 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800b9f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ba3:	74 1e                	je     800bc3 <vprintfmt+0x4f0>
  800ba5:	83 fb 1f             	cmp    $0x1f,%ebx
  800ba8:	7e 05                	jle    800baf <vprintfmt+0x4dc>
  800baa:	83 fb 7e             	cmp    $0x7e,%ebx
  800bad:	7e 14                	jle    800bc3 <vprintfmt+0x4f0>
					putch('?', putdat);
  800baf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb7:	48 89 d6             	mov    %rdx,%rsi
  800bba:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bbf:	ff d0                	callq  *%rax
  800bc1:	eb 0f                	jmp    800bd2 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800bc3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bcb:	48 89 d6             	mov    %rdx,%rsi
  800bce:	89 df                	mov    %ebx,%edi
  800bd0:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bd2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bd6:	4c 89 e0             	mov    %r12,%rax
  800bd9:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bdd:	0f b6 00             	movzbl (%rax),%eax
  800be0:	0f be d8             	movsbl %al,%ebx
  800be3:	85 db                	test   %ebx,%ebx
  800be5:	74 10                	je     800bf7 <vprintfmt+0x524>
  800be7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800beb:	78 b2                	js     800b9f <vprintfmt+0x4cc>
  800bed:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bf1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bf5:	79 a8                	jns    800b9f <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf7:	eb 16                	jmp    800c0f <vprintfmt+0x53c>
				putch(' ', putdat);
  800bf9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bfd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c01:	48 89 d6             	mov    %rdx,%rsi
  800c04:	bf 20 00 00 00       	mov    $0x20,%edi
  800c09:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c0b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c0f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c13:	7f e4                	jg     800bf9 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800c15:	e9 b6 01 00 00       	jmpq   800dd0 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c1a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c1e:	be 03 00 00 00       	mov    $0x3,%esi
  800c23:	48 89 c7             	mov    %rax,%rdi
  800c26:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  800c2d:	00 00 00 
  800c30:	ff d0                	callq  *%rax
  800c32:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c3a:	48 85 c0             	test   %rax,%rax
  800c3d:	79 1d                	jns    800c5c <vprintfmt+0x589>
				putch('-', putdat);
  800c3f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c47:	48 89 d6             	mov    %rdx,%rsi
  800c4a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c4f:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c55:	48 f7 d8             	neg    %rax
  800c58:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c5c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c63:	e9 fb 00 00 00       	jmpq   800d63 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c68:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c6c:	be 03 00 00 00       	mov    $0x3,%esi
  800c71:	48 89 c7             	mov    %rax,%rdi
  800c74:	48 b8 b3 04 80 00 00 	movabs $0x8004b3,%rax
  800c7b:	00 00 00 
  800c7e:	ff d0                	callq  *%rax
  800c80:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c84:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c8b:	e9 d3 00 00 00       	jmpq   800d63 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800c90:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c94:	be 03 00 00 00       	mov    $0x3,%esi
  800c99:	48 89 c7             	mov    %rax,%rdi
  800c9c:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  800ca3:	00 00 00 
  800ca6:	ff d0                	callq  *%rax
  800ca8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800cac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb0:	48 85 c0             	test   %rax,%rax
  800cb3:	79 1d                	jns    800cd2 <vprintfmt+0x5ff>
				putch('-', putdat);
  800cb5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cbd:	48 89 d6             	mov    %rdx,%rsi
  800cc0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800cc5:	ff d0                	callq  *%rax
				num = -(long long) num;
  800cc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ccb:	48 f7 d8             	neg    %rax
  800cce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800cd2:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800cd9:	e9 85 00 00 00       	jmpq   800d63 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800cde:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce6:	48 89 d6             	mov    %rdx,%rsi
  800ce9:	bf 30 00 00 00       	mov    $0x30,%edi
  800cee:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cf0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf8:	48 89 d6             	mov    %rdx,%rsi
  800cfb:	bf 78 00 00 00       	mov    $0x78,%edi
  800d00:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d02:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d05:	83 f8 30             	cmp    $0x30,%eax
  800d08:	73 17                	jae    800d21 <vprintfmt+0x64e>
  800d0a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d0e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d11:	89 c0                	mov    %eax,%eax
  800d13:	48 01 d0             	add    %rdx,%rax
  800d16:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d19:	83 c2 08             	add    $0x8,%edx
  800d1c:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d1f:	eb 0f                	jmp    800d30 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800d21:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d25:	48 89 d0             	mov    %rdx,%rax
  800d28:	48 83 c2 08          	add    $0x8,%rdx
  800d2c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d30:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d33:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d37:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d3e:	eb 23                	jmp    800d63 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d40:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d44:	be 03 00 00 00       	mov    $0x3,%esi
  800d49:	48 89 c7             	mov    %rax,%rdi
  800d4c:	48 b8 b3 04 80 00 00 	movabs $0x8004b3,%rax
  800d53:	00 00 00 
  800d56:	ff d0                	callq  *%rax
  800d58:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d5c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d63:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d68:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d6b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d6e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d72:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d76:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d7a:	45 89 c1             	mov    %r8d,%r9d
  800d7d:	41 89 f8             	mov    %edi,%r8d
  800d80:	48 89 c7             	mov    %rax,%rdi
  800d83:	48 b8 f8 03 80 00 00 	movabs $0x8003f8,%rax
  800d8a:	00 00 00 
  800d8d:	ff d0                	callq  *%rax
			break;
  800d8f:	eb 3f                	jmp    800dd0 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d91:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d99:	48 89 d6             	mov    %rdx,%rsi
  800d9c:	89 df                	mov    %ebx,%edi
  800d9e:	ff d0                	callq  *%rax
			break;
  800da0:	eb 2e                	jmp    800dd0 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800da2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800da6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800daa:	48 89 d6             	mov    %rdx,%rsi
  800dad:	bf 25 00 00 00       	mov    $0x25,%edi
  800db2:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800db4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800db9:	eb 05                	jmp    800dc0 <vprintfmt+0x6ed>
  800dbb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dc0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dc4:	48 83 e8 01          	sub    $0x1,%rax
  800dc8:	0f b6 00             	movzbl (%rax),%eax
  800dcb:	3c 25                	cmp    $0x25,%al
  800dcd:	75 ec                	jne    800dbb <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  800dcf:	90                   	nop
		}
	}
  800dd0:	e9 37 f9 ff ff       	jmpq   80070c <vprintfmt+0x39>
    va_end(aq);
}
  800dd5:	48 83 c4 60          	add    $0x60,%rsp
  800dd9:	5b                   	pop    %rbx
  800dda:	41 5c                	pop    %r12
  800ddc:	5d                   	pop    %rbp
  800ddd:	c3                   	retq   

0000000000800dde <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dde:	55                   	push   %rbp
  800ddf:	48 89 e5             	mov    %rsp,%rbp
  800de2:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800de9:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800df0:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800df7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dfe:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e05:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e0c:	84 c0                	test   %al,%al
  800e0e:	74 20                	je     800e30 <printfmt+0x52>
  800e10:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e14:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e18:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e1c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e20:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e24:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e28:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e2c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e30:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e37:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e3e:	00 00 00 
  800e41:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e48:	00 00 00 
  800e4b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e4f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e56:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e5d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e64:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e6b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e72:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e79:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e80:	48 89 c7             	mov    %rax,%rdi
  800e83:	48 b8 d3 06 80 00 00 	movabs $0x8006d3,%rax
  800e8a:	00 00 00 
  800e8d:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e8f:	c9                   	leaveq 
  800e90:	c3                   	retq   

0000000000800e91 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e91:	55                   	push   %rbp
  800e92:	48 89 e5             	mov    %rsp,%rbp
  800e95:	48 83 ec 10          	sub    $0x10,%rsp
  800e99:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e9c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ea0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea4:	8b 40 10             	mov    0x10(%rax),%eax
  800ea7:	8d 50 01             	lea    0x1(%rax),%edx
  800eaa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eae:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800eb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb5:	48 8b 10             	mov    (%rax),%rdx
  800eb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ebc:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ec0:	48 39 c2             	cmp    %rax,%rdx
  800ec3:	73 17                	jae    800edc <sprintputch+0x4b>
		*b->buf++ = ch;
  800ec5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ec9:	48 8b 00             	mov    (%rax),%rax
  800ecc:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ed0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ed4:	48 89 0a             	mov    %rcx,(%rdx)
  800ed7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800eda:	88 10                	mov    %dl,(%rax)
}
  800edc:	c9                   	leaveq 
  800edd:	c3                   	retq   

0000000000800ede <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ede:	55                   	push   %rbp
  800edf:	48 89 e5             	mov    %rsp,%rbp
  800ee2:	48 83 ec 50          	sub    $0x50,%rsp
  800ee6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800eea:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800eed:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ef1:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ef5:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ef9:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800efd:	48 8b 0a             	mov    (%rdx),%rcx
  800f00:	48 89 08             	mov    %rcx,(%rax)
  800f03:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f07:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f0b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f0f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f13:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f17:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f1b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f1e:	48 98                	cltq   
  800f20:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f24:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f28:	48 01 d0             	add    %rdx,%rax
  800f2b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f36:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f3b:	74 06                	je     800f43 <vsnprintf+0x65>
  800f3d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f41:	7f 07                	jg     800f4a <vsnprintf+0x6c>
		return -E_INVAL;
  800f43:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f48:	eb 2f                	jmp    800f79 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f4a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f4e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f52:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f56:	48 89 c6             	mov    %rax,%rsi
  800f59:	48 bf 91 0e 80 00 00 	movabs $0x800e91,%rdi
  800f60:	00 00 00 
  800f63:	48 b8 d3 06 80 00 00 	movabs $0x8006d3,%rax
  800f6a:	00 00 00 
  800f6d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f6f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f73:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f76:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f79:	c9                   	leaveq 
  800f7a:	c3                   	retq   

0000000000800f7b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f7b:	55                   	push   %rbp
  800f7c:	48 89 e5             	mov    %rsp,%rbp
  800f7f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f86:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f8d:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f93:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f9a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fa1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fa8:	84 c0                	test   %al,%al
  800faa:	74 20                	je     800fcc <snprintf+0x51>
  800fac:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fb0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fb4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fb8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fbc:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fc0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fc4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fc8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fcc:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fd3:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fda:	00 00 00 
  800fdd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fe4:	00 00 00 
  800fe7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800feb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ff2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ff9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801000:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801007:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80100e:	48 8b 0a             	mov    (%rdx),%rcx
  801011:	48 89 08             	mov    %rcx,(%rax)
  801014:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801018:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80101c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801020:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801024:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80102b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801032:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801038:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80103f:	48 89 c7             	mov    %rax,%rdi
  801042:	48 b8 de 0e 80 00 00 	movabs $0x800ede,%rax
  801049:	00 00 00 
  80104c:	ff d0                	callq  *%rax
  80104e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801054:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80105a:	c9                   	leaveq 
  80105b:	c3                   	retq   

000000000080105c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80105c:	55                   	push   %rbp
  80105d:	48 89 e5             	mov    %rsp,%rbp
  801060:	48 83 ec 18          	sub    $0x18,%rsp
  801064:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801068:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80106f:	eb 09                	jmp    80107a <strlen+0x1e>
		n++;
  801071:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801075:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80107a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107e:	0f b6 00             	movzbl (%rax),%eax
  801081:	84 c0                	test   %al,%al
  801083:	75 ec                	jne    801071 <strlen+0x15>
		n++;
	return n;
  801085:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801088:	c9                   	leaveq 
  801089:	c3                   	retq   

000000000080108a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80108a:	55                   	push   %rbp
  80108b:	48 89 e5             	mov    %rsp,%rbp
  80108e:	48 83 ec 20          	sub    $0x20,%rsp
  801092:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801096:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80109a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010a1:	eb 0e                	jmp    8010b1 <strnlen+0x27>
		n++;
  8010a3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010a7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010ac:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010b1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010b6:	74 0b                	je     8010c3 <strnlen+0x39>
  8010b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bc:	0f b6 00             	movzbl (%rax),%eax
  8010bf:	84 c0                	test   %al,%al
  8010c1:	75 e0                	jne    8010a3 <strnlen+0x19>
		n++;
	return n;
  8010c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010c6:	c9                   	leaveq 
  8010c7:	c3                   	retq   

00000000008010c8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010c8:	55                   	push   %rbp
  8010c9:	48 89 e5             	mov    %rsp,%rbp
  8010cc:	48 83 ec 20          	sub    $0x20,%rsp
  8010d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010e0:	90                   	nop
  8010e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010e9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010ed:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010f1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010f5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010f9:	0f b6 12             	movzbl (%rdx),%edx
  8010fc:	88 10                	mov    %dl,(%rax)
  8010fe:	0f b6 00             	movzbl (%rax),%eax
  801101:	84 c0                	test   %al,%al
  801103:	75 dc                	jne    8010e1 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801105:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801109:	c9                   	leaveq 
  80110a:	c3                   	retq   

000000000080110b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80110b:	55                   	push   %rbp
  80110c:	48 89 e5             	mov    %rsp,%rbp
  80110f:	48 83 ec 20          	sub    $0x20,%rsp
  801113:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801117:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80111b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111f:	48 89 c7             	mov    %rax,%rdi
  801122:	48 b8 5c 10 80 00 00 	movabs $0x80105c,%rax
  801129:	00 00 00 
  80112c:	ff d0                	callq  *%rax
  80112e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801131:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801134:	48 63 d0             	movslq %eax,%rdx
  801137:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113b:	48 01 c2             	add    %rax,%rdx
  80113e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801142:	48 89 c6             	mov    %rax,%rsi
  801145:	48 89 d7             	mov    %rdx,%rdi
  801148:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  80114f:	00 00 00 
  801152:	ff d0                	callq  *%rax
	return dst;
  801154:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801158:	c9                   	leaveq 
  801159:	c3                   	retq   

000000000080115a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80115a:	55                   	push   %rbp
  80115b:	48 89 e5             	mov    %rsp,%rbp
  80115e:	48 83 ec 28          	sub    $0x28,%rsp
  801162:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801166:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80116a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80116e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801172:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801176:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80117d:	00 
  80117e:	eb 2a                	jmp    8011aa <strncpy+0x50>
		*dst++ = *src;
  801180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801184:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801188:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80118c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801190:	0f b6 12             	movzbl (%rdx),%edx
  801193:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801195:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801199:	0f b6 00             	movzbl (%rax),%eax
  80119c:	84 c0                	test   %al,%al
  80119e:	74 05                	je     8011a5 <strncpy+0x4b>
			src++;
  8011a0:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011a5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ae:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011b2:	72 cc                	jb     801180 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011b8:	c9                   	leaveq 
  8011b9:	c3                   	retq   

00000000008011ba <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011ba:	55                   	push   %rbp
  8011bb:	48 89 e5             	mov    %rsp,%rbp
  8011be:	48 83 ec 28          	sub    $0x28,%rsp
  8011c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011ca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011d6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011db:	74 3d                	je     80121a <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011dd:	eb 1d                	jmp    8011fc <strlcpy+0x42>
			*dst++ = *src++;
  8011df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011e7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011eb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011ef:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011f3:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011f7:	0f b6 12             	movzbl (%rdx),%edx
  8011fa:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011fc:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801201:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801206:	74 0b                	je     801213 <strlcpy+0x59>
  801208:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80120c:	0f b6 00             	movzbl (%rax),%eax
  80120f:	84 c0                	test   %al,%al
  801211:	75 cc                	jne    8011df <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801213:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801217:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80121a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80121e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801222:	48 29 c2             	sub    %rax,%rdx
  801225:	48 89 d0             	mov    %rdx,%rax
}
  801228:	c9                   	leaveq 
  801229:	c3                   	retq   

000000000080122a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80122a:	55                   	push   %rbp
  80122b:	48 89 e5             	mov    %rsp,%rbp
  80122e:	48 83 ec 10          	sub    $0x10,%rsp
  801232:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801236:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80123a:	eb 0a                	jmp    801246 <strcmp+0x1c>
		p++, q++;
  80123c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801241:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801246:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124a:	0f b6 00             	movzbl (%rax),%eax
  80124d:	84 c0                	test   %al,%al
  80124f:	74 12                	je     801263 <strcmp+0x39>
  801251:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801255:	0f b6 10             	movzbl (%rax),%edx
  801258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80125c:	0f b6 00             	movzbl (%rax),%eax
  80125f:	38 c2                	cmp    %al,%dl
  801261:	74 d9                	je     80123c <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801263:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801267:	0f b6 00             	movzbl (%rax),%eax
  80126a:	0f b6 d0             	movzbl %al,%edx
  80126d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801271:	0f b6 00             	movzbl (%rax),%eax
  801274:	0f b6 c0             	movzbl %al,%eax
  801277:	29 c2                	sub    %eax,%edx
  801279:	89 d0                	mov    %edx,%eax
}
  80127b:	c9                   	leaveq 
  80127c:	c3                   	retq   

000000000080127d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80127d:	55                   	push   %rbp
  80127e:	48 89 e5             	mov    %rsp,%rbp
  801281:	48 83 ec 18          	sub    $0x18,%rsp
  801285:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801289:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80128d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801291:	eb 0f                	jmp    8012a2 <strncmp+0x25>
		n--, p++, q++;
  801293:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801298:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80129d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012a2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012a7:	74 1d                	je     8012c6 <strncmp+0x49>
  8012a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ad:	0f b6 00             	movzbl (%rax),%eax
  8012b0:	84 c0                	test   %al,%al
  8012b2:	74 12                	je     8012c6 <strncmp+0x49>
  8012b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b8:	0f b6 10             	movzbl (%rax),%edx
  8012bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012bf:	0f b6 00             	movzbl (%rax),%eax
  8012c2:	38 c2                	cmp    %al,%dl
  8012c4:	74 cd                	je     801293 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012c6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012cb:	75 07                	jne    8012d4 <strncmp+0x57>
		return 0;
  8012cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d2:	eb 18                	jmp    8012ec <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d8:	0f b6 00             	movzbl (%rax),%eax
  8012db:	0f b6 d0             	movzbl %al,%edx
  8012de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e2:	0f b6 00             	movzbl (%rax),%eax
  8012e5:	0f b6 c0             	movzbl %al,%eax
  8012e8:	29 c2                	sub    %eax,%edx
  8012ea:	89 d0                	mov    %edx,%eax
}
  8012ec:	c9                   	leaveq 
  8012ed:	c3                   	retq   

00000000008012ee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012ee:	55                   	push   %rbp
  8012ef:	48 89 e5             	mov    %rsp,%rbp
  8012f2:	48 83 ec 0c          	sub    $0xc,%rsp
  8012f6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012fa:	89 f0                	mov    %esi,%eax
  8012fc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012ff:	eb 17                	jmp    801318 <strchr+0x2a>
		if (*s == c)
  801301:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801305:	0f b6 00             	movzbl (%rax),%eax
  801308:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80130b:	75 06                	jne    801313 <strchr+0x25>
			return (char *) s;
  80130d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801311:	eb 15                	jmp    801328 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801313:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801318:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131c:	0f b6 00             	movzbl (%rax),%eax
  80131f:	84 c0                	test   %al,%al
  801321:	75 de                	jne    801301 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801323:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801328:	c9                   	leaveq 
  801329:	c3                   	retq   

000000000080132a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80132a:	55                   	push   %rbp
  80132b:	48 89 e5             	mov    %rsp,%rbp
  80132e:	48 83 ec 0c          	sub    $0xc,%rsp
  801332:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801336:	89 f0                	mov    %esi,%eax
  801338:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80133b:	eb 13                	jmp    801350 <strfind+0x26>
		if (*s == c)
  80133d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801341:	0f b6 00             	movzbl (%rax),%eax
  801344:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801347:	75 02                	jne    80134b <strfind+0x21>
			break;
  801349:	eb 10                	jmp    80135b <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80134b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801350:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801354:	0f b6 00             	movzbl (%rax),%eax
  801357:	84 c0                	test   %al,%al
  801359:	75 e2                	jne    80133d <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80135b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80135f:	c9                   	leaveq 
  801360:	c3                   	retq   

0000000000801361 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801361:	55                   	push   %rbp
  801362:	48 89 e5             	mov    %rsp,%rbp
  801365:	48 83 ec 18          	sub    $0x18,%rsp
  801369:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80136d:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801370:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801374:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801379:	75 06                	jne    801381 <memset+0x20>
		return v;
  80137b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137f:	eb 69                	jmp    8013ea <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801381:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801385:	83 e0 03             	and    $0x3,%eax
  801388:	48 85 c0             	test   %rax,%rax
  80138b:	75 48                	jne    8013d5 <memset+0x74>
  80138d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801391:	83 e0 03             	and    $0x3,%eax
  801394:	48 85 c0             	test   %rax,%rax
  801397:	75 3c                	jne    8013d5 <memset+0x74>
		c &= 0xFF;
  801399:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013a3:	c1 e0 18             	shl    $0x18,%eax
  8013a6:	89 c2                	mov    %eax,%edx
  8013a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013ab:	c1 e0 10             	shl    $0x10,%eax
  8013ae:	09 c2                	or     %eax,%edx
  8013b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b3:	c1 e0 08             	shl    $0x8,%eax
  8013b6:	09 d0                	or     %edx,%eax
  8013b8:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8013bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bf:	48 c1 e8 02          	shr    $0x2,%rax
  8013c3:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013c6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013cd:	48 89 d7             	mov    %rdx,%rdi
  8013d0:	fc                   	cld    
  8013d1:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013d3:	eb 11                	jmp    8013e6 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013dc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013e0:	48 89 d7             	mov    %rdx,%rdi
  8013e3:	fc                   	cld    
  8013e4:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8013e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013ea:	c9                   	leaveq 
  8013eb:	c3                   	retq   

00000000008013ec <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013ec:	55                   	push   %rbp
  8013ed:	48 89 e5             	mov    %rsp,%rbp
  8013f0:	48 83 ec 28          	sub    $0x28,%rsp
  8013f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013fc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801400:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801404:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801408:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801410:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801414:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801418:	0f 83 88 00 00 00    	jae    8014a6 <memmove+0xba>
  80141e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801422:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801426:	48 01 d0             	add    %rdx,%rax
  801429:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80142d:	76 77                	jbe    8014a6 <memmove+0xba>
		s += n;
  80142f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801433:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801437:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80143f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801443:	83 e0 03             	and    $0x3,%eax
  801446:	48 85 c0             	test   %rax,%rax
  801449:	75 3b                	jne    801486 <memmove+0x9a>
  80144b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80144f:	83 e0 03             	and    $0x3,%eax
  801452:	48 85 c0             	test   %rax,%rax
  801455:	75 2f                	jne    801486 <memmove+0x9a>
  801457:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145b:	83 e0 03             	and    $0x3,%eax
  80145e:	48 85 c0             	test   %rax,%rax
  801461:	75 23                	jne    801486 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801463:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801467:	48 83 e8 04          	sub    $0x4,%rax
  80146b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80146f:	48 83 ea 04          	sub    $0x4,%rdx
  801473:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801477:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80147b:	48 89 c7             	mov    %rax,%rdi
  80147e:	48 89 d6             	mov    %rdx,%rsi
  801481:	fd                   	std    
  801482:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801484:	eb 1d                	jmp    8014a3 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801486:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80148e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801492:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801496:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149a:	48 89 d7             	mov    %rdx,%rdi
  80149d:	48 89 c1             	mov    %rax,%rcx
  8014a0:	fd                   	std    
  8014a1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014a3:	fc                   	cld    
  8014a4:	eb 57                	jmp    8014fd <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014aa:	83 e0 03             	and    $0x3,%eax
  8014ad:	48 85 c0             	test   %rax,%rax
  8014b0:	75 36                	jne    8014e8 <memmove+0xfc>
  8014b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b6:	83 e0 03             	and    $0x3,%eax
  8014b9:	48 85 c0             	test   %rax,%rax
  8014bc:	75 2a                	jne    8014e8 <memmove+0xfc>
  8014be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c2:	83 e0 03             	and    $0x3,%eax
  8014c5:	48 85 c0             	test   %rax,%rax
  8014c8:	75 1e                	jne    8014e8 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ce:	48 c1 e8 02          	shr    $0x2,%rax
  8014d2:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014dd:	48 89 c7             	mov    %rax,%rdi
  8014e0:	48 89 d6             	mov    %rdx,%rsi
  8014e3:	fc                   	cld    
  8014e4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014e6:	eb 15                	jmp    8014fd <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014f0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014f4:	48 89 c7             	mov    %rax,%rdi
  8014f7:	48 89 d6             	mov    %rdx,%rsi
  8014fa:	fc                   	cld    
  8014fb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801501:	c9                   	leaveq 
  801502:	c3                   	retq   

0000000000801503 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801503:	55                   	push   %rbp
  801504:	48 89 e5             	mov    %rsp,%rbp
  801507:	48 83 ec 18          	sub    $0x18,%rsp
  80150b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80150f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801513:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801517:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80151b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80151f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801523:	48 89 ce             	mov    %rcx,%rsi
  801526:	48 89 c7             	mov    %rax,%rdi
  801529:	48 b8 ec 13 80 00 00 	movabs $0x8013ec,%rax
  801530:	00 00 00 
  801533:	ff d0                	callq  *%rax
}
  801535:	c9                   	leaveq 
  801536:	c3                   	retq   

0000000000801537 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801537:	55                   	push   %rbp
  801538:	48 89 e5             	mov    %rsp,%rbp
  80153b:	48 83 ec 28          	sub    $0x28,%rsp
  80153f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801543:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801547:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80154b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80154f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801553:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801557:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80155b:	eb 36                	jmp    801593 <memcmp+0x5c>
		if (*s1 != *s2)
  80155d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801561:	0f b6 10             	movzbl (%rax),%edx
  801564:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801568:	0f b6 00             	movzbl (%rax),%eax
  80156b:	38 c2                	cmp    %al,%dl
  80156d:	74 1a                	je     801589 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80156f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801573:	0f b6 00             	movzbl (%rax),%eax
  801576:	0f b6 d0             	movzbl %al,%edx
  801579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157d:	0f b6 00             	movzbl (%rax),%eax
  801580:	0f b6 c0             	movzbl %al,%eax
  801583:	29 c2                	sub    %eax,%edx
  801585:	89 d0                	mov    %edx,%eax
  801587:	eb 20                	jmp    8015a9 <memcmp+0x72>
		s1++, s2++;
  801589:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80158e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801593:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801597:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80159b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80159f:	48 85 c0             	test   %rax,%rax
  8015a2:	75 b9                	jne    80155d <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a9:	c9                   	leaveq 
  8015aa:	c3                   	retq   

00000000008015ab <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015ab:	55                   	push   %rbp
  8015ac:	48 89 e5             	mov    %rsp,%rbp
  8015af:	48 83 ec 28          	sub    $0x28,%rsp
  8015b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015b7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015c6:	48 01 d0             	add    %rdx,%rax
  8015c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015cd:	eb 15                	jmp    8015e4 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d3:	0f b6 10             	movzbl (%rax),%edx
  8015d6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015d9:	38 c2                	cmp    %al,%dl
  8015db:	75 02                	jne    8015df <memfind+0x34>
			break;
  8015dd:	eb 0f                	jmp    8015ee <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015df:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e8:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015ec:	72 e1                	jb     8015cf <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015f2:	c9                   	leaveq 
  8015f3:	c3                   	retq   

00000000008015f4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015f4:	55                   	push   %rbp
  8015f5:	48 89 e5             	mov    %rsp,%rbp
  8015f8:	48 83 ec 34          	sub    $0x34,%rsp
  8015fc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801600:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801604:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801607:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80160e:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801615:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801616:	eb 05                	jmp    80161d <strtol+0x29>
		s++;
  801618:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80161d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801621:	0f b6 00             	movzbl (%rax),%eax
  801624:	3c 20                	cmp    $0x20,%al
  801626:	74 f0                	je     801618 <strtol+0x24>
  801628:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162c:	0f b6 00             	movzbl (%rax),%eax
  80162f:	3c 09                	cmp    $0x9,%al
  801631:	74 e5                	je     801618 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801633:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801637:	0f b6 00             	movzbl (%rax),%eax
  80163a:	3c 2b                	cmp    $0x2b,%al
  80163c:	75 07                	jne    801645 <strtol+0x51>
		s++;
  80163e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801643:	eb 17                	jmp    80165c <strtol+0x68>
	else if (*s == '-')
  801645:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801649:	0f b6 00             	movzbl (%rax),%eax
  80164c:	3c 2d                	cmp    $0x2d,%al
  80164e:	75 0c                	jne    80165c <strtol+0x68>
		s++, neg = 1;
  801650:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801655:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80165c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801660:	74 06                	je     801668 <strtol+0x74>
  801662:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801666:	75 28                	jne    801690 <strtol+0x9c>
  801668:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166c:	0f b6 00             	movzbl (%rax),%eax
  80166f:	3c 30                	cmp    $0x30,%al
  801671:	75 1d                	jne    801690 <strtol+0x9c>
  801673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801677:	48 83 c0 01          	add    $0x1,%rax
  80167b:	0f b6 00             	movzbl (%rax),%eax
  80167e:	3c 78                	cmp    $0x78,%al
  801680:	75 0e                	jne    801690 <strtol+0x9c>
		s += 2, base = 16;
  801682:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801687:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80168e:	eb 2c                	jmp    8016bc <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801690:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801694:	75 19                	jne    8016af <strtol+0xbb>
  801696:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169a:	0f b6 00             	movzbl (%rax),%eax
  80169d:	3c 30                	cmp    $0x30,%al
  80169f:	75 0e                	jne    8016af <strtol+0xbb>
		s++, base = 8;
  8016a1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016a6:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016ad:	eb 0d                	jmp    8016bc <strtol+0xc8>
	else if (base == 0)
  8016af:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016b3:	75 07                	jne    8016bc <strtol+0xc8>
		base = 10;
  8016b5:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c0:	0f b6 00             	movzbl (%rax),%eax
  8016c3:	3c 2f                	cmp    $0x2f,%al
  8016c5:	7e 1d                	jle    8016e4 <strtol+0xf0>
  8016c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cb:	0f b6 00             	movzbl (%rax),%eax
  8016ce:	3c 39                	cmp    $0x39,%al
  8016d0:	7f 12                	jg     8016e4 <strtol+0xf0>
			dig = *s - '0';
  8016d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d6:	0f b6 00             	movzbl (%rax),%eax
  8016d9:	0f be c0             	movsbl %al,%eax
  8016dc:	83 e8 30             	sub    $0x30,%eax
  8016df:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016e2:	eb 4e                	jmp    801732 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e8:	0f b6 00             	movzbl (%rax),%eax
  8016eb:	3c 60                	cmp    $0x60,%al
  8016ed:	7e 1d                	jle    80170c <strtol+0x118>
  8016ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f3:	0f b6 00             	movzbl (%rax),%eax
  8016f6:	3c 7a                	cmp    $0x7a,%al
  8016f8:	7f 12                	jg     80170c <strtol+0x118>
			dig = *s - 'a' + 10;
  8016fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fe:	0f b6 00             	movzbl (%rax),%eax
  801701:	0f be c0             	movsbl %al,%eax
  801704:	83 e8 57             	sub    $0x57,%eax
  801707:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80170a:	eb 26                	jmp    801732 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80170c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801710:	0f b6 00             	movzbl (%rax),%eax
  801713:	3c 40                	cmp    $0x40,%al
  801715:	7e 48                	jle    80175f <strtol+0x16b>
  801717:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171b:	0f b6 00             	movzbl (%rax),%eax
  80171e:	3c 5a                	cmp    $0x5a,%al
  801720:	7f 3d                	jg     80175f <strtol+0x16b>
			dig = *s - 'A' + 10;
  801722:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801726:	0f b6 00             	movzbl (%rax),%eax
  801729:	0f be c0             	movsbl %al,%eax
  80172c:	83 e8 37             	sub    $0x37,%eax
  80172f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801732:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801735:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801738:	7c 02                	jl     80173c <strtol+0x148>
			break;
  80173a:	eb 23                	jmp    80175f <strtol+0x16b>
		s++, val = (val * base) + dig;
  80173c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801741:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801744:	48 98                	cltq   
  801746:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80174b:	48 89 c2             	mov    %rax,%rdx
  80174e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801751:	48 98                	cltq   
  801753:	48 01 d0             	add    %rdx,%rax
  801756:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80175a:	e9 5d ff ff ff       	jmpq   8016bc <strtol+0xc8>

	if (endptr)
  80175f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801764:	74 0b                	je     801771 <strtol+0x17d>
		*endptr = (char *) s;
  801766:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80176a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80176e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801771:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801775:	74 09                	je     801780 <strtol+0x18c>
  801777:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177b:	48 f7 d8             	neg    %rax
  80177e:	eb 04                	jmp    801784 <strtol+0x190>
  801780:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801784:	c9                   	leaveq 
  801785:	c3                   	retq   

0000000000801786 <strstr>:

char * strstr(const char *in, const char *str)
{
  801786:	55                   	push   %rbp
  801787:	48 89 e5             	mov    %rsp,%rbp
  80178a:	48 83 ec 30          	sub    $0x30,%rsp
  80178e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801792:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801796:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80179a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80179e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017a2:	0f b6 00             	movzbl (%rax),%eax
  8017a5:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8017a8:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017ac:	75 06                	jne    8017b4 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8017ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b2:	eb 6b                	jmp    80181f <strstr+0x99>

    len = strlen(str);
  8017b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b8:	48 89 c7             	mov    %rax,%rdi
  8017bb:	48 b8 5c 10 80 00 00 	movabs $0x80105c,%rax
  8017c2:	00 00 00 
  8017c5:	ff d0                	callq  *%rax
  8017c7:	48 98                	cltq   
  8017c9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8017cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017d5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017d9:	0f b6 00             	movzbl (%rax),%eax
  8017dc:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8017df:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017e3:	75 07                	jne    8017ec <strstr+0x66>
                return (char *) 0;
  8017e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ea:	eb 33                	jmp    80181f <strstr+0x99>
        } while (sc != c);
  8017ec:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017f0:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017f3:	75 d8                	jne    8017cd <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  8017f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017f9:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801801:	48 89 ce             	mov    %rcx,%rsi
  801804:	48 89 c7             	mov    %rax,%rdi
  801807:	48 b8 7d 12 80 00 00 	movabs $0x80127d,%rax
  80180e:	00 00 00 
  801811:	ff d0                	callq  *%rax
  801813:	85 c0                	test   %eax,%eax
  801815:	75 b6                	jne    8017cd <strstr+0x47>

    return (char *) (in - 1);
  801817:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181b:	48 83 e8 01          	sub    $0x1,%rax
}
  80181f:	c9                   	leaveq 
  801820:	c3                   	retq   

0000000000801821 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801821:	55                   	push   %rbp
  801822:	48 89 e5             	mov    %rsp,%rbp
  801825:	53                   	push   %rbx
  801826:	48 83 ec 48          	sub    $0x48,%rsp
  80182a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80182d:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801830:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801834:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801838:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80183c:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801840:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801843:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801847:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80184b:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80184f:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801853:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801857:	4c 89 c3             	mov    %r8,%rbx
  80185a:	cd 30                	int    $0x30
  80185c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801860:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801864:	74 3e                	je     8018a4 <syscall+0x83>
  801866:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80186b:	7e 37                	jle    8018a4 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80186d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801871:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801874:	49 89 d0             	mov    %rdx,%r8
  801877:	89 c1                	mov    %eax,%ecx
  801879:	48 ba 40 41 80 00 00 	movabs $0x804140,%rdx
  801880:	00 00 00 
  801883:	be 23 00 00 00       	mov    $0x23,%esi
  801888:	48 bf 5d 41 80 00 00 	movabs $0x80415d,%rdi
  80188f:	00 00 00 
  801892:	b8 00 00 00 00       	mov    $0x0,%eax
  801897:	49 b9 63 37 80 00 00 	movabs $0x803763,%r9
  80189e:	00 00 00 
  8018a1:	41 ff d1             	callq  *%r9

	return ret;
  8018a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018a8:	48 83 c4 48          	add    $0x48,%rsp
  8018ac:	5b                   	pop    %rbx
  8018ad:	5d                   	pop    %rbp
  8018ae:	c3                   	retq   

00000000008018af <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018af:	55                   	push   %rbp
  8018b0:	48 89 e5             	mov    %rsp,%rbp
  8018b3:	48 83 ec 20          	sub    $0x20,%rsp
  8018b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018c7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ce:	00 
  8018cf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018db:	48 89 d1             	mov    %rdx,%rcx
  8018de:	48 89 c2             	mov    %rax,%rdx
  8018e1:	be 00 00 00 00       	mov    $0x0,%esi
  8018e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8018eb:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  8018f2:	00 00 00 
  8018f5:	ff d0                	callq  *%rax
}
  8018f7:	c9                   	leaveq 
  8018f8:	c3                   	retq   

00000000008018f9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018f9:	55                   	push   %rbp
  8018fa:	48 89 e5             	mov    %rsp,%rbp
  8018fd:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801901:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801908:	00 
  801909:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80190f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801915:	b9 00 00 00 00       	mov    $0x0,%ecx
  80191a:	ba 00 00 00 00       	mov    $0x0,%edx
  80191f:	be 00 00 00 00       	mov    $0x0,%esi
  801924:	bf 01 00 00 00       	mov    $0x1,%edi
  801929:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  801930:	00 00 00 
  801933:	ff d0                	callq  *%rax
}
  801935:	c9                   	leaveq 
  801936:	c3                   	retq   

0000000000801937 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801937:	55                   	push   %rbp
  801938:	48 89 e5             	mov    %rsp,%rbp
  80193b:	48 83 ec 10          	sub    $0x10,%rsp
  80193f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801942:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801945:	48 98                	cltq   
  801947:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80194e:	00 
  80194f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801955:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80195b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801960:	48 89 c2             	mov    %rax,%rdx
  801963:	be 01 00 00 00       	mov    $0x1,%esi
  801968:	bf 03 00 00 00       	mov    $0x3,%edi
  80196d:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  801974:	00 00 00 
  801977:	ff d0                	callq  *%rax
}
  801979:	c9                   	leaveq 
  80197a:	c3                   	retq   

000000000080197b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80197b:	55                   	push   %rbp
  80197c:	48 89 e5             	mov    %rsp,%rbp
  80197f:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801983:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80198a:	00 
  80198b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801991:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801997:	b9 00 00 00 00       	mov    $0x0,%ecx
  80199c:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a1:	be 00 00 00 00       	mov    $0x0,%esi
  8019a6:	bf 02 00 00 00       	mov    $0x2,%edi
  8019ab:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  8019b2:	00 00 00 
  8019b5:	ff d0                	callq  *%rax
}
  8019b7:	c9                   	leaveq 
  8019b8:	c3                   	retq   

00000000008019b9 <sys_yield>:

void
sys_yield(void)
{
  8019b9:	55                   	push   %rbp
  8019ba:	48 89 e5             	mov    %rsp,%rbp
  8019bd:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019c1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c8:	00 
  8019c9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019da:	ba 00 00 00 00       	mov    $0x0,%edx
  8019df:	be 00 00 00 00       	mov    $0x0,%esi
  8019e4:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019e9:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  8019f0:	00 00 00 
  8019f3:	ff d0                	callq  *%rax
}
  8019f5:	c9                   	leaveq 
  8019f6:	c3                   	retq   

00000000008019f7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019f7:	55                   	push   %rbp
  8019f8:	48 89 e5             	mov    %rsp,%rbp
  8019fb:	48 83 ec 20          	sub    $0x20,%rsp
  8019ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a02:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a06:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a09:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a0c:	48 63 c8             	movslq %eax,%rcx
  801a0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a16:	48 98                	cltq   
  801a18:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1f:	00 
  801a20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a26:	49 89 c8             	mov    %rcx,%r8
  801a29:	48 89 d1             	mov    %rdx,%rcx
  801a2c:	48 89 c2             	mov    %rax,%rdx
  801a2f:	be 01 00 00 00       	mov    $0x1,%esi
  801a34:	bf 04 00 00 00       	mov    $0x4,%edi
  801a39:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  801a40:	00 00 00 
  801a43:	ff d0                	callq  *%rax
}
  801a45:	c9                   	leaveq 
  801a46:	c3                   	retq   

0000000000801a47 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a47:	55                   	push   %rbp
  801a48:	48 89 e5             	mov    %rsp,%rbp
  801a4b:	48 83 ec 30          	sub    $0x30,%rsp
  801a4f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a56:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a59:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a5d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a61:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a64:	48 63 c8             	movslq %eax,%rcx
  801a67:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a6b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a6e:	48 63 f0             	movslq %eax,%rsi
  801a71:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a78:	48 98                	cltq   
  801a7a:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a7e:	49 89 f9             	mov    %rdi,%r9
  801a81:	49 89 f0             	mov    %rsi,%r8
  801a84:	48 89 d1             	mov    %rdx,%rcx
  801a87:	48 89 c2             	mov    %rax,%rdx
  801a8a:	be 01 00 00 00       	mov    $0x1,%esi
  801a8f:	bf 05 00 00 00       	mov    $0x5,%edi
  801a94:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  801a9b:	00 00 00 
  801a9e:	ff d0                	callq  *%rax
}
  801aa0:	c9                   	leaveq 
  801aa1:	c3                   	retq   

0000000000801aa2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801aa2:	55                   	push   %rbp
  801aa3:	48 89 e5             	mov    %rsp,%rbp
  801aa6:	48 83 ec 20          	sub    $0x20,%rsp
  801aaa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ab1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab8:	48 98                	cltq   
  801aba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac1:	00 
  801ac2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ace:	48 89 d1             	mov    %rdx,%rcx
  801ad1:	48 89 c2             	mov    %rax,%rdx
  801ad4:	be 01 00 00 00       	mov    $0x1,%esi
  801ad9:	bf 06 00 00 00       	mov    $0x6,%edi
  801ade:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  801ae5:	00 00 00 
  801ae8:	ff d0                	callq  *%rax
}
  801aea:	c9                   	leaveq 
  801aeb:	c3                   	retq   

0000000000801aec <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801aec:	55                   	push   %rbp
  801aed:	48 89 e5             	mov    %rsp,%rbp
  801af0:	48 83 ec 10          	sub    $0x10,%rsp
  801af4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801afa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801afd:	48 63 d0             	movslq %eax,%rdx
  801b00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b03:	48 98                	cltq   
  801b05:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b0c:	00 
  801b0d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b13:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b19:	48 89 d1             	mov    %rdx,%rcx
  801b1c:	48 89 c2             	mov    %rax,%rdx
  801b1f:	be 01 00 00 00       	mov    $0x1,%esi
  801b24:	bf 08 00 00 00       	mov    $0x8,%edi
  801b29:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  801b30:	00 00 00 
  801b33:	ff d0                	callq  *%rax
}
  801b35:	c9                   	leaveq 
  801b36:	c3                   	retq   

0000000000801b37 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b37:	55                   	push   %rbp
  801b38:	48 89 e5             	mov    %rsp,%rbp
  801b3b:	48 83 ec 20          	sub    $0x20,%rsp
  801b3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b42:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b46:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b4d:	48 98                	cltq   
  801b4f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b56:	00 
  801b57:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b5d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b63:	48 89 d1             	mov    %rdx,%rcx
  801b66:	48 89 c2             	mov    %rax,%rdx
  801b69:	be 01 00 00 00       	mov    $0x1,%esi
  801b6e:	bf 09 00 00 00       	mov    $0x9,%edi
  801b73:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  801b7a:	00 00 00 
  801b7d:	ff d0                	callq  *%rax
}
  801b7f:	c9                   	leaveq 
  801b80:	c3                   	retq   

0000000000801b81 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b81:	55                   	push   %rbp
  801b82:	48 89 e5             	mov    %rsp,%rbp
  801b85:	48 83 ec 20          	sub    $0x20,%rsp
  801b89:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b8c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b90:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b97:	48 98                	cltq   
  801b99:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ba0:	00 
  801ba1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bad:	48 89 d1             	mov    %rdx,%rcx
  801bb0:	48 89 c2             	mov    %rax,%rdx
  801bb3:	be 01 00 00 00       	mov    $0x1,%esi
  801bb8:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bbd:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  801bc4:	00 00 00 
  801bc7:	ff d0                	callq  *%rax
}
  801bc9:	c9                   	leaveq 
  801bca:	c3                   	retq   

0000000000801bcb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801bcb:	55                   	push   %rbp
  801bcc:	48 89 e5             	mov    %rsp,%rbp
  801bcf:	48 83 ec 20          	sub    $0x20,%rsp
  801bd3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bd6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bda:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bde:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801be1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801be4:	48 63 f0             	movslq %eax,%rsi
  801be7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801beb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bee:	48 98                	cltq   
  801bf0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bfb:	00 
  801bfc:	49 89 f1             	mov    %rsi,%r9
  801bff:	49 89 c8             	mov    %rcx,%r8
  801c02:	48 89 d1             	mov    %rdx,%rcx
  801c05:	48 89 c2             	mov    %rax,%rdx
  801c08:	be 00 00 00 00       	mov    $0x0,%esi
  801c0d:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c12:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  801c19:	00 00 00 
  801c1c:	ff d0                	callq  *%rax
}
  801c1e:	c9                   	leaveq 
  801c1f:	c3                   	retq   

0000000000801c20 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c20:	55                   	push   %rbp
  801c21:	48 89 e5             	mov    %rsp,%rbp
  801c24:	48 83 ec 10          	sub    $0x10,%rsp
  801c28:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c30:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c37:	00 
  801c38:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c3e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c44:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c49:	48 89 c2             	mov    %rax,%rdx
  801c4c:	be 01 00 00 00       	mov    $0x1,%esi
  801c51:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c56:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  801c5d:	00 00 00 
  801c60:	ff d0                	callq  *%rax
}
  801c62:	c9                   	leaveq 
  801c63:	c3                   	retq   

0000000000801c64 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801c64:	55                   	push   %rbp
  801c65:	48 89 e5             	mov    %rsp,%rbp
  801c68:	48 83 ec 30          	sub    $0x30,%rsp
  801c6c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801c70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c74:	48 8b 00             	mov    (%rax),%rax
  801c77:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801c7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c7f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c83:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)))
  801c86:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c89:	83 e0 02             	and    $0x2,%eax
  801c8c:	85 c0                	test   %eax,%eax
  801c8e:	74 23                	je     801cb3 <pgfault+0x4f>
  801c90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c94:	48 c1 e8 0c          	shr    $0xc,%rax
  801c98:	48 89 c2             	mov    %rax,%rdx
  801c9b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ca2:	01 00 00 
  801ca5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ca9:	25 00 08 00 00       	and    $0x800,%eax
  801cae:	48 85 c0             	test   %rax,%rax
  801cb1:	75 2a                	jne    801cdd <pgfault+0x79>
		panic("fail check at fork pgfault");
  801cb3:	48 ba 6b 41 80 00 00 	movabs $0x80416b,%rdx
  801cba:	00 00 00 
  801cbd:	be 1d 00 00 00       	mov    $0x1d,%esi
  801cc2:	48 bf 86 41 80 00 00 	movabs $0x804186,%rdi
  801cc9:	00 00 00 
  801ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd1:	48 b9 63 37 80 00 00 	movabs $0x803763,%rcx
  801cd8:	00 00 00 
  801cdb:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801cdd:	ba 07 00 00 00       	mov    $0x7,%edx
  801ce2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ce7:	bf 00 00 00 00       	mov    $0x0,%edi
  801cec:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  801cf3:	00 00 00 
  801cf6:	ff d0                	callq  *%rax

	addr = ROUNDDOWN(addr, PGSIZE);
  801cf8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cfc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d04:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801d0a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memmove(PFTEMP, addr, PGSIZE);
  801d0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d12:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d17:	48 89 c6             	mov    %rax,%rsi
  801d1a:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801d1f:	48 b8 ec 13 80 00 00 	movabs $0x8013ec,%rax
  801d26:	00 00 00 
  801d29:	ff d0                	callq  *%rax

	sys_page_map(0, (void *)PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W);
  801d2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d2f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801d35:	48 89 c1             	mov    %rax,%rcx
  801d38:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d42:	bf 00 00 00 00       	mov    $0x0,%edi
  801d47:	48 b8 47 1a 80 00 00 	movabs $0x801a47,%rax
  801d4e:	00 00 00 
  801d51:	ff d0                	callq  *%rax
	sys_page_unmap(0, PFTEMP);
  801d53:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d58:	bf 00 00 00 00       	mov    $0x0,%edi
  801d5d:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  801d64:	00 00 00 
  801d67:	ff d0                	callq  *%rax
	//panic("pgfault not implemented");
}
  801d69:	c9                   	leaveq 
  801d6a:	c3                   	retq   

0000000000801d6b <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d6b:	55                   	push   %rbp
  801d6c:	48 89 e5             	mov    %rsp,%rbp
  801d6f:	48 83 ec 20          	sub    $0x20,%rsp
  801d73:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d76:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uintptr_t)pn * PGSIZE);
  801d79:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801d7c:	48 c1 e0 0c          	shl    $0xc,%rax
  801d80:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	// note: modified for LAB 5, supporting PTE_SHARE
	if (uvpt[pn] & PTE_SHARE) {
  801d84:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d8b:	01 00 00 
  801d8e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d91:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d95:	25 00 04 00 00       	and    $0x400,%eax
  801d9a:	48 85 c0             	test   %rax,%rax
  801d9d:	74 55                	je     801df4 <duppage+0x89>
		if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL))) < 0)
  801d9f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801da6:	01 00 00 
  801da9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801dac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801db0:	25 07 0e 00 00       	and    $0xe07,%eax
  801db5:	89 c6                	mov    %eax,%esi
  801db7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801dbb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801dbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc2:	41 89 f0             	mov    %esi,%r8d
  801dc5:	48 89 c6             	mov    %rax,%rsi
  801dc8:	bf 00 00 00 00       	mov    $0x0,%edi
  801dcd:	48 b8 47 1a 80 00 00 	movabs $0x801a47,%rax
  801dd4:	00 00 00 
  801dd7:	ff d0                	callq  *%rax
  801dd9:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801ddc:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801de0:	79 08                	jns    801dea <duppage+0x7f>
			return r;
  801de2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801de5:	e9 e1 00 00 00       	jmpq   801ecb <duppage+0x160>
		return 0;
  801dea:	b8 00 00 00 00       	mov    $0x0,%eax
  801def:	e9 d7 00 00 00       	jmpq   801ecb <duppage+0x160>
	}

	// note: here we must set ~PTE_W and PTE_COW such that parent process can get correct pid
	if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  801df4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dfb:	01 00 00 
  801dfe:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e01:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e05:	25 05 06 00 00       	and    $0x605,%eax
  801e0a:	80 cc 08             	or     $0x8,%ah
  801e0d:	89 c6                	mov    %eax,%esi
  801e0f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801e13:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e1a:	41 89 f0             	mov    %esi,%r8d
  801e1d:	48 89 c6             	mov    %rax,%rsi
  801e20:	bf 00 00 00 00       	mov    $0x0,%edi
  801e25:	48 b8 47 1a 80 00 00 	movabs $0x801a47,%rax
  801e2c:	00 00 00 
  801e2f:	ff d0                	callq  *%rax
  801e31:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801e34:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e38:	79 08                	jns    801e42 <duppage+0xd7>
		return r;
  801e3a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e3d:	e9 89 00 00 00       	jmpq   801ecb <duppage+0x160>

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  801e42:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e49:	01 00 00 
  801e4c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e4f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e53:	83 e0 02             	and    $0x2,%eax
  801e56:	48 85 c0             	test   %rax,%rax
  801e59:	75 1b                	jne    801e76 <duppage+0x10b>
  801e5b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e62:	01 00 00 
  801e65:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e68:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e6c:	25 00 08 00 00       	and    $0x800,%eax
  801e71:	48 85 c0             	test   %rax,%rax
  801e74:	74 50                	je     801ec6 <duppage+0x15b>
		if ((r = sys_page_map(0, addr, 0, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  801e76:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e7d:	01 00 00 
  801e80:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e83:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e87:	25 05 06 00 00       	and    $0x605,%eax
  801e8c:	80 cc 08             	or     $0x8,%ah
  801e8f:	89 c1                	mov    %eax,%ecx
  801e91:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e99:	41 89 c8             	mov    %ecx,%r8d
  801e9c:	48 89 d1             	mov    %rdx,%rcx
  801e9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea4:	48 89 c6             	mov    %rax,%rsi
  801ea7:	bf 00 00 00 00       	mov    $0x0,%edi
  801eac:	48 b8 47 1a 80 00 00 	movabs $0x801a47,%rax
  801eb3:	00 00 00 
  801eb6:	ff d0                	callq  *%rax
  801eb8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801ebb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801ebf:	79 05                	jns    801ec6 <duppage+0x15b>
			return r;
  801ec1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ec4:	eb 05                	jmp    801ecb <duppage+0x160>
	//panic("duppage not implemented");
	return 0;
  801ec6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ecb:	c9                   	leaveq 
  801ecc:	c3                   	retq   

0000000000801ecd <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801ecd:	55                   	push   %rbp
  801ece:	48 89 e5             	mov    %rsp,%rbp
  801ed1:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	int r;
	envid_t envid;
	int i, j, k, l, ptx = 0;
  801ed5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	set_pgfault_handler(pgfault);
  801edc:	48 bf 64 1c 80 00 00 	movabs $0x801c64,%rdi
  801ee3:	00 00 00 
  801ee6:	48 b8 77 38 80 00 00 	movabs $0x803877,%rax
  801eed:	00 00 00 
  801ef0:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801ef2:	b8 07 00 00 00       	mov    $0x7,%eax
  801ef7:	cd 30                	int    $0x30
  801ef9:	89 45 e0             	mov    %eax,-0x20(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801efc:	8b 45 e0             	mov    -0x20(%rbp),%eax

	if ((envid = sys_exofork()) < 0)
  801eff:	89 45 e8             	mov    %eax,-0x18(%rbp)
  801f02:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801f06:	79 08                	jns    801f10 <fork+0x43>
		return envid;
  801f08:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f0b:	e9 27 02 00 00       	jmpq   802137 <fork+0x26a>
	else if (envid == 0) {
  801f10:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801f14:	75 46                	jne    801f5c <fork+0x8f>
		thisenv = &envs[ENVX(sys_getenvid())];
  801f16:	48 b8 7b 19 80 00 00 	movabs $0x80197b,%rax
  801f1d:	00 00 00 
  801f20:	ff d0                	callq  *%rax
  801f22:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f27:	48 63 d0             	movslq %eax,%rdx
  801f2a:	48 89 d0             	mov    %rdx,%rax
  801f2d:	48 c1 e0 03          	shl    $0x3,%rax
  801f31:	48 01 d0             	add    %rdx,%rax
  801f34:	48 c1 e0 05          	shl    $0x5,%rax
  801f38:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801f3f:	00 00 00 
  801f42:	48 01 c2             	add    %rax,%rdx
  801f45:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801f4c:	00 00 00 
  801f4f:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801f52:	b8 00 00 00 00       	mov    $0x0,%eax
  801f57:	e9 db 01 00 00       	jmpq   802137 <fork+0x26a>
	}

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801f5c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f5f:	ba 07 00 00 00       	mov    $0x7,%edx
  801f64:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801f69:	89 c7                	mov    %eax,%edi
  801f6b:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  801f72:	00 00 00 
  801f75:	ff d0                	callq  *%rax
  801f77:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  801f7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801f7e:	79 08                	jns    801f88 <fork+0xbb>
		return r;
  801f80:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801f83:	e9 af 01 00 00       	jmpq   802137 <fork+0x26a>

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  801f88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f8f:	e9 49 01 00 00       	jmpq   8020dd <fork+0x210>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  801f94:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f97:	8d 90 ff ff ff 07    	lea    0x7ffffff(%rax),%edx
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	0f 48 c2             	cmovs  %edx,%eax
  801fa2:	c1 f8 1b             	sar    $0x1b,%eax
  801fa5:	89 c2                	mov    %eax,%edx
  801fa7:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801fae:	01 00 00 
  801fb1:	48 63 d2             	movslq %edx,%rdx
  801fb4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb8:	83 e0 01             	and    $0x1,%eax
  801fbb:	48 85 c0             	test   %rax,%rax
  801fbe:	75 0c                	jne    801fcc <fork+0xff>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  801fc0:	81 45 ec 00 00 00 08 	addl   $0x8000000,-0x14(%rbp)
			continue;
  801fc7:	e9 0d 01 00 00       	jmpq   8020d9 <fork+0x20c>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  801fcc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  801fd3:	e9 f4 00 00 00       	jmpq   8020cc <fork+0x1ff>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  801fd8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fdb:	8d 90 ff ff 03 00    	lea    0x3ffff(%rax),%edx
  801fe1:	85 c0                	test   %eax,%eax
  801fe3:	0f 48 c2             	cmovs  %edx,%eax
  801fe6:	c1 f8 12             	sar    $0x12,%eax
  801fe9:	89 c2                	mov    %eax,%edx
  801feb:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801ff2:	01 00 00 
  801ff5:	48 63 d2             	movslq %edx,%rdx
  801ff8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ffc:	83 e0 01             	and    $0x1,%eax
  801fff:	48 85 c0             	test   %rax,%rax
  802002:	75 0c                	jne    802010 <fork+0x143>
				ptx += NPDENTRIES * NPTENTRIES;
  802004:	81 45 ec 00 00 04 00 	addl   $0x40000,-0x14(%rbp)
				continue;
  80200b:	e9 b8 00 00 00       	jmpq   8020c8 <fork+0x1fb>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  802010:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  802017:	e9 9f 00 00 00       	jmpq   8020bb <fork+0x1ee>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  80201c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80201f:	8d 90 ff 01 00 00    	lea    0x1ff(%rax),%edx
  802025:	85 c0                	test   %eax,%eax
  802027:	0f 48 c2             	cmovs  %edx,%eax
  80202a:	c1 f8 09             	sar    $0x9,%eax
  80202d:	89 c2                	mov    %eax,%edx
  80202f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802036:	01 00 00 
  802039:	48 63 d2             	movslq %edx,%rdx
  80203c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802040:	83 e0 01             	and    $0x1,%eax
  802043:	48 85 c0             	test   %rax,%rax
  802046:	75 09                	jne    802051 <fork+0x184>
					ptx += NPTENTRIES;
  802048:	81 45 ec 00 02 00 00 	addl   $0x200,-0x14(%rbp)
					continue;
  80204f:	eb 66                	jmp    8020b7 <fork+0x1ea>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  802051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  802058:	eb 54                	jmp    8020ae <fork+0x1e1>
					if ((uvpt[ptx] & PTE_P) != 0)
  80205a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802061:	01 00 00 
  802064:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802067:	48 63 d2             	movslq %edx,%rdx
  80206a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80206e:	83 e0 01             	and    $0x1,%eax
  802071:	48 85 c0             	test   %rax,%rax
  802074:	74 30                	je     8020a6 <fork+0x1d9>
						if (ptx != VPN(UXSTACKTOP - PGSIZE))
  802076:	81 7d ec ff f7 0e 00 	cmpl   $0xef7ff,-0x14(%rbp)
  80207d:	74 27                	je     8020a6 <fork+0x1d9>
							if ((r = duppage(envid, ptx)) < 0)
  80207f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802082:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802085:	89 d6                	mov    %edx,%esi
  802087:	89 c7                	mov    %eax,%edi
  802089:	48 b8 6b 1d 80 00 00 	movabs $0x801d6b,%rax
  802090:	00 00 00 
  802093:	ff d0                	callq  *%rax
  802095:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802098:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80209c:	79 08                	jns    8020a6 <fork+0x1d9>
								return r;
  80209e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8020a1:	e9 91 00 00 00       	jmpq   802137 <fork+0x26a>
					ptx++;
  8020a6:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  8020aa:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8020ae:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
  8020b5:	7e a3                	jle    80205a <fork+0x18d>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  8020b7:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8020bb:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
  8020c2:	0f 8e 54 ff ff ff    	jle    80201c <fork+0x14f>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  8020c8:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8020cc:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
  8020d3:	0f 8e ff fe ff ff    	jle    801fd8 <fork+0x10b>
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		return r;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  8020d9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020e1:	0f 84 ad fe ff ff    	je     801f94 <fork+0xc7>
			}
		}
	}

	extern void _pgfault_upcall();
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8020e7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020ea:	48 be e2 38 80 00 00 	movabs $0x8038e2,%rsi
  8020f1:	00 00 00 
  8020f4:	89 c7                	mov    %eax,%edi
  8020f6:	48 b8 81 1b 80 00 00 	movabs $0x801b81,%rax
  8020fd:	00 00 00 
  802100:	ff d0                	callq  *%rax
  802102:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802105:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802109:	79 05                	jns    802110 <fork+0x243>
		return r;
  80210b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80210e:	eb 27                	jmp    802137 <fork+0x26a>
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802110:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802113:	be 02 00 00 00       	mov    $0x2,%esi
  802118:	89 c7                	mov    %eax,%edi
  80211a:	48 b8 ec 1a 80 00 00 	movabs $0x801aec,%rax
  802121:	00 00 00 
  802124:	ff d0                	callq  *%rax
  802126:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802129:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80212d:	79 05                	jns    802134 <fork+0x267>
		return r;
  80212f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802132:	eb 03                	jmp    802137 <fork+0x26a>

	return envid;
  802134:	8b 45 e8             	mov    -0x18(%rbp),%eax
	//panic("fork not implemented");
}
  802137:	c9                   	leaveq 
  802138:	c3                   	retq   

0000000000802139 <sfork>:

// Challenge!
int
sfork(void)
{
  802139:	55                   	push   %rbp
  80213a:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80213d:	48 ba 91 41 80 00 00 	movabs $0x804191,%rdx
  802144:	00 00 00 
  802147:	be a7 00 00 00       	mov    $0xa7,%esi
  80214c:	48 bf 86 41 80 00 00 	movabs $0x804186,%rdi
  802153:	00 00 00 
  802156:	b8 00 00 00 00       	mov    $0x0,%eax
  80215b:	48 b9 63 37 80 00 00 	movabs $0x803763,%rcx
  802162:	00 00 00 
  802165:	ff d1                	callq  *%rcx

0000000000802167 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802167:	55                   	push   %rbp
  802168:	48 89 e5             	mov    %rsp,%rbp
  80216b:	48 83 ec 08          	sub    $0x8,%rsp
  80216f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802173:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802177:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80217e:	ff ff ff 
  802181:	48 01 d0             	add    %rdx,%rax
  802184:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802188:	c9                   	leaveq 
  802189:	c3                   	retq   

000000000080218a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80218a:	55                   	push   %rbp
  80218b:	48 89 e5             	mov    %rsp,%rbp
  80218e:	48 83 ec 08          	sub    $0x8,%rsp
  802192:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802196:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80219a:	48 89 c7             	mov    %rax,%rdi
  80219d:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  8021a4:	00 00 00 
  8021a7:	ff d0                	callq  *%rax
  8021a9:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8021af:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8021b3:	c9                   	leaveq 
  8021b4:	c3                   	retq   

00000000008021b5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8021b5:	55                   	push   %rbp
  8021b6:	48 89 e5             	mov    %rsp,%rbp
  8021b9:	48 83 ec 18          	sub    $0x18,%rsp
  8021bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8021c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021c8:	eb 6b                	jmp    802235 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8021ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021cd:	48 98                	cltq   
  8021cf:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021d5:	48 c1 e0 0c          	shl    $0xc,%rax
  8021d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8021dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e1:	48 c1 e8 15          	shr    $0x15,%rax
  8021e5:	48 89 c2             	mov    %rax,%rdx
  8021e8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021ef:	01 00 00 
  8021f2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f6:	83 e0 01             	and    $0x1,%eax
  8021f9:	48 85 c0             	test   %rax,%rax
  8021fc:	74 21                	je     80221f <fd_alloc+0x6a>
  8021fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802202:	48 c1 e8 0c          	shr    $0xc,%rax
  802206:	48 89 c2             	mov    %rax,%rdx
  802209:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802210:	01 00 00 
  802213:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802217:	83 e0 01             	and    $0x1,%eax
  80221a:	48 85 c0             	test   %rax,%rax
  80221d:	75 12                	jne    802231 <fd_alloc+0x7c>
			*fd_store = fd;
  80221f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802223:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802227:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80222a:	b8 00 00 00 00       	mov    $0x0,%eax
  80222f:	eb 1a                	jmp    80224b <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802231:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802235:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802239:	7e 8f                	jle    8021ca <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80223b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802246:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80224b:	c9                   	leaveq 
  80224c:	c3                   	retq   

000000000080224d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80224d:	55                   	push   %rbp
  80224e:	48 89 e5             	mov    %rsp,%rbp
  802251:	48 83 ec 20          	sub    $0x20,%rsp
  802255:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802258:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80225c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802260:	78 06                	js     802268 <fd_lookup+0x1b>
  802262:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802266:	7e 07                	jle    80226f <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802268:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80226d:	eb 6c                	jmp    8022db <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80226f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802272:	48 98                	cltq   
  802274:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80227a:	48 c1 e0 0c          	shl    $0xc,%rax
  80227e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802282:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802286:	48 c1 e8 15          	shr    $0x15,%rax
  80228a:	48 89 c2             	mov    %rax,%rdx
  80228d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802294:	01 00 00 
  802297:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80229b:	83 e0 01             	and    $0x1,%eax
  80229e:	48 85 c0             	test   %rax,%rax
  8022a1:	74 21                	je     8022c4 <fd_lookup+0x77>
  8022a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022a7:	48 c1 e8 0c          	shr    $0xc,%rax
  8022ab:	48 89 c2             	mov    %rax,%rdx
  8022ae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022b5:	01 00 00 
  8022b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022bc:	83 e0 01             	and    $0x1,%eax
  8022bf:	48 85 c0             	test   %rax,%rax
  8022c2:	75 07                	jne    8022cb <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022c9:	eb 10                	jmp    8022db <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8022cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022cf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8022d3:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8022d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022db:	c9                   	leaveq 
  8022dc:	c3                   	retq   

00000000008022dd <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8022dd:	55                   	push   %rbp
  8022de:	48 89 e5             	mov    %rsp,%rbp
  8022e1:	48 83 ec 30          	sub    $0x30,%rsp
  8022e5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8022e9:	89 f0                	mov    %esi,%eax
  8022eb:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8022ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022f2:	48 89 c7             	mov    %rax,%rdi
  8022f5:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  8022fc:	00 00 00 
  8022ff:	ff d0                	callq  *%rax
  802301:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802305:	48 89 d6             	mov    %rdx,%rsi
  802308:	89 c7                	mov    %eax,%edi
  80230a:	48 b8 4d 22 80 00 00 	movabs $0x80224d,%rax
  802311:	00 00 00 
  802314:	ff d0                	callq  *%rax
  802316:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802319:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80231d:	78 0a                	js     802329 <fd_close+0x4c>
	    || fd != fd2)
  80231f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802323:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802327:	74 12                	je     80233b <fd_close+0x5e>
		return (must_exist ? r : 0);
  802329:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80232d:	74 05                	je     802334 <fd_close+0x57>
  80232f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802332:	eb 05                	jmp    802339 <fd_close+0x5c>
  802334:	b8 00 00 00 00       	mov    $0x0,%eax
  802339:	eb 69                	jmp    8023a4 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80233b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80233f:	8b 00                	mov    (%rax),%eax
  802341:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802345:	48 89 d6             	mov    %rdx,%rsi
  802348:	89 c7                	mov    %eax,%edi
  80234a:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  802351:	00 00 00 
  802354:	ff d0                	callq  *%rax
  802356:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802359:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80235d:	78 2a                	js     802389 <fd_close+0xac>
		if (dev->dev_close)
  80235f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802363:	48 8b 40 20          	mov    0x20(%rax),%rax
  802367:	48 85 c0             	test   %rax,%rax
  80236a:	74 16                	je     802382 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80236c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802370:	48 8b 40 20          	mov    0x20(%rax),%rax
  802374:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802378:	48 89 d7             	mov    %rdx,%rdi
  80237b:	ff d0                	callq  *%rax
  80237d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802380:	eb 07                	jmp    802389 <fd_close+0xac>
		else
			r = 0;
  802382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802389:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80238d:	48 89 c6             	mov    %rax,%rsi
  802390:	bf 00 00 00 00       	mov    $0x0,%edi
  802395:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  80239c:	00 00 00 
  80239f:	ff d0                	callq  *%rax
	return r;
  8023a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023a4:	c9                   	leaveq 
  8023a5:	c3                   	retq   

00000000008023a6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8023a6:	55                   	push   %rbp
  8023a7:	48 89 e5             	mov    %rsp,%rbp
  8023aa:	48 83 ec 20          	sub    $0x20,%rsp
  8023ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8023b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023bc:	eb 41                	jmp    8023ff <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8023be:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8023c5:	00 00 00 
  8023c8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023cb:	48 63 d2             	movslq %edx,%rdx
  8023ce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023d2:	8b 00                	mov    (%rax),%eax
  8023d4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8023d7:	75 22                	jne    8023fb <dev_lookup+0x55>
			*dev = devtab[i];
  8023d9:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8023e0:	00 00 00 
  8023e3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023e6:	48 63 d2             	movslq %edx,%rdx
  8023e9:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8023ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023f1:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f9:	eb 60                	jmp    80245b <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8023fb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023ff:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802406:	00 00 00 
  802409:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80240c:	48 63 d2             	movslq %edx,%rdx
  80240f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802413:	48 85 c0             	test   %rax,%rax
  802416:	75 a6                	jne    8023be <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802418:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80241f:	00 00 00 
  802422:	48 8b 00             	mov    (%rax),%rax
  802425:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80242b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80242e:	89 c6                	mov    %eax,%esi
  802430:	48 bf a8 41 80 00 00 	movabs $0x8041a8,%rdi
  802437:	00 00 00 
  80243a:	b8 00 00 00 00       	mov    $0x0,%eax
  80243f:	48 b9 20 03 80 00 00 	movabs $0x800320,%rcx
  802446:	00 00 00 
  802449:	ff d1                	callq  *%rcx
	*dev = 0;
  80244b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80244f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802456:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80245b:	c9                   	leaveq 
  80245c:	c3                   	retq   

000000000080245d <close>:

int
close(int fdnum)
{
  80245d:	55                   	push   %rbp
  80245e:	48 89 e5             	mov    %rsp,%rbp
  802461:	48 83 ec 20          	sub    $0x20,%rsp
  802465:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802468:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80246c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80246f:	48 89 d6             	mov    %rdx,%rsi
  802472:	89 c7                	mov    %eax,%edi
  802474:	48 b8 4d 22 80 00 00 	movabs $0x80224d,%rax
  80247b:	00 00 00 
  80247e:	ff d0                	callq  *%rax
  802480:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802483:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802487:	79 05                	jns    80248e <close+0x31>
		return r;
  802489:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248c:	eb 18                	jmp    8024a6 <close+0x49>
	else
		return fd_close(fd, 1);
  80248e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802492:	be 01 00 00 00       	mov    $0x1,%esi
  802497:	48 89 c7             	mov    %rax,%rdi
  80249a:	48 b8 dd 22 80 00 00 	movabs $0x8022dd,%rax
  8024a1:	00 00 00 
  8024a4:	ff d0                	callq  *%rax
}
  8024a6:	c9                   	leaveq 
  8024a7:	c3                   	retq   

00000000008024a8 <close_all>:

void
close_all(void)
{
  8024a8:	55                   	push   %rbp
  8024a9:	48 89 e5             	mov    %rsp,%rbp
  8024ac:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8024b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024b7:	eb 15                	jmp    8024ce <close_all+0x26>
		close(i);
  8024b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024bc:	89 c7                	mov    %eax,%edi
  8024be:	48 b8 5d 24 80 00 00 	movabs $0x80245d,%rax
  8024c5:	00 00 00 
  8024c8:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8024ca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024ce:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8024d2:	7e e5                	jle    8024b9 <close_all+0x11>
		close(i);
}
  8024d4:	c9                   	leaveq 
  8024d5:	c3                   	retq   

00000000008024d6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8024d6:	55                   	push   %rbp
  8024d7:	48 89 e5             	mov    %rsp,%rbp
  8024da:	48 83 ec 40          	sub    $0x40,%rsp
  8024de:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8024e1:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8024e4:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8024e8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8024eb:	48 89 d6             	mov    %rdx,%rsi
  8024ee:	89 c7                	mov    %eax,%edi
  8024f0:	48 b8 4d 22 80 00 00 	movabs $0x80224d,%rax
  8024f7:	00 00 00 
  8024fa:	ff d0                	callq  *%rax
  8024fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802503:	79 08                	jns    80250d <dup+0x37>
		return r;
  802505:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802508:	e9 70 01 00 00       	jmpq   80267d <dup+0x1a7>
	close(newfdnum);
  80250d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802510:	89 c7                	mov    %eax,%edi
  802512:	48 b8 5d 24 80 00 00 	movabs $0x80245d,%rax
  802519:	00 00 00 
  80251c:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80251e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802521:	48 98                	cltq   
  802523:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802529:	48 c1 e0 0c          	shl    $0xc,%rax
  80252d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802531:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802535:	48 89 c7             	mov    %rax,%rdi
  802538:	48 b8 8a 21 80 00 00 	movabs $0x80218a,%rax
  80253f:	00 00 00 
  802542:	ff d0                	callq  *%rax
  802544:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802548:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80254c:	48 89 c7             	mov    %rax,%rdi
  80254f:	48 b8 8a 21 80 00 00 	movabs $0x80218a,%rax
  802556:	00 00 00 
  802559:	ff d0                	callq  *%rax
  80255b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80255f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802563:	48 c1 e8 15          	shr    $0x15,%rax
  802567:	48 89 c2             	mov    %rax,%rdx
  80256a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802571:	01 00 00 
  802574:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802578:	83 e0 01             	and    $0x1,%eax
  80257b:	48 85 c0             	test   %rax,%rax
  80257e:	74 73                	je     8025f3 <dup+0x11d>
  802580:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802584:	48 c1 e8 0c          	shr    $0xc,%rax
  802588:	48 89 c2             	mov    %rax,%rdx
  80258b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802592:	01 00 00 
  802595:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802599:	83 e0 01             	and    $0x1,%eax
  80259c:	48 85 c0             	test   %rax,%rax
  80259f:	74 52                	je     8025f3 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8025a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a5:	48 c1 e8 0c          	shr    $0xc,%rax
  8025a9:	48 89 c2             	mov    %rax,%rdx
  8025ac:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025b3:	01 00 00 
  8025b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ba:	25 07 0e 00 00       	and    $0xe07,%eax
  8025bf:	89 c1                	mov    %eax,%ecx
  8025c1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c9:	41 89 c8             	mov    %ecx,%r8d
  8025cc:	48 89 d1             	mov    %rdx,%rcx
  8025cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8025d4:	48 89 c6             	mov    %rax,%rsi
  8025d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8025dc:	48 b8 47 1a 80 00 00 	movabs $0x801a47,%rax
  8025e3:	00 00 00 
  8025e6:	ff d0                	callq  *%rax
  8025e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ef:	79 02                	jns    8025f3 <dup+0x11d>
			goto err;
  8025f1:	eb 57                	jmp    80264a <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8025f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025f7:	48 c1 e8 0c          	shr    $0xc,%rax
  8025fb:	48 89 c2             	mov    %rax,%rdx
  8025fe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802605:	01 00 00 
  802608:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80260c:	25 07 0e 00 00       	and    $0xe07,%eax
  802611:	89 c1                	mov    %eax,%ecx
  802613:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802617:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80261b:	41 89 c8             	mov    %ecx,%r8d
  80261e:	48 89 d1             	mov    %rdx,%rcx
  802621:	ba 00 00 00 00       	mov    $0x0,%edx
  802626:	48 89 c6             	mov    %rax,%rsi
  802629:	bf 00 00 00 00       	mov    $0x0,%edi
  80262e:	48 b8 47 1a 80 00 00 	movabs $0x801a47,%rax
  802635:	00 00 00 
  802638:	ff d0                	callq  *%rax
  80263a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80263d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802641:	79 02                	jns    802645 <dup+0x16f>
		goto err;
  802643:	eb 05                	jmp    80264a <dup+0x174>

	return newfdnum;
  802645:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802648:	eb 33                	jmp    80267d <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80264a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80264e:	48 89 c6             	mov    %rax,%rsi
  802651:	bf 00 00 00 00       	mov    $0x0,%edi
  802656:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  80265d:	00 00 00 
  802660:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802662:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802666:	48 89 c6             	mov    %rax,%rsi
  802669:	bf 00 00 00 00       	mov    $0x0,%edi
  80266e:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  802675:	00 00 00 
  802678:	ff d0                	callq  *%rax
	return r;
  80267a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80267d:	c9                   	leaveq 
  80267e:	c3                   	retq   

000000000080267f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80267f:	55                   	push   %rbp
  802680:	48 89 e5             	mov    %rsp,%rbp
  802683:	48 83 ec 40          	sub    $0x40,%rsp
  802687:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80268a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80268e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802692:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802696:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802699:	48 89 d6             	mov    %rdx,%rsi
  80269c:	89 c7                	mov    %eax,%edi
  80269e:	48 b8 4d 22 80 00 00 	movabs $0x80224d,%rax
  8026a5:	00 00 00 
  8026a8:	ff d0                	callq  *%rax
  8026aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b1:	78 24                	js     8026d7 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b7:	8b 00                	mov    (%rax),%eax
  8026b9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026bd:	48 89 d6             	mov    %rdx,%rsi
  8026c0:	89 c7                	mov    %eax,%edi
  8026c2:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  8026c9:	00 00 00 
  8026cc:	ff d0                	callq  *%rax
  8026ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d5:	79 05                	jns    8026dc <read+0x5d>
		return r;
  8026d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026da:	eb 76                	jmp    802752 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8026dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e0:	8b 40 08             	mov    0x8(%rax),%eax
  8026e3:	83 e0 03             	and    $0x3,%eax
  8026e6:	83 f8 01             	cmp    $0x1,%eax
  8026e9:	75 3a                	jne    802725 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8026eb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8026f2:	00 00 00 
  8026f5:	48 8b 00             	mov    (%rax),%rax
  8026f8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026fe:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802701:	89 c6                	mov    %eax,%esi
  802703:	48 bf c7 41 80 00 00 	movabs $0x8041c7,%rdi
  80270a:	00 00 00 
  80270d:	b8 00 00 00 00       	mov    $0x0,%eax
  802712:	48 b9 20 03 80 00 00 	movabs $0x800320,%rcx
  802719:	00 00 00 
  80271c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80271e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802723:	eb 2d                	jmp    802752 <read+0xd3>
	}
	if (!dev->dev_read)
  802725:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802729:	48 8b 40 10          	mov    0x10(%rax),%rax
  80272d:	48 85 c0             	test   %rax,%rax
  802730:	75 07                	jne    802739 <read+0xba>
		return -E_NOT_SUPP;
  802732:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802737:	eb 19                	jmp    802752 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802739:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802741:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802745:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802749:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80274d:	48 89 cf             	mov    %rcx,%rdi
  802750:	ff d0                	callq  *%rax
}
  802752:	c9                   	leaveq 
  802753:	c3                   	retq   

0000000000802754 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802754:	55                   	push   %rbp
  802755:	48 89 e5             	mov    %rsp,%rbp
  802758:	48 83 ec 30          	sub    $0x30,%rsp
  80275c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80275f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802763:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802767:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80276e:	eb 49                	jmp    8027b9 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802770:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802773:	48 98                	cltq   
  802775:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802779:	48 29 c2             	sub    %rax,%rdx
  80277c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277f:	48 63 c8             	movslq %eax,%rcx
  802782:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802786:	48 01 c1             	add    %rax,%rcx
  802789:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80278c:	48 89 ce             	mov    %rcx,%rsi
  80278f:	89 c7                	mov    %eax,%edi
  802791:	48 b8 7f 26 80 00 00 	movabs $0x80267f,%rax
  802798:	00 00 00 
  80279b:	ff d0                	callq  *%rax
  80279d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8027a0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027a4:	79 05                	jns    8027ab <readn+0x57>
			return m;
  8027a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027a9:	eb 1c                	jmp    8027c7 <readn+0x73>
		if (m == 0)
  8027ab:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027af:	75 02                	jne    8027b3 <readn+0x5f>
			break;
  8027b1:	eb 11                	jmp    8027c4 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027b6:	01 45 fc             	add    %eax,-0x4(%rbp)
  8027b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027bc:	48 98                	cltq   
  8027be:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8027c2:	72 ac                	jb     802770 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8027c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027c7:	c9                   	leaveq 
  8027c8:	c3                   	retq   

00000000008027c9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8027c9:	55                   	push   %rbp
  8027ca:	48 89 e5             	mov    %rsp,%rbp
  8027cd:	48 83 ec 40          	sub    $0x40,%rsp
  8027d1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027d4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8027d8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027dc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027e0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027e3:	48 89 d6             	mov    %rdx,%rsi
  8027e6:	89 c7                	mov    %eax,%edi
  8027e8:	48 b8 4d 22 80 00 00 	movabs $0x80224d,%rax
  8027ef:	00 00 00 
  8027f2:	ff d0                	callq  *%rax
  8027f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027fb:	78 24                	js     802821 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802801:	8b 00                	mov    (%rax),%eax
  802803:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802807:	48 89 d6             	mov    %rdx,%rsi
  80280a:	89 c7                	mov    %eax,%edi
  80280c:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  802813:	00 00 00 
  802816:	ff d0                	callq  *%rax
  802818:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80281b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80281f:	79 05                	jns    802826 <write+0x5d>
		return r;
  802821:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802824:	eb 75                	jmp    80289b <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802826:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80282a:	8b 40 08             	mov    0x8(%rax),%eax
  80282d:	83 e0 03             	and    $0x3,%eax
  802830:	85 c0                	test   %eax,%eax
  802832:	75 3a                	jne    80286e <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802834:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80283b:	00 00 00 
  80283e:	48 8b 00             	mov    (%rax),%rax
  802841:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802847:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80284a:	89 c6                	mov    %eax,%esi
  80284c:	48 bf e3 41 80 00 00 	movabs $0x8041e3,%rdi
  802853:	00 00 00 
  802856:	b8 00 00 00 00       	mov    $0x0,%eax
  80285b:	48 b9 20 03 80 00 00 	movabs $0x800320,%rcx
  802862:	00 00 00 
  802865:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802867:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80286c:	eb 2d                	jmp    80289b <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80286e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802872:	48 8b 40 18          	mov    0x18(%rax),%rax
  802876:	48 85 c0             	test   %rax,%rax
  802879:	75 07                	jne    802882 <write+0xb9>
		return -E_NOT_SUPP;
  80287b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802880:	eb 19                	jmp    80289b <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802882:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802886:	48 8b 40 18          	mov    0x18(%rax),%rax
  80288a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80288e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802892:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802896:	48 89 cf             	mov    %rcx,%rdi
  802899:	ff d0                	callq  *%rax
}
  80289b:	c9                   	leaveq 
  80289c:	c3                   	retq   

000000000080289d <seek>:

int
seek(int fdnum, off_t offset)
{
  80289d:	55                   	push   %rbp
  80289e:	48 89 e5             	mov    %rsp,%rbp
  8028a1:	48 83 ec 18          	sub    $0x18,%rsp
  8028a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028a8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028ab:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028b2:	48 89 d6             	mov    %rdx,%rsi
  8028b5:	89 c7                	mov    %eax,%edi
  8028b7:	48 b8 4d 22 80 00 00 	movabs $0x80224d,%rax
  8028be:	00 00 00 
  8028c1:	ff d0                	callq  *%rax
  8028c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ca:	79 05                	jns    8028d1 <seek+0x34>
		return r;
  8028cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028cf:	eb 0f                	jmp    8028e0 <seek+0x43>
	fd->fd_offset = offset;
  8028d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8028d8:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8028db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028e0:	c9                   	leaveq 
  8028e1:	c3                   	retq   

00000000008028e2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8028e2:	55                   	push   %rbp
  8028e3:	48 89 e5             	mov    %rsp,%rbp
  8028e6:	48 83 ec 30          	sub    $0x30,%rsp
  8028ea:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028ed:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028f0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028f4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028f7:	48 89 d6             	mov    %rdx,%rsi
  8028fa:	89 c7                	mov    %eax,%edi
  8028fc:	48 b8 4d 22 80 00 00 	movabs $0x80224d,%rax
  802903:	00 00 00 
  802906:	ff d0                	callq  *%rax
  802908:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80290b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290f:	78 24                	js     802935 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802911:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802915:	8b 00                	mov    (%rax),%eax
  802917:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80291b:	48 89 d6             	mov    %rdx,%rsi
  80291e:	89 c7                	mov    %eax,%edi
  802920:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  802927:	00 00 00 
  80292a:	ff d0                	callq  *%rax
  80292c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80292f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802933:	79 05                	jns    80293a <ftruncate+0x58>
		return r;
  802935:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802938:	eb 72                	jmp    8029ac <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80293a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80293e:	8b 40 08             	mov    0x8(%rax),%eax
  802941:	83 e0 03             	and    $0x3,%eax
  802944:	85 c0                	test   %eax,%eax
  802946:	75 3a                	jne    802982 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802948:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80294f:	00 00 00 
  802952:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802955:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80295b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80295e:	89 c6                	mov    %eax,%esi
  802960:	48 bf 00 42 80 00 00 	movabs $0x804200,%rdi
  802967:	00 00 00 
  80296a:	b8 00 00 00 00       	mov    $0x0,%eax
  80296f:	48 b9 20 03 80 00 00 	movabs $0x800320,%rcx
  802976:	00 00 00 
  802979:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80297b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802980:	eb 2a                	jmp    8029ac <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802982:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802986:	48 8b 40 30          	mov    0x30(%rax),%rax
  80298a:	48 85 c0             	test   %rax,%rax
  80298d:	75 07                	jne    802996 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80298f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802994:	eb 16                	jmp    8029ac <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802996:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80299a:	48 8b 40 30          	mov    0x30(%rax),%rax
  80299e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029a2:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8029a5:	89 ce                	mov    %ecx,%esi
  8029a7:	48 89 d7             	mov    %rdx,%rdi
  8029aa:	ff d0                	callq  *%rax
}
  8029ac:	c9                   	leaveq 
  8029ad:	c3                   	retq   

00000000008029ae <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8029ae:	55                   	push   %rbp
  8029af:	48 89 e5             	mov    %rsp,%rbp
  8029b2:	48 83 ec 30          	sub    $0x30,%rsp
  8029b6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029b9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029bd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029c1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029c4:	48 89 d6             	mov    %rdx,%rsi
  8029c7:	89 c7                	mov    %eax,%edi
  8029c9:	48 b8 4d 22 80 00 00 	movabs $0x80224d,%rax
  8029d0:	00 00 00 
  8029d3:	ff d0                	callq  *%rax
  8029d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029dc:	78 24                	js     802a02 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e2:	8b 00                	mov    (%rax),%eax
  8029e4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029e8:	48 89 d6             	mov    %rdx,%rsi
  8029eb:	89 c7                	mov    %eax,%edi
  8029ed:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  8029f4:	00 00 00 
  8029f7:	ff d0                	callq  *%rax
  8029f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a00:	79 05                	jns    802a07 <fstat+0x59>
		return r;
  802a02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a05:	eb 5e                	jmp    802a65 <fstat+0xb7>
	if (!dev->dev_stat)
  802a07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0b:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a0f:	48 85 c0             	test   %rax,%rax
  802a12:	75 07                	jne    802a1b <fstat+0x6d>
		return -E_NOT_SUPP;
  802a14:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a19:	eb 4a                	jmp    802a65 <fstat+0xb7>
	stat->st_name[0] = 0;
  802a1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a1f:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802a22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a26:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a2d:	00 00 00 
	stat->st_isdir = 0;
  802a30:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a34:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a3b:	00 00 00 
	stat->st_dev = dev;
  802a3e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a42:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a46:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802a4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a51:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a55:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a59:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a5d:	48 89 ce             	mov    %rcx,%rsi
  802a60:	48 89 d7             	mov    %rdx,%rdi
  802a63:	ff d0                	callq  *%rax
}
  802a65:	c9                   	leaveq 
  802a66:	c3                   	retq   

0000000000802a67 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802a67:	55                   	push   %rbp
  802a68:	48 89 e5             	mov    %rsp,%rbp
  802a6b:	48 83 ec 20          	sub    $0x20,%rsp
  802a6f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a73:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802a77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a7b:	be 00 00 00 00       	mov    $0x0,%esi
  802a80:	48 89 c7             	mov    %rax,%rdi
  802a83:	48 b8 55 2b 80 00 00 	movabs $0x802b55,%rax
  802a8a:	00 00 00 
  802a8d:	ff d0                	callq  *%rax
  802a8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a96:	79 05                	jns    802a9d <stat+0x36>
		return fd;
  802a98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a9b:	eb 2f                	jmp    802acc <stat+0x65>
	r = fstat(fd, stat);
  802a9d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802aa1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa4:	48 89 d6             	mov    %rdx,%rsi
  802aa7:	89 c7                	mov    %eax,%edi
  802aa9:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  802ab0:	00 00 00 
  802ab3:	ff d0                	callq  *%rax
  802ab5:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ab8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802abb:	89 c7                	mov    %eax,%edi
  802abd:	48 b8 5d 24 80 00 00 	movabs $0x80245d,%rax
  802ac4:	00 00 00 
  802ac7:	ff d0                	callq  *%rax
	return r;
  802ac9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802acc:	c9                   	leaveq 
  802acd:	c3                   	retq   

0000000000802ace <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802ace:	55                   	push   %rbp
  802acf:	48 89 e5             	mov    %rsp,%rbp
  802ad2:	48 83 ec 10          	sub    $0x10,%rsp
  802ad6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ad9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802add:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802ae4:	00 00 00 
  802ae7:	8b 00                	mov    (%rax),%eax
  802ae9:	85 c0                	test   %eax,%eax
  802aeb:	75 1d                	jne    802b0a <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802aed:	bf 01 00 00 00       	mov    $0x1,%edi
  802af2:	48 b8 cd 3a 80 00 00 	movabs $0x803acd,%rax
  802af9:	00 00 00 
  802afc:	ff d0                	callq  *%rax
  802afe:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  802b05:	00 00 00 
  802b08:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b0a:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802b11:	00 00 00 
  802b14:	8b 00                	mov    (%rax),%eax
  802b16:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b19:	b9 07 00 00 00       	mov    $0x7,%ecx
  802b1e:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802b25:	00 00 00 
  802b28:	89 c7                	mov    %eax,%edi
  802b2a:	48 b8 35 3a 80 00 00 	movabs $0x803a35,%rax
  802b31:	00 00 00 
  802b34:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b3a:	ba 00 00 00 00       	mov    $0x0,%edx
  802b3f:	48 89 c6             	mov    %rax,%rsi
  802b42:	bf 00 00 00 00       	mov    $0x0,%edi
  802b47:	48 b8 6c 39 80 00 00 	movabs $0x80396c,%rax
  802b4e:	00 00 00 
  802b51:	ff d0                	callq  *%rax
}
  802b53:	c9                   	leaveq 
  802b54:	c3                   	retq   

0000000000802b55 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802b55:	55                   	push   %rbp
  802b56:	48 89 e5             	mov    %rsp,%rbp
  802b59:	48 83 ec 20          	sub    $0x20,%rsp
  802b5d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b61:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802b64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b68:	48 89 c7             	mov    %rax,%rdi
  802b6b:	48 b8 5c 10 80 00 00 	movabs $0x80105c,%rax
  802b72:	00 00 00 
  802b75:	ff d0                	callq  *%rax
  802b77:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b7c:	7e 0a                	jle    802b88 <open+0x33>
		return -E_BAD_PATH;
  802b7e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b83:	e9 a5 00 00 00       	jmpq   802c2d <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802b88:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b8c:	48 89 c7             	mov    %rax,%rdi
  802b8f:	48 b8 b5 21 80 00 00 	movabs $0x8021b5,%rax
  802b96:	00 00 00 
  802b99:	ff d0                	callq  *%rax
  802b9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba2:	79 08                	jns    802bac <open+0x57>
		return r;
  802ba4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba7:	e9 81 00 00 00       	jmpq   802c2d <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802bac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb0:	48 89 c6             	mov    %rax,%rsi
  802bb3:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802bba:	00 00 00 
  802bbd:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  802bc4:	00 00 00 
  802bc7:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802bc9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bd0:	00 00 00 
  802bd3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802bd6:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802bdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802be0:	48 89 c6             	mov    %rax,%rsi
  802be3:	bf 01 00 00 00       	mov    $0x1,%edi
  802be8:	48 b8 ce 2a 80 00 00 	movabs $0x802ace,%rax
  802bef:	00 00 00 
  802bf2:	ff d0                	callq  *%rax
  802bf4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bf7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bfb:	79 1d                	jns    802c1a <open+0xc5>
		fd_close(fd, 0);
  802bfd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c01:	be 00 00 00 00       	mov    $0x0,%esi
  802c06:	48 89 c7             	mov    %rax,%rdi
  802c09:	48 b8 dd 22 80 00 00 	movabs $0x8022dd,%rax
  802c10:	00 00 00 
  802c13:	ff d0                	callq  *%rax
		return r;
  802c15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c18:	eb 13                	jmp    802c2d <open+0xd8>
	}

	return fd2num(fd);
  802c1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c1e:	48 89 c7             	mov    %rax,%rdi
  802c21:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  802c28:	00 00 00 
  802c2b:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802c2d:	c9                   	leaveq 
  802c2e:	c3                   	retq   

0000000000802c2f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802c2f:	55                   	push   %rbp
  802c30:	48 89 e5             	mov    %rsp,%rbp
  802c33:	48 83 ec 10          	sub    $0x10,%rsp
  802c37:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802c3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c3f:	8b 50 0c             	mov    0xc(%rax),%edx
  802c42:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c49:	00 00 00 
  802c4c:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802c4e:	be 00 00 00 00       	mov    $0x0,%esi
  802c53:	bf 06 00 00 00       	mov    $0x6,%edi
  802c58:	48 b8 ce 2a 80 00 00 	movabs $0x802ace,%rax
  802c5f:	00 00 00 
  802c62:	ff d0                	callq  *%rax
}
  802c64:	c9                   	leaveq 
  802c65:	c3                   	retq   

0000000000802c66 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802c66:	55                   	push   %rbp
  802c67:	48 89 e5             	mov    %rsp,%rbp
  802c6a:	48 83 ec 30          	sub    $0x30,%rsp
  802c6e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c72:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c76:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802c7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7e:	8b 50 0c             	mov    0xc(%rax),%edx
  802c81:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c88:	00 00 00 
  802c8b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802c8d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c94:	00 00 00 
  802c97:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c9b:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802c9f:	be 00 00 00 00       	mov    $0x0,%esi
  802ca4:	bf 03 00 00 00       	mov    $0x3,%edi
  802ca9:	48 b8 ce 2a 80 00 00 	movabs $0x802ace,%rax
  802cb0:	00 00 00 
  802cb3:	ff d0                	callq  *%rax
  802cb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cbc:	79 05                	jns    802cc3 <devfile_read+0x5d>
		return r;
  802cbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc1:	eb 26                	jmp    802ce9 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802cc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc6:	48 63 d0             	movslq %eax,%rdx
  802cc9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ccd:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802cd4:	00 00 00 
  802cd7:	48 89 c7             	mov    %rax,%rdi
  802cda:	48 b8 ec 13 80 00 00 	movabs $0x8013ec,%rax
  802ce1:	00 00 00 
  802ce4:	ff d0                	callq  *%rax

	return r;
  802ce6:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802ce9:	c9                   	leaveq 
  802cea:	c3                   	retq   

0000000000802ceb <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802ceb:	55                   	push   %rbp
  802cec:	48 89 e5             	mov    %rsp,%rbp
  802cef:	48 83 ec 30          	sub    $0x30,%rsp
  802cf3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cf7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cfb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802cff:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802d06:	00 
  802d07:	76 08                	jbe    802d11 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802d09:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802d10:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802d11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d15:	8b 50 0c             	mov    0xc(%rax),%edx
  802d18:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d1f:	00 00 00 
  802d22:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802d24:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d2b:	00 00 00 
  802d2e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d32:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  802d36:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d3a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d3e:	48 89 c6             	mov    %rax,%rsi
  802d41:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802d48:	00 00 00 
  802d4b:	48 b8 ec 13 80 00 00 	movabs $0x8013ec,%rax
  802d52:	00 00 00 
  802d55:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802d57:	be 00 00 00 00       	mov    $0x0,%esi
  802d5c:	bf 04 00 00 00       	mov    $0x4,%edi
  802d61:	48 b8 ce 2a 80 00 00 	movabs $0x802ace,%rax
  802d68:	00 00 00 
  802d6b:	ff d0                	callq  *%rax
  802d6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d74:	79 05                	jns    802d7b <devfile_write+0x90>
		return r;
  802d76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d79:	eb 03                	jmp    802d7e <devfile_write+0x93>

	return r;
  802d7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802d7e:	c9                   	leaveq 
  802d7f:	c3                   	retq   

0000000000802d80 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802d80:	55                   	push   %rbp
  802d81:	48 89 e5             	mov    %rsp,%rbp
  802d84:	48 83 ec 20          	sub    $0x20,%rsp
  802d88:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d8c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802d90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d94:	8b 50 0c             	mov    0xc(%rax),%edx
  802d97:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d9e:	00 00 00 
  802da1:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802da3:	be 00 00 00 00       	mov    $0x0,%esi
  802da8:	bf 05 00 00 00       	mov    $0x5,%edi
  802dad:	48 b8 ce 2a 80 00 00 	movabs $0x802ace,%rax
  802db4:	00 00 00 
  802db7:	ff d0                	callq  *%rax
  802db9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc0:	79 05                	jns    802dc7 <devfile_stat+0x47>
		return r;
  802dc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc5:	eb 56                	jmp    802e1d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802dc7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dcb:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802dd2:	00 00 00 
  802dd5:	48 89 c7             	mov    %rax,%rdi
  802dd8:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  802ddf:	00 00 00 
  802de2:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802de4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802deb:	00 00 00 
  802dee:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802df4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802df8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802dfe:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e05:	00 00 00 
  802e08:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802e0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e12:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802e18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e1d:	c9                   	leaveq 
  802e1e:	c3                   	retq   

0000000000802e1f <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802e1f:	55                   	push   %rbp
  802e20:	48 89 e5             	mov    %rsp,%rbp
  802e23:	48 83 ec 10          	sub    $0x10,%rsp
  802e27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e2b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802e2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e32:	8b 50 0c             	mov    0xc(%rax),%edx
  802e35:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e3c:	00 00 00 
  802e3f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802e41:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e48:	00 00 00 
  802e4b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e4e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802e51:	be 00 00 00 00       	mov    $0x0,%esi
  802e56:	bf 02 00 00 00       	mov    $0x2,%edi
  802e5b:	48 b8 ce 2a 80 00 00 	movabs $0x802ace,%rax
  802e62:	00 00 00 
  802e65:	ff d0                	callq  *%rax
}
  802e67:	c9                   	leaveq 
  802e68:	c3                   	retq   

0000000000802e69 <remove>:

// Delete a file
int
remove(const char *path)
{
  802e69:	55                   	push   %rbp
  802e6a:	48 89 e5             	mov    %rsp,%rbp
  802e6d:	48 83 ec 10          	sub    $0x10,%rsp
  802e71:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802e75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e79:	48 89 c7             	mov    %rax,%rdi
  802e7c:	48 b8 5c 10 80 00 00 	movabs $0x80105c,%rax
  802e83:	00 00 00 
  802e86:	ff d0                	callq  *%rax
  802e88:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e8d:	7e 07                	jle    802e96 <remove+0x2d>
		return -E_BAD_PATH;
  802e8f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e94:	eb 33                	jmp    802ec9 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802e96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e9a:	48 89 c6             	mov    %rax,%rsi
  802e9d:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802ea4:	00 00 00 
  802ea7:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  802eae:	00 00 00 
  802eb1:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802eb3:	be 00 00 00 00       	mov    $0x0,%esi
  802eb8:	bf 07 00 00 00       	mov    $0x7,%edi
  802ebd:	48 b8 ce 2a 80 00 00 	movabs $0x802ace,%rax
  802ec4:	00 00 00 
  802ec7:	ff d0                	callq  *%rax
}
  802ec9:	c9                   	leaveq 
  802eca:	c3                   	retq   

0000000000802ecb <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802ecb:	55                   	push   %rbp
  802ecc:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802ecf:	be 00 00 00 00       	mov    $0x0,%esi
  802ed4:	bf 08 00 00 00       	mov    $0x8,%edi
  802ed9:	48 b8 ce 2a 80 00 00 	movabs $0x802ace,%rax
  802ee0:	00 00 00 
  802ee3:	ff d0                	callq  *%rax
}
  802ee5:	5d                   	pop    %rbp
  802ee6:	c3                   	retq   

0000000000802ee7 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802ee7:	55                   	push   %rbp
  802ee8:	48 89 e5             	mov    %rsp,%rbp
  802eeb:	53                   	push   %rbx
  802eec:	48 83 ec 38          	sub    $0x38,%rsp
  802ef0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802ef4:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802ef8:	48 89 c7             	mov    %rax,%rdi
  802efb:	48 b8 b5 21 80 00 00 	movabs $0x8021b5,%rax
  802f02:	00 00 00 
  802f05:	ff d0                	callq  *%rax
  802f07:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f0a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f0e:	0f 88 bf 01 00 00    	js     8030d3 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f18:	ba 07 04 00 00       	mov    $0x407,%edx
  802f1d:	48 89 c6             	mov    %rax,%rsi
  802f20:	bf 00 00 00 00       	mov    $0x0,%edi
  802f25:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  802f2c:	00 00 00 
  802f2f:	ff d0                	callq  *%rax
  802f31:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f34:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f38:	0f 88 95 01 00 00    	js     8030d3 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802f3e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802f42:	48 89 c7             	mov    %rax,%rdi
  802f45:	48 b8 b5 21 80 00 00 	movabs $0x8021b5,%rax
  802f4c:	00 00 00 
  802f4f:	ff d0                	callq  *%rax
  802f51:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f54:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f58:	0f 88 5d 01 00 00    	js     8030bb <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f62:	ba 07 04 00 00       	mov    $0x407,%edx
  802f67:	48 89 c6             	mov    %rax,%rsi
  802f6a:	bf 00 00 00 00       	mov    $0x0,%edi
  802f6f:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  802f76:	00 00 00 
  802f79:	ff d0                	callq  *%rax
  802f7b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f82:	0f 88 33 01 00 00    	js     8030bb <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802f88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f8c:	48 89 c7             	mov    %rax,%rdi
  802f8f:	48 b8 8a 21 80 00 00 	movabs $0x80218a,%rax
  802f96:	00 00 00 
  802f99:	ff d0                	callq  *%rax
  802f9b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fa3:	ba 07 04 00 00       	mov    $0x407,%edx
  802fa8:	48 89 c6             	mov    %rax,%rsi
  802fab:	bf 00 00 00 00       	mov    $0x0,%edi
  802fb0:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  802fb7:	00 00 00 
  802fba:	ff d0                	callq  *%rax
  802fbc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fbf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fc3:	79 05                	jns    802fca <pipe+0xe3>
		goto err2;
  802fc5:	e9 d9 00 00 00       	jmpq   8030a3 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fce:	48 89 c7             	mov    %rax,%rdi
  802fd1:	48 b8 8a 21 80 00 00 	movabs $0x80218a,%rax
  802fd8:	00 00 00 
  802fdb:	ff d0                	callq  *%rax
  802fdd:	48 89 c2             	mov    %rax,%rdx
  802fe0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fe4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802fea:	48 89 d1             	mov    %rdx,%rcx
  802fed:	ba 00 00 00 00       	mov    $0x0,%edx
  802ff2:	48 89 c6             	mov    %rax,%rsi
  802ff5:	bf 00 00 00 00       	mov    $0x0,%edi
  802ffa:	48 b8 47 1a 80 00 00 	movabs $0x801a47,%rax
  803001:	00 00 00 
  803004:	ff d0                	callq  *%rax
  803006:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803009:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80300d:	79 1b                	jns    80302a <pipe+0x143>
		goto err3;
  80300f:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803010:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803014:	48 89 c6             	mov    %rax,%rsi
  803017:	bf 00 00 00 00       	mov    $0x0,%edi
  80301c:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  803023:	00 00 00 
  803026:	ff d0                	callq  *%rax
  803028:	eb 79                	jmp    8030a3 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80302a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80302e:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  803035:	00 00 00 
  803038:	8b 12                	mov    (%rdx),%edx
  80303a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80303c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803040:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803047:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80304b:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  803052:	00 00 00 
  803055:	8b 12                	mov    (%rdx),%edx
  803057:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803059:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80305d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803064:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803068:	48 89 c7             	mov    %rax,%rdi
  80306b:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  803072:	00 00 00 
  803075:	ff d0                	callq  *%rax
  803077:	89 c2                	mov    %eax,%edx
  803079:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80307d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80307f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803083:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803087:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80308b:	48 89 c7             	mov    %rax,%rdi
  80308e:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  803095:	00 00 00 
  803098:	ff d0                	callq  *%rax
  80309a:	89 03                	mov    %eax,(%rbx)
	return 0;
  80309c:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a1:	eb 33                	jmp    8030d6 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8030a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030a7:	48 89 c6             	mov    %rax,%rsi
  8030aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8030af:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  8030b6:	00 00 00 
  8030b9:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8030bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030bf:	48 89 c6             	mov    %rax,%rsi
  8030c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8030c7:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  8030ce:	00 00 00 
  8030d1:	ff d0                	callq  *%rax
    err:
	return r;
  8030d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8030d6:	48 83 c4 38          	add    $0x38,%rsp
  8030da:	5b                   	pop    %rbx
  8030db:	5d                   	pop    %rbp
  8030dc:	c3                   	retq   

00000000008030dd <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8030dd:	55                   	push   %rbp
  8030de:	48 89 e5             	mov    %rsp,%rbp
  8030e1:	53                   	push   %rbx
  8030e2:	48 83 ec 28          	sub    $0x28,%rsp
  8030e6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8030ea:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8030ee:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8030f5:	00 00 00 
  8030f8:	48 8b 00             	mov    (%rax),%rax
  8030fb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803101:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803104:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803108:	48 89 c7             	mov    %rax,%rdi
  80310b:	48 b8 4f 3b 80 00 00 	movabs $0x803b4f,%rax
  803112:	00 00 00 
  803115:	ff d0                	callq  *%rax
  803117:	89 c3                	mov    %eax,%ebx
  803119:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80311d:	48 89 c7             	mov    %rax,%rdi
  803120:	48 b8 4f 3b 80 00 00 	movabs $0x803b4f,%rax
  803127:	00 00 00 
  80312a:	ff d0                	callq  *%rax
  80312c:	39 c3                	cmp    %eax,%ebx
  80312e:	0f 94 c0             	sete   %al
  803131:	0f b6 c0             	movzbl %al,%eax
  803134:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803137:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80313e:	00 00 00 
  803141:	48 8b 00             	mov    (%rax),%rax
  803144:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80314a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80314d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803150:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803153:	75 05                	jne    80315a <_pipeisclosed+0x7d>
			return ret;
  803155:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803158:	eb 4f                	jmp    8031a9 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80315a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80315d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803160:	74 42                	je     8031a4 <_pipeisclosed+0xc7>
  803162:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803166:	75 3c                	jne    8031a4 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803168:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80316f:	00 00 00 
  803172:	48 8b 00             	mov    (%rax),%rax
  803175:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80317b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80317e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803181:	89 c6                	mov    %eax,%esi
  803183:	48 bf 2b 42 80 00 00 	movabs $0x80422b,%rdi
  80318a:	00 00 00 
  80318d:	b8 00 00 00 00       	mov    $0x0,%eax
  803192:	49 b8 20 03 80 00 00 	movabs $0x800320,%r8
  803199:	00 00 00 
  80319c:	41 ff d0             	callq  *%r8
	}
  80319f:	e9 4a ff ff ff       	jmpq   8030ee <_pipeisclosed+0x11>
  8031a4:	e9 45 ff ff ff       	jmpq   8030ee <_pipeisclosed+0x11>
}
  8031a9:	48 83 c4 28          	add    $0x28,%rsp
  8031ad:	5b                   	pop    %rbx
  8031ae:	5d                   	pop    %rbp
  8031af:	c3                   	retq   

00000000008031b0 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8031b0:	55                   	push   %rbp
  8031b1:	48 89 e5             	mov    %rsp,%rbp
  8031b4:	48 83 ec 30          	sub    $0x30,%rsp
  8031b8:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031bb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031bf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031c2:	48 89 d6             	mov    %rdx,%rsi
  8031c5:	89 c7                	mov    %eax,%edi
  8031c7:	48 b8 4d 22 80 00 00 	movabs $0x80224d,%rax
  8031ce:	00 00 00 
  8031d1:	ff d0                	callq  *%rax
  8031d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031da:	79 05                	jns    8031e1 <pipeisclosed+0x31>
		return r;
  8031dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031df:	eb 31                	jmp    803212 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8031e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031e5:	48 89 c7             	mov    %rax,%rdi
  8031e8:	48 b8 8a 21 80 00 00 	movabs $0x80218a,%rax
  8031ef:	00 00 00 
  8031f2:	ff d0                	callq  *%rax
  8031f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8031f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803200:	48 89 d6             	mov    %rdx,%rsi
  803203:	48 89 c7             	mov    %rax,%rdi
  803206:	48 b8 dd 30 80 00 00 	movabs $0x8030dd,%rax
  80320d:	00 00 00 
  803210:	ff d0                	callq  *%rax
}
  803212:	c9                   	leaveq 
  803213:	c3                   	retq   

0000000000803214 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803214:	55                   	push   %rbp
  803215:	48 89 e5             	mov    %rsp,%rbp
  803218:	48 83 ec 40          	sub    $0x40,%rsp
  80321c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803220:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803224:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803228:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80322c:	48 89 c7             	mov    %rax,%rdi
  80322f:	48 b8 8a 21 80 00 00 	movabs $0x80218a,%rax
  803236:	00 00 00 
  803239:	ff d0                	callq  *%rax
  80323b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80323f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803243:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803247:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80324e:	00 
  80324f:	e9 92 00 00 00       	jmpq   8032e6 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803254:	eb 41                	jmp    803297 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803256:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80325b:	74 09                	je     803266 <devpipe_read+0x52>
				return i;
  80325d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803261:	e9 92 00 00 00       	jmpq   8032f8 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803266:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80326a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80326e:	48 89 d6             	mov    %rdx,%rsi
  803271:	48 89 c7             	mov    %rax,%rdi
  803274:	48 b8 dd 30 80 00 00 	movabs $0x8030dd,%rax
  80327b:	00 00 00 
  80327e:	ff d0                	callq  *%rax
  803280:	85 c0                	test   %eax,%eax
  803282:	74 07                	je     80328b <devpipe_read+0x77>
				return 0;
  803284:	b8 00 00 00 00       	mov    $0x0,%eax
  803289:	eb 6d                	jmp    8032f8 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80328b:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  803292:	00 00 00 
  803295:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803297:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80329b:	8b 10                	mov    (%rax),%edx
  80329d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a1:	8b 40 04             	mov    0x4(%rax),%eax
  8032a4:	39 c2                	cmp    %eax,%edx
  8032a6:	74 ae                	je     803256 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8032a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032b0:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8032b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b8:	8b 00                	mov    (%rax),%eax
  8032ba:	99                   	cltd   
  8032bb:	c1 ea 1b             	shr    $0x1b,%edx
  8032be:	01 d0                	add    %edx,%eax
  8032c0:	83 e0 1f             	and    $0x1f,%eax
  8032c3:	29 d0                	sub    %edx,%eax
  8032c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032c9:	48 98                	cltq   
  8032cb:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8032d0:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8032d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d6:	8b 00                	mov    (%rax),%eax
  8032d8:	8d 50 01             	lea    0x1(%rax),%edx
  8032db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032df:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8032e1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8032e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032ea:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8032ee:	0f 82 60 ff ff ff    	jb     803254 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8032f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8032f8:	c9                   	leaveq 
  8032f9:	c3                   	retq   

00000000008032fa <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8032fa:	55                   	push   %rbp
  8032fb:	48 89 e5             	mov    %rsp,%rbp
  8032fe:	48 83 ec 40          	sub    $0x40,%rsp
  803302:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803306:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80330a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80330e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803312:	48 89 c7             	mov    %rax,%rdi
  803315:	48 b8 8a 21 80 00 00 	movabs $0x80218a,%rax
  80331c:	00 00 00 
  80331f:	ff d0                	callq  *%rax
  803321:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803325:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803329:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80332d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803334:	00 
  803335:	e9 8e 00 00 00       	jmpq   8033c8 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80333a:	eb 31                	jmp    80336d <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80333c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803340:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803344:	48 89 d6             	mov    %rdx,%rsi
  803347:	48 89 c7             	mov    %rax,%rdi
  80334a:	48 b8 dd 30 80 00 00 	movabs $0x8030dd,%rax
  803351:	00 00 00 
  803354:	ff d0                	callq  *%rax
  803356:	85 c0                	test   %eax,%eax
  803358:	74 07                	je     803361 <devpipe_write+0x67>
				return 0;
  80335a:	b8 00 00 00 00       	mov    $0x0,%eax
  80335f:	eb 79                	jmp    8033da <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803361:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  803368:	00 00 00 
  80336b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80336d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803371:	8b 40 04             	mov    0x4(%rax),%eax
  803374:	48 63 d0             	movslq %eax,%rdx
  803377:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337b:	8b 00                	mov    (%rax),%eax
  80337d:	48 98                	cltq   
  80337f:	48 83 c0 20          	add    $0x20,%rax
  803383:	48 39 c2             	cmp    %rax,%rdx
  803386:	73 b4                	jae    80333c <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803388:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80338c:	8b 40 04             	mov    0x4(%rax),%eax
  80338f:	99                   	cltd   
  803390:	c1 ea 1b             	shr    $0x1b,%edx
  803393:	01 d0                	add    %edx,%eax
  803395:	83 e0 1f             	and    $0x1f,%eax
  803398:	29 d0                	sub    %edx,%eax
  80339a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80339e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8033a2:	48 01 ca             	add    %rcx,%rdx
  8033a5:	0f b6 0a             	movzbl (%rdx),%ecx
  8033a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033ac:	48 98                	cltq   
  8033ae:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8033b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033b6:	8b 40 04             	mov    0x4(%rax),%eax
  8033b9:	8d 50 01             	lea    0x1(%rax),%edx
  8033bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033c0:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8033c3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8033c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033cc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8033d0:	0f 82 64 ff ff ff    	jb     80333a <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8033d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8033da:	c9                   	leaveq 
  8033db:	c3                   	retq   

00000000008033dc <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8033dc:	55                   	push   %rbp
  8033dd:	48 89 e5             	mov    %rsp,%rbp
  8033e0:	48 83 ec 20          	sub    $0x20,%rsp
  8033e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8033ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f0:	48 89 c7             	mov    %rax,%rdi
  8033f3:	48 b8 8a 21 80 00 00 	movabs $0x80218a,%rax
  8033fa:	00 00 00 
  8033fd:	ff d0                	callq  *%rax
  8033ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803403:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803407:	48 be 3e 42 80 00 00 	movabs $0x80423e,%rsi
  80340e:	00 00 00 
  803411:	48 89 c7             	mov    %rax,%rdi
  803414:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  80341b:	00 00 00 
  80341e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803420:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803424:	8b 50 04             	mov    0x4(%rax),%edx
  803427:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80342b:	8b 00                	mov    (%rax),%eax
  80342d:	29 c2                	sub    %eax,%edx
  80342f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803433:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803439:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80343d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803444:	00 00 00 
	stat->st_dev = &devpipe;
  803447:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80344b:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  803452:	00 00 00 
  803455:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80345c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803461:	c9                   	leaveq 
  803462:	c3                   	retq   

0000000000803463 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803463:	55                   	push   %rbp
  803464:	48 89 e5             	mov    %rsp,%rbp
  803467:	48 83 ec 10          	sub    $0x10,%rsp
  80346b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80346f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803473:	48 89 c6             	mov    %rax,%rsi
  803476:	bf 00 00 00 00       	mov    $0x0,%edi
  80347b:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  803482:	00 00 00 
  803485:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803487:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80348b:	48 89 c7             	mov    %rax,%rdi
  80348e:	48 b8 8a 21 80 00 00 	movabs $0x80218a,%rax
  803495:	00 00 00 
  803498:	ff d0                	callq  *%rax
  80349a:	48 89 c6             	mov    %rax,%rsi
  80349d:	bf 00 00 00 00       	mov    $0x0,%edi
  8034a2:	48 b8 a2 1a 80 00 00 	movabs $0x801aa2,%rax
  8034a9:	00 00 00 
  8034ac:	ff d0                	callq  *%rax
}
  8034ae:	c9                   	leaveq 
  8034af:	c3                   	retq   

00000000008034b0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8034b0:	55                   	push   %rbp
  8034b1:	48 89 e5             	mov    %rsp,%rbp
  8034b4:	48 83 ec 20          	sub    $0x20,%rsp
  8034b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8034bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034be:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8034c1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8034c5:	be 01 00 00 00       	mov    $0x1,%esi
  8034ca:	48 89 c7             	mov    %rax,%rdi
  8034cd:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  8034d4:	00 00 00 
  8034d7:	ff d0                	callq  *%rax
}
  8034d9:	c9                   	leaveq 
  8034da:	c3                   	retq   

00000000008034db <getchar>:

int
getchar(void)
{
  8034db:	55                   	push   %rbp
  8034dc:	48 89 e5             	mov    %rsp,%rbp
  8034df:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8034e3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8034e7:	ba 01 00 00 00       	mov    $0x1,%edx
  8034ec:	48 89 c6             	mov    %rax,%rsi
  8034ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8034f4:	48 b8 7f 26 80 00 00 	movabs $0x80267f,%rax
  8034fb:	00 00 00 
  8034fe:	ff d0                	callq  *%rax
  803500:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803503:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803507:	79 05                	jns    80350e <getchar+0x33>
		return r;
  803509:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350c:	eb 14                	jmp    803522 <getchar+0x47>
	if (r < 1)
  80350e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803512:	7f 07                	jg     80351b <getchar+0x40>
		return -E_EOF;
  803514:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803519:	eb 07                	jmp    803522 <getchar+0x47>
	return c;
  80351b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80351f:	0f b6 c0             	movzbl %al,%eax
}
  803522:	c9                   	leaveq 
  803523:	c3                   	retq   

0000000000803524 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803524:	55                   	push   %rbp
  803525:	48 89 e5             	mov    %rsp,%rbp
  803528:	48 83 ec 20          	sub    $0x20,%rsp
  80352c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80352f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803533:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803536:	48 89 d6             	mov    %rdx,%rsi
  803539:	89 c7                	mov    %eax,%edi
  80353b:	48 b8 4d 22 80 00 00 	movabs $0x80224d,%rax
  803542:	00 00 00 
  803545:	ff d0                	callq  *%rax
  803547:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80354a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80354e:	79 05                	jns    803555 <iscons+0x31>
		return r;
  803550:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803553:	eb 1a                	jmp    80356f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803555:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803559:	8b 10                	mov    (%rax),%edx
  80355b:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803562:	00 00 00 
  803565:	8b 00                	mov    (%rax),%eax
  803567:	39 c2                	cmp    %eax,%edx
  803569:	0f 94 c0             	sete   %al
  80356c:	0f b6 c0             	movzbl %al,%eax
}
  80356f:	c9                   	leaveq 
  803570:	c3                   	retq   

0000000000803571 <opencons>:

int
opencons(void)
{
  803571:	55                   	push   %rbp
  803572:	48 89 e5             	mov    %rsp,%rbp
  803575:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803579:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80357d:	48 89 c7             	mov    %rax,%rdi
  803580:	48 b8 b5 21 80 00 00 	movabs $0x8021b5,%rax
  803587:	00 00 00 
  80358a:	ff d0                	callq  *%rax
  80358c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80358f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803593:	79 05                	jns    80359a <opencons+0x29>
		return r;
  803595:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803598:	eb 5b                	jmp    8035f5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80359a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80359e:	ba 07 04 00 00       	mov    $0x407,%edx
  8035a3:	48 89 c6             	mov    %rax,%rsi
  8035a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ab:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  8035b2:	00 00 00 
  8035b5:	ff d0                	callq  *%rax
  8035b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035be:	79 05                	jns    8035c5 <opencons+0x54>
		return r;
  8035c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c3:	eb 30                	jmp    8035f5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8035c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035c9:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8035d0:	00 00 00 
  8035d3:	8b 12                	mov    (%rdx),%edx
  8035d5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8035d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035db:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8035e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e6:	48 89 c7             	mov    %rax,%rdi
  8035e9:	48 b8 67 21 80 00 00 	movabs $0x802167,%rax
  8035f0:	00 00 00 
  8035f3:	ff d0                	callq  *%rax
}
  8035f5:	c9                   	leaveq 
  8035f6:	c3                   	retq   

00000000008035f7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8035f7:	55                   	push   %rbp
  8035f8:	48 89 e5             	mov    %rsp,%rbp
  8035fb:	48 83 ec 30          	sub    $0x30,%rsp
  8035ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803603:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803607:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80360b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803610:	75 07                	jne    803619 <devcons_read+0x22>
		return 0;
  803612:	b8 00 00 00 00       	mov    $0x0,%eax
  803617:	eb 4b                	jmp    803664 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803619:	eb 0c                	jmp    803627 <devcons_read+0x30>
		sys_yield();
  80361b:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  803622:	00 00 00 
  803625:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803627:	48 b8 f9 18 80 00 00 	movabs $0x8018f9,%rax
  80362e:	00 00 00 
  803631:	ff d0                	callq  *%rax
  803633:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803636:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80363a:	74 df                	je     80361b <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80363c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803640:	79 05                	jns    803647 <devcons_read+0x50>
		return c;
  803642:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803645:	eb 1d                	jmp    803664 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803647:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80364b:	75 07                	jne    803654 <devcons_read+0x5d>
		return 0;
  80364d:	b8 00 00 00 00       	mov    $0x0,%eax
  803652:	eb 10                	jmp    803664 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803654:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803657:	89 c2                	mov    %eax,%edx
  803659:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80365d:	88 10                	mov    %dl,(%rax)
	return 1;
  80365f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803664:	c9                   	leaveq 
  803665:	c3                   	retq   

0000000000803666 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803666:	55                   	push   %rbp
  803667:	48 89 e5             	mov    %rsp,%rbp
  80366a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803671:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803678:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80367f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803686:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80368d:	eb 76                	jmp    803705 <devcons_write+0x9f>
		m = n - tot;
  80368f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803696:	89 c2                	mov    %eax,%edx
  803698:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80369b:	29 c2                	sub    %eax,%edx
  80369d:	89 d0                	mov    %edx,%eax
  80369f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8036a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036a5:	83 f8 7f             	cmp    $0x7f,%eax
  8036a8:	76 07                	jbe    8036b1 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8036aa:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8036b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036b4:	48 63 d0             	movslq %eax,%rdx
  8036b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ba:	48 63 c8             	movslq %eax,%rcx
  8036bd:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8036c4:	48 01 c1             	add    %rax,%rcx
  8036c7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8036ce:	48 89 ce             	mov    %rcx,%rsi
  8036d1:	48 89 c7             	mov    %rax,%rdi
  8036d4:	48 b8 ec 13 80 00 00 	movabs $0x8013ec,%rax
  8036db:	00 00 00 
  8036de:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8036e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036e3:	48 63 d0             	movslq %eax,%rdx
  8036e6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8036ed:	48 89 d6             	mov    %rdx,%rsi
  8036f0:	48 89 c7             	mov    %rax,%rdi
  8036f3:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  8036fa:	00 00 00 
  8036fd:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8036ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803702:	01 45 fc             	add    %eax,-0x4(%rbp)
  803705:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803708:	48 98                	cltq   
  80370a:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803711:	0f 82 78 ff ff ff    	jb     80368f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803717:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80371a:	c9                   	leaveq 
  80371b:	c3                   	retq   

000000000080371c <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80371c:	55                   	push   %rbp
  80371d:	48 89 e5             	mov    %rsp,%rbp
  803720:	48 83 ec 08          	sub    $0x8,%rsp
  803724:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803728:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80372d:	c9                   	leaveq 
  80372e:	c3                   	retq   

000000000080372f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80372f:	55                   	push   %rbp
  803730:	48 89 e5             	mov    %rsp,%rbp
  803733:	48 83 ec 10          	sub    $0x10,%rsp
  803737:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80373b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80373f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803743:	48 be 4a 42 80 00 00 	movabs $0x80424a,%rsi
  80374a:	00 00 00 
  80374d:	48 89 c7             	mov    %rax,%rdi
  803750:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  803757:	00 00 00 
  80375a:	ff d0                	callq  *%rax
	return 0;
  80375c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803761:	c9                   	leaveq 
  803762:	c3                   	retq   

0000000000803763 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803763:	55                   	push   %rbp
  803764:	48 89 e5             	mov    %rsp,%rbp
  803767:	53                   	push   %rbx
  803768:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80376f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803776:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80377c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803783:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80378a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803791:	84 c0                	test   %al,%al
  803793:	74 23                	je     8037b8 <_panic+0x55>
  803795:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80379c:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8037a0:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8037a4:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8037a8:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8037ac:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8037b0:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8037b4:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8037b8:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8037bf:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8037c6:	00 00 00 
  8037c9:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8037d0:	00 00 00 
  8037d3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8037d7:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8037de:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8037e5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8037ec:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8037f3:	00 00 00 
  8037f6:	48 8b 18             	mov    (%rax),%rbx
  8037f9:	48 b8 7b 19 80 00 00 	movabs $0x80197b,%rax
  803800:	00 00 00 
  803803:	ff d0                	callq  *%rax
  803805:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80380b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803812:	41 89 c8             	mov    %ecx,%r8d
  803815:	48 89 d1             	mov    %rdx,%rcx
  803818:	48 89 da             	mov    %rbx,%rdx
  80381b:	89 c6                	mov    %eax,%esi
  80381d:	48 bf 58 42 80 00 00 	movabs $0x804258,%rdi
  803824:	00 00 00 
  803827:	b8 00 00 00 00       	mov    $0x0,%eax
  80382c:	49 b9 20 03 80 00 00 	movabs $0x800320,%r9
  803833:	00 00 00 
  803836:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803839:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803840:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803847:	48 89 d6             	mov    %rdx,%rsi
  80384a:	48 89 c7             	mov    %rax,%rdi
  80384d:	48 b8 74 02 80 00 00 	movabs $0x800274,%rax
  803854:	00 00 00 
  803857:	ff d0                	callq  *%rax
	cprintf("\n");
  803859:	48 bf 7b 42 80 00 00 	movabs $0x80427b,%rdi
  803860:	00 00 00 
  803863:	b8 00 00 00 00       	mov    $0x0,%eax
  803868:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  80386f:	00 00 00 
  803872:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803874:	cc                   	int3   
  803875:	eb fd                	jmp    803874 <_panic+0x111>

0000000000803877 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803877:	55                   	push   %rbp
  803878:	48 89 e5             	mov    %rsp,%rbp
  80387b:	48 83 ec 10          	sub    $0x10,%rsp
  80387f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803883:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80388a:	00 00 00 
  80388d:	48 8b 00             	mov    (%rax),%rax
  803890:	48 85 c0             	test   %rax,%rax
  803893:	75 3a                	jne    8038cf <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  803895:	ba 07 00 00 00       	mov    $0x7,%edx
  80389a:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80389f:	bf 00 00 00 00       	mov    $0x0,%edi
  8038a4:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  8038ab:	00 00 00 
  8038ae:	ff d0                	callq  *%rax
  8038b0:	85 c0                	test   %eax,%eax
  8038b2:	75 1b                	jne    8038cf <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8038b4:	48 be e2 38 80 00 00 	movabs $0x8038e2,%rsi
  8038bb:	00 00 00 
  8038be:	bf 00 00 00 00       	mov    $0x0,%edi
  8038c3:	48 b8 81 1b 80 00 00 	movabs $0x801b81,%rax
  8038ca:	00 00 00 
  8038cd:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8038cf:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8038d6:	00 00 00 
  8038d9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038dd:	48 89 10             	mov    %rdx,(%rax)
}
  8038e0:	c9                   	leaveq 
  8038e1:	c3                   	retq   

00000000008038e2 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  8038e2:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  8038e5:	48 a1 08 80 80 00 00 	movabs 0x808008,%rax
  8038ec:	00 00 00 
	call *%rax
  8038ef:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  8038f1:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  8038f4:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8038fb:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  8038fc:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  803903:	00 
	pushq %rbx		// push utf_rip into new stack
  803904:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  803905:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  80390c:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  80390f:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  803913:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  803917:	4c 8b 3c 24          	mov    (%rsp),%r15
  80391b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803920:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803925:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80392a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80392f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803934:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803939:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80393e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803943:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803948:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80394d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803952:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803957:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80395c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803961:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  803965:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  803969:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  80396a:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80396b:	c3                   	retq   

000000000080396c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80396c:	55                   	push   %rbp
  80396d:	48 89 e5             	mov    %rsp,%rbp
  803970:	48 83 ec 30          	sub    $0x30,%rsp
  803974:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803978:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80397c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803980:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803984:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803988:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80398d:	75 0e                	jne    80399d <ipc_recv+0x31>
		page = (void *)KERNBASE;
  80398f:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803996:	00 00 00 
  803999:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  80399d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039a1:	48 89 c7             	mov    %rax,%rdi
  8039a4:	48 b8 20 1c 80 00 00 	movabs $0x801c20,%rax
  8039ab:	00 00 00 
  8039ae:	ff d0                	callq  *%rax
  8039b0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8039b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8039b7:	79 27                	jns    8039e0 <ipc_recv+0x74>
		if (from_env_store != NULL)
  8039b9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8039be:	74 0a                	je     8039ca <ipc_recv+0x5e>
			*from_env_store = 0;
  8039c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039c4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  8039ca:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039cf:	74 0a                	je     8039db <ipc_recv+0x6f>
			*perm_store = 0;
  8039d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8039db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039de:	eb 53                	jmp    803a33 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  8039e0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8039e5:	74 19                	je     803a00 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  8039e7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8039ee:	00 00 00 
  8039f1:	48 8b 00             	mov    (%rax),%rax
  8039f4:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8039fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039fe:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  803a00:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a05:	74 19                	je     803a20 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803a07:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803a0e:	00 00 00 
  803a11:	48 8b 00             	mov    (%rax),%rax
  803a14:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803a1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a1e:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  803a20:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803a27:	00 00 00 
  803a2a:	48 8b 00             	mov    (%rax),%rax
  803a2d:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803a33:	c9                   	leaveq 
  803a34:	c3                   	retq   

0000000000803a35 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a35:	55                   	push   %rbp
  803a36:	48 89 e5             	mov    %rsp,%rbp
  803a39:	48 83 ec 30          	sub    $0x30,%rsp
  803a3d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a40:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a43:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803a47:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803a4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a4e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803a52:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803a57:	75 10                	jne    803a69 <ipc_send+0x34>
		page = (void *)KERNBASE;
  803a59:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803a60:	00 00 00 
  803a63:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803a67:	eb 0e                	jmp    803a77 <ipc_send+0x42>
  803a69:	eb 0c                	jmp    803a77 <ipc_send+0x42>
		sys_yield();
  803a6b:	48 b8 b9 19 80 00 00 	movabs $0x8019b9,%rax
  803a72:	00 00 00 
  803a75:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803a77:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803a7a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803a7d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a81:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a84:	89 c7                	mov    %eax,%edi
  803a86:	48 b8 cb 1b 80 00 00 	movabs $0x801bcb,%rax
  803a8d:	00 00 00 
  803a90:	ff d0                	callq  *%rax
  803a92:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803a95:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  803a99:	74 d0                	je     803a6b <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  803a9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803a9f:	74 2a                	je     803acb <ipc_send+0x96>
		panic("error on ipc send procedure");
  803aa1:	48 ba 7d 42 80 00 00 	movabs $0x80427d,%rdx
  803aa8:	00 00 00 
  803aab:	be 49 00 00 00       	mov    $0x49,%esi
  803ab0:	48 bf 99 42 80 00 00 	movabs $0x804299,%rdi
  803ab7:	00 00 00 
  803aba:	b8 00 00 00 00       	mov    $0x0,%eax
  803abf:	48 b9 63 37 80 00 00 	movabs $0x803763,%rcx
  803ac6:	00 00 00 
  803ac9:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  803acb:	c9                   	leaveq 
  803acc:	c3                   	retq   

0000000000803acd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803acd:	55                   	push   %rbp
  803ace:	48 89 e5             	mov    %rsp,%rbp
  803ad1:	48 83 ec 14          	sub    $0x14,%rsp
  803ad5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803ad8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803adf:	eb 5e                	jmp    803b3f <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803ae1:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ae8:	00 00 00 
  803aeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aee:	48 63 d0             	movslq %eax,%rdx
  803af1:	48 89 d0             	mov    %rdx,%rax
  803af4:	48 c1 e0 03          	shl    $0x3,%rax
  803af8:	48 01 d0             	add    %rdx,%rax
  803afb:	48 c1 e0 05          	shl    $0x5,%rax
  803aff:	48 01 c8             	add    %rcx,%rax
  803b02:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803b08:	8b 00                	mov    (%rax),%eax
  803b0a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b0d:	75 2c                	jne    803b3b <ipc_find_env+0x6e>
			return envs[i].env_id;
  803b0f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b16:	00 00 00 
  803b19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b1c:	48 63 d0             	movslq %eax,%rdx
  803b1f:	48 89 d0             	mov    %rdx,%rax
  803b22:	48 c1 e0 03          	shl    $0x3,%rax
  803b26:	48 01 d0             	add    %rdx,%rax
  803b29:	48 c1 e0 05          	shl    $0x5,%rax
  803b2d:	48 01 c8             	add    %rcx,%rax
  803b30:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803b36:	8b 40 08             	mov    0x8(%rax),%eax
  803b39:	eb 12                	jmp    803b4d <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803b3b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803b3f:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803b46:	7e 99                	jle    803ae1 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803b48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b4d:	c9                   	leaveq 
  803b4e:	c3                   	retq   

0000000000803b4f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803b4f:	55                   	push   %rbp
  803b50:	48 89 e5             	mov    %rsp,%rbp
  803b53:	48 83 ec 18          	sub    $0x18,%rsp
  803b57:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803b5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b5f:	48 c1 e8 15          	shr    $0x15,%rax
  803b63:	48 89 c2             	mov    %rax,%rdx
  803b66:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803b6d:	01 00 00 
  803b70:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b74:	83 e0 01             	and    $0x1,%eax
  803b77:	48 85 c0             	test   %rax,%rax
  803b7a:	75 07                	jne    803b83 <pageref+0x34>
		return 0;
  803b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  803b81:	eb 53                	jmp    803bd6 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803b83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b87:	48 c1 e8 0c          	shr    $0xc,%rax
  803b8b:	48 89 c2             	mov    %rax,%rdx
  803b8e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803b95:	01 00 00 
  803b98:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b9c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803ba0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ba4:	83 e0 01             	and    $0x1,%eax
  803ba7:	48 85 c0             	test   %rax,%rax
  803baa:	75 07                	jne    803bb3 <pageref+0x64>
		return 0;
  803bac:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb1:	eb 23                	jmp    803bd6 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803bb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bb7:	48 c1 e8 0c          	shr    $0xc,%rax
  803bbb:	48 89 c2             	mov    %rax,%rdx
  803bbe:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803bc5:	00 00 00 
  803bc8:	48 c1 e2 04          	shl    $0x4,%rdx
  803bcc:	48 01 d0             	add    %rdx,%rax
  803bcf:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803bd3:	0f b7 c0             	movzwl %ax,%eax
}
  803bd6:	c9                   	leaveq 
  803bd7:	c3                   	retq   
