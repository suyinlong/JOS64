
obj/user/stresssched.debug:     file format elf64-x86-64


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
  80003c:	e8 74 01 00 00       	callq  8001b5 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800052:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 f4             	mov    %eax,-0xc(%rbp)

	// Fork several environments
	for (i = 0; i < 20; i++)
  800061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800068:	eb 16                	jmp    800080 <umain+0x3d>
		if (fork() == 0)
  80006a:	48 b8 4e 20 80 00 00 	movabs $0x80204e,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	85 c0                	test   %eax,%eax
  800078:	75 02                	jne    80007c <umain+0x39>
			break;
  80007a:	eb 0a                	jmp    800086 <umain+0x43>
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();

	// Fork several environments
	for (i = 0; i < 20; i++)
  80007c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800080:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
  800084:	7e e4                	jle    80006a <umain+0x27>
		if (fork() == 0)
			break;
	if (i == 20) {
  800086:	83 7d fc 14          	cmpl   $0x14,-0x4(%rbp)
  80008a:	75 11                	jne    80009d <umain+0x5a>
		sys_yield();
  80008c:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  800093:	00 00 00 
  800096:	ff d0                	callq  *%rax
		return;
  800098:	e9 16 01 00 00       	jmpq   8001b3 <umain+0x170>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80009d:	eb 02                	jmp    8000a1 <umain+0x5e>
		asm volatile("pause");
  80009f:	f3 90                	pause  
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  8000a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8000b0:	00 00 00 
  8000b3:	48 63 d0             	movslq %eax,%rdx
  8000b6:	48 89 d0             	mov    %rdx,%rax
  8000b9:	48 c1 e0 03          	shl    $0x3,%rax
  8000bd:	48 01 d0             	add    %rdx,%rax
  8000c0:	48 c1 e0 05          	shl    $0x5,%rax
  8000c4:	48 01 c8             	add    %rcx,%rax
  8000c7:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8000cd:	8b 40 04             	mov    0x4(%rax),%eax
  8000d0:	85 c0                	test   %eax,%eax
  8000d2:	75 cb                	jne    80009f <umain+0x5c>
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  8000d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000db:	eb 41                	jmp    80011e <umain+0xdb>
		sys_yield();
  8000dd:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
		for (j = 0; j < 10000; j++)
  8000e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8000f0:	eb 1f                	jmp    800111 <umain+0xce>
			counter++;
  8000f2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000f9:	00 00 00 
  8000fc:	8b 00                	mov    (%rax),%eax
  8000fe:	8d 50 01             	lea    0x1(%rax),%edx
  800101:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800108:	00 00 00 
  80010b:	89 10                	mov    %edx,(%rax)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
		for (j = 0; j < 10000; j++)
  80010d:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800111:	81 7d f8 0f 27 00 00 	cmpl   $0x270f,-0x8(%rbp)
  800118:	7e d8                	jle    8000f2 <umain+0xaf>
	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  80011a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80011e:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  800122:	7e b9                	jle    8000dd <umain+0x9a>
		sys_yield();
		for (j = 0; j < 10000; j++)
			counter++;
	}

	if (counter != 10*10000)
  800124:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80012b:	00 00 00 
  80012e:	8b 00                	mov    (%rax),%eax
  800130:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  800135:	74 39                	je     800170 <umain+0x12d>
		panic("ran on two CPUs at once (counter is %d)", counter);
  800137:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80013e:	00 00 00 
  800141:	8b 00                	mov    (%rax),%eax
  800143:	89 c1                	mov    %eax,%ecx
  800145:	48 ba 60 3c 80 00 00 	movabs $0x803c60,%rdx
  80014c:	00 00 00 
  80014f:	be 21 00 00 00       	mov    $0x21,%esi
  800154:	48 bf 88 3c 80 00 00 	movabs $0x803c88,%rdi
  80015b:	00 00 00 
  80015e:	b8 00 00 00 00       	mov    $0x0,%eax
  800163:	49 b8 68 02 80 00 00 	movabs $0x800268,%r8
  80016a:	00 00 00 
  80016d:	41 ff d0             	callq  *%r8

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  800170:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800177:	00 00 00 
  80017a:	48 8b 00             	mov    (%rax),%rax
  80017d:	8b 90 dc 00 00 00    	mov    0xdc(%rax),%edx
  800183:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  80018a:	00 00 00 
  80018d:	48 8b 00             	mov    (%rax),%rax
  800190:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800196:	89 c6                	mov    %eax,%esi
  800198:	48 bf 9b 3c 80 00 00 	movabs $0x803c9b,%rdi
  80019f:	00 00 00 
  8001a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a7:	48 b9 a1 04 80 00 00 	movabs $0x8004a1,%rcx
  8001ae:	00 00 00 
  8001b1:	ff d1                	callq  *%rcx

}
  8001b3:	c9                   	leaveq 
  8001b4:	c3                   	retq   

00000000008001b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001b5:	55                   	push   %rbp
  8001b6:	48 89 e5             	mov    %rsp,%rbp
  8001b9:	48 83 ec 10          	sub    $0x10,%rsp
  8001bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8001c4:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  8001cb:	00 00 00 
  8001ce:	ff d0                	callq  *%rax
  8001d0:	48 98                	cltq   
  8001d2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d7:	48 89 c2             	mov    %rax,%rdx
  8001da:	48 89 d0             	mov    %rdx,%rax
  8001dd:	48 c1 e0 03          	shl    $0x3,%rax
  8001e1:	48 01 d0             	add    %rdx,%rax
  8001e4:	48 c1 e0 05          	shl    $0x5,%rax
  8001e8:	48 89 c2             	mov    %rax,%rdx
  8001eb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001f2:	00 00 00 
  8001f5:	48 01 c2             	add    %rax,%rdx
  8001f8:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8001ff:	00 00 00 
  800202:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800205:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800209:	7e 14                	jle    80021f <libmain+0x6a>
		binaryname = argv[0];
  80020b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020f:	48 8b 10             	mov    (%rax),%rdx
  800212:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800219:	00 00 00 
  80021c:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80021f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800223:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800226:	48 89 d6             	mov    %rdx,%rsi
  800229:	89 c7                	mov    %eax,%edi
  80022b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800232:	00 00 00 
  800235:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800237:	48 b8 45 02 80 00 00 	movabs $0x800245,%rax
  80023e:	00 00 00 
  800241:	ff d0                	callq  *%rax
}
  800243:	c9                   	leaveq 
  800244:	c3                   	retq   

0000000000800245 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800245:	55                   	push   %rbp
  800246:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800249:	48 b8 29 26 80 00 00 	movabs $0x802629,%rax
  800250:	00 00 00 
  800253:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800255:	bf 00 00 00 00       	mov    $0x0,%edi
  80025a:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  800261:	00 00 00 
  800264:	ff d0                	callq  *%rax
}
  800266:	5d                   	pop    %rbp
  800267:	c3                   	retq   

0000000000800268 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800268:	55                   	push   %rbp
  800269:	48 89 e5             	mov    %rsp,%rbp
  80026c:	53                   	push   %rbx
  80026d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800274:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80027b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800281:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800288:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80028f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800296:	84 c0                	test   %al,%al
  800298:	74 23                	je     8002bd <_panic+0x55>
  80029a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002a1:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002a5:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002a9:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002ad:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002b1:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002b5:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002b9:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002bd:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002c4:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002cb:	00 00 00 
  8002ce:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002d5:	00 00 00 
  8002d8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002dc:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002e3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002ea:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002f1:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8002f8:	00 00 00 
  8002fb:	48 8b 18             	mov    (%rax),%rbx
  8002fe:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  800305:	00 00 00 
  800308:	ff d0                	callq  *%rax
  80030a:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800310:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800317:	41 89 c8             	mov    %ecx,%r8d
  80031a:	48 89 d1             	mov    %rdx,%rcx
  80031d:	48 89 da             	mov    %rbx,%rdx
  800320:	89 c6                	mov    %eax,%esi
  800322:	48 bf c8 3c 80 00 00 	movabs $0x803cc8,%rdi
  800329:	00 00 00 
  80032c:	b8 00 00 00 00       	mov    $0x0,%eax
  800331:	49 b9 a1 04 80 00 00 	movabs $0x8004a1,%r9
  800338:	00 00 00 
  80033b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80033e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800345:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80034c:	48 89 d6             	mov    %rdx,%rsi
  80034f:	48 89 c7             	mov    %rax,%rdi
  800352:	48 b8 f5 03 80 00 00 	movabs $0x8003f5,%rax
  800359:	00 00 00 
  80035c:	ff d0                	callq  *%rax
	cprintf("\n");
  80035e:	48 bf eb 3c 80 00 00 	movabs $0x803ceb,%rdi
  800365:	00 00 00 
  800368:	b8 00 00 00 00       	mov    $0x0,%eax
  80036d:	48 ba a1 04 80 00 00 	movabs $0x8004a1,%rdx
  800374:	00 00 00 
  800377:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800379:	cc                   	int3   
  80037a:	eb fd                	jmp    800379 <_panic+0x111>

000000000080037c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80037c:	55                   	push   %rbp
  80037d:	48 89 e5             	mov    %rsp,%rbp
  800380:	48 83 ec 10          	sub    $0x10,%rsp
  800384:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800387:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80038b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038f:	8b 00                	mov    (%rax),%eax
  800391:	8d 48 01             	lea    0x1(%rax),%ecx
  800394:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800398:	89 0a                	mov    %ecx,(%rdx)
  80039a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80039d:	89 d1                	mov    %edx,%ecx
  80039f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a3:	48 98                	cltq   
  8003a5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8003a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ad:	8b 00                	mov    (%rax),%eax
  8003af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b4:	75 2c                	jne    8003e2 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8003b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ba:	8b 00                	mov    (%rax),%eax
  8003bc:	48 98                	cltq   
  8003be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c2:	48 83 c2 08          	add    $0x8,%rdx
  8003c6:	48 89 c6             	mov    %rax,%rsi
  8003c9:	48 89 d7             	mov    %rdx,%rdi
  8003cc:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  8003d3:	00 00 00 
  8003d6:	ff d0                	callq  *%rax
		b->idx = 0;
  8003d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003dc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8003e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e6:	8b 40 04             	mov    0x4(%rax),%eax
  8003e9:	8d 50 01             	lea    0x1(%rax),%edx
  8003ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f0:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003f3:	c9                   	leaveq 
  8003f4:	c3                   	retq   

00000000008003f5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003f5:	55                   	push   %rbp
  8003f6:	48 89 e5             	mov    %rsp,%rbp
  8003f9:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800400:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800407:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80040e:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800415:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80041c:	48 8b 0a             	mov    (%rdx),%rcx
  80041f:	48 89 08             	mov    %rcx,(%rax)
  800422:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800426:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80042a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80042e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800432:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800439:	00 00 00 
	b.cnt = 0;
  80043c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800443:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800446:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80044d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800454:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80045b:	48 89 c6             	mov    %rax,%rsi
  80045e:	48 bf 7c 03 80 00 00 	movabs $0x80037c,%rdi
  800465:	00 00 00 
  800468:	48 b8 54 08 80 00 00 	movabs $0x800854,%rax
  80046f:	00 00 00 
  800472:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800474:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80047a:	48 98                	cltq   
  80047c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800483:	48 83 c2 08          	add    $0x8,%rdx
  800487:	48 89 c6             	mov    %rax,%rsi
  80048a:	48 89 d7             	mov    %rdx,%rdi
  80048d:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  800494:	00 00 00 
  800497:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800499:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80049f:	c9                   	leaveq 
  8004a0:	c3                   	retq   

00000000008004a1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004a1:	55                   	push   %rbp
  8004a2:	48 89 e5             	mov    %rsp,%rbp
  8004a5:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004ac:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004b3:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004ba:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004c1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004c8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004cf:	84 c0                	test   %al,%al
  8004d1:	74 20                	je     8004f3 <cprintf+0x52>
  8004d3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004d7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004db:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004df:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004e3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004e7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004eb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004ef:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004f3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8004fa:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800501:	00 00 00 
  800504:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80050b:	00 00 00 
  80050e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800512:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800519:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800520:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800527:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80052e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800535:	48 8b 0a             	mov    (%rdx),%rcx
  800538:	48 89 08             	mov    %rcx,(%rax)
  80053b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80053f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800543:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800547:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80054b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800552:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800559:	48 89 d6             	mov    %rdx,%rsi
  80055c:	48 89 c7             	mov    %rax,%rdi
  80055f:	48 b8 f5 03 80 00 00 	movabs $0x8003f5,%rax
  800566:	00 00 00 
  800569:	ff d0                	callq  *%rax
  80056b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800571:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800577:	c9                   	leaveq 
  800578:	c3                   	retq   

0000000000800579 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800579:	55                   	push   %rbp
  80057a:	48 89 e5             	mov    %rsp,%rbp
  80057d:	53                   	push   %rbx
  80057e:	48 83 ec 38          	sub    $0x38,%rsp
  800582:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800586:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80058a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80058e:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800591:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800595:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800599:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80059c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005a0:	77 3b                	ja     8005dd <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005a2:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005a5:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005a9:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b5:	48 f7 f3             	div    %rbx
  8005b8:	48 89 c2             	mov    %rax,%rdx
  8005bb:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005be:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005c1:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c9:	41 89 f9             	mov    %edi,%r9d
  8005cc:	48 89 c7             	mov    %rax,%rdi
  8005cf:	48 b8 79 05 80 00 00 	movabs $0x800579,%rax
  8005d6:	00 00 00 
  8005d9:	ff d0                	callq  *%rax
  8005db:	eb 1e                	jmp    8005fb <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005dd:	eb 12                	jmp    8005f1 <printnum+0x78>
			putch(padc, putdat);
  8005df:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005e3:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ea:	48 89 ce             	mov    %rcx,%rsi
  8005ed:	89 d7                	mov    %edx,%edi
  8005ef:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f1:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005f5:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005f9:	7f e4                	jg     8005df <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005fb:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800602:	ba 00 00 00 00       	mov    $0x0,%edx
  800607:	48 f7 f1             	div    %rcx
  80060a:	48 89 d0             	mov    %rdx,%rax
  80060d:	48 ba c8 3e 80 00 00 	movabs $0x803ec8,%rdx
  800614:	00 00 00 
  800617:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80061b:	0f be d0             	movsbl %al,%edx
  80061e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800626:	48 89 ce             	mov    %rcx,%rsi
  800629:	89 d7                	mov    %edx,%edi
  80062b:	ff d0                	callq  *%rax
}
  80062d:	48 83 c4 38          	add    $0x38,%rsp
  800631:	5b                   	pop    %rbx
  800632:	5d                   	pop    %rbp
  800633:	c3                   	retq   

0000000000800634 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800634:	55                   	push   %rbp
  800635:	48 89 e5             	mov    %rsp,%rbp
  800638:	48 83 ec 1c          	sub    $0x1c,%rsp
  80063c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800640:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800643:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800647:	7e 52                	jle    80069b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064d:	8b 00                	mov    (%rax),%eax
  80064f:	83 f8 30             	cmp    $0x30,%eax
  800652:	73 24                	jae    800678 <getuint+0x44>
  800654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800658:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80065c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800660:	8b 00                	mov    (%rax),%eax
  800662:	89 c0                	mov    %eax,%eax
  800664:	48 01 d0             	add    %rdx,%rax
  800667:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066b:	8b 12                	mov    (%rdx),%edx
  80066d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800670:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800674:	89 0a                	mov    %ecx,(%rdx)
  800676:	eb 17                	jmp    80068f <getuint+0x5b>
  800678:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800680:	48 89 d0             	mov    %rdx,%rax
  800683:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800687:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80068f:	48 8b 00             	mov    (%rax),%rax
  800692:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800696:	e9 a3 00 00 00       	jmpq   80073e <getuint+0x10a>
	else if (lflag)
  80069b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80069f:	74 4f                	je     8006f0 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a5:	8b 00                	mov    (%rax),%eax
  8006a7:	83 f8 30             	cmp    $0x30,%eax
  8006aa:	73 24                	jae    8006d0 <getuint+0x9c>
  8006ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b8:	8b 00                	mov    (%rax),%eax
  8006ba:	89 c0                	mov    %eax,%eax
  8006bc:	48 01 d0             	add    %rdx,%rax
  8006bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c3:	8b 12                	mov    (%rdx),%edx
  8006c5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006cc:	89 0a                	mov    %ecx,(%rdx)
  8006ce:	eb 17                	jmp    8006e7 <getuint+0xb3>
  8006d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006d8:	48 89 d0             	mov    %rdx,%rax
  8006db:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e7:	48 8b 00             	mov    (%rax),%rax
  8006ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ee:	eb 4e                	jmp    80073e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f4:	8b 00                	mov    (%rax),%eax
  8006f6:	83 f8 30             	cmp    $0x30,%eax
  8006f9:	73 24                	jae    80071f <getuint+0xeb>
  8006fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ff:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800703:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800707:	8b 00                	mov    (%rax),%eax
  800709:	89 c0                	mov    %eax,%eax
  80070b:	48 01 d0             	add    %rdx,%rax
  80070e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800712:	8b 12                	mov    (%rdx),%edx
  800714:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800717:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071b:	89 0a                	mov    %ecx,(%rdx)
  80071d:	eb 17                	jmp    800736 <getuint+0x102>
  80071f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800723:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800727:	48 89 d0             	mov    %rdx,%rax
  80072a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80072e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800732:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800736:	8b 00                	mov    (%rax),%eax
  800738:	89 c0                	mov    %eax,%eax
  80073a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80073e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800742:	c9                   	leaveq 
  800743:	c3                   	retq   

0000000000800744 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800744:	55                   	push   %rbp
  800745:	48 89 e5             	mov    %rsp,%rbp
  800748:	48 83 ec 1c          	sub    $0x1c,%rsp
  80074c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800750:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800753:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800757:	7e 52                	jle    8007ab <getint+0x67>
		x=va_arg(*ap, long long);
  800759:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075d:	8b 00                	mov    (%rax),%eax
  80075f:	83 f8 30             	cmp    $0x30,%eax
  800762:	73 24                	jae    800788 <getint+0x44>
  800764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800768:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80076c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800770:	8b 00                	mov    (%rax),%eax
  800772:	89 c0                	mov    %eax,%eax
  800774:	48 01 d0             	add    %rdx,%rax
  800777:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077b:	8b 12                	mov    (%rdx),%edx
  80077d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800780:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800784:	89 0a                	mov    %ecx,(%rdx)
  800786:	eb 17                	jmp    80079f <getint+0x5b>
  800788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800790:	48 89 d0             	mov    %rdx,%rax
  800793:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800797:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80079f:	48 8b 00             	mov    (%rax),%rax
  8007a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007a6:	e9 a3 00 00 00       	jmpq   80084e <getint+0x10a>
	else if (lflag)
  8007ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007af:	74 4f                	je     800800 <getint+0xbc>
		x=va_arg(*ap, long);
  8007b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b5:	8b 00                	mov    (%rax),%eax
  8007b7:	83 f8 30             	cmp    $0x30,%eax
  8007ba:	73 24                	jae    8007e0 <getint+0x9c>
  8007bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c8:	8b 00                	mov    (%rax),%eax
  8007ca:	89 c0                	mov    %eax,%eax
  8007cc:	48 01 d0             	add    %rdx,%rax
  8007cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d3:	8b 12                	mov    (%rdx),%edx
  8007d5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007dc:	89 0a                	mov    %ecx,(%rdx)
  8007de:	eb 17                	jmp    8007f7 <getint+0xb3>
  8007e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007e8:	48 89 d0             	mov    %rdx,%rax
  8007eb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007f7:	48 8b 00             	mov    (%rax),%rax
  8007fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007fe:	eb 4e                	jmp    80084e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800800:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800804:	8b 00                	mov    (%rax),%eax
  800806:	83 f8 30             	cmp    $0x30,%eax
  800809:	73 24                	jae    80082f <getint+0xeb>
  80080b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800817:	8b 00                	mov    (%rax),%eax
  800819:	89 c0                	mov    %eax,%eax
  80081b:	48 01 d0             	add    %rdx,%rax
  80081e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800822:	8b 12                	mov    (%rdx),%edx
  800824:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800827:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082b:	89 0a                	mov    %ecx,(%rdx)
  80082d:	eb 17                	jmp    800846 <getint+0x102>
  80082f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800833:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800837:	48 89 d0             	mov    %rdx,%rax
  80083a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80083e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800842:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800846:	8b 00                	mov    (%rax),%eax
  800848:	48 98                	cltq   
  80084a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80084e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800852:	c9                   	leaveq 
  800853:	c3                   	retq   

0000000000800854 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800854:	55                   	push   %rbp
  800855:	48 89 e5             	mov    %rsp,%rbp
  800858:	41 54                	push   %r12
  80085a:	53                   	push   %rbx
  80085b:	48 83 ec 60          	sub    $0x60,%rsp
  80085f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800863:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800867:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80086b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80086f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800873:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800877:	48 8b 0a             	mov    (%rdx),%rcx
  80087a:	48 89 08             	mov    %rcx,(%rax)
  80087d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800881:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800885:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800889:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  80088d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800891:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800895:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800899:	0f b6 00             	movzbl (%rax),%eax
  80089c:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  80089f:	eb 29                	jmp    8008ca <vprintfmt+0x76>
			if (ch == '\0')
  8008a1:	85 db                	test   %ebx,%ebx
  8008a3:	0f 84 ad 06 00 00    	je     800f56 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  8008a9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008ad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b1:	48 89 d6             	mov    %rdx,%rsi
  8008b4:	89 df                	mov    %ebx,%edi
  8008b6:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  8008b8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008bc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008c0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008c4:	0f b6 00             	movzbl (%rax),%eax
  8008c7:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  8008ca:	83 fb 25             	cmp    $0x25,%ebx
  8008cd:	74 05                	je     8008d4 <vprintfmt+0x80>
  8008cf:	83 fb 1b             	cmp    $0x1b,%ebx
  8008d2:	75 cd                	jne    8008a1 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  8008d4:	83 fb 1b             	cmp    $0x1b,%ebx
  8008d7:	0f 85 ae 01 00 00    	jne    800a8b <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  8008dd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8008e4:	00 00 00 
  8008e7:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  8008ed:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008f1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f5:	48 89 d6             	mov    %rdx,%rsi
  8008f8:	89 df                	mov    %ebx,%edi
  8008fa:	ff d0                	callq  *%rax
			putch('[', putdat);
  8008fc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800900:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800904:	48 89 d6             	mov    %rdx,%rsi
  800907:	bf 5b 00 00 00       	mov    $0x5b,%edi
  80090c:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  80090e:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800914:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800919:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80091d:	0f b6 00             	movzbl (%rax),%eax
  800920:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800923:	eb 32                	jmp    800957 <vprintfmt+0x103>
					putch(ch, putdat);
  800925:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800929:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80092d:	48 89 d6             	mov    %rdx,%rsi
  800930:	89 df                	mov    %ebx,%edi
  800932:	ff d0                	callq  *%rax
					esc_color *= 10;
  800934:	44 89 e0             	mov    %r12d,%eax
  800937:	c1 e0 02             	shl    $0x2,%eax
  80093a:	44 01 e0             	add    %r12d,%eax
  80093d:	01 c0                	add    %eax,%eax
  80093f:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800942:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800945:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800948:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80094d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800951:	0f b6 00             	movzbl (%rax),%eax
  800954:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800957:	83 fb 3b             	cmp    $0x3b,%ebx
  80095a:	74 05                	je     800961 <vprintfmt+0x10d>
  80095c:	83 fb 6d             	cmp    $0x6d,%ebx
  80095f:	75 c4                	jne    800925 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800961:	45 85 e4             	test   %r12d,%r12d
  800964:	75 15                	jne    80097b <vprintfmt+0x127>
					color_flag = 0x07;
  800966:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80096d:	00 00 00 
  800970:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800976:	e9 dc 00 00 00       	jmpq   800a57 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  80097b:	41 83 fc 1d          	cmp    $0x1d,%r12d
  80097f:	7e 69                	jle    8009ea <vprintfmt+0x196>
  800981:	41 83 fc 25          	cmp    $0x25,%r12d
  800985:	7f 63                	jg     8009ea <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800987:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80098e:	00 00 00 
  800991:	8b 00                	mov    (%rax),%eax
  800993:	25 f8 00 00 00       	and    $0xf8,%eax
  800998:	89 c2                	mov    %eax,%edx
  80099a:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8009a1:	00 00 00 
  8009a4:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  8009a6:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  8009aa:	44 89 e0             	mov    %r12d,%eax
  8009ad:	83 e0 04             	and    $0x4,%eax
  8009b0:	c1 f8 02             	sar    $0x2,%eax
  8009b3:	89 c2                	mov    %eax,%edx
  8009b5:	44 89 e0             	mov    %r12d,%eax
  8009b8:	83 e0 02             	and    $0x2,%eax
  8009bb:	09 c2                	or     %eax,%edx
  8009bd:	44 89 e0             	mov    %r12d,%eax
  8009c0:	83 e0 01             	and    $0x1,%eax
  8009c3:	c1 e0 02             	shl    $0x2,%eax
  8009c6:	09 c2                	or     %eax,%edx
  8009c8:	41 89 d4             	mov    %edx,%r12d
  8009cb:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8009d2:	00 00 00 
  8009d5:	8b 00                	mov    (%rax),%eax
  8009d7:	44 89 e2             	mov    %r12d,%edx
  8009da:	09 c2                	or     %eax,%edx
  8009dc:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8009e3:	00 00 00 
  8009e6:	89 10                	mov    %edx,(%rax)
  8009e8:	eb 6d                	jmp    800a57 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  8009ea:	41 83 fc 27          	cmp    $0x27,%r12d
  8009ee:	7e 67                	jle    800a57 <vprintfmt+0x203>
  8009f0:	41 83 fc 2f          	cmp    $0x2f,%r12d
  8009f4:	7f 61                	jg     800a57 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  8009f6:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8009fd:	00 00 00 
  800a00:	8b 00                	mov    (%rax),%eax
  800a02:	25 8f 00 00 00       	and    $0x8f,%eax
  800a07:	89 c2                	mov    %eax,%edx
  800a09:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800a10:	00 00 00 
  800a13:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800a15:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800a19:	44 89 e0             	mov    %r12d,%eax
  800a1c:	83 e0 04             	and    $0x4,%eax
  800a1f:	c1 f8 02             	sar    $0x2,%eax
  800a22:	89 c2                	mov    %eax,%edx
  800a24:	44 89 e0             	mov    %r12d,%eax
  800a27:	83 e0 02             	and    $0x2,%eax
  800a2a:	09 c2                	or     %eax,%edx
  800a2c:	44 89 e0             	mov    %r12d,%eax
  800a2f:	83 e0 01             	and    $0x1,%eax
  800a32:	c1 e0 06             	shl    $0x6,%eax
  800a35:	09 c2                	or     %eax,%edx
  800a37:	41 89 d4             	mov    %edx,%r12d
  800a3a:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800a41:	00 00 00 
  800a44:	8b 00                	mov    (%rax),%eax
  800a46:	44 89 e2             	mov    %r12d,%edx
  800a49:	09 c2                	or     %eax,%edx
  800a4b:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800a52:	00 00 00 
  800a55:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800a57:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a5b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5f:	48 89 d6             	mov    %rdx,%rsi
  800a62:	89 df                	mov    %ebx,%edi
  800a64:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800a66:	83 fb 6d             	cmp    $0x6d,%ebx
  800a69:	75 1b                	jne    800a86 <vprintfmt+0x232>
					fmt ++;
  800a6b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800a70:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800a71:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800a78:	00 00 00 
  800a7b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800a81:	e9 cb 04 00 00       	jmpq   800f51 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800a86:	e9 83 fe ff ff       	jmpq   80090e <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800a8b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a8f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a96:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a9d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800aa4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800aab:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aaf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ab3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ab7:	0f b6 00             	movzbl (%rax),%eax
  800aba:	0f b6 d8             	movzbl %al,%ebx
  800abd:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800ac0:	83 f8 55             	cmp    $0x55,%eax
  800ac3:	0f 87 5a 04 00 00    	ja     800f23 <vprintfmt+0x6cf>
  800ac9:	89 c0                	mov    %eax,%eax
  800acb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ad2:	00 
  800ad3:	48 b8 f0 3e 80 00 00 	movabs $0x803ef0,%rax
  800ada:	00 00 00 
  800add:	48 01 d0             	add    %rdx,%rax
  800ae0:	48 8b 00             	mov    (%rax),%rax
  800ae3:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ae5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ae9:	eb c0                	jmp    800aab <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aeb:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800aef:	eb ba                	jmp    800aab <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800af1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800af8:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800afb:	89 d0                	mov    %edx,%eax
  800afd:	c1 e0 02             	shl    $0x2,%eax
  800b00:	01 d0                	add    %edx,%eax
  800b02:	01 c0                	add    %eax,%eax
  800b04:	01 d8                	add    %ebx,%eax
  800b06:	83 e8 30             	sub    $0x30,%eax
  800b09:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b0c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b10:	0f b6 00             	movzbl (%rax),%eax
  800b13:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b16:	83 fb 2f             	cmp    $0x2f,%ebx
  800b19:	7e 0c                	jle    800b27 <vprintfmt+0x2d3>
  800b1b:	83 fb 39             	cmp    $0x39,%ebx
  800b1e:	7f 07                	jg     800b27 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b20:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b25:	eb d1                	jmp    800af8 <vprintfmt+0x2a4>
			goto process_precision;
  800b27:	eb 58                	jmp    800b81 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800b29:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b2c:	83 f8 30             	cmp    $0x30,%eax
  800b2f:	73 17                	jae    800b48 <vprintfmt+0x2f4>
  800b31:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b35:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b38:	89 c0                	mov    %eax,%eax
  800b3a:	48 01 d0             	add    %rdx,%rax
  800b3d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b40:	83 c2 08             	add    $0x8,%edx
  800b43:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b46:	eb 0f                	jmp    800b57 <vprintfmt+0x303>
  800b48:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b4c:	48 89 d0             	mov    %rdx,%rax
  800b4f:	48 83 c2 08          	add    $0x8,%rdx
  800b53:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b57:	8b 00                	mov    (%rax),%eax
  800b59:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b5c:	eb 23                	jmp    800b81 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800b5e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b62:	79 0c                	jns    800b70 <vprintfmt+0x31c>
				width = 0;
  800b64:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b6b:	e9 3b ff ff ff       	jmpq   800aab <vprintfmt+0x257>
  800b70:	e9 36 ff ff ff       	jmpq   800aab <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800b75:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b7c:	e9 2a ff ff ff       	jmpq   800aab <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800b81:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b85:	79 12                	jns    800b99 <vprintfmt+0x345>
				width = precision, precision = -1;
  800b87:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b8a:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b8d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b94:	e9 12 ff ff ff       	jmpq   800aab <vprintfmt+0x257>
  800b99:	e9 0d ff ff ff       	jmpq   800aab <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b9e:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ba2:	e9 04 ff ff ff       	jmpq   800aab <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ba7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800baa:	83 f8 30             	cmp    $0x30,%eax
  800bad:	73 17                	jae    800bc6 <vprintfmt+0x372>
  800baf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bb3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb6:	89 c0                	mov    %eax,%eax
  800bb8:	48 01 d0             	add    %rdx,%rax
  800bbb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bbe:	83 c2 08             	add    $0x8,%edx
  800bc1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bc4:	eb 0f                	jmp    800bd5 <vprintfmt+0x381>
  800bc6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bca:	48 89 d0             	mov    %rdx,%rax
  800bcd:	48 83 c2 08          	add    $0x8,%rdx
  800bd1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bd5:	8b 10                	mov    (%rax),%edx
  800bd7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bdb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bdf:	48 89 ce             	mov    %rcx,%rsi
  800be2:	89 d7                	mov    %edx,%edi
  800be4:	ff d0                	callq  *%rax
			break;
  800be6:	e9 66 03 00 00       	jmpq   800f51 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800beb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bee:	83 f8 30             	cmp    $0x30,%eax
  800bf1:	73 17                	jae    800c0a <vprintfmt+0x3b6>
  800bf3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bf7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bfa:	89 c0                	mov    %eax,%eax
  800bfc:	48 01 d0             	add    %rdx,%rax
  800bff:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c02:	83 c2 08             	add    $0x8,%edx
  800c05:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c08:	eb 0f                	jmp    800c19 <vprintfmt+0x3c5>
  800c0a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c0e:	48 89 d0             	mov    %rdx,%rax
  800c11:	48 83 c2 08          	add    $0x8,%rdx
  800c15:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c19:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c1b:	85 db                	test   %ebx,%ebx
  800c1d:	79 02                	jns    800c21 <vprintfmt+0x3cd>
				err = -err;
  800c1f:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c21:	83 fb 10             	cmp    $0x10,%ebx
  800c24:	7f 16                	jg     800c3c <vprintfmt+0x3e8>
  800c26:	48 b8 40 3e 80 00 00 	movabs $0x803e40,%rax
  800c2d:	00 00 00 
  800c30:	48 63 d3             	movslq %ebx,%rdx
  800c33:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c37:	4d 85 e4             	test   %r12,%r12
  800c3a:	75 2e                	jne    800c6a <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800c3c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c44:	89 d9                	mov    %ebx,%ecx
  800c46:	48 ba d9 3e 80 00 00 	movabs $0x803ed9,%rdx
  800c4d:	00 00 00 
  800c50:	48 89 c7             	mov    %rax,%rdi
  800c53:	b8 00 00 00 00       	mov    $0x0,%eax
  800c58:	49 b8 5f 0f 80 00 00 	movabs $0x800f5f,%r8
  800c5f:	00 00 00 
  800c62:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c65:	e9 e7 02 00 00       	jmpq   800f51 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c6a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c72:	4c 89 e1             	mov    %r12,%rcx
  800c75:	48 ba e2 3e 80 00 00 	movabs $0x803ee2,%rdx
  800c7c:	00 00 00 
  800c7f:	48 89 c7             	mov    %rax,%rdi
  800c82:	b8 00 00 00 00       	mov    $0x0,%eax
  800c87:	49 b8 5f 0f 80 00 00 	movabs $0x800f5f,%r8
  800c8e:	00 00 00 
  800c91:	41 ff d0             	callq  *%r8
			break;
  800c94:	e9 b8 02 00 00       	jmpq   800f51 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c99:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9c:	83 f8 30             	cmp    $0x30,%eax
  800c9f:	73 17                	jae    800cb8 <vprintfmt+0x464>
  800ca1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ca5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca8:	89 c0                	mov    %eax,%eax
  800caa:	48 01 d0             	add    %rdx,%rax
  800cad:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb0:	83 c2 08             	add    $0x8,%edx
  800cb3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cb6:	eb 0f                	jmp    800cc7 <vprintfmt+0x473>
  800cb8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cbc:	48 89 d0             	mov    %rdx,%rax
  800cbf:	48 83 c2 08          	add    $0x8,%rdx
  800cc3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cc7:	4c 8b 20             	mov    (%rax),%r12
  800cca:	4d 85 e4             	test   %r12,%r12
  800ccd:	75 0a                	jne    800cd9 <vprintfmt+0x485>
				p = "(null)";
  800ccf:	49 bc e5 3e 80 00 00 	movabs $0x803ee5,%r12
  800cd6:	00 00 00 
			if (width > 0 && padc != '-')
  800cd9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cdd:	7e 3f                	jle    800d1e <vprintfmt+0x4ca>
  800cdf:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ce3:	74 39                	je     800d1e <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ce5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ce8:	48 98                	cltq   
  800cea:	48 89 c6             	mov    %rax,%rsi
  800ced:	4c 89 e7             	mov    %r12,%rdi
  800cf0:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  800cf7:	00 00 00 
  800cfa:	ff d0                	callq  *%rax
  800cfc:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cff:	eb 17                	jmp    800d18 <vprintfmt+0x4c4>
					putch(padc, putdat);
  800d01:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d05:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0d:	48 89 ce             	mov    %rcx,%rsi
  800d10:	89 d7                	mov    %edx,%edi
  800d12:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d14:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d18:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d1c:	7f e3                	jg     800d01 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d1e:	eb 37                	jmp    800d57 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800d20:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d24:	74 1e                	je     800d44 <vprintfmt+0x4f0>
  800d26:	83 fb 1f             	cmp    $0x1f,%ebx
  800d29:	7e 05                	jle    800d30 <vprintfmt+0x4dc>
  800d2b:	83 fb 7e             	cmp    $0x7e,%ebx
  800d2e:	7e 14                	jle    800d44 <vprintfmt+0x4f0>
					putch('?', putdat);
  800d30:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d34:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d38:	48 89 d6             	mov    %rdx,%rsi
  800d3b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d40:	ff d0                	callq  *%rax
  800d42:	eb 0f                	jmp    800d53 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800d44:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4c:	48 89 d6             	mov    %rdx,%rsi
  800d4f:	89 df                	mov    %ebx,%edi
  800d51:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d53:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d57:	4c 89 e0             	mov    %r12,%rax
  800d5a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d5e:	0f b6 00             	movzbl (%rax),%eax
  800d61:	0f be d8             	movsbl %al,%ebx
  800d64:	85 db                	test   %ebx,%ebx
  800d66:	74 10                	je     800d78 <vprintfmt+0x524>
  800d68:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d6c:	78 b2                	js     800d20 <vprintfmt+0x4cc>
  800d6e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d72:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d76:	79 a8                	jns    800d20 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d78:	eb 16                	jmp    800d90 <vprintfmt+0x53c>
				putch(' ', putdat);
  800d7a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d82:	48 89 d6             	mov    %rdx,%rsi
  800d85:	bf 20 00 00 00       	mov    $0x20,%edi
  800d8a:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d8c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d90:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d94:	7f e4                	jg     800d7a <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800d96:	e9 b6 01 00 00       	jmpq   800f51 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d9b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d9f:	be 03 00 00 00       	mov    $0x3,%esi
  800da4:	48 89 c7             	mov    %rax,%rdi
  800da7:	48 b8 44 07 80 00 00 	movabs $0x800744,%rax
  800dae:	00 00 00 
  800db1:	ff d0                	callq  *%rax
  800db3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800db7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dbb:	48 85 c0             	test   %rax,%rax
  800dbe:	79 1d                	jns    800ddd <vprintfmt+0x589>
				putch('-', putdat);
  800dc0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc8:	48 89 d6             	mov    %rdx,%rsi
  800dcb:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800dd0:	ff d0                	callq  *%rax
				num = -(long long) num;
  800dd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd6:	48 f7 d8             	neg    %rax
  800dd9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ddd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800de4:	e9 fb 00 00 00       	jmpq   800ee4 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800de9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ded:	be 03 00 00 00       	mov    $0x3,%esi
  800df2:	48 89 c7             	mov    %rax,%rdi
  800df5:	48 b8 34 06 80 00 00 	movabs $0x800634,%rax
  800dfc:	00 00 00 
  800dff:	ff d0                	callq  *%rax
  800e01:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e05:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e0c:	e9 d3 00 00 00       	jmpq   800ee4 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800e11:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e15:	be 03 00 00 00       	mov    $0x3,%esi
  800e1a:	48 89 c7             	mov    %rax,%rdi
  800e1d:	48 b8 44 07 80 00 00 	movabs $0x800744,%rax
  800e24:	00 00 00 
  800e27:	ff d0                	callq  *%rax
  800e29:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e31:	48 85 c0             	test   %rax,%rax
  800e34:	79 1d                	jns    800e53 <vprintfmt+0x5ff>
				putch('-', putdat);
  800e36:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e3a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e3e:	48 89 d6             	mov    %rdx,%rsi
  800e41:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e46:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4c:	48 f7 d8             	neg    %rax
  800e4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800e53:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e5a:	e9 85 00 00 00       	jmpq   800ee4 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800e5f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e63:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e67:	48 89 d6             	mov    %rdx,%rsi
  800e6a:	bf 30 00 00 00       	mov    $0x30,%edi
  800e6f:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e71:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e75:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e79:	48 89 d6             	mov    %rdx,%rsi
  800e7c:	bf 78 00 00 00       	mov    $0x78,%edi
  800e81:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e83:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e86:	83 f8 30             	cmp    $0x30,%eax
  800e89:	73 17                	jae    800ea2 <vprintfmt+0x64e>
  800e8b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e8f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e92:	89 c0                	mov    %eax,%eax
  800e94:	48 01 d0             	add    %rdx,%rax
  800e97:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e9a:	83 c2 08             	add    $0x8,%edx
  800e9d:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ea0:	eb 0f                	jmp    800eb1 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800ea2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ea6:	48 89 d0             	mov    %rdx,%rax
  800ea9:	48 83 c2 08          	add    $0x8,%rdx
  800ead:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800eb1:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800eb4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800eb8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ebf:	eb 23                	jmp    800ee4 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ec1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ec5:	be 03 00 00 00       	mov    $0x3,%esi
  800eca:	48 89 c7             	mov    %rax,%rdi
  800ecd:	48 b8 34 06 80 00 00 	movabs $0x800634,%rax
  800ed4:	00 00 00 
  800ed7:	ff d0                	callq  *%rax
  800ed9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800edd:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ee4:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ee9:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800eec:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800eef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ef3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ef7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efb:	45 89 c1             	mov    %r8d,%r9d
  800efe:	41 89 f8             	mov    %edi,%r8d
  800f01:	48 89 c7             	mov    %rax,%rdi
  800f04:	48 b8 79 05 80 00 00 	movabs $0x800579,%rax
  800f0b:	00 00 00 
  800f0e:	ff d0                	callq  *%rax
			break;
  800f10:	eb 3f                	jmp    800f51 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f12:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f16:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f1a:	48 89 d6             	mov    %rdx,%rsi
  800f1d:	89 df                	mov    %ebx,%edi
  800f1f:	ff d0                	callq  *%rax
			break;
  800f21:	eb 2e                	jmp    800f51 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f23:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f2b:	48 89 d6             	mov    %rdx,%rsi
  800f2e:	bf 25 00 00 00       	mov    $0x25,%edi
  800f33:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f35:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f3a:	eb 05                	jmp    800f41 <vprintfmt+0x6ed>
  800f3c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f41:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f45:	48 83 e8 01          	sub    $0x1,%rax
  800f49:	0f b6 00             	movzbl (%rax),%eax
  800f4c:	3c 25                	cmp    $0x25,%al
  800f4e:	75 ec                	jne    800f3c <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  800f50:	90                   	nop
		}
	}
  800f51:	e9 37 f9 ff ff       	jmpq   80088d <vprintfmt+0x39>
    va_end(aq);
}
  800f56:	48 83 c4 60          	add    $0x60,%rsp
  800f5a:	5b                   	pop    %rbx
  800f5b:	41 5c                	pop    %r12
  800f5d:	5d                   	pop    %rbp
  800f5e:	c3                   	retq   

0000000000800f5f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f5f:	55                   	push   %rbp
  800f60:	48 89 e5             	mov    %rsp,%rbp
  800f63:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f6a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f71:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f78:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f7f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f86:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f8d:	84 c0                	test   %al,%al
  800f8f:	74 20                	je     800fb1 <printfmt+0x52>
  800f91:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f95:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f99:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f9d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fa1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fa5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fa9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fad:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fb1:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800fb8:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800fbf:	00 00 00 
  800fc2:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800fc9:	00 00 00 
  800fcc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fd0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fd7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fde:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fe5:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fec:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ff3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ffa:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801001:	48 89 c7             	mov    %rax,%rdi
  801004:	48 b8 54 08 80 00 00 	movabs $0x800854,%rax
  80100b:	00 00 00 
  80100e:	ff d0                	callq  *%rax
	va_end(ap);
}
  801010:	c9                   	leaveq 
  801011:	c3                   	retq   

0000000000801012 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801012:	55                   	push   %rbp
  801013:	48 89 e5             	mov    %rsp,%rbp
  801016:	48 83 ec 10          	sub    $0x10,%rsp
  80101a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80101d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801021:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801025:	8b 40 10             	mov    0x10(%rax),%eax
  801028:	8d 50 01             	lea    0x1(%rax),%edx
  80102b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80102f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801032:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801036:	48 8b 10             	mov    (%rax),%rdx
  801039:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80103d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801041:	48 39 c2             	cmp    %rax,%rdx
  801044:	73 17                	jae    80105d <sprintputch+0x4b>
		*b->buf++ = ch;
  801046:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80104a:	48 8b 00             	mov    (%rax),%rax
  80104d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801051:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801055:	48 89 0a             	mov    %rcx,(%rdx)
  801058:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80105b:	88 10                	mov    %dl,(%rax)
}
  80105d:	c9                   	leaveq 
  80105e:	c3                   	retq   

000000000080105f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80105f:	55                   	push   %rbp
  801060:	48 89 e5             	mov    %rsp,%rbp
  801063:	48 83 ec 50          	sub    $0x50,%rsp
  801067:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80106b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80106e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801072:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801076:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80107a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80107e:	48 8b 0a             	mov    (%rdx),%rcx
  801081:	48 89 08             	mov    %rcx,(%rax)
  801084:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801088:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80108c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801090:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801094:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801098:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80109c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80109f:	48 98                	cltq   
  8010a1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8010a5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010a9:	48 01 d0             	add    %rdx,%rax
  8010ac:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8010b0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8010b7:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8010bc:	74 06                	je     8010c4 <vsnprintf+0x65>
  8010be:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8010c2:	7f 07                	jg     8010cb <vsnprintf+0x6c>
		return -E_INVAL;
  8010c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010c9:	eb 2f                	jmp    8010fa <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8010cb:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8010cf:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8010d3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010d7:	48 89 c6             	mov    %rax,%rsi
  8010da:	48 bf 12 10 80 00 00 	movabs $0x801012,%rdi
  8010e1:	00 00 00 
  8010e4:	48 b8 54 08 80 00 00 	movabs $0x800854,%rax
  8010eb:	00 00 00 
  8010ee:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010f4:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010f7:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010fa:	c9                   	leaveq 
  8010fb:	c3                   	retq   

00000000008010fc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010fc:	55                   	push   %rbp
  8010fd:	48 89 e5             	mov    %rsp,%rbp
  801100:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801107:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80110e:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801114:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80111b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801122:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801129:	84 c0                	test   %al,%al
  80112b:	74 20                	je     80114d <snprintf+0x51>
  80112d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801131:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801135:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801139:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80113d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801141:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801145:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801149:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80114d:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801154:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80115b:	00 00 00 
  80115e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801165:	00 00 00 
  801168:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80116c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801173:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80117a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801181:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801188:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80118f:	48 8b 0a             	mov    (%rdx),%rcx
  801192:	48 89 08             	mov    %rcx,(%rax)
  801195:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801199:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80119d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011a1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8011a5:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8011ac:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8011b3:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8011b9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8011c0:	48 89 c7             	mov    %rax,%rdi
  8011c3:	48 b8 5f 10 80 00 00 	movabs $0x80105f,%rax
  8011ca:	00 00 00 
  8011cd:	ff d0                	callq  *%rax
  8011cf:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8011d5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011db:	c9                   	leaveq 
  8011dc:	c3                   	retq   

00000000008011dd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011dd:	55                   	push   %rbp
  8011de:	48 89 e5             	mov    %rsp,%rbp
  8011e1:	48 83 ec 18          	sub    $0x18,%rsp
  8011e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011f0:	eb 09                	jmp    8011fb <strlen+0x1e>
		n++;
  8011f2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011f6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ff:	0f b6 00             	movzbl (%rax),%eax
  801202:	84 c0                	test   %al,%al
  801204:	75 ec                	jne    8011f2 <strlen+0x15>
		n++;
	return n;
  801206:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801209:	c9                   	leaveq 
  80120a:	c3                   	retq   

000000000080120b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80120b:	55                   	push   %rbp
  80120c:	48 89 e5             	mov    %rsp,%rbp
  80120f:	48 83 ec 20          	sub    $0x20,%rsp
  801213:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801217:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80121b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801222:	eb 0e                	jmp    801232 <strnlen+0x27>
		n++;
  801224:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801228:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80122d:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801232:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801237:	74 0b                	je     801244 <strnlen+0x39>
  801239:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123d:	0f b6 00             	movzbl (%rax),%eax
  801240:	84 c0                	test   %al,%al
  801242:	75 e0                	jne    801224 <strnlen+0x19>
		n++;
	return n;
  801244:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801247:	c9                   	leaveq 
  801248:	c3                   	retq   

0000000000801249 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801249:	55                   	push   %rbp
  80124a:	48 89 e5             	mov    %rsp,%rbp
  80124d:	48 83 ec 20          	sub    $0x20,%rsp
  801251:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801255:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801259:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80125d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801261:	90                   	nop
  801262:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801266:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80126a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80126e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801272:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801276:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80127a:	0f b6 12             	movzbl (%rdx),%edx
  80127d:	88 10                	mov    %dl,(%rax)
  80127f:	0f b6 00             	movzbl (%rax),%eax
  801282:	84 c0                	test   %al,%al
  801284:	75 dc                	jne    801262 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801286:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80128a:	c9                   	leaveq 
  80128b:	c3                   	retq   

000000000080128c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80128c:	55                   	push   %rbp
  80128d:	48 89 e5             	mov    %rsp,%rbp
  801290:	48 83 ec 20          	sub    $0x20,%rsp
  801294:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801298:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80129c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a0:	48 89 c7             	mov    %rax,%rdi
  8012a3:	48 b8 dd 11 80 00 00 	movabs $0x8011dd,%rax
  8012aa:	00 00 00 
  8012ad:	ff d0                	callq  *%rax
  8012af:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8012b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012b5:	48 63 d0             	movslq %eax,%rdx
  8012b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bc:	48 01 c2             	add    %rax,%rdx
  8012bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c3:	48 89 c6             	mov    %rax,%rsi
  8012c6:	48 89 d7             	mov    %rdx,%rdi
  8012c9:	48 b8 49 12 80 00 00 	movabs $0x801249,%rax
  8012d0:	00 00 00 
  8012d3:	ff d0                	callq  *%rax
	return dst;
  8012d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012d9:	c9                   	leaveq 
  8012da:	c3                   	retq   

00000000008012db <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012db:	55                   	push   %rbp
  8012dc:	48 89 e5             	mov    %rsp,%rbp
  8012df:	48 83 ec 28          	sub    $0x28,%rsp
  8012e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012f7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012fe:	00 
  8012ff:	eb 2a                	jmp    80132b <strncpy+0x50>
		*dst++ = *src;
  801301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801305:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801309:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80130d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801311:	0f b6 12             	movzbl (%rdx),%edx
  801314:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801316:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80131a:	0f b6 00             	movzbl (%rax),%eax
  80131d:	84 c0                	test   %al,%al
  80131f:	74 05                	je     801326 <strncpy+0x4b>
			src++;
  801321:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801326:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80132b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801333:	72 cc                	jb     801301 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801335:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801339:	c9                   	leaveq 
  80133a:	c3                   	retq   

000000000080133b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80133b:	55                   	push   %rbp
  80133c:	48 89 e5             	mov    %rsp,%rbp
  80133f:	48 83 ec 28          	sub    $0x28,%rsp
  801343:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801347:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80134b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80134f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801353:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801357:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80135c:	74 3d                	je     80139b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80135e:	eb 1d                	jmp    80137d <strlcpy+0x42>
			*dst++ = *src++;
  801360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801364:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801368:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80136c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801370:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801374:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801378:	0f b6 12             	movzbl (%rdx),%edx
  80137b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80137d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801382:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801387:	74 0b                	je     801394 <strlcpy+0x59>
  801389:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80138d:	0f b6 00             	movzbl (%rax),%eax
  801390:	84 c0                	test   %al,%al
  801392:	75 cc                	jne    801360 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801394:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801398:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80139b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80139f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a3:	48 29 c2             	sub    %rax,%rdx
  8013a6:	48 89 d0             	mov    %rdx,%rax
}
  8013a9:	c9                   	leaveq 
  8013aa:	c3                   	retq   

00000000008013ab <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013ab:	55                   	push   %rbp
  8013ac:	48 89 e5             	mov    %rsp,%rbp
  8013af:	48 83 ec 10          	sub    $0x10,%rsp
  8013b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8013bb:	eb 0a                	jmp    8013c7 <strcmp+0x1c>
		p++, q++;
  8013bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013c2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cb:	0f b6 00             	movzbl (%rax),%eax
  8013ce:	84 c0                	test   %al,%al
  8013d0:	74 12                	je     8013e4 <strcmp+0x39>
  8013d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d6:	0f b6 10             	movzbl (%rax),%edx
  8013d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013dd:	0f b6 00             	movzbl (%rax),%eax
  8013e0:	38 c2                	cmp    %al,%dl
  8013e2:	74 d9                	je     8013bd <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e8:	0f b6 00             	movzbl (%rax),%eax
  8013eb:	0f b6 d0             	movzbl %al,%edx
  8013ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f2:	0f b6 00             	movzbl (%rax),%eax
  8013f5:	0f b6 c0             	movzbl %al,%eax
  8013f8:	29 c2                	sub    %eax,%edx
  8013fa:	89 d0                	mov    %edx,%eax
}
  8013fc:	c9                   	leaveq 
  8013fd:	c3                   	retq   

00000000008013fe <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013fe:	55                   	push   %rbp
  8013ff:	48 89 e5             	mov    %rsp,%rbp
  801402:	48 83 ec 18          	sub    $0x18,%rsp
  801406:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80140a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80140e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801412:	eb 0f                	jmp    801423 <strncmp+0x25>
		n--, p++, q++;
  801414:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801419:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80141e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801423:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801428:	74 1d                	je     801447 <strncmp+0x49>
  80142a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142e:	0f b6 00             	movzbl (%rax),%eax
  801431:	84 c0                	test   %al,%al
  801433:	74 12                	je     801447 <strncmp+0x49>
  801435:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801439:	0f b6 10             	movzbl (%rax),%edx
  80143c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801440:	0f b6 00             	movzbl (%rax),%eax
  801443:	38 c2                	cmp    %al,%dl
  801445:	74 cd                	je     801414 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801447:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80144c:	75 07                	jne    801455 <strncmp+0x57>
		return 0;
  80144e:	b8 00 00 00 00       	mov    $0x0,%eax
  801453:	eb 18                	jmp    80146d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801455:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801459:	0f b6 00             	movzbl (%rax),%eax
  80145c:	0f b6 d0             	movzbl %al,%edx
  80145f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801463:	0f b6 00             	movzbl (%rax),%eax
  801466:	0f b6 c0             	movzbl %al,%eax
  801469:	29 c2                	sub    %eax,%edx
  80146b:	89 d0                	mov    %edx,%eax
}
  80146d:	c9                   	leaveq 
  80146e:	c3                   	retq   

000000000080146f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80146f:	55                   	push   %rbp
  801470:	48 89 e5             	mov    %rsp,%rbp
  801473:	48 83 ec 0c          	sub    $0xc,%rsp
  801477:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80147b:	89 f0                	mov    %esi,%eax
  80147d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801480:	eb 17                	jmp    801499 <strchr+0x2a>
		if (*s == c)
  801482:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801486:	0f b6 00             	movzbl (%rax),%eax
  801489:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80148c:	75 06                	jne    801494 <strchr+0x25>
			return (char *) s;
  80148e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801492:	eb 15                	jmp    8014a9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801494:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801499:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149d:	0f b6 00             	movzbl (%rax),%eax
  8014a0:	84 c0                	test   %al,%al
  8014a2:	75 de                	jne    801482 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8014a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a9:	c9                   	leaveq 
  8014aa:	c3                   	retq   

00000000008014ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014ab:	55                   	push   %rbp
  8014ac:	48 89 e5             	mov    %rsp,%rbp
  8014af:	48 83 ec 0c          	sub    $0xc,%rsp
  8014b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b7:	89 f0                	mov    %esi,%eax
  8014b9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014bc:	eb 13                	jmp    8014d1 <strfind+0x26>
		if (*s == c)
  8014be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c2:	0f b6 00             	movzbl (%rax),%eax
  8014c5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014c8:	75 02                	jne    8014cc <strfind+0x21>
			break;
  8014ca:	eb 10                	jmp    8014dc <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d5:	0f b6 00             	movzbl (%rax),%eax
  8014d8:	84 c0                	test   %al,%al
  8014da:	75 e2                	jne    8014be <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014e0:	c9                   	leaveq 
  8014e1:	c3                   	retq   

00000000008014e2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014e2:	55                   	push   %rbp
  8014e3:	48 89 e5             	mov    %rsp,%rbp
  8014e6:	48 83 ec 18          	sub    $0x18,%rsp
  8014ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014ee:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014fa:	75 06                	jne    801502 <memset+0x20>
		return v;
  8014fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801500:	eb 69                	jmp    80156b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801502:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801506:	83 e0 03             	and    $0x3,%eax
  801509:	48 85 c0             	test   %rax,%rax
  80150c:	75 48                	jne    801556 <memset+0x74>
  80150e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801512:	83 e0 03             	and    $0x3,%eax
  801515:	48 85 c0             	test   %rax,%rax
  801518:	75 3c                	jne    801556 <memset+0x74>
		c &= 0xFF;
  80151a:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801521:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801524:	c1 e0 18             	shl    $0x18,%eax
  801527:	89 c2                	mov    %eax,%edx
  801529:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80152c:	c1 e0 10             	shl    $0x10,%eax
  80152f:	09 c2                	or     %eax,%edx
  801531:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801534:	c1 e0 08             	shl    $0x8,%eax
  801537:	09 d0                	or     %edx,%eax
  801539:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80153c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801540:	48 c1 e8 02          	shr    $0x2,%rax
  801544:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801547:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80154b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80154e:	48 89 d7             	mov    %rdx,%rdi
  801551:	fc                   	cld    
  801552:	f3 ab                	rep stos %eax,%es:(%rdi)
  801554:	eb 11                	jmp    801567 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801556:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80155a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80155d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801561:	48 89 d7             	mov    %rdx,%rdi
  801564:	fc                   	cld    
  801565:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801567:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80156b:	c9                   	leaveq 
  80156c:	c3                   	retq   

000000000080156d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80156d:	55                   	push   %rbp
  80156e:	48 89 e5             	mov    %rsp,%rbp
  801571:	48 83 ec 28          	sub    $0x28,%rsp
  801575:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801579:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80157d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801581:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801585:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801589:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80158d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801595:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801599:	0f 83 88 00 00 00    	jae    801627 <memmove+0xba>
  80159f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015a7:	48 01 d0             	add    %rdx,%rax
  8015aa:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015ae:	76 77                	jbe    801627 <memmove+0xba>
		s += n;
  8015b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b4:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8015b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bc:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c4:	83 e0 03             	and    $0x3,%eax
  8015c7:	48 85 c0             	test   %rax,%rax
  8015ca:	75 3b                	jne    801607 <memmove+0x9a>
  8015cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d0:	83 e0 03             	and    $0x3,%eax
  8015d3:	48 85 c0             	test   %rax,%rax
  8015d6:	75 2f                	jne    801607 <memmove+0x9a>
  8015d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dc:	83 e0 03             	and    $0x3,%eax
  8015df:	48 85 c0             	test   %rax,%rax
  8015e2:	75 23                	jne    801607 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e8:	48 83 e8 04          	sub    $0x4,%rax
  8015ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015f0:	48 83 ea 04          	sub    $0x4,%rdx
  8015f4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015f8:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015fc:	48 89 c7             	mov    %rax,%rdi
  8015ff:	48 89 d6             	mov    %rdx,%rsi
  801602:	fd                   	std    
  801603:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801605:	eb 1d                	jmp    801624 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80160f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801613:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801617:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161b:	48 89 d7             	mov    %rdx,%rdi
  80161e:	48 89 c1             	mov    %rax,%rcx
  801621:	fd                   	std    
  801622:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801624:	fc                   	cld    
  801625:	eb 57                	jmp    80167e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801627:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162b:	83 e0 03             	and    $0x3,%eax
  80162e:	48 85 c0             	test   %rax,%rax
  801631:	75 36                	jne    801669 <memmove+0xfc>
  801633:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801637:	83 e0 03             	and    $0x3,%eax
  80163a:	48 85 c0             	test   %rax,%rax
  80163d:	75 2a                	jne    801669 <memmove+0xfc>
  80163f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801643:	83 e0 03             	and    $0x3,%eax
  801646:	48 85 c0             	test   %rax,%rax
  801649:	75 1e                	jne    801669 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80164b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164f:	48 c1 e8 02          	shr    $0x2,%rax
  801653:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801656:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80165a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80165e:	48 89 c7             	mov    %rax,%rdi
  801661:	48 89 d6             	mov    %rdx,%rsi
  801664:	fc                   	cld    
  801665:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801667:	eb 15                	jmp    80167e <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801669:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801671:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801675:	48 89 c7             	mov    %rax,%rdi
  801678:	48 89 d6             	mov    %rdx,%rsi
  80167b:	fc                   	cld    
  80167c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80167e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801682:	c9                   	leaveq 
  801683:	c3                   	retq   

0000000000801684 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801684:	55                   	push   %rbp
  801685:	48 89 e5             	mov    %rsp,%rbp
  801688:	48 83 ec 18          	sub    $0x18,%rsp
  80168c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801690:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801694:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801698:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80169c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8016a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a4:	48 89 ce             	mov    %rcx,%rsi
  8016a7:	48 89 c7             	mov    %rax,%rdi
  8016aa:	48 b8 6d 15 80 00 00 	movabs $0x80156d,%rax
  8016b1:	00 00 00 
  8016b4:	ff d0                	callq  *%rax
}
  8016b6:	c9                   	leaveq 
  8016b7:	c3                   	retq   

00000000008016b8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8016b8:	55                   	push   %rbp
  8016b9:	48 89 e5             	mov    %rsp,%rbp
  8016bc:	48 83 ec 28          	sub    $0x28,%rsp
  8016c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016c8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8016cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8016d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016dc:	eb 36                	jmp    801714 <memcmp+0x5c>
		if (*s1 != *s2)
  8016de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e2:	0f b6 10             	movzbl (%rax),%edx
  8016e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e9:	0f b6 00             	movzbl (%rax),%eax
  8016ec:	38 c2                	cmp    %al,%dl
  8016ee:	74 1a                	je     80170a <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f4:	0f b6 00             	movzbl (%rax),%eax
  8016f7:	0f b6 d0             	movzbl %al,%edx
  8016fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016fe:	0f b6 00             	movzbl (%rax),%eax
  801701:	0f b6 c0             	movzbl %al,%eax
  801704:	29 c2                	sub    %eax,%edx
  801706:	89 d0                	mov    %edx,%eax
  801708:	eb 20                	jmp    80172a <memcmp+0x72>
		s1++, s2++;
  80170a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80170f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801714:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801718:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80171c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801720:	48 85 c0             	test   %rax,%rax
  801723:	75 b9                	jne    8016de <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801725:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172a:	c9                   	leaveq 
  80172b:	c3                   	retq   

000000000080172c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80172c:	55                   	push   %rbp
  80172d:	48 89 e5             	mov    %rsp,%rbp
  801730:	48 83 ec 28          	sub    $0x28,%rsp
  801734:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801738:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80173b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80173f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801743:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801747:	48 01 d0             	add    %rdx,%rax
  80174a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80174e:	eb 15                	jmp    801765 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801750:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801754:	0f b6 10             	movzbl (%rax),%edx
  801757:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80175a:	38 c2                	cmp    %al,%dl
  80175c:	75 02                	jne    801760 <memfind+0x34>
			break;
  80175e:	eb 0f                	jmp    80176f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801760:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801769:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80176d:	72 e1                	jb     801750 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80176f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801773:	c9                   	leaveq 
  801774:	c3                   	retq   

0000000000801775 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801775:	55                   	push   %rbp
  801776:	48 89 e5             	mov    %rsp,%rbp
  801779:	48 83 ec 34          	sub    $0x34,%rsp
  80177d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801781:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801785:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801788:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80178f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801796:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801797:	eb 05                	jmp    80179e <strtol+0x29>
		s++;
  801799:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80179e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a2:	0f b6 00             	movzbl (%rax),%eax
  8017a5:	3c 20                	cmp    $0x20,%al
  8017a7:	74 f0                	je     801799 <strtol+0x24>
  8017a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ad:	0f b6 00             	movzbl (%rax),%eax
  8017b0:	3c 09                	cmp    $0x9,%al
  8017b2:	74 e5                	je     801799 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b8:	0f b6 00             	movzbl (%rax),%eax
  8017bb:	3c 2b                	cmp    $0x2b,%al
  8017bd:	75 07                	jne    8017c6 <strtol+0x51>
		s++;
  8017bf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017c4:	eb 17                	jmp    8017dd <strtol+0x68>
	else if (*s == '-')
  8017c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ca:	0f b6 00             	movzbl (%rax),%eax
  8017cd:	3c 2d                	cmp    $0x2d,%al
  8017cf:	75 0c                	jne    8017dd <strtol+0x68>
		s++, neg = 1;
  8017d1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017d6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017dd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017e1:	74 06                	je     8017e9 <strtol+0x74>
  8017e3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017e7:	75 28                	jne    801811 <strtol+0x9c>
  8017e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ed:	0f b6 00             	movzbl (%rax),%eax
  8017f0:	3c 30                	cmp    $0x30,%al
  8017f2:	75 1d                	jne    801811 <strtol+0x9c>
  8017f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f8:	48 83 c0 01          	add    $0x1,%rax
  8017fc:	0f b6 00             	movzbl (%rax),%eax
  8017ff:	3c 78                	cmp    $0x78,%al
  801801:	75 0e                	jne    801811 <strtol+0x9c>
		s += 2, base = 16;
  801803:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801808:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80180f:	eb 2c                	jmp    80183d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801811:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801815:	75 19                	jne    801830 <strtol+0xbb>
  801817:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181b:	0f b6 00             	movzbl (%rax),%eax
  80181e:	3c 30                	cmp    $0x30,%al
  801820:	75 0e                	jne    801830 <strtol+0xbb>
		s++, base = 8;
  801822:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801827:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80182e:	eb 0d                	jmp    80183d <strtol+0xc8>
	else if (base == 0)
  801830:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801834:	75 07                	jne    80183d <strtol+0xc8>
		base = 10;
  801836:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80183d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801841:	0f b6 00             	movzbl (%rax),%eax
  801844:	3c 2f                	cmp    $0x2f,%al
  801846:	7e 1d                	jle    801865 <strtol+0xf0>
  801848:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184c:	0f b6 00             	movzbl (%rax),%eax
  80184f:	3c 39                	cmp    $0x39,%al
  801851:	7f 12                	jg     801865 <strtol+0xf0>
			dig = *s - '0';
  801853:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801857:	0f b6 00             	movzbl (%rax),%eax
  80185a:	0f be c0             	movsbl %al,%eax
  80185d:	83 e8 30             	sub    $0x30,%eax
  801860:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801863:	eb 4e                	jmp    8018b3 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801865:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801869:	0f b6 00             	movzbl (%rax),%eax
  80186c:	3c 60                	cmp    $0x60,%al
  80186e:	7e 1d                	jle    80188d <strtol+0x118>
  801870:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801874:	0f b6 00             	movzbl (%rax),%eax
  801877:	3c 7a                	cmp    $0x7a,%al
  801879:	7f 12                	jg     80188d <strtol+0x118>
			dig = *s - 'a' + 10;
  80187b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187f:	0f b6 00             	movzbl (%rax),%eax
  801882:	0f be c0             	movsbl %al,%eax
  801885:	83 e8 57             	sub    $0x57,%eax
  801888:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80188b:	eb 26                	jmp    8018b3 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80188d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801891:	0f b6 00             	movzbl (%rax),%eax
  801894:	3c 40                	cmp    $0x40,%al
  801896:	7e 48                	jle    8018e0 <strtol+0x16b>
  801898:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189c:	0f b6 00             	movzbl (%rax),%eax
  80189f:	3c 5a                	cmp    $0x5a,%al
  8018a1:	7f 3d                	jg     8018e0 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8018a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a7:	0f b6 00             	movzbl (%rax),%eax
  8018aa:	0f be c0             	movsbl %al,%eax
  8018ad:	83 e8 37             	sub    $0x37,%eax
  8018b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8018b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018b6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8018b9:	7c 02                	jl     8018bd <strtol+0x148>
			break;
  8018bb:	eb 23                	jmp    8018e0 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8018bd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018c2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8018c5:	48 98                	cltq   
  8018c7:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8018cc:	48 89 c2             	mov    %rax,%rdx
  8018cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018d2:	48 98                	cltq   
  8018d4:	48 01 d0             	add    %rdx,%rax
  8018d7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018db:	e9 5d ff ff ff       	jmpq   80183d <strtol+0xc8>

	if (endptr)
  8018e0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018e5:	74 0b                	je     8018f2 <strtol+0x17d>
		*endptr = (char *) s;
  8018e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018eb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018ef:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018f6:	74 09                	je     801901 <strtol+0x18c>
  8018f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018fc:	48 f7 d8             	neg    %rax
  8018ff:	eb 04                	jmp    801905 <strtol+0x190>
  801901:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801905:	c9                   	leaveq 
  801906:	c3                   	retq   

0000000000801907 <strstr>:

char * strstr(const char *in, const char *str)
{
  801907:	55                   	push   %rbp
  801908:	48 89 e5             	mov    %rsp,%rbp
  80190b:	48 83 ec 30          	sub    $0x30,%rsp
  80190f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801913:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801917:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80191b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80191f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801923:	0f b6 00             	movzbl (%rax),%eax
  801926:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801929:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80192d:	75 06                	jne    801935 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  80192f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801933:	eb 6b                	jmp    8019a0 <strstr+0x99>

    len = strlen(str);
  801935:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801939:	48 89 c7             	mov    %rax,%rdi
  80193c:	48 b8 dd 11 80 00 00 	movabs $0x8011dd,%rax
  801943:	00 00 00 
  801946:	ff d0                	callq  *%rax
  801948:	48 98                	cltq   
  80194a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80194e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801952:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801956:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80195a:	0f b6 00             	movzbl (%rax),%eax
  80195d:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801960:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801964:	75 07                	jne    80196d <strstr+0x66>
                return (char *) 0;
  801966:	b8 00 00 00 00       	mov    $0x0,%eax
  80196b:	eb 33                	jmp    8019a0 <strstr+0x99>
        } while (sc != c);
  80196d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801971:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801974:	75 d8                	jne    80194e <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801976:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80197a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80197e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801982:	48 89 ce             	mov    %rcx,%rsi
  801985:	48 89 c7             	mov    %rax,%rdi
  801988:	48 b8 fe 13 80 00 00 	movabs $0x8013fe,%rax
  80198f:	00 00 00 
  801992:	ff d0                	callq  *%rax
  801994:	85 c0                	test   %eax,%eax
  801996:	75 b6                	jne    80194e <strstr+0x47>

    return (char *) (in - 1);
  801998:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199c:	48 83 e8 01          	sub    $0x1,%rax
}
  8019a0:	c9                   	leaveq 
  8019a1:	c3                   	retq   

00000000008019a2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8019a2:	55                   	push   %rbp
  8019a3:	48 89 e5             	mov    %rsp,%rbp
  8019a6:	53                   	push   %rbx
  8019a7:	48 83 ec 48          	sub    $0x48,%rsp
  8019ab:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8019ae:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8019b1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019b5:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8019b9:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8019bd:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019c1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019c4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8019c8:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8019cc:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8019d0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8019d4:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019d8:	4c 89 c3             	mov    %r8,%rbx
  8019db:	cd 30                	int    $0x30
  8019dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  8019e1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019e5:	74 3e                	je     801a25 <syscall+0x83>
  8019e7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019ec:	7e 37                	jle    801a25 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019f2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019f5:	49 89 d0             	mov    %rdx,%r8
  8019f8:	89 c1                	mov    %eax,%ecx
  8019fa:	48 ba a0 41 80 00 00 	movabs $0x8041a0,%rdx
  801a01:	00 00 00 
  801a04:	be 23 00 00 00       	mov    $0x23,%esi
  801a09:	48 bf bd 41 80 00 00 	movabs $0x8041bd,%rdi
  801a10:	00 00 00 
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
  801a18:	49 b9 68 02 80 00 00 	movabs $0x800268,%r9
  801a1f:	00 00 00 
  801a22:	41 ff d1             	callq  *%r9

	return ret;
  801a25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a29:	48 83 c4 48          	add    $0x48,%rsp
  801a2d:	5b                   	pop    %rbx
  801a2e:	5d                   	pop    %rbp
  801a2f:	c3                   	retq   

0000000000801a30 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a30:	55                   	push   %rbp
  801a31:	48 89 e5             	mov    %rsp,%rbp
  801a34:	48 83 ec 20          	sub    $0x20,%rsp
  801a38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a3c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a48:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a4f:	00 
  801a50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a5c:	48 89 d1             	mov    %rdx,%rcx
  801a5f:	48 89 c2             	mov    %rax,%rdx
  801a62:	be 00 00 00 00       	mov    $0x0,%esi
  801a67:	bf 00 00 00 00       	mov    $0x0,%edi
  801a6c:	48 b8 a2 19 80 00 00 	movabs $0x8019a2,%rax
  801a73:	00 00 00 
  801a76:	ff d0                	callq  *%rax
}
  801a78:	c9                   	leaveq 
  801a79:	c3                   	retq   

0000000000801a7a <sys_cgetc>:

int
sys_cgetc(void)
{
  801a7a:	55                   	push   %rbp
  801a7b:	48 89 e5             	mov    %rsp,%rbp
  801a7e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a82:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a89:	00 
  801a8a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a90:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a96:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa0:	be 00 00 00 00       	mov    $0x0,%esi
  801aa5:	bf 01 00 00 00       	mov    $0x1,%edi
  801aaa:	48 b8 a2 19 80 00 00 	movabs $0x8019a2,%rax
  801ab1:	00 00 00 
  801ab4:	ff d0                	callq  *%rax
}
  801ab6:	c9                   	leaveq 
  801ab7:	c3                   	retq   

0000000000801ab8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801ab8:	55                   	push   %rbp
  801ab9:	48 89 e5             	mov    %rsp,%rbp
  801abc:	48 83 ec 10          	sub    $0x10,%rsp
  801ac0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801ac3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac6:	48 98                	cltq   
  801ac8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801acf:	00 
  801ad0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801adc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae1:	48 89 c2             	mov    %rax,%rdx
  801ae4:	be 01 00 00 00       	mov    $0x1,%esi
  801ae9:	bf 03 00 00 00       	mov    $0x3,%edi
  801aee:	48 b8 a2 19 80 00 00 	movabs $0x8019a2,%rax
  801af5:	00 00 00 
  801af8:	ff d0                	callq  *%rax
}
  801afa:	c9                   	leaveq 
  801afb:	c3                   	retq   

0000000000801afc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801afc:	55                   	push   %rbp
  801afd:	48 89 e5             	mov    %rsp,%rbp
  801b00:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801b04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b0b:	00 
  801b0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b18:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b22:	be 00 00 00 00       	mov    $0x0,%esi
  801b27:	bf 02 00 00 00       	mov    $0x2,%edi
  801b2c:	48 b8 a2 19 80 00 00 	movabs $0x8019a2,%rax
  801b33:	00 00 00 
  801b36:	ff d0                	callq  *%rax
}
  801b38:	c9                   	leaveq 
  801b39:	c3                   	retq   

0000000000801b3a <sys_yield>:

void
sys_yield(void)
{
  801b3a:	55                   	push   %rbp
  801b3b:	48 89 e5             	mov    %rsp,%rbp
  801b3e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b42:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b49:	00 
  801b4a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b50:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b56:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b60:	be 00 00 00 00       	mov    $0x0,%esi
  801b65:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b6a:	48 b8 a2 19 80 00 00 	movabs $0x8019a2,%rax
  801b71:	00 00 00 
  801b74:	ff d0                	callq  *%rax
}
  801b76:	c9                   	leaveq 
  801b77:	c3                   	retq   

0000000000801b78 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b78:	55                   	push   %rbp
  801b79:	48 89 e5             	mov    %rsp,%rbp
  801b7c:	48 83 ec 20          	sub    $0x20,%rsp
  801b80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b87:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b8d:	48 63 c8             	movslq %eax,%rcx
  801b90:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b97:	48 98                	cltq   
  801b99:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ba0:	00 
  801ba1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba7:	49 89 c8             	mov    %rcx,%r8
  801baa:	48 89 d1             	mov    %rdx,%rcx
  801bad:	48 89 c2             	mov    %rax,%rdx
  801bb0:	be 01 00 00 00       	mov    $0x1,%esi
  801bb5:	bf 04 00 00 00       	mov    $0x4,%edi
  801bba:	48 b8 a2 19 80 00 00 	movabs $0x8019a2,%rax
  801bc1:	00 00 00 
  801bc4:	ff d0                	callq  *%rax
}
  801bc6:	c9                   	leaveq 
  801bc7:	c3                   	retq   

0000000000801bc8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801bc8:	55                   	push   %rbp
  801bc9:	48 89 e5             	mov    %rsp,%rbp
  801bcc:	48 83 ec 30          	sub    $0x30,%rsp
  801bd0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bd3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bd7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bda:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bde:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801be2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801be5:	48 63 c8             	movslq %eax,%rcx
  801be8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bef:	48 63 f0             	movslq %eax,%rsi
  801bf2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf9:	48 98                	cltq   
  801bfb:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bff:	49 89 f9             	mov    %rdi,%r9
  801c02:	49 89 f0             	mov    %rsi,%r8
  801c05:	48 89 d1             	mov    %rdx,%rcx
  801c08:	48 89 c2             	mov    %rax,%rdx
  801c0b:	be 01 00 00 00       	mov    $0x1,%esi
  801c10:	bf 05 00 00 00       	mov    $0x5,%edi
  801c15:	48 b8 a2 19 80 00 00 	movabs $0x8019a2,%rax
  801c1c:	00 00 00 
  801c1f:	ff d0                	callq  *%rax
}
  801c21:	c9                   	leaveq 
  801c22:	c3                   	retq   

0000000000801c23 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c23:	55                   	push   %rbp
  801c24:	48 89 e5             	mov    %rsp,%rbp
  801c27:	48 83 ec 20          	sub    $0x20,%rsp
  801c2b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c2e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c39:	48 98                	cltq   
  801c3b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c42:	00 
  801c43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c4f:	48 89 d1             	mov    %rdx,%rcx
  801c52:	48 89 c2             	mov    %rax,%rdx
  801c55:	be 01 00 00 00       	mov    $0x1,%esi
  801c5a:	bf 06 00 00 00       	mov    $0x6,%edi
  801c5f:	48 b8 a2 19 80 00 00 	movabs $0x8019a2,%rax
  801c66:	00 00 00 
  801c69:	ff d0                	callq  *%rax
}
  801c6b:	c9                   	leaveq 
  801c6c:	c3                   	retq   

0000000000801c6d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c6d:	55                   	push   %rbp
  801c6e:	48 89 e5             	mov    %rsp,%rbp
  801c71:	48 83 ec 10          	sub    $0x10,%rsp
  801c75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c78:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c7e:	48 63 d0             	movslq %eax,%rdx
  801c81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c84:	48 98                	cltq   
  801c86:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c8d:	00 
  801c8e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c94:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c9a:	48 89 d1             	mov    %rdx,%rcx
  801c9d:	48 89 c2             	mov    %rax,%rdx
  801ca0:	be 01 00 00 00       	mov    $0x1,%esi
  801ca5:	bf 08 00 00 00       	mov    $0x8,%edi
  801caa:	48 b8 a2 19 80 00 00 	movabs $0x8019a2,%rax
  801cb1:	00 00 00 
  801cb4:	ff d0                	callq  *%rax
}
  801cb6:	c9                   	leaveq 
  801cb7:	c3                   	retq   

0000000000801cb8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801cb8:	55                   	push   %rbp
  801cb9:	48 89 e5             	mov    %rsp,%rbp
  801cbc:	48 83 ec 20          	sub    $0x20,%rsp
  801cc0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cc3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801cc7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ccb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cce:	48 98                	cltq   
  801cd0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd7:	00 
  801cd8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cde:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce4:	48 89 d1             	mov    %rdx,%rcx
  801ce7:	48 89 c2             	mov    %rax,%rdx
  801cea:	be 01 00 00 00       	mov    $0x1,%esi
  801cef:	bf 09 00 00 00       	mov    $0x9,%edi
  801cf4:	48 b8 a2 19 80 00 00 	movabs $0x8019a2,%rax
  801cfb:	00 00 00 
  801cfe:	ff d0                	callq  *%rax
}
  801d00:	c9                   	leaveq 
  801d01:	c3                   	retq   

0000000000801d02 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801d02:	55                   	push   %rbp
  801d03:	48 89 e5             	mov    %rsp,%rbp
  801d06:	48 83 ec 20          	sub    $0x20,%rsp
  801d0a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801d11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d18:	48 98                	cltq   
  801d1a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d21:	00 
  801d22:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d28:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d2e:	48 89 d1             	mov    %rdx,%rcx
  801d31:	48 89 c2             	mov    %rax,%rdx
  801d34:	be 01 00 00 00       	mov    $0x1,%esi
  801d39:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d3e:	48 b8 a2 19 80 00 00 	movabs $0x8019a2,%rax
  801d45:	00 00 00 
  801d48:	ff d0                	callq  *%rax
}
  801d4a:	c9                   	leaveq 
  801d4b:	c3                   	retq   

0000000000801d4c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d4c:	55                   	push   %rbp
  801d4d:	48 89 e5             	mov    %rsp,%rbp
  801d50:	48 83 ec 20          	sub    $0x20,%rsp
  801d54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d5b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d5f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d62:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d65:	48 63 f0             	movslq %eax,%rsi
  801d68:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d6f:	48 98                	cltq   
  801d71:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d75:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d7c:	00 
  801d7d:	49 89 f1             	mov    %rsi,%r9
  801d80:	49 89 c8             	mov    %rcx,%r8
  801d83:	48 89 d1             	mov    %rdx,%rcx
  801d86:	48 89 c2             	mov    %rax,%rdx
  801d89:	be 00 00 00 00       	mov    $0x0,%esi
  801d8e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d93:	48 b8 a2 19 80 00 00 	movabs $0x8019a2,%rax
  801d9a:	00 00 00 
  801d9d:	ff d0                	callq  *%rax
}
  801d9f:	c9                   	leaveq 
  801da0:	c3                   	retq   

0000000000801da1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801da1:	55                   	push   %rbp
  801da2:	48 89 e5             	mov    %rsp,%rbp
  801da5:	48 83 ec 10          	sub    $0x10,%rsp
  801da9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801dad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801db1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db8:	00 
  801db9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dbf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dc5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dca:	48 89 c2             	mov    %rax,%rdx
  801dcd:	be 01 00 00 00       	mov    $0x1,%esi
  801dd2:	bf 0d 00 00 00       	mov    $0xd,%edi
  801dd7:	48 b8 a2 19 80 00 00 	movabs $0x8019a2,%rax
  801dde:	00 00 00 
  801de1:	ff d0                	callq  *%rax
}
  801de3:	c9                   	leaveq 
  801de4:	c3                   	retq   

0000000000801de5 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801de5:	55                   	push   %rbp
  801de6:	48 89 e5             	mov    %rsp,%rbp
  801de9:	48 83 ec 30          	sub    $0x30,%rsp
  801ded:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801df1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801df5:	48 8b 00             	mov    (%rax),%rax
  801df8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801dfc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e00:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e04:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)))
  801e07:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e0a:	83 e0 02             	and    $0x2,%eax
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	74 23                	je     801e34 <pgfault+0x4f>
  801e11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e15:	48 c1 e8 0c          	shr    $0xc,%rax
  801e19:	48 89 c2             	mov    %rax,%rdx
  801e1c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e23:	01 00 00 
  801e26:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e2a:	25 00 08 00 00       	and    $0x800,%eax
  801e2f:	48 85 c0             	test   %rax,%rax
  801e32:	75 2a                	jne    801e5e <pgfault+0x79>
		panic("fail check at fork pgfault");
  801e34:	48 ba cb 41 80 00 00 	movabs $0x8041cb,%rdx
  801e3b:	00 00 00 
  801e3e:	be 1d 00 00 00       	mov    $0x1d,%esi
  801e43:	48 bf e6 41 80 00 00 	movabs $0x8041e6,%rdi
  801e4a:	00 00 00 
  801e4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e52:	48 b9 68 02 80 00 00 	movabs $0x800268,%rcx
  801e59:	00 00 00 
  801e5c:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801e5e:	ba 07 00 00 00       	mov    $0x7,%edx
  801e63:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e68:	bf 00 00 00 00       	mov    $0x0,%edi
  801e6d:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  801e74:	00 00 00 
  801e77:	ff d0                	callq  *%rax

	addr = ROUNDDOWN(addr, PGSIZE);
  801e79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801e81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e85:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801e8b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memmove(PFTEMP, addr, PGSIZE);
  801e8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e93:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e98:	48 89 c6             	mov    %rax,%rsi
  801e9b:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ea0:	48 b8 6d 15 80 00 00 	movabs $0x80156d,%rax
  801ea7:	00 00 00 
  801eaa:	ff d0                	callq  *%rax

	sys_page_map(0, (void *)PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W);
  801eac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eb0:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801eb6:	48 89 c1             	mov    %rax,%rcx
  801eb9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ebe:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ec3:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec8:	48 b8 c8 1b 80 00 00 	movabs $0x801bc8,%rax
  801ecf:	00 00 00 
  801ed2:	ff d0                	callq  *%rax
	sys_page_unmap(0, PFTEMP);
  801ed4:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ed9:	bf 00 00 00 00       	mov    $0x0,%edi
  801ede:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  801ee5:	00 00 00 
  801ee8:	ff d0                	callq  *%rax
	//panic("pgfault not implemented");
}
  801eea:	c9                   	leaveq 
  801eeb:	c3                   	retq   

0000000000801eec <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801eec:	55                   	push   %rbp
  801eed:	48 89 e5             	mov    %rsp,%rbp
  801ef0:	48 83 ec 20          	sub    $0x20,%rsp
  801ef4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ef7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uintptr_t)pn * PGSIZE);
  801efa:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801efd:	48 c1 e0 0c          	shl    $0xc,%rax
  801f01:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	// note: modified for LAB 5, supporting PTE_SHARE
	if (uvpt[pn] & PTE_SHARE) {
  801f05:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f0c:	01 00 00 
  801f0f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f12:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f16:	25 00 04 00 00       	and    $0x400,%eax
  801f1b:	48 85 c0             	test   %rax,%rax
  801f1e:	74 55                	je     801f75 <duppage+0x89>
		if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL))) < 0)
  801f20:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f27:	01 00 00 
  801f2a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f2d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f31:	25 07 0e 00 00       	and    $0xe07,%eax
  801f36:	89 c6                	mov    %eax,%esi
  801f38:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801f3c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f43:	41 89 f0             	mov    %esi,%r8d
  801f46:	48 89 c6             	mov    %rax,%rsi
  801f49:	bf 00 00 00 00       	mov    $0x0,%edi
  801f4e:	48 b8 c8 1b 80 00 00 	movabs $0x801bc8,%rax
  801f55:	00 00 00 
  801f58:	ff d0                	callq  *%rax
  801f5a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801f5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801f61:	79 08                	jns    801f6b <duppage+0x7f>
			return r;
  801f63:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f66:	e9 e1 00 00 00       	jmpq   80204c <duppage+0x160>
		return 0;
  801f6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f70:	e9 d7 00 00 00       	jmpq   80204c <duppage+0x160>
	}

	// note: here we must set ~PTE_W and PTE_COW such that parent process can get correct pid
	if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  801f75:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f7c:	01 00 00 
  801f7f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801f82:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f86:	25 05 06 00 00       	and    $0x605,%eax
  801f8b:	80 cc 08             	or     $0x8,%ah
  801f8e:	89 c6                	mov    %eax,%esi
  801f90:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801f94:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f9b:	41 89 f0             	mov    %esi,%r8d
  801f9e:	48 89 c6             	mov    %rax,%rsi
  801fa1:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa6:	48 b8 c8 1b 80 00 00 	movabs $0x801bc8,%rax
  801fad:	00 00 00 
  801fb0:	ff d0                	callq  *%rax
  801fb2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801fb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801fb9:	79 08                	jns    801fc3 <duppage+0xd7>
		return r;
  801fbb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fbe:	e9 89 00 00 00       	jmpq   80204c <duppage+0x160>

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  801fc3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fca:	01 00 00 
  801fcd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801fd0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fd4:	83 e0 02             	and    $0x2,%eax
  801fd7:	48 85 c0             	test   %rax,%rax
  801fda:	75 1b                	jne    801ff7 <duppage+0x10b>
  801fdc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fe3:	01 00 00 
  801fe6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801fe9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fed:	25 00 08 00 00       	and    $0x800,%eax
  801ff2:	48 85 c0             	test   %rax,%rax
  801ff5:	74 50                	je     802047 <duppage+0x15b>
		if ((r = sys_page_map(0, addr, 0, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  801ff7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ffe:	01 00 00 
  802001:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802004:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802008:	25 05 06 00 00       	and    $0x605,%eax
  80200d:	80 cc 08             	or     $0x8,%ah
  802010:	89 c1                	mov    %eax,%ecx
  802012:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802016:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80201a:	41 89 c8             	mov    %ecx,%r8d
  80201d:	48 89 d1             	mov    %rdx,%rcx
  802020:	ba 00 00 00 00       	mov    $0x0,%edx
  802025:	48 89 c6             	mov    %rax,%rsi
  802028:	bf 00 00 00 00       	mov    $0x0,%edi
  80202d:	48 b8 c8 1b 80 00 00 	movabs $0x801bc8,%rax
  802034:	00 00 00 
  802037:	ff d0                	callq  *%rax
  802039:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80203c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802040:	79 05                	jns    802047 <duppage+0x15b>
			return r;
  802042:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802045:	eb 05                	jmp    80204c <duppage+0x160>
	//panic("duppage not implemented");
	return 0;
  802047:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204c:	c9                   	leaveq 
  80204d:	c3                   	retq   

000000000080204e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80204e:	55                   	push   %rbp
  80204f:	48 89 e5             	mov    %rsp,%rbp
  802052:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	int r;
	envid_t envid;
	int i, j, k, l, ptx = 0;
  802056:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	set_pgfault_handler(pgfault);
  80205d:	48 bf e5 1d 80 00 00 	movabs $0x801de5,%rdi
  802064:	00 00 00 
  802067:	48 b8 e4 38 80 00 00 	movabs $0x8038e4,%rax
  80206e:	00 00 00 
  802071:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802073:	b8 07 00 00 00       	mov    $0x7,%eax
  802078:	cd 30                	int    $0x30
  80207a:	89 45 e0             	mov    %eax,-0x20(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80207d:	8b 45 e0             	mov    -0x20(%rbp),%eax

	if ((envid = sys_exofork()) < 0)
  802080:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802083:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802087:	79 08                	jns    802091 <fork+0x43>
		return envid;
  802089:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80208c:	e9 27 02 00 00       	jmpq   8022b8 <fork+0x26a>
	else if (envid == 0) {
  802091:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802095:	75 46                	jne    8020dd <fork+0x8f>
		thisenv = &envs[ENVX(sys_getenvid())];
  802097:	48 b8 fc 1a 80 00 00 	movabs $0x801afc,%rax
  80209e:	00 00 00 
  8020a1:	ff d0                	callq  *%rax
  8020a3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8020a8:	48 63 d0             	movslq %eax,%rdx
  8020ab:	48 89 d0             	mov    %rdx,%rax
  8020ae:	48 c1 e0 03          	shl    $0x3,%rax
  8020b2:	48 01 d0             	add    %rdx,%rax
  8020b5:	48 c1 e0 05          	shl    $0x5,%rax
  8020b9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8020c0:	00 00 00 
  8020c3:	48 01 c2             	add    %rax,%rdx
  8020c6:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8020cd:	00 00 00 
  8020d0:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8020d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d8:	e9 db 01 00 00       	jmpq   8022b8 <fork+0x26a>
	}

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8020dd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020e0:	ba 07 00 00 00       	mov    $0x7,%edx
  8020e5:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8020ea:	89 c7                	mov    %eax,%edi
  8020ec:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  8020f3:	00 00 00 
  8020f6:	ff d0                	callq  *%rax
  8020f8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8020fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8020ff:	79 08                	jns    802109 <fork+0xbb>
		return r;
  802101:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802104:	e9 af 01 00 00       	jmpq   8022b8 <fork+0x26a>

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  802109:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802110:	e9 49 01 00 00       	jmpq   80225e <fork+0x210>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  802115:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802118:	8d 90 ff ff ff 07    	lea    0x7ffffff(%rax),%edx
  80211e:	85 c0                	test   %eax,%eax
  802120:	0f 48 c2             	cmovs  %edx,%eax
  802123:	c1 f8 1b             	sar    $0x1b,%eax
  802126:	89 c2                	mov    %eax,%edx
  802128:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80212f:	01 00 00 
  802132:	48 63 d2             	movslq %edx,%rdx
  802135:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802139:	83 e0 01             	and    $0x1,%eax
  80213c:	48 85 c0             	test   %rax,%rax
  80213f:	75 0c                	jne    80214d <fork+0xff>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  802141:	81 45 ec 00 00 00 08 	addl   $0x8000000,-0x14(%rbp)
			continue;
  802148:	e9 0d 01 00 00       	jmpq   80225a <fork+0x20c>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  80214d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  802154:	e9 f4 00 00 00       	jmpq   80224d <fork+0x1ff>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  802159:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80215c:	8d 90 ff ff 03 00    	lea    0x3ffff(%rax),%edx
  802162:	85 c0                	test   %eax,%eax
  802164:	0f 48 c2             	cmovs  %edx,%eax
  802167:	c1 f8 12             	sar    $0x12,%eax
  80216a:	89 c2                	mov    %eax,%edx
  80216c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802173:	01 00 00 
  802176:	48 63 d2             	movslq %edx,%rdx
  802179:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80217d:	83 e0 01             	and    $0x1,%eax
  802180:	48 85 c0             	test   %rax,%rax
  802183:	75 0c                	jne    802191 <fork+0x143>
				ptx += NPDENTRIES * NPTENTRIES;
  802185:	81 45 ec 00 00 04 00 	addl   $0x40000,-0x14(%rbp)
				continue;
  80218c:	e9 b8 00 00 00       	jmpq   802249 <fork+0x1fb>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  802191:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  802198:	e9 9f 00 00 00       	jmpq   80223c <fork+0x1ee>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  80219d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021a0:	8d 90 ff 01 00 00    	lea    0x1ff(%rax),%edx
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	0f 48 c2             	cmovs  %edx,%eax
  8021ab:	c1 f8 09             	sar    $0x9,%eax
  8021ae:	89 c2                	mov    %eax,%edx
  8021b0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021b7:	01 00 00 
  8021ba:	48 63 d2             	movslq %edx,%rdx
  8021bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c1:	83 e0 01             	and    $0x1,%eax
  8021c4:	48 85 c0             	test   %rax,%rax
  8021c7:	75 09                	jne    8021d2 <fork+0x184>
					ptx += NPTENTRIES;
  8021c9:	81 45 ec 00 02 00 00 	addl   $0x200,-0x14(%rbp)
					continue;
  8021d0:	eb 66                	jmp    802238 <fork+0x1ea>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  8021d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8021d9:	eb 54                	jmp    80222f <fork+0x1e1>
					if ((uvpt[ptx] & PTE_P) != 0)
  8021db:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021e2:	01 00 00 
  8021e5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021e8:	48 63 d2             	movslq %edx,%rdx
  8021eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ef:	83 e0 01             	and    $0x1,%eax
  8021f2:	48 85 c0             	test   %rax,%rax
  8021f5:	74 30                	je     802227 <fork+0x1d9>
						if (ptx != VPN(UXSTACKTOP - PGSIZE))
  8021f7:	81 7d ec ff f7 0e 00 	cmpl   $0xef7ff,-0x14(%rbp)
  8021fe:	74 27                	je     802227 <fork+0x1d9>
							if ((r = duppage(envid, ptx)) < 0)
  802200:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802203:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802206:	89 d6                	mov    %edx,%esi
  802208:	89 c7                	mov    %eax,%edi
  80220a:	48 b8 ec 1e 80 00 00 	movabs $0x801eec,%rax
  802211:	00 00 00 
  802214:	ff d0                	callq  *%rax
  802216:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802219:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80221d:	79 08                	jns    802227 <fork+0x1d9>
								return r;
  80221f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802222:	e9 91 00 00 00       	jmpq   8022b8 <fork+0x26a>
					ptx++;
  802227:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  80222b:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  80222f:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
  802236:	7e a3                	jle    8021db <fork+0x18d>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  802238:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  80223c:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
  802243:	0f 8e 54 ff ff ff    	jle    80219d <fork+0x14f>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  802249:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80224d:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
  802254:	0f 8e ff fe ff ff    	jle    802159 <fork+0x10b>
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		return r;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  80225a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80225e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802262:	0f 84 ad fe ff ff    	je     802115 <fork+0xc7>
			}
		}
	}

	extern void _pgfault_upcall();
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  802268:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80226b:	48 be 4f 39 80 00 00 	movabs $0x80394f,%rsi
  802272:	00 00 00 
  802275:	89 c7                	mov    %eax,%edi
  802277:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  80227e:	00 00 00 
  802281:	ff d0                	callq  *%rax
  802283:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802286:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80228a:	79 05                	jns    802291 <fork+0x243>
		return r;
  80228c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80228f:	eb 27                	jmp    8022b8 <fork+0x26a>
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802291:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802294:	be 02 00 00 00       	mov    $0x2,%esi
  802299:	89 c7                	mov    %eax,%edi
  80229b:	48 b8 6d 1c 80 00 00 	movabs $0x801c6d,%rax
  8022a2:	00 00 00 
  8022a5:	ff d0                	callq  *%rax
  8022a7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8022aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8022ae:	79 05                	jns    8022b5 <fork+0x267>
		return r;
  8022b0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8022b3:	eb 03                	jmp    8022b8 <fork+0x26a>

	return envid;
  8022b5:	8b 45 e8             	mov    -0x18(%rbp),%eax
	//panic("fork not implemented");
}
  8022b8:	c9                   	leaveq 
  8022b9:	c3                   	retq   

00000000008022ba <sfork>:

// Challenge!
int
sfork(void)
{
  8022ba:	55                   	push   %rbp
  8022bb:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8022be:	48 ba f1 41 80 00 00 	movabs $0x8041f1,%rdx
  8022c5:	00 00 00 
  8022c8:	be a7 00 00 00       	mov    $0xa7,%esi
  8022cd:	48 bf e6 41 80 00 00 	movabs $0x8041e6,%rdi
  8022d4:	00 00 00 
  8022d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022dc:	48 b9 68 02 80 00 00 	movabs $0x800268,%rcx
  8022e3:	00 00 00 
  8022e6:	ff d1                	callq  *%rcx

00000000008022e8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8022e8:	55                   	push   %rbp
  8022e9:	48 89 e5             	mov    %rsp,%rbp
  8022ec:	48 83 ec 08          	sub    $0x8,%rsp
  8022f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8022f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8022f8:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8022ff:	ff ff ff 
  802302:	48 01 d0             	add    %rdx,%rax
  802305:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802309:	c9                   	leaveq 
  80230a:	c3                   	retq   

000000000080230b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80230b:	55                   	push   %rbp
  80230c:	48 89 e5             	mov    %rsp,%rbp
  80230f:	48 83 ec 08          	sub    $0x8,%rsp
  802313:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802317:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80231b:	48 89 c7             	mov    %rax,%rdi
  80231e:	48 b8 e8 22 80 00 00 	movabs $0x8022e8,%rax
  802325:	00 00 00 
  802328:	ff d0                	callq  *%rax
  80232a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802330:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802334:	c9                   	leaveq 
  802335:	c3                   	retq   

0000000000802336 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802336:	55                   	push   %rbp
  802337:	48 89 e5             	mov    %rsp,%rbp
  80233a:	48 83 ec 18          	sub    $0x18,%rsp
  80233e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802342:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802349:	eb 6b                	jmp    8023b6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80234b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80234e:	48 98                	cltq   
  802350:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802356:	48 c1 e0 0c          	shl    $0xc,%rax
  80235a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80235e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802362:	48 c1 e8 15          	shr    $0x15,%rax
  802366:	48 89 c2             	mov    %rax,%rdx
  802369:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802370:	01 00 00 
  802373:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802377:	83 e0 01             	and    $0x1,%eax
  80237a:	48 85 c0             	test   %rax,%rax
  80237d:	74 21                	je     8023a0 <fd_alloc+0x6a>
  80237f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802383:	48 c1 e8 0c          	shr    $0xc,%rax
  802387:	48 89 c2             	mov    %rax,%rdx
  80238a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802391:	01 00 00 
  802394:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802398:	83 e0 01             	and    $0x1,%eax
  80239b:	48 85 c0             	test   %rax,%rax
  80239e:	75 12                	jne    8023b2 <fd_alloc+0x7c>
			*fd_store = fd;
  8023a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023a8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b0:	eb 1a                	jmp    8023cc <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023b2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023b6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8023ba:	7e 8f                	jle    80234b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8023bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8023c7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8023cc:	c9                   	leaveq 
  8023cd:	c3                   	retq   

00000000008023ce <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8023ce:	55                   	push   %rbp
  8023cf:	48 89 e5             	mov    %rsp,%rbp
  8023d2:	48 83 ec 20          	sub    $0x20,%rsp
  8023d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8023dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023e1:	78 06                	js     8023e9 <fd_lookup+0x1b>
  8023e3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8023e7:	7e 07                	jle    8023f0 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8023e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023ee:	eb 6c                	jmp    80245c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8023f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023f3:	48 98                	cltq   
  8023f5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023fb:	48 c1 e0 0c          	shl    $0xc,%rax
  8023ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802403:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802407:	48 c1 e8 15          	shr    $0x15,%rax
  80240b:	48 89 c2             	mov    %rax,%rdx
  80240e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802415:	01 00 00 
  802418:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80241c:	83 e0 01             	and    $0x1,%eax
  80241f:	48 85 c0             	test   %rax,%rax
  802422:	74 21                	je     802445 <fd_lookup+0x77>
  802424:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802428:	48 c1 e8 0c          	shr    $0xc,%rax
  80242c:	48 89 c2             	mov    %rax,%rdx
  80242f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802436:	01 00 00 
  802439:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80243d:	83 e0 01             	and    $0x1,%eax
  802440:	48 85 c0             	test   %rax,%rax
  802443:	75 07                	jne    80244c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802445:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80244a:	eb 10                	jmp    80245c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80244c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802450:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802454:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802457:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80245c:	c9                   	leaveq 
  80245d:	c3                   	retq   

000000000080245e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80245e:	55                   	push   %rbp
  80245f:	48 89 e5             	mov    %rsp,%rbp
  802462:	48 83 ec 30          	sub    $0x30,%rsp
  802466:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80246a:	89 f0                	mov    %esi,%eax
  80246c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80246f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802473:	48 89 c7             	mov    %rax,%rdi
  802476:	48 b8 e8 22 80 00 00 	movabs $0x8022e8,%rax
  80247d:	00 00 00 
  802480:	ff d0                	callq  *%rax
  802482:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802486:	48 89 d6             	mov    %rdx,%rsi
  802489:	89 c7                	mov    %eax,%edi
  80248b:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  802492:	00 00 00 
  802495:	ff d0                	callq  *%rax
  802497:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80249a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80249e:	78 0a                	js     8024aa <fd_close+0x4c>
	    || fd != fd2)
  8024a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8024a8:	74 12                	je     8024bc <fd_close+0x5e>
		return (must_exist ? r : 0);
  8024aa:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8024ae:	74 05                	je     8024b5 <fd_close+0x57>
  8024b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b3:	eb 05                	jmp    8024ba <fd_close+0x5c>
  8024b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ba:	eb 69                	jmp    802525 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8024bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024c0:	8b 00                	mov    (%rax),%eax
  8024c2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024c6:	48 89 d6             	mov    %rdx,%rsi
  8024c9:	89 c7                	mov    %eax,%edi
  8024cb:	48 b8 27 25 80 00 00 	movabs $0x802527,%rax
  8024d2:	00 00 00 
  8024d5:	ff d0                	callq  *%rax
  8024d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024de:	78 2a                	js     80250a <fd_close+0xac>
		if (dev->dev_close)
  8024e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e4:	48 8b 40 20          	mov    0x20(%rax),%rax
  8024e8:	48 85 c0             	test   %rax,%rax
  8024eb:	74 16                	je     802503 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8024ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f1:	48 8b 40 20          	mov    0x20(%rax),%rax
  8024f5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024f9:	48 89 d7             	mov    %rdx,%rdi
  8024fc:	ff d0                	callq  *%rax
  8024fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802501:	eb 07                	jmp    80250a <fd_close+0xac>
		else
			r = 0;
  802503:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80250a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80250e:	48 89 c6             	mov    %rax,%rsi
  802511:	bf 00 00 00 00       	mov    $0x0,%edi
  802516:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  80251d:	00 00 00 
  802520:	ff d0                	callq  *%rax
	return r;
  802522:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802525:	c9                   	leaveq 
  802526:	c3                   	retq   

0000000000802527 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802527:	55                   	push   %rbp
  802528:	48 89 e5             	mov    %rsp,%rbp
  80252b:	48 83 ec 20          	sub    $0x20,%rsp
  80252f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802532:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802536:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80253d:	eb 41                	jmp    802580 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80253f:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802546:	00 00 00 
  802549:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80254c:	48 63 d2             	movslq %edx,%rdx
  80254f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802553:	8b 00                	mov    (%rax),%eax
  802555:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802558:	75 22                	jne    80257c <dev_lookup+0x55>
			*dev = devtab[i];
  80255a:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802561:	00 00 00 
  802564:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802567:	48 63 d2             	movslq %edx,%rdx
  80256a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80256e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802572:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802575:	b8 00 00 00 00       	mov    $0x0,%eax
  80257a:	eb 60                	jmp    8025dc <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80257c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802580:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802587:	00 00 00 
  80258a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80258d:	48 63 d2             	movslq %edx,%rdx
  802590:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802594:	48 85 c0             	test   %rax,%rax
  802597:	75 a6                	jne    80253f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802599:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8025a0:	00 00 00 
  8025a3:	48 8b 00             	mov    (%rax),%rax
  8025a6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025ac:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8025af:	89 c6                	mov    %eax,%esi
  8025b1:	48 bf 08 42 80 00 00 	movabs $0x804208,%rdi
  8025b8:	00 00 00 
  8025bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c0:	48 b9 a1 04 80 00 00 	movabs $0x8004a1,%rcx
  8025c7:	00 00 00 
  8025ca:	ff d1                	callq  *%rcx
	*dev = 0;
  8025cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025d0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8025d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8025dc:	c9                   	leaveq 
  8025dd:	c3                   	retq   

00000000008025de <close>:

int
close(int fdnum)
{
  8025de:	55                   	push   %rbp
  8025df:	48 89 e5             	mov    %rsp,%rbp
  8025e2:	48 83 ec 20          	sub    $0x20,%rsp
  8025e6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025e9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025f0:	48 89 d6             	mov    %rdx,%rsi
  8025f3:	89 c7                	mov    %eax,%edi
  8025f5:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  8025fc:	00 00 00 
  8025ff:	ff d0                	callq  *%rax
  802601:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802604:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802608:	79 05                	jns    80260f <close+0x31>
		return r;
  80260a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80260d:	eb 18                	jmp    802627 <close+0x49>
	else
		return fd_close(fd, 1);
  80260f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802613:	be 01 00 00 00       	mov    $0x1,%esi
  802618:	48 89 c7             	mov    %rax,%rdi
  80261b:	48 b8 5e 24 80 00 00 	movabs $0x80245e,%rax
  802622:	00 00 00 
  802625:	ff d0                	callq  *%rax
}
  802627:	c9                   	leaveq 
  802628:	c3                   	retq   

0000000000802629 <close_all>:

void
close_all(void)
{
  802629:	55                   	push   %rbp
  80262a:	48 89 e5             	mov    %rsp,%rbp
  80262d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802631:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802638:	eb 15                	jmp    80264f <close_all+0x26>
		close(i);
  80263a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263d:	89 c7                	mov    %eax,%edi
  80263f:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802646:	00 00 00 
  802649:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80264b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80264f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802653:	7e e5                	jle    80263a <close_all+0x11>
		close(i);
}
  802655:	c9                   	leaveq 
  802656:	c3                   	retq   

0000000000802657 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802657:	55                   	push   %rbp
  802658:	48 89 e5             	mov    %rsp,%rbp
  80265b:	48 83 ec 40          	sub    $0x40,%rsp
  80265f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802662:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802665:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802669:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80266c:	48 89 d6             	mov    %rdx,%rsi
  80266f:	89 c7                	mov    %eax,%edi
  802671:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  802678:	00 00 00 
  80267b:	ff d0                	callq  *%rax
  80267d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802680:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802684:	79 08                	jns    80268e <dup+0x37>
		return r;
  802686:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802689:	e9 70 01 00 00       	jmpq   8027fe <dup+0x1a7>
	close(newfdnum);
  80268e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802691:	89 c7                	mov    %eax,%edi
  802693:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  80269a:	00 00 00 
  80269d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80269f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026a2:	48 98                	cltq   
  8026a4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026aa:	48 c1 e0 0c          	shl    $0xc,%rax
  8026ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8026b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026b6:	48 89 c7             	mov    %rax,%rdi
  8026b9:	48 b8 0b 23 80 00 00 	movabs $0x80230b,%rax
  8026c0:	00 00 00 
  8026c3:	ff d0                	callq  *%rax
  8026c5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8026c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026cd:	48 89 c7             	mov    %rax,%rdi
  8026d0:	48 b8 0b 23 80 00 00 	movabs $0x80230b,%rax
  8026d7:	00 00 00 
  8026da:	ff d0                	callq  *%rax
  8026dc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8026e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e4:	48 c1 e8 15          	shr    $0x15,%rax
  8026e8:	48 89 c2             	mov    %rax,%rdx
  8026eb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026f2:	01 00 00 
  8026f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026f9:	83 e0 01             	and    $0x1,%eax
  8026fc:	48 85 c0             	test   %rax,%rax
  8026ff:	74 73                	je     802774 <dup+0x11d>
  802701:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802705:	48 c1 e8 0c          	shr    $0xc,%rax
  802709:	48 89 c2             	mov    %rax,%rdx
  80270c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802713:	01 00 00 
  802716:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80271a:	83 e0 01             	and    $0x1,%eax
  80271d:	48 85 c0             	test   %rax,%rax
  802720:	74 52                	je     802774 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802722:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802726:	48 c1 e8 0c          	shr    $0xc,%rax
  80272a:	48 89 c2             	mov    %rax,%rdx
  80272d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802734:	01 00 00 
  802737:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80273b:	25 07 0e 00 00       	and    $0xe07,%eax
  802740:	89 c1                	mov    %eax,%ecx
  802742:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274a:	41 89 c8             	mov    %ecx,%r8d
  80274d:	48 89 d1             	mov    %rdx,%rcx
  802750:	ba 00 00 00 00       	mov    $0x0,%edx
  802755:	48 89 c6             	mov    %rax,%rsi
  802758:	bf 00 00 00 00       	mov    $0x0,%edi
  80275d:	48 b8 c8 1b 80 00 00 	movabs $0x801bc8,%rax
  802764:	00 00 00 
  802767:	ff d0                	callq  *%rax
  802769:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80276c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802770:	79 02                	jns    802774 <dup+0x11d>
			goto err;
  802772:	eb 57                	jmp    8027cb <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802774:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802778:	48 c1 e8 0c          	shr    $0xc,%rax
  80277c:	48 89 c2             	mov    %rax,%rdx
  80277f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802786:	01 00 00 
  802789:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80278d:	25 07 0e 00 00       	and    $0xe07,%eax
  802792:	89 c1                	mov    %eax,%ecx
  802794:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802798:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80279c:	41 89 c8             	mov    %ecx,%r8d
  80279f:	48 89 d1             	mov    %rdx,%rcx
  8027a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a7:	48 89 c6             	mov    %rax,%rsi
  8027aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8027af:	48 b8 c8 1b 80 00 00 	movabs $0x801bc8,%rax
  8027b6:	00 00 00 
  8027b9:	ff d0                	callq  *%rax
  8027bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c2:	79 02                	jns    8027c6 <dup+0x16f>
		goto err;
  8027c4:	eb 05                	jmp    8027cb <dup+0x174>

	return newfdnum;
  8027c6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027c9:	eb 33                	jmp    8027fe <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8027cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027cf:	48 89 c6             	mov    %rax,%rsi
  8027d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8027d7:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  8027de:	00 00 00 
  8027e1:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8027e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027e7:	48 89 c6             	mov    %rax,%rsi
  8027ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ef:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  8027f6:	00 00 00 
  8027f9:	ff d0                	callq  *%rax
	return r;
  8027fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027fe:	c9                   	leaveq 
  8027ff:	c3                   	retq   

0000000000802800 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802800:	55                   	push   %rbp
  802801:	48 89 e5             	mov    %rsp,%rbp
  802804:	48 83 ec 40          	sub    $0x40,%rsp
  802808:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80280b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80280f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802813:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802817:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80281a:	48 89 d6             	mov    %rdx,%rsi
  80281d:	89 c7                	mov    %eax,%edi
  80281f:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  802826:	00 00 00 
  802829:	ff d0                	callq  *%rax
  80282b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80282e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802832:	78 24                	js     802858 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802834:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802838:	8b 00                	mov    (%rax),%eax
  80283a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80283e:	48 89 d6             	mov    %rdx,%rsi
  802841:	89 c7                	mov    %eax,%edi
  802843:	48 b8 27 25 80 00 00 	movabs $0x802527,%rax
  80284a:	00 00 00 
  80284d:	ff d0                	callq  *%rax
  80284f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802852:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802856:	79 05                	jns    80285d <read+0x5d>
		return r;
  802858:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80285b:	eb 76                	jmp    8028d3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80285d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802861:	8b 40 08             	mov    0x8(%rax),%eax
  802864:	83 e0 03             	and    $0x3,%eax
  802867:	83 f8 01             	cmp    $0x1,%eax
  80286a:	75 3a                	jne    8028a6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80286c:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  802873:	00 00 00 
  802876:	48 8b 00             	mov    (%rax),%rax
  802879:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80287f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802882:	89 c6                	mov    %eax,%esi
  802884:	48 bf 27 42 80 00 00 	movabs $0x804227,%rdi
  80288b:	00 00 00 
  80288e:	b8 00 00 00 00       	mov    $0x0,%eax
  802893:	48 b9 a1 04 80 00 00 	movabs $0x8004a1,%rcx
  80289a:	00 00 00 
  80289d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80289f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028a4:	eb 2d                	jmp    8028d3 <read+0xd3>
	}
	if (!dev->dev_read)
  8028a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028aa:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028ae:	48 85 c0             	test   %rax,%rax
  8028b1:	75 07                	jne    8028ba <read+0xba>
		return -E_NOT_SUPP;
  8028b3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028b8:	eb 19                	jmp    8028d3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8028ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028be:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028c2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028c6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028ca:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028ce:	48 89 cf             	mov    %rcx,%rdi
  8028d1:	ff d0                	callq  *%rax
}
  8028d3:	c9                   	leaveq 
  8028d4:	c3                   	retq   

00000000008028d5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8028d5:	55                   	push   %rbp
  8028d6:	48 89 e5             	mov    %rsp,%rbp
  8028d9:	48 83 ec 30          	sub    $0x30,%rsp
  8028dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8028e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028ef:	eb 49                	jmp    80293a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8028f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f4:	48 98                	cltq   
  8028f6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028fa:	48 29 c2             	sub    %rax,%rdx
  8028fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802900:	48 63 c8             	movslq %eax,%rcx
  802903:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802907:	48 01 c1             	add    %rax,%rcx
  80290a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80290d:	48 89 ce             	mov    %rcx,%rsi
  802910:	89 c7                	mov    %eax,%edi
  802912:	48 b8 00 28 80 00 00 	movabs $0x802800,%rax
  802919:	00 00 00 
  80291c:	ff d0                	callq  *%rax
  80291e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802921:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802925:	79 05                	jns    80292c <readn+0x57>
			return m;
  802927:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80292a:	eb 1c                	jmp    802948 <readn+0x73>
		if (m == 0)
  80292c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802930:	75 02                	jne    802934 <readn+0x5f>
			break;
  802932:	eb 11                	jmp    802945 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802934:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802937:	01 45 fc             	add    %eax,-0x4(%rbp)
  80293a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80293d:	48 98                	cltq   
  80293f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802943:	72 ac                	jb     8028f1 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802945:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802948:	c9                   	leaveq 
  802949:	c3                   	retq   

000000000080294a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80294a:	55                   	push   %rbp
  80294b:	48 89 e5             	mov    %rsp,%rbp
  80294e:	48 83 ec 40          	sub    $0x40,%rsp
  802952:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802955:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802959:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80295d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802961:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802964:	48 89 d6             	mov    %rdx,%rsi
  802967:	89 c7                	mov    %eax,%edi
  802969:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  802970:	00 00 00 
  802973:	ff d0                	callq  *%rax
  802975:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802978:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80297c:	78 24                	js     8029a2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80297e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802982:	8b 00                	mov    (%rax),%eax
  802984:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802988:	48 89 d6             	mov    %rdx,%rsi
  80298b:	89 c7                	mov    %eax,%edi
  80298d:	48 b8 27 25 80 00 00 	movabs $0x802527,%rax
  802994:	00 00 00 
  802997:	ff d0                	callq  *%rax
  802999:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80299c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a0:	79 05                	jns    8029a7 <write+0x5d>
		return r;
  8029a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a5:	eb 75                	jmp    802a1c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ab:	8b 40 08             	mov    0x8(%rax),%eax
  8029ae:	83 e0 03             	and    $0x3,%eax
  8029b1:	85 c0                	test   %eax,%eax
  8029b3:	75 3a                	jne    8029ef <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8029b5:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8029bc:	00 00 00 
  8029bf:	48 8b 00             	mov    (%rax),%rax
  8029c2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029c8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029cb:	89 c6                	mov    %eax,%esi
  8029cd:	48 bf 43 42 80 00 00 	movabs $0x804243,%rdi
  8029d4:	00 00 00 
  8029d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029dc:	48 b9 a1 04 80 00 00 	movabs $0x8004a1,%rcx
  8029e3:	00 00 00 
  8029e6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029ed:	eb 2d                	jmp    802a1c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8029ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029f3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8029f7:	48 85 c0             	test   %rax,%rax
  8029fa:	75 07                	jne    802a03 <write+0xb9>
		return -E_NOT_SUPP;
  8029fc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a01:	eb 19                	jmp    802a1c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802a03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a07:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a0b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a0f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a13:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a17:	48 89 cf             	mov    %rcx,%rdi
  802a1a:	ff d0                	callq  *%rax
}
  802a1c:	c9                   	leaveq 
  802a1d:	c3                   	retq   

0000000000802a1e <seek>:

int
seek(int fdnum, off_t offset)
{
  802a1e:	55                   	push   %rbp
  802a1f:	48 89 e5             	mov    %rsp,%rbp
  802a22:	48 83 ec 18          	sub    $0x18,%rsp
  802a26:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a29:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a2c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a30:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a33:	48 89 d6             	mov    %rdx,%rsi
  802a36:	89 c7                	mov    %eax,%edi
  802a38:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  802a3f:	00 00 00 
  802a42:	ff d0                	callq  *%rax
  802a44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a4b:	79 05                	jns    802a52 <seek+0x34>
		return r;
  802a4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a50:	eb 0f                	jmp    802a61 <seek+0x43>
	fd->fd_offset = offset;
  802a52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a56:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a59:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802a5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a61:	c9                   	leaveq 
  802a62:	c3                   	retq   

0000000000802a63 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a63:	55                   	push   %rbp
  802a64:	48 89 e5             	mov    %rsp,%rbp
  802a67:	48 83 ec 30          	sub    $0x30,%rsp
  802a6b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a6e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a71:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a75:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a78:	48 89 d6             	mov    %rdx,%rsi
  802a7b:	89 c7                	mov    %eax,%edi
  802a7d:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  802a84:	00 00 00 
  802a87:	ff d0                	callq  *%rax
  802a89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a90:	78 24                	js     802ab6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a96:	8b 00                	mov    (%rax),%eax
  802a98:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a9c:	48 89 d6             	mov    %rdx,%rsi
  802a9f:	89 c7                	mov    %eax,%edi
  802aa1:	48 b8 27 25 80 00 00 	movabs $0x802527,%rax
  802aa8:	00 00 00 
  802aab:	ff d0                	callq  *%rax
  802aad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab4:	79 05                	jns    802abb <ftruncate+0x58>
		return r;
  802ab6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab9:	eb 72                	jmp    802b2d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802abb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802abf:	8b 40 08             	mov    0x8(%rax),%eax
  802ac2:	83 e0 03             	and    $0x3,%eax
  802ac5:	85 c0                	test   %eax,%eax
  802ac7:	75 3a                	jne    802b03 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ac9:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  802ad0:	00 00 00 
  802ad3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802ad6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802adc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802adf:	89 c6                	mov    %eax,%esi
  802ae1:	48 bf 60 42 80 00 00 	movabs $0x804260,%rdi
  802ae8:	00 00 00 
  802aeb:	b8 00 00 00 00       	mov    $0x0,%eax
  802af0:	48 b9 a1 04 80 00 00 	movabs $0x8004a1,%rcx
  802af7:	00 00 00 
  802afa:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802afc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b01:	eb 2a                	jmp    802b2d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b07:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b0b:	48 85 c0             	test   %rax,%rax
  802b0e:	75 07                	jne    802b17 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b10:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b15:	eb 16                	jmp    802b2d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b1b:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b1f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b23:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802b26:	89 ce                	mov    %ecx,%esi
  802b28:	48 89 d7             	mov    %rdx,%rdi
  802b2b:	ff d0                	callq  *%rax
}
  802b2d:	c9                   	leaveq 
  802b2e:	c3                   	retq   

0000000000802b2f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b2f:	55                   	push   %rbp
  802b30:	48 89 e5             	mov    %rsp,%rbp
  802b33:	48 83 ec 30          	sub    $0x30,%rsp
  802b37:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b3a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b3e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b42:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b45:	48 89 d6             	mov    %rdx,%rsi
  802b48:	89 c7                	mov    %eax,%edi
  802b4a:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  802b51:	00 00 00 
  802b54:	ff d0                	callq  *%rax
  802b56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5d:	78 24                	js     802b83 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b63:	8b 00                	mov    (%rax),%eax
  802b65:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b69:	48 89 d6             	mov    %rdx,%rsi
  802b6c:	89 c7                	mov    %eax,%edi
  802b6e:	48 b8 27 25 80 00 00 	movabs $0x802527,%rax
  802b75:	00 00 00 
  802b78:	ff d0                	callq  *%rax
  802b7a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b81:	79 05                	jns    802b88 <fstat+0x59>
		return r;
  802b83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b86:	eb 5e                	jmp    802be6 <fstat+0xb7>
	if (!dev->dev_stat)
  802b88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b8c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b90:	48 85 c0             	test   %rax,%rax
  802b93:	75 07                	jne    802b9c <fstat+0x6d>
		return -E_NOT_SUPP;
  802b95:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b9a:	eb 4a                	jmp    802be6 <fstat+0xb7>
	stat->st_name[0] = 0;
  802b9c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ba0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802ba3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ba7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802bae:	00 00 00 
	stat->st_isdir = 0;
  802bb1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bb5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802bbc:	00 00 00 
	stat->st_dev = dev;
  802bbf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bc3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bc7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802bce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd2:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bd6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bda:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802bde:	48 89 ce             	mov    %rcx,%rsi
  802be1:	48 89 d7             	mov    %rdx,%rdi
  802be4:	ff d0                	callq  *%rax
}
  802be6:	c9                   	leaveq 
  802be7:	c3                   	retq   

0000000000802be8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802be8:	55                   	push   %rbp
  802be9:	48 89 e5             	mov    %rsp,%rbp
  802bec:	48 83 ec 20          	sub    $0x20,%rsp
  802bf0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bf4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802bf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfc:	be 00 00 00 00       	mov    $0x0,%esi
  802c01:	48 89 c7             	mov    %rax,%rdi
  802c04:	48 b8 d6 2c 80 00 00 	movabs $0x802cd6,%rax
  802c0b:	00 00 00 
  802c0e:	ff d0                	callq  *%rax
  802c10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c17:	79 05                	jns    802c1e <stat+0x36>
		return fd;
  802c19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1c:	eb 2f                	jmp    802c4d <stat+0x65>
	r = fstat(fd, stat);
  802c1e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c25:	48 89 d6             	mov    %rdx,%rsi
  802c28:	89 c7                	mov    %eax,%edi
  802c2a:	48 b8 2f 2b 80 00 00 	movabs $0x802b2f,%rax
  802c31:	00 00 00 
  802c34:	ff d0                	callq  *%rax
  802c36:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3c:	89 c7                	mov    %eax,%edi
  802c3e:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802c45:	00 00 00 
  802c48:	ff d0                	callq  *%rax
	return r;
  802c4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802c4d:	c9                   	leaveq 
  802c4e:	c3                   	retq   

0000000000802c4f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802c4f:	55                   	push   %rbp
  802c50:	48 89 e5             	mov    %rsp,%rbp
  802c53:	48 83 ec 10          	sub    $0x10,%rsp
  802c57:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802c5e:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802c65:	00 00 00 
  802c68:	8b 00                	mov    (%rax),%eax
  802c6a:	85 c0                	test   %eax,%eax
  802c6c:	75 1d                	jne    802c8b <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802c6e:	bf 01 00 00 00       	mov    $0x1,%edi
  802c73:	48 b8 3a 3b 80 00 00 	movabs $0x803b3a,%rax
  802c7a:	00 00 00 
  802c7d:	ff d0                	callq  *%rax
  802c7f:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  802c86:	00 00 00 
  802c89:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802c8b:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802c92:	00 00 00 
  802c95:	8b 00                	mov    (%rax),%eax
  802c97:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c9a:	b9 07 00 00 00       	mov    $0x7,%ecx
  802c9f:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802ca6:	00 00 00 
  802ca9:	89 c7                	mov    %eax,%edi
  802cab:	48 b8 a2 3a 80 00 00 	movabs $0x803aa2,%rax
  802cb2:	00 00 00 
  802cb5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802cb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cbb:	ba 00 00 00 00       	mov    $0x0,%edx
  802cc0:	48 89 c6             	mov    %rax,%rsi
  802cc3:	bf 00 00 00 00       	mov    $0x0,%edi
  802cc8:	48 b8 d9 39 80 00 00 	movabs $0x8039d9,%rax
  802ccf:	00 00 00 
  802cd2:	ff d0                	callq  *%rax
}
  802cd4:	c9                   	leaveq 
  802cd5:	c3                   	retq   

0000000000802cd6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802cd6:	55                   	push   %rbp
  802cd7:	48 89 e5             	mov    %rsp,%rbp
  802cda:	48 83 ec 20          	sub    $0x20,%rsp
  802cde:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ce2:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802ce5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce9:	48 89 c7             	mov    %rax,%rdi
  802cec:	48 b8 dd 11 80 00 00 	movabs $0x8011dd,%rax
  802cf3:	00 00 00 
  802cf6:	ff d0                	callq  *%rax
  802cf8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802cfd:	7e 0a                	jle    802d09 <open+0x33>
		return -E_BAD_PATH;
  802cff:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d04:	e9 a5 00 00 00       	jmpq   802dae <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802d09:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d0d:	48 89 c7             	mov    %rax,%rdi
  802d10:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  802d17:	00 00 00 
  802d1a:	ff d0                	callq  *%rax
  802d1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d23:	79 08                	jns    802d2d <open+0x57>
		return r;
  802d25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d28:	e9 81 00 00 00       	jmpq   802dae <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802d2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d31:	48 89 c6             	mov    %rax,%rsi
  802d34:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802d3b:	00 00 00 
  802d3e:	48 b8 49 12 80 00 00 	movabs $0x801249,%rax
  802d45:	00 00 00 
  802d48:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802d4a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d51:	00 00 00 
  802d54:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802d57:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802d5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d61:	48 89 c6             	mov    %rax,%rsi
  802d64:	bf 01 00 00 00       	mov    $0x1,%edi
  802d69:	48 b8 4f 2c 80 00 00 	movabs $0x802c4f,%rax
  802d70:	00 00 00 
  802d73:	ff d0                	callq  *%rax
  802d75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d7c:	79 1d                	jns    802d9b <open+0xc5>
		fd_close(fd, 0);
  802d7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d82:	be 00 00 00 00       	mov    $0x0,%esi
  802d87:	48 89 c7             	mov    %rax,%rdi
  802d8a:	48 b8 5e 24 80 00 00 	movabs $0x80245e,%rax
  802d91:	00 00 00 
  802d94:	ff d0                	callq  *%rax
		return r;
  802d96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d99:	eb 13                	jmp    802dae <open+0xd8>
	}

	return fd2num(fd);
  802d9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d9f:	48 89 c7             	mov    %rax,%rdi
  802da2:	48 b8 e8 22 80 00 00 	movabs $0x8022e8,%rax
  802da9:	00 00 00 
  802dac:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802dae:	c9                   	leaveq 
  802daf:	c3                   	retq   

0000000000802db0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802db0:	55                   	push   %rbp
  802db1:	48 89 e5             	mov    %rsp,%rbp
  802db4:	48 83 ec 10          	sub    $0x10,%rsp
  802db8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802dbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dc0:	8b 50 0c             	mov    0xc(%rax),%edx
  802dc3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802dca:	00 00 00 
  802dcd:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802dcf:	be 00 00 00 00       	mov    $0x0,%esi
  802dd4:	bf 06 00 00 00       	mov    $0x6,%edi
  802dd9:	48 b8 4f 2c 80 00 00 	movabs $0x802c4f,%rax
  802de0:	00 00 00 
  802de3:	ff d0                	callq  *%rax
}
  802de5:	c9                   	leaveq 
  802de6:	c3                   	retq   

0000000000802de7 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802de7:	55                   	push   %rbp
  802de8:	48 89 e5             	mov    %rsp,%rbp
  802deb:	48 83 ec 30          	sub    $0x30,%rsp
  802def:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802df3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802df7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802dfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dff:	8b 50 0c             	mov    0xc(%rax),%edx
  802e02:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e09:	00 00 00 
  802e0c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e0e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e15:	00 00 00 
  802e18:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e1c:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802e20:	be 00 00 00 00       	mov    $0x0,%esi
  802e25:	bf 03 00 00 00       	mov    $0x3,%edi
  802e2a:	48 b8 4f 2c 80 00 00 	movabs $0x802c4f,%rax
  802e31:	00 00 00 
  802e34:	ff d0                	callq  *%rax
  802e36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e3d:	79 05                	jns    802e44 <devfile_read+0x5d>
		return r;
  802e3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e42:	eb 26                	jmp    802e6a <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802e44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e47:	48 63 d0             	movslq %eax,%rdx
  802e4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e4e:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802e55:	00 00 00 
  802e58:	48 89 c7             	mov    %rax,%rdi
  802e5b:	48 b8 6d 15 80 00 00 	movabs $0x80156d,%rax
  802e62:	00 00 00 
  802e65:	ff d0                	callq  *%rax

	return r;
  802e67:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802e6a:	c9                   	leaveq 
  802e6b:	c3                   	retq   

0000000000802e6c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802e6c:	55                   	push   %rbp
  802e6d:	48 89 e5             	mov    %rsp,%rbp
  802e70:	48 83 ec 30          	sub    $0x30,%rsp
  802e74:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e78:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e7c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802e80:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802e87:	00 
  802e88:	76 08                	jbe    802e92 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802e8a:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802e91:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802e92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e96:	8b 50 0c             	mov    0xc(%rax),%edx
  802e99:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ea0:	00 00 00 
  802ea3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802ea5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802eac:	00 00 00 
  802eaf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802eb3:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  802eb7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ebb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ebf:	48 89 c6             	mov    %rax,%rsi
  802ec2:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802ec9:	00 00 00 
  802ecc:	48 b8 6d 15 80 00 00 	movabs $0x80156d,%rax
  802ed3:	00 00 00 
  802ed6:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802ed8:	be 00 00 00 00       	mov    $0x0,%esi
  802edd:	bf 04 00 00 00       	mov    $0x4,%edi
  802ee2:	48 b8 4f 2c 80 00 00 	movabs $0x802c4f,%rax
  802ee9:	00 00 00 
  802eec:	ff d0                	callq  *%rax
  802eee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ef1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ef5:	79 05                	jns    802efc <devfile_write+0x90>
		return r;
  802ef7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802efa:	eb 03                	jmp    802eff <devfile_write+0x93>

	return r;
  802efc:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802eff:	c9                   	leaveq 
  802f00:	c3                   	retq   

0000000000802f01 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802f01:	55                   	push   %rbp
  802f02:	48 89 e5             	mov    %rsp,%rbp
  802f05:	48 83 ec 20          	sub    $0x20,%rsp
  802f09:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f0d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f15:	8b 50 0c             	mov    0xc(%rax),%edx
  802f18:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f1f:	00 00 00 
  802f22:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f24:	be 00 00 00 00       	mov    $0x0,%esi
  802f29:	bf 05 00 00 00       	mov    $0x5,%edi
  802f2e:	48 b8 4f 2c 80 00 00 	movabs $0x802c4f,%rax
  802f35:	00 00 00 
  802f38:	ff d0                	callq  *%rax
  802f3a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f41:	79 05                	jns    802f48 <devfile_stat+0x47>
		return r;
  802f43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f46:	eb 56                	jmp    802f9e <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f4c:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802f53:	00 00 00 
  802f56:	48 89 c7             	mov    %rax,%rdi
  802f59:	48 b8 49 12 80 00 00 	movabs $0x801249,%rax
  802f60:	00 00 00 
  802f63:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802f65:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f6c:	00 00 00 
  802f6f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802f75:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f79:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f7f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802f86:	00 00 00 
  802f89:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802f8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f93:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802f99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f9e:	c9                   	leaveq 
  802f9f:	c3                   	retq   

0000000000802fa0 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802fa0:	55                   	push   %rbp
  802fa1:	48 89 e5             	mov    %rsp,%rbp
  802fa4:	48 83 ec 10          	sub    $0x10,%rsp
  802fa8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fac:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802faf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fb3:	8b 50 0c             	mov    0xc(%rax),%edx
  802fb6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802fbd:	00 00 00 
  802fc0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802fc2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802fc9:	00 00 00 
  802fcc:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802fcf:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802fd2:	be 00 00 00 00       	mov    $0x0,%esi
  802fd7:	bf 02 00 00 00       	mov    $0x2,%edi
  802fdc:	48 b8 4f 2c 80 00 00 	movabs $0x802c4f,%rax
  802fe3:	00 00 00 
  802fe6:	ff d0                	callq  *%rax
}
  802fe8:	c9                   	leaveq 
  802fe9:	c3                   	retq   

0000000000802fea <remove>:

// Delete a file
int
remove(const char *path)
{
  802fea:	55                   	push   %rbp
  802feb:	48 89 e5             	mov    %rsp,%rbp
  802fee:	48 83 ec 10          	sub    $0x10,%rsp
  802ff2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802ff6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ffa:	48 89 c7             	mov    %rax,%rdi
  802ffd:	48 b8 dd 11 80 00 00 	movabs $0x8011dd,%rax
  803004:	00 00 00 
  803007:	ff d0                	callq  *%rax
  803009:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80300e:	7e 07                	jle    803017 <remove+0x2d>
		return -E_BAD_PATH;
  803010:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803015:	eb 33                	jmp    80304a <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803017:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80301b:	48 89 c6             	mov    %rax,%rsi
  80301e:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  803025:	00 00 00 
  803028:	48 b8 49 12 80 00 00 	movabs $0x801249,%rax
  80302f:	00 00 00 
  803032:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803034:	be 00 00 00 00       	mov    $0x0,%esi
  803039:	bf 07 00 00 00       	mov    $0x7,%edi
  80303e:	48 b8 4f 2c 80 00 00 	movabs $0x802c4f,%rax
  803045:	00 00 00 
  803048:	ff d0                	callq  *%rax
}
  80304a:	c9                   	leaveq 
  80304b:	c3                   	retq   

000000000080304c <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80304c:	55                   	push   %rbp
  80304d:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803050:	be 00 00 00 00       	mov    $0x0,%esi
  803055:	bf 08 00 00 00       	mov    $0x8,%edi
  80305a:	48 b8 4f 2c 80 00 00 	movabs $0x802c4f,%rax
  803061:	00 00 00 
  803064:	ff d0                	callq  *%rax
}
  803066:	5d                   	pop    %rbp
  803067:	c3                   	retq   

0000000000803068 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803068:	55                   	push   %rbp
  803069:	48 89 e5             	mov    %rsp,%rbp
  80306c:	53                   	push   %rbx
  80306d:	48 83 ec 38          	sub    $0x38,%rsp
  803071:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803075:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803079:	48 89 c7             	mov    %rax,%rdi
  80307c:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  803083:	00 00 00 
  803086:	ff d0                	callq  *%rax
  803088:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80308b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80308f:	0f 88 bf 01 00 00    	js     803254 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803095:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803099:	ba 07 04 00 00       	mov    $0x407,%edx
  80309e:	48 89 c6             	mov    %rax,%rsi
  8030a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8030a6:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  8030ad:	00 00 00 
  8030b0:	ff d0                	callq  *%rax
  8030b2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030b9:	0f 88 95 01 00 00    	js     803254 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8030bf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8030c3:	48 89 c7             	mov    %rax,%rdi
  8030c6:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  8030cd:	00 00 00 
  8030d0:	ff d0                	callq  *%rax
  8030d2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030d9:	0f 88 5d 01 00 00    	js     80323c <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030e3:	ba 07 04 00 00       	mov    $0x407,%edx
  8030e8:	48 89 c6             	mov    %rax,%rsi
  8030eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8030f0:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  8030f7:	00 00 00 
  8030fa:	ff d0                	callq  *%rax
  8030fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803103:	0f 88 33 01 00 00    	js     80323c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803109:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80310d:	48 89 c7             	mov    %rax,%rdi
  803110:	48 b8 0b 23 80 00 00 	movabs $0x80230b,%rax
  803117:	00 00 00 
  80311a:	ff d0                	callq  *%rax
  80311c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803120:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803124:	ba 07 04 00 00       	mov    $0x407,%edx
  803129:	48 89 c6             	mov    %rax,%rsi
  80312c:	bf 00 00 00 00       	mov    $0x0,%edi
  803131:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  803138:	00 00 00 
  80313b:	ff d0                	callq  *%rax
  80313d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803140:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803144:	79 05                	jns    80314b <pipe+0xe3>
		goto err2;
  803146:	e9 d9 00 00 00       	jmpq   803224 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80314b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80314f:	48 89 c7             	mov    %rax,%rdi
  803152:	48 b8 0b 23 80 00 00 	movabs $0x80230b,%rax
  803159:	00 00 00 
  80315c:	ff d0                	callq  *%rax
  80315e:	48 89 c2             	mov    %rax,%rdx
  803161:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803165:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80316b:	48 89 d1             	mov    %rdx,%rcx
  80316e:	ba 00 00 00 00       	mov    $0x0,%edx
  803173:	48 89 c6             	mov    %rax,%rsi
  803176:	bf 00 00 00 00       	mov    $0x0,%edi
  80317b:	48 b8 c8 1b 80 00 00 	movabs $0x801bc8,%rax
  803182:	00 00 00 
  803185:	ff d0                	callq  *%rax
  803187:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80318a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80318e:	79 1b                	jns    8031ab <pipe+0x143>
		goto err3;
  803190:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803191:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803195:	48 89 c6             	mov    %rax,%rsi
  803198:	bf 00 00 00 00       	mov    $0x0,%edi
  80319d:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  8031a4:	00 00 00 
  8031a7:	ff d0                	callq  *%rax
  8031a9:	eb 79                	jmp    803224 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8031ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031af:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8031b6:	00 00 00 
  8031b9:	8b 12                	mov    (%rdx),%edx
  8031bb:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8031bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031c1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8031c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031cc:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8031d3:	00 00 00 
  8031d6:	8b 12                	mov    (%rdx),%edx
  8031d8:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8031da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031de:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8031e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031e9:	48 89 c7             	mov    %rax,%rdi
  8031ec:	48 b8 e8 22 80 00 00 	movabs $0x8022e8,%rax
  8031f3:	00 00 00 
  8031f6:	ff d0                	callq  *%rax
  8031f8:	89 c2                	mov    %eax,%edx
  8031fa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8031fe:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803200:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803204:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803208:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80320c:	48 89 c7             	mov    %rax,%rdi
  80320f:	48 b8 e8 22 80 00 00 	movabs $0x8022e8,%rax
  803216:	00 00 00 
  803219:	ff d0                	callq  *%rax
  80321b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80321d:	b8 00 00 00 00       	mov    $0x0,%eax
  803222:	eb 33                	jmp    803257 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803224:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803228:	48 89 c6             	mov    %rax,%rsi
  80322b:	bf 00 00 00 00       	mov    $0x0,%edi
  803230:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  803237:	00 00 00 
  80323a:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  80323c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803240:	48 89 c6             	mov    %rax,%rsi
  803243:	bf 00 00 00 00       	mov    $0x0,%edi
  803248:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  80324f:	00 00 00 
  803252:	ff d0                	callq  *%rax
    err:
	return r;
  803254:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803257:	48 83 c4 38          	add    $0x38,%rsp
  80325b:	5b                   	pop    %rbx
  80325c:	5d                   	pop    %rbp
  80325d:	c3                   	retq   

000000000080325e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80325e:	55                   	push   %rbp
  80325f:	48 89 e5             	mov    %rsp,%rbp
  803262:	53                   	push   %rbx
  803263:	48 83 ec 28          	sub    $0x28,%rsp
  803267:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80326b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80326f:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  803276:	00 00 00 
  803279:	48 8b 00             	mov    (%rax),%rax
  80327c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803282:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803285:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803289:	48 89 c7             	mov    %rax,%rdi
  80328c:	48 b8 bc 3b 80 00 00 	movabs $0x803bbc,%rax
  803293:	00 00 00 
  803296:	ff d0                	callq  *%rax
  803298:	89 c3                	mov    %eax,%ebx
  80329a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80329e:	48 89 c7             	mov    %rax,%rdi
  8032a1:	48 b8 bc 3b 80 00 00 	movabs $0x803bbc,%rax
  8032a8:	00 00 00 
  8032ab:	ff d0                	callq  *%rax
  8032ad:	39 c3                	cmp    %eax,%ebx
  8032af:	0f 94 c0             	sete   %al
  8032b2:	0f b6 c0             	movzbl %al,%eax
  8032b5:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8032b8:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8032bf:	00 00 00 
  8032c2:	48 8b 00             	mov    (%rax),%rax
  8032c5:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8032cb:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8032ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032d1:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8032d4:	75 05                	jne    8032db <_pipeisclosed+0x7d>
			return ret;
  8032d6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032d9:	eb 4f                	jmp    80332a <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8032db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032de:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8032e1:	74 42                	je     803325 <_pipeisclosed+0xc7>
  8032e3:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8032e7:	75 3c                	jne    803325 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8032e9:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8032f0:	00 00 00 
  8032f3:	48 8b 00             	mov    (%rax),%rax
  8032f6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8032fc:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8032ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803302:	89 c6                	mov    %eax,%esi
  803304:	48 bf 8b 42 80 00 00 	movabs $0x80428b,%rdi
  80330b:	00 00 00 
  80330e:	b8 00 00 00 00       	mov    $0x0,%eax
  803313:	49 b8 a1 04 80 00 00 	movabs $0x8004a1,%r8
  80331a:	00 00 00 
  80331d:	41 ff d0             	callq  *%r8
	}
  803320:	e9 4a ff ff ff       	jmpq   80326f <_pipeisclosed+0x11>
  803325:	e9 45 ff ff ff       	jmpq   80326f <_pipeisclosed+0x11>
}
  80332a:	48 83 c4 28          	add    $0x28,%rsp
  80332e:	5b                   	pop    %rbx
  80332f:	5d                   	pop    %rbp
  803330:	c3                   	retq   

0000000000803331 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803331:	55                   	push   %rbp
  803332:	48 89 e5             	mov    %rsp,%rbp
  803335:	48 83 ec 30          	sub    $0x30,%rsp
  803339:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80333c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803340:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803343:	48 89 d6             	mov    %rdx,%rsi
  803346:	89 c7                	mov    %eax,%edi
  803348:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  80334f:	00 00 00 
  803352:	ff d0                	callq  *%rax
  803354:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803357:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80335b:	79 05                	jns    803362 <pipeisclosed+0x31>
		return r;
  80335d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803360:	eb 31                	jmp    803393 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803366:	48 89 c7             	mov    %rax,%rdi
  803369:	48 b8 0b 23 80 00 00 	movabs $0x80230b,%rax
  803370:	00 00 00 
  803373:	ff d0                	callq  *%rax
  803375:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803379:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80337d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803381:	48 89 d6             	mov    %rdx,%rsi
  803384:	48 89 c7             	mov    %rax,%rdi
  803387:	48 b8 5e 32 80 00 00 	movabs $0x80325e,%rax
  80338e:	00 00 00 
  803391:	ff d0                	callq  *%rax
}
  803393:	c9                   	leaveq 
  803394:	c3                   	retq   

0000000000803395 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803395:	55                   	push   %rbp
  803396:	48 89 e5             	mov    %rsp,%rbp
  803399:	48 83 ec 40          	sub    $0x40,%rsp
  80339d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033a1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8033a5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8033a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033ad:	48 89 c7             	mov    %rax,%rdi
  8033b0:	48 b8 0b 23 80 00 00 	movabs $0x80230b,%rax
  8033b7:	00 00 00 
  8033ba:	ff d0                	callq  *%rax
  8033bc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8033c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033c4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8033c8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8033cf:	00 
  8033d0:	e9 92 00 00 00       	jmpq   803467 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8033d5:	eb 41                	jmp    803418 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8033d7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8033dc:	74 09                	je     8033e7 <devpipe_read+0x52>
				return i;
  8033de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033e2:	e9 92 00 00 00       	jmpq   803479 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8033e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033ef:	48 89 d6             	mov    %rdx,%rsi
  8033f2:	48 89 c7             	mov    %rax,%rdi
  8033f5:	48 b8 5e 32 80 00 00 	movabs $0x80325e,%rax
  8033fc:	00 00 00 
  8033ff:	ff d0                	callq  *%rax
  803401:	85 c0                	test   %eax,%eax
  803403:	74 07                	je     80340c <devpipe_read+0x77>
				return 0;
  803405:	b8 00 00 00 00       	mov    $0x0,%eax
  80340a:	eb 6d                	jmp    803479 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80340c:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  803413:	00 00 00 
  803416:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803418:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80341c:	8b 10                	mov    (%rax),%edx
  80341e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803422:	8b 40 04             	mov    0x4(%rax),%eax
  803425:	39 c2                	cmp    %eax,%edx
  803427:	74 ae                	je     8033d7 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803429:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80342d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803431:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803435:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803439:	8b 00                	mov    (%rax),%eax
  80343b:	99                   	cltd   
  80343c:	c1 ea 1b             	shr    $0x1b,%edx
  80343f:	01 d0                	add    %edx,%eax
  803441:	83 e0 1f             	and    $0x1f,%eax
  803444:	29 d0                	sub    %edx,%eax
  803446:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80344a:	48 98                	cltq   
  80344c:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803451:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803453:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803457:	8b 00                	mov    (%rax),%eax
  803459:	8d 50 01             	lea    0x1(%rax),%edx
  80345c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803460:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803462:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803467:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80346b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80346f:	0f 82 60 ff ff ff    	jb     8033d5 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803475:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803479:	c9                   	leaveq 
  80347a:	c3                   	retq   

000000000080347b <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80347b:	55                   	push   %rbp
  80347c:	48 89 e5             	mov    %rsp,%rbp
  80347f:	48 83 ec 40          	sub    $0x40,%rsp
  803483:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803487:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80348b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80348f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803493:	48 89 c7             	mov    %rax,%rdi
  803496:	48 b8 0b 23 80 00 00 	movabs $0x80230b,%rax
  80349d:	00 00 00 
  8034a0:	ff d0                	callq  *%rax
  8034a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8034a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034aa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8034ae:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8034b5:	00 
  8034b6:	e9 8e 00 00 00       	jmpq   803549 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8034bb:	eb 31                	jmp    8034ee <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8034bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034c5:	48 89 d6             	mov    %rdx,%rsi
  8034c8:	48 89 c7             	mov    %rax,%rdi
  8034cb:	48 b8 5e 32 80 00 00 	movabs $0x80325e,%rax
  8034d2:	00 00 00 
  8034d5:	ff d0                	callq  *%rax
  8034d7:	85 c0                	test   %eax,%eax
  8034d9:	74 07                	je     8034e2 <devpipe_write+0x67>
				return 0;
  8034db:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e0:	eb 79                	jmp    80355b <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8034e2:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  8034e9:	00 00 00 
  8034ec:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8034ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f2:	8b 40 04             	mov    0x4(%rax),%eax
  8034f5:	48 63 d0             	movslq %eax,%rdx
  8034f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034fc:	8b 00                	mov    (%rax),%eax
  8034fe:	48 98                	cltq   
  803500:	48 83 c0 20          	add    $0x20,%rax
  803504:	48 39 c2             	cmp    %rax,%rdx
  803507:	73 b4                	jae    8034bd <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803509:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80350d:	8b 40 04             	mov    0x4(%rax),%eax
  803510:	99                   	cltd   
  803511:	c1 ea 1b             	shr    $0x1b,%edx
  803514:	01 d0                	add    %edx,%eax
  803516:	83 e0 1f             	and    $0x1f,%eax
  803519:	29 d0                	sub    %edx,%eax
  80351b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80351f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803523:	48 01 ca             	add    %rcx,%rdx
  803526:	0f b6 0a             	movzbl (%rdx),%ecx
  803529:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80352d:	48 98                	cltq   
  80352f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803533:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803537:	8b 40 04             	mov    0x4(%rax),%eax
  80353a:	8d 50 01             	lea    0x1(%rax),%edx
  80353d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803541:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803544:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803549:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80354d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803551:	0f 82 64 ff ff ff    	jb     8034bb <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803557:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80355b:	c9                   	leaveq 
  80355c:	c3                   	retq   

000000000080355d <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80355d:	55                   	push   %rbp
  80355e:	48 89 e5             	mov    %rsp,%rbp
  803561:	48 83 ec 20          	sub    $0x20,%rsp
  803565:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803569:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80356d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803571:	48 89 c7             	mov    %rax,%rdi
  803574:	48 b8 0b 23 80 00 00 	movabs $0x80230b,%rax
  80357b:	00 00 00 
  80357e:	ff d0                	callq  *%rax
  803580:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803584:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803588:	48 be 9e 42 80 00 00 	movabs $0x80429e,%rsi
  80358f:	00 00 00 
  803592:	48 89 c7             	mov    %rax,%rdi
  803595:	48 b8 49 12 80 00 00 	movabs $0x801249,%rax
  80359c:	00 00 00 
  80359f:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8035a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035a5:	8b 50 04             	mov    0x4(%rax),%edx
  8035a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ac:	8b 00                	mov    (%rax),%eax
  8035ae:	29 c2                	sub    %eax,%edx
  8035b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035b4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8035ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035be:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8035c5:	00 00 00 
	stat->st_dev = &devpipe;
  8035c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035cc:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8035d3:	00 00 00 
  8035d6:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8035dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035e2:	c9                   	leaveq 
  8035e3:	c3                   	retq   

00000000008035e4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8035e4:	55                   	push   %rbp
  8035e5:	48 89 e5             	mov    %rsp,%rbp
  8035e8:	48 83 ec 10          	sub    $0x10,%rsp
  8035ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8035f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035f4:	48 89 c6             	mov    %rax,%rsi
  8035f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8035fc:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  803603:	00 00 00 
  803606:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803608:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80360c:	48 89 c7             	mov    %rax,%rdi
  80360f:	48 b8 0b 23 80 00 00 	movabs $0x80230b,%rax
  803616:	00 00 00 
  803619:	ff d0                	callq  *%rax
  80361b:	48 89 c6             	mov    %rax,%rsi
  80361e:	bf 00 00 00 00       	mov    $0x0,%edi
  803623:	48 b8 23 1c 80 00 00 	movabs $0x801c23,%rax
  80362a:	00 00 00 
  80362d:	ff d0                	callq  *%rax
}
  80362f:	c9                   	leaveq 
  803630:	c3                   	retq   

0000000000803631 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803631:	55                   	push   %rbp
  803632:	48 89 e5             	mov    %rsp,%rbp
  803635:	48 83 ec 20          	sub    $0x20,%rsp
  803639:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80363c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80363f:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803642:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803646:	be 01 00 00 00       	mov    $0x1,%esi
  80364b:	48 89 c7             	mov    %rax,%rdi
  80364e:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  803655:	00 00 00 
  803658:	ff d0                	callq  *%rax
}
  80365a:	c9                   	leaveq 
  80365b:	c3                   	retq   

000000000080365c <getchar>:

int
getchar(void)
{
  80365c:	55                   	push   %rbp
  80365d:	48 89 e5             	mov    %rsp,%rbp
  803660:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803664:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803668:	ba 01 00 00 00       	mov    $0x1,%edx
  80366d:	48 89 c6             	mov    %rax,%rsi
  803670:	bf 00 00 00 00       	mov    $0x0,%edi
  803675:	48 b8 00 28 80 00 00 	movabs $0x802800,%rax
  80367c:	00 00 00 
  80367f:	ff d0                	callq  *%rax
  803681:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803684:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803688:	79 05                	jns    80368f <getchar+0x33>
		return r;
  80368a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80368d:	eb 14                	jmp    8036a3 <getchar+0x47>
	if (r < 1)
  80368f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803693:	7f 07                	jg     80369c <getchar+0x40>
		return -E_EOF;
  803695:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80369a:	eb 07                	jmp    8036a3 <getchar+0x47>
	return c;
  80369c:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8036a0:	0f b6 c0             	movzbl %al,%eax
}
  8036a3:	c9                   	leaveq 
  8036a4:	c3                   	retq   

00000000008036a5 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8036a5:	55                   	push   %rbp
  8036a6:	48 89 e5             	mov    %rsp,%rbp
  8036a9:	48 83 ec 20          	sub    $0x20,%rsp
  8036ad:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036b0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8036b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036b7:	48 89 d6             	mov    %rdx,%rsi
  8036ba:	89 c7                	mov    %eax,%edi
  8036bc:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  8036c3:	00 00 00 
  8036c6:	ff d0                	callq  *%rax
  8036c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036cf:	79 05                	jns    8036d6 <iscons+0x31>
		return r;
  8036d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d4:	eb 1a                	jmp    8036f0 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8036d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036da:	8b 10                	mov    (%rax),%edx
  8036dc:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8036e3:	00 00 00 
  8036e6:	8b 00                	mov    (%rax),%eax
  8036e8:	39 c2                	cmp    %eax,%edx
  8036ea:	0f 94 c0             	sete   %al
  8036ed:	0f b6 c0             	movzbl %al,%eax
}
  8036f0:	c9                   	leaveq 
  8036f1:	c3                   	retq   

00000000008036f2 <opencons>:

int
opencons(void)
{
  8036f2:	55                   	push   %rbp
  8036f3:	48 89 e5             	mov    %rsp,%rbp
  8036f6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8036fa:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8036fe:	48 89 c7             	mov    %rax,%rdi
  803701:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  803708:	00 00 00 
  80370b:	ff d0                	callq  *%rax
  80370d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803710:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803714:	79 05                	jns    80371b <opencons+0x29>
		return r;
  803716:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803719:	eb 5b                	jmp    803776 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80371b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80371f:	ba 07 04 00 00       	mov    $0x407,%edx
  803724:	48 89 c6             	mov    %rax,%rsi
  803727:	bf 00 00 00 00       	mov    $0x0,%edi
  80372c:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  803733:	00 00 00 
  803736:	ff d0                	callq  *%rax
  803738:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80373b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80373f:	79 05                	jns    803746 <opencons+0x54>
		return r;
  803741:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803744:	eb 30                	jmp    803776 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803746:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80374a:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803751:	00 00 00 
  803754:	8b 12                	mov    (%rdx),%edx
  803756:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803758:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80375c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803763:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803767:	48 89 c7             	mov    %rax,%rdi
  80376a:	48 b8 e8 22 80 00 00 	movabs $0x8022e8,%rax
  803771:	00 00 00 
  803774:	ff d0                	callq  *%rax
}
  803776:	c9                   	leaveq 
  803777:	c3                   	retq   

0000000000803778 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803778:	55                   	push   %rbp
  803779:	48 89 e5             	mov    %rsp,%rbp
  80377c:	48 83 ec 30          	sub    $0x30,%rsp
  803780:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803784:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803788:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80378c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803791:	75 07                	jne    80379a <devcons_read+0x22>
		return 0;
  803793:	b8 00 00 00 00       	mov    $0x0,%eax
  803798:	eb 4b                	jmp    8037e5 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80379a:	eb 0c                	jmp    8037a8 <devcons_read+0x30>
		sys_yield();
  80379c:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  8037a3:	00 00 00 
  8037a6:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8037a8:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  8037af:	00 00 00 
  8037b2:	ff d0                	callq  *%rax
  8037b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037bb:	74 df                	je     80379c <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8037bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c1:	79 05                	jns    8037c8 <devcons_read+0x50>
		return c;
  8037c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c6:	eb 1d                	jmp    8037e5 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8037c8:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8037cc:	75 07                	jne    8037d5 <devcons_read+0x5d>
		return 0;
  8037ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8037d3:	eb 10                	jmp    8037e5 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8037d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d8:	89 c2                	mov    %eax,%edx
  8037da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037de:	88 10                	mov    %dl,(%rax)
	return 1;
  8037e0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8037e5:	c9                   	leaveq 
  8037e6:	c3                   	retq   

00000000008037e7 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8037e7:	55                   	push   %rbp
  8037e8:	48 89 e5             	mov    %rsp,%rbp
  8037eb:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8037f2:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8037f9:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803800:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803807:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80380e:	eb 76                	jmp    803886 <devcons_write+0x9f>
		m = n - tot;
  803810:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803817:	89 c2                	mov    %eax,%edx
  803819:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80381c:	29 c2                	sub    %eax,%edx
  80381e:	89 d0                	mov    %edx,%eax
  803820:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803823:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803826:	83 f8 7f             	cmp    $0x7f,%eax
  803829:	76 07                	jbe    803832 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80382b:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803832:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803835:	48 63 d0             	movslq %eax,%rdx
  803838:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80383b:	48 63 c8             	movslq %eax,%rcx
  80383e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803845:	48 01 c1             	add    %rax,%rcx
  803848:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80384f:	48 89 ce             	mov    %rcx,%rsi
  803852:	48 89 c7             	mov    %rax,%rdi
  803855:	48 b8 6d 15 80 00 00 	movabs $0x80156d,%rax
  80385c:	00 00 00 
  80385f:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803861:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803864:	48 63 d0             	movslq %eax,%rdx
  803867:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80386e:	48 89 d6             	mov    %rdx,%rsi
  803871:	48 89 c7             	mov    %rax,%rdi
  803874:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  80387b:	00 00 00 
  80387e:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803880:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803883:	01 45 fc             	add    %eax,-0x4(%rbp)
  803886:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803889:	48 98                	cltq   
  80388b:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803892:	0f 82 78 ff ff ff    	jb     803810 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803898:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80389b:	c9                   	leaveq 
  80389c:	c3                   	retq   

000000000080389d <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80389d:	55                   	push   %rbp
  80389e:	48 89 e5             	mov    %rsp,%rbp
  8038a1:	48 83 ec 08          	sub    $0x8,%rsp
  8038a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8038a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038ae:	c9                   	leaveq 
  8038af:	c3                   	retq   

00000000008038b0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8038b0:	55                   	push   %rbp
  8038b1:	48 89 e5             	mov    %rsp,%rbp
  8038b4:	48 83 ec 10          	sub    $0x10,%rsp
  8038b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8038c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c4:	48 be aa 42 80 00 00 	movabs $0x8042aa,%rsi
  8038cb:	00 00 00 
  8038ce:	48 89 c7             	mov    %rax,%rdi
  8038d1:	48 b8 49 12 80 00 00 	movabs $0x801249,%rax
  8038d8:	00 00 00 
  8038db:	ff d0                	callq  *%rax
	return 0;
  8038dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038e2:	c9                   	leaveq 
  8038e3:	c3                   	retq   

00000000008038e4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8038e4:	55                   	push   %rbp
  8038e5:	48 89 e5             	mov    %rsp,%rbp
  8038e8:	48 83 ec 10          	sub    $0x10,%rsp
  8038ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8038f0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8038f7:	00 00 00 
  8038fa:	48 8b 00             	mov    (%rax),%rax
  8038fd:	48 85 c0             	test   %rax,%rax
  803900:	75 3a                	jne    80393c <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  803902:	ba 07 00 00 00       	mov    $0x7,%edx
  803907:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80390c:	bf 00 00 00 00       	mov    $0x0,%edi
  803911:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  803918:	00 00 00 
  80391b:	ff d0                	callq  *%rax
  80391d:	85 c0                	test   %eax,%eax
  80391f:	75 1b                	jne    80393c <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803921:	48 be 4f 39 80 00 00 	movabs $0x80394f,%rsi
  803928:	00 00 00 
  80392b:	bf 00 00 00 00       	mov    $0x0,%edi
  803930:	48 b8 02 1d 80 00 00 	movabs $0x801d02,%rax
  803937:	00 00 00 
  80393a:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80393c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803943:	00 00 00 
  803946:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80394a:	48 89 10             	mov    %rdx,(%rax)
}
  80394d:	c9                   	leaveq 
  80394e:	c3                   	retq   

000000000080394f <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  80394f:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803952:	48 a1 08 80 80 00 00 	movabs 0x808008,%rax
  803959:	00 00 00 
	call *%rax
  80395c:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  80395e:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  803961:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803968:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  803969:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  803970:	00 
	pushq %rbx		// push utf_rip into new stack
  803971:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  803972:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  803979:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  80397c:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  803980:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  803984:	4c 8b 3c 24          	mov    (%rsp),%r15
  803988:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80398d:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803992:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803997:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80399c:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8039a1:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8039a6:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8039ab:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8039b0:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8039b5:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8039ba:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8039bf:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8039c4:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8039c9:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8039ce:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  8039d2:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  8039d6:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  8039d7:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8039d8:	c3                   	retq   

00000000008039d9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8039d9:	55                   	push   %rbp
  8039da:	48 89 e5             	mov    %rsp,%rbp
  8039dd:	48 83 ec 30          	sub    $0x30,%rsp
  8039e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8039ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8039f5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8039fa:	75 0e                	jne    803a0a <ipc_recv+0x31>
		page = (void *)KERNBASE;
  8039fc:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803a03:	00 00 00 
  803a06:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  803a0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a0e:	48 89 c7             	mov    %rax,%rdi
  803a11:	48 b8 a1 1d 80 00 00 	movabs $0x801da1,%rax
  803a18:	00 00 00 
  803a1b:	ff d0                	callq  *%rax
  803a1d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803a20:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803a24:	79 27                	jns    803a4d <ipc_recv+0x74>
		if (from_env_store != NULL)
  803a26:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803a2b:	74 0a                	je     803a37 <ipc_recv+0x5e>
			*from_env_store = 0;
  803a2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a31:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  803a37:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a3c:	74 0a                	je     803a48 <ipc_recv+0x6f>
			*perm_store = 0;
  803a3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a42:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803a48:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a4b:	eb 53                	jmp    803aa0 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  803a4d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803a52:	74 19                	je     803a6d <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  803a54:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  803a5b:	00 00 00 
  803a5e:	48 8b 00             	mov    (%rax),%rax
  803a61:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803a67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a6b:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  803a6d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a72:	74 19                	je     803a8d <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803a74:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  803a7b:	00 00 00 
  803a7e:	48 8b 00             	mov    (%rax),%rax
  803a81:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803a87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a8b:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  803a8d:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  803a94:	00 00 00 
  803a97:	48 8b 00             	mov    (%rax),%rax
  803a9a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803aa0:	c9                   	leaveq 
  803aa1:	c3                   	retq   

0000000000803aa2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803aa2:	55                   	push   %rbp
  803aa3:	48 89 e5             	mov    %rsp,%rbp
  803aa6:	48 83 ec 30          	sub    $0x30,%rsp
  803aaa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803aad:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ab0:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803ab4:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803ab7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803abb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803abf:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803ac4:	75 10                	jne    803ad6 <ipc_send+0x34>
		page = (void *)KERNBASE;
  803ac6:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803acd:	00 00 00 
  803ad0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803ad4:	eb 0e                	jmp    803ae4 <ipc_send+0x42>
  803ad6:	eb 0c                	jmp    803ae4 <ipc_send+0x42>
		sys_yield();
  803ad8:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  803adf:	00 00 00 
  803ae2:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803ae4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803ae7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803aea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803aee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803af1:	89 c7                	mov    %eax,%edi
  803af3:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  803afa:	00 00 00 
  803afd:	ff d0                	callq  *%rax
  803aff:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803b02:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  803b06:	74 d0                	je     803ad8 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  803b08:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803b0c:	74 2a                	je     803b38 <ipc_send+0x96>
		panic("error on ipc send procedure");
  803b0e:	48 ba b1 42 80 00 00 	movabs $0x8042b1,%rdx
  803b15:	00 00 00 
  803b18:	be 49 00 00 00       	mov    $0x49,%esi
  803b1d:	48 bf cd 42 80 00 00 	movabs $0x8042cd,%rdi
  803b24:	00 00 00 
  803b27:	b8 00 00 00 00       	mov    $0x0,%eax
  803b2c:	48 b9 68 02 80 00 00 	movabs $0x800268,%rcx
  803b33:	00 00 00 
  803b36:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  803b38:	c9                   	leaveq 
  803b39:	c3                   	retq   

0000000000803b3a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803b3a:	55                   	push   %rbp
  803b3b:	48 89 e5             	mov    %rsp,%rbp
  803b3e:	48 83 ec 14          	sub    $0x14,%rsp
  803b42:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803b45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b4c:	eb 5e                	jmp    803bac <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803b4e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b55:	00 00 00 
  803b58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b5b:	48 63 d0             	movslq %eax,%rdx
  803b5e:	48 89 d0             	mov    %rdx,%rax
  803b61:	48 c1 e0 03          	shl    $0x3,%rax
  803b65:	48 01 d0             	add    %rdx,%rax
  803b68:	48 c1 e0 05          	shl    $0x5,%rax
  803b6c:	48 01 c8             	add    %rcx,%rax
  803b6f:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803b75:	8b 00                	mov    (%rax),%eax
  803b77:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b7a:	75 2c                	jne    803ba8 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803b7c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b83:	00 00 00 
  803b86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b89:	48 63 d0             	movslq %eax,%rdx
  803b8c:	48 89 d0             	mov    %rdx,%rax
  803b8f:	48 c1 e0 03          	shl    $0x3,%rax
  803b93:	48 01 d0             	add    %rdx,%rax
  803b96:	48 c1 e0 05          	shl    $0x5,%rax
  803b9a:	48 01 c8             	add    %rcx,%rax
  803b9d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803ba3:	8b 40 08             	mov    0x8(%rax),%eax
  803ba6:	eb 12                	jmp    803bba <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803ba8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803bac:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803bb3:	7e 99                	jle    803b4e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803bb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bba:	c9                   	leaveq 
  803bbb:	c3                   	retq   

0000000000803bbc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803bbc:	55                   	push   %rbp
  803bbd:	48 89 e5             	mov    %rsp,%rbp
  803bc0:	48 83 ec 18          	sub    $0x18,%rsp
  803bc4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803bc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bcc:	48 c1 e8 15          	shr    $0x15,%rax
  803bd0:	48 89 c2             	mov    %rax,%rdx
  803bd3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803bda:	01 00 00 
  803bdd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803be1:	83 e0 01             	and    $0x1,%eax
  803be4:	48 85 c0             	test   %rax,%rax
  803be7:	75 07                	jne    803bf0 <pageref+0x34>
		return 0;
  803be9:	b8 00 00 00 00       	mov    $0x0,%eax
  803bee:	eb 53                	jmp    803c43 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803bf0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bf4:	48 c1 e8 0c          	shr    $0xc,%rax
  803bf8:	48 89 c2             	mov    %rax,%rdx
  803bfb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c02:	01 00 00 
  803c05:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c09:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c11:	83 e0 01             	and    $0x1,%eax
  803c14:	48 85 c0             	test   %rax,%rax
  803c17:	75 07                	jne    803c20 <pageref+0x64>
		return 0;
  803c19:	b8 00 00 00 00       	mov    $0x0,%eax
  803c1e:	eb 23                	jmp    803c43 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c24:	48 c1 e8 0c          	shr    $0xc,%rax
  803c28:	48 89 c2             	mov    %rax,%rdx
  803c2b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c32:	00 00 00 
  803c35:	48 c1 e2 04          	shl    $0x4,%rdx
  803c39:	48 01 d0             	add    %rdx,%rax
  803c3c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c40:	0f b7 c0             	movzwl %ax,%eax
}
  803c43:	c9                   	leaveq 
  803c44:	c3                   	retq   
