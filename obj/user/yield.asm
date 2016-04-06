
obj/user/yield.debug:     file format elf64-x86-64


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
  80003c:	e8 c5 00 00 00       	callq  800106 <libmain>
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
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  800052:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800065:	89 c6                	mov    %eax,%esi
  800067:	48 bf a0 35 80 00 00 	movabs $0x8035a0,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba de 02 80 00 00 	movabs $0x8002de,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	for (i = 0; i < 5; i++) {
  800082:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800089:	eb 43                	jmp    8000ce <umain+0x8b>
		sys_yield();
  80008b:	48 b8 77 19 80 00 00 	movabs $0x801977,%rax
  800092:	00 00 00 
  800095:	ff d0                	callq  *%rax
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  800097:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80009e:	00 00 00 
  8000a1:	48 8b 00             	mov    (%rax),%rax
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
  8000a4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8000aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8000ad:	89 c6                	mov    %eax,%esi
  8000af:	48 bf c0 35 80 00 00 	movabs $0x8035c0,%rdi
  8000b6:	00 00 00 
  8000b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000be:	48 b9 de 02 80 00 00 	movabs $0x8002de,%rcx
  8000c5:	00 00 00 
  8000c8:	ff d1                	callq  *%rcx
umain(int argc, char **argv)
{
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
  8000ca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000ce:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8000d2:	7e b7                	jle    80008b <umain+0x48>
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  8000d4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000db:	00 00 00 
  8000de:	48 8b 00             	mov    (%rax),%rax
  8000e1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8000e7:	89 c6                	mov    %eax,%esi
  8000e9:	48 bf f0 35 80 00 00 	movabs $0x8035f0,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	48 ba de 02 80 00 00 	movabs $0x8002de,%rdx
  8000ff:	00 00 00 
  800102:	ff d2                	callq  *%rdx
}
  800104:	c9                   	leaveq 
  800105:	c3                   	retq   

0000000000800106 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800106:	55                   	push   %rbp
  800107:	48 89 e5             	mov    %rsp,%rbp
  80010a:	48 83 ec 10          	sub    $0x10,%rsp
  80010e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800111:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800115:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
  800121:	48 98                	cltq   
  800123:	25 ff 03 00 00       	and    $0x3ff,%eax
  800128:	48 89 c2             	mov    %rax,%rdx
  80012b:	48 89 d0             	mov    %rdx,%rax
  80012e:	48 c1 e0 03          	shl    $0x3,%rax
  800132:	48 01 d0             	add    %rdx,%rax
  800135:	48 c1 e0 05          	shl    $0x5,%rax
  800139:	48 89 c2             	mov    %rax,%rdx
  80013c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800143:	00 00 00 
  800146:	48 01 c2             	add    %rax,%rdx
  800149:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800150:	00 00 00 
  800153:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800156:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80015a:	7e 14                	jle    800170 <libmain+0x6a>
		binaryname = argv[0];
  80015c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800160:	48 8b 10             	mov    (%rax),%rdx
  800163:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80016a:	00 00 00 
  80016d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800170:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800174:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800177:	48 89 d6             	mov    %rdx,%rsi
  80017a:	89 c7                	mov    %eax,%edi
  80017c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800183:	00 00 00 
  800186:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800188:	48 b8 96 01 80 00 00 	movabs $0x800196,%rax
  80018f:	00 00 00 
  800192:	ff d0                	callq  *%rax
}
  800194:	c9                   	leaveq 
  800195:	c3                   	retq   

0000000000800196 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800196:	55                   	push   %rbp
  800197:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80019a:	48 b8 63 1f 80 00 00 	movabs $0x801f63,%rax
  8001a1:	00 00 00 
  8001a4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ab:	48 b8 f5 18 80 00 00 	movabs $0x8018f5,%rax
  8001b2:	00 00 00 
  8001b5:	ff d0                	callq  *%rax
}
  8001b7:	5d                   	pop    %rbp
  8001b8:	c3                   	retq   

00000000008001b9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001b9:	55                   	push   %rbp
  8001ba:	48 89 e5             	mov    %rsp,%rbp
  8001bd:	48 83 ec 10          	sub    $0x10,%rsp
  8001c1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8001c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001cc:	8b 00                	mov    (%rax),%eax
  8001ce:	8d 48 01             	lea    0x1(%rax),%ecx
  8001d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d5:	89 0a                	mov    %ecx,(%rdx)
  8001d7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001da:	89 d1                	mov    %edx,%ecx
  8001dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001e0:	48 98                	cltq   
  8001e2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8001e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ea:	8b 00                	mov    (%rax),%eax
  8001ec:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f1:	75 2c                	jne    80021f <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8001f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001f7:	8b 00                	mov    (%rax),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ff:	48 83 c2 08          	add    $0x8,%rdx
  800203:	48 89 c6             	mov    %rax,%rsi
  800206:	48 89 d7             	mov    %rdx,%rdi
  800209:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  800210:	00 00 00 
  800213:	ff d0                	callq  *%rax
		b->idx = 0;
  800215:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800219:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80021f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800223:	8b 40 04             	mov    0x4(%rax),%eax
  800226:	8d 50 01             	lea    0x1(%rax),%edx
  800229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022d:	89 50 04             	mov    %edx,0x4(%rax)
}
  800230:	c9                   	leaveq 
  800231:	c3                   	retq   

0000000000800232 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800232:	55                   	push   %rbp
  800233:	48 89 e5             	mov    %rsp,%rbp
  800236:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80023d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800244:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80024b:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800252:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800259:	48 8b 0a             	mov    (%rdx),%rcx
  80025c:	48 89 08             	mov    %rcx,(%rax)
  80025f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800263:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800267:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80026b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  80026f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800276:	00 00 00 
	b.cnt = 0;
  800279:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800280:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800283:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80028a:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800291:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800298:	48 89 c6             	mov    %rax,%rsi
  80029b:	48 bf b9 01 80 00 00 	movabs $0x8001b9,%rdi
  8002a2:	00 00 00 
  8002a5:	48 b8 91 06 80 00 00 	movabs $0x800691,%rax
  8002ac:	00 00 00 
  8002af:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8002b1:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002b7:	48 98                	cltq   
  8002b9:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002c0:	48 83 c2 08          	add    $0x8,%rdx
  8002c4:	48 89 c6             	mov    %rax,%rsi
  8002c7:	48 89 d7             	mov    %rdx,%rdi
  8002ca:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  8002d1:	00 00 00 
  8002d4:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8002d6:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002dc:	c9                   	leaveq 
  8002dd:	c3                   	retq   

00000000008002de <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002de:	55                   	push   %rbp
  8002df:	48 89 e5             	mov    %rsp,%rbp
  8002e2:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002e9:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8002f0:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8002f7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8002fe:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800305:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80030c:	84 c0                	test   %al,%al
  80030e:	74 20                	je     800330 <cprintf+0x52>
  800310:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800314:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800318:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80031c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800320:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800324:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800328:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80032c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800330:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800337:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80033e:	00 00 00 
  800341:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800348:	00 00 00 
  80034b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80034f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800356:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80035d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800364:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80036b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800372:	48 8b 0a             	mov    (%rdx),%rcx
  800375:	48 89 08             	mov    %rcx,(%rax)
  800378:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80037c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800380:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800384:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800388:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80038f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800396:	48 89 d6             	mov    %rdx,%rsi
  800399:	48 89 c7             	mov    %rax,%rdi
  80039c:	48 b8 32 02 80 00 00 	movabs $0x800232,%rax
  8003a3:	00 00 00 
  8003a6:	ff d0                	callq  *%rax
  8003a8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8003ae:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003b4:	c9                   	leaveq 
  8003b5:	c3                   	retq   

00000000008003b6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003b6:	55                   	push   %rbp
  8003b7:	48 89 e5             	mov    %rsp,%rbp
  8003ba:	53                   	push   %rbx
  8003bb:	48 83 ec 38          	sub    $0x38,%rsp
  8003bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8003c7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8003cb:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003ce:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003d2:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003d6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003d9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003dd:	77 3b                	ja     80041a <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003df:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003e2:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003e6:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8003e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f2:	48 f7 f3             	div    %rbx
  8003f5:	48 89 c2             	mov    %rax,%rdx
  8003f8:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8003fb:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003fe:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800406:	41 89 f9             	mov    %edi,%r9d
  800409:	48 89 c7             	mov    %rax,%rdi
  80040c:	48 b8 b6 03 80 00 00 	movabs $0x8003b6,%rax
  800413:	00 00 00 
  800416:	ff d0                	callq  *%rax
  800418:	eb 1e                	jmp    800438 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80041a:	eb 12                	jmp    80042e <printnum+0x78>
			putch(padc, putdat);
  80041c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800420:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800423:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800427:	48 89 ce             	mov    %rcx,%rsi
  80042a:	89 d7                	mov    %edx,%edi
  80042c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80042e:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800432:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800436:	7f e4                	jg     80041c <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800438:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80043b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80043f:	ba 00 00 00 00       	mov    $0x0,%edx
  800444:	48 f7 f1             	div    %rcx
  800447:	48 89 d0             	mov    %rdx,%rax
  80044a:	48 ba e8 37 80 00 00 	movabs $0x8037e8,%rdx
  800451:	00 00 00 
  800454:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800458:	0f be d0             	movsbl %al,%edx
  80045b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80045f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800463:	48 89 ce             	mov    %rcx,%rsi
  800466:	89 d7                	mov    %edx,%edi
  800468:	ff d0                	callq  *%rax
}
  80046a:	48 83 c4 38          	add    $0x38,%rsp
  80046e:	5b                   	pop    %rbx
  80046f:	5d                   	pop    %rbp
  800470:	c3                   	retq   

0000000000800471 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800471:	55                   	push   %rbp
  800472:	48 89 e5             	mov    %rsp,%rbp
  800475:	48 83 ec 1c          	sub    $0x1c,%rsp
  800479:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80047d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800480:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800484:	7e 52                	jle    8004d8 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048a:	8b 00                	mov    (%rax),%eax
  80048c:	83 f8 30             	cmp    $0x30,%eax
  80048f:	73 24                	jae    8004b5 <getuint+0x44>
  800491:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800495:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800499:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049d:	8b 00                	mov    (%rax),%eax
  80049f:	89 c0                	mov    %eax,%eax
  8004a1:	48 01 d0             	add    %rdx,%rax
  8004a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a8:	8b 12                	mov    (%rdx),%edx
  8004aa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b1:	89 0a                	mov    %ecx,(%rdx)
  8004b3:	eb 17                	jmp    8004cc <getuint+0x5b>
  8004b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004bd:	48 89 d0             	mov    %rdx,%rax
  8004c0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004cc:	48 8b 00             	mov    (%rax),%rax
  8004cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004d3:	e9 a3 00 00 00       	jmpq   80057b <getuint+0x10a>
	else if (lflag)
  8004d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004dc:	74 4f                	je     80052d <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e2:	8b 00                	mov    (%rax),%eax
  8004e4:	83 f8 30             	cmp    $0x30,%eax
  8004e7:	73 24                	jae    80050d <getuint+0x9c>
  8004e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ed:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f5:	8b 00                	mov    (%rax),%eax
  8004f7:	89 c0                	mov    %eax,%eax
  8004f9:	48 01 d0             	add    %rdx,%rax
  8004fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800500:	8b 12                	mov    (%rdx),%edx
  800502:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800505:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800509:	89 0a                	mov    %ecx,(%rdx)
  80050b:	eb 17                	jmp    800524 <getuint+0xb3>
  80050d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800511:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800515:	48 89 d0             	mov    %rdx,%rax
  800518:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80051c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800520:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800524:	48 8b 00             	mov    (%rax),%rax
  800527:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80052b:	eb 4e                	jmp    80057b <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80052d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800531:	8b 00                	mov    (%rax),%eax
  800533:	83 f8 30             	cmp    $0x30,%eax
  800536:	73 24                	jae    80055c <getuint+0xeb>
  800538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800540:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800544:	8b 00                	mov    (%rax),%eax
  800546:	89 c0                	mov    %eax,%eax
  800548:	48 01 d0             	add    %rdx,%rax
  80054b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054f:	8b 12                	mov    (%rdx),%edx
  800551:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800554:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800558:	89 0a                	mov    %ecx,(%rdx)
  80055a:	eb 17                	jmp    800573 <getuint+0x102>
  80055c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800560:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800564:	48 89 d0             	mov    %rdx,%rax
  800567:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80056b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800573:	8b 00                	mov    (%rax),%eax
  800575:	89 c0                	mov    %eax,%eax
  800577:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80057b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80057f:	c9                   	leaveq 
  800580:	c3                   	retq   

0000000000800581 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800581:	55                   	push   %rbp
  800582:	48 89 e5             	mov    %rsp,%rbp
  800585:	48 83 ec 1c          	sub    $0x1c,%rsp
  800589:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80058d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800590:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800594:	7e 52                	jle    8005e8 <getint+0x67>
		x=va_arg(*ap, long long);
  800596:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059a:	8b 00                	mov    (%rax),%eax
  80059c:	83 f8 30             	cmp    $0x30,%eax
  80059f:	73 24                	jae    8005c5 <getint+0x44>
  8005a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ad:	8b 00                	mov    (%rax),%eax
  8005af:	89 c0                	mov    %eax,%eax
  8005b1:	48 01 d0             	add    %rdx,%rax
  8005b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b8:	8b 12                	mov    (%rdx),%edx
  8005ba:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c1:	89 0a                	mov    %ecx,(%rdx)
  8005c3:	eb 17                	jmp    8005dc <getint+0x5b>
  8005c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005cd:	48 89 d0             	mov    %rdx,%rax
  8005d0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005dc:	48 8b 00             	mov    (%rax),%rax
  8005df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005e3:	e9 a3 00 00 00       	jmpq   80068b <getint+0x10a>
	else if (lflag)
  8005e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005ec:	74 4f                	je     80063d <getint+0xbc>
		x=va_arg(*ap, long);
  8005ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f2:	8b 00                	mov    (%rax),%eax
  8005f4:	83 f8 30             	cmp    $0x30,%eax
  8005f7:	73 24                	jae    80061d <getint+0x9c>
  8005f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800605:	8b 00                	mov    (%rax),%eax
  800607:	89 c0                	mov    %eax,%eax
  800609:	48 01 d0             	add    %rdx,%rax
  80060c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800610:	8b 12                	mov    (%rdx),%edx
  800612:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800615:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800619:	89 0a                	mov    %ecx,(%rdx)
  80061b:	eb 17                	jmp    800634 <getint+0xb3>
  80061d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800621:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800625:	48 89 d0             	mov    %rdx,%rax
  800628:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80062c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800630:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800634:	48 8b 00             	mov    (%rax),%rax
  800637:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80063b:	eb 4e                	jmp    80068b <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80063d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800641:	8b 00                	mov    (%rax),%eax
  800643:	83 f8 30             	cmp    $0x30,%eax
  800646:	73 24                	jae    80066c <getint+0xeb>
  800648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800654:	8b 00                	mov    (%rax),%eax
  800656:	89 c0                	mov    %eax,%eax
  800658:	48 01 d0             	add    %rdx,%rax
  80065b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065f:	8b 12                	mov    (%rdx),%edx
  800661:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800664:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800668:	89 0a                	mov    %ecx,(%rdx)
  80066a:	eb 17                	jmp    800683 <getint+0x102>
  80066c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800670:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800674:	48 89 d0             	mov    %rdx,%rax
  800677:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80067b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800683:	8b 00                	mov    (%rax),%eax
  800685:	48 98                	cltq   
  800687:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80068b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80068f:	c9                   	leaveq 
  800690:	c3                   	retq   

0000000000800691 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800691:	55                   	push   %rbp
  800692:	48 89 e5             	mov    %rsp,%rbp
  800695:	41 54                	push   %r12
  800697:	53                   	push   %rbx
  800698:	48 83 ec 60          	sub    $0x60,%rsp
  80069c:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006a0:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006a4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006a8:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006ac:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006b0:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006b4:	48 8b 0a             	mov    (%rdx),%rcx
  8006b7:	48 89 08             	mov    %rcx,(%rax)
  8006ba:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006be:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006c2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006c6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  8006ca:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006ce:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006d2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006d6:	0f b6 00             	movzbl (%rax),%eax
  8006d9:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  8006dc:	eb 29                	jmp    800707 <vprintfmt+0x76>
			if (ch == '\0')
  8006de:	85 db                	test   %ebx,%ebx
  8006e0:	0f 84 ad 06 00 00    	je     800d93 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  8006e6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006ea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006ee:	48 89 d6             	mov    %rdx,%rsi
  8006f1:	89 df                	mov    %ebx,%edi
  8006f3:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  8006f5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006f9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006fd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800701:	0f b6 00             	movzbl (%rax),%eax
  800704:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  800707:	83 fb 25             	cmp    $0x25,%ebx
  80070a:	74 05                	je     800711 <vprintfmt+0x80>
  80070c:	83 fb 1b             	cmp    $0x1b,%ebx
  80070f:	75 cd                	jne    8006de <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800711:	83 fb 1b             	cmp    $0x1b,%ebx
  800714:	0f 85 ae 01 00 00    	jne    8008c8 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  80071a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800721:	00 00 00 
  800724:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  80072a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80072e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800732:	48 89 d6             	mov    %rdx,%rsi
  800735:	89 df                	mov    %ebx,%edi
  800737:	ff d0                	callq  *%rax
			putch('[', putdat);
  800739:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80073d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800741:	48 89 d6             	mov    %rdx,%rsi
  800744:	bf 5b 00 00 00       	mov    $0x5b,%edi
  800749:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  80074b:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800751:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800756:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80075a:	0f b6 00             	movzbl (%rax),%eax
  80075d:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800760:	eb 32                	jmp    800794 <vprintfmt+0x103>
					putch(ch, putdat);
  800762:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800766:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80076a:	48 89 d6             	mov    %rdx,%rsi
  80076d:	89 df                	mov    %ebx,%edi
  80076f:	ff d0                	callq  *%rax
					esc_color *= 10;
  800771:	44 89 e0             	mov    %r12d,%eax
  800774:	c1 e0 02             	shl    $0x2,%eax
  800777:	44 01 e0             	add    %r12d,%eax
  80077a:	01 c0                	add    %eax,%eax
  80077c:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  80077f:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800782:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800785:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80078a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80078e:	0f b6 00             	movzbl (%rax),%eax
  800791:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800794:	83 fb 3b             	cmp    $0x3b,%ebx
  800797:	74 05                	je     80079e <vprintfmt+0x10d>
  800799:	83 fb 6d             	cmp    $0x6d,%ebx
  80079c:	75 c4                	jne    800762 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  80079e:	45 85 e4             	test   %r12d,%r12d
  8007a1:	75 15                	jne    8007b8 <vprintfmt+0x127>
					color_flag = 0x07;
  8007a3:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8007aa:	00 00 00 
  8007ad:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  8007b3:	e9 dc 00 00 00       	jmpq   800894 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  8007b8:	41 83 fc 1d          	cmp    $0x1d,%r12d
  8007bc:	7e 69                	jle    800827 <vprintfmt+0x196>
  8007be:	41 83 fc 25          	cmp    $0x25,%r12d
  8007c2:	7f 63                	jg     800827 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  8007c4:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8007cb:	00 00 00 
  8007ce:	8b 00                	mov    (%rax),%eax
  8007d0:	25 f8 00 00 00       	and    $0xf8,%eax
  8007d5:	89 c2                	mov    %eax,%edx
  8007d7:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8007de:	00 00 00 
  8007e1:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  8007e3:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  8007e7:	44 89 e0             	mov    %r12d,%eax
  8007ea:	83 e0 04             	and    $0x4,%eax
  8007ed:	c1 f8 02             	sar    $0x2,%eax
  8007f0:	89 c2                	mov    %eax,%edx
  8007f2:	44 89 e0             	mov    %r12d,%eax
  8007f5:	83 e0 02             	and    $0x2,%eax
  8007f8:	09 c2                	or     %eax,%edx
  8007fa:	44 89 e0             	mov    %r12d,%eax
  8007fd:	83 e0 01             	and    $0x1,%eax
  800800:	c1 e0 02             	shl    $0x2,%eax
  800803:	09 c2                	or     %eax,%edx
  800805:	41 89 d4             	mov    %edx,%r12d
  800808:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80080f:	00 00 00 
  800812:	8b 00                	mov    (%rax),%eax
  800814:	44 89 e2             	mov    %r12d,%edx
  800817:	09 c2                	or     %eax,%edx
  800819:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800820:	00 00 00 
  800823:	89 10                	mov    %edx,(%rax)
  800825:	eb 6d                	jmp    800894 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800827:	41 83 fc 27          	cmp    $0x27,%r12d
  80082b:	7e 67                	jle    800894 <vprintfmt+0x203>
  80082d:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800831:	7f 61                	jg     800894 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800833:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80083a:	00 00 00 
  80083d:	8b 00                	mov    (%rax),%eax
  80083f:	25 8f 00 00 00       	and    $0x8f,%eax
  800844:	89 c2                	mov    %eax,%edx
  800846:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80084d:	00 00 00 
  800850:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800852:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800856:	44 89 e0             	mov    %r12d,%eax
  800859:	83 e0 04             	and    $0x4,%eax
  80085c:	c1 f8 02             	sar    $0x2,%eax
  80085f:	89 c2                	mov    %eax,%edx
  800861:	44 89 e0             	mov    %r12d,%eax
  800864:	83 e0 02             	and    $0x2,%eax
  800867:	09 c2                	or     %eax,%edx
  800869:	44 89 e0             	mov    %r12d,%eax
  80086c:	83 e0 01             	and    $0x1,%eax
  80086f:	c1 e0 06             	shl    $0x6,%eax
  800872:	09 c2                	or     %eax,%edx
  800874:	41 89 d4             	mov    %edx,%r12d
  800877:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80087e:	00 00 00 
  800881:	8b 00                	mov    (%rax),%eax
  800883:	44 89 e2             	mov    %r12d,%edx
  800886:	09 c2                	or     %eax,%edx
  800888:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80088f:	00 00 00 
  800892:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800894:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800898:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80089c:	48 89 d6             	mov    %rdx,%rsi
  80089f:	89 df                	mov    %ebx,%edi
  8008a1:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  8008a3:	83 fb 6d             	cmp    $0x6d,%ebx
  8008a6:	75 1b                	jne    8008c3 <vprintfmt+0x232>
					fmt ++;
  8008a8:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  8008ad:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  8008ae:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8008b5:	00 00 00 
  8008b8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  8008be:	e9 cb 04 00 00       	jmpq   800d8e <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  8008c3:	e9 83 fe ff ff       	jmpq   80074b <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  8008c8:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008cc:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008e1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008ec:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008f0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008f4:	0f b6 00             	movzbl (%rax),%eax
  8008f7:	0f b6 d8             	movzbl %al,%ebx
  8008fa:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008fd:	83 f8 55             	cmp    $0x55,%eax
  800900:	0f 87 5a 04 00 00    	ja     800d60 <vprintfmt+0x6cf>
  800906:	89 c0                	mov    %eax,%eax
  800908:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80090f:	00 
  800910:	48 b8 10 38 80 00 00 	movabs $0x803810,%rax
  800917:	00 00 00 
  80091a:	48 01 d0             	add    %rdx,%rax
  80091d:	48 8b 00             	mov    (%rax),%rax
  800920:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800922:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800926:	eb c0                	jmp    8008e8 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800928:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80092c:	eb ba                	jmp    8008e8 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80092e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800935:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800938:	89 d0                	mov    %edx,%eax
  80093a:	c1 e0 02             	shl    $0x2,%eax
  80093d:	01 d0                	add    %edx,%eax
  80093f:	01 c0                	add    %eax,%eax
  800941:	01 d8                	add    %ebx,%eax
  800943:	83 e8 30             	sub    $0x30,%eax
  800946:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800949:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80094d:	0f b6 00             	movzbl (%rax),%eax
  800950:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800953:	83 fb 2f             	cmp    $0x2f,%ebx
  800956:	7e 0c                	jle    800964 <vprintfmt+0x2d3>
  800958:	83 fb 39             	cmp    $0x39,%ebx
  80095b:	7f 07                	jg     800964 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80095d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800962:	eb d1                	jmp    800935 <vprintfmt+0x2a4>
			goto process_precision;
  800964:	eb 58                	jmp    8009be <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800966:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800969:	83 f8 30             	cmp    $0x30,%eax
  80096c:	73 17                	jae    800985 <vprintfmt+0x2f4>
  80096e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800972:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800975:	89 c0                	mov    %eax,%eax
  800977:	48 01 d0             	add    %rdx,%rax
  80097a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80097d:	83 c2 08             	add    $0x8,%edx
  800980:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800983:	eb 0f                	jmp    800994 <vprintfmt+0x303>
  800985:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800989:	48 89 d0             	mov    %rdx,%rax
  80098c:	48 83 c2 08          	add    $0x8,%rdx
  800990:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800994:	8b 00                	mov    (%rax),%eax
  800996:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800999:	eb 23                	jmp    8009be <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  80099b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80099f:	79 0c                	jns    8009ad <vprintfmt+0x31c>
				width = 0;
  8009a1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009a8:	e9 3b ff ff ff       	jmpq   8008e8 <vprintfmt+0x257>
  8009ad:	e9 36 ff ff ff       	jmpq   8008e8 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  8009b2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009b9:	e9 2a ff ff ff       	jmpq   8008e8 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  8009be:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c2:	79 12                	jns    8009d6 <vprintfmt+0x345>
				width = precision, precision = -1;
  8009c4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009c7:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009ca:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009d1:	e9 12 ff ff ff       	jmpq   8008e8 <vprintfmt+0x257>
  8009d6:	e9 0d ff ff ff       	jmpq   8008e8 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009db:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009df:	e9 04 ff ff ff       	jmpq   8008e8 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009e4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e7:	83 f8 30             	cmp    $0x30,%eax
  8009ea:	73 17                	jae    800a03 <vprintfmt+0x372>
  8009ec:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009f0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f3:	89 c0                	mov    %eax,%eax
  8009f5:	48 01 d0             	add    %rdx,%rax
  8009f8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009fb:	83 c2 08             	add    $0x8,%edx
  8009fe:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a01:	eb 0f                	jmp    800a12 <vprintfmt+0x381>
  800a03:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a07:	48 89 d0             	mov    %rdx,%rax
  800a0a:	48 83 c2 08          	add    $0x8,%rdx
  800a0e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a12:	8b 10                	mov    (%rax),%edx
  800a14:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a1c:	48 89 ce             	mov    %rcx,%rsi
  800a1f:	89 d7                	mov    %edx,%edi
  800a21:	ff d0                	callq  *%rax
			break;
  800a23:	e9 66 03 00 00       	jmpq   800d8e <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800a28:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2b:	83 f8 30             	cmp    $0x30,%eax
  800a2e:	73 17                	jae    800a47 <vprintfmt+0x3b6>
  800a30:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a34:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a37:	89 c0                	mov    %eax,%eax
  800a39:	48 01 d0             	add    %rdx,%rax
  800a3c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a3f:	83 c2 08             	add    $0x8,%edx
  800a42:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a45:	eb 0f                	jmp    800a56 <vprintfmt+0x3c5>
  800a47:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a4b:	48 89 d0             	mov    %rdx,%rax
  800a4e:	48 83 c2 08          	add    $0x8,%rdx
  800a52:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a56:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a58:	85 db                	test   %ebx,%ebx
  800a5a:	79 02                	jns    800a5e <vprintfmt+0x3cd>
				err = -err;
  800a5c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a5e:	83 fb 10             	cmp    $0x10,%ebx
  800a61:	7f 16                	jg     800a79 <vprintfmt+0x3e8>
  800a63:	48 b8 60 37 80 00 00 	movabs $0x803760,%rax
  800a6a:	00 00 00 
  800a6d:	48 63 d3             	movslq %ebx,%rdx
  800a70:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a74:	4d 85 e4             	test   %r12,%r12
  800a77:	75 2e                	jne    800aa7 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800a79:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a7d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a81:	89 d9                	mov    %ebx,%ecx
  800a83:	48 ba f9 37 80 00 00 	movabs $0x8037f9,%rdx
  800a8a:	00 00 00 
  800a8d:	48 89 c7             	mov    %rax,%rdi
  800a90:	b8 00 00 00 00       	mov    $0x0,%eax
  800a95:	49 b8 9c 0d 80 00 00 	movabs $0x800d9c,%r8
  800a9c:	00 00 00 
  800a9f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa2:	e9 e7 02 00 00       	jmpq   800d8e <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aa7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aaf:	4c 89 e1             	mov    %r12,%rcx
  800ab2:	48 ba 02 38 80 00 00 	movabs $0x803802,%rdx
  800ab9:	00 00 00 
  800abc:	48 89 c7             	mov    %rax,%rdi
  800abf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac4:	49 b8 9c 0d 80 00 00 	movabs $0x800d9c,%r8
  800acb:	00 00 00 
  800ace:	41 ff d0             	callq  *%r8
			break;
  800ad1:	e9 b8 02 00 00       	jmpq   800d8e <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ad6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad9:	83 f8 30             	cmp    $0x30,%eax
  800adc:	73 17                	jae    800af5 <vprintfmt+0x464>
  800ade:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ae2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae5:	89 c0                	mov    %eax,%eax
  800ae7:	48 01 d0             	add    %rdx,%rax
  800aea:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aed:	83 c2 08             	add    $0x8,%edx
  800af0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800af3:	eb 0f                	jmp    800b04 <vprintfmt+0x473>
  800af5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800af9:	48 89 d0             	mov    %rdx,%rax
  800afc:	48 83 c2 08          	add    $0x8,%rdx
  800b00:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b04:	4c 8b 20             	mov    (%rax),%r12
  800b07:	4d 85 e4             	test   %r12,%r12
  800b0a:	75 0a                	jne    800b16 <vprintfmt+0x485>
				p = "(null)";
  800b0c:	49 bc 05 38 80 00 00 	movabs $0x803805,%r12
  800b13:	00 00 00 
			if (width > 0 && padc != '-')
  800b16:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b1a:	7e 3f                	jle    800b5b <vprintfmt+0x4ca>
  800b1c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b20:	74 39                	je     800b5b <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b22:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b25:	48 98                	cltq   
  800b27:	48 89 c6             	mov    %rax,%rsi
  800b2a:	4c 89 e7             	mov    %r12,%rdi
  800b2d:	48 b8 48 10 80 00 00 	movabs $0x801048,%rax
  800b34:	00 00 00 
  800b37:	ff d0                	callq  *%rax
  800b39:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b3c:	eb 17                	jmp    800b55 <vprintfmt+0x4c4>
					putch(padc, putdat);
  800b3e:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b42:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b4a:	48 89 ce             	mov    %rcx,%rsi
  800b4d:	89 d7                	mov    %edx,%edi
  800b4f:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b51:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b55:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b59:	7f e3                	jg     800b3e <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5b:	eb 37                	jmp    800b94 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800b5d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b61:	74 1e                	je     800b81 <vprintfmt+0x4f0>
  800b63:	83 fb 1f             	cmp    $0x1f,%ebx
  800b66:	7e 05                	jle    800b6d <vprintfmt+0x4dc>
  800b68:	83 fb 7e             	cmp    $0x7e,%ebx
  800b6b:	7e 14                	jle    800b81 <vprintfmt+0x4f0>
					putch('?', putdat);
  800b6d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b75:	48 89 d6             	mov    %rdx,%rsi
  800b78:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b7d:	ff d0                	callq  *%rax
  800b7f:	eb 0f                	jmp    800b90 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800b81:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b85:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b89:	48 89 d6             	mov    %rdx,%rsi
  800b8c:	89 df                	mov    %ebx,%edi
  800b8e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b90:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b94:	4c 89 e0             	mov    %r12,%rax
  800b97:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b9b:	0f b6 00             	movzbl (%rax),%eax
  800b9e:	0f be d8             	movsbl %al,%ebx
  800ba1:	85 db                	test   %ebx,%ebx
  800ba3:	74 10                	je     800bb5 <vprintfmt+0x524>
  800ba5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ba9:	78 b2                	js     800b5d <vprintfmt+0x4cc>
  800bab:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800baf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bb3:	79 a8                	jns    800b5d <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb5:	eb 16                	jmp    800bcd <vprintfmt+0x53c>
				putch(' ', putdat);
  800bb7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bbb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bbf:	48 89 d6             	mov    %rdx,%rsi
  800bc2:	bf 20 00 00 00       	mov    $0x20,%edi
  800bc7:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bcd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bd1:	7f e4                	jg     800bb7 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800bd3:	e9 b6 01 00 00       	jmpq   800d8e <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bd8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bdc:	be 03 00 00 00       	mov    $0x3,%esi
  800be1:	48 89 c7             	mov    %rax,%rdi
  800be4:	48 b8 81 05 80 00 00 	movabs $0x800581,%rax
  800beb:	00 00 00 
  800bee:	ff d0                	callq  *%rax
  800bf0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bf4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf8:	48 85 c0             	test   %rax,%rax
  800bfb:	79 1d                	jns    800c1a <vprintfmt+0x589>
				putch('-', putdat);
  800bfd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c05:	48 89 d6             	mov    %rdx,%rsi
  800c08:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c0d:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c13:	48 f7 d8             	neg    %rax
  800c16:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c1a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c21:	e9 fb 00 00 00       	jmpq   800d21 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c26:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c2a:	be 03 00 00 00       	mov    $0x3,%esi
  800c2f:	48 89 c7             	mov    %rax,%rdi
  800c32:	48 b8 71 04 80 00 00 	movabs $0x800471,%rax
  800c39:	00 00 00 
  800c3c:	ff d0                	callq  *%rax
  800c3e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c42:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c49:	e9 d3 00 00 00       	jmpq   800d21 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800c4e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c52:	be 03 00 00 00       	mov    $0x3,%esi
  800c57:	48 89 c7             	mov    %rax,%rdi
  800c5a:	48 b8 81 05 80 00 00 	movabs $0x800581,%rax
  800c61:	00 00 00 
  800c64:	ff d0                	callq  *%rax
  800c66:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c6e:	48 85 c0             	test   %rax,%rax
  800c71:	79 1d                	jns    800c90 <vprintfmt+0x5ff>
				putch('-', putdat);
  800c73:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7b:	48 89 d6             	mov    %rdx,%rsi
  800c7e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c83:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c89:	48 f7 d8             	neg    %rax
  800c8c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800c90:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c97:	e9 85 00 00 00       	jmpq   800d21 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800c9c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca4:	48 89 d6             	mov    %rdx,%rsi
  800ca7:	bf 30 00 00 00       	mov    $0x30,%edi
  800cac:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cb2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb6:	48 89 d6             	mov    %rdx,%rsi
  800cb9:	bf 78 00 00 00       	mov    $0x78,%edi
  800cbe:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cc0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc3:	83 f8 30             	cmp    $0x30,%eax
  800cc6:	73 17                	jae    800cdf <vprintfmt+0x64e>
  800cc8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ccc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ccf:	89 c0                	mov    %eax,%eax
  800cd1:	48 01 d0             	add    %rdx,%rax
  800cd4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cd7:	83 c2 08             	add    $0x8,%edx
  800cda:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cdd:	eb 0f                	jmp    800cee <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800cdf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ce3:	48 89 d0             	mov    %rdx,%rax
  800ce6:	48 83 c2 08          	add    $0x8,%rdx
  800cea:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cee:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cf1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cf5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cfc:	eb 23                	jmp    800d21 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cfe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d02:	be 03 00 00 00       	mov    $0x3,%esi
  800d07:	48 89 c7             	mov    %rax,%rdi
  800d0a:	48 b8 71 04 80 00 00 	movabs $0x800471,%rax
  800d11:	00 00 00 
  800d14:	ff d0                	callq  *%rax
  800d16:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d1a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d21:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d26:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d29:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d2c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d30:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d34:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d38:	45 89 c1             	mov    %r8d,%r9d
  800d3b:	41 89 f8             	mov    %edi,%r8d
  800d3e:	48 89 c7             	mov    %rax,%rdi
  800d41:	48 b8 b6 03 80 00 00 	movabs $0x8003b6,%rax
  800d48:	00 00 00 
  800d4b:	ff d0                	callq  *%rax
			break;
  800d4d:	eb 3f                	jmp    800d8e <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d4f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d53:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d57:	48 89 d6             	mov    %rdx,%rsi
  800d5a:	89 df                	mov    %ebx,%edi
  800d5c:	ff d0                	callq  *%rax
			break;
  800d5e:	eb 2e                	jmp    800d8e <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d60:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d64:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d68:	48 89 d6             	mov    %rdx,%rsi
  800d6b:	bf 25 00 00 00       	mov    $0x25,%edi
  800d70:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d72:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d77:	eb 05                	jmp    800d7e <vprintfmt+0x6ed>
  800d79:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d7e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d82:	48 83 e8 01          	sub    $0x1,%rax
  800d86:	0f b6 00             	movzbl (%rax),%eax
  800d89:	3c 25                	cmp    $0x25,%al
  800d8b:	75 ec                	jne    800d79 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  800d8d:	90                   	nop
		}
	}
  800d8e:	e9 37 f9 ff ff       	jmpq   8006ca <vprintfmt+0x39>
    va_end(aq);
}
  800d93:	48 83 c4 60          	add    $0x60,%rsp
  800d97:	5b                   	pop    %rbx
  800d98:	41 5c                	pop    %r12
  800d9a:	5d                   	pop    %rbp
  800d9b:	c3                   	retq   

0000000000800d9c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d9c:	55                   	push   %rbp
  800d9d:	48 89 e5             	mov    %rsp,%rbp
  800da0:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800da7:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dae:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800db5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dbc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dc3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dca:	84 c0                	test   %al,%al
  800dcc:	74 20                	je     800dee <printfmt+0x52>
  800dce:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dd2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dd6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dda:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dde:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800de2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800de6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dea:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dee:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800df5:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dfc:	00 00 00 
  800dff:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e06:	00 00 00 
  800e09:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e0d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e14:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e1b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e22:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e29:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e30:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e37:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e3e:	48 89 c7             	mov    %rax,%rdi
  800e41:	48 b8 91 06 80 00 00 	movabs $0x800691,%rax
  800e48:	00 00 00 
  800e4b:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e4d:	c9                   	leaveq 
  800e4e:	c3                   	retq   

0000000000800e4f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e4f:	55                   	push   %rbp
  800e50:	48 89 e5             	mov    %rsp,%rbp
  800e53:	48 83 ec 10          	sub    $0x10,%rsp
  800e57:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e62:	8b 40 10             	mov    0x10(%rax),%eax
  800e65:	8d 50 01             	lea    0x1(%rax),%edx
  800e68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e73:	48 8b 10             	mov    (%rax),%rdx
  800e76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7a:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e7e:	48 39 c2             	cmp    %rax,%rdx
  800e81:	73 17                	jae    800e9a <sprintputch+0x4b>
		*b->buf++ = ch;
  800e83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e87:	48 8b 00             	mov    (%rax),%rax
  800e8a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e8e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e92:	48 89 0a             	mov    %rcx,(%rdx)
  800e95:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e98:	88 10                	mov    %dl,(%rax)
}
  800e9a:	c9                   	leaveq 
  800e9b:	c3                   	retq   

0000000000800e9c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e9c:	55                   	push   %rbp
  800e9d:	48 89 e5             	mov    %rsp,%rbp
  800ea0:	48 83 ec 50          	sub    $0x50,%rsp
  800ea4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ea8:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800eab:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800eaf:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800eb3:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800eb7:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ebb:	48 8b 0a             	mov    (%rdx),%rcx
  800ebe:	48 89 08             	mov    %rcx,(%rax)
  800ec1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ec5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ec9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ecd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ed1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ed5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ed9:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800edc:	48 98                	cltq   
  800ede:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ee2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ee6:	48 01 d0             	add    %rdx,%rax
  800ee9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800eed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ef4:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ef9:	74 06                	je     800f01 <vsnprintf+0x65>
  800efb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800eff:	7f 07                	jg     800f08 <vsnprintf+0x6c>
		return -E_INVAL;
  800f01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f06:	eb 2f                	jmp    800f37 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f08:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f0c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f10:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f14:	48 89 c6             	mov    %rax,%rsi
  800f17:	48 bf 4f 0e 80 00 00 	movabs $0x800e4f,%rdi
  800f1e:	00 00 00 
  800f21:	48 b8 91 06 80 00 00 	movabs $0x800691,%rax
  800f28:	00 00 00 
  800f2b:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f31:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f34:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f37:	c9                   	leaveq 
  800f38:	c3                   	retq   

0000000000800f39 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f39:	55                   	push   %rbp
  800f3a:	48 89 e5             	mov    %rsp,%rbp
  800f3d:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f44:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f4b:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f51:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f58:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f5f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f66:	84 c0                	test   %al,%al
  800f68:	74 20                	je     800f8a <snprintf+0x51>
  800f6a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f6e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f72:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f76:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f7a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f7e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f82:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f86:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f8a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f91:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f98:	00 00 00 
  800f9b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fa2:	00 00 00 
  800fa5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fa9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fb0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fb7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fbe:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fc5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fcc:	48 8b 0a             	mov    (%rdx),%rcx
  800fcf:	48 89 08             	mov    %rcx,(%rax)
  800fd2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fd6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fda:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fde:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fe2:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fe9:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ff0:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800ff6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ffd:	48 89 c7             	mov    %rax,%rdi
  801000:	48 b8 9c 0e 80 00 00 	movabs $0x800e9c,%rax
  801007:	00 00 00 
  80100a:	ff d0                	callq  *%rax
  80100c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801012:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801018:	c9                   	leaveq 
  801019:	c3                   	retq   

000000000080101a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80101a:	55                   	push   %rbp
  80101b:	48 89 e5             	mov    %rsp,%rbp
  80101e:	48 83 ec 18          	sub    $0x18,%rsp
  801022:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801026:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80102d:	eb 09                	jmp    801038 <strlen+0x1e>
		n++;
  80102f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801033:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801038:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103c:	0f b6 00             	movzbl (%rax),%eax
  80103f:	84 c0                	test   %al,%al
  801041:	75 ec                	jne    80102f <strlen+0x15>
		n++;
	return n;
  801043:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801046:	c9                   	leaveq 
  801047:	c3                   	retq   

0000000000801048 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801048:	55                   	push   %rbp
  801049:	48 89 e5             	mov    %rsp,%rbp
  80104c:	48 83 ec 20          	sub    $0x20,%rsp
  801050:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801054:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801058:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80105f:	eb 0e                	jmp    80106f <strnlen+0x27>
		n++;
  801061:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801065:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80106a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80106f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801074:	74 0b                	je     801081 <strnlen+0x39>
  801076:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107a:	0f b6 00             	movzbl (%rax),%eax
  80107d:	84 c0                	test   %al,%al
  80107f:	75 e0                	jne    801061 <strnlen+0x19>
		n++;
	return n;
  801081:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801084:	c9                   	leaveq 
  801085:	c3                   	retq   

0000000000801086 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801086:	55                   	push   %rbp
  801087:	48 89 e5             	mov    %rsp,%rbp
  80108a:	48 83 ec 20          	sub    $0x20,%rsp
  80108e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801092:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801096:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80109e:	90                   	nop
  80109f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010a7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010ab:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010af:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010b3:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010b7:	0f b6 12             	movzbl (%rdx),%edx
  8010ba:	88 10                	mov    %dl,(%rax)
  8010bc:	0f b6 00             	movzbl (%rax),%eax
  8010bf:	84 c0                	test   %al,%al
  8010c1:	75 dc                	jne    80109f <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010c7:	c9                   	leaveq 
  8010c8:	c3                   	retq   

00000000008010c9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010c9:	55                   	push   %rbp
  8010ca:	48 89 e5             	mov    %rsp,%rbp
  8010cd:	48 83 ec 20          	sub    $0x20,%rsp
  8010d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010dd:	48 89 c7             	mov    %rax,%rdi
  8010e0:	48 b8 1a 10 80 00 00 	movabs $0x80101a,%rax
  8010e7:	00 00 00 
  8010ea:	ff d0                	callq  *%rax
  8010ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010f2:	48 63 d0             	movslq %eax,%rdx
  8010f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f9:	48 01 c2             	add    %rax,%rdx
  8010fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801100:	48 89 c6             	mov    %rax,%rsi
  801103:	48 89 d7             	mov    %rdx,%rdi
  801106:	48 b8 86 10 80 00 00 	movabs $0x801086,%rax
  80110d:	00 00 00 
  801110:	ff d0                	callq  *%rax
	return dst;
  801112:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801116:	c9                   	leaveq 
  801117:	c3                   	retq   

0000000000801118 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801118:	55                   	push   %rbp
  801119:	48 89 e5             	mov    %rsp,%rbp
  80111c:	48 83 ec 28          	sub    $0x28,%rsp
  801120:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801124:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801128:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80112c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801130:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801134:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80113b:	00 
  80113c:	eb 2a                	jmp    801168 <strncpy+0x50>
		*dst++ = *src;
  80113e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801142:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801146:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80114a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80114e:	0f b6 12             	movzbl (%rdx),%edx
  801151:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801153:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801157:	0f b6 00             	movzbl (%rax),%eax
  80115a:	84 c0                	test   %al,%al
  80115c:	74 05                	je     801163 <strncpy+0x4b>
			src++;
  80115e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801163:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801168:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801170:	72 cc                	jb     80113e <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801172:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801176:	c9                   	leaveq 
  801177:	c3                   	retq   

0000000000801178 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801178:	55                   	push   %rbp
  801179:	48 89 e5             	mov    %rsp,%rbp
  80117c:	48 83 ec 28          	sub    $0x28,%rsp
  801180:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801184:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801188:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80118c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801190:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801194:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801199:	74 3d                	je     8011d8 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80119b:	eb 1d                	jmp    8011ba <strlcpy+0x42>
			*dst++ = *src++;
  80119d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011a5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011a9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011ad:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011b1:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011b5:	0f b6 12             	movzbl (%rdx),%edx
  8011b8:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011ba:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011bf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011c4:	74 0b                	je     8011d1 <strlcpy+0x59>
  8011c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ca:	0f b6 00             	movzbl (%rax),%eax
  8011cd:	84 c0                	test   %al,%al
  8011cf:	75 cc                	jne    80119d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d5:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e0:	48 29 c2             	sub    %rax,%rdx
  8011e3:	48 89 d0             	mov    %rdx,%rax
}
  8011e6:	c9                   	leaveq 
  8011e7:	c3                   	retq   

00000000008011e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011e8:	55                   	push   %rbp
  8011e9:	48 89 e5             	mov    %rsp,%rbp
  8011ec:	48 83 ec 10          	sub    $0x10,%rsp
  8011f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011f8:	eb 0a                	jmp    801204 <strcmp+0x1c>
		p++, q++;
  8011fa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011ff:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801204:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801208:	0f b6 00             	movzbl (%rax),%eax
  80120b:	84 c0                	test   %al,%al
  80120d:	74 12                	je     801221 <strcmp+0x39>
  80120f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801213:	0f b6 10             	movzbl (%rax),%edx
  801216:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121a:	0f b6 00             	movzbl (%rax),%eax
  80121d:	38 c2                	cmp    %al,%dl
  80121f:	74 d9                	je     8011fa <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801221:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801225:	0f b6 00             	movzbl (%rax),%eax
  801228:	0f b6 d0             	movzbl %al,%edx
  80122b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122f:	0f b6 00             	movzbl (%rax),%eax
  801232:	0f b6 c0             	movzbl %al,%eax
  801235:	29 c2                	sub    %eax,%edx
  801237:	89 d0                	mov    %edx,%eax
}
  801239:	c9                   	leaveq 
  80123a:	c3                   	retq   

000000000080123b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80123b:	55                   	push   %rbp
  80123c:	48 89 e5             	mov    %rsp,%rbp
  80123f:	48 83 ec 18          	sub    $0x18,%rsp
  801243:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801247:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80124b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80124f:	eb 0f                	jmp    801260 <strncmp+0x25>
		n--, p++, q++;
  801251:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801256:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80125b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801260:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801265:	74 1d                	je     801284 <strncmp+0x49>
  801267:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126b:	0f b6 00             	movzbl (%rax),%eax
  80126e:	84 c0                	test   %al,%al
  801270:	74 12                	je     801284 <strncmp+0x49>
  801272:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801276:	0f b6 10             	movzbl (%rax),%edx
  801279:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127d:	0f b6 00             	movzbl (%rax),%eax
  801280:	38 c2                	cmp    %al,%dl
  801282:	74 cd                	je     801251 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801284:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801289:	75 07                	jne    801292 <strncmp+0x57>
		return 0;
  80128b:	b8 00 00 00 00       	mov    $0x0,%eax
  801290:	eb 18                	jmp    8012aa <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801292:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801296:	0f b6 00             	movzbl (%rax),%eax
  801299:	0f b6 d0             	movzbl %al,%edx
  80129c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a0:	0f b6 00             	movzbl (%rax),%eax
  8012a3:	0f b6 c0             	movzbl %al,%eax
  8012a6:	29 c2                	sub    %eax,%edx
  8012a8:	89 d0                	mov    %edx,%eax
}
  8012aa:	c9                   	leaveq 
  8012ab:	c3                   	retq   

00000000008012ac <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012ac:	55                   	push   %rbp
  8012ad:	48 89 e5             	mov    %rsp,%rbp
  8012b0:	48 83 ec 0c          	sub    $0xc,%rsp
  8012b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012b8:	89 f0                	mov    %esi,%eax
  8012ba:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012bd:	eb 17                	jmp    8012d6 <strchr+0x2a>
		if (*s == c)
  8012bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c3:	0f b6 00             	movzbl (%rax),%eax
  8012c6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012c9:	75 06                	jne    8012d1 <strchr+0x25>
			return (char *) s;
  8012cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cf:	eb 15                	jmp    8012e6 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012d1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012da:	0f b6 00             	movzbl (%rax),%eax
  8012dd:	84 c0                	test   %al,%al
  8012df:	75 de                	jne    8012bf <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e6:	c9                   	leaveq 
  8012e7:	c3                   	retq   

00000000008012e8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012e8:	55                   	push   %rbp
  8012e9:	48 89 e5             	mov    %rsp,%rbp
  8012ec:	48 83 ec 0c          	sub    $0xc,%rsp
  8012f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012f4:	89 f0                	mov    %esi,%eax
  8012f6:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012f9:	eb 13                	jmp    80130e <strfind+0x26>
		if (*s == c)
  8012fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ff:	0f b6 00             	movzbl (%rax),%eax
  801302:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801305:	75 02                	jne    801309 <strfind+0x21>
			break;
  801307:	eb 10                	jmp    801319 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801309:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80130e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801312:	0f b6 00             	movzbl (%rax),%eax
  801315:	84 c0                	test   %al,%al
  801317:	75 e2                	jne    8012fb <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801319:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80131d:	c9                   	leaveq 
  80131e:	c3                   	retq   

000000000080131f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80131f:	55                   	push   %rbp
  801320:	48 89 e5             	mov    %rsp,%rbp
  801323:	48 83 ec 18          	sub    $0x18,%rsp
  801327:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80132b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80132e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801332:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801337:	75 06                	jne    80133f <memset+0x20>
		return v;
  801339:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133d:	eb 69                	jmp    8013a8 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80133f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801343:	83 e0 03             	and    $0x3,%eax
  801346:	48 85 c0             	test   %rax,%rax
  801349:	75 48                	jne    801393 <memset+0x74>
  80134b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134f:	83 e0 03             	and    $0x3,%eax
  801352:	48 85 c0             	test   %rax,%rax
  801355:	75 3c                	jne    801393 <memset+0x74>
		c &= 0xFF;
  801357:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80135e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801361:	c1 e0 18             	shl    $0x18,%eax
  801364:	89 c2                	mov    %eax,%edx
  801366:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801369:	c1 e0 10             	shl    $0x10,%eax
  80136c:	09 c2                	or     %eax,%edx
  80136e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801371:	c1 e0 08             	shl    $0x8,%eax
  801374:	09 d0                	or     %edx,%eax
  801376:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801379:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80137d:	48 c1 e8 02          	shr    $0x2,%rax
  801381:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801384:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801388:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80138b:	48 89 d7             	mov    %rdx,%rdi
  80138e:	fc                   	cld    
  80138f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801391:	eb 11                	jmp    8013a4 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801393:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801397:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80139a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80139e:	48 89 d7             	mov    %rdx,%rdi
  8013a1:	fc                   	cld    
  8013a2:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8013a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013a8:	c9                   	leaveq 
  8013a9:	c3                   	retq   

00000000008013aa <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013aa:	55                   	push   %rbp
  8013ab:	48 89 e5             	mov    %rsp,%rbp
  8013ae:	48 83 ec 28          	sub    $0x28,%rsp
  8013b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013d6:	0f 83 88 00 00 00    	jae    801464 <memmove+0xba>
  8013dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e4:	48 01 d0             	add    %rdx,%rax
  8013e7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013eb:	76 77                	jbe    801464 <memmove+0xba>
		s += n;
  8013ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f1:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f9:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801401:	83 e0 03             	and    $0x3,%eax
  801404:	48 85 c0             	test   %rax,%rax
  801407:	75 3b                	jne    801444 <memmove+0x9a>
  801409:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140d:	83 e0 03             	and    $0x3,%eax
  801410:	48 85 c0             	test   %rax,%rax
  801413:	75 2f                	jne    801444 <memmove+0x9a>
  801415:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801419:	83 e0 03             	and    $0x3,%eax
  80141c:	48 85 c0             	test   %rax,%rax
  80141f:	75 23                	jne    801444 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801421:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801425:	48 83 e8 04          	sub    $0x4,%rax
  801429:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80142d:	48 83 ea 04          	sub    $0x4,%rdx
  801431:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801435:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801439:	48 89 c7             	mov    %rax,%rdi
  80143c:	48 89 d6             	mov    %rdx,%rsi
  80143f:	fd                   	std    
  801440:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801442:	eb 1d                	jmp    801461 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801444:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801448:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80144c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801450:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801454:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801458:	48 89 d7             	mov    %rdx,%rdi
  80145b:	48 89 c1             	mov    %rax,%rcx
  80145e:	fd                   	std    
  80145f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801461:	fc                   	cld    
  801462:	eb 57                	jmp    8014bb <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801464:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801468:	83 e0 03             	and    $0x3,%eax
  80146b:	48 85 c0             	test   %rax,%rax
  80146e:	75 36                	jne    8014a6 <memmove+0xfc>
  801470:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801474:	83 e0 03             	and    $0x3,%eax
  801477:	48 85 c0             	test   %rax,%rax
  80147a:	75 2a                	jne    8014a6 <memmove+0xfc>
  80147c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801480:	83 e0 03             	and    $0x3,%eax
  801483:	48 85 c0             	test   %rax,%rax
  801486:	75 1e                	jne    8014a6 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801488:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148c:	48 c1 e8 02          	shr    $0x2,%rax
  801490:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801493:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801497:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80149b:	48 89 c7             	mov    %rax,%rdi
  80149e:	48 89 d6             	mov    %rdx,%rsi
  8014a1:	fc                   	cld    
  8014a2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014a4:	eb 15                	jmp    8014bb <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014aa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ae:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014b2:	48 89 c7             	mov    %rax,%rdi
  8014b5:	48 89 d6             	mov    %rdx,%rsi
  8014b8:	fc                   	cld    
  8014b9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014bf:	c9                   	leaveq 
  8014c0:	c3                   	retq   

00000000008014c1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014c1:	55                   	push   %rbp
  8014c2:	48 89 e5             	mov    %rsp,%rbp
  8014c5:	48 83 ec 18          	sub    $0x18,%rsp
  8014c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014d1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014d9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e1:	48 89 ce             	mov    %rcx,%rsi
  8014e4:	48 89 c7             	mov    %rax,%rdi
  8014e7:	48 b8 aa 13 80 00 00 	movabs $0x8013aa,%rax
  8014ee:	00 00 00 
  8014f1:	ff d0                	callq  *%rax
}
  8014f3:	c9                   	leaveq 
  8014f4:	c3                   	retq   

00000000008014f5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014f5:	55                   	push   %rbp
  8014f6:	48 89 e5             	mov    %rsp,%rbp
  8014f9:	48 83 ec 28          	sub    $0x28,%rsp
  8014fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801501:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801505:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801511:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801515:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801519:	eb 36                	jmp    801551 <memcmp+0x5c>
		if (*s1 != *s2)
  80151b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151f:	0f b6 10             	movzbl (%rax),%edx
  801522:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801526:	0f b6 00             	movzbl (%rax),%eax
  801529:	38 c2                	cmp    %al,%dl
  80152b:	74 1a                	je     801547 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80152d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801531:	0f b6 00             	movzbl (%rax),%eax
  801534:	0f b6 d0             	movzbl %al,%edx
  801537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80153b:	0f b6 00             	movzbl (%rax),%eax
  80153e:	0f b6 c0             	movzbl %al,%eax
  801541:	29 c2                	sub    %eax,%edx
  801543:	89 d0                	mov    %edx,%eax
  801545:	eb 20                	jmp    801567 <memcmp+0x72>
		s1++, s2++;
  801547:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80154c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801551:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801555:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801559:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80155d:	48 85 c0             	test   %rax,%rax
  801560:	75 b9                	jne    80151b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801562:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801567:	c9                   	leaveq 
  801568:	c3                   	retq   

0000000000801569 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801569:	55                   	push   %rbp
  80156a:	48 89 e5             	mov    %rsp,%rbp
  80156d:	48 83 ec 28          	sub    $0x28,%rsp
  801571:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801575:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801578:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80157c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801580:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801584:	48 01 d0             	add    %rdx,%rax
  801587:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80158b:	eb 15                	jmp    8015a2 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80158d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801591:	0f b6 10             	movzbl (%rax),%edx
  801594:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801597:	38 c2                	cmp    %al,%dl
  801599:	75 02                	jne    80159d <memfind+0x34>
			break;
  80159b:	eb 0f                	jmp    8015ac <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80159d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a6:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015aa:	72 e1                	jb     80158d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015b0:	c9                   	leaveq 
  8015b1:	c3                   	retq   

00000000008015b2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015b2:	55                   	push   %rbp
  8015b3:	48 89 e5             	mov    %rsp,%rbp
  8015b6:	48 83 ec 34          	sub    $0x34,%rsp
  8015ba:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015be:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015c2:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015cc:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015d3:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015d4:	eb 05                	jmp    8015db <strtol+0x29>
		s++;
  8015d6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015df:	0f b6 00             	movzbl (%rax),%eax
  8015e2:	3c 20                	cmp    $0x20,%al
  8015e4:	74 f0                	je     8015d6 <strtol+0x24>
  8015e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ea:	0f b6 00             	movzbl (%rax),%eax
  8015ed:	3c 09                	cmp    $0x9,%al
  8015ef:	74 e5                	je     8015d6 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f5:	0f b6 00             	movzbl (%rax),%eax
  8015f8:	3c 2b                	cmp    $0x2b,%al
  8015fa:	75 07                	jne    801603 <strtol+0x51>
		s++;
  8015fc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801601:	eb 17                	jmp    80161a <strtol+0x68>
	else if (*s == '-')
  801603:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801607:	0f b6 00             	movzbl (%rax),%eax
  80160a:	3c 2d                	cmp    $0x2d,%al
  80160c:	75 0c                	jne    80161a <strtol+0x68>
		s++, neg = 1;
  80160e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801613:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80161a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80161e:	74 06                	je     801626 <strtol+0x74>
  801620:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801624:	75 28                	jne    80164e <strtol+0x9c>
  801626:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162a:	0f b6 00             	movzbl (%rax),%eax
  80162d:	3c 30                	cmp    $0x30,%al
  80162f:	75 1d                	jne    80164e <strtol+0x9c>
  801631:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801635:	48 83 c0 01          	add    $0x1,%rax
  801639:	0f b6 00             	movzbl (%rax),%eax
  80163c:	3c 78                	cmp    $0x78,%al
  80163e:	75 0e                	jne    80164e <strtol+0x9c>
		s += 2, base = 16;
  801640:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801645:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80164c:	eb 2c                	jmp    80167a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80164e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801652:	75 19                	jne    80166d <strtol+0xbb>
  801654:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801658:	0f b6 00             	movzbl (%rax),%eax
  80165b:	3c 30                	cmp    $0x30,%al
  80165d:	75 0e                	jne    80166d <strtol+0xbb>
		s++, base = 8;
  80165f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801664:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80166b:	eb 0d                	jmp    80167a <strtol+0xc8>
	else if (base == 0)
  80166d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801671:	75 07                	jne    80167a <strtol+0xc8>
		base = 10;
  801673:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80167a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167e:	0f b6 00             	movzbl (%rax),%eax
  801681:	3c 2f                	cmp    $0x2f,%al
  801683:	7e 1d                	jle    8016a2 <strtol+0xf0>
  801685:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801689:	0f b6 00             	movzbl (%rax),%eax
  80168c:	3c 39                	cmp    $0x39,%al
  80168e:	7f 12                	jg     8016a2 <strtol+0xf0>
			dig = *s - '0';
  801690:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801694:	0f b6 00             	movzbl (%rax),%eax
  801697:	0f be c0             	movsbl %al,%eax
  80169a:	83 e8 30             	sub    $0x30,%eax
  80169d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016a0:	eb 4e                	jmp    8016f0 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a6:	0f b6 00             	movzbl (%rax),%eax
  8016a9:	3c 60                	cmp    $0x60,%al
  8016ab:	7e 1d                	jle    8016ca <strtol+0x118>
  8016ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b1:	0f b6 00             	movzbl (%rax),%eax
  8016b4:	3c 7a                	cmp    $0x7a,%al
  8016b6:	7f 12                	jg     8016ca <strtol+0x118>
			dig = *s - 'a' + 10;
  8016b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bc:	0f b6 00             	movzbl (%rax),%eax
  8016bf:	0f be c0             	movsbl %al,%eax
  8016c2:	83 e8 57             	sub    $0x57,%eax
  8016c5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016c8:	eb 26                	jmp    8016f0 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ce:	0f b6 00             	movzbl (%rax),%eax
  8016d1:	3c 40                	cmp    $0x40,%al
  8016d3:	7e 48                	jle    80171d <strtol+0x16b>
  8016d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d9:	0f b6 00             	movzbl (%rax),%eax
  8016dc:	3c 5a                	cmp    $0x5a,%al
  8016de:	7f 3d                	jg     80171d <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e4:	0f b6 00             	movzbl (%rax),%eax
  8016e7:	0f be c0             	movsbl %al,%eax
  8016ea:	83 e8 37             	sub    $0x37,%eax
  8016ed:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016f3:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016f6:	7c 02                	jl     8016fa <strtol+0x148>
			break;
  8016f8:	eb 23                	jmp    80171d <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016fa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016ff:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801702:	48 98                	cltq   
  801704:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801709:	48 89 c2             	mov    %rax,%rdx
  80170c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80170f:	48 98                	cltq   
  801711:	48 01 d0             	add    %rdx,%rax
  801714:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801718:	e9 5d ff ff ff       	jmpq   80167a <strtol+0xc8>

	if (endptr)
  80171d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801722:	74 0b                	je     80172f <strtol+0x17d>
		*endptr = (char *) s;
  801724:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801728:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80172c:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80172f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801733:	74 09                	je     80173e <strtol+0x18c>
  801735:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801739:	48 f7 d8             	neg    %rax
  80173c:	eb 04                	jmp    801742 <strtol+0x190>
  80173e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801742:	c9                   	leaveq 
  801743:	c3                   	retq   

0000000000801744 <strstr>:

char * strstr(const char *in, const char *str)
{
  801744:	55                   	push   %rbp
  801745:	48 89 e5             	mov    %rsp,%rbp
  801748:	48 83 ec 30          	sub    $0x30,%rsp
  80174c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801750:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801754:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801758:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80175c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801760:	0f b6 00             	movzbl (%rax),%eax
  801763:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801766:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80176a:	75 06                	jne    801772 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  80176c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801770:	eb 6b                	jmp    8017dd <strstr+0x99>

    len = strlen(str);
  801772:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801776:	48 89 c7             	mov    %rax,%rdi
  801779:	48 b8 1a 10 80 00 00 	movabs $0x80101a,%rax
  801780:	00 00 00 
  801783:	ff d0                	callq  *%rax
  801785:	48 98                	cltq   
  801787:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80178b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801793:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801797:	0f b6 00             	movzbl (%rax),%eax
  80179a:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  80179d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017a1:	75 07                	jne    8017aa <strstr+0x66>
                return (char *) 0;
  8017a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a8:	eb 33                	jmp    8017dd <strstr+0x99>
        } while (sc != c);
  8017aa:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017ae:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017b1:	75 d8                	jne    80178b <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  8017b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017b7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bf:	48 89 ce             	mov    %rcx,%rsi
  8017c2:	48 89 c7             	mov    %rax,%rdi
  8017c5:	48 b8 3b 12 80 00 00 	movabs $0x80123b,%rax
  8017cc:	00 00 00 
  8017cf:	ff d0                	callq  *%rax
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	75 b6                	jne    80178b <strstr+0x47>

    return (char *) (in - 1);
  8017d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d9:	48 83 e8 01          	sub    $0x1,%rax
}
  8017dd:	c9                   	leaveq 
  8017de:	c3                   	retq   

00000000008017df <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017df:	55                   	push   %rbp
  8017e0:	48 89 e5             	mov    %rsp,%rbp
  8017e3:	53                   	push   %rbx
  8017e4:	48 83 ec 48          	sub    $0x48,%rsp
  8017e8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017eb:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017ee:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017f2:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017f6:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017fa:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017fe:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801801:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801805:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801809:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80180d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801811:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801815:	4c 89 c3             	mov    %r8,%rbx
  801818:	cd 30                	int    $0x30
  80181a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  80181e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801822:	74 3e                	je     801862 <syscall+0x83>
  801824:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801829:	7e 37                	jle    801862 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80182b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80182f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801832:	49 89 d0             	mov    %rdx,%r8
  801835:	89 c1                	mov    %eax,%ecx
  801837:	48 ba c0 3a 80 00 00 	movabs $0x803ac0,%rdx
  80183e:	00 00 00 
  801841:	be 23 00 00 00       	mov    $0x23,%esi
  801846:	48 bf dd 3a 80 00 00 	movabs $0x803add,%rdi
  80184d:	00 00 00 
  801850:	b8 00 00 00 00       	mov    $0x0,%eax
  801855:	49 b9 1e 32 80 00 00 	movabs $0x80321e,%r9
  80185c:	00 00 00 
  80185f:	41 ff d1             	callq  *%r9

	return ret;
  801862:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801866:	48 83 c4 48          	add    $0x48,%rsp
  80186a:	5b                   	pop    %rbx
  80186b:	5d                   	pop    %rbp
  80186c:	c3                   	retq   

000000000080186d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80186d:	55                   	push   %rbp
  80186e:	48 89 e5             	mov    %rsp,%rbp
  801871:	48 83 ec 20          	sub    $0x20,%rsp
  801875:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801879:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80187d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801881:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801885:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80188c:	00 
  80188d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801893:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801899:	48 89 d1             	mov    %rdx,%rcx
  80189c:	48 89 c2             	mov    %rax,%rdx
  80189f:	be 00 00 00 00       	mov    $0x0,%esi
  8018a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8018a9:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  8018b0:	00 00 00 
  8018b3:	ff d0                	callq  *%rax
}
  8018b5:	c9                   	leaveq 
  8018b6:	c3                   	retq   

00000000008018b7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018b7:	55                   	push   %rbp
  8018b8:	48 89 e5             	mov    %rsp,%rbp
  8018bb:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018bf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c6:	00 
  8018c7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018cd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018dd:	be 00 00 00 00       	mov    $0x0,%esi
  8018e2:	bf 01 00 00 00       	mov    $0x1,%edi
  8018e7:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  8018ee:	00 00 00 
  8018f1:	ff d0                	callq  *%rax
}
  8018f3:	c9                   	leaveq 
  8018f4:	c3                   	retq   

00000000008018f5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018f5:	55                   	push   %rbp
  8018f6:	48 89 e5             	mov    %rsp,%rbp
  8018f9:	48 83 ec 10          	sub    $0x10,%rsp
  8018fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801900:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801903:	48 98                	cltq   
  801905:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80190c:	00 
  80190d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801913:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801919:	b9 00 00 00 00       	mov    $0x0,%ecx
  80191e:	48 89 c2             	mov    %rax,%rdx
  801921:	be 01 00 00 00       	mov    $0x1,%esi
  801926:	bf 03 00 00 00       	mov    $0x3,%edi
  80192b:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  801932:	00 00 00 
  801935:	ff d0                	callq  *%rax
}
  801937:	c9                   	leaveq 
  801938:	c3                   	retq   

0000000000801939 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801939:	55                   	push   %rbp
  80193a:	48 89 e5             	mov    %rsp,%rbp
  80193d:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801941:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801948:	00 
  801949:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80194f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801955:	b9 00 00 00 00       	mov    $0x0,%ecx
  80195a:	ba 00 00 00 00       	mov    $0x0,%edx
  80195f:	be 00 00 00 00       	mov    $0x0,%esi
  801964:	bf 02 00 00 00       	mov    $0x2,%edi
  801969:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  801970:	00 00 00 
  801973:	ff d0                	callq  *%rax
}
  801975:	c9                   	leaveq 
  801976:	c3                   	retq   

0000000000801977 <sys_yield>:

void
sys_yield(void)
{
  801977:	55                   	push   %rbp
  801978:	48 89 e5             	mov    %rsp,%rbp
  80197b:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80197f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801986:	00 
  801987:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801993:	b9 00 00 00 00       	mov    $0x0,%ecx
  801998:	ba 00 00 00 00       	mov    $0x0,%edx
  80199d:	be 00 00 00 00       	mov    $0x0,%esi
  8019a2:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019a7:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  8019ae:	00 00 00 
  8019b1:	ff d0                	callq  *%rax
}
  8019b3:	c9                   	leaveq 
  8019b4:	c3                   	retq   

00000000008019b5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019b5:	55                   	push   %rbp
  8019b6:	48 89 e5             	mov    %rsp,%rbp
  8019b9:	48 83 ec 20          	sub    $0x20,%rsp
  8019bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019c4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019ca:	48 63 c8             	movslq %eax,%rcx
  8019cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d4:	48 98                	cltq   
  8019d6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019dd:	00 
  8019de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e4:	49 89 c8             	mov    %rcx,%r8
  8019e7:	48 89 d1             	mov    %rdx,%rcx
  8019ea:	48 89 c2             	mov    %rax,%rdx
  8019ed:	be 01 00 00 00       	mov    $0x1,%esi
  8019f2:	bf 04 00 00 00       	mov    $0x4,%edi
  8019f7:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  8019fe:	00 00 00 
  801a01:	ff d0                	callq  *%rax
}
  801a03:	c9                   	leaveq 
  801a04:	c3                   	retq   

0000000000801a05 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a05:	55                   	push   %rbp
  801a06:	48 89 e5             	mov    %rsp,%rbp
  801a09:	48 83 ec 30          	sub    $0x30,%rsp
  801a0d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a10:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a14:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a17:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a1b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a1f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a22:	48 63 c8             	movslq %eax,%rcx
  801a25:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a29:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a2c:	48 63 f0             	movslq %eax,%rsi
  801a2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a36:	48 98                	cltq   
  801a38:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a3c:	49 89 f9             	mov    %rdi,%r9
  801a3f:	49 89 f0             	mov    %rsi,%r8
  801a42:	48 89 d1             	mov    %rdx,%rcx
  801a45:	48 89 c2             	mov    %rax,%rdx
  801a48:	be 01 00 00 00       	mov    $0x1,%esi
  801a4d:	bf 05 00 00 00       	mov    $0x5,%edi
  801a52:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  801a59:	00 00 00 
  801a5c:	ff d0                	callq  *%rax
}
  801a5e:	c9                   	leaveq 
  801a5f:	c3                   	retq   

0000000000801a60 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a60:	55                   	push   %rbp
  801a61:	48 89 e5             	mov    %rsp,%rbp
  801a64:	48 83 ec 20          	sub    $0x20,%rsp
  801a68:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a6b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a6f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a76:	48 98                	cltq   
  801a78:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a7f:	00 
  801a80:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a86:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a8c:	48 89 d1             	mov    %rdx,%rcx
  801a8f:	48 89 c2             	mov    %rax,%rdx
  801a92:	be 01 00 00 00       	mov    $0x1,%esi
  801a97:	bf 06 00 00 00       	mov    $0x6,%edi
  801a9c:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  801aa3:	00 00 00 
  801aa6:	ff d0                	callq  *%rax
}
  801aa8:	c9                   	leaveq 
  801aa9:	c3                   	retq   

0000000000801aaa <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801aaa:	55                   	push   %rbp
  801aab:	48 89 e5             	mov    %rsp,%rbp
  801aae:	48 83 ec 10          	sub    $0x10,%rsp
  801ab2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ab5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ab8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801abb:	48 63 d0             	movslq %eax,%rdx
  801abe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac1:	48 98                	cltq   
  801ac3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aca:	00 
  801acb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad7:	48 89 d1             	mov    %rdx,%rcx
  801ada:	48 89 c2             	mov    %rax,%rdx
  801add:	be 01 00 00 00       	mov    $0x1,%esi
  801ae2:	bf 08 00 00 00       	mov    $0x8,%edi
  801ae7:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  801aee:	00 00 00 
  801af1:	ff d0                	callq  *%rax
}
  801af3:	c9                   	leaveq 
  801af4:	c3                   	retq   

0000000000801af5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801af5:	55                   	push   %rbp
  801af6:	48 89 e5             	mov    %rsp,%rbp
  801af9:	48 83 ec 20          	sub    $0x20,%rsp
  801afd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b04:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b0b:	48 98                	cltq   
  801b0d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b14:	00 
  801b15:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b21:	48 89 d1             	mov    %rdx,%rcx
  801b24:	48 89 c2             	mov    %rax,%rdx
  801b27:	be 01 00 00 00       	mov    $0x1,%esi
  801b2c:	bf 09 00 00 00       	mov    $0x9,%edi
  801b31:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  801b38:	00 00 00 
  801b3b:	ff d0                	callq  *%rax
}
  801b3d:	c9                   	leaveq 
  801b3e:	c3                   	retq   

0000000000801b3f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b3f:	55                   	push   %rbp
  801b40:	48 89 e5             	mov    %rsp,%rbp
  801b43:	48 83 ec 20          	sub    $0x20,%rsp
  801b47:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b4e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b55:	48 98                	cltq   
  801b57:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b5e:	00 
  801b5f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b65:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b6b:	48 89 d1             	mov    %rdx,%rcx
  801b6e:	48 89 c2             	mov    %rax,%rdx
  801b71:	be 01 00 00 00       	mov    $0x1,%esi
  801b76:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b7b:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  801b82:	00 00 00 
  801b85:	ff d0                	callq  *%rax
}
  801b87:	c9                   	leaveq 
  801b88:	c3                   	retq   

0000000000801b89 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b89:	55                   	push   %rbp
  801b8a:	48 89 e5             	mov    %rsp,%rbp
  801b8d:	48 83 ec 20          	sub    $0x20,%rsp
  801b91:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b94:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b98:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b9c:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ba2:	48 63 f0             	movslq %eax,%rsi
  801ba5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ba9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bac:	48 98                	cltq   
  801bae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb9:	00 
  801bba:	49 89 f1             	mov    %rsi,%r9
  801bbd:	49 89 c8             	mov    %rcx,%r8
  801bc0:	48 89 d1             	mov    %rdx,%rcx
  801bc3:	48 89 c2             	mov    %rax,%rdx
  801bc6:	be 00 00 00 00       	mov    $0x0,%esi
  801bcb:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bd0:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  801bd7:	00 00 00 
  801bda:	ff d0                	callq  *%rax
}
  801bdc:	c9                   	leaveq 
  801bdd:	c3                   	retq   

0000000000801bde <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bde:	55                   	push   %rbp
  801bdf:	48 89 e5             	mov    %rsp,%rbp
  801be2:	48 83 ec 10          	sub    $0x10,%rsp
  801be6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bee:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf5:	00 
  801bf6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bfc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c02:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c07:	48 89 c2             	mov    %rax,%rdx
  801c0a:	be 01 00 00 00       	mov    $0x1,%esi
  801c0f:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c14:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  801c1b:	00 00 00 
  801c1e:	ff d0                	callq  *%rax
}
  801c20:	c9                   	leaveq 
  801c21:	c3                   	retq   

0000000000801c22 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c22:	55                   	push   %rbp
  801c23:	48 89 e5             	mov    %rsp,%rbp
  801c26:	48 83 ec 08          	sub    $0x8,%rsp
  801c2a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c2e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c32:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801c39:	ff ff ff 
  801c3c:	48 01 d0             	add    %rdx,%rax
  801c3f:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801c43:	c9                   	leaveq 
  801c44:	c3                   	retq   

0000000000801c45 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801c45:	55                   	push   %rbp
  801c46:	48 89 e5             	mov    %rsp,%rbp
  801c49:	48 83 ec 08          	sub    $0x8,%rsp
  801c4d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801c51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c55:	48 89 c7             	mov    %rax,%rdi
  801c58:	48 b8 22 1c 80 00 00 	movabs $0x801c22,%rax
  801c5f:	00 00 00 
  801c62:	ff d0                	callq  *%rax
  801c64:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801c6a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801c6e:	c9                   	leaveq 
  801c6f:	c3                   	retq   

0000000000801c70 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c70:	55                   	push   %rbp
  801c71:	48 89 e5             	mov    %rsp,%rbp
  801c74:	48 83 ec 18          	sub    $0x18,%rsp
  801c78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c83:	eb 6b                	jmp    801cf0 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801c85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c88:	48 98                	cltq   
  801c8a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c90:	48 c1 e0 0c          	shl    $0xc,%rax
  801c94:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801c98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c9c:	48 c1 e8 15          	shr    $0x15,%rax
  801ca0:	48 89 c2             	mov    %rax,%rdx
  801ca3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801caa:	01 00 00 
  801cad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cb1:	83 e0 01             	and    $0x1,%eax
  801cb4:	48 85 c0             	test   %rax,%rax
  801cb7:	74 21                	je     801cda <fd_alloc+0x6a>
  801cb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cbd:	48 c1 e8 0c          	shr    $0xc,%rax
  801cc1:	48 89 c2             	mov    %rax,%rdx
  801cc4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ccb:	01 00 00 
  801cce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cd2:	83 e0 01             	and    $0x1,%eax
  801cd5:	48 85 c0             	test   %rax,%rax
  801cd8:	75 12                	jne    801cec <fd_alloc+0x7c>
			*fd_store = fd;
  801cda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cde:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cea:	eb 1a                	jmp    801d06 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801cec:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801cf0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801cf4:	7e 8f                	jle    801c85 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801cf6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cfa:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d01:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d06:	c9                   	leaveq 
  801d07:	c3                   	retq   

0000000000801d08 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d08:	55                   	push   %rbp
  801d09:	48 89 e5             	mov    %rsp,%rbp
  801d0c:	48 83 ec 20          	sub    $0x20,%rsp
  801d10:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d13:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d17:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d1b:	78 06                	js     801d23 <fd_lookup+0x1b>
  801d1d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d21:	7e 07                	jle    801d2a <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d28:	eb 6c                	jmp    801d96 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801d2a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d2d:	48 98                	cltq   
  801d2f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d35:	48 c1 e0 0c          	shl    $0xc,%rax
  801d39:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d41:	48 c1 e8 15          	shr    $0x15,%rax
  801d45:	48 89 c2             	mov    %rax,%rdx
  801d48:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d4f:	01 00 00 
  801d52:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d56:	83 e0 01             	and    $0x1,%eax
  801d59:	48 85 c0             	test   %rax,%rax
  801d5c:	74 21                	je     801d7f <fd_lookup+0x77>
  801d5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d62:	48 c1 e8 0c          	shr    $0xc,%rax
  801d66:	48 89 c2             	mov    %rax,%rdx
  801d69:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d70:	01 00 00 
  801d73:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d77:	83 e0 01             	and    $0x1,%eax
  801d7a:	48 85 c0             	test   %rax,%rax
  801d7d:	75 07                	jne    801d86 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d7f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d84:	eb 10                	jmp    801d96 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801d86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d8a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d8e:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801d91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d96:	c9                   	leaveq 
  801d97:	c3                   	retq   

0000000000801d98 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801d98:	55                   	push   %rbp
  801d99:	48 89 e5             	mov    %rsp,%rbp
  801d9c:	48 83 ec 30          	sub    $0x30,%rsp
  801da0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801da4:	89 f0                	mov    %esi,%eax
  801da6:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801da9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dad:	48 89 c7             	mov    %rax,%rdi
  801db0:	48 b8 22 1c 80 00 00 	movabs $0x801c22,%rax
  801db7:	00 00 00 
  801dba:	ff d0                	callq  *%rax
  801dbc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801dc0:	48 89 d6             	mov    %rdx,%rsi
  801dc3:	89 c7                	mov    %eax,%edi
  801dc5:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  801dcc:	00 00 00 
  801dcf:	ff d0                	callq  *%rax
  801dd1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dd4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dd8:	78 0a                	js     801de4 <fd_close+0x4c>
	    || fd != fd2)
  801dda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dde:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801de2:	74 12                	je     801df6 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801de4:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801de8:	74 05                	je     801def <fd_close+0x57>
  801dea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ded:	eb 05                	jmp    801df4 <fd_close+0x5c>
  801def:	b8 00 00 00 00       	mov    $0x0,%eax
  801df4:	eb 69                	jmp    801e5f <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801df6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dfa:	8b 00                	mov    (%rax),%eax
  801dfc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e00:	48 89 d6             	mov    %rdx,%rsi
  801e03:	89 c7                	mov    %eax,%edi
  801e05:	48 b8 61 1e 80 00 00 	movabs $0x801e61,%rax
  801e0c:	00 00 00 
  801e0f:	ff d0                	callq  *%rax
  801e11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e18:	78 2a                	js     801e44 <fd_close+0xac>
		if (dev->dev_close)
  801e1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1e:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e22:	48 85 c0             	test   %rax,%rax
  801e25:	74 16                	je     801e3d <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801e27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e2b:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e2f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801e33:	48 89 d7             	mov    %rdx,%rdi
  801e36:	ff d0                	callq  *%rax
  801e38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e3b:	eb 07                	jmp    801e44 <fd_close+0xac>
		else
			r = 0;
  801e3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e48:	48 89 c6             	mov    %rax,%rsi
  801e4b:	bf 00 00 00 00       	mov    $0x0,%edi
  801e50:	48 b8 60 1a 80 00 00 	movabs $0x801a60,%rax
  801e57:	00 00 00 
  801e5a:	ff d0                	callq  *%rax
	return r;
  801e5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e5f:	c9                   	leaveq 
  801e60:	c3                   	retq   

0000000000801e61 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e61:	55                   	push   %rbp
  801e62:	48 89 e5             	mov    %rsp,%rbp
  801e65:	48 83 ec 20          	sub    $0x20,%rsp
  801e69:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e6c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801e70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e77:	eb 41                	jmp    801eba <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801e79:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801e80:	00 00 00 
  801e83:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e86:	48 63 d2             	movslq %edx,%rdx
  801e89:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e8d:	8b 00                	mov    (%rax),%eax
  801e8f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801e92:	75 22                	jne    801eb6 <dev_lookup+0x55>
			*dev = devtab[i];
  801e94:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801e9b:	00 00 00 
  801e9e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ea1:	48 63 d2             	movslq %edx,%rdx
  801ea4:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801ea8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eac:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb4:	eb 60                	jmp    801f16 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801eb6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801eba:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801ec1:	00 00 00 
  801ec4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ec7:	48 63 d2             	movslq %edx,%rdx
  801eca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ece:	48 85 c0             	test   %rax,%rax
  801ed1:	75 a6                	jne    801e79 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ed3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801eda:	00 00 00 
  801edd:	48 8b 00             	mov    (%rax),%rax
  801ee0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801ee6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ee9:	89 c6                	mov    %eax,%esi
  801eeb:	48 bf f0 3a 80 00 00 	movabs $0x803af0,%rdi
  801ef2:	00 00 00 
  801ef5:	b8 00 00 00 00       	mov    $0x0,%eax
  801efa:	48 b9 de 02 80 00 00 	movabs $0x8002de,%rcx
  801f01:	00 00 00 
  801f04:	ff d1                	callq  *%rcx
	*dev = 0;
  801f06:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f0a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f11:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f16:	c9                   	leaveq 
  801f17:	c3                   	retq   

0000000000801f18 <close>:

int
close(int fdnum)
{
  801f18:	55                   	push   %rbp
  801f19:	48 89 e5             	mov    %rsp,%rbp
  801f1c:	48 83 ec 20          	sub    $0x20,%rsp
  801f20:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f23:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f27:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f2a:	48 89 d6             	mov    %rdx,%rsi
  801f2d:	89 c7                	mov    %eax,%edi
  801f2f:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  801f36:	00 00 00 
  801f39:	ff d0                	callq  *%rax
  801f3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f42:	79 05                	jns    801f49 <close+0x31>
		return r;
  801f44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f47:	eb 18                	jmp    801f61 <close+0x49>
	else
		return fd_close(fd, 1);
  801f49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f4d:	be 01 00 00 00       	mov    $0x1,%esi
  801f52:	48 89 c7             	mov    %rax,%rdi
  801f55:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  801f5c:	00 00 00 
  801f5f:	ff d0                	callq  *%rax
}
  801f61:	c9                   	leaveq 
  801f62:	c3                   	retq   

0000000000801f63 <close_all>:

void
close_all(void)
{
  801f63:	55                   	push   %rbp
  801f64:	48 89 e5             	mov    %rsp,%rbp
  801f67:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f72:	eb 15                	jmp    801f89 <close_all+0x26>
		close(i);
  801f74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f77:	89 c7                	mov    %eax,%edi
  801f79:	48 b8 18 1f 80 00 00 	movabs $0x801f18,%rax
  801f80:	00 00 00 
  801f83:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801f85:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f89:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f8d:	7e e5                	jle    801f74 <close_all+0x11>
		close(i);
}
  801f8f:	c9                   	leaveq 
  801f90:	c3                   	retq   

0000000000801f91 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f91:	55                   	push   %rbp
  801f92:	48 89 e5             	mov    %rsp,%rbp
  801f95:	48 83 ec 40          	sub    $0x40,%rsp
  801f99:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801f9c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801f9f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801fa3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801fa6:	48 89 d6             	mov    %rdx,%rsi
  801fa9:	89 c7                	mov    %eax,%edi
  801fab:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  801fb2:	00 00 00 
  801fb5:	ff d0                	callq  *%rax
  801fb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fbe:	79 08                	jns    801fc8 <dup+0x37>
		return r;
  801fc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fc3:	e9 70 01 00 00       	jmpq   802138 <dup+0x1a7>
	close(newfdnum);
  801fc8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fcb:	89 c7                	mov    %eax,%edi
  801fcd:	48 b8 18 1f 80 00 00 	movabs $0x801f18,%rax
  801fd4:	00 00 00 
  801fd7:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801fd9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fdc:	48 98                	cltq   
  801fde:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fe4:	48 c1 e0 0c          	shl    $0xc,%rax
  801fe8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801fec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff0:	48 89 c7             	mov    %rax,%rdi
  801ff3:	48 b8 45 1c 80 00 00 	movabs $0x801c45,%rax
  801ffa:	00 00 00 
  801ffd:	ff d0                	callq  *%rax
  801fff:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802003:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802007:	48 89 c7             	mov    %rax,%rdi
  80200a:	48 b8 45 1c 80 00 00 	movabs $0x801c45,%rax
  802011:	00 00 00 
  802014:	ff d0                	callq  *%rax
  802016:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80201a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80201e:	48 c1 e8 15          	shr    $0x15,%rax
  802022:	48 89 c2             	mov    %rax,%rdx
  802025:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80202c:	01 00 00 
  80202f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802033:	83 e0 01             	and    $0x1,%eax
  802036:	48 85 c0             	test   %rax,%rax
  802039:	74 73                	je     8020ae <dup+0x11d>
  80203b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80203f:	48 c1 e8 0c          	shr    $0xc,%rax
  802043:	48 89 c2             	mov    %rax,%rdx
  802046:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80204d:	01 00 00 
  802050:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802054:	83 e0 01             	and    $0x1,%eax
  802057:	48 85 c0             	test   %rax,%rax
  80205a:	74 52                	je     8020ae <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80205c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802060:	48 c1 e8 0c          	shr    $0xc,%rax
  802064:	48 89 c2             	mov    %rax,%rdx
  802067:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80206e:	01 00 00 
  802071:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802075:	25 07 0e 00 00       	and    $0xe07,%eax
  80207a:	89 c1                	mov    %eax,%ecx
  80207c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802080:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802084:	41 89 c8             	mov    %ecx,%r8d
  802087:	48 89 d1             	mov    %rdx,%rcx
  80208a:	ba 00 00 00 00       	mov    $0x0,%edx
  80208f:	48 89 c6             	mov    %rax,%rsi
  802092:	bf 00 00 00 00       	mov    $0x0,%edi
  802097:	48 b8 05 1a 80 00 00 	movabs $0x801a05,%rax
  80209e:	00 00 00 
  8020a1:	ff d0                	callq  *%rax
  8020a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020aa:	79 02                	jns    8020ae <dup+0x11d>
			goto err;
  8020ac:	eb 57                	jmp    802105 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8020ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b2:	48 c1 e8 0c          	shr    $0xc,%rax
  8020b6:	48 89 c2             	mov    %rax,%rdx
  8020b9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020c0:	01 00 00 
  8020c3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8020cc:	89 c1                	mov    %eax,%ecx
  8020ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020d6:	41 89 c8             	mov    %ecx,%r8d
  8020d9:	48 89 d1             	mov    %rdx,%rcx
  8020dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e1:	48 89 c6             	mov    %rax,%rsi
  8020e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8020e9:	48 b8 05 1a 80 00 00 	movabs $0x801a05,%rax
  8020f0:	00 00 00 
  8020f3:	ff d0                	callq  *%rax
  8020f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020fc:	79 02                	jns    802100 <dup+0x16f>
		goto err;
  8020fe:	eb 05                	jmp    802105 <dup+0x174>

	return newfdnum;
  802100:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802103:	eb 33                	jmp    802138 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802105:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802109:	48 89 c6             	mov    %rax,%rsi
  80210c:	bf 00 00 00 00       	mov    $0x0,%edi
  802111:	48 b8 60 1a 80 00 00 	movabs $0x801a60,%rax
  802118:	00 00 00 
  80211b:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80211d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802121:	48 89 c6             	mov    %rax,%rsi
  802124:	bf 00 00 00 00       	mov    $0x0,%edi
  802129:	48 b8 60 1a 80 00 00 	movabs $0x801a60,%rax
  802130:	00 00 00 
  802133:	ff d0                	callq  *%rax
	return r;
  802135:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802138:	c9                   	leaveq 
  802139:	c3                   	retq   

000000000080213a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80213a:	55                   	push   %rbp
  80213b:	48 89 e5             	mov    %rsp,%rbp
  80213e:	48 83 ec 40          	sub    $0x40,%rsp
  802142:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802145:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802149:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80214d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802151:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802154:	48 89 d6             	mov    %rdx,%rsi
  802157:	89 c7                	mov    %eax,%edi
  802159:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  802160:	00 00 00 
  802163:	ff d0                	callq  *%rax
  802165:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802168:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80216c:	78 24                	js     802192 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80216e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802172:	8b 00                	mov    (%rax),%eax
  802174:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802178:	48 89 d6             	mov    %rdx,%rsi
  80217b:	89 c7                	mov    %eax,%edi
  80217d:	48 b8 61 1e 80 00 00 	movabs $0x801e61,%rax
  802184:	00 00 00 
  802187:	ff d0                	callq  *%rax
  802189:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80218c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802190:	79 05                	jns    802197 <read+0x5d>
		return r;
  802192:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802195:	eb 76                	jmp    80220d <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802197:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80219b:	8b 40 08             	mov    0x8(%rax),%eax
  80219e:	83 e0 03             	and    $0x3,%eax
  8021a1:	83 f8 01             	cmp    $0x1,%eax
  8021a4:	75 3a                	jne    8021e0 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8021a6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8021ad:	00 00 00 
  8021b0:	48 8b 00             	mov    (%rax),%rax
  8021b3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021b9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021bc:	89 c6                	mov    %eax,%esi
  8021be:	48 bf 0f 3b 80 00 00 	movabs $0x803b0f,%rdi
  8021c5:	00 00 00 
  8021c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cd:	48 b9 de 02 80 00 00 	movabs $0x8002de,%rcx
  8021d4:	00 00 00 
  8021d7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8021d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021de:	eb 2d                	jmp    80220d <read+0xd3>
	}
	if (!dev->dev_read)
  8021e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e4:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021e8:	48 85 c0             	test   %rax,%rax
  8021eb:	75 07                	jne    8021f4 <read+0xba>
		return -E_NOT_SUPP;
  8021ed:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021f2:	eb 19                	jmp    80220d <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8021f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021fc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802200:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802204:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802208:	48 89 cf             	mov    %rcx,%rdi
  80220b:	ff d0                	callq  *%rax
}
  80220d:	c9                   	leaveq 
  80220e:	c3                   	retq   

000000000080220f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80220f:	55                   	push   %rbp
  802210:	48 89 e5             	mov    %rsp,%rbp
  802213:	48 83 ec 30          	sub    $0x30,%rsp
  802217:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80221a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80221e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802222:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802229:	eb 49                	jmp    802274 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80222b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80222e:	48 98                	cltq   
  802230:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802234:	48 29 c2             	sub    %rax,%rdx
  802237:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80223a:	48 63 c8             	movslq %eax,%rcx
  80223d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802241:	48 01 c1             	add    %rax,%rcx
  802244:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802247:	48 89 ce             	mov    %rcx,%rsi
  80224a:	89 c7                	mov    %eax,%edi
  80224c:	48 b8 3a 21 80 00 00 	movabs $0x80213a,%rax
  802253:	00 00 00 
  802256:	ff d0                	callq  *%rax
  802258:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80225b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80225f:	79 05                	jns    802266 <readn+0x57>
			return m;
  802261:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802264:	eb 1c                	jmp    802282 <readn+0x73>
		if (m == 0)
  802266:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80226a:	75 02                	jne    80226e <readn+0x5f>
			break;
  80226c:	eb 11                	jmp    80227f <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80226e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802271:	01 45 fc             	add    %eax,-0x4(%rbp)
  802274:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802277:	48 98                	cltq   
  802279:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80227d:	72 ac                	jb     80222b <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80227f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802282:	c9                   	leaveq 
  802283:	c3                   	retq   

0000000000802284 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802284:	55                   	push   %rbp
  802285:	48 89 e5             	mov    %rsp,%rbp
  802288:	48 83 ec 40          	sub    $0x40,%rsp
  80228c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80228f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802293:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802297:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80229b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80229e:	48 89 d6             	mov    %rdx,%rsi
  8022a1:	89 c7                	mov    %eax,%edi
  8022a3:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  8022aa:	00 00 00 
  8022ad:	ff d0                	callq  *%rax
  8022af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b6:	78 24                	js     8022dc <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022bc:	8b 00                	mov    (%rax),%eax
  8022be:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022c2:	48 89 d6             	mov    %rdx,%rsi
  8022c5:	89 c7                	mov    %eax,%edi
  8022c7:	48 b8 61 1e 80 00 00 	movabs $0x801e61,%rax
  8022ce:	00 00 00 
  8022d1:	ff d0                	callq  *%rax
  8022d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022da:	79 05                	jns    8022e1 <write+0x5d>
		return r;
  8022dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022df:	eb 75                	jmp    802356 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e5:	8b 40 08             	mov    0x8(%rax),%eax
  8022e8:	83 e0 03             	and    $0x3,%eax
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	75 3a                	jne    802329 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8022ef:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8022f6:	00 00 00 
  8022f9:	48 8b 00             	mov    (%rax),%rax
  8022fc:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802302:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802305:	89 c6                	mov    %eax,%esi
  802307:	48 bf 2b 3b 80 00 00 	movabs $0x803b2b,%rdi
  80230e:	00 00 00 
  802311:	b8 00 00 00 00       	mov    $0x0,%eax
  802316:	48 b9 de 02 80 00 00 	movabs $0x8002de,%rcx
  80231d:	00 00 00 
  802320:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802322:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802327:	eb 2d                	jmp    802356 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802329:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80232d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802331:	48 85 c0             	test   %rax,%rax
  802334:	75 07                	jne    80233d <write+0xb9>
		return -E_NOT_SUPP;
  802336:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80233b:	eb 19                	jmp    802356 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80233d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802341:	48 8b 40 18          	mov    0x18(%rax),%rax
  802345:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802349:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80234d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802351:	48 89 cf             	mov    %rcx,%rdi
  802354:	ff d0                	callq  *%rax
}
  802356:	c9                   	leaveq 
  802357:	c3                   	retq   

0000000000802358 <seek>:

int
seek(int fdnum, off_t offset)
{
  802358:	55                   	push   %rbp
  802359:	48 89 e5             	mov    %rsp,%rbp
  80235c:	48 83 ec 18          	sub    $0x18,%rsp
  802360:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802363:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802366:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80236a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80236d:	48 89 d6             	mov    %rdx,%rsi
  802370:	89 c7                	mov    %eax,%edi
  802372:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  802379:	00 00 00 
  80237c:	ff d0                	callq  *%rax
  80237e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802381:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802385:	79 05                	jns    80238c <seek+0x34>
		return r;
  802387:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80238a:	eb 0f                	jmp    80239b <seek+0x43>
	fd->fd_offset = offset;
  80238c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802390:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802393:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802396:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80239b:	c9                   	leaveq 
  80239c:	c3                   	retq   

000000000080239d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80239d:	55                   	push   %rbp
  80239e:	48 89 e5             	mov    %rsp,%rbp
  8023a1:	48 83 ec 30          	sub    $0x30,%rsp
  8023a5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023a8:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023ab:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023af:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023b2:	48 89 d6             	mov    %rdx,%rsi
  8023b5:	89 c7                	mov    %eax,%edi
  8023b7:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  8023be:	00 00 00 
  8023c1:	ff d0                	callq  *%rax
  8023c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ca:	78 24                	js     8023f0 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d0:	8b 00                	mov    (%rax),%eax
  8023d2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023d6:	48 89 d6             	mov    %rdx,%rsi
  8023d9:	89 c7                	mov    %eax,%edi
  8023db:	48 b8 61 1e 80 00 00 	movabs $0x801e61,%rax
  8023e2:	00 00 00 
  8023e5:	ff d0                	callq  *%rax
  8023e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ee:	79 05                	jns    8023f5 <ftruncate+0x58>
		return r;
  8023f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f3:	eb 72                	jmp    802467 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f9:	8b 40 08             	mov    0x8(%rax),%eax
  8023fc:	83 e0 03             	and    $0x3,%eax
  8023ff:	85 c0                	test   %eax,%eax
  802401:	75 3a                	jne    80243d <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802403:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80240a:	00 00 00 
  80240d:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802410:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802416:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802419:	89 c6                	mov    %eax,%esi
  80241b:	48 bf 48 3b 80 00 00 	movabs $0x803b48,%rdi
  802422:	00 00 00 
  802425:	b8 00 00 00 00       	mov    $0x0,%eax
  80242a:	48 b9 de 02 80 00 00 	movabs $0x8002de,%rcx
  802431:	00 00 00 
  802434:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802436:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80243b:	eb 2a                	jmp    802467 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80243d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802441:	48 8b 40 30          	mov    0x30(%rax),%rax
  802445:	48 85 c0             	test   %rax,%rax
  802448:	75 07                	jne    802451 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80244a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80244f:	eb 16                	jmp    802467 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802451:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802455:	48 8b 40 30          	mov    0x30(%rax),%rax
  802459:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80245d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802460:	89 ce                	mov    %ecx,%esi
  802462:	48 89 d7             	mov    %rdx,%rdi
  802465:	ff d0                	callq  *%rax
}
  802467:	c9                   	leaveq 
  802468:	c3                   	retq   

0000000000802469 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802469:	55                   	push   %rbp
  80246a:	48 89 e5             	mov    %rsp,%rbp
  80246d:	48 83 ec 30          	sub    $0x30,%rsp
  802471:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802474:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802478:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80247c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80247f:	48 89 d6             	mov    %rdx,%rsi
  802482:	89 c7                	mov    %eax,%edi
  802484:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  80248b:	00 00 00 
  80248e:	ff d0                	callq  *%rax
  802490:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802493:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802497:	78 24                	js     8024bd <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802499:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80249d:	8b 00                	mov    (%rax),%eax
  80249f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024a3:	48 89 d6             	mov    %rdx,%rsi
  8024a6:	89 c7                	mov    %eax,%edi
  8024a8:	48 b8 61 1e 80 00 00 	movabs $0x801e61,%rax
  8024af:	00 00 00 
  8024b2:	ff d0                	callq  *%rax
  8024b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024bb:	79 05                	jns    8024c2 <fstat+0x59>
		return r;
  8024bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c0:	eb 5e                	jmp    802520 <fstat+0xb7>
	if (!dev->dev_stat)
  8024c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c6:	48 8b 40 28          	mov    0x28(%rax),%rax
  8024ca:	48 85 c0             	test   %rax,%rax
  8024cd:	75 07                	jne    8024d6 <fstat+0x6d>
		return -E_NOT_SUPP;
  8024cf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024d4:	eb 4a                	jmp    802520 <fstat+0xb7>
	stat->st_name[0] = 0;
  8024d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024da:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8024dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024e1:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8024e8:	00 00 00 
	stat->st_isdir = 0;
  8024eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024ef:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8024f6:	00 00 00 
	stat->st_dev = dev;
  8024f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802501:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802508:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80250c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802510:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802514:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802518:	48 89 ce             	mov    %rcx,%rsi
  80251b:	48 89 d7             	mov    %rdx,%rdi
  80251e:	ff d0                	callq  *%rax
}
  802520:	c9                   	leaveq 
  802521:	c3                   	retq   

0000000000802522 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802522:	55                   	push   %rbp
  802523:	48 89 e5             	mov    %rsp,%rbp
  802526:	48 83 ec 20          	sub    $0x20,%rsp
  80252a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80252e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802532:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802536:	be 00 00 00 00       	mov    $0x0,%esi
  80253b:	48 89 c7             	mov    %rax,%rdi
  80253e:	48 b8 10 26 80 00 00 	movabs $0x802610,%rax
  802545:	00 00 00 
  802548:	ff d0                	callq  *%rax
  80254a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80254d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802551:	79 05                	jns    802558 <stat+0x36>
		return fd;
  802553:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802556:	eb 2f                	jmp    802587 <stat+0x65>
	r = fstat(fd, stat);
  802558:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80255c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80255f:	48 89 d6             	mov    %rdx,%rsi
  802562:	89 c7                	mov    %eax,%edi
  802564:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  80256b:	00 00 00 
  80256e:	ff d0                	callq  *%rax
  802570:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802573:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802576:	89 c7                	mov    %eax,%edi
  802578:	48 b8 18 1f 80 00 00 	movabs $0x801f18,%rax
  80257f:	00 00 00 
  802582:	ff d0                	callq  *%rax
	return r;
  802584:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802587:	c9                   	leaveq 
  802588:	c3                   	retq   

0000000000802589 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802589:	55                   	push   %rbp
  80258a:	48 89 e5             	mov    %rsp,%rbp
  80258d:	48 83 ec 10          	sub    $0x10,%rsp
  802591:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802594:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802598:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  80259f:	00 00 00 
  8025a2:	8b 00                	mov    (%rax),%eax
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	75 1d                	jne    8025c5 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8025a8:	bf 01 00 00 00       	mov    $0x1,%edi
  8025ad:	48 b8 93 34 80 00 00 	movabs $0x803493,%rax
  8025b4:	00 00 00 
  8025b7:	ff d0                	callq  *%rax
  8025b9:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  8025c0:	00 00 00 
  8025c3:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8025c5:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  8025cc:	00 00 00 
  8025cf:	8b 00                	mov    (%rax),%eax
  8025d1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8025d4:	b9 07 00 00 00       	mov    $0x7,%ecx
  8025d9:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8025e0:	00 00 00 
  8025e3:	89 c7                	mov    %eax,%edi
  8025e5:	48 b8 fb 33 80 00 00 	movabs $0x8033fb,%rax
  8025ec:	00 00 00 
  8025ef:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8025f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8025fa:	48 89 c6             	mov    %rax,%rsi
  8025fd:	bf 00 00 00 00       	mov    $0x0,%edi
  802602:	48 b8 32 33 80 00 00 	movabs $0x803332,%rax
  802609:	00 00 00 
  80260c:	ff d0                	callq  *%rax
}
  80260e:	c9                   	leaveq 
  80260f:	c3                   	retq   

0000000000802610 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802610:	55                   	push   %rbp
  802611:	48 89 e5             	mov    %rsp,%rbp
  802614:	48 83 ec 20          	sub    $0x20,%rsp
  802618:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80261c:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  80261f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802623:	48 89 c7             	mov    %rax,%rdi
  802626:	48 b8 1a 10 80 00 00 	movabs $0x80101a,%rax
  80262d:	00 00 00 
  802630:	ff d0                	callq  *%rax
  802632:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802637:	7e 0a                	jle    802643 <open+0x33>
		return -E_BAD_PATH;
  802639:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80263e:	e9 a5 00 00 00       	jmpq   8026e8 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802643:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802647:	48 89 c7             	mov    %rax,%rdi
  80264a:	48 b8 70 1c 80 00 00 	movabs $0x801c70,%rax
  802651:	00 00 00 
  802654:	ff d0                	callq  *%rax
  802656:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802659:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265d:	79 08                	jns    802667 <open+0x57>
		return r;
  80265f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802662:	e9 81 00 00 00       	jmpq   8026e8 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80266b:	48 89 c6             	mov    %rax,%rsi
  80266e:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802675:	00 00 00 
  802678:	48 b8 86 10 80 00 00 	movabs $0x801086,%rax
  80267f:	00 00 00 
  802682:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802684:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80268b:	00 00 00 
  80268e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802691:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802697:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269b:	48 89 c6             	mov    %rax,%rsi
  80269e:	bf 01 00 00 00       	mov    $0x1,%edi
  8026a3:	48 b8 89 25 80 00 00 	movabs $0x802589,%rax
  8026aa:	00 00 00 
  8026ad:	ff d0                	callq  *%rax
  8026af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b6:	79 1d                	jns    8026d5 <open+0xc5>
		fd_close(fd, 0);
  8026b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026bc:	be 00 00 00 00       	mov    $0x0,%esi
  8026c1:	48 89 c7             	mov    %rax,%rdi
  8026c4:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  8026cb:	00 00 00 
  8026ce:	ff d0                	callq  *%rax
		return r;
  8026d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d3:	eb 13                	jmp    8026e8 <open+0xd8>
	}

	return fd2num(fd);
  8026d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d9:	48 89 c7             	mov    %rax,%rdi
  8026dc:	48 b8 22 1c 80 00 00 	movabs $0x801c22,%rax
  8026e3:	00 00 00 
  8026e6:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  8026e8:	c9                   	leaveq 
  8026e9:	c3                   	retq   

00000000008026ea <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8026ea:	55                   	push   %rbp
  8026eb:	48 89 e5             	mov    %rsp,%rbp
  8026ee:	48 83 ec 10          	sub    $0x10,%rsp
  8026f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8026f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026fa:	8b 50 0c             	mov    0xc(%rax),%edx
  8026fd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802704:	00 00 00 
  802707:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802709:	be 00 00 00 00       	mov    $0x0,%esi
  80270e:	bf 06 00 00 00       	mov    $0x6,%edi
  802713:	48 b8 89 25 80 00 00 	movabs $0x802589,%rax
  80271a:	00 00 00 
  80271d:	ff d0                	callq  *%rax
}
  80271f:	c9                   	leaveq 
  802720:	c3                   	retq   

0000000000802721 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802721:	55                   	push   %rbp
  802722:	48 89 e5             	mov    %rsp,%rbp
  802725:	48 83 ec 30          	sub    $0x30,%rsp
  802729:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80272d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802731:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802735:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802739:	8b 50 0c             	mov    0xc(%rax),%edx
  80273c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802743:	00 00 00 
  802746:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802748:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80274f:	00 00 00 
  802752:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802756:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80275a:	be 00 00 00 00       	mov    $0x0,%esi
  80275f:	bf 03 00 00 00       	mov    $0x3,%edi
  802764:	48 b8 89 25 80 00 00 	movabs $0x802589,%rax
  80276b:	00 00 00 
  80276e:	ff d0                	callq  *%rax
  802770:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802773:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802777:	79 05                	jns    80277e <devfile_read+0x5d>
		return r;
  802779:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277c:	eb 26                	jmp    8027a4 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80277e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802781:	48 63 d0             	movslq %eax,%rdx
  802784:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802788:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80278f:	00 00 00 
  802792:	48 89 c7             	mov    %rax,%rdi
  802795:	48 b8 aa 13 80 00 00 	movabs $0x8013aa,%rax
  80279c:	00 00 00 
  80279f:	ff d0                	callq  *%rax

	return r;
  8027a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8027a4:	c9                   	leaveq 
  8027a5:	c3                   	retq   

00000000008027a6 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8027a6:	55                   	push   %rbp
  8027a7:	48 89 e5             	mov    %rsp,%rbp
  8027aa:	48 83 ec 30          	sub    $0x30,%rsp
  8027ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027b6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  8027ba:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8027c1:	00 
  8027c2:	76 08                	jbe    8027cc <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  8027c4:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8027cb:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8027cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d0:	8b 50 0c             	mov    0xc(%rax),%edx
  8027d3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027da:	00 00 00 
  8027dd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8027df:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027e6:	00 00 00 
  8027e9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027ed:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  8027f1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027f9:	48 89 c6             	mov    %rax,%rsi
  8027fc:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802803:	00 00 00 
  802806:	48 b8 aa 13 80 00 00 	movabs $0x8013aa,%rax
  80280d:	00 00 00 
  802810:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802812:	be 00 00 00 00       	mov    $0x0,%esi
  802817:	bf 04 00 00 00       	mov    $0x4,%edi
  80281c:	48 b8 89 25 80 00 00 	movabs $0x802589,%rax
  802823:	00 00 00 
  802826:	ff d0                	callq  *%rax
  802828:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80282b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282f:	79 05                	jns    802836 <devfile_write+0x90>
		return r;
  802831:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802834:	eb 03                	jmp    802839 <devfile_write+0x93>

	return r;
  802836:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802839:	c9                   	leaveq 
  80283a:	c3                   	retq   

000000000080283b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80283b:	55                   	push   %rbp
  80283c:	48 89 e5             	mov    %rsp,%rbp
  80283f:	48 83 ec 20          	sub    $0x20,%rsp
  802843:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802847:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80284b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80284f:	8b 50 0c             	mov    0xc(%rax),%edx
  802852:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802859:	00 00 00 
  80285c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80285e:	be 00 00 00 00       	mov    $0x0,%esi
  802863:	bf 05 00 00 00       	mov    $0x5,%edi
  802868:	48 b8 89 25 80 00 00 	movabs $0x802589,%rax
  80286f:	00 00 00 
  802872:	ff d0                	callq  *%rax
  802874:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802877:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80287b:	79 05                	jns    802882 <devfile_stat+0x47>
		return r;
  80287d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802880:	eb 56                	jmp    8028d8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802882:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802886:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80288d:	00 00 00 
  802890:	48 89 c7             	mov    %rax,%rdi
  802893:	48 b8 86 10 80 00 00 	movabs $0x801086,%rax
  80289a:	00 00 00 
  80289d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80289f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028a6:	00 00 00 
  8028a9:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8028af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028b3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8028b9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028c0:	00 00 00 
  8028c3:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8028c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028cd:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8028d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028d8:	c9                   	leaveq 
  8028d9:	c3                   	retq   

00000000008028da <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8028da:	55                   	push   %rbp
  8028db:	48 89 e5             	mov    %rsp,%rbp
  8028de:	48 83 ec 10          	sub    $0x10,%rsp
  8028e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8028e6:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8028e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028ed:	8b 50 0c             	mov    0xc(%rax),%edx
  8028f0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028f7:	00 00 00 
  8028fa:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8028fc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802903:	00 00 00 
  802906:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802909:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80290c:	be 00 00 00 00       	mov    $0x0,%esi
  802911:	bf 02 00 00 00       	mov    $0x2,%edi
  802916:	48 b8 89 25 80 00 00 	movabs $0x802589,%rax
  80291d:	00 00 00 
  802920:	ff d0                	callq  *%rax
}
  802922:	c9                   	leaveq 
  802923:	c3                   	retq   

0000000000802924 <remove>:

// Delete a file
int
remove(const char *path)
{
  802924:	55                   	push   %rbp
  802925:	48 89 e5             	mov    %rsp,%rbp
  802928:	48 83 ec 10          	sub    $0x10,%rsp
  80292c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802930:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802934:	48 89 c7             	mov    %rax,%rdi
  802937:	48 b8 1a 10 80 00 00 	movabs $0x80101a,%rax
  80293e:	00 00 00 
  802941:	ff d0                	callq  *%rax
  802943:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802948:	7e 07                	jle    802951 <remove+0x2d>
		return -E_BAD_PATH;
  80294a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80294f:	eb 33                	jmp    802984 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802951:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802955:	48 89 c6             	mov    %rax,%rsi
  802958:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80295f:	00 00 00 
  802962:	48 b8 86 10 80 00 00 	movabs $0x801086,%rax
  802969:	00 00 00 
  80296c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80296e:	be 00 00 00 00       	mov    $0x0,%esi
  802973:	bf 07 00 00 00       	mov    $0x7,%edi
  802978:	48 b8 89 25 80 00 00 	movabs $0x802589,%rax
  80297f:	00 00 00 
  802982:	ff d0                	callq  *%rax
}
  802984:	c9                   	leaveq 
  802985:	c3                   	retq   

0000000000802986 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802986:	55                   	push   %rbp
  802987:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80298a:	be 00 00 00 00       	mov    $0x0,%esi
  80298f:	bf 08 00 00 00       	mov    $0x8,%edi
  802994:	48 b8 89 25 80 00 00 	movabs $0x802589,%rax
  80299b:	00 00 00 
  80299e:	ff d0                	callq  *%rax
}
  8029a0:	5d                   	pop    %rbp
  8029a1:	c3                   	retq   

00000000008029a2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8029a2:	55                   	push   %rbp
  8029a3:	48 89 e5             	mov    %rsp,%rbp
  8029a6:	53                   	push   %rbx
  8029a7:	48 83 ec 38          	sub    $0x38,%rsp
  8029ab:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8029af:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8029b3:	48 89 c7             	mov    %rax,%rdi
  8029b6:	48 b8 70 1c 80 00 00 	movabs $0x801c70,%rax
  8029bd:	00 00 00 
  8029c0:	ff d0                	callq  *%rax
  8029c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029c9:	0f 88 bf 01 00 00    	js     802b8e <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029d3:	ba 07 04 00 00       	mov    $0x407,%edx
  8029d8:	48 89 c6             	mov    %rax,%rsi
  8029db:	bf 00 00 00 00       	mov    $0x0,%edi
  8029e0:	48 b8 b5 19 80 00 00 	movabs $0x8019b5,%rax
  8029e7:	00 00 00 
  8029ea:	ff d0                	callq  *%rax
  8029ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029f3:	0f 88 95 01 00 00    	js     802b8e <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8029f9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8029fd:	48 89 c7             	mov    %rax,%rdi
  802a00:	48 b8 70 1c 80 00 00 	movabs $0x801c70,%rax
  802a07:	00 00 00 
  802a0a:	ff d0                	callq  *%rax
  802a0c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a0f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a13:	0f 88 5d 01 00 00    	js     802b76 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a19:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a1d:	ba 07 04 00 00       	mov    $0x407,%edx
  802a22:	48 89 c6             	mov    %rax,%rsi
  802a25:	bf 00 00 00 00       	mov    $0x0,%edi
  802a2a:	48 b8 b5 19 80 00 00 	movabs $0x8019b5,%rax
  802a31:	00 00 00 
  802a34:	ff d0                	callq  *%rax
  802a36:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a39:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a3d:	0f 88 33 01 00 00    	js     802b76 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802a43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a47:	48 89 c7             	mov    %rax,%rdi
  802a4a:	48 b8 45 1c 80 00 00 	movabs $0x801c45,%rax
  802a51:	00 00 00 
  802a54:	ff d0                	callq  *%rax
  802a56:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a5e:	ba 07 04 00 00       	mov    $0x407,%edx
  802a63:	48 89 c6             	mov    %rax,%rsi
  802a66:	bf 00 00 00 00       	mov    $0x0,%edi
  802a6b:	48 b8 b5 19 80 00 00 	movabs $0x8019b5,%rax
  802a72:	00 00 00 
  802a75:	ff d0                	callq  *%rax
  802a77:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a7e:	79 05                	jns    802a85 <pipe+0xe3>
		goto err2;
  802a80:	e9 d9 00 00 00       	jmpq   802b5e <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a89:	48 89 c7             	mov    %rax,%rdi
  802a8c:	48 b8 45 1c 80 00 00 	movabs $0x801c45,%rax
  802a93:	00 00 00 
  802a96:	ff d0                	callq  *%rax
  802a98:	48 89 c2             	mov    %rax,%rdx
  802a9b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a9f:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802aa5:	48 89 d1             	mov    %rdx,%rcx
  802aa8:	ba 00 00 00 00       	mov    $0x0,%edx
  802aad:	48 89 c6             	mov    %rax,%rsi
  802ab0:	bf 00 00 00 00       	mov    $0x0,%edi
  802ab5:	48 b8 05 1a 80 00 00 	movabs $0x801a05,%rax
  802abc:	00 00 00 
  802abf:	ff d0                	callq  *%rax
  802ac1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ac4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ac8:	79 1b                	jns    802ae5 <pipe+0x143>
		goto err3;
  802aca:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  802acb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802acf:	48 89 c6             	mov    %rax,%rsi
  802ad2:	bf 00 00 00 00       	mov    $0x0,%edi
  802ad7:	48 b8 60 1a 80 00 00 	movabs $0x801a60,%rax
  802ade:	00 00 00 
  802ae1:	ff d0                	callq  *%rax
  802ae3:	eb 79                	jmp    802b5e <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802ae5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ae9:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802af0:	00 00 00 
  802af3:	8b 12                	mov    (%rdx),%edx
  802af5:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802af7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802afb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802b02:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b06:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802b0d:	00 00 00 
  802b10:	8b 12                	mov    (%rdx),%edx
  802b12:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802b14:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b18:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802b1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b23:	48 89 c7             	mov    %rax,%rdi
  802b26:	48 b8 22 1c 80 00 00 	movabs $0x801c22,%rax
  802b2d:	00 00 00 
  802b30:	ff d0                	callq  *%rax
  802b32:	89 c2                	mov    %eax,%edx
  802b34:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b38:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802b3a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b3e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802b42:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b46:	48 89 c7             	mov    %rax,%rdi
  802b49:	48 b8 22 1c 80 00 00 	movabs $0x801c22,%rax
  802b50:	00 00 00 
  802b53:	ff d0                	callq  *%rax
  802b55:	89 03                	mov    %eax,(%rbx)
	return 0;
  802b57:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5c:	eb 33                	jmp    802b91 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  802b5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b62:	48 89 c6             	mov    %rax,%rsi
  802b65:	bf 00 00 00 00       	mov    $0x0,%edi
  802b6a:	48 b8 60 1a 80 00 00 	movabs $0x801a60,%rax
  802b71:	00 00 00 
  802b74:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  802b76:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b7a:	48 89 c6             	mov    %rax,%rsi
  802b7d:	bf 00 00 00 00       	mov    $0x0,%edi
  802b82:	48 b8 60 1a 80 00 00 	movabs $0x801a60,%rax
  802b89:	00 00 00 
  802b8c:	ff d0                	callq  *%rax
    err:
	return r;
  802b8e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802b91:	48 83 c4 38          	add    $0x38,%rsp
  802b95:	5b                   	pop    %rbx
  802b96:	5d                   	pop    %rbp
  802b97:	c3                   	retq   

0000000000802b98 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802b98:	55                   	push   %rbp
  802b99:	48 89 e5             	mov    %rsp,%rbp
  802b9c:	53                   	push   %rbx
  802b9d:	48 83 ec 28          	sub    $0x28,%rsp
  802ba1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ba5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802ba9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802bb0:	00 00 00 
  802bb3:	48 8b 00             	mov    (%rax),%rax
  802bb6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802bbc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802bbf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bc3:	48 89 c7             	mov    %rax,%rdi
  802bc6:	48 b8 15 35 80 00 00 	movabs $0x803515,%rax
  802bcd:	00 00 00 
  802bd0:	ff d0                	callq  *%rax
  802bd2:	89 c3                	mov    %eax,%ebx
  802bd4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bd8:	48 89 c7             	mov    %rax,%rdi
  802bdb:	48 b8 15 35 80 00 00 	movabs $0x803515,%rax
  802be2:	00 00 00 
  802be5:	ff d0                	callq  *%rax
  802be7:	39 c3                	cmp    %eax,%ebx
  802be9:	0f 94 c0             	sete   %al
  802bec:	0f b6 c0             	movzbl %al,%eax
  802bef:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802bf2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802bf9:	00 00 00 
  802bfc:	48 8b 00             	mov    (%rax),%rax
  802bff:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802c05:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802c08:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c0b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802c0e:	75 05                	jne    802c15 <_pipeisclosed+0x7d>
			return ret;
  802c10:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c13:	eb 4f                	jmp    802c64 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802c15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c18:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802c1b:	74 42                	je     802c5f <_pipeisclosed+0xc7>
  802c1d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802c21:	75 3c                	jne    802c5f <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802c23:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c2a:	00 00 00 
  802c2d:	48 8b 00             	mov    (%rax),%rax
  802c30:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802c36:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802c39:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c3c:	89 c6                	mov    %eax,%esi
  802c3e:	48 bf 73 3b 80 00 00 	movabs $0x803b73,%rdi
  802c45:	00 00 00 
  802c48:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4d:	49 b8 de 02 80 00 00 	movabs $0x8002de,%r8
  802c54:	00 00 00 
  802c57:	41 ff d0             	callq  *%r8
	}
  802c5a:	e9 4a ff ff ff       	jmpq   802ba9 <_pipeisclosed+0x11>
  802c5f:	e9 45 ff ff ff       	jmpq   802ba9 <_pipeisclosed+0x11>
}
  802c64:	48 83 c4 28          	add    $0x28,%rsp
  802c68:	5b                   	pop    %rbx
  802c69:	5d                   	pop    %rbp
  802c6a:	c3                   	retq   

0000000000802c6b <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802c6b:	55                   	push   %rbp
  802c6c:	48 89 e5             	mov    %rsp,%rbp
  802c6f:	48 83 ec 30          	sub    $0x30,%rsp
  802c73:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c76:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c7a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c7d:	48 89 d6             	mov    %rdx,%rsi
  802c80:	89 c7                	mov    %eax,%edi
  802c82:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  802c89:	00 00 00 
  802c8c:	ff d0                	callq  *%rax
  802c8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c95:	79 05                	jns    802c9c <pipeisclosed+0x31>
		return r;
  802c97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9a:	eb 31                	jmp    802ccd <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802c9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca0:	48 89 c7             	mov    %rax,%rdi
  802ca3:	48 b8 45 1c 80 00 00 	movabs $0x801c45,%rax
  802caa:	00 00 00 
  802cad:	ff d0                	callq  *%rax
  802caf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802cb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cbb:	48 89 d6             	mov    %rdx,%rsi
  802cbe:	48 89 c7             	mov    %rax,%rdi
  802cc1:	48 b8 98 2b 80 00 00 	movabs $0x802b98,%rax
  802cc8:	00 00 00 
  802ccb:	ff d0                	callq  *%rax
}
  802ccd:	c9                   	leaveq 
  802cce:	c3                   	retq   

0000000000802ccf <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802ccf:	55                   	push   %rbp
  802cd0:	48 89 e5             	mov    %rsp,%rbp
  802cd3:	48 83 ec 40          	sub    $0x40,%rsp
  802cd7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802cdb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802cdf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802ce3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ce7:	48 89 c7             	mov    %rax,%rdi
  802cea:	48 b8 45 1c 80 00 00 	movabs $0x801c45,%rax
  802cf1:	00 00 00 
  802cf4:	ff d0                	callq  *%rax
  802cf6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802cfa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cfe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802d02:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802d09:	00 
  802d0a:	e9 92 00 00 00       	jmpq   802da1 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802d0f:	eb 41                	jmp    802d52 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802d11:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802d16:	74 09                	je     802d21 <devpipe_read+0x52>
				return i;
  802d18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d1c:	e9 92 00 00 00       	jmpq   802db3 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802d21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d29:	48 89 d6             	mov    %rdx,%rsi
  802d2c:	48 89 c7             	mov    %rax,%rdi
  802d2f:	48 b8 98 2b 80 00 00 	movabs $0x802b98,%rax
  802d36:	00 00 00 
  802d39:	ff d0                	callq  *%rax
  802d3b:	85 c0                	test   %eax,%eax
  802d3d:	74 07                	je     802d46 <devpipe_read+0x77>
				return 0;
  802d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d44:	eb 6d                	jmp    802db3 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802d46:	48 b8 77 19 80 00 00 	movabs $0x801977,%rax
  802d4d:	00 00 00 
  802d50:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802d52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d56:	8b 10                	mov    (%rax),%edx
  802d58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5c:	8b 40 04             	mov    0x4(%rax),%eax
  802d5f:	39 c2                	cmp    %eax,%edx
  802d61:	74 ae                	je     802d11 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802d63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d6b:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802d6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d73:	8b 00                	mov    (%rax),%eax
  802d75:	99                   	cltd   
  802d76:	c1 ea 1b             	shr    $0x1b,%edx
  802d79:	01 d0                	add    %edx,%eax
  802d7b:	83 e0 1f             	and    $0x1f,%eax
  802d7e:	29 d0                	sub    %edx,%eax
  802d80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d84:	48 98                	cltq   
  802d86:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802d8b:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802d8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d91:	8b 00                	mov    (%rax),%eax
  802d93:	8d 50 01             	lea    0x1(%rax),%edx
  802d96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d9a:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802d9c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802da1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802da5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802da9:	0f 82 60 ff ff ff    	jb     802d0f <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802daf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802db3:	c9                   	leaveq 
  802db4:	c3                   	retq   

0000000000802db5 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802db5:	55                   	push   %rbp
  802db6:	48 89 e5             	mov    %rsp,%rbp
  802db9:	48 83 ec 40          	sub    $0x40,%rsp
  802dbd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802dc1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802dc5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802dc9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dcd:	48 89 c7             	mov    %rax,%rdi
  802dd0:	48 b8 45 1c 80 00 00 	movabs $0x801c45,%rax
  802dd7:	00 00 00 
  802dda:	ff d0                	callq  *%rax
  802ddc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802de0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802de4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802de8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802def:	00 
  802df0:	e9 8e 00 00 00       	jmpq   802e83 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802df5:	eb 31                	jmp    802e28 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802df7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802dfb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dff:	48 89 d6             	mov    %rdx,%rsi
  802e02:	48 89 c7             	mov    %rax,%rdi
  802e05:	48 b8 98 2b 80 00 00 	movabs $0x802b98,%rax
  802e0c:	00 00 00 
  802e0f:	ff d0                	callq  *%rax
  802e11:	85 c0                	test   %eax,%eax
  802e13:	74 07                	je     802e1c <devpipe_write+0x67>
				return 0;
  802e15:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1a:	eb 79                	jmp    802e95 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802e1c:	48 b8 77 19 80 00 00 	movabs $0x801977,%rax
  802e23:	00 00 00 
  802e26:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802e28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e2c:	8b 40 04             	mov    0x4(%rax),%eax
  802e2f:	48 63 d0             	movslq %eax,%rdx
  802e32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e36:	8b 00                	mov    (%rax),%eax
  802e38:	48 98                	cltq   
  802e3a:	48 83 c0 20          	add    $0x20,%rax
  802e3e:	48 39 c2             	cmp    %rax,%rdx
  802e41:	73 b4                	jae    802df7 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802e43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e47:	8b 40 04             	mov    0x4(%rax),%eax
  802e4a:	99                   	cltd   
  802e4b:	c1 ea 1b             	shr    $0x1b,%edx
  802e4e:	01 d0                	add    %edx,%eax
  802e50:	83 e0 1f             	and    $0x1f,%eax
  802e53:	29 d0                	sub    %edx,%eax
  802e55:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e59:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e5d:	48 01 ca             	add    %rcx,%rdx
  802e60:	0f b6 0a             	movzbl (%rdx),%ecx
  802e63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e67:	48 98                	cltq   
  802e69:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802e6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e71:	8b 40 04             	mov    0x4(%rax),%eax
  802e74:	8d 50 01             	lea    0x1(%rax),%edx
  802e77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e7b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e7e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e87:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802e8b:	0f 82 64 ff ff ff    	jb     802df5 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802e91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e95:	c9                   	leaveq 
  802e96:	c3                   	retq   

0000000000802e97 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802e97:	55                   	push   %rbp
  802e98:	48 89 e5             	mov    %rsp,%rbp
  802e9b:	48 83 ec 20          	sub    $0x20,%rsp
  802e9f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ea3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802ea7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eab:	48 89 c7             	mov    %rax,%rdi
  802eae:	48 b8 45 1c 80 00 00 	movabs $0x801c45,%rax
  802eb5:	00 00 00 
  802eb8:	ff d0                	callq  *%rax
  802eba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802ebe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ec2:	48 be 86 3b 80 00 00 	movabs $0x803b86,%rsi
  802ec9:	00 00 00 
  802ecc:	48 89 c7             	mov    %rax,%rdi
  802ecf:	48 b8 86 10 80 00 00 	movabs $0x801086,%rax
  802ed6:	00 00 00 
  802ed9:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802edb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802edf:	8b 50 04             	mov    0x4(%rax),%edx
  802ee2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ee6:	8b 00                	mov    (%rax),%eax
  802ee8:	29 c2                	sub    %eax,%edx
  802eea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eee:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802ef4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ef8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802eff:	00 00 00 
	stat->st_dev = &devpipe;
  802f02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f06:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  802f0d:	00 00 00 
  802f10:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802f17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f1c:	c9                   	leaveq 
  802f1d:	c3                   	retq   

0000000000802f1e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802f1e:	55                   	push   %rbp
  802f1f:	48 89 e5             	mov    %rsp,%rbp
  802f22:	48 83 ec 10          	sub    $0x10,%rsp
  802f26:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802f2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f2e:	48 89 c6             	mov    %rax,%rsi
  802f31:	bf 00 00 00 00       	mov    $0x0,%edi
  802f36:	48 b8 60 1a 80 00 00 	movabs $0x801a60,%rax
  802f3d:	00 00 00 
  802f40:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802f42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f46:	48 89 c7             	mov    %rax,%rdi
  802f49:	48 b8 45 1c 80 00 00 	movabs $0x801c45,%rax
  802f50:	00 00 00 
  802f53:	ff d0                	callq  *%rax
  802f55:	48 89 c6             	mov    %rax,%rsi
  802f58:	bf 00 00 00 00       	mov    $0x0,%edi
  802f5d:	48 b8 60 1a 80 00 00 	movabs $0x801a60,%rax
  802f64:	00 00 00 
  802f67:	ff d0                	callq  *%rax
}
  802f69:	c9                   	leaveq 
  802f6a:	c3                   	retq   

0000000000802f6b <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802f6b:	55                   	push   %rbp
  802f6c:	48 89 e5             	mov    %rsp,%rbp
  802f6f:	48 83 ec 20          	sub    $0x20,%rsp
  802f73:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802f76:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f79:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802f7c:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802f80:	be 01 00 00 00       	mov    $0x1,%esi
  802f85:	48 89 c7             	mov    %rax,%rdi
  802f88:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  802f8f:	00 00 00 
  802f92:	ff d0                	callq  *%rax
}
  802f94:	c9                   	leaveq 
  802f95:	c3                   	retq   

0000000000802f96 <getchar>:

int
getchar(void)
{
  802f96:	55                   	push   %rbp
  802f97:	48 89 e5             	mov    %rsp,%rbp
  802f9a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802f9e:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802fa2:	ba 01 00 00 00       	mov    $0x1,%edx
  802fa7:	48 89 c6             	mov    %rax,%rsi
  802faa:	bf 00 00 00 00       	mov    $0x0,%edi
  802faf:	48 b8 3a 21 80 00 00 	movabs $0x80213a,%rax
  802fb6:	00 00 00 
  802fb9:	ff d0                	callq  *%rax
  802fbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802fbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc2:	79 05                	jns    802fc9 <getchar+0x33>
		return r;
  802fc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc7:	eb 14                	jmp    802fdd <getchar+0x47>
	if (r < 1)
  802fc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fcd:	7f 07                	jg     802fd6 <getchar+0x40>
		return -E_EOF;
  802fcf:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802fd4:	eb 07                	jmp    802fdd <getchar+0x47>
	return c;
  802fd6:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802fda:	0f b6 c0             	movzbl %al,%eax
}
  802fdd:	c9                   	leaveq 
  802fde:	c3                   	retq   

0000000000802fdf <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802fdf:	55                   	push   %rbp
  802fe0:	48 89 e5             	mov    %rsp,%rbp
  802fe3:	48 83 ec 20          	sub    $0x20,%rsp
  802fe7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fea:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ff1:	48 89 d6             	mov    %rdx,%rsi
  802ff4:	89 c7                	mov    %eax,%edi
  802ff6:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  802ffd:	00 00 00 
  803000:	ff d0                	callq  *%rax
  803002:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803005:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803009:	79 05                	jns    803010 <iscons+0x31>
		return r;
  80300b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300e:	eb 1a                	jmp    80302a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803010:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803014:	8b 10                	mov    (%rax),%edx
  803016:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  80301d:	00 00 00 
  803020:	8b 00                	mov    (%rax),%eax
  803022:	39 c2                	cmp    %eax,%edx
  803024:	0f 94 c0             	sete   %al
  803027:	0f b6 c0             	movzbl %al,%eax
}
  80302a:	c9                   	leaveq 
  80302b:	c3                   	retq   

000000000080302c <opencons>:

int
opencons(void)
{
  80302c:	55                   	push   %rbp
  80302d:	48 89 e5             	mov    %rsp,%rbp
  803030:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803034:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803038:	48 89 c7             	mov    %rax,%rdi
  80303b:	48 b8 70 1c 80 00 00 	movabs $0x801c70,%rax
  803042:	00 00 00 
  803045:	ff d0                	callq  *%rax
  803047:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80304a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80304e:	79 05                	jns    803055 <opencons+0x29>
		return r;
  803050:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803053:	eb 5b                	jmp    8030b0 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803055:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803059:	ba 07 04 00 00       	mov    $0x407,%edx
  80305e:	48 89 c6             	mov    %rax,%rsi
  803061:	bf 00 00 00 00       	mov    $0x0,%edi
  803066:	48 b8 b5 19 80 00 00 	movabs $0x8019b5,%rax
  80306d:	00 00 00 
  803070:	ff d0                	callq  *%rax
  803072:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803075:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803079:	79 05                	jns    803080 <opencons+0x54>
		return r;
  80307b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80307e:	eb 30                	jmp    8030b0 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803080:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803084:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  80308b:	00 00 00 
  80308e:	8b 12                	mov    (%rdx),%edx
  803090:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803092:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803096:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80309d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a1:	48 89 c7             	mov    %rax,%rdi
  8030a4:	48 b8 22 1c 80 00 00 	movabs $0x801c22,%rax
  8030ab:	00 00 00 
  8030ae:	ff d0                	callq  *%rax
}
  8030b0:	c9                   	leaveq 
  8030b1:	c3                   	retq   

00000000008030b2 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8030b2:	55                   	push   %rbp
  8030b3:	48 89 e5             	mov    %rsp,%rbp
  8030b6:	48 83 ec 30          	sub    $0x30,%rsp
  8030ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8030c6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8030cb:	75 07                	jne    8030d4 <devcons_read+0x22>
		return 0;
  8030cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8030d2:	eb 4b                	jmp    80311f <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8030d4:	eb 0c                	jmp    8030e2 <devcons_read+0x30>
		sys_yield();
  8030d6:	48 b8 77 19 80 00 00 	movabs $0x801977,%rax
  8030dd:	00 00 00 
  8030e0:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8030e2:	48 b8 b7 18 80 00 00 	movabs $0x8018b7,%rax
  8030e9:	00 00 00 
  8030ec:	ff d0                	callq  *%rax
  8030ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f5:	74 df                	je     8030d6 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8030f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030fb:	79 05                	jns    803102 <devcons_read+0x50>
		return c;
  8030fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803100:	eb 1d                	jmp    80311f <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803102:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803106:	75 07                	jne    80310f <devcons_read+0x5d>
		return 0;
  803108:	b8 00 00 00 00       	mov    $0x0,%eax
  80310d:	eb 10                	jmp    80311f <devcons_read+0x6d>
	*(char*)vbuf = c;
  80310f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803112:	89 c2                	mov    %eax,%edx
  803114:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803118:	88 10                	mov    %dl,(%rax)
	return 1;
  80311a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80311f:	c9                   	leaveq 
  803120:	c3                   	retq   

0000000000803121 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803121:	55                   	push   %rbp
  803122:	48 89 e5             	mov    %rsp,%rbp
  803125:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80312c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803133:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80313a:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803141:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803148:	eb 76                	jmp    8031c0 <devcons_write+0x9f>
		m = n - tot;
  80314a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803151:	89 c2                	mov    %eax,%edx
  803153:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803156:	29 c2                	sub    %eax,%edx
  803158:	89 d0                	mov    %edx,%eax
  80315a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80315d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803160:	83 f8 7f             	cmp    $0x7f,%eax
  803163:	76 07                	jbe    80316c <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803165:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80316c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80316f:	48 63 d0             	movslq %eax,%rdx
  803172:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803175:	48 63 c8             	movslq %eax,%rcx
  803178:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80317f:	48 01 c1             	add    %rax,%rcx
  803182:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803189:	48 89 ce             	mov    %rcx,%rsi
  80318c:	48 89 c7             	mov    %rax,%rdi
  80318f:	48 b8 aa 13 80 00 00 	movabs $0x8013aa,%rax
  803196:	00 00 00 
  803199:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80319b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80319e:	48 63 d0             	movslq %eax,%rdx
  8031a1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8031a8:	48 89 d6             	mov    %rdx,%rsi
  8031ab:	48 89 c7             	mov    %rax,%rdi
  8031ae:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  8031b5:	00 00 00 
  8031b8:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8031ba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031bd:	01 45 fc             	add    %eax,-0x4(%rbp)
  8031c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c3:	48 98                	cltq   
  8031c5:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8031cc:	0f 82 78 ff ff ff    	jb     80314a <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8031d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031d5:	c9                   	leaveq 
  8031d6:	c3                   	retq   

00000000008031d7 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8031d7:	55                   	push   %rbp
  8031d8:	48 89 e5             	mov    %rsp,%rbp
  8031db:	48 83 ec 08          	sub    $0x8,%rsp
  8031df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8031e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031e8:	c9                   	leaveq 
  8031e9:	c3                   	retq   

00000000008031ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8031ea:	55                   	push   %rbp
  8031eb:	48 89 e5             	mov    %rsp,%rbp
  8031ee:	48 83 ec 10          	sub    $0x10,%rsp
  8031f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8031fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031fe:	48 be 92 3b 80 00 00 	movabs $0x803b92,%rsi
  803205:	00 00 00 
  803208:	48 89 c7             	mov    %rax,%rdi
  80320b:	48 b8 86 10 80 00 00 	movabs $0x801086,%rax
  803212:	00 00 00 
  803215:	ff d0                	callq  *%rax
	return 0;
  803217:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80321c:	c9                   	leaveq 
  80321d:	c3                   	retq   

000000000080321e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80321e:	55                   	push   %rbp
  80321f:	48 89 e5             	mov    %rsp,%rbp
  803222:	53                   	push   %rbx
  803223:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80322a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803231:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803237:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80323e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803245:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80324c:	84 c0                	test   %al,%al
  80324e:	74 23                	je     803273 <_panic+0x55>
  803250:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803257:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80325b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80325f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803263:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803267:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80326b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80326f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803273:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80327a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803281:	00 00 00 
  803284:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80328b:	00 00 00 
  80328e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803292:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803299:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8032a0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8032a7:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8032ae:	00 00 00 
  8032b1:	48 8b 18             	mov    (%rax),%rbx
  8032b4:	48 b8 39 19 80 00 00 	movabs $0x801939,%rax
  8032bb:	00 00 00 
  8032be:	ff d0                	callq  *%rax
  8032c0:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8032c6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8032cd:	41 89 c8             	mov    %ecx,%r8d
  8032d0:	48 89 d1             	mov    %rdx,%rcx
  8032d3:	48 89 da             	mov    %rbx,%rdx
  8032d6:	89 c6                	mov    %eax,%esi
  8032d8:	48 bf a0 3b 80 00 00 	movabs $0x803ba0,%rdi
  8032df:	00 00 00 
  8032e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e7:	49 b9 de 02 80 00 00 	movabs $0x8002de,%r9
  8032ee:	00 00 00 
  8032f1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8032f4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8032fb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803302:	48 89 d6             	mov    %rdx,%rsi
  803305:	48 89 c7             	mov    %rax,%rdi
  803308:	48 b8 32 02 80 00 00 	movabs $0x800232,%rax
  80330f:	00 00 00 
  803312:	ff d0                	callq  *%rax
	cprintf("\n");
  803314:	48 bf c3 3b 80 00 00 	movabs $0x803bc3,%rdi
  80331b:	00 00 00 
  80331e:	b8 00 00 00 00       	mov    $0x0,%eax
  803323:	48 ba de 02 80 00 00 	movabs $0x8002de,%rdx
  80332a:	00 00 00 
  80332d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80332f:	cc                   	int3   
  803330:	eb fd                	jmp    80332f <_panic+0x111>

0000000000803332 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803332:	55                   	push   %rbp
  803333:	48 89 e5             	mov    %rsp,%rbp
  803336:	48 83 ec 30          	sub    $0x30,%rsp
  80333a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80333e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803342:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803346:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80334a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  80334e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803353:	75 0e                	jne    803363 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  803355:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  80335c:	00 00 00 
  80335f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  803363:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803367:	48 89 c7             	mov    %rax,%rdi
  80336a:	48 b8 de 1b 80 00 00 	movabs $0x801bde,%rax
  803371:	00 00 00 
  803374:	ff d0                	callq  *%rax
  803376:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803379:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80337d:	79 27                	jns    8033a6 <ipc_recv+0x74>
		if (from_env_store != NULL)
  80337f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803384:	74 0a                	je     803390 <ipc_recv+0x5e>
			*from_env_store = 0;
  803386:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80338a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  803390:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803395:	74 0a                	je     8033a1 <ipc_recv+0x6f>
			*perm_store = 0;
  803397:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80339b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8033a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033a4:	eb 53                	jmp    8033f9 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  8033a6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033ab:	74 19                	je     8033c6 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  8033ad:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033b4:	00 00 00 
  8033b7:	48 8b 00             	mov    (%rax),%rax
  8033ba:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8033c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033c4:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  8033c6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033cb:	74 19                	je     8033e6 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  8033cd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033d4:	00 00 00 
  8033d7:	48 8b 00             	mov    (%rax),%rax
  8033da:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8033e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033e4:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  8033e6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033ed:	00 00 00 
  8033f0:	48 8b 00             	mov    (%rax),%rax
  8033f3:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  8033f9:	c9                   	leaveq 
  8033fa:	c3                   	retq   

00000000008033fb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8033fb:	55                   	push   %rbp
  8033fc:	48 89 e5             	mov    %rsp,%rbp
  8033ff:	48 83 ec 30          	sub    $0x30,%rsp
  803403:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803406:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803409:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80340d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803410:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803414:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803418:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80341d:	75 10                	jne    80342f <ipc_send+0x34>
		page = (void *)KERNBASE;
  80341f:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803426:	00 00 00 
  803429:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  80342d:	eb 0e                	jmp    80343d <ipc_send+0x42>
  80342f:	eb 0c                	jmp    80343d <ipc_send+0x42>
		sys_yield();
  803431:	48 b8 77 19 80 00 00 	movabs $0x801977,%rax
  803438:	00 00 00 
  80343b:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  80343d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803440:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803443:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803447:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80344a:	89 c7                	mov    %eax,%edi
  80344c:	48 b8 89 1b 80 00 00 	movabs $0x801b89,%rax
  803453:	00 00 00 
  803456:	ff d0                	callq  *%rax
  803458:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80345b:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  80345f:	74 d0                	je     803431 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  803461:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803465:	74 2a                	je     803491 <ipc_send+0x96>
		panic("error on ipc send procedure");
  803467:	48 ba c5 3b 80 00 00 	movabs $0x803bc5,%rdx
  80346e:	00 00 00 
  803471:	be 49 00 00 00       	mov    $0x49,%esi
  803476:	48 bf e1 3b 80 00 00 	movabs $0x803be1,%rdi
  80347d:	00 00 00 
  803480:	b8 00 00 00 00       	mov    $0x0,%eax
  803485:	48 b9 1e 32 80 00 00 	movabs $0x80321e,%rcx
  80348c:	00 00 00 
  80348f:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  803491:	c9                   	leaveq 
  803492:	c3                   	retq   

0000000000803493 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803493:	55                   	push   %rbp
  803494:	48 89 e5             	mov    %rsp,%rbp
  803497:	48 83 ec 14          	sub    $0x14,%rsp
  80349b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80349e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034a5:	eb 5e                	jmp    803505 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8034a7:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8034ae:	00 00 00 
  8034b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034b4:	48 63 d0             	movslq %eax,%rdx
  8034b7:	48 89 d0             	mov    %rdx,%rax
  8034ba:	48 c1 e0 03          	shl    $0x3,%rax
  8034be:	48 01 d0             	add    %rdx,%rax
  8034c1:	48 c1 e0 05          	shl    $0x5,%rax
  8034c5:	48 01 c8             	add    %rcx,%rax
  8034c8:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8034ce:	8b 00                	mov    (%rax),%eax
  8034d0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8034d3:	75 2c                	jne    803501 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8034d5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8034dc:	00 00 00 
  8034df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e2:	48 63 d0             	movslq %eax,%rdx
  8034e5:	48 89 d0             	mov    %rdx,%rax
  8034e8:	48 c1 e0 03          	shl    $0x3,%rax
  8034ec:	48 01 d0             	add    %rdx,%rax
  8034ef:	48 c1 e0 05          	shl    $0x5,%rax
  8034f3:	48 01 c8             	add    %rcx,%rax
  8034f6:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8034fc:	8b 40 08             	mov    0x8(%rax),%eax
  8034ff:	eb 12                	jmp    803513 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803501:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803505:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80350c:	7e 99                	jle    8034a7 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80350e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803513:	c9                   	leaveq 
  803514:	c3                   	retq   

0000000000803515 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803515:	55                   	push   %rbp
  803516:	48 89 e5             	mov    %rsp,%rbp
  803519:	48 83 ec 18          	sub    $0x18,%rsp
  80351d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803521:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803525:	48 c1 e8 15          	shr    $0x15,%rax
  803529:	48 89 c2             	mov    %rax,%rdx
  80352c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803533:	01 00 00 
  803536:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80353a:	83 e0 01             	and    $0x1,%eax
  80353d:	48 85 c0             	test   %rax,%rax
  803540:	75 07                	jne    803549 <pageref+0x34>
		return 0;
  803542:	b8 00 00 00 00       	mov    $0x0,%eax
  803547:	eb 53                	jmp    80359c <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803549:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80354d:	48 c1 e8 0c          	shr    $0xc,%rax
  803551:	48 89 c2             	mov    %rax,%rdx
  803554:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80355b:	01 00 00 
  80355e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803562:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803566:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80356a:	83 e0 01             	and    $0x1,%eax
  80356d:	48 85 c0             	test   %rax,%rax
  803570:	75 07                	jne    803579 <pageref+0x64>
		return 0;
  803572:	b8 00 00 00 00       	mov    $0x0,%eax
  803577:	eb 23                	jmp    80359c <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803579:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80357d:	48 c1 e8 0c          	shr    $0xc,%rax
  803581:	48 89 c2             	mov    %rax,%rdx
  803584:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80358b:	00 00 00 
  80358e:	48 c1 e2 04          	shl    $0x4,%rdx
  803592:	48 01 d0             	add    %rdx,%rax
  803595:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803599:	0f b7 c0             	movzwl %ax,%eax
}
  80359c:	c9                   	leaveq 
  80359d:	c3                   	retq   
