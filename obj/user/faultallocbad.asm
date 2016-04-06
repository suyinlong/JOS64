
obj/user/faultallocbad.debug:     file format elf64-x86-64


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
  80003c:	e8 15 01 00 00       	callq  800156 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
  80004b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80004f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800053:	48 8b 00             	mov    (%rax),%rax
  800056:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	cprintf("fault %x\n", addr);
  80005a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80005e:	48 89 c6             	mov    %rax,%rsi
  800061:	48 bf 00 37 80 00 00 	movabs $0x803700,%rdi
  800068:	00 00 00 
  80006b:	b8 00 00 00 00       	mov    $0x0,%eax
  800070:	48 ba 42 04 80 00 00 	movabs $0x800442,%rdx
  800077:	00 00 00 
  80007a:	ff d2                	callq  *%rdx
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80007c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800080:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800084:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800088:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80008e:	ba 07 00 00 00       	mov    $0x7,%edx
  800093:	48 89 c6             	mov    %rax,%rsi
  800096:	bf 00 00 00 00       	mov    $0x0,%edi
  80009b:	48 b8 19 1b 80 00 00 	movabs $0x801b19,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8000aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000ae:	79 38                	jns    8000e8 <handler+0xa5>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  8000b0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8000b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000b7:	41 89 d0             	mov    %edx,%r8d
  8000ba:	48 89 c1             	mov    %rax,%rcx
  8000bd:	48 ba 10 37 80 00 00 	movabs $0x803710,%rdx
  8000c4:	00 00 00 
  8000c7:	be 0f 00 00 00       	mov    $0xf,%esi
  8000cc:	48 bf 3b 37 80 00 00 	movabs $0x80373b,%rdi
  8000d3:	00 00 00 
  8000d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000db:	49 b9 09 02 80 00 00 	movabs $0x800209,%r9
  8000e2:	00 00 00 
  8000e5:	41 ff d1             	callq  *%r9
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	48 89 d1             	mov    %rdx,%rcx
  8000f3:	48 ba 50 37 80 00 00 	movabs $0x803750,%rdx
  8000fa:	00 00 00 
  8000fd:	be 64 00 00 00       	mov    $0x64,%esi
  800102:	48 89 c7             	mov    %rax,%rdi
  800105:	b8 00 00 00 00       	mov    $0x0,%eax
  80010a:	49 b8 9d 10 80 00 00 	movabs $0x80109d,%r8
  800111:	00 00 00 
  800114:	41 ff d0             	callq  *%r8
}
  800117:	c9                   	leaveq 
  800118:	c3                   	retq   

0000000000800119 <umain>:

void
umain(int argc, char **argv)
{
  800119:	55                   	push   %rbp
  80011a:	48 89 e5             	mov    %rsp,%rbp
  80011d:	48 83 ec 10          	sub    $0x10,%rsp
  800121:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800124:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(handler);
  800128:	48 bf 43 00 80 00 00 	movabs $0x800043,%rdi
  80012f:	00 00 00 
  800132:	48 b8 86 1d 80 00 00 	movabs $0x801d86,%rax
  800139:	00 00 00 
  80013c:	ff d0                	callq  *%rax
	sys_cputs((char*)0xDEADBEEF, 4);
  80013e:	be 04 00 00 00       	mov    $0x4,%esi
  800143:	bf ef be ad de       	mov    $0xdeadbeef,%edi
  800148:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  80014f:	00 00 00 
  800152:	ff d0                	callq  *%rax
}
  800154:	c9                   	leaveq 
  800155:	c3                   	retq   

0000000000800156 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800156:	55                   	push   %rbp
  800157:	48 89 e5             	mov    %rsp,%rbp
  80015a:	48 83 ec 10          	sub    $0x10,%rsp
  80015e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800161:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800165:	48 b8 9d 1a 80 00 00 	movabs $0x801a9d,%rax
  80016c:	00 00 00 
  80016f:	ff d0                	callq  *%rax
  800171:	48 98                	cltq   
  800173:	25 ff 03 00 00       	and    $0x3ff,%eax
  800178:	48 89 c2             	mov    %rax,%rdx
  80017b:	48 89 d0             	mov    %rdx,%rax
  80017e:	48 c1 e0 03          	shl    $0x3,%rax
  800182:	48 01 d0             	add    %rdx,%rax
  800185:	48 c1 e0 05          	shl    $0x5,%rax
  800189:	48 89 c2             	mov    %rax,%rdx
  80018c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800193:	00 00 00 
  800196:	48 01 c2             	add    %rax,%rdx
  800199:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001a0:	00 00 00 
  8001a3:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001aa:	7e 14                	jle    8001c0 <libmain+0x6a>
		binaryname = argv[0];
  8001ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b0:	48 8b 10             	mov    (%rax),%rdx
  8001b3:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001ba:	00 00 00 
  8001bd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001c7:	48 89 d6             	mov    %rdx,%rsi
  8001ca:	89 c7                	mov    %eax,%edi
  8001cc:	48 b8 19 01 80 00 00 	movabs $0x800119,%rax
  8001d3:	00 00 00 
  8001d6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001d8:	48 b8 e6 01 80 00 00 	movabs $0x8001e6,%rax
  8001df:	00 00 00 
  8001e2:	ff d0                	callq  *%rax
}
  8001e4:	c9                   	leaveq 
  8001e5:	c3                   	retq   

00000000008001e6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e6:	55                   	push   %rbp
  8001e7:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001ea:	48 b8 bc 21 80 00 00 	movabs $0x8021bc,%rax
  8001f1:	00 00 00 
  8001f4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fb:	48 b8 59 1a 80 00 00 	movabs $0x801a59,%rax
  800202:	00 00 00 
  800205:	ff d0                	callq  *%rax
}
  800207:	5d                   	pop    %rbp
  800208:	c3                   	retq   

0000000000800209 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800209:	55                   	push   %rbp
  80020a:	48 89 e5             	mov    %rsp,%rbp
  80020d:	53                   	push   %rbx
  80020e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800215:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80021c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800222:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800229:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800230:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800237:	84 c0                	test   %al,%al
  800239:	74 23                	je     80025e <_panic+0x55>
  80023b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800242:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800246:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80024a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80024e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800252:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800256:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80025a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80025e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800265:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80026c:	00 00 00 
  80026f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800276:	00 00 00 
  800279:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80027d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800284:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80028b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800292:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800299:	00 00 00 
  80029c:	48 8b 18             	mov    (%rax),%rbx
  80029f:	48 b8 9d 1a 80 00 00 	movabs $0x801a9d,%rax
  8002a6:	00 00 00 
  8002a9:	ff d0                	callq  *%rax
  8002ab:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8002b1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8002b8:	41 89 c8             	mov    %ecx,%r8d
  8002bb:	48 89 d1             	mov    %rdx,%rcx
  8002be:	48 89 da             	mov    %rbx,%rdx
  8002c1:	89 c6                	mov    %eax,%esi
  8002c3:	48 bf 80 37 80 00 00 	movabs $0x803780,%rdi
  8002ca:	00 00 00 
  8002cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d2:	49 b9 42 04 80 00 00 	movabs $0x800442,%r9
  8002d9:	00 00 00 
  8002dc:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002df:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8002e6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8002ed:	48 89 d6             	mov    %rdx,%rsi
  8002f0:	48 89 c7             	mov    %rax,%rdi
  8002f3:	48 b8 96 03 80 00 00 	movabs $0x800396,%rax
  8002fa:	00 00 00 
  8002fd:	ff d0                	callq  *%rax
	cprintf("\n");
  8002ff:	48 bf a3 37 80 00 00 	movabs $0x8037a3,%rdi
  800306:	00 00 00 
  800309:	b8 00 00 00 00       	mov    $0x0,%eax
  80030e:	48 ba 42 04 80 00 00 	movabs $0x800442,%rdx
  800315:	00 00 00 
  800318:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80031a:	cc                   	int3   
  80031b:	eb fd                	jmp    80031a <_panic+0x111>

000000000080031d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80031d:	55                   	push   %rbp
  80031e:	48 89 e5             	mov    %rsp,%rbp
  800321:	48 83 ec 10          	sub    $0x10,%rsp
  800325:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800328:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80032c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800330:	8b 00                	mov    (%rax),%eax
  800332:	8d 48 01             	lea    0x1(%rax),%ecx
  800335:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800339:	89 0a                	mov    %ecx,(%rdx)
  80033b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80033e:	89 d1                	mov    %edx,%ecx
  800340:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800344:	48 98                	cltq   
  800346:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80034a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80034e:	8b 00                	mov    (%rax),%eax
  800350:	3d ff 00 00 00       	cmp    $0xff,%eax
  800355:	75 2c                	jne    800383 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800357:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80035b:	8b 00                	mov    (%rax),%eax
  80035d:	48 98                	cltq   
  80035f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800363:	48 83 c2 08          	add    $0x8,%rdx
  800367:	48 89 c6             	mov    %rax,%rsi
  80036a:	48 89 d7             	mov    %rdx,%rdi
  80036d:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  800374:	00 00 00 
  800377:	ff d0                	callq  *%rax
		b->idx = 0;
  800379:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80037d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800383:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800387:	8b 40 04             	mov    0x4(%rax),%eax
  80038a:	8d 50 01             	lea    0x1(%rax),%edx
  80038d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800391:	89 50 04             	mov    %edx,0x4(%rax)
}
  800394:	c9                   	leaveq 
  800395:	c3                   	retq   

0000000000800396 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800396:	55                   	push   %rbp
  800397:	48 89 e5             	mov    %rsp,%rbp
  80039a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003a1:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003a8:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8003af:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003b6:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003bd:	48 8b 0a             	mov    (%rdx),%rcx
  8003c0:	48 89 08             	mov    %rcx,(%rax)
  8003c3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003c7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003cb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003cf:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8003d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8003da:	00 00 00 
	b.cnt = 0;
  8003dd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8003e4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8003e7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8003ee:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8003f5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8003fc:	48 89 c6             	mov    %rax,%rsi
  8003ff:	48 bf 1d 03 80 00 00 	movabs $0x80031d,%rdi
  800406:	00 00 00 
  800409:	48 b8 f5 07 80 00 00 	movabs $0x8007f5,%rax
  800410:	00 00 00 
  800413:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800415:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80041b:	48 98                	cltq   
  80041d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800424:	48 83 c2 08          	add    $0x8,%rdx
  800428:	48 89 c6             	mov    %rax,%rsi
  80042b:	48 89 d7             	mov    %rdx,%rdi
  80042e:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  800435:	00 00 00 
  800438:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80043a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800440:	c9                   	leaveq 
  800441:	c3                   	retq   

0000000000800442 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800442:	55                   	push   %rbp
  800443:	48 89 e5             	mov    %rsp,%rbp
  800446:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80044d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800454:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80045b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800462:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800469:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800470:	84 c0                	test   %al,%al
  800472:	74 20                	je     800494 <cprintf+0x52>
  800474:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800478:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80047c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800480:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800484:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800488:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80048c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800490:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800494:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80049b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004a2:	00 00 00 
  8004a5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004ac:	00 00 00 
  8004af:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004b3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004ba:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004c1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8004c8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004cf:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8004d6:	48 8b 0a             	mov    (%rdx),%rcx
  8004d9:	48 89 08             	mov    %rcx,(%rax)
  8004dc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004e0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004e4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004e8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8004ec:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8004f3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004fa:	48 89 d6             	mov    %rdx,%rsi
  8004fd:	48 89 c7             	mov    %rax,%rdi
  800500:	48 b8 96 03 80 00 00 	movabs $0x800396,%rax
  800507:	00 00 00 
  80050a:	ff d0                	callq  *%rax
  80050c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800512:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800518:	c9                   	leaveq 
  800519:	c3                   	retq   

000000000080051a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80051a:	55                   	push   %rbp
  80051b:	48 89 e5             	mov    %rsp,%rbp
  80051e:	53                   	push   %rbx
  80051f:	48 83 ec 38          	sub    $0x38,%rsp
  800523:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800527:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80052b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80052f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800532:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800536:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80053a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80053d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800541:	77 3b                	ja     80057e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800543:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800546:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80054a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80054d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800551:	ba 00 00 00 00       	mov    $0x0,%edx
  800556:	48 f7 f3             	div    %rbx
  800559:	48 89 c2             	mov    %rax,%rdx
  80055c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80055f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800562:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800566:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056a:	41 89 f9             	mov    %edi,%r9d
  80056d:	48 89 c7             	mov    %rax,%rdi
  800570:	48 b8 1a 05 80 00 00 	movabs $0x80051a,%rax
  800577:	00 00 00 
  80057a:	ff d0                	callq  *%rax
  80057c:	eb 1e                	jmp    80059c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80057e:	eb 12                	jmp    800592 <printnum+0x78>
			putch(padc, putdat);
  800580:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800584:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800587:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058b:	48 89 ce             	mov    %rcx,%rsi
  80058e:	89 d7                	mov    %edx,%edi
  800590:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800592:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800596:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80059a:	7f e4                	jg     800580 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80059c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80059f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a8:	48 f7 f1             	div    %rcx
  8005ab:	48 89 d0             	mov    %rdx,%rax
  8005ae:	48 ba 88 39 80 00 00 	movabs $0x803988,%rdx
  8005b5:	00 00 00 
  8005b8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005bc:	0f be d0             	movsbl %al,%edx
  8005bf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c7:	48 89 ce             	mov    %rcx,%rsi
  8005ca:	89 d7                	mov    %edx,%edi
  8005cc:	ff d0                	callq  *%rax
}
  8005ce:	48 83 c4 38          	add    $0x38,%rsp
  8005d2:	5b                   	pop    %rbx
  8005d3:	5d                   	pop    %rbp
  8005d4:	c3                   	retq   

00000000008005d5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005d5:	55                   	push   %rbp
  8005d6:	48 89 e5             	mov    %rsp,%rbp
  8005d9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005e1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8005e4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005e8:	7e 52                	jle    80063c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8005ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ee:	8b 00                	mov    (%rax),%eax
  8005f0:	83 f8 30             	cmp    $0x30,%eax
  8005f3:	73 24                	jae    800619 <getuint+0x44>
  8005f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800601:	8b 00                	mov    (%rax),%eax
  800603:	89 c0                	mov    %eax,%eax
  800605:	48 01 d0             	add    %rdx,%rax
  800608:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060c:	8b 12                	mov    (%rdx),%edx
  80060e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800611:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800615:	89 0a                	mov    %ecx,(%rdx)
  800617:	eb 17                	jmp    800630 <getuint+0x5b>
  800619:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800621:	48 89 d0             	mov    %rdx,%rax
  800624:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800628:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800630:	48 8b 00             	mov    (%rax),%rax
  800633:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800637:	e9 a3 00 00 00       	jmpq   8006df <getuint+0x10a>
	else if (lflag)
  80063c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800640:	74 4f                	je     800691 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800642:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800646:	8b 00                	mov    (%rax),%eax
  800648:	83 f8 30             	cmp    $0x30,%eax
  80064b:	73 24                	jae    800671 <getuint+0x9c>
  80064d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800651:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800655:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800659:	8b 00                	mov    (%rax),%eax
  80065b:	89 c0                	mov    %eax,%eax
  80065d:	48 01 d0             	add    %rdx,%rax
  800660:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800664:	8b 12                	mov    (%rdx),%edx
  800666:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800669:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066d:	89 0a                	mov    %ecx,(%rdx)
  80066f:	eb 17                	jmp    800688 <getuint+0xb3>
  800671:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800675:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800679:	48 89 d0             	mov    %rdx,%rax
  80067c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800680:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800684:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800688:	48 8b 00             	mov    (%rax),%rax
  80068b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80068f:	eb 4e                	jmp    8006df <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800695:	8b 00                	mov    (%rax),%eax
  800697:	83 f8 30             	cmp    $0x30,%eax
  80069a:	73 24                	jae    8006c0 <getuint+0xeb>
  80069c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a8:	8b 00                	mov    (%rax),%eax
  8006aa:	89 c0                	mov    %eax,%eax
  8006ac:	48 01 d0             	add    %rdx,%rax
  8006af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b3:	8b 12                	mov    (%rdx),%edx
  8006b5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bc:	89 0a                	mov    %ecx,(%rdx)
  8006be:	eb 17                	jmp    8006d7 <getuint+0x102>
  8006c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006c8:	48 89 d0             	mov    %rdx,%rax
  8006cb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006d7:	8b 00                	mov    (%rax),%eax
  8006d9:	89 c0                	mov    %eax,%eax
  8006db:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006e3:	c9                   	leaveq 
  8006e4:	c3                   	retq   

00000000008006e5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e5:	55                   	push   %rbp
  8006e6:	48 89 e5             	mov    %rsp,%rbp
  8006e9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006f1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8006f4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006f8:	7e 52                	jle    80074c <getint+0x67>
		x=va_arg(*ap, long long);
  8006fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fe:	8b 00                	mov    (%rax),%eax
  800700:	83 f8 30             	cmp    $0x30,%eax
  800703:	73 24                	jae    800729 <getint+0x44>
  800705:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800709:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80070d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800711:	8b 00                	mov    (%rax),%eax
  800713:	89 c0                	mov    %eax,%eax
  800715:	48 01 d0             	add    %rdx,%rax
  800718:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071c:	8b 12                	mov    (%rdx),%edx
  80071e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800721:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800725:	89 0a                	mov    %ecx,(%rdx)
  800727:	eb 17                	jmp    800740 <getint+0x5b>
  800729:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800731:	48 89 d0             	mov    %rdx,%rax
  800734:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800738:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80073c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800740:	48 8b 00             	mov    (%rax),%rax
  800743:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800747:	e9 a3 00 00 00       	jmpq   8007ef <getint+0x10a>
	else if (lflag)
  80074c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800750:	74 4f                	je     8007a1 <getint+0xbc>
		x=va_arg(*ap, long);
  800752:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800756:	8b 00                	mov    (%rax),%eax
  800758:	83 f8 30             	cmp    $0x30,%eax
  80075b:	73 24                	jae    800781 <getint+0x9c>
  80075d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800761:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800769:	8b 00                	mov    (%rax),%eax
  80076b:	89 c0                	mov    %eax,%eax
  80076d:	48 01 d0             	add    %rdx,%rax
  800770:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800774:	8b 12                	mov    (%rdx),%edx
  800776:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800779:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077d:	89 0a                	mov    %ecx,(%rdx)
  80077f:	eb 17                	jmp    800798 <getint+0xb3>
  800781:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800785:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800789:	48 89 d0             	mov    %rdx,%rax
  80078c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800790:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800794:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800798:	48 8b 00             	mov    (%rax),%rax
  80079b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80079f:	eb 4e                	jmp    8007ef <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a5:	8b 00                	mov    (%rax),%eax
  8007a7:	83 f8 30             	cmp    $0x30,%eax
  8007aa:	73 24                	jae    8007d0 <getint+0xeb>
  8007ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b8:	8b 00                	mov    (%rax),%eax
  8007ba:	89 c0                	mov    %eax,%eax
  8007bc:	48 01 d0             	add    %rdx,%rax
  8007bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c3:	8b 12                	mov    (%rdx),%edx
  8007c5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cc:	89 0a                	mov    %ecx,(%rdx)
  8007ce:	eb 17                	jmp    8007e7 <getint+0x102>
  8007d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007d8:	48 89 d0             	mov    %rdx,%rax
  8007db:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007e7:	8b 00                	mov    (%rax),%eax
  8007e9:	48 98                	cltq   
  8007eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007f3:	c9                   	leaveq 
  8007f4:	c3                   	retq   

00000000008007f5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f5:	55                   	push   %rbp
  8007f6:	48 89 e5             	mov    %rsp,%rbp
  8007f9:	41 54                	push   %r12
  8007fb:	53                   	push   %rbx
  8007fc:	48 83 ec 60          	sub    $0x60,%rsp
  800800:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800804:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800808:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80080c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800810:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800814:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800818:	48 8b 0a             	mov    (%rdx),%rcx
  80081b:	48 89 08             	mov    %rcx,(%rax)
  80081e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800822:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800826:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80082a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  80082e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800832:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800836:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80083a:	0f b6 00             	movzbl (%rax),%eax
  80083d:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  800840:	eb 29                	jmp    80086b <vprintfmt+0x76>
			if (ch == '\0')
  800842:	85 db                	test   %ebx,%ebx
  800844:	0f 84 ad 06 00 00    	je     800ef7 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  80084a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80084e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800852:	48 89 d6             	mov    %rdx,%rsi
  800855:	89 df                	mov    %ebx,%edi
  800857:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  800859:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80085d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800861:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800865:	0f b6 00             	movzbl (%rax),%eax
  800868:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  80086b:	83 fb 25             	cmp    $0x25,%ebx
  80086e:	74 05                	je     800875 <vprintfmt+0x80>
  800870:	83 fb 1b             	cmp    $0x1b,%ebx
  800873:	75 cd                	jne    800842 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800875:	83 fb 1b             	cmp    $0x1b,%ebx
  800878:	0f 85 ae 01 00 00    	jne    800a2c <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  80087e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800885:	00 00 00 
  800888:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  80088e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800892:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800896:	48 89 d6             	mov    %rdx,%rsi
  800899:	89 df                	mov    %ebx,%edi
  80089b:	ff d0                	callq  *%rax
			putch('[', putdat);
  80089d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008a1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008a5:	48 89 d6             	mov    %rdx,%rsi
  8008a8:	bf 5b 00 00 00       	mov    $0x5b,%edi
  8008ad:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  8008af:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  8008b5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8008ba:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008be:	0f b6 00             	movzbl (%rax),%eax
  8008c1:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8008c4:	eb 32                	jmp    8008f8 <vprintfmt+0x103>
					putch(ch, putdat);
  8008c6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008ca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ce:	48 89 d6             	mov    %rdx,%rsi
  8008d1:	89 df                	mov    %ebx,%edi
  8008d3:	ff d0                	callq  *%rax
					esc_color *= 10;
  8008d5:	44 89 e0             	mov    %r12d,%eax
  8008d8:	c1 e0 02             	shl    $0x2,%eax
  8008db:	44 01 e0             	add    %r12d,%eax
  8008de:	01 c0                	add    %eax,%eax
  8008e0:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  8008e3:	8d 43 d0             	lea    -0x30(%rbx),%eax
  8008e6:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  8008e9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8008ee:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008f2:	0f b6 00             	movzbl (%rax),%eax
  8008f5:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8008f8:	83 fb 3b             	cmp    $0x3b,%ebx
  8008fb:	74 05                	je     800902 <vprintfmt+0x10d>
  8008fd:	83 fb 6d             	cmp    $0x6d,%ebx
  800900:	75 c4                	jne    8008c6 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800902:	45 85 e4             	test   %r12d,%r12d
  800905:	75 15                	jne    80091c <vprintfmt+0x127>
					color_flag = 0x07;
  800907:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80090e:	00 00 00 
  800911:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800917:	e9 dc 00 00 00       	jmpq   8009f8 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  80091c:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800920:	7e 69                	jle    80098b <vprintfmt+0x196>
  800922:	41 83 fc 25          	cmp    $0x25,%r12d
  800926:	7f 63                	jg     80098b <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800928:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80092f:	00 00 00 
  800932:	8b 00                	mov    (%rax),%eax
  800934:	25 f8 00 00 00       	and    $0xf8,%eax
  800939:	89 c2                	mov    %eax,%edx
  80093b:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800942:	00 00 00 
  800945:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800947:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  80094b:	44 89 e0             	mov    %r12d,%eax
  80094e:	83 e0 04             	and    $0x4,%eax
  800951:	c1 f8 02             	sar    $0x2,%eax
  800954:	89 c2                	mov    %eax,%edx
  800956:	44 89 e0             	mov    %r12d,%eax
  800959:	83 e0 02             	and    $0x2,%eax
  80095c:	09 c2                	or     %eax,%edx
  80095e:	44 89 e0             	mov    %r12d,%eax
  800961:	83 e0 01             	and    $0x1,%eax
  800964:	c1 e0 02             	shl    $0x2,%eax
  800967:	09 c2                	or     %eax,%edx
  800969:	41 89 d4             	mov    %edx,%r12d
  80096c:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800973:	00 00 00 
  800976:	8b 00                	mov    (%rax),%eax
  800978:	44 89 e2             	mov    %r12d,%edx
  80097b:	09 c2                	or     %eax,%edx
  80097d:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800984:	00 00 00 
  800987:	89 10                	mov    %edx,(%rax)
  800989:	eb 6d                	jmp    8009f8 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  80098b:	41 83 fc 27          	cmp    $0x27,%r12d
  80098f:	7e 67                	jle    8009f8 <vprintfmt+0x203>
  800991:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800995:	7f 61                	jg     8009f8 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800997:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80099e:	00 00 00 
  8009a1:	8b 00                	mov    (%rax),%eax
  8009a3:	25 8f 00 00 00       	and    $0x8f,%eax
  8009a8:	89 c2                	mov    %eax,%edx
  8009aa:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8009b1:	00 00 00 
  8009b4:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  8009b6:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  8009ba:	44 89 e0             	mov    %r12d,%eax
  8009bd:	83 e0 04             	and    $0x4,%eax
  8009c0:	c1 f8 02             	sar    $0x2,%eax
  8009c3:	89 c2                	mov    %eax,%edx
  8009c5:	44 89 e0             	mov    %r12d,%eax
  8009c8:	83 e0 02             	and    $0x2,%eax
  8009cb:	09 c2                	or     %eax,%edx
  8009cd:	44 89 e0             	mov    %r12d,%eax
  8009d0:	83 e0 01             	and    $0x1,%eax
  8009d3:	c1 e0 06             	shl    $0x6,%eax
  8009d6:	09 c2                	or     %eax,%edx
  8009d8:	41 89 d4             	mov    %edx,%r12d
  8009db:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8009e2:	00 00 00 
  8009e5:	8b 00                	mov    (%rax),%eax
  8009e7:	44 89 e2             	mov    %r12d,%edx
  8009ea:	09 c2                	or     %eax,%edx
  8009ec:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8009f3:	00 00 00 
  8009f6:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  8009f8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009fc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a00:	48 89 d6             	mov    %rdx,%rsi
  800a03:	89 df                	mov    %ebx,%edi
  800a05:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800a07:	83 fb 6d             	cmp    $0x6d,%ebx
  800a0a:	75 1b                	jne    800a27 <vprintfmt+0x232>
					fmt ++;
  800a0c:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800a11:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800a12:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800a19:	00 00 00 
  800a1c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800a22:	e9 cb 04 00 00       	jmpq   800ef2 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800a27:	e9 83 fe ff ff       	jmpq   8008af <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800a2c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a30:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a37:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a3e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a45:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a4c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a50:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a54:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a58:	0f b6 00             	movzbl (%rax),%eax
  800a5b:	0f b6 d8             	movzbl %al,%ebx
  800a5e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a61:	83 f8 55             	cmp    $0x55,%eax
  800a64:	0f 87 5a 04 00 00    	ja     800ec4 <vprintfmt+0x6cf>
  800a6a:	89 c0                	mov    %eax,%eax
  800a6c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a73:	00 
  800a74:	48 b8 b0 39 80 00 00 	movabs $0x8039b0,%rax
  800a7b:	00 00 00 
  800a7e:	48 01 d0             	add    %rdx,%rax
  800a81:	48 8b 00             	mov    (%rax),%rax
  800a84:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a86:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a8a:	eb c0                	jmp    800a4c <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a8c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a90:	eb ba                	jmp    800a4c <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a92:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a99:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a9c:	89 d0                	mov    %edx,%eax
  800a9e:	c1 e0 02             	shl    $0x2,%eax
  800aa1:	01 d0                	add    %edx,%eax
  800aa3:	01 c0                	add    %eax,%eax
  800aa5:	01 d8                	add    %ebx,%eax
  800aa7:	83 e8 30             	sub    $0x30,%eax
  800aaa:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800aad:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ab1:	0f b6 00             	movzbl (%rax),%eax
  800ab4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ab7:	83 fb 2f             	cmp    $0x2f,%ebx
  800aba:	7e 0c                	jle    800ac8 <vprintfmt+0x2d3>
  800abc:	83 fb 39             	cmp    $0x39,%ebx
  800abf:	7f 07                	jg     800ac8 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ac6:	eb d1                	jmp    800a99 <vprintfmt+0x2a4>
			goto process_precision;
  800ac8:	eb 58                	jmp    800b22 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800aca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800acd:	83 f8 30             	cmp    $0x30,%eax
  800ad0:	73 17                	jae    800ae9 <vprintfmt+0x2f4>
  800ad2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad9:	89 c0                	mov    %eax,%eax
  800adb:	48 01 d0             	add    %rdx,%rax
  800ade:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae1:	83 c2 08             	add    $0x8,%edx
  800ae4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae7:	eb 0f                	jmp    800af8 <vprintfmt+0x303>
  800ae9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aed:	48 89 d0             	mov    %rdx,%rax
  800af0:	48 83 c2 08          	add    $0x8,%rdx
  800af4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800af8:	8b 00                	mov    (%rax),%eax
  800afa:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800afd:	eb 23                	jmp    800b22 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800aff:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b03:	79 0c                	jns    800b11 <vprintfmt+0x31c>
				width = 0;
  800b05:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b0c:	e9 3b ff ff ff       	jmpq   800a4c <vprintfmt+0x257>
  800b11:	e9 36 ff ff ff       	jmpq   800a4c <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800b16:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b1d:	e9 2a ff ff ff       	jmpq   800a4c <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800b22:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b26:	79 12                	jns    800b3a <vprintfmt+0x345>
				width = precision, precision = -1;
  800b28:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b2b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b2e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b35:	e9 12 ff ff ff       	jmpq   800a4c <vprintfmt+0x257>
  800b3a:	e9 0d ff ff ff       	jmpq   800a4c <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b3f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b43:	e9 04 ff ff ff       	jmpq   800a4c <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b4b:	83 f8 30             	cmp    $0x30,%eax
  800b4e:	73 17                	jae    800b67 <vprintfmt+0x372>
  800b50:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b54:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b57:	89 c0                	mov    %eax,%eax
  800b59:	48 01 d0             	add    %rdx,%rax
  800b5c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b5f:	83 c2 08             	add    $0x8,%edx
  800b62:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b65:	eb 0f                	jmp    800b76 <vprintfmt+0x381>
  800b67:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b6b:	48 89 d0             	mov    %rdx,%rax
  800b6e:	48 83 c2 08          	add    $0x8,%rdx
  800b72:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b76:	8b 10                	mov    (%rax),%edx
  800b78:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b80:	48 89 ce             	mov    %rcx,%rsi
  800b83:	89 d7                	mov    %edx,%edi
  800b85:	ff d0                	callq  *%rax
			break;
  800b87:	e9 66 03 00 00       	jmpq   800ef2 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800b8c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b8f:	83 f8 30             	cmp    $0x30,%eax
  800b92:	73 17                	jae    800bab <vprintfmt+0x3b6>
  800b94:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b98:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9b:	89 c0                	mov    %eax,%eax
  800b9d:	48 01 d0             	add    %rdx,%rax
  800ba0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ba3:	83 c2 08             	add    $0x8,%edx
  800ba6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ba9:	eb 0f                	jmp    800bba <vprintfmt+0x3c5>
  800bab:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800baf:	48 89 d0             	mov    %rdx,%rax
  800bb2:	48 83 c2 08          	add    $0x8,%rdx
  800bb6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bba:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bbc:	85 db                	test   %ebx,%ebx
  800bbe:	79 02                	jns    800bc2 <vprintfmt+0x3cd>
				err = -err;
  800bc0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bc2:	83 fb 10             	cmp    $0x10,%ebx
  800bc5:	7f 16                	jg     800bdd <vprintfmt+0x3e8>
  800bc7:	48 b8 00 39 80 00 00 	movabs $0x803900,%rax
  800bce:	00 00 00 
  800bd1:	48 63 d3             	movslq %ebx,%rdx
  800bd4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bd8:	4d 85 e4             	test   %r12,%r12
  800bdb:	75 2e                	jne    800c0b <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800bdd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800be1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be5:	89 d9                	mov    %ebx,%ecx
  800be7:	48 ba 99 39 80 00 00 	movabs $0x803999,%rdx
  800bee:	00 00 00 
  800bf1:	48 89 c7             	mov    %rax,%rdi
  800bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf9:	49 b8 00 0f 80 00 00 	movabs $0x800f00,%r8
  800c00:	00 00 00 
  800c03:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c06:	e9 e7 02 00 00       	jmpq   800ef2 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c0b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c13:	4c 89 e1             	mov    %r12,%rcx
  800c16:	48 ba a2 39 80 00 00 	movabs $0x8039a2,%rdx
  800c1d:	00 00 00 
  800c20:	48 89 c7             	mov    %rax,%rdi
  800c23:	b8 00 00 00 00       	mov    $0x0,%eax
  800c28:	49 b8 00 0f 80 00 00 	movabs $0x800f00,%r8
  800c2f:	00 00 00 
  800c32:	41 ff d0             	callq  *%r8
			break;
  800c35:	e9 b8 02 00 00       	jmpq   800ef2 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3d:	83 f8 30             	cmp    $0x30,%eax
  800c40:	73 17                	jae    800c59 <vprintfmt+0x464>
  800c42:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c46:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c49:	89 c0                	mov    %eax,%eax
  800c4b:	48 01 d0             	add    %rdx,%rax
  800c4e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c51:	83 c2 08             	add    $0x8,%edx
  800c54:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c57:	eb 0f                	jmp    800c68 <vprintfmt+0x473>
  800c59:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c5d:	48 89 d0             	mov    %rdx,%rax
  800c60:	48 83 c2 08          	add    $0x8,%rdx
  800c64:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c68:	4c 8b 20             	mov    (%rax),%r12
  800c6b:	4d 85 e4             	test   %r12,%r12
  800c6e:	75 0a                	jne    800c7a <vprintfmt+0x485>
				p = "(null)";
  800c70:	49 bc a5 39 80 00 00 	movabs $0x8039a5,%r12
  800c77:	00 00 00 
			if (width > 0 && padc != '-')
  800c7a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c7e:	7e 3f                	jle    800cbf <vprintfmt+0x4ca>
  800c80:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c84:	74 39                	je     800cbf <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c86:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c89:	48 98                	cltq   
  800c8b:	48 89 c6             	mov    %rax,%rsi
  800c8e:	4c 89 e7             	mov    %r12,%rdi
  800c91:	48 b8 ac 11 80 00 00 	movabs $0x8011ac,%rax
  800c98:	00 00 00 
  800c9b:	ff d0                	callq  *%rax
  800c9d:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ca0:	eb 17                	jmp    800cb9 <vprintfmt+0x4c4>
					putch(padc, putdat);
  800ca2:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ca6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800caa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cae:	48 89 ce             	mov    %rcx,%rsi
  800cb1:	89 d7                	mov    %edx,%edi
  800cb3:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cb5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cb9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cbd:	7f e3                	jg     800ca2 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cbf:	eb 37                	jmp    800cf8 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800cc1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cc5:	74 1e                	je     800ce5 <vprintfmt+0x4f0>
  800cc7:	83 fb 1f             	cmp    $0x1f,%ebx
  800cca:	7e 05                	jle    800cd1 <vprintfmt+0x4dc>
  800ccc:	83 fb 7e             	cmp    $0x7e,%ebx
  800ccf:	7e 14                	jle    800ce5 <vprintfmt+0x4f0>
					putch('?', putdat);
  800cd1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cd5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd9:	48 89 d6             	mov    %rdx,%rsi
  800cdc:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ce1:	ff d0                	callq  *%rax
  800ce3:	eb 0f                	jmp    800cf4 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800ce5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ced:	48 89 d6             	mov    %rdx,%rsi
  800cf0:	89 df                	mov    %ebx,%edi
  800cf2:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cf4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cf8:	4c 89 e0             	mov    %r12,%rax
  800cfb:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800cff:	0f b6 00             	movzbl (%rax),%eax
  800d02:	0f be d8             	movsbl %al,%ebx
  800d05:	85 db                	test   %ebx,%ebx
  800d07:	74 10                	je     800d19 <vprintfmt+0x524>
  800d09:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d0d:	78 b2                	js     800cc1 <vprintfmt+0x4cc>
  800d0f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d13:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d17:	79 a8                	jns    800cc1 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d19:	eb 16                	jmp    800d31 <vprintfmt+0x53c>
				putch(' ', putdat);
  800d1b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d1f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d23:	48 89 d6             	mov    %rdx,%rsi
  800d26:	bf 20 00 00 00       	mov    $0x20,%edi
  800d2b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d2d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d31:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d35:	7f e4                	jg     800d1b <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800d37:	e9 b6 01 00 00       	jmpq   800ef2 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d3c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d40:	be 03 00 00 00       	mov    $0x3,%esi
  800d45:	48 89 c7             	mov    %rax,%rdi
  800d48:	48 b8 e5 06 80 00 00 	movabs $0x8006e5,%rax
  800d4f:	00 00 00 
  800d52:	ff d0                	callq  *%rax
  800d54:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d5c:	48 85 c0             	test   %rax,%rax
  800d5f:	79 1d                	jns    800d7e <vprintfmt+0x589>
				putch('-', putdat);
  800d61:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d65:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d69:	48 89 d6             	mov    %rdx,%rsi
  800d6c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d71:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d77:	48 f7 d8             	neg    %rax
  800d7a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d7e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d85:	e9 fb 00 00 00       	jmpq   800e85 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d8a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d8e:	be 03 00 00 00       	mov    $0x3,%esi
  800d93:	48 89 c7             	mov    %rax,%rdi
  800d96:	48 b8 d5 05 80 00 00 	movabs $0x8005d5,%rax
  800d9d:	00 00 00 
  800da0:	ff d0                	callq  *%rax
  800da2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800da6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dad:	e9 d3 00 00 00       	jmpq   800e85 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800db2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800db6:	be 03 00 00 00       	mov    $0x3,%esi
  800dbb:	48 89 c7             	mov    %rax,%rdi
  800dbe:	48 b8 e5 06 80 00 00 	movabs $0x8006e5,%rax
  800dc5:	00 00 00 
  800dc8:	ff d0                	callq  *%rax
  800dca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800dce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd2:	48 85 c0             	test   %rax,%rax
  800dd5:	79 1d                	jns    800df4 <vprintfmt+0x5ff>
				putch('-', putdat);
  800dd7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ddb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ddf:	48 89 d6             	mov    %rdx,%rsi
  800de2:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800de7:	ff d0                	callq  *%rax
				num = -(long long) num;
  800de9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ded:	48 f7 d8             	neg    %rax
  800df0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800df4:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800dfb:	e9 85 00 00 00       	jmpq   800e85 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800e00:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e08:	48 89 d6             	mov    %rdx,%rsi
  800e0b:	bf 30 00 00 00       	mov    $0x30,%edi
  800e10:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e12:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e16:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1a:	48 89 d6             	mov    %rdx,%rsi
  800e1d:	bf 78 00 00 00       	mov    $0x78,%edi
  800e22:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e24:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e27:	83 f8 30             	cmp    $0x30,%eax
  800e2a:	73 17                	jae    800e43 <vprintfmt+0x64e>
  800e2c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e30:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e33:	89 c0                	mov    %eax,%eax
  800e35:	48 01 d0             	add    %rdx,%rax
  800e38:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e3b:	83 c2 08             	add    $0x8,%edx
  800e3e:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e41:	eb 0f                	jmp    800e52 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800e43:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e47:	48 89 d0             	mov    %rdx,%rax
  800e4a:	48 83 c2 08          	add    $0x8,%rdx
  800e4e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e52:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e55:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e59:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e60:	eb 23                	jmp    800e85 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e62:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e66:	be 03 00 00 00       	mov    $0x3,%esi
  800e6b:	48 89 c7             	mov    %rax,%rdi
  800e6e:	48 b8 d5 05 80 00 00 	movabs $0x8005d5,%rax
  800e75:	00 00 00 
  800e78:	ff d0                	callq  *%rax
  800e7a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e7e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e85:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e8a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e8d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e90:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e94:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e98:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e9c:	45 89 c1             	mov    %r8d,%r9d
  800e9f:	41 89 f8             	mov    %edi,%r8d
  800ea2:	48 89 c7             	mov    %rax,%rdi
  800ea5:	48 b8 1a 05 80 00 00 	movabs $0x80051a,%rax
  800eac:	00 00 00 
  800eaf:	ff d0                	callq  *%rax
			break;
  800eb1:	eb 3f                	jmp    800ef2 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800eb3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ebb:	48 89 d6             	mov    %rdx,%rsi
  800ebe:	89 df                	mov    %ebx,%edi
  800ec0:	ff d0                	callq  *%rax
			break;
  800ec2:	eb 2e                	jmp    800ef2 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ec4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ec8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ecc:	48 89 d6             	mov    %rdx,%rsi
  800ecf:	bf 25 00 00 00       	mov    $0x25,%edi
  800ed4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ed6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800edb:	eb 05                	jmp    800ee2 <vprintfmt+0x6ed>
  800edd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ee2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ee6:	48 83 e8 01          	sub    $0x1,%rax
  800eea:	0f b6 00             	movzbl (%rax),%eax
  800eed:	3c 25                	cmp    $0x25,%al
  800eef:	75 ec                	jne    800edd <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  800ef1:	90                   	nop
		}
	}
  800ef2:	e9 37 f9 ff ff       	jmpq   80082e <vprintfmt+0x39>
    va_end(aq);
}
  800ef7:	48 83 c4 60          	add    $0x60,%rsp
  800efb:	5b                   	pop    %rbx
  800efc:	41 5c                	pop    %r12
  800efe:	5d                   	pop    %rbp
  800eff:	c3                   	retq   

0000000000800f00 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f00:	55                   	push   %rbp
  800f01:	48 89 e5             	mov    %rsp,%rbp
  800f04:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f0b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f12:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f19:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f20:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f27:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f2e:	84 c0                	test   %al,%al
  800f30:	74 20                	je     800f52 <printfmt+0x52>
  800f32:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f36:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f3a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f3e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f42:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f46:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f4a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f4e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f52:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f59:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f60:	00 00 00 
  800f63:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f6a:	00 00 00 
  800f6d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f71:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f78:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f7f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f86:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f8d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f94:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f9b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fa2:	48 89 c7             	mov    %rax,%rdi
  800fa5:	48 b8 f5 07 80 00 00 	movabs $0x8007f5,%rax
  800fac:	00 00 00 
  800faf:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fb1:	c9                   	leaveq 
  800fb2:	c3                   	retq   

0000000000800fb3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fb3:	55                   	push   %rbp
  800fb4:	48 89 e5             	mov    %rsp,%rbp
  800fb7:	48 83 ec 10          	sub    $0x10,%rsp
  800fbb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fbe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc6:	8b 40 10             	mov    0x10(%rax),%eax
  800fc9:	8d 50 01             	lea    0x1(%rax),%edx
  800fcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd0:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd7:	48 8b 10             	mov    (%rax),%rdx
  800fda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fde:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fe2:	48 39 c2             	cmp    %rax,%rdx
  800fe5:	73 17                	jae    800ffe <sprintputch+0x4b>
		*b->buf++ = ch;
  800fe7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800feb:	48 8b 00             	mov    (%rax),%rax
  800fee:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ff2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ff6:	48 89 0a             	mov    %rcx,(%rdx)
  800ff9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ffc:	88 10                	mov    %dl,(%rax)
}
  800ffe:	c9                   	leaveq 
  800fff:	c3                   	retq   

0000000000801000 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801000:	55                   	push   %rbp
  801001:	48 89 e5             	mov    %rsp,%rbp
  801004:	48 83 ec 50          	sub    $0x50,%rsp
  801008:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80100c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80100f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801013:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801017:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80101b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80101f:	48 8b 0a             	mov    (%rdx),%rcx
  801022:	48 89 08             	mov    %rcx,(%rax)
  801025:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801029:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80102d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801031:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801035:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801039:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80103d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801040:	48 98                	cltq   
  801042:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801046:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80104a:	48 01 d0             	add    %rdx,%rax
  80104d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801051:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801058:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80105d:	74 06                	je     801065 <vsnprintf+0x65>
  80105f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801063:	7f 07                	jg     80106c <vsnprintf+0x6c>
		return -E_INVAL;
  801065:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80106a:	eb 2f                	jmp    80109b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80106c:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801070:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801074:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801078:	48 89 c6             	mov    %rax,%rsi
  80107b:	48 bf b3 0f 80 00 00 	movabs $0x800fb3,%rdi
  801082:	00 00 00 
  801085:	48 b8 f5 07 80 00 00 	movabs $0x8007f5,%rax
  80108c:	00 00 00 
  80108f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801091:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801095:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801098:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80109b:	c9                   	leaveq 
  80109c:	c3                   	retq   

000000000080109d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80109d:	55                   	push   %rbp
  80109e:	48 89 e5             	mov    %rsp,%rbp
  8010a1:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010a8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010af:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010b5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010bc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010c3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010ca:	84 c0                	test   %al,%al
  8010cc:	74 20                	je     8010ee <snprintf+0x51>
  8010ce:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010d2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010d6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010da:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010de:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010e2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010e6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010ea:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010ee:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010f5:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010fc:	00 00 00 
  8010ff:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801106:	00 00 00 
  801109:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80110d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801114:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80111b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801122:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801129:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801130:	48 8b 0a             	mov    (%rdx),%rcx
  801133:	48 89 08             	mov    %rcx,(%rax)
  801136:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80113a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80113e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801142:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801146:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80114d:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801154:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80115a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801161:	48 89 c7             	mov    %rax,%rdi
  801164:	48 b8 00 10 80 00 00 	movabs $0x801000,%rax
  80116b:	00 00 00 
  80116e:	ff d0                	callq  *%rax
  801170:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801176:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80117c:	c9                   	leaveq 
  80117d:	c3                   	retq   

000000000080117e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80117e:	55                   	push   %rbp
  80117f:	48 89 e5             	mov    %rsp,%rbp
  801182:	48 83 ec 18          	sub    $0x18,%rsp
  801186:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80118a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801191:	eb 09                	jmp    80119c <strlen+0x1e>
		n++;
  801193:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801197:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80119c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a0:	0f b6 00             	movzbl (%rax),%eax
  8011a3:	84 c0                	test   %al,%al
  8011a5:	75 ec                	jne    801193 <strlen+0x15>
		n++;
	return n;
  8011a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011aa:	c9                   	leaveq 
  8011ab:	c3                   	retq   

00000000008011ac <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011ac:	55                   	push   %rbp
  8011ad:	48 89 e5             	mov    %rsp,%rbp
  8011b0:	48 83 ec 20          	sub    $0x20,%rsp
  8011b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011c3:	eb 0e                	jmp    8011d3 <strnlen+0x27>
		n++;
  8011c5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011c9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011ce:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011d3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011d8:	74 0b                	je     8011e5 <strnlen+0x39>
  8011da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011de:	0f b6 00             	movzbl (%rax),%eax
  8011e1:	84 c0                	test   %al,%al
  8011e3:	75 e0                	jne    8011c5 <strnlen+0x19>
		n++;
	return n;
  8011e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011e8:	c9                   	leaveq 
  8011e9:	c3                   	retq   

00000000008011ea <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011ea:	55                   	push   %rbp
  8011eb:	48 89 e5             	mov    %rsp,%rbp
  8011ee:	48 83 ec 20          	sub    $0x20,%rsp
  8011f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801202:	90                   	nop
  801203:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801207:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80120b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80120f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801213:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801217:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80121b:	0f b6 12             	movzbl (%rdx),%edx
  80121e:	88 10                	mov    %dl,(%rax)
  801220:	0f b6 00             	movzbl (%rax),%eax
  801223:	84 c0                	test   %al,%al
  801225:	75 dc                	jne    801203 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801227:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80122b:	c9                   	leaveq 
  80122c:	c3                   	retq   

000000000080122d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80122d:	55                   	push   %rbp
  80122e:	48 89 e5             	mov    %rsp,%rbp
  801231:	48 83 ec 20          	sub    $0x20,%rsp
  801235:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801239:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80123d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801241:	48 89 c7             	mov    %rax,%rdi
  801244:	48 b8 7e 11 80 00 00 	movabs $0x80117e,%rax
  80124b:	00 00 00 
  80124e:	ff d0                	callq  *%rax
  801250:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801253:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801256:	48 63 d0             	movslq %eax,%rdx
  801259:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80125d:	48 01 c2             	add    %rax,%rdx
  801260:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801264:	48 89 c6             	mov    %rax,%rsi
  801267:	48 89 d7             	mov    %rdx,%rdi
  80126a:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  801271:	00 00 00 
  801274:	ff d0                	callq  *%rax
	return dst;
  801276:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80127a:	c9                   	leaveq 
  80127b:	c3                   	retq   

000000000080127c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80127c:	55                   	push   %rbp
  80127d:	48 89 e5             	mov    %rsp,%rbp
  801280:	48 83 ec 28          	sub    $0x28,%rsp
  801284:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801288:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80128c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801290:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801294:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801298:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80129f:	00 
  8012a0:	eb 2a                	jmp    8012cc <strncpy+0x50>
		*dst++ = *src;
  8012a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012aa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012ae:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012b2:	0f b6 12             	movzbl (%rdx),%edx
  8012b5:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012bb:	0f b6 00             	movzbl (%rax),%eax
  8012be:	84 c0                	test   %al,%al
  8012c0:	74 05                	je     8012c7 <strncpy+0x4b>
			src++;
  8012c2:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012d4:	72 cc                	jb     8012a2 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012da:	c9                   	leaveq 
  8012db:	c3                   	retq   

00000000008012dc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012dc:	55                   	push   %rbp
  8012dd:	48 89 e5             	mov    %rsp,%rbp
  8012e0:	48 83 ec 28          	sub    $0x28,%rsp
  8012e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012f8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012fd:	74 3d                	je     80133c <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012ff:	eb 1d                	jmp    80131e <strlcpy+0x42>
			*dst++ = *src++;
  801301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801305:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801309:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80130d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801311:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801315:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801319:	0f b6 12             	movzbl (%rdx),%edx
  80131c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80131e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801323:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801328:	74 0b                	je     801335 <strlcpy+0x59>
  80132a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80132e:	0f b6 00             	movzbl (%rax),%eax
  801331:	84 c0                	test   %al,%al
  801333:	75 cc                	jne    801301 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801335:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801339:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80133c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801344:	48 29 c2             	sub    %rax,%rdx
  801347:	48 89 d0             	mov    %rdx,%rax
}
  80134a:	c9                   	leaveq 
  80134b:	c3                   	retq   

000000000080134c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80134c:	55                   	push   %rbp
  80134d:	48 89 e5             	mov    %rsp,%rbp
  801350:	48 83 ec 10          	sub    $0x10,%rsp
  801354:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801358:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80135c:	eb 0a                	jmp    801368 <strcmp+0x1c>
		p++, q++;
  80135e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801363:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801368:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136c:	0f b6 00             	movzbl (%rax),%eax
  80136f:	84 c0                	test   %al,%al
  801371:	74 12                	je     801385 <strcmp+0x39>
  801373:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801377:	0f b6 10             	movzbl (%rax),%edx
  80137a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137e:	0f b6 00             	movzbl (%rax),%eax
  801381:	38 c2                	cmp    %al,%dl
  801383:	74 d9                	je     80135e <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801385:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801389:	0f b6 00             	movzbl (%rax),%eax
  80138c:	0f b6 d0             	movzbl %al,%edx
  80138f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801393:	0f b6 00             	movzbl (%rax),%eax
  801396:	0f b6 c0             	movzbl %al,%eax
  801399:	29 c2                	sub    %eax,%edx
  80139b:	89 d0                	mov    %edx,%eax
}
  80139d:	c9                   	leaveq 
  80139e:	c3                   	retq   

000000000080139f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80139f:	55                   	push   %rbp
  8013a0:	48 89 e5             	mov    %rsp,%rbp
  8013a3:	48 83 ec 18          	sub    $0x18,%rsp
  8013a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013af:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013b3:	eb 0f                	jmp    8013c4 <strncmp+0x25>
		n--, p++, q++;
  8013b5:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013bf:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013c4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013c9:	74 1d                	je     8013e8 <strncmp+0x49>
  8013cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cf:	0f b6 00             	movzbl (%rax),%eax
  8013d2:	84 c0                	test   %al,%al
  8013d4:	74 12                	je     8013e8 <strncmp+0x49>
  8013d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013da:	0f b6 10             	movzbl (%rax),%edx
  8013dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e1:	0f b6 00             	movzbl (%rax),%eax
  8013e4:	38 c2                	cmp    %al,%dl
  8013e6:	74 cd                	je     8013b5 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ed:	75 07                	jne    8013f6 <strncmp+0x57>
		return 0;
  8013ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f4:	eb 18                	jmp    80140e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fa:	0f b6 00             	movzbl (%rax),%eax
  8013fd:	0f b6 d0             	movzbl %al,%edx
  801400:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801404:	0f b6 00             	movzbl (%rax),%eax
  801407:	0f b6 c0             	movzbl %al,%eax
  80140a:	29 c2                	sub    %eax,%edx
  80140c:	89 d0                	mov    %edx,%eax
}
  80140e:	c9                   	leaveq 
  80140f:	c3                   	retq   

0000000000801410 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801410:	55                   	push   %rbp
  801411:	48 89 e5             	mov    %rsp,%rbp
  801414:	48 83 ec 0c          	sub    $0xc,%rsp
  801418:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80141c:	89 f0                	mov    %esi,%eax
  80141e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801421:	eb 17                	jmp    80143a <strchr+0x2a>
		if (*s == c)
  801423:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801427:	0f b6 00             	movzbl (%rax),%eax
  80142a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80142d:	75 06                	jne    801435 <strchr+0x25>
			return (char *) s;
  80142f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801433:	eb 15                	jmp    80144a <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801435:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80143a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143e:	0f b6 00             	movzbl (%rax),%eax
  801441:	84 c0                	test   %al,%al
  801443:	75 de                	jne    801423 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801445:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144a:	c9                   	leaveq 
  80144b:	c3                   	retq   

000000000080144c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80144c:	55                   	push   %rbp
  80144d:	48 89 e5             	mov    %rsp,%rbp
  801450:	48 83 ec 0c          	sub    $0xc,%rsp
  801454:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801458:	89 f0                	mov    %esi,%eax
  80145a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80145d:	eb 13                	jmp    801472 <strfind+0x26>
		if (*s == c)
  80145f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801463:	0f b6 00             	movzbl (%rax),%eax
  801466:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801469:	75 02                	jne    80146d <strfind+0x21>
			break;
  80146b:	eb 10                	jmp    80147d <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80146d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801472:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801476:	0f b6 00             	movzbl (%rax),%eax
  801479:	84 c0                	test   %al,%al
  80147b:	75 e2                	jne    80145f <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80147d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801481:	c9                   	leaveq 
  801482:	c3                   	retq   

0000000000801483 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801483:	55                   	push   %rbp
  801484:	48 89 e5             	mov    %rsp,%rbp
  801487:	48 83 ec 18          	sub    $0x18,%rsp
  80148b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80148f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801492:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801496:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80149b:	75 06                	jne    8014a3 <memset+0x20>
		return v;
  80149d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a1:	eb 69                	jmp    80150c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a7:	83 e0 03             	and    $0x3,%eax
  8014aa:	48 85 c0             	test   %rax,%rax
  8014ad:	75 48                	jne    8014f7 <memset+0x74>
  8014af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b3:	83 e0 03             	and    $0x3,%eax
  8014b6:	48 85 c0             	test   %rax,%rax
  8014b9:	75 3c                	jne    8014f7 <memset+0x74>
		c &= 0xFF;
  8014bb:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014c2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014c5:	c1 e0 18             	shl    $0x18,%eax
  8014c8:	89 c2                	mov    %eax,%edx
  8014ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014cd:	c1 e0 10             	shl    $0x10,%eax
  8014d0:	09 c2                	or     %eax,%edx
  8014d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014d5:	c1 e0 08             	shl    $0x8,%eax
  8014d8:	09 d0                	or     %edx,%eax
  8014da:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8014dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e1:	48 c1 e8 02          	shr    $0x2,%rax
  8014e5:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ef:	48 89 d7             	mov    %rdx,%rdi
  8014f2:	fc                   	cld    
  8014f3:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014f5:	eb 11                	jmp    801508 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014f7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014fe:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801502:	48 89 d7             	mov    %rdx,%rdi
  801505:	fc                   	cld    
  801506:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80150c:	c9                   	leaveq 
  80150d:	c3                   	retq   

000000000080150e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80150e:	55                   	push   %rbp
  80150f:	48 89 e5             	mov    %rsp,%rbp
  801512:	48 83 ec 28          	sub    $0x28,%rsp
  801516:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80151a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80151e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801522:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801526:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80152a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80152e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801532:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801536:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80153a:	0f 83 88 00 00 00    	jae    8015c8 <memmove+0xba>
  801540:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801544:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801548:	48 01 d0             	add    %rdx,%rax
  80154b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80154f:	76 77                	jbe    8015c8 <memmove+0xba>
		s += n;
  801551:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801555:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801559:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801561:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801565:	83 e0 03             	and    $0x3,%eax
  801568:	48 85 c0             	test   %rax,%rax
  80156b:	75 3b                	jne    8015a8 <memmove+0x9a>
  80156d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801571:	83 e0 03             	and    $0x3,%eax
  801574:	48 85 c0             	test   %rax,%rax
  801577:	75 2f                	jne    8015a8 <memmove+0x9a>
  801579:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157d:	83 e0 03             	and    $0x3,%eax
  801580:	48 85 c0             	test   %rax,%rax
  801583:	75 23                	jne    8015a8 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801589:	48 83 e8 04          	sub    $0x4,%rax
  80158d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801591:	48 83 ea 04          	sub    $0x4,%rdx
  801595:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801599:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80159d:	48 89 c7             	mov    %rax,%rdi
  8015a0:	48 89 d6             	mov    %rdx,%rsi
  8015a3:	fd                   	std    
  8015a4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015a6:	eb 1d                	jmp    8015c5 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ac:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b4:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bc:	48 89 d7             	mov    %rdx,%rdi
  8015bf:	48 89 c1             	mov    %rax,%rcx
  8015c2:	fd                   	std    
  8015c3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015c5:	fc                   	cld    
  8015c6:	eb 57                	jmp    80161f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015cc:	83 e0 03             	and    $0x3,%eax
  8015cf:	48 85 c0             	test   %rax,%rax
  8015d2:	75 36                	jne    80160a <memmove+0xfc>
  8015d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d8:	83 e0 03             	and    $0x3,%eax
  8015db:	48 85 c0             	test   %rax,%rax
  8015de:	75 2a                	jne    80160a <memmove+0xfc>
  8015e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e4:	83 e0 03             	and    $0x3,%eax
  8015e7:	48 85 c0             	test   %rax,%rax
  8015ea:	75 1e                	jne    80160a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f0:	48 c1 e8 02          	shr    $0x2,%rax
  8015f4:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015fb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ff:	48 89 c7             	mov    %rax,%rdi
  801602:	48 89 d6             	mov    %rdx,%rsi
  801605:	fc                   	cld    
  801606:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801608:	eb 15                	jmp    80161f <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80160a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801612:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801616:	48 89 c7             	mov    %rax,%rdi
  801619:	48 89 d6             	mov    %rdx,%rsi
  80161c:	fc                   	cld    
  80161d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80161f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801623:	c9                   	leaveq 
  801624:	c3                   	retq   

0000000000801625 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801625:	55                   	push   %rbp
  801626:	48 89 e5             	mov    %rsp,%rbp
  801629:	48 83 ec 18          	sub    $0x18,%rsp
  80162d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801631:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801635:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801639:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80163d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801641:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801645:	48 89 ce             	mov    %rcx,%rsi
  801648:	48 89 c7             	mov    %rax,%rdi
  80164b:	48 b8 0e 15 80 00 00 	movabs $0x80150e,%rax
  801652:	00 00 00 
  801655:	ff d0                	callq  *%rax
}
  801657:	c9                   	leaveq 
  801658:	c3                   	retq   

0000000000801659 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801659:	55                   	push   %rbp
  80165a:	48 89 e5             	mov    %rsp,%rbp
  80165d:	48 83 ec 28          	sub    $0x28,%rsp
  801661:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801665:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801669:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80166d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801671:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801675:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801679:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80167d:	eb 36                	jmp    8016b5 <memcmp+0x5c>
		if (*s1 != *s2)
  80167f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801683:	0f b6 10             	movzbl (%rax),%edx
  801686:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80168a:	0f b6 00             	movzbl (%rax),%eax
  80168d:	38 c2                	cmp    %al,%dl
  80168f:	74 1a                	je     8016ab <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801691:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801695:	0f b6 00             	movzbl (%rax),%eax
  801698:	0f b6 d0             	movzbl %al,%edx
  80169b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169f:	0f b6 00             	movzbl (%rax),%eax
  8016a2:	0f b6 c0             	movzbl %al,%eax
  8016a5:	29 c2                	sub    %eax,%edx
  8016a7:	89 d0                	mov    %edx,%eax
  8016a9:	eb 20                	jmp    8016cb <memcmp+0x72>
		s1++, s2++;
  8016ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016b0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016bd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016c1:	48 85 c0             	test   %rax,%rax
  8016c4:	75 b9                	jne    80167f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016cb:	c9                   	leaveq 
  8016cc:	c3                   	retq   

00000000008016cd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016cd:	55                   	push   %rbp
  8016ce:	48 89 e5             	mov    %rsp,%rbp
  8016d1:	48 83 ec 28          	sub    $0x28,%rsp
  8016d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016d9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016e8:	48 01 d0             	add    %rdx,%rax
  8016eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016ef:	eb 15                	jmp    801706 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016f5:	0f b6 10             	movzbl (%rax),%edx
  8016f8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8016fb:	38 c2                	cmp    %al,%dl
  8016fd:	75 02                	jne    801701 <memfind+0x34>
			break;
  8016ff:	eb 0f                	jmp    801710 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801701:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801706:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80170a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80170e:	72 e1                	jb     8016f1 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801710:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801714:	c9                   	leaveq 
  801715:	c3                   	retq   

0000000000801716 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801716:	55                   	push   %rbp
  801717:	48 89 e5             	mov    %rsp,%rbp
  80171a:	48 83 ec 34          	sub    $0x34,%rsp
  80171e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801722:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801726:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801729:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801730:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801737:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801738:	eb 05                	jmp    80173f <strtol+0x29>
		s++;
  80173a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80173f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801743:	0f b6 00             	movzbl (%rax),%eax
  801746:	3c 20                	cmp    $0x20,%al
  801748:	74 f0                	je     80173a <strtol+0x24>
  80174a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174e:	0f b6 00             	movzbl (%rax),%eax
  801751:	3c 09                	cmp    $0x9,%al
  801753:	74 e5                	je     80173a <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801755:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801759:	0f b6 00             	movzbl (%rax),%eax
  80175c:	3c 2b                	cmp    $0x2b,%al
  80175e:	75 07                	jne    801767 <strtol+0x51>
		s++;
  801760:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801765:	eb 17                	jmp    80177e <strtol+0x68>
	else if (*s == '-')
  801767:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176b:	0f b6 00             	movzbl (%rax),%eax
  80176e:	3c 2d                	cmp    $0x2d,%al
  801770:	75 0c                	jne    80177e <strtol+0x68>
		s++, neg = 1;
  801772:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801777:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80177e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801782:	74 06                	je     80178a <strtol+0x74>
  801784:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801788:	75 28                	jne    8017b2 <strtol+0x9c>
  80178a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178e:	0f b6 00             	movzbl (%rax),%eax
  801791:	3c 30                	cmp    $0x30,%al
  801793:	75 1d                	jne    8017b2 <strtol+0x9c>
  801795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801799:	48 83 c0 01          	add    $0x1,%rax
  80179d:	0f b6 00             	movzbl (%rax),%eax
  8017a0:	3c 78                	cmp    $0x78,%al
  8017a2:	75 0e                	jne    8017b2 <strtol+0x9c>
		s += 2, base = 16;
  8017a4:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017a9:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017b0:	eb 2c                	jmp    8017de <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017b2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017b6:	75 19                	jne    8017d1 <strtol+0xbb>
  8017b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bc:	0f b6 00             	movzbl (%rax),%eax
  8017bf:	3c 30                	cmp    $0x30,%al
  8017c1:	75 0e                	jne    8017d1 <strtol+0xbb>
		s++, base = 8;
  8017c3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017c8:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017cf:	eb 0d                	jmp    8017de <strtol+0xc8>
	else if (base == 0)
  8017d1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017d5:	75 07                	jne    8017de <strtol+0xc8>
		base = 10;
  8017d7:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e2:	0f b6 00             	movzbl (%rax),%eax
  8017e5:	3c 2f                	cmp    $0x2f,%al
  8017e7:	7e 1d                	jle    801806 <strtol+0xf0>
  8017e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ed:	0f b6 00             	movzbl (%rax),%eax
  8017f0:	3c 39                	cmp    $0x39,%al
  8017f2:	7f 12                	jg     801806 <strtol+0xf0>
			dig = *s - '0';
  8017f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f8:	0f b6 00             	movzbl (%rax),%eax
  8017fb:	0f be c0             	movsbl %al,%eax
  8017fe:	83 e8 30             	sub    $0x30,%eax
  801801:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801804:	eb 4e                	jmp    801854 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801806:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180a:	0f b6 00             	movzbl (%rax),%eax
  80180d:	3c 60                	cmp    $0x60,%al
  80180f:	7e 1d                	jle    80182e <strtol+0x118>
  801811:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801815:	0f b6 00             	movzbl (%rax),%eax
  801818:	3c 7a                	cmp    $0x7a,%al
  80181a:	7f 12                	jg     80182e <strtol+0x118>
			dig = *s - 'a' + 10;
  80181c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801820:	0f b6 00             	movzbl (%rax),%eax
  801823:	0f be c0             	movsbl %al,%eax
  801826:	83 e8 57             	sub    $0x57,%eax
  801829:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80182c:	eb 26                	jmp    801854 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80182e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801832:	0f b6 00             	movzbl (%rax),%eax
  801835:	3c 40                	cmp    $0x40,%al
  801837:	7e 48                	jle    801881 <strtol+0x16b>
  801839:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183d:	0f b6 00             	movzbl (%rax),%eax
  801840:	3c 5a                	cmp    $0x5a,%al
  801842:	7f 3d                	jg     801881 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801844:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801848:	0f b6 00             	movzbl (%rax),%eax
  80184b:	0f be c0             	movsbl %al,%eax
  80184e:	83 e8 37             	sub    $0x37,%eax
  801851:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801854:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801857:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80185a:	7c 02                	jl     80185e <strtol+0x148>
			break;
  80185c:	eb 23                	jmp    801881 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80185e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801863:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801866:	48 98                	cltq   
  801868:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80186d:	48 89 c2             	mov    %rax,%rdx
  801870:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801873:	48 98                	cltq   
  801875:	48 01 d0             	add    %rdx,%rax
  801878:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80187c:	e9 5d ff ff ff       	jmpq   8017de <strtol+0xc8>

	if (endptr)
  801881:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801886:	74 0b                	je     801893 <strtol+0x17d>
		*endptr = (char *) s;
  801888:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80188c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801890:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801893:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801897:	74 09                	je     8018a2 <strtol+0x18c>
  801899:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80189d:	48 f7 d8             	neg    %rax
  8018a0:	eb 04                	jmp    8018a6 <strtol+0x190>
  8018a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018a6:	c9                   	leaveq 
  8018a7:	c3                   	retq   

00000000008018a8 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018a8:	55                   	push   %rbp
  8018a9:	48 89 e5             	mov    %rsp,%rbp
  8018ac:	48 83 ec 30          	sub    $0x30,%rsp
  8018b0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018b4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8018b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018bc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018c0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018c4:	0f b6 00             	movzbl (%rax),%eax
  8018c7:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8018ca:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018ce:	75 06                	jne    8018d6 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8018d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d4:	eb 6b                	jmp    801941 <strstr+0x99>

    len = strlen(str);
  8018d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018da:	48 89 c7             	mov    %rax,%rdi
  8018dd:	48 b8 7e 11 80 00 00 	movabs $0x80117e,%rax
  8018e4:	00 00 00 
  8018e7:	ff d0                	callq  *%rax
  8018e9:	48 98                	cltq   
  8018eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8018ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018f7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018fb:	0f b6 00             	movzbl (%rax),%eax
  8018fe:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801901:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801905:	75 07                	jne    80190e <strstr+0x66>
                return (char *) 0;
  801907:	b8 00 00 00 00       	mov    $0x0,%eax
  80190c:	eb 33                	jmp    801941 <strstr+0x99>
        } while (sc != c);
  80190e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801912:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801915:	75 d8                	jne    8018ef <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801917:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80191b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80191f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801923:	48 89 ce             	mov    %rcx,%rsi
  801926:	48 89 c7             	mov    %rax,%rdi
  801929:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  801930:	00 00 00 
  801933:	ff d0                	callq  *%rax
  801935:	85 c0                	test   %eax,%eax
  801937:	75 b6                	jne    8018ef <strstr+0x47>

    return (char *) (in - 1);
  801939:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193d:	48 83 e8 01          	sub    $0x1,%rax
}
  801941:	c9                   	leaveq 
  801942:	c3                   	retq   

0000000000801943 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801943:	55                   	push   %rbp
  801944:	48 89 e5             	mov    %rsp,%rbp
  801947:	53                   	push   %rbx
  801948:	48 83 ec 48          	sub    $0x48,%rsp
  80194c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80194f:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801952:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801956:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80195a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80195e:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801962:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801965:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801969:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80196d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801971:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801975:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801979:	4c 89 c3             	mov    %r8,%rbx
  80197c:	cd 30                	int    $0x30
  80197e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801982:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801986:	74 3e                	je     8019c6 <syscall+0x83>
  801988:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80198d:	7e 37                	jle    8019c6 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80198f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801993:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801996:	49 89 d0             	mov    %rdx,%r8
  801999:	89 c1                	mov    %eax,%ecx
  80199b:	48 ba 60 3c 80 00 00 	movabs $0x803c60,%rdx
  8019a2:	00 00 00 
  8019a5:	be 23 00 00 00       	mov    $0x23,%esi
  8019aa:	48 bf 7d 3c 80 00 00 	movabs $0x803c7d,%rdi
  8019b1:	00 00 00 
  8019b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b9:	49 b9 09 02 80 00 00 	movabs $0x800209,%r9
  8019c0:	00 00 00 
  8019c3:	41 ff d1             	callq  *%r9

	return ret;
  8019c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019ca:	48 83 c4 48          	add    $0x48,%rsp
  8019ce:	5b                   	pop    %rbx
  8019cf:	5d                   	pop    %rbp
  8019d0:	c3                   	retq   

00000000008019d1 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019d1:	55                   	push   %rbp
  8019d2:	48 89 e5             	mov    %rsp,%rbp
  8019d5:	48 83 ec 20          	sub    $0x20,%rsp
  8019d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019e9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f0:	00 
  8019f1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019fd:	48 89 d1             	mov    %rdx,%rcx
  801a00:	48 89 c2             	mov    %rax,%rdx
  801a03:	be 00 00 00 00       	mov    $0x0,%esi
  801a08:	bf 00 00 00 00       	mov    $0x0,%edi
  801a0d:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801a14:	00 00 00 
  801a17:	ff d0                	callq  *%rax
}
  801a19:	c9                   	leaveq 
  801a1a:	c3                   	retq   

0000000000801a1b <sys_cgetc>:

int
sys_cgetc(void)
{
  801a1b:	55                   	push   %rbp
  801a1c:	48 89 e5             	mov    %rsp,%rbp
  801a1f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a23:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a2a:	00 
  801a2b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a31:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a37:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a41:	be 00 00 00 00       	mov    $0x0,%esi
  801a46:	bf 01 00 00 00       	mov    $0x1,%edi
  801a4b:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801a52:	00 00 00 
  801a55:	ff d0                	callq  *%rax
}
  801a57:	c9                   	leaveq 
  801a58:	c3                   	retq   

0000000000801a59 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a59:	55                   	push   %rbp
  801a5a:	48 89 e5             	mov    %rsp,%rbp
  801a5d:	48 83 ec 10          	sub    $0x10,%rsp
  801a61:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a67:	48 98                	cltq   
  801a69:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a70:	00 
  801a71:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a77:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a7d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a82:	48 89 c2             	mov    %rax,%rdx
  801a85:	be 01 00 00 00       	mov    $0x1,%esi
  801a8a:	bf 03 00 00 00       	mov    $0x3,%edi
  801a8f:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801a96:	00 00 00 
  801a99:	ff d0                	callq  *%rax
}
  801a9b:	c9                   	leaveq 
  801a9c:	c3                   	retq   

0000000000801a9d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a9d:	55                   	push   %rbp
  801a9e:	48 89 e5             	mov    %rsp,%rbp
  801aa1:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801aa5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aac:	00 
  801aad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ab9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801abe:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac3:	be 00 00 00 00       	mov    $0x0,%esi
  801ac8:	bf 02 00 00 00       	mov    $0x2,%edi
  801acd:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801ad4:	00 00 00 
  801ad7:	ff d0                	callq  *%rax
}
  801ad9:	c9                   	leaveq 
  801ada:	c3                   	retq   

0000000000801adb <sys_yield>:

void
sys_yield(void)
{
  801adb:	55                   	push   %rbp
  801adc:	48 89 e5             	mov    %rsp,%rbp
  801adf:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ae3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aea:	00 
  801aeb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801afc:	ba 00 00 00 00       	mov    $0x0,%edx
  801b01:	be 00 00 00 00       	mov    $0x0,%esi
  801b06:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b0b:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801b12:	00 00 00 
  801b15:	ff d0                	callq  *%rax
}
  801b17:	c9                   	leaveq 
  801b18:	c3                   	retq   

0000000000801b19 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b19:	55                   	push   %rbp
  801b1a:	48 89 e5             	mov    %rsp,%rbp
  801b1d:	48 83 ec 20          	sub    $0x20,%rsp
  801b21:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b24:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b28:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b2b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b2e:	48 63 c8             	movslq %eax,%rcx
  801b31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b38:	48 98                	cltq   
  801b3a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b41:	00 
  801b42:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b48:	49 89 c8             	mov    %rcx,%r8
  801b4b:	48 89 d1             	mov    %rdx,%rcx
  801b4e:	48 89 c2             	mov    %rax,%rdx
  801b51:	be 01 00 00 00       	mov    $0x1,%esi
  801b56:	bf 04 00 00 00       	mov    $0x4,%edi
  801b5b:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801b62:	00 00 00 
  801b65:	ff d0                	callq  *%rax
}
  801b67:	c9                   	leaveq 
  801b68:	c3                   	retq   

0000000000801b69 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b69:	55                   	push   %rbp
  801b6a:	48 89 e5             	mov    %rsp,%rbp
  801b6d:	48 83 ec 30          	sub    $0x30,%rsp
  801b71:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b74:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b78:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b7b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b7f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b83:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b86:	48 63 c8             	movslq %eax,%rcx
  801b89:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b8d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b90:	48 63 f0             	movslq %eax,%rsi
  801b93:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b9a:	48 98                	cltq   
  801b9c:	48 89 0c 24          	mov    %rcx,(%rsp)
  801ba0:	49 89 f9             	mov    %rdi,%r9
  801ba3:	49 89 f0             	mov    %rsi,%r8
  801ba6:	48 89 d1             	mov    %rdx,%rcx
  801ba9:	48 89 c2             	mov    %rax,%rdx
  801bac:	be 01 00 00 00       	mov    $0x1,%esi
  801bb1:	bf 05 00 00 00       	mov    $0x5,%edi
  801bb6:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801bbd:	00 00 00 
  801bc0:	ff d0                	callq  *%rax
}
  801bc2:	c9                   	leaveq 
  801bc3:	c3                   	retq   

0000000000801bc4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bc4:	55                   	push   %rbp
  801bc5:	48 89 e5             	mov    %rsp,%rbp
  801bc8:	48 83 ec 20          	sub    $0x20,%rsp
  801bcc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bcf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bd3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bda:	48 98                	cltq   
  801bdc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801be3:	00 
  801be4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bf0:	48 89 d1             	mov    %rdx,%rcx
  801bf3:	48 89 c2             	mov    %rax,%rdx
  801bf6:	be 01 00 00 00       	mov    $0x1,%esi
  801bfb:	bf 06 00 00 00       	mov    $0x6,%edi
  801c00:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801c07:	00 00 00 
  801c0a:	ff d0                	callq  *%rax
}
  801c0c:	c9                   	leaveq 
  801c0d:	c3                   	retq   

0000000000801c0e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c0e:	55                   	push   %rbp
  801c0f:	48 89 e5             	mov    %rsp,%rbp
  801c12:	48 83 ec 10          	sub    $0x10,%rsp
  801c16:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c19:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c1c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c1f:	48 63 d0             	movslq %eax,%rdx
  801c22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c25:	48 98                	cltq   
  801c27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c2e:	00 
  801c2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c3b:	48 89 d1             	mov    %rdx,%rcx
  801c3e:	48 89 c2             	mov    %rax,%rdx
  801c41:	be 01 00 00 00       	mov    $0x1,%esi
  801c46:	bf 08 00 00 00       	mov    $0x8,%edi
  801c4b:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801c52:	00 00 00 
  801c55:	ff d0                	callq  *%rax
}
  801c57:	c9                   	leaveq 
  801c58:	c3                   	retq   

0000000000801c59 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c59:	55                   	push   %rbp
  801c5a:	48 89 e5             	mov    %rsp,%rbp
  801c5d:	48 83 ec 20          	sub    $0x20,%rsp
  801c61:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c64:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c68:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c6f:	48 98                	cltq   
  801c71:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c78:	00 
  801c79:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c7f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c85:	48 89 d1             	mov    %rdx,%rcx
  801c88:	48 89 c2             	mov    %rax,%rdx
  801c8b:	be 01 00 00 00       	mov    $0x1,%esi
  801c90:	bf 09 00 00 00       	mov    $0x9,%edi
  801c95:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801c9c:	00 00 00 
  801c9f:	ff d0                	callq  *%rax
}
  801ca1:	c9                   	leaveq 
  801ca2:	c3                   	retq   

0000000000801ca3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ca3:	55                   	push   %rbp
  801ca4:	48 89 e5             	mov    %rsp,%rbp
  801ca7:	48 83 ec 20          	sub    $0x20,%rsp
  801cab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cb2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb9:	48 98                	cltq   
  801cbb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cc2:	00 
  801cc3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cc9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ccf:	48 89 d1             	mov    %rdx,%rcx
  801cd2:	48 89 c2             	mov    %rax,%rdx
  801cd5:	be 01 00 00 00       	mov    $0x1,%esi
  801cda:	bf 0a 00 00 00       	mov    $0xa,%edi
  801cdf:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801ce6:	00 00 00 
  801ce9:	ff d0                	callq  *%rax
}
  801ceb:	c9                   	leaveq 
  801cec:	c3                   	retq   

0000000000801ced <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ced:	55                   	push   %rbp
  801cee:	48 89 e5             	mov    %rsp,%rbp
  801cf1:	48 83 ec 20          	sub    $0x20,%rsp
  801cf5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cf8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cfc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d00:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d06:	48 63 f0             	movslq %eax,%rsi
  801d09:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d10:	48 98                	cltq   
  801d12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d16:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d1d:	00 
  801d1e:	49 89 f1             	mov    %rsi,%r9
  801d21:	49 89 c8             	mov    %rcx,%r8
  801d24:	48 89 d1             	mov    %rdx,%rcx
  801d27:	48 89 c2             	mov    %rax,%rdx
  801d2a:	be 00 00 00 00       	mov    $0x0,%esi
  801d2f:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d34:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801d3b:	00 00 00 
  801d3e:	ff d0                	callq  *%rax
}
  801d40:	c9                   	leaveq 
  801d41:	c3                   	retq   

0000000000801d42 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d42:	55                   	push   %rbp
  801d43:	48 89 e5             	mov    %rsp,%rbp
  801d46:	48 83 ec 10          	sub    $0x10,%rsp
  801d4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d52:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d59:	00 
  801d5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d6b:	48 89 c2             	mov    %rax,%rdx
  801d6e:	be 01 00 00 00       	mov    $0x1,%esi
  801d73:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d78:	48 b8 43 19 80 00 00 	movabs $0x801943,%rax
  801d7f:	00 00 00 
  801d82:	ff d0                	callq  *%rax
}
  801d84:	c9                   	leaveq 
  801d85:	c3                   	retq   

0000000000801d86 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801d86:	55                   	push   %rbp
  801d87:	48 89 e5             	mov    %rsp,%rbp
  801d8a:	48 83 ec 10          	sub    $0x10,%rsp
  801d8e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  801d92:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801d99:	00 00 00 
  801d9c:	48 8b 00             	mov    (%rax),%rax
  801d9f:	48 85 c0             	test   %rax,%rax
  801da2:	75 3a                	jne    801dde <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  801da4:	ba 07 00 00 00       	mov    $0x7,%edx
  801da9:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801dae:	bf 00 00 00 00       	mov    $0x0,%edi
  801db3:	48 b8 19 1b 80 00 00 	movabs $0x801b19,%rax
  801dba:	00 00 00 
  801dbd:	ff d0                	callq  *%rax
  801dbf:	85 c0                	test   %eax,%eax
  801dc1:	75 1b                	jne    801dde <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801dc3:	48 be f1 1d 80 00 00 	movabs $0x801df1,%rsi
  801dca:	00 00 00 
  801dcd:	bf 00 00 00 00       	mov    $0x0,%edi
  801dd2:	48 b8 a3 1c 80 00 00 	movabs $0x801ca3,%rax
  801dd9:	00 00 00 
  801ddc:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801dde:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801de5:	00 00 00 
  801de8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dec:	48 89 10             	mov    %rdx,(%rax)
}
  801def:	c9                   	leaveq 
  801df0:	c3                   	retq   

0000000000801df1 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  801df1:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  801df4:	48 a1 10 60 80 00 00 	movabs 0x806010,%rax
  801dfb:	00 00 00 
	call *%rax
  801dfe:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  801e00:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  801e03:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801e0a:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  801e0b:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  801e12:	00 
	pushq %rbx		// push utf_rip into new stack
  801e13:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  801e14:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  801e1b:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  801e1e:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  801e22:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  801e26:	4c 8b 3c 24          	mov    (%rsp),%r15
  801e2a:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801e2f:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801e34:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801e39:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801e3e:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801e43:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801e48:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801e4d:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801e52:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801e57:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801e5c:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801e61:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801e66:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801e6b:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801e70:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  801e74:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  801e78:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  801e79:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801e7a:	c3                   	retq   

0000000000801e7b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e7b:	55                   	push   %rbp
  801e7c:	48 89 e5             	mov    %rsp,%rbp
  801e7f:	48 83 ec 08          	sub    $0x8,%rsp
  801e83:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e87:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e8b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e92:	ff ff ff 
  801e95:	48 01 d0             	add    %rdx,%rax
  801e98:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e9c:	c9                   	leaveq 
  801e9d:	c3                   	retq   

0000000000801e9e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e9e:	55                   	push   %rbp
  801e9f:	48 89 e5             	mov    %rsp,%rbp
  801ea2:	48 83 ec 08          	sub    $0x8,%rsp
  801ea6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801eaa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eae:	48 89 c7             	mov    %rax,%rdi
  801eb1:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  801eb8:	00 00 00 
  801ebb:	ff d0                	callq  *%rax
  801ebd:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ec3:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ec7:	c9                   	leaveq 
  801ec8:	c3                   	retq   

0000000000801ec9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ec9:	55                   	push   %rbp
  801eca:	48 89 e5             	mov    %rsp,%rbp
  801ecd:	48 83 ec 18          	sub    $0x18,%rsp
  801ed1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ed5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801edc:	eb 6b                	jmp    801f49 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ede:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee1:	48 98                	cltq   
  801ee3:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ee9:	48 c1 e0 0c          	shl    $0xc,%rax
  801eed:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ef1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ef5:	48 c1 e8 15          	shr    $0x15,%rax
  801ef9:	48 89 c2             	mov    %rax,%rdx
  801efc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f03:	01 00 00 
  801f06:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f0a:	83 e0 01             	and    $0x1,%eax
  801f0d:	48 85 c0             	test   %rax,%rax
  801f10:	74 21                	je     801f33 <fd_alloc+0x6a>
  801f12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f16:	48 c1 e8 0c          	shr    $0xc,%rax
  801f1a:	48 89 c2             	mov    %rax,%rdx
  801f1d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f24:	01 00 00 
  801f27:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f2b:	83 e0 01             	and    $0x1,%eax
  801f2e:	48 85 c0             	test   %rax,%rax
  801f31:	75 12                	jne    801f45 <fd_alloc+0x7c>
			*fd_store = fd;
  801f33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f3b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f43:	eb 1a                	jmp    801f5f <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f45:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f49:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f4d:	7e 8f                	jle    801ede <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f53:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f5a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f5f:	c9                   	leaveq 
  801f60:	c3                   	retq   

0000000000801f61 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f61:	55                   	push   %rbp
  801f62:	48 89 e5             	mov    %rsp,%rbp
  801f65:	48 83 ec 20          	sub    $0x20,%rsp
  801f69:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f6c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f70:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f74:	78 06                	js     801f7c <fd_lookup+0x1b>
  801f76:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f7a:	7e 07                	jle    801f83 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f81:	eb 6c                	jmp    801fef <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f83:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f86:	48 98                	cltq   
  801f88:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f8e:	48 c1 e0 0c          	shl    $0xc,%rax
  801f92:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f9a:	48 c1 e8 15          	shr    $0x15,%rax
  801f9e:	48 89 c2             	mov    %rax,%rdx
  801fa1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fa8:	01 00 00 
  801fab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801faf:	83 e0 01             	and    $0x1,%eax
  801fb2:	48 85 c0             	test   %rax,%rax
  801fb5:	74 21                	je     801fd8 <fd_lookup+0x77>
  801fb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fbb:	48 c1 e8 0c          	shr    $0xc,%rax
  801fbf:	48 89 c2             	mov    %rax,%rdx
  801fc2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc9:	01 00 00 
  801fcc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fd0:	83 e0 01             	and    $0x1,%eax
  801fd3:	48 85 c0             	test   %rax,%rax
  801fd6:	75 07                	jne    801fdf <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fd8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fdd:	eb 10                	jmp    801fef <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801fdf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fe3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fe7:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fef:	c9                   	leaveq 
  801ff0:	c3                   	retq   

0000000000801ff1 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ff1:	55                   	push   %rbp
  801ff2:	48 89 e5             	mov    %rsp,%rbp
  801ff5:	48 83 ec 30          	sub    $0x30,%rsp
  801ff9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ffd:	89 f0                	mov    %esi,%eax
  801fff:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802002:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802006:	48 89 c7             	mov    %rax,%rdi
  802009:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  802010:	00 00 00 
  802013:	ff d0                	callq  *%rax
  802015:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802019:	48 89 d6             	mov    %rdx,%rsi
  80201c:	89 c7                	mov    %eax,%edi
  80201e:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  802025:	00 00 00 
  802028:	ff d0                	callq  *%rax
  80202a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80202d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802031:	78 0a                	js     80203d <fd_close+0x4c>
	    || fd != fd2)
  802033:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802037:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80203b:	74 12                	je     80204f <fd_close+0x5e>
		return (must_exist ? r : 0);
  80203d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802041:	74 05                	je     802048 <fd_close+0x57>
  802043:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802046:	eb 05                	jmp    80204d <fd_close+0x5c>
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
  80204d:	eb 69                	jmp    8020b8 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80204f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802053:	8b 00                	mov    (%rax),%eax
  802055:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802059:	48 89 d6             	mov    %rdx,%rsi
  80205c:	89 c7                	mov    %eax,%edi
  80205e:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  802065:	00 00 00 
  802068:	ff d0                	callq  *%rax
  80206a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80206d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802071:	78 2a                	js     80209d <fd_close+0xac>
		if (dev->dev_close)
  802073:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802077:	48 8b 40 20          	mov    0x20(%rax),%rax
  80207b:	48 85 c0             	test   %rax,%rax
  80207e:	74 16                	je     802096 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802080:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802084:	48 8b 40 20          	mov    0x20(%rax),%rax
  802088:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80208c:	48 89 d7             	mov    %rdx,%rdi
  80208f:	ff d0                	callq  *%rax
  802091:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802094:	eb 07                	jmp    80209d <fd_close+0xac>
		else
			r = 0;
  802096:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80209d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020a1:	48 89 c6             	mov    %rax,%rsi
  8020a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a9:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  8020b0:	00 00 00 
  8020b3:	ff d0                	callq  *%rax
	return r;
  8020b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020b8:	c9                   	leaveq 
  8020b9:	c3                   	retq   

00000000008020ba <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020ba:	55                   	push   %rbp
  8020bb:	48 89 e5             	mov    %rsp,%rbp
  8020be:	48 83 ec 20          	sub    $0x20,%rsp
  8020c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020d0:	eb 41                	jmp    802113 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020d2:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8020d9:	00 00 00 
  8020dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020df:	48 63 d2             	movslq %edx,%rdx
  8020e2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e6:	8b 00                	mov    (%rax),%eax
  8020e8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8020eb:	75 22                	jne    80210f <dev_lookup+0x55>
			*dev = devtab[i];
  8020ed:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8020f4:	00 00 00 
  8020f7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020fa:	48 63 d2             	movslq %edx,%rdx
  8020fd:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802101:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802105:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802108:	b8 00 00 00 00       	mov    $0x0,%eax
  80210d:	eb 60                	jmp    80216f <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80210f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802113:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80211a:	00 00 00 
  80211d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802120:	48 63 d2             	movslq %edx,%rdx
  802123:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802127:	48 85 c0             	test   %rax,%rax
  80212a:	75 a6                	jne    8020d2 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80212c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802133:	00 00 00 
  802136:	48 8b 00             	mov    (%rax),%rax
  802139:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80213f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802142:	89 c6                	mov    %eax,%esi
  802144:	48 bf 90 3c 80 00 00 	movabs $0x803c90,%rdi
  80214b:	00 00 00 
  80214e:	b8 00 00 00 00       	mov    $0x0,%eax
  802153:	48 b9 42 04 80 00 00 	movabs $0x800442,%rcx
  80215a:	00 00 00 
  80215d:	ff d1                	callq  *%rcx
	*dev = 0;
  80215f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802163:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80216a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80216f:	c9                   	leaveq 
  802170:	c3                   	retq   

0000000000802171 <close>:

int
close(int fdnum)
{
  802171:	55                   	push   %rbp
  802172:	48 89 e5             	mov    %rsp,%rbp
  802175:	48 83 ec 20          	sub    $0x20,%rsp
  802179:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80217c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802180:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802183:	48 89 d6             	mov    %rdx,%rsi
  802186:	89 c7                	mov    %eax,%edi
  802188:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  80218f:	00 00 00 
  802192:	ff d0                	callq  *%rax
  802194:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802197:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80219b:	79 05                	jns    8021a2 <close+0x31>
		return r;
  80219d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a0:	eb 18                	jmp    8021ba <close+0x49>
	else
		return fd_close(fd, 1);
  8021a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a6:	be 01 00 00 00       	mov    $0x1,%esi
  8021ab:	48 89 c7             	mov    %rax,%rdi
  8021ae:	48 b8 f1 1f 80 00 00 	movabs $0x801ff1,%rax
  8021b5:	00 00 00 
  8021b8:	ff d0                	callq  *%rax
}
  8021ba:	c9                   	leaveq 
  8021bb:	c3                   	retq   

00000000008021bc <close_all>:

void
close_all(void)
{
  8021bc:	55                   	push   %rbp
  8021bd:	48 89 e5             	mov    %rsp,%rbp
  8021c0:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021cb:	eb 15                	jmp    8021e2 <close_all+0x26>
		close(i);
  8021cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d0:	89 c7                	mov    %eax,%edi
  8021d2:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  8021d9:	00 00 00 
  8021dc:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8021de:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021e2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021e6:	7e e5                	jle    8021cd <close_all+0x11>
		close(i);
}
  8021e8:	c9                   	leaveq 
  8021e9:	c3                   	retq   

00000000008021ea <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021ea:	55                   	push   %rbp
  8021eb:	48 89 e5             	mov    %rsp,%rbp
  8021ee:	48 83 ec 40          	sub    $0x40,%rsp
  8021f2:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8021f5:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021f8:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8021fc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021ff:	48 89 d6             	mov    %rdx,%rsi
  802202:	89 c7                	mov    %eax,%edi
  802204:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  80220b:	00 00 00 
  80220e:	ff d0                	callq  *%rax
  802210:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802213:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802217:	79 08                	jns    802221 <dup+0x37>
		return r;
  802219:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80221c:	e9 70 01 00 00       	jmpq   802391 <dup+0x1a7>
	close(newfdnum);
  802221:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802224:	89 c7                	mov    %eax,%edi
  802226:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  80222d:	00 00 00 
  802230:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802232:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802235:	48 98                	cltq   
  802237:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80223d:	48 c1 e0 0c          	shl    $0xc,%rax
  802241:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802245:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802249:	48 89 c7             	mov    %rax,%rdi
  80224c:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  802253:	00 00 00 
  802256:	ff d0                	callq  *%rax
  802258:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80225c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802260:	48 89 c7             	mov    %rax,%rdi
  802263:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  80226a:	00 00 00 
  80226d:	ff d0                	callq  *%rax
  80226f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802273:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802277:	48 c1 e8 15          	shr    $0x15,%rax
  80227b:	48 89 c2             	mov    %rax,%rdx
  80227e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802285:	01 00 00 
  802288:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80228c:	83 e0 01             	and    $0x1,%eax
  80228f:	48 85 c0             	test   %rax,%rax
  802292:	74 73                	je     802307 <dup+0x11d>
  802294:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802298:	48 c1 e8 0c          	shr    $0xc,%rax
  80229c:	48 89 c2             	mov    %rax,%rdx
  80229f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022a6:	01 00 00 
  8022a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ad:	83 e0 01             	and    $0x1,%eax
  8022b0:	48 85 c0             	test   %rax,%rax
  8022b3:	74 52                	je     802307 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b9:	48 c1 e8 0c          	shr    $0xc,%rax
  8022bd:	48 89 c2             	mov    %rax,%rdx
  8022c0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022c7:	01 00 00 
  8022ca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ce:	25 07 0e 00 00       	and    $0xe07,%eax
  8022d3:	89 c1                	mov    %eax,%ecx
  8022d5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022dd:	41 89 c8             	mov    %ecx,%r8d
  8022e0:	48 89 d1             	mov    %rdx,%rcx
  8022e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e8:	48 89 c6             	mov    %rax,%rsi
  8022eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f0:	48 b8 69 1b 80 00 00 	movabs $0x801b69,%rax
  8022f7:	00 00 00 
  8022fa:	ff d0                	callq  *%rax
  8022fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802303:	79 02                	jns    802307 <dup+0x11d>
			goto err;
  802305:	eb 57                	jmp    80235e <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802307:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80230b:	48 c1 e8 0c          	shr    $0xc,%rax
  80230f:	48 89 c2             	mov    %rax,%rdx
  802312:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802319:	01 00 00 
  80231c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802320:	25 07 0e 00 00       	and    $0xe07,%eax
  802325:	89 c1                	mov    %eax,%ecx
  802327:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80232b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80232f:	41 89 c8             	mov    %ecx,%r8d
  802332:	48 89 d1             	mov    %rdx,%rcx
  802335:	ba 00 00 00 00       	mov    $0x0,%edx
  80233a:	48 89 c6             	mov    %rax,%rsi
  80233d:	bf 00 00 00 00       	mov    $0x0,%edi
  802342:	48 b8 69 1b 80 00 00 	movabs $0x801b69,%rax
  802349:	00 00 00 
  80234c:	ff d0                	callq  *%rax
  80234e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802351:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802355:	79 02                	jns    802359 <dup+0x16f>
		goto err;
  802357:	eb 05                	jmp    80235e <dup+0x174>

	return newfdnum;
  802359:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80235c:	eb 33                	jmp    802391 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80235e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802362:	48 89 c6             	mov    %rax,%rsi
  802365:	bf 00 00 00 00       	mov    $0x0,%edi
  80236a:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  802371:	00 00 00 
  802374:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802376:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80237a:	48 89 c6             	mov    %rax,%rsi
  80237d:	bf 00 00 00 00       	mov    $0x0,%edi
  802382:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  802389:	00 00 00 
  80238c:	ff d0                	callq  *%rax
	return r;
  80238e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802391:	c9                   	leaveq 
  802392:	c3                   	retq   

0000000000802393 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802393:	55                   	push   %rbp
  802394:	48 89 e5             	mov    %rsp,%rbp
  802397:	48 83 ec 40          	sub    $0x40,%rsp
  80239b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80239e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023a2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023a6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023aa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023ad:	48 89 d6             	mov    %rdx,%rsi
  8023b0:	89 c7                	mov    %eax,%edi
  8023b2:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  8023b9:	00 00 00 
  8023bc:	ff d0                	callq  *%rax
  8023be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c5:	78 24                	js     8023eb <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cb:	8b 00                	mov    (%rax),%eax
  8023cd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023d1:	48 89 d6             	mov    %rdx,%rsi
  8023d4:	89 c7                	mov    %eax,%edi
  8023d6:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  8023dd:	00 00 00 
  8023e0:	ff d0                	callq  *%rax
  8023e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e9:	79 05                	jns    8023f0 <read+0x5d>
		return r;
  8023eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ee:	eb 76                	jmp    802466 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8023f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f4:	8b 40 08             	mov    0x8(%rax),%eax
  8023f7:	83 e0 03             	and    $0x3,%eax
  8023fa:	83 f8 01             	cmp    $0x1,%eax
  8023fd:	75 3a                	jne    802439 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8023ff:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802406:	00 00 00 
  802409:	48 8b 00             	mov    (%rax),%rax
  80240c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802412:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802415:	89 c6                	mov    %eax,%esi
  802417:	48 bf af 3c 80 00 00 	movabs $0x803caf,%rdi
  80241e:	00 00 00 
  802421:	b8 00 00 00 00       	mov    $0x0,%eax
  802426:	48 b9 42 04 80 00 00 	movabs $0x800442,%rcx
  80242d:	00 00 00 
  802430:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802432:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802437:	eb 2d                	jmp    802466 <read+0xd3>
	}
	if (!dev->dev_read)
  802439:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80243d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802441:	48 85 c0             	test   %rax,%rax
  802444:	75 07                	jne    80244d <read+0xba>
		return -E_NOT_SUPP;
  802446:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80244b:	eb 19                	jmp    802466 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80244d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802451:	48 8b 40 10          	mov    0x10(%rax),%rax
  802455:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802459:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80245d:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802461:	48 89 cf             	mov    %rcx,%rdi
  802464:	ff d0                	callq  *%rax
}
  802466:	c9                   	leaveq 
  802467:	c3                   	retq   

0000000000802468 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802468:	55                   	push   %rbp
  802469:	48 89 e5             	mov    %rsp,%rbp
  80246c:	48 83 ec 30          	sub    $0x30,%rsp
  802470:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802473:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802477:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80247b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802482:	eb 49                	jmp    8024cd <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802484:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802487:	48 98                	cltq   
  802489:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80248d:	48 29 c2             	sub    %rax,%rdx
  802490:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802493:	48 63 c8             	movslq %eax,%rcx
  802496:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80249a:	48 01 c1             	add    %rax,%rcx
  80249d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024a0:	48 89 ce             	mov    %rcx,%rsi
  8024a3:	89 c7                	mov    %eax,%edi
  8024a5:	48 b8 93 23 80 00 00 	movabs $0x802393,%rax
  8024ac:	00 00 00 
  8024af:	ff d0                	callq  *%rax
  8024b1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8024b4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024b8:	79 05                	jns    8024bf <readn+0x57>
			return m;
  8024ba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024bd:	eb 1c                	jmp    8024db <readn+0x73>
		if (m == 0)
  8024bf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024c3:	75 02                	jne    8024c7 <readn+0x5f>
			break;
  8024c5:	eb 11                	jmp    8024d8 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024ca:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d0:	48 98                	cltq   
  8024d2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024d6:	72 ac                	jb     802484 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8024d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024db:	c9                   	leaveq 
  8024dc:	c3                   	retq   

00000000008024dd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024dd:	55                   	push   %rbp
  8024de:	48 89 e5             	mov    %rsp,%rbp
  8024e1:	48 83 ec 40          	sub    $0x40,%rsp
  8024e5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024e8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024ec:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024f0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024f4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024f7:	48 89 d6             	mov    %rdx,%rsi
  8024fa:	89 c7                	mov    %eax,%edi
  8024fc:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  802503:	00 00 00 
  802506:	ff d0                	callq  *%rax
  802508:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250f:	78 24                	js     802535 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802511:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802515:	8b 00                	mov    (%rax),%eax
  802517:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80251b:	48 89 d6             	mov    %rdx,%rsi
  80251e:	89 c7                	mov    %eax,%edi
  802520:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  802527:	00 00 00 
  80252a:	ff d0                	callq  *%rax
  80252c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802533:	79 05                	jns    80253a <write+0x5d>
		return r;
  802535:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802538:	eb 75                	jmp    8025af <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80253a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253e:	8b 40 08             	mov    0x8(%rax),%eax
  802541:	83 e0 03             	and    $0x3,%eax
  802544:	85 c0                	test   %eax,%eax
  802546:	75 3a                	jne    802582 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802548:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80254f:	00 00 00 
  802552:	48 8b 00             	mov    (%rax),%rax
  802555:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80255b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80255e:	89 c6                	mov    %eax,%esi
  802560:	48 bf cb 3c 80 00 00 	movabs $0x803ccb,%rdi
  802567:	00 00 00 
  80256a:	b8 00 00 00 00       	mov    $0x0,%eax
  80256f:	48 b9 42 04 80 00 00 	movabs $0x800442,%rcx
  802576:	00 00 00 
  802579:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80257b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802580:	eb 2d                	jmp    8025af <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802582:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802586:	48 8b 40 18          	mov    0x18(%rax),%rax
  80258a:	48 85 c0             	test   %rax,%rax
  80258d:	75 07                	jne    802596 <write+0xb9>
		return -E_NOT_SUPP;
  80258f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802594:	eb 19                	jmp    8025af <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802596:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80259e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025a2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025a6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025aa:	48 89 cf             	mov    %rcx,%rdi
  8025ad:	ff d0                	callq  *%rax
}
  8025af:	c9                   	leaveq 
  8025b0:	c3                   	retq   

00000000008025b1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8025b1:	55                   	push   %rbp
  8025b2:	48 89 e5             	mov    %rsp,%rbp
  8025b5:	48 83 ec 18          	sub    $0x18,%rsp
  8025b9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025bc:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025bf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025c6:	48 89 d6             	mov    %rdx,%rsi
  8025c9:	89 c7                	mov    %eax,%edi
  8025cb:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  8025d2:	00 00 00 
  8025d5:	ff d0                	callq  *%rax
  8025d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025de:	79 05                	jns    8025e5 <seek+0x34>
		return r;
  8025e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e3:	eb 0f                	jmp    8025f4 <seek+0x43>
	fd->fd_offset = offset;
  8025e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025ec:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8025ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f4:	c9                   	leaveq 
  8025f5:	c3                   	retq   

00000000008025f6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025f6:	55                   	push   %rbp
  8025f7:	48 89 e5             	mov    %rsp,%rbp
  8025fa:	48 83 ec 30          	sub    $0x30,%rsp
  8025fe:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802601:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802604:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802608:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80260b:	48 89 d6             	mov    %rdx,%rsi
  80260e:	89 c7                	mov    %eax,%edi
  802610:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  802617:	00 00 00 
  80261a:	ff d0                	callq  *%rax
  80261c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802623:	78 24                	js     802649 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802629:	8b 00                	mov    (%rax),%eax
  80262b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80262f:	48 89 d6             	mov    %rdx,%rsi
  802632:	89 c7                	mov    %eax,%edi
  802634:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  80263b:	00 00 00 
  80263e:	ff d0                	callq  *%rax
  802640:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802643:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802647:	79 05                	jns    80264e <ftruncate+0x58>
		return r;
  802649:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264c:	eb 72                	jmp    8026c0 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80264e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802652:	8b 40 08             	mov    0x8(%rax),%eax
  802655:	83 e0 03             	and    $0x3,%eax
  802658:	85 c0                	test   %eax,%eax
  80265a:	75 3a                	jne    802696 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80265c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802663:	00 00 00 
  802666:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802669:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80266f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802672:	89 c6                	mov    %eax,%esi
  802674:	48 bf e8 3c 80 00 00 	movabs $0x803ce8,%rdi
  80267b:	00 00 00 
  80267e:	b8 00 00 00 00       	mov    $0x0,%eax
  802683:	48 b9 42 04 80 00 00 	movabs $0x800442,%rcx
  80268a:	00 00 00 
  80268d:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80268f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802694:	eb 2a                	jmp    8026c0 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802696:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269a:	48 8b 40 30          	mov    0x30(%rax),%rax
  80269e:	48 85 c0             	test   %rax,%rax
  8026a1:	75 07                	jne    8026aa <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8026a3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026a8:	eb 16                	jmp    8026c0 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8026aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ae:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026b6:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8026b9:	89 ce                	mov    %ecx,%esi
  8026bb:	48 89 d7             	mov    %rdx,%rdi
  8026be:	ff d0                	callq  *%rax
}
  8026c0:	c9                   	leaveq 
  8026c1:	c3                   	retq   

00000000008026c2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026c2:	55                   	push   %rbp
  8026c3:	48 89 e5             	mov    %rsp,%rbp
  8026c6:	48 83 ec 30          	sub    $0x30,%rsp
  8026ca:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026cd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026d1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026d5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026d8:	48 89 d6             	mov    %rdx,%rsi
  8026db:	89 c7                	mov    %eax,%edi
  8026dd:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  8026e4:	00 00 00 
  8026e7:	ff d0                	callq  *%rax
  8026e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f0:	78 24                	js     802716 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f6:	8b 00                	mov    (%rax),%eax
  8026f8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026fc:	48 89 d6             	mov    %rdx,%rsi
  8026ff:	89 c7                	mov    %eax,%edi
  802701:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  802708:	00 00 00 
  80270b:	ff d0                	callq  *%rax
  80270d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802710:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802714:	79 05                	jns    80271b <fstat+0x59>
		return r;
  802716:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802719:	eb 5e                	jmp    802779 <fstat+0xb7>
	if (!dev->dev_stat)
  80271b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802723:	48 85 c0             	test   %rax,%rax
  802726:	75 07                	jne    80272f <fstat+0x6d>
		return -E_NOT_SUPP;
  802728:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80272d:	eb 4a                	jmp    802779 <fstat+0xb7>
	stat->st_name[0] = 0;
  80272f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802733:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802736:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80273a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802741:	00 00 00 
	stat->st_isdir = 0;
  802744:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802748:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80274f:	00 00 00 
	stat->st_dev = dev;
  802752:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802756:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80275a:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802761:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802765:	48 8b 40 28          	mov    0x28(%rax),%rax
  802769:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80276d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802771:	48 89 ce             	mov    %rcx,%rsi
  802774:	48 89 d7             	mov    %rdx,%rdi
  802777:	ff d0                	callq  *%rax
}
  802779:	c9                   	leaveq 
  80277a:	c3                   	retq   

000000000080277b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80277b:	55                   	push   %rbp
  80277c:	48 89 e5             	mov    %rsp,%rbp
  80277f:	48 83 ec 20          	sub    $0x20,%rsp
  802783:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802787:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80278b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278f:	be 00 00 00 00       	mov    $0x0,%esi
  802794:	48 89 c7             	mov    %rax,%rdi
  802797:	48 b8 69 28 80 00 00 	movabs $0x802869,%rax
  80279e:	00 00 00 
  8027a1:	ff d0                	callq  *%rax
  8027a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027aa:	79 05                	jns    8027b1 <stat+0x36>
		return fd;
  8027ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027af:	eb 2f                	jmp    8027e0 <stat+0x65>
	r = fstat(fd, stat);
  8027b1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b8:	48 89 d6             	mov    %rdx,%rsi
  8027bb:	89 c7                	mov    %eax,%edi
  8027bd:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  8027c4:	00 00 00 
  8027c7:	ff d0                	callq  *%rax
  8027c9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cf:	89 c7                	mov    %eax,%edi
  8027d1:	48 b8 71 21 80 00 00 	movabs $0x802171,%rax
  8027d8:	00 00 00 
  8027db:	ff d0                	callq  *%rax
	return r;
  8027dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027e0:	c9                   	leaveq 
  8027e1:	c3                   	retq   

00000000008027e2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027e2:	55                   	push   %rbp
  8027e3:	48 89 e5             	mov    %rsp,%rbp
  8027e6:	48 83 ec 10          	sub    $0x10,%rsp
  8027ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8027f1:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  8027f8:	00 00 00 
  8027fb:	8b 00                	mov    (%rax),%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	75 1d                	jne    80281e <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802801:	bf 01 00 00 00       	mov    $0x1,%edi
  802806:	48 b8 d8 35 80 00 00 	movabs $0x8035d8,%rax
  80280d:	00 00 00 
  802810:	ff d0                	callq  *%rax
  802812:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  802819:	00 00 00 
  80281c:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80281e:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802825:	00 00 00 
  802828:	8b 00                	mov    (%rax),%eax
  80282a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80282d:	b9 07 00 00 00       	mov    $0x7,%ecx
  802832:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802839:	00 00 00 
  80283c:	89 c7                	mov    %eax,%edi
  80283e:	48 b8 40 35 80 00 00 	movabs $0x803540,%rax
  802845:	00 00 00 
  802848:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80284a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284e:	ba 00 00 00 00       	mov    $0x0,%edx
  802853:	48 89 c6             	mov    %rax,%rsi
  802856:	bf 00 00 00 00       	mov    $0x0,%edi
  80285b:	48 b8 77 34 80 00 00 	movabs $0x803477,%rax
  802862:	00 00 00 
  802865:	ff d0                	callq  *%rax
}
  802867:	c9                   	leaveq 
  802868:	c3                   	retq   

0000000000802869 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802869:	55                   	push   %rbp
  80286a:	48 89 e5             	mov    %rsp,%rbp
  80286d:	48 83 ec 20          	sub    $0x20,%rsp
  802871:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802875:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802878:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287c:	48 89 c7             	mov    %rax,%rdi
  80287f:	48 b8 7e 11 80 00 00 	movabs $0x80117e,%rax
  802886:	00 00 00 
  802889:	ff d0                	callq  *%rax
  80288b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802890:	7e 0a                	jle    80289c <open+0x33>
		return -E_BAD_PATH;
  802892:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802897:	e9 a5 00 00 00       	jmpq   802941 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80289c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8028a0:	48 89 c7             	mov    %rax,%rdi
  8028a3:	48 b8 c9 1e 80 00 00 	movabs $0x801ec9,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
  8028af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b6:	79 08                	jns    8028c0 <open+0x57>
		return r;
  8028b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028bb:	e9 81 00 00 00       	jmpq   802941 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8028c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c4:	48 89 c6             	mov    %rax,%rsi
  8028c7:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8028ce:	00 00 00 
  8028d1:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  8028d8:	00 00 00 
  8028db:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8028dd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028e4:	00 00 00 
  8028e7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8028ea:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8028f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f4:	48 89 c6             	mov    %rax,%rsi
  8028f7:	bf 01 00 00 00       	mov    $0x1,%edi
  8028fc:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802903:	00 00 00 
  802906:	ff d0                	callq  *%rax
  802908:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80290b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290f:	79 1d                	jns    80292e <open+0xc5>
		fd_close(fd, 0);
  802911:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802915:	be 00 00 00 00       	mov    $0x0,%esi
  80291a:	48 89 c7             	mov    %rax,%rdi
  80291d:	48 b8 f1 1f 80 00 00 	movabs $0x801ff1,%rax
  802924:	00 00 00 
  802927:	ff d0                	callq  *%rax
		return r;
  802929:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292c:	eb 13                	jmp    802941 <open+0xd8>
	}

	return fd2num(fd);
  80292e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802932:	48 89 c7             	mov    %rax,%rdi
  802935:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  80293c:	00 00 00 
  80293f:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802941:	c9                   	leaveq 
  802942:	c3                   	retq   

0000000000802943 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802943:	55                   	push   %rbp
  802944:	48 89 e5             	mov    %rsp,%rbp
  802947:	48 83 ec 10          	sub    $0x10,%rsp
  80294b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80294f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802953:	8b 50 0c             	mov    0xc(%rax),%edx
  802956:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80295d:	00 00 00 
  802960:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802962:	be 00 00 00 00       	mov    $0x0,%esi
  802967:	bf 06 00 00 00       	mov    $0x6,%edi
  80296c:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802973:	00 00 00 
  802976:	ff d0                	callq  *%rax
}
  802978:	c9                   	leaveq 
  802979:	c3                   	retq   

000000000080297a <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80297a:	55                   	push   %rbp
  80297b:	48 89 e5             	mov    %rsp,%rbp
  80297e:	48 83 ec 30          	sub    $0x30,%rsp
  802982:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802986:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80298a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80298e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802992:	8b 50 0c             	mov    0xc(%rax),%edx
  802995:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80299c:	00 00 00 
  80299f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8029a1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029a8:	00 00 00 
  8029ab:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029af:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8029b3:	be 00 00 00 00       	mov    $0x0,%esi
  8029b8:	bf 03 00 00 00       	mov    $0x3,%edi
  8029bd:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  8029c4:	00 00 00 
  8029c7:	ff d0                	callq  *%rax
  8029c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d0:	79 05                	jns    8029d7 <devfile_read+0x5d>
		return r;
  8029d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d5:	eb 26                	jmp    8029fd <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8029d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029da:	48 63 d0             	movslq %eax,%rdx
  8029dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029e1:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8029e8:	00 00 00 
  8029eb:	48 89 c7             	mov    %rax,%rdi
  8029ee:	48 b8 0e 15 80 00 00 	movabs $0x80150e,%rax
  8029f5:	00 00 00 
  8029f8:	ff d0                	callq  *%rax

	return r;
  8029fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8029fd:	c9                   	leaveq 
  8029fe:	c3                   	retq   

00000000008029ff <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8029ff:	55                   	push   %rbp
  802a00:	48 89 e5             	mov    %rsp,%rbp
  802a03:	48 83 ec 30          	sub    $0x30,%rsp
  802a07:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a0b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a0f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802a13:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802a1a:	00 
  802a1b:	76 08                	jbe    802a25 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802a1d:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802a24:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a29:	8b 50 0c             	mov    0xc(%rax),%edx
  802a2c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a33:	00 00 00 
  802a36:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802a38:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a3f:	00 00 00 
  802a42:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a46:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  802a4a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a52:	48 89 c6             	mov    %rax,%rsi
  802a55:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802a5c:	00 00 00 
  802a5f:	48 b8 0e 15 80 00 00 	movabs $0x80150e,%rax
  802a66:	00 00 00 
  802a69:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802a6b:	be 00 00 00 00       	mov    $0x0,%esi
  802a70:	bf 04 00 00 00       	mov    $0x4,%edi
  802a75:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802a7c:	00 00 00 
  802a7f:	ff d0                	callq  *%rax
  802a81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a88:	79 05                	jns    802a8f <devfile_write+0x90>
		return r;
  802a8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a8d:	eb 03                	jmp    802a92 <devfile_write+0x93>

	return r;
  802a8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802a92:	c9                   	leaveq 
  802a93:	c3                   	retq   

0000000000802a94 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a94:	55                   	push   %rbp
  802a95:	48 89 e5             	mov    %rsp,%rbp
  802a98:	48 83 ec 20          	sub    $0x20,%rsp
  802a9c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802aa0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802aa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa8:	8b 50 0c             	mov    0xc(%rax),%edx
  802aab:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ab2:	00 00 00 
  802ab5:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ab7:	be 00 00 00 00       	mov    $0x0,%esi
  802abc:	bf 05 00 00 00       	mov    $0x5,%edi
  802ac1:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802ac8:	00 00 00 
  802acb:	ff d0                	callq  *%rax
  802acd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad4:	79 05                	jns    802adb <devfile_stat+0x47>
		return r;
  802ad6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad9:	eb 56                	jmp    802b31 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802adb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802adf:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802ae6:	00 00 00 
  802ae9:	48 89 c7             	mov    %rax,%rdi
  802aec:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  802af3:	00 00 00 
  802af6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802af8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aff:	00 00 00 
  802b02:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b0c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b12:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b19:	00 00 00 
  802b1c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b26:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b31:	c9                   	leaveq 
  802b32:	c3                   	retq   

0000000000802b33 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b33:	55                   	push   %rbp
  802b34:	48 89 e5             	mov    %rsp,%rbp
  802b37:	48 83 ec 10          	sub    $0x10,%rsp
  802b3b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b3f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b46:	8b 50 0c             	mov    0xc(%rax),%edx
  802b49:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b50:	00 00 00 
  802b53:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b55:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b5c:	00 00 00 
  802b5f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b62:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b65:	be 00 00 00 00       	mov    $0x0,%esi
  802b6a:	bf 02 00 00 00       	mov    $0x2,%edi
  802b6f:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802b76:	00 00 00 
  802b79:	ff d0                	callq  *%rax
}
  802b7b:	c9                   	leaveq 
  802b7c:	c3                   	retq   

0000000000802b7d <remove>:

// Delete a file
int
remove(const char *path)
{
  802b7d:	55                   	push   %rbp
  802b7e:	48 89 e5             	mov    %rsp,%rbp
  802b81:	48 83 ec 10          	sub    $0x10,%rsp
  802b85:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b8d:	48 89 c7             	mov    %rax,%rdi
  802b90:	48 b8 7e 11 80 00 00 	movabs $0x80117e,%rax
  802b97:	00 00 00 
  802b9a:	ff d0                	callq  *%rax
  802b9c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ba1:	7e 07                	jle    802baa <remove+0x2d>
		return -E_BAD_PATH;
  802ba3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ba8:	eb 33                	jmp    802bdd <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802baa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bae:	48 89 c6             	mov    %rax,%rsi
  802bb1:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802bb8:	00 00 00 
  802bbb:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  802bc2:	00 00 00 
  802bc5:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802bc7:	be 00 00 00 00       	mov    $0x0,%esi
  802bcc:	bf 07 00 00 00       	mov    $0x7,%edi
  802bd1:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802bd8:	00 00 00 
  802bdb:	ff d0                	callq  *%rax
}
  802bdd:	c9                   	leaveq 
  802bde:	c3                   	retq   

0000000000802bdf <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802bdf:	55                   	push   %rbp
  802be0:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802be3:	be 00 00 00 00       	mov    $0x0,%esi
  802be8:	bf 08 00 00 00       	mov    $0x8,%edi
  802bed:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802bf4:	00 00 00 
  802bf7:	ff d0                	callq  *%rax
}
  802bf9:	5d                   	pop    %rbp
  802bfa:	c3                   	retq   

0000000000802bfb <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802bfb:	55                   	push   %rbp
  802bfc:	48 89 e5             	mov    %rsp,%rbp
  802bff:	53                   	push   %rbx
  802c00:	48 83 ec 38          	sub    $0x38,%rsp
  802c04:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802c08:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802c0c:	48 89 c7             	mov    %rax,%rdi
  802c0f:	48 b8 c9 1e 80 00 00 	movabs $0x801ec9,%rax
  802c16:	00 00 00 
  802c19:	ff d0                	callq  *%rax
  802c1b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c1e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c22:	0f 88 bf 01 00 00    	js     802de7 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c2c:	ba 07 04 00 00       	mov    $0x407,%edx
  802c31:	48 89 c6             	mov    %rax,%rsi
  802c34:	bf 00 00 00 00       	mov    $0x0,%edi
  802c39:	48 b8 19 1b 80 00 00 	movabs $0x801b19,%rax
  802c40:	00 00 00 
  802c43:	ff d0                	callq  *%rax
  802c45:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c48:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c4c:	0f 88 95 01 00 00    	js     802de7 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802c52:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802c56:	48 89 c7             	mov    %rax,%rdi
  802c59:	48 b8 c9 1e 80 00 00 	movabs $0x801ec9,%rax
  802c60:	00 00 00 
  802c63:	ff d0                	callq  *%rax
  802c65:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c68:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c6c:	0f 88 5d 01 00 00    	js     802dcf <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c72:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c76:	ba 07 04 00 00       	mov    $0x407,%edx
  802c7b:	48 89 c6             	mov    %rax,%rsi
  802c7e:	bf 00 00 00 00       	mov    $0x0,%edi
  802c83:	48 b8 19 1b 80 00 00 	movabs $0x801b19,%rax
  802c8a:	00 00 00 
  802c8d:	ff d0                	callq  *%rax
  802c8f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c92:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c96:	0f 88 33 01 00 00    	js     802dcf <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802c9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ca0:	48 89 c7             	mov    %rax,%rdi
  802ca3:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  802caa:	00 00 00 
  802cad:	ff d0                	callq  *%rax
  802caf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cb7:	ba 07 04 00 00       	mov    $0x407,%edx
  802cbc:	48 89 c6             	mov    %rax,%rsi
  802cbf:	bf 00 00 00 00       	mov    $0x0,%edi
  802cc4:	48 b8 19 1b 80 00 00 	movabs $0x801b19,%rax
  802ccb:	00 00 00 
  802cce:	ff d0                	callq  *%rax
  802cd0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802cd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802cd7:	79 05                	jns    802cde <pipe+0xe3>
		goto err2;
  802cd9:	e9 d9 00 00 00       	jmpq   802db7 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cde:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ce2:	48 89 c7             	mov    %rax,%rdi
  802ce5:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  802cec:	00 00 00 
  802cef:	ff d0                	callq  *%rax
  802cf1:	48 89 c2             	mov    %rax,%rdx
  802cf4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cf8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802cfe:	48 89 d1             	mov    %rdx,%rcx
  802d01:	ba 00 00 00 00       	mov    $0x0,%edx
  802d06:	48 89 c6             	mov    %rax,%rsi
  802d09:	bf 00 00 00 00       	mov    $0x0,%edi
  802d0e:	48 b8 69 1b 80 00 00 	movabs $0x801b69,%rax
  802d15:	00 00 00 
  802d18:	ff d0                	callq  *%rax
  802d1a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d1d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d21:	79 1b                	jns    802d3e <pipe+0x143>
		goto err3;
  802d23:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  802d24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d28:	48 89 c6             	mov    %rax,%rsi
  802d2b:	bf 00 00 00 00       	mov    $0x0,%edi
  802d30:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  802d37:	00 00 00 
  802d3a:	ff d0                	callq  *%rax
  802d3c:	eb 79                	jmp    802db7 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802d3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d42:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802d49:	00 00 00 
  802d4c:	8b 12                	mov    (%rdx),%edx
  802d4e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802d50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d54:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802d5b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d5f:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802d66:	00 00 00 
  802d69:	8b 12                	mov    (%rdx),%edx
  802d6b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802d6d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d71:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802d78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d7c:	48 89 c7             	mov    %rax,%rdi
  802d7f:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  802d86:	00 00 00 
  802d89:	ff d0                	callq  *%rax
  802d8b:	89 c2                	mov    %eax,%edx
  802d8d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d91:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802d93:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d97:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802d9b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d9f:	48 89 c7             	mov    %rax,%rdi
  802da2:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  802da9:	00 00 00 
  802dac:	ff d0                	callq  *%rax
  802dae:	89 03                	mov    %eax,(%rbx)
	return 0;
  802db0:	b8 00 00 00 00       	mov    $0x0,%eax
  802db5:	eb 33                	jmp    802dea <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  802db7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dbb:	48 89 c6             	mov    %rax,%rsi
  802dbe:	bf 00 00 00 00       	mov    $0x0,%edi
  802dc3:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  802dca:	00 00 00 
  802dcd:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  802dcf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dd3:	48 89 c6             	mov    %rax,%rsi
  802dd6:	bf 00 00 00 00       	mov    $0x0,%edi
  802ddb:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  802de2:	00 00 00 
  802de5:	ff d0                	callq  *%rax
    err:
	return r;
  802de7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802dea:	48 83 c4 38          	add    $0x38,%rsp
  802dee:	5b                   	pop    %rbx
  802def:	5d                   	pop    %rbp
  802df0:	c3                   	retq   

0000000000802df1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802df1:	55                   	push   %rbp
  802df2:	48 89 e5             	mov    %rsp,%rbp
  802df5:	53                   	push   %rbx
  802df6:	48 83 ec 28          	sub    $0x28,%rsp
  802dfa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802dfe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802e02:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802e09:	00 00 00 
  802e0c:	48 8b 00             	mov    (%rax),%rax
  802e0f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802e15:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802e18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e1c:	48 89 c7             	mov    %rax,%rdi
  802e1f:	48 b8 5a 36 80 00 00 	movabs $0x80365a,%rax
  802e26:	00 00 00 
  802e29:	ff d0                	callq  *%rax
  802e2b:	89 c3                	mov    %eax,%ebx
  802e2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e31:	48 89 c7             	mov    %rax,%rdi
  802e34:	48 b8 5a 36 80 00 00 	movabs $0x80365a,%rax
  802e3b:	00 00 00 
  802e3e:	ff d0                	callq  *%rax
  802e40:	39 c3                	cmp    %eax,%ebx
  802e42:	0f 94 c0             	sete   %al
  802e45:	0f b6 c0             	movzbl %al,%eax
  802e48:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802e4b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802e52:	00 00 00 
  802e55:	48 8b 00             	mov    (%rax),%rax
  802e58:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802e5e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802e61:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e64:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802e67:	75 05                	jne    802e6e <_pipeisclosed+0x7d>
			return ret;
  802e69:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e6c:	eb 4f                	jmp    802ebd <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802e6e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e71:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802e74:	74 42                	je     802eb8 <_pipeisclosed+0xc7>
  802e76:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802e7a:	75 3c                	jne    802eb8 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802e7c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802e83:	00 00 00 
  802e86:	48 8b 00             	mov    (%rax),%rax
  802e89:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802e8f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802e92:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e95:	89 c6                	mov    %eax,%esi
  802e97:	48 bf 13 3d 80 00 00 	movabs $0x803d13,%rdi
  802e9e:	00 00 00 
  802ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea6:	49 b8 42 04 80 00 00 	movabs $0x800442,%r8
  802ead:	00 00 00 
  802eb0:	41 ff d0             	callq  *%r8
	}
  802eb3:	e9 4a ff ff ff       	jmpq   802e02 <_pipeisclosed+0x11>
  802eb8:	e9 45 ff ff ff       	jmpq   802e02 <_pipeisclosed+0x11>
}
  802ebd:	48 83 c4 28          	add    $0x28,%rsp
  802ec1:	5b                   	pop    %rbx
  802ec2:	5d                   	pop    %rbp
  802ec3:	c3                   	retq   

0000000000802ec4 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802ec4:	55                   	push   %rbp
  802ec5:	48 89 e5             	mov    %rsp,%rbp
  802ec8:	48 83 ec 30          	sub    $0x30,%rsp
  802ecc:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ecf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ed3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ed6:	48 89 d6             	mov    %rdx,%rsi
  802ed9:	89 c7                	mov    %eax,%edi
  802edb:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  802ee2:	00 00 00 
  802ee5:	ff d0                	callq  *%rax
  802ee7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eee:	79 05                	jns    802ef5 <pipeisclosed+0x31>
		return r;
  802ef0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef3:	eb 31                	jmp    802f26 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802ef5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef9:	48 89 c7             	mov    %rax,%rdi
  802efc:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  802f03:	00 00 00 
  802f06:	ff d0                	callq  *%rax
  802f08:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802f0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f10:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f14:	48 89 d6             	mov    %rdx,%rsi
  802f17:	48 89 c7             	mov    %rax,%rdi
  802f1a:	48 b8 f1 2d 80 00 00 	movabs $0x802df1,%rax
  802f21:	00 00 00 
  802f24:	ff d0                	callq  *%rax
}
  802f26:	c9                   	leaveq 
  802f27:	c3                   	retq   

0000000000802f28 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802f28:	55                   	push   %rbp
  802f29:	48 89 e5             	mov    %rsp,%rbp
  802f2c:	48 83 ec 40          	sub    $0x40,%rsp
  802f30:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f34:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f38:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802f3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f40:	48 89 c7             	mov    %rax,%rdi
  802f43:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  802f4a:	00 00 00 
  802f4d:	ff d0                	callq  *%rax
  802f4f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802f53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802f5b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802f62:	00 
  802f63:	e9 92 00 00 00       	jmpq   802ffa <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802f68:	eb 41                	jmp    802fab <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802f6a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802f6f:	74 09                	je     802f7a <devpipe_read+0x52>
				return i;
  802f71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f75:	e9 92 00 00 00       	jmpq   80300c <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802f7a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f82:	48 89 d6             	mov    %rdx,%rsi
  802f85:	48 89 c7             	mov    %rax,%rdi
  802f88:	48 b8 f1 2d 80 00 00 	movabs $0x802df1,%rax
  802f8f:	00 00 00 
  802f92:	ff d0                	callq  *%rax
  802f94:	85 c0                	test   %eax,%eax
  802f96:	74 07                	je     802f9f <devpipe_read+0x77>
				return 0;
  802f98:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9d:	eb 6d                	jmp    80300c <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802f9f:	48 b8 db 1a 80 00 00 	movabs $0x801adb,%rax
  802fa6:	00 00 00 
  802fa9:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802fab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802faf:	8b 10                	mov    (%rax),%edx
  802fb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb5:	8b 40 04             	mov    0x4(%rax),%eax
  802fb8:	39 c2                	cmp    %eax,%edx
  802fba:	74 ae                	je     802f6a <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802fbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fc0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802fc4:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802fc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fcc:	8b 00                	mov    (%rax),%eax
  802fce:	99                   	cltd   
  802fcf:	c1 ea 1b             	shr    $0x1b,%edx
  802fd2:	01 d0                	add    %edx,%eax
  802fd4:	83 e0 1f             	and    $0x1f,%eax
  802fd7:	29 d0                	sub    %edx,%eax
  802fd9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fdd:	48 98                	cltq   
  802fdf:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802fe4:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802fe6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fea:	8b 00                	mov    (%rax),%eax
  802fec:	8d 50 01             	lea    0x1(%rax),%edx
  802fef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff3:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802ff5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802ffa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ffe:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803002:	0f 82 60 ff ff ff    	jb     802f68 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803008:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80300c:	c9                   	leaveq 
  80300d:	c3                   	retq   

000000000080300e <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80300e:	55                   	push   %rbp
  80300f:	48 89 e5             	mov    %rsp,%rbp
  803012:	48 83 ec 40          	sub    $0x40,%rsp
  803016:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80301a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80301e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803022:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803026:	48 89 c7             	mov    %rax,%rdi
  803029:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  803030:	00 00 00 
  803033:	ff d0                	callq  *%rax
  803035:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803039:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80303d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803041:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803048:	00 
  803049:	e9 8e 00 00 00       	jmpq   8030dc <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80304e:	eb 31                	jmp    803081 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803050:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803054:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803058:	48 89 d6             	mov    %rdx,%rsi
  80305b:	48 89 c7             	mov    %rax,%rdi
  80305e:	48 b8 f1 2d 80 00 00 	movabs $0x802df1,%rax
  803065:	00 00 00 
  803068:	ff d0                	callq  *%rax
  80306a:	85 c0                	test   %eax,%eax
  80306c:	74 07                	je     803075 <devpipe_write+0x67>
				return 0;
  80306e:	b8 00 00 00 00       	mov    $0x0,%eax
  803073:	eb 79                	jmp    8030ee <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803075:	48 b8 db 1a 80 00 00 	movabs $0x801adb,%rax
  80307c:	00 00 00 
  80307f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803081:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803085:	8b 40 04             	mov    0x4(%rax),%eax
  803088:	48 63 d0             	movslq %eax,%rdx
  80308b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80308f:	8b 00                	mov    (%rax),%eax
  803091:	48 98                	cltq   
  803093:	48 83 c0 20          	add    $0x20,%rax
  803097:	48 39 c2             	cmp    %rax,%rdx
  80309a:	73 b4                	jae    803050 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80309c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a0:	8b 40 04             	mov    0x4(%rax),%eax
  8030a3:	99                   	cltd   
  8030a4:	c1 ea 1b             	shr    $0x1b,%edx
  8030a7:	01 d0                	add    %edx,%eax
  8030a9:	83 e0 1f             	and    $0x1f,%eax
  8030ac:	29 d0                	sub    %edx,%eax
  8030ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8030b2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8030b6:	48 01 ca             	add    %rcx,%rdx
  8030b9:	0f b6 0a             	movzbl (%rdx),%ecx
  8030bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030c0:	48 98                	cltq   
  8030c2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8030c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ca:	8b 40 04             	mov    0x4(%rax),%eax
  8030cd:	8d 50 01             	lea    0x1(%rax),%edx
  8030d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d4:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8030d7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8030dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030e0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8030e4:	0f 82 64 ff ff ff    	jb     80304e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8030ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8030ee:	c9                   	leaveq 
  8030ef:	c3                   	retq   

00000000008030f0 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8030f0:	55                   	push   %rbp
  8030f1:	48 89 e5             	mov    %rsp,%rbp
  8030f4:	48 83 ec 20          	sub    $0x20,%rsp
  8030f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803100:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803104:	48 89 c7             	mov    %rax,%rdi
  803107:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  80310e:	00 00 00 
  803111:	ff d0                	callq  *%rax
  803113:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803117:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80311b:	48 be 26 3d 80 00 00 	movabs $0x803d26,%rsi
  803122:	00 00 00 
  803125:	48 89 c7             	mov    %rax,%rdi
  803128:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  80312f:	00 00 00 
  803132:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803134:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803138:	8b 50 04             	mov    0x4(%rax),%edx
  80313b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80313f:	8b 00                	mov    (%rax),%eax
  803141:	29 c2                	sub    %eax,%edx
  803143:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803147:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80314d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803151:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803158:	00 00 00 
	stat->st_dev = &devpipe;
  80315b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80315f:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  803166:	00 00 00 
  803169:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803170:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803175:	c9                   	leaveq 
  803176:	c3                   	retq   

0000000000803177 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803177:	55                   	push   %rbp
  803178:	48 89 e5             	mov    %rsp,%rbp
  80317b:	48 83 ec 10          	sub    $0x10,%rsp
  80317f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803183:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803187:	48 89 c6             	mov    %rax,%rsi
  80318a:	bf 00 00 00 00       	mov    $0x0,%edi
  80318f:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  803196:	00 00 00 
  803199:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80319b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80319f:	48 89 c7             	mov    %rax,%rdi
  8031a2:	48 b8 9e 1e 80 00 00 	movabs $0x801e9e,%rax
  8031a9:	00 00 00 
  8031ac:	ff d0                	callq  *%rax
  8031ae:	48 89 c6             	mov    %rax,%rsi
  8031b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8031b6:	48 b8 c4 1b 80 00 00 	movabs $0x801bc4,%rax
  8031bd:	00 00 00 
  8031c0:	ff d0                	callq  *%rax
}
  8031c2:	c9                   	leaveq 
  8031c3:	c3                   	retq   

00000000008031c4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8031c4:	55                   	push   %rbp
  8031c5:	48 89 e5             	mov    %rsp,%rbp
  8031c8:	48 83 ec 20          	sub    $0x20,%rsp
  8031cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8031cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031d2:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8031d5:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8031d9:	be 01 00 00 00       	mov    $0x1,%esi
  8031de:	48 89 c7             	mov    %rax,%rdi
  8031e1:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  8031e8:	00 00 00 
  8031eb:	ff d0                	callq  *%rax
}
  8031ed:	c9                   	leaveq 
  8031ee:	c3                   	retq   

00000000008031ef <getchar>:

int
getchar(void)
{
  8031ef:	55                   	push   %rbp
  8031f0:	48 89 e5             	mov    %rsp,%rbp
  8031f3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8031f7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8031fb:	ba 01 00 00 00       	mov    $0x1,%edx
  803200:	48 89 c6             	mov    %rax,%rsi
  803203:	bf 00 00 00 00       	mov    $0x0,%edi
  803208:	48 b8 93 23 80 00 00 	movabs $0x802393,%rax
  80320f:	00 00 00 
  803212:	ff d0                	callq  *%rax
  803214:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803217:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80321b:	79 05                	jns    803222 <getchar+0x33>
		return r;
  80321d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803220:	eb 14                	jmp    803236 <getchar+0x47>
	if (r < 1)
  803222:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803226:	7f 07                	jg     80322f <getchar+0x40>
		return -E_EOF;
  803228:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80322d:	eb 07                	jmp    803236 <getchar+0x47>
	return c;
  80322f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803233:	0f b6 c0             	movzbl %al,%eax
}
  803236:	c9                   	leaveq 
  803237:	c3                   	retq   

0000000000803238 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803238:	55                   	push   %rbp
  803239:	48 89 e5             	mov    %rsp,%rbp
  80323c:	48 83 ec 20          	sub    $0x20,%rsp
  803240:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803243:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803247:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80324a:	48 89 d6             	mov    %rdx,%rsi
  80324d:	89 c7                	mov    %eax,%edi
  80324f:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  803256:	00 00 00 
  803259:	ff d0                	callq  *%rax
  80325b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80325e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803262:	79 05                	jns    803269 <iscons+0x31>
		return r;
  803264:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803267:	eb 1a                	jmp    803283 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803269:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80326d:	8b 10                	mov    (%rax),%edx
  80326f:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803276:	00 00 00 
  803279:	8b 00                	mov    (%rax),%eax
  80327b:	39 c2                	cmp    %eax,%edx
  80327d:	0f 94 c0             	sete   %al
  803280:	0f b6 c0             	movzbl %al,%eax
}
  803283:	c9                   	leaveq 
  803284:	c3                   	retq   

0000000000803285 <opencons>:

int
opencons(void)
{
  803285:	55                   	push   %rbp
  803286:	48 89 e5             	mov    %rsp,%rbp
  803289:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80328d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803291:	48 89 c7             	mov    %rax,%rdi
  803294:	48 b8 c9 1e 80 00 00 	movabs $0x801ec9,%rax
  80329b:	00 00 00 
  80329e:	ff d0                	callq  *%rax
  8032a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032a7:	79 05                	jns    8032ae <opencons+0x29>
		return r;
  8032a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ac:	eb 5b                	jmp    803309 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8032ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b2:	ba 07 04 00 00       	mov    $0x407,%edx
  8032b7:	48 89 c6             	mov    %rax,%rsi
  8032ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8032bf:	48 b8 19 1b 80 00 00 	movabs $0x801b19,%rax
  8032c6:	00 00 00 
  8032c9:	ff d0                	callq  *%rax
  8032cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d2:	79 05                	jns    8032d9 <opencons+0x54>
		return r;
  8032d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d7:	eb 30                	jmp    803309 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8032d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032dd:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8032e4:	00 00 00 
  8032e7:	8b 12                	mov    (%rdx),%edx
  8032e9:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8032eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ef:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8032f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032fa:	48 89 c7             	mov    %rax,%rdi
  8032fd:	48 b8 7b 1e 80 00 00 	movabs $0x801e7b,%rax
  803304:	00 00 00 
  803307:	ff d0                	callq  *%rax
}
  803309:	c9                   	leaveq 
  80330a:	c3                   	retq   

000000000080330b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80330b:	55                   	push   %rbp
  80330c:	48 89 e5             	mov    %rsp,%rbp
  80330f:	48 83 ec 30          	sub    $0x30,%rsp
  803313:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803317:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80331b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80331f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803324:	75 07                	jne    80332d <devcons_read+0x22>
		return 0;
  803326:	b8 00 00 00 00       	mov    $0x0,%eax
  80332b:	eb 4b                	jmp    803378 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80332d:	eb 0c                	jmp    80333b <devcons_read+0x30>
		sys_yield();
  80332f:	48 b8 db 1a 80 00 00 	movabs $0x801adb,%rax
  803336:	00 00 00 
  803339:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80333b:	48 b8 1b 1a 80 00 00 	movabs $0x801a1b,%rax
  803342:	00 00 00 
  803345:	ff d0                	callq  *%rax
  803347:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80334a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80334e:	74 df                	je     80332f <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803350:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803354:	79 05                	jns    80335b <devcons_read+0x50>
		return c;
  803356:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803359:	eb 1d                	jmp    803378 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80335b:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80335f:	75 07                	jne    803368 <devcons_read+0x5d>
		return 0;
  803361:	b8 00 00 00 00       	mov    $0x0,%eax
  803366:	eb 10                	jmp    803378 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803368:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80336b:	89 c2                	mov    %eax,%edx
  80336d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803371:	88 10                	mov    %dl,(%rax)
	return 1;
  803373:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803378:	c9                   	leaveq 
  803379:	c3                   	retq   

000000000080337a <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80337a:	55                   	push   %rbp
  80337b:	48 89 e5             	mov    %rsp,%rbp
  80337e:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803385:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80338c:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803393:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80339a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8033a1:	eb 76                	jmp    803419 <devcons_write+0x9f>
		m = n - tot;
  8033a3:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8033aa:	89 c2                	mov    %eax,%edx
  8033ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033af:	29 c2                	sub    %eax,%edx
  8033b1:	89 d0                	mov    %edx,%eax
  8033b3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8033b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033b9:	83 f8 7f             	cmp    $0x7f,%eax
  8033bc:	76 07                	jbe    8033c5 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8033be:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8033c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033c8:	48 63 d0             	movslq %eax,%rdx
  8033cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ce:	48 63 c8             	movslq %eax,%rcx
  8033d1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8033d8:	48 01 c1             	add    %rax,%rcx
  8033db:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8033e2:	48 89 ce             	mov    %rcx,%rsi
  8033e5:	48 89 c7             	mov    %rax,%rdi
  8033e8:	48 b8 0e 15 80 00 00 	movabs $0x80150e,%rax
  8033ef:	00 00 00 
  8033f2:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8033f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033f7:	48 63 d0             	movslq %eax,%rdx
  8033fa:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803401:	48 89 d6             	mov    %rdx,%rsi
  803404:	48 89 c7             	mov    %rax,%rdi
  803407:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  80340e:	00 00 00 
  803411:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803413:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803416:	01 45 fc             	add    %eax,-0x4(%rbp)
  803419:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341c:	48 98                	cltq   
  80341e:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803425:	0f 82 78 ff ff ff    	jb     8033a3 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80342b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80342e:	c9                   	leaveq 
  80342f:	c3                   	retq   

0000000000803430 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803430:	55                   	push   %rbp
  803431:	48 89 e5             	mov    %rsp,%rbp
  803434:	48 83 ec 08          	sub    $0x8,%rsp
  803438:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80343c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803441:	c9                   	leaveq 
  803442:	c3                   	retq   

0000000000803443 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803443:	55                   	push   %rbp
  803444:	48 89 e5             	mov    %rsp,%rbp
  803447:	48 83 ec 10          	sub    $0x10,%rsp
  80344b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80344f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803453:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803457:	48 be 32 3d 80 00 00 	movabs $0x803d32,%rsi
  80345e:	00 00 00 
  803461:	48 89 c7             	mov    %rax,%rdi
  803464:	48 b8 ea 11 80 00 00 	movabs $0x8011ea,%rax
  80346b:	00 00 00 
  80346e:	ff d0                	callq  *%rax
	return 0;
  803470:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803475:	c9                   	leaveq 
  803476:	c3                   	retq   

0000000000803477 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803477:	55                   	push   %rbp
  803478:	48 89 e5             	mov    %rsp,%rbp
  80347b:	48 83 ec 30          	sub    $0x30,%rsp
  80347f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803483:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803487:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  80348b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80348f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803493:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803498:	75 0e                	jne    8034a8 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  80349a:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8034a1:	00 00 00 
  8034a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  8034a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034ac:	48 89 c7             	mov    %rax,%rdi
  8034af:	48 b8 42 1d 80 00 00 	movabs $0x801d42,%rax
  8034b6:	00 00 00 
  8034b9:	ff d0                	callq  *%rax
  8034bb:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8034be:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8034c2:	79 27                	jns    8034eb <ipc_recv+0x74>
		if (from_env_store != NULL)
  8034c4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8034c9:	74 0a                	je     8034d5 <ipc_recv+0x5e>
			*from_env_store = 0;
  8034cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034cf:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  8034d5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8034da:	74 0a                	je     8034e6 <ipc_recv+0x6f>
			*perm_store = 0;
  8034dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8034e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034e9:	eb 53                	jmp    80353e <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  8034eb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8034f0:	74 19                	je     80350b <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  8034f2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034f9:	00 00 00 
  8034fc:	48 8b 00             	mov    (%rax),%rax
  8034ff:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803505:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803509:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  80350b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803510:	74 19                	je     80352b <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803512:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803519:	00 00 00 
  80351c:	48 8b 00             	mov    (%rax),%rax
  80351f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803525:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803529:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  80352b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803532:	00 00 00 
  803535:	48 8b 00             	mov    (%rax),%rax
  803538:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  80353e:	c9                   	leaveq 
  80353f:	c3                   	retq   

0000000000803540 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803540:	55                   	push   %rbp
  803541:	48 89 e5             	mov    %rsp,%rbp
  803544:	48 83 ec 30          	sub    $0x30,%rsp
  803548:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80354b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80354e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803552:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803555:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803559:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  80355d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803562:	75 10                	jne    803574 <ipc_send+0x34>
		page = (void *)KERNBASE;
  803564:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  80356b:	00 00 00 
  80356e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803572:	eb 0e                	jmp    803582 <ipc_send+0x42>
  803574:	eb 0c                	jmp    803582 <ipc_send+0x42>
		sys_yield();
  803576:	48 b8 db 1a 80 00 00 	movabs $0x801adb,%rax
  80357d:	00 00 00 
  803580:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803582:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803585:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803588:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80358c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80358f:	89 c7                	mov    %eax,%edi
  803591:	48 b8 ed 1c 80 00 00 	movabs $0x801ced,%rax
  803598:	00 00 00 
  80359b:	ff d0                	callq  *%rax
  80359d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8035a0:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  8035a4:	74 d0                	je     803576 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  8035a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8035aa:	74 2a                	je     8035d6 <ipc_send+0x96>
		panic("error on ipc send procedure");
  8035ac:	48 ba 39 3d 80 00 00 	movabs $0x803d39,%rdx
  8035b3:	00 00 00 
  8035b6:	be 49 00 00 00       	mov    $0x49,%esi
  8035bb:	48 bf 55 3d 80 00 00 	movabs $0x803d55,%rdi
  8035c2:	00 00 00 
  8035c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ca:	48 b9 09 02 80 00 00 	movabs $0x800209,%rcx
  8035d1:	00 00 00 
  8035d4:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  8035d6:	c9                   	leaveq 
  8035d7:	c3                   	retq   

00000000008035d8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8035d8:	55                   	push   %rbp
  8035d9:	48 89 e5             	mov    %rsp,%rbp
  8035dc:	48 83 ec 14          	sub    $0x14,%rsp
  8035e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8035e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8035ea:	eb 5e                	jmp    80364a <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8035ec:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8035f3:	00 00 00 
  8035f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f9:	48 63 d0             	movslq %eax,%rdx
  8035fc:	48 89 d0             	mov    %rdx,%rax
  8035ff:	48 c1 e0 03          	shl    $0x3,%rax
  803603:	48 01 d0             	add    %rdx,%rax
  803606:	48 c1 e0 05          	shl    $0x5,%rax
  80360a:	48 01 c8             	add    %rcx,%rax
  80360d:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803613:	8b 00                	mov    (%rax),%eax
  803615:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803618:	75 2c                	jne    803646 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80361a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803621:	00 00 00 
  803624:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803627:	48 63 d0             	movslq %eax,%rdx
  80362a:	48 89 d0             	mov    %rdx,%rax
  80362d:	48 c1 e0 03          	shl    $0x3,%rax
  803631:	48 01 d0             	add    %rdx,%rax
  803634:	48 c1 e0 05          	shl    $0x5,%rax
  803638:	48 01 c8             	add    %rcx,%rax
  80363b:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803641:	8b 40 08             	mov    0x8(%rax),%eax
  803644:	eb 12                	jmp    803658 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803646:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80364a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803651:	7e 99                	jle    8035ec <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803653:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803658:	c9                   	leaveq 
  803659:	c3                   	retq   

000000000080365a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80365a:	55                   	push   %rbp
  80365b:	48 89 e5             	mov    %rsp,%rbp
  80365e:	48 83 ec 18          	sub    $0x18,%rsp
  803662:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803666:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80366a:	48 c1 e8 15          	shr    $0x15,%rax
  80366e:	48 89 c2             	mov    %rax,%rdx
  803671:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803678:	01 00 00 
  80367b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80367f:	83 e0 01             	and    $0x1,%eax
  803682:	48 85 c0             	test   %rax,%rax
  803685:	75 07                	jne    80368e <pageref+0x34>
		return 0;
  803687:	b8 00 00 00 00       	mov    $0x0,%eax
  80368c:	eb 53                	jmp    8036e1 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80368e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803692:	48 c1 e8 0c          	shr    $0xc,%rax
  803696:	48 89 c2             	mov    %rax,%rdx
  803699:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8036a0:	01 00 00 
  8036a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8036ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036af:	83 e0 01             	and    $0x1,%eax
  8036b2:	48 85 c0             	test   %rax,%rax
  8036b5:	75 07                	jne    8036be <pageref+0x64>
		return 0;
  8036b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8036bc:	eb 23                	jmp    8036e1 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8036be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036c2:	48 c1 e8 0c          	shr    $0xc,%rax
  8036c6:	48 89 c2             	mov    %rax,%rdx
  8036c9:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8036d0:	00 00 00 
  8036d3:	48 c1 e2 04          	shl    $0x4,%rdx
  8036d7:	48 01 d0             	add    %rdx,%rax
  8036da:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8036de:	0f b7 c0             	movzwl %ax,%eax
}
  8036e1:	c9                   	leaveq 
  8036e2:	c3                   	retq   
