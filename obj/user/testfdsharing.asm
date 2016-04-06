
obj/user/testfdsharing.debug:     file format elf64-x86-64


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
  80003c:	e8 fa 02 00 00       	callq  80033b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  800052:	be 00 00 00 00       	mov    $0x0,%esi
  800057:	48 bf 80 3e 80 00 00 	movabs $0x803e80,%rdi
  80005e:	00 00 00 
  800061:	48 b8 5c 2e 80 00 00 	movabs $0x802e5c,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
  80006d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800070:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800074:	79 30                	jns    8000a6 <umain+0x63>
		panic("open motd: %e", fd);
  800076:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800079:	89 c1                	mov    %eax,%ecx
  80007b:	48 ba 85 3e 80 00 00 	movabs $0x803e85,%rdx
  800082:	00 00 00 
  800085:	be 0c 00 00 00       	mov    $0xc,%esi
  80008a:	48 bf 93 3e 80 00 00 	movabs $0x803e93,%rdi
  800091:	00 00 00 
  800094:	b8 00 00 00 00       	mov    $0x0,%eax
  800099:	49 b8 ee 03 80 00 00 	movabs $0x8003ee,%r8
  8000a0:	00 00 00 
  8000a3:	41 ff d0             	callq  *%r8
	seek(fd, 0);
  8000a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	89 c7                	mov    %eax,%edi
  8000b0:	48 b8 a4 2b 80 00 00 	movabs $0x802ba4,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  8000bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000bf:	ba 00 02 00 00       	mov    $0x200,%edx
  8000c4:	48 be 20 72 80 00 00 	movabs $0x807220,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 5b 2a 80 00 00 	movabs $0x802a5b,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000df:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e3:	7f 30                	jg     800115 <umain+0xd2>
		panic("readn: %e", n);
  8000e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	48 ba a8 3e 80 00 00 	movabs $0x803ea8,%rdx
  8000f1:	00 00 00 
  8000f4:	be 0f 00 00 00       	mov    $0xf,%esi
  8000f9:	48 bf 93 3e 80 00 00 	movabs $0x803e93,%rdi
  800100:	00 00 00 
  800103:	b8 00 00 00 00       	mov    $0x0,%eax
  800108:	49 b8 ee 03 80 00 00 	movabs $0x8003ee,%r8
  80010f:	00 00 00 
  800112:	41 ff d0             	callq  *%r8

	if ((r = fork()) < 0)
  800115:	48 b8 d4 21 80 00 00 	movabs $0x8021d4,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
  800121:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800124:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800128:	79 30                	jns    80015a <umain+0x117>
		panic("fork: %e", r);
  80012a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80012d:	89 c1                	mov    %eax,%ecx
  80012f:	48 ba b2 3e 80 00 00 	movabs $0x803eb2,%rdx
  800136:	00 00 00 
  800139:	be 12 00 00 00       	mov    $0x12,%esi
  80013e:	48 bf 93 3e 80 00 00 	movabs $0x803e93,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	49 b8 ee 03 80 00 00 	movabs $0x8003ee,%r8
  800154:	00 00 00 
  800157:	41 ff d0             	callq  *%r8
	if (r == 0) {
  80015a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80015e:	0f 85 36 01 00 00    	jne    80029a <umain+0x257>
		seek(fd, 0);
  800164:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800167:	be 00 00 00 00       	mov    $0x0,%esi
  80016c:	89 c7                	mov    %eax,%edi
  80016e:	48 b8 a4 2b 80 00 00 	movabs $0x802ba4,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80017a:	48 bf c0 3e 80 00 00 	movabs $0x803ec0,%rdi
  800181:	00 00 00 
  800184:	b8 00 00 00 00       	mov    $0x0,%eax
  800189:	48 ba 27 06 80 00 00 	movabs $0x800627,%rdx
  800190:	00 00 00 
  800193:	ff d2                	callq  *%rdx
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800195:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800198:	ba 00 02 00 00       	mov    $0x200,%edx
  80019d:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8001a4:	00 00 00 
  8001a7:	89 c7                	mov    %eax,%edi
  8001a9:	48 b8 5b 2a 80 00 00 	movabs $0x802a5b,%rax
  8001b0:	00 00 00 
  8001b3:	ff d0                	callq  *%rax
  8001b5:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8001b8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001bb:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8001be:	74 36                	je     8001f6 <umain+0x1b3>
			panic("read in parent got %d, read in child got %d", n, n2);
  8001c0:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8001c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001c6:	41 89 d0             	mov    %edx,%r8d
  8001c9:	89 c1                	mov    %eax,%ecx
  8001cb:	48 ba 08 3f 80 00 00 	movabs $0x803f08,%rdx
  8001d2:	00 00 00 
  8001d5:	be 17 00 00 00       	mov    $0x17,%esi
  8001da:	48 bf 93 3e 80 00 00 	movabs $0x803e93,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b9 ee 03 80 00 00 	movabs $0x8003ee,%r9
  8001f0:	00 00 00 
  8001f3:	41 ff d1             	callq  *%r9
		if (memcmp(buf, buf2, n) != 0)
  8001f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 89 c2             	mov    %rax,%rdx
  8001fe:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  800205:	00 00 00 
  800208:	48 bf 20 72 80 00 00 	movabs $0x807220,%rdi
  80020f:	00 00 00 
  800212:	48 b8 3e 18 80 00 00 	movabs $0x80183e,%rax
  800219:	00 00 00 
  80021c:	ff d0                	callq  *%rax
  80021e:	85 c0                	test   %eax,%eax
  800220:	74 2a                	je     80024c <umain+0x209>
			panic("read in parent got different bytes from read in child");
  800222:	48 ba 38 3f 80 00 00 	movabs $0x803f38,%rdx
  800229:	00 00 00 
  80022c:	be 19 00 00 00       	mov    $0x19,%esi
  800231:	48 bf 93 3e 80 00 00 	movabs $0x803e93,%rdi
  800238:	00 00 00 
  80023b:	b8 00 00 00 00       	mov    $0x0,%eax
  800240:	48 b9 ee 03 80 00 00 	movabs $0x8003ee,%rcx
  800247:	00 00 00 
  80024a:	ff d1                	callq  *%rcx
		cprintf("read in child succeeded\n");
  80024c:	48 bf 6e 3f 80 00 00 	movabs $0x803f6e,%rdi
  800253:	00 00 00 
  800256:	b8 00 00 00 00       	mov    $0x0,%eax
  80025b:	48 ba 27 06 80 00 00 	movabs $0x800627,%rdx
  800262:	00 00 00 
  800265:	ff d2                	callq  *%rdx
		seek(fd, 0);
  800267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80026a:	be 00 00 00 00       	mov    $0x0,%esi
  80026f:	89 c7                	mov    %eax,%edi
  800271:	48 b8 a4 2b 80 00 00 	movabs $0x802ba4,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
		close(fd);
  80027d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800280:	89 c7                	mov    %eax,%edi
  800282:	48 b8 64 27 80 00 00 	movabs $0x802764,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
		exit();
  80028e:	48 b8 cb 03 80 00 00 	movabs $0x8003cb,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	}
	wait(r);
  80029a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029d:	89 c7                	mov    %eax,%edi
  80029f:	48 b8 b7 37 80 00 00 	movabs $0x8037b7,%rax
  8002a6:	00 00 00 
  8002a9:	ff d0                	callq  *%rax
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8002ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ae:	ba 00 02 00 00       	mov    $0x200,%edx
  8002b3:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8002ba:	00 00 00 
  8002bd:	89 c7                	mov    %eax,%edi
  8002bf:	48 b8 5b 2a 80 00 00 	movabs $0x802a5b,%rax
  8002c6:	00 00 00 
  8002c9:	ff d0                	callq  *%rax
  8002cb:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002ce:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002d1:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8002d4:	74 36                	je     80030c <umain+0x2c9>
		panic("read in parent got %d, then got %d", n, n2);
  8002d6:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8002d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002dc:	41 89 d0             	mov    %edx,%r8d
  8002df:	89 c1                	mov    %eax,%ecx
  8002e1:	48 ba 88 3f 80 00 00 	movabs $0x803f88,%rdx
  8002e8:	00 00 00 
  8002eb:	be 21 00 00 00       	mov    $0x21,%esi
  8002f0:	48 bf 93 3e 80 00 00 	movabs $0x803e93,%rdi
  8002f7:	00 00 00 
  8002fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ff:	49 b9 ee 03 80 00 00 	movabs $0x8003ee,%r9
  800306:	00 00 00 
  800309:	41 ff d1             	callq  *%r9
	cprintf("read in parent succeeded\n");
  80030c:	48 bf ab 3f 80 00 00 	movabs $0x803fab,%rdi
  800313:	00 00 00 
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	48 ba 27 06 80 00 00 	movabs $0x800627,%rdx
  800322:	00 00 00 
  800325:	ff d2                	callq  *%rdx
	close(fd);
  800327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032a:	89 c7                	mov    %eax,%edi
  80032c:	48 b8 64 27 80 00 00 	movabs $0x802764,%rax
  800333:	00 00 00 
  800336:	ff d0                	callq  *%rax
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800338:	cc                   	int3   

	breakpoint();
}
  800339:	c9                   	leaveq 
  80033a:	c3                   	retq   

000000000080033b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80033b:	55                   	push   %rbp
  80033c:	48 89 e5             	mov    %rsp,%rbp
  80033f:	48 83 ec 10          	sub    $0x10,%rsp
  800343:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800346:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80034a:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  800351:	00 00 00 
  800354:	ff d0                	callq  *%rax
  800356:	48 98                	cltq   
  800358:	25 ff 03 00 00       	and    $0x3ff,%eax
  80035d:	48 89 c2             	mov    %rax,%rdx
  800360:	48 89 d0             	mov    %rdx,%rax
  800363:	48 c1 e0 03          	shl    $0x3,%rax
  800367:	48 01 d0             	add    %rdx,%rax
  80036a:	48 c1 e0 05          	shl    $0x5,%rax
  80036e:	48 89 c2             	mov    %rax,%rdx
  800371:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800378:	00 00 00 
  80037b:	48 01 c2             	add    %rax,%rdx
  80037e:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  800385:	00 00 00 
  800388:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80038b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80038f:	7e 14                	jle    8003a5 <libmain+0x6a>
		binaryname = argv[0];
  800391:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800395:	48 8b 10             	mov    (%rax),%rdx
  800398:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80039f:	00 00 00 
  8003a2:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ac:	48 89 d6             	mov    %rdx,%rsi
  8003af:	89 c7                	mov    %eax,%edi
  8003b1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003b8:	00 00 00 
  8003bb:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003bd:	48 b8 cb 03 80 00 00 	movabs $0x8003cb,%rax
  8003c4:	00 00 00 
  8003c7:	ff d0                	callq  *%rax
}
  8003c9:	c9                   	leaveq 
  8003ca:	c3                   	retq   

00000000008003cb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003cb:	55                   	push   %rbp
  8003cc:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003cf:	48 b8 af 27 80 00 00 	movabs $0x8027af,%rax
  8003d6:	00 00 00 
  8003d9:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003db:	bf 00 00 00 00       	mov    $0x0,%edi
  8003e0:	48 b8 3e 1c 80 00 00 	movabs $0x801c3e,%rax
  8003e7:	00 00 00 
  8003ea:	ff d0                	callq  *%rax
}
  8003ec:	5d                   	pop    %rbp
  8003ed:	c3                   	retq   

00000000008003ee <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003ee:	55                   	push   %rbp
  8003ef:	48 89 e5             	mov    %rsp,%rbp
  8003f2:	53                   	push   %rbx
  8003f3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003fa:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800401:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800407:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80040e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800415:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80041c:	84 c0                	test   %al,%al
  80041e:	74 23                	je     800443 <_panic+0x55>
  800420:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800427:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80042b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80042f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800433:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800437:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80043b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80043f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800443:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80044a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800451:	00 00 00 
  800454:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80045b:	00 00 00 
  80045e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800462:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800469:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800470:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800477:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80047e:	00 00 00 
  800481:	48 8b 18             	mov    (%rax),%rbx
  800484:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  80048b:	00 00 00 
  80048e:	ff d0                	callq  *%rax
  800490:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800496:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80049d:	41 89 c8             	mov    %ecx,%r8d
  8004a0:	48 89 d1             	mov    %rdx,%rcx
  8004a3:	48 89 da             	mov    %rbx,%rdx
  8004a6:	89 c6                	mov    %eax,%esi
  8004a8:	48 bf d0 3f 80 00 00 	movabs $0x803fd0,%rdi
  8004af:	00 00 00 
  8004b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b7:	49 b9 27 06 80 00 00 	movabs $0x800627,%r9
  8004be:	00 00 00 
  8004c1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004c4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004cb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004d2:	48 89 d6             	mov    %rdx,%rsi
  8004d5:	48 89 c7             	mov    %rax,%rdi
  8004d8:	48 b8 7b 05 80 00 00 	movabs $0x80057b,%rax
  8004df:	00 00 00 
  8004e2:	ff d0                	callq  *%rax
	cprintf("\n");
  8004e4:	48 bf f3 3f 80 00 00 	movabs $0x803ff3,%rdi
  8004eb:	00 00 00 
  8004ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f3:	48 ba 27 06 80 00 00 	movabs $0x800627,%rdx
  8004fa:	00 00 00 
  8004fd:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004ff:	cc                   	int3   
  800500:	eb fd                	jmp    8004ff <_panic+0x111>

0000000000800502 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800502:	55                   	push   %rbp
  800503:	48 89 e5             	mov    %rsp,%rbp
  800506:	48 83 ec 10          	sub    $0x10,%rsp
  80050a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80050d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800511:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800515:	8b 00                	mov    (%rax),%eax
  800517:	8d 48 01             	lea    0x1(%rax),%ecx
  80051a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80051e:	89 0a                	mov    %ecx,(%rdx)
  800520:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800523:	89 d1                	mov    %edx,%ecx
  800525:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800529:	48 98                	cltq   
  80052b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80052f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800533:	8b 00                	mov    (%rax),%eax
  800535:	3d ff 00 00 00       	cmp    $0xff,%eax
  80053a:	75 2c                	jne    800568 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80053c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800540:	8b 00                	mov    (%rax),%eax
  800542:	48 98                	cltq   
  800544:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800548:	48 83 c2 08          	add    $0x8,%rdx
  80054c:	48 89 c6             	mov    %rax,%rsi
  80054f:	48 89 d7             	mov    %rdx,%rdi
  800552:	48 b8 b6 1b 80 00 00 	movabs $0x801bb6,%rax
  800559:	00 00 00 
  80055c:	ff d0                	callq  *%rax
		b->idx = 0;
  80055e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800562:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800568:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80056c:	8b 40 04             	mov    0x4(%rax),%eax
  80056f:	8d 50 01             	lea    0x1(%rax),%edx
  800572:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800576:	89 50 04             	mov    %edx,0x4(%rax)
}
  800579:	c9                   	leaveq 
  80057a:	c3                   	retq   

000000000080057b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80057b:	55                   	push   %rbp
  80057c:	48 89 e5             	mov    %rsp,%rbp
  80057f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800586:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80058d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800594:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80059b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005a2:	48 8b 0a             	mov    (%rdx),%rcx
  8005a5:	48 89 08             	mov    %rcx,(%rax)
  8005a8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005ac:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005b0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005b4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8005b8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005bf:	00 00 00 
	b.cnt = 0;
  8005c2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005c9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8005cc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005d3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005da:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005e1:	48 89 c6             	mov    %rax,%rsi
  8005e4:	48 bf 02 05 80 00 00 	movabs $0x800502,%rdi
  8005eb:	00 00 00 
  8005ee:	48 b8 da 09 80 00 00 	movabs $0x8009da,%rax
  8005f5:	00 00 00 
  8005f8:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8005fa:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800600:	48 98                	cltq   
  800602:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800609:	48 83 c2 08          	add    $0x8,%rdx
  80060d:	48 89 c6             	mov    %rax,%rsi
  800610:	48 89 d7             	mov    %rdx,%rdi
  800613:	48 b8 b6 1b 80 00 00 	movabs $0x801bb6,%rax
  80061a:	00 00 00 
  80061d:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80061f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800625:	c9                   	leaveq 
  800626:	c3                   	retq   

0000000000800627 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800627:	55                   	push   %rbp
  800628:	48 89 e5             	mov    %rsp,%rbp
  80062b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800632:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800639:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800640:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800647:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80064e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800655:	84 c0                	test   %al,%al
  800657:	74 20                	je     800679 <cprintf+0x52>
  800659:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80065d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800661:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800665:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800669:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80066d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800671:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800675:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800679:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800680:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800687:	00 00 00 
  80068a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800691:	00 00 00 
  800694:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800698:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80069f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006a6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8006ad:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006b4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006bb:	48 8b 0a             	mov    (%rdx),%rcx
  8006be:	48 89 08             	mov    %rcx,(%rax)
  8006c1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006c5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006c9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006cd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8006d1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006d8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006df:	48 89 d6             	mov    %rdx,%rsi
  8006e2:	48 89 c7             	mov    %rax,%rdi
  8006e5:	48 b8 7b 05 80 00 00 	movabs $0x80057b,%rax
  8006ec:	00 00 00 
  8006ef:	ff d0                	callq  *%rax
  8006f1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8006f7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006fd:	c9                   	leaveq 
  8006fe:	c3                   	retq   

00000000008006ff <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006ff:	55                   	push   %rbp
  800700:	48 89 e5             	mov    %rsp,%rbp
  800703:	53                   	push   %rbx
  800704:	48 83 ec 38          	sub    $0x38,%rsp
  800708:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80070c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800710:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800714:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800717:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80071b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80071f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800722:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800726:	77 3b                	ja     800763 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800728:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80072b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80072f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800732:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800736:	ba 00 00 00 00       	mov    $0x0,%edx
  80073b:	48 f7 f3             	div    %rbx
  80073e:	48 89 c2             	mov    %rax,%rdx
  800741:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800744:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800747:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80074b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074f:	41 89 f9             	mov    %edi,%r9d
  800752:	48 89 c7             	mov    %rax,%rdi
  800755:	48 b8 ff 06 80 00 00 	movabs $0x8006ff,%rax
  80075c:	00 00 00 
  80075f:	ff d0                	callq  *%rax
  800761:	eb 1e                	jmp    800781 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800763:	eb 12                	jmp    800777 <printnum+0x78>
			putch(padc, putdat);
  800765:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800769:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80076c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800770:	48 89 ce             	mov    %rcx,%rsi
  800773:	89 d7                	mov    %edx,%edi
  800775:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800777:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80077b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80077f:	7f e4                	jg     800765 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800781:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800788:	ba 00 00 00 00       	mov    $0x0,%edx
  80078d:	48 f7 f1             	div    %rcx
  800790:	48 89 d0             	mov    %rdx,%rax
  800793:	48 ba c8 41 80 00 00 	movabs $0x8041c8,%rdx
  80079a:	00 00 00 
  80079d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007a1:	0f be d0             	movsbl %al,%edx
  8007a4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ac:	48 89 ce             	mov    %rcx,%rsi
  8007af:	89 d7                	mov    %edx,%edi
  8007b1:	ff d0                	callq  *%rax
}
  8007b3:	48 83 c4 38          	add    $0x38,%rsp
  8007b7:	5b                   	pop    %rbx
  8007b8:	5d                   	pop    %rbp
  8007b9:	c3                   	retq   

00000000008007ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007ba:	55                   	push   %rbp
  8007bb:	48 89 e5             	mov    %rsp,%rbp
  8007be:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007c6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8007c9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007cd:	7e 52                	jle    800821 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d3:	8b 00                	mov    (%rax),%eax
  8007d5:	83 f8 30             	cmp    $0x30,%eax
  8007d8:	73 24                	jae    8007fe <getuint+0x44>
  8007da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007de:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e6:	8b 00                	mov    (%rax),%eax
  8007e8:	89 c0                	mov    %eax,%eax
  8007ea:	48 01 d0             	add    %rdx,%rax
  8007ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f1:	8b 12                	mov    (%rdx),%edx
  8007f3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fa:	89 0a                	mov    %ecx,(%rdx)
  8007fc:	eb 17                	jmp    800815 <getuint+0x5b>
  8007fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800802:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800806:	48 89 d0             	mov    %rdx,%rax
  800809:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80080d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800811:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800815:	48 8b 00             	mov    (%rax),%rax
  800818:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80081c:	e9 a3 00 00 00       	jmpq   8008c4 <getuint+0x10a>
	else if (lflag)
  800821:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800825:	74 4f                	je     800876 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800827:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082b:	8b 00                	mov    (%rax),%eax
  80082d:	83 f8 30             	cmp    $0x30,%eax
  800830:	73 24                	jae    800856 <getuint+0x9c>
  800832:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800836:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80083a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083e:	8b 00                	mov    (%rax),%eax
  800840:	89 c0                	mov    %eax,%eax
  800842:	48 01 d0             	add    %rdx,%rax
  800845:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800849:	8b 12                	mov    (%rdx),%edx
  80084b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80084e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800852:	89 0a                	mov    %ecx,(%rdx)
  800854:	eb 17                	jmp    80086d <getuint+0xb3>
  800856:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80085e:	48 89 d0             	mov    %rdx,%rax
  800861:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800865:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800869:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80086d:	48 8b 00             	mov    (%rax),%rax
  800870:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800874:	eb 4e                	jmp    8008c4 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800876:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087a:	8b 00                	mov    (%rax),%eax
  80087c:	83 f8 30             	cmp    $0x30,%eax
  80087f:	73 24                	jae    8008a5 <getuint+0xeb>
  800881:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800885:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800889:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088d:	8b 00                	mov    (%rax),%eax
  80088f:	89 c0                	mov    %eax,%eax
  800891:	48 01 d0             	add    %rdx,%rax
  800894:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800898:	8b 12                	mov    (%rdx),%edx
  80089a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80089d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a1:	89 0a                	mov    %ecx,(%rdx)
  8008a3:	eb 17                	jmp    8008bc <getuint+0x102>
  8008a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ad:	48 89 d0             	mov    %rdx,%rax
  8008b0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008bc:	8b 00                	mov    (%rax),%eax
  8008be:	89 c0                	mov    %eax,%eax
  8008c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008c8:	c9                   	leaveq 
  8008c9:	c3                   	retq   

00000000008008ca <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ca:	55                   	push   %rbp
  8008cb:	48 89 e5             	mov    %rsp,%rbp
  8008ce:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008d6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008d9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008dd:	7e 52                	jle    800931 <getint+0x67>
		x=va_arg(*ap, long long);
  8008df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e3:	8b 00                	mov    (%rax),%eax
  8008e5:	83 f8 30             	cmp    $0x30,%eax
  8008e8:	73 24                	jae    80090e <getint+0x44>
  8008ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ee:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f6:	8b 00                	mov    (%rax),%eax
  8008f8:	89 c0                	mov    %eax,%eax
  8008fa:	48 01 d0             	add    %rdx,%rax
  8008fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800901:	8b 12                	mov    (%rdx),%edx
  800903:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800906:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090a:	89 0a                	mov    %ecx,(%rdx)
  80090c:	eb 17                	jmp    800925 <getint+0x5b>
  80090e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800912:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800916:	48 89 d0             	mov    %rdx,%rax
  800919:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80091d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800921:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800925:	48 8b 00             	mov    (%rax),%rax
  800928:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80092c:	e9 a3 00 00 00       	jmpq   8009d4 <getint+0x10a>
	else if (lflag)
  800931:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800935:	74 4f                	je     800986 <getint+0xbc>
		x=va_arg(*ap, long);
  800937:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093b:	8b 00                	mov    (%rax),%eax
  80093d:	83 f8 30             	cmp    $0x30,%eax
  800940:	73 24                	jae    800966 <getint+0x9c>
  800942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800946:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80094a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094e:	8b 00                	mov    (%rax),%eax
  800950:	89 c0                	mov    %eax,%eax
  800952:	48 01 d0             	add    %rdx,%rax
  800955:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800959:	8b 12                	mov    (%rdx),%edx
  80095b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80095e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800962:	89 0a                	mov    %ecx,(%rdx)
  800964:	eb 17                	jmp    80097d <getint+0xb3>
  800966:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80096e:	48 89 d0             	mov    %rdx,%rax
  800971:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800975:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800979:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80097d:	48 8b 00             	mov    (%rax),%rax
  800980:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800984:	eb 4e                	jmp    8009d4 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800986:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098a:	8b 00                	mov    (%rax),%eax
  80098c:	83 f8 30             	cmp    $0x30,%eax
  80098f:	73 24                	jae    8009b5 <getint+0xeb>
  800991:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800995:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099d:	8b 00                	mov    (%rax),%eax
  80099f:	89 c0                	mov    %eax,%eax
  8009a1:	48 01 d0             	add    %rdx,%rax
  8009a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a8:	8b 12                	mov    (%rdx),%edx
  8009aa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b1:	89 0a                	mov    %ecx,(%rdx)
  8009b3:	eb 17                	jmp    8009cc <getint+0x102>
  8009b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009bd:	48 89 d0             	mov    %rdx,%rax
  8009c0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009cc:	8b 00                	mov    (%rax),%eax
  8009ce:	48 98                	cltq   
  8009d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009d8:	c9                   	leaveq 
  8009d9:	c3                   	retq   

00000000008009da <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009da:	55                   	push   %rbp
  8009db:	48 89 e5             	mov    %rsp,%rbp
  8009de:	41 54                	push   %r12
  8009e0:	53                   	push   %rbx
  8009e1:	48 83 ec 60          	sub    $0x60,%rsp
  8009e5:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009e9:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009ed:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009f1:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009f5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009f9:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009fd:	48 8b 0a             	mov    (%rdx),%rcx
  800a00:	48 89 08             	mov    %rcx,(%rax)
  800a03:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a07:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a0b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a0f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  800a13:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a17:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a1b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a1f:	0f b6 00             	movzbl (%rax),%eax
  800a22:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  800a25:	eb 29                	jmp    800a50 <vprintfmt+0x76>
			if (ch == '\0')
  800a27:	85 db                	test   %ebx,%ebx
  800a29:	0f 84 ad 06 00 00    	je     8010dc <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  800a2f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a33:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a37:	48 89 d6             	mov    %rdx,%rsi
  800a3a:	89 df                	mov    %ebx,%edi
  800a3c:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  800a3e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a42:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a46:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a4a:	0f b6 00             	movzbl (%rax),%eax
  800a4d:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  800a50:	83 fb 25             	cmp    $0x25,%ebx
  800a53:	74 05                	je     800a5a <vprintfmt+0x80>
  800a55:	83 fb 1b             	cmp    $0x1b,%ebx
  800a58:	75 cd                	jne    800a27 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800a5a:	83 fb 1b             	cmp    $0x1b,%ebx
  800a5d:	0f 85 ae 01 00 00    	jne    800c11 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  800a63:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800a6a:	00 00 00 
  800a6d:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  800a73:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a7b:	48 89 d6             	mov    %rdx,%rsi
  800a7e:	89 df                	mov    %ebx,%edi
  800a80:	ff d0                	callq  *%rax
			putch('[', putdat);
  800a82:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a86:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8a:	48 89 d6             	mov    %rdx,%rsi
  800a8d:	bf 5b 00 00 00       	mov    $0x5b,%edi
  800a92:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800a94:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800a9a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a9f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aa3:	0f b6 00             	movzbl (%rax),%eax
  800aa6:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800aa9:	eb 32                	jmp    800add <vprintfmt+0x103>
					putch(ch, putdat);
  800aab:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aaf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab3:	48 89 d6             	mov    %rdx,%rsi
  800ab6:	89 df                	mov    %ebx,%edi
  800ab8:	ff d0                	callq  *%rax
					esc_color *= 10;
  800aba:	44 89 e0             	mov    %r12d,%eax
  800abd:	c1 e0 02             	shl    $0x2,%eax
  800ac0:	44 01 e0             	add    %r12d,%eax
  800ac3:	01 c0                	add    %eax,%eax
  800ac5:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800ac8:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800acb:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800ace:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800ad3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ad7:	0f b6 00             	movzbl (%rax),%eax
  800ada:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800add:	83 fb 3b             	cmp    $0x3b,%ebx
  800ae0:	74 05                	je     800ae7 <vprintfmt+0x10d>
  800ae2:	83 fb 6d             	cmp    $0x6d,%ebx
  800ae5:	75 c4                	jne    800aab <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800ae7:	45 85 e4             	test   %r12d,%r12d
  800aea:	75 15                	jne    800b01 <vprintfmt+0x127>
					color_flag = 0x07;
  800aec:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800af3:	00 00 00 
  800af6:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800afc:	e9 dc 00 00 00       	jmpq   800bdd <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800b01:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800b05:	7e 69                	jle    800b70 <vprintfmt+0x196>
  800b07:	41 83 fc 25          	cmp    $0x25,%r12d
  800b0b:	7f 63                	jg     800b70 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800b0d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b14:	00 00 00 
  800b17:	8b 00                	mov    (%rax),%eax
  800b19:	25 f8 00 00 00       	and    $0xf8,%eax
  800b1e:	89 c2                	mov    %eax,%edx
  800b20:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b27:	00 00 00 
  800b2a:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800b2c:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800b30:	44 89 e0             	mov    %r12d,%eax
  800b33:	83 e0 04             	and    $0x4,%eax
  800b36:	c1 f8 02             	sar    $0x2,%eax
  800b39:	89 c2                	mov    %eax,%edx
  800b3b:	44 89 e0             	mov    %r12d,%eax
  800b3e:	83 e0 02             	and    $0x2,%eax
  800b41:	09 c2                	or     %eax,%edx
  800b43:	44 89 e0             	mov    %r12d,%eax
  800b46:	83 e0 01             	and    $0x1,%eax
  800b49:	c1 e0 02             	shl    $0x2,%eax
  800b4c:	09 c2                	or     %eax,%edx
  800b4e:	41 89 d4             	mov    %edx,%r12d
  800b51:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b58:	00 00 00 
  800b5b:	8b 00                	mov    (%rax),%eax
  800b5d:	44 89 e2             	mov    %r12d,%edx
  800b60:	09 c2                	or     %eax,%edx
  800b62:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b69:	00 00 00 
  800b6c:	89 10                	mov    %edx,(%rax)
  800b6e:	eb 6d                	jmp    800bdd <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800b70:	41 83 fc 27          	cmp    $0x27,%r12d
  800b74:	7e 67                	jle    800bdd <vprintfmt+0x203>
  800b76:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800b7a:	7f 61                	jg     800bdd <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800b7c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b83:	00 00 00 
  800b86:	8b 00                	mov    (%rax),%eax
  800b88:	25 8f 00 00 00       	and    $0x8f,%eax
  800b8d:	89 c2                	mov    %eax,%edx
  800b8f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b96:	00 00 00 
  800b99:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800b9b:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800b9f:	44 89 e0             	mov    %r12d,%eax
  800ba2:	83 e0 04             	and    $0x4,%eax
  800ba5:	c1 f8 02             	sar    $0x2,%eax
  800ba8:	89 c2                	mov    %eax,%edx
  800baa:	44 89 e0             	mov    %r12d,%eax
  800bad:	83 e0 02             	and    $0x2,%eax
  800bb0:	09 c2                	or     %eax,%edx
  800bb2:	44 89 e0             	mov    %r12d,%eax
  800bb5:	83 e0 01             	and    $0x1,%eax
  800bb8:	c1 e0 06             	shl    $0x6,%eax
  800bbb:	09 c2                	or     %eax,%edx
  800bbd:	41 89 d4             	mov    %edx,%r12d
  800bc0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800bc7:	00 00 00 
  800bca:	8b 00                	mov    (%rax),%eax
  800bcc:	44 89 e2             	mov    %r12d,%edx
  800bcf:	09 c2                	or     %eax,%edx
  800bd1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800bd8:	00 00 00 
  800bdb:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800bdd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800be1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be5:	48 89 d6             	mov    %rdx,%rsi
  800be8:	89 df                	mov    %ebx,%edi
  800bea:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800bec:	83 fb 6d             	cmp    $0x6d,%ebx
  800bef:	75 1b                	jne    800c0c <vprintfmt+0x232>
					fmt ++;
  800bf1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800bf6:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800bf7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800bfe:	00 00 00 
  800c01:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800c07:	e9 cb 04 00 00       	jmpq   8010d7 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800c0c:	e9 83 fe ff ff       	jmpq   800a94 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800c11:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c15:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c1c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c23:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c2a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c31:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c35:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c39:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c3d:	0f b6 00             	movzbl (%rax),%eax
  800c40:	0f b6 d8             	movzbl %al,%ebx
  800c43:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c46:	83 f8 55             	cmp    $0x55,%eax
  800c49:	0f 87 5a 04 00 00    	ja     8010a9 <vprintfmt+0x6cf>
  800c4f:	89 c0                	mov    %eax,%eax
  800c51:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c58:	00 
  800c59:	48 b8 f0 41 80 00 00 	movabs $0x8041f0,%rax
  800c60:	00 00 00 
  800c63:	48 01 d0             	add    %rdx,%rax
  800c66:	48 8b 00             	mov    (%rax),%rax
  800c69:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c6b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c6f:	eb c0                	jmp    800c31 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c71:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c75:	eb ba                	jmp    800c31 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c77:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c7e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c81:	89 d0                	mov    %edx,%eax
  800c83:	c1 e0 02             	shl    $0x2,%eax
  800c86:	01 d0                	add    %edx,%eax
  800c88:	01 c0                	add    %eax,%eax
  800c8a:	01 d8                	add    %ebx,%eax
  800c8c:	83 e8 30             	sub    $0x30,%eax
  800c8f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c92:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c96:	0f b6 00             	movzbl (%rax),%eax
  800c99:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c9c:	83 fb 2f             	cmp    $0x2f,%ebx
  800c9f:	7e 0c                	jle    800cad <vprintfmt+0x2d3>
  800ca1:	83 fb 39             	cmp    $0x39,%ebx
  800ca4:	7f 07                	jg     800cad <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ca6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cab:	eb d1                	jmp    800c7e <vprintfmt+0x2a4>
			goto process_precision;
  800cad:	eb 58                	jmp    800d07 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800caf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb2:	83 f8 30             	cmp    $0x30,%eax
  800cb5:	73 17                	jae    800cce <vprintfmt+0x2f4>
  800cb7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cbb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cbe:	89 c0                	mov    %eax,%eax
  800cc0:	48 01 d0             	add    %rdx,%rax
  800cc3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc6:	83 c2 08             	add    $0x8,%edx
  800cc9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ccc:	eb 0f                	jmp    800cdd <vprintfmt+0x303>
  800cce:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cd2:	48 89 d0             	mov    %rdx,%rax
  800cd5:	48 83 c2 08          	add    $0x8,%rdx
  800cd9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cdd:	8b 00                	mov    (%rax),%eax
  800cdf:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800ce2:	eb 23                	jmp    800d07 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800ce4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ce8:	79 0c                	jns    800cf6 <vprintfmt+0x31c>
				width = 0;
  800cea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800cf1:	e9 3b ff ff ff       	jmpq   800c31 <vprintfmt+0x257>
  800cf6:	e9 36 ff ff ff       	jmpq   800c31 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800cfb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d02:	e9 2a ff ff ff       	jmpq   800c31 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800d07:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d0b:	79 12                	jns    800d1f <vprintfmt+0x345>
				width = precision, precision = -1;
  800d0d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d10:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d13:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d1a:	e9 12 ff ff ff       	jmpq   800c31 <vprintfmt+0x257>
  800d1f:	e9 0d ff ff ff       	jmpq   800c31 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d24:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d28:	e9 04 ff ff ff       	jmpq   800c31 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d2d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d30:	83 f8 30             	cmp    $0x30,%eax
  800d33:	73 17                	jae    800d4c <vprintfmt+0x372>
  800d35:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d3c:	89 c0                	mov    %eax,%eax
  800d3e:	48 01 d0             	add    %rdx,%rax
  800d41:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d44:	83 c2 08             	add    $0x8,%edx
  800d47:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d4a:	eb 0f                	jmp    800d5b <vprintfmt+0x381>
  800d4c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d50:	48 89 d0             	mov    %rdx,%rax
  800d53:	48 83 c2 08          	add    $0x8,%rdx
  800d57:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d5b:	8b 10                	mov    (%rax),%edx
  800d5d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d65:	48 89 ce             	mov    %rcx,%rsi
  800d68:	89 d7                	mov    %edx,%edi
  800d6a:	ff d0                	callq  *%rax
			break;
  800d6c:	e9 66 03 00 00       	jmpq   8010d7 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800d71:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d74:	83 f8 30             	cmp    $0x30,%eax
  800d77:	73 17                	jae    800d90 <vprintfmt+0x3b6>
  800d79:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d80:	89 c0                	mov    %eax,%eax
  800d82:	48 01 d0             	add    %rdx,%rax
  800d85:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d88:	83 c2 08             	add    $0x8,%edx
  800d8b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d8e:	eb 0f                	jmp    800d9f <vprintfmt+0x3c5>
  800d90:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d94:	48 89 d0             	mov    %rdx,%rax
  800d97:	48 83 c2 08          	add    $0x8,%rdx
  800d9b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d9f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800da1:	85 db                	test   %ebx,%ebx
  800da3:	79 02                	jns    800da7 <vprintfmt+0x3cd>
				err = -err;
  800da5:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800da7:	83 fb 10             	cmp    $0x10,%ebx
  800daa:	7f 16                	jg     800dc2 <vprintfmt+0x3e8>
  800dac:	48 b8 40 41 80 00 00 	movabs $0x804140,%rax
  800db3:	00 00 00 
  800db6:	48 63 d3             	movslq %ebx,%rdx
  800db9:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800dbd:	4d 85 e4             	test   %r12,%r12
  800dc0:	75 2e                	jne    800df0 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800dc2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dc6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dca:	89 d9                	mov    %ebx,%ecx
  800dcc:	48 ba d9 41 80 00 00 	movabs $0x8041d9,%rdx
  800dd3:	00 00 00 
  800dd6:	48 89 c7             	mov    %rax,%rdi
  800dd9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dde:	49 b8 e5 10 80 00 00 	movabs $0x8010e5,%r8
  800de5:	00 00 00 
  800de8:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800deb:	e9 e7 02 00 00       	jmpq   8010d7 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800df0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800df4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df8:	4c 89 e1             	mov    %r12,%rcx
  800dfb:	48 ba e2 41 80 00 00 	movabs $0x8041e2,%rdx
  800e02:	00 00 00 
  800e05:	48 89 c7             	mov    %rax,%rdi
  800e08:	b8 00 00 00 00       	mov    $0x0,%eax
  800e0d:	49 b8 e5 10 80 00 00 	movabs $0x8010e5,%r8
  800e14:	00 00 00 
  800e17:	41 ff d0             	callq  *%r8
			break;
  800e1a:	e9 b8 02 00 00       	jmpq   8010d7 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e1f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e22:	83 f8 30             	cmp    $0x30,%eax
  800e25:	73 17                	jae    800e3e <vprintfmt+0x464>
  800e27:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e2b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e2e:	89 c0                	mov    %eax,%eax
  800e30:	48 01 d0             	add    %rdx,%rax
  800e33:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e36:	83 c2 08             	add    $0x8,%edx
  800e39:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e3c:	eb 0f                	jmp    800e4d <vprintfmt+0x473>
  800e3e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e42:	48 89 d0             	mov    %rdx,%rax
  800e45:	48 83 c2 08          	add    $0x8,%rdx
  800e49:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e4d:	4c 8b 20             	mov    (%rax),%r12
  800e50:	4d 85 e4             	test   %r12,%r12
  800e53:	75 0a                	jne    800e5f <vprintfmt+0x485>
				p = "(null)";
  800e55:	49 bc e5 41 80 00 00 	movabs $0x8041e5,%r12
  800e5c:	00 00 00 
			if (width > 0 && padc != '-')
  800e5f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e63:	7e 3f                	jle    800ea4 <vprintfmt+0x4ca>
  800e65:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e69:	74 39                	je     800ea4 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e6b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e6e:	48 98                	cltq   
  800e70:	48 89 c6             	mov    %rax,%rsi
  800e73:	4c 89 e7             	mov    %r12,%rdi
  800e76:	48 b8 91 13 80 00 00 	movabs $0x801391,%rax
  800e7d:	00 00 00 
  800e80:	ff d0                	callq  *%rax
  800e82:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e85:	eb 17                	jmp    800e9e <vprintfmt+0x4c4>
					putch(padc, putdat);
  800e87:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e8b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e8f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e93:	48 89 ce             	mov    %rcx,%rsi
  800e96:	89 d7                	mov    %edx,%edi
  800e98:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e9a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e9e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ea2:	7f e3                	jg     800e87 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ea4:	eb 37                	jmp    800edd <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800ea6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800eaa:	74 1e                	je     800eca <vprintfmt+0x4f0>
  800eac:	83 fb 1f             	cmp    $0x1f,%ebx
  800eaf:	7e 05                	jle    800eb6 <vprintfmt+0x4dc>
  800eb1:	83 fb 7e             	cmp    $0x7e,%ebx
  800eb4:	7e 14                	jle    800eca <vprintfmt+0x4f0>
					putch('?', putdat);
  800eb6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ebe:	48 89 d6             	mov    %rdx,%rsi
  800ec1:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ec6:	ff d0                	callq  *%rax
  800ec8:	eb 0f                	jmp    800ed9 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800eca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ece:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed2:	48 89 d6             	mov    %rdx,%rsi
  800ed5:	89 df                	mov    %ebx,%edi
  800ed7:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ed9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800edd:	4c 89 e0             	mov    %r12,%rax
  800ee0:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ee4:	0f b6 00             	movzbl (%rax),%eax
  800ee7:	0f be d8             	movsbl %al,%ebx
  800eea:	85 db                	test   %ebx,%ebx
  800eec:	74 10                	je     800efe <vprintfmt+0x524>
  800eee:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ef2:	78 b2                	js     800ea6 <vprintfmt+0x4cc>
  800ef4:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ef8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800efc:	79 a8                	jns    800ea6 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800efe:	eb 16                	jmp    800f16 <vprintfmt+0x53c>
				putch(' ', putdat);
  800f00:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f08:	48 89 d6             	mov    %rdx,%rsi
  800f0b:	bf 20 00 00 00       	mov    $0x20,%edi
  800f10:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f12:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f16:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f1a:	7f e4                	jg     800f00 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800f1c:	e9 b6 01 00 00       	jmpq   8010d7 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f21:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f25:	be 03 00 00 00       	mov    $0x3,%esi
  800f2a:	48 89 c7             	mov    %rax,%rdi
  800f2d:	48 b8 ca 08 80 00 00 	movabs $0x8008ca,%rax
  800f34:	00 00 00 
  800f37:	ff d0                	callq  *%rax
  800f39:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f41:	48 85 c0             	test   %rax,%rax
  800f44:	79 1d                	jns    800f63 <vprintfmt+0x589>
				putch('-', putdat);
  800f46:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f4a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f4e:	48 89 d6             	mov    %rdx,%rsi
  800f51:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f56:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5c:	48 f7 d8             	neg    %rax
  800f5f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f63:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f6a:	e9 fb 00 00 00       	jmpq   80106a <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f6f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f73:	be 03 00 00 00       	mov    $0x3,%esi
  800f78:	48 89 c7             	mov    %rax,%rdi
  800f7b:	48 b8 ba 07 80 00 00 	movabs $0x8007ba,%rax
  800f82:	00 00 00 
  800f85:	ff d0                	callq  *%rax
  800f87:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f8b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f92:	e9 d3 00 00 00       	jmpq   80106a <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800f97:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f9b:	be 03 00 00 00       	mov    $0x3,%esi
  800fa0:	48 89 c7             	mov    %rax,%rdi
  800fa3:	48 b8 ca 08 80 00 00 	movabs $0x8008ca,%rax
  800faa:	00 00 00 
  800fad:	ff d0                	callq  *%rax
  800faf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800fb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb7:	48 85 c0             	test   %rax,%rax
  800fba:	79 1d                	jns    800fd9 <vprintfmt+0x5ff>
				putch('-', putdat);
  800fbc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fc0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fc4:	48 89 d6             	mov    %rdx,%rsi
  800fc7:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800fcc:	ff d0                	callq  *%rax
				num = -(long long) num;
  800fce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd2:	48 f7 d8             	neg    %rax
  800fd5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800fd9:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800fe0:	e9 85 00 00 00       	jmpq   80106a <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800fe5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fe9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fed:	48 89 d6             	mov    %rdx,%rsi
  800ff0:	bf 30 00 00 00       	mov    $0x30,%edi
  800ff5:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ff7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ffb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fff:	48 89 d6             	mov    %rdx,%rsi
  801002:	bf 78 00 00 00       	mov    $0x78,%edi
  801007:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801009:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80100c:	83 f8 30             	cmp    $0x30,%eax
  80100f:	73 17                	jae    801028 <vprintfmt+0x64e>
  801011:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801015:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801018:	89 c0                	mov    %eax,%eax
  80101a:	48 01 d0             	add    %rdx,%rax
  80101d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801020:	83 c2 08             	add    $0x8,%edx
  801023:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801026:	eb 0f                	jmp    801037 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  801028:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80102c:	48 89 d0             	mov    %rdx,%rax
  80102f:	48 83 c2 08          	add    $0x8,%rdx
  801033:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801037:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80103a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80103e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801045:	eb 23                	jmp    80106a <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801047:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80104b:	be 03 00 00 00       	mov    $0x3,%esi
  801050:	48 89 c7             	mov    %rax,%rdi
  801053:	48 b8 ba 07 80 00 00 	movabs $0x8007ba,%rax
  80105a:	00 00 00 
  80105d:	ff d0                	callq  *%rax
  80105f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801063:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80106a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80106f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801072:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801075:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801079:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80107d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801081:	45 89 c1             	mov    %r8d,%r9d
  801084:	41 89 f8             	mov    %edi,%r8d
  801087:	48 89 c7             	mov    %rax,%rdi
  80108a:	48 b8 ff 06 80 00 00 	movabs $0x8006ff,%rax
  801091:	00 00 00 
  801094:	ff d0                	callq  *%rax
			break;
  801096:	eb 3f                	jmp    8010d7 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801098:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80109c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010a0:	48 89 d6             	mov    %rdx,%rsi
  8010a3:	89 df                	mov    %ebx,%edi
  8010a5:	ff d0                	callq  *%rax
			break;
  8010a7:	eb 2e                	jmp    8010d7 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010a9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010ad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010b1:	48 89 d6             	mov    %rdx,%rsi
  8010b4:	bf 25 00 00 00       	mov    $0x25,%edi
  8010b9:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010bb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010c0:	eb 05                	jmp    8010c7 <vprintfmt+0x6ed>
  8010c2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010c7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010cb:	48 83 e8 01          	sub    $0x1,%rax
  8010cf:	0f b6 00             	movzbl (%rax),%eax
  8010d2:	3c 25                	cmp    $0x25,%al
  8010d4:	75 ec                	jne    8010c2 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  8010d6:	90                   	nop
		}
	}
  8010d7:	e9 37 f9 ff ff       	jmpq   800a13 <vprintfmt+0x39>
    va_end(aq);
}
  8010dc:	48 83 c4 60          	add    $0x60,%rsp
  8010e0:	5b                   	pop    %rbx
  8010e1:	41 5c                	pop    %r12
  8010e3:	5d                   	pop    %rbp
  8010e4:	c3                   	retq   

00000000008010e5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010e5:	55                   	push   %rbp
  8010e6:	48 89 e5             	mov    %rsp,%rbp
  8010e9:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8010f0:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8010f7:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8010fe:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801105:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80110c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801113:	84 c0                	test   %al,%al
  801115:	74 20                	je     801137 <printfmt+0x52>
  801117:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80111b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80111f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801123:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801127:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80112b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80112f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801133:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801137:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80113e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801145:	00 00 00 
  801148:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80114f:	00 00 00 
  801152:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801156:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80115d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801164:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80116b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801172:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801179:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801180:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801187:	48 89 c7             	mov    %rax,%rdi
  80118a:	48 b8 da 09 80 00 00 	movabs $0x8009da,%rax
  801191:	00 00 00 
  801194:	ff d0                	callq  *%rax
	va_end(ap);
}
  801196:	c9                   	leaveq 
  801197:	c3                   	retq   

0000000000801198 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801198:	55                   	push   %rbp
  801199:	48 89 e5             	mov    %rsp,%rbp
  80119c:	48 83 ec 10          	sub    $0x10,%rsp
  8011a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8011a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8011a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ab:	8b 40 10             	mov    0x10(%rax),%eax
  8011ae:	8d 50 01             	lea    0x1(%rax),%edx
  8011b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b5:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011bc:	48 8b 10             	mov    (%rax),%rdx
  8011bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011c7:	48 39 c2             	cmp    %rax,%rdx
  8011ca:	73 17                	jae    8011e3 <sprintputch+0x4b>
		*b->buf++ = ch;
  8011cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d0:	48 8b 00             	mov    (%rax),%rax
  8011d3:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8011d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011db:	48 89 0a             	mov    %rcx,(%rdx)
  8011de:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011e1:	88 10                	mov    %dl,(%rax)
}
  8011e3:	c9                   	leaveq 
  8011e4:	c3                   	retq   

00000000008011e5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011e5:	55                   	push   %rbp
  8011e6:	48 89 e5             	mov    %rsp,%rbp
  8011e9:	48 83 ec 50          	sub    $0x50,%rsp
  8011ed:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8011f1:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8011f4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8011f8:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8011fc:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801200:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801204:	48 8b 0a             	mov    (%rdx),%rcx
  801207:	48 89 08             	mov    %rcx,(%rax)
  80120a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80120e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801212:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801216:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80121a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80121e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801222:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801225:	48 98                	cltq   
  801227:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80122b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80122f:	48 01 d0             	add    %rdx,%rax
  801232:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801236:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80123d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801242:	74 06                	je     80124a <vsnprintf+0x65>
  801244:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801248:	7f 07                	jg     801251 <vsnprintf+0x6c>
		return -E_INVAL;
  80124a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80124f:	eb 2f                	jmp    801280 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801251:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801255:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801259:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80125d:	48 89 c6             	mov    %rax,%rsi
  801260:	48 bf 98 11 80 00 00 	movabs $0x801198,%rdi
  801267:	00 00 00 
  80126a:	48 b8 da 09 80 00 00 	movabs $0x8009da,%rax
  801271:	00 00 00 
  801274:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801276:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80127a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80127d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801280:	c9                   	leaveq 
  801281:	c3                   	retq   

0000000000801282 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801282:	55                   	push   %rbp
  801283:	48 89 e5             	mov    %rsp,%rbp
  801286:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80128d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801294:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80129a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012a1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012a8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012af:	84 c0                	test   %al,%al
  8012b1:	74 20                	je     8012d3 <snprintf+0x51>
  8012b3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012b7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012bb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012bf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012c3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012c7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012cb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012cf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012d3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012da:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8012e1:	00 00 00 
  8012e4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8012eb:	00 00 00 
  8012ee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012f2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8012f9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801300:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801307:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80130e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801315:	48 8b 0a             	mov    (%rdx),%rcx
  801318:	48 89 08             	mov    %rcx,(%rax)
  80131b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80131f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801323:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801327:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80132b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801332:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801339:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80133f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801346:	48 89 c7             	mov    %rax,%rdi
  801349:	48 b8 e5 11 80 00 00 	movabs $0x8011e5,%rax
  801350:	00 00 00 
  801353:	ff d0                	callq  *%rax
  801355:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80135b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801361:	c9                   	leaveq 
  801362:	c3                   	retq   

0000000000801363 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801363:	55                   	push   %rbp
  801364:	48 89 e5             	mov    %rsp,%rbp
  801367:	48 83 ec 18          	sub    $0x18,%rsp
  80136b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80136f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801376:	eb 09                	jmp    801381 <strlen+0x1e>
		n++;
  801378:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80137c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801381:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801385:	0f b6 00             	movzbl (%rax),%eax
  801388:	84 c0                	test   %al,%al
  80138a:	75 ec                	jne    801378 <strlen+0x15>
		n++;
	return n;
  80138c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80138f:	c9                   	leaveq 
  801390:	c3                   	retq   

0000000000801391 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801391:	55                   	push   %rbp
  801392:	48 89 e5             	mov    %rsp,%rbp
  801395:	48 83 ec 20          	sub    $0x20,%rsp
  801399:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80139d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013a8:	eb 0e                	jmp    8013b8 <strnlen+0x27>
		n++;
  8013aa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013ae:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013b3:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013b8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8013bd:	74 0b                	je     8013ca <strnlen+0x39>
  8013bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c3:	0f b6 00             	movzbl (%rax),%eax
  8013c6:	84 c0                	test   %al,%al
  8013c8:	75 e0                	jne    8013aa <strnlen+0x19>
		n++;
	return n;
  8013ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013cd:	c9                   	leaveq 
  8013ce:	c3                   	retq   

00000000008013cf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013cf:	55                   	push   %rbp
  8013d0:	48 89 e5             	mov    %rsp,%rbp
  8013d3:	48 83 ec 20          	sub    $0x20,%rsp
  8013d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8013df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8013e7:	90                   	nop
  8013e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ec:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013f0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013f4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013f8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013fc:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801400:	0f b6 12             	movzbl (%rdx),%edx
  801403:	88 10                	mov    %dl,(%rax)
  801405:	0f b6 00             	movzbl (%rax),%eax
  801408:	84 c0                	test   %al,%al
  80140a:	75 dc                	jne    8013e8 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80140c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801410:	c9                   	leaveq 
  801411:	c3                   	retq   

0000000000801412 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801412:	55                   	push   %rbp
  801413:	48 89 e5             	mov    %rsp,%rbp
  801416:	48 83 ec 20          	sub    $0x20,%rsp
  80141a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80141e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801422:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801426:	48 89 c7             	mov    %rax,%rdi
  801429:	48 b8 63 13 80 00 00 	movabs $0x801363,%rax
  801430:	00 00 00 
  801433:	ff d0                	callq  *%rax
  801435:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801438:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80143b:	48 63 d0             	movslq %eax,%rdx
  80143e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801442:	48 01 c2             	add    %rax,%rdx
  801445:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801449:	48 89 c6             	mov    %rax,%rsi
  80144c:	48 89 d7             	mov    %rdx,%rdi
  80144f:	48 b8 cf 13 80 00 00 	movabs $0x8013cf,%rax
  801456:	00 00 00 
  801459:	ff d0                	callq  *%rax
	return dst;
  80145b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80145f:	c9                   	leaveq 
  801460:	c3                   	retq   

0000000000801461 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801461:	55                   	push   %rbp
  801462:	48 89 e5             	mov    %rsp,%rbp
  801465:	48 83 ec 28          	sub    $0x28,%rsp
  801469:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80146d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801471:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801479:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80147d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801484:	00 
  801485:	eb 2a                	jmp    8014b1 <strncpy+0x50>
		*dst++ = *src;
  801487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80148f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801493:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801497:	0f b6 12             	movzbl (%rdx),%edx
  80149a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80149c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014a0:	0f b6 00             	movzbl (%rax),%eax
  8014a3:	84 c0                	test   %al,%al
  8014a5:	74 05                	je     8014ac <strncpy+0x4b>
			src++;
  8014a7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014b9:	72 cc                	jb     801487 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014bf:	c9                   	leaveq 
  8014c0:	c3                   	retq   

00000000008014c1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014c1:	55                   	push   %rbp
  8014c2:	48 89 e5             	mov    %rsp,%rbp
  8014c5:	48 83 ec 28          	sub    $0x28,%rsp
  8014c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8014dd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014e2:	74 3d                	je     801521 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8014e4:	eb 1d                	jmp    801503 <strlcpy+0x42>
			*dst++ = *src++;
  8014e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014ee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014f6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014fa:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8014fe:	0f b6 12             	movzbl (%rdx),%edx
  801501:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801503:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801508:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80150d:	74 0b                	je     80151a <strlcpy+0x59>
  80150f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801513:	0f b6 00             	movzbl (%rax),%eax
  801516:	84 c0                	test   %al,%al
  801518:	75 cc                	jne    8014e6 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80151a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801521:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801525:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801529:	48 29 c2             	sub    %rax,%rdx
  80152c:	48 89 d0             	mov    %rdx,%rax
}
  80152f:	c9                   	leaveq 
  801530:	c3                   	retq   

0000000000801531 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801531:	55                   	push   %rbp
  801532:	48 89 e5             	mov    %rsp,%rbp
  801535:	48 83 ec 10          	sub    $0x10,%rsp
  801539:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80153d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801541:	eb 0a                	jmp    80154d <strcmp+0x1c>
		p++, q++;
  801543:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801548:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80154d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801551:	0f b6 00             	movzbl (%rax),%eax
  801554:	84 c0                	test   %al,%al
  801556:	74 12                	je     80156a <strcmp+0x39>
  801558:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155c:	0f b6 10             	movzbl (%rax),%edx
  80155f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801563:	0f b6 00             	movzbl (%rax),%eax
  801566:	38 c2                	cmp    %al,%dl
  801568:	74 d9                	je     801543 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80156a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156e:	0f b6 00             	movzbl (%rax),%eax
  801571:	0f b6 d0             	movzbl %al,%edx
  801574:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801578:	0f b6 00             	movzbl (%rax),%eax
  80157b:	0f b6 c0             	movzbl %al,%eax
  80157e:	29 c2                	sub    %eax,%edx
  801580:	89 d0                	mov    %edx,%eax
}
  801582:	c9                   	leaveq 
  801583:	c3                   	retq   

0000000000801584 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801584:	55                   	push   %rbp
  801585:	48 89 e5             	mov    %rsp,%rbp
  801588:	48 83 ec 18          	sub    $0x18,%rsp
  80158c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801590:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801594:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801598:	eb 0f                	jmp    8015a9 <strncmp+0x25>
		n--, p++, q++;
  80159a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80159f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015a4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8015a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015ae:	74 1d                	je     8015cd <strncmp+0x49>
  8015b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b4:	0f b6 00             	movzbl (%rax),%eax
  8015b7:	84 c0                	test   %al,%al
  8015b9:	74 12                	je     8015cd <strncmp+0x49>
  8015bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015bf:	0f b6 10             	movzbl (%rax),%edx
  8015c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c6:	0f b6 00             	movzbl (%rax),%eax
  8015c9:	38 c2                	cmp    %al,%dl
  8015cb:	74 cd                	je     80159a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015cd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015d2:	75 07                	jne    8015db <strncmp+0x57>
		return 0;
  8015d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d9:	eb 18                	jmp    8015f3 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015df:	0f b6 00             	movzbl (%rax),%eax
  8015e2:	0f b6 d0             	movzbl %al,%edx
  8015e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e9:	0f b6 00             	movzbl (%rax),%eax
  8015ec:	0f b6 c0             	movzbl %al,%eax
  8015ef:	29 c2                	sub    %eax,%edx
  8015f1:	89 d0                	mov    %edx,%eax
}
  8015f3:	c9                   	leaveq 
  8015f4:	c3                   	retq   

00000000008015f5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015f5:	55                   	push   %rbp
  8015f6:	48 89 e5             	mov    %rsp,%rbp
  8015f9:	48 83 ec 0c          	sub    $0xc,%rsp
  8015fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801601:	89 f0                	mov    %esi,%eax
  801603:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801606:	eb 17                	jmp    80161f <strchr+0x2a>
		if (*s == c)
  801608:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160c:	0f b6 00             	movzbl (%rax),%eax
  80160f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801612:	75 06                	jne    80161a <strchr+0x25>
			return (char *) s;
  801614:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801618:	eb 15                	jmp    80162f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80161a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80161f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801623:	0f b6 00             	movzbl (%rax),%eax
  801626:	84 c0                	test   %al,%al
  801628:	75 de                	jne    801608 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80162a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80162f:	c9                   	leaveq 
  801630:	c3                   	retq   

0000000000801631 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801631:	55                   	push   %rbp
  801632:	48 89 e5             	mov    %rsp,%rbp
  801635:	48 83 ec 0c          	sub    $0xc,%rsp
  801639:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80163d:	89 f0                	mov    %esi,%eax
  80163f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801642:	eb 13                	jmp    801657 <strfind+0x26>
		if (*s == c)
  801644:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801648:	0f b6 00             	movzbl (%rax),%eax
  80164b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80164e:	75 02                	jne    801652 <strfind+0x21>
			break;
  801650:	eb 10                	jmp    801662 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801652:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801657:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165b:	0f b6 00             	movzbl (%rax),%eax
  80165e:	84 c0                	test   %al,%al
  801660:	75 e2                	jne    801644 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801662:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801666:	c9                   	leaveq 
  801667:	c3                   	retq   

0000000000801668 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801668:	55                   	push   %rbp
  801669:	48 89 e5             	mov    %rsp,%rbp
  80166c:	48 83 ec 18          	sub    $0x18,%rsp
  801670:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801674:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801677:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80167b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801680:	75 06                	jne    801688 <memset+0x20>
		return v;
  801682:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801686:	eb 69                	jmp    8016f1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801688:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168c:	83 e0 03             	and    $0x3,%eax
  80168f:	48 85 c0             	test   %rax,%rax
  801692:	75 48                	jne    8016dc <memset+0x74>
  801694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801698:	83 e0 03             	and    $0x3,%eax
  80169b:	48 85 c0             	test   %rax,%rax
  80169e:	75 3c                	jne    8016dc <memset+0x74>
		c &= 0xFF;
  8016a0:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8016a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016aa:	c1 e0 18             	shl    $0x18,%eax
  8016ad:	89 c2                	mov    %eax,%edx
  8016af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016b2:	c1 e0 10             	shl    $0x10,%eax
  8016b5:	09 c2                	or     %eax,%edx
  8016b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016ba:	c1 e0 08             	shl    $0x8,%eax
  8016bd:	09 d0                	or     %edx,%eax
  8016bf:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8016c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c6:	48 c1 e8 02          	shr    $0x2,%rax
  8016ca:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016d4:	48 89 d7             	mov    %rdx,%rdi
  8016d7:	fc                   	cld    
  8016d8:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016da:	eb 11                	jmp    8016ed <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8016dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016e3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016e7:	48 89 d7             	mov    %rdx,%rdi
  8016ea:	fc                   	cld    
  8016eb:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8016ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016f1:	c9                   	leaveq 
  8016f2:	c3                   	retq   

00000000008016f3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8016f3:	55                   	push   %rbp
  8016f4:	48 89 e5             	mov    %rsp,%rbp
  8016f7:	48 83 ec 28          	sub    $0x28,%rsp
  8016fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801703:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801707:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80170b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80170f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801713:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801717:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80171b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80171f:	0f 83 88 00 00 00    	jae    8017ad <memmove+0xba>
  801725:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801729:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80172d:	48 01 d0             	add    %rdx,%rax
  801730:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801734:	76 77                	jbe    8017ad <memmove+0xba>
		s += n;
  801736:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80173e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801742:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801746:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80174a:	83 e0 03             	and    $0x3,%eax
  80174d:	48 85 c0             	test   %rax,%rax
  801750:	75 3b                	jne    80178d <memmove+0x9a>
  801752:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801756:	83 e0 03             	and    $0x3,%eax
  801759:	48 85 c0             	test   %rax,%rax
  80175c:	75 2f                	jne    80178d <memmove+0x9a>
  80175e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801762:	83 e0 03             	and    $0x3,%eax
  801765:	48 85 c0             	test   %rax,%rax
  801768:	75 23                	jne    80178d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80176a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80176e:	48 83 e8 04          	sub    $0x4,%rax
  801772:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801776:	48 83 ea 04          	sub    $0x4,%rdx
  80177a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80177e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801782:	48 89 c7             	mov    %rax,%rdi
  801785:	48 89 d6             	mov    %rdx,%rsi
  801788:	fd                   	std    
  801789:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80178b:	eb 1d                	jmp    8017aa <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80178d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801791:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801795:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801799:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80179d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a1:	48 89 d7             	mov    %rdx,%rdi
  8017a4:	48 89 c1             	mov    %rax,%rcx
  8017a7:	fd                   	std    
  8017a8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017aa:	fc                   	cld    
  8017ab:	eb 57                	jmp    801804 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b1:	83 e0 03             	and    $0x3,%eax
  8017b4:	48 85 c0             	test   %rax,%rax
  8017b7:	75 36                	jne    8017ef <memmove+0xfc>
  8017b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017bd:	83 e0 03             	and    $0x3,%eax
  8017c0:	48 85 c0             	test   %rax,%rax
  8017c3:	75 2a                	jne    8017ef <memmove+0xfc>
  8017c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c9:	83 e0 03             	and    $0x3,%eax
  8017cc:	48 85 c0             	test   %rax,%rax
  8017cf:	75 1e                	jne    8017ef <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d5:	48 c1 e8 02          	shr    $0x2,%rax
  8017d9:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8017dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017e4:	48 89 c7             	mov    %rax,%rdi
  8017e7:	48 89 d6             	mov    %rdx,%rsi
  8017ea:	fc                   	cld    
  8017eb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017ed:	eb 15                	jmp    801804 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8017ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017f3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017f7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017fb:	48 89 c7             	mov    %rax,%rdi
  8017fe:	48 89 d6             	mov    %rdx,%rsi
  801801:	fc                   	cld    
  801802:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801804:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801808:	c9                   	leaveq 
  801809:	c3                   	retq   

000000000080180a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80180a:	55                   	push   %rbp
  80180b:	48 89 e5             	mov    %rsp,%rbp
  80180e:	48 83 ec 18          	sub    $0x18,%rsp
  801812:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801816:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80181a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80181e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801822:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801826:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80182a:	48 89 ce             	mov    %rcx,%rsi
  80182d:	48 89 c7             	mov    %rax,%rdi
  801830:	48 b8 f3 16 80 00 00 	movabs $0x8016f3,%rax
  801837:	00 00 00 
  80183a:	ff d0                	callq  *%rax
}
  80183c:	c9                   	leaveq 
  80183d:	c3                   	retq   

000000000080183e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80183e:	55                   	push   %rbp
  80183f:	48 89 e5             	mov    %rsp,%rbp
  801842:	48 83 ec 28          	sub    $0x28,%rsp
  801846:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80184a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80184e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801852:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801856:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80185a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80185e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801862:	eb 36                	jmp    80189a <memcmp+0x5c>
		if (*s1 != *s2)
  801864:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801868:	0f b6 10             	movzbl (%rax),%edx
  80186b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80186f:	0f b6 00             	movzbl (%rax),%eax
  801872:	38 c2                	cmp    %al,%dl
  801874:	74 1a                	je     801890 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801876:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80187a:	0f b6 00             	movzbl (%rax),%eax
  80187d:	0f b6 d0             	movzbl %al,%edx
  801880:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801884:	0f b6 00             	movzbl (%rax),%eax
  801887:	0f b6 c0             	movzbl %al,%eax
  80188a:	29 c2                	sub    %eax,%edx
  80188c:	89 d0                	mov    %edx,%eax
  80188e:	eb 20                	jmp    8018b0 <memcmp+0x72>
		s1++, s2++;
  801890:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801895:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80189a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018a2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018a6:	48 85 c0             	test   %rax,%rax
  8018a9:	75 b9                	jne    801864 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b0:	c9                   	leaveq 
  8018b1:	c3                   	retq   

00000000008018b2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018b2:	55                   	push   %rbp
  8018b3:	48 89 e5             	mov    %rsp,%rbp
  8018b6:	48 83 ec 28          	sub    $0x28,%rsp
  8018ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018be:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8018c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018cd:	48 01 d0             	add    %rdx,%rax
  8018d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018d4:	eb 15                	jmp    8018eb <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018da:	0f b6 10             	movzbl (%rax),%edx
  8018dd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018e0:	38 c2                	cmp    %al,%dl
  8018e2:	75 02                	jne    8018e6 <memfind+0x34>
			break;
  8018e4:	eb 0f                	jmp    8018f5 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018e6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ef:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8018f3:	72 e1                	jb     8018d6 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8018f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018f9:	c9                   	leaveq 
  8018fa:	c3                   	retq   

00000000008018fb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018fb:	55                   	push   %rbp
  8018fc:	48 89 e5             	mov    %rsp,%rbp
  8018ff:	48 83 ec 34          	sub    $0x34,%rsp
  801903:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801907:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80190b:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80190e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801915:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80191c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80191d:	eb 05                	jmp    801924 <strtol+0x29>
		s++;
  80191f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801924:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801928:	0f b6 00             	movzbl (%rax),%eax
  80192b:	3c 20                	cmp    $0x20,%al
  80192d:	74 f0                	je     80191f <strtol+0x24>
  80192f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801933:	0f b6 00             	movzbl (%rax),%eax
  801936:	3c 09                	cmp    $0x9,%al
  801938:	74 e5                	je     80191f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80193a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193e:	0f b6 00             	movzbl (%rax),%eax
  801941:	3c 2b                	cmp    $0x2b,%al
  801943:	75 07                	jne    80194c <strtol+0x51>
		s++;
  801945:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80194a:	eb 17                	jmp    801963 <strtol+0x68>
	else if (*s == '-')
  80194c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801950:	0f b6 00             	movzbl (%rax),%eax
  801953:	3c 2d                	cmp    $0x2d,%al
  801955:	75 0c                	jne    801963 <strtol+0x68>
		s++, neg = 1;
  801957:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80195c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801963:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801967:	74 06                	je     80196f <strtol+0x74>
  801969:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80196d:	75 28                	jne    801997 <strtol+0x9c>
  80196f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801973:	0f b6 00             	movzbl (%rax),%eax
  801976:	3c 30                	cmp    $0x30,%al
  801978:	75 1d                	jne    801997 <strtol+0x9c>
  80197a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197e:	48 83 c0 01          	add    $0x1,%rax
  801982:	0f b6 00             	movzbl (%rax),%eax
  801985:	3c 78                	cmp    $0x78,%al
  801987:	75 0e                	jne    801997 <strtol+0x9c>
		s += 2, base = 16;
  801989:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80198e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801995:	eb 2c                	jmp    8019c3 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801997:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80199b:	75 19                	jne    8019b6 <strtol+0xbb>
  80199d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a1:	0f b6 00             	movzbl (%rax),%eax
  8019a4:	3c 30                	cmp    $0x30,%al
  8019a6:	75 0e                	jne    8019b6 <strtol+0xbb>
		s++, base = 8;
  8019a8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019ad:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8019b4:	eb 0d                	jmp    8019c3 <strtol+0xc8>
	else if (base == 0)
  8019b6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019ba:	75 07                	jne    8019c3 <strtol+0xc8>
		base = 10;
  8019bc:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c7:	0f b6 00             	movzbl (%rax),%eax
  8019ca:	3c 2f                	cmp    $0x2f,%al
  8019cc:	7e 1d                	jle    8019eb <strtol+0xf0>
  8019ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d2:	0f b6 00             	movzbl (%rax),%eax
  8019d5:	3c 39                	cmp    $0x39,%al
  8019d7:	7f 12                	jg     8019eb <strtol+0xf0>
			dig = *s - '0';
  8019d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019dd:	0f b6 00             	movzbl (%rax),%eax
  8019e0:	0f be c0             	movsbl %al,%eax
  8019e3:	83 e8 30             	sub    $0x30,%eax
  8019e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019e9:	eb 4e                	jmp    801a39 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8019eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ef:	0f b6 00             	movzbl (%rax),%eax
  8019f2:	3c 60                	cmp    $0x60,%al
  8019f4:	7e 1d                	jle    801a13 <strtol+0x118>
  8019f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fa:	0f b6 00             	movzbl (%rax),%eax
  8019fd:	3c 7a                	cmp    $0x7a,%al
  8019ff:	7f 12                	jg     801a13 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a05:	0f b6 00             	movzbl (%rax),%eax
  801a08:	0f be c0             	movsbl %al,%eax
  801a0b:	83 e8 57             	sub    $0x57,%eax
  801a0e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a11:	eb 26                	jmp    801a39 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a17:	0f b6 00             	movzbl (%rax),%eax
  801a1a:	3c 40                	cmp    $0x40,%al
  801a1c:	7e 48                	jle    801a66 <strtol+0x16b>
  801a1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a22:	0f b6 00             	movzbl (%rax),%eax
  801a25:	3c 5a                	cmp    $0x5a,%al
  801a27:	7f 3d                	jg     801a66 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2d:	0f b6 00             	movzbl (%rax),%eax
  801a30:	0f be c0             	movsbl %al,%eax
  801a33:	83 e8 37             	sub    $0x37,%eax
  801a36:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a39:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a3c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a3f:	7c 02                	jl     801a43 <strtol+0x148>
			break;
  801a41:	eb 23                	jmp    801a66 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a43:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a48:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a4b:	48 98                	cltq   
  801a4d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a52:	48 89 c2             	mov    %rax,%rdx
  801a55:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a58:	48 98                	cltq   
  801a5a:	48 01 d0             	add    %rdx,%rax
  801a5d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a61:	e9 5d ff ff ff       	jmpq   8019c3 <strtol+0xc8>

	if (endptr)
  801a66:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a6b:	74 0b                	je     801a78 <strtol+0x17d>
		*endptr = (char *) s;
  801a6d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a71:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a75:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a7c:	74 09                	je     801a87 <strtol+0x18c>
  801a7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a82:	48 f7 d8             	neg    %rax
  801a85:	eb 04                	jmp    801a8b <strtol+0x190>
  801a87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a8b:	c9                   	leaveq 
  801a8c:	c3                   	retq   

0000000000801a8d <strstr>:

char * strstr(const char *in, const char *str)
{
  801a8d:	55                   	push   %rbp
  801a8e:	48 89 e5             	mov    %rsp,%rbp
  801a91:	48 83 ec 30          	sub    $0x30,%rsp
  801a95:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a99:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801a9d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801aa1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801aa5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801aa9:	0f b6 00             	movzbl (%rax),%eax
  801aac:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801aaf:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801ab3:	75 06                	jne    801abb <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801ab5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab9:	eb 6b                	jmp    801b26 <strstr+0x99>

    len = strlen(str);
  801abb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801abf:	48 89 c7             	mov    %rax,%rdi
  801ac2:	48 b8 63 13 80 00 00 	movabs $0x801363,%rax
  801ac9:	00 00 00 
  801acc:	ff d0                	callq  *%rax
  801ace:	48 98                	cltq   
  801ad0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801ad4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801adc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ae0:	0f b6 00             	movzbl (%rax),%eax
  801ae3:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801ae6:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801aea:	75 07                	jne    801af3 <strstr+0x66>
                return (char *) 0;
  801aec:	b8 00 00 00 00       	mov    $0x0,%eax
  801af1:	eb 33                	jmp    801b26 <strstr+0x99>
        } while (sc != c);
  801af3:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801af7:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801afa:	75 d8                	jne    801ad4 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801afc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b00:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b08:	48 89 ce             	mov    %rcx,%rsi
  801b0b:	48 89 c7             	mov    %rax,%rdi
  801b0e:	48 b8 84 15 80 00 00 	movabs $0x801584,%rax
  801b15:	00 00 00 
  801b18:	ff d0                	callq  *%rax
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	75 b6                	jne    801ad4 <strstr+0x47>

    return (char *) (in - 1);
  801b1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b22:	48 83 e8 01          	sub    $0x1,%rax
}
  801b26:	c9                   	leaveq 
  801b27:	c3                   	retq   

0000000000801b28 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b28:	55                   	push   %rbp
  801b29:	48 89 e5             	mov    %rsp,%rbp
  801b2c:	53                   	push   %rbx
  801b2d:	48 83 ec 48          	sub    $0x48,%rsp
  801b31:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b34:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b37:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b3b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b3f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b43:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b47:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b4a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b4e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b52:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b56:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b5a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b5e:	4c 89 c3             	mov    %r8,%rbx
  801b61:	cd 30                	int    $0x30
  801b63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801b67:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b6b:	74 3e                	je     801bab <syscall+0x83>
  801b6d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b72:	7e 37                	jle    801bab <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b78:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b7b:	49 89 d0             	mov    %rdx,%r8
  801b7e:	89 c1                	mov    %eax,%ecx
  801b80:	48 ba a0 44 80 00 00 	movabs $0x8044a0,%rdx
  801b87:	00 00 00 
  801b8a:	be 23 00 00 00       	mov    $0x23,%esi
  801b8f:	48 bf bd 44 80 00 00 	movabs $0x8044bd,%rdi
  801b96:	00 00 00 
  801b99:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9e:	49 b9 ee 03 80 00 00 	movabs $0x8003ee,%r9
  801ba5:	00 00 00 
  801ba8:	41 ff d1             	callq  *%r9

	return ret;
  801bab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801baf:	48 83 c4 48          	add    $0x48,%rsp
  801bb3:	5b                   	pop    %rbx
  801bb4:	5d                   	pop    %rbp
  801bb5:	c3                   	retq   

0000000000801bb6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801bb6:	55                   	push   %rbp
  801bb7:	48 89 e5             	mov    %rsp,%rbp
  801bba:	48 83 ec 20          	sub    $0x20,%rsp
  801bbe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bc2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801bc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd5:	00 
  801bd6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bdc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be2:	48 89 d1             	mov    %rdx,%rcx
  801be5:	48 89 c2             	mov    %rax,%rdx
  801be8:	be 00 00 00 00       	mov    $0x0,%esi
  801bed:	bf 00 00 00 00       	mov    $0x0,%edi
  801bf2:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  801bf9:	00 00 00 
  801bfc:	ff d0                	callq  *%rax
}
  801bfe:	c9                   	leaveq 
  801bff:	c3                   	retq   

0000000000801c00 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c00:	55                   	push   %rbp
  801c01:	48 89 e5             	mov    %rsp,%rbp
  801c04:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c08:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c0f:	00 
  801c10:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c16:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c21:	ba 00 00 00 00       	mov    $0x0,%edx
  801c26:	be 00 00 00 00       	mov    $0x0,%esi
  801c2b:	bf 01 00 00 00       	mov    $0x1,%edi
  801c30:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  801c37:	00 00 00 
  801c3a:	ff d0                	callq  *%rax
}
  801c3c:	c9                   	leaveq 
  801c3d:	c3                   	retq   

0000000000801c3e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c3e:	55                   	push   %rbp
  801c3f:	48 89 e5             	mov    %rsp,%rbp
  801c42:	48 83 ec 10          	sub    $0x10,%rsp
  801c46:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4c:	48 98                	cltq   
  801c4e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c55:	00 
  801c56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c62:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c67:	48 89 c2             	mov    %rax,%rdx
  801c6a:	be 01 00 00 00       	mov    $0x1,%esi
  801c6f:	bf 03 00 00 00       	mov    $0x3,%edi
  801c74:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  801c7b:	00 00 00 
  801c7e:	ff d0                	callq  *%rax
}
  801c80:	c9                   	leaveq 
  801c81:	c3                   	retq   

0000000000801c82 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c82:	55                   	push   %rbp
  801c83:	48 89 e5             	mov    %rsp,%rbp
  801c86:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c8a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c91:	00 
  801c92:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c98:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ca3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca8:	be 00 00 00 00       	mov    $0x0,%esi
  801cad:	bf 02 00 00 00       	mov    $0x2,%edi
  801cb2:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  801cb9:	00 00 00 
  801cbc:	ff d0                	callq  *%rax
}
  801cbe:	c9                   	leaveq 
  801cbf:	c3                   	retq   

0000000000801cc0 <sys_yield>:

void
sys_yield(void)
{
  801cc0:	55                   	push   %rbp
  801cc1:	48 89 e5             	mov    %rsp,%rbp
  801cc4:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801cc8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ccf:	00 
  801cd0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cdc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ce1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce6:	be 00 00 00 00       	mov    $0x0,%esi
  801ceb:	bf 0b 00 00 00       	mov    $0xb,%edi
  801cf0:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  801cf7:	00 00 00 
  801cfa:	ff d0                	callq  *%rax
}
  801cfc:	c9                   	leaveq 
  801cfd:	c3                   	retq   

0000000000801cfe <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801cfe:	55                   	push   %rbp
  801cff:	48 89 e5             	mov    %rsp,%rbp
  801d02:	48 83 ec 20          	sub    $0x20,%rsp
  801d06:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d0d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d10:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d13:	48 63 c8             	movslq %eax,%rcx
  801d16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1d:	48 98                	cltq   
  801d1f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d26:	00 
  801d27:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d2d:	49 89 c8             	mov    %rcx,%r8
  801d30:	48 89 d1             	mov    %rdx,%rcx
  801d33:	48 89 c2             	mov    %rax,%rdx
  801d36:	be 01 00 00 00       	mov    $0x1,%esi
  801d3b:	bf 04 00 00 00       	mov    $0x4,%edi
  801d40:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  801d47:	00 00 00 
  801d4a:	ff d0                	callq  *%rax
}
  801d4c:	c9                   	leaveq 
  801d4d:	c3                   	retq   

0000000000801d4e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d4e:	55                   	push   %rbp
  801d4f:	48 89 e5             	mov    %rsp,%rbp
  801d52:	48 83 ec 30          	sub    $0x30,%rsp
  801d56:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d5d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d60:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d64:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d68:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d6b:	48 63 c8             	movslq %eax,%rcx
  801d6e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d72:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d75:	48 63 f0             	movslq %eax,%rsi
  801d78:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d7f:	48 98                	cltq   
  801d81:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d85:	49 89 f9             	mov    %rdi,%r9
  801d88:	49 89 f0             	mov    %rsi,%r8
  801d8b:	48 89 d1             	mov    %rdx,%rcx
  801d8e:	48 89 c2             	mov    %rax,%rdx
  801d91:	be 01 00 00 00       	mov    $0x1,%esi
  801d96:	bf 05 00 00 00       	mov    $0x5,%edi
  801d9b:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  801da2:	00 00 00 
  801da5:	ff d0                	callq  *%rax
}
  801da7:	c9                   	leaveq 
  801da8:	c3                   	retq   

0000000000801da9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801da9:	55                   	push   %rbp
  801daa:	48 89 e5             	mov    %rsp,%rbp
  801dad:	48 83 ec 20          	sub    $0x20,%rsp
  801db1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801db4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801db8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dbf:	48 98                	cltq   
  801dc1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dc8:	00 
  801dc9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dcf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd5:	48 89 d1             	mov    %rdx,%rcx
  801dd8:	48 89 c2             	mov    %rax,%rdx
  801ddb:	be 01 00 00 00       	mov    $0x1,%esi
  801de0:	bf 06 00 00 00       	mov    $0x6,%edi
  801de5:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  801dec:	00 00 00 
  801def:	ff d0                	callq  *%rax
}
  801df1:	c9                   	leaveq 
  801df2:	c3                   	retq   

0000000000801df3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801df3:	55                   	push   %rbp
  801df4:	48 89 e5             	mov    %rsp,%rbp
  801df7:	48 83 ec 10          	sub    $0x10,%rsp
  801dfb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dfe:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e01:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e04:	48 63 d0             	movslq %eax,%rdx
  801e07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e0a:	48 98                	cltq   
  801e0c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e13:	00 
  801e14:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e1a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e20:	48 89 d1             	mov    %rdx,%rcx
  801e23:	48 89 c2             	mov    %rax,%rdx
  801e26:	be 01 00 00 00       	mov    $0x1,%esi
  801e2b:	bf 08 00 00 00       	mov    $0x8,%edi
  801e30:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  801e37:	00 00 00 
  801e3a:	ff d0                	callq  *%rax
}
  801e3c:	c9                   	leaveq 
  801e3d:	c3                   	retq   

0000000000801e3e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e3e:	55                   	push   %rbp
  801e3f:	48 89 e5             	mov    %rsp,%rbp
  801e42:	48 83 ec 20          	sub    $0x20,%rsp
  801e46:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e49:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e54:	48 98                	cltq   
  801e56:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e5d:	00 
  801e5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e6a:	48 89 d1             	mov    %rdx,%rcx
  801e6d:	48 89 c2             	mov    %rax,%rdx
  801e70:	be 01 00 00 00       	mov    $0x1,%esi
  801e75:	bf 09 00 00 00       	mov    $0x9,%edi
  801e7a:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  801e81:	00 00 00 
  801e84:	ff d0                	callq  *%rax
}
  801e86:	c9                   	leaveq 
  801e87:	c3                   	retq   

0000000000801e88 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e88:	55                   	push   %rbp
  801e89:	48 89 e5             	mov    %rsp,%rbp
  801e8c:	48 83 ec 20          	sub    $0x20,%rsp
  801e90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801e97:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e9e:	48 98                	cltq   
  801ea0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ea7:	00 
  801ea8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eb4:	48 89 d1             	mov    %rdx,%rcx
  801eb7:	48 89 c2             	mov    %rax,%rdx
  801eba:	be 01 00 00 00       	mov    $0x1,%esi
  801ebf:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ec4:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  801ecb:	00 00 00 
  801ece:	ff d0                	callq  *%rax
}
  801ed0:	c9                   	leaveq 
  801ed1:	c3                   	retq   

0000000000801ed2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ed2:	55                   	push   %rbp
  801ed3:	48 89 e5             	mov    %rsp,%rbp
  801ed6:	48 83 ec 20          	sub    $0x20,%rsp
  801eda:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801edd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ee1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ee5:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ee8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801eeb:	48 63 f0             	movslq %eax,%rsi
  801eee:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ef2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef5:	48 98                	cltq   
  801ef7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801efb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f02:	00 
  801f03:	49 89 f1             	mov    %rsi,%r9
  801f06:	49 89 c8             	mov    %rcx,%r8
  801f09:	48 89 d1             	mov    %rdx,%rcx
  801f0c:	48 89 c2             	mov    %rax,%rdx
  801f0f:	be 00 00 00 00       	mov    $0x0,%esi
  801f14:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f19:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  801f20:	00 00 00 
  801f23:	ff d0                	callq  *%rax
}
  801f25:	c9                   	leaveq 
  801f26:	c3                   	retq   

0000000000801f27 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f27:	55                   	push   %rbp
  801f28:	48 89 e5             	mov    %rsp,%rbp
  801f2b:	48 83 ec 10          	sub    $0x10,%rsp
  801f2f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f37:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f3e:	00 
  801f3f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f45:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f4b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f50:	48 89 c2             	mov    %rax,%rdx
  801f53:	be 01 00 00 00       	mov    $0x1,%esi
  801f58:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f5d:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  801f64:	00 00 00 
  801f67:	ff d0                	callq  *%rax
}
  801f69:	c9                   	leaveq 
  801f6a:	c3                   	retq   

0000000000801f6b <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801f6b:	55                   	push   %rbp
  801f6c:	48 89 e5             	mov    %rsp,%rbp
  801f6f:	48 83 ec 30          	sub    $0x30,%rsp
  801f73:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f7b:	48 8b 00             	mov    (%rax),%rax
  801f7e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801f82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f86:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f8a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)))
  801f8d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f90:	83 e0 02             	and    $0x2,%eax
  801f93:	85 c0                	test   %eax,%eax
  801f95:	74 23                	je     801fba <pgfault+0x4f>
  801f97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f9b:	48 c1 e8 0c          	shr    $0xc,%rax
  801f9f:	48 89 c2             	mov    %rax,%rdx
  801fa2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fa9:	01 00 00 
  801fac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb0:	25 00 08 00 00       	and    $0x800,%eax
  801fb5:	48 85 c0             	test   %rax,%rax
  801fb8:	75 2a                	jne    801fe4 <pgfault+0x79>
		panic("fail check at fork pgfault");
  801fba:	48 ba cb 44 80 00 00 	movabs $0x8044cb,%rdx
  801fc1:	00 00 00 
  801fc4:	be 1d 00 00 00       	mov    $0x1d,%esi
  801fc9:	48 bf e6 44 80 00 00 	movabs $0x8044e6,%rdi
  801fd0:	00 00 00 
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd8:	48 b9 ee 03 80 00 00 	movabs $0x8003ee,%rcx
  801fdf:	00 00 00 
  801fe2:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801fe4:	ba 07 00 00 00       	mov    $0x7,%edx
  801fe9:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fee:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff3:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  801ffa:	00 00 00 
  801ffd:	ff d0                	callq  *%rax

	addr = ROUNDDOWN(addr, PGSIZE);
  801fff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802003:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802007:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80200b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802011:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memmove(PFTEMP, addr, PGSIZE);
  802015:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802019:	ba 00 10 00 00       	mov    $0x1000,%edx
  80201e:	48 89 c6             	mov    %rax,%rsi
  802021:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802026:	48 b8 f3 16 80 00 00 	movabs $0x8016f3,%rax
  80202d:	00 00 00 
  802030:	ff d0                	callq  *%rax

	sys_page_map(0, (void *)PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W);
  802032:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802036:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80203c:	48 89 c1             	mov    %rax,%rcx
  80203f:	ba 00 00 00 00       	mov    $0x0,%edx
  802044:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802049:	bf 00 00 00 00       	mov    $0x0,%edi
  80204e:	48 b8 4e 1d 80 00 00 	movabs $0x801d4e,%rax
  802055:	00 00 00 
  802058:	ff d0                	callq  *%rax
	sys_page_unmap(0, PFTEMP);
  80205a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80205f:	bf 00 00 00 00       	mov    $0x0,%edi
  802064:	48 b8 a9 1d 80 00 00 	movabs $0x801da9,%rax
  80206b:	00 00 00 
  80206e:	ff d0                	callq  *%rax
	//panic("pgfault not implemented");
}
  802070:	c9                   	leaveq 
  802071:	c3                   	retq   

0000000000802072 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802072:	55                   	push   %rbp
  802073:	48 89 e5             	mov    %rsp,%rbp
  802076:	48 83 ec 20          	sub    $0x20,%rsp
  80207a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80207d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uintptr_t)pn * PGSIZE);
  802080:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802083:	48 c1 e0 0c          	shl    $0xc,%rax
  802087:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	// note: modified for LAB 5, supporting PTE_SHARE
	if (uvpt[pn] & PTE_SHARE) {
  80208b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802092:	01 00 00 
  802095:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802098:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80209c:	25 00 04 00 00       	and    $0x400,%eax
  8020a1:	48 85 c0             	test   %rax,%rax
  8020a4:	74 55                	je     8020fb <duppage+0x89>
		if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL))) < 0)
  8020a6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020ad:	01 00 00 
  8020b0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8020b3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8020bc:	89 c6                	mov    %eax,%esi
  8020be:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8020c2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020c9:	41 89 f0             	mov    %esi,%r8d
  8020cc:	48 89 c6             	mov    %rax,%rsi
  8020cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8020d4:	48 b8 4e 1d 80 00 00 	movabs $0x801d4e,%rax
  8020db:	00 00 00 
  8020de:	ff d0                	callq  *%rax
  8020e0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8020e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8020e7:	79 08                	jns    8020f1 <duppage+0x7f>
			return r;
  8020e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020ec:	e9 e1 00 00 00       	jmpq   8021d2 <duppage+0x160>
		return 0;
  8020f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f6:	e9 d7 00 00 00       	jmpq   8021d2 <duppage+0x160>
	}

	// note: here we must set ~PTE_W and PTE_COW such that parent process can get correct pid
	if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  8020fb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802102:	01 00 00 
  802105:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802108:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80210c:	25 05 06 00 00       	and    $0x605,%eax
  802111:	80 cc 08             	or     $0x8,%ah
  802114:	89 c6                	mov    %eax,%esi
  802116:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80211a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80211d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802121:	41 89 f0             	mov    %esi,%r8d
  802124:	48 89 c6             	mov    %rax,%rsi
  802127:	bf 00 00 00 00       	mov    $0x0,%edi
  80212c:	48 b8 4e 1d 80 00 00 	movabs $0x801d4e,%rax
  802133:	00 00 00 
  802136:	ff d0                	callq  *%rax
  802138:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80213b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80213f:	79 08                	jns    802149 <duppage+0xd7>
		return r;
  802141:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802144:	e9 89 00 00 00       	jmpq   8021d2 <duppage+0x160>

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  802149:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802150:	01 00 00 
  802153:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802156:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80215a:	83 e0 02             	and    $0x2,%eax
  80215d:	48 85 c0             	test   %rax,%rax
  802160:	75 1b                	jne    80217d <duppage+0x10b>
  802162:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802169:	01 00 00 
  80216c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80216f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802173:	25 00 08 00 00       	and    $0x800,%eax
  802178:	48 85 c0             	test   %rax,%rax
  80217b:	74 50                	je     8021cd <duppage+0x15b>
		if ((r = sys_page_map(0, addr, 0, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  80217d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802184:	01 00 00 
  802187:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80218a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80218e:	25 05 06 00 00       	and    $0x605,%eax
  802193:	80 cc 08             	or     $0x8,%ah
  802196:	89 c1                	mov    %eax,%ecx
  802198:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80219c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021a0:	41 89 c8             	mov    %ecx,%r8d
  8021a3:	48 89 d1             	mov    %rdx,%rcx
  8021a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ab:	48 89 c6             	mov    %rax,%rsi
  8021ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b3:	48 b8 4e 1d 80 00 00 	movabs $0x801d4e,%rax
  8021ba:	00 00 00 
  8021bd:	ff d0                	callq  *%rax
  8021bf:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8021c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8021c6:	79 05                	jns    8021cd <duppage+0x15b>
			return r;
  8021c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021cb:	eb 05                	jmp    8021d2 <duppage+0x160>
	//panic("duppage not implemented");
	return 0;
  8021cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d2:	c9                   	leaveq 
  8021d3:	c3                   	retq   

00000000008021d4 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8021d4:	55                   	push   %rbp
  8021d5:	48 89 e5             	mov    %rsp,%rbp
  8021d8:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	int r;
	envid_t envid;
	int i, j, k, l, ptx = 0;
  8021dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	set_pgfault_handler(pgfault);
  8021e3:	48 bf 6b 1f 80 00 00 	movabs $0x801f6b,%rdi
  8021ea:	00 00 00 
  8021ed:	48 b8 07 3b 80 00 00 	movabs $0x803b07,%rax
  8021f4:	00 00 00 
  8021f7:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8021f9:	b8 07 00 00 00       	mov    $0x7,%eax
  8021fe:	cd 30                	int    $0x30
  802200:	89 45 e0             	mov    %eax,-0x20(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802203:	8b 45 e0             	mov    -0x20(%rbp),%eax

	if ((envid = sys_exofork()) < 0)
  802206:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802209:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80220d:	79 08                	jns    802217 <fork+0x43>
		return envid;
  80220f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802212:	e9 27 02 00 00       	jmpq   80243e <fork+0x26a>
	else if (envid == 0) {
  802217:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80221b:	75 46                	jne    802263 <fork+0x8f>
		thisenv = &envs[ENVX(sys_getenvid())];
  80221d:	48 b8 82 1c 80 00 00 	movabs $0x801c82,%rax
  802224:	00 00 00 
  802227:	ff d0                	callq  *%rax
  802229:	25 ff 03 00 00       	and    $0x3ff,%eax
  80222e:	48 63 d0             	movslq %eax,%rdx
  802231:	48 89 d0             	mov    %rdx,%rax
  802234:	48 c1 e0 03          	shl    $0x3,%rax
  802238:	48 01 d0             	add    %rdx,%rax
  80223b:	48 c1 e0 05          	shl    $0x5,%rax
  80223f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802246:	00 00 00 
  802249:	48 01 c2             	add    %rax,%rdx
  80224c:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802253:	00 00 00 
  802256:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802259:	b8 00 00 00 00       	mov    $0x0,%eax
  80225e:	e9 db 01 00 00       	jmpq   80243e <fork+0x26a>
	}

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802263:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802266:	ba 07 00 00 00       	mov    $0x7,%edx
  80226b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802270:	89 c7                	mov    %eax,%edi
  802272:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  802279:	00 00 00 
  80227c:	ff d0                	callq  *%rax
  80227e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802281:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802285:	79 08                	jns    80228f <fork+0xbb>
		return r;
  802287:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80228a:	e9 af 01 00 00       	jmpq   80243e <fork+0x26a>

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  80228f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802296:	e9 49 01 00 00       	jmpq   8023e4 <fork+0x210>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  80229b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80229e:	8d 90 ff ff ff 07    	lea    0x7ffffff(%rax),%edx
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	0f 48 c2             	cmovs  %edx,%eax
  8022a9:	c1 f8 1b             	sar    $0x1b,%eax
  8022ac:	89 c2                	mov    %eax,%edx
  8022ae:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8022b5:	01 00 00 
  8022b8:	48 63 d2             	movslq %edx,%rdx
  8022bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022bf:	83 e0 01             	and    $0x1,%eax
  8022c2:	48 85 c0             	test   %rax,%rax
  8022c5:	75 0c                	jne    8022d3 <fork+0xff>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  8022c7:	81 45 ec 00 00 00 08 	addl   $0x8000000,-0x14(%rbp)
			continue;
  8022ce:	e9 0d 01 00 00       	jmpq   8023e0 <fork+0x20c>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  8022d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8022da:	e9 f4 00 00 00       	jmpq   8023d3 <fork+0x1ff>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  8022df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022e2:	8d 90 ff ff 03 00    	lea    0x3ffff(%rax),%edx
  8022e8:	85 c0                	test   %eax,%eax
  8022ea:	0f 48 c2             	cmovs  %edx,%eax
  8022ed:	c1 f8 12             	sar    $0x12,%eax
  8022f0:	89 c2                	mov    %eax,%edx
  8022f2:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8022f9:	01 00 00 
  8022fc:	48 63 d2             	movslq %edx,%rdx
  8022ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802303:	83 e0 01             	and    $0x1,%eax
  802306:	48 85 c0             	test   %rax,%rax
  802309:	75 0c                	jne    802317 <fork+0x143>
				ptx += NPDENTRIES * NPTENTRIES;
  80230b:	81 45 ec 00 00 04 00 	addl   $0x40000,-0x14(%rbp)
				continue;
  802312:	e9 b8 00 00 00       	jmpq   8023cf <fork+0x1fb>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  802317:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80231e:	e9 9f 00 00 00       	jmpq   8023c2 <fork+0x1ee>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  802323:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802326:	8d 90 ff 01 00 00    	lea    0x1ff(%rax),%edx
  80232c:	85 c0                	test   %eax,%eax
  80232e:	0f 48 c2             	cmovs  %edx,%eax
  802331:	c1 f8 09             	sar    $0x9,%eax
  802334:	89 c2                	mov    %eax,%edx
  802336:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80233d:	01 00 00 
  802340:	48 63 d2             	movslq %edx,%rdx
  802343:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802347:	83 e0 01             	and    $0x1,%eax
  80234a:	48 85 c0             	test   %rax,%rax
  80234d:	75 09                	jne    802358 <fork+0x184>
					ptx += NPTENTRIES;
  80234f:	81 45 ec 00 02 00 00 	addl   $0x200,-0x14(%rbp)
					continue;
  802356:	eb 66                	jmp    8023be <fork+0x1ea>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  802358:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  80235f:	eb 54                	jmp    8023b5 <fork+0x1e1>
					if ((uvpt[ptx] & PTE_P) != 0)
  802361:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802368:	01 00 00 
  80236b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80236e:	48 63 d2             	movslq %edx,%rdx
  802371:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802375:	83 e0 01             	and    $0x1,%eax
  802378:	48 85 c0             	test   %rax,%rax
  80237b:	74 30                	je     8023ad <fork+0x1d9>
						if (ptx != VPN(UXSTACKTOP - PGSIZE))
  80237d:	81 7d ec ff f7 0e 00 	cmpl   $0xef7ff,-0x14(%rbp)
  802384:	74 27                	je     8023ad <fork+0x1d9>
							if ((r = duppage(envid, ptx)) < 0)
  802386:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802389:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80238c:	89 d6                	mov    %edx,%esi
  80238e:	89 c7                	mov    %eax,%edi
  802390:	48 b8 72 20 80 00 00 	movabs $0x802072,%rax
  802397:	00 00 00 
  80239a:	ff d0                	callq  *%rax
  80239c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80239f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8023a3:	79 08                	jns    8023ad <fork+0x1d9>
								return r;
  8023a5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8023a8:	e9 91 00 00 00       	jmpq   80243e <fork+0x26a>
					ptx++;
  8023ad:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  8023b1:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8023b5:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
  8023bc:	7e a3                	jle    802361 <fork+0x18d>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  8023be:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8023c2:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
  8023c9:	0f 8e 54 ff ff ff    	jle    802323 <fork+0x14f>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  8023cf:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8023d3:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
  8023da:	0f 8e ff fe ff ff    	jle    8022df <fork+0x10b>
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		return r;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  8023e0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e8:	0f 84 ad fe ff ff    	je     80229b <fork+0xc7>
			}
		}
	}

	extern void _pgfault_upcall();
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8023ee:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8023f1:	48 be 72 3b 80 00 00 	movabs $0x803b72,%rsi
  8023f8:	00 00 00 
  8023fb:	89 c7                	mov    %eax,%edi
  8023fd:	48 b8 88 1e 80 00 00 	movabs $0x801e88,%rax
  802404:	00 00 00 
  802407:	ff d0                	callq  *%rax
  802409:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80240c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802410:	79 05                	jns    802417 <fork+0x243>
		return r;
  802412:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802415:	eb 27                	jmp    80243e <fork+0x26a>
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802417:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80241a:	be 02 00 00 00       	mov    $0x2,%esi
  80241f:	89 c7                	mov    %eax,%edi
  802421:	48 b8 f3 1d 80 00 00 	movabs $0x801df3,%rax
  802428:	00 00 00 
  80242b:	ff d0                	callq  *%rax
  80242d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802430:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802434:	79 05                	jns    80243b <fork+0x267>
		return r;
  802436:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802439:	eb 03                	jmp    80243e <fork+0x26a>

	return envid;
  80243b:	8b 45 e8             	mov    -0x18(%rbp),%eax
	//panic("fork not implemented");
}
  80243e:	c9                   	leaveq 
  80243f:	c3                   	retq   

0000000000802440 <sfork>:

// Challenge!
int
sfork(void)
{
  802440:	55                   	push   %rbp
  802441:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802444:	48 ba f1 44 80 00 00 	movabs $0x8044f1,%rdx
  80244b:	00 00 00 
  80244e:	be a7 00 00 00       	mov    $0xa7,%esi
  802453:	48 bf e6 44 80 00 00 	movabs $0x8044e6,%rdi
  80245a:	00 00 00 
  80245d:	b8 00 00 00 00       	mov    $0x0,%eax
  802462:	48 b9 ee 03 80 00 00 	movabs $0x8003ee,%rcx
  802469:	00 00 00 
  80246c:	ff d1                	callq  *%rcx

000000000080246e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80246e:	55                   	push   %rbp
  80246f:	48 89 e5             	mov    %rsp,%rbp
  802472:	48 83 ec 08          	sub    $0x8,%rsp
  802476:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80247a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80247e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802485:	ff ff ff 
  802488:	48 01 d0             	add    %rdx,%rax
  80248b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80248f:	c9                   	leaveq 
  802490:	c3                   	retq   

0000000000802491 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802491:	55                   	push   %rbp
  802492:	48 89 e5             	mov    %rsp,%rbp
  802495:	48 83 ec 08          	sub    $0x8,%rsp
  802499:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80249d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024a1:	48 89 c7             	mov    %rax,%rdi
  8024a4:	48 b8 6e 24 80 00 00 	movabs $0x80246e,%rax
  8024ab:	00 00 00 
  8024ae:	ff d0                	callq  *%rax
  8024b0:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8024b6:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8024ba:	c9                   	leaveq 
  8024bb:	c3                   	retq   

00000000008024bc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8024bc:	55                   	push   %rbp
  8024bd:	48 89 e5             	mov    %rsp,%rbp
  8024c0:	48 83 ec 18          	sub    $0x18,%rsp
  8024c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024cf:	eb 6b                	jmp    80253c <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8024d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d4:	48 98                	cltq   
  8024d6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024dc:	48 c1 e0 0c          	shl    $0xc,%rax
  8024e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8024e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e8:	48 c1 e8 15          	shr    $0x15,%rax
  8024ec:	48 89 c2             	mov    %rax,%rdx
  8024ef:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024f6:	01 00 00 
  8024f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024fd:	83 e0 01             	and    $0x1,%eax
  802500:	48 85 c0             	test   %rax,%rax
  802503:	74 21                	je     802526 <fd_alloc+0x6a>
  802505:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802509:	48 c1 e8 0c          	shr    $0xc,%rax
  80250d:	48 89 c2             	mov    %rax,%rdx
  802510:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802517:	01 00 00 
  80251a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80251e:	83 e0 01             	and    $0x1,%eax
  802521:	48 85 c0             	test   %rax,%rax
  802524:	75 12                	jne    802538 <fd_alloc+0x7c>
			*fd_store = fd;
  802526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80252e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802531:	b8 00 00 00 00       	mov    $0x0,%eax
  802536:	eb 1a                	jmp    802552 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802538:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80253c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802540:	7e 8f                	jle    8024d1 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802542:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802546:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80254d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802552:	c9                   	leaveq 
  802553:	c3                   	retq   

0000000000802554 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802554:	55                   	push   %rbp
  802555:	48 89 e5             	mov    %rsp,%rbp
  802558:	48 83 ec 20          	sub    $0x20,%rsp
  80255c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80255f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802563:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802567:	78 06                	js     80256f <fd_lookup+0x1b>
  802569:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80256d:	7e 07                	jle    802576 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80256f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802574:	eb 6c                	jmp    8025e2 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802576:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802579:	48 98                	cltq   
  80257b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802581:	48 c1 e0 0c          	shl    $0xc,%rax
  802585:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802589:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80258d:	48 c1 e8 15          	shr    $0x15,%rax
  802591:	48 89 c2             	mov    %rax,%rdx
  802594:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80259b:	01 00 00 
  80259e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025a2:	83 e0 01             	and    $0x1,%eax
  8025a5:	48 85 c0             	test   %rax,%rax
  8025a8:	74 21                	je     8025cb <fd_lookup+0x77>
  8025aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025ae:	48 c1 e8 0c          	shr    $0xc,%rax
  8025b2:	48 89 c2             	mov    %rax,%rdx
  8025b5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025bc:	01 00 00 
  8025bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025c3:	83 e0 01             	and    $0x1,%eax
  8025c6:	48 85 c0             	test   %rax,%rax
  8025c9:	75 07                	jne    8025d2 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025d0:	eb 10                	jmp    8025e2 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8025d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025d6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025da:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8025dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e2:	c9                   	leaveq 
  8025e3:	c3                   	retq   

00000000008025e4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8025e4:	55                   	push   %rbp
  8025e5:	48 89 e5             	mov    %rsp,%rbp
  8025e8:	48 83 ec 30          	sub    $0x30,%rsp
  8025ec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8025f0:	89 f0                	mov    %esi,%eax
  8025f2:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8025f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025f9:	48 89 c7             	mov    %rax,%rdi
  8025fc:	48 b8 6e 24 80 00 00 	movabs $0x80246e,%rax
  802603:	00 00 00 
  802606:	ff d0                	callq  *%rax
  802608:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80260c:	48 89 d6             	mov    %rdx,%rsi
  80260f:	89 c7                	mov    %eax,%edi
  802611:	48 b8 54 25 80 00 00 	movabs $0x802554,%rax
  802618:	00 00 00 
  80261b:	ff d0                	callq  *%rax
  80261d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802620:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802624:	78 0a                	js     802630 <fd_close+0x4c>
	    || fd != fd2)
  802626:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80262a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80262e:	74 12                	je     802642 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802630:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802634:	74 05                	je     80263b <fd_close+0x57>
  802636:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802639:	eb 05                	jmp    802640 <fd_close+0x5c>
  80263b:	b8 00 00 00 00       	mov    $0x0,%eax
  802640:	eb 69                	jmp    8026ab <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802642:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802646:	8b 00                	mov    (%rax),%eax
  802648:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80264c:	48 89 d6             	mov    %rdx,%rsi
  80264f:	89 c7                	mov    %eax,%edi
  802651:	48 b8 ad 26 80 00 00 	movabs $0x8026ad,%rax
  802658:	00 00 00 
  80265b:	ff d0                	callq  *%rax
  80265d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802660:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802664:	78 2a                	js     802690 <fd_close+0xac>
		if (dev->dev_close)
  802666:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80266a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80266e:	48 85 c0             	test   %rax,%rax
  802671:	74 16                	je     802689 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802677:	48 8b 40 20          	mov    0x20(%rax),%rax
  80267b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80267f:	48 89 d7             	mov    %rdx,%rdi
  802682:	ff d0                	callq  *%rax
  802684:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802687:	eb 07                	jmp    802690 <fd_close+0xac>
		else
			r = 0;
  802689:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802690:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802694:	48 89 c6             	mov    %rax,%rsi
  802697:	bf 00 00 00 00       	mov    $0x0,%edi
  80269c:	48 b8 a9 1d 80 00 00 	movabs $0x801da9,%rax
  8026a3:	00 00 00 
  8026a6:	ff d0                	callq  *%rax
	return r;
  8026a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026ab:	c9                   	leaveq 
  8026ac:	c3                   	retq   

00000000008026ad <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8026ad:	55                   	push   %rbp
  8026ae:	48 89 e5             	mov    %rsp,%rbp
  8026b1:	48 83 ec 20          	sub    $0x20,%rsp
  8026b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8026bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026c3:	eb 41                	jmp    802706 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8026c5:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026cc:	00 00 00 
  8026cf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026d2:	48 63 d2             	movslq %edx,%rdx
  8026d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026d9:	8b 00                	mov    (%rax),%eax
  8026db:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8026de:	75 22                	jne    802702 <dev_lookup+0x55>
			*dev = devtab[i];
  8026e0:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026e7:	00 00 00 
  8026ea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026ed:	48 63 d2             	movslq %edx,%rdx
  8026f0:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8026f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026f8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802700:	eb 60                	jmp    802762 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802702:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802706:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80270d:	00 00 00 
  802710:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802713:	48 63 d2             	movslq %edx,%rdx
  802716:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80271a:	48 85 c0             	test   %rax,%rax
  80271d:	75 a6                	jne    8026c5 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80271f:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802726:	00 00 00 
  802729:	48 8b 00             	mov    (%rax),%rax
  80272c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802732:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802735:	89 c6                	mov    %eax,%esi
  802737:	48 bf 08 45 80 00 00 	movabs $0x804508,%rdi
  80273e:	00 00 00 
  802741:	b8 00 00 00 00       	mov    $0x0,%eax
  802746:	48 b9 27 06 80 00 00 	movabs $0x800627,%rcx
  80274d:	00 00 00 
  802750:	ff d1                	callq  *%rcx
	*dev = 0;
  802752:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802756:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80275d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802762:	c9                   	leaveq 
  802763:	c3                   	retq   

0000000000802764 <close>:

int
close(int fdnum)
{
  802764:	55                   	push   %rbp
  802765:	48 89 e5             	mov    %rsp,%rbp
  802768:	48 83 ec 20          	sub    $0x20,%rsp
  80276c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80276f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802773:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802776:	48 89 d6             	mov    %rdx,%rsi
  802779:	89 c7                	mov    %eax,%edi
  80277b:	48 b8 54 25 80 00 00 	movabs $0x802554,%rax
  802782:	00 00 00 
  802785:	ff d0                	callq  *%rax
  802787:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278e:	79 05                	jns    802795 <close+0x31>
		return r;
  802790:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802793:	eb 18                	jmp    8027ad <close+0x49>
	else
		return fd_close(fd, 1);
  802795:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802799:	be 01 00 00 00       	mov    $0x1,%esi
  80279e:	48 89 c7             	mov    %rax,%rdi
  8027a1:	48 b8 e4 25 80 00 00 	movabs $0x8025e4,%rax
  8027a8:	00 00 00 
  8027ab:	ff d0                	callq  *%rax
}
  8027ad:	c9                   	leaveq 
  8027ae:	c3                   	retq   

00000000008027af <close_all>:

void
close_all(void)
{
  8027af:	55                   	push   %rbp
  8027b0:	48 89 e5             	mov    %rsp,%rbp
  8027b3:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8027b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027be:	eb 15                	jmp    8027d5 <close_all+0x26>
		close(i);
  8027c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c3:	89 c7                	mov    %eax,%edi
  8027c5:	48 b8 64 27 80 00 00 	movabs $0x802764,%rax
  8027cc:	00 00 00 
  8027cf:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8027d1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027d5:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027d9:	7e e5                	jle    8027c0 <close_all+0x11>
		close(i);
}
  8027db:	c9                   	leaveq 
  8027dc:	c3                   	retq   

00000000008027dd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8027dd:	55                   	push   %rbp
  8027de:	48 89 e5             	mov    %rsp,%rbp
  8027e1:	48 83 ec 40          	sub    $0x40,%rsp
  8027e5:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8027e8:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8027eb:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8027ef:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027f2:	48 89 d6             	mov    %rdx,%rsi
  8027f5:	89 c7                	mov    %eax,%edi
  8027f7:	48 b8 54 25 80 00 00 	movabs $0x802554,%rax
  8027fe:	00 00 00 
  802801:	ff d0                	callq  *%rax
  802803:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802806:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80280a:	79 08                	jns    802814 <dup+0x37>
		return r;
  80280c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280f:	e9 70 01 00 00       	jmpq   802984 <dup+0x1a7>
	close(newfdnum);
  802814:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802817:	89 c7                	mov    %eax,%edi
  802819:	48 b8 64 27 80 00 00 	movabs $0x802764,%rax
  802820:	00 00 00 
  802823:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802825:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802828:	48 98                	cltq   
  80282a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802830:	48 c1 e0 0c          	shl    $0xc,%rax
  802834:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802838:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80283c:	48 89 c7             	mov    %rax,%rdi
  80283f:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  802846:	00 00 00 
  802849:	ff d0                	callq  *%rax
  80284b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80284f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802853:	48 89 c7             	mov    %rax,%rdi
  802856:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  80285d:	00 00 00 
  802860:	ff d0                	callq  *%rax
  802862:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286a:	48 c1 e8 15          	shr    $0x15,%rax
  80286e:	48 89 c2             	mov    %rax,%rdx
  802871:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802878:	01 00 00 
  80287b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80287f:	83 e0 01             	and    $0x1,%eax
  802882:	48 85 c0             	test   %rax,%rax
  802885:	74 73                	je     8028fa <dup+0x11d>
  802887:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80288b:	48 c1 e8 0c          	shr    $0xc,%rax
  80288f:	48 89 c2             	mov    %rax,%rdx
  802892:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802899:	01 00 00 
  80289c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028a0:	83 e0 01             	and    $0x1,%eax
  8028a3:	48 85 c0             	test   %rax,%rax
  8028a6:	74 52                	je     8028fa <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8028a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ac:	48 c1 e8 0c          	shr    $0xc,%rax
  8028b0:	48 89 c2             	mov    %rax,%rdx
  8028b3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028ba:	01 00 00 
  8028bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028c1:	25 07 0e 00 00       	and    $0xe07,%eax
  8028c6:	89 c1                	mov    %eax,%ecx
  8028c8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d0:	41 89 c8             	mov    %ecx,%r8d
  8028d3:	48 89 d1             	mov    %rdx,%rcx
  8028d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8028db:	48 89 c6             	mov    %rax,%rsi
  8028de:	bf 00 00 00 00       	mov    $0x0,%edi
  8028e3:	48 b8 4e 1d 80 00 00 	movabs $0x801d4e,%rax
  8028ea:	00 00 00 
  8028ed:	ff d0                	callq  *%rax
  8028ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028f6:	79 02                	jns    8028fa <dup+0x11d>
			goto err;
  8028f8:	eb 57                	jmp    802951 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8028fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028fe:	48 c1 e8 0c          	shr    $0xc,%rax
  802902:	48 89 c2             	mov    %rax,%rdx
  802905:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80290c:	01 00 00 
  80290f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802913:	25 07 0e 00 00       	and    $0xe07,%eax
  802918:	89 c1                	mov    %eax,%ecx
  80291a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80291e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802922:	41 89 c8             	mov    %ecx,%r8d
  802925:	48 89 d1             	mov    %rdx,%rcx
  802928:	ba 00 00 00 00       	mov    $0x0,%edx
  80292d:	48 89 c6             	mov    %rax,%rsi
  802930:	bf 00 00 00 00       	mov    $0x0,%edi
  802935:	48 b8 4e 1d 80 00 00 	movabs $0x801d4e,%rax
  80293c:	00 00 00 
  80293f:	ff d0                	callq  *%rax
  802941:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802944:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802948:	79 02                	jns    80294c <dup+0x16f>
		goto err;
  80294a:	eb 05                	jmp    802951 <dup+0x174>

	return newfdnum;
  80294c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80294f:	eb 33                	jmp    802984 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802951:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802955:	48 89 c6             	mov    %rax,%rsi
  802958:	bf 00 00 00 00       	mov    $0x0,%edi
  80295d:	48 b8 a9 1d 80 00 00 	movabs $0x801da9,%rax
  802964:	00 00 00 
  802967:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802969:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80296d:	48 89 c6             	mov    %rax,%rsi
  802970:	bf 00 00 00 00       	mov    $0x0,%edi
  802975:	48 b8 a9 1d 80 00 00 	movabs $0x801da9,%rax
  80297c:	00 00 00 
  80297f:	ff d0                	callq  *%rax
	return r;
  802981:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802984:	c9                   	leaveq 
  802985:	c3                   	retq   

0000000000802986 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802986:	55                   	push   %rbp
  802987:	48 89 e5             	mov    %rsp,%rbp
  80298a:	48 83 ec 40          	sub    $0x40,%rsp
  80298e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802991:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802995:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802999:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80299d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029a0:	48 89 d6             	mov    %rdx,%rsi
  8029a3:	89 c7                	mov    %eax,%edi
  8029a5:	48 b8 54 25 80 00 00 	movabs $0x802554,%rax
  8029ac:	00 00 00 
  8029af:	ff d0                	callq  *%rax
  8029b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b8:	78 24                	js     8029de <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029be:	8b 00                	mov    (%rax),%eax
  8029c0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029c4:	48 89 d6             	mov    %rdx,%rsi
  8029c7:	89 c7                	mov    %eax,%edi
  8029c9:	48 b8 ad 26 80 00 00 	movabs $0x8026ad,%rax
  8029d0:	00 00 00 
  8029d3:	ff d0                	callq  *%rax
  8029d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029dc:	79 05                	jns    8029e3 <read+0x5d>
		return r;
  8029de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e1:	eb 76                	jmp    802a59 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8029e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e7:	8b 40 08             	mov    0x8(%rax),%eax
  8029ea:	83 e0 03             	and    $0x3,%eax
  8029ed:	83 f8 01             	cmp    $0x1,%eax
  8029f0:	75 3a                	jne    802a2c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8029f2:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8029f9:	00 00 00 
  8029fc:	48 8b 00             	mov    (%rax),%rax
  8029ff:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a05:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a08:	89 c6                	mov    %eax,%esi
  802a0a:	48 bf 27 45 80 00 00 	movabs $0x804527,%rdi
  802a11:	00 00 00 
  802a14:	b8 00 00 00 00       	mov    $0x0,%eax
  802a19:	48 b9 27 06 80 00 00 	movabs $0x800627,%rcx
  802a20:	00 00 00 
  802a23:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a25:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a2a:	eb 2d                	jmp    802a59 <read+0xd3>
	}
	if (!dev->dev_read)
  802a2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a30:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a34:	48 85 c0             	test   %rax,%rax
  802a37:	75 07                	jne    802a40 <read+0xba>
		return -E_NOT_SUPP;
  802a39:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a3e:	eb 19                	jmp    802a59 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a44:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a48:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a4c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a50:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a54:	48 89 cf             	mov    %rcx,%rdi
  802a57:	ff d0                	callq  *%rax
}
  802a59:	c9                   	leaveq 
  802a5a:	c3                   	retq   

0000000000802a5b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a5b:	55                   	push   %rbp
  802a5c:	48 89 e5             	mov    %rsp,%rbp
  802a5f:	48 83 ec 30          	sub    $0x30,%rsp
  802a63:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a6a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a75:	eb 49                	jmp    802ac0 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7a:	48 98                	cltq   
  802a7c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a80:	48 29 c2             	sub    %rax,%rdx
  802a83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a86:	48 63 c8             	movslq %eax,%rcx
  802a89:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a8d:	48 01 c1             	add    %rax,%rcx
  802a90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a93:	48 89 ce             	mov    %rcx,%rsi
  802a96:	89 c7                	mov    %eax,%edi
  802a98:	48 b8 86 29 80 00 00 	movabs $0x802986,%rax
  802a9f:	00 00 00 
  802aa2:	ff d0                	callq  *%rax
  802aa4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802aa7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802aab:	79 05                	jns    802ab2 <readn+0x57>
			return m;
  802aad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ab0:	eb 1c                	jmp    802ace <readn+0x73>
		if (m == 0)
  802ab2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ab6:	75 02                	jne    802aba <readn+0x5f>
			break;
  802ab8:	eb 11                	jmp    802acb <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802aba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802abd:	01 45 fc             	add    %eax,-0x4(%rbp)
  802ac0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac3:	48 98                	cltq   
  802ac5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ac9:	72 ac                	jb     802a77 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802acb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ace:	c9                   	leaveq 
  802acf:	c3                   	retq   

0000000000802ad0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802ad0:	55                   	push   %rbp
  802ad1:	48 89 e5             	mov    %rsp,%rbp
  802ad4:	48 83 ec 40          	sub    $0x40,%rsp
  802ad8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802adb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802adf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ae3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ae7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802aea:	48 89 d6             	mov    %rdx,%rsi
  802aed:	89 c7                	mov    %eax,%edi
  802aef:	48 b8 54 25 80 00 00 	movabs $0x802554,%rax
  802af6:	00 00 00 
  802af9:	ff d0                	callq  *%rax
  802afb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b02:	78 24                	js     802b28 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b08:	8b 00                	mov    (%rax),%eax
  802b0a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b0e:	48 89 d6             	mov    %rdx,%rsi
  802b11:	89 c7                	mov    %eax,%edi
  802b13:	48 b8 ad 26 80 00 00 	movabs $0x8026ad,%rax
  802b1a:	00 00 00 
  802b1d:	ff d0                	callq  *%rax
  802b1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b26:	79 05                	jns    802b2d <write+0x5d>
		return r;
  802b28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b2b:	eb 75                	jmp    802ba2 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b31:	8b 40 08             	mov    0x8(%rax),%eax
  802b34:	83 e0 03             	and    $0x3,%eax
  802b37:	85 c0                	test   %eax,%eax
  802b39:	75 3a                	jne    802b75 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b3b:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802b42:	00 00 00 
  802b45:	48 8b 00             	mov    (%rax),%rax
  802b48:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b4e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b51:	89 c6                	mov    %eax,%esi
  802b53:	48 bf 43 45 80 00 00 	movabs $0x804543,%rdi
  802b5a:	00 00 00 
  802b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b62:	48 b9 27 06 80 00 00 	movabs $0x800627,%rcx
  802b69:	00 00 00 
  802b6c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b73:	eb 2d                	jmp    802ba2 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b79:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b7d:	48 85 c0             	test   %rax,%rax
  802b80:	75 07                	jne    802b89 <write+0xb9>
		return -E_NOT_SUPP;
  802b82:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b87:	eb 19                	jmp    802ba2 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b8d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b91:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b95:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b99:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b9d:	48 89 cf             	mov    %rcx,%rdi
  802ba0:	ff d0                	callq  *%rax
}
  802ba2:	c9                   	leaveq 
  802ba3:	c3                   	retq   

0000000000802ba4 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ba4:	55                   	push   %rbp
  802ba5:	48 89 e5             	mov    %rsp,%rbp
  802ba8:	48 83 ec 18          	sub    $0x18,%rsp
  802bac:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802baf:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bb2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bb6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bb9:	48 89 d6             	mov    %rdx,%rsi
  802bbc:	89 c7                	mov    %eax,%edi
  802bbe:	48 b8 54 25 80 00 00 	movabs $0x802554,%rax
  802bc5:	00 00 00 
  802bc8:	ff d0                	callq  *%rax
  802bca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd1:	79 05                	jns    802bd8 <seek+0x34>
		return r;
  802bd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd6:	eb 0f                	jmp    802be7 <seek+0x43>
	fd->fd_offset = offset;
  802bd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bdc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802bdf:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802be2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802be7:	c9                   	leaveq 
  802be8:	c3                   	retq   

0000000000802be9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802be9:	55                   	push   %rbp
  802bea:	48 89 e5             	mov    %rsp,%rbp
  802bed:	48 83 ec 30          	sub    $0x30,%rsp
  802bf1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bf4:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bf7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bfb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bfe:	48 89 d6             	mov    %rdx,%rsi
  802c01:	89 c7                	mov    %eax,%edi
  802c03:	48 b8 54 25 80 00 00 	movabs $0x802554,%rax
  802c0a:	00 00 00 
  802c0d:	ff d0                	callq  *%rax
  802c0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c16:	78 24                	js     802c3c <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1c:	8b 00                	mov    (%rax),%eax
  802c1e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c22:	48 89 d6             	mov    %rdx,%rsi
  802c25:	89 c7                	mov    %eax,%edi
  802c27:	48 b8 ad 26 80 00 00 	movabs $0x8026ad,%rax
  802c2e:	00 00 00 
  802c31:	ff d0                	callq  *%rax
  802c33:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c3a:	79 05                	jns    802c41 <ftruncate+0x58>
		return r;
  802c3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3f:	eb 72                	jmp    802cb3 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c45:	8b 40 08             	mov    0x8(%rax),%eax
  802c48:	83 e0 03             	and    $0x3,%eax
  802c4b:	85 c0                	test   %eax,%eax
  802c4d:	75 3a                	jne    802c89 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c4f:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802c56:	00 00 00 
  802c59:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c5c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c62:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c65:	89 c6                	mov    %eax,%esi
  802c67:	48 bf 60 45 80 00 00 	movabs $0x804560,%rdi
  802c6e:	00 00 00 
  802c71:	b8 00 00 00 00       	mov    $0x0,%eax
  802c76:	48 b9 27 06 80 00 00 	movabs $0x800627,%rcx
  802c7d:	00 00 00 
  802c80:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c87:	eb 2a                	jmp    802cb3 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c8d:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c91:	48 85 c0             	test   %rax,%rax
  802c94:	75 07                	jne    802c9d <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c96:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c9b:	eb 16                	jmp    802cb3 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca1:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ca5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ca9:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802cac:	89 ce                	mov    %ecx,%esi
  802cae:	48 89 d7             	mov    %rdx,%rdi
  802cb1:	ff d0                	callq  *%rax
}
  802cb3:	c9                   	leaveq 
  802cb4:	c3                   	retq   

0000000000802cb5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802cb5:	55                   	push   %rbp
  802cb6:	48 89 e5             	mov    %rsp,%rbp
  802cb9:	48 83 ec 30          	sub    $0x30,%rsp
  802cbd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cc0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cc4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cc8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ccb:	48 89 d6             	mov    %rdx,%rsi
  802cce:	89 c7                	mov    %eax,%edi
  802cd0:	48 b8 54 25 80 00 00 	movabs $0x802554,%rax
  802cd7:	00 00 00 
  802cda:	ff d0                	callq  *%rax
  802cdc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cdf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce3:	78 24                	js     802d09 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ce5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce9:	8b 00                	mov    (%rax),%eax
  802ceb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cef:	48 89 d6             	mov    %rdx,%rsi
  802cf2:	89 c7                	mov    %eax,%edi
  802cf4:	48 b8 ad 26 80 00 00 	movabs $0x8026ad,%rax
  802cfb:	00 00 00 
  802cfe:	ff d0                	callq  *%rax
  802d00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d07:	79 05                	jns    802d0e <fstat+0x59>
		return r;
  802d09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d0c:	eb 5e                	jmp    802d6c <fstat+0xb7>
	if (!dev->dev_stat)
  802d0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d12:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d16:	48 85 c0             	test   %rax,%rax
  802d19:	75 07                	jne    802d22 <fstat+0x6d>
		return -E_NOT_SUPP;
  802d1b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d20:	eb 4a                	jmp    802d6c <fstat+0xb7>
	stat->st_name[0] = 0;
  802d22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d26:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d2d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d34:	00 00 00 
	stat->st_isdir = 0;
  802d37:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d3b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d42:	00 00 00 
	stat->st_dev = dev;
  802d45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d49:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d4d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d58:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d5c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d60:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d64:	48 89 ce             	mov    %rcx,%rsi
  802d67:	48 89 d7             	mov    %rdx,%rdi
  802d6a:	ff d0                	callq  *%rax
}
  802d6c:	c9                   	leaveq 
  802d6d:	c3                   	retq   

0000000000802d6e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d6e:	55                   	push   %rbp
  802d6f:	48 89 e5             	mov    %rsp,%rbp
  802d72:	48 83 ec 20          	sub    $0x20,%rsp
  802d76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d7a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d82:	be 00 00 00 00       	mov    $0x0,%esi
  802d87:	48 89 c7             	mov    %rax,%rdi
  802d8a:	48 b8 5c 2e 80 00 00 	movabs $0x802e5c,%rax
  802d91:	00 00 00 
  802d94:	ff d0                	callq  *%rax
  802d96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d9d:	79 05                	jns    802da4 <stat+0x36>
		return fd;
  802d9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da2:	eb 2f                	jmp    802dd3 <stat+0x65>
	r = fstat(fd, stat);
  802da4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802da8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dab:	48 89 d6             	mov    %rdx,%rsi
  802dae:	89 c7                	mov    %eax,%edi
  802db0:	48 b8 b5 2c 80 00 00 	movabs $0x802cb5,%rax
  802db7:	00 00 00 
  802dba:	ff d0                	callq  *%rax
  802dbc:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802dbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc2:	89 c7                	mov    %eax,%edi
  802dc4:	48 b8 64 27 80 00 00 	movabs $0x802764,%rax
  802dcb:	00 00 00 
  802dce:	ff d0                	callq  *%rax
	return r;
  802dd0:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802dd3:	c9                   	leaveq 
  802dd4:	c3                   	retq   

0000000000802dd5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802dd5:	55                   	push   %rbp
  802dd6:	48 89 e5             	mov    %rsp,%rbp
  802dd9:	48 83 ec 10          	sub    $0x10,%rsp
  802ddd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802de0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802de4:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802deb:	00 00 00 
  802dee:	8b 00                	mov    (%rax),%eax
  802df0:	85 c0                	test   %eax,%eax
  802df2:	75 1d                	jne    802e11 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802df4:	bf 01 00 00 00       	mov    $0x1,%edi
  802df9:	48 b8 5d 3d 80 00 00 	movabs $0x803d5d,%rax
  802e00:	00 00 00 
  802e03:	ff d0                	callq  *%rax
  802e05:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  802e0c:	00 00 00 
  802e0f:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e11:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802e18:	00 00 00 
  802e1b:	8b 00                	mov    (%rax),%eax
  802e1d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e20:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e25:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802e2c:	00 00 00 
  802e2f:	89 c7                	mov    %eax,%edi
  802e31:	48 b8 c5 3c 80 00 00 	movabs $0x803cc5,%rax
  802e38:	00 00 00 
  802e3b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e41:	ba 00 00 00 00       	mov    $0x0,%edx
  802e46:	48 89 c6             	mov    %rax,%rsi
  802e49:	bf 00 00 00 00       	mov    $0x0,%edi
  802e4e:	48 b8 fc 3b 80 00 00 	movabs $0x803bfc,%rax
  802e55:	00 00 00 
  802e58:	ff d0                	callq  *%rax
}
  802e5a:	c9                   	leaveq 
  802e5b:	c3                   	retq   

0000000000802e5c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e5c:	55                   	push   %rbp
  802e5d:	48 89 e5             	mov    %rsp,%rbp
  802e60:	48 83 ec 20          	sub    $0x20,%rsp
  802e64:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e68:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802e6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e6f:	48 89 c7             	mov    %rax,%rdi
  802e72:	48 b8 63 13 80 00 00 	movabs $0x801363,%rax
  802e79:	00 00 00 
  802e7c:	ff d0                	callq  *%rax
  802e7e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e83:	7e 0a                	jle    802e8f <open+0x33>
		return -E_BAD_PATH;
  802e85:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e8a:	e9 a5 00 00 00       	jmpq   802f34 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802e8f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e93:	48 89 c7             	mov    %rax,%rdi
  802e96:	48 b8 bc 24 80 00 00 	movabs $0x8024bc,%rax
  802e9d:	00 00 00 
  802ea0:	ff d0                	callq  *%rax
  802ea2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea9:	79 08                	jns    802eb3 <open+0x57>
		return r;
  802eab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eae:	e9 81 00 00 00       	jmpq   802f34 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802eb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb7:	48 89 c6             	mov    %rax,%rsi
  802eba:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802ec1:	00 00 00 
  802ec4:	48 b8 cf 13 80 00 00 	movabs $0x8013cf,%rax
  802ecb:	00 00 00 
  802ece:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802ed0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ed7:	00 00 00 
  802eda:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802edd:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802ee3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee7:	48 89 c6             	mov    %rax,%rsi
  802eea:	bf 01 00 00 00       	mov    $0x1,%edi
  802eef:	48 b8 d5 2d 80 00 00 	movabs $0x802dd5,%rax
  802ef6:	00 00 00 
  802ef9:	ff d0                	callq  *%rax
  802efb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802efe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f02:	79 1d                	jns    802f21 <open+0xc5>
		fd_close(fd, 0);
  802f04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f08:	be 00 00 00 00       	mov    $0x0,%esi
  802f0d:	48 89 c7             	mov    %rax,%rdi
  802f10:	48 b8 e4 25 80 00 00 	movabs $0x8025e4,%rax
  802f17:	00 00 00 
  802f1a:	ff d0                	callq  *%rax
		return r;
  802f1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1f:	eb 13                	jmp    802f34 <open+0xd8>
	}

	return fd2num(fd);
  802f21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f25:	48 89 c7             	mov    %rax,%rdi
  802f28:	48 b8 6e 24 80 00 00 	movabs $0x80246e,%rax
  802f2f:	00 00 00 
  802f32:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802f34:	c9                   	leaveq 
  802f35:	c3                   	retq   

0000000000802f36 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f36:	55                   	push   %rbp
  802f37:	48 89 e5             	mov    %rsp,%rbp
  802f3a:	48 83 ec 10          	sub    $0x10,%rsp
  802f3e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f46:	8b 50 0c             	mov    0xc(%rax),%edx
  802f49:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f50:	00 00 00 
  802f53:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f55:	be 00 00 00 00       	mov    $0x0,%esi
  802f5a:	bf 06 00 00 00       	mov    $0x6,%edi
  802f5f:	48 b8 d5 2d 80 00 00 	movabs $0x802dd5,%rax
  802f66:	00 00 00 
  802f69:	ff d0                	callq  *%rax
}
  802f6b:	c9                   	leaveq 
  802f6c:	c3                   	retq   

0000000000802f6d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802f6d:	55                   	push   %rbp
  802f6e:	48 89 e5             	mov    %rsp,%rbp
  802f71:	48 83 ec 30          	sub    $0x30,%rsp
  802f75:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f79:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f7d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802f81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f85:	8b 50 0c             	mov    0xc(%rax),%edx
  802f88:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f8f:	00 00 00 
  802f92:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802f94:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f9b:	00 00 00 
  802f9e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fa2:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802fa6:	be 00 00 00 00       	mov    $0x0,%esi
  802fab:	bf 03 00 00 00       	mov    $0x3,%edi
  802fb0:	48 b8 d5 2d 80 00 00 	movabs $0x802dd5,%rax
  802fb7:	00 00 00 
  802fba:	ff d0                	callq  *%rax
  802fbc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fbf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc3:	79 05                	jns    802fca <devfile_read+0x5d>
		return r;
  802fc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc8:	eb 26                	jmp    802ff0 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802fca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fcd:	48 63 d0             	movslq %eax,%rdx
  802fd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fd4:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802fdb:	00 00 00 
  802fde:	48 89 c7             	mov    %rax,%rdi
  802fe1:	48 b8 f3 16 80 00 00 	movabs $0x8016f3,%rax
  802fe8:	00 00 00 
  802feb:	ff d0                	callq  *%rax

	return r;
  802fed:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802ff0:	c9                   	leaveq 
  802ff1:	c3                   	retq   

0000000000802ff2 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802ff2:	55                   	push   %rbp
  802ff3:	48 89 e5             	mov    %rsp,%rbp
  802ff6:	48 83 ec 30          	sub    $0x30,%rsp
  802ffa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ffe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803002:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  803006:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80300d:	00 
  80300e:	76 08                	jbe    803018 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  803010:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803017:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80301c:	8b 50 0c             	mov    0xc(%rax),%edx
  80301f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803026:	00 00 00 
  803029:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80302b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803032:	00 00 00 
  803035:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803039:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  80303d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803041:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803045:	48 89 c6             	mov    %rax,%rsi
  803048:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80304f:	00 00 00 
  803052:	48 b8 f3 16 80 00 00 	movabs $0x8016f3,%rax
  803059:	00 00 00 
  80305c:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80305e:	be 00 00 00 00       	mov    $0x0,%esi
  803063:	bf 04 00 00 00       	mov    $0x4,%edi
  803068:	48 b8 d5 2d 80 00 00 	movabs $0x802dd5,%rax
  80306f:	00 00 00 
  803072:	ff d0                	callq  *%rax
  803074:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803077:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80307b:	79 05                	jns    803082 <devfile_write+0x90>
		return r;
  80307d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803080:	eb 03                	jmp    803085 <devfile_write+0x93>

	return r;
  803082:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803085:	c9                   	leaveq 
  803086:	c3                   	retq   

0000000000803087 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803087:	55                   	push   %rbp
  803088:	48 89 e5             	mov    %rsp,%rbp
  80308b:	48 83 ec 20          	sub    $0x20,%rsp
  80308f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803093:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803097:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80309b:	8b 50 0c             	mov    0xc(%rax),%edx
  80309e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030a5:	00 00 00 
  8030a8:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8030aa:	be 00 00 00 00       	mov    $0x0,%esi
  8030af:	bf 05 00 00 00       	mov    $0x5,%edi
  8030b4:	48 b8 d5 2d 80 00 00 	movabs $0x802dd5,%rax
  8030bb:	00 00 00 
  8030be:	ff d0                	callq  *%rax
  8030c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030c7:	79 05                	jns    8030ce <devfile_stat+0x47>
		return r;
  8030c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030cc:	eb 56                	jmp    803124 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8030ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030d2:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8030d9:	00 00 00 
  8030dc:	48 89 c7             	mov    %rax,%rdi
  8030df:	48 b8 cf 13 80 00 00 	movabs $0x8013cf,%rax
  8030e6:	00 00 00 
  8030e9:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8030eb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030f2:	00 00 00 
  8030f5:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8030fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ff:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803105:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80310c:	00 00 00 
  80310f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803115:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803119:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80311f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803124:	c9                   	leaveq 
  803125:	c3                   	retq   

0000000000803126 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803126:	55                   	push   %rbp
  803127:	48 89 e5             	mov    %rsp,%rbp
  80312a:	48 83 ec 10          	sub    $0x10,%rsp
  80312e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803132:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803135:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803139:	8b 50 0c             	mov    0xc(%rax),%edx
  80313c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803143:	00 00 00 
  803146:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803148:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80314f:	00 00 00 
  803152:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803155:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803158:	be 00 00 00 00       	mov    $0x0,%esi
  80315d:	bf 02 00 00 00       	mov    $0x2,%edi
  803162:	48 b8 d5 2d 80 00 00 	movabs $0x802dd5,%rax
  803169:	00 00 00 
  80316c:	ff d0                	callq  *%rax
}
  80316e:	c9                   	leaveq 
  80316f:	c3                   	retq   

0000000000803170 <remove>:

// Delete a file
int
remove(const char *path)
{
  803170:	55                   	push   %rbp
  803171:	48 89 e5             	mov    %rsp,%rbp
  803174:	48 83 ec 10          	sub    $0x10,%rsp
  803178:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80317c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803180:	48 89 c7             	mov    %rax,%rdi
  803183:	48 b8 63 13 80 00 00 	movabs $0x801363,%rax
  80318a:	00 00 00 
  80318d:	ff d0                	callq  *%rax
  80318f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803194:	7e 07                	jle    80319d <remove+0x2d>
		return -E_BAD_PATH;
  803196:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80319b:	eb 33                	jmp    8031d0 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80319d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031a1:	48 89 c6             	mov    %rax,%rsi
  8031a4:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8031ab:	00 00 00 
  8031ae:	48 b8 cf 13 80 00 00 	movabs $0x8013cf,%rax
  8031b5:	00 00 00 
  8031b8:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8031ba:	be 00 00 00 00       	mov    $0x0,%esi
  8031bf:	bf 07 00 00 00       	mov    $0x7,%edi
  8031c4:	48 b8 d5 2d 80 00 00 	movabs $0x802dd5,%rax
  8031cb:	00 00 00 
  8031ce:	ff d0                	callq  *%rax
}
  8031d0:	c9                   	leaveq 
  8031d1:	c3                   	retq   

00000000008031d2 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8031d2:	55                   	push   %rbp
  8031d3:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8031d6:	be 00 00 00 00       	mov    $0x0,%esi
  8031db:	bf 08 00 00 00       	mov    $0x8,%edi
  8031e0:	48 b8 d5 2d 80 00 00 	movabs $0x802dd5,%rax
  8031e7:	00 00 00 
  8031ea:	ff d0                	callq  *%rax
}
  8031ec:	5d                   	pop    %rbp
  8031ed:	c3                   	retq   

00000000008031ee <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8031ee:	55                   	push   %rbp
  8031ef:	48 89 e5             	mov    %rsp,%rbp
  8031f2:	53                   	push   %rbx
  8031f3:	48 83 ec 38          	sub    $0x38,%rsp
  8031f7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8031fb:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8031ff:	48 89 c7             	mov    %rax,%rdi
  803202:	48 b8 bc 24 80 00 00 	movabs $0x8024bc,%rax
  803209:	00 00 00 
  80320c:	ff d0                	callq  *%rax
  80320e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803211:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803215:	0f 88 bf 01 00 00    	js     8033da <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80321b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80321f:	ba 07 04 00 00       	mov    $0x407,%edx
  803224:	48 89 c6             	mov    %rax,%rsi
  803227:	bf 00 00 00 00       	mov    $0x0,%edi
  80322c:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  803233:	00 00 00 
  803236:	ff d0                	callq  *%rax
  803238:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80323b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80323f:	0f 88 95 01 00 00    	js     8033da <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803245:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803249:	48 89 c7             	mov    %rax,%rdi
  80324c:	48 b8 bc 24 80 00 00 	movabs $0x8024bc,%rax
  803253:	00 00 00 
  803256:	ff d0                	callq  *%rax
  803258:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80325b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80325f:	0f 88 5d 01 00 00    	js     8033c2 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803265:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803269:	ba 07 04 00 00       	mov    $0x407,%edx
  80326e:	48 89 c6             	mov    %rax,%rsi
  803271:	bf 00 00 00 00       	mov    $0x0,%edi
  803276:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  80327d:	00 00 00 
  803280:	ff d0                	callq  *%rax
  803282:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803285:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803289:	0f 88 33 01 00 00    	js     8033c2 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80328f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803293:	48 89 c7             	mov    %rax,%rdi
  803296:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  80329d:	00 00 00 
  8032a0:	ff d0                	callq  *%rax
  8032a2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032aa:	ba 07 04 00 00       	mov    $0x407,%edx
  8032af:	48 89 c6             	mov    %rax,%rsi
  8032b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8032b7:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  8032be:	00 00 00 
  8032c1:	ff d0                	callq  *%rax
  8032c3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032ca:	79 05                	jns    8032d1 <pipe+0xe3>
		goto err2;
  8032cc:	e9 d9 00 00 00       	jmpq   8033aa <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032d5:	48 89 c7             	mov    %rax,%rdi
  8032d8:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  8032df:	00 00 00 
  8032e2:	ff d0                	callq  *%rax
  8032e4:	48 89 c2             	mov    %rax,%rdx
  8032e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032eb:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8032f1:	48 89 d1             	mov    %rdx,%rcx
  8032f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8032f9:	48 89 c6             	mov    %rax,%rsi
  8032fc:	bf 00 00 00 00       	mov    $0x0,%edi
  803301:	48 b8 4e 1d 80 00 00 	movabs $0x801d4e,%rax
  803308:	00 00 00 
  80330b:	ff d0                	callq  *%rax
  80330d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803310:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803314:	79 1b                	jns    803331 <pipe+0x143>
		goto err3;
  803316:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803317:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80331b:	48 89 c6             	mov    %rax,%rsi
  80331e:	bf 00 00 00 00       	mov    $0x0,%edi
  803323:	48 b8 a9 1d 80 00 00 	movabs $0x801da9,%rax
  80332a:	00 00 00 
  80332d:	ff d0                	callq  *%rax
  80332f:	eb 79                	jmp    8033aa <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803331:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803335:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80333c:	00 00 00 
  80333f:	8b 12                	mov    (%rdx),%edx
  803341:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803343:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803347:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80334e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803352:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803359:	00 00 00 
  80335c:	8b 12                	mov    (%rdx),%edx
  80335e:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803360:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803364:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80336b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80336f:	48 89 c7             	mov    %rax,%rdi
  803372:	48 b8 6e 24 80 00 00 	movabs $0x80246e,%rax
  803379:	00 00 00 
  80337c:	ff d0                	callq  *%rax
  80337e:	89 c2                	mov    %eax,%edx
  803380:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803384:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803386:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80338a:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80338e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803392:	48 89 c7             	mov    %rax,%rdi
  803395:	48 b8 6e 24 80 00 00 	movabs $0x80246e,%rax
  80339c:	00 00 00 
  80339f:	ff d0                	callq  *%rax
  8033a1:	89 03                	mov    %eax,(%rbx)
	return 0;
  8033a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a8:	eb 33                	jmp    8033dd <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8033aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ae:	48 89 c6             	mov    %rax,%rsi
  8033b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8033b6:	48 b8 a9 1d 80 00 00 	movabs $0x801da9,%rax
  8033bd:	00 00 00 
  8033c0:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8033c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033c6:	48 89 c6             	mov    %rax,%rsi
  8033c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8033ce:	48 b8 a9 1d 80 00 00 	movabs $0x801da9,%rax
  8033d5:	00 00 00 
  8033d8:	ff d0                	callq  *%rax
    err:
	return r;
  8033da:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8033dd:	48 83 c4 38          	add    $0x38,%rsp
  8033e1:	5b                   	pop    %rbx
  8033e2:	5d                   	pop    %rbp
  8033e3:	c3                   	retq   

00000000008033e4 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8033e4:	55                   	push   %rbp
  8033e5:	48 89 e5             	mov    %rsp,%rbp
  8033e8:	53                   	push   %rbx
  8033e9:	48 83 ec 28          	sub    $0x28,%rsp
  8033ed:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033f1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8033f5:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8033fc:	00 00 00 
  8033ff:	48 8b 00             	mov    (%rax),%rax
  803402:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803408:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80340b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80340f:	48 89 c7             	mov    %rax,%rdi
  803412:	48 b8 df 3d 80 00 00 	movabs $0x803ddf,%rax
  803419:	00 00 00 
  80341c:	ff d0                	callq  *%rax
  80341e:	89 c3                	mov    %eax,%ebx
  803420:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803424:	48 89 c7             	mov    %rax,%rdi
  803427:	48 b8 df 3d 80 00 00 	movabs $0x803ddf,%rax
  80342e:	00 00 00 
  803431:	ff d0                	callq  *%rax
  803433:	39 c3                	cmp    %eax,%ebx
  803435:	0f 94 c0             	sete   %al
  803438:	0f b6 c0             	movzbl %al,%eax
  80343b:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80343e:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803445:	00 00 00 
  803448:	48 8b 00             	mov    (%rax),%rax
  80344b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803451:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803454:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803457:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80345a:	75 05                	jne    803461 <_pipeisclosed+0x7d>
			return ret;
  80345c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80345f:	eb 4f                	jmp    8034b0 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803461:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803464:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803467:	74 42                	je     8034ab <_pipeisclosed+0xc7>
  803469:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80346d:	75 3c                	jne    8034ab <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80346f:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803476:	00 00 00 
  803479:	48 8b 00             	mov    (%rax),%rax
  80347c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803482:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803485:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803488:	89 c6                	mov    %eax,%esi
  80348a:	48 bf 8b 45 80 00 00 	movabs $0x80458b,%rdi
  803491:	00 00 00 
  803494:	b8 00 00 00 00       	mov    $0x0,%eax
  803499:	49 b8 27 06 80 00 00 	movabs $0x800627,%r8
  8034a0:	00 00 00 
  8034a3:	41 ff d0             	callq  *%r8
	}
  8034a6:	e9 4a ff ff ff       	jmpq   8033f5 <_pipeisclosed+0x11>
  8034ab:	e9 45 ff ff ff       	jmpq   8033f5 <_pipeisclosed+0x11>
}
  8034b0:	48 83 c4 28          	add    $0x28,%rsp
  8034b4:	5b                   	pop    %rbx
  8034b5:	5d                   	pop    %rbp
  8034b6:	c3                   	retq   

00000000008034b7 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8034b7:	55                   	push   %rbp
  8034b8:	48 89 e5             	mov    %rsp,%rbp
  8034bb:	48 83 ec 30          	sub    $0x30,%rsp
  8034bf:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8034c2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8034c6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8034c9:	48 89 d6             	mov    %rdx,%rsi
  8034cc:	89 c7                	mov    %eax,%edi
  8034ce:	48 b8 54 25 80 00 00 	movabs $0x802554,%rax
  8034d5:	00 00 00 
  8034d8:	ff d0                	callq  *%rax
  8034da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e1:	79 05                	jns    8034e8 <pipeisclosed+0x31>
		return r;
  8034e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e6:	eb 31                	jmp    803519 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8034e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ec:	48 89 c7             	mov    %rax,%rdi
  8034ef:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  8034f6:	00 00 00 
  8034f9:	ff d0                	callq  *%rax
  8034fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8034ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803503:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803507:	48 89 d6             	mov    %rdx,%rsi
  80350a:	48 89 c7             	mov    %rax,%rdi
  80350d:	48 b8 e4 33 80 00 00 	movabs $0x8033e4,%rax
  803514:	00 00 00 
  803517:	ff d0                	callq  *%rax
}
  803519:	c9                   	leaveq 
  80351a:	c3                   	retq   

000000000080351b <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80351b:	55                   	push   %rbp
  80351c:	48 89 e5             	mov    %rsp,%rbp
  80351f:	48 83 ec 40          	sub    $0x40,%rsp
  803523:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803527:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80352b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80352f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803533:	48 89 c7             	mov    %rax,%rdi
  803536:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  80353d:	00 00 00 
  803540:	ff d0                	callq  *%rax
  803542:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803546:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80354a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80354e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803555:	00 
  803556:	e9 92 00 00 00       	jmpq   8035ed <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80355b:	eb 41                	jmp    80359e <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80355d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803562:	74 09                	je     80356d <devpipe_read+0x52>
				return i;
  803564:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803568:	e9 92 00 00 00       	jmpq   8035ff <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80356d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803571:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803575:	48 89 d6             	mov    %rdx,%rsi
  803578:	48 89 c7             	mov    %rax,%rdi
  80357b:	48 b8 e4 33 80 00 00 	movabs $0x8033e4,%rax
  803582:	00 00 00 
  803585:	ff d0                	callq  *%rax
  803587:	85 c0                	test   %eax,%eax
  803589:	74 07                	je     803592 <devpipe_read+0x77>
				return 0;
  80358b:	b8 00 00 00 00       	mov    $0x0,%eax
  803590:	eb 6d                	jmp    8035ff <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803592:	48 b8 c0 1c 80 00 00 	movabs $0x801cc0,%rax
  803599:	00 00 00 
  80359c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80359e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035a2:	8b 10                	mov    (%rax),%edx
  8035a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035a8:	8b 40 04             	mov    0x4(%rax),%eax
  8035ab:	39 c2                	cmp    %eax,%edx
  8035ad:	74 ae                	je     80355d <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8035af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035b7:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8035bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035bf:	8b 00                	mov    (%rax),%eax
  8035c1:	99                   	cltd   
  8035c2:	c1 ea 1b             	shr    $0x1b,%edx
  8035c5:	01 d0                	add    %edx,%eax
  8035c7:	83 e0 1f             	and    $0x1f,%eax
  8035ca:	29 d0                	sub    %edx,%eax
  8035cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035d0:	48 98                	cltq   
  8035d2:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8035d7:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8035d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035dd:	8b 00                	mov    (%rax),%eax
  8035df:	8d 50 01             	lea    0x1(%rax),%edx
  8035e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e6:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8035e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035f1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8035f5:	0f 82 60 ff ff ff    	jb     80355b <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8035fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8035ff:	c9                   	leaveq 
  803600:	c3                   	retq   

0000000000803601 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803601:	55                   	push   %rbp
  803602:	48 89 e5             	mov    %rsp,%rbp
  803605:	48 83 ec 40          	sub    $0x40,%rsp
  803609:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80360d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803611:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803615:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803619:	48 89 c7             	mov    %rax,%rdi
  80361c:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  803623:	00 00 00 
  803626:	ff d0                	callq  *%rax
  803628:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80362c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803630:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803634:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80363b:	00 
  80363c:	e9 8e 00 00 00       	jmpq   8036cf <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803641:	eb 31                	jmp    803674 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803643:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803647:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80364b:	48 89 d6             	mov    %rdx,%rsi
  80364e:	48 89 c7             	mov    %rax,%rdi
  803651:	48 b8 e4 33 80 00 00 	movabs $0x8033e4,%rax
  803658:	00 00 00 
  80365b:	ff d0                	callq  *%rax
  80365d:	85 c0                	test   %eax,%eax
  80365f:	74 07                	je     803668 <devpipe_write+0x67>
				return 0;
  803661:	b8 00 00 00 00       	mov    $0x0,%eax
  803666:	eb 79                	jmp    8036e1 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803668:	48 b8 c0 1c 80 00 00 	movabs $0x801cc0,%rax
  80366f:	00 00 00 
  803672:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803674:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803678:	8b 40 04             	mov    0x4(%rax),%eax
  80367b:	48 63 d0             	movslq %eax,%rdx
  80367e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803682:	8b 00                	mov    (%rax),%eax
  803684:	48 98                	cltq   
  803686:	48 83 c0 20          	add    $0x20,%rax
  80368a:	48 39 c2             	cmp    %rax,%rdx
  80368d:	73 b4                	jae    803643 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80368f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803693:	8b 40 04             	mov    0x4(%rax),%eax
  803696:	99                   	cltd   
  803697:	c1 ea 1b             	shr    $0x1b,%edx
  80369a:	01 d0                	add    %edx,%eax
  80369c:	83 e0 1f             	and    $0x1f,%eax
  80369f:	29 d0                	sub    %edx,%eax
  8036a1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8036a5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8036a9:	48 01 ca             	add    %rcx,%rdx
  8036ac:	0f b6 0a             	movzbl (%rdx),%ecx
  8036af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036b3:	48 98                	cltq   
  8036b5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8036b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036bd:	8b 40 04             	mov    0x4(%rax),%eax
  8036c0:	8d 50 01             	lea    0x1(%rax),%edx
  8036c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c7:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8036ca:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036d3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036d7:	0f 82 64 ff ff ff    	jb     803641 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8036dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8036e1:	c9                   	leaveq 
  8036e2:	c3                   	retq   

00000000008036e3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8036e3:	55                   	push   %rbp
  8036e4:	48 89 e5             	mov    %rsp,%rbp
  8036e7:	48 83 ec 20          	sub    $0x20,%rsp
  8036eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8036f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f7:	48 89 c7             	mov    %rax,%rdi
  8036fa:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  803701:	00 00 00 
  803704:	ff d0                	callq  *%rax
  803706:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80370a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80370e:	48 be 9e 45 80 00 00 	movabs $0x80459e,%rsi
  803715:	00 00 00 
  803718:	48 89 c7             	mov    %rax,%rdi
  80371b:	48 b8 cf 13 80 00 00 	movabs $0x8013cf,%rax
  803722:	00 00 00 
  803725:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803727:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80372b:	8b 50 04             	mov    0x4(%rax),%edx
  80372e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803732:	8b 00                	mov    (%rax),%eax
  803734:	29 c2                	sub    %eax,%edx
  803736:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80373a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803740:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803744:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80374b:	00 00 00 
	stat->st_dev = &devpipe;
  80374e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803752:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803759:	00 00 00 
  80375c:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803763:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803768:	c9                   	leaveq 
  803769:	c3                   	retq   

000000000080376a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80376a:	55                   	push   %rbp
  80376b:	48 89 e5             	mov    %rsp,%rbp
  80376e:	48 83 ec 10          	sub    $0x10,%rsp
  803772:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803776:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80377a:	48 89 c6             	mov    %rax,%rsi
  80377d:	bf 00 00 00 00       	mov    $0x0,%edi
  803782:	48 b8 a9 1d 80 00 00 	movabs $0x801da9,%rax
  803789:	00 00 00 
  80378c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80378e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803792:	48 89 c7             	mov    %rax,%rdi
  803795:	48 b8 91 24 80 00 00 	movabs $0x802491,%rax
  80379c:	00 00 00 
  80379f:	ff d0                	callq  *%rax
  8037a1:	48 89 c6             	mov    %rax,%rsi
  8037a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8037a9:	48 b8 a9 1d 80 00 00 	movabs $0x801da9,%rax
  8037b0:	00 00 00 
  8037b3:	ff d0                	callq  *%rax
}
  8037b5:	c9                   	leaveq 
  8037b6:	c3                   	retq   

00000000008037b7 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8037b7:	55                   	push   %rbp
  8037b8:	48 89 e5             	mov    %rsp,%rbp
  8037bb:	48 83 ec 20          	sub    $0x20,%rsp
  8037bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8037c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037c6:	75 35                	jne    8037fd <wait+0x46>
  8037c8:	48 b9 a5 45 80 00 00 	movabs $0x8045a5,%rcx
  8037cf:	00 00 00 
  8037d2:	48 ba b0 45 80 00 00 	movabs $0x8045b0,%rdx
  8037d9:	00 00 00 
  8037dc:	be 09 00 00 00       	mov    $0x9,%esi
  8037e1:	48 bf c5 45 80 00 00 	movabs $0x8045c5,%rdi
  8037e8:	00 00 00 
  8037eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8037f0:	49 b8 ee 03 80 00 00 	movabs $0x8003ee,%r8
  8037f7:	00 00 00 
  8037fa:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8037fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803800:	25 ff 03 00 00       	and    $0x3ff,%eax
  803805:	48 63 d0             	movslq %eax,%rdx
  803808:	48 89 d0             	mov    %rdx,%rax
  80380b:	48 c1 e0 03          	shl    $0x3,%rax
  80380f:	48 01 d0             	add    %rdx,%rax
  803812:	48 c1 e0 05          	shl    $0x5,%rax
  803816:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80381d:	00 00 00 
  803820:	48 01 d0             	add    %rdx,%rax
  803823:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803827:	eb 0c                	jmp    803835 <wait+0x7e>
		sys_yield();
  803829:	48 b8 c0 1c 80 00 00 	movabs $0x801cc0,%rax
  803830:	00 00 00 
  803833:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803835:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803839:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80383f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803842:	75 0e                	jne    803852 <wait+0x9b>
  803844:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803848:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80384e:	85 c0                	test   %eax,%eax
  803850:	75 d7                	jne    803829 <wait+0x72>
		sys_yield();
}
  803852:	c9                   	leaveq 
  803853:	c3                   	retq   

0000000000803854 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803854:	55                   	push   %rbp
  803855:	48 89 e5             	mov    %rsp,%rbp
  803858:	48 83 ec 20          	sub    $0x20,%rsp
  80385c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80385f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803862:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803865:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803869:	be 01 00 00 00       	mov    $0x1,%esi
  80386e:	48 89 c7             	mov    %rax,%rdi
  803871:	48 b8 b6 1b 80 00 00 	movabs $0x801bb6,%rax
  803878:	00 00 00 
  80387b:	ff d0                	callq  *%rax
}
  80387d:	c9                   	leaveq 
  80387e:	c3                   	retq   

000000000080387f <getchar>:

int
getchar(void)
{
  80387f:	55                   	push   %rbp
  803880:	48 89 e5             	mov    %rsp,%rbp
  803883:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803887:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80388b:	ba 01 00 00 00       	mov    $0x1,%edx
  803890:	48 89 c6             	mov    %rax,%rsi
  803893:	bf 00 00 00 00       	mov    $0x0,%edi
  803898:	48 b8 86 29 80 00 00 	movabs $0x802986,%rax
  80389f:	00 00 00 
  8038a2:	ff d0                	callq  *%rax
  8038a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8038a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038ab:	79 05                	jns    8038b2 <getchar+0x33>
		return r;
  8038ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b0:	eb 14                	jmp    8038c6 <getchar+0x47>
	if (r < 1)
  8038b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b6:	7f 07                	jg     8038bf <getchar+0x40>
		return -E_EOF;
  8038b8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8038bd:	eb 07                	jmp    8038c6 <getchar+0x47>
	return c;
  8038bf:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8038c3:	0f b6 c0             	movzbl %al,%eax
}
  8038c6:	c9                   	leaveq 
  8038c7:	c3                   	retq   

00000000008038c8 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8038c8:	55                   	push   %rbp
  8038c9:	48 89 e5             	mov    %rsp,%rbp
  8038cc:	48 83 ec 20          	sub    $0x20,%rsp
  8038d0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038d3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8038d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038da:	48 89 d6             	mov    %rdx,%rsi
  8038dd:	89 c7                	mov    %eax,%edi
  8038df:	48 b8 54 25 80 00 00 	movabs $0x802554,%rax
  8038e6:	00 00 00 
  8038e9:	ff d0                	callq  *%rax
  8038eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038f2:	79 05                	jns    8038f9 <iscons+0x31>
		return r;
  8038f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f7:	eb 1a                	jmp    803913 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8038f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038fd:	8b 10                	mov    (%rax),%edx
  8038ff:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803906:	00 00 00 
  803909:	8b 00                	mov    (%rax),%eax
  80390b:	39 c2                	cmp    %eax,%edx
  80390d:	0f 94 c0             	sete   %al
  803910:	0f b6 c0             	movzbl %al,%eax
}
  803913:	c9                   	leaveq 
  803914:	c3                   	retq   

0000000000803915 <opencons>:

int
opencons(void)
{
  803915:	55                   	push   %rbp
  803916:	48 89 e5             	mov    %rsp,%rbp
  803919:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80391d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803921:	48 89 c7             	mov    %rax,%rdi
  803924:	48 b8 bc 24 80 00 00 	movabs $0x8024bc,%rax
  80392b:	00 00 00 
  80392e:	ff d0                	callq  *%rax
  803930:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803933:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803937:	79 05                	jns    80393e <opencons+0x29>
		return r;
  803939:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80393c:	eb 5b                	jmp    803999 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80393e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803942:	ba 07 04 00 00       	mov    $0x407,%edx
  803947:	48 89 c6             	mov    %rax,%rsi
  80394a:	bf 00 00 00 00       	mov    $0x0,%edi
  80394f:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  803956:	00 00 00 
  803959:	ff d0                	callq  *%rax
  80395b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80395e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803962:	79 05                	jns    803969 <opencons+0x54>
		return r;
  803964:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803967:	eb 30                	jmp    803999 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803969:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80396d:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803974:	00 00 00 
  803977:	8b 12                	mov    (%rdx),%edx
  803979:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80397b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803986:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398a:	48 89 c7             	mov    %rax,%rdi
  80398d:	48 b8 6e 24 80 00 00 	movabs $0x80246e,%rax
  803994:	00 00 00 
  803997:	ff d0                	callq  *%rax
}
  803999:	c9                   	leaveq 
  80399a:	c3                   	retq   

000000000080399b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80399b:	55                   	push   %rbp
  80399c:	48 89 e5             	mov    %rsp,%rbp
  80399f:	48 83 ec 30          	sub    $0x30,%rsp
  8039a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8039af:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039b4:	75 07                	jne    8039bd <devcons_read+0x22>
		return 0;
  8039b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8039bb:	eb 4b                	jmp    803a08 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8039bd:	eb 0c                	jmp    8039cb <devcons_read+0x30>
		sys_yield();
  8039bf:	48 b8 c0 1c 80 00 00 	movabs $0x801cc0,%rax
  8039c6:	00 00 00 
  8039c9:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8039cb:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  8039d2:	00 00 00 
  8039d5:	ff d0                	callq  *%rax
  8039d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039de:	74 df                	je     8039bf <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8039e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039e4:	79 05                	jns    8039eb <devcons_read+0x50>
		return c;
  8039e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e9:	eb 1d                	jmp    803a08 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8039eb:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8039ef:	75 07                	jne    8039f8 <devcons_read+0x5d>
		return 0;
  8039f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f6:	eb 10                	jmp    803a08 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8039f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039fb:	89 c2                	mov    %eax,%edx
  8039fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a01:	88 10                	mov    %dl,(%rax)
	return 1;
  803a03:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a08:	c9                   	leaveq 
  803a09:	c3                   	retq   

0000000000803a0a <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a0a:	55                   	push   %rbp
  803a0b:	48 89 e5             	mov    %rsp,%rbp
  803a0e:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803a15:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803a1c:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803a23:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a31:	eb 76                	jmp    803aa9 <devcons_write+0x9f>
		m = n - tot;
  803a33:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a3a:	89 c2                	mov    %eax,%edx
  803a3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a3f:	29 c2                	sub    %eax,%edx
  803a41:	89 d0                	mov    %edx,%eax
  803a43:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a49:	83 f8 7f             	cmp    $0x7f,%eax
  803a4c:	76 07                	jbe    803a55 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803a4e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a58:	48 63 d0             	movslq %eax,%rdx
  803a5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5e:	48 63 c8             	movslq %eax,%rcx
  803a61:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803a68:	48 01 c1             	add    %rax,%rcx
  803a6b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a72:	48 89 ce             	mov    %rcx,%rsi
  803a75:	48 89 c7             	mov    %rax,%rdi
  803a78:	48 b8 f3 16 80 00 00 	movabs $0x8016f3,%rax
  803a7f:	00 00 00 
  803a82:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803a84:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a87:	48 63 d0             	movslq %eax,%rdx
  803a8a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a91:	48 89 d6             	mov    %rdx,%rsi
  803a94:	48 89 c7             	mov    %rax,%rdi
  803a97:	48 b8 b6 1b 80 00 00 	movabs $0x801bb6,%rax
  803a9e:	00 00 00 
  803aa1:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803aa3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aa6:	01 45 fc             	add    %eax,-0x4(%rbp)
  803aa9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aac:	48 98                	cltq   
  803aae:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803ab5:	0f 82 78 ff ff ff    	jb     803a33 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803abb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803abe:	c9                   	leaveq 
  803abf:	c3                   	retq   

0000000000803ac0 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803ac0:	55                   	push   %rbp
  803ac1:	48 89 e5             	mov    %rsp,%rbp
  803ac4:	48 83 ec 08          	sub    $0x8,%rsp
  803ac8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803acc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ad1:	c9                   	leaveq 
  803ad2:	c3                   	retq   

0000000000803ad3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803ad3:	55                   	push   %rbp
  803ad4:	48 89 e5             	mov    %rsp,%rbp
  803ad7:	48 83 ec 10          	sub    $0x10,%rsp
  803adb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803adf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ae3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ae7:	48 be d5 45 80 00 00 	movabs $0x8045d5,%rsi
  803aee:	00 00 00 
  803af1:	48 89 c7             	mov    %rax,%rdi
  803af4:	48 b8 cf 13 80 00 00 	movabs $0x8013cf,%rax
  803afb:	00 00 00 
  803afe:	ff d0                	callq  *%rax
	return 0;
  803b00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b05:	c9                   	leaveq 
  803b06:	c3                   	retq   

0000000000803b07 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803b07:	55                   	push   %rbp
  803b08:	48 89 e5             	mov    %rsp,%rbp
  803b0b:	48 83 ec 10          	sub    $0x10,%rsp
  803b0f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803b13:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803b1a:	00 00 00 
  803b1d:	48 8b 00             	mov    (%rax),%rax
  803b20:	48 85 c0             	test   %rax,%rax
  803b23:	75 3a                	jne    803b5f <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  803b25:	ba 07 00 00 00       	mov    $0x7,%edx
  803b2a:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803b2f:	bf 00 00 00 00       	mov    $0x0,%edi
  803b34:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  803b3b:	00 00 00 
  803b3e:	ff d0                	callq  *%rax
  803b40:	85 c0                	test   %eax,%eax
  803b42:	75 1b                	jne    803b5f <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803b44:	48 be 72 3b 80 00 00 	movabs $0x803b72,%rsi
  803b4b:	00 00 00 
  803b4e:	bf 00 00 00 00       	mov    $0x0,%edi
  803b53:	48 b8 88 1e 80 00 00 	movabs $0x801e88,%rax
  803b5a:	00 00 00 
  803b5d:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803b5f:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803b66:	00 00 00 
  803b69:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b6d:	48 89 10             	mov    %rdx,(%rax)
}
  803b70:	c9                   	leaveq 
  803b71:	c3                   	retq   

0000000000803b72 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803b72:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803b75:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803b7c:	00 00 00 
	call *%rax
  803b7f:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  803b81:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  803b84:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803b8b:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  803b8c:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  803b93:	00 
	pushq %rbx		// push utf_rip into new stack
  803b94:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  803b95:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  803b9c:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  803b9f:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  803ba3:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  803ba7:	4c 8b 3c 24          	mov    (%rsp),%r15
  803bab:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803bb0:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803bb5:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803bba:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803bbf:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803bc4:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803bc9:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803bce:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803bd3:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803bd8:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803bdd:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803be2:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803be7:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803bec:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803bf1:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  803bf5:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  803bf9:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  803bfa:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803bfb:	c3                   	retq   

0000000000803bfc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803bfc:	55                   	push   %rbp
  803bfd:	48 89 e5             	mov    %rsp,%rbp
  803c00:	48 83 ec 30          	sub    $0x30,%rsp
  803c04:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c08:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c0c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803c10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c14:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803c18:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803c1d:	75 0e                	jne    803c2d <ipc_recv+0x31>
		page = (void *)KERNBASE;
  803c1f:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803c26:	00 00 00 
  803c29:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  803c2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c31:	48 89 c7             	mov    %rax,%rdi
  803c34:	48 b8 27 1f 80 00 00 	movabs $0x801f27,%rax
  803c3b:	00 00 00 
  803c3e:	ff d0                	callq  *%rax
  803c40:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803c43:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803c47:	79 27                	jns    803c70 <ipc_recv+0x74>
		if (from_env_store != NULL)
  803c49:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803c4e:	74 0a                	je     803c5a <ipc_recv+0x5e>
			*from_env_store = 0;
  803c50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c54:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  803c5a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c5f:	74 0a                	je     803c6b <ipc_recv+0x6f>
			*perm_store = 0;
  803c61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c65:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803c6b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803c6e:	eb 53                	jmp    803cc3 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  803c70:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803c75:	74 19                	je     803c90 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  803c77:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803c7e:	00 00 00 
  803c81:	48 8b 00             	mov    (%rax),%rax
  803c84:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803c8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c8e:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  803c90:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c95:	74 19                	je     803cb0 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803c97:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803c9e:	00 00 00 
  803ca1:	48 8b 00             	mov    (%rax),%rax
  803ca4:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803caa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cae:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  803cb0:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803cb7:	00 00 00 
  803cba:	48 8b 00             	mov    (%rax),%rax
  803cbd:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803cc3:	c9                   	leaveq 
  803cc4:	c3                   	retq   

0000000000803cc5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803cc5:	55                   	push   %rbp
  803cc6:	48 89 e5             	mov    %rsp,%rbp
  803cc9:	48 83 ec 30          	sub    $0x30,%rsp
  803ccd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cd0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803cd3:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803cd7:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803cda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cde:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803ce2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803ce7:	75 10                	jne    803cf9 <ipc_send+0x34>
		page = (void *)KERNBASE;
  803ce9:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803cf0:	00 00 00 
  803cf3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803cf7:	eb 0e                	jmp    803d07 <ipc_send+0x42>
  803cf9:	eb 0c                	jmp    803d07 <ipc_send+0x42>
		sys_yield();
  803cfb:	48 b8 c0 1c 80 00 00 	movabs $0x801cc0,%rax
  803d02:	00 00 00 
  803d05:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803d07:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803d0a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803d0d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d11:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d14:	89 c7                	mov    %eax,%edi
  803d16:	48 b8 d2 1e 80 00 00 	movabs $0x801ed2,%rax
  803d1d:	00 00 00 
  803d20:	ff d0                	callq  *%rax
  803d22:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803d25:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  803d29:	74 d0                	je     803cfb <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  803d2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803d2f:	74 2a                	je     803d5b <ipc_send+0x96>
		panic("error on ipc send procedure");
  803d31:	48 ba dc 45 80 00 00 	movabs $0x8045dc,%rdx
  803d38:	00 00 00 
  803d3b:	be 49 00 00 00       	mov    $0x49,%esi
  803d40:	48 bf f8 45 80 00 00 	movabs $0x8045f8,%rdi
  803d47:	00 00 00 
  803d4a:	b8 00 00 00 00       	mov    $0x0,%eax
  803d4f:	48 b9 ee 03 80 00 00 	movabs $0x8003ee,%rcx
  803d56:	00 00 00 
  803d59:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  803d5b:	c9                   	leaveq 
  803d5c:	c3                   	retq   

0000000000803d5d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d5d:	55                   	push   %rbp
  803d5e:	48 89 e5             	mov    %rsp,%rbp
  803d61:	48 83 ec 14          	sub    $0x14,%rsp
  803d65:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803d68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d6f:	eb 5e                	jmp    803dcf <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803d71:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d78:	00 00 00 
  803d7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d7e:	48 63 d0             	movslq %eax,%rdx
  803d81:	48 89 d0             	mov    %rdx,%rax
  803d84:	48 c1 e0 03          	shl    $0x3,%rax
  803d88:	48 01 d0             	add    %rdx,%rax
  803d8b:	48 c1 e0 05          	shl    $0x5,%rax
  803d8f:	48 01 c8             	add    %rcx,%rax
  803d92:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803d98:	8b 00                	mov    (%rax),%eax
  803d9a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803d9d:	75 2c                	jne    803dcb <ipc_find_env+0x6e>
			return envs[i].env_id;
  803d9f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803da6:	00 00 00 
  803da9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dac:	48 63 d0             	movslq %eax,%rdx
  803daf:	48 89 d0             	mov    %rdx,%rax
  803db2:	48 c1 e0 03          	shl    $0x3,%rax
  803db6:	48 01 d0             	add    %rdx,%rax
  803db9:	48 c1 e0 05          	shl    $0x5,%rax
  803dbd:	48 01 c8             	add    %rcx,%rax
  803dc0:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803dc6:	8b 40 08             	mov    0x8(%rax),%eax
  803dc9:	eb 12                	jmp    803ddd <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803dcb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803dcf:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803dd6:	7e 99                	jle    803d71 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803dd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ddd:	c9                   	leaveq 
  803dde:	c3                   	retq   

0000000000803ddf <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803ddf:	55                   	push   %rbp
  803de0:	48 89 e5             	mov    %rsp,%rbp
  803de3:	48 83 ec 18          	sub    $0x18,%rsp
  803de7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803deb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803def:	48 c1 e8 15          	shr    $0x15,%rax
  803df3:	48 89 c2             	mov    %rax,%rdx
  803df6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803dfd:	01 00 00 
  803e00:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e04:	83 e0 01             	and    $0x1,%eax
  803e07:	48 85 c0             	test   %rax,%rax
  803e0a:	75 07                	jne    803e13 <pageref+0x34>
		return 0;
  803e0c:	b8 00 00 00 00       	mov    $0x0,%eax
  803e11:	eb 53                	jmp    803e66 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e17:	48 c1 e8 0c          	shr    $0xc,%rax
  803e1b:	48 89 c2             	mov    %rax,%rdx
  803e1e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e25:	01 00 00 
  803e28:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e2c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e34:	83 e0 01             	and    $0x1,%eax
  803e37:	48 85 c0             	test   %rax,%rax
  803e3a:	75 07                	jne    803e43 <pageref+0x64>
		return 0;
  803e3c:	b8 00 00 00 00       	mov    $0x0,%eax
  803e41:	eb 23                	jmp    803e66 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e47:	48 c1 e8 0c          	shr    $0xc,%rax
  803e4b:	48 89 c2             	mov    %rax,%rdx
  803e4e:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e55:	00 00 00 
  803e58:	48 c1 e2 04          	shl    $0x4,%rdx
  803e5c:	48 01 d0             	add    %rdx,%rax
  803e5f:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e63:	0f b7 c0             	movzwl %ax,%eax
}
  803e66:	c9                   	leaveq 
  803e67:	c3                   	retq   
