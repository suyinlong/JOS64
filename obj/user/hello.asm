
obj/user/hello.debug:     file format elf64-x86-64


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
  80003c:	e8 5e 00 00 00       	callq  80009f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cprintf("hello, world\n");
  800052:	48 bf 40 35 80 00 00 	movabs $0x803540,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 77 02 80 00 00 	movabs $0x800277,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	cprintf("i am environment %08x\n", thisenv->env_id);
  80006d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800074:	00 00 00 
  800077:	48 8b 00             	mov    (%rax),%rax
  80007a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800080:	89 c6                	mov    %eax,%esi
  800082:	48 bf 4e 35 80 00 00 	movabs $0x80354e,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 77 02 80 00 00 	movabs $0x800277,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
}
  80009d:	c9                   	leaveq 
  80009e:	c3                   	retq   

000000000080009f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009f:	55                   	push   %rbp
  8000a0:	48 89 e5             	mov    %rsp,%rbp
  8000a3:	48 83 ec 10          	sub    $0x10,%rsp
  8000a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8000ae:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  8000b5:	00 00 00 
  8000b8:	ff d0                	callq  *%rax
  8000ba:	48 98                	cltq   
  8000bc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000c1:	48 89 c2             	mov    %rax,%rdx
  8000c4:	48 89 d0             	mov    %rdx,%rax
  8000c7:	48 c1 e0 03          	shl    $0x3,%rax
  8000cb:	48 01 d0             	add    %rdx,%rax
  8000ce:	48 c1 e0 05          	shl    $0x5,%rax
  8000d2:	48 89 c2             	mov    %rax,%rdx
  8000d5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000dc:	00 00 00 
  8000df:	48 01 c2             	add    %rax,%rdx
  8000e2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000e9:	00 00 00 
  8000ec:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000f3:	7e 14                	jle    800109 <libmain+0x6a>
		binaryname = argv[0];
  8000f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000f9:	48 8b 10             	mov    (%rax),%rdx
  8000fc:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800103:	00 00 00 
  800106:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800109:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80010d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800110:	48 89 d6             	mov    %rdx,%rsi
  800113:	89 c7                	mov    %eax,%edi
  800115:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800121:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  800128:	00 00 00 
  80012b:	ff d0                	callq  *%rax
}
  80012d:	c9                   	leaveq 
  80012e:	c3                   	retq   

000000000080012f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012f:	55                   	push   %rbp
  800130:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800133:	48 b8 fc 1e 80 00 00 	movabs $0x801efc,%rax
  80013a:	00 00 00 
  80013d:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80013f:	bf 00 00 00 00       	mov    $0x0,%edi
  800144:	48 b8 8e 18 80 00 00 	movabs $0x80188e,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
}
  800150:	5d                   	pop    %rbp
  800151:	c3                   	retq   

0000000000800152 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800152:	55                   	push   %rbp
  800153:	48 89 e5             	mov    %rsp,%rbp
  800156:	48 83 ec 10          	sub    $0x10,%rsp
  80015a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80015d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800161:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800165:	8b 00                	mov    (%rax),%eax
  800167:	8d 48 01             	lea    0x1(%rax),%ecx
  80016a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80016e:	89 0a                	mov    %ecx,(%rdx)
  800170:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800173:	89 d1                	mov    %edx,%ecx
  800175:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800179:	48 98                	cltq   
  80017b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80017f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800183:	8b 00                	mov    (%rax),%eax
  800185:	3d ff 00 00 00       	cmp    $0xff,%eax
  80018a:	75 2c                	jne    8001b8 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80018c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800190:	8b 00                	mov    (%rax),%eax
  800192:	48 98                	cltq   
  800194:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800198:	48 83 c2 08          	add    $0x8,%rdx
  80019c:	48 89 c6             	mov    %rax,%rsi
  80019f:	48 89 d7             	mov    %rdx,%rdi
  8001a2:	48 b8 06 18 80 00 00 	movabs $0x801806,%rax
  8001a9:	00 00 00 
  8001ac:	ff d0                	callq  *%rax
		b->idx = 0;
  8001ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8001b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001bc:	8b 40 04             	mov    0x4(%rax),%eax
  8001bf:	8d 50 01             	lea    0x1(%rax),%edx
  8001c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001c9:	c9                   	leaveq 
  8001ca:	c3                   	retq   

00000000008001cb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001cb:	55                   	push   %rbp
  8001cc:	48 89 e5             	mov    %rsp,%rbp
  8001cf:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001d6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001dd:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8001e4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001eb:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001f2:	48 8b 0a             	mov    (%rdx),%rcx
  8001f5:	48 89 08             	mov    %rcx,(%rax)
  8001f8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001fc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800200:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800204:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800208:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80020f:	00 00 00 
	b.cnt = 0;
  800212:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800219:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80021c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800223:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80022a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800231:	48 89 c6             	mov    %rax,%rsi
  800234:	48 bf 52 01 80 00 00 	movabs $0x800152,%rdi
  80023b:	00 00 00 
  80023e:	48 b8 2a 06 80 00 00 	movabs $0x80062a,%rax
  800245:	00 00 00 
  800248:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80024a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800250:	48 98                	cltq   
  800252:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800259:	48 83 c2 08          	add    $0x8,%rdx
  80025d:	48 89 c6             	mov    %rax,%rsi
  800260:	48 89 d7             	mov    %rdx,%rdi
  800263:	48 b8 06 18 80 00 00 	movabs $0x801806,%rax
  80026a:	00 00 00 
  80026d:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80026f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800275:	c9                   	leaveq 
  800276:	c3                   	retq   

0000000000800277 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800277:	55                   	push   %rbp
  800278:	48 89 e5             	mov    %rsp,%rbp
  80027b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800282:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800289:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800290:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800297:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80029e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002a5:	84 c0                	test   %al,%al
  8002a7:	74 20                	je     8002c9 <cprintf+0x52>
  8002a9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002ad:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002b1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002b5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002b9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002bd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002c1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002c5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002c9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8002d0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002d7:	00 00 00 
  8002da:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002e1:	00 00 00 
  8002e4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002e8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002ef:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002f6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8002fd:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800304:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80030b:	48 8b 0a             	mov    (%rdx),%rcx
  80030e:	48 89 08             	mov    %rcx,(%rax)
  800311:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800315:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800319:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80031d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800321:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800328:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80032f:	48 89 d6             	mov    %rdx,%rsi
  800332:	48 89 c7             	mov    %rax,%rdi
  800335:	48 b8 cb 01 80 00 00 	movabs $0x8001cb,%rax
  80033c:	00 00 00 
  80033f:	ff d0                	callq  *%rax
  800341:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800347:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80034d:	c9                   	leaveq 
  80034e:	c3                   	retq   

000000000080034f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80034f:	55                   	push   %rbp
  800350:	48 89 e5             	mov    %rsp,%rbp
  800353:	53                   	push   %rbx
  800354:	48 83 ec 38          	sub    $0x38,%rsp
  800358:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80035c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800360:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800364:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800367:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80036b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80036f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800372:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800376:	77 3b                	ja     8003b3 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800378:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80037b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80037f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800382:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800386:	ba 00 00 00 00       	mov    $0x0,%edx
  80038b:	48 f7 f3             	div    %rbx
  80038e:	48 89 c2             	mov    %rax,%rdx
  800391:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800394:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800397:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80039b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80039f:	41 89 f9             	mov    %edi,%r9d
  8003a2:	48 89 c7             	mov    %rax,%rdi
  8003a5:	48 b8 4f 03 80 00 00 	movabs $0x80034f,%rax
  8003ac:	00 00 00 
  8003af:	ff d0                	callq  *%rax
  8003b1:	eb 1e                	jmp    8003d1 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b3:	eb 12                	jmp    8003c7 <printnum+0x78>
			putch(padc, putdat);
  8003b5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003b9:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003c0:	48 89 ce             	mov    %rcx,%rsi
  8003c3:	89 d7                	mov    %edx,%edi
  8003c5:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003c7:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003cb:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003cf:	7f e4                	jg     8003b5 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003d1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dd:	48 f7 f1             	div    %rcx
  8003e0:	48 89 d0             	mov    %rdx,%rax
  8003e3:	48 ba 48 37 80 00 00 	movabs $0x803748,%rdx
  8003ea:	00 00 00 
  8003ed:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003f1:	0f be d0             	movsbl %al,%edx
  8003f4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003fc:	48 89 ce             	mov    %rcx,%rsi
  8003ff:	89 d7                	mov    %edx,%edi
  800401:	ff d0                	callq  *%rax
}
  800403:	48 83 c4 38          	add    $0x38,%rsp
  800407:	5b                   	pop    %rbx
  800408:	5d                   	pop    %rbp
  800409:	c3                   	retq   

000000000080040a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80040a:	55                   	push   %rbp
  80040b:	48 89 e5             	mov    %rsp,%rbp
  80040e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800412:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800416:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800419:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80041d:	7e 52                	jle    800471 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80041f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800423:	8b 00                	mov    (%rax),%eax
  800425:	83 f8 30             	cmp    $0x30,%eax
  800428:	73 24                	jae    80044e <getuint+0x44>
  80042a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800432:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800436:	8b 00                	mov    (%rax),%eax
  800438:	89 c0                	mov    %eax,%eax
  80043a:	48 01 d0             	add    %rdx,%rax
  80043d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800441:	8b 12                	mov    (%rdx),%edx
  800443:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800446:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80044a:	89 0a                	mov    %ecx,(%rdx)
  80044c:	eb 17                	jmp    800465 <getuint+0x5b>
  80044e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800452:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800456:	48 89 d0             	mov    %rdx,%rax
  800459:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80045d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800461:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800465:	48 8b 00             	mov    (%rax),%rax
  800468:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80046c:	e9 a3 00 00 00       	jmpq   800514 <getuint+0x10a>
	else if (lflag)
  800471:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800475:	74 4f                	je     8004c6 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800477:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80047b:	8b 00                	mov    (%rax),%eax
  80047d:	83 f8 30             	cmp    $0x30,%eax
  800480:	73 24                	jae    8004a6 <getuint+0x9c>
  800482:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800486:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80048a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048e:	8b 00                	mov    (%rax),%eax
  800490:	89 c0                	mov    %eax,%eax
  800492:	48 01 d0             	add    %rdx,%rax
  800495:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800499:	8b 12                	mov    (%rdx),%edx
  80049b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80049e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a2:	89 0a                	mov    %ecx,(%rdx)
  8004a4:	eb 17                	jmp    8004bd <getuint+0xb3>
  8004a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004aa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004ae:	48 89 d0             	mov    %rdx,%rax
  8004b1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004bd:	48 8b 00             	mov    (%rax),%rax
  8004c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004c4:	eb 4e                	jmp    800514 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ca:	8b 00                	mov    (%rax),%eax
  8004cc:	83 f8 30             	cmp    $0x30,%eax
  8004cf:	73 24                	jae    8004f5 <getuint+0xeb>
  8004d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004dd:	8b 00                	mov    (%rax),%eax
  8004df:	89 c0                	mov    %eax,%eax
  8004e1:	48 01 d0             	add    %rdx,%rax
  8004e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e8:	8b 12                	mov    (%rdx),%edx
  8004ea:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f1:	89 0a                	mov    %ecx,(%rdx)
  8004f3:	eb 17                	jmp    80050c <getuint+0x102>
  8004f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004fd:	48 89 d0             	mov    %rdx,%rax
  800500:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800504:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800508:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80050c:	8b 00                	mov    (%rax),%eax
  80050e:	89 c0                	mov    %eax,%eax
  800510:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800514:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800518:	c9                   	leaveq 
  800519:	c3                   	retq   

000000000080051a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80051a:	55                   	push   %rbp
  80051b:	48 89 e5             	mov    %rsp,%rbp
  80051e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800522:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800526:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800529:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80052d:	7e 52                	jle    800581 <getint+0x67>
		x=va_arg(*ap, long long);
  80052f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800533:	8b 00                	mov    (%rax),%eax
  800535:	83 f8 30             	cmp    $0x30,%eax
  800538:	73 24                	jae    80055e <getint+0x44>
  80053a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800542:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800546:	8b 00                	mov    (%rax),%eax
  800548:	89 c0                	mov    %eax,%eax
  80054a:	48 01 d0             	add    %rdx,%rax
  80054d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800551:	8b 12                	mov    (%rdx),%edx
  800553:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800556:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055a:	89 0a                	mov    %ecx,(%rdx)
  80055c:	eb 17                	jmp    800575 <getint+0x5b>
  80055e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800562:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800566:	48 89 d0             	mov    %rdx,%rax
  800569:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80056d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800571:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800575:	48 8b 00             	mov    (%rax),%rax
  800578:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80057c:	e9 a3 00 00 00       	jmpq   800624 <getint+0x10a>
	else if (lflag)
  800581:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800585:	74 4f                	je     8005d6 <getint+0xbc>
		x=va_arg(*ap, long);
  800587:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058b:	8b 00                	mov    (%rax),%eax
  80058d:	83 f8 30             	cmp    $0x30,%eax
  800590:	73 24                	jae    8005b6 <getint+0x9c>
  800592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800596:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80059a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059e:	8b 00                	mov    (%rax),%eax
  8005a0:	89 c0                	mov    %eax,%eax
  8005a2:	48 01 d0             	add    %rdx,%rax
  8005a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a9:	8b 12                	mov    (%rdx),%edx
  8005ab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b2:	89 0a                	mov    %ecx,(%rdx)
  8005b4:	eb 17                	jmp    8005cd <getint+0xb3>
  8005b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005be:	48 89 d0             	mov    %rdx,%rax
  8005c1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005cd:	48 8b 00             	mov    (%rax),%rax
  8005d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005d4:	eb 4e                	jmp    800624 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005da:	8b 00                	mov    (%rax),%eax
  8005dc:	83 f8 30             	cmp    $0x30,%eax
  8005df:	73 24                	jae    800605 <getint+0xeb>
  8005e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ed:	8b 00                	mov    (%rax),%eax
  8005ef:	89 c0                	mov    %eax,%eax
  8005f1:	48 01 d0             	add    %rdx,%rax
  8005f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f8:	8b 12                	mov    (%rdx),%edx
  8005fa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800601:	89 0a                	mov    %ecx,(%rdx)
  800603:	eb 17                	jmp    80061c <getint+0x102>
  800605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800609:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80060d:	48 89 d0             	mov    %rdx,%rax
  800610:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800614:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800618:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80061c:	8b 00                	mov    (%rax),%eax
  80061e:	48 98                	cltq   
  800620:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800624:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800628:	c9                   	leaveq 
  800629:	c3                   	retq   

000000000080062a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80062a:	55                   	push   %rbp
  80062b:	48 89 e5             	mov    %rsp,%rbp
  80062e:	41 54                	push   %r12
  800630:	53                   	push   %rbx
  800631:	48 83 ec 60          	sub    $0x60,%rsp
  800635:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800639:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80063d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800641:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800645:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800649:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80064d:	48 8b 0a             	mov    (%rdx),%rcx
  800650:	48 89 08             	mov    %rcx,(%rax)
  800653:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800657:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80065b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80065f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  800663:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800667:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80066b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80066f:	0f b6 00             	movzbl (%rax),%eax
  800672:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  800675:	eb 29                	jmp    8006a0 <vprintfmt+0x76>
			if (ch == '\0')
  800677:	85 db                	test   %ebx,%ebx
  800679:	0f 84 ad 06 00 00    	je     800d2c <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  80067f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800683:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800687:	48 89 d6             	mov    %rdx,%rsi
  80068a:	89 df                	mov    %ebx,%edi
  80068c:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  80068e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800692:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800696:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80069a:	0f b6 00             	movzbl (%rax),%eax
  80069d:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  8006a0:	83 fb 25             	cmp    $0x25,%ebx
  8006a3:	74 05                	je     8006aa <vprintfmt+0x80>
  8006a5:	83 fb 1b             	cmp    $0x1b,%ebx
  8006a8:	75 cd                	jne    800677 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  8006aa:	83 fb 1b             	cmp    $0x1b,%ebx
  8006ad:	0f 85 ae 01 00 00    	jne    800861 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  8006b3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8006ba:	00 00 00 
  8006bd:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  8006c3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006c7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006cb:	48 89 d6             	mov    %rdx,%rsi
  8006ce:	89 df                	mov    %ebx,%edi
  8006d0:	ff d0                	callq  *%rax
			putch('[', putdat);
  8006d2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006d6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006da:	48 89 d6             	mov    %rdx,%rsi
  8006dd:	bf 5b 00 00 00       	mov    $0x5b,%edi
  8006e2:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  8006e4:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  8006ea:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8006ef:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006f3:	0f b6 00             	movzbl (%rax),%eax
  8006f6:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8006f9:	eb 32                	jmp    80072d <vprintfmt+0x103>
					putch(ch, putdat);
  8006fb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006ff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800703:	48 89 d6             	mov    %rdx,%rsi
  800706:	89 df                	mov    %ebx,%edi
  800708:	ff d0                	callq  *%rax
					esc_color *= 10;
  80070a:	44 89 e0             	mov    %r12d,%eax
  80070d:	c1 e0 02             	shl    $0x2,%eax
  800710:	44 01 e0             	add    %r12d,%eax
  800713:	01 c0                	add    %eax,%eax
  800715:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800718:	8d 43 d0             	lea    -0x30(%rbx),%eax
  80071b:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  80071e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800723:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800727:	0f b6 00             	movzbl (%rax),%eax
  80072a:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  80072d:	83 fb 3b             	cmp    $0x3b,%ebx
  800730:	74 05                	je     800737 <vprintfmt+0x10d>
  800732:	83 fb 6d             	cmp    $0x6d,%ebx
  800735:	75 c4                	jne    8006fb <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800737:	45 85 e4             	test   %r12d,%r12d
  80073a:	75 15                	jne    800751 <vprintfmt+0x127>
					color_flag = 0x07;
  80073c:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800743:	00 00 00 
  800746:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  80074c:	e9 dc 00 00 00       	jmpq   80082d <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800751:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800755:	7e 69                	jle    8007c0 <vprintfmt+0x196>
  800757:	41 83 fc 25          	cmp    $0x25,%r12d
  80075b:	7f 63                	jg     8007c0 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  80075d:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800764:	00 00 00 
  800767:	8b 00                	mov    (%rax),%eax
  800769:	25 f8 00 00 00       	and    $0xf8,%eax
  80076e:	89 c2                	mov    %eax,%edx
  800770:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800777:	00 00 00 
  80077a:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  80077c:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800780:	44 89 e0             	mov    %r12d,%eax
  800783:	83 e0 04             	and    $0x4,%eax
  800786:	c1 f8 02             	sar    $0x2,%eax
  800789:	89 c2                	mov    %eax,%edx
  80078b:	44 89 e0             	mov    %r12d,%eax
  80078e:	83 e0 02             	and    $0x2,%eax
  800791:	09 c2                	or     %eax,%edx
  800793:	44 89 e0             	mov    %r12d,%eax
  800796:	83 e0 01             	and    $0x1,%eax
  800799:	c1 e0 02             	shl    $0x2,%eax
  80079c:	09 c2                	or     %eax,%edx
  80079e:	41 89 d4             	mov    %edx,%r12d
  8007a1:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8007a8:	00 00 00 
  8007ab:	8b 00                	mov    (%rax),%eax
  8007ad:	44 89 e2             	mov    %r12d,%edx
  8007b0:	09 c2                	or     %eax,%edx
  8007b2:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8007b9:	00 00 00 
  8007bc:	89 10                	mov    %edx,(%rax)
  8007be:	eb 6d                	jmp    80082d <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  8007c0:	41 83 fc 27          	cmp    $0x27,%r12d
  8007c4:	7e 67                	jle    80082d <vprintfmt+0x203>
  8007c6:	41 83 fc 2f          	cmp    $0x2f,%r12d
  8007ca:	7f 61                	jg     80082d <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  8007cc:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8007d3:	00 00 00 
  8007d6:	8b 00                	mov    (%rax),%eax
  8007d8:	25 8f 00 00 00       	and    $0x8f,%eax
  8007dd:	89 c2                	mov    %eax,%edx
  8007df:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8007e6:	00 00 00 
  8007e9:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  8007eb:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  8007ef:	44 89 e0             	mov    %r12d,%eax
  8007f2:	83 e0 04             	and    $0x4,%eax
  8007f5:	c1 f8 02             	sar    $0x2,%eax
  8007f8:	89 c2                	mov    %eax,%edx
  8007fa:	44 89 e0             	mov    %r12d,%eax
  8007fd:	83 e0 02             	and    $0x2,%eax
  800800:	09 c2                	or     %eax,%edx
  800802:	44 89 e0             	mov    %r12d,%eax
  800805:	83 e0 01             	and    $0x1,%eax
  800808:	c1 e0 06             	shl    $0x6,%eax
  80080b:	09 c2                	or     %eax,%edx
  80080d:	41 89 d4             	mov    %edx,%r12d
  800810:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800817:	00 00 00 
  80081a:	8b 00                	mov    (%rax),%eax
  80081c:	44 89 e2             	mov    %r12d,%edx
  80081f:	09 c2                	or     %eax,%edx
  800821:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800828:	00 00 00 
  80082b:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  80082d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800831:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800835:	48 89 d6             	mov    %rdx,%rsi
  800838:	89 df                	mov    %ebx,%edi
  80083a:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  80083c:	83 fb 6d             	cmp    $0x6d,%ebx
  80083f:	75 1b                	jne    80085c <vprintfmt+0x232>
					fmt ++;
  800841:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800846:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800847:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80084e:	00 00 00 
  800851:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800857:	e9 cb 04 00 00       	jmpq   800d27 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  80085c:	e9 83 fe ff ff       	jmpq   8006e4 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800861:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800865:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80086c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800873:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80087a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800881:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800885:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800889:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80088d:	0f b6 00             	movzbl (%rax),%eax
  800890:	0f b6 d8             	movzbl %al,%ebx
  800893:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800896:	83 f8 55             	cmp    $0x55,%eax
  800899:	0f 87 5a 04 00 00    	ja     800cf9 <vprintfmt+0x6cf>
  80089f:	89 c0                	mov    %eax,%eax
  8008a1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008a8:	00 
  8008a9:	48 b8 70 37 80 00 00 	movabs $0x803770,%rax
  8008b0:	00 00 00 
  8008b3:	48 01 d0             	add    %rdx,%rax
  8008b6:	48 8b 00             	mov    (%rax),%rax
  8008b9:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008bb:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008bf:	eb c0                	jmp    800881 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008c1:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008c5:	eb ba                	jmp    800881 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008c7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008ce:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8008d1:	89 d0                	mov    %edx,%eax
  8008d3:	c1 e0 02             	shl    $0x2,%eax
  8008d6:	01 d0                	add    %edx,%eax
  8008d8:	01 c0                	add    %eax,%eax
  8008da:	01 d8                	add    %ebx,%eax
  8008dc:	83 e8 30             	sub    $0x30,%eax
  8008df:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8008e2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008e6:	0f b6 00             	movzbl (%rax),%eax
  8008e9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008ec:	83 fb 2f             	cmp    $0x2f,%ebx
  8008ef:	7e 0c                	jle    8008fd <vprintfmt+0x2d3>
  8008f1:	83 fb 39             	cmp    $0x39,%ebx
  8008f4:	7f 07                	jg     8008fd <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008f6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008fb:	eb d1                	jmp    8008ce <vprintfmt+0x2a4>
			goto process_precision;
  8008fd:	eb 58                	jmp    800957 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  8008ff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800902:	83 f8 30             	cmp    $0x30,%eax
  800905:	73 17                	jae    80091e <vprintfmt+0x2f4>
  800907:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80090b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090e:	89 c0                	mov    %eax,%eax
  800910:	48 01 d0             	add    %rdx,%rax
  800913:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800916:	83 c2 08             	add    $0x8,%edx
  800919:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80091c:	eb 0f                	jmp    80092d <vprintfmt+0x303>
  80091e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800922:	48 89 d0             	mov    %rdx,%rax
  800925:	48 83 c2 08          	add    $0x8,%rdx
  800929:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80092d:	8b 00                	mov    (%rax),%eax
  80092f:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800932:	eb 23                	jmp    800957 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800934:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800938:	79 0c                	jns    800946 <vprintfmt+0x31c>
				width = 0;
  80093a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800941:	e9 3b ff ff ff       	jmpq   800881 <vprintfmt+0x257>
  800946:	e9 36 ff ff ff       	jmpq   800881 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  80094b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800952:	e9 2a ff ff ff       	jmpq   800881 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800957:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80095b:	79 12                	jns    80096f <vprintfmt+0x345>
				width = precision, precision = -1;
  80095d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800960:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800963:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80096a:	e9 12 ff ff ff       	jmpq   800881 <vprintfmt+0x257>
  80096f:	e9 0d ff ff ff       	jmpq   800881 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800974:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800978:	e9 04 ff ff ff       	jmpq   800881 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80097d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800980:	83 f8 30             	cmp    $0x30,%eax
  800983:	73 17                	jae    80099c <vprintfmt+0x372>
  800985:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800989:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80098c:	89 c0                	mov    %eax,%eax
  80098e:	48 01 d0             	add    %rdx,%rax
  800991:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800994:	83 c2 08             	add    $0x8,%edx
  800997:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80099a:	eb 0f                	jmp    8009ab <vprintfmt+0x381>
  80099c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009a0:	48 89 d0             	mov    %rdx,%rax
  8009a3:	48 83 c2 08          	add    $0x8,%rdx
  8009a7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009ab:	8b 10                	mov    (%rax),%edx
  8009ad:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009b1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b5:	48 89 ce             	mov    %rcx,%rsi
  8009b8:	89 d7                	mov    %edx,%edi
  8009ba:	ff d0                	callq  *%rax
			break;
  8009bc:	e9 66 03 00 00       	jmpq   800d27 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8009c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c4:	83 f8 30             	cmp    $0x30,%eax
  8009c7:	73 17                	jae    8009e0 <vprintfmt+0x3b6>
  8009c9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009cd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d0:	89 c0                	mov    %eax,%eax
  8009d2:	48 01 d0             	add    %rdx,%rax
  8009d5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d8:	83 c2 08             	add    $0x8,%edx
  8009db:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009de:	eb 0f                	jmp    8009ef <vprintfmt+0x3c5>
  8009e0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e4:	48 89 d0             	mov    %rdx,%rax
  8009e7:	48 83 c2 08          	add    $0x8,%rdx
  8009eb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009ef:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8009f1:	85 db                	test   %ebx,%ebx
  8009f3:	79 02                	jns    8009f7 <vprintfmt+0x3cd>
				err = -err;
  8009f5:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009f7:	83 fb 10             	cmp    $0x10,%ebx
  8009fa:	7f 16                	jg     800a12 <vprintfmt+0x3e8>
  8009fc:	48 b8 c0 36 80 00 00 	movabs $0x8036c0,%rax
  800a03:	00 00 00 
  800a06:	48 63 d3             	movslq %ebx,%rdx
  800a09:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a0d:	4d 85 e4             	test   %r12,%r12
  800a10:	75 2e                	jne    800a40 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800a12:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a16:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a1a:	89 d9                	mov    %ebx,%ecx
  800a1c:	48 ba 59 37 80 00 00 	movabs $0x803759,%rdx
  800a23:	00 00 00 
  800a26:	48 89 c7             	mov    %rax,%rdi
  800a29:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2e:	49 b8 35 0d 80 00 00 	movabs $0x800d35,%r8
  800a35:	00 00 00 
  800a38:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a3b:	e9 e7 02 00 00       	jmpq   800d27 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a40:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a48:	4c 89 e1             	mov    %r12,%rcx
  800a4b:	48 ba 62 37 80 00 00 	movabs $0x803762,%rdx
  800a52:	00 00 00 
  800a55:	48 89 c7             	mov    %rax,%rdi
  800a58:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5d:	49 b8 35 0d 80 00 00 	movabs $0x800d35,%r8
  800a64:	00 00 00 
  800a67:	41 ff d0             	callq  *%r8
			break;
  800a6a:	e9 b8 02 00 00       	jmpq   800d27 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a72:	83 f8 30             	cmp    $0x30,%eax
  800a75:	73 17                	jae    800a8e <vprintfmt+0x464>
  800a77:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7e:	89 c0                	mov    %eax,%eax
  800a80:	48 01 d0             	add    %rdx,%rax
  800a83:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a86:	83 c2 08             	add    $0x8,%edx
  800a89:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a8c:	eb 0f                	jmp    800a9d <vprintfmt+0x473>
  800a8e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a92:	48 89 d0             	mov    %rdx,%rax
  800a95:	48 83 c2 08          	add    $0x8,%rdx
  800a99:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a9d:	4c 8b 20             	mov    (%rax),%r12
  800aa0:	4d 85 e4             	test   %r12,%r12
  800aa3:	75 0a                	jne    800aaf <vprintfmt+0x485>
				p = "(null)";
  800aa5:	49 bc 65 37 80 00 00 	movabs $0x803765,%r12
  800aac:	00 00 00 
			if (width > 0 && padc != '-')
  800aaf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ab3:	7e 3f                	jle    800af4 <vprintfmt+0x4ca>
  800ab5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ab9:	74 39                	je     800af4 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800abb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800abe:	48 98                	cltq   
  800ac0:	48 89 c6             	mov    %rax,%rsi
  800ac3:	4c 89 e7             	mov    %r12,%rdi
  800ac6:	48 b8 e1 0f 80 00 00 	movabs $0x800fe1,%rax
  800acd:	00 00 00 
  800ad0:	ff d0                	callq  *%rax
  800ad2:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ad5:	eb 17                	jmp    800aee <vprintfmt+0x4c4>
					putch(padc, putdat);
  800ad7:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800adb:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800adf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae3:	48 89 ce             	mov    %rcx,%rsi
  800ae6:	89 d7                	mov    %edx,%edi
  800ae8:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800aea:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800aee:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af2:	7f e3                	jg     800ad7 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800af4:	eb 37                	jmp    800b2d <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800af6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800afa:	74 1e                	je     800b1a <vprintfmt+0x4f0>
  800afc:	83 fb 1f             	cmp    $0x1f,%ebx
  800aff:	7e 05                	jle    800b06 <vprintfmt+0x4dc>
  800b01:	83 fb 7e             	cmp    $0x7e,%ebx
  800b04:	7e 14                	jle    800b1a <vprintfmt+0x4f0>
					putch('?', putdat);
  800b06:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0e:	48 89 d6             	mov    %rdx,%rsi
  800b11:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b16:	ff d0                	callq  *%rax
  800b18:	eb 0f                	jmp    800b29 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800b1a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b1e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b22:	48 89 d6             	mov    %rdx,%rsi
  800b25:	89 df                	mov    %ebx,%edi
  800b27:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b29:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b2d:	4c 89 e0             	mov    %r12,%rax
  800b30:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b34:	0f b6 00             	movzbl (%rax),%eax
  800b37:	0f be d8             	movsbl %al,%ebx
  800b3a:	85 db                	test   %ebx,%ebx
  800b3c:	74 10                	je     800b4e <vprintfmt+0x524>
  800b3e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b42:	78 b2                	js     800af6 <vprintfmt+0x4cc>
  800b44:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b48:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b4c:	79 a8                	jns    800af6 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4e:	eb 16                	jmp    800b66 <vprintfmt+0x53c>
				putch(' ', putdat);
  800b50:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b54:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b58:	48 89 d6             	mov    %rdx,%rsi
  800b5b:	bf 20 00 00 00       	mov    $0x20,%edi
  800b60:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b62:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b66:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b6a:	7f e4                	jg     800b50 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800b6c:	e9 b6 01 00 00       	jmpq   800d27 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b71:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b75:	be 03 00 00 00       	mov    $0x3,%esi
  800b7a:	48 89 c7             	mov    %rax,%rdi
  800b7d:	48 b8 1a 05 80 00 00 	movabs $0x80051a,%rax
  800b84:	00 00 00 
  800b87:	ff d0                	callq  *%rax
  800b89:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b91:	48 85 c0             	test   %rax,%rax
  800b94:	79 1d                	jns    800bb3 <vprintfmt+0x589>
				putch('-', putdat);
  800b96:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9e:	48 89 d6             	mov    %rdx,%rsi
  800ba1:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ba6:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ba8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bac:	48 f7 d8             	neg    %rax
  800baf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bb3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bba:	e9 fb 00 00 00       	jmpq   800cba <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bbf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bc3:	be 03 00 00 00       	mov    $0x3,%esi
  800bc8:	48 89 c7             	mov    %rax,%rdi
  800bcb:	48 b8 0a 04 80 00 00 	movabs $0x80040a,%rax
  800bd2:	00 00 00 
  800bd5:	ff d0                	callq  *%rax
  800bd7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800bdb:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800be2:	e9 d3 00 00 00       	jmpq   800cba <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800be7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800beb:	be 03 00 00 00       	mov    $0x3,%esi
  800bf0:	48 89 c7             	mov    %rax,%rdi
  800bf3:	48 b8 1a 05 80 00 00 	movabs $0x80051a,%rax
  800bfa:	00 00 00 
  800bfd:	ff d0                	callq  *%rax
  800bff:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c07:	48 85 c0             	test   %rax,%rax
  800c0a:	79 1d                	jns    800c29 <vprintfmt+0x5ff>
				putch('-', putdat);
  800c0c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c14:	48 89 d6             	mov    %rdx,%rsi
  800c17:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c1c:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c22:	48 f7 d8             	neg    %rax
  800c25:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800c29:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c30:	e9 85 00 00 00       	jmpq   800cba <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800c35:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c39:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3d:	48 89 d6             	mov    %rdx,%rsi
  800c40:	bf 30 00 00 00       	mov    $0x30,%edi
  800c45:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c47:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4f:	48 89 d6             	mov    %rdx,%rsi
  800c52:	bf 78 00 00 00       	mov    $0x78,%edi
  800c57:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c59:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c5c:	83 f8 30             	cmp    $0x30,%eax
  800c5f:	73 17                	jae    800c78 <vprintfmt+0x64e>
  800c61:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c65:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c68:	89 c0                	mov    %eax,%eax
  800c6a:	48 01 d0             	add    %rdx,%rax
  800c6d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c70:	83 c2 08             	add    $0x8,%edx
  800c73:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c76:	eb 0f                	jmp    800c87 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800c78:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c7c:	48 89 d0             	mov    %rdx,%rax
  800c7f:	48 83 c2 08          	add    $0x8,%rdx
  800c83:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c87:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c8a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c8e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c95:	eb 23                	jmp    800cba <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c97:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c9b:	be 03 00 00 00       	mov    $0x3,%esi
  800ca0:	48 89 c7             	mov    %rax,%rdi
  800ca3:	48 b8 0a 04 80 00 00 	movabs $0x80040a,%rax
  800caa:	00 00 00 
  800cad:	ff d0                	callq  *%rax
  800caf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cb3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cba:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cbf:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cc2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cc5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cc9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ccd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd1:	45 89 c1             	mov    %r8d,%r9d
  800cd4:	41 89 f8             	mov    %edi,%r8d
  800cd7:	48 89 c7             	mov    %rax,%rdi
  800cda:	48 b8 4f 03 80 00 00 	movabs $0x80034f,%rax
  800ce1:	00 00 00 
  800ce4:	ff d0                	callq  *%rax
			break;
  800ce6:	eb 3f                	jmp    800d27 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ce8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf0:	48 89 d6             	mov    %rdx,%rsi
  800cf3:	89 df                	mov    %ebx,%edi
  800cf5:	ff d0                	callq  *%rax
			break;
  800cf7:	eb 2e                	jmp    800d27 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cf9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cfd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d01:	48 89 d6             	mov    %rdx,%rsi
  800d04:	bf 25 00 00 00       	mov    $0x25,%edi
  800d09:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d10:	eb 05                	jmp    800d17 <vprintfmt+0x6ed>
  800d12:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d17:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d1b:	48 83 e8 01          	sub    $0x1,%rax
  800d1f:	0f b6 00             	movzbl (%rax),%eax
  800d22:	3c 25                	cmp    $0x25,%al
  800d24:	75 ec                	jne    800d12 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  800d26:	90                   	nop
		}
	}
  800d27:	e9 37 f9 ff ff       	jmpq   800663 <vprintfmt+0x39>
    va_end(aq);
}
  800d2c:	48 83 c4 60          	add    $0x60,%rsp
  800d30:	5b                   	pop    %rbx
  800d31:	41 5c                	pop    %r12
  800d33:	5d                   	pop    %rbp
  800d34:	c3                   	retq   

0000000000800d35 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d35:	55                   	push   %rbp
  800d36:	48 89 e5             	mov    %rsp,%rbp
  800d39:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d40:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d47:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d4e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d55:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d5c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d63:	84 c0                	test   %al,%al
  800d65:	74 20                	je     800d87 <printfmt+0x52>
  800d67:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d6b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d6f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d73:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d77:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d7b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d7f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d83:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d87:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d8e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d95:	00 00 00 
  800d98:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d9f:	00 00 00 
  800da2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800da6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dad:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800db4:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800dbb:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dc2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dc9:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800dd0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800dd7:	48 89 c7             	mov    %rax,%rdi
  800dda:	48 b8 2a 06 80 00 00 	movabs $0x80062a,%rax
  800de1:	00 00 00 
  800de4:	ff d0                	callq  *%rax
	va_end(ap);
}
  800de6:	c9                   	leaveq 
  800de7:	c3                   	retq   

0000000000800de8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800de8:	55                   	push   %rbp
  800de9:	48 89 e5             	mov    %rsp,%rbp
  800dec:	48 83 ec 10          	sub    $0x10,%rsp
  800df0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800df3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800df7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dfb:	8b 40 10             	mov    0x10(%rax),%eax
  800dfe:	8d 50 01             	lea    0x1(%rax),%edx
  800e01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e05:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e0c:	48 8b 10             	mov    (%rax),%rdx
  800e0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e13:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e17:	48 39 c2             	cmp    %rax,%rdx
  800e1a:	73 17                	jae    800e33 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e20:	48 8b 00             	mov    (%rax),%rax
  800e23:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e27:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e2b:	48 89 0a             	mov    %rcx,(%rdx)
  800e2e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e31:	88 10                	mov    %dl,(%rax)
}
  800e33:	c9                   	leaveq 
  800e34:	c3                   	retq   

0000000000800e35 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e35:	55                   	push   %rbp
  800e36:	48 89 e5             	mov    %rsp,%rbp
  800e39:	48 83 ec 50          	sub    $0x50,%rsp
  800e3d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e41:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e44:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e48:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e4c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e50:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e54:	48 8b 0a             	mov    (%rdx),%rcx
  800e57:	48 89 08             	mov    %rcx,(%rax)
  800e5a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e5e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e62:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e66:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e6a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e6e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e72:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e75:	48 98                	cltq   
  800e77:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e7b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e7f:	48 01 d0             	add    %rdx,%rax
  800e82:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e86:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e8d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e92:	74 06                	je     800e9a <vsnprintf+0x65>
  800e94:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e98:	7f 07                	jg     800ea1 <vsnprintf+0x6c>
		return -E_INVAL;
  800e9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e9f:	eb 2f                	jmp    800ed0 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ea1:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ea5:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ea9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ead:	48 89 c6             	mov    %rax,%rsi
  800eb0:	48 bf e8 0d 80 00 00 	movabs $0x800de8,%rdi
  800eb7:	00 00 00 
  800eba:	48 b8 2a 06 80 00 00 	movabs $0x80062a,%rax
  800ec1:	00 00 00 
  800ec4:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ec6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eca:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ecd:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ed0:	c9                   	leaveq 
  800ed1:	c3                   	retq   

0000000000800ed2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ed2:	55                   	push   %rbp
  800ed3:	48 89 e5             	mov    %rsp,%rbp
  800ed6:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800edd:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ee4:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800eea:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ef1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ef8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800eff:	84 c0                	test   %al,%al
  800f01:	74 20                	je     800f23 <snprintf+0x51>
  800f03:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f07:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f0b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f0f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f13:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f17:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f1b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f1f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f23:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f2a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f31:	00 00 00 
  800f34:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f3b:	00 00 00 
  800f3e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f42:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f49:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f50:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f57:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f5e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f65:	48 8b 0a             	mov    (%rdx),%rcx
  800f68:	48 89 08             	mov    %rcx,(%rax)
  800f6b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f6f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f73:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f77:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f7b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f82:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f89:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f8f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f96:	48 89 c7             	mov    %rax,%rdi
  800f99:	48 b8 35 0e 80 00 00 	movabs $0x800e35,%rax
  800fa0:	00 00 00 
  800fa3:	ff d0                	callq  *%rax
  800fa5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fab:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fb1:	c9                   	leaveq 
  800fb2:	c3                   	retq   

0000000000800fb3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fb3:	55                   	push   %rbp
  800fb4:	48 89 e5             	mov    %rsp,%rbp
  800fb7:	48 83 ec 18          	sub    $0x18,%rsp
  800fbb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fc6:	eb 09                	jmp    800fd1 <strlen+0x1e>
		n++;
  800fc8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fcc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd5:	0f b6 00             	movzbl (%rax),%eax
  800fd8:	84 c0                	test   %al,%al
  800fda:	75 ec                	jne    800fc8 <strlen+0x15>
		n++;
	return n;
  800fdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fdf:	c9                   	leaveq 
  800fe0:	c3                   	retq   

0000000000800fe1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fe1:	55                   	push   %rbp
  800fe2:	48 89 e5             	mov    %rsp,%rbp
  800fe5:	48 83 ec 20          	sub    $0x20,%rsp
  800fe9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ff1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ff8:	eb 0e                	jmp    801008 <strnlen+0x27>
		n++;
  800ffa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ffe:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801003:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801008:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80100d:	74 0b                	je     80101a <strnlen+0x39>
  80100f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801013:	0f b6 00             	movzbl (%rax),%eax
  801016:	84 c0                	test   %al,%al
  801018:	75 e0                	jne    800ffa <strnlen+0x19>
		n++;
	return n;
  80101a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80101d:	c9                   	leaveq 
  80101e:	c3                   	retq   

000000000080101f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80101f:	55                   	push   %rbp
  801020:	48 89 e5             	mov    %rsp,%rbp
  801023:	48 83 ec 20          	sub    $0x20,%rsp
  801027:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80102b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80102f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801033:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801037:	90                   	nop
  801038:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801040:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801044:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801048:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80104c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801050:	0f b6 12             	movzbl (%rdx),%edx
  801053:	88 10                	mov    %dl,(%rax)
  801055:	0f b6 00             	movzbl (%rax),%eax
  801058:	84 c0                	test   %al,%al
  80105a:	75 dc                	jne    801038 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80105c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801060:	c9                   	leaveq 
  801061:	c3                   	retq   

0000000000801062 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801062:	55                   	push   %rbp
  801063:	48 89 e5             	mov    %rsp,%rbp
  801066:	48 83 ec 20          	sub    $0x20,%rsp
  80106a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80106e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801072:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801076:	48 89 c7             	mov    %rax,%rdi
  801079:	48 b8 b3 0f 80 00 00 	movabs $0x800fb3,%rax
  801080:	00 00 00 
  801083:	ff d0                	callq  *%rax
  801085:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80108b:	48 63 d0             	movslq %eax,%rdx
  80108e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801092:	48 01 c2             	add    %rax,%rdx
  801095:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801099:	48 89 c6             	mov    %rax,%rsi
  80109c:	48 89 d7             	mov    %rdx,%rdi
  80109f:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  8010a6:	00 00 00 
  8010a9:	ff d0                	callq  *%rax
	return dst;
  8010ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010af:	c9                   	leaveq 
  8010b0:	c3                   	retq   

00000000008010b1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010b1:	55                   	push   %rbp
  8010b2:	48 89 e5             	mov    %rsp,%rbp
  8010b5:	48 83 ec 28          	sub    $0x28,%rsp
  8010b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010cd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010d4:	00 
  8010d5:	eb 2a                	jmp    801101 <strncpy+0x50>
		*dst++ = *src;
  8010d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010db:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010df:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010e3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010e7:	0f b6 12             	movzbl (%rdx),%edx
  8010ea:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010f0:	0f b6 00             	movzbl (%rax),%eax
  8010f3:	84 c0                	test   %al,%al
  8010f5:	74 05                	je     8010fc <strncpy+0x4b>
			src++;
  8010f7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010fc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801101:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801105:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801109:	72 cc                	jb     8010d7 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80110b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80110f:	c9                   	leaveq 
  801110:	c3                   	retq   

0000000000801111 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801111:	55                   	push   %rbp
  801112:	48 89 e5             	mov    %rsp,%rbp
  801115:	48 83 ec 28          	sub    $0x28,%rsp
  801119:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80111d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801121:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801125:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801129:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80112d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801132:	74 3d                	je     801171 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801134:	eb 1d                	jmp    801153 <strlcpy+0x42>
			*dst++ = *src++;
  801136:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80113e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801142:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801146:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80114a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80114e:	0f b6 12             	movzbl (%rdx),%edx
  801151:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801153:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801158:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80115d:	74 0b                	je     80116a <strlcpy+0x59>
  80115f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801163:	0f b6 00             	movzbl (%rax),%eax
  801166:	84 c0                	test   %al,%al
  801168:	75 cc                	jne    801136 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80116a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801171:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801175:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801179:	48 29 c2             	sub    %rax,%rdx
  80117c:	48 89 d0             	mov    %rdx,%rax
}
  80117f:	c9                   	leaveq 
  801180:	c3                   	retq   

0000000000801181 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801181:	55                   	push   %rbp
  801182:	48 89 e5             	mov    %rsp,%rbp
  801185:	48 83 ec 10          	sub    $0x10,%rsp
  801189:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80118d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801191:	eb 0a                	jmp    80119d <strcmp+0x1c>
		p++, q++;
  801193:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801198:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80119d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a1:	0f b6 00             	movzbl (%rax),%eax
  8011a4:	84 c0                	test   %al,%al
  8011a6:	74 12                	je     8011ba <strcmp+0x39>
  8011a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ac:	0f b6 10             	movzbl (%rax),%edx
  8011af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b3:	0f b6 00             	movzbl (%rax),%eax
  8011b6:	38 c2                	cmp    %al,%dl
  8011b8:	74 d9                	je     801193 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011be:	0f b6 00             	movzbl (%rax),%eax
  8011c1:	0f b6 d0             	movzbl %al,%edx
  8011c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c8:	0f b6 00             	movzbl (%rax),%eax
  8011cb:	0f b6 c0             	movzbl %al,%eax
  8011ce:	29 c2                	sub    %eax,%edx
  8011d0:	89 d0                	mov    %edx,%eax
}
  8011d2:	c9                   	leaveq 
  8011d3:	c3                   	retq   

00000000008011d4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011d4:	55                   	push   %rbp
  8011d5:	48 89 e5             	mov    %rsp,%rbp
  8011d8:	48 83 ec 18          	sub    $0x18,%rsp
  8011dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011e8:	eb 0f                	jmp    8011f9 <strncmp+0x25>
		n--, p++, q++;
  8011ea:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011f4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011f9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011fe:	74 1d                	je     80121d <strncmp+0x49>
  801200:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801204:	0f b6 00             	movzbl (%rax),%eax
  801207:	84 c0                	test   %al,%al
  801209:	74 12                	je     80121d <strncmp+0x49>
  80120b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120f:	0f b6 10             	movzbl (%rax),%edx
  801212:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801216:	0f b6 00             	movzbl (%rax),%eax
  801219:	38 c2                	cmp    %al,%dl
  80121b:	74 cd                	je     8011ea <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80121d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801222:	75 07                	jne    80122b <strncmp+0x57>
		return 0;
  801224:	b8 00 00 00 00       	mov    $0x0,%eax
  801229:	eb 18                	jmp    801243 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80122b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122f:	0f b6 00             	movzbl (%rax),%eax
  801232:	0f b6 d0             	movzbl %al,%edx
  801235:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801239:	0f b6 00             	movzbl (%rax),%eax
  80123c:	0f b6 c0             	movzbl %al,%eax
  80123f:	29 c2                	sub    %eax,%edx
  801241:	89 d0                	mov    %edx,%eax
}
  801243:	c9                   	leaveq 
  801244:	c3                   	retq   

0000000000801245 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801245:	55                   	push   %rbp
  801246:	48 89 e5             	mov    %rsp,%rbp
  801249:	48 83 ec 0c          	sub    $0xc,%rsp
  80124d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801251:	89 f0                	mov    %esi,%eax
  801253:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801256:	eb 17                	jmp    80126f <strchr+0x2a>
		if (*s == c)
  801258:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125c:	0f b6 00             	movzbl (%rax),%eax
  80125f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801262:	75 06                	jne    80126a <strchr+0x25>
			return (char *) s;
  801264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801268:	eb 15                	jmp    80127f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80126a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80126f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801273:	0f b6 00             	movzbl (%rax),%eax
  801276:	84 c0                	test   %al,%al
  801278:	75 de                	jne    801258 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80127a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127f:	c9                   	leaveq 
  801280:	c3                   	retq   

0000000000801281 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801281:	55                   	push   %rbp
  801282:	48 89 e5             	mov    %rsp,%rbp
  801285:	48 83 ec 0c          	sub    $0xc,%rsp
  801289:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80128d:	89 f0                	mov    %esi,%eax
  80128f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801292:	eb 13                	jmp    8012a7 <strfind+0x26>
		if (*s == c)
  801294:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801298:	0f b6 00             	movzbl (%rax),%eax
  80129b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80129e:	75 02                	jne    8012a2 <strfind+0x21>
			break;
  8012a0:	eb 10                	jmp    8012b2 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ab:	0f b6 00             	movzbl (%rax),%eax
  8012ae:	84 c0                	test   %al,%al
  8012b0:	75 e2                	jne    801294 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012b6:	c9                   	leaveq 
  8012b7:	c3                   	retq   

00000000008012b8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012b8:	55                   	push   %rbp
  8012b9:	48 89 e5             	mov    %rsp,%rbp
  8012bc:	48 83 ec 18          	sub    $0x18,%rsp
  8012c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012c4:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012c7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012cb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012d0:	75 06                	jne    8012d8 <memset+0x20>
		return v;
  8012d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d6:	eb 69                	jmp    801341 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012dc:	83 e0 03             	and    $0x3,%eax
  8012df:	48 85 c0             	test   %rax,%rax
  8012e2:	75 48                	jne    80132c <memset+0x74>
  8012e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e8:	83 e0 03             	and    $0x3,%eax
  8012eb:	48 85 c0             	test   %rax,%rax
  8012ee:	75 3c                	jne    80132c <memset+0x74>
		c &= 0xFF;
  8012f0:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012f7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012fa:	c1 e0 18             	shl    $0x18,%eax
  8012fd:	89 c2                	mov    %eax,%edx
  8012ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801302:	c1 e0 10             	shl    $0x10,%eax
  801305:	09 c2                	or     %eax,%edx
  801307:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80130a:	c1 e0 08             	shl    $0x8,%eax
  80130d:	09 d0                	or     %edx,%eax
  80130f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801312:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801316:	48 c1 e8 02          	shr    $0x2,%rax
  80131a:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80131d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801321:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801324:	48 89 d7             	mov    %rdx,%rdi
  801327:	fc                   	cld    
  801328:	f3 ab                	rep stos %eax,%es:(%rdi)
  80132a:	eb 11                	jmp    80133d <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80132c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801330:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801333:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801337:	48 89 d7             	mov    %rdx,%rdi
  80133a:	fc                   	cld    
  80133b:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80133d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801341:	c9                   	leaveq 
  801342:	c3                   	retq   

0000000000801343 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801343:	55                   	push   %rbp
  801344:	48 89 e5             	mov    %rsp,%rbp
  801347:	48 83 ec 28          	sub    $0x28,%rsp
  80134b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80134f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801353:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801357:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80135f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801363:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80136f:	0f 83 88 00 00 00    	jae    8013fd <memmove+0xba>
  801375:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801379:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80137d:	48 01 d0             	add    %rdx,%rax
  801380:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801384:	76 77                	jbe    8013fd <memmove+0xba>
		s += n;
  801386:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80138e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801392:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801396:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139a:	83 e0 03             	and    $0x3,%eax
  80139d:	48 85 c0             	test   %rax,%rax
  8013a0:	75 3b                	jne    8013dd <memmove+0x9a>
  8013a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a6:	83 e0 03             	and    $0x3,%eax
  8013a9:	48 85 c0             	test   %rax,%rax
  8013ac:	75 2f                	jne    8013dd <memmove+0x9a>
  8013ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b2:	83 e0 03             	and    $0x3,%eax
  8013b5:	48 85 c0             	test   %rax,%rax
  8013b8:	75 23                	jne    8013dd <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013be:	48 83 e8 04          	sub    $0x4,%rax
  8013c2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c6:	48 83 ea 04          	sub    $0x4,%rdx
  8013ca:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013ce:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013d2:	48 89 c7             	mov    %rax,%rdi
  8013d5:	48 89 d6             	mov    %rdx,%rsi
  8013d8:	fd                   	std    
  8013d9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013db:	eb 1d                	jmp    8013fa <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e9:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f1:	48 89 d7             	mov    %rdx,%rdi
  8013f4:	48 89 c1             	mov    %rax,%rcx
  8013f7:	fd                   	std    
  8013f8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013fa:	fc                   	cld    
  8013fb:	eb 57                	jmp    801454 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801401:	83 e0 03             	and    $0x3,%eax
  801404:	48 85 c0             	test   %rax,%rax
  801407:	75 36                	jne    80143f <memmove+0xfc>
  801409:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140d:	83 e0 03             	and    $0x3,%eax
  801410:	48 85 c0             	test   %rax,%rax
  801413:	75 2a                	jne    80143f <memmove+0xfc>
  801415:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801419:	83 e0 03             	and    $0x3,%eax
  80141c:	48 85 c0             	test   %rax,%rax
  80141f:	75 1e                	jne    80143f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801421:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801425:	48 c1 e8 02          	shr    $0x2,%rax
  801429:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80142c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801430:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801434:	48 89 c7             	mov    %rax,%rdi
  801437:	48 89 d6             	mov    %rdx,%rsi
  80143a:	fc                   	cld    
  80143b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80143d:	eb 15                	jmp    801454 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80143f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801443:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801447:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80144b:	48 89 c7             	mov    %rax,%rdi
  80144e:	48 89 d6             	mov    %rdx,%rsi
  801451:	fc                   	cld    
  801452:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801454:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801458:	c9                   	leaveq 
  801459:	c3                   	retq   

000000000080145a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80145a:	55                   	push   %rbp
  80145b:	48 89 e5             	mov    %rsp,%rbp
  80145e:	48 83 ec 18          	sub    $0x18,%rsp
  801462:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801466:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80146a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80146e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801472:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801476:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147a:	48 89 ce             	mov    %rcx,%rsi
  80147d:	48 89 c7             	mov    %rax,%rdi
  801480:	48 b8 43 13 80 00 00 	movabs $0x801343,%rax
  801487:	00 00 00 
  80148a:	ff d0                	callq  *%rax
}
  80148c:	c9                   	leaveq 
  80148d:	c3                   	retq   

000000000080148e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80148e:	55                   	push   %rbp
  80148f:	48 89 e5             	mov    %rsp,%rbp
  801492:	48 83 ec 28          	sub    $0x28,%rsp
  801496:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80149a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80149e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014b2:	eb 36                	jmp    8014ea <memcmp+0x5c>
		if (*s1 != *s2)
  8014b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b8:	0f b6 10             	movzbl (%rax),%edx
  8014bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014bf:	0f b6 00             	movzbl (%rax),%eax
  8014c2:	38 c2                	cmp    %al,%dl
  8014c4:	74 1a                	je     8014e0 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ca:	0f b6 00             	movzbl (%rax),%eax
  8014cd:	0f b6 d0             	movzbl %al,%edx
  8014d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d4:	0f b6 00             	movzbl (%rax),%eax
  8014d7:	0f b6 c0             	movzbl %al,%eax
  8014da:	29 c2                	sub    %eax,%edx
  8014dc:	89 d0                	mov    %edx,%eax
  8014de:	eb 20                	jmp    801500 <memcmp+0x72>
		s1++, s2++;
  8014e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014e5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ee:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014f6:	48 85 c0             	test   %rax,%rax
  8014f9:	75 b9                	jne    8014b4 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801500:	c9                   	leaveq 
  801501:	c3                   	retq   

0000000000801502 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801502:	55                   	push   %rbp
  801503:	48 89 e5             	mov    %rsp,%rbp
  801506:	48 83 ec 28          	sub    $0x28,%rsp
  80150a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80150e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801511:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801515:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801519:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80151d:	48 01 d0             	add    %rdx,%rax
  801520:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801524:	eb 15                	jmp    80153b <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80152a:	0f b6 10             	movzbl (%rax),%edx
  80152d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801530:	38 c2                	cmp    %al,%dl
  801532:	75 02                	jne    801536 <memfind+0x34>
			break;
  801534:	eb 0f                	jmp    801545 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801536:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80153b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801543:	72 e1                	jb     801526 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801545:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801549:	c9                   	leaveq 
  80154a:	c3                   	retq   

000000000080154b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80154b:	55                   	push   %rbp
  80154c:	48 89 e5             	mov    %rsp,%rbp
  80154f:	48 83 ec 34          	sub    $0x34,%rsp
  801553:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801557:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80155b:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80155e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801565:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80156c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80156d:	eb 05                	jmp    801574 <strtol+0x29>
		s++;
  80156f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801574:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801578:	0f b6 00             	movzbl (%rax),%eax
  80157b:	3c 20                	cmp    $0x20,%al
  80157d:	74 f0                	je     80156f <strtol+0x24>
  80157f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801583:	0f b6 00             	movzbl (%rax),%eax
  801586:	3c 09                	cmp    $0x9,%al
  801588:	74 e5                	je     80156f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80158a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158e:	0f b6 00             	movzbl (%rax),%eax
  801591:	3c 2b                	cmp    $0x2b,%al
  801593:	75 07                	jne    80159c <strtol+0x51>
		s++;
  801595:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80159a:	eb 17                	jmp    8015b3 <strtol+0x68>
	else if (*s == '-')
  80159c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a0:	0f b6 00             	movzbl (%rax),%eax
  8015a3:	3c 2d                	cmp    $0x2d,%al
  8015a5:	75 0c                	jne    8015b3 <strtol+0x68>
		s++, neg = 1;
  8015a7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015ac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015b3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015b7:	74 06                	je     8015bf <strtol+0x74>
  8015b9:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015bd:	75 28                	jne    8015e7 <strtol+0x9c>
  8015bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c3:	0f b6 00             	movzbl (%rax),%eax
  8015c6:	3c 30                	cmp    $0x30,%al
  8015c8:	75 1d                	jne    8015e7 <strtol+0x9c>
  8015ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ce:	48 83 c0 01          	add    $0x1,%rax
  8015d2:	0f b6 00             	movzbl (%rax),%eax
  8015d5:	3c 78                	cmp    $0x78,%al
  8015d7:	75 0e                	jne    8015e7 <strtol+0x9c>
		s += 2, base = 16;
  8015d9:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015de:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015e5:	eb 2c                	jmp    801613 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015e7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015eb:	75 19                	jne    801606 <strtol+0xbb>
  8015ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f1:	0f b6 00             	movzbl (%rax),%eax
  8015f4:	3c 30                	cmp    $0x30,%al
  8015f6:	75 0e                	jne    801606 <strtol+0xbb>
		s++, base = 8;
  8015f8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015fd:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801604:	eb 0d                	jmp    801613 <strtol+0xc8>
	else if (base == 0)
  801606:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80160a:	75 07                	jne    801613 <strtol+0xc8>
		base = 10;
  80160c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801613:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801617:	0f b6 00             	movzbl (%rax),%eax
  80161a:	3c 2f                	cmp    $0x2f,%al
  80161c:	7e 1d                	jle    80163b <strtol+0xf0>
  80161e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801622:	0f b6 00             	movzbl (%rax),%eax
  801625:	3c 39                	cmp    $0x39,%al
  801627:	7f 12                	jg     80163b <strtol+0xf0>
			dig = *s - '0';
  801629:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162d:	0f b6 00             	movzbl (%rax),%eax
  801630:	0f be c0             	movsbl %al,%eax
  801633:	83 e8 30             	sub    $0x30,%eax
  801636:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801639:	eb 4e                	jmp    801689 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80163b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163f:	0f b6 00             	movzbl (%rax),%eax
  801642:	3c 60                	cmp    $0x60,%al
  801644:	7e 1d                	jle    801663 <strtol+0x118>
  801646:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164a:	0f b6 00             	movzbl (%rax),%eax
  80164d:	3c 7a                	cmp    $0x7a,%al
  80164f:	7f 12                	jg     801663 <strtol+0x118>
			dig = *s - 'a' + 10;
  801651:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801655:	0f b6 00             	movzbl (%rax),%eax
  801658:	0f be c0             	movsbl %al,%eax
  80165b:	83 e8 57             	sub    $0x57,%eax
  80165e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801661:	eb 26                	jmp    801689 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801663:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801667:	0f b6 00             	movzbl (%rax),%eax
  80166a:	3c 40                	cmp    $0x40,%al
  80166c:	7e 48                	jle    8016b6 <strtol+0x16b>
  80166e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801672:	0f b6 00             	movzbl (%rax),%eax
  801675:	3c 5a                	cmp    $0x5a,%al
  801677:	7f 3d                	jg     8016b6 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801679:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167d:	0f b6 00             	movzbl (%rax),%eax
  801680:	0f be c0             	movsbl %al,%eax
  801683:	83 e8 37             	sub    $0x37,%eax
  801686:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801689:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80168c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80168f:	7c 02                	jl     801693 <strtol+0x148>
			break;
  801691:	eb 23                	jmp    8016b6 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801693:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801698:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80169b:	48 98                	cltq   
  80169d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016a2:	48 89 c2             	mov    %rax,%rdx
  8016a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016a8:	48 98                	cltq   
  8016aa:	48 01 d0             	add    %rdx,%rax
  8016ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016b1:	e9 5d ff ff ff       	jmpq   801613 <strtol+0xc8>

	if (endptr)
  8016b6:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016bb:	74 0b                	je     8016c8 <strtol+0x17d>
		*endptr = (char *) s;
  8016bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016c1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016c5:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016cc:	74 09                	je     8016d7 <strtol+0x18c>
  8016ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d2:	48 f7 d8             	neg    %rax
  8016d5:	eb 04                	jmp    8016db <strtol+0x190>
  8016d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016db:	c9                   	leaveq 
  8016dc:	c3                   	retq   

00000000008016dd <strstr>:

char * strstr(const char *in, const char *str)
{
  8016dd:	55                   	push   %rbp
  8016de:	48 89 e5             	mov    %rsp,%rbp
  8016e1:	48 83 ec 30          	sub    $0x30,%rsp
  8016e5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016e9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8016ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016f1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016f5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016f9:	0f b6 00             	movzbl (%rax),%eax
  8016fc:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8016ff:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801703:	75 06                	jne    80170b <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801705:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801709:	eb 6b                	jmp    801776 <strstr+0x99>

    len = strlen(str);
  80170b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80170f:	48 89 c7             	mov    %rax,%rdi
  801712:	48 b8 b3 0f 80 00 00 	movabs $0x800fb3,%rax
  801719:	00 00 00 
  80171c:	ff d0                	callq  *%rax
  80171e:	48 98                	cltq   
  801720:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801724:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801728:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80172c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801730:	0f b6 00             	movzbl (%rax),%eax
  801733:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801736:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80173a:	75 07                	jne    801743 <strstr+0x66>
                return (char *) 0;
  80173c:	b8 00 00 00 00       	mov    $0x0,%eax
  801741:	eb 33                	jmp    801776 <strstr+0x99>
        } while (sc != c);
  801743:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801747:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80174a:	75 d8                	jne    801724 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  80174c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801750:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801754:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801758:	48 89 ce             	mov    %rcx,%rsi
  80175b:	48 89 c7             	mov    %rax,%rdi
  80175e:	48 b8 d4 11 80 00 00 	movabs $0x8011d4,%rax
  801765:	00 00 00 
  801768:	ff d0                	callq  *%rax
  80176a:	85 c0                	test   %eax,%eax
  80176c:	75 b6                	jne    801724 <strstr+0x47>

    return (char *) (in - 1);
  80176e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801772:	48 83 e8 01          	sub    $0x1,%rax
}
  801776:	c9                   	leaveq 
  801777:	c3                   	retq   

0000000000801778 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801778:	55                   	push   %rbp
  801779:	48 89 e5             	mov    %rsp,%rbp
  80177c:	53                   	push   %rbx
  80177d:	48 83 ec 48          	sub    $0x48,%rsp
  801781:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801784:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801787:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80178b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80178f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801793:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801797:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80179a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80179e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017a2:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017a6:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017aa:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017ae:	4c 89 c3             	mov    %r8,%rbx
  8017b1:	cd 30                	int    $0x30
  8017b3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  8017b7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017bb:	74 3e                	je     8017fb <syscall+0x83>
  8017bd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017c2:	7e 37                	jle    8017fb <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017c8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017cb:	49 89 d0             	mov    %rdx,%r8
  8017ce:	89 c1                	mov    %eax,%ecx
  8017d0:	48 ba 20 3a 80 00 00 	movabs $0x803a20,%rdx
  8017d7:	00 00 00 
  8017da:	be 23 00 00 00       	mov    $0x23,%esi
  8017df:	48 bf 3d 3a 80 00 00 	movabs $0x803a3d,%rdi
  8017e6:	00 00 00 
  8017e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ee:	49 b9 b7 31 80 00 00 	movabs $0x8031b7,%r9
  8017f5:	00 00 00 
  8017f8:	41 ff d1             	callq  *%r9

	return ret;
  8017fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017ff:	48 83 c4 48          	add    $0x48,%rsp
  801803:	5b                   	pop    %rbx
  801804:	5d                   	pop    %rbp
  801805:	c3                   	retq   

0000000000801806 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801806:	55                   	push   %rbp
  801807:	48 89 e5             	mov    %rsp,%rbp
  80180a:	48 83 ec 20          	sub    $0x20,%rsp
  80180e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801812:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801816:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80181a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80181e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801825:	00 
  801826:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80182c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801832:	48 89 d1             	mov    %rdx,%rcx
  801835:	48 89 c2             	mov    %rax,%rdx
  801838:	be 00 00 00 00       	mov    $0x0,%esi
  80183d:	bf 00 00 00 00       	mov    $0x0,%edi
  801842:	48 b8 78 17 80 00 00 	movabs $0x801778,%rax
  801849:	00 00 00 
  80184c:	ff d0                	callq  *%rax
}
  80184e:	c9                   	leaveq 
  80184f:	c3                   	retq   

0000000000801850 <sys_cgetc>:

int
sys_cgetc(void)
{
  801850:	55                   	push   %rbp
  801851:	48 89 e5             	mov    %rsp,%rbp
  801854:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801858:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80185f:	00 
  801860:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801866:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80186c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801871:	ba 00 00 00 00       	mov    $0x0,%edx
  801876:	be 00 00 00 00       	mov    $0x0,%esi
  80187b:	bf 01 00 00 00       	mov    $0x1,%edi
  801880:	48 b8 78 17 80 00 00 	movabs $0x801778,%rax
  801887:	00 00 00 
  80188a:	ff d0                	callq  *%rax
}
  80188c:	c9                   	leaveq 
  80188d:	c3                   	retq   

000000000080188e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80188e:	55                   	push   %rbp
  80188f:	48 89 e5             	mov    %rsp,%rbp
  801892:	48 83 ec 10          	sub    $0x10,%rsp
  801896:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801899:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80189c:	48 98                	cltq   
  80189e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a5:	00 
  8018a6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018b7:	48 89 c2             	mov    %rax,%rdx
  8018ba:	be 01 00 00 00       	mov    $0x1,%esi
  8018bf:	bf 03 00 00 00       	mov    $0x3,%edi
  8018c4:	48 b8 78 17 80 00 00 	movabs $0x801778,%rax
  8018cb:	00 00 00 
  8018ce:	ff d0                	callq  *%rax
}
  8018d0:	c9                   	leaveq 
  8018d1:	c3                   	retq   

00000000008018d2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018d2:	55                   	push   %rbp
  8018d3:	48 89 e5             	mov    %rsp,%rbp
  8018d6:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018da:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e1:	00 
  8018e2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f8:	be 00 00 00 00       	mov    $0x0,%esi
  8018fd:	bf 02 00 00 00       	mov    $0x2,%edi
  801902:	48 b8 78 17 80 00 00 	movabs $0x801778,%rax
  801909:	00 00 00 
  80190c:	ff d0                	callq  *%rax
}
  80190e:	c9                   	leaveq 
  80190f:	c3                   	retq   

0000000000801910 <sys_yield>:

void
sys_yield(void)
{
  801910:	55                   	push   %rbp
  801911:	48 89 e5             	mov    %rsp,%rbp
  801914:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801918:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80191f:	00 
  801920:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801926:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801931:	ba 00 00 00 00       	mov    $0x0,%edx
  801936:	be 00 00 00 00       	mov    $0x0,%esi
  80193b:	bf 0b 00 00 00       	mov    $0xb,%edi
  801940:	48 b8 78 17 80 00 00 	movabs $0x801778,%rax
  801947:	00 00 00 
  80194a:	ff d0                	callq  *%rax
}
  80194c:	c9                   	leaveq 
  80194d:	c3                   	retq   

000000000080194e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80194e:	55                   	push   %rbp
  80194f:	48 89 e5             	mov    %rsp,%rbp
  801952:	48 83 ec 20          	sub    $0x20,%rsp
  801956:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801959:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80195d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801960:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801963:	48 63 c8             	movslq %eax,%rcx
  801966:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80196a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196d:	48 98                	cltq   
  80196f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801976:	00 
  801977:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197d:	49 89 c8             	mov    %rcx,%r8
  801980:	48 89 d1             	mov    %rdx,%rcx
  801983:	48 89 c2             	mov    %rax,%rdx
  801986:	be 01 00 00 00       	mov    $0x1,%esi
  80198b:	bf 04 00 00 00       	mov    $0x4,%edi
  801990:	48 b8 78 17 80 00 00 	movabs $0x801778,%rax
  801997:	00 00 00 
  80199a:	ff d0                	callq  *%rax
}
  80199c:	c9                   	leaveq 
  80199d:	c3                   	retq   

000000000080199e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80199e:	55                   	push   %rbp
  80199f:	48 89 e5             	mov    %rsp,%rbp
  8019a2:	48 83 ec 30          	sub    $0x30,%rsp
  8019a6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019ad:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019b0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019b4:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019b8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019bb:	48 63 c8             	movslq %eax,%rcx
  8019be:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019c5:	48 63 f0             	movslq %eax,%rsi
  8019c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019cf:	48 98                	cltq   
  8019d1:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019d5:	49 89 f9             	mov    %rdi,%r9
  8019d8:	49 89 f0             	mov    %rsi,%r8
  8019db:	48 89 d1             	mov    %rdx,%rcx
  8019de:	48 89 c2             	mov    %rax,%rdx
  8019e1:	be 01 00 00 00       	mov    $0x1,%esi
  8019e6:	bf 05 00 00 00       	mov    $0x5,%edi
  8019eb:	48 b8 78 17 80 00 00 	movabs $0x801778,%rax
  8019f2:	00 00 00 
  8019f5:	ff d0                	callq  *%rax
}
  8019f7:	c9                   	leaveq 
  8019f8:	c3                   	retq   

00000000008019f9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8019f9:	55                   	push   %rbp
  8019fa:	48 89 e5             	mov    %rsp,%rbp
  8019fd:	48 83 ec 20          	sub    $0x20,%rsp
  801a01:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a04:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a08:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0f:	48 98                	cltq   
  801a11:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a18:	00 
  801a19:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a25:	48 89 d1             	mov    %rdx,%rcx
  801a28:	48 89 c2             	mov    %rax,%rdx
  801a2b:	be 01 00 00 00       	mov    $0x1,%esi
  801a30:	bf 06 00 00 00       	mov    $0x6,%edi
  801a35:	48 b8 78 17 80 00 00 	movabs $0x801778,%rax
  801a3c:	00 00 00 
  801a3f:	ff d0                	callq  *%rax
}
  801a41:	c9                   	leaveq 
  801a42:	c3                   	retq   

0000000000801a43 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a43:	55                   	push   %rbp
  801a44:	48 89 e5             	mov    %rsp,%rbp
  801a47:	48 83 ec 10          	sub    $0x10,%rsp
  801a4b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a4e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a51:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a54:	48 63 d0             	movslq %eax,%rdx
  801a57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a5a:	48 98                	cltq   
  801a5c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a63:	00 
  801a64:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a6a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a70:	48 89 d1             	mov    %rdx,%rcx
  801a73:	48 89 c2             	mov    %rax,%rdx
  801a76:	be 01 00 00 00       	mov    $0x1,%esi
  801a7b:	bf 08 00 00 00       	mov    $0x8,%edi
  801a80:	48 b8 78 17 80 00 00 	movabs $0x801778,%rax
  801a87:	00 00 00 
  801a8a:	ff d0                	callq  *%rax
}
  801a8c:	c9                   	leaveq 
  801a8d:	c3                   	retq   

0000000000801a8e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a8e:	55                   	push   %rbp
  801a8f:	48 89 e5             	mov    %rsp,%rbp
  801a92:	48 83 ec 20          	sub    $0x20,%rsp
  801a96:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a99:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a9d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aa1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa4:	48 98                	cltq   
  801aa6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aad:	00 
  801aae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aba:	48 89 d1             	mov    %rdx,%rcx
  801abd:	48 89 c2             	mov    %rax,%rdx
  801ac0:	be 01 00 00 00       	mov    $0x1,%esi
  801ac5:	bf 09 00 00 00       	mov    $0x9,%edi
  801aca:	48 b8 78 17 80 00 00 	movabs $0x801778,%rax
  801ad1:	00 00 00 
  801ad4:	ff d0                	callq  *%rax
}
  801ad6:	c9                   	leaveq 
  801ad7:	c3                   	retq   

0000000000801ad8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ad8:	55                   	push   %rbp
  801ad9:	48 89 e5             	mov    %rsp,%rbp
  801adc:	48 83 ec 20          	sub    $0x20,%rsp
  801ae0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ae3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ae7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aee:	48 98                	cltq   
  801af0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af7:	00 
  801af8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801afe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b04:	48 89 d1             	mov    %rdx,%rcx
  801b07:	48 89 c2             	mov    %rax,%rdx
  801b0a:	be 01 00 00 00       	mov    $0x1,%esi
  801b0f:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b14:	48 b8 78 17 80 00 00 	movabs $0x801778,%rax
  801b1b:	00 00 00 
  801b1e:	ff d0                	callq  *%rax
}
  801b20:	c9                   	leaveq 
  801b21:	c3                   	retq   

0000000000801b22 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b22:	55                   	push   %rbp
  801b23:	48 89 e5             	mov    %rsp,%rbp
  801b26:	48 83 ec 20          	sub    $0x20,%rsp
  801b2a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b2d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b31:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b35:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b38:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b3b:	48 63 f0             	movslq %eax,%rsi
  801b3e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b45:	48 98                	cltq   
  801b47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b4b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b52:	00 
  801b53:	49 89 f1             	mov    %rsi,%r9
  801b56:	49 89 c8             	mov    %rcx,%r8
  801b59:	48 89 d1             	mov    %rdx,%rcx
  801b5c:	48 89 c2             	mov    %rax,%rdx
  801b5f:	be 00 00 00 00       	mov    $0x0,%esi
  801b64:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b69:	48 b8 78 17 80 00 00 	movabs $0x801778,%rax
  801b70:	00 00 00 
  801b73:	ff d0                	callq  *%rax
}
  801b75:	c9                   	leaveq 
  801b76:	c3                   	retq   

0000000000801b77 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b77:	55                   	push   %rbp
  801b78:	48 89 e5             	mov    %rsp,%rbp
  801b7b:	48 83 ec 10          	sub    $0x10,%rsp
  801b7f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b87:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b8e:	00 
  801b8f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b95:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b9b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ba0:	48 89 c2             	mov    %rax,%rdx
  801ba3:	be 01 00 00 00       	mov    $0x1,%esi
  801ba8:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bad:	48 b8 78 17 80 00 00 	movabs $0x801778,%rax
  801bb4:	00 00 00 
  801bb7:	ff d0                	callq  *%rax
}
  801bb9:	c9                   	leaveq 
  801bba:	c3                   	retq   

0000000000801bbb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801bbb:	55                   	push   %rbp
  801bbc:	48 89 e5             	mov    %rsp,%rbp
  801bbf:	48 83 ec 08          	sub    $0x8,%rsp
  801bc3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801bc7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bcb:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801bd2:	ff ff ff 
  801bd5:	48 01 d0             	add    %rdx,%rax
  801bd8:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801bdc:	c9                   	leaveq 
  801bdd:	c3                   	retq   

0000000000801bde <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801bde:	55                   	push   %rbp
  801bdf:	48 89 e5             	mov    %rsp,%rbp
  801be2:	48 83 ec 08          	sub    $0x8,%rsp
  801be6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801bea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bee:	48 89 c7             	mov    %rax,%rdi
  801bf1:	48 b8 bb 1b 80 00 00 	movabs $0x801bbb,%rax
  801bf8:	00 00 00 
  801bfb:	ff d0                	callq  *%rax
  801bfd:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801c03:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801c07:	c9                   	leaveq 
  801c08:	c3                   	retq   

0000000000801c09 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c09:	55                   	push   %rbp
  801c0a:	48 89 e5             	mov    %rsp,%rbp
  801c0d:	48 83 ec 18          	sub    $0x18,%rsp
  801c11:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c1c:	eb 6b                	jmp    801c89 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801c1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c21:	48 98                	cltq   
  801c23:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c29:	48 c1 e0 0c          	shl    $0xc,%rax
  801c2d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801c31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c35:	48 c1 e8 15          	shr    $0x15,%rax
  801c39:	48 89 c2             	mov    %rax,%rdx
  801c3c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c43:	01 00 00 
  801c46:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c4a:	83 e0 01             	and    $0x1,%eax
  801c4d:	48 85 c0             	test   %rax,%rax
  801c50:	74 21                	je     801c73 <fd_alloc+0x6a>
  801c52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c56:	48 c1 e8 0c          	shr    $0xc,%rax
  801c5a:	48 89 c2             	mov    %rax,%rdx
  801c5d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c64:	01 00 00 
  801c67:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c6b:	83 e0 01             	and    $0x1,%eax
  801c6e:	48 85 c0             	test   %rax,%rax
  801c71:	75 12                	jne    801c85 <fd_alloc+0x7c>
			*fd_store = fd;
  801c73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c77:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c7b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801c7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c83:	eb 1a                	jmp    801c9f <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c85:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c89:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801c8d:	7e 8f                	jle    801c1e <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801c8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c93:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801c9a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801c9f:	c9                   	leaveq 
  801ca0:	c3                   	retq   

0000000000801ca1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ca1:	55                   	push   %rbp
  801ca2:	48 89 e5             	mov    %rsp,%rbp
  801ca5:	48 83 ec 20          	sub    $0x20,%rsp
  801ca9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801cac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801cb0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801cb4:	78 06                	js     801cbc <fd_lookup+0x1b>
  801cb6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801cba:	7e 07                	jle    801cc3 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801cbc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cc1:	eb 6c                	jmp    801d2f <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801cc3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801cc6:	48 98                	cltq   
  801cc8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801cce:	48 c1 e0 0c          	shl    $0xc,%rax
  801cd2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801cd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cda:	48 c1 e8 15          	shr    $0x15,%rax
  801cde:	48 89 c2             	mov    %rax,%rdx
  801ce1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ce8:	01 00 00 
  801ceb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cef:	83 e0 01             	and    $0x1,%eax
  801cf2:	48 85 c0             	test   %rax,%rax
  801cf5:	74 21                	je     801d18 <fd_lookup+0x77>
  801cf7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cfb:	48 c1 e8 0c          	shr    $0xc,%rax
  801cff:	48 89 c2             	mov    %rax,%rdx
  801d02:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d09:	01 00 00 
  801d0c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d10:	83 e0 01             	and    $0x1,%eax
  801d13:	48 85 c0             	test   %rax,%rax
  801d16:	75 07                	jne    801d1f <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d1d:	eb 10                	jmp    801d2f <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801d1f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d23:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d27:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801d2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2f:	c9                   	leaveq 
  801d30:	c3                   	retq   

0000000000801d31 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801d31:	55                   	push   %rbp
  801d32:	48 89 e5             	mov    %rsp,%rbp
  801d35:	48 83 ec 30          	sub    $0x30,%rsp
  801d39:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d3d:	89 f0                	mov    %esi,%eax
  801d3f:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801d42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d46:	48 89 c7             	mov    %rax,%rdi
  801d49:	48 b8 bb 1b 80 00 00 	movabs $0x801bbb,%rax
  801d50:	00 00 00 
  801d53:	ff d0                	callq  *%rax
  801d55:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d59:	48 89 d6             	mov    %rdx,%rsi
  801d5c:	89 c7                	mov    %eax,%edi
  801d5e:	48 b8 a1 1c 80 00 00 	movabs $0x801ca1,%rax
  801d65:	00 00 00 
  801d68:	ff d0                	callq  *%rax
  801d6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d71:	78 0a                	js     801d7d <fd_close+0x4c>
	    || fd != fd2)
  801d73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d77:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801d7b:	74 12                	je     801d8f <fd_close+0x5e>
		return (must_exist ? r : 0);
  801d7d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801d81:	74 05                	je     801d88 <fd_close+0x57>
  801d83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d86:	eb 05                	jmp    801d8d <fd_close+0x5c>
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8d:	eb 69                	jmp    801df8 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801d8f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d93:	8b 00                	mov    (%rax),%eax
  801d95:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801d99:	48 89 d6             	mov    %rdx,%rsi
  801d9c:	89 c7                	mov    %eax,%edi
  801d9e:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  801da5:	00 00 00 
  801da8:	ff d0                	callq  *%rax
  801daa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801db1:	78 2a                	js     801ddd <fd_close+0xac>
		if (dev->dev_close)
  801db3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801db7:	48 8b 40 20          	mov    0x20(%rax),%rax
  801dbb:	48 85 c0             	test   %rax,%rax
  801dbe:	74 16                	je     801dd6 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801dc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc4:	48 8b 40 20          	mov    0x20(%rax),%rax
  801dc8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801dcc:	48 89 d7             	mov    %rdx,%rdi
  801dcf:	ff d0                	callq  *%rax
  801dd1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dd4:	eb 07                	jmp    801ddd <fd_close+0xac>
		else
			r = 0;
  801dd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ddd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801de1:	48 89 c6             	mov    %rax,%rsi
  801de4:	bf 00 00 00 00       	mov    $0x0,%edi
  801de9:	48 b8 f9 19 80 00 00 	movabs $0x8019f9,%rax
  801df0:	00 00 00 
  801df3:	ff d0                	callq  *%rax
	return r;
  801df5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801df8:	c9                   	leaveq 
  801df9:	c3                   	retq   

0000000000801dfa <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801dfa:	55                   	push   %rbp
  801dfb:	48 89 e5             	mov    %rsp,%rbp
  801dfe:	48 83 ec 20          	sub    $0x20,%rsp
  801e02:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e05:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801e09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e10:	eb 41                	jmp    801e53 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801e12:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801e19:	00 00 00 
  801e1c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e1f:	48 63 d2             	movslq %edx,%rdx
  801e22:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e26:	8b 00                	mov    (%rax),%eax
  801e28:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801e2b:	75 22                	jne    801e4f <dev_lookup+0x55>
			*dev = devtab[i];
  801e2d:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801e34:	00 00 00 
  801e37:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e3a:	48 63 d2             	movslq %edx,%rdx
  801e3d:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801e41:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e45:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e48:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4d:	eb 60                	jmp    801eaf <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801e4f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e53:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801e5a:	00 00 00 
  801e5d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e60:	48 63 d2             	movslq %edx,%rdx
  801e63:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e67:	48 85 c0             	test   %rax,%rax
  801e6a:	75 a6                	jne    801e12 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801e6c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801e73:	00 00 00 
  801e76:	48 8b 00             	mov    (%rax),%rax
  801e79:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801e7f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e82:	89 c6                	mov    %eax,%esi
  801e84:	48 bf 50 3a 80 00 00 	movabs $0x803a50,%rdi
  801e8b:	00 00 00 
  801e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e93:	48 b9 77 02 80 00 00 	movabs $0x800277,%rcx
  801e9a:	00 00 00 
  801e9d:	ff d1                	callq  *%rcx
	*dev = 0;
  801e9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ea3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801eaa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801eaf:	c9                   	leaveq 
  801eb0:	c3                   	retq   

0000000000801eb1 <close>:

int
close(int fdnum)
{
  801eb1:	55                   	push   %rbp
  801eb2:	48 89 e5             	mov    %rsp,%rbp
  801eb5:	48 83 ec 20          	sub    $0x20,%rsp
  801eb9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ebc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ec0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ec3:	48 89 d6             	mov    %rdx,%rsi
  801ec6:	89 c7                	mov    %eax,%edi
  801ec8:	48 b8 a1 1c 80 00 00 	movabs $0x801ca1,%rax
  801ecf:	00 00 00 
  801ed2:	ff d0                	callq  *%rax
  801ed4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ed7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801edb:	79 05                	jns    801ee2 <close+0x31>
		return r;
  801edd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee0:	eb 18                	jmp    801efa <close+0x49>
	else
		return fd_close(fd, 1);
  801ee2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ee6:	be 01 00 00 00       	mov    $0x1,%esi
  801eeb:	48 89 c7             	mov    %rax,%rdi
  801eee:	48 b8 31 1d 80 00 00 	movabs $0x801d31,%rax
  801ef5:	00 00 00 
  801ef8:	ff d0                	callq  *%rax
}
  801efa:	c9                   	leaveq 
  801efb:	c3                   	retq   

0000000000801efc <close_all>:

void
close_all(void)
{
  801efc:	55                   	push   %rbp
  801efd:	48 89 e5             	mov    %rsp,%rbp
  801f00:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f0b:	eb 15                	jmp    801f22 <close_all+0x26>
		close(i);
  801f0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f10:	89 c7                	mov    %eax,%edi
  801f12:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  801f19:	00 00 00 
  801f1c:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801f1e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f22:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f26:	7e e5                	jle    801f0d <close_all+0x11>
		close(i);
}
  801f28:	c9                   	leaveq 
  801f29:	c3                   	retq   

0000000000801f2a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f2a:	55                   	push   %rbp
  801f2b:	48 89 e5             	mov    %rsp,%rbp
  801f2e:	48 83 ec 40          	sub    $0x40,%rsp
  801f32:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801f35:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801f38:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801f3c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f3f:	48 89 d6             	mov    %rdx,%rsi
  801f42:	89 c7                	mov    %eax,%edi
  801f44:	48 b8 a1 1c 80 00 00 	movabs $0x801ca1,%rax
  801f4b:	00 00 00 
  801f4e:	ff d0                	callq  *%rax
  801f50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f57:	79 08                	jns    801f61 <dup+0x37>
		return r;
  801f59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f5c:	e9 70 01 00 00       	jmpq   8020d1 <dup+0x1a7>
	close(newfdnum);
  801f61:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f64:	89 c7                	mov    %eax,%edi
  801f66:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  801f6d:	00 00 00 
  801f70:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801f72:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f75:	48 98                	cltq   
  801f77:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f7d:	48 c1 e0 0c          	shl    $0xc,%rax
  801f81:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801f85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f89:	48 89 c7             	mov    %rax,%rdi
  801f8c:	48 b8 de 1b 80 00 00 	movabs $0x801bde,%rax
  801f93:	00 00 00 
  801f96:	ff d0                	callq  *%rax
  801f98:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801f9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa0:	48 89 c7             	mov    %rax,%rdi
  801fa3:	48 b8 de 1b 80 00 00 	movabs $0x801bde,%rax
  801faa:	00 00 00 
  801fad:	ff d0                	callq  *%rax
  801faf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801fb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb7:	48 c1 e8 15          	shr    $0x15,%rax
  801fbb:	48 89 c2             	mov    %rax,%rdx
  801fbe:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fc5:	01 00 00 
  801fc8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fcc:	83 e0 01             	and    $0x1,%eax
  801fcf:	48 85 c0             	test   %rax,%rax
  801fd2:	74 73                	je     802047 <dup+0x11d>
  801fd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd8:	48 c1 e8 0c          	shr    $0xc,%rax
  801fdc:	48 89 c2             	mov    %rax,%rdx
  801fdf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fe6:	01 00 00 
  801fe9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fed:	83 e0 01             	and    $0x1,%eax
  801ff0:	48 85 c0             	test   %rax,%rax
  801ff3:	74 52                	je     802047 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801ff5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ff9:	48 c1 e8 0c          	shr    $0xc,%rax
  801ffd:	48 89 c2             	mov    %rax,%rdx
  802000:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802007:	01 00 00 
  80200a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80200e:	25 07 0e 00 00       	and    $0xe07,%eax
  802013:	89 c1                	mov    %eax,%ecx
  802015:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802019:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80201d:	41 89 c8             	mov    %ecx,%r8d
  802020:	48 89 d1             	mov    %rdx,%rcx
  802023:	ba 00 00 00 00       	mov    $0x0,%edx
  802028:	48 89 c6             	mov    %rax,%rsi
  80202b:	bf 00 00 00 00       	mov    $0x0,%edi
  802030:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  802037:	00 00 00 
  80203a:	ff d0                	callq  *%rax
  80203c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80203f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802043:	79 02                	jns    802047 <dup+0x11d>
			goto err;
  802045:	eb 57                	jmp    80209e <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802047:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80204b:	48 c1 e8 0c          	shr    $0xc,%rax
  80204f:	48 89 c2             	mov    %rax,%rdx
  802052:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802059:	01 00 00 
  80205c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802060:	25 07 0e 00 00       	and    $0xe07,%eax
  802065:	89 c1                	mov    %eax,%ecx
  802067:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80206b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80206f:	41 89 c8             	mov    %ecx,%r8d
  802072:	48 89 d1             	mov    %rdx,%rcx
  802075:	ba 00 00 00 00       	mov    $0x0,%edx
  80207a:	48 89 c6             	mov    %rax,%rsi
  80207d:	bf 00 00 00 00       	mov    $0x0,%edi
  802082:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  802089:	00 00 00 
  80208c:	ff d0                	callq  *%rax
  80208e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802091:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802095:	79 02                	jns    802099 <dup+0x16f>
		goto err;
  802097:	eb 05                	jmp    80209e <dup+0x174>

	return newfdnum;
  802099:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80209c:	eb 33                	jmp    8020d1 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80209e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020a2:	48 89 c6             	mov    %rax,%rsi
  8020a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8020aa:	48 b8 f9 19 80 00 00 	movabs $0x8019f9,%rax
  8020b1:	00 00 00 
  8020b4:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8020b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020ba:	48 89 c6             	mov    %rax,%rsi
  8020bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c2:	48 b8 f9 19 80 00 00 	movabs $0x8019f9,%rax
  8020c9:	00 00 00 
  8020cc:	ff d0                	callq  *%rax
	return r;
  8020ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020d1:	c9                   	leaveq 
  8020d2:	c3                   	retq   

00000000008020d3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8020d3:	55                   	push   %rbp
  8020d4:	48 89 e5             	mov    %rsp,%rbp
  8020d7:	48 83 ec 40          	sub    $0x40,%rsp
  8020db:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8020de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8020e2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020e6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020ea:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8020ed:	48 89 d6             	mov    %rdx,%rsi
  8020f0:	89 c7                	mov    %eax,%edi
  8020f2:	48 b8 a1 1c 80 00 00 	movabs $0x801ca1,%rax
  8020f9:	00 00 00 
  8020fc:	ff d0                	callq  *%rax
  8020fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802101:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802105:	78 24                	js     80212b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802107:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80210b:	8b 00                	mov    (%rax),%eax
  80210d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802111:	48 89 d6             	mov    %rdx,%rsi
  802114:	89 c7                	mov    %eax,%edi
  802116:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  80211d:	00 00 00 
  802120:	ff d0                	callq  *%rax
  802122:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802125:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802129:	79 05                	jns    802130 <read+0x5d>
		return r;
  80212b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80212e:	eb 76                	jmp    8021a6 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802134:	8b 40 08             	mov    0x8(%rax),%eax
  802137:	83 e0 03             	and    $0x3,%eax
  80213a:	83 f8 01             	cmp    $0x1,%eax
  80213d:	75 3a                	jne    802179 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80213f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802146:	00 00 00 
  802149:	48 8b 00             	mov    (%rax),%rax
  80214c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802152:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802155:	89 c6                	mov    %eax,%esi
  802157:	48 bf 6f 3a 80 00 00 	movabs $0x803a6f,%rdi
  80215e:	00 00 00 
  802161:	b8 00 00 00 00       	mov    $0x0,%eax
  802166:	48 b9 77 02 80 00 00 	movabs $0x800277,%rcx
  80216d:	00 00 00 
  802170:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802172:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802177:	eb 2d                	jmp    8021a6 <read+0xd3>
	}
	if (!dev->dev_read)
  802179:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80217d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802181:	48 85 c0             	test   %rax,%rax
  802184:	75 07                	jne    80218d <read+0xba>
		return -E_NOT_SUPP;
  802186:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80218b:	eb 19                	jmp    8021a6 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80218d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802191:	48 8b 40 10          	mov    0x10(%rax),%rax
  802195:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802199:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80219d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8021a1:	48 89 cf             	mov    %rcx,%rdi
  8021a4:	ff d0                	callq  *%rax
}
  8021a6:	c9                   	leaveq 
  8021a7:	c3                   	retq   

00000000008021a8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8021a8:	55                   	push   %rbp
  8021a9:	48 89 e5             	mov    %rsp,%rbp
  8021ac:	48 83 ec 30          	sub    $0x30,%rsp
  8021b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8021bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021c2:	eb 49                	jmp    80220d <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8021c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021c7:	48 98                	cltq   
  8021c9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021cd:	48 29 c2             	sub    %rax,%rdx
  8021d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d3:	48 63 c8             	movslq %eax,%rcx
  8021d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021da:	48 01 c1             	add    %rax,%rcx
  8021dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021e0:	48 89 ce             	mov    %rcx,%rsi
  8021e3:	89 c7                	mov    %eax,%edi
  8021e5:	48 b8 d3 20 80 00 00 	movabs $0x8020d3,%rax
  8021ec:	00 00 00 
  8021ef:	ff d0                	callq  *%rax
  8021f1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8021f4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8021f8:	79 05                	jns    8021ff <readn+0x57>
			return m;
  8021fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021fd:	eb 1c                	jmp    80221b <readn+0x73>
		if (m == 0)
  8021ff:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802203:	75 02                	jne    802207 <readn+0x5f>
			break;
  802205:	eb 11                	jmp    802218 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802207:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80220a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80220d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802210:	48 98                	cltq   
  802212:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802216:	72 ac                	jb     8021c4 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802218:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80221b:	c9                   	leaveq 
  80221c:	c3                   	retq   

000000000080221d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80221d:	55                   	push   %rbp
  80221e:	48 89 e5             	mov    %rsp,%rbp
  802221:	48 83 ec 40          	sub    $0x40,%rsp
  802225:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802228:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80222c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802230:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802234:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802237:	48 89 d6             	mov    %rdx,%rsi
  80223a:	89 c7                	mov    %eax,%edi
  80223c:	48 b8 a1 1c 80 00 00 	movabs $0x801ca1,%rax
  802243:	00 00 00 
  802246:	ff d0                	callq  *%rax
  802248:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80224b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80224f:	78 24                	js     802275 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802251:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802255:	8b 00                	mov    (%rax),%eax
  802257:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80225b:	48 89 d6             	mov    %rdx,%rsi
  80225e:	89 c7                	mov    %eax,%edi
  802260:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  802267:	00 00 00 
  80226a:	ff d0                	callq  *%rax
  80226c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80226f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802273:	79 05                	jns    80227a <write+0x5d>
		return r;
  802275:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802278:	eb 75                	jmp    8022ef <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80227a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227e:	8b 40 08             	mov    0x8(%rax),%eax
  802281:	83 e0 03             	and    $0x3,%eax
  802284:	85 c0                	test   %eax,%eax
  802286:	75 3a                	jne    8022c2 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802288:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80228f:	00 00 00 
  802292:	48 8b 00             	mov    (%rax),%rax
  802295:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80229b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80229e:	89 c6                	mov    %eax,%esi
  8022a0:	48 bf 8b 3a 80 00 00 	movabs $0x803a8b,%rdi
  8022a7:	00 00 00 
  8022aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8022af:	48 b9 77 02 80 00 00 	movabs $0x800277,%rcx
  8022b6:	00 00 00 
  8022b9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022c0:	eb 2d                	jmp    8022ef <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8022c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022c6:	48 8b 40 18          	mov    0x18(%rax),%rax
  8022ca:	48 85 c0             	test   %rax,%rax
  8022cd:	75 07                	jne    8022d6 <write+0xb9>
		return -E_NOT_SUPP;
  8022cf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022d4:	eb 19                	jmp    8022ef <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8022d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022da:	48 8b 40 18          	mov    0x18(%rax),%rax
  8022de:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022e2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022e6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022ea:	48 89 cf             	mov    %rcx,%rdi
  8022ed:	ff d0                	callq  *%rax
}
  8022ef:	c9                   	leaveq 
  8022f0:	c3                   	retq   

00000000008022f1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8022f1:	55                   	push   %rbp
  8022f2:	48 89 e5             	mov    %rsp,%rbp
  8022f5:	48 83 ec 18          	sub    $0x18,%rsp
  8022f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022fc:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022ff:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802303:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802306:	48 89 d6             	mov    %rdx,%rsi
  802309:	89 c7                	mov    %eax,%edi
  80230b:	48 b8 a1 1c 80 00 00 	movabs $0x801ca1,%rax
  802312:	00 00 00 
  802315:	ff d0                	callq  *%rax
  802317:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80231a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80231e:	79 05                	jns    802325 <seek+0x34>
		return r;
  802320:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802323:	eb 0f                	jmp    802334 <seek+0x43>
	fd->fd_offset = offset;
  802325:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802329:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80232c:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80232f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802334:	c9                   	leaveq 
  802335:	c3                   	retq   

0000000000802336 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802336:	55                   	push   %rbp
  802337:	48 89 e5             	mov    %rsp,%rbp
  80233a:	48 83 ec 30          	sub    $0x30,%rsp
  80233e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802341:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802344:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802348:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80234b:	48 89 d6             	mov    %rdx,%rsi
  80234e:	89 c7                	mov    %eax,%edi
  802350:	48 b8 a1 1c 80 00 00 	movabs $0x801ca1,%rax
  802357:	00 00 00 
  80235a:	ff d0                	callq  *%rax
  80235c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80235f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802363:	78 24                	js     802389 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802365:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802369:	8b 00                	mov    (%rax),%eax
  80236b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80236f:	48 89 d6             	mov    %rdx,%rsi
  802372:	89 c7                	mov    %eax,%edi
  802374:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  80237b:	00 00 00 
  80237e:	ff d0                	callq  *%rax
  802380:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802383:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802387:	79 05                	jns    80238e <ftruncate+0x58>
		return r;
  802389:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80238c:	eb 72                	jmp    802400 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80238e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802392:	8b 40 08             	mov    0x8(%rax),%eax
  802395:	83 e0 03             	and    $0x3,%eax
  802398:	85 c0                	test   %eax,%eax
  80239a:	75 3a                	jne    8023d6 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80239c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8023a3:	00 00 00 
  8023a6:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8023a9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023af:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023b2:	89 c6                	mov    %eax,%esi
  8023b4:	48 bf a8 3a 80 00 00 	movabs $0x803aa8,%rdi
  8023bb:	00 00 00 
  8023be:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c3:	48 b9 77 02 80 00 00 	movabs $0x800277,%rcx
  8023ca:	00 00 00 
  8023cd:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8023cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023d4:	eb 2a                	jmp    802400 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8023d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023da:	48 8b 40 30          	mov    0x30(%rax),%rax
  8023de:	48 85 c0             	test   %rax,%rax
  8023e1:	75 07                	jne    8023ea <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8023e3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023e8:	eb 16                	jmp    802400 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8023ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ee:	48 8b 40 30          	mov    0x30(%rax),%rax
  8023f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023f6:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8023f9:	89 ce                	mov    %ecx,%esi
  8023fb:	48 89 d7             	mov    %rdx,%rdi
  8023fe:	ff d0                	callq  *%rax
}
  802400:	c9                   	leaveq 
  802401:	c3                   	retq   

0000000000802402 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802402:	55                   	push   %rbp
  802403:	48 89 e5             	mov    %rsp,%rbp
  802406:	48 83 ec 30          	sub    $0x30,%rsp
  80240a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80240d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802411:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802415:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802418:	48 89 d6             	mov    %rdx,%rsi
  80241b:	89 c7                	mov    %eax,%edi
  80241d:	48 b8 a1 1c 80 00 00 	movabs $0x801ca1,%rax
  802424:	00 00 00 
  802427:	ff d0                	callq  *%rax
  802429:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80242c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802430:	78 24                	js     802456 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802432:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802436:	8b 00                	mov    (%rax),%eax
  802438:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80243c:	48 89 d6             	mov    %rdx,%rsi
  80243f:	89 c7                	mov    %eax,%edi
  802441:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  802448:	00 00 00 
  80244b:	ff d0                	callq  *%rax
  80244d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802450:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802454:	79 05                	jns    80245b <fstat+0x59>
		return r;
  802456:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802459:	eb 5e                	jmp    8024b9 <fstat+0xb7>
	if (!dev->dev_stat)
  80245b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80245f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802463:	48 85 c0             	test   %rax,%rax
  802466:	75 07                	jne    80246f <fstat+0x6d>
		return -E_NOT_SUPP;
  802468:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80246d:	eb 4a                	jmp    8024b9 <fstat+0xb7>
	stat->st_name[0] = 0;
  80246f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802473:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802476:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80247a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802481:	00 00 00 
	stat->st_isdir = 0;
  802484:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802488:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80248f:	00 00 00 
	stat->st_dev = dev;
  802492:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802496:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80249a:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8024a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a5:	48 8b 40 28          	mov    0x28(%rax),%rax
  8024a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024ad:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8024b1:	48 89 ce             	mov    %rcx,%rsi
  8024b4:	48 89 d7             	mov    %rdx,%rdi
  8024b7:	ff d0                	callq  *%rax
}
  8024b9:	c9                   	leaveq 
  8024ba:	c3                   	retq   

00000000008024bb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8024bb:	55                   	push   %rbp
  8024bc:	48 89 e5             	mov    %rsp,%rbp
  8024bf:	48 83 ec 20          	sub    $0x20,%rsp
  8024c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8024c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8024cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024cf:	be 00 00 00 00       	mov    $0x0,%esi
  8024d4:	48 89 c7             	mov    %rax,%rdi
  8024d7:	48 b8 a9 25 80 00 00 	movabs $0x8025a9,%rax
  8024de:	00 00 00 
  8024e1:	ff d0                	callq  *%rax
  8024e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ea:	79 05                	jns    8024f1 <stat+0x36>
		return fd;
  8024ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ef:	eb 2f                	jmp    802520 <stat+0x65>
	r = fstat(fd, stat);
  8024f1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8024f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f8:	48 89 d6             	mov    %rdx,%rsi
  8024fb:	89 c7                	mov    %eax,%edi
  8024fd:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  802504:	00 00 00 
  802507:	ff d0                	callq  *%rax
  802509:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80250c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80250f:	89 c7                	mov    %eax,%edi
  802511:	48 b8 b1 1e 80 00 00 	movabs $0x801eb1,%rax
  802518:	00 00 00 
  80251b:	ff d0                	callq  *%rax
	return r;
  80251d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802520:	c9                   	leaveq 
  802521:	c3                   	retq   

0000000000802522 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802522:	55                   	push   %rbp
  802523:	48 89 e5             	mov    %rsp,%rbp
  802526:	48 83 ec 10          	sub    $0x10,%rsp
  80252a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80252d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802531:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802538:	00 00 00 
  80253b:	8b 00                	mov    (%rax),%eax
  80253d:	85 c0                	test   %eax,%eax
  80253f:	75 1d                	jne    80255e <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802541:	bf 01 00 00 00       	mov    $0x1,%edi
  802546:	48 b8 2c 34 80 00 00 	movabs $0x80342c,%rax
  80254d:	00 00 00 
  802550:	ff d0                	callq  *%rax
  802552:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  802559:	00 00 00 
  80255c:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80255e:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802565:	00 00 00 
  802568:	8b 00                	mov    (%rax),%eax
  80256a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80256d:	b9 07 00 00 00       	mov    $0x7,%ecx
  802572:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802579:	00 00 00 
  80257c:	89 c7                	mov    %eax,%edi
  80257e:	48 b8 94 33 80 00 00 	movabs $0x803394,%rax
  802585:	00 00 00 
  802588:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80258a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80258e:	ba 00 00 00 00       	mov    $0x0,%edx
  802593:	48 89 c6             	mov    %rax,%rsi
  802596:	bf 00 00 00 00       	mov    $0x0,%edi
  80259b:	48 b8 cb 32 80 00 00 	movabs $0x8032cb,%rax
  8025a2:	00 00 00 
  8025a5:	ff d0                	callq  *%rax
}
  8025a7:	c9                   	leaveq 
  8025a8:	c3                   	retq   

00000000008025a9 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8025a9:	55                   	push   %rbp
  8025aa:	48 89 e5             	mov    %rsp,%rbp
  8025ad:	48 83 ec 20          	sub    $0x20,%rsp
  8025b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025b5:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  8025b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025bc:	48 89 c7             	mov    %rax,%rdi
  8025bf:	48 b8 b3 0f 80 00 00 	movabs $0x800fb3,%rax
  8025c6:	00 00 00 
  8025c9:	ff d0                	callq  *%rax
  8025cb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8025d0:	7e 0a                	jle    8025dc <open+0x33>
		return -E_BAD_PATH;
  8025d2:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8025d7:	e9 a5 00 00 00       	jmpq   802681 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8025dc:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8025e0:	48 89 c7             	mov    %rax,%rdi
  8025e3:	48 b8 09 1c 80 00 00 	movabs $0x801c09,%rax
  8025ea:	00 00 00 
  8025ed:	ff d0                	callq  *%rax
  8025ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025f6:	79 08                	jns    802600 <open+0x57>
		return r;
  8025f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025fb:	e9 81 00 00 00       	jmpq   802681 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802600:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802604:	48 89 c6             	mov    %rax,%rsi
  802607:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80260e:	00 00 00 
  802611:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  802618:	00 00 00 
  80261b:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80261d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802624:	00 00 00 
  802627:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80262a:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802630:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802634:	48 89 c6             	mov    %rax,%rsi
  802637:	bf 01 00 00 00       	mov    $0x1,%edi
  80263c:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  802643:	00 00 00 
  802646:	ff d0                	callq  *%rax
  802648:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80264b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80264f:	79 1d                	jns    80266e <open+0xc5>
		fd_close(fd, 0);
  802651:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802655:	be 00 00 00 00       	mov    $0x0,%esi
  80265a:	48 89 c7             	mov    %rax,%rdi
  80265d:	48 b8 31 1d 80 00 00 	movabs $0x801d31,%rax
  802664:	00 00 00 
  802667:	ff d0                	callq  *%rax
		return r;
  802669:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80266c:	eb 13                	jmp    802681 <open+0xd8>
	}

	return fd2num(fd);
  80266e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802672:	48 89 c7             	mov    %rax,%rdi
  802675:	48 b8 bb 1b 80 00 00 	movabs $0x801bbb,%rax
  80267c:	00 00 00 
  80267f:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802681:	c9                   	leaveq 
  802682:	c3                   	retq   

0000000000802683 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802683:	55                   	push   %rbp
  802684:	48 89 e5             	mov    %rsp,%rbp
  802687:	48 83 ec 10          	sub    $0x10,%rsp
  80268b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80268f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802693:	8b 50 0c             	mov    0xc(%rax),%edx
  802696:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80269d:	00 00 00 
  8026a0:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8026a2:	be 00 00 00 00       	mov    $0x0,%esi
  8026a7:	bf 06 00 00 00       	mov    $0x6,%edi
  8026ac:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  8026b3:	00 00 00 
  8026b6:	ff d0                	callq  *%rax
}
  8026b8:	c9                   	leaveq 
  8026b9:	c3                   	retq   

00000000008026ba <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8026ba:	55                   	push   %rbp
  8026bb:	48 89 e5             	mov    %rsp,%rbp
  8026be:	48 83 ec 30          	sub    $0x30,%rsp
  8026c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026ca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8026ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d2:	8b 50 0c             	mov    0xc(%rax),%edx
  8026d5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026dc:	00 00 00 
  8026df:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8026e1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026e8:	00 00 00 
  8026eb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026ef:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8026f3:	be 00 00 00 00       	mov    $0x0,%esi
  8026f8:	bf 03 00 00 00       	mov    $0x3,%edi
  8026fd:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  802704:	00 00 00 
  802707:	ff d0                	callq  *%rax
  802709:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80270c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802710:	79 05                	jns    802717 <devfile_read+0x5d>
		return r;
  802712:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802715:	eb 26                	jmp    80273d <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802717:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271a:	48 63 d0             	movslq %eax,%rdx
  80271d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802721:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802728:	00 00 00 
  80272b:	48 89 c7             	mov    %rax,%rdi
  80272e:	48 b8 43 13 80 00 00 	movabs $0x801343,%rax
  802735:	00 00 00 
  802738:	ff d0                	callq  *%rax

	return r;
  80273a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80273d:	c9                   	leaveq 
  80273e:	c3                   	retq   

000000000080273f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80273f:	55                   	push   %rbp
  802740:	48 89 e5             	mov    %rsp,%rbp
  802743:	48 83 ec 30          	sub    $0x30,%rsp
  802747:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80274b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80274f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802753:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80275a:	00 
  80275b:	76 08                	jbe    802765 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  80275d:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802764:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802769:	8b 50 0c             	mov    0xc(%rax),%edx
  80276c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802773:	00 00 00 
  802776:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802778:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80277f:	00 00 00 
  802782:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802786:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  80278a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80278e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802792:	48 89 c6             	mov    %rax,%rsi
  802795:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  80279c:	00 00 00 
  80279f:	48 b8 43 13 80 00 00 	movabs $0x801343,%rax
  8027a6:	00 00 00 
  8027a9:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8027ab:	be 00 00 00 00       	mov    $0x0,%esi
  8027b0:	bf 04 00 00 00       	mov    $0x4,%edi
  8027b5:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  8027bc:	00 00 00 
  8027bf:	ff d0                	callq  *%rax
  8027c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c8:	79 05                	jns    8027cf <devfile_write+0x90>
		return r;
  8027ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cd:	eb 03                	jmp    8027d2 <devfile_write+0x93>

	return r;
  8027cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8027d2:	c9                   	leaveq 
  8027d3:	c3                   	retq   

00000000008027d4 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8027d4:	55                   	push   %rbp
  8027d5:	48 89 e5             	mov    %rsp,%rbp
  8027d8:	48 83 ec 20          	sub    $0x20,%rsp
  8027dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8027e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e8:	8b 50 0c             	mov    0xc(%rax),%edx
  8027eb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027f2:	00 00 00 
  8027f5:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8027f7:	be 00 00 00 00       	mov    $0x0,%esi
  8027fc:	bf 05 00 00 00       	mov    $0x5,%edi
  802801:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  802808:	00 00 00 
  80280b:	ff d0                	callq  *%rax
  80280d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802810:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802814:	79 05                	jns    80281b <devfile_stat+0x47>
		return r;
  802816:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802819:	eb 56                	jmp    802871 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80281b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80281f:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802826:	00 00 00 
  802829:	48 89 c7             	mov    %rax,%rdi
  80282c:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  802833:	00 00 00 
  802836:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802838:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80283f:	00 00 00 
  802842:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802848:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80284c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802852:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802859:	00 00 00 
  80285c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802862:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802866:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80286c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802871:	c9                   	leaveq 
  802872:	c3                   	retq   

0000000000802873 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802873:	55                   	push   %rbp
  802874:	48 89 e5             	mov    %rsp,%rbp
  802877:	48 83 ec 10          	sub    $0x10,%rsp
  80287b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80287f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802882:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802886:	8b 50 0c             	mov    0xc(%rax),%edx
  802889:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802890:	00 00 00 
  802893:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802895:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80289c:	00 00 00 
  80289f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8028a2:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8028a5:	be 00 00 00 00       	mov    $0x0,%esi
  8028aa:	bf 02 00 00 00       	mov    $0x2,%edi
  8028af:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  8028b6:	00 00 00 
  8028b9:	ff d0                	callq  *%rax
}
  8028bb:	c9                   	leaveq 
  8028bc:	c3                   	retq   

00000000008028bd <remove>:

// Delete a file
int
remove(const char *path)
{
  8028bd:	55                   	push   %rbp
  8028be:	48 89 e5             	mov    %rsp,%rbp
  8028c1:	48 83 ec 10          	sub    $0x10,%rsp
  8028c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8028c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028cd:	48 89 c7             	mov    %rax,%rdi
  8028d0:	48 b8 b3 0f 80 00 00 	movabs $0x800fb3,%rax
  8028d7:	00 00 00 
  8028da:	ff d0                	callq  *%rax
  8028dc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8028e1:	7e 07                	jle    8028ea <remove+0x2d>
		return -E_BAD_PATH;
  8028e3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028e8:	eb 33                	jmp    80291d <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8028ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028ee:	48 89 c6             	mov    %rax,%rsi
  8028f1:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8028f8:	00 00 00 
  8028fb:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  802902:	00 00 00 
  802905:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802907:	be 00 00 00 00       	mov    $0x0,%esi
  80290c:	bf 07 00 00 00       	mov    $0x7,%edi
  802911:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  802918:	00 00 00 
  80291b:	ff d0                	callq  *%rax
}
  80291d:	c9                   	leaveq 
  80291e:	c3                   	retq   

000000000080291f <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80291f:	55                   	push   %rbp
  802920:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802923:	be 00 00 00 00       	mov    $0x0,%esi
  802928:	bf 08 00 00 00       	mov    $0x8,%edi
  80292d:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  802934:	00 00 00 
  802937:	ff d0                	callq  *%rax
}
  802939:	5d                   	pop    %rbp
  80293a:	c3                   	retq   

000000000080293b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80293b:	55                   	push   %rbp
  80293c:	48 89 e5             	mov    %rsp,%rbp
  80293f:	53                   	push   %rbx
  802940:	48 83 ec 38          	sub    $0x38,%rsp
  802944:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802948:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80294c:	48 89 c7             	mov    %rax,%rdi
  80294f:	48 b8 09 1c 80 00 00 	movabs $0x801c09,%rax
  802956:	00 00 00 
  802959:	ff d0                	callq  *%rax
  80295b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80295e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802962:	0f 88 bf 01 00 00    	js     802b27 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802968:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80296c:	ba 07 04 00 00       	mov    $0x407,%edx
  802971:	48 89 c6             	mov    %rax,%rsi
  802974:	bf 00 00 00 00       	mov    $0x0,%edi
  802979:	48 b8 4e 19 80 00 00 	movabs $0x80194e,%rax
  802980:	00 00 00 
  802983:	ff d0                	callq  *%rax
  802985:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802988:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80298c:	0f 88 95 01 00 00    	js     802b27 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802992:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802996:	48 89 c7             	mov    %rax,%rdi
  802999:	48 b8 09 1c 80 00 00 	movabs $0x801c09,%rax
  8029a0:	00 00 00 
  8029a3:	ff d0                	callq  *%rax
  8029a5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029ac:	0f 88 5d 01 00 00    	js     802b0f <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029b6:	ba 07 04 00 00       	mov    $0x407,%edx
  8029bb:	48 89 c6             	mov    %rax,%rsi
  8029be:	bf 00 00 00 00       	mov    $0x0,%edi
  8029c3:	48 b8 4e 19 80 00 00 	movabs $0x80194e,%rax
  8029ca:	00 00 00 
  8029cd:	ff d0                	callq  *%rax
  8029cf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029d6:	0f 88 33 01 00 00    	js     802b0f <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8029dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029e0:	48 89 c7             	mov    %rax,%rdi
  8029e3:	48 b8 de 1b 80 00 00 	movabs $0x801bde,%rax
  8029ea:	00 00 00 
  8029ed:	ff d0                	callq  *%rax
  8029ef:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029f7:	ba 07 04 00 00       	mov    $0x407,%edx
  8029fc:	48 89 c6             	mov    %rax,%rsi
  8029ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802a04:	48 b8 4e 19 80 00 00 	movabs $0x80194e,%rax
  802a0b:	00 00 00 
  802a0e:	ff d0                	callq  *%rax
  802a10:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a13:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a17:	79 05                	jns    802a1e <pipe+0xe3>
		goto err2;
  802a19:	e9 d9 00 00 00       	jmpq   802af7 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a22:	48 89 c7             	mov    %rax,%rdi
  802a25:	48 b8 de 1b 80 00 00 	movabs $0x801bde,%rax
  802a2c:	00 00 00 
  802a2f:	ff d0                	callq  *%rax
  802a31:	48 89 c2             	mov    %rax,%rdx
  802a34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a38:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802a3e:	48 89 d1             	mov    %rdx,%rcx
  802a41:	ba 00 00 00 00       	mov    $0x0,%edx
  802a46:	48 89 c6             	mov    %rax,%rsi
  802a49:	bf 00 00 00 00       	mov    $0x0,%edi
  802a4e:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  802a55:	00 00 00 
  802a58:	ff d0                	callq  *%rax
  802a5a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a61:	79 1b                	jns    802a7e <pipe+0x143>
		goto err3;
  802a63:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  802a64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a68:	48 89 c6             	mov    %rax,%rsi
  802a6b:	bf 00 00 00 00       	mov    $0x0,%edi
  802a70:	48 b8 f9 19 80 00 00 	movabs $0x8019f9,%rax
  802a77:	00 00 00 
  802a7a:	ff d0                	callq  *%rax
  802a7c:	eb 79                	jmp    802af7 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802a7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a82:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802a89:	00 00 00 
  802a8c:	8b 12                	mov    (%rdx),%edx
  802a8e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802a90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a94:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802a9b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a9f:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802aa6:	00 00 00 
  802aa9:	8b 12                	mov    (%rdx),%edx
  802aab:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802aad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ab1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802ab8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802abc:	48 89 c7             	mov    %rax,%rdi
  802abf:	48 b8 bb 1b 80 00 00 	movabs $0x801bbb,%rax
  802ac6:	00 00 00 
  802ac9:	ff d0                	callq  *%rax
  802acb:	89 c2                	mov    %eax,%edx
  802acd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ad1:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802ad3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ad7:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802adb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802adf:	48 89 c7             	mov    %rax,%rdi
  802ae2:	48 b8 bb 1b 80 00 00 	movabs $0x801bbb,%rax
  802ae9:	00 00 00 
  802aec:	ff d0                	callq  *%rax
  802aee:	89 03                	mov    %eax,(%rbx)
	return 0;
  802af0:	b8 00 00 00 00       	mov    $0x0,%eax
  802af5:	eb 33                	jmp    802b2a <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  802af7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802afb:	48 89 c6             	mov    %rax,%rsi
  802afe:	bf 00 00 00 00       	mov    $0x0,%edi
  802b03:	48 b8 f9 19 80 00 00 	movabs $0x8019f9,%rax
  802b0a:	00 00 00 
  802b0d:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  802b0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b13:	48 89 c6             	mov    %rax,%rsi
  802b16:	bf 00 00 00 00       	mov    $0x0,%edi
  802b1b:	48 b8 f9 19 80 00 00 	movabs $0x8019f9,%rax
  802b22:	00 00 00 
  802b25:	ff d0                	callq  *%rax
    err:
	return r;
  802b27:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802b2a:	48 83 c4 38          	add    $0x38,%rsp
  802b2e:	5b                   	pop    %rbx
  802b2f:	5d                   	pop    %rbp
  802b30:	c3                   	retq   

0000000000802b31 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802b31:	55                   	push   %rbp
  802b32:	48 89 e5             	mov    %rsp,%rbp
  802b35:	53                   	push   %rbx
  802b36:	48 83 ec 28          	sub    $0x28,%rsp
  802b3a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b3e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802b42:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802b49:	00 00 00 
  802b4c:	48 8b 00             	mov    (%rax),%rax
  802b4f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802b55:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802b58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b5c:	48 89 c7             	mov    %rax,%rdi
  802b5f:	48 b8 ae 34 80 00 00 	movabs $0x8034ae,%rax
  802b66:	00 00 00 
  802b69:	ff d0                	callq  *%rax
  802b6b:	89 c3                	mov    %eax,%ebx
  802b6d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b71:	48 89 c7             	mov    %rax,%rdi
  802b74:	48 b8 ae 34 80 00 00 	movabs $0x8034ae,%rax
  802b7b:	00 00 00 
  802b7e:	ff d0                	callq  *%rax
  802b80:	39 c3                	cmp    %eax,%ebx
  802b82:	0f 94 c0             	sete   %al
  802b85:	0f b6 c0             	movzbl %al,%eax
  802b88:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802b8b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802b92:	00 00 00 
  802b95:	48 8b 00             	mov    (%rax),%rax
  802b98:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802b9e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802ba1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ba4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802ba7:	75 05                	jne    802bae <_pipeisclosed+0x7d>
			return ret;
  802ba9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802bac:	eb 4f                	jmp    802bfd <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802bae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bb1:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802bb4:	74 42                	je     802bf8 <_pipeisclosed+0xc7>
  802bb6:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802bba:	75 3c                	jne    802bf8 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802bbc:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802bc3:	00 00 00 
  802bc6:	48 8b 00             	mov    (%rax),%rax
  802bc9:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802bcf:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802bd2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bd5:	89 c6                	mov    %eax,%esi
  802bd7:	48 bf d3 3a 80 00 00 	movabs $0x803ad3,%rdi
  802bde:	00 00 00 
  802be1:	b8 00 00 00 00       	mov    $0x0,%eax
  802be6:	49 b8 77 02 80 00 00 	movabs $0x800277,%r8
  802bed:	00 00 00 
  802bf0:	41 ff d0             	callq  *%r8
	}
  802bf3:	e9 4a ff ff ff       	jmpq   802b42 <_pipeisclosed+0x11>
  802bf8:	e9 45 ff ff ff       	jmpq   802b42 <_pipeisclosed+0x11>
}
  802bfd:	48 83 c4 28          	add    $0x28,%rsp
  802c01:	5b                   	pop    %rbx
  802c02:	5d                   	pop    %rbp
  802c03:	c3                   	retq   

0000000000802c04 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802c04:	55                   	push   %rbp
  802c05:	48 89 e5             	mov    %rsp,%rbp
  802c08:	48 83 ec 30          	sub    $0x30,%rsp
  802c0c:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c0f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c13:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c16:	48 89 d6             	mov    %rdx,%rsi
  802c19:	89 c7                	mov    %eax,%edi
  802c1b:	48 b8 a1 1c 80 00 00 	movabs $0x801ca1,%rax
  802c22:	00 00 00 
  802c25:	ff d0                	callq  *%rax
  802c27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c2e:	79 05                	jns    802c35 <pipeisclosed+0x31>
		return r;
  802c30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c33:	eb 31                	jmp    802c66 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802c35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c39:	48 89 c7             	mov    %rax,%rdi
  802c3c:	48 b8 de 1b 80 00 00 	movabs $0x801bde,%rax
  802c43:	00 00 00 
  802c46:	ff d0                	callq  *%rax
  802c48:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802c4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c50:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c54:	48 89 d6             	mov    %rdx,%rsi
  802c57:	48 89 c7             	mov    %rax,%rdi
  802c5a:	48 b8 31 2b 80 00 00 	movabs $0x802b31,%rax
  802c61:	00 00 00 
  802c64:	ff d0                	callq  *%rax
}
  802c66:	c9                   	leaveq 
  802c67:	c3                   	retq   

0000000000802c68 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802c68:	55                   	push   %rbp
  802c69:	48 89 e5             	mov    %rsp,%rbp
  802c6c:	48 83 ec 40          	sub    $0x40,%rsp
  802c70:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c74:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c78:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802c7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c80:	48 89 c7             	mov    %rax,%rdi
  802c83:	48 b8 de 1b 80 00 00 	movabs $0x801bde,%rax
  802c8a:	00 00 00 
  802c8d:	ff d0                	callq  *%rax
  802c8f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802c93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c97:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802c9b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ca2:	00 
  802ca3:	e9 92 00 00 00       	jmpq   802d3a <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802ca8:	eb 41                	jmp    802ceb <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802caa:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802caf:	74 09                	je     802cba <devpipe_read+0x52>
				return i;
  802cb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cb5:	e9 92 00 00 00       	jmpq   802d4c <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802cba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cbe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cc2:	48 89 d6             	mov    %rdx,%rsi
  802cc5:	48 89 c7             	mov    %rax,%rdi
  802cc8:	48 b8 31 2b 80 00 00 	movabs $0x802b31,%rax
  802ccf:	00 00 00 
  802cd2:	ff d0                	callq  *%rax
  802cd4:	85 c0                	test   %eax,%eax
  802cd6:	74 07                	je     802cdf <devpipe_read+0x77>
				return 0;
  802cd8:	b8 00 00 00 00       	mov    $0x0,%eax
  802cdd:	eb 6d                	jmp    802d4c <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802cdf:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  802ce6:	00 00 00 
  802ce9:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802ceb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cef:	8b 10                	mov    (%rax),%edx
  802cf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf5:	8b 40 04             	mov    0x4(%rax),%eax
  802cf8:	39 c2                	cmp    %eax,%edx
  802cfa:	74 ae                	je     802caa <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802cfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d00:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d04:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802d08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d0c:	8b 00                	mov    (%rax),%eax
  802d0e:	99                   	cltd   
  802d0f:	c1 ea 1b             	shr    $0x1b,%edx
  802d12:	01 d0                	add    %edx,%eax
  802d14:	83 e0 1f             	and    $0x1f,%eax
  802d17:	29 d0                	sub    %edx,%eax
  802d19:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d1d:	48 98                	cltq   
  802d1f:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802d24:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802d26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d2a:	8b 00                	mov    (%rax),%eax
  802d2c:	8d 50 01             	lea    0x1(%rax),%edx
  802d2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d33:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802d35:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d3e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802d42:	0f 82 60 ff ff ff    	jb     802ca8 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802d48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802d4c:	c9                   	leaveq 
  802d4d:	c3                   	retq   

0000000000802d4e <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802d4e:	55                   	push   %rbp
  802d4f:	48 89 e5             	mov    %rsp,%rbp
  802d52:	48 83 ec 40          	sub    $0x40,%rsp
  802d56:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802d5a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d5e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802d62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d66:	48 89 c7             	mov    %rax,%rdi
  802d69:	48 b8 de 1b 80 00 00 	movabs $0x801bde,%rax
  802d70:	00 00 00 
  802d73:	ff d0                	callq  *%rax
  802d75:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802d79:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802d81:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802d88:	00 
  802d89:	e9 8e 00 00 00       	jmpq   802e1c <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802d8e:	eb 31                	jmp    802dc1 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802d90:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d98:	48 89 d6             	mov    %rdx,%rsi
  802d9b:	48 89 c7             	mov    %rax,%rdi
  802d9e:	48 b8 31 2b 80 00 00 	movabs $0x802b31,%rax
  802da5:	00 00 00 
  802da8:	ff d0                	callq  *%rax
  802daa:	85 c0                	test   %eax,%eax
  802dac:	74 07                	je     802db5 <devpipe_write+0x67>
				return 0;
  802dae:	b8 00 00 00 00       	mov    $0x0,%eax
  802db3:	eb 79                	jmp    802e2e <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802db5:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  802dbc:	00 00 00 
  802dbf:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802dc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc5:	8b 40 04             	mov    0x4(%rax),%eax
  802dc8:	48 63 d0             	movslq %eax,%rdx
  802dcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dcf:	8b 00                	mov    (%rax),%eax
  802dd1:	48 98                	cltq   
  802dd3:	48 83 c0 20          	add    $0x20,%rax
  802dd7:	48 39 c2             	cmp    %rax,%rdx
  802dda:	73 b4                	jae    802d90 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802ddc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de0:	8b 40 04             	mov    0x4(%rax),%eax
  802de3:	99                   	cltd   
  802de4:	c1 ea 1b             	shr    $0x1b,%edx
  802de7:	01 d0                	add    %edx,%eax
  802de9:	83 e0 1f             	and    $0x1f,%eax
  802dec:	29 d0                	sub    %edx,%eax
  802dee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802df2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802df6:	48 01 ca             	add    %rcx,%rdx
  802df9:	0f b6 0a             	movzbl (%rdx),%ecx
  802dfc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e00:	48 98                	cltq   
  802e02:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802e06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0a:	8b 40 04             	mov    0x4(%rax),%eax
  802e0d:	8d 50 01             	lea    0x1(%rax),%edx
  802e10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e14:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e17:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e20:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802e24:	0f 82 64 ff ff ff    	jb     802d8e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802e2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e2e:	c9                   	leaveq 
  802e2f:	c3                   	retq   

0000000000802e30 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802e30:	55                   	push   %rbp
  802e31:	48 89 e5             	mov    %rsp,%rbp
  802e34:	48 83 ec 20          	sub    $0x20,%rsp
  802e38:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e3c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802e40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e44:	48 89 c7             	mov    %rax,%rdi
  802e47:	48 b8 de 1b 80 00 00 	movabs $0x801bde,%rax
  802e4e:	00 00 00 
  802e51:	ff d0                	callq  *%rax
  802e53:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802e57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e5b:	48 be e6 3a 80 00 00 	movabs $0x803ae6,%rsi
  802e62:	00 00 00 
  802e65:	48 89 c7             	mov    %rax,%rdi
  802e68:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  802e6f:	00 00 00 
  802e72:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802e74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e78:	8b 50 04             	mov    0x4(%rax),%edx
  802e7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e7f:	8b 00                	mov    (%rax),%eax
  802e81:	29 c2                	sub    %eax,%edx
  802e83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e87:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802e8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e91:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e98:	00 00 00 
	stat->st_dev = &devpipe;
  802e9b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e9f:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  802ea6:	00 00 00 
  802ea9:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802eb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eb5:	c9                   	leaveq 
  802eb6:	c3                   	retq   

0000000000802eb7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802eb7:	55                   	push   %rbp
  802eb8:	48 89 e5             	mov    %rsp,%rbp
  802ebb:	48 83 ec 10          	sub    $0x10,%rsp
  802ebf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802ec3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ec7:	48 89 c6             	mov    %rax,%rsi
  802eca:	bf 00 00 00 00       	mov    $0x0,%edi
  802ecf:	48 b8 f9 19 80 00 00 	movabs $0x8019f9,%rax
  802ed6:	00 00 00 
  802ed9:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802edb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802edf:	48 89 c7             	mov    %rax,%rdi
  802ee2:	48 b8 de 1b 80 00 00 	movabs $0x801bde,%rax
  802ee9:	00 00 00 
  802eec:	ff d0                	callq  *%rax
  802eee:	48 89 c6             	mov    %rax,%rsi
  802ef1:	bf 00 00 00 00       	mov    $0x0,%edi
  802ef6:	48 b8 f9 19 80 00 00 	movabs $0x8019f9,%rax
  802efd:	00 00 00 
  802f00:	ff d0                	callq  *%rax
}
  802f02:	c9                   	leaveq 
  802f03:	c3                   	retq   

0000000000802f04 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802f04:	55                   	push   %rbp
  802f05:	48 89 e5             	mov    %rsp,%rbp
  802f08:	48 83 ec 20          	sub    $0x20,%rsp
  802f0c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802f0f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f12:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802f15:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802f19:	be 01 00 00 00       	mov    $0x1,%esi
  802f1e:	48 89 c7             	mov    %rax,%rdi
  802f21:	48 b8 06 18 80 00 00 	movabs $0x801806,%rax
  802f28:	00 00 00 
  802f2b:	ff d0                	callq  *%rax
}
  802f2d:	c9                   	leaveq 
  802f2e:	c3                   	retq   

0000000000802f2f <getchar>:

int
getchar(void)
{
  802f2f:	55                   	push   %rbp
  802f30:	48 89 e5             	mov    %rsp,%rbp
  802f33:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802f37:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802f3b:	ba 01 00 00 00       	mov    $0x1,%edx
  802f40:	48 89 c6             	mov    %rax,%rsi
  802f43:	bf 00 00 00 00       	mov    $0x0,%edi
  802f48:	48 b8 d3 20 80 00 00 	movabs $0x8020d3,%rax
  802f4f:	00 00 00 
  802f52:	ff d0                	callq  *%rax
  802f54:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802f57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f5b:	79 05                	jns    802f62 <getchar+0x33>
		return r;
  802f5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f60:	eb 14                	jmp    802f76 <getchar+0x47>
	if (r < 1)
  802f62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f66:	7f 07                	jg     802f6f <getchar+0x40>
		return -E_EOF;
  802f68:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802f6d:	eb 07                	jmp    802f76 <getchar+0x47>
	return c;
  802f6f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802f73:	0f b6 c0             	movzbl %al,%eax
}
  802f76:	c9                   	leaveq 
  802f77:	c3                   	retq   

0000000000802f78 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802f78:	55                   	push   %rbp
  802f79:	48 89 e5             	mov    %rsp,%rbp
  802f7c:	48 83 ec 20          	sub    $0x20,%rsp
  802f80:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f83:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f87:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f8a:	48 89 d6             	mov    %rdx,%rsi
  802f8d:	89 c7                	mov    %eax,%edi
  802f8f:	48 b8 a1 1c 80 00 00 	movabs $0x801ca1,%rax
  802f96:	00 00 00 
  802f99:	ff d0                	callq  *%rax
  802f9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa2:	79 05                	jns    802fa9 <iscons+0x31>
		return r;
  802fa4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa7:	eb 1a                	jmp    802fc3 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802fa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fad:	8b 10                	mov    (%rax),%edx
  802faf:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  802fb6:	00 00 00 
  802fb9:	8b 00                	mov    (%rax),%eax
  802fbb:	39 c2                	cmp    %eax,%edx
  802fbd:	0f 94 c0             	sete   %al
  802fc0:	0f b6 c0             	movzbl %al,%eax
}
  802fc3:	c9                   	leaveq 
  802fc4:	c3                   	retq   

0000000000802fc5 <opencons>:

int
opencons(void)
{
  802fc5:	55                   	push   %rbp
  802fc6:	48 89 e5             	mov    %rsp,%rbp
  802fc9:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802fcd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802fd1:	48 89 c7             	mov    %rax,%rdi
  802fd4:	48 b8 09 1c 80 00 00 	movabs $0x801c09,%rax
  802fdb:	00 00 00 
  802fde:	ff d0                	callq  *%rax
  802fe0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe7:	79 05                	jns    802fee <opencons+0x29>
		return r;
  802fe9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fec:	eb 5b                	jmp    803049 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802fee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff2:	ba 07 04 00 00       	mov    $0x407,%edx
  802ff7:	48 89 c6             	mov    %rax,%rsi
  802ffa:	bf 00 00 00 00       	mov    $0x0,%edi
  802fff:	48 b8 4e 19 80 00 00 	movabs $0x80194e,%rax
  803006:	00 00 00 
  803009:	ff d0                	callq  *%rax
  80300b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80300e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803012:	79 05                	jns    803019 <opencons+0x54>
		return r;
  803014:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803017:	eb 30                	jmp    803049 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803019:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80301d:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803024:	00 00 00 
  803027:	8b 12                	mov    (%rdx),%edx
  803029:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80302b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80302f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803036:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80303a:	48 89 c7             	mov    %rax,%rdi
  80303d:	48 b8 bb 1b 80 00 00 	movabs $0x801bbb,%rax
  803044:	00 00 00 
  803047:	ff d0                	callq  *%rax
}
  803049:	c9                   	leaveq 
  80304a:	c3                   	retq   

000000000080304b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80304b:	55                   	push   %rbp
  80304c:	48 89 e5             	mov    %rsp,%rbp
  80304f:	48 83 ec 30          	sub    $0x30,%rsp
  803053:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803057:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80305b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80305f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803064:	75 07                	jne    80306d <devcons_read+0x22>
		return 0;
  803066:	b8 00 00 00 00       	mov    $0x0,%eax
  80306b:	eb 4b                	jmp    8030b8 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80306d:	eb 0c                	jmp    80307b <devcons_read+0x30>
		sys_yield();
  80306f:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  803076:	00 00 00 
  803079:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80307b:	48 b8 50 18 80 00 00 	movabs $0x801850,%rax
  803082:	00 00 00 
  803085:	ff d0                	callq  *%rax
  803087:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80308a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308e:	74 df                	je     80306f <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803090:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803094:	79 05                	jns    80309b <devcons_read+0x50>
		return c;
  803096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803099:	eb 1d                	jmp    8030b8 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80309b:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80309f:	75 07                	jne    8030a8 <devcons_read+0x5d>
		return 0;
  8030a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a6:	eb 10                	jmp    8030b8 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8030a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ab:	89 c2                	mov    %eax,%edx
  8030ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b1:	88 10                	mov    %dl,(%rax)
	return 1;
  8030b3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8030b8:	c9                   	leaveq 
  8030b9:	c3                   	retq   

00000000008030ba <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8030ba:	55                   	push   %rbp
  8030bb:	48 89 e5             	mov    %rsp,%rbp
  8030be:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8030c5:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8030cc:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8030d3:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8030da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8030e1:	eb 76                	jmp    803159 <devcons_write+0x9f>
		m = n - tot;
  8030e3:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8030ea:	89 c2                	mov    %eax,%edx
  8030ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ef:	29 c2                	sub    %eax,%edx
  8030f1:	89 d0                	mov    %edx,%eax
  8030f3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8030f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030f9:	83 f8 7f             	cmp    $0x7f,%eax
  8030fc:	76 07                	jbe    803105 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8030fe:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803105:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803108:	48 63 d0             	movslq %eax,%rdx
  80310b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80310e:	48 63 c8             	movslq %eax,%rcx
  803111:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803118:	48 01 c1             	add    %rax,%rcx
  80311b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803122:	48 89 ce             	mov    %rcx,%rsi
  803125:	48 89 c7             	mov    %rax,%rdi
  803128:	48 b8 43 13 80 00 00 	movabs $0x801343,%rax
  80312f:	00 00 00 
  803132:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803134:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803137:	48 63 d0             	movslq %eax,%rdx
  80313a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803141:	48 89 d6             	mov    %rdx,%rsi
  803144:	48 89 c7             	mov    %rax,%rdi
  803147:	48 b8 06 18 80 00 00 	movabs $0x801806,%rax
  80314e:	00 00 00 
  803151:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803153:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803156:	01 45 fc             	add    %eax,-0x4(%rbp)
  803159:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80315c:	48 98                	cltq   
  80315e:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803165:	0f 82 78 ff ff ff    	jb     8030e3 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80316b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80316e:	c9                   	leaveq 
  80316f:	c3                   	retq   

0000000000803170 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803170:	55                   	push   %rbp
  803171:	48 89 e5             	mov    %rsp,%rbp
  803174:	48 83 ec 08          	sub    $0x8,%rsp
  803178:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80317c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803181:	c9                   	leaveq 
  803182:	c3                   	retq   

0000000000803183 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803183:	55                   	push   %rbp
  803184:	48 89 e5             	mov    %rsp,%rbp
  803187:	48 83 ec 10          	sub    $0x10,%rsp
  80318b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80318f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803193:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803197:	48 be f2 3a 80 00 00 	movabs $0x803af2,%rsi
  80319e:	00 00 00 
  8031a1:	48 89 c7             	mov    %rax,%rdi
  8031a4:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  8031ab:	00 00 00 
  8031ae:	ff d0                	callq  *%rax
	return 0;
  8031b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031b5:	c9                   	leaveq 
  8031b6:	c3                   	retq   

00000000008031b7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8031b7:	55                   	push   %rbp
  8031b8:	48 89 e5             	mov    %rsp,%rbp
  8031bb:	53                   	push   %rbx
  8031bc:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8031c3:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8031ca:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8031d0:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8031d7:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8031de:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8031e5:	84 c0                	test   %al,%al
  8031e7:	74 23                	je     80320c <_panic+0x55>
  8031e9:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8031f0:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8031f4:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8031f8:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8031fc:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803200:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803204:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803208:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80320c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803213:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80321a:	00 00 00 
  80321d:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803224:	00 00 00 
  803227:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80322b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803232:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803239:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803240:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  803247:	00 00 00 
  80324a:	48 8b 18             	mov    (%rax),%rbx
  80324d:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  803254:	00 00 00 
  803257:	ff d0                	callq  *%rax
  803259:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80325f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803266:	41 89 c8             	mov    %ecx,%r8d
  803269:	48 89 d1             	mov    %rdx,%rcx
  80326c:	48 89 da             	mov    %rbx,%rdx
  80326f:	89 c6                	mov    %eax,%esi
  803271:	48 bf 00 3b 80 00 00 	movabs $0x803b00,%rdi
  803278:	00 00 00 
  80327b:	b8 00 00 00 00       	mov    $0x0,%eax
  803280:	49 b9 77 02 80 00 00 	movabs $0x800277,%r9
  803287:	00 00 00 
  80328a:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80328d:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803294:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80329b:	48 89 d6             	mov    %rdx,%rsi
  80329e:	48 89 c7             	mov    %rax,%rdi
  8032a1:	48 b8 cb 01 80 00 00 	movabs $0x8001cb,%rax
  8032a8:	00 00 00 
  8032ab:	ff d0                	callq  *%rax
	cprintf("\n");
  8032ad:	48 bf 23 3b 80 00 00 	movabs $0x803b23,%rdi
  8032b4:	00 00 00 
  8032b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8032bc:	48 ba 77 02 80 00 00 	movabs $0x800277,%rdx
  8032c3:	00 00 00 
  8032c6:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8032c8:	cc                   	int3   
  8032c9:	eb fd                	jmp    8032c8 <_panic+0x111>

00000000008032cb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8032cb:	55                   	push   %rbp
  8032cc:	48 89 e5             	mov    %rsp,%rbp
  8032cf:	48 83 ec 30          	sub    $0x30,%rsp
  8032d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032db:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8032df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8032e7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8032ec:	75 0e                	jne    8032fc <ipc_recv+0x31>
		page = (void *)KERNBASE;
  8032ee:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8032f5:	00 00 00 
  8032f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  8032fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803300:	48 89 c7             	mov    %rax,%rdi
  803303:	48 b8 77 1b 80 00 00 	movabs $0x801b77,%rax
  80330a:	00 00 00 
  80330d:	ff d0                	callq  *%rax
  80330f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803312:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803316:	79 27                	jns    80333f <ipc_recv+0x74>
		if (from_env_store != NULL)
  803318:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80331d:	74 0a                	je     803329 <ipc_recv+0x5e>
			*from_env_store = 0;
  80331f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803323:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  803329:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80332e:	74 0a                	je     80333a <ipc_recv+0x6f>
			*perm_store = 0;
  803330:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803334:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  80333a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80333d:	eb 53                	jmp    803392 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  80333f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803344:	74 19                	je     80335f <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  803346:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80334d:	00 00 00 
  803350:	48 8b 00             	mov    (%rax),%rax
  803353:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803359:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80335d:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  80335f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803364:	74 19                	je     80337f <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803366:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80336d:	00 00 00 
  803370:	48 8b 00             	mov    (%rax),%rax
  803373:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803379:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80337d:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  80337f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803386:	00 00 00 
  803389:	48 8b 00             	mov    (%rax),%rax
  80338c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803392:	c9                   	leaveq 
  803393:	c3                   	retq   

0000000000803394 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803394:	55                   	push   %rbp
  803395:	48 89 e5             	mov    %rsp,%rbp
  803398:	48 83 ec 30          	sub    $0x30,%rsp
  80339c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80339f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8033a2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8033a6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8033a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8033b1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8033b6:	75 10                	jne    8033c8 <ipc_send+0x34>
		page = (void *)KERNBASE;
  8033b8:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8033bf:	00 00 00 
  8033c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  8033c6:	eb 0e                	jmp    8033d6 <ipc_send+0x42>
  8033c8:	eb 0c                	jmp    8033d6 <ipc_send+0x42>
		sys_yield();
  8033ca:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  8033d1:	00 00 00 
  8033d4:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  8033d6:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8033d9:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8033dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033e3:	89 c7                	mov    %eax,%edi
  8033e5:	48 b8 22 1b 80 00 00 	movabs $0x801b22,%rax
  8033ec:	00 00 00 
  8033ef:	ff d0                	callq  *%rax
  8033f1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8033f4:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  8033f8:	74 d0                	je     8033ca <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  8033fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8033fe:	74 2a                	je     80342a <ipc_send+0x96>
		panic("error on ipc send procedure");
  803400:	48 ba 25 3b 80 00 00 	movabs $0x803b25,%rdx
  803407:	00 00 00 
  80340a:	be 49 00 00 00       	mov    $0x49,%esi
  80340f:	48 bf 41 3b 80 00 00 	movabs $0x803b41,%rdi
  803416:	00 00 00 
  803419:	b8 00 00 00 00       	mov    $0x0,%eax
  80341e:	48 b9 b7 31 80 00 00 	movabs $0x8031b7,%rcx
  803425:	00 00 00 
  803428:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  80342a:	c9                   	leaveq 
  80342b:	c3                   	retq   

000000000080342c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80342c:	55                   	push   %rbp
  80342d:	48 89 e5             	mov    %rsp,%rbp
  803430:	48 83 ec 14          	sub    $0x14,%rsp
  803434:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803437:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80343e:	eb 5e                	jmp    80349e <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803440:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803447:	00 00 00 
  80344a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344d:	48 63 d0             	movslq %eax,%rdx
  803450:	48 89 d0             	mov    %rdx,%rax
  803453:	48 c1 e0 03          	shl    $0x3,%rax
  803457:	48 01 d0             	add    %rdx,%rax
  80345a:	48 c1 e0 05          	shl    $0x5,%rax
  80345e:	48 01 c8             	add    %rcx,%rax
  803461:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803467:	8b 00                	mov    (%rax),%eax
  803469:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80346c:	75 2c                	jne    80349a <ipc_find_env+0x6e>
			return envs[i].env_id;
  80346e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803475:	00 00 00 
  803478:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347b:	48 63 d0             	movslq %eax,%rdx
  80347e:	48 89 d0             	mov    %rdx,%rax
  803481:	48 c1 e0 03          	shl    $0x3,%rax
  803485:	48 01 d0             	add    %rdx,%rax
  803488:	48 c1 e0 05          	shl    $0x5,%rax
  80348c:	48 01 c8             	add    %rcx,%rax
  80348f:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803495:	8b 40 08             	mov    0x8(%rax),%eax
  803498:	eb 12                	jmp    8034ac <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80349a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80349e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8034a5:	7e 99                	jle    803440 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8034a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034ac:	c9                   	leaveq 
  8034ad:	c3                   	retq   

00000000008034ae <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8034ae:	55                   	push   %rbp
  8034af:	48 89 e5             	mov    %rsp,%rbp
  8034b2:	48 83 ec 18          	sub    $0x18,%rsp
  8034b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8034ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034be:	48 c1 e8 15          	shr    $0x15,%rax
  8034c2:	48 89 c2             	mov    %rax,%rdx
  8034c5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8034cc:	01 00 00 
  8034cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034d3:	83 e0 01             	and    $0x1,%eax
  8034d6:	48 85 c0             	test   %rax,%rax
  8034d9:	75 07                	jne    8034e2 <pageref+0x34>
		return 0;
  8034db:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e0:	eb 53                	jmp    803535 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8034e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034e6:	48 c1 e8 0c          	shr    $0xc,%rax
  8034ea:	48 89 c2             	mov    %rax,%rdx
  8034ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8034f4:	01 00 00 
  8034f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8034ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803503:	83 e0 01             	and    $0x1,%eax
  803506:	48 85 c0             	test   %rax,%rax
  803509:	75 07                	jne    803512 <pageref+0x64>
		return 0;
  80350b:	b8 00 00 00 00       	mov    $0x0,%eax
  803510:	eb 23                	jmp    803535 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803516:	48 c1 e8 0c          	shr    $0xc,%rax
  80351a:	48 89 c2             	mov    %rax,%rdx
  80351d:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803524:	00 00 00 
  803527:	48 c1 e2 04          	shl    $0x4,%rdx
  80352b:	48 01 d0             	add    %rdx,%rax
  80352e:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803532:	0f b7 c0             	movzwl %ax,%eax
}
  803535:	c9                   	leaveq 
  803536:	c3                   	retq   
