
obj/user/fairness.debug:     file format elf64-x86-64


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
  80003c:	e8 dd 00 00 00       	callq  80011e <libmain>
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
	envid_t who, id;

	id = sys_getenvid();
  800052:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 fc             	mov    %eax,-0x4(%rbp)

	if (thisenv == &envs[1]) {
  800061:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800068:	00 00 00 
  80006b:	48 8b 10             	mov    (%rax),%rdx
  80006e:	48 b8 20 01 80 00 80 	movabs $0x8000800120,%rax
  800075:	00 00 00 
  800078:	48 39 c2             	cmp    %rax,%rdx
  80007b:	75 42                	jne    8000bf <umain+0x7c>
		while (1) {
			ipc_recv(&who, 0, 0);
  80007d:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
  800081:	ba 00 00 00 00       	mov    $0x0,%edx
  800086:	be 00 00 00 00       	mov    $0x0,%esi
  80008b:	48 89 c7             	mov    %rax,%rdi
  80008e:	48 b8 3a 1c 80 00 00 	movabs $0x801c3a,%rax
  800095:	00 00 00 
  800098:	ff d0                	callq  *%rax
			cprintf("%x recv from %x\n", id, who);
  80009a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80009d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a0:	89 c6                	mov    %eax,%esi
  8000a2:	48 bf c0 35 80 00 00 	movabs $0x8035c0,%rdi
  8000a9:	00 00 00 
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	48 b9 f6 02 80 00 00 	movabs $0x8002f6,%rcx
  8000b8:	00 00 00 
  8000bb:	ff d1                	callq  *%rcx
		}
  8000bd:	eb be                	jmp    80007d <umain+0x3a>
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  8000bf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000c6:	00 00 00 
  8000c9:	8b 90 e8 01 00 00    	mov    0x1e8(%rax),%edx
  8000cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d2:	89 c6                	mov    %eax,%esi
  8000d4:	48 bf d1 35 80 00 00 	movabs $0x8035d1,%rdi
  8000db:	00 00 00 
  8000de:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e3:	48 b9 f6 02 80 00 00 	movabs $0x8002f6,%rcx
  8000ea:	00 00 00 
  8000ed:	ff d1                	callq  *%rcx
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  8000ef:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000f6:	00 00 00 
  8000f9:	8b 80 e8 01 00 00    	mov    0x1e8(%rax),%eax
  8000ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800104:	ba 00 00 00 00       	mov    $0x0,%edx
  800109:	be 00 00 00 00       	mov    $0x0,%esi
  80010e:	89 c7                	mov    %eax,%edi
  800110:	48 b8 03 1d 80 00 00 	movabs $0x801d03,%rax
  800117:	00 00 00 
  80011a:	ff d0                	callq  *%rax
  80011c:	eb d1                	jmp    8000ef <umain+0xac>

000000000080011e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80011e:	55                   	push   %rbp
  80011f:	48 89 e5             	mov    %rsp,%rbp
  800122:	48 83 ec 10          	sub    $0x10,%rsp
  800126:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800129:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80012d:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
  800139:	48 98                	cltq   
  80013b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800140:	48 89 c2             	mov    %rax,%rdx
  800143:	48 89 d0             	mov    %rdx,%rax
  800146:	48 c1 e0 03          	shl    $0x3,%rax
  80014a:	48 01 d0             	add    %rdx,%rax
  80014d:	48 c1 e0 05          	shl    $0x5,%rax
  800151:	48 89 c2             	mov    %rax,%rdx
  800154:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80015b:	00 00 00 
  80015e:	48 01 c2             	add    %rax,%rdx
  800161:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800168:	00 00 00 
  80016b:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800172:	7e 14                	jle    800188 <libmain+0x6a>
		binaryname = argv[0];
  800174:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800178:	48 8b 10             	mov    (%rax),%rdx
  80017b:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800182:	00 00 00 
  800185:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800188:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80018c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80018f:	48 89 d6             	mov    %rdx,%rsi
  800192:	89 c7                	mov    %eax,%edi
  800194:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001a0:	48 b8 ae 01 80 00 00 	movabs $0x8001ae,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
}
  8001ac:	c9                   	leaveq 
  8001ad:	c3                   	retq   

00000000008001ae <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ae:	55                   	push   %rbp
  8001af:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001b2:	48 b8 5e 21 80 00 00 	movabs $0x80215e,%rax
  8001b9:	00 00 00 
  8001bc:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001be:	bf 00 00 00 00       	mov    $0x0,%edi
  8001c3:	48 b8 0d 19 80 00 00 	movabs $0x80190d,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	callq  *%rax
}
  8001cf:	5d                   	pop    %rbp
  8001d0:	c3                   	retq   

00000000008001d1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d1:	55                   	push   %rbp
  8001d2:	48 89 e5             	mov    %rsp,%rbp
  8001d5:	48 83 ec 10          	sub    $0x10,%rsp
  8001d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8001e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001e4:	8b 00                	mov    (%rax),%eax
  8001e6:	8d 48 01             	lea    0x1(%rax),%ecx
  8001e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ed:	89 0a                	mov    %ecx,(%rdx)
  8001ef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001f2:	89 d1                	mov    %edx,%ecx
  8001f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001f8:	48 98                	cltq   
  8001fa:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8001fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800202:	8b 00                	mov    (%rax),%eax
  800204:	3d ff 00 00 00       	cmp    $0xff,%eax
  800209:	75 2c                	jne    800237 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80020b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020f:	8b 00                	mov    (%rax),%eax
  800211:	48 98                	cltq   
  800213:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800217:	48 83 c2 08          	add    $0x8,%rdx
  80021b:	48 89 c6             	mov    %rax,%rsi
  80021e:	48 89 d7             	mov    %rdx,%rdi
  800221:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  800228:	00 00 00 
  80022b:	ff d0                	callq  *%rax
		b->idx = 0;
  80022d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800231:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800237:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80023b:	8b 40 04             	mov    0x4(%rax),%eax
  80023e:	8d 50 01             	lea    0x1(%rax),%edx
  800241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800245:	89 50 04             	mov    %edx,0x4(%rax)
}
  800248:	c9                   	leaveq 
  800249:	c3                   	retq   

000000000080024a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80024a:	55                   	push   %rbp
  80024b:	48 89 e5             	mov    %rsp,%rbp
  80024e:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800255:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80025c:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800263:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80026a:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800271:	48 8b 0a             	mov    (%rdx),%rcx
  800274:	48 89 08             	mov    %rcx,(%rax)
  800277:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80027b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80027f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800283:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800287:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80028e:	00 00 00 
	b.cnt = 0;
  800291:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800298:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80029b:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002a2:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002a9:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002b0:	48 89 c6             	mov    %rax,%rsi
  8002b3:	48 bf d1 01 80 00 00 	movabs $0x8001d1,%rdi
  8002ba:	00 00 00 
  8002bd:	48 b8 a9 06 80 00 00 	movabs $0x8006a9,%rax
  8002c4:	00 00 00 
  8002c7:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8002c9:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002cf:	48 98                	cltq   
  8002d1:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002d8:	48 83 c2 08          	add    $0x8,%rdx
  8002dc:	48 89 c6             	mov    %rax,%rsi
  8002df:	48 89 d7             	mov    %rdx,%rdi
  8002e2:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  8002e9:	00 00 00 
  8002ec:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8002ee:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002f4:	c9                   	leaveq 
  8002f5:	c3                   	retq   

00000000008002f6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002f6:	55                   	push   %rbp
  8002f7:	48 89 e5             	mov    %rsp,%rbp
  8002fa:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800301:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800308:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80030f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800316:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80031d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800324:	84 c0                	test   %al,%al
  800326:	74 20                	je     800348 <cprintf+0x52>
  800328:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80032c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800330:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800334:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800338:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80033c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800340:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800344:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800348:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80034f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800356:	00 00 00 
  800359:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800360:	00 00 00 
  800363:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800367:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80036e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800375:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80037c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800383:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80038a:	48 8b 0a             	mov    (%rdx),%rcx
  80038d:	48 89 08             	mov    %rcx,(%rax)
  800390:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800394:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800398:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80039c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8003a0:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003a7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003ae:	48 89 d6             	mov    %rdx,%rsi
  8003b1:	48 89 c7             	mov    %rax,%rdi
  8003b4:	48 b8 4a 02 80 00 00 	movabs $0x80024a,%rax
  8003bb:	00 00 00 
  8003be:	ff d0                	callq  *%rax
  8003c0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8003c6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003cc:	c9                   	leaveq 
  8003cd:	c3                   	retq   

00000000008003ce <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ce:	55                   	push   %rbp
  8003cf:	48 89 e5             	mov    %rsp,%rbp
  8003d2:	53                   	push   %rbx
  8003d3:	48 83 ec 38          	sub    $0x38,%rsp
  8003d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8003df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8003e3:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003e6:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003ea:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ee:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003f1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003f5:	77 3b                	ja     800432 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003f7:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003fa:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003fe:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800401:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800405:	ba 00 00 00 00       	mov    $0x0,%edx
  80040a:	48 f7 f3             	div    %rbx
  80040d:	48 89 c2             	mov    %rax,%rdx
  800410:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800413:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800416:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80041a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80041e:	41 89 f9             	mov    %edi,%r9d
  800421:	48 89 c7             	mov    %rax,%rdi
  800424:	48 b8 ce 03 80 00 00 	movabs $0x8003ce,%rax
  80042b:	00 00 00 
  80042e:	ff d0                	callq  *%rax
  800430:	eb 1e                	jmp    800450 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800432:	eb 12                	jmp    800446 <printnum+0x78>
			putch(padc, putdat);
  800434:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800438:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80043b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043f:	48 89 ce             	mov    %rcx,%rsi
  800442:	89 d7                	mov    %edx,%edi
  800444:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800446:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80044a:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80044e:	7f e4                	jg     800434 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800450:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800457:	ba 00 00 00 00       	mov    $0x0,%edx
  80045c:	48 f7 f1             	div    %rcx
  80045f:	48 89 d0             	mov    %rdx,%rax
  800462:	48 ba c8 37 80 00 00 	movabs $0x8037c8,%rdx
  800469:	00 00 00 
  80046c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800470:	0f be d0             	movsbl %al,%edx
  800473:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800477:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80047b:	48 89 ce             	mov    %rcx,%rsi
  80047e:	89 d7                	mov    %edx,%edi
  800480:	ff d0                	callq  *%rax
}
  800482:	48 83 c4 38          	add    $0x38,%rsp
  800486:	5b                   	pop    %rbx
  800487:	5d                   	pop    %rbp
  800488:	c3                   	retq   

0000000000800489 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800489:	55                   	push   %rbp
  80048a:	48 89 e5             	mov    %rsp,%rbp
  80048d:	48 83 ec 1c          	sub    $0x1c,%rsp
  800491:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800495:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800498:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80049c:	7e 52                	jle    8004f0 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80049e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a2:	8b 00                	mov    (%rax),%eax
  8004a4:	83 f8 30             	cmp    $0x30,%eax
  8004a7:	73 24                	jae    8004cd <getuint+0x44>
  8004a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ad:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b5:	8b 00                	mov    (%rax),%eax
  8004b7:	89 c0                	mov    %eax,%eax
  8004b9:	48 01 d0             	add    %rdx,%rax
  8004bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c0:	8b 12                	mov    (%rdx),%edx
  8004c2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c9:	89 0a                	mov    %ecx,(%rdx)
  8004cb:	eb 17                	jmp    8004e4 <getuint+0x5b>
  8004cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004d5:	48 89 d0             	mov    %rdx,%rax
  8004d8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004e4:	48 8b 00             	mov    (%rax),%rax
  8004e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004eb:	e9 a3 00 00 00       	jmpq   800593 <getuint+0x10a>
	else if (lflag)
  8004f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004f4:	74 4f                	je     800545 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fa:	8b 00                	mov    (%rax),%eax
  8004fc:	83 f8 30             	cmp    $0x30,%eax
  8004ff:	73 24                	jae    800525 <getuint+0x9c>
  800501:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800505:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050d:	8b 00                	mov    (%rax),%eax
  80050f:	89 c0                	mov    %eax,%eax
  800511:	48 01 d0             	add    %rdx,%rax
  800514:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800518:	8b 12                	mov    (%rdx),%edx
  80051a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80051d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800521:	89 0a                	mov    %ecx,(%rdx)
  800523:	eb 17                	jmp    80053c <getuint+0xb3>
  800525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800529:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80052d:	48 89 d0             	mov    %rdx,%rax
  800530:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800534:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800538:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80053c:	48 8b 00             	mov    (%rax),%rax
  80053f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800543:	eb 4e                	jmp    800593 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800545:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800549:	8b 00                	mov    (%rax),%eax
  80054b:	83 f8 30             	cmp    $0x30,%eax
  80054e:	73 24                	jae    800574 <getuint+0xeb>
  800550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800554:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800558:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055c:	8b 00                	mov    (%rax),%eax
  80055e:	89 c0                	mov    %eax,%eax
  800560:	48 01 d0             	add    %rdx,%rax
  800563:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800567:	8b 12                	mov    (%rdx),%edx
  800569:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80056c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800570:	89 0a                	mov    %ecx,(%rdx)
  800572:	eb 17                	jmp    80058b <getuint+0x102>
  800574:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800578:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80057c:	48 89 d0             	mov    %rdx,%rax
  80057f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800583:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800587:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80058b:	8b 00                	mov    (%rax),%eax
  80058d:	89 c0                	mov    %eax,%eax
  80058f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800593:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800597:	c9                   	leaveq 
  800598:	c3                   	retq   

0000000000800599 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800599:	55                   	push   %rbp
  80059a:	48 89 e5             	mov    %rsp,%rbp
  80059d:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005a5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005a8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005ac:	7e 52                	jle    800600 <getint+0x67>
		x=va_arg(*ap, long long);
  8005ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b2:	8b 00                	mov    (%rax),%eax
  8005b4:	83 f8 30             	cmp    $0x30,%eax
  8005b7:	73 24                	jae    8005dd <getint+0x44>
  8005b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c5:	8b 00                	mov    (%rax),%eax
  8005c7:	89 c0                	mov    %eax,%eax
  8005c9:	48 01 d0             	add    %rdx,%rax
  8005cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d0:	8b 12                	mov    (%rdx),%edx
  8005d2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d9:	89 0a                	mov    %ecx,(%rdx)
  8005db:	eb 17                	jmp    8005f4 <getint+0x5b>
  8005dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005e5:	48 89 d0             	mov    %rdx,%rax
  8005e8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005f4:	48 8b 00             	mov    (%rax),%rax
  8005f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005fb:	e9 a3 00 00 00       	jmpq   8006a3 <getint+0x10a>
	else if (lflag)
  800600:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800604:	74 4f                	je     800655 <getint+0xbc>
		x=va_arg(*ap, long);
  800606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060a:	8b 00                	mov    (%rax),%eax
  80060c:	83 f8 30             	cmp    $0x30,%eax
  80060f:	73 24                	jae    800635 <getint+0x9c>
  800611:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800615:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800619:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061d:	8b 00                	mov    (%rax),%eax
  80061f:	89 c0                	mov    %eax,%eax
  800621:	48 01 d0             	add    %rdx,%rax
  800624:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800628:	8b 12                	mov    (%rdx),%edx
  80062a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80062d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800631:	89 0a                	mov    %ecx,(%rdx)
  800633:	eb 17                	jmp    80064c <getint+0xb3>
  800635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800639:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80063d:	48 89 d0             	mov    %rdx,%rax
  800640:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800644:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800648:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80064c:	48 8b 00             	mov    (%rax),%rax
  80064f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800653:	eb 4e                	jmp    8006a3 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800655:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800659:	8b 00                	mov    (%rax),%eax
  80065b:	83 f8 30             	cmp    $0x30,%eax
  80065e:	73 24                	jae    800684 <getint+0xeb>
  800660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800664:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800668:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066c:	8b 00                	mov    (%rax),%eax
  80066e:	89 c0                	mov    %eax,%eax
  800670:	48 01 d0             	add    %rdx,%rax
  800673:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800677:	8b 12                	mov    (%rdx),%edx
  800679:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80067c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800680:	89 0a                	mov    %ecx,(%rdx)
  800682:	eb 17                	jmp    80069b <getint+0x102>
  800684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800688:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80068c:	48 89 d0             	mov    %rdx,%rax
  80068f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800693:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800697:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80069b:	8b 00                	mov    (%rax),%eax
  80069d:	48 98                	cltq   
  80069f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006a7:	c9                   	leaveq 
  8006a8:	c3                   	retq   

00000000008006a9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006a9:	55                   	push   %rbp
  8006aa:	48 89 e5             	mov    %rsp,%rbp
  8006ad:	41 54                	push   %r12
  8006af:	53                   	push   %rbx
  8006b0:	48 83 ec 60          	sub    $0x60,%rsp
  8006b4:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006b8:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006bc:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006c0:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006c4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006c8:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006cc:	48 8b 0a             	mov    (%rdx),%rcx
  8006cf:	48 89 08             	mov    %rcx,(%rax)
  8006d2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006d6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006da:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006de:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  8006e2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006e6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006ea:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006ee:	0f b6 00             	movzbl (%rax),%eax
  8006f1:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  8006f4:	eb 29                	jmp    80071f <vprintfmt+0x76>
			if (ch == '\0')
  8006f6:	85 db                	test   %ebx,%ebx
  8006f8:	0f 84 ad 06 00 00    	je     800dab <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  8006fe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800702:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800706:	48 89 d6             	mov    %rdx,%rsi
  800709:	89 df                	mov    %ebx,%edi
  80070b:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  80070d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800711:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800715:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800719:	0f b6 00             	movzbl (%rax),%eax
  80071c:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  80071f:	83 fb 25             	cmp    $0x25,%ebx
  800722:	74 05                	je     800729 <vprintfmt+0x80>
  800724:	83 fb 1b             	cmp    $0x1b,%ebx
  800727:	75 cd                	jne    8006f6 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800729:	83 fb 1b             	cmp    $0x1b,%ebx
  80072c:	0f 85 ae 01 00 00    	jne    8008e0 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  800732:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800739:	00 00 00 
  80073c:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  800742:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800746:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80074a:	48 89 d6             	mov    %rdx,%rsi
  80074d:	89 df                	mov    %ebx,%edi
  80074f:	ff d0                	callq  *%rax
			putch('[', putdat);
  800751:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800755:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800759:	48 89 d6             	mov    %rdx,%rsi
  80075c:	bf 5b 00 00 00       	mov    $0x5b,%edi
  800761:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800763:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800769:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80076e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800772:	0f b6 00             	movzbl (%rax),%eax
  800775:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800778:	eb 32                	jmp    8007ac <vprintfmt+0x103>
					putch(ch, putdat);
  80077a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80077e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800782:	48 89 d6             	mov    %rdx,%rsi
  800785:	89 df                	mov    %ebx,%edi
  800787:	ff d0                	callq  *%rax
					esc_color *= 10;
  800789:	44 89 e0             	mov    %r12d,%eax
  80078c:	c1 e0 02             	shl    $0x2,%eax
  80078f:	44 01 e0             	add    %r12d,%eax
  800792:	01 c0                	add    %eax,%eax
  800794:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800797:	8d 43 d0             	lea    -0x30(%rbx),%eax
  80079a:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  80079d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8007a2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007a6:	0f b6 00             	movzbl (%rax),%eax
  8007a9:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8007ac:	83 fb 3b             	cmp    $0x3b,%ebx
  8007af:	74 05                	je     8007b6 <vprintfmt+0x10d>
  8007b1:	83 fb 6d             	cmp    $0x6d,%ebx
  8007b4:	75 c4                	jne    80077a <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  8007b6:	45 85 e4             	test   %r12d,%r12d
  8007b9:	75 15                	jne    8007d0 <vprintfmt+0x127>
					color_flag = 0x07;
  8007bb:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8007c2:	00 00 00 
  8007c5:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  8007cb:	e9 dc 00 00 00       	jmpq   8008ac <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  8007d0:	41 83 fc 1d          	cmp    $0x1d,%r12d
  8007d4:	7e 69                	jle    80083f <vprintfmt+0x196>
  8007d6:	41 83 fc 25          	cmp    $0x25,%r12d
  8007da:	7f 63                	jg     80083f <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  8007dc:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8007e3:	00 00 00 
  8007e6:	8b 00                	mov    (%rax),%eax
  8007e8:	25 f8 00 00 00       	and    $0xf8,%eax
  8007ed:	89 c2                	mov    %eax,%edx
  8007ef:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8007f6:	00 00 00 
  8007f9:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  8007fb:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  8007ff:	44 89 e0             	mov    %r12d,%eax
  800802:	83 e0 04             	and    $0x4,%eax
  800805:	c1 f8 02             	sar    $0x2,%eax
  800808:	89 c2                	mov    %eax,%edx
  80080a:	44 89 e0             	mov    %r12d,%eax
  80080d:	83 e0 02             	and    $0x2,%eax
  800810:	09 c2                	or     %eax,%edx
  800812:	44 89 e0             	mov    %r12d,%eax
  800815:	83 e0 01             	and    $0x1,%eax
  800818:	c1 e0 02             	shl    $0x2,%eax
  80081b:	09 c2                	or     %eax,%edx
  80081d:	41 89 d4             	mov    %edx,%r12d
  800820:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800827:	00 00 00 
  80082a:	8b 00                	mov    (%rax),%eax
  80082c:	44 89 e2             	mov    %r12d,%edx
  80082f:	09 c2                	or     %eax,%edx
  800831:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800838:	00 00 00 
  80083b:	89 10                	mov    %edx,(%rax)
  80083d:	eb 6d                	jmp    8008ac <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  80083f:	41 83 fc 27          	cmp    $0x27,%r12d
  800843:	7e 67                	jle    8008ac <vprintfmt+0x203>
  800845:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800849:	7f 61                	jg     8008ac <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  80084b:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800852:	00 00 00 
  800855:	8b 00                	mov    (%rax),%eax
  800857:	25 8f 00 00 00       	and    $0x8f,%eax
  80085c:	89 c2                	mov    %eax,%edx
  80085e:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800865:	00 00 00 
  800868:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  80086a:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  80086e:	44 89 e0             	mov    %r12d,%eax
  800871:	83 e0 04             	and    $0x4,%eax
  800874:	c1 f8 02             	sar    $0x2,%eax
  800877:	89 c2                	mov    %eax,%edx
  800879:	44 89 e0             	mov    %r12d,%eax
  80087c:	83 e0 02             	and    $0x2,%eax
  80087f:	09 c2                	or     %eax,%edx
  800881:	44 89 e0             	mov    %r12d,%eax
  800884:	83 e0 01             	and    $0x1,%eax
  800887:	c1 e0 06             	shl    $0x6,%eax
  80088a:	09 c2                	or     %eax,%edx
  80088c:	41 89 d4             	mov    %edx,%r12d
  80088f:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800896:	00 00 00 
  800899:	8b 00                	mov    (%rax),%eax
  80089b:	44 89 e2             	mov    %r12d,%edx
  80089e:	09 c2                	or     %eax,%edx
  8008a0:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8008a7:	00 00 00 
  8008aa:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  8008ac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008b0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b4:	48 89 d6             	mov    %rdx,%rsi
  8008b7:	89 df                	mov    %ebx,%edi
  8008b9:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  8008bb:	83 fb 6d             	cmp    $0x6d,%ebx
  8008be:	75 1b                	jne    8008db <vprintfmt+0x232>
					fmt ++;
  8008c0:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  8008c5:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  8008c6:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8008cd:	00 00 00 
  8008d0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  8008d6:	e9 cb 04 00 00       	jmpq   800da6 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  8008db:	e9 83 fe ff ff       	jmpq   800763 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  8008e0:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008e4:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008eb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008f9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800900:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800904:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800908:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80090c:	0f b6 00             	movzbl (%rax),%eax
  80090f:	0f b6 d8             	movzbl %al,%ebx
  800912:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800915:	83 f8 55             	cmp    $0x55,%eax
  800918:	0f 87 5a 04 00 00    	ja     800d78 <vprintfmt+0x6cf>
  80091e:	89 c0                	mov    %eax,%eax
  800920:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800927:	00 
  800928:	48 b8 f0 37 80 00 00 	movabs $0x8037f0,%rax
  80092f:	00 00 00 
  800932:	48 01 d0             	add    %rdx,%rax
  800935:	48 8b 00             	mov    (%rax),%rax
  800938:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  80093a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80093e:	eb c0                	jmp    800900 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800940:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800944:	eb ba                	jmp    800900 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800946:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80094d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800950:	89 d0                	mov    %edx,%eax
  800952:	c1 e0 02             	shl    $0x2,%eax
  800955:	01 d0                	add    %edx,%eax
  800957:	01 c0                	add    %eax,%eax
  800959:	01 d8                	add    %ebx,%eax
  80095b:	83 e8 30             	sub    $0x30,%eax
  80095e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800961:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800965:	0f b6 00             	movzbl (%rax),%eax
  800968:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80096b:	83 fb 2f             	cmp    $0x2f,%ebx
  80096e:	7e 0c                	jle    80097c <vprintfmt+0x2d3>
  800970:	83 fb 39             	cmp    $0x39,%ebx
  800973:	7f 07                	jg     80097c <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800975:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80097a:	eb d1                	jmp    80094d <vprintfmt+0x2a4>
			goto process_precision;
  80097c:	eb 58                	jmp    8009d6 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  80097e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800981:	83 f8 30             	cmp    $0x30,%eax
  800984:	73 17                	jae    80099d <vprintfmt+0x2f4>
  800986:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80098a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80098d:	89 c0                	mov    %eax,%eax
  80098f:	48 01 d0             	add    %rdx,%rax
  800992:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800995:	83 c2 08             	add    $0x8,%edx
  800998:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80099b:	eb 0f                	jmp    8009ac <vprintfmt+0x303>
  80099d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009a1:	48 89 d0             	mov    %rdx,%rax
  8009a4:	48 83 c2 08          	add    $0x8,%rdx
  8009a8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009ac:	8b 00                	mov    (%rax),%eax
  8009ae:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009b1:	eb 23                	jmp    8009d6 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  8009b3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009b7:	79 0c                	jns    8009c5 <vprintfmt+0x31c>
				width = 0;
  8009b9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009c0:	e9 3b ff ff ff       	jmpq   800900 <vprintfmt+0x257>
  8009c5:	e9 36 ff ff ff       	jmpq   800900 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  8009ca:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009d1:	e9 2a ff ff ff       	jmpq   800900 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  8009d6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009da:	79 12                	jns    8009ee <vprintfmt+0x345>
				width = precision, precision = -1;
  8009dc:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009df:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009e2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009e9:	e9 12 ff ff ff       	jmpq   800900 <vprintfmt+0x257>
  8009ee:	e9 0d ff ff ff       	jmpq   800900 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009f3:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009f7:	e9 04 ff ff ff       	jmpq   800900 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009fc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ff:	83 f8 30             	cmp    $0x30,%eax
  800a02:	73 17                	jae    800a1b <vprintfmt+0x372>
  800a04:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0b:	89 c0                	mov    %eax,%eax
  800a0d:	48 01 d0             	add    %rdx,%rax
  800a10:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a13:	83 c2 08             	add    $0x8,%edx
  800a16:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a19:	eb 0f                	jmp    800a2a <vprintfmt+0x381>
  800a1b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a1f:	48 89 d0             	mov    %rdx,%rax
  800a22:	48 83 c2 08          	add    $0x8,%rdx
  800a26:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a2a:	8b 10                	mov    (%rax),%edx
  800a2c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a34:	48 89 ce             	mov    %rcx,%rsi
  800a37:	89 d7                	mov    %edx,%edi
  800a39:	ff d0                	callq  *%rax
			break;
  800a3b:	e9 66 03 00 00       	jmpq   800da6 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800a40:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a43:	83 f8 30             	cmp    $0x30,%eax
  800a46:	73 17                	jae    800a5f <vprintfmt+0x3b6>
  800a48:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a4c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a4f:	89 c0                	mov    %eax,%eax
  800a51:	48 01 d0             	add    %rdx,%rax
  800a54:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a57:	83 c2 08             	add    $0x8,%edx
  800a5a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a5d:	eb 0f                	jmp    800a6e <vprintfmt+0x3c5>
  800a5f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a63:	48 89 d0             	mov    %rdx,%rax
  800a66:	48 83 c2 08          	add    $0x8,%rdx
  800a6a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a6e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a70:	85 db                	test   %ebx,%ebx
  800a72:	79 02                	jns    800a76 <vprintfmt+0x3cd>
				err = -err;
  800a74:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a76:	83 fb 10             	cmp    $0x10,%ebx
  800a79:	7f 16                	jg     800a91 <vprintfmt+0x3e8>
  800a7b:	48 b8 40 37 80 00 00 	movabs $0x803740,%rax
  800a82:	00 00 00 
  800a85:	48 63 d3             	movslq %ebx,%rdx
  800a88:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a8c:	4d 85 e4             	test   %r12,%r12
  800a8f:	75 2e                	jne    800abf <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800a91:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a99:	89 d9                	mov    %ebx,%ecx
  800a9b:	48 ba d9 37 80 00 00 	movabs $0x8037d9,%rdx
  800aa2:	00 00 00 
  800aa5:	48 89 c7             	mov    %rax,%rdi
  800aa8:	b8 00 00 00 00       	mov    $0x0,%eax
  800aad:	49 b8 b4 0d 80 00 00 	movabs $0x800db4,%r8
  800ab4:	00 00 00 
  800ab7:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aba:	e9 e7 02 00 00       	jmpq   800da6 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800abf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ac3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac7:	4c 89 e1             	mov    %r12,%rcx
  800aca:	48 ba e2 37 80 00 00 	movabs $0x8037e2,%rdx
  800ad1:	00 00 00 
  800ad4:	48 89 c7             	mov    %rax,%rdi
  800ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  800adc:	49 b8 b4 0d 80 00 00 	movabs $0x800db4,%r8
  800ae3:	00 00 00 
  800ae6:	41 ff d0             	callq  *%r8
			break;
  800ae9:	e9 b8 02 00 00       	jmpq   800da6 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800aee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af1:	83 f8 30             	cmp    $0x30,%eax
  800af4:	73 17                	jae    800b0d <vprintfmt+0x464>
  800af6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800afa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800afd:	89 c0                	mov    %eax,%eax
  800aff:	48 01 d0             	add    %rdx,%rax
  800b02:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b05:	83 c2 08             	add    $0x8,%edx
  800b08:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b0b:	eb 0f                	jmp    800b1c <vprintfmt+0x473>
  800b0d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b11:	48 89 d0             	mov    %rdx,%rax
  800b14:	48 83 c2 08          	add    $0x8,%rdx
  800b18:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b1c:	4c 8b 20             	mov    (%rax),%r12
  800b1f:	4d 85 e4             	test   %r12,%r12
  800b22:	75 0a                	jne    800b2e <vprintfmt+0x485>
				p = "(null)";
  800b24:	49 bc e5 37 80 00 00 	movabs $0x8037e5,%r12
  800b2b:	00 00 00 
			if (width > 0 && padc != '-')
  800b2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b32:	7e 3f                	jle    800b73 <vprintfmt+0x4ca>
  800b34:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b38:	74 39                	je     800b73 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b3d:	48 98                	cltq   
  800b3f:	48 89 c6             	mov    %rax,%rsi
  800b42:	4c 89 e7             	mov    %r12,%rdi
  800b45:	48 b8 60 10 80 00 00 	movabs $0x801060,%rax
  800b4c:	00 00 00 
  800b4f:	ff d0                	callq  *%rax
  800b51:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b54:	eb 17                	jmp    800b6d <vprintfmt+0x4c4>
					putch(padc, putdat);
  800b56:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b5a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b5e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b62:	48 89 ce             	mov    %rcx,%rsi
  800b65:	89 d7                	mov    %edx,%edi
  800b67:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b69:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b6d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b71:	7f e3                	jg     800b56 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b73:	eb 37                	jmp    800bac <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800b75:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b79:	74 1e                	je     800b99 <vprintfmt+0x4f0>
  800b7b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b7e:	7e 05                	jle    800b85 <vprintfmt+0x4dc>
  800b80:	83 fb 7e             	cmp    $0x7e,%ebx
  800b83:	7e 14                	jle    800b99 <vprintfmt+0x4f0>
					putch('?', putdat);
  800b85:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8d:	48 89 d6             	mov    %rdx,%rsi
  800b90:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b95:	ff d0                	callq  *%rax
  800b97:	eb 0f                	jmp    800ba8 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800b99:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba1:	48 89 d6             	mov    %rdx,%rsi
  800ba4:	89 df                	mov    %ebx,%edi
  800ba6:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bac:	4c 89 e0             	mov    %r12,%rax
  800baf:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bb3:	0f b6 00             	movzbl (%rax),%eax
  800bb6:	0f be d8             	movsbl %al,%ebx
  800bb9:	85 db                	test   %ebx,%ebx
  800bbb:	74 10                	je     800bcd <vprintfmt+0x524>
  800bbd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bc1:	78 b2                	js     800b75 <vprintfmt+0x4cc>
  800bc3:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bc7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bcb:	79 a8                	jns    800b75 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bcd:	eb 16                	jmp    800be5 <vprintfmt+0x53c>
				putch(' ', putdat);
  800bcf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd7:	48 89 d6             	mov    %rdx,%rsi
  800bda:	bf 20 00 00 00       	mov    $0x20,%edi
  800bdf:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800be1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800be5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800be9:	7f e4                	jg     800bcf <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800beb:	e9 b6 01 00 00       	jmpq   800da6 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bf0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bf4:	be 03 00 00 00       	mov    $0x3,%esi
  800bf9:	48 89 c7             	mov    %rax,%rdi
  800bfc:	48 b8 99 05 80 00 00 	movabs $0x800599,%rax
  800c03:	00 00 00 
  800c06:	ff d0                	callq  *%rax
  800c08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c10:	48 85 c0             	test   %rax,%rax
  800c13:	79 1d                	jns    800c32 <vprintfmt+0x589>
				putch('-', putdat);
  800c15:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1d:	48 89 d6             	mov    %rdx,%rsi
  800c20:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c25:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2b:	48 f7 d8             	neg    %rax
  800c2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c32:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c39:	e9 fb 00 00 00       	jmpq   800d39 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c3e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c42:	be 03 00 00 00       	mov    $0x3,%esi
  800c47:	48 89 c7             	mov    %rax,%rdi
  800c4a:	48 b8 89 04 80 00 00 	movabs $0x800489,%rax
  800c51:	00 00 00 
  800c54:	ff d0                	callq  *%rax
  800c56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c5a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c61:	e9 d3 00 00 00       	jmpq   800d39 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800c66:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c6a:	be 03 00 00 00       	mov    $0x3,%esi
  800c6f:	48 89 c7             	mov    %rax,%rdi
  800c72:	48 b8 99 05 80 00 00 	movabs $0x800599,%rax
  800c79:	00 00 00 
  800c7c:	ff d0                	callq  *%rax
  800c7e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c86:	48 85 c0             	test   %rax,%rax
  800c89:	79 1d                	jns    800ca8 <vprintfmt+0x5ff>
				putch('-', putdat);
  800c8b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c93:	48 89 d6             	mov    %rdx,%rsi
  800c96:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c9b:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca1:	48 f7 d8             	neg    %rax
  800ca4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800ca8:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800caf:	e9 85 00 00 00       	jmpq   800d39 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800cb4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cb8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cbc:	48 89 d6             	mov    %rdx,%rsi
  800cbf:	bf 30 00 00 00       	mov    $0x30,%edi
  800cc4:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cc6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cce:	48 89 d6             	mov    %rdx,%rsi
  800cd1:	bf 78 00 00 00       	mov    $0x78,%edi
  800cd6:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cd8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cdb:	83 f8 30             	cmp    $0x30,%eax
  800cde:	73 17                	jae    800cf7 <vprintfmt+0x64e>
  800ce0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ce4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce7:	89 c0                	mov    %eax,%eax
  800ce9:	48 01 d0             	add    %rdx,%rax
  800cec:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cef:	83 c2 08             	add    $0x8,%edx
  800cf2:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cf5:	eb 0f                	jmp    800d06 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800cf7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cfb:	48 89 d0             	mov    %rdx,%rax
  800cfe:	48 83 c2 08          	add    $0x8,%rdx
  800d02:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d06:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d09:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d0d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d14:	eb 23                	jmp    800d39 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d16:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d1a:	be 03 00 00 00       	mov    $0x3,%esi
  800d1f:	48 89 c7             	mov    %rax,%rdi
  800d22:	48 b8 89 04 80 00 00 	movabs $0x800489,%rax
  800d29:	00 00 00 
  800d2c:	ff d0                	callq  *%rax
  800d2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d32:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d39:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d3e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d41:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d44:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d48:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d50:	45 89 c1             	mov    %r8d,%r9d
  800d53:	41 89 f8             	mov    %edi,%r8d
  800d56:	48 89 c7             	mov    %rax,%rdi
  800d59:	48 b8 ce 03 80 00 00 	movabs $0x8003ce,%rax
  800d60:	00 00 00 
  800d63:	ff d0                	callq  *%rax
			break;
  800d65:	eb 3f                	jmp    800da6 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d67:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d6f:	48 89 d6             	mov    %rdx,%rsi
  800d72:	89 df                	mov    %ebx,%edi
  800d74:	ff d0                	callq  *%rax
			break;
  800d76:	eb 2e                	jmp    800da6 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d80:	48 89 d6             	mov    %rdx,%rsi
  800d83:	bf 25 00 00 00       	mov    $0x25,%edi
  800d88:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d8a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d8f:	eb 05                	jmp    800d96 <vprintfmt+0x6ed>
  800d91:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d96:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d9a:	48 83 e8 01          	sub    $0x1,%rax
  800d9e:	0f b6 00             	movzbl (%rax),%eax
  800da1:	3c 25                	cmp    $0x25,%al
  800da3:	75 ec                	jne    800d91 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  800da5:	90                   	nop
		}
	}
  800da6:	e9 37 f9 ff ff       	jmpq   8006e2 <vprintfmt+0x39>
    va_end(aq);
}
  800dab:	48 83 c4 60          	add    $0x60,%rsp
  800daf:	5b                   	pop    %rbx
  800db0:	41 5c                	pop    %r12
  800db2:	5d                   	pop    %rbp
  800db3:	c3                   	retq   

0000000000800db4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800db4:	55                   	push   %rbp
  800db5:	48 89 e5             	mov    %rsp,%rbp
  800db8:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800dbf:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dc6:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800dcd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dd4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ddb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800de2:	84 c0                	test   %al,%al
  800de4:	74 20                	je     800e06 <printfmt+0x52>
  800de6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dea:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dee:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800df2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800df6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dfa:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dfe:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e02:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e06:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e0d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e14:	00 00 00 
  800e17:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e1e:	00 00 00 
  800e21:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e25:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e2c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e33:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e3a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e41:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e48:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e4f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e56:	48 89 c7             	mov    %rax,%rdi
  800e59:	48 b8 a9 06 80 00 00 	movabs $0x8006a9,%rax
  800e60:	00 00 00 
  800e63:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e65:	c9                   	leaveq 
  800e66:	c3                   	retq   

0000000000800e67 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e67:	55                   	push   %rbp
  800e68:	48 89 e5             	mov    %rsp,%rbp
  800e6b:	48 83 ec 10          	sub    $0x10,%rsp
  800e6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7a:	8b 40 10             	mov    0x10(%rax),%eax
  800e7d:	8d 50 01             	lea    0x1(%rax),%edx
  800e80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e84:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e8b:	48 8b 10             	mov    (%rax),%rdx
  800e8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e92:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e96:	48 39 c2             	cmp    %rax,%rdx
  800e99:	73 17                	jae    800eb2 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9f:	48 8b 00             	mov    (%rax),%rax
  800ea2:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ea6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800eaa:	48 89 0a             	mov    %rcx,(%rdx)
  800ead:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800eb0:	88 10                	mov    %dl,(%rax)
}
  800eb2:	c9                   	leaveq 
  800eb3:	c3                   	retq   

0000000000800eb4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800eb4:	55                   	push   %rbp
  800eb5:	48 89 e5             	mov    %rsp,%rbp
  800eb8:	48 83 ec 50          	sub    $0x50,%rsp
  800ebc:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ec0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ec3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ec7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ecb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ecf:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ed3:	48 8b 0a             	mov    (%rdx),%rcx
  800ed6:	48 89 08             	mov    %rcx,(%rax)
  800ed9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800edd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ee1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ee5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ee9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eed:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ef1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ef4:	48 98                	cltq   
  800ef6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800efa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800efe:	48 01 d0             	add    %rdx,%rax
  800f01:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f05:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f0c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f11:	74 06                	je     800f19 <vsnprintf+0x65>
  800f13:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f17:	7f 07                	jg     800f20 <vsnprintf+0x6c>
		return -E_INVAL;
  800f19:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f1e:	eb 2f                	jmp    800f4f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f20:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f24:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f28:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f2c:	48 89 c6             	mov    %rax,%rsi
  800f2f:	48 bf 67 0e 80 00 00 	movabs $0x800e67,%rdi
  800f36:	00 00 00 
  800f39:	48 b8 a9 06 80 00 00 	movabs $0x8006a9,%rax
  800f40:	00 00 00 
  800f43:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f45:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f49:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f4c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f4f:	c9                   	leaveq 
  800f50:	c3                   	retq   

0000000000800f51 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f51:	55                   	push   %rbp
  800f52:	48 89 e5             	mov    %rsp,%rbp
  800f55:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f5c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f63:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f69:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f70:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f77:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f7e:	84 c0                	test   %al,%al
  800f80:	74 20                	je     800fa2 <snprintf+0x51>
  800f82:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f86:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f8a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f8e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f92:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f96:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f9a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f9e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fa2:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fa9:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fb0:	00 00 00 
  800fb3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fba:	00 00 00 
  800fbd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fc1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fc8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fcf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fd6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fdd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fe4:	48 8b 0a             	mov    (%rdx),%rcx
  800fe7:	48 89 08             	mov    %rcx,(%rax)
  800fea:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fee:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ff2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ff6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ffa:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801001:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801008:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80100e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801015:	48 89 c7             	mov    %rax,%rdi
  801018:	48 b8 b4 0e 80 00 00 	movabs $0x800eb4,%rax
  80101f:	00 00 00 
  801022:	ff d0                	callq  *%rax
  801024:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80102a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801030:	c9                   	leaveq 
  801031:	c3                   	retq   

0000000000801032 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801032:	55                   	push   %rbp
  801033:	48 89 e5             	mov    %rsp,%rbp
  801036:	48 83 ec 18          	sub    $0x18,%rsp
  80103a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80103e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801045:	eb 09                	jmp    801050 <strlen+0x1e>
		n++;
  801047:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80104b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801050:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801054:	0f b6 00             	movzbl (%rax),%eax
  801057:	84 c0                	test   %al,%al
  801059:	75 ec                	jne    801047 <strlen+0x15>
		n++;
	return n;
  80105b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80105e:	c9                   	leaveq 
  80105f:	c3                   	retq   

0000000000801060 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801060:	55                   	push   %rbp
  801061:	48 89 e5             	mov    %rsp,%rbp
  801064:	48 83 ec 20          	sub    $0x20,%rsp
  801068:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80106c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801070:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801077:	eb 0e                	jmp    801087 <strnlen+0x27>
		n++;
  801079:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80107d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801082:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801087:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80108c:	74 0b                	je     801099 <strnlen+0x39>
  80108e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801092:	0f b6 00             	movzbl (%rax),%eax
  801095:	84 c0                	test   %al,%al
  801097:	75 e0                	jne    801079 <strnlen+0x19>
		n++;
	return n;
  801099:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80109c:	c9                   	leaveq 
  80109d:	c3                   	retq   

000000000080109e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80109e:	55                   	push   %rbp
  80109f:	48 89 e5             	mov    %rsp,%rbp
  8010a2:	48 83 ec 20          	sub    $0x20,%rsp
  8010a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010b6:	90                   	nop
  8010b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010bf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010c3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010c7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010cb:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010cf:	0f b6 12             	movzbl (%rdx),%edx
  8010d2:	88 10                	mov    %dl,(%rax)
  8010d4:	0f b6 00             	movzbl (%rax),%eax
  8010d7:	84 c0                	test   %al,%al
  8010d9:	75 dc                	jne    8010b7 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010df:	c9                   	leaveq 
  8010e0:	c3                   	retq   

00000000008010e1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010e1:	55                   	push   %rbp
  8010e2:	48 89 e5             	mov    %rsp,%rbp
  8010e5:	48 83 ec 20          	sub    $0x20,%rsp
  8010e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f5:	48 89 c7             	mov    %rax,%rdi
  8010f8:	48 b8 32 10 80 00 00 	movabs $0x801032,%rax
  8010ff:	00 00 00 
  801102:	ff d0                	callq  *%rax
  801104:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801107:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80110a:	48 63 d0             	movslq %eax,%rdx
  80110d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801111:	48 01 c2             	add    %rax,%rdx
  801114:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801118:	48 89 c6             	mov    %rax,%rsi
  80111b:	48 89 d7             	mov    %rdx,%rdi
  80111e:	48 b8 9e 10 80 00 00 	movabs $0x80109e,%rax
  801125:	00 00 00 
  801128:	ff d0                	callq  *%rax
	return dst;
  80112a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80112e:	c9                   	leaveq 
  80112f:	c3                   	retq   

0000000000801130 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801130:	55                   	push   %rbp
  801131:	48 89 e5             	mov    %rsp,%rbp
  801134:	48 83 ec 28          	sub    $0x28,%rsp
  801138:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80113c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801140:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801144:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801148:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80114c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801153:	00 
  801154:	eb 2a                	jmp    801180 <strncpy+0x50>
		*dst++ = *src;
  801156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80115e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801162:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801166:	0f b6 12             	movzbl (%rdx),%edx
  801169:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80116b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80116f:	0f b6 00             	movzbl (%rax),%eax
  801172:	84 c0                	test   %al,%al
  801174:	74 05                	je     80117b <strncpy+0x4b>
			src++;
  801176:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80117b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801180:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801184:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801188:	72 cc                	jb     801156 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80118a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80118e:	c9                   	leaveq 
  80118f:	c3                   	retq   

0000000000801190 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801190:	55                   	push   %rbp
  801191:	48 89 e5             	mov    %rsp,%rbp
  801194:	48 83 ec 28          	sub    $0x28,%rsp
  801198:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80119c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011ac:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011b1:	74 3d                	je     8011f0 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011b3:	eb 1d                	jmp    8011d2 <strlcpy+0x42>
			*dst++ = *src++;
  8011b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011bd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011c1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011c5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011c9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011cd:	0f b6 12             	movzbl (%rdx),%edx
  8011d0:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011d2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011dc:	74 0b                	je     8011e9 <strlcpy+0x59>
  8011de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e2:	0f b6 00             	movzbl (%rax),%eax
  8011e5:	84 c0                	test   %al,%al
  8011e7:	75 cc                	jne    8011b5 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ed:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f8:	48 29 c2             	sub    %rax,%rdx
  8011fb:	48 89 d0             	mov    %rdx,%rax
}
  8011fe:	c9                   	leaveq 
  8011ff:	c3                   	retq   

0000000000801200 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801200:	55                   	push   %rbp
  801201:	48 89 e5             	mov    %rsp,%rbp
  801204:	48 83 ec 10          	sub    $0x10,%rsp
  801208:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80120c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801210:	eb 0a                	jmp    80121c <strcmp+0x1c>
		p++, q++;
  801212:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801217:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80121c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801220:	0f b6 00             	movzbl (%rax),%eax
  801223:	84 c0                	test   %al,%al
  801225:	74 12                	je     801239 <strcmp+0x39>
  801227:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122b:	0f b6 10             	movzbl (%rax),%edx
  80122e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801232:	0f b6 00             	movzbl (%rax),%eax
  801235:	38 c2                	cmp    %al,%dl
  801237:	74 d9                	je     801212 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801239:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123d:	0f b6 00             	movzbl (%rax),%eax
  801240:	0f b6 d0             	movzbl %al,%edx
  801243:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801247:	0f b6 00             	movzbl (%rax),%eax
  80124a:	0f b6 c0             	movzbl %al,%eax
  80124d:	29 c2                	sub    %eax,%edx
  80124f:	89 d0                	mov    %edx,%eax
}
  801251:	c9                   	leaveq 
  801252:	c3                   	retq   

0000000000801253 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801253:	55                   	push   %rbp
  801254:	48 89 e5             	mov    %rsp,%rbp
  801257:	48 83 ec 18          	sub    $0x18,%rsp
  80125b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80125f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801263:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801267:	eb 0f                	jmp    801278 <strncmp+0x25>
		n--, p++, q++;
  801269:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80126e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801273:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801278:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80127d:	74 1d                	je     80129c <strncmp+0x49>
  80127f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801283:	0f b6 00             	movzbl (%rax),%eax
  801286:	84 c0                	test   %al,%al
  801288:	74 12                	je     80129c <strncmp+0x49>
  80128a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128e:	0f b6 10             	movzbl (%rax),%edx
  801291:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801295:	0f b6 00             	movzbl (%rax),%eax
  801298:	38 c2                	cmp    %al,%dl
  80129a:	74 cd                	je     801269 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80129c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012a1:	75 07                	jne    8012aa <strncmp+0x57>
		return 0;
  8012a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a8:	eb 18                	jmp    8012c2 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ae:	0f b6 00             	movzbl (%rax),%eax
  8012b1:	0f b6 d0             	movzbl %al,%edx
  8012b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b8:	0f b6 00             	movzbl (%rax),%eax
  8012bb:	0f b6 c0             	movzbl %al,%eax
  8012be:	29 c2                	sub    %eax,%edx
  8012c0:	89 d0                	mov    %edx,%eax
}
  8012c2:	c9                   	leaveq 
  8012c3:	c3                   	retq   

00000000008012c4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012c4:	55                   	push   %rbp
  8012c5:	48 89 e5             	mov    %rsp,%rbp
  8012c8:	48 83 ec 0c          	sub    $0xc,%rsp
  8012cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d0:	89 f0                	mov    %esi,%eax
  8012d2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012d5:	eb 17                	jmp    8012ee <strchr+0x2a>
		if (*s == c)
  8012d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012db:	0f b6 00             	movzbl (%rax),%eax
  8012de:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012e1:	75 06                	jne    8012e9 <strchr+0x25>
			return (char *) s;
  8012e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e7:	eb 15                	jmp    8012fe <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012e9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f2:	0f b6 00             	movzbl (%rax),%eax
  8012f5:	84 c0                	test   %al,%al
  8012f7:	75 de                	jne    8012d7 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012fe:	c9                   	leaveq 
  8012ff:	c3                   	retq   

0000000000801300 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801300:	55                   	push   %rbp
  801301:	48 89 e5             	mov    %rsp,%rbp
  801304:	48 83 ec 0c          	sub    $0xc,%rsp
  801308:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80130c:	89 f0                	mov    %esi,%eax
  80130e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801311:	eb 13                	jmp    801326 <strfind+0x26>
		if (*s == c)
  801313:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801317:	0f b6 00             	movzbl (%rax),%eax
  80131a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80131d:	75 02                	jne    801321 <strfind+0x21>
			break;
  80131f:	eb 10                	jmp    801331 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801321:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801326:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132a:	0f b6 00             	movzbl (%rax),%eax
  80132d:	84 c0                	test   %al,%al
  80132f:	75 e2                	jne    801313 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801335:	c9                   	leaveq 
  801336:	c3                   	retq   

0000000000801337 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801337:	55                   	push   %rbp
  801338:	48 89 e5             	mov    %rsp,%rbp
  80133b:	48 83 ec 18          	sub    $0x18,%rsp
  80133f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801343:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801346:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80134a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80134f:	75 06                	jne    801357 <memset+0x20>
		return v;
  801351:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801355:	eb 69                	jmp    8013c0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801357:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135b:	83 e0 03             	and    $0x3,%eax
  80135e:	48 85 c0             	test   %rax,%rax
  801361:	75 48                	jne    8013ab <memset+0x74>
  801363:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801367:	83 e0 03             	and    $0x3,%eax
  80136a:	48 85 c0             	test   %rax,%rax
  80136d:	75 3c                	jne    8013ab <memset+0x74>
		c &= 0xFF;
  80136f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801376:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801379:	c1 e0 18             	shl    $0x18,%eax
  80137c:	89 c2                	mov    %eax,%edx
  80137e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801381:	c1 e0 10             	shl    $0x10,%eax
  801384:	09 c2                	or     %eax,%edx
  801386:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801389:	c1 e0 08             	shl    $0x8,%eax
  80138c:	09 d0                	or     %edx,%eax
  80138e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801391:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801395:	48 c1 e8 02          	shr    $0x2,%rax
  801399:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80139c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013a3:	48 89 d7             	mov    %rdx,%rdi
  8013a6:	fc                   	cld    
  8013a7:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013a9:	eb 11                	jmp    8013bc <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013ab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013b6:	48 89 d7             	mov    %rdx,%rdi
  8013b9:	fc                   	cld    
  8013ba:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8013bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013c0:	c9                   	leaveq 
  8013c1:	c3                   	retq   

00000000008013c2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013c2:	55                   	push   %rbp
  8013c3:	48 89 e5             	mov    %rsp,%rbp
  8013c6:	48 83 ec 28          	sub    $0x28,%rsp
  8013ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ea:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013ee:	0f 83 88 00 00 00    	jae    80147c <memmove+0xba>
  8013f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013fc:	48 01 d0             	add    %rdx,%rax
  8013ff:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801403:	76 77                	jbe    80147c <memmove+0xba>
		s += n;
  801405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801409:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80140d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801411:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801415:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801419:	83 e0 03             	and    $0x3,%eax
  80141c:	48 85 c0             	test   %rax,%rax
  80141f:	75 3b                	jne    80145c <memmove+0x9a>
  801421:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801425:	83 e0 03             	and    $0x3,%eax
  801428:	48 85 c0             	test   %rax,%rax
  80142b:	75 2f                	jne    80145c <memmove+0x9a>
  80142d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801431:	83 e0 03             	and    $0x3,%eax
  801434:	48 85 c0             	test   %rax,%rax
  801437:	75 23                	jne    80145c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801439:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143d:	48 83 e8 04          	sub    $0x4,%rax
  801441:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801445:	48 83 ea 04          	sub    $0x4,%rdx
  801449:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80144d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801451:	48 89 c7             	mov    %rax,%rdi
  801454:	48 89 d6             	mov    %rdx,%rsi
  801457:	fd                   	std    
  801458:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80145a:	eb 1d                	jmp    801479 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80145c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801460:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801464:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801468:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80146c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801470:	48 89 d7             	mov    %rdx,%rdi
  801473:	48 89 c1             	mov    %rax,%rcx
  801476:	fd                   	std    
  801477:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801479:	fc                   	cld    
  80147a:	eb 57                	jmp    8014d3 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80147c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801480:	83 e0 03             	and    $0x3,%eax
  801483:	48 85 c0             	test   %rax,%rax
  801486:	75 36                	jne    8014be <memmove+0xfc>
  801488:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148c:	83 e0 03             	and    $0x3,%eax
  80148f:	48 85 c0             	test   %rax,%rax
  801492:	75 2a                	jne    8014be <memmove+0xfc>
  801494:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801498:	83 e0 03             	and    $0x3,%eax
  80149b:	48 85 c0             	test   %rax,%rax
  80149e:	75 1e                	jne    8014be <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a4:	48 c1 e8 02          	shr    $0x2,%rax
  8014a8:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014af:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014b3:	48 89 c7             	mov    %rax,%rdi
  8014b6:	48 89 d6             	mov    %rdx,%rsi
  8014b9:	fc                   	cld    
  8014ba:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014bc:	eb 15                	jmp    8014d3 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014c6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014ca:	48 89 c7             	mov    %rax,%rdi
  8014cd:	48 89 d6             	mov    %rdx,%rsi
  8014d0:	fc                   	cld    
  8014d1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014d7:	c9                   	leaveq 
  8014d8:	c3                   	retq   

00000000008014d9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014d9:	55                   	push   %rbp
  8014da:	48 89 e5             	mov    %rsp,%rbp
  8014dd:	48 83 ec 18          	sub    $0x18,%rsp
  8014e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014e9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014f1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f9:	48 89 ce             	mov    %rcx,%rsi
  8014fc:	48 89 c7             	mov    %rax,%rdi
  8014ff:	48 b8 c2 13 80 00 00 	movabs $0x8013c2,%rax
  801506:	00 00 00 
  801509:	ff d0                	callq  *%rax
}
  80150b:	c9                   	leaveq 
  80150c:	c3                   	retq   

000000000080150d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80150d:	55                   	push   %rbp
  80150e:	48 89 e5             	mov    %rsp,%rbp
  801511:	48 83 ec 28          	sub    $0x28,%rsp
  801515:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801519:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80151d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801521:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801525:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801529:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80152d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801531:	eb 36                	jmp    801569 <memcmp+0x5c>
		if (*s1 != *s2)
  801533:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801537:	0f b6 10             	movzbl (%rax),%edx
  80153a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80153e:	0f b6 00             	movzbl (%rax),%eax
  801541:	38 c2                	cmp    %al,%dl
  801543:	74 1a                	je     80155f <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801545:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801549:	0f b6 00             	movzbl (%rax),%eax
  80154c:	0f b6 d0             	movzbl %al,%edx
  80154f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801553:	0f b6 00             	movzbl (%rax),%eax
  801556:	0f b6 c0             	movzbl %al,%eax
  801559:	29 c2                	sub    %eax,%edx
  80155b:	89 d0                	mov    %edx,%eax
  80155d:	eb 20                	jmp    80157f <memcmp+0x72>
		s1++, s2++;
  80155f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801564:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801569:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801571:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801575:	48 85 c0             	test   %rax,%rax
  801578:	75 b9                	jne    801533 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80157a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157f:	c9                   	leaveq 
  801580:	c3                   	retq   

0000000000801581 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801581:	55                   	push   %rbp
  801582:	48 89 e5             	mov    %rsp,%rbp
  801585:	48 83 ec 28          	sub    $0x28,%rsp
  801589:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80158d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801590:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801594:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801598:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80159c:	48 01 d0             	add    %rdx,%rax
  80159f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015a3:	eb 15                	jmp    8015ba <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a9:	0f b6 10             	movzbl (%rax),%edx
  8015ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015af:	38 c2                	cmp    %al,%dl
  8015b1:	75 02                	jne    8015b5 <memfind+0x34>
			break;
  8015b3:	eb 0f                	jmp    8015c4 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015b5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015be:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015c2:	72 e1                	jb     8015a5 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015c8:	c9                   	leaveq 
  8015c9:	c3                   	retq   

00000000008015ca <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015ca:	55                   	push   %rbp
  8015cb:	48 89 e5             	mov    %rsp,%rbp
  8015ce:	48 83 ec 34          	sub    $0x34,%rsp
  8015d2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015d6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015da:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015e4:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015eb:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015ec:	eb 05                	jmp    8015f3 <strtol+0x29>
		s++;
  8015ee:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f7:	0f b6 00             	movzbl (%rax),%eax
  8015fa:	3c 20                	cmp    $0x20,%al
  8015fc:	74 f0                	je     8015ee <strtol+0x24>
  8015fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801602:	0f b6 00             	movzbl (%rax),%eax
  801605:	3c 09                	cmp    $0x9,%al
  801607:	74 e5                	je     8015ee <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160d:	0f b6 00             	movzbl (%rax),%eax
  801610:	3c 2b                	cmp    $0x2b,%al
  801612:	75 07                	jne    80161b <strtol+0x51>
		s++;
  801614:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801619:	eb 17                	jmp    801632 <strtol+0x68>
	else if (*s == '-')
  80161b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161f:	0f b6 00             	movzbl (%rax),%eax
  801622:	3c 2d                	cmp    $0x2d,%al
  801624:	75 0c                	jne    801632 <strtol+0x68>
		s++, neg = 1;
  801626:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80162b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801632:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801636:	74 06                	je     80163e <strtol+0x74>
  801638:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80163c:	75 28                	jne    801666 <strtol+0x9c>
  80163e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801642:	0f b6 00             	movzbl (%rax),%eax
  801645:	3c 30                	cmp    $0x30,%al
  801647:	75 1d                	jne    801666 <strtol+0x9c>
  801649:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164d:	48 83 c0 01          	add    $0x1,%rax
  801651:	0f b6 00             	movzbl (%rax),%eax
  801654:	3c 78                	cmp    $0x78,%al
  801656:	75 0e                	jne    801666 <strtol+0x9c>
		s += 2, base = 16;
  801658:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80165d:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801664:	eb 2c                	jmp    801692 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801666:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80166a:	75 19                	jne    801685 <strtol+0xbb>
  80166c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801670:	0f b6 00             	movzbl (%rax),%eax
  801673:	3c 30                	cmp    $0x30,%al
  801675:	75 0e                	jne    801685 <strtol+0xbb>
		s++, base = 8;
  801677:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80167c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801683:	eb 0d                	jmp    801692 <strtol+0xc8>
	else if (base == 0)
  801685:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801689:	75 07                	jne    801692 <strtol+0xc8>
		base = 10;
  80168b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801692:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801696:	0f b6 00             	movzbl (%rax),%eax
  801699:	3c 2f                	cmp    $0x2f,%al
  80169b:	7e 1d                	jle    8016ba <strtol+0xf0>
  80169d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a1:	0f b6 00             	movzbl (%rax),%eax
  8016a4:	3c 39                	cmp    $0x39,%al
  8016a6:	7f 12                	jg     8016ba <strtol+0xf0>
			dig = *s - '0';
  8016a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ac:	0f b6 00             	movzbl (%rax),%eax
  8016af:	0f be c0             	movsbl %al,%eax
  8016b2:	83 e8 30             	sub    $0x30,%eax
  8016b5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016b8:	eb 4e                	jmp    801708 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016be:	0f b6 00             	movzbl (%rax),%eax
  8016c1:	3c 60                	cmp    $0x60,%al
  8016c3:	7e 1d                	jle    8016e2 <strtol+0x118>
  8016c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c9:	0f b6 00             	movzbl (%rax),%eax
  8016cc:	3c 7a                	cmp    $0x7a,%al
  8016ce:	7f 12                	jg     8016e2 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d4:	0f b6 00             	movzbl (%rax),%eax
  8016d7:	0f be c0             	movsbl %al,%eax
  8016da:	83 e8 57             	sub    $0x57,%eax
  8016dd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016e0:	eb 26                	jmp    801708 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e6:	0f b6 00             	movzbl (%rax),%eax
  8016e9:	3c 40                	cmp    $0x40,%al
  8016eb:	7e 48                	jle    801735 <strtol+0x16b>
  8016ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f1:	0f b6 00             	movzbl (%rax),%eax
  8016f4:	3c 5a                	cmp    $0x5a,%al
  8016f6:	7f 3d                	jg     801735 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fc:	0f b6 00             	movzbl (%rax),%eax
  8016ff:	0f be c0             	movsbl %al,%eax
  801702:	83 e8 37             	sub    $0x37,%eax
  801705:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801708:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80170b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80170e:	7c 02                	jl     801712 <strtol+0x148>
			break;
  801710:	eb 23                	jmp    801735 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801712:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801717:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80171a:	48 98                	cltq   
  80171c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801721:	48 89 c2             	mov    %rax,%rdx
  801724:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801727:	48 98                	cltq   
  801729:	48 01 d0             	add    %rdx,%rax
  80172c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801730:	e9 5d ff ff ff       	jmpq   801692 <strtol+0xc8>

	if (endptr)
  801735:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80173a:	74 0b                	je     801747 <strtol+0x17d>
		*endptr = (char *) s;
  80173c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801740:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801744:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801747:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80174b:	74 09                	je     801756 <strtol+0x18c>
  80174d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801751:	48 f7 d8             	neg    %rax
  801754:	eb 04                	jmp    80175a <strtol+0x190>
  801756:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80175a:	c9                   	leaveq 
  80175b:	c3                   	retq   

000000000080175c <strstr>:

char * strstr(const char *in, const char *str)
{
  80175c:	55                   	push   %rbp
  80175d:	48 89 e5             	mov    %rsp,%rbp
  801760:	48 83 ec 30          	sub    $0x30,%rsp
  801764:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801768:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80176c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801770:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801774:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801778:	0f b6 00             	movzbl (%rax),%eax
  80177b:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  80177e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801782:	75 06                	jne    80178a <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801788:	eb 6b                	jmp    8017f5 <strstr+0x99>

    len = strlen(str);
  80178a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80178e:	48 89 c7             	mov    %rax,%rdi
  801791:	48 b8 32 10 80 00 00 	movabs $0x801032,%rax
  801798:	00 00 00 
  80179b:	ff d0                	callq  *%rax
  80179d:	48 98                	cltq   
  80179f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8017a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017af:	0f b6 00             	movzbl (%rax),%eax
  8017b2:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8017b5:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017b9:	75 07                	jne    8017c2 <strstr+0x66>
                return (char *) 0;
  8017bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c0:	eb 33                	jmp    8017f5 <strstr+0x99>
        } while (sc != c);
  8017c2:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017c6:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017c9:	75 d8                	jne    8017a3 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  8017cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017cf:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d7:	48 89 ce             	mov    %rcx,%rsi
  8017da:	48 89 c7             	mov    %rax,%rdi
  8017dd:	48 b8 53 12 80 00 00 	movabs $0x801253,%rax
  8017e4:	00 00 00 
  8017e7:	ff d0                	callq  *%rax
  8017e9:	85 c0                	test   %eax,%eax
  8017eb:	75 b6                	jne    8017a3 <strstr+0x47>

    return (char *) (in - 1);
  8017ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f1:	48 83 e8 01          	sub    $0x1,%rax
}
  8017f5:	c9                   	leaveq 
  8017f6:	c3                   	retq   

00000000008017f7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017f7:	55                   	push   %rbp
  8017f8:	48 89 e5             	mov    %rsp,%rbp
  8017fb:	53                   	push   %rbx
  8017fc:	48 83 ec 48          	sub    $0x48,%rsp
  801800:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801803:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801806:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80180a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80180e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801812:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801816:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801819:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80181d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801821:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801825:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801829:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80182d:	4c 89 c3             	mov    %r8,%rbx
  801830:	cd 30                	int    $0x30
  801832:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801836:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80183a:	74 3e                	je     80187a <syscall+0x83>
  80183c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801841:	7e 37                	jle    80187a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801843:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801847:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80184a:	49 89 d0             	mov    %rdx,%r8
  80184d:	89 c1                	mov    %eax,%ecx
  80184f:	48 ba a0 3a 80 00 00 	movabs $0x803aa0,%rdx
  801856:	00 00 00 
  801859:	be 23 00 00 00       	mov    $0x23,%esi
  80185e:	48 bf bd 3a 80 00 00 	movabs $0x803abd,%rdi
  801865:	00 00 00 
  801868:	b8 00 00 00 00       	mov    $0x0,%eax
  80186d:	49 b9 19 34 80 00 00 	movabs $0x803419,%r9
  801874:	00 00 00 
  801877:	41 ff d1             	callq  *%r9

	return ret;
  80187a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80187e:	48 83 c4 48          	add    $0x48,%rsp
  801882:	5b                   	pop    %rbx
  801883:	5d                   	pop    %rbp
  801884:	c3                   	retq   

0000000000801885 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801885:	55                   	push   %rbp
  801886:	48 89 e5             	mov    %rsp,%rbp
  801889:	48 83 ec 20          	sub    $0x20,%rsp
  80188d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801891:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801895:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801899:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80189d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a4:	00 
  8018a5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b1:	48 89 d1             	mov    %rdx,%rcx
  8018b4:	48 89 c2             	mov    %rax,%rdx
  8018b7:	be 00 00 00 00       	mov    $0x0,%esi
  8018bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8018c1:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  8018c8:	00 00 00 
  8018cb:	ff d0                	callq  *%rax
}
  8018cd:	c9                   	leaveq 
  8018ce:	c3                   	retq   

00000000008018cf <sys_cgetc>:

int
sys_cgetc(void)
{
  8018cf:	55                   	push   %rbp
  8018d0:	48 89 e5             	mov    %rsp,%rbp
  8018d3:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018d7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018de:	00 
  8018df:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f5:	be 00 00 00 00       	mov    $0x0,%esi
  8018fa:	bf 01 00 00 00       	mov    $0x1,%edi
  8018ff:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  801906:	00 00 00 
  801909:	ff d0                	callq  *%rax
}
  80190b:	c9                   	leaveq 
  80190c:	c3                   	retq   

000000000080190d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80190d:	55                   	push   %rbp
  80190e:	48 89 e5             	mov    %rsp,%rbp
  801911:	48 83 ec 10          	sub    $0x10,%rsp
  801915:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801918:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80191b:	48 98                	cltq   
  80191d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801924:	00 
  801925:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80192b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801931:	b9 00 00 00 00       	mov    $0x0,%ecx
  801936:	48 89 c2             	mov    %rax,%rdx
  801939:	be 01 00 00 00       	mov    $0x1,%esi
  80193e:	bf 03 00 00 00       	mov    $0x3,%edi
  801943:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  80194a:	00 00 00 
  80194d:	ff d0                	callq  *%rax
}
  80194f:	c9                   	leaveq 
  801950:	c3                   	retq   

0000000000801951 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801951:	55                   	push   %rbp
  801952:	48 89 e5             	mov    %rsp,%rbp
  801955:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801959:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801960:	00 
  801961:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801967:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80196d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801972:	ba 00 00 00 00       	mov    $0x0,%edx
  801977:	be 00 00 00 00       	mov    $0x0,%esi
  80197c:	bf 02 00 00 00       	mov    $0x2,%edi
  801981:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  801988:	00 00 00 
  80198b:	ff d0                	callq  *%rax
}
  80198d:	c9                   	leaveq 
  80198e:	c3                   	retq   

000000000080198f <sys_yield>:

void
sys_yield(void)
{
  80198f:	55                   	push   %rbp
  801990:	48 89 e5             	mov    %rsp,%rbp
  801993:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801997:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80199e:	00 
  80199f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b5:	be 00 00 00 00       	mov    $0x0,%esi
  8019ba:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019bf:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  8019c6:	00 00 00 
  8019c9:	ff d0                	callq  *%rax
}
  8019cb:	c9                   	leaveq 
  8019cc:	c3                   	retq   

00000000008019cd <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019cd:	55                   	push   %rbp
  8019ce:	48 89 e5             	mov    %rsp,%rbp
  8019d1:	48 83 ec 20          	sub    $0x20,%rsp
  8019d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019dc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019df:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019e2:	48 63 c8             	movslq %eax,%rcx
  8019e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ec:	48 98                	cltq   
  8019ee:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f5:	00 
  8019f6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019fc:	49 89 c8             	mov    %rcx,%r8
  8019ff:	48 89 d1             	mov    %rdx,%rcx
  801a02:	48 89 c2             	mov    %rax,%rdx
  801a05:	be 01 00 00 00       	mov    $0x1,%esi
  801a0a:	bf 04 00 00 00       	mov    $0x4,%edi
  801a0f:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  801a16:	00 00 00 
  801a19:	ff d0                	callq  *%rax
}
  801a1b:	c9                   	leaveq 
  801a1c:	c3                   	retq   

0000000000801a1d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a1d:	55                   	push   %rbp
  801a1e:	48 89 e5             	mov    %rsp,%rbp
  801a21:	48 83 ec 30          	sub    $0x30,%rsp
  801a25:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a28:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a2c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a2f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a33:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a37:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a3a:	48 63 c8             	movslq %eax,%rcx
  801a3d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a41:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a44:	48 63 f0             	movslq %eax,%rsi
  801a47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a4e:	48 98                	cltq   
  801a50:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a54:	49 89 f9             	mov    %rdi,%r9
  801a57:	49 89 f0             	mov    %rsi,%r8
  801a5a:	48 89 d1             	mov    %rdx,%rcx
  801a5d:	48 89 c2             	mov    %rax,%rdx
  801a60:	be 01 00 00 00       	mov    $0x1,%esi
  801a65:	bf 05 00 00 00       	mov    $0x5,%edi
  801a6a:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  801a71:	00 00 00 
  801a74:	ff d0                	callq  *%rax
}
  801a76:	c9                   	leaveq 
  801a77:	c3                   	retq   

0000000000801a78 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a78:	55                   	push   %rbp
  801a79:	48 89 e5             	mov    %rsp,%rbp
  801a7c:	48 83 ec 20          	sub    $0x20,%rsp
  801a80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8e:	48 98                	cltq   
  801a90:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a97:	00 
  801a98:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a9e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa4:	48 89 d1             	mov    %rdx,%rcx
  801aa7:	48 89 c2             	mov    %rax,%rdx
  801aaa:	be 01 00 00 00       	mov    $0x1,%esi
  801aaf:	bf 06 00 00 00       	mov    $0x6,%edi
  801ab4:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  801abb:	00 00 00 
  801abe:	ff d0                	callq  *%rax
}
  801ac0:	c9                   	leaveq 
  801ac1:	c3                   	retq   

0000000000801ac2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ac2:	55                   	push   %rbp
  801ac3:	48 89 e5             	mov    %rsp,%rbp
  801ac6:	48 83 ec 10          	sub    $0x10,%rsp
  801aca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801acd:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ad0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ad3:	48 63 d0             	movslq %eax,%rdx
  801ad6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad9:	48 98                	cltq   
  801adb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae2:	00 
  801ae3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aef:	48 89 d1             	mov    %rdx,%rcx
  801af2:	48 89 c2             	mov    %rax,%rdx
  801af5:	be 01 00 00 00       	mov    $0x1,%esi
  801afa:	bf 08 00 00 00       	mov    $0x8,%edi
  801aff:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  801b06:	00 00 00 
  801b09:	ff d0                	callq  *%rax
}
  801b0b:	c9                   	leaveq 
  801b0c:	c3                   	retq   

0000000000801b0d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b0d:	55                   	push   %rbp
  801b0e:	48 89 e5             	mov    %rsp,%rbp
  801b11:	48 83 ec 20          	sub    $0x20,%rsp
  801b15:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b18:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b1c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b23:	48 98                	cltq   
  801b25:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b2c:	00 
  801b2d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b33:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b39:	48 89 d1             	mov    %rdx,%rcx
  801b3c:	48 89 c2             	mov    %rax,%rdx
  801b3f:	be 01 00 00 00       	mov    $0x1,%esi
  801b44:	bf 09 00 00 00       	mov    $0x9,%edi
  801b49:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  801b50:	00 00 00 
  801b53:	ff d0                	callq  *%rax
}
  801b55:	c9                   	leaveq 
  801b56:	c3                   	retq   

0000000000801b57 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b57:	55                   	push   %rbp
  801b58:	48 89 e5             	mov    %rsp,%rbp
  801b5b:	48 83 ec 20          	sub    $0x20,%rsp
  801b5f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b62:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b66:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b6d:	48 98                	cltq   
  801b6f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b76:	00 
  801b77:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b7d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b83:	48 89 d1             	mov    %rdx,%rcx
  801b86:	48 89 c2             	mov    %rax,%rdx
  801b89:	be 01 00 00 00       	mov    $0x1,%esi
  801b8e:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b93:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  801b9a:	00 00 00 
  801b9d:	ff d0                	callq  *%rax
}
  801b9f:	c9                   	leaveq 
  801ba0:	c3                   	retq   

0000000000801ba1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ba1:	55                   	push   %rbp
  801ba2:	48 89 e5             	mov    %rsp,%rbp
  801ba5:	48 83 ec 20          	sub    $0x20,%rsp
  801ba9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bb0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bb4:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bb7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bba:	48 63 f0             	movslq %eax,%rsi
  801bbd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc4:	48 98                	cltq   
  801bc6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd1:	00 
  801bd2:	49 89 f1             	mov    %rsi,%r9
  801bd5:	49 89 c8             	mov    %rcx,%r8
  801bd8:	48 89 d1             	mov    %rdx,%rcx
  801bdb:	48 89 c2             	mov    %rax,%rdx
  801bde:	be 00 00 00 00       	mov    $0x0,%esi
  801be3:	bf 0c 00 00 00       	mov    $0xc,%edi
  801be8:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  801bef:	00 00 00 
  801bf2:	ff d0                	callq  *%rax
}
  801bf4:	c9                   	leaveq 
  801bf5:	c3                   	retq   

0000000000801bf6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bf6:	55                   	push   %rbp
  801bf7:	48 89 e5             	mov    %rsp,%rbp
  801bfa:	48 83 ec 10          	sub    $0x10,%rsp
  801bfe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c06:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c0d:	00 
  801c0e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c14:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c1f:	48 89 c2             	mov    %rax,%rdx
  801c22:	be 01 00 00 00       	mov    $0x1,%esi
  801c27:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c2c:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  801c33:	00 00 00 
  801c36:	ff d0                	callq  *%rax
}
  801c38:	c9                   	leaveq 
  801c39:	c3                   	retq   

0000000000801c3a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c3a:	55                   	push   %rbp
  801c3b:	48 89 e5             	mov    %rsp,%rbp
  801c3e:	48 83 ec 30          	sub    $0x30,%rsp
  801c42:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c46:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c4a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  801c4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c52:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  801c56:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801c5b:	75 0e                	jne    801c6b <ipc_recv+0x31>
		page = (void *)KERNBASE;
  801c5d:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  801c64:	00 00 00 
  801c67:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  801c6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c6f:	48 89 c7             	mov    %rax,%rdi
  801c72:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  801c79:	00 00 00 
  801c7c:	ff d0                	callq  *%rax
  801c7e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801c81:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801c85:	79 27                	jns    801cae <ipc_recv+0x74>
		if (from_env_store != NULL)
  801c87:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801c8c:	74 0a                	je     801c98 <ipc_recv+0x5e>
			*from_env_store = 0;
  801c8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c92:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  801c98:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c9d:	74 0a                	je     801ca9 <ipc_recv+0x6f>
			*perm_store = 0;
  801c9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  801ca9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801cac:	eb 53                	jmp    801d01 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  801cae:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801cb3:	74 19                	je     801cce <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  801cb5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801cbc:	00 00 00 
  801cbf:	48 8b 00             	mov    (%rax),%rax
  801cc2:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  801cc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ccc:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  801cce:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801cd3:	74 19                	je     801cee <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  801cd5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801cdc:	00 00 00 
  801cdf:	48 8b 00             	mov    (%rax),%rax
  801ce2:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  801ce8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cec:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  801cee:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801cf5:	00 00 00 
  801cf8:	48 8b 00             	mov    (%rax),%rax
  801cfb:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  801d01:	c9                   	leaveq 
  801d02:	c3                   	retq   

0000000000801d03 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d03:	55                   	push   %rbp
  801d04:	48 89 e5             	mov    %rsp,%rbp
  801d07:	48 83 ec 30          	sub    $0x30,%rsp
  801d0b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d0e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  801d11:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801d15:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  801d18:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  801d20:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801d25:	75 10                	jne    801d37 <ipc_send+0x34>
		page = (void *)KERNBASE;
  801d27:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  801d2e:	00 00 00 
  801d31:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  801d35:	eb 0e                	jmp    801d45 <ipc_send+0x42>
  801d37:	eb 0c                	jmp    801d45 <ipc_send+0x42>
		sys_yield();
  801d39:	48 b8 8f 19 80 00 00 	movabs $0x80198f,%rax
  801d40:	00 00 00 
  801d43:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  801d45:	8b 75 e8             	mov    -0x18(%rbp),%esi
  801d48:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801d4b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d4f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d52:	89 c7                	mov    %eax,%edi
  801d54:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  801d5b:	00 00 00 
  801d5e:	ff d0                	callq  *%rax
  801d60:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801d63:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  801d67:	74 d0                	je     801d39 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  801d69:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801d6d:	74 2a                	je     801d99 <ipc_send+0x96>
		panic("error on ipc send procedure");
  801d6f:	48 ba cb 3a 80 00 00 	movabs $0x803acb,%rdx
  801d76:	00 00 00 
  801d79:	be 49 00 00 00       	mov    $0x49,%esi
  801d7e:	48 bf e7 3a 80 00 00 	movabs $0x803ae7,%rdi
  801d85:	00 00 00 
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8d:	48 b9 19 34 80 00 00 	movabs $0x803419,%rcx
  801d94:	00 00 00 
  801d97:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  801d99:	c9                   	leaveq 
  801d9a:	c3                   	retq   

0000000000801d9b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801d9b:	55                   	push   %rbp
  801d9c:	48 89 e5             	mov    %rsp,%rbp
  801d9f:	48 83 ec 14          	sub    $0x14,%rsp
  801da3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  801da6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801dad:	eb 5e                	jmp    801e0d <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  801daf:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801db6:	00 00 00 
  801db9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dbc:	48 63 d0             	movslq %eax,%rdx
  801dbf:	48 89 d0             	mov    %rdx,%rax
  801dc2:	48 c1 e0 03          	shl    $0x3,%rax
  801dc6:	48 01 d0             	add    %rdx,%rax
  801dc9:	48 c1 e0 05          	shl    $0x5,%rax
  801dcd:	48 01 c8             	add    %rcx,%rax
  801dd0:	48 05 d0 00 00 00    	add    $0xd0,%rax
  801dd6:	8b 00                	mov    (%rax),%eax
  801dd8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801ddb:	75 2c                	jne    801e09 <ipc_find_env+0x6e>
			return envs[i].env_id;
  801ddd:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801de4:	00 00 00 
  801de7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dea:	48 63 d0             	movslq %eax,%rdx
  801ded:	48 89 d0             	mov    %rdx,%rax
  801df0:	48 c1 e0 03          	shl    $0x3,%rax
  801df4:	48 01 d0             	add    %rdx,%rax
  801df7:	48 c1 e0 05          	shl    $0x5,%rax
  801dfb:	48 01 c8             	add    %rcx,%rax
  801dfe:	48 05 c0 00 00 00    	add    $0xc0,%rax
  801e04:	8b 40 08             	mov    0x8(%rax),%eax
  801e07:	eb 12                	jmp    801e1b <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e09:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e0d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801e14:	7e 99                	jle    801daf <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801e16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1b:	c9                   	leaveq 
  801e1c:	c3                   	retq   

0000000000801e1d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e1d:	55                   	push   %rbp
  801e1e:	48 89 e5             	mov    %rsp,%rbp
  801e21:	48 83 ec 08          	sub    $0x8,%rsp
  801e25:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e29:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e2d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e34:	ff ff ff 
  801e37:	48 01 d0             	add    %rdx,%rax
  801e3a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e3e:	c9                   	leaveq 
  801e3f:	c3                   	retq   

0000000000801e40 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e40:	55                   	push   %rbp
  801e41:	48 89 e5             	mov    %rsp,%rbp
  801e44:	48 83 ec 08          	sub    $0x8,%rsp
  801e48:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e50:	48 89 c7             	mov    %rax,%rdi
  801e53:	48 b8 1d 1e 80 00 00 	movabs $0x801e1d,%rax
  801e5a:	00 00 00 
  801e5d:	ff d0                	callq  *%rax
  801e5f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e65:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e69:	c9                   	leaveq 
  801e6a:	c3                   	retq   

0000000000801e6b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e6b:	55                   	push   %rbp
  801e6c:	48 89 e5             	mov    %rsp,%rbp
  801e6f:	48 83 ec 18          	sub    $0x18,%rsp
  801e73:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e7e:	eb 6b                	jmp    801eeb <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e83:	48 98                	cltq   
  801e85:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e8b:	48 c1 e0 0c          	shl    $0xc,%rax
  801e8f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e97:	48 c1 e8 15          	shr    $0x15,%rax
  801e9b:	48 89 c2             	mov    %rax,%rdx
  801e9e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ea5:	01 00 00 
  801ea8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eac:	83 e0 01             	and    $0x1,%eax
  801eaf:	48 85 c0             	test   %rax,%rax
  801eb2:	74 21                	je     801ed5 <fd_alloc+0x6a>
  801eb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb8:	48 c1 e8 0c          	shr    $0xc,%rax
  801ebc:	48 89 c2             	mov    %rax,%rdx
  801ebf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ec6:	01 00 00 
  801ec9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ecd:	83 e0 01             	and    $0x1,%eax
  801ed0:	48 85 c0             	test   %rax,%rax
  801ed3:	75 12                	jne    801ee7 <fd_alloc+0x7c>
			*fd_store = fd;
  801ed5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801edd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee5:	eb 1a                	jmp    801f01 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ee7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801eeb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801eef:	7e 8f                	jle    801e80 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ef1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801efc:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f01:	c9                   	leaveq 
  801f02:	c3                   	retq   

0000000000801f03 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f03:	55                   	push   %rbp
  801f04:	48 89 e5             	mov    %rsp,%rbp
  801f07:	48 83 ec 20          	sub    $0x20,%rsp
  801f0b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f0e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f12:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f16:	78 06                	js     801f1e <fd_lookup+0x1b>
  801f18:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f1c:	7e 07                	jle    801f25 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f1e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f23:	eb 6c                	jmp    801f91 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f25:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f28:	48 98                	cltq   
  801f2a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f30:	48 c1 e0 0c          	shl    $0xc,%rax
  801f34:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f3c:	48 c1 e8 15          	shr    $0x15,%rax
  801f40:	48 89 c2             	mov    %rax,%rdx
  801f43:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f4a:	01 00 00 
  801f4d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f51:	83 e0 01             	and    $0x1,%eax
  801f54:	48 85 c0             	test   %rax,%rax
  801f57:	74 21                	je     801f7a <fd_lookup+0x77>
  801f59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f5d:	48 c1 e8 0c          	shr    $0xc,%rax
  801f61:	48 89 c2             	mov    %rax,%rdx
  801f64:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f6b:	01 00 00 
  801f6e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f72:	83 e0 01             	and    $0x1,%eax
  801f75:	48 85 c0             	test   %rax,%rax
  801f78:	75 07                	jne    801f81 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f7f:	eb 10                	jmp    801f91 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f85:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f89:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f91:	c9                   	leaveq 
  801f92:	c3                   	retq   

0000000000801f93 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f93:	55                   	push   %rbp
  801f94:	48 89 e5             	mov    %rsp,%rbp
  801f97:	48 83 ec 30          	sub    $0x30,%rsp
  801f9b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f9f:	89 f0                	mov    %esi,%eax
  801fa1:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801fa4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fa8:	48 89 c7             	mov    %rax,%rdi
  801fab:	48 b8 1d 1e 80 00 00 	movabs $0x801e1d,%rax
  801fb2:	00 00 00 
  801fb5:	ff d0                	callq  *%rax
  801fb7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801fbb:	48 89 d6             	mov    %rdx,%rsi
  801fbe:	89 c7                	mov    %eax,%edi
  801fc0:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  801fc7:	00 00 00 
  801fca:	ff d0                	callq  *%rax
  801fcc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fcf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fd3:	78 0a                	js     801fdf <fd_close+0x4c>
	    || fd != fd2)
  801fd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fd9:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801fdd:	74 12                	je     801ff1 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801fdf:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801fe3:	74 05                	je     801fea <fd_close+0x57>
  801fe5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fe8:	eb 05                	jmp    801fef <fd_close+0x5c>
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
  801fef:	eb 69                	jmp    80205a <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ff1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff5:	8b 00                	mov    (%rax),%eax
  801ff7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ffb:	48 89 d6             	mov    %rdx,%rsi
  801ffe:	89 c7                	mov    %eax,%edi
  802000:	48 b8 5c 20 80 00 00 	movabs $0x80205c,%rax
  802007:	00 00 00 
  80200a:	ff d0                	callq  *%rax
  80200c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80200f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802013:	78 2a                	js     80203f <fd_close+0xac>
		if (dev->dev_close)
  802015:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802019:	48 8b 40 20          	mov    0x20(%rax),%rax
  80201d:	48 85 c0             	test   %rax,%rax
  802020:	74 16                	je     802038 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802022:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802026:	48 8b 40 20          	mov    0x20(%rax),%rax
  80202a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80202e:	48 89 d7             	mov    %rdx,%rdi
  802031:	ff d0                	callq  *%rax
  802033:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802036:	eb 07                	jmp    80203f <fd_close+0xac>
		else
			r = 0;
  802038:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80203f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802043:	48 89 c6             	mov    %rax,%rsi
  802046:	bf 00 00 00 00       	mov    $0x0,%edi
  80204b:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  802052:	00 00 00 
  802055:	ff d0                	callq  *%rax
	return r;
  802057:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80205a:	c9                   	leaveq 
  80205b:	c3                   	retq   

000000000080205c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80205c:	55                   	push   %rbp
  80205d:	48 89 e5             	mov    %rsp,%rbp
  802060:	48 83 ec 20          	sub    $0x20,%rsp
  802064:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802067:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80206b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802072:	eb 41                	jmp    8020b5 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802074:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80207b:	00 00 00 
  80207e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802081:	48 63 d2             	movslq %edx,%rdx
  802084:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802088:	8b 00                	mov    (%rax),%eax
  80208a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80208d:	75 22                	jne    8020b1 <dev_lookup+0x55>
			*dev = devtab[i];
  80208f:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802096:	00 00 00 
  802099:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80209c:	48 63 d2             	movslq %edx,%rdx
  80209f:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8020a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020a7:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8020aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8020af:	eb 60                	jmp    802111 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8020b1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020b5:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8020bc:	00 00 00 
  8020bf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020c2:	48 63 d2             	movslq %edx,%rdx
  8020c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020c9:	48 85 c0             	test   %rax,%rax
  8020cc:	75 a6                	jne    802074 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8020ce:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8020d5:	00 00 00 
  8020d8:	48 8b 00             	mov    (%rax),%rax
  8020db:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020e1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020e4:	89 c6                	mov    %eax,%esi
  8020e6:	48 bf f8 3a 80 00 00 	movabs $0x803af8,%rdi
  8020ed:	00 00 00 
  8020f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f5:	48 b9 f6 02 80 00 00 	movabs $0x8002f6,%rcx
  8020fc:	00 00 00 
  8020ff:	ff d1                	callq  *%rcx
	*dev = 0;
  802101:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802105:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80210c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802111:	c9                   	leaveq 
  802112:	c3                   	retq   

0000000000802113 <close>:

int
close(int fdnum)
{
  802113:	55                   	push   %rbp
  802114:	48 89 e5             	mov    %rsp,%rbp
  802117:	48 83 ec 20          	sub    $0x20,%rsp
  80211b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80211e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802122:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802125:	48 89 d6             	mov    %rdx,%rsi
  802128:	89 c7                	mov    %eax,%edi
  80212a:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  802131:	00 00 00 
  802134:	ff d0                	callq  *%rax
  802136:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802139:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80213d:	79 05                	jns    802144 <close+0x31>
		return r;
  80213f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802142:	eb 18                	jmp    80215c <close+0x49>
	else
		return fd_close(fd, 1);
  802144:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802148:	be 01 00 00 00       	mov    $0x1,%esi
  80214d:	48 89 c7             	mov    %rax,%rdi
  802150:	48 b8 93 1f 80 00 00 	movabs $0x801f93,%rax
  802157:	00 00 00 
  80215a:	ff d0                	callq  *%rax
}
  80215c:	c9                   	leaveq 
  80215d:	c3                   	retq   

000000000080215e <close_all>:

void
close_all(void)
{
  80215e:	55                   	push   %rbp
  80215f:	48 89 e5             	mov    %rsp,%rbp
  802162:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802166:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80216d:	eb 15                	jmp    802184 <close_all+0x26>
		close(i);
  80216f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802172:	89 c7                	mov    %eax,%edi
  802174:	48 b8 13 21 80 00 00 	movabs $0x802113,%rax
  80217b:	00 00 00 
  80217e:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802180:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802184:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802188:	7e e5                	jle    80216f <close_all+0x11>
		close(i);
}
  80218a:	c9                   	leaveq 
  80218b:	c3                   	retq   

000000000080218c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80218c:	55                   	push   %rbp
  80218d:	48 89 e5             	mov    %rsp,%rbp
  802190:	48 83 ec 40          	sub    $0x40,%rsp
  802194:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802197:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80219a:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80219e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021a1:	48 89 d6             	mov    %rdx,%rsi
  8021a4:	89 c7                	mov    %eax,%edi
  8021a6:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  8021ad:	00 00 00 
  8021b0:	ff d0                	callq  *%rax
  8021b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021b9:	79 08                	jns    8021c3 <dup+0x37>
		return r;
  8021bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021be:	e9 70 01 00 00       	jmpq   802333 <dup+0x1a7>
	close(newfdnum);
  8021c3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021c6:	89 c7                	mov    %eax,%edi
  8021c8:	48 b8 13 21 80 00 00 	movabs $0x802113,%rax
  8021cf:	00 00 00 
  8021d2:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8021d4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021d7:	48 98                	cltq   
  8021d9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021df:	48 c1 e0 0c          	shl    $0xc,%rax
  8021e3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8021e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021eb:	48 89 c7             	mov    %rax,%rdi
  8021ee:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  8021f5:	00 00 00 
  8021f8:	ff d0                	callq  *%rax
  8021fa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802202:	48 89 c7             	mov    %rax,%rdi
  802205:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  80220c:	00 00 00 
  80220f:	ff d0                	callq  *%rax
  802211:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802215:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802219:	48 c1 e8 15          	shr    $0x15,%rax
  80221d:	48 89 c2             	mov    %rax,%rdx
  802220:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802227:	01 00 00 
  80222a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80222e:	83 e0 01             	and    $0x1,%eax
  802231:	48 85 c0             	test   %rax,%rax
  802234:	74 73                	je     8022a9 <dup+0x11d>
  802236:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223a:	48 c1 e8 0c          	shr    $0xc,%rax
  80223e:	48 89 c2             	mov    %rax,%rdx
  802241:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802248:	01 00 00 
  80224b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80224f:	83 e0 01             	and    $0x1,%eax
  802252:	48 85 c0             	test   %rax,%rax
  802255:	74 52                	je     8022a9 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802257:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225b:	48 c1 e8 0c          	shr    $0xc,%rax
  80225f:	48 89 c2             	mov    %rax,%rdx
  802262:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802269:	01 00 00 
  80226c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802270:	25 07 0e 00 00       	and    $0xe07,%eax
  802275:	89 c1                	mov    %eax,%ecx
  802277:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80227b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227f:	41 89 c8             	mov    %ecx,%r8d
  802282:	48 89 d1             	mov    %rdx,%rcx
  802285:	ba 00 00 00 00       	mov    $0x0,%edx
  80228a:	48 89 c6             	mov    %rax,%rsi
  80228d:	bf 00 00 00 00       	mov    $0x0,%edi
  802292:	48 b8 1d 1a 80 00 00 	movabs $0x801a1d,%rax
  802299:	00 00 00 
  80229c:	ff d0                	callq  *%rax
  80229e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a5:	79 02                	jns    8022a9 <dup+0x11d>
			goto err;
  8022a7:	eb 57                	jmp    802300 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8022a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022ad:	48 c1 e8 0c          	shr    $0xc,%rax
  8022b1:	48 89 c2             	mov    %rax,%rdx
  8022b4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022bb:	01 00 00 
  8022be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c2:	25 07 0e 00 00       	and    $0xe07,%eax
  8022c7:	89 c1                	mov    %eax,%ecx
  8022c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022d1:	41 89 c8             	mov    %ecx,%r8d
  8022d4:	48 89 d1             	mov    %rdx,%rcx
  8022d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8022dc:	48 89 c6             	mov    %rax,%rsi
  8022df:	bf 00 00 00 00       	mov    $0x0,%edi
  8022e4:	48 b8 1d 1a 80 00 00 	movabs $0x801a1d,%rax
  8022eb:	00 00 00 
  8022ee:	ff d0                	callq  *%rax
  8022f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f7:	79 02                	jns    8022fb <dup+0x16f>
		goto err;
  8022f9:	eb 05                	jmp    802300 <dup+0x174>

	return newfdnum;
  8022fb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022fe:	eb 33                	jmp    802333 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802304:	48 89 c6             	mov    %rax,%rsi
  802307:	bf 00 00 00 00       	mov    $0x0,%edi
  80230c:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  802313:	00 00 00 
  802316:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802318:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80231c:	48 89 c6             	mov    %rax,%rsi
  80231f:	bf 00 00 00 00       	mov    $0x0,%edi
  802324:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  80232b:	00 00 00 
  80232e:	ff d0                	callq  *%rax
	return r;
  802330:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802333:	c9                   	leaveq 
  802334:	c3                   	retq   

0000000000802335 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802335:	55                   	push   %rbp
  802336:	48 89 e5             	mov    %rsp,%rbp
  802339:	48 83 ec 40          	sub    $0x40,%rsp
  80233d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802340:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802344:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802348:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80234c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80234f:	48 89 d6             	mov    %rdx,%rsi
  802352:	89 c7                	mov    %eax,%edi
  802354:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  80235b:	00 00 00 
  80235e:	ff d0                	callq  *%rax
  802360:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802363:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802367:	78 24                	js     80238d <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236d:	8b 00                	mov    (%rax),%eax
  80236f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802373:	48 89 d6             	mov    %rdx,%rsi
  802376:	89 c7                	mov    %eax,%edi
  802378:	48 b8 5c 20 80 00 00 	movabs $0x80205c,%rax
  80237f:	00 00 00 
  802382:	ff d0                	callq  *%rax
  802384:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802387:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80238b:	79 05                	jns    802392 <read+0x5d>
		return r;
  80238d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802390:	eb 76                	jmp    802408 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802392:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802396:	8b 40 08             	mov    0x8(%rax),%eax
  802399:	83 e0 03             	and    $0x3,%eax
  80239c:	83 f8 01             	cmp    $0x1,%eax
  80239f:	75 3a                	jne    8023db <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8023a1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8023a8:	00 00 00 
  8023ab:	48 8b 00             	mov    (%rax),%rax
  8023ae:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023b4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023b7:	89 c6                	mov    %eax,%esi
  8023b9:	48 bf 17 3b 80 00 00 	movabs $0x803b17,%rdi
  8023c0:	00 00 00 
  8023c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c8:	48 b9 f6 02 80 00 00 	movabs $0x8002f6,%rcx
  8023cf:	00 00 00 
  8023d2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023d9:	eb 2d                	jmp    802408 <read+0xd3>
	}
	if (!dev->dev_read)
  8023db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023df:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023e3:	48 85 c0             	test   %rax,%rax
  8023e6:	75 07                	jne    8023ef <read+0xba>
		return -E_NOT_SUPP;
  8023e8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023ed:	eb 19                	jmp    802408 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8023ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f3:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023f7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023fb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023ff:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802403:	48 89 cf             	mov    %rcx,%rdi
  802406:	ff d0                	callq  *%rax
}
  802408:	c9                   	leaveq 
  802409:	c3                   	retq   

000000000080240a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80240a:	55                   	push   %rbp
  80240b:	48 89 e5             	mov    %rsp,%rbp
  80240e:	48 83 ec 30          	sub    $0x30,%rsp
  802412:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802415:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802419:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80241d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802424:	eb 49                	jmp    80246f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802426:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802429:	48 98                	cltq   
  80242b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80242f:	48 29 c2             	sub    %rax,%rdx
  802432:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802435:	48 63 c8             	movslq %eax,%rcx
  802438:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80243c:	48 01 c1             	add    %rax,%rcx
  80243f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802442:	48 89 ce             	mov    %rcx,%rsi
  802445:	89 c7                	mov    %eax,%edi
  802447:	48 b8 35 23 80 00 00 	movabs $0x802335,%rax
  80244e:	00 00 00 
  802451:	ff d0                	callq  *%rax
  802453:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802456:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80245a:	79 05                	jns    802461 <readn+0x57>
			return m;
  80245c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80245f:	eb 1c                	jmp    80247d <readn+0x73>
		if (m == 0)
  802461:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802465:	75 02                	jne    802469 <readn+0x5f>
			break;
  802467:	eb 11                	jmp    80247a <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802469:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80246c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80246f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802472:	48 98                	cltq   
  802474:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802478:	72 ac                	jb     802426 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80247a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80247d:	c9                   	leaveq 
  80247e:	c3                   	retq   

000000000080247f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80247f:	55                   	push   %rbp
  802480:	48 89 e5             	mov    %rsp,%rbp
  802483:	48 83 ec 40          	sub    $0x40,%rsp
  802487:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80248a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80248e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802492:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802496:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802499:	48 89 d6             	mov    %rdx,%rsi
  80249c:	89 c7                	mov    %eax,%edi
  80249e:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  8024a5:	00 00 00 
  8024a8:	ff d0                	callq  *%rax
  8024aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b1:	78 24                	js     8024d7 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024b7:	8b 00                	mov    (%rax),%eax
  8024b9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024bd:	48 89 d6             	mov    %rdx,%rsi
  8024c0:	89 c7                	mov    %eax,%edi
  8024c2:	48 b8 5c 20 80 00 00 	movabs $0x80205c,%rax
  8024c9:	00 00 00 
  8024cc:	ff d0                	callq  *%rax
  8024ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024d5:	79 05                	jns    8024dc <write+0x5d>
		return r;
  8024d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024da:	eb 75                	jmp    802551 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e0:	8b 40 08             	mov    0x8(%rax),%eax
  8024e3:	83 e0 03             	and    $0x3,%eax
  8024e6:	85 c0                	test   %eax,%eax
  8024e8:	75 3a                	jne    802524 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8024ea:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8024f1:	00 00 00 
  8024f4:	48 8b 00             	mov    (%rax),%rax
  8024f7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024fd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802500:	89 c6                	mov    %eax,%esi
  802502:	48 bf 33 3b 80 00 00 	movabs $0x803b33,%rdi
  802509:	00 00 00 
  80250c:	b8 00 00 00 00       	mov    $0x0,%eax
  802511:	48 b9 f6 02 80 00 00 	movabs $0x8002f6,%rcx
  802518:	00 00 00 
  80251b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80251d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802522:	eb 2d                	jmp    802551 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802524:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802528:	48 8b 40 18          	mov    0x18(%rax),%rax
  80252c:	48 85 c0             	test   %rax,%rax
  80252f:	75 07                	jne    802538 <write+0xb9>
		return -E_NOT_SUPP;
  802531:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802536:	eb 19                	jmp    802551 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802538:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80253c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802540:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802544:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802548:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80254c:	48 89 cf             	mov    %rcx,%rdi
  80254f:	ff d0                	callq  *%rax
}
  802551:	c9                   	leaveq 
  802552:	c3                   	retq   

0000000000802553 <seek>:

int
seek(int fdnum, off_t offset)
{
  802553:	55                   	push   %rbp
  802554:	48 89 e5             	mov    %rsp,%rbp
  802557:	48 83 ec 18          	sub    $0x18,%rsp
  80255b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80255e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802561:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802565:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802568:	48 89 d6             	mov    %rdx,%rsi
  80256b:	89 c7                	mov    %eax,%edi
  80256d:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  802574:	00 00 00 
  802577:	ff d0                	callq  *%rax
  802579:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80257c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802580:	79 05                	jns    802587 <seek+0x34>
		return r;
  802582:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802585:	eb 0f                	jmp    802596 <seek+0x43>
	fd->fd_offset = offset;
  802587:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80258b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80258e:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802591:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802596:	c9                   	leaveq 
  802597:	c3                   	retq   

0000000000802598 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802598:	55                   	push   %rbp
  802599:	48 89 e5             	mov    %rsp,%rbp
  80259c:	48 83 ec 30          	sub    $0x30,%rsp
  8025a0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025a3:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025a6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025aa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025ad:	48 89 d6             	mov    %rdx,%rsi
  8025b0:	89 c7                	mov    %eax,%edi
  8025b2:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  8025b9:	00 00 00 
  8025bc:	ff d0                	callq  *%rax
  8025be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c5:	78 24                	js     8025eb <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025cb:	8b 00                	mov    (%rax),%eax
  8025cd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025d1:	48 89 d6             	mov    %rdx,%rsi
  8025d4:	89 c7                	mov    %eax,%edi
  8025d6:	48 b8 5c 20 80 00 00 	movabs $0x80205c,%rax
  8025dd:	00 00 00 
  8025e0:	ff d0                	callq  *%rax
  8025e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e9:	79 05                	jns    8025f0 <ftruncate+0x58>
		return r;
  8025eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ee:	eb 72                	jmp    802662 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f4:	8b 40 08             	mov    0x8(%rax),%eax
  8025f7:	83 e0 03             	and    $0x3,%eax
  8025fa:	85 c0                	test   %eax,%eax
  8025fc:	75 3a                	jne    802638 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025fe:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802605:	00 00 00 
  802608:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80260b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802611:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802614:	89 c6                	mov    %eax,%esi
  802616:	48 bf 50 3b 80 00 00 	movabs $0x803b50,%rdi
  80261d:	00 00 00 
  802620:	b8 00 00 00 00       	mov    $0x0,%eax
  802625:	48 b9 f6 02 80 00 00 	movabs $0x8002f6,%rcx
  80262c:	00 00 00 
  80262f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802631:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802636:	eb 2a                	jmp    802662 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802638:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802640:	48 85 c0             	test   %rax,%rax
  802643:	75 07                	jne    80264c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802645:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80264a:	eb 16                	jmp    802662 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80264c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802650:	48 8b 40 30          	mov    0x30(%rax),%rax
  802654:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802658:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80265b:	89 ce                	mov    %ecx,%esi
  80265d:	48 89 d7             	mov    %rdx,%rdi
  802660:	ff d0                	callq  *%rax
}
  802662:	c9                   	leaveq 
  802663:	c3                   	retq   

0000000000802664 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802664:	55                   	push   %rbp
  802665:	48 89 e5             	mov    %rsp,%rbp
  802668:	48 83 ec 30          	sub    $0x30,%rsp
  80266c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80266f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802673:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802677:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80267a:	48 89 d6             	mov    %rdx,%rsi
  80267d:	89 c7                	mov    %eax,%edi
  80267f:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  802686:	00 00 00 
  802689:	ff d0                	callq  *%rax
  80268b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80268e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802692:	78 24                	js     8026b8 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802698:	8b 00                	mov    (%rax),%eax
  80269a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80269e:	48 89 d6             	mov    %rdx,%rsi
  8026a1:	89 c7                	mov    %eax,%edi
  8026a3:	48 b8 5c 20 80 00 00 	movabs $0x80205c,%rax
  8026aa:	00 00 00 
  8026ad:	ff d0                	callq  *%rax
  8026af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b6:	79 05                	jns    8026bd <fstat+0x59>
		return r;
  8026b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026bb:	eb 5e                	jmp    80271b <fstat+0xb7>
	if (!dev->dev_stat)
  8026bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c1:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026c5:	48 85 c0             	test   %rax,%rax
  8026c8:	75 07                	jne    8026d1 <fstat+0x6d>
		return -E_NOT_SUPP;
  8026ca:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026cf:	eb 4a                	jmp    80271b <fstat+0xb7>
	stat->st_name[0] = 0;
  8026d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026d5:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8026d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026dc:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8026e3:	00 00 00 
	stat->st_isdir = 0;
  8026e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026ea:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8026f1:	00 00 00 
	stat->st_dev = dev;
  8026f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026fc:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802703:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802707:	48 8b 40 28          	mov    0x28(%rax),%rax
  80270b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80270f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802713:	48 89 ce             	mov    %rcx,%rsi
  802716:	48 89 d7             	mov    %rdx,%rdi
  802719:	ff d0                	callq  *%rax
}
  80271b:	c9                   	leaveq 
  80271c:	c3                   	retq   

000000000080271d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80271d:	55                   	push   %rbp
  80271e:	48 89 e5             	mov    %rsp,%rbp
  802721:	48 83 ec 20          	sub    $0x20,%rsp
  802725:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802729:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80272d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802731:	be 00 00 00 00       	mov    $0x0,%esi
  802736:	48 89 c7             	mov    %rax,%rdi
  802739:	48 b8 0b 28 80 00 00 	movabs $0x80280b,%rax
  802740:	00 00 00 
  802743:	ff d0                	callq  *%rax
  802745:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802748:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80274c:	79 05                	jns    802753 <stat+0x36>
		return fd;
  80274e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802751:	eb 2f                	jmp    802782 <stat+0x65>
	r = fstat(fd, stat);
  802753:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802757:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80275a:	48 89 d6             	mov    %rdx,%rsi
  80275d:	89 c7                	mov    %eax,%edi
  80275f:	48 b8 64 26 80 00 00 	movabs $0x802664,%rax
  802766:	00 00 00 
  802769:	ff d0                	callq  *%rax
  80276b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80276e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802771:	89 c7                	mov    %eax,%edi
  802773:	48 b8 13 21 80 00 00 	movabs $0x802113,%rax
  80277a:	00 00 00 
  80277d:	ff d0                	callq  *%rax
	return r;
  80277f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802782:	c9                   	leaveq 
  802783:	c3                   	retq   

0000000000802784 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802784:	55                   	push   %rbp
  802785:	48 89 e5             	mov    %rsp,%rbp
  802788:	48 83 ec 10          	sub    $0x10,%rsp
  80278c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80278f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802793:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  80279a:	00 00 00 
  80279d:	8b 00                	mov    (%rax),%eax
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	75 1d                	jne    8027c0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8027a3:	bf 01 00 00 00       	mov    $0x1,%edi
  8027a8:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  8027af:	00 00 00 
  8027b2:	ff d0                	callq  *%rax
  8027b4:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  8027bb:	00 00 00 
  8027be:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8027c0:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  8027c7:	00 00 00 
  8027ca:	8b 00                	mov    (%rax),%eax
  8027cc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8027cf:	b9 07 00 00 00       	mov    $0x7,%ecx
  8027d4:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8027db:	00 00 00 
  8027de:	89 c7                	mov    %eax,%edi
  8027e0:	48 b8 03 1d 80 00 00 	movabs $0x801d03,%rax
  8027e7:	00 00 00 
  8027ea:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8027ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8027f5:	48 89 c6             	mov    %rax,%rsi
  8027f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8027fd:	48 b8 3a 1c 80 00 00 	movabs $0x801c3a,%rax
  802804:	00 00 00 
  802807:	ff d0                	callq  *%rax
}
  802809:	c9                   	leaveq 
  80280a:	c3                   	retq   

000000000080280b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80280b:	55                   	push   %rbp
  80280c:	48 89 e5             	mov    %rsp,%rbp
  80280f:	48 83 ec 20          	sub    $0x20,%rsp
  802813:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802817:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  80281a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80281e:	48 89 c7             	mov    %rax,%rdi
  802821:	48 b8 32 10 80 00 00 	movabs $0x801032,%rax
  802828:	00 00 00 
  80282b:	ff d0                	callq  *%rax
  80282d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802832:	7e 0a                	jle    80283e <open+0x33>
		return -E_BAD_PATH;
  802834:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802839:	e9 a5 00 00 00       	jmpq   8028e3 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80283e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802842:	48 89 c7             	mov    %rax,%rdi
  802845:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  80284c:	00 00 00 
  80284f:	ff d0                	callq  *%rax
  802851:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802854:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802858:	79 08                	jns    802862 <open+0x57>
		return r;
  80285a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80285d:	e9 81 00 00 00       	jmpq   8028e3 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802862:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802866:	48 89 c6             	mov    %rax,%rsi
  802869:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802870:	00 00 00 
  802873:	48 b8 9e 10 80 00 00 	movabs $0x80109e,%rax
  80287a:	00 00 00 
  80287d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80287f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802886:	00 00 00 
  802889:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80288c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802892:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802896:	48 89 c6             	mov    %rax,%rsi
  802899:	bf 01 00 00 00       	mov    $0x1,%edi
  80289e:	48 b8 84 27 80 00 00 	movabs $0x802784,%rax
  8028a5:	00 00 00 
  8028a8:	ff d0                	callq  *%rax
  8028aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b1:	79 1d                	jns    8028d0 <open+0xc5>
		fd_close(fd, 0);
  8028b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028b7:	be 00 00 00 00       	mov    $0x0,%esi
  8028bc:	48 89 c7             	mov    %rax,%rdi
  8028bf:	48 b8 93 1f 80 00 00 	movabs $0x801f93,%rax
  8028c6:	00 00 00 
  8028c9:	ff d0                	callq  *%rax
		return r;
  8028cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ce:	eb 13                	jmp    8028e3 <open+0xd8>
	}

	return fd2num(fd);
  8028d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d4:	48 89 c7             	mov    %rax,%rdi
  8028d7:	48 b8 1d 1e 80 00 00 	movabs $0x801e1d,%rax
  8028de:	00 00 00 
  8028e1:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  8028e3:	c9                   	leaveq 
  8028e4:	c3                   	retq   

00000000008028e5 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028e5:	55                   	push   %rbp
  8028e6:	48 89 e5             	mov    %rsp,%rbp
  8028e9:	48 83 ec 10          	sub    $0x10,%rsp
  8028ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028f5:	8b 50 0c             	mov    0xc(%rax),%edx
  8028f8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028ff:	00 00 00 
  802902:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802904:	be 00 00 00 00       	mov    $0x0,%esi
  802909:	bf 06 00 00 00       	mov    $0x6,%edi
  80290e:	48 b8 84 27 80 00 00 	movabs $0x802784,%rax
  802915:	00 00 00 
  802918:	ff d0                	callq  *%rax
}
  80291a:	c9                   	leaveq 
  80291b:	c3                   	retq   

000000000080291c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80291c:	55                   	push   %rbp
  80291d:	48 89 e5             	mov    %rsp,%rbp
  802920:	48 83 ec 30          	sub    $0x30,%rsp
  802924:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802928:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80292c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802934:	8b 50 0c             	mov    0xc(%rax),%edx
  802937:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80293e:	00 00 00 
  802941:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802943:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80294a:	00 00 00 
  80294d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802951:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802955:	be 00 00 00 00       	mov    $0x0,%esi
  80295a:	bf 03 00 00 00       	mov    $0x3,%edi
  80295f:	48 b8 84 27 80 00 00 	movabs $0x802784,%rax
  802966:	00 00 00 
  802969:	ff d0                	callq  *%rax
  80296b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80296e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802972:	79 05                	jns    802979 <devfile_read+0x5d>
		return r;
  802974:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802977:	eb 26                	jmp    80299f <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802979:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80297c:	48 63 d0             	movslq %eax,%rdx
  80297f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802983:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80298a:	00 00 00 
  80298d:	48 89 c7             	mov    %rax,%rdi
  802990:	48 b8 c2 13 80 00 00 	movabs $0x8013c2,%rax
  802997:	00 00 00 
  80299a:	ff d0                	callq  *%rax

	return r;
  80299c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80299f:	c9                   	leaveq 
  8029a0:	c3                   	retq   

00000000008029a1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8029a1:	55                   	push   %rbp
  8029a2:	48 89 e5             	mov    %rsp,%rbp
  8029a5:	48 83 ec 30          	sub    $0x30,%rsp
  8029a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  8029b5:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8029bc:	00 
  8029bd:	76 08                	jbe    8029c7 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  8029bf:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8029c6:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8029c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029cb:	8b 50 0c             	mov    0xc(%rax),%edx
  8029ce:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029d5:	00 00 00 
  8029d8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8029da:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029e1:	00 00 00 
  8029e4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029e8:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  8029ec:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029f4:	48 89 c6             	mov    %rax,%rsi
  8029f7:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8029fe:	00 00 00 
  802a01:	48 b8 c2 13 80 00 00 	movabs $0x8013c2,%rax
  802a08:	00 00 00 
  802a0b:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802a0d:	be 00 00 00 00       	mov    $0x0,%esi
  802a12:	bf 04 00 00 00       	mov    $0x4,%edi
  802a17:	48 b8 84 27 80 00 00 	movabs $0x802784,%rax
  802a1e:	00 00 00 
  802a21:	ff d0                	callq  *%rax
  802a23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a2a:	79 05                	jns    802a31 <devfile_write+0x90>
		return r;
  802a2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a2f:	eb 03                	jmp    802a34 <devfile_write+0x93>

	return r;
  802a31:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802a34:	c9                   	leaveq 
  802a35:	c3                   	retq   

0000000000802a36 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a36:	55                   	push   %rbp
  802a37:	48 89 e5             	mov    %rsp,%rbp
  802a3a:	48 83 ec 20          	sub    $0x20,%rsp
  802a3e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a42:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a4a:	8b 50 0c             	mov    0xc(%rax),%edx
  802a4d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a54:	00 00 00 
  802a57:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a59:	be 00 00 00 00       	mov    $0x0,%esi
  802a5e:	bf 05 00 00 00       	mov    $0x5,%edi
  802a63:	48 b8 84 27 80 00 00 	movabs $0x802784,%rax
  802a6a:	00 00 00 
  802a6d:	ff d0                	callq  *%rax
  802a6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a76:	79 05                	jns    802a7d <devfile_stat+0x47>
		return r;
  802a78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7b:	eb 56                	jmp    802ad3 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a7d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a81:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802a88:	00 00 00 
  802a8b:	48 89 c7             	mov    %rax,%rdi
  802a8e:	48 b8 9e 10 80 00 00 	movabs $0x80109e,%rax
  802a95:	00 00 00 
  802a98:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a9a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aa1:	00 00 00 
  802aa4:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802aaa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aae:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802ab4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802abb:	00 00 00 
  802abe:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802ac4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ac8:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802ace:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ad3:	c9                   	leaveq 
  802ad4:	c3                   	retq   

0000000000802ad5 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802ad5:	55                   	push   %rbp
  802ad6:	48 89 e5             	mov    %rsp,%rbp
  802ad9:	48 83 ec 10          	sub    $0x10,%rsp
  802add:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ae1:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802ae4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ae8:	8b 50 0c             	mov    0xc(%rax),%edx
  802aeb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802af2:	00 00 00 
  802af5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802af7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802afe:	00 00 00 
  802b01:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b04:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b07:	be 00 00 00 00       	mov    $0x0,%esi
  802b0c:	bf 02 00 00 00       	mov    $0x2,%edi
  802b11:	48 b8 84 27 80 00 00 	movabs $0x802784,%rax
  802b18:	00 00 00 
  802b1b:	ff d0                	callq  *%rax
}
  802b1d:	c9                   	leaveq 
  802b1e:	c3                   	retq   

0000000000802b1f <remove>:

// Delete a file
int
remove(const char *path)
{
  802b1f:	55                   	push   %rbp
  802b20:	48 89 e5             	mov    %rsp,%rbp
  802b23:	48 83 ec 10          	sub    $0x10,%rsp
  802b27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b2f:	48 89 c7             	mov    %rax,%rdi
  802b32:	48 b8 32 10 80 00 00 	movabs $0x801032,%rax
  802b39:	00 00 00 
  802b3c:	ff d0                	callq  *%rax
  802b3e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b43:	7e 07                	jle    802b4c <remove+0x2d>
		return -E_BAD_PATH;
  802b45:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b4a:	eb 33                	jmp    802b7f <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802b4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b50:	48 89 c6             	mov    %rax,%rsi
  802b53:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802b5a:	00 00 00 
  802b5d:	48 b8 9e 10 80 00 00 	movabs $0x80109e,%rax
  802b64:	00 00 00 
  802b67:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b69:	be 00 00 00 00       	mov    $0x0,%esi
  802b6e:	bf 07 00 00 00       	mov    $0x7,%edi
  802b73:	48 b8 84 27 80 00 00 	movabs $0x802784,%rax
  802b7a:	00 00 00 
  802b7d:	ff d0                	callq  *%rax
}
  802b7f:	c9                   	leaveq 
  802b80:	c3                   	retq   

0000000000802b81 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b81:	55                   	push   %rbp
  802b82:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b85:	be 00 00 00 00       	mov    $0x0,%esi
  802b8a:	bf 08 00 00 00       	mov    $0x8,%edi
  802b8f:	48 b8 84 27 80 00 00 	movabs $0x802784,%rax
  802b96:	00 00 00 
  802b99:	ff d0                	callq  *%rax
}
  802b9b:	5d                   	pop    %rbp
  802b9c:	c3                   	retq   

0000000000802b9d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802b9d:	55                   	push   %rbp
  802b9e:	48 89 e5             	mov    %rsp,%rbp
  802ba1:	53                   	push   %rbx
  802ba2:	48 83 ec 38          	sub    $0x38,%rsp
  802ba6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802baa:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802bae:	48 89 c7             	mov    %rax,%rdi
  802bb1:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  802bb8:	00 00 00 
  802bbb:	ff d0                	callq  *%rax
  802bbd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802bc0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802bc4:	0f 88 bf 01 00 00    	js     802d89 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bce:	ba 07 04 00 00       	mov    $0x407,%edx
  802bd3:	48 89 c6             	mov    %rax,%rsi
  802bd6:	bf 00 00 00 00       	mov    $0x0,%edi
  802bdb:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  802be2:	00 00 00 
  802be5:	ff d0                	callq  *%rax
  802be7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802bea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802bee:	0f 88 95 01 00 00    	js     802d89 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802bf4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802bf8:	48 89 c7             	mov    %rax,%rdi
  802bfb:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  802c02:	00 00 00 
  802c05:	ff d0                	callq  *%rax
  802c07:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c0a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c0e:	0f 88 5d 01 00 00    	js     802d71 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c14:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c18:	ba 07 04 00 00       	mov    $0x407,%edx
  802c1d:	48 89 c6             	mov    %rax,%rsi
  802c20:	bf 00 00 00 00       	mov    $0x0,%edi
  802c25:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  802c2c:	00 00 00 
  802c2f:	ff d0                	callq  *%rax
  802c31:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c34:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c38:	0f 88 33 01 00 00    	js     802d71 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802c3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c42:	48 89 c7             	mov    %rax,%rdi
  802c45:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  802c4c:	00 00 00 
  802c4f:	ff d0                	callq  *%rax
  802c51:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c59:	ba 07 04 00 00       	mov    $0x407,%edx
  802c5e:	48 89 c6             	mov    %rax,%rsi
  802c61:	bf 00 00 00 00       	mov    $0x0,%edi
  802c66:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  802c6d:	00 00 00 
  802c70:	ff d0                	callq  *%rax
  802c72:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c75:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c79:	79 05                	jns    802c80 <pipe+0xe3>
		goto err2;
  802c7b:	e9 d9 00 00 00       	jmpq   802d59 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c80:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c84:	48 89 c7             	mov    %rax,%rdi
  802c87:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  802c8e:	00 00 00 
  802c91:	ff d0                	callq  *%rax
  802c93:	48 89 c2             	mov    %rax,%rdx
  802c96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c9a:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802ca0:	48 89 d1             	mov    %rdx,%rcx
  802ca3:	ba 00 00 00 00       	mov    $0x0,%edx
  802ca8:	48 89 c6             	mov    %rax,%rsi
  802cab:	bf 00 00 00 00       	mov    $0x0,%edi
  802cb0:	48 b8 1d 1a 80 00 00 	movabs $0x801a1d,%rax
  802cb7:	00 00 00 
  802cba:	ff d0                	callq  *%rax
  802cbc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802cbf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802cc3:	79 1b                	jns    802ce0 <pipe+0x143>
		goto err3;
  802cc5:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  802cc6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cca:	48 89 c6             	mov    %rax,%rsi
  802ccd:	bf 00 00 00 00       	mov    $0x0,%edi
  802cd2:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  802cd9:	00 00 00 
  802cdc:	ff d0                	callq  *%rax
  802cde:	eb 79                	jmp    802d59 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802ce0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ce4:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802ceb:	00 00 00 
  802cee:	8b 12                	mov    (%rdx),%edx
  802cf0:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802cf2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cf6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802cfd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d01:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802d08:	00 00 00 
  802d0b:	8b 12                	mov    (%rdx),%edx
  802d0d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802d0f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d13:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802d1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d1e:	48 89 c7             	mov    %rax,%rdi
  802d21:	48 b8 1d 1e 80 00 00 	movabs $0x801e1d,%rax
  802d28:	00 00 00 
  802d2b:	ff d0                	callq  *%rax
  802d2d:	89 c2                	mov    %eax,%edx
  802d2f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d33:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802d35:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d39:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802d3d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d41:	48 89 c7             	mov    %rax,%rdi
  802d44:	48 b8 1d 1e 80 00 00 	movabs $0x801e1d,%rax
  802d4b:	00 00 00 
  802d4e:	ff d0                	callq  *%rax
  802d50:	89 03                	mov    %eax,(%rbx)
	return 0;
  802d52:	b8 00 00 00 00       	mov    $0x0,%eax
  802d57:	eb 33                	jmp    802d8c <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  802d59:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d5d:	48 89 c6             	mov    %rax,%rsi
  802d60:	bf 00 00 00 00       	mov    $0x0,%edi
  802d65:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  802d6c:	00 00 00 
  802d6f:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  802d71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d75:	48 89 c6             	mov    %rax,%rsi
  802d78:	bf 00 00 00 00       	mov    $0x0,%edi
  802d7d:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  802d84:	00 00 00 
  802d87:	ff d0                	callq  *%rax
    err:
	return r;
  802d89:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802d8c:	48 83 c4 38          	add    $0x38,%rsp
  802d90:	5b                   	pop    %rbx
  802d91:	5d                   	pop    %rbp
  802d92:	c3                   	retq   

0000000000802d93 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802d93:	55                   	push   %rbp
  802d94:	48 89 e5             	mov    %rsp,%rbp
  802d97:	53                   	push   %rbx
  802d98:	48 83 ec 28          	sub    $0x28,%rsp
  802d9c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802da0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802da4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802dab:	00 00 00 
  802dae:	48 8b 00             	mov    (%rax),%rax
  802db1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802db7:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802dba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dbe:	48 89 c7             	mov    %rax,%rdi
  802dc1:	48 b8 2d 35 80 00 00 	movabs $0x80352d,%rax
  802dc8:	00 00 00 
  802dcb:	ff d0                	callq  *%rax
  802dcd:	89 c3                	mov    %eax,%ebx
  802dcf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dd3:	48 89 c7             	mov    %rax,%rdi
  802dd6:	48 b8 2d 35 80 00 00 	movabs $0x80352d,%rax
  802ddd:	00 00 00 
  802de0:	ff d0                	callq  *%rax
  802de2:	39 c3                	cmp    %eax,%ebx
  802de4:	0f 94 c0             	sete   %al
  802de7:	0f b6 c0             	movzbl %al,%eax
  802dea:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802ded:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802df4:	00 00 00 
  802df7:	48 8b 00             	mov    (%rax),%rax
  802dfa:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802e00:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802e03:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e06:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802e09:	75 05                	jne    802e10 <_pipeisclosed+0x7d>
			return ret;
  802e0b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e0e:	eb 4f                	jmp    802e5f <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802e10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e13:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802e16:	74 42                	je     802e5a <_pipeisclosed+0xc7>
  802e18:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802e1c:	75 3c                	jne    802e5a <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802e1e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802e25:	00 00 00 
  802e28:	48 8b 00             	mov    (%rax),%rax
  802e2b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802e31:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802e34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e37:	89 c6                	mov    %eax,%esi
  802e39:	48 bf 7b 3b 80 00 00 	movabs $0x803b7b,%rdi
  802e40:	00 00 00 
  802e43:	b8 00 00 00 00       	mov    $0x0,%eax
  802e48:	49 b8 f6 02 80 00 00 	movabs $0x8002f6,%r8
  802e4f:	00 00 00 
  802e52:	41 ff d0             	callq  *%r8
	}
  802e55:	e9 4a ff ff ff       	jmpq   802da4 <_pipeisclosed+0x11>
  802e5a:	e9 45 ff ff ff       	jmpq   802da4 <_pipeisclosed+0x11>
}
  802e5f:	48 83 c4 28          	add    $0x28,%rsp
  802e63:	5b                   	pop    %rbx
  802e64:	5d                   	pop    %rbp
  802e65:	c3                   	retq   

0000000000802e66 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802e66:	55                   	push   %rbp
  802e67:	48 89 e5             	mov    %rsp,%rbp
  802e6a:	48 83 ec 30          	sub    $0x30,%rsp
  802e6e:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e71:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e75:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e78:	48 89 d6             	mov    %rdx,%rsi
  802e7b:	89 c7                	mov    %eax,%edi
  802e7d:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  802e84:	00 00 00 
  802e87:	ff d0                	callq  *%rax
  802e89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e90:	79 05                	jns    802e97 <pipeisclosed+0x31>
		return r;
  802e92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e95:	eb 31                	jmp    802ec8 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802e97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e9b:	48 89 c7             	mov    %rax,%rdi
  802e9e:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  802ea5:	00 00 00 
  802ea8:	ff d0                	callq  *%rax
  802eaa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802eae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802eb6:	48 89 d6             	mov    %rdx,%rsi
  802eb9:	48 89 c7             	mov    %rax,%rdi
  802ebc:	48 b8 93 2d 80 00 00 	movabs $0x802d93,%rax
  802ec3:	00 00 00 
  802ec6:	ff d0                	callq  *%rax
}
  802ec8:	c9                   	leaveq 
  802ec9:	c3                   	retq   

0000000000802eca <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802eca:	55                   	push   %rbp
  802ecb:	48 89 e5             	mov    %rsp,%rbp
  802ece:	48 83 ec 40          	sub    $0x40,%rsp
  802ed2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ed6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802eda:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802ede:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ee2:	48 89 c7             	mov    %rax,%rdi
  802ee5:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  802eec:	00 00 00 
  802eef:	ff d0                	callq  *%rax
  802ef1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802ef5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ef9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802efd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802f04:	00 
  802f05:	e9 92 00 00 00       	jmpq   802f9c <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802f0a:	eb 41                	jmp    802f4d <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802f0c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802f11:	74 09                	je     802f1c <devpipe_read+0x52>
				return i;
  802f13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f17:	e9 92 00 00 00       	jmpq   802fae <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802f1c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f24:	48 89 d6             	mov    %rdx,%rsi
  802f27:	48 89 c7             	mov    %rax,%rdi
  802f2a:	48 b8 93 2d 80 00 00 	movabs $0x802d93,%rax
  802f31:	00 00 00 
  802f34:	ff d0                	callq  *%rax
  802f36:	85 c0                	test   %eax,%eax
  802f38:	74 07                	je     802f41 <devpipe_read+0x77>
				return 0;
  802f3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f3f:	eb 6d                	jmp    802fae <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802f41:	48 b8 8f 19 80 00 00 	movabs $0x80198f,%rax
  802f48:	00 00 00 
  802f4b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802f4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f51:	8b 10                	mov    (%rax),%edx
  802f53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f57:	8b 40 04             	mov    0x4(%rax),%eax
  802f5a:	39 c2                	cmp    %eax,%edx
  802f5c:	74 ae                	je     802f0c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802f5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f62:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f66:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802f6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f6e:	8b 00                	mov    (%rax),%eax
  802f70:	99                   	cltd   
  802f71:	c1 ea 1b             	shr    $0x1b,%edx
  802f74:	01 d0                	add    %edx,%eax
  802f76:	83 e0 1f             	and    $0x1f,%eax
  802f79:	29 d0                	sub    %edx,%eax
  802f7b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f7f:	48 98                	cltq   
  802f81:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802f86:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802f88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f8c:	8b 00                	mov    (%rax),%eax
  802f8e:	8d 50 01             	lea    0x1(%rax),%edx
  802f91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f95:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f97:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802f9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fa0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802fa4:	0f 82 60 ff ff ff    	jb     802f0a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802faa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802fae:	c9                   	leaveq 
  802faf:	c3                   	retq   

0000000000802fb0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802fb0:	55                   	push   %rbp
  802fb1:	48 89 e5             	mov    %rsp,%rbp
  802fb4:	48 83 ec 40          	sub    $0x40,%rsp
  802fb8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802fbc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802fc0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802fc4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fc8:	48 89 c7             	mov    %rax,%rdi
  802fcb:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  802fd2:	00 00 00 
  802fd5:	ff d0                	callq  *%rax
  802fd7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802fdb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fdf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802fe3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802fea:	00 
  802feb:	e9 8e 00 00 00       	jmpq   80307e <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802ff0:	eb 31                	jmp    803023 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802ff2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ff6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ffa:	48 89 d6             	mov    %rdx,%rsi
  802ffd:	48 89 c7             	mov    %rax,%rdi
  803000:	48 b8 93 2d 80 00 00 	movabs $0x802d93,%rax
  803007:	00 00 00 
  80300a:	ff d0                	callq  *%rax
  80300c:	85 c0                	test   %eax,%eax
  80300e:	74 07                	je     803017 <devpipe_write+0x67>
				return 0;
  803010:	b8 00 00 00 00       	mov    $0x0,%eax
  803015:	eb 79                	jmp    803090 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803017:	48 b8 8f 19 80 00 00 	movabs $0x80198f,%rax
  80301e:	00 00 00 
  803021:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803023:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803027:	8b 40 04             	mov    0x4(%rax),%eax
  80302a:	48 63 d0             	movslq %eax,%rdx
  80302d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803031:	8b 00                	mov    (%rax),%eax
  803033:	48 98                	cltq   
  803035:	48 83 c0 20          	add    $0x20,%rax
  803039:	48 39 c2             	cmp    %rax,%rdx
  80303c:	73 b4                	jae    802ff2 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80303e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803042:	8b 40 04             	mov    0x4(%rax),%eax
  803045:	99                   	cltd   
  803046:	c1 ea 1b             	shr    $0x1b,%edx
  803049:	01 d0                	add    %edx,%eax
  80304b:	83 e0 1f             	and    $0x1f,%eax
  80304e:	29 d0                	sub    %edx,%eax
  803050:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803054:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803058:	48 01 ca             	add    %rcx,%rdx
  80305b:	0f b6 0a             	movzbl (%rdx),%ecx
  80305e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803062:	48 98                	cltq   
  803064:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803068:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80306c:	8b 40 04             	mov    0x4(%rax),%eax
  80306f:	8d 50 01             	lea    0x1(%rax),%edx
  803072:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803076:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803079:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80307e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803082:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803086:	0f 82 64 ff ff ff    	jb     802ff0 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80308c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803090:	c9                   	leaveq 
  803091:	c3                   	retq   

0000000000803092 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803092:	55                   	push   %rbp
  803093:	48 89 e5             	mov    %rsp,%rbp
  803096:	48 83 ec 20          	sub    $0x20,%rsp
  80309a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80309e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8030a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030a6:	48 89 c7             	mov    %rax,%rdi
  8030a9:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  8030b0:	00 00 00 
  8030b3:	ff d0                	callq  *%rax
  8030b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8030b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030bd:	48 be 8e 3b 80 00 00 	movabs $0x803b8e,%rsi
  8030c4:	00 00 00 
  8030c7:	48 89 c7             	mov    %rax,%rdi
  8030ca:	48 b8 9e 10 80 00 00 	movabs $0x80109e,%rax
  8030d1:	00 00 00 
  8030d4:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8030d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030da:	8b 50 04             	mov    0x4(%rax),%edx
  8030dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030e1:	8b 00                	mov    (%rax),%eax
  8030e3:	29 c2                	sub    %eax,%edx
  8030e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030e9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8030ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030f3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8030fa:	00 00 00 
	stat->st_dev = &devpipe;
  8030fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803101:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  803108:	00 00 00 
  80310b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803112:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803117:	c9                   	leaveq 
  803118:	c3                   	retq   

0000000000803119 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803119:	55                   	push   %rbp
  80311a:	48 89 e5             	mov    %rsp,%rbp
  80311d:	48 83 ec 10          	sub    $0x10,%rsp
  803121:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803125:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803129:	48 89 c6             	mov    %rax,%rsi
  80312c:	bf 00 00 00 00       	mov    $0x0,%edi
  803131:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  803138:	00 00 00 
  80313b:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80313d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803141:	48 89 c7             	mov    %rax,%rdi
  803144:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  80314b:	00 00 00 
  80314e:	ff d0                	callq  *%rax
  803150:	48 89 c6             	mov    %rax,%rsi
  803153:	bf 00 00 00 00       	mov    $0x0,%edi
  803158:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  80315f:	00 00 00 
  803162:	ff d0                	callq  *%rax
}
  803164:	c9                   	leaveq 
  803165:	c3                   	retq   

0000000000803166 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803166:	55                   	push   %rbp
  803167:	48 89 e5             	mov    %rsp,%rbp
  80316a:	48 83 ec 20          	sub    $0x20,%rsp
  80316e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803171:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803174:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803177:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80317b:	be 01 00 00 00       	mov    $0x1,%esi
  803180:	48 89 c7             	mov    %rax,%rdi
  803183:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  80318a:	00 00 00 
  80318d:	ff d0                	callq  *%rax
}
  80318f:	c9                   	leaveq 
  803190:	c3                   	retq   

0000000000803191 <getchar>:

int
getchar(void)
{
  803191:	55                   	push   %rbp
  803192:	48 89 e5             	mov    %rsp,%rbp
  803195:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803199:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80319d:	ba 01 00 00 00       	mov    $0x1,%edx
  8031a2:	48 89 c6             	mov    %rax,%rsi
  8031a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8031aa:	48 b8 35 23 80 00 00 	movabs $0x802335,%rax
  8031b1:	00 00 00 
  8031b4:	ff d0                	callq  *%rax
  8031b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8031b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031bd:	79 05                	jns    8031c4 <getchar+0x33>
		return r;
  8031bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c2:	eb 14                	jmp    8031d8 <getchar+0x47>
	if (r < 1)
  8031c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c8:	7f 07                	jg     8031d1 <getchar+0x40>
		return -E_EOF;
  8031ca:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8031cf:	eb 07                	jmp    8031d8 <getchar+0x47>
	return c;
  8031d1:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8031d5:	0f b6 c0             	movzbl %al,%eax
}
  8031d8:	c9                   	leaveq 
  8031d9:	c3                   	retq   

00000000008031da <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8031da:	55                   	push   %rbp
  8031db:	48 89 e5             	mov    %rsp,%rbp
  8031de:	48 83 ec 20          	sub    $0x20,%rsp
  8031e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031e5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031ec:	48 89 d6             	mov    %rdx,%rsi
  8031ef:	89 c7                	mov    %eax,%edi
  8031f1:	48 b8 03 1f 80 00 00 	movabs $0x801f03,%rax
  8031f8:	00 00 00 
  8031fb:	ff d0                	callq  *%rax
  8031fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803200:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803204:	79 05                	jns    80320b <iscons+0x31>
		return r;
  803206:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803209:	eb 1a                	jmp    803225 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80320b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80320f:	8b 10                	mov    (%rax),%edx
  803211:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803218:	00 00 00 
  80321b:	8b 00                	mov    (%rax),%eax
  80321d:	39 c2                	cmp    %eax,%edx
  80321f:	0f 94 c0             	sete   %al
  803222:	0f b6 c0             	movzbl %al,%eax
}
  803225:	c9                   	leaveq 
  803226:	c3                   	retq   

0000000000803227 <opencons>:

int
opencons(void)
{
  803227:	55                   	push   %rbp
  803228:	48 89 e5             	mov    %rsp,%rbp
  80322b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80322f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803233:	48 89 c7             	mov    %rax,%rdi
  803236:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  80323d:	00 00 00 
  803240:	ff d0                	callq  *%rax
  803242:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803245:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803249:	79 05                	jns    803250 <opencons+0x29>
		return r;
  80324b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80324e:	eb 5b                	jmp    8032ab <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803250:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803254:	ba 07 04 00 00       	mov    $0x407,%edx
  803259:	48 89 c6             	mov    %rax,%rsi
  80325c:	bf 00 00 00 00       	mov    $0x0,%edi
  803261:	48 b8 cd 19 80 00 00 	movabs $0x8019cd,%rax
  803268:	00 00 00 
  80326b:	ff d0                	callq  *%rax
  80326d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803270:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803274:	79 05                	jns    80327b <opencons+0x54>
		return r;
  803276:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803279:	eb 30                	jmp    8032ab <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80327b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80327f:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803286:	00 00 00 
  803289:	8b 12                	mov    (%rdx),%edx
  80328b:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80328d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803291:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803298:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80329c:	48 89 c7             	mov    %rax,%rdi
  80329f:	48 b8 1d 1e 80 00 00 	movabs $0x801e1d,%rax
  8032a6:	00 00 00 
  8032a9:	ff d0                	callq  *%rax
}
  8032ab:	c9                   	leaveq 
  8032ac:	c3                   	retq   

00000000008032ad <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8032ad:	55                   	push   %rbp
  8032ae:	48 89 e5             	mov    %rsp,%rbp
  8032b1:	48 83 ec 30          	sub    $0x30,%rsp
  8032b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032bd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8032c1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8032c6:	75 07                	jne    8032cf <devcons_read+0x22>
		return 0;
  8032c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032cd:	eb 4b                	jmp    80331a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8032cf:	eb 0c                	jmp    8032dd <devcons_read+0x30>
		sys_yield();
  8032d1:	48 b8 8f 19 80 00 00 	movabs $0x80198f,%rax
  8032d8:	00 00 00 
  8032db:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8032dd:	48 b8 cf 18 80 00 00 	movabs $0x8018cf,%rax
  8032e4:	00 00 00 
  8032e7:	ff d0                	callq  *%rax
  8032e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f0:	74 df                	je     8032d1 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8032f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f6:	79 05                	jns    8032fd <devcons_read+0x50>
		return c;
  8032f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032fb:	eb 1d                	jmp    80331a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8032fd:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803301:	75 07                	jne    80330a <devcons_read+0x5d>
		return 0;
  803303:	b8 00 00 00 00       	mov    $0x0,%eax
  803308:	eb 10                	jmp    80331a <devcons_read+0x6d>
	*(char*)vbuf = c;
  80330a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80330d:	89 c2                	mov    %eax,%edx
  80330f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803313:	88 10                	mov    %dl,(%rax)
	return 1;
  803315:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80331a:	c9                   	leaveq 
  80331b:	c3                   	retq   

000000000080331c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80331c:	55                   	push   %rbp
  80331d:	48 89 e5             	mov    %rsp,%rbp
  803320:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803327:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80332e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803335:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80333c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803343:	eb 76                	jmp    8033bb <devcons_write+0x9f>
		m = n - tot;
  803345:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80334c:	89 c2                	mov    %eax,%edx
  80334e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803351:	29 c2                	sub    %eax,%edx
  803353:	89 d0                	mov    %edx,%eax
  803355:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803358:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80335b:	83 f8 7f             	cmp    $0x7f,%eax
  80335e:	76 07                	jbe    803367 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803360:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803367:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80336a:	48 63 d0             	movslq %eax,%rdx
  80336d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803370:	48 63 c8             	movslq %eax,%rcx
  803373:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80337a:	48 01 c1             	add    %rax,%rcx
  80337d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803384:	48 89 ce             	mov    %rcx,%rsi
  803387:	48 89 c7             	mov    %rax,%rdi
  80338a:	48 b8 c2 13 80 00 00 	movabs $0x8013c2,%rax
  803391:	00 00 00 
  803394:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803396:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803399:	48 63 d0             	movslq %eax,%rdx
  80339c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8033a3:	48 89 d6             	mov    %rdx,%rsi
  8033a6:	48 89 c7             	mov    %rax,%rdi
  8033a9:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  8033b0:	00 00 00 
  8033b3:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8033b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033b8:	01 45 fc             	add    %eax,-0x4(%rbp)
  8033bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033be:	48 98                	cltq   
  8033c0:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8033c7:	0f 82 78 ff ff ff    	jb     803345 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8033cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033d0:	c9                   	leaveq 
  8033d1:	c3                   	retq   

00000000008033d2 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8033d2:	55                   	push   %rbp
  8033d3:	48 89 e5             	mov    %rsp,%rbp
  8033d6:	48 83 ec 08          	sub    $0x8,%rsp
  8033da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8033de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033e3:	c9                   	leaveq 
  8033e4:	c3                   	retq   

00000000008033e5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8033e5:	55                   	push   %rbp
  8033e6:	48 89 e5             	mov    %rsp,%rbp
  8033e9:	48 83 ec 10          	sub    $0x10,%rsp
  8033ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8033f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f9:	48 be 9a 3b 80 00 00 	movabs $0x803b9a,%rsi
  803400:	00 00 00 
  803403:	48 89 c7             	mov    %rax,%rdi
  803406:	48 b8 9e 10 80 00 00 	movabs $0x80109e,%rax
  80340d:	00 00 00 
  803410:	ff d0                	callq  *%rax
	return 0;
  803412:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803417:	c9                   	leaveq 
  803418:	c3                   	retq   

0000000000803419 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803419:	55                   	push   %rbp
  80341a:	48 89 e5             	mov    %rsp,%rbp
  80341d:	53                   	push   %rbx
  80341e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803425:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80342c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803432:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803439:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803440:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803447:	84 c0                	test   %al,%al
  803449:	74 23                	je     80346e <_panic+0x55>
  80344b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803452:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803456:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80345a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80345e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803462:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803466:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80346a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80346e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803475:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80347c:	00 00 00 
  80347f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803486:	00 00 00 
  803489:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80348d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803494:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80349b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8034a2:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8034a9:	00 00 00 
  8034ac:	48 8b 18             	mov    (%rax),%rbx
  8034af:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  8034b6:	00 00 00 
  8034b9:	ff d0                	callq  *%rax
  8034bb:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8034c1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8034c8:	41 89 c8             	mov    %ecx,%r8d
  8034cb:	48 89 d1             	mov    %rdx,%rcx
  8034ce:	48 89 da             	mov    %rbx,%rdx
  8034d1:	89 c6                	mov    %eax,%esi
  8034d3:	48 bf a8 3b 80 00 00 	movabs $0x803ba8,%rdi
  8034da:	00 00 00 
  8034dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e2:	49 b9 f6 02 80 00 00 	movabs $0x8002f6,%r9
  8034e9:	00 00 00 
  8034ec:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8034ef:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8034f6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8034fd:	48 89 d6             	mov    %rdx,%rsi
  803500:	48 89 c7             	mov    %rax,%rdi
  803503:	48 b8 4a 02 80 00 00 	movabs $0x80024a,%rax
  80350a:	00 00 00 
  80350d:	ff d0                	callq  *%rax
	cprintf("\n");
  80350f:	48 bf cb 3b 80 00 00 	movabs $0x803bcb,%rdi
  803516:	00 00 00 
  803519:	b8 00 00 00 00       	mov    $0x0,%eax
  80351e:	48 ba f6 02 80 00 00 	movabs $0x8002f6,%rdx
  803525:	00 00 00 
  803528:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80352a:	cc                   	int3   
  80352b:	eb fd                	jmp    80352a <_panic+0x111>

000000000080352d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80352d:	55                   	push   %rbp
  80352e:	48 89 e5             	mov    %rsp,%rbp
  803531:	48 83 ec 18          	sub    $0x18,%rsp
  803535:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803539:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80353d:	48 c1 e8 15          	shr    $0x15,%rax
  803541:	48 89 c2             	mov    %rax,%rdx
  803544:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80354b:	01 00 00 
  80354e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803552:	83 e0 01             	and    $0x1,%eax
  803555:	48 85 c0             	test   %rax,%rax
  803558:	75 07                	jne    803561 <pageref+0x34>
		return 0;
  80355a:	b8 00 00 00 00       	mov    $0x0,%eax
  80355f:	eb 53                	jmp    8035b4 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803561:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803565:	48 c1 e8 0c          	shr    $0xc,%rax
  803569:	48 89 c2             	mov    %rax,%rdx
  80356c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803573:	01 00 00 
  803576:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80357a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80357e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803582:	83 e0 01             	and    $0x1,%eax
  803585:	48 85 c0             	test   %rax,%rax
  803588:	75 07                	jne    803591 <pageref+0x64>
		return 0;
  80358a:	b8 00 00 00 00       	mov    $0x0,%eax
  80358f:	eb 23                	jmp    8035b4 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803595:	48 c1 e8 0c          	shr    $0xc,%rax
  803599:	48 89 c2             	mov    %rax,%rdx
  80359c:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035a3:	00 00 00 
  8035a6:	48 c1 e2 04          	shl    $0x4,%rdx
  8035aa:	48 01 d0             	add    %rdx,%rax
  8035ad:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8035b1:	0f b7 c0             	movzwl %ax,%eax
}
  8035b4:	c9                   	leaveq 
  8035b5:	c3                   	retq   
