
obj/user/primes.debug:     file format elf64-x86-64


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
  80003c:	e8 8d 01 00 00       	callq  8001ce <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80004b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80004f:	ba 00 00 00 00       	mov    $0x0,%edx
  800054:	be 00 00 00 00       	mov    $0x0,%esi
  800059:	48 89 c7             	mov    %rax,%rdi
  80005c:	48 b8 01 23 80 00 00 	movabs $0x802301,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80006b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800072:	00 00 00 
  800075:	48 8b 00             	mov    (%rax),%rax
  800078:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
  80007e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800081:	89 c6                	mov    %eax,%esi
  800083:	48 bf 60 3c 80 00 00 	movabs $0x803c60,%rdi
  80008a:	00 00 00 
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  800099:	00 00 00 
  80009c:	ff d1                	callq  *%rcx

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  80009e:	48 b8 67 20 80 00 00 	movabs $0x802067,%rax
  8000a5:	00 00 00 
  8000a8:	ff d0                	callq  *%rax
  8000aa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000ad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000b1:	79 30                	jns    8000e3 <primeproc+0xa0>
		panic("fork: %e", id);
  8000b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000b6:	89 c1                	mov    %eax,%ecx
  8000b8:	48 ba 6c 3c 80 00 00 	movabs $0x803c6c,%rdx
  8000bf:	00 00 00 
  8000c2:	be 1a 00 00 00       	mov    $0x1a,%esi
  8000c7:	48 bf 75 3c 80 00 00 	movabs $0x803c75,%rdi
  8000ce:	00 00 00 
  8000d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d6:	49 b8 81 02 80 00 00 	movabs $0x800281,%r8
  8000dd:	00 00 00 
  8000e0:	41 ff d0             	callq  *%r8
	if (id == 0)
  8000e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e7:	75 05                	jne    8000ee <primeproc+0xab>
		goto top;
  8000e9:	e9 5d ff ff ff       	jmpq   80004b <primeproc+0x8>

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000ee:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f7:	be 00 00 00 00       	mov    $0x0,%esi
  8000fc:	48 89 c7             	mov    %rax,%rdi
  8000ff:	48 b8 01 23 80 00 00 	movabs $0x802301,%rax
  800106:	00 00 00 
  800109:	ff d0                	callq  *%rax
  80010b:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (i % p)
  80010e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800111:	99                   	cltd   
  800112:	f7 7d fc             	idivl  -0x4(%rbp)
  800115:	89 d0                	mov    %edx,%eax
  800117:	85 c0                	test   %eax,%eax
  800119:	74 20                	je     80013b <primeproc+0xf8>
			ipc_send(id, i, 0, 0);
  80011b:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80011e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800121:	b9 00 00 00 00       	mov    $0x0,%ecx
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
  80012b:	89 c7                	mov    %eax,%edi
  80012d:	48 b8 ca 23 80 00 00 	movabs $0x8023ca,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
	}
  800139:	eb b3                	jmp    8000ee <primeproc+0xab>
  80013b:	eb b1                	jmp    8000ee <primeproc+0xab>

000000000080013d <umain>:
}

void
umain(int argc, char **argv)
{
  80013d:	55                   	push   %rbp
  80013e:	48 89 e5             	mov    %rsp,%rbp
  800141:	48 83 ec 20          	sub    $0x20,%rsp
  800145:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800148:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  80014c:	48 b8 67 20 80 00 00 	movabs $0x802067,%rax
  800153:	00 00 00 
  800156:	ff d0                	callq  *%rax
  800158:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80015b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80015f:	79 30                	jns    800191 <umain+0x54>
		panic("fork: %e", id);
  800161:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800164:	89 c1                	mov    %eax,%ecx
  800166:	48 ba 6c 3c 80 00 00 	movabs $0x803c6c,%rdx
  80016d:	00 00 00 
  800170:	be 2d 00 00 00       	mov    $0x2d,%esi
  800175:	48 bf 75 3c 80 00 00 	movabs $0x803c75,%rdi
  80017c:	00 00 00 
  80017f:	b8 00 00 00 00       	mov    $0x0,%eax
  800184:	49 b8 81 02 80 00 00 	movabs $0x800281,%r8
  80018b:	00 00 00 
  80018e:	41 ff d0             	callq  *%r8
	if (id == 0)
  800191:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800195:	75 0c                	jne    8001a3 <umain+0x66>
		primeproc();
  800197:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80019e:	00 00 00 
  8001a1:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i = 2; ; i++)
  8001a3:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001aa:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 ca 23 80 00 00 	movabs $0x8023ca,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8001c8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001cc:	eb dc                	jmp    8001aa <umain+0x6d>

00000000008001ce <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ce:	55                   	push   %rbp
  8001cf:	48 89 e5             	mov    %rsp,%rbp
  8001d2:	48 83 ec 10          	sub    $0x10,%rsp
  8001d6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001d9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8001dd:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
  8001e9:	48 98                	cltq   
  8001eb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001f0:	48 89 c2             	mov    %rax,%rdx
  8001f3:	48 89 d0             	mov    %rdx,%rax
  8001f6:	48 c1 e0 03          	shl    $0x3,%rax
  8001fa:	48 01 d0             	add    %rdx,%rax
  8001fd:	48 c1 e0 05          	shl    $0x5,%rax
  800201:	48 89 c2             	mov    %rax,%rdx
  800204:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80020b:	00 00 00 
  80020e:	48 01 c2             	add    %rax,%rdx
  800211:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800218:	00 00 00 
  80021b:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80021e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800222:	7e 14                	jle    800238 <libmain+0x6a>
		binaryname = argv[0];
  800224:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800228:	48 8b 10             	mov    (%rax),%rdx
  80022b:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800232:	00 00 00 
  800235:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800238:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80023c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80023f:	48 89 d6             	mov    %rdx,%rsi
  800242:	89 c7                	mov    %eax,%edi
  800244:	48 b8 3d 01 80 00 00 	movabs $0x80013d,%rax
  80024b:	00 00 00 
  80024e:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800250:	48 b8 5e 02 80 00 00 	movabs $0x80025e,%rax
  800257:	00 00 00 
  80025a:	ff d0                	callq  *%rax
}
  80025c:	c9                   	leaveq 
  80025d:	c3                   	retq   

000000000080025e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80025e:	55                   	push   %rbp
  80025f:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800262:	48 b8 25 28 80 00 00 	movabs $0x802825,%rax
  800269:	00 00 00 
  80026c:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80026e:	bf 00 00 00 00       	mov    $0x0,%edi
  800273:	48 b8 d1 1a 80 00 00 	movabs $0x801ad1,%rax
  80027a:	00 00 00 
  80027d:	ff d0                	callq  *%rax
}
  80027f:	5d                   	pop    %rbp
  800280:	c3                   	retq   

0000000000800281 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800281:	55                   	push   %rbp
  800282:	48 89 e5             	mov    %rsp,%rbp
  800285:	53                   	push   %rbx
  800286:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80028d:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800294:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80029a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002a1:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002a8:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002af:	84 c0                	test   %al,%al
  8002b1:	74 23                	je     8002d6 <_panic+0x55>
  8002b3:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002ba:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002be:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002c2:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002c6:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002ca:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002ce:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002d2:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002d6:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002dd:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002e4:	00 00 00 
  8002e7:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002ee:	00 00 00 
  8002f1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002f5:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002fc:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800303:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80030a:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800311:	00 00 00 
  800314:	48 8b 18             	mov    (%rax),%rbx
  800317:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  80031e:	00 00 00 
  800321:	ff d0                	callq  *%rax
  800323:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800329:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800330:	41 89 c8             	mov    %ecx,%r8d
  800333:	48 89 d1             	mov    %rdx,%rcx
  800336:	48 89 da             	mov    %rbx,%rdx
  800339:	89 c6                	mov    %eax,%esi
  80033b:	48 bf 90 3c 80 00 00 	movabs $0x803c90,%rdi
  800342:	00 00 00 
  800345:	b8 00 00 00 00       	mov    $0x0,%eax
  80034a:	49 b9 ba 04 80 00 00 	movabs $0x8004ba,%r9
  800351:	00 00 00 
  800354:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800357:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80035e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800365:	48 89 d6             	mov    %rdx,%rsi
  800368:	48 89 c7             	mov    %rax,%rdi
  80036b:	48 b8 0e 04 80 00 00 	movabs $0x80040e,%rax
  800372:	00 00 00 
  800375:	ff d0                	callq  *%rax
	cprintf("\n");
  800377:	48 bf b3 3c 80 00 00 	movabs $0x803cb3,%rdi
  80037e:	00 00 00 
  800381:	b8 00 00 00 00       	mov    $0x0,%eax
  800386:	48 ba ba 04 80 00 00 	movabs $0x8004ba,%rdx
  80038d:	00 00 00 
  800390:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800392:	cc                   	int3   
  800393:	eb fd                	jmp    800392 <_panic+0x111>

0000000000800395 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800395:	55                   	push   %rbp
  800396:	48 89 e5             	mov    %rsp,%rbp
  800399:	48 83 ec 10          	sub    $0x10,%rsp
  80039d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8003a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a8:	8b 00                	mov    (%rax),%eax
  8003aa:	8d 48 01             	lea    0x1(%rax),%ecx
  8003ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b1:	89 0a                	mov    %ecx,(%rdx)
  8003b3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003b6:	89 d1                	mov    %edx,%ecx
  8003b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003bc:	48 98                	cltq   
  8003be:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8003c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c6:	8b 00                	mov    (%rax),%eax
  8003c8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003cd:	75 2c                	jne    8003fb <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8003cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d3:	8b 00                	mov    (%rax),%eax
  8003d5:	48 98                	cltq   
  8003d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003db:	48 83 c2 08          	add    $0x8,%rdx
  8003df:	48 89 c6             	mov    %rax,%rsi
  8003e2:	48 89 d7             	mov    %rdx,%rdi
  8003e5:	48 b8 49 1a 80 00 00 	movabs $0x801a49,%rax
  8003ec:	00 00 00 
  8003ef:	ff d0                	callq  *%rax
		b->idx = 0;
  8003f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8003fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ff:	8b 40 04             	mov    0x4(%rax),%eax
  800402:	8d 50 01             	lea    0x1(%rax),%edx
  800405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800409:	89 50 04             	mov    %edx,0x4(%rax)
}
  80040c:	c9                   	leaveq 
  80040d:	c3                   	retq   

000000000080040e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80040e:	55                   	push   %rbp
  80040f:	48 89 e5             	mov    %rsp,%rbp
  800412:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800419:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800420:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800427:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80042e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800435:	48 8b 0a             	mov    (%rdx),%rcx
  800438:	48 89 08             	mov    %rcx,(%rax)
  80043b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80043f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800443:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800447:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  80044b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800452:	00 00 00 
	b.cnt = 0;
  800455:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80045c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80045f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800466:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80046d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800474:	48 89 c6             	mov    %rax,%rsi
  800477:	48 bf 95 03 80 00 00 	movabs $0x800395,%rdi
  80047e:	00 00 00 
  800481:	48 b8 6d 08 80 00 00 	movabs $0x80086d,%rax
  800488:	00 00 00 
  80048b:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80048d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800493:	48 98                	cltq   
  800495:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80049c:	48 83 c2 08          	add    $0x8,%rdx
  8004a0:	48 89 c6             	mov    %rax,%rsi
  8004a3:	48 89 d7             	mov    %rdx,%rdi
  8004a6:	48 b8 49 1a 80 00 00 	movabs $0x801a49,%rax
  8004ad:	00 00 00 
  8004b0:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8004b2:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004b8:	c9                   	leaveq 
  8004b9:	c3                   	retq   

00000000008004ba <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004ba:	55                   	push   %rbp
  8004bb:	48 89 e5             	mov    %rsp,%rbp
  8004be:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004c5:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004cc:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004d3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004da:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004e1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004e8:	84 c0                	test   %al,%al
  8004ea:	74 20                	je     80050c <cprintf+0x52>
  8004ec:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004f0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004f4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004f8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004fc:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800500:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800504:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800508:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80050c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800513:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80051a:	00 00 00 
  80051d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800524:	00 00 00 
  800527:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80052b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800532:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800539:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800540:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800547:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80054e:	48 8b 0a             	mov    (%rdx),%rcx
  800551:	48 89 08             	mov    %rcx,(%rax)
  800554:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800558:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80055c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800560:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800564:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80056b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800572:	48 89 d6             	mov    %rdx,%rsi
  800575:	48 89 c7             	mov    %rax,%rdi
  800578:	48 b8 0e 04 80 00 00 	movabs $0x80040e,%rax
  80057f:	00 00 00 
  800582:	ff d0                	callq  *%rax
  800584:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80058a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800590:	c9                   	leaveq 
  800591:	c3                   	retq   

0000000000800592 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800592:	55                   	push   %rbp
  800593:	48 89 e5             	mov    %rsp,%rbp
  800596:	53                   	push   %rbx
  800597:	48 83 ec 38          	sub    $0x38,%rsp
  80059b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80059f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005a7:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005aa:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005ae:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005b5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005b9:	77 3b                	ja     8005f6 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005bb:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005be:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005c2:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ce:	48 f7 f3             	div    %rbx
  8005d1:	48 89 c2             	mov    %rax,%rdx
  8005d4:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005d7:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005da:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e2:	41 89 f9             	mov    %edi,%r9d
  8005e5:	48 89 c7             	mov    %rax,%rdi
  8005e8:	48 b8 92 05 80 00 00 	movabs $0x800592,%rax
  8005ef:	00 00 00 
  8005f2:	ff d0                	callq  *%rax
  8005f4:	eb 1e                	jmp    800614 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f6:	eb 12                	jmp    80060a <printnum+0x78>
			putch(padc, putdat);
  8005f8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005fc:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800603:	48 89 ce             	mov    %rcx,%rsi
  800606:	89 d7                	mov    %edx,%edi
  800608:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80060a:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80060e:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800612:	7f e4                	jg     8005f8 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800614:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800617:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80061b:	ba 00 00 00 00       	mov    $0x0,%edx
  800620:	48 f7 f1             	div    %rcx
  800623:	48 89 d0             	mov    %rdx,%rax
  800626:	48 ba 88 3e 80 00 00 	movabs $0x803e88,%rdx
  80062d:	00 00 00 
  800630:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800634:	0f be d0             	movsbl %al,%edx
  800637:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80063b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063f:	48 89 ce             	mov    %rcx,%rsi
  800642:	89 d7                	mov    %edx,%edi
  800644:	ff d0                	callq  *%rax
}
  800646:	48 83 c4 38          	add    $0x38,%rsp
  80064a:	5b                   	pop    %rbx
  80064b:	5d                   	pop    %rbp
  80064c:	c3                   	retq   

000000000080064d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064d:	55                   	push   %rbp
  80064e:	48 89 e5             	mov    %rsp,%rbp
  800651:	48 83 ec 1c          	sub    $0x1c,%rsp
  800655:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800659:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  80065c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800660:	7e 52                	jle    8006b4 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800662:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800666:	8b 00                	mov    (%rax),%eax
  800668:	83 f8 30             	cmp    $0x30,%eax
  80066b:	73 24                	jae    800691 <getuint+0x44>
  80066d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800671:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800675:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800679:	8b 00                	mov    (%rax),%eax
  80067b:	89 c0                	mov    %eax,%eax
  80067d:	48 01 d0             	add    %rdx,%rax
  800680:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800684:	8b 12                	mov    (%rdx),%edx
  800686:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800689:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068d:	89 0a                	mov    %ecx,(%rdx)
  80068f:	eb 17                	jmp    8006a8 <getuint+0x5b>
  800691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800695:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800699:	48 89 d0             	mov    %rdx,%rax
  80069c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006a8:	48 8b 00             	mov    (%rax),%rax
  8006ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006af:	e9 a3 00 00 00       	jmpq   800757 <getuint+0x10a>
	else if (lflag)
  8006b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006b8:	74 4f                	je     800709 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006be:	8b 00                	mov    (%rax),%eax
  8006c0:	83 f8 30             	cmp    $0x30,%eax
  8006c3:	73 24                	jae    8006e9 <getuint+0x9c>
  8006c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d1:	8b 00                	mov    (%rax),%eax
  8006d3:	89 c0                	mov    %eax,%eax
  8006d5:	48 01 d0             	add    %rdx,%rax
  8006d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006dc:	8b 12                	mov    (%rdx),%edx
  8006de:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e5:	89 0a                	mov    %ecx,(%rdx)
  8006e7:	eb 17                	jmp    800700 <getuint+0xb3>
  8006e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ed:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006f1:	48 89 d0             	mov    %rdx,%rax
  8006f4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800700:	48 8b 00             	mov    (%rax),%rax
  800703:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800707:	eb 4e                	jmp    800757 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070d:	8b 00                	mov    (%rax),%eax
  80070f:	83 f8 30             	cmp    $0x30,%eax
  800712:	73 24                	jae    800738 <getuint+0xeb>
  800714:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800718:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80071c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800720:	8b 00                	mov    (%rax),%eax
  800722:	89 c0                	mov    %eax,%eax
  800724:	48 01 d0             	add    %rdx,%rax
  800727:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072b:	8b 12                	mov    (%rdx),%edx
  80072d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800730:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800734:	89 0a                	mov    %ecx,(%rdx)
  800736:	eb 17                	jmp    80074f <getuint+0x102>
  800738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800740:	48 89 d0             	mov    %rdx,%rax
  800743:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800747:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80074f:	8b 00                	mov    (%rax),%eax
  800751:	89 c0                	mov    %eax,%eax
  800753:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800757:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80075b:	c9                   	leaveq 
  80075c:	c3                   	retq   

000000000080075d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80075d:	55                   	push   %rbp
  80075e:	48 89 e5             	mov    %rsp,%rbp
  800761:	48 83 ec 1c          	sub    $0x1c,%rsp
  800765:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800769:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80076c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800770:	7e 52                	jle    8007c4 <getint+0x67>
		x=va_arg(*ap, long long);
  800772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800776:	8b 00                	mov    (%rax),%eax
  800778:	83 f8 30             	cmp    $0x30,%eax
  80077b:	73 24                	jae    8007a1 <getint+0x44>
  80077d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800781:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800785:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800789:	8b 00                	mov    (%rax),%eax
  80078b:	89 c0                	mov    %eax,%eax
  80078d:	48 01 d0             	add    %rdx,%rax
  800790:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800794:	8b 12                	mov    (%rdx),%edx
  800796:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800799:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079d:	89 0a                	mov    %ecx,(%rdx)
  80079f:	eb 17                	jmp    8007b8 <getint+0x5b>
  8007a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007a9:	48 89 d0             	mov    %rdx,%rax
  8007ac:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007b8:	48 8b 00             	mov    (%rax),%rax
  8007bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007bf:	e9 a3 00 00 00       	jmpq   800867 <getint+0x10a>
	else if (lflag)
  8007c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007c8:	74 4f                	je     800819 <getint+0xbc>
		x=va_arg(*ap, long);
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	8b 00                	mov    (%rax),%eax
  8007d0:	83 f8 30             	cmp    $0x30,%eax
  8007d3:	73 24                	jae    8007f9 <getint+0x9c>
  8007d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e1:	8b 00                	mov    (%rax),%eax
  8007e3:	89 c0                	mov    %eax,%eax
  8007e5:	48 01 d0             	add    %rdx,%rax
  8007e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ec:	8b 12                	mov    (%rdx),%edx
  8007ee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f5:	89 0a                	mov    %ecx,(%rdx)
  8007f7:	eb 17                	jmp    800810 <getint+0xb3>
  8007f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800801:	48 89 d0             	mov    %rdx,%rax
  800804:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800808:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800810:	48 8b 00             	mov    (%rax),%rax
  800813:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800817:	eb 4e                	jmp    800867 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081d:	8b 00                	mov    (%rax),%eax
  80081f:	83 f8 30             	cmp    $0x30,%eax
  800822:	73 24                	jae    800848 <getint+0xeb>
  800824:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800828:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800830:	8b 00                	mov    (%rax),%eax
  800832:	89 c0                	mov    %eax,%eax
  800834:	48 01 d0             	add    %rdx,%rax
  800837:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083b:	8b 12                	mov    (%rdx),%edx
  80083d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800840:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800844:	89 0a                	mov    %ecx,(%rdx)
  800846:	eb 17                	jmp    80085f <getint+0x102>
  800848:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800850:	48 89 d0             	mov    %rdx,%rax
  800853:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800857:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80085f:	8b 00                	mov    (%rax),%eax
  800861:	48 98                	cltq   
  800863:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800867:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80086b:	c9                   	leaveq 
  80086c:	c3                   	retq   

000000000080086d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80086d:	55                   	push   %rbp
  80086e:	48 89 e5             	mov    %rsp,%rbp
  800871:	41 54                	push   %r12
  800873:	53                   	push   %rbx
  800874:	48 83 ec 60          	sub    $0x60,%rsp
  800878:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80087c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800880:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800884:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800888:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80088c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800890:	48 8b 0a             	mov    (%rdx),%rcx
  800893:	48 89 08             	mov    %rcx,(%rax)
  800896:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80089a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80089e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008a2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  8008a6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008aa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008ae:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008b2:	0f b6 00             	movzbl (%rax),%eax
  8008b5:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  8008b8:	eb 29                	jmp    8008e3 <vprintfmt+0x76>
			if (ch == '\0')
  8008ba:	85 db                	test   %ebx,%ebx
  8008bc:	0f 84 ad 06 00 00    	je     800f6f <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  8008c2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008c6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ca:	48 89 d6             	mov    %rdx,%rsi
  8008cd:	89 df                	mov    %ebx,%edi
  8008cf:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  8008d1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008d5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008d9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008dd:	0f b6 00             	movzbl (%rax),%eax
  8008e0:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  8008e3:	83 fb 25             	cmp    $0x25,%ebx
  8008e6:	74 05                	je     8008ed <vprintfmt+0x80>
  8008e8:	83 fb 1b             	cmp    $0x1b,%ebx
  8008eb:	75 cd                	jne    8008ba <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  8008ed:	83 fb 1b             	cmp    $0x1b,%ebx
  8008f0:	0f 85 ae 01 00 00    	jne    800aa4 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  8008f6:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8008fd:	00 00 00 
  800900:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  800906:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80090a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80090e:	48 89 d6             	mov    %rdx,%rsi
  800911:	89 df                	mov    %ebx,%edi
  800913:	ff d0                	callq  *%rax
			putch('[', putdat);
  800915:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800919:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80091d:	48 89 d6             	mov    %rdx,%rsi
  800920:	bf 5b 00 00 00       	mov    $0x5b,%edi
  800925:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800927:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  80092d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800932:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800936:	0f b6 00             	movzbl (%rax),%eax
  800939:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  80093c:	eb 32                	jmp    800970 <vprintfmt+0x103>
					putch(ch, putdat);
  80093e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800942:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800946:	48 89 d6             	mov    %rdx,%rsi
  800949:	89 df                	mov    %ebx,%edi
  80094b:	ff d0                	callq  *%rax
					esc_color *= 10;
  80094d:	44 89 e0             	mov    %r12d,%eax
  800950:	c1 e0 02             	shl    $0x2,%eax
  800953:	44 01 e0             	add    %r12d,%eax
  800956:	01 c0                	add    %eax,%eax
  800958:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  80095b:	8d 43 d0             	lea    -0x30(%rbx),%eax
  80095e:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800961:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800966:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80096a:	0f b6 00             	movzbl (%rax),%eax
  80096d:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800970:	83 fb 3b             	cmp    $0x3b,%ebx
  800973:	74 05                	je     80097a <vprintfmt+0x10d>
  800975:	83 fb 6d             	cmp    $0x6d,%ebx
  800978:	75 c4                	jne    80093e <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  80097a:	45 85 e4             	test   %r12d,%r12d
  80097d:	75 15                	jne    800994 <vprintfmt+0x127>
					color_flag = 0x07;
  80097f:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800986:	00 00 00 
  800989:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  80098f:	e9 dc 00 00 00       	jmpq   800a70 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800994:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800998:	7e 69                	jle    800a03 <vprintfmt+0x196>
  80099a:	41 83 fc 25          	cmp    $0x25,%r12d
  80099e:	7f 63                	jg     800a03 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  8009a0:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8009a7:	00 00 00 
  8009aa:	8b 00                	mov    (%rax),%eax
  8009ac:	25 f8 00 00 00       	and    $0xf8,%eax
  8009b1:	89 c2                	mov    %eax,%edx
  8009b3:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8009ba:	00 00 00 
  8009bd:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  8009bf:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  8009c3:	44 89 e0             	mov    %r12d,%eax
  8009c6:	83 e0 04             	and    $0x4,%eax
  8009c9:	c1 f8 02             	sar    $0x2,%eax
  8009cc:	89 c2                	mov    %eax,%edx
  8009ce:	44 89 e0             	mov    %r12d,%eax
  8009d1:	83 e0 02             	and    $0x2,%eax
  8009d4:	09 c2                	or     %eax,%edx
  8009d6:	44 89 e0             	mov    %r12d,%eax
  8009d9:	83 e0 01             	and    $0x1,%eax
  8009dc:	c1 e0 02             	shl    $0x2,%eax
  8009df:	09 c2                	or     %eax,%edx
  8009e1:	41 89 d4             	mov    %edx,%r12d
  8009e4:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8009eb:	00 00 00 
  8009ee:	8b 00                	mov    (%rax),%eax
  8009f0:	44 89 e2             	mov    %r12d,%edx
  8009f3:	09 c2                	or     %eax,%edx
  8009f5:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8009fc:	00 00 00 
  8009ff:	89 10                	mov    %edx,(%rax)
  800a01:	eb 6d                	jmp    800a70 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800a03:	41 83 fc 27          	cmp    $0x27,%r12d
  800a07:	7e 67                	jle    800a70 <vprintfmt+0x203>
  800a09:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800a0d:	7f 61                	jg     800a70 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800a0f:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800a16:	00 00 00 
  800a19:	8b 00                	mov    (%rax),%eax
  800a1b:	25 8f 00 00 00       	and    $0x8f,%eax
  800a20:	89 c2                	mov    %eax,%edx
  800a22:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800a29:	00 00 00 
  800a2c:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800a2e:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800a32:	44 89 e0             	mov    %r12d,%eax
  800a35:	83 e0 04             	and    $0x4,%eax
  800a38:	c1 f8 02             	sar    $0x2,%eax
  800a3b:	89 c2                	mov    %eax,%edx
  800a3d:	44 89 e0             	mov    %r12d,%eax
  800a40:	83 e0 02             	and    $0x2,%eax
  800a43:	09 c2                	or     %eax,%edx
  800a45:	44 89 e0             	mov    %r12d,%eax
  800a48:	83 e0 01             	and    $0x1,%eax
  800a4b:	c1 e0 06             	shl    $0x6,%eax
  800a4e:	09 c2                	or     %eax,%edx
  800a50:	41 89 d4             	mov    %edx,%r12d
  800a53:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800a5a:	00 00 00 
  800a5d:	8b 00                	mov    (%rax),%eax
  800a5f:	44 89 e2             	mov    %r12d,%edx
  800a62:	09 c2                	or     %eax,%edx
  800a64:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800a6b:	00 00 00 
  800a6e:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800a70:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a78:	48 89 d6             	mov    %rdx,%rsi
  800a7b:	89 df                	mov    %ebx,%edi
  800a7d:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800a7f:	83 fb 6d             	cmp    $0x6d,%ebx
  800a82:	75 1b                	jne    800a9f <vprintfmt+0x232>
					fmt ++;
  800a84:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800a89:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800a8a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800a91:	00 00 00 
  800a94:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800a9a:	e9 cb 04 00 00       	jmpq   800f6a <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800a9f:	e9 83 fe ff ff       	jmpq   800927 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800aa4:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800aa8:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800aaf:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800ab6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800abd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ac4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ac8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800acc:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ad0:	0f b6 00             	movzbl (%rax),%eax
  800ad3:	0f b6 d8             	movzbl %al,%ebx
  800ad6:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800ad9:	83 f8 55             	cmp    $0x55,%eax
  800adc:	0f 87 5a 04 00 00    	ja     800f3c <vprintfmt+0x6cf>
  800ae2:	89 c0                	mov    %eax,%eax
  800ae4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800aeb:	00 
  800aec:	48 b8 b0 3e 80 00 00 	movabs $0x803eb0,%rax
  800af3:	00 00 00 
  800af6:	48 01 d0             	add    %rdx,%rax
  800af9:	48 8b 00             	mov    (%rax),%rax
  800afc:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800afe:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800b02:	eb c0                	jmp    800ac4 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b04:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800b08:	eb ba                	jmp    800ac4 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b0a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b11:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b14:	89 d0                	mov    %edx,%eax
  800b16:	c1 e0 02             	shl    $0x2,%eax
  800b19:	01 d0                	add    %edx,%eax
  800b1b:	01 c0                	add    %eax,%eax
  800b1d:	01 d8                	add    %ebx,%eax
  800b1f:	83 e8 30             	sub    $0x30,%eax
  800b22:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b25:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b29:	0f b6 00             	movzbl (%rax),%eax
  800b2c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b2f:	83 fb 2f             	cmp    $0x2f,%ebx
  800b32:	7e 0c                	jle    800b40 <vprintfmt+0x2d3>
  800b34:	83 fb 39             	cmp    $0x39,%ebx
  800b37:	7f 07                	jg     800b40 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b39:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b3e:	eb d1                	jmp    800b11 <vprintfmt+0x2a4>
			goto process_precision;
  800b40:	eb 58                	jmp    800b9a <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800b42:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b45:	83 f8 30             	cmp    $0x30,%eax
  800b48:	73 17                	jae    800b61 <vprintfmt+0x2f4>
  800b4a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b4e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b51:	89 c0                	mov    %eax,%eax
  800b53:	48 01 d0             	add    %rdx,%rax
  800b56:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b59:	83 c2 08             	add    $0x8,%edx
  800b5c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b5f:	eb 0f                	jmp    800b70 <vprintfmt+0x303>
  800b61:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b65:	48 89 d0             	mov    %rdx,%rax
  800b68:	48 83 c2 08          	add    $0x8,%rdx
  800b6c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b70:	8b 00                	mov    (%rax),%eax
  800b72:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b75:	eb 23                	jmp    800b9a <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800b77:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b7b:	79 0c                	jns    800b89 <vprintfmt+0x31c>
				width = 0;
  800b7d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b84:	e9 3b ff ff ff       	jmpq   800ac4 <vprintfmt+0x257>
  800b89:	e9 36 ff ff ff       	jmpq   800ac4 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800b8e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b95:	e9 2a ff ff ff       	jmpq   800ac4 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800b9a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b9e:	79 12                	jns    800bb2 <vprintfmt+0x345>
				width = precision, precision = -1;
  800ba0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ba3:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ba6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800bad:	e9 12 ff ff ff       	jmpq   800ac4 <vprintfmt+0x257>
  800bb2:	e9 0d ff ff ff       	jmpq   800ac4 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800bb7:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800bbb:	e9 04 ff ff ff       	jmpq   800ac4 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800bc0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc3:	83 f8 30             	cmp    $0x30,%eax
  800bc6:	73 17                	jae    800bdf <vprintfmt+0x372>
  800bc8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bcc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcf:	89 c0                	mov    %eax,%eax
  800bd1:	48 01 d0             	add    %rdx,%rax
  800bd4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd7:	83 c2 08             	add    $0x8,%edx
  800bda:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bdd:	eb 0f                	jmp    800bee <vprintfmt+0x381>
  800bdf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be3:	48 89 d0             	mov    %rdx,%rax
  800be6:	48 83 c2 08          	add    $0x8,%rdx
  800bea:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bee:	8b 10                	mov    (%rax),%edx
  800bf0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bf4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf8:	48 89 ce             	mov    %rcx,%rsi
  800bfb:	89 d7                	mov    %edx,%edi
  800bfd:	ff d0                	callq  *%rax
			break;
  800bff:	e9 66 03 00 00       	jmpq   800f6a <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800c04:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c07:	83 f8 30             	cmp    $0x30,%eax
  800c0a:	73 17                	jae    800c23 <vprintfmt+0x3b6>
  800c0c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c10:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c13:	89 c0                	mov    %eax,%eax
  800c15:	48 01 d0             	add    %rdx,%rax
  800c18:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c1b:	83 c2 08             	add    $0x8,%edx
  800c1e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c21:	eb 0f                	jmp    800c32 <vprintfmt+0x3c5>
  800c23:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c27:	48 89 d0             	mov    %rdx,%rax
  800c2a:	48 83 c2 08          	add    $0x8,%rdx
  800c2e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c32:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c34:	85 db                	test   %ebx,%ebx
  800c36:	79 02                	jns    800c3a <vprintfmt+0x3cd>
				err = -err;
  800c38:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c3a:	83 fb 10             	cmp    $0x10,%ebx
  800c3d:	7f 16                	jg     800c55 <vprintfmt+0x3e8>
  800c3f:	48 b8 00 3e 80 00 00 	movabs $0x803e00,%rax
  800c46:	00 00 00 
  800c49:	48 63 d3             	movslq %ebx,%rdx
  800c4c:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c50:	4d 85 e4             	test   %r12,%r12
  800c53:	75 2e                	jne    800c83 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800c55:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5d:	89 d9                	mov    %ebx,%ecx
  800c5f:	48 ba 99 3e 80 00 00 	movabs $0x803e99,%rdx
  800c66:	00 00 00 
  800c69:	48 89 c7             	mov    %rax,%rdi
  800c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c71:	49 b8 78 0f 80 00 00 	movabs $0x800f78,%r8
  800c78:	00 00 00 
  800c7b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c7e:	e9 e7 02 00 00       	jmpq   800f6a <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c83:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c87:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c8b:	4c 89 e1             	mov    %r12,%rcx
  800c8e:	48 ba a2 3e 80 00 00 	movabs $0x803ea2,%rdx
  800c95:	00 00 00 
  800c98:	48 89 c7             	mov    %rax,%rdi
  800c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca0:	49 b8 78 0f 80 00 00 	movabs $0x800f78,%r8
  800ca7:	00 00 00 
  800caa:	41 ff d0             	callq  *%r8
			break;
  800cad:	e9 b8 02 00 00       	jmpq   800f6a <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800cb2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb5:	83 f8 30             	cmp    $0x30,%eax
  800cb8:	73 17                	jae    800cd1 <vprintfmt+0x464>
  800cba:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cbe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc1:	89 c0                	mov    %eax,%eax
  800cc3:	48 01 d0             	add    %rdx,%rax
  800cc6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc9:	83 c2 08             	add    $0x8,%edx
  800ccc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ccf:	eb 0f                	jmp    800ce0 <vprintfmt+0x473>
  800cd1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cd5:	48 89 d0             	mov    %rdx,%rax
  800cd8:	48 83 c2 08          	add    $0x8,%rdx
  800cdc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ce0:	4c 8b 20             	mov    (%rax),%r12
  800ce3:	4d 85 e4             	test   %r12,%r12
  800ce6:	75 0a                	jne    800cf2 <vprintfmt+0x485>
				p = "(null)";
  800ce8:	49 bc a5 3e 80 00 00 	movabs $0x803ea5,%r12
  800cef:	00 00 00 
			if (width > 0 && padc != '-')
  800cf2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cf6:	7e 3f                	jle    800d37 <vprintfmt+0x4ca>
  800cf8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cfc:	74 39                	je     800d37 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cfe:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d01:	48 98                	cltq   
  800d03:	48 89 c6             	mov    %rax,%rsi
  800d06:	4c 89 e7             	mov    %r12,%rdi
  800d09:	48 b8 24 12 80 00 00 	movabs $0x801224,%rax
  800d10:	00 00 00 
  800d13:	ff d0                	callq  *%rax
  800d15:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d18:	eb 17                	jmp    800d31 <vprintfmt+0x4c4>
					putch(padc, putdat);
  800d1a:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d1e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d26:	48 89 ce             	mov    %rcx,%rsi
  800d29:	89 d7                	mov    %edx,%edi
  800d2b:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d2d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d31:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d35:	7f e3                	jg     800d1a <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d37:	eb 37                	jmp    800d70 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800d39:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d3d:	74 1e                	je     800d5d <vprintfmt+0x4f0>
  800d3f:	83 fb 1f             	cmp    $0x1f,%ebx
  800d42:	7e 05                	jle    800d49 <vprintfmt+0x4dc>
  800d44:	83 fb 7e             	cmp    $0x7e,%ebx
  800d47:	7e 14                	jle    800d5d <vprintfmt+0x4f0>
					putch('?', putdat);
  800d49:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d4d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d51:	48 89 d6             	mov    %rdx,%rsi
  800d54:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d59:	ff d0                	callq  *%rax
  800d5b:	eb 0f                	jmp    800d6c <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800d5d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d65:	48 89 d6             	mov    %rdx,%rsi
  800d68:	89 df                	mov    %ebx,%edi
  800d6a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d6c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d70:	4c 89 e0             	mov    %r12,%rax
  800d73:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d77:	0f b6 00             	movzbl (%rax),%eax
  800d7a:	0f be d8             	movsbl %al,%ebx
  800d7d:	85 db                	test   %ebx,%ebx
  800d7f:	74 10                	je     800d91 <vprintfmt+0x524>
  800d81:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d85:	78 b2                	js     800d39 <vprintfmt+0x4cc>
  800d87:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d8b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d8f:	79 a8                	jns    800d39 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d91:	eb 16                	jmp    800da9 <vprintfmt+0x53c>
				putch(' ', putdat);
  800d93:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d97:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9b:	48 89 d6             	mov    %rdx,%rsi
  800d9e:	bf 20 00 00 00       	mov    $0x20,%edi
  800da3:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800da9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dad:	7f e4                	jg     800d93 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800daf:	e9 b6 01 00 00       	jmpq   800f6a <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800db4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800db8:	be 03 00 00 00       	mov    $0x3,%esi
  800dbd:	48 89 c7             	mov    %rax,%rdi
  800dc0:	48 b8 5d 07 80 00 00 	movabs $0x80075d,%rax
  800dc7:	00 00 00 
  800dca:	ff d0                	callq  *%rax
  800dcc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800dd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd4:	48 85 c0             	test   %rax,%rax
  800dd7:	79 1d                	jns    800df6 <vprintfmt+0x589>
				putch('-', putdat);
  800dd9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ddd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de1:	48 89 d6             	mov    %rdx,%rsi
  800de4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800de9:	ff d0                	callq  *%rax
				num = -(long long) num;
  800deb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800def:	48 f7 d8             	neg    %rax
  800df2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800df6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dfd:	e9 fb 00 00 00       	jmpq   800efd <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e02:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e06:	be 03 00 00 00       	mov    $0x3,%esi
  800e0b:	48 89 c7             	mov    %rax,%rdi
  800e0e:	48 b8 4d 06 80 00 00 	movabs $0x80064d,%rax
  800e15:	00 00 00 
  800e18:	ff d0                	callq  *%rax
  800e1a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e1e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e25:	e9 d3 00 00 00       	jmpq   800efd <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800e2a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e2e:	be 03 00 00 00       	mov    $0x3,%esi
  800e33:	48 89 c7             	mov    %rax,%rdi
  800e36:	48 b8 5d 07 80 00 00 	movabs $0x80075d,%rax
  800e3d:	00 00 00 
  800e40:	ff d0                	callq  *%rax
  800e42:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4a:	48 85 c0             	test   %rax,%rax
  800e4d:	79 1d                	jns    800e6c <vprintfmt+0x5ff>
				putch('-', putdat);
  800e4f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e53:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e57:	48 89 d6             	mov    %rdx,%rsi
  800e5a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e5f:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e65:	48 f7 d8             	neg    %rax
  800e68:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800e6c:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e73:	e9 85 00 00 00       	jmpq   800efd <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800e78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e80:	48 89 d6             	mov    %rdx,%rsi
  800e83:	bf 30 00 00 00       	mov    $0x30,%edi
  800e88:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e8a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e92:	48 89 d6             	mov    %rdx,%rsi
  800e95:	bf 78 00 00 00       	mov    $0x78,%edi
  800e9a:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e9c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e9f:	83 f8 30             	cmp    $0x30,%eax
  800ea2:	73 17                	jae    800ebb <vprintfmt+0x64e>
  800ea4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ea8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800eab:	89 c0                	mov    %eax,%eax
  800ead:	48 01 d0             	add    %rdx,%rax
  800eb0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800eb3:	83 c2 08             	add    $0x8,%edx
  800eb6:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800eb9:	eb 0f                	jmp    800eca <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800ebb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ebf:	48 89 d0             	mov    %rdx,%rax
  800ec2:	48 83 c2 08          	add    $0x8,%rdx
  800ec6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800eca:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ecd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ed1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ed8:	eb 23                	jmp    800efd <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800eda:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ede:	be 03 00 00 00       	mov    $0x3,%esi
  800ee3:	48 89 c7             	mov    %rax,%rdi
  800ee6:	48 b8 4d 06 80 00 00 	movabs $0x80064d,%rax
  800eed:	00 00 00 
  800ef0:	ff d0                	callq  *%rax
  800ef2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ef6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800efd:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f02:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f05:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f08:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f0c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f14:	45 89 c1             	mov    %r8d,%r9d
  800f17:	41 89 f8             	mov    %edi,%r8d
  800f1a:	48 89 c7             	mov    %rax,%rdi
  800f1d:	48 b8 92 05 80 00 00 	movabs $0x800592,%rax
  800f24:	00 00 00 
  800f27:	ff d0                	callq  *%rax
			break;
  800f29:	eb 3f                	jmp    800f6a <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f2b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f33:	48 89 d6             	mov    %rdx,%rsi
  800f36:	89 df                	mov    %ebx,%edi
  800f38:	ff d0                	callq  *%rax
			break;
  800f3a:	eb 2e                	jmp    800f6a <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f3c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f44:	48 89 d6             	mov    %rdx,%rsi
  800f47:	bf 25 00 00 00       	mov    $0x25,%edi
  800f4c:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f4e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f53:	eb 05                	jmp    800f5a <vprintfmt+0x6ed>
  800f55:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f5a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f5e:	48 83 e8 01          	sub    $0x1,%rax
  800f62:	0f b6 00             	movzbl (%rax),%eax
  800f65:	3c 25                	cmp    $0x25,%al
  800f67:	75 ec                	jne    800f55 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  800f69:	90                   	nop
		}
	}
  800f6a:	e9 37 f9 ff ff       	jmpq   8008a6 <vprintfmt+0x39>
    va_end(aq);
}
  800f6f:	48 83 c4 60          	add    $0x60,%rsp
  800f73:	5b                   	pop    %rbx
  800f74:	41 5c                	pop    %r12
  800f76:	5d                   	pop    %rbp
  800f77:	c3                   	retq   

0000000000800f78 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f78:	55                   	push   %rbp
  800f79:	48 89 e5             	mov    %rsp,%rbp
  800f7c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f83:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f8a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f91:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f98:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f9f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fa6:	84 c0                	test   %al,%al
  800fa8:	74 20                	je     800fca <printfmt+0x52>
  800faa:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fae:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fb2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fb6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fba:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fbe:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fc2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fc6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fca:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800fd1:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800fd8:	00 00 00 
  800fdb:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800fe2:	00 00 00 
  800fe5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fe9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ff0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ff7:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ffe:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801005:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80100c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801013:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80101a:	48 89 c7             	mov    %rax,%rdi
  80101d:	48 b8 6d 08 80 00 00 	movabs $0x80086d,%rax
  801024:	00 00 00 
  801027:	ff d0                	callq  *%rax
	va_end(ap);
}
  801029:	c9                   	leaveq 
  80102a:	c3                   	retq   

000000000080102b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80102b:	55                   	push   %rbp
  80102c:	48 89 e5             	mov    %rsp,%rbp
  80102f:	48 83 ec 10          	sub    $0x10,%rsp
  801033:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801036:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80103a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80103e:	8b 40 10             	mov    0x10(%rax),%eax
  801041:	8d 50 01             	lea    0x1(%rax),%edx
  801044:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801048:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80104b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80104f:	48 8b 10             	mov    (%rax),%rdx
  801052:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801056:	48 8b 40 08          	mov    0x8(%rax),%rax
  80105a:	48 39 c2             	cmp    %rax,%rdx
  80105d:	73 17                	jae    801076 <sprintputch+0x4b>
		*b->buf++ = ch;
  80105f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801063:	48 8b 00             	mov    (%rax),%rax
  801066:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80106a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80106e:	48 89 0a             	mov    %rcx,(%rdx)
  801071:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801074:	88 10                	mov    %dl,(%rax)
}
  801076:	c9                   	leaveq 
  801077:	c3                   	retq   

0000000000801078 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801078:	55                   	push   %rbp
  801079:	48 89 e5             	mov    %rsp,%rbp
  80107c:	48 83 ec 50          	sub    $0x50,%rsp
  801080:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801084:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801087:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80108b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80108f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801093:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801097:	48 8b 0a             	mov    (%rdx),%rcx
  80109a:	48 89 08             	mov    %rcx,(%rax)
  80109d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010a1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010a5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010a9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010ad:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010b1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8010b5:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8010b8:	48 98                	cltq   
  8010ba:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8010be:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010c2:	48 01 d0             	add    %rdx,%rax
  8010c5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8010c9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8010d0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8010d5:	74 06                	je     8010dd <vsnprintf+0x65>
  8010d7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8010db:	7f 07                	jg     8010e4 <vsnprintf+0x6c>
		return -E_INVAL;
  8010dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e2:	eb 2f                	jmp    801113 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8010e4:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8010e8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8010ec:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010f0:	48 89 c6             	mov    %rax,%rsi
  8010f3:	48 bf 2b 10 80 00 00 	movabs $0x80102b,%rdi
  8010fa:	00 00 00 
  8010fd:	48 b8 6d 08 80 00 00 	movabs $0x80086d,%rax
  801104:	00 00 00 
  801107:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801109:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80110d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801110:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801113:	c9                   	leaveq 
  801114:	c3                   	retq   

0000000000801115 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801115:	55                   	push   %rbp
  801116:	48 89 e5             	mov    %rsp,%rbp
  801119:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801120:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801127:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80112d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801134:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80113b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801142:	84 c0                	test   %al,%al
  801144:	74 20                	je     801166 <snprintf+0x51>
  801146:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80114a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80114e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801152:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801156:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80115a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80115e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801162:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801166:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80116d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801174:	00 00 00 
  801177:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80117e:	00 00 00 
  801181:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801185:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80118c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801193:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80119a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8011a1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8011a8:	48 8b 0a             	mov    (%rdx),%rcx
  8011ab:	48 89 08             	mov    %rcx,(%rax)
  8011ae:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011b2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011b6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011ba:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8011be:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8011c5:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8011cc:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8011d2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8011d9:	48 89 c7             	mov    %rax,%rdi
  8011dc:	48 b8 78 10 80 00 00 	movabs $0x801078,%rax
  8011e3:	00 00 00 
  8011e6:	ff d0                	callq  *%rax
  8011e8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8011ee:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011f4:	c9                   	leaveq 
  8011f5:	c3                   	retq   

00000000008011f6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011f6:	55                   	push   %rbp
  8011f7:	48 89 e5             	mov    %rsp,%rbp
  8011fa:	48 83 ec 18          	sub    $0x18,%rsp
  8011fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801202:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801209:	eb 09                	jmp    801214 <strlen+0x1e>
		n++;
  80120b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80120f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801214:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801218:	0f b6 00             	movzbl (%rax),%eax
  80121b:	84 c0                	test   %al,%al
  80121d:	75 ec                	jne    80120b <strlen+0x15>
		n++;
	return n;
  80121f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801222:	c9                   	leaveq 
  801223:	c3                   	retq   

0000000000801224 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801224:	55                   	push   %rbp
  801225:	48 89 e5             	mov    %rsp,%rbp
  801228:	48 83 ec 20          	sub    $0x20,%rsp
  80122c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801230:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801234:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80123b:	eb 0e                	jmp    80124b <strnlen+0x27>
		n++;
  80123d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801241:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801246:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80124b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801250:	74 0b                	je     80125d <strnlen+0x39>
  801252:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801256:	0f b6 00             	movzbl (%rax),%eax
  801259:	84 c0                	test   %al,%al
  80125b:	75 e0                	jne    80123d <strnlen+0x19>
		n++;
	return n;
  80125d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801260:	c9                   	leaveq 
  801261:	c3                   	retq   

0000000000801262 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801262:	55                   	push   %rbp
  801263:	48 89 e5             	mov    %rsp,%rbp
  801266:	48 83 ec 20          	sub    $0x20,%rsp
  80126a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80126e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801272:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801276:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80127a:	90                   	nop
  80127b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801283:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801287:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80128b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80128f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801293:	0f b6 12             	movzbl (%rdx),%edx
  801296:	88 10                	mov    %dl,(%rax)
  801298:	0f b6 00             	movzbl (%rax),%eax
  80129b:	84 c0                	test   %al,%al
  80129d:	75 dc                	jne    80127b <strcpy+0x19>
		/* do nothing */;
	return ret;
  80129f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012a3:	c9                   	leaveq 
  8012a4:	c3                   	retq   

00000000008012a5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012a5:	55                   	push   %rbp
  8012a6:	48 89 e5             	mov    %rsp,%rbp
  8012a9:	48 83 ec 20          	sub    $0x20,%rsp
  8012ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8012b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b9:	48 89 c7             	mov    %rax,%rdi
  8012bc:	48 b8 f6 11 80 00 00 	movabs $0x8011f6,%rax
  8012c3:	00 00 00 
  8012c6:	ff d0                	callq  *%rax
  8012c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8012cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012ce:	48 63 d0             	movslq %eax,%rdx
  8012d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d5:	48 01 c2             	add    %rax,%rdx
  8012d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012dc:	48 89 c6             	mov    %rax,%rsi
  8012df:	48 89 d7             	mov    %rdx,%rdi
  8012e2:	48 b8 62 12 80 00 00 	movabs $0x801262,%rax
  8012e9:	00 00 00 
  8012ec:	ff d0                	callq  *%rax
	return dst;
  8012ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012f2:	c9                   	leaveq 
  8012f3:	c3                   	retq   

00000000008012f4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012f4:	55                   	push   %rbp
  8012f5:	48 89 e5             	mov    %rsp,%rbp
  8012f8:	48 83 ec 28          	sub    $0x28,%rsp
  8012fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801300:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801304:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801308:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801310:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801317:	00 
  801318:	eb 2a                	jmp    801344 <strncpy+0x50>
		*dst++ = *src;
  80131a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801322:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801326:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80132a:	0f b6 12             	movzbl (%rdx),%edx
  80132d:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80132f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801333:	0f b6 00             	movzbl (%rax),%eax
  801336:	84 c0                	test   %al,%al
  801338:	74 05                	je     80133f <strncpy+0x4b>
			src++;
  80133a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80133f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801344:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801348:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80134c:	72 cc                	jb     80131a <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80134e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801352:	c9                   	leaveq 
  801353:	c3                   	retq   

0000000000801354 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801354:	55                   	push   %rbp
  801355:	48 89 e5             	mov    %rsp,%rbp
  801358:	48 83 ec 28          	sub    $0x28,%rsp
  80135c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801360:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801364:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801368:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801370:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801375:	74 3d                	je     8013b4 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801377:	eb 1d                	jmp    801396 <strlcpy+0x42>
			*dst++ = *src++;
  801379:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80137d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801381:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801385:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801389:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80138d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801391:	0f b6 12             	movzbl (%rdx),%edx
  801394:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801396:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80139b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013a0:	74 0b                	je     8013ad <strlcpy+0x59>
  8013a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013a6:	0f b6 00             	movzbl (%rax),%eax
  8013a9:	84 c0                	test   %al,%al
  8013ab:	75 cc                	jne    801379 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8013ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b1:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8013b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bc:	48 29 c2             	sub    %rax,%rdx
  8013bf:	48 89 d0             	mov    %rdx,%rax
}
  8013c2:	c9                   	leaveq 
  8013c3:	c3                   	retq   

00000000008013c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013c4:	55                   	push   %rbp
  8013c5:	48 89 e5             	mov    %rsp,%rbp
  8013c8:	48 83 ec 10          	sub    $0x10,%rsp
  8013cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8013d4:	eb 0a                	jmp    8013e0 <strcmp+0x1c>
		p++, q++;
  8013d6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013db:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e4:	0f b6 00             	movzbl (%rax),%eax
  8013e7:	84 c0                	test   %al,%al
  8013e9:	74 12                	je     8013fd <strcmp+0x39>
  8013eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ef:	0f b6 10             	movzbl (%rax),%edx
  8013f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f6:	0f b6 00             	movzbl (%rax),%eax
  8013f9:	38 c2                	cmp    %al,%dl
  8013fb:	74 d9                	je     8013d6 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801401:	0f b6 00             	movzbl (%rax),%eax
  801404:	0f b6 d0             	movzbl %al,%edx
  801407:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140b:	0f b6 00             	movzbl (%rax),%eax
  80140e:	0f b6 c0             	movzbl %al,%eax
  801411:	29 c2                	sub    %eax,%edx
  801413:	89 d0                	mov    %edx,%eax
}
  801415:	c9                   	leaveq 
  801416:	c3                   	retq   

0000000000801417 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801417:	55                   	push   %rbp
  801418:	48 89 e5             	mov    %rsp,%rbp
  80141b:	48 83 ec 18          	sub    $0x18,%rsp
  80141f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801423:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801427:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80142b:	eb 0f                	jmp    80143c <strncmp+0x25>
		n--, p++, q++;
  80142d:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801432:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801437:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80143c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801441:	74 1d                	je     801460 <strncmp+0x49>
  801443:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801447:	0f b6 00             	movzbl (%rax),%eax
  80144a:	84 c0                	test   %al,%al
  80144c:	74 12                	je     801460 <strncmp+0x49>
  80144e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801452:	0f b6 10             	movzbl (%rax),%edx
  801455:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801459:	0f b6 00             	movzbl (%rax),%eax
  80145c:	38 c2                	cmp    %al,%dl
  80145e:	74 cd                	je     80142d <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801460:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801465:	75 07                	jne    80146e <strncmp+0x57>
		return 0;
  801467:	b8 00 00 00 00       	mov    $0x0,%eax
  80146c:	eb 18                	jmp    801486 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80146e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801472:	0f b6 00             	movzbl (%rax),%eax
  801475:	0f b6 d0             	movzbl %al,%edx
  801478:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147c:	0f b6 00             	movzbl (%rax),%eax
  80147f:	0f b6 c0             	movzbl %al,%eax
  801482:	29 c2                	sub    %eax,%edx
  801484:	89 d0                	mov    %edx,%eax
}
  801486:	c9                   	leaveq 
  801487:	c3                   	retq   

0000000000801488 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801488:	55                   	push   %rbp
  801489:	48 89 e5             	mov    %rsp,%rbp
  80148c:	48 83 ec 0c          	sub    $0xc,%rsp
  801490:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801494:	89 f0                	mov    %esi,%eax
  801496:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801499:	eb 17                	jmp    8014b2 <strchr+0x2a>
		if (*s == c)
  80149b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149f:	0f b6 00             	movzbl (%rax),%eax
  8014a2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014a5:	75 06                	jne    8014ad <strchr+0x25>
			return (char *) s;
  8014a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ab:	eb 15                	jmp    8014c2 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014ad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b6:	0f b6 00             	movzbl (%rax),%eax
  8014b9:	84 c0                	test   %al,%al
  8014bb:	75 de                	jne    80149b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8014bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c2:	c9                   	leaveq 
  8014c3:	c3                   	retq   

00000000008014c4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014c4:	55                   	push   %rbp
  8014c5:	48 89 e5             	mov    %rsp,%rbp
  8014c8:	48 83 ec 0c          	sub    $0xc,%rsp
  8014cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014d0:	89 f0                	mov    %esi,%eax
  8014d2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014d5:	eb 13                	jmp    8014ea <strfind+0x26>
		if (*s == c)
  8014d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014db:	0f b6 00             	movzbl (%rax),%eax
  8014de:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014e1:	75 02                	jne    8014e5 <strfind+0x21>
			break;
  8014e3:	eb 10                	jmp    8014f5 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ee:	0f b6 00             	movzbl (%rax),%eax
  8014f1:	84 c0                	test   %al,%al
  8014f3:	75 e2                	jne    8014d7 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014f9:	c9                   	leaveq 
  8014fa:	c3                   	retq   

00000000008014fb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014fb:	55                   	push   %rbp
  8014fc:	48 89 e5             	mov    %rsp,%rbp
  8014ff:	48 83 ec 18          	sub    $0x18,%rsp
  801503:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801507:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80150a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80150e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801513:	75 06                	jne    80151b <memset+0x20>
		return v;
  801515:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801519:	eb 69                	jmp    801584 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80151b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151f:	83 e0 03             	and    $0x3,%eax
  801522:	48 85 c0             	test   %rax,%rax
  801525:	75 48                	jne    80156f <memset+0x74>
  801527:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80152b:	83 e0 03             	and    $0x3,%eax
  80152e:	48 85 c0             	test   %rax,%rax
  801531:	75 3c                	jne    80156f <memset+0x74>
		c &= 0xFF;
  801533:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80153a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80153d:	c1 e0 18             	shl    $0x18,%eax
  801540:	89 c2                	mov    %eax,%edx
  801542:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801545:	c1 e0 10             	shl    $0x10,%eax
  801548:	09 c2                	or     %eax,%edx
  80154a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80154d:	c1 e0 08             	shl    $0x8,%eax
  801550:	09 d0                	or     %edx,%eax
  801552:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801555:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801559:	48 c1 e8 02          	shr    $0x2,%rax
  80155d:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801560:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801564:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801567:	48 89 d7             	mov    %rdx,%rdi
  80156a:	fc                   	cld    
  80156b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80156d:	eb 11                	jmp    801580 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80156f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801573:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801576:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80157a:	48 89 d7             	mov    %rdx,%rdi
  80157d:	fc                   	cld    
  80157e:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801580:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801584:	c9                   	leaveq 
  801585:	c3                   	retq   

0000000000801586 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801586:	55                   	push   %rbp
  801587:	48 89 e5             	mov    %rsp,%rbp
  80158a:	48 83 ec 28          	sub    $0x28,%rsp
  80158e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801592:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801596:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80159a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80159e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8015a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8015aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ae:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015b2:	0f 83 88 00 00 00    	jae    801640 <memmove+0xba>
  8015b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015c0:	48 01 d0             	add    %rdx,%rax
  8015c3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015c7:	76 77                	jbe    801640 <memmove+0xba>
		s += n;
  8015c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cd:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8015d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015dd:	83 e0 03             	and    $0x3,%eax
  8015e0:	48 85 c0             	test   %rax,%rax
  8015e3:	75 3b                	jne    801620 <memmove+0x9a>
  8015e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e9:	83 e0 03             	and    $0x3,%eax
  8015ec:	48 85 c0             	test   %rax,%rax
  8015ef:	75 2f                	jne    801620 <memmove+0x9a>
  8015f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f5:	83 e0 03             	and    $0x3,%eax
  8015f8:	48 85 c0             	test   %rax,%rax
  8015fb:	75 23                	jne    801620 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801601:	48 83 e8 04          	sub    $0x4,%rax
  801605:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801609:	48 83 ea 04          	sub    $0x4,%rdx
  80160d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801611:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801615:	48 89 c7             	mov    %rax,%rdi
  801618:	48 89 d6             	mov    %rdx,%rsi
  80161b:	fd                   	std    
  80161c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80161e:	eb 1d                	jmp    80163d <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801620:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801624:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801628:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801630:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801634:	48 89 d7             	mov    %rdx,%rdi
  801637:	48 89 c1             	mov    %rax,%rcx
  80163a:	fd                   	std    
  80163b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80163d:	fc                   	cld    
  80163e:	eb 57                	jmp    801697 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801640:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801644:	83 e0 03             	and    $0x3,%eax
  801647:	48 85 c0             	test   %rax,%rax
  80164a:	75 36                	jne    801682 <memmove+0xfc>
  80164c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801650:	83 e0 03             	and    $0x3,%eax
  801653:	48 85 c0             	test   %rax,%rax
  801656:	75 2a                	jne    801682 <memmove+0xfc>
  801658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165c:	83 e0 03             	and    $0x3,%eax
  80165f:	48 85 c0             	test   %rax,%rax
  801662:	75 1e                	jne    801682 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801664:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801668:	48 c1 e8 02          	shr    $0x2,%rax
  80166c:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80166f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801673:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801677:	48 89 c7             	mov    %rax,%rdi
  80167a:	48 89 d6             	mov    %rdx,%rsi
  80167d:	fc                   	cld    
  80167e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801680:	eb 15                	jmp    801697 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801682:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801686:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80168a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80168e:	48 89 c7             	mov    %rax,%rdi
  801691:	48 89 d6             	mov    %rdx,%rsi
  801694:	fc                   	cld    
  801695:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80169b:	c9                   	leaveq 
  80169c:	c3                   	retq   

000000000080169d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80169d:	55                   	push   %rbp
  80169e:	48 89 e5             	mov    %rsp,%rbp
  8016a1:	48 83 ec 18          	sub    $0x18,%rsp
  8016a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8016ad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8016b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016b5:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8016b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016bd:	48 89 ce             	mov    %rcx,%rsi
  8016c0:	48 89 c7             	mov    %rax,%rdi
  8016c3:	48 b8 86 15 80 00 00 	movabs $0x801586,%rax
  8016ca:	00 00 00 
  8016cd:	ff d0                	callq  *%rax
}
  8016cf:	c9                   	leaveq 
  8016d0:	c3                   	retq   

00000000008016d1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8016d1:	55                   	push   %rbp
  8016d2:	48 89 e5             	mov    %rsp,%rbp
  8016d5:	48 83 ec 28          	sub    $0x28,%rsp
  8016d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8016e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8016ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016f1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016f5:	eb 36                	jmp    80172d <memcmp+0x5c>
		if (*s1 != *s2)
  8016f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016fb:	0f b6 10             	movzbl (%rax),%edx
  8016fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801702:	0f b6 00             	movzbl (%rax),%eax
  801705:	38 c2                	cmp    %al,%dl
  801707:	74 1a                	je     801723 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801709:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80170d:	0f b6 00             	movzbl (%rax),%eax
  801710:	0f b6 d0             	movzbl %al,%edx
  801713:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801717:	0f b6 00             	movzbl (%rax),%eax
  80171a:	0f b6 c0             	movzbl %al,%eax
  80171d:	29 c2                	sub    %eax,%edx
  80171f:	89 d0                	mov    %edx,%eax
  801721:	eb 20                	jmp    801743 <memcmp+0x72>
		s1++, s2++;
  801723:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801728:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80172d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801731:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801735:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801739:	48 85 c0             	test   %rax,%rax
  80173c:	75 b9                	jne    8016f7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801743:	c9                   	leaveq 
  801744:	c3                   	retq   

0000000000801745 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801745:	55                   	push   %rbp
  801746:	48 89 e5             	mov    %rsp,%rbp
  801749:	48 83 ec 28          	sub    $0x28,%rsp
  80174d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801751:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801754:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801758:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801760:	48 01 d0             	add    %rdx,%rax
  801763:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801767:	eb 15                	jmp    80177e <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801769:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80176d:	0f b6 10             	movzbl (%rax),%edx
  801770:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801773:	38 c2                	cmp    %al,%dl
  801775:	75 02                	jne    801779 <memfind+0x34>
			break;
  801777:	eb 0f                	jmp    801788 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801779:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80177e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801782:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801786:	72 e1                	jb     801769 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80178c:	c9                   	leaveq 
  80178d:	c3                   	retq   

000000000080178e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80178e:	55                   	push   %rbp
  80178f:	48 89 e5             	mov    %rsp,%rbp
  801792:	48 83 ec 34          	sub    $0x34,%rsp
  801796:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80179a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80179e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8017a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8017a8:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8017af:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b0:	eb 05                	jmp    8017b7 <strtol+0x29>
		s++;
  8017b2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bb:	0f b6 00             	movzbl (%rax),%eax
  8017be:	3c 20                	cmp    $0x20,%al
  8017c0:	74 f0                	je     8017b2 <strtol+0x24>
  8017c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c6:	0f b6 00             	movzbl (%rax),%eax
  8017c9:	3c 09                	cmp    $0x9,%al
  8017cb:	74 e5                	je     8017b2 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d1:	0f b6 00             	movzbl (%rax),%eax
  8017d4:	3c 2b                	cmp    $0x2b,%al
  8017d6:	75 07                	jne    8017df <strtol+0x51>
		s++;
  8017d8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017dd:	eb 17                	jmp    8017f6 <strtol+0x68>
	else if (*s == '-')
  8017df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e3:	0f b6 00             	movzbl (%rax),%eax
  8017e6:	3c 2d                	cmp    $0x2d,%al
  8017e8:	75 0c                	jne    8017f6 <strtol+0x68>
		s++, neg = 1;
  8017ea:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017ef:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017f6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017fa:	74 06                	je     801802 <strtol+0x74>
  8017fc:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801800:	75 28                	jne    80182a <strtol+0x9c>
  801802:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801806:	0f b6 00             	movzbl (%rax),%eax
  801809:	3c 30                	cmp    $0x30,%al
  80180b:	75 1d                	jne    80182a <strtol+0x9c>
  80180d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801811:	48 83 c0 01          	add    $0x1,%rax
  801815:	0f b6 00             	movzbl (%rax),%eax
  801818:	3c 78                	cmp    $0x78,%al
  80181a:	75 0e                	jne    80182a <strtol+0x9c>
		s += 2, base = 16;
  80181c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801821:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801828:	eb 2c                	jmp    801856 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80182a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80182e:	75 19                	jne    801849 <strtol+0xbb>
  801830:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801834:	0f b6 00             	movzbl (%rax),%eax
  801837:	3c 30                	cmp    $0x30,%al
  801839:	75 0e                	jne    801849 <strtol+0xbb>
		s++, base = 8;
  80183b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801840:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801847:	eb 0d                	jmp    801856 <strtol+0xc8>
	else if (base == 0)
  801849:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80184d:	75 07                	jne    801856 <strtol+0xc8>
		base = 10;
  80184f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801856:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185a:	0f b6 00             	movzbl (%rax),%eax
  80185d:	3c 2f                	cmp    $0x2f,%al
  80185f:	7e 1d                	jle    80187e <strtol+0xf0>
  801861:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801865:	0f b6 00             	movzbl (%rax),%eax
  801868:	3c 39                	cmp    $0x39,%al
  80186a:	7f 12                	jg     80187e <strtol+0xf0>
			dig = *s - '0';
  80186c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801870:	0f b6 00             	movzbl (%rax),%eax
  801873:	0f be c0             	movsbl %al,%eax
  801876:	83 e8 30             	sub    $0x30,%eax
  801879:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80187c:	eb 4e                	jmp    8018cc <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80187e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801882:	0f b6 00             	movzbl (%rax),%eax
  801885:	3c 60                	cmp    $0x60,%al
  801887:	7e 1d                	jle    8018a6 <strtol+0x118>
  801889:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188d:	0f b6 00             	movzbl (%rax),%eax
  801890:	3c 7a                	cmp    $0x7a,%al
  801892:	7f 12                	jg     8018a6 <strtol+0x118>
			dig = *s - 'a' + 10;
  801894:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801898:	0f b6 00             	movzbl (%rax),%eax
  80189b:	0f be c0             	movsbl %al,%eax
  80189e:	83 e8 57             	sub    $0x57,%eax
  8018a1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018a4:	eb 26                	jmp    8018cc <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8018a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018aa:	0f b6 00             	movzbl (%rax),%eax
  8018ad:	3c 40                	cmp    $0x40,%al
  8018af:	7e 48                	jle    8018f9 <strtol+0x16b>
  8018b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b5:	0f b6 00             	movzbl (%rax),%eax
  8018b8:	3c 5a                	cmp    $0x5a,%al
  8018ba:	7f 3d                	jg     8018f9 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8018bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c0:	0f b6 00             	movzbl (%rax),%eax
  8018c3:	0f be c0             	movsbl %al,%eax
  8018c6:	83 e8 37             	sub    $0x37,%eax
  8018c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8018cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018cf:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8018d2:	7c 02                	jl     8018d6 <strtol+0x148>
			break;
  8018d4:	eb 23                	jmp    8018f9 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8018d6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018db:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8018de:	48 98                	cltq   
  8018e0:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8018e5:	48 89 c2             	mov    %rax,%rdx
  8018e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018eb:	48 98                	cltq   
  8018ed:	48 01 d0             	add    %rdx,%rax
  8018f0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018f4:	e9 5d ff ff ff       	jmpq   801856 <strtol+0xc8>

	if (endptr)
  8018f9:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018fe:	74 0b                	je     80190b <strtol+0x17d>
		*endptr = (char *) s;
  801900:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801904:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801908:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80190b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80190f:	74 09                	je     80191a <strtol+0x18c>
  801911:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801915:	48 f7 d8             	neg    %rax
  801918:	eb 04                	jmp    80191e <strtol+0x190>
  80191a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80191e:	c9                   	leaveq 
  80191f:	c3                   	retq   

0000000000801920 <strstr>:

char * strstr(const char *in, const char *str)
{
  801920:	55                   	push   %rbp
  801921:	48 89 e5             	mov    %rsp,%rbp
  801924:	48 83 ec 30          	sub    $0x30,%rsp
  801928:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80192c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801930:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801934:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801938:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80193c:	0f b6 00             	movzbl (%rax),%eax
  80193f:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801942:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801946:	75 06                	jne    80194e <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801948:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194c:	eb 6b                	jmp    8019b9 <strstr+0x99>

    len = strlen(str);
  80194e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801952:	48 89 c7             	mov    %rax,%rdi
  801955:	48 b8 f6 11 80 00 00 	movabs $0x8011f6,%rax
  80195c:	00 00 00 
  80195f:	ff d0                	callq  *%rax
  801961:	48 98                	cltq   
  801963:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801967:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80196f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801973:	0f b6 00             	movzbl (%rax),%eax
  801976:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801979:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80197d:	75 07                	jne    801986 <strstr+0x66>
                return (char *) 0;
  80197f:	b8 00 00 00 00       	mov    $0x0,%eax
  801984:	eb 33                	jmp    8019b9 <strstr+0x99>
        } while (sc != c);
  801986:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80198a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80198d:	75 d8                	jne    801967 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  80198f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801993:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801997:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199b:	48 89 ce             	mov    %rcx,%rsi
  80199e:	48 89 c7             	mov    %rax,%rdi
  8019a1:	48 b8 17 14 80 00 00 	movabs $0x801417,%rax
  8019a8:	00 00 00 
  8019ab:	ff d0                	callq  *%rax
  8019ad:	85 c0                	test   %eax,%eax
  8019af:	75 b6                	jne    801967 <strstr+0x47>

    return (char *) (in - 1);
  8019b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b5:	48 83 e8 01          	sub    $0x1,%rax
}
  8019b9:	c9                   	leaveq 
  8019ba:	c3                   	retq   

00000000008019bb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8019bb:	55                   	push   %rbp
  8019bc:	48 89 e5             	mov    %rsp,%rbp
  8019bf:	53                   	push   %rbx
  8019c0:	48 83 ec 48          	sub    $0x48,%rsp
  8019c4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8019c7:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8019ca:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019ce:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8019d2:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8019d6:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019da:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019dd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8019e1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8019e5:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8019e9:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8019ed:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019f1:	4c 89 c3             	mov    %r8,%rbx
  8019f4:	cd 30                	int    $0x30
  8019f6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  8019fa:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019fe:	74 3e                	je     801a3e <syscall+0x83>
  801a00:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a05:	7e 37                	jle    801a3e <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a0b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a0e:	49 89 d0             	mov    %rdx,%r8
  801a11:	89 c1                	mov    %eax,%ecx
  801a13:	48 ba 60 41 80 00 00 	movabs $0x804160,%rdx
  801a1a:	00 00 00 
  801a1d:	be 23 00 00 00       	mov    $0x23,%esi
  801a22:	48 bf 7d 41 80 00 00 	movabs $0x80417d,%rdi
  801a29:	00 00 00 
  801a2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a31:	49 b9 81 02 80 00 00 	movabs $0x800281,%r9
  801a38:	00 00 00 
  801a3b:	41 ff d1             	callq  *%r9

	return ret;
  801a3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a42:	48 83 c4 48          	add    $0x48,%rsp
  801a46:	5b                   	pop    %rbx
  801a47:	5d                   	pop    %rbp
  801a48:	c3                   	retq   

0000000000801a49 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a49:	55                   	push   %rbp
  801a4a:	48 89 e5             	mov    %rsp,%rbp
  801a4d:	48 83 ec 20          	sub    $0x20,%rsp
  801a51:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a55:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a61:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a68:	00 
  801a69:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a6f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a75:	48 89 d1             	mov    %rdx,%rcx
  801a78:	48 89 c2             	mov    %rax,%rdx
  801a7b:	be 00 00 00 00       	mov    $0x0,%esi
  801a80:	bf 00 00 00 00       	mov    $0x0,%edi
  801a85:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801a8c:	00 00 00 
  801a8f:	ff d0                	callq  *%rax
}
  801a91:	c9                   	leaveq 
  801a92:	c3                   	retq   

0000000000801a93 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a93:	55                   	push   %rbp
  801a94:	48 89 e5             	mov    %rsp,%rbp
  801a97:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a9b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa2:	00 
  801aa3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aaf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab9:	be 00 00 00 00       	mov    $0x0,%esi
  801abe:	bf 01 00 00 00       	mov    $0x1,%edi
  801ac3:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801aca:	00 00 00 
  801acd:	ff d0                	callq  *%rax
}
  801acf:	c9                   	leaveq 
  801ad0:	c3                   	retq   

0000000000801ad1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801ad1:	55                   	push   %rbp
  801ad2:	48 89 e5             	mov    %rsp,%rbp
  801ad5:	48 83 ec 10          	sub    $0x10,%rsp
  801ad9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801adc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801adf:	48 98                	cltq   
  801ae1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae8:	00 
  801ae9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801afa:	48 89 c2             	mov    %rax,%rdx
  801afd:	be 01 00 00 00       	mov    $0x1,%esi
  801b02:	bf 03 00 00 00       	mov    $0x3,%edi
  801b07:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801b0e:	00 00 00 
  801b11:	ff d0                	callq  *%rax
}
  801b13:	c9                   	leaveq 
  801b14:	c3                   	retq   

0000000000801b15 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801b15:	55                   	push   %rbp
  801b16:	48 89 e5             	mov    %rsp,%rbp
  801b19:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801b1d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b24:	00 
  801b25:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b2b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b31:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b36:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3b:	be 00 00 00 00       	mov    $0x0,%esi
  801b40:	bf 02 00 00 00       	mov    $0x2,%edi
  801b45:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801b4c:	00 00 00 
  801b4f:	ff d0                	callq  *%rax
}
  801b51:	c9                   	leaveq 
  801b52:	c3                   	retq   

0000000000801b53 <sys_yield>:

void
sys_yield(void)
{
  801b53:	55                   	push   %rbp
  801b54:	48 89 e5             	mov    %rsp,%rbp
  801b57:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b5b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b62:	00 
  801b63:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b69:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b6f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b74:	ba 00 00 00 00       	mov    $0x0,%edx
  801b79:	be 00 00 00 00       	mov    $0x0,%esi
  801b7e:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b83:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801b8a:	00 00 00 
  801b8d:	ff d0                	callq  *%rax
}
  801b8f:	c9                   	leaveq 
  801b90:	c3                   	retq   

0000000000801b91 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b91:	55                   	push   %rbp
  801b92:	48 89 e5             	mov    %rsp,%rbp
  801b95:	48 83 ec 20          	sub    $0x20,%rsp
  801b99:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b9c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ba0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ba3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ba6:	48 63 c8             	movslq %eax,%rcx
  801ba9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb0:	48 98                	cltq   
  801bb2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb9:	00 
  801bba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc0:	49 89 c8             	mov    %rcx,%r8
  801bc3:	48 89 d1             	mov    %rdx,%rcx
  801bc6:	48 89 c2             	mov    %rax,%rdx
  801bc9:	be 01 00 00 00       	mov    $0x1,%esi
  801bce:	bf 04 00 00 00       	mov    $0x4,%edi
  801bd3:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801bda:	00 00 00 
  801bdd:	ff d0                	callq  *%rax
}
  801bdf:	c9                   	leaveq 
  801be0:	c3                   	retq   

0000000000801be1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801be1:	55                   	push   %rbp
  801be2:	48 89 e5             	mov    %rsp,%rbp
  801be5:	48 83 ec 30          	sub    $0x30,%rsp
  801be9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bf0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bf3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bf7:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bfb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bfe:	48 63 c8             	movslq %eax,%rcx
  801c01:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c05:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c08:	48 63 f0             	movslq %eax,%rsi
  801c0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c12:	48 98                	cltq   
  801c14:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c18:	49 89 f9             	mov    %rdi,%r9
  801c1b:	49 89 f0             	mov    %rsi,%r8
  801c1e:	48 89 d1             	mov    %rdx,%rcx
  801c21:	48 89 c2             	mov    %rax,%rdx
  801c24:	be 01 00 00 00       	mov    $0x1,%esi
  801c29:	bf 05 00 00 00       	mov    $0x5,%edi
  801c2e:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801c35:	00 00 00 
  801c38:	ff d0                	callq  *%rax
}
  801c3a:	c9                   	leaveq 
  801c3b:	c3                   	retq   

0000000000801c3c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c3c:	55                   	push   %rbp
  801c3d:	48 89 e5             	mov    %rsp,%rbp
  801c40:	48 83 ec 20          	sub    $0x20,%rsp
  801c44:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c52:	48 98                	cltq   
  801c54:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c5b:	00 
  801c5c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c62:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c68:	48 89 d1             	mov    %rdx,%rcx
  801c6b:	48 89 c2             	mov    %rax,%rdx
  801c6e:	be 01 00 00 00       	mov    $0x1,%esi
  801c73:	bf 06 00 00 00       	mov    $0x6,%edi
  801c78:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801c7f:	00 00 00 
  801c82:	ff d0                	callq  *%rax
}
  801c84:	c9                   	leaveq 
  801c85:	c3                   	retq   

0000000000801c86 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c86:	55                   	push   %rbp
  801c87:	48 89 e5             	mov    %rsp,%rbp
  801c8a:	48 83 ec 10          	sub    $0x10,%rsp
  801c8e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c91:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c94:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c97:	48 63 d0             	movslq %eax,%rdx
  801c9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c9d:	48 98                	cltq   
  801c9f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca6:	00 
  801ca7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb3:	48 89 d1             	mov    %rdx,%rcx
  801cb6:	48 89 c2             	mov    %rax,%rdx
  801cb9:	be 01 00 00 00       	mov    $0x1,%esi
  801cbe:	bf 08 00 00 00       	mov    $0x8,%edi
  801cc3:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801cca:	00 00 00 
  801ccd:	ff d0                	callq  *%rax
}
  801ccf:	c9                   	leaveq 
  801cd0:	c3                   	retq   

0000000000801cd1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801cd1:	55                   	push   %rbp
  801cd2:	48 89 e5             	mov    %rsp,%rbp
  801cd5:	48 83 ec 20          	sub    $0x20,%rsp
  801cd9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cdc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ce0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce7:	48 98                	cltq   
  801ce9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf0:	00 
  801cf1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cfd:	48 89 d1             	mov    %rdx,%rcx
  801d00:	48 89 c2             	mov    %rax,%rdx
  801d03:	be 01 00 00 00       	mov    $0x1,%esi
  801d08:	bf 09 00 00 00       	mov    $0x9,%edi
  801d0d:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801d14:	00 00 00 
  801d17:	ff d0                	callq  *%rax
}
  801d19:	c9                   	leaveq 
  801d1a:	c3                   	retq   

0000000000801d1b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801d1b:	55                   	push   %rbp
  801d1c:	48 89 e5             	mov    %rsp,%rbp
  801d1f:	48 83 ec 20          	sub    $0x20,%rsp
  801d23:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d26:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801d2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d31:	48 98                	cltq   
  801d33:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d3a:	00 
  801d3b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d41:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d47:	48 89 d1             	mov    %rdx,%rcx
  801d4a:	48 89 c2             	mov    %rax,%rdx
  801d4d:	be 01 00 00 00       	mov    $0x1,%esi
  801d52:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d57:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801d5e:	00 00 00 
  801d61:	ff d0                	callq  *%rax
}
  801d63:	c9                   	leaveq 
  801d64:	c3                   	retq   

0000000000801d65 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d65:	55                   	push   %rbp
  801d66:	48 89 e5             	mov    %rsp,%rbp
  801d69:	48 83 ec 20          	sub    $0x20,%rsp
  801d6d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d70:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d74:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d78:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d7e:	48 63 f0             	movslq %eax,%rsi
  801d81:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d88:	48 98                	cltq   
  801d8a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d8e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d95:	00 
  801d96:	49 89 f1             	mov    %rsi,%r9
  801d99:	49 89 c8             	mov    %rcx,%r8
  801d9c:	48 89 d1             	mov    %rdx,%rcx
  801d9f:	48 89 c2             	mov    %rax,%rdx
  801da2:	be 00 00 00 00       	mov    $0x0,%esi
  801da7:	bf 0c 00 00 00       	mov    $0xc,%edi
  801dac:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801db3:	00 00 00 
  801db6:	ff d0                	callq  *%rax
}
  801db8:	c9                   	leaveq 
  801db9:	c3                   	retq   

0000000000801dba <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801dba:	55                   	push   %rbp
  801dbb:	48 89 e5             	mov    %rsp,%rbp
  801dbe:	48 83 ec 10          	sub    $0x10,%rsp
  801dc2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801dc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dd1:	00 
  801dd2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dd8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dde:	b9 00 00 00 00       	mov    $0x0,%ecx
  801de3:	48 89 c2             	mov    %rax,%rdx
  801de6:	be 01 00 00 00       	mov    $0x1,%esi
  801deb:	bf 0d 00 00 00       	mov    $0xd,%edi
  801df0:	48 b8 bb 19 80 00 00 	movabs $0x8019bb,%rax
  801df7:	00 00 00 
  801dfa:	ff d0                	callq  *%rax
}
  801dfc:	c9                   	leaveq 
  801dfd:	c3                   	retq   

0000000000801dfe <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801dfe:	55                   	push   %rbp
  801dff:	48 89 e5             	mov    %rsp,%rbp
  801e02:	48 83 ec 30          	sub    $0x30,%rsp
  801e06:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e0e:	48 8b 00             	mov    (%rax),%rax
  801e11:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801e15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e19:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e1d:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)))
  801e20:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e23:	83 e0 02             	and    $0x2,%eax
  801e26:	85 c0                	test   %eax,%eax
  801e28:	74 23                	je     801e4d <pgfault+0x4f>
  801e2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e2e:	48 c1 e8 0c          	shr    $0xc,%rax
  801e32:	48 89 c2             	mov    %rax,%rdx
  801e35:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e3c:	01 00 00 
  801e3f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e43:	25 00 08 00 00       	and    $0x800,%eax
  801e48:	48 85 c0             	test   %rax,%rax
  801e4b:	75 2a                	jne    801e77 <pgfault+0x79>
		panic("fail check at fork pgfault");
  801e4d:	48 ba 8b 41 80 00 00 	movabs $0x80418b,%rdx
  801e54:	00 00 00 
  801e57:	be 1d 00 00 00       	mov    $0x1d,%esi
  801e5c:	48 bf a6 41 80 00 00 	movabs $0x8041a6,%rdi
  801e63:	00 00 00 
  801e66:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6b:	48 b9 81 02 80 00 00 	movabs $0x800281,%rcx
  801e72:	00 00 00 
  801e75:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801e77:	ba 07 00 00 00       	mov    $0x7,%edx
  801e7c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e81:	bf 00 00 00 00       	mov    $0x0,%edi
  801e86:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  801e8d:	00 00 00 
  801e90:	ff d0                	callq  *%rax

	addr = ROUNDDOWN(addr, PGSIZE);
  801e92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e96:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801e9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e9e:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801ea4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memmove(PFTEMP, addr, PGSIZE);
  801ea8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eac:	ba 00 10 00 00       	mov    $0x1000,%edx
  801eb1:	48 89 c6             	mov    %rax,%rsi
  801eb4:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801eb9:	48 b8 86 15 80 00 00 	movabs $0x801586,%rax
  801ec0:	00 00 00 
  801ec3:	ff d0                	callq  *%rax

	sys_page_map(0, (void *)PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W);
  801ec5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ec9:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801ecf:	48 89 c1             	mov    %rax,%rcx
  801ed2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801edc:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee1:	48 b8 e1 1b 80 00 00 	movabs $0x801be1,%rax
  801ee8:	00 00 00 
  801eeb:	ff d0                	callq  *%rax
	sys_page_unmap(0, PFTEMP);
  801eed:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ef2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef7:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  801efe:	00 00 00 
  801f01:	ff d0                	callq  *%rax
	//panic("pgfault not implemented");
}
  801f03:	c9                   	leaveq 
  801f04:	c3                   	retq   

0000000000801f05 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801f05:	55                   	push   %rbp
  801f06:	48 89 e5             	mov    %rsp,%rbp
  801f09:	48 83 ec 20          	sub    $0x20,%rsp
  801f0d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f10:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uintptr_t)pn * PGSIZE);
  801f13:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f16:	48 c1 e0 0c          	shl    $0xc,%rax
  801f1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	// note: modified for LAB 5, supporting PTE_SHARE
	if (uvpt[pn] & PTE_SHARE) {
  801f1e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f25:	01 00 00 
  801f28:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f2b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f2f:	25 00 04 00 00       	and    $0x400,%eax
  801f34:	48 85 c0             	test   %rax,%rax
  801f37:	74 55                	je     801f8e <duppage+0x89>
		if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL))) < 0)
  801f39:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f40:	01 00 00 
  801f43:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f46:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f4a:	25 07 0e 00 00       	and    $0xe07,%eax
  801f4f:	89 c6                	mov    %eax,%esi
  801f51:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801f55:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f5c:	41 89 f0             	mov    %esi,%r8d
  801f5f:	48 89 c6             	mov    %rax,%rsi
  801f62:	bf 00 00 00 00       	mov    $0x0,%edi
  801f67:	48 b8 e1 1b 80 00 00 	movabs $0x801be1,%rax
  801f6e:	00 00 00 
  801f71:	ff d0                	callq  *%rax
  801f73:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801f76:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f7a:	79 08                	jns    801f84 <duppage+0x7f>
			return r;
  801f7c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f7f:	e9 e1 00 00 00       	jmpq   802065 <duppage+0x160>
		return 0;
  801f84:	b8 00 00 00 00       	mov    $0x0,%eax
  801f89:	e9 d7 00 00 00       	jmpq   802065 <duppage+0x160>
	}

	// note: here we must set ~PTE_W and PTE_COW such that parent process can get correct pid
	if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  801f8e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f95:	01 00 00 
  801f98:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f9b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f9f:	25 05 06 00 00       	and    $0x605,%eax
  801fa4:	80 cc 08             	or     $0x8,%ah
  801fa7:	89 c6                	mov    %eax,%esi
  801fa9:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801fad:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb4:	41 89 f0             	mov    %esi,%r8d
  801fb7:	48 89 c6             	mov    %rax,%rsi
  801fba:	bf 00 00 00 00       	mov    $0x0,%edi
  801fbf:	48 b8 e1 1b 80 00 00 	movabs $0x801be1,%rax
  801fc6:	00 00 00 
  801fc9:	ff d0                	callq  *%rax
  801fcb:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801fce:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801fd2:	79 08                	jns    801fdc <duppage+0xd7>
		return r;
  801fd4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fd7:	e9 89 00 00 00       	jmpq   802065 <duppage+0x160>

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  801fdc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fe3:	01 00 00 
  801fe6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801fe9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fed:	83 e0 02             	and    $0x2,%eax
  801ff0:	48 85 c0             	test   %rax,%rax
  801ff3:	75 1b                	jne    802010 <duppage+0x10b>
  801ff5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ffc:	01 00 00 
  801fff:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802002:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802006:	25 00 08 00 00       	and    $0x800,%eax
  80200b:	48 85 c0             	test   %rax,%rax
  80200e:	74 50                	je     802060 <duppage+0x15b>
		if ((r = sys_page_map(0, addr, 0, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  802010:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802017:	01 00 00 
  80201a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80201d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802021:	25 05 06 00 00       	and    $0x605,%eax
  802026:	80 cc 08             	or     $0x8,%ah
  802029:	89 c1                	mov    %eax,%ecx
  80202b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80202f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802033:	41 89 c8             	mov    %ecx,%r8d
  802036:	48 89 d1             	mov    %rdx,%rcx
  802039:	ba 00 00 00 00       	mov    $0x0,%edx
  80203e:	48 89 c6             	mov    %rax,%rsi
  802041:	bf 00 00 00 00       	mov    $0x0,%edi
  802046:	48 b8 e1 1b 80 00 00 	movabs $0x801be1,%rax
  80204d:	00 00 00 
  802050:	ff d0                	callq  *%rax
  802052:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802055:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802059:	79 05                	jns    802060 <duppage+0x15b>
			return r;
  80205b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80205e:	eb 05                	jmp    802065 <duppage+0x160>
	//panic("duppage not implemented");
	return 0;
  802060:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802065:	c9                   	leaveq 
  802066:	c3                   	retq   

0000000000802067 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802067:	55                   	push   %rbp
  802068:	48 89 e5             	mov    %rsp,%rbp
  80206b:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	int r;
	envid_t envid;
	int i, j, k, l, ptx = 0;
  80206f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	set_pgfault_handler(pgfault);
  802076:	48 bf fe 1d 80 00 00 	movabs $0x801dfe,%rdi
  80207d:	00 00 00 
  802080:	48 b8 e0 3a 80 00 00 	movabs $0x803ae0,%rax
  802087:	00 00 00 
  80208a:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80208c:	b8 07 00 00 00       	mov    $0x7,%eax
  802091:	cd 30                	int    $0x30
  802093:	89 45 e0             	mov    %eax,-0x20(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802096:	8b 45 e0             	mov    -0x20(%rbp),%eax

	if ((envid = sys_exofork()) < 0)
  802099:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80209c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8020a0:	79 08                	jns    8020aa <fork+0x43>
		return envid;
  8020a2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020a5:	e9 27 02 00 00       	jmpq   8022d1 <fork+0x26a>
	else if (envid == 0) {
  8020aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8020ae:	75 46                	jne    8020f6 <fork+0x8f>
		thisenv = &envs[ENVX(sys_getenvid())];
  8020b0:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  8020b7:	00 00 00 
  8020ba:	ff d0                	callq  *%rax
  8020bc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8020c1:	48 63 d0             	movslq %eax,%rdx
  8020c4:	48 89 d0             	mov    %rdx,%rax
  8020c7:	48 c1 e0 03          	shl    $0x3,%rax
  8020cb:	48 01 d0             	add    %rdx,%rax
  8020ce:	48 c1 e0 05          	shl    $0x5,%rax
  8020d2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8020d9:	00 00 00 
  8020dc:	48 01 c2             	add    %rax,%rdx
  8020df:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8020e6:	00 00 00 
  8020e9:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8020ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f1:	e9 db 01 00 00       	jmpq   8022d1 <fork+0x26a>
	}

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8020f6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020f9:	ba 07 00 00 00       	mov    $0x7,%edx
  8020fe:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802103:	89 c7                	mov    %eax,%edi
  802105:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  80210c:	00 00 00 
  80210f:	ff d0                	callq  *%rax
  802111:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802114:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802118:	79 08                	jns    802122 <fork+0xbb>
		return r;
  80211a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80211d:	e9 af 01 00 00       	jmpq   8022d1 <fork+0x26a>

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  802122:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802129:	e9 49 01 00 00       	jmpq   802277 <fork+0x210>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  80212e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802131:	8d 90 ff ff ff 07    	lea    0x7ffffff(%rax),%edx
  802137:	85 c0                	test   %eax,%eax
  802139:	0f 48 c2             	cmovs  %edx,%eax
  80213c:	c1 f8 1b             	sar    $0x1b,%eax
  80213f:	89 c2                	mov    %eax,%edx
  802141:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802148:	01 00 00 
  80214b:	48 63 d2             	movslq %edx,%rdx
  80214e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802152:	83 e0 01             	and    $0x1,%eax
  802155:	48 85 c0             	test   %rax,%rax
  802158:	75 0c                	jne    802166 <fork+0xff>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  80215a:	81 45 ec 00 00 00 08 	addl   $0x8000000,-0x14(%rbp)
			continue;
  802161:	e9 0d 01 00 00       	jmpq   802273 <fork+0x20c>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  802166:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  80216d:	e9 f4 00 00 00       	jmpq   802266 <fork+0x1ff>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  802172:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802175:	8d 90 ff ff 03 00    	lea    0x3ffff(%rax),%edx
  80217b:	85 c0                	test   %eax,%eax
  80217d:	0f 48 c2             	cmovs  %edx,%eax
  802180:	c1 f8 12             	sar    $0x12,%eax
  802183:	89 c2                	mov    %eax,%edx
  802185:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80218c:	01 00 00 
  80218f:	48 63 d2             	movslq %edx,%rdx
  802192:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802196:	83 e0 01             	and    $0x1,%eax
  802199:	48 85 c0             	test   %rax,%rax
  80219c:	75 0c                	jne    8021aa <fork+0x143>
				ptx += NPDENTRIES * NPTENTRIES;
  80219e:	81 45 ec 00 00 04 00 	addl   $0x40000,-0x14(%rbp)
				continue;
  8021a5:	e9 b8 00 00 00       	jmpq   802262 <fork+0x1fb>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  8021aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8021b1:	e9 9f 00 00 00       	jmpq   802255 <fork+0x1ee>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  8021b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021b9:	8d 90 ff 01 00 00    	lea    0x1ff(%rax),%edx
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	0f 48 c2             	cmovs  %edx,%eax
  8021c4:	c1 f8 09             	sar    $0x9,%eax
  8021c7:	89 c2                	mov    %eax,%edx
  8021c9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021d0:	01 00 00 
  8021d3:	48 63 d2             	movslq %edx,%rdx
  8021d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021da:	83 e0 01             	and    $0x1,%eax
  8021dd:	48 85 c0             	test   %rax,%rax
  8021e0:	75 09                	jne    8021eb <fork+0x184>
					ptx += NPTENTRIES;
  8021e2:	81 45 ec 00 02 00 00 	addl   $0x200,-0x14(%rbp)
					continue;
  8021e9:	eb 66                	jmp    802251 <fork+0x1ea>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  8021eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8021f2:	eb 54                	jmp    802248 <fork+0x1e1>
					if ((uvpt[ptx] & PTE_P) != 0)
  8021f4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021fb:	01 00 00 
  8021fe:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802201:	48 63 d2             	movslq %edx,%rdx
  802204:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802208:	83 e0 01             	and    $0x1,%eax
  80220b:	48 85 c0             	test   %rax,%rax
  80220e:	74 30                	je     802240 <fork+0x1d9>
						if (ptx != VPN(UXSTACKTOP - PGSIZE))
  802210:	81 7d ec ff f7 0e 00 	cmpl   $0xef7ff,-0x14(%rbp)
  802217:	74 27                	je     802240 <fork+0x1d9>
							if ((r = duppage(envid, ptx)) < 0)
  802219:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80221c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80221f:	89 d6                	mov    %edx,%esi
  802221:	89 c7                	mov    %eax,%edi
  802223:	48 b8 05 1f 80 00 00 	movabs $0x801f05,%rax
  80222a:	00 00 00 
  80222d:	ff d0                	callq  *%rax
  80222f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802232:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802236:	79 08                	jns    802240 <fork+0x1d9>
								return r;
  802238:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80223b:	e9 91 00 00 00       	jmpq   8022d1 <fork+0x26a>
					ptx++;
  802240:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  802244:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  802248:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
  80224f:	7e a3                	jle    8021f4 <fork+0x18d>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  802251:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  802255:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
  80225c:	0f 8e 54 ff ff ff    	jle    8021b6 <fork+0x14f>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  802262:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  802266:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
  80226d:	0f 8e ff fe ff ff    	jle    802172 <fork+0x10b>
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		return r;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  802273:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802277:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80227b:	0f 84 ad fe ff ff    	je     80212e <fork+0xc7>
			}
		}
	}

	extern void _pgfault_upcall();
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  802281:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802284:	48 be 4b 3b 80 00 00 	movabs $0x803b4b,%rsi
  80228b:	00 00 00 
  80228e:	89 c7                	mov    %eax,%edi
  802290:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  802297:	00 00 00 
  80229a:	ff d0                	callq  *%rax
  80229c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80229f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8022a3:	79 05                	jns    8022aa <fork+0x243>
		return r;
  8022a5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8022a8:	eb 27                	jmp    8022d1 <fork+0x26a>
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8022aa:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8022ad:	be 02 00 00 00       	mov    $0x2,%esi
  8022b2:	89 c7                	mov    %eax,%edi
  8022b4:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  8022bb:	00 00 00 
  8022be:	ff d0                	callq  *%rax
  8022c0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8022c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8022c7:	79 05                	jns    8022ce <fork+0x267>
		return r;
  8022c9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8022cc:	eb 03                	jmp    8022d1 <fork+0x26a>

	return envid;
  8022ce:	8b 45 e8             	mov    -0x18(%rbp),%eax
	//panic("fork not implemented");
}
  8022d1:	c9                   	leaveq 
  8022d2:	c3                   	retq   

00000000008022d3 <sfork>:

// Challenge!
int
sfork(void)
{
  8022d3:	55                   	push   %rbp
  8022d4:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8022d7:	48 ba b1 41 80 00 00 	movabs $0x8041b1,%rdx
  8022de:	00 00 00 
  8022e1:	be a7 00 00 00       	mov    $0xa7,%esi
  8022e6:	48 bf a6 41 80 00 00 	movabs $0x8041a6,%rdi
  8022ed:	00 00 00 
  8022f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f5:	48 b9 81 02 80 00 00 	movabs $0x800281,%rcx
  8022fc:	00 00 00 
  8022ff:	ff d1                	callq  *%rcx

0000000000802301 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802301:	55                   	push   %rbp
  802302:	48 89 e5             	mov    %rsp,%rbp
  802305:	48 83 ec 30          	sub    $0x30,%rsp
  802309:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80230d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802311:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  802315:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802319:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  80231d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802322:	75 0e                	jne    802332 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  802324:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  80232b:	00 00 00 
  80232e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  802332:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802336:	48 89 c7             	mov    %rax,%rdi
  802339:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  802340:	00 00 00 
  802343:	ff d0                	callq  *%rax
  802345:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802348:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80234c:	79 27                	jns    802375 <ipc_recv+0x74>
		if (from_env_store != NULL)
  80234e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802353:	74 0a                	je     80235f <ipc_recv+0x5e>
			*from_env_store = 0;
  802355:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802359:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  80235f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802364:	74 0a                	je     802370 <ipc_recv+0x6f>
			*perm_store = 0;
  802366:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80236a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  802370:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802373:	eb 53                	jmp    8023c8 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  802375:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80237a:	74 19                	je     802395 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  80237c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802383:	00 00 00 
  802386:	48 8b 00             	mov    (%rax),%rax
  802389:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80238f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802393:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  802395:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80239a:	74 19                	je     8023b5 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  80239c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8023a3:	00 00 00 
  8023a6:	48 8b 00             	mov    (%rax),%rax
  8023a9:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8023af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023b3:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  8023b5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8023bc:	00 00 00 
  8023bf:	48 8b 00             	mov    (%rax),%rax
  8023c2:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  8023c8:	c9                   	leaveq 
  8023c9:	c3                   	retq   

00000000008023ca <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023ca:	55                   	push   %rbp
  8023cb:	48 89 e5             	mov    %rsp,%rbp
  8023ce:	48 83 ec 30          	sub    $0x30,%rsp
  8023d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023d5:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8023d8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8023dc:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8023df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8023e7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8023ec:	75 10                	jne    8023fe <ipc_send+0x34>
		page = (void *)KERNBASE;
  8023ee:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8023f5:	00 00 00 
  8023f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  8023fc:	eb 0e                	jmp    80240c <ipc_send+0x42>
  8023fe:	eb 0c                	jmp    80240c <ipc_send+0x42>
		sys_yield();
  802400:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  802407:	00 00 00 
  80240a:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  80240c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80240f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802412:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802416:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802419:	89 c7                	mov    %eax,%edi
  80241b:	48 b8 65 1d 80 00 00 	movabs $0x801d65,%rax
  802422:	00 00 00 
  802425:	ff d0                	callq  *%rax
  802427:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80242a:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  80242e:	74 d0                	je     802400 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  802430:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802434:	74 2a                	je     802460 <ipc_send+0x96>
		panic("error on ipc send procedure");
  802436:	48 ba c7 41 80 00 00 	movabs $0x8041c7,%rdx
  80243d:	00 00 00 
  802440:	be 49 00 00 00       	mov    $0x49,%esi
  802445:	48 bf e3 41 80 00 00 	movabs $0x8041e3,%rdi
  80244c:	00 00 00 
  80244f:	b8 00 00 00 00       	mov    $0x0,%eax
  802454:	48 b9 81 02 80 00 00 	movabs $0x800281,%rcx
  80245b:	00 00 00 
  80245e:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  802460:	c9                   	leaveq 
  802461:	c3                   	retq   

0000000000802462 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802462:	55                   	push   %rbp
  802463:	48 89 e5             	mov    %rsp,%rbp
  802466:	48 83 ec 14          	sub    $0x14,%rsp
  80246a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80246d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802474:	eb 5e                	jmp    8024d4 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802476:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80247d:	00 00 00 
  802480:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802483:	48 63 d0             	movslq %eax,%rdx
  802486:	48 89 d0             	mov    %rdx,%rax
  802489:	48 c1 e0 03          	shl    $0x3,%rax
  80248d:	48 01 d0             	add    %rdx,%rax
  802490:	48 c1 e0 05          	shl    $0x5,%rax
  802494:	48 01 c8             	add    %rcx,%rax
  802497:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80249d:	8b 00                	mov    (%rax),%eax
  80249f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8024a2:	75 2c                	jne    8024d0 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8024a4:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8024ab:	00 00 00 
  8024ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b1:	48 63 d0             	movslq %eax,%rdx
  8024b4:	48 89 d0             	mov    %rdx,%rax
  8024b7:	48 c1 e0 03          	shl    $0x3,%rax
  8024bb:	48 01 d0             	add    %rdx,%rax
  8024be:	48 c1 e0 05          	shl    $0x5,%rax
  8024c2:	48 01 c8             	add    %rcx,%rax
  8024c5:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8024cb:	8b 40 08             	mov    0x8(%rax),%eax
  8024ce:	eb 12                	jmp    8024e2 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8024d0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024d4:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8024db:	7e 99                	jle    802476 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8024dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e2:	c9                   	leaveq 
  8024e3:	c3                   	retq   

00000000008024e4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8024e4:	55                   	push   %rbp
  8024e5:	48 89 e5             	mov    %rsp,%rbp
  8024e8:	48 83 ec 08          	sub    $0x8,%rsp
  8024ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8024f0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024f4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8024fb:	ff ff ff 
  8024fe:	48 01 d0             	add    %rdx,%rax
  802501:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802505:	c9                   	leaveq 
  802506:	c3                   	retq   

0000000000802507 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802507:	55                   	push   %rbp
  802508:	48 89 e5             	mov    %rsp,%rbp
  80250b:	48 83 ec 08          	sub    $0x8,%rsp
  80250f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802513:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802517:	48 89 c7             	mov    %rax,%rdi
  80251a:	48 b8 e4 24 80 00 00 	movabs $0x8024e4,%rax
  802521:	00 00 00 
  802524:	ff d0                	callq  *%rax
  802526:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80252c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802530:	c9                   	leaveq 
  802531:	c3                   	retq   

0000000000802532 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802532:	55                   	push   %rbp
  802533:	48 89 e5             	mov    %rsp,%rbp
  802536:	48 83 ec 18          	sub    $0x18,%rsp
  80253a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80253e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802545:	eb 6b                	jmp    8025b2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802547:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80254a:	48 98                	cltq   
  80254c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802552:	48 c1 e0 0c          	shl    $0xc,%rax
  802556:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80255a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255e:	48 c1 e8 15          	shr    $0x15,%rax
  802562:	48 89 c2             	mov    %rax,%rdx
  802565:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80256c:	01 00 00 
  80256f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802573:	83 e0 01             	and    $0x1,%eax
  802576:	48 85 c0             	test   %rax,%rax
  802579:	74 21                	je     80259c <fd_alloc+0x6a>
  80257b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257f:	48 c1 e8 0c          	shr    $0xc,%rax
  802583:	48 89 c2             	mov    %rax,%rdx
  802586:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80258d:	01 00 00 
  802590:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802594:	83 e0 01             	and    $0x1,%eax
  802597:	48 85 c0             	test   %rax,%rax
  80259a:	75 12                	jne    8025ae <fd_alloc+0x7c>
			*fd_store = fd;
  80259c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025a4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ac:	eb 1a                	jmp    8025c8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025ae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025b2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025b6:	7e 8f                	jle    802547 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8025b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025bc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8025c3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8025c8:	c9                   	leaveq 
  8025c9:	c3                   	retq   

00000000008025ca <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8025ca:	55                   	push   %rbp
  8025cb:	48 89 e5             	mov    %rsp,%rbp
  8025ce:	48 83 ec 20          	sub    $0x20,%rsp
  8025d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8025d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025dd:	78 06                	js     8025e5 <fd_lookup+0x1b>
  8025df:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8025e3:	7e 07                	jle    8025ec <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025ea:	eb 6c                	jmp    802658 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8025ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025ef:	48 98                	cltq   
  8025f1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025f7:	48 c1 e0 0c          	shl    $0xc,%rax
  8025fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8025ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802603:	48 c1 e8 15          	shr    $0x15,%rax
  802607:	48 89 c2             	mov    %rax,%rdx
  80260a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802611:	01 00 00 
  802614:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802618:	83 e0 01             	and    $0x1,%eax
  80261b:	48 85 c0             	test   %rax,%rax
  80261e:	74 21                	je     802641 <fd_lookup+0x77>
  802620:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802624:	48 c1 e8 0c          	shr    $0xc,%rax
  802628:	48 89 c2             	mov    %rax,%rdx
  80262b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802632:	01 00 00 
  802635:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802639:	83 e0 01             	and    $0x1,%eax
  80263c:	48 85 c0             	test   %rax,%rax
  80263f:	75 07                	jne    802648 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802641:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802646:	eb 10                	jmp    802658 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802648:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80264c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802650:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802653:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802658:	c9                   	leaveq 
  802659:	c3                   	retq   

000000000080265a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80265a:	55                   	push   %rbp
  80265b:	48 89 e5             	mov    %rsp,%rbp
  80265e:	48 83 ec 30          	sub    $0x30,%rsp
  802662:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802666:	89 f0                	mov    %esi,%eax
  802668:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80266b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80266f:	48 89 c7             	mov    %rax,%rdi
  802672:	48 b8 e4 24 80 00 00 	movabs $0x8024e4,%rax
  802679:	00 00 00 
  80267c:	ff d0                	callq  *%rax
  80267e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802682:	48 89 d6             	mov    %rdx,%rsi
  802685:	89 c7                	mov    %eax,%edi
  802687:	48 b8 ca 25 80 00 00 	movabs $0x8025ca,%rax
  80268e:	00 00 00 
  802691:	ff d0                	callq  *%rax
  802693:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802696:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269a:	78 0a                	js     8026a6 <fd_close+0x4c>
	    || fd != fd2)
  80269c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8026a4:	74 12                	je     8026b8 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8026a6:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8026aa:	74 05                	je     8026b1 <fd_close+0x57>
  8026ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026af:	eb 05                	jmp    8026b6 <fd_close+0x5c>
  8026b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b6:	eb 69                	jmp    802721 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8026b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026bc:	8b 00                	mov    (%rax),%eax
  8026be:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026c2:	48 89 d6             	mov    %rdx,%rsi
  8026c5:	89 c7                	mov    %eax,%edi
  8026c7:	48 b8 23 27 80 00 00 	movabs $0x802723,%rax
  8026ce:	00 00 00 
  8026d1:	ff d0                	callq  *%rax
  8026d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026da:	78 2a                	js     802706 <fd_close+0xac>
		if (dev->dev_close)
  8026dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026e4:	48 85 c0             	test   %rax,%rax
  8026e7:	74 16                	je     8026ff <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8026e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ed:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026f1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026f5:	48 89 d7             	mov    %rdx,%rdi
  8026f8:	ff d0                	callq  *%rax
  8026fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026fd:	eb 07                	jmp    802706 <fd_close+0xac>
		else
			r = 0;
  8026ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802706:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80270a:	48 89 c6             	mov    %rax,%rsi
  80270d:	bf 00 00 00 00       	mov    $0x0,%edi
  802712:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  802719:	00 00 00 
  80271c:	ff d0                	callq  *%rax
	return r;
  80271e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802721:	c9                   	leaveq 
  802722:	c3                   	retq   

0000000000802723 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802723:	55                   	push   %rbp
  802724:	48 89 e5             	mov    %rsp,%rbp
  802727:	48 83 ec 20          	sub    $0x20,%rsp
  80272b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80272e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802732:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802739:	eb 41                	jmp    80277c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80273b:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802742:	00 00 00 
  802745:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802748:	48 63 d2             	movslq %edx,%rdx
  80274b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80274f:	8b 00                	mov    (%rax),%eax
  802751:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802754:	75 22                	jne    802778 <dev_lookup+0x55>
			*dev = devtab[i];
  802756:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80275d:	00 00 00 
  802760:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802763:	48 63 d2             	movslq %edx,%rdx
  802766:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80276a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80276e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802771:	b8 00 00 00 00       	mov    $0x0,%eax
  802776:	eb 60                	jmp    8027d8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802778:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80277c:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802783:	00 00 00 
  802786:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802789:	48 63 d2             	movslq %edx,%rdx
  80278c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802790:	48 85 c0             	test   %rax,%rax
  802793:	75 a6                	jne    80273b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802795:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80279c:	00 00 00 
  80279f:	48 8b 00             	mov    (%rax),%rax
  8027a2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027a8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8027ab:	89 c6                	mov    %eax,%esi
  8027ad:	48 bf f0 41 80 00 00 	movabs $0x8041f0,%rdi
  8027b4:	00 00 00 
  8027b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bc:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  8027c3:	00 00 00 
  8027c6:	ff d1                	callq  *%rcx
	*dev = 0;
  8027c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027cc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8027d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8027d8:	c9                   	leaveq 
  8027d9:	c3                   	retq   

00000000008027da <close>:

int
close(int fdnum)
{
  8027da:	55                   	push   %rbp
  8027db:	48 89 e5             	mov    %rsp,%rbp
  8027de:	48 83 ec 20          	sub    $0x20,%rsp
  8027e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027e5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027ec:	48 89 d6             	mov    %rdx,%rsi
  8027ef:	89 c7                	mov    %eax,%edi
  8027f1:	48 b8 ca 25 80 00 00 	movabs $0x8025ca,%rax
  8027f8:	00 00 00 
  8027fb:	ff d0                	callq  *%rax
  8027fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802800:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802804:	79 05                	jns    80280b <close+0x31>
		return r;
  802806:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802809:	eb 18                	jmp    802823 <close+0x49>
	else
		return fd_close(fd, 1);
  80280b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280f:	be 01 00 00 00       	mov    $0x1,%esi
  802814:	48 89 c7             	mov    %rax,%rdi
  802817:	48 b8 5a 26 80 00 00 	movabs $0x80265a,%rax
  80281e:	00 00 00 
  802821:	ff d0                	callq  *%rax
}
  802823:	c9                   	leaveq 
  802824:	c3                   	retq   

0000000000802825 <close_all>:

void
close_all(void)
{
  802825:	55                   	push   %rbp
  802826:	48 89 e5             	mov    %rsp,%rbp
  802829:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80282d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802834:	eb 15                	jmp    80284b <close_all+0x26>
		close(i);
  802836:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802839:	89 c7                	mov    %eax,%edi
  80283b:	48 b8 da 27 80 00 00 	movabs $0x8027da,%rax
  802842:	00 00 00 
  802845:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802847:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80284b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80284f:	7e e5                	jle    802836 <close_all+0x11>
		close(i);
}
  802851:	c9                   	leaveq 
  802852:	c3                   	retq   

0000000000802853 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802853:	55                   	push   %rbp
  802854:	48 89 e5             	mov    %rsp,%rbp
  802857:	48 83 ec 40          	sub    $0x40,%rsp
  80285b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80285e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802861:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802865:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802868:	48 89 d6             	mov    %rdx,%rsi
  80286b:	89 c7                	mov    %eax,%edi
  80286d:	48 b8 ca 25 80 00 00 	movabs $0x8025ca,%rax
  802874:	00 00 00 
  802877:	ff d0                	callq  *%rax
  802879:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80287c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802880:	79 08                	jns    80288a <dup+0x37>
		return r;
  802882:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802885:	e9 70 01 00 00       	jmpq   8029fa <dup+0x1a7>
	close(newfdnum);
  80288a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80288d:	89 c7                	mov    %eax,%edi
  80288f:	48 b8 da 27 80 00 00 	movabs $0x8027da,%rax
  802896:	00 00 00 
  802899:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80289b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80289e:	48 98                	cltq   
  8028a0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028a6:	48 c1 e0 0c          	shl    $0xc,%rax
  8028aa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8028ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b2:	48 89 c7             	mov    %rax,%rdi
  8028b5:	48 b8 07 25 80 00 00 	movabs $0x802507,%rax
  8028bc:	00 00 00 
  8028bf:	ff d0                	callq  *%rax
  8028c1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8028c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c9:	48 89 c7             	mov    %rax,%rdi
  8028cc:	48 b8 07 25 80 00 00 	movabs $0x802507,%rax
  8028d3:	00 00 00 
  8028d6:	ff d0                	callq  *%rax
  8028d8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8028dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e0:	48 c1 e8 15          	shr    $0x15,%rax
  8028e4:	48 89 c2             	mov    %rax,%rdx
  8028e7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028ee:	01 00 00 
  8028f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f5:	83 e0 01             	and    $0x1,%eax
  8028f8:	48 85 c0             	test   %rax,%rax
  8028fb:	74 73                	je     802970 <dup+0x11d>
  8028fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802901:	48 c1 e8 0c          	shr    $0xc,%rax
  802905:	48 89 c2             	mov    %rax,%rdx
  802908:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80290f:	01 00 00 
  802912:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802916:	83 e0 01             	and    $0x1,%eax
  802919:	48 85 c0             	test   %rax,%rax
  80291c:	74 52                	je     802970 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80291e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802922:	48 c1 e8 0c          	shr    $0xc,%rax
  802926:	48 89 c2             	mov    %rax,%rdx
  802929:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802930:	01 00 00 
  802933:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802937:	25 07 0e 00 00       	and    $0xe07,%eax
  80293c:	89 c1                	mov    %eax,%ecx
  80293e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802946:	41 89 c8             	mov    %ecx,%r8d
  802949:	48 89 d1             	mov    %rdx,%rcx
  80294c:	ba 00 00 00 00       	mov    $0x0,%edx
  802951:	48 89 c6             	mov    %rax,%rsi
  802954:	bf 00 00 00 00       	mov    $0x0,%edi
  802959:	48 b8 e1 1b 80 00 00 	movabs $0x801be1,%rax
  802960:	00 00 00 
  802963:	ff d0                	callq  *%rax
  802965:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802968:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80296c:	79 02                	jns    802970 <dup+0x11d>
			goto err;
  80296e:	eb 57                	jmp    8029c7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802970:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802974:	48 c1 e8 0c          	shr    $0xc,%rax
  802978:	48 89 c2             	mov    %rax,%rdx
  80297b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802982:	01 00 00 
  802985:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802989:	25 07 0e 00 00       	and    $0xe07,%eax
  80298e:	89 c1                	mov    %eax,%ecx
  802990:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802994:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802998:	41 89 c8             	mov    %ecx,%r8d
  80299b:	48 89 d1             	mov    %rdx,%rcx
  80299e:	ba 00 00 00 00       	mov    $0x0,%edx
  8029a3:	48 89 c6             	mov    %rax,%rsi
  8029a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8029ab:	48 b8 e1 1b 80 00 00 	movabs $0x801be1,%rax
  8029b2:	00 00 00 
  8029b5:	ff d0                	callq  *%rax
  8029b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029be:	79 02                	jns    8029c2 <dup+0x16f>
		goto err;
  8029c0:	eb 05                	jmp    8029c7 <dup+0x174>

	return newfdnum;
  8029c2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029c5:	eb 33                	jmp    8029fa <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8029c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029cb:	48 89 c6             	mov    %rax,%rsi
  8029ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8029d3:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  8029da:	00 00 00 
  8029dd:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8029df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029e3:	48 89 c6             	mov    %rax,%rsi
  8029e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8029eb:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  8029f2:	00 00 00 
  8029f5:	ff d0                	callq  *%rax
	return r;
  8029f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029fa:	c9                   	leaveq 
  8029fb:	c3                   	retq   

00000000008029fc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8029fc:	55                   	push   %rbp
  8029fd:	48 89 e5             	mov    %rsp,%rbp
  802a00:	48 83 ec 40          	sub    $0x40,%rsp
  802a04:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a07:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a0b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a0f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a13:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a16:	48 89 d6             	mov    %rdx,%rsi
  802a19:	89 c7                	mov    %eax,%edi
  802a1b:	48 b8 ca 25 80 00 00 	movabs $0x8025ca,%rax
  802a22:	00 00 00 
  802a25:	ff d0                	callq  *%rax
  802a27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a2e:	78 24                	js     802a54 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a34:	8b 00                	mov    (%rax),%eax
  802a36:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a3a:	48 89 d6             	mov    %rdx,%rsi
  802a3d:	89 c7                	mov    %eax,%edi
  802a3f:	48 b8 23 27 80 00 00 	movabs $0x802723,%rax
  802a46:	00 00 00 
  802a49:	ff d0                	callq  *%rax
  802a4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a52:	79 05                	jns    802a59 <read+0x5d>
		return r;
  802a54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a57:	eb 76                	jmp    802acf <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a5d:	8b 40 08             	mov    0x8(%rax),%eax
  802a60:	83 e0 03             	and    $0x3,%eax
  802a63:	83 f8 01             	cmp    $0x1,%eax
  802a66:	75 3a                	jne    802aa2 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a68:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802a6f:	00 00 00 
  802a72:	48 8b 00             	mov    (%rax),%rax
  802a75:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a7b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a7e:	89 c6                	mov    %eax,%esi
  802a80:	48 bf 0f 42 80 00 00 	movabs $0x80420f,%rdi
  802a87:	00 00 00 
  802a8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8f:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802a96:	00 00 00 
  802a99:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aa0:	eb 2d                	jmp    802acf <read+0xd3>
	}
	if (!dev->dev_read)
  802aa2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aa6:	48 8b 40 10          	mov    0x10(%rax),%rax
  802aaa:	48 85 c0             	test   %rax,%rax
  802aad:	75 07                	jne    802ab6 <read+0xba>
		return -E_NOT_SUPP;
  802aaf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ab4:	eb 19                	jmp    802acf <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802ab6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aba:	48 8b 40 10          	mov    0x10(%rax),%rax
  802abe:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ac2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ac6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802aca:	48 89 cf             	mov    %rcx,%rdi
  802acd:	ff d0                	callq  *%rax
}
  802acf:	c9                   	leaveq 
  802ad0:	c3                   	retq   

0000000000802ad1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802ad1:	55                   	push   %rbp
  802ad2:	48 89 e5             	mov    %rsp,%rbp
  802ad5:	48 83 ec 30          	sub    $0x30,%rsp
  802ad9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802adc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ae0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ae4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802aeb:	eb 49                	jmp    802b36 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802aed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af0:	48 98                	cltq   
  802af2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802af6:	48 29 c2             	sub    %rax,%rdx
  802af9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afc:	48 63 c8             	movslq %eax,%rcx
  802aff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b03:	48 01 c1             	add    %rax,%rcx
  802b06:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b09:	48 89 ce             	mov    %rcx,%rsi
  802b0c:	89 c7                	mov    %eax,%edi
  802b0e:	48 b8 fc 29 80 00 00 	movabs $0x8029fc,%rax
  802b15:	00 00 00 
  802b18:	ff d0                	callq  *%rax
  802b1a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b1d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b21:	79 05                	jns    802b28 <readn+0x57>
			return m;
  802b23:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b26:	eb 1c                	jmp    802b44 <readn+0x73>
		if (m == 0)
  802b28:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b2c:	75 02                	jne    802b30 <readn+0x5f>
			break;
  802b2e:	eb 11                	jmp    802b41 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b33:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b39:	48 98                	cltq   
  802b3b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b3f:	72 ac                	jb     802aed <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802b41:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b44:	c9                   	leaveq 
  802b45:	c3                   	retq   

0000000000802b46 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b46:	55                   	push   %rbp
  802b47:	48 89 e5             	mov    %rsp,%rbp
  802b4a:	48 83 ec 40          	sub    $0x40,%rsp
  802b4e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b51:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b55:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b59:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b5d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b60:	48 89 d6             	mov    %rdx,%rsi
  802b63:	89 c7                	mov    %eax,%edi
  802b65:	48 b8 ca 25 80 00 00 	movabs $0x8025ca,%rax
  802b6c:	00 00 00 
  802b6f:	ff d0                	callq  *%rax
  802b71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b78:	78 24                	js     802b9e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7e:	8b 00                	mov    (%rax),%eax
  802b80:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b84:	48 89 d6             	mov    %rdx,%rsi
  802b87:	89 c7                	mov    %eax,%edi
  802b89:	48 b8 23 27 80 00 00 	movabs $0x802723,%rax
  802b90:	00 00 00 
  802b93:	ff d0                	callq  *%rax
  802b95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9c:	79 05                	jns    802ba3 <write+0x5d>
		return r;
  802b9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba1:	eb 75                	jmp    802c18 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ba3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba7:	8b 40 08             	mov    0x8(%rax),%eax
  802baa:	83 e0 03             	and    $0x3,%eax
  802bad:	85 c0                	test   %eax,%eax
  802baf:	75 3a                	jne    802beb <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802bb1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802bb8:	00 00 00 
  802bbb:	48 8b 00             	mov    (%rax),%rax
  802bbe:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bc4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bc7:	89 c6                	mov    %eax,%esi
  802bc9:	48 bf 2b 42 80 00 00 	movabs $0x80422b,%rdi
  802bd0:	00 00 00 
  802bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd8:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802bdf:	00 00 00 
  802be2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802be4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802be9:	eb 2d                	jmp    802c18 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802beb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bef:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bf3:	48 85 c0             	test   %rax,%rax
  802bf6:	75 07                	jne    802bff <write+0xb9>
		return -E_NOT_SUPP;
  802bf8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bfd:	eb 19                	jmp    802c18 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802bff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c03:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c07:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c0b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c0f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c13:	48 89 cf             	mov    %rcx,%rdi
  802c16:	ff d0                	callq  *%rax
}
  802c18:	c9                   	leaveq 
  802c19:	c3                   	retq   

0000000000802c1a <seek>:

int
seek(int fdnum, off_t offset)
{
  802c1a:	55                   	push   %rbp
  802c1b:	48 89 e5             	mov    %rsp,%rbp
  802c1e:	48 83 ec 18          	sub    $0x18,%rsp
  802c22:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c25:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c28:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c2c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c2f:	48 89 d6             	mov    %rdx,%rsi
  802c32:	89 c7                	mov    %eax,%edi
  802c34:	48 b8 ca 25 80 00 00 	movabs $0x8025ca,%rax
  802c3b:	00 00 00 
  802c3e:	ff d0                	callq  *%rax
  802c40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c47:	79 05                	jns    802c4e <seek+0x34>
		return r;
  802c49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4c:	eb 0f                	jmp    802c5d <seek+0x43>
	fd->fd_offset = offset;
  802c4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c52:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c55:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c5d:	c9                   	leaveq 
  802c5e:	c3                   	retq   

0000000000802c5f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c5f:	55                   	push   %rbp
  802c60:	48 89 e5             	mov    %rsp,%rbp
  802c63:	48 83 ec 30          	sub    $0x30,%rsp
  802c67:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c6a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c6d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c71:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c74:	48 89 d6             	mov    %rdx,%rsi
  802c77:	89 c7                	mov    %eax,%edi
  802c79:	48 b8 ca 25 80 00 00 	movabs $0x8025ca,%rax
  802c80:	00 00 00 
  802c83:	ff d0                	callq  *%rax
  802c85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c8c:	78 24                	js     802cb2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c92:	8b 00                	mov    (%rax),%eax
  802c94:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c98:	48 89 d6             	mov    %rdx,%rsi
  802c9b:	89 c7                	mov    %eax,%edi
  802c9d:	48 b8 23 27 80 00 00 	movabs $0x802723,%rax
  802ca4:	00 00 00 
  802ca7:	ff d0                	callq  *%rax
  802ca9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cb0:	79 05                	jns    802cb7 <ftruncate+0x58>
		return r;
  802cb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb5:	eb 72                	jmp    802d29 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802cb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cbb:	8b 40 08             	mov    0x8(%rax),%eax
  802cbe:	83 e0 03             	and    $0x3,%eax
  802cc1:	85 c0                	test   %eax,%eax
  802cc3:	75 3a                	jne    802cff <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802cc5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802ccc:	00 00 00 
  802ccf:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802cd2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cd8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802cdb:	89 c6                	mov    %eax,%esi
  802cdd:	48 bf 48 42 80 00 00 	movabs $0x804248,%rdi
  802ce4:	00 00 00 
  802ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  802cec:	48 b9 ba 04 80 00 00 	movabs $0x8004ba,%rcx
  802cf3:	00 00 00 
  802cf6:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802cf8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cfd:	eb 2a                	jmp    802d29 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802cff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d03:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d07:	48 85 c0             	test   %rax,%rax
  802d0a:	75 07                	jne    802d13 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802d0c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d11:	eb 16                	jmp    802d29 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802d13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d17:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d1b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d1f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802d22:	89 ce                	mov    %ecx,%esi
  802d24:	48 89 d7             	mov    %rdx,%rdi
  802d27:	ff d0                	callq  *%rax
}
  802d29:	c9                   	leaveq 
  802d2a:	c3                   	retq   

0000000000802d2b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802d2b:	55                   	push   %rbp
  802d2c:	48 89 e5             	mov    %rsp,%rbp
  802d2f:	48 83 ec 30          	sub    $0x30,%rsp
  802d33:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d36:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d3a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d3e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d41:	48 89 d6             	mov    %rdx,%rsi
  802d44:	89 c7                	mov    %eax,%edi
  802d46:	48 b8 ca 25 80 00 00 	movabs $0x8025ca,%rax
  802d4d:	00 00 00 
  802d50:	ff d0                	callq  *%rax
  802d52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d59:	78 24                	js     802d7f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d5f:	8b 00                	mov    (%rax),%eax
  802d61:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d65:	48 89 d6             	mov    %rdx,%rsi
  802d68:	89 c7                	mov    %eax,%edi
  802d6a:	48 b8 23 27 80 00 00 	movabs $0x802723,%rax
  802d71:	00 00 00 
  802d74:	ff d0                	callq  *%rax
  802d76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d7d:	79 05                	jns    802d84 <fstat+0x59>
		return r;
  802d7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d82:	eb 5e                	jmp    802de2 <fstat+0xb7>
	if (!dev->dev_stat)
  802d84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d88:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d8c:	48 85 c0             	test   %rax,%rax
  802d8f:	75 07                	jne    802d98 <fstat+0x6d>
		return -E_NOT_SUPP;
  802d91:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d96:	eb 4a                	jmp    802de2 <fstat+0xb7>
	stat->st_name[0] = 0;
  802d98:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d9c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d9f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802da3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802daa:	00 00 00 
	stat->st_isdir = 0;
  802dad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802db1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802db8:	00 00 00 
	stat->st_dev = dev;
  802dbb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802dbf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dc3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802dca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dce:	48 8b 40 28          	mov    0x28(%rax),%rax
  802dd2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dd6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802dda:	48 89 ce             	mov    %rcx,%rsi
  802ddd:	48 89 d7             	mov    %rdx,%rdi
  802de0:	ff d0                	callq  *%rax
}
  802de2:	c9                   	leaveq 
  802de3:	c3                   	retq   

0000000000802de4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802de4:	55                   	push   %rbp
  802de5:	48 89 e5             	mov    %rsp,%rbp
  802de8:	48 83 ec 20          	sub    $0x20,%rsp
  802dec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802df0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802df4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df8:	be 00 00 00 00       	mov    $0x0,%esi
  802dfd:	48 89 c7             	mov    %rax,%rdi
  802e00:	48 b8 d2 2e 80 00 00 	movabs $0x802ed2,%rax
  802e07:	00 00 00 
  802e0a:	ff d0                	callq  *%rax
  802e0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e13:	79 05                	jns    802e1a <stat+0x36>
		return fd;
  802e15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e18:	eb 2f                	jmp    802e49 <stat+0x65>
	r = fstat(fd, stat);
  802e1a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e21:	48 89 d6             	mov    %rdx,%rsi
  802e24:	89 c7                	mov    %eax,%edi
  802e26:	48 b8 2b 2d 80 00 00 	movabs $0x802d2b,%rax
  802e2d:	00 00 00 
  802e30:	ff d0                	callq  *%rax
  802e32:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e38:	89 c7                	mov    %eax,%edi
  802e3a:	48 b8 da 27 80 00 00 	movabs $0x8027da,%rax
  802e41:	00 00 00 
  802e44:	ff d0                	callq  *%rax
	return r;
  802e46:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e49:	c9                   	leaveq 
  802e4a:	c3                   	retq   

0000000000802e4b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e4b:	55                   	push   %rbp
  802e4c:	48 89 e5             	mov    %rsp,%rbp
  802e4f:	48 83 ec 10          	sub    $0x10,%rsp
  802e53:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e56:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e5a:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802e61:	00 00 00 
  802e64:	8b 00                	mov    (%rax),%eax
  802e66:	85 c0                	test   %eax,%eax
  802e68:	75 1d                	jne    802e87 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e6a:	bf 01 00 00 00       	mov    $0x1,%edi
  802e6f:	48 b8 62 24 80 00 00 	movabs $0x802462,%rax
  802e76:	00 00 00 
  802e79:	ff d0                	callq  *%rax
  802e7b:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  802e82:	00 00 00 
  802e85:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e87:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802e8e:	00 00 00 
  802e91:	8b 00                	mov    (%rax),%eax
  802e93:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e96:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e9b:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802ea2:	00 00 00 
  802ea5:	89 c7                	mov    %eax,%edi
  802ea7:	48 b8 ca 23 80 00 00 	movabs $0x8023ca,%rax
  802eae:	00 00 00 
  802eb1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802eb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb7:	ba 00 00 00 00       	mov    $0x0,%edx
  802ebc:	48 89 c6             	mov    %rax,%rsi
  802ebf:	bf 00 00 00 00       	mov    $0x0,%edi
  802ec4:	48 b8 01 23 80 00 00 	movabs $0x802301,%rax
  802ecb:	00 00 00 
  802ece:	ff d0                	callq  *%rax
}
  802ed0:	c9                   	leaveq 
  802ed1:	c3                   	retq   

0000000000802ed2 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802ed2:	55                   	push   %rbp
  802ed3:	48 89 e5             	mov    %rsp,%rbp
  802ed6:	48 83 ec 20          	sub    $0x20,%rsp
  802eda:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ede:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802ee1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee5:	48 89 c7             	mov    %rax,%rdi
  802ee8:	48 b8 f6 11 80 00 00 	movabs $0x8011f6,%rax
  802eef:	00 00 00 
  802ef2:	ff d0                	callq  *%rax
  802ef4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ef9:	7e 0a                	jle    802f05 <open+0x33>
		return -E_BAD_PATH;
  802efb:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f00:	e9 a5 00 00 00       	jmpq   802faa <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802f05:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f09:	48 89 c7             	mov    %rax,%rdi
  802f0c:	48 b8 32 25 80 00 00 	movabs $0x802532,%rax
  802f13:	00 00 00 
  802f16:	ff d0                	callq  *%rax
  802f18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f1f:	79 08                	jns    802f29 <open+0x57>
		return r;
  802f21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f24:	e9 81 00 00 00       	jmpq   802faa <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802f29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f2d:	48 89 c6             	mov    %rax,%rsi
  802f30:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802f37:	00 00 00 
  802f3a:	48 b8 62 12 80 00 00 	movabs $0x801262,%rax
  802f41:	00 00 00 
  802f44:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802f46:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f4d:	00 00 00 
  802f50:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802f53:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802f59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f5d:	48 89 c6             	mov    %rax,%rsi
  802f60:	bf 01 00 00 00       	mov    $0x1,%edi
  802f65:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  802f6c:	00 00 00 
  802f6f:	ff d0                	callq  *%rax
  802f71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f78:	79 1d                	jns    802f97 <open+0xc5>
		fd_close(fd, 0);
  802f7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f7e:	be 00 00 00 00       	mov    $0x0,%esi
  802f83:	48 89 c7             	mov    %rax,%rdi
  802f86:	48 b8 5a 26 80 00 00 	movabs $0x80265a,%rax
  802f8d:	00 00 00 
  802f90:	ff d0                	callq  *%rax
		return r;
  802f92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f95:	eb 13                	jmp    802faa <open+0xd8>
	}

	return fd2num(fd);
  802f97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f9b:	48 89 c7             	mov    %rax,%rdi
  802f9e:	48 b8 e4 24 80 00 00 	movabs $0x8024e4,%rax
  802fa5:	00 00 00 
  802fa8:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802faa:	c9                   	leaveq 
  802fab:	c3                   	retq   

0000000000802fac <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802fac:	55                   	push   %rbp
  802fad:	48 89 e5             	mov    %rsp,%rbp
  802fb0:	48 83 ec 10          	sub    $0x10,%rsp
  802fb4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802fb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fbc:	8b 50 0c             	mov    0xc(%rax),%edx
  802fbf:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802fc6:	00 00 00 
  802fc9:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802fcb:	be 00 00 00 00       	mov    $0x0,%esi
  802fd0:	bf 06 00 00 00       	mov    $0x6,%edi
  802fd5:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  802fdc:	00 00 00 
  802fdf:	ff d0                	callq  *%rax
}
  802fe1:	c9                   	leaveq 
  802fe2:	c3                   	retq   

0000000000802fe3 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802fe3:	55                   	push   %rbp
  802fe4:	48 89 e5             	mov    %rsp,%rbp
  802fe7:	48 83 ec 30          	sub    $0x30,%rsp
  802feb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ff3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802ff7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ffb:	8b 50 0c             	mov    0xc(%rax),%edx
  802ffe:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803005:	00 00 00 
  803008:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80300a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803011:	00 00 00 
  803014:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803018:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80301c:	be 00 00 00 00       	mov    $0x0,%esi
  803021:	bf 03 00 00 00       	mov    $0x3,%edi
  803026:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  80302d:	00 00 00 
  803030:	ff d0                	callq  *%rax
  803032:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803035:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803039:	79 05                	jns    803040 <devfile_read+0x5d>
		return r;
  80303b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80303e:	eb 26                	jmp    803066 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  803040:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803043:	48 63 d0             	movslq %eax,%rdx
  803046:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80304a:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  803051:	00 00 00 
  803054:	48 89 c7             	mov    %rax,%rdi
  803057:	48 b8 86 15 80 00 00 	movabs $0x801586,%rax
  80305e:	00 00 00 
  803061:	ff d0                	callq  *%rax

	return r;
  803063:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803066:	c9                   	leaveq 
  803067:	c3                   	retq   

0000000000803068 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803068:	55                   	push   %rbp
  803069:	48 89 e5             	mov    %rsp,%rbp
  80306c:	48 83 ec 30          	sub    $0x30,%rsp
  803070:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803074:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803078:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  80307c:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803083:	00 
  803084:	76 08                	jbe    80308e <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  803086:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80308d:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80308e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803092:	8b 50 0c             	mov    0xc(%rax),%edx
  803095:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80309c:	00 00 00 
  80309f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8030a1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8030a8:	00 00 00 
  8030ab:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030af:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  8030b3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030bb:	48 89 c6             	mov    %rax,%rsi
  8030be:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8030c5:	00 00 00 
  8030c8:	48 b8 86 15 80 00 00 	movabs $0x801586,%rax
  8030cf:	00 00 00 
  8030d2:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8030d4:	be 00 00 00 00       	mov    $0x0,%esi
  8030d9:	bf 04 00 00 00       	mov    $0x4,%edi
  8030de:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  8030e5:	00 00 00 
  8030e8:	ff d0                	callq  *%rax
  8030ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f1:	79 05                	jns    8030f8 <devfile_write+0x90>
		return r;
  8030f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f6:	eb 03                	jmp    8030fb <devfile_write+0x93>

	return r;
  8030f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8030fb:	c9                   	leaveq 
  8030fc:	c3                   	retq   

00000000008030fd <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8030fd:	55                   	push   %rbp
  8030fe:	48 89 e5             	mov    %rsp,%rbp
  803101:	48 83 ec 20          	sub    $0x20,%rsp
  803105:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803109:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80310d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803111:	8b 50 0c             	mov    0xc(%rax),%edx
  803114:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80311b:	00 00 00 
  80311e:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803120:	be 00 00 00 00       	mov    $0x0,%esi
  803125:	bf 05 00 00 00       	mov    $0x5,%edi
  80312a:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  803131:	00 00 00 
  803134:	ff d0                	callq  *%rax
  803136:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803139:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80313d:	79 05                	jns    803144 <devfile_stat+0x47>
		return r;
  80313f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803142:	eb 56                	jmp    80319a <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803144:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803148:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80314f:	00 00 00 
  803152:	48 89 c7             	mov    %rax,%rdi
  803155:	48 b8 62 12 80 00 00 	movabs $0x801262,%rax
  80315c:	00 00 00 
  80315f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803161:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803168:	00 00 00 
  80316b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803171:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803175:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80317b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803182:	00 00 00 
  803185:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80318b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80318f:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803195:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80319a:	c9                   	leaveq 
  80319b:	c3                   	retq   

000000000080319c <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80319c:	55                   	push   %rbp
  80319d:	48 89 e5             	mov    %rsp,%rbp
  8031a0:	48 83 ec 10          	sub    $0x10,%rsp
  8031a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031a8:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8031ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031af:	8b 50 0c             	mov    0xc(%rax),%edx
  8031b2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8031b9:	00 00 00 
  8031bc:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8031be:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8031c5:	00 00 00 
  8031c8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8031cb:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8031ce:	be 00 00 00 00       	mov    $0x0,%esi
  8031d3:	bf 02 00 00 00       	mov    $0x2,%edi
  8031d8:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  8031df:	00 00 00 
  8031e2:	ff d0                	callq  *%rax
}
  8031e4:	c9                   	leaveq 
  8031e5:	c3                   	retq   

00000000008031e6 <remove>:

// Delete a file
int
remove(const char *path)
{
  8031e6:	55                   	push   %rbp
  8031e7:	48 89 e5             	mov    %rsp,%rbp
  8031ea:	48 83 ec 10          	sub    $0x10,%rsp
  8031ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8031f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031f6:	48 89 c7             	mov    %rax,%rdi
  8031f9:	48 b8 f6 11 80 00 00 	movabs $0x8011f6,%rax
  803200:	00 00 00 
  803203:	ff d0                	callq  *%rax
  803205:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80320a:	7e 07                	jle    803213 <remove+0x2d>
		return -E_BAD_PATH;
  80320c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803211:	eb 33                	jmp    803246 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803213:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803217:	48 89 c6             	mov    %rax,%rsi
  80321a:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  803221:	00 00 00 
  803224:	48 b8 62 12 80 00 00 	movabs $0x801262,%rax
  80322b:	00 00 00 
  80322e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803230:	be 00 00 00 00       	mov    $0x0,%esi
  803235:	bf 07 00 00 00       	mov    $0x7,%edi
  80323a:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  803241:	00 00 00 
  803244:	ff d0                	callq  *%rax
}
  803246:	c9                   	leaveq 
  803247:	c3                   	retq   

0000000000803248 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803248:	55                   	push   %rbp
  803249:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80324c:	be 00 00 00 00       	mov    $0x0,%esi
  803251:	bf 08 00 00 00       	mov    $0x8,%edi
  803256:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  80325d:	00 00 00 
  803260:	ff d0                	callq  *%rax
}
  803262:	5d                   	pop    %rbp
  803263:	c3                   	retq   

0000000000803264 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803264:	55                   	push   %rbp
  803265:	48 89 e5             	mov    %rsp,%rbp
  803268:	53                   	push   %rbx
  803269:	48 83 ec 38          	sub    $0x38,%rsp
  80326d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803271:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803275:	48 89 c7             	mov    %rax,%rdi
  803278:	48 b8 32 25 80 00 00 	movabs $0x802532,%rax
  80327f:	00 00 00 
  803282:	ff d0                	callq  *%rax
  803284:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803287:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80328b:	0f 88 bf 01 00 00    	js     803450 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803291:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803295:	ba 07 04 00 00       	mov    $0x407,%edx
  80329a:	48 89 c6             	mov    %rax,%rsi
  80329d:	bf 00 00 00 00       	mov    $0x0,%edi
  8032a2:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  8032a9:	00 00 00 
  8032ac:	ff d0                	callq  *%rax
  8032ae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032b5:	0f 88 95 01 00 00    	js     803450 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8032bb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8032bf:	48 89 c7             	mov    %rax,%rdi
  8032c2:	48 b8 32 25 80 00 00 	movabs $0x802532,%rax
  8032c9:	00 00 00 
  8032cc:	ff d0                	callq  *%rax
  8032ce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032d5:	0f 88 5d 01 00 00    	js     803438 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032df:	ba 07 04 00 00       	mov    $0x407,%edx
  8032e4:	48 89 c6             	mov    %rax,%rsi
  8032e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8032ec:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  8032f3:	00 00 00 
  8032f6:	ff d0                	callq  *%rax
  8032f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032ff:	0f 88 33 01 00 00    	js     803438 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803305:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803309:	48 89 c7             	mov    %rax,%rdi
  80330c:	48 b8 07 25 80 00 00 	movabs $0x802507,%rax
  803313:	00 00 00 
  803316:	ff d0                	callq  *%rax
  803318:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80331c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803320:	ba 07 04 00 00       	mov    $0x407,%edx
  803325:	48 89 c6             	mov    %rax,%rsi
  803328:	bf 00 00 00 00       	mov    $0x0,%edi
  80332d:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  803334:	00 00 00 
  803337:	ff d0                	callq  *%rax
  803339:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80333c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803340:	79 05                	jns    803347 <pipe+0xe3>
		goto err2;
  803342:	e9 d9 00 00 00       	jmpq   803420 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803347:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80334b:	48 89 c7             	mov    %rax,%rdi
  80334e:	48 b8 07 25 80 00 00 	movabs $0x802507,%rax
  803355:	00 00 00 
  803358:	ff d0                	callq  *%rax
  80335a:	48 89 c2             	mov    %rax,%rdx
  80335d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803361:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803367:	48 89 d1             	mov    %rdx,%rcx
  80336a:	ba 00 00 00 00       	mov    $0x0,%edx
  80336f:	48 89 c6             	mov    %rax,%rsi
  803372:	bf 00 00 00 00       	mov    $0x0,%edi
  803377:	48 b8 e1 1b 80 00 00 	movabs $0x801be1,%rax
  80337e:	00 00 00 
  803381:	ff d0                	callq  *%rax
  803383:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803386:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80338a:	79 1b                	jns    8033a7 <pipe+0x143>
		goto err3;
  80338c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  80338d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803391:	48 89 c6             	mov    %rax,%rsi
  803394:	bf 00 00 00 00       	mov    $0x0,%edi
  803399:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  8033a0:	00 00 00 
  8033a3:	ff d0                	callq  *%rax
  8033a5:	eb 79                	jmp    803420 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8033a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033ab:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8033b2:	00 00 00 
  8033b5:	8b 12                	mov    (%rdx),%edx
  8033b7:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8033b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033bd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8033c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033c8:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8033cf:	00 00 00 
  8033d2:	8b 12                	mov    (%rdx),%edx
  8033d4:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8033d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033da:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8033e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033e5:	48 89 c7             	mov    %rax,%rdi
  8033e8:	48 b8 e4 24 80 00 00 	movabs $0x8024e4,%rax
  8033ef:	00 00 00 
  8033f2:	ff d0                	callq  *%rax
  8033f4:	89 c2                	mov    %eax,%edx
  8033f6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033fa:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8033fc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803400:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803404:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803408:	48 89 c7             	mov    %rax,%rdi
  80340b:	48 b8 e4 24 80 00 00 	movabs $0x8024e4,%rax
  803412:	00 00 00 
  803415:	ff d0                	callq  *%rax
  803417:	89 03                	mov    %eax,(%rbx)
	return 0;
  803419:	b8 00 00 00 00       	mov    $0x0,%eax
  80341e:	eb 33                	jmp    803453 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803420:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803424:	48 89 c6             	mov    %rax,%rsi
  803427:	bf 00 00 00 00       	mov    $0x0,%edi
  80342c:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  803433:	00 00 00 
  803436:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803438:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80343c:	48 89 c6             	mov    %rax,%rsi
  80343f:	bf 00 00 00 00       	mov    $0x0,%edi
  803444:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  80344b:	00 00 00 
  80344e:	ff d0                	callq  *%rax
    err:
	return r;
  803450:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803453:	48 83 c4 38          	add    $0x38,%rsp
  803457:	5b                   	pop    %rbx
  803458:	5d                   	pop    %rbp
  803459:	c3                   	retq   

000000000080345a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80345a:	55                   	push   %rbp
  80345b:	48 89 e5             	mov    %rsp,%rbp
  80345e:	53                   	push   %rbx
  80345f:	48 83 ec 28          	sub    $0x28,%rsp
  803463:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803467:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80346b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803472:	00 00 00 
  803475:	48 8b 00             	mov    (%rax),%rax
  803478:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80347e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803481:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803485:	48 89 c7             	mov    %rax,%rdi
  803488:	48 b8 d5 3b 80 00 00 	movabs $0x803bd5,%rax
  80348f:	00 00 00 
  803492:	ff d0                	callq  *%rax
  803494:	89 c3                	mov    %eax,%ebx
  803496:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80349a:	48 89 c7             	mov    %rax,%rdi
  80349d:	48 b8 d5 3b 80 00 00 	movabs $0x803bd5,%rax
  8034a4:	00 00 00 
  8034a7:	ff d0                	callq  *%rax
  8034a9:	39 c3                	cmp    %eax,%ebx
  8034ab:	0f 94 c0             	sete   %al
  8034ae:	0f b6 c0             	movzbl %al,%eax
  8034b1:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8034b4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034bb:	00 00 00 
  8034be:	48 8b 00             	mov    (%rax),%rax
  8034c1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034c7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8034ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034cd:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034d0:	75 05                	jne    8034d7 <_pipeisclosed+0x7d>
			return ret;
  8034d2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034d5:	eb 4f                	jmp    803526 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8034d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034da:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034dd:	74 42                	je     803521 <_pipeisclosed+0xc7>
  8034df:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8034e3:	75 3c                	jne    803521 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8034e5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034ec:	00 00 00 
  8034ef:	48 8b 00             	mov    (%rax),%rax
  8034f2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8034f8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8034fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034fe:	89 c6                	mov    %eax,%esi
  803500:	48 bf 73 42 80 00 00 	movabs $0x804273,%rdi
  803507:	00 00 00 
  80350a:	b8 00 00 00 00       	mov    $0x0,%eax
  80350f:	49 b8 ba 04 80 00 00 	movabs $0x8004ba,%r8
  803516:	00 00 00 
  803519:	41 ff d0             	callq  *%r8
	}
  80351c:	e9 4a ff ff ff       	jmpq   80346b <_pipeisclosed+0x11>
  803521:	e9 45 ff ff ff       	jmpq   80346b <_pipeisclosed+0x11>
}
  803526:	48 83 c4 28          	add    $0x28,%rsp
  80352a:	5b                   	pop    %rbx
  80352b:	5d                   	pop    %rbp
  80352c:	c3                   	retq   

000000000080352d <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80352d:	55                   	push   %rbp
  80352e:	48 89 e5             	mov    %rsp,%rbp
  803531:	48 83 ec 30          	sub    $0x30,%rsp
  803535:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803538:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80353c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80353f:	48 89 d6             	mov    %rdx,%rsi
  803542:	89 c7                	mov    %eax,%edi
  803544:	48 b8 ca 25 80 00 00 	movabs $0x8025ca,%rax
  80354b:	00 00 00 
  80354e:	ff d0                	callq  *%rax
  803550:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803553:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803557:	79 05                	jns    80355e <pipeisclosed+0x31>
		return r;
  803559:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355c:	eb 31                	jmp    80358f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80355e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803562:	48 89 c7             	mov    %rax,%rdi
  803565:	48 b8 07 25 80 00 00 	movabs $0x802507,%rax
  80356c:	00 00 00 
  80356f:	ff d0                	callq  *%rax
  803571:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803575:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803579:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80357d:	48 89 d6             	mov    %rdx,%rsi
  803580:	48 89 c7             	mov    %rax,%rdi
  803583:	48 b8 5a 34 80 00 00 	movabs $0x80345a,%rax
  80358a:	00 00 00 
  80358d:	ff d0                	callq  *%rax
}
  80358f:	c9                   	leaveq 
  803590:	c3                   	retq   

0000000000803591 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803591:	55                   	push   %rbp
  803592:	48 89 e5             	mov    %rsp,%rbp
  803595:	48 83 ec 40          	sub    $0x40,%rsp
  803599:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80359d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035a1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8035a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035a9:	48 89 c7             	mov    %rax,%rdi
  8035ac:	48 b8 07 25 80 00 00 	movabs $0x802507,%rax
  8035b3:	00 00 00 
  8035b6:	ff d0                	callq  *%rax
  8035b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035c0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035c4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035cb:	00 
  8035cc:	e9 92 00 00 00       	jmpq   803663 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8035d1:	eb 41                	jmp    803614 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8035d3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8035d8:	74 09                	je     8035e3 <devpipe_read+0x52>
				return i;
  8035da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035de:	e9 92 00 00 00       	jmpq   803675 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8035e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035eb:	48 89 d6             	mov    %rdx,%rsi
  8035ee:	48 89 c7             	mov    %rax,%rdi
  8035f1:	48 b8 5a 34 80 00 00 	movabs $0x80345a,%rax
  8035f8:	00 00 00 
  8035fb:	ff d0                	callq  *%rax
  8035fd:	85 c0                	test   %eax,%eax
  8035ff:	74 07                	je     803608 <devpipe_read+0x77>
				return 0;
  803601:	b8 00 00 00 00       	mov    $0x0,%eax
  803606:	eb 6d                	jmp    803675 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803608:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  80360f:	00 00 00 
  803612:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803614:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803618:	8b 10                	mov    (%rax),%edx
  80361a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80361e:	8b 40 04             	mov    0x4(%rax),%eax
  803621:	39 c2                	cmp    %eax,%edx
  803623:	74 ae                	je     8035d3 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803625:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803629:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80362d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803631:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803635:	8b 00                	mov    (%rax),%eax
  803637:	99                   	cltd   
  803638:	c1 ea 1b             	shr    $0x1b,%edx
  80363b:	01 d0                	add    %edx,%eax
  80363d:	83 e0 1f             	and    $0x1f,%eax
  803640:	29 d0                	sub    %edx,%eax
  803642:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803646:	48 98                	cltq   
  803648:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80364d:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80364f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803653:	8b 00                	mov    (%rax),%eax
  803655:	8d 50 01             	lea    0x1(%rax),%edx
  803658:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80365c:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80365e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803663:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803667:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80366b:	0f 82 60 ff ff ff    	jb     8035d1 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803671:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803675:	c9                   	leaveq 
  803676:	c3                   	retq   

0000000000803677 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803677:	55                   	push   %rbp
  803678:	48 89 e5             	mov    %rsp,%rbp
  80367b:	48 83 ec 40          	sub    $0x40,%rsp
  80367f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803683:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803687:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80368b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80368f:	48 89 c7             	mov    %rax,%rdi
  803692:	48 b8 07 25 80 00 00 	movabs $0x802507,%rax
  803699:	00 00 00 
  80369c:	ff d0                	callq  *%rax
  80369e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8036a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8036aa:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8036b1:	00 
  8036b2:	e9 8e 00 00 00       	jmpq   803745 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036b7:	eb 31                	jmp    8036ea <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8036b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036c1:	48 89 d6             	mov    %rdx,%rsi
  8036c4:	48 89 c7             	mov    %rax,%rdi
  8036c7:	48 b8 5a 34 80 00 00 	movabs $0x80345a,%rax
  8036ce:	00 00 00 
  8036d1:	ff d0                	callq  *%rax
  8036d3:	85 c0                	test   %eax,%eax
  8036d5:	74 07                	je     8036de <devpipe_write+0x67>
				return 0;
  8036d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8036dc:	eb 79                	jmp    803757 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8036de:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  8036e5:	00 00 00 
  8036e8:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ee:	8b 40 04             	mov    0x4(%rax),%eax
  8036f1:	48 63 d0             	movslq %eax,%rdx
  8036f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f8:	8b 00                	mov    (%rax),%eax
  8036fa:	48 98                	cltq   
  8036fc:	48 83 c0 20          	add    $0x20,%rax
  803700:	48 39 c2             	cmp    %rax,%rdx
  803703:	73 b4                	jae    8036b9 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803705:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803709:	8b 40 04             	mov    0x4(%rax),%eax
  80370c:	99                   	cltd   
  80370d:	c1 ea 1b             	shr    $0x1b,%edx
  803710:	01 d0                	add    %edx,%eax
  803712:	83 e0 1f             	and    $0x1f,%eax
  803715:	29 d0                	sub    %edx,%eax
  803717:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80371b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80371f:	48 01 ca             	add    %rcx,%rdx
  803722:	0f b6 0a             	movzbl (%rdx),%ecx
  803725:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803729:	48 98                	cltq   
  80372b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80372f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803733:	8b 40 04             	mov    0x4(%rax),%eax
  803736:	8d 50 01             	lea    0x1(%rax),%edx
  803739:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80373d:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803740:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803745:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803749:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80374d:	0f 82 64 ff ff ff    	jb     8036b7 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803753:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803757:	c9                   	leaveq 
  803758:	c3                   	retq   

0000000000803759 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803759:	55                   	push   %rbp
  80375a:	48 89 e5             	mov    %rsp,%rbp
  80375d:	48 83 ec 20          	sub    $0x20,%rsp
  803761:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803765:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803769:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80376d:	48 89 c7             	mov    %rax,%rdi
  803770:	48 b8 07 25 80 00 00 	movabs $0x802507,%rax
  803777:	00 00 00 
  80377a:	ff d0                	callq  *%rax
  80377c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803780:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803784:	48 be 86 42 80 00 00 	movabs $0x804286,%rsi
  80378b:	00 00 00 
  80378e:	48 89 c7             	mov    %rax,%rdi
  803791:	48 b8 62 12 80 00 00 	movabs $0x801262,%rax
  803798:	00 00 00 
  80379b:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80379d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037a1:	8b 50 04             	mov    0x4(%rax),%edx
  8037a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037a8:	8b 00                	mov    (%rax),%eax
  8037aa:	29 c2                	sub    %eax,%edx
  8037ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037b0:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8037b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037ba:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8037c1:	00 00 00 
	stat->st_dev = &devpipe;
  8037c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c8:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8037cf:	00 00 00 
  8037d2:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8037d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037de:	c9                   	leaveq 
  8037df:	c3                   	retq   

00000000008037e0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8037e0:	55                   	push   %rbp
  8037e1:	48 89 e5             	mov    %rsp,%rbp
  8037e4:	48 83 ec 10          	sub    $0x10,%rsp
  8037e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8037ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f0:	48 89 c6             	mov    %rax,%rsi
  8037f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8037f8:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  8037ff:	00 00 00 
  803802:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803804:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803808:	48 89 c7             	mov    %rax,%rdi
  80380b:	48 b8 07 25 80 00 00 	movabs $0x802507,%rax
  803812:	00 00 00 
  803815:	ff d0                	callq  *%rax
  803817:	48 89 c6             	mov    %rax,%rsi
  80381a:	bf 00 00 00 00       	mov    $0x0,%edi
  80381f:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  803826:	00 00 00 
  803829:	ff d0                	callq  *%rax
}
  80382b:	c9                   	leaveq 
  80382c:	c3                   	retq   

000000000080382d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80382d:	55                   	push   %rbp
  80382e:	48 89 e5             	mov    %rsp,%rbp
  803831:	48 83 ec 20          	sub    $0x20,%rsp
  803835:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803838:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80383b:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80383e:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803842:	be 01 00 00 00       	mov    $0x1,%esi
  803847:	48 89 c7             	mov    %rax,%rdi
  80384a:	48 b8 49 1a 80 00 00 	movabs $0x801a49,%rax
  803851:	00 00 00 
  803854:	ff d0                	callq  *%rax
}
  803856:	c9                   	leaveq 
  803857:	c3                   	retq   

0000000000803858 <getchar>:

int
getchar(void)
{
  803858:	55                   	push   %rbp
  803859:	48 89 e5             	mov    %rsp,%rbp
  80385c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803860:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803864:	ba 01 00 00 00       	mov    $0x1,%edx
  803869:	48 89 c6             	mov    %rax,%rsi
  80386c:	bf 00 00 00 00       	mov    $0x0,%edi
  803871:	48 b8 fc 29 80 00 00 	movabs $0x8029fc,%rax
  803878:	00 00 00 
  80387b:	ff d0                	callq  *%rax
  80387d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803880:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803884:	79 05                	jns    80388b <getchar+0x33>
		return r;
  803886:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803889:	eb 14                	jmp    80389f <getchar+0x47>
	if (r < 1)
  80388b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80388f:	7f 07                	jg     803898 <getchar+0x40>
		return -E_EOF;
  803891:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803896:	eb 07                	jmp    80389f <getchar+0x47>
	return c;
  803898:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80389c:	0f b6 c0             	movzbl %al,%eax
}
  80389f:	c9                   	leaveq 
  8038a0:	c3                   	retq   

00000000008038a1 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8038a1:	55                   	push   %rbp
  8038a2:	48 89 e5             	mov    %rsp,%rbp
  8038a5:	48 83 ec 20          	sub    $0x20,%rsp
  8038a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038ac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8038b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038b3:	48 89 d6             	mov    %rdx,%rsi
  8038b6:	89 c7                	mov    %eax,%edi
  8038b8:	48 b8 ca 25 80 00 00 	movabs $0x8025ca,%rax
  8038bf:	00 00 00 
  8038c2:	ff d0                	callq  *%rax
  8038c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038cb:	79 05                	jns    8038d2 <iscons+0x31>
		return r;
  8038cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d0:	eb 1a                	jmp    8038ec <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8038d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d6:	8b 10                	mov    (%rax),%edx
  8038d8:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8038df:	00 00 00 
  8038e2:	8b 00                	mov    (%rax),%eax
  8038e4:	39 c2                	cmp    %eax,%edx
  8038e6:	0f 94 c0             	sete   %al
  8038e9:	0f b6 c0             	movzbl %al,%eax
}
  8038ec:	c9                   	leaveq 
  8038ed:	c3                   	retq   

00000000008038ee <opencons>:

int
opencons(void)
{
  8038ee:	55                   	push   %rbp
  8038ef:	48 89 e5             	mov    %rsp,%rbp
  8038f2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8038f6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8038fa:	48 89 c7             	mov    %rax,%rdi
  8038fd:	48 b8 32 25 80 00 00 	movabs $0x802532,%rax
  803904:	00 00 00 
  803907:	ff d0                	callq  *%rax
  803909:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80390c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803910:	79 05                	jns    803917 <opencons+0x29>
		return r;
  803912:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803915:	eb 5b                	jmp    803972 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803917:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80391b:	ba 07 04 00 00       	mov    $0x407,%edx
  803920:	48 89 c6             	mov    %rax,%rsi
  803923:	bf 00 00 00 00       	mov    $0x0,%edi
  803928:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  80392f:	00 00 00 
  803932:	ff d0                	callq  *%rax
  803934:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803937:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80393b:	79 05                	jns    803942 <opencons+0x54>
		return r;
  80393d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803940:	eb 30                	jmp    803972 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803942:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803946:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  80394d:	00 00 00 
  803950:	8b 12                	mov    (%rdx),%edx
  803952:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803954:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803958:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80395f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803963:	48 89 c7             	mov    %rax,%rdi
  803966:	48 b8 e4 24 80 00 00 	movabs $0x8024e4,%rax
  80396d:	00 00 00 
  803970:	ff d0                	callq  *%rax
}
  803972:	c9                   	leaveq 
  803973:	c3                   	retq   

0000000000803974 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803974:	55                   	push   %rbp
  803975:	48 89 e5             	mov    %rsp,%rbp
  803978:	48 83 ec 30          	sub    $0x30,%rsp
  80397c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803980:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803984:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803988:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80398d:	75 07                	jne    803996 <devcons_read+0x22>
		return 0;
  80398f:	b8 00 00 00 00       	mov    $0x0,%eax
  803994:	eb 4b                	jmp    8039e1 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803996:	eb 0c                	jmp    8039a4 <devcons_read+0x30>
		sys_yield();
  803998:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  80399f:	00 00 00 
  8039a2:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8039a4:	48 b8 93 1a 80 00 00 	movabs $0x801a93,%rax
  8039ab:	00 00 00 
  8039ae:	ff d0                	callq  *%rax
  8039b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039b7:	74 df                	je     803998 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8039b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039bd:	79 05                	jns    8039c4 <devcons_read+0x50>
		return c;
  8039bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039c2:	eb 1d                	jmp    8039e1 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8039c4:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8039c8:	75 07                	jne    8039d1 <devcons_read+0x5d>
		return 0;
  8039ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8039cf:	eb 10                	jmp    8039e1 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8039d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039d4:	89 c2                	mov    %eax,%edx
  8039d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039da:	88 10                	mov    %dl,(%rax)
	return 1;
  8039dc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8039e1:	c9                   	leaveq 
  8039e2:	c3                   	retq   

00000000008039e3 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039e3:	55                   	push   %rbp
  8039e4:	48 89 e5             	mov    %rsp,%rbp
  8039e7:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8039ee:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8039f5:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8039fc:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a0a:	eb 76                	jmp    803a82 <devcons_write+0x9f>
		m = n - tot;
  803a0c:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a13:	89 c2                	mov    %eax,%edx
  803a15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a18:	29 c2                	sub    %eax,%edx
  803a1a:	89 d0                	mov    %edx,%eax
  803a1c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a1f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a22:	83 f8 7f             	cmp    $0x7f,%eax
  803a25:	76 07                	jbe    803a2e <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803a27:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a2e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a31:	48 63 d0             	movslq %eax,%rdx
  803a34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a37:	48 63 c8             	movslq %eax,%rcx
  803a3a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803a41:	48 01 c1             	add    %rax,%rcx
  803a44:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a4b:	48 89 ce             	mov    %rcx,%rsi
  803a4e:	48 89 c7             	mov    %rax,%rdi
  803a51:	48 b8 86 15 80 00 00 	movabs $0x801586,%rax
  803a58:	00 00 00 
  803a5b:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803a5d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a60:	48 63 d0             	movslq %eax,%rdx
  803a63:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a6a:	48 89 d6             	mov    %rdx,%rsi
  803a6d:	48 89 c7             	mov    %rax,%rdi
  803a70:	48 b8 49 1a 80 00 00 	movabs $0x801a49,%rax
  803a77:	00 00 00 
  803a7a:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a7f:	01 45 fc             	add    %eax,-0x4(%rbp)
  803a82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a85:	48 98                	cltq   
  803a87:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803a8e:	0f 82 78 ff ff ff    	jb     803a0c <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803a94:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a97:	c9                   	leaveq 
  803a98:	c3                   	retq   

0000000000803a99 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803a99:	55                   	push   %rbp
  803a9a:	48 89 e5             	mov    %rsp,%rbp
  803a9d:	48 83 ec 08          	sub    $0x8,%rsp
  803aa1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803aa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803aaa:	c9                   	leaveq 
  803aab:	c3                   	retq   

0000000000803aac <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803aac:	55                   	push   %rbp
  803aad:	48 89 e5             	mov    %rsp,%rbp
  803ab0:	48 83 ec 10          	sub    $0x10,%rsp
  803ab4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ab8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803abc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ac0:	48 be 92 42 80 00 00 	movabs $0x804292,%rsi
  803ac7:	00 00 00 
  803aca:	48 89 c7             	mov    %rax,%rdi
  803acd:	48 b8 62 12 80 00 00 	movabs $0x801262,%rax
  803ad4:	00 00 00 
  803ad7:	ff d0                	callq  *%rax
	return 0;
  803ad9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ade:	c9                   	leaveq 
  803adf:	c3                   	retq   

0000000000803ae0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803ae0:	55                   	push   %rbp
  803ae1:	48 89 e5             	mov    %rsp,%rbp
  803ae4:	48 83 ec 10          	sub    $0x10,%rsp
  803ae8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803aec:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803af3:	00 00 00 
  803af6:	48 8b 00             	mov    (%rax),%rax
  803af9:	48 85 c0             	test   %rax,%rax
  803afc:	75 3a                	jne    803b38 <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  803afe:	ba 07 00 00 00       	mov    $0x7,%edx
  803b03:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803b08:	bf 00 00 00 00       	mov    $0x0,%edi
  803b0d:	48 b8 91 1b 80 00 00 	movabs $0x801b91,%rax
  803b14:	00 00 00 
  803b17:	ff d0                	callq  *%rax
  803b19:	85 c0                	test   %eax,%eax
  803b1b:	75 1b                	jne    803b38 <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803b1d:	48 be 4b 3b 80 00 00 	movabs $0x803b4b,%rsi
  803b24:	00 00 00 
  803b27:	bf 00 00 00 00       	mov    $0x0,%edi
  803b2c:	48 b8 1b 1d 80 00 00 	movabs $0x801d1b,%rax
  803b33:	00 00 00 
  803b36:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803b38:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803b3f:	00 00 00 
  803b42:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b46:	48 89 10             	mov    %rdx,(%rax)
}
  803b49:	c9                   	leaveq 
  803b4a:	c3                   	retq   

0000000000803b4b <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803b4b:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803b4e:	48 a1 08 80 80 00 00 	movabs 0x808008,%rax
  803b55:	00 00 00 
	call *%rax
  803b58:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  803b5a:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  803b5d:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803b64:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  803b65:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  803b6c:	00 
	pushq %rbx		// push utf_rip into new stack
  803b6d:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  803b6e:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  803b75:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  803b78:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  803b7c:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  803b80:	4c 8b 3c 24          	mov    (%rsp),%r15
  803b84:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803b89:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803b8e:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803b93:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803b98:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803b9d:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803ba2:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803ba7:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803bac:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803bb1:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803bb6:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803bbb:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803bc0:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803bc5:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803bca:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  803bce:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  803bd2:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  803bd3:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803bd4:	c3                   	retq   

0000000000803bd5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803bd5:	55                   	push   %rbp
  803bd6:	48 89 e5             	mov    %rsp,%rbp
  803bd9:	48 83 ec 18          	sub    $0x18,%rsp
  803bdd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803be1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803be5:	48 c1 e8 15          	shr    $0x15,%rax
  803be9:	48 89 c2             	mov    %rax,%rdx
  803bec:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803bf3:	01 00 00 
  803bf6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bfa:	83 e0 01             	and    $0x1,%eax
  803bfd:	48 85 c0             	test   %rax,%rax
  803c00:	75 07                	jne    803c09 <pageref+0x34>
		return 0;
  803c02:	b8 00 00 00 00       	mov    $0x0,%eax
  803c07:	eb 53                	jmp    803c5c <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803c09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c0d:	48 c1 e8 0c          	shr    $0xc,%rax
  803c11:	48 89 c2             	mov    %rax,%rdx
  803c14:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c1b:	01 00 00 
  803c1e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c2a:	83 e0 01             	and    $0x1,%eax
  803c2d:	48 85 c0             	test   %rax,%rax
  803c30:	75 07                	jne    803c39 <pageref+0x64>
		return 0;
  803c32:	b8 00 00 00 00       	mov    $0x0,%eax
  803c37:	eb 23                	jmp    803c5c <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c3d:	48 c1 e8 0c          	shr    $0xc,%rax
  803c41:	48 89 c2             	mov    %rax,%rdx
  803c44:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c4b:	00 00 00 
  803c4e:	48 c1 e2 04          	shl    $0x4,%rdx
  803c52:	48 01 d0             	add    %rdx,%rax
  803c55:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c59:	0f b7 c0             	movzwl %ax,%eax
}
  803c5c:	c9                   	leaveq 
  803c5d:	c3                   	retq   
