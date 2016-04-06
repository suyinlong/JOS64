
obj/user/forktree.debug:     file format elf64-x86-64


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
  80003c:	e8 24 01 00 00       	callq  800165 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 f0                	mov    %esi,%eax
  800051:	88 45 e4             	mov    %al,-0x1c(%rbp)
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  800054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800058:	48 89 c7             	mov    %rax,%rdi
  80005b:	48 b8 79 10 80 00 00 	movabs $0x801079,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
  800067:	83 f8 02             	cmp    $0x2,%eax
  80006a:	7f 65                	jg     8000d1 <forkchild+0x8e>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80006c:	0f be 4d e4          	movsbl -0x1c(%rbp),%ecx
  800070:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800074:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800078:	41 89 c8             	mov    %ecx,%r8d
  80007b:	48 89 d1             	mov    %rdx,%rcx
  80007e:	48 ba 00 3c 80 00 00 	movabs $0x803c00,%rdx
  800085:	00 00 00 
  800088:	be 04 00 00 00       	mov    $0x4,%esi
  80008d:	48 89 c7             	mov    %rax,%rdi
  800090:	b8 00 00 00 00       	mov    $0x0,%eax
  800095:	49 b9 98 0f 80 00 00 	movabs $0x800f98,%r9
  80009c:	00 00 00 
  80009f:	41 ff d1             	callq  *%r9
	if (fork() == 0) {
  8000a2:	48 b8 ea 1e 80 00 00 	movabs $0x801eea,%rax
  8000a9:	00 00 00 
  8000ac:	ff d0                	callq  *%rax
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 1f                	jne    8000d1 <forkchild+0x8e>
		forktree(nxt);
  8000b2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000b6:	48 89 c7             	mov    %rax,%rdi
  8000b9:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
		exit();
  8000c5:	48 b8 f5 01 80 00 00 	movabs $0x8001f5,%rax
  8000cc:	00 00 00 
  8000cf:	ff d0                	callq  *%rax
	}
}
  8000d1:	c9                   	leaveq 
  8000d2:	c3                   	retq   

00000000008000d3 <forktree>:

void
forktree(const char *cur)
{
  8000d3:	55                   	push   %rbp
  8000d4:	48 89 e5             	mov    %rsp,%rbp
  8000d7:	48 83 ec 10          	sub    $0x10,%rsp
  8000db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  8000df:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  8000e6:	00 00 00 
  8000e9:	ff d0                	callq  *%rax
  8000eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ef:	89 c6                	mov    %eax,%esi
  8000f1:	48 bf 05 3c 80 00 00 	movabs $0x803c05,%rdi
  8000f8:	00 00 00 
  8000fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800100:	48 b9 3d 03 80 00 00 	movabs $0x80033d,%rcx
  800107:	00 00 00 
  80010a:	ff d1                	callq  *%rcx

	forkchild(cur, '0');
  80010c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800110:	be 30 00 00 00       	mov    $0x30,%esi
  800115:	48 89 c7             	mov    %rax,%rdi
  800118:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
	forkchild(cur, '1');
  800124:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800128:	be 31 00 00 00       	mov    $0x31,%esi
  80012d:	48 89 c7             	mov    %rax,%rdi
  800130:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800137:	00 00 00 
  80013a:	ff d0                	callq  *%rax
}
  80013c:	c9                   	leaveq 
  80013d:	c3                   	retq   

000000000080013e <umain>:

void
umain(int argc, char **argv)
{
  80013e:	55                   	push   %rbp
  80013f:	48 89 e5             	mov    %rsp,%rbp
  800142:	48 83 ec 10          	sub    $0x10,%rsp
  800146:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800149:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	forktree("");
  80014d:	48 bf 16 3c 80 00 00 	movabs $0x803c16,%rdi
  800154:	00 00 00 
  800157:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  80015e:	00 00 00 
  800161:	ff d0                	callq  *%rax
}
  800163:	c9                   	leaveq 
  800164:	c3                   	retq   

0000000000800165 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800165:	55                   	push   %rbp
  800166:	48 89 e5             	mov    %rsp,%rbp
  800169:	48 83 ec 10          	sub    $0x10,%rsp
  80016d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800170:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800174:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	48 98                	cltq   
  800182:	25 ff 03 00 00       	and    $0x3ff,%eax
  800187:	48 89 c2             	mov    %rax,%rdx
  80018a:	48 89 d0             	mov    %rdx,%rax
  80018d:	48 c1 e0 03          	shl    $0x3,%rax
  800191:	48 01 d0             	add    %rdx,%rax
  800194:	48 c1 e0 05          	shl    $0x5,%rax
  800198:	48 89 c2             	mov    %rax,%rdx
  80019b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001a2:	00 00 00 
  8001a5:	48 01 c2             	add    %rax,%rdx
  8001a8:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001af:	00 00 00 
  8001b2:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001b9:	7e 14                	jle    8001cf <libmain+0x6a>
		binaryname = argv[0];
  8001bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001bf:	48 8b 10             	mov    (%rax),%rdx
  8001c2:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001c9:	00 00 00 
  8001cc:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001d6:	48 89 d6             	mov    %rdx,%rsi
  8001d9:	89 c7                	mov    %eax,%edi
  8001db:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  8001e2:	00 00 00 
  8001e5:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001e7:	48 b8 f5 01 80 00 00 	movabs $0x8001f5,%rax
  8001ee:	00 00 00 
  8001f1:	ff d0                	callq  *%rax
}
  8001f3:	c9                   	leaveq 
  8001f4:	c3                   	retq   

00000000008001f5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001f5:	55                   	push   %rbp
  8001f6:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001f9:	48 b8 c5 24 80 00 00 	movabs $0x8024c5,%rax
  800200:	00 00 00 
  800203:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800205:	bf 00 00 00 00       	mov    $0x0,%edi
  80020a:	48 b8 54 19 80 00 00 	movabs $0x801954,%rax
  800211:	00 00 00 
  800214:	ff d0                	callq  *%rax
}
  800216:	5d                   	pop    %rbp
  800217:	c3                   	retq   

0000000000800218 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800218:	55                   	push   %rbp
  800219:	48 89 e5             	mov    %rsp,%rbp
  80021c:	48 83 ec 10          	sub    $0x10,%rsp
  800220:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800223:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800227:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022b:	8b 00                	mov    (%rax),%eax
  80022d:	8d 48 01             	lea    0x1(%rax),%ecx
  800230:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800234:	89 0a                	mov    %ecx,(%rdx)
  800236:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800239:	89 d1                	mov    %edx,%ecx
  80023b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80023f:	48 98                	cltq   
  800241:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800245:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800249:	8b 00                	mov    (%rax),%eax
  80024b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800250:	75 2c                	jne    80027e <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800256:	8b 00                	mov    (%rax),%eax
  800258:	48 98                	cltq   
  80025a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80025e:	48 83 c2 08          	add    $0x8,%rdx
  800262:	48 89 c6             	mov    %rax,%rsi
  800265:	48 89 d7             	mov    %rdx,%rdi
  800268:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  80026f:	00 00 00 
  800272:	ff d0                	callq  *%rax
		b->idx = 0;
  800274:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800278:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80027e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800282:	8b 40 04             	mov    0x4(%rax),%eax
  800285:	8d 50 01             	lea    0x1(%rax),%edx
  800288:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80028c:	89 50 04             	mov    %edx,0x4(%rax)
}
  80028f:	c9                   	leaveq 
  800290:	c3                   	retq   

0000000000800291 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800291:	55                   	push   %rbp
  800292:	48 89 e5             	mov    %rsp,%rbp
  800295:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80029c:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8002a3:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8002aa:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8002b1:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8002b8:	48 8b 0a             	mov    (%rdx),%rcx
  8002bb:	48 89 08             	mov    %rcx,(%rax)
  8002be:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002c2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002c6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002ca:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8002ce:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002d5:	00 00 00 
	b.cnt = 0;
  8002d8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002df:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8002e2:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002e9:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002f0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002f7:	48 89 c6             	mov    %rax,%rsi
  8002fa:	48 bf 18 02 80 00 00 	movabs $0x800218,%rdi
  800301:	00 00 00 
  800304:	48 b8 f0 06 80 00 00 	movabs $0x8006f0,%rax
  80030b:	00 00 00 
  80030e:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800310:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800316:	48 98                	cltq   
  800318:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80031f:	48 83 c2 08          	add    $0x8,%rdx
  800323:	48 89 c6             	mov    %rax,%rsi
  800326:	48 89 d7             	mov    %rdx,%rdi
  800329:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  800330:	00 00 00 
  800333:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800335:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80033b:	c9                   	leaveq 
  80033c:	c3                   	retq   

000000000080033d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80033d:	55                   	push   %rbp
  80033e:	48 89 e5             	mov    %rsp,%rbp
  800341:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800348:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80034f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800356:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80035d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800364:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80036b:	84 c0                	test   %al,%al
  80036d:	74 20                	je     80038f <cprintf+0x52>
  80036f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800373:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800377:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80037b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80037f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800383:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800387:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80038b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80038f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800396:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80039d:	00 00 00 
  8003a0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003a7:	00 00 00 
  8003aa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003ae:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8003b5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8003bc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8003c3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003ca:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003d1:	48 8b 0a             	mov    (%rdx),%rcx
  8003d4:	48 89 08             	mov    %rcx,(%rax)
  8003d7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003db:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003df:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003e3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8003e7:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003ee:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003f5:	48 89 d6             	mov    %rdx,%rsi
  8003f8:	48 89 c7             	mov    %rax,%rdi
  8003fb:	48 b8 91 02 80 00 00 	movabs $0x800291,%rax
  800402:	00 00 00 
  800405:	ff d0                	callq  *%rax
  800407:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80040d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800413:	c9                   	leaveq 
  800414:	c3                   	retq   

0000000000800415 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800415:	55                   	push   %rbp
  800416:	48 89 e5             	mov    %rsp,%rbp
  800419:	53                   	push   %rbx
  80041a:	48 83 ec 38          	sub    $0x38,%rsp
  80041e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800422:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800426:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80042a:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80042d:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800431:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800435:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800438:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80043c:	77 3b                	ja     800479 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80043e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800441:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800445:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800448:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80044c:	ba 00 00 00 00       	mov    $0x0,%edx
  800451:	48 f7 f3             	div    %rbx
  800454:	48 89 c2             	mov    %rax,%rdx
  800457:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80045a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80045d:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800461:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800465:	41 89 f9             	mov    %edi,%r9d
  800468:	48 89 c7             	mov    %rax,%rdi
  80046b:	48 b8 15 04 80 00 00 	movabs $0x800415,%rax
  800472:	00 00 00 
  800475:	ff d0                	callq  *%rax
  800477:	eb 1e                	jmp    800497 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800479:	eb 12                	jmp    80048d <printnum+0x78>
			putch(padc, putdat);
  80047b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80047f:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800482:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800486:	48 89 ce             	mov    %rcx,%rsi
  800489:	89 d7                	mov    %edx,%edi
  80048b:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80048d:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800491:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800495:	7f e4                	jg     80047b <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800497:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80049a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80049e:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a3:	48 f7 f1             	div    %rcx
  8004a6:	48 89 d0             	mov    %rdx,%rax
  8004a9:	48 ba 08 3e 80 00 00 	movabs $0x803e08,%rdx
  8004b0:	00 00 00 
  8004b3:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004b7:	0f be d0             	movsbl %al,%edx
  8004ba:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c2:	48 89 ce             	mov    %rcx,%rsi
  8004c5:	89 d7                	mov    %edx,%edi
  8004c7:	ff d0                	callq  *%rax
}
  8004c9:	48 83 c4 38          	add    $0x38,%rsp
  8004cd:	5b                   	pop    %rbx
  8004ce:	5d                   	pop    %rbp
  8004cf:	c3                   	retq   

00000000008004d0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004d0:	55                   	push   %rbp
  8004d1:	48 89 e5             	mov    %rsp,%rbp
  8004d4:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004dc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8004df:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004e3:	7e 52                	jle    800537 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e9:	8b 00                	mov    (%rax),%eax
  8004eb:	83 f8 30             	cmp    $0x30,%eax
  8004ee:	73 24                	jae    800514 <getuint+0x44>
  8004f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fc:	8b 00                	mov    (%rax),%eax
  8004fe:	89 c0                	mov    %eax,%eax
  800500:	48 01 d0             	add    %rdx,%rax
  800503:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800507:	8b 12                	mov    (%rdx),%edx
  800509:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80050c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800510:	89 0a                	mov    %ecx,(%rdx)
  800512:	eb 17                	jmp    80052b <getuint+0x5b>
  800514:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800518:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80051c:	48 89 d0             	mov    %rdx,%rax
  80051f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800523:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800527:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80052b:	48 8b 00             	mov    (%rax),%rax
  80052e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800532:	e9 a3 00 00 00       	jmpq   8005da <getuint+0x10a>
	else if (lflag)
  800537:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80053b:	74 4f                	je     80058c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80053d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800541:	8b 00                	mov    (%rax),%eax
  800543:	83 f8 30             	cmp    $0x30,%eax
  800546:	73 24                	jae    80056c <getuint+0x9c>
  800548:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800554:	8b 00                	mov    (%rax),%eax
  800556:	89 c0                	mov    %eax,%eax
  800558:	48 01 d0             	add    %rdx,%rax
  80055b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055f:	8b 12                	mov    (%rdx),%edx
  800561:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800564:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800568:	89 0a                	mov    %ecx,(%rdx)
  80056a:	eb 17                	jmp    800583 <getuint+0xb3>
  80056c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800570:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800574:	48 89 d0             	mov    %rdx,%rax
  800577:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80057b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80057f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800583:	48 8b 00             	mov    (%rax),%rax
  800586:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80058a:	eb 4e                	jmp    8005da <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80058c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800590:	8b 00                	mov    (%rax),%eax
  800592:	83 f8 30             	cmp    $0x30,%eax
  800595:	73 24                	jae    8005bb <getuint+0xeb>
  800597:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80059f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a3:	8b 00                	mov    (%rax),%eax
  8005a5:	89 c0                	mov    %eax,%eax
  8005a7:	48 01 d0             	add    %rdx,%rax
  8005aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ae:	8b 12                	mov    (%rdx),%edx
  8005b0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b7:	89 0a                	mov    %ecx,(%rdx)
  8005b9:	eb 17                	jmp    8005d2 <getuint+0x102>
  8005bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005c3:	48 89 d0             	mov    %rdx,%rax
  8005c6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ce:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005d2:	8b 00                	mov    (%rax),%eax
  8005d4:	89 c0                	mov    %eax,%eax
  8005d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005de:	c9                   	leaveq 
  8005df:	c3                   	retq   

00000000008005e0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005e0:	55                   	push   %rbp
  8005e1:	48 89 e5             	mov    %rsp,%rbp
  8005e4:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005ec:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005ef:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005f3:	7e 52                	jle    800647 <getint+0x67>
		x=va_arg(*ap, long long);
  8005f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f9:	8b 00                	mov    (%rax),%eax
  8005fb:	83 f8 30             	cmp    $0x30,%eax
  8005fe:	73 24                	jae    800624 <getint+0x44>
  800600:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800604:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800608:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060c:	8b 00                	mov    (%rax),%eax
  80060e:	89 c0                	mov    %eax,%eax
  800610:	48 01 d0             	add    %rdx,%rax
  800613:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800617:	8b 12                	mov    (%rdx),%edx
  800619:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80061c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800620:	89 0a                	mov    %ecx,(%rdx)
  800622:	eb 17                	jmp    80063b <getint+0x5b>
  800624:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800628:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80062c:	48 89 d0             	mov    %rdx,%rax
  80062f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800633:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800637:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80063b:	48 8b 00             	mov    (%rax),%rax
  80063e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800642:	e9 a3 00 00 00       	jmpq   8006ea <getint+0x10a>
	else if (lflag)
  800647:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80064b:	74 4f                	je     80069c <getint+0xbc>
		x=va_arg(*ap, long);
  80064d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800651:	8b 00                	mov    (%rax),%eax
  800653:	83 f8 30             	cmp    $0x30,%eax
  800656:	73 24                	jae    80067c <getint+0x9c>
  800658:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800664:	8b 00                	mov    (%rax),%eax
  800666:	89 c0                	mov    %eax,%eax
  800668:	48 01 d0             	add    %rdx,%rax
  80066b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066f:	8b 12                	mov    (%rdx),%edx
  800671:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800674:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800678:	89 0a                	mov    %ecx,(%rdx)
  80067a:	eb 17                	jmp    800693 <getint+0xb3>
  80067c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800680:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800684:	48 89 d0             	mov    %rdx,%rax
  800687:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80068b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800693:	48 8b 00             	mov    (%rax),%rax
  800696:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80069a:	eb 4e                	jmp    8006ea <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80069c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a0:	8b 00                	mov    (%rax),%eax
  8006a2:	83 f8 30             	cmp    $0x30,%eax
  8006a5:	73 24                	jae    8006cb <getint+0xeb>
  8006a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ab:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b3:	8b 00                	mov    (%rax),%eax
  8006b5:	89 c0                	mov    %eax,%eax
  8006b7:	48 01 d0             	add    %rdx,%rax
  8006ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006be:	8b 12                	mov    (%rdx),%edx
  8006c0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c7:	89 0a                	mov    %ecx,(%rdx)
  8006c9:	eb 17                	jmp    8006e2 <getint+0x102>
  8006cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006d3:	48 89 d0             	mov    %rdx,%rax
  8006d6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006de:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e2:	8b 00                	mov    (%rax),%eax
  8006e4:	48 98                	cltq   
  8006e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006ee:	c9                   	leaveq 
  8006ef:	c3                   	retq   

00000000008006f0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006f0:	55                   	push   %rbp
  8006f1:	48 89 e5             	mov    %rsp,%rbp
  8006f4:	41 54                	push   %r12
  8006f6:	53                   	push   %rbx
  8006f7:	48 83 ec 60          	sub    $0x60,%rsp
  8006fb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006ff:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800703:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800707:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80070b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80070f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800713:	48 8b 0a             	mov    (%rdx),%rcx
  800716:	48 89 08             	mov    %rcx,(%rax)
  800719:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80071d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800721:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800725:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  800729:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80072d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800731:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800735:	0f b6 00             	movzbl (%rax),%eax
  800738:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  80073b:	eb 29                	jmp    800766 <vprintfmt+0x76>
			if (ch == '\0')
  80073d:	85 db                	test   %ebx,%ebx
  80073f:	0f 84 ad 06 00 00    	je     800df2 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  800745:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800749:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80074d:	48 89 d6             	mov    %rdx,%rsi
  800750:	89 df                	mov    %ebx,%edi
  800752:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  800754:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800758:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80075c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800760:	0f b6 00             	movzbl (%rax),%eax
  800763:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  800766:	83 fb 25             	cmp    $0x25,%ebx
  800769:	74 05                	je     800770 <vprintfmt+0x80>
  80076b:	83 fb 1b             	cmp    $0x1b,%ebx
  80076e:	75 cd                	jne    80073d <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800770:	83 fb 1b             	cmp    $0x1b,%ebx
  800773:	0f 85 ae 01 00 00    	jne    800927 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  800779:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800780:	00 00 00 
  800783:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  800789:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80078d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800791:	48 89 d6             	mov    %rdx,%rsi
  800794:	89 df                	mov    %ebx,%edi
  800796:	ff d0                	callq  *%rax
			putch('[', putdat);
  800798:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80079c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007a0:	48 89 d6             	mov    %rdx,%rsi
  8007a3:	bf 5b 00 00 00       	mov    $0x5b,%edi
  8007a8:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  8007aa:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  8007b0:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8007b5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007b9:	0f b6 00             	movzbl (%rax),%eax
  8007bc:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8007bf:	eb 32                	jmp    8007f3 <vprintfmt+0x103>
					putch(ch, putdat);
  8007c1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007c5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007c9:	48 89 d6             	mov    %rdx,%rsi
  8007cc:	89 df                	mov    %ebx,%edi
  8007ce:	ff d0                	callq  *%rax
					esc_color *= 10;
  8007d0:	44 89 e0             	mov    %r12d,%eax
  8007d3:	c1 e0 02             	shl    $0x2,%eax
  8007d6:	44 01 e0             	add    %r12d,%eax
  8007d9:	01 c0                	add    %eax,%eax
  8007db:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  8007de:	8d 43 d0             	lea    -0x30(%rbx),%eax
  8007e1:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  8007e4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8007e9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007ed:	0f b6 00             	movzbl (%rax),%eax
  8007f0:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8007f3:	83 fb 3b             	cmp    $0x3b,%ebx
  8007f6:	74 05                	je     8007fd <vprintfmt+0x10d>
  8007f8:	83 fb 6d             	cmp    $0x6d,%ebx
  8007fb:	75 c4                	jne    8007c1 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  8007fd:	45 85 e4             	test   %r12d,%r12d
  800800:	75 15                	jne    800817 <vprintfmt+0x127>
					color_flag = 0x07;
  800802:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800809:	00 00 00 
  80080c:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800812:	e9 dc 00 00 00       	jmpq   8008f3 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800817:	41 83 fc 1d          	cmp    $0x1d,%r12d
  80081b:	7e 69                	jle    800886 <vprintfmt+0x196>
  80081d:	41 83 fc 25          	cmp    $0x25,%r12d
  800821:	7f 63                	jg     800886 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800823:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80082a:	00 00 00 
  80082d:	8b 00                	mov    (%rax),%eax
  80082f:	25 f8 00 00 00       	and    $0xf8,%eax
  800834:	89 c2                	mov    %eax,%edx
  800836:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80083d:	00 00 00 
  800840:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800842:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800846:	44 89 e0             	mov    %r12d,%eax
  800849:	83 e0 04             	and    $0x4,%eax
  80084c:	c1 f8 02             	sar    $0x2,%eax
  80084f:	89 c2                	mov    %eax,%edx
  800851:	44 89 e0             	mov    %r12d,%eax
  800854:	83 e0 02             	and    $0x2,%eax
  800857:	09 c2                	or     %eax,%edx
  800859:	44 89 e0             	mov    %r12d,%eax
  80085c:	83 e0 01             	and    $0x1,%eax
  80085f:	c1 e0 02             	shl    $0x2,%eax
  800862:	09 c2                	or     %eax,%edx
  800864:	41 89 d4             	mov    %edx,%r12d
  800867:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80086e:	00 00 00 
  800871:	8b 00                	mov    (%rax),%eax
  800873:	44 89 e2             	mov    %r12d,%edx
  800876:	09 c2                	or     %eax,%edx
  800878:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80087f:	00 00 00 
  800882:	89 10                	mov    %edx,(%rax)
  800884:	eb 6d                	jmp    8008f3 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800886:	41 83 fc 27          	cmp    $0x27,%r12d
  80088a:	7e 67                	jle    8008f3 <vprintfmt+0x203>
  80088c:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800890:	7f 61                	jg     8008f3 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800892:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800899:	00 00 00 
  80089c:	8b 00                	mov    (%rax),%eax
  80089e:	25 8f 00 00 00       	and    $0x8f,%eax
  8008a3:	89 c2                	mov    %eax,%edx
  8008a5:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8008ac:	00 00 00 
  8008af:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  8008b1:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  8008b5:	44 89 e0             	mov    %r12d,%eax
  8008b8:	83 e0 04             	and    $0x4,%eax
  8008bb:	c1 f8 02             	sar    $0x2,%eax
  8008be:	89 c2                	mov    %eax,%edx
  8008c0:	44 89 e0             	mov    %r12d,%eax
  8008c3:	83 e0 02             	and    $0x2,%eax
  8008c6:	09 c2                	or     %eax,%edx
  8008c8:	44 89 e0             	mov    %r12d,%eax
  8008cb:	83 e0 01             	and    $0x1,%eax
  8008ce:	c1 e0 06             	shl    $0x6,%eax
  8008d1:	09 c2                	or     %eax,%edx
  8008d3:	41 89 d4             	mov    %edx,%r12d
  8008d6:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8008dd:	00 00 00 
  8008e0:	8b 00                	mov    (%rax),%eax
  8008e2:	44 89 e2             	mov    %r12d,%edx
  8008e5:	09 c2                	or     %eax,%edx
  8008e7:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8008ee:	00 00 00 
  8008f1:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  8008f3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008f7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008fb:	48 89 d6             	mov    %rdx,%rsi
  8008fe:	89 df                	mov    %ebx,%edi
  800900:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800902:	83 fb 6d             	cmp    $0x6d,%ebx
  800905:	75 1b                	jne    800922 <vprintfmt+0x232>
					fmt ++;
  800907:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  80090c:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  80090d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800914:	00 00 00 
  800917:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  80091d:	e9 cb 04 00 00       	jmpq   800ded <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800922:	e9 83 fe ff ff       	jmpq   8007aa <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800927:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80092b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800932:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800939:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800940:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800947:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80094b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80094f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800953:	0f b6 00             	movzbl (%rax),%eax
  800956:	0f b6 d8             	movzbl %al,%ebx
  800959:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80095c:	83 f8 55             	cmp    $0x55,%eax
  80095f:	0f 87 5a 04 00 00    	ja     800dbf <vprintfmt+0x6cf>
  800965:	89 c0                	mov    %eax,%eax
  800967:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80096e:	00 
  80096f:	48 b8 30 3e 80 00 00 	movabs $0x803e30,%rax
  800976:	00 00 00 
  800979:	48 01 d0             	add    %rdx,%rax
  80097c:	48 8b 00             	mov    (%rax),%rax
  80097f:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800981:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800985:	eb c0                	jmp    800947 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800987:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80098b:	eb ba                	jmp    800947 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80098d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800994:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800997:	89 d0                	mov    %edx,%eax
  800999:	c1 e0 02             	shl    $0x2,%eax
  80099c:	01 d0                	add    %edx,%eax
  80099e:	01 c0                	add    %eax,%eax
  8009a0:	01 d8                	add    %ebx,%eax
  8009a2:	83 e8 30             	sub    $0x30,%eax
  8009a5:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009a8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009ac:	0f b6 00             	movzbl (%rax),%eax
  8009af:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009b2:	83 fb 2f             	cmp    $0x2f,%ebx
  8009b5:	7e 0c                	jle    8009c3 <vprintfmt+0x2d3>
  8009b7:	83 fb 39             	cmp    $0x39,%ebx
  8009ba:	7f 07                	jg     8009c3 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009bc:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009c1:	eb d1                	jmp    800994 <vprintfmt+0x2a4>
			goto process_precision;
  8009c3:	eb 58                	jmp    800a1d <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  8009c5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c8:	83 f8 30             	cmp    $0x30,%eax
  8009cb:	73 17                	jae    8009e4 <vprintfmt+0x2f4>
  8009cd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009d1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d4:	89 c0                	mov    %eax,%eax
  8009d6:	48 01 d0             	add    %rdx,%rax
  8009d9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009dc:	83 c2 08             	add    $0x8,%edx
  8009df:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009e2:	eb 0f                	jmp    8009f3 <vprintfmt+0x303>
  8009e4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e8:	48 89 d0             	mov    %rdx,%rax
  8009eb:	48 83 c2 08          	add    $0x8,%rdx
  8009ef:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009f3:	8b 00                	mov    (%rax),%eax
  8009f5:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009f8:	eb 23                	jmp    800a1d <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  8009fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009fe:	79 0c                	jns    800a0c <vprintfmt+0x31c>
				width = 0;
  800a00:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a07:	e9 3b ff ff ff       	jmpq   800947 <vprintfmt+0x257>
  800a0c:	e9 36 ff ff ff       	jmpq   800947 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800a11:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a18:	e9 2a ff ff ff       	jmpq   800947 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800a1d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a21:	79 12                	jns    800a35 <vprintfmt+0x345>
				width = precision, precision = -1;
  800a23:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a26:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a29:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a30:	e9 12 ff ff ff       	jmpq   800947 <vprintfmt+0x257>
  800a35:	e9 0d ff ff ff       	jmpq   800947 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a3a:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a3e:	e9 04 ff ff ff       	jmpq   800947 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a43:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a46:	83 f8 30             	cmp    $0x30,%eax
  800a49:	73 17                	jae    800a62 <vprintfmt+0x372>
  800a4b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a4f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a52:	89 c0                	mov    %eax,%eax
  800a54:	48 01 d0             	add    %rdx,%rax
  800a57:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a5a:	83 c2 08             	add    $0x8,%edx
  800a5d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a60:	eb 0f                	jmp    800a71 <vprintfmt+0x381>
  800a62:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a66:	48 89 d0             	mov    %rdx,%rax
  800a69:	48 83 c2 08          	add    $0x8,%rdx
  800a6d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a71:	8b 10                	mov    (%rax),%edx
  800a73:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a7b:	48 89 ce             	mov    %rcx,%rsi
  800a7e:	89 d7                	mov    %edx,%edi
  800a80:	ff d0                	callq  *%rax
			break;
  800a82:	e9 66 03 00 00       	jmpq   800ded <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800a87:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a8a:	83 f8 30             	cmp    $0x30,%eax
  800a8d:	73 17                	jae    800aa6 <vprintfmt+0x3b6>
  800a8f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a96:	89 c0                	mov    %eax,%eax
  800a98:	48 01 d0             	add    %rdx,%rax
  800a9b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a9e:	83 c2 08             	add    $0x8,%edx
  800aa1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aa4:	eb 0f                	jmp    800ab5 <vprintfmt+0x3c5>
  800aa6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aaa:	48 89 d0             	mov    %rdx,%rax
  800aad:	48 83 c2 08          	add    $0x8,%rdx
  800ab1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ab5:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ab7:	85 db                	test   %ebx,%ebx
  800ab9:	79 02                	jns    800abd <vprintfmt+0x3cd>
				err = -err;
  800abb:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800abd:	83 fb 10             	cmp    $0x10,%ebx
  800ac0:	7f 16                	jg     800ad8 <vprintfmt+0x3e8>
  800ac2:	48 b8 80 3d 80 00 00 	movabs $0x803d80,%rax
  800ac9:	00 00 00 
  800acc:	48 63 d3             	movslq %ebx,%rdx
  800acf:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ad3:	4d 85 e4             	test   %r12,%r12
  800ad6:	75 2e                	jne    800b06 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800ad8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800adc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae0:	89 d9                	mov    %ebx,%ecx
  800ae2:	48 ba 19 3e 80 00 00 	movabs $0x803e19,%rdx
  800ae9:	00 00 00 
  800aec:	48 89 c7             	mov    %rax,%rdi
  800aef:	b8 00 00 00 00       	mov    $0x0,%eax
  800af4:	49 b8 fb 0d 80 00 00 	movabs $0x800dfb,%r8
  800afb:	00 00 00 
  800afe:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b01:	e9 e7 02 00 00       	jmpq   800ded <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b06:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0e:	4c 89 e1             	mov    %r12,%rcx
  800b11:	48 ba 22 3e 80 00 00 	movabs $0x803e22,%rdx
  800b18:	00 00 00 
  800b1b:	48 89 c7             	mov    %rax,%rdi
  800b1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b23:	49 b8 fb 0d 80 00 00 	movabs $0x800dfb,%r8
  800b2a:	00 00 00 
  800b2d:	41 ff d0             	callq  *%r8
			break;
  800b30:	e9 b8 02 00 00       	jmpq   800ded <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b35:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b38:	83 f8 30             	cmp    $0x30,%eax
  800b3b:	73 17                	jae    800b54 <vprintfmt+0x464>
  800b3d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b41:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b44:	89 c0                	mov    %eax,%eax
  800b46:	48 01 d0             	add    %rdx,%rax
  800b49:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b4c:	83 c2 08             	add    $0x8,%edx
  800b4f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b52:	eb 0f                	jmp    800b63 <vprintfmt+0x473>
  800b54:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b58:	48 89 d0             	mov    %rdx,%rax
  800b5b:	48 83 c2 08          	add    $0x8,%rdx
  800b5f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b63:	4c 8b 20             	mov    (%rax),%r12
  800b66:	4d 85 e4             	test   %r12,%r12
  800b69:	75 0a                	jne    800b75 <vprintfmt+0x485>
				p = "(null)";
  800b6b:	49 bc 25 3e 80 00 00 	movabs $0x803e25,%r12
  800b72:	00 00 00 
			if (width > 0 && padc != '-')
  800b75:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b79:	7e 3f                	jle    800bba <vprintfmt+0x4ca>
  800b7b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b7f:	74 39                	je     800bba <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b81:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b84:	48 98                	cltq   
  800b86:	48 89 c6             	mov    %rax,%rsi
  800b89:	4c 89 e7             	mov    %r12,%rdi
  800b8c:	48 b8 a7 10 80 00 00 	movabs $0x8010a7,%rax
  800b93:	00 00 00 
  800b96:	ff d0                	callq  *%rax
  800b98:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b9b:	eb 17                	jmp    800bb4 <vprintfmt+0x4c4>
					putch(padc, putdat);
  800b9d:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ba1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ba5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba9:	48 89 ce             	mov    %rcx,%rsi
  800bac:	89 d7                	mov    %edx,%edi
  800bae:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bb4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bb8:	7f e3                	jg     800b9d <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bba:	eb 37                	jmp    800bf3 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800bbc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bc0:	74 1e                	je     800be0 <vprintfmt+0x4f0>
  800bc2:	83 fb 1f             	cmp    $0x1f,%ebx
  800bc5:	7e 05                	jle    800bcc <vprintfmt+0x4dc>
  800bc7:	83 fb 7e             	cmp    $0x7e,%ebx
  800bca:	7e 14                	jle    800be0 <vprintfmt+0x4f0>
					putch('?', putdat);
  800bcc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bd0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd4:	48 89 d6             	mov    %rdx,%rsi
  800bd7:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bdc:	ff d0                	callq  *%rax
  800bde:	eb 0f                	jmp    800bef <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800be0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800be4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be8:	48 89 d6             	mov    %rdx,%rsi
  800beb:	89 df                	mov    %ebx,%edi
  800bed:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bef:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bf3:	4c 89 e0             	mov    %r12,%rax
  800bf6:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bfa:	0f b6 00             	movzbl (%rax),%eax
  800bfd:	0f be d8             	movsbl %al,%ebx
  800c00:	85 db                	test   %ebx,%ebx
  800c02:	74 10                	je     800c14 <vprintfmt+0x524>
  800c04:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c08:	78 b2                	js     800bbc <vprintfmt+0x4cc>
  800c0a:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c0e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c12:	79 a8                	jns    800bbc <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c14:	eb 16                	jmp    800c2c <vprintfmt+0x53c>
				putch(' ', putdat);
  800c16:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1e:	48 89 d6             	mov    %rdx,%rsi
  800c21:	bf 20 00 00 00       	mov    $0x20,%edi
  800c26:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c28:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c2c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c30:	7f e4                	jg     800c16 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800c32:	e9 b6 01 00 00       	jmpq   800ded <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c37:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c3b:	be 03 00 00 00       	mov    $0x3,%esi
  800c40:	48 89 c7             	mov    %rax,%rdi
  800c43:	48 b8 e0 05 80 00 00 	movabs $0x8005e0,%rax
  800c4a:	00 00 00 
  800c4d:	ff d0                	callq  *%rax
  800c4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c57:	48 85 c0             	test   %rax,%rax
  800c5a:	79 1d                	jns    800c79 <vprintfmt+0x589>
				putch('-', putdat);
  800c5c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c64:	48 89 d6             	mov    %rdx,%rsi
  800c67:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c6c:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c72:	48 f7 d8             	neg    %rax
  800c75:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c79:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c80:	e9 fb 00 00 00       	jmpq   800d80 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c85:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c89:	be 03 00 00 00       	mov    $0x3,%esi
  800c8e:	48 89 c7             	mov    %rax,%rdi
  800c91:	48 b8 d0 04 80 00 00 	movabs $0x8004d0,%rax
  800c98:	00 00 00 
  800c9b:	ff d0                	callq  *%rax
  800c9d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ca1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ca8:	e9 d3 00 00 00       	jmpq   800d80 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800cad:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cb1:	be 03 00 00 00       	mov    $0x3,%esi
  800cb6:	48 89 c7             	mov    %rax,%rdi
  800cb9:	48 b8 e0 05 80 00 00 	movabs $0x8005e0,%rax
  800cc0:	00 00 00 
  800cc3:	ff d0                	callq  *%rax
  800cc5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800cc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ccd:	48 85 c0             	test   %rax,%rax
  800cd0:	79 1d                	jns    800cef <vprintfmt+0x5ff>
				putch('-', putdat);
  800cd2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cd6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cda:	48 89 d6             	mov    %rdx,%rsi
  800cdd:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ce2:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ce4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce8:	48 f7 d8             	neg    %rax
  800ceb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800cef:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800cf6:	e9 85 00 00 00       	jmpq   800d80 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800cfb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d03:	48 89 d6             	mov    %rdx,%rsi
  800d06:	bf 30 00 00 00       	mov    $0x30,%edi
  800d0b:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d15:	48 89 d6             	mov    %rdx,%rsi
  800d18:	bf 78 00 00 00       	mov    $0x78,%edi
  800d1d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d1f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d22:	83 f8 30             	cmp    $0x30,%eax
  800d25:	73 17                	jae    800d3e <vprintfmt+0x64e>
  800d27:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d2b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2e:	89 c0                	mov    %eax,%eax
  800d30:	48 01 d0             	add    %rdx,%rax
  800d33:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d36:	83 c2 08             	add    $0x8,%edx
  800d39:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d3c:	eb 0f                	jmp    800d4d <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800d3e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d42:	48 89 d0             	mov    %rdx,%rax
  800d45:	48 83 c2 08          	add    $0x8,%rdx
  800d49:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d4d:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d50:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d54:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d5b:	eb 23                	jmp    800d80 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d5d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d61:	be 03 00 00 00       	mov    $0x3,%esi
  800d66:	48 89 c7             	mov    %rax,%rdi
  800d69:	48 b8 d0 04 80 00 00 	movabs $0x8004d0,%rax
  800d70:	00 00 00 
  800d73:	ff d0                	callq  *%rax
  800d75:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d79:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d80:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d85:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d88:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d8b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d8f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d97:	45 89 c1             	mov    %r8d,%r9d
  800d9a:	41 89 f8             	mov    %edi,%r8d
  800d9d:	48 89 c7             	mov    %rax,%rdi
  800da0:	48 b8 15 04 80 00 00 	movabs $0x800415,%rax
  800da7:	00 00 00 
  800daa:	ff d0                	callq  *%rax
			break;
  800dac:	eb 3f                	jmp    800ded <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800db2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db6:	48 89 d6             	mov    %rdx,%rsi
  800db9:	89 df                	mov    %ebx,%edi
  800dbb:	ff d0                	callq  *%rax
			break;
  800dbd:	eb 2e                	jmp    800ded <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dbf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc7:	48 89 d6             	mov    %rdx,%rsi
  800dca:	bf 25 00 00 00       	mov    $0x25,%edi
  800dcf:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dd1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dd6:	eb 05                	jmp    800ddd <vprintfmt+0x6ed>
  800dd8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ddd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800de1:	48 83 e8 01          	sub    $0x1,%rax
  800de5:	0f b6 00             	movzbl (%rax),%eax
  800de8:	3c 25                	cmp    $0x25,%al
  800dea:	75 ec                	jne    800dd8 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  800dec:	90                   	nop
		}
	}
  800ded:	e9 37 f9 ff ff       	jmpq   800729 <vprintfmt+0x39>
    va_end(aq);
}
  800df2:	48 83 c4 60          	add    $0x60,%rsp
  800df6:	5b                   	pop    %rbx
  800df7:	41 5c                	pop    %r12
  800df9:	5d                   	pop    %rbp
  800dfa:	c3                   	retq   

0000000000800dfb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dfb:	55                   	push   %rbp
  800dfc:	48 89 e5             	mov    %rsp,%rbp
  800dff:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e06:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e0d:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e14:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e1b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e22:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e29:	84 c0                	test   %al,%al
  800e2b:	74 20                	je     800e4d <printfmt+0x52>
  800e2d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e31:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e35:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e39:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e3d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e41:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e45:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e49:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e4d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e54:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e5b:	00 00 00 
  800e5e:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e65:	00 00 00 
  800e68:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e6c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e73:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e7a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e81:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e88:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e8f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e96:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e9d:	48 89 c7             	mov    %rax,%rdi
  800ea0:	48 b8 f0 06 80 00 00 	movabs $0x8006f0,%rax
  800ea7:	00 00 00 
  800eaa:	ff d0                	callq  *%rax
	va_end(ap);
}
  800eac:	c9                   	leaveq 
  800ead:	c3                   	retq   

0000000000800eae <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800eae:	55                   	push   %rbp
  800eaf:	48 89 e5             	mov    %rsp,%rbp
  800eb2:	48 83 ec 10          	sub    $0x10,%rsp
  800eb6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800eb9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ebd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ec1:	8b 40 10             	mov    0x10(%rax),%eax
  800ec4:	8d 50 01             	lea    0x1(%rax),%edx
  800ec7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ecb:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ece:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed2:	48 8b 10             	mov    (%rax),%rdx
  800ed5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed9:	48 8b 40 08          	mov    0x8(%rax),%rax
  800edd:	48 39 c2             	cmp    %rax,%rdx
  800ee0:	73 17                	jae    800ef9 <sprintputch+0x4b>
		*b->buf++ = ch;
  800ee2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ee6:	48 8b 00             	mov    (%rax),%rax
  800ee9:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800eed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ef1:	48 89 0a             	mov    %rcx,(%rdx)
  800ef4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ef7:	88 10                	mov    %dl,(%rax)
}
  800ef9:	c9                   	leaveq 
  800efa:	c3                   	retq   

0000000000800efb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800efb:	55                   	push   %rbp
  800efc:	48 89 e5             	mov    %rsp,%rbp
  800eff:	48 83 ec 50          	sub    $0x50,%rsp
  800f03:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f07:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f0a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f0e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f12:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f16:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f1a:	48 8b 0a             	mov    (%rdx),%rcx
  800f1d:	48 89 08             	mov    %rcx,(%rax)
  800f20:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f24:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f28:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f2c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f30:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f34:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f38:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f3b:	48 98                	cltq   
  800f3d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f41:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f45:	48 01 d0             	add    %rdx,%rax
  800f48:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f4c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f53:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f58:	74 06                	je     800f60 <vsnprintf+0x65>
  800f5a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f5e:	7f 07                	jg     800f67 <vsnprintf+0x6c>
		return -E_INVAL;
  800f60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f65:	eb 2f                	jmp    800f96 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f67:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f6b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f6f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f73:	48 89 c6             	mov    %rax,%rsi
  800f76:	48 bf ae 0e 80 00 00 	movabs $0x800eae,%rdi
  800f7d:	00 00 00 
  800f80:	48 b8 f0 06 80 00 00 	movabs $0x8006f0,%rax
  800f87:	00 00 00 
  800f8a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f90:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f93:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f96:	c9                   	leaveq 
  800f97:	c3                   	retq   

0000000000800f98 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f98:	55                   	push   %rbp
  800f99:	48 89 e5             	mov    %rsp,%rbp
  800f9c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fa3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800faa:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fb0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fb7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fbe:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fc5:	84 c0                	test   %al,%al
  800fc7:	74 20                	je     800fe9 <snprintf+0x51>
  800fc9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fcd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fd1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fd5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fd9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fdd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fe1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fe5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fe9:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800ff0:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800ff7:	00 00 00 
  800ffa:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801001:	00 00 00 
  801004:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801008:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80100f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801016:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80101d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801024:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80102b:	48 8b 0a             	mov    (%rdx),%rcx
  80102e:	48 89 08             	mov    %rcx,(%rax)
  801031:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801035:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801039:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80103d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801041:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801048:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80104f:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801055:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80105c:	48 89 c7             	mov    %rax,%rdi
  80105f:	48 b8 fb 0e 80 00 00 	movabs $0x800efb,%rax
  801066:	00 00 00 
  801069:	ff d0                	callq  *%rax
  80106b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801071:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801077:	c9                   	leaveq 
  801078:	c3                   	retq   

0000000000801079 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801079:	55                   	push   %rbp
  80107a:	48 89 e5             	mov    %rsp,%rbp
  80107d:	48 83 ec 18          	sub    $0x18,%rsp
  801081:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801085:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80108c:	eb 09                	jmp    801097 <strlen+0x1e>
		n++;
  80108e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801092:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801097:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109b:	0f b6 00             	movzbl (%rax),%eax
  80109e:	84 c0                	test   %al,%al
  8010a0:	75 ec                	jne    80108e <strlen+0x15>
		n++;
	return n;
  8010a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010a5:	c9                   	leaveq 
  8010a6:	c3                   	retq   

00000000008010a7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010a7:	55                   	push   %rbp
  8010a8:	48 89 e5             	mov    %rsp,%rbp
  8010ab:	48 83 ec 20          	sub    $0x20,%rsp
  8010af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010be:	eb 0e                	jmp    8010ce <strnlen+0x27>
		n++;
  8010c0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010c4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010c9:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010ce:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010d3:	74 0b                	je     8010e0 <strnlen+0x39>
  8010d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d9:	0f b6 00             	movzbl (%rax),%eax
  8010dc:	84 c0                	test   %al,%al
  8010de:	75 e0                	jne    8010c0 <strnlen+0x19>
		n++;
	return n;
  8010e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010e3:	c9                   	leaveq 
  8010e4:	c3                   	retq   

00000000008010e5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010e5:	55                   	push   %rbp
  8010e6:	48 89 e5             	mov    %rsp,%rbp
  8010e9:	48 83 ec 20          	sub    $0x20,%rsp
  8010ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010fd:	90                   	nop
  8010fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801102:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801106:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80110a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80110e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801112:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801116:	0f b6 12             	movzbl (%rdx),%edx
  801119:	88 10                	mov    %dl,(%rax)
  80111b:	0f b6 00             	movzbl (%rax),%eax
  80111e:	84 c0                	test   %al,%al
  801120:	75 dc                	jne    8010fe <strcpy+0x19>
		/* do nothing */;
	return ret;
  801122:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801126:	c9                   	leaveq 
  801127:	c3                   	retq   

0000000000801128 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801128:	55                   	push   %rbp
  801129:	48 89 e5             	mov    %rsp,%rbp
  80112c:	48 83 ec 20          	sub    $0x20,%rsp
  801130:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801134:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801138:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113c:	48 89 c7             	mov    %rax,%rdi
  80113f:	48 b8 79 10 80 00 00 	movabs $0x801079,%rax
  801146:	00 00 00 
  801149:	ff d0                	callq  *%rax
  80114b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80114e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801151:	48 63 d0             	movslq %eax,%rdx
  801154:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801158:	48 01 c2             	add    %rax,%rdx
  80115b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80115f:	48 89 c6             	mov    %rax,%rsi
  801162:	48 89 d7             	mov    %rdx,%rdi
  801165:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  80116c:	00 00 00 
  80116f:	ff d0                	callq  *%rax
	return dst;
  801171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801175:	c9                   	leaveq 
  801176:	c3                   	retq   

0000000000801177 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801177:	55                   	push   %rbp
  801178:	48 89 e5             	mov    %rsp,%rbp
  80117b:	48 83 ec 28          	sub    $0x28,%rsp
  80117f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801183:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801187:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80118b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801193:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80119a:	00 
  80119b:	eb 2a                	jmp    8011c7 <strncpy+0x50>
		*dst++ = *src;
  80119d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011a5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011a9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011ad:	0f b6 12             	movzbl (%rdx),%edx
  8011b0:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011b6:	0f b6 00             	movzbl (%rax),%eax
  8011b9:	84 c0                	test   %al,%al
  8011bb:	74 05                	je     8011c2 <strncpy+0x4b>
			src++;
  8011bd:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011cb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011cf:	72 cc                	jb     80119d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011d5:	c9                   	leaveq 
  8011d6:	c3                   	retq   

00000000008011d7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011d7:	55                   	push   %rbp
  8011d8:	48 89 e5             	mov    %rsp,%rbp
  8011db:	48 83 ec 28          	sub    $0x28,%rsp
  8011df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011f3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011f8:	74 3d                	je     801237 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011fa:	eb 1d                	jmp    801219 <strlcpy+0x42>
			*dst++ = *src++;
  8011fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801200:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801204:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801208:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80120c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801210:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801214:	0f b6 12             	movzbl (%rdx),%edx
  801217:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801219:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80121e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801223:	74 0b                	je     801230 <strlcpy+0x59>
  801225:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801229:	0f b6 00             	movzbl (%rax),%eax
  80122c:	84 c0                	test   %al,%al
  80122e:	75 cc                	jne    8011fc <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801230:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801234:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801237:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80123b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123f:	48 29 c2             	sub    %rax,%rdx
  801242:	48 89 d0             	mov    %rdx,%rax
}
  801245:	c9                   	leaveq 
  801246:	c3                   	retq   

0000000000801247 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801247:	55                   	push   %rbp
  801248:	48 89 e5             	mov    %rsp,%rbp
  80124b:	48 83 ec 10          	sub    $0x10,%rsp
  80124f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801253:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801257:	eb 0a                	jmp    801263 <strcmp+0x1c>
		p++, q++;
  801259:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80125e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801263:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801267:	0f b6 00             	movzbl (%rax),%eax
  80126a:	84 c0                	test   %al,%al
  80126c:	74 12                	je     801280 <strcmp+0x39>
  80126e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801272:	0f b6 10             	movzbl (%rax),%edx
  801275:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801279:	0f b6 00             	movzbl (%rax),%eax
  80127c:	38 c2                	cmp    %al,%dl
  80127e:	74 d9                	je     801259 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801284:	0f b6 00             	movzbl (%rax),%eax
  801287:	0f b6 d0             	movzbl %al,%edx
  80128a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128e:	0f b6 00             	movzbl (%rax),%eax
  801291:	0f b6 c0             	movzbl %al,%eax
  801294:	29 c2                	sub    %eax,%edx
  801296:	89 d0                	mov    %edx,%eax
}
  801298:	c9                   	leaveq 
  801299:	c3                   	retq   

000000000080129a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80129a:	55                   	push   %rbp
  80129b:	48 89 e5             	mov    %rsp,%rbp
  80129e:	48 83 ec 18          	sub    $0x18,%rsp
  8012a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012aa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012ae:	eb 0f                	jmp    8012bf <strncmp+0x25>
		n--, p++, q++;
  8012b0:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ba:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012c4:	74 1d                	je     8012e3 <strncmp+0x49>
  8012c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ca:	0f b6 00             	movzbl (%rax),%eax
  8012cd:	84 c0                	test   %al,%al
  8012cf:	74 12                	je     8012e3 <strncmp+0x49>
  8012d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d5:	0f b6 10             	movzbl (%rax),%edx
  8012d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012dc:	0f b6 00             	movzbl (%rax),%eax
  8012df:	38 c2                	cmp    %al,%dl
  8012e1:	74 cd                	je     8012b0 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012e3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012e8:	75 07                	jne    8012f1 <strncmp+0x57>
		return 0;
  8012ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ef:	eb 18                	jmp    801309 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f5:	0f b6 00             	movzbl (%rax),%eax
  8012f8:	0f b6 d0             	movzbl %al,%edx
  8012fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ff:	0f b6 00             	movzbl (%rax),%eax
  801302:	0f b6 c0             	movzbl %al,%eax
  801305:	29 c2                	sub    %eax,%edx
  801307:	89 d0                	mov    %edx,%eax
}
  801309:	c9                   	leaveq 
  80130a:	c3                   	retq   

000000000080130b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80130b:	55                   	push   %rbp
  80130c:	48 89 e5             	mov    %rsp,%rbp
  80130f:	48 83 ec 0c          	sub    $0xc,%rsp
  801313:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801317:	89 f0                	mov    %esi,%eax
  801319:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80131c:	eb 17                	jmp    801335 <strchr+0x2a>
		if (*s == c)
  80131e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801322:	0f b6 00             	movzbl (%rax),%eax
  801325:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801328:	75 06                	jne    801330 <strchr+0x25>
			return (char *) s;
  80132a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132e:	eb 15                	jmp    801345 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801330:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801335:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801339:	0f b6 00             	movzbl (%rax),%eax
  80133c:	84 c0                	test   %al,%al
  80133e:	75 de                	jne    80131e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801340:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801345:	c9                   	leaveq 
  801346:	c3                   	retq   

0000000000801347 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801347:	55                   	push   %rbp
  801348:	48 89 e5             	mov    %rsp,%rbp
  80134b:	48 83 ec 0c          	sub    $0xc,%rsp
  80134f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801353:	89 f0                	mov    %esi,%eax
  801355:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801358:	eb 13                	jmp    80136d <strfind+0x26>
		if (*s == c)
  80135a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135e:	0f b6 00             	movzbl (%rax),%eax
  801361:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801364:	75 02                	jne    801368 <strfind+0x21>
			break;
  801366:	eb 10                	jmp    801378 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801368:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80136d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801371:	0f b6 00             	movzbl (%rax),%eax
  801374:	84 c0                	test   %al,%al
  801376:	75 e2                	jne    80135a <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801378:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80137c:	c9                   	leaveq 
  80137d:	c3                   	retq   

000000000080137e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80137e:	55                   	push   %rbp
  80137f:	48 89 e5             	mov    %rsp,%rbp
  801382:	48 83 ec 18          	sub    $0x18,%rsp
  801386:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80138a:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80138d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801391:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801396:	75 06                	jne    80139e <memset+0x20>
		return v;
  801398:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139c:	eb 69                	jmp    801407 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80139e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a2:	83 e0 03             	and    $0x3,%eax
  8013a5:	48 85 c0             	test   %rax,%rax
  8013a8:	75 48                	jne    8013f2 <memset+0x74>
  8013aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ae:	83 e0 03             	and    $0x3,%eax
  8013b1:	48 85 c0             	test   %rax,%rax
  8013b4:	75 3c                	jne    8013f2 <memset+0x74>
		c &= 0xFF;
  8013b6:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c0:	c1 e0 18             	shl    $0x18,%eax
  8013c3:	89 c2                	mov    %eax,%edx
  8013c5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c8:	c1 e0 10             	shl    $0x10,%eax
  8013cb:	09 c2                	or     %eax,%edx
  8013cd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013d0:	c1 e0 08             	shl    $0x8,%eax
  8013d3:	09 d0                	or     %edx,%eax
  8013d5:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8013d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013dc:	48 c1 e8 02          	shr    $0x2,%rax
  8013e0:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013e3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013ea:	48 89 d7             	mov    %rdx,%rdi
  8013ed:	fc                   	cld    
  8013ee:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013f0:	eb 11                	jmp    801403 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013f2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013f9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013fd:	48 89 d7             	mov    %rdx,%rdi
  801400:	fc                   	cld    
  801401:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801403:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801407:	c9                   	leaveq 
  801408:	c3                   	retq   

0000000000801409 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801409:	55                   	push   %rbp
  80140a:	48 89 e5             	mov    %rsp,%rbp
  80140d:	48 83 ec 28          	sub    $0x28,%rsp
  801411:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801415:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801419:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80141d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801421:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801429:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80142d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801431:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801435:	0f 83 88 00 00 00    	jae    8014c3 <memmove+0xba>
  80143b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801443:	48 01 d0             	add    %rdx,%rax
  801446:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80144a:	76 77                	jbe    8014c3 <memmove+0xba>
		s += n;
  80144c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801450:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801454:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801458:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80145c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801460:	83 e0 03             	and    $0x3,%eax
  801463:	48 85 c0             	test   %rax,%rax
  801466:	75 3b                	jne    8014a3 <memmove+0x9a>
  801468:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146c:	83 e0 03             	and    $0x3,%eax
  80146f:	48 85 c0             	test   %rax,%rax
  801472:	75 2f                	jne    8014a3 <memmove+0x9a>
  801474:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801478:	83 e0 03             	and    $0x3,%eax
  80147b:	48 85 c0             	test   %rax,%rax
  80147e:	75 23                	jne    8014a3 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801480:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801484:	48 83 e8 04          	sub    $0x4,%rax
  801488:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148c:	48 83 ea 04          	sub    $0x4,%rdx
  801490:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801494:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801498:	48 89 c7             	mov    %rax,%rdi
  80149b:	48 89 d6             	mov    %rdx,%rsi
  80149e:	fd                   	std    
  80149f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014a1:	eb 1d                	jmp    8014c0 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014af:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b7:	48 89 d7             	mov    %rdx,%rdi
  8014ba:	48 89 c1             	mov    %rax,%rcx
  8014bd:	fd                   	std    
  8014be:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014c0:	fc                   	cld    
  8014c1:	eb 57                	jmp    80151a <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c7:	83 e0 03             	and    $0x3,%eax
  8014ca:	48 85 c0             	test   %rax,%rax
  8014cd:	75 36                	jne    801505 <memmove+0xfc>
  8014cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d3:	83 e0 03             	and    $0x3,%eax
  8014d6:	48 85 c0             	test   %rax,%rax
  8014d9:	75 2a                	jne    801505 <memmove+0xfc>
  8014db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014df:	83 e0 03             	and    $0x3,%eax
  8014e2:	48 85 c0             	test   %rax,%rax
  8014e5:	75 1e                	jne    801505 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014eb:	48 c1 e8 02          	shr    $0x2,%rax
  8014ef:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014fa:	48 89 c7             	mov    %rax,%rdi
  8014fd:	48 89 d6             	mov    %rdx,%rsi
  801500:	fc                   	cld    
  801501:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801503:	eb 15                	jmp    80151a <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801505:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801509:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80150d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801511:	48 89 c7             	mov    %rax,%rdi
  801514:	48 89 d6             	mov    %rdx,%rsi
  801517:	fc                   	cld    
  801518:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80151a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80151e:	c9                   	leaveq 
  80151f:	c3                   	retq   

0000000000801520 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801520:	55                   	push   %rbp
  801521:	48 89 e5             	mov    %rsp,%rbp
  801524:	48 83 ec 18          	sub    $0x18,%rsp
  801528:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80152c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801530:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801534:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801538:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80153c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801540:	48 89 ce             	mov    %rcx,%rsi
  801543:	48 89 c7             	mov    %rax,%rdi
  801546:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  80154d:	00 00 00 
  801550:	ff d0                	callq  *%rax
}
  801552:	c9                   	leaveq 
  801553:	c3                   	retq   

0000000000801554 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801554:	55                   	push   %rbp
  801555:	48 89 e5             	mov    %rsp,%rbp
  801558:	48 83 ec 28          	sub    $0x28,%rsp
  80155c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801560:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801564:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801570:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801574:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801578:	eb 36                	jmp    8015b0 <memcmp+0x5c>
		if (*s1 != *s2)
  80157a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157e:	0f b6 10             	movzbl (%rax),%edx
  801581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801585:	0f b6 00             	movzbl (%rax),%eax
  801588:	38 c2                	cmp    %al,%dl
  80158a:	74 1a                	je     8015a6 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80158c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801590:	0f b6 00             	movzbl (%rax),%eax
  801593:	0f b6 d0             	movzbl %al,%edx
  801596:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159a:	0f b6 00             	movzbl (%rax),%eax
  80159d:	0f b6 c0             	movzbl %al,%eax
  8015a0:	29 c2                	sub    %eax,%edx
  8015a2:	89 d0                	mov    %edx,%eax
  8015a4:	eb 20                	jmp    8015c6 <memcmp+0x72>
		s1++, s2++;
  8015a6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015ab:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015b8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015bc:	48 85 c0             	test   %rax,%rax
  8015bf:	75 b9                	jne    80157a <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c6:	c9                   	leaveq 
  8015c7:	c3                   	retq   

00000000008015c8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015c8:	55                   	push   %rbp
  8015c9:	48 89 e5             	mov    %rsp,%rbp
  8015cc:	48 83 ec 28          	sub    $0x28,%rsp
  8015d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015d4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015e3:	48 01 d0             	add    %rdx,%rax
  8015e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015ea:	eb 15                	jmp    801601 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f0:	0f b6 10             	movzbl (%rax),%edx
  8015f3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015f6:	38 c2                	cmp    %al,%dl
  8015f8:	75 02                	jne    8015fc <memfind+0x34>
			break;
  8015fa:	eb 0f                	jmp    80160b <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015fc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801605:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801609:	72 e1                	jb     8015ec <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80160b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80160f:	c9                   	leaveq 
  801610:	c3                   	retq   

0000000000801611 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801611:	55                   	push   %rbp
  801612:	48 89 e5             	mov    %rsp,%rbp
  801615:	48 83 ec 34          	sub    $0x34,%rsp
  801619:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80161d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801621:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801624:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80162b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801632:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801633:	eb 05                	jmp    80163a <strtol+0x29>
		s++;
  801635:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80163a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163e:	0f b6 00             	movzbl (%rax),%eax
  801641:	3c 20                	cmp    $0x20,%al
  801643:	74 f0                	je     801635 <strtol+0x24>
  801645:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801649:	0f b6 00             	movzbl (%rax),%eax
  80164c:	3c 09                	cmp    $0x9,%al
  80164e:	74 e5                	je     801635 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801654:	0f b6 00             	movzbl (%rax),%eax
  801657:	3c 2b                	cmp    $0x2b,%al
  801659:	75 07                	jne    801662 <strtol+0x51>
		s++;
  80165b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801660:	eb 17                	jmp    801679 <strtol+0x68>
	else if (*s == '-')
  801662:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801666:	0f b6 00             	movzbl (%rax),%eax
  801669:	3c 2d                	cmp    $0x2d,%al
  80166b:	75 0c                	jne    801679 <strtol+0x68>
		s++, neg = 1;
  80166d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801672:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801679:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80167d:	74 06                	je     801685 <strtol+0x74>
  80167f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801683:	75 28                	jne    8016ad <strtol+0x9c>
  801685:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801689:	0f b6 00             	movzbl (%rax),%eax
  80168c:	3c 30                	cmp    $0x30,%al
  80168e:	75 1d                	jne    8016ad <strtol+0x9c>
  801690:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801694:	48 83 c0 01          	add    $0x1,%rax
  801698:	0f b6 00             	movzbl (%rax),%eax
  80169b:	3c 78                	cmp    $0x78,%al
  80169d:	75 0e                	jne    8016ad <strtol+0x9c>
		s += 2, base = 16;
  80169f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016a4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016ab:	eb 2c                	jmp    8016d9 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016b1:	75 19                	jne    8016cc <strtol+0xbb>
  8016b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b7:	0f b6 00             	movzbl (%rax),%eax
  8016ba:	3c 30                	cmp    $0x30,%al
  8016bc:	75 0e                	jne    8016cc <strtol+0xbb>
		s++, base = 8;
  8016be:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016c3:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016ca:	eb 0d                	jmp    8016d9 <strtol+0xc8>
	else if (base == 0)
  8016cc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016d0:	75 07                	jne    8016d9 <strtol+0xc8>
		base = 10;
  8016d2:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016dd:	0f b6 00             	movzbl (%rax),%eax
  8016e0:	3c 2f                	cmp    $0x2f,%al
  8016e2:	7e 1d                	jle    801701 <strtol+0xf0>
  8016e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e8:	0f b6 00             	movzbl (%rax),%eax
  8016eb:	3c 39                	cmp    $0x39,%al
  8016ed:	7f 12                	jg     801701 <strtol+0xf0>
			dig = *s - '0';
  8016ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f3:	0f b6 00             	movzbl (%rax),%eax
  8016f6:	0f be c0             	movsbl %al,%eax
  8016f9:	83 e8 30             	sub    $0x30,%eax
  8016fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016ff:	eb 4e                	jmp    80174f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801701:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801705:	0f b6 00             	movzbl (%rax),%eax
  801708:	3c 60                	cmp    $0x60,%al
  80170a:	7e 1d                	jle    801729 <strtol+0x118>
  80170c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801710:	0f b6 00             	movzbl (%rax),%eax
  801713:	3c 7a                	cmp    $0x7a,%al
  801715:	7f 12                	jg     801729 <strtol+0x118>
			dig = *s - 'a' + 10;
  801717:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171b:	0f b6 00             	movzbl (%rax),%eax
  80171e:	0f be c0             	movsbl %al,%eax
  801721:	83 e8 57             	sub    $0x57,%eax
  801724:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801727:	eb 26                	jmp    80174f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801729:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172d:	0f b6 00             	movzbl (%rax),%eax
  801730:	3c 40                	cmp    $0x40,%al
  801732:	7e 48                	jle    80177c <strtol+0x16b>
  801734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801738:	0f b6 00             	movzbl (%rax),%eax
  80173b:	3c 5a                	cmp    $0x5a,%al
  80173d:	7f 3d                	jg     80177c <strtol+0x16b>
			dig = *s - 'A' + 10;
  80173f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801743:	0f b6 00             	movzbl (%rax),%eax
  801746:	0f be c0             	movsbl %al,%eax
  801749:	83 e8 37             	sub    $0x37,%eax
  80174c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80174f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801752:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801755:	7c 02                	jl     801759 <strtol+0x148>
			break;
  801757:	eb 23                	jmp    80177c <strtol+0x16b>
		s++, val = (val * base) + dig;
  801759:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80175e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801761:	48 98                	cltq   
  801763:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801768:	48 89 c2             	mov    %rax,%rdx
  80176b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80176e:	48 98                	cltq   
  801770:	48 01 d0             	add    %rdx,%rax
  801773:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801777:	e9 5d ff ff ff       	jmpq   8016d9 <strtol+0xc8>

	if (endptr)
  80177c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801781:	74 0b                	je     80178e <strtol+0x17d>
		*endptr = (char *) s;
  801783:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801787:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80178b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80178e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801792:	74 09                	je     80179d <strtol+0x18c>
  801794:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801798:	48 f7 d8             	neg    %rax
  80179b:	eb 04                	jmp    8017a1 <strtol+0x190>
  80179d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017a1:	c9                   	leaveq 
  8017a2:	c3                   	retq   

00000000008017a3 <strstr>:

char * strstr(const char *in, const char *str)
{
  8017a3:	55                   	push   %rbp
  8017a4:	48 89 e5             	mov    %rsp,%rbp
  8017a7:	48 83 ec 30          	sub    $0x30,%rsp
  8017ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8017b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017bb:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017bf:	0f b6 00             	movzbl (%rax),%eax
  8017c2:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8017c5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017c9:	75 06                	jne    8017d1 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8017cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cf:	eb 6b                	jmp    80183c <strstr+0x99>

    len = strlen(str);
  8017d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d5:	48 89 c7             	mov    %rax,%rdi
  8017d8:	48 b8 79 10 80 00 00 	movabs $0x801079,%rax
  8017df:	00 00 00 
  8017e2:	ff d0                	callq  *%rax
  8017e4:	48 98                	cltq   
  8017e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8017ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017f6:	0f b6 00             	movzbl (%rax),%eax
  8017f9:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8017fc:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801800:	75 07                	jne    801809 <strstr+0x66>
                return (char *) 0;
  801802:	b8 00 00 00 00       	mov    $0x0,%eax
  801807:	eb 33                	jmp    80183c <strstr+0x99>
        } while (sc != c);
  801809:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80180d:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801810:	75 d8                	jne    8017ea <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801812:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801816:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80181a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181e:	48 89 ce             	mov    %rcx,%rsi
  801821:	48 89 c7             	mov    %rax,%rdi
  801824:	48 b8 9a 12 80 00 00 	movabs $0x80129a,%rax
  80182b:	00 00 00 
  80182e:	ff d0                	callq  *%rax
  801830:	85 c0                	test   %eax,%eax
  801832:	75 b6                	jne    8017ea <strstr+0x47>

    return (char *) (in - 1);
  801834:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801838:	48 83 e8 01          	sub    $0x1,%rax
}
  80183c:	c9                   	leaveq 
  80183d:	c3                   	retq   

000000000080183e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80183e:	55                   	push   %rbp
  80183f:	48 89 e5             	mov    %rsp,%rbp
  801842:	53                   	push   %rbx
  801843:	48 83 ec 48          	sub    $0x48,%rsp
  801847:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80184a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80184d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801851:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801855:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801859:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80185d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801860:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801864:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801868:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80186c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801870:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801874:	4c 89 c3             	mov    %r8,%rbx
  801877:	cd 30                	int    $0x30
  801879:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  80187d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801881:	74 3e                	je     8018c1 <syscall+0x83>
  801883:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801888:	7e 37                	jle    8018c1 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80188a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80188e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801891:	49 89 d0             	mov    %rdx,%r8
  801894:	89 c1                	mov    %eax,%ecx
  801896:	48 ba e0 40 80 00 00 	movabs $0x8040e0,%rdx
  80189d:	00 00 00 
  8018a0:	be 23 00 00 00       	mov    $0x23,%esi
  8018a5:	48 bf fd 40 80 00 00 	movabs $0x8040fd,%rdi
  8018ac:	00 00 00 
  8018af:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b4:	49 b9 80 37 80 00 00 	movabs $0x803780,%r9
  8018bb:	00 00 00 
  8018be:	41 ff d1             	callq  *%r9

	return ret;
  8018c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018c5:	48 83 c4 48          	add    $0x48,%rsp
  8018c9:	5b                   	pop    %rbx
  8018ca:	5d                   	pop    %rbp
  8018cb:	c3                   	retq   

00000000008018cc <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018cc:	55                   	push   %rbp
  8018cd:	48 89 e5             	mov    %rsp,%rbp
  8018d0:	48 83 ec 20          	sub    $0x20,%rsp
  8018d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018eb:	00 
  8018ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f8:	48 89 d1             	mov    %rdx,%rcx
  8018fb:	48 89 c2             	mov    %rax,%rdx
  8018fe:	be 00 00 00 00       	mov    $0x0,%esi
  801903:	bf 00 00 00 00       	mov    $0x0,%edi
  801908:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  80190f:	00 00 00 
  801912:	ff d0                	callq  *%rax
}
  801914:	c9                   	leaveq 
  801915:	c3                   	retq   

0000000000801916 <sys_cgetc>:

int
sys_cgetc(void)
{
  801916:	55                   	push   %rbp
  801917:	48 89 e5             	mov    %rsp,%rbp
  80191a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80191e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801925:	00 
  801926:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80192c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801932:	b9 00 00 00 00       	mov    $0x0,%ecx
  801937:	ba 00 00 00 00       	mov    $0x0,%edx
  80193c:	be 00 00 00 00       	mov    $0x0,%esi
  801941:	bf 01 00 00 00       	mov    $0x1,%edi
  801946:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  80194d:	00 00 00 
  801950:	ff d0                	callq  *%rax
}
  801952:	c9                   	leaveq 
  801953:	c3                   	retq   

0000000000801954 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801954:	55                   	push   %rbp
  801955:	48 89 e5             	mov    %rsp,%rbp
  801958:	48 83 ec 10          	sub    $0x10,%rsp
  80195c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80195f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801962:	48 98                	cltq   
  801964:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80196b:	00 
  80196c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801972:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801978:	b9 00 00 00 00       	mov    $0x0,%ecx
  80197d:	48 89 c2             	mov    %rax,%rdx
  801980:	be 01 00 00 00       	mov    $0x1,%esi
  801985:	bf 03 00 00 00       	mov    $0x3,%edi
  80198a:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801991:	00 00 00 
  801994:	ff d0                	callq  *%rax
}
  801996:	c9                   	leaveq 
  801997:	c3                   	retq   

0000000000801998 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801998:	55                   	push   %rbp
  801999:	48 89 e5             	mov    %rsp,%rbp
  80199c:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a7:	00 
  8019a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019be:	be 00 00 00 00       	mov    $0x0,%esi
  8019c3:	bf 02 00 00 00       	mov    $0x2,%edi
  8019c8:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  8019cf:	00 00 00 
  8019d2:	ff d0                	callq  *%rax
}
  8019d4:	c9                   	leaveq 
  8019d5:	c3                   	retq   

00000000008019d6 <sys_yield>:

void
sys_yield(void)
{
  8019d6:	55                   	push   %rbp
  8019d7:	48 89 e5             	mov    %rsp,%rbp
  8019da:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019de:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019e5:	00 
  8019e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fc:	be 00 00 00 00       	mov    $0x0,%esi
  801a01:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a06:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801a0d:	00 00 00 
  801a10:	ff d0                	callq  *%rax
}
  801a12:	c9                   	leaveq 
  801a13:	c3                   	retq   

0000000000801a14 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a14:	55                   	push   %rbp
  801a15:	48 89 e5             	mov    %rsp,%rbp
  801a18:	48 83 ec 20          	sub    $0x20,%rsp
  801a1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a23:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a26:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a29:	48 63 c8             	movslq %eax,%rcx
  801a2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a33:	48 98                	cltq   
  801a35:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3c:	00 
  801a3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a43:	49 89 c8             	mov    %rcx,%r8
  801a46:	48 89 d1             	mov    %rdx,%rcx
  801a49:	48 89 c2             	mov    %rax,%rdx
  801a4c:	be 01 00 00 00       	mov    $0x1,%esi
  801a51:	bf 04 00 00 00       	mov    $0x4,%edi
  801a56:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801a5d:	00 00 00 
  801a60:	ff d0                	callq  *%rax
}
  801a62:	c9                   	leaveq 
  801a63:	c3                   	retq   

0000000000801a64 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a64:	55                   	push   %rbp
  801a65:	48 89 e5             	mov    %rsp,%rbp
  801a68:	48 83 ec 30          	sub    $0x30,%rsp
  801a6c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a73:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a76:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a7a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a7e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a81:	48 63 c8             	movslq %eax,%rcx
  801a84:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a8b:	48 63 f0             	movslq %eax,%rsi
  801a8e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a95:	48 98                	cltq   
  801a97:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a9b:	49 89 f9             	mov    %rdi,%r9
  801a9e:	49 89 f0             	mov    %rsi,%r8
  801aa1:	48 89 d1             	mov    %rdx,%rcx
  801aa4:	48 89 c2             	mov    %rax,%rdx
  801aa7:	be 01 00 00 00       	mov    $0x1,%esi
  801aac:	bf 05 00 00 00       	mov    $0x5,%edi
  801ab1:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801ab8:	00 00 00 
  801abb:	ff d0                	callq  *%rax
}
  801abd:	c9                   	leaveq 
  801abe:	c3                   	retq   

0000000000801abf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801abf:	55                   	push   %rbp
  801ac0:	48 89 e5             	mov    %rsp,%rbp
  801ac3:	48 83 ec 20          	sub    $0x20,%rsp
  801ac7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ace:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad5:	48 98                	cltq   
  801ad7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ade:	00 
  801adf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aeb:	48 89 d1             	mov    %rdx,%rcx
  801aee:	48 89 c2             	mov    %rax,%rdx
  801af1:	be 01 00 00 00       	mov    $0x1,%esi
  801af6:	bf 06 00 00 00       	mov    $0x6,%edi
  801afb:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801b02:	00 00 00 
  801b05:	ff d0                	callq  *%rax
}
  801b07:	c9                   	leaveq 
  801b08:	c3                   	retq   

0000000000801b09 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b09:	55                   	push   %rbp
  801b0a:	48 89 e5             	mov    %rsp,%rbp
  801b0d:	48 83 ec 10          	sub    $0x10,%rsp
  801b11:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b14:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b17:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b1a:	48 63 d0             	movslq %eax,%rdx
  801b1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b20:	48 98                	cltq   
  801b22:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b29:	00 
  801b2a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b30:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b36:	48 89 d1             	mov    %rdx,%rcx
  801b39:	48 89 c2             	mov    %rax,%rdx
  801b3c:	be 01 00 00 00       	mov    $0x1,%esi
  801b41:	bf 08 00 00 00       	mov    $0x8,%edi
  801b46:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801b4d:	00 00 00 
  801b50:	ff d0                	callq  *%rax
}
  801b52:	c9                   	leaveq 
  801b53:	c3                   	retq   

0000000000801b54 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b54:	55                   	push   %rbp
  801b55:	48 89 e5             	mov    %rsp,%rbp
  801b58:	48 83 ec 20          	sub    $0x20,%rsp
  801b5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b6a:	48 98                	cltq   
  801b6c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b73:	00 
  801b74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b80:	48 89 d1             	mov    %rdx,%rcx
  801b83:	48 89 c2             	mov    %rax,%rdx
  801b86:	be 01 00 00 00       	mov    $0x1,%esi
  801b8b:	bf 09 00 00 00       	mov    $0x9,%edi
  801b90:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801b97:	00 00 00 
  801b9a:	ff d0                	callq  *%rax
}
  801b9c:	c9                   	leaveq 
  801b9d:	c3                   	retq   

0000000000801b9e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b9e:	55                   	push   %rbp
  801b9f:	48 89 e5             	mov    %rsp,%rbp
  801ba2:	48 83 ec 20          	sub    $0x20,%rsp
  801ba6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb4:	48 98                	cltq   
  801bb6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bbd:	00 
  801bbe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bca:	48 89 d1             	mov    %rdx,%rcx
  801bcd:	48 89 c2             	mov    %rax,%rdx
  801bd0:	be 01 00 00 00       	mov    $0x1,%esi
  801bd5:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bda:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801be1:	00 00 00 
  801be4:	ff d0                	callq  *%rax
}
  801be6:	c9                   	leaveq 
  801be7:	c3                   	retq   

0000000000801be8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801be8:	55                   	push   %rbp
  801be9:	48 89 e5             	mov    %rsp,%rbp
  801bec:	48 83 ec 20          	sub    $0x20,%rsp
  801bf0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bf7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bfb:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bfe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c01:	48 63 f0             	movslq %eax,%rsi
  801c04:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0b:	48 98                	cltq   
  801c0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c11:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c18:	00 
  801c19:	49 89 f1             	mov    %rsi,%r9
  801c1c:	49 89 c8             	mov    %rcx,%r8
  801c1f:	48 89 d1             	mov    %rdx,%rcx
  801c22:	48 89 c2             	mov    %rax,%rdx
  801c25:	be 00 00 00 00       	mov    $0x0,%esi
  801c2a:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c2f:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801c36:	00 00 00 
  801c39:	ff d0                	callq  *%rax
}
  801c3b:	c9                   	leaveq 
  801c3c:	c3                   	retq   

0000000000801c3d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c3d:	55                   	push   %rbp
  801c3e:	48 89 e5             	mov    %rsp,%rbp
  801c41:	48 83 ec 10          	sub    $0x10,%rsp
  801c45:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c4d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c54:	00 
  801c55:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c61:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c66:	48 89 c2             	mov    %rax,%rdx
  801c69:	be 01 00 00 00       	mov    $0x1,%esi
  801c6e:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c73:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  801c7a:	00 00 00 
  801c7d:	ff d0                	callq  *%rax
}
  801c7f:	c9                   	leaveq 
  801c80:	c3                   	retq   

0000000000801c81 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801c81:	55                   	push   %rbp
  801c82:	48 89 e5             	mov    %rsp,%rbp
  801c85:	48 83 ec 30          	sub    $0x30,%rsp
  801c89:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801c8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c91:	48 8b 00             	mov    (%rax),%rax
  801c94:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801c98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c9c:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ca0:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)))
  801ca3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ca6:	83 e0 02             	and    $0x2,%eax
  801ca9:	85 c0                	test   %eax,%eax
  801cab:	74 23                	je     801cd0 <pgfault+0x4f>
  801cad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb1:	48 c1 e8 0c          	shr    $0xc,%rax
  801cb5:	48 89 c2             	mov    %rax,%rdx
  801cb8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cbf:	01 00 00 
  801cc2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cc6:	25 00 08 00 00       	and    $0x800,%eax
  801ccb:	48 85 c0             	test   %rax,%rax
  801cce:	75 2a                	jne    801cfa <pgfault+0x79>
		panic("fail check at fork pgfault");
  801cd0:	48 ba 0b 41 80 00 00 	movabs $0x80410b,%rdx
  801cd7:	00 00 00 
  801cda:	be 1d 00 00 00       	mov    $0x1d,%esi
  801cdf:	48 bf 26 41 80 00 00 	movabs $0x804126,%rdi
  801ce6:	00 00 00 
  801ce9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cee:	48 b9 80 37 80 00 00 	movabs $0x803780,%rcx
  801cf5:	00 00 00 
  801cf8:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801cfa:	ba 07 00 00 00       	mov    $0x7,%edx
  801cff:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d04:	bf 00 00 00 00       	mov    $0x0,%edi
  801d09:	48 b8 14 1a 80 00 00 	movabs $0x801a14,%rax
  801d10:	00 00 00 
  801d13:	ff d0                	callq  *%rax

	addr = ROUNDDOWN(addr, PGSIZE);
  801d15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d19:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801d1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d21:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801d27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memmove(PFTEMP, addr, PGSIZE);
  801d2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d2f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d34:	48 89 c6             	mov    %rax,%rsi
  801d37:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801d3c:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  801d43:	00 00 00 
  801d46:	ff d0                	callq  *%rax

	sys_page_map(0, (void *)PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W);
  801d48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d4c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801d52:	48 89 c1             	mov    %rax,%rcx
  801d55:	ba 00 00 00 00       	mov    $0x0,%edx
  801d5a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d5f:	bf 00 00 00 00       	mov    $0x0,%edi
  801d64:	48 b8 64 1a 80 00 00 	movabs $0x801a64,%rax
  801d6b:	00 00 00 
  801d6e:	ff d0                	callq  *%rax
	sys_page_unmap(0, PFTEMP);
  801d70:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d75:	bf 00 00 00 00       	mov    $0x0,%edi
  801d7a:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  801d81:	00 00 00 
  801d84:	ff d0                	callq  *%rax
	//panic("pgfault not implemented");
}
  801d86:	c9                   	leaveq 
  801d87:	c3                   	retq   

0000000000801d88 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d88:	55                   	push   %rbp
  801d89:	48 89 e5             	mov    %rsp,%rbp
  801d8c:	48 83 ec 20          	sub    $0x20,%rsp
  801d90:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d93:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uintptr_t)pn * PGSIZE);
  801d96:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801d99:	48 c1 e0 0c          	shl    $0xc,%rax
  801d9d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	// note: modified for LAB 5, supporting PTE_SHARE
	if (uvpt[pn] & PTE_SHARE) {
  801da1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801da8:	01 00 00 
  801dab:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801dae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801db2:	25 00 04 00 00       	and    $0x400,%eax
  801db7:	48 85 c0             	test   %rax,%rax
  801dba:	74 55                	je     801e11 <duppage+0x89>
		if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL))) < 0)
  801dbc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dc3:	01 00 00 
  801dc6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801dc9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dcd:	25 07 0e 00 00       	and    $0xe07,%eax
  801dd2:	89 c6                	mov    %eax,%esi
  801dd4:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801dd8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ddb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ddf:	41 89 f0             	mov    %esi,%r8d
  801de2:	48 89 c6             	mov    %rax,%rsi
  801de5:	bf 00 00 00 00       	mov    $0x0,%edi
  801dea:	48 b8 64 1a 80 00 00 	movabs $0x801a64,%rax
  801df1:	00 00 00 
  801df4:	ff d0                	callq  *%rax
  801df6:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801df9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801dfd:	79 08                	jns    801e07 <duppage+0x7f>
			return r;
  801dff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e02:	e9 e1 00 00 00       	jmpq   801ee8 <duppage+0x160>
		return 0;
  801e07:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0c:	e9 d7 00 00 00       	jmpq   801ee8 <duppage+0x160>
	}

	// note: here we must set ~PTE_W and PTE_COW such that parent process can get correct pid
	if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  801e11:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e18:	01 00 00 
  801e1b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e1e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e22:	25 05 06 00 00       	and    $0x605,%eax
  801e27:	80 cc 08             	or     $0x8,%ah
  801e2a:	89 c6                	mov    %eax,%esi
  801e2c:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801e30:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e37:	41 89 f0             	mov    %esi,%r8d
  801e3a:	48 89 c6             	mov    %rax,%rsi
  801e3d:	bf 00 00 00 00       	mov    $0x0,%edi
  801e42:	48 b8 64 1a 80 00 00 	movabs $0x801a64,%rax
  801e49:	00 00 00 
  801e4c:	ff d0                	callq  *%rax
  801e4e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801e51:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e55:	79 08                	jns    801e5f <duppage+0xd7>
		return r;
  801e57:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e5a:	e9 89 00 00 00       	jmpq   801ee8 <duppage+0x160>

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  801e5f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e66:	01 00 00 
  801e69:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e6c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e70:	83 e0 02             	and    $0x2,%eax
  801e73:	48 85 c0             	test   %rax,%rax
  801e76:	75 1b                	jne    801e93 <duppage+0x10b>
  801e78:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e7f:	01 00 00 
  801e82:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e85:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e89:	25 00 08 00 00       	and    $0x800,%eax
  801e8e:	48 85 c0             	test   %rax,%rax
  801e91:	74 50                	je     801ee3 <duppage+0x15b>
		if ((r = sys_page_map(0, addr, 0, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  801e93:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e9a:	01 00 00 
  801e9d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801ea0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ea4:	25 05 06 00 00       	and    $0x605,%eax
  801ea9:	80 cc 08             	or     $0x8,%ah
  801eac:	89 c1                	mov    %eax,%ecx
  801eae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801eb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eb6:	41 89 c8             	mov    %ecx,%r8d
  801eb9:	48 89 d1             	mov    %rdx,%rcx
  801ebc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec1:	48 89 c6             	mov    %rax,%rsi
  801ec4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec9:	48 b8 64 1a 80 00 00 	movabs $0x801a64,%rax
  801ed0:	00 00 00 
  801ed3:	ff d0                	callq  *%rax
  801ed5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801ed8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801edc:	79 05                	jns    801ee3 <duppage+0x15b>
			return r;
  801ede:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ee1:	eb 05                	jmp    801ee8 <duppage+0x160>
	//panic("duppage not implemented");
	return 0;
  801ee3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee8:	c9                   	leaveq 
  801ee9:	c3                   	retq   

0000000000801eea <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801eea:	55                   	push   %rbp
  801eeb:	48 89 e5             	mov    %rsp,%rbp
  801eee:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	int r;
	envid_t envid;
	int i, j, k, l, ptx = 0;
  801ef2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	set_pgfault_handler(pgfault);
  801ef9:	48 bf 81 1c 80 00 00 	movabs $0x801c81,%rdi
  801f00:	00 00 00 
  801f03:	48 b8 94 38 80 00 00 	movabs $0x803894,%rax
  801f0a:	00 00 00 
  801f0d:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f0f:	b8 07 00 00 00       	mov    $0x7,%eax
  801f14:	cd 30                	int    $0x30
  801f16:	89 45 e0             	mov    %eax,-0x20(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f19:	8b 45 e0             	mov    -0x20(%rbp),%eax

	if ((envid = sys_exofork()) < 0)
  801f1c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  801f1f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801f23:	79 08                	jns    801f2d <fork+0x43>
		return envid;
  801f25:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f28:	e9 27 02 00 00       	jmpq   802154 <fork+0x26a>
	else if (envid == 0) {
  801f2d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801f31:	75 46                	jne    801f79 <fork+0x8f>
		thisenv = &envs[ENVX(sys_getenvid())];
  801f33:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  801f3a:	00 00 00 
  801f3d:	ff d0                	callq  *%rax
  801f3f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f44:	48 63 d0             	movslq %eax,%rdx
  801f47:	48 89 d0             	mov    %rdx,%rax
  801f4a:	48 c1 e0 03          	shl    $0x3,%rax
  801f4e:	48 01 d0             	add    %rdx,%rax
  801f51:	48 c1 e0 05          	shl    $0x5,%rax
  801f55:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801f5c:	00 00 00 
  801f5f:	48 01 c2             	add    %rax,%rdx
  801f62:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801f69:	00 00 00 
  801f6c:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f74:	e9 db 01 00 00       	jmpq   802154 <fork+0x26a>
	}

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801f79:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f7c:	ba 07 00 00 00       	mov    $0x7,%edx
  801f81:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801f86:	89 c7                	mov    %eax,%edi
  801f88:	48 b8 14 1a 80 00 00 	movabs $0x801a14,%rax
  801f8f:	00 00 00 
  801f92:	ff d0                	callq  *%rax
  801f94:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  801f97:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801f9b:	79 08                	jns    801fa5 <fork+0xbb>
		return r;
  801f9d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801fa0:	e9 af 01 00 00       	jmpq   802154 <fork+0x26a>

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  801fa5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fac:	e9 49 01 00 00       	jmpq   8020fa <fork+0x210>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  801fb1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fb4:	8d 90 ff ff ff 07    	lea    0x7ffffff(%rax),%edx
  801fba:	85 c0                	test   %eax,%eax
  801fbc:	0f 48 c2             	cmovs  %edx,%eax
  801fbf:	c1 f8 1b             	sar    $0x1b,%eax
  801fc2:	89 c2                	mov    %eax,%edx
  801fc4:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801fcb:	01 00 00 
  801fce:	48 63 d2             	movslq %edx,%rdx
  801fd1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fd5:	83 e0 01             	and    $0x1,%eax
  801fd8:	48 85 c0             	test   %rax,%rax
  801fdb:	75 0c                	jne    801fe9 <fork+0xff>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  801fdd:	81 45 ec 00 00 00 08 	addl   $0x8000000,-0x14(%rbp)
			continue;
  801fe4:	e9 0d 01 00 00       	jmpq   8020f6 <fork+0x20c>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  801fe9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  801ff0:	e9 f4 00 00 00       	jmpq   8020e9 <fork+0x1ff>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  801ff5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ff8:	8d 90 ff ff 03 00    	lea    0x3ffff(%rax),%edx
  801ffe:	85 c0                	test   %eax,%eax
  802000:	0f 48 c2             	cmovs  %edx,%eax
  802003:	c1 f8 12             	sar    $0x12,%eax
  802006:	89 c2                	mov    %eax,%edx
  802008:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80200f:	01 00 00 
  802012:	48 63 d2             	movslq %edx,%rdx
  802015:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802019:	83 e0 01             	and    $0x1,%eax
  80201c:	48 85 c0             	test   %rax,%rax
  80201f:	75 0c                	jne    80202d <fork+0x143>
				ptx += NPDENTRIES * NPTENTRIES;
  802021:	81 45 ec 00 00 04 00 	addl   $0x40000,-0x14(%rbp)
				continue;
  802028:	e9 b8 00 00 00       	jmpq   8020e5 <fork+0x1fb>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  80202d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  802034:	e9 9f 00 00 00       	jmpq   8020d8 <fork+0x1ee>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  802039:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80203c:	8d 90 ff 01 00 00    	lea    0x1ff(%rax),%edx
  802042:	85 c0                	test   %eax,%eax
  802044:	0f 48 c2             	cmovs  %edx,%eax
  802047:	c1 f8 09             	sar    $0x9,%eax
  80204a:	89 c2                	mov    %eax,%edx
  80204c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802053:	01 00 00 
  802056:	48 63 d2             	movslq %edx,%rdx
  802059:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80205d:	83 e0 01             	and    $0x1,%eax
  802060:	48 85 c0             	test   %rax,%rax
  802063:	75 09                	jne    80206e <fork+0x184>
					ptx += NPTENTRIES;
  802065:	81 45 ec 00 02 00 00 	addl   $0x200,-0x14(%rbp)
					continue;
  80206c:	eb 66                	jmp    8020d4 <fork+0x1ea>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  80206e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  802075:	eb 54                	jmp    8020cb <fork+0x1e1>
					if ((uvpt[ptx] & PTE_P) != 0)
  802077:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80207e:	01 00 00 
  802081:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802084:	48 63 d2             	movslq %edx,%rdx
  802087:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80208b:	83 e0 01             	and    $0x1,%eax
  80208e:	48 85 c0             	test   %rax,%rax
  802091:	74 30                	je     8020c3 <fork+0x1d9>
						if (ptx != VPN(UXSTACKTOP - PGSIZE))
  802093:	81 7d ec ff f7 0e 00 	cmpl   $0xef7ff,-0x14(%rbp)
  80209a:	74 27                	je     8020c3 <fork+0x1d9>
							if ((r = duppage(envid, ptx)) < 0)
  80209c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80209f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020a2:	89 d6                	mov    %edx,%esi
  8020a4:	89 c7                	mov    %eax,%edi
  8020a6:	48 b8 88 1d 80 00 00 	movabs $0x801d88,%rax
  8020ad:	00 00 00 
  8020b0:	ff d0                	callq  *%rax
  8020b2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8020b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8020b9:	79 08                	jns    8020c3 <fork+0x1d9>
								return r;
  8020bb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8020be:	e9 91 00 00 00       	jmpq   802154 <fork+0x26a>
					ptx++;
  8020c3:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  8020c7:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8020cb:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
  8020d2:	7e a3                	jle    802077 <fork+0x18d>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  8020d4:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8020d8:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
  8020df:	0f 8e 54 ff ff ff    	jle    802039 <fork+0x14f>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  8020e5:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8020e9:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
  8020f0:	0f 8e ff fe ff ff    	jle    801ff5 <fork+0x10b>
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		return r;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  8020f6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020fe:	0f 84 ad fe ff ff    	je     801fb1 <fork+0xc7>
			}
		}
	}

	extern void _pgfault_upcall();
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  802104:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802107:	48 be ff 38 80 00 00 	movabs $0x8038ff,%rsi
  80210e:	00 00 00 
  802111:	89 c7                	mov    %eax,%edi
  802113:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  80211a:	00 00 00 
  80211d:	ff d0                	callq  *%rax
  80211f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802122:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802126:	79 05                	jns    80212d <fork+0x243>
		return r;
  802128:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80212b:	eb 27                	jmp    802154 <fork+0x26a>
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80212d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802130:	be 02 00 00 00       	mov    $0x2,%esi
  802135:	89 c7                	mov    %eax,%edi
  802137:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  80213e:	00 00 00 
  802141:	ff d0                	callq  *%rax
  802143:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802146:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80214a:	79 05                	jns    802151 <fork+0x267>
		return r;
  80214c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80214f:	eb 03                	jmp    802154 <fork+0x26a>

	return envid;
  802151:	8b 45 e8             	mov    -0x18(%rbp),%eax
	//panic("fork not implemented");
}
  802154:	c9                   	leaveq 
  802155:	c3                   	retq   

0000000000802156 <sfork>:

// Challenge!
int
sfork(void)
{
  802156:	55                   	push   %rbp
  802157:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80215a:	48 ba 31 41 80 00 00 	movabs $0x804131,%rdx
  802161:	00 00 00 
  802164:	be a7 00 00 00       	mov    $0xa7,%esi
  802169:	48 bf 26 41 80 00 00 	movabs $0x804126,%rdi
  802170:	00 00 00 
  802173:	b8 00 00 00 00       	mov    $0x0,%eax
  802178:	48 b9 80 37 80 00 00 	movabs $0x803780,%rcx
  80217f:	00 00 00 
  802182:	ff d1                	callq  *%rcx

0000000000802184 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802184:	55                   	push   %rbp
  802185:	48 89 e5             	mov    %rsp,%rbp
  802188:	48 83 ec 08          	sub    $0x8,%rsp
  80218c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802190:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802194:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80219b:	ff ff ff 
  80219e:	48 01 d0             	add    %rdx,%rax
  8021a1:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8021a5:	c9                   	leaveq 
  8021a6:	c3                   	retq   

00000000008021a7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8021a7:	55                   	push   %rbp
  8021a8:	48 89 e5             	mov    %rsp,%rbp
  8021ab:	48 83 ec 08          	sub    $0x8,%rsp
  8021af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8021b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021b7:	48 89 c7             	mov    %rax,%rdi
  8021ba:	48 b8 84 21 80 00 00 	movabs $0x802184,%rax
  8021c1:	00 00 00 
  8021c4:	ff d0                	callq  *%rax
  8021c6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8021cc:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8021d0:	c9                   	leaveq 
  8021d1:	c3                   	retq   

00000000008021d2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8021d2:	55                   	push   %rbp
  8021d3:	48 89 e5             	mov    %rsp,%rbp
  8021d6:	48 83 ec 18          	sub    $0x18,%rsp
  8021da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8021de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021e5:	eb 6b                	jmp    802252 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8021e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ea:	48 98                	cltq   
  8021ec:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021f2:	48 c1 e0 0c          	shl    $0xc,%rax
  8021f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8021fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021fe:	48 c1 e8 15          	shr    $0x15,%rax
  802202:	48 89 c2             	mov    %rax,%rdx
  802205:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80220c:	01 00 00 
  80220f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802213:	83 e0 01             	and    $0x1,%eax
  802216:	48 85 c0             	test   %rax,%rax
  802219:	74 21                	je     80223c <fd_alloc+0x6a>
  80221b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80221f:	48 c1 e8 0c          	shr    $0xc,%rax
  802223:	48 89 c2             	mov    %rax,%rdx
  802226:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80222d:	01 00 00 
  802230:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802234:	83 e0 01             	and    $0x1,%eax
  802237:	48 85 c0             	test   %rax,%rax
  80223a:	75 12                	jne    80224e <fd_alloc+0x7c>
			*fd_store = fd;
  80223c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802240:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802244:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802247:	b8 00 00 00 00       	mov    $0x0,%eax
  80224c:	eb 1a                	jmp    802268 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80224e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802252:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802256:	7e 8f                	jle    8021e7 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802258:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802263:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802268:	c9                   	leaveq 
  802269:	c3                   	retq   

000000000080226a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80226a:	55                   	push   %rbp
  80226b:	48 89 e5             	mov    %rsp,%rbp
  80226e:	48 83 ec 20          	sub    $0x20,%rsp
  802272:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802275:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802279:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80227d:	78 06                	js     802285 <fd_lookup+0x1b>
  80227f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802283:	7e 07                	jle    80228c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802285:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80228a:	eb 6c                	jmp    8022f8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80228c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80228f:	48 98                	cltq   
  802291:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802297:	48 c1 e0 0c          	shl    $0xc,%rax
  80229b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80229f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022a3:	48 c1 e8 15          	shr    $0x15,%rax
  8022a7:	48 89 c2             	mov    %rax,%rdx
  8022aa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022b1:	01 00 00 
  8022b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b8:	83 e0 01             	and    $0x1,%eax
  8022bb:	48 85 c0             	test   %rax,%rax
  8022be:	74 21                	je     8022e1 <fd_lookup+0x77>
  8022c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022c4:	48 c1 e8 0c          	shr    $0xc,%rax
  8022c8:	48 89 c2             	mov    %rax,%rdx
  8022cb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022d2:	01 00 00 
  8022d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022d9:	83 e0 01             	and    $0x1,%eax
  8022dc:	48 85 c0             	test   %rax,%rax
  8022df:	75 07                	jne    8022e8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022e6:	eb 10                	jmp    8022f8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8022e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8022f0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8022f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022f8:	c9                   	leaveq 
  8022f9:	c3                   	retq   

00000000008022fa <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8022fa:	55                   	push   %rbp
  8022fb:	48 89 e5             	mov    %rsp,%rbp
  8022fe:	48 83 ec 30          	sub    $0x30,%rsp
  802302:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802306:	89 f0                	mov    %esi,%eax
  802308:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80230b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80230f:	48 89 c7             	mov    %rax,%rdi
  802312:	48 b8 84 21 80 00 00 	movabs $0x802184,%rax
  802319:	00 00 00 
  80231c:	ff d0                	callq  *%rax
  80231e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802322:	48 89 d6             	mov    %rdx,%rsi
  802325:	89 c7                	mov    %eax,%edi
  802327:	48 b8 6a 22 80 00 00 	movabs $0x80226a,%rax
  80232e:	00 00 00 
  802331:	ff d0                	callq  *%rax
  802333:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802336:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80233a:	78 0a                	js     802346 <fd_close+0x4c>
	    || fd != fd2)
  80233c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802340:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802344:	74 12                	je     802358 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802346:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80234a:	74 05                	je     802351 <fd_close+0x57>
  80234c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80234f:	eb 05                	jmp    802356 <fd_close+0x5c>
  802351:	b8 00 00 00 00       	mov    $0x0,%eax
  802356:	eb 69                	jmp    8023c1 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802358:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80235c:	8b 00                	mov    (%rax),%eax
  80235e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802362:	48 89 d6             	mov    %rdx,%rsi
  802365:	89 c7                	mov    %eax,%edi
  802367:	48 b8 c3 23 80 00 00 	movabs $0x8023c3,%rax
  80236e:	00 00 00 
  802371:	ff d0                	callq  *%rax
  802373:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802376:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80237a:	78 2a                	js     8023a6 <fd_close+0xac>
		if (dev->dev_close)
  80237c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802380:	48 8b 40 20          	mov    0x20(%rax),%rax
  802384:	48 85 c0             	test   %rax,%rax
  802387:	74 16                	je     80239f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802389:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80238d:	48 8b 40 20          	mov    0x20(%rax),%rax
  802391:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802395:	48 89 d7             	mov    %rdx,%rdi
  802398:	ff d0                	callq  *%rax
  80239a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80239d:	eb 07                	jmp    8023a6 <fd_close+0xac>
		else
			r = 0;
  80239f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8023a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023aa:	48 89 c6             	mov    %rax,%rsi
  8023ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8023b2:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  8023b9:	00 00 00 
  8023bc:	ff d0                	callq  *%rax
	return r;
  8023be:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023c1:	c9                   	leaveq 
  8023c2:	c3                   	retq   

00000000008023c3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8023c3:	55                   	push   %rbp
  8023c4:	48 89 e5             	mov    %rsp,%rbp
  8023c7:	48 83 ec 20          	sub    $0x20,%rsp
  8023cb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8023d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023d9:	eb 41                	jmp    80241c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8023db:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8023e2:	00 00 00 
  8023e5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023e8:	48 63 d2             	movslq %edx,%rdx
  8023eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023ef:	8b 00                	mov    (%rax),%eax
  8023f1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8023f4:	75 22                	jne    802418 <dev_lookup+0x55>
			*dev = devtab[i];
  8023f6:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8023fd:	00 00 00 
  802400:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802403:	48 63 d2             	movslq %edx,%rdx
  802406:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80240a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80240e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802411:	b8 00 00 00 00       	mov    $0x0,%eax
  802416:	eb 60                	jmp    802478 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802418:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80241c:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802423:	00 00 00 
  802426:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802429:	48 63 d2             	movslq %edx,%rdx
  80242c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802430:	48 85 c0             	test   %rax,%rax
  802433:	75 a6                	jne    8023db <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802435:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80243c:	00 00 00 
  80243f:	48 8b 00             	mov    (%rax),%rax
  802442:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802448:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80244b:	89 c6                	mov    %eax,%esi
  80244d:	48 bf 48 41 80 00 00 	movabs $0x804148,%rdi
  802454:	00 00 00 
  802457:	b8 00 00 00 00       	mov    $0x0,%eax
  80245c:	48 b9 3d 03 80 00 00 	movabs $0x80033d,%rcx
  802463:	00 00 00 
  802466:	ff d1                	callq  *%rcx
	*dev = 0;
  802468:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80246c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802473:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802478:	c9                   	leaveq 
  802479:	c3                   	retq   

000000000080247a <close>:

int
close(int fdnum)
{
  80247a:	55                   	push   %rbp
  80247b:	48 89 e5             	mov    %rsp,%rbp
  80247e:	48 83 ec 20          	sub    $0x20,%rsp
  802482:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802485:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802489:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80248c:	48 89 d6             	mov    %rdx,%rsi
  80248f:	89 c7                	mov    %eax,%edi
  802491:	48 b8 6a 22 80 00 00 	movabs $0x80226a,%rax
  802498:	00 00 00 
  80249b:	ff d0                	callq  *%rax
  80249d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a4:	79 05                	jns    8024ab <close+0x31>
		return r;
  8024a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a9:	eb 18                	jmp    8024c3 <close+0x49>
	else
		return fd_close(fd, 1);
  8024ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024af:	be 01 00 00 00       	mov    $0x1,%esi
  8024b4:	48 89 c7             	mov    %rax,%rdi
  8024b7:	48 b8 fa 22 80 00 00 	movabs $0x8022fa,%rax
  8024be:	00 00 00 
  8024c1:	ff d0                	callq  *%rax
}
  8024c3:	c9                   	leaveq 
  8024c4:	c3                   	retq   

00000000008024c5 <close_all>:

void
close_all(void)
{
  8024c5:	55                   	push   %rbp
  8024c6:	48 89 e5             	mov    %rsp,%rbp
  8024c9:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8024cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024d4:	eb 15                	jmp    8024eb <close_all+0x26>
		close(i);
  8024d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d9:	89 c7                	mov    %eax,%edi
  8024db:	48 b8 7a 24 80 00 00 	movabs $0x80247a,%rax
  8024e2:	00 00 00 
  8024e5:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8024e7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024eb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8024ef:	7e e5                	jle    8024d6 <close_all+0x11>
		close(i);
}
  8024f1:	c9                   	leaveq 
  8024f2:	c3                   	retq   

00000000008024f3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8024f3:	55                   	push   %rbp
  8024f4:	48 89 e5             	mov    %rsp,%rbp
  8024f7:	48 83 ec 40          	sub    $0x40,%rsp
  8024fb:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8024fe:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802501:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802505:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802508:	48 89 d6             	mov    %rdx,%rsi
  80250b:	89 c7                	mov    %eax,%edi
  80250d:	48 b8 6a 22 80 00 00 	movabs $0x80226a,%rax
  802514:	00 00 00 
  802517:	ff d0                	callq  *%rax
  802519:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80251c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802520:	79 08                	jns    80252a <dup+0x37>
		return r;
  802522:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802525:	e9 70 01 00 00       	jmpq   80269a <dup+0x1a7>
	close(newfdnum);
  80252a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80252d:	89 c7                	mov    %eax,%edi
  80252f:	48 b8 7a 24 80 00 00 	movabs $0x80247a,%rax
  802536:	00 00 00 
  802539:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80253b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80253e:	48 98                	cltq   
  802540:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802546:	48 c1 e0 0c          	shl    $0xc,%rax
  80254a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80254e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802552:	48 89 c7             	mov    %rax,%rdi
  802555:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  80255c:	00 00 00 
  80255f:	ff d0                	callq  *%rax
  802561:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802565:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802569:	48 89 c7             	mov    %rax,%rdi
  80256c:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  802573:	00 00 00 
  802576:	ff d0                	callq  *%rax
  802578:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80257c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802580:	48 c1 e8 15          	shr    $0x15,%rax
  802584:	48 89 c2             	mov    %rax,%rdx
  802587:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80258e:	01 00 00 
  802591:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802595:	83 e0 01             	and    $0x1,%eax
  802598:	48 85 c0             	test   %rax,%rax
  80259b:	74 73                	je     802610 <dup+0x11d>
  80259d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a1:	48 c1 e8 0c          	shr    $0xc,%rax
  8025a5:	48 89 c2             	mov    %rax,%rdx
  8025a8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025af:	01 00 00 
  8025b2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025b6:	83 e0 01             	and    $0x1,%eax
  8025b9:	48 85 c0             	test   %rax,%rax
  8025bc:	74 52                	je     802610 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8025be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c2:	48 c1 e8 0c          	shr    $0xc,%rax
  8025c6:	48 89 c2             	mov    %rax,%rdx
  8025c9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025d0:	01 00 00 
  8025d3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025d7:	25 07 0e 00 00       	and    $0xe07,%eax
  8025dc:	89 c1                	mov    %eax,%ecx
  8025de:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025e6:	41 89 c8             	mov    %ecx,%r8d
  8025e9:	48 89 d1             	mov    %rdx,%rcx
  8025ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8025f1:	48 89 c6             	mov    %rax,%rsi
  8025f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8025f9:	48 b8 64 1a 80 00 00 	movabs $0x801a64,%rax
  802600:	00 00 00 
  802603:	ff d0                	callq  *%rax
  802605:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802608:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80260c:	79 02                	jns    802610 <dup+0x11d>
			goto err;
  80260e:	eb 57                	jmp    802667 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802610:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802614:	48 c1 e8 0c          	shr    $0xc,%rax
  802618:	48 89 c2             	mov    %rax,%rdx
  80261b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802622:	01 00 00 
  802625:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802629:	25 07 0e 00 00       	and    $0xe07,%eax
  80262e:	89 c1                	mov    %eax,%ecx
  802630:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802634:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802638:	41 89 c8             	mov    %ecx,%r8d
  80263b:	48 89 d1             	mov    %rdx,%rcx
  80263e:	ba 00 00 00 00       	mov    $0x0,%edx
  802643:	48 89 c6             	mov    %rax,%rsi
  802646:	bf 00 00 00 00       	mov    $0x0,%edi
  80264b:	48 b8 64 1a 80 00 00 	movabs $0x801a64,%rax
  802652:	00 00 00 
  802655:	ff d0                	callq  *%rax
  802657:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265e:	79 02                	jns    802662 <dup+0x16f>
		goto err;
  802660:	eb 05                	jmp    802667 <dup+0x174>

	return newfdnum;
  802662:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802665:	eb 33                	jmp    80269a <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802667:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80266b:	48 89 c6             	mov    %rax,%rsi
  80266e:	bf 00 00 00 00       	mov    $0x0,%edi
  802673:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  80267a:	00 00 00 
  80267d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80267f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802683:	48 89 c6             	mov    %rax,%rsi
  802686:	bf 00 00 00 00       	mov    $0x0,%edi
  80268b:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  802692:	00 00 00 
  802695:	ff d0                	callq  *%rax
	return r;
  802697:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80269a:	c9                   	leaveq 
  80269b:	c3                   	retq   

000000000080269c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80269c:	55                   	push   %rbp
  80269d:	48 89 e5             	mov    %rsp,%rbp
  8026a0:	48 83 ec 40          	sub    $0x40,%rsp
  8026a4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026a7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026ab:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026af:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026b3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026b6:	48 89 d6             	mov    %rdx,%rsi
  8026b9:	89 c7                	mov    %eax,%edi
  8026bb:	48 b8 6a 22 80 00 00 	movabs $0x80226a,%rax
  8026c2:	00 00 00 
  8026c5:	ff d0                	callq  *%rax
  8026c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ce:	78 24                	js     8026f4 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d4:	8b 00                	mov    (%rax),%eax
  8026d6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026da:	48 89 d6             	mov    %rdx,%rsi
  8026dd:	89 c7                	mov    %eax,%edi
  8026df:	48 b8 c3 23 80 00 00 	movabs $0x8023c3,%rax
  8026e6:	00 00 00 
  8026e9:	ff d0                	callq  *%rax
  8026eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f2:	79 05                	jns    8026f9 <read+0x5d>
		return r;
  8026f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f7:	eb 76                	jmp    80276f <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8026f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026fd:	8b 40 08             	mov    0x8(%rax),%eax
  802700:	83 e0 03             	and    $0x3,%eax
  802703:	83 f8 01             	cmp    $0x1,%eax
  802706:	75 3a                	jne    802742 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802708:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80270f:	00 00 00 
  802712:	48 8b 00             	mov    (%rax),%rax
  802715:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80271b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80271e:	89 c6                	mov    %eax,%esi
  802720:	48 bf 67 41 80 00 00 	movabs $0x804167,%rdi
  802727:	00 00 00 
  80272a:	b8 00 00 00 00       	mov    $0x0,%eax
  80272f:	48 b9 3d 03 80 00 00 	movabs $0x80033d,%rcx
  802736:	00 00 00 
  802739:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80273b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802740:	eb 2d                	jmp    80276f <read+0xd3>
	}
	if (!dev->dev_read)
  802742:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802746:	48 8b 40 10          	mov    0x10(%rax),%rax
  80274a:	48 85 c0             	test   %rax,%rax
  80274d:	75 07                	jne    802756 <read+0xba>
		return -E_NOT_SUPP;
  80274f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802754:	eb 19                	jmp    80276f <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802756:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80275a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80275e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802762:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802766:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80276a:	48 89 cf             	mov    %rcx,%rdi
  80276d:	ff d0                	callq  *%rax
}
  80276f:	c9                   	leaveq 
  802770:	c3                   	retq   

0000000000802771 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802771:	55                   	push   %rbp
  802772:	48 89 e5             	mov    %rsp,%rbp
  802775:	48 83 ec 30          	sub    $0x30,%rsp
  802779:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80277c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802780:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802784:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80278b:	eb 49                	jmp    8027d6 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80278d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802790:	48 98                	cltq   
  802792:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802796:	48 29 c2             	sub    %rax,%rdx
  802799:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80279c:	48 63 c8             	movslq %eax,%rcx
  80279f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027a3:	48 01 c1             	add    %rax,%rcx
  8027a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027a9:	48 89 ce             	mov    %rcx,%rsi
  8027ac:	89 c7                	mov    %eax,%edi
  8027ae:	48 b8 9c 26 80 00 00 	movabs $0x80269c,%rax
  8027b5:	00 00 00 
  8027b8:	ff d0                	callq  *%rax
  8027ba:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8027bd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027c1:	79 05                	jns    8027c8 <readn+0x57>
			return m;
  8027c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027c6:	eb 1c                	jmp    8027e4 <readn+0x73>
		if (m == 0)
  8027c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027cc:	75 02                	jne    8027d0 <readn+0x5f>
			break;
  8027ce:	eb 11                	jmp    8027e1 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027d3:	01 45 fc             	add    %eax,-0x4(%rbp)
  8027d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d9:	48 98                	cltq   
  8027db:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8027df:	72 ac                	jb     80278d <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8027e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027e4:	c9                   	leaveq 
  8027e5:	c3                   	retq   

00000000008027e6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8027e6:	55                   	push   %rbp
  8027e7:	48 89 e5             	mov    %rsp,%rbp
  8027ea:	48 83 ec 40          	sub    $0x40,%rsp
  8027ee:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027f1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8027f5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027f9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027fd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802800:	48 89 d6             	mov    %rdx,%rsi
  802803:	89 c7                	mov    %eax,%edi
  802805:	48 b8 6a 22 80 00 00 	movabs $0x80226a,%rax
  80280c:	00 00 00 
  80280f:	ff d0                	callq  *%rax
  802811:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802814:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802818:	78 24                	js     80283e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80281a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80281e:	8b 00                	mov    (%rax),%eax
  802820:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802824:	48 89 d6             	mov    %rdx,%rsi
  802827:	89 c7                	mov    %eax,%edi
  802829:	48 b8 c3 23 80 00 00 	movabs $0x8023c3,%rax
  802830:	00 00 00 
  802833:	ff d0                	callq  *%rax
  802835:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802838:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80283c:	79 05                	jns    802843 <write+0x5d>
		return r;
  80283e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802841:	eb 75                	jmp    8028b8 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802843:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802847:	8b 40 08             	mov    0x8(%rax),%eax
  80284a:	83 e0 03             	and    $0x3,%eax
  80284d:	85 c0                	test   %eax,%eax
  80284f:	75 3a                	jne    80288b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802851:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802858:	00 00 00 
  80285b:	48 8b 00             	mov    (%rax),%rax
  80285e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802864:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802867:	89 c6                	mov    %eax,%esi
  802869:	48 bf 83 41 80 00 00 	movabs $0x804183,%rdi
  802870:	00 00 00 
  802873:	b8 00 00 00 00       	mov    $0x0,%eax
  802878:	48 b9 3d 03 80 00 00 	movabs $0x80033d,%rcx
  80287f:	00 00 00 
  802882:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802884:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802889:	eb 2d                	jmp    8028b8 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80288b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80288f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802893:	48 85 c0             	test   %rax,%rax
  802896:	75 07                	jne    80289f <write+0xb9>
		return -E_NOT_SUPP;
  802898:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80289d:	eb 19                	jmp    8028b8 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80289f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028a7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028ab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028af:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028b3:	48 89 cf             	mov    %rcx,%rdi
  8028b6:	ff d0                	callq  *%rax
}
  8028b8:	c9                   	leaveq 
  8028b9:	c3                   	retq   

00000000008028ba <seek>:

int
seek(int fdnum, off_t offset)
{
  8028ba:	55                   	push   %rbp
  8028bb:	48 89 e5             	mov    %rsp,%rbp
  8028be:	48 83 ec 18          	sub    $0x18,%rsp
  8028c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028c5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028c8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028cf:	48 89 d6             	mov    %rdx,%rsi
  8028d2:	89 c7                	mov    %eax,%edi
  8028d4:	48 b8 6a 22 80 00 00 	movabs $0x80226a,%rax
  8028db:	00 00 00 
  8028de:	ff d0                	callq  *%rax
  8028e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e7:	79 05                	jns    8028ee <seek+0x34>
		return r;
  8028e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ec:	eb 0f                	jmp    8028fd <seek+0x43>
	fd->fd_offset = offset;
  8028ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8028f5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8028f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028fd:	c9                   	leaveq 
  8028fe:	c3                   	retq   

00000000008028ff <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8028ff:	55                   	push   %rbp
  802900:	48 89 e5             	mov    %rsp,%rbp
  802903:	48 83 ec 30          	sub    $0x30,%rsp
  802907:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80290a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80290d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802911:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802914:	48 89 d6             	mov    %rdx,%rsi
  802917:	89 c7                	mov    %eax,%edi
  802919:	48 b8 6a 22 80 00 00 	movabs $0x80226a,%rax
  802920:	00 00 00 
  802923:	ff d0                	callq  *%rax
  802925:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802928:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80292c:	78 24                	js     802952 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80292e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802932:	8b 00                	mov    (%rax),%eax
  802934:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802938:	48 89 d6             	mov    %rdx,%rsi
  80293b:	89 c7                	mov    %eax,%edi
  80293d:	48 b8 c3 23 80 00 00 	movabs $0x8023c3,%rax
  802944:	00 00 00 
  802947:	ff d0                	callq  *%rax
  802949:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802950:	79 05                	jns    802957 <ftruncate+0x58>
		return r;
  802952:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802955:	eb 72                	jmp    8029c9 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802957:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80295b:	8b 40 08             	mov    0x8(%rax),%eax
  80295e:	83 e0 03             	and    $0x3,%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	75 3a                	jne    80299f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802965:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80296c:	00 00 00 
  80296f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802972:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802978:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80297b:	89 c6                	mov    %eax,%esi
  80297d:	48 bf a0 41 80 00 00 	movabs $0x8041a0,%rdi
  802984:	00 00 00 
  802987:	b8 00 00 00 00       	mov    $0x0,%eax
  80298c:	48 b9 3d 03 80 00 00 	movabs $0x80033d,%rcx
  802993:	00 00 00 
  802996:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802998:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80299d:	eb 2a                	jmp    8029c9 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80299f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a3:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029a7:	48 85 c0             	test   %rax,%rax
  8029aa:	75 07                	jne    8029b3 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8029ac:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029b1:	eb 16                	jmp    8029c9 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8029b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b7:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029bf:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8029c2:	89 ce                	mov    %ecx,%esi
  8029c4:	48 89 d7             	mov    %rdx,%rdi
  8029c7:	ff d0                	callq  *%rax
}
  8029c9:	c9                   	leaveq 
  8029ca:	c3                   	retq   

00000000008029cb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8029cb:	55                   	push   %rbp
  8029cc:	48 89 e5             	mov    %rsp,%rbp
  8029cf:	48 83 ec 30          	sub    $0x30,%rsp
  8029d3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029d6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029da:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029de:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029e1:	48 89 d6             	mov    %rdx,%rsi
  8029e4:	89 c7                	mov    %eax,%edi
  8029e6:	48 b8 6a 22 80 00 00 	movabs $0x80226a,%rax
  8029ed:	00 00 00 
  8029f0:	ff d0                	callq  *%rax
  8029f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f9:	78 24                	js     802a1f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ff:	8b 00                	mov    (%rax),%eax
  802a01:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a05:	48 89 d6             	mov    %rdx,%rsi
  802a08:	89 c7                	mov    %eax,%edi
  802a0a:	48 b8 c3 23 80 00 00 	movabs $0x8023c3,%rax
  802a11:	00 00 00 
  802a14:	ff d0                	callq  *%rax
  802a16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a1d:	79 05                	jns    802a24 <fstat+0x59>
		return r;
  802a1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a22:	eb 5e                	jmp    802a82 <fstat+0xb7>
	if (!dev->dev_stat)
  802a24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a28:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a2c:	48 85 c0             	test   %rax,%rax
  802a2f:	75 07                	jne    802a38 <fstat+0x6d>
		return -E_NOT_SUPP;
  802a31:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a36:	eb 4a                	jmp    802a82 <fstat+0xb7>
	stat->st_name[0] = 0;
  802a38:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a3c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802a3f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a43:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a4a:	00 00 00 
	stat->st_isdir = 0;
  802a4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a51:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a58:	00 00 00 
	stat->st_dev = dev;
  802a5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a63:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802a6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a6e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a72:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a76:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a7a:	48 89 ce             	mov    %rcx,%rsi
  802a7d:	48 89 d7             	mov    %rdx,%rdi
  802a80:	ff d0                	callq  *%rax
}
  802a82:	c9                   	leaveq 
  802a83:	c3                   	retq   

0000000000802a84 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802a84:	55                   	push   %rbp
  802a85:	48 89 e5             	mov    %rsp,%rbp
  802a88:	48 83 ec 20          	sub    $0x20,%rsp
  802a8c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a90:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802a94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a98:	be 00 00 00 00       	mov    $0x0,%esi
  802a9d:	48 89 c7             	mov    %rax,%rdi
  802aa0:	48 b8 72 2b 80 00 00 	movabs $0x802b72,%rax
  802aa7:	00 00 00 
  802aaa:	ff d0                	callq  *%rax
  802aac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aaf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab3:	79 05                	jns    802aba <stat+0x36>
		return fd;
  802ab5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab8:	eb 2f                	jmp    802ae9 <stat+0x65>
	r = fstat(fd, stat);
  802aba:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802abe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac1:	48 89 d6             	mov    %rdx,%rsi
  802ac4:	89 c7                	mov    %eax,%edi
  802ac6:	48 b8 cb 29 80 00 00 	movabs $0x8029cb,%rax
  802acd:	00 00 00 
  802ad0:	ff d0                	callq  *%rax
  802ad2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ad5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad8:	89 c7                	mov    %eax,%edi
  802ada:	48 b8 7a 24 80 00 00 	movabs $0x80247a,%rax
  802ae1:	00 00 00 
  802ae4:	ff d0                	callq  *%rax
	return r;
  802ae6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802ae9:	c9                   	leaveq 
  802aea:	c3                   	retq   

0000000000802aeb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802aeb:	55                   	push   %rbp
  802aec:	48 89 e5             	mov    %rsp,%rbp
  802aef:	48 83 ec 10          	sub    $0x10,%rsp
  802af3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802af6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802afa:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802b01:	00 00 00 
  802b04:	8b 00                	mov    (%rax),%eax
  802b06:	85 c0                	test   %eax,%eax
  802b08:	75 1d                	jne    802b27 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b0a:	bf 01 00 00 00       	mov    $0x1,%edi
  802b0f:	48 b8 ea 3a 80 00 00 	movabs $0x803aea,%rax
  802b16:	00 00 00 
  802b19:	ff d0                	callq  *%rax
  802b1b:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  802b22:	00 00 00 
  802b25:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b27:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802b2e:	00 00 00 
  802b31:	8b 00                	mov    (%rax),%eax
  802b33:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b36:	b9 07 00 00 00       	mov    $0x7,%ecx
  802b3b:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802b42:	00 00 00 
  802b45:	89 c7                	mov    %eax,%edi
  802b47:	48 b8 52 3a 80 00 00 	movabs $0x803a52,%rax
  802b4e:	00 00 00 
  802b51:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b57:	ba 00 00 00 00       	mov    $0x0,%edx
  802b5c:	48 89 c6             	mov    %rax,%rsi
  802b5f:	bf 00 00 00 00       	mov    $0x0,%edi
  802b64:	48 b8 89 39 80 00 00 	movabs $0x803989,%rax
  802b6b:	00 00 00 
  802b6e:	ff d0                	callq  *%rax
}
  802b70:	c9                   	leaveq 
  802b71:	c3                   	retq   

0000000000802b72 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802b72:	55                   	push   %rbp
  802b73:	48 89 e5             	mov    %rsp,%rbp
  802b76:	48 83 ec 20          	sub    $0x20,%rsp
  802b7a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b7e:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802b81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b85:	48 89 c7             	mov    %rax,%rdi
  802b88:	48 b8 79 10 80 00 00 	movabs $0x801079,%rax
  802b8f:	00 00 00 
  802b92:	ff d0                	callq  *%rax
  802b94:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b99:	7e 0a                	jle    802ba5 <open+0x33>
		return -E_BAD_PATH;
  802b9b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ba0:	e9 a5 00 00 00       	jmpq   802c4a <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802ba5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ba9:	48 89 c7             	mov    %rax,%rdi
  802bac:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  802bb3:	00 00 00 
  802bb6:	ff d0                	callq  *%rax
  802bb8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bbf:	79 08                	jns    802bc9 <open+0x57>
		return r;
  802bc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc4:	e9 81 00 00 00       	jmpq   802c4a <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802bc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bcd:	48 89 c6             	mov    %rax,%rsi
  802bd0:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802bd7:	00 00 00 
  802bda:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  802be1:	00 00 00 
  802be4:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802be6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bed:	00 00 00 
  802bf0:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802bf3:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802bf9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bfd:	48 89 c6             	mov    %rax,%rsi
  802c00:	bf 01 00 00 00       	mov    $0x1,%edi
  802c05:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  802c0c:	00 00 00 
  802c0f:	ff d0                	callq  *%rax
  802c11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c18:	79 1d                	jns    802c37 <open+0xc5>
		fd_close(fd, 0);
  802c1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c1e:	be 00 00 00 00       	mov    $0x0,%esi
  802c23:	48 89 c7             	mov    %rax,%rdi
  802c26:	48 b8 fa 22 80 00 00 	movabs $0x8022fa,%rax
  802c2d:	00 00 00 
  802c30:	ff d0                	callq  *%rax
		return r;
  802c32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c35:	eb 13                	jmp    802c4a <open+0xd8>
	}

	return fd2num(fd);
  802c37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c3b:	48 89 c7             	mov    %rax,%rdi
  802c3e:	48 b8 84 21 80 00 00 	movabs $0x802184,%rax
  802c45:	00 00 00 
  802c48:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802c4a:	c9                   	leaveq 
  802c4b:	c3                   	retq   

0000000000802c4c <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802c4c:	55                   	push   %rbp
  802c4d:	48 89 e5             	mov    %rsp,%rbp
  802c50:	48 83 ec 10          	sub    $0x10,%rsp
  802c54:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802c58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c5c:	8b 50 0c             	mov    0xc(%rax),%edx
  802c5f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c66:	00 00 00 
  802c69:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802c6b:	be 00 00 00 00       	mov    $0x0,%esi
  802c70:	bf 06 00 00 00       	mov    $0x6,%edi
  802c75:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  802c7c:	00 00 00 
  802c7f:	ff d0                	callq  *%rax
}
  802c81:	c9                   	leaveq 
  802c82:	c3                   	retq   

0000000000802c83 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802c83:	55                   	push   %rbp
  802c84:	48 89 e5             	mov    %rsp,%rbp
  802c87:	48 83 ec 30          	sub    $0x30,%rsp
  802c8b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c8f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c93:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802c97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9b:	8b 50 0c             	mov    0xc(%rax),%edx
  802c9e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ca5:	00 00 00 
  802ca8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802caa:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802cb1:	00 00 00 
  802cb4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cb8:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802cbc:	be 00 00 00 00       	mov    $0x0,%esi
  802cc1:	bf 03 00 00 00       	mov    $0x3,%edi
  802cc6:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  802ccd:	00 00 00 
  802cd0:	ff d0                	callq  *%rax
  802cd2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cd9:	79 05                	jns    802ce0 <devfile_read+0x5d>
		return r;
  802cdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cde:	eb 26                	jmp    802d06 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802ce0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce3:	48 63 d0             	movslq %eax,%rdx
  802ce6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cea:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802cf1:	00 00 00 
  802cf4:	48 89 c7             	mov    %rax,%rdi
  802cf7:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  802cfe:	00 00 00 
  802d01:	ff d0                	callq  *%rax

	return r;
  802d03:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802d06:	c9                   	leaveq 
  802d07:	c3                   	retq   

0000000000802d08 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802d08:	55                   	push   %rbp
  802d09:	48 89 e5             	mov    %rsp,%rbp
  802d0c:	48 83 ec 30          	sub    $0x30,%rsp
  802d10:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d14:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d18:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802d1c:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802d23:	00 
  802d24:	76 08                	jbe    802d2e <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802d26:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802d2d:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802d2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d32:	8b 50 0c             	mov    0xc(%rax),%edx
  802d35:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d3c:	00 00 00 
  802d3f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802d41:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d48:	00 00 00 
  802d4b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d4f:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  802d53:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d5b:	48 89 c6             	mov    %rax,%rsi
  802d5e:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802d65:	00 00 00 
  802d68:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  802d6f:	00 00 00 
  802d72:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802d74:	be 00 00 00 00       	mov    $0x0,%esi
  802d79:	bf 04 00 00 00       	mov    $0x4,%edi
  802d7e:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  802d85:	00 00 00 
  802d88:	ff d0                	callq  *%rax
  802d8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d91:	79 05                	jns    802d98 <devfile_write+0x90>
		return r;
  802d93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d96:	eb 03                	jmp    802d9b <devfile_write+0x93>

	return r;
  802d98:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802d9b:	c9                   	leaveq 
  802d9c:	c3                   	retq   

0000000000802d9d <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802d9d:	55                   	push   %rbp
  802d9e:	48 89 e5             	mov    %rsp,%rbp
  802da1:	48 83 ec 20          	sub    $0x20,%rsp
  802da5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802da9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802dad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db1:	8b 50 0c             	mov    0xc(%rax),%edx
  802db4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802dbb:	00 00 00 
  802dbe:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802dc0:	be 00 00 00 00       	mov    $0x0,%esi
  802dc5:	bf 05 00 00 00       	mov    $0x5,%edi
  802dca:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  802dd1:	00 00 00 
  802dd4:	ff d0                	callq  *%rax
  802dd6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ddd:	79 05                	jns    802de4 <devfile_stat+0x47>
		return r;
  802ddf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de2:	eb 56                	jmp    802e3a <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802de4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802de8:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802def:	00 00 00 
  802df2:	48 89 c7             	mov    %rax,%rdi
  802df5:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  802dfc:	00 00 00 
  802dff:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802e01:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e08:	00 00 00 
  802e0b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802e11:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e15:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802e1b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e22:	00 00 00 
  802e25:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802e2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e2f:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802e35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e3a:	c9                   	leaveq 
  802e3b:	c3                   	retq   

0000000000802e3c <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802e3c:	55                   	push   %rbp
  802e3d:	48 89 e5             	mov    %rsp,%rbp
  802e40:	48 83 ec 10          	sub    $0x10,%rsp
  802e44:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e48:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802e4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e4f:	8b 50 0c             	mov    0xc(%rax),%edx
  802e52:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e59:	00 00 00 
  802e5c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802e5e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e65:	00 00 00 
  802e68:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e6b:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802e6e:	be 00 00 00 00       	mov    $0x0,%esi
  802e73:	bf 02 00 00 00       	mov    $0x2,%edi
  802e78:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  802e7f:	00 00 00 
  802e82:	ff d0                	callq  *%rax
}
  802e84:	c9                   	leaveq 
  802e85:	c3                   	retq   

0000000000802e86 <remove>:

// Delete a file
int
remove(const char *path)
{
  802e86:	55                   	push   %rbp
  802e87:	48 89 e5             	mov    %rsp,%rbp
  802e8a:	48 83 ec 10          	sub    $0x10,%rsp
  802e8e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802e92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e96:	48 89 c7             	mov    %rax,%rdi
  802e99:	48 b8 79 10 80 00 00 	movabs $0x801079,%rax
  802ea0:	00 00 00 
  802ea3:	ff d0                	callq  *%rax
  802ea5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802eaa:	7e 07                	jle    802eb3 <remove+0x2d>
		return -E_BAD_PATH;
  802eac:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802eb1:	eb 33                	jmp    802ee6 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802eb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eb7:	48 89 c6             	mov    %rax,%rsi
  802eba:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802ec1:	00 00 00 
  802ec4:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  802ecb:	00 00 00 
  802ece:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802ed0:	be 00 00 00 00       	mov    $0x0,%esi
  802ed5:	bf 07 00 00 00       	mov    $0x7,%edi
  802eda:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  802ee1:	00 00 00 
  802ee4:	ff d0                	callq  *%rax
}
  802ee6:	c9                   	leaveq 
  802ee7:	c3                   	retq   

0000000000802ee8 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802ee8:	55                   	push   %rbp
  802ee9:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802eec:	be 00 00 00 00       	mov    $0x0,%esi
  802ef1:	bf 08 00 00 00       	mov    $0x8,%edi
  802ef6:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  802efd:	00 00 00 
  802f00:	ff d0                	callq  *%rax
}
  802f02:	5d                   	pop    %rbp
  802f03:	c3                   	retq   

0000000000802f04 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802f04:	55                   	push   %rbp
  802f05:	48 89 e5             	mov    %rsp,%rbp
  802f08:	53                   	push   %rbx
  802f09:	48 83 ec 38          	sub    $0x38,%rsp
  802f0d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802f11:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802f15:	48 89 c7             	mov    %rax,%rdi
  802f18:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  802f1f:	00 00 00 
  802f22:	ff d0                	callq  *%rax
  802f24:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f27:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f2b:	0f 88 bf 01 00 00    	js     8030f0 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f35:	ba 07 04 00 00       	mov    $0x407,%edx
  802f3a:	48 89 c6             	mov    %rax,%rsi
  802f3d:	bf 00 00 00 00       	mov    $0x0,%edi
  802f42:	48 b8 14 1a 80 00 00 	movabs $0x801a14,%rax
  802f49:	00 00 00 
  802f4c:	ff d0                	callq  *%rax
  802f4e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f51:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f55:	0f 88 95 01 00 00    	js     8030f0 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802f5b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802f5f:	48 89 c7             	mov    %rax,%rdi
  802f62:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  802f69:	00 00 00 
  802f6c:	ff d0                	callq  *%rax
  802f6e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f71:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f75:	0f 88 5d 01 00 00    	js     8030d8 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f7b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f7f:	ba 07 04 00 00       	mov    $0x407,%edx
  802f84:	48 89 c6             	mov    %rax,%rsi
  802f87:	bf 00 00 00 00       	mov    $0x0,%edi
  802f8c:	48 b8 14 1a 80 00 00 	movabs $0x801a14,%rax
  802f93:	00 00 00 
  802f96:	ff d0                	callq  *%rax
  802f98:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f9f:	0f 88 33 01 00 00    	js     8030d8 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802fa5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fa9:	48 89 c7             	mov    %rax,%rdi
  802fac:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  802fb3:	00 00 00 
  802fb6:	ff d0                	callq  *%rax
  802fb8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fbc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fc0:	ba 07 04 00 00       	mov    $0x407,%edx
  802fc5:	48 89 c6             	mov    %rax,%rsi
  802fc8:	bf 00 00 00 00       	mov    $0x0,%edi
  802fcd:	48 b8 14 1a 80 00 00 	movabs $0x801a14,%rax
  802fd4:	00 00 00 
  802fd7:	ff d0                	callq  *%rax
  802fd9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fdc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fe0:	79 05                	jns    802fe7 <pipe+0xe3>
		goto err2;
  802fe2:	e9 d9 00 00 00       	jmpq   8030c0 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fe7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802feb:	48 89 c7             	mov    %rax,%rdi
  802fee:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  802ff5:	00 00 00 
  802ff8:	ff d0                	callq  *%rax
  802ffa:	48 89 c2             	mov    %rax,%rdx
  802ffd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803001:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803007:	48 89 d1             	mov    %rdx,%rcx
  80300a:	ba 00 00 00 00       	mov    $0x0,%edx
  80300f:	48 89 c6             	mov    %rax,%rsi
  803012:	bf 00 00 00 00       	mov    $0x0,%edi
  803017:	48 b8 64 1a 80 00 00 	movabs $0x801a64,%rax
  80301e:	00 00 00 
  803021:	ff d0                	callq  *%rax
  803023:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803026:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80302a:	79 1b                	jns    803047 <pipe+0x143>
		goto err3;
  80302c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  80302d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803031:	48 89 c6             	mov    %rax,%rsi
  803034:	bf 00 00 00 00       	mov    $0x0,%edi
  803039:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  803040:	00 00 00 
  803043:	ff d0                	callq  *%rax
  803045:	eb 79                	jmp    8030c0 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803047:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80304b:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  803052:	00 00 00 
  803055:	8b 12                	mov    (%rdx),%edx
  803057:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803059:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80305d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803064:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803068:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  80306f:	00 00 00 
  803072:	8b 12                	mov    (%rdx),%edx
  803074:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803076:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80307a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803081:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803085:	48 89 c7             	mov    %rax,%rdi
  803088:	48 b8 84 21 80 00 00 	movabs $0x802184,%rax
  80308f:	00 00 00 
  803092:	ff d0                	callq  *%rax
  803094:	89 c2                	mov    %eax,%edx
  803096:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80309a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80309c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030a0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8030a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030a8:	48 89 c7             	mov    %rax,%rdi
  8030ab:	48 b8 84 21 80 00 00 	movabs $0x802184,%rax
  8030b2:	00 00 00 
  8030b5:	ff d0                	callq  *%rax
  8030b7:	89 03                	mov    %eax,(%rbx)
	return 0;
  8030b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030be:	eb 33                	jmp    8030f3 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8030c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030c4:	48 89 c6             	mov    %rax,%rsi
  8030c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8030cc:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  8030d3:	00 00 00 
  8030d6:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8030d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030dc:	48 89 c6             	mov    %rax,%rsi
  8030df:	bf 00 00 00 00       	mov    $0x0,%edi
  8030e4:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  8030eb:	00 00 00 
  8030ee:	ff d0                	callq  *%rax
    err:
	return r;
  8030f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8030f3:	48 83 c4 38          	add    $0x38,%rsp
  8030f7:	5b                   	pop    %rbx
  8030f8:	5d                   	pop    %rbp
  8030f9:	c3                   	retq   

00000000008030fa <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8030fa:	55                   	push   %rbp
  8030fb:	48 89 e5             	mov    %rsp,%rbp
  8030fe:	53                   	push   %rbx
  8030ff:	48 83 ec 28          	sub    $0x28,%rsp
  803103:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803107:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80310b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803112:	00 00 00 
  803115:	48 8b 00             	mov    (%rax),%rax
  803118:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80311e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803121:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803125:	48 89 c7             	mov    %rax,%rdi
  803128:	48 b8 6c 3b 80 00 00 	movabs $0x803b6c,%rax
  80312f:	00 00 00 
  803132:	ff d0                	callq  *%rax
  803134:	89 c3                	mov    %eax,%ebx
  803136:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80313a:	48 89 c7             	mov    %rax,%rdi
  80313d:	48 b8 6c 3b 80 00 00 	movabs $0x803b6c,%rax
  803144:	00 00 00 
  803147:	ff d0                	callq  *%rax
  803149:	39 c3                	cmp    %eax,%ebx
  80314b:	0f 94 c0             	sete   %al
  80314e:	0f b6 c0             	movzbl %al,%eax
  803151:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803154:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80315b:	00 00 00 
  80315e:	48 8b 00             	mov    (%rax),%rax
  803161:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803167:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80316a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80316d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803170:	75 05                	jne    803177 <_pipeisclosed+0x7d>
			return ret;
  803172:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803175:	eb 4f                	jmp    8031c6 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803177:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80317a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80317d:	74 42                	je     8031c1 <_pipeisclosed+0xc7>
  80317f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803183:	75 3c                	jne    8031c1 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803185:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80318c:	00 00 00 
  80318f:	48 8b 00             	mov    (%rax),%rax
  803192:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803198:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80319b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80319e:	89 c6                	mov    %eax,%esi
  8031a0:	48 bf cb 41 80 00 00 	movabs $0x8041cb,%rdi
  8031a7:	00 00 00 
  8031aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8031af:	49 b8 3d 03 80 00 00 	movabs $0x80033d,%r8
  8031b6:	00 00 00 
  8031b9:	41 ff d0             	callq  *%r8
	}
  8031bc:	e9 4a ff ff ff       	jmpq   80310b <_pipeisclosed+0x11>
  8031c1:	e9 45 ff ff ff       	jmpq   80310b <_pipeisclosed+0x11>
}
  8031c6:	48 83 c4 28          	add    $0x28,%rsp
  8031ca:	5b                   	pop    %rbx
  8031cb:	5d                   	pop    %rbp
  8031cc:	c3                   	retq   

00000000008031cd <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8031cd:	55                   	push   %rbp
  8031ce:	48 89 e5             	mov    %rsp,%rbp
  8031d1:	48 83 ec 30          	sub    $0x30,%rsp
  8031d5:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031d8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031dc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031df:	48 89 d6             	mov    %rdx,%rsi
  8031e2:	89 c7                	mov    %eax,%edi
  8031e4:	48 b8 6a 22 80 00 00 	movabs $0x80226a,%rax
  8031eb:	00 00 00 
  8031ee:	ff d0                	callq  *%rax
  8031f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031f7:	79 05                	jns    8031fe <pipeisclosed+0x31>
		return r;
  8031f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031fc:	eb 31                	jmp    80322f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8031fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803202:	48 89 c7             	mov    %rax,%rdi
  803205:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  80320c:	00 00 00 
  80320f:	ff d0                	callq  *%rax
  803211:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803215:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803219:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80321d:	48 89 d6             	mov    %rdx,%rsi
  803220:	48 89 c7             	mov    %rax,%rdi
  803223:	48 b8 fa 30 80 00 00 	movabs $0x8030fa,%rax
  80322a:	00 00 00 
  80322d:	ff d0                	callq  *%rax
}
  80322f:	c9                   	leaveq 
  803230:	c3                   	retq   

0000000000803231 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803231:	55                   	push   %rbp
  803232:	48 89 e5             	mov    %rsp,%rbp
  803235:	48 83 ec 40          	sub    $0x40,%rsp
  803239:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80323d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803241:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803245:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803249:	48 89 c7             	mov    %rax,%rdi
  80324c:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  803253:	00 00 00 
  803256:	ff d0                	callq  *%rax
  803258:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80325c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803260:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803264:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80326b:	00 
  80326c:	e9 92 00 00 00       	jmpq   803303 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803271:	eb 41                	jmp    8032b4 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803273:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803278:	74 09                	je     803283 <devpipe_read+0x52>
				return i;
  80327a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80327e:	e9 92 00 00 00       	jmpq   803315 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803283:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803287:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80328b:	48 89 d6             	mov    %rdx,%rsi
  80328e:	48 89 c7             	mov    %rax,%rdi
  803291:	48 b8 fa 30 80 00 00 	movabs $0x8030fa,%rax
  803298:	00 00 00 
  80329b:	ff d0                	callq  *%rax
  80329d:	85 c0                	test   %eax,%eax
  80329f:	74 07                	je     8032a8 <devpipe_read+0x77>
				return 0;
  8032a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a6:	eb 6d                	jmp    803315 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8032a8:	48 b8 d6 19 80 00 00 	movabs $0x8019d6,%rax
  8032af:	00 00 00 
  8032b2:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8032b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b8:	8b 10                	mov    (%rax),%edx
  8032ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032be:	8b 40 04             	mov    0x4(%rax),%eax
  8032c1:	39 c2                	cmp    %eax,%edx
  8032c3:	74 ae                	je     803273 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8032c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032cd:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8032d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d5:	8b 00                	mov    (%rax),%eax
  8032d7:	99                   	cltd   
  8032d8:	c1 ea 1b             	shr    $0x1b,%edx
  8032db:	01 d0                	add    %edx,%eax
  8032dd:	83 e0 1f             	and    $0x1f,%eax
  8032e0:	29 d0                	sub    %edx,%eax
  8032e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032e6:	48 98                	cltq   
  8032e8:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8032ed:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8032ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f3:	8b 00                	mov    (%rax),%eax
  8032f5:	8d 50 01             	lea    0x1(%rax),%edx
  8032f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032fc:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8032fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803303:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803307:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80330b:	0f 82 60 ff ff ff    	jb     803271 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803311:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803315:	c9                   	leaveq 
  803316:	c3                   	retq   

0000000000803317 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803317:	55                   	push   %rbp
  803318:	48 89 e5             	mov    %rsp,%rbp
  80331b:	48 83 ec 40          	sub    $0x40,%rsp
  80331f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803323:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803327:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80332b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80332f:	48 89 c7             	mov    %rax,%rdi
  803332:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  803339:	00 00 00 
  80333c:	ff d0                	callq  *%rax
  80333e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803342:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803346:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80334a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803351:	00 
  803352:	e9 8e 00 00 00       	jmpq   8033e5 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803357:	eb 31                	jmp    80338a <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803359:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80335d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803361:	48 89 d6             	mov    %rdx,%rsi
  803364:	48 89 c7             	mov    %rax,%rdi
  803367:	48 b8 fa 30 80 00 00 	movabs $0x8030fa,%rax
  80336e:	00 00 00 
  803371:	ff d0                	callq  *%rax
  803373:	85 c0                	test   %eax,%eax
  803375:	74 07                	je     80337e <devpipe_write+0x67>
				return 0;
  803377:	b8 00 00 00 00       	mov    $0x0,%eax
  80337c:	eb 79                	jmp    8033f7 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80337e:	48 b8 d6 19 80 00 00 	movabs $0x8019d6,%rax
  803385:	00 00 00 
  803388:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80338a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80338e:	8b 40 04             	mov    0x4(%rax),%eax
  803391:	48 63 d0             	movslq %eax,%rdx
  803394:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803398:	8b 00                	mov    (%rax),%eax
  80339a:	48 98                	cltq   
  80339c:	48 83 c0 20          	add    $0x20,%rax
  8033a0:	48 39 c2             	cmp    %rax,%rdx
  8033a3:	73 b4                	jae    803359 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8033a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a9:	8b 40 04             	mov    0x4(%rax),%eax
  8033ac:	99                   	cltd   
  8033ad:	c1 ea 1b             	shr    $0x1b,%edx
  8033b0:	01 d0                	add    %edx,%eax
  8033b2:	83 e0 1f             	and    $0x1f,%eax
  8033b5:	29 d0                	sub    %edx,%eax
  8033b7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033bb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8033bf:	48 01 ca             	add    %rcx,%rdx
  8033c2:	0f b6 0a             	movzbl (%rdx),%ecx
  8033c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033c9:	48 98                	cltq   
  8033cb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8033cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033d3:	8b 40 04             	mov    0x4(%rax),%eax
  8033d6:	8d 50 01             	lea    0x1(%rax),%edx
  8033d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033dd:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8033e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8033e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033e9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8033ed:	0f 82 64 ff ff ff    	jb     803357 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8033f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8033f7:	c9                   	leaveq 
  8033f8:	c3                   	retq   

00000000008033f9 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8033f9:	55                   	push   %rbp
  8033fa:	48 89 e5             	mov    %rsp,%rbp
  8033fd:	48 83 ec 20          	sub    $0x20,%rsp
  803401:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803405:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803409:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80340d:	48 89 c7             	mov    %rax,%rdi
  803410:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  803417:	00 00 00 
  80341a:	ff d0                	callq  *%rax
  80341c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803420:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803424:	48 be de 41 80 00 00 	movabs $0x8041de,%rsi
  80342b:	00 00 00 
  80342e:	48 89 c7             	mov    %rax,%rdi
  803431:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  803438:	00 00 00 
  80343b:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80343d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803441:	8b 50 04             	mov    0x4(%rax),%edx
  803444:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803448:	8b 00                	mov    (%rax),%eax
  80344a:	29 c2                	sub    %eax,%edx
  80344c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803450:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803456:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80345a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803461:	00 00 00 
	stat->st_dev = &devpipe;
  803464:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803468:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  80346f:	00 00 00 
  803472:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803479:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80347e:	c9                   	leaveq 
  80347f:	c3                   	retq   

0000000000803480 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803480:	55                   	push   %rbp
  803481:	48 89 e5             	mov    %rsp,%rbp
  803484:	48 83 ec 10          	sub    $0x10,%rsp
  803488:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80348c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803490:	48 89 c6             	mov    %rax,%rsi
  803493:	bf 00 00 00 00       	mov    $0x0,%edi
  803498:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  80349f:	00 00 00 
  8034a2:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8034a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034a8:	48 89 c7             	mov    %rax,%rdi
  8034ab:	48 b8 a7 21 80 00 00 	movabs $0x8021a7,%rax
  8034b2:	00 00 00 
  8034b5:	ff d0                	callq  *%rax
  8034b7:	48 89 c6             	mov    %rax,%rsi
  8034ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8034bf:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  8034c6:	00 00 00 
  8034c9:	ff d0                	callq  *%rax
}
  8034cb:	c9                   	leaveq 
  8034cc:	c3                   	retq   

00000000008034cd <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8034cd:	55                   	push   %rbp
  8034ce:	48 89 e5             	mov    %rsp,%rbp
  8034d1:	48 83 ec 20          	sub    $0x20,%rsp
  8034d5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8034d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034db:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8034de:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8034e2:	be 01 00 00 00       	mov    $0x1,%esi
  8034e7:	48 89 c7             	mov    %rax,%rdi
  8034ea:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  8034f1:	00 00 00 
  8034f4:	ff d0                	callq  *%rax
}
  8034f6:	c9                   	leaveq 
  8034f7:	c3                   	retq   

00000000008034f8 <getchar>:

int
getchar(void)
{
  8034f8:	55                   	push   %rbp
  8034f9:	48 89 e5             	mov    %rsp,%rbp
  8034fc:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803500:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803504:	ba 01 00 00 00       	mov    $0x1,%edx
  803509:	48 89 c6             	mov    %rax,%rsi
  80350c:	bf 00 00 00 00       	mov    $0x0,%edi
  803511:	48 b8 9c 26 80 00 00 	movabs $0x80269c,%rax
  803518:	00 00 00 
  80351b:	ff d0                	callq  *%rax
  80351d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803520:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803524:	79 05                	jns    80352b <getchar+0x33>
		return r;
  803526:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803529:	eb 14                	jmp    80353f <getchar+0x47>
	if (r < 1)
  80352b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80352f:	7f 07                	jg     803538 <getchar+0x40>
		return -E_EOF;
  803531:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803536:	eb 07                	jmp    80353f <getchar+0x47>
	return c;
  803538:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80353c:	0f b6 c0             	movzbl %al,%eax
}
  80353f:	c9                   	leaveq 
  803540:	c3                   	retq   

0000000000803541 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803541:	55                   	push   %rbp
  803542:	48 89 e5             	mov    %rsp,%rbp
  803545:	48 83 ec 20          	sub    $0x20,%rsp
  803549:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80354c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803550:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803553:	48 89 d6             	mov    %rdx,%rsi
  803556:	89 c7                	mov    %eax,%edi
  803558:	48 b8 6a 22 80 00 00 	movabs $0x80226a,%rax
  80355f:	00 00 00 
  803562:	ff d0                	callq  *%rax
  803564:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803567:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80356b:	79 05                	jns    803572 <iscons+0x31>
		return r;
  80356d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803570:	eb 1a                	jmp    80358c <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803572:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803576:	8b 10                	mov    (%rax),%edx
  803578:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  80357f:	00 00 00 
  803582:	8b 00                	mov    (%rax),%eax
  803584:	39 c2                	cmp    %eax,%edx
  803586:	0f 94 c0             	sete   %al
  803589:	0f b6 c0             	movzbl %al,%eax
}
  80358c:	c9                   	leaveq 
  80358d:	c3                   	retq   

000000000080358e <opencons>:

int
opencons(void)
{
  80358e:	55                   	push   %rbp
  80358f:	48 89 e5             	mov    %rsp,%rbp
  803592:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803596:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80359a:	48 89 c7             	mov    %rax,%rdi
  80359d:	48 b8 d2 21 80 00 00 	movabs $0x8021d2,%rax
  8035a4:	00 00 00 
  8035a7:	ff d0                	callq  *%rax
  8035a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035b0:	79 05                	jns    8035b7 <opencons+0x29>
		return r;
  8035b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b5:	eb 5b                	jmp    803612 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8035b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035bb:	ba 07 04 00 00       	mov    $0x407,%edx
  8035c0:	48 89 c6             	mov    %rax,%rsi
  8035c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8035c8:	48 b8 14 1a 80 00 00 	movabs $0x801a14,%rax
  8035cf:	00 00 00 
  8035d2:	ff d0                	callq  *%rax
  8035d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035db:	79 05                	jns    8035e2 <opencons+0x54>
		return r;
  8035dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e0:	eb 30                	jmp    803612 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8035e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e6:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8035ed:	00 00 00 
  8035f0:	8b 12                	mov    (%rdx),%edx
  8035f2:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8035f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8035ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803603:	48 89 c7             	mov    %rax,%rdi
  803606:	48 b8 84 21 80 00 00 	movabs $0x802184,%rax
  80360d:	00 00 00 
  803610:	ff d0                	callq  *%rax
}
  803612:	c9                   	leaveq 
  803613:	c3                   	retq   

0000000000803614 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803614:	55                   	push   %rbp
  803615:	48 89 e5             	mov    %rsp,%rbp
  803618:	48 83 ec 30          	sub    $0x30,%rsp
  80361c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803620:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803624:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803628:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80362d:	75 07                	jne    803636 <devcons_read+0x22>
		return 0;
  80362f:	b8 00 00 00 00       	mov    $0x0,%eax
  803634:	eb 4b                	jmp    803681 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803636:	eb 0c                	jmp    803644 <devcons_read+0x30>
		sys_yield();
  803638:	48 b8 d6 19 80 00 00 	movabs $0x8019d6,%rax
  80363f:	00 00 00 
  803642:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803644:	48 b8 16 19 80 00 00 	movabs $0x801916,%rax
  80364b:	00 00 00 
  80364e:	ff d0                	callq  *%rax
  803650:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803653:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803657:	74 df                	je     803638 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803659:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80365d:	79 05                	jns    803664 <devcons_read+0x50>
		return c;
  80365f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803662:	eb 1d                	jmp    803681 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803664:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803668:	75 07                	jne    803671 <devcons_read+0x5d>
		return 0;
  80366a:	b8 00 00 00 00       	mov    $0x0,%eax
  80366f:	eb 10                	jmp    803681 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803671:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803674:	89 c2                	mov    %eax,%edx
  803676:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80367a:	88 10                	mov    %dl,(%rax)
	return 1;
  80367c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803681:	c9                   	leaveq 
  803682:	c3                   	retq   

0000000000803683 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803683:	55                   	push   %rbp
  803684:	48 89 e5             	mov    %rsp,%rbp
  803687:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80368e:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803695:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80369c:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8036a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8036aa:	eb 76                	jmp    803722 <devcons_write+0x9f>
		m = n - tot;
  8036ac:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8036b3:	89 c2                	mov    %eax,%edx
  8036b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b8:	29 c2                	sub    %eax,%edx
  8036ba:	89 d0                	mov    %edx,%eax
  8036bc:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8036bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036c2:	83 f8 7f             	cmp    $0x7f,%eax
  8036c5:	76 07                	jbe    8036ce <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8036c7:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8036ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036d1:	48 63 d0             	movslq %eax,%rdx
  8036d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d7:	48 63 c8             	movslq %eax,%rcx
  8036da:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8036e1:	48 01 c1             	add    %rax,%rcx
  8036e4:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8036eb:	48 89 ce             	mov    %rcx,%rsi
  8036ee:	48 89 c7             	mov    %rax,%rdi
  8036f1:	48 b8 09 14 80 00 00 	movabs $0x801409,%rax
  8036f8:	00 00 00 
  8036fb:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8036fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803700:	48 63 d0             	movslq %eax,%rdx
  803703:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80370a:	48 89 d6             	mov    %rdx,%rsi
  80370d:	48 89 c7             	mov    %rax,%rdi
  803710:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  803717:	00 00 00 
  80371a:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80371c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80371f:	01 45 fc             	add    %eax,-0x4(%rbp)
  803722:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803725:	48 98                	cltq   
  803727:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80372e:	0f 82 78 ff ff ff    	jb     8036ac <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803734:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803737:	c9                   	leaveq 
  803738:	c3                   	retq   

0000000000803739 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803739:	55                   	push   %rbp
  80373a:	48 89 e5             	mov    %rsp,%rbp
  80373d:	48 83 ec 08          	sub    $0x8,%rsp
  803741:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803745:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80374a:	c9                   	leaveq 
  80374b:	c3                   	retq   

000000000080374c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80374c:	55                   	push   %rbp
  80374d:	48 89 e5             	mov    %rsp,%rbp
  803750:	48 83 ec 10          	sub    $0x10,%rsp
  803754:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803758:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80375c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803760:	48 be ea 41 80 00 00 	movabs $0x8041ea,%rsi
  803767:	00 00 00 
  80376a:	48 89 c7             	mov    %rax,%rdi
  80376d:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  803774:	00 00 00 
  803777:	ff d0                	callq  *%rax
	return 0;
  803779:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80377e:	c9                   	leaveq 
  80377f:	c3                   	retq   

0000000000803780 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803780:	55                   	push   %rbp
  803781:	48 89 e5             	mov    %rsp,%rbp
  803784:	53                   	push   %rbx
  803785:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80378c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803793:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803799:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8037a0:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8037a7:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8037ae:	84 c0                	test   %al,%al
  8037b0:	74 23                	je     8037d5 <_panic+0x55>
  8037b2:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8037b9:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8037bd:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8037c1:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8037c5:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8037c9:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8037cd:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8037d1:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8037d5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8037dc:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8037e3:	00 00 00 
  8037e6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8037ed:	00 00 00 
  8037f0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8037f4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8037fb:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803802:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803809:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  803810:	00 00 00 
  803813:	48 8b 18             	mov    (%rax),%rbx
  803816:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  80381d:	00 00 00 
  803820:	ff d0                	callq  *%rax
  803822:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803828:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80382f:	41 89 c8             	mov    %ecx,%r8d
  803832:	48 89 d1             	mov    %rdx,%rcx
  803835:	48 89 da             	mov    %rbx,%rdx
  803838:	89 c6                	mov    %eax,%esi
  80383a:	48 bf f8 41 80 00 00 	movabs $0x8041f8,%rdi
  803841:	00 00 00 
  803844:	b8 00 00 00 00       	mov    $0x0,%eax
  803849:	49 b9 3d 03 80 00 00 	movabs $0x80033d,%r9
  803850:	00 00 00 
  803853:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803856:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80385d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803864:	48 89 d6             	mov    %rdx,%rsi
  803867:	48 89 c7             	mov    %rax,%rdi
  80386a:	48 b8 91 02 80 00 00 	movabs $0x800291,%rax
  803871:	00 00 00 
  803874:	ff d0                	callq  *%rax
	cprintf("\n");
  803876:	48 bf 1b 42 80 00 00 	movabs $0x80421b,%rdi
  80387d:	00 00 00 
  803880:	b8 00 00 00 00       	mov    $0x0,%eax
  803885:	48 ba 3d 03 80 00 00 	movabs $0x80033d,%rdx
  80388c:	00 00 00 
  80388f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803891:	cc                   	int3   
  803892:	eb fd                	jmp    803891 <_panic+0x111>

0000000000803894 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803894:	55                   	push   %rbp
  803895:	48 89 e5             	mov    %rsp,%rbp
  803898:	48 83 ec 10          	sub    $0x10,%rsp
  80389c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8038a0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8038a7:	00 00 00 
  8038aa:	48 8b 00             	mov    (%rax),%rax
  8038ad:	48 85 c0             	test   %rax,%rax
  8038b0:	75 3a                	jne    8038ec <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  8038b2:	ba 07 00 00 00       	mov    $0x7,%edx
  8038b7:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8038bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8038c1:	48 b8 14 1a 80 00 00 	movabs $0x801a14,%rax
  8038c8:	00 00 00 
  8038cb:	ff d0                	callq  *%rax
  8038cd:	85 c0                	test   %eax,%eax
  8038cf:	75 1b                	jne    8038ec <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8038d1:	48 be ff 38 80 00 00 	movabs $0x8038ff,%rsi
  8038d8:	00 00 00 
  8038db:	bf 00 00 00 00       	mov    $0x0,%edi
  8038e0:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  8038e7:	00 00 00 
  8038ea:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8038ec:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8038f3:	00 00 00 
  8038f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038fa:	48 89 10             	mov    %rdx,(%rax)
}
  8038fd:	c9                   	leaveq 
  8038fe:	c3                   	retq   

00000000008038ff <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  8038ff:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803902:	48 a1 08 80 80 00 00 	movabs 0x808008,%rax
  803909:	00 00 00 
	call *%rax
  80390c:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  80390e:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  803911:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803918:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  803919:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  803920:	00 
	pushq %rbx		// push utf_rip into new stack
  803921:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  803922:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  803929:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  80392c:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  803930:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  803934:	4c 8b 3c 24          	mov    (%rsp),%r15
  803938:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80393d:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803942:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803947:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80394c:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803951:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803956:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80395b:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803960:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803965:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80396a:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80396f:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803974:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803979:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80397e:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  803982:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  803986:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  803987:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803988:	c3                   	retq   

0000000000803989 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803989:	55                   	push   %rbp
  80398a:	48 89 e5             	mov    %rsp,%rbp
  80398d:	48 83 ec 30          	sub    $0x30,%rsp
  803991:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803995:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803999:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  80399d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8039a5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8039aa:	75 0e                	jne    8039ba <ipc_recv+0x31>
		page = (void *)KERNBASE;
  8039ac:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8039b3:	00 00 00 
  8039b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  8039ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039be:	48 89 c7             	mov    %rax,%rdi
  8039c1:	48 b8 3d 1c 80 00 00 	movabs $0x801c3d,%rax
  8039c8:	00 00 00 
  8039cb:	ff d0                	callq  *%rax
  8039cd:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8039d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8039d4:	79 27                	jns    8039fd <ipc_recv+0x74>
		if (from_env_store != NULL)
  8039d6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8039db:	74 0a                	je     8039e7 <ipc_recv+0x5e>
			*from_env_store = 0;
  8039dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039e1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  8039e7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039ec:	74 0a                	je     8039f8 <ipc_recv+0x6f>
			*perm_store = 0;
  8039ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039f2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8039f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039fb:	eb 53                	jmp    803a50 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  8039fd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803a02:	74 19                	je     803a1d <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  803a04:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803a0b:	00 00 00 
  803a0e:	48 8b 00             	mov    (%rax),%rax
  803a11:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803a17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a1b:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  803a1d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a22:	74 19                	je     803a3d <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803a24:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803a2b:	00 00 00 
  803a2e:	48 8b 00             	mov    (%rax),%rax
  803a31:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803a37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a3b:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  803a3d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803a44:	00 00 00 
  803a47:	48 8b 00             	mov    (%rax),%rax
  803a4a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803a50:	c9                   	leaveq 
  803a51:	c3                   	retq   

0000000000803a52 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a52:	55                   	push   %rbp
  803a53:	48 89 e5             	mov    %rsp,%rbp
  803a56:	48 83 ec 30          	sub    $0x30,%rsp
  803a5a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a5d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a60:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803a64:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803a67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803a6f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803a74:	75 10                	jne    803a86 <ipc_send+0x34>
		page = (void *)KERNBASE;
  803a76:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803a7d:	00 00 00 
  803a80:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803a84:	eb 0e                	jmp    803a94 <ipc_send+0x42>
  803a86:	eb 0c                	jmp    803a94 <ipc_send+0x42>
		sys_yield();
  803a88:	48 b8 d6 19 80 00 00 	movabs $0x8019d6,%rax
  803a8f:	00 00 00 
  803a92:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803a94:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803a97:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803a9a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a9e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aa1:	89 c7                	mov    %eax,%edi
  803aa3:	48 b8 e8 1b 80 00 00 	movabs $0x801be8,%rax
  803aaa:	00 00 00 
  803aad:	ff d0                	callq  *%rax
  803aaf:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803ab2:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  803ab6:	74 d0                	je     803a88 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  803ab8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803abc:	74 2a                	je     803ae8 <ipc_send+0x96>
		panic("error on ipc send procedure");
  803abe:	48 ba 1d 42 80 00 00 	movabs $0x80421d,%rdx
  803ac5:	00 00 00 
  803ac8:	be 49 00 00 00       	mov    $0x49,%esi
  803acd:	48 bf 39 42 80 00 00 	movabs $0x804239,%rdi
  803ad4:	00 00 00 
  803ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  803adc:	48 b9 80 37 80 00 00 	movabs $0x803780,%rcx
  803ae3:	00 00 00 
  803ae6:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  803ae8:	c9                   	leaveq 
  803ae9:	c3                   	retq   

0000000000803aea <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803aea:	55                   	push   %rbp
  803aeb:	48 89 e5             	mov    %rsp,%rbp
  803aee:	48 83 ec 14          	sub    $0x14,%rsp
  803af2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803af5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803afc:	eb 5e                	jmp    803b5c <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803afe:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b05:	00 00 00 
  803b08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b0b:	48 63 d0             	movslq %eax,%rdx
  803b0e:	48 89 d0             	mov    %rdx,%rax
  803b11:	48 c1 e0 03          	shl    $0x3,%rax
  803b15:	48 01 d0             	add    %rdx,%rax
  803b18:	48 c1 e0 05          	shl    $0x5,%rax
  803b1c:	48 01 c8             	add    %rcx,%rax
  803b1f:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803b25:	8b 00                	mov    (%rax),%eax
  803b27:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b2a:	75 2c                	jne    803b58 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803b2c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b33:	00 00 00 
  803b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b39:	48 63 d0             	movslq %eax,%rdx
  803b3c:	48 89 d0             	mov    %rdx,%rax
  803b3f:	48 c1 e0 03          	shl    $0x3,%rax
  803b43:	48 01 d0             	add    %rdx,%rax
  803b46:	48 c1 e0 05          	shl    $0x5,%rax
  803b4a:	48 01 c8             	add    %rcx,%rax
  803b4d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803b53:	8b 40 08             	mov    0x8(%rax),%eax
  803b56:	eb 12                	jmp    803b6a <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803b58:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803b5c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803b63:	7e 99                	jle    803afe <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803b65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b6a:	c9                   	leaveq 
  803b6b:	c3                   	retq   

0000000000803b6c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803b6c:	55                   	push   %rbp
  803b6d:	48 89 e5             	mov    %rsp,%rbp
  803b70:	48 83 ec 18          	sub    $0x18,%rsp
  803b74:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803b78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b7c:	48 c1 e8 15          	shr    $0x15,%rax
  803b80:	48 89 c2             	mov    %rax,%rdx
  803b83:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803b8a:	01 00 00 
  803b8d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b91:	83 e0 01             	and    $0x1,%eax
  803b94:	48 85 c0             	test   %rax,%rax
  803b97:	75 07                	jne    803ba0 <pageref+0x34>
		return 0;
  803b99:	b8 00 00 00 00       	mov    $0x0,%eax
  803b9e:	eb 53                	jmp    803bf3 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803ba0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ba4:	48 c1 e8 0c          	shr    $0xc,%rax
  803ba8:	48 89 c2             	mov    %rax,%rdx
  803bab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803bb2:	01 00 00 
  803bb5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bb9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803bbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bc1:	83 e0 01             	and    $0x1,%eax
  803bc4:	48 85 c0             	test   %rax,%rax
  803bc7:	75 07                	jne    803bd0 <pageref+0x64>
		return 0;
  803bc9:	b8 00 00 00 00       	mov    $0x0,%eax
  803bce:	eb 23                	jmp    803bf3 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803bd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bd4:	48 c1 e8 0c          	shr    $0xc,%rax
  803bd8:	48 89 c2             	mov    %rax,%rdx
  803bdb:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803be2:	00 00 00 
  803be5:	48 c1 e2 04          	shl    $0x4,%rdx
  803be9:	48 01 d0             	add    %rdx,%rax
  803bec:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803bf0:	0f b7 c0             	movzwl %ax,%eax
}
  803bf3:	c9                   	leaveq 
  803bf4:	c3                   	retq   
