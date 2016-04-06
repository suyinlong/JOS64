
obj/user/spawnhello.debug:     file format elf64-x86-64


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
  80003c:	e8 a6 00 00 00       	callq  8000e7 <libmain>
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
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800052:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800065:	89 c6                	mov    %eax,%esi
  800067:	48 bf 80 41 80 00 00 	movabs $0x804180,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba d3 03 80 00 00 	movabs $0x8003d3,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	if ((r = spawnl("/bin/hello", "hello", 0)) < 0)
  800082:	ba 00 00 00 00       	mov    $0x0,%edx
  800087:	48 be 9e 41 80 00 00 	movabs $0x80419e,%rsi
  80008e:	00 00 00 
  800091:	48 bf a4 41 80 00 00 	movabs $0x8041a4,%rdi
  800098:	00 00 00 
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a0:	48 b9 f2 2d 80 00 00 	movabs $0x802df2,%rcx
  8000a7:	00 00 00 
  8000aa:	ff d1                	callq  *%rcx
  8000ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b3:	79 30                	jns    8000e5 <umain+0xa2>
		panic("spawn(hello) failed: %e", r);
  8000b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b8:	89 c1                	mov    %eax,%ecx
  8000ba:	48 ba af 41 80 00 00 	movabs $0x8041af,%rdx
  8000c1:	00 00 00 
  8000c4:	be 09 00 00 00       	mov    $0x9,%esi
  8000c9:	48 bf c7 41 80 00 00 	movabs $0x8041c7,%rdi
  8000d0:	00 00 00 
  8000d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d8:	49 b8 9a 01 80 00 00 	movabs $0x80019a,%r8
  8000df:	00 00 00 
  8000e2:	41 ff d0             	callq  *%r8
}
  8000e5:	c9                   	leaveq 
  8000e6:	c3                   	retq   

00000000008000e7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e7:	55                   	push   %rbp
  8000e8:	48 89 e5             	mov    %rsp,%rbp
  8000eb:	48 83 ec 10          	sub    $0x10,%rsp
  8000ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8000f6:	48 b8 2e 1a 80 00 00 	movabs $0x801a2e,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	callq  *%rax
  800102:	48 98                	cltq   
  800104:	25 ff 03 00 00       	and    $0x3ff,%eax
  800109:	48 89 c2             	mov    %rax,%rdx
  80010c:	48 89 d0             	mov    %rdx,%rax
  80010f:	48 c1 e0 03          	shl    $0x3,%rax
  800113:	48 01 d0             	add    %rdx,%rax
  800116:	48 c1 e0 05          	shl    $0x5,%rax
  80011a:	48 89 c2             	mov    %rax,%rdx
  80011d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800124:	00 00 00 
  800127:	48 01 c2             	add    %rax,%rdx
  80012a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800131:	00 00 00 
  800134:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800137:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80013b:	7e 14                	jle    800151 <libmain+0x6a>
		binaryname = argv[0];
  80013d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800141:	48 8b 10             	mov    (%rax),%rdx
  800144:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80014b:	00 00 00 
  80014e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800151:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800155:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800158:	48 89 d6             	mov    %rdx,%rsi
  80015b:	89 c7                	mov    %eax,%edi
  80015d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800164:	00 00 00 
  800167:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800169:	48 b8 77 01 80 00 00 	movabs $0x800177,%rax
  800170:	00 00 00 
  800173:	ff d0                	callq  *%rax
}
  800175:	c9                   	leaveq 
  800176:	c3                   	retq   

0000000000800177 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800177:	55                   	push   %rbp
  800178:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80017b:	48 b8 58 20 80 00 00 	movabs $0x802058,%rax
  800182:	00 00 00 
  800185:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800187:	bf 00 00 00 00       	mov    $0x0,%edi
  80018c:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  800193:	00 00 00 
  800196:	ff d0                	callq  *%rax
}
  800198:	5d                   	pop    %rbp
  800199:	c3                   	retq   

000000000080019a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80019a:	55                   	push   %rbp
  80019b:	48 89 e5             	mov    %rsp,%rbp
  80019e:	53                   	push   %rbx
  80019f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8001a6:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8001ad:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8001b3:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8001ba:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8001c1:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8001c8:	84 c0                	test   %al,%al
  8001ca:	74 23                	je     8001ef <_panic+0x55>
  8001cc:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8001d3:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8001d7:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8001db:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8001df:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8001e3:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8001e7:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8001eb:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8001ef:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8001f6:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8001fd:	00 00 00 
  800200:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800207:	00 00 00 
  80020a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80020e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800215:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80021c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800223:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80022a:	00 00 00 
  80022d:	48 8b 18             	mov    (%rax),%rbx
  800230:	48 b8 2e 1a 80 00 00 	movabs $0x801a2e,%rax
  800237:	00 00 00 
  80023a:	ff d0                	callq  *%rax
  80023c:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800242:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800249:	41 89 c8             	mov    %ecx,%r8d
  80024c:	48 89 d1             	mov    %rdx,%rcx
  80024f:	48 89 da             	mov    %rbx,%rdx
  800252:	89 c6                	mov    %eax,%esi
  800254:	48 bf e8 41 80 00 00 	movabs $0x8041e8,%rdi
  80025b:	00 00 00 
  80025e:	b8 00 00 00 00       	mov    $0x0,%eax
  800263:	49 b9 d3 03 80 00 00 	movabs $0x8003d3,%r9
  80026a:	00 00 00 
  80026d:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800270:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800277:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80027e:	48 89 d6             	mov    %rdx,%rsi
  800281:	48 89 c7             	mov    %rax,%rdi
  800284:	48 b8 27 03 80 00 00 	movabs $0x800327,%rax
  80028b:	00 00 00 
  80028e:	ff d0                	callq  *%rax
	cprintf("\n");
  800290:	48 bf 0b 42 80 00 00 	movabs $0x80420b,%rdi
  800297:	00 00 00 
  80029a:	b8 00 00 00 00       	mov    $0x0,%eax
  80029f:	48 ba d3 03 80 00 00 	movabs $0x8003d3,%rdx
  8002a6:	00 00 00 
  8002a9:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002ab:	cc                   	int3   
  8002ac:	eb fd                	jmp    8002ab <_panic+0x111>

00000000008002ae <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002ae:	55                   	push   %rbp
  8002af:	48 89 e5             	mov    %rsp,%rbp
  8002b2:	48 83 ec 10          	sub    $0x10,%rsp
  8002b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8002bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002c1:	8b 00                	mov    (%rax),%eax
  8002c3:	8d 48 01             	lea    0x1(%rax),%ecx
  8002c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002ca:	89 0a                	mov    %ecx,(%rdx)
  8002cc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002cf:	89 d1                	mov    %edx,%ecx
  8002d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002d5:	48 98                	cltq   
  8002d7:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8002db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002df:	8b 00                	mov    (%rax),%eax
  8002e1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002e6:	75 2c                	jne    800314 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8002e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ec:	8b 00                	mov    (%rax),%eax
  8002ee:	48 98                	cltq   
  8002f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002f4:	48 83 c2 08          	add    $0x8,%rdx
  8002f8:	48 89 c6             	mov    %rax,%rsi
  8002fb:	48 89 d7             	mov    %rdx,%rdi
  8002fe:	48 b8 62 19 80 00 00 	movabs $0x801962,%rax
  800305:	00 00 00 
  800308:	ff d0                	callq  *%rax
		b->idx = 0;
  80030a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80030e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800314:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800318:	8b 40 04             	mov    0x4(%rax),%eax
  80031b:	8d 50 01             	lea    0x1(%rax),%edx
  80031e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800322:	89 50 04             	mov    %edx,0x4(%rax)
}
  800325:	c9                   	leaveq 
  800326:	c3                   	retq   

0000000000800327 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800327:	55                   	push   %rbp
  800328:	48 89 e5             	mov    %rsp,%rbp
  80032b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800332:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800339:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800340:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800347:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80034e:	48 8b 0a             	mov    (%rdx),%rcx
  800351:	48 89 08             	mov    %rcx,(%rax)
  800354:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800358:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80035c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800360:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800364:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80036b:	00 00 00 
	b.cnt = 0;
  80036e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800375:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800378:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80037f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800386:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80038d:	48 89 c6             	mov    %rax,%rsi
  800390:	48 bf ae 02 80 00 00 	movabs $0x8002ae,%rdi
  800397:	00 00 00 
  80039a:	48 b8 86 07 80 00 00 	movabs $0x800786,%rax
  8003a1:	00 00 00 
  8003a4:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8003a6:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8003ac:	48 98                	cltq   
  8003ae:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003b5:	48 83 c2 08          	add    $0x8,%rdx
  8003b9:	48 89 c6             	mov    %rax,%rsi
  8003bc:	48 89 d7             	mov    %rdx,%rdi
  8003bf:	48 b8 62 19 80 00 00 	movabs $0x801962,%rax
  8003c6:	00 00 00 
  8003c9:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8003cb:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003d1:	c9                   	leaveq 
  8003d2:	c3                   	retq   

00000000008003d3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003d3:	55                   	push   %rbp
  8003d4:	48 89 e5             	mov    %rsp,%rbp
  8003d7:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003de:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003e5:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003ec:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003f3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003fa:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800401:	84 c0                	test   %al,%al
  800403:	74 20                	je     800425 <cprintf+0x52>
  800405:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800409:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80040d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800411:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800415:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800419:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80041d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800421:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800425:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80042c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800433:	00 00 00 
  800436:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80043d:	00 00 00 
  800440:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800444:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80044b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800452:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800459:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800460:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800467:	48 8b 0a             	mov    (%rdx),%rcx
  80046a:	48 89 08             	mov    %rcx,(%rax)
  80046d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800471:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800475:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800479:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80047d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800484:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80048b:	48 89 d6             	mov    %rdx,%rsi
  80048e:	48 89 c7             	mov    %rax,%rdi
  800491:	48 b8 27 03 80 00 00 	movabs $0x800327,%rax
  800498:	00 00 00 
  80049b:	ff d0                	callq  *%rax
  80049d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8004a3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004a9:	c9                   	leaveq 
  8004aa:	c3                   	retq   

00000000008004ab <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004ab:	55                   	push   %rbp
  8004ac:	48 89 e5             	mov    %rsp,%rbp
  8004af:	53                   	push   %rbx
  8004b0:	48 83 ec 38          	sub    $0x38,%rsp
  8004b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004bc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004c0:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8004c3:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8004c7:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004cb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004ce:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004d2:	77 3b                	ja     80050f <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d4:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8004d7:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004db:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e7:	48 f7 f3             	div    %rbx
  8004ea:	48 89 c2             	mov    %rax,%rdx
  8004ed:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004f0:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004f3:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fb:	41 89 f9             	mov    %edi,%r9d
  8004fe:	48 89 c7             	mov    %rax,%rdi
  800501:	48 b8 ab 04 80 00 00 	movabs $0x8004ab,%rax
  800508:	00 00 00 
  80050b:	ff d0                	callq  *%rax
  80050d:	eb 1e                	jmp    80052d <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80050f:	eb 12                	jmp    800523 <printnum+0x78>
			putch(padc, putdat);
  800511:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800515:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051c:	48 89 ce             	mov    %rcx,%rsi
  80051f:	89 d7                	mov    %edx,%edi
  800521:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800523:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800527:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80052b:	7f e4                	jg     800511 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80052d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800530:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800534:	ba 00 00 00 00       	mov    $0x0,%edx
  800539:	48 f7 f1             	div    %rcx
  80053c:	48 89 d0             	mov    %rdx,%rax
  80053f:	48 ba e8 43 80 00 00 	movabs $0x8043e8,%rdx
  800546:	00 00 00 
  800549:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80054d:	0f be d0             	movsbl %al,%edx
  800550:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800554:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800558:	48 89 ce             	mov    %rcx,%rsi
  80055b:	89 d7                	mov    %edx,%edi
  80055d:	ff d0                	callq  *%rax
}
  80055f:	48 83 c4 38          	add    $0x38,%rsp
  800563:	5b                   	pop    %rbx
  800564:	5d                   	pop    %rbp
  800565:	c3                   	retq   

0000000000800566 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800566:	55                   	push   %rbp
  800567:	48 89 e5             	mov    %rsp,%rbp
  80056a:	48 83 ec 1c          	sub    $0x1c,%rsp
  80056e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800572:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800575:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800579:	7e 52                	jle    8005cd <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80057b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057f:	8b 00                	mov    (%rax),%eax
  800581:	83 f8 30             	cmp    $0x30,%eax
  800584:	73 24                	jae    8005aa <getuint+0x44>
  800586:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80058e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800592:	8b 00                	mov    (%rax),%eax
  800594:	89 c0                	mov    %eax,%eax
  800596:	48 01 d0             	add    %rdx,%rax
  800599:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059d:	8b 12                	mov    (%rdx),%edx
  80059f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a6:	89 0a                	mov    %ecx,(%rdx)
  8005a8:	eb 17                	jmp    8005c1 <getuint+0x5b>
  8005aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ae:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005b2:	48 89 d0             	mov    %rdx,%rax
  8005b5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005bd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005c1:	48 8b 00             	mov    (%rax),%rax
  8005c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005c8:	e9 a3 00 00 00       	jmpq   800670 <getuint+0x10a>
	else if (lflag)
  8005cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005d1:	74 4f                	je     800622 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d7:	8b 00                	mov    (%rax),%eax
  8005d9:	83 f8 30             	cmp    $0x30,%eax
  8005dc:	73 24                	jae    800602 <getuint+0x9c>
  8005de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ea:	8b 00                	mov    (%rax),%eax
  8005ec:	89 c0                	mov    %eax,%eax
  8005ee:	48 01 d0             	add    %rdx,%rax
  8005f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f5:	8b 12                	mov    (%rdx),%edx
  8005f7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fe:	89 0a                	mov    %ecx,(%rdx)
  800600:	eb 17                	jmp    800619 <getuint+0xb3>
  800602:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800606:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80060a:	48 89 d0             	mov    %rdx,%rax
  80060d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800611:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800615:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800619:	48 8b 00             	mov    (%rax),%rax
  80061c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800620:	eb 4e                	jmp    800670 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800626:	8b 00                	mov    (%rax),%eax
  800628:	83 f8 30             	cmp    $0x30,%eax
  80062b:	73 24                	jae    800651 <getuint+0xeb>
  80062d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800631:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800639:	8b 00                	mov    (%rax),%eax
  80063b:	89 c0                	mov    %eax,%eax
  80063d:	48 01 d0             	add    %rdx,%rax
  800640:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800644:	8b 12                	mov    (%rdx),%edx
  800646:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800649:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80064d:	89 0a                	mov    %ecx,(%rdx)
  80064f:	eb 17                	jmp    800668 <getuint+0x102>
  800651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800655:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800659:	48 89 d0             	mov    %rdx,%rax
  80065c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800660:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800664:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800668:	8b 00                	mov    (%rax),%eax
  80066a:	89 c0                	mov    %eax,%eax
  80066c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800670:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800674:	c9                   	leaveq 
  800675:	c3                   	retq   

0000000000800676 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800676:	55                   	push   %rbp
  800677:	48 89 e5             	mov    %rsp,%rbp
  80067a:	48 83 ec 1c          	sub    $0x1c,%rsp
  80067e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800682:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800685:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800689:	7e 52                	jle    8006dd <getint+0x67>
		x=va_arg(*ap, long long);
  80068b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068f:	8b 00                	mov    (%rax),%eax
  800691:	83 f8 30             	cmp    $0x30,%eax
  800694:	73 24                	jae    8006ba <getint+0x44>
  800696:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80069e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a2:	8b 00                	mov    (%rax),%eax
  8006a4:	89 c0                	mov    %eax,%eax
  8006a6:	48 01 d0             	add    %rdx,%rax
  8006a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ad:	8b 12                	mov    (%rdx),%edx
  8006af:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b6:	89 0a                	mov    %ecx,(%rdx)
  8006b8:	eb 17                	jmp    8006d1 <getint+0x5b>
  8006ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006be:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006c2:	48 89 d0             	mov    %rdx,%rax
  8006c5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006cd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006d1:	48 8b 00             	mov    (%rax),%rax
  8006d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d8:	e9 a3 00 00 00       	jmpq   800780 <getint+0x10a>
	else if (lflag)
  8006dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006e1:	74 4f                	je     800732 <getint+0xbc>
		x=va_arg(*ap, long);
  8006e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e7:	8b 00                	mov    (%rax),%eax
  8006e9:	83 f8 30             	cmp    $0x30,%eax
  8006ec:	73 24                	jae    800712 <getint+0x9c>
  8006ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fa:	8b 00                	mov    (%rax),%eax
  8006fc:	89 c0                	mov    %eax,%eax
  8006fe:	48 01 d0             	add    %rdx,%rax
  800701:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800705:	8b 12                	mov    (%rdx),%edx
  800707:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80070a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070e:	89 0a                	mov    %ecx,(%rdx)
  800710:	eb 17                	jmp    800729 <getint+0xb3>
  800712:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800716:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80071a:	48 89 d0             	mov    %rdx,%rax
  80071d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800721:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800725:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800729:	48 8b 00             	mov    (%rax),%rax
  80072c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800730:	eb 4e                	jmp    800780 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800732:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800736:	8b 00                	mov    (%rax),%eax
  800738:	83 f8 30             	cmp    $0x30,%eax
  80073b:	73 24                	jae    800761 <getint+0xeb>
  80073d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800741:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800749:	8b 00                	mov    (%rax),%eax
  80074b:	89 c0                	mov    %eax,%eax
  80074d:	48 01 d0             	add    %rdx,%rax
  800750:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800754:	8b 12                	mov    (%rdx),%edx
  800756:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800759:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075d:	89 0a                	mov    %ecx,(%rdx)
  80075f:	eb 17                	jmp    800778 <getint+0x102>
  800761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800765:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800769:	48 89 d0             	mov    %rdx,%rax
  80076c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800770:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800774:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800778:	8b 00                	mov    (%rax),%eax
  80077a:	48 98                	cltq   
  80077c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800780:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800784:	c9                   	leaveq 
  800785:	c3                   	retq   

0000000000800786 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800786:	55                   	push   %rbp
  800787:	48 89 e5             	mov    %rsp,%rbp
  80078a:	41 54                	push   %r12
  80078c:	53                   	push   %rbx
  80078d:	48 83 ec 60          	sub    $0x60,%rsp
  800791:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800795:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800799:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80079d:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8007a1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8007a5:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8007a9:	48 8b 0a             	mov    (%rdx),%rcx
  8007ac:	48 89 08             	mov    %rcx,(%rax)
  8007af:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007b3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007b7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007bb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  8007bf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007c3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007c7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007cb:	0f b6 00             	movzbl (%rax),%eax
  8007ce:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  8007d1:	eb 29                	jmp    8007fc <vprintfmt+0x76>
			if (ch == '\0')
  8007d3:	85 db                	test   %ebx,%ebx
  8007d5:	0f 84 ad 06 00 00    	je     800e88 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  8007db:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007df:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007e3:	48 89 d6             	mov    %rdx,%rsi
  8007e6:	89 df                	mov    %ebx,%edi
  8007e8:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  8007ea:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007ee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007f2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007f6:	0f b6 00             	movzbl (%rax),%eax
  8007f9:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  8007fc:	83 fb 25             	cmp    $0x25,%ebx
  8007ff:	74 05                	je     800806 <vprintfmt+0x80>
  800801:	83 fb 1b             	cmp    $0x1b,%ebx
  800804:	75 cd                	jne    8007d3 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800806:	83 fb 1b             	cmp    $0x1b,%ebx
  800809:	0f 85 ae 01 00 00    	jne    8009bd <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  80080f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800816:	00 00 00 
  800819:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  80081f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800823:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800827:	48 89 d6             	mov    %rdx,%rsi
  80082a:	89 df                	mov    %ebx,%edi
  80082c:	ff d0                	callq  *%rax
			putch('[', putdat);
  80082e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800832:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800836:	48 89 d6             	mov    %rdx,%rsi
  800839:	bf 5b 00 00 00       	mov    $0x5b,%edi
  80083e:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800840:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800846:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80084b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80084f:	0f b6 00             	movzbl (%rax),%eax
  800852:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800855:	eb 32                	jmp    800889 <vprintfmt+0x103>
					putch(ch, putdat);
  800857:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80085b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80085f:	48 89 d6             	mov    %rdx,%rsi
  800862:	89 df                	mov    %ebx,%edi
  800864:	ff d0                	callq  *%rax
					esc_color *= 10;
  800866:	44 89 e0             	mov    %r12d,%eax
  800869:	c1 e0 02             	shl    $0x2,%eax
  80086c:	44 01 e0             	add    %r12d,%eax
  80086f:	01 c0                	add    %eax,%eax
  800871:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800874:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800877:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  80087a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80087f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800883:	0f b6 00             	movzbl (%rax),%eax
  800886:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800889:	83 fb 3b             	cmp    $0x3b,%ebx
  80088c:	74 05                	je     800893 <vprintfmt+0x10d>
  80088e:	83 fb 6d             	cmp    $0x6d,%ebx
  800891:	75 c4                	jne    800857 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800893:	45 85 e4             	test   %r12d,%r12d
  800896:	75 15                	jne    8008ad <vprintfmt+0x127>
					color_flag = 0x07;
  800898:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80089f:	00 00 00 
  8008a2:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  8008a8:	e9 dc 00 00 00       	jmpq   800989 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  8008ad:	41 83 fc 1d          	cmp    $0x1d,%r12d
  8008b1:	7e 69                	jle    80091c <vprintfmt+0x196>
  8008b3:	41 83 fc 25          	cmp    $0x25,%r12d
  8008b7:	7f 63                	jg     80091c <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  8008b9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8008c0:	00 00 00 
  8008c3:	8b 00                	mov    (%rax),%eax
  8008c5:	25 f8 00 00 00       	and    $0xf8,%eax
  8008ca:	89 c2                	mov    %eax,%edx
  8008cc:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8008d3:	00 00 00 
  8008d6:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  8008d8:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  8008dc:	44 89 e0             	mov    %r12d,%eax
  8008df:	83 e0 04             	and    $0x4,%eax
  8008e2:	c1 f8 02             	sar    $0x2,%eax
  8008e5:	89 c2                	mov    %eax,%edx
  8008e7:	44 89 e0             	mov    %r12d,%eax
  8008ea:	83 e0 02             	and    $0x2,%eax
  8008ed:	09 c2                	or     %eax,%edx
  8008ef:	44 89 e0             	mov    %r12d,%eax
  8008f2:	83 e0 01             	and    $0x1,%eax
  8008f5:	c1 e0 02             	shl    $0x2,%eax
  8008f8:	09 c2                	or     %eax,%edx
  8008fa:	41 89 d4             	mov    %edx,%r12d
  8008fd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800904:	00 00 00 
  800907:	8b 00                	mov    (%rax),%eax
  800909:	44 89 e2             	mov    %r12d,%edx
  80090c:	09 c2                	or     %eax,%edx
  80090e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800915:	00 00 00 
  800918:	89 10                	mov    %edx,(%rax)
  80091a:	eb 6d                	jmp    800989 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  80091c:	41 83 fc 27          	cmp    $0x27,%r12d
  800920:	7e 67                	jle    800989 <vprintfmt+0x203>
  800922:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800926:	7f 61                	jg     800989 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800928:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80092f:	00 00 00 
  800932:	8b 00                	mov    (%rax),%eax
  800934:	25 8f 00 00 00       	and    $0x8f,%eax
  800939:	89 c2                	mov    %eax,%edx
  80093b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800942:	00 00 00 
  800945:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800947:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  80094b:	44 89 e0             	mov    %r12d,%eax
  80094e:	83 e0 04             	and    $0x4,%eax
  800951:	c1 f8 02             	sar    $0x2,%eax
  800954:	89 c2                	mov    %eax,%edx
  800956:	44 89 e0             	mov    %r12d,%eax
  800959:	83 e0 02             	and    $0x2,%eax
  80095c:	09 c2                	or     %eax,%edx
  80095e:	44 89 e0             	mov    %r12d,%eax
  800961:	83 e0 01             	and    $0x1,%eax
  800964:	c1 e0 06             	shl    $0x6,%eax
  800967:	09 c2                	or     %eax,%edx
  800969:	41 89 d4             	mov    %edx,%r12d
  80096c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800973:	00 00 00 
  800976:	8b 00                	mov    (%rax),%eax
  800978:	44 89 e2             	mov    %r12d,%edx
  80097b:	09 c2                	or     %eax,%edx
  80097d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800984:	00 00 00 
  800987:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800989:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80098d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800991:	48 89 d6             	mov    %rdx,%rsi
  800994:	89 df                	mov    %ebx,%edi
  800996:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800998:	83 fb 6d             	cmp    $0x6d,%ebx
  80099b:	75 1b                	jne    8009b8 <vprintfmt+0x232>
					fmt ++;
  80099d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  8009a2:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  8009a3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8009aa:	00 00 00 
  8009ad:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  8009b3:	e9 cb 04 00 00       	jmpq   800e83 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  8009b8:	e9 83 fe ff ff       	jmpq   800840 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  8009bd:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009c1:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009c8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009d6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009dd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009e1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009e5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009e9:	0f b6 00             	movzbl (%rax),%eax
  8009ec:	0f b6 d8             	movzbl %al,%ebx
  8009ef:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8009f2:	83 f8 55             	cmp    $0x55,%eax
  8009f5:	0f 87 5a 04 00 00    	ja     800e55 <vprintfmt+0x6cf>
  8009fb:	89 c0                	mov    %eax,%eax
  8009fd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a04:	00 
  800a05:	48 b8 10 44 80 00 00 	movabs $0x804410,%rax
  800a0c:	00 00 00 
  800a0f:	48 01 d0             	add    %rdx,%rax
  800a12:	48 8b 00             	mov    (%rax),%rax
  800a15:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a17:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a1b:	eb c0                	jmp    8009dd <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a1d:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a21:	eb ba                	jmp    8009dd <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a23:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a2a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a2d:	89 d0                	mov    %edx,%eax
  800a2f:	c1 e0 02             	shl    $0x2,%eax
  800a32:	01 d0                	add    %edx,%eax
  800a34:	01 c0                	add    %eax,%eax
  800a36:	01 d8                	add    %ebx,%eax
  800a38:	83 e8 30             	sub    $0x30,%eax
  800a3b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a3e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a42:	0f b6 00             	movzbl (%rax),%eax
  800a45:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a48:	83 fb 2f             	cmp    $0x2f,%ebx
  800a4b:	7e 0c                	jle    800a59 <vprintfmt+0x2d3>
  800a4d:	83 fb 39             	cmp    $0x39,%ebx
  800a50:	7f 07                	jg     800a59 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a52:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a57:	eb d1                	jmp    800a2a <vprintfmt+0x2a4>
			goto process_precision;
  800a59:	eb 58                	jmp    800ab3 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800a5b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5e:	83 f8 30             	cmp    $0x30,%eax
  800a61:	73 17                	jae    800a7a <vprintfmt+0x2f4>
  800a63:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a67:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6a:	89 c0                	mov    %eax,%eax
  800a6c:	48 01 d0             	add    %rdx,%rax
  800a6f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a72:	83 c2 08             	add    $0x8,%edx
  800a75:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a78:	eb 0f                	jmp    800a89 <vprintfmt+0x303>
  800a7a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a7e:	48 89 d0             	mov    %rdx,%rax
  800a81:	48 83 c2 08          	add    $0x8,%rdx
  800a85:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a89:	8b 00                	mov    (%rax),%eax
  800a8b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a8e:	eb 23                	jmp    800ab3 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800a90:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a94:	79 0c                	jns    800aa2 <vprintfmt+0x31c>
				width = 0;
  800a96:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a9d:	e9 3b ff ff ff       	jmpq   8009dd <vprintfmt+0x257>
  800aa2:	e9 36 ff ff ff       	jmpq   8009dd <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800aa7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800aae:	e9 2a ff ff ff       	jmpq   8009dd <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800ab3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ab7:	79 12                	jns    800acb <vprintfmt+0x345>
				width = precision, precision = -1;
  800ab9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800abc:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800abf:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800ac6:	e9 12 ff ff ff       	jmpq   8009dd <vprintfmt+0x257>
  800acb:	e9 0d ff ff ff       	jmpq   8009dd <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ad0:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ad4:	e9 04 ff ff ff       	jmpq   8009dd <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ad9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800adc:	83 f8 30             	cmp    $0x30,%eax
  800adf:	73 17                	jae    800af8 <vprintfmt+0x372>
  800ae1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ae5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae8:	89 c0                	mov    %eax,%eax
  800aea:	48 01 d0             	add    %rdx,%rax
  800aed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af0:	83 c2 08             	add    $0x8,%edx
  800af3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800af6:	eb 0f                	jmp    800b07 <vprintfmt+0x381>
  800af8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800afc:	48 89 d0             	mov    %rdx,%rax
  800aff:	48 83 c2 08          	add    $0x8,%rdx
  800b03:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b07:	8b 10                	mov    (%rax),%edx
  800b09:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b0d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b11:	48 89 ce             	mov    %rcx,%rsi
  800b14:	89 d7                	mov    %edx,%edi
  800b16:	ff d0                	callq  *%rax
			break;
  800b18:	e9 66 03 00 00       	jmpq   800e83 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800b1d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b20:	83 f8 30             	cmp    $0x30,%eax
  800b23:	73 17                	jae    800b3c <vprintfmt+0x3b6>
  800b25:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b29:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b2c:	89 c0                	mov    %eax,%eax
  800b2e:	48 01 d0             	add    %rdx,%rax
  800b31:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b34:	83 c2 08             	add    $0x8,%edx
  800b37:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b3a:	eb 0f                	jmp    800b4b <vprintfmt+0x3c5>
  800b3c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b40:	48 89 d0             	mov    %rdx,%rax
  800b43:	48 83 c2 08          	add    $0x8,%rdx
  800b47:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b4b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b4d:	85 db                	test   %ebx,%ebx
  800b4f:	79 02                	jns    800b53 <vprintfmt+0x3cd>
				err = -err;
  800b51:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b53:	83 fb 10             	cmp    $0x10,%ebx
  800b56:	7f 16                	jg     800b6e <vprintfmt+0x3e8>
  800b58:	48 b8 60 43 80 00 00 	movabs $0x804360,%rax
  800b5f:	00 00 00 
  800b62:	48 63 d3             	movslq %ebx,%rdx
  800b65:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b69:	4d 85 e4             	test   %r12,%r12
  800b6c:	75 2e                	jne    800b9c <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800b6e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b72:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b76:	89 d9                	mov    %ebx,%ecx
  800b78:	48 ba f9 43 80 00 00 	movabs $0x8043f9,%rdx
  800b7f:	00 00 00 
  800b82:	48 89 c7             	mov    %rax,%rdi
  800b85:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8a:	49 b8 91 0e 80 00 00 	movabs $0x800e91,%r8
  800b91:	00 00 00 
  800b94:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b97:	e9 e7 02 00 00       	jmpq   800e83 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b9c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ba0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba4:	4c 89 e1             	mov    %r12,%rcx
  800ba7:	48 ba 02 44 80 00 00 	movabs $0x804402,%rdx
  800bae:	00 00 00 
  800bb1:	48 89 c7             	mov    %rax,%rdi
  800bb4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb9:	49 b8 91 0e 80 00 00 	movabs $0x800e91,%r8
  800bc0:	00 00 00 
  800bc3:	41 ff d0             	callq  *%r8
			break;
  800bc6:	e9 b8 02 00 00       	jmpq   800e83 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bcb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bce:	83 f8 30             	cmp    $0x30,%eax
  800bd1:	73 17                	jae    800bea <vprintfmt+0x464>
  800bd3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bd7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bda:	89 c0                	mov    %eax,%eax
  800bdc:	48 01 d0             	add    %rdx,%rax
  800bdf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800be2:	83 c2 08             	add    $0x8,%edx
  800be5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800be8:	eb 0f                	jmp    800bf9 <vprintfmt+0x473>
  800bea:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bee:	48 89 d0             	mov    %rdx,%rax
  800bf1:	48 83 c2 08          	add    $0x8,%rdx
  800bf5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bf9:	4c 8b 20             	mov    (%rax),%r12
  800bfc:	4d 85 e4             	test   %r12,%r12
  800bff:	75 0a                	jne    800c0b <vprintfmt+0x485>
				p = "(null)";
  800c01:	49 bc 05 44 80 00 00 	movabs $0x804405,%r12
  800c08:	00 00 00 
			if (width > 0 && padc != '-')
  800c0b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c0f:	7e 3f                	jle    800c50 <vprintfmt+0x4ca>
  800c11:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c15:	74 39                	je     800c50 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c17:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c1a:	48 98                	cltq   
  800c1c:	48 89 c6             	mov    %rax,%rsi
  800c1f:	4c 89 e7             	mov    %r12,%rdi
  800c22:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  800c29:	00 00 00 
  800c2c:	ff d0                	callq  *%rax
  800c2e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c31:	eb 17                	jmp    800c4a <vprintfmt+0x4c4>
					putch(padc, putdat);
  800c33:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c37:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3f:	48 89 ce             	mov    %rcx,%rsi
  800c42:	89 d7                	mov    %edx,%edi
  800c44:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c46:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c4a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c4e:	7f e3                	jg     800c33 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c50:	eb 37                	jmp    800c89 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800c52:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c56:	74 1e                	je     800c76 <vprintfmt+0x4f0>
  800c58:	83 fb 1f             	cmp    $0x1f,%ebx
  800c5b:	7e 05                	jle    800c62 <vprintfmt+0x4dc>
  800c5d:	83 fb 7e             	cmp    $0x7e,%ebx
  800c60:	7e 14                	jle    800c76 <vprintfmt+0x4f0>
					putch('?', putdat);
  800c62:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c66:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6a:	48 89 d6             	mov    %rdx,%rsi
  800c6d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c72:	ff d0                	callq  *%rax
  800c74:	eb 0f                	jmp    800c85 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800c76:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7e:	48 89 d6             	mov    %rdx,%rsi
  800c81:	89 df                	mov    %ebx,%edi
  800c83:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c85:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c89:	4c 89 e0             	mov    %r12,%rax
  800c8c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c90:	0f b6 00             	movzbl (%rax),%eax
  800c93:	0f be d8             	movsbl %al,%ebx
  800c96:	85 db                	test   %ebx,%ebx
  800c98:	74 10                	je     800caa <vprintfmt+0x524>
  800c9a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c9e:	78 b2                	js     800c52 <vprintfmt+0x4cc>
  800ca0:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ca4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ca8:	79 a8                	jns    800c52 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800caa:	eb 16                	jmp    800cc2 <vprintfmt+0x53c>
				putch(' ', putdat);
  800cac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cb0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb4:	48 89 d6             	mov    %rdx,%rsi
  800cb7:	bf 20 00 00 00       	mov    $0x20,%edi
  800cbc:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cbe:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cc2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cc6:	7f e4                	jg     800cac <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800cc8:	e9 b6 01 00 00       	jmpq   800e83 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ccd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cd1:	be 03 00 00 00       	mov    $0x3,%esi
  800cd6:	48 89 c7             	mov    %rax,%rdi
  800cd9:	48 b8 76 06 80 00 00 	movabs $0x800676,%rax
  800ce0:	00 00 00 
  800ce3:	ff d0                	callq  *%rax
  800ce5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ce9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ced:	48 85 c0             	test   %rax,%rax
  800cf0:	79 1d                	jns    800d0f <vprintfmt+0x589>
				putch('-', putdat);
  800cf2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cfa:	48 89 d6             	mov    %rdx,%rsi
  800cfd:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d02:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d08:	48 f7 d8             	neg    %rax
  800d0b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d0f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d16:	e9 fb 00 00 00       	jmpq   800e16 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d1b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d1f:	be 03 00 00 00       	mov    $0x3,%esi
  800d24:	48 89 c7             	mov    %rax,%rdi
  800d27:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  800d2e:	00 00 00 
  800d31:	ff d0                	callq  *%rax
  800d33:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d37:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d3e:	e9 d3 00 00 00       	jmpq   800e16 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800d43:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d47:	be 03 00 00 00       	mov    $0x3,%esi
  800d4c:	48 89 c7             	mov    %rax,%rdi
  800d4f:	48 b8 76 06 80 00 00 	movabs $0x800676,%rax
  800d56:	00 00 00 
  800d59:	ff d0                	callq  *%rax
  800d5b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d63:	48 85 c0             	test   %rax,%rax
  800d66:	79 1d                	jns    800d85 <vprintfmt+0x5ff>
				putch('-', putdat);
  800d68:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d70:	48 89 d6             	mov    %rdx,%rsi
  800d73:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d78:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d7e:	48 f7 d8             	neg    %rax
  800d81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800d85:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d8c:	e9 85 00 00 00       	jmpq   800e16 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800d91:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d99:	48 89 d6             	mov    %rdx,%rsi
  800d9c:	bf 30 00 00 00       	mov    $0x30,%edi
  800da1:	ff d0                	callq  *%rax
			putch('x', putdat);
  800da3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800da7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dab:	48 89 d6             	mov    %rdx,%rsi
  800dae:	bf 78 00 00 00       	mov    $0x78,%edi
  800db3:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800db5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db8:	83 f8 30             	cmp    $0x30,%eax
  800dbb:	73 17                	jae    800dd4 <vprintfmt+0x64e>
  800dbd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800dc1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dc4:	89 c0                	mov    %eax,%eax
  800dc6:	48 01 d0             	add    %rdx,%rax
  800dc9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dcc:	83 c2 08             	add    $0x8,%edx
  800dcf:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dd2:	eb 0f                	jmp    800de3 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800dd4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dd8:	48 89 d0             	mov    %rdx,%rax
  800ddb:	48 83 c2 08          	add    $0x8,%rdx
  800ddf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800de3:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800de6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800dea:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800df1:	eb 23                	jmp    800e16 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800df3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800df7:	be 03 00 00 00       	mov    $0x3,%esi
  800dfc:	48 89 c7             	mov    %rax,%rdi
  800dff:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  800e06:	00 00 00 
  800e09:	ff d0                	callq  *%rax
  800e0b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e0f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e16:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e1b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e1e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e21:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e25:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2d:	45 89 c1             	mov    %r8d,%r9d
  800e30:	41 89 f8             	mov    %edi,%r8d
  800e33:	48 89 c7             	mov    %rax,%rdi
  800e36:	48 b8 ab 04 80 00 00 	movabs $0x8004ab,%rax
  800e3d:	00 00 00 
  800e40:	ff d0                	callq  *%rax
			break;
  800e42:	eb 3f                	jmp    800e83 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e44:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e4c:	48 89 d6             	mov    %rdx,%rsi
  800e4f:	89 df                	mov    %ebx,%edi
  800e51:	ff d0                	callq  *%rax
			break;
  800e53:	eb 2e                	jmp    800e83 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e55:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5d:	48 89 d6             	mov    %rdx,%rsi
  800e60:	bf 25 00 00 00       	mov    $0x25,%edi
  800e65:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e67:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e6c:	eb 05                	jmp    800e73 <vprintfmt+0x6ed>
  800e6e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e73:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e77:	48 83 e8 01          	sub    $0x1,%rax
  800e7b:	0f b6 00             	movzbl (%rax),%eax
  800e7e:	3c 25                	cmp    $0x25,%al
  800e80:	75 ec                	jne    800e6e <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  800e82:	90                   	nop
		}
	}
  800e83:	e9 37 f9 ff ff       	jmpq   8007bf <vprintfmt+0x39>
    va_end(aq);
}
  800e88:	48 83 c4 60          	add    $0x60,%rsp
  800e8c:	5b                   	pop    %rbx
  800e8d:	41 5c                	pop    %r12
  800e8f:	5d                   	pop    %rbp
  800e90:	c3                   	retq   

0000000000800e91 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e91:	55                   	push   %rbp
  800e92:	48 89 e5             	mov    %rsp,%rbp
  800e95:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e9c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ea3:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800eaa:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800eb1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800eb8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ebf:	84 c0                	test   %al,%al
  800ec1:	74 20                	je     800ee3 <printfmt+0x52>
  800ec3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ec7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ecb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ecf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ed3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ed7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800edb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800edf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ee3:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800eea:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ef1:	00 00 00 
  800ef4:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800efb:	00 00 00 
  800efe:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f02:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f09:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f10:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f17:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f1e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f25:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f2c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f33:	48 89 c7             	mov    %rax,%rdi
  800f36:	48 b8 86 07 80 00 00 	movabs $0x800786,%rax
  800f3d:	00 00 00 
  800f40:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f42:	c9                   	leaveq 
  800f43:	c3                   	retq   

0000000000800f44 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f44:	55                   	push   %rbp
  800f45:	48 89 e5             	mov    %rsp,%rbp
  800f48:	48 83 ec 10          	sub    $0x10,%rsp
  800f4c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f4f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f57:	8b 40 10             	mov    0x10(%rax),%eax
  800f5a:	8d 50 01             	lea    0x1(%rax),%edx
  800f5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f61:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f68:	48 8b 10             	mov    (%rax),%rdx
  800f6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f73:	48 39 c2             	cmp    %rax,%rdx
  800f76:	73 17                	jae    800f8f <sprintputch+0x4b>
		*b->buf++ = ch;
  800f78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f7c:	48 8b 00             	mov    (%rax),%rax
  800f7f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f87:	48 89 0a             	mov    %rcx,(%rdx)
  800f8a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f8d:	88 10                	mov    %dl,(%rax)
}
  800f8f:	c9                   	leaveq 
  800f90:	c3                   	retq   

0000000000800f91 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f91:	55                   	push   %rbp
  800f92:	48 89 e5             	mov    %rsp,%rbp
  800f95:	48 83 ec 50          	sub    $0x50,%rsp
  800f99:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f9d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800fa0:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800fa4:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800fa8:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800fac:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fb0:	48 8b 0a             	mov    (%rdx),%rcx
  800fb3:	48 89 08             	mov    %rcx,(%rax)
  800fb6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fba:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fbe:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fc2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fc6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fca:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800fce:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800fd1:	48 98                	cltq   
  800fd3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800fd7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fdb:	48 01 d0             	add    %rdx,%rax
  800fde:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fe2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fe9:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800fee:	74 06                	je     800ff6 <vsnprintf+0x65>
  800ff0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ff4:	7f 07                	jg     800ffd <vsnprintf+0x6c>
		return -E_INVAL;
  800ff6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ffb:	eb 2f                	jmp    80102c <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ffd:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801001:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801005:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801009:	48 89 c6             	mov    %rax,%rsi
  80100c:	48 bf 44 0f 80 00 00 	movabs $0x800f44,%rdi
  801013:	00 00 00 
  801016:	48 b8 86 07 80 00 00 	movabs $0x800786,%rax
  80101d:	00 00 00 
  801020:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801022:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801026:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801029:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80102c:	c9                   	leaveq 
  80102d:	c3                   	retq   

000000000080102e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80102e:	55                   	push   %rbp
  80102f:	48 89 e5             	mov    %rsp,%rbp
  801032:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801039:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801040:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801046:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80104d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801054:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80105b:	84 c0                	test   %al,%al
  80105d:	74 20                	je     80107f <snprintf+0x51>
  80105f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801063:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801067:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80106b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80106f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801073:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801077:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80107b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80107f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801086:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80108d:	00 00 00 
  801090:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801097:	00 00 00 
  80109a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80109e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010a5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010ac:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010b3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010ba:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010c1:	48 8b 0a             	mov    (%rdx),%rcx
  8010c4:	48 89 08             	mov    %rcx,(%rax)
  8010c7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010cb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010cf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010d3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010d7:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010de:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010e5:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010eb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010f2:	48 89 c7             	mov    %rax,%rdi
  8010f5:	48 b8 91 0f 80 00 00 	movabs $0x800f91,%rax
  8010fc:	00 00 00 
  8010ff:	ff d0                	callq  *%rax
  801101:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801107:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80110d:	c9                   	leaveq 
  80110e:	c3                   	retq   

000000000080110f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80110f:	55                   	push   %rbp
  801110:	48 89 e5             	mov    %rsp,%rbp
  801113:	48 83 ec 18          	sub    $0x18,%rsp
  801117:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80111b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801122:	eb 09                	jmp    80112d <strlen+0x1e>
		n++;
  801124:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801128:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80112d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801131:	0f b6 00             	movzbl (%rax),%eax
  801134:	84 c0                	test   %al,%al
  801136:	75 ec                	jne    801124 <strlen+0x15>
		n++;
	return n;
  801138:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80113b:	c9                   	leaveq 
  80113c:	c3                   	retq   

000000000080113d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80113d:	55                   	push   %rbp
  80113e:	48 89 e5             	mov    %rsp,%rbp
  801141:	48 83 ec 20          	sub    $0x20,%rsp
  801145:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801149:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80114d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801154:	eb 0e                	jmp    801164 <strnlen+0x27>
		n++;
  801156:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80115a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80115f:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801164:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801169:	74 0b                	je     801176 <strnlen+0x39>
  80116b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116f:	0f b6 00             	movzbl (%rax),%eax
  801172:	84 c0                	test   %al,%al
  801174:	75 e0                	jne    801156 <strnlen+0x19>
		n++;
	return n;
  801176:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801179:	c9                   	leaveq 
  80117a:	c3                   	retq   

000000000080117b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80117b:	55                   	push   %rbp
  80117c:	48 89 e5             	mov    %rsp,%rbp
  80117f:	48 83 ec 20          	sub    $0x20,%rsp
  801183:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801187:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80118b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801193:	90                   	nop
  801194:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801198:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80119c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011a0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011a4:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011a8:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011ac:	0f b6 12             	movzbl (%rdx),%edx
  8011af:	88 10                	mov    %dl,(%rax)
  8011b1:	0f b6 00             	movzbl (%rax),%eax
  8011b4:	84 c0                	test   %al,%al
  8011b6:	75 dc                	jne    801194 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011bc:	c9                   	leaveq 
  8011bd:	c3                   	retq   

00000000008011be <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011be:	55                   	push   %rbp
  8011bf:	48 89 e5             	mov    %rsp,%rbp
  8011c2:	48 83 ec 20          	sub    $0x20,%rsp
  8011c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8011ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d2:	48 89 c7             	mov    %rax,%rdi
  8011d5:	48 b8 0f 11 80 00 00 	movabs $0x80110f,%rax
  8011dc:	00 00 00 
  8011df:	ff d0                	callq  *%rax
  8011e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011e7:	48 63 d0             	movslq %eax,%rdx
  8011ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ee:	48 01 c2             	add    %rax,%rdx
  8011f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011f5:	48 89 c6             	mov    %rax,%rsi
  8011f8:	48 89 d7             	mov    %rdx,%rdi
  8011fb:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  801202:	00 00 00 
  801205:	ff d0                	callq  *%rax
	return dst;
  801207:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80120b:	c9                   	leaveq 
  80120c:	c3                   	retq   

000000000080120d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80120d:	55                   	push   %rbp
  80120e:	48 89 e5             	mov    %rsp,%rbp
  801211:	48 83 ec 28          	sub    $0x28,%rsp
  801215:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801219:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80121d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801221:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801225:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801229:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801230:	00 
  801231:	eb 2a                	jmp    80125d <strncpy+0x50>
		*dst++ = *src;
  801233:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801237:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80123b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80123f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801243:	0f b6 12             	movzbl (%rdx),%edx
  801246:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801248:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80124c:	0f b6 00             	movzbl (%rax),%eax
  80124f:	84 c0                	test   %al,%al
  801251:	74 05                	je     801258 <strncpy+0x4b>
			src++;
  801253:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801258:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80125d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801261:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801265:	72 cc                	jb     801233 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801267:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80126b:	c9                   	leaveq 
  80126c:	c3                   	retq   

000000000080126d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80126d:	55                   	push   %rbp
  80126e:	48 89 e5             	mov    %rsp,%rbp
  801271:	48 83 ec 28          	sub    $0x28,%rsp
  801275:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801279:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80127d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801281:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801285:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801289:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80128e:	74 3d                	je     8012cd <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801290:	eb 1d                	jmp    8012af <strlcpy+0x42>
			*dst++ = *src++;
  801292:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801296:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80129a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80129e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012a2:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012a6:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012aa:	0f b6 12             	movzbl (%rdx),%edx
  8012ad:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012af:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012b4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012b9:	74 0b                	je     8012c6 <strlcpy+0x59>
  8012bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012bf:	0f b6 00             	movzbl (%rax),%eax
  8012c2:	84 c0                	test   %al,%al
  8012c4:	75 cc                	jne    801292 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8012c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ca:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d5:	48 29 c2             	sub    %rax,%rdx
  8012d8:	48 89 d0             	mov    %rdx,%rax
}
  8012db:	c9                   	leaveq 
  8012dc:	c3                   	retq   

00000000008012dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012dd:	55                   	push   %rbp
  8012de:	48 89 e5             	mov    %rsp,%rbp
  8012e1:	48 83 ec 10          	sub    $0x10,%rsp
  8012e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012ed:	eb 0a                	jmp    8012f9 <strcmp+0x1c>
		p++, q++;
  8012ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fd:	0f b6 00             	movzbl (%rax),%eax
  801300:	84 c0                	test   %al,%al
  801302:	74 12                	je     801316 <strcmp+0x39>
  801304:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801308:	0f b6 10             	movzbl (%rax),%edx
  80130b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130f:	0f b6 00             	movzbl (%rax),%eax
  801312:	38 c2                	cmp    %al,%dl
  801314:	74 d9                	je     8012ef <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131a:	0f b6 00             	movzbl (%rax),%eax
  80131d:	0f b6 d0             	movzbl %al,%edx
  801320:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801324:	0f b6 00             	movzbl (%rax),%eax
  801327:	0f b6 c0             	movzbl %al,%eax
  80132a:	29 c2                	sub    %eax,%edx
  80132c:	89 d0                	mov    %edx,%eax
}
  80132e:	c9                   	leaveq 
  80132f:	c3                   	retq   

0000000000801330 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801330:	55                   	push   %rbp
  801331:	48 89 e5             	mov    %rsp,%rbp
  801334:	48 83 ec 18          	sub    $0x18,%rsp
  801338:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80133c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801340:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801344:	eb 0f                	jmp    801355 <strncmp+0x25>
		n--, p++, q++;
  801346:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80134b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801350:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801355:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80135a:	74 1d                	je     801379 <strncmp+0x49>
  80135c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801360:	0f b6 00             	movzbl (%rax),%eax
  801363:	84 c0                	test   %al,%al
  801365:	74 12                	je     801379 <strncmp+0x49>
  801367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136b:	0f b6 10             	movzbl (%rax),%edx
  80136e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801372:	0f b6 00             	movzbl (%rax),%eax
  801375:	38 c2                	cmp    %al,%dl
  801377:	74 cd                	je     801346 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801379:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80137e:	75 07                	jne    801387 <strncmp+0x57>
		return 0;
  801380:	b8 00 00 00 00       	mov    $0x0,%eax
  801385:	eb 18                	jmp    80139f <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801387:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138b:	0f b6 00             	movzbl (%rax),%eax
  80138e:	0f b6 d0             	movzbl %al,%edx
  801391:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801395:	0f b6 00             	movzbl (%rax),%eax
  801398:	0f b6 c0             	movzbl %al,%eax
  80139b:	29 c2                	sub    %eax,%edx
  80139d:	89 d0                	mov    %edx,%eax
}
  80139f:	c9                   	leaveq 
  8013a0:	c3                   	retq   

00000000008013a1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013a1:	55                   	push   %rbp
  8013a2:	48 89 e5             	mov    %rsp,%rbp
  8013a5:	48 83 ec 0c          	sub    $0xc,%rsp
  8013a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ad:	89 f0                	mov    %esi,%eax
  8013af:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013b2:	eb 17                	jmp    8013cb <strchr+0x2a>
		if (*s == c)
  8013b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b8:	0f b6 00             	movzbl (%rax),%eax
  8013bb:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013be:	75 06                	jne    8013c6 <strchr+0x25>
			return (char *) s;
  8013c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c4:	eb 15                	jmp    8013db <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013c6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cf:	0f b6 00             	movzbl (%rax),%eax
  8013d2:	84 c0                	test   %al,%al
  8013d4:	75 de                	jne    8013b4 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8013d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013db:	c9                   	leaveq 
  8013dc:	c3                   	retq   

00000000008013dd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013dd:	55                   	push   %rbp
  8013de:	48 89 e5             	mov    %rsp,%rbp
  8013e1:	48 83 ec 0c          	sub    $0xc,%rsp
  8013e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013e9:	89 f0                	mov    %esi,%eax
  8013eb:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013ee:	eb 13                	jmp    801403 <strfind+0x26>
		if (*s == c)
  8013f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f4:	0f b6 00             	movzbl (%rax),%eax
  8013f7:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013fa:	75 02                	jne    8013fe <strfind+0x21>
			break;
  8013fc:	eb 10                	jmp    80140e <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801403:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801407:	0f b6 00             	movzbl (%rax),%eax
  80140a:	84 c0                	test   %al,%al
  80140c:	75 e2                	jne    8013f0 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80140e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801412:	c9                   	leaveq 
  801413:	c3                   	retq   

0000000000801414 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801414:	55                   	push   %rbp
  801415:	48 89 e5             	mov    %rsp,%rbp
  801418:	48 83 ec 18          	sub    $0x18,%rsp
  80141c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801420:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801423:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801427:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80142c:	75 06                	jne    801434 <memset+0x20>
		return v;
  80142e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801432:	eb 69                	jmp    80149d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801434:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801438:	83 e0 03             	and    $0x3,%eax
  80143b:	48 85 c0             	test   %rax,%rax
  80143e:	75 48                	jne    801488 <memset+0x74>
  801440:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801444:	83 e0 03             	and    $0x3,%eax
  801447:	48 85 c0             	test   %rax,%rax
  80144a:	75 3c                	jne    801488 <memset+0x74>
		c &= 0xFF;
  80144c:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801453:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801456:	c1 e0 18             	shl    $0x18,%eax
  801459:	89 c2                	mov    %eax,%edx
  80145b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80145e:	c1 e0 10             	shl    $0x10,%eax
  801461:	09 c2                	or     %eax,%edx
  801463:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801466:	c1 e0 08             	shl    $0x8,%eax
  801469:	09 d0                	or     %edx,%eax
  80146b:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80146e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801472:	48 c1 e8 02          	shr    $0x2,%rax
  801476:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801479:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80147d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801480:	48 89 d7             	mov    %rdx,%rdi
  801483:	fc                   	cld    
  801484:	f3 ab                	rep stos %eax,%es:(%rdi)
  801486:	eb 11                	jmp    801499 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801488:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80148f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801493:	48 89 d7             	mov    %rdx,%rdi
  801496:	fc                   	cld    
  801497:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801499:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80149d:	c9                   	leaveq 
  80149e:	c3                   	retq   

000000000080149f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80149f:	55                   	push   %rbp
  8014a0:	48 89 e5             	mov    %rsp,%rbp
  8014a3:	48 83 ec 28          	sub    $0x28,%rsp
  8014a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014cb:	0f 83 88 00 00 00    	jae    801559 <memmove+0xba>
  8014d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d9:	48 01 d0             	add    %rdx,%rax
  8014dc:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014e0:	76 77                	jbe    801559 <memmove+0xba>
		s += n;
  8014e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e6:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ee:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f6:	83 e0 03             	and    $0x3,%eax
  8014f9:	48 85 c0             	test   %rax,%rax
  8014fc:	75 3b                	jne    801539 <memmove+0x9a>
  8014fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801502:	83 e0 03             	and    $0x3,%eax
  801505:	48 85 c0             	test   %rax,%rax
  801508:	75 2f                	jne    801539 <memmove+0x9a>
  80150a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150e:	83 e0 03             	and    $0x3,%eax
  801511:	48 85 c0             	test   %rax,%rax
  801514:	75 23                	jne    801539 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801516:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151a:	48 83 e8 04          	sub    $0x4,%rax
  80151e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801522:	48 83 ea 04          	sub    $0x4,%rdx
  801526:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80152a:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80152e:	48 89 c7             	mov    %rax,%rdi
  801531:	48 89 d6             	mov    %rdx,%rsi
  801534:	fd                   	std    
  801535:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801537:	eb 1d                	jmp    801556 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801539:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80153d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801541:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801545:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801549:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154d:	48 89 d7             	mov    %rdx,%rdi
  801550:	48 89 c1             	mov    %rax,%rcx
  801553:	fd                   	std    
  801554:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801556:	fc                   	cld    
  801557:	eb 57                	jmp    8015b0 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801559:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155d:	83 e0 03             	and    $0x3,%eax
  801560:	48 85 c0             	test   %rax,%rax
  801563:	75 36                	jne    80159b <memmove+0xfc>
  801565:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801569:	83 e0 03             	and    $0x3,%eax
  80156c:	48 85 c0             	test   %rax,%rax
  80156f:	75 2a                	jne    80159b <memmove+0xfc>
  801571:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801575:	83 e0 03             	and    $0x3,%eax
  801578:	48 85 c0             	test   %rax,%rax
  80157b:	75 1e                	jne    80159b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80157d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801581:	48 c1 e8 02          	shr    $0x2,%rax
  801585:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801588:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80158c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801590:	48 89 c7             	mov    %rax,%rdi
  801593:	48 89 d6             	mov    %rdx,%rsi
  801596:	fc                   	cld    
  801597:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801599:	eb 15                	jmp    8015b0 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80159b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015a3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015a7:	48 89 c7             	mov    %rax,%rdi
  8015aa:	48 89 d6             	mov    %rdx,%rsi
  8015ad:	fc                   	cld    
  8015ae:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015b4:	c9                   	leaveq 
  8015b5:	c3                   	retq   

00000000008015b6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015b6:	55                   	push   %rbp
  8015b7:	48 89 e5             	mov    %rsp,%rbp
  8015ba:	48 83 ec 18          	sub    $0x18,%rsp
  8015be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015c6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015ce:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d6:	48 89 ce             	mov    %rcx,%rsi
  8015d9:	48 89 c7             	mov    %rax,%rdi
  8015dc:	48 b8 9f 14 80 00 00 	movabs $0x80149f,%rax
  8015e3:	00 00 00 
  8015e6:	ff d0                	callq  *%rax
}
  8015e8:	c9                   	leaveq 
  8015e9:	c3                   	retq   

00000000008015ea <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015ea:	55                   	push   %rbp
  8015eb:	48 89 e5             	mov    %rsp,%rbp
  8015ee:	48 83 ec 28          	sub    $0x28,%rsp
  8015f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801602:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801606:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80160a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80160e:	eb 36                	jmp    801646 <memcmp+0x5c>
		if (*s1 != *s2)
  801610:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801614:	0f b6 10             	movzbl (%rax),%edx
  801617:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161b:	0f b6 00             	movzbl (%rax),%eax
  80161e:	38 c2                	cmp    %al,%dl
  801620:	74 1a                	je     80163c <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801622:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801626:	0f b6 00             	movzbl (%rax),%eax
  801629:	0f b6 d0             	movzbl %al,%edx
  80162c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801630:	0f b6 00             	movzbl (%rax),%eax
  801633:	0f b6 c0             	movzbl %al,%eax
  801636:	29 c2                	sub    %eax,%edx
  801638:	89 d0                	mov    %edx,%eax
  80163a:	eb 20                	jmp    80165c <memcmp+0x72>
		s1++, s2++;
  80163c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801641:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801646:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80164e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801652:	48 85 c0             	test   %rax,%rax
  801655:	75 b9                	jne    801610 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801657:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80165c:	c9                   	leaveq 
  80165d:	c3                   	retq   

000000000080165e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80165e:	55                   	push   %rbp
  80165f:	48 89 e5             	mov    %rsp,%rbp
  801662:	48 83 ec 28          	sub    $0x28,%rsp
  801666:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80166a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80166d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801671:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801675:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801679:	48 01 d0             	add    %rdx,%rax
  80167c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801680:	eb 15                	jmp    801697 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801682:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801686:	0f b6 10             	movzbl (%rax),%edx
  801689:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80168c:	38 c2                	cmp    %al,%dl
  80168e:	75 02                	jne    801692 <memfind+0x34>
			break;
  801690:	eb 0f                	jmp    8016a1 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801692:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80169b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80169f:	72 e1                	jb     801682 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8016a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016a5:	c9                   	leaveq 
  8016a6:	c3                   	retq   

00000000008016a7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016a7:	55                   	push   %rbp
  8016a8:	48 89 e5             	mov    %rsp,%rbp
  8016ab:	48 83 ec 34          	sub    $0x34,%rsp
  8016af:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016b3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016b7:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016c1:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016c8:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016c9:	eb 05                	jmp    8016d0 <strtol+0x29>
		s++;
  8016cb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d4:	0f b6 00             	movzbl (%rax),%eax
  8016d7:	3c 20                	cmp    $0x20,%al
  8016d9:	74 f0                	je     8016cb <strtol+0x24>
  8016db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016df:	0f b6 00             	movzbl (%rax),%eax
  8016e2:	3c 09                	cmp    $0x9,%al
  8016e4:	74 e5                	je     8016cb <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ea:	0f b6 00             	movzbl (%rax),%eax
  8016ed:	3c 2b                	cmp    $0x2b,%al
  8016ef:	75 07                	jne    8016f8 <strtol+0x51>
		s++;
  8016f1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016f6:	eb 17                	jmp    80170f <strtol+0x68>
	else if (*s == '-')
  8016f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fc:	0f b6 00             	movzbl (%rax),%eax
  8016ff:	3c 2d                	cmp    $0x2d,%al
  801701:	75 0c                	jne    80170f <strtol+0x68>
		s++, neg = 1;
  801703:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801708:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80170f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801713:	74 06                	je     80171b <strtol+0x74>
  801715:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801719:	75 28                	jne    801743 <strtol+0x9c>
  80171b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171f:	0f b6 00             	movzbl (%rax),%eax
  801722:	3c 30                	cmp    $0x30,%al
  801724:	75 1d                	jne    801743 <strtol+0x9c>
  801726:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172a:	48 83 c0 01          	add    $0x1,%rax
  80172e:	0f b6 00             	movzbl (%rax),%eax
  801731:	3c 78                	cmp    $0x78,%al
  801733:	75 0e                	jne    801743 <strtol+0x9c>
		s += 2, base = 16;
  801735:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80173a:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801741:	eb 2c                	jmp    80176f <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801743:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801747:	75 19                	jne    801762 <strtol+0xbb>
  801749:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174d:	0f b6 00             	movzbl (%rax),%eax
  801750:	3c 30                	cmp    $0x30,%al
  801752:	75 0e                	jne    801762 <strtol+0xbb>
		s++, base = 8;
  801754:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801759:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801760:	eb 0d                	jmp    80176f <strtol+0xc8>
	else if (base == 0)
  801762:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801766:	75 07                	jne    80176f <strtol+0xc8>
		base = 10;
  801768:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80176f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801773:	0f b6 00             	movzbl (%rax),%eax
  801776:	3c 2f                	cmp    $0x2f,%al
  801778:	7e 1d                	jle    801797 <strtol+0xf0>
  80177a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177e:	0f b6 00             	movzbl (%rax),%eax
  801781:	3c 39                	cmp    $0x39,%al
  801783:	7f 12                	jg     801797 <strtol+0xf0>
			dig = *s - '0';
  801785:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801789:	0f b6 00             	movzbl (%rax),%eax
  80178c:	0f be c0             	movsbl %al,%eax
  80178f:	83 e8 30             	sub    $0x30,%eax
  801792:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801795:	eb 4e                	jmp    8017e5 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801797:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179b:	0f b6 00             	movzbl (%rax),%eax
  80179e:	3c 60                	cmp    $0x60,%al
  8017a0:	7e 1d                	jle    8017bf <strtol+0x118>
  8017a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a6:	0f b6 00             	movzbl (%rax),%eax
  8017a9:	3c 7a                	cmp    $0x7a,%al
  8017ab:	7f 12                	jg     8017bf <strtol+0x118>
			dig = *s - 'a' + 10;
  8017ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b1:	0f b6 00             	movzbl (%rax),%eax
  8017b4:	0f be c0             	movsbl %al,%eax
  8017b7:	83 e8 57             	sub    $0x57,%eax
  8017ba:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017bd:	eb 26                	jmp    8017e5 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c3:	0f b6 00             	movzbl (%rax),%eax
  8017c6:	3c 40                	cmp    $0x40,%al
  8017c8:	7e 48                	jle    801812 <strtol+0x16b>
  8017ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ce:	0f b6 00             	movzbl (%rax),%eax
  8017d1:	3c 5a                	cmp    $0x5a,%al
  8017d3:	7f 3d                	jg     801812 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8017d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d9:	0f b6 00             	movzbl (%rax),%eax
  8017dc:	0f be c0             	movsbl %al,%eax
  8017df:	83 e8 37             	sub    $0x37,%eax
  8017e2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017e8:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017eb:	7c 02                	jl     8017ef <strtol+0x148>
			break;
  8017ed:	eb 23                	jmp    801812 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8017ef:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017f4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017f7:	48 98                	cltq   
  8017f9:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017fe:	48 89 c2             	mov    %rax,%rdx
  801801:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801804:	48 98                	cltq   
  801806:	48 01 d0             	add    %rdx,%rax
  801809:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80180d:	e9 5d ff ff ff       	jmpq   80176f <strtol+0xc8>

	if (endptr)
  801812:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801817:	74 0b                	je     801824 <strtol+0x17d>
		*endptr = (char *) s;
  801819:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80181d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801821:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801824:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801828:	74 09                	je     801833 <strtol+0x18c>
  80182a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80182e:	48 f7 d8             	neg    %rax
  801831:	eb 04                	jmp    801837 <strtol+0x190>
  801833:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801837:	c9                   	leaveq 
  801838:	c3                   	retq   

0000000000801839 <strstr>:

char * strstr(const char *in, const char *str)
{
  801839:	55                   	push   %rbp
  80183a:	48 89 e5             	mov    %rsp,%rbp
  80183d:	48 83 ec 30          	sub    $0x30,%rsp
  801841:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801845:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801849:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80184d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801851:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801855:	0f b6 00             	movzbl (%rax),%eax
  801858:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  80185b:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80185f:	75 06                	jne    801867 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801861:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801865:	eb 6b                	jmp    8018d2 <strstr+0x99>

    len = strlen(str);
  801867:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80186b:	48 89 c7             	mov    %rax,%rdi
  80186e:	48 b8 0f 11 80 00 00 	movabs $0x80110f,%rax
  801875:	00 00 00 
  801878:	ff d0                	callq  *%rax
  80187a:	48 98                	cltq   
  80187c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801880:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801884:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801888:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80188c:	0f b6 00             	movzbl (%rax),%eax
  80188f:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801892:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801896:	75 07                	jne    80189f <strstr+0x66>
                return (char *) 0;
  801898:	b8 00 00 00 00       	mov    $0x0,%eax
  80189d:	eb 33                	jmp    8018d2 <strstr+0x99>
        } while (sc != c);
  80189f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018a3:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018a6:	75 d8                	jne    801880 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  8018a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ac:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b4:	48 89 ce             	mov    %rcx,%rsi
  8018b7:	48 89 c7             	mov    %rax,%rdi
  8018ba:	48 b8 30 13 80 00 00 	movabs $0x801330,%rax
  8018c1:	00 00 00 
  8018c4:	ff d0                	callq  *%rax
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	75 b6                	jne    801880 <strstr+0x47>

    return (char *) (in - 1);
  8018ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ce:	48 83 e8 01          	sub    $0x1,%rax
}
  8018d2:	c9                   	leaveq 
  8018d3:	c3                   	retq   

00000000008018d4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018d4:	55                   	push   %rbp
  8018d5:	48 89 e5             	mov    %rsp,%rbp
  8018d8:	53                   	push   %rbx
  8018d9:	48 83 ec 48          	sub    $0x48,%rsp
  8018dd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018e0:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018e3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018e7:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018eb:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018ef:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018f3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018f6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018fa:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018fe:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801902:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801906:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80190a:	4c 89 c3             	mov    %r8,%rbx
  80190d:	cd 30                	int    $0x30
  80190f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801913:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801917:	74 3e                	je     801957 <syscall+0x83>
  801919:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80191e:	7e 37                	jle    801957 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801920:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801924:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801927:	49 89 d0             	mov    %rdx,%r8
  80192a:	89 c1                	mov    %eax,%ecx
  80192c:	48 ba c0 46 80 00 00 	movabs $0x8046c0,%rdx
  801933:	00 00 00 
  801936:	be 23 00 00 00       	mov    $0x23,%esi
  80193b:	48 bf dd 46 80 00 00 	movabs $0x8046dd,%rdi
  801942:	00 00 00 
  801945:	b8 00 00 00 00       	mov    $0x0,%eax
  80194a:	49 b9 9a 01 80 00 00 	movabs $0x80019a,%r9
  801951:	00 00 00 
  801954:	41 ff d1             	callq  *%r9

	return ret;
  801957:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80195b:	48 83 c4 48          	add    $0x48,%rsp
  80195f:	5b                   	pop    %rbx
  801960:	5d                   	pop    %rbp
  801961:	c3                   	retq   

0000000000801962 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801962:	55                   	push   %rbp
  801963:	48 89 e5             	mov    %rsp,%rbp
  801966:	48 83 ec 20          	sub    $0x20,%rsp
  80196a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80196e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801972:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801976:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80197a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801981:	00 
  801982:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801988:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198e:	48 89 d1             	mov    %rdx,%rcx
  801991:	48 89 c2             	mov    %rax,%rdx
  801994:	be 00 00 00 00       	mov    $0x0,%esi
  801999:	bf 00 00 00 00       	mov    $0x0,%edi
  80199e:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  8019a5:	00 00 00 
  8019a8:	ff d0                	callq  *%rax
}
  8019aa:	c9                   	leaveq 
  8019ab:	c3                   	retq   

00000000008019ac <sys_cgetc>:

int
sys_cgetc(void)
{
  8019ac:	55                   	push   %rbp
  8019ad:	48 89 e5             	mov    %rsp,%rbp
  8019b0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019b4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019bb:	00 
  8019bc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d2:	be 00 00 00 00       	mov    $0x0,%esi
  8019d7:	bf 01 00 00 00       	mov    $0x1,%edi
  8019dc:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  8019e3:	00 00 00 
  8019e6:	ff d0                	callq  *%rax
}
  8019e8:	c9                   	leaveq 
  8019e9:	c3                   	retq   

00000000008019ea <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019ea:	55                   	push   %rbp
  8019eb:	48 89 e5             	mov    %rsp,%rbp
  8019ee:	48 83 ec 10          	sub    $0x10,%rsp
  8019f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f8:	48 98                	cltq   
  8019fa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a01:	00 
  801a02:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a08:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a13:	48 89 c2             	mov    %rax,%rdx
  801a16:	be 01 00 00 00       	mov    $0x1,%esi
  801a1b:	bf 03 00 00 00       	mov    $0x3,%edi
  801a20:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801a27:	00 00 00 
  801a2a:	ff d0                	callq  *%rax
}
  801a2c:	c9                   	leaveq 
  801a2d:	c3                   	retq   

0000000000801a2e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a2e:	55                   	push   %rbp
  801a2f:	48 89 e5             	mov    %rsp,%rbp
  801a32:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a36:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3d:	00 
  801a3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a4f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a54:	be 00 00 00 00       	mov    $0x0,%esi
  801a59:	bf 02 00 00 00       	mov    $0x2,%edi
  801a5e:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801a65:	00 00 00 
  801a68:	ff d0                	callq  *%rax
}
  801a6a:	c9                   	leaveq 
  801a6b:	c3                   	retq   

0000000000801a6c <sys_yield>:

void
sys_yield(void)
{
  801a6c:	55                   	push   %rbp
  801a6d:	48 89 e5             	mov    %rsp,%rbp
  801a70:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a74:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a7b:	00 
  801a7c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a82:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a88:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a92:	be 00 00 00 00       	mov    $0x0,%esi
  801a97:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a9c:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801aa3:	00 00 00 
  801aa6:	ff d0                	callq  *%rax
}
  801aa8:	c9                   	leaveq 
  801aa9:	c3                   	retq   

0000000000801aaa <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801aaa:	55                   	push   %rbp
  801aab:	48 89 e5             	mov    %rsp,%rbp
  801aae:	48 83 ec 20          	sub    $0x20,%rsp
  801ab2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ab5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ab9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801abc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801abf:	48 63 c8             	movslq %eax,%rcx
  801ac2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac9:	48 98                	cltq   
  801acb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad2:	00 
  801ad3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad9:	49 89 c8             	mov    %rcx,%r8
  801adc:	48 89 d1             	mov    %rdx,%rcx
  801adf:	48 89 c2             	mov    %rax,%rdx
  801ae2:	be 01 00 00 00       	mov    $0x1,%esi
  801ae7:	bf 04 00 00 00       	mov    $0x4,%edi
  801aec:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801af3:	00 00 00 
  801af6:	ff d0                	callq  *%rax
}
  801af8:	c9                   	leaveq 
  801af9:	c3                   	retq   

0000000000801afa <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801afa:	55                   	push   %rbp
  801afb:	48 89 e5             	mov    %rsp,%rbp
  801afe:	48 83 ec 30          	sub    $0x30,%rsp
  801b02:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b05:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b09:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b0c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b10:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b14:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b17:	48 63 c8             	movslq %eax,%rcx
  801b1a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b1e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b21:	48 63 f0             	movslq %eax,%rsi
  801b24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2b:	48 98                	cltq   
  801b2d:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b31:	49 89 f9             	mov    %rdi,%r9
  801b34:	49 89 f0             	mov    %rsi,%r8
  801b37:	48 89 d1             	mov    %rdx,%rcx
  801b3a:	48 89 c2             	mov    %rax,%rdx
  801b3d:	be 01 00 00 00       	mov    $0x1,%esi
  801b42:	bf 05 00 00 00       	mov    $0x5,%edi
  801b47:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801b4e:	00 00 00 
  801b51:	ff d0                	callq  *%rax
}
  801b53:	c9                   	leaveq 
  801b54:	c3                   	retq   

0000000000801b55 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b55:	55                   	push   %rbp
  801b56:	48 89 e5             	mov    %rsp,%rbp
  801b59:	48 83 ec 20          	sub    $0x20,%rsp
  801b5d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b60:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b6b:	48 98                	cltq   
  801b6d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b74:	00 
  801b75:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b7b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b81:	48 89 d1             	mov    %rdx,%rcx
  801b84:	48 89 c2             	mov    %rax,%rdx
  801b87:	be 01 00 00 00       	mov    $0x1,%esi
  801b8c:	bf 06 00 00 00       	mov    $0x6,%edi
  801b91:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801b98:	00 00 00 
  801b9b:	ff d0                	callq  *%rax
}
  801b9d:	c9                   	leaveq 
  801b9e:	c3                   	retq   

0000000000801b9f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b9f:	55                   	push   %rbp
  801ba0:	48 89 e5             	mov    %rsp,%rbp
  801ba3:	48 83 ec 10          	sub    $0x10,%rsp
  801ba7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801baa:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801bad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bb0:	48 63 d0             	movslq %eax,%rdx
  801bb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb6:	48 98                	cltq   
  801bb8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bbf:	00 
  801bc0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bcc:	48 89 d1             	mov    %rdx,%rcx
  801bcf:	48 89 c2             	mov    %rax,%rdx
  801bd2:	be 01 00 00 00       	mov    $0x1,%esi
  801bd7:	bf 08 00 00 00       	mov    $0x8,%edi
  801bdc:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801be3:	00 00 00 
  801be6:	ff d0                	callq  *%rax
}
  801be8:	c9                   	leaveq 
  801be9:	c3                   	retq   

0000000000801bea <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801bea:	55                   	push   %rbp
  801beb:	48 89 e5             	mov    %rsp,%rbp
  801bee:	48 83 ec 20          	sub    $0x20,%rsp
  801bf2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bf9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c00:	48 98                	cltq   
  801c02:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c09:	00 
  801c0a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c10:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c16:	48 89 d1             	mov    %rdx,%rcx
  801c19:	48 89 c2             	mov    %rax,%rdx
  801c1c:	be 01 00 00 00       	mov    $0x1,%esi
  801c21:	bf 09 00 00 00       	mov    $0x9,%edi
  801c26:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801c2d:	00 00 00 
  801c30:	ff d0                	callq  *%rax
}
  801c32:	c9                   	leaveq 
  801c33:	c3                   	retq   

0000000000801c34 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c34:	55                   	push   %rbp
  801c35:	48 89 e5             	mov    %rsp,%rbp
  801c38:	48 83 ec 20          	sub    $0x20,%rsp
  801c3c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c43:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4a:	48 98                	cltq   
  801c4c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c53:	00 
  801c54:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c60:	48 89 d1             	mov    %rdx,%rcx
  801c63:	48 89 c2             	mov    %rax,%rdx
  801c66:	be 01 00 00 00       	mov    $0x1,%esi
  801c6b:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c70:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801c77:	00 00 00 
  801c7a:	ff d0                	callq  *%rax
}
  801c7c:	c9                   	leaveq 
  801c7d:	c3                   	retq   

0000000000801c7e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c7e:	55                   	push   %rbp
  801c7f:	48 89 e5             	mov    %rsp,%rbp
  801c82:	48 83 ec 20          	sub    $0x20,%rsp
  801c86:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c89:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c8d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c91:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c94:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c97:	48 63 f0             	movslq %eax,%rsi
  801c9a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ca1:	48 98                	cltq   
  801ca3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cae:	00 
  801caf:	49 89 f1             	mov    %rsi,%r9
  801cb2:	49 89 c8             	mov    %rcx,%r8
  801cb5:	48 89 d1             	mov    %rdx,%rcx
  801cb8:	48 89 c2             	mov    %rax,%rdx
  801cbb:	be 00 00 00 00       	mov    $0x0,%esi
  801cc0:	bf 0c 00 00 00       	mov    $0xc,%edi
  801cc5:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801ccc:	00 00 00 
  801ccf:	ff d0                	callq  *%rax
}
  801cd1:	c9                   	leaveq 
  801cd2:	c3                   	retq   

0000000000801cd3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801cd3:	55                   	push   %rbp
  801cd4:	48 89 e5             	mov    %rsp,%rbp
  801cd7:	48 83 ec 10          	sub    $0x10,%rsp
  801cdb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801cdf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ce3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cea:	00 
  801ceb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cfc:	48 89 c2             	mov    %rax,%rdx
  801cff:	be 01 00 00 00       	mov    $0x1,%esi
  801d04:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d09:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801d10:	00 00 00 
  801d13:	ff d0                	callq  *%rax
}
  801d15:	c9                   	leaveq 
  801d16:	c3                   	retq   

0000000000801d17 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d17:	55                   	push   %rbp
  801d18:	48 89 e5             	mov    %rsp,%rbp
  801d1b:	48 83 ec 08          	sub    $0x8,%rsp
  801d1f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d23:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d27:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d2e:	ff ff ff 
  801d31:	48 01 d0             	add    %rdx,%rax
  801d34:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d38:	c9                   	leaveq 
  801d39:	c3                   	retq   

0000000000801d3a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d3a:	55                   	push   %rbp
  801d3b:	48 89 e5             	mov    %rsp,%rbp
  801d3e:	48 83 ec 08          	sub    $0x8,%rsp
  801d42:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d4a:	48 89 c7             	mov    %rax,%rdi
  801d4d:	48 b8 17 1d 80 00 00 	movabs $0x801d17,%rax
  801d54:	00 00 00 
  801d57:	ff d0                	callq  *%rax
  801d59:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d5f:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d63:	c9                   	leaveq 
  801d64:	c3                   	retq   

0000000000801d65 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d65:	55                   	push   %rbp
  801d66:	48 89 e5             	mov    %rsp,%rbp
  801d69:	48 83 ec 18          	sub    $0x18,%rsp
  801d6d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d78:	eb 6b                	jmp    801de5 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7d:	48 98                	cltq   
  801d7f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d85:	48 c1 e0 0c          	shl    $0xc,%rax
  801d89:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d91:	48 c1 e8 15          	shr    $0x15,%rax
  801d95:	48 89 c2             	mov    %rax,%rdx
  801d98:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d9f:	01 00 00 
  801da2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801da6:	83 e0 01             	and    $0x1,%eax
  801da9:	48 85 c0             	test   %rax,%rax
  801dac:	74 21                	je     801dcf <fd_alloc+0x6a>
  801dae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801db2:	48 c1 e8 0c          	shr    $0xc,%rax
  801db6:	48 89 c2             	mov    %rax,%rdx
  801db9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dc0:	01 00 00 
  801dc3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dc7:	83 e0 01             	and    $0x1,%eax
  801dca:	48 85 c0             	test   %rax,%rax
  801dcd:	75 12                	jne    801de1 <fd_alloc+0x7c>
			*fd_store = fd;
  801dcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dd7:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801dda:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddf:	eb 1a                	jmp    801dfb <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801de1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801de5:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801de9:	7e 8f                	jle    801d7a <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801deb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801def:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801df6:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801dfb:	c9                   	leaveq 
  801dfc:	c3                   	retq   

0000000000801dfd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801dfd:	55                   	push   %rbp
  801dfe:	48 89 e5             	mov    %rsp,%rbp
  801e01:	48 83 ec 20          	sub    $0x20,%rsp
  801e05:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e08:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e0c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e10:	78 06                	js     801e18 <fd_lookup+0x1b>
  801e12:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e16:	7e 07                	jle    801e1f <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e1d:	eb 6c                	jmp    801e8b <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e1f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e22:	48 98                	cltq   
  801e24:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e2a:	48 c1 e0 0c          	shl    $0xc,%rax
  801e2e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e36:	48 c1 e8 15          	shr    $0x15,%rax
  801e3a:	48 89 c2             	mov    %rax,%rdx
  801e3d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e44:	01 00 00 
  801e47:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e4b:	83 e0 01             	and    $0x1,%eax
  801e4e:	48 85 c0             	test   %rax,%rax
  801e51:	74 21                	je     801e74 <fd_lookup+0x77>
  801e53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e57:	48 c1 e8 0c          	shr    $0xc,%rax
  801e5b:	48 89 c2             	mov    %rax,%rdx
  801e5e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e65:	01 00 00 
  801e68:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e6c:	83 e0 01             	and    $0x1,%eax
  801e6f:	48 85 c0             	test   %rax,%rax
  801e72:	75 07                	jne    801e7b <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e74:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e79:	eb 10                	jmp    801e8b <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e7b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e7f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e83:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8b:	c9                   	leaveq 
  801e8c:	c3                   	retq   

0000000000801e8d <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e8d:	55                   	push   %rbp
  801e8e:	48 89 e5             	mov    %rsp,%rbp
  801e91:	48 83 ec 30          	sub    $0x30,%rsp
  801e95:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e99:	89 f0                	mov    %esi,%eax
  801e9b:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea2:	48 89 c7             	mov    %rax,%rdi
  801ea5:	48 b8 17 1d 80 00 00 	movabs $0x801d17,%rax
  801eac:	00 00 00 
  801eaf:	ff d0                	callq  *%rax
  801eb1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801eb5:	48 89 d6             	mov    %rdx,%rsi
  801eb8:	89 c7                	mov    %eax,%edi
  801eba:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  801ec1:	00 00 00 
  801ec4:	ff d0                	callq  *%rax
  801ec6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ec9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ecd:	78 0a                	js     801ed9 <fd_close+0x4c>
	    || fd != fd2)
  801ecf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed3:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801ed7:	74 12                	je     801eeb <fd_close+0x5e>
		return (must_exist ? r : 0);
  801ed9:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801edd:	74 05                	je     801ee4 <fd_close+0x57>
  801edf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee2:	eb 05                	jmp    801ee9 <fd_close+0x5c>
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee9:	eb 69                	jmp    801f54 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801eeb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eef:	8b 00                	mov    (%rax),%eax
  801ef1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ef5:	48 89 d6             	mov    %rdx,%rsi
  801ef8:	89 c7                	mov    %eax,%edi
  801efa:	48 b8 56 1f 80 00 00 	movabs $0x801f56,%rax
  801f01:	00 00 00 
  801f04:	ff d0                	callq  *%rax
  801f06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f0d:	78 2a                	js     801f39 <fd_close+0xac>
		if (dev->dev_close)
  801f0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f13:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f17:	48 85 c0             	test   %rax,%rax
  801f1a:	74 16                	je     801f32 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f20:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f24:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f28:	48 89 d7             	mov    %rdx,%rdi
  801f2b:	ff d0                	callq  *%rax
  801f2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f30:	eb 07                	jmp    801f39 <fd_close+0xac>
		else
			r = 0;
  801f32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f3d:	48 89 c6             	mov    %rax,%rsi
  801f40:	bf 00 00 00 00       	mov    $0x0,%edi
  801f45:	48 b8 55 1b 80 00 00 	movabs $0x801b55,%rax
  801f4c:	00 00 00 
  801f4f:	ff d0                	callq  *%rax
	return r;
  801f51:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f54:	c9                   	leaveq 
  801f55:	c3                   	retq   

0000000000801f56 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f56:	55                   	push   %rbp
  801f57:	48 89 e5             	mov    %rsp,%rbp
  801f5a:	48 83 ec 20          	sub    $0x20,%rsp
  801f5e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f61:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f6c:	eb 41                	jmp    801faf <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f6e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f75:	00 00 00 
  801f78:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f7b:	48 63 d2             	movslq %edx,%rdx
  801f7e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f82:	8b 00                	mov    (%rax),%eax
  801f84:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f87:	75 22                	jne    801fab <dev_lookup+0x55>
			*dev = devtab[i];
  801f89:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f90:	00 00 00 
  801f93:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f96:	48 63 d2             	movslq %edx,%rdx
  801f99:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fa1:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa9:	eb 60                	jmp    80200b <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801fab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801faf:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fb6:	00 00 00 
  801fb9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fbc:	48 63 d2             	movslq %edx,%rdx
  801fbf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fc3:	48 85 c0             	test   %rax,%rax
  801fc6:	75 a6                	jne    801f6e <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801fc8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801fcf:	00 00 00 
  801fd2:	48 8b 00             	mov    (%rax),%rax
  801fd5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fdb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fde:	89 c6                	mov    %eax,%esi
  801fe0:	48 bf f0 46 80 00 00 	movabs $0x8046f0,%rdi
  801fe7:	00 00 00 
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
  801fef:	48 b9 d3 03 80 00 00 	movabs $0x8003d3,%rcx
  801ff6:	00 00 00 
  801ff9:	ff d1                	callq  *%rcx
	*dev = 0;
  801ffb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fff:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802006:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80200b:	c9                   	leaveq 
  80200c:	c3                   	retq   

000000000080200d <close>:

int
close(int fdnum)
{
  80200d:	55                   	push   %rbp
  80200e:	48 89 e5             	mov    %rsp,%rbp
  802011:	48 83 ec 20          	sub    $0x20,%rsp
  802015:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802018:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80201c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80201f:	48 89 d6             	mov    %rdx,%rsi
  802022:	89 c7                	mov    %eax,%edi
  802024:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  80202b:	00 00 00 
  80202e:	ff d0                	callq  *%rax
  802030:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802033:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802037:	79 05                	jns    80203e <close+0x31>
		return r;
  802039:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80203c:	eb 18                	jmp    802056 <close+0x49>
	else
		return fd_close(fd, 1);
  80203e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802042:	be 01 00 00 00       	mov    $0x1,%esi
  802047:	48 89 c7             	mov    %rax,%rdi
  80204a:	48 b8 8d 1e 80 00 00 	movabs $0x801e8d,%rax
  802051:	00 00 00 
  802054:	ff d0                	callq  *%rax
}
  802056:	c9                   	leaveq 
  802057:	c3                   	retq   

0000000000802058 <close_all>:

void
close_all(void)
{
  802058:	55                   	push   %rbp
  802059:	48 89 e5             	mov    %rsp,%rbp
  80205c:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802060:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802067:	eb 15                	jmp    80207e <close_all+0x26>
		close(i);
  802069:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80206c:	89 c7                	mov    %eax,%edi
  80206e:	48 b8 0d 20 80 00 00 	movabs $0x80200d,%rax
  802075:	00 00 00 
  802078:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80207a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80207e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802082:	7e e5                	jle    802069 <close_all+0x11>
		close(i);
}
  802084:	c9                   	leaveq 
  802085:	c3                   	retq   

0000000000802086 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802086:	55                   	push   %rbp
  802087:	48 89 e5             	mov    %rsp,%rbp
  80208a:	48 83 ec 40          	sub    $0x40,%rsp
  80208e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802091:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802094:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802098:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80209b:	48 89 d6             	mov    %rdx,%rsi
  80209e:	89 c7                	mov    %eax,%edi
  8020a0:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  8020a7:	00 00 00 
  8020aa:	ff d0                	callq  *%rax
  8020ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020b3:	79 08                	jns    8020bd <dup+0x37>
		return r;
  8020b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b8:	e9 70 01 00 00       	jmpq   80222d <dup+0x1a7>
	close(newfdnum);
  8020bd:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020c0:	89 c7                	mov    %eax,%edi
  8020c2:	48 b8 0d 20 80 00 00 	movabs $0x80200d,%rax
  8020c9:	00 00 00 
  8020cc:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020ce:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020d1:	48 98                	cltq   
  8020d3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020d9:	48 c1 e0 0c          	shl    $0xc,%rax
  8020dd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020e5:	48 89 c7             	mov    %rax,%rdi
  8020e8:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  8020ef:	00 00 00 
  8020f2:	ff d0                	callq  *%rax
  8020f4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8020f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020fc:	48 89 c7             	mov    %rax,%rdi
  8020ff:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  802106:	00 00 00 
  802109:	ff d0                	callq  *%rax
  80210b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80210f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802113:	48 c1 e8 15          	shr    $0x15,%rax
  802117:	48 89 c2             	mov    %rax,%rdx
  80211a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802121:	01 00 00 
  802124:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802128:	83 e0 01             	and    $0x1,%eax
  80212b:	48 85 c0             	test   %rax,%rax
  80212e:	74 73                	je     8021a3 <dup+0x11d>
  802130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802134:	48 c1 e8 0c          	shr    $0xc,%rax
  802138:	48 89 c2             	mov    %rax,%rdx
  80213b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802142:	01 00 00 
  802145:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802149:	83 e0 01             	and    $0x1,%eax
  80214c:	48 85 c0             	test   %rax,%rax
  80214f:	74 52                	je     8021a3 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802151:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802155:	48 c1 e8 0c          	shr    $0xc,%rax
  802159:	48 89 c2             	mov    %rax,%rdx
  80215c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802163:	01 00 00 
  802166:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80216a:	25 07 0e 00 00       	and    $0xe07,%eax
  80216f:	89 c1                	mov    %eax,%ecx
  802171:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802175:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802179:	41 89 c8             	mov    %ecx,%r8d
  80217c:	48 89 d1             	mov    %rdx,%rcx
  80217f:	ba 00 00 00 00       	mov    $0x0,%edx
  802184:	48 89 c6             	mov    %rax,%rsi
  802187:	bf 00 00 00 00       	mov    $0x0,%edi
  80218c:	48 b8 fa 1a 80 00 00 	movabs $0x801afa,%rax
  802193:	00 00 00 
  802196:	ff d0                	callq  *%rax
  802198:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80219b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80219f:	79 02                	jns    8021a3 <dup+0x11d>
			goto err;
  8021a1:	eb 57                	jmp    8021fa <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021a7:	48 c1 e8 0c          	shr    $0xc,%rax
  8021ab:	48 89 c2             	mov    %rax,%rdx
  8021ae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021b5:	01 00 00 
  8021b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021bc:	25 07 0e 00 00       	and    $0xe07,%eax
  8021c1:	89 c1                	mov    %eax,%ecx
  8021c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021cb:	41 89 c8             	mov    %ecx,%r8d
  8021ce:	48 89 d1             	mov    %rdx,%rcx
  8021d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d6:	48 89 c6             	mov    %rax,%rsi
  8021d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8021de:	48 b8 fa 1a 80 00 00 	movabs $0x801afa,%rax
  8021e5:	00 00 00 
  8021e8:	ff d0                	callq  *%rax
  8021ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021f1:	79 02                	jns    8021f5 <dup+0x16f>
		goto err;
  8021f3:	eb 05                	jmp    8021fa <dup+0x174>

	return newfdnum;
  8021f5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021f8:	eb 33                	jmp    80222d <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8021fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021fe:	48 89 c6             	mov    %rax,%rsi
  802201:	bf 00 00 00 00       	mov    $0x0,%edi
  802206:	48 b8 55 1b 80 00 00 	movabs $0x801b55,%rax
  80220d:	00 00 00 
  802210:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802212:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802216:	48 89 c6             	mov    %rax,%rsi
  802219:	bf 00 00 00 00       	mov    $0x0,%edi
  80221e:	48 b8 55 1b 80 00 00 	movabs $0x801b55,%rax
  802225:	00 00 00 
  802228:	ff d0                	callq  *%rax
	return r;
  80222a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80222d:	c9                   	leaveq 
  80222e:	c3                   	retq   

000000000080222f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80222f:	55                   	push   %rbp
  802230:	48 89 e5             	mov    %rsp,%rbp
  802233:	48 83 ec 40          	sub    $0x40,%rsp
  802237:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80223a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80223e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802242:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802246:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802249:	48 89 d6             	mov    %rdx,%rsi
  80224c:	89 c7                	mov    %eax,%edi
  80224e:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  802255:	00 00 00 
  802258:	ff d0                	callq  *%rax
  80225a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80225d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802261:	78 24                	js     802287 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802263:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802267:	8b 00                	mov    (%rax),%eax
  802269:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80226d:	48 89 d6             	mov    %rdx,%rsi
  802270:	89 c7                	mov    %eax,%edi
  802272:	48 b8 56 1f 80 00 00 	movabs $0x801f56,%rax
  802279:	00 00 00 
  80227c:	ff d0                	callq  *%rax
  80227e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802281:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802285:	79 05                	jns    80228c <read+0x5d>
		return r;
  802287:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80228a:	eb 76                	jmp    802302 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80228c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802290:	8b 40 08             	mov    0x8(%rax),%eax
  802293:	83 e0 03             	and    $0x3,%eax
  802296:	83 f8 01             	cmp    $0x1,%eax
  802299:	75 3a                	jne    8022d5 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80229b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022a2:	00 00 00 
  8022a5:	48 8b 00             	mov    (%rax),%rax
  8022a8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022ae:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022b1:	89 c6                	mov    %eax,%esi
  8022b3:	48 bf 0f 47 80 00 00 	movabs $0x80470f,%rdi
  8022ba:	00 00 00 
  8022bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c2:	48 b9 d3 03 80 00 00 	movabs $0x8003d3,%rcx
  8022c9:	00 00 00 
  8022cc:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022d3:	eb 2d                	jmp    802302 <read+0xd3>
	}
	if (!dev->dev_read)
  8022d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d9:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022dd:	48 85 c0             	test   %rax,%rax
  8022e0:	75 07                	jne    8022e9 <read+0xba>
		return -E_NOT_SUPP;
  8022e2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022e7:	eb 19                	jmp    802302 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8022e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ed:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022f1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022f5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022f9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022fd:	48 89 cf             	mov    %rcx,%rdi
  802300:	ff d0                	callq  *%rax
}
  802302:	c9                   	leaveq 
  802303:	c3                   	retq   

0000000000802304 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802304:	55                   	push   %rbp
  802305:	48 89 e5             	mov    %rsp,%rbp
  802308:	48 83 ec 30          	sub    $0x30,%rsp
  80230c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80230f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802313:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802317:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80231e:	eb 49                	jmp    802369 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802320:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802323:	48 98                	cltq   
  802325:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802329:	48 29 c2             	sub    %rax,%rdx
  80232c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80232f:	48 63 c8             	movslq %eax,%rcx
  802332:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802336:	48 01 c1             	add    %rax,%rcx
  802339:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80233c:	48 89 ce             	mov    %rcx,%rsi
  80233f:	89 c7                	mov    %eax,%edi
  802341:	48 b8 2f 22 80 00 00 	movabs $0x80222f,%rax
  802348:	00 00 00 
  80234b:	ff d0                	callq  *%rax
  80234d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802350:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802354:	79 05                	jns    80235b <readn+0x57>
			return m;
  802356:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802359:	eb 1c                	jmp    802377 <readn+0x73>
		if (m == 0)
  80235b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80235f:	75 02                	jne    802363 <readn+0x5f>
			break;
  802361:	eb 11                	jmp    802374 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802363:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802366:	01 45 fc             	add    %eax,-0x4(%rbp)
  802369:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80236c:	48 98                	cltq   
  80236e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802372:	72 ac                	jb     802320 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802374:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802377:	c9                   	leaveq 
  802378:	c3                   	retq   

0000000000802379 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802379:	55                   	push   %rbp
  80237a:	48 89 e5             	mov    %rsp,%rbp
  80237d:	48 83 ec 40          	sub    $0x40,%rsp
  802381:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802384:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802388:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80238c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802390:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802393:	48 89 d6             	mov    %rdx,%rsi
  802396:	89 c7                	mov    %eax,%edi
  802398:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  80239f:	00 00 00 
  8023a2:	ff d0                	callq  *%rax
  8023a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ab:	78 24                	js     8023d1 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b1:	8b 00                	mov    (%rax),%eax
  8023b3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023b7:	48 89 d6             	mov    %rdx,%rsi
  8023ba:	89 c7                	mov    %eax,%edi
  8023bc:	48 b8 56 1f 80 00 00 	movabs $0x801f56,%rax
  8023c3:	00 00 00 
  8023c6:	ff d0                	callq  *%rax
  8023c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023cf:	79 05                	jns    8023d6 <write+0x5d>
		return r;
  8023d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d4:	eb 75                	jmp    80244b <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023da:	8b 40 08             	mov    0x8(%rax),%eax
  8023dd:	83 e0 03             	and    $0x3,%eax
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	75 3a                	jne    80241e <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023e4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023eb:	00 00 00 
  8023ee:	48 8b 00             	mov    (%rax),%rax
  8023f1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023f7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023fa:	89 c6                	mov    %eax,%esi
  8023fc:	48 bf 2b 47 80 00 00 	movabs $0x80472b,%rdi
  802403:	00 00 00 
  802406:	b8 00 00 00 00       	mov    $0x0,%eax
  80240b:	48 b9 d3 03 80 00 00 	movabs $0x8003d3,%rcx
  802412:	00 00 00 
  802415:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802417:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80241c:	eb 2d                	jmp    80244b <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80241e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802422:	48 8b 40 18          	mov    0x18(%rax),%rax
  802426:	48 85 c0             	test   %rax,%rax
  802429:	75 07                	jne    802432 <write+0xb9>
		return -E_NOT_SUPP;
  80242b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802430:	eb 19                	jmp    80244b <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802432:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802436:	48 8b 40 18          	mov    0x18(%rax),%rax
  80243a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80243e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802442:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802446:	48 89 cf             	mov    %rcx,%rdi
  802449:	ff d0                	callq  *%rax
}
  80244b:	c9                   	leaveq 
  80244c:	c3                   	retq   

000000000080244d <seek>:

int
seek(int fdnum, off_t offset)
{
  80244d:	55                   	push   %rbp
  80244e:	48 89 e5             	mov    %rsp,%rbp
  802451:	48 83 ec 18          	sub    $0x18,%rsp
  802455:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802458:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80245b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80245f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802462:	48 89 d6             	mov    %rdx,%rsi
  802465:	89 c7                	mov    %eax,%edi
  802467:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  80246e:	00 00 00 
  802471:	ff d0                	callq  *%rax
  802473:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802476:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80247a:	79 05                	jns    802481 <seek+0x34>
		return r;
  80247c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80247f:	eb 0f                	jmp    802490 <seek+0x43>
	fd->fd_offset = offset;
  802481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802485:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802488:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80248b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802490:	c9                   	leaveq 
  802491:	c3                   	retq   

0000000000802492 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802492:	55                   	push   %rbp
  802493:	48 89 e5             	mov    %rsp,%rbp
  802496:	48 83 ec 30          	sub    $0x30,%rsp
  80249a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80249d:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024a0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024a4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024a7:	48 89 d6             	mov    %rdx,%rsi
  8024aa:	89 c7                	mov    %eax,%edi
  8024ac:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  8024b3:	00 00 00 
  8024b6:	ff d0                	callq  *%rax
  8024b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024bf:	78 24                	js     8024e5 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c5:	8b 00                	mov    (%rax),%eax
  8024c7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024cb:	48 89 d6             	mov    %rdx,%rsi
  8024ce:	89 c7                	mov    %eax,%edi
  8024d0:	48 b8 56 1f 80 00 00 	movabs $0x801f56,%rax
  8024d7:	00 00 00 
  8024da:	ff d0                	callq  *%rax
  8024dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024e3:	79 05                	jns    8024ea <ftruncate+0x58>
		return r;
  8024e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e8:	eb 72                	jmp    80255c <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ee:	8b 40 08             	mov    0x8(%rax),%eax
  8024f1:	83 e0 03             	and    $0x3,%eax
  8024f4:	85 c0                	test   %eax,%eax
  8024f6:	75 3a                	jne    802532 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024f8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8024ff:	00 00 00 
  802502:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802505:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80250b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80250e:	89 c6                	mov    %eax,%esi
  802510:	48 bf 48 47 80 00 00 	movabs $0x804748,%rdi
  802517:	00 00 00 
  80251a:	b8 00 00 00 00       	mov    $0x0,%eax
  80251f:	48 b9 d3 03 80 00 00 	movabs $0x8003d3,%rcx
  802526:	00 00 00 
  802529:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80252b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802530:	eb 2a                	jmp    80255c <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802532:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802536:	48 8b 40 30          	mov    0x30(%rax),%rax
  80253a:	48 85 c0             	test   %rax,%rax
  80253d:	75 07                	jne    802546 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80253f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802544:	eb 16                	jmp    80255c <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802546:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80254a:	48 8b 40 30          	mov    0x30(%rax),%rax
  80254e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802552:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802555:	89 ce                	mov    %ecx,%esi
  802557:	48 89 d7             	mov    %rdx,%rdi
  80255a:	ff d0                	callq  *%rax
}
  80255c:	c9                   	leaveq 
  80255d:	c3                   	retq   

000000000080255e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80255e:	55                   	push   %rbp
  80255f:	48 89 e5             	mov    %rsp,%rbp
  802562:	48 83 ec 30          	sub    $0x30,%rsp
  802566:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802569:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80256d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802571:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802574:	48 89 d6             	mov    %rdx,%rsi
  802577:	89 c7                	mov    %eax,%edi
  802579:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  802580:	00 00 00 
  802583:	ff d0                	callq  *%rax
  802585:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802588:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258c:	78 24                	js     8025b2 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80258e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802592:	8b 00                	mov    (%rax),%eax
  802594:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802598:	48 89 d6             	mov    %rdx,%rsi
  80259b:	89 c7                	mov    %eax,%edi
  80259d:	48 b8 56 1f 80 00 00 	movabs $0x801f56,%rax
  8025a4:	00 00 00 
  8025a7:	ff d0                	callq  *%rax
  8025a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b0:	79 05                	jns    8025b7 <fstat+0x59>
		return r;
  8025b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b5:	eb 5e                	jmp    802615 <fstat+0xb7>
	if (!dev->dev_stat)
  8025b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025bb:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025bf:	48 85 c0             	test   %rax,%rax
  8025c2:	75 07                	jne    8025cb <fstat+0x6d>
		return -E_NOT_SUPP;
  8025c4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025c9:	eb 4a                	jmp    802615 <fstat+0xb7>
	stat->st_name[0] = 0;
  8025cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025cf:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025d6:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025dd:	00 00 00 
	stat->st_isdir = 0;
  8025e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025e4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025eb:	00 00 00 
	stat->st_dev = dev;
  8025ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025f6:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8025fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802601:	48 8b 40 28          	mov    0x28(%rax),%rax
  802605:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802609:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80260d:	48 89 ce             	mov    %rcx,%rsi
  802610:	48 89 d7             	mov    %rdx,%rdi
  802613:	ff d0                	callq  *%rax
}
  802615:	c9                   	leaveq 
  802616:	c3                   	retq   

0000000000802617 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802617:	55                   	push   %rbp
  802618:	48 89 e5             	mov    %rsp,%rbp
  80261b:	48 83 ec 20          	sub    $0x20,%rsp
  80261f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802623:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80262b:	be 00 00 00 00       	mov    $0x0,%esi
  802630:	48 89 c7             	mov    %rax,%rdi
  802633:	48 b8 05 27 80 00 00 	movabs $0x802705,%rax
  80263a:	00 00 00 
  80263d:	ff d0                	callq  *%rax
  80263f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802642:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802646:	79 05                	jns    80264d <stat+0x36>
		return fd;
  802648:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264b:	eb 2f                	jmp    80267c <stat+0x65>
	r = fstat(fd, stat);
  80264d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802651:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802654:	48 89 d6             	mov    %rdx,%rsi
  802657:	89 c7                	mov    %eax,%edi
  802659:	48 b8 5e 25 80 00 00 	movabs $0x80255e,%rax
  802660:	00 00 00 
  802663:	ff d0                	callq  *%rax
  802665:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802668:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80266b:	89 c7                	mov    %eax,%edi
  80266d:	48 b8 0d 20 80 00 00 	movabs $0x80200d,%rax
  802674:	00 00 00 
  802677:	ff d0                	callq  *%rax
	return r;
  802679:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80267c:	c9                   	leaveq 
  80267d:	c3                   	retq   

000000000080267e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80267e:	55                   	push   %rbp
  80267f:	48 89 e5             	mov    %rsp,%rbp
  802682:	48 83 ec 10          	sub    $0x10,%rsp
  802686:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802689:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80268d:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802694:	00 00 00 
  802697:	8b 00                	mov    (%rax),%eax
  802699:	85 c0                	test   %eax,%eax
  80269b:	75 1d                	jne    8026ba <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80269d:	bf 01 00 00 00       	mov    $0x1,%edi
  8026a2:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8026a9:	00 00 00 
  8026ac:	ff d0                	callq  *%rax
  8026ae:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8026b5:	00 00 00 
  8026b8:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026ba:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8026c1:	00 00 00 
  8026c4:	8b 00                	mov    (%rax),%eax
  8026c6:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026c9:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026ce:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8026d5:	00 00 00 
  8026d8:	89 c7                	mov    %eax,%edi
  8026da:	48 b8 c8 3f 80 00 00 	movabs $0x803fc8,%rax
  8026e1:	00 00 00 
  8026e4:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ef:	48 89 c6             	mov    %rax,%rsi
  8026f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f7:	48 b8 ff 3e 80 00 00 	movabs $0x803eff,%rax
  8026fe:	00 00 00 
  802701:	ff d0                	callq  *%rax
}
  802703:	c9                   	leaveq 
  802704:	c3                   	retq   

0000000000802705 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802705:	55                   	push   %rbp
  802706:	48 89 e5             	mov    %rsp,%rbp
  802709:	48 83 ec 20          	sub    $0x20,%rsp
  80270d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802711:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802714:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802718:	48 89 c7             	mov    %rax,%rdi
  80271b:	48 b8 0f 11 80 00 00 	movabs $0x80110f,%rax
  802722:	00 00 00 
  802725:	ff d0                	callq  *%rax
  802727:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80272c:	7e 0a                	jle    802738 <open+0x33>
		return -E_BAD_PATH;
  80272e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802733:	e9 a5 00 00 00       	jmpq   8027dd <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802738:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80273c:	48 89 c7             	mov    %rax,%rdi
  80273f:	48 b8 65 1d 80 00 00 	movabs $0x801d65,%rax
  802746:	00 00 00 
  802749:	ff d0                	callq  *%rax
  80274b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80274e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802752:	79 08                	jns    80275c <open+0x57>
		return r;
  802754:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802757:	e9 81 00 00 00       	jmpq   8027dd <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80275c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802760:	48 89 c6             	mov    %rax,%rsi
  802763:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80276a:	00 00 00 
  80276d:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  802774:	00 00 00 
  802777:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802779:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802780:	00 00 00 
  802783:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802786:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80278c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802790:	48 89 c6             	mov    %rax,%rsi
  802793:	bf 01 00 00 00       	mov    $0x1,%edi
  802798:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  80279f:	00 00 00 
  8027a2:	ff d0                	callq  *%rax
  8027a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ab:	79 1d                	jns    8027ca <open+0xc5>
		fd_close(fd, 0);
  8027ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027b1:	be 00 00 00 00       	mov    $0x0,%esi
  8027b6:	48 89 c7             	mov    %rax,%rdi
  8027b9:	48 b8 8d 1e 80 00 00 	movabs $0x801e8d,%rax
  8027c0:	00 00 00 
  8027c3:	ff d0                	callq  *%rax
		return r;
  8027c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c8:	eb 13                	jmp    8027dd <open+0xd8>
	}

	return fd2num(fd);
  8027ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ce:	48 89 c7             	mov    %rax,%rdi
  8027d1:	48 b8 17 1d 80 00 00 	movabs $0x801d17,%rax
  8027d8:	00 00 00 
  8027db:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  8027dd:	c9                   	leaveq 
  8027de:	c3                   	retq   

00000000008027df <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8027df:	55                   	push   %rbp
  8027e0:	48 89 e5             	mov    %rsp,%rbp
  8027e3:	48 83 ec 10          	sub    $0x10,%rsp
  8027e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8027eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027ef:	8b 50 0c             	mov    0xc(%rax),%edx
  8027f2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027f9:	00 00 00 
  8027fc:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8027fe:	be 00 00 00 00       	mov    $0x0,%esi
  802803:	bf 06 00 00 00       	mov    $0x6,%edi
  802808:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  80280f:	00 00 00 
  802812:	ff d0                	callq  *%rax
}
  802814:	c9                   	leaveq 
  802815:	c3                   	retq   

0000000000802816 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802816:	55                   	push   %rbp
  802817:	48 89 e5             	mov    %rsp,%rbp
  80281a:	48 83 ec 30          	sub    $0x30,%rsp
  80281e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802822:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802826:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80282a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80282e:	8b 50 0c             	mov    0xc(%rax),%edx
  802831:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802838:	00 00 00 
  80283b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80283d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802844:	00 00 00 
  802847:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80284b:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80284f:	be 00 00 00 00       	mov    $0x0,%esi
  802854:	bf 03 00 00 00       	mov    $0x3,%edi
  802859:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  802860:	00 00 00 
  802863:	ff d0                	callq  *%rax
  802865:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802868:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286c:	79 05                	jns    802873 <devfile_read+0x5d>
		return r;
  80286e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802871:	eb 26                	jmp    802899 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802873:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802876:	48 63 d0             	movslq %eax,%rdx
  802879:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80287d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802884:	00 00 00 
  802887:	48 89 c7             	mov    %rax,%rdi
  80288a:	48 b8 9f 14 80 00 00 	movabs $0x80149f,%rax
  802891:	00 00 00 
  802894:	ff d0                	callq  *%rax

	return r;
  802896:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802899:	c9                   	leaveq 
  80289a:	c3                   	retq   

000000000080289b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80289b:	55                   	push   %rbp
  80289c:	48 89 e5             	mov    %rsp,%rbp
  80289f:	48 83 ec 30          	sub    $0x30,%rsp
  8028a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  8028af:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8028b6:	00 
  8028b7:	76 08                	jbe    8028c1 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  8028b9:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8028c0:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8028c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c5:	8b 50 0c             	mov    0xc(%rax),%edx
  8028c8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028cf:	00 00 00 
  8028d2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8028d4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028db:	00 00 00 
  8028de:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028e2:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  8028e6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028ee:	48 89 c6             	mov    %rax,%rsi
  8028f1:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8028f8:	00 00 00 
  8028fb:	48 b8 9f 14 80 00 00 	movabs $0x80149f,%rax
  802902:	00 00 00 
  802905:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802907:	be 00 00 00 00       	mov    $0x0,%esi
  80290c:	bf 04 00 00 00       	mov    $0x4,%edi
  802911:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  802918:	00 00 00 
  80291b:	ff d0                	callq  *%rax
  80291d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802920:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802924:	79 05                	jns    80292b <devfile_write+0x90>
		return r;
  802926:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802929:	eb 03                	jmp    80292e <devfile_write+0x93>

	return r;
  80292b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80292e:	c9                   	leaveq 
  80292f:	c3                   	retq   

0000000000802930 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802930:	55                   	push   %rbp
  802931:	48 89 e5             	mov    %rsp,%rbp
  802934:	48 83 ec 20          	sub    $0x20,%rsp
  802938:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80293c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802940:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802944:	8b 50 0c             	mov    0xc(%rax),%edx
  802947:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80294e:	00 00 00 
  802951:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802953:	be 00 00 00 00       	mov    $0x0,%esi
  802958:	bf 05 00 00 00       	mov    $0x5,%edi
  80295d:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  802964:	00 00 00 
  802967:	ff d0                	callq  *%rax
  802969:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80296c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802970:	79 05                	jns    802977 <devfile_stat+0x47>
		return r;
  802972:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802975:	eb 56                	jmp    8029cd <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802977:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80297b:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802982:	00 00 00 
  802985:	48 89 c7             	mov    %rax,%rdi
  802988:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  80298f:	00 00 00 
  802992:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802994:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80299b:	00 00 00 
  80299e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8029a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029a8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8029ae:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029b5:	00 00 00 
  8029b8:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8029be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c2:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8029c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029cd:	c9                   	leaveq 
  8029ce:	c3                   	retq   

00000000008029cf <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8029cf:	55                   	push   %rbp
  8029d0:	48 89 e5             	mov    %rsp,%rbp
  8029d3:	48 83 ec 10          	sub    $0x10,%rsp
  8029d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8029db:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8029de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029e2:	8b 50 0c             	mov    0xc(%rax),%edx
  8029e5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029ec:	00 00 00 
  8029ef:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8029f1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029f8:	00 00 00 
  8029fb:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8029fe:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a01:	be 00 00 00 00       	mov    $0x0,%esi
  802a06:	bf 02 00 00 00       	mov    $0x2,%edi
  802a0b:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  802a12:	00 00 00 
  802a15:	ff d0                	callq  *%rax
}
  802a17:	c9                   	leaveq 
  802a18:	c3                   	retq   

0000000000802a19 <remove>:

// Delete a file
int
remove(const char *path)
{
  802a19:	55                   	push   %rbp
  802a1a:	48 89 e5             	mov    %rsp,%rbp
  802a1d:	48 83 ec 10          	sub    $0x10,%rsp
  802a21:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802a25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a29:	48 89 c7             	mov    %rax,%rdi
  802a2c:	48 b8 0f 11 80 00 00 	movabs $0x80110f,%rax
  802a33:	00 00 00 
  802a36:	ff d0                	callq  *%rax
  802a38:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a3d:	7e 07                	jle    802a46 <remove+0x2d>
		return -E_BAD_PATH;
  802a3f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a44:	eb 33                	jmp    802a79 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802a46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a4a:	48 89 c6             	mov    %rax,%rsi
  802a4d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802a54:	00 00 00 
  802a57:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  802a5e:	00 00 00 
  802a61:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802a63:	be 00 00 00 00       	mov    $0x0,%esi
  802a68:	bf 07 00 00 00       	mov    $0x7,%edi
  802a6d:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  802a74:	00 00 00 
  802a77:	ff d0                	callq  *%rax
}
  802a79:	c9                   	leaveq 
  802a7a:	c3                   	retq   

0000000000802a7b <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802a7b:	55                   	push   %rbp
  802a7c:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802a7f:	be 00 00 00 00       	mov    $0x0,%esi
  802a84:	bf 08 00 00 00       	mov    $0x8,%edi
  802a89:	48 b8 7e 26 80 00 00 	movabs $0x80267e,%rax
  802a90:	00 00 00 
  802a93:	ff d0                	callq  *%rax
}
  802a95:	5d                   	pop    %rbp
  802a96:	c3                   	retq   

0000000000802a97 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802a97:	55                   	push   %rbp
  802a98:	48 89 e5             	mov    %rsp,%rbp
  802a9b:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  802aa2:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802aa9:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802ab0:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802ab7:	be 00 00 00 00       	mov    $0x0,%esi
  802abc:	48 89 c7             	mov    %rax,%rdi
  802abf:	48 b8 05 27 80 00 00 	movabs $0x802705,%rax
  802ac6:	00 00 00 
  802ac9:	ff d0                	callq  *%rax
  802acb:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802ace:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802ad2:	79 08                	jns    802adc <spawn+0x45>
		return r;
  802ad4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ad7:	e9 14 03 00 00       	jmpq   802df0 <spawn+0x359>
	fd = r;
  802adc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802adf:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802ae2:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802ae9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802aed:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802af4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802af7:	ba 00 02 00 00       	mov    $0x200,%edx
  802afc:	48 89 ce             	mov    %rcx,%rsi
  802aff:	89 c7                	mov    %eax,%edi
  802b01:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  802b08:	00 00 00 
  802b0b:	ff d0                	callq  *%rax
  802b0d:	3d 00 02 00 00       	cmp    $0x200,%eax
  802b12:	75 0d                	jne    802b21 <spawn+0x8a>
	    || elf->e_magic != ELF_MAGIC) {
  802b14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b18:	8b 00                	mov    (%rax),%eax
  802b1a:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802b1f:	74 43                	je     802b64 <spawn+0xcd>
		close(fd);
  802b21:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802b24:	89 c7                	mov    %eax,%edi
  802b26:	48 b8 0d 20 80 00 00 	movabs $0x80200d,%rax
  802b2d:	00 00 00 
  802b30:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802b32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b36:	8b 00                	mov    (%rax),%eax
  802b38:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802b3d:	89 c6                	mov    %eax,%esi
  802b3f:	48 bf 70 47 80 00 00 	movabs $0x804770,%rdi
  802b46:	00 00 00 
  802b49:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4e:	48 b9 d3 03 80 00 00 	movabs $0x8003d3,%rcx
  802b55:	00 00 00 
  802b58:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802b5a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802b5f:	e9 8c 02 00 00       	jmpq   802df0 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802b64:	b8 07 00 00 00       	mov    $0x7,%eax
  802b69:	cd 30                	int    $0x30
  802b6b:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802b6e:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802b71:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802b74:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802b78:	79 08                	jns    802b82 <spawn+0xeb>
		return r;
  802b7a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802b7d:	e9 6e 02 00 00       	jmpq   802df0 <spawn+0x359>
	child = r;
  802b82:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802b85:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802b88:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802b8b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802b90:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802b97:	00 00 00 
  802b9a:	48 63 d0             	movslq %eax,%rdx
  802b9d:	48 89 d0             	mov    %rdx,%rax
  802ba0:	48 c1 e0 03          	shl    $0x3,%rax
  802ba4:	48 01 d0             	add    %rdx,%rax
  802ba7:	48 c1 e0 05          	shl    $0x5,%rax
  802bab:	48 01 c8             	add    %rcx,%rax
  802bae:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802bb5:	48 89 c6             	mov    %rax,%rsi
  802bb8:	b8 18 00 00 00       	mov    $0x18,%eax
  802bbd:	48 89 d7             	mov    %rdx,%rdi
  802bc0:	48 89 c1             	mov    %rax,%rcx
  802bc3:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802bc6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bca:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bce:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802bd5:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802bdc:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802be3:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802bea:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802bed:	48 89 ce             	mov    %rcx,%rsi
  802bf0:	89 c7                	mov    %eax,%edi
  802bf2:	48 b8 5a 30 80 00 00 	movabs $0x80305a,%rax
  802bf9:	00 00 00 
  802bfc:	ff d0                	callq  *%rax
  802bfe:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802c01:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802c05:	79 08                	jns    802c0f <spawn+0x178>
		return r;
  802c07:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c0a:	e9 e1 01 00 00       	jmpq   802df0 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802c0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c13:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c17:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802c1e:	48 01 d0             	add    %rdx,%rax
  802c21:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c2c:	e9 a3 00 00 00       	jmpq   802cd4 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  802c31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c35:	8b 00                	mov    (%rax),%eax
  802c37:	83 f8 01             	cmp    $0x1,%eax
  802c3a:	74 05                	je     802c41 <spawn+0x1aa>
			continue;
  802c3c:	e9 8a 00 00 00       	jmpq   802ccb <spawn+0x234>
		perm = PTE_P | PTE_U;
  802c41:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802c48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c4c:	8b 40 04             	mov    0x4(%rax),%eax
  802c4f:	83 e0 02             	and    $0x2,%eax
  802c52:	85 c0                	test   %eax,%eax
  802c54:	74 04                	je     802c5a <spawn+0x1c3>
			perm |= PTE_W;
  802c56:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802c5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c5e:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802c62:	41 89 c1             	mov    %eax,%r9d
  802c65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c69:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802c6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c71:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802c75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c79:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802c7d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802c80:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802c83:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802c86:	89 3c 24             	mov    %edi,(%rsp)
  802c89:	89 c7                	mov    %eax,%edi
  802c8b:	48 b8 03 33 80 00 00 	movabs $0x803303,%rax
  802c92:	00 00 00 
  802c95:	ff d0                	callq  *%rax
  802c97:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802c9a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802c9e:	79 2b                	jns    802ccb <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802ca0:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802ca1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ca4:	89 c7                	mov    %eax,%edi
  802ca6:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  802cad:	00 00 00 
  802cb0:	ff d0                	callq  *%rax
	close(fd);
  802cb2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802cb5:	89 c7                	mov    %eax,%edi
  802cb7:	48 b8 0d 20 80 00 00 	movabs $0x80200d,%rax
  802cbe:	00 00 00 
  802cc1:	ff d0                	callq  *%rax
	return r;
  802cc3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cc6:	e9 25 01 00 00       	jmpq   802df0 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802ccb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ccf:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802cd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cd8:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802cdc:	0f b7 c0             	movzwl %ax,%eax
  802cdf:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802ce2:	0f 8f 49 ff ff ff    	jg     802c31 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802ce8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802ceb:	89 c7                	mov    %eax,%edi
  802ced:	48 b8 0d 20 80 00 00 	movabs $0x80200d,%rax
  802cf4:	00 00 00 
  802cf7:	ff d0                	callq  *%rax
	fd = -1;
  802cf9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802d00:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d03:	89 c7                	mov    %eax,%edi
  802d05:	48 b8 ef 34 80 00 00 	movabs $0x8034ef,%rax
  802d0c:	00 00 00 
  802d0f:	ff d0                	callq  *%rax
  802d11:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d14:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d18:	79 30                	jns    802d4a <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  802d1a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d1d:	89 c1                	mov    %eax,%ecx
  802d1f:	48 ba 8a 47 80 00 00 	movabs $0x80478a,%rdx
  802d26:	00 00 00 
  802d29:	be 82 00 00 00       	mov    $0x82,%esi
  802d2e:	48 bf a0 47 80 00 00 	movabs $0x8047a0,%rdi
  802d35:	00 00 00 
  802d38:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3d:	49 b8 9a 01 80 00 00 	movabs $0x80019a,%r8
  802d44:	00 00 00 
  802d47:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802d4a:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802d51:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d54:	48 89 d6             	mov    %rdx,%rsi
  802d57:	89 c7                	mov    %eax,%edi
  802d59:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  802d60:	00 00 00 
  802d63:	ff d0                	callq  *%rax
  802d65:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d68:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d6c:	79 30                	jns    802d9e <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  802d6e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d71:	89 c1                	mov    %eax,%ecx
  802d73:	48 ba ac 47 80 00 00 	movabs $0x8047ac,%rdx
  802d7a:	00 00 00 
  802d7d:	be 85 00 00 00       	mov    $0x85,%esi
  802d82:	48 bf a0 47 80 00 00 	movabs $0x8047a0,%rdi
  802d89:	00 00 00 
  802d8c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d91:	49 b8 9a 01 80 00 00 	movabs $0x80019a,%r8
  802d98:	00 00 00 
  802d9b:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802d9e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802da1:	be 02 00 00 00       	mov    $0x2,%esi
  802da6:	89 c7                	mov    %eax,%edi
  802da8:	48 b8 9f 1b 80 00 00 	movabs $0x801b9f,%rax
  802daf:	00 00 00 
  802db2:	ff d0                	callq  *%rax
  802db4:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802db7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802dbb:	79 30                	jns    802ded <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  802dbd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802dc0:	89 c1                	mov    %eax,%ecx
  802dc2:	48 ba c6 47 80 00 00 	movabs $0x8047c6,%rdx
  802dc9:	00 00 00 
  802dcc:	be 88 00 00 00       	mov    $0x88,%esi
  802dd1:	48 bf a0 47 80 00 00 	movabs $0x8047a0,%rdi
  802dd8:	00 00 00 
  802ddb:	b8 00 00 00 00       	mov    $0x0,%eax
  802de0:	49 b8 9a 01 80 00 00 	movabs $0x80019a,%r8
  802de7:	00 00 00 
  802dea:	41 ff d0             	callq  *%r8

	return child;
  802ded:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802df0:	c9                   	leaveq 
  802df1:	c3                   	retq   

0000000000802df2 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802df2:	55                   	push   %rbp
  802df3:	48 89 e5             	mov    %rsp,%rbp
  802df6:	41 55                	push   %r13
  802df8:	41 54                	push   %r12
  802dfa:	53                   	push   %rbx
  802dfb:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802e02:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  802e09:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  802e10:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  802e17:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  802e1e:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  802e25:	84 c0                	test   %al,%al
  802e27:	74 26                	je     802e4f <spawnl+0x5d>
  802e29:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  802e30:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  802e37:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  802e3b:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  802e3f:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  802e43:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  802e47:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  802e4b:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  802e4f:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802e56:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  802e5d:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  802e60:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  802e67:	00 00 00 
  802e6a:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  802e71:	00 00 00 
  802e74:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802e78:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  802e7f:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  802e86:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while (va_arg(vl, void *) != NULL)
  802e8d:	eb 07                	jmp    802e96 <spawnl+0xa4>
		argc++;
  802e8f:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  802e96:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802e9c:	83 f8 30             	cmp    $0x30,%eax
  802e9f:	73 23                	jae    802ec4 <spawnl+0xd2>
  802ea1:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  802ea8:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802eae:	89 c0                	mov    %eax,%eax
  802eb0:	48 01 d0             	add    %rdx,%rax
  802eb3:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  802eb9:	83 c2 08             	add    $0x8,%edx
  802ebc:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  802ec2:	eb 15                	jmp    802ed9 <spawnl+0xe7>
  802ec4:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  802ecb:	48 89 d0             	mov    %rdx,%rax
  802ece:	48 83 c2 08          	add    $0x8,%rdx
  802ed2:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  802ed9:	48 8b 00             	mov    (%rax),%rax
  802edc:	48 85 c0             	test   %rax,%rax
  802edf:	75 ae                	jne    802e8f <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802ee1:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802ee7:	83 c0 02             	add    $0x2,%eax
  802eea:	48 89 e2             	mov    %rsp,%rdx
  802eed:	48 89 d3             	mov    %rdx,%rbx
  802ef0:	48 63 d0             	movslq %eax,%rdx
  802ef3:	48 83 ea 01          	sub    $0x1,%rdx
  802ef7:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  802efe:	48 63 d0             	movslq %eax,%rdx
  802f01:	49 89 d4             	mov    %rdx,%r12
  802f04:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  802f0a:	48 63 d0             	movslq %eax,%rdx
  802f0d:	49 89 d2             	mov    %rdx,%r10
  802f10:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  802f16:	48 98                	cltq   
  802f18:	48 c1 e0 03          	shl    $0x3,%rax
  802f1c:	48 8d 50 07          	lea    0x7(%rax),%rdx
  802f20:	b8 10 00 00 00       	mov    $0x10,%eax
  802f25:	48 83 e8 01          	sub    $0x1,%rax
  802f29:	48 01 d0             	add    %rdx,%rax
  802f2c:	bf 10 00 00 00       	mov    $0x10,%edi
  802f31:	ba 00 00 00 00       	mov    $0x0,%edx
  802f36:	48 f7 f7             	div    %rdi
  802f39:	48 6b c0 10          	imul   $0x10,%rax,%rax
  802f3d:	48 29 c4             	sub    %rax,%rsp
  802f40:	48 89 e0             	mov    %rsp,%rax
  802f43:	48 83 c0 07          	add    $0x7,%rax
  802f47:	48 c1 e8 03          	shr    $0x3,%rax
  802f4b:	48 c1 e0 03          	shl    $0x3,%rax
  802f4f:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  802f56:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  802f5d:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  802f64:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  802f67:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802f6d:	8d 50 01             	lea    0x1(%rax),%edx
  802f70:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  802f77:	48 63 d2             	movslq %edx,%rdx
  802f7a:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  802f81:	00 

	va_start(vl, arg0);
  802f82:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  802f89:	00 00 00 
  802f8c:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  802f93:	00 00 00 
  802f96:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f9a:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  802fa1:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  802fa8:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for (i = 0; i < argc; i++)
  802faf:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  802fb6:	00 00 00 
  802fb9:	eb 63                	jmp    80301e <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  802fbb:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  802fc1:	8d 70 01             	lea    0x1(%rax),%esi
  802fc4:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802fca:	83 f8 30             	cmp    $0x30,%eax
  802fcd:	73 23                	jae    802ff2 <spawnl+0x200>
  802fcf:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  802fd6:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802fdc:	89 c0                	mov    %eax,%eax
  802fde:	48 01 d0             	add    %rdx,%rax
  802fe1:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  802fe7:	83 c2 08             	add    $0x8,%edx
  802fea:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  802ff0:	eb 15                	jmp    803007 <spawnl+0x215>
  802ff2:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  802ff9:	48 89 d0             	mov    %rdx,%rax
  802ffc:	48 83 c2 08          	add    $0x8,%rdx
  803000:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803007:	48 8b 08             	mov    (%rax),%rcx
  80300a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803011:	89 f2                	mov    %esi,%edx
  803013:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  803017:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  80301e:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803024:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  80302a:	77 8f                	ja     802fbb <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  80302c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803033:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  80303a:	48 89 d6             	mov    %rdx,%rsi
  80303d:	48 89 c7             	mov    %rax,%rdi
  803040:	48 b8 97 2a 80 00 00 	movabs $0x802a97,%rax
  803047:	00 00 00 
  80304a:	ff d0                	callq  *%rax
  80304c:	48 89 dc             	mov    %rbx,%rsp
}
  80304f:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803053:	5b                   	pop    %rbx
  803054:	41 5c                	pop    %r12
  803056:	41 5d                	pop    %r13
  803058:	5d                   	pop    %rbp
  803059:	c3                   	retq   

000000000080305a <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  80305a:	55                   	push   %rbp
  80305b:	48 89 e5             	mov    %rsp,%rbp
  80305e:	48 83 ec 50          	sub    $0x50,%rsp
  803062:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803065:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803069:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80306d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803074:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803075:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80307c:	eb 33                	jmp    8030b1 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  80307e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803081:	48 98                	cltq   
  803083:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80308a:	00 
  80308b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80308f:	48 01 d0             	add    %rdx,%rax
  803092:	48 8b 00             	mov    (%rax),%rax
  803095:	48 89 c7             	mov    %rax,%rdi
  803098:	48 b8 0f 11 80 00 00 	movabs $0x80110f,%rax
  80309f:	00 00 00 
  8030a2:	ff d0                	callq  *%rax
  8030a4:	83 c0 01             	add    $0x1,%eax
  8030a7:	48 98                	cltq   
  8030a9:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8030ad:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8030b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030b4:	48 98                	cltq   
  8030b6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8030bd:	00 
  8030be:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8030c2:	48 01 d0             	add    %rdx,%rax
  8030c5:	48 8b 00             	mov    (%rax),%rax
  8030c8:	48 85 c0             	test   %rax,%rax
  8030cb:	75 b1                	jne    80307e <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8030cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030d1:	48 f7 d8             	neg    %rax
  8030d4:	48 05 00 10 40 00    	add    $0x401000,%rax
  8030da:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8030de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030e2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8030e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030ea:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8030ee:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8030f1:	83 c2 01             	add    $0x1,%edx
  8030f4:	c1 e2 03             	shl    $0x3,%edx
  8030f7:	48 63 d2             	movslq %edx,%rdx
  8030fa:	48 f7 da             	neg    %rdx
  8030fd:	48 01 d0             	add    %rdx,%rax
  803100:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803104:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803108:	48 83 e8 10          	sub    $0x10,%rax
  80310c:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803112:	77 0a                	ja     80311e <init_stack+0xc4>
		return -E_NO_MEM;
  803114:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803119:	e9 e3 01 00 00       	jmpq   803301 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80311e:	ba 07 00 00 00       	mov    $0x7,%edx
  803123:	be 00 00 40 00       	mov    $0x400000,%esi
  803128:	bf 00 00 00 00       	mov    $0x0,%edi
  80312d:	48 b8 aa 1a 80 00 00 	movabs $0x801aaa,%rax
  803134:	00 00 00 
  803137:	ff d0                	callq  *%rax
  803139:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80313c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803140:	79 08                	jns    80314a <init_stack+0xf0>
		return r;
  803142:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803145:	e9 b7 01 00 00       	jmpq   803301 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80314a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803151:	e9 8a 00 00 00       	jmpq   8031e0 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803156:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803159:	48 98                	cltq   
  80315b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803162:	00 
  803163:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803167:	48 01 c2             	add    %rax,%rdx
  80316a:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80316f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803173:	48 01 c8             	add    %rcx,%rax
  803176:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80317c:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  80317f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803182:	48 98                	cltq   
  803184:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80318b:	00 
  80318c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803190:	48 01 d0             	add    %rdx,%rax
  803193:	48 8b 10             	mov    (%rax),%rdx
  803196:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80319a:	48 89 d6             	mov    %rdx,%rsi
  80319d:	48 89 c7             	mov    %rax,%rdi
  8031a0:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  8031a7:	00 00 00 
  8031aa:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8031ac:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031af:	48 98                	cltq   
  8031b1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8031b8:	00 
  8031b9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8031bd:	48 01 d0             	add    %rdx,%rax
  8031c0:	48 8b 00             	mov    (%rax),%rax
  8031c3:	48 89 c7             	mov    %rax,%rdi
  8031c6:	48 b8 0f 11 80 00 00 	movabs $0x80110f,%rax
  8031cd:	00 00 00 
  8031d0:	ff d0                	callq  *%rax
  8031d2:	48 98                	cltq   
  8031d4:	48 83 c0 01          	add    $0x1,%rax
  8031d8:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8031dc:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8031e0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031e3:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8031e6:	0f 8c 6a ff ff ff    	jl     803156 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8031ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031ef:	48 98                	cltq   
  8031f1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8031f8:	00 
  8031f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031fd:	48 01 d0             	add    %rdx,%rax
  803200:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803207:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  80320e:	00 
  80320f:	74 35                	je     803246 <init_stack+0x1ec>
  803211:	48 b9 e0 47 80 00 00 	movabs $0x8047e0,%rcx
  803218:	00 00 00 
  80321b:	48 ba 06 48 80 00 00 	movabs $0x804806,%rdx
  803222:	00 00 00 
  803225:	be f1 00 00 00       	mov    $0xf1,%esi
  80322a:	48 bf a0 47 80 00 00 	movabs $0x8047a0,%rdi
  803231:	00 00 00 
  803234:	b8 00 00 00 00       	mov    $0x0,%eax
  803239:	49 b8 9a 01 80 00 00 	movabs $0x80019a,%r8
  803240:	00 00 00 
  803243:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803246:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80324a:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  80324e:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803253:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803257:	48 01 c8             	add    %rcx,%rax
  80325a:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803260:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803263:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803267:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  80326b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80326e:	48 98                	cltq   
  803270:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803273:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803278:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80327c:	48 01 d0             	add    %rdx,%rax
  80327f:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803285:	48 89 c2             	mov    %rax,%rdx
  803288:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80328c:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80328f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803292:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803298:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80329d:	89 c2                	mov    %eax,%edx
  80329f:	be 00 00 40 00       	mov    $0x400000,%esi
  8032a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8032a9:	48 b8 fa 1a 80 00 00 	movabs $0x801afa,%rax
  8032b0:	00 00 00 
  8032b3:	ff d0                	callq  *%rax
  8032b5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032bc:	79 02                	jns    8032c0 <init_stack+0x266>
		goto error;
  8032be:	eb 28                	jmp    8032e8 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8032c0:	be 00 00 40 00       	mov    $0x400000,%esi
  8032c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ca:	48 b8 55 1b 80 00 00 	movabs $0x801b55,%rax
  8032d1:	00 00 00 
  8032d4:	ff d0                	callq  *%rax
  8032d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032dd:	79 02                	jns    8032e1 <init_stack+0x287>
		goto error;
  8032df:	eb 07                	jmp    8032e8 <init_stack+0x28e>

	return 0;
  8032e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e6:	eb 19                	jmp    803301 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  8032e8:	be 00 00 40 00       	mov    $0x400000,%esi
  8032ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8032f2:	48 b8 55 1b 80 00 00 	movabs $0x801b55,%rax
  8032f9:	00 00 00 
  8032fc:	ff d0                	callq  *%rax
	return r;
  8032fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803301:	c9                   	leaveq 
  803302:	c3                   	retq   

0000000000803303 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  803303:	55                   	push   %rbp
  803304:	48 89 e5             	mov    %rsp,%rbp
  803307:	48 83 ec 50          	sub    $0x50,%rsp
  80330b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80330e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803312:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803316:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803319:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80331d:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803321:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803325:	25 ff 0f 00 00       	and    $0xfff,%eax
  80332a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80332d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803331:	74 21                	je     803354 <map_segment+0x51>
		va -= i;
  803333:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803336:	48 98                	cltq   
  803338:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  80333c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80333f:	48 98                	cltq   
  803341:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803345:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803348:	48 98                	cltq   
  80334a:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  80334e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803351:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803354:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80335b:	e9 79 01 00 00       	jmpq   8034d9 <map_segment+0x1d6>
		if (i >= filesz) {
  803360:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803363:	48 98                	cltq   
  803365:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803369:	72 3c                	jb     8033a7 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80336b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80336e:	48 63 d0             	movslq %eax,%rdx
  803371:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803375:	48 01 d0             	add    %rdx,%rax
  803378:	48 89 c1             	mov    %rax,%rcx
  80337b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80337e:	8b 55 10             	mov    0x10(%rbp),%edx
  803381:	48 89 ce             	mov    %rcx,%rsi
  803384:	89 c7                	mov    %eax,%edi
  803386:	48 b8 aa 1a 80 00 00 	movabs $0x801aaa,%rax
  80338d:	00 00 00 
  803390:	ff d0                	callq  *%rax
  803392:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803395:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803399:	0f 89 33 01 00 00    	jns    8034d2 <map_segment+0x1cf>
				return r;
  80339f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033a2:	e9 46 01 00 00       	jmpq   8034ed <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8033a7:	ba 07 00 00 00       	mov    $0x7,%edx
  8033ac:	be 00 00 40 00       	mov    $0x400000,%esi
  8033b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8033b6:	48 b8 aa 1a 80 00 00 	movabs $0x801aaa,%rax
  8033bd:	00 00 00 
  8033c0:	ff d0                	callq  *%rax
  8033c2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8033c5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8033c9:	79 08                	jns    8033d3 <map_segment+0xd0>
				return r;
  8033cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033ce:	e9 1a 01 00 00       	jmpq   8034ed <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8033d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d6:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8033d9:	01 c2                	add    %eax,%edx
  8033db:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8033de:	89 d6                	mov    %edx,%esi
  8033e0:	89 c7                	mov    %eax,%edi
  8033e2:	48 b8 4d 24 80 00 00 	movabs $0x80244d,%rax
  8033e9:	00 00 00 
  8033ec:	ff d0                	callq  *%rax
  8033ee:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8033f1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8033f5:	79 08                	jns    8033ff <map_segment+0xfc>
				return r;
  8033f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033fa:	e9 ee 00 00 00       	jmpq   8034ed <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8033ff:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803406:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803409:	48 98                	cltq   
  80340b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80340f:	48 29 c2             	sub    %rax,%rdx
  803412:	48 89 d0             	mov    %rdx,%rax
  803415:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803419:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80341c:	48 63 d0             	movslq %eax,%rdx
  80341f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803423:	48 39 c2             	cmp    %rax,%rdx
  803426:	48 0f 47 d0          	cmova  %rax,%rdx
  80342a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80342d:	be 00 00 40 00       	mov    $0x400000,%esi
  803432:	89 c7                	mov    %eax,%edi
  803434:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  80343b:	00 00 00 
  80343e:	ff d0                	callq  *%rax
  803440:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803443:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803447:	79 08                	jns    803451 <map_segment+0x14e>
				return r;
  803449:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80344c:	e9 9c 00 00 00       	jmpq   8034ed <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803451:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803454:	48 63 d0             	movslq %eax,%rdx
  803457:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80345b:	48 01 d0             	add    %rdx,%rax
  80345e:	48 89 c2             	mov    %rax,%rdx
  803461:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803464:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803468:	48 89 d1             	mov    %rdx,%rcx
  80346b:	89 c2                	mov    %eax,%edx
  80346d:	be 00 00 40 00       	mov    $0x400000,%esi
  803472:	bf 00 00 00 00       	mov    $0x0,%edi
  803477:	48 b8 fa 1a 80 00 00 	movabs $0x801afa,%rax
  80347e:	00 00 00 
  803481:	ff d0                	callq  *%rax
  803483:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803486:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80348a:	79 30                	jns    8034bc <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  80348c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80348f:	89 c1                	mov    %eax,%ecx
  803491:	48 ba 1b 48 80 00 00 	movabs $0x80481b,%rdx
  803498:	00 00 00 
  80349b:	be 24 01 00 00       	mov    $0x124,%esi
  8034a0:	48 bf a0 47 80 00 00 	movabs $0x8047a0,%rdi
  8034a7:	00 00 00 
  8034aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8034af:	49 b8 9a 01 80 00 00 	movabs $0x80019a,%r8
  8034b6:	00 00 00 
  8034b9:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8034bc:	be 00 00 40 00       	mov    $0x400000,%esi
  8034c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8034c6:	48 b8 55 1b 80 00 00 	movabs $0x801b55,%rax
  8034cd:	00 00 00 
  8034d0:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8034d2:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8034d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034dc:	48 98                	cltq   
  8034de:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8034e2:	0f 82 78 fe ff ff    	jb     803360 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8034e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034ed:	c9                   	leaveq 
  8034ee:	c3                   	retq   

00000000008034ef <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8034ef:	55                   	push   %rbp
  8034f0:	48 89 e5             	mov    %rsp,%rbp
  8034f3:	48 83 ec 50          	sub    $0x50,%rsp
  8034f7:	89 7d bc             	mov    %edi,-0x44(%rbp)
	// LAB 5: Your code here.
	// note: just copied and modified from lib/fork.c, function envid_t fork(void)
	void *addr;
	int r;
	pte_t i, j, k, l, ptx = 0;
  8034fa:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803501:	00 

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  803502:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803509:	00 
  80350a:	e9 62 01 00 00       	jmpq   803671 <copy_shared_pages+0x182>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  80350f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803513:	48 c1 e8 1b          	shr    $0x1b,%rax
  803517:	48 89 c2             	mov    %rax,%rdx
  80351a:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803521:	01 00 00 
  803524:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803528:	83 e0 01             	and    $0x1,%eax
  80352b:	48 85 c0             	test   %rax,%rax
  80352e:	75 0d                	jne    80353d <copy_shared_pages+0x4e>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  803530:	48 81 45 d8 00 00 00 	addq   $0x8000000,-0x28(%rbp)
  803537:	08 
			continue;
  803538:	e9 2f 01 00 00       	jmpq   80366c <copy_shared_pages+0x17d>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  80353d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803544:	00 
  803545:	e9 14 01 00 00       	jmpq   80365e <copy_shared_pages+0x16f>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  80354a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80354e:	48 c1 e8 12          	shr    $0x12,%rax
  803552:	48 89 c2             	mov    %rax,%rdx
  803555:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80355c:	01 00 00 
  80355f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803563:	83 e0 01             	and    $0x1,%eax
  803566:	48 85 c0             	test   %rax,%rax
  803569:	75 0d                	jne    803578 <copy_shared_pages+0x89>
				ptx += NPDENTRIES * NPTENTRIES;
  80356b:	48 81 45 d8 00 00 04 	addq   $0x40000,-0x28(%rbp)
  803572:	00 
				continue;
  803573:	e9 e1 00 00 00       	jmpq   803659 <copy_shared_pages+0x16a>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  803578:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80357f:	00 
  803580:	e9 c6 00 00 00       	jmpq   80364b <copy_shared_pages+0x15c>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  803585:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803589:	48 c1 e8 09          	shr    $0x9,%rax
  80358d:	48 89 c2             	mov    %rax,%rdx
  803590:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803597:	01 00 00 
  80359a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80359e:	83 e0 01             	and    $0x1,%eax
  8035a1:	48 85 c0             	test   %rax,%rax
  8035a4:	75 0d                	jne    8035b3 <copy_shared_pages+0xc4>
					ptx += NPTENTRIES;
  8035a6:	48 81 45 d8 00 02 00 	addq   $0x200,-0x28(%rbp)
  8035ad:	00 
					continue;
  8035ae:	e9 93 00 00 00       	jmpq   803646 <copy_shared_pages+0x157>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  8035b3:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8035ba:	00 
  8035bb:	eb 7b                	jmp    803638 <copy_shared_pages+0x149>
					if ((uvpt[ptx] & PTE_SHARE) != 0) {
  8035bd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035c4:	01 00 00 
  8035c7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8035cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035cf:	25 00 04 00 00       	and    $0x400,%eax
  8035d4:	48 85 c0             	test   %rax,%rax
  8035d7:	74 55                	je     80362e <copy_shared_pages+0x13f>
						addr = (void *)(ptx * PGSIZE);
  8035d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035dd:	48 c1 e0 0c          	shl    $0xc,%rax
  8035e1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
						if ((r = sys_page_map(0, addr, child, addr, uvpt[ptx] & PTE_SYSCALL)) < 0)
  8035e5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035ec:	01 00 00 
  8035ef:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8035f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8035fc:	89 c6                	mov    %eax,%esi
  8035fe:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803602:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803605:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803609:	41 89 f0             	mov    %esi,%r8d
  80360c:	48 89 c6             	mov    %rax,%rsi
  80360f:	bf 00 00 00 00       	mov    $0x0,%edi
  803614:	48 b8 fa 1a 80 00 00 	movabs $0x801afa,%rax
  80361b:	00 00 00 
  80361e:	ff d0                	callq  *%rax
  803620:	89 45 cc             	mov    %eax,-0x34(%rbp)
  803623:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803627:	79 05                	jns    80362e <copy_shared_pages+0x13f>
							return r;
  803629:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80362c:	eb 53                	jmp    803681 <copy_shared_pages+0x192>
					}
					ptx++;
  80362e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  803633:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  803638:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  80363f:	00 
  803640:	0f 86 77 ff ff ff    	jbe    8035bd <copy_shared_pages+0xce>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  803646:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80364b:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  803652:	00 
  803653:	0f 86 2c ff ff ff    	jbe    803585 <copy_shared_pages+0x96>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  803659:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  80365e:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  803665:	00 
  803666:	0f 86 de fe ff ff    	jbe    80354a <copy_shared_pages+0x5b>
	int r;
	pte_t i, j, k, l, ptx = 0;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  80366c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803671:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803676:	0f 84 93 fe ff ff    	je     80350f <copy_shared_pages+0x20>
				}
			}
		}
	}

	return 0;
  80367c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803681:	c9                   	leaveq 
  803682:	c3                   	retq   

0000000000803683 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803683:	55                   	push   %rbp
  803684:	48 89 e5             	mov    %rsp,%rbp
  803687:	53                   	push   %rbx
  803688:	48 83 ec 38          	sub    $0x38,%rsp
  80368c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803690:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803694:	48 89 c7             	mov    %rax,%rdi
  803697:	48 b8 65 1d 80 00 00 	movabs $0x801d65,%rax
  80369e:	00 00 00 
  8036a1:	ff d0                	callq  *%rax
  8036a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036aa:	0f 88 bf 01 00 00    	js     80386f <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036b4:	ba 07 04 00 00       	mov    $0x407,%edx
  8036b9:	48 89 c6             	mov    %rax,%rsi
  8036bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8036c1:	48 b8 aa 1a 80 00 00 	movabs $0x801aaa,%rax
  8036c8:	00 00 00 
  8036cb:	ff d0                	callq  *%rax
  8036cd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036d4:	0f 88 95 01 00 00    	js     80386f <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8036da:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8036de:	48 89 c7             	mov    %rax,%rdi
  8036e1:	48 b8 65 1d 80 00 00 	movabs $0x801d65,%rax
  8036e8:	00 00 00 
  8036eb:	ff d0                	callq  *%rax
  8036ed:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036f4:	0f 88 5d 01 00 00    	js     803857 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036fe:	ba 07 04 00 00       	mov    $0x407,%edx
  803703:	48 89 c6             	mov    %rax,%rsi
  803706:	bf 00 00 00 00       	mov    $0x0,%edi
  80370b:	48 b8 aa 1a 80 00 00 	movabs $0x801aaa,%rax
  803712:	00 00 00 
  803715:	ff d0                	callq  *%rax
  803717:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80371a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80371e:	0f 88 33 01 00 00    	js     803857 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803724:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803728:	48 89 c7             	mov    %rax,%rdi
  80372b:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  803732:	00 00 00 
  803735:	ff d0                	callq  *%rax
  803737:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80373b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80373f:	ba 07 04 00 00       	mov    $0x407,%edx
  803744:	48 89 c6             	mov    %rax,%rsi
  803747:	bf 00 00 00 00       	mov    $0x0,%edi
  80374c:	48 b8 aa 1a 80 00 00 	movabs $0x801aaa,%rax
  803753:	00 00 00 
  803756:	ff d0                	callq  *%rax
  803758:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80375b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80375f:	79 05                	jns    803766 <pipe+0xe3>
		goto err2;
  803761:	e9 d9 00 00 00       	jmpq   80383f <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803766:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80376a:	48 89 c7             	mov    %rax,%rdi
  80376d:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  803774:	00 00 00 
  803777:	ff d0                	callq  *%rax
  803779:	48 89 c2             	mov    %rax,%rdx
  80377c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803780:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803786:	48 89 d1             	mov    %rdx,%rcx
  803789:	ba 00 00 00 00       	mov    $0x0,%edx
  80378e:	48 89 c6             	mov    %rax,%rsi
  803791:	bf 00 00 00 00       	mov    $0x0,%edi
  803796:	48 b8 fa 1a 80 00 00 	movabs $0x801afa,%rax
  80379d:	00 00 00 
  8037a0:	ff d0                	callq  *%rax
  8037a2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037a9:	79 1b                	jns    8037c6 <pipe+0x143>
		goto err3;
  8037ab:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8037ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037b0:	48 89 c6             	mov    %rax,%rsi
  8037b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8037b8:	48 b8 55 1b 80 00 00 	movabs $0x801b55,%rax
  8037bf:	00 00 00 
  8037c2:	ff d0                	callq  *%rax
  8037c4:	eb 79                	jmp    80383f <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8037c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037ca:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8037d1:	00 00 00 
  8037d4:	8b 12                	mov    (%rdx),%edx
  8037d6:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8037d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037dc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8037e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037e7:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8037ee:	00 00 00 
  8037f1:	8b 12                	mov    (%rdx),%edx
  8037f3:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8037f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037f9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803800:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803804:	48 89 c7             	mov    %rax,%rdi
  803807:	48 b8 17 1d 80 00 00 	movabs $0x801d17,%rax
  80380e:	00 00 00 
  803811:	ff d0                	callq  *%rax
  803813:	89 c2                	mov    %eax,%edx
  803815:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803819:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80381b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80381f:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803823:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803827:	48 89 c7             	mov    %rax,%rdi
  80382a:	48 b8 17 1d 80 00 00 	movabs $0x801d17,%rax
  803831:	00 00 00 
  803834:	ff d0                	callq  *%rax
  803836:	89 03                	mov    %eax,(%rbx)
	return 0;
  803838:	b8 00 00 00 00       	mov    $0x0,%eax
  80383d:	eb 33                	jmp    803872 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  80383f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803843:	48 89 c6             	mov    %rax,%rsi
  803846:	bf 00 00 00 00       	mov    $0x0,%edi
  80384b:	48 b8 55 1b 80 00 00 	movabs $0x801b55,%rax
  803852:	00 00 00 
  803855:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803857:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80385b:	48 89 c6             	mov    %rax,%rsi
  80385e:	bf 00 00 00 00       	mov    $0x0,%edi
  803863:	48 b8 55 1b 80 00 00 	movabs $0x801b55,%rax
  80386a:	00 00 00 
  80386d:	ff d0                	callq  *%rax
    err:
	return r;
  80386f:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803872:	48 83 c4 38          	add    $0x38,%rsp
  803876:	5b                   	pop    %rbx
  803877:	5d                   	pop    %rbp
  803878:	c3                   	retq   

0000000000803879 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803879:	55                   	push   %rbp
  80387a:	48 89 e5             	mov    %rsp,%rbp
  80387d:	53                   	push   %rbx
  80387e:	48 83 ec 28          	sub    $0x28,%rsp
  803882:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803886:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80388a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803891:	00 00 00 
  803894:	48 8b 00             	mov    (%rax),%rax
  803897:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80389d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8038a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038a4:	48 89 c7             	mov    %rax,%rdi
  8038a7:	48 b8 e2 40 80 00 00 	movabs $0x8040e2,%rax
  8038ae:	00 00 00 
  8038b1:	ff d0                	callq  *%rax
  8038b3:	89 c3                	mov    %eax,%ebx
  8038b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038b9:	48 89 c7             	mov    %rax,%rdi
  8038bc:	48 b8 e2 40 80 00 00 	movabs $0x8040e2,%rax
  8038c3:	00 00 00 
  8038c6:	ff d0                	callq  *%rax
  8038c8:	39 c3                	cmp    %eax,%ebx
  8038ca:	0f 94 c0             	sete   %al
  8038cd:	0f b6 c0             	movzbl %al,%eax
  8038d0:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8038d3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038da:	00 00 00 
  8038dd:	48 8b 00             	mov    (%rax),%rax
  8038e0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038e6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8038e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038ec:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8038ef:	75 05                	jne    8038f6 <_pipeisclosed+0x7d>
			return ret;
  8038f1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8038f4:	eb 4f                	jmp    803945 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8038f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038f9:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8038fc:	74 42                	je     803940 <_pipeisclosed+0xc7>
  8038fe:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803902:	75 3c                	jne    803940 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803904:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80390b:	00 00 00 
  80390e:	48 8b 00             	mov    (%rax),%rax
  803911:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803917:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80391a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80391d:	89 c6                	mov    %eax,%esi
  80391f:	48 bf 3d 48 80 00 00 	movabs $0x80483d,%rdi
  803926:	00 00 00 
  803929:	b8 00 00 00 00       	mov    $0x0,%eax
  80392e:	49 b8 d3 03 80 00 00 	movabs $0x8003d3,%r8
  803935:	00 00 00 
  803938:	41 ff d0             	callq  *%r8
	}
  80393b:	e9 4a ff ff ff       	jmpq   80388a <_pipeisclosed+0x11>
  803940:	e9 45 ff ff ff       	jmpq   80388a <_pipeisclosed+0x11>
}
  803945:	48 83 c4 28          	add    $0x28,%rsp
  803949:	5b                   	pop    %rbx
  80394a:	5d                   	pop    %rbp
  80394b:	c3                   	retq   

000000000080394c <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80394c:	55                   	push   %rbp
  80394d:	48 89 e5             	mov    %rsp,%rbp
  803950:	48 83 ec 30          	sub    $0x30,%rsp
  803954:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803957:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80395b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80395e:	48 89 d6             	mov    %rdx,%rsi
  803961:	89 c7                	mov    %eax,%edi
  803963:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  80396a:	00 00 00 
  80396d:	ff d0                	callq  *%rax
  80396f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803972:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803976:	79 05                	jns    80397d <pipeisclosed+0x31>
		return r;
  803978:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80397b:	eb 31                	jmp    8039ae <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80397d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803981:	48 89 c7             	mov    %rax,%rdi
  803984:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  80398b:	00 00 00 
  80398e:	ff d0                	callq  *%rax
  803990:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803994:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803998:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80399c:	48 89 d6             	mov    %rdx,%rsi
  80399f:	48 89 c7             	mov    %rax,%rdi
  8039a2:	48 b8 79 38 80 00 00 	movabs $0x803879,%rax
  8039a9:	00 00 00 
  8039ac:	ff d0                	callq  *%rax
}
  8039ae:	c9                   	leaveq 
  8039af:	c3                   	retq   

00000000008039b0 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039b0:	55                   	push   %rbp
  8039b1:	48 89 e5             	mov    %rsp,%rbp
  8039b4:	48 83 ec 40          	sub    $0x40,%rsp
  8039b8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039bc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039c0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8039c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039c8:	48 89 c7             	mov    %rax,%rdi
  8039cb:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  8039d2:	00 00 00 
  8039d5:	ff d0                	callq  *%rax
  8039d7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039df:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039e3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039ea:	00 
  8039eb:	e9 92 00 00 00       	jmpq   803a82 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8039f0:	eb 41                	jmp    803a33 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8039f2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8039f7:	74 09                	je     803a02 <devpipe_read+0x52>
				return i;
  8039f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039fd:	e9 92 00 00 00       	jmpq   803a94 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803a02:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a0a:	48 89 d6             	mov    %rdx,%rsi
  803a0d:	48 89 c7             	mov    %rax,%rdi
  803a10:	48 b8 79 38 80 00 00 	movabs $0x803879,%rax
  803a17:	00 00 00 
  803a1a:	ff d0                	callq  *%rax
  803a1c:	85 c0                	test   %eax,%eax
  803a1e:	74 07                	je     803a27 <devpipe_read+0x77>
				return 0;
  803a20:	b8 00 00 00 00       	mov    $0x0,%eax
  803a25:	eb 6d                	jmp    803a94 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a27:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  803a2e:	00 00 00 
  803a31:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803a33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a37:	8b 10                	mov    (%rax),%edx
  803a39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a3d:	8b 40 04             	mov    0x4(%rax),%eax
  803a40:	39 c2                	cmp    %eax,%edx
  803a42:	74 ae                	je     8039f2 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a4c:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803a50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a54:	8b 00                	mov    (%rax),%eax
  803a56:	99                   	cltd   
  803a57:	c1 ea 1b             	shr    $0x1b,%edx
  803a5a:	01 d0                	add    %edx,%eax
  803a5c:	83 e0 1f             	and    $0x1f,%eax
  803a5f:	29 d0                	sub    %edx,%eax
  803a61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a65:	48 98                	cltq   
  803a67:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803a6c:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803a6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a72:	8b 00                	mov    (%rax),%eax
  803a74:	8d 50 01             	lea    0x1(%rax),%edx
  803a77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a7b:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a7d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a86:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a8a:	0f 82 60 ff ff ff    	jb     8039f0 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803a90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a94:	c9                   	leaveq 
  803a95:	c3                   	retq   

0000000000803a96 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a96:	55                   	push   %rbp
  803a97:	48 89 e5             	mov    %rsp,%rbp
  803a9a:	48 83 ec 40          	sub    $0x40,%rsp
  803a9e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803aa2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803aa6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803aaa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aae:	48 89 c7             	mov    %rax,%rdi
  803ab1:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  803ab8:	00 00 00 
  803abb:	ff d0                	callq  *%rax
  803abd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ac1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ac5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ac9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ad0:	00 
  803ad1:	e9 8e 00 00 00       	jmpq   803b64 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ad6:	eb 31                	jmp    803b09 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803ad8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803adc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ae0:	48 89 d6             	mov    %rdx,%rsi
  803ae3:	48 89 c7             	mov    %rax,%rdi
  803ae6:	48 b8 79 38 80 00 00 	movabs $0x803879,%rax
  803aed:	00 00 00 
  803af0:	ff d0                	callq  *%rax
  803af2:	85 c0                	test   %eax,%eax
  803af4:	74 07                	je     803afd <devpipe_write+0x67>
				return 0;
  803af6:	b8 00 00 00 00       	mov    $0x0,%eax
  803afb:	eb 79                	jmp    803b76 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803afd:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  803b04:	00 00 00 
  803b07:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b0d:	8b 40 04             	mov    0x4(%rax),%eax
  803b10:	48 63 d0             	movslq %eax,%rdx
  803b13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b17:	8b 00                	mov    (%rax),%eax
  803b19:	48 98                	cltq   
  803b1b:	48 83 c0 20          	add    $0x20,%rax
  803b1f:	48 39 c2             	cmp    %rax,%rdx
  803b22:	73 b4                	jae    803ad8 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b28:	8b 40 04             	mov    0x4(%rax),%eax
  803b2b:	99                   	cltd   
  803b2c:	c1 ea 1b             	shr    $0x1b,%edx
  803b2f:	01 d0                	add    %edx,%eax
  803b31:	83 e0 1f             	and    $0x1f,%eax
  803b34:	29 d0                	sub    %edx,%eax
  803b36:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b3a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803b3e:	48 01 ca             	add    %rcx,%rdx
  803b41:	0f b6 0a             	movzbl (%rdx),%ecx
  803b44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b48:	48 98                	cltq   
  803b4a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803b4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b52:	8b 40 04             	mov    0x4(%rax),%eax
  803b55:	8d 50 01             	lea    0x1(%rax),%edx
  803b58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b5c:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b5f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b68:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b6c:	0f 82 64 ff ff ff    	jb     803ad6 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803b72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b76:	c9                   	leaveq 
  803b77:	c3                   	retq   

0000000000803b78 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803b78:	55                   	push   %rbp
  803b79:	48 89 e5             	mov    %rsp,%rbp
  803b7c:	48 83 ec 20          	sub    $0x20,%rsp
  803b80:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b8c:	48 89 c7             	mov    %rax,%rdi
  803b8f:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  803b96:	00 00 00 
  803b99:	ff d0                	callq  *%rax
  803b9b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ba3:	48 be 50 48 80 00 00 	movabs $0x804850,%rsi
  803baa:	00 00 00 
  803bad:	48 89 c7             	mov    %rax,%rdi
  803bb0:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  803bb7:	00 00 00 
  803bba:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803bbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bc0:	8b 50 04             	mov    0x4(%rax),%edx
  803bc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bc7:	8b 00                	mov    (%rax),%eax
  803bc9:	29 c2                	sub    %eax,%edx
  803bcb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bcf:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803bd5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bd9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803be0:	00 00 00 
	stat->st_dev = &devpipe;
  803be3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803be7:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803bee:	00 00 00 
  803bf1:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803bf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bfd:	c9                   	leaveq 
  803bfe:	c3                   	retq   

0000000000803bff <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803bff:	55                   	push   %rbp
  803c00:	48 89 e5             	mov    %rsp,%rbp
  803c03:	48 83 ec 10          	sub    $0x10,%rsp
  803c07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803c0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c0f:	48 89 c6             	mov    %rax,%rsi
  803c12:	bf 00 00 00 00       	mov    $0x0,%edi
  803c17:	48 b8 55 1b 80 00 00 	movabs $0x801b55,%rax
  803c1e:	00 00 00 
  803c21:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803c23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c27:	48 89 c7             	mov    %rax,%rdi
  803c2a:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  803c31:	00 00 00 
  803c34:	ff d0                	callq  *%rax
  803c36:	48 89 c6             	mov    %rax,%rsi
  803c39:	bf 00 00 00 00       	mov    $0x0,%edi
  803c3e:	48 b8 55 1b 80 00 00 	movabs $0x801b55,%rax
  803c45:	00 00 00 
  803c48:	ff d0                	callq  *%rax
}
  803c4a:	c9                   	leaveq 
  803c4b:	c3                   	retq   

0000000000803c4c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803c4c:	55                   	push   %rbp
  803c4d:	48 89 e5             	mov    %rsp,%rbp
  803c50:	48 83 ec 20          	sub    $0x20,%rsp
  803c54:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803c57:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c5a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803c5d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803c61:	be 01 00 00 00       	mov    $0x1,%esi
  803c66:	48 89 c7             	mov    %rax,%rdi
  803c69:	48 b8 62 19 80 00 00 	movabs $0x801962,%rax
  803c70:	00 00 00 
  803c73:	ff d0                	callq  *%rax
}
  803c75:	c9                   	leaveq 
  803c76:	c3                   	retq   

0000000000803c77 <getchar>:

int
getchar(void)
{
  803c77:	55                   	push   %rbp
  803c78:	48 89 e5             	mov    %rsp,%rbp
  803c7b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c7f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c83:	ba 01 00 00 00       	mov    $0x1,%edx
  803c88:	48 89 c6             	mov    %rax,%rsi
  803c8b:	bf 00 00 00 00       	mov    $0x0,%edi
  803c90:	48 b8 2f 22 80 00 00 	movabs $0x80222f,%rax
  803c97:	00 00 00 
  803c9a:	ff d0                	callq  *%rax
  803c9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca3:	79 05                	jns    803caa <getchar+0x33>
		return r;
  803ca5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ca8:	eb 14                	jmp    803cbe <getchar+0x47>
	if (r < 1)
  803caa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cae:	7f 07                	jg     803cb7 <getchar+0x40>
		return -E_EOF;
  803cb0:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803cb5:	eb 07                	jmp    803cbe <getchar+0x47>
	return c;
  803cb7:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803cbb:	0f b6 c0             	movzbl %al,%eax
}
  803cbe:	c9                   	leaveq 
  803cbf:	c3                   	retq   

0000000000803cc0 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803cc0:	55                   	push   %rbp
  803cc1:	48 89 e5             	mov    %rsp,%rbp
  803cc4:	48 83 ec 20          	sub    $0x20,%rsp
  803cc8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ccb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ccf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cd2:	48 89 d6             	mov    %rdx,%rsi
  803cd5:	89 c7                	mov    %eax,%edi
  803cd7:	48 b8 fd 1d 80 00 00 	movabs $0x801dfd,%rax
  803cde:	00 00 00 
  803ce1:	ff d0                	callq  *%rax
  803ce3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ce6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cea:	79 05                	jns    803cf1 <iscons+0x31>
		return r;
  803cec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cef:	eb 1a                	jmp    803d0b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803cf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf5:	8b 10                	mov    (%rax),%edx
  803cf7:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803cfe:	00 00 00 
  803d01:	8b 00                	mov    (%rax),%eax
  803d03:	39 c2                	cmp    %eax,%edx
  803d05:	0f 94 c0             	sete   %al
  803d08:	0f b6 c0             	movzbl %al,%eax
}
  803d0b:	c9                   	leaveq 
  803d0c:	c3                   	retq   

0000000000803d0d <opencons>:

int
opencons(void)
{
  803d0d:	55                   	push   %rbp
  803d0e:	48 89 e5             	mov    %rsp,%rbp
  803d11:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803d15:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803d19:	48 89 c7             	mov    %rax,%rdi
  803d1c:	48 b8 65 1d 80 00 00 	movabs $0x801d65,%rax
  803d23:	00 00 00 
  803d26:	ff d0                	callq  *%rax
  803d28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d2f:	79 05                	jns    803d36 <opencons+0x29>
		return r;
  803d31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d34:	eb 5b                	jmp    803d91 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803d36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d3a:	ba 07 04 00 00       	mov    $0x407,%edx
  803d3f:	48 89 c6             	mov    %rax,%rsi
  803d42:	bf 00 00 00 00       	mov    $0x0,%edi
  803d47:	48 b8 aa 1a 80 00 00 	movabs $0x801aaa,%rax
  803d4e:	00 00 00 
  803d51:	ff d0                	callq  *%rax
  803d53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d5a:	79 05                	jns    803d61 <opencons+0x54>
		return r;
  803d5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5f:	eb 30                	jmp    803d91 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803d61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d65:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803d6c:	00 00 00 
  803d6f:	8b 12                	mov    (%rdx),%edx
  803d71:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d77:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d82:	48 89 c7             	mov    %rax,%rdi
  803d85:	48 b8 17 1d 80 00 00 	movabs $0x801d17,%rax
  803d8c:	00 00 00 
  803d8f:	ff d0                	callq  *%rax
}
  803d91:	c9                   	leaveq 
  803d92:	c3                   	retq   

0000000000803d93 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d93:	55                   	push   %rbp
  803d94:	48 89 e5             	mov    %rsp,%rbp
  803d97:	48 83 ec 30          	sub    $0x30,%rsp
  803d9b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d9f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803da3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803da7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803dac:	75 07                	jne    803db5 <devcons_read+0x22>
		return 0;
  803dae:	b8 00 00 00 00       	mov    $0x0,%eax
  803db3:	eb 4b                	jmp    803e00 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803db5:	eb 0c                	jmp    803dc3 <devcons_read+0x30>
		sys_yield();
  803db7:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  803dbe:	00 00 00 
  803dc1:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803dc3:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  803dca:	00 00 00 
  803dcd:	ff d0                	callq  *%rax
  803dcf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dd6:	74 df                	je     803db7 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803dd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ddc:	79 05                	jns    803de3 <devcons_read+0x50>
		return c;
  803dde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de1:	eb 1d                	jmp    803e00 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803de3:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803de7:	75 07                	jne    803df0 <devcons_read+0x5d>
		return 0;
  803de9:	b8 00 00 00 00       	mov    $0x0,%eax
  803dee:	eb 10                	jmp    803e00 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803df0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803df3:	89 c2                	mov    %eax,%edx
  803df5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803df9:	88 10                	mov    %dl,(%rax)
	return 1;
  803dfb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803e00:	c9                   	leaveq 
  803e01:	c3                   	retq   

0000000000803e02 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e02:	55                   	push   %rbp
  803e03:	48 89 e5             	mov    %rsp,%rbp
  803e06:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803e0d:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803e14:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803e1b:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e29:	eb 76                	jmp    803ea1 <devcons_write+0x9f>
		m = n - tot;
  803e2b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803e32:	89 c2                	mov    %eax,%edx
  803e34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e37:	29 c2                	sub    %eax,%edx
  803e39:	89 d0                	mov    %edx,%eax
  803e3b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803e3e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e41:	83 f8 7f             	cmp    $0x7f,%eax
  803e44:	76 07                	jbe    803e4d <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803e46:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803e4d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e50:	48 63 d0             	movslq %eax,%rdx
  803e53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e56:	48 63 c8             	movslq %eax,%rcx
  803e59:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803e60:	48 01 c1             	add    %rax,%rcx
  803e63:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e6a:	48 89 ce             	mov    %rcx,%rsi
  803e6d:	48 89 c7             	mov    %rax,%rdi
  803e70:	48 b8 9f 14 80 00 00 	movabs $0x80149f,%rax
  803e77:	00 00 00 
  803e7a:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e7f:	48 63 d0             	movslq %eax,%rdx
  803e82:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e89:	48 89 d6             	mov    %rdx,%rsi
  803e8c:	48 89 c7             	mov    %rax,%rdi
  803e8f:	48 b8 62 19 80 00 00 	movabs $0x801962,%rax
  803e96:	00 00 00 
  803e99:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e9b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e9e:	01 45 fc             	add    %eax,-0x4(%rbp)
  803ea1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ea4:	48 98                	cltq   
  803ea6:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803ead:	0f 82 78 ff ff ff    	jb     803e2b <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803eb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803eb6:	c9                   	leaveq 
  803eb7:	c3                   	retq   

0000000000803eb8 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803eb8:	55                   	push   %rbp
  803eb9:	48 89 e5             	mov    %rsp,%rbp
  803ebc:	48 83 ec 08          	sub    $0x8,%rsp
  803ec0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ec4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ec9:	c9                   	leaveq 
  803eca:	c3                   	retq   

0000000000803ecb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803ecb:	55                   	push   %rbp
  803ecc:	48 89 e5             	mov    %rsp,%rbp
  803ecf:	48 83 ec 10          	sub    $0x10,%rsp
  803ed3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ed7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803edb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803edf:	48 be 5c 48 80 00 00 	movabs $0x80485c,%rsi
  803ee6:	00 00 00 
  803ee9:	48 89 c7             	mov    %rax,%rdi
  803eec:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  803ef3:	00 00 00 
  803ef6:	ff d0                	callq  *%rax
	return 0;
  803ef8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803efd:	c9                   	leaveq 
  803efe:	c3                   	retq   

0000000000803eff <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803eff:	55                   	push   %rbp
  803f00:	48 89 e5             	mov    %rsp,%rbp
  803f03:	48 83 ec 30          	sub    $0x30,%rsp
  803f07:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f0b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f0f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803f13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f17:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803f1b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803f20:	75 0e                	jne    803f30 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  803f22:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803f29:	00 00 00 
  803f2c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  803f30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f34:	48 89 c7             	mov    %rax,%rdi
  803f37:	48 b8 d3 1c 80 00 00 	movabs $0x801cd3,%rax
  803f3e:	00 00 00 
  803f41:	ff d0                	callq  *%rax
  803f43:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803f46:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803f4a:	79 27                	jns    803f73 <ipc_recv+0x74>
		if (from_env_store != NULL)
  803f4c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f51:	74 0a                	je     803f5d <ipc_recv+0x5e>
			*from_env_store = 0;
  803f53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f57:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  803f5d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f62:	74 0a                	je     803f6e <ipc_recv+0x6f>
			*perm_store = 0;
  803f64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f68:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803f6e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803f71:	eb 53                	jmp    803fc6 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  803f73:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f78:	74 19                	je     803f93 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  803f7a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f81:	00 00 00 
  803f84:	48 8b 00             	mov    (%rax),%rax
  803f87:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803f8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f91:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  803f93:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f98:	74 19                	je     803fb3 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803f9a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fa1:	00 00 00 
  803fa4:	48 8b 00             	mov    (%rax),%rax
  803fa7:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803fad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fb1:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  803fb3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fba:	00 00 00 
  803fbd:	48 8b 00             	mov    (%rax),%rax
  803fc0:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803fc6:	c9                   	leaveq 
  803fc7:	c3                   	retq   

0000000000803fc8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803fc8:	55                   	push   %rbp
  803fc9:	48 89 e5             	mov    %rsp,%rbp
  803fcc:	48 83 ec 30          	sub    $0x30,%rsp
  803fd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fd3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803fd6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803fda:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803fdd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fe1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803fe5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803fea:	75 10                	jne    803ffc <ipc_send+0x34>
		page = (void *)KERNBASE;
  803fec:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803ff3:	00 00 00 
  803ff6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803ffa:	eb 0e                	jmp    80400a <ipc_send+0x42>
  803ffc:	eb 0c                	jmp    80400a <ipc_send+0x42>
		sys_yield();
  803ffe:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  804005:	00 00 00 
  804008:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  80400a:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80400d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804010:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804014:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804017:	89 c7                	mov    %eax,%edi
  804019:	48 b8 7e 1c 80 00 00 	movabs $0x801c7e,%rax
  804020:	00 00 00 
  804023:	ff d0                	callq  *%rax
  804025:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804028:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  80402c:	74 d0                	je     803ffe <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  80402e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  804032:	74 2a                	je     80405e <ipc_send+0x96>
		panic("error on ipc send procedure");
  804034:	48 ba 63 48 80 00 00 	movabs $0x804863,%rdx
  80403b:	00 00 00 
  80403e:	be 49 00 00 00       	mov    $0x49,%esi
  804043:	48 bf 7f 48 80 00 00 	movabs $0x80487f,%rdi
  80404a:	00 00 00 
  80404d:	b8 00 00 00 00       	mov    $0x0,%eax
  804052:	48 b9 9a 01 80 00 00 	movabs $0x80019a,%rcx
  804059:	00 00 00 
  80405c:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  80405e:	c9                   	leaveq 
  80405f:	c3                   	retq   

0000000000804060 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804060:	55                   	push   %rbp
  804061:	48 89 e5             	mov    %rsp,%rbp
  804064:	48 83 ec 14          	sub    $0x14,%rsp
  804068:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80406b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804072:	eb 5e                	jmp    8040d2 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804074:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80407b:	00 00 00 
  80407e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804081:	48 63 d0             	movslq %eax,%rdx
  804084:	48 89 d0             	mov    %rdx,%rax
  804087:	48 c1 e0 03          	shl    $0x3,%rax
  80408b:	48 01 d0             	add    %rdx,%rax
  80408e:	48 c1 e0 05          	shl    $0x5,%rax
  804092:	48 01 c8             	add    %rcx,%rax
  804095:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80409b:	8b 00                	mov    (%rax),%eax
  80409d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8040a0:	75 2c                	jne    8040ce <ipc_find_env+0x6e>
			return envs[i].env_id;
  8040a2:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8040a9:	00 00 00 
  8040ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040af:	48 63 d0             	movslq %eax,%rdx
  8040b2:	48 89 d0             	mov    %rdx,%rax
  8040b5:	48 c1 e0 03          	shl    $0x3,%rax
  8040b9:	48 01 d0             	add    %rdx,%rax
  8040bc:	48 c1 e0 05          	shl    $0x5,%rax
  8040c0:	48 01 c8             	add    %rcx,%rax
  8040c3:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8040c9:	8b 40 08             	mov    0x8(%rax),%eax
  8040cc:	eb 12                	jmp    8040e0 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8040ce:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8040d2:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8040d9:	7e 99                	jle    804074 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8040db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040e0:	c9                   	leaveq 
  8040e1:	c3                   	retq   

00000000008040e2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8040e2:	55                   	push   %rbp
  8040e3:	48 89 e5             	mov    %rsp,%rbp
  8040e6:	48 83 ec 18          	sub    $0x18,%rsp
  8040ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8040ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040f2:	48 c1 e8 15          	shr    $0x15,%rax
  8040f6:	48 89 c2             	mov    %rax,%rdx
  8040f9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804100:	01 00 00 
  804103:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804107:	83 e0 01             	and    $0x1,%eax
  80410a:	48 85 c0             	test   %rax,%rax
  80410d:	75 07                	jne    804116 <pageref+0x34>
		return 0;
  80410f:	b8 00 00 00 00       	mov    $0x0,%eax
  804114:	eb 53                	jmp    804169 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804116:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80411a:	48 c1 e8 0c          	shr    $0xc,%rax
  80411e:	48 89 c2             	mov    %rax,%rdx
  804121:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804128:	01 00 00 
  80412b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80412f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804133:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804137:	83 e0 01             	and    $0x1,%eax
  80413a:	48 85 c0             	test   %rax,%rax
  80413d:	75 07                	jne    804146 <pageref+0x64>
		return 0;
  80413f:	b8 00 00 00 00       	mov    $0x0,%eax
  804144:	eb 23                	jmp    804169 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80414a:	48 c1 e8 0c          	shr    $0xc,%rax
  80414e:	48 89 c2             	mov    %rax,%rdx
  804151:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804158:	00 00 00 
  80415b:	48 c1 e2 04          	shl    $0x4,%rdx
  80415f:	48 01 d0             	add    %rdx,%rax
  804162:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804166:	0f b7 c0             	movzwl %ax,%eax
}
  804169:	c9                   	leaveq 
  80416a:	c3                   	retq   
