
obj/user/testpiperace.debug:     file format elf64-x86-64


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
  80003c:	e8 4c 03 00 00       	callq  80038d <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 50          	sub    $0x50,%rsp
  80004b:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80004e:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800052:	48 bf 20 3e 80 00 00 	movabs $0x803e20,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 ac 34 80 00 00 	movabs $0x8034ac,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba 39 3e 80 00 00 	movabs $0x803e39,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf 42 3e 80 00 00 	movabs $0x803e42,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 40 04 80 00 00 	movabs $0x800440,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	max = 200;
  8000b9:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%rbp)
	if ((r = fork()) < 0)
  8000c0:	48 b8 26 22 80 00 00 	movabs $0x802226,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	callq  *%rax
  8000cc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d3:	79 30                	jns    800105 <umain+0xc2>
		panic("fork: %e", r);
  8000d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d8:	89 c1                	mov    %eax,%ecx
  8000da:	48 ba 56 3e 80 00 00 	movabs $0x803e56,%rdx
  8000e1:	00 00 00 
  8000e4:	be 10 00 00 00       	mov    $0x10,%esi
  8000e9:	48 bf 42 3e 80 00 00 	movabs $0x803e42,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	49 b8 40 04 80 00 00 	movabs $0x800440,%r8
  8000ff:	00 00 00 
  800102:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800105:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800109:	0f 85 89 00 00 00    	jne    800198 <umain+0x155>
		close(p[1]);
  80010f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800112:	89 c7                	mov    %eax,%edi
  800114:	48 b8 99 29 80 00 00 	movabs $0x802999,%rax
  80011b:	00 00 00 
  80011e:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i = 0; i < max; i++) {
  800120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800127:	eb 4c                	jmp    800175 <umain+0x132>
			if (pipeisclosed(p[0])){
  800129:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80012c:	89 c7                	mov    %eax,%edi
  80012e:	48 b8 75 37 80 00 00 	movabs $0x803775,%rax
  800135:	00 00 00 
  800138:	ff d0                	callq  *%rax
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 27                	je     800165 <umain+0x122>
				cprintf("RACE: pipe appears closed\n");
  80013e:	48 bf 5f 3e 80 00 00 	movabs $0x803e5f,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 1d 04 80 00 00 	movabs $0x80041d,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			sys_yield();
  800165:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  80016c:	00 00 00 
  80016f:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i = 0; i < max; i++) {
  800171:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800175:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800178:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80017b:	7c ac                	jl     800129 <umain+0xe6>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  80017d:	ba 00 00 00 00       	mov    $0x0,%edx
  800182:	be 00 00 00 00       	mov    $0x0,%esi
  800187:	bf 00 00 00 00       	mov    $0x0,%edi
  80018c:	48 b8 c0 24 80 00 00 	movabs $0x8024c0,%rax
  800193:	00 00 00 
  800196:	ff d0                	callq  *%rax
	}
	pid = r;
  800198:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019b:	89 45 f0             	mov    %eax,-0x10(%rbp)
	cprintf("pid is %d\n", pid);
  80019e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001a1:	89 c6                	mov    %eax,%esi
  8001a3:	48 bf 7a 3e 80 00 00 	movabs $0x803e7a,%rdi
  8001aa:	00 00 00 
  8001ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b2:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  8001b9:	00 00 00 
  8001bc:	ff d2                	callq  *%rdx
	va = 0;
  8001be:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8001c5:	00 
	kid = &envs[ENVX(pid)];
  8001c6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001c9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ce:	48 63 d0             	movslq %eax,%rdx
  8001d1:	48 89 d0             	mov    %rdx,%rax
  8001d4:	48 c1 e0 03          	shl    $0x3,%rax
  8001d8:	48 01 d0             	add    %rdx,%rax
  8001db:	48 c1 e0 05          	shl    $0x5,%rax
  8001df:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001e6:	00 00 00 
  8001e9:	48 01 d0             	add    %rdx,%rax
  8001ec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	cprintf("kid is %d\n", kid-envs);
  8001f0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001f4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001fb:	00 00 00 
  8001fe:	48 29 c2             	sub    %rax,%rdx
  800201:	48 89 d0             	mov    %rdx,%rax
  800204:	48 c1 f8 05          	sar    $0x5,%rax
  800208:	48 89 c2             	mov    %rax,%rdx
  80020b:	48 b8 39 8e e3 38 8e 	movabs $0x8e38e38e38e38e39,%rax
  800212:	e3 38 8e 
  800215:	48 0f af c2          	imul   %rdx,%rax
  800219:	48 89 c6             	mov    %rax,%rsi
  80021c:	48 bf 85 3e 80 00 00 	movabs $0x803e85,%rdi
  800223:	00 00 00 
  800226:	b8 00 00 00 00       	mov    $0x0,%eax
  80022b:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  800232:	00 00 00 
  800235:	ff d2                	callq  *%rdx
	dup(p[0], 10);
  800237:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80023a:	be 0a 00 00 00       	mov    $0xa,%esi
  80023f:	89 c7                	mov    %eax,%edi
  800241:	48 b8 12 2a 80 00 00 	movabs $0x802a12,%rax
  800248:	00 00 00 
  80024b:	ff d0                	callq  *%rax
	while (kid->env_status == ENV_RUNNABLE)
  80024d:	eb 16                	jmp    800265 <umain+0x222>
		dup(p[0], 10);
  80024f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800252:	be 0a 00 00 00       	mov    $0xa,%esi
  800257:	89 c7                	mov    %eax,%edi
  800259:	48 b8 12 2a 80 00 00 	movabs $0x802a12,%rax
  800260:	00 00 00 
  800263:	ff d0                	callq  *%rax
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  800265:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800269:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80026f:	83 f8 02             	cmp    $0x2,%eax
  800272:	74 db                	je     80024f <umain+0x20c>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  800274:	48 bf 90 3e 80 00 00 	movabs $0x803e90,%rdi
  80027b:	00 00 00 
  80027e:	b8 00 00 00 00       	mov    $0x0,%eax
  800283:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  80028a:	00 00 00 
  80028d:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  80028f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800292:	89 c7                	mov    %eax,%edi
  800294:	48 b8 75 37 80 00 00 	movabs $0x803775,%rax
  80029b:	00 00 00 
  80029e:	ff d0                	callq  *%rax
  8002a0:	85 c0                	test   %eax,%eax
  8002a2:	74 2a                	je     8002ce <umain+0x28b>
		panic("somehow the other end of p[0] got closed!");
  8002a4:	48 ba a8 3e 80 00 00 	movabs $0x803ea8,%rdx
  8002ab:	00 00 00 
  8002ae:	be 3a 00 00 00       	mov    $0x3a,%esi
  8002b3:	48 bf 42 3e 80 00 00 	movabs $0x803e42,%rdi
  8002ba:	00 00 00 
  8002bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c2:	48 b9 40 04 80 00 00 	movabs $0x800440,%rcx
  8002c9:	00 00 00 
  8002cc:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002ce:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002d1:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8002d5:	48 89 d6             	mov    %rdx,%rsi
  8002d8:	89 c7                	mov    %eax,%edi
  8002da:	48 b8 89 27 80 00 00 	movabs $0x802789,%rax
  8002e1:	00 00 00 
  8002e4:	ff d0                	callq  *%rax
  8002e6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002e9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002ed:	79 30                	jns    80031f <umain+0x2dc>
		panic("cannot look up p[0]: %e", r);
  8002ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002f2:	89 c1                	mov    %eax,%ecx
  8002f4:	48 ba d2 3e 80 00 00 	movabs $0x803ed2,%rdx
  8002fb:	00 00 00 
  8002fe:	be 3c 00 00 00       	mov    $0x3c,%esi
  800303:	48 bf 42 3e 80 00 00 	movabs $0x803e42,%rdi
  80030a:	00 00 00 
  80030d:	b8 00 00 00 00       	mov    $0x0,%eax
  800312:	49 b8 40 04 80 00 00 	movabs $0x800440,%r8
  800319:	00 00 00 
  80031c:	41 ff d0             	callq  *%r8
	va = fd2data(fd);
  80031f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800323:	48 89 c7             	mov    %rax,%rdi
  800326:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  80032d:	00 00 00 
  800330:	ff d0                	callq  *%rax
  800332:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (pageref(va) != 3+1)
  800336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80033a:	48 89 c7             	mov    %rax,%rdi
  80033d:	48 b8 23 34 80 00 00 	movabs $0x803423,%rax
  800344:	00 00 00 
  800347:	ff d0                	callq  *%rax
  800349:	83 f8 04             	cmp    $0x4,%eax
  80034c:	74 1d                	je     80036b <umain+0x328>
		cprintf("\nchild detected race\n");
  80034e:	48 bf ea 3e 80 00 00 	movabs $0x803eea,%rdi
  800355:	00 00 00 
  800358:	b8 00 00 00 00       	mov    $0x0,%eax
  80035d:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  800364:	00 00 00 
  800367:	ff d2                	callq  *%rdx
  800369:	eb 20                	jmp    80038b <umain+0x348>
	else
		cprintf("\nrace didn't happen\n", max);
  80036b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80036e:	89 c6                	mov    %eax,%esi
  800370:	48 bf 00 3f 80 00 00 	movabs $0x803f00,%rdi
  800377:	00 00 00 
  80037a:	b8 00 00 00 00       	mov    $0x0,%eax
  80037f:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  800386:	00 00 00 
  800389:	ff d2                	callq  *%rdx
}
  80038b:	c9                   	leaveq 
  80038c:	c3                   	retq   

000000000080038d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80038d:	55                   	push   %rbp
  80038e:	48 89 e5             	mov    %rsp,%rbp
  800391:	48 83 ec 10          	sub    $0x10,%rsp
  800395:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800398:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80039c:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  8003a3:	00 00 00 
  8003a6:	ff d0                	callq  *%rax
  8003a8:	48 98                	cltq   
  8003aa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003af:	48 89 c2             	mov    %rax,%rdx
  8003b2:	48 89 d0             	mov    %rdx,%rax
  8003b5:	48 c1 e0 03          	shl    $0x3,%rax
  8003b9:	48 01 d0             	add    %rdx,%rax
  8003bc:	48 c1 e0 05          	shl    $0x5,%rax
  8003c0:	48 89 c2             	mov    %rax,%rdx
  8003c3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8003ca:	00 00 00 
  8003cd:	48 01 c2             	add    %rax,%rdx
  8003d0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8003d7:	00 00 00 
  8003da:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003e1:	7e 14                	jle    8003f7 <libmain+0x6a>
		binaryname = argv[0];
  8003e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e7:	48 8b 10             	mov    (%rax),%rdx
  8003ea:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003f1:	00 00 00 
  8003f4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003fe:	48 89 d6             	mov    %rdx,%rsi
  800401:	89 c7                	mov    %eax,%edi
  800403:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80040a:	00 00 00 
  80040d:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80040f:	48 b8 1d 04 80 00 00 	movabs $0x80041d,%rax
  800416:	00 00 00 
  800419:	ff d0                	callq  *%rax
}
  80041b:	c9                   	leaveq 
  80041c:	c3                   	retq   

000000000080041d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80041d:	55                   	push   %rbp
  80041e:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800421:	48 b8 e4 29 80 00 00 	movabs $0x8029e4,%rax
  800428:	00 00 00 
  80042b:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80042d:	bf 00 00 00 00       	mov    $0x0,%edi
  800432:	48 b8 90 1c 80 00 00 	movabs $0x801c90,%rax
  800439:	00 00 00 
  80043c:	ff d0                	callq  *%rax
}
  80043e:	5d                   	pop    %rbp
  80043f:	c3                   	retq   

0000000000800440 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800440:	55                   	push   %rbp
  800441:	48 89 e5             	mov    %rsp,%rbp
  800444:	53                   	push   %rbx
  800445:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80044c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800453:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800459:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800460:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800467:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80046e:	84 c0                	test   %al,%al
  800470:	74 23                	je     800495 <_panic+0x55>
  800472:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800479:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80047d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800481:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800485:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800489:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80048d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800491:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800495:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80049c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8004a3:	00 00 00 
  8004a6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8004ad:	00 00 00 
  8004b0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004b4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004bb:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004c2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004c9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8004d0:	00 00 00 
  8004d3:	48 8b 18             	mov    (%rax),%rbx
  8004d6:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  8004dd:	00 00 00 
  8004e0:	ff d0                	callq  *%rax
  8004e2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004e8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004ef:	41 89 c8             	mov    %ecx,%r8d
  8004f2:	48 89 d1             	mov    %rdx,%rcx
  8004f5:	48 89 da             	mov    %rbx,%rdx
  8004f8:	89 c6                	mov    %eax,%esi
  8004fa:	48 bf 20 3f 80 00 00 	movabs $0x803f20,%rdi
  800501:	00 00 00 
  800504:	b8 00 00 00 00       	mov    $0x0,%eax
  800509:	49 b9 79 06 80 00 00 	movabs $0x800679,%r9
  800510:	00 00 00 
  800513:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800516:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80051d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800524:	48 89 d6             	mov    %rdx,%rsi
  800527:	48 89 c7             	mov    %rax,%rdi
  80052a:	48 b8 cd 05 80 00 00 	movabs $0x8005cd,%rax
  800531:	00 00 00 
  800534:	ff d0                	callq  *%rax
	cprintf("\n");
  800536:	48 bf 43 3f 80 00 00 	movabs $0x803f43,%rdi
  80053d:	00 00 00 
  800540:	b8 00 00 00 00       	mov    $0x0,%eax
  800545:	48 ba 79 06 80 00 00 	movabs $0x800679,%rdx
  80054c:	00 00 00 
  80054f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800551:	cc                   	int3   
  800552:	eb fd                	jmp    800551 <_panic+0x111>

0000000000800554 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800554:	55                   	push   %rbp
  800555:	48 89 e5             	mov    %rsp,%rbp
  800558:	48 83 ec 10          	sub    $0x10,%rsp
  80055c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80055f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800563:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800567:	8b 00                	mov    (%rax),%eax
  800569:	8d 48 01             	lea    0x1(%rax),%ecx
  80056c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800570:	89 0a                	mov    %ecx,(%rdx)
  800572:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800575:	89 d1                	mov    %edx,%ecx
  800577:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80057b:	48 98                	cltq   
  80057d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800585:	8b 00                	mov    (%rax),%eax
  800587:	3d ff 00 00 00       	cmp    $0xff,%eax
  80058c:	75 2c                	jne    8005ba <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80058e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800592:	8b 00                	mov    (%rax),%eax
  800594:	48 98                	cltq   
  800596:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80059a:	48 83 c2 08          	add    $0x8,%rdx
  80059e:	48 89 c6             	mov    %rax,%rsi
  8005a1:	48 89 d7             	mov    %rdx,%rdi
  8005a4:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  8005ab:	00 00 00 
  8005ae:	ff d0                	callq  *%rax
		b->idx = 0;
  8005b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005b4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8005ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005be:	8b 40 04             	mov    0x4(%rax),%eax
  8005c1:	8d 50 01             	lea    0x1(%rax),%edx
  8005c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005c8:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005cb:	c9                   	leaveq 
  8005cc:	c3                   	retq   

00000000008005cd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005cd:	55                   	push   %rbp
  8005ce:	48 89 e5             	mov    %rsp,%rbp
  8005d1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005d8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005df:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8005e6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005ed:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005f4:	48 8b 0a             	mov    (%rdx),%rcx
  8005f7:	48 89 08             	mov    %rcx,(%rax)
  8005fa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005fe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800602:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800606:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  80060a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800611:	00 00 00 
	b.cnt = 0;
  800614:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80061b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80061e:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800625:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80062c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800633:	48 89 c6             	mov    %rax,%rsi
  800636:	48 bf 54 05 80 00 00 	movabs $0x800554,%rdi
  80063d:	00 00 00 
  800640:	48 b8 2c 0a 80 00 00 	movabs $0x800a2c,%rax
  800647:	00 00 00 
  80064a:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80064c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800652:	48 98                	cltq   
  800654:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80065b:	48 83 c2 08          	add    $0x8,%rdx
  80065f:	48 89 c6             	mov    %rax,%rsi
  800662:	48 89 d7             	mov    %rdx,%rdi
  800665:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  80066c:	00 00 00 
  80066f:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800671:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800677:	c9                   	leaveq 
  800678:	c3                   	retq   

0000000000800679 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800679:	55                   	push   %rbp
  80067a:	48 89 e5             	mov    %rsp,%rbp
  80067d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800684:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80068b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800692:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800699:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8006a0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8006a7:	84 c0                	test   %al,%al
  8006a9:	74 20                	je     8006cb <cprintf+0x52>
  8006ab:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8006af:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8006b3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8006b7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006bb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006bf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006c3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006c7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006cb:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8006d2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006d9:	00 00 00 
  8006dc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006e3:	00 00 00 
  8006e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006ea:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006f1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006f8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8006ff:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800706:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80070d:	48 8b 0a             	mov    (%rdx),%rcx
  800710:	48 89 08             	mov    %rcx,(%rax)
  800713:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800717:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80071b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80071f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800723:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80072a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800731:	48 89 d6             	mov    %rdx,%rsi
  800734:	48 89 c7             	mov    %rax,%rdi
  800737:	48 b8 cd 05 80 00 00 	movabs $0x8005cd,%rax
  80073e:	00 00 00 
  800741:	ff d0                	callq  *%rax
  800743:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800749:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80074f:	c9                   	leaveq 
  800750:	c3                   	retq   

0000000000800751 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800751:	55                   	push   %rbp
  800752:	48 89 e5             	mov    %rsp,%rbp
  800755:	53                   	push   %rbx
  800756:	48 83 ec 38          	sub    $0x38,%rsp
  80075a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80075e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800762:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800766:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800769:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80076d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800771:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800774:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800778:	77 3b                	ja     8007b5 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80077a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80077d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800781:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800788:	ba 00 00 00 00       	mov    $0x0,%edx
  80078d:	48 f7 f3             	div    %rbx
  800790:	48 89 c2             	mov    %rax,%rdx
  800793:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800796:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800799:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80079d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a1:	41 89 f9             	mov    %edi,%r9d
  8007a4:	48 89 c7             	mov    %rax,%rdi
  8007a7:	48 b8 51 07 80 00 00 	movabs $0x800751,%rax
  8007ae:	00 00 00 
  8007b1:	ff d0                	callq  *%rax
  8007b3:	eb 1e                	jmp    8007d3 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b5:	eb 12                	jmp    8007c9 <printnum+0x78>
			putch(padc, putdat);
  8007b7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007bb:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8007be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c2:	48 89 ce             	mov    %rcx,%rsi
  8007c5:	89 d7                	mov    %edx,%edi
  8007c7:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007c9:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8007cd:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007d1:	7f e4                	jg     8007b7 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007d3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007da:	ba 00 00 00 00       	mov    $0x0,%edx
  8007df:	48 f7 f1             	div    %rcx
  8007e2:	48 89 d0             	mov    %rdx,%rax
  8007e5:	48 ba 28 41 80 00 00 	movabs $0x804128,%rdx
  8007ec:	00 00 00 
  8007ef:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007f3:	0f be d0             	movsbl %al,%edx
  8007f6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fe:	48 89 ce             	mov    %rcx,%rsi
  800801:	89 d7                	mov    %edx,%edi
  800803:	ff d0                	callq  *%rax
}
  800805:	48 83 c4 38          	add    $0x38,%rsp
  800809:	5b                   	pop    %rbx
  80080a:	5d                   	pop    %rbp
  80080b:	c3                   	retq   

000000000080080c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80080c:	55                   	push   %rbp
  80080d:	48 89 e5             	mov    %rsp,%rbp
  800810:	48 83 ec 1c          	sub    $0x1c,%rsp
  800814:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800818:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  80081b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80081f:	7e 52                	jle    800873 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800821:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800825:	8b 00                	mov    (%rax),%eax
  800827:	83 f8 30             	cmp    $0x30,%eax
  80082a:	73 24                	jae    800850 <getuint+0x44>
  80082c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800830:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800834:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800838:	8b 00                	mov    (%rax),%eax
  80083a:	89 c0                	mov    %eax,%eax
  80083c:	48 01 d0             	add    %rdx,%rax
  80083f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800843:	8b 12                	mov    (%rdx),%edx
  800845:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800848:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084c:	89 0a                	mov    %ecx,(%rdx)
  80084e:	eb 17                	jmp    800867 <getuint+0x5b>
  800850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800854:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800858:	48 89 d0             	mov    %rdx,%rax
  80085b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80085f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800863:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800867:	48 8b 00             	mov    (%rax),%rax
  80086a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80086e:	e9 a3 00 00 00       	jmpq   800916 <getuint+0x10a>
	else if (lflag)
  800873:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800877:	74 4f                	je     8008c8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800879:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087d:	8b 00                	mov    (%rax),%eax
  80087f:	83 f8 30             	cmp    $0x30,%eax
  800882:	73 24                	jae    8008a8 <getuint+0x9c>
  800884:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800888:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80088c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800890:	8b 00                	mov    (%rax),%eax
  800892:	89 c0                	mov    %eax,%eax
  800894:	48 01 d0             	add    %rdx,%rax
  800897:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089b:	8b 12                	mov    (%rdx),%edx
  80089d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a4:	89 0a                	mov    %ecx,(%rdx)
  8008a6:	eb 17                	jmp    8008bf <getuint+0xb3>
  8008a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ac:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008b0:	48 89 d0             	mov    %rdx,%rax
  8008b3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008bb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008bf:	48 8b 00             	mov    (%rax),%rax
  8008c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008c6:	eb 4e                	jmp    800916 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008cc:	8b 00                	mov    (%rax),%eax
  8008ce:	83 f8 30             	cmp    $0x30,%eax
  8008d1:	73 24                	jae    8008f7 <getuint+0xeb>
  8008d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008df:	8b 00                	mov    (%rax),%eax
  8008e1:	89 c0                	mov    %eax,%eax
  8008e3:	48 01 d0             	add    %rdx,%rax
  8008e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ea:	8b 12                	mov    (%rdx),%edx
  8008ec:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f3:	89 0a                	mov    %ecx,(%rdx)
  8008f5:	eb 17                	jmp    80090e <getuint+0x102>
  8008f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ff:	48 89 d0             	mov    %rdx,%rax
  800902:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800906:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80090e:	8b 00                	mov    (%rax),%eax
  800910:	89 c0                	mov    %eax,%eax
  800912:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800916:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80091a:	c9                   	leaveq 
  80091b:	c3                   	retq   

000000000080091c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80091c:	55                   	push   %rbp
  80091d:	48 89 e5             	mov    %rsp,%rbp
  800920:	48 83 ec 1c          	sub    $0x1c,%rsp
  800924:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800928:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80092b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80092f:	7e 52                	jle    800983 <getint+0x67>
		x=va_arg(*ap, long long);
  800931:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800935:	8b 00                	mov    (%rax),%eax
  800937:	83 f8 30             	cmp    $0x30,%eax
  80093a:	73 24                	jae    800960 <getint+0x44>
  80093c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800940:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800944:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800948:	8b 00                	mov    (%rax),%eax
  80094a:	89 c0                	mov    %eax,%eax
  80094c:	48 01 d0             	add    %rdx,%rax
  80094f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800953:	8b 12                	mov    (%rdx),%edx
  800955:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800958:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095c:	89 0a                	mov    %ecx,(%rdx)
  80095e:	eb 17                	jmp    800977 <getint+0x5b>
  800960:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800964:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800968:	48 89 d0             	mov    %rdx,%rax
  80096b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80096f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800973:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800977:	48 8b 00             	mov    (%rax),%rax
  80097a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80097e:	e9 a3 00 00 00       	jmpq   800a26 <getint+0x10a>
	else if (lflag)
  800983:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800987:	74 4f                	je     8009d8 <getint+0xbc>
		x=va_arg(*ap, long);
  800989:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098d:	8b 00                	mov    (%rax),%eax
  80098f:	83 f8 30             	cmp    $0x30,%eax
  800992:	73 24                	jae    8009b8 <getint+0x9c>
  800994:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800998:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80099c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a0:	8b 00                	mov    (%rax),%eax
  8009a2:	89 c0                	mov    %eax,%eax
  8009a4:	48 01 d0             	add    %rdx,%rax
  8009a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ab:	8b 12                	mov    (%rdx),%edx
  8009ad:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b4:	89 0a                	mov    %ecx,(%rdx)
  8009b6:	eb 17                	jmp    8009cf <getint+0xb3>
  8009b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009c0:	48 89 d0             	mov    %rdx,%rax
  8009c3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009cf:	48 8b 00             	mov    (%rax),%rax
  8009d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009d6:	eb 4e                	jmp    800a26 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009dc:	8b 00                	mov    (%rax),%eax
  8009de:	83 f8 30             	cmp    $0x30,%eax
  8009e1:	73 24                	jae    800a07 <getint+0xeb>
  8009e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ef:	8b 00                	mov    (%rax),%eax
  8009f1:	89 c0                	mov    %eax,%eax
  8009f3:	48 01 d0             	add    %rdx,%rax
  8009f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fa:	8b 12                	mov    (%rdx),%edx
  8009fc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a03:	89 0a                	mov    %ecx,(%rdx)
  800a05:	eb 17                	jmp    800a1e <getint+0x102>
  800a07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a0f:	48 89 d0             	mov    %rdx,%rax
  800a12:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a1e:	8b 00                	mov    (%rax),%eax
  800a20:	48 98                	cltq   
  800a22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a2a:	c9                   	leaveq 
  800a2b:	c3                   	retq   

0000000000800a2c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a2c:	55                   	push   %rbp
  800a2d:	48 89 e5             	mov    %rsp,%rbp
  800a30:	41 54                	push   %r12
  800a32:	53                   	push   %rbx
  800a33:	48 83 ec 60          	sub    $0x60,%rsp
  800a37:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a3b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a3f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a43:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a47:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a4b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a4f:	48 8b 0a             	mov    (%rdx),%rcx
  800a52:	48 89 08             	mov    %rcx,(%rax)
  800a55:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a59:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a5d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a61:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  800a65:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a69:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a6d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a71:	0f b6 00             	movzbl (%rax),%eax
  800a74:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  800a77:	eb 29                	jmp    800aa2 <vprintfmt+0x76>
			if (ch == '\0')
  800a79:	85 db                	test   %ebx,%ebx
  800a7b:	0f 84 ad 06 00 00    	je     80112e <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  800a81:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a85:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a89:	48 89 d6             	mov    %rdx,%rsi
  800a8c:	89 df                	mov    %ebx,%edi
  800a8e:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  800a90:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a94:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a98:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a9c:	0f b6 00             	movzbl (%rax),%eax
  800a9f:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  800aa2:	83 fb 25             	cmp    $0x25,%ebx
  800aa5:	74 05                	je     800aac <vprintfmt+0x80>
  800aa7:	83 fb 1b             	cmp    $0x1b,%ebx
  800aaa:	75 cd                	jne    800a79 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800aac:	83 fb 1b             	cmp    $0x1b,%ebx
  800aaf:	0f 85 ae 01 00 00    	jne    800c63 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  800ab5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800abc:	00 00 00 
  800abf:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  800ac5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ac9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800acd:	48 89 d6             	mov    %rdx,%rsi
  800ad0:	89 df                	mov    %ebx,%edi
  800ad2:	ff d0                	callq  *%rax
			putch('[', putdat);
  800ad4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800adc:	48 89 d6             	mov    %rdx,%rsi
  800adf:	bf 5b 00 00 00       	mov    $0x5b,%edi
  800ae4:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800ae6:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800aec:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800af1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800af5:	0f b6 00             	movzbl (%rax),%eax
  800af8:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800afb:	eb 32                	jmp    800b2f <vprintfmt+0x103>
					putch(ch, putdat);
  800afd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b05:	48 89 d6             	mov    %rdx,%rsi
  800b08:	89 df                	mov    %ebx,%edi
  800b0a:	ff d0                	callq  *%rax
					esc_color *= 10;
  800b0c:	44 89 e0             	mov    %r12d,%eax
  800b0f:	c1 e0 02             	shl    $0x2,%eax
  800b12:	44 01 e0             	add    %r12d,%eax
  800b15:	01 c0                	add    %eax,%eax
  800b17:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800b1a:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800b1d:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800b20:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800b25:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b29:	0f b6 00             	movzbl (%rax),%eax
  800b2c:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800b2f:	83 fb 3b             	cmp    $0x3b,%ebx
  800b32:	74 05                	je     800b39 <vprintfmt+0x10d>
  800b34:	83 fb 6d             	cmp    $0x6d,%ebx
  800b37:	75 c4                	jne    800afd <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800b39:	45 85 e4             	test   %r12d,%r12d
  800b3c:	75 15                	jne    800b53 <vprintfmt+0x127>
					color_flag = 0x07;
  800b3e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b45:	00 00 00 
  800b48:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800b4e:	e9 dc 00 00 00       	jmpq   800c2f <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800b53:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800b57:	7e 69                	jle    800bc2 <vprintfmt+0x196>
  800b59:	41 83 fc 25          	cmp    $0x25,%r12d
  800b5d:	7f 63                	jg     800bc2 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800b5f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b66:	00 00 00 
  800b69:	8b 00                	mov    (%rax),%eax
  800b6b:	25 f8 00 00 00       	and    $0xf8,%eax
  800b70:	89 c2                	mov    %eax,%edx
  800b72:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b79:	00 00 00 
  800b7c:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800b7e:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800b82:	44 89 e0             	mov    %r12d,%eax
  800b85:	83 e0 04             	and    $0x4,%eax
  800b88:	c1 f8 02             	sar    $0x2,%eax
  800b8b:	89 c2                	mov    %eax,%edx
  800b8d:	44 89 e0             	mov    %r12d,%eax
  800b90:	83 e0 02             	and    $0x2,%eax
  800b93:	09 c2                	or     %eax,%edx
  800b95:	44 89 e0             	mov    %r12d,%eax
  800b98:	83 e0 01             	and    $0x1,%eax
  800b9b:	c1 e0 02             	shl    $0x2,%eax
  800b9e:	09 c2                	or     %eax,%edx
  800ba0:	41 89 d4             	mov    %edx,%r12d
  800ba3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800baa:	00 00 00 
  800bad:	8b 00                	mov    (%rax),%eax
  800baf:	44 89 e2             	mov    %r12d,%edx
  800bb2:	09 c2                	or     %eax,%edx
  800bb4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800bbb:	00 00 00 
  800bbe:	89 10                	mov    %edx,(%rax)
  800bc0:	eb 6d                	jmp    800c2f <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800bc2:	41 83 fc 27          	cmp    $0x27,%r12d
  800bc6:	7e 67                	jle    800c2f <vprintfmt+0x203>
  800bc8:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800bcc:	7f 61                	jg     800c2f <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800bce:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800bd5:	00 00 00 
  800bd8:	8b 00                	mov    (%rax),%eax
  800bda:	25 8f 00 00 00       	and    $0x8f,%eax
  800bdf:	89 c2                	mov    %eax,%edx
  800be1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800be8:	00 00 00 
  800beb:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800bed:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800bf1:	44 89 e0             	mov    %r12d,%eax
  800bf4:	83 e0 04             	and    $0x4,%eax
  800bf7:	c1 f8 02             	sar    $0x2,%eax
  800bfa:	89 c2                	mov    %eax,%edx
  800bfc:	44 89 e0             	mov    %r12d,%eax
  800bff:	83 e0 02             	and    $0x2,%eax
  800c02:	09 c2                	or     %eax,%edx
  800c04:	44 89 e0             	mov    %r12d,%eax
  800c07:	83 e0 01             	and    $0x1,%eax
  800c0a:	c1 e0 06             	shl    $0x6,%eax
  800c0d:	09 c2                	or     %eax,%edx
  800c0f:	41 89 d4             	mov    %edx,%r12d
  800c12:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c19:	00 00 00 
  800c1c:	8b 00                	mov    (%rax),%eax
  800c1e:	44 89 e2             	mov    %r12d,%edx
  800c21:	09 c2                	or     %eax,%edx
  800c23:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c2a:	00 00 00 
  800c2d:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800c2f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c33:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c37:	48 89 d6             	mov    %rdx,%rsi
  800c3a:	89 df                	mov    %ebx,%edi
  800c3c:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800c3e:	83 fb 6d             	cmp    $0x6d,%ebx
  800c41:	75 1b                	jne    800c5e <vprintfmt+0x232>
					fmt ++;
  800c43:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800c48:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800c49:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800c50:	00 00 00 
  800c53:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800c59:	e9 cb 04 00 00       	jmpq   801129 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800c5e:	e9 83 fe ff ff       	jmpq   800ae6 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800c63:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c67:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c6e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c75:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c7c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c83:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c87:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c8b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c8f:	0f b6 00             	movzbl (%rax),%eax
  800c92:	0f b6 d8             	movzbl %al,%ebx
  800c95:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c98:	83 f8 55             	cmp    $0x55,%eax
  800c9b:	0f 87 5a 04 00 00    	ja     8010fb <vprintfmt+0x6cf>
  800ca1:	89 c0                	mov    %eax,%eax
  800ca3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800caa:	00 
  800cab:	48 b8 50 41 80 00 00 	movabs $0x804150,%rax
  800cb2:	00 00 00 
  800cb5:	48 01 d0             	add    %rdx,%rax
  800cb8:	48 8b 00             	mov    (%rax),%rax
  800cbb:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cbd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800cc1:	eb c0                	jmp    800c83 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cc3:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800cc7:	eb ba                	jmp    800c83 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cc9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800cd0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800cd3:	89 d0                	mov    %edx,%eax
  800cd5:	c1 e0 02             	shl    $0x2,%eax
  800cd8:	01 d0                	add    %edx,%eax
  800cda:	01 c0                	add    %eax,%eax
  800cdc:	01 d8                	add    %ebx,%eax
  800cde:	83 e8 30             	sub    $0x30,%eax
  800ce1:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ce4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ce8:	0f b6 00             	movzbl (%rax),%eax
  800ceb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cee:	83 fb 2f             	cmp    $0x2f,%ebx
  800cf1:	7e 0c                	jle    800cff <vprintfmt+0x2d3>
  800cf3:	83 fb 39             	cmp    $0x39,%ebx
  800cf6:	7f 07                	jg     800cff <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cf8:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cfd:	eb d1                	jmp    800cd0 <vprintfmt+0x2a4>
			goto process_precision;
  800cff:	eb 58                	jmp    800d59 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800d01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d04:	83 f8 30             	cmp    $0x30,%eax
  800d07:	73 17                	jae    800d20 <vprintfmt+0x2f4>
  800d09:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d0d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d10:	89 c0                	mov    %eax,%eax
  800d12:	48 01 d0             	add    %rdx,%rax
  800d15:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d18:	83 c2 08             	add    $0x8,%edx
  800d1b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d1e:	eb 0f                	jmp    800d2f <vprintfmt+0x303>
  800d20:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d24:	48 89 d0             	mov    %rdx,%rax
  800d27:	48 83 c2 08          	add    $0x8,%rdx
  800d2b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d2f:	8b 00                	mov    (%rax),%eax
  800d31:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800d34:	eb 23                	jmp    800d59 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800d36:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d3a:	79 0c                	jns    800d48 <vprintfmt+0x31c>
				width = 0;
  800d3c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d43:	e9 3b ff ff ff       	jmpq   800c83 <vprintfmt+0x257>
  800d48:	e9 36 ff ff ff       	jmpq   800c83 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800d4d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d54:	e9 2a ff ff ff       	jmpq   800c83 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800d59:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d5d:	79 12                	jns    800d71 <vprintfmt+0x345>
				width = precision, precision = -1;
  800d5f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d62:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d65:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d6c:	e9 12 ff ff ff       	jmpq   800c83 <vprintfmt+0x257>
  800d71:	e9 0d ff ff ff       	jmpq   800c83 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d76:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d7a:	e9 04 ff ff ff       	jmpq   800c83 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d7f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d82:	83 f8 30             	cmp    $0x30,%eax
  800d85:	73 17                	jae    800d9e <vprintfmt+0x372>
  800d87:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d8b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d8e:	89 c0                	mov    %eax,%eax
  800d90:	48 01 d0             	add    %rdx,%rax
  800d93:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d96:	83 c2 08             	add    $0x8,%edx
  800d99:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d9c:	eb 0f                	jmp    800dad <vprintfmt+0x381>
  800d9e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800da2:	48 89 d0             	mov    %rdx,%rax
  800da5:	48 83 c2 08          	add    $0x8,%rdx
  800da9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dad:	8b 10                	mov    (%rax),%edx
  800daf:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800db3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db7:	48 89 ce             	mov    %rcx,%rsi
  800dba:	89 d7                	mov    %edx,%edi
  800dbc:	ff d0                	callq  *%rax
			break;
  800dbe:	e9 66 03 00 00       	jmpq   801129 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800dc3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dc6:	83 f8 30             	cmp    $0x30,%eax
  800dc9:	73 17                	jae    800de2 <vprintfmt+0x3b6>
  800dcb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800dcf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dd2:	89 c0                	mov    %eax,%eax
  800dd4:	48 01 d0             	add    %rdx,%rax
  800dd7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dda:	83 c2 08             	add    $0x8,%edx
  800ddd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800de0:	eb 0f                	jmp    800df1 <vprintfmt+0x3c5>
  800de2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800de6:	48 89 d0             	mov    %rdx,%rax
  800de9:	48 83 c2 08          	add    $0x8,%rdx
  800ded:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800df1:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800df3:	85 db                	test   %ebx,%ebx
  800df5:	79 02                	jns    800df9 <vprintfmt+0x3cd>
				err = -err;
  800df7:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800df9:	83 fb 10             	cmp    $0x10,%ebx
  800dfc:	7f 16                	jg     800e14 <vprintfmt+0x3e8>
  800dfe:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  800e05:	00 00 00 
  800e08:	48 63 d3             	movslq %ebx,%rdx
  800e0b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800e0f:	4d 85 e4             	test   %r12,%r12
  800e12:	75 2e                	jne    800e42 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800e14:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1c:	89 d9                	mov    %ebx,%ecx
  800e1e:	48 ba 39 41 80 00 00 	movabs $0x804139,%rdx
  800e25:	00 00 00 
  800e28:	48 89 c7             	mov    %rax,%rdi
  800e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e30:	49 b8 37 11 80 00 00 	movabs $0x801137,%r8
  800e37:	00 00 00 
  800e3a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e3d:	e9 e7 02 00 00       	jmpq   801129 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e42:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e4a:	4c 89 e1             	mov    %r12,%rcx
  800e4d:	48 ba 42 41 80 00 00 	movabs $0x804142,%rdx
  800e54:	00 00 00 
  800e57:	48 89 c7             	mov    %rax,%rdi
  800e5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e5f:	49 b8 37 11 80 00 00 	movabs $0x801137,%r8
  800e66:	00 00 00 
  800e69:	41 ff d0             	callq  *%r8
			break;
  800e6c:	e9 b8 02 00 00       	jmpq   801129 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e71:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e74:	83 f8 30             	cmp    $0x30,%eax
  800e77:	73 17                	jae    800e90 <vprintfmt+0x464>
  800e79:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e80:	89 c0                	mov    %eax,%eax
  800e82:	48 01 d0             	add    %rdx,%rax
  800e85:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e88:	83 c2 08             	add    $0x8,%edx
  800e8b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e8e:	eb 0f                	jmp    800e9f <vprintfmt+0x473>
  800e90:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e94:	48 89 d0             	mov    %rdx,%rax
  800e97:	48 83 c2 08          	add    $0x8,%rdx
  800e9b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e9f:	4c 8b 20             	mov    (%rax),%r12
  800ea2:	4d 85 e4             	test   %r12,%r12
  800ea5:	75 0a                	jne    800eb1 <vprintfmt+0x485>
				p = "(null)";
  800ea7:	49 bc 45 41 80 00 00 	movabs $0x804145,%r12
  800eae:	00 00 00 
			if (width > 0 && padc != '-')
  800eb1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800eb5:	7e 3f                	jle    800ef6 <vprintfmt+0x4ca>
  800eb7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ebb:	74 39                	je     800ef6 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ebd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ec0:	48 98                	cltq   
  800ec2:	48 89 c6             	mov    %rax,%rsi
  800ec5:	4c 89 e7             	mov    %r12,%rdi
  800ec8:	48 b8 e3 13 80 00 00 	movabs $0x8013e3,%rax
  800ecf:	00 00 00 
  800ed2:	ff d0                	callq  *%rax
  800ed4:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ed7:	eb 17                	jmp    800ef0 <vprintfmt+0x4c4>
					putch(padc, putdat);
  800ed9:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800edd:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ee1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee5:	48 89 ce             	mov    %rcx,%rsi
  800ee8:	89 d7                	mov    %edx,%edi
  800eea:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eec:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ef0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ef4:	7f e3                	jg     800ed9 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ef6:	eb 37                	jmp    800f2f <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800ef8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800efc:	74 1e                	je     800f1c <vprintfmt+0x4f0>
  800efe:	83 fb 1f             	cmp    $0x1f,%ebx
  800f01:	7e 05                	jle    800f08 <vprintfmt+0x4dc>
  800f03:	83 fb 7e             	cmp    $0x7e,%ebx
  800f06:	7e 14                	jle    800f1c <vprintfmt+0x4f0>
					putch('?', putdat);
  800f08:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f10:	48 89 d6             	mov    %rdx,%rsi
  800f13:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800f18:	ff d0                	callq  *%rax
  800f1a:	eb 0f                	jmp    800f2b <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800f1c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f20:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f24:	48 89 d6             	mov    %rdx,%rsi
  800f27:	89 df                	mov    %ebx,%edi
  800f29:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f2b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f2f:	4c 89 e0             	mov    %r12,%rax
  800f32:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800f36:	0f b6 00             	movzbl (%rax),%eax
  800f39:	0f be d8             	movsbl %al,%ebx
  800f3c:	85 db                	test   %ebx,%ebx
  800f3e:	74 10                	je     800f50 <vprintfmt+0x524>
  800f40:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f44:	78 b2                	js     800ef8 <vprintfmt+0x4cc>
  800f46:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f4a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f4e:	79 a8                	jns    800ef8 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f50:	eb 16                	jmp    800f68 <vprintfmt+0x53c>
				putch(' ', putdat);
  800f52:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f5a:	48 89 d6             	mov    %rdx,%rsi
  800f5d:	bf 20 00 00 00       	mov    $0x20,%edi
  800f62:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f64:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f68:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f6c:	7f e4                	jg     800f52 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800f6e:	e9 b6 01 00 00       	jmpq   801129 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f73:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f77:	be 03 00 00 00       	mov    $0x3,%esi
  800f7c:	48 89 c7             	mov    %rax,%rdi
  800f7f:	48 b8 1c 09 80 00 00 	movabs $0x80091c,%rax
  800f86:	00 00 00 
  800f89:	ff d0                	callq  *%rax
  800f8b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f93:	48 85 c0             	test   %rax,%rax
  800f96:	79 1d                	jns    800fb5 <vprintfmt+0x589>
				putch('-', putdat);
  800f98:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fa0:	48 89 d6             	mov    %rdx,%rsi
  800fa3:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800fa8:	ff d0                	callq  *%rax
				num = -(long long) num;
  800faa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fae:	48 f7 d8             	neg    %rax
  800fb1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800fb5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fbc:	e9 fb 00 00 00       	jmpq   8010bc <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800fc1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fc5:	be 03 00 00 00       	mov    $0x3,%esi
  800fca:	48 89 c7             	mov    %rax,%rdi
  800fcd:	48 b8 0c 08 80 00 00 	movabs $0x80080c,%rax
  800fd4:	00 00 00 
  800fd7:	ff d0                	callq  *%rax
  800fd9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800fdd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fe4:	e9 d3 00 00 00       	jmpq   8010bc <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800fe9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fed:	be 03 00 00 00       	mov    $0x3,%esi
  800ff2:	48 89 c7             	mov    %rax,%rdi
  800ff5:	48 b8 1c 09 80 00 00 	movabs $0x80091c,%rax
  800ffc:	00 00 00 
  800fff:	ff d0                	callq  *%rax
  801001:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801005:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801009:	48 85 c0             	test   %rax,%rax
  80100c:	79 1d                	jns    80102b <vprintfmt+0x5ff>
				putch('-', putdat);
  80100e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801012:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801016:	48 89 d6             	mov    %rdx,%rsi
  801019:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80101e:	ff d0                	callq  *%rax
				num = -(long long) num;
  801020:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801024:	48 f7 d8             	neg    %rax
  801027:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  80102b:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801032:	e9 85 00 00 00       	jmpq   8010bc <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  801037:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80103b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80103f:	48 89 d6             	mov    %rdx,%rsi
  801042:	bf 30 00 00 00       	mov    $0x30,%edi
  801047:	ff d0                	callq  *%rax
			putch('x', putdat);
  801049:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80104d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801051:	48 89 d6             	mov    %rdx,%rsi
  801054:	bf 78 00 00 00       	mov    $0x78,%edi
  801059:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80105b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80105e:	83 f8 30             	cmp    $0x30,%eax
  801061:	73 17                	jae    80107a <vprintfmt+0x64e>
  801063:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801067:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80106a:	89 c0                	mov    %eax,%eax
  80106c:	48 01 d0             	add    %rdx,%rax
  80106f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801072:	83 c2 08             	add    $0x8,%edx
  801075:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801078:	eb 0f                	jmp    801089 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  80107a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80107e:	48 89 d0             	mov    %rdx,%rax
  801081:	48 83 c2 08          	add    $0x8,%rdx
  801085:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801089:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80108c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801090:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801097:	eb 23                	jmp    8010bc <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801099:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80109d:	be 03 00 00 00       	mov    $0x3,%esi
  8010a2:	48 89 c7             	mov    %rax,%rdi
  8010a5:	48 b8 0c 08 80 00 00 	movabs $0x80080c,%rax
  8010ac:	00 00 00 
  8010af:	ff d0                	callq  *%rax
  8010b1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8010b5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010bc:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8010c1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8010c4:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8010c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010cb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010cf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010d3:	45 89 c1             	mov    %r8d,%r9d
  8010d6:	41 89 f8             	mov    %edi,%r8d
  8010d9:	48 89 c7             	mov    %rax,%rdi
  8010dc:	48 b8 51 07 80 00 00 	movabs $0x800751,%rax
  8010e3:	00 00 00 
  8010e6:	ff d0                	callq  *%rax
			break;
  8010e8:	eb 3f                	jmp    801129 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ea:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010f2:	48 89 d6             	mov    %rdx,%rsi
  8010f5:	89 df                	mov    %ebx,%edi
  8010f7:	ff d0                	callq  *%rax
			break;
  8010f9:	eb 2e                	jmp    801129 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010fb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010ff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801103:	48 89 d6             	mov    %rdx,%rsi
  801106:	bf 25 00 00 00       	mov    $0x25,%edi
  80110b:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80110d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801112:	eb 05                	jmp    801119 <vprintfmt+0x6ed>
  801114:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801119:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80111d:	48 83 e8 01          	sub    $0x1,%rax
  801121:	0f b6 00             	movzbl (%rax),%eax
  801124:	3c 25                	cmp    $0x25,%al
  801126:	75 ec                	jne    801114 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  801128:	90                   	nop
		}
	}
  801129:	e9 37 f9 ff ff       	jmpq   800a65 <vprintfmt+0x39>
    va_end(aq);
}
  80112e:	48 83 c4 60          	add    $0x60,%rsp
  801132:	5b                   	pop    %rbx
  801133:	41 5c                	pop    %r12
  801135:	5d                   	pop    %rbp
  801136:	c3                   	retq   

0000000000801137 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801137:	55                   	push   %rbp
  801138:	48 89 e5             	mov    %rsp,%rbp
  80113b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801142:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801149:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801150:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801157:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80115e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801165:	84 c0                	test   %al,%al
  801167:	74 20                	je     801189 <printfmt+0x52>
  801169:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80116d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801171:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801175:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801179:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80117d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801181:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801185:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801189:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801190:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801197:	00 00 00 
  80119a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8011a1:	00 00 00 
  8011a4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011a8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8011af:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011b6:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8011bd:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8011c4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8011cb:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8011d2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8011d9:	48 89 c7             	mov    %rax,%rdi
  8011dc:	48 b8 2c 0a 80 00 00 	movabs $0x800a2c,%rax
  8011e3:	00 00 00 
  8011e6:	ff d0                	callq  *%rax
	va_end(ap);
}
  8011e8:	c9                   	leaveq 
  8011e9:	c3                   	retq   

00000000008011ea <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011ea:	55                   	push   %rbp
  8011eb:	48 89 e5             	mov    %rsp,%rbp
  8011ee:	48 83 ec 10          	sub    $0x10,%rsp
  8011f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8011f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8011f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011fd:	8b 40 10             	mov    0x10(%rax),%eax
  801200:	8d 50 01             	lea    0x1(%rax),%edx
  801203:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801207:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80120a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120e:	48 8b 10             	mov    (%rax),%rdx
  801211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801215:	48 8b 40 08          	mov    0x8(%rax),%rax
  801219:	48 39 c2             	cmp    %rax,%rdx
  80121c:	73 17                	jae    801235 <sprintputch+0x4b>
		*b->buf++ = ch;
  80121e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801222:	48 8b 00             	mov    (%rax),%rax
  801225:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801229:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80122d:	48 89 0a             	mov    %rcx,(%rdx)
  801230:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801233:	88 10                	mov    %dl,(%rax)
}
  801235:	c9                   	leaveq 
  801236:	c3                   	retq   

0000000000801237 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801237:	55                   	push   %rbp
  801238:	48 89 e5             	mov    %rsp,%rbp
  80123b:	48 83 ec 50          	sub    $0x50,%rsp
  80123f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801243:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801246:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80124a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80124e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801252:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801256:	48 8b 0a             	mov    (%rdx),%rcx
  801259:	48 89 08             	mov    %rcx,(%rax)
  80125c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801260:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801264:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801268:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80126c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801270:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801274:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801277:	48 98                	cltq   
  801279:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80127d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801281:	48 01 d0             	add    %rdx,%rax
  801284:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801288:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80128f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801294:	74 06                	je     80129c <vsnprintf+0x65>
  801296:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80129a:	7f 07                	jg     8012a3 <vsnprintf+0x6c>
		return -E_INVAL;
  80129c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012a1:	eb 2f                	jmp    8012d2 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8012a3:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8012a7:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8012ab:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8012af:	48 89 c6             	mov    %rax,%rsi
  8012b2:	48 bf ea 11 80 00 00 	movabs $0x8011ea,%rdi
  8012b9:	00 00 00 
  8012bc:	48 b8 2c 0a 80 00 00 	movabs $0x800a2c,%rax
  8012c3:	00 00 00 
  8012c6:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8012c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8012cc:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8012cf:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8012d2:	c9                   	leaveq 
  8012d3:	c3                   	retq   

00000000008012d4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012d4:	55                   	push   %rbp
  8012d5:	48 89 e5             	mov    %rsp,%rbp
  8012d8:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8012df:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8012e6:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8012ec:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012f3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012fa:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801301:	84 c0                	test   %al,%al
  801303:	74 20                	je     801325 <snprintf+0x51>
  801305:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801309:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80130d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801311:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801315:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801319:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80131d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801321:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801325:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80132c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801333:	00 00 00 
  801336:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80133d:	00 00 00 
  801340:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801344:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80134b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801352:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801359:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801360:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801367:	48 8b 0a             	mov    (%rdx),%rcx
  80136a:	48 89 08             	mov    %rcx,(%rax)
  80136d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801371:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801375:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801379:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80137d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801384:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80138b:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801391:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801398:	48 89 c7             	mov    %rax,%rdi
  80139b:	48 b8 37 12 80 00 00 	movabs $0x801237,%rax
  8013a2:	00 00 00 
  8013a5:	ff d0                	callq  *%rax
  8013a7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8013ad:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8013b3:	c9                   	leaveq 
  8013b4:	c3                   	retq   

00000000008013b5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8013b5:	55                   	push   %rbp
  8013b6:	48 89 e5             	mov    %rsp,%rbp
  8013b9:	48 83 ec 18          	sub    $0x18,%rsp
  8013bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8013c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013c8:	eb 09                	jmp    8013d3 <strlen+0x1e>
		n++;
  8013ca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013ce:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d7:	0f b6 00             	movzbl (%rax),%eax
  8013da:	84 c0                	test   %al,%al
  8013dc:	75 ec                	jne    8013ca <strlen+0x15>
		n++;
	return n;
  8013de:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013e1:	c9                   	leaveq 
  8013e2:	c3                   	retq   

00000000008013e3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013e3:	55                   	push   %rbp
  8013e4:	48 89 e5             	mov    %rsp,%rbp
  8013e7:	48 83 ec 20          	sub    $0x20,%rsp
  8013eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013fa:	eb 0e                	jmp    80140a <strnlen+0x27>
		n++;
  8013fc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801400:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801405:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80140a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80140f:	74 0b                	je     80141c <strnlen+0x39>
  801411:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801415:	0f b6 00             	movzbl (%rax),%eax
  801418:	84 c0                	test   %al,%al
  80141a:	75 e0                	jne    8013fc <strnlen+0x19>
		n++;
	return n;
  80141c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80141f:	c9                   	leaveq 
  801420:	c3                   	retq   

0000000000801421 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801421:	55                   	push   %rbp
  801422:	48 89 e5             	mov    %rsp,%rbp
  801425:	48 83 ec 20          	sub    $0x20,%rsp
  801429:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80142d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801431:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801435:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801439:	90                   	nop
  80143a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80143e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801442:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801446:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80144a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80144e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801452:	0f b6 12             	movzbl (%rdx),%edx
  801455:	88 10                	mov    %dl,(%rax)
  801457:	0f b6 00             	movzbl (%rax),%eax
  80145a:	84 c0                	test   %al,%al
  80145c:	75 dc                	jne    80143a <strcpy+0x19>
		/* do nothing */;
	return ret;
  80145e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801462:	c9                   	leaveq 
  801463:	c3                   	retq   

0000000000801464 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801464:	55                   	push   %rbp
  801465:	48 89 e5             	mov    %rsp,%rbp
  801468:	48 83 ec 20          	sub    $0x20,%rsp
  80146c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801470:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801474:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801478:	48 89 c7             	mov    %rax,%rdi
  80147b:	48 b8 b5 13 80 00 00 	movabs $0x8013b5,%rax
  801482:	00 00 00 
  801485:	ff d0                	callq  *%rax
  801487:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80148a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80148d:	48 63 d0             	movslq %eax,%rdx
  801490:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801494:	48 01 c2             	add    %rax,%rdx
  801497:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80149b:	48 89 c6             	mov    %rax,%rsi
  80149e:	48 89 d7             	mov    %rdx,%rdi
  8014a1:	48 b8 21 14 80 00 00 	movabs $0x801421,%rax
  8014a8:	00 00 00 
  8014ab:	ff d0                	callq  *%rax
	return dst;
  8014ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014b1:	c9                   	leaveq 
  8014b2:	c3                   	retq   

00000000008014b3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8014b3:	55                   	push   %rbp
  8014b4:	48 89 e5             	mov    %rsp,%rbp
  8014b7:	48 83 ec 28          	sub    $0x28,%rsp
  8014bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8014c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8014cf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8014d6:	00 
  8014d7:	eb 2a                	jmp    801503 <strncpy+0x50>
		*dst++ = *src;
  8014d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014dd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014e1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014e5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014e9:	0f b6 12             	movzbl (%rdx),%edx
  8014ec:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014f2:	0f b6 00             	movzbl (%rax),%eax
  8014f5:	84 c0                	test   %al,%al
  8014f7:	74 05                	je     8014fe <strncpy+0x4b>
			src++;
  8014f9:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801503:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801507:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80150b:	72 cc                	jb     8014d9 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80150d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801511:	c9                   	leaveq 
  801512:	c3                   	retq   

0000000000801513 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801513:	55                   	push   %rbp
  801514:	48 89 e5             	mov    %rsp,%rbp
  801517:	48 83 ec 28          	sub    $0x28,%rsp
  80151b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80151f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801523:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801527:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80152b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80152f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801534:	74 3d                	je     801573 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801536:	eb 1d                	jmp    801555 <strlcpy+0x42>
			*dst++ = *src++;
  801538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801540:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801544:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801548:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80154c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801550:	0f b6 12             	movzbl (%rdx),%edx
  801553:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801555:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80155a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80155f:	74 0b                	je     80156c <strlcpy+0x59>
  801561:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801565:	0f b6 00             	movzbl (%rax),%eax
  801568:	84 c0                	test   %al,%al
  80156a:	75 cc                	jne    801538 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80156c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801570:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801573:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801577:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157b:	48 29 c2             	sub    %rax,%rdx
  80157e:	48 89 d0             	mov    %rdx,%rax
}
  801581:	c9                   	leaveq 
  801582:	c3                   	retq   

0000000000801583 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801583:	55                   	push   %rbp
  801584:	48 89 e5             	mov    %rsp,%rbp
  801587:	48 83 ec 10          	sub    $0x10,%rsp
  80158b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80158f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801593:	eb 0a                	jmp    80159f <strcmp+0x1c>
		p++, q++;
  801595:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80159a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80159f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a3:	0f b6 00             	movzbl (%rax),%eax
  8015a6:	84 c0                	test   %al,%al
  8015a8:	74 12                	je     8015bc <strcmp+0x39>
  8015aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ae:	0f b6 10             	movzbl (%rax),%edx
  8015b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b5:	0f b6 00             	movzbl (%rax),%eax
  8015b8:	38 c2                	cmp    %al,%dl
  8015ba:	74 d9                	je     801595 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c0:	0f b6 00             	movzbl (%rax),%eax
  8015c3:	0f b6 d0             	movzbl %al,%edx
  8015c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ca:	0f b6 00             	movzbl (%rax),%eax
  8015cd:	0f b6 c0             	movzbl %al,%eax
  8015d0:	29 c2                	sub    %eax,%edx
  8015d2:	89 d0                	mov    %edx,%eax
}
  8015d4:	c9                   	leaveq 
  8015d5:	c3                   	retq   

00000000008015d6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8015d6:	55                   	push   %rbp
  8015d7:	48 89 e5             	mov    %rsp,%rbp
  8015da:	48 83 ec 18          	sub    $0x18,%rsp
  8015de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8015ea:	eb 0f                	jmp    8015fb <strncmp+0x25>
		n--, p++, q++;
  8015ec:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015f6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8015fb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801600:	74 1d                	je     80161f <strncmp+0x49>
  801602:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801606:	0f b6 00             	movzbl (%rax),%eax
  801609:	84 c0                	test   %al,%al
  80160b:	74 12                	je     80161f <strncmp+0x49>
  80160d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801611:	0f b6 10             	movzbl (%rax),%edx
  801614:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801618:	0f b6 00             	movzbl (%rax),%eax
  80161b:	38 c2                	cmp    %al,%dl
  80161d:	74 cd                	je     8015ec <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80161f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801624:	75 07                	jne    80162d <strncmp+0x57>
		return 0;
  801626:	b8 00 00 00 00       	mov    $0x0,%eax
  80162b:	eb 18                	jmp    801645 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80162d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801631:	0f b6 00             	movzbl (%rax),%eax
  801634:	0f b6 d0             	movzbl %al,%edx
  801637:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80163b:	0f b6 00             	movzbl (%rax),%eax
  80163e:	0f b6 c0             	movzbl %al,%eax
  801641:	29 c2                	sub    %eax,%edx
  801643:	89 d0                	mov    %edx,%eax
}
  801645:	c9                   	leaveq 
  801646:	c3                   	retq   

0000000000801647 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801647:	55                   	push   %rbp
  801648:	48 89 e5             	mov    %rsp,%rbp
  80164b:	48 83 ec 0c          	sub    $0xc,%rsp
  80164f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801653:	89 f0                	mov    %esi,%eax
  801655:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801658:	eb 17                	jmp    801671 <strchr+0x2a>
		if (*s == c)
  80165a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165e:	0f b6 00             	movzbl (%rax),%eax
  801661:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801664:	75 06                	jne    80166c <strchr+0x25>
			return (char *) s;
  801666:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166a:	eb 15                	jmp    801681 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80166c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801671:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801675:	0f b6 00             	movzbl (%rax),%eax
  801678:	84 c0                	test   %al,%al
  80167a:	75 de                	jne    80165a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80167c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801681:	c9                   	leaveq 
  801682:	c3                   	retq   

0000000000801683 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801683:	55                   	push   %rbp
  801684:	48 89 e5             	mov    %rsp,%rbp
  801687:	48 83 ec 0c          	sub    $0xc,%rsp
  80168b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80168f:	89 f0                	mov    %esi,%eax
  801691:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801694:	eb 13                	jmp    8016a9 <strfind+0x26>
		if (*s == c)
  801696:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169a:	0f b6 00             	movzbl (%rax),%eax
  80169d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016a0:	75 02                	jne    8016a4 <strfind+0x21>
			break;
  8016a2:	eb 10                	jmp    8016b4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ad:	0f b6 00             	movzbl (%rax),%eax
  8016b0:	84 c0                	test   %al,%al
  8016b2:	75 e2                	jne    801696 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8016b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016b8:	c9                   	leaveq 
  8016b9:	c3                   	retq   

00000000008016ba <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8016ba:	55                   	push   %rbp
  8016bb:	48 89 e5             	mov    %rsp,%rbp
  8016be:	48 83 ec 18          	sub    $0x18,%rsp
  8016c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016c6:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8016c9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8016cd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016d2:	75 06                	jne    8016da <memset+0x20>
		return v;
  8016d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d8:	eb 69                	jmp    801743 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8016da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016de:	83 e0 03             	and    $0x3,%eax
  8016e1:	48 85 c0             	test   %rax,%rax
  8016e4:	75 48                	jne    80172e <memset+0x74>
  8016e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ea:	83 e0 03             	and    $0x3,%eax
  8016ed:	48 85 c0             	test   %rax,%rax
  8016f0:	75 3c                	jne    80172e <memset+0x74>
		c &= 0xFF;
  8016f2:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8016f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016fc:	c1 e0 18             	shl    $0x18,%eax
  8016ff:	89 c2                	mov    %eax,%edx
  801701:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801704:	c1 e0 10             	shl    $0x10,%eax
  801707:	09 c2                	or     %eax,%edx
  801709:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80170c:	c1 e0 08             	shl    $0x8,%eax
  80170f:	09 d0                	or     %edx,%eax
  801711:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801714:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801718:	48 c1 e8 02          	shr    $0x2,%rax
  80171c:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80171f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801723:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801726:	48 89 d7             	mov    %rdx,%rdi
  801729:	fc                   	cld    
  80172a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80172c:	eb 11                	jmp    80173f <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80172e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801732:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801735:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801739:	48 89 d7             	mov    %rdx,%rdi
  80173c:	fc                   	cld    
  80173d:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80173f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801743:	c9                   	leaveq 
  801744:	c3                   	retq   

0000000000801745 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801745:	55                   	push   %rbp
  801746:	48 89 e5             	mov    %rsp,%rbp
  801749:	48 83 ec 28          	sub    $0x28,%rsp
  80174d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801751:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801755:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801759:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80175d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801765:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801769:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80176d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801771:	0f 83 88 00 00 00    	jae    8017ff <memmove+0xba>
  801777:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80177f:	48 01 d0             	add    %rdx,%rax
  801782:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801786:	76 77                	jbe    8017ff <memmove+0xba>
		s += n;
  801788:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801790:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801794:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801798:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80179c:	83 e0 03             	and    $0x3,%eax
  80179f:	48 85 c0             	test   %rax,%rax
  8017a2:	75 3b                	jne    8017df <memmove+0x9a>
  8017a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a8:	83 e0 03             	and    $0x3,%eax
  8017ab:	48 85 c0             	test   %rax,%rax
  8017ae:	75 2f                	jne    8017df <memmove+0x9a>
  8017b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b4:	83 e0 03             	and    $0x3,%eax
  8017b7:	48 85 c0             	test   %rax,%rax
  8017ba:	75 23                	jne    8017df <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8017bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c0:	48 83 e8 04          	sub    $0x4,%rax
  8017c4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017c8:	48 83 ea 04          	sub    $0x4,%rdx
  8017cc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017d0:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8017d4:	48 89 c7             	mov    %rax,%rdi
  8017d7:	48 89 d6             	mov    %rdx,%rsi
  8017da:	fd                   	std    
  8017db:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017dd:	eb 1d                	jmp    8017fc <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8017df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017eb:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f3:	48 89 d7             	mov    %rdx,%rdi
  8017f6:	48 89 c1             	mov    %rax,%rcx
  8017f9:	fd                   	std    
  8017fa:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017fc:	fc                   	cld    
  8017fd:	eb 57                	jmp    801856 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801803:	83 e0 03             	and    $0x3,%eax
  801806:	48 85 c0             	test   %rax,%rax
  801809:	75 36                	jne    801841 <memmove+0xfc>
  80180b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80180f:	83 e0 03             	and    $0x3,%eax
  801812:	48 85 c0             	test   %rax,%rax
  801815:	75 2a                	jne    801841 <memmove+0xfc>
  801817:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181b:	83 e0 03             	and    $0x3,%eax
  80181e:	48 85 c0             	test   %rax,%rax
  801821:	75 1e                	jne    801841 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801823:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801827:	48 c1 e8 02          	shr    $0x2,%rax
  80182b:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80182e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801832:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801836:	48 89 c7             	mov    %rax,%rdi
  801839:	48 89 d6             	mov    %rdx,%rsi
  80183c:	fc                   	cld    
  80183d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80183f:	eb 15                	jmp    801856 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801841:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801845:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801849:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80184d:	48 89 c7             	mov    %rax,%rdi
  801850:	48 89 d6             	mov    %rdx,%rsi
  801853:	fc                   	cld    
  801854:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801856:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80185a:	c9                   	leaveq 
  80185b:	c3                   	retq   

000000000080185c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80185c:	55                   	push   %rbp
  80185d:	48 89 e5             	mov    %rsp,%rbp
  801860:	48 83 ec 18          	sub    $0x18,%rsp
  801864:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801868:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80186c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801870:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801874:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801878:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80187c:	48 89 ce             	mov    %rcx,%rsi
  80187f:	48 89 c7             	mov    %rax,%rdi
  801882:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  801889:	00 00 00 
  80188c:	ff d0                	callq  *%rax
}
  80188e:	c9                   	leaveq 
  80188f:	c3                   	retq   

0000000000801890 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801890:	55                   	push   %rbp
  801891:	48 89 e5             	mov    %rsp,%rbp
  801894:	48 83 ec 28          	sub    $0x28,%rsp
  801898:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80189c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8018a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8018ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8018b4:	eb 36                	jmp    8018ec <memcmp+0x5c>
		if (*s1 != *s2)
  8018b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ba:	0f b6 10             	movzbl (%rax),%edx
  8018bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c1:	0f b6 00             	movzbl (%rax),%eax
  8018c4:	38 c2                	cmp    %al,%dl
  8018c6:	74 1a                	je     8018e2 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8018c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018cc:	0f b6 00             	movzbl (%rax),%eax
  8018cf:	0f b6 d0             	movzbl %al,%edx
  8018d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018d6:	0f b6 00             	movzbl (%rax),%eax
  8018d9:	0f b6 c0             	movzbl %al,%eax
  8018dc:	29 c2                	sub    %eax,%edx
  8018de:	89 d0                	mov    %edx,%eax
  8018e0:	eb 20                	jmp    801902 <memcmp+0x72>
		s1++, s2++;
  8018e2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018e7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018f8:	48 85 c0             	test   %rax,%rax
  8018fb:	75 b9                	jne    8018b6 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801902:	c9                   	leaveq 
  801903:	c3                   	retq   

0000000000801904 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801904:	55                   	push   %rbp
  801905:	48 89 e5             	mov    %rsp,%rbp
  801908:	48 83 ec 28          	sub    $0x28,%rsp
  80190c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801910:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801913:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801917:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80191f:	48 01 d0             	add    %rdx,%rax
  801922:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801926:	eb 15                	jmp    80193d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801928:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80192c:	0f b6 10             	movzbl (%rax),%edx
  80192f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801932:	38 c2                	cmp    %al,%dl
  801934:	75 02                	jne    801938 <memfind+0x34>
			break;
  801936:	eb 0f                	jmp    801947 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801938:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80193d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801941:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801945:	72 e1                	jb     801928 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801947:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80194b:	c9                   	leaveq 
  80194c:	c3                   	retq   

000000000080194d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80194d:	55                   	push   %rbp
  80194e:	48 89 e5             	mov    %rsp,%rbp
  801951:	48 83 ec 34          	sub    $0x34,%rsp
  801955:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801959:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80195d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801960:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801967:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80196e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80196f:	eb 05                	jmp    801976 <strtol+0x29>
		s++;
  801971:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801976:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197a:	0f b6 00             	movzbl (%rax),%eax
  80197d:	3c 20                	cmp    $0x20,%al
  80197f:	74 f0                	je     801971 <strtol+0x24>
  801981:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801985:	0f b6 00             	movzbl (%rax),%eax
  801988:	3c 09                	cmp    $0x9,%al
  80198a:	74 e5                	je     801971 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80198c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801990:	0f b6 00             	movzbl (%rax),%eax
  801993:	3c 2b                	cmp    $0x2b,%al
  801995:	75 07                	jne    80199e <strtol+0x51>
		s++;
  801997:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80199c:	eb 17                	jmp    8019b5 <strtol+0x68>
	else if (*s == '-')
  80199e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a2:	0f b6 00             	movzbl (%rax),%eax
  8019a5:	3c 2d                	cmp    $0x2d,%al
  8019a7:	75 0c                	jne    8019b5 <strtol+0x68>
		s++, neg = 1;
  8019a9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019ae:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019b5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019b9:	74 06                	je     8019c1 <strtol+0x74>
  8019bb:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8019bf:	75 28                	jne    8019e9 <strtol+0x9c>
  8019c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c5:	0f b6 00             	movzbl (%rax),%eax
  8019c8:	3c 30                	cmp    $0x30,%al
  8019ca:	75 1d                	jne    8019e9 <strtol+0x9c>
  8019cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d0:	48 83 c0 01          	add    $0x1,%rax
  8019d4:	0f b6 00             	movzbl (%rax),%eax
  8019d7:	3c 78                	cmp    $0x78,%al
  8019d9:	75 0e                	jne    8019e9 <strtol+0x9c>
		s += 2, base = 16;
  8019db:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8019e0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8019e7:	eb 2c                	jmp    801a15 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8019e9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019ed:	75 19                	jne    801a08 <strtol+0xbb>
  8019ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f3:	0f b6 00             	movzbl (%rax),%eax
  8019f6:	3c 30                	cmp    $0x30,%al
  8019f8:	75 0e                	jne    801a08 <strtol+0xbb>
		s++, base = 8;
  8019fa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019ff:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a06:	eb 0d                	jmp    801a15 <strtol+0xc8>
	else if (base == 0)
  801a08:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a0c:	75 07                	jne    801a15 <strtol+0xc8>
		base = 10;
  801a0e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a19:	0f b6 00             	movzbl (%rax),%eax
  801a1c:	3c 2f                	cmp    $0x2f,%al
  801a1e:	7e 1d                	jle    801a3d <strtol+0xf0>
  801a20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a24:	0f b6 00             	movzbl (%rax),%eax
  801a27:	3c 39                	cmp    $0x39,%al
  801a29:	7f 12                	jg     801a3d <strtol+0xf0>
			dig = *s - '0';
  801a2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2f:	0f b6 00             	movzbl (%rax),%eax
  801a32:	0f be c0             	movsbl %al,%eax
  801a35:	83 e8 30             	sub    $0x30,%eax
  801a38:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a3b:	eb 4e                	jmp    801a8b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a41:	0f b6 00             	movzbl (%rax),%eax
  801a44:	3c 60                	cmp    $0x60,%al
  801a46:	7e 1d                	jle    801a65 <strtol+0x118>
  801a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4c:	0f b6 00             	movzbl (%rax),%eax
  801a4f:	3c 7a                	cmp    $0x7a,%al
  801a51:	7f 12                	jg     801a65 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a57:	0f b6 00             	movzbl (%rax),%eax
  801a5a:	0f be c0             	movsbl %al,%eax
  801a5d:	83 e8 57             	sub    $0x57,%eax
  801a60:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a63:	eb 26                	jmp    801a8b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a69:	0f b6 00             	movzbl (%rax),%eax
  801a6c:	3c 40                	cmp    $0x40,%al
  801a6e:	7e 48                	jle    801ab8 <strtol+0x16b>
  801a70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a74:	0f b6 00             	movzbl (%rax),%eax
  801a77:	3c 5a                	cmp    $0x5a,%al
  801a79:	7f 3d                	jg     801ab8 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a7f:	0f b6 00             	movzbl (%rax),%eax
  801a82:	0f be c0             	movsbl %al,%eax
  801a85:	83 e8 37             	sub    $0x37,%eax
  801a88:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a8e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a91:	7c 02                	jl     801a95 <strtol+0x148>
			break;
  801a93:	eb 23                	jmp    801ab8 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a95:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a9a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a9d:	48 98                	cltq   
  801a9f:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801aa4:	48 89 c2             	mov    %rax,%rdx
  801aa7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801aaa:	48 98                	cltq   
  801aac:	48 01 d0             	add    %rdx,%rax
  801aaf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801ab3:	e9 5d ff ff ff       	jmpq   801a15 <strtol+0xc8>

	if (endptr)
  801ab8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801abd:	74 0b                	je     801aca <strtol+0x17d>
		*endptr = (char *) s;
  801abf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ac3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ac7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801aca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ace:	74 09                	je     801ad9 <strtol+0x18c>
  801ad0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ad4:	48 f7 d8             	neg    %rax
  801ad7:	eb 04                	jmp    801add <strtol+0x190>
  801ad9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801add:	c9                   	leaveq 
  801ade:	c3                   	retq   

0000000000801adf <strstr>:

char * strstr(const char *in, const char *str)
{
  801adf:	55                   	push   %rbp
  801ae0:	48 89 e5             	mov    %rsp,%rbp
  801ae3:	48 83 ec 30          	sub    $0x30,%rsp
  801ae7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801aeb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801aef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801af3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801af7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801afb:	0f b6 00             	movzbl (%rax),%eax
  801afe:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801b01:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801b05:	75 06                	jne    801b0d <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801b07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b0b:	eb 6b                	jmp    801b78 <strstr+0x99>

    len = strlen(str);
  801b0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b11:	48 89 c7             	mov    %rax,%rdi
  801b14:	48 b8 b5 13 80 00 00 	movabs $0x8013b5,%rax
  801b1b:	00 00 00 
  801b1e:	ff d0                	callq  *%rax
  801b20:	48 98                	cltq   
  801b22:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801b26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b2a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b2e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b32:	0f b6 00             	movzbl (%rax),%eax
  801b35:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801b38:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b3c:	75 07                	jne    801b45 <strstr+0x66>
                return (char *) 0;
  801b3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b43:	eb 33                	jmp    801b78 <strstr+0x99>
        } while (sc != c);
  801b45:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b49:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b4c:	75 d8                	jne    801b26 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801b4e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b52:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b5a:	48 89 ce             	mov    %rcx,%rsi
  801b5d:	48 89 c7             	mov    %rax,%rdi
  801b60:	48 b8 d6 15 80 00 00 	movabs $0x8015d6,%rax
  801b67:	00 00 00 
  801b6a:	ff d0                	callq  *%rax
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	75 b6                	jne    801b26 <strstr+0x47>

    return (char *) (in - 1);
  801b70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b74:	48 83 e8 01          	sub    $0x1,%rax
}
  801b78:	c9                   	leaveq 
  801b79:	c3                   	retq   

0000000000801b7a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b7a:	55                   	push   %rbp
  801b7b:	48 89 e5             	mov    %rsp,%rbp
  801b7e:	53                   	push   %rbx
  801b7f:	48 83 ec 48          	sub    $0x48,%rsp
  801b83:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b86:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b89:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b8d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b91:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b95:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b99:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b9c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801ba0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801ba4:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801ba8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801bac:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801bb0:	4c 89 c3             	mov    %r8,%rbx
  801bb3:	cd 30                	int    $0x30
  801bb5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801bb9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801bbd:	74 3e                	je     801bfd <syscall+0x83>
  801bbf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bc4:	7e 37                	jle    801bfd <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801bc6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bcd:	49 89 d0             	mov    %rdx,%r8
  801bd0:	89 c1                	mov    %eax,%ecx
  801bd2:	48 ba 00 44 80 00 00 	movabs $0x804400,%rdx
  801bd9:	00 00 00 
  801bdc:	be 23 00 00 00       	mov    $0x23,%esi
  801be1:	48 bf 1d 44 80 00 00 	movabs $0x80441d,%rdi
  801be8:	00 00 00 
  801beb:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf0:	49 b9 40 04 80 00 00 	movabs $0x800440,%r9
  801bf7:	00 00 00 
  801bfa:	41 ff d1             	callq  *%r9

	return ret;
  801bfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c01:	48 83 c4 48          	add    $0x48,%rsp
  801c05:	5b                   	pop    %rbx
  801c06:	5d                   	pop    %rbp
  801c07:	c3                   	retq   

0000000000801c08 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c08:	55                   	push   %rbp
  801c09:	48 89 e5             	mov    %rsp,%rbp
  801c0c:	48 83 ec 20          	sub    $0x20,%rsp
  801c10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c14:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c1c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c20:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c27:	00 
  801c28:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c2e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c34:	48 89 d1             	mov    %rdx,%rcx
  801c37:	48 89 c2             	mov    %rax,%rdx
  801c3a:	be 00 00 00 00       	mov    $0x0,%esi
  801c3f:	bf 00 00 00 00       	mov    $0x0,%edi
  801c44:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  801c4b:	00 00 00 
  801c4e:	ff d0                	callq  *%rax
}
  801c50:	c9                   	leaveq 
  801c51:	c3                   	retq   

0000000000801c52 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c52:	55                   	push   %rbp
  801c53:	48 89 e5             	mov    %rsp,%rbp
  801c56:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c61:	00 
  801c62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c73:	ba 00 00 00 00       	mov    $0x0,%edx
  801c78:	be 00 00 00 00       	mov    $0x0,%esi
  801c7d:	bf 01 00 00 00       	mov    $0x1,%edi
  801c82:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  801c89:	00 00 00 
  801c8c:	ff d0                	callq  *%rax
}
  801c8e:	c9                   	leaveq 
  801c8f:	c3                   	retq   

0000000000801c90 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c90:	55                   	push   %rbp
  801c91:	48 89 e5             	mov    %rsp,%rbp
  801c94:	48 83 ec 10          	sub    $0x10,%rsp
  801c98:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c9e:	48 98                	cltq   
  801ca0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca7:	00 
  801ca8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cb9:	48 89 c2             	mov    %rax,%rdx
  801cbc:	be 01 00 00 00       	mov    $0x1,%esi
  801cc1:	bf 03 00 00 00       	mov    $0x3,%edi
  801cc6:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  801ccd:	00 00 00 
  801cd0:	ff d0                	callq  *%rax
}
  801cd2:	c9                   	leaveq 
  801cd3:	c3                   	retq   

0000000000801cd4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801cd4:	55                   	push   %rbp
  801cd5:	48 89 e5             	mov    %rsp,%rbp
  801cd8:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801cdc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce3:	00 
  801ce4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cf5:	ba 00 00 00 00       	mov    $0x0,%edx
  801cfa:	be 00 00 00 00       	mov    $0x0,%esi
  801cff:	bf 02 00 00 00       	mov    $0x2,%edi
  801d04:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  801d0b:	00 00 00 
  801d0e:	ff d0                	callq  *%rax
}
  801d10:	c9                   	leaveq 
  801d11:	c3                   	retq   

0000000000801d12 <sys_yield>:

void
sys_yield(void)
{
  801d12:	55                   	push   %rbp
  801d13:	48 89 e5             	mov    %rsp,%rbp
  801d16:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d1a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d21:	00 
  801d22:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d28:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d2e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d33:	ba 00 00 00 00       	mov    $0x0,%edx
  801d38:	be 00 00 00 00       	mov    $0x0,%esi
  801d3d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d42:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  801d49:	00 00 00 
  801d4c:	ff d0                	callq  *%rax
}
  801d4e:	c9                   	leaveq 
  801d4f:	c3                   	retq   

0000000000801d50 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d50:	55                   	push   %rbp
  801d51:	48 89 e5             	mov    %rsp,%rbp
  801d54:	48 83 ec 20          	sub    $0x20,%rsp
  801d58:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d5b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d5f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d62:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d65:	48 63 c8             	movslq %eax,%rcx
  801d68:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d6f:	48 98                	cltq   
  801d71:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d78:	00 
  801d79:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d7f:	49 89 c8             	mov    %rcx,%r8
  801d82:	48 89 d1             	mov    %rdx,%rcx
  801d85:	48 89 c2             	mov    %rax,%rdx
  801d88:	be 01 00 00 00       	mov    $0x1,%esi
  801d8d:	bf 04 00 00 00       	mov    $0x4,%edi
  801d92:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  801d99:	00 00 00 
  801d9c:	ff d0                	callq  *%rax
}
  801d9e:	c9                   	leaveq 
  801d9f:	c3                   	retq   

0000000000801da0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801da0:	55                   	push   %rbp
  801da1:	48 89 e5             	mov    %rsp,%rbp
  801da4:	48 83 ec 30          	sub    $0x30,%rsp
  801da8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801daf:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801db2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801db6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801dba:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dbd:	48 63 c8             	movslq %eax,%rcx
  801dc0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801dc4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dc7:	48 63 f0             	movslq %eax,%rsi
  801dca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd1:	48 98                	cltq   
  801dd3:	48 89 0c 24          	mov    %rcx,(%rsp)
  801dd7:	49 89 f9             	mov    %rdi,%r9
  801dda:	49 89 f0             	mov    %rsi,%r8
  801ddd:	48 89 d1             	mov    %rdx,%rcx
  801de0:	48 89 c2             	mov    %rax,%rdx
  801de3:	be 01 00 00 00       	mov    $0x1,%esi
  801de8:	bf 05 00 00 00       	mov    $0x5,%edi
  801ded:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  801df4:	00 00 00 
  801df7:	ff d0                	callq  *%rax
}
  801df9:	c9                   	leaveq 
  801dfa:	c3                   	retq   

0000000000801dfb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801dfb:	55                   	push   %rbp
  801dfc:	48 89 e5             	mov    %rsp,%rbp
  801dff:	48 83 ec 20          	sub    $0x20,%rsp
  801e03:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e11:	48 98                	cltq   
  801e13:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e1a:	00 
  801e1b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e21:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e27:	48 89 d1             	mov    %rdx,%rcx
  801e2a:	48 89 c2             	mov    %rax,%rdx
  801e2d:	be 01 00 00 00       	mov    $0x1,%esi
  801e32:	bf 06 00 00 00       	mov    $0x6,%edi
  801e37:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  801e3e:	00 00 00 
  801e41:	ff d0                	callq  *%rax
}
  801e43:	c9                   	leaveq 
  801e44:	c3                   	retq   

0000000000801e45 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e45:	55                   	push   %rbp
  801e46:	48 89 e5             	mov    %rsp,%rbp
  801e49:	48 83 ec 10          	sub    $0x10,%rsp
  801e4d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e50:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e53:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e56:	48 63 d0             	movslq %eax,%rdx
  801e59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e5c:	48 98                	cltq   
  801e5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e65:	00 
  801e66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e72:	48 89 d1             	mov    %rdx,%rcx
  801e75:	48 89 c2             	mov    %rax,%rdx
  801e78:	be 01 00 00 00       	mov    $0x1,%esi
  801e7d:	bf 08 00 00 00       	mov    $0x8,%edi
  801e82:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  801e89:	00 00 00 
  801e8c:	ff d0                	callq  *%rax
}
  801e8e:	c9                   	leaveq 
  801e8f:	c3                   	retq   

0000000000801e90 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e90:	55                   	push   %rbp
  801e91:	48 89 e5             	mov    %rsp,%rbp
  801e94:	48 83 ec 20          	sub    $0x20,%rsp
  801e98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e9f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ea3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ea6:	48 98                	cltq   
  801ea8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eaf:	00 
  801eb0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eb6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ebc:	48 89 d1             	mov    %rdx,%rcx
  801ebf:	48 89 c2             	mov    %rax,%rdx
  801ec2:	be 01 00 00 00       	mov    $0x1,%esi
  801ec7:	bf 09 00 00 00       	mov    $0x9,%edi
  801ecc:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  801ed3:	00 00 00 
  801ed6:	ff d0                	callq  *%rax
}
  801ed8:	c9                   	leaveq 
  801ed9:	c3                   	retq   

0000000000801eda <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801eda:	55                   	push   %rbp
  801edb:	48 89 e5             	mov    %rsp,%rbp
  801ede:	48 83 ec 20          	sub    $0x20,%rsp
  801ee2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ee5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ee9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef0:	48 98                	cltq   
  801ef2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ef9:	00 
  801efa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f00:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f06:	48 89 d1             	mov    %rdx,%rcx
  801f09:	48 89 c2             	mov    %rax,%rdx
  801f0c:	be 01 00 00 00       	mov    $0x1,%esi
  801f11:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f16:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  801f1d:	00 00 00 
  801f20:	ff d0                	callq  *%rax
}
  801f22:	c9                   	leaveq 
  801f23:	c3                   	retq   

0000000000801f24 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f24:	55                   	push   %rbp
  801f25:	48 89 e5             	mov    %rsp,%rbp
  801f28:	48 83 ec 20          	sub    $0x20,%rsp
  801f2c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f2f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f33:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f37:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f3d:	48 63 f0             	movslq %eax,%rsi
  801f40:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f47:	48 98                	cltq   
  801f49:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f4d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f54:	00 
  801f55:	49 89 f1             	mov    %rsi,%r9
  801f58:	49 89 c8             	mov    %rcx,%r8
  801f5b:	48 89 d1             	mov    %rdx,%rcx
  801f5e:	48 89 c2             	mov    %rax,%rdx
  801f61:	be 00 00 00 00       	mov    $0x0,%esi
  801f66:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f6b:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  801f72:	00 00 00 
  801f75:	ff d0                	callq  *%rax
}
  801f77:	c9                   	leaveq 
  801f78:	c3                   	retq   

0000000000801f79 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f79:	55                   	push   %rbp
  801f7a:	48 89 e5             	mov    %rsp,%rbp
  801f7d:	48 83 ec 10          	sub    $0x10,%rsp
  801f81:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f89:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f90:	00 
  801f91:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f97:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fa2:	48 89 c2             	mov    %rax,%rdx
  801fa5:	be 01 00 00 00       	mov    $0x1,%esi
  801faa:	bf 0d 00 00 00       	mov    $0xd,%edi
  801faf:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  801fb6:	00 00 00 
  801fb9:	ff d0                	callq  *%rax
}
  801fbb:	c9                   	leaveq 
  801fbc:	c3                   	retq   

0000000000801fbd <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801fbd:	55                   	push   %rbp
  801fbe:	48 89 e5             	mov    %rsp,%rbp
  801fc1:	48 83 ec 30          	sub    $0x30,%rsp
  801fc5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801fc9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fcd:	48 8b 00             	mov    (%rax),%rax
  801fd0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801fd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd8:	48 8b 40 08          	mov    0x8(%rax),%rax
  801fdc:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)))
  801fdf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fe2:	83 e0 02             	and    $0x2,%eax
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	74 23                	je     80200c <pgfault+0x4f>
  801fe9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fed:	48 c1 e8 0c          	shr    $0xc,%rax
  801ff1:	48 89 c2             	mov    %rax,%rdx
  801ff4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ffb:	01 00 00 
  801ffe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802002:	25 00 08 00 00       	and    $0x800,%eax
  802007:	48 85 c0             	test   %rax,%rax
  80200a:	75 2a                	jne    802036 <pgfault+0x79>
		panic("fail check at fork pgfault");
  80200c:	48 ba 2b 44 80 00 00 	movabs $0x80442b,%rdx
  802013:	00 00 00 
  802016:	be 1d 00 00 00       	mov    $0x1d,%esi
  80201b:	48 bf 46 44 80 00 00 	movabs $0x804446,%rdi
  802022:	00 00 00 
  802025:	b8 00 00 00 00       	mov    $0x0,%eax
  80202a:	48 b9 40 04 80 00 00 	movabs $0x800440,%rcx
  802031:	00 00 00 
  802034:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  802036:	ba 07 00 00 00       	mov    $0x7,%edx
  80203b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802040:	bf 00 00 00 00       	mov    $0x0,%edi
  802045:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  80204c:	00 00 00 
  80204f:	ff d0                	callq  *%rax

	addr = ROUNDDOWN(addr, PGSIZE);
  802051:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802055:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802059:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80205d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802063:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memmove(PFTEMP, addr, PGSIZE);
  802067:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80206b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802070:	48 89 c6             	mov    %rax,%rsi
  802073:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802078:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  80207f:	00 00 00 
  802082:	ff d0                	callq  *%rax

	sys_page_map(0, (void *)PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W);
  802084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802088:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80208e:	48 89 c1             	mov    %rax,%rcx
  802091:	ba 00 00 00 00       	mov    $0x0,%edx
  802096:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80209b:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a0:	48 b8 a0 1d 80 00 00 	movabs $0x801da0,%rax
  8020a7:	00 00 00 
  8020aa:	ff d0                	callq  *%rax
	sys_page_unmap(0, PFTEMP);
  8020ac:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8020b6:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  8020bd:	00 00 00 
  8020c0:	ff d0                	callq  *%rax
	//panic("pgfault not implemented");
}
  8020c2:	c9                   	leaveq 
  8020c3:	c3                   	retq   

00000000008020c4 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8020c4:	55                   	push   %rbp
  8020c5:	48 89 e5             	mov    %rsp,%rbp
  8020c8:	48 83 ec 20          	sub    $0x20,%rsp
  8020cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020cf:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uintptr_t)pn * PGSIZE);
  8020d2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020d5:	48 c1 e0 0c          	shl    $0xc,%rax
  8020d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	// note: modified for LAB 5, supporting PTE_SHARE
	if (uvpt[pn] & PTE_SHARE) {
  8020dd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020e4:	01 00 00 
  8020e7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8020ea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ee:	25 00 04 00 00       	and    $0x400,%eax
  8020f3:	48 85 c0             	test   %rax,%rax
  8020f6:	74 55                	je     80214d <duppage+0x89>
		if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL))) < 0)
  8020f8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020ff:	01 00 00 
  802102:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802105:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802109:	25 07 0e 00 00       	and    $0xe07,%eax
  80210e:	89 c6                	mov    %eax,%esi
  802110:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802114:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802117:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80211b:	41 89 f0             	mov    %esi,%r8d
  80211e:	48 89 c6             	mov    %rax,%rsi
  802121:	bf 00 00 00 00       	mov    $0x0,%edi
  802126:	48 b8 a0 1d 80 00 00 	movabs $0x801da0,%rax
  80212d:	00 00 00 
  802130:	ff d0                	callq  *%rax
  802132:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802135:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802139:	79 08                	jns    802143 <duppage+0x7f>
			return r;
  80213b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80213e:	e9 e1 00 00 00       	jmpq   802224 <duppage+0x160>
		return 0;
  802143:	b8 00 00 00 00       	mov    $0x0,%eax
  802148:	e9 d7 00 00 00       	jmpq   802224 <duppage+0x160>
	}

	// note: here we must set ~PTE_W and PTE_COW such that parent process can get correct pid
	if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  80214d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802154:	01 00 00 
  802157:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80215a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80215e:	25 05 06 00 00       	and    $0x605,%eax
  802163:	80 cc 08             	or     $0x8,%ah
  802166:	89 c6                	mov    %eax,%esi
  802168:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80216c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80216f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802173:	41 89 f0             	mov    %esi,%r8d
  802176:	48 89 c6             	mov    %rax,%rsi
  802179:	bf 00 00 00 00       	mov    $0x0,%edi
  80217e:	48 b8 a0 1d 80 00 00 	movabs $0x801da0,%rax
  802185:	00 00 00 
  802188:	ff d0                	callq  *%rax
  80218a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80218d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802191:	79 08                	jns    80219b <duppage+0xd7>
		return r;
  802193:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802196:	e9 89 00 00 00       	jmpq   802224 <duppage+0x160>

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  80219b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021a2:	01 00 00 
  8021a5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8021a8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ac:	83 e0 02             	and    $0x2,%eax
  8021af:	48 85 c0             	test   %rax,%rax
  8021b2:	75 1b                	jne    8021cf <duppage+0x10b>
  8021b4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021bb:	01 00 00 
  8021be:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8021c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c5:	25 00 08 00 00       	and    $0x800,%eax
  8021ca:	48 85 c0             	test   %rax,%rax
  8021cd:	74 50                	je     80221f <duppage+0x15b>
		if ((r = sys_page_map(0, addr, 0, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  8021cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021d6:	01 00 00 
  8021d9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8021dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e0:	25 05 06 00 00       	and    $0x605,%eax
  8021e5:	80 cc 08             	or     $0x8,%ah
  8021e8:	89 c1                	mov    %eax,%ecx
  8021ea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021f2:	41 89 c8             	mov    %ecx,%r8d
  8021f5:	48 89 d1             	mov    %rdx,%rcx
  8021f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8021fd:	48 89 c6             	mov    %rax,%rsi
  802200:	bf 00 00 00 00       	mov    $0x0,%edi
  802205:	48 b8 a0 1d 80 00 00 	movabs $0x801da0,%rax
  80220c:	00 00 00 
  80220f:	ff d0                	callq  *%rax
  802211:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802214:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802218:	79 05                	jns    80221f <duppage+0x15b>
			return r;
  80221a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80221d:	eb 05                	jmp    802224 <duppage+0x160>
	//panic("duppage not implemented");
	return 0;
  80221f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802224:	c9                   	leaveq 
  802225:	c3                   	retq   

0000000000802226 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802226:	55                   	push   %rbp
  802227:	48 89 e5             	mov    %rsp,%rbp
  80222a:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	int r;
	envid_t envid;
	int i, j, k, l, ptx = 0;
  80222e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	set_pgfault_handler(pgfault);
  802235:	48 bf bd 1f 80 00 00 	movabs $0x801fbd,%rdi
  80223c:	00 00 00 
  80223f:	48 b8 28 3d 80 00 00 	movabs $0x803d28,%rax
  802246:	00 00 00 
  802249:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80224b:	b8 07 00 00 00       	mov    $0x7,%eax
  802250:	cd 30                	int    $0x30
  802252:	89 45 e0             	mov    %eax,-0x20(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802255:	8b 45 e0             	mov    -0x20(%rbp),%eax

	if ((envid = sys_exofork()) < 0)
  802258:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80225b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80225f:	79 08                	jns    802269 <fork+0x43>
		return envid;
  802261:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802264:	e9 27 02 00 00       	jmpq   802490 <fork+0x26a>
	else if (envid == 0) {
  802269:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80226d:	75 46                	jne    8022b5 <fork+0x8f>
		thisenv = &envs[ENVX(sys_getenvid())];
  80226f:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  802276:	00 00 00 
  802279:	ff d0                	callq  *%rax
  80227b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802280:	48 63 d0             	movslq %eax,%rdx
  802283:	48 89 d0             	mov    %rdx,%rax
  802286:	48 c1 e0 03          	shl    $0x3,%rax
  80228a:	48 01 d0             	add    %rdx,%rax
  80228d:	48 c1 e0 05          	shl    $0x5,%rax
  802291:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802298:	00 00 00 
  80229b:	48 01 c2             	add    %rax,%rdx
  80229e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022a5:	00 00 00 
  8022a8:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8022ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b0:	e9 db 01 00 00       	jmpq   802490 <fork+0x26a>
	}

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8022b5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8022b8:	ba 07 00 00 00       	mov    $0x7,%edx
  8022bd:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8022c2:	89 c7                	mov    %eax,%edi
  8022c4:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  8022cb:	00 00 00 
  8022ce:	ff d0                	callq  *%rax
  8022d0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8022d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8022d7:	79 08                	jns    8022e1 <fork+0xbb>
		return r;
  8022d9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8022dc:	e9 af 01 00 00       	jmpq   802490 <fork+0x26a>

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  8022e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022e8:	e9 49 01 00 00       	jmpq   802436 <fork+0x210>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  8022ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022f0:	8d 90 ff ff ff 07    	lea    0x7ffffff(%rax),%edx
  8022f6:	85 c0                	test   %eax,%eax
  8022f8:	0f 48 c2             	cmovs  %edx,%eax
  8022fb:	c1 f8 1b             	sar    $0x1b,%eax
  8022fe:	89 c2                	mov    %eax,%edx
  802300:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802307:	01 00 00 
  80230a:	48 63 d2             	movslq %edx,%rdx
  80230d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802311:	83 e0 01             	and    $0x1,%eax
  802314:	48 85 c0             	test   %rax,%rax
  802317:	75 0c                	jne    802325 <fork+0xff>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  802319:	81 45 ec 00 00 00 08 	addl   $0x8000000,-0x14(%rbp)
			continue;
  802320:	e9 0d 01 00 00       	jmpq   802432 <fork+0x20c>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  802325:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  80232c:	e9 f4 00 00 00       	jmpq   802425 <fork+0x1ff>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  802331:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802334:	8d 90 ff ff 03 00    	lea    0x3ffff(%rax),%edx
  80233a:	85 c0                	test   %eax,%eax
  80233c:	0f 48 c2             	cmovs  %edx,%eax
  80233f:	c1 f8 12             	sar    $0x12,%eax
  802342:	89 c2                	mov    %eax,%edx
  802344:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80234b:	01 00 00 
  80234e:	48 63 d2             	movslq %edx,%rdx
  802351:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802355:	83 e0 01             	and    $0x1,%eax
  802358:	48 85 c0             	test   %rax,%rax
  80235b:	75 0c                	jne    802369 <fork+0x143>
				ptx += NPDENTRIES * NPTENTRIES;
  80235d:	81 45 ec 00 00 04 00 	addl   $0x40000,-0x14(%rbp)
				continue;
  802364:	e9 b8 00 00 00       	jmpq   802421 <fork+0x1fb>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  802369:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  802370:	e9 9f 00 00 00       	jmpq   802414 <fork+0x1ee>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  802375:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802378:	8d 90 ff 01 00 00    	lea    0x1ff(%rax),%edx
  80237e:	85 c0                	test   %eax,%eax
  802380:	0f 48 c2             	cmovs  %edx,%eax
  802383:	c1 f8 09             	sar    $0x9,%eax
  802386:	89 c2                	mov    %eax,%edx
  802388:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80238f:	01 00 00 
  802392:	48 63 d2             	movslq %edx,%rdx
  802395:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802399:	83 e0 01             	and    $0x1,%eax
  80239c:	48 85 c0             	test   %rax,%rax
  80239f:	75 09                	jne    8023aa <fork+0x184>
					ptx += NPTENTRIES;
  8023a1:	81 45 ec 00 02 00 00 	addl   $0x200,-0x14(%rbp)
					continue;
  8023a8:	eb 66                	jmp    802410 <fork+0x1ea>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  8023aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8023b1:	eb 54                	jmp    802407 <fork+0x1e1>
					if ((uvpt[ptx] & PTE_P) != 0)
  8023b3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023ba:	01 00 00 
  8023bd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8023c0:	48 63 d2             	movslq %edx,%rdx
  8023c3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023c7:	83 e0 01             	and    $0x1,%eax
  8023ca:	48 85 c0             	test   %rax,%rax
  8023cd:	74 30                	je     8023ff <fork+0x1d9>
						if (ptx != VPN(UXSTACKTOP - PGSIZE))
  8023cf:	81 7d ec ff f7 0e 00 	cmpl   $0xef7ff,-0x14(%rbp)
  8023d6:	74 27                	je     8023ff <fork+0x1d9>
							if ((r = duppage(envid, ptx)) < 0)
  8023d8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8023db:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8023de:	89 d6                	mov    %edx,%esi
  8023e0:	89 c7                	mov    %eax,%edi
  8023e2:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
  8023e9:	00 00 00 
  8023ec:	ff d0                	callq  *%rax
  8023ee:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8023f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8023f5:	79 08                	jns    8023ff <fork+0x1d9>
								return r;
  8023f7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8023fa:	e9 91 00 00 00       	jmpq   802490 <fork+0x26a>
					ptx++;
  8023ff:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  802403:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  802407:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
  80240e:	7e a3                	jle    8023b3 <fork+0x18d>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  802410:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  802414:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
  80241b:	0f 8e 54 ff ff ff    	jle    802375 <fork+0x14f>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  802421:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  802425:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
  80242c:	0f 8e ff fe ff ff    	jle    802331 <fork+0x10b>
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		return r;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  802432:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802436:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80243a:	0f 84 ad fe ff ff    	je     8022ed <fork+0xc7>
			}
		}
	}

	extern void _pgfault_upcall();
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  802440:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802443:	48 be 93 3d 80 00 00 	movabs $0x803d93,%rsi
  80244a:	00 00 00 
  80244d:	89 c7                	mov    %eax,%edi
  80244f:	48 b8 da 1e 80 00 00 	movabs $0x801eda,%rax
  802456:	00 00 00 
  802459:	ff d0                	callq  *%rax
  80245b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80245e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802462:	79 05                	jns    802469 <fork+0x243>
		return r;
  802464:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802467:	eb 27                	jmp    802490 <fork+0x26a>
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802469:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80246c:	be 02 00 00 00       	mov    $0x2,%esi
  802471:	89 c7                	mov    %eax,%edi
  802473:	48 b8 45 1e 80 00 00 	movabs $0x801e45,%rax
  80247a:	00 00 00 
  80247d:	ff d0                	callq  *%rax
  80247f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802482:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802486:	79 05                	jns    80248d <fork+0x267>
		return r;
  802488:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80248b:	eb 03                	jmp    802490 <fork+0x26a>

	return envid;
  80248d:	8b 45 e8             	mov    -0x18(%rbp),%eax
	//panic("fork not implemented");
}
  802490:	c9                   	leaveq 
  802491:	c3                   	retq   

0000000000802492 <sfork>:

// Challenge!
int
sfork(void)
{
  802492:	55                   	push   %rbp
  802493:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802496:	48 ba 51 44 80 00 00 	movabs $0x804451,%rdx
  80249d:	00 00 00 
  8024a0:	be a7 00 00 00       	mov    $0xa7,%esi
  8024a5:	48 bf 46 44 80 00 00 	movabs $0x804446,%rdi
  8024ac:	00 00 00 
  8024af:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b4:	48 b9 40 04 80 00 00 	movabs $0x800440,%rcx
  8024bb:	00 00 00 
  8024be:	ff d1                	callq  *%rcx

00000000008024c0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024c0:	55                   	push   %rbp
  8024c1:	48 89 e5             	mov    %rsp,%rbp
  8024c4:	48 83 ec 30          	sub    $0x30,%rsp
  8024c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8024cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024d0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8024d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8024dc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8024e1:	75 0e                	jne    8024f1 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  8024e3:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8024ea:	00 00 00 
  8024ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  8024f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024f5:	48 89 c7             	mov    %rax,%rdi
  8024f8:	48 b8 79 1f 80 00 00 	movabs $0x801f79,%rax
  8024ff:	00 00 00 
  802502:	ff d0                	callq  *%rax
  802504:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802507:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80250b:	79 27                	jns    802534 <ipc_recv+0x74>
		if (from_env_store != NULL)
  80250d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802512:	74 0a                	je     80251e <ipc_recv+0x5e>
			*from_env_store = 0;
  802514:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802518:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  80251e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802523:	74 0a                	je     80252f <ipc_recv+0x6f>
			*perm_store = 0;
  802525:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802529:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  80252f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802532:	eb 53                	jmp    802587 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  802534:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802539:	74 19                	je     802554 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  80253b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802542:	00 00 00 
  802545:	48 8b 00             	mov    (%rax),%rax
  802548:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80254e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802552:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  802554:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802559:	74 19                	je     802574 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  80255b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802562:	00 00 00 
  802565:	48 8b 00             	mov    (%rax),%rax
  802568:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80256e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802572:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  802574:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80257b:	00 00 00 
  80257e:	48 8b 00             	mov    (%rax),%rax
  802581:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  802587:	c9                   	leaveq 
  802588:	c3                   	retq   

0000000000802589 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802589:	55                   	push   %rbp
  80258a:	48 89 e5             	mov    %rsp,%rbp
  80258d:	48 83 ec 30          	sub    $0x30,%rsp
  802591:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802594:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802597:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80259b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  80259e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8025a6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8025ab:	75 10                	jne    8025bd <ipc_send+0x34>
		page = (void *)KERNBASE;
  8025ad:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8025b4:	00 00 00 
  8025b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  8025bb:	eb 0e                	jmp    8025cb <ipc_send+0x42>
  8025bd:	eb 0c                	jmp    8025cb <ipc_send+0x42>
		sys_yield();
  8025bf:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  8025c6:	00 00 00 
  8025c9:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  8025cb:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8025ce:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8025d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025d8:	89 c7                	mov    %eax,%edi
  8025da:	48 b8 24 1f 80 00 00 	movabs $0x801f24,%rax
  8025e1:	00 00 00 
  8025e4:	ff d0                	callq  *%rax
  8025e6:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8025e9:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  8025ed:	74 d0                	je     8025bf <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  8025ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8025f3:	74 2a                	je     80261f <ipc_send+0x96>
		panic("error on ipc send procedure");
  8025f5:	48 ba 67 44 80 00 00 	movabs $0x804467,%rdx
  8025fc:	00 00 00 
  8025ff:	be 49 00 00 00       	mov    $0x49,%esi
  802604:	48 bf 83 44 80 00 00 	movabs $0x804483,%rdi
  80260b:	00 00 00 
  80260e:	b8 00 00 00 00       	mov    $0x0,%eax
  802613:	48 b9 40 04 80 00 00 	movabs $0x800440,%rcx
  80261a:	00 00 00 
  80261d:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  80261f:	c9                   	leaveq 
  802620:	c3                   	retq   

0000000000802621 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802621:	55                   	push   %rbp
  802622:	48 89 e5             	mov    %rsp,%rbp
  802625:	48 83 ec 14          	sub    $0x14,%rsp
  802629:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80262c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802633:	eb 5e                	jmp    802693 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802635:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80263c:	00 00 00 
  80263f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802642:	48 63 d0             	movslq %eax,%rdx
  802645:	48 89 d0             	mov    %rdx,%rax
  802648:	48 c1 e0 03          	shl    $0x3,%rax
  80264c:	48 01 d0             	add    %rdx,%rax
  80264f:	48 c1 e0 05          	shl    $0x5,%rax
  802653:	48 01 c8             	add    %rcx,%rax
  802656:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80265c:	8b 00                	mov    (%rax),%eax
  80265e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802661:	75 2c                	jne    80268f <ipc_find_env+0x6e>
			return envs[i].env_id;
  802663:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80266a:	00 00 00 
  80266d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802670:	48 63 d0             	movslq %eax,%rdx
  802673:	48 89 d0             	mov    %rdx,%rax
  802676:	48 c1 e0 03          	shl    $0x3,%rax
  80267a:	48 01 d0             	add    %rdx,%rax
  80267d:	48 c1 e0 05          	shl    $0x5,%rax
  802681:	48 01 c8             	add    %rcx,%rax
  802684:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80268a:	8b 40 08             	mov    0x8(%rax),%eax
  80268d:	eb 12                	jmp    8026a1 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80268f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802693:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80269a:	7e 99                	jle    802635 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80269c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a1:	c9                   	leaveq 
  8026a2:	c3                   	retq   

00000000008026a3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8026a3:	55                   	push   %rbp
  8026a4:	48 89 e5             	mov    %rsp,%rbp
  8026a7:	48 83 ec 08          	sub    $0x8,%rsp
  8026ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8026af:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026b3:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8026ba:	ff ff ff 
  8026bd:	48 01 d0             	add    %rdx,%rax
  8026c0:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8026c4:	c9                   	leaveq 
  8026c5:	c3                   	retq   

00000000008026c6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8026c6:	55                   	push   %rbp
  8026c7:	48 89 e5             	mov    %rsp,%rbp
  8026ca:	48 83 ec 08          	sub    $0x8,%rsp
  8026ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8026d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026d6:	48 89 c7             	mov    %rax,%rdi
  8026d9:	48 b8 a3 26 80 00 00 	movabs $0x8026a3,%rax
  8026e0:	00 00 00 
  8026e3:	ff d0                	callq  *%rax
  8026e5:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8026eb:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8026ef:	c9                   	leaveq 
  8026f0:	c3                   	retq   

00000000008026f1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8026f1:	55                   	push   %rbp
  8026f2:	48 89 e5             	mov    %rsp,%rbp
  8026f5:	48 83 ec 18          	sub    $0x18,%rsp
  8026f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802704:	eb 6b                	jmp    802771 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802706:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802709:	48 98                	cltq   
  80270b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802711:	48 c1 e0 0c          	shl    $0xc,%rax
  802715:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802719:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271d:	48 c1 e8 15          	shr    $0x15,%rax
  802721:	48 89 c2             	mov    %rax,%rdx
  802724:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80272b:	01 00 00 
  80272e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802732:	83 e0 01             	and    $0x1,%eax
  802735:	48 85 c0             	test   %rax,%rax
  802738:	74 21                	je     80275b <fd_alloc+0x6a>
  80273a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273e:	48 c1 e8 0c          	shr    $0xc,%rax
  802742:	48 89 c2             	mov    %rax,%rdx
  802745:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80274c:	01 00 00 
  80274f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802753:	83 e0 01             	and    $0x1,%eax
  802756:	48 85 c0             	test   %rax,%rax
  802759:	75 12                	jne    80276d <fd_alloc+0x7c>
			*fd_store = fd;
  80275b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80275f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802763:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802766:	b8 00 00 00 00       	mov    $0x0,%eax
  80276b:	eb 1a                	jmp    802787 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80276d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802771:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802775:	7e 8f                	jle    802706 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802777:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80277b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802782:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802787:	c9                   	leaveq 
  802788:	c3                   	retq   

0000000000802789 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802789:	55                   	push   %rbp
  80278a:	48 89 e5             	mov    %rsp,%rbp
  80278d:	48 83 ec 20          	sub    $0x20,%rsp
  802791:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802794:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802798:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80279c:	78 06                	js     8027a4 <fd_lookup+0x1b>
  80279e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8027a2:	7e 07                	jle    8027ab <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027a9:	eb 6c                	jmp    802817 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8027ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027ae:	48 98                	cltq   
  8027b0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027b6:	48 c1 e0 0c          	shl    $0xc,%rax
  8027ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8027be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027c2:	48 c1 e8 15          	shr    $0x15,%rax
  8027c6:	48 89 c2             	mov    %rax,%rdx
  8027c9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027d0:	01 00 00 
  8027d3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027d7:	83 e0 01             	and    $0x1,%eax
  8027da:	48 85 c0             	test   %rax,%rax
  8027dd:	74 21                	je     802800 <fd_lookup+0x77>
  8027df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027e3:	48 c1 e8 0c          	shr    $0xc,%rax
  8027e7:	48 89 c2             	mov    %rax,%rdx
  8027ea:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027f1:	01 00 00 
  8027f4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027f8:	83 e0 01             	and    $0x1,%eax
  8027fb:	48 85 c0             	test   %rax,%rax
  8027fe:	75 07                	jne    802807 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802800:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802805:	eb 10                	jmp    802817 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802807:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80280b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80280f:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802812:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802817:	c9                   	leaveq 
  802818:	c3                   	retq   

0000000000802819 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802819:	55                   	push   %rbp
  80281a:	48 89 e5             	mov    %rsp,%rbp
  80281d:	48 83 ec 30          	sub    $0x30,%rsp
  802821:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802825:	89 f0                	mov    %esi,%eax
  802827:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80282a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80282e:	48 89 c7             	mov    %rax,%rdi
  802831:	48 b8 a3 26 80 00 00 	movabs $0x8026a3,%rax
  802838:	00 00 00 
  80283b:	ff d0                	callq  *%rax
  80283d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802841:	48 89 d6             	mov    %rdx,%rsi
  802844:	89 c7                	mov    %eax,%edi
  802846:	48 b8 89 27 80 00 00 	movabs $0x802789,%rax
  80284d:	00 00 00 
  802850:	ff d0                	callq  *%rax
  802852:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802855:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802859:	78 0a                	js     802865 <fd_close+0x4c>
	    || fd != fd2)
  80285b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80285f:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802863:	74 12                	je     802877 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802865:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802869:	74 05                	je     802870 <fd_close+0x57>
  80286b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80286e:	eb 05                	jmp    802875 <fd_close+0x5c>
  802870:	b8 00 00 00 00       	mov    $0x0,%eax
  802875:	eb 69                	jmp    8028e0 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802877:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80287b:	8b 00                	mov    (%rax),%eax
  80287d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802881:	48 89 d6             	mov    %rdx,%rsi
  802884:	89 c7                	mov    %eax,%edi
  802886:	48 b8 e2 28 80 00 00 	movabs $0x8028e2,%rax
  80288d:	00 00 00 
  802890:	ff d0                	callq  *%rax
  802892:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802895:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802899:	78 2a                	js     8028c5 <fd_close+0xac>
		if (dev->dev_close)
  80289b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289f:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028a3:	48 85 c0             	test   %rax,%rax
  8028a6:	74 16                	je     8028be <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8028a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ac:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028b0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028b4:	48 89 d7             	mov    %rdx,%rdi
  8028b7:	ff d0                	callq  *%rax
  8028b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028bc:	eb 07                	jmp    8028c5 <fd_close+0xac>
		else
			r = 0;
  8028be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8028c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028c9:	48 89 c6             	mov    %rax,%rsi
  8028cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8028d1:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  8028d8:	00 00 00 
  8028db:	ff d0                	callq  *%rax
	return r;
  8028dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028e0:	c9                   	leaveq 
  8028e1:	c3                   	retq   

00000000008028e2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8028e2:	55                   	push   %rbp
  8028e3:	48 89 e5             	mov    %rsp,%rbp
  8028e6:	48 83 ec 20          	sub    $0x20,%rsp
  8028ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028ed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8028f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028f8:	eb 41                	jmp    80293b <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8028fa:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802901:	00 00 00 
  802904:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802907:	48 63 d2             	movslq %edx,%rdx
  80290a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80290e:	8b 00                	mov    (%rax),%eax
  802910:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802913:	75 22                	jne    802937 <dev_lookup+0x55>
			*dev = devtab[i];
  802915:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80291c:	00 00 00 
  80291f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802922:	48 63 d2             	movslq %edx,%rdx
  802925:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802929:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80292d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802930:	b8 00 00 00 00       	mov    $0x0,%eax
  802935:	eb 60                	jmp    802997 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802937:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80293b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802942:	00 00 00 
  802945:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802948:	48 63 d2             	movslq %edx,%rdx
  80294b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80294f:	48 85 c0             	test   %rax,%rax
  802952:	75 a6                	jne    8028fa <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802954:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80295b:	00 00 00 
  80295e:	48 8b 00             	mov    (%rax),%rax
  802961:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802967:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80296a:	89 c6                	mov    %eax,%esi
  80296c:	48 bf 90 44 80 00 00 	movabs $0x804490,%rdi
  802973:	00 00 00 
  802976:	b8 00 00 00 00       	mov    $0x0,%eax
  80297b:	48 b9 79 06 80 00 00 	movabs $0x800679,%rcx
  802982:	00 00 00 
  802985:	ff d1                	callq  *%rcx
	*dev = 0;
  802987:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80298b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802992:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802997:	c9                   	leaveq 
  802998:	c3                   	retq   

0000000000802999 <close>:

int
close(int fdnum)
{
  802999:	55                   	push   %rbp
  80299a:	48 89 e5             	mov    %rsp,%rbp
  80299d:	48 83 ec 20          	sub    $0x20,%rsp
  8029a1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029a4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029ab:	48 89 d6             	mov    %rdx,%rsi
  8029ae:	89 c7                	mov    %eax,%edi
  8029b0:	48 b8 89 27 80 00 00 	movabs $0x802789,%rax
  8029b7:	00 00 00 
  8029ba:	ff d0                	callq  *%rax
  8029bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029c3:	79 05                	jns    8029ca <close+0x31>
		return r;
  8029c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c8:	eb 18                	jmp    8029e2 <close+0x49>
	else
		return fd_close(fd, 1);
  8029ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ce:	be 01 00 00 00       	mov    $0x1,%esi
  8029d3:	48 89 c7             	mov    %rax,%rdi
  8029d6:	48 b8 19 28 80 00 00 	movabs $0x802819,%rax
  8029dd:	00 00 00 
  8029e0:	ff d0                	callq  *%rax
}
  8029e2:	c9                   	leaveq 
  8029e3:	c3                   	retq   

00000000008029e4 <close_all>:

void
close_all(void)
{
  8029e4:	55                   	push   %rbp
  8029e5:	48 89 e5             	mov    %rsp,%rbp
  8029e8:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8029ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029f3:	eb 15                	jmp    802a0a <close_all+0x26>
		close(i);
  8029f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f8:	89 c7                	mov    %eax,%edi
  8029fa:	48 b8 99 29 80 00 00 	movabs $0x802999,%rax
  802a01:	00 00 00 
  802a04:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802a06:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a0a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a0e:	7e e5                	jle    8029f5 <close_all+0x11>
		close(i);
}
  802a10:	c9                   	leaveq 
  802a11:	c3                   	retq   

0000000000802a12 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802a12:	55                   	push   %rbp
  802a13:	48 89 e5             	mov    %rsp,%rbp
  802a16:	48 83 ec 40          	sub    $0x40,%rsp
  802a1a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802a1d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802a20:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802a24:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802a27:	48 89 d6             	mov    %rdx,%rsi
  802a2a:	89 c7                	mov    %eax,%edi
  802a2c:	48 b8 89 27 80 00 00 	movabs $0x802789,%rax
  802a33:	00 00 00 
  802a36:	ff d0                	callq  *%rax
  802a38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a3f:	79 08                	jns    802a49 <dup+0x37>
		return r;
  802a41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a44:	e9 70 01 00 00       	jmpq   802bb9 <dup+0x1a7>
	close(newfdnum);
  802a49:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a4c:	89 c7                	mov    %eax,%edi
  802a4e:	48 b8 99 29 80 00 00 	movabs $0x802999,%rax
  802a55:	00 00 00 
  802a58:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a5a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a5d:	48 98                	cltq   
  802a5f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a65:	48 c1 e0 0c          	shl    $0xc,%rax
  802a69:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802a6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a71:	48 89 c7             	mov    %rax,%rdi
  802a74:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  802a7b:	00 00 00 
  802a7e:	ff d0                	callq  *%rax
  802a80:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802a84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a88:	48 89 c7             	mov    %rax,%rdi
  802a8b:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  802a92:	00 00 00 
  802a95:	ff d0                	callq  *%rax
  802a97:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802a9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a9f:	48 c1 e8 15          	shr    $0x15,%rax
  802aa3:	48 89 c2             	mov    %rax,%rdx
  802aa6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802aad:	01 00 00 
  802ab0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ab4:	83 e0 01             	and    $0x1,%eax
  802ab7:	48 85 c0             	test   %rax,%rax
  802aba:	74 73                	je     802b2f <dup+0x11d>
  802abc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac0:	48 c1 e8 0c          	shr    $0xc,%rax
  802ac4:	48 89 c2             	mov    %rax,%rdx
  802ac7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ace:	01 00 00 
  802ad1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ad5:	83 e0 01             	and    $0x1,%eax
  802ad8:	48 85 c0             	test   %rax,%rax
  802adb:	74 52                	je     802b2f <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802add:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae1:	48 c1 e8 0c          	shr    $0xc,%rax
  802ae5:	48 89 c2             	mov    %rax,%rdx
  802ae8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802aef:	01 00 00 
  802af2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802af6:	25 07 0e 00 00       	and    $0xe07,%eax
  802afb:	89 c1                	mov    %eax,%ecx
  802afd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b05:	41 89 c8             	mov    %ecx,%r8d
  802b08:	48 89 d1             	mov    %rdx,%rcx
  802b0b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b10:	48 89 c6             	mov    %rax,%rsi
  802b13:	bf 00 00 00 00       	mov    $0x0,%edi
  802b18:	48 b8 a0 1d 80 00 00 	movabs $0x801da0,%rax
  802b1f:	00 00 00 
  802b22:	ff d0                	callq  *%rax
  802b24:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b2b:	79 02                	jns    802b2f <dup+0x11d>
			goto err;
  802b2d:	eb 57                	jmp    802b86 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b33:	48 c1 e8 0c          	shr    $0xc,%rax
  802b37:	48 89 c2             	mov    %rax,%rdx
  802b3a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b41:	01 00 00 
  802b44:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b48:	25 07 0e 00 00       	and    $0xe07,%eax
  802b4d:	89 c1                	mov    %eax,%ecx
  802b4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b53:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b57:	41 89 c8             	mov    %ecx,%r8d
  802b5a:	48 89 d1             	mov    %rdx,%rcx
  802b5d:	ba 00 00 00 00       	mov    $0x0,%edx
  802b62:	48 89 c6             	mov    %rax,%rsi
  802b65:	bf 00 00 00 00       	mov    $0x0,%edi
  802b6a:	48 b8 a0 1d 80 00 00 	movabs $0x801da0,%rax
  802b71:	00 00 00 
  802b74:	ff d0                	callq  *%rax
  802b76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b7d:	79 02                	jns    802b81 <dup+0x16f>
		goto err;
  802b7f:	eb 05                	jmp    802b86 <dup+0x174>

	return newfdnum;
  802b81:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b84:	eb 33                	jmp    802bb9 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802b86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b8a:	48 89 c6             	mov    %rax,%rsi
  802b8d:	bf 00 00 00 00       	mov    $0x0,%edi
  802b92:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  802b99:	00 00 00 
  802b9c:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802b9e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ba2:	48 89 c6             	mov    %rax,%rsi
  802ba5:	bf 00 00 00 00       	mov    $0x0,%edi
  802baa:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  802bb1:	00 00 00 
  802bb4:	ff d0                	callq  *%rax
	return r;
  802bb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bb9:	c9                   	leaveq 
  802bba:	c3                   	retq   

0000000000802bbb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802bbb:	55                   	push   %rbp
  802bbc:	48 89 e5             	mov    %rsp,%rbp
  802bbf:	48 83 ec 40          	sub    $0x40,%rsp
  802bc3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bc6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802bca:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bce:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bd2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bd5:	48 89 d6             	mov    %rdx,%rsi
  802bd8:	89 c7                	mov    %eax,%edi
  802bda:	48 b8 89 27 80 00 00 	movabs $0x802789,%rax
  802be1:	00 00 00 
  802be4:	ff d0                	callq  *%rax
  802be6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bed:	78 24                	js     802c13 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf3:	8b 00                	mov    (%rax),%eax
  802bf5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bf9:	48 89 d6             	mov    %rdx,%rsi
  802bfc:	89 c7                	mov    %eax,%edi
  802bfe:	48 b8 e2 28 80 00 00 	movabs $0x8028e2,%rax
  802c05:	00 00 00 
  802c08:	ff d0                	callq  *%rax
  802c0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c11:	79 05                	jns    802c18 <read+0x5d>
		return r;
  802c13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c16:	eb 76                	jmp    802c8e <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802c18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1c:	8b 40 08             	mov    0x8(%rax),%eax
  802c1f:	83 e0 03             	and    $0x3,%eax
  802c22:	83 f8 01             	cmp    $0x1,%eax
  802c25:	75 3a                	jne    802c61 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802c27:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802c2e:	00 00 00 
  802c31:	48 8b 00             	mov    (%rax),%rax
  802c34:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c3a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c3d:	89 c6                	mov    %eax,%esi
  802c3f:	48 bf af 44 80 00 00 	movabs $0x8044af,%rdi
  802c46:	00 00 00 
  802c49:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4e:	48 b9 79 06 80 00 00 	movabs $0x800679,%rcx
  802c55:	00 00 00 
  802c58:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c5a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c5f:	eb 2d                	jmp    802c8e <read+0xd3>
	}
	if (!dev->dev_read)
  802c61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c65:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c69:	48 85 c0             	test   %rax,%rax
  802c6c:	75 07                	jne    802c75 <read+0xba>
		return -E_NOT_SUPP;
  802c6e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c73:	eb 19                	jmp    802c8e <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802c75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c79:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c7d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c81:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c85:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c89:	48 89 cf             	mov    %rcx,%rdi
  802c8c:	ff d0                	callq  *%rax
}
  802c8e:	c9                   	leaveq 
  802c8f:	c3                   	retq   

0000000000802c90 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802c90:	55                   	push   %rbp
  802c91:	48 89 e5             	mov    %rsp,%rbp
  802c94:	48 83 ec 30          	sub    $0x30,%rsp
  802c98:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c9b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c9f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ca3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802caa:	eb 49                	jmp    802cf5 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802cac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802caf:	48 98                	cltq   
  802cb1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cb5:	48 29 c2             	sub    %rax,%rdx
  802cb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cbb:	48 63 c8             	movslq %eax,%rcx
  802cbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cc2:	48 01 c1             	add    %rax,%rcx
  802cc5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cc8:	48 89 ce             	mov    %rcx,%rsi
  802ccb:	89 c7                	mov    %eax,%edi
  802ccd:	48 b8 bb 2b 80 00 00 	movabs $0x802bbb,%rax
  802cd4:	00 00 00 
  802cd7:	ff d0                	callq  *%rax
  802cd9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802cdc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ce0:	79 05                	jns    802ce7 <readn+0x57>
			return m;
  802ce2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ce5:	eb 1c                	jmp    802d03 <readn+0x73>
		if (m == 0)
  802ce7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ceb:	75 02                	jne    802cef <readn+0x5f>
			break;
  802ced:	eb 11                	jmp    802d00 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802cef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cf2:	01 45 fc             	add    %eax,-0x4(%rbp)
  802cf5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf8:	48 98                	cltq   
  802cfa:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802cfe:	72 ac                	jb     802cac <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802d00:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d03:	c9                   	leaveq 
  802d04:	c3                   	retq   

0000000000802d05 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802d05:	55                   	push   %rbp
  802d06:	48 89 e5             	mov    %rsp,%rbp
  802d09:	48 83 ec 40          	sub    $0x40,%rsp
  802d0d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d10:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d14:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d18:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d1c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d1f:	48 89 d6             	mov    %rdx,%rsi
  802d22:	89 c7                	mov    %eax,%edi
  802d24:	48 b8 89 27 80 00 00 	movabs $0x802789,%rax
  802d2b:	00 00 00 
  802d2e:	ff d0                	callq  *%rax
  802d30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d37:	78 24                	js     802d5d <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3d:	8b 00                	mov    (%rax),%eax
  802d3f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d43:	48 89 d6             	mov    %rdx,%rsi
  802d46:	89 c7                	mov    %eax,%edi
  802d48:	48 b8 e2 28 80 00 00 	movabs $0x8028e2,%rax
  802d4f:	00 00 00 
  802d52:	ff d0                	callq  *%rax
  802d54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5b:	79 05                	jns    802d62 <write+0x5d>
		return r;
  802d5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d60:	eb 75                	jmp    802dd7 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d66:	8b 40 08             	mov    0x8(%rax),%eax
  802d69:	83 e0 03             	and    $0x3,%eax
  802d6c:	85 c0                	test   %eax,%eax
  802d6e:	75 3a                	jne    802daa <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802d70:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802d77:	00 00 00 
  802d7a:	48 8b 00             	mov    (%rax),%rax
  802d7d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d83:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d86:	89 c6                	mov    %eax,%esi
  802d88:	48 bf cb 44 80 00 00 	movabs $0x8044cb,%rdi
  802d8f:	00 00 00 
  802d92:	b8 00 00 00 00       	mov    $0x0,%eax
  802d97:	48 b9 79 06 80 00 00 	movabs $0x800679,%rcx
  802d9e:	00 00 00 
  802da1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802da3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802da8:	eb 2d                	jmp    802dd7 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802daa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dae:	48 8b 40 18          	mov    0x18(%rax),%rax
  802db2:	48 85 c0             	test   %rax,%rax
  802db5:	75 07                	jne    802dbe <write+0xb9>
		return -E_NOT_SUPP;
  802db7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dbc:	eb 19                	jmp    802dd7 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802dbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc2:	48 8b 40 18          	mov    0x18(%rax),%rax
  802dc6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802dca:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802dce:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802dd2:	48 89 cf             	mov    %rcx,%rdi
  802dd5:	ff d0                	callq  *%rax
}
  802dd7:	c9                   	leaveq 
  802dd8:	c3                   	retq   

0000000000802dd9 <seek>:

int
seek(int fdnum, off_t offset)
{
  802dd9:	55                   	push   %rbp
  802dda:	48 89 e5             	mov    %rsp,%rbp
  802ddd:	48 83 ec 18          	sub    $0x18,%rsp
  802de1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802de4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802de7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802deb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dee:	48 89 d6             	mov    %rdx,%rsi
  802df1:	89 c7                	mov    %eax,%edi
  802df3:	48 b8 89 27 80 00 00 	movabs $0x802789,%rax
  802dfa:	00 00 00 
  802dfd:	ff d0                	callq  *%rax
  802dff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e06:	79 05                	jns    802e0d <seek+0x34>
		return r;
  802e08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e0b:	eb 0f                	jmp    802e1c <seek+0x43>
	fd->fd_offset = offset;
  802e0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e11:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e14:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e1c:	c9                   	leaveq 
  802e1d:	c3                   	retq   

0000000000802e1e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802e1e:	55                   	push   %rbp
  802e1f:	48 89 e5             	mov    %rsp,%rbp
  802e22:	48 83 ec 30          	sub    $0x30,%rsp
  802e26:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e29:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e2c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e30:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e33:	48 89 d6             	mov    %rdx,%rsi
  802e36:	89 c7                	mov    %eax,%edi
  802e38:	48 b8 89 27 80 00 00 	movabs $0x802789,%rax
  802e3f:	00 00 00 
  802e42:	ff d0                	callq  *%rax
  802e44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e4b:	78 24                	js     802e71 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e51:	8b 00                	mov    (%rax),%eax
  802e53:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e57:	48 89 d6             	mov    %rdx,%rsi
  802e5a:	89 c7                	mov    %eax,%edi
  802e5c:	48 b8 e2 28 80 00 00 	movabs $0x8028e2,%rax
  802e63:	00 00 00 
  802e66:	ff d0                	callq  *%rax
  802e68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e6f:	79 05                	jns    802e76 <ftruncate+0x58>
		return r;
  802e71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e74:	eb 72                	jmp    802ee8 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e7a:	8b 40 08             	mov    0x8(%rax),%eax
  802e7d:	83 e0 03             	and    $0x3,%eax
  802e80:	85 c0                	test   %eax,%eax
  802e82:	75 3a                	jne    802ebe <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802e84:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802e8b:	00 00 00 
  802e8e:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802e91:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e97:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e9a:	89 c6                	mov    %eax,%esi
  802e9c:	48 bf e8 44 80 00 00 	movabs $0x8044e8,%rdi
  802ea3:	00 00 00 
  802ea6:	b8 00 00 00 00       	mov    $0x0,%eax
  802eab:	48 b9 79 06 80 00 00 	movabs $0x800679,%rcx
  802eb2:	00 00 00 
  802eb5:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802eb7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ebc:	eb 2a                	jmp    802ee8 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802ebe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec2:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ec6:	48 85 c0             	test   %rax,%rax
  802ec9:	75 07                	jne    802ed2 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802ecb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ed0:	eb 16                	jmp    802ee8 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802ed2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed6:	48 8b 40 30          	mov    0x30(%rax),%rax
  802eda:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ede:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802ee1:	89 ce                	mov    %ecx,%esi
  802ee3:	48 89 d7             	mov    %rdx,%rdi
  802ee6:	ff d0                	callq  *%rax
}
  802ee8:	c9                   	leaveq 
  802ee9:	c3                   	retq   

0000000000802eea <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802eea:	55                   	push   %rbp
  802eeb:	48 89 e5             	mov    %rsp,%rbp
  802eee:	48 83 ec 30          	sub    $0x30,%rsp
  802ef2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ef5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ef9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802efd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f00:	48 89 d6             	mov    %rdx,%rsi
  802f03:	89 c7                	mov    %eax,%edi
  802f05:	48 b8 89 27 80 00 00 	movabs $0x802789,%rax
  802f0c:	00 00 00 
  802f0f:	ff d0                	callq  *%rax
  802f11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f18:	78 24                	js     802f3e <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1e:	8b 00                	mov    (%rax),%eax
  802f20:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f24:	48 89 d6             	mov    %rdx,%rsi
  802f27:	89 c7                	mov    %eax,%edi
  802f29:	48 b8 e2 28 80 00 00 	movabs $0x8028e2,%rax
  802f30:	00 00 00 
  802f33:	ff d0                	callq  *%rax
  802f35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3c:	79 05                	jns    802f43 <fstat+0x59>
		return r;
  802f3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f41:	eb 5e                	jmp    802fa1 <fstat+0xb7>
	if (!dev->dev_stat)
  802f43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f47:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f4b:	48 85 c0             	test   %rax,%rax
  802f4e:	75 07                	jne    802f57 <fstat+0x6d>
		return -E_NOT_SUPP;
  802f50:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f55:	eb 4a                	jmp    802fa1 <fstat+0xb7>
	stat->st_name[0] = 0;
  802f57:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f5b:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802f5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f62:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802f69:	00 00 00 
	stat->st_isdir = 0;
  802f6c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f70:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f77:	00 00 00 
	stat->st_dev = dev;
  802f7a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f7e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f82:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802f89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f8d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f91:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f95:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802f99:	48 89 ce             	mov    %rcx,%rsi
  802f9c:	48 89 d7             	mov    %rdx,%rdi
  802f9f:	ff d0                	callq  *%rax
}
  802fa1:	c9                   	leaveq 
  802fa2:	c3                   	retq   

0000000000802fa3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802fa3:	55                   	push   %rbp
  802fa4:	48 89 e5             	mov    %rsp,%rbp
  802fa7:	48 83 ec 20          	sub    $0x20,%rsp
  802fab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802faf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802fb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb7:	be 00 00 00 00       	mov    $0x0,%esi
  802fbc:	48 89 c7             	mov    %rax,%rdi
  802fbf:	48 b8 91 30 80 00 00 	movabs $0x803091,%rax
  802fc6:	00 00 00 
  802fc9:	ff d0                	callq  *%rax
  802fcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd2:	79 05                	jns    802fd9 <stat+0x36>
		return fd;
  802fd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd7:	eb 2f                	jmp    803008 <stat+0x65>
	r = fstat(fd, stat);
  802fd9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802fdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe0:	48 89 d6             	mov    %rdx,%rsi
  802fe3:	89 c7                	mov    %eax,%edi
  802fe5:	48 b8 ea 2e 80 00 00 	movabs $0x802eea,%rax
  802fec:	00 00 00 
  802fef:	ff d0                	callq  *%rax
  802ff1:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ff4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff7:	89 c7                	mov    %eax,%edi
  802ff9:	48 b8 99 29 80 00 00 	movabs $0x802999,%rax
  803000:	00 00 00 
  803003:	ff d0                	callq  *%rax
	return r;
  803005:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803008:	c9                   	leaveq 
  803009:	c3                   	retq   

000000000080300a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80300a:	55                   	push   %rbp
  80300b:	48 89 e5             	mov    %rsp,%rbp
  80300e:	48 83 ec 10          	sub    $0x10,%rsp
  803012:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803015:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803019:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803020:	00 00 00 
  803023:	8b 00                	mov    (%rax),%eax
  803025:	85 c0                	test   %eax,%eax
  803027:	75 1d                	jne    803046 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803029:	bf 01 00 00 00       	mov    $0x1,%edi
  80302e:	48 b8 21 26 80 00 00 	movabs $0x802621,%rax
  803035:	00 00 00 
  803038:	ff d0                	callq  *%rax
  80303a:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803041:	00 00 00 
  803044:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803046:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80304d:	00 00 00 
  803050:	8b 00                	mov    (%rax),%eax
  803052:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803055:	b9 07 00 00 00       	mov    $0x7,%ecx
  80305a:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  803061:	00 00 00 
  803064:	89 c7                	mov    %eax,%edi
  803066:	48 b8 89 25 80 00 00 	movabs $0x802589,%rax
  80306d:	00 00 00 
  803070:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803072:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803076:	ba 00 00 00 00       	mov    $0x0,%edx
  80307b:	48 89 c6             	mov    %rax,%rsi
  80307e:	bf 00 00 00 00       	mov    $0x0,%edi
  803083:	48 b8 c0 24 80 00 00 	movabs $0x8024c0,%rax
  80308a:	00 00 00 
  80308d:	ff d0                	callq  *%rax
}
  80308f:	c9                   	leaveq 
  803090:	c3                   	retq   

0000000000803091 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803091:	55                   	push   %rbp
  803092:	48 89 e5             	mov    %rsp,%rbp
  803095:	48 83 ec 20          	sub    $0x20,%rsp
  803099:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80309d:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  8030a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030a4:	48 89 c7             	mov    %rax,%rdi
  8030a7:	48 b8 b5 13 80 00 00 	movabs $0x8013b5,%rax
  8030ae:	00 00 00 
  8030b1:	ff d0                	callq  *%rax
  8030b3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8030b8:	7e 0a                	jle    8030c4 <open+0x33>
		return -E_BAD_PATH;
  8030ba:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030bf:	e9 a5 00 00 00       	jmpq   803169 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8030c4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8030c8:	48 89 c7             	mov    %rax,%rdi
  8030cb:	48 b8 f1 26 80 00 00 	movabs $0x8026f1,%rax
  8030d2:	00 00 00 
  8030d5:	ff d0                	callq  *%rax
  8030d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030de:	79 08                	jns    8030e8 <open+0x57>
		return r;
  8030e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e3:	e9 81 00 00 00       	jmpq   803169 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8030e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ec:	48 89 c6             	mov    %rax,%rsi
  8030ef:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8030f6:	00 00 00 
  8030f9:	48 b8 21 14 80 00 00 	movabs $0x801421,%rax
  803100:	00 00 00 
  803103:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  803105:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80310c:	00 00 00 
  80310f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803112:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803118:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80311c:	48 89 c6             	mov    %rax,%rsi
  80311f:	bf 01 00 00 00       	mov    $0x1,%edi
  803124:	48 b8 0a 30 80 00 00 	movabs $0x80300a,%rax
  80312b:	00 00 00 
  80312e:	ff d0                	callq  *%rax
  803130:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803133:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803137:	79 1d                	jns    803156 <open+0xc5>
		fd_close(fd, 0);
  803139:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80313d:	be 00 00 00 00       	mov    $0x0,%esi
  803142:	48 89 c7             	mov    %rax,%rdi
  803145:	48 b8 19 28 80 00 00 	movabs $0x802819,%rax
  80314c:	00 00 00 
  80314f:	ff d0                	callq  *%rax
		return r;
  803151:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803154:	eb 13                	jmp    803169 <open+0xd8>
	}

	return fd2num(fd);
  803156:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80315a:	48 89 c7             	mov    %rax,%rdi
  80315d:	48 b8 a3 26 80 00 00 	movabs $0x8026a3,%rax
  803164:	00 00 00 
  803167:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  803169:	c9                   	leaveq 
  80316a:	c3                   	retq   

000000000080316b <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80316b:	55                   	push   %rbp
  80316c:	48 89 e5             	mov    %rsp,%rbp
  80316f:	48 83 ec 10          	sub    $0x10,%rsp
  803173:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803177:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80317b:	8b 50 0c             	mov    0xc(%rax),%edx
  80317e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803185:	00 00 00 
  803188:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80318a:	be 00 00 00 00       	mov    $0x0,%esi
  80318f:	bf 06 00 00 00       	mov    $0x6,%edi
  803194:	48 b8 0a 30 80 00 00 	movabs $0x80300a,%rax
  80319b:	00 00 00 
  80319e:	ff d0                	callq  *%rax
}
  8031a0:	c9                   	leaveq 
  8031a1:	c3                   	retq   

00000000008031a2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8031a2:	55                   	push   %rbp
  8031a3:	48 89 e5             	mov    %rsp,%rbp
  8031a6:	48 83 ec 30          	sub    $0x30,%rsp
  8031aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031b2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8031b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ba:	8b 50 0c             	mov    0xc(%rax),%edx
  8031bd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031c4:	00 00 00 
  8031c7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8031c9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031d0:	00 00 00 
  8031d3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031d7:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8031db:	be 00 00 00 00       	mov    $0x0,%esi
  8031e0:	bf 03 00 00 00       	mov    $0x3,%edi
  8031e5:	48 b8 0a 30 80 00 00 	movabs $0x80300a,%rax
  8031ec:	00 00 00 
  8031ef:	ff d0                	callq  *%rax
  8031f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031f8:	79 05                	jns    8031ff <devfile_read+0x5d>
		return r;
  8031fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031fd:	eb 26                	jmp    803225 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8031ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803202:	48 63 d0             	movslq %eax,%rdx
  803205:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803209:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803210:	00 00 00 
  803213:	48 89 c7             	mov    %rax,%rdi
  803216:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  80321d:	00 00 00 
  803220:	ff d0                	callq  *%rax

	return r;
  803222:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803225:	c9                   	leaveq 
  803226:	c3                   	retq   

0000000000803227 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803227:	55                   	push   %rbp
  803228:	48 89 e5             	mov    %rsp,%rbp
  80322b:	48 83 ec 30          	sub    $0x30,%rsp
  80322f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803233:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803237:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  80323b:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803242:	00 
  803243:	76 08                	jbe    80324d <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  803245:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80324c:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80324d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803251:	8b 50 0c             	mov    0xc(%rax),%edx
  803254:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80325b:	00 00 00 
  80325e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803260:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803267:	00 00 00 
  80326a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80326e:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  803272:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803276:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80327a:	48 89 c6             	mov    %rax,%rsi
  80327d:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803284:	00 00 00 
  803287:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  80328e:	00 00 00 
  803291:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803293:	be 00 00 00 00       	mov    $0x0,%esi
  803298:	bf 04 00 00 00       	mov    $0x4,%edi
  80329d:	48 b8 0a 30 80 00 00 	movabs $0x80300a,%rax
  8032a4:	00 00 00 
  8032a7:	ff d0                	callq  *%rax
  8032a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b0:	79 05                	jns    8032b7 <devfile_write+0x90>
		return r;
  8032b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b5:	eb 03                	jmp    8032ba <devfile_write+0x93>

	return r;
  8032b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8032ba:	c9                   	leaveq 
  8032bb:	c3                   	retq   

00000000008032bc <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8032bc:	55                   	push   %rbp
  8032bd:	48 89 e5             	mov    %rsp,%rbp
  8032c0:	48 83 ec 20          	sub    $0x20,%rsp
  8032c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8032cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032d0:	8b 50 0c             	mov    0xc(%rax),%edx
  8032d3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032da:	00 00 00 
  8032dd:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8032df:	be 00 00 00 00       	mov    $0x0,%esi
  8032e4:	bf 05 00 00 00       	mov    $0x5,%edi
  8032e9:	48 b8 0a 30 80 00 00 	movabs $0x80300a,%rax
  8032f0:	00 00 00 
  8032f3:	ff d0                	callq  *%rax
  8032f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032fc:	79 05                	jns    803303 <devfile_stat+0x47>
		return r;
  8032fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803301:	eb 56                	jmp    803359 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803303:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803307:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80330e:	00 00 00 
  803311:	48 89 c7             	mov    %rax,%rdi
  803314:	48 b8 21 14 80 00 00 	movabs $0x801421,%rax
  80331b:	00 00 00 
  80331e:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803320:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803327:	00 00 00 
  80332a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803330:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803334:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80333a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803341:	00 00 00 
  803344:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80334a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80334e:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803354:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803359:	c9                   	leaveq 
  80335a:	c3                   	retq   

000000000080335b <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80335b:	55                   	push   %rbp
  80335c:	48 89 e5             	mov    %rsp,%rbp
  80335f:	48 83 ec 10          	sub    $0x10,%rsp
  803363:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803367:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80336a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80336e:	8b 50 0c             	mov    0xc(%rax),%edx
  803371:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803378:	00 00 00 
  80337b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80337d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803384:	00 00 00 
  803387:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80338a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80338d:	be 00 00 00 00       	mov    $0x0,%esi
  803392:	bf 02 00 00 00       	mov    $0x2,%edi
  803397:	48 b8 0a 30 80 00 00 	movabs $0x80300a,%rax
  80339e:	00 00 00 
  8033a1:	ff d0                	callq  *%rax
}
  8033a3:	c9                   	leaveq 
  8033a4:	c3                   	retq   

00000000008033a5 <remove>:

// Delete a file
int
remove(const char *path)
{
  8033a5:	55                   	push   %rbp
  8033a6:	48 89 e5             	mov    %rsp,%rbp
  8033a9:	48 83 ec 10          	sub    $0x10,%rsp
  8033ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8033b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033b5:	48 89 c7             	mov    %rax,%rdi
  8033b8:	48 b8 b5 13 80 00 00 	movabs $0x8013b5,%rax
  8033bf:	00 00 00 
  8033c2:	ff d0                	callq  *%rax
  8033c4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8033c9:	7e 07                	jle    8033d2 <remove+0x2d>
		return -E_BAD_PATH;
  8033cb:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8033d0:	eb 33                	jmp    803405 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8033d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033d6:	48 89 c6             	mov    %rax,%rsi
  8033d9:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8033e0:	00 00 00 
  8033e3:	48 b8 21 14 80 00 00 	movabs $0x801421,%rax
  8033ea:	00 00 00 
  8033ed:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8033ef:	be 00 00 00 00       	mov    $0x0,%esi
  8033f4:	bf 07 00 00 00       	mov    $0x7,%edi
  8033f9:	48 b8 0a 30 80 00 00 	movabs $0x80300a,%rax
  803400:	00 00 00 
  803403:	ff d0                	callq  *%rax
}
  803405:	c9                   	leaveq 
  803406:	c3                   	retq   

0000000000803407 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803407:	55                   	push   %rbp
  803408:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80340b:	be 00 00 00 00       	mov    $0x0,%esi
  803410:	bf 08 00 00 00       	mov    $0x8,%edi
  803415:	48 b8 0a 30 80 00 00 	movabs $0x80300a,%rax
  80341c:	00 00 00 
  80341f:	ff d0                	callq  *%rax
}
  803421:	5d                   	pop    %rbp
  803422:	c3                   	retq   

0000000000803423 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803423:	55                   	push   %rbp
  803424:	48 89 e5             	mov    %rsp,%rbp
  803427:	48 83 ec 18          	sub    $0x18,%rsp
  80342b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80342f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803433:	48 c1 e8 15          	shr    $0x15,%rax
  803437:	48 89 c2             	mov    %rax,%rdx
  80343a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803441:	01 00 00 
  803444:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803448:	83 e0 01             	and    $0x1,%eax
  80344b:	48 85 c0             	test   %rax,%rax
  80344e:	75 07                	jne    803457 <pageref+0x34>
		return 0;
  803450:	b8 00 00 00 00       	mov    $0x0,%eax
  803455:	eb 53                	jmp    8034aa <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803457:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80345b:	48 c1 e8 0c          	shr    $0xc,%rax
  80345f:	48 89 c2             	mov    %rax,%rdx
  803462:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803469:	01 00 00 
  80346c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803470:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803474:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803478:	83 e0 01             	and    $0x1,%eax
  80347b:	48 85 c0             	test   %rax,%rax
  80347e:	75 07                	jne    803487 <pageref+0x64>
		return 0;
  803480:	b8 00 00 00 00       	mov    $0x0,%eax
  803485:	eb 23                	jmp    8034aa <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803487:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80348b:	48 c1 e8 0c          	shr    $0xc,%rax
  80348f:	48 89 c2             	mov    %rax,%rdx
  803492:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803499:	00 00 00 
  80349c:	48 c1 e2 04          	shl    $0x4,%rdx
  8034a0:	48 01 d0             	add    %rdx,%rax
  8034a3:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8034a7:	0f b7 c0             	movzwl %ax,%eax
}
  8034aa:	c9                   	leaveq 
  8034ab:	c3                   	retq   

00000000008034ac <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8034ac:	55                   	push   %rbp
  8034ad:	48 89 e5             	mov    %rsp,%rbp
  8034b0:	53                   	push   %rbx
  8034b1:	48 83 ec 38          	sub    $0x38,%rsp
  8034b5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8034b9:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8034bd:	48 89 c7             	mov    %rax,%rdi
  8034c0:	48 b8 f1 26 80 00 00 	movabs $0x8026f1,%rax
  8034c7:	00 00 00 
  8034ca:	ff d0                	callq  *%rax
  8034cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034d3:	0f 88 bf 01 00 00    	js     803698 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034dd:	ba 07 04 00 00       	mov    $0x407,%edx
  8034e2:	48 89 c6             	mov    %rax,%rsi
  8034e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8034ea:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  8034f1:	00 00 00 
  8034f4:	ff d0                	callq  *%rax
  8034f6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034fd:	0f 88 95 01 00 00    	js     803698 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803503:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803507:	48 89 c7             	mov    %rax,%rdi
  80350a:	48 b8 f1 26 80 00 00 	movabs $0x8026f1,%rax
  803511:	00 00 00 
  803514:	ff d0                	callq  *%rax
  803516:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803519:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80351d:	0f 88 5d 01 00 00    	js     803680 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803523:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803527:	ba 07 04 00 00       	mov    $0x407,%edx
  80352c:	48 89 c6             	mov    %rax,%rsi
  80352f:	bf 00 00 00 00       	mov    $0x0,%edi
  803534:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  80353b:	00 00 00 
  80353e:	ff d0                	callq  *%rax
  803540:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803543:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803547:	0f 88 33 01 00 00    	js     803680 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80354d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803551:	48 89 c7             	mov    %rax,%rdi
  803554:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  80355b:	00 00 00 
  80355e:	ff d0                	callq  *%rax
  803560:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803564:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803568:	ba 07 04 00 00       	mov    $0x407,%edx
  80356d:	48 89 c6             	mov    %rax,%rsi
  803570:	bf 00 00 00 00       	mov    $0x0,%edi
  803575:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  80357c:	00 00 00 
  80357f:	ff d0                	callq  *%rax
  803581:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803584:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803588:	79 05                	jns    80358f <pipe+0xe3>
		goto err2;
  80358a:	e9 d9 00 00 00       	jmpq   803668 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80358f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803593:	48 89 c7             	mov    %rax,%rdi
  803596:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  80359d:	00 00 00 
  8035a0:	ff d0                	callq  *%rax
  8035a2:	48 89 c2             	mov    %rax,%rdx
  8035a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035a9:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8035af:	48 89 d1             	mov    %rdx,%rcx
  8035b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8035b7:	48 89 c6             	mov    %rax,%rsi
  8035ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8035bf:	48 b8 a0 1d 80 00 00 	movabs $0x801da0,%rax
  8035c6:	00 00 00 
  8035c9:	ff d0                	callq  *%rax
  8035cb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035d2:	79 1b                	jns    8035ef <pipe+0x143>
		goto err3;
  8035d4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8035d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035d9:	48 89 c6             	mov    %rax,%rsi
  8035dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e1:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  8035e8:	00 00 00 
  8035eb:	ff d0                	callq  *%rax
  8035ed:	eb 79                	jmp    803668 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8035ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035f3:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8035fa:	00 00 00 
  8035fd:	8b 12                	mov    (%rdx),%edx
  8035ff:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803601:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803605:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80360c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803610:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803617:	00 00 00 
  80361a:	8b 12                	mov    (%rdx),%edx
  80361c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80361e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803622:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803629:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80362d:	48 89 c7             	mov    %rax,%rdi
  803630:	48 b8 a3 26 80 00 00 	movabs $0x8026a3,%rax
  803637:	00 00 00 
  80363a:	ff d0                	callq  *%rax
  80363c:	89 c2                	mov    %eax,%edx
  80363e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803642:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803644:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803648:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80364c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803650:	48 89 c7             	mov    %rax,%rdi
  803653:	48 b8 a3 26 80 00 00 	movabs $0x8026a3,%rax
  80365a:	00 00 00 
  80365d:	ff d0                	callq  *%rax
  80365f:	89 03                	mov    %eax,(%rbx)
	return 0;
  803661:	b8 00 00 00 00       	mov    $0x0,%eax
  803666:	eb 33                	jmp    80369b <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803668:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80366c:	48 89 c6             	mov    %rax,%rsi
  80366f:	bf 00 00 00 00       	mov    $0x0,%edi
  803674:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  80367b:	00 00 00 
  80367e:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803680:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803684:	48 89 c6             	mov    %rax,%rsi
  803687:	bf 00 00 00 00       	mov    $0x0,%edi
  80368c:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  803693:	00 00 00 
  803696:	ff d0                	callq  *%rax
    err:
	return r;
  803698:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80369b:	48 83 c4 38          	add    $0x38,%rsp
  80369f:	5b                   	pop    %rbx
  8036a0:	5d                   	pop    %rbp
  8036a1:	c3                   	retq   

00000000008036a2 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8036a2:	55                   	push   %rbp
  8036a3:	48 89 e5             	mov    %rsp,%rbp
  8036a6:	53                   	push   %rbx
  8036a7:	48 83 ec 28          	sub    $0x28,%rsp
  8036ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8036b3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036ba:	00 00 00 
  8036bd:	48 8b 00             	mov    (%rax),%rax
  8036c0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036c6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8036c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036cd:	48 89 c7             	mov    %rax,%rdi
  8036d0:	48 b8 23 34 80 00 00 	movabs $0x803423,%rax
  8036d7:	00 00 00 
  8036da:	ff d0                	callq  *%rax
  8036dc:	89 c3                	mov    %eax,%ebx
  8036de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036e2:	48 89 c7             	mov    %rax,%rdi
  8036e5:	48 b8 23 34 80 00 00 	movabs $0x803423,%rax
  8036ec:	00 00 00 
  8036ef:	ff d0                	callq  *%rax
  8036f1:	39 c3                	cmp    %eax,%ebx
  8036f3:	0f 94 c0             	sete   %al
  8036f6:	0f b6 c0             	movzbl %al,%eax
  8036f9:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8036fc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803703:	00 00 00 
  803706:	48 8b 00             	mov    (%rax),%rax
  803709:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80370f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803712:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803715:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803718:	75 05                	jne    80371f <_pipeisclosed+0x7d>
			return ret;
  80371a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80371d:	eb 4f                	jmp    80376e <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80371f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803722:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803725:	74 42                	je     803769 <_pipeisclosed+0xc7>
  803727:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80372b:	75 3c                	jne    803769 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80372d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803734:	00 00 00 
  803737:	48 8b 00             	mov    (%rax),%rax
  80373a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803740:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803743:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803746:	89 c6                	mov    %eax,%esi
  803748:	48 bf 13 45 80 00 00 	movabs $0x804513,%rdi
  80374f:	00 00 00 
  803752:	b8 00 00 00 00       	mov    $0x0,%eax
  803757:	49 b8 79 06 80 00 00 	movabs $0x800679,%r8
  80375e:	00 00 00 
  803761:	41 ff d0             	callq  *%r8
	}
  803764:	e9 4a ff ff ff       	jmpq   8036b3 <_pipeisclosed+0x11>
  803769:	e9 45 ff ff ff       	jmpq   8036b3 <_pipeisclosed+0x11>
}
  80376e:	48 83 c4 28          	add    $0x28,%rsp
  803772:	5b                   	pop    %rbx
  803773:	5d                   	pop    %rbp
  803774:	c3                   	retq   

0000000000803775 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803775:	55                   	push   %rbp
  803776:	48 89 e5             	mov    %rsp,%rbp
  803779:	48 83 ec 30          	sub    $0x30,%rsp
  80377d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803780:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803784:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803787:	48 89 d6             	mov    %rdx,%rsi
  80378a:	89 c7                	mov    %eax,%edi
  80378c:	48 b8 89 27 80 00 00 	movabs $0x802789,%rax
  803793:	00 00 00 
  803796:	ff d0                	callq  *%rax
  803798:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80379b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80379f:	79 05                	jns    8037a6 <pipeisclosed+0x31>
		return r;
  8037a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a4:	eb 31                	jmp    8037d7 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8037a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037aa:	48 89 c7             	mov    %rax,%rdi
  8037ad:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  8037b4:	00 00 00 
  8037b7:	ff d0                	callq  *%rax
  8037b9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8037bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037c5:	48 89 d6             	mov    %rdx,%rsi
  8037c8:	48 89 c7             	mov    %rax,%rdi
  8037cb:	48 b8 a2 36 80 00 00 	movabs $0x8036a2,%rax
  8037d2:	00 00 00 
  8037d5:	ff d0                	callq  *%rax
}
  8037d7:	c9                   	leaveq 
  8037d8:	c3                   	retq   

00000000008037d9 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8037d9:	55                   	push   %rbp
  8037da:	48 89 e5             	mov    %rsp,%rbp
  8037dd:	48 83 ec 40          	sub    $0x40,%rsp
  8037e1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037e5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037e9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8037ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037f1:	48 89 c7             	mov    %rax,%rdi
  8037f4:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  8037fb:	00 00 00 
  8037fe:	ff d0                	callq  *%rax
  803800:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803804:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803808:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80380c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803813:	00 
  803814:	e9 92 00 00 00       	jmpq   8038ab <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803819:	eb 41                	jmp    80385c <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80381b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803820:	74 09                	je     80382b <devpipe_read+0x52>
				return i;
  803822:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803826:	e9 92 00 00 00       	jmpq   8038bd <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80382b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80382f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803833:	48 89 d6             	mov    %rdx,%rsi
  803836:	48 89 c7             	mov    %rax,%rdi
  803839:	48 b8 a2 36 80 00 00 	movabs $0x8036a2,%rax
  803840:	00 00 00 
  803843:	ff d0                	callq  *%rax
  803845:	85 c0                	test   %eax,%eax
  803847:	74 07                	je     803850 <devpipe_read+0x77>
				return 0;
  803849:	b8 00 00 00 00       	mov    $0x0,%eax
  80384e:	eb 6d                	jmp    8038bd <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803850:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  803857:	00 00 00 
  80385a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80385c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803860:	8b 10                	mov    (%rax),%edx
  803862:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803866:	8b 40 04             	mov    0x4(%rax),%eax
  803869:	39 c2                	cmp    %eax,%edx
  80386b:	74 ae                	je     80381b <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80386d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803871:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803875:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803879:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387d:	8b 00                	mov    (%rax),%eax
  80387f:	99                   	cltd   
  803880:	c1 ea 1b             	shr    $0x1b,%edx
  803883:	01 d0                	add    %edx,%eax
  803885:	83 e0 1f             	and    $0x1f,%eax
  803888:	29 d0                	sub    %edx,%eax
  80388a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80388e:	48 98                	cltq   
  803890:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803895:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803897:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389b:	8b 00                	mov    (%rax),%eax
  80389d:	8d 50 01             	lea    0x1(%rax),%edx
  8038a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a4:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038a6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038af:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038b3:	0f 82 60 ff ff ff    	jb     803819 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8038b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038bd:	c9                   	leaveq 
  8038be:	c3                   	retq   

00000000008038bf <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038bf:	55                   	push   %rbp
  8038c0:	48 89 e5             	mov    %rsp,%rbp
  8038c3:	48 83 ec 40          	sub    $0x40,%rsp
  8038c7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038cb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038cf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8038d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038d7:	48 89 c7             	mov    %rax,%rdi
  8038da:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  8038e1:	00 00 00 
  8038e4:	ff d0                	callq  *%rax
  8038e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038ee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038f2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8038f9:	00 
  8038fa:	e9 8e 00 00 00       	jmpq   80398d <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8038ff:	eb 31                	jmp    803932 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803901:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803905:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803909:	48 89 d6             	mov    %rdx,%rsi
  80390c:	48 89 c7             	mov    %rax,%rdi
  80390f:	48 b8 a2 36 80 00 00 	movabs $0x8036a2,%rax
  803916:	00 00 00 
  803919:	ff d0                	callq  *%rax
  80391b:	85 c0                	test   %eax,%eax
  80391d:	74 07                	je     803926 <devpipe_write+0x67>
				return 0;
  80391f:	b8 00 00 00 00       	mov    $0x0,%eax
  803924:	eb 79                	jmp    80399f <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803926:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  80392d:	00 00 00 
  803930:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803932:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803936:	8b 40 04             	mov    0x4(%rax),%eax
  803939:	48 63 d0             	movslq %eax,%rdx
  80393c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803940:	8b 00                	mov    (%rax),%eax
  803942:	48 98                	cltq   
  803944:	48 83 c0 20          	add    $0x20,%rax
  803948:	48 39 c2             	cmp    %rax,%rdx
  80394b:	73 b4                	jae    803901 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80394d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803951:	8b 40 04             	mov    0x4(%rax),%eax
  803954:	99                   	cltd   
  803955:	c1 ea 1b             	shr    $0x1b,%edx
  803958:	01 d0                	add    %edx,%eax
  80395a:	83 e0 1f             	and    $0x1f,%eax
  80395d:	29 d0                	sub    %edx,%eax
  80395f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803963:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803967:	48 01 ca             	add    %rcx,%rdx
  80396a:	0f b6 0a             	movzbl (%rdx),%ecx
  80396d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803971:	48 98                	cltq   
  803973:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803977:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397b:	8b 40 04             	mov    0x4(%rax),%eax
  80397e:	8d 50 01             	lea    0x1(%rax),%edx
  803981:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803985:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803988:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80398d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803991:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803995:	0f 82 64 ff ff ff    	jb     8038ff <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80399b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80399f:	c9                   	leaveq 
  8039a0:	c3                   	retq   

00000000008039a1 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8039a1:	55                   	push   %rbp
  8039a2:	48 89 e5             	mov    %rsp,%rbp
  8039a5:	48 83 ec 20          	sub    $0x20,%rsp
  8039a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8039b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039b5:	48 89 c7             	mov    %rax,%rdi
  8039b8:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  8039bf:	00 00 00 
  8039c2:	ff d0                	callq  *%rax
  8039c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8039c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039cc:	48 be 26 45 80 00 00 	movabs $0x804526,%rsi
  8039d3:	00 00 00 
  8039d6:	48 89 c7             	mov    %rax,%rdi
  8039d9:	48 b8 21 14 80 00 00 	movabs $0x801421,%rax
  8039e0:	00 00 00 
  8039e3:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8039e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039e9:	8b 50 04             	mov    0x4(%rax),%edx
  8039ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039f0:	8b 00                	mov    (%rax),%eax
  8039f2:	29 c2                	sub    %eax,%edx
  8039f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039f8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8039fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a02:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a09:	00 00 00 
	stat->st_dev = &devpipe;
  803a0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a10:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803a17:	00 00 00 
  803a1a:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a26:	c9                   	leaveq 
  803a27:	c3                   	retq   

0000000000803a28 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a28:	55                   	push   %rbp
  803a29:	48 89 e5             	mov    %rsp,%rbp
  803a2c:	48 83 ec 10          	sub    $0x10,%rsp
  803a30:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803a34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a38:	48 89 c6             	mov    %rax,%rsi
  803a3b:	bf 00 00 00 00       	mov    $0x0,%edi
  803a40:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  803a47:	00 00 00 
  803a4a:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803a4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a50:	48 89 c7             	mov    %rax,%rdi
  803a53:	48 b8 c6 26 80 00 00 	movabs $0x8026c6,%rax
  803a5a:	00 00 00 
  803a5d:	ff d0                	callq  *%rax
  803a5f:	48 89 c6             	mov    %rax,%rsi
  803a62:	bf 00 00 00 00       	mov    $0x0,%edi
  803a67:	48 b8 fb 1d 80 00 00 	movabs $0x801dfb,%rax
  803a6e:	00 00 00 
  803a71:	ff d0                	callq  *%rax
}
  803a73:	c9                   	leaveq 
  803a74:	c3                   	retq   

0000000000803a75 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803a75:	55                   	push   %rbp
  803a76:	48 89 e5             	mov    %rsp,%rbp
  803a79:	48 83 ec 20          	sub    $0x20,%rsp
  803a7d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803a80:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a83:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803a86:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803a8a:	be 01 00 00 00       	mov    $0x1,%esi
  803a8f:	48 89 c7             	mov    %rax,%rdi
  803a92:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  803a99:	00 00 00 
  803a9c:	ff d0                	callq  *%rax
}
  803a9e:	c9                   	leaveq 
  803a9f:	c3                   	retq   

0000000000803aa0 <getchar>:

int
getchar(void)
{
  803aa0:	55                   	push   %rbp
  803aa1:	48 89 e5             	mov    %rsp,%rbp
  803aa4:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803aa8:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803aac:	ba 01 00 00 00       	mov    $0x1,%edx
  803ab1:	48 89 c6             	mov    %rax,%rsi
  803ab4:	bf 00 00 00 00       	mov    $0x0,%edi
  803ab9:	48 b8 bb 2b 80 00 00 	movabs $0x802bbb,%rax
  803ac0:	00 00 00 
  803ac3:	ff d0                	callq  *%rax
  803ac5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803ac8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803acc:	79 05                	jns    803ad3 <getchar+0x33>
		return r;
  803ace:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad1:	eb 14                	jmp    803ae7 <getchar+0x47>
	if (r < 1)
  803ad3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ad7:	7f 07                	jg     803ae0 <getchar+0x40>
		return -E_EOF;
  803ad9:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803ade:	eb 07                	jmp    803ae7 <getchar+0x47>
	return c;
  803ae0:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803ae4:	0f b6 c0             	movzbl %al,%eax
}
  803ae7:	c9                   	leaveq 
  803ae8:	c3                   	retq   

0000000000803ae9 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803ae9:	55                   	push   %rbp
  803aea:	48 89 e5             	mov    %rsp,%rbp
  803aed:	48 83 ec 20          	sub    $0x20,%rsp
  803af1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803af4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803af8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803afb:	48 89 d6             	mov    %rdx,%rsi
  803afe:	89 c7                	mov    %eax,%edi
  803b00:	48 b8 89 27 80 00 00 	movabs $0x802789,%rax
  803b07:	00 00 00 
  803b0a:	ff d0                	callq  *%rax
  803b0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b13:	79 05                	jns    803b1a <iscons+0x31>
		return r;
  803b15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b18:	eb 1a                	jmp    803b34 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803b1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b1e:	8b 10                	mov    (%rax),%edx
  803b20:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803b27:	00 00 00 
  803b2a:	8b 00                	mov    (%rax),%eax
  803b2c:	39 c2                	cmp    %eax,%edx
  803b2e:	0f 94 c0             	sete   %al
  803b31:	0f b6 c0             	movzbl %al,%eax
}
  803b34:	c9                   	leaveq 
  803b35:	c3                   	retq   

0000000000803b36 <opencons>:

int
opencons(void)
{
  803b36:	55                   	push   %rbp
  803b37:	48 89 e5             	mov    %rsp,%rbp
  803b3a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b3e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b42:	48 89 c7             	mov    %rax,%rdi
  803b45:	48 b8 f1 26 80 00 00 	movabs $0x8026f1,%rax
  803b4c:	00 00 00 
  803b4f:	ff d0                	callq  *%rax
  803b51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b58:	79 05                	jns    803b5f <opencons+0x29>
		return r;
  803b5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b5d:	eb 5b                	jmp    803bba <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b63:	ba 07 04 00 00       	mov    $0x407,%edx
  803b68:	48 89 c6             	mov    %rax,%rsi
  803b6b:	bf 00 00 00 00       	mov    $0x0,%edi
  803b70:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  803b77:	00 00 00 
  803b7a:	ff d0                	callq  *%rax
  803b7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b83:	79 05                	jns    803b8a <opencons+0x54>
		return r;
  803b85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b88:	eb 30                	jmp    803bba <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803b8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8e:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803b95:	00 00 00 
  803b98:	8b 12                	mov    (%rdx),%edx
  803b9a:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803b9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803ba7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bab:	48 89 c7             	mov    %rax,%rdi
  803bae:	48 b8 a3 26 80 00 00 	movabs $0x8026a3,%rax
  803bb5:	00 00 00 
  803bb8:	ff d0                	callq  *%rax
}
  803bba:	c9                   	leaveq 
  803bbb:	c3                   	retq   

0000000000803bbc <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803bbc:	55                   	push   %rbp
  803bbd:	48 89 e5             	mov    %rsp,%rbp
  803bc0:	48 83 ec 30          	sub    $0x30,%rsp
  803bc4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bc8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bcc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803bd0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803bd5:	75 07                	jne    803bde <devcons_read+0x22>
		return 0;
  803bd7:	b8 00 00 00 00       	mov    $0x0,%eax
  803bdc:	eb 4b                	jmp    803c29 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803bde:	eb 0c                	jmp    803bec <devcons_read+0x30>
		sys_yield();
  803be0:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  803be7:	00 00 00 
  803bea:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803bec:	48 b8 52 1c 80 00 00 	movabs $0x801c52,%rax
  803bf3:	00 00 00 
  803bf6:	ff d0                	callq  *%rax
  803bf8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bfb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bff:	74 df                	je     803be0 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803c01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c05:	79 05                	jns    803c0c <devcons_read+0x50>
		return c;
  803c07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c0a:	eb 1d                	jmp    803c29 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803c0c:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803c10:	75 07                	jne    803c19 <devcons_read+0x5d>
		return 0;
  803c12:	b8 00 00 00 00       	mov    $0x0,%eax
  803c17:	eb 10                	jmp    803c29 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803c19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c1c:	89 c2                	mov    %eax,%edx
  803c1e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c22:	88 10                	mov    %dl,(%rax)
	return 1;
  803c24:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c29:	c9                   	leaveq 
  803c2a:	c3                   	retq   

0000000000803c2b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c2b:	55                   	push   %rbp
  803c2c:	48 89 e5             	mov    %rsp,%rbp
  803c2f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c36:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c3d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c44:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c52:	eb 76                	jmp    803cca <devcons_write+0x9f>
		m = n - tot;
  803c54:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c5b:	89 c2                	mov    %eax,%edx
  803c5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c60:	29 c2                	sub    %eax,%edx
  803c62:	89 d0                	mov    %edx,%eax
  803c64:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c67:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c6a:	83 f8 7f             	cmp    $0x7f,%eax
  803c6d:	76 07                	jbe    803c76 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803c6f:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803c76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c79:	48 63 d0             	movslq %eax,%rdx
  803c7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c7f:	48 63 c8             	movslq %eax,%rcx
  803c82:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803c89:	48 01 c1             	add    %rax,%rcx
  803c8c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c93:	48 89 ce             	mov    %rcx,%rsi
  803c96:	48 89 c7             	mov    %rax,%rdi
  803c99:	48 b8 45 17 80 00 00 	movabs $0x801745,%rax
  803ca0:	00 00 00 
  803ca3:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803ca5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ca8:	48 63 d0             	movslq %eax,%rdx
  803cab:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803cb2:	48 89 d6             	mov    %rdx,%rsi
  803cb5:	48 89 c7             	mov    %rax,%rdi
  803cb8:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  803cbf:	00 00 00 
  803cc2:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803cc4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803cc7:	01 45 fc             	add    %eax,-0x4(%rbp)
  803cca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ccd:	48 98                	cltq   
  803ccf:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803cd6:	0f 82 78 ff ff ff    	jb     803c54 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803cdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803cdf:	c9                   	leaveq 
  803ce0:	c3                   	retq   

0000000000803ce1 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803ce1:	55                   	push   %rbp
  803ce2:	48 89 e5             	mov    %rsp,%rbp
  803ce5:	48 83 ec 08          	sub    $0x8,%rsp
  803ce9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ced:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cf2:	c9                   	leaveq 
  803cf3:	c3                   	retq   

0000000000803cf4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803cf4:	55                   	push   %rbp
  803cf5:	48 89 e5             	mov    %rsp,%rbp
  803cf8:	48 83 ec 10          	sub    $0x10,%rsp
  803cfc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803d04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d08:	48 be 32 45 80 00 00 	movabs $0x804532,%rsi
  803d0f:	00 00 00 
  803d12:	48 89 c7             	mov    %rax,%rdi
  803d15:	48 b8 21 14 80 00 00 	movabs $0x801421,%rax
  803d1c:	00 00 00 
  803d1f:	ff d0                	callq  *%rax
	return 0;
  803d21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d26:	c9                   	leaveq 
  803d27:	c3                   	retq   

0000000000803d28 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803d28:	55                   	push   %rbp
  803d29:	48 89 e5             	mov    %rsp,%rbp
  803d2c:	48 83 ec 10          	sub    $0x10,%rsp
  803d30:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803d34:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803d3b:	00 00 00 
  803d3e:	48 8b 00             	mov    (%rax),%rax
  803d41:	48 85 c0             	test   %rax,%rax
  803d44:	75 3a                	jne    803d80 <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  803d46:	ba 07 00 00 00       	mov    $0x7,%edx
  803d4b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803d50:	bf 00 00 00 00       	mov    $0x0,%edi
  803d55:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  803d5c:	00 00 00 
  803d5f:	ff d0                	callq  *%rax
  803d61:	85 c0                	test   %eax,%eax
  803d63:	75 1b                	jne    803d80 <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803d65:	48 be 93 3d 80 00 00 	movabs $0x803d93,%rsi
  803d6c:	00 00 00 
  803d6f:	bf 00 00 00 00       	mov    $0x0,%edi
  803d74:	48 b8 da 1e 80 00 00 	movabs $0x801eda,%rax
  803d7b:	00 00 00 
  803d7e:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803d80:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803d87:	00 00 00 
  803d8a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d8e:	48 89 10             	mov    %rdx,(%rax)
}
  803d91:	c9                   	leaveq 
  803d92:	c3                   	retq   

0000000000803d93 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803d93:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803d96:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803d9d:	00 00 00 
	call *%rax
  803da0:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  803da2:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  803da5:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803dac:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  803dad:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  803db4:	00 
	pushq %rbx		// push utf_rip into new stack
  803db5:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  803db6:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  803dbd:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  803dc0:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  803dc4:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  803dc8:	4c 8b 3c 24          	mov    (%rsp),%r15
  803dcc:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803dd1:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803dd6:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803ddb:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803de0:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803de5:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803dea:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803def:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803df4:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803df9:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803dfe:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803e03:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803e08:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803e0d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803e12:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  803e16:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  803e1a:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  803e1b:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803e1c:	c3                   	retq   
