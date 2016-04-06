
obj/user/testpteshare.debug:     file format elf64-x86-64


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
  80003c:	e8 67 02 00 00       	callq  8002a8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (argc != 0)
  800052:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800056:	74 0c                	je     800064 <umain+0x21>
		childofspawn();
  800058:	48 b8 75 02 80 00 00 	movabs $0x800275,%rax
  80005f:	00 00 00 
  800062:	ff d0                	callq  *%rax

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	ba 07 04 00 00       	mov    $0x407,%edx
  800069:	be 00 00 00 a0       	mov    $0xa0000000,%esi
  80006e:	bf 00 00 00 00       	mov    $0x0,%edi
  800073:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  80007a:	00 00 00 
  80007d:	ff d0                	callq  *%rax
  80007f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800082:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800086:	79 30                	jns    8000b8 <umain+0x75>
		panic("sys_page_alloc: %e", r);
  800088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008b:	89 c1                	mov    %eax,%ecx
  80008d:	48 ba fe 49 80 00 00 	movabs $0x8049fe,%rdx
  800094:	00 00 00 
  800097:	be 13 00 00 00       	mov    $0x13,%esi
  80009c:	48 bf 11 4a 80 00 00 	movabs $0x804a11,%rdi
  8000a3:	00 00 00 
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  8000b2:	00 00 00 
  8000b5:	41 ff d0             	callq  *%r8

	// check fork
	if ((r = fork()) < 0)
  8000b8:	48 b8 41 21 80 00 00 	movabs $0x802141,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("fork: %e", r);
  8000cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 25 4a 80 00 00 	movabs $0x804a25,%rdx
  8000d9:	00 00 00 
  8000dc:	be 17 00 00 00       	mov    $0x17,%esi
  8000e1:	48 bf 11 4a 80 00 00 	movabs $0x804a11,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800101:	75 2d                	jne    800130 <umain+0xed>
		strcpy(VA, msg);
  800103:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80010a:	00 00 00 
  80010d:	48 8b 00             	mov    (%rax),%rax
  800110:	48 89 c6             	mov    %rax,%rsi
  800113:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800118:	48 b8 3c 13 80 00 00 	movabs $0x80133c,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
		exit();
  800124:	48 b8 38 03 80 00 00 	movabs $0x800338,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	callq  *%rax
	}
	wait(r);
  800130:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800133:	89 c7                	mov    %eax,%edi
  800135:	48 b8 10 43 80 00 00 	movabs $0x804310,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  800141:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800148:	00 00 00 
  80014b:	48 8b 00             	mov    (%rax),%rax
  80014e:	48 89 c6             	mov    %rax,%rsi
  800151:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800156:	48 b8 9e 14 80 00 00 	movabs $0x80149e,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	85 c0                	test   %eax,%eax
  800164:	75 0c                	jne    800172 <umain+0x12f>
  800166:	48 b8 2e 4a 80 00 00 	movabs $0x804a2e,%rax
  80016d:	00 00 00 
  800170:	eb 0a                	jmp    80017c <umain+0x139>
  800172:	48 b8 34 4a 80 00 00 	movabs $0x804a34,%rax
  800179:	00 00 00 
  80017c:	48 89 c6             	mov    %rax,%rsi
  80017f:	48 bf 3a 4a 80 00 00 	movabs $0x804a3a,%rdi
  800186:	00 00 00 
  800189:	b8 00 00 00 00       	mov    $0x0,%eax
  80018e:	48 ba 94 05 80 00 00 	movabs $0x800594,%rdx
  800195:	00 00 00 
  800198:	ff d2                	callq  *%rdx

	// check spawn
	if ((r = spawnl("/bin/testpteshare", "testpteshare", "arg", 0)) < 0)
  80019a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80019f:	48 ba 55 4a 80 00 00 	movabs $0x804a55,%rdx
  8001a6:	00 00 00 
  8001a9:	48 be 59 4a 80 00 00 	movabs $0x804a59,%rsi
  8001b0:	00 00 00 
  8001b3:	48 bf 66 4a 80 00 00 	movabs $0x804a66,%rdi
  8001ba:	00 00 00 
  8001bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c2:	49 b8 b6 34 80 00 00 	movabs $0x8034b6,%r8
  8001c9:	00 00 00 
  8001cc:	41 ff d0             	callq  *%r8
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d6:	79 30                	jns    800208 <umain+0x1c5>
		panic("spawn: %e", r);
  8001d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001db:	89 c1                	mov    %eax,%ecx
  8001dd:	48 ba 78 4a 80 00 00 	movabs $0x804a78,%rdx
  8001e4:	00 00 00 
  8001e7:	be 21 00 00 00       	mov    $0x21,%esi
  8001ec:	48 bf 11 4a 80 00 00 	movabs $0x804a11,%rdi
  8001f3:	00 00 00 
  8001f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fb:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  800202:	00 00 00 
  800205:	41 ff d0             	callq  *%r8
	wait(r);
  800208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020b:	89 c7                	mov    %eax,%edi
  80020d:	48 b8 10 43 80 00 00 	movabs $0x804310,%rax
  800214:	00 00 00 
  800217:	ff d0                	callq  *%rax
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  800219:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800220:	00 00 00 
  800223:	48 8b 00             	mov    (%rax),%rax
  800226:	48 89 c6             	mov    %rax,%rsi
  800229:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80022e:	48 b8 9e 14 80 00 00 	movabs $0x80149e,%rax
  800235:	00 00 00 
  800238:	ff d0                	callq  *%rax
  80023a:	85 c0                	test   %eax,%eax
  80023c:	75 0c                	jne    80024a <umain+0x207>
  80023e:	48 b8 2e 4a 80 00 00 	movabs $0x804a2e,%rax
  800245:	00 00 00 
  800248:	eb 0a                	jmp    800254 <umain+0x211>
  80024a:	48 b8 34 4a 80 00 00 	movabs $0x804a34,%rax
  800251:	00 00 00 
  800254:	48 89 c6             	mov    %rax,%rsi
  800257:	48 bf 82 4a 80 00 00 	movabs $0x804a82,%rdi
  80025e:	00 00 00 
  800261:	b8 00 00 00 00       	mov    $0x0,%eax
  800266:	48 ba 94 05 80 00 00 	movabs $0x800594,%rdx
  80026d:	00 00 00 
  800270:	ff d2                	callq  *%rdx
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800272:	cc                   	int3   

	breakpoint();
}
  800273:	c9                   	leaveq 
  800274:	c3                   	retq   

0000000000800275 <childofspawn>:

void
childofspawn(void)
{
  800275:	55                   	push   %rbp
  800276:	48 89 e5             	mov    %rsp,%rbp
	strcpy(VA, msg2);
  800279:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800280:	00 00 00 
  800283:	48 8b 00             	mov    (%rax),%rax
  800286:	48 89 c6             	mov    %rax,%rsi
  800289:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80028e:	48 b8 3c 13 80 00 00 	movabs $0x80133c,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	exit();
  80029a:	48 b8 38 03 80 00 00 	movabs $0x800338,%rax
  8002a1:	00 00 00 
  8002a4:	ff d0                	callq  *%rax
}
  8002a6:	5d                   	pop    %rbp
  8002a7:	c3                   	retq   

00000000008002a8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	48 83 ec 10          	sub    $0x10,%rsp
  8002b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8002b7:	48 b8 ef 1b 80 00 00 	movabs $0x801bef,%rax
  8002be:	00 00 00 
  8002c1:	ff d0                	callq  *%rax
  8002c3:	48 98                	cltq   
  8002c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002ca:	48 89 c2             	mov    %rax,%rdx
  8002cd:	48 89 d0             	mov    %rdx,%rax
  8002d0:	48 c1 e0 03          	shl    $0x3,%rax
  8002d4:	48 01 d0             	add    %rdx,%rax
  8002d7:	48 c1 e0 05          	shl    $0x5,%rax
  8002db:	48 89 c2             	mov    %rax,%rdx
  8002de:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8002e5:	00 00 00 
  8002e8:	48 01 c2             	add    %rax,%rdx
  8002eb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8002f2:	00 00 00 
  8002f5:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002fc:	7e 14                	jle    800312 <libmain+0x6a>
		binaryname = argv[0];
  8002fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800302:	48 8b 10             	mov    (%rax),%rdx
  800305:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  80030c:	00 00 00 
  80030f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800312:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800316:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800319:	48 89 d6             	mov    %rdx,%rsi
  80031c:	89 c7                	mov    %eax,%edi
  80031e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800325:	00 00 00 
  800328:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80032a:	48 b8 38 03 80 00 00 	movabs $0x800338,%rax
  800331:	00 00 00 
  800334:	ff d0                	callq  *%rax
}
  800336:	c9                   	leaveq 
  800337:	c3                   	retq   

0000000000800338 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800338:	55                   	push   %rbp
  800339:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80033c:	48 b8 1c 27 80 00 00 	movabs $0x80271c,%rax
  800343:	00 00 00 
  800346:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800348:	bf 00 00 00 00       	mov    $0x0,%edi
  80034d:	48 b8 ab 1b 80 00 00 	movabs $0x801bab,%rax
  800354:	00 00 00 
  800357:	ff d0                	callq  *%rax
}
  800359:	5d                   	pop    %rbp
  80035a:	c3                   	retq   

000000000080035b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80035b:	55                   	push   %rbp
  80035c:	48 89 e5             	mov    %rsp,%rbp
  80035f:	53                   	push   %rbx
  800360:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800367:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80036e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800374:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80037b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800382:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800389:	84 c0                	test   %al,%al
  80038b:	74 23                	je     8003b0 <_panic+0x55>
  80038d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800394:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800398:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80039c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8003a0:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003a4:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003a8:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003ac:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003b0:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003b7:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003be:	00 00 00 
  8003c1:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003c8:	00 00 00 
  8003cb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003cf:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003d6:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8003dd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003e4:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8003eb:	00 00 00 
  8003ee:	48 8b 18             	mov    (%rax),%rbx
  8003f1:	48 b8 ef 1b 80 00 00 	movabs $0x801bef,%rax
  8003f8:	00 00 00 
  8003fb:	ff d0                	callq  *%rax
  8003fd:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800403:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80040a:	41 89 c8             	mov    %ecx,%r8d
  80040d:	48 89 d1             	mov    %rdx,%rcx
  800410:	48 89 da             	mov    %rbx,%rdx
  800413:	89 c6                	mov    %eax,%esi
  800415:	48 bf a8 4a 80 00 00 	movabs $0x804aa8,%rdi
  80041c:	00 00 00 
  80041f:	b8 00 00 00 00       	mov    $0x0,%eax
  800424:	49 b9 94 05 80 00 00 	movabs $0x800594,%r9
  80042b:	00 00 00 
  80042e:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800431:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800438:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80043f:	48 89 d6             	mov    %rdx,%rsi
  800442:	48 89 c7             	mov    %rax,%rdi
  800445:	48 b8 e8 04 80 00 00 	movabs $0x8004e8,%rax
  80044c:	00 00 00 
  80044f:	ff d0                	callq  *%rax
	cprintf("\n");
  800451:	48 bf cb 4a 80 00 00 	movabs $0x804acb,%rdi
  800458:	00 00 00 
  80045b:	b8 00 00 00 00       	mov    $0x0,%eax
  800460:	48 ba 94 05 80 00 00 	movabs $0x800594,%rdx
  800467:	00 00 00 
  80046a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80046c:	cc                   	int3   
  80046d:	eb fd                	jmp    80046c <_panic+0x111>

000000000080046f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80046f:	55                   	push   %rbp
  800470:	48 89 e5             	mov    %rsp,%rbp
  800473:	48 83 ec 10          	sub    $0x10,%rsp
  800477:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80047a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80047e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800482:	8b 00                	mov    (%rax),%eax
  800484:	8d 48 01             	lea    0x1(%rax),%ecx
  800487:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80048b:	89 0a                	mov    %ecx,(%rdx)
  80048d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800490:	89 d1                	mov    %edx,%ecx
  800492:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800496:	48 98                	cltq   
  800498:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80049c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a0:	8b 00                	mov    (%rax),%eax
  8004a2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004a7:	75 2c                	jne    8004d5 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8004a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004ad:	8b 00                	mov    (%rax),%eax
  8004af:	48 98                	cltq   
  8004b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b5:	48 83 c2 08          	add    $0x8,%rdx
  8004b9:	48 89 c6             	mov    %rax,%rsi
  8004bc:	48 89 d7             	mov    %rdx,%rdi
  8004bf:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  8004c6:	00 00 00 
  8004c9:	ff d0                	callq  *%rax
		b->idx = 0;
  8004cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004cf:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8004d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d9:	8b 40 04             	mov    0x4(%rax),%eax
  8004dc:	8d 50 01             	lea    0x1(%rax),%edx
  8004df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004e3:	89 50 04             	mov    %edx,0x4(%rax)
}
  8004e6:	c9                   	leaveq 
  8004e7:	c3                   	retq   

00000000008004e8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8004e8:	55                   	push   %rbp
  8004e9:	48 89 e5             	mov    %rsp,%rbp
  8004ec:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004f3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004fa:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800501:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800508:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80050f:	48 8b 0a             	mov    (%rdx),%rcx
  800512:	48 89 08             	mov    %rcx,(%rax)
  800515:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800519:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80051d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800521:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800525:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80052c:	00 00 00 
	b.cnt = 0;
  80052f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800536:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800539:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800540:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800547:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80054e:	48 89 c6             	mov    %rax,%rsi
  800551:	48 bf 6f 04 80 00 00 	movabs $0x80046f,%rdi
  800558:	00 00 00 
  80055b:	48 b8 47 09 80 00 00 	movabs $0x800947,%rax
  800562:	00 00 00 
  800565:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800567:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80056d:	48 98                	cltq   
  80056f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800576:	48 83 c2 08          	add    $0x8,%rdx
  80057a:	48 89 c6             	mov    %rax,%rsi
  80057d:	48 89 d7             	mov    %rdx,%rdi
  800580:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  800587:	00 00 00 
  80058a:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80058c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800592:	c9                   	leaveq 
  800593:	c3                   	retq   

0000000000800594 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800594:	55                   	push   %rbp
  800595:	48 89 e5             	mov    %rsp,%rbp
  800598:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80059f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005a6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005ad:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005b4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005bb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005c2:	84 c0                	test   %al,%al
  8005c4:	74 20                	je     8005e6 <cprintf+0x52>
  8005c6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005ca:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005ce:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005d2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005d6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8005da:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8005de:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8005e2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8005e6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8005ed:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005f4:	00 00 00 
  8005f7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005fe:	00 00 00 
  800601:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800605:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80060c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800613:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80061a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800621:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800628:	48 8b 0a             	mov    (%rdx),%rcx
  80062b:	48 89 08             	mov    %rcx,(%rax)
  80062e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800632:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800636:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80063a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80063e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800645:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80064c:	48 89 d6             	mov    %rdx,%rsi
  80064f:	48 89 c7             	mov    %rax,%rdi
  800652:	48 b8 e8 04 80 00 00 	movabs $0x8004e8,%rax
  800659:	00 00 00 
  80065c:	ff d0                	callq  *%rax
  80065e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800664:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80066a:	c9                   	leaveq 
  80066b:	c3                   	retq   

000000000080066c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80066c:	55                   	push   %rbp
  80066d:	48 89 e5             	mov    %rsp,%rbp
  800670:	53                   	push   %rbx
  800671:	48 83 ec 38          	sub    $0x38,%rsp
  800675:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800679:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80067d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800681:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800684:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800688:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80068c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80068f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800693:	77 3b                	ja     8006d0 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800695:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800698:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80069c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80069f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a8:	48 f7 f3             	div    %rbx
  8006ab:	48 89 c2             	mov    %rax,%rdx
  8006ae:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8006b1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006b4:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8006b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bc:	41 89 f9             	mov    %edi,%r9d
  8006bf:	48 89 c7             	mov    %rax,%rdi
  8006c2:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  8006c9:	00 00 00 
  8006cc:	ff d0                	callq  *%rax
  8006ce:	eb 1e                	jmp    8006ee <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006d0:	eb 12                	jmp    8006e4 <printnum+0x78>
			putch(padc, putdat);
  8006d2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006d6:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8006d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006dd:	48 89 ce             	mov    %rcx,%rsi
  8006e0:	89 d7                	mov    %edx,%edi
  8006e2:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006e4:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8006e8:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8006ec:	7f e4                	jg     8006d2 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006ee:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fa:	48 f7 f1             	div    %rcx
  8006fd:	48 89 d0             	mov    %rdx,%rax
  800700:	48 ba a8 4c 80 00 00 	movabs $0x804ca8,%rdx
  800707:	00 00 00 
  80070a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80070e:	0f be d0             	movsbl %al,%edx
  800711:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800715:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800719:	48 89 ce             	mov    %rcx,%rsi
  80071c:	89 d7                	mov    %edx,%edi
  80071e:	ff d0                	callq  *%rax
}
  800720:	48 83 c4 38          	add    $0x38,%rsp
  800724:	5b                   	pop    %rbx
  800725:	5d                   	pop    %rbp
  800726:	c3                   	retq   

0000000000800727 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800727:	55                   	push   %rbp
  800728:	48 89 e5             	mov    %rsp,%rbp
  80072b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80072f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800733:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800736:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80073a:	7e 52                	jle    80078e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80073c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800740:	8b 00                	mov    (%rax),%eax
  800742:	83 f8 30             	cmp    $0x30,%eax
  800745:	73 24                	jae    80076b <getuint+0x44>
  800747:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80074f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800753:	8b 00                	mov    (%rax),%eax
  800755:	89 c0                	mov    %eax,%eax
  800757:	48 01 d0             	add    %rdx,%rax
  80075a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075e:	8b 12                	mov    (%rdx),%edx
  800760:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800763:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800767:	89 0a                	mov    %ecx,(%rdx)
  800769:	eb 17                	jmp    800782 <getuint+0x5b>
  80076b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800773:	48 89 d0             	mov    %rdx,%rax
  800776:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80077a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800782:	48 8b 00             	mov    (%rax),%rax
  800785:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800789:	e9 a3 00 00 00       	jmpq   800831 <getuint+0x10a>
	else if (lflag)
  80078e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800792:	74 4f                	je     8007e3 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800798:	8b 00                	mov    (%rax),%eax
  80079a:	83 f8 30             	cmp    $0x30,%eax
  80079d:	73 24                	jae    8007c3 <getuint+0x9c>
  80079f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ab:	8b 00                	mov    (%rax),%eax
  8007ad:	89 c0                	mov    %eax,%eax
  8007af:	48 01 d0             	add    %rdx,%rax
  8007b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b6:	8b 12                	mov    (%rdx),%edx
  8007b8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007bf:	89 0a                	mov    %ecx,(%rdx)
  8007c1:	eb 17                	jmp    8007da <getuint+0xb3>
  8007c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007cb:	48 89 d0             	mov    %rdx,%rax
  8007ce:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007da:	48 8b 00             	mov    (%rax),%rax
  8007dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007e1:	eb 4e                	jmp    800831 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8007e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e7:	8b 00                	mov    (%rax),%eax
  8007e9:	83 f8 30             	cmp    $0x30,%eax
  8007ec:	73 24                	jae    800812 <getuint+0xeb>
  8007ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fa:	8b 00                	mov    (%rax),%eax
  8007fc:	89 c0                	mov    %eax,%eax
  8007fe:	48 01 d0             	add    %rdx,%rax
  800801:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800805:	8b 12                	mov    (%rdx),%edx
  800807:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80080a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080e:	89 0a                	mov    %ecx,(%rdx)
  800810:	eb 17                	jmp    800829 <getuint+0x102>
  800812:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800816:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80081a:	48 89 d0             	mov    %rdx,%rax
  80081d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800821:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800825:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800829:	8b 00                	mov    (%rax),%eax
  80082b:	89 c0                	mov    %eax,%eax
  80082d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800831:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800835:	c9                   	leaveq 
  800836:	c3                   	retq   

0000000000800837 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800837:	55                   	push   %rbp
  800838:	48 89 e5             	mov    %rsp,%rbp
  80083b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80083f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800843:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800846:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80084a:	7e 52                	jle    80089e <getint+0x67>
		x=va_arg(*ap, long long);
  80084c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800850:	8b 00                	mov    (%rax),%eax
  800852:	83 f8 30             	cmp    $0x30,%eax
  800855:	73 24                	jae    80087b <getint+0x44>
  800857:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80085f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800863:	8b 00                	mov    (%rax),%eax
  800865:	89 c0                	mov    %eax,%eax
  800867:	48 01 d0             	add    %rdx,%rax
  80086a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086e:	8b 12                	mov    (%rdx),%edx
  800870:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800873:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800877:	89 0a                	mov    %ecx,(%rdx)
  800879:	eb 17                	jmp    800892 <getint+0x5b>
  80087b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800883:	48 89 d0             	mov    %rdx,%rax
  800886:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80088a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800892:	48 8b 00             	mov    (%rax),%rax
  800895:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800899:	e9 a3 00 00 00       	jmpq   800941 <getint+0x10a>
	else if (lflag)
  80089e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008a2:	74 4f                	je     8008f3 <getint+0xbc>
		x=va_arg(*ap, long);
  8008a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a8:	8b 00                	mov    (%rax),%eax
  8008aa:	83 f8 30             	cmp    $0x30,%eax
  8008ad:	73 24                	jae    8008d3 <getint+0x9c>
  8008af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bb:	8b 00                	mov    (%rax),%eax
  8008bd:	89 c0                	mov    %eax,%eax
  8008bf:	48 01 d0             	add    %rdx,%rax
  8008c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c6:	8b 12                	mov    (%rdx),%edx
  8008c8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008cf:	89 0a                	mov    %ecx,(%rdx)
  8008d1:	eb 17                	jmp    8008ea <getint+0xb3>
  8008d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008db:	48 89 d0             	mov    %rdx,%rax
  8008de:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008ea:	48 8b 00             	mov    (%rax),%rax
  8008ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008f1:	eb 4e                	jmp    800941 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8008f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f7:	8b 00                	mov    (%rax),%eax
  8008f9:	83 f8 30             	cmp    $0x30,%eax
  8008fc:	73 24                	jae    800922 <getint+0xeb>
  8008fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800902:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800906:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090a:	8b 00                	mov    (%rax),%eax
  80090c:	89 c0                	mov    %eax,%eax
  80090e:	48 01 d0             	add    %rdx,%rax
  800911:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800915:	8b 12                	mov    (%rdx),%edx
  800917:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80091a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091e:	89 0a                	mov    %ecx,(%rdx)
  800920:	eb 17                	jmp    800939 <getint+0x102>
  800922:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800926:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80092a:	48 89 d0             	mov    %rdx,%rax
  80092d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800931:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800935:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800939:	8b 00                	mov    (%rax),%eax
  80093b:	48 98                	cltq   
  80093d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800941:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800945:	c9                   	leaveq 
  800946:	c3                   	retq   

0000000000800947 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800947:	55                   	push   %rbp
  800948:	48 89 e5             	mov    %rsp,%rbp
  80094b:	41 54                	push   %r12
  80094d:	53                   	push   %rbx
  80094e:	48 83 ec 60          	sub    $0x60,%rsp
  800952:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800956:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80095a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80095e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800962:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800966:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80096a:	48 8b 0a             	mov    (%rdx),%rcx
  80096d:	48 89 08             	mov    %rcx,(%rax)
  800970:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800974:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800978:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80097c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  800980:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800984:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800988:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80098c:	0f b6 00             	movzbl (%rax),%eax
  80098f:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  800992:	eb 29                	jmp    8009bd <vprintfmt+0x76>
			if (ch == '\0')
  800994:	85 db                	test   %ebx,%ebx
  800996:	0f 84 ad 06 00 00    	je     801049 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  80099c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009a0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009a4:	48 89 d6             	mov    %rdx,%rsi
  8009a7:	89 df                	mov    %ebx,%edi
  8009a9:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  8009ab:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009af:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009b3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009b7:	0f b6 00             	movzbl (%rax),%eax
  8009ba:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  8009bd:	83 fb 25             	cmp    $0x25,%ebx
  8009c0:	74 05                	je     8009c7 <vprintfmt+0x80>
  8009c2:	83 fb 1b             	cmp    $0x1b,%ebx
  8009c5:	75 cd                	jne    800994 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  8009c7:	83 fb 1b             	cmp    $0x1b,%ebx
  8009ca:	0f 85 ae 01 00 00    	jne    800b7e <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  8009d0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8009d7:	00 00 00 
  8009da:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  8009e0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009e4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e8:	48 89 d6             	mov    %rdx,%rsi
  8009eb:	89 df                	mov    %ebx,%edi
  8009ed:	ff d0                	callq  *%rax
			putch('[', putdat);
  8009ef:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f7:	48 89 d6             	mov    %rdx,%rsi
  8009fa:	bf 5b 00 00 00       	mov    $0x5b,%edi
  8009ff:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800a01:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800a07:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a0c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a10:	0f b6 00             	movzbl (%rax),%eax
  800a13:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800a16:	eb 32                	jmp    800a4a <vprintfmt+0x103>
					putch(ch, putdat);
  800a18:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a20:	48 89 d6             	mov    %rdx,%rsi
  800a23:	89 df                	mov    %ebx,%edi
  800a25:	ff d0                	callq  *%rax
					esc_color *= 10;
  800a27:	44 89 e0             	mov    %r12d,%eax
  800a2a:	c1 e0 02             	shl    $0x2,%eax
  800a2d:	44 01 e0             	add    %r12d,%eax
  800a30:	01 c0                	add    %eax,%eax
  800a32:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800a35:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800a38:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800a3b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a40:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a44:	0f b6 00             	movzbl (%rax),%eax
  800a47:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800a4a:	83 fb 3b             	cmp    $0x3b,%ebx
  800a4d:	74 05                	je     800a54 <vprintfmt+0x10d>
  800a4f:	83 fb 6d             	cmp    $0x6d,%ebx
  800a52:	75 c4                	jne    800a18 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800a54:	45 85 e4             	test   %r12d,%r12d
  800a57:	75 15                	jne    800a6e <vprintfmt+0x127>
					color_flag = 0x07;
  800a59:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  800a60:	00 00 00 
  800a63:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800a69:	e9 dc 00 00 00       	jmpq   800b4a <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800a6e:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800a72:	7e 69                	jle    800add <vprintfmt+0x196>
  800a74:	41 83 fc 25          	cmp    $0x25,%r12d
  800a78:	7f 63                	jg     800add <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800a7a:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  800a81:	00 00 00 
  800a84:	8b 00                	mov    (%rax),%eax
  800a86:	25 f8 00 00 00       	and    $0xf8,%eax
  800a8b:	89 c2                	mov    %eax,%edx
  800a8d:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  800a94:	00 00 00 
  800a97:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800a99:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800a9d:	44 89 e0             	mov    %r12d,%eax
  800aa0:	83 e0 04             	and    $0x4,%eax
  800aa3:	c1 f8 02             	sar    $0x2,%eax
  800aa6:	89 c2                	mov    %eax,%edx
  800aa8:	44 89 e0             	mov    %r12d,%eax
  800aab:	83 e0 02             	and    $0x2,%eax
  800aae:	09 c2                	or     %eax,%edx
  800ab0:	44 89 e0             	mov    %r12d,%eax
  800ab3:	83 e0 01             	and    $0x1,%eax
  800ab6:	c1 e0 02             	shl    $0x2,%eax
  800ab9:	09 c2                	or     %eax,%edx
  800abb:	41 89 d4             	mov    %edx,%r12d
  800abe:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  800ac5:	00 00 00 
  800ac8:	8b 00                	mov    (%rax),%eax
  800aca:	44 89 e2             	mov    %r12d,%edx
  800acd:	09 c2                	or     %eax,%edx
  800acf:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  800ad6:	00 00 00 
  800ad9:	89 10                	mov    %edx,(%rax)
  800adb:	eb 6d                	jmp    800b4a <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800add:	41 83 fc 27          	cmp    $0x27,%r12d
  800ae1:	7e 67                	jle    800b4a <vprintfmt+0x203>
  800ae3:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800ae7:	7f 61                	jg     800b4a <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800ae9:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  800af0:	00 00 00 
  800af3:	8b 00                	mov    (%rax),%eax
  800af5:	25 8f 00 00 00       	and    $0x8f,%eax
  800afa:	89 c2                	mov    %eax,%edx
  800afc:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  800b03:	00 00 00 
  800b06:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800b08:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800b0c:	44 89 e0             	mov    %r12d,%eax
  800b0f:	83 e0 04             	and    $0x4,%eax
  800b12:	c1 f8 02             	sar    $0x2,%eax
  800b15:	89 c2                	mov    %eax,%edx
  800b17:	44 89 e0             	mov    %r12d,%eax
  800b1a:	83 e0 02             	and    $0x2,%eax
  800b1d:	09 c2                	or     %eax,%edx
  800b1f:	44 89 e0             	mov    %r12d,%eax
  800b22:	83 e0 01             	and    $0x1,%eax
  800b25:	c1 e0 06             	shl    $0x6,%eax
  800b28:	09 c2                	or     %eax,%edx
  800b2a:	41 89 d4             	mov    %edx,%r12d
  800b2d:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  800b34:	00 00 00 
  800b37:	8b 00                	mov    (%rax),%eax
  800b39:	44 89 e2             	mov    %r12d,%edx
  800b3c:	09 c2                	or     %eax,%edx
  800b3e:	48 b8 18 60 80 00 00 	movabs $0x806018,%rax
  800b45:	00 00 00 
  800b48:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800b4a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b52:	48 89 d6             	mov    %rdx,%rsi
  800b55:	89 df                	mov    %ebx,%edi
  800b57:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800b59:	83 fb 6d             	cmp    $0x6d,%ebx
  800b5c:	75 1b                	jne    800b79 <vprintfmt+0x232>
					fmt ++;
  800b5e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800b63:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800b64:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800b6b:	00 00 00 
  800b6e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800b74:	e9 cb 04 00 00       	jmpq   801044 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800b79:	e9 83 fe ff ff       	jmpq   800a01 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800b7e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b82:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b89:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b90:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b97:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b9e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ba2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ba6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800baa:	0f b6 00             	movzbl (%rax),%eax
  800bad:	0f b6 d8             	movzbl %al,%ebx
  800bb0:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800bb3:	83 f8 55             	cmp    $0x55,%eax
  800bb6:	0f 87 5a 04 00 00    	ja     801016 <vprintfmt+0x6cf>
  800bbc:	89 c0                	mov    %eax,%eax
  800bbe:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bc5:	00 
  800bc6:	48 b8 d0 4c 80 00 00 	movabs $0x804cd0,%rax
  800bcd:	00 00 00 
  800bd0:	48 01 d0             	add    %rdx,%rax
  800bd3:	48 8b 00             	mov    (%rax),%rax
  800bd6:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bd8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bdc:	eb c0                	jmp    800b9e <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bde:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800be2:	eb ba                	jmp    800b9e <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800beb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bee:	89 d0                	mov    %edx,%eax
  800bf0:	c1 e0 02             	shl    $0x2,%eax
  800bf3:	01 d0                	add    %edx,%eax
  800bf5:	01 c0                	add    %eax,%eax
  800bf7:	01 d8                	add    %ebx,%eax
  800bf9:	83 e8 30             	sub    $0x30,%eax
  800bfc:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bff:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c03:	0f b6 00             	movzbl (%rax),%eax
  800c06:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c09:	83 fb 2f             	cmp    $0x2f,%ebx
  800c0c:	7e 0c                	jle    800c1a <vprintfmt+0x2d3>
  800c0e:	83 fb 39             	cmp    $0x39,%ebx
  800c11:	7f 07                	jg     800c1a <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c13:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c18:	eb d1                	jmp    800beb <vprintfmt+0x2a4>
			goto process_precision;
  800c1a:	eb 58                	jmp    800c74 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800c1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c1f:	83 f8 30             	cmp    $0x30,%eax
  800c22:	73 17                	jae    800c3b <vprintfmt+0x2f4>
  800c24:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c28:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c2b:	89 c0                	mov    %eax,%eax
  800c2d:	48 01 d0             	add    %rdx,%rax
  800c30:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c33:	83 c2 08             	add    $0x8,%edx
  800c36:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c39:	eb 0f                	jmp    800c4a <vprintfmt+0x303>
  800c3b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c3f:	48 89 d0             	mov    %rdx,%rax
  800c42:	48 83 c2 08          	add    $0x8,%rdx
  800c46:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c4a:	8b 00                	mov    (%rax),%eax
  800c4c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c4f:	eb 23                	jmp    800c74 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800c51:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c55:	79 0c                	jns    800c63 <vprintfmt+0x31c>
				width = 0;
  800c57:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c5e:	e9 3b ff ff ff       	jmpq   800b9e <vprintfmt+0x257>
  800c63:	e9 36 ff ff ff       	jmpq   800b9e <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800c68:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c6f:	e9 2a ff ff ff       	jmpq   800b9e <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800c74:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c78:	79 12                	jns    800c8c <vprintfmt+0x345>
				width = precision, precision = -1;
  800c7a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c7d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c80:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c87:	e9 12 ff ff ff       	jmpq   800b9e <vprintfmt+0x257>
  800c8c:	e9 0d ff ff ff       	jmpq   800b9e <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c91:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c95:	e9 04 ff ff ff       	jmpq   800b9e <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c9a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9d:	83 f8 30             	cmp    $0x30,%eax
  800ca0:	73 17                	jae    800cb9 <vprintfmt+0x372>
  800ca2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ca6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca9:	89 c0                	mov    %eax,%eax
  800cab:	48 01 d0             	add    %rdx,%rax
  800cae:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb1:	83 c2 08             	add    $0x8,%edx
  800cb4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cb7:	eb 0f                	jmp    800cc8 <vprintfmt+0x381>
  800cb9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cbd:	48 89 d0             	mov    %rdx,%rax
  800cc0:	48 83 c2 08          	add    $0x8,%rdx
  800cc4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cc8:	8b 10                	mov    (%rax),%edx
  800cca:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd2:	48 89 ce             	mov    %rcx,%rsi
  800cd5:	89 d7                	mov    %edx,%edi
  800cd7:	ff d0                	callq  *%rax
			break;
  800cd9:	e9 66 03 00 00       	jmpq   801044 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800cde:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce1:	83 f8 30             	cmp    $0x30,%eax
  800ce4:	73 17                	jae    800cfd <vprintfmt+0x3b6>
  800ce6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ced:	89 c0                	mov    %eax,%eax
  800cef:	48 01 d0             	add    %rdx,%rax
  800cf2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cf5:	83 c2 08             	add    $0x8,%edx
  800cf8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cfb:	eb 0f                	jmp    800d0c <vprintfmt+0x3c5>
  800cfd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d01:	48 89 d0             	mov    %rdx,%rax
  800d04:	48 83 c2 08          	add    $0x8,%rdx
  800d08:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d0c:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d0e:	85 db                	test   %ebx,%ebx
  800d10:	79 02                	jns    800d14 <vprintfmt+0x3cd>
				err = -err;
  800d12:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d14:	83 fb 10             	cmp    $0x10,%ebx
  800d17:	7f 16                	jg     800d2f <vprintfmt+0x3e8>
  800d19:	48 b8 20 4c 80 00 00 	movabs $0x804c20,%rax
  800d20:	00 00 00 
  800d23:	48 63 d3             	movslq %ebx,%rdx
  800d26:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d2a:	4d 85 e4             	test   %r12,%r12
  800d2d:	75 2e                	jne    800d5d <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800d2f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d33:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d37:	89 d9                	mov    %ebx,%ecx
  800d39:	48 ba b9 4c 80 00 00 	movabs $0x804cb9,%rdx
  800d40:	00 00 00 
  800d43:	48 89 c7             	mov    %rax,%rdi
  800d46:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4b:	49 b8 52 10 80 00 00 	movabs $0x801052,%r8
  800d52:	00 00 00 
  800d55:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d58:	e9 e7 02 00 00       	jmpq   801044 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d5d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d65:	4c 89 e1             	mov    %r12,%rcx
  800d68:	48 ba c2 4c 80 00 00 	movabs $0x804cc2,%rdx
  800d6f:	00 00 00 
  800d72:	48 89 c7             	mov    %rax,%rdi
  800d75:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7a:	49 b8 52 10 80 00 00 	movabs $0x801052,%r8
  800d81:	00 00 00 
  800d84:	41 ff d0             	callq  *%r8
			break;
  800d87:	e9 b8 02 00 00       	jmpq   801044 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d8c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d8f:	83 f8 30             	cmp    $0x30,%eax
  800d92:	73 17                	jae    800dab <vprintfmt+0x464>
  800d94:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d98:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d9b:	89 c0                	mov    %eax,%eax
  800d9d:	48 01 d0             	add    %rdx,%rax
  800da0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800da3:	83 c2 08             	add    $0x8,%edx
  800da6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800da9:	eb 0f                	jmp    800dba <vprintfmt+0x473>
  800dab:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800daf:	48 89 d0             	mov    %rdx,%rax
  800db2:	48 83 c2 08          	add    $0x8,%rdx
  800db6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dba:	4c 8b 20             	mov    (%rax),%r12
  800dbd:	4d 85 e4             	test   %r12,%r12
  800dc0:	75 0a                	jne    800dcc <vprintfmt+0x485>
				p = "(null)";
  800dc2:	49 bc c5 4c 80 00 00 	movabs $0x804cc5,%r12
  800dc9:	00 00 00 
			if (width > 0 && padc != '-')
  800dcc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dd0:	7e 3f                	jle    800e11 <vprintfmt+0x4ca>
  800dd2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dd6:	74 39                	je     800e11 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ddb:	48 98                	cltq   
  800ddd:	48 89 c6             	mov    %rax,%rsi
  800de0:	4c 89 e7             	mov    %r12,%rdi
  800de3:	48 b8 fe 12 80 00 00 	movabs $0x8012fe,%rax
  800dea:	00 00 00 
  800ded:	ff d0                	callq  *%rax
  800def:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800df2:	eb 17                	jmp    800e0b <vprintfmt+0x4c4>
					putch(padc, putdat);
  800df4:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800df8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800dfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e00:	48 89 ce             	mov    %rcx,%rsi
  800e03:	89 d7                	mov    %edx,%edi
  800e05:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e07:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e0b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e0f:	7f e3                	jg     800df4 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e11:	eb 37                	jmp    800e4a <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800e13:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e17:	74 1e                	je     800e37 <vprintfmt+0x4f0>
  800e19:	83 fb 1f             	cmp    $0x1f,%ebx
  800e1c:	7e 05                	jle    800e23 <vprintfmt+0x4dc>
  800e1e:	83 fb 7e             	cmp    $0x7e,%ebx
  800e21:	7e 14                	jle    800e37 <vprintfmt+0x4f0>
					putch('?', putdat);
  800e23:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2b:	48 89 d6             	mov    %rdx,%rsi
  800e2e:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e33:	ff d0                	callq  *%rax
  800e35:	eb 0f                	jmp    800e46 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800e37:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e3f:	48 89 d6             	mov    %rdx,%rsi
  800e42:	89 df                	mov    %ebx,%edi
  800e44:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e46:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e4a:	4c 89 e0             	mov    %r12,%rax
  800e4d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e51:	0f b6 00             	movzbl (%rax),%eax
  800e54:	0f be d8             	movsbl %al,%ebx
  800e57:	85 db                	test   %ebx,%ebx
  800e59:	74 10                	je     800e6b <vprintfmt+0x524>
  800e5b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e5f:	78 b2                	js     800e13 <vprintfmt+0x4cc>
  800e61:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e65:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e69:	79 a8                	jns    800e13 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e6b:	eb 16                	jmp    800e83 <vprintfmt+0x53c>
				putch(' ', putdat);
  800e6d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e75:	48 89 d6             	mov    %rdx,%rsi
  800e78:	bf 20 00 00 00       	mov    $0x20,%edi
  800e7d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e7f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e83:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e87:	7f e4                	jg     800e6d <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800e89:	e9 b6 01 00 00       	jmpq   801044 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e8e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e92:	be 03 00 00 00       	mov    $0x3,%esi
  800e97:	48 89 c7             	mov    %rax,%rdi
  800e9a:	48 b8 37 08 80 00 00 	movabs $0x800837,%rax
  800ea1:	00 00 00 
  800ea4:	ff d0                	callq  *%rax
  800ea6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800eaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eae:	48 85 c0             	test   %rax,%rax
  800eb1:	79 1d                	jns    800ed0 <vprintfmt+0x589>
				putch('-', putdat);
  800eb3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ebb:	48 89 d6             	mov    %rdx,%rsi
  800ebe:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ec3:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec9:	48 f7 d8             	neg    %rax
  800ecc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ed0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ed7:	e9 fb 00 00 00       	jmpq   800fd7 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800edc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ee0:	be 03 00 00 00       	mov    $0x3,%esi
  800ee5:	48 89 c7             	mov    %rax,%rdi
  800ee8:	48 b8 27 07 80 00 00 	movabs $0x800727,%rax
  800eef:	00 00 00 
  800ef2:	ff d0                	callq  *%rax
  800ef4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ef8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800eff:	e9 d3 00 00 00       	jmpq   800fd7 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800f04:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f08:	be 03 00 00 00       	mov    $0x3,%esi
  800f0d:	48 89 c7             	mov    %rax,%rdi
  800f10:	48 b8 37 08 80 00 00 	movabs $0x800837,%rax
  800f17:	00 00 00 
  800f1a:	ff d0                	callq  *%rax
  800f1c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f24:	48 85 c0             	test   %rax,%rax
  800f27:	79 1d                	jns    800f46 <vprintfmt+0x5ff>
				putch('-', putdat);
  800f29:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f2d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f31:	48 89 d6             	mov    %rdx,%rsi
  800f34:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f39:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3f:	48 f7 d8             	neg    %rax
  800f42:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800f46:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f4d:	e9 85 00 00 00       	jmpq   800fd7 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800f52:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f5a:	48 89 d6             	mov    %rdx,%rsi
  800f5d:	bf 30 00 00 00       	mov    $0x30,%edi
  800f62:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f64:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f68:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f6c:	48 89 d6             	mov    %rdx,%rsi
  800f6f:	bf 78 00 00 00       	mov    $0x78,%edi
  800f74:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f76:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f79:	83 f8 30             	cmp    $0x30,%eax
  800f7c:	73 17                	jae    800f95 <vprintfmt+0x64e>
  800f7e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f82:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f85:	89 c0                	mov    %eax,%eax
  800f87:	48 01 d0             	add    %rdx,%rax
  800f8a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f8d:	83 c2 08             	add    $0x8,%edx
  800f90:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f93:	eb 0f                	jmp    800fa4 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800f95:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f99:	48 89 d0             	mov    %rdx,%rax
  800f9c:	48 83 c2 08          	add    $0x8,%rdx
  800fa0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800fa4:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fa7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800fab:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800fb2:	eb 23                	jmp    800fd7 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800fb4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fb8:	be 03 00 00 00       	mov    $0x3,%esi
  800fbd:	48 89 c7             	mov    %rax,%rdi
  800fc0:	48 b8 27 07 80 00 00 	movabs $0x800727,%rax
  800fc7:	00 00 00 
  800fca:	ff d0                	callq  *%rax
  800fcc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800fd0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fd7:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fdc:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fdf:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fe2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fe6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fee:	45 89 c1             	mov    %r8d,%r9d
  800ff1:	41 89 f8             	mov    %edi,%r8d
  800ff4:	48 89 c7             	mov    %rax,%rdi
  800ff7:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800ffe:	00 00 00 
  801001:	ff d0                	callq  *%rax
			break;
  801003:	eb 3f                	jmp    801044 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801005:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801009:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80100d:	48 89 d6             	mov    %rdx,%rsi
  801010:	89 df                	mov    %ebx,%edi
  801012:	ff d0                	callq  *%rax
			break;
  801014:	eb 2e                	jmp    801044 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801016:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80101a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80101e:	48 89 d6             	mov    %rdx,%rsi
  801021:	bf 25 00 00 00       	mov    $0x25,%edi
  801026:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801028:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80102d:	eb 05                	jmp    801034 <vprintfmt+0x6ed>
  80102f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801034:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801038:	48 83 e8 01          	sub    $0x1,%rax
  80103c:	0f b6 00             	movzbl (%rax),%eax
  80103f:	3c 25                	cmp    $0x25,%al
  801041:	75 ec                	jne    80102f <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  801043:	90                   	nop
		}
	}
  801044:	e9 37 f9 ff ff       	jmpq   800980 <vprintfmt+0x39>
    va_end(aq);
}
  801049:	48 83 c4 60          	add    $0x60,%rsp
  80104d:	5b                   	pop    %rbx
  80104e:	41 5c                	pop    %r12
  801050:	5d                   	pop    %rbp
  801051:	c3                   	retq   

0000000000801052 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801052:	55                   	push   %rbp
  801053:	48 89 e5             	mov    %rsp,%rbp
  801056:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80105d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801064:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80106b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801072:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801079:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801080:	84 c0                	test   %al,%al
  801082:	74 20                	je     8010a4 <printfmt+0x52>
  801084:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801088:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80108c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801090:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801094:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801098:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80109c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010a0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010a4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8010ab:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8010b2:	00 00 00 
  8010b5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8010bc:	00 00 00 
  8010bf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010c3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8010ca:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010d1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010d8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010df:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010e6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010ed:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010f4:	48 89 c7             	mov    %rax,%rdi
  8010f7:	48 b8 47 09 80 00 00 	movabs $0x800947,%rax
  8010fe:	00 00 00 
  801101:	ff d0                	callq  *%rax
	va_end(ap);
}
  801103:	c9                   	leaveq 
  801104:	c3                   	retq   

0000000000801105 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801105:	55                   	push   %rbp
  801106:	48 89 e5             	mov    %rsp,%rbp
  801109:	48 83 ec 10          	sub    $0x10,%rsp
  80110d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801110:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801114:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801118:	8b 40 10             	mov    0x10(%rax),%eax
  80111b:	8d 50 01             	lea    0x1(%rax),%edx
  80111e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801122:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801125:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801129:	48 8b 10             	mov    (%rax),%rdx
  80112c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801130:	48 8b 40 08          	mov    0x8(%rax),%rax
  801134:	48 39 c2             	cmp    %rax,%rdx
  801137:	73 17                	jae    801150 <sprintputch+0x4b>
		*b->buf++ = ch;
  801139:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80113d:	48 8b 00             	mov    (%rax),%rax
  801140:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801144:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801148:	48 89 0a             	mov    %rcx,(%rdx)
  80114b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80114e:	88 10                	mov    %dl,(%rax)
}
  801150:	c9                   	leaveq 
  801151:	c3                   	retq   

0000000000801152 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801152:	55                   	push   %rbp
  801153:	48 89 e5             	mov    %rsp,%rbp
  801156:	48 83 ec 50          	sub    $0x50,%rsp
  80115a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80115e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801161:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801165:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801169:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80116d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801171:	48 8b 0a             	mov    (%rdx),%rcx
  801174:	48 89 08             	mov    %rcx,(%rax)
  801177:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80117b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80117f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801183:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801187:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80118b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80118f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801192:	48 98                	cltq   
  801194:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801198:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80119c:	48 01 d0             	add    %rdx,%rax
  80119f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8011a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8011aa:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8011af:	74 06                	je     8011b7 <vsnprintf+0x65>
  8011b1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8011b5:	7f 07                	jg     8011be <vsnprintf+0x6c>
		return -E_INVAL;
  8011b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011bc:	eb 2f                	jmp    8011ed <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8011be:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8011c2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8011c6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8011ca:	48 89 c6             	mov    %rax,%rsi
  8011cd:	48 bf 05 11 80 00 00 	movabs $0x801105,%rdi
  8011d4:	00 00 00 
  8011d7:	48 b8 47 09 80 00 00 	movabs $0x800947,%rax
  8011de:	00 00 00 
  8011e1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011e7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011ea:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011ed:	c9                   	leaveq 
  8011ee:	c3                   	retq   

00000000008011ef <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011ef:	55                   	push   %rbp
  8011f0:	48 89 e5             	mov    %rsp,%rbp
  8011f3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011fa:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801201:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801207:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80120e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801215:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80121c:	84 c0                	test   %al,%al
  80121e:	74 20                	je     801240 <snprintf+0x51>
  801220:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801224:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801228:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80122c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801230:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801234:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801238:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80123c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801240:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801247:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80124e:	00 00 00 
  801251:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801258:	00 00 00 
  80125b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80125f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801266:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80126d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801274:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80127b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801282:	48 8b 0a             	mov    (%rdx),%rcx
  801285:	48 89 08             	mov    %rcx,(%rax)
  801288:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80128c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801290:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801294:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801298:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80129f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8012a6:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8012ac:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8012b3:	48 89 c7             	mov    %rax,%rdi
  8012b6:	48 b8 52 11 80 00 00 	movabs $0x801152,%rax
  8012bd:	00 00 00 
  8012c0:	ff d0                	callq  *%rax
  8012c2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8012c8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8012ce:	c9                   	leaveq 
  8012cf:	c3                   	retq   

00000000008012d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012d0:	55                   	push   %rbp
  8012d1:	48 89 e5             	mov    %rsp,%rbp
  8012d4:	48 83 ec 18          	sub    $0x18,%rsp
  8012d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8012dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012e3:	eb 09                	jmp    8012ee <strlen+0x1e>
		n++;
  8012e5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012e9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f2:	0f b6 00             	movzbl (%rax),%eax
  8012f5:	84 c0                	test   %al,%al
  8012f7:	75 ec                	jne    8012e5 <strlen+0x15>
		n++;
	return n;
  8012f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012fc:	c9                   	leaveq 
  8012fd:	c3                   	retq   

00000000008012fe <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012fe:	55                   	push   %rbp
  8012ff:	48 89 e5             	mov    %rsp,%rbp
  801302:	48 83 ec 20          	sub    $0x20,%rsp
  801306:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80130a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80130e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801315:	eb 0e                	jmp    801325 <strnlen+0x27>
		n++;
  801317:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80131b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801320:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801325:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80132a:	74 0b                	je     801337 <strnlen+0x39>
  80132c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801330:	0f b6 00             	movzbl (%rax),%eax
  801333:	84 c0                	test   %al,%al
  801335:	75 e0                	jne    801317 <strnlen+0x19>
		n++;
	return n;
  801337:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80133a:	c9                   	leaveq 
  80133b:	c3                   	retq   

000000000080133c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80133c:	55                   	push   %rbp
  80133d:	48 89 e5             	mov    %rsp,%rbp
  801340:	48 83 ec 20          	sub    $0x20,%rsp
  801344:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801348:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80134c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801350:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801354:	90                   	nop
  801355:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801359:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80135d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801361:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801365:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801369:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80136d:	0f b6 12             	movzbl (%rdx),%edx
  801370:	88 10                	mov    %dl,(%rax)
  801372:	0f b6 00             	movzbl (%rax),%eax
  801375:	84 c0                	test   %al,%al
  801377:	75 dc                	jne    801355 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801379:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80137d:	c9                   	leaveq 
  80137e:	c3                   	retq   

000000000080137f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80137f:	55                   	push   %rbp
  801380:	48 89 e5             	mov    %rsp,%rbp
  801383:	48 83 ec 20          	sub    $0x20,%rsp
  801387:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80138b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80138f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801393:	48 89 c7             	mov    %rax,%rdi
  801396:	48 b8 d0 12 80 00 00 	movabs $0x8012d0,%rax
  80139d:	00 00 00 
  8013a0:	ff d0                	callq  *%rax
  8013a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8013a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013a8:	48 63 d0             	movslq %eax,%rdx
  8013ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013af:	48 01 c2             	add    %rax,%rdx
  8013b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013b6:	48 89 c6             	mov    %rax,%rsi
  8013b9:	48 89 d7             	mov    %rdx,%rdi
  8013bc:	48 b8 3c 13 80 00 00 	movabs $0x80133c,%rax
  8013c3:	00 00 00 
  8013c6:	ff d0                	callq  *%rax
	return dst;
  8013c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013cc:	c9                   	leaveq 
  8013cd:	c3                   	retq   

00000000008013ce <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8013ce:	55                   	push   %rbp
  8013cf:	48 89 e5             	mov    %rsp,%rbp
  8013d2:	48 83 ec 28          	sub    $0x28,%rsp
  8013d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8013e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013ea:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013f1:	00 
  8013f2:	eb 2a                	jmp    80141e <strncpy+0x50>
		*dst++ = *src;
  8013f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801400:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801404:	0f b6 12             	movzbl (%rdx),%edx
  801407:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801409:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80140d:	0f b6 00             	movzbl (%rax),%eax
  801410:	84 c0                	test   %al,%al
  801412:	74 05                	je     801419 <strncpy+0x4b>
			src++;
  801414:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801419:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80141e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801422:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801426:	72 cc                	jb     8013f4 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801428:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80142c:	c9                   	leaveq 
  80142d:	c3                   	retq   

000000000080142e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80142e:	55                   	push   %rbp
  80142f:	48 89 e5             	mov    %rsp,%rbp
  801432:	48 83 ec 28          	sub    $0x28,%rsp
  801436:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80143a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80143e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801442:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801446:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80144a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80144f:	74 3d                	je     80148e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801451:	eb 1d                	jmp    801470 <strlcpy+0x42>
			*dst++ = *src++;
  801453:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801457:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80145b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80145f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801463:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801467:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80146b:	0f b6 12             	movzbl (%rdx),%edx
  80146e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801470:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801475:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80147a:	74 0b                	je     801487 <strlcpy+0x59>
  80147c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801480:	0f b6 00             	movzbl (%rax),%eax
  801483:	84 c0                	test   %al,%al
  801485:	75 cc                	jne    801453 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80148e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801492:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801496:	48 29 c2             	sub    %rax,%rdx
  801499:	48 89 d0             	mov    %rdx,%rax
}
  80149c:	c9                   	leaveq 
  80149d:	c3                   	retq   

000000000080149e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80149e:	55                   	push   %rbp
  80149f:	48 89 e5             	mov    %rsp,%rbp
  8014a2:	48 83 ec 10          	sub    $0x10,%rsp
  8014a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8014ae:	eb 0a                	jmp    8014ba <strcmp+0x1c>
		p++, q++;
  8014b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014be:	0f b6 00             	movzbl (%rax),%eax
  8014c1:	84 c0                	test   %al,%al
  8014c3:	74 12                	je     8014d7 <strcmp+0x39>
  8014c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c9:	0f b6 10             	movzbl (%rax),%edx
  8014cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d0:	0f b6 00             	movzbl (%rax),%eax
  8014d3:	38 c2                	cmp    %al,%dl
  8014d5:	74 d9                	je     8014b0 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014db:	0f b6 00             	movzbl (%rax),%eax
  8014de:	0f b6 d0             	movzbl %al,%edx
  8014e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e5:	0f b6 00             	movzbl (%rax),%eax
  8014e8:	0f b6 c0             	movzbl %al,%eax
  8014eb:	29 c2                	sub    %eax,%edx
  8014ed:	89 d0                	mov    %edx,%eax
}
  8014ef:	c9                   	leaveq 
  8014f0:	c3                   	retq   

00000000008014f1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014f1:	55                   	push   %rbp
  8014f2:	48 89 e5             	mov    %rsp,%rbp
  8014f5:	48 83 ec 18          	sub    $0x18,%rsp
  8014f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801501:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801505:	eb 0f                	jmp    801516 <strncmp+0x25>
		n--, p++, q++;
  801507:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80150c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801511:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801516:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80151b:	74 1d                	je     80153a <strncmp+0x49>
  80151d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801521:	0f b6 00             	movzbl (%rax),%eax
  801524:	84 c0                	test   %al,%al
  801526:	74 12                	je     80153a <strncmp+0x49>
  801528:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152c:	0f b6 10             	movzbl (%rax),%edx
  80152f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801533:	0f b6 00             	movzbl (%rax),%eax
  801536:	38 c2                	cmp    %al,%dl
  801538:	74 cd                	je     801507 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80153a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80153f:	75 07                	jne    801548 <strncmp+0x57>
		return 0;
  801541:	b8 00 00 00 00       	mov    $0x0,%eax
  801546:	eb 18                	jmp    801560 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801548:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154c:	0f b6 00             	movzbl (%rax),%eax
  80154f:	0f b6 d0             	movzbl %al,%edx
  801552:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801556:	0f b6 00             	movzbl (%rax),%eax
  801559:	0f b6 c0             	movzbl %al,%eax
  80155c:	29 c2                	sub    %eax,%edx
  80155e:	89 d0                	mov    %edx,%eax
}
  801560:	c9                   	leaveq 
  801561:	c3                   	retq   

0000000000801562 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801562:	55                   	push   %rbp
  801563:	48 89 e5             	mov    %rsp,%rbp
  801566:	48 83 ec 0c          	sub    $0xc,%rsp
  80156a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80156e:	89 f0                	mov    %esi,%eax
  801570:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801573:	eb 17                	jmp    80158c <strchr+0x2a>
		if (*s == c)
  801575:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801579:	0f b6 00             	movzbl (%rax),%eax
  80157c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80157f:	75 06                	jne    801587 <strchr+0x25>
			return (char *) s;
  801581:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801585:	eb 15                	jmp    80159c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801587:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80158c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801590:	0f b6 00             	movzbl (%rax),%eax
  801593:	84 c0                	test   %al,%al
  801595:	75 de                	jne    801575 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801597:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159c:	c9                   	leaveq 
  80159d:	c3                   	retq   

000000000080159e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80159e:	55                   	push   %rbp
  80159f:	48 89 e5             	mov    %rsp,%rbp
  8015a2:	48 83 ec 0c          	sub    $0xc,%rsp
  8015a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015aa:	89 f0                	mov    %esi,%eax
  8015ac:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015af:	eb 13                	jmp    8015c4 <strfind+0x26>
		if (*s == c)
  8015b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b5:	0f b6 00             	movzbl (%rax),%eax
  8015b8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015bb:	75 02                	jne    8015bf <strfind+0x21>
			break;
  8015bd:	eb 10                	jmp    8015cf <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015bf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c8:	0f b6 00             	movzbl (%rax),%eax
  8015cb:	84 c0                	test   %al,%al
  8015cd:	75 e2                	jne    8015b1 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8015cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015d3:	c9                   	leaveq 
  8015d4:	c3                   	retq   

00000000008015d5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8015d5:	55                   	push   %rbp
  8015d6:	48 89 e5             	mov    %rsp,%rbp
  8015d9:	48 83 ec 18          	sub    $0x18,%rsp
  8015dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015e1:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8015e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015ed:	75 06                	jne    8015f5 <memset+0x20>
		return v;
  8015ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f3:	eb 69                	jmp    80165e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f9:	83 e0 03             	and    $0x3,%eax
  8015fc:	48 85 c0             	test   %rax,%rax
  8015ff:	75 48                	jne    801649 <memset+0x74>
  801601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801605:	83 e0 03             	and    $0x3,%eax
  801608:	48 85 c0             	test   %rax,%rax
  80160b:	75 3c                	jne    801649 <memset+0x74>
		c &= 0xFF;
  80160d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801614:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801617:	c1 e0 18             	shl    $0x18,%eax
  80161a:	89 c2                	mov    %eax,%edx
  80161c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80161f:	c1 e0 10             	shl    $0x10,%eax
  801622:	09 c2                	or     %eax,%edx
  801624:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801627:	c1 e0 08             	shl    $0x8,%eax
  80162a:	09 d0                	or     %edx,%eax
  80162c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80162f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801633:	48 c1 e8 02          	shr    $0x2,%rax
  801637:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80163a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80163e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801641:	48 89 d7             	mov    %rdx,%rdi
  801644:	fc                   	cld    
  801645:	f3 ab                	rep stos %eax,%es:(%rdi)
  801647:	eb 11                	jmp    80165a <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801649:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80164d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801650:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801654:	48 89 d7             	mov    %rdx,%rdi
  801657:	fc                   	cld    
  801658:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80165a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80165e:	c9                   	leaveq 
  80165f:	c3                   	retq   

0000000000801660 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801660:	55                   	push   %rbp
  801661:	48 89 e5             	mov    %rsp,%rbp
  801664:	48 83 ec 28          	sub    $0x28,%rsp
  801668:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80166c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801670:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801674:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801678:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80167c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801680:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801684:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801688:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80168c:	0f 83 88 00 00 00    	jae    80171a <memmove+0xba>
  801692:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801696:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80169a:	48 01 d0             	add    %rdx,%rax
  80169d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016a1:	76 77                	jbe    80171a <memmove+0xba>
		s += n;
  8016a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8016ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016af:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b7:	83 e0 03             	and    $0x3,%eax
  8016ba:	48 85 c0             	test   %rax,%rax
  8016bd:	75 3b                	jne    8016fa <memmove+0x9a>
  8016bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c3:	83 e0 03             	and    $0x3,%eax
  8016c6:	48 85 c0             	test   %rax,%rax
  8016c9:	75 2f                	jne    8016fa <memmove+0x9a>
  8016cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cf:	83 e0 03             	and    $0x3,%eax
  8016d2:	48 85 c0             	test   %rax,%rax
  8016d5:	75 23                	jne    8016fa <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8016d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016db:	48 83 e8 04          	sub    $0x4,%rax
  8016df:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016e3:	48 83 ea 04          	sub    $0x4,%rdx
  8016e7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016eb:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016ef:	48 89 c7             	mov    %rax,%rdi
  8016f2:	48 89 d6             	mov    %rdx,%rsi
  8016f5:	fd                   	std    
  8016f6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016f8:	eb 1d                	jmp    801717 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016fe:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801702:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801706:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80170a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170e:	48 89 d7             	mov    %rdx,%rdi
  801711:	48 89 c1             	mov    %rax,%rcx
  801714:	fd                   	std    
  801715:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801717:	fc                   	cld    
  801718:	eb 57                	jmp    801771 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80171a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80171e:	83 e0 03             	and    $0x3,%eax
  801721:	48 85 c0             	test   %rax,%rax
  801724:	75 36                	jne    80175c <memmove+0xfc>
  801726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172a:	83 e0 03             	and    $0x3,%eax
  80172d:	48 85 c0             	test   %rax,%rax
  801730:	75 2a                	jne    80175c <memmove+0xfc>
  801732:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801736:	83 e0 03             	and    $0x3,%eax
  801739:	48 85 c0             	test   %rax,%rax
  80173c:	75 1e                	jne    80175c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80173e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801742:	48 c1 e8 02          	shr    $0x2,%rax
  801746:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801749:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80174d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801751:	48 89 c7             	mov    %rax,%rdi
  801754:	48 89 d6             	mov    %rdx,%rsi
  801757:	fc                   	cld    
  801758:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80175a:	eb 15                	jmp    801771 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80175c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801760:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801764:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801768:	48 89 c7             	mov    %rax,%rdi
  80176b:	48 89 d6             	mov    %rdx,%rsi
  80176e:	fc                   	cld    
  80176f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801771:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801775:	c9                   	leaveq 
  801776:	c3                   	retq   

0000000000801777 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801777:	55                   	push   %rbp
  801778:	48 89 e5             	mov    %rsp,%rbp
  80177b:	48 83 ec 18          	sub    $0x18,%rsp
  80177f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801783:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801787:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80178b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80178f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801793:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801797:	48 89 ce             	mov    %rcx,%rsi
  80179a:	48 89 c7             	mov    %rax,%rdi
  80179d:	48 b8 60 16 80 00 00 	movabs $0x801660,%rax
  8017a4:	00 00 00 
  8017a7:	ff d0                	callq  *%rax
}
  8017a9:	c9                   	leaveq 
  8017aa:	c3                   	retq   

00000000008017ab <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8017ab:	55                   	push   %rbp
  8017ac:	48 89 e5             	mov    %rsp,%rbp
  8017af:	48 83 ec 28          	sub    $0x28,%rsp
  8017b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8017bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8017c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8017cf:	eb 36                	jmp    801807 <memcmp+0x5c>
		if (*s1 != *s2)
  8017d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017d5:	0f b6 10             	movzbl (%rax),%edx
  8017d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017dc:	0f b6 00             	movzbl (%rax),%eax
  8017df:	38 c2                	cmp    %al,%dl
  8017e1:	74 1a                	je     8017fd <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8017e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017e7:	0f b6 00             	movzbl (%rax),%eax
  8017ea:	0f b6 d0             	movzbl %al,%edx
  8017ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017f1:	0f b6 00             	movzbl (%rax),%eax
  8017f4:	0f b6 c0             	movzbl %al,%eax
  8017f7:	29 c2                	sub    %eax,%edx
  8017f9:	89 d0                	mov    %edx,%eax
  8017fb:	eb 20                	jmp    80181d <memcmp+0x72>
		s1++, s2++;
  8017fd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801802:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801807:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80180f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801813:	48 85 c0             	test   %rax,%rax
  801816:	75 b9                	jne    8017d1 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801818:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181d:	c9                   	leaveq 
  80181e:	c3                   	retq   

000000000080181f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80181f:	55                   	push   %rbp
  801820:	48 89 e5             	mov    %rsp,%rbp
  801823:	48 83 ec 28          	sub    $0x28,%rsp
  801827:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80182b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80182e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801832:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801836:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80183a:	48 01 d0             	add    %rdx,%rax
  80183d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801841:	eb 15                	jmp    801858 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801843:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801847:	0f b6 10             	movzbl (%rax),%edx
  80184a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80184d:	38 c2                	cmp    %al,%dl
  80184f:	75 02                	jne    801853 <memfind+0x34>
			break;
  801851:	eb 0f                	jmp    801862 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801853:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801858:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80185c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801860:	72 e1                	jb     801843 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801862:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801866:	c9                   	leaveq 
  801867:	c3                   	retq   

0000000000801868 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801868:	55                   	push   %rbp
  801869:	48 89 e5             	mov    %rsp,%rbp
  80186c:	48 83 ec 34          	sub    $0x34,%rsp
  801870:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801874:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801878:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80187b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801882:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801889:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80188a:	eb 05                	jmp    801891 <strtol+0x29>
		s++;
  80188c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801891:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801895:	0f b6 00             	movzbl (%rax),%eax
  801898:	3c 20                	cmp    $0x20,%al
  80189a:	74 f0                	je     80188c <strtol+0x24>
  80189c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a0:	0f b6 00             	movzbl (%rax),%eax
  8018a3:	3c 09                	cmp    $0x9,%al
  8018a5:	74 e5                	je     80188c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ab:	0f b6 00             	movzbl (%rax),%eax
  8018ae:	3c 2b                	cmp    $0x2b,%al
  8018b0:	75 07                	jne    8018b9 <strtol+0x51>
		s++;
  8018b2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018b7:	eb 17                	jmp    8018d0 <strtol+0x68>
	else if (*s == '-')
  8018b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018bd:	0f b6 00             	movzbl (%rax),%eax
  8018c0:	3c 2d                	cmp    $0x2d,%al
  8018c2:	75 0c                	jne    8018d0 <strtol+0x68>
		s++, neg = 1;
  8018c4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018c9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018d0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018d4:	74 06                	je     8018dc <strtol+0x74>
  8018d6:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8018da:	75 28                	jne    801904 <strtol+0x9c>
  8018dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e0:	0f b6 00             	movzbl (%rax),%eax
  8018e3:	3c 30                	cmp    $0x30,%al
  8018e5:	75 1d                	jne    801904 <strtol+0x9c>
  8018e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018eb:	48 83 c0 01          	add    $0x1,%rax
  8018ef:	0f b6 00             	movzbl (%rax),%eax
  8018f2:	3c 78                	cmp    $0x78,%al
  8018f4:	75 0e                	jne    801904 <strtol+0x9c>
		s += 2, base = 16;
  8018f6:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018fb:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801902:	eb 2c                	jmp    801930 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801904:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801908:	75 19                	jne    801923 <strtol+0xbb>
  80190a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190e:	0f b6 00             	movzbl (%rax),%eax
  801911:	3c 30                	cmp    $0x30,%al
  801913:	75 0e                	jne    801923 <strtol+0xbb>
		s++, base = 8;
  801915:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80191a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801921:	eb 0d                	jmp    801930 <strtol+0xc8>
	else if (base == 0)
  801923:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801927:	75 07                	jne    801930 <strtol+0xc8>
		base = 10;
  801929:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801934:	0f b6 00             	movzbl (%rax),%eax
  801937:	3c 2f                	cmp    $0x2f,%al
  801939:	7e 1d                	jle    801958 <strtol+0xf0>
  80193b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193f:	0f b6 00             	movzbl (%rax),%eax
  801942:	3c 39                	cmp    $0x39,%al
  801944:	7f 12                	jg     801958 <strtol+0xf0>
			dig = *s - '0';
  801946:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194a:	0f b6 00             	movzbl (%rax),%eax
  80194d:	0f be c0             	movsbl %al,%eax
  801950:	83 e8 30             	sub    $0x30,%eax
  801953:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801956:	eb 4e                	jmp    8019a6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801958:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195c:	0f b6 00             	movzbl (%rax),%eax
  80195f:	3c 60                	cmp    $0x60,%al
  801961:	7e 1d                	jle    801980 <strtol+0x118>
  801963:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801967:	0f b6 00             	movzbl (%rax),%eax
  80196a:	3c 7a                	cmp    $0x7a,%al
  80196c:	7f 12                	jg     801980 <strtol+0x118>
			dig = *s - 'a' + 10;
  80196e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801972:	0f b6 00             	movzbl (%rax),%eax
  801975:	0f be c0             	movsbl %al,%eax
  801978:	83 e8 57             	sub    $0x57,%eax
  80197b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80197e:	eb 26                	jmp    8019a6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801980:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801984:	0f b6 00             	movzbl (%rax),%eax
  801987:	3c 40                	cmp    $0x40,%al
  801989:	7e 48                	jle    8019d3 <strtol+0x16b>
  80198b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80198f:	0f b6 00             	movzbl (%rax),%eax
  801992:	3c 5a                	cmp    $0x5a,%al
  801994:	7f 3d                	jg     8019d3 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801996:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199a:	0f b6 00             	movzbl (%rax),%eax
  80199d:	0f be c0             	movsbl %al,%eax
  8019a0:	83 e8 37             	sub    $0x37,%eax
  8019a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8019a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019a9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8019ac:	7c 02                	jl     8019b0 <strtol+0x148>
			break;
  8019ae:	eb 23                	jmp    8019d3 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8019b0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019b5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8019b8:	48 98                	cltq   
  8019ba:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8019bf:	48 89 c2             	mov    %rax,%rdx
  8019c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019c5:	48 98                	cltq   
  8019c7:	48 01 d0             	add    %rdx,%rax
  8019ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8019ce:	e9 5d ff ff ff       	jmpq   801930 <strtol+0xc8>

	if (endptr)
  8019d3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8019d8:	74 0b                	je     8019e5 <strtol+0x17d>
		*endptr = (char *) s;
  8019da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019de:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019e2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019e9:	74 09                	je     8019f4 <strtol+0x18c>
  8019eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019ef:	48 f7 d8             	neg    %rax
  8019f2:	eb 04                	jmp    8019f8 <strtol+0x190>
  8019f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019f8:	c9                   	leaveq 
  8019f9:	c3                   	retq   

00000000008019fa <strstr>:

char * strstr(const char *in, const char *str)
{
  8019fa:	55                   	push   %rbp
  8019fb:	48 89 e5             	mov    %rsp,%rbp
  8019fe:	48 83 ec 30          	sub    $0x30,%rsp
  801a02:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a06:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801a0a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a0e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a12:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a16:	0f b6 00             	movzbl (%rax),%eax
  801a19:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801a1c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801a20:	75 06                	jne    801a28 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801a22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a26:	eb 6b                	jmp    801a93 <strstr+0x99>

    len = strlen(str);
  801a28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a2c:	48 89 c7             	mov    %rax,%rdi
  801a2f:	48 b8 d0 12 80 00 00 	movabs $0x8012d0,%rax
  801a36:	00 00 00 
  801a39:	ff d0                	callq  *%rax
  801a3b:	48 98                	cltq   
  801a3d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801a41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a45:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a49:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a4d:	0f b6 00             	movzbl (%rax),%eax
  801a50:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801a53:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a57:	75 07                	jne    801a60 <strstr+0x66>
                return (char *) 0;
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5e:	eb 33                	jmp    801a93 <strstr+0x99>
        } while (sc != c);
  801a60:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a64:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a67:	75 d8                	jne    801a41 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801a69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a6d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a75:	48 89 ce             	mov    %rcx,%rsi
  801a78:	48 89 c7             	mov    %rax,%rdi
  801a7b:	48 b8 f1 14 80 00 00 	movabs $0x8014f1,%rax
  801a82:	00 00 00 
  801a85:	ff d0                	callq  *%rax
  801a87:	85 c0                	test   %eax,%eax
  801a89:	75 b6                	jne    801a41 <strstr+0x47>

    return (char *) (in - 1);
  801a8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a8f:	48 83 e8 01          	sub    $0x1,%rax
}
  801a93:	c9                   	leaveq 
  801a94:	c3                   	retq   

0000000000801a95 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801a95:	55                   	push   %rbp
  801a96:	48 89 e5             	mov    %rsp,%rbp
  801a99:	53                   	push   %rbx
  801a9a:	48 83 ec 48          	sub    $0x48,%rsp
  801a9e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801aa1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801aa4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801aa8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801aac:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801ab0:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ab4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ab7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801abb:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801abf:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801ac3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801ac7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801acb:	4c 89 c3             	mov    %r8,%rbx
  801ace:	cd 30                	int    $0x30
  801ad0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801ad4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801ad8:	74 3e                	je     801b18 <syscall+0x83>
  801ada:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801adf:	7e 37                	jle    801b18 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801ae1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ae5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ae8:	49 89 d0             	mov    %rdx,%r8
  801aeb:	89 c1                	mov    %eax,%ecx
  801aed:	48 ba 80 4f 80 00 00 	movabs $0x804f80,%rdx
  801af4:	00 00 00 
  801af7:	be 23 00 00 00       	mov    $0x23,%esi
  801afc:	48 bf 9d 4f 80 00 00 	movabs $0x804f9d,%rdi
  801b03:	00 00 00 
  801b06:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0b:	49 b9 5b 03 80 00 00 	movabs $0x80035b,%r9
  801b12:	00 00 00 
  801b15:	41 ff d1             	callq  *%r9

	return ret;
  801b18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b1c:	48 83 c4 48          	add    $0x48,%rsp
  801b20:	5b                   	pop    %rbx
  801b21:	5d                   	pop    %rbp
  801b22:	c3                   	retq   

0000000000801b23 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801b23:	55                   	push   %rbp
  801b24:	48 89 e5             	mov    %rsp,%rbp
  801b27:	48 83 ec 20          	sub    $0x20,%rsp
  801b2b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b2f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801b33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b3b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b42:	00 
  801b43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b4f:	48 89 d1             	mov    %rdx,%rcx
  801b52:	48 89 c2             	mov    %rax,%rdx
  801b55:	be 00 00 00 00       	mov    $0x0,%esi
  801b5a:	bf 00 00 00 00       	mov    $0x0,%edi
  801b5f:	48 b8 95 1a 80 00 00 	movabs $0x801a95,%rax
  801b66:	00 00 00 
  801b69:	ff d0                	callq  *%rax
}
  801b6b:	c9                   	leaveq 
  801b6c:	c3                   	retq   

0000000000801b6d <sys_cgetc>:

int
sys_cgetc(void)
{
  801b6d:	55                   	push   %rbp
  801b6e:	48 89 e5             	mov    %rsp,%rbp
  801b71:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801b75:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b7c:	00 
  801b7d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b83:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b89:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b93:	be 00 00 00 00       	mov    $0x0,%esi
  801b98:	bf 01 00 00 00       	mov    $0x1,%edi
  801b9d:	48 b8 95 1a 80 00 00 	movabs $0x801a95,%rax
  801ba4:	00 00 00 
  801ba7:	ff d0                	callq  *%rax
}
  801ba9:	c9                   	leaveq 
  801baa:	c3                   	retq   

0000000000801bab <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801bab:	55                   	push   %rbp
  801bac:	48 89 e5             	mov    %rsp,%rbp
  801baf:	48 83 ec 10          	sub    $0x10,%rsp
  801bb3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801bb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb9:	48 98                	cltq   
  801bbb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc2:	00 
  801bc3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bcf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bd4:	48 89 c2             	mov    %rax,%rdx
  801bd7:	be 01 00 00 00       	mov    $0x1,%esi
  801bdc:	bf 03 00 00 00       	mov    $0x3,%edi
  801be1:	48 b8 95 1a 80 00 00 	movabs $0x801a95,%rax
  801be8:	00 00 00 
  801beb:	ff d0                	callq  *%rax
}
  801bed:	c9                   	leaveq 
  801bee:	c3                   	retq   

0000000000801bef <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801bef:	55                   	push   %rbp
  801bf0:	48 89 e5             	mov    %rsp,%rbp
  801bf3:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801bf7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bfe:	00 
  801bff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c0b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c10:	ba 00 00 00 00       	mov    $0x0,%edx
  801c15:	be 00 00 00 00       	mov    $0x0,%esi
  801c1a:	bf 02 00 00 00       	mov    $0x2,%edi
  801c1f:	48 b8 95 1a 80 00 00 	movabs $0x801a95,%rax
  801c26:	00 00 00 
  801c29:	ff d0                	callq  *%rax
}
  801c2b:	c9                   	leaveq 
  801c2c:	c3                   	retq   

0000000000801c2d <sys_yield>:

void
sys_yield(void)
{
  801c2d:	55                   	push   %rbp
  801c2e:	48 89 e5             	mov    %rsp,%rbp
  801c31:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801c35:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c3c:	00 
  801c3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c49:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c53:	be 00 00 00 00       	mov    $0x0,%esi
  801c58:	bf 0b 00 00 00       	mov    $0xb,%edi
  801c5d:	48 b8 95 1a 80 00 00 	movabs $0x801a95,%rax
  801c64:	00 00 00 
  801c67:	ff d0                	callq  *%rax
}
  801c69:	c9                   	leaveq 
  801c6a:	c3                   	retq   

0000000000801c6b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801c6b:	55                   	push   %rbp
  801c6c:	48 89 e5             	mov    %rsp,%rbp
  801c6f:	48 83 ec 20          	sub    $0x20,%rsp
  801c73:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c76:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c7a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801c7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c80:	48 63 c8             	movslq %eax,%rcx
  801c83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c8a:	48 98                	cltq   
  801c8c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c93:	00 
  801c94:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c9a:	49 89 c8             	mov    %rcx,%r8
  801c9d:	48 89 d1             	mov    %rdx,%rcx
  801ca0:	48 89 c2             	mov    %rax,%rdx
  801ca3:	be 01 00 00 00       	mov    $0x1,%esi
  801ca8:	bf 04 00 00 00       	mov    $0x4,%edi
  801cad:	48 b8 95 1a 80 00 00 	movabs $0x801a95,%rax
  801cb4:	00 00 00 
  801cb7:	ff d0                	callq  *%rax
}
  801cb9:	c9                   	leaveq 
  801cba:	c3                   	retq   

0000000000801cbb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801cbb:	55                   	push   %rbp
  801cbc:	48 89 e5             	mov    %rsp,%rbp
  801cbf:	48 83 ec 30          	sub    $0x30,%rsp
  801cc3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cc6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cca:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ccd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801cd1:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801cd5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801cd8:	48 63 c8             	movslq %eax,%rcx
  801cdb:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801cdf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ce2:	48 63 f0             	movslq %eax,%rsi
  801ce5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cec:	48 98                	cltq   
  801cee:	48 89 0c 24          	mov    %rcx,(%rsp)
  801cf2:	49 89 f9             	mov    %rdi,%r9
  801cf5:	49 89 f0             	mov    %rsi,%r8
  801cf8:	48 89 d1             	mov    %rdx,%rcx
  801cfb:	48 89 c2             	mov    %rax,%rdx
  801cfe:	be 01 00 00 00       	mov    $0x1,%esi
  801d03:	bf 05 00 00 00       	mov    $0x5,%edi
  801d08:	48 b8 95 1a 80 00 00 	movabs $0x801a95,%rax
  801d0f:	00 00 00 
  801d12:	ff d0                	callq  *%rax
}
  801d14:	c9                   	leaveq 
  801d15:	c3                   	retq   

0000000000801d16 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801d16:	55                   	push   %rbp
  801d17:	48 89 e5             	mov    %rsp,%rbp
  801d1a:	48 83 ec 20          	sub    $0x20,%rsp
  801d1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801d25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d2c:	48 98                	cltq   
  801d2e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d35:	00 
  801d36:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d3c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d42:	48 89 d1             	mov    %rdx,%rcx
  801d45:	48 89 c2             	mov    %rax,%rdx
  801d48:	be 01 00 00 00       	mov    $0x1,%esi
  801d4d:	bf 06 00 00 00       	mov    $0x6,%edi
  801d52:	48 b8 95 1a 80 00 00 	movabs $0x801a95,%rax
  801d59:	00 00 00 
  801d5c:	ff d0                	callq  *%rax
}
  801d5e:	c9                   	leaveq 
  801d5f:	c3                   	retq   

0000000000801d60 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801d60:	55                   	push   %rbp
  801d61:	48 89 e5             	mov    %rsp,%rbp
  801d64:	48 83 ec 10          	sub    $0x10,%rsp
  801d68:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d6b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801d6e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d71:	48 63 d0             	movslq %eax,%rdx
  801d74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d77:	48 98                	cltq   
  801d79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d80:	00 
  801d81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d8d:	48 89 d1             	mov    %rdx,%rcx
  801d90:	48 89 c2             	mov    %rax,%rdx
  801d93:	be 01 00 00 00       	mov    $0x1,%esi
  801d98:	bf 08 00 00 00       	mov    $0x8,%edi
  801d9d:	48 b8 95 1a 80 00 00 	movabs $0x801a95,%rax
  801da4:	00 00 00 
  801da7:	ff d0                	callq  *%rax
}
  801da9:	c9                   	leaveq 
  801daa:	c3                   	retq   

0000000000801dab <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801dab:	55                   	push   %rbp
  801dac:	48 89 e5             	mov    %rsp,%rbp
  801daf:	48 83 ec 20          	sub    $0x20,%rsp
  801db3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801db6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801dba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc1:	48 98                	cltq   
  801dc3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dca:	00 
  801dcb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dd1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd7:	48 89 d1             	mov    %rdx,%rcx
  801dda:	48 89 c2             	mov    %rax,%rdx
  801ddd:	be 01 00 00 00       	mov    $0x1,%esi
  801de2:	bf 09 00 00 00       	mov    $0x9,%edi
  801de7:	48 b8 95 1a 80 00 00 	movabs $0x801a95,%rax
  801dee:	00 00 00 
  801df1:	ff d0                	callq  *%rax
}
  801df3:	c9                   	leaveq 
  801df4:	c3                   	retq   

0000000000801df5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801df5:	55                   	push   %rbp
  801df6:	48 89 e5             	mov    %rsp,%rbp
  801df9:	48 83 ec 20          	sub    $0x20,%rsp
  801dfd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801e04:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e0b:	48 98                	cltq   
  801e0d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e14:	00 
  801e15:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e21:	48 89 d1             	mov    %rdx,%rcx
  801e24:	48 89 c2             	mov    %rax,%rdx
  801e27:	be 01 00 00 00       	mov    $0x1,%esi
  801e2c:	bf 0a 00 00 00       	mov    $0xa,%edi
  801e31:	48 b8 95 1a 80 00 00 	movabs $0x801a95,%rax
  801e38:	00 00 00 
  801e3b:	ff d0                	callq  *%rax
}
  801e3d:	c9                   	leaveq 
  801e3e:	c3                   	retq   

0000000000801e3f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801e3f:	55                   	push   %rbp
  801e40:	48 89 e5             	mov    %rsp,%rbp
  801e43:	48 83 ec 20          	sub    $0x20,%rsp
  801e47:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e4e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801e52:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801e55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e58:	48 63 f0             	movslq %eax,%rsi
  801e5b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e62:	48 98                	cltq   
  801e64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e68:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e6f:	00 
  801e70:	49 89 f1             	mov    %rsi,%r9
  801e73:	49 89 c8             	mov    %rcx,%r8
  801e76:	48 89 d1             	mov    %rdx,%rcx
  801e79:	48 89 c2             	mov    %rax,%rdx
  801e7c:	be 00 00 00 00       	mov    $0x0,%esi
  801e81:	bf 0c 00 00 00       	mov    $0xc,%edi
  801e86:	48 b8 95 1a 80 00 00 	movabs $0x801a95,%rax
  801e8d:	00 00 00 
  801e90:	ff d0                	callq  *%rax
}
  801e92:	c9                   	leaveq 
  801e93:	c3                   	retq   

0000000000801e94 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801e94:	55                   	push   %rbp
  801e95:	48 89 e5             	mov    %rsp,%rbp
  801e98:	48 83 ec 10          	sub    $0x10,%rsp
  801e9c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ea0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eab:	00 
  801eac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eb2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eb8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ebd:	48 89 c2             	mov    %rax,%rdx
  801ec0:	be 01 00 00 00       	mov    $0x1,%esi
  801ec5:	bf 0d 00 00 00       	mov    $0xd,%edi
  801eca:	48 b8 95 1a 80 00 00 	movabs $0x801a95,%rax
  801ed1:	00 00 00 
  801ed4:	ff d0                	callq  *%rax
}
  801ed6:	c9                   	leaveq 
  801ed7:	c3                   	retq   

0000000000801ed8 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801ed8:	55                   	push   %rbp
  801ed9:	48 89 e5             	mov    %rsp,%rbp
  801edc:	48 83 ec 30          	sub    $0x30,%rsp
  801ee0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801ee4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee8:	48 8b 00             	mov    (%rax),%rax
  801eeb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801eef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef3:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ef7:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)))
  801efa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801efd:	83 e0 02             	and    $0x2,%eax
  801f00:	85 c0                	test   %eax,%eax
  801f02:	74 23                	je     801f27 <pgfault+0x4f>
  801f04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f08:	48 c1 e8 0c          	shr    $0xc,%rax
  801f0c:	48 89 c2             	mov    %rax,%rdx
  801f0f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f16:	01 00 00 
  801f19:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f1d:	25 00 08 00 00       	and    $0x800,%eax
  801f22:	48 85 c0             	test   %rax,%rax
  801f25:	75 2a                	jne    801f51 <pgfault+0x79>
		panic("fail check at fork pgfault");
  801f27:	48 ba ab 4f 80 00 00 	movabs $0x804fab,%rdx
  801f2e:	00 00 00 
  801f31:	be 1d 00 00 00       	mov    $0x1d,%esi
  801f36:	48 bf c6 4f 80 00 00 	movabs $0x804fc6,%rdi
  801f3d:	00 00 00 
  801f40:	b8 00 00 00 00       	mov    $0x0,%eax
  801f45:	48 b9 5b 03 80 00 00 	movabs $0x80035b,%rcx
  801f4c:	00 00 00 
  801f4f:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801f51:	ba 07 00 00 00       	mov    $0x7,%edx
  801f56:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f5b:	bf 00 00 00 00       	mov    $0x0,%edi
  801f60:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  801f67:	00 00 00 
  801f6a:	ff d0                	callq  *%rax

	addr = ROUNDDOWN(addr, PGSIZE);
  801f6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f70:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801f74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f78:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801f7e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memmove(PFTEMP, addr, PGSIZE);
  801f82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f86:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f8b:	48 89 c6             	mov    %rax,%rsi
  801f8e:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801f93:	48 b8 60 16 80 00 00 	movabs $0x801660,%rax
  801f9a:	00 00 00 
  801f9d:	ff d0                	callq  *%rax

	sys_page_map(0, (void *)PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W);
  801f9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fa3:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801fa9:	48 89 c1             	mov    %rax,%rcx
  801fac:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fb6:	bf 00 00 00 00       	mov    $0x0,%edi
  801fbb:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  801fc2:	00 00 00 
  801fc5:	ff d0                	callq  *%rax
	sys_page_unmap(0, PFTEMP);
  801fc7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fcc:	bf 00 00 00 00       	mov    $0x0,%edi
  801fd1:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  801fd8:	00 00 00 
  801fdb:	ff d0                	callq  *%rax
	//panic("pgfault not implemented");
}
  801fdd:	c9                   	leaveq 
  801fde:	c3                   	retq   

0000000000801fdf <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801fdf:	55                   	push   %rbp
  801fe0:	48 89 e5             	mov    %rsp,%rbp
  801fe3:	48 83 ec 20          	sub    $0x20,%rsp
  801fe7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fea:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uintptr_t)pn * PGSIZE);
  801fed:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801ff0:	48 c1 e0 0c          	shl    $0xc,%rax
  801ff4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	// note: modified for LAB 5, supporting PTE_SHARE
	if (uvpt[pn] & PTE_SHARE) {
  801ff8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fff:	01 00 00 
  802002:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802005:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802009:	25 00 04 00 00       	and    $0x400,%eax
  80200e:	48 85 c0             	test   %rax,%rax
  802011:	74 55                	je     802068 <duppage+0x89>
		if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL))) < 0)
  802013:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80201a:	01 00 00 
  80201d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802020:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802024:	25 07 0e 00 00       	and    $0xe07,%eax
  802029:	89 c6                	mov    %eax,%esi
  80202b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80202f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802032:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802036:	41 89 f0             	mov    %esi,%r8d
  802039:	48 89 c6             	mov    %rax,%rsi
  80203c:	bf 00 00 00 00       	mov    $0x0,%edi
  802041:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  802048:	00 00 00 
  80204b:	ff d0                	callq  *%rax
  80204d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802050:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802054:	79 08                	jns    80205e <duppage+0x7f>
			return r;
  802056:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802059:	e9 e1 00 00 00       	jmpq   80213f <duppage+0x160>
		return 0;
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
  802063:	e9 d7 00 00 00       	jmpq   80213f <duppage+0x160>
	}

	// note: here we must set ~PTE_W and PTE_COW such that parent process can get correct pid
	if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  802068:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80206f:	01 00 00 
  802072:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802075:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802079:	25 05 06 00 00       	and    $0x605,%eax
  80207e:	80 cc 08             	or     $0x8,%ah
  802081:	89 c6                	mov    %eax,%esi
  802083:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802087:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80208a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80208e:	41 89 f0             	mov    %esi,%r8d
  802091:	48 89 c6             	mov    %rax,%rsi
  802094:	bf 00 00 00 00       	mov    $0x0,%edi
  802099:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  8020a0:	00 00 00 
  8020a3:	ff d0                	callq  *%rax
  8020a5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8020a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8020ac:	79 08                	jns    8020b6 <duppage+0xd7>
		return r;
  8020ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020b1:	e9 89 00 00 00       	jmpq   80213f <duppage+0x160>

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  8020b6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020bd:	01 00 00 
  8020c0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8020c3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020c7:	83 e0 02             	and    $0x2,%eax
  8020ca:	48 85 c0             	test   %rax,%rax
  8020cd:	75 1b                	jne    8020ea <duppage+0x10b>
  8020cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020d6:	01 00 00 
  8020d9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8020dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e0:	25 00 08 00 00       	and    $0x800,%eax
  8020e5:	48 85 c0             	test   %rax,%rax
  8020e8:	74 50                	je     80213a <duppage+0x15b>
		if ((r = sys_page_map(0, addr, 0, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  8020ea:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020f1:	01 00 00 
  8020f4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8020f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020fb:	25 05 06 00 00       	and    $0x605,%eax
  802100:	80 cc 08             	or     $0x8,%ah
  802103:	89 c1                	mov    %eax,%ecx
  802105:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802109:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80210d:	41 89 c8             	mov    %ecx,%r8d
  802110:	48 89 d1             	mov    %rdx,%rcx
  802113:	ba 00 00 00 00       	mov    $0x0,%edx
  802118:	48 89 c6             	mov    %rax,%rsi
  80211b:	bf 00 00 00 00       	mov    $0x0,%edi
  802120:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  802127:	00 00 00 
  80212a:	ff d0                	callq  *%rax
  80212c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80212f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802133:	79 05                	jns    80213a <duppage+0x15b>
			return r;
  802135:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802138:	eb 05                	jmp    80213f <duppage+0x160>
	//panic("duppage not implemented");
	return 0;
  80213a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80213f:	c9                   	leaveq 
  802140:	c3                   	retq   

0000000000802141 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802141:	55                   	push   %rbp
  802142:	48 89 e5             	mov    %rsp,%rbp
  802145:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	int r;
	envid_t envid;
	int i, j, k, l, ptx = 0;
  802149:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	set_pgfault_handler(pgfault);
  802150:	48 bf d8 1e 80 00 00 	movabs $0x801ed8,%rdi
  802157:	00 00 00 
  80215a:	48 b8 60 46 80 00 00 	movabs $0x804660,%rax
  802161:	00 00 00 
  802164:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802166:	b8 07 00 00 00       	mov    $0x7,%eax
  80216b:	cd 30                	int    $0x30
  80216d:	89 45 e0             	mov    %eax,-0x20(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802170:	8b 45 e0             	mov    -0x20(%rbp),%eax

	if ((envid = sys_exofork()) < 0)
  802173:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802176:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80217a:	79 08                	jns    802184 <fork+0x43>
		return envid;
  80217c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80217f:	e9 27 02 00 00       	jmpq   8023ab <fork+0x26a>
	else if (envid == 0) {
  802184:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802188:	75 46                	jne    8021d0 <fork+0x8f>
		thisenv = &envs[ENVX(sys_getenvid())];
  80218a:	48 b8 ef 1b 80 00 00 	movabs $0x801bef,%rax
  802191:	00 00 00 
  802194:	ff d0                	callq  *%rax
  802196:	25 ff 03 00 00       	and    $0x3ff,%eax
  80219b:	48 63 d0             	movslq %eax,%rdx
  80219e:	48 89 d0             	mov    %rdx,%rax
  8021a1:	48 c1 e0 03          	shl    $0x3,%rax
  8021a5:	48 01 d0             	add    %rdx,%rax
  8021a8:	48 c1 e0 05          	shl    $0x5,%rax
  8021ac:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8021b3:	00 00 00 
  8021b6:	48 01 c2             	add    %rax,%rdx
  8021b9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021c0:	00 00 00 
  8021c3:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8021c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cb:	e9 db 01 00 00       	jmpq   8023ab <fork+0x26a>
	}

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8021d0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8021d3:	ba 07 00 00 00       	mov    $0x7,%edx
  8021d8:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8021dd:	89 c7                	mov    %eax,%edi
  8021df:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  8021e6:	00 00 00 
  8021e9:	ff d0                	callq  *%rax
  8021eb:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8021ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8021f2:	79 08                	jns    8021fc <fork+0xbb>
		return r;
  8021f4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8021f7:	e9 af 01 00 00       	jmpq   8023ab <fork+0x26a>

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  8021fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802203:	e9 49 01 00 00       	jmpq   802351 <fork+0x210>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  802208:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80220b:	8d 90 ff ff ff 07    	lea    0x7ffffff(%rax),%edx
  802211:	85 c0                	test   %eax,%eax
  802213:	0f 48 c2             	cmovs  %edx,%eax
  802216:	c1 f8 1b             	sar    $0x1b,%eax
  802219:	89 c2                	mov    %eax,%edx
  80221b:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802222:	01 00 00 
  802225:	48 63 d2             	movslq %edx,%rdx
  802228:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80222c:	83 e0 01             	and    $0x1,%eax
  80222f:	48 85 c0             	test   %rax,%rax
  802232:	75 0c                	jne    802240 <fork+0xff>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  802234:	81 45 ec 00 00 00 08 	addl   $0x8000000,-0x14(%rbp)
			continue;
  80223b:	e9 0d 01 00 00       	jmpq   80234d <fork+0x20c>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  802240:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  802247:	e9 f4 00 00 00       	jmpq   802340 <fork+0x1ff>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  80224c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80224f:	8d 90 ff ff 03 00    	lea    0x3ffff(%rax),%edx
  802255:	85 c0                	test   %eax,%eax
  802257:	0f 48 c2             	cmovs  %edx,%eax
  80225a:	c1 f8 12             	sar    $0x12,%eax
  80225d:	89 c2                	mov    %eax,%edx
  80225f:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802266:	01 00 00 
  802269:	48 63 d2             	movslq %edx,%rdx
  80226c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802270:	83 e0 01             	and    $0x1,%eax
  802273:	48 85 c0             	test   %rax,%rax
  802276:	75 0c                	jne    802284 <fork+0x143>
				ptx += NPDENTRIES * NPTENTRIES;
  802278:	81 45 ec 00 00 04 00 	addl   $0x40000,-0x14(%rbp)
				continue;
  80227f:	e9 b8 00 00 00       	jmpq   80233c <fork+0x1fb>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  802284:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80228b:	e9 9f 00 00 00       	jmpq   80232f <fork+0x1ee>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  802290:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802293:	8d 90 ff 01 00 00    	lea    0x1ff(%rax),%edx
  802299:	85 c0                	test   %eax,%eax
  80229b:	0f 48 c2             	cmovs  %edx,%eax
  80229e:	c1 f8 09             	sar    $0x9,%eax
  8022a1:	89 c2                	mov    %eax,%edx
  8022a3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022aa:	01 00 00 
  8022ad:	48 63 d2             	movslq %edx,%rdx
  8022b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b4:	83 e0 01             	and    $0x1,%eax
  8022b7:	48 85 c0             	test   %rax,%rax
  8022ba:	75 09                	jne    8022c5 <fork+0x184>
					ptx += NPTENTRIES;
  8022bc:	81 45 ec 00 02 00 00 	addl   $0x200,-0x14(%rbp)
					continue;
  8022c3:	eb 66                	jmp    80232b <fork+0x1ea>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  8022c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8022cc:	eb 54                	jmp    802322 <fork+0x1e1>
					if ((uvpt[ptx] & PTE_P) != 0)
  8022ce:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022d5:	01 00 00 
  8022d8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8022db:	48 63 d2             	movslq %edx,%rdx
  8022de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e2:	83 e0 01             	and    $0x1,%eax
  8022e5:	48 85 c0             	test   %rax,%rax
  8022e8:	74 30                	je     80231a <fork+0x1d9>
						if (ptx != VPN(UXSTACKTOP - PGSIZE))
  8022ea:	81 7d ec ff f7 0e 00 	cmpl   $0xef7ff,-0x14(%rbp)
  8022f1:	74 27                	je     80231a <fork+0x1d9>
							if ((r = duppage(envid, ptx)) < 0)
  8022f3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8022f6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8022f9:	89 d6                	mov    %edx,%esi
  8022fb:	89 c7                	mov    %eax,%edi
  8022fd:	48 b8 df 1f 80 00 00 	movabs $0x801fdf,%rax
  802304:	00 00 00 
  802307:	ff d0                	callq  *%rax
  802309:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80230c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802310:	79 08                	jns    80231a <fork+0x1d9>
								return r;
  802312:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802315:	e9 91 00 00 00       	jmpq   8023ab <fork+0x26a>
					ptx++;
  80231a:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  80231e:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  802322:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
  802329:	7e a3                	jle    8022ce <fork+0x18d>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  80232b:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  80232f:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
  802336:	0f 8e 54 ff ff ff    	jle    802290 <fork+0x14f>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  80233c:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  802340:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
  802347:	0f 8e ff fe ff ff    	jle    80224c <fork+0x10b>
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		return r;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  80234d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802351:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802355:	0f 84 ad fe ff ff    	je     802208 <fork+0xc7>
			}
		}
	}

	extern void _pgfault_upcall();
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  80235b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80235e:	48 be cb 46 80 00 00 	movabs $0x8046cb,%rsi
  802365:	00 00 00 
  802368:	89 c7                	mov    %eax,%edi
  80236a:	48 b8 f5 1d 80 00 00 	movabs $0x801df5,%rax
  802371:	00 00 00 
  802374:	ff d0                	callq  *%rax
  802376:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802379:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80237d:	79 05                	jns    802384 <fork+0x243>
		return r;
  80237f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802382:	eb 27                	jmp    8023ab <fork+0x26a>
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802384:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802387:	be 02 00 00 00       	mov    $0x2,%esi
  80238c:	89 c7                	mov    %eax,%edi
  80238e:	48 b8 60 1d 80 00 00 	movabs $0x801d60,%rax
  802395:	00 00 00 
  802398:	ff d0                	callq  *%rax
  80239a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80239d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8023a1:	79 05                	jns    8023a8 <fork+0x267>
		return r;
  8023a3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8023a6:	eb 03                	jmp    8023ab <fork+0x26a>

	return envid;
  8023a8:	8b 45 e8             	mov    -0x18(%rbp),%eax
	//panic("fork not implemented");
}
  8023ab:	c9                   	leaveq 
  8023ac:	c3                   	retq   

00000000008023ad <sfork>:

// Challenge!
int
sfork(void)
{
  8023ad:	55                   	push   %rbp
  8023ae:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8023b1:	48 ba d1 4f 80 00 00 	movabs $0x804fd1,%rdx
  8023b8:	00 00 00 
  8023bb:	be a7 00 00 00       	mov    $0xa7,%esi
  8023c0:	48 bf c6 4f 80 00 00 	movabs $0x804fc6,%rdi
  8023c7:	00 00 00 
  8023ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cf:	48 b9 5b 03 80 00 00 	movabs $0x80035b,%rcx
  8023d6:	00 00 00 
  8023d9:	ff d1                	callq  *%rcx

00000000008023db <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8023db:	55                   	push   %rbp
  8023dc:	48 89 e5             	mov    %rsp,%rbp
  8023df:	48 83 ec 08          	sub    $0x8,%rsp
  8023e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8023e7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023eb:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8023f2:	ff ff ff 
  8023f5:	48 01 d0             	add    %rdx,%rax
  8023f8:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8023fc:	c9                   	leaveq 
  8023fd:	c3                   	retq   

00000000008023fe <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8023fe:	55                   	push   %rbp
  8023ff:	48 89 e5             	mov    %rsp,%rbp
  802402:	48 83 ec 08          	sub    $0x8,%rsp
  802406:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80240a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80240e:	48 89 c7             	mov    %rax,%rdi
  802411:	48 b8 db 23 80 00 00 	movabs $0x8023db,%rax
  802418:	00 00 00 
  80241b:	ff d0                	callq  *%rax
  80241d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802423:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802427:	c9                   	leaveq 
  802428:	c3                   	retq   

0000000000802429 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802429:	55                   	push   %rbp
  80242a:	48 89 e5             	mov    %rsp,%rbp
  80242d:	48 83 ec 18          	sub    $0x18,%rsp
  802431:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802435:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80243c:	eb 6b                	jmp    8024a9 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80243e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802441:	48 98                	cltq   
  802443:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802449:	48 c1 e0 0c          	shl    $0xc,%rax
  80244d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802451:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802455:	48 c1 e8 15          	shr    $0x15,%rax
  802459:	48 89 c2             	mov    %rax,%rdx
  80245c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802463:	01 00 00 
  802466:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80246a:	83 e0 01             	and    $0x1,%eax
  80246d:	48 85 c0             	test   %rax,%rax
  802470:	74 21                	je     802493 <fd_alloc+0x6a>
  802472:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802476:	48 c1 e8 0c          	shr    $0xc,%rax
  80247a:	48 89 c2             	mov    %rax,%rdx
  80247d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802484:	01 00 00 
  802487:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80248b:	83 e0 01             	and    $0x1,%eax
  80248e:	48 85 c0             	test   %rax,%rax
  802491:	75 12                	jne    8024a5 <fd_alloc+0x7c>
			*fd_store = fd;
  802493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802497:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80249b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80249e:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a3:	eb 1a                	jmp    8024bf <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024a5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024a9:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8024ad:	7e 8f                	jle    80243e <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8024af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024b3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8024ba:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8024bf:	c9                   	leaveq 
  8024c0:	c3                   	retq   

00000000008024c1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8024c1:	55                   	push   %rbp
  8024c2:	48 89 e5             	mov    %rsp,%rbp
  8024c5:	48 83 ec 20          	sub    $0x20,%rsp
  8024c9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8024d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8024d4:	78 06                	js     8024dc <fd_lookup+0x1b>
  8024d6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8024da:	7e 07                	jle    8024e3 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024e1:	eb 6c                	jmp    80254f <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8024e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024e6:	48 98                	cltq   
  8024e8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024ee:	48 c1 e0 0c          	shl    $0xc,%rax
  8024f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8024f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024fa:	48 c1 e8 15          	shr    $0x15,%rax
  8024fe:	48 89 c2             	mov    %rax,%rdx
  802501:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802508:	01 00 00 
  80250b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80250f:	83 e0 01             	and    $0x1,%eax
  802512:	48 85 c0             	test   %rax,%rax
  802515:	74 21                	je     802538 <fd_lookup+0x77>
  802517:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80251b:	48 c1 e8 0c          	shr    $0xc,%rax
  80251f:	48 89 c2             	mov    %rax,%rdx
  802522:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802529:	01 00 00 
  80252c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802530:	83 e0 01             	and    $0x1,%eax
  802533:	48 85 c0             	test   %rax,%rax
  802536:	75 07                	jne    80253f <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802538:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80253d:	eb 10                	jmp    80254f <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80253f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802543:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802547:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80254a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80254f:	c9                   	leaveq 
  802550:	c3                   	retq   

0000000000802551 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802551:	55                   	push   %rbp
  802552:	48 89 e5             	mov    %rsp,%rbp
  802555:	48 83 ec 30          	sub    $0x30,%rsp
  802559:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80255d:	89 f0                	mov    %esi,%eax
  80255f:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802562:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802566:	48 89 c7             	mov    %rax,%rdi
  802569:	48 b8 db 23 80 00 00 	movabs $0x8023db,%rax
  802570:	00 00 00 
  802573:	ff d0                	callq  *%rax
  802575:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802579:	48 89 d6             	mov    %rdx,%rsi
  80257c:	89 c7                	mov    %eax,%edi
  80257e:	48 b8 c1 24 80 00 00 	movabs $0x8024c1,%rax
  802585:	00 00 00 
  802588:	ff d0                	callq  *%rax
  80258a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802591:	78 0a                	js     80259d <fd_close+0x4c>
	    || fd != fd2)
  802593:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802597:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80259b:	74 12                	je     8025af <fd_close+0x5e>
		return (must_exist ? r : 0);
  80259d:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8025a1:	74 05                	je     8025a8 <fd_close+0x57>
  8025a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a6:	eb 05                	jmp    8025ad <fd_close+0x5c>
  8025a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ad:	eb 69                	jmp    802618 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8025af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025b3:	8b 00                	mov    (%rax),%eax
  8025b5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025b9:	48 89 d6             	mov    %rdx,%rsi
  8025bc:	89 c7                	mov    %eax,%edi
  8025be:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  8025c5:	00 00 00 
  8025c8:	ff d0                	callq  *%rax
  8025ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025d1:	78 2a                	js     8025fd <fd_close+0xac>
		if (dev->dev_close)
  8025d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8025db:	48 85 c0             	test   %rax,%rax
  8025de:	74 16                	je     8025f6 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8025e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025e4:	48 8b 40 20          	mov    0x20(%rax),%rax
  8025e8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025ec:	48 89 d7             	mov    %rdx,%rdi
  8025ef:	ff d0                	callq  *%rax
  8025f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f4:	eb 07                	jmp    8025fd <fd_close+0xac>
		else
			r = 0;
  8025f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8025fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802601:	48 89 c6             	mov    %rax,%rsi
  802604:	bf 00 00 00 00       	mov    $0x0,%edi
  802609:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  802610:	00 00 00 
  802613:	ff d0                	callq  *%rax
	return r;
  802615:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802618:	c9                   	leaveq 
  802619:	c3                   	retq   

000000000080261a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80261a:	55                   	push   %rbp
  80261b:	48 89 e5             	mov    %rsp,%rbp
  80261e:	48 83 ec 20          	sub    $0x20,%rsp
  802622:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802625:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802629:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802630:	eb 41                	jmp    802673 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802632:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802639:	00 00 00 
  80263c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80263f:	48 63 d2             	movslq %edx,%rdx
  802642:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802646:	8b 00                	mov    (%rax),%eax
  802648:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80264b:	75 22                	jne    80266f <dev_lookup+0x55>
			*dev = devtab[i];
  80264d:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802654:	00 00 00 
  802657:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80265a:	48 63 d2             	movslq %edx,%rdx
  80265d:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802661:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802665:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802668:	b8 00 00 00 00       	mov    $0x0,%eax
  80266d:	eb 60                	jmp    8026cf <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80266f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802673:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80267a:	00 00 00 
  80267d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802680:	48 63 d2             	movslq %edx,%rdx
  802683:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802687:	48 85 c0             	test   %rax,%rax
  80268a:	75 a6                	jne    802632 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80268c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802693:	00 00 00 
  802696:	48 8b 00             	mov    (%rax),%rax
  802699:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80269f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8026a2:	89 c6                	mov    %eax,%esi
  8026a4:	48 bf e8 4f 80 00 00 	movabs $0x804fe8,%rdi
  8026ab:	00 00 00 
  8026ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b3:	48 b9 94 05 80 00 00 	movabs $0x800594,%rcx
  8026ba:	00 00 00 
  8026bd:	ff d1                	callq  *%rcx
	*dev = 0;
  8026bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026c3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8026ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8026cf:	c9                   	leaveq 
  8026d0:	c3                   	retq   

00000000008026d1 <close>:

int
close(int fdnum)
{
  8026d1:	55                   	push   %rbp
  8026d2:	48 89 e5             	mov    %rsp,%rbp
  8026d5:	48 83 ec 20          	sub    $0x20,%rsp
  8026d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026dc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026e3:	48 89 d6             	mov    %rdx,%rsi
  8026e6:	89 c7                	mov    %eax,%edi
  8026e8:	48 b8 c1 24 80 00 00 	movabs $0x8024c1,%rax
  8026ef:	00 00 00 
  8026f2:	ff d0                	callq  *%rax
  8026f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026fb:	79 05                	jns    802702 <close+0x31>
		return r;
  8026fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802700:	eb 18                	jmp    80271a <close+0x49>
	else
		return fd_close(fd, 1);
  802702:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802706:	be 01 00 00 00       	mov    $0x1,%esi
  80270b:	48 89 c7             	mov    %rax,%rdi
  80270e:	48 b8 51 25 80 00 00 	movabs $0x802551,%rax
  802715:	00 00 00 
  802718:	ff d0                	callq  *%rax
}
  80271a:	c9                   	leaveq 
  80271b:	c3                   	retq   

000000000080271c <close_all>:

void
close_all(void)
{
  80271c:	55                   	push   %rbp
  80271d:	48 89 e5             	mov    %rsp,%rbp
  802720:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802724:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80272b:	eb 15                	jmp    802742 <close_all+0x26>
		close(i);
  80272d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802730:	89 c7                	mov    %eax,%edi
  802732:	48 b8 d1 26 80 00 00 	movabs $0x8026d1,%rax
  802739:	00 00 00 
  80273c:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80273e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802742:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802746:	7e e5                	jle    80272d <close_all+0x11>
		close(i);
}
  802748:	c9                   	leaveq 
  802749:	c3                   	retq   

000000000080274a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80274a:	55                   	push   %rbp
  80274b:	48 89 e5             	mov    %rsp,%rbp
  80274e:	48 83 ec 40          	sub    $0x40,%rsp
  802752:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802755:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802758:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80275c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80275f:	48 89 d6             	mov    %rdx,%rsi
  802762:	89 c7                	mov    %eax,%edi
  802764:	48 b8 c1 24 80 00 00 	movabs $0x8024c1,%rax
  80276b:	00 00 00 
  80276e:	ff d0                	callq  *%rax
  802770:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802773:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802777:	79 08                	jns    802781 <dup+0x37>
		return r;
  802779:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277c:	e9 70 01 00 00       	jmpq   8028f1 <dup+0x1a7>
	close(newfdnum);
  802781:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802784:	89 c7                	mov    %eax,%edi
  802786:	48 b8 d1 26 80 00 00 	movabs $0x8026d1,%rax
  80278d:	00 00 00 
  802790:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802792:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802795:	48 98                	cltq   
  802797:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80279d:	48 c1 e0 0c          	shl    $0xc,%rax
  8027a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8027a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a9:	48 89 c7             	mov    %rax,%rdi
  8027ac:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  8027b3:	00 00 00 
  8027b6:	ff d0                	callq  *%rax
  8027b8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8027bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027c0:	48 89 c7             	mov    %rax,%rdi
  8027c3:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  8027ca:	00 00 00 
  8027cd:	ff d0                	callq  *%rax
  8027cf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8027d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d7:	48 c1 e8 15          	shr    $0x15,%rax
  8027db:	48 89 c2             	mov    %rax,%rdx
  8027de:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027e5:	01 00 00 
  8027e8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027ec:	83 e0 01             	and    $0x1,%eax
  8027ef:	48 85 c0             	test   %rax,%rax
  8027f2:	74 73                	je     802867 <dup+0x11d>
  8027f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f8:	48 c1 e8 0c          	shr    $0xc,%rax
  8027fc:	48 89 c2             	mov    %rax,%rdx
  8027ff:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802806:	01 00 00 
  802809:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80280d:	83 e0 01             	and    $0x1,%eax
  802810:	48 85 c0             	test   %rax,%rax
  802813:	74 52                	je     802867 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802815:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802819:	48 c1 e8 0c          	shr    $0xc,%rax
  80281d:	48 89 c2             	mov    %rax,%rdx
  802820:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802827:	01 00 00 
  80282a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80282e:	25 07 0e 00 00       	and    $0xe07,%eax
  802833:	89 c1                	mov    %eax,%ecx
  802835:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802839:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80283d:	41 89 c8             	mov    %ecx,%r8d
  802840:	48 89 d1             	mov    %rdx,%rcx
  802843:	ba 00 00 00 00       	mov    $0x0,%edx
  802848:	48 89 c6             	mov    %rax,%rsi
  80284b:	bf 00 00 00 00       	mov    $0x0,%edi
  802850:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  802857:	00 00 00 
  80285a:	ff d0                	callq  *%rax
  80285c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80285f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802863:	79 02                	jns    802867 <dup+0x11d>
			goto err;
  802865:	eb 57                	jmp    8028be <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802867:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80286b:	48 c1 e8 0c          	shr    $0xc,%rax
  80286f:	48 89 c2             	mov    %rax,%rdx
  802872:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802879:	01 00 00 
  80287c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802880:	25 07 0e 00 00       	and    $0xe07,%eax
  802885:	89 c1                	mov    %eax,%ecx
  802887:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80288b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80288f:	41 89 c8             	mov    %ecx,%r8d
  802892:	48 89 d1             	mov    %rdx,%rcx
  802895:	ba 00 00 00 00       	mov    $0x0,%edx
  80289a:	48 89 c6             	mov    %rax,%rsi
  80289d:	bf 00 00 00 00       	mov    $0x0,%edi
  8028a2:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  8028a9:	00 00 00 
  8028ac:	ff d0                	callq  *%rax
  8028ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b5:	79 02                	jns    8028b9 <dup+0x16f>
		goto err;
  8028b7:	eb 05                	jmp    8028be <dup+0x174>

	return newfdnum;
  8028b9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028bc:	eb 33                	jmp    8028f1 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8028be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c2:	48 89 c6             	mov    %rax,%rsi
  8028c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ca:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  8028d1:	00 00 00 
  8028d4:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8028d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028da:	48 89 c6             	mov    %rax,%rsi
  8028dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8028e2:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  8028e9:	00 00 00 
  8028ec:	ff d0                	callq  *%rax
	return r;
  8028ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028f1:	c9                   	leaveq 
  8028f2:	c3                   	retq   

00000000008028f3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8028f3:	55                   	push   %rbp
  8028f4:	48 89 e5             	mov    %rsp,%rbp
  8028f7:	48 83 ec 40          	sub    $0x40,%rsp
  8028fb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802902:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802906:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80290a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80290d:	48 89 d6             	mov    %rdx,%rsi
  802910:	89 c7                	mov    %eax,%edi
  802912:	48 b8 c1 24 80 00 00 	movabs $0x8024c1,%rax
  802919:	00 00 00 
  80291c:	ff d0                	callq  *%rax
  80291e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802921:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802925:	78 24                	js     80294b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802927:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292b:	8b 00                	mov    (%rax),%eax
  80292d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802931:	48 89 d6             	mov    %rdx,%rsi
  802934:	89 c7                	mov    %eax,%edi
  802936:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  80293d:	00 00 00 
  802940:	ff d0                	callq  *%rax
  802942:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802945:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802949:	79 05                	jns    802950 <read+0x5d>
		return r;
  80294b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80294e:	eb 76                	jmp    8029c6 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802954:	8b 40 08             	mov    0x8(%rax),%eax
  802957:	83 e0 03             	and    $0x3,%eax
  80295a:	83 f8 01             	cmp    $0x1,%eax
  80295d:	75 3a                	jne    802999 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80295f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802966:	00 00 00 
  802969:	48 8b 00             	mov    (%rax),%rax
  80296c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802972:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802975:	89 c6                	mov    %eax,%esi
  802977:	48 bf 07 50 80 00 00 	movabs $0x805007,%rdi
  80297e:	00 00 00 
  802981:	b8 00 00 00 00       	mov    $0x0,%eax
  802986:	48 b9 94 05 80 00 00 	movabs $0x800594,%rcx
  80298d:	00 00 00 
  802990:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802992:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802997:	eb 2d                	jmp    8029c6 <read+0xd3>
	}
	if (!dev->dev_read)
  802999:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80299d:	48 8b 40 10          	mov    0x10(%rax),%rax
  8029a1:	48 85 c0             	test   %rax,%rax
  8029a4:	75 07                	jne    8029ad <read+0xba>
		return -E_NOT_SUPP;
  8029a6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029ab:	eb 19                	jmp    8029c6 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8029ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8029b5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8029b9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029bd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8029c1:	48 89 cf             	mov    %rcx,%rdi
  8029c4:	ff d0                	callq  *%rax
}
  8029c6:	c9                   	leaveq 
  8029c7:	c3                   	retq   

00000000008029c8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8029c8:	55                   	push   %rbp
  8029c9:	48 89 e5             	mov    %rsp,%rbp
  8029cc:	48 83 ec 30          	sub    $0x30,%rsp
  8029d0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8029db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029e2:	eb 49                	jmp    802a2d <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8029e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e7:	48 98                	cltq   
  8029e9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029ed:	48 29 c2             	sub    %rax,%rdx
  8029f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f3:	48 63 c8             	movslq %eax,%rcx
  8029f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029fa:	48 01 c1             	add    %rax,%rcx
  8029fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a00:	48 89 ce             	mov    %rcx,%rsi
  802a03:	89 c7                	mov    %eax,%edi
  802a05:	48 b8 f3 28 80 00 00 	movabs $0x8028f3,%rax
  802a0c:	00 00 00 
  802a0f:	ff d0                	callq  *%rax
  802a11:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802a14:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a18:	79 05                	jns    802a1f <readn+0x57>
			return m;
  802a1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a1d:	eb 1c                	jmp    802a3b <readn+0x73>
		if (m == 0)
  802a1f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a23:	75 02                	jne    802a27 <readn+0x5f>
			break;
  802a25:	eb 11                	jmp    802a38 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a27:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a2a:	01 45 fc             	add    %eax,-0x4(%rbp)
  802a2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a30:	48 98                	cltq   
  802a32:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a36:	72 ac                	jb     8029e4 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802a38:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a3b:	c9                   	leaveq 
  802a3c:	c3                   	retq   

0000000000802a3d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802a3d:	55                   	push   %rbp
  802a3e:	48 89 e5             	mov    %rsp,%rbp
  802a41:	48 83 ec 40          	sub    $0x40,%rsp
  802a45:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a48:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a4c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a50:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a54:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a57:	48 89 d6             	mov    %rdx,%rsi
  802a5a:	89 c7                	mov    %eax,%edi
  802a5c:	48 b8 c1 24 80 00 00 	movabs $0x8024c1,%rax
  802a63:	00 00 00 
  802a66:	ff d0                	callq  *%rax
  802a68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a6f:	78 24                	js     802a95 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a75:	8b 00                	mov    (%rax),%eax
  802a77:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a7b:	48 89 d6             	mov    %rdx,%rsi
  802a7e:	89 c7                	mov    %eax,%edi
  802a80:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  802a87:	00 00 00 
  802a8a:	ff d0                	callq  *%rax
  802a8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a93:	79 05                	jns    802a9a <write+0x5d>
		return r;
  802a95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a98:	eb 75                	jmp    802b0f <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a9e:	8b 40 08             	mov    0x8(%rax),%eax
  802aa1:	83 e0 03             	and    $0x3,%eax
  802aa4:	85 c0                	test   %eax,%eax
  802aa6:	75 3a                	jne    802ae2 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802aa8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802aaf:	00 00 00 
  802ab2:	48 8b 00             	mov    (%rax),%rax
  802ab5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802abb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802abe:	89 c6                	mov    %eax,%esi
  802ac0:	48 bf 23 50 80 00 00 	movabs $0x805023,%rdi
  802ac7:	00 00 00 
  802aca:	b8 00 00 00 00       	mov    $0x0,%eax
  802acf:	48 b9 94 05 80 00 00 	movabs $0x800594,%rcx
  802ad6:	00 00 00 
  802ad9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802adb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ae0:	eb 2d                	jmp    802b0f <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ae2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae6:	48 8b 40 18          	mov    0x18(%rax),%rax
  802aea:	48 85 c0             	test   %rax,%rax
  802aed:	75 07                	jne    802af6 <write+0xb9>
		return -E_NOT_SUPP;
  802aef:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802af4:	eb 19                	jmp    802b0f <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802af6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802afa:	48 8b 40 18          	mov    0x18(%rax),%rax
  802afe:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b02:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b06:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b0a:	48 89 cf             	mov    %rcx,%rdi
  802b0d:	ff d0                	callq  *%rax
}
  802b0f:	c9                   	leaveq 
  802b10:	c3                   	retq   

0000000000802b11 <seek>:

int
seek(int fdnum, off_t offset)
{
  802b11:	55                   	push   %rbp
  802b12:	48 89 e5             	mov    %rsp,%rbp
  802b15:	48 83 ec 18          	sub    $0x18,%rsp
  802b19:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b1c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b1f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b23:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b26:	48 89 d6             	mov    %rdx,%rsi
  802b29:	89 c7                	mov    %eax,%edi
  802b2b:	48 b8 c1 24 80 00 00 	movabs $0x8024c1,%rax
  802b32:	00 00 00 
  802b35:	ff d0                	callq  *%rax
  802b37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b3e:	79 05                	jns    802b45 <seek+0x34>
		return r;
  802b40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b43:	eb 0f                	jmp    802b54 <seek+0x43>
	fd->fd_offset = offset;
  802b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b49:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b4c:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802b4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b54:	c9                   	leaveq 
  802b55:	c3                   	retq   

0000000000802b56 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802b56:	55                   	push   %rbp
  802b57:	48 89 e5             	mov    %rsp,%rbp
  802b5a:	48 83 ec 30          	sub    $0x30,%rsp
  802b5e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b61:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b64:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b68:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b6b:	48 89 d6             	mov    %rdx,%rsi
  802b6e:	89 c7                	mov    %eax,%edi
  802b70:	48 b8 c1 24 80 00 00 	movabs $0x8024c1,%rax
  802b77:	00 00 00 
  802b7a:	ff d0                	callq  *%rax
  802b7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b83:	78 24                	js     802ba9 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b89:	8b 00                	mov    (%rax),%eax
  802b8b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b8f:	48 89 d6             	mov    %rdx,%rsi
  802b92:	89 c7                	mov    %eax,%edi
  802b94:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  802b9b:	00 00 00 
  802b9e:	ff d0                	callq  *%rax
  802ba0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba7:	79 05                	jns    802bae <ftruncate+0x58>
		return r;
  802ba9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bac:	eb 72                	jmp    802c20 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802bae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb2:	8b 40 08             	mov    0x8(%rax),%eax
  802bb5:	83 e0 03             	and    $0x3,%eax
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	75 3a                	jne    802bf6 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802bbc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802bc3:	00 00 00 
  802bc6:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802bc9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bcf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bd2:	89 c6                	mov    %eax,%esi
  802bd4:	48 bf 40 50 80 00 00 	movabs $0x805040,%rdi
  802bdb:	00 00 00 
  802bde:	b8 00 00 00 00       	mov    $0x0,%eax
  802be3:	48 b9 94 05 80 00 00 	movabs $0x800594,%rcx
  802bea:	00 00 00 
  802bed:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802bef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bf4:	eb 2a                	jmp    802c20 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802bf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bfa:	48 8b 40 30          	mov    0x30(%rax),%rax
  802bfe:	48 85 c0             	test   %rax,%rax
  802c01:	75 07                	jne    802c0a <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c03:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c08:	eb 16                	jmp    802c20 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c0e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c16:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802c19:	89 ce                	mov    %ecx,%esi
  802c1b:	48 89 d7             	mov    %rdx,%rdi
  802c1e:	ff d0                	callq  *%rax
}
  802c20:	c9                   	leaveq 
  802c21:	c3                   	retq   

0000000000802c22 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c22:	55                   	push   %rbp
  802c23:	48 89 e5             	mov    %rsp,%rbp
  802c26:	48 83 ec 30          	sub    $0x30,%rsp
  802c2a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c2d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c31:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c35:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c38:	48 89 d6             	mov    %rdx,%rsi
  802c3b:	89 c7                	mov    %eax,%edi
  802c3d:	48 b8 c1 24 80 00 00 	movabs $0x8024c1,%rax
  802c44:	00 00 00 
  802c47:	ff d0                	callq  *%rax
  802c49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c50:	78 24                	js     802c76 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c56:	8b 00                	mov    (%rax),%eax
  802c58:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c5c:	48 89 d6             	mov    %rdx,%rsi
  802c5f:	89 c7                	mov    %eax,%edi
  802c61:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  802c68:	00 00 00 
  802c6b:	ff d0                	callq  *%rax
  802c6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c74:	79 05                	jns    802c7b <fstat+0x59>
		return r;
  802c76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c79:	eb 5e                	jmp    802cd9 <fstat+0xb7>
	if (!dev->dev_stat)
  802c7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c7f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c83:	48 85 c0             	test   %rax,%rax
  802c86:	75 07                	jne    802c8f <fstat+0x6d>
		return -E_NOT_SUPP;
  802c88:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c8d:	eb 4a                	jmp    802cd9 <fstat+0xb7>
	stat->st_name[0] = 0;
  802c8f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c93:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802c96:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c9a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802ca1:	00 00 00 
	stat->st_isdir = 0;
  802ca4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ca8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802caf:	00 00 00 
	stat->st_dev = dev;
  802cb2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cb6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cba:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802cc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cc5:	48 8b 40 28          	mov    0x28(%rax),%rax
  802cc9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ccd:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802cd1:	48 89 ce             	mov    %rcx,%rsi
  802cd4:	48 89 d7             	mov    %rdx,%rdi
  802cd7:	ff d0                	callq  *%rax
}
  802cd9:	c9                   	leaveq 
  802cda:	c3                   	retq   

0000000000802cdb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802cdb:	55                   	push   %rbp
  802cdc:	48 89 e5             	mov    %rsp,%rbp
  802cdf:	48 83 ec 20          	sub    $0x20,%rsp
  802ce3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ce7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ceb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cef:	be 00 00 00 00       	mov    $0x0,%esi
  802cf4:	48 89 c7             	mov    %rax,%rdi
  802cf7:	48 b8 c9 2d 80 00 00 	movabs $0x802dc9,%rax
  802cfe:	00 00 00 
  802d01:	ff d0                	callq  *%rax
  802d03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d0a:	79 05                	jns    802d11 <stat+0x36>
		return fd;
  802d0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d0f:	eb 2f                	jmp    802d40 <stat+0x65>
	r = fstat(fd, stat);
  802d11:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d18:	48 89 d6             	mov    %rdx,%rsi
  802d1b:	89 c7                	mov    %eax,%edi
  802d1d:	48 b8 22 2c 80 00 00 	movabs $0x802c22,%rax
  802d24:	00 00 00 
  802d27:	ff d0                	callq  *%rax
  802d29:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802d2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2f:	89 c7                	mov    %eax,%edi
  802d31:	48 b8 d1 26 80 00 00 	movabs $0x8026d1,%rax
  802d38:	00 00 00 
  802d3b:	ff d0                	callq  *%rax
	return r;
  802d3d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802d40:	c9                   	leaveq 
  802d41:	c3                   	retq   

0000000000802d42 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802d42:	55                   	push   %rbp
  802d43:	48 89 e5             	mov    %rsp,%rbp
  802d46:	48 83 ec 10          	sub    $0x10,%rsp
  802d4a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d4d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802d51:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802d58:	00 00 00 
  802d5b:	8b 00                	mov    (%rax),%eax
  802d5d:	85 c0                	test   %eax,%eax
  802d5f:	75 1d                	jne    802d7e <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802d61:	bf 01 00 00 00       	mov    $0x1,%edi
  802d66:	48 b8 b6 48 80 00 00 	movabs $0x8048b6,%rax
  802d6d:	00 00 00 
  802d70:	ff d0                	callq  *%rax
  802d72:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  802d79:	00 00 00 
  802d7c:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802d7e:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802d85:	00 00 00 
  802d88:	8b 00                	mov    (%rax),%eax
  802d8a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d8d:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d92:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802d99:	00 00 00 
  802d9c:	89 c7                	mov    %eax,%edi
  802d9e:	48 b8 1e 48 80 00 00 	movabs $0x80481e,%rax
  802da5:	00 00 00 
  802da8:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802daa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dae:	ba 00 00 00 00       	mov    $0x0,%edx
  802db3:	48 89 c6             	mov    %rax,%rsi
  802db6:	bf 00 00 00 00       	mov    $0x0,%edi
  802dbb:	48 b8 55 47 80 00 00 	movabs $0x804755,%rax
  802dc2:	00 00 00 
  802dc5:	ff d0                	callq  *%rax
}
  802dc7:	c9                   	leaveq 
  802dc8:	c3                   	retq   

0000000000802dc9 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802dc9:	55                   	push   %rbp
  802dca:	48 89 e5             	mov    %rsp,%rbp
  802dcd:	48 83 ec 20          	sub    $0x20,%rsp
  802dd1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dd5:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802dd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ddc:	48 89 c7             	mov    %rax,%rdi
  802ddf:	48 b8 d0 12 80 00 00 	movabs $0x8012d0,%rax
  802de6:	00 00 00 
  802de9:	ff d0                	callq  *%rax
  802deb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802df0:	7e 0a                	jle    802dfc <open+0x33>
		return -E_BAD_PATH;
  802df2:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802df7:	e9 a5 00 00 00       	jmpq   802ea1 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802dfc:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e00:	48 89 c7             	mov    %rax,%rdi
  802e03:	48 b8 29 24 80 00 00 	movabs $0x802429,%rax
  802e0a:	00 00 00 
  802e0d:	ff d0                	callq  *%rax
  802e0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e16:	79 08                	jns    802e20 <open+0x57>
		return r;
  802e18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e1b:	e9 81 00 00 00       	jmpq   802ea1 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802e20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e24:	48 89 c6             	mov    %rax,%rsi
  802e27:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e2e:	00 00 00 
  802e31:	48 b8 3c 13 80 00 00 	movabs $0x80133c,%rax
  802e38:	00 00 00 
  802e3b:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802e3d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e44:	00 00 00 
  802e47:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802e4a:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802e50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e54:	48 89 c6             	mov    %rax,%rsi
  802e57:	bf 01 00 00 00       	mov    $0x1,%edi
  802e5c:	48 b8 42 2d 80 00 00 	movabs $0x802d42,%rax
  802e63:	00 00 00 
  802e66:	ff d0                	callq  *%rax
  802e68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e6f:	79 1d                	jns    802e8e <open+0xc5>
		fd_close(fd, 0);
  802e71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e75:	be 00 00 00 00       	mov    $0x0,%esi
  802e7a:	48 89 c7             	mov    %rax,%rdi
  802e7d:	48 b8 51 25 80 00 00 	movabs $0x802551,%rax
  802e84:	00 00 00 
  802e87:	ff d0                	callq  *%rax
		return r;
  802e89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e8c:	eb 13                	jmp    802ea1 <open+0xd8>
	}

	return fd2num(fd);
  802e8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e92:	48 89 c7             	mov    %rax,%rdi
  802e95:	48 b8 db 23 80 00 00 	movabs $0x8023db,%rax
  802e9c:	00 00 00 
  802e9f:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802ea1:	c9                   	leaveq 
  802ea2:	c3                   	retq   

0000000000802ea3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802ea3:	55                   	push   %rbp
  802ea4:	48 89 e5             	mov    %rsp,%rbp
  802ea7:	48 83 ec 10          	sub    $0x10,%rsp
  802eab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802eaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802eb3:	8b 50 0c             	mov    0xc(%rax),%edx
  802eb6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ebd:	00 00 00 
  802ec0:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802ec2:	be 00 00 00 00       	mov    $0x0,%esi
  802ec7:	bf 06 00 00 00       	mov    $0x6,%edi
  802ecc:	48 b8 42 2d 80 00 00 	movabs $0x802d42,%rax
  802ed3:	00 00 00 
  802ed6:	ff d0                	callq  *%rax
}
  802ed8:	c9                   	leaveq 
  802ed9:	c3                   	retq   

0000000000802eda <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802eda:	55                   	push   %rbp
  802edb:	48 89 e5             	mov    %rsp,%rbp
  802ede:	48 83 ec 30          	sub    $0x30,%rsp
  802ee2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ee6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802eea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802eee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef2:	8b 50 0c             	mov    0xc(%rax),%edx
  802ef5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802efc:	00 00 00 
  802eff:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802f01:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f08:	00 00 00 
  802f0b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f0f:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802f13:	be 00 00 00 00       	mov    $0x0,%esi
  802f18:	bf 03 00 00 00       	mov    $0x3,%edi
  802f1d:	48 b8 42 2d 80 00 00 	movabs $0x802d42,%rax
  802f24:	00 00 00 
  802f27:	ff d0                	callq  *%rax
  802f29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f30:	79 05                	jns    802f37 <devfile_read+0x5d>
		return r;
  802f32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f35:	eb 26                	jmp    802f5d <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802f37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f3a:	48 63 d0             	movslq %eax,%rdx
  802f3d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f41:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f48:	00 00 00 
  802f4b:	48 89 c7             	mov    %rax,%rdi
  802f4e:	48 b8 60 16 80 00 00 	movabs $0x801660,%rax
  802f55:	00 00 00 
  802f58:	ff d0                	callq  *%rax

	return r;
  802f5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802f5d:	c9                   	leaveq 
  802f5e:	c3                   	retq   

0000000000802f5f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802f5f:	55                   	push   %rbp
  802f60:	48 89 e5             	mov    %rsp,%rbp
  802f63:	48 83 ec 30          	sub    $0x30,%rsp
  802f67:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f6b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f6f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802f73:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802f7a:	00 
  802f7b:	76 08                	jbe    802f85 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802f7d:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802f84:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802f85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f89:	8b 50 0c             	mov    0xc(%rax),%edx
  802f8c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f93:	00 00 00 
  802f96:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802f98:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f9f:	00 00 00 
  802fa2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fa6:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  802faa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fb2:	48 89 c6             	mov    %rax,%rsi
  802fb5:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802fbc:	00 00 00 
  802fbf:	48 b8 60 16 80 00 00 	movabs $0x801660,%rax
  802fc6:	00 00 00 
  802fc9:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802fcb:	be 00 00 00 00       	mov    $0x0,%esi
  802fd0:	bf 04 00 00 00       	mov    $0x4,%edi
  802fd5:	48 b8 42 2d 80 00 00 	movabs $0x802d42,%rax
  802fdc:	00 00 00 
  802fdf:	ff d0                	callq  *%rax
  802fe1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe8:	79 05                	jns    802fef <devfile_write+0x90>
		return r;
  802fea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fed:	eb 03                	jmp    802ff2 <devfile_write+0x93>

	return r;
  802fef:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802ff2:	c9                   	leaveq 
  802ff3:	c3                   	retq   

0000000000802ff4 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802ff4:	55                   	push   %rbp
  802ff5:	48 89 e5             	mov    %rsp,%rbp
  802ff8:	48 83 ec 20          	sub    $0x20,%rsp
  802ffc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803000:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803004:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803008:	8b 50 0c             	mov    0xc(%rax),%edx
  80300b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803012:	00 00 00 
  803015:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803017:	be 00 00 00 00       	mov    $0x0,%esi
  80301c:	bf 05 00 00 00       	mov    $0x5,%edi
  803021:	48 b8 42 2d 80 00 00 	movabs $0x802d42,%rax
  803028:	00 00 00 
  80302b:	ff d0                	callq  *%rax
  80302d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803030:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803034:	79 05                	jns    80303b <devfile_stat+0x47>
		return r;
  803036:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803039:	eb 56                	jmp    803091 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80303b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80303f:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803046:	00 00 00 
  803049:	48 89 c7             	mov    %rax,%rdi
  80304c:	48 b8 3c 13 80 00 00 	movabs $0x80133c,%rax
  803053:	00 00 00 
  803056:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803058:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80305f:	00 00 00 
  803062:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803068:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80306c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803072:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803079:	00 00 00 
  80307c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803082:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803086:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80308c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803091:	c9                   	leaveq 
  803092:	c3                   	retq   

0000000000803093 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803093:	55                   	push   %rbp
  803094:	48 89 e5             	mov    %rsp,%rbp
  803097:	48 83 ec 10          	sub    $0x10,%rsp
  80309b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80309f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8030a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030a6:	8b 50 0c             	mov    0xc(%rax),%edx
  8030a9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030b0:	00 00 00 
  8030b3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8030b5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030bc:	00 00 00 
  8030bf:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8030c2:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8030c5:	be 00 00 00 00       	mov    $0x0,%esi
  8030ca:	bf 02 00 00 00       	mov    $0x2,%edi
  8030cf:	48 b8 42 2d 80 00 00 	movabs $0x802d42,%rax
  8030d6:	00 00 00 
  8030d9:	ff d0                	callq  *%rax
}
  8030db:	c9                   	leaveq 
  8030dc:	c3                   	retq   

00000000008030dd <remove>:

// Delete a file
int
remove(const char *path)
{
  8030dd:	55                   	push   %rbp
  8030de:	48 89 e5             	mov    %rsp,%rbp
  8030e1:	48 83 ec 10          	sub    $0x10,%rsp
  8030e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8030e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ed:	48 89 c7             	mov    %rax,%rdi
  8030f0:	48 b8 d0 12 80 00 00 	movabs $0x8012d0,%rax
  8030f7:	00 00 00 
  8030fa:	ff d0                	callq  *%rax
  8030fc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803101:	7e 07                	jle    80310a <remove+0x2d>
		return -E_BAD_PATH;
  803103:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803108:	eb 33                	jmp    80313d <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80310a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80310e:	48 89 c6             	mov    %rax,%rsi
  803111:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803118:	00 00 00 
  80311b:	48 b8 3c 13 80 00 00 	movabs $0x80133c,%rax
  803122:	00 00 00 
  803125:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803127:	be 00 00 00 00       	mov    $0x0,%esi
  80312c:	bf 07 00 00 00       	mov    $0x7,%edi
  803131:	48 b8 42 2d 80 00 00 	movabs $0x802d42,%rax
  803138:	00 00 00 
  80313b:	ff d0                	callq  *%rax
}
  80313d:	c9                   	leaveq 
  80313e:	c3                   	retq   

000000000080313f <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80313f:	55                   	push   %rbp
  803140:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803143:	be 00 00 00 00       	mov    $0x0,%esi
  803148:	bf 08 00 00 00       	mov    $0x8,%edi
  80314d:	48 b8 42 2d 80 00 00 	movabs $0x802d42,%rax
  803154:	00 00 00 
  803157:	ff d0                	callq  *%rax
}
  803159:	5d                   	pop    %rbp
  80315a:	c3                   	retq   

000000000080315b <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80315b:	55                   	push   %rbp
  80315c:	48 89 e5             	mov    %rsp,%rbp
  80315f:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  803166:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  80316d:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803174:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  80317b:	be 00 00 00 00       	mov    $0x0,%esi
  803180:	48 89 c7             	mov    %rax,%rdi
  803183:	48 b8 c9 2d 80 00 00 	movabs $0x802dc9,%rax
  80318a:	00 00 00 
  80318d:	ff d0                	callq  *%rax
  80318f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803192:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803196:	79 08                	jns    8031a0 <spawn+0x45>
		return r;
  803198:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80319b:	e9 14 03 00 00       	jmpq   8034b4 <spawn+0x359>
	fd = r;
  8031a0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031a3:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8031a6:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  8031ad:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8031b1:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8031b8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8031bb:	ba 00 02 00 00       	mov    $0x200,%edx
  8031c0:	48 89 ce             	mov    %rcx,%rsi
  8031c3:	89 c7                	mov    %eax,%edi
  8031c5:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  8031cc:	00 00 00 
  8031cf:	ff d0                	callq  *%rax
  8031d1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8031d6:	75 0d                	jne    8031e5 <spawn+0x8a>
	    || elf->e_magic != ELF_MAGIC) {
  8031d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031dc:	8b 00                	mov    (%rax),%eax
  8031de:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8031e3:	74 43                	je     803228 <spawn+0xcd>
		close(fd);
  8031e5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8031e8:	89 c7                	mov    %eax,%edi
  8031ea:	48 b8 d1 26 80 00 00 	movabs $0x8026d1,%rax
  8031f1:	00 00 00 
  8031f4:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8031f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031fa:	8b 00                	mov    (%rax),%eax
  8031fc:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803201:	89 c6                	mov    %eax,%esi
  803203:	48 bf 68 50 80 00 00 	movabs $0x805068,%rdi
  80320a:	00 00 00 
  80320d:	b8 00 00 00 00       	mov    $0x0,%eax
  803212:	48 b9 94 05 80 00 00 	movabs $0x800594,%rcx
  803219:	00 00 00 
  80321c:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  80321e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803223:	e9 8c 02 00 00       	jmpq   8034b4 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  803228:	b8 07 00 00 00       	mov    $0x7,%eax
  80322d:	cd 30                	int    $0x30
  80322f:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803232:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803235:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803238:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80323c:	79 08                	jns    803246 <spawn+0xeb>
		return r;
  80323e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803241:	e9 6e 02 00 00       	jmpq   8034b4 <spawn+0x359>
	child = r;
  803246:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803249:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80324c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80324f:	25 ff 03 00 00       	and    $0x3ff,%eax
  803254:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80325b:	00 00 00 
  80325e:	48 63 d0             	movslq %eax,%rdx
  803261:	48 89 d0             	mov    %rdx,%rax
  803264:	48 c1 e0 03          	shl    $0x3,%rax
  803268:	48 01 d0             	add    %rdx,%rax
  80326b:	48 c1 e0 05          	shl    $0x5,%rax
  80326f:	48 01 c8             	add    %rcx,%rax
  803272:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803279:	48 89 c6             	mov    %rax,%rsi
  80327c:	b8 18 00 00 00       	mov    $0x18,%eax
  803281:	48 89 d7             	mov    %rdx,%rdi
  803284:	48 89 c1             	mov    %rax,%rcx
  803287:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  80328a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80328e:	48 8b 40 18          	mov    0x18(%rax),%rax
  803292:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803299:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8032a0:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8032a7:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  8032ae:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8032b1:	48 89 ce             	mov    %rcx,%rsi
  8032b4:	89 c7                	mov    %eax,%edi
  8032b6:	48 b8 1e 37 80 00 00 	movabs $0x80371e,%rax
  8032bd:	00 00 00 
  8032c0:	ff d0                	callq  *%rax
  8032c2:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8032c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8032c9:	79 08                	jns    8032d3 <spawn+0x178>
		return r;
  8032cb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032ce:	e9 e1 01 00 00       	jmpq   8034b4 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8032d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032d7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8032db:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  8032e2:	48 01 d0             	add    %rdx,%rax
  8032e5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8032e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8032f0:	e9 a3 00 00 00       	jmpq   803398 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  8032f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f9:	8b 00                	mov    (%rax),%eax
  8032fb:	83 f8 01             	cmp    $0x1,%eax
  8032fe:	74 05                	je     803305 <spawn+0x1aa>
			continue;
  803300:	e9 8a 00 00 00       	jmpq   80338f <spawn+0x234>
		perm = PTE_P | PTE_U;
  803305:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80330c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803310:	8b 40 04             	mov    0x4(%rax),%eax
  803313:	83 e0 02             	and    $0x2,%eax
  803316:	85 c0                	test   %eax,%eax
  803318:	74 04                	je     80331e <spawn+0x1c3>
			perm |= PTE_W;
  80331a:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  80331e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803322:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803326:	41 89 c1             	mov    %eax,%r9d
  803329:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80332d:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803331:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803335:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803339:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333d:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803341:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803344:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803347:	8b 7d ec             	mov    -0x14(%rbp),%edi
  80334a:	89 3c 24             	mov    %edi,(%rsp)
  80334d:	89 c7                	mov    %eax,%edi
  80334f:	48 b8 c7 39 80 00 00 	movabs $0x8039c7,%rax
  803356:	00 00 00 
  803359:	ff d0                	callq  *%rax
  80335b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80335e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803362:	79 2b                	jns    80338f <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803364:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803365:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803368:	89 c7                	mov    %eax,%edi
  80336a:	48 b8 ab 1b 80 00 00 	movabs $0x801bab,%rax
  803371:	00 00 00 
  803374:	ff d0                	callq  *%rax
	close(fd);
  803376:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803379:	89 c7                	mov    %eax,%edi
  80337b:	48 b8 d1 26 80 00 00 	movabs $0x8026d1,%rax
  803382:	00 00 00 
  803385:	ff d0                	callq  *%rax
	return r;
  803387:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80338a:	e9 25 01 00 00       	jmpq   8034b4 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80338f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803393:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803398:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80339c:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8033a0:	0f b7 c0             	movzwl %ax,%eax
  8033a3:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8033a6:	0f 8f 49 ff ff ff    	jg     8032f5 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8033ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8033af:	89 c7                	mov    %eax,%edi
  8033b1:	48 b8 d1 26 80 00 00 	movabs $0x8026d1,%rax
  8033b8:	00 00 00 
  8033bb:	ff d0                	callq  *%rax
	fd = -1;
  8033bd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8033c4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8033c7:	89 c7                	mov    %eax,%edi
  8033c9:	48 b8 b3 3b 80 00 00 	movabs $0x803bb3,%rax
  8033d0:	00 00 00 
  8033d3:	ff d0                	callq  *%rax
  8033d5:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8033d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8033dc:	79 30                	jns    80340e <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  8033de:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8033e1:	89 c1                	mov    %eax,%ecx
  8033e3:	48 ba 82 50 80 00 00 	movabs $0x805082,%rdx
  8033ea:	00 00 00 
  8033ed:	be 82 00 00 00       	mov    $0x82,%esi
  8033f2:	48 bf 98 50 80 00 00 	movabs $0x805098,%rdi
  8033f9:	00 00 00 
  8033fc:	b8 00 00 00 00       	mov    $0x0,%eax
  803401:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  803408:	00 00 00 
  80340b:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80340e:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803415:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803418:	48 89 d6             	mov    %rdx,%rsi
  80341b:	89 c7                	mov    %eax,%edi
  80341d:	48 b8 ab 1d 80 00 00 	movabs $0x801dab,%rax
  803424:	00 00 00 
  803427:	ff d0                	callq  *%rax
  803429:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80342c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803430:	79 30                	jns    803462 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  803432:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803435:	89 c1                	mov    %eax,%ecx
  803437:	48 ba a4 50 80 00 00 	movabs $0x8050a4,%rdx
  80343e:	00 00 00 
  803441:	be 85 00 00 00       	mov    $0x85,%esi
  803446:	48 bf 98 50 80 00 00 	movabs $0x805098,%rdi
  80344d:	00 00 00 
  803450:	b8 00 00 00 00       	mov    $0x0,%eax
  803455:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  80345c:	00 00 00 
  80345f:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803462:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803465:	be 02 00 00 00       	mov    $0x2,%esi
  80346a:	89 c7                	mov    %eax,%edi
  80346c:	48 b8 60 1d 80 00 00 	movabs $0x801d60,%rax
  803473:	00 00 00 
  803476:	ff d0                	callq  *%rax
  803478:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80347b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80347f:	79 30                	jns    8034b1 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  803481:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803484:	89 c1                	mov    %eax,%ecx
  803486:	48 ba be 50 80 00 00 	movabs $0x8050be,%rdx
  80348d:	00 00 00 
  803490:	be 88 00 00 00       	mov    $0x88,%esi
  803495:	48 bf 98 50 80 00 00 	movabs $0x805098,%rdi
  80349c:	00 00 00 
  80349f:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a4:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  8034ab:	00 00 00 
  8034ae:	41 ff d0             	callq  *%r8

	return child;
  8034b1:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8034b4:	c9                   	leaveq 
  8034b5:	c3                   	retq   

00000000008034b6 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8034b6:	55                   	push   %rbp
  8034b7:	48 89 e5             	mov    %rsp,%rbp
  8034ba:	41 55                	push   %r13
  8034bc:	41 54                	push   %r12
  8034be:	53                   	push   %rbx
  8034bf:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8034c6:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8034cd:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8034d4:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  8034db:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  8034e2:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  8034e9:	84 c0                	test   %al,%al
  8034eb:	74 26                	je     803513 <spawnl+0x5d>
  8034ed:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  8034f4:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  8034fb:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  8034ff:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803503:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803507:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  80350b:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  80350f:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803513:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  80351a:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803521:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803524:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80352b:	00 00 00 
  80352e:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803535:	00 00 00 
  803538:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80353c:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803543:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80354a:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while (va_arg(vl, void *) != NULL)
  803551:	eb 07                	jmp    80355a <spawnl+0xa4>
		argc++;
  803553:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  80355a:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803560:	83 f8 30             	cmp    $0x30,%eax
  803563:	73 23                	jae    803588 <spawnl+0xd2>
  803565:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80356c:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803572:	89 c0                	mov    %eax,%eax
  803574:	48 01 d0             	add    %rdx,%rax
  803577:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80357d:	83 c2 08             	add    $0x8,%edx
  803580:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803586:	eb 15                	jmp    80359d <spawnl+0xe7>
  803588:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  80358f:	48 89 d0             	mov    %rdx,%rax
  803592:	48 83 c2 08          	add    $0x8,%rdx
  803596:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80359d:	48 8b 00             	mov    (%rax),%rax
  8035a0:	48 85 c0             	test   %rax,%rax
  8035a3:	75 ae                	jne    803553 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8035a5:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8035ab:	83 c0 02             	add    $0x2,%eax
  8035ae:	48 89 e2             	mov    %rsp,%rdx
  8035b1:	48 89 d3             	mov    %rdx,%rbx
  8035b4:	48 63 d0             	movslq %eax,%rdx
  8035b7:	48 83 ea 01          	sub    $0x1,%rdx
  8035bb:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8035c2:	48 63 d0             	movslq %eax,%rdx
  8035c5:	49 89 d4             	mov    %rdx,%r12
  8035c8:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8035ce:	48 63 d0             	movslq %eax,%rdx
  8035d1:	49 89 d2             	mov    %rdx,%r10
  8035d4:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  8035da:	48 98                	cltq   
  8035dc:	48 c1 e0 03          	shl    $0x3,%rax
  8035e0:	48 8d 50 07          	lea    0x7(%rax),%rdx
  8035e4:	b8 10 00 00 00       	mov    $0x10,%eax
  8035e9:	48 83 e8 01          	sub    $0x1,%rax
  8035ed:	48 01 d0             	add    %rdx,%rax
  8035f0:	bf 10 00 00 00       	mov    $0x10,%edi
  8035f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8035fa:	48 f7 f7             	div    %rdi
  8035fd:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803601:	48 29 c4             	sub    %rax,%rsp
  803604:	48 89 e0             	mov    %rsp,%rax
  803607:	48 83 c0 07          	add    $0x7,%rax
  80360b:	48 c1 e8 03          	shr    $0x3,%rax
  80360f:	48 c1 e0 03          	shl    $0x3,%rax
  803613:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  80361a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803621:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803628:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  80362b:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803631:	8d 50 01             	lea    0x1(%rax),%edx
  803634:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80363b:	48 63 d2             	movslq %edx,%rdx
  80363e:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803645:	00 

	va_start(vl, arg0);
  803646:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80364d:	00 00 00 
  803650:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803657:	00 00 00 
  80365a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80365e:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803665:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80366c:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for (i = 0; i < argc; i++)
  803673:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  80367a:	00 00 00 
  80367d:	eb 63                	jmp    8036e2 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  80367f:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803685:	8d 70 01             	lea    0x1(%rax),%esi
  803688:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80368e:	83 f8 30             	cmp    $0x30,%eax
  803691:	73 23                	jae    8036b6 <spawnl+0x200>
  803693:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  80369a:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8036a0:	89 c0                	mov    %eax,%eax
  8036a2:	48 01 d0             	add    %rdx,%rax
  8036a5:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8036ab:	83 c2 08             	add    $0x8,%edx
  8036ae:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8036b4:	eb 15                	jmp    8036cb <spawnl+0x215>
  8036b6:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8036bd:	48 89 d0             	mov    %rdx,%rax
  8036c0:	48 83 c2 08          	add    $0x8,%rdx
  8036c4:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8036cb:	48 8b 08             	mov    (%rax),%rcx
  8036ce:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8036d5:	89 f2                	mov    %esi,%edx
  8036d7:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  8036db:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8036e2:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8036e8:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  8036ee:	77 8f                	ja     80367f <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8036f0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8036f7:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  8036fe:	48 89 d6             	mov    %rdx,%rsi
  803701:	48 89 c7             	mov    %rax,%rdi
  803704:	48 b8 5b 31 80 00 00 	movabs $0x80315b,%rax
  80370b:	00 00 00 
  80370e:	ff d0                	callq  *%rax
  803710:	48 89 dc             	mov    %rbx,%rsp
}
  803713:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803717:	5b                   	pop    %rbx
  803718:	41 5c                	pop    %r12
  80371a:	41 5d                	pop    %r13
  80371c:	5d                   	pop    %rbp
  80371d:	c3                   	retq   

000000000080371e <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  80371e:	55                   	push   %rbp
  80371f:	48 89 e5             	mov    %rsp,%rbp
  803722:	48 83 ec 50          	sub    $0x50,%rsp
  803726:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803729:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80372d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803731:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803738:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803739:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803740:	eb 33                	jmp    803775 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803742:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803745:	48 98                	cltq   
  803747:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80374e:	00 
  80374f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803753:	48 01 d0             	add    %rdx,%rax
  803756:	48 8b 00             	mov    (%rax),%rax
  803759:	48 89 c7             	mov    %rax,%rdi
  80375c:	48 b8 d0 12 80 00 00 	movabs $0x8012d0,%rax
  803763:	00 00 00 
  803766:	ff d0                	callq  *%rax
  803768:	83 c0 01             	add    $0x1,%eax
  80376b:	48 98                	cltq   
  80376d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803771:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803775:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803778:	48 98                	cltq   
  80377a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803781:	00 
  803782:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803786:	48 01 d0             	add    %rdx,%rax
  803789:	48 8b 00             	mov    (%rax),%rax
  80378c:	48 85 c0             	test   %rax,%rax
  80378f:	75 b1                	jne    803742 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803791:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803795:	48 f7 d8             	neg    %rax
  803798:	48 05 00 10 40 00    	add    $0x401000,%rax
  80379e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8037a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037a6:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8037aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037ae:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8037b2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8037b5:	83 c2 01             	add    $0x1,%edx
  8037b8:	c1 e2 03             	shl    $0x3,%edx
  8037bb:	48 63 d2             	movslq %edx,%rdx
  8037be:	48 f7 da             	neg    %rdx
  8037c1:	48 01 d0             	add    %rdx,%rax
  8037c4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8037c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037cc:	48 83 e8 10          	sub    $0x10,%rax
  8037d0:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8037d6:	77 0a                	ja     8037e2 <init_stack+0xc4>
		return -E_NO_MEM;
  8037d8:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8037dd:	e9 e3 01 00 00       	jmpq   8039c5 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8037e2:	ba 07 00 00 00       	mov    $0x7,%edx
  8037e7:	be 00 00 40 00       	mov    $0x400000,%esi
  8037ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8037f1:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  8037f8:	00 00 00 
  8037fb:	ff d0                	callq  *%rax
  8037fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803800:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803804:	79 08                	jns    80380e <init_stack+0xf0>
		return r;
  803806:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803809:	e9 b7 01 00 00       	jmpq   8039c5 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80380e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803815:	e9 8a 00 00 00       	jmpq   8038a4 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  80381a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80381d:	48 98                	cltq   
  80381f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803826:	00 
  803827:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80382b:	48 01 c2             	add    %rax,%rdx
  80382e:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803833:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803837:	48 01 c8             	add    %rcx,%rax
  80383a:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803840:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803843:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803846:	48 98                	cltq   
  803848:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80384f:	00 
  803850:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803854:	48 01 d0             	add    %rdx,%rax
  803857:	48 8b 10             	mov    (%rax),%rdx
  80385a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80385e:	48 89 d6             	mov    %rdx,%rsi
  803861:	48 89 c7             	mov    %rax,%rdi
  803864:	48 b8 3c 13 80 00 00 	movabs $0x80133c,%rax
  80386b:	00 00 00 
  80386e:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803870:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803873:	48 98                	cltq   
  803875:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80387c:	00 
  80387d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803881:	48 01 d0             	add    %rdx,%rax
  803884:	48 8b 00             	mov    (%rax),%rax
  803887:	48 89 c7             	mov    %rax,%rdi
  80388a:	48 b8 d0 12 80 00 00 	movabs $0x8012d0,%rax
  803891:	00 00 00 
  803894:	ff d0                	callq  *%rax
  803896:	48 98                	cltq   
  803898:	48 83 c0 01          	add    $0x1,%rax
  80389c:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8038a0:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8038a4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8038a7:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8038aa:	0f 8c 6a ff ff ff    	jl     80381a <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8038b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8038b3:	48 98                	cltq   
  8038b5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8038bc:	00 
  8038bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038c1:	48 01 d0             	add    %rdx,%rax
  8038c4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8038cb:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8038d2:	00 
  8038d3:	74 35                	je     80390a <init_stack+0x1ec>
  8038d5:	48 b9 d8 50 80 00 00 	movabs $0x8050d8,%rcx
  8038dc:	00 00 00 
  8038df:	48 ba fe 50 80 00 00 	movabs $0x8050fe,%rdx
  8038e6:	00 00 00 
  8038e9:	be f1 00 00 00       	mov    $0xf1,%esi
  8038ee:	48 bf 98 50 80 00 00 	movabs $0x805098,%rdi
  8038f5:	00 00 00 
  8038f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8038fd:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  803904:	00 00 00 
  803907:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80390a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80390e:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803912:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803917:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80391b:	48 01 c8             	add    %rcx,%rax
  80391e:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803924:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803927:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80392b:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  80392f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803932:	48 98                	cltq   
  803934:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803937:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  80393c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803940:	48 01 d0             	add    %rdx,%rax
  803943:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803949:	48 89 c2             	mov    %rax,%rdx
  80394c:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803950:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803953:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803956:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80395c:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803961:	89 c2                	mov    %eax,%edx
  803963:	be 00 00 40 00       	mov    $0x400000,%esi
  803968:	bf 00 00 00 00       	mov    $0x0,%edi
  80396d:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  803974:	00 00 00 
  803977:	ff d0                	callq  *%rax
  803979:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80397c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803980:	79 02                	jns    803984 <init_stack+0x266>
		goto error;
  803982:	eb 28                	jmp    8039ac <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803984:	be 00 00 40 00       	mov    $0x400000,%esi
  803989:	bf 00 00 00 00       	mov    $0x0,%edi
  80398e:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  803995:	00 00 00 
  803998:	ff d0                	callq  *%rax
  80399a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80399d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039a1:	79 02                	jns    8039a5 <init_stack+0x287>
		goto error;
  8039a3:	eb 07                	jmp    8039ac <init_stack+0x28e>

	return 0;
  8039a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8039aa:	eb 19                	jmp    8039c5 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  8039ac:	be 00 00 40 00       	mov    $0x400000,%esi
  8039b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8039b6:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  8039bd:	00 00 00 
  8039c0:	ff d0                	callq  *%rax
	return r;
  8039c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8039c5:	c9                   	leaveq 
  8039c6:	c3                   	retq   

00000000008039c7 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  8039c7:	55                   	push   %rbp
  8039c8:	48 89 e5             	mov    %rsp,%rbp
  8039cb:	48 83 ec 50          	sub    $0x50,%rsp
  8039cf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8039d2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039d6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8039da:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8039dd:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8039e1:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8039e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039e9:	25 ff 0f 00 00       	and    $0xfff,%eax
  8039ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039f5:	74 21                	je     803a18 <map_segment+0x51>
		va -= i;
  8039f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039fa:	48 98                	cltq   
  8039fc:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803a00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a03:	48 98                	cltq   
  803a05:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803a09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a0c:	48 98                	cltq   
  803a0e:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803a12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a15:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803a18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a1f:	e9 79 01 00 00       	jmpq   803b9d <map_segment+0x1d6>
		if (i >= filesz) {
  803a24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a27:	48 98                	cltq   
  803a29:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803a2d:	72 3c                	jb     803a6b <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803a2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a32:	48 63 d0             	movslq %eax,%rdx
  803a35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a39:	48 01 d0             	add    %rdx,%rax
  803a3c:	48 89 c1             	mov    %rax,%rcx
  803a3f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a42:	8b 55 10             	mov    0x10(%rbp),%edx
  803a45:	48 89 ce             	mov    %rcx,%rsi
  803a48:	89 c7                	mov    %eax,%edi
  803a4a:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  803a51:	00 00 00 
  803a54:	ff d0                	callq  *%rax
  803a56:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803a59:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803a5d:	0f 89 33 01 00 00    	jns    803b96 <map_segment+0x1cf>
				return r;
  803a63:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a66:	e9 46 01 00 00       	jmpq   803bb1 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803a6b:	ba 07 00 00 00       	mov    $0x7,%edx
  803a70:	be 00 00 40 00       	mov    $0x400000,%esi
  803a75:	bf 00 00 00 00       	mov    $0x0,%edi
  803a7a:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  803a81:	00 00 00 
  803a84:	ff d0                	callq  *%rax
  803a86:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803a89:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803a8d:	79 08                	jns    803a97 <map_segment+0xd0>
				return r;
  803a8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a92:	e9 1a 01 00 00       	jmpq   803bb1 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803a97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a9a:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803a9d:	01 c2                	add    %eax,%edx
  803a9f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803aa2:	89 d6                	mov    %edx,%esi
  803aa4:	89 c7                	mov    %eax,%edi
  803aa6:	48 b8 11 2b 80 00 00 	movabs $0x802b11,%rax
  803aad:	00 00 00 
  803ab0:	ff d0                	callq  *%rax
  803ab2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ab5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ab9:	79 08                	jns    803ac3 <map_segment+0xfc>
				return r;
  803abb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803abe:	e9 ee 00 00 00       	jmpq   803bb1 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803ac3:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803aca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803acd:	48 98                	cltq   
  803acf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803ad3:	48 29 c2             	sub    %rax,%rdx
  803ad6:	48 89 d0             	mov    %rdx,%rax
  803ad9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803add:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ae0:	48 63 d0             	movslq %eax,%rdx
  803ae3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ae7:	48 39 c2             	cmp    %rax,%rdx
  803aea:	48 0f 47 d0          	cmova  %rax,%rdx
  803aee:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803af1:	be 00 00 40 00       	mov    $0x400000,%esi
  803af6:	89 c7                	mov    %eax,%edi
  803af8:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  803aff:	00 00 00 
  803b02:	ff d0                	callq  *%rax
  803b04:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b07:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b0b:	79 08                	jns    803b15 <map_segment+0x14e>
				return r;
  803b0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b10:	e9 9c 00 00 00       	jmpq   803bb1 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803b15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b18:	48 63 d0             	movslq %eax,%rdx
  803b1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b1f:	48 01 d0             	add    %rdx,%rax
  803b22:	48 89 c2             	mov    %rax,%rdx
  803b25:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b28:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803b2c:	48 89 d1             	mov    %rdx,%rcx
  803b2f:	89 c2                	mov    %eax,%edx
  803b31:	be 00 00 40 00       	mov    $0x400000,%esi
  803b36:	bf 00 00 00 00       	mov    $0x0,%edi
  803b3b:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  803b42:	00 00 00 
  803b45:	ff d0                	callq  *%rax
  803b47:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b4a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b4e:	79 30                	jns    803b80 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803b50:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b53:	89 c1                	mov    %eax,%ecx
  803b55:	48 ba 13 51 80 00 00 	movabs $0x805113,%rdx
  803b5c:	00 00 00 
  803b5f:	be 24 01 00 00       	mov    $0x124,%esi
  803b64:	48 bf 98 50 80 00 00 	movabs $0x805098,%rdi
  803b6b:	00 00 00 
  803b6e:	b8 00 00 00 00       	mov    $0x0,%eax
  803b73:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  803b7a:	00 00 00 
  803b7d:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803b80:	be 00 00 40 00       	mov    $0x400000,%esi
  803b85:	bf 00 00 00 00       	mov    $0x0,%edi
  803b8a:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  803b91:	00 00 00 
  803b94:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803b96:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803b9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba0:	48 98                	cltq   
  803ba2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ba6:	0f 82 78 fe ff ff    	jb     803a24 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803bac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bb1:	c9                   	leaveq 
  803bb2:	c3                   	retq   

0000000000803bb3 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803bb3:	55                   	push   %rbp
  803bb4:	48 89 e5             	mov    %rsp,%rbp
  803bb7:	48 83 ec 50          	sub    $0x50,%rsp
  803bbb:	89 7d bc             	mov    %edi,-0x44(%rbp)
	// LAB 5: Your code here.
	// note: just copied and modified from lib/fork.c, function envid_t fork(void)
	void *addr;
	int r;
	pte_t i, j, k, l, ptx = 0;
  803bbe:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803bc5:	00 

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  803bc6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803bcd:	00 
  803bce:	e9 62 01 00 00       	jmpq   803d35 <copy_shared_pages+0x182>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  803bd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bd7:	48 c1 e8 1b          	shr    $0x1b,%rax
  803bdb:	48 89 c2             	mov    %rax,%rdx
  803bde:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803be5:	01 00 00 
  803be8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bec:	83 e0 01             	and    $0x1,%eax
  803bef:	48 85 c0             	test   %rax,%rax
  803bf2:	75 0d                	jne    803c01 <copy_shared_pages+0x4e>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  803bf4:	48 81 45 d8 00 00 00 	addq   $0x8000000,-0x28(%rbp)
  803bfb:	08 
			continue;
  803bfc:	e9 2f 01 00 00       	jmpq   803d30 <copy_shared_pages+0x17d>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  803c01:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803c08:	00 
  803c09:	e9 14 01 00 00       	jmpq   803d22 <copy_shared_pages+0x16f>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  803c0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c12:	48 c1 e8 12          	shr    $0x12,%rax
  803c16:	48 89 c2             	mov    %rax,%rdx
  803c19:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803c20:	01 00 00 
  803c23:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c27:	83 e0 01             	and    $0x1,%eax
  803c2a:	48 85 c0             	test   %rax,%rax
  803c2d:	75 0d                	jne    803c3c <copy_shared_pages+0x89>
				ptx += NPDENTRIES * NPTENTRIES;
  803c2f:	48 81 45 d8 00 00 04 	addq   $0x40000,-0x28(%rbp)
  803c36:	00 
				continue;
  803c37:	e9 e1 00 00 00       	jmpq   803d1d <copy_shared_pages+0x16a>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  803c3c:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803c43:	00 
  803c44:	e9 c6 00 00 00       	jmpq   803d0f <copy_shared_pages+0x15c>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  803c49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c4d:	48 c1 e8 09          	shr    $0x9,%rax
  803c51:	48 89 c2             	mov    %rax,%rdx
  803c54:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c5b:	01 00 00 
  803c5e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c62:	83 e0 01             	and    $0x1,%eax
  803c65:	48 85 c0             	test   %rax,%rax
  803c68:	75 0d                	jne    803c77 <copy_shared_pages+0xc4>
					ptx += NPTENTRIES;
  803c6a:	48 81 45 d8 00 02 00 	addq   $0x200,-0x28(%rbp)
  803c71:	00 
					continue;
  803c72:	e9 93 00 00 00       	jmpq   803d0a <copy_shared_pages+0x157>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  803c77:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  803c7e:	00 
  803c7f:	eb 7b                	jmp    803cfc <copy_shared_pages+0x149>
					if ((uvpt[ptx] & PTE_SHARE) != 0) {
  803c81:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c88:	01 00 00 
  803c8b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803c8f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c93:	25 00 04 00 00       	and    $0x400,%eax
  803c98:	48 85 c0             	test   %rax,%rax
  803c9b:	74 55                	je     803cf2 <copy_shared_pages+0x13f>
						addr = (void *)(ptx * PGSIZE);
  803c9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ca1:	48 c1 e0 0c          	shl    $0xc,%rax
  803ca5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
						if ((r = sys_page_map(0, addr, child, addr, uvpt[ptx] & PTE_SYSCALL)) < 0)
  803ca9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803cb0:	01 00 00 
  803cb3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803cb7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cbb:	25 07 0e 00 00       	and    $0xe07,%eax
  803cc0:	89 c6                	mov    %eax,%esi
  803cc2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803cc6:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803cc9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ccd:	41 89 f0             	mov    %esi,%r8d
  803cd0:	48 89 c6             	mov    %rax,%rsi
  803cd3:	bf 00 00 00 00       	mov    $0x0,%edi
  803cd8:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  803cdf:	00 00 00 
  803ce2:	ff d0                	callq  *%rax
  803ce4:	89 45 cc             	mov    %eax,-0x34(%rbp)
  803ce7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803ceb:	79 05                	jns    803cf2 <copy_shared_pages+0x13f>
							return r;
  803ced:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803cf0:	eb 53                	jmp    803d45 <copy_shared_pages+0x192>
					}
					ptx++;
  803cf2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  803cf7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  803cfc:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  803d03:	00 
  803d04:	0f 86 77 ff ff ff    	jbe    803c81 <copy_shared_pages+0xce>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  803d0a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803d0f:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  803d16:	00 
  803d17:	0f 86 2c ff ff ff    	jbe    803c49 <copy_shared_pages+0x96>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  803d1d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  803d22:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  803d29:	00 
  803d2a:	0f 86 de fe ff ff    	jbe    803c0e <copy_shared_pages+0x5b>
	int r;
	pte_t i, j, k, l, ptx = 0;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  803d30:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d35:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d3a:	0f 84 93 fe ff ff    	je     803bd3 <copy_shared_pages+0x20>
				}
			}
		}
	}

	return 0;
  803d40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d45:	c9                   	leaveq 
  803d46:	c3                   	retq   

0000000000803d47 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803d47:	55                   	push   %rbp
  803d48:	48 89 e5             	mov    %rsp,%rbp
  803d4b:	53                   	push   %rbx
  803d4c:	48 83 ec 38          	sub    $0x38,%rsp
  803d50:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803d54:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803d58:	48 89 c7             	mov    %rax,%rdi
  803d5b:	48 b8 29 24 80 00 00 	movabs $0x802429,%rax
  803d62:	00 00 00 
  803d65:	ff d0                	callq  *%rax
  803d67:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d6e:	0f 88 bf 01 00 00    	js     803f33 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d78:	ba 07 04 00 00       	mov    $0x407,%edx
  803d7d:	48 89 c6             	mov    %rax,%rsi
  803d80:	bf 00 00 00 00       	mov    $0x0,%edi
  803d85:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  803d8c:	00 00 00 
  803d8f:	ff d0                	callq  *%rax
  803d91:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d94:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d98:	0f 88 95 01 00 00    	js     803f33 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803d9e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803da2:	48 89 c7             	mov    %rax,%rdi
  803da5:	48 b8 29 24 80 00 00 	movabs $0x802429,%rax
  803dac:	00 00 00 
  803daf:	ff d0                	callq  *%rax
  803db1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803db4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803db8:	0f 88 5d 01 00 00    	js     803f1b <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803dbe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dc2:	ba 07 04 00 00       	mov    $0x407,%edx
  803dc7:	48 89 c6             	mov    %rax,%rsi
  803dca:	bf 00 00 00 00       	mov    $0x0,%edi
  803dcf:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  803dd6:	00 00 00 
  803dd9:	ff d0                	callq  *%rax
  803ddb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dde:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803de2:	0f 88 33 01 00 00    	js     803f1b <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803de8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dec:	48 89 c7             	mov    %rax,%rdi
  803def:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  803df6:	00 00 00 
  803df9:	ff d0                	callq  *%rax
  803dfb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803dff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e03:	ba 07 04 00 00       	mov    $0x407,%edx
  803e08:	48 89 c6             	mov    %rax,%rsi
  803e0b:	bf 00 00 00 00       	mov    $0x0,%edi
  803e10:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  803e17:	00 00 00 
  803e1a:	ff d0                	callq  *%rax
  803e1c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e23:	79 05                	jns    803e2a <pipe+0xe3>
		goto err2;
  803e25:	e9 d9 00 00 00       	jmpq   803f03 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e2e:	48 89 c7             	mov    %rax,%rdi
  803e31:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  803e38:	00 00 00 
  803e3b:	ff d0                	callq  *%rax
  803e3d:	48 89 c2             	mov    %rax,%rdx
  803e40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e44:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803e4a:	48 89 d1             	mov    %rdx,%rcx
  803e4d:	ba 00 00 00 00       	mov    $0x0,%edx
  803e52:	48 89 c6             	mov    %rax,%rsi
  803e55:	bf 00 00 00 00       	mov    $0x0,%edi
  803e5a:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  803e61:	00 00 00 
  803e64:	ff d0                	callq  *%rax
  803e66:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e69:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e6d:	79 1b                	jns    803e8a <pipe+0x143>
		goto err3;
  803e6f:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803e70:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e74:	48 89 c6             	mov    %rax,%rsi
  803e77:	bf 00 00 00 00       	mov    $0x0,%edi
  803e7c:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  803e83:	00 00 00 
  803e86:	ff d0                	callq  *%rax
  803e88:	eb 79                	jmp    803f03 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803e8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e8e:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803e95:	00 00 00 
  803e98:	8b 12                	mov    (%rdx),%edx
  803e9a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803e9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ea0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803ea7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803eab:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803eb2:	00 00 00 
  803eb5:	8b 12                	mov    (%rdx),%edx
  803eb7:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803eb9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ebd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803ec4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ec8:	48 89 c7             	mov    %rax,%rdi
  803ecb:	48 b8 db 23 80 00 00 	movabs $0x8023db,%rax
  803ed2:	00 00 00 
  803ed5:	ff d0                	callq  *%rax
  803ed7:	89 c2                	mov    %eax,%edx
  803ed9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803edd:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803edf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ee3:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803ee7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803eeb:	48 89 c7             	mov    %rax,%rdi
  803eee:	48 b8 db 23 80 00 00 	movabs $0x8023db,%rax
  803ef5:	00 00 00 
  803ef8:	ff d0                	callq  *%rax
  803efa:	89 03                	mov    %eax,(%rbx)
	return 0;
  803efc:	b8 00 00 00 00       	mov    $0x0,%eax
  803f01:	eb 33                	jmp    803f36 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803f03:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f07:	48 89 c6             	mov    %rax,%rsi
  803f0a:	bf 00 00 00 00       	mov    $0x0,%edi
  803f0f:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  803f16:	00 00 00 
  803f19:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803f1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f1f:	48 89 c6             	mov    %rax,%rsi
  803f22:	bf 00 00 00 00       	mov    $0x0,%edi
  803f27:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  803f2e:	00 00 00 
  803f31:	ff d0                	callq  *%rax
    err:
	return r;
  803f33:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803f36:	48 83 c4 38          	add    $0x38,%rsp
  803f3a:	5b                   	pop    %rbx
  803f3b:	5d                   	pop    %rbp
  803f3c:	c3                   	retq   

0000000000803f3d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803f3d:	55                   	push   %rbp
  803f3e:	48 89 e5             	mov    %rsp,%rbp
  803f41:	53                   	push   %rbx
  803f42:	48 83 ec 28          	sub    $0x28,%rsp
  803f46:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f4a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803f4e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f55:	00 00 00 
  803f58:	48 8b 00             	mov    (%rax),%rax
  803f5b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f61:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803f64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f68:	48 89 c7             	mov    %rax,%rdi
  803f6b:	48 b8 38 49 80 00 00 	movabs $0x804938,%rax
  803f72:	00 00 00 
  803f75:	ff d0                	callq  *%rax
  803f77:	89 c3                	mov    %eax,%ebx
  803f79:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f7d:	48 89 c7             	mov    %rax,%rdi
  803f80:	48 b8 38 49 80 00 00 	movabs $0x804938,%rax
  803f87:	00 00 00 
  803f8a:	ff d0                	callq  *%rax
  803f8c:	39 c3                	cmp    %eax,%ebx
  803f8e:	0f 94 c0             	sete   %al
  803f91:	0f b6 c0             	movzbl %al,%eax
  803f94:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803f97:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f9e:	00 00 00 
  803fa1:	48 8b 00             	mov    (%rax),%rax
  803fa4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803faa:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803fad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fb0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803fb3:	75 05                	jne    803fba <_pipeisclosed+0x7d>
			return ret;
  803fb5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803fb8:	eb 4f                	jmp    804009 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803fba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fbd:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803fc0:	74 42                	je     804004 <_pipeisclosed+0xc7>
  803fc2:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803fc6:	75 3c                	jne    804004 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803fc8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fcf:	00 00 00 
  803fd2:	48 8b 00             	mov    (%rax),%rax
  803fd5:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803fdb:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803fde:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fe1:	89 c6                	mov    %eax,%esi
  803fe3:	48 bf 35 51 80 00 00 	movabs $0x805135,%rdi
  803fea:	00 00 00 
  803fed:	b8 00 00 00 00       	mov    $0x0,%eax
  803ff2:	49 b8 94 05 80 00 00 	movabs $0x800594,%r8
  803ff9:	00 00 00 
  803ffc:	41 ff d0             	callq  *%r8
	}
  803fff:	e9 4a ff ff ff       	jmpq   803f4e <_pipeisclosed+0x11>
  804004:	e9 45 ff ff ff       	jmpq   803f4e <_pipeisclosed+0x11>
}
  804009:	48 83 c4 28          	add    $0x28,%rsp
  80400d:	5b                   	pop    %rbx
  80400e:	5d                   	pop    %rbp
  80400f:	c3                   	retq   

0000000000804010 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804010:	55                   	push   %rbp
  804011:	48 89 e5             	mov    %rsp,%rbp
  804014:	48 83 ec 30          	sub    $0x30,%rsp
  804018:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80401b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80401f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804022:	48 89 d6             	mov    %rdx,%rsi
  804025:	89 c7                	mov    %eax,%edi
  804027:	48 b8 c1 24 80 00 00 	movabs $0x8024c1,%rax
  80402e:	00 00 00 
  804031:	ff d0                	callq  *%rax
  804033:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804036:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80403a:	79 05                	jns    804041 <pipeisclosed+0x31>
		return r;
  80403c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80403f:	eb 31                	jmp    804072 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804041:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804045:	48 89 c7             	mov    %rax,%rdi
  804048:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  80404f:	00 00 00 
  804052:	ff d0                	callq  *%rax
  804054:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804058:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80405c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804060:	48 89 d6             	mov    %rdx,%rsi
  804063:	48 89 c7             	mov    %rax,%rdi
  804066:	48 b8 3d 3f 80 00 00 	movabs $0x803f3d,%rax
  80406d:	00 00 00 
  804070:	ff d0                	callq  *%rax
}
  804072:	c9                   	leaveq 
  804073:	c3                   	retq   

0000000000804074 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804074:	55                   	push   %rbp
  804075:	48 89 e5             	mov    %rsp,%rbp
  804078:	48 83 ec 40          	sub    $0x40,%rsp
  80407c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804080:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804084:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804088:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80408c:	48 89 c7             	mov    %rax,%rdi
  80408f:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  804096:	00 00 00 
  804099:	ff d0                	callq  *%rax
  80409b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80409f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040a3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8040a7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8040ae:	00 
  8040af:	e9 92 00 00 00       	jmpq   804146 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8040b4:	eb 41                	jmp    8040f7 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8040b6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8040bb:	74 09                	je     8040c6 <devpipe_read+0x52>
				return i;
  8040bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040c1:	e9 92 00 00 00       	jmpq   804158 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8040c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040ce:	48 89 d6             	mov    %rdx,%rsi
  8040d1:	48 89 c7             	mov    %rax,%rdi
  8040d4:	48 b8 3d 3f 80 00 00 	movabs $0x803f3d,%rax
  8040db:	00 00 00 
  8040de:	ff d0                	callq  *%rax
  8040e0:	85 c0                	test   %eax,%eax
  8040e2:	74 07                	je     8040eb <devpipe_read+0x77>
				return 0;
  8040e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8040e9:	eb 6d                	jmp    804158 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8040eb:	48 b8 2d 1c 80 00 00 	movabs $0x801c2d,%rax
  8040f2:	00 00 00 
  8040f5:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8040f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040fb:	8b 10                	mov    (%rax),%edx
  8040fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804101:	8b 40 04             	mov    0x4(%rax),%eax
  804104:	39 c2                	cmp    %eax,%edx
  804106:	74 ae                	je     8040b6 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804108:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80410c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804110:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804114:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804118:	8b 00                	mov    (%rax),%eax
  80411a:	99                   	cltd   
  80411b:	c1 ea 1b             	shr    $0x1b,%edx
  80411e:	01 d0                	add    %edx,%eax
  804120:	83 e0 1f             	and    $0x1f,%eax
  804123:	29 d0                	sub    %edx,%eax
  804125:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804129:	48 98                	cltq   
  80412b:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804130:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804132:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804136:	8b 00                	mov    (%rax),%eax
  804138:	8d 50 01             	lea    0x1(%rax),%edx
  80413b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80413f:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804141:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80414a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80414e:	0f 82 60 ff ff ff    	jb     8040b4 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804154:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804158:	c9                   	leaveq 
  804159:	c3                   	retq   

000000000080415a <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80415a:	55                   	push   %rbp
  80415b:	48 89 e5             	mov    %rsp,%rbp
  80415e:	48 83 ec 40          	sub    $0x40,%rsp
  804162:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804166:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80416a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80416e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804172:	48 89 c7             	mov    %rax,%rdi
  804175:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  80417c:	00 00 00 
  80417f:	ff d0                	callq  *%rax
  804181:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804185:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804189:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80418d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804194:	00 
  804195:	e9 8e 00 00 00       	jmpq   804228 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80419a:	eb 31                	jmp    8041cd <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80419c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041a4:	48 89 d6             	mov    %rdx,%rsi
  8041a7:	48 89 c7             	mov    %rax,%rdi
  8041aa:	48 b8 3d 3f 80 00 00 	movabs $0x803f3d,%rax
  8041b1:	00 00 00 
  8041b4:	ff d0                	callq  *%rax
  8041b6:	85 c0                	test   %eax,%eax
  8041b8:	74 07                	je     8041c1 <devpipe_write+0x67>
				return 0;
  8041ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8041bf:	eb 79                	jmp    80423a <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8041c1:	48 b8 2d 1c 80 00 00 	movabs $0x801c2d,%rax
  8041c8:	00 00 00 
  8041cb:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8041cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041d1:	8b 40 04             	mov    0x4(%rax),%eax
  8041d4:	48 63 d0             	movslq %eax,%rdx
  8041d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041db:	8b 00                	mov    (%rax),%eax
  8041dd:	48 98                	cltq   
  8041df:	48 83 c0 20          	add    $0x20,%rax
  8041e3:	48 39 c2             	cmp    %rax,%rdx
  8041e6:	73 b4                	jae    80419c <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8041e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ec:	8b 40 04             	mov    0x4(%rax),%eax
  8041ef:	99                   	cltd   
  8041f0:	c1 ea 1b             	shr    $0x1b,%edx
  8041f3:	01 d0                	add    %edx,%eax
  8041f5:	83 e0 1f             	and    $0x1f,%eax
  8041f8:	29 d0                	sub    %edx,%eax
  8041fa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8041fe:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804202:	48 01 ca             	add    %rcx,%rdx
  804205:	0f b6 0a             	movzbl (%rdx),%ecx
  804208:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80420c:	48 98                	cltq   
  80420e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804212:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804216:	8b 40 04             	mov    0x4(%rax),%eax
  804219:	8d 50 01             	lea    0x1(%rax),%edx
  80421c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804220:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804223:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804228:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80422c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804230:	0f 82 64 ff ff ff    	jb     80419a <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804236:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80423a:	c9                   	leaveq 
  80423b:	c3                   	retq   

000000000080423c <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80423c:	55                   	push   %rbp
  80423d:	48 89 e5             	mov    %rsp,%rbp
  804240:	48 83 ec 20          	sub    $0x20,%rsp
  804244:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804248:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80424c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804250:	48 89 c7             	mov    %rax,%rdi
  804253:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  80425a:	00 00 00 
  80425d:	ff d0                	callq  *%rax
  80425f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804263:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804267:	48 be 48 51 80 00 00 	movabs $0x805148,%rsi
  80426e:	00 00 00 
  804271:	48 89 c7             	mov    %rax,%rdi
  804274:	48 b8 3c 13 80 00 00 	movabs $0x80133c,%rax
  80427b:	00 00 00 
  80427e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804284:	8b 50 04             	mov    0x4(%rax),%edx
  804287:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80428b:	8b 00                	mov    (%rax),%eax
  80428d:	29 c2                	sub    %eax,%edx
  80428f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804293:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804299:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80429d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8042a4:	00 00 00 
	stat->st_dev = &devpipe;
  8042a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042ab:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  8042b2:	00 00 00 
  8042b5:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8042bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042c1:	c9                   	leaveq 
  8042c2:	c3                   	retq   

00000000008042c3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8042c3:	55                   	push   %rbp
  8042c4:	48 89 e5             	mov    %rsp,%rbp
  8042c7:	48 83 ec 10          	sub    $0x10,%rsp
  8042cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8042cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042d3:	48 89 c6             	mov    %rax,%rsi
  8042d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8042db:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  8042e2:	00 00 00 
  8042e5:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8042e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042eb:	48 89 c7             	mov    %rax,%rdi
  8042ee:	48 b8 fe 23 80 00 00 	movabs $0x8023fe,%rax
  8042f5:	00 00 00 
  8042f8:	ff d0                	callq  *%rax
  8042fa:	48 89 c6             	mov    %rax,%rsi
  8042fd:	bf 00 00 00 00       	mov    $0x0,%edi
  804302:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  804309:	00 00 00 
  80430c:	ff d0                	callq  *%rax
}
  80430e:	c9                   	leaveq 
  80430f:	c3                   	retq   

0000000000804310 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804310:	55                   	push   %rbp
  804311:	48 89 e5             	mov    %rsp,%rbp
  804314:	48 83 ec 20          	sub    $0x20,%rsp
  804318:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  80431b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80431f:	75 35                	jne    804356 <wait+0x46>
  804321:	48 b9 4f 51 80 00 00 	movabs $0x80514f,%rcx
  804328:	00 00 00 
  80432b:	48 ba 5a 51 80 00 00 	movabs $0x80515a,%rdx
  804332:	00 00 00 
  804335:	be 09 00 00 00       	mov    $0x9,%esi
  80433a:	48 bf 6f 51 80 00 00 	movabs $0x80516f,%rdi
  804341:	00 00 00 
  804344:	b8 00 00 00 00       	mov    $0x0,%eax
  804349:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  804350:	00 00 00 
  804353:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804356:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804359:	25 ff 03 00 00       	and    $0x3ff,%eax
  80435e:	48 63 d0             	movslq %eax,%rdx
  804361:	48 89 d0             	mov    %rdx,%rax
  804364:	48 c1 e0 03          	shl    $0x3,%rax
  804368:	48 01 d0             	add    %rdx,%rax
  80436b:	48 c1 e0 05          	shl    $0x5,%rax
  80436f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804376:	00 00 00 
  804379:	48 01 d0             	add    %rdx,%rax
  80437c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804380:	eb 0c                	jmp    80438e <wait+0x7e>
		sys_yield();
  804382:	48 b8 2d 1c 80 00 00 	movabs $0x801c2d,%rax
  804389:	00 00 00 
  80438c:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80438e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804392:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804398:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80439b:	75 0e                	jne    8043ab <wait+0x9b>
  80439d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043a1:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8043a7:	85 c0                	test   %eax,%eax
  8043a9:	75 d7                	jne    804382 <wait+0x72>
		sys_yield();
}
  8043ab:	c9                   	leaveq 
  8043ac:	c3                   	retq   

00000000008043ad <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8043ad:	55                   	push   %rbp
  8043ae:	48 89 e5             	mov    %rsp,%rbp
  8043b1:	48 83 ec 20          	sub    $0x20,%rsp
  8043b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8043b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043bb:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8043be:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8043c2:	be 01 00 00 00       	mov    $0x1,%esi
  8043c7:	48 89 c7             	mov    %rax,%rdi
  8043ca:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  8043d1:	00 00 00 
  8043d4:	ff d0                	callq  *%rax
}
  8043d6:	c9                   	leaveq 
  8043d7:	c3                   	retq   

00000000008043d8 <getchar>:

int
getchar(void)
{
  8043d8:	55                   	push   %rbp
  8043d9:	48 89 e5             	mov    %rsp,%rbp
  8043dc:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8043e0:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8043e4:	ba 01 00 00 00       	mov    $0x1,%edx
  8043e9:	48 89 c6             	mov    %rax,%rsi
  8043ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8043f1:	48 b8 f3 28 80 00 00 	movabs $0x8028f3,%rax
  8043f8:	00 00 00 
  8043fb:	ff d0                	callq  *%rax
  8043fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804400:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804404:	79 05                	jns    80440b <getchar+0x33>
		return r;
  804406:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804409:	eb 14                	jmp    80441f <getchar+0x47>
	if (r < 1)
  80440b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80440f:	7f 07                	jg     804418 <getchar+0x40>
		return -E_EOF;
  804411:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804416:	eb 07                	jmp    80441f <getchar+0x47>
	return c;
  804418:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80441c:	0f b6 c0             	movzbl %al,%eax
}
  80441f:	c9                   	leaveq 
  804420:	c3                   	retq   

0000000000804421 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804421:	55                   	push   %rbp
  804422:	48 89 e5             	mov    %rsp,%rbp
  804425:	48 83 ec 20          	sub    $0x20,%rsp
  804429:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80442c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804430:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804433:	48 89 d6             	mov    %rdx,%rsi
  804436:	89 c7                	mov    %eax,%edi
  804438:	48 b8 c1 24 80 00 00 	movabs $0x8024c1,%rax
  80443f:	00 00 00 
  804442:	ff d0                	callq  *%rax
  804444:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804447:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80444b:	79 05                	jns    804452 <iscons+0x31>
		return r;
  80444d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804450:	eb 1a                	jmp    80446c <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804452:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804456:	8b 10                	mov    (%rax),%edx
  804458:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  80445f:	00 00 00 
  804462:	8b 00                	mov    (%rax),%eax
  804464:	39 c2                	cmp    %eax,%edx
  804466:	0f 94 c0             	sete   %al
  804469:	0f b6 c0             	movzbl %al,%eax
}
  80446c:	c9                   	leaveq 
  80446d:	c3                   	retq   

000000000080446e <opencons>:

int
opencons(void)
{
  80446e:	55                   	push   %rbp
  80446f:	48 89 e5             	mov    %rsp,%rbp
  804472:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804476:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80447a:	48 89 c7             	mov    %rax,%rdi
  80447d:	48 b8 29 24 80 00 00 	movabs $0x802429,%rax
  804484:	00 00 00 
  804487:	ff d0                	callq  *%rax
  804489:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80448c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804490:	79 05                	jns    804497 <opencons+0x29>
		return r;
  804492:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804495:	eb 5b                	jmp    8044f2 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804497:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80449b:	ba 07 04 00 00       	mov    $0x407,%edx
  8044a0:	48 89 c6             	mov    %rax,%rsi
  8044a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8044a8:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  8044af:	00 00 00 
  8044b2:	ff d0                	callq  *%rax
  8044b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044bb:	79 05                	jns    8044c2 <opencons+0x54>
		return r;
  8044bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044c0:	eb 30                	jmp    8044f2 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8044c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044c6:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  8044cd:	00 00 00 
  8044d0:	8b 12                	mov    (%rdx),%edx
  8044d2:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8044d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044d8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8044df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044e3:	48 89 c7             	mov    %rax,%rdi
  8044e6:	48 b8 db 23 80 00 00 	movabs $0x8023db,%rax
  8044ed:	00 00 00 
  8044f0:	ff d0                	callq  *%rax
}
  8044f2:	c9                   	leaveq 
  8044f3:	c3                   	retq   

00000000008044f4 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8044f4:	55                   	push   %rbp
  8044f5:	48 89 e5             	mov    %rsp,%rbp
  8044f8:	48 83 ec 30          	sub    $0x30,%rsp
  8044fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804500:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804504:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804508:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80450d:	75 07                	jne    804516 <devcons_read+0x22>
		return 0;
  80450f:	b8 00 00 00 00       	mov    $0x0,%eax
  804514:	eb 4b                	jmp    804561 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804516:	eb 0c                	jmp    804524 <devcons_read+0x30>
		sys_yield();
  804518:	48 b8 2d 1c 80 00 00 	movabs $0x801c2d,%rax
  80451f:	00 00 00 
  804522:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804524:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  80452b:	00 00 00 
  80452e:	ff d0                	callq  *%rax
  804530:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804533:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804537:	74 df                	je     804518 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804539:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80453d:	79 05                	jns    804544 <devcons_read+0x50>
		return c;
  80453f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804542:	eb 1d                	jmp    804561 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804544:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804548:	75 07                	jne    804551 <devcons_read+0x5d>
		return 0;
  80454a:	b8 00 00 00 00       	mov    $0x0,%eax
  80454f:	eb 10                	jmp    804561 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804551:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804554:	89 c2                	mov    %eax,%edx
  804556:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80455a:	88 10                	mov    %dl,(%rax)
	return 1;
  80455c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804561:	c9                   	leaveq 
  804562:	c3                   	retq   

0000000000804563 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804563:	55                   	push   %rbp
  804564:	48 89 e5             	mov    %rsp,%rbp
  804567:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80456e:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804575:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80457c:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804583:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80458a:	eb 76                	jmp    804602 <devcons_write+0x9f>
		m = n - tot;
  80458c:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804593:	89 c2                	mov    %eax,%edx
  804595:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804598:	29 c2                	sub    %eax,%edx
  80459a:	89 d0                	mov    %edx,%eax
  80459c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80459f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045a2:	83 f8 7f             	cmp    $0x7f,%eax
  8045a5:	76 07                	jbe    8045ae <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8045a7:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8045ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045b1:	48 63 d0             	movslq %eax,%rdx
  8045b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045b7:	48 63 c8             	movslq %eax,%rcx
  8045ba:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8045c1:	48 01 c1             	add    %rax,%rcx
  8045c4:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8045cb:	48 89 ce             	mov    %rcx,%rsi
  8045ce:	48 89 c7             	mov    %rax,%rdi
  8045d1:	48 b8 60 16 80 00 00 	movabs $0x801660,%rax
  8045d8:	00 00 00 
  8045db:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8045dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045e0:	48 63 d0             	movslq %eax,%rdx
  8045e3:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8045ea:	48 89 d6             	mov    %rdx,%rsi
  8045ed:	48 89 c7             	mov    %rax,%rdi
  8045f0:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  8045f7:	00 00 00 
  8045fa:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8045fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045ff:	01 45 fc             	add    %eax,-0x4(%rbp)
  804602:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804605:	48 98                	cltq   
  804607:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80460e:	0f 82 78 ff ff ff    	jb     80458c <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804614:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804617:	c9                   	leaveq 
  804618:	c3                   	retq   

0000000000804619 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804619:	55                   	push   %rbp
  80461a:	48 89 e5             	mov    %rsp,%rbp
  80461d:	48 83 ec 08          	sub    $0x8,%rsp
  804621:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804625:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80462a:	c9                   	leaveq 
  80462b:	c3                   	retq   

000000000080462c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80462c:	55                   	push   %rbp
  80462d:	48 89 e5             	mov    %rsp,%rbp
  804630:	48 83 ec 10          	sub    $0x10,%rsp
  804634:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804638:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80463c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804640:	48 be 7f 51 80 00 00 	movabs $0x80517f,%rsi
  804647:	00 00 00 
  80464a:	48 89 c7             	mov    %rax,%rdi
  80464d:	48 b8 3c 13 80 00 00 	movabs $0x80133c,%rax
  804654:	00 00 00 
  804657:	ff d0                	callq  *%rax
	return 0;
  804659:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80465e:	c9                   	leaveq 
  80465f:	c3                   	retq   

0000000000804660 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804660:	55                   	push   %rbp
  804661:	48 89 e5             	mov    %rsp,%rbp
  804664:	48 83 ec 10          	sub    $0x10,%rsp
  804668:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  80466c:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804673:	00 00 00 
  804676:	48 8b 00             	mov    (%rax),%rax
  804679:	48 85 c0             	test   %rax,%rax
  80467c:	75 3a                	jne    8046b8 <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  80467e:	ba 07 00 00 00       	mov    $0x7,%edx
  804683:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804688:	bf 00 00 00 00       	mov    $0x0,%edi
  80468d:	48 b8 6b 1c 80 00 00 	movabs $0x801c6b,%rax
  804694:	00 00 00 
  804697:	ff d0                	callq  *%rax
  804699:	85 c0                	test   %eax,%eax
  80469b:	75 1b                	jne    8046b8 <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  80469d:	48 be cb 46 80 00 00 	movabs $0x8046cb,%rsi
  8046a4:	00 00 00 
  8046a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8046ac:	48 b8 f5 1d 80 00 00 	movabs $0x801df5,%rax
  8046b3:	00 00 00 
  8046b6:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8046b8:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8046bf:	00 00 00 
  8046c2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8046c6:	48 89 10             	mov    %rdx,(%rax)
}
  8046c9:	c9                   	leaveq 
  8046ca:	c3                   	retq   

00000000008046cb <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  8046cb:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  8046ce:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  8046d5:	00 00 00 
	call *%rax
  8046d8:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  8046da:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  8046dd:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8046e4:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  8046e5:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  8046ec:	00 
	pushq %rbx		// push utf_rip into new stack
  8046ed:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  8046ee:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  8046f5:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  8046f8:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  8046fc:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  804700:	4c 8b 3c 24          	mov    (%rsp),%r15
  804704:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804709:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80470e:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804713:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804718:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80471d:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804722:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804727:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80472c:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804731:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804736:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80473b:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804740:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804745:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80474a:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  80474e:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  804752:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  804753:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  804754:	c3                   	retq   

0000000000804755 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804755:	55                   	push   %rbp
  804756:	48 89 e5             	mov    %rsp,%rbp
  804759:	48 83 ec 30          	sub    $0x30,%rsp
  80475d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804761:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804765:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  804769:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80476d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  804771:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804776:	75 0e                	jne    804786 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  804778:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  80477f:	00 00 00 
  804782:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  804786:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80478a:	48 89 c7             	mov    %rax,%rdi
  80478d:	48 b8 94 1e 80 00 00 	movabs $0x801e94,%rax
  804794:	00 00 00 
  804797:	ff d0                	callq  *%rax
  804799:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80479c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8047a0:	79 27                	jns    8047c9 <ipc_recv+0x74>
		if (from_env_store != NULL)
  8047a2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8047a7:	74 0a                	je     8047b3 <ipc_recv+0x5e>
			*from_env_store = 0;
  8047a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047ad:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  8047b3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8047b8:	74 0a                	je     8047c4 <ipc_recv+0x6f>
			*perm_store = 0;
  8047ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047be:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8047c4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8047c7:	eb 53                	jmp    80481c <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  8047c9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8047ce:	74 19                	je     8047e9 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  8047d0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8047d7:	00 00 00 
  8047da:	48 8b 00             	mov    (%rax),%rax
  8047dd:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8047e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047e7:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  8047e9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8047ee:	74 19                	je     804809 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  8047f0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8047f7:	00 00 00 
  8047fa:	48 8b 00             	mov    (%rax),%rax
  8047fd:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804803:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804807:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  804809:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804810:	00 00 00 
  804813:	48 8b 00             	mov    (%rax),%rax
  804816:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  80481c:	c9                   	leaveq 
  80481d:	c3                   	retq   

000000000080481e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80481e:	55                   	push   %rbp
  80481f:	48 89 e5             	mov    %rsp,%rbp
  804822:	48 83 ec 30          	sub    $0x30,%rsp
  804826:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804829:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80482c:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804830:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  804833:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804837:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  80483b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804840:	75 10                	jne    804852 <ipc_send+0x34>
		page = (void *)KERNBASE;
  804842:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  804849:	00 00 00 
  80484c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  804850:	eb 0e                	jmp    804860 <ipc_send+0x42>
  804852:	eb 0c                	jmp    804860 <ipc_send+0x42>
		sys_yield();
  804854:	48 b8 2d 1c 80 00 00 	movabs $0x801c2d,%rax
  80485b:	00 00 00 
  80485e:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  804860:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804863:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804866:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80486a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80486d:	89 c7                	mov    %eax,%edi
  80486f:	48 b8 3f 1e 80 00 00 	movabs $0x801e3f,%rax
  804876:	00 00 00 
  804879:	ff d0                	callq  *%rax
  80487b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80487e:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  804882:	74 d0                	je     804854 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  804884:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  804888:	74 2a                	je     8048b4 <ipc_send+0x96>
		panic("error on ipc send procedure");
  80488a:	48 ba 86 51 80 00 00 	movabs $0x805186,%rdx
  804891:	00 00 00 
  804894:	be 49 00 00 00       	mov    $0x49,%esi
  804899:	48 bf a2 51 80 00 00 	movabs $0x8051a2,%rdi
  8048a0:	00 00 00 
  8048a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8048a8:	48 b9 5b 03 80 00 00 	movabs $0x80035b,%rcx
  8048af:	00 00 00 
  8048b2:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  8048b4:	c9                   	leaveq 
  8048b5:	c3                   	retq   

00000000008048b6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8048b6:	55                   	push   %rbp
  8048b7:	48 89 e5             	mov    %rsp,%rbp
  8048ba:	48 83 ec 14          	sub    $0x14,%rsp
  8048be:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8048c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8048c8:	eb 5e                	jmp    804928 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8048ca:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8048d1:	00 00 00 
  8048d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048d7:	48 63 d0             	movslq %eax,%rdx
  8048da:	48 89 d0             	mov    %rdx,%rax
  8048dd:	48 c1 e0 03          	shl    $0x3,%rax
  8048e1:	48 01 d0             	add    %rdx,%rax
  8048e4:	48 c1 e0 05          	shl    $0x5,%rax
  8048e8:	48 01 c8             	add    %rcx,%rax
  8048eb:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8048f1:	8b 00                	mov    (%rax),%eax
  8048f3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8048f6:	75 2c                	jne    804924 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8048f8:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8048ff:	00 00 00 
  804902:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804905:	48 63 d0             	movslq %eax,%rdx
  804908:	48 89 d0             	mov    %rdx,%rax
  80490b:	48 c1 e0 03          	shl    $0x3,%rax
  80490f:	48 01 d0             	add    %rdx,%rax
  804912:	48 c1 e0 05          	shl    $0x5,%rax
  804916:	48 01 c8             	add    %rcx,%rax
  804919:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80491f:	8b 40 08             	mov    0x8(%rax),%eax
  804922:	eb 12                	jmp    804936 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804924:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804928:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80492f:	7e 99                	jle    8048ca <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  804931:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804936:	c9                   	leaveq 
  804937:	c3                   	retq   

0000000000804938 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804938:	55                   	push   %rbp
  804939:	48 89 e5             	mov    %rsp,%rbp
  80493c:	48 83 ec 18          	sub    $0x18,%rsp
  804940:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804944:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804948:	48 c1 e8 15          	shr    $0x15,%rax
  80494c:	48 89 c2             	mov    %rax,%rdx
  80494f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804956:	01 00 00 
  804959:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80495d:	83 e0 01             	and    $0x1,%eax
  804960:	48 85 c0             	test   %rax,%rax
  804963:	75 07                	jne    80496c <pageref+0x34>
		return 0;
  804965:	b8 00 00 00 00       	mov    $0x0,%eax
  80496a:	eb 53                	jmp    8049bf <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80496c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804970:	48 c1 e8 0c          	shr    $0xc,%rax
  804974:	48 89 c2             	mov    %rax,%rdx
  804977:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80497e:	01 00 00 
  804981:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804985:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804989:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80498d:	83 e0 01             	and    $0x1,%eax
  804990:	48 85 c0             	test   %rax,%rax
  804993:	75 07                	jne    80499c <pageref+0x64>
		return 0;
  804995:	b8 00 00 00 00       	mov    $0x0,%eax
  80499a:	eb 23                	jmp    8049bf <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80499c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049a0:	48 c1 e8 0c          	shr    $0xc,%rax
  8049a4:	48 89 c2             	mov    %rax,%rdx
  8049a7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8049ae:	00 00 00 
  8049b1:	48 c1 e2 04          	shl    $0x4,%rdx
  8049b5:	48 01 d0             	add    %rdx,%rax
  8049b8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8049bc:	0f b7 c0             	movzwl %ax,%eax
}
  8049bf:	c9                   	leaveq 
  8049c0:	c3                   	retq   
