
obj/user/faultdie.debug:     file format elf64-x86-64


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
  80003c:	e8 9c 00 00 00       	callq  8000dd <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void*)utf->utf_fault_va;
  80004f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800053:	48 8b 00             	mov    (%rax),%rax
  800056:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  80005a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80005e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800062:	89 45 f4             	mov    %eax,-0xc(%rbp)
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800065:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800068:	83 e0 07             	and    $0x7,%eax
  80006b:	89 c2                	mov    %eax,%edx
  80006d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800071:	48 89 c6             	mov    %rax,%rsi
  800074:	48 bf 80 36 80 00 00 	movabs $0x803680,%rdi
  80007b:	00 00 00 
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
  800083:	48 b9 b5 02 80 00 00 	movabs $0x8002b5,%rcx
  80008a:	00 00 00 
  80008d:	ff d1                	callq  *%rcx
	sys_env_destroy(sys_getenvid());
  80008f:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  800096:	00 00 00 
  800099:	ff d0                	callq  *%rax
  80009b:	89 c7                	mov    %eax,%edi
  80009d:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  8000a4:	00 00 00 
  8000a7:	ff d0                	callq  *%rax
}
  8000a9:	c9                   	leaveq 
  8000aa:	c3                   	retq   

00000000008000ab <umain>:

void
umain(int argc, char **argv)
{
  8000ab:	55                   	push   %rbp
  8000ac:	48 89 e5             	mov    %rsp,%rbp
  8000af:	48 83 ec 10          	sub    $0x10,%rsp
  8000b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(handler);
  8000ba:	48 bf 43 00 80 00 00 	movabs $0x800043,%rdi
  8000c1:	00 00 00 
  8000c4:	48 b8 f9 1b 80 00 00 	movabs $0x801bf9,%rax
  8000cb:	00 00 00 
  8000ce:	ff d0                	callq  *%rax
	*(int*)0xDeadBeef = 0;
  8000d0:	b8 ef be ad de       	mov    $0xdeadbeef,%eax
  8000d5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  8000db:	c9                   	leaveq 
  8000dc:	c3                   	retq   

00000000008000dd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000dd:	55                   	push   %rbp
  8000de:	48 89 e5             	mov    %rsp,%rbp
  8000e1:	48 83 ec 10          	sub    $0x10,%rsp
  8000e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8000ec:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  8000f3:	00 00 00 
  8000f6:	ff d0                	callq  *%rax
  8000f8:	48 98                	cltq   
  8000fa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ff:	48 89 c2             	mov    %rax,%rdx
  800102:	48 89 d0             	mov    %rdx,%rax
  800105:	48 c1 e0 03          	shl    $0x3,%rax
  800109:	48 01 d0             	add    %rdx,%rax
  80010c:	48 c1 e0 05          	shl    $0x5,%rax
  800110:	48 89 c2             	mov    %rax,%rdx
  800113:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80011a:	00 00 00 
  80011d:	48 01 c2             	add    %rax,%rdx
  800120:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800127:	00 00 00 
  80012a:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800131:	7e 14                	jle    800147 <libmain+0x6a>
		binaryname = argv[0];
  800133:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800137:	48 8b 10             	mov    (%rax),%rdx
  80013a:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800141:	00 00 00 
  800144:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800147:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80014b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80014e:	48 89 d6             	mov    %rdx,%rsi
  800151:	89 c7                	mov    %eax,%edi
  800153:	48 b8 ab 00 80 00 00 	movabs $0x8000ab,%rax
  80015a:	00 00 00 
  80015d:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80015f:	48 b8 6d 01 80 00 00 	movabs $0x80016d,%rax
  800166:	00 00 00 
  800169:	ff d0                	callq  *%rax
}
  80016b:	c9                   	leaveq 
  80016c:	c3                   	retq   

000000000080016d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80016d:	55                   	push   %rbp
  80016e:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800171:	48 b8 2f 20 80 00 00 	movabs $0x80202f,%rax
  800178:	00 00 00 
  80017b:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80017d:	bf 00 00 00 00       	mov    $0x0,%edi
  800182:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
}
  80018e:	5d                   	pop    %rbp
  80018f:	c3                   	retq   

0000000000800190 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800190:	55                   	push   %rbp
  800191:	48 89 e5             	mov    %rsp,%rbp
  800194:	48 83 ec 10          	sub    $0x10,%rsp
  800198:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80019b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80019f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a3:	8b 00                	mov    (%rax),%eax
  8001a5:	8d 48 01             	lea    0x1(%rax),%ecx
  8001a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ac:	89 0a                	mov    %ecx,(%rdx)
  8001ae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001b1:	89 d1                	mov    %edx,%ecx
  8001b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b7:	48 98                	cltq   
  8001b9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8001bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c1:	8b 00                	mov    (%rax),%eax
  8001c3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c8:	75 2c                	jne    8001f6 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8001ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ce:	8b 00                	mov    (%rax),%eax
  8001d0:	48 98                	cltq   
  8001d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d6:	48 83 c2 08          	add    $0x8,%rdx
  8001da:	48 89 c6             	mov    %rax,%rsi
  8001dd:	48 89 d7             	mov    %rdx,%rdi
  8001e0:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  8001e7:	00 00 00 
  8001ea:	ff d0                	callq  *%rax
		b->idx = 0;
  8001ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001f0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8001f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001fa:	8b 40 04             	mov    0x4(%rax),%eax
  8001fd:	8d 50 01             	lea    0x1(%rax),%edx
  800200:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800204:	89 50 04             	mov    %edx,0x4(%rax)
}
  800207:	c9                   	leaveq 
  800208:	c3                   	retq   

0000000000800209 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800209:	55                   	push   %rbp
  80020a:	48 89 e5             	mov    %rsp,%rbp
  80020d:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800214:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80021b:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800222:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800229:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800230:	48 8b 0a             	mov    (%rdx),%rcx
  800233:	48 89 08             	mov    %rcx,(%rax)
  800236:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80023a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80023e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800242:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800246:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80024d:	00 00 00 
	b.cnt = 0;
  800250:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800257:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80025a:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800261:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800268:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80026f:	48 89 c6             	mov    %rax,%rsi
  800272:	48 bf 90 01 80 00 00 	movabs $0x800190,%rdi
  800279:	00 00 00 
  80027c:	48 b8 68 06 80 00 00 	movabs $0x800668,%rax
  800283:	00 00 00 
  800286:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800288:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80028e:	48 98                	cltq   
  800290:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800297:	48 83 c2 08          	add    $0x8,%rdx
  80029b:	48 89 c6             	mov    %rax,%rsi
  80029e:	48 89 d7             	mov    %rdx,%rdi
  8002a1:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  8002a8:	00 00 00 
  8002ab:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8002ad:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002b3:	c9                   	leaveq 
  8002b4:	c3                   	retq   

00000000008002b5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002b5:	55                   	push   %rbp
  8002b6:	48 89 e5             	mov    %rsp,%rbp
  8002b9:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002c0:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8002c7:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8002ce:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8002d5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8002dc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002e3:	84 c0                	test   %al,%al
  8002e5:	74 20                	je     800307 <cprintf+0x52>
  8002e7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002eb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002ef:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002f3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002f7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002fb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002ff:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800303:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800307:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80030e:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800315:	00 00 00 
  800318:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80031f:	00 00 00 
  800322:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800326:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80032d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800334:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80033b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800342:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800349:	48 8b 0a             	mov    (%rdx),%rcx
  80034c:	48 89 08             	mov    %rcx,(%rax)
  80034f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800353:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800357:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80035b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80035f:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800366:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80036d:	48 89 d6             	mov    %rdx,%rsi
  800370:	48 89 c7             	mov    %rax,%rdi
  800373:	48 b8 09 02 80 00 00 	movabs $0x800209,%rax
  80037a:	00 00 00 
  80037d:	ff d0                	callq  *%rax
  80037f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800385:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80038b:	c9                   	leaveq 
  80038c:	c3                   	retq   

000000000080038d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80038d:	55                   	push   %rbp
  80038e:	48 89 e5             	mov    %rsp,%rbp
  800391:	53                   	push   %rbx
  800392:	48 83 ec 38          	sub    $0x38,%rsp
  800396:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80039a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80039e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8003a2:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003a5:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003a9:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ad:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003b0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003b4:	77 3b                	ja     8003f1 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003b6:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003b9:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003bd:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8003c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c9:	48 f7 f3             	div    %rbx
  8003cc:	48 89 c2             	mov    %rax,%rdx
  8003cf:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8003d2:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003d5:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8003d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003dd:	41 89 f9             	mov    %edi,%r9d
  8003e0:	48 89 c7             	mov    %rax,%rdi
  8003e3:	48 b8 8d 03 80 00 00 	movabs $0x80038d,%rax
  8003ea:	00 00 00 
  8003ed:	ff d0                	callq  *%rax
  8003ef:	eb 1e                	jmp    80040f <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003f1:	eb 12                	jmp    800405 <printnum+0x78>
			putch(padc, putdat);
  8003f3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003f7:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003fe:	48 89 ce             	mov    %rcx,%rsi
  800401:	89 d7                	mov    %edx,%edi
  800403:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800405:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800409:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80040d:	7f e4                	jg     8003f3 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80040f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800412:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800416:	ba 00 00 00 00       	mov    $0x0,%edx
  80041b:	48 f7 f1             	div    %rcx
  80041e:	48 89 d0             	mov    %rdx,%rax
  800421:	48 ba 88 38 80 00 00 	movabs $0x803888,%rdx
  800428:	00 00 00 
  80042b:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80042f:	0f be d0             	movsbl %al,%edx
  800432:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043a:	48 89 ce             	mov    %rcx,%rsi
  80043d:	89 d7                	mov    %edx,%edi
  80043f:	ff d0                	callq  *%rax
}
  800441:	48 83 c4 38          	add    $0x38,%rsp
  800445:	5b                   	pop    %rbx
  800446:	5d                   	pop    %rbp
  800447:	c3                   	retq   

0000000000800448 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800448:	55                   	push   %rbp
  800449:	48 89 e5             	mov    %rsp,%rbp
  80044c:	48 83 ec 1c          	sub    $0x1c,%rsp
  800450:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800454:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800457:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80045b:	7e 52                	jle    8004af <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80045d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800461:	8b 00                	mov    (%rax),%eax
  800463:	83 f8 30             	cmp    $0x30,%eax
  800466:	73 24                	jae    80048c <getuint+0x44>
  800468:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80046c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800470:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800474:	8b 00                	mov    (%rax),%eax
  800476:	89 c0                	mov    %eax,%eax
  800478:	48 01 d0             	add    %rdx,%rax
  80047b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80047f:	8b 12                	mov    (%rdx),%edx
  800481:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800484:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800488:	89 0a                	mov    %ecx,(%rdx)
  80048a:	eb 17                	jmp    8004a3 <getuint+0x5b>
  80048c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800490:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800494:	48 89 d0             	mov    %rdx,%rax
  800497:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80049b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80049f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004a3:	48 8b 00             	mov    (%rax),%rax
  8004a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004aa:	e9 a3 00 00 00       	jmpq   800552 <getuint+0x10a>
	else if (lflag)
  8004af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004b3:	74 4f                	je     800504 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b9:	8b 00                	mov    (%rax),%eax
  8004bb:	83 f8 30             	cmp    $0x30,%eax
  8004be:	73 24                	jae    8004e4 <getuint+0x9c>
  8004c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cc:	8b 00                	mov    (%rax),%eax
  8004ce:	89 c0                	mov    %eax,%eax
  8004d0:	48 01 d0             	add    %rdx,%rax
  8004d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d7:	8b 12                	mov    (%rdx),%edx
  8004d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e0:	89 0a                	mov    %ecx,(%rdx)
  8004e2:	eb 17                	jmp    8004fb <getuint+0xb3>
  8004e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004ec:	48 89 d0             	mov    %rdx,%rax
  8004ef:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004fb:	48 8b 00             	mov    (%rax),%rax
  8004fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800502:	eb 4e                	jmp    800552 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800504:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800508:	8b 00                	mov    (%rax),%eax
  80050a:	83 f8 30             	cmp    $0x30,%eax
  80050d:	73 24                	jae    800533 <getuint+0xeb>
  80050f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800513:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800517:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051b:	8b 00                	mov    (%rax),%eax
  80051d:	89 c0                	mov    %eax,%eax
  80051f:	48 01 d0             	add    %rdx,%rax
  800522:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800526:	8b 12                	mov    (%rdx),%edx
  800528:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80052b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80052f:	89 0a                	mov    %ecx,(%rdx)
  800531:	eb 17                	jmp    80054a <getuint+0x102>
  800533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800537:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80053b:	48 89 d0             	mov    %rdx,%rax
  80053e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800542:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800546:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80054a:	8b 00                	mov    (%rax),%eax
  80054c:	89 c0                	mov    %eax,%eax
  80054e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800552:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800556:	c9                   	leaveq 
  800557:	c3                   	retq   

0000000000800558 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800558:	55                   	push   %rbp
  800559:	48 89 e5             	mov    %rsp,%rbp
  80055c:	48 83 ec 1c          	sub    $0x1c,%rsp
  800560:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800564:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800567:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80056b:	7e 52                	jle    8005bf <getint+0x67>
		x=va_arg(*ap, long long);
  80056d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800571:	8b 00                	mov    (%rax),%eax
  800573:	83 f8 30             	cmp    $0x30,%eax
  800576:	73 24                	jae    80059c <getint+0x44>
  800578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800580:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800584:	8b 00                	mov    (%rax),%eax
  800586:	89 c0                	mov    %eax,%eax
  800588:	48 01 d0             	add    %rdx,%rax
  80058b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058f:	8b 12                	mov    (%rdx),%edx
  800591:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800594:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800598:	89 0a                	mov    %ecx,(%rdx)
  80059a:	eb 17                	jmp    8005b3 <getint+0x5b>
  80059c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a4:	48 89 d0             	mov    %rdx,%rax
  8005a7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005af:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b3:	48 8b 00             	mov    (%rax),%rax
  8005b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005ba:	e9 a3 00 00 00       	jmpq   800662 <getint+0x10a>
	else if (lflag)
  8005bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005c3:	74 4f                	je     800614 <getint+0xbc>
		x=va_arg(*ap, long);
  8005c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c9:	8b 00                	mov    (%rax),%eax
  8005cb:	83 f8 30             	cmp    $0x30,%eax
  8005ce:	73 24                	jae    8005f4 <getint+0x9c>
  8005d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dc:	8b 00                	mov    (%rax),%eax
  8005de:	89 c0                	mov    %eax,%eax
  8005e0:	48 01 d0             	add    %rdx,%rax
  8005e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e7:	8b 12                	mov    (%rdx),%edx
  8005e9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f0:	89 0a                	mov    %ecx,(%rdx)
  8005f2:	eb 17                	jmp    80060b <getint+0xb3>
  8005f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005fc:	48 89 d0             	mov    %rdx,%rax
  8005ff:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800603:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800607:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80060b:	48 8b 00             	mov    (%rax),%rax
  80060e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800612:	eb 4e                	jmp    800662 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800614:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800618:	8b 00                	mov    (%rax),%eax
  80061a:	83 f8 30             	cmp    $0x30,%eax
  80061d:	73 24                	jae    800643 <getint+0xeb>
  80061f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800623:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062b:	8b 00                	mov    (%rax),%eax
  80062d:	89 c0                	mov    %eax,%eax
  80062f:	48 01 d0             	add    %rdx,%rax
  800632:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800636:	8b 12                	mov    (%rdx),%edx
  800638:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80063b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80063f:	89 0a                	mov    %ecx,(%rdx)
  800641:	eb 17                	jmp    80065a <getint+0x102>
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80064b:	48 89 d0             	mov    %rdx,%rax
  80064e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800652:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800656:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80065a:	8b 00                	mov    (%rax),%eax
  80065c:	48 98                	cltq   
  80065e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800662:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800666:	c9                   	leaveq 
  800667:	c3                   	retq   

0000000000800668 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800668:	55                   	push   %rbp
  800669:	48 89 e5             	mov    %rsp,%rbp
  80066c:	41 54                	push   %r12
  80066e:	53                   	push   %rbx
  80066f:	48 83 ec 60          	sub    $0x60,%rsp
  800673:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800677:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80067b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80067f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800683:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800687:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80068b:	48 8b 0a             	mov    (%rdx),%rcx
  80068e:	48 89 08             	mov    %rcx,(%rax)
  800691:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800695:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800699:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80069d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  8006a1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006a5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006a9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006ad:	0f b6 00             	movzbl (%rax),%eax
  8006b0:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  8006b3:	eb 29                	jmp    8006de <vprintfmt+0x76>
			if (ch == '\0')
  8006b5:	85 db                	test   %ebx,%ebx
  8006b7:	0f 84 ad 06 00 00    	je     800d6a <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  8006bd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006c1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006c5:	48 89 d6             	mov    %rdx,%rsi
  8006c8:	89 df                	mov    %ebx,%edi
  8006ca:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  8006cc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006d4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006d8:	0f b6 00             	movzbl (%rax),%eax
  8006db:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  8006de:	83 fb 25             	cmp    $0x25,%ebx
  8006e1:	74 05                	je     8006e8 <vprintfmt+0x80>
  8006e3:	83 fb 1b             	cmp    $0x1b,%ebx
  8006e6:	75 cd                	jne    8006b5 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  8006e8:	83 fb 1b             	cmp    $0x1b,%ebx
  8006eb:	0f 85 ae 01 00 00    	jne    80089f <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  8006f1:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8006f8:	00 00 00 
  8006fb:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  800701:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800705:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800709:	48 89 d6             	mov    %rdx,%rsi
  80070c:	89 df                	mov    %ebx,%edi
  80070e:	ff d0                	callq  *%rax
			putch('[', putdat);
  800710:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800714:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800718:	48 89 d6             	mov    %rdx,%rsi
  80071b:	bf 5b 00 00 00       	mov    $0x5b,%edi
  800720:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800722:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800728:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80072d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800731:	0f b6 00             	movzbl (%rax),%eax
  800734:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800737:	eb 32                	jmp    80076b <vprintfmt+0x103>
					putch(ch, putdat);
  800739:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80073d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800741:	48 89 d6             	mov    %rdx,%rsi
  800744:	89 df                	mov    %ebx,%edi
  800746:	ff d0                	callq  *%rax
					esc_color *= 10;
  800748:	44 89 e0             	mov    %r12d,%eax
  80074b:	c1 e0 02             	shl    $0x2,%eax
  80074e:	44 01 e0             	add    %r12d,%eax
  800751:	01 c0                	add    %eax,%eax
  800753:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800756:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800759:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  80075c:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800761:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800765:	0f b6 00             	movzbl (%rax),%eax
  800768:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  80076b:	83 fb 3b             	cmp    $0x3b,%ebx
  80076e:	74 05                	je     800775 <vprintfmt+0x10d>
  800770:	83 fb 6d             	cmp    $0x6d,%ebx
  800773:	75 c4                	jne    800739 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800775:	45 85 e4             	test   %r12d,%r12d
  800778:	75 15                	jne    80078f <vprintfmt+0x127>
					color_flag = 0x07;
  80077a:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800781:	00 00 00 
  800784:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  80078a:	e9 dc 00 00 00       	jmpq   80086b <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  80078f:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800793:	7e 69                	jle    8007fe <vprintfmt+0x196>
  800795:	41 83 fc 25          	cmp    $0x25,%r12d
  800799:	7f 63                	jg     8007fe <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  80079b:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8007a2:	00 00 00 
  8007a5:	8b 00                	mov    (%rax),%eax
  8007a7:	25 f8 00 00 00       	and    $0xf8,%eax
  8007ac:	89 c2                	mov    %eax,%edx
  8007ae:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8007b5:	00 00 00 
  8007b8:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  8007ba:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  8007be:	44 89 e0             	mov    %r12d,%eax
  8007c1:	83 e0 04             	and    $0x4,%eax
  8007c4:	c1 f8 02             	sar    $0x2,%eax
  8007c7:	89 c2                	mov    %eax,%edx
  8007c9:	44 89 e0             	mov    %r12d,%eax
  8007cc:	83 e0 02             	and    $0x2,%eax
  8007cf:	09 c2                	or     %eax,%edx
  8007d1:	44 89 e0             	mov    %r12d,%eax
  8007d4:	83 e0 01             	and    $0x1,%eax
  8007d7:	c1 e0 02             	shl    $0x2,%eax
  8007da:	09 c2                	or     %eax,%edx
  8007dc:	41 89 d4             	mov    %edx,%r12d
  8007df:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8007e6:	00 00 00 
  8007e9:	8b 00                	mov    (%rax),%eax
  8007eb:	44 89 e2             	mov    %r12d,%edx
  8007ee:	09 c2                	or     %eax,%edx
  8007f0:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8007f7:	00 00 00 
  8007fa:	89 10                	mov    %edx,(%rax)
  8007fc:	eb 6d                	jmp    80086b <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  8007fe:	41 83 fc 27          	cmp    $0x27,%r12d
  800802:	7e 67                	jle    80086b <vprintfmt+0x203>
  800804:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800808:	7f 61                	jg     80086b <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  80080a:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800811:	00 00 00 
  800814:	8b 00                	mov    (%rax),%eax
  800816:	25 8f 00 00 00       	and    $0x8f,%eax
  80081b:	89 c2                	mov    %eax,%edx
  80081d:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800824:	00 00 00 
  800827:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800829:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  80082d:	44 89 e0             	mov    %r12d,%eax
  800830:	83 e0 04             	and    $0x4,%eax
  800833:	c1 f8 02             	sar    $0x2,%eax
  800836:	89 c2                	mov    %eax,%edx
  800838:	44 89 e0             	mov    %r12d,%eax
  80083b:	83 e0 02             	and    $0x2,%eax
  80083e:	09 c2                	or     %eax,%edx
  800840:	44 89 e0             	mov    %r12d,%eax
  800843:	83 e0 01             	and    $0x1,%eax
  800846:	c1 e0 06             	shl    $0x6,%eax
  800849:	09 c2                	or     %eax,%edx
  80084b:	41 89 d4             	mov    %edx,%r12d
  80084e:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800855:	00 00 00 
  800858:	8b 00                	mov    (%rax),%eax
  80085a:	44 89 e2             	mov    %r12d,%edx
  80085d:	09 c2                	or     %eax,%edx
  80085f:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800866:	00 00 00 
  800869:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  80086b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80086f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800873:	48 89 d6             	mov    %rdx,%rsi
  800876:	89 df                	mov    %ebx,%edi
  800878:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  80087a:	83 fb 6d             	cmp    $0x6d,%ebx
  80087d:	75 1b                	jne    80089a <vprintfmt+0x232>
					fmt ++;
  80087f:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800884:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800885:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80088c:	00 00 00 
  80088f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800895:	e9 cb 04 00 00       	jmpq   800d65 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  80089a:	e9 83 fe ff ff       	jmpq   800722 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  80089f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008a3:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008aa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008b8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008bf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008c3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008c7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008cb:	0f b6 00             	movzbl (%rax),%eax
  8008ce:	0f b6 d8             	movzbl %al,%ebx
  8008d1:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008d4:	83 f8 55             	cmp    $0x55,%eax
  8008d7:	0f 87 5a 04 00 00    	ja     800d37 <vprintfmt+0x6cf>
  8008dd:	89 c0                	mov    %eax,%eax
  8008df:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008e6:	00 
  8008e7:	48 b8 b0 38 80 00 00 	movabs $0x8038b0,%rax
  8008ee:	00 00 00 
  8008f1:	48 01 d0             	add    %rdx,%rax
  8008f4:	48 8b 00             	mov    (%rax),%rax
  8008f7:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008f9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008fd:	eb c0                	jmp    8008bf <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008ff:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800903:	eb ba                	jmp    8008bf <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800905:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80090c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80090f:	89 d0                	mov    %edx,%eax
  800911:	c1 e0 02             	shl    $0x2,%eax
  800914:	01 d0                	add    %edx,%eax
  800916:	01 c0                	add    %eax,%eax
  800918:	01 d8                	add    %ebx,%eax
  80091a:	83 e8 30             	sub    $0x30,%eax
  80091d:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800920:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800924:	0f b6 00             	movzbl (%rax),%eax
  800927:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80092a:	83 fb 2f             	cmp    $0x2f,%ebx
  80092d:	7e 0c                	jle    80093b <vprintfmt+0x2d3>
  80092f:	83 fb 39             	cmp    $0x39,%ebx
  800932:	7f 07                	jg     80093b <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800934:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800939:	eb d1                	jmp    80090c <vprintfmt+0x2a4>
			goto process_precision;
  80093b:	eb 58                	jmp    800995 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  80093d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800940:	83 f8 30             	cmp    $0x30,%eax
  800943:	73 17                	jae    80095c <vprintfmt+0x2f4>
  800945:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800949:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094c:	89 c0                	mov    %eax,%eax
  80094e:	48 01 d0             	add    %rdx,%rax
  800951:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800954:	83 c2 08             	add    $0x8,%edx
  800957:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80095a:	eb 0f                	jmp    80096b <vprintfmt+0x303>
  80095c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800960:	48 89 d0             	mov    %rdx,%rax
  800963:	48 83 c2 08          	add    $0x8,%rdx
  800967:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80096b:	8b 00                	mov    (%rax),%eax
  80096d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800970:	eb 23                	jmp    800995 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800972:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800976:	79 0c                	jns    800984 <vprintfmt+0x31c>
				width = 0;
  800978:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80097f:	e9 3b ff ff ff       	jmpq   8008bf <vprintfmt+0x257>
  800984:	e9 36 ff ff ff       	jmpq   8008bf <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800989:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800990:	e9 2a ff ff ff       	jmpq   8008bf <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800995:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800999:	79 12                	jns    8009ad <vprintfmt+0x345>
				width = precision, precision = -1;
  80099b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80099e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009a1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009a8:	e9 12 ff ff ff       	jmpq   8008bf <vprintfmt+0x257>
  8009ad:	e9 0d ff ff ff       	jmpq   8008bf <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009b2:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009b6:	e9 04 ff ff ff       	jmpq   8008bf <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009bb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009be:	83 f8 30             	cmp    $0x30,%eax
  8009c1:	73 17                	jae    8009da <vprintfmt+0x372>
  8009c3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009c7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ca:	89 c0                	mov    %eax,%eax
  8009cc:	48 01 d0             	add    %rdx,%rax
  8009cf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d2:	83 c2 08             	add    $0x8,%edx
  8009d5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009d8:	eb 0f                	jmp    8009e9 <vprintfmt+0x381>
  8009da:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009de:	48 89 d0             	mov    %rdx,%rax
  8009e1:	48 83 c2 08          	add    $0x8,%rdx
  8009e5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009e9:	8b 10                	mov    (%rax),%edx
  8009eb:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009ef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f3:	48 89 ce             	mov    %rcx,%rsi
  8009f6:	89 d7                	mov    %edx,%edi
  8009f8:	ff d0                	callq  *%rax
			break;
  8009fa:	e9 66 03 00 00       	jmpq   800d65 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8009ff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a02:	83 f8 30             	cmp    $0x30,%eax
  800a05:	73 17                	jae    800a1e <vprintfmt+0x3b6>
  800a07:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a0b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0e:	89 c0                	mov    %eax,%eax
  800a10:	48 01 d0             	add    %rdx,%rax
  800a13:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a16:	83 c2 08             	add    $0x8,%edx
  800a19:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a1c:	eb 0f                	jmp    800a2d <vprintfmt+0x3c5>
  800a1e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a22:	48 89 d0             	mov    %rdx,%rax
  800a25:	48 83 c2 08          	add    $0x8,%rdx
  800a29:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a2d:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a2f:	85 db                	test   %ebx,%ebx
  800a31:	79 02                	jns    800a35 <vprintfmt+0x3cd>
				err = -err;
  800a33:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a35:	83 fb 10             	cmp    $0x10,%ebx
  800a38:	7f 16                	jg     800a50 <vprintfmt+0x3e8>
  800a3a:	48 b8 00 38 80 00 00 	movabs $0x803800,%rax
  800a41:	00 00 00 
  800a44:	48 63 d3             	movslq %ebx,%rdx
  800a47:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a4b:	4d 85 e4             	test   %r12,%r12
  800a4e:	75 2e                	jne    800a7e <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800a50:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a54:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a58:	89 d9                	mov    %ebx,%ecx
  800a5a:	48 ba 99 38 80 00 00 	movabs $0x803899,%rdx
  800a61:	00 00 00 
  800a64:	48 89 c7             	mov    %rax,%rdi
  800a67:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6c:	49 b8 73 0d 80 00 00 	movabs $0x800d73,%r8
  800a73:	00 00 00 
  800a76:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a79:	e9 e7 02 00 00       	jmpq   800d65 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a7e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a82:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a86:	4c 89 e1             	mov    %r12,%rcx
  800a89:	48 ba a2 38 80 00 00 	movabs $0x8038a2,%rdx
  800a90:	00 00 00 
  800a93:	48 89 c7             	mov    %rax,%rdi
  800a96:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9b:	49 b8 73 0d 80 00 00 	movabs $0x800d73,%r8
  800aa2:	00 00 00 
  800aa5:	41 ff d0             	callq  *%r8
			break;
  800aa8:	e9 b8 02 00 00       	jmpq   800d65 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800aad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab0:	83 f8 30             	cmp    $0x30,%eax
  800ab3:	73 17                	jae    800acc <vprintfmt+0x464>
  800ab5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ab9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800abc:	89 c0                	mov    %eax,%eax
  800abe:	48 01 d0             	add    %rdx,%rax
  800ac1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac4:	83 c2 08             	add    $0x8,%edx
  800ac7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aca:	eb 0f                	jmp    800adb <vprintfmt+0x473>
  800acc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ad0:	48 89 d0             	mov    %rdx,%rax
  800ad3:	48 83 c2 08          	add    $0x8,%rdx
  800ad7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800adb:	4c 8b 20             	mov    (%rax),%r12
  800ade:	4d 85 e4             	test   %r12,%r12
  800ae1:	75 0a                	jne    800aed <vprintfmt+0x485>
				p = "(null)";
  800ae3:	49 bc a5 38 80 00 00 	movabs $0x8038a5,%r12
  800aea:	00 00 00 
			if (width > 0 && padc != '-')
  800aed:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af1:	7e 3f                	jle    800b32 <vprintfmt+0x4ca>
  800af3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800af7:	74 39                	je     800b32 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800af9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800afc:	48 98                	cltq   
  800afe:	48 89 c6             	mov    %rax,%rsi
  800b01:	4c 89 e7             	mov    %r12,%rdi
  800b04:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  800b0b:	00 00 00 
  800b0e:	ff d0                	callq  *%rax
  800b10:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b13:	eb 17                	jmp    800b2c <vprintfmt+0x4c4>
					putch(padc, putdat);
  800b15:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b19:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b21:	48 89 ce             	mov    %rcx,%rsi
  800b24:	89 d7                	mov    %edx,%edi
  800b26:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b28:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b2c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b30:	7f e3                	jg     800b15 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b32:	eb 37                	jmp    800b6b <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800b34:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b38:	74 1e                	je     800b58 <vprintfmt+0x4f0>
  800b3a:	83 fb 1f             	cmp    $0x1f,%ebx
  800b3d:	7e 05                	jle    800b44 <vprintfmt+0x4dc>
  800b3f:	83 fb 7e             	cmp    $0x7e,%ebx
  800b42:	7e 14                	jle    800b58 <vprintfmt+0x4f0>
					putch('?', putdat);
  800b44:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b4c:	48 89 d6             	mov    %rdx,%rsi
  800b4f:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b54:	ff d0                	callq  *%rax
  800b56:	eb 0f                	jmp    800b67 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800b58:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b5c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b60:	48 89 d6             	mov    %rdx,%rsi
  800b63:	89 df                	mov    %ebx,%edi
  800b65:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b67:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b6b:	4c 89 e0             	mov    %r12,%rax
  800b6e:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b72:	0f b6 00             	movzbl (%rax),%eax
  800b75:	0f be d8             	movsbl %al,%ebx
  800b78:	85 db                	test   %ebx,%ebx
  800b7a:	74 10                	je     800b8c <vprintfmt+0x524>
  800b7c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b80:	78 b2                	js     800b34 <vprintfmt+0x4cc>
  800b82:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b86:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b8a:	79 a8                	jns    800b34 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b8c:	eb 16                	jmp    800ba4 <vprintfmt+0x53c>
				putch(' ', putdat);
  800b8e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b96:	48 89 d6             	mov    %rdx,%rsi
  800b99:	bf 20 00 00 00       	mov    $0x20,%edi
  800b9e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ba4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ba8:	7f e4                	jg     800b8e <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800baa:	e9 b6 01 00 00       	jmpq   800d65 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800baf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bb3:	be 03 00 00 00       	mov    $0x3,%esi
  800bb8:	48 89 c7             	mov    %rax,%rdi
  800bbb:	48 b8 58 05 80 00 00 	movabs $0x800558,%rax
  800bc2:	00 00 00 
  800bc5:	ff d0                	callq  *%rax
  800bc7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bcf:	48 85 c0             	test   %rax,%rax
  800bd2:	79 1d                	jns    800bf1 <vprintfmt+0x589>
				putch('-', putdat);
  800bd4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bd8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bdc:	48 89 d6             	mov    %rdx,%rsi
  800bdf:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800be4:	ff d0                	callq  *%rax
				num = -(long long) num;
  800be6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bea:	48 f7 d8             	neg    %rax
  800bed:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bf1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bf8:	e9 fb 00 00 00       	jmpq   800cf8 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bfd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c01:	be 03 00 00 00       	mov    $0x3,%esi
  800c06:	48 89 c7             	mov    %rax,%rdi
  800c09:	48 b8 48 04 80 00 00 	movabs $0x800448,%rax
  800c10:	00 00 00 
  800c13:	ff d0                	callq  *%rax
  800c15:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c19:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c20:	e9 d3 00 00 00       	jmpq   800cf8 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800c25:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c29:	be 03 00 00 00       	mov    $0x3,%esi
  800c2e:	48 89 c7             	mov    %rax,%rdi
  800c31:	48 b8 58 05 80 00 00 	movabs $0x800558,%rax
  800c38:	00 00 00 
  800c3b:	ff d0                	callq  *%rax
  800c3d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c45:	48 85 c0             	test   %rax,%rax
  800c48:	79 1d                	jns    800c67 <vprintfmt+0x5ff>
				putch('-', putdat);
  800c4a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c52:	48 89 d6             	mov    %rdx,%rsi
  800c55:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c5a:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c60:	48 f7 d8             	neg    %rax
  800c63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800c67:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c6e:	e9 85 00 00 00       	jmpq   800cf8 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800c73:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7b:	48 89 d6             	mov    %rdx,%rsi
  800c7e:	bf 30 00 00 00       	mov    $0x30,%edi
  800c83:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c85:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c8d:	48 89 d6             	mov    %rdx,%rsi
  800c90:	bf 78 00 00 00       	mov    $0x78,%edi
  800c95:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c97:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9a:	83 f8 30             	cmp    $0x30,%eax
  800c9d:	73 17                	jae    800cb6 <vprintfmt+0x64e>
  800c9f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ca3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca6:	89 c0                	mov    %eax,%eax
  800ca8:	48 01 d0             	add    %rdx,%rax
  800cab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cae:	83 c2 08             	add    $0x8,%edx
  800cb1:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb4:	eb 0f                	jmp    800cc5 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800cb6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cba:	48 89 d0             	mov    %rdx,%rax
  800cbd:	48 83 c2 08          	add    $0x8,%rdx
  800cc1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cc5:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ccc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cd3:	eb 23                	jmp    800cf8 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cd5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cd9:	be 03 00 00 00       	mov    $0x3,%esi
  800cde:	48 89 c7             	mov    %rax,%rdi
  800ce1:	48 b8 48 04 80 00 00 	movabs $0x800448,%rax
  800ce8:	00 00 00 
  800ceb:	ff d0                	callq  *%rax
  800ced:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cf1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cf8:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cfd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d00:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d03:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d07:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0f:	45 89 c1             	mov    %r8d,%r9d
  800d12:	41 89 f8             	mov    %edi,%r8d
  800d15:	48 89 c7             	mov    %rax,%rdi
  800d18:	48 b8 8d 03 80 00 00 	movabs $0x80038d,%rax
  800d1f:	00 00 00 
  800d22:	ff d0                	callq  *%rax
			break;
  800d24:	eb 3f                	jmp    800d65 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d26:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2e:	48 89 d6             	mov    %rdx,%rsi
  800d31:	89 df                	mov    %ebx,%edi
  800d33:	ff d0                	callq  *%rax
			break;
  800d35:	eb 2e                	jmp    800d65 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d37:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3f:	48 89 d6             	mov    %rdx,%rsi
  800d42:	bf 25 00 00 00       	mov    $0x25,%edi
  800d47:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d49:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d4e:	eb 05                	jmp    800d55 <vprintfmt+0x6ed>
  800d50:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d55:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d59:	48 83 e8 01          	sub    $0x1,%rax
  800d5d:	0f b6 00             	movzbl (%rax),%eax
  800d60:	3c 25                	cmp    $0x25,%al
  800d62:	75 ec                	jne    800d50 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  800d64:	90                   	nop
		}
	}
  800d65:	e9 37 f9 ff ff       	jmpq   8006a1 <vprintfmt+0x39>
    va_end(aq);
}
  800d6a:	48 83 c4 60          	add    $0x60,%rsp
  800d6e:	5b                   	pop    %rbx
  800d6f:	41 5c                	pop    %r12
  800d71:	5d                   	pop    %rbp
  800d72:	c3                   	retq   

0000000000800d73 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d73:	55                   	push   %rbp
  800d74:	48 89 e5             	mov    %rsp,%rbp
  800d77:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d7e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d85:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d8c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d93:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d9a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800da1:	84 c0                	test   %al,%al
  800da3:	74 20                	je     800dc5 <printfmt+0x52>
  800da5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800da9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dad:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800db1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800db5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800db9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dbd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dc1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dc5:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dcc:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dd3:	00 00 00 
  800dd6:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ddd:	00 00 00 
  800de0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800de4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800deb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800df2:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800df9:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e00:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e07:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e0e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e15:	48 89 c7             	mov    %rax,%rdi
  800e18:	48 b8 68 06 80 00 00 	movabs $0x800668,%rax
  800e1f:	00 00 00 
  800e22:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e24:	c9                   	leaveq 
  800e25:	c3                   	retq   

0000000000800e26 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e26:	55                   	push   %rbp
  800e27:	48 89 e5             	mov    %rsp,%rbp
  800e2a:	48 83 ec 10          	sub    $0x10,%rsp
  800e2e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e31:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e39:	8b 40 10             	mov    0x10(%rax),%eax
  800e3c:	8d 50 01             	lea    0x1(%rax),%edx
  800e3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e43:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4a:	48 8b 10             	mov    (%rax),%rdx
  800e4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e51:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e55:	48 39 c2             	cmp    %rax,%rdx
  800e58:	73 17                	jae    800e71 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e5e:	48 8b 00             	mov    (%rax),%rax
  800e61:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e69:	48 89 0a             	mov    %rcx,(%rdx)
  800e6c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e6f:	88 10                	mov    %dl,(%rax)
}
  800e71:	c9                   	leaveq 
  800e72:	c3                   	retq   

0000000000800e73 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e73:	55                   	push   %rbp
  800e74:	48 89 e5             	mov    %rsp,%rbp
  800e77:	48 83 ec 50          	sub    $0x50,%rsp
  800e7b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e7f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e82:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e86:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e8a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e8e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e92:	48 8b 0a             	mov    (%rdx),%rcx
  800e95:	48 89 08             	mov    %rcx,(%rax)
  800e98:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e9c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ea0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ea4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ea8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eac:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800eb0:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800eb3:	48 98                	cltq   
  800eb5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800eb9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ebd:	48 01 d0             	add    %rdx,%rax
  800ec0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ec4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ecb:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ed0:	74 06                	je     800ed8 <vsnprintf+0x65>
  800ed2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ed6:	7f 07                	jg     800edf <vsnprintf+0x6c>
		return -E_INVAL;
  800ed8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800edd:	eb 2f                	jmp    800f0e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800edf:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ee3:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ee7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800eeb:	48 89 c6             	mov    %rax,%rsi
  800eee:	48 bf 26 0e 80 00 00 	movabs $0x800e26,%rdi
  800ef5:	00 00 00 
  800ef8:	48 b8 68 06 80 00 00 	movabs $0x800668,%rax
  800eff:	00 00 00 
  800f02:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f08:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f0b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f0e:	c9                   	leaveq 
  800f0f:	c3                   	retq   

0000000000800f10 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f10:	55                   	push   %rbp
  800f11:	48 89 e5             	mov    %rsp,%rbp
  800f14:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f1b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f22:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f28:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f2f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f36:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f3d:	84 c0                	test   %al,%al
  800f3f:	74 20                	je     800f61 <snprintf+0x51>
  800f41:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f45:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f49:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f4d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f51:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f55:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f59:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f5d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f61:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f68:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f6f:	00 00 00 
  800f72:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f79:	00 00 00 
  800f7c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f80:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f87:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f8e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f95:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f9c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fa3:	48 8b 0a             	mov    (%rdx),%rcx
  800fa6:	48 89 08             	mov    %rcx,(%rax)
  800fa9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fad:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fb1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fb5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fb9:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fc0:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fc7:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fcd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fd4:	48 89 c7             	mov    %rax,%rdi
  800fd7:	48 b8 73 0e 80 00 00 	movabs $0x800e73,%rax
  800fde:	00 00 00 
  800fe1:	ff d0                	callq  *%rax
  800fe3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fe9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fef:	c9                   	leaveq 
  800ff0:	c3                   	retq   

0000000000800ff1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ff1:	55                   	push   %rbp
  800ff2:	48 89 e5             	mov    %rsp,%rbp
  800ff5:	48 83 ec 18          	sub    $0x18,%rsp
  800ff9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801004:	eb 09                	jmp    80100f <strlen+0x1e>
		n++;
  801006:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80100a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80100f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801013:	0f b6 00             	movzbl (%rax),%eax
  801016:	84 c0                	test   %al,%al
  801018:	75 ec                	jne    801006 <strlen+0x15>
		n++;
	return n;
  80101a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80101d:	c9                   	leaveq 
  80101e:	c3                   	retq   

000000000080101f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80101f:	55                   	push   %rbp
  801020:	48 89 e5             	mov    %rsp,%rbp
  801023:	48 83 ec 20          	sub    $0x20,%rsp
  801027:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80102b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80102f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801036:	eb 0e                	jmp    801046 <strnlen+0x27>
		n++;
  801038:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80103c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801041:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801046:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80104b:	74 0b                	je     801058 <strnlen+0x39>
  80104d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801051:	0f b6 00             	movzbl (%rax),%eax
  801054:	84 c0                	test   %al,%al
  801056:	75 e0                	jne    801038 <strnlen+0x19>
		n++;
	return n;
  801058:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80105b:	c9                   	leaveq 
  80105c:	c3                   	retq   

000000000080105d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80105d:	55                   	push   %rbp
  80105e:	48 89 e5             	mov    %rsp,%rbp
  801061:	48 83 ec 20          	sub    $0x20,%rsp
  801065:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801069:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80106d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801071:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801075:	90                   	nop
  801076:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80107e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801082:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801086:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80108a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80108e:	0f b6 12             	movzbl (%rdx),%edx
  801091:	88 10                	mov    %dl,(%rax)
  801093:	0f b6 00             	movzbl (%rax),%eax
  801096:	84 c0                	test   %al,%al
  801098:	75 dc                	jne    801076 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80109a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80109e:	c9                   	leaveq 
  80109f:	c3                   	retq   

00000000008010a0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010a0:	55                   	push   %rbp
  8010a1:	48 89 e5             	mov    %rsp,%rbp
  8010a4:	48 83 ec 20          	sub    $0x20,%rsp
  8010a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b4:	48 89 c7             	mov    %rax,%rdi
  8010b7:	48 b8 f1 0f 80 00 00 	movabs $0x800ff1,%rax
  8010be:	00 00 00 
  8010c1:	ff d0                	callq  *%rax
  8010c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c9:	48 63 d0             	movslq %eax,%rdx
  8010cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d0:	48 01 c2             	add    %rax,%rdx
  8010d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010d7:	48 89 c6             	mov    %rax,%rsi
  8010da:	48 89 d7             	mov    %rdx,%rdi
  8010dd:	48 b8 5d 10 80 00 00 	movabs $0x80105d,%rax
  8010e4:	00 00 00 
  8010e7:	ff d0                	callq  *%rax
	return dst;
  8010e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010ed:	c9                   	leaveq 
  8010ee:	c3                   	retq   

00000000008010ef <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010ef:	55                   	push   %rbp
  8010f0:	48 89 e5             	mov    %rsp,%rbp
  8010f3:	48 83 ec 28          	sub    $0x28,%rsp
  8010f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010fb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010ff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801103:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801107:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80110b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801112:	00 
  801113:	eb 2a                	jmp    80113f <strncpy+0x50>
		*dst++ = *src;
  801115:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801119:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80111d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801121:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801125:	0f b6 12             	movzbl (%rdx),%edx
  801128:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80112a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80112e:	0f b6 00             	movzbl (%rax),%eax
  801131:	84 c0                	test   %al,%al
  801133:	74 05                	je     80113a <strncpy+0x4b>
			src++;
  801135:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80113a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80113f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801143:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801147:	72 cc                	jb     801115 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801149:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80114d:	c9                   	leaveq 
  80114e:	c3                   	retq   

000000000080114f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80114f:	55                   	push   %rbp
  801150:	48 89 e5             	mov    %rsp,%rbp
  801153:	48 83 ec 28          	sub    $0x28,%rsp
  801157:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80115b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80115f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801163:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801167:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80116b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801170:	74 3d                	je     8011af <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801172:	eb 1d                	jmp    801191 <strlcpy+0x42>
			*dst++ = *src++;
  801174:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801178:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80117c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801180:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801184:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801188:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80118c:	0f b6 12             	movzbl (%rdx),%edx
  80118f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801191:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801196:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80119b:	74 0b                	je     8011a8 <strlcpy+0x59>
  80119d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011a1:	0f b6 00             	movzbl (%rax),%eax
  8011a4:	84 c0                	test   %al,%al
  8011a6:	75 cc                	jne    801174 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ac:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b7:	48 29 c2             	sub    %rax,%rdx
  8011ba:	48 89 d0             	mov    %rdx,%rax
}
  8011bd:	c9                   	leaveq 
  8011be:	c3                   	retq   

00000000008011bf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011bf:	55                   	push   %rbp
  8011c0:	48 89 e5             	mov    %rsp,%rbp
  8011c3:	48 83 ec 10          	sub    $0x10,%rsp
  8011c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011cf:	eb 0a                	jmp    8011db <strcmp+0x1c>
		p++, q++;
  8011d1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011d6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011df:	0f b6 00             	movzbl (%rax),%eax
  8011e2:	84 c0                	test   %al,%al
  8011e4:	74 12                	je     8011f8 <strcmp+0x39>
  8011e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ea:	0f b6 10             	movzbl (%rax),%edx
  8011ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f1:	0f b6 00             	movzbl (%rax),%eax
  8011f4:	38 c2                	cmp    %al,%dl
  8011f6:	74 d9                	je     8011d1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fc:	0f b6 00             	movzbl (%rax),%eax
  8011ff:	0f b6 d0             	movzbl %al,%edx
  801202:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801206:	0f b6 00             	movzbl (%rax),%eax
  801209:	0f b6 c0             	movzbl %al,%eax
  80120c:	29 c2                	sub    %eax,%edx
  80120e:	89 d0                	mov    %edx,%eax
}
  801210:	c9                   	leaveq 
  801211:	c3                   	retq   

0000000000801212 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801212:	55                   	push   %rbp
  801213:	48 89 e5             	mov    %rsp,%rbp
  801216:	48 83 ec 18          	sub    $0x18,%rsp
  80121a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80121e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801222:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801226:	eb 0f                	jmp    801237 <strncmp+0x25>
		n--, p++, q++;
  801228:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80122d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801232:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801237:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80123c:	74 1d                	je     80125b <strncmp+0x49>
  80123e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801242:	0f b6 00             	movzbl (%rax),%eax
  801245:	84 c0                	test   %al,%al
  801247:	74 12                	je     80125b <strncmp+0x49>
  801249:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124d:	0f b6 10             	movzbl (%rax),%edx
  801250:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801254:	0f b6 00             	movzbl (%rax),%eax
  801257:	38 c2                	cmp    %al,%dl
  801259:	74 cd                	je     801228 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80125b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801260:	75 07                	jne    801269 <strncmp+0x57>
		return 0;
  801262:	b8 00 00 00 00       	mov    $0x0,%eax
  801267:	eb 18                	jmp    801281 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801269:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126d:	0f b6 00             	movzbl (%rax),%eax
  801270:	0f b6 d0             	movzbl %al,%edx
  801273:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801277:	0f b6 00             	movzbl (%rax),%eax
  80127a:	0f b6 c0             	movzbl %al,%eax
  80127d:	29 c2                	sub    %eax,%edx
  80127f:	89 d0                	mov    %edx,%eax
}
  801281:	c9                   	leaveq 
  801282:	c3                   	retq   

0000000000801283 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801283:	55                   	push   %rbp
  801284:	48 89 e5             	mov    %rsp,%rbp
  801287:	48 83 ec 0c          	sub    $0xc,%rsp
  80128b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80128f:	89 f0                	mov    %esi,%eax
  801291:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801294:	eb 17                	jmp    8012ad <strchr+0x2a>
		if (*s == c)
  801296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129a:	0f b6 00             	movzbl (%rax),%eax
  80129d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012a0:	75 06                	jne    8012a8 <strchr+0x25>
			return (char *) s;
  8012a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a6:	eb 15                	jmp    8012bd <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012a8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b1:	0f b6 00             	movzbl (%rax),%eax
  8012b4:	84 c0                	test   %al,%al
  8012b6:	75 de                	jne    801296 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012bd:	c9                   	leaveq 
  8012be:	c3                   	retq   

00000000008012bf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012bf:	55                   	push   %rbp
  8012c0:	48 89 e5             	mov    %rsp,%rbp
  8012c3:	48 83 ec 0c          	sub    $0xc,%rsp
  8012c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012cb:	89 f0                	mov    %esi,%eax
  8012cd:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012d0:	eb 13                	jmp    8012e5 <strfind+0x26>
		if (*s == c)
  8012d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d6:	0f b6 00             	movzbl (%rax),%eax
  8012d9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012dc:	75 02                	jne    8012e0 <strfind+0x21>
			break;
  8012de:	eb 10                	jmp    8012f0 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e9:	0f b6 00             	movzbl (%rax),%eax
  8012ec:	84 c0                	test   %al,%al
  8012ee:	75 e2                	jne    8012d2 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012f4:	c9                   	leaveq 
  8012f5:	c3                   	retq   

00000000008012f6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012f6:	55                   	push   %rbp
  8012f7:	48 89 e5             	mov    %rsp,%rbp
  8012fa:	48 83 ec 18          	sub    $0x18,%rsp
  8012fe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801302:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801305:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801309:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80130e:	75 06                	jne    801316 <memset+0x20>
		return v;
  801310:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801314:	eb 69                	jmp    80137f <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131a:	83 e0 03             	and    $0x3,%eax
  80131d:	48 85 c0             	test   %rax,%rax
  801320:	75 48                	jne    80136a <memset+0x74>
  801322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801326:	83 e0 03             	and    $0x3,%eax
  801329:	48 85 c0             	test   %rax,%rax
  80132c:	75 3c                	jne    80136a <memset+0x74>
		c &= 0xFF;
  80132e:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801335:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801338:	c1 e0 18             	shl    $0x18,%eax
  80133b:	89 c2                	mov    %eax,%edx
  80133d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801340:	c1 e0 10             	shl    $0x10,%eax
  801343:	09 c2                	or     %eax,%edx
  801345:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801348:	c1 e0 08             	shl    $0x8,%eax
  80134b:	09 d0                	or     %edx,%eax
  80134d:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801350:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801354:	48 c1 e8 02          	shr    $0x2,%rax
  801358:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80135b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80135f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801362:	48 89 d7             	mov    %rdx,%rdi
  801365:	fc                   	cld    
  801366:	f3 ab                	rep stos %eax,%es:(%rdi)
  801368:	eb 11                	jmp    80137b <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80136a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80136e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801371:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801375:	48 89 d7             	mov    %rdx,%rdi
  801378:	fc                   	cld    
  801379:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80137b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80137f:	c9                   	leaveq 
  801380:	c3                   	retq   

0000000000801381 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801381:	55                   	push   %rbp
  801382:	48 89 e5             	mov    %rsp,%rbp
  801385:	48 83 ec 28          	sub    $0x28,%rsp
  801389:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80138d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801391:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801395:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801399:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80139d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a9:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013ad:	0f 83 88 00 00 00    	jae    80143b <memmove+0xba>
  8013b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013bb:	48 01 d0             	add    %rdx,%rax
  8013be:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013c2:	76 77                	jbe    80143b <memmove+0xba>
		s += n;
  8013c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c8:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d0:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d8:	83 e0 03             	and    $0x3,%eax
  8013db:	48 85 c0             	test   %rax,%rax
  8013de:	75 3b                	jne    80141b <memmove+0x9a>
  8013e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e4:	83 e0 03             	and    $0x3,%eax
  8013e7:	48 85 c0             	test   %rax,%rax
  8013ea:	75 2f                	jne    80141b <memmove+0x9a>
  8013ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f0:	83 e0 03             	and    $0x3,%eax
  8013f3:	48 85 c0             	test   %rax,%rax
  8013f6:	75 23                	jne    80141b <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013fc:	48 83 e8 04          	sub    $0x4,%rax
  801400:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801404:	48 83 ea 04          	sub    $0x4,%rdx
  801408:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80140c:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801410:	48 89 c7             	mov    %rax,%rdi
  801413:	48 89 d6             	mov    %rdx,%rsi
  801416:	fd                   	std    
  801417:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801419:	eb 1d                	jmp    801438 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80141b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801423:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801427:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80142b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142f:	48 89 d7             	mov    %rdx,%rdi
  801432:	48 89 c1             	mov    %rax,%rcx
  801435:	fd                   	std    
  801436:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801438:	fc                   	cld    
  801439:	eb 57                	jmp    801492 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80143b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143f:	83 e0 03             	and    $0x3,%eax
  801442:	48 85 c0             	test   %rax,%rax
  801445:	75 36                	jne    80147d <memmove+0xfc>
  801447:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80144b:	83 e0 03             	and    $0x3,%eax
  80144e:	48 85 c0             	test   %rax,%rax
  801451:	75 2a                	jne    80147d <memmove+0xfc>
  801453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801457:	83 e0 03             	and    $0x3,%eax
  80145a:	48 85 c0             	test   %rax,%rax
  80145d:	75 1e                	jne    80147d <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80145f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801463:	48 c1 e8 02          	shr    $0x2,%rax
  801467:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80146a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801472:	48 89 c7             	mov    %rax,%rdi
  801475:	48 89 d6             	mov    %rdx,%rsi
  801478:	fc                   	cld    
  801479:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80147b:	eb 15                	jmp    801492 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80147d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801481:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801485:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801489:	48 89 c7             	mov    %rax,%rdi
  80148c:	48 89 d6             	mov    %rdx,%rsi
  80148f:	fc                   	cld    
  801490:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801492:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801496:	c9                   	leaveq 
  801497:	c3                   	retq   

0000000000801498 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801498:	55                   	push   %rbp
  801499:	48 89 e5             	mov    %rsp,%rbp
  80149c:	48 83 ec 18          	sub    $0x18,%rsp
  8014a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014b0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b8:	48 89 ce             	mov    %rcx,%rsi
  8014bb:	48 89 c7             	mov    %rax,%rdi
  8014be:	48 b8 81 13 80 00 00 	movabs $0x801381,%rax
  8014c5:	00 00 00 
  8014c8:	ff d0                	callq  *%rax
}
  8014ca:	c9                   	leaveq 
  8014cb:	c3                   	retq   

00000000008014cc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014cc:	55                   	push   %rbp
  8014cd:	48 89 e5             	mov    %rsp,%rbp
  8014d0:	48 83 ec 28          	sub    $0x28,%rsp
  8014d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014f0:	eb 36                	jmp    801528 <memcmp+0x5c>
		if (*s1 != *s2)
  8014f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f6:	0f b6 10             	movzbl (%rax),%edx
  8014f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fd:	0f b6 00             	movzbl (%rax),%eax
  801500:	38 c2                	cmp    %al,%dl
  801502:	74 1a                	je     80151e <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801504:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801508:	0f b6 00             	movzbl (%rax),%eax
  80150b:	0f b6 d0             	movzbl %al,%edx
  80150e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801512:	0f b6 00             	movzbl (%rax),%eax
  801515:	0f b6 c0             	movzbl %al,%eax
  801518:	29 c2                	sub    %eax,%edx
  80151a:	89 d0                	mov    %edx,%eax
  80151c:	eb 20                	jmp    80153e <memcmp+0x72>
		s1++, s2++;
  80151e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801523:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801528:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801530:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801534:	48 85 c0             	test   %rax,%rax
  801537:	75 b9                	jne    8014f2 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801539:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153e:	c9                   	leaveq 
  80153f:	c3                   	retq   

0000000000801540 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801540:	55                   	push   %rbp
  801541:	48 89 e5             	mov    %rsp,%rbp
  801544:	48 83 ec 28          	sub    $0x28,%rsp
  801548:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80154c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80154f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801553:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801557:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80155b:	48 01 d0             	add    %rdx,%rax
  80155e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801562:	eb 15                	jmp    801579 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801564:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801568:	0f b6 10             	movzbl (%rax),%edx
  80156b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80156e:	38 c2                	cmp    %al,%dl
  801570:	75 02                	jne    801574 <memfind+0x34>
			break;
  801572:	eb 0f                	jmp    801583 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801574:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801579:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801581:	72 e1                	jb     801564 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801583:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801587:	c9                   	leaveq 
  801588:	c3                   	retq   

0000000000801589 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801589:	55                   	push   %rbp
  80158a:	48 89 e5             	mov    %rsp,%rbp
  80158d:	48 83 ec 34          	sub    $0x34,%rsp
  801591:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801595:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801599:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80159c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015a3:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015aa:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015ab:	eb 05                	jmp    8015b2 <strtol+0x29>
		s++;
  8015ad:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b6:	0f b6 00             	movzbl (%rax),%eax
  8015b9:	3c 20                	cmp    $0x20,%al
  8015bb:	74 f0                	je     8015ad <strtol+0x24>
  8015bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c1:	0f b6 00             	movzbl (%rax),%eax
  8015c4:	3c 09                	cmp    $0x9,%al
  8015c6:	74 e5                	je     8015ad <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cc:	0f b6 00             	movzbl (%rax),%eax
  8015cf:	3c 2b                	cmp    $0x2b,%al
  8015d1:	75 07                	jne    8015da <strtol+0x51>
		s++;
  8015d3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d8:	eb 17                	jmp    8015f1 <strtol+0x68>
	else if (*s == '-')
  8015da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015de:	0f b6 00             	movzbl (%rax),%eax
  8015e1:	3c 2d                	cmp    $0x2d,%al
  8015e3:	75 0c                	jne    8015f1 <strtol+0x68>
		s++, neg = 1;
  8015e5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015f1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015f5:	74 06                	je     8015fd <strtol+0x74>
  8015f7:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015fb:	75 28                	jne    801625 <strtol+0x9c>
  8015fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801601:	0f b6 00             	movzbl (%rax),%eax
  801604:	3c 30                	cmp    $0x30,%al
  801606:	75 1d                	jne    801625 <strtol+0x9c>
  801608:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160c:	48 83 c0 01          	add    $0x1,%rax
  801610:	0f b6 00             	movzbl (%rax),%eax
  801613:	3c 78                	cmp    $0x78,%al
  801615:	75 0e                	jne    801625 <strtol+0x9c>
		s += 2, base = 16;
  801617:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80161c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801623:	eb 2c                	jmp    801651 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801625:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801629:	75 19                	jne    801644 <strtol+0xbb>
  80162b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162f:	0f b6 00             	movzbl (%rax),%eax
  801632:	3c 30                	cmp    $0x30,%al
  801634:	75 0e                	jne    801644 <strtol+0xbb>
		s++, base = 8;
  801636:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80163b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801642:	eb 0d                	jmp    801651 <strtol+0xc8>
	else if (base == 0)
  801644:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801648:	75 07                	jne    801651 <strtol+0xc8>
		base = 10;
  80164a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801651:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801655:	0f b6 00             	movzbl (%rax),%eax
  801658:	3c 2f                	cmp    $0x2f,%al
  80165a:	7e 1d                	jle    801679 <strtol+0xf0>
  80165c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801660:	0f b6 00             	movzbl (%rax),%eax
  801663:	3c 39                	cmp    $0x39,%al
  801665:	7f 12                	jg     801679 <strtol+0xf0>
			dig = *s - '0';
  801667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166b:	0f b6 00             	movzbl (%rax),%eax
  80166e:	0f be c0             	movsbl %al,%eax
  801671:	83 e8 30             	sub    $0x30,%eax
  801674:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801677:	eb 4e                	jmp    8016c7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801679:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167d:	0f b6 00             	movzbl (%rax),%eax
  801680:	3c 60                	cmp    $0x60,%al
  801682:	7e 1d                	jle    8016a1 <strtol+0x118>
  801684:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801688:	0f b6 00             	movzbl (%rax),%eax
  80168b:	3c 7a                	cmp    $0x7a,%al
  80168d:	7f 12                	jg     8016a1 <strtol+0x118>
			dig = *s - 'a' + 10;
  80168f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801693:	0f b6 00             	movzbl (%rax),%eax
  801696:	0f be c0             	movsbl %al,%eax
  801699:	83 e8 57             	sub    $0x57,%eax
  80169c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80169f:	eb 26                	jmp    8016c7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a5:	0f b6 00             	movzbl (%rax),%eax
  8016a8:	3c 40                	cmp    $0x40,%al
  8016aa:	7e 48                	jle    8016f4 <strtol+0x16b>
  8016ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b0:	0f b6 00             	movzbl (%rax),%eax
  8016b3:	3c 5a                	cmp    $0x5a,%al
  8016b5:	7f 3d                	jg     8016f4 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bb:	0f b6 00             	movzbl (%rax),%eax
  8016be:	0f be c0             	movsbl %al,%eax
  8016c1:	83 e8 37             	sub    $0x37,%eax
  8016c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016ca:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016cd:	7c 02                	jl     8016d1 <strtol+0x148>
			break;
  8016cf:	eb 23                	jmp    8016f4 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016d1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016d6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016d9:	48 98                	cltq   
  8016db:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016e0:	48 89 c2             	mov    %rax,%rdx
  8016e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016e6:	48 98                	cltq   
  8016e8:	48 01 d0             	add    %rdx,%rax
  8016eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016ef:	e9 5d ff ff ff       	jmpq   801651 <strtol+0xc8>

	if (endptr)
  8016f4:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016f9:	74 0b                	je     801706 <strtol+0x17d>
		*endptr = (char *) s;
  8016fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ff:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801703:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801706:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80170a:	74 09                	je     801715 <strtol+0x18c>
  80170c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801710:	48 f7 d8             	neg    %rax
  801713:	eb 04                	jmp    801719 <strtol+0x190>
  801715:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801719:	c9                   	leaveq 
  80171a:	c3                   	retq   

000000000080171b <strstr>:

char * strstr(const char *in, const char *str)
{
  80171b:	55                   	push   %rbp
  80171c:	48 89 e5             	mov    %rsp,%rbp
  80171f:	48 83 ec 30          	sub    $0x30,%rsp
  801723:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801727:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80172b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80172f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801733:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801737:	0f b6 00             	movzbl (%rax),%eax
  80173a:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  80173d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801741:	75 06                	jne    801749 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801743:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801747:	eb 6b                	jmp    8017b4 <strstr+0x99>

    len = strlen(str);
  801749:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80174d:	48 89 c7             	mov    %rax,%rdi
  801750:	48 b8 f1 0f 80 00 00 	movabs $0x800ff1,%rax
  801757:	00 00 00 
  80175a:	ff d0                	callq  *%rax
  80175c:	48 98                	cltq   
  80175e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801762:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801766:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80176a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80176e:	0f b6 00             	movzbl (%rax),%eax
  801771:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801774:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801778:	75 07                	jne    801781 <strstr+0x66>
                return (char *) 0;
  80177a:	b8 00 00 00 00       	mov    $0x0,%eax
  80177f:	eb 33                	jmp    8017b4 <strstr+0x99>
        } while (sc != c);
  801781:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801785:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801788:	75 d8                	jne    801762 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  80178a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80178e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801792:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801796:	48 89 ce             	mov    %rcx,%rsi
  801799:	48 89 c7             	mov    %rax,%rdi
  80179c:	48 b8 12 12 80 00 00 	movabs $0x801212,%rax
  8017a3:	00 00 00 
  8017a6:	ff d0                	callq  *%rax
  8017a8:	85 c0                	test   %eax,%eax
  8017aa:	75 b6                	jne    801762 <strstr+0x47>

    return (char *) (in - 1);
  8017ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b0:	48 83 e8 01          	sub    $0x1,%rax
}
  8017b4:	c9                   	leaveq 
  8017b5:	c3                   	retq   

00000000008017b6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017b6:	55                   	push   %rbp
  8017b7:	48 89 e5             	mov    %rsp,%rbp
  8017ba:	53                   	push   %rbx
  8017bb:	48 83 ec 48          	sub    $0x48,%rsp
  8017bf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017c2:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017c5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017c9:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017cd:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017d1:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017d5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017d8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017dc:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017e0:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017e4:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017e8:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017ec:	4c 89 c3             	mov    %r8,%rbx
  8017ef:	cd 30                	int    $0x30
  8017f1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  8017f5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017f9:	74 3e                	je     801839 <syscall+0x83>
  8017fb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801800:	7e 37                	jle    801839 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801802:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801806:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801809:	49 89 d0             	mov    %rdx,%r8
  80180c:	89 c1                	mov    %eax,%ecx
  80180e:	48 ba 60 3b 80 00 00 	movabs $0x803b60,%rdx
  801815:	00 00 00 
  801818:	be 23 00 00 00       	mov    $0x23,%esi
  80181d:	48 bf 7d 3b 80 00 00 	movabs $0x803b7d,%rdi
  801824:	00 00 00 
  801827:	b8 00 00 00 00       	mov    $0x0,%eax
  80182c:	49 b9 ea 32 80 00 00 	movabs $0x8032ea,%r9
  801833:	00 00 00 
  801836:	41 ff d1             	callq  *%r9

	return ret;
  801839:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80183d:	48 83 c4 48          	add    $0x48,%rsp
  801841:	5b                   	pop    %rbx
  801842:	5d                   	pop    %rbp
  801843:	c3                   	retq   

0000000000801844 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801844:	55                   	push   %rbp
  801845:	48 89 e5             	mov    %rsp,%rbp
  801848:	48 83 ec 20          	sub    $0x20,%rsp
  80184c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801850:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801854:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801858:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80185c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801863:	00 
  801864:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80186a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801870:	48 89 d1             	mov    %rdx,%rcx
  801873:	48 89 c2             	mov    %rax,%rdx
  801876:	be 00 00 00 00       	mov    $0x0,%esi
  80187b:	bf 00 00 00 00       	mov    $0x0,%edi
  801880:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  801887:	00 00 00 
  80188a:	ff d0                	callq  *%rax
}
  80188c:	c9                   	leaveq 
  80188d:	c3                   	retq   

000000000080188e <sys_cgetc>:

int
sys_cgetc(void)
{
  80188e:	55                   	push   %rbp
  80188f:	48 89 e5             	mov    %rsp,%rbp
  801892:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801896:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80189d:	00 
  80189e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018af:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b4:	be 00 00 00 00       	mov    $0x0,%esi
  8018b9:	bf 01 00 00 00       	mov    $0x1,%edi
  8018be:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  8018c5:	00 00 00 
  8018c8:	ff d0                	callq  *%rax
}
  8018ca:	c9                   	leaveq 
  8018cb:	c3                   	retq   

00000000008018cc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018cc:	55                   	push   %rbp
  8018cd:	48 89 e5             	mov    %rsp,%rbp
  8018d0:	48 83 ec 10          	sub    $0x10,%rsp
  8018d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018da:	48 98                	cltq   
  8018dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e3:	00 
  8018e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f5:	48 89 c2             	mov    %rax,%rdx
  8018f8:	be 01 00 00 00       	mov    $0x1,%esi
  8018fd:	bf 03 00 00 00       	mov    $0x3,%edi
  801902:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  801909:	00 00 00 
  80190c:	ff d0                	callq  *%rax
}
  80190e:	c9                   	leaveq 
  80190f:	c3                   	retq   

0000000000801910 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801910:	55                   	push   %rbp
  801911:	48 89 e5             	mov    %rsp,%rbp
  801914:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801918:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80191f:	00 
  801920:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801926:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801931:	ba 00 00 00 00       	mov    $0x0,%edx
  801936:	be 00 00 00 00       	mov    $0x0,%esi
  80193b:	bf 02 00 00 00       	mov    $0x2,%edi
  801940:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  801947:	00 00 00 
  80194a:	ff d0                	callq  *%rax
}
  80194c:	c9                   	leaveq 
  80194d:	c3                   	retq   

000000000080194e <sys_yield>:

void
sys_yield(void)
{
  80194e:	55                   	push   %rbp
  80194f:	48 89 e5             	mov    %rsp,%rbp
  801952:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801956:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80195d:	00 
  80195e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801964:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80196a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80196f:	ba 00 00 00 00       	mov    $0x0,%edx
  801974:	be 00 00 00 00       	mov    $0x0,%esi
  801979:	bf 0b 00 00 00       	mov    $0xb,%edi
  80197e:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  801985:	00 00 00 
  801988:	ff d0                	callq  *%rax
}
  80198a:	c9                   	leaveq 
  80198b:	c3                   	retq   

000000000080198c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80198c:	55                   	push   %rbp
  80198d:	48 89 e5             	mov    %rsp,%rbp
  801990:	48 83 ec 20          	sub    $0x20,%rsp
  801994:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801997:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80199b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80199e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019a1:	48 63 c8             	movslq %eax,%rcx
  8019a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ab:	48 98                	cltq   
  8019ad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b4:	00 
  8019b5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019bb:	49 89 c8             	mov    %rcx,%r8
  8019be:	48 89 d1             	mov    %rdx,%rcx
  8019c1:	48 89 c2             	mov    %rax,%rdx
  8019c4:	be 01 00 00 00       	mov    $0x1,%esi
  8019c9:	bf 04 00 00 00       	mov    $0x4,%edi
  8019ce:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  8019d5:	00 00 00 
  8019d8:	ff d0                	callq  *%rax
}
  8019da:	c9                   	leaveq 
  8019db:	c3                   	retq   

00000000008019dc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019dc:	55                   	push   %rbp
  8019dd:	48 89 e5             	mov    %rsp,%rbp
  8019e0:	48 83 ec 30          	sub    $0x30,%rsp
  8019e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019eb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019ee:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019f2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019f6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019f9:	48 63 c8             	movslq %eax,%rcx
  8019fc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a00:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a03:	48 63 f0             	movslq %eax,%rsi
  801a06:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0d:	48 98                	cltq   
  801a0f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a13:	49 89 f9             	mov    %rdi,%r9
  801a16:	49 89 f0             	mov    %rsi,%r8
  801a19:	48 89 d1             	mov    %rdx,%rcx
  801a1c:	48 89 c2             	mov    %rax,%rdx
  801a1f:	be 01 00 00 00       	mov    $0x1,%esi
  801a24:	bf 05 00 00 00       	mov    $0x5,%edi
  801a29:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  801a30:	00 00 00 
  801a33:	ff d0                	callq  *%rax
}
  801a35:	c9                   	leaveq 
  801a36:	c3                   	retq   

0000000000801a37 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a37:	55                   	push   %rbp
  801a38:	48 89 e5             	mov    %rsp,%rbp
  801a3b:	48 83 ec 20          	sub    $0x20,%rsp
  801a3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a42:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a46:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a4d:	48 98                	cltq   
  801a4f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a56:	00 
  801a57:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a63:	48 89 d1             	mov    %rdx,%rcx
  801a66:	48 89 c2             	mov    %rax,%rdx
  801a69:	be 01 00 00 00       	mov    $0x1,%esi
  801a6e:	bf 06 00 00 00       	mov    $0x6,%edi
  801a73:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  801a7a:	00 00 00 
  801a7d:	ff d0                	callq  *%rax
}
  801a7f:	c9                   	leaveq 
  801a80:	c3                   	retq   

0000000000801a81 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a81:	55                   	push   %rbp
  801a82:	48 89 e5             	mov    %rsp,%rbp
  801a85:	48 83 ec 10          	sub    $0x10,%rsp
  801a89:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a8c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a92:	48 63 d0             	movslq %eax,%rdx
  801a95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a98:	48 98                	cltq   
  801a9a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa1:	00 
  801aa2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aae:	48 89 d1             	mov    %rdx,%rcx
  801ab1:	48 89 c2             	mov    %rax,%rdx
  801ab4:	be 01 00 00 00       	mov    $0x1,%esi
  801ab9:	bf 08 00 00 00       	mov    $0x8,%edi
  801abe:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  801ac5:	00 00 00 
  801ac8:	ff d0                	callq  *%rax
}
  801aca:	c9                   	leaveq 
  801acb:	c3                   	retq   

0000000000801acc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801acc:	55                   	push   %rbp
  801acd:	48 89 e5             	mov    %rsp,%rbp
  801ad0:	48 83 ec 20          	sub    $0x20,%rsp
  801ad4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ad7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801adb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801adf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae2:	48 98                	cltq   
  801ae4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aeb:	00 
  801aec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af8:	48 89 d1             	mov    %rdx,%rcx
  801afb:	48 89 c2             	mov    %rax,%rdx
  801afe:	be 01 00 00 00       	mov    $0x1,%esi
  801b03:	bf 09 00 00 00       	mov    $0x9,%edi
  801b08:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  801b0f:	00 00 00 
  801b12:	ff d0                	callq  *%rax
}
  801b14:	c9                   	leaveq 
  801b15:	c3                   	retq   

0000000000801b16 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b16:	55                   	push   %rbp
  801b17:	48 89 e5             	mov    %rsp,%rbp
  801b1a:	48 83 ec 20          	sub    $0x20,%rsp
  801b1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2c:	48 98                	cltq   
  801b2e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b35:	00 
  801b36:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b3c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b42:	48 89 d1             	mov    %rdx,%rcx
  801b45:	48 89 c2             	mov    %rax,%rdx
  801b48:	be 01 00 00 00       	mov    $0x1,%esi
  801b4d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b52:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  801b59:	00 00 00 
  801b5c:	ff d0                	callq  *%rax
}
  801b5e:	c9                   	leaveq 
  801b5f:	c3                   	retq   

0000000000801b60 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b60:	55                   	push   %rbp
  801b61:	48 89 e5             	mov    %rsp,%rbp
  801b64:	48 83 ec 20          	sub    $0x20,%rsp
  801b68:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b6b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b6f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b73:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b79:	48 63 f0             	movslq %eax,%rsi
  801b7c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b83:	48 98                	cltq   
  801b85:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b89:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b90:	00 
  801b91:	49 89 f1             	mov    %rsi,%r9
  801b94:	49 89 c8             	mov    %rcx,%r8
  801b97:	48 89 d1             	mov    %rdx,%rcx
  801b9a:	48 89 c2             	mov    %rax,%rdx
  801b9d:	be 00 00 00 00       	mov    $0x0,%esi
  801ba2:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ba7:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  801bae:	00 00 00 
  801bb1:	ff d0                	callq  *%rax
}
  801bb3:	c9                   	leaveq 
  801bb4:	c3                   	retq   

0000000000801bb5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bb5:	55                   	push   %rbp
  801bb6:	48 89 e5             	mov    %rsp,%rbp
  801bb9:	48 83 ec 10          	sub    $0x10,%rsp
  801bbd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bc5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bcc:	00 
  801bcd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bde:	48 89 c2             	mov    %rax,%rdx
  801be1:	be 01 00 00 00       	mov    $0x1,%esi
  801be6:	bf 0d 00 00 00       	mov    $0xd,%edi
  801beb:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  801bf2:	00 00 00 
  801bf5:	ff d0                	callq  *%rax
}
  801bf7:	c9                   	leaveq 
  801bf8:	c3                   	retq   

0000000000801bf9 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801bf9:	55                   	push   %rbp
  801bfa:	48 89 e5             	mov    %rsp,%rbp
  801bfd:	48 83 ec 10          	sub    $0x10,%rsp
  801c01:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  801c05:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801c0c:	00 00 00 
  801c0f:	48 8b 00             	mov    (%rax),%rax
  801c12:	48 85 c0             	test   %rax,%rax
  801c15:	75 3a                	jne    801c51 <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  801c17:	ba 07 00 00 00       	mov    $0x7,%edx
  801c1c:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801c21:	bf 00 00 00 00       	mov    $0x0,%edi
  801c26:	48 b8 8c 19 80 00 00 	movabs $0x80198c,%rax
  801c2d:	00 00 00 
  801c30:	ff d0                	callq  *%rax
  801c32:	85 c0                	test   %eax,%eax
  801c34:	75 1b                	jne    801c51 <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801c36:	48 be 64 1c 80 00 00 	movabs $0x801c64,%rsi
  801c3d:	00 00 00 
  801c40:	bf 00 00 00 00       	mov    $0x0,%edi
  801c45:	48 b8 16 1b 80 00 00 	movabs $0x801b16,%rax
  801c4c:	00 00 00 
  801c4f:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801c51:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801c58:	00 00 00 
  801c5b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c5f:	48 89 10             	mov    %rdx,(%rax)
}
  801c62:	c9                   	leaveq 
  801c63:	c3                   	retq   

0000000000801c64 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  801c64:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  801c67:	48 a1 10 60 80 00 00 	movabs 0x806010,%rax
  801c6e:	00 00 00 
	call *%rax
  801c71:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  801c73:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  801c76:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801c7d:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  801c7e:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  801c85:	00 
	pushq %rbx		// push utf_rip into new stack
  801c86:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  801c87:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  801c8e:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  801c91:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  801c95:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  801c99:	4c 8b 3c 24          	mov    (%rsp),%r15
  801c9d:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801ca2:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801ca7:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801cac:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801cb1:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801cb6:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801cbb:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801cc0:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801cc5:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801cca:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801ccf:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801cd4:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801cd9:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801cde:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801ce3:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  801ce7:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  801ceb:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  801cec:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801ced:	c3                   	retq   

0000000000801cee <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801cee:	55                   	push   %rbp
  801cef:	48 89 e5             	mov    %rsp,%rbp
  801cf2:	48 83 ec 08          	sub    $0x8,%rsp
  801cf6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801cfa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cfe:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d05:	ff ff ff 
  801d08:	48 01 d0             	add    %rdx,%rax
  801d0b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d0f:	c9                   	leaveq 
  801d10:	c3                   	retq   

0000000000801d11 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d11:	55                   	push   %rbp
  801d12:	48 89 e5             	mov    %rsp,%rbp
  801d15:	48 83 ec 08          	sub    $0x8,%rsp
  801d19:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d21:	48 89 c7             	mov    %rax,%rdi
  801d24:	48 b8 ee 1c 80 00 00 	movabs $0x801cee,%rax
  801d2b:	00 00 00 
  801d2e:	ff d0                	callq  *%rax
  801d30:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d36:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d3a:	c9                   	leaveq 
  801d3b:	c3                   	retq   

0000000000801d3c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d3c:	55                   	push   %rbp
  801d3d:	48 89 e5             	mov    %rsp,%rbp
  801d40:	48 83 ec 18          	sub    $0x18,%rsp
  801d44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d4f:	eb 6b                	jmp    801dbc <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d54:	48 98                	cltq   
  801d56:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d5c:	48 c1 e0 0c          	shl    $0xc,%rax
  801d60:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d68:	48 c1 e8 15          	shr    $0x15,%rax
  801d6c:	48 89 c2             	mov    %rax,%rdx
  801d6f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d76:	01 00 00 
  801d79:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d7d:	83 e0 01             	and    $0x1,%eax
  801d80:	48 85 c0             	test   %rax,%rax
  801d83:	74 21                	je     801da6 <fd_alloc+0x6a>
  801d85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d89:	48 c1 e8 0c          	shr    $0xc,%rax
  801d8d:	48 89 c2             	mov    %rax,%rdx
  801d90:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d97:	01 00 00 
  801d9a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d9e:	83 e0 01             	and    $0x1,%eax
  801da1:	48 85 c0             	test   %rax,%rax
  801da4:	75 12                	jne    801db8 <fd_alloc+0x7c>
			*fd_store = fd;
  801da6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801daa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dae:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801db1:	b8 00 00 00 00       	mov    $0x0,%eax
  801db6:	eb 1a                	jmp    801dd2 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801db8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dbc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801dc0:	7e 8f                	jle    801d51 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801dc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801dcd:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801dd2:	c9                   	leaveq 
  801dd3:	c3                   	retq   

0000000000801dd4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801dd4:	55                   	push   %rbp
  801dd5:	48 89 e5             	mov    %rsp,%rbp
  801dd8:	48 83 ec 20          	sub    $0x20,%rsp
  801ddc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ddf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801de3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801de7:	78 06                	js     801def <fd_lookup+0x1b>
  801de9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ded:	7e 07                	jle    801df6 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801def:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801df4:	eb 6c                	jmp    801e62 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801df6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801df9:	48 98                	cltq   
  801dfb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e01:	48 c1 e0 0c          	shl    $0xc,%rax
  801e05:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e0d:	48 c1 e8 15          	shr    $0x15,%rax
  801e11:	48 89 c2             	mov    %rax,%rdx
  801e14:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e1b:	01 00 00 
  801e1e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e22:	83 e0 01             	and    $0x1,%eax
  801e25:	48 85 c0             	test   %rax,%rax
  801e28:	74 21                	je     801e4b <fd_lookup+0x77>
  801e2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e2e:	48 c1 e8 0c          	shr    $0xc,%rax
  801e32:	48 89 c2             	mov    %rax,%rdx
  801e35:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e3c:	01 00 00 
  801e3f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e43:	83 e0 01             	and    $0x1,%eax
  801e46:	48 85 c0             	test   %rax,%rax
  801e49:	75 07                	jne    801e52 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e50:	eb 10                	jmp    801e62 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e56:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e5a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e62:	c9                   	leaveq 
  801e63:	c3                   	retq   

0000000000801e64 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e64:	55                   	push   %rbp
  801e65:	48 89 e5             	mov    %rsp,%rbp
  801e68:	48 83 ec 30          	sub    $0x30,%rsp
  801e6c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e70:	89 f0                	mov    %esi,%eax
  801e72:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e79:	48 89 c7             	mov    %rax,%rdi
  801e7c:	48 b8 ee 1c 80 00 00 	movabs $0x801cee,%rax
  801e83:	00 00 00 
  801e86:	ff d0                	callq  *%rax
  801e88:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e8c:	48 89 d6             	mov    %rdx,%rsi
  801e8f:	89 c7                	mov    %eax,%edi
  801e91:	48 b8 d4 1d 80 00 00 	movabs $0x801dd4,%rax
  801e98:	00 00 00 
  801e9b:	ff d0                	callq  *%rax
  801e9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ea0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ea4:	78 0a                	js     801eb0 <fd_close+0x4c>
	    || fd != fd2)
  801ea6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eaa:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801eae:	74 12                	je     801ec2 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801eb0:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801eb4:	74 05                	je     801ebb <fd_close+0x57>
  801eb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb9:	eb 05                	jmp    801ec0 <fd_close+0x5c>
  801ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec0:	eb 69                	jmp    801f2b <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ec2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec6:	8b 00                	mov    (%rax),%eax
  801ec8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ecc:	48 89 d6             	mov    %rdx,%rsi
  801ecf:	89 c7                	mov    %eax,%edi
  801ed1:	48 b8 2d 1f 80 00 00 	movabs $0x801f2d,%rax
  801ed8:	00 00 00 
  801edb:	ff d0                	callq  *%rax
  801edd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ee0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ee4:	78 2a                	js     801f10 <fd_close+0xac>
		if (dev->dev_close)
  801ee6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eea:	48 8b 40 20          	mov    0x20(%rax),%rax
  801eee:	48 85 c0             	test   %rax,%rax
  801ef1:	74 16                	je     801f09 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801ef3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef7:	48 8b 40 20          	mov    0x20(%rax),%rax
  801efb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801eff:	48 89 d7             	mov    %rdx,%rdi
  801f02:	ff d0                	callq  *%rax
  801f04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f07:	eb 07                	jmp    801f10 <fd_close+0xac>
		else
			r = 0;
  801f09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f14:	48 89 c6             	mov    %rax,%rsi
  801f17:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1c:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  801f23:	00 00 00 
  801f26:	ff d0                	callq  *%rax
	return r;
  801f28:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f2b:	c9                   	leaveq 
  801f2c:	c3                   	retq   

0000000000801f2d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f2d:	55                   	push   %rbp
  801f2e:	48 89 e5             	mov    %rsp,%rbp
  801f31:	48 83 ec 20          	sub    $0x20,%rsp
  801f35:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f38:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f43:	eb 41                	jmp    801f86 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f45:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f4c:	00 00 00 
  801f4f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f52:	48 63 d2             	movslq %edx,%rdx
  801f55:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f59:	8b 00                	mov    (%rax),%eax
  801f5b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f5e:	75 22                	jne    801f82 <dev_lookup+0x55>
			*dev = devtab[i];
  801f60:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f67:	00 00 00 
  801f6a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f6d:	48 63 d2             	movslq %edx,%rdx
  801f70:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f78:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f80:	eb 60                	jmp    801fe2 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f82:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f86:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f8d:	00 00 00 
  801f90:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f93:	48 63 d2             	movslq %edx,%rdx
  801f96:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f9a:	48 85 c0             	test   %rax,%rax
  801f9d:	75 a6                	jne    801f45 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f9f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801fa6:	00 00 00 
  801fa9:	48 8b 00             	mov    (%rax),%rax
  801fac:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fb2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fb5:	89 c6                	mov    %eax,%esi
  801fb7:	48 bf 90 3b 80 00 00 	movabs $0x803b90,%rdi
  801fbe:	00 00 00 
  801fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc6:	48 b9 b5 02 80 00 00 	movabs $0x8002b5,%rcx
  801fcd:	00 00 00 
  801fd0:	ff d1                	callq  *%rcx
	*dev = 0;
  801fd2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fd6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801fdd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801fe2:	c9                   	leaveq 
  801fe3:	c3                   	retq   

0000000000801fe4 <close>:

int
close(int fdnum)
{
  801fe4:	55                   	push   %rbp
  801fe5:	48 89 e5             	mov    %rsp,%rbp
  801fe8:	48 83 ec 20          	sub    $0x20,%rsp
  801fec:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fef:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ff3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ff6:	48 89 d6             	mov    %rdx,%rsi
  801ff9:	89 c7                	mov    %eax,%edi
  801ffb:	48 b8 d4 1d 80 00 00 	movabs $0x801dd4,%rax
  802002:	00 00 00 
  802005:	ff d0                	callq  *%rax
  802007:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80200a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80200e:	79 05                	jns    802015 <close+0x31>
		return r;
  802010:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802013:	eb 18                	jmp    80202d <close+0x49>
	else
		return fd_close(fd, 1);
  802015:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802019:	be 01 00 00 00       	mov    $0x1,%esi
  80201e:	48 89 c7             	mov    %rax,%rdi
  802021:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  802028:	00 00 00 
  80202b:	ff d0                	callq  *%rax
}
  80202d:	c9                   	leaveq 
  80202e:	c3                   	retq   

000000000080202f <close_all>:

void
close_all(void)
{
  80202f:	55                   	push   %rbp
  802030:	48 89 e5             	mov    %rsp,%rbp
  802033:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802037:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80203e:	eb 15                	jmp    802055 <close_all+0x26>
		close(i);
  802040:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802043:	89 c7                	mov    %eax,%edi
  802045:	48 b8 e4 1f 80 00 00 	movabs $0x801fe4,%rax
  80204c:	00 00 00 
  80204f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802051:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802055:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802059:	7e e5                	jle    802040 <close_all+0x11>
		close(i);
}
  80205b:	c9                   	leaveq 
  80205c:	c3                   	retq   

000000000080205d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80205d:	55                   	push   %rbp
  80205e:	48 89 e5             	mov    %rsp,%rbp
  802061:	48 83 ec 40          	sub    $0x40,%rsp
  802065:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802068:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80206b:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80206f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802072:	48 89 d6             	mov    %rdx,%rsi
  802075:	89 c7                	mov    %eax,%edi
  802077:	48 b8 d4 1d 80 00 00 	movabs $0x801dd4,%rax
  80207e:	00 00 00 
  802081:	ff d0                	callq  *%rax
  802083:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802086:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80208a:	79 08                	jns    802094 <dup+0x37>
		return r;
  80208c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80208f:	e9 70 01 00 00       	jmpq   802204 <dup+0x1a7>
	close(newfdnum);
  802094:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802097:	89 c7                	mov    %eax,%edi
  802099:	48 b8 e4 1f 80 00 00 	movabs $0x801fe4,%rax
  8020a0:	00 00 00 
  8020a3:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020a5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020a8:	48 98                	cltq   
  8020aa:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020b0:	48 c1 e0 0c          	shl    $0xc,%rax
  8020b4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020bc:	48 89 c7             	mov    %rax,%rdi
  8020bf:	48 b8 11 1d 80 00 00 	movabs $0x801d11,%rax
  8020c6:	00 00 00 
  8020c9:	ff d0                	callq  *%rax
  8020cb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8020cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d3:	48 89 c7             	mov    %rax,%rdi
  8020d6:	48 b8 11 1d 80 00 00 	movabs $0x801d11,%rax
  8020dd:	00 00 00 
  8020e0:	ff d0                	callq  *%rax
  8020e2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ea:	48 c1 e8 15          	shr    $0x15,%rax
  8020ee:	48 89 c2             	mov    %rax,%rdx
  8020f1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020f8:	01 00 00 
  8020fb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ff:	83 e0 01             	and    $0x1,%eax
  802102:	48 85 c0             	test   %rax,%rax
  802105:	74 73                	je     80217a <dup+0x11d>
  802107:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80210b:	48 c1 e8 0c          	shr    $0xc,%rax
  80210f:	48 89 c2             	mov    %rax,%rdx
  802112:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802119:	01 00 00 
  80211c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802120:	83 e0 01             	and    $0x1,%eax
  802123:	48 85 c0             	test   %rax,%rax
  802126:	74 52                	je     80217a <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802128:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80212c:	48 c1 e8 0c          	shr    $0xc,%rax
  802130:	48 89 c2             	mov    %rax,%rdx
  802133:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80213a:	01 00 00 
  80213d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802141:	25 07 0e 00 00       	and    $0xe07,%eax
  802146:	89 c1                	mov    %eax,%ecx
  802148:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80214c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802150:	41 89 c8             	mov    %ecx,%r8d
  802153:	48 89 d1             	mov    %rdx,%rcx
  802156:	ba 00 00 00 00       	mov    $0x0,%edx
  80215b:	48 89 c6             	mov    %rax,%rsi
  80215e:	bf 00 00 00 00       	mov    $0x0,%edi
  802163:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  80216a:	00 00 00 
  80216d:	ff d0                	callq  *%rax
  80216f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802172:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802176:	79 02                	jns    80217a <dup+0x11d>
			goto err;
  802178:	eb 57                	jmp    8021d1 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80217a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80217e:	48 c1 e8 0c          	shr    $0xc,%rax
  802182:	48 89 c2             	mov    %rax,%rdx
  802185:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80218c:	01 00 00 
  80218f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802193:	25 07 0e 00 00       	and    $0xe07,%eax
  802198:	89 c1                	mov    %eax,%ecx
  80219a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80219e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021a2:	41 89 c8             	mov    %ecx,%r8d
  8021a5:	48 89 d1             	mov    %rdx,%rcx
  8021a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ad:	48 89 c6             	mov    %rax,%rsi
  8021b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b5:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  8021bc:	00 00 00 
  8021bf:	ff d0                	callq  *%rax
  8021c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021c8:	79 02                	jns    8021cc <dup+0x16f>
		goto err;
  8021ca:	eb 05                	jmp    8021d1 <dup+0x174>

	return newfdnum;
  8021cc:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021cf:	eb 33                	jmp    802204 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8021d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021d5:	48 89 c6             	mov    %rax,%rsi
  8021d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8021dd:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  8021e4:	00 00 00 
  8021e7:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8021e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021ed:	48 89 c6             	mov    %rax,%rsi
  8021f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8021f5:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  8021fc:	00 00 00 
  8021ff:	ff d0                	callq  *%rax
	return r;
  802201:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802204:	c9                   	leaveq 
  802205:	c3                   	retq   

0000000000802206 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802206:	55                   	push   %rbp
  802207:	48 89 e5             	mov    %rsp,%rbp
  80220a:	48 83 ec 40          	sub    $0x40,%rsp
  80220e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802211:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802215:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802219:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80221d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802220:	48 89 d6             	mov    %rdx,%rsi
  802223:	89 c7                	mov    %eax,%edi
  802225:	48 b8 d4 1d 80 00 00 	movabs $0x801dd4,%rax
  80222c:	00 00 00 
  80222f:	ff d0                	callq  *%rax
  802231:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802234:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802238:	78 24                	js     80225e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80223a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223e:	8b 00                	mov    (%rax),%eax
  802240:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802244:	48 89 d6             	mov    %rdx,%rsi
  802247:	89 c7                	mov    %eax,%edi
  802249:	48 b8 2d 1f 80 00 00 	movabs $0x801f2d,%rax
  802250:	00 00 00 
  802253:	ff d0                	callq  *%rax
  802255:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802258:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80225c:	79 05                	jns    802263 <read+0x5d>
		return r;
  80225e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802261:	eb 76                	jmp    8022d9 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802263:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802267:	8b 40 08             	mov    0x8(%rax),%eax
  80226a:	83 e0 03             	and    $0x3,%eax
  80226d:	83 f8 01             	cmp    $0x1,%eax
  802270:	75 3a                	jne    8022ac <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802272:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802279:	00 00 00 
  80227c:	48 8b 00             	mov    (%rax),%rax
  80227f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802285:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802288:	89 c6                	mov    %eax,%esi
  80228a:	48 bf af 3b 80 00 00 	movabs $0x803baf,%rdi
  802291:	00 00 00 
  802294:	b8 00 00 00 00       	mov    $0x0,%eax
  802299:	48 b9 b5 02 80 00 00 	movabs $0x8002b5,%rcx
  8022a0:	00 00 00 
  8022a3:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022aa:	eb 2d                	jmp    8022d9 <read+0xd3>
	}
	if (!dev->dev_read)
  8022ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022b0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022b4:	48 85 c0             	test   %rax,%rax
  8022b7:	75 07                	jne    8022c0 <read+0xba>
		return -E_NOT_SUPP;
  8022b9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022be:	eb 19                	jmp    8022d9 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8022c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022c4:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022c8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022cc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022d0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022d4:	48 89 cf             	mov    %rcx,%rdi
  8022d7:	ff d0                	callq  *%rax
}
  8022d9:	c9                   	leaveq 
  8022da:	c3                   	retq   

00000000008022db <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022db:	55                   	push   %rbp
  8022dc:	48 89 e5             	mov    %rsp,%rbp
  8022df:	48 83 ec 30          	sub    $0x30,%rsp
  8022e3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022f5:	eb 49                	jmp    802340 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022fa:	48 98                	cltq   
  8022fc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802300:	48 29 c2             	sub    %rax,%rdx
  802303:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802306:	48 63 c8             	movslq %eax,%rcx
  802309:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80230d:	48 01 c1             	add    %rax,%rcx
  802310:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802313:	48 89 ce             	mov    %rcx,%rsi
  802316:	89 c7                	mov    %eax,%edi
  802318:	48 b8 06 22 80 00 00 	movabs $0x802206,%rax
  80231f:	00 00 00 
  802322:	ff d0                	callq  *%rax
  802324:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802327:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80232b:	79 05                	jns    802332 <readn+0x57>
			return m;
  80232d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802330:	eb 1c                	jmp    80234e <readn+0x73>
		if (m == 0)
  802332:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802336:	75 02                	jne    80233a <readn+0x5f>
			break;
  802338:	eb 11                	jmp    80234b <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80233a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80233d:	01 45 fc             	add    %eax,-0x4(%rbp)
  802340:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802343:	48 98                	cltq   
  802345:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802349:	72 ac                	jb     8022f7 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80234b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80234e:	c9                   	leaveq 
  80234f:	c3                   	retq   

0000000000802350 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802350:	55                   	push   %rbp
  802351:	48 89 e5             	mov    %rsp,%rbp
  802354:	48 83 ec 40          	sub    $0x40,%rsp
  802358:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80235b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80235f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802363:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802367:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80236a:	48 89 d6             	mov    %rdx,%rsi
  80236d:	89 c7                	mov    %eax,%edi
  80236f:	48 b8 d4 1d 80 00 00 	movabs $0x801dd4,%rax
  802376:	00 00 00 
  802379:	ff d0                	callq  *%rax
  80237b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80237e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802382:	78 24                	js     8023a8 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802384:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802388:	8b 00                	mov    (%rax),%eax
  80238a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80238e:	48 89 d6             	mov    %rdx,%rsi
  802391:	89 c7                	mov    %eax,%edi
  802393:	48 b8 2d 1f 80 00 00 	movabs $0x801f2d,%rax
  80239a:	00 00 00 
  80239d:	ff d0                	callq  *%rax
  80239f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a6:	79 05                	jns    8023ad <write+0x5d>
		return r;
  8023a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ab:	eb 75                	jmp    802422 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b1:	8b 40 08             	mov    0x8(%rax),%eax
  8023b4:	83 e0 03             	and    $0x3,%eax
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	75 3a                	jne    8023f5 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023bb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8023c2:	00 00 00 
  8023c5:	48 8b 00             	mov    (%rax),%rax
  8023c8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023ce:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023d1:	89 c6                	mov    %eax,%esi
  8023d3:	48 bf cb 3b 80 00 00 	movabs $0x803bcb,%rdi
  8023da:	00 00 00 
  8023dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e2:	48 b9 b5 02 80 00 00 	movabs $0x8002b5,%rcx
  8023e9:	00 00 00 
  8023ec:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023f3:	eb 2d                	jmp    802422 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8023f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023fd:	48 85 c0             	test   %rax,%rax
  802400:	75 07                	jne    802409 <write+0xb9>
		return -E_NOT_SUPP;
  802402:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802407:	eb 19                	jmp    802422 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802409:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80240d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802411:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802415:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802419:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80241d:	48 89 cf             	mov    %rcx,%rdi
  802420:	ff d0                	callq  *%rax
}
  802422:	c9                   	leaveq 
  802423:	c3                   	retq   

0000000000802424 <seek>:

int
seek(int fdnum, off_t offset)
{
  802424:	55                   	push   %rbp
  802425:	48 89 e5             	mov    %rsp,%rbp
  802428:	48 83 ec 18          	sub    $0x18,%rsp
  80242c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80242f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802432:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802436:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802439:	48 89 d6             	mov    %rdx,%rsi
  80243c:	89 c7                	mov    %eax,%edi
  80243e:	48 b8 d4 1d 80 00 00 	movabs $0x801dd4,%rax
  802445:	00 00 00 
  802448:	ff d0                	callq  *%rax
  80244a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80244d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802451:	79 05                	jns    802458 <seek+0x34>
		return r;
  802453:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802456:	eb 0f                	jmp    802467 <seek+0x43>
	fd->fd_offset = offset;
  802458:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80245c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80245f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802462:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802467:	c9                   	leaveq 
  802468:	c3                   	retq   

0000000000802469 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802469:	55                   	push   %rbp
  80246a:	48 89 e5             	mov    %rsp,%rbp
  80246d:	48 83 ec 30          	sub    $0x30,%rsp
  802471:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802474:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802477:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80247b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80247e:	48 89 d6             	mov    %rdx,%rsi
  802481:	89 c7                	mov    %eax,%edi
  802483:	48 b8 d4 1d 80 00 00 	movabs $0x801dd4,%rax
  80248a:	00 00 00 
  80248d:	ff d0                	callq  *%rax
  80248f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802492:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802496:	78 24                	js     8024bc <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802498:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80249c:	8b 00                	mov    (%rax),%eax
  80249e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024a2:	48 89 d6             	mov    %rdx,%rsi
  8024a5:	89 c7                	mov    %eax,%edi
  8024a7:	48 b8 2d 1f 80 00 00 	movabs $0x801f2d,%rax
  8024ae:	00 00 00 
  8024b1:	ff d0                	callq  *%rax
  8024b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ba:	79 05                	jns    8024c1 <ftruncate+0x58>
		return r;
  8024bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024bf:	eb 72                	jmp    802533 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c5:	8b 40 08             	mov    0x8(%rax),%eax
  8024c8:	83 e0 03             	and    $0x3,%eax
  8024cb:	85 c0                	test   %eax,%eax
  8024cd:	75 3a                	jne    802509 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024cf:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8024d6:	00 00 00 
  8024d9:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8024dc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024e2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024e5:	89 c6                	mov    %eax,%esi
  8024e7:	48 bf e8 3b 80 00 00 	movabs $0x803be8,%rdi
  8024ee:	00 00 00 
  8024f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f6:	48 b9 b5 02 80 00 00 	movabs $0x8002b5,%rcx
  8024fd:	00 00 00 
  802500:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802502:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802507:	eb 2a                	jmp    802533 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802509:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80250d:	48 8b 40 30          	mov    0x30(%rax),%rax
  802511:	48 85 c0             	test   %rax,%rax
  802514:	75 07                	jne    80251d <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802516:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80251b:	eb 16                	jmp    802533 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80251d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802521:	48 8b 40 30          	mov    0x30(%rax),%rax
  802525:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802529:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80252c:	89 ce                	mov    %ecx,%esi
  80252e:	48 89 d7             	mov    %rdx,%rdi
  802531:	ff d0                	callq  *%rax
}
  802533:	c9                   	leaveq 
  802534:	c3                   	retq   

0000000000802535 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802535:	55                   	push   %rbp
  802536:	48 89 e5             	mov    %rsp,%rbp
  802539:	48 83 ec 30          	sub    $0x30,%rsp
  80253d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802540:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802544:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802548:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80254b:	48 89 d6             	mov    %rdx,%rsi
  80254e:	89 c7                	mov    %eax,%edi
  802550:	48 b8 d4 1d 80 00 00 	movabs $0x801dd4,%rax
  802557:	00 00 00 
  80255a:	ff d0                	callq  *%rax
  80255c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80255f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802563:	78 24                	js     802589 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802565:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802569:	8b 00                	mov    (%rax),%eax
  80256b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80256f:	48 89 d6             	mov    %rdx,%rsi
  802572:	89 c7                	mov    %eax,%edi
  802574:	48 b8 2d 1f 80 00 00 	movabs $0x801f2d,%rax
  80257b:	00 00 00 
  80257e:	ff d0                	callq  *%rax
  802580:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802583:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802587:	79 05                	jns    80258e <fstat+0x59>
		return r;
  802589:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258c:	eb 5e                	jmp    8025ec <fstat+0xb7>
	if (!dev->dev_stat)
  80258e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802592:	48 8b 40 28          	mov    0x28(%rax),%rax
  802596:	48 85 c0             	test   %rax,%rax
  802599:	75 07                	jne    8025a2 <fstat+0x6d>
		return -E_NOT_SUPP;
  80259b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025a0:	eb 4a                	jmp    8025ec <fstat+0xb7>
	stat->st_name[0] = 0;
  8025a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025a6:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025ad:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025b4:	00 00 00 
	stat->st_isdir = 0;
  8025b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025bb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025c2:	00 00 00 
	stat->st_dev = dev;
  8025c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025cd:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8025d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d8:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025e0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8025e4:	48 89 ce             	mov    %rcx,%rsi
  8025e7:	48 89 d7             	mov    %rdx,%rdi
  8025ea:	ff d0                	callq  *%rax
}
  8025ec:	c9                   	leaveq 
  8025ed:	c3                   	retq   

00000000008025ee <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8025ee:	55                   	push   %rbp
  8025ef:	48 89 e5             	mov    %rsp,%rbp
  8025f2:	48 83 ec 20          	sub    $0x20,%rsp
  8025f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8025fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802602:	be 00 00 00 00       	mov    $0x0,%esi
  802607:	48 89 c7             	mov    %rax,%rdi
  80260a:	48 b8 dc 26 80 00 00 	movabs $0x8026dc,%rax
  802611:	00 00 00 
  802614:	ff d0                	callq  *%rax
  802616:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802619:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80261d:	79 05                	jns    802624 <stat+0x36>
		return fd;
  80261f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802622:	eb 2f                	jmp    802653 <stat+0x65>
	r = fstat(fd, stat);
  802624:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802628:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262b:	48 89 d6             	mov    %rdx,%rsi
  80262e:	89 c7                	mov    %eax,%edi
  802630:	48 b8 35 25 80 00 00 	movabs $0x802535,%rax
  802637:	00 00 00 
  80263a:	ff d0                	callq  *%rax
  80263c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80263f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802642:	89 c7                	mov    %eax,%edi
  802644:	48 b8 e4 1f 80 00 00 	movabs $0x801fe4,%rax
  80264b:	00 00 00 
  80264e:	ff d0                	callq  *%rax
	return r;
  802650:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802653:	c9                   	leaveq 
  802654:	c3                   	retq   

0000000000802655 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802655:	55                   	push   %rbp
  802656:	48 89 e5             	mov    %rsp,%rbp
  802659:	48 83 ec 10          	sub    $0x10,%rsp
  80265d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802660:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802664:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  80266b:	00 00 00 
  80266e:	8b 00                	mov    (%rax),%eax
  802670:	85 c0                	test   %eax,%eax
  802672:	75 1d                	jne    802691 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802674:	bf 01 00 00 00       	mov    $0x1,%edi
  802679:	48 b8 5f 35 80 00 00 	movabs $0x80355f,%rax
  802680:	00 00 00 
  802683:	ff d0                	callq  *%rax
  802685:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  80268c:	00 00 00 
  80268f:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802691:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802698:	00 00 00 
  80269b:	8b 00                	mov    (%rax),%eax
  80269d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026a0:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026a5:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8026ac:	00 00 00 
  8026af:	89 c7                	mov    %eax,%edi
  8026b1:	48 b8 c7 34 80 00 00 	movabs $0x8034c7,%rax
  8026b8:	00 00 00 
  8026bb:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8026c6:	48 89 c6             	mov    %rax,%rsi
  8026c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ce:	48 b8 fe 33 80 00 00 	movabs $0x8033fe,%rax
  8026d5:	00 00 00 
  8026d8:	ff d0                	callq  *%rax
}
  8026da:	c9                   	leaveq 
  8026db:	c3                   	retq   

00000000008026dc <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8026dc:	55                   	push   %rbp
  8026dd:	48 89 e5             	mov    %rsp,%rbp
  8026e0:	48 83 ec 20          	sub    $0x20,%rsp
  8026e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026e8:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  8026eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ef:	48 89 c7             	mov    %rax,%rdi
  8026f2:	48 b8 f1 0f 80 00 00 	movabs $0x800ff1,%rax
  8026f9:	00 00 00 
  8026fc:	ff d0                	callq  *%rax
  8026fe:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802703:	7e 0a                	jle    80270f <open+0x33>
		return -E_BAD_PATH;
  802705:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80270a:	e9 a5 00 00 00       	jmpq   8027b4 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80270f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802713:	48 89 c7             	mov    %rax,%rdi
  802716:	48 b8 3c 1d 80 00 00 	movabs $0x801d3c,%rax
  80271d:	00 00 00 
  802720:	ff d0                	callq  *%rax
  802722:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802725:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802729:	79 08                	jns    802733 <open+0x57>
		return r;
  80272b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80272e:	e9 81 00 00 00       	jmpq   8027b4 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802737:	48 89 c6             	mov    %rax,%rsi
  80273a:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802741:	00 00 00 
  802744:	48 b8 5d 10 80 00 00 	movabs $0x80105d,%rax
  80274b:	00 00 00 
  80274e:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802750:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802757:	00 00 00 
  80275a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80275d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802763:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802767:	48 89 c6             	mov    %rax,%rsi
  80276a:	bf 01 00 00 00       	mov    $0x1,%edi
  80276f:	48 b8 55 26 80 00 00 	movabs $0x802655,%rax
  802776:	00 00 00 
  802779:	ff d0                	callq  *%rax
  80277b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802782:	79 1d                	jns    8027a1 <open+0xc5>
		fd_close(fd, 0);
  802784:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802788:	be 00 00 00 00       	mov    $0x0,%esi
  80278d:	48 89 c7             	mov    %rax,%rdi
  802790:	48 b8 64 1e 80 00 00 	movabs $0x801e64,%rax
  802797:	00 00 00 
  80279a:	ff d0                	callq  *%rax
		return r;
  80279c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80279f:	eb 13                	jmp    8027b4 <open+0xd8>
	}

	return fd2num(fd);
  8027a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027a5:	48 89 c7             	mov    %rax,%rdi
  8027a8:	48 b8 ee 1c 80 00 00 	movabs $0x801cee,%rax
  8027af:	00 00 00 
  8027b2:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  8027b4:	c9                   	leaveq 
  8027b5:	c3                   	retq   

00000000008027b6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8027b6:	55                   	push   %rbp
  8027b7:	48 89 e5             	mov    %rsp,%rbp
  8027ba:	48 83 ec 10          	sub    $0x10,%rsp
  8027be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8027c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027c6:	8b 50 0c             	mov    0xc(%rax),%edx
  8027c9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027d0:	00 00 00 
  8027d3:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8027d5:	be 00 00 00 00       	mov    $0x0,%esi
  8027da:	bf 06 00 00 00       	mov    $0x6,%edi
  8027df:	48 b8 55 26 80 00 00 	movabs $0x802655,%rax
  8027e6:	00 00 00 
  8027e9:	ff d0                	callq  *%rax
}
  8027eb:	c9                   	leaveq 
  8027ec:	c3                   	retq   

00000000008027ed <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8027ed:	55                   	push   %rbp
  8027ee:	48 89 e5             	mov    %rsp,%rbp
  8027f1:	48 83 ec 30          	sub    $0x30,%rsp
  8027f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802801:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802805:	8b 50 0c             	mov    0xc(%rax),%edx
  802808:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80280f:	00 00 00 
  802812:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802814:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80281b:	00 00 00 
  80281e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802822:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802826:	be 00 00 00 00       	mov    $0x0,%esi
  80282b:	bf 03 00 00 00       	mov    $0x3,%edi
  802830:	48 b8 55 26 80 00 00 	movabs $0x802655,%rax
  802837:	00 00 00 
  80283a:	ff d0                	callq  *%rax
  80283c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80283f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802843:	79 05                	jns    80284a <devfile_read+0x5d>
		return r;
  802845:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802848:	eb 26                	jmp    802870 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80284a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80284d:	48 63 d0             	movslq %eax,%rdx
  802850:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802854:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80285b:	00 00 00 
  80285e:	48 89 c7             	mov    %rax,%rdi
  802861:	48 b8 81 13 80 00 00 	movabs $0x801381,%rax
  802868:	00 00 00 
  80286b:	ff d0                	callq  *%rax

	return r;
  80286d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802870:	c9                   	leaveq 
  802871:	c3                   	retq   

0000000000802872 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802872:	55                   	push   %rbp
  802873:	48 89 e5             	mov    %rsp,%rbp
  802876:	48 83 ec 30          	sub    $0x30,%rsp
  80287a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80287e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802882:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802886:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80288d:	00 
  80288e:	76 08                	jbe    802898 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802890:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802897:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289c:	8b 50 0c             	mov    0xc(%rax),%edx
  80289f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028a6:	00 00 00 
  8028a9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8028ab:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028b2:	00 00 00 
  8028b5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028b9:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  8028bd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028c5:	48 89 c6             	mov    %rax,%rsi
  8028c8:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8028cf:	00 00 00 
  8028d2:	48 b8 81 13 80 00 00 	movabs $0x801381,%rax
  8028d9:	00 00 00 
  8028dc:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8028de:	be 00 00 00 00       	mov    $0x0,%esi
  8028e3:	bf 04 00 00 00       	mov    $0x4,%edi
  8028e8:	48 b8 55 26 80 00 00 	movabs $0x802655,%rax
  8028ef:	00 00 00 
  8028f2:	ff d0                	callq  *%rax
  8028f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028fb:	79 05                	jns    802902 <devfile_write+0x90>
		return r;
  8028fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802900:	eb 03                	jmp    802905 <devfile_write+0x93>

	return r;
  802902:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802905:	c9                   	leaveq 
  802906:	c3                   	retq   

0000000000802907 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802907:	55                   	push   %rbp
  802908:	48 89 e5             	mov    %rsp,%rbp
  80290b:	48 83 ec 20          	sub    $0x20,%rsp
  80290f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802913:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80291b:	8b 50 0c             	mov    0xc(%rax),%edx
  80291e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802925:	00 00 00 
  802928:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80292a:	be 00 00 00 00       	mov    $0x0,%esi
  80292f:	bf 05 00 00 00       	mov    $0x5,%edi
  802934:	48 b8 55 26 80 00 00 	movabs $0x802655,%rax
  80293b:	00 00 00 
  80293e:	ff d0                	callq  *%rax
  802940:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802943:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802947:	79 05                	jns    80294e <devfile_stat+0x47>
		return r;
  802949:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80294c:	eb 56                	jmp    8029a4 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80294e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802952:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802959:	00 00 00 
  80295c:	48 89 c7             	mov    %rax,%rdi
  80295f:	48 b8 5d 10 80 00 00 	movabs $0x80105d,%rax
  802966:	00 00 00 
  802969:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80296b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802972:	00 00 00 
  802975:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80297b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80297f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802985:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80298c:	00 00 00 
  80298f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802995:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802999:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80299f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029a4:	c9                   	leaveq 
  8029a5:	c3                   	retq   

00000000008029a6 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8029a6:	55                   	push   %rbp
  8029a7:	48 89 e5             	mov    %rsp,%rbp
  8029aa:	48 83 ec 10          	sub    $0x10,%rsp
  8029ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8029b2:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8029b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029b9:	8b 50 0c             	mov    0xc(%rax),%edx
  8029bc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029c3:	00 00 00 
  8029c6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8029c8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029cf:	00 00 00 
  8029d2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8029d5:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8029d8:	be 00 00 00 00       	mov    $0x0,%esi
  8029dd:	bf 02 00 00 00       	mov    $0x2,%edi
  8029e2:	48 b8 55 26 80 00 00 	movabs $0x802655,%rax
  8029e9:	00 00 00 
  8029ec:	ff d0                	callq  *%rax
}
  8029ee:	c9                   	leaveq 
  8029ef:	c3                   	retq   

00000000008029f0 <remove>:

// Delete a file
int
remove(const char *path)
{
  8029f0:	55                   	push   %rbp
  8029f1:	48 89 e5             	mov    %rsp,%rbp
  8029f4:	48 83 ec 10          	sub    $0x10,%rsp
  8029f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8029fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a00:	48 89 c7             	mov    %rax,%rdi
  802a03:	48 b8 f1 0f 80 00 00 	movabs $0x800ff1,%rax
  802a0a:	00 00 00 
  802a0d:	ff d0                	callq  *%rax
  802a0f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a14:	7e 07                	jle    802a1d <remove+0x2d>
		return -E_BAD_PATH;
  802a16:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a1b:	eb 33                	jmp    802a50 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802a1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a21:	48 89 c6             	mov    %rax,%rsi
  802a24:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802a2b:	00 00 00 
  802a2e:	48 b8 5d 10 80 00 00 	movabs $0x80105d,%rax
  802a35:	00 00 00 
  802a38:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802a3a:	be 00 00 00 00       	mov    $0x0,%esi
  802a3f:	bf 07 00 00 00       	mov    $0x7,%edi
  802a44:	48 b8 55 26 80 00 00 	movabs $0x802655,%rax
  802a4b:	00 00 00 
  802a4e:	ff d0                	callq  *%rax
}
  802a50:	c9                   	leaveq 
  802a51:	c3                   	retq   

0000000000802a52 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802a52:	55                   	push   %rbp
  802a53:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802a56:	be 00 00 00 00       	mov    $0x0,%esi
  802a5b:	bf 08 00 00 00       	mov    $0x8,%edi
  802a60:	48 b8 55 26 80 00 00 	movabs $0x802655,%rax
  802a67:	00 00 00 
  802a6a:	ff d0                	callq  *%rax
}
  802a6c:	5d                   	pop    %rbp
  802a6d:	c3                   	retq   

0000000000802a6e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802a6e:	55                   	push   %rbp
  802a6f:	48 89 e5             	mov    %rsp,%rbp
  802a72:	53                   	push   %rbx
  802a73:	48 83 ec 38          	sub    $0x38,%rsp
  802a77:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802a7b:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802a7f:	48 89 c7             	mov    %rax,%rdi
  802a82:	48 b8 3c 1d 80 00 00 	movabs $0x801d3c,%rax
  802a89:	00 00 00 
  802a8c:	ff d0                	callq  *%rax
  802a8e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a91:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a95:	0f 88 bf 01 00 00    	js     802c5a <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a9f:	ba 07 04 00 00       	mov    $0x407,%edx
  802aa4:	48 89 c6             	mov    %rax,%rsi
  802aa7:	bf 00 00 00 00       	mov    $0x0,%edi
  802aac:	48 b8 8c 19 80 00 00 	movabs $0x80198c,%rax
  802ab3:	00 00 00 
  802ab6:	ff d0                	callq  *%rax
  802ab8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802abb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802abf:	0f 88 95 01 00 00    	js     802c5a <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802ac5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802ac9:	48 89 c7             	mov    %rax,%rdi
  802acc:	48 b8 3c 1d 80 00 00 	movabs $0x801d3c,%rax
  802ad3:	00 00 00 
  802ad6:	ff d0                	callq  *%rax
  802ad8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802adb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802adf:	0f 88 5d 01 00 00    	js     802c42 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ae5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ae9:	ba 07 04 00 00       	mov    $0x407,%edx
  802aee:	48 89 c6             	mov    %rax,%rsi
  802af1:	bf 00 00 00 00       	mov    $0x0,%edi
  802af6:	48 b8 8c 19 80 00 00 	movabs $0x80198c,%rax
  802afd:	00 00 00 
  802b00:	ff d0                	callq  *%rax
  802b02:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b05:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b09:	0f 88 33 01 00 00    	js     802c42 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802b0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b13:	48 89 c7             	mov    %rax,%rdi
  802b16:	48 b8 11 1d 80 00 00 	movabs $0x801d11,%rax
  802b1d:	00 00 00 
  802b20:	ff d0                	callq  *%rax
  802b22:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b2a:	ba 07 04 00 00       	mov    $0x407,%edx
  802b2f:	48 89 c6             	mov    %rax,%rsi
  802b32:	bf 00 00 00 00       	mov    $0x0,%edi
  802b37:	48 b8 8c 19 80 00 00 	movabs $0x80198c,%rax
  802b3e:	00 00 00 
  802b41:	ff d0                	callq  *%rax
  802b43:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b46:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b4a:	79 05                	jns    802b51 <pipe+0xe3>
		goto err2;
  802b4c:	e9 d9 00 00 00       	jmpq   802c2a <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b51:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b55:	48 89 c7             	mov    %rax,%rdi
  802b58:	48 b8 11 1d 80 00 00 	movabs $0x801d11,%rax
  802b5f:	00 00 00 
  802b62:	ff d0                	callq  *%rax
  802b64:	48 89 c2             	mov    %rax,%rdx
  802b67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b6b:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802b71:	48 89 d1             	mov    %rdx,%rcx
  802b74:	ba 00 00 00 00       	mov    $0x0,%edx
  802b79:	48 89 c6             	mov    %rax,%rsi
  802b7c:	bf 00 00 00 00       	mov    $0x0,%edi
  802b81:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  802b88:	00 00 00 
  802b8b:	ff d0                	callq  *%rax
  802b8d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b90:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b94:	79 1b                	jns    802bb1 <pipe+0x143>
		goto err3;
  802b96:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  802b97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b9b:	48 89 c6             	mov    %rax,%rsi
  802b9e:	bf 00 00 00 00       	mov    $0x0,%edi
  802ba3:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  802baa:	00 00 00 
  802bad:	ff d0                	callq  *%rax
  802baf:	eb 79                	jmp    802c2a <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802bb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bb5:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802bbc:	00 00 00 
  802bbf:	8b 12                	mov    (%rdx),%edx
  802bc1:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802bc3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bc7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802bce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bd2:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802bd9:	00 00 00 
  802bdc:	8b 12                	mov    (%rdx),%edx
  802bde:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802be0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802be4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802beb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bef:	48 89 c7             	mov    %rax,%rdi
  802bf2:	48 b8 ee 1c 80 00 00 	movabs $0x801cee,%rax
  802bf9:	00 00 00 
  802bfc:	ff d0                	callq  *%rax
  802bfe:	89 c2                	mov    %eax,%edx
  802c00:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c04:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802c06:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c0a:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802c0e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c12:	48 89 c7             	mov    %rax,%rdi
  802c15:	48 b8 ee 1c 80 00 00 	movabs $0x801cee,%rax
  802c1c:	00 00 00 
  802c1f:	ff d0                	callq  *%rax
  802c21:	89 03                	mov    %eax,(%rbx)
	return 0;
  802c23:	b8 00 00 00 00       	mov    $0x0,%eax
  802c28:	eb 33                	jmp    802c5d <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  802c2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c2e:	48 89 c6             	mov    %rax,%rsi
  802c31:	bf 00 00 00 00       	mov    $0x0,%edi
  802c36:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  802c3d:	00 00 00 
  802c40:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  802c42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c46:	48 89 c6             	mov    %rax,%rsi
  802c49:	bf 00 00 00 00       	mov    $0x0,%edi
  802c4e:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  802c55:	00 00 00 
  802c58:	ff d0                	callq  *%rax
    err:
	return r;
  802c5a:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802c5d:	48 83 c4 38          	add    $0x38,%rsp
  802c61:	5b                   	pop    %rbx
  802c62:	5d                   	pop    %rbp
  802c63:	c3                   	retq   

0000000000802c64 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802c64:	55                   	push   %rbp
  802c65:	48 89 e5             	mov    %rsp,%rbp
  802c68:	53                   	push   %rbx
  802c69:	48 83 ec 28          	sub    $0x28,%rsp
  802c6d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c71:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802c75:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c7c:	00 00 00 
  802c7f:	48 8b 00             	mov    (%rax),%rax
  802c82:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802c88:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802c8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c8f:	48 89 c7             	mov    %rax,%rdi
  802c92:	48 b8 e1 35 80 00 00 	movabs $0x8035e1,%rax
  802c99:	00 00 00 
  802c9c:	ff d0                	callq  *%rax
  802c9e:	89 c3                	mov    %eax,%ebx
  802ca0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ca4:	48 89 c7             	mov    %rax,%rdi
  802ca7:	48 b8 e1 35 80 00 00 	movabs $0x8035e1,%rax
  802cae:	00 00 00 
  802cb1:	ff d0                	callq  *%rax
  802cb3:	39 c3                	cmp    %eax,%ebx
  802cb5:	0f 94 c0             	sete   %al
  802cb8:	0f b6 c0             	movzbl %al,%eax
  802cbb:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802cbe:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802cc5:	00 00 00 
  802cc8:	48 8b 00             	mov    (%rax),%rax
  802ccb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802cd1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802cd4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cd7:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802cda:	75 05                	jne    802ce1 <_pipeisclosed+0x7d>
			return ret;
  802cdc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cdf:	eb 4f                	jmp    802d30 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802ce1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ce4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802ce7:	74 42                	je     802d2b <_pipeisclosed+0xc7>
  802ce9:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802ced:	75 3c                	jne    802d2b <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802cef:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802cf6:	00 00 00 
  802cf9:	48 8b 00             	mov    (%rax),%rax
  802cfc:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802d02:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802d05:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d08:	89 c6                	mov    %eax,%esi
  802d0a:	48 bf 13 3c 80 00 00 	movabs $0x803c13,%rdi
  802d11:	00 00 00 
  802d14:	b8 00 00 00 00       	mov    $0x0,%eax
  802d19:	49 b8 b5 02 80 00 00 	movabs $0x8002b5,%r8
  802d20:	00 00 00 
  802d23:	41 ff d0             	callq  *%r8
	}
  802d26:	e9 4a ff ff ff       	jmpq   802c75 <_pipeisclosed+0x11>
  802d2b:	e9 45 ff ff ff       	jmpq   802c75 <_pipeisclosed+0x11>
}
  802d30:	48 83 c4 28          	add    $0x28,%rsp
  802d34:	5b                   	pop    %rbx
  802d35:	5d                   	pop    %rbp
  802d36:	c3                   	retq   

0000000000802d37 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802d37:	55                   	push   %rbp
  802d38:	48 89 e5             	mov    %rsp,%rbp
  802d3b:	48 83 ec 30          	sub    $0x30,%rsp
  802d3f:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d42:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d46:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d49:	48 89 d6             	mov    %rdx,%rsi
  802d4c:	89 c7                	mov    %eax,%edi
  802d4e:	48 b8 d4 1d 80 00 00 	movabs $0x801dd4,%rax
  802d55:	00 00 00 
  802d58:	ff d0                	callq  *%rax
  802d5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d61:	79 05                	jns    802d68 <pipeisclosed+0x31>
		return r;
  802d63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d66:	eb 31                	jmp    802d99 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802d68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d6c:	48 89 c7             	mov    %rax,%rdi
  802d6f:	48 b8 11 1d 80 00 00 	movabs $0x801d11,%rax
  802d76:	00 00 00 
  802d79:	ff d0                	callq  *%rax
  802d7b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802d7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d87:	48 89 d6             	mov    %rdx,%rsi
  802d8a:	48 89 c7             	mov    %rax,%rdi
  802d8d:	48 b8 64 2c 80 00 00 	movabs $0x802c64,%rax
  802d94:	00 00 00 
  802d97:	ff d0                	callq  *%rax
}
  802d99:	c9                   	leaveq 
  802d9a:	c3                   	retq   

0000000000802d9b <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802d9b:	55                   	push   %rbp
  802d9c:	48 89 e5             	mov    %rsp,%rbp
  802d9f:	48 83 ec 40          	sub    $0x40,%rsp
  802da3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802da7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802dab:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802daf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802db3:	48 89 c7             	mov    %rax,%rdi
  802db6:	48 b8 11 1d 80 00 00 	movabs $0x801d11,%rax
  802dbd:	00 00 00 
  802dc0:	ff d0                	callq  *%rax
  802dc2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802dc6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802dce:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802dd5:	00 
  802dd6:	e9 92 00 00 00       	jmpq   802e6d <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802ddb:	eb 41                	jmp    802e1e <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802ddd:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802de2:	74 09                	je     802ded <devpipe_read+0x52>
				return i;
  802de4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802de8:	e9 92 00 00 00       	jmpq   802e7f <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802ded:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802df1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802df5:	48 89 d6             	mov    %rdx,%rsi
  802df8:	48 89 c7             	mov    %rax,%rdi
  802dfb:	48 b8 64 2c 80 00 00 	movabs $0x802c64,%rax
  802e02:	00 00 00 
  802e05:	ff d0                	callq  *%rax
  802e07:	85 c0                	test   %eax,%eax
  802e09:	74 07                	je     802e12 <devpipe_read+0x77>
				return 0;
  802e0b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e10:	eb 6d                	jmp    802e7f <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802e12:	48 b8 4e 19 80 00 00 	movabs $0x80194e,%rax
  802e19:	00 00 00 
  802e1c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802e1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e22:	8b 10                	mov    (%rax),%edx
  802e24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e28:	8b 40 04             	mov    0x4(%rax),%eax
  802e2b:	39 c2                	cmp    %eax,%edx
  802e2d:	74 ae                	je     802ddd <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802e2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e33:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e37:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802e3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e3f:	8b 00                	mov    (%rax),%eax
  802e41:	99                   	cltd   
  802e42:	c1 ea 1b             	shr    $0x1b,%edx
  802e45:	01 d0                	add    %edx,%eax
  802e47:	83 e0 1f             	and    $0x1f,%eax
  802e4a:	29 d0                	sub    %edx,%eax
  802e4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e50:	48 98                	cltq   
  802e52:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802e57:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802e59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5d:	8b 00                	mov    (%rax),%eax
  802e5f:	8d 50 01             	lea    0x1(%rax),%edx
  802e62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e66:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e68:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e71:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802e75:	0f 82 60 ff ff ff    	jb     802ddb <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802e7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e7f:	c9                   	leaveq 
  802e80:	c3                   	retq   

0000000000802e81 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802e81:	55                   	push   %rbp
  802e82:	48 89 e5             	mov    %rsp,%rbp
  802e85:	48 83 ec 40          	sub    $0x40,%rsp
  802e89:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e8d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e91:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802e95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e99:	48 89 c7             	mov    %rax,%rdi
  802e9c:	48 b8 11 1d 80 00 00 	movabs $0x801d11,%rax
  802ea3:	00 00 00 
  802ea6:	ff d0                	callq  *%rax
  802ea8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802eac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802eb0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802eb4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ebb:	00 
  802ebc:	e9 8e 00 00 00       	jmpq   802f4f <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802ec1:	eb 31                	jmp    802ef4 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802ec3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ec7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ecb:	48 89 d6             	mov    %rdx,%rsi
  802ece:	48 89 c7             	mov    %rax,%rdi
  802ed1:	48 b8 64 2c 80 00 00 	movabs $0x802c64,%rax
  802ed8:	00 00 00 
  802edb:	ff d0                	callq  *%rax
  802edd:	85 c0                	test   %eax,%eax
  802edf:	74 07                	je     802ee8 <devpipe_write+0x67>
				return 0;
  802ee1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee6:	eb 79                	jmp    802f61 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802ee8:	48 b8 4e 19 80 00 00 	movabs $0x80194e,%rax
  802eef:	00 00 00 
  802ef2:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802ef4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef8:	8b 40 04             	mov    0x4(%rax),%eax
  802efb:	48 63 d0             	movslq %eax,%rdx
  802efe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f02:	8b 00                	mov    (%rax),%eax
  802f04:	48 98                	cltq   
  802f06:	48 83 c0 20          	add    $0x20,%rax
  802f0a:	48 39 c2             	cmp    %rax,%rdx
  802f0d:	73 b4                	jae    802ec3 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802f0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f13:	8b 40 04             	mov    0x4(%rax),%eax
  802f16:	99                   	cltd   
  802f17:	c1 ea 1b             	shr    $0x1b,%edx
  802f1a:	01 d0                	add    %edx,%eax
  802f1c:	83 e0 1f             	and    $0x1f,%eax
  802f1f:	29 d0                	sub    %edx,%eax
  802f21:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f25:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f29:	48 01 ca             	add    %rcx,%rdx
  802f2c:	0f b6 0a             	movzbl (%rdx),%ecx
  802f2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f33:	48 98                	cltq   
  802f35:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802f39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3d:	8b 40 04             	mov    0x4(%rax),%eax
  802f40:	8d 50 01             	lea    0x1(%rax),%edx
  802f43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f47:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f4a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802f4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f53:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802f57:	0f 82 64 ff ff ff    	jb     802ec1 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802f5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f61:	c9                   	leaveq 
  802f62:	c3                   	retq   

0000000000802f63 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802f63:	55                   	push   %rbp
  802f64:	48 89 e5             	mov    %rsp,%rbp
  802f67:	48 83 ec 20          	sub    $0x20,%rsp
  802f6b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f6f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f77:	48 89 c7             	mov    %rax,%rdi
  802f7a:	48 b8 11 1d 80 00 00 	movabs $0x801d11,%rax
  802f81:	00 00 00 
  802f84:	ff d0                	callq  *%rax
  802f86:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802f8a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f8e:	48 be 26 3c 80 00 00 	movabs $0x803c26,%rsi
  802f95:	00 00 00 
  802f98:	48 89 c7             	mov    %rax,%rdi
  802f9b:	48 b8 5d 10 80 00 00 	movabs $0x80105d,%rax
  802fa2:	00 00 00 
  802fa5:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802fa7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fab:	8b 50 04             	mov    0x4(%rax),%edx
  802fae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fb2:	8b 00                	mov    (%rax),%eax
  802fb4:	29 c2                	sub    %eax,%edx
  802fb6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fba:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802fc0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fc4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802fcb:	00 00 00 
	stat->st_dev = &devpipe;
  802fce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fd2:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  802fd9:	00 00 00 
  802fdc:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fe8:	c9                   	leaveq 
  802fe9:	c3                   	retq   

0000000000802fea <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802fea:	55                   	push   %rbp
  802feb:	48 89 e5             	mov    %rsp,%rbp
  802fee:	48 83 ec 10          	sub    $0x10,%rsp
  802ff2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802ff6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ffa:	48 89 c6             	mov    %rax,%rsi
  802ffd:	bf 00 00 00 00       	mov    $0x0,%edi
  803002:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  803009:	00 00 00 
  80300c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80300e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803012:	48 89 c7             	mov    %rax,%rdi
  803015:	48 b8 11 1d 80 00 00 	movabs $0x801d11,%rax
  80301c:	00 00 00 
  80301f:	ff d0                	callq  *%rax
  803021:	48 89 c6             	mov    %rax,%rsi
  803024:	bf 00 00 00 00       	mov    $0x0,%edi
  803029:	48 b8 37 1a 80 00 00 	movabs $0x801a37,%rax
  803030:	00 00 00 
  803033:	ff d0                	callq  *%rax
}
  803035:	c9                   	leaveq 
  803036:	c3                   	retq   

0000000000803037 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803037:	55                   	push   %rbp
  803038:	48 89 e5             	mov    %rsp,%rbp
  80303b:	48 83 ec 20          	sub    $0x20,%rsp
  80303f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803042:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803045:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803048:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80304c:	be 01 00 00 00       	mov    $0x1,%esi
  803051:	48 89 c7             	mov    %rax,%rdi
  803054:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  80305b:	00 00 00 
  80305e:	ff d0                	callq  *%rax
}
  803060:	c9                   	leaveq 
  803061:	c3                   	retq   

0000000000803062 <getchar>:

int
getchar(void)
{
  803062:	55                   	push   %rbp
  803063:	48 89 e5             	mov    %rsp,%rbp
  803066:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80306a:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80306e:	ba 01 00 00 00       	mov    $0x1,%edx
  803073:	48 89 c6             	mov    %rax,%rsi
  803076:	bf 00 00 00 00       	mov    $0x0,%edi
  80307b:	48 b8 06 22 80 00 00 	movabs $0x802206,%rax
  803082:	00 00 00 
  803085:	ff d0                	callq  *%rax
  803087:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80308a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308e:	79 05                	jns    803095 <getchar+0x33>
		return r;
  803090:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803093:	eb 14                	jmp    8030a9 <getchar+0x47>
	if (r < 1)
  803095:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803099:	7f 07                	jg     8030a2 <getchar+0x40>
		return -E_EOF;
  80309b:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8030a0:	eb 07                	jmp    8030a9 <getchar+0x47>
	return c;
  8030a2:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8030a6:	0f b6 c0             	movzbl %al,%eax
}
  8030a9:	c9                   	leaveq 
  8030aa:	c3                   	retq   

00000000008030ab <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8030ab:	55                   	push   %rbp
  8030ac:	48 89 e5             	mov    %rsp,%rbp
  8030af:	48 83 ec 20          	sub    $0x20,%rsp
  8030b3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8030b6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030bd:	48 89 d6             	mov    %rdx,%rsi
  8030c0:	89 c7                	mov    %eax,%edi
  8030c2:	48 b8 d4 1d 80 00 00 	movabs $0x801dd4,%rax
  8030c9:	00 00 00 
  8030cc:	ff d0                	callq  *%rax
  8030ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d5:	79 05                	jns    8030dc <iscons+0x31>
		return r;
  8030d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030da:	eb 1a                	jmp    8030f6 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8030dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e0:	8b 10                	mov    (%rax),%edx
  8030e2:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8030e9:	00 00 00 
  8030ec:	8b 00                	mov    (%rax),%eax
  8030ee:	39 c2                	cmp    %eax,%edx
  8030f0:	0f 94 c0             	sete   %al
  8030f3:	0f b6 c0             	movzbl %al,%eax
}
  8030f6:	c9                   	leaveq 
  8030f7:	c3                   	retq   

00000000008030f8 <opencons>:

int
opencons(void)
{
  8030f8:	55                   	push   %rbp
  8030f9:	48 89 e5             	mov    %rsp,%rbp
  8030fc:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803100:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803104:	48 89 c7             	mov    %rax,%rdi
  803107:	48 b8 3c 1d 80 00 00 	movabs $0x801d3c,%rax
  80310e:	00 00 00 
  803111:	ff d0                	callq  *%rax
  803113:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803116:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80311a:	79 05                	jns    803121 <opencons+0x29>
		return r;
  80311c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311f:	eb 5b                	jmp    80317c <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803121:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803125:	ba 07 04 00 00       	mov    $0x407,%edx
  80312a:	48 89 c6             	mov    %rax,%rsi
  80312d:	bf 00 00 00 00       	mov    $0x0,%edi
  803132:	48 b8 8c 19 80 00 00 	movabs $0x80198c,%rax
  803139:	00 00 00 
  80313c:	ff d0                	callq  *%rax
  80313e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803141:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803145:	79 05                	jns    80314c <opencons+0x54>
		return r;
  803147:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314a:	eb 30                	jmp    80317c <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80314c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803150:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803157:	00 00 00 
  80315a:	8b 12                	mov    (%rdx),%edx
  80315c:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80315e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803162:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803169:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80316d:	48 89 c7             	mov    %rax,%rdi
  803170:	48 b8 ee 1c 80 00 00 	movabs $0x801cee,%rax
  803177:	00 00 00 
  80317a:	ff d0                	callq  *%rax
}
  80317c:	c9                   	leaveq 
  80317d:	c3                   	retq   

000000000080317e <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80317e:	55                   	push   %rbp
  80317f:	48 89 e5             	mov    %rsp,%rbp
  803182:	48 83 ec 30          	sub    $0x30,%rsp
  803186:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80318a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80318e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803192:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803197:	75 07                	jne    8031a0 <devcons_read+0x22>
		return 0;
  803199:	b8 00 00 00 00       	mov    $0x0,%eax
  80319e:	eb 4b                	jmp    8031eb <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8031a0:	eb 0c                	jmp    8031ae <devcons_read+0x30>
		sys_yield();
  8031a2:	48 b8 4e 19 80 00 00 	movabs $0x80194e,%rax
  8031a9:	00 00 00 
  8031ac:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8031ae:	48 b8 8e 18 80 00 00 	movabs $0x80188e,%rax
  8031b5:	00 00 00 
  8031b8:	ff d0                	callq  *%rax
  8031ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c1:	74 df                	je     8031a2 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8031c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c7:	79 05                	jns    8031ce <devcons_read+0x50>
		return c;
  8031c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031cc:	eb 1d                	jmp    8031eb <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8031ce:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8031d2:	75 07                	jne    8031db <devcons_read+0x5d>
		return 0;
  8031d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d9:	eb 10                	jmp    8031eb <devcons_read+0x6d>
	*(char*)vbuf = c;
  8031db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031de:	89 c2                	mov    %eax,%edx
  8031e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031e4:	88 10                	mov    %dl,(%rax)
	return 1;
  8031e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8031eb:	c9                   	leaveq 
  8031ec:	c3                   	retq   

00000000008031ed <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8031ed:	55                   	push   %rbp
  8031ee:	48 89 e5             	mov    %rsp,%rbp
  8031f1:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8031f8:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8031ff:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803206:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80320d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803214:	eb 76                	jmp    80328c <devcons_write+0x9f>
		m = n - tot;
  803216:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80321d:	89 c2                	mov    %eax,%edx
  80321f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803222:	29 c2                	sub    %eax,%edx
  803224:	89 d0                	mov    %edx,%eax
  803226:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803229:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80322c:	83 f8 7f             	cmp    $0x7f,%eax
  80322f:	76 07                	jbe    803238 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803231:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803238:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80323b:	48 63 d0             	movslq %eax,%rdx
  80323e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803241:	48 63 c8             	movslq %eax,%rcx
  803244:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80324b:	48 01 c1             	add    %rax,%rcx
  80324e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803255:	48 89 ce             	mov    %rcx,%rsi
  803258:	48 89 c7             	mov    %rax,%rdi
  80325b:	48 b8 81 13 80 00 00 	movabs $0x801381,%rax
  803262:	00 00 00 
  803265:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803267:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80326a:	48 63 d0             	movslq %eax,%rdx
  80326d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803274:	48 89 d6             	mov    %rdx,%rsi
  803277:	48 89 c7             	mov    %rax,%rdi
  80327a:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  803281:	00 00 00 
  803284:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803286:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803289:	01 45 fc             	add    %eax,-0x4(%rbp)
  80328c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80328f:	48 98                	cltq   
  803291:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803298:	0f 82 78 ff ff ff    	jb     803216 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80329e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8032a1:	c9                   	leaveq 
  8032a2:	c3                   	retq   

00000000008032a3 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8032a3:	55                   	push   %rbp
  8032a4:	48 89 e5             	mov    %rsp,%rbp
  8032a7:	48 83 ec 08          	sub    $0x8,%rsp
  8032ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8032af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032b4:	c9                   	leaveq 
  8032b5:	c3                   	retq   

00000000008032b6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8032b6:	55                   	push   %rbp
  8032b7:	48 89 e5             	mov    %rsp,%rbp
  8032ba:	48 83 ec 10          	sub    $0x10,%rsp
  8032be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8032c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8032c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ca:	48 be 32 3c 80 00 00 	movabs $0x803c32,%rsi
  8032d1:	00 00 00 
  8032d4:	48 89 c7             	mov    %rax,%rdi
  8032d7:	48 b8 5d 10 80 00 00 	movabs $0x80105d,%rax
  8032de:	00 00 00 
  8032e1:	ff d0                	callq  *%rax
	return 0;
  8032e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032e8:	c9                   	leaveq 
  8032e9:	c3                   	retq   

00000000008032ea <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8032ea:	55                   	push   %rbp
  8032eb:	48 89 e5             	mov    %rsp,%rbp
  8032ee:	53                   	push   %rbx
  8032ef:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8032f6:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8032fd:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803303:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80330a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803311:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803318:	84 c0                	test   %al,%al
  80331a:	74 23                	je     80333f <_panic+0x55>
  80331c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803323:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803327:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80332b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80332f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803333:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803337:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80333b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80333f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803346:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80334d:	00 00 00 
  803350:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803357:	00 00 00 
  80335a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80335e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803365:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80336c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803373:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80337a:	00 00 00 
  80337d:	48 8b 18             	mov    (%rax),%rbx
  803380:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  803387:	00 00 00 
  80338a:	ff d0                	callq  *%rax
  80338c:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803392:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803399:	41 89 c8             	mov    %ecx,%r8d
  80339c:	48 89 d1             	mov    %rdx,%rcx
  80339f:	48 89 da             	mov    %rbx,%rdx
  8033a2:	89 c6                	mov    %eax,%esi
  8033a4:	48 bf 40 3c 80 00 00 	movabs $0x803c40,%rdi
  8033ab:	00 00 00 
  8033ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b3:	49 b9 b5 02 80 00 00 	movabs $0x8002b5,%r9
  8033ba:	00 00 00 
  8033bd:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8033c0:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8033c7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8033ce:	48 89 d6             	mov    %rdx,%rsi
  8033d1:	48 89 c7             	mov    %rax,%rdi
  8033d4:	48 b8 09 02 80 00 00 	movabs $0x800209,%rax
  8033db:	00 00 00 
  8033de:	ff d0                	callq  *%rax
	cprintf("\n");
  8033e0:	48 bf 63 3c 80 00 00 	movabs $0x803c63,%rdi
  8033e7:	00 00 00 
  8033ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ef:	48 ba b5 02 80 00 00 	movabs $0x8002b5,%rdx
  8033f6:	00 00 00 
  8033f9:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8033fb:	cc                   	int3   
  8033fc:	eb fd                	jmp    8033fb <_panic+0x111>

00000000008033fe <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8033fe:	55                   	push   %rbp
  8033ff:	48 89 e5             	mov    %rsp,%rbp
  803402:	48 83 ec 30          	sub    $0x30,%rsp
  803406:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80340a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80340e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803412:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803416:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  80341a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80341f:	75 0e                	jne    80342f <ipc_recv+0x31>
		page = (void *)KERNBASE;
  803421:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803428:	00 00 00 
  80342b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  80342f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803433:	48 89 c7             	mov    %rax,%rdi
  803436:	48 b8 b5 1b 80 00 00 	movabs $0x801bb5,%rax
  80343d:	00 00 00 
  803440:	ff d0                	callq  *%rax
  803442:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803445:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803449:	79 27                	jns    803472 <ipc_recv+0x74>
		if (from_env_store != NULL)
  80344b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803450:	74 0a                	je     80345c <ipc_recv+0x5e>
			*from_env_store = 0;
  803452:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803456:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  80345c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803461:	74 0a                	je     80346d <ipc_recv+0x6f>
			*perm_store = 0;
  803463:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803467:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  80346d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803470:	eb 53                	jmp    8034c5 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  803472:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803477:	74 19                	je     803492 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  803479:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803480:	00 00 00 
  803483:	48 8b 00             	mov    (%rax),%rax
  803486:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80348c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803490:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  803492:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803497:	74 19                	je     8034b2 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803499:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034a0:	00 00 00 
  8034a3:	48 8b 00             	mov    (%rax),%rax
  8034a6:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8034ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034b0:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  8034b2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034b9:	00 00 00 
  8034bc:	48 8b 00             	mov    (%rax),%rax
  8034bf:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  8034c5:	c9                   	leaveq 
  8034c6:	c3                   	retq   

00000000008034c7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8034c7:	55                   	push   %rbp
  8034c8:	48 89 e5             	mov    %rsp,%rbp
  8034cb:	48 83 ec 30          	sub    $0x30,%rsp
  8034cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034d2:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8034d5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8034d9:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8034dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8034e4:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8034e9:	75 10                	jne    8034fb <ipc_send+0x34>
		page = (void *)KERNBASE;
  8034eb:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8034f2:	00 00 00 
  8034f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  8034f9:	eb 0e                	jmp    803509 <ipc_send+0x42>
  8034fb:	eb 0c                	jmp    803509 <ipc_send+0x42>
		sys_yield();
  8034fd:	48 b8 4e 19 80 00 00 	movabs $0x80194e,%rax
  803504:	00 00 00 
  803507:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803509:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80350c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80350f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803513:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803516:	89 c7                	mov    %eax,%edi
  803518:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  80351f:	00 00 00 
  803522:	ff d0                	callq  *%rax
  803524:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803527:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  80352b:	74 d0                	je     8034fd <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  80352d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803531:	74 2a                	je     80355d <ipc_send+0x96>
		panic("error on ipc send procedure");
  803533:	48 ba 65 3c 80 00 00 	movabs $0x803c65,%rdx
  80353a:	00 00 00 
  80353d:	be 49 00 00 00       	mov    $0x49,%esi
  803542:	48 bf 81 3c 80 00 00 	movabs $0x803c81,%rdi
  803549:	00 00 00 
  80354c:	b8 00 00 00 00       	mov    $0x0,%eax
  803551:	48 b9 ea 32 80 00 00 	movabs $0x8032ea,%rcx
  803558:	00 00 00 
  80355b:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  80355d:	c9                   	leaveq 
  80355e:	c3                   	retq   

000000000080355f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80355f:	55                   	push   %rbp
  803560:	48 89 e5             	mov    %rsp,%rbp
  803563:	48 83 ec 14          	sub    $0x14,%rsp
  803567:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80356a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803571:	eb 5e                	jmp    8035d1 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803573:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80357a:	00 00 00 
  80357d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803580:	48 63 d0             	movslq %eax,%rdx
  803583:	48 89 d0             	mov    %rdx,%rax
  803586:	48 c1 e0 03          	shl    $0x3,%rax
  80358a:	48 01 d0             	add    %rdx,%rax
  80358d:	48 c1 e0 05          	shl    $0x5,%rax
  803591:	48 01 c8             	add    %rcx,%rax
  803594:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80359a:	8b 00                	mov    (%rax),%eax
  80359c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80359f:	75 2c                	jne    8035cd <ipc_find_env+0x6e>
			return envs[i].env_id;
  8035a1:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8035a8:	00 00 00 
  8035ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ae:	48 63 d0             	movslq %eax,%rdx
  8035b1:	48 89 d0             	mov    %rdx,%rax
  8035b4:	48 c1 e0 03          	shl    $0x3,%rax
  8035b8:	48 01 d0             	add    %rdx,%rax
  8035bb:	48 c1 e0 05          	shl    $0x5,%rax
  8035bf:	48 01 c8             	add    %rcx,%rax
  8035c2:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8035c8:	8b 40 08             	mov    0x8(%rax),%eax
  8035cb:	eb 12                	jmp    8035df <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8035cd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8035d1:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8035d8:	7e 99                	jle    803573 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8035da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035df:	c9                   	leaveq 
  8035e0:	c3                   	retq   

00000000008035e1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8035e1:	55                   	push   %rbp
  8035e2:	48 89 e5             	mov    %rsp,%rbp
  8035e5:	48 83 ec 18          	sub    $0x18,%rsp
  8035e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8035ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035f1:	48 c1 e8 15          	shr    $0x15,%rax
  8035f5:	48 89 c2             	mov    %rax,%rdx
  8035f8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8035ff:	01 00 00 
  803602:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803606:	83 e0 01             	and    $0x1,%eax
  803609:	48 85 c0             	test   %rax,%rax
  80360c:	75 07                	jne    803615 <pageref+0x34>
		return 0;
  80360e:	b8 00 00 00 00       	mov    $0x0,%eax
  803613:	eb 53                	jmp    803668 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803615:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803619:	48 c1 e8 0c          	shr    $0xc,%rax
  80361d:	48 89 c2             	mov    %rax,%rdx
  803620:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803627:	01 00 00 
  80362a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80362e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803632:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803636:	83 e0 01             	and    $0x1,%eax
  803639:	48 85 c0             	test   %rax,%rax
  80363c:	75 07                	jne    803645 <pageref+0x64>
		return 0;
  80363e:	b8 00 00 00 00       	mov    $0x0,%eax
  803643:	eb 23                	jmp    803668 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803645:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803649:	48 c1 e8 0c          	shr    $0xc,%rax
  80364d:	48 89 c2             	mov    %rax,%rdx
  803650:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803657:	00 00 00 
  80365a:	48 c1 e2 04          	shl    $0x4,%rdx
  80365e:	48 01 d0             	add    %rdx,%rax
  803661:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803665:	0f b7 c0             	movzwl %ax,%eax
}
  803668:	c9                   	leaveq 
  803669:	c3                   	retq   
