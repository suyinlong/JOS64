
obj/user/pingpong.debug:     file format elf64-x86-64


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
  80003c:	e8 06 01 00 00       	callq  800147 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 83 ec 28          	sub    $0x28,%rsp
  80004c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80004f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	envid_t who;

	if ((who = fork()) != 0) {
  800053:	48 b8 cc 1e 80 00 00 	movabs $0x801ecc,%rax
  80005a:	00 00 00 
  80005d:	ff d0                	callq  *%rax
  80005f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800062:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800065:	85 c0                	test   %eax,%eax
  800067:	74 4e                	je     8000b7 <umain+0x74>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800069:	8b 5d e8             	mov    -0x18(%rbp),%ebx
  80006c:	48 b8 7a 19 80 00 00 	movabs $0x80197a,%rax
  800073:	00 00 00 
  800076:	ff d0                	callq  *%rax
  800078:	89 da                	mov    %ebx,%edx
  80007a:	89 c6                	mov    %eax,%esi
  80007c:	48 bf e0 3b 80 00 00 	movabs $0x803be0,%rdi
  800083:	00 00 00 
  800086:	b8 00 00 00 00       	mov    $0x0,%eax
  80008b:	48 b9 1f 03 80 00 00 	movabs $0x80031f,%rcx
  800092:	00 00 00 
  800095:	ff d1                	callq  *%rcx
		ipc_send(who, 0, 0, 0);
  800097:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80009a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80009f:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a4:	be 00 00 00 00       	mov    $0x0,%esi
  8000a9:	89 c7                	mov    %eax,%edi
  8000ab:	48 b8 2f 22 80 00 00 	movabs $0x80222f,%rax
  8000b2:	00 00 00 
  8000b5:	ff d0                	callq  *%rax
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  8000b7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 00 00 00       	mov    $0x0,%esi
  8000c5:	48 89 c7             	mov    %rax,%rdi
  8000c8:	48 b8 66 21 80 00 00 	movabs $0x802166,%rax
  8000cf:	00 00 00 
  8000d2:	ff d0                	callq  *%rax
  8000d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000d7:	8b 5d e8             	mov    -0x18(%rbp),%ebx
  8000da:	48 b8 7a 19 80 00 00 	movabs $0x80197a,%rax
  8000e1:	00 00 00 
  8000e4:	ff d0                	callq  *%rax
  8000e6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8000e9:	89 d9                	mov    %ebx,%ecx
  8000eb:	89 c6                	mov    %eax,%esi
  8000ed:	48 bf f6 3b 80 00 00 	movabs $0x803bf6,%rdi
  8000f4:	00 00 00 
  8000f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fc:	49 b8 1f 03 80 00 00 	movabs $0x80031f,%r8
  800103:	00 00 00 
  800106:	41 ff d0             	callq  *%r8
		if (i == 10)
  800109:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
  80010d:	75 02                	jne    800111 <umain+0xce>
			return;
  80010f:	eb 2f                	jmp    800140 <umain+0xfd>
		i++;
  800111:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
		ipc_send(who, i, 0, 0);
  800115:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800118:	8b 75 ec             	mov    -0x14(%rbp),%esi
  80011b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800120:	ba 00 00 00 00       	mov    $0x0,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	48 b8 2f 22 80 00 00 	movabs $0x80222f,%rax
  80012e:	00 00 00 
  800131:	ff d0                	callq  *%rax
		if (i == 10)
  800133:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
  800137:	75 02                	jne    80013b <umain+0xf8>
			return;
  800139:	eb 05                	jmp    800140 <umain+0xfd>
	}
  80013b:	e9 77 ff ff ff       	jmpq   8000b7 <umain+0x74>

}
  800140:	48 83 c4 28          	add    $0x28,%rsp
  800144:	5b                   	pop    %rbx
  800145:	5d                   	pop    %rbp
  800146:	c3                   	retq   

0000000000800147 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	48 83 ec 10          	sub    $0x10,%rsp
  80014f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800152:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800156:	48 b8 7a 19 80 00 00 	movabs $0x80197a,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	48 98                	cltq   
  800164:	25 ff 03 00 00       	and    $0x3ff,%eax
  800169:	48 89 c2             	mov    %rax,%rdx
  80016c:	48 89 d0             	mov    %rdx,%rax
  80016f:	48 c1 e0 03          	shl    $0x3,%rax
  800173:	48 01 d0             	add    %rdx,%rax
  800176:	48 c1 e0 05          	shl    $0x5,%rax
  80017a:	48 89 c2             	mov    %rax,%rdx
  80017d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800184:	00 00 00 
  800187:	48 01 c2             	add    %rax,%rdx
  80018a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800191:	00 00 00 
  800194:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800197:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80019b:	7e 14                	jle    8001b1 <libmain+0x6a>
		binaryname = argv[0];
  80019d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a1:	48 8b 10             	mov    (%rax),%rdx
  8001a4:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001ab:	00 00 00 
  8001ae:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001b8:	48 89 d6             	mov    %rdx,%rsi
  8001bb:	89 c7                	mov    %eax,%edi
  8001bd:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001c4:	00 00 00 
  8001c7:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001c9:	48 b8 d7 01 80 00 00 	movabs $0x8001d7,%rax
  8001d0:	00 00 00 
  8001d3:	ff d0                	callq  *%rax
}
  8001d5:	c9                   	leaveq 
  8001d6:	c3                   	retq   

00000000008001d7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d7:	55                   	push   %rbp
  8001d8:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001db:	48 b8 8a 26 80 00 00 	movabs $0x80268a,%rax
  8001e2:	00 00 00 
  8001e5:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ec:	48 b8 36 19 80 00 00 	movabs $0x801936,%rax
  8001f3:	00 00 00 
  8001f6:	ff d0                	callq  *%rax
}
  8001f8:	5d                   	pop    %rbp
  8001f9:	c3                   	retq   

00000000008001fa <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001fa:	55                   	push   %rbp
  8001fb:	48 89 e5             	mov    %rsp,%rbp
  8001fe:	48 83 ec 10          	sub    $0x10,%rsp
  800202:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800205:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800209:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020d:	8b 00                	mov    (%rax),%eax
  80020f:	8d 48 01             	lea    0x1(%rax),%ecx
  800212:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800216:	89 0a                	mov    %ecx,(%rdx)
  800218:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80021b:	89 d1                	mov    %edx,%ecx
  80021d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800221:	48 98                	cltq   
  800223:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800227:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022b:	8b 00                	mov    (%rax),%eax
  80022d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800232:	75 2c                	jne    800260 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800234:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800238:	8b 00                	mov    (%rax),%eax
  80023a:	48 98                	cltq   
  80023c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800240:	48 83 c2 08          	add    $0x8,%rdx
  800244:	48 89 c6             	mov    %rax,%rsi
  800247:	48 89 d7             	mov    %rdx,%rdi
  80024a:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  800251:	00 00 00 
  800254:	ff d0                	callq  *%rax
		b->idx = 0;
  800256:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80025a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800260:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800264:	8b 40 04             	mov    0x4(%rax),%eax
  800267:	8d 50 01             	lea    0x1(%rax),%edx
  80026a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80026e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800271:	c9                   	leaveq 
  800272:	c3                   	retq   

0000000000800273 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800273:	55                   	push   %rbp
  800274:	48 89 e5             	mov    %rsp,%rbp
  800277:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80027e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800285:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80028c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800293:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80029a:	48 8b 0a             	mov    (%rdx),%rcx
  80029d:	48 89 08             	mov    %rcx,(%rax)
  8002a0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002a4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002a8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002ac:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8002b0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002b7:	00 00 00 
	b.cnt = 0;
  8002ba:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002c1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8002c4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002cb:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002d2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002d9:	48 89 c6             	mov    %rax,%rsi
  8002dc:	48 bf fa 01 80 00 00 	movabs $0x8001fa,%rdi
  8002e3:	00 00 00 
  8002e6:	48 b8 d2 06 80 00 00 	movabs $0x8006d2,%rax
  8002ed:	00 00 00 
  8002f0:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8002f2:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002f8:	48 98                	cltq   
  8002fa:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800301:	48 83 c2 08          	add    $0x8,%rdx
  800305:	48 89 c6             	mov    %rax,%rsi
  800308:	48 89 d7             	mov    %rdx,%rdi
  80030b:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  800312:	00 00 00 
  800315:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800317:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80031d:	c9                   	leaveq 
  80031e:	c3                   	retq   

000000000080031f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80031f:	55                   	push   %rbp
  800320:	48 89 e5             	mov    %rsp,%rbp
  800323:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80032a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800331:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800338:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80033f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800346:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80034d:	84 c0                	test   %al,%al
  80034f:	74 20                	je     800371 <cprintf+0x52>
  800351:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800355:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800359:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80035d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800361:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800365:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800369:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80036d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800371:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800378:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80037f:	00 00 00 
  800382:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800389:	00 00 00 
  80038c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800390:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800397:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80039e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8003a5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003ac:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003b3:	48 8b 0a             	mov    (%rdx),%rcx
  8003b6:	48 89 08             	mov    %rcx,(%rax)
  8003b9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003bd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003c1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003c5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8003c9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003d0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003d7:	48 89 d6             	mov    %rdx,%rsi
  8003da:	48 89 c7             	mov    %rax,%rdi
  8003dd:	48 b8 73 02 80 00 00 	movabs $0x800273,%rax
  8003e4:	00 00 00 
  8003e7:	ff d0                	callq  *%rax
  8003e9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8003ef:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003f5:	c9                   	leaveq 
  8003f6:	c3                   	retq   

00000000008003f7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f7:	55                   	push   %rbp
  8003f8:	48 89 e5             	mov    %rsp,%rbp
  8003fb:	53                   	push   %rbx
  8003fc:	48 83 ec 38          	sub    $0x38,%rsp
  800400:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800404:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800408:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80040c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80040f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800413:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800417:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80041a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80041e:	77 3b                	ja     80045b <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800420:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800423:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800427:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80042a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042e:	ba 00 00 00 00       	mov    $0x0,%edx
  800433:	48 f7 f3             	div    %rbx
  800436:	48 89 c2             	mov    %rax,%rdx
  800439:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80043c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80043f:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800447:	41 89 f9             	mov    %edi,%r9d
  80044a:	48 89 c7             	mov    %rax,%rdi
  80044d:	48 b8 f7 03 80 00 00 	movabs $0x8003f7,%rax
  800454:	00 00 00 
  800457:	ff d0                	callq  *%rax
  800459:	eb 1e                	jmp    800479 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80045b:	eb 12                	jmp    80046f <printnum+0x78>
			putch(padc, putdat);
  80045d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800461:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800468:	48 89 ce             	mov    %rcx,%rsi
  80046b:	89 d7                	mov    %edx,%edi
  80046d:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80046f:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800473:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800477:	7f e4                	jg     80045d <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800479:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80047c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800480:	ba 00 00 00 00       	mov    $0x0,%edx
  800485:	48 f7 f1             	div    %rcx
  800488:	48 89 d0             	mov    %rdx,%rax
  80048b:	48 ba e8 3d 80 00 00 	movabs $0x803de8,%rdx
  800492:	00 00 00 
  800495:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800499:	0f be d0             	movsbl %al,%edx
  80049c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a4:	48 89 ce             	mov    %rcx,%rsi
  8004a7:	89 d7                	mov    %edx,%edi
  8004a9:	ff d0                	callq  *%rax
}
  8004ab:	48 83 c4 38          	add    $0x38,%rsp
  8004af:	5b                   	pop    %rbx
  8004b0:	5d                   	pop    %rbp
  8004b1:	c3                   	retq   

00000000008004b2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004b2:	55                   	push   %rbp
  8004b3:	48 89 e5             	mov    %rsp,%rbp
  8004b6:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004be:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8004c1:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004c5:	7e 52                	jle    800519 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cb:	8b 00                	mov    (%rax),%eax
  8004cd:	83 f8 30             	cmp    $0x30,%eax
  8004d0:	73 24                	jae    8004f6 <getuint+0x44>
  8004d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004de:	8b 00                	mov    (%rax),%eax
  8004e0:	89 c0                	mov    %eax,%eax
  8004e2:	48 01 d0             	add    %rdx,%rax
  8004e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e9:	8b 12                	mov    (%rdx),%edx
  8004eb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f2:	89 0a                	mov    %ecx,(%rdx)
  8004f4:	eb 17                	jmp    80050d <getuint+0x5b>
  8004f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004fe:	48 89 d0             	mov    %rdx,%rax
  800501:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800505:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800509:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80050d:	48 8b 00             	mov    (%rax),%rax
  800510:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800514:	e9 a3 00 00 00       	jmpq   8005bc <getuint+0x10a>
	else if (lflag)
  800519:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80051d:	74 4f                	je     80056e <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80051f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800523:	8b 00                	mov    (%rax),%eax
  800525:	83 f8 30             	cmp    $0x30,%eax
  800528:	73 24                	jae    80054e <getuint+0x9c>
  80052a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800532:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800536:	8b 00                	mov    (%rax),%eax
  800538:	89 c0                	mov    %eax,%eax
  80053a:	48 01 d0             	add    %rdx,%rax
  80053d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800541:	8b 12                	mov    (%rdx),%edx
  800543:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800546:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054a:	89 0a                	mov    %ecx,(%rdx)
  80054c:	eb 17                	jmp    800565 <getuint+0xb3>
  80054e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800552:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800556:	48 89 d0             	mov    %rdx,%rax
  800559:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80055d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800561:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800565:	48 8b 00             	mov    (%rax),%rax
  800568:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80056c:	eb 4e                	jmp    8005bc <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80056e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800572:	8b 00                	mov    (%rax),%eax
  800574:	83 f8 30             	cmp    $0x30,%eax
  800577:	73 24                	jae    80059d <getuint+0xeb>
  800579:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800585:	8b 00                	mov    (%rax),%eax
  800587:	89 c0                	mov    %eax,%eax
  800589:	48 01 d0             	add    %rdx,%rax
  80058c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800590:	8b 12                	mov    (%rdx),%edx
  800592:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800595:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800599:	89 0a                	mov    %ecx,(%rdx)
  80059b:	eb 17                	jmp    8005b4 <getuint+0x102>
  80059d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a5:	48 89 d0             	mov    %rdx,%rax
  8005a8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b4:	8b 00                	mov    (%rax),%eax
  8005b6:	89 c0                	mov    %eax,%eax
  8005b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005c0:	c9                   	leaveq 
  8005c1:	c3                   	retq   

00000000008005c2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005c2:	55                   	push   %rbp
  8005c3:	48 89 e5             	mov    %rsp,%rbp
  8005c6:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005ce:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005d1:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005d5:	7e 52                	jle    800629 <getint+0x67>
		x=va_arg(*ap, long long);
  8005d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005db:	8b 00                	mov    (%rax),%eax
  8005dd:	83 f8 30             	cmp    $0x30,%eax
  8005e0:	73 24                	jae    800606 <getint+0x44>
  8005e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ee:	8b 00                	mov    (%rax),%eax
  8005f0:	89 c0                	mov    %eax,%eax
  8005f2:	48 01 d0             	add    %rdx,%rax
  8005f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f9:	8b 12                	mov    (%rdx),%edx
  8005fb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800602:	89 0a                	mov    %ecx,(%rdx)
  800604:	eb 17                	jmp    80061d <getint+0x5b>
  800606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80060e:	48 89 d0             	mov    %rdx,%rax
  800611:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800615:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800619:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80061d:	48 8b 00             	mov    (%rax),%rax
  800620:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800624:	e9 a3 00 00 00       	jmpq   8006cc <getint+0x10a>
	else if (lflag)
  800629:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80062d:	74 4f                	je     80067e <getint+0xbc>
		x=va_arg(*ap, long);
  80062f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800633:	8b 00                	mov    (%rax),%eax
  800635:	83 f8 30             	cmp    $0x30,%eax
  800638:	73 24                	jae    80065e <getint+0x9c>
  80063a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800642:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800646:	8b 00                	mov    (%rax),%eax
  800648:	89 c0                	mov    %eax,%eax
  80064a:	48 01 d0             	add    %rdx,%rax
  80064d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800651:	8b 12                	mov    (%rdx),%edx
  800653:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800656:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065a:	89 0a                	mov    %ecx,(%rdx)
  80065c:	eb 17                	jmp    800675 <getint+0xb3>
  80065e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800662:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800666:	48 89 d0             	mov    %rdx,%rax
  800669:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80066d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800671:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800675:	48 8b 00             	mov    (%rax),%rax
  800678:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80067c:	eb 4e                	jmp    8006cc <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80067e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800682:	8b 00                	mov    (%rax),%eax
  800684:	83 f8 30             	cmp    $0x30,%eax
  800687:	73 24                	jae    8006ad <getint+0xeb>
  800689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800695:	8b 00                	mov    (%rax),%eax
  800697:	89 c0                	mov    %eax,%eax
  800699:	48 01 d0             	add    %rdx,%rax
  80069c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a0:	8b 12                	mov    (%rdx),%edx
  8006a2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a9:	89 0a                	mov    %ecx,(%rdx)
  8006ab:	eb 17                	jmp    8006c4 <getint+0x102>
  8006ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b5:	48 89 d0             	mov    %rdx,%rax
  8006b8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c4:	8b 00                	mov    (%rax),%eax
  8006c6:	48 98                	cltq   
  8006c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006d0:	c9                   	leaveq 
  8006d1:	c3                   	retq   

00000000008006d2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006d2:	55                   	push   %rbp
  8006d3:	48 89 e5             	mov    %rsp,%rbp
  8006d6:	41 54                	push   %r12
  8006d8:	53                   	push   %rbx
  8006d9:	48 83 ec 60          	sub    $0x60,%rsp
  8006dd:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006e1:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006e5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006e9:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006ed:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006f1:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006f5:	48 8b 0a             	mov    (%rdx),%rcx
  8006f8:	48 89 08             	mov    %rcx,(%rax)
  8006fb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006ff:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800703:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800707:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  80070b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80070f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800713:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800717:	0f b6 00             	movzbl (%rax),%eax
  80071a:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  80071d:	eb 29                	jmp    800748 <vprintfmt+0x76>
			if (ch == '\0')
  80071f:	85 db                	test   %ebx,%ebx
  800721:	0f 84 ad 06 00 00    	je     800dd4 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  800727:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80072b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80072f:	48 89 d6             	mov    %rdx,%rsi
  800732:	89 df                	mov    %ebx,%edi
  800734:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  800736:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80073a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80073e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800742:	0f b6 00             	movzbl (%rax),%eax
  800745:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  800748:	83 fb 25             	cmp    $0x25,%ebx
  80074b:	74 05                	je     800752 <vprintfmt+0x80>
  80074d:	83 fb 1b             	cmp    $0x1b,%ebx
  800750:	75 cd                	jne    80071f <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800752:	83 fb 1b             	cmp    $0x1b,%ebx
  800755:	0f 85 ae 01 00 00    	jne    800909 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  80075b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800762:	00 00 00 
  800765:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  80076b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80076f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800773:	48 89 d6             	mov    %rdx,%rsi
  800776:	89 df                	mov    %ebx,%edi
  800778:	ff d0                	callq  *%rax
			putch('[', putdat);
  80077a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80077e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800782:	48 89 d6             	mov    %rdx,%rsi
  800785:	bf 5b 00 00 00       	mov    $0x5b,%edi
  80078a:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  80078c:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800792:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800797:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80079b:	0f b6 00             	movzbl (%rax),%eax
  80079e:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8007a1:	eb 32                	jmp    8007d5 <vprintfmt+0x103>
					putch(ch, putdat);
  8007a3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007a7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007ab:	48 89 d6             	mov    %rdx,%rsi
  8007ae:	89 df                	mov    %ebx,%edi
  8007b0:	ff d0                	callq  *%rax
					esc_color *= 10;
  8007b2:	44 89 e0             	mov    %r12d,%eax
  8007b5:	c1 e0 02             	shl    $0x2,%eax
  8007b8:	44 01 e0             	add    %r12d,%eax
  8007bb:	01 c0                	add    %eax,%eax
  8007bd:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  8007c0:	8d 43 d0             	lea    -0x30(%rbx),%eax
  8007c3:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  8007c6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8007cb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007cf:	0f b6 00             	movzbl (%rax),%eax
  8007d2:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8007d5:	83 fb 3b             	cmp    $0x3b,%ebx
  8007d8:	74 05                	je     8007df <vprintfmt+0x10d>
  8007da:	83 fb 6d             	cmp    $0x6d,%ebx
  8007dd:	75 c4                	jne    8007a3 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  8007df:	45 85 e4             	test   %r12d,%r12d
  8007e2:	75 15                	jne    8007f9 <vprintfmt+0x127>
					color_flag = 0x07;
  8007e4:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8007eb:	00 00 00 
  8007ee:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  8007f4:	e9 dc 00 00 00       	jmpq   8008d5 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  8007f9:	41 83 fc 1d          	cmp    $0x1d,%r12d
  8007fd:	7e 69                	jle    800868 <vprintfmt+0x196>
  8007ff:	41 83 fc 25          	cmp    $0x25,%r12d
  800803:	7f 63                	jg     800868 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800805:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80080c:	00 00 00 
  80080f:	8b 00                	mov    (%rax),%eax
  800811:	25 f8 00 00 00       	and    $0xf8,%eax
  800816:	89 c2                	mov    %eax,%edx
  800818:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80081f:	00 00 00 
  800822:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800824:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800828:	44 89 e0             	mov    %r12d,%eax
  80082b:	83 e0 04             	and    $0x4,%eax
  80082e:	c1 f8 02             	sar    $0x2,%eax
  800831:	89 c2                	mov    %eax,%edx
  800833:	44 89 e0             	mov    %r12d,%eax
  800836:	83 e0 02             	and    $0x2,%eax
  800839:	09 c2                	or     %eax,%edx
  80083b:	44 89 e0             	mov    %r12d,%eax
  80083e:	83 e0 01             	and    $0x1,%eax
  800841:	c1 e0 02             	shl    $0x2,%eax
  800844:	09 c2                	or     %eax,%edx
  800846:	41 89 d4             	mov    %edx,%r12d
  800849:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800850:	00 00 00 
  800853:	8b 00                	mov    (%rax),%eax
  800855:	44 89 e2             	mov    %r12d,%edx
  800858:	09 c2                	or     %eax,%edx
  80085a:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800861:	00 00 00 
  800864:	89 10                	mov    %edx,(%rax)
  800866:	eb 6d                	jmp    8008d5 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800868:	41 83 fc 27          	cmp    $0x27,%r12d
  80086c:	7e 67                	jle    8008d5 <vprintfmt+0x203>
  80086e:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800872:	7f 61                	jg     8008d5 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800874:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80087b:	00 00 00 
  80087e:	8b 00                	mov    (%rax),%eax
  800880:	25 8f 00 00 00       	and    $0x8f,%eax
  800885:	89 c2                	mov    %eax,%edx
  800887:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80088e:	00 00 00 
  800891:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800893:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800897:	44 89 e0             	mov    %r12d,%eax
  80089a:	83 e0 04             	and    $0x4,%eax
  80089d:	c1 f8 02             	sar    $0x2,%eax
  8008a0:	89 c2                	mov    %eax,%edx
  8008a2:	44 89 e0             	mov    %r12d,%eax
  8008a5:	83 e0 02             	and    $0x2,%eax
  8008a8:	09 c2                	or     %eax,%edx
  8008aa:	44 89 e0             	mov    %r12d,%eax
  8008ad:	83 e0 01             	and    $0x1,%eax
  8008b0:	c1 e0 06             	shl    $0x6,%eax
  8008b3:	09 c2                	or     %eax,%edx
  8008b5:	41 89 d4             	mov    %edx,%r12d
  8008b8:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8008bf:	00 00 00 
  8008c2:	8b 00                	mov    (%rax),%eax
  8008c4:	44 89 e2             	mov    %r12d,%edx
  8008c7:	09 c2                	or     %eax,%edx
  8008c9:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8008d0:	00 00 00 
  8008d3:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  8008d5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008d9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008dd:	48 89 d6             	mov    %rdx,%rsi
  8008e0:	89 df                	mov    %ebx,%edi
  8008e2:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  8008e4:	83 fb 6d             	cmp    $0x6d,%ebx
  8008e7:	75 1b                	jne    800904 <vprintfmt+0x232>
					fmt ++;
  8008e9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  8008ee:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  8008ef:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8008f6:	00 00 00 
  8008f9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  8008ff:	e9 cb 04 00 00       	jmpq   800dcf <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800904:	e9 83 fe ff ff       	jmpq   80078c <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800909:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80090d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800914:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80091b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800922:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800929:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80092d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800931:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800935:	0f b6 00             	movzbl (%rax),%eax
  800938:	0f b6 d8             	movzbl %al,%ebx
  80093b:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80093e:	83 f8 55             	cmp    $0x55,%eax
  800941:	0f 87 5a 04 00 00    	ja     800da1 <vprintfmt+0x6cf>
  800947:	89 c0                	mov    %eax,%eax
  800949:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800950:	00 
  800951:	48 b8 10 3e 80 00 00 	movabs $0x803e10,%rax
  800958:	00 00 00 
  80095b:	48 01 d0             	add    %rdx,%rax
  80095e:	48 8b 00             	mov    (%rax),%rax
  800961:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800963:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800967:	eb c0                	jmp    800929 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800969:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80096d:	eb ba                	jmp    800929 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80096f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800976:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800979:	89 d0                	mov    %edx,%eax
  80097b:	c1 e0 02             	shl    $0x2,%eax
  80097e:	01 d0                	add    %edx,%eax
  800980:	01 c0                	add    %eax,%eax
  800982:	01 d8                	add    %ebx,%eax
  800984:	83 e8 30             	sub    $0x30,%eax
  800987:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80098a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80098e:	0f b6 00             	movzbl (%rax),%eax
  800991:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800994:	83 fb 2f             	cmp    $0x2f,%ebx
  800997:	7e 0c                	jle    8009a5 <vprintfmt+0x2d3>
  800999:	83 fb 39             	cmp    $0x39,%ebx
  80099c:	7f 07                	jg     8009a5 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009a3:	eb d1                	jmp    800976 <vprintfmt+0x2a4>
			goto process_precision;
  8009a5:	eb 58                	jmp    8009ff <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  8009a7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009aa:	83 f8 30             	cmp    $0x30,%eax
  8009ad:	73 17                	jae    8009c6 <vprintfmt+0x2f4>
  8009af:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009b3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b6:	89 c0                	mov    %eax,%eax
  8009b8:	48 01 d0             	add    %rdx,%rax
  8009bb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009be:	83 c2 08             	add    $0x8,%edx
  8009c1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009c4:	eb 0f                	jmp    8009d5 <vprintfmt+0x303>
  8009c6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ca:	48 89 d0             	mov    %rdx,%rax
  8009cd:	48 83 c2 08          	add    $0x8,%rdx
  8009d1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009d5:	8b 00                	mov    (%rax),%eax
  8009d7:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009da:	eb 23                	jmp    8009ff <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  8009dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009e0:	79 0c                	jns    8009ee <vprintfmt+0x31c>
				width = 0;
  8009e2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009e9:	e9 3b ff ff ff       	jmpq   800929 <vprintfmt+0x257>
  8009ee:	e9 36 ff ff ff       	jmpq   800929 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  8009f3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009fa:	e9 2a ff ff ff       	jmpq   800929 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  8009ff:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a03:	79 12                	jns    800a17 <vprintfmt+0x345>
				width = precision, precision = -1;
  800a05:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a08:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a0b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a12:	e9 12 ff ff ff       	jmpq   800929 <vprintfmt+0x257>
  800a17:	e9 0d ff ff ff       	jmpq   800929 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a20:	e9 04 ff ff ff       	jmpq   800929 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a28:	83 f8 30             	cmp    $0x30,%eax
  800a2b:	73 17                	jae    800a44 <vprintfmt+0x372>
  800a2d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a34:	89 c0                	mov    %eax,%eax
  800a36:	48 01 d0             	add    %rdx,%rax
  800a39:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a3c:	83 c2 08             	add    $0x8,%edx
  800a3f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a42:	eb 0f                	jmp    800a53 <vprintfmt+0x381>
  800a44:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a48:	48 89 d0             	mov    %rdx,%rax
  800a4b:	48 83 c2 08          	add    $0x8,%rdx
  800a4f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a53:	8b 10                	mov    (%rax),%edx
  800a55:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5d:	48 89 ce             	mov    %rcx,%rsi
  800a60:	89 d7                	mov    %edx,%edi
  800a62:	ff d0                	callq  *%rax
			break;
  800a64:	e9 66 03 00 00       	jmpq   800dcf <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800a69:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6c:	83 f8 30             	cmp    $0x30,%eax
  800a6f:	73 17                	jae    800a88 <vprintfmt+0x3b6>
  800a71:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a75:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a78:	89 c0                	mov    %eax,%eax
  800a7a:	48 01 d0             	add    %rdx,%rax
  800a7d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a80:	83 c2 08             	add    $0x8,%edx
  800a83:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a86:	eb 0f                	jmp    800a97 <vprintfmt+0x3c5>
  800a88:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a8c:	48 89 d0             	mov    %rdx,%rax
  800a8f:	48 83 c2 08          	add    $0x8,%rdx
  800a93:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a97:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a99:	85 db                	test   %ebx,%ebx
  800a9b:	79 02                	jns    800a9f <vprintfmt+0x3cd>
				err = -err;
  800a9d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a9f:	83 fb 10             	cmp    $0x10,%ebx
  800aa2:	7f 16                	jg     800aba <vprintfmt+0x3e8>
  800aa4:	48 b8 60 3d 80 00 00 	movabs $0x803d60,%rax
  800aab:	00 00 00 
  800aae:	48 63 d3             	movslq %ebx,%rdx
  800ab1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ab5:	4d 85 e4             	test   %r12,%r12
  800ab8:	75 2e                	jne    800ae8 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800aba:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800abe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac2:	89 d9                	mov    %ebx,%ecx
  800ac4:	48 ba f9 3d 80 00 00 	movabs $0x803df9,%rdx
  800acb:	00 00 00 
  800ace:	48 89 c7             	mov    %rax,%rdi
  800ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad6:	49 b8 dd 0d 80 00 00 	movabs $0x800ddd,%r8
  800add:	00 00 00 
  800ae0:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ae3:	e9 e7 02 00 00       	jmpq   800dcf <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af0:	4c 89 e1             	mov    %r12,%rcx
  800af3:	48 ba 02 3e 80 00 00 	movabs $0x803e02,%rdx
  800afa:	00 00 00 
  800afd:	48 89 c7             	mov    %rax,%rdi
  800b00:	b8 00 00 00 00       	mov    $0x0,%eax
  800b05:	49 b8 dd 0d 80 00 00 	movabs $0x800ddd,%r8
  800b0c:	00 00 00 
  800b0f:	41 ff d0             	callq  *%r8
			break;
  800b12:	e9 b8 02 00 00       	jmpq   800dcf <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b17:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1a:	83 f8 30             	cmp    $0x30,%eax
  800b1d:	73 17                	jae    800b36 <vprintfmt+0x464>
  800b1f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b23:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b26:	89 c0                	mov    %eax,%eax
  800b28:	48 01 d0             	add    %rdx,%rax
  800b2b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b2e:	83 c2 08             	add    $0x8,%edx
  800b31:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b34:	eb 0f                	jmp    800b45 <vprintfmt+0x473>
  800b36:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b3a:	48 89 d0             	mov    %rdx,%rax
  800b3d:	48 83 c2 08          	add    $0x8,%rdx
  800b41:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b45:	4c 8b 20             	mov    (%rax),%r12
  800b48:	4d 85 e4             	test   %r12,%r12
  800b4b:	75 0a                	jne    800b57 <vprintfmt+0x485>
				p = "(null)";
  800b4d:	49 bc 05 3e 80 00 00 	movabs $0x803e05,%r12
  800b54:	00 00 00 
			if (width > 0 && padc != '-')
  800b57:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b5b:	7e 3f                	jle    800b9c <vprintfmt+0x4ca>
  800b5d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b61:	74 39                	je     800b9c <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b63:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b66:	48 98                	cltq   
  800b68:	48 89 c6             	mov    %rax,%rsi
  800b6b:	4c 89 e7             	mov    %r12,%rdi
  800b6e:	48 b8 89 10 80 00 00 	movabs $0x801089,%rax
  800b75:	00 00 00 
  800b78:	ff d0                	callq  *%rax
  800b7a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b7d:	eb 17                	jmp    800b96 <vprintfmt+0x4c4>
					putch(padc, putdat);
  800b7f:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b83:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b87:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8b:	48 89 ce             	mov    %rcx,%rsi
  800b8e:	89 d7                	mov    %edx,%edi
  800b90:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b92:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b96:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b9a:	7f e3                	jg     800b7f <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9c:	eb 37                	jmp    800bd5 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800b9e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ba2:	74 1e                	je     800bc2 <vprintfmt+0x4f0>
  800ba4:	83 fb 1f             	cmp    $0x1f,%ebx
  800ba7:	7e 05                	jle    800bae <vprintfmt+0x4dc>
  800ba9:	83 fb 7e             	cmp    $0x7e,%ebx
  800bac:	7e 14                	jle    800bc2 <vprintfmt+0x4f0>
					putch('?', putdat);
  800bae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb6:	48 89 d6             	mov    %rdx,%rsi
  800bb9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bbe:	ff d0                	callq  *%rax
  800bc0:	eb 0f                	jmp    800bd1 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800bc2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bca:	48 89 d6             	mov    %rdx,%rsi
  800bcd:	89 df                	mov    %ebx,%edi
  800bcf:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bd1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bd5:	4c 89 e0             	mov    %r12,%rax
  800bd8:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bdc:	0f b6 00             	movzbl (%rax),%eax
  800bdf:	0f be d8             	movsbl %al,%ebx
  800be2:	85 db                	test   %ebx,%ebx
  800be4:	74 10                	je     800bf6 <vprintfmt+0x524>
  800be6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bea:	78 b2                	js     800b9e <vprintfmt+0x4cc>
  800bec:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bf0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bf4:	79 a8                	jns    800b9e <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf6:	eb 16                	jmp    800c0e <vprintfmt+0x53c>
				putch(' ', putdat);
  800bf8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c00:	48 89 d6             	mov    %rdx,%rsi
  800c03:	bf 20 00 00 00       	mov    $0x20,%edi
  800c08:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c0a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c0e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c12:	7f e4                	jg     800bf8 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800c14:	e9 b6 01 00 00       	jmpq   800dcf <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c19:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c1d:	be 03 00 00 00       	mov    $0x3,%esi
  800c22:	48 89 c7             	mov    %rax,%rdi
  800c25:	48 b8 c2 05 80 00 00 	movabs $0x8005c2,%rax
  800c2c:	00 00 00 
  800c2f:	ff d0                	callq  *%rax
  800c31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c39:	48 85 c0             	test   %rax,%rax
  800c3c:	79 1d                	jns    800c5b <vprintfmt+0x589>
				putch('-', putdat);
  800c3e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c46:	48 89 d6             	mov    %rdx,%rsi
  800c49:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c4e:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c54:	48 f7 d8             	neg    %rax
  800c57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c5b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c62:	e9 fb 00 00 00       	jmpq   800d62 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c67:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c6b:	be 03 00 00 00       	mov    $0x3,%esi
  800c70:	48 89 c7             	mov    %rax,%rdi
  800c73:	48 b8 b2 04 80 00 00 	movabs $0x8004b2,%rax
  800c7a:	00 00 00 
  800c7d:	ff d0                	callq  *%rax
  800c7f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c83:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c8a:	e9 d3 00 00 00       	jmpq   800d62 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800c8f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c93:	be 03 00 00 00       	mov    $0x3,%esi
  800c98:	48 89 c7             	mov    %rax,%rdi
  800c9b:	48 b8 c2 05 80 00 00 	movabs $0x8005c2,%rax
  800ca2:	00 00 00 
  800ca5:	ff d0                	callq  *%rax
  800ca7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800cab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800caf:	48 85 c0             	test   %rax,%rax
  800cb2:	79 1d                	jns    800cd1 <vprintfmt+0x5ff>
				putch('-', putdat);
  800cb4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cb8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cbc:	48 89 d6             	mov    %rdx,%rsi
  800cbf:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800cc4:	ff d0                	callq  *%rax
				num = -(long long) num;
  800cc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cca:	48 f7 d8             	neg    %rax
  800ccd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800cd1:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800cd8:	e9 85 00 00 00       	jmpq   800d62 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800cdd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce5:	48 89 d6             	mov    %rdx,%rsi
  800ce8:	bf 30 00 00 00       	mov    $0x30,%edi
  800ced:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cef:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf7:	48 89 d6             	mov    %rdx,%rsi
  800cfa:	bf 78 00 00 00       	mov    $0x78,%edi
  800cff:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d04:	83 f8 30             	cmp    $0x30,%eax
  800d07:	73 17                	jae    800d20 <vprintfmt+0x64e>
  800d09:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d0d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d10:	89 c0                	mov    %eax,%eax
  800d12:	48 01 d0             	add    %rdx,%rax
  800d15:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d18:	83 c2 08             	add    $0x8,%edx
  800d1b:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d1e:	eb 0f                	jmp    800d2f <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800d20:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d24:	48 89 d0             	mov    %rdx,%rax
  800d27:	48 83 c2 08          	add    $0x8,%rdx
  800d2b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d2f:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d32:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d36:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d3d:	eb 23                	jmp    800d62 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d3f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d43:	be 03 00 00 00       	mov    $0x3,%esi
  800d48:	48 89 c7             	mov    %rax,%rdi
  800d4b:	48 b8 b2 04 80 00 00 	movabs $0x8004b2,%rax
  800d52:	00 00 00 
  800d55:	ff d0                	callq  *%rax
  800d57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d5b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d62:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d67:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d6a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d6d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d71:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d75:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d79:	45 89 c1             	mov    %r8d,%r9d
  800d7c:	41 89 f8             	mov    %edi,%r8d
  800d7f:	48 89 c7             	mov    %rax,%rdi
  800d82:	48 b8 f7 03 80 00 00 	movabs $0x8003f7,%rax
  800d89:	00 00 00 
  800d8c:	ff d0                	callq  *%rax
			break;
  800d8e:	eb 3f                	jmp    800dcf <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d90:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d94:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d98:	48 89 d6             	mov    %rdx,%rsi
  800d9b:	89 df                	mov    %ebx,%edi
  800d9d:	ff d0                	callq  *%rax
			break;
  800d9f:	eb 2e                	jmp    800dcf <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800da1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800da5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800da9:	48 89 d6             	mov    %rdx,%rsi
  800dac:	bf 25 00 00 00       	mov    $0x25,%edi
  800db1:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800db3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800db8:	eb 05                	jmp    800dbf <vprintfmt+0x6ed>
  800dba:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dbf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dc3:	48 83 e8 01          	sub    $0x1,%rax
  800dc7:	0f b6 00             	movzbl (%rax),%eax
  800dca:	3c 25                	cmp    $0x25,%al
  800dcc:	75 ec                	jne    800dba <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  800dce:	90                   	nop
		}
	}
  800dcf:	e9 37 f9 ff ff       	jmpq   80070b <vprintfmt+0x39>
    va_end(aq);
}
  800dd4:	48 83 c4 60          	add    $0x60,%rsp
  800dd8:	5b                   	pop    %rbx
  800dd9:	41 5c                	pop    %r12
  800ddb:	5d                   	pop    %rbp
  800ddc:	c3                   	retq   

0000000000800ddd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ddd:	55                   	push   %rbp
  800dde:	48 89 e5             	mov    %rsp,%rbp
  800de1:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800de8:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800def:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800df6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dfd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e04:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e0b:	84 c0                	test   %al,%al
  800e0d:	74 20                	je     800e2f <printfmt+0x52>
  800e0f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e13:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e17:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e1b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e1f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e23:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e27:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e2b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e2f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e36:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e3d:	00 00 00 
  800e40:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e47:	00 00 00 
  800e4a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e4e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e55:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e5c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e63:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e6a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e71:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e78:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e7f:	48 89 c7             	mov    %rax,%rdi
  800e82:	48 b8 d2 06 80 00 00 	movabs $0x8006d2,%rax
  800e89:	00 00 00 
  800e8c:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e8e:	c9                   	leaveq 
  800e8f:	c3                   	retq   

0000000000800e90 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e90:	55                   	push   %rbp
  800e91:	48 89 e5             	mov    %rsp,%rbp
  800e94:	48 83 ec 10          	sub    $0x10,%rsp
  800e98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea3:	8b 40 10             	mov    0x10(%rax),%eax
  800ea6:	8d 50 01             	lea    0x1(%rax),%edx
  800ea9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ead:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800eb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb4:	48 8b 10             	mov    (%rax),%rdx
  800eb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ebb:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ebf:	48 39 c2             	cmp    %rax,%rdx
  800ec2:	73 17                	jae    800edb <sprintputch+0x4b>
		*b->buf++ = ch;
  800ec4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ec8:	48 8b 00             	mov    (%rax),%rax
  800ecb:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ecf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ed3:	48 89 0a             	mov    %rcx,(%rdx)
  800ed6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ed9:	88 10                	mov    %dl,(%rax)
}
  800edb:	c9                   	leaveq 
  800edc:	c3                   	retq   

0000000000800edd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800edd:	55                   	push   %rbp
  800ede:	48 89 e5             	mov    %rsp,%rbp
  800ee1:	48 83 ec 50          	sub    $0x50,%rsp
  800ee5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ee9:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800eec:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ef0:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ef4:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ef8:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800efc:	48 8b 0a             	mov    (%rdx),%rcx
  800eff:	48 89 08             	mov    %rcx,(%rax)
  800f02:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f06:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f0a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f0e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f12:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f16:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f1a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f1d:	48 98                	cltq   
  800f1f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f23:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f27:	48 01 d0             	add    %rdx,%rax
  800f2a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f2e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f35:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f3a:	74 06                	je     800f42 <vsnprintf+0x65>
  800f3c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f40:	7f 07                	jg     800f49 <vsnprintf+0x6c>
		return -E_INVAL;
  800f42:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f47:	eb 2f                	jmp    800f78 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f49:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f4d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f51:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f55:	48 89 c6             	mov    %rax,%rsi
  800f58:	48 bf 90 0e 80 00 00 	movabs $0x800e90,%rdi
  800f5f:	00 00 00 
  800f62:	48 b8 d2 06 80 00 00 	movabs $0x8006d2,%rax
  800f69:	00 00 00 
  800f6c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f6e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f72:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f75:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f78:	c9                   	leaveq 
  800f79:	c3                   	retq   

0000000000800f7a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f7a:	55                   	push   %rbp
  800f7b:	48 89 e5             	mov    %rsp,%rbp
  800f7e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f85:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f8c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f92:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f99:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fa0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fa7:	84 c0                	test   %al,%al
  800fa9:	74 20                	je     800fcb <snprintf+0x51>
  800fab:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800faf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fb3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fb7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fbb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fbf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fc3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fc7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fcb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fd2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fd9:	00 00 00 
  800fdc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fe3:	00 00 00 
  800fe6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fea:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ff1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ff8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fff:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801006:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80100d:	48 8b 0a             	mov    (%rdx),%rcx
  801010:	48 89 08             	mov    %rcx,(%rax)
  801013:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801017:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80101b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80101f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801023:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80102a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801031:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801037:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80103e:	48 89 c7             	mov    %rax,%rdi
  801041:	48 b8 dd 0e 80 00 00 	movabs $0x800edd,%rax
  801048:	00 00 00 
  80104b:	ff d0                	callq  *%rax
  80104d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801053:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801059:	c9                   	leaveq 
  80105a:	c3                   	retq   

000000000080105b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80105b:	55                   	push   %rbp
  80105c:	48 89 e5             	mov    %rsp,%rbp
  80105f:	48 83 ec 18          	sub    $0x18,%rsp
  801063:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801067:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80106e:	eb 09                	jmp    801079 <strlen+0x1e>
		n++;
  801070:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801074:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801079:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107d:	0f b6 00             	movzbl (%rax),%eax
  801080:	84 c0                	test   %al,%al
  801082:	75 ec                	jne    801070 <strlen+0x15>
		n++;
	return n;
  801084:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801087:	c9                   	leaveq 
  801088:	c3                   	retq   

0000000000801089 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801089:	55                   	push   %rbp
  80108a:	48 89 e5             	mov    %rsp,%rbp
  80108d:	48 83 ec 20          	sub    $0x20,%rsp
  801091:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801095:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801099:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010a0:	eb 0e                	jmp    8010b0 <strnlen+0x27>
		n++;
  8010a2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010a6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010ab:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010b0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010b5:	74 0b                	je     8010c2 <strnlen+0x39>
  8010b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bb:	0f b6 00             	movzbl (%rax),%eax
  8010be:	84 c0                	test   %al,%al
  8010c0:	75 e0                	jne    8010a2 <strnlen+0x19>
		n++;
	return n;
  8010c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010c5:	c9                   	leaveq 
  8010c6:	c3                   	retq   

00000000008010c7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010c7:	55                   	push   %rbp
  8010c8:	48 89 e5             	mov    %rsp,%rbp
  8010cb:	48 83 ec 20          	sub    $0x20,%rsp
  8010cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010db:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010df:	90                   	nop
  8010e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010e8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010ec:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010f0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010f4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010f8:	0f b6 12             	movzbl (%rdx),%edx
  8010fb:	88 10                	mov    %dl,(%rax)
  8010fd:	0f b6 00             	movzbl (%rax),%eax
  801100:	84 c0                	test   %al,%al
  801102:	75 dc                	jne    8010e0 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801104:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801108:	c9                   	leaveq 
  801109:	c3                   	retq   

000000000080110a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80110a:	55                   	push   %rbp
  80110b:	48 89 e5             	mov    %rsp,%rbp
  80110e:	48 83 ec 20          	sub    $0x20,%rsp
  801112:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801116:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80111a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111e:	48 89 c7             	mov    %rax,%rdi
  801121:	48 b8 5b 10 80 00 00 	movabs $0x80105b,%rax
  801128:	00 00 00 
  80112b:	ff d0                	callq  *%rax
  80112d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801130:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801133:	48 63 d0             	movslq %eax,%rdx
  801136:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113a:	48 01 c2             	add    %rax,%rdx
  80113d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801141:	48 89 c6             	mov    %rax,%rsi
  801144:	48 89 d7             	mov    %rdx,%rdi
  801147:	48 b8 c7 10 80 00 00 	movabs $0x8010c7,%rax
  80114e:	00 00 00 
  801151:	ff d0                	callq  *%rax
	return dst;
  801153:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801157:	c9                   	leaveq 
  801158:	c3                   	retq   

0000000000801159 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801159:	55                   	push   %rbp
  80115a:	48 89 e5             	mov    %rsp,%rbp
  80115d:	48 83 ec 28          	sub    $0x28,%rsp
  801161:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801165:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801169:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80116d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801171:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801175:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80117c:	00 
  80117d:	eb 2a                	jmp    8011a9 <strncpy+0x50>
		*dst++ = *src;
  80117f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801183:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801187:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80118b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80118f:	0f b6 12             	movzbl (%rdx),%edx
  801192:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801194:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801198:	0f b6 00             	movzbl (%rax),%eax
  80119b:	84 c0                	test   %al,%al
  80119d:	74 05                	je     8011a4 <strncpy+0x4b>
			src++;
  80119f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ad:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011b1:	72 cc                	jb     80117f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011b7:	c9                   	leaveq 
  8011b8:	c3                   	retq   

00000000008011b9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011b9:	55                   	push   %rbp
  8011ba:	48 89 e5             	mov    %rsp,%rbp
  8011bd:	48 83 ec 28          	sub    $0x28,%rsp
  8011c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011d5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011da:	74 3d                	je     801219 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011dc:	eb 1d                	jmp    8011fb <strlcpy+0x42>
			*dst++ = *src++;
  8011de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011ea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011ee:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011f2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011f6:	0f b6 12             	movzbl (%rdx),%edx
  8011f9:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011fb:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801200:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801205:	74 0b                	je     801212 <strlcpy+0x59>
  801207:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80120b:	0f b6 00             	movzbl (%rax),%eax
  80120e:	84 c0                	test   %al,%al
  801210:	75 cc                	jne    8011de <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801212:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801216:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801219:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80121d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801221:	48 29 c2             	sub    %rax,%rdx
  801224:	48 89 d0             	mov    %rdx,%rax
}
  801227:	c9                   	leaveq 
  801228:	c3                   	retq   

0000000000801229 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801229:	55                   	push   %rbp
  80122a:	48 89 e5             	mov    %rsp,%rbp
  80122d:	48 83 ec 10          	sub    $0x10,%rsp
  801231:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801235:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801239:	eb 0a                	jmp    801245 <strcmp+0x1c>
		p++, q++;
  80123b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801240:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801245:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801249:	0f b6 00             	movzbl (%rax),%eax
  80124c:	84 c0                	test   %al,%al
  80124e:	74 12                	je     801262 <strcmp+0x39>
  801250:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801254:	0f b6 10             	movzbl (%rax),%edx
  801257:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80125b:	0f b6 00             	movzbl (%rax),%eax
  80125e:	38 c2                	cmp    %al,%dl
  801260:	74 d9                	je     80123b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801266:	0f b6 00             	movzbl (%rax),%eax
  801269:	0f b6 d0             	movzbl %al,%edx
  80126c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801270:	0f b6 00             	movzbl (%rax),%eax
  801273:	0f b6 c0             	movzbl %al,%eax
  801276:	29 c2                	sub    %eax,%edx
  801278:	89 d0                	mov    %edx,%eax
}
  80127a:	c9                   	leaveq 
  80127b:	c3                   	retq   

000000000080127c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80127c:	55                   	push   %rbp
  80127d:	48 89 e5             	mov    %rsp,%rbp
  801280:	48 83 ec 18          	sub    $0x18,%rsp
  801284:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801288:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80128c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801290:	eb 0f                	jmp    8012a1 <strncmp+0x25>
		n--, p++, q++;
  801292:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801297:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80129c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012a1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012a6:	74 1d                	je     8012c5 <strncmp+0x49>
  8012a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ac:	0f b6 00             	movzbl (%rax),%eax
  8012af:	84 c0                	test   %al,%al
  8012b1:	74 12                	je     8012c5 <strncmp+0x49>
  8012b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b7:	0f b6 10             	movzbl (%rax),%edx
  8012ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012be:	0f b6 00             	movzbl (%rax),%eax
  8012c1:	38 c2                	cmp    %al,%dl
  8012c3:	74 cd                	je     801292 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012c5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012ca:	75 07                	jne    8012d3 <strncmp+0x57>
		return 0;
  8012cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d1:	eb 18                	jmp    8012eb <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d7:	0f b6 00             	movzbl (%rax),%eax
  8012da:	0f b6 d0             	movzbl %al,%edx
  8012dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e1:	0f b6 00             	movzbl (%rax),%eax
  8012e4:	0f b6 c0             	movzbl %al,%eax
  8012e7:	29 c2                	sub    %eax,%edx
  8012e9:	89 d0                	mov    %edx,%eax
}
  8012eb:	c9                   	leaveq 
  8012ec:	c3                   	retq   

00000000008012ed <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012ed:	55                   	push   %rbp
  8012ee:	48 89 e5             	mov    %rsp,%rbp
  8012f1:	48 83 ec 0c          	sub    $0xc,%rsp
  8012f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012f9:	89 f0                	mov    %esi,%eax
  8012fb:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012fe:	eb 17                	jmp    801317 <strchr+0x2a>
		if (*s == c)
  801300:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801304:	0f b6 00             	movzbl (%rax),%eax
  801307:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80130a:	75 06                	jne    801312 <strchr+0x25>
			return (char *) s;
  80130c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801310:	eb 15                	jmp    801327 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801312:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801317:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131b:	0f b6 00             	movzbl (%rax),%eax
  80131e:	84 c0                	test   %al,%al
  801320:	75 de                	jne    801300 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801322:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801327:	c9                   	leaveq 
  801328:	c3                   	retq   

0000000000801329 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801329:	55                   	push   %rbp
  80132a:	48 89 e5             	mov    %rsp,%rbp
  80132d:	48 83 ec 0c          	sub    $0xc,%rsp
  801331:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801335:	89 f0                	mov    %esi,%eax
  801337:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80133a:	eb 13                	jmp    80134f <strfind+0x26>
		if (*s == c)
  80133c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801340:	0f b6 00             	movzbl (%rax),%eax
  801343:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801346:	75 02                	jne    80134a <strfind+0x21>
			break;
  801348:	eb 10                	jmp    80135a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80134a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80134f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801353:	0f b6 00             	movzbl (%rax),%eax
  801356:	84 c0                	test   %al,%al
  801358:	75 e2                	jne    80133c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80135a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80135e:	c9                   	leaveq 
  80135f:	c3                   	retq   

0000000000801360 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801360:	55                   	push   %rbp
  801361:	48 89 e5             	mov    %rsp,%rbp
  801364:	48 83 ec 18          	sub    $0x18,%rsp
  801368:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80136c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80136f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801373:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801378:	75 06                	jne    801380 <memset+0x20>
		return v;
  80137a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137e:	eb 69                	jmp    8013e9 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801380:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801384:	83 e0 03             	and    $0x3,%eax
  801387:	48 85 c0             	test   %rax,%rax
  80138a:	75 48                	jne    8013d4 <memset+0x74>
  80138c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801390:	83 e0 03             	and    $0x3,%eax
  801393:	48 85 c0             	test   %rax,%rax
  801396:	75 3c                	jne    8013d4 <memset+0x74>
		c &= 0xFF;
  801398:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80139f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013a2:	c1 e0 18             	shl    $0x18,%eax
  8013a5:	89 c2                	mov    %eax,%edx
  8013a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013aa:	c1 e0 10             	shl    $0x10,%eax
  8013ad:	09 c2                	or     %eax,%edx
  8013af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b2:	c1 e0 08             	shl    $0x8,%eax
  8013b5:	09 d0                	or     %edx,%eax
  8013b7:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8013ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013be:	48 c1 e8 02          	shr    $0x2,%rax
  8013c2:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013c5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013cc:	48 89 d7             	mov    %rdx,%rdi
  8013cf:	fc                   	cld    
  8013d0:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013d2:	eb 11                	jmp    8013e5 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013db:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013df:	48 89 d7             	mov    %rdx,%rdi
  8013e2:	fc                   	cld    
  8013e3:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8013e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013e9:	c9                   	leaveq 
  8013ea:	c3                   	retq   

00000000008013eb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013eb:	55                   	push   %rbp
  8013ec:	48 89 e5             	mov    %rsp,%rbp
  8013ef:	48 83 ec 28          	sub    $0x28,%rsp
  8013f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801403:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801407:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80140f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801413:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801417:	0f 83 88 00 00 00    	jae    8014a5 <memmove+0xba>
  80141d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801421:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801425:	48 01 d0             	add    %rdx,%rax
  801428:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80142c:	76 77                	jbe    8014a5 <memmove+0xba>
		s += n;
  80142e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801432:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801436:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80143e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801442:	83 e0 03             	and    $0x3,%eax
  801445:	48 85 c0             	test   %rax,%rax
  801448:	75 3b                	jne    801485 <memmove+0x9a>
  80144a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80144e:	83 e0 03             	and    $0x3,%eax
  801451:	48 85 c0             	test   %rax,%rax
  801454:	75 2f                	jne    801485 <memmove+0x9a>
  801456:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145a:	83 e0 03             	and    $0x3,%eax
  80145d:	48 85 c0             	test   %rax,%rax
  801460:	75 23                	jne    801485 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801462:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801466:	48 83 e8 04          	sub    $0x4,%rax
  80146a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80146e:	48 83 ea 04          	sub    $0x4,%rdx
  801472:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801476:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80147a:	48 89 c7             	mov    %rax,%rdi
  80147d:	48 89 d6             	mov    %rdx,%rsi
  801480:	fd                   	std    
  801481:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801483:	eb 1d                	jmp    8014a2 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801485:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801489:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80148d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801491:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801495:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801499:	48 89 d7             	mov    %rdx,%rdi
  80149c:	48 89 c1             	mov    %rax,%rcx
  80149f:	fd                   	std    
  8014a0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014a2:	fc                   	cld    
  8014a3:	eb 57                	jmp    8014fc <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a9:	83 e0 03             	and    $0x3,%eax
  8014ac:	48 85 c0             	test   %rax,%rax
  8014af:	75 36                	jne    8014e7 <memmove+0xfc>
  8014b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b5:	83 e0 03             	and    $0x3,%eax
  8014b8:	48 85 c0             	test   %rax,%rax
  8014bb:	75 2a                	jne    8014e7 <memmove+0xfc>
  8014bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c1:	83 e0 03             	and    $0x3,%eax
  8014c4:	48 85 c0             	test   %rax,%rax
  8014c7:	75 1e                	jne    8014e7 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cd:	48 c1 e8 02          	shr    $0x2,%rax
  8014d1:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014dc:	48 89 c7             	mov    %rax,%rdi
  8014df:	48 89 d6             	mov    %rdx,%rsi
  8014e2:	fc                   	cld    
  8014e3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014e5:	eb 15                	jmp    8014fc <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ef:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014f3:	48 89 c7             	mov    %rax,%rdi
  8014f6:	48 89 d6             	mov    %rdx,%rsi
  8014f9:	fc                   	cld    
  8014fa:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801500:	c9                   	leaveq 
  801501:	c3                   	retq   

0000000000801502 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801502:	55                   	push   %rbp
  801503:	48 89 e5             	mov    %rsp,%rbp
  801506:	48 83 ec 18          	sub    $0x18,%rsp
  80150a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80150e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801512:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801516:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80151a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80151e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801522:	48 89 ce             	mov    %rcx,%rsi
  801525:	48 89 c7             	mov    %rax,%rdi
  801528:	48 b8 eb 13 80 00 00 	movabs $0x8013eb,%rax
  80152f:	00 00 00 
  801532:	ff d0                	callq  *%rax
}
  801534:	c9                   	leaveq 
  801535:	c3                   	retq   

0000000000801536 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801536:	55                   	push   %rbp
  801537:	48 89 e5             	mov    %rsp,%rbp
  80153a:	48 83 ec 28          	sub    $0x28,%rsp
  80153e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801542:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801546:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80154a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80154e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801552:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801556:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80155a:	eb 36                	jmp    801592 <memcmp+0x5c>
		if (*s1 != *s2)
  80155c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801560:	0f b6 10             	movzbl (%rax),%edx
  801563:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801567:	0f b6 00             	movzbl (%rax),%eax
  80156a:	38 c2                	cmp    %al,%dl
  80156c:	74 1a                	je     801588 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80156e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801572:	0f b6 00             	movzbl (%rax),%eax
  801575:	0f b6 d0             	movzbl %al,%edx
  801578:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157c:	0f b6 00             	movzbl (%rax),%eax
  80157f:	0f b6 c0             	movzbl %al,%eax
  801582:	29 c2                	sub    %eax,%edx
  801584:	89 d0                	mov    %edx,%eax
  801586:	eb 20                	jmp    8015a8 <memcmp+0x72>
		s1++, s2++;
  801588:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80158d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801592:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801596:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80159a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80159e:	48 85 c0             	test   %rax,%rax
  8015a1:	75 b9                	jne    80155c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a8:	c9                   	leaveq 
  8015a9:	c3                   	retq   

00000000008015aa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015aa:	55                   	push   %rbp
  8015ab:	48 89 e5             	mov    %rsp,%rbp
  8015ae:	48 83 ec 28          	sub    $0x28,%rsp
  8015b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015b6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015c5:	48 01 d0             	add    %rdx,%rax
  8015c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015cc:	eb 15                	jmp    8015e3 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d2:	0f b6 10             	movzbl (%rax),%edx
  8015d5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015d8:	38 c2                	cmp    %al,%dl
  8015da:	75 02                	jne    8015de <memfind+0x34>
			break;
  8015dc:	eb 0f                	jmp    8015ed <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015de:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e7:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015eb:	72 e1                	jb     8015ce <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015f1:	c9                   	leaveq 
  8015f2:	c3                   	retq   

00000000008015f3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015f3:	55                   	push   %rbp
  8015f4:	48 89 e5             	mov    %rsp,%rbp
  8015f7:	48 83 ec 34          	sub    $0x34,%rsp
  8015fb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015ff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801603:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801606:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80160d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801614:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801615:	eb 05                	jmp    80161c <strtol+0x29>
		s++;
  801617:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80161c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801620:	0f b6 00             	movzbl (%rax),%eax
  801623:	3c 20                	cmp    $0x20,%al
  801625:	74 f0                	je     801617 <strtol+0x24>
  801627:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162b:	0f b6 00             	movzbl (%rax),%eax
  80162e:	3c 09                	cmp    $0x9,%al
  801630:	74 e5                	je     801617 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801632:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801636:	0f b6 00             	movzbl (%rax),%eax
  801639:	3c 2b                	cmp    $0x2b,%al
  80163b:	75 07                	jne    801644 <strtol+0x51>
		s++;
  80163d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801642:	eb 17                	jmp    80165b <strtol+0x68>
	else if (*s == '-')
  801644:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801648:	0f b6 00             	movzbl (%rax),%eax
  80164b:	3c 2d                	cmp    $0x2d,%al
  80164d:	75 0c                	jne    80165b <strtol+0x68>
		s++, neg = 1;
  80164f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801654:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80165b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80165f:	74 06                	je     801667 <strtol+0x74>
  801661:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801665:	75 28                	jne    80168f <strtol+0x9c>
  801667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166b:	0f b6 00             	movzbl (%rax),%eax
  80166e:	3c 30                	cmp    $0x30,%al
  801670:	75 1d                	jne    80168f <strtol+0x9c>
  801672:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801676:	48 83 c0 01          	add    $0x1,%rax
  80167a:	0f b6 00             	movzbl (%rax),%eax
  80167d:	3c 78                	cmp    $0x78,%al
  80167f:	75 0e                	jne    80168f <strtol+0x9c>
		s += 2, base = 16;
  801681:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801686:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80168d:	eb 2c                	jmp    8016bb <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80168f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801693:	75 19                	jne    8016ae <strtol+0xbb>
  801695:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801699:	0f b6 00             	movzbl (%rax),%eax
  80169c:	3c 30                	cmp    $0x30,%al
  80169e:	75 0e                	jne    8016ae <strtol+0xbb>
		s++, base = 8;
  8016a0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016a5:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016ac:	eb 0d                	jmp    8016bb <strtol+0xc8>
	else if (base == 0)
  8016ae:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016b2:	75 07                	jne    8016bb <strtol+0xc8>
		base = 10;
  8016b4:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bf:	0f b6 00             	movzbl (%rax),%eax
  8016c2:	3c 2f                	cmp    $0x2f,%al
  8016c4:	7e 1d                	jle    8016e3 <strtol+0xf0>
  8016c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ca:	0f b6 00             	movzbl (%rax),%eax
  8016cd:	3c 39                	cmp    $0x39,%al
  8016cf:	7f 12                	jg     8016e3 <strtol+0xf0>
			dig = *s - '0';
  8016d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d5:	0f b6 00             	movzbl (%rax),%eax
  8016d8:	0f be c0             	movsbl %al,%eax
  8016db:	83 e8 30             	sub    $0x30,%eax
  8016de:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016e1:	eb 4e                	jmp    801731 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e7:	0f b6 00             	movzbl (%rax),%eax
  8016ea:	3c 60                	cmp    $0x60,%al
  8016ec:	7e 1d                	jle    80170b <strtol+0x118>
  8016ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f2:	0f b6 00             	movzbl (%rax),%eax
  8016f5:	3c 7a                	cmp    $0x7a,%al
  8016f7:	7f 12                	jg     80170b <strtol+0x118>
			dig = *s - 'a' + 10;
  8016f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fd:	0f b6 00             	movzbl (%rax),%eax
  801700:	0f be c0             	movsbl %al,%eax
  801703:	83 e8 57             	sub    $0x57,%eax
  801706:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801709:	eb 26                	jmp    801731 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80170b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170f:	0f b6 00             	movzbl (%rax),%eax
  801712:	3c 40                	cmp    $0x40,%al
  801714:	7e 48                	jle    80175e <strtol+0x16b>
  801716:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171a:	0f b6 00             	movzbl (%rax),%eax
  80171d:	3c 5a                	cmp    $0x5a,%al
  80171f:	7f 3d                	jg     80175e <strtol+0x16b>
			dig = *s - 'A' + 10;
  801721:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801725:	0f b6 00             	movzbl (%rax),%eax
  801728:	0f be c0             	movsbl %al,%eax
  80172b:	83 e8 37             	sub    $0x37,%eax
  80172e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801731:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801734:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801737:	7c 02                	jl     80173b <strtol+0x148>
			break;
  801739:	eb 23                	jmp    80175e <strtol+0x16b>
		s++, val = (val * base) + dig;
  80173b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801740:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801743:	48 98                	cltq   
  801745:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80174a:	48 89 c2             	mov    %rax,%rdx
  80174d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801750:	48 98                	cltq   
  801752:	48 01 d0             	add    %rdx,%rax
  801755:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801759:	e9 5d ff ff ff       	jmpq   8016bb <strtol+0xc8>

	if (endptr)
  80175e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801763:	74 0b                	je     801770 <strtol+0x17d>
		*endptr = (char *) s;
  801765:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801769:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80176d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801770:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801774:	74 09                	je     80177f <strtol+0x18c>
  801776:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177a:	48 f7 d8             	neg    %rax
  80177d:	eb 04                	jmp    801783 <strtol+0x190>
  80177f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801783:	c9                   	leaveq 
  801784:	c3                   	retq   

0000000000801785 <strstr>:

char * strstr(const char *in, const char *str)
{
  801785:	55                   	push   %rbp
  801786:	48 89 e5             	mov    %rsp,%rbp
  801789:	48 83 ec 30          	sub    $0x30,%rsp
  80178d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801791:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801795:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801799:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80179d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017a1:	0f b6 00             	movzbl (%rax),%eax
  8017a4:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8017a7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017ab:	75 06                	jne    8017b3 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8017ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b1:	eb 6b                	jmp    80181e <strstr+0x99>

    len = strlen(str);
  8017b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b7:	48 89 c7             	mov    %rax,%rdi
  8017ba:	48 b8 5b 10 80 00 00 	movabs $0x80105b,%rax
  8017c1:	00 00 00 
  8017c4:	ff d0                	callq  *%rax
  8017c6:	48 98                	cltq   
  8017c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8017cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017d8:	0f b6 00             	movzbl (%rax),%eax
  8017db:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8017de:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017e2:	75 07                	jne    8017eb <strstr+0x66>
                return (char *) 0;
  8017e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e9:	eb 33                	jmp    80181e <strstr+0x99>
        } while (sc != c);
  8017eb:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017ef:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017f2:	75 d8                	jne    8017cc <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  8017f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017f8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801800:	48 89 ce             	mov    %rcx,%rsi
  801803:	48 89 c7             	mov    %rax,%rdi
  801806:	48 b8 7c 12 80 00 00 	movabs $0x80127c,%rax
  80180d:	00 00 00 
  801810:	ff d0                	callq  *%rax
  801812:	85 c0                	test   %eax,%eax
  801814:	75 b6                	jne    8017cc <strstr+0x47>

    return (char *) (in - 1);
  801816:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181a:	48 83 e8 01          	sub    $0x1,%rax
}
  80181e:	c9                   	leaveq 
  80181f:	c3                   	retq   

0000000000801820 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801820:	55                   	push   %rbp
  801821:	48 89 e5             	mov    %rsp,%rbp
  801824:	53                   	push   %rbx
  801825:	48 83 ec 48          	sub    $0x48,%rsp
  801829:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80182c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80182f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801833:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801837:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80183b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80183f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801842:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801846:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80184a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80184e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801852:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801856:	4c 89 c3             	mov    %r8,%rbx
  801859:	cd 30                	int    $0x30
  80185b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  80185f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801863:	74 3e                	je     8018a3 <syscall+0x83>
  801865:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80186a:	7e 37                	jle    8018a3 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80186c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801870:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801873:	49 89 d0             	mov    %rdx,%r8
  801876:	89 c1                	mov    %eax,%ecx
  801878:	48 ba c0 40 80 00 00 	movabs $0x8040c0,%rdx
  80187f:	00 00 00 
  801882:	be 23 00 00 00       	mov    $0x23,%esi
  801887:	48 bf dd 40 80 00 00 	movabs $0x8040dd,%rdi
  80188e:	00 00 00 
  801891:	b8 00 00 00 00       	mov    $0x0,%eax
  801896:	49 b9 45 39 80 00 00 	movabs $0x803945,%r9
  80189d:	00 00 00 
  8018a0:	41 ff d1             	callq  *%r9

	return ret;
  8018a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018a7:	48 83 c4 48          	add    $0x48,%rsp
  8018ab:	5b                   	pop    %rbx
  8018ac:	5d                   	pop    %rbp
  8018ad:	c3                   	retq   

00000000008018ae <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018ae:	55                   	push   %rbp
  8018af:	48 89 e5             	mov    %rsp,%rbp
  8018b2:	48 83 ec 20          	sub    $0x20,%rsp
  8018b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018cd:	00 
  8018ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018da:	48 89 d1             	mov    %rdx,%rcx
  8018dd:	48 89 c2             	mov    %rax,%rdx
  8018e0:	be 00 00 00 00       	mov    $0x0,%esi
  8018e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8018ea:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  8018f1:	00 00 00 
  8018f4:	ff d0                	callq  *%rax
}
  8018f6:	c9                   	leaveq 
  8018f7:	c3                   	retq   

00000000008018f8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018f8:	55                   	push   %rbp
  8018f9:	48 89 e5             	mov    %rsp,%rbp
  8018fc:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801900:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801907:	00 
  801908:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80190e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801914:	b9 00 00 00 00       	mov    $0x0,%ecx
  801919:	ba 00 00 00 00       	mov    $0x0,%edx
  80191e:	be 00 00 00 00       	mov    $0x0,%esi
  801923:	bf 01 00 00 00       	mov    $0x1,%edi
  801928:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  80192f:	00 00 00 
  801932:	ff d0                	callq  *%rax
}
  801934:	c9                   	leaveq 
  801935:	c3                   	retq   

0000000000801936 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801936:	55                   	push   %rbp
  801937:	48 89 e5             	mov    %rsp,%rbp
  80193a:	48 83 ec 10          	sub    $0x10,%rsp
  80193e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801941:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801944:	48 98                	cltq   
  801946:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80194d:	00 
  80194e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801954:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80195a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80195f:	48 89 c2             	mov    %rax,%rdx
  801962:	be 01 00 00 00       	mov    $0x1,%esi
  801967:	bf 03 00 00 00       	mov    $0x3,%edi
  80196c:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801973:	00 00 00 
  801976:	ff d0                	callq  *%rax
}
  801978:	c9                   	leaveq 
  801979:	c3                   	retq   

000000000080197a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80197a:	55                   	push   %rbp
  80197b:	48 89 e5             	mov    %rsp,%rbp
  80197e:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801982:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801989:	00 
  80198a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801990:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801996:	b9 00 00 00 00       	mov    $0x0,%ecx
  80199b:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a0:	be 00 00 00 00       	mov    $0x0,%esi
  8019a5:	bf 02 00 00 00       	mov    $0x2,%edi
  8019aa:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  8019b1:	00 00 00 
  8019b4:	ff d0                	callq  *%rax
}
  8019b6:	c9                   	leaveq 
  8019b7:	c3                   	retq   

00000000008019b8 <sys_yield>:

void
sys_yield(void)
{
  8019b8:	55                   	push   %rbp
  8019b9:	48 89 e5             	mov    %rsp,%rbp
  8019bc:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019c0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c7:	00 
  8019c8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019de:	be 00 00 00 00       	mov    $0x0,%esi
  8019e3:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019e8:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  8019ef:	00 00 00 
  8019f2:	ff d0                	callq  *%rax
}
  8019f4:	c9                   	leaveq 
  8019f5:	c3                   	retq   

00000000008019f6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019f6:	55                   	push   %rbp
  8019f7:	48 89 e5             	mov    %rsp,%rbp
  8019fa:	48 83 ec 20          	sub    $0x20,%rsp
  8019fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a05:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a08:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a0b:	48 63 c8             	movslq %eax,%rcx
  801a0e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a15:	48 98                	cltq   
  801a17:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1e:	00 
  801a1f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a25:	49 89 c8             	mov    %rcx,%r8
  801a28:	48 89 d1             	mov    %rdx,%rcx
  801a2b:	48 89 c2             	mov    %rax,%rdx
  801a2e:	be 01 00 00 00       	mov    $0x1,%esi
  801a33:	bf 04 00 00 00       	mov    $0x4,%edi
  801a38:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801a3f:	00 00 00 
  801a42:	ff d0                	callq  *%rax
}
  801a44:	c9                   	leaveq 
  801a45:	c3                   	retq   

0000000000801a46 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a46:	55                   	push   %rbp
  801a47:	48 89 e5             	mov    %rsp,%rbp
  801a4a:	48 83 ec 30          	sub    $0x30,%rsp
  801a4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a55:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a58:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a5c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a60:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a63:	48 63 c8             	movslq %eax,%rcx
  801a66:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a6d:	48 63 f0             	movslq %eax,%rsi
  801a70:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a77:	48 98                	cltq   
  801a79:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a7d:	49 89 f9             	mov    %rdi,%r9
  801a80:	49 89 f0             	mov    %rsi,%r8
  801a83:	48 89 d1             	mov    %rdx,%rcx
  801a86:	48 89 c2             	mov    %rax,%rdx
  801a89:	be 01 00 00 00       	mov    $0x1,%esi
  801a8e:	bf 05 00 00 00       	mov    $0x5,%edi
  801a93:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801a9a:	00 00 00 
  801a9d:	ff d0                	callq  *%rax
}
  801a9f:	c9                   	leaveq 
  801aa0:	c3                   	retq   

0000000000801aa1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801aa1:	55                   	push   %rbp
  801aa2:	48 89 e5             	mov    %rsp,%rbp
  801aa5:	48 83 ec 20          	sub    $0x20,%rsp
  801aa9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ab0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab7:	48 98                	cltq   
  801ab9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac0:	00 
  801ac1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801acd:	48 89 d1             	mov    %rdx,%rcx
  801ad0:	48 89 c2             	mov    %rax,%rdx
  801ad3:	be 01 00 00 00       	mov    $0x1,%esi
  801ad8:	bf 06 00 00 00       	mov    $0x6,%edi
  801add:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801ae4:	00 00 00 
  801ae7:	ff d0                	callq  *%rax
}
  801ae9:	c9                   	leaveq 
  801aea:	c3                   	retq   

0000000000801aeb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801aeb:	55                   	push   %rbp
  801aec:	48 89 e5             	mov    %rsp,%rbp
  801aef:	48 83 ec 10          	sub    $0x10,%rsp
  801af3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801af9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801afc:	48 63 d0             	movslq %eax,%rdx
  801aff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b02:	48 98                	cltq   
  801b04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b0b:	00 
  801b0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b18:	48 89 d1             	mov    %rdx,%rcx
  801b1b:	48 89 c2             	mov    %rax,%rdx
  801b1e:	be 01 00 00 00       	mov    $0x1,%esi
  801b23:	bf 08 00 00 00       	mov    $0x8,%edi
  801b28:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801b2f:	00 00 00 
  801b32:	ff d0                	callq  *%rax
}
  801b34:	c9                   	leaveq 
  801b35:	c3                   	retq   

0000000000801b36 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b36:	55                   	push   %rbp
  801b37:	48 89 e5             	mov    %rsp,%rbp
  801b3a:	48 83 ec 20          	sub    $0x20,%rsp
  801b3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b4c:	48 98                	cltq   
  801b4e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b55:	00 
  801b56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b5c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b62:	48 89 d1             	mov    %rdx,%rcx
  801b65:	48 89 c2             	mov    %rax,%rdx
  801b68:	be 01 00 00 00       	mov    $0x1,%esi
  801b6d:	bf 09 00 00 00       	mov    $0x9,%edi
  801b72:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801b79:	00 00 00 
  801b7c:	ff d0                	callq  *%rax
}
  801b7e:	c9                   	leaveq 
  801b7f:	c3                   	retq   

0000000000801b80 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b80:	55                   	push   %rbp
  801b81:	48 89 e5             	mov    %rsp,%rbp
  801b84:	48 83 ec 20          	sub    $0x20,%rsp
  801b88:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b8f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b96:	48 98                	cltq   
  801b98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b9f:	00 
  801ba0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bac:	48 89 d1             	mov    %rdx,%rcx
  801baf:	48 89 c2             	mov    %rax,%rdx
  801bb2:	be 01 00 00 00       	mov    $0x1,%esi
  801bb7:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bbc:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801bc3:	00 00 00 
  801bc6:	ff d0                	callq  *%rax
}
  801bc8:	c9                   	leaveq 
  801bc9:	c3                   	retq   

0000000000801bca <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801bca:	55                   	push   %rbp
  801bcb:	48 89 e5             	mov    %rsp,%rbp
  801bce:	48 83 ec 20          	sub    $0x20,%rsp
  801bd2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bd5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bd9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bdd:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801be0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801be3:	48 63 f0             	movslq %eax,%rsi
  801be6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bed:	48 98                	cltq   
  801bef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bfa:	00 
  801bfb:	49 89 f1             	mov    %rsi,%r9
  801bfe:	49 89 c8             	mov    %rcx,%r8
  801c01:	48 89 d1             	mov    %rdx,%rcx
  801c04:	48 89 c2             	mov    %rax,%rdx
  801c07:	be 00 00 00 00       	mov    $0x0,%esi
  801c0c:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c11:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801c18:	00 00 00 
  801c1b:	ff d0                	callq  *%rax
}
  801c1d:	c9                   	leaveq 
  801c1e:	c3                   	retq   

0000000000801c1f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c1f:	55                   	push   %rbp
  801c20:	48 89 e5             	mov    %rsp,%rbp
  801c23:	48 83 ec 10          	sub    $0x10,%rsp
  801c27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c36:	00 
  801c37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c43:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c48:	48 89 c2             	mov    %rax,%rdx
  801c4b:	be 01 00 00 00       	mov    $0x1,%esi
  801c50:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c55:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801c5c:	00 00 00 
  801c5f:	ff d0                	callq  *%rax
}
  801c61:	c9                   	leaveq 
  801c62:	c3                   	retq   

0000000000801c63 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801c63:	55                   	push   %rbp
  801c64:	48 89 e5             	mov    %rsp,%rbp
  801c67:	48 83 ec 30          	sub    $0x30,%rsp
  801c6b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801c6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c73:	48 8b 00             	mov    (%rax),%rax
  801c76:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801c7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c7e:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c82:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)))
  801c85:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c88:	83 e0 02             	and    $0x2,%eax
  801c8b:	85 c0                	test   %eax,%eax
  801c8d:	74 23                	je     801cb2 <pgfault+0x4f>
  801c8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c93:	48 c1 e8 0c          	shr    $0xc,%rax
  801c97:	48 89 c2             	mov    %rax,%rdx
  801c9a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ca1:	01 00 00 
  801ca4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ca8:	25 00 08 00 00       	and    $0x800,%eax
  801cad:	48 85 c0             	test   %rax,%rax
  801cb0:	75 2a                	jne    801cdc <pgfault+0x79>
		panic("fail check at fork pgfault");
  801cb2:	48 ba eb 40 80 00 00 	movabs $0x8040eb,%rdx
  801cb9:	00 00 00 
  801cbc:	be 1d 00 00 00       	mov    $0x1d,%esi
  801cc1:	48 bf 06 41 80 00 00 	movabs $0x804106,%rdi
  801cc8:	00 00 00 
  801ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd0:	48 b9 45 39 80 00 00 	movabs $0x803945,%rcx
  801cd7:	00 00 00 
  801cda:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801cdc:	ba 07 00 00 00       	mov    $0x7,%edx
  801ce1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ce6:	bf 00 00 00 00       	mov    $0x0,%edi
  801ceb:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801cf2:	00 00 00 
  801cf5:	ff d0                	callq  *%rax

	addr = ROUNDDOWN(addr, PGSIZE);
  801cf7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cfb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801cff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d03:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801d09:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memmove(PFTEMP, addr, PGSIZE);
  801d0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d11:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d16:	48 89 c6             	mov    %rax,%rsi
  801d19:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801d1e:	48 b8 eb 13 80 00 00 	movabs $0x8013eb,%rax
  801d25:	00 00 00 
  801d28:	ff d0                	callq  *%rax

	sys_page_map(0, (void *)PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W);
  801d2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d2e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801d34:	48 89 c1             	mov    %rax,%rcx
  801d37:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d41:	bf 00 00 00 00       	mov    $0x0,%edi
  801d46:	48 b8 46 1a 80 00 00 	movabs $0x801a46,%rax
  801d4d:	00 00 00 
  801d50:	ff d0                	callq  *%rax
	sys_page_unmap(0, PFTEMP);
  801d52:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d57:	bf 00 00 00 00       	mov    $0x0,%edi
  801d5c:	48 b8 a1 1a 80 00 00 	movabs $0x801aa1,%rax
  801d63:	00 00 00 
  801d66:	ff d0                	callq  *%rax
	//panic("pgfault not implemented");
}
  801d68:	c9                   	leaveq 
  801d69:	c3                   	retq   

0000000000801d6a <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d6a:	55                   	push   %rbp
  801d6b:	48 89 e5             	mov    %rsp,%rbp
  801d6e:	48 83 ec 20          	sub    $0x20,%rsp
  801d72:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d75:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uintptr_t)pn * PGSIZE);
  801d78:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801d7b:	48 c1 e0 0c          	shl    $0xc,%rax
  801d7f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	// note: modified for LAB 5, supporting PTE_SHARE
	if (uvpt[pn] & PTE_SHARE) {
  801d83:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d8a:	01 00 00 
  801d8d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801d90:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d94:	25 00 04 00 00       	and    $0x400,%eax
  801d99:	48 85 c0             	test   %rax,%rax
  801d9c:	74 55                	je     801df3 <duppage+0x89>
		if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL))) < 0)
  801d9e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801da5:	01 00 00 
  801da8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801dab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801daf:	25 07 0e 00 00       	and    $0xe07,%eax
  801db4:	89 c6                	mov    %eax,%esi
  801db6:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801dba:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801dbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc1:	41 89 f0             	mov    %esi,%r8d
  801dc4:	48 89 c6             	mov    %rax,%rsi
  801dc7:	bf 00 00 00 00       	mov    $0x0,%edi
  801dcc:	48 b8 46 1a 80 00 00 	movabs $0x801a46,%rax
  801dd3:	00 00 00 
  801dd6:	ff d0                	callq  *%rax
  801dd8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801ddb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801ddf:	79 08                	jns    801de9 <duppage+0x7f>
			return r;
  801de1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801de4:	e9 e1 00 00 00       	jmpq   801eca <duppage+0x160>
		return 0;
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dee:	e9 d7 00 00 00       	jmpq   801eca <duppage+0x160>
	}

	// note: here we must set ~PTE_W and PTE_COW such that parent process can get correct pid
	if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  801df3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dfa:	01 00 00 
  801dfd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e00:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e04:	25 05 06 00 00       	and    $0x605,%eax
  801e09:	80 cc 08             	or     $0x8,%ah
  801e0c:	89 c6                	mov    %eax,%esi
  801e0e:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801e12:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e19:	41 89 f0             	mov    %esi,%r8d
  801e1c:	48 89 c6             	mov    %rax,%rsi
  801e1f:	bf 00 00 00 00       	mov    $0x0,%edi
  801e24:	48 b8 46 1a 80 00 00 	movabs $0x801a46,%rax
  801e2b:	00 00 00 
  801e2e:	ff d0                	callq  *%rax
  801e30:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801e33:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e37:	79 08                	jns    801e41 <duppage+0xd7>
		return r;
  801e39:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e3c:	e9 89 00 00 00       	jmpq   801eca <duppage+0x160>

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  801e41:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e48:	01 00 00 
  801e4b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e4e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e52:	83 e0 02             	and    $0x2,%eax
  801e55:	48 85 c0             	test   %rax,%rax
  801e58:	75 1b                	jne    801e75 <duppage+0x10b>
  801e5a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e61:	01 00 00 
  801e64:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e67:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e6b:	25 00 08 00 00       	and    $0x800,%eax
  801e70:	48 85 c0             	test   %rax,%rax
  801e73:	74 50                	je     801ec5 <duppage+0x15b>
		if ((r = sys_page_map(0, addr, 0, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  801e75:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e7c:	01 00 00 
  801e7f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e82:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e86:	25 05 06 00 00       	and    $0x605,%eax
  801e8b:	80 cc 08             	or     $0x8,%ah
  801e8e:	89 c1                	mov    %eax,%ecx
  801e90:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e98:	41 89 c8             	mov    %ecx,%r8d
  801e9b:	48 89 d1             	mov    %rdx,%rcx
  801e9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea3:	48 89 c6             	mov    %rax,%rsi
  801ea6:	bf 00 00 00 00       	mov    $0x0,%edi
  801eab:	48 b8 46 1a 80 00 00 	movabs $0x801a46,%rax
  801eb2:	00 00 00 
  801eb5:	ff d0                	callq  *%rax
  801eb7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801eba:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801ebe:	79 05                	jns    801ec5 <duppage+0x15b>
			return r;
  801ec0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ec3:	eb 05                	jmp    801eca <duppage+0x160>
	//panic("duppage not implemented");
	return 0;
  801ec5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eca:	c9                   	leaveq 
  801ecb:	c3                   	retq   

0000000000801ecc <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801ecc:	55                   	push   %rbp
  801ecd:	48 89 e5             	mov    %rsp,%rbp
  801ed0:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	int r;
	envid_t envid;
	int i, j, k, l, ptx = 0;
  801ed4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	set_pgfault_handler(pgfault);
  801edb:	48 bf 63 1c 80 00 00 	movabs $0x801c63,%rdi
  801ee2:	00 00 00 
  801ee5:	48 b8 59 3a 80 00 00 	movabs $0x803a59,%rax
  801eec:	00 00 00 
  801eef:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801ef1:	b8 07 00 00 00       	mov    $0x7,%eax
  801ef6:	cd 30                	int    $0x30
  801ef8:	89 45 e0             	mov    %eax,-0x20(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801efb:	8b 45 e0             	mov    -0x20(%rbp),%eax

	if ((envid = sys_exofork()) < 0)
  801efe:	89 45 e8             	mov    %eax,-0x18(%rbp)
  801f01:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801f05:	79 08                	jns    801f0f <fork+0x43>
		return envid;
  801f07:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f0a:	e9 27 02 00 00       	jmpq   802136 <fork+0x26a>
	else if (envid == 0) {
  801f0f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801f13:	75 46                	jne    801f5b <fork+0x8f>
		thisenv = &envs[ENVX(sys_getenvid())];
  801f15:	48 b8 7a 19 80 00 00 	movabs $0x80197a,%rax
  801f1c:	00 00 00 
  801f1f:	ff d0                	callq  *%rax
  801f21:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f26:	48 63 d0             	movslq %eax,%rdx
  801f29:	48 89 d0             	mov    %rdx,%rax
  801f2c:	48 c1 e0 03          	shl    $0x3,%rax
  801f30:	48 01 d0             	add    %rdx,%rax
  801f33:	48 c1 e0 05          	shl    $0x5,%rax
  801f37:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801f3e:	00 00 00 
  801f41:	48 01 c2             	add    %rax,%rdx
  801f44:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801f4b:	00 00 00 
  801f4e:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801f51:	b8 00 00 00 00       	mov    $0x0,%eax
  801f56:	e9 db 01 00 00       	jmpq   802136 <fork+0x26a>
	}

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801f5b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f5e:	ba 07 00 00 00       	mov    $0x7,%edx
  801f63:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801f68:	89 c7                	mov    %eax,%edi
  801f6a:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  801f71:	00 00 00 
  801f74:	ff d0                	callq  *%rax
  801f76:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  801f79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801f7d:	79 08                	jns    801f87 <fork+0xbb>
		return r;
  801f7f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801f82:	e9 af 01 00 00       	jmpq   802136 <fork+0x26a>

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  801f87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f8e:	e9 49 01 00 00       	jmpq   8020dc <fork+0x210>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  801f93:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f96:	8d 90 ff ff ff 07    	lea    0x7ffffff(%rax),%edx
  801f9c:	85 c0                	test   %eax,%eax
  801f9e:	0f 48 c2             	cmovs  %edx,%eax
  801fa1:	c1 f8 1b             	sar    $0x1b,%eax
  801fa4:	89 c2                	mov    %eax,%edx
  801fa6:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801fad:	01 00 00 
  801fb0:	48 63 d2             	movslq %edx,%rdx
  801fb3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb7:	83 e0 01             	and    $0x1,%eax
  801fba:	48 85 c0             	test   %rax,%rax
  801fbd:	75 0c                	jne    801fcb <fork+0xff>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  801fbf:	81 45 ec 00 00 00 08 	addl   $0x8000000,-0x14(%rbp)
			continue;
  801fc6:	e9 0d 01 00 00       	jmpq   8020d8 <fork+0x20c>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  801fcb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  801fd2:	e9 f4 00 00 00       	jmpq   8020cb <fork+0x1ff>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  801fd7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fda:	8d 90 ff ff 03 00    	lea    0x3ffff(%rax),%edx
  801fe0:	85 c0                	test   %eax,%eax
  801fe2:	0f 48 c2             	cmovs  %edx,%eax
  801fe5:	c1 f8 12             	sar    $0x12,%eax
  801fe8:	89 c2                	mov    %eax,%edx
  801fea:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801ff1:	01 00 00 
  801ff4:	48 63 d2             	movslq %edx,%rdx
  801ff7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ffb:	83 e0 01             	and    $0x1,%eax
  801ffe:	48 85 c0             	test   %rax,%rax
  802001:	75 0c                	jne    80200f <fork+0x143>
				ptx += NPDENTRIES * NPTENTRIES;
  802003:	81 45 ec 00 00 04 00 	addl   $0x40000,-0x14(%rbp)
				continue;
  80200a:	e9 b8 00 00 00       	jmpq   8020c7 <fork+0x1fb>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  80200f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  802016:	e9 9f 00 00 00       	jmpq   8020ba <fork+0x1ee>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  80201b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80201e:	8d 90 ff 01 00 00    	lea    0x1ff(%rax),%edx
  802024:	85 c0                	test   %eax,%eax
  802026:	0f 48 c2             	cmovs  %edx,%eax
  802029:	c1 f8 09             	sar    $0x9,%eax
  80202c:	89 c2                	mov    %eax,%edx
  80202e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802035:	01 00 00 
  802038:	48 63 d2             	movslq %edx,%rdx
  80203b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80203f:	83 e0 01             	and    $0x1,%eax
  802042:	48 85 c0             	test   %rax,%rax
  802045:	75 09                	jne    802050 <fork+0x184>
					ptx += NPTENTRIES;
  802047:	81 45 ec 00 02 00 00 	addl   $0x200,-0x14(%rbp)
					continue;
  80204e:	eb 66                	jmp    8020b6 <fork+0x1ea>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  802050:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  802057:	eb 54                	jmp    8020ad <fork+0x1e1>
					if ((uvpt[ptx] & PTE_P) != 0)
  802059:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802060:	01 00 00 
  802063:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802066:	48 63 d2             	movslq %edx,%rdx
  802069:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80206d:	83 e0 01             	and    $0x1,%eax
  802070:	48 85 c0             	test   %rax,%rax
  802073:	74 30                	je     8020a5 <fork+0x1d9>
						if (ptx != VPN(UXSTACKTOP - PGSIZE))
  802075:	81 7d ec ff f7 0e 00 	cmpl   $0xef7ff,-0x14(%rbp)
  80207c:	74 27                	je     8020a5 <fork+0x1d9>
							if ((r = duppage(envid, ptx)) < 0)
  80207e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802081:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802084:	89 d6                	mov    %edx,%esi
  802086:	89 c7                	mov    %eax,%edi
  802088:	48 b8 6a 1d 80 00 00 	movabs $0x801d6a,%rax
  80208f:	00 00 00 
  802092:	ff d0                	callq  *%rax
  802094:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802097:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80209b:	79 08                	jns    8020a5 <fork+0x1d9>
								return r;
  80209d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8020a0:	e9 91 00 00 00       	jmpq   802136 <fork+0x26a>
					ptx++;
  8020a5:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  8020a9:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8020ad:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
  8020b4:	7e a3                	jle    802059 <fork+0x18d>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  8020b6:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8020ba:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
  8020c1:	0f 8e 54 ff ff ff    	jle    80201b <fork+0x14f>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  8020c7:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8020cb:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
  8020d2:	0f 8e ff fe ff ff    	jle    801fd7 <fork+0x10b>
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		return r;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  8020d8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020e0:	0f 84 ad fe ff ff    	je     801f93 <fork+0xc7>
			}
		}
	}

	extern void _pgfault_upcall();
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8020e6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020e9:	48 be c4 3a 80 00 00 	movabs $0x803ac4,%rsi
  8020f0:	00 00 00 
  8020f3:	89 c7                	mov    %eax,%edi
  8020f5:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  8020fc:	00 00 00 
  8020ff:	ff d0                	callq  *%rax
  802101:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802104:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802108:	79 05                	jns    80210f <fork+0x243>
		return r;
  80210a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80210d:	eb 27                	jmp    802136 <fork+0x26a>
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80210f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802112:	be 02 00 00 00       	mov    $0x2,%esi
  802117:	89 c7                	mov    %eax,%edi
  802119:	48 b8 eb 1a 80 00 00 	movabs $0x801aeb,%rax
  802120:	00 00 00 
  802123:	ff d0                	callq  *%rax
  802125:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802128:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80212c:	79 05                	jns    802133 <fork+0x267>
		return r;
  80212e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802131:	eb 03                	jmp    802136 <fork+0x26a>

	return envid;
  802133:	8b 45 e8             	mov    -0x18(%rbp),%eax
	//panic("fork not implemented");
}
  802136:	c9                   	leaveq 
  802137:	c3                   	retq   

0000000000802138 <sfork>:

// Challenge!
int
sfork(void)
{
  802138:	55                   	push   %rbp
  802139:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80213c:	48 ba 11 41 80 00 00 	movabs $0x804111,%rdx
  802143:	00 00 00 
  802146:	be a7 00 00 00       	mov    $0xa7,%esi
  80214b:	48 bf 06 41 80 00 00 	movabs $0x804106,%rdi
  802152:	00 00 00 
  802155:	b8 00 00 00 00       	mov    $0x0,%eax
  80215a:	48 b9 45 39 80 00 00 	movabs $0x803945,%rcx
  802161:	00 00 00 
  802164:	ff d1                	callq  *%rcx

0000000000802166 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802166:	55                   	push   %rbp
  802167:	48 89 e5             	mov    %rsp,%rbp
  80216a:	48 83 ec 30          	sub    $0x30,%rsp
  80216e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802172:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802176:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  80217a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80217e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  802182:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802187:	75 0e                	jne    802197 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  802189:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  802190:	00 00 00 
  802193:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  802197:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80219b:	48 89 c7             	mov    %rax,%rdi
  80219e:	48 b8 1f 1c 80 00 00 	movabs $0x801c1f,%rax
  8021a5:	00 00 00 
  8021a8:	ff d0                	callq  *%rax
  8021aa:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8021ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8021b1:	79 27                	jns    8021da <ipc_recv+0x74>
		if (from_env_store != NULL)
  8021b3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8021b8:	74 0a                	je     8021c4 <ipc_recv+0x5e>
			*from_env_store = 0;
  8021ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021be:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  8021c4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8021c9:	74 0a                	je     8021d5 <ipc_recv+0x6f>
			*perm_store = 0;
  8021cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021cf:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8021d5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021d8:	eb 53                	jmp    80222d <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  8021da:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8021df:	74 19                	je     8021fa <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  8021e1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8021e8:	00 00 00 
  8021eb:	48 8b 00             	mov    (%rax),%rax
  8021ee:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8021f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f8:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  8021fa:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8021ff:	74 19                	je     80221a <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  802201:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802208:	00 00 00 
  80220b:	48 8b 00             	mov    (%rax),%rax
  80220e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802214:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802218:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  80221a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802221:	00 00 00 
  802224:	48 8b 00             	mov    (%rax),%rax
  802227:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  80222d:	c9                   	leaveq 
  80222e:	c3                   	retq   

000000000080222f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80222f:	55                   	push   %rbp
  802230:	48 89 e5             	mov    %rsp,%rbp
  802233:	48 83 ec 30          	sub    $0x30,%rsp
  802237:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80223a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80223d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802241:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  802244:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802248:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  80224c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802251:	75 10                	jne    802263 <ipc_send+0x34>
		page = (void *)KERNBASE;
  802253:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  80225a:	00 00 00 
  80225d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  802261:	eb 0e                	jmp    802271 <ipc_send+0x42>
  802263:	eb 0c                	jmp    802271 <ipc_send+0x42>
		sys_yield();
  802265:	48 b8 b8 19 80 00 00 	movabs $0x8019b8,%rax
  80226c:	00 00 00 
  80226f:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  802271:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802274:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802277:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80227b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80227e:	89 c7                	mov    %eax,%edi
  802280:	48 b8 ca 1b 80 00 00 	movabs $0x801bca,%rax
  802287:	00 00 00 
  80228a:	ff d0                	callq  *%rax
  80228c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80228f:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  802293:	74 d0                	je     802265 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  802295:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802299:	74 2a                	je     8022c5 <ipc_send+0x96>
		panic("error on ipc send procedure");
  80229b:	48 ba 27 41 80 00 00 	movabs $0x804127,%rdx
  8022a2:	00 00 00 
  8022a5:	be 49 00 00 00       	mov    $0x49,%esi
  8022aa:	48 bf 43 41 80 00 00 	movabs $0x804143,%rdi
  8022b1:	00 00 00 
  8022b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b9:	48 b9 45 39 80 00 00 	movabs $0x803945,%rcx
  8022c0:	00 00 00 
  8022c3:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  8022c5:	c9                   	leaveq 
  8022c6:	c3                   	retq   

00000000008022c7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022c7:	55                   	push   %rbp
  8022c8:	48 89 e5             	mov    %rsp,%rbp
  8022cb:	48 83 ec 14          	sub    $0x14,%rsp
  8022cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8022d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022d9:	eb 5e                	jmp    802339 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8022db:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8022e2:	00 00 00 
  8022e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e8:	48 63 d0             	movslq %eax,%rdx
  8022eb:	48 89 d0             	mov    %rdx,%rax
  8022ee:	48 c1 e0 03          	shl    $0x3,%rax
  8022f2:	48 01 d0             	add    %rdx,%rax
  8022f5:	48 c1 e0 05          	shl    $0x5,%rax
  8022f9:	48 01 c8             	add    %rcx,%rax
  8022fc:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802302:	8b 00                	mov    (%rax),%eax
  802304:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802307:	75 2c                	jne    802335 <ipc_find_env+0x6e>
			return envs[i].env_id;
  802309:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802310:	00 00 00 
  802313:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802316:	48 63 d0             	movslq %eax,%rdx
  802319:	48 89 d0             	mov    %rdx,%rax
  80231c:	48 c1 e0 03          	shl    $0x3,%rax
  802320:	48 01 d0             	add    %rdx,%rax
  802323:	48 c1 e0 05          	shl    $0x5,%rax
  802327:	48 01 c8             	add    %rcx,%rax
  80232a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802330:	8b 40 08             	mov    0x8(%rax),%eax
  802333:	eb 12                	jmp    802347 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802335:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802339:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802340:	7e 99                	jle    8022db <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802342:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802347:	c9                   	leaveq 
  802348:	c3                   	retq   

0000000000802349 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802349:	55                   	push   %rbp
  80234a:	48 89 e5             	mov    %rsp,%rbp
  80234d:	48 83 ec 08          	sub    $0x8,%rsp
  802351:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802355:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802359:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802360:	ff ff ff 
  802363:	48 01 d0             	add    %rdx,%rax
  802366:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80236a:	c9                   	leaveq 
  80236b:	c3                   	retq   

000000000080236c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80236c:	55                   	push   %rbp
  80236d:	48 89 e5             	mov    %rsp,%rbp
  802370:	48 83 ec 08          	sub    $0x8,%rsp
  802374:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802378:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80237c:	48 89 c7             	mov    %rax,%rdi
  80237f:	48 b8 49 23 80 00 00 	movabs $0x802349,%rax
  802386:	00 00 00 
  802389:	ff d0                	callq  *%rax
  80238b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802391:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802395:	c9                   	leaveq 
  802396:	c3                   	retq   

0000000000802397 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802397:	55                   	push   %rbp
  802398:	48 89 e5             	mov    %rsp,%rbp
  80239b:	48 83 ec 18          	sub    $0x18,%rsp
  80239f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023aa:	eb 6b                	jmp    802417 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8023ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023af:	48 98                	cltq   
  8023b1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023b7:	48 c1 e0 0c          	shl    $0xc,%rax
  8023bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8023bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023c3:	48 c1 e8 15          	shr    $0x15,%rax
  8023c7:	48 89 c2             	mov    %rax,%rdx
  8023ca:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023d1:	01 00 00 
  8023d4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023d8:	83 e0 01             	and    $0x1,%eax
  8023db:	48 85 c0             	test   %rax,%rax
  8023de:	74 21                	je     802401 <fd_alloc+0x6a>
  8023e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023e4:	48 c1 e8 0c          	shr    $0xc,%rax
  8023e8:	48 89 c2             	mov    %rax,%rdx
  8023eb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023f2:	01 00 00 
  8023f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023f9:	83 e0 01             	and    $0x1,%eax
  8023fc:	48 85 c0             	test   %rax,%rax
  8023ff:	75 12                	jne    802413 <fd_alloc+0x7c>
			*fd_store = fd;
  802401:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802405:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802409:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80240c:	b8 00 00 00 00       	mov    $0x0,%eax
  802411:	eb 1a                	jmp    80242d <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802413:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802417:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80241b:	7e 8f                	jle    8023ac <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80241d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802421:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802428:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80242d:	c9                   	leaveq 
  80242e:	c3                   	retq   

000000000080242f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80242f:	55                   	push   %rbp
  802430:	48 89 e5             	mov    %rsp,%rbp
  802433:	48 83 ec 20          	sub    $0x20,%rsp
  802437:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80243a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80243e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802442:	78 06                	js     80244a <fd_lookup+0x1b>
  802444:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802448:	7e 07                	jle    802451 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80244a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80244f:	eb 6c                	jmp    8024bd <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802451:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802454:	48 98                	cltq   
  802456:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80245c:	48 c1 e0 0c          	shl    $0xc,%rax
  802460:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802464:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802468:	48 c1 e8 15          	shr    $0x15,%rax
  80246c:	48 89 c2             	mov    %rax,%rdx
  80246f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802476:	01 00 00 
  802479:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80247d:	83 e0 01             	and    $0x1,%eax
  802480:	48 85 c0             	test   %rax,%rax
  802483:	74 21                	je     8024a6 <fd_lookup+0x77>
  802485:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802489:	48 c1 e8 0c          	shr    $0xc,%rax
  80248d:	48 89 c2             	mov    %rax,%rdx
  802490:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802497:	01 00 00 
  80249a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80249e:	83 e0 01             	and    $0x1,%eax
  8024a1:	48 85 c0             	test   %rax,%rax
  8024a4:	75 07                	jne    8024ad <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024ab:	eb 10                	jmp    8024bd <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8024ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024b1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024b5:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8024b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024bd:	c9                   	leaveq 
  8024be:	c3                   	retq   

00000000008024bf <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8024bf:	55                   	push   %rbp
  8024c0:	48 89 e5             	mov    %rsp,%rbp
  8024c3:	48 83 ec 30          	sub    $0x30,%rsp
  8024c7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8024cb:	89 f0                	mov    %esi,%eax
  8024cd:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8024d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024d4:	48 89 c7             	mov    %rax,%rdi
  8024d7:	48 b8 49 23 80 00 00 	movabs $0x802349,%rax
  8024de:	00 00 00 
  8024e1:	ff d0                	callq  *%rax
  8024e3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024e7:	48 89 d6             	mov    %rdx,%rsi
  8024ea:	89 c7                	mov    %eax,%edi
  8024ec:	48 b8 2f 24 80 00 00 	movabs $0x80242f,%rax
  8024f3:	00 00 00 
  8024f6:	ff d0                	callq  *%rax
  8024f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ff:	78 0a                	js     80250b <fd_close+0x4c>
	    || fd != fd2)
  802501:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802505:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802509:	74 12                	je     80251d <fd_close+0x5e>
		return (must_exist ? r : 0);
  80250b:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80250f:	74 05                	je     802516 <fd_close+0x57>
  802511:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802514:	eb 05                	jmp    80251b <fd_close+0x5c>
  802516:	b8 00 00 00 00       	mov    $0x0,%eax
  80251b:	eb 69                	jmp    802586 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80251d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802521:	8b 00                	mov    (%rax),%eax
  802523:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802527:	48 89 d6             	mov    %rdx,%rsi
  80252a:	89 c7                	mov    %eax,%edi
  80252c:	48 b8 88 25 80 00 00 	movabs $0x802588,%rax
  802533:	00 00 00 
  802536:	ff d0                	callq  *%rax
  802538:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80253b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80253f:	78 2a                	js     80256b <fd_close+0xac>
		if (dev->dev_close)
  802541:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802545:	48 8b 40 20          	mov    0x20(%rax),%rax
  802549:	48 85 c0             	test   %rax,%rax
  80254c:	74 16                	je     802564 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80254e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802552:	48 8b 40 20          	mov    0x20(%rax),%rax
  802556:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80255a:	48 89 d7             	mov    %rdx,%rdi
  80255d:	ff d0                	callq  *%rax
  80255f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802562:	eb 07                	jmp    80256b <fd_close+0xac>
		else
			r = 0;
  802564:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80256b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80256f:	48 89 c6             	mov    %rax,%rsi
  802572:	bf 00 00 00 00       	mov    $0x0,%edi
  802577:	48 b8 a1 1a 80 00 00 	movabs $0x801aa1,%rax
  80257e:	00 00 00 
  802581:	ff d0                	callq  *%rax
	return r;
  802583:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802586:	c9                   	leaveq 
  802587:	c3                   	retq   

0000000000802588 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802588:	55                   	push   %rbp
  802589:	48 89 e5             	mov    %rsp,%rbp
  80258c:	48 83 ec 20          	sub    $0x20,%rsp
  802590:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802593:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802597:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80259e:	eb 41                	jmp    8025e1 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8025a0:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8025a7:	00 00 00 
  8025aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025ad:	48 63 d2             	movslq %edx,%rdx
  8025b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025b4:	8b 00                	mov    (%rax),%eax
  8025b6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8025b9:	75 22                	jne    8025dd <dev_lookup+0x55>
			*dev = devtab[i];
  8025bb:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8025c2:	00 00 00 
  8025c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025c8:	48 63 d2             	movslq %edx,%rdx
  8025cb:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8025cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025d3:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025db:	eb 60                	jmp    80263d <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8025dd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025e1:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8025e8:	00 00 00 
  8025eb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025ee:	48 63 d2             	movslq %edx,%rdx
  8025f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025f5:	48 85 c0             	test   %rax,%rax
  8025f8:	75 a6                	jne    8025a0 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8025fa:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802601:	00 00 00 
  802604:	48 8b 00             	mov    (%rax),%rax
  802607:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80260d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802610:	89 c6                	mov    %eax,%esi
  802612:	48 bf 50 41 80 00 00 	movabs $0x804150,%rdi
  802619:	00 00 00 
  80261c:	b8 00 00 00 00       	mov    $0x0,%eax
  802621:	48 b9 1f 03 80 00 00 	movabs $0x80031f,%rcx
  802628:	00 00 00 
  80262b:	ff d1                	callq  *%rcx
	*dev = 0;
  80262d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802631:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802638:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80263d:	c9                   	leaveq 
  80263e:	c3                   	retq   

000000000080263f <close>:

int
close(int fdnum)
{
  80263f:	55                   	push   %rbp
  802640:	48 89 e5             	mov    %rsp,%rbp
  802643:	48 83 ec 20          	sub    $0x20,%rsp
  802647:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80264a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80264e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802651:	48 89 d6             	mov    %rdx,%rsi
  802654:	89 c7                	mov    %eax,%edi
  802656:	48 b8 2f 24 80 00 00 	movabs $0x80242f,%rax
  80265d:	00 00 00 
  802660:	ff d0                	callq  *%rax
  802662:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802665:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802669:	79 05                	jns    802670 <close+0x31>
		return r;
  80266b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80266e:	eb 18                	jmp    802688 <close+0x49>
	else
		return fd_close(fd, 1);
  802670:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802674:	be 01 00 00 00       	mov    $0x1,%esi
  802679:	48 89 c7             	mov    %rax,%rdi
  80267c:	48 b8 bf 24 80 00 00 	movabs $0x8024bf,%rax
  802683:	00 00 00 
  802686:	ff d0                	callq  *%rax
}
  802688:	c9                   	leaveq 
  802689:	c3                   	retq   

000000000080268a <close_all>:

void
close_all(void)
{
  80268a:	55                   	push   %rbp
  80268b:	48 89 e5             	mov    %rsp,%rbp
  80268e:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802692:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802699:	eb 15                	jmp    8026b0 <close_all+0x26>
		close(i);
  80269b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269e:	89 c7                	mov    %eax,%edi
  8026a0:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  8026a7:	00 00 00 
  8026aa:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8026ac:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026b0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026b4:	7e e5                	jle    80269b <close_all+0x11>
		close(i);
}
  8026b6:	c9                   	leaveq 
  8026b7:	c3                   	retq   

00000000008026b8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8026b8:	55                   	push   %rbp
  8026b9:	48 89 e5             	mov    %rsp,%rbp
  8026bc:	48 83 ec 40          	sub    $0x40,%rsp
  8026c0:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8026c3:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8026c6:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8026ca:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8026cd:	48 89 d6             	mov    %rdx,%rsi
  8026d0:	89 c7                	mov    %eax,%edi
  8026d2:	48 b8 2f 24 80 00 00 	movabs $0x80242f,%rax
  8026d9:	00 00 00 
  8026dc:	ff d0                	callq  *%rax
  8026de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026e5:	79 08                	jns    8026ef <dup+0x37>
		return r;
  8026e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ea:	e9 70 01 00 00       	jmpq   80285f <dup+0x1a7>
	close(newfdnum);
  8026ef:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026f2:	89 c7                	mov    %eax,%edi
  8026f4:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  8026fb:	00 00 00 
  8026fe:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802700:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802703:	48 98                	cltq   
  802705:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80270b:	48 c1 e0 0c          	shl    $0xc,%rax
  80270f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802713:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802717:	48 89 c7             	mov    %rax,%rdi
  80271a:	48 b8 6c 23 80 00 00 	movabs $0x80236c,%rax
  802721:	00 00 00 
  802724:	ff d0                	callq  *%rax
  802726:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80272a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80272e:	48 89 c7             	mov    %rax,%rdi
  802731:	48 b8 6c 23 80 00 00 	movabs $0x80236c,%rax
  802738:	00 00 00 
  80273b:	ff d0                	callq  *%rax
  80273d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802745:	48 c1 e8 15          	shr    $0x15,%rax
  802749:	48 89 c2             	mov    %rax,%rdx
  80274c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802753:	01 00 00 
  802756:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80275a:	83 e0 01             	and    $0x1,%eax
  80275d:	48 85 c0             	test   %rax,%rax
  802760:	74 73                	je     8027d5 <dup+0x11d>
  802762:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802766:	48 c1 e8 0c          	shr    $0xc,%rax
  80276a:	48 89 c2             	mov    %rax,%rdx
  80276d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802774:	01 00 00 
  802777:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80277b:	83 e0 01             	and    $0x1,%eax
  80277e:	48 85 c0             	test   %rax,%rax
  802781:	74 52                	je     8027d5 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802783:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802787:	48 c1 e8 0c          	shr    $0xc,%rax
  80278b:	48 89 c2             	mov    %rax,%rdx
  80278e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802795:	01 00 00 
  802798:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80279c:	25 07 0e 00 00       	and    $0xe07,%eax
  8027a1:	89 c1                	mov    %eax,%ecx
  8027a3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ab:	41 89 c8             	mov    %ecx,%r8d
  8027ae:	48 89 d1             	mov    %rdx,%rcx
  8027b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8027b6:	48 89 c6             	mov    %rax,%rsi
  8027b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8027be:	48 b8 46 1a 80 00 00 	movabs $0x801a46,%rax
  8027c5:	00 00 00 
  8027c8:	ff d0                	callq  *%rax
  8027ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d1:	79 02                	jns    8027d5 <dup+0x11d>
			goto err;
  8027d3:	eb 57                	jmp    80282c <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8027d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d9:	48 c1 e8 0c          	shr    $0xc,%rax
  8027dd:	48 89 c2             	mov    %rax,%rdx
  8027e0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027e7:	01 00 00 
  8027ea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027ee:	25 07 0e 00 00       	and    $0xe07,%eax
  8027f3:	89 c1                	mov    %eax,%ecx
  8027f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027fd:	41 89 c8             	mov    %ecx,%r8d
  802800:	48 89 d1             	mov    %rdx,%rcx
  802803:	ba 00 00 00 00       	mov    $0x0,%edx
  802808:	48 89 c6             	mov    %rax,%rsi
  80280b:	bf 00 00 00 00       	mov    $0x0,%edi
  802810:	48 b8 46 1a 80 00 00 	movabs $0x801a46,%rax
  802817:	00 00 00 
  80281a:	ff d0                	callq  *%rax
  80281c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80281f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802823:	79 02                	jns    802827 <dup+0x16f>
		goto err;
  802825:	eb 05                	jmp    80282c <dup+0x174>

	return newfdnum;
  802827:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80282a:	eb 33                	jmp    80285f <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80282c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802830:	48 89 c6             	mov    %rax,%rsi
  802833:	bf 00 00 00 00       	mov    $0x0,%edi
  802838:	48 b8 a1 1a 80 00 00 	movabs $0x801aa1,%rax
  80283f:	00 00 00 
  802842:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802844:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802848:	48 89 c6             	mov    %rax,%rsi
  80284b:	bf 00 00 00 00       	mov    $0x0,%edi
  802850:	48 b8 a1 1a 80 00 00 	movabs $0x801aa1,%rax
  802857:	00 00 00 
  80285a:	ff d0                	callq  *%rax
	return r;
  80285c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80285f:	c9                   	leaveq 
  802860:	c3                   	retq   

0000000000802861 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802861:	55                   	push   %rbp
  802862:	48 89 e5             	mov    %rsp,%rbp
  802865:	48 83 ec 40          	sub    $0x40,%rsp
  802869:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80286c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802870:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802874:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802878:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80287b:	48 89 d6             	mov    %rdx,%rsi
  80287e:	89 c7                	mov    %eax,%edi
  802880:	48 b8 2f 24 80 00 00 	movabs $0x80242f,%rax
  802887:	00 00 00 
  80288a:	ff d0                	callq  *%rax
  80288c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80288f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802893:	78 24                	js     8028b9 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802895:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802899:	8b 00                	mov    (%rax),%eax
  80289b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80289f:	48 89 d6             	mov    %rdx,%rsi
  8028a2:	89 c7                	mov    %eax,%edi
  8028a4:	48 b8 88 25 80 00 00 	movabs $0x802588,%rax
  8028ab:	00 00 00 
  8028ae:	ff d0                	callq  *%rax
  8028b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b7:	79 05                	jns    8028be <read+0x5d>
		return r;
  8028b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028bc:	eb 76                	jmp    802934 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8028be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c2:	8b 40 08             	mov    0x8(%rax),%eax
  8028c5:	83 e0 03             	and    $0x3,%eax
  8028c8:	83 f8 01             	cmp    $0x1,%eax
  8028cb:	75 3a                	jne    802907 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8028cd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8028d4:	00 00 00 
  8028d7:	48 8b 00             	mov    (%rax),%rax
  8028da:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028e0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028e3:	89 c6                	mov    %eax,%esi
  8028e5:	48 bf 6f 41 80 00 00 	movabs $0x80416f,%rdi
  8028ec:	00 00 00 
  8028ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f4:	48 b9 1f 03 80 00 00 	movabs $0x80031f,%rcx
  8028fb:	00 00 00 
  8028fe:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802900:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802905:	eb 2d                	jmp    802934 <read+0xd3>
	}
	if (!dev->dev_read)
  802907:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80290b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80290f:	48 85 c0             	test   %rax,%rax
  802912:	75 07                	jne    80291b <read+0xba>
		return -E_NOT_SUPP;
  802914:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802919:	eb 19                	jmp    802934 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80291b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80291f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802923:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802927:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80292b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80292f:	48 89 cf             	mov    %rcx,%rdi
  802932:	ff d0                	callq  *%rax
}
  802934:	c9                   	leaveq 
  802935:	c3                   	retq   

0000000000802936 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802936:	55                   	push   %rbp
  802937:	48 89 e5             	mov    %rsp,%rbp
  80293a:	48 83 ec 30          	sub    $0x30,%rsp
  80293e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802941:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802945:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802949:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802950:	eb 49                	jmp    80299b <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802952:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802955:	48 98                	cltq   
  802957:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80295b:	48 29 c2             	sub    %rax,%rdx
  80295e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802961:	48 63 c8             	movslq %eax,%rcx
  802964:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802968:	48 01 c1             	add    %rax,%rcx
  80296b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80296e:	48 89 ce             	mov    %rcx,%rsi
  802971:	89 c7                	mov    %eax,%edi
  802973:	48 b8 61 28 80 00 00 	movabs $0x802861,%rax
  80297a:	00 00 00 
  80297d:	ff d0                	callq  *%rax
  80297f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802982:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802986:	79 05                	jns    80298d <readn+0x57>
			return m;
  802988:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80298b:	eb 1c                	jmp    8029a9 <readn+0x73>
		if (m == 0)
  80298d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802991:	75 02                	jne    802995 <readn+0x5f>
			break;
  802993:	eb 11                	jmp    8029a6 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802995:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802998:	01 45 fc             	add    %eax,-0x4(%rbp)
  80299b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80299e:	48 98                	cltq   
  8029a0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029a4:	72 ac                	jb     802952 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8029a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029a9:	c9                   	leaveq 
  8029aa:	c3                   	retq   

00000000008029ab <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8029ab:	55                   	push   %rbp
  8029ac:	48 89 e5             	mov    %rsp,%rbp
  8029af:	48 83 ec 40          	sub    $0x40,%rsp
  8029b3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029b6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029ba:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029be:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029c2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029c5:	48 89 d6             	mov    %rdx,%rsi
  8029c8:	89 c7                	mov    %eax,%edi
  8029ca:	48 b8 2f 24 80 00 00 	movabs $0x80242f,%rax
  8029d1:	00 00 00 
  8029d4:	ff d0                	callq  *%rax
  8029d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029dd:	78 24                	js     802a03 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e3:	8b 00                	mov    (%rax),%eax
  8029e5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029e9:	48 89 d6             	mov    %rdx,%rsi
  8029ec:	89 c7                	mov    %eax,%edi
  8029ee:	48 b8 88 25 80 00 00 	movabs $0x802588,%rax
  8029f5:	00 00 00 
  8029f8:	ff d0                	callq  *%rax
  8029fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a01:	79 05                	jns    802a08 <write+0x5d>
		return r;
  802a03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a06:	eb 75                	jmp    802a7d <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a0c:	8b 40 08             	mov    0x8(%rax),%eax
  802a0f:	83 e0 03             	and    $0x3,%eax
  802a12:	85 c0                	test   %eax,%eax
  802a14:	75 3a                	jne    802a50 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a16:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802a1d:	00 00 00 
  802a20:	48 8b 00             	mov    (%rax),%rax
  802a23:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a29:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a2c:	89 c6                	mov    %eax,%esi
  802a2e:	48 bf 8b 41 80 00 00 	movabs $0x80418b,%rdi
  802a35:	00 00 00 
  802a38:	b8 00 00 00 00       	mov    $0x0,%eax
  802a3d:	48 b9 1f 03 80 00 00 	movabs $0x80031f,%rcx
  802a44:	00 00 00 
  802a47:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a4e:	eb 2d                	jmp    802a7d <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802a50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a54:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a58:	48 85 c0             	test   %rax,%rax
  802a5b:	75 07                	jne    802a64 <write+0xb9>
		return -E_NOT_SUPP;
  802a5d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a62:	eb 19                	jmp    802a7d <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802a64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a68:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a6c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a70:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a74:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a78:	48 89 cf             	mov    %rcx,%rdi
  802a7b:	ff d0                	callq  *%rax
}
  802a7d:	c9                   	leaveq 
  802a7e:	c3                   	retq   

0000000000802a7f <seek>:

int
seek(int fdnum, off_t offset)
{
  802a7f:	55                   	push   %rbp
  802a80:	48 89 e5             	mov    %rsp,%rbp
  802a83:	48 83 ec 18          	sub    $0x18,%rsp
  802a87:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a8a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a8d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a91:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a94:	48 89 d6             	mov    %rdx,%rsi
  802a97:	89 c7                	mov    %eax,%edi
  802a99:	48 b8 2f 24 80 00 00 	movabs $0x80242f,%rax
  802aa0:	00 00 00 
  802aa3:	ff d0                	callq  *%rax
  802aa5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aac:	79 05                	jns    802ab3 <seek+0x34>
		return r;
  802aae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab1:	eb 0f                	jmp    802ac2 <seek+0x43>
	fd->fd_offset = offset;
  802ab3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802aba:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802abd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ac2:	c9                   	leaveq 
  802ac3:	c3                   	retq   

0000000000802ac4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802ac4:	55                   	push   %rbp
  802ac5:	48 89 e5             	mov    %rsp,%rbp
  802ac8:	48 83 ec 30          	sub    $0x30,%rsp
  802acc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802acf:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ad2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ad6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ad9:	48 89 d6             	mov    %rdx,%rsi
  802adc:	89 c7                	mov    %eax,%edi
  802ade:	48 b8 2f 24 80 00 00 	movabs $0x80242f,%rax
  802ae5:	00 00 00 
  802ae8:	ff d0                	callq  *%rax
  802aea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af1:	78 24                	js     802b17 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802af3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af7:	8b 00                	mov    (%rax),%eax
  802af9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802afd:	48 89 d6             	mov    %rdx,%rsi
  802b00:	89 c7                	mov    %eax,%edi
  802b02:	48 b8 88 25 80 00 00 	movabs $0x802588,%rax
  802b09:	00 00 00 
  802b0c:	ff d0                	callq  *%rax
  802b0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b15:	79 05                	jns    802b1c <ftruncate+0x58>
		return r;
  802b17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1a:	eb 72                	jmp    802b8e <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b20:	8b 40 08             	mov    0x8(%rax),%eax
  802b23:	83 e0 03             	and    $0x3,%eax
  802b26:	85 c0                	test   %eax,%eax
  802b28:	75 3a                	jne    802b64 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802b2a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802b31:	00 00 00 
  802b34:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b37:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b3d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b40:	89 c6                	mov    %eax,%esi
  802b42:	48 bf a8 41 80 00 00 	movabs $0x8041a8,%rdi
  802b49:	00 00 00 
  802b4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b51:	48 b9 1f 03 80 00 00 	movabs $0x80031f,%rcx
  802b58:	00 00 00 
  802b5b:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802b5d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b62:	eb 2a                	jmp    802b8e <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b68:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b6c:	48 85 c0             	test   %rax,%rax
  802b6f:	75 07                	jne    802b78 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b71:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b76:	eb 16                	jmp    802b8e <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b7c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b80:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b84:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802b87:	89 ce                	mov    %ecx,%esi
  802b89:	48 89 d7             	mov    %rdx,%rdi
  802b8c:	ff d0                	callq  *%rax
}
  802b8e:	c9                   	leaveq 
  802b8f:	c3                   	retq   

0000000000802b90 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b90:	55                   	push   %rbp
  802b91:	48 89 e5             	mov    %rsp,%rbp
  802b94:	48 83 ec 30          	sub    $0x30,%rsp
  802b98:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b9b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b9f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ba3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ba6:	48 89 d6             	mov    %rdx,%rsi
  802ba9:	89 c7                	mov    %eax,%edi
  802bab:	48 b8 2f 24 80 00 00 	movabs $0x80242f,%rax
  802bb2:	00 00 00 
  802bb5:	ff d0                	callq  *%rax
  802bb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bbe:	78 24                	js     802be4 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc4:	8b 00                	mov    (%rax),%eax
  802bc6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bca:	48 89 d6             	mov    %rdx,%rsi
  802bcd:	89 c7                	mov    %eax,%edi
  802bcf:	48 b8 88 25 80 00 00 	movabs $0x802588,%rax
  802bd6:	00 00 00 
  802bd9:	ff d0                	callq  *%rax
  802bdb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be2:	79 05                	jns    802be9 <fstat+0x59>
		return r;
  802be4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be7:	eb 5e                	jmp    802c47 <fstat+0xb7>
	if (!dev->dev_stat)
  802be9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bed:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bf1:	48 85 c0             	test   %rax,%rax
  802bf4:	75 07                	jne    802bfd <fstat+0x6d>
		return -E_NOT_SUPP;
  802bf6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bfb:	eb 4a                	jmp    802c47 <fstat+0xb7>
	stat->st_name[0] = 0;
  802bfd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c01:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802c04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c08:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802c0f:	00 00 00 
	stat->st_isdir = 0;
  802c12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c16:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c1d:	00 00 00 
	stat->st_dev = dev;
  802c20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c24:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c28:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802c2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c33:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c37:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c3b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c3f:	48 89 ce             	mov    %rcx,%rsi
  802c42:	48 89 d7             	mov    %rdx,%rdi
  802c45:	ff d0                	callq  *%rax
}
  802c47:	c9                   	leaveq 
  802c48:	c3                   	retq   

0000000000802c49 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c49:	55                   	push   %rbp
  802c4a:	48 89 e5             	mov    %rsp,%rbp
  802c4d:	48 83 ec 20          	sub    $0x20,%rsp
  802c51:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c55:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802c59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5d:	be 00 00 00 00       	mov    $0x0,%esi
  802c62:	48 89 c7             	mov    %rax,%rdi
  802c65:	48 b8 37 2d 80 00 00 	movabs $0x802d37,%rax
  802c6c:	00 00 00 
  802c6f:	ff d0                	callq  *%rax
  802c71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c78:	79 05                	jns    802c7f <stat+0x36>
		return fd;
  802c7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c7d:	eb 2f                	jmp    802cae <stat+0x65>
	r = fstat(fd, stat);
  802c7f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c86:	48 89 d6             	mov    %rdx,%rsi
  802c89:	89 c7                	mov    %eax,%edi
  802c8b:	48 b8 90 2b 80 00 00 	movabs $0x802b90,%rax
  802c92:	00 00 00 
  802c95:	ff d0                	callq  *%rax
  802c97:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9d:	89 c7                	mov    %eax,%edi
  802c9f:	48 b8 3f 26 80 00 00 	movabs $0x80263f,%rax
  802ca6:	00 00 00 
  802ca9:	ff d0                	callq  *%rax
	return r;
  802cab:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802cae:	c9                   	leaveq 
  802caf:	c3                   	retq   

0000000000802cb0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802cb0:	55                   	push   %rbp
  802cb1:	48 89 e5             	mov    %rsp,%rbp
  802cb4:	48 83 ec 10          	sub    $0x10,%rsp
  802cb8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cbb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802cbf:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802cc6:	00 00 00 
  802cc9:	8b 00                	mov    (%rax),%eax
  802ccb:	85 c0                	test   %eax,%eax
  802ccd:	75 1d                	jne    802cec <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802ccf:	bf 01 00 00 00       	mov    $0x1,%edi
  802cd4:	48 b8 c7 22 80 00 00 	movabs $0x8022c7,%rax
  802cdb:	00 00 00 
  802cde:	ff d0                	callq  *%rax
  802ce0:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  802ce7:	00 00 00 
  802cea:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802cec:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802cf3:	00 00 00 
  802cf6:	8b 00                	mov    (%rax),%eax
  802cf8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802cfb:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d00:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802d07:	00 00 00 
  802d0a:	89 c7                	mov    %eax,%edi
  802d0c:	48 b8 2f 22 80 00 00 	movabs $0x80222f,%rax
  802d13:	00 00 00 
  802d16:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802d18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d1c:	ba 00 00 00 00       	mov    $0x0,%edx
  802d21:	48 89 c6             	mov    %rax,%rsi
  802d24:	bf 00 00 00 00       	mov    $0x0,%edi
  802d29:	48 b8 66 21 80 00 00 	movabs $0x802166,%rax
  802d30:	00 00 00 
  802d33:	ff d0                	callq  *%rax
}
  802d35:	c9                   	leaveq 
  802d36:	c3                   	retq   

0000000000802d37 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802d37:	55                   	push   %rbp
  802d38:	48 89 e5             	mov    %rsp,%rbp
  802d3b:	48 83 ec 20          	sub    $0x20,%rsp
  802d3f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d43:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802d46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d4a:	48 89 c7             	mov    %rax,%rdi
  802d4d:	48 b8 5b 10 80 00 00 	movabs $0x80105b,%rax
  802d54:	00 00 00 
  802d57:	ff d0                	callq  *%rax
  802d59:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802d5e:	7e 0a                	jle    802d6a <open+0x33>
		return -E_BAD_PATH;
  802d60:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d65:	e9 a5 00 00 00       	jmpq   802e0f <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802d6a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d6e:	48 89 c7             	mov    %rax,%rdi
  802d71:	48 b8 97 23 80 00 00 	movabs $0x802397,%rax
  802d78:	00 00 00 
  802d7b:	ff d0                	callq  *%rax
  802d7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d84:	79 08                	jns    802d8e <open+0x57>
		return r;
  802d86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d89:	e9 81 00 00 00       	jmpq   802e0f <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802d8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d92:	48 89 c6             	mov    %rax,%rsi
  802d95:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802d9c:	00 00 00 
  802d9f:	48 b8 c7 10 80 00 00 	movabs $0x8010c7,%rax
  802da6:	00 00 00 
  802da9:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802dab:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802db2:	00 00 00 
  802db5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802db8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802dbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc2:	48 89 c6             	mov    %rax,%rsi
  802dc5:	bf 01 00 00 00       	mov    $0x1,%edi
  802dca:	48 b8 b0 2c 80 00 00 	movabs $0x802cb0,%rax
  802dd1:	00 00 00 
  802dd4:	ff d0                	callq  *%rax
  802dd6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ddd:	79 1d                	jns    802dfc <open+0xc5>
		fd_close(fd, 0);
  802ddf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de3:	be 00 00 00 00       	mov    $0x0,%esi
  802de8:	48 89 c7             	mov    %rax,%rdi
  802deb:	48 b8 bf 24 80 00 00 	movabs $0x8024bf,%rax
  802df2:	00 00 00 
  802df5:	ff d0                	callq  *%rax
		return r;
  802df7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfa:	eb 13                	jmp    802e0f <open+0xd8>
	}

	return fd2num(fd);
  802dfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e00:	48 89 c7             	mov    %rax,%rdi
  802e03:	48 b8 49 23 80 00 00 	movabs $0x802349,%rax
  802e0a:	00 00 00 
  802e0d:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802e0f:	c9                   	leaveq 
  802e10:	c3                   	retq   

0000000000802e11 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e11:	55                   	push   %rbp
  802e12:	48 89 e5             	mov    %rsp,%rbp
  802e15:	48 83 ec 10          	sub    $0x10,%rsp
  802e19:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e21:	8b 50 0c             	mov    0xc(%rax),%edx
  802e24:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e2b:	00 00 00 
  802e2e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e30:	be 00 00 00 00       	mov    $0x0,%esi
  802e35:	bf 06 00 00 00       	mov    $0x6,%edi
  802e3a:	48 b8 b0 2c 80 00 00 	movabs $0x802cb0,%rax
  802e41:	00 00 00 
  802e44:	ff d0                	callq  *%rax
}
  802e46:	c9                   	leaveq 
  802e47:	c3                   	retq   

0000000000802e48 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e48:	55                   	push   %rbp
  802e49:	48 89 e5             	mov    %rsp,%rbp
  802e4c:	48 83 ec 30          	sub    $0x30,%rsp
  802e50:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e54:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e58:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e60:	8b 50 0c             	mov    0xc(%rax),%edx
  802e63:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e6a:	00 00 00 
  802e6d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e6f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e76:	00 00 00 
  802e79:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e7d:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802e81:	be 00 00 00 00       	mov    $0x0,%esi
  802e86:	bf 03 00 00 00       	mov    $0x3,%edi
  802e8b:	48 b8 b0 2c 80 00 00 	movabs $0x802cb0,%rax
  802e92:	00 00 00 
  802e95:	ff d0                	callq  *%rax
  802e97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e9e:	79 05                	jns    802ea5 <devfile_read+0x5d>
		return r;
  802ea0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea3:	eb 26                	jmp    802ecb <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802ea5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea8:	48 63 d0             	movslq %eax,%rdx
  802eab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eaf:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802eb6:	00 00 00 
  802eb9:	48 89 c7             	mov    %rax,%rdi
  802ebc:	48 b8 eb 13 80 00 00 	movabs $0x8013eb,%rax
  802ec3:	00 00 00 
  802ec6:	ff d0                	callq  *%rax

	return r;
  802ec8:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802ecb:	c9                   	leaveq 
  802ecc:	c3                   	retq   

0000000000802ecd <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802ecd:	55                   	push   %rbp
  802ece:	48 89 e5             	mov    %rsp,%rbp
  802ed1:	48 83 ec 30          	sub    $0x30,%rsp
  802ed5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ed9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802edd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802ee1:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802ee8:	00 
  802ee9:	76 08                	jbe    802ef3 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802eeb:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802ef2:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802ef3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef7:	8b 50 0c             	mov    0xc(%rax),%edx
  802efa:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f01:	00 00 00 
  802f04:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802f06:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f0d:	00 00 00 
  802f10:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f14:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  802f18:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f20:	48 89 c6             	mov    %rax,%rsi
  802f23:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802f2a:	00 00 00 
  802f2d:	48 b8 eb 13 80 00 00 	movabs $0x8013eb,%rax
  802f34:	00 00 00 
  802f37:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802f39:	be 00 00 00 00       	mov    $0x0,%esi
  802f3e:	bf 04 00 00 00       	mov    $0x4,%edi
  802f43:	48 b8 b0 2c 80 00 00 	movabs $0x802cb0,%rax
  802f4a:	00 00 00 
  802f4d:	ff d0                	callq  *%rax
  802f4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f56:	79 05                	jns    802f5d <devfile_write+0x90>
		return r;
  802f58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f5b:	eb 03                	jmp    802f60 <devfile_write+0x93>

	return r;
  802f5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802f60:	c9                   	leaveq 
  802f61:	c3                   	retq   

0000000000802f62 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802f62:	55                   	push   %rbp
  802f63:	48 89 e5             	mov    %rsp,%rbp
  802f66:	48 83 ec 20          	sub    $0x20,%rsp
  802f6a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f6e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f76:	8b 50 0c             	mov    0xc(%rax),%edx
  802f79:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f80:	00 00 00 
  802f83:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f85:	be 00 00 00 00       	mov    $0x0,%esi
  802f8a:	bf 05 00 00 00       	mov    $0x5,%edi
  802f8f:	48 b8 b0 2c 80 00 00 	movabs $0x802cb0,%rax
  802f96:	00 00 00 
  802f99:	ff d0                	callq  *%rax
  802f9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa2:	79 05                	jns    802fa9 <devfile_stat+0x47>
		return r;
  802fa4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa7:	eb 56                	jmp    802fff <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802fa9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fad:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802fb4:	00 00 00 
  802fb7:	48 89 c7             	mov    %rax,%rdi
  802fba:	48 b8 c7 10 80 00 00 	movabs $0x8010c7,%rax
  802fc1:	00 00 00 
  802fc4:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802fc6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802fcd:	00 00 00 
  802fd0:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802fd6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fda:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802fe0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802fe7:	00 00 00 
  802fea:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802ff0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ff4:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802ffa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fff:	c9                   	leaveq 
  803000:	c3                   	retq   

0000000000803001 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803001:	55                   	push   %rbp
  803002:	48 89 e5             	mov    %rsp,%rbp
  803005:	48 83 ec 10          	sub    $0x10,%rsp
  803009:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80300d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803010:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803014:	8b 50 0c             	mov    0xc(%rax),%edx
  803017:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80301e:	00 00 00 
  803021:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803023:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80302a:	00 00 00 
  80302d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803030:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803033:	be 00 00 00 00       	mov    $0x0,%esi
  803038:	bf 02 00 00 00       	mov    $0x2,%edi
  80303d:	48 b8 b0 2c 80 00 00 	movabs $0x802cb0,%rax
  803044:	00 00 00 
  803047:	ff d0                	callq  *%rax
}
  803049:	c9                   	leaveq 
  80304a:	c3                   	retq   

000000000080304b <remove>:

// Delete a file
int
remove(const char *path)
{
  80304b:	55                   	push   %rbp
  80304c:	48 89 e5             	mov    %rsp,%rbp
  80304f:	48 83 ec 10          	sub    $0x10,%rsp
  803053:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803057:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80305b:	48 89 c7             	mov    %rax,%rdi
  80305e:	48 b8 5b 10 80 00 00 	movabs $0x80105b,%rax
  803065:	00 00 00 
  803068:	ff d0                	callq  *%rax
  80306a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80306f:	7e 07                	jle    803078 <remove+0x2d>
		return -E_BAD_PATH;
  803071:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803076:	eb 33                	jmp    8030ab <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803078:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80307c:	48 89 c6             	mov    %rax,%rsi
  80307f:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  803086:	00 00 00 
  803089:	48 b8 c7 10 80 00 00 	movabs $0x8010c7,%rax
  803090:	00 00 00 
  803093:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803095:	be 00 00 00 00       	mov    $0x0,%esi
  80309a:	bf 07 00 00 00       	mov    $0x7,%edi
  80309f:	48 b8 b0 2c 80 00 00 	movabs $0x802cb0,%rax
  8030a6:	00 00 00 
  8030a9:	ff d0                	callq  *%rax
}
  8030ab:	c9                   	leaveq 
  8030ac:	c3                   	retq   

00000000008030ad <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8030ad:	55                   	push   %rbp
  8030ae:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8030b1:	be 00 00 00 00       	mov    $0x0,%esi
  8030b6:	bf 08 00 00 00       	mov    $0x8,%edi
  8030bb:	48 b8 b0 2c 80 00 00 	movabs $0x802cb0,%rax
  8030c2:	00 00 00 
  8030c5:	ff d0                	callq  *%rax
}
  8030c7:	5d                   	pop    %rbp
  8030c8:	c3                   	retq   

00000000008030c9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8030c9:	55                   	push   %rbp
  8030ca:	48 89 e5             	mov    %rsp,%rbp
  8030cd:	53                   	push   %rbx
  8030ce:	48 83 ec 38          	sub    $0x38,%rsp
  8030d2:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8030d6:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8030da:	48 89 c7             	mov    %rax,%rdi
  8030dd:	48 b8 97 23 80 00 00 	movabs $0x802397,%rax
  8030e4:	00 00 00 
  8030e7:	ff d0                	callq  *%rax
  8030e9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030f0:	0f 88 bf 01 00 00    	js     8032b5 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030fa:	ba 07 04 00 00       	mov    $0x407,%edx
  8030ff:	48 89 c6             	mov    %rax,%rsi
  803102:	bf 00 00 00 00       	mov    $0x0,%edi
  803107:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  80310e:	00 00 00 
  803111:	ff d0                	callq  *%rax
  803113:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803116:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80311a:	0f 88 95 01 00 00    	js     8032b5 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803120:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803124:	48 89 c7             	mov    %rax,%rdi
  803127:	48 b8 97 23 80 00 00 	movabs $0x802397,%rax
  80312e:	00 00 00 
  803131:	ff d0                	callq  *%rax
  803133:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803136:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80313a:	0f 88 5d 01 00 00    	js     80329d <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803140:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803144:	ba 07 04 00 00       	mov    $0x407,%edx
  803149:	48 89 c6             	mov    %rax,%rsi
  80314c:	bf 00 00 00 00       	mov    $0x0,%edi
  803151:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  803158:	00 00 00 
  80315b:	ff d0                	callq  *%rax
  80315d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803160:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803164:	0f 88 33 01 00 00    	js     80329d <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80316a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80316e:	48 89 c7             	mov    %rax,%rdi
  803171:	48 b8 6c 23 80 00 00 	movabs $0x80236c,%rax
  803178:	00 00 00 
  80317b:	ff d0                	callq  *%rax
  80317d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803181:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803185:	ba 07 04 00 00       	mov    $0x407,%edx
  80318a:	48 89 c6             	mov    %rax,%rsi
  80318d:	bf 00 00 00 00       	mov    $0x0,%edi
  803192:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  803199:	00 00 00 
  80319c:	ff d0                	callq  *%rax
  80319e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031a5:	79 05                	jns    8031ac <pipe+0xe3>
		goto err2;
  8031a7:	e9 d9 00 00 00       	jmpq   803285 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031b0:	48 89 c7             	mov    %rax,%rdi
  8031b3:	48 b8 6c 23 80 00 00 	movabs $0x80236c,%rax
  8031ba:	00 00 00 
  8031bd:	ff d0                	callq  *%rax
  8031bf:	48 89 c2             	mov    %rax,%rdx
  8031c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031c6:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8031cc:	48 89 d1             	mov    %rdx,%rcx
  8031cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8031d4:	48 89 c6             	mov    %rax,%rsi
  8031d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8031dc:	48 b8 46 1a 80 00 00 	movabs $0x801a46,%rax
  8031e3:	00 00 00 
  8031e6:	ff d0                	callq  *%rax
  8031e8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031ef:	79 1b                	jns    80320c <pipe+0x143>
		goto err3;
  8031f1:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8031f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031f6:	48 89 c6             	mov    %rax,%rsi
  8031f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8031fe:	48 b8 a1 1a 80 00 00 	movabs $0x801aa1,%rax
  803205:	00 00 00 
  803208:	ff d0                	callq  *%rax
  80320a:	eb 79                	jmp    803285 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80320c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803210:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  803217:	00 00 00 
  80321a:	8b 12                	mov    (%rdx),%edx
  80321c:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80321e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803222:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803229:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80322d:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  803234:	00 00 00 
  803237:	8b 12                	mov    (%rdx),%edx
  803239:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80323b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80323f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803246:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80324a:	48 89 c7             	mov    %rax,%rdi
  80324d:	48 b8 49 23 80 00 00 	movabs $0x802349,%rax
  803254:	00 00 00 
  803257:	ff d0                	callq  *%rax
  803259:	89 c2                	mov    %eax,%edx
  80325b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80325f:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803261:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803265:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803269:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80326d:	48 89 c7             	mov    %rax,%rdi
  803270:	48 b8 49 23 80 00 00 	movabs $0x802349,%rax
  803277:	00 00 00 
  80327a:	ff d0                	callq  *%rax
  80327c:	89 03                	mov    %eax,(%rbx)
	return 0;
  80327e:	b8 00 00 00 00       	mov    $0x0,%eax
  803283:	eb 33                	jmp    8032b8 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803285:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803289:	48 89 c6             	mov    %rax,%rsi
  80328c:	bf 00 00 00 00       	mov    $0x0,%edi
  803291:	48 b8 a1 1a 80 00 00 	movabs $0x801aa1,%rax
  803298:	00 00 00 
  80329b:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  80329d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032a1:	48 89 c6             	mov    %rax,%rsi
  8032a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8032a9:	48 b8 a1 1a 80 00 00 	movabs $0x801aa1,%rax
  8032b0:	00 00 00 
  8032b3:	ff d0                	callq  *%rax
    err:
	return r;
  8032b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8032b8:	48 83 c4 38          	add    $0x38,%rsp
  8032bc:	5b                   	pop    %rbx
  8032bd:	5d                   	pop    %rbp
  8032be:	c3                   	retq   

00000000008032bf <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8032bf:	55                   	push   %rbp
  8032c0:	48 89 e5             	mov    %rsp,%rbp
  8032c3:	53                   	push   %rbx
  8032c4:	48 83 ec 28          	sub    $0x28,%rsp
  8032c8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032cc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8032d0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8032d7:	00 00 00 
  8032da:	48 8b 00             	mov    (%rax),%rax
  8032dd:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8032e3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8032e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032ea:	48 89 c7             	mov    %rax,%rdi
  8032ed:	48 b8 4e 3b 80 00 00 	movabs $0x803b4e,%rax
  8032f4:	00 00 00 
  8032f7:	ff d0                	callq  *%rax
  8032f9:	89 c3                	mov    %eax,%ebx
  8032fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032ff:	48 89 c7             	mov    %rax,%rdi
  803302:	48 b8 4e 3b 80 00 00 	movabs $0x803b4e,%rax
  803309:	00 00 00 
  80330c:	ff d0                	callq  *%rax
  80330e:	39 c3                	cmp    %eax,%ebx
  803310:	0f 94 c0             	sete   %al
  803313:	0f b6 c0             	movzbl %al,%eax
  803316:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803319:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803320:	00 00 00 
  803323:	48 8b 00             	mov    (%rax),%rax
  803326:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80332c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80332f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803332:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803335:	75 05                	jne    80333c <_pipeisclosed+0x7d>
			return ret;
  803337:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80333a:	eb 4f                	jmp    80338b <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80333c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80333f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803342:	74 42                	je     803386 <_pipeisclosed+0xc7>
  803344:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803348:	75 3c                	jne    803386 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80334a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803351:	00 00 00 
  803354:	48 8b 00             	mov    (%rax),%rax
  803357:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80335d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803360:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803363:	89 c6                	mov    %eax,%esi
  803365:	48 bf d3 41 80 00 00 	movabs $0x8041d3,%rdi
  80336c:	00 00 00 
  80336f:	b8 00 00 00 00       	mov    $0x0,%eax
  803374:	49 b8 1f 03 80 00 00 	movabs $0x80031f,%r8
  80337b:	00 00 00 
  80337e:	41 ff d0             	callq  *%r8
	}
  803381:	e9 4a ff ff ff       	jmpq   8032d0 <_pipeisclosed+0x11>
  803386:	e9 45 ff ff ff       	jmpq   8032d0 <_pipeisclosed+0x11>
}
  80338b:	48 83 c4 28          	add    $0x28,%rsp
  80338f:	5b                   	pop    %rbx
  803390:	5d                   	pop    %rbp
  803391:	c3                   	retq   

0000000000803392 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803392:	55                   	push   %rbp
  803393:	48 89 e5             	mov    %rsp,%rbp
  803396:	48 83 ec 30          	sub    $0x30,%rsp
  80339a:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80339d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8033a1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8033a4:	48 89 d6             	mov    %rdx,%rsi
  8033a7:	89 c7                	mov    %eax,%edi
  8033a9:	48 b8 2f 24 80 00 00 	movabs $0x80242f,%rax
  8033b0:	00 00 00 
  8033b3:	ff d0                	callq  *%rax
  8033b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033bc:	79 05                	jns    8033c3 <pipeisclosed+0x31>
		return r;
  8033be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033c1:	eb 31                	jmp    8033f4 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8033c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033c7:	48 89 c7             	mov    %rax,%rdi
  8033ca:	48 b8 6c 23 80 00 00 	movabs $0x80236c,%rax
  8033d1:	00 00 00 
  8033d4:	ff d0                	callq  *%rax
  8033d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8033da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033e2:	48 89 d6             	mov    %rdx,%rsi
  8033e5:	48 89 c7             	mov    %rax,%rdi
  8033e8:	48 b8 bf 32 80 00 00 	movabs $0x8032bf,%rax
  8033ef:	00 00 00 
  8033f2:	ff d0                	callq  *%rax
}
  8033f4:	c9                   	leaveq 
  8033f5:	c3                   	retq   

00000000008033f6 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8033f6:	55                   	push   %rbp
  8033f7:	48 89 e5             	mov    %rsp,%rbp
  8033fa:	48 83 ec 40          	sub    $0x40,%rsp
  8033fe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803402:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803406:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80340a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80340e:	48 89 c7             	mov    %rax,%rdi
  803411:	48 b8 6c 23 80 00 00 	movabs $0x80236c,%rax
  803418:	00 00 00 
  80341b:	ff d0                	callq  *%rax
  80341d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803421:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803425:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803429:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803430:	00 
  803431:	e9 92 00 00 00       	jmpq   8034c8 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803436:	eb 41                	jmp    803479 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803438:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80343d:	74 09                	je     803448 <devpipe_read+0x52>
				return i;
  80343f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803443:	e9 92 00 00 00       	jmpq   8034da <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803448:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80344c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803450:	48 89 d6             	mov    %rdx,%rsi
  803453:	48 89 c7             	mov    %rax,%rdi
  803456:	48 b8 bf 32 80 00 00 	movabs $0x8032bf,%rax
  80345d:	00 00 00 
  803460:	ff d0                	callq  *%rax
  803462:	85 c0                	test   %eax,%eax
  803464:	74 07                	je     80346d <devpipe_read+0x77>
				return 0;
  803466:	b8 00 00 00 00       	mov    $0x0,%eax
  80346b:	eb 6d                	jmp    8034da <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80346d:	48 b8 b8 19 80 00 00 	movabs $0x8019b8,%rax
  803474:	00 00 00 
  803477:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803479:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80347d:	8b 10                	mov    (%rax),%edx
  80347f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803483:	8b 40 04             	mov    0x4(%rax),%eax
  803486:	39 c2                	cmp    %eax,%edx
  803488:	74 ae                	je     803438 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80348a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80348e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803492:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803496:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80349a:	8b 00                	mov    (%rax),%eax
  80349c:	99                   	cltd   
  80349d:	c1 ea 1b             	shr    $0x1b,%edx
  8034a0:	01 d0                	add    %edx,%eax
  8034a2:	83 e0 1f             	and    $0x1f,%eax
  8034a5:	29 d0                	sub    %edx,%eax
  8034a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034ab:	48 98                	cltq   
  8034ad:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8034b2:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8034b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b8:	8b 00                	mov    (%rax),%eax
  8034ba:	8d 50 01             	lea    0x1(%rax),%edx
  8034bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034c1:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8034c3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8034c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034cc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8034d0:	0f 82 60 ff ff ff    	jb     803436 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8034d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8034da:	c9                   	leaveq 
  8034db:	c3                   	retq   

00000000008034dc <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8034dc:	55                   	push   %rbp
  8034dd:	48 89 e5             	mov    %rsp,%rbp
  8034e0:	48 83 ec 40          	sub    $0x40,%rsp
  8034e4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034e8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8034ec:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8034f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034f4:	48 89 c7             	mov    %rax,%rdi
  8034f7:	48 b8 6c 23 80 00 00 	movabs $0x80236c,%rax
  8034fe:	00 00 00 
  803501:	ff d0                	callq  *%rax
  803503:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803507:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80350b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80350f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803516:	00 
  803517:	e9 8e 00 00 00       	jmpq   8035aa <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80351c:	eb 31                	jmp    80354f <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80351e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803522:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803526:	48 89 d6             	mov    %rdx,%rsi
  803529:	48 89 c7             	mov    %rax,%rdi
  80352c:	48 b8 bf 32 80 00 00 	movabs $0x8032bf,%rax
  803533:	00 00 00 
  803536:	ff d0                	callq  *%rax
  803538:	85 c0                	test   %eax,%eax
  80353a:	74 07                	je     803543 <devpipe_write+0x67>
				return 0;
  80353c:	b8 00 00 00 00       	mov    $0x0,%eax
  803541:	eb 79                	jmp    8035bc <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803543:	48 b8 b8 19 80 00 00 	movabs $0x8019b8,%rax
  80354a:	00 00 00 
  80354d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80354f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803553:	8b 40 04             	mov    0x4(%rax),%eax
  803556:	48 63 d0             	movslq %eax,%rdx
  803559:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80355d:	8b 00                	mov    (%rax),%eax
  80355f:	48 98                	cltq   
  803561:	48 83 c0 20          	add    $0x20,%rax
  803565:	48 39 c2             	cmp    %rax,%rdx
  803568:	73 b4                	jae    80351e <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80356a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80356e:	8b 40 04             	mov    0x4(%rax),%eax
  803571:	99                   	cltd   
  803572:	c1 ea 1b             	shr    $0x1b,%edx
  803575:	01 d0                	add    %edx,%eax
  803577:	83 e0 1f             	and    $0x1f,%eax
  80357a:	29 d0                	sub    %edx,%eax
  80357c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803580:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803584:	48 01 ca             	add    %rcx,%rdx
  803587:	0f b6 0a             	movzbl (%rdx),%ecx
  80358a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80358e:	48 98                	cltq   
  803590:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803598:	8b 40 04             	mov    0x4(%rax),%eax
  80359b:	8d 50 01             	lea    0x1(%rax),%edx
  80359e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035a2:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8035a5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ae:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8035b2:	0f 82 64 ff ff ff    	jb     80351c <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8035b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8035bc:	c9                   	leaveq 
  8035bd:	c3                   	retq   

00000000008035be <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8035be:	55                   	push   %rbp
  8035bf:	48 89 e5             	mov    %rsp,%rbp
  8035c2:	48 83 ec 20          	sub    $0x20,%rsp
  8035c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8035ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035d2:	48 89 c7             	mov    %rax,%rdi
  8035d5:	48 b8 6c 23 80 00 00 	movabs $0x80236c,%rax
  8035dc:	00 00 00 
  8035df:	ff d0                	callq  *%rax
  8035e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8035e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035e9:	48 be e6 41 80 00 00 	movabs $0x8041e6,%rsi
  8035f0:	00 00 00 
  8035f3:	48 89 c7             	mov    %rax,%rdi
  8035f6:	48 b8 c7 10 80 00 00 	movabs $0x8010c7,%rax
  8035fd:	00 00 00 
  803600:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803602:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803606:	8b 50 04             	mov    0x4(%rax),%edx
  803609:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80360d:	8b 00                	mov    (%rax),%eax
  80360f:	29 c2                	sub    %eax,%edx
  803611:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803615:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80361b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80361f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803626:	00 00 00 
	stat->st_dev = &devpipe;
  803629:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80362d:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  803634:	00 00 00 
  803637:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80363e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803643:	c9                   	leaveq 
  803644:	c3                   	retq   

0000000000803645 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803645:	55                   	push   %rbp
  803646:	48 89 e5             	mov    %rsp,%rbp
  803649:	48 83 ec 10          	sub    $0x10,%rsp
  80364d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803651:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803655:	48 89 c6             	mov    %rax,%rsi
  803658:	bf 00 00 00 00       	mov    $0x0,%edi
  80365d:	48 b8 a1 1a 80 00 00 	movabs $0x801aa1,%rax
  803664:	00 00 00 
  803667:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803669:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80366d:	48 89 c7             	mov    %rax,%rdi
  803670:	48 b8 6c 23 80 00 00 	movabs $0x80236c,%rax
  803677:	00 00 00 
  80367a:	ff d0                	callq  *%rax
  80367c:	48 89 c6             	mov    %rax,%rsi
  80367f:	bf 00 00 00 00       	mov    $0x0,%edi
  803684:	48 b8 a1 1a 80 00 00 	movabs $0x801aa1,%rax
  80368b:	00 00 00 
  80368e:	ff d0                	callq  *%rax
}
  803690:	c9                   	leaveq 
  803691:	c3                   	retq   

0000000000803692 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803692:	55                   	push   %rbp
  803693:	48 89 e5             	mov    %rsp,%rbp
  803696:	48 83 ec 20          	sub    $0x20,%rsp
  80369a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80369d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036a0:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8036a3:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8036a7:	be 01 00 00 00       	mov    $0x1,%esi
  8036ac:	48 89 c7             	mov    %rax,%rdi
  8036af:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  8036b6:	00 00 00 
  8036b9:	ff d0                	callq  *%rax
}
  8036bb:	c9                   	leaveq 
  8036bc:	c3                   	retq   

00000000008036bd <getchar>:

int
getchar(void)
{
  8036bd:	55                   	push   %rbp
  8036be:	48 89 e5             	mov    %rsp,%rbp
  8036c1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8036c5:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8036c9:	ba 01 00 00 00       	mov    $0x1,%edx
  8036ce:	48 89 c6             	mov    %rax,%rsi
  8036d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8036d6:	48 b8 61 28 80 00 00 	movabs $0x802861,%rax
  8036dd:	00 00 00 
  8036e0:	ff d0                	callq  *%rax
  8036e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8036e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036e9:	79 05                	jns    8036f0 <getchar+0x33>
		return r;
  8036eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ee:	eb 14                	jmp    803704 <getchar+0x47>
	if (r < 1)
  8036f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036f4:	7f 07                	jg     8036fd <getchar+0x40>
		return -E_EOF;
  8036f6:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8036fb:	eb 07                	jmp    803704 <getchar+0x47>
	return c;
  8036fd:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803701:	0f b6 c0             	movzbl %al,%eax
}
  803704:	c9                   	leaveq 
  803705:	c3                   	retq   

0000000000803706 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803706:	55                   	push   %rbp
  803707:	48 89 e5             	mov    %rsp,%rbp
  80370a:	48 83 ec 20          	sub    $0x20,%rsp
  80370e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803711:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803715:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803718:	48 89 d6             	mov    %rdx,%rsi
  80371b:	89 c7                	mov    %eax,%edi
  80371d:	48 b8 2f 24 80 00 00 	movabs $0x80242f,%rax
  803724:	00 00 00 
  803727:	ff d0                	callq  *%rax
  803729:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80372c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803730:	79 05                	jns    803737 <iscons+0x31>
		return r;
  803732:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803735:	eb 1a                	jmp    803751 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803737:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80373b:	8b 10                	mov    (%rax),%edx
  80373d:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803744:	00 00 00 
  803747:	8b 00                	mov    (%rax),%eax
  803749:	39 c2                	cmp    %eax,%edx
  80374b:	0f 94 c0             	sete   %al
  80374e:	0f b6 c0             	movzbl %al,%eax
}
  803751:	c9                   	leaveq 
  803752:	c3                   	retq   

0000000000803753 <opencons>:

int
opencons(void)
{
  803753:	55                   	push   %rbp
  803754:	48 89 e5             	mov    %rsp,%rbp
  803757:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80375b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80375f:	48 89 c7             	mov    %rax,%rdi
  803762:	48 b8 97 23 80 00 00 	movabs $0x802397,%rax
  803769:	00 00 00 
  80376c:	ff d0                	callq  *%rax
  80376e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803771:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803775:	79 05                	jns    80377c <opencons+0x29>
		return r;
  803777:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80377a:	eb 5b                	jmp    8037d7 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80377c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803780:	ba 07 04 00 00       	mov    $0x407,%edx
  803785:	48 89 c6             	mov    %rax,%rsi
  803788:	bf 00 00 00 00       	mov    $0x0,%edi
  80378d:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  803794:	00 00 00 
  803797:	ff d0                	callq  *%rax
  803799:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80379c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037a0:	79 05                	jns    8037a7 <opencons+0x54>
		return r;
  8037a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a5:	eb 30                	jmp    8037d7 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8037a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ab:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8037b2:	00 00 00 
  8037b5:	8b 12                	mov    (%rdx),%edx
  8037b7:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8037b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037bd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8037c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c8:	48 89 c7             	mov    %rax,%rdi
  8037cb:	48 b8 49 23 80 00 00 	movabs $0x802349,%rax
  8037d2:	00 00 00 
  8037d5:	ff d0                	callq  *%rax
}
  8037d7:	c9                   	leaveq 
  8037d8:	c3                   	retq   

00000000008037d9 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8037d9:	55                   	push   %rbp
  8037da:	48 89 e5             	mov    %rsp,%rbp
  8037dd:	48 83 ec 30          	sub    $0x30,%rsp
  8037e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8037ed:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8037f2:	75 07                	jne    8037fb <devcons_read+0x22>
		return 0;
  8037f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8037f9:	eb 4b                	jmp    803846 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8037fb:	eb 0c                	jmp    803809 <devcons_read+0x30>
		sys_yield();
  8037fd:	48 b8 b8 19 80 00 00 	movabs $0x8019b8,%rax
  803804:	00 00 00 
  803807:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803809:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  803810:	00 00 00 
  803813:	ff d0                	callq  *%rax
  803815:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803818:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80381c:	74 df                	je     8037fd <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80381e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803822:	79 05                	jns    803829 <devcons_read+0x50>
		return c;
  803824:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803827:	eb 1d                	jmp    803846 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803829:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80382d:	75 07                	jne    803836 <devcons_read+0x5d>
		return 0;
  80382f:	b8 00 00 00 00       	mov    $0x0,%eax
  803834:	eb 10                	jmp    803846 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803836:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803839:	89 c2                	mov    %eax,%edx
  80383b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80383f:	88 10                	mov    %dl,(%rax)
	return 1;
  803841:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803846:	c9                   	leaveq 
  803847:	c3                   	retq   

0000000000803848 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803848:	55                   	push   %rbp
  803849:	48 89 e5             	mov    %rsp,%rbp
  80384c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803853:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80385a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803861:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803868:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80386f:	eb 76                	jmp    8038e7 <devcons_write+0x9f>
		m = n - tot;
  803871:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803878:	89 c2                	mov    %eax,%edx
  80387a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80387d:	29 c2                	sub    %eax,%edx
  80387f:	89 d0                	mov    %edx,%eax
  803881:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803884:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803887:	83 f8 7f             	cmp    $0x7f,%eax
  80388a:	76 07                	jbe    803893 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80388c:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803893:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803896:	48 63 d0             	movslq %eax,%rdx
  803899:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80389c:	48 63 c8             	movslq %eax,%rcx
  80389f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8038a6:	48 01 c1             	add    %rax,%rcx
  8038a9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8038b0:	48 89 ce             	mov    %rcx,%rsi
  8038b3:	48 89 c7             	mov    %rax,%rdi
  8038b6:	48 b8 eb 13 80 00 00 	movabs $0x8013eb,%rax
  8038bd:	00 00 00 
  8038c0:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8038c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038c5:	48 63 d0             	movslq %eax,%rdx
  8038c8:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8038cf:	48 89 d6             	mov    %rdx,%rsi
  8038d2:	48 89 c7             	mov    %rax,%rdi
  8038d5:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  8038dc:	00 00 00 
  8038df:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8038e1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038e4:	01 45 fc             	add    %eax,-0x4(%rbp)
  8038e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ea:	48 98                	cltq   
  8038ec:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8038f3:	0f 82 78 ff ff ff    	jb     803871 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8038f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038fc:	c9                   	leaveq 
  8038fd:	c3                   	retq   

00000000008038fe <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8038fe:	55                   	push   %rbp
  8038ff:	48 89 e5             	mov    %rsp,%rbp
  803902:	48 83 ec 08          	sub    $0x8,%rsp
  803906:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80390a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80390f:	c9                   	leaveq 
  803910:	c3                   	retq   

0000000000803911 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803911:	55                   	push   %rbp
  803912:	48 89 e5             	mov    %rsp,%rbp
  803915:	48 83 ec 10          	sub    $0x10,%rsp
  803919:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80391d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803921:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803925:	48 be f2 41 80 00 00 	movabs $0x8041f2,%rsi
  80392c:	00 00 00 
  80392f:	48 89 c7             	mov    %rax,%rdi
  803932:	48 b8 c7 10 80 00 00 	movabs $0x8010c7,%rax
  803939:	00 00 00 
  80393c:	ff d0                	callq  *%rax
	return 0;
  80393e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803943:	c9                   	leaveq 
  803944:	c3                   	retq   

0000000000803945 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803945:	55                   	push   %rbp
  803946:	48 89 e5             	mov    %rsp,%rbp
  803949:	53                   	push   %rbx
  80394a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803951:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803958:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80395e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803965:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80396c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803973:	84 c0                	test   %al,%al
  803975:	74 23                	je     80399a <_panic+0x55>
  803977:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80397e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803982:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803986:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80398a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80398e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803992:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803996:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80399a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8039a1:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8039a8:	00 00 00 
  8039ab:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8039b2:	00 00 00 
  8039b5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8039b9:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8039c0:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8039c7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8039ce:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8039d5:	00 00 00 
  8039d8:	48 8b 18             	mov    (%rax),%rbx
  8039db:	48 b8 7a 19 80 00 00 	movabs $0x80197a,%rax
  8039e2:	00 00 00 
  8039e5:	ff d0                	callq  *%rax
  8039e7:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8039ed:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8039f4:	41 89 c8             	mov    %ecx,%r8d
  8039f7:	48 89 d1             	mov    %rdx,%rcx
  8039fa:	48 89 da             	mov    %rbx,%rdx
  8039fd:	89 c6                	mov    %eax,%esi
  8039ff:	48 bf 00 42 80 00 00 	movabs $0x804200,%rdi
  803a06:	00 00 00 
  803a09:	b8 00 00 00 00       	mov    $0x0,%eax
  803a0e:	49 b9 1f 03 80 00 00 	movabs $0x80031f,%r9
  803a15:	00 00 00 
  803a18:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803a1b:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803a22:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803a29:	48 89 d6             	mov    %rdx,%rsi
  803a2c:	48 89 c7             	mov    %rax,%rdi
  803a2f:	48 b8 73 02 80 00 00 	movabs $0x800273,%rax
  803a36:	00 00 00 
  803a39:	ff d0                	callq  *%rax
	cprintf("\n");
  803a3b:	48 bf 23 42 80 00 00 	movabs $0x804223,%rdi
  803a42:	00 00 00 
  803a45:	b8 00 00 00 00       	mov    $0x0,%eax
  803a4a:	48 ba 1f 03 80 00 00 	movabs $0x80031f,%rdx
  803a51:	00 00 00 
  803a54:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803a56:	cc                   	int3   
  803a57:	eb fd                	jmp    803a56 <_panic+0x111>

0000000000803a59 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803a59:	55                   	push   %rbp
  803a5a:	48 89 e5             	mov    %rsp,%rbp
  803a5d:	48 83 ec 10          	sub    $0x10,%rsp
  803a61:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803a65:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803a6c:	00 00 00 
  803a6f:	48 8b 00             	mov    (%rax),%rax
  803a72:	48 85 c0             	test   %rax,%rax
  803a75:	75 3a                	jne    803ab1 <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  803a77:	ba 07 00 00 00       	mov    $0x7,%edx
  803a7c:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803a81:	bf 00 00 00 00       	mov    $0x0,%edi
  803a86:	48 b8 f6 19 80 00 00 	movabs $0x8019f6,%rax
  803a8d:	00 00 00 
  803a90:	ff d0                	callq  *%rax
  803a92:	85 c0                	test   %eax,%eax
  803a94:	75 1b                	jne    803ab1 <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803a96:	48 be c4 3a 80 00 00 	movabs $0x803ac4,%rsi
  803a9d:	00 00 00 
  803aa0:	bf 00 00 00 00       	mov    $0x0,%edi
  803aa5:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  803aac:	00 00 00 
  803aaf:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803ab1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803ab8:	00 00 00 
  803abb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803abf:	48 89 10             	mov    %rdx,(%rax)
}
  803ac2:	c9                   	leaveq 
  803ac3:	c3                   	retq   

0000000000803ac4 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803ac4:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803ac7:	48 a1 08 80 80 00 00 	movabs 0x808008,%rax
  803ace:	00 00 00 
	call *%rax
  803ad1:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  803ad3:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  803ad6:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803add:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  803ade:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  803ae5:	00 
	pushq %rbx		// push utf_rip into new stack
  803ae6:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  803ae7:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  803aee:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  803af1:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  803af5:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  803af9:	4c 8b 3c 24          	mov    (%rsp),%r15
  803afd:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803b02:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803b07:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803b0c:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803b11:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803b16:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803b1b:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803b20:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803b25:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803b2a:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803b2f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803b34:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803b39:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803b3e:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803b43:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  803b47:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  803b4b:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  803b4c:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803b4d:	c3                   	retq   

0000000000803b4e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803b4e:	55                   	push   %rbp
  803b4f:	48 89 e5             	mov    %rsp,%rbp
  803b52:	48 83 ec 18          	sub    $0x18,%rsp
  803b56:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b5e:	48 c1 e8 15          	shr    $0x15,%rax
  803b62:	48 89 c2             	mov    %rax,%rdx
  803b65:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803b6c:	01 00 00 
  803b6f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b73:	83 e0 01             	and    $0x1,%eax
  803b76:	48 85 c0             	test   %rax,%rax
  803b79:	75 07                	jne    803b82 <pageref+0x34>
		return 0;
  803b7b:	b8 00 00 00 00       	mov    $0x0,%eax
  803b80:	eb 53                	jmp    803bd5 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803b82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b86:	48 c1 e8 0c          	shr    $0xc,%rax
  803b8a:	48 89 c2             	mov    %rax,%rdx
  803b8d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803b94:	01 00 00 
  803b97:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b9b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803b9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ba3:	83 e0 01             	and    $0x1,%eax
  803ba6:	48 85 c0             	test   %rax,%rax
  803ba9:	75 07                	jne    803bb2 <pageref+0x64>
		return 0;
  803bab:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb0:	eb 23                	jmp    803bd5 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803bb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bb6:	48 c1 e8 0c          	shr    $0xc,%rax
  803bba:	48 89 c2             	mov    %rax,%rdx
  803bbd:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803bc4:	00 00 00 
  803bc7:	48 c1 e2 04          	shl    $0x4,%rdx
  803bcb:	48 01 d0             	add    %rdx,%rax
  803bce:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803bd2:	0f b7 c0             	movzwl %ax,%eax
}
  803bd5:	c9                   	leaveq 
  803bd6:	c3                   	retq   
