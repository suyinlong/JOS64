
obj/user/faultalloc.debug:     file format elf64-x86-64


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
  80003c:	e8 3f 01 00 00       	callq  800180 <libmain>
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
  800061:	48 bf 20 37 80 00 00 	movabs $0x803720,%rdi
  800068:	00 00 00 
  80006b:	b8 00 00 00 00       	mov    $0x0,%eax
  800070:	48 ba 6c 04 80 00 00 	movabs $0x80046c,%rdx
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
  80009b:	48 b8 43 1b 80 00 00 	movabs $0x801b43,%rax
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
  8000bd:	48 ba 30 37 80 00 00 	movabs $0x803730,%rdx
  8000c4:	00 00 00 
  8000c7:	be 0e 00 00 00       	mov    $0xe,%esi
  8000cc:	48 bf 5b 37 80 00 00 	movabs $0x80375b,%rdi
  8000d3:	00 00 00 
  8000d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000db:	49 b9 33 02 80 00 00 	movabs $0x800233,%r9
  8000e2:	00 00 00 
  8000e5:	41 ff d1             	callq  *%r9
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	48 89 d1             	mov    %rdx,%rcx
  8000f3:	48 ba 70 37 80 00 00 	movabs $0x803770,%rdx
  8000fa:	00 00 00 
  8000fd:	be 64 00 00 00       	mov    $0x64,%esi
  800102:	48 89 c7             	mov    %rax,%rdi
  800105:	b8 00 00 00 00       	mov    $0x0,%eax
  80010a:	49 b8 c7 10 80 00 00 	movabs $0x8010c7,%r8
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
  800132:	48 b8 b0 1d 80 00 00 	movabs $0x801db0,%rax
  800139:	00 00 00 
  80013c:	ff d0                	callq  *%rax
	cprintf("%s\n", (char*)0xDeadBeef);
  80013e:	be ef be ad de       	mov    $0xdeadbeef,%esi
  800143:	48 bf 91 37 80 00 00 	movabs $0x803791,%rdi
  80014a:	00 00 00 
  80014d:	b8 00 00 00 00       	mov    $0x0,%eax
  800152:	48 ba 6c 04 80 00 00 	movabs $0x80046c,%rdx
  800159:	00 00 00 
  80015c:	ff d2                	callq  *%rdx
	cprintf("%s\n", (char*)0xCafeBffe);
  80015e:	be fe bf fe ca       	mov    $0xcafebffe,%esi
  800163:	48 bf 91 37 80 00 00 	movabs $0x803791,%rdi
  80016a:	00 00 00 
  80016d:	b8 00 00 00 00       	mov    $0x0,%eax
  800172:	48 ba 6c 04 80 00 00 	movabs $0x80046c,%rdx
  800179:	00 00 00 
  80017c:	ff d2                	callq  *%rdx
}
  80017e:	c9                   	leaveq 
  80017f:	c3                   	retq   

0000000000800180 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800180:	55                   	push   %rbp
  800181:	48 89 e5             	mov    %rsp,%rbp
  800184:	48 83 ec 10          	sub    $0x10,%rsp
  800188:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80018b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80018f:	48 b8 c7 1a 80 00 00 	movabs $0x801ac7,%rax
  800196:	00 00 00 
  800199:	ff d0                	callq  *%rax
  80019b:	48 98                	cltq   
  80019d:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001a2:	48 89 c2             	mov    %rax,%rdx
  8001a5:	48 89 d0             	mov    %rdx,%rax
  8001a8:	48 c1 e0 03          	shl    $0x3,%rax
  8001ac:	48 01 d0             	add    %rdx,%rax
  8001af:	48 c1 e0 05          	shl    $0x5,%rax
  8001b3:	48 89 c2             	mov    %rax,%rdx
  8001b6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001bd:	00 00 00 
  8001c0:	48 01 c2             	add    %rax,%rdx
  8001c3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001ca:	00 00 00 
  8001cd:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d4:	7e 14                	jle    8001ea <libmain+0x6a>
		binaryname = argv[0];
  8001d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001da:	48 8b 10             	mov    (%rax),%rdx
  8001dd:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001e4:	00 00 00 
  8001e7:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001f1:	48 89 d6             	mov    %rdx,%rsi
  8001f4:	89 c7                	mov    %eax,%edi
  8001f6:	48 b8 19 01 80 00 00 	movabs $0x800119,%rax
  8001fd:	00 00 00 
  800200:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800202:	48 b8 10 02 80 00 00 	movabs $0x800210,%rax
  800209:	00 00 00 
  80020c:	ff d0                	callq  *%rax
}
  80020e:	c9                   	leaveq 
  80020f:	c3                   	retq   

0000000000800210 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800210:	55                   	push   %rbp
  800211:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800214:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800220:	bf 00 00 00 00       	mov    $0x0,%edi
  800225:	48 b8 83 1a 80 00 00 	movabs $0x801a83,%rax
  80022c:	00 00 00 
  80022f:	ff d0                	callq  *%rax
}
  800231:	5d                   	pop    %rbp
  800232:	c3                   	retq   

0000000000800233 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800233:	55                   	push   %rbp
  800234:	48 89 e5             	mov    %rsp,%rbp
  800237:	53                   	push   %rbx
  800238:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80023f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800246:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80024c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800253:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80025a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800261:	84 c0                	test   %al,%al
  800263:	74 23                	je     800288 <_panic+0x55>
  800265:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80026c:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800270:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800274:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800278:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80027c:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800280:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800284:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800288:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80028f:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800296:	00 00 00 
  800299:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002a0:	00 00 00 
  8002a3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002a7:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002ae:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002b5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002bc:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8002c3:	00 00 00 
  8002c6:	48 8b 18             	mov    (%rax),%rbx
  8002c9:	48 b8 c7 1a 80 00 00 	movabs $0x801ac7,%rax
  8002d0:	00 00 00 
  8002d3:	ff d0                	callq  *%rax
  8002d5:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8002db:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8002e2:	41 89 c8             	mov    %ecx,%r8d
  8002e5:	48 89 d1             	mov    %rdx,%rcx
  8002e8:	48 89 da             	mov    %rbx,%rdx
  8002eb:	89 c6                	mov    %eax,%esi
  8002ed:	48 bf a0 37 80 00 00 	movabs $0x8037a0,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	49 b9 6c 04 80 00 00 	movabs $0x80046c,%r9
  800303:	00 00 00 
  800306:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800309:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800310:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800317:	48 89 d6             	mov    %rdx,%rsi
  80031a:	48 89 c7             	mov    %rax,%rdi
  80031d:	48 b8 c0 03 80 00 00 	movabs $0x8003c0,%rax
  800324:	00 00 00 
  800327:	ff d0                	callq  *%rax
	cprintf("\n");
  800329:	48 bf c3 37 80 00 00 	movabs $0x8037c3,%rdi
  800330:	00 00 00 
  800333:	b8 00 00 00 00       	mov    $0x0,%eax
  800338:	48 ba 6c 04 80 00 00 	movabs $0x80046c,%rdx
  80033f:	00 00 00 
  800342:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800344:	cc                   	int3   
  800345:	eb fd                	jmp    800344 <_panic+0x111>

0000000000800347 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800347:	55                   	push   %rbp
  800348:	48 89 e5             	mov    %rsp,%rbp
  80034b:	48 83 ec 10          	sub    $0x10,%rsp
  80034f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800352:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800356:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80035a:	8b 00                	mov    (%rax),%eax
  80035c:	8d 48 01             	lea    0x1(%rax),%ecx
  80035f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800363:	89 0a                	mov    %ecx,(%rdx)
  800365:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800368:	89 d1                	mov    %edx,%ecx
  80036a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80036e:	48 98                	cltq   
  800370:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800374:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800378:	8b 00                	mov    (%rax),%eax
  80037a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80037f:	75 2c                	jne    8003ad <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800381:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800385:	8b 00                	mov    (%rax),%eax
  800387:	48 98                	cltq   
  800389:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80038d:	48 83 c2 08          	add    $0x8,%rdx
  800391:	48 89 c6             	mov    %rax,%rsi
  800394:	48 89 d7             	mov    %rdx,%rdi
  800397:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  80039e:	00 00 00 
  8003a1:	ff d0                	callq  *%rax
		b->idx = 0;
  8003a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8003ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b1:	8b 40 04             	mov    0x4(%rax),%eax
  8003b4:	8d 50 01             	lea    0x1(%rax),%edx
  8003b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003bb:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003be:	c9                   	leaveq 
  8003bf:	c3                   	retq   

00000000008003c0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003c0:	55                   	push   %rbp
  8003c1:	48 89 e5             	mov    %rsp,%rbp
  8003c4:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003cb:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003d2:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8003d9:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003e0:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003e7:	48 8b 0a             	mov    (%rdx),%rcx
  8003ea:	48 89 08             	mov    %rcx,(%rax)
  8003ed:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003f1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003f5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003f9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8003fd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800404:	00 00 00 
	b.cnt = 0;
  800407:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80040e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800411:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800418:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80041f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800426:	48 89 c6             	mov    %rax,%rsi
  800429:	48 bf 47 03 80 00 00 	movabs $0x800347,%rdi
  800430:	00 00 00 
  800433:	48 b8 1f 08 80 00 00 	movabs $0x80081f,%rax
  80043a:	00 00 00 
  80043d:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80043f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800445:	48 98                	cltq   
  800447:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80044e:	48 83 c2 08          	add    $0x8,%rdx
  800452:	48 89 c6             	mov    %rax,%rsi
  800455:	48 89 d7             	mov    %rdx,%rdi
  800458:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  80045f:	00 00 00 
  800462:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800464:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80046a:	c9                   	leaveq 
  80046b:	c3                   	retq   

000000000080046c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80046c:	55                   	push   %rbp
  80046d:	48 89 e5             	mov    %rsp,%rbp
  800470:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800477:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80047e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800485:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80048c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800493:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80049a:	84 c0                	test   %al,%al
  80049c:	74 20                	je     8004be <cprintf+0x52>
  80049e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004a2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004a6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004aa:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004ae:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004b2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004b6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004ba:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004be:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8004c5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004cc:	00 00 00 
  8004cf:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004d6:	00 00 00 
  8004d9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004dd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004e4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004eb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8004f2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004f9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800500:	48 8b 0a             	mov    (%rdx),%rcx
  800503:	48 89 08             	mov    %rcx,(%rax)
  800506:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80050a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80050e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800512:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800516:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80051d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800524:	48 89 d6             	mov    %rdx,%rsi
  800527:	48 89 c7             	mov    %rax,%rdi
  80052a:	48 b8 c0 03 80 00 00 	movabs $0x8003c0,%rax
  800531:	00 00 00 
  800534:	ff d0                	callq  *%rax
  800536:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80053c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800542:	c9                   	leaveq 
  800543:	c3                   	retq   

0000000000800544 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800544:	55                   	push   %rbp
  800545:	48 89 e5             	mov    %rsp,%rbp
  800548:	53                   	push   %rbx
  800549:	48 83 ec 38          	sub    $0x38,%rsp
  80054d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800551:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800555:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800559:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80055c:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800560:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800564:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800567:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80056b:	77 3b                	ja     8005a8 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80056d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800570:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800574:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800577:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80057b:	ba 00 00 00 00       	mov    $0x0,%edx
  800580:	48 f7 f3             	div    %rbx
  800583:	48 89 c2             	mov    %rax,%rdx
  800586:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800589:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80058c:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800590:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800594:	41 89 f9             	mov    %edi,%r9d
  800597:	48 89 c7             	mov    %rax,%rdi
  80059a:	48 b8 44 05 80 00 00 	movabs $0x800544,%rax
  8005a1:	00 00 00 
  8005a4:	ff d0                	callq  *%rax
  8005a6:	eb 1e                	jmp    8005c6 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005a8:	eb 12                	jmp    8005bc <printnum+0x78>
			putch(padc, putdat);
  8005aa:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005ae:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b5:	48 89 ce             	mov    %rcx,%rsi
  8005b8:	89 d7                	mov    %edx,%edi
  8005ba:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005bc:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005c0:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005c4:	7f e4                	jg     8005aa <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005c6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d2:	48 f7 f1             	div    %rcx
  8005d5:	48 89 d0             	mov    %rdx,%rax
  8005d8:	48 ba a8 39 80 00 00 	movabs $0x8039a8,%rdx
  8005df:	00 00 00 
  8005e2:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005e6:	0f be d0             	movsbl %al,%edx
  8005e9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f1:	48 89 ce             	mov    %rcx,%rsi
  8005f4:	89 d7                	mov    %edx,%edi
  8005f6:	ff d0                	callq  *%rax
}
  8005f8:	48 83 c4 38          	add    $0x38,%rsp
  8005fc:	5b                   	pop    %rbx
  8005fd:	5d                   	pop    %rbp
  8005fe:	c3                   	retq   

00000000008005ff <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005ff:	55                   	push   %rbp
  800600:	48 89 e5             	mov    %rsp,%rbp
  800603:	48 83 ec 1c          	sub    $0x1c,%rsp
  800607:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80060b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  80060e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800612:	7e 52                	jle    800666 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800614:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800618:	8b 00                	mov    (%rax),%eax
  80061a:	83 f8 30             	cmp    $0x30,%eax
  80061d:	73 24                	jae    800643 <getuint+0x44>
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
  800641:	eb 17                	jmp    80065a <getuint+0x5b>
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80064b:	48 89 d0             	mov    %rdx,%rax
  80064e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800652:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800656:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80065a:	48 8b 00             	mov    (%rax),%rax
  80065d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800661:	e9 a3 00 00 00       	jmpq   800709 <getuint+0x10a>
	else if (lflag)
  800666:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80066a:	74 4f                	je     8006bb <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80066c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800670:	8b 00                	mov    (%rax),%eax
  800672:	83 f8 30             	cmp    $0x30,%eax
  800675:	73 24                	jae    80069b <getuint+0x9c>
  800677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80067f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800683:	8b 00                	mov    (%rax),%eax
  800685:	89 c0                	mov    %eax,%eax
  800687:	48 01 d0             	add    %rdx,%rax
  80068a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068e:	8b 12                	mov    (%rdx),%edx
  800690:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800693:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800697:	89 0a                	mov    %ecx,(%rdx)
  800699:	eb 17                	jmp    8006b2 <getuint+0xb3>
  80069b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006a3:	48 89 d0             	mov    %rdx,%rax
  8006a6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006b2:	48 8b 00             	mov    (%rax),%rax
  8006b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006b9:	eb 4e                	jmp    800709 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bf:	8b 00                	mov    (%rax),%eax
  8006c1:	83 f8 30             	cmp    $0x30,%eax
  8006c4:	73 24                	jae    8006ea <getuint+0xeb>
  8006c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ca:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d2:	8b 00                	mov    (%rax),%eax
  8006d4:	89 c0                	mov    %eax,%eax
  8006d6:	48 01 d0             	add    %rdx,%rax
  8006d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006dd:	8b 12                	mov    (%rdx),%edx
  8006df:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e6:	89 0a                	mov    %ecx,(%rdx)
  8006e8:	eb 17                	jmp    800701 <getuint+0x102>
  8006ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ee:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006f2:	48 89 d0             	mov    %rdx,%rax
  8006f5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800701:	8b 00                	mov    (%rax),%eax
  800703:	89 c0                	mov    %eax,%eax
  800705:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800709:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80070d:	c9                   	leaveq 
  80070e:	c3                   	retq   

000000000080070f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80070f:	55                   	push   %rbp
  800710:	48 89 e5             	mov    %rsp,%rbp
  800713:	48 83 ec 1c          	sub    $0x1c,%rsp
  800717:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80071b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80071e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800722:	7e 52                	jle    800776 <getint+0x67>
		x=va_arg(*ap, long long);
  800724:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800728:	8b 00                	mov    (%rax),%eax
  80072a:	83 f8 30             	cmp    $0x30,%eax
  80072d:	73 24                	jae    800753 <getint+0x44>
  80072f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800733:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800737:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073b:	8b 00                	mov    (%rax),%eax
  80073d:	89 c0                	mov    %eax,%eax
  80073f:	48 01 d0             	add    %rdx,%rax
  800742:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800746:	8b 12                	mov    (%rdx),%edx
  800748:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80074b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074f:	89 0a                	mov    %ecx,(%rdx)
  800751:	eb 17                	jmp    80076a <getint+0x5b>
  800753:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800757:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80075b:	48 89 d0             	mov    %rdx,%rax
  80075e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800762:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800766:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80076a:	48 8b 00             	mov    (%rax),%rax
  80076d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800771:	e9 a3 00 00 00       	jmpq   800819 <getint+0x10a>
	else if (lflag)
  800776:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80077a:	74 4f                	je     8007cb <getint+0xbc>
		x=va_arg(*ap, long);
  80077c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800780:	8b 00                	mov    (%rax),%eax
  800782:	83 f8 30             	cmp    $0x30,%eax
  800785:	73 24                	jae    8007ab <getint+0x9c>
  800787:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80078f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800793:	8b 00                	mov    (%rax),%eax
  800795:	89 c0                	mov    %eax,%eax
  800797:	48 01 d0             	add    %rdx,%rax
  80079a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079e:	8b 12                	mov    (%rdx),%edx
  8007a0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a7:	89 0a                	mov    %ecx,(%rdx)
  8007a9:	eb 17                	jmp    8007c2 <getint+0xb3>
  8007ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007af:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007b3:	48 89 d0             	mov    %rdx,%rax
  8007b6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007be:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007c2:	48 8b 00             	mov    (%rax),%rax
  8007c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007c9:	eb 4e                	jmp    800819 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cf:	8b 00                	mov    (%rax),%eax
  8007d1:	83 f8 30             	cmp    $0x30,%eax
  8007d4:	73 24                	jae    8007fa <getint+0xeb>
  8007d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007da:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e2:	8b 00                	mov    (%rax),%eax
  8007e4:	89 c0                	mov    %eax,%eax
  8007e6:	48 01 d0             	add    %rdx,%rax
  8007e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ed:	8b 12                	mov    (%rdx),%edx
  8007ef:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f6:	89 0a                	mov    %ecx,(%rdx)
  8007f8:	eb 17                	jmp    800811 <getint+0x102>
  8007fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fe:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800802:	48 89 d0             	mov    %rdx,%rax
  800805:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800809:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800811:	8b 00                	mov    (%rax),%eax
  800813:	48 98                	cltq   
  800815:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800819:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80081d:	c9                   	leaveq 
  80081e:	c3                   	retq   

000000000080081f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80081f:	55                   	push   %rbp
  800820:	48 89 e5             	mov    %rsp,%rbp
  800823:	41 54                	push   %r12
  800825:	53                   	push   %rbx
  800826:	48 83 ec 60          	sub    $0x60,%rsp
  80082a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80082e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800832:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800836:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80083a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80083e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800842:	48 8b 0a             	mov    (%rdx),%rcx
  800845:	48 89 08             	mov    %rcx,(%rax)
  800848:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80084c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800850:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800854:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  800858:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80085c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800860:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800864:	0f b6 00             	movzbl (%rax),%eax
  800867:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  80086a:	eb 29                	jmp    800895 <vprintfmt+0x76>
			if (ch == '\0')
  80086c:	85 db                	test   %ebx,%ebx
  80086e:	0f 84 ad 06 00 00    	je     800f21 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  800874:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800878:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80087c:	48 89 d6             	mov    %rdx,%rsi
  80087f:	89 df                	mov    %ebx,%edi
  800881:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  800883:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800887:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80088b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80088f:	0f b6 00             	movzbl (%rax),%eax
  800892:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  800895:	83 fb 25             	cmp    $0x25,%ebx
  800898:	74 05                	je     80089f <vprintfmt+0x80>
  80089a:	83 fb 1b             	cmp    $0x1b,%ebx
  80089d:	75 cd                	jne    80086c <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  80089f:	83 fb 1b             	cmp    $0x1b,%ebx
  8008a2:	0f 85 ae 01 00 00    	jne    800a56 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  8008a8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8008af:	00 00 00 
  8008b2:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  8008b8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008bc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008c0:	48 89 d6             	mov    %rdx,%rsi
  8008c3:	89 df                	mov    %ebx,%edi
  8008c5:	ff d0                	callq  *%rax
			putch('[', putdat);
  8008c7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008cb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008cf:	48 89 d6             	mov    %rdx,%rsi
  8008d2:	bf 5b 00 00 00       	mov    $0x5b,%edi
  8008d7:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  8008d9:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  8008df:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8008e4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008e8:	0f b6 00             	movzbl (%rax),%eax
  8008eb:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8008ee:	eb 32                	jmp    800922 <vprintfmt+0x103>
					putch(ch, putdat);
  8008f0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008f4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f8:	48 89 d6             	mov    %rdx,%rsi
  8008fb:	89 df                	mov    %ebx,%edi
  8008fd:	ff d0                	callq  *%rax
					esc_color *= 10;
  8008ff:	44 89 e0             	mov    %r12d,%eax
  800902:	c1 e0 02             	shl    $0x2,%eax
  800905:	44 01 e0             	add    %r12d,%eax
  800908:	01 c0                	add    %eax,%eax
  80090a:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  80090d:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800910:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800913:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800918:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80091c:	0f b6 00             	movzbl (%rax),%eax
  80091f:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800922:	83 fb 3b             	cmp    $0x3b,%ebx
  800925:	74 05                	je     80092c <vprintfmt+0x10d>
  800927:	83 fb 6d             	cmp    $0x6d,%ebx
  80092a:	75 c4                	jne    8008f0 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  80092c:	45 85 e4             	test   %r12d,%r12d
  80092f:	75 15                	jne    800946 <vprintfmt+0x127>
					color_flag = 0x07;
  800931:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800938:	00 00 00 
  80093b:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800941:	e9 dc 00 00 00       	jmpq   800a22 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800946:	41 83 fc 1d          	cmp    $0x1d,%r12d
  80094a:	7e 69                	jle    8009b5 <vprintfmt+0x196>
  80094c:	41 83 fc 25          	cmp    $0x25,%r12d
  800950:	7f 63                	jg     8009b5 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800952:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800959:	00 00 00 
  80095c:	8b 00                	mov    (%rax),%eax
  80095e:	25 f8 00 00 00       	and    $0xf8,%eax
  800963:	89 c2                	mov    %eax,%edx
  800965:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80096c:	00 00 00 
  80096f:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800971:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800975:	44 89 e0             	mov    %r12d,%eax
  800978:	83 e0 04             	and    $0x4,%eax
  80097b:	c1 f8 02             	sar    $0x2,%eax
  80097e:	89 c2                	mov    %eax,%edx
  800980:	44 89 e0             	mov    %r12d,%eax
  800983:	83 e0 02             	and    $0x2,%eax
  800986:	09 c2                	or     %eax,%edx
  800988:	44 89 e0             	mov    %r12d,%eax
  80098b:	83 e0 01             	and    $0x1,%eax
  80098e:	c1 e0 02             	shl    $0x2,%eax
  800991:	09 c2                	or     %eax,%edx
  800993:	41 89 d4             	mov    %edx,%r12d
  800996:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80099d:	00 00 00 
  8009a0:	8b 00                	mov    (%rax),%eax
  8009a2:	44 89 e2             	mov    %r12d,%edx
  8009a5:	09 c2                	or     %eax,%edx
  8009a7:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8009ae:	00 00 00 
  8009b1:	89 10                	mov    %edx,(%rax)
  8009b3:	eb 6d                	jmp    800a22 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  8009b5:	41 83 fc 27          	cmp    $0x27,%r12d
  8009b9:	7e 67                	jle    800a22 <vprintfmt+0x203>
  8009bb:	41 83 fc 2f          	cmp    $0x2f,%r12d
  8009bf:	7f 61                	jg     800a22 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  8009c1:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8009c8:	00 00 00 
  8009cb:	8b 00                	mov    (%rax),%eax
  8009cd:	25 8f 00 00 00       	and    $0x8f,%eax
  8009d2:	89 c2                	mov    %eax,%edx
  8009d4:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8009db:	00 00 00 
  8009de:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  8009e0:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  8009e4:	44 89 e0             	mov    %r12d,%eax
  8009e7:	83 e0 04             	and    $0x4,%eax
  8009ea:	c1 f8 02             	sar    $0x2,%eax
  8009ed:	89 c2                	mov    %eax,%edx
  8009ef:	44 89 e0             	mov    %r12d,%eax
  8009f2:	83 e0 02             	and    $0x2,%eax
  8009f5:	09 c2                	or     %eax,%edx
  8009f7:	44 89 e0             	mov    %r12d,%eax
  8009fa:	83 e0 01             	and    $0x1,%eax
  8009fd:	c1 e0 06             	shl    $0x6,%eax
  800a00:	09 c2                	or     %eax,%edx
  800a02:	41 89 d4             	mov    %edx,%r12d
  800a05:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800a0c:	00 00 00 
  800a0f:	8b 00                	mov    (%rax),%eax
  800a11:	44 89 e2             	mov    %r12d,%edx
  800a14:	09 c2                	or     %eax,%edx
  800a16:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800a1d:	00 00 00 
  800a20:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800a22:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2a:	48 89 d6             	mov    %rdx,%rsi
  800a2d:	89 df                	mov    %ebx,%edi
  800a2f:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800a31:	83 fb 6d             	cmp    $0x6d,%ebx
  800a34:	75 1b                	jne    800a51 <vprintfmt+0x232>
					fmt ++;
  800a36:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800a3b:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800a3c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800a43:	00 00 00 
  800a46:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800a4c:	e9 cb 04 00 00       	jmpq   800f1c <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800a51:	e9 83 fe ff ff       	jmpq   8008d9 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800a56:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a5a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a61:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a68:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a6f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a76:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a7a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a7e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a82:	0f b6 00             	movzbl (%rax),%eax
  800a85:	0f b6 d8             	movzbl %al,%ebx
  800a88:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a8b:	83 f8 55             	cmp    $0x55,%eax
  800a8e:	0f 87 5a 04 00 00    	ja     800eee <vprintfmt+0x6cf>
  800a94:	89 c0                	mov    %eax,%eax
  800a96:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a9d:	00 
  800a9e:	48 b8 d0 39 80 00 00 	movabs $0x8039d0,%rax
  800aa5:	00 00 00 
  800aa8:	48 01 d0             	add    %rdx,%rax
  800aab:	48 8b 00             	mov    (%rax),%rax
  800aae:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ab0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ab4:	eb c0                	jmp    800a76 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ab6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800aba:	eb ba                	jmp    800a76 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800abc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ac3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ac6:	89 d0                	mov    %edx,%eax
  800ac8:	c1 e0 02             	shl    $0x2,%eax
  800acb:	01 d0                	add    %edx,%eax
  800acd:	01 c0                	add    %eax,%eax
  800acf:	01 d8                	add    %ebx,%eax
  800ad1:	83 e8 30             	sub    $0x30,%eax
  800ad4:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ad7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800adb:	0f b6 00             	movzbl (%rax),%eax
  800ade:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ae1:	83 fb 2f             	cmp    $0x2f,%ebx
  800ae4:	7e 0c                	jle    800af2 <vprintfmt+0x2d3>
  800ae6:	83 fb 39             	cmp    $0x39,%ebx
  800ae9:	7f 07                	jg     800af2 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aeb:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800af0:	eb d1                	jmp    800ac3 <vprintfmt+0x2a4>
			goto process_precision;
  800af2:	eb 58                	jmp    800b4c <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800af4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af7:	83 f8 30             	cmp    $0x30,%eax
  800afa:	73 17                	jae    800b13 <vprintfmt+0x2f4>
  800afc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b03:	89 c0                	mov    %eax,%eax
  800b05:	48 01 d0             	add    %rdx,%rax
  800b08:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b0b:	83 c2 08             	add    $0x8,%edx
  800b0e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b11:	eb 0f                	jmp    800b22 <vprintfmt+0x303>
  800b13:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b17:	48 89 d0             	mov    %rdx,%rax
  800b1a:	48 83 c2 08          	add    $0x8,%rdx
  800b1e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b22:	8b 00                	mov    (%rax),%eax
  800b24:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b27:	eb 23                	jmp    800b4c <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800b29:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b2d:	79 0c                	jns    800b3b <vprintfmt+0x31c>
				width = 0;
  800b2f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b36:	e9 3b ff ff ff       	jmpq   800a76 <vprintfmt+0x257>
  800b3b:	e9 36 ff ff ff       	jmpq   800a76 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800b40:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b47:	e9 2a ff ff ff       	jmpq   800a76 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800b4c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b50:	79 12                	jns    800b64 <vprintfmt+0x345>
				width = precision, precision = -1;
  800b52:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b55:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b58:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b5f:	e9 12 ff ff ff       	jmpq   800a76 <vprintfmt+0x257>
  800b64:	e9 0d ff ff ff       	jmpq   800a76 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b69:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b6d:	e9 04 ff ff ff       	jmpq   800a76 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b72:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b75:	83 f8 30             	cmp    $0x30,%eax
  800b78:	73 17                	jae    800b91 <vprintfmt+0x372>
  800b7a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b7e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b81:	89 c0                	mov    %eax,%eax
  800b83:	48 01 d0             	add    %rdx,%rax
  800b86:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b89:	83 c2 08             	add    $0x8,%edx
  800b8c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b8f:	eb 0f                	jmp    800ba0 <vprintfmt+0x381>
  800b91:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b95:	48 89 d0             	mov    %rdx,%rax
  800b98:	48 83 c2 08          	add    $0x8,%rdx
  800b9c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ba0:	8b 10                	mov    (%rax),%edx
  800ba2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ba6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800baa:	48 89 ce             	mov    %rcx,%rsi
  800bad:	89 d7                	mov    %edx,%edi
  800baf:	ff d0                	callq  *%rax
			break;
  800bb1:	e9 66 03 00 00       	jmpq   800f1c <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800bb6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb9:	83 f8 30             	cmp    $0x30,%eax
  800bbc:	73 17                	jae    800bd5 <vprintfmt+0x3b6>
  800bbe:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc5:	89 c0                	mov    %eax,%eax
  800bc7:	48 01 d0             	add    %rdx,%rax
  800bca:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bcd:	83 c2 08             	add    $0x8,%edx
  800bd0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bd3:	eb 0f                	jmp    800be4 <vprintfmt+0x3c5>
  800bd5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bd9:	48 89 d0             	mov    %rdx,%rax
  800bdc:	48 83 c2 08          	add    $0x8,%rdx
  800be0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800be4:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800be6:	85 db                	test   %ebx,%ebx
  800be8:	79 02                	jns    800bec <vprintfmt+0x3cd>
				err = -err;
  800bea:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bec:	83 fb 10             	cmp    $0x10,%ebx
  800bef:	7f 16                	jg     800c07 <vprintfmt+0x3e8>
  800bf1:	48 b8 20 39 80 00 00 	movabs $0x803920,%rax
  800bf8:	00 00 00 
  800bfb:	48 63 d3             	movslq %ebx,%rdx
  800bfe:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c02:	4d 85 e4             	test   %r12,%r12
  800c05:	75 2e                	jne    800c35 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800c07:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0f:	89 d9                	mov    %ebx,%ecx
  800c11:	48 ba b9 39 80 00 00 	movabs $0x8039b9,%rdx
  800c18:	00 00 00 
  800c1b:	48 89 c7             	mov    %rax,%rdi
  800c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c23:	49 b8 2a 0f 80 00 00 	movabs $0x800f2a,%r8
  800c2a:	00 00 00 
  800c2d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c30:	e9 e7 02 00 00       	jmpq   800f1c <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c35:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c39:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3d:	4c 89 e1             	mov    %r12,%rcx
  800c40:	48 ba c2 39 80 00 00 	movabs $0x8039c2,%rdx
  800c47:	00 00 00 
  800c4a:	48 89 c7             	mov    %rax,%rdi
  800c4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c52:	49 b8 2a 0f 80 00 00 	movabs $0x800f2a,%r8
  800c59:	00 00 00 
  800c5c:	41 ff d0             	callq  *%r8
			break;
  800c5f:	e9 b8 02 00 00       	jmpq   800f1c <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c64:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c67:	83 f8 30             	cmp    $0x30,%eax
  800c6a:	73 17                	jae    800c83 <vprintfmt+0x464>
  800c6c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c70:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c73:	89 c0                	mov    %eax,%eax
  800c75:	48 01 d0             	add    %rdx,%rax
  800c78:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c7b:	83 c2 08             	add    $0x8,%edx
  800c7e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c81:	eb 0f                	jmp    800c92 <vprintfmt+0x473>
  800c83:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c87:	48 89 d0             	mov    %rdx,%rax
  800c8a:	48 83 c2 08          	add    $0x8,%rdx
  800c8e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c92:	4c 8b 20             	mov    (%rax),%r12
  800c95:	4d 85 e4             	test   %r12,%r12
  800c98:	75 0a                	jne    800ca4 <vprintfmt+0x485>
				p = "(null)";
  800c9a:	49 bc c5 39 80 00 00 	movabs $0x8039c5,%r12
  800ca1:	00 00 00 
			if (width > 0 && padc != '-')
  800ca4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ca8:	7e 3f                	jle    800ce9 <vprintfmt+0x4ca>
  800caa:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cae:	74 39                	je     800ce9 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cb0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cb3:	48 98                	cltq   
  800cb5:	48 89 c6             	mov    %rax,%rsi
  800cb8:	4c 89 e7             	mov    %r12,%rdi
  800cbb:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  800cc2:	00 00 00 
  800cc5:	ff d0                	callq  *%rax
  800cc7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cca:	eb 17                	jmp    800ce3 <vprintfmt+0x4c4>
					putch(padc, putdat);
  800ccc:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cd0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cd4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd8:	48 89 ce             	mov    %rcx,%rsi
  800cdb:	89 d7                	mov    %edx,%edi
  800cdd:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cdf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ce3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ce7:	7f e3                	jg     800ccc <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ce9:	eb 37                	jmp    800d22 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800ceb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cef:	74 1e                	je     800d0f <vprintfmt+0x4f0>
  800cf1:	83 fb 1f             	cmp    $0x1f,%ebx
  800cf4:	7e 05                	jle    800cfb <vprintfmt+0x4dc>
  800cf6:	83 fb 7e             	cmp    $0x7e,%ebx
  800cf9:	7e 14                	jle    800d0f <vprintfmt+0x4f0>
					putch('?', putdat);
  800cfb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d03:	48 89 d6             	mov    %rdx,%rsi
  800d06:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d0b:	ff d0                	callq  *%rax
  800d0d:	eb 0f                	jmp    800d1e <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800d0f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d17:	48 89 d6             	mov    %rdx,%rsi
  800d1a:	89 df                	mov    %ebx,%edi
  800d1c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d1e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d22:	4c 89 e0             	mov    %r12,%rax
  800d25:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d29:	0f b6 00             	movzbl (%rax),%eax
  800d2c:	0f be d8             	movsbl %al,%ebx
  800d2f:	85 db                	test   %ebx,%ebx
  800d31:	74 10                	je     800d43 <vprintfmt+0x524>
  800d33:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d37:	78 b2                	js     800ceb <vprintfmt+0x4cc>
  800d39:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d3d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d41:	79 a8                	jns    800ceb <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d43:	eb 16                	jmp    800d5b <vprintfmt+0x53c>
				putch(' ', putdat);
  800d45:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d49:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4d:	48 89 d6             	mov    %rdx,%rsi
  800d50:	bf 20 00 00 00       	mov    $0x20,%edi
  800d55:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d57:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d5f:	7f e4                	jg     800d45 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800d61:	e9 b6 01 00 00       	jmpq   800f1c <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d66:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d6a:	be 03 00 00 00       	mov    $0x3,%esi
  800d6f:	48 89 c7             	mov    %rax,%rdi
  800d72:	48 b8 0f 07 80 00 00 	movabs $0x80070f,%rax
  800d79:	00 00 00 
  800d7c:	ff d0                	callq  *%rax
  800d7e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d86:	48 85 c0             	test   %rax,%rax
  800d89:	79 1d                	jns    800da8 <vprintfmt+0x589>
				putch('-', putdat);
  800d8b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d8f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d93:	48 89 d6             	mov    %rdx,%rsi
  800d96:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d9b:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da1:	48 f7 d8             	neg    %rax
  800da4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800da8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800daf:	e9 fb 00 00 00       	jmpq   800eaf <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800db4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800db8:	be 03 00 00 00       	mov    $0x3,%esi
  800dbd:	48 89 c7             	mov    %rax,%rdi
  800dc0:	48 b8 ff 05 80 00 00 	movabs $0x8005ff,%rax
  800dc7:	00 00 00 
  800dca:	ff d0                	callq  *%rax
  800dcc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dd0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dd7:	e9 d3 00 00 00       	jmpq   800eaf <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800ddc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800de0:	be 03 00 00 00       	mov    $0x3,%esi
  800de5:	48 89 c7             	mov    %rax,%rdi
  800de8:	48 b8 0f 07 80 00 00 	movabs $0x80070f,%rax
  800def:	00 00 00 
  800df2:	ff d0                	callq  *%rax
  800df4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800df8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dfc:	48 85 c0             	test   %rax,%rax
  800dff:	79 1d                	jns    800e1e <vprintfmt+0x5ff>
				putch('-', putdat);
  800e01:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e05:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e09:	48 89 d6             	mov    %rdx,%rsi
  800e0c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e11:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e17:	48 f7 d8             	neg    %rax
  800e1a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800e1e:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e25:	e9 85 00 00 00       	jmpq   800eaf <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800e2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e32:	48 89 d6             	mov    %rdx,%rsi
  800e35:	bf 30 00 00 00       	mov    $0x30,%edi
  800e3a:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e3c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e44:	48 89 d6             	mov    %rdx,%rsi
  800e47:	bf 78 00 00 00       	mov    $0x78,%edi
  800e4c:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e4e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e51:	83 f8 30             	cmp    $0x30,%eax
  800e54:	73 17                	jae    800e6d <vprintfmt+0x64e>
  800e56:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e5a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e5d:	89 c0                	mov    %eax,%eax
  800e5f:	48 01 d0             	add    %rdx,%rax
  800e62:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e65:	83 c2 08             	add    $0x8,%edx
  800e68:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e6b:	eb 0f                	jmp    800e7c <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800e6d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e71:	48 89 d0             	mov    %rdx,%rax
  800e74:	48 83 c2 08          	add    $0x8,%rdx
  800e78:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e7c:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e7f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e83:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e8a:	eb 23                	jmp    800eaf <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e8c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e90:	be 03 00 00 00       	mov    $0x3,%esi
  800e95:	48 89 c7             	mov    %rax,%rdi
  800e98:	48 b8 ff 05 80 00 00 	movabs $0x8005ff,%rax
  800e9f:	00 00 00 
  800ea2:	ff d0                	callq  *%rax
  800ea4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ea8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800eaf:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800eb4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800eb7:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800eba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ebe:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ec2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec6:	45 89 c1             	mov    %r8d,%r9d
  800ec9:	41 89 f8             	mov    %edi,%r8d
  800ecc:	48 89 c7             	mov    %rax,%rdi
  800ecf:	48 b8 44 05 80 00 00 	movabs $0x800544,%rax
  800ed6:	00 00 00 
  800ed9:	ff d0                	callq  *%rax
			break;
  800edb:	eb 3f                	jmp    800f1c <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800edd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee5:	48 89 d6             	mov    %rdx,%rsi
  800ee8:	89 df                	mov    %ebx,%edi
  800eea:	ff d0                	callq  *%rax
			break;
  800eec:	eb 2e                	jmp    800f1c <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef6:	48 89 d6             	mov    %rdx,%rsi
  800ef9:	bf 25 00 00 00       	mov    $0x25,%edi
  800efe:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f00:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f05:	eb 05                	jmp    800f0c <vprintfmt+0x6ed>
  800f07:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f0c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f10:	48 83 e8 01          	sub    $0x1,%rax
  800f14:	0f b6 00             	movzbl (%rax),%eax
  800f17:	3c 25                	cmp    $0x25,%al
  800f19:	75 ec                	jne    800f07 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  800f1b:	90                   	nop
		}
	}
  800f1c:	e9 37 f9 ff ff       	jmpq   800858 <vprintfmt+0x39>
    va_end(aq);
}
  800f21:	48 83 c4 60          	add    $0x60,%rsp
  800f25:	5b                   	pop    %rbx
  800f26:	41 5c                	pop    %r12
  800f28:	5d                   	pop    %rbp
  800f29:	c3                   	retq   

0000000000800f2a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f2a:	55                   	push   %rbp
  800f2b:	48 89 e5             	mov    %rsp,%rbp
  800f2e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f35:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f3c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f43:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f4a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f51:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f58:	84 c0                	test   %al,%al
  800f5a:	74 20                	je     800f7c <printfmt+0x52>
  800f5c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f60:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f64:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f68:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f6c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f70:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f74:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f78:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f7c:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f83:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f8a:	00 00 00 
  800f8d:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f94:	00 00 00 
  800f97:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f9b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fa2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fa9:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fb0:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fb7:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fbe:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fc5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fcc:	48 89 c7             	mov    %rax,%rdi
  800fcf:	48 b8 1f 08 80 00 00 	movabs $0x80081f,%rax
  800fd6:	00 00 00 
  800fd9:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fdb:	c9                   	leaveq 
  800fdc:	c3                   	retq   

0000000000800fdd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fdd:	55                   	push   %rbp
  800fde:	48 89 e5             	mov    %rsp,%rbp
  800fe1:	48 83 ec 10          	sub    $0x10,%rsp
  800fe5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fe8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff0:	8b 40 10             	mov    0x10(%rax),%eax
  800ff3:	8d 50 01             	lea    0x1(%rax),%edx
  800ff6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ffa:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ffd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801001:	48 8b 10             	mov    (%rax),%rdx
  801004:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801008:	48 8b 40 08          	mov    0x8(%rax),%rax
  80100c:	48 39 c2             	cmp    %rax,%rdx
  80100f:	73 17                	jae    801028 <sprintputch+0x4b>
		*b->buf++ = ch;
  801011:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801015:	48 8b 00             	mov    (%rax),%rax
  801018:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80101c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801020:	48 89 0a             	mov    %rcx,(%rdx)
  801023:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801026:	88 10                	mov    %dl,(%rax)
}
  801028:	c9                   	leaveq 
  801029:	c3                   	retq   

000000000080102a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80102a:	55                   	push   %rbp
  80102b:	48 89 e5             	mov    %rsp,%rbp
  80102e:	48 83 ec 50          	sub    $0x50,%rsp
  801032:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801036:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801039:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80103d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801041:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801045:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801049:	48 8b 0a             	mov    (%rdx),%rcx
  80104c:	48 89 08             	mov    %rcx,(%rax)
  80104f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801053:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801057:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80105b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80105f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801063:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801067:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80106a:	48 98                	cltq   
  80106c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801070:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801074:	48 01 d0             	add    %rdx,%rax
  801077:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80107b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801082:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801087:	74 06                	je     80108f <vsnprintf+0x65>
  801089:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80108d:	7f 07                	jg     801096 <vsnprintf+0x6c>
		return -E_INVAL;
  80108f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801094:	eb 2f                	jmp    8010c5 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801096:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80109a:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80109e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010a2:	48 89 c6             	mov    %rax,%rsi
  8010a5:	48 bf dd 0f 80 00 00 	movabs $0x800fdd,%rdi
  8010ac:	00 00 00 
  8010af:	48 b8 1f 08 80 00 00 	movabs $0x80081f,%rax
  8010b6:	00 00 00 
  8010b9:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010bf:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010c2:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010c5:	c9                   	leaveq 
  8010c6:	c3                   	retq   

00000000008010c7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010c7:	55                   	push   %rbp
  8010c8:	48 89 e5             	mov    %rsp,%rbp
  8010cb:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010d2:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010d9:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010df:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010e6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010ed:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010f4:	84 c0                	test   %al,%al
  8010f6:	74 20                	je     801118 <snprintf+0x51>
  8010f8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010fc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801100:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801104:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801108:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80110c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801110:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801114:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801118:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80111f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801126:	00 00 00 
  801129:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801130:	00 00 00 
  801133:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801137:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80113e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801145:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80114c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801153:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80115a:	48 8b 0a             	mov    (%rdx),%rcx
  80115d:	48 89 08             	mov    %rcx,(%rax)
  801160:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801164:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801168:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80116c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801170:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801177:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80117e:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801184:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80118b:	48 89 c7             	mov    %rax,%rdi
  80118e:	48 b8 2a 10 80 00 00 	movabs $0x80102a,%rax
  801195:	00 00 00 
  801198:	ff d0                	callq  *%rax
  80119a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8011a0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011a6:	c9                   	leaveq 
  8011a7:	c3                   	retq   

00000000008011a8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011a8:	55                   	push   %rbp
  8011a9:	48 89 e5             	mov    %rsp,%rbp
  8011ac:	48 83 ec 18          	sub    $0x18,%rsp
  8011b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011bb:	eb 09                	jmp    8011c6 <strlen+0x1e>
		n++;
  8011bd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011c1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ca:	0f b6 00             	movzbl (%rax),%eax
  8011cd:	84 c0                	test   %al,%al
  8011cf:	75 ec                	jne    8011bd <strlen+0x15>
		n++;
	return n;
  8011d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011d4:	c9                   	leaveq 
  8011d5:	c3                   	retq   

00000000008011d6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011d6:	55                   	push   %rbp
  8011d7:	48 89 e5             	mov    %rsp,%rbp
  8011da:	48 83 ec 20          	sub    $0x20,%rsp
  8011de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011ed:	eb 0e                	jmp    8011fd <strnlen+0x27>
		n++;
  8011ef:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011f3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011f8:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011fd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801202:	74 0b                	je     80120f <strnlen+0x39>
  801204:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801208:	0f b6 00             	movzbl (%rax),%eax
  80120b:	84 c0                	test   %al,%al
  80120d:	75 e0                	jne    8011ef <strnlen+0x19>
		n++;
	return n;
  80120f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801212:	c9                   	leaveq 
  801213:	c3                   	retq   

0000000000801214 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801214:	55                   	push   %rbp
  801215:	48 89 e5             	mov    %rsp,%rbp
  801218:	48 83 ec 20          	sub    $0x20,%rsp
  80121c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801220:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801228:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80122c:	90                   	nop
  80122d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801231:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801235:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801239:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80123d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801241:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801245:	0f b6 12             	movzbl (%rdx),%edx
  801248:	88 10                	mov    %dl,(%rax)
  80124a:	0f b6 00             	movzbl (%rax),%eax
  80124d:	84 c0                	test   %al,%al
  80124f:	75 dc                	jne    80122d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801251:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801255:	c9                   	leaveq 
  801256:	c3                   	retq   

0000000000801257 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801257:	55                   	push   %rbp
  801258:	48 89 e5             	mov    %rsp,%rbp
  80125b:	48 83 ec 20          	sub    $0x20,%rsp
  80125f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801263:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801267:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126b:	48 89 c7             	mov    %rax,%rdi
  80126e:	48 b8 a8 11 80 00 00 	movabs $0x8011a8,%rax
  801275:	00 00 00 
  801278:	ff d0                	callq  *%rax
  80127a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80127d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801280:	48 63 d0             	movslq %eax,%rdx
  801283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801287:	48 01 c2             	add    %rax,%rdx
  80128a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80128e:	48 89 c6             	mov    %rax,%rsi
  801291:	48 89 d7             	mov    %rdx,%rdi
  801294:	48 b8 14 12 80 00 00 	movabs $0x801214,%rax
  80129b:	00 00 00 
  80129e:	ff d0                	callq  *%rax
	return dst;
  8012a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012a4:	c9                   	leaveq 
  8012a5:	c3                   	retq   

00000000008012a6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012a6:	55                   	push   %rbp
  8012a7:	48 89 e5             	mov    %rsp,%rbp
  8012aa:	48 83 ec 28          	sub    $0x28,%rsp
  8012ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012c2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012c9:	00 
  8012ca:	eb 2a                	jmp    8012f6 <strncpy+0x50>
		*dst++ = *src;
  8012cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012d4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012d8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012dc:	0f b6 12             	movzbl (%rdx),%edx
  8012df:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012e5:	0f b6 00             	movzbl (%rax),%eax
  8012e8:	84 c0                	test   %al,%al
  8012ea:	74 05                	je     8012f1 <strncpy+0x4b>
			src++;
  8012ec:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fa:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012fe:	72 cc                	jb     8012cc <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801304:	c9                   	leaveq 
  801305:	c3                   	retq   

0000000000801306 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801306:	55                   	push   %rbp
  801307:	48 89 e5             	mov    %rsp,%rbp
  80130a:	48 83 ec 28          	sub    $0x28,%rsp
  80130e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801312:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801316:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80131a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801322:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801327:	74 3d                	je     801366 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801329:	eb 1d                	jmp    801348 <strlcpy+0x42>
			*dst++ = *src++;
  80132b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801333:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801337:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80133b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80133f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801343:	0f b6 12             	movzbl (%rdx),%edx
  801346:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801348:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80134d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801352:	74 0b                	je     80135f <strlcpy+0x59>
  801354:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801358:	0f b6 00             	movzbl (%rax),%eax
  80135b:	84 c0                	test   %al,%al
  80135d:	75 cc                	jne    80132b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80135f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801363:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801366:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80136a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136e:	48 29 c2             	sub    %rax,%rdx
  801371:	48 89 d0             	mov    %rdx,%rax
}
  801374:	c9                   	leaveq 
  801375:	c3                   	retq   

0000000000801376 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801376:	55                   	push   %rbp
  801377:	48 89 e5             	mov    %rsp,%rbp
  80137a:	48 83 ec 10          	sub    $0x10,%rsp
  80137e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801382:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801386:	eb 0a                	jmp    801392 <strcmp+0x1c>
		p++, q++;
  801388:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80138d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801392:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801396:	0f b6 00             	movzbl (%rax),%eax
  801399:	84 c0                	test   %al,%al
  80139b:	74 12                	je     8013af <strcmp+0x39>
  80139d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a1:	0f b6 10             	movzbl (%rax),%edx
  8013a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a8:	0f b6 00             	movzbl (%rax),%eax
  8013ab:	38 c2                	cmp    %al,%dl
  8013ad:	74 d9                	je     801388 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b3:	0f b6 00             	movzbl (%rax),%eax
  8013b6:	0f b6 d0             	movzbl %al,%edx
  8013b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013bd:	0f b6 00             	movzbl (%rax),%eax
  8013c0:	0f b6 c0             	movzbl %al,%eax
  8013c3:	29 c2                	sub    %eax,%edx
  8013c5:	89 d0                	mov    %edx,%eax
}
  8013c7:	c9                   	leaveq 
  8013c8:	c3                   	retq   

00000000008013c9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013c9:	55                   	push   %rbp
  8013ca:	48 89 e5             	mov    %rsp,%rbp
  8013cd:	48 83 ec 18          	sub    $0x18,%rsp
  8013d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013d5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013d9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013dd:	eb 0f                	jmp    8013ee <strncmp+0x25>
		n--, p++, q++;
  8013df:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013e4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013ee:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013f3:	74 1d                	je     801412 <strncmp+0x49>
  8013f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f9:	0f b6 00             	movzbl (%rax),%eax
  8013fc:	84 c0                	test   %al,%al
  8013fe:	74 12                	je     801412 <strncmp+0x49>
  801400:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801404:	0f b6 10             	movzbl (%rax),%edx
  801407:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140b:	0f b6 00             	movzbl (%rax),%eax
  80140e:	38 c2                	cmp    %al,%dl
  801410:	74 cd                	je     8013df <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801412:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801417:	75 07                	jne    801420 <strncmp+0x57>
		return 0;
  801419:	b8 00 00 00 00       	mov    $0x0,%eax
  80141e:	eb 18                	jmp    801438 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801420:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801424:	0f b6 00             	movzbl (%rax),%eax
  801427:	0f b6 d0             	movzbl %al,%edx
  80142a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142e:	0f b6 00             	movzbl (%rax),%eax
  801431:	0f b6 c0             	movzbl %al,%eax
  801434:	29 c2                	sub    %eax,%edx
  801436:	89 d0                	mov    %edx,%eax
}
  801438:	c9                   	leaveq 
  801439:	c3                   	retq   

000000000080143a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80143a:	55                   	push   %rbp
  80143b:	48 89 e5             	mov    %rsp,%rbp
  80143e:	48 83 ec 0c          	sub    $0xc,%rsp
  801442:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801446:	89 f0                	mov    %esi,%eax
  801448:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80144b:	eb 17                	jmp    801464 <strchr+0x2a>
		if (*s == c)
  80144d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801451:	0f b6 00             	movzbl (%rax),%eax
  801454:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801457:	75 06                	jne    80145f <strchr+0x25>
			return (char *) s;
  801459:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145d:	eb 15                	jmp    801474 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80145f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801464:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801468:	0f b6 00             	movzbl (%rax),%eax
  80146b:	84 c0                	test   %al,%al
  80146d:	75 de                	jne    80144d <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80146f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801474:	c9                   	leaveq 
  801475:	c3                   	retq   

0000000000801476 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801476:	55                   	push   %rbp
  801477:	48 89 e5             	mov    %rsp,%rbp
  80147a:	48 83 ec 0c          	sub    $0xc,%rsp
  80147e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801482:	89 f0                	mov    %esi,%eax
  801484:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801487:	eb 13                	jmp    80149c <strfind+0x26>
		if (*s == c)
  801489:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148d:	0f b6 00             	movzbl (%rax),%eax
  801490:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801493:	75 02                	jne    801497 <strfind+0x21>
			break;
  801495:	eb 10                	jmp    8014a7 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801497:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80149c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a0:	0f b6 00             	movzbl (%rax),%eax
  8014a3:	84 c0                	test   %al,%al
  8014a5:	75 e2                	jne    801489 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014ab:	c9                   	leaveq 
  8014ac:	c3                   	retq   

00000000008014ad <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014ad:	55                   	push   %rbp
  8014ae:	48 89 e5             	mov    %rsp,%rbp
  8014b1:	48 83 ec 18          	sub    $0x18,%rsp
  8014b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b9:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014bc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014c0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014c5:	75 06                	jne    8014cd <memset+0x20>
		return v;
  8014c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cb:	eb 69                	jmp    801536 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d1:	83 e0 03             	and    $0x3,%eax
  8014d4:	48 85 c0             	test   %rax,%rax
  8014d7:	75 48                	jne    801521 <memset+0x74>
  8014d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014dd:	83 e0 03             	and    $0x3,%eax
  8014e0:	48 85 c0             	test   %rax,%rax
  8014e3:	75 3c                	jne    801521 <memset+0x74>
		c &= 0xFF;
  8014e5:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ef:	c1 e0 18             	shl    $0x18,%eax
  8014f2:	89 c2                	mov    %eax,%edx
  8014f4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f7:	c1 e0 10             	shl    $0x10,%eax
  8014fa:	09 c2                	or     %eax,%edx
  8014fc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ff:	c1 e0 08             	shl    $0x8,%eax
  801502:	09 d0                	or     %edx,%eax
  801504:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150b:	48 c1 e8 02          	shr    $0x2,%rax
  80150f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801512:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801516:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801519:	48 89 d7             	mov    %rdx,%rdi
  80151c:	fc                   	cld    
  80151d:	f3 ab                	rep stos %eax,%es:(%rdi)
  80151f:	eb 11                	jmp    801532 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801521:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801525:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801528:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80152c:	48 89 d7             	mov    %rdx,%rdi
  80152f:	fc                   	cld    
  801530:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801532:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801536:	c9                   	leaveq 
  801537:	c3                   	retq   

0000000000801538 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801538:	55                   	push   %rbp
  801539:	48 89 e5             	mov    %rsp,%rbp
  80153c:	48 83 ec 28          	sub    $0x28,%rsp
  801540:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801544:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801548:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80154c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801550:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801554:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801558:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80155c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801560:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801564:	0f 83 88 00 00 00    	jae    8015f2 <memmove+0xba>
  80156a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801572:	48 01 d0             	add    %rdx,%rax
  801575:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801579:	76 77                	jbe    8015f2 <memmove+0xba>
		s += n;
  80157b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801583:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801587:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80158b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158f:	83 e0 03             	and    $0x3,%eax
  801592:	48 85 c0             	test   %rax,%rax
  801595:	75 3b                	jne    8015d2 <memmove+0x9a>
  801597:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159b:	83 e0 03             	and    $0x3,%eax
  80159e:	48 85 c0             	test   %rax,%rax
  8015a1:	75 2f                	jne    8015d2 <memmove+0x9a>
  8015a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a7:	83 e0 03             	and    $0x3,%eax
  8015aa:	48 85 c0             	test   %rax,%rax
  8015ad:	75 23                	jne    8015d2 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b3:	48 83 e8 04          	sub    $0x4,%rax
  8015b7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015bb:	48 83 ea 04          	sub    $0x4,%rdx
  8015bf:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015c3:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015c7:	48 89 c7             	mov    %rax,%rdi
  8015ca:	48 89 d6             	mov    %rdx,%rsi
  8015cd:	fd                   	std    
  8015ce:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015d0:	eb 1d                	jmp    8015ef <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015de:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e6:	48 89 d7             	mov    %rdx,%rdi
  8015e9:	48 89 c1             	mov    %rax,%rcx
  8015ec:	fd                   	std    
  8015ed:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015ef:	fc                   	cld    
  8015f0:	eb 57                	jmp    801649 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f6:	83 e0 03             	and    $0x3,%eax
  8015f9:	48 85 c0             	test   %rax,%rax
  8015fc:	75 36                	jne    801634 <memmove+0xfc>
  8015fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801602:	83 e0 03             	and    $0x3,%eax
  801605:	48 85 c0             	test   %rax,%rax
  801608:	75 2a                	jne    801634 <memmove+0xfc>
  80160a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160e:	83 e0 03             	and    $0x3,%eax
  801611:	48 85 c0             	test   %rax,%rax
  801614:	75 1e                	jne    801634 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801616:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161a:	48 c1 e8 02          	shr    $0x2,%rax
  80161e:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801621:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801625:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801629:	48 89 c7             	mov    %rax,%rdi
  80162c:	48 89 d6             	mov    %rdx,%rsi
  80162f:	fc                   	cld    
  801630:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801632:	eb 15                	jmp    801649 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801634:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801638:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80163c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801640:	48 89 c7             	mov    %rax,%rdi
  801643:	48 89 d6             	mov    %rdx,%rsi
  801646:	fc                   	cld    
  801647:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80164d:	c9                   	leaveq 
  80164e:	c3                   	retq   

000000000080164f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80164f:	55                   	push   %rbp
  801650:	48 89 e5             	mov    %rsp,%rbp
  801653:	48 83 ec 18          	sub    $0x18,%rsp
  801657:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80165b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80165f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801663:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801667:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80166b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166f:	48 89 ce             	mov    %rcx,%rsi
  801672:	48 89 c7             	mov    %rax,%rdi
  801675:	48 b8 38 15 80 00 00 	movabs $0x801538,%rax
  80167c:	00 00 00 
  80167f:	ff d0                	callq  *%rax
}
  801681:	c9                   	leaveq 
  801682:	c3                   	retq   

0000000000801683 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801683:	55                   	push   %rbp
  801684:	48 89 e5             	mov    %rsp,%rbp
  801687:	48 83 ec 28          	sub    $0x28,%rsp
  80168b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80168f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801693:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80169b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80169f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016a3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016a7:	eb 36                	jmp    8016df <memcmp+0x5c>
		if (*s1 != *s2)
  8016a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ad:	0f b6 10             	movzbl (%rax),%edx
  8016b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b4:	0f b6 00             	movzbl (%rax),%eax
  8016b7:	38 c2                	cmp    %al,%dl
  8016b9:	74 1a                	je     8016d5 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016bf:	0f b6 00             	movzbl (%rax),%eax
  8016c2:	0f b6 d0             	movzbl %al,%edx
  8016c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c9:	0f b6 00             	movzbl (%rax),%eax
  8016cc:	0f b6 c0             	movzbl %al,%eax
  8016cf:	29 c2                	sub    %eax,%edx
  8016d1:	89 d0                	mov    %edx,%eax
  8016d3:	eb 20                	jmp    8016f5 <memcmp+0x72>
		s1++, s2++;
  8016d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016da:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016eb:	48 85 c0             	test   %rax,%rax
  8016ee:	75 b9                	jne    8016a9 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f5:	c9                   	leaveq 
  8016f6:	c3                   	retq   

00000000008016f7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016f7:	55                   	push   %rbp
  8016f8:	48 89 e5             	mov    %rsp,%rbp
  8016fb:	48 83 ec 28          	sub    $0x28,%rsp
  8016ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801703:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801706:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80170a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801712:	48 01 d0             	add    %rdx,%rax
  801715:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801719:	eb 15                	jmp    801730 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80171b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171f:	0f b6 10             	movzbl (%rax),%edx
  801722:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801725:	38 c2                	cmp    %al,%dl
  801727:	75 02                	jne    80172b <memfind+0x34>
			break;
  801729:	eb 0f                	jmp    80173a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80172b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801734:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801738:	72 e1                	jb     80171b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80173a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80173e:	c9                   	leaveq 
  80173f:	c3                   	retq   

0000000000801740 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801740:	55                   	push   %rbp
  801741:	48 89 e5             	mov    %rsp,%rbp
  801744:	48 83 ec 34          	sub    $0x34,%rsp
  801748:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80174c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801750:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801753:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80175a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801761:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801762:	eb 05                	jmp    801769 <strtol+0x29>
		s++;
  801764:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801769:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176d:	0f b6 00             	movzbl (%rax),%eax
  801770:	3c 20                	cmp    $0x20,%al
  801772:	74 f0                	je     801764 <strtol+0x24>
  801774:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801778:	0f b6 00             	movzbl (%rax),%eax
  80177b:	3c 09                	cmp    $0x9,%al
  80177d:	74 e5                	je     801764 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80177f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801783:	0f b6 00             	movzbl (%rax),%eax
  801786:	3c 2b                	cmp    $0x2b,%al
  801788:	75 07                	jne    801791 <strtol+0x51>
		s++;
  80178a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80178f:	eb 17                	jmp    8017a8 <strtol+0x68>
	else if (*s == '-')
  801791:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801795:	0f b6 00             	movzbl (%rax),%eax
  801798:	3c 2d                	cmp    $0x2d,%al
  80179a:	75 0c                	jne    8017a8 <strtol+0x68>
		s++, neg = 1;
  80179c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017a1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017a8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017ac:	74 06                	je     8017b4 <strtol+0x74>
  8017ae:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017b2:	75 28                	jne    8017dc <strtol+0x9c>
  8017b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b8:	0f b6 00             	movzbl (%rax),%eax
  8017bb:	3c 30                	cmp    $0x30,%al
  8017bd:	75 1d                	jne    8017dc <strtol+0x9c>
  8017bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c3:	48 83 c0 01          	add    $0x1,%rax
  8017c7:	0f b6 00             	movzbl (%rax),%eax
  8017ca:	3c 78                	cmp    $0x78,%al
  8017cc:	75 0e                	jne    8017dc <strtol+0x9c>
		s += 2, base = 16;
  8017ce:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017d3:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017da:	eb 2c                	jmp    801808 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017dc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017e0:	75 19                	jne    8017fb <strtol+0xbb>
  8017e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e6:	0f b6 00             	movzbl (%rax),%eax
  8017e9:	3c 30                	cmp    $0x30,%al
  8017eb:	75 0e                	jne    8017fb <strtol+0xbb>
		s++, base = 8;
  8017ed:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017f2:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017f9:	eb 0d                	jmp    801808 <strtol+0xc8>
	else if (base == 0)
  8017fb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017ff:	75 07                	jne    801808 <strtol+0xc8>
		base = 10;
  801801:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801808:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180c:	0f b6 00             	movzbl (%rax),%eax
  80180f:	3c 2f                	cmp    $0x2f,%al
  801811:	7e 1d                	jle    801830 <strtol+0xf0>
  801813:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801817:	0f b6 00             	movzbl (%rax),%eax
  80181a:	3c 39                	cmp    $0x39,%al
  80181c:	7f 12                	jg     801830 <strtol+0xf0>
			dig = *s - '0';
  80181e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801822:	0f b6 00             	movzbl (%rax),%eax
  801825:	0f be c0             	movsbl %al,%eax
  801828:	83 e8 30             	sub    $0x30,%eax
  80182b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80182e:	eb 4e                	jmp    80187e <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801830:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801834:	0f b6 00             	movzbl (%rax),%eax
  801837:	3c 60                	cmp    $0x60,%al
  801839:	7e 1d                	jle    801858 <strtol+0x118>
  80183b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183f:	0f b6 00             	movzbl (%rax),%eax
  801842:	3c 7a                	cmp    $0x7a,%al
  801844:	7f 12                	jg     801858 <strtol+0x118>
			dig = *s - 'a' + 10;
  801846:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184a:	0f b6 00             	movzbl (%rax),%eax
  80184d:	0f be c0             	movsbl %al,%eax
  801850:	83 e8 57             	sub    $0x57,%eax
  801853:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801856:	eb 26                	jmp    80187e <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801858:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185c:	0f b6 00             	movzbl (%rax),%eax
  80185f:	3c 40                	cmp    $0x40,%al
  801861:	7e 48                	jle    8018ab <strtol+0x16b>
  801863:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801867:	0f b6 00             	movzbl (%rax),%eax
  80186a:	3c 5a                	cmp    $0x5a,%al
  80186c:	7f 3d                	jg     8018ab <strtol+0x16b>
			dig = *s - 'A' + 10;
  80186e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801872:	0f b6 00             	movzbl (%rax),%eax
  801875:	0f be c0             	movsbl %al,%eax
  801878:	83 e8 37             	sub    $0x37,%eax
  80187b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80187e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801881:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801884:	7c 02                	jl     801888 <strtol+0x148>
			break;
  801886:	eb 23                	jmp    8018ab <strtol+0x16b>
		s++, val = (val * base) + dig;
  801888:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80188d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801890:	48 98                	cltq   
  801892:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801897:	48 89 c2             	mov    %rax,%rdx
  80189a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80189d:	48 98                	cltq   
  80189f:	48 01 d0             	add    %rdx,%rax
  8018a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018a6:	e9 5d ff ff ff       	jmpq   801808 <strtol+0xc8>

	if (endptr)
  8018ab:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018b0:	74 0b                	je     8018bd <strtol+0x17d>
		*endptr = (char *) s;
  8018b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018b6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018ba:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018c1:	74 09                	je     8018cc <strtol+0x18c>
  8018c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c7:	48 f7 d8             	neg    %rax
  8018ca:	eb 04                	jmp    8018d0 <strtol+0x190>
  8018cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018d0:	c9                   	leaveq 
  8018d1:	c3                   	retq   

00000000008018d2 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018d2:	55                   	push   %rbp
  8018d3:	48 89 e5             	mov    %rsp,%rbp
  8018d6:	48 83 ec 30          	sub    $0x30,%rsp
  8018da:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8018e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018e6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018ea:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018ee:	0f b6 00             	movzbl (%rax),%eax
  8018f1:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8018f4:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018f8:	75 06                	jne    801900 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8018fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fe:	eb 6b                	jmp    80196b <strstr+0x99>

    len = strlen(str);
  801900:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801904:	48 89 c7             	mov    %rax,%rdi
  801907:	48 b8 a8 11 80 00 00 	movabs $0x8011a8,%rax
  80190e:	00 00 00 
  801911:	ff d0                	callq  *%rax
  801913:	48 98                	cltq   
  801915:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801919:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801921:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801925:	0f b6 00             	movzbl (%rax),%eax
  801928:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  80192b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80192f:	75 07                	jne    801938 <strstr+0x66>
                return (char *) 0;
  801931:	b8 00 00 00 00       	mov    $0x0,%eax
  801936:	eb 33                	jmp    80196b <strstr+0x99>
        } while (sc != c);
  801938:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80193c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80193f:	75 d8                	jne    801919 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801941:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801945:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801949:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194d:	48 89 ce             	mov    %rcx,%rsi
  801950:	48 89 c7             	mov    %rax,%rdi
  801953:	48 b8 c9 13 80 00 00 	movabs $0x8013c9,%rax
  80195a:	00 00 00 
  80195d:	ff d0                	callq  *%rax
  80195f:	85 c0                	test   %eax,%eax
  801961:	75 b6                	jne    801919 <strstr+0x47>

    return (char *) (in - 1);
  801963:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801967:	48 83 e8 01          	sub    $0x1,%rax
}
  80196b:	c9                   	leaveq 
  80196c:	c3                   	retq   

000000000080196d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80196d:	55                   	push   %rbp
  80196e:	48 89 e5             	mov    %rsp,%rbp
  801971:	53                   	push   %rbx
  801972:	48 83 ec 48          	sub    $0x48,%rsp
  801976:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801979:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80197c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801980:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801984:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801988:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80198c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80198f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801993:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801997:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80199b:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80199f:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019a3:	4c 89 c3             	mov    %r8,%rbx
  8019a6:	cd 30                	int    $0x30
  8019a8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  8019ac:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019b0:	74 3e                	je     8019f0 <syscall+0x83>
  8019b2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019b7:	7e 37                	jle    8019f0 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019bd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019c0:	49 89 d0             	mov    %rdx,%r8
  8019c3:	89 c1                	mov    %eax,%ecx
  8019c5:	48 ba 80 3c 80 00 00 	movabs $0x803c80,%rdx
  8019cc:	00 00 00 
  8019cf:	be 23 00 00 00       	mov    $0x23,%esi
  8019d4:	48 bf 9d 3c 80 00 00 	movabs $0x803c9d,%rdi
  8019db:	00 00 00 
  8019de:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e3:	49 b9 33 02 80 00 00 	movabs $0x800233,%r9
  8019ea:	00 00 00 
  8019ed:	41 ff d1             	callq  *%r9

	return ret;
  8019f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019f4:	48 83 c4 48          	add    $0x48,%rsp
  8019f8:	5b                   	pop    %rbx
  8019f9:	5d                   	pop    %rbp
  8019fa:	c3                   	retq   

00000000008019fb <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019fb:	55                   	push   %rbp
  8019fc:	48 89 e5             	mov    %rsp,%rbp
  8019ff:	48 83 ec 20          	sub    $0x20,%rsp
  801a03:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a07:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a13:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1a:	00 
  801a1b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a21:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a27:	48 89 d1             	mov    %rdx,%rcx
  801a2a:	48 89 c2             	mov    %rax,%rdx
  801a2d:	be 00 00 00 00       	mov    $0x0,%esi
  801a32:	bf 00 00 00 00       	mov    $0x0,%edi
  801a37:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  801a3e:	00 00 00 
  801a41:	ff d0                	callq  *%rax
}
  801a43:	c9                   	leaveq 
  801a44:	c3                   	retq   

0000000000801a45 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a45:	55                   	push   %rbp
  801a46:	48 89 e5             	mov    %rsp,%rbp
  801a49:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a4d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a54:	00 
  801a55:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a5b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a61:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a66:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6b:	be 00 00 00 00       	mov    $0x0,%esi
  801a70:	bf 01 00 00 00       	mov    $0x1,%edi
  801a75:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  801a7c:	00 00 00 
  801a7f:	ff d0                	callq  *%rax
}
  801a81:	c9                   	leaveq 
  801a82:	c3                   	retq   

0000000000801a83 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a83:	55                   	push   %rbp
  801a84:	48 89 e5             	mov    %rsp,%rbp
  801a87:	48 83 ec 10          	sub    $0x10,%rsp
  801a8b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a91:	48 98                	cltq   
  801a93:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a9a:	00 
  801a9b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aac:	48 89 c2             	mov    %rax,%rdx
  801aaf:	be 01 00 00 00       	mov    $0x1,%esi
  801ab4:	bf 03 00 00 00       	mov    $0x3,%edi
  801ab9:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  801ac0:	00 00 00 
  801ac3:	ff d0                	callq  *%rax
}
  801ac5:	c9                   	leaveq 
  801ac6:	c3                   	retq   

0000000000801ac7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ac7:	55                   	push   %rbp
  801ac8:	48 89 e5             	mov    %rsp,%rbp
  801acb:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801acf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad6:	00 
  801ad7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801add:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae8:	ba 00 00 00 00       	mov    $0x0,%edx
  801aed:	be 00 00 00 00       	mov    $0x0,%esi
  801af2:	bf 02 00 00 00       	mov    $0x2,%edi
  801af7:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  801afe:	00 00 00 
  801b01:	ff d0                	callq  *%rax
}
  801b03:	c9                   	leaveq 
  801b04:	c3                   	retq   

0000000000801b05 <sys_yield>:

void
sys_yield(void)
{
  801b05:	55                   	push   %rbp
  801b06:	48 89 e5             	mov    %rsp,%rbp
  801b09:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b0d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b14:	00 
  801b15:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b21:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b26:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2b:	be 00 00 00 00       	mov    $0x0,%esi
  801b30:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b35:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  801b3c:	00 00 00 
  801b3f:	ff d0                	callq  *%rax
}
  801b41:	c9                   	leaveq 
  801b42:	c3                   	retq   

0000000000801b43 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b43:	55                   	push   %rbp
  801b44:	48 89 e5             	mov    %rsp,%rbp
  801b47:	48 83 ec 20          	sub    $0x20,%rsp
  801b4b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b4e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b52:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b58:	48 63 c8             	movslq %eax,%rcx
  801b5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b62:	48 98                	cltq   
  801b64:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b6b:	00 
  801b6c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b72:	49 89 c8             	mov    %rcx,%r8
  801b75:	48 89 d1             	mov    %rdx,%rcx
  801b78:	48 89 c2             	mov    %rax,%rdx
  801b7b:	be 01 00 00 00       	mov    $0x1,%esi
  801b80:	bf 04 00 00 00       	mov    $0x4,%edi
  801b85:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  801b8c:	00 00 00 
  801b8f:	ff d0                	callq  *%rax
}
  801b91:	c9                   	leaveq 
  801b92:	c3                   	retq   

0000000000801b93 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b93:	55                   	push   %rbp
  801b94:	48 89 e5             	mov    %rsp,%rbp
  801b97:	48 83 ec 30          	sub    $0x30,%rsp
  801b9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ba2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ba5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ba9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bad:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bb0:	48 63 c8             	movslq %eax,%rcx
  801bb3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bb7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bba:	48 63 f0             	movslq %eax,%rsi
  801bbd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc4:	48 98                	cltq   
  801bc6:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bca:	49 89 f9             	mov    %rdi,%r9
  801bcd:	49 89 f0             	mov    %rsi,%r8
  801bd0:	48 89 d1             	mov    %rdx,%rcx
  801bd3:	48 89 c2             	mov    %rax,%rdx
  801bd6:	be 01 00 00 00       	mov    $0x1,%esi
  801bdb:	bf 05 00 00 00       	mov    $0x5,%edi
  801be0:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  801be7:	00 00 00 
  801bea:	ff d0                	callq  *%rax
}
  801bec:	c9                   	leaveq 
  801bed:	c3                   	retq   

0000000000801bee <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bee:	55                   	push   %rbp
  801bef:	48 89 e5             	mov    %rsp,%rbp
  801bf2:	48 83 ec 20          	sub    $0x20,%rsp
  801bf6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bfd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c04:	48 98                	cltq   
  801c06:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c0d:	00 
  801c0e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c14:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1a:	48 89 d1             	mov    %rdx,%rcx
  801c1d:	48 89 c2             	mov    %rax,%rdx
  801c20:	be 01 00 00 00       	mov    $0x1,%esi
  801c25:	bf 06 00 00 00       	mov    $0x6,%edi
  801c2a:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  801c31:	00 00 00 
  801c34:	ff d0                	callq  *%rax
}
  801c36:	c9                   	leaveq 
  801c37:	c3                   	retq   

0000000000801c38 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c38:	55                   	push   %rbp
  801c39:	48 89 e5             	mov    %rsp,%rbp
  801c3c:	48 83 ec 10          	sub    $0x10,%rsp
  801c40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c43:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c49:	48 63 d0             	movslq %eax,%rdx
  801c4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4f:	48 98                	cltq   
  801c51:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c58:	00 
  801c59:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c65:	48 89 d1             	mov    %rdx,%rcx
  801c68:	48 89 c2             	mov    %rax,%rdx
  801c6b:	be 01 00 00 00       	mov    $0x1,%esi
  801c70:	bf 08 00 00 00       	mov    $0x8,%edi
  801c75:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  801c7c:	00 00 00 
  801c7f:	ff d0                	callq  *%rax
}
  801c81:	c9                   	leaveq 
  801c82:	c3                   	retq   

0000000000801c83 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c83:	55                   	push   %rbp
  801c84:	48 89 e5             	mov    %rsp,%rbp
  801c87:	48 83 ec 20          	sub    $0x20,%rsp
  801c8b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c8e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c99:	48 98                	cltq   
  801c9b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca2:	00 
  801ca3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801caf:	48 89 d1             	mov    %rdx,%rcx
  801cb2:	48 89 c2             	mov    %rax,%rdx
  801cb5:	be 01 00 00 00       	mov    $0x1,%esi
  801cba:	bf 09 00 00 00       	mov    $0x9,%edi
  801cbf:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  801cc6:	00 00 00 
  801cc9:	ff d0                	callq  *%rax
}
  801ccb:	c9                   	leaveq 
  801ccc:	c3                   	retq   

0000000000801ccd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ccd:	55                   	push   %rbp
  801cce:	48 89 e5             	mov    %rsp,%rbp
  801cd1:	48 83 ec 20          	sub    $0x20,%rsp
  801cd5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cd8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cdc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce3:	48 98                	cltq   
  801ce5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cec:	00 
  801ced:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf9:	48 89 d1             	mov    %rdx,%rcx
  801cfc:	48 89 c2             	mov    %rax,%rdx
  801cff:	be 01 00 00 00       	mov    $0x1,%esi
  801d04:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d09:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  801d10:	00 00 00 
  801d13:	ff d0                	callq  *%rax
}
  801d15:	c9                   	leaveq 
  801d16:	c3                   	retq   

0000000000801d17 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d17:	55                   	push   %rbp
  801d18:	48 89 e5             	mov    %rsp,%rbp
  801d1b:	48 83 ec 20          	sub    $0x20,%rsp
  801d1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d26:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d2a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d2d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d30:	48 63 f0             	movslq %eax,%rsi
  801d33:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d3a:	48 98                	cltq   
  801d3c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d40:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d47:	00 
  801d48:	49 89 f1             	mov    %rsi,%r9
  801d4b:	49 89 c8             	mov    %rcx,%r8
  801d4e:	48 89 d1             	mov    %rdx,%rcx
  801d51:	48 89 c2             	mov    %rax,%rdx
  801d54:	be 00 00 00 00       	mov    $0x0,%esi
  801d59:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d5e:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  801d65:	00 00 00 
  801d68:	ff d0                	callq  *%rax
}
  801d6a:	c9                   	leaveq 
  801d6b:	c3                   	retq   

0000000000801d6c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d6c:	55                   	push   %rbp
  801d6d:	48 89 e5             	mov    %rsp,%rbp
  801d70:	48 83 ec 10          	sub    $0x10,%rsp
  801d74:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d7c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d83:	00 
  801d84:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d8a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d90:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d95:	48 89 c2             	mov    %rax,%rdx
  801d98:	be 01 00 00 00       	mov    $0x1,%esi
  801d9d:	bf 0d 00 00 00       	mov    $0xd,%edi
  801da2:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  801da9:	00 00 00 
  801dac:	ff d0                	callq  *%rax
}
  801dae:	c9                   	leaveq 
  801daf:	c3                   	retq   

0000000000801db0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801db0:	55                   	push   %rbp
  801db1:	48 89 e5             	mov    %rsp,%rbp
  801db4:	48 83 ec 10          	sub    $0x10,%rsp
  801db8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  801dbc:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801dc3:	00 00 00 
  801dc6:	48 8b 00             	mov    (%rax),%rax
  801dc9:	48 85 c0             	test   %rax,%rax
  801dcc:	75 3a                	jne    801e08 <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  801dce:	ba 07 00 00 00       	mov    $0x7,%edx
  801dd3:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801dd8:	bf 00 00 00 00       	mov    $0x0,%edi
  801ddd:	48 b8 43 1b 80 00 00 	movabs $0x801b43,%rax
  801de4:	00 00 00 
  801de7:	ff d0                	callq  *%rax
  801de9:	85 c0                	test   %eax,%eax
  801deb:	75 1b                	jne    801e08 <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801ded:	48 be 1b 1e 80 00 00 	movabs $0x801e1b,%rsi
  801df4:	00 00 00 
  801df7:	bf 00 00 00 00       	mov    $0x0,%edi
  801dfc:	48 b8 cd 1c 80 00 00 	movabs $0x801ccd,%rax
  801e03:	00 00 00 
  801e06:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801e08:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801e0f:	00 00 00 
  801e12:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e16:	48 89 10             	mov    %rdx,(%rax)
}
  801e19:	c9                   	leaveq 
  801e1a:	c3                   	retq   

0000000000801e1b <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  801e1b:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  801e1e:	48 a1 10 60 80 00 00 	movabs 0x806010,%rax
  801e25:	00 00 00 
	call *%rax
  801e28:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  801e2a:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  801e2d:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801e34:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  801e35:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  801e3c:	00 
	pushq %rbx		// push utf_rip into new stack
  801e3d:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  801e3e:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  801e45:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  801e48:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  801e4c:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  801e50:	4c 8b 3c 24          	mov    (%rsp),%r15
  801e54:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801e59:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801e5e:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801e63:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801e68:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801e6d:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801e72:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801e77:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801e7c:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801e81:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801e86:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801e8b:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801e90:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801e95:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801e9a:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  801e9e:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  801ea2:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  801ea3:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801ea4:	c3                   	retq   

0000000000801ea5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801ea5:	55                   	push   %rbp
  801ea6:	48 89 e5             	mov    %rsp,%rbp
  801ea9:	48 83 ec 08          	sub    $0x8,%rsp
  801ead:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801eb1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801eb5:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801ebc:	ff ff ff 
  801ebf:	48 01 d0             	add    %rdx,%rax
  801ec2:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801ec6:	c9                   	leaveq 
  801ec7:	c3                   	retq   

0000000000801ec8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ec8:	55                   	push   %rbp
  801ec9:	48 89 e5             	mov    %rsp,%rbp
  801ecc:	48 83 ec 08          	sub    $0x8,%rsp
  801ed0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ed4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed8:	48 89 c7             	mov    %rax,%rdi
  801edb:	48 b8 a5 1e 80 00 00 	movabs $0x801ea5,%rax
  801ee2:	00 00 00 
  801ee5:	ff d0                	callq  *%rax
  801ee7:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801eed:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ef1:	c9                   	leaveq 
  801ef2:	c3                   	retq   

0000000000801ef3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ef3:	55                   	push   %rbp
  801ef4:	48 89 e5             	mov    %rsp,%rbp
  801ef7:	48 83 ec 18          	sub    $0x18,%rsp
  801efb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801eff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f06:	eb 6b                	jmp    801f73 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801f08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f0b:	48 98                	cltq   
  801f0d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f13:	48 c1 e0 0c          	shl    $0xc,%rax
  801f17:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f1f:	48 c1 e8 15          	shr    $0x15,%rax
  801f23:	48 89 c2             	mov    %rax,%rdx
  801f26:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f2d:	01 00 00 
  801f30:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f34:	83 e0 01             	and    $0x1,%eax
  801f37:	48 85 c0             	test   %rax,%rax
  801f3a:	74 21                	je     801f5d <fd_alloc+0x6a>
  801f3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f40:	48 c1 e8 0c          	shr    $0xc,%rax
  801f44:	48 89 c2             	mov    %rax,%rdx
  801f47:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f4e:	01 00 00 
  801f51:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f55:	83 e0 01             	and    $0x1,%eax
  801f58:	48 85 c0             	test   %rax,%rax
  801f5b:	75 12                	jne    801f6f <fd_alloc+0x7c>
			*fd_store = fd;
  801f5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f65:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f68:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6d:	eb 1a                	jmp    801f89 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f6f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f73:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f77:	7e 8f                	jle    801f08 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f7d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f84:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f89:	c9                   	leaveq 
  801f8a:	c3                   	retq   

0000000000801f8b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f8b:	55                   	push   %rbp
  801f8c:	48 89 e5             	mov    %rsp,%rbp
  801f8f:	48 83 ec 20          	sub    $0x20,%rsp
  801f93:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f96:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f9a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f9e:	78 06                	js     801fa6 <fd_lookup+0x1b>
  801fa0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801fa4:	7e 07                	jle    801fad <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fa6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fab:	eb 6c                	jmp    802019 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801fad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fb0:	48 98                	cltq   
  801fb2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fb8:	48 c1 e0 0c          	shl    $0xc,%rax
  801fbc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801fc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc4:	48 c1 e8 15          	shr    $0x15,%rax
  801fc8:	48 89 c2             	mov    %rax,%rdx
  801fcb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fd2:	01 00 00 
  801fd5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fd9:	83 e0 01             	and    $0x1,%eax
  801fdc:	48 85 c0             	test   %rax,%rax
  801fdf:	74 21                	je     802002 <fd_lookup+0x77>
  801fe1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe5:	48 c1 e8 0c          	shr    $0xc,%rax
  801fe9:	48 89 c2             	mov    %rax,%rdx
  801fec:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ff3:	01 00 00 
  801ff6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ffa:	83 e0 01             	and    $0x1,%eax
  801ffd:	48 85 c0             	test   %rax,%rax
  802000:	75 07                	jne    802009 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802002:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802007:	eb 10                	jmp    802019 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802009:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80200d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802011:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802014:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802019:	c9                   	leaveq 
  80201a:	c3                   	retq   

000000000080201b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80201b:	55                   	push   %rbp
  80201c:	48 89 e5             	mov    %rsp,%rbp
  80201f:	48 83 ec 30          	sub    $0x30,%rsp
  802023:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802027:	89 f0                	mov    %esi,%eax
  802029:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80202c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802030:	48 89 c7             	mov    %rax,%rdi
  802033:	48 b8 a5 1e 80 00 00 	movabs $0x801ea5,%rax
  80203a:	00 00 00 
  80203d:	ff d0                	callq  *%rax
  80203f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802043:	48 89 d6             	mov    %rdx,%rsi
  802046:	89 c7                	mov    %eax,%edi
  802048:	48 b8 8b 1f 80 00 00 	movabs $0x801f8b,%rax
  80204f:	00 00 00 
  802052:	ff d0                	callq  *%rax
  802054:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802057:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80205b:	78 0a                	js     802067 <fd_close+0x4c>
	    || fd != fd2)
  80205d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802061:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802065:	74 12                	je     802079 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802067:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80206b:	74 05                	je     802072 <fd_close+0x57>
  80206d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802070:	eb 05                	jmp    802077 <fd_close+0x5c>
  802072:	b8 00 00 00 00       	mov    $0x0,%eax
  802077:	eb 69                	jmp    8020e2 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802079:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80207d:	8b 00                	mov    (%rax),%eax
  80207f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802083:	48 89 d6             	mov    %rdx,%rsi
  802086:	89 c7                	mov    %eax,%edi
  802088:	48 b8 e4 20 80 00 00 	movabs $0x8020e4,%rax
  80208f:	00 00 00 
  802092:	ff d0                	callq  *%rax
  802094:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802097:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80209b:	78 2a                	js     8020c7 <fd_close+0xac>
		if (dev->dev_close)
  80209d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020a1:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020a5:	48 85 c0             	test   %rax,%rax
  8020a8:	74 16                	je     8020c0 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8020aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ae:	48 8b 40 20          	mov    0x20(%rax),%rax
  8020b2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8020b6:	48 89 d7             	mov    %rdx,%rdi
  8020b9:	ff d0                	callq  *%rax
  8020bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020be:	eb 07                	jmp    8020c7 <fd_close+0xac>
		else
			r = 0;
  8020c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8020c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020cb:	48 89 c6             	mov    %rax,%rsi
  8020ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8020d3:	48 b8 ee 1b 80 00 00 	movabs $0x801bee,%rax
  8020da:	00 00 00 
  8020dd:	ff d0                	callq  *%rax
	return r;
  8020df:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020e2:	c9                   	leaveq 
  8020e3:	c3                   	retq   

00000000008020e4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020e4:	55                   	push   %rbp
  8020e5:	48 89 e5             	mov    %rsp,%rbp
  8020e8:	48 83 ec 20          	sub    $0x20,%rsp
  8020ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020fa:	eb 41                	jmp    80213d <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020fc:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802103:	00 00 00 
  802106:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802109:	48 63 d2             	movslq %edx,%rdx
  80210c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802110:	8b 00                	mov    (%rax),%eax
  802112:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802115:	75 22                	jne    802139 <dev_lookup+0x55>
			*dev = devtab[i];
  802117:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80211e:	00 00 00 
  802121:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802124:	48 63 d2             	movslq %edx,%rdx
  802127:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80212b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80212f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802132:	b8 00 00 00 00       	mov    $0x0,%eax
  802137:	eb 60                	jmp    802199 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802139:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80213d:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802144:	00 00 00 
  802147:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80214a:	48 63 d2             	movslq %edx,%rdx
  80214d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802151:	48 85 c0             	test   %rax,%rax
  802154:	75 a6                	jne    8020fc <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802156:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80215d:	00 00 00 
  802160:	48 8b 00             	mov    (%rax),%rax
  802163:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802169:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80216c:	89 c6                	mov    %eax,%esi
  80216e:	48 bf b0 3c 80 00 00 	movabs $0x803cb0,%rdi
  802175:	00 00 00 
  802178:	b8 00 00 00 00       	mov    $0x0,%eax
  80217d:	48 b9 6c 04 80 00 00 	movabs $0x80046c,%rcx
  802184:	00 00 00 
  802187:	ff d1                	callq  *%rcx
	*dev = 0;
  802189:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80218d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802194:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802199:	c9                   	leaveq 
  80219a:	c3                   	retq   

000000000080219b <close>:

int
close(int fdnum)
{
  80219b:	55                   	push   %rbp
  80219c:	48 89 e5             	mov    %rsp,%rbp
  80219f:	48 83 ec 20          	sub    $0x20,%rsp
  8021a3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021a6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021ad:	48 89 d6             	mov    %rdx,%rsi
  8021b0:	89 c7                	mov    %eax,%edi
  8021b2:	48 b8 8b 1f 80 00 00 	movabs $0x801f8b,%rax
  8021b9:	00 00 00 
  8021bc:	ff d0                	callq  *%rax
  8021be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021c5:	79 05                	jns    8021cc <close+0x31>
		return r;
  8021c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ca:	eb 18                	jmp    8021e4 <close+0x49>
	else
		return fd_close(fd, 1);
  8021cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021d0:	be 01 00 00 00       	mov    $0x1,%esi
  8021d5:	48 89 c7             	mov    %rax,%rdi
  8021d8:	48 b8 1b 20 80 00 00 	movabs $0x80201b,%rax
  8021df:	00 00 00 
  8021e2:	ff d0                	callq  *%rax
}
  8021e4:	c9                   	leaveq 
  8021e5:	c3                   	retq   

00000000008021e6 <close_all>:

void
close_all(void)
{
  8021e6:	55                   	push   %rbp
  8021e7:	48 89 e5             	mov    %rsp,%rbp
  8021ea:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021f5:	eb 15                	jmp    80220c <close_all+0x26>
		close(i);
  8021f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021fa:	89 c7                	mov    %eax,%edi
  8021fc:	48 b8 9b 21 80 00 00 	movabs $0x80219b,%rax
  802203:	00 00 00 
  802206:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802208:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80220c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802210:	7e e5                	jle    8021f7 <close_all+0x11>
		close(i);
}
  802212:	c9                   	leaveq 
  802213:	c3                   	retq   

0000000000802214 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802214:	55                   	push   %rbp
  802215:	48 89 e5             	mov    %rsp,%rbp
  802218:	48 83 ec 40          	sub    $0x40,%rsp
  80221c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80221f:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802222:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802226:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802229:	48 89 d6             	mov    %rdx,%rsi
  80222c:	89 c7                	mov    %eax,%edi
  80222e:	48 b8 8b 1f 80 00 00 	movabs $0x801f8b,%rax
  802235:	00 00 00 
  802238:	ff d0                	callq  *%rax
  80223a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80223d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802241:	79 08                	jns    80224b <dup+0x37>
		return r;
  802243:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802246:	e9 70 01 00 00       	jmpq   8023bb <dup+0x1a7>
	close(newfdnum);
  80224b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80224e:	89 c7                	mov    %eax,%edi
  802250:	48 b8 9b 21 80 00 00 	movabs $0x80219b,%rax
  802257:	00 00 00 
  80225a:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80225c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80225f:	48 98                	cltq   
  802261:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802267:	48 c1 e0 0c          	shl    $0xc,%rax
  80226b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80226f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802273:	48 89 c7             	mov    %rax,%rdi
  802276:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  80227d:	00 00 00 
  802280:	ff d0                	callq  *%rax
  802282:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802286:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80228a:	48 89 c7             	mov    %rax,%rdi
  80228d:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  802294:	00 00 00 
  802297:	ff d0                	callq  *%rax
  802299:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80229d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a1:	48 c1 e8 15          	shr    $0x15,%rax
  8022a5:	48 89 c2             	mov    %rax,%rdx
  8022a8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022af:	01 00 00 
  8022b2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b6:	83 e0 01             	and    $0x1,%eax
  8022b9:	48 85 c0             	test   %rax,%rax
  8022bc:	74 73                	je     802331 <dup+0x11d>
  8022be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c2:	48 c1 e8 0c          	shr    $0xc,%rax
  8022c6:	48 89 c2             	mov    %rax,%rdx
  8022c9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022d0:	01 00 00 
  8022d3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022d7:	83 e0 01             	and    $0x1,%eax
  8022da:	48 85 c0             	test   %rax,%rax
  8022dd:	74 52                	je     802331 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e3:	48 c1 e8 0c          	shr    $0xc,%rax
  8022e7:	48 89 c2             	mov    %rax,%rdx
  8022ea:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022f1:	01 00 00 
  8022f4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f8:	25 07 0e 00 00       	and    $0xe07,%eax
  8022fd:	89 c1                	mov    %eax,%ecx
  8022ff:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802303:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802307:	41 89 c8             	mov    %ecx,%r8d
  80230a:	48 89 d1             	mov    %rdx,%rcx
  80230d:	ba 00 00 00 00       	mov    $0x0,%edx
  802312:	48 89 c6             	mov    %rax,%rsi
  802315:	bf 00 00 00 00       	mov    $0x0,%edi
  80231a:	48 b8 93 1b 80 00 00 	movabs $0x801b93,%rax
  802321:	00 00 00 
  802324:	ff d0                	callq  *%rax
  802326:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802329:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80232d:	79 02                	jns    802331 <dup+0x11d>
			goto err;
  80232f:	eb 57                	jmp    802388 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802331:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802335:	48 c1 e8 0c          	shr    $0xc,%rax
  802339:	48 89 c2             	mov    %rax,%rdx
  80233c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802343:	01 00 00 
  802346:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80234a:	25 07 0e 00 00       	and    $0xe07,%eax
  80234f:	89 c1                	mov    %eax,%ecx
  802351:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802355:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802359:	41 89 c8             	mov    %ecx,%r8d
  80235c:	48 89 d1             	mov    %rdx,%rcx
  80235f:	ba 00 00 00 00       	mov    $0x0,%edx
  802364:	48 89 c6             	mov    %rax,%rsi
  802367:	bf 00 00 00 00       	mov    $0x0,%edi
  80236c:	48 b8 93 1b 80 00 00 	movabs $0x801b93,%rax
  802373:	00 00 00 
  802376:	ff d0                	callq  *%rax
  802378:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80237b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80237f:	79 02                	jns    802383 <dup+0x16f>
		goto err;
  802381:	eb 05                	jmp    802388 <dup+0x174>

	return newfdnum;
  802383:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802386:	eb 33                	jmp    8023bb <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802388:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238c:	48 89 c6             	mov    %rax,%rsi
  80238f:	bf 00 00 00 00       	mov    $0x0,%edi
  802394:	48 b8 ee 1b 80 00 00 	movabs $0x801bee,%rax
  80239b:	00 00 00 
  80239e:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8023a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023a4:	48 89 c6             	mov    %rax,%rsi
  8023a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ac:	48 b8 ee 1b 80 00 00 	movabs $0x801bee,%rax
  8023b3:	00 00 00 
  8023b6:	ff d0                	callq  *%rax
	return r;
  8023b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023bb:	c9                   	leaveq 
  8023bc:	c3                   	retq   

00000000008023bd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8023bd:	55                   	push   %rbp
  8023be:	48 89 e5             	mov    %rsp,%rbp
  8023c1:	48 83 ec 40          	sub    $0x40,%rsp
  8023c5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023c8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023cc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023d0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023d4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023d7:	48 89 d6             	mov    %rdx,%rsi
  8023da:	89 c7                	mov    %eax,%edi
  8023dc:	48 b8 8b 1f 80 00 00 	movabs $0x801f8b,%rax
  8023e3:	00 00 00 
  8023e6:	ff d0                	callq  *%rax
  8023e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ef:	78 24                	js     802415 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f5:	8b 00                	mov    (%rax),%eax
  8023f7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023fb:	48 89 d6             	mov    %rdx,%rsi
  8023fe:	89 c7                	mov    %eax,%edi
  802400:	48 b8 e4 20 80 00 00 	movabs $0x8020e4,%rax
  802407:	00 00 00 
  80240a:	ff d0                	callq  *%rax
  80240c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80240f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802413:	79 05                	jns    80241a <read+0x5d>
		return r;
  802415:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802418:	eb 76                	jmp    802490 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80241a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80241e:	8b 40 08             	mov    0x8(%rax),%eax
  802421:	83 e0 03             	and    $0x3,%eax
  802424:	83 f8 01             	cmp    $0x1,%eax
  802427:	75 3a                	jne    802463 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802429:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802430:	00 00 00 
  802433:	48 8b 00             	mov    (%rax),%rax
  802436:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80243c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80243f:	89 c6                	mov    %eax,%esi
  802441:	48 bf cf 3c 80 00 00 	movabs $0x803ccf,%rdi
  802448:	00 00 00 
  80244b:	b8 00 00 00 00       	mov    $0x0,%eax
  802450:	48 b9 6c 04 80 00 00 	movabs $0x80046c,%rcx
  802457:	00 00 00 
  80245a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80245c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802461:	eb 2d                	jmp    802490 <read+0xd3>
	}
	if (!dev->dev_read)
  802463:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802467:	48 8b 40 10          	mov    0x10(%rax),%rax
  80246b:	48 85 c0             	test   %rax,%rax
  80246e:	75 07                	jne    802477 <read+0xba>
		return -E_NOT_SUPP;
  802470:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802475:	eb 19                	jmp    802490 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802477:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80247b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80247f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802483:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802487:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80248b:	48 89 cf             	mov    %rcx,%rdi
  80248e:	ff d0                	callq  *%rax
}
  802490:	c9                   	leaveq 
  802491:	c3                   	retq   

0000000000802492 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802492:	55                   	push   %rbp
  802493:	48 89 e5             	mov    %rsp,%rbp
  802496:	48 83 ec 30          	sub    $0x30,%rsp
  80249a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80249d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024ac:	eb 49                	jmp    8024f7 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8024ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b1:	48 98                	cltq   
  8024b3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024b7:	48 29 c2             	sub    %rax,%rdx
  8024ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024bd:	48 63 c8             	movslq %eax,%rcx
  8024c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024c4:	48 01 c1             	add    %rax,%rcx
  8024c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024ca:	48 89 ce             	mov    %rcx,%rsi
  8024cd:	89 c7                	mov    %eax,%edi
  8024cf:	48 b8 bd 23 80 00 00 	movabs $0x8023bd,%rax
  8024d6:	00 00 00 
  8024d9:	ff d0                	callq  *%rax
  8024db:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8024de:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024e2:	79 05                	jns    8024e9 <readn+0x57>
			return m;
  8024e4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024e7:	eb 1c                	jmp    802505 <readn+0x73>
		if (m == 0)
  8024e9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024ed:	75 02                	jne    8024f1 <readn+0x5f>
			break;
  8024ef:	eb 11                	jmp    802502 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024f4:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024fa:	48 98                	cltq   
  8024fc:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802500:	72 ac                	jb     8024ae <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802502:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802505:	c9                   	leaveq 
  802506:	c3                   	retq   

0000000000802507 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802507:	55                   	push   %rbp
  802508:	48 89 e5             	mov    %rsp,%rbp
  80250b:	48 83 ec 40          	sub    $0x40,%rsp
  80250f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802512:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802516:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80251a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80251e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802521:	48 89 d6             	mov    %rdx,%rsi
  802524:	89 c7                	mov    %eax,%edi
  802526:	48 b8 8b 1f 80 00 00 	movabs $0x801f8b,%rax
  80252d:	00 00 00 
  802530:	ff d0                	callq  *%rax
  802532:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802535:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802539:	78 24                	js     80255f <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80253b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253f:	8b 00                	mov    (%rax),%eax
  802541:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802545:	48 89 d6             	mov    %rdx,%rsi
  802548:	89 c7                	mov    %eax,%edi
  80254a:	48 b8 e4 20 80 00 00 	movabs $0x8020e4,%rax
  802551:	00 00 00 
  802554:	ff d0                	callq  *%rax
  802556:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802559:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80255d:	79 05                	jns    802564 <write+0x5d>
		return r;
  80255f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802562:	eb 75                	jmp    8025d9 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802564:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802568:	8b 40 08             	mov    0x8(%rax),%eax
  80256b:	83 e0 03             	and    $0x3,%eax
  80256e:	85 c0                	test   %eax,%eax
  802570:	75 3a                	jne    8025ac <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802572:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802579:	00 00 00 
  80257c:	48 8b 00             	mov    (%rax),%rax
  80257f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802585:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802588:	89 c6                	mov    %eax,%esi
  80258a:	48 bf eb 3c 80 00 00 	movabs $0x803ceb,%rdi
  802591:	00 00 00 
  802594:	b8 00 00 00 00       	mov    $0x0,%eax
  802599:	48 b9 6c 04 80 00 00 	movabs $0x80046c,%rcx
  8025a0:	00 00 00 
  8025a3:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8025a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025aa:	eb 2d                	jmp    8025d9 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8025ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b0:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025b4:	48 85 c0             	test   %rax,%rax
  8025b7:	75 07                	jne    8025c0 <write+0xb9>
		return -E_NOT_SUPP;
  8025b9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025be:	eb 19                	jmp    8025d9 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8025c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025c8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025cc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025d0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025d4:	48 89 cf             	mov    %rcx,%rdi
  8025d7:	ff d0                	callq  *%rax
}
  8025d9:	c9                   	leaveq 
  8025da:	c3                   	retq   

00000000008025db <seek>:

int
seek(int fdnum, off_t offset)
{
  8025db:	55                   	push   %rbp
  8025dc:	48 89 e5             	mov    %rsp,%rbp
  8025df:	48 83 ec 18          	sub    $0x18,%rsp
  8025e3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025e6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025e9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025f0:	48 89 d6             	mov    %rdx,%rsi
  8025f3:	89 c7                	mov    %eax,%edi
  8025f5:	48 b8 8b 1f 80 00 00 	movabs $0x801f8b,%rax
  8025fc:	00 00 00 
  8025ff:	ff d0                	callq  *%rax
  802601:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802604:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802608:	79 05                	jns    80260f <seek+0x34>
		return r;
  80260a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80260d:	eb 0f                	jmp    80261e <seek+0x43>
	fd->fd_offset = offset;
  80260f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802613:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802616:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261e:	c9                   	leaveq 
  80261f:	c3                   	retq   

0000000000802620 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802620:	55                   	push   %rbp
  802621:	48 89 e5             	mov    %rsp,%rbp
  802624:	48 83 ec 30          	sub    $0x30,%rsp
  802628:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80262b:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80262e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802632:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802635:	48 89 d6             	mov    %rdx,%rsi
  802638:	89 c7                	mov    %eax,%edi
  80263a:	48 b8 8b 1f 80 00 00 	movabs $0x801f8b,%rax
  802641:	00 00 00 
  802644:	ff d0                	callq  *%rax
  802646:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802649:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80264d:	78 24                	js     802673 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80264f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802653:	8b 00                	mov    (%rax),%eax
  802655:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802659:	48 89 d6             	mov    %rdx,%rsi
  80265c:	89 c7                	mov    %eax,%edi
  80265e:	48 b8 e4 20 80 00 00 	movabs $0x8020e4,%rax
  802665:	00 00 00 
  802668:	ff d0                	callq  *%rax
  80266a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80266d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802671:	79 05                	jns    802678 <ftruncate+0x58>
		return r;
  802673:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802676:	eb 72                	jmp    8026ea <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802678:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267c:	8b 40 08             	mov    0x8(%rax),%eax
  80267f:	83 e0 03             	and    $0x3,%eax
  802682:	85 c0                	test   %eax,%eax
  802684:	75 3a                	jne    8026c0 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802686:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80268d:	00 00 00 
  802690:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802693:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802699:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80269c:	89 c6                	mov    %eax,%esi
  80269e:	48 bf 08 3d 80 00 00 	movabs $0x803d08,%rdi
  8026a5:	00 00 00 
  8026a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ad:	48 b9 6c 04 80 00 00 	movabs $0x80046c,%rcx
  8026b4:	00 00 00 
  8026b7:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8026b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026be:	eb 2a                	jmp    8026ea <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8026c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c4:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026c8:	48 85 c0             	test   %rax,%rax
  8026cb:	75 07                	jne    8026d4 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8026cd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026d2:	eb 16                	jmp    8026ea <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8026d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d8:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026e0:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8026e3:	89 ce                	mov    %ecx,%esi
  8026e5:	48 89 d7             	mov    %rdx,%rdi
  8026e8:	ff d0                	callq  *%rax
}
  8026ea:	c9                   	leaveq 
  8026eb:	c3                   	retq   

00000000008026ec <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026ec:	55                   	push   %rbp
  8026ed:	48 89 e5             	mov    %rsp,%rbp
  8026f0:	48 83 ec 30          	sub    $0x30,%rsp
  8026f4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026f7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026fb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026ff:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802702:	48 89 d6             	mov    %rdx,%rsi
  802705:	89 c7                	mov    %eax,%edi
  802707:	48 b8 8b 1f 80 00 00 	movabs $0x801f8b,%rax
  80270e:	00 00 00 
  802711:	ff d0                	callq  *%rax
  802713:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802716:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80271a:	78 24                	js     802740 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80271c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802720:	8b 00                	mov    (%rax),%eax
  802722:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802726:	48 89 d6             	mov    %rdx,%rsi
  802729:	89 c7                	mov    %eax,%edi
  80272b:	48 b8 e4 20 80 00 00 	movabs $0x8020e4,%rax
  802732:	00 00 00 
  802735:	ff d0                	callq  *%rax
  802737:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80273e:	79 05                	jns    802745 <fstat+0x59>
		return r;
  802740:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802743:	eb 5e                	jmp    8027a3 <fstat+0xb7>
	if (!dev->dev_stat)
  802745:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802749:	48 8b 40 28          	mov    0x28(%rax),%rax
  80274d:	48 85 c0             	test   %rax,%rax
  802750:	75 07                	jne    802759 <fstat+0x6d>
		return -E_NOT_SUPP;
  802752:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802757:	eb 4a                	jmp    8027a3 <fstat+0xb7>
	stat->st_name[0] = 0;
  802759:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80275d:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802760:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802764:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80276b:	00 00 00 
	stat->st_isdir = 0;
  80276e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802772:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802779:	00 00 00 
	stat->st_dev = dev;
  80277c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802780:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802784:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80278b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80278f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802793:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802797:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80279b:	48 89 ce             	mov    %rcx,%rsi
  80279e:	48 89 d7             	mov    %rdx,%rdi
  8027a1:	ff d0                	callq  *%rax
}
  8027a3:	c9                   	leaveq 
  8027a4:	c3                   	retq   

00000000008027a5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8027a5:	55                   	push   %rbp
  8027a6:	48 89 e5             	mov    %rsp,%rbp
  8027a9:	48 83 ec 20          	sub    $0x20,%rsp
  8027ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8027b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b9:	be 00 00 00 00       	mov    $0x0,%esi
  8027be:	48 89 c7             	mov    %rax,%rdi
  8027c1:	48 b8 93 28 80 00 00 	movabs $0x802893,%rax
  8027c8:	00 00 00 
  8027cb:	ff d0                	callq  *%rax
  8027cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d4:	79 05                	jns    8027db <stat+0x36>
		return fd;
  8027d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d9:	eb 2f                	jmp    80280a <stat+0x65>
	r = fstat(fd, stat);
  8027db:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e2:	48 89 d6             	mov    %rdx,%rsi
  8027e5:	89 c7                	mov    %eax,%edi
  8027e7:	48 b8 ec 26 80 00 00 	movabs $0x8026ec,%rax
  8027ee:	00 00 00 
  8027f1:	ff d0                	callq  *%rax
  8027f3:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f9:	89 c7                	mov    %eax,%edi
  8027fb:	48 b8 9b 21 80 00 00 	movabs $0x80219b,%rax
  802802:	00 00 00 
  802805:	ff d0                	callq  *%rax
	return r;
  802807:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80280a:	c9                   	leaveq 
  80280b:	c3                   	retq   

000000000080280c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80280c:	55                   	push   %rbp
  80280d:	48 89 e5             	mov    %rsp,%rbp
  802810:	48 83 ec 10          	sub    $0x10,%rsp
  802814:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802817:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80281b:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802822:	00 00 00 
  802825:	8b 00                	mov    (%rax),%eax
  802827:	85 c0                	test   %eax,%eax
  802829:	75 1d                	jne    802848 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80282b:	bf 01 00 00 00       	mov    $0x1,%edi
  802830:	48 b8 02 36 80 00 00 	movabs $0x803602,%rax
  802837:	00 00 00 
  80283a:	ff d0                	callq  *%rax
  80283c:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  802843:	00 00 00 
  802846:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802848:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  80284f:	00 00 00 
  802852:	8b 00                	mov    (%rax),%eax
  802854:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802857:	b9 07 00 00 00       	mov    $0x7,%ecx
  80285c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802863:	00 00 00 
  802866:	89 c7                	mov    %eax,%edi
  802868:	48 b8 6a 35 80 00 00 	movabs $0x80356a,%rax
  80286f:	00 00 00 
  802872:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802874:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802878:	ba 00 00 00 00       	mov    $0x0,%edx
  80287d:	48 89 c6             	mov    %rax,%rsi
  802880:	bf 00 00 00 00       	mov    $0x0,%edi
  802885:	48 b8 a1 34 80 00 00 	movabs $0x8034a1,%rax
  80288c:	00 00 00 
  80288f:	ff d0                	callq  *%rax
}
  802891:	c9                   	leaveq 
  802892:	c3                   	retq   

0000000000802893 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802893:	55                   	push   %rbp
  802894:	48 89 e5             	mov    %rsp,%rbp
  802897:	48 83 ec 20          	sub    $0x20,%rsp
  80289b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80289f:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  8028a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a6:	48 89 c7             	mov    %rax,%rdi
  8028a9:	48 b8 a8 11 80 00 00 	movabs $0x8011a8,%rax
  8028b0:	00 00 00 
  8028b3:	ff d0                	callq  *%rax
  8028b5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8028ba:	7e 0a                	jle    8028c6 <open+0x33>
		return -E_BAD_PATH;
  8028bc:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028c1:	e9 a5 00 00 00       	jmpq   80296b <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8028c6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8028ca:	48 89 c7             	mov    %rax,%rdi
  8028cd:	48 b8 f3 1e 80 00 00 	movabs $0x801ef3,%rax
  8028d4:	00 00 00 
  8028d7:	ff d0                	callq  *%rax
  8028d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e0:	79 08                	jns    8028ea <open+0x57>
		return r;
  8028e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e5:	e9 81 00 00 00       	jmpq   80296b <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8028ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ee:	48 89 c6             	mov    %rax,%rsi
  8028f1:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8028f8:	00 00 00 
  8028fb:	48 b8 14 12 80 00 00 	movabs $0x801214,%rax
  802902:	00 00 00 
  802905:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802907:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80290e:	00 00 00 
  802911:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802914:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80291a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80291e:	48 89 c6             	mov    %rax,%rsi
  802921:	bf 01 00 00 00       	mov    $0x1,%edi
  802926:	48 b8 0c 28 80 00 00 	movabs $0x80280c,%rax
  80292d:	00 00 00 
  802930:	ff d0                	callq  *%rax
  802932:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802935:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802939:	79 1d                	jns    802958 <open+0xc5>
		fd_close(fd, 0);
  80293b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80293f:	be 00 00 00 00       	mov    $0x0,%esi
  802944:	48 89 c7             	mov    %rax,%rdi
  802947:	48 b8 1b 20 80 00 00 	movabs $0x80201b,%rax
  80294e:	00 00 00 
  802951:	ff d0                	callq  *%rax
		return r;
  802953:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802956:	eb 13                	jmp    80296b <open+0xd8>
	}

	return fd2num(fd);
  802958:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80295c:	48 89 c7             	mov    %rax,%rdi
  80295f:	48 b8 a5 1e 80 00 00 	movabs $0x801ea5,%rax
  802966:	00 00 00 
  802969:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  80296b:	c9                   	leaveq 
  80296c:	c3                   	retq   

000000000080296d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80296d:	55                   	push   %rbp
  80296e:	48 89 e5             	mov    %rsp,%rbp
  802971:	48 83 ec 10          	sub    $0x10,%rsp
  802975:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802979:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80297d:	8b 50 0c             	mov    0xc(%rax),%edx
  802980:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802987:	00 00 00 
  80298a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80298c:	be 00 00 00 00       	mov    $0x0,%esi
  802991:	bf 06 00 00 00       	mov    $0x6,%edi
  802996:	48 b8 0c 28 80 00 00 	movabs $0x80280c,%rax
  80299d:	00 00 00 
  8029a0:	ff d0                	callq  *%rax
}
  8029a2:	c9                   	leaveq 
  8029a3:	c3                   	retq   

00000000008029a4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8029a4:	55                   	push   %rbp
  8029a5:	48 89 e5             	mov    %rsp,%rbp
  8029a8:	48 83 ec 30          	sub    $0x30,%rsp
  8029ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8029b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029bc:	8b 50 0c             	mov    0xc(%rax),%edx
  8029bf:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029c6:	00 00 00 
  8029c9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8029cb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029d2:	00 00 00 
  8029d5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029d9:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8029dd:	be 00 00 00 00       	mov    $0x0,%esi
  8029e2:	bf 03 00 00 00       	mov    $0x3,%edi
  8029e7:	48 b8 0c 28 80 00 00 	movabs $0x80280c,%rax
  8029ee:	00 00 00 
  8029f1:	ff d0                	callq  *%rax
  8029f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029fa:	79 05                	jns    802a01 <devfile_read+0x5d>
		return r;
  8029fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ff:	eb 26                	jmp    802a27 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802a01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a04:	48 63 d0             	movslq %eax,%rdx
  802a07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a0b:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802a12:	00 00 00 
  802a15:	48 89 c7             	mov    %rax,%rdi
  802a18:	48 b8 38 15 80 00 00 	movabs $0x801538,%rax
  802a1f:	00 00 00 
  802a22:	ff d0                	callq  *%rax

	return r;
  802a24:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802a27:	c9                   	leaveq 
  802a28:	c3                   	retq   

0000000000802a29 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a29:	55                   	push   %rbp
  802a2a:	48 89 e5             	mov    %rsp,%rbp
  802a2d:	48 83 ec 30          	sub    $0x30,%rsp
  802a31:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a35:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a39:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802a3d:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802a44:	00 
  802a45:	76 08                	jbe    802a4f <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802a47:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802a4e:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a53:	8b 50 0c             	mov    0xc(%rax),%edx
  802a56:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a5d:	00 00 00 
  802a60:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802a62:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a69:	00 00 00 
  802a6c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a70:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  802a74:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a7c:	48 89 c6             	mov    %rax,%rsi
  802a7f:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802a86:	00 00 00 
  802a89:	48 b8 38 15 80 00 00 	movabs $0x801538,%rax
  802a90:	00 00 00 
  802a93:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802a95:	be 00 00 00 00       	mov    $0x0,%esi
  802a9a:	bf 04 00 00 00       	mov    $0x4,%edi
  802a9f:	48 b8 0c 28 80 00 00 	movabs $0x80280c,%rax
  802aa6:	00 00 00 
  802aa9:	ff d0                	callq  *%rax
  802aab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab2:	79 05                	jns    802ab9 <devfile_write+0x90>
		return r;
  802ab4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab7:	eb 03                	jmp    802abc <devfile_write+0x93>

	return r;
  802ab9:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802abc:	c9                   	leaveq 
  802abd:	c3                   	retq   

0000000000802abe <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802abe:	55                   	push   %rbp
  802abf:	48 89 e5             	mov    %rsp,%rbp
  802ac2:	48 83 ec 20          	sub    $0x20,%rsp
  802ac6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802aca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802ace:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad2:	8b 50 0c             	mov    0xc(%rax),%edx
  802ad5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802adc:	00 00 00 
  802adf:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ae1:	be 00 00 00 00       	mov    $0x0,%esi
  802ae6:	bf 05 00 00 00       	mov    $0x5,%edi
  802aeb:	48 b8 0c 28 80 00 00 	movabs $0x80280c,%rax
  802af2:	00 00 00 
  802af5:	ff d0                	callq  *%rax
  802af7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afe:	79 05                	jns    802b05 <devfile_stat+0x47>
		return r;
  802b00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b03:	eb 56                	jmp    802b5b <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b05:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b09:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802b10:	00 00 00 
  802b13:	48 89 c7             	mov    %rax,%rdi
  802b16:	48 b8 14 12 80 00 00 	movabs $0x801214,%rax
  802b1d:	00 00 00 
  802b20:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b22:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b29:	00 00 00 
  802b2c:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b32:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b36:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b3c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b43:	00 00 00 
  802b46:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b50:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b5b:	c9                   	leaveq 
  802b5c:	c3                   	retq   

0000000000802b5d <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b5d:	55                   	push   %rbp
  802b5e:	48 89 e5             	mov    %rsp,%rbp
  802b61:	48 83 ec 10          	sub    $0x10,%rsp
  802b65:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b69:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b70:	8b 50 0c             	mov    0xc(%rax),%edx
  802b73:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b7a:	00 00 00 
  802b7d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b7f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b86:	00 00 00 
  802b89:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b8c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b8f:	be 00 00 00 00       	mov    $0x0,%esi
  802b94:	bf 02 00 00 00       	mov    $0x2,%edi
  802b99:	48 b8 0c 28 80 00 00 	movabs $0x80280c,%rax
  802ba0:	00 00 00 
  802ba3:	ff d0                	callq  *%rax
}
  802ba5:	c9                   	leaveq 
  802ba6:	c3                   	retq   

0000000000802ba7 <remove>:

// Delete a file
int
remove(const char *path)
{
  802ba7:	55                   	push   %rbp
  802ba8:	48 89 e5             	mov    %rsp,%rbp
  802bab:	48 83 ec 10          	sub    $0x10,%rsp
  802baf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802bb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bb7:	48 89 c7             	mov    %rax,%rdi
  802bba:	48 b8 a8 11 80 00 00 	movabs $0x8011a8,%rax
  802bc1:	00 00 00 
  802bc4:	ff d0                	callq  *%rax
  802bc6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802bcb:	7e 07                	jle    802bd4 <remove+0x2d>
		return -E_BAD_PATH;
  802bcd:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802bd2:	eb 33                	jmp    802c07 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802bd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bd8:	48 89 c6             	mov    %rax,%rsi
  802bdb:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802be2:	00 00 00 
  802be5:	48 b8 14 12 80 00 00 	movabs $0x801214,%rax
  802bec:	00 00 00 
  802bef:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802bf1:	be 00 00 00 00       	mov    $0x0,%esi
  802bf6:	bf 07 00 00 00       	mov    $0x7,%edi
  802bfb:	48 b8 0c 28 80 00 00 	movabs $0x80280c,%rax
  802c02:	00 00 00 
  802c05:	ff d0                	callq  *%rax
}
  802c07:	c9                   	leaveq 
  802c08:	c3                   	retq   

0000000000802c09 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c09:	55                   	push   %rbp
  802c0a:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c0d:	be 00 00 00 00       	mov    $0x0,%esi
  802c12:	bf 08 00 00 00       	mov    $0x8,%edi
  802c17:	48 b8 0c 28 80 00 00 	movabs $0x80280c,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	callq  *%rax
}
  802c23:	5d                   	pop    %rbp
  802c24:	c3                   	retq   

0000000000802c25 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802c25:	55                   	push   %rbp
  802c26:	48 89 e5             	mov    %rsp,%rbp
  802c29:	53                   	push   %rbx
  802c2a:	48 83 ec 38          	sub    $0x38,%rsp
  802c2e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802c32:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802c36:	48 89 c7             	mov    %rax,%rdi
  802c39:	48 b8 f3 1e 80 00 00 	movabs $0x801ef3,%rax
  802c40:	00 00 00 
  802c43:	ff d0                	callq  *%rax
  802c45:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c48:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c4c:	0f 88 bf 01 00 00    	js     802e11 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c56:	ba 07 04 00 00       	mov    $0x407,%edx
  802c5b:	48 89 c6             	mov    %rax,%rsi
  802c5e:	bf 00 00 00 00       	mov    $0x0,%edi
  802c63:	48 b8 43 1b 80 00 00 	movabs $0x801b43,%rax
  802c6a:	00 00 00 
  802c6d:	ff d0                	callq  *%rax
  802c6f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c72:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c76:	0f 88 95 01 00 00    	js     802e11 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802c7c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802c80:	48 89 c7             	mov    %rax,%rdi
  802c83:	48 b8 f3 1e 80 00 00 	movabs $0x801ef3,%rax
  802c8a:	00 00 00 
  802c8d:	ff d0                	callq  *%rax
  802c8f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c92:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c96:	0f 88 5d 01 00 00    	js     802df9 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c9c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ca0:	ba 07 04 00 00       	mov    $0x407,%edx
  802ca5:	48 89 c6             	mov    %rax,%rsi
  802ca8:	bf 00 00 00 00       	mov    $0x0,%edi
  802cad:	48 b8 43 1b 80 00 00 	movabs $0x801b43,%rax
  802cb4:	00 00 00 
  802cb7:	ff d0                	callq  *%rax
  802cb9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802cbc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802cc0:	0f 88 33 01 00 00    	js     802df9 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802cc6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cca:	48 89 c7             	mov    %rax,%rdi
  802ccd:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  802cd4:	00 00 00 
  802cd7:	ff d0                	callq  *%rax
  802cd9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cdd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ce1:	ba 07 04 00 00       	mov    $0x407,%edx
  802ce6:	48 89 c6             	mov    %rax,%rsi
  802ce9:	bf 00 00 00 00       	mov    $0x0,%edi
  802cee:	48 b8 43 1b 80 00 00 	movabs $0x801b43,%rax
  802cf5:	00 00 00 
  802cf8:	ff d0                	callq  *%rax
  802cfa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802cfd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d01:	79 05                	jns    802d08 <pipe+0xe3>
		goto err2;
  802d03:	e9 d9 00 00 00       	jmpq   802de1 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d08:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d0c:	48 89 c7             	mov    %rax,%rdi
  802d0f:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  802d16:	00 00 00 
  802d19:	ff d0                	callq  *%rax
  802d1b:	48 89 c2             	mov    %rax,%rdx
  802d1e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d22:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802d28:	48 89 d1             	mov    %rdx,%rcx
  802d2b:	ba 00 00 00 00       	mov    $0x0,%edx
  802d30:	48 89 c6             	mov    %rax,%rsi
  802d33:	bf 00 00 00 00       	mov    $0x0,%edi
  802d38:	48 b8 93 1b 80 00 00 	movabs $0x801b93,%rax
  802d3f:	00 00 00 
  802d42:	ff d0                	callq  *%rax
  802d44:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d47:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d4b:	79 1b                	jns    802d68 <pipe+0x143>
		goto err3;
  802d4d:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  802d4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d52:	48 89 c6             	mov    %rax,%rsi
  802d55:	bf 00 00 00 00       	mov    $0x0,%edi
  802d5a:	48 b8 ee 1b 80 00 00 	movabs $0x801bee,%rax
  802d61:	00 00 00 
  802d64:	ff d0                	callq  *%rax
  802d66:	eb 79                	jmp    802de1 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802d68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d6c:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802d73:	00 00 00 
  802d76:	8b 12                	mov    (%rdx),%edx
  802d78:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802d7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d7e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802d85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d89:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802d90:	00 00 00 
  802d93:	8b 12                	mov    (%rdx),%edx
  802d95:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802d97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d9b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802da2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802da6:	48 89 c7             	mov    %rax,%rdi
  802da9:	48 b8 a5 1e 80 00 00 	movabs $0x801ea5,%rax
  802db0:	00 00 00 
  802db3:	ff d0                	callq  *%rax
  802db5:	89 c2                	mov    %eax,%edx
  802db7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802dbb:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802dbd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802dc1:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802dc5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dc9:	48 89 c7             	mov    %rax,%rdi
  802dcc:	48 b8 a5 1e 80 00 00 	movabs $0x801ea5,%rax
  802dd3:	00 00 00 
  802dd6:	ff d0                	callq  *%rax
  802dd8:	89 03                	mov    %eax,(%rbx)
	return 0;
  802dda:	b8 00 00 00 00       	mov    $0x0,%eax
  802ddf:	eb 33                	jmp    802e14 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  802de1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802de5:	48 89 c6             	mov    %rax,%rsi
  802de8:	bf 00 00 00 00       	mov    $0x0,%edi
  802ded:	48 b8 ee 1b 80 00 00 	movabs $0x801bee,%rax
  802df4:	00 00 00 
  802df7:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  802df9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dfd:	48 89 c6             	mov    %rax,%rsi
  802e00:	bf 00 00 00 00       	mov    $0x0,%edi
  802e05:	48 b8 ee 1b 80 00 00 	movabs $0x801bee,%rax
  802e0c:	00 00 00 
  802e0f:	ff d0                	callq  *%rax
    err:
	return r;
  802e11:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802e14:	48 83 c4 38          	add    $0x38,%rsp
  802e18:	5b                   	pop    %rbx
  802e19:	5d                   	pop    %rbp
  802e1a:	c3                   	retq   

0000000000802e1b <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802e1b:	55                   	push   %rbp
  802e1c:	48 89 e5             	mov    %rsp,%rbp
  802e1f:	53                   	push   %rbx
  802e20:	48 83 ec 28          	sub    $0x28,%rsp
  802e24:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e28:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802e2c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802e33:	00 00 00 
  802e36:	48 8b 00             	mov    (%rax),%rax
  802e39:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802e3f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802e42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e46:	48 89 c7             	mov    %rax,%rdi
  802e49:	48 b8 84 36 80 00 00 	movabs $0x803684,%rax
  802e50:	00 00 00 
  802e53:	ff d0                	callq  *%rax
  802e55:	89 c3                	mov    %eax,%ebx
  802e57:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e5b:	48 89 c7             	mov    %rax,%rdi
  802e5e:	48 b8 84 36 80 00 00 	movabs $0x803684,%rax
  802e65:	00 00 00 
  802e68:	ff d0                	callq  *%rax
  802e6a:	39 c3                	cmp    %eax,%ebx
  802e6c:	0f 94 c0             	sete   %al
  802e6f:	0f b6 c0             	movzbl %al,%eax
  802e72:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802e75:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802e7c:	00 00 00 
  802e7f:	48 8b 00             	mov    (%rax),%rax
  802e82:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802e88:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802e8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e8e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802e91:	75 05                	jne    802e98 <_pipeisclosed+0x7d>
			return ret;
  802e93:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e96:	eb 4f                	jmp    802ee7 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802e98:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e9b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802e9e:	74 42                	je     802ee2 <_pipeisclosed+0xc7>
  802ea0:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802ea4:	75 3c                	jne    802ee2 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802ea6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802ead:	00 00 00 
  802eb0:	48 8b 00             	mov    (%rax),%rax
  802eb3:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802eb9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802ebc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ebf:	89 c6                	mov    %eax,%esi
  802ec1:	48 bf 33 3d 80 00 00 	movabs $0x803d33,%rdi
  802ec8:	00 00 00 
  802ecb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed0:	49 b8 6c 04 80 00 00 	movabs $0x80046c,%r8
  802ed7:	00 00 00 
  802eda:	41 ff d0             	callq  *%r8
	}
  802edd:	e9 4a ff ff ff       	jmpq   802e2c <_pipeisclosed+0x11>
  802ee2:	e9 45 ff ff ff       	jmpq   802e2c <_pipeisclosed+0x11>
}
  802ee7:	48 83 c4 28          	add    $0x28,%rsp
  802eeb:	5b                   	pop    %rbx
  802eec:	5d                   	pop    %rbp
  802eed:	c3                   	retq   

0000000000802eee <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802eee:	55                   	push   %rbp
  802eef:	48 89 e5             	mov    %rsp,%rbp
  802ef2:	48 83 ec 30          	sub    $0x30,%rsp
  802ef6:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ef9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802efd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f00:	48 89 d6             	mov    %rdx,%rsi
  802f03:	89 c7                	mov    %eax,%edi
  802f05:	48 b8 8b 1f 80 00 00 	movabs $0x801f8b,%rax
  802f0c:	00 00 00 
  802f0f:	ff d0                	callq  *%rax
  802f11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f18:	79 05                	jns    802f1f <pipeisclosed+0x31>
		return r;
  802f1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1d:	eb 31                	jmp    802f50 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802f1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f23:	48 89 c7             	mov    %rax,%rdi
  802f26:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  802f2d:	00 00 00 
  802f30:	ff d0                	callq  *%rax
  802f32:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802f36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f3e:	48 89 d6             	mov    %rdx,%rsi
  802f41:	48 89 c7             	mov    %rax,%rdi
  802f44:	48 b8 1b 2e 80 00 00 	movabs $0x802e1b,%rax
  802f4b:	00 00 00 
  802f4e:	ff d0                	callq  *%rax
}
  802f50:	c9                   	leaveq 
  802f51:	c3                   	retq   

0000000000802f52 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802f52:	55                   	push   %rbp
  802f53:	48 89 e5             	mov    %rsp,%rbp
  802f56:	48 83 ec 40          	sub    $0x40,%rsp
  802f5a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f5e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f62:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802f66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f6a:	48 89 c7             	mov    %rax,%rdi
  802f6d:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  802f74:	00 00 00 
  802f77:	ff d0                	callq  *%rax
  802f79:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802f7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802f85:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802f8c:	00 
  802f8d:	e9 92 00 00 00       	jmpq   803024 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802f92:	eb 41                	jmp    802fd5 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802f94:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802f99:	74 09                	je     802fa4 <devpipe_read+0x52>
				return i;
  802f9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f9f:	e9 92 00 00 00       	jmpq   803036 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802fa4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fa8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fac:	48 89 d6             	mov    %rdx,%rsi
  802faf:	48 89 c7             	mov    %rax,%rdi
  802fb2:	48 b8 1b 2e 80 00 00 	movabs $0x802e1b,%rax
  802fb9:	00 00 00 
  802fbc:	ff d0                	callq  *%rax
  802fbe:	85 c0                	test   %eax,%eax
  802fc0:	74 07                	je     802fc9 <devpipe_read+0x77>
				return 0;
  802fc2:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc7:	eb 6d                	jmp    803036 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802fc9:	48 b8 05 1b 80 00 00 	movabs $0x801b05,%rax
  802fd0:	00 00 00 
  802fd3:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802fd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd9:	8b 10                	mov    (%rax),%edx
  802fdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fdf:	8b 40 04             	mov    0x4(%rax),%eax
  802fe2:	39 c2                	cmp    %eax,%edx
  802fe4:	74 ae                	je     802f94 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802fe6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802fee:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802ff2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff6:	8b 00                	mov    (%rax),%eax
  802ff8:	99                   	cltd   
  802ff9:	c1 ea 1b             	shr    $0x1b,%edx
  802ffc:	01 d0                	add    %edx,%eax
  802ffe:	83 e0 1f             	and    $0x1f,%eax
  803001:	29 d0                	sub    %edx,%eax
  803003:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803007:	48 98                	cltq   
  803009:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80300e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803010:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803014:	8b 00                	mov    (%rax),%eax
  803016:	8d 50 01             	lea    0x1(%rax),%edx
  803019:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80301d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80301f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803024:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803028:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80302c:	0f 82 60 ff ff ff    	jb     802f92 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803032:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803036:	c9                   	leaveq 
  803037:	c3                   	retq   

0000000000803038 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803038:	55                   	push   %rbp
  803039:	48 89 e5             	mov    %rsp,%rbp
  80303c:	48 83 ec 40          	sub    $0x40,%rsp
  803040:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803044:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803048:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80304c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803050:	48 89 c7             	mov    %rax,%rdi
  803053:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  80305a:	00 00 00 
  80305d:	ff d0                	callq  *%rax
  80305f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803063:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803067:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80306b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803072:	00 
  803073:	e9 8e 00 00 00       	jmpq   803106 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803078:	eb 31                	jmp    8030ab <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80307a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80307e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803082:	48 89 d6             	mov    %rdx,%rsi
  803085:	48 89 c7             	mov    %rax,%rdi
  803088:	48 b8 1b 2e 80 00 00 	movabs $0x802e1b,%rax
  80308f:	00 00 00 
  803092:	ff d0                	callq  *%rax
  803094:	85 c0                	test   %eax,%eax
  803096:	74 07                	je     80309f <devpipe_write+0x67>
				return 0;
  803098:	b8 00 00 00 00       	mov    $0x0,%eax
  80309d:	eb 79                	jmp    803118 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80309f:	48 b8 05 1b 80 00 00 	movabs $0x801b05,%rax
  8030a6:	00 00 00 
  8030a9:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8030ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030af:	8b 40 04             	mov    0x4(%rax),%eax
  8030b2:	48 63 d0             	movslq %eax,%rdx
  8030b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b9:	8b 00                	mov    (%rax),%eax
  8030bb:	48 98                	cltq   
  8030bd:	48 83 c0 20          	add    $0x20,%rax
  8030c1:	48 39 c2             	cmp    %rax,%rdx
  8030c4:	73 b4                	jae    80307a <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8030c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ca:	8b 40 04             	mov    0x4(%rax),%eax
  8030cd:	99                   	cltd   
  8030ce:	c1 ea 1b             	shr    $0x1b,%edx
  8030d1:	01 d0                	add    %edx,%eax
  8030d3:	83 e0 1f             	and    $0x1f,%eax
  8030d6:	29 d0                	sub    %edx,%eax
  8030d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8030dc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8030e0:	48 01 ca             	add    %rcx,%rdx
  8030e3:	0f b6 0a             	movzbl (%rdx),%ecx
  8030e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030ea:	48 98                	cltq   
  8030ec:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8030f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f4:	8b 40 04             	mov    0x4(%rax),%eax
  8030f7:	8d 50 01             	lea    0x1(%rax),%edx
  8030fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030fe:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803101:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803106:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80310a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80310e:	0f 82 64 ff ff ff    	jb     803078 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803114:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803118:	c9                   	leaveq 
  803119:	c3                   	retq   

000000000080311a <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80311a:	55                   	push   %rbp
  80311b:	48 89 e5             	mov    %rsp,%rbp
  80311e:	48 83 ec 20          	sub    $0x20,%rsp
  803122:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803126:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80312a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80312e:	48 89 c7             	mov    %rax,%rdi
  803131:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  803138:	00 00 00 
  80313b:	ff d0                	callq  *%rax
  80313d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803141:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803145:	48 be 46 3d 80 00 00 	movabs $0x803d46,%rsi
  80314c:	00 00 00 
  80314f:	48 89 c7             	mov    %rax,%rdi
  803152:	48 b8 14 12 80 00 00 	movabs $0x801214,%rax
  803159:	00 00 00 
  80315c:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80315e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803162:	8b 50 04             	mov    0x4(%rax),%edx
  803165:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803169:	8b 00                	mov    (%rax),%eax
  80316b:	29 c2                	sub    %eax,%edx
  80316d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803171:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803177:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80317b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803182:	00 00 00 
	stat->st_dev = &devpipe;
  803185:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803189:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  803190:	00 00 00 
  803193:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80319a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80319f:	c9                   	leaveq 
  8031a0:	c3                   	retq   

00000000008031a1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8031a1:	55                   	push   %rbp
  8031a2:	48 89 e5             	mov    %rsp,%rbp
  8031a5:	48 83 ec 10          	sub    $0x10,%rsp
  8031a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8031ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031b1:	48 89 c6             	mov    %rax,%rsi
  8031b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8031b9:	48 b8 ee 1b 80 00 00 	movabs $0x801bee,%rax
  8031c0:	00 00 00 
  8031c3:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8031c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031c9:	48 89 c7             	mov    %rax,%rdi
  8031cc:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  8031d3:	00 00 00 
  8031d6:	ff d0                	callq  *%rax
  8031d8:	48 89 c6             	mov    %rax,%rsi
  8031db:	bf 00 00 00 00       	mov    $0x0,%edi
  8031e0:	48 b8 ee 1b 80 00 00 	movabs $0x801bee,%rax
  8031e7:	00 00 00 
  8031ea:	ff d0                	callq  *%rax
}
  8031ec:	c9                   	leaveq 
  8031ed:	c3                   	retq   

00000000008031ee <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8031ee:	55                   	push   %rbp
  8031ef:	48 89 e5             	mov    %rsp,%rbp
  8031f2:	48 83 ec 20          	sub    $0x20,%rsp
  8031f6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8031f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031fc:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8031ff:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803203:	be 01 00 00 00       	mov    $0x1,%esi
  803208:	48 89 c7             	mov    %rax,%rdi
  80320b:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  803212:	00 00 00 
  803215:	ff d0                	callq  *%rax
}
  803217:	c9                   	leaveq 
  803218:	c3                   	retq   

0000000000803219 <getchar>:

int
getchar(void)
{
  803219:	55                   	push   %rbp
  80321a:	48 89 e5             	mov    %rsp,%rbp
  80321d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803221:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803225:	ba 01 00 00 00       	mov    $0x1,%edx
  80322a:	48 89 c6             	mov    %rax,%rsi
  80322d:	bf 00 00 00 00       	mov    $0x0,%edi
  803232:	48 b8 bd 23 80 00 00 	movabs $0x8023bd,%rax
  803239:	00 00 00 
  80323c:	ff d0                	callq  *%rax
  80323e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803241:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803245:	79 05                	jns    80324c <getchar+0x33>
		return r;
  803247:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80324a:	eb 14                	jmp    803260 <getchar+0x47>
	if (r < 1)
  80324c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803250:	7f 07                	jg     803259 <getchar+0x40>
		return -E_EOF;
  803252:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803257:	eb 07                	jmp    803260 <getchar+0x47>
	return c;
  803259:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80325d:	0f b6 c0             	movzbl %al,%eax
}
  803260:	c9                   	leaveq 
  803261:	c3                   	retq   

0000000000803262 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803262:	55                   	push   %rbp
  803263:	48 89 e5             	mov    %rsp,%rbp
  803266:	48 83 ec 20          	sub    $0x20,%rsp
  80326a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80326d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803271:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803274:	48 89 d6             	mov    %rdx,%rsi
  803277:	89 c7                	mov    %eax,%edi
  803279:	48 b8 8b 1f 80 00 00 	movabs $0x801f8b,%rax
  803280:	00 00 00 
  803283:	ff d0                	callq  *%rax
  803285:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803288:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80328c:	79 05                	jns    803293 <iscons+0x31>
		return r;
  80328e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803291:	eb 1a                	jmp    8032ad <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803293:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803297:	8b 10                	mov    (%rax),%edx
  803299:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8032a0:	00 00 00 
  8032a3:	8b 00                	mov    (%rax),%eax
  8032a5:	39 c2                	cmp    %eax,%edx
  8032a7:	0f 94 c0             	sete   %al
  8032aa:	0f b6 c0             	movzbl %al,%eax
}
  8032ad:	c9                   	leaveq 
  8032ae:	c3                   	retq   

00000000008032af <opencons>:

int
opencons(void)
{
  8032af:	55                   	push   %rbp
  8032b0:	48 89 e5             	mov    %rsp,%rbp
  8032b3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8032b7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8032bb:	48 89 c7             	mov    %rax,%rdi
  8032be:	48 b8 f3 1e 80 00 00 	movabs $0x801ef3,%rax
  8032c5:	00 00 00 
  8032c8:	ff d0                	callq  *%rax
  8032ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d1:	79 05                	jns    8032d8 <opencons+0x29>
		return r;
  8032d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d6:	eb 5b                	jmp    803333 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8032d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032dc:	ba 07 04 00 00       	mov    $0x407,%edx
  8032e1:	48 89 c6             	mov    %rax,%rsi
  8032e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8032e9:	48 b8 43 1b 80 00 00 	movabs $0x801b43,%rax
  8032f0:	00 00 00 
  8032f3:	ff d0                	callq  *%rax
  8032f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032fc:	79 05                	jns    803303 <opencons+0x54>
		return r;
  8032fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803301:	eb 30                	jmp    803333 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803303:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803307:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  80330e:	00 00 00 
  803311:	8b 12                	mov    (%rdx),%edx
  803313:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803319:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803320:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803324:	48 89 c7             	mov    %rax,%rdi
  803327:	48 b8 a5 1e 80 00 00 	movabs $0x801ea5,%rax
  80332e:	00 00 00 
  803331:	ff d0                	callq  *%rax
}
  803333:	c9                   	leaveq 
  803334:	c3                   	retq   

0000000000803335 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803335:	55                   	push   %rbp
  803336:	48 89 e5             	mov    %rsp,%rbp
  803339:	48 83 ec 30          	sub    $0x30,%rsp
  80333d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803341:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803345:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803349:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80334e:	75 07                	jne    803357 <devcons_read+0x22>
		return 0;
  803350:	b8 00 00 00 00       	mov    $0x0,%eax
  803355:	eb 4b                	jmp    8033a2 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803357:	eb 0c                	jmp    803365 <devcons_read+0x30>
		sys_yield();
  803359:	48 b8 05 1b 80 00 00 	movabs $0x801b05,%rax
  803360:	00 00 00 
  803363:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803365:	48 b8 45 1a 80 00 00 	movabs $0x801a45,%rax
  80336c:	00 00 00 
  80336f:	ff d0                	callq  *%rax
  803371:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803374:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803378:	74 df                	je     803359 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80337a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80337e:	79 05                	jns    803385 <devcons_read+0x50>
		return c;
  803380:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803383:	eb 1d                	jmp    8033a2 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803385:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803389:	75 07                	jne    803392 <devcons_read+0x5d>
		return 0;
  80338b:	b8 00 00 00 00       	mov    $0x0,%eax
  803390:	eb 10                	jmp    8033a2 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803392:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803395:	89 c2                	mov    %eax,%edx
  803397:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80339b:	88 10                	mov    %dl,(%rax)
	return 1;
  80339d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8033a2:	c9                   	leaveq 
  8033a3:	c3                   	retq   

00000000008033a4 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8033a4:	55                   	push   %rbp
  8033a5:	48 89 e5             	mov    %rsp,%rbp
  8033a8:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8033af:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8033b6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8033bd:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8033c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8033cb:	eb 76                	jmp    803443 <devcons_write+0x9f>
		m = n - tot;
  8033cd:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8033d4:	89 c2                	mov    %eax,%edx
  8033d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d9:	29 c2                	sub    %eax,%edx
  8033db:	89 d0                	mov    %edx,%eax
  8033dd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8033e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033e3:	83 f8 7f             	cmp    $0x7f,%eax
  8033e6:	76 07                	jbe    8033ef <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8033e8:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8033ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033f2:	48 63 d0             	movslq %eax,%rdx
  8033f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f8:	48 63 c8             	movslq %eax,%rcx
  8033fb:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803402:	48 01 c1             	add    %rax,%rcx
  803405:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80340c:	48 89 ce             	mov    %rcx,%rsi
  80340f:	48 89 c7             	mov    %rax,%rdi
  803412:	48 b8 38 15 80 00 00 	movabs $0x801538,%rax
  803419:	00 00 00 
  80341c:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80341e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803421:	48 63 d0             	movslq %eax,%rdx
  803424:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80342b:	48 89 d6             	mov    %rdx,%rsi
  80342e:	48 89 c7             	mov    %rax,%rdi
  803431:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  803438:	00 00 00 
  80343b:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80343d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803440:	01 45 fc             	add    %eax,-0x4(%rbp)
  803443:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803446:	48 98                	cltq   
  803448:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80344f:	0f 82 78 ff ff ff    	jb     8033cd <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803455:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803458:	c9                   	leaveq 
  803459:	c3                   	retq   

000000000080345a <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80345a:	55                   	push   %rbp
  80345b:	48 89 e5             	mov    %rsp,%rbp
  80345e:	48 83 ec 08          	sub    $0x8,%rsp
  803462:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803466:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80346b:	c9                   	leaveq 
  80346c:	c3                   	retq   

000000000080346d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80346d:	55                   	push   %rbp
  80346e:	48 89 e5             	mov    %rsp,%rbp
  803471:	48 83 ec 10          	sub    $0x10,%rsp
  803475:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803479:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80347d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803481:	48 be 52 3d 80 00 00 	movabs $0x803d52,%rsi
  803488:	00 00 00 
  80348b:	48 89 c7             	mov    %rax,%rdi
  80348e:	48 b8 14 12 80 00 00 	movabs $0x801214,%rax
  803495:	00 00 00 
  803498:	ff d0                	callq  *%rax
	return 0;
  80349a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80349f:	c9                   	leaveq 
  8034a0:	c3                   	retq   

00000000008034a1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8034a1:	55                   	push   %rbp
  8034a2:	48 89 e5             	mov    %rsp,%rbp
  8034a5:	48 83 ec 30          	sub    $0x30,%rsp
  8034a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8034b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8034bd:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8034c2:	75 0e                	jne    8034d2 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  8034c4:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8034cb:	00 00 00 
  8034ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  8034d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034d6:	48 89 c7             	mov    %rax,%rdi
  8034d9:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  8034e0:	00 00 00 
  8034e3:	ff d0                	callq  *%rax
  8034e5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8034e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8034ec:	79 27                	jns    803515 <ipc_recv+0x74>
		if (from_env_store != NULL)
  8034ee:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8034f3:	74 0a                	je     8034ff <ipc_recv+0x5e>
			*from_env_store = 0;
  8034f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034f9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  8034ff:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803504:	74 0a                	je     803510 <ipc_recv+0x6f>
			*perm_store = 0;
  803506:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80350a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803510:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803513:	eb 53                	jmp    803568 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  803515:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80351a:	74 19                	je     803535 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  80351c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803523:	00 00 00 
  803526:	48 8b 00             	mov    (%rax),%rax
  803529:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80352f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803533:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  803535:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80353a:	74 19                	je     803555 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  80353c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803543:	00 00 00 
  803546:	48 8b 00             	mov    (%rax),%rax
  803549:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80354f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803553:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  803555:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80355c:	00 00 00 
  80355f:	48 8b 00             	mov    (%rax),%rax
  803562:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803568:	c9                   	leaveq 
  803569:	c3                   	retq   

000000000080356a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80356a:	55                   	push   %rbp
  80356b:	48 89 e5             	mov    %rsp,%rbp
  80356e:	48 83 ec 30          	sub    $0x30,%rsp
  803572:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803575:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803578:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80357c:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  80357f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803583:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803587:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80358c:	75 10                	jne    80359e <ipc_send+0x34>
		page = (void *)KERNBASE;
  80358e:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803595:	00 00 00 
  803598:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  80359c:	eb 0e                	jmp    8035ac <ipc_send+0x42>
  80359e:	eb 0c                	jmp    8035ac <ipc_send+0x42>
		sys_yield();
  8035a0:	48 b8 05 1b 80 00 00 	movabs $0x801b05,%rax
  8035a7:	00 00 00 
  8035aa:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  8035ac:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8035af:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8035b2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8035b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035b9:	89 c7                	mov    %eax,%edi
  8035bb:	48 b8 17 1d 80 00 00 	movabs $0x801d17,%rax
  8035c2:	00 00 00 
  8035c5:	ff d0                	callq  *%rax
  8035c7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8035ca:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  8035ce:	74 d0                	je     8035a0 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  8035d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8035d4:	74 2a                	je     803600 <ipc_send+0x96>
		panic("error on ipc send procedure");
  8035d6:	48 ba 59 3d 80 00 00 	movabs $0x803d59,%rdx
  8035dd:	00 00 00 
  8035e0:	be 49 00 00 00       	mov    $0x49,%esi
  8035e5:	48 bf 75 3d 80 00 00 	movabs $0x803d75,%rdi
  8035ec:	00 00 00 
  8035ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f4:	48 b9 33 02 80 00 00 	movabs $0x800233,%rcx
  8035fb:	00 00 00 
  8035fe:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  803600:	c9                   	leaveq 
  803601:	c3                   	retq   

0000000000803602 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803602:	55                   	push   %rbp
  803603:	48 89 e5             	mov    %rsp,%rbp
  803606:	48 83 ec 14          	sub    $0x14,%rsp
  80360a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80360d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803614:	eb 5e                	jmp    803674 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803616:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80361d:	00 00 00 
  803620:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803623:	48 63 d0             	movslq %eax,%rdx
  803626:	48 89 d0             	mov    %rdx,%rax
  803629:	48 c1 e0 03          	shl    $0x3,%rax
  80362d:	48 01 d0             	add    %rdx,%rax
  803630:	48 c1 e0 05          	shl    $0x5,%rax
  803634:	48 01 c8             	add    %rcx,%rax
  803637:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80363d:	8b 00                	mov    (%rax),%eax
  80363f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803642:	75 2c                	jne    803670 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803644:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80364b:	00 00 00 
  80364e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803651:	48 63 d0             	movslq %eax,%rdx
  803654:	48 89 d0             	mov    %rdx,%rax
  803657:	48 c1 e0 03          	shl    $0x3,%rax
  80365b:	48 01 d0             	add    %rdx,%rax
  80365e:	48 c1 e0 05          	shl    $0x5,%rax
  803662:	48 01 c8             	add    %rcx,%rax
  803665:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80366b:	8b 40 08             	mov    0x8(%rax),%eax
  80366e:	eb 12                	jmp    803682 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803670:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803674:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80367b:	7e 99                	jle    803616 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80367d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803682:	c9                   	leaveq 
  803683:	c3                   	retq   

0000000000803684 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803684:	55                   	push   %rbp
  803685:	48 89 e5             	mov    %rsp,%rbp
  803688:	48 83 ec 18          	sub    $0x18,%rsp
  80368c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803690:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803694:	48 c1 e8 15          	shr    $0x15,%rax
  803698:	48 89 c2             	mov    %rax,%rdx
  80369b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8036a2:	01 00 00 
  8036a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036a9:	83 e0 01             	and    $0x1,%eax
  8036ac:	48 85 c0             	test   %rax,%rax
  8036af:	75 07                	jne    8036b8 <pageref+0x34>
		return 0;
  8036b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b6:	eb 53                	jmp    80370b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8036b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036bc:	48 c1 e8 0c          	shr    $0xc,%rax
  8036c0:	48 89 c2             	mov    %rax,%rdx
  8036c3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8036ca:	01 00 00 
  8036cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8036d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036d9:	83 e0 01             	and    $0x1,%eax
  8036dc:	48 85 c0             	test   %rax,%rax
  8036df:	75 07                	jne    8036e8 <pageref+0x64>
		return 0;
  8036e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8036e6:	eb 23                	jmp    80370b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8036e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036ec:	48 c1 e8 0c          	shr    $0xc,%rax
  8036f0:	48 89 c2             	mov    %rax,%rdx
  8036f3:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8036fa:	00 00 00 
  8036fd:	48 c1 e2 04          	shl    $0x4,%rdx
  803701:	48 01 d0             	add    %rdx,%rax
  803704:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803708:	0f b7 c0             	movzwl %ax,%eax
}
  80370b:	c9                   	leaveq 
  80370c:	c3                   	retq   
