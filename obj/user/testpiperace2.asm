
obj/user/testpiperace2.debug:     file format elf64-x86-64


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
  80003c:	e8 ea 02 00 00       	callq  80032b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  800052:	48 bf c0 3d 80 00 00 	movabs $0x803dc0,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 17 06 80 00 00 	movabs $0x800617,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006d:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800071:	48 89 c7             	mov    %rax,%rdi
  800074:	48 b8 de 31 80 00 00 	movabs $0x8031de,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800083:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x76>
		panic("pipe: %e", r);
  800089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba e2 3d 80 00 00 	movabs $0x803de2,%rdx
  800095:	00 00 00 
  800098:	be 0d 00 00 00       	mov    $0xd,%esi
  80009d:	48 bf eb 3d 80 00 00 	movabs $0x803deb,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 de 03 80 00 00 	movabs $0x8003de,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8
	if ((r = fork()) < 0)
  8000b9:	48 b8 c4 21 80 00 00 	movabs $0x8021c4,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
  8000c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cc:	79 30                	jns    8000fe <umain+0xbb>
		panic("fork: %e", r);
  8000ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d1:	89 c1                	mov    %eax,%ecx
  8000d3:	48 ba 00 3e 80 00 00 	movabs $0x803e00,%rdx
  8000da:	00 00 00 
  8000dd:	be 0f 00 00 00       	mov    $0xf,%esi
  8000e2:	48 bf eb 3d 80 00 00 	movabs $0x803deb,%rdi
  8000e9:	00 00 00 
  8000ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f1:	49 b8 de 03 80 00 00 	movabs $0x8003de,%r8
  8000f8:	00 00 00 
  8000fb:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800102:	0f 85 c0 00 00 00    	jne    8001c8 <umain+0x185>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  800108:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80010b:	89 c7                	mov    %eax,%edi
  80010d:	48 b8 54 27 80 00 00 	movabs $0x802754,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
		for (i = 0; i < 200; i++) {
  800119:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800120:	e9 8a 00 00 00       	jmpq   8001af <umain+0x16c>
			if (i % 10 == 0)
  800125:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800128:	ba 67 66 66 66       	mov    $0x66666667,%edx
  80012d:	89 c8                	mov    %ecx,%eax
  80012f:	f7 ea                	imul   %edx
  800131:	c1 fa 02             	sar    $0x2,%edx
  800134:	89 c8                	mov    %ecx,%eax
  800136:	c1 f8 1f             	sar    $0x1f,%eax
  800139:	29 c2                	sub    %eax,%edx
  80013b:	89 d0                	mov    %edx,%eax
  80013d:	c1 e0 02             	shl    $0x2,%eax
  800140:	01 d0                	add    %edx,%eax
  800142:	01 c0                	add    %eax,%eax
  800144:	29 c1                	sub    %eax,%ecx
  800146:	89 ca                	mov    %ecx,%edx
  800148:	85 d2                	test   %edx,%edx
  80014a:	75 20                	jne    80016c <umain+0x129>
				cprintf("%d.", i);
  80014c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80014f:	89 c6                	mov    %eax,%esi
  800151:	48 bf 09 3e 80 00 00 	movabs $0x803e09,%rdi
  800158:	00 00 00 
  80015b:	b8 00 00 00 00       	mov    $0x0,%eax
  800160:	48 ba 17 06 80 00 00 	movabs $0x800617,%rdx
  800167:	00 00 00 
  80016a:	ff d2                	callq  *%rdx
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  80016c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80016f:	be 0a 00 00 00       	mov    $0xa,%esi
  800174:	89 c7                	mov    %eax,%edi
  800176:	48 b8 cd 27 80 00 00 	movabs $0x8027cd,%rax
  80017d:	00 00 00 
  800180:	ff d0                	callq  *%rax
			sys_yield();
  800182:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
			close(10);
  80018e:	bf 0a 00 00 00       	mov    $0xa,%edi
  800193:	48 b8 54 27 80 00 00 	movabs $0x802754,%rax
  80019a:	00 00 00 
  80019d:	ff d0                	callq  *%rax
			sys_yield();
  80019f:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  8001a6:	00 00 00 
  8001a9:	ff d0                	callq  *%rax
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  8001ab:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001af:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%rbp)
  8001b6:	0f 8e 69 ff ff ff    	jle    800125 <umain+0xe2>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  8001bc:	48 b8 bb 03 80 00 00 	movabs $0x8003bb,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  8001c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001cb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d0:	48 63 d0             	movslq %eax,%rdx
  8001d3:	48 89 d0             	mov    %rdx,%rax
  8001d6:	48 c1 e0 03          	shl    $0x3,%rax
  8001da:	48 01 d0             	add    %rdx,%rax
  8001dd:	48 c1 e0 05          	shl    $0x5,%rax
  8001e1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001e8:	00 00 00 
  8001eb:	48 01 d0             	add    %rdx,%rax
  8001ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	while (kid->env_status == ENV_RUNNABLE)
  8001f2:	eb 4d                	jmp    800241 <umain+0x1fe>
		if (pipeisclosed(p[0]) != 0) {
  8001f4:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8001f7:	89 c7                	mov    %eax,%edi
  8001f9:	48 b8 a7 34 80 00 00 	movabs $0x8034a7,%rax
  800200:	00 00 00 
  800203:	ff d0                	callq  *%rax
  800205:	85 c0                	test   %eax,%eax
  800207:	74 38                	je     800241 <umain+0x1fe>
			cprintf("\nRACE: pipe appears closed\n");
  800209:	48 bf 0d 3e 80 00 00 	movabs $0x803e0d,%rdi
  800210:	00 00 00 
  800213:	b8 00 00 00 00       	mov    $0x0,%eax
  800218:	48 ba 17 06 80 00 00 	movabs $0x800617,%rdx
  80021f:	00 00 00 
  800222:	ff d2                	callq  *%rdx
			sys_env_destroy(r);
  800224:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800227:	89 c7                	mov    %eax,%edi
  800229:	48 b8 2e 1c 80 00 00 	movabs $0x801c2e,%rax
  800230:	00 00 00 
  800233:	ff d0                	callq  *%rax
			exit();
  800235:	48 b8 bb 03 80 00 00 	movabs $0x8003bb,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	callq  *%rax
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800245:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80024b:	83 f8 02             	cmp    $0x2,%eax
  80024e:	74 a4                	je     8001f4 <umain+0x1b1>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  800250:	48 bf 29 3e 80 00 00 	movabs $0x803e29,%rdi
  800257:	00 00 00 
  80025a:	b8 00 00 00 00       	mov    $0x0,%eax
  80025f:	48 ba 17 06 80 00 00 	movabs $0x800617,%rdx
  800266:	00 00 00 
  800269:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  80026b:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80026e:	89 c7                	mov    %eax,%edi
  800270:	48 b8 a7 34 80 00 00 	movabs $0x8034a7,%rax
  800277:	00 00 00 
  80027a:	ff d0                	callq  *%rax
  80027c:	85 c0                	test   %eax,%eax
  80027e:	74 2a                	je     8002aa <umain+0x267>
		panic("somehow the other end of p[0] got closed!");
  800280:	48 ba 40 3e 80 00 00 	movabs $0x803e40,%rdx
  800287:	00 00 00 
  80028a:	be 40 00 00 00       	mov    $0x40,%esi
  80028f:	48 bf eb 3d 80 00 00 	movabs $0x803deb,%rdi
  800296:	00 00 00 
  800299:	b8 00 00 00 00       	mov    $0x0,%eax
  80029e:	48 b9 de 03 80 00 00 	movabs $0x8003de,%rcx
  8002a5:	00 00 00 
  8002a8:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002aa:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8002ad:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8002b1:	48 89 d6             	mov    %rdx,%rsi
  8002b4:	89 c7                	mov    %eax,%edi
  8002b6:	48 b8 44 25 80 00 00 	movabs $0x802544,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	callq  *%rax
  8002c2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002c5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002c9:	79 30                	jns    8002fb <umain+0x2b8>
		panic("cannot look up p[0]: %e", r);
  8002cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002ce:	89 c1                	mov    %eax,%ecx
  8002d0:	48 ba 6a 3e 80 00 00 	movabs $0x803e6a,%rdx
  8002d7:	00 00 00 
  8002da:	be 42 00 00 00       	mov    $0x42,%esi
  8002df:	48 bf eb 3d 80 00 00 	movabs $0x803deb,%rdi
  8002e6:	00 00 00 
  8002e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ee:	49 b8 de 03 80 00 00 	movabs $0x8003de,%r8
  8002f5:	00 00 00 
  8002f8:	41 ff d0             	callq  *%r8
	(void) fd2data(fd);
  8002fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002ff:	48 89 c7             	mov    %rax,%rdi
  800302:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  800309:	00 00 00 
  80030c:	ff d0                	callq  *%rax
	cprintf("race didn't happen\n");
  80030e:	48 bf 82 3e 80 00 00 	movabs $0x803e82,%rdi
  800315:	00 00 00 
  800318:	b8 00 00 00 00       	mov    $0x0,%eax
  80031d:	48 ba 17 06 80 00 00 	movabs $0x800617,%rdx
  800324:	00 00 00 
  800327:	ff d2                	callq  *%rdx
}
  800329:	c9                   	leaveq 
  80032a:	c3                   	retq   

000000000080032b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80032b:	55                   	push   %rbp
  80032c:	48 89 e5             	mov    %rsp,%rbp
  80032f:	48 83 ec 10          	sub    $0x10,%rsp
  800333:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800336:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  80033a:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  800341:	00 00 00 
  800344:	ff d0                	callq  *%rax
  800346:	48 98                	cltq   
  800348:	25 ff 03 00 00       	and    $0x3ff,%eax
  80034d:	48 89 c2             	mov    %rax,%rdx
  800350:	48 89 d0             	mov    %rdx,%rax
  800353:	48 c1 e0 03          	shl    $0x3,%rax
  800357:	48 01 d0             	add    %rdx,%rax
  80035a:	48 c1 e0 05          	shl    $0x5,%rax
  80035e:	48 89 c2             	mov    %rax,%rdx
  800361:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800368:	00 00 00 
  80036b:	48 01 c2             	add    %rax,%rdx
  80036e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800375:	00 00 00 
  800378:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80037b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80037f:	7e 14                	jle    800395 <libmain+0x6a>
		binaryname = argv[0];
  800381:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800385:	48 8b 10             	mov    (%rax),%rdx
  800388:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80038f:	00 00 00 
  800392:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800395:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800399:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80039c:	48 89 d6             	mov    %rdx,%rsi
  80039f:	89 c7                	mov    %eax,%edi
  8003a1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003a8:	00 00 00 
  8003ab:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003ad:	48 b8 bb 03 80 00 00 	movabs $0x8003bb,%rax
  8003b4:	00 00 00 
  8003b7:	ff d0                	callq  *%rax
}
  8003b9:	c9                   	leaveq 
  8003ba:	c3                   	retq   

00000000008003bb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003bb:	55                   	push   %rbp
  8003bc:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003bf:	48 b8 9f 27 80 00 00 	movabs $0x80279f,%rax
  8003c6:	00 00 00 
  8003c9:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8003d0:	48 b8 2e 1c 80 00 00 	movabs $0x801c2e,%rax
  8003d7:	00 00 00 
  8003da:	ff d0                	callq  *%rax
}
  8003dc:	5d                   	pop    %rbp
  8003dd:	c3                   	retq   

00000000008003de <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003de:	55                   	push   %rbp
  8003df:	48 89 e5             	mov    %rsp,%rbp
  8003e2:	53                   	push   %rbx
  8003e3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003ea:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8003f1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003f7:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003fe:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800405:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80040c:	84 c0                	test   %al,%al
  80040e:	74 23                	je     800433 <_panic+0x55>
  800410:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800417:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80041b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80041f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800423:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800427:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80042b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80042f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800433:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80043a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800441:	00 00 00 
  800444:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80044b:	00 00 00 
  80044e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800452:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800459:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800460:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800467:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80046e:	00 00 00 
  800471:	48 8b 18             	mov    (%rax),%rbx
  800474:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  80047b:	00 00 00 
  80047e:	ff d0                	callq  *%rax
  800480:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800486:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80048d:	41 89 c8             	mov    %ecx,%r8d
  800490:	48 89 d1             	mov    %rdx,%rcx
  800493:	48 89 da             	mov    %rbx,%rdx
  800496:	89 c6                	mov    %eax,%esi
  800498:	48 bf a0 3e 80 00 00 	movabs $0x803ea0,%rdi
  80049f:	00 00 00 
  8004a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a7:	49 b9 17 06 80 00 00 	movabs $0x800617,%r9
  8004ae:	00 00 00 
  8004b1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004b4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004bb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004c2:	48 89 d6             	mov    %rdx,%rsi
  8004c5:	48 89 c7             	mov    %rax,%rdi
  8004c8:	48 b8 6b 05 80 00 00 	movabs $0x80056b,%rax
  8004cf:	00 00 00 
  8004d2:	ff d0                	callq  *%rax
	cprintf("\n");
  8004d4:	48 bf c3 3e 80 00 00 	movabs $0x803ec3,%rdi
  8004db:	00 00 00 
  8004de:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e3:	48 ba 17 06 80 00 00 	movabs $0x800617,%rdx
  8004ea:	00 00 00 
  8004ed:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004ef:	cc                   	int3   
  8004f0:	eb fd                	jmp    8004ef <_panic+0x111>

00000000008004f2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8004f2:	55                   	push   %rbp
  8004f3:	48 89 e5             	mov    %rsp,%rbp
  8004f6:	48 83 ec 10          	sub    $0x10,%rsp
  8004fa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004fd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800501:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800505:	8b 00                	mov    (%rax),%eax
  800507:	8d 48 01             	lea    0x1(%rax),%ecx
  80050a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80050e:	89 0a                	mov    %ecx,(%rdx)
  800510:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800513:	89 d1                	mov    %edx,%ecx
  800515:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800519:	48 98                	cltq   
  80051b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80051f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800523:	8b 00                	mov    (%rax),%eax
  800525:	3d ff 00 00 00       	cmp    $0xff,%eax
  80052a:	75 2c                	jne    800558 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80052c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800530:	8b 00                	mov    (%rax),%eax
  800532:	48 98                	cltq   
  800534:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800538:	48 83 c2 08          	add    $0x8,%rdx
  80053c:	48 89 c6             	mov    %rax,%rsi
  80053f:	48 89 d7             	mov    %rdx,%rdi
  800542:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  800549:	00 00 00 
  80054c:	ff d0                	callq  *%rax
		b->idx = 0;
  80054e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800552:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800558:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80055c:	8b 40 04             	mov    0x4(%rax),%eax
  80055f:	8d 50 01             	lea    0x1(%rax),%edx
  800562:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800566:	89 50 04             	mov    %edx,0x4(%rax)
}
  800569:	c9                   	leaveq 
  80056a:	c3                   	retq   

000000000080056b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80056b:	55                   	push   %rbp
  80056c:	48 89 e5             	mov    %rsp,%rbp
  80056f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800576:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80057d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800584:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80058b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800592:	48 8b 0a             	mov    (%rdx),%rcx
  800595:	48 89 08             	mov    %rcx,(%rax)
  800598:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80059c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005a0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005a4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8005a8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005af:	00 00 00 
	b.cnt = 0;
  8005b2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005b9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8005bc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005c3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005ca:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005d1:	48 89 c6             	mov    %rax,%rsi
  8005d4:	48 bf f2 04 80 00 00 	movabs $0x8004f2,%rdi
  8005db:	00 00 00 
  8005de:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  8005e5:	00 00 00 
  8005e8:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8005ea:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8005f0:	48 98                	cltq   
  8005f2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005f9:	48 83 c2 08          	add    $0x8,%rdx
  8005fd:	48 89 c6             	mov    %rax,%rsi
  800600:	48 89 d7             	mov    %rdx,%rdi
  800603:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  80060a:	00 00 00 
  80060d:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80060f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800615:	c9                   	leaveq 
  800616:	c3                   	retq   

0000000000800617 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800617:	55                   	push   %rbp
  800618:	48 89 e5             	mov    %rsp,%rbp
  80061b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800622:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800629:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800630:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800637:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80063e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800645:	84 c0                	test   %al,%al
  800647:	74 20                	je     800669 <cprintf+0x52>
  800649:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80064d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800651:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800655:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800659:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80065d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800661:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800665:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800669:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800670:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800677:	00 00 00 
  80067a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800681:	00 00 00 
  800684:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800688:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80068f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800696:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80069d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006a4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006ab:	48 8b 0a             	mov    (%rdx),%rcx
  8006ae:	48 89 08             	mov    %rcx,(%rax)
  8006b1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006b5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006b9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006bd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8006c1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006c8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006cf:	48 89 d6             	mov    %rdx,%rsi
  8006d2:	48 89 c7             	mov    %rax,%rdi
  8006d5:	48 b8 6b 05 80 00 00 	movabs $0x80056b,%rax
  8006dc:	00 00 00 
  8006df:	ff d0                	callq  *%rax
  8006e1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8006e7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006ed:	c9                   	leaveq 
  8006ee:	c3                   	retq   

00000000008006ef <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006ef:	55                   	push   %rbp
  8006f0:	48 89 e5             	mov    %rsp,%rbp
  8006f3:	53                   	push   %rbx
  8006f4:	48 83 ec 38          	sub    $0x38,%rsp
  8006f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800700:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800704:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800707:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80070b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80070f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800712:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800716:	77 3b                	ja     800753 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800718:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80071b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80071f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800722:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800726:	ba 00 00 00 00       	mov    $0x0,%edx
  80072b:	48 f7 f3             	div    %rbx
  80072e:	48 89 c2             	mov    %rax,%rdx
  800731:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800734:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800737:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80073b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073f:	41 89 f9             	mov    %edi,%r9d
  800742:	48 89 c7             	mov    %rax,%rdi
  800745:	48 b8 ef 06 80 00 00 	movabs $0x8006ef,%rax
  80074c:	00 00 00 
  80074f:	ff d0                	callq  *%rax
  800751:	eb 1e                	jmp    800771 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800753:	eb 12                	jmp    800767 <printnum+0x78>
			putch(padc, putdat);
  800755:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800759:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80075c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800760:	48 89 ce             	mov    %rcx,%rsi
  800763:	89 d7                	mov    %edx,%edi
  800765:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800767:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80076b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80076f:	7f e4                	jg     800755 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800771:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800774:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800778:	ba 00 00 00 00       	mov    $0x0,%edx
  80077d:	48 f7 f1             	div    %rcx
  800780:	48 89 d0             	mov    %rdx,%rax
  800783:	48 ba a8 40 80 00 00 	movabs $0x8040a8,%rdx
  80078a:	00 00 00 
  80078d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800791:	0f be d0             	movsbl %al,%edx
  800794:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800798:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079c:	48 89 ce             	mov    %rcx,%rsi
  80079f:	89 d7                	mov    %edx,%edi
  8007a1:	ff d0                	callq  *%rax
}
  8007a3:	48 83 c4 38          	add    $0x38,%rsp
  8007a7:	5b                   	pop    %rbx
  8007a8:	5d                   	pop    %rbp
  8007a9:	c3                   	retq   

00000000008007aa <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007aa:	55                   	push   %rbp
  8007ab:	48 89 e5             	mov    %rsp,%rbp
  8007ae:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007b6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8007b9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007bd:	7e 52                	jle    800811 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c3:	8b 00                	mov    (%rax),%eax
  8007c5:	83 f8 30             	cmp    $0x30,%eax
  8007c8:	73 24                	jae    8007ee <getuint+0x44>
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d6:	8b 00                	mov    (%rax),%eax
  8007d8:	89 c0                	mov    %eax,%eax
  8007da:	48 01 d0             	add    %rdx,%rax
  8007dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e1:	8b 12                	mov    (%rdx),%edx
  8007e3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ea:	89 0a                	mov    %ecx,(%rdx)
  8007ec:	eb 17                	jmp    800805 <getuint+0x5b>
  8007ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f6:	48 89 d0             	mov    %rdx,%rax
  8007f9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800801:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800805:	48 8b 00             	mov    (%rax),%rax
  800808:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080c:	e9 a3 00 00 00       	jmpq   8008b4 <getuint+0x10a>
	else if (lflag)
  800811:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800815:	74 4f                	je     800866 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081b:	8b 00                	mov    (%rax),%eax
  80081d:	83 f8 30             	cmp    $0x30,%eax
  800820:	73 24                	jae    800846 <getuint+0x9c>
  800822:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800826:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082e:	8b 00                	mov    (%rax),%eax
  800830:	89 c0                	mov    %eax,%eax
  800832:	48 01 d0             	add    %rdx,%rax
  800835:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800839:	8b 12                	mov    (%rdx),%edx
  80083b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80083e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800842:	89 0a                	mov    %ecx,(%rdx)
  800844:	eb 17                	jmp    80085d <getuint+0xb3>
  800846:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80084e:	48 89 d0             	mov    %rdx,%rax
  800851:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800855:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800859:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80085d:	48 8b 00             	mov    (%rax),%rax
  800860:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800864:	eb 4e                	jmp    8008b4 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086a:	8b 00                	mov    (%rax),%eax
  80086c:	83 f8 30             	cmp    $0x30,%eax
  80086f:	73 24                	jae    800895 <getuint+0xeb>
  800871:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800875:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800879:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087d:	8b 00                	mov    (%rax),%eax
  80087f:	89 c0                	mov    %eax,%eax
  800881:	48 01 d0             	add    %rdx,%rax
  800884:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800888:	8b 12                	mov    (%rdx),%edx
  80088a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80088d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800891:	89 0a                	mov    %ecx,(%rdx)
  800893:	eb 17                	jmp    8008ac <getuint+0x102>
  800895:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800899:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80089d:	48 89 d0             	mov    %rdx,%rax
  8008a0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008ac:	8b 00                	mov    (%rax),%eax
  8008ae:	89 c0                	mov    %eax,%eax
  8008b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008b8:	c9                   	leaveq 
  8008b9:	c3                   	retq   

00000000008008ba <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ba:	55                   	push   %rbp
  8008bb:	48 89 e5             	mov    %rsp,%rbp
  8008be:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008c6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008c9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008cd:	7e 52                	jle    800921 <getint+0x67>
		x=va_arg(*ap, long long);
  8008cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d3:	8b 00                	mov    (%rax),%eax
  8008d5:	83 f8 30             	cmp    $0x30,%eax
  8008d8:	73 24                	jae    8008fe <getint+0x44>
  8008da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008de:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e6:	8b 00                	mov    (%rax),%eax
  8008e8:	89 c0                	mov    %eax,%eax
  8008ea:	48 01 d0             	add    %rdx,%rax
  8008ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f1:	8b 12                	mov    (%rdx),%edx
  8008f3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008fa:	89 0a                	mov    %ecx,(%rdx)
  8008fc:	eb 17                	jmp    800915 <getint+0x5b>
  8008fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800902:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800906:	48 89 d0             	mov    %rdx,%rax
  800909:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80090d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800911:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800915:	48 8b 00             	mov    (%rax),%rax
  800918:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80091c:	e9 a3 00 00 00       	jmpq   8009c4 <getint+0x10a>
	else if (lflag)
  800921:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800925:	74 4f                	je     800976 <getint+0xbc>
		x=va_arg(*ap, long);
  800927:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092b:	8b 00                	mov    (%rax),%eax
  80092d:	83 f8 30             	cmp    $0x30,%eax
  800930:	73 24                	jae    800956 <getint+0x9c>
  800932:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800936:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80093a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093e:	8b 00                	mov    (%rax),%eax
  800940:	89 c0                	mov    %eax,%eax
  800942:	48 01 d0             	add    %rdx,%rax
  800945:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800949:	8b 12                	mov    (%rdx),%edx
  80094b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80094e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800952:	89 0a                	mov    %ecx,(%rdx)
  800954:	eb 17                	jmp    80096d <getint+0xb3>
  800956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80095e:	48 89 d0             	mov    %rdx,%rax
  800961:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800965:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800969:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80096d:	48 8b 00             	mov    (%rax),%rax
  800970:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800974:	eb 4e                	jmp    8009c4 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800976:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097a:	8b 00                	mov    (%rax),%eax
  80097c:	83 f8 30             	cmp    $0x30,%eax
  80097f:	73 24                	jae    8009a5 <getint+0xeb>
  800981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800985:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800989:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098d:	8b 00                	mov    (%rax),%eax
  80098f:	89 c0                	mov    %eax,%eax
  800991:	48 01 d0             	add    %rdx,%rax
  800994:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800998:	8b 12                	mov    (%rdx),%edx
  80099a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80099d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a1:	89 0a                	mov    %ecx,(%rdx)
  8009a3:	eb 17                	jmp    8009bc <getint+0x102>
  8009a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ad:	48 89 d0             	mov    %rdx,%rax
  8009b0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009bc:	8b 00                	mov    (%rax),%eax
  8009be:	48 98                	cltq   
  8009c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009c8:	c9                   	leaveq 
  8009c9:	c3                   	retq   

00000000008009ca <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009ca:	55                   	push   %rbp
  8009cb:	48 89 e5             	mov    %rsp,%rbp
  8009ce:	41 54                	push   %r12
  8009d0:	53                   	push   %rbx
  8009d1:	48 83 ec 60          	sub    $0x60,%rsp
  8009d5:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009d9:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009dd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009e1:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009e5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009e9:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009ed:	48 8b 0a             	mov    (%rdx),%rcx
  8009f0:	48 89 08             	mov    %rcx,(%rax)
  8009f3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009f7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009fb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009ff:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  800a03:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a07:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a0b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a0f:	0f b6 00             	movzbl (%rax),%eax
  800a12:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  800a15:	eb 29                	jmp    800a40 <vprintfmt+0x76>
			if (ch == '\0')
  800a17:	85 db                	test   %ebx,%ebx
  800a19:	0f 84 ad 06 00 00    	je     8010cc <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  800a1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a27:	48 89 d6             	mov    %rdx,%rsi
  800a2a:	89 df                	mov    %ebx,%edi
  800a2c:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  800a2e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a32:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a36:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a3a:	0f b6 00             	movzbl (%rax),%eax
  800a3d:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  800a40:	83 fb 25             	cmp    $0x25,%ebx
  800a43:	74 05                	je     800a4a <vprintfmt+0x80>
  800a45:	83 fb 1b             	cmp    $0x1b,%ebx
  800a48:	75 cd                	jne    800a17 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800a4a:	83 fb 1b             	cmp    $0x1b,%ebx
  800a4d:	0f 85 ae 01 00 00    	jne    800c01 <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  800a53:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800a5a:	00 00 00 
  800a5d:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  800a63:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a6b:	48 89 d6             	mov    %rdx,%rsi
  800a6e:	89 df                	mov    %ebx,%edi
  800a70:	ff d0                	callq  *%rax
			putch('[', putdat);
  800a72:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a76:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a7a:	48 89 d6             	mov    %rdx,%rsi
  800a7d:	bf 5b 00 00 00       	mov    $0x5b,%edi
  800a82:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800a84:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800a8a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a8f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a93:	0f b6 00             	movzbl (%rax),%eax
  800a96:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800a99:	eb 32                	jmp    800acd <vprintfmt+0x103>
					putch(ch, putdat);
  800a9b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa3:	48 89 d6             	mov    %rdx,%rsi
  800aa6:	89 df                	mov    %ebx,%edi
  800aa8:	ff d0                	callq  *%rax
					esc_color *= 10;
  800aaa:	44 89 e0             	mov    %r12d,%eax
  800aad:	c1 e0 02             	shl    $0x2,%eax
  800ab0:	44 01 e0             	add    %r12d,%eax
  800ab3:	01 c0                	add    %eax,%eax
  800ab5:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800ab8:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800abb:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800abe:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800ac3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ac7:	0f b6 00             	movzbl (%rax),%eax
  800aca:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800acd:	83 fb 3b             	cmp    $0x3b,%ebx
  800ad0:	74 05                	je     800ad7 <vprintfmt+0x10d>
  800ad2:	83 fb 6d             	cmp    $0x6d,%ebx
  800ad5:	75 c4                	jne    800a9b <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800ad7:	45 85 e4             	test   %r12d,%r12d
  800ada:	75 15                	jne    800af1 <vprintfmt+0x127>
					color_flag = 0x07;
  800adc:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800ae3:	00 00 00 
  800ae6:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800aec:	e9 dc 00 00 00       	jmpq   800bcd <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800af1:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800af5:	7e 69                	jle    800b60 <vprintfmt+0x196>
  800af7:	41 83 fc 25          	cmp    $0x25,%r12d
  800afb:	7f 63                	jg     800b60 <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800afd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b04:	00 00 00 
  800b07:	8b 00                	mov    (%rax),%eax
  800b09:	25 f8 00 00 00       	and    $0xf8,%eax
  800b0e:	89 c2                	mov    %eax,%edx
  800b10:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b17:	00 00 00 
  800b1a:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800b1c:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800b20:	44 89 e0             	mov    %r12d,%eax
  800b23:	83 e0 04             	and    $0x4,%eax
  800b26:	c1 f8 02             	sar    $0x2,%eax
  800b29:	89 c2                	mov    %eax,%edx
  800b2b:	44 89 e0             	mov    %r12d,%eax
  800b2e:	83 e0 02             	and    $0x2,%eax
  800b31:	09 c2                	or     %eax,%edx
  800b33:	44 89 e0             	mov    %r12d,%eax
  800b36:	83 e0 01             	and    $0x1,%eax
  800b39:	c1 e0 02             	shl    $0x2,%eax
  800b3c:	09 c2                	or     %eax,%edx
  800b3e:	41 89 d4             	mov    %edx,%r12d
  800b41:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b48:	00 00 00 
  800b4b:	8b 00                	mov    (%rax),%eax
  800b4d:	44 89 e2             	mov    %r12d,%edx
  800b50:	09 c2                	or     %eax,%edx
  800b52:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b59:	00 00 00 
  800b5c:	89 10                	mov    %edx,(%rax)
  800b5e:	eb 6d                	jmp    800bcd <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800b60:	41 83 fc 27          	cmp    $0x27,%r12d
  800b64:	7e 67                	jle    800bcd <vprintfmt+0x203>
  800b66:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800b6a:	7f 61                	jg     800bcd <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800b6c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b73:	00 00 00 
  800b76:	8b 00                	mov    (%rax),%eax
  800b78:	25 8f 00 00 00       	and    $0x8f,%eax
  800b7d:	89 c2                	mov    %eax,%edx
  800b7f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b86:	00 00 00 
  800b89:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800b8b:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800b8f:	44 89 e0             	mov    %r12d,%eax
  800b92:	83 e0 04             	and    $0x4,%eax
  800b95:	c1 f8 02             	sar    $0x2,%eax
  800b98:	89 c2                	mov    %eax,%edx
  800b9a:	44 89 e0             	mov    %r12d,%eax
  800b9d:	83 e0 02             	and    $0x2,%eax
  800ba0:	09 c2                	or     %eax,%edx
  800ba2:	44 89 e0             	mov    %r12d,%eax
  800ba5:	83 e0 01             	and    $0x1,%eax
  800ba8:	c1 e0 06             	shl    $0x6,%eax
  800bab:	09 c2                	or     %eax,%edx
  800bad:	41 89 d4             	mov    %edx,%r12d
  800bb0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800bb7:	00 00 00 
  800bba:	8b 00                	mov    (%rax),%eax
  800bbc:	44 89 e2             	mov    %r12d,%edx
  800bbf:	09 c2                	or     %eax,%edx
  800bc1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800bc8:	00 00 00 
  800bcb:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800bcd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bd1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd5:	48 89 d6             	mov    %rdx,%rsi
  800bd8:	89 df                	mov    %ebx,%edi
  800bda:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800bdc:	83 fb 6d             	cmp    $0x6d,%ebx
  800bdf:	75 1b                	jne    800bfc <vprintfmt+0x232>
					fmt ++;
  800be1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800be6:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800be7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800bee:	00 00 00 
  800bf1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800bf7:	e9 cb 04 00 00       	jmpq   8010c7 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800bfc:	e9 83 fe ff ff       	jmpq   800a84 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800c01:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c05:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c0c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c13:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c1a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c21:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c25:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c29:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c2d:	0f b6 00             	movzbl (%rax),%eax
  800c30:	0f b6 d8             	movzbl %al,%ebx
  800c33:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c36:	83 f8 55             	cmp    $0x55,%eax
  800c39:	0f 87 5a 04 00 00    	ja     801099 <vprintfmt+0x6cf>
  800c3f:	89 c0                	mov    %eax,%eax
  800c41:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c48:	00 
  800c49:	48 b8 d0 40 80 00 00 	movabs $0x8040d0,%rax
  800c50:	00 00 00 
  800c53:	48 01 d0             	add    %rdx,%rax
  800c56:	48 8b 00             	mov    (%rax),%rax
  800c59:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c5b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c5f:	eb c0                	jmp    800c21 <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c61:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c65:	eb ba                	jmp    800c21 <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c67:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c6e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c71:	89 d0                	mov    %edx,%eax
  800c73:	c1 e0 02             	shl    $0x2,%eax
  800c76:	01 d0                	add    %edx,%eax
  800c78:	01 c0                	add    %eax,%eax
  800c7a:	01 d8                	add    %ebx,%eax
  800c7c:	83 e8 30             	sub    $0x30,%eax
  800c7f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c82:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c86:	0f b6 00             	movzbl (%rax),%eax
  800c89:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c8c:	83 fb 2f             	cmp    $0x2f,%ebx
  800c8f:	7e 0c                	jle    800c9d <vprintfmt+0x2d3>
  800c91:	83 fb 39             	cmp    $0x39,%ebx
  800c94:	7f 07                	jg     800c9d <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c96:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c9b:	eb d1                	jmp    800c6e <vprintfmt+0x2a4>
			goto process_precision;
  800c9d:	eb 58                	jmp    800cf7 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800c9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca2:	83 f8 30             	cmp    $0x30,%eax
  800ca5:	73 17                	jae    800cbe <vprintfmt+0x2f4>
  800ca7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cae:	89 c0                	mov    %eax,%eax
  800cb0:	48 01 d0             	add    %rdx,%rax
  800cb3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb6:	83 c2 08             	add    $0x8,%edx
  800cb9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cbc:	eb 0f                	jmp    800ccd <vprintfmt+0x303>
  800cbe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc2:	48 89 d0             	mov    %rdx,%rax
  800cc5:	48 83 c2 08          	add    $0x8,%rdx
  800cc9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ccd:	8b 00                	mov    (%rax),%eax
  800ccf:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800cd2:	eb 23                	jmp    800cf7 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800cd4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cd8:	79 0c                	jns    800ce6 <vprintfmt+0x31c>
				width = 0;
  800cda:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ce1:	e9 3b ff ff ff       	jmpq   800c21 <vprintfmt+0x257>
  800ce6:	e9 36 ff ff ff       	jmpq   800c21 <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800ceb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800cf2:	e9 2a ff ff ff       	jmpq   800c21 <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800cf7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cfb:	79 12                	jns    800d0f <vprintfmt+0x345>
				width = precision, precision = -1;
  800cfd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d00:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d03:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d0a:	e9 12 ff ff ff       	jmpq   800c21 <vprintfmt+0x257>
  800d0f:	e9 0d ff ff ff       	jmpq   800c21 <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d14:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d18:	e9 04 ff ff ff       	jmpq   800c21 <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d1d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d20:	83 f8 30             	cmp    $0x30,%eax
  800d23:	73 17                	jae    800d3c <vprintfmt+0x372>
  800d25:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d29:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2c:	89 c0                	mov    %eax,%eax
  800d2e:	48 01 d0             	add    %rdx,%rax
  800d31:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d34:	83 c2 08             	add    $0x8,%edx
  800d37:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d3a:	eb 0f                	jmp    800d4b <vprintfmt+0x381>
  800d3c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d40:	48 89 d0             	mov    %rdx,%rax
  800d43:	48 83 c2 08          	add    $0x8,%rdx
  800d47:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d4b:	8b 10                	mov    (%rax),%edx
  800d4d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d55:	48 89 ce             	mov    %rcx,%rsi
  800d58:	89 d7                	mov    %edx,%edi
  800d5a:	ff d0                	callq  *%rax
			break;
  800d5c:	e9 66 03 00 00       	jmpq   8010c7 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800d61:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d64:	83 f8 30             	cmp    $0x30,%eax
  800d67:	73 17                	jae    800d80 <vprintfmt+0x3b6>
  800d69:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d70:	89 c0                	mov    %eax,%eax
  800d72:	48 01 d0             	add    %rdx,%rax
  800d75:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d78:	83 c2 08             	add    $0x8,%edx
  800d7b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d7e:	eb 0f                	jmp    800d8f <vprintfmt+0x3c5>
  800d80:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d84:	48 89 d0             	mov    %rdx,%rax
  800d87:	48 83 c2 08          	add    $0x8,%rdx
  800d8b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d8f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d91:	85 db                	test   %ebx,%ebx
  800d93:	79 02                	jns    800d97 <vprintfmt+0x3cd>
				err = -err;
  800d95:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d97:	83 fb 10             	cmp    $0x10,%ebx
  800d9a:	7f 16                	jg     800db2 <vprintfmt+0x3e8>
  800d9c:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  800da3:	00 00 00 
  800da6:	48 63 d3             	movslq %ebx,%rdx
  800da9:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800dad:	4d 85 e4             	test   %r12,%r12
  800db0:	75 2e                	jne    800de0 <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800db2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800db6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dba:	89 d9                	mov    %ebx,%ecx
  800dbc:	48 ba b9 40 80 00 00 	movabs $0x8040b9,%rdx
  800dc3:	00 00 00 
  800dc6:	48 89 c7             	mov    %rax,%rdi
  800dc9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dce:	49 b8 d5 10 80 00 00 	movabs $0x8010d5,%r8
  800dd5:	00 00 00 
  800dd8:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ddb:	e9 e7 02 00 00       	jmpq   8010c7 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800de0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800de4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de8:	4c 89 e1             	mov    %r12,%rcx
  800deb:	48 ba c2 40 80 00 00 	movabs $0x8040c2,%rdx
  800df2:	00 00 00 
  800df5:	48 89 c7             	mov    %rax,%rdi
  800df8:	b8 00 00 00 00       	mov    $0x0,%eax
  800dfd:	49 b8 d5 10 80 00 00 	movabs $0x8010d5,%r8
  800e04:	00 00 00 
  800e07:	41 ff d0             	callq  *%r8
			break;
  800e0a:	e9 b8 02 00 00       	jmpq   8010c7 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e12:	83 f8 30             	cmp    $0x30,%eax
  800e15:	73 17                	jae    800e2e <vprintfmt+0x464>
  800e17:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e1b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e1e:	89 c0                	mov    %eax,%eax
  800e20:	48 01 d0             	add    %rdx,%rax
  800e23:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e26:	83 c2 08             	add    $0x8,%edx
  800e29:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e2c:	eb 0f                	jmp    800e3d <vprintfmt+0x473>
  800e2e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e32:	48 89 d0             	mov    %rdx,%rax
  800e35:	48 83 c2 08          	add    $0x8,%rdx
  800e39:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e3d:	4c 8b 20             	mov    (%rax),%r12
  800e40:	4d 85 e4             	test   %r12,%r12
  800e43:	75 0a                	jne    800e4f <vprintfmt+0x485>
				p = "(null)";
  800e45:	49 bc c5 40 80 00 00 	movabs $0x8040c5,%r12
  800e4c:	00 00 00 
			if (width > 0 && padc != '-')
  800e4f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e53:	7e 3f                	jle    800e94 <vprintfmt+0x4ca>
  800e55:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e59:	74 39                	je     800e94 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e5b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e5e:	48 98                	cltq   
  800e60:	48 89 c6             	mov    %rax,%rsi
  800e63:	4c 89 e7             	mov    %r12,%rdi
  800e66:	48 b8 81 13 80 00 00 	movabs $0x801381,%rax
  800e6d:	00 00 00 
  800e70:	ff d0                	callq  *%rax
  800e72:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e75:	eb 17                	jmp    800e8e <vprintfmt+0x4c4>
					putch(padc, putdat);
  800e77:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e7b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e7f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e83:	48 89 ce             	mov    %rcx,%rsi
  800e86:	89 d7                	mov    %edx,%edi
  800e88:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e8a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e8e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e92:	7f e3                	jg     800e77 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e94:	eb 37                	jmp    800ecd <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800e96:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e9a:	74 1e                	je     800eba <vprintfmt+0x4f0>
  800e9c:	83 fb 1f             	cmp    $0x1f,%ebx
  800e9f:	7e 05                	jle    800ea6 <vprintfmt+0x4dc>
  800ea1:	83 fb 7e             	cmp    $0x7e,%ebx
  800ea4:	7e 14                	jle    800eba <vprintfmt+0x4f0>
					putch('?', putdat);
  800ea6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eaa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eae:	48 89 d6             	mov    %rdx,%rsi
  800eb1:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800eb6:	ff d0                	callq  *%rax
  800eb8:	eb 0f                	jmp    800ec9 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800eba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ebe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec2:	48 89 d6             	mov    %rdx,%rsi
  800ec5:	89 df                	mov    %ebx,%edi
  800ec7:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ec9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ecd:	4c 89 e0             	mov    %r12,%rax
  800ed0:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ed4:	0f b6 00             	movzbl (%rax),%eax
  800ed7:	0f be d8             	movsbl %al,%ebx
  800eda:	85 db                	test   %ebx,%ebx
  800edc:	74 10                	je     800eee <vprintfmt+0x524>
  800ede:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ee2:	78 b2                	js     800e96 <vprintfmt+0x4cc>
  800ee4:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ee8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800eec:	79 a8                	jns    800e96 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eee:	eb 16                	jmp    800f06 <vprintfmt+0x53c>
				putch(' ', putdat);
  800ef0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef8:	48 89 d6             	mov    %rdx,%rsi
  800efb:	bf 20 00 00 00       	mov    $0x20,%edi
  800f00:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f02:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f06:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f0a:	7f e4                	jg     800ef0 <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800f0c:	e9 b6 01 00 00       	jmpq   8010c7 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f11:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f15:	be 03 00 00 00       	mov    $0x3,%esi
  800f1a:	48 89 c7             	mov    %rax,%rdi
  800f1d:	48 b8 ba 08 80 00 00 	movabs $0x8008ba,%rax
  800f24:	00 00 00 
  800f27:	ff d0                	callq  *%rax
  800f29:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f31:	48 85 c0             	test   %rax,%rax
  800f34:	79 1d                	jns    800f53 <vprintfmt+0x589>
				putch('-', putdat);
  800f36:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f3a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f3e:	48 89 d6             	mov    %rdx,%rsi
  800f41:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f46:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4c:	48 f7 d8             	neg    %rax
  800f4f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f53:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f5a:	e9 fb 00 00 00       	jmpq   80105a <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f5f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f63:	be 03 00 00 00       	mov    $0x3,%esi
  800f68:	48 89 c7             	mov    %rax,%rdi
  800f6b:	48 b8 aa 07 80 00 00 	movabs $0x8007aa,%rax
  800f72:	00 00 00 
  800f75:	ff d0                	callq  *%rax
  800f77:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f7b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f82:	e9 d3 00 00 00       	jmpq   80105a <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800f87:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f8b:	be 03 00 00 00       	mov    $0x3,%esi
  800f90:	48 89 c7             	mov    %rax,%rdi
  800f93:	48 b8 ba 08 80 00 00 	movabs $0x8008ba,%rax
  800f9a:	00 00 00 
  800f9d:	ff d0                	callq  *%rax
  800f9f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800fa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa7:	48 85 c0             	test   %rax,%rax
  800faa:	79 1d                	jns    800fc9 <vprintfmt+0x5ff>
				putch('-', putdat);
  800fac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fb0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fb4:	48 89 d6             	mov    %rdx,%rsi
  800fb7:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800fbc:	ff d0                	callq  *%rax
				num = -(long long) num;
  800fbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc2:	48 f7 d8             	neg    %rax
  800fc5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800fc9:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800fd0:	e9 85 00 00 00       	jmpq   80105a <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800fd5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fdd:	48 89 d6             	mov    %rdx,%rsi
  800fe0:	bf 30 00 00 00       	mov    $0x30,%edi
  800fe5:	ff d0                	callq  *%rax
			putch('x', putdat);
  800fe7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800feb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fef:	48 89 d6             	mov    %rdx,%rsi
  800ff2:	bf 78 00 00 00       	mov    $0x78,%edi
  800ff7:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ff9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ffc:	83 f8 30             	cmp    $0x30,%eax
  800fff:	73 17                	jae    801018 <vprintfmt+0x64e>
  801001:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801005:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801008:	89 c0                	mov    %eax,%eax
  80100a:	48 01 d0             	add    %rdx,%rax
  80100d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801010:	83 c2 08             	add    $0x8,%edx
  801013:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801016:	eb 0f                	jmp    801027 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  801018:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80101c:	48 89 d0             	mov    %rdx,%rax
  80101f:	48 83 c2 08          	add    $0x8,%rdx
  801023:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801027:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80102a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80102e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801035:	eb 23                	jmp    80105a <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801037:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80103b:	be 03 00 00 00       	mov    $0x3,%esi
  801040:	48 89 c7             	mov    %rax,%rdi
  801043:	48 b8 aa 07 80 00 00 	movabs $0x8007aa,%rax
  80104a:	00 00 00 
  80104d:	ff d0                	callq  *%rax
  80104f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801053:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80105a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80105f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801062:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801065:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801069:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80106d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801071:	45 89 c1             	mov    %r8d,%r9d
  801074:	41 89 f8             	mov    %edi,%r8d
  801077:	48 89 c7             	mov    %rax,%rdi
  80107a:	48 b8 ef 06 80 00 00 	movabs $0x8006ef,%rax
  801081:	00 00 00 
  801084:	ff d0                	callq  *%rax
			break;
  801086:	eb 3f                	jmp    8010c7 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801088:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80108c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801090:	48 89 d6             	mov    %rdx,%rsi
  801093:	89 df                	mov    %ebx,%edi
  801095:	ff d0                	callq  *%rax
			break;
  801097:	eb 2e                	jmp    8010c7 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801099:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80109d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010a1:	48 89 d6             	mov    %rdx,%rsi
  8010a4:	bf 25 00 00 00       	mov    $0x25,%edi
  8010a9:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010ab:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010b0:	eb 05                	jmp    8010b7 <vprintfmt+0x6ed>
  8010b2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010b7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010bb:	48 83 e8 01          	sub    $0x1,%rax
  8010bf:	0f b6 00             	movzbl (%rax),%eax
  8010c2:	3c 25                	cmp    $0x25,%al
  8010c4:	75 ec                	jne    8010b2 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  8010c6:	90                   	nop
		}
	}
  8010c7:	e9 37 f9 ff ff       	jmpq   800a03 <vprintfmt+0x39>
    va_end(aq);
}
  8010cc:	48 83 c4 60          	add    $0x60,%rsp
  8010d0:	5b                   	pop    %rbx
  8010d1:	41 5c                	pop    %r12
  8010d3:	5d                   	pop    %rbp
  8010d4:	c3                   	retq   

00000000008010d5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010d5:	55                   	push   %rbp
  8010d6:	48 89 e5             	mov    %rsp,%rbp
  8010d9:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8010e0:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8010e7:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8010ee:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010f5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010fc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801103:	84 c0                	test   %al,%al
  801105:	74 20                	je     801127 <printfmt+0x52>
  801107:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80110b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80110f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801113:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801117:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80111b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80111f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801123:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801127:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80112e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801135:	00 00 00 
  801138:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80113f:	00 00 00 
  801142:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801146:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80114d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801154:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80115b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801162:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801169:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801170:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801177:	48 89 c7             	mov    %rax,%rdi
  80117a:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  801181:	00 00 00 
  801184:	ff d0                	callq  *%rax
	va_end(ap);
}
  801186:	c9                   	leaveq 
  801187:	c3                   	retq   

0000000000801188 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801188:	55                   	push   %rbp
  801189:	48 89 e5             	mov    %rsp,%rbp
  80118c:	48 83 ec 10          	sub    $0x10,%rsp
  801190:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801193:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801197:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119b:	8b 40 10             	mov    0x10(%rax),%eax
  80119e:	8d 50 01             	lea    0x1(%rax),%edx
  8011a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a5:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ac:	48 8b 10             	mov    (%rax),%rdx
  8011af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011b7:	48 39 c2             	cmp    %rax,%rdx
  8011ba:	73 17                	jae    8011d3 <sprintputch+0x4b>
		*b->buf++ = ch;
  8011bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c0:	48 8b 00             	mov    (%rax),%rax
  8011c3:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8011c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011cb:	48 89 0a             	mov    %rcx,(%rdx)
  8011ce:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011d1:	88 10                	mov    %dl,(%rax)
}
  8011d3:	c9                   	leaveq 
  8011d4:	c3                   	retq   

00000000008011d5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011d5:	55                   	push   %rbp
  8011d6:	48 89 e5             	mov    %rsp,%rbp
  8011d9:	48 83 ec 50          	sub    $0x50,%rsp
  8011dd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8011e1:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8011e4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8011e8:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8011ec:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8011f0:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8011f4:	48 8b 0a             	mov    (%rdx),%rcx
  8011f7:	48 89 08             	mov    %rcx,(%rax)
  8011fa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011fe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801202:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801206:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80120a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80120e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801212:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801215:	48 98                	cltq   
  801217:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80121b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80121f:	48 01 d0             	add    %rdx,%rax
  801222:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801226:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80122d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801232:	74 06                	je     80123a <vsnprintf+0x65>
  801234:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801238:	7f 07                	jg     801241 <vsnprintf+0x6c>
		return -E_INVAL;
  80123a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123f:	eb 2f                	jmp    801270 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801241:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801245:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801249:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80124d:	48 89 c6             	mov    %rax,%rsi
  801250:	48 bf 88 11 80 00 00 	movabs $0x801188,%rdi
  801257:	00 00 00 
  80125a:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  801261:	00 00 00 
  801264:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801266:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80126a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80126d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801270:	c9                   	leaveq 
  801271:	c3                   	retq   

0000000000801272 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801272:	55                   	push   %rbp
  801273:	48 89 e5             	mov    %rsp,%rbp
  801276:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80127d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801284:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80128a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801291:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801298:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80129f:	84 c0                	test   %al,%al
  8012a1:	74 20                	je     8012c3 <snprintf+0x51>
  8012a3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012a7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012ab:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012af:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012b3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012b7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012bb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012bf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012c3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012ca:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8012d1:	00 00 00 
  8012d4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8012db:	00 00 00 
  8012de:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012e2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8012e9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012f0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8012f7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8012fe:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801305:	48 8b 0a             	mov    (%rdx),%rcx
  801308:	48 89 08             	mov    %rcx,(%rax)
  80130b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80130f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801313:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801317:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80131b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801322:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801329:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80132f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801336:	48 89 c7             	mov    %rax,%rdi
  801339:	48 b8 d5 11 80 00 00 	movabs $0x8011d5,%rax
  801340:	00 00 00 
  801343:	ff d0                	callq  *%rax
  801345:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80134b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801351:	c9                   	leaveq 
  801352:	c3                   	retq   

0000000000801353 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801353:	55                   	push   %rbp
  801354:	48 89 e5             	mov    %rsp,%rbp
  801357:	48 83 ec 18          	sub    $0x18,%rsp
  80135b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80135f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801366:	eb 09                	jmp    801371 <strlen+0x1e>
		n++;
  801368:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80136c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801371:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801375:	0f b6 00             	movzbl (%rax),%eax
  801378:	84 c0                	test   %al,%al
  80137a:	75 ec                	jne    801368 <strlen+0x15>
		n++;
	return n;
  80137c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80137f:	c9                   	leaveq 
  801380:	c3                   	retq   

0000000000801381 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801381:	55                   	push   %rbp
  801382:	48 89 e5             	mov    %rsp,%rbp
  801385:	48 83 ec 20          	sub    $0x20,%rsp
  801389:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80138d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801391:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801398:	eb 0e                	jmp    8013a8 <strnlen+0x27>
		n++;
  80139a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80139e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013a3:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013a8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8013ad:	74 0b                	je     8013ba <strnlen+0x39>
  8013af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b3:	0f b6 00             	movzbl (%rax),%eax
  8013b6:	84 c0                	test   %al,%al
  8013b8:	75 e0                	jne    80139a <strnlen+0x19>
		n++;
	return n;
  8013ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013bd:	c9                   	leaveq 
  8013be:	c3                   	retq   

00000000008013bf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013bf:	55                   	push   %rbp
  8013c0:	48 89 e5             	mov    %rsp,%rbp
  8013c3:	48 83 ec 20          	sub    $0x20,%rsp
  8013c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8013cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8013d7:	90                   	nop
  8013d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013dc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013e0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013e4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013e8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013ec:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013f0:	0f b6 12             	movzbl (%rdx),%edx
  8013f3:	88 10                	mov    %dl,(%rax)
  8013f5:	0f b6 00             	movzbl (%rax),%eax
  8013f8:	84 c0                	test   %al,%al
  8013fa:	75 dc                	jne    8013d8 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8013fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801400:	c9                   	leaveq 
  801401:	c3                   	retq   

0000000000801402 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801402:	55                   	push   %rbp
  801403:	48 89 e5             	mov    %rsp,%rbp
  801406:	48 83 ec 20          	sub    $0x20,%rsp
  80140a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80140e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801412:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801416:	48 89 c7             	mov    %rax,%rdi
  801419:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  801420:	00 00 00 
  801423:	ff d0                	callq  *%rax
  801425:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801428:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80142b:	48 63 d0             	movslq %eax,%rdx
  80142e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801432:	48 01 c2             	add    %rax,%rdx
  801435:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801439:	48 89 c6             	mov    %rax,%rsi
  80143c:	48 89 d7             	mov    %rdx,%rdi
  80143f:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  801446:	00 00 00 
  801449:	ff d0                	callq  *%rax
	return dst;
  80144b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80144f:	c9                   	leaveq 
  801450:	c3                   	retq   

0000000000801451 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801451:	55                   	push   %rbp
  801452:	48 89 e5             	mov    %rsp,%rbp
  801455:	48 83 ec 28          	sub    $0x28,%rsp
  801459:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80145d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801461:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801465:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801469:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80146d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801474:	00 
  801475:	eb 2a                	jmp    8014a1 <strncpy+0x50>
		*dst++ = *src;
  801477:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80147b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80147f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801483:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801487:	0f b6 12             	movzbl (%rdx),%edx
  80148a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80148c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801490:	0f b6 00             	movzbl (%rax),%eax
  801493:	84 c0                	test   %al,%al
  801495:	74 05                	je     80149c <strncpy+0x4b>
			src++;
  801497:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80149c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014a9:	72 cc                	jb     801477 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014af:	c9                   	leaveq 
  8014b0:	c3                   	retq   

00000000008014b1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014b1:	55                   	push   %rbp
  8014b2:	48 89 e5             	mov    %rsp,%rbp
  8014b5:	48 83 ec 28          	sub    $0x28,%rsp
  8014b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8014cd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014d2:	74 3d                	je     801511 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8014d4:	eb 1d                	jmp    8014f3 <strlcpy+0x42>
			*dst++ = *src++;
  8014d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014da:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014de:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014e2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014e6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014ea:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8014ee:	0f b6 12             	movzbl (%rdx),%edx
  8014f1:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014f3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8014f8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014fd:	74 0b                	je     80150a <strlcpy+0x59>
  8014ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801503:	0f b6 00             	movzbl (%rax),%eax
  801506:	84 c0                	test   %al,%al
  801508:	75 cc                	jne    8014d6 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80150a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801511:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801515:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801519:	48 29 c2             	sub    %rax,%rdx
  80151c:	48 89 d0             	mov    %rdx,%rax
}
  80151f:	c9                   	leaveq 
  801520:	c3                   	retq   

0000000000801521 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801521:	55                   	push   %rbp
  801522:	48 89 e5             	mov    %rsp,%rbp
  801525:	48 83 ec 10          	sub    $0x10,%rsp
  801529:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80152d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801531:	eb 0a                	jmp    80153d <strcmp+0x1c>
		p++, q++;
  801533:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801538:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80153d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801541:	0f b6 00             	movzbl (%rax),%eax
  801544:	84 c0                	test   %al,%al
  801546:	74 12                	je     80155a <strcmp+0x39>
  801548:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154c:	0f b6 10             	movzbl (%rax),%edx
  80154f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801553:	0f b6 00             	movzbl (%rax),%eax
  801556:	38 c2                	cmp    %al,%dl
  801558:	74 d9                	je     801533 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80155a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155e:	0f b6 00             	movzbl (%rax),%eax
  801561:	0f b6 d0             	movzbl %al,%edx
  801564:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801568:	0f b6 00             	movzbl (%rax),%eax
  80156b:	0f b6 c0             	movzbl %al,%eax
  80156e:	29 c2                	sub    %eax,%edx
  801570:	89 d0                	mov    %edx,%eax
}
  801572:	c9                   	leaveq 
  801573:	c3                   	retq   

0000000000801574 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801574:	55                   	push   %rbp
  801575:	48 89 e5             	mov    %rsp,%rbp
  801578:	48 83 ec 18          	sub    $0x18,%rsp
  80157c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801580:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801584:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801588:	eb 0f                	jmp    801599 <strncmp+0x25>
		n--, p++, q++;
  80158a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80158f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801594:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801599:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80159e:	74 1d                	je     8015bd <strncmp+0x49>
  8015a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a4:	0f b6 00             	movzbl (%rax),%eax
  8015a7:	84 c0                	test   %al,%al
  8015a9:	74 12                	je     8015bd <strncmp+0x49>
  8015ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015af:	0f b6 10             	movzbl (%rax),%edx
  8015b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b6:	0f b6 00             	movzbl (%rax),%eax
  8015b9:	38 c2                	cmp    %al,%dl
  8015bb:	74 cd                	je     80158a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015bd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015c2:	75 07                	jne    8015cb <strncmp+0x57>
		return 0;
  8015c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c9:	eb 18                	jmp    8015e3 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015cf:	0f b6 00             	movzbl (%rax),%eax
  8015d2:	0f b6 d0             	movzbl %al,%edx
  8015d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d9:	0f b6 00             	movzbl (%rax),%eax
  8015dc:	0f b6 c0             	movzbl %al,%eax
  8015df:	29 c2                	sub    %eax,%edx
  8015e1:	89 d0                	mov    %edx,%eax
}
  8015e3:	c9                   	leaveq 
  8015e4:	c3                   	retq   

00000000008015e5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015e5:	55                   	push   %rbp
  8015e6:	48 89 e5             	mov    %rsp,%rbp
  8015e9:	48 83 ec 0c          	sub    $0xc,%rsp
  8015ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015f1:	89 f0                	mov    %esi,%eax
  8015f3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015f6:	eb 17                	jmp    80160f <strchr+0x2a>
		if (*s == c)
  8015f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015fc:	0f b6 00             	movzbl (%rax),%eax
  8015ff:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801602:	75 06                	jne    80160a <strchr+0x25>
			return (char *) s;
  801604:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801608:	eb 15                	jmp    80161f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80160a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80160f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801613:	0f b6 00             	movzbl (%rax),%eax
  801616:	84 c0                	test   %al,%al
  801618:	75 de                	jne    8015f8 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80161a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161f:	c9                   	leaveq 
  801620:	c3                   	retq   

0000000000801621 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801621:	55                   	push   %rbp
  801622:	48 89 e5             	mov    %rsp,%rbp
  801625:	48 83 ec 0c          	sub    $0xc,%rsp
  801629:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80162d:	89 f0                	mov    %esi,%eax
  80162f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801632:	eb 13                	jmp    801647 <strfind+0x26>
		if (*s == c)
  801634:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801638:	0f b6 00             	movzbl (%rax),%eax
  80163b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80163e:	75 02                	jne    801642 <strfind+0x21>
			break;
  801640:	eb 10                	jmp    801652 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801642:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801647:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80164b:	0f b6 00             	movzbl (%rax),%eax
  80164e:	84 c0                	test   %al,%al
  801650:	75 e2                	jne    801634 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801652:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801656:	c9                   	leaveq 
  801657:	c3                   	retq   

0000000000801658 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801658:	55                   	push   %rbp
  801659:	48 89 e5             	mov    %rsp,%rbp
  80165c:	48 83 ec 18          	sub    $0x18,%rsp
  801660:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801664:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801667:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80166b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801670:	75 06                	jne    801678 <memset+0x20>
		return v;
  801672:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801676:	eb 69                	jmp    8016e1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801678:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80167c:	83 e0 03             	and    $0x3,%eax
  80167f:	48 85 c0             	test   %rax,%rax
  801682:	75 48                	jne    8016cc <memset+0x74>
  801684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801688:	83 e0 03             	and    $0x3,%eax
  80168b:	48 85 c0             	test   %rax,%rax
  80168e:	75 3c                	jne    8016cc <memset+0x74>
		c &= 0xFF;
  801690:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801697:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80169a:	c1 e0 18             	shl    $0x18,%eax
  80169d:	89 c2                	mov    %eax,%edx
  80169f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016a2:	c1 e0 10             	shl    $0x10,%eax
  8016a5:	09 c2                	or     %eax,%edx
  8016a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016aa:	c1 e0 08             	shl    $0x8,%eax
  8016ad:	09 d0                	or     %edx,%eax
  8016af:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8016b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b6:	48 c1 e8 02          	shr    $0x2,%rax
  8016ba:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016bd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016c4:	48 89 d7             	mov    %rdx,%rdi
  8016c7:	fc                   	cld    
  8016c8:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016ca:	eb 11                	jmp    8016dd <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8016cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016d3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016d7:	48 89 d7             	mov    %rdx,%rdi
  8016da:	fc                   	cld    
  8016db:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8016dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016e1:	c9                   	leaveq 
  8016e2:	c3                   	retq   

00000000008016e3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8016e3:	55                   	push   %rbp
  8016e4:	48 89 e5             	mov    %rsp,%rbp
  8016e7:	48 83 ec 28          	sub    $0x28,%rsp
  8016eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016f3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8016f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8016ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801703:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801707:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80170b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80170f:	0f 83 88 00 00 00    	jae    80179d <memmove+0xba>
  801715:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801719:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80171d:	48 01 d0             	add    %rdx,%rax
  801720:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801724:	76 77                	jbe    80179d <memmove+0xba>
		s += n;
  801726:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80172e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801732:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801736:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80173a:	83 e0 03             	and    $0x3,%eax
  80173d:	48 85 c0             	test   %rax,%rax
  801740:	75 3b                	jne    80177d <memmove+0x9a>
  801742:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801746:	83 e0 03             	and    $0x3,%eax
  801749:	48 85 c0             	test   %rax,%rax
  80174c:	75 2f                	jne    80177d <memmove+0x9a>
  80174e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801752:	83 e0 03             	and    $0x3,%eax
  801755:	48 85 c0             	test   %rax,%rax
  801758:	75 23                	jne    80177d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80175a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80175e:	48 83 e8 04          	sub    $0x4,%rax
  801762:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801766:	48 83 ea 04          	sub    $0x4,%rdx
  80176a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80176e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801772:	48 89 c7             	mov    %rax,%rdi
  801775:	48 89 d6             	mov    %rdx,%rsi
  801778:	fd                   	std    
  801779:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80177b:	eb 1d                	jmp    80179a <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80177d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801781:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801785:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801789:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80178d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801791:	48 89 d7             	mov    %rdx,%rdi
  801794:	48 89 c1             	mov    %rax,%rcx
  801797:	fd                   	std    
  801798:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80179a:	fc                   	cld    
  80179b:	eb 57                	jmp    8017f4 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80179d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a1:	83 e0 03             	and    $0x3,%eax
  8017a4:	48 85 c0             	test   %rax,%rax
  8017a7:	75 36                	jne    8017df <memmove+0xfc>
  8017a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ad:	83 e0 03             	and    $0x3,%eax
  8017b0:	48 85 c0             	test   %rax,%rax
  8017b3:	75 2a                	jne    8017df <memmove+0xfc>
  8017b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b9:	83 e0 03             	and    $0x3,%eax
  8017bc:	48 85 c0             	test   %rax,%rax
  8017bf:	75 1e                	jne    8017df <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c5:	48 c1 e8 02          	shr    $0x2,%rax
  8017c9:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8017cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017d0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017d4:	48 89 c7             	mov    %rax,%rdi
  8017d7:	48 89 d6             	mov    %rdx,%rsi
  8017da:	fc                   	cld    
  8017db:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017dd:	eb 15                	jmp    8017f4 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8017df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017e7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017eb:	48 89 c7             	mov    %rax,%rdi
  8017ee:	48 89 d6             	mov    %rdx,%rsi
  8017f1:	fc                   	cld    
  8017f2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8017f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017f8:	c9                   	leaveq 
  8017f9:	c3                   	retq   

00000000008017fa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8017fa:	55                   	push   %rbp
  8017fb:	48 89 e5             	mov    %rsp,%rbp
  8017fe:	48 83 ec 18          	sub    $0x18,%rsp
  801802:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801806:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80180a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80180e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801812:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801816:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80181a:	48 89 ce             	mov    %rcx,%rsi
  80181d:	48 89 c7             	mov    %rax,%rdi
  801820:	48 b8 e3 16 80 00 00 	movabs $0x8016e3,%rax
  801827:	00 00 00 
  80182a:	ff d0                	callq  *%rax
}
  80182c:	c9                   	leaveq 
  80182d:	c3                   	retq   

000000000080182e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80182e:	55                   	push   %rbp
  80182f:	48 89 e5             	mov    %rsp,%rbp
  801832:	48 83 ec 28          	sub    $0x28,%rsp
  801836:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80183a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80183e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801842:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801846:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80184a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80184e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801852:	eb 36                	jmp    80188a <memcmp+0x5c>
		if (*s1 != *s2)
  801854:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801858:	0f b6 10             	movzbl (%rax),%edx
  80185b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80185f:	0f b6 00             	movzbl (%rax),%eax
  801862:	38 c2                	cmp    %al,%dl
  801864:	74 1a                	je     801880 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801866:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80186a:	0f b6 00             	movzbl (%rax),%eax
  80186d:	0f b6 d0             	movzbl %al,%edx
  801870:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801874:	0f b6 00             	movzbl (%rax),%eax
  801877:	0f b6 c0             	movzbl %al,%eax
  80187a:	29 c2                	sub    %eax,%edx
  80187c:	89 d0                	mov    %edx,%eax
  80187e:	eb 20                	jmp    8018a0 <memcmp+0x72>
		s1++, s2++;
  801880:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801885:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80188a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801892:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801896:	48 85 c0             	test   %rax,%rax
  801899:	75 b9                	jne    801854 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a0:	c9                   	leaveq 
  8018a1:	c3                   	retq   

00000000008018a2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018a2:	55                   	push   %rbp
  8018a3:	48 89 e5             	mov    %rsp,%rbp
  8018a6:	48 83 ec 28          	sub    $0x28,%rsp
  8018aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018ae:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8018b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018bd:	48 01 d0             	add    %rdx,%rax
  8018c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018c4:	eb 15                	jmp    8018db <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ca:	0f b6 10             	movzbl (%rax),%edx
  8018cd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018d0:	38 c2                	cmp    %al,%dl
  8018d2:	75 02                	jne    8018d6 <memfind+0x34>
			break;
  8018d4:	eb 0f                	jmp    8018e5 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018d6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018df:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8018e3:	72 e1                	jb     8018c6 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8018e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018e9:	c9                   	leaveq 
  8018ea:	c3                   	retq   

00000000008018eb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018eb:	55                   	push   %rbp
  8018ec:	48 89 e5             	mov    %rsp,%rbp
  8018ef:	48 83 ec 34          	sub    $0x34,%rsp
  8018f3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018f7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018fb:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8018fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801905:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80190c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80190d:	eb 05                	jmp    801914 <strtol+0x29>
		s++;
  80190f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801914:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801918:	0f b6 00             	movzbl (%rax),%eax
  80191b:	3c 20                	cmp    $0x20,%al
  80191d:	74 f0                	je     80190f <strtol+0x24>
  80191f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801923:	0f b6 00             	movzbl (%rax),%eax
  801926:	3c 09                	cmp    $0x9,%al
  801928:	74 e5                	je     80190f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80192a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192e:	0f b6 00             	movzbl (%rax),%eax
  801931:	3c 2b                	cmp    $0x2b,%al
  801933:	75 07                	jne    80193c <strtol+0x51>
		s++;
  801935:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80193a:	eb 17                	jmp    801953 <strtol+0x68>
	else if (*s == '-')
  80193c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801940:	0f b6 00             	movzbl (%rax),%eax
  801943:	3c 2d                	cmp    $0x2d,%al
  801945:	75 0c                	jne    801953 <strtol+0x68>
		s++, neg = 1;
  801947:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80194c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801953:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801957:	74 06                	je     80195f <strtol+0x74>
  801959:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80195d:	75 28                	jne    801987 <strtol+0x9c>
  80195f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801963:	0f b6 00             	movzbl (%rax),%eax
  801966:	3c 30                	cmp    $0x30,%al
  801968:	75 1d                	jne    801987 <strtol+0x9c>
  80196a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196e:	48 83 c0 01          	add    $0x1,%rax
  801972:	0f b6 00             	movzbl (%rax),%eax
  801975:	3c 78                	cmp    $0x78,%al
  801977:	75 0e                	jne    801987 <strtol+0x9c>
		s += 2, base = 16;
  801979:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80197e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801985:	eb 2c                	jmp    8019b3 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801987:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80198b:	75 19                	jne    8019a6 <strtol+0xbb>
  80198d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801991:	0f b6 00             	movzbl (%rax),%eax
  801994:	3c 30                	cmp    $0x30,%al
  801996:	75 0e                	jne    8019a6 <strtol+0xbb>
		s++, base = 8;
  801998:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80199d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8019a4:	eb 0d                	jmp    8019b3 <strtol+0xc8>
	else if (base == 0)
  8019a6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019aa:	75 07                	jne    8019b3 <strtol+0xc8>
		base = 10;
  8019ac:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b7:	0f b6 00             	movzbl (%rax),%eax
  8019ba:	3c 2f                	cmp    $0x2f,%al
  8019bc:	7e 1d                	jle    8019db <strtol+0xf0>
  8019be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c2:	0f b6 00             	movzbl (%rax),%eax
  8019c5:	3c 39                	cmp    $0x39,%al
  8019c7:	7f 12                	jg     8019db <strtol+0xf0>
			dig = *s - '0';
  8019c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019cd:	0f b6 00             	movzbl (%rax),%eax
  8019d0:	0f be c0             	movsbl %al,%eax
  8019d3:	83 e8 30             	sub    $0x30,%eax
  8019d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019d9:	eb 4e                	jmp    801a29 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8019db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019df:	0f b6 00             	movzbl (%rax),%eax
  8019e2:	3c 60                	cmp    $0x60,%al
  8019e4:	7e 1d                	jle    801a03 <strtol+0x118>
  8019e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ea:	0f b6 00             	movzbl (%rax),%eax
  8019ed:	3c 7a                	cmp    $0x7a,%al
  8019ef:	7f 12                	jg     801a03 <strtol+0x118>
			dig = *s - 'a' + 10;
  8019f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f5:	0f b6 00             	movzbl (%rax),%eax
  8019f8:	0f be c0             	movsbl %al,%eax
  8019fb:	83 e8 57             	sub    $0x57,%eax
  8019fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a01:	eb 26                	jmp    801a29 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a07:	0f b6 00             	movzbl (%rax),%eax
  801a0a:	3c 40                	cmp    $0x40,%al
  801a0c:	7e 48                	jle    801a56 <strtol+0x16b>
  801a0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a12:	0f b6 00             	movzbl (%rax),%eax
  801a15:	3c 5a                	cmp    $0x5a,%al
  801a17:	7f 3d                	jg     801a56 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1d:	0f b6 00             	movzbl (%rax),%eax
  801a20:	0f be c0             	movsbl %al,%eax
  801a23:	83 e8 37             	sub    $0x37,%eax
  801a26:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a29:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a2c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a2f:	7c 02                	jl     801a33 <strtol+0x148>
			break;
  801a31:	eb 23                	jmp    801a56 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a33:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a38:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a3b:	48 98                	cltq   
  801a3d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a42:	48 89 c2             	mov    %rax,%rdx
  801a45:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a48:	48 98                	cltq   
  801a4a:	48 01 d0             	add    %rdx,%rax
  801a4d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a51:	e9 5d ff ff ff       	jmpq   8019b3 <strtol+0xc8>

	if (endptr)
  801a56:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a5b:	74 0b                	je     801a68 <strtol+0x17d>
		*endptr = (char *) s;
  801a5d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a61:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a65:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a6c:	74 09                	je     801a77 <strtol+0x18c>
  801a6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a72:	48 f7 d8             	neg    %rax
  801a75:	eb 04                	jmp    801a7b <strtol+0x190>
  801a77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a7b:	c9                   	leaveq 
  801a7c:	c3                   	retq   

0000000000801a7d <strstr>:

char * strstr(const char *in, const char *str)
{
  801a7d:	55                   	push   %rbp
  801a7e:	48 89 e5             	mov    %rsp,%rbp
  801a81:	48 83 ec 30          	sub    $0x30,%rsp
  801a85:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a89:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801a8d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a91:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a95:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a99:	0f b6 00             	movzbl (%rax),%eax
  801a9c:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801a9f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801aa3:	75 06                	jne    801aab <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801aa5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa9:	eb 6b                	jmp    801b16 <strstr+0x99>

    len = strlen(str);
  801aab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801aaf:	48 89 c7             	mov    %rax,%rdi
  801ab2:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  801ab9:	00 00 00 
  801abc:	ff d0                	callq  *%rax
  801abe:	48 98                	cltq   
  801ac0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801ac4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801acc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ad0:	0f b6 00             	movzbl (%rax),%eax
  801ad3:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801ad6:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801ada:	75 07                	jne    801ae3 <strstr+0x66>
                return (char *) 0;
  801adc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae1:	eb 33                	jmp    801b16 <strstr+0x99>
        } while (sc != c);
  801ae3:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801ae7:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801aea:	75 d8                	jne    801ac4 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801aec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801af4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af8:	48 89 ce             	mov    %rcx,%rsi
  801afb:	48 89 c7             	mov    %rax,%rdi
  801afe:	48 b8 74 15 80 00 00 	movabs $0x801574,%rax
  801b05:	00 00 00 
  801b08:	ff d0                	callq  *%rax
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	75 b6                	jne    801ac4 <strstr+0x47>

    return (char *) (in - 1);
  801b0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b12:	48 83 e8 01          	sub    $0x1,%rax
}
  801b16:	c9                   	leaveq 
  801b17:	c3                   	retq   

0000000000801b18 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b18:	55                   	push   %rbp
  801b19:	48 89 e5             	mov    %rsp,%rbp
  801b1c:	53                   	push   %rbx
  801b1d:	48 83 ec 48          	sub    $0x48,%rsp
  801b21:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b24:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b27:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b2b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b2f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b33:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b37:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b3a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b3e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b42:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b46:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b4a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b4e:	4c 89 c3             	mov    %r8,%rbx
  801b51:	cd 30                	int    $0x30
  801b53:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801b57:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b5b:	74 3e                	je     801b9b <syscall+0x83>
  801b5d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b62:	7e 37                	jle    801b9b <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b64:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b68:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b6b:	49 89 d0             	mov    %rdx,%r8
  801b6e:	89 c1                	mov    %eax,%ecx
  801b70:	48 ba 80 43 80 00 00 	movabs $0x804380,%rdx
  801b77:	00 00 00 
  801b7a:	be 23 00 00 00       	mov    $0x23,%esi
  801b7f:	48 bf 9d 43 80 00 00 	movabs $0x80439d,%rdi
  801b86:	00 00 00 
  801b89:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8e:	49 b9 de 03 80 00 00 	movabs $0x8003de,%r9
  801b95:	00 00 00 
  801b98:	41 ff d1             	callq  *%r9

	return ret;
  801b9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b9f:	48 83 c4 48          	add    $0x48,%rsp
  801ba3:	5b                   	pop    %rbx
  801ba4:	5d                   	pop    %rbp
  801ba5:	c3                   	retq   

0000000000801ba6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801ba6:	55                   	push   %rbp
  801ba7:	48 89 e5             	mov    %rsp,%rbp
  801baa:	48 83 ec 20          	sub    $0x20,%rsp
  801bae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bb2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801bb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bbe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc5:	00 
  801bc6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bcc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd2:	48 89 d1             	mov    %rdx,%rcx
  801bd5:	48 89 c2             	mov    %rax,%rdx
  801bd8:	be 00 00 00 00       	mov    $0x0,%esi
  801bdd:	bf 00 00 00 00       	mov    $0x0,%edi
  801be2:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  801be9:	00 00 00 
  801bec:	ff d0                	callq  *%rax
}
  801bee:	c9                   	leaveq 
  801bef:	c3                   	retq   

0000000000801bf0 <sys_cgetc>:

int
sys_cgetc(void)
{
  801bf0:	55                   	push   %rbp
  801bf1:	48 89 e5             	mov    %rsp,%rbp
  801bf4:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801bf8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bff:	00 
  801c00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c11:	ba 00 00 00 00       	mov    $0x0,%edx
  801c16:	be 00 00 00 00       	mov    $0x0,%esi
  801c1b:	bf 01 00 00 00       	mov    $0x1,%edi
  801c20:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  801c27:	00 00 00 
  801c2a:	ff d0                	callq  *%rax
}
  801c2c:	c9                   	leaveq 
  801c2d:	c3                   	retq   

0000000000801c2e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c2e:	55                   	push   %rbp
  801c2f:	48 89 e5             	mov    %rsp,%rbp
  801c32:	48 83 ec 10          	sub    $0x10,%rsp
  801c36:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c3c:	48 98                	cltq   
  801c3e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c45:	00 
  801c46:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c4c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c52:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c57:	48 89 c2             	mov    %rax,%rdx
  801c5a:	be 01 00 00 00       	mov    $0x1,%esi
  801c5f:	bf 03 00 00 00       	mov    $0x3,%edi
  801c64:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  801c6b:	00 00 00 
  801c6e:	ff d0                	callq  *%rax
}
  801c70:	c9                   	leaveq 
  801c71:	c3                   	retq   

0000000000801c72 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c72:	55                   	push   %rbp
  801c73:	48 89 e5             	mov    %rsp,%rbp
  801c76:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c7a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c81:	00 
  801c82:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c88:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c93:	ba 00 00 00 00       	mov    $0x0,%edx
  801c98:	be 00 00 00 00       	mov    $0x0,%esi
  801c9d:	bf 02 00 00 00       	mov    $0x2,%edi
  801ca2:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  801ca9:	00 00 00 
  801cac:	ff d0                	callq  *%rax
}
  801cae:	c9                   	leaveq 
  801caf:	c3                   	retq   

0000000000801cb0 <sys_yield>:

void
sys_yield(void)
{
  801cb0:	55                   	push   %rbp
  801cb1:	48 89 e5             	mov    %rsp,%rbp
  801cb4:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801cb8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cbf:	00 
  801cc0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cc6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ccc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cd1:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd6:	be 00 00 00 00       	mov    $0x0,%esi
  801cdb:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ce0:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  801ce7:	00 00 00 
  801cea:	ff d0                	callq  *%rax
}
  801cec:	c9                   	leaveq 
  801ced:	c3                   	retq   

0000000000801cee <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801cee:	55                   	push   %rbp
  801cef:	48 89 e5             	mov    %rsp,%rbp
  801cf2:	48 83 ec 20          	sub    $0x20,%rsp
  801cf6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cf9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cfd:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d00:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d03:	48 63 c8             	movslq %eax,%rcx
  801d06:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d0d:	48 98                	cltq   
  801d0f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d16:	00 
  801d17:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d1d:	49 89 c8             	mov    %rcx,%r8
  801d20:	48 89 d1             	mov    %rdx,%rcx
  801d23:	48 89 c2             	mov    %rax,%rdx
  801d26:	be 01 00 00 00       	mov    $0x1,%esi
  801d2b:	bf 04 00 00 00       	mov    $0x4,%edi
  801d30:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  801d37:	00 00 00 
  801d3a:	ff d0                	callq  *%rax
}
  801d3c:	c9                   	leaveq 
  801d3d:	c3                   	retq   

0000000000801d3e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d3e:	55                   	push   %rbp
  801d3f:	48 89 e5             	mov    %rsp,%rbp
  801d42:	48 83 ec 30          	sub    $0x30,%rsp
  801d46:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d49:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d4d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d50:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d54:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d58:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d5b:	48 63 c8             	movslq %eax,%rcx
  801d5e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d62:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d65:	48 63 f0             	movslq %eax,%rsi
  801d68:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d6f:	48 98                	cltq   
  801d71:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d75:	49 89 f9             	mov    %rdi,%r9
  801d78:	49 89 f0             	mov    %rsi,%r8
  801d7b:	48 89 d1             	mov    %rdx,%rcx
  801d7e:	48 89 c2             	mov    %rax,%rdx
  801d81:	be 01 00 00 00       	mov    $0x1,%esi
  801d86:	bf 05 00 00 00       	mov    $0x5,%edi
  801d8b:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  801d92:	00 00 00 
  801d95:	ff d0                	callq  *%rax
}
  801d97:	c9                   	leaveq 
  801d98:	c3                   	retq   

0000000000801d99 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801d99:	55                   	push   %rbp
  801d9a:	48 89 e5             	mov    %rsp,%rbp
  801d9d:	48 83 ec 20          	sub    $0x20,%rsp
  801da1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801da4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801da8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801daf:	48 98                	cltq   
  801db1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db8:	00 
  801db9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dbf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dc5:	48 89 d1             	mov    %rdx,%rcx
  801dc8:	48 89 c2             	mov    %rax,%rdx
  801dcb:	be 01 00 00 00       	mov    $0x1,%esi
  801dd0:	bf 06 00 00 00       	mov    $0x6,%edi
  801dd5:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  801ddc:	00 00 00 
  801ddf:	ff d0                	callq  *%rax
}
  801de1:	c9                   	leaveq 
  801de2:	c3                   	retq   

0000000000801de3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801de3:	55                   	push   %rbp
  801de4:	48 89 e5             	mov    %rsp,%rbp
  801de7:	48 83 ec 10          	sub    $0x10,%rsp
  801deb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dee:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801df1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801df4:	48 63 d0             	movslq %eax,%rdx
  801df7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dfa:	48 98                	cltq   
  801dfc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e03:	00 
  801e04:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e0a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e10:	48 89 d1             	mov    %rdx,%rcx
  801e13:	48 89 c2             	mov    %rax,%rdx
  801e16:	be 01 00 00 00       	mov    $0x1,%esi
  801e1b:	bf 08 00 00 00       	mov    $0x8,%edi
  801e20:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  801e27:	00 00 00 
  801e2a:	ff d0                	callq  *%rax
}
  801e2c:	c9                   	leaveq 
  801e2d:	c3                   	retq   

0000000000801e2e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e2e:	55                   	push   %rbp
  801e2f:	48 89 e5             	mov    %rsp,%rbp
  801e32:	48 83 ec 20          	sub    $0x20,%rsp
  801e36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e44:	48 98                	cltq   
  801e46:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e4d:	00 
  801e4e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e54:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e5a:	48 89 d1             	mov    %rdx,%rcx
  801e5d:	48 89 c2             	mov    %rax,%rdx
  801e60:	be 01 00 00 00       	mov    $0x1,%esi
  801e65:	bf 09 00 00 00       	mov    $0x9,%edi
  801e6a:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  801e71:	00 00 00 
  801e74:	ff d0                	callq  *%rax
}
  801e76:	c9                   	leaveq 
  801e77:	c3                   	retq   

0000000000801e78 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e78:	55                   	push   %rbp
  801e79:	48 89 e5             	mov    %rsp,%rbp
  801e7c:	48 83 ec 20          	sub    $0x20,%rsp
  801e80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801e87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e8e:	48 98                	cltq   
  801e90:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e97:	00 
  801e98:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e9e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ea4:	48 89 d1             	mov    %rdx,%rcx
  801ea7:	48 89 c2             	mov    %rax,%rdx
  801eaa:	be 01 00 00 00       	mov    $0x1,%esi
  801eaf:	bf 0a 00 00 00       	mov    $0xa,%edi
  801eb4:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  801ebb:	00 00 00 
  801ebe:	ff d0                	callq  *%rax
}
  801ec0:	c9                   	leaveq 
  801ec1:	c3                   	retq   

0000000000801ec2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ec2:	55                   	push   %rbp
  801ec3:	48 89 e5             	mov    %rsp,%rbp
  801ec6:	48 83 ec 20          	sub    $0x20,%rsp
  801eca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ecd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ed1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ed5:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ed8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801edb:	48 63 f0             	movslq %eax,%rsi
  801ede:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ee2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee5:	48 98                	cltq   
  801ee7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eeb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ef2:	00 
  801ef3:	49 89 f1             	mov    %rsi,%r9
  801ef6:	49 89 c8             	mov    %rcx,%r8
  801ef9:	48 89 d1             	mov    %rdx,%rcx
  801efc:	48 89 c2             	mov    %rax,%rdx
  801eff:	be 00 00 00 00       	mov    $0x0,%esi
  801f04:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f09:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  801f10:	00 00 00 
  801f13:	ff d0                	callq  *%rax
}
  801f15:	c9                   	leaveq 
  801f16:	c3                   	retq   

0000000000801f17 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f17:	55                   	push   %rbp
  801f18:	48 89 e5             	mov    %rsp,%rbp
  801f1b:	48 83 ec 10          	sub    $0x10,%rsp
  801f1f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f2e:	00 
  801f2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f40:	48 89 c2             	mov    %rax,%rdx
  801f43:	be 01 00 00 00       	mov    $0x1,%esi
  801f48:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f4d:	48 b8 18 1b 80 00 00 	movabs $0x801b18,%rax
  801f54:	00 00 00 
  801f57:	ff d0                	callq  *%rax
}
  801f59:	c9                   	leaveq 
  801f5a:	c3                   	retq   

0000000000801f5b <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801f5b:	55                   	push   %rbp
  801f5c:	48 89 e5             	mov    %rsp,%rbp
  801f5f:	48 83 ec 30          	sub    $0x30,%rsp
  801f63:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801f67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f6b:	48 8b 00             	mov    (%rax),%rax
  801f6e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801f72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f76:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f7a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)))
  801f7d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f80:	83 e0 02             	and    $0x2,%eax
  801f83:	85 c0                	test   %eax,%eax
  801f85:	74 23                	je     801faa <pgfault+0x4f>
  801f87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f8b:	48 c1 e8 0c          	shr    $0xc,%rax
  801f8f:	48 89 c2             	mov    %rax,%rdx
  801f92:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f99:	01 00 00 
  801f9c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fa0:	25 00 08 00 00       	and    $0x800,%eax
  801fa5:	48 85 c0             	test   %rax,%rax
  801fa8:	75 2a                	jne    801fd4 <pgfault+0x79>
		panic("fail check at fork pgfault");
  801faa:	48 ba ab 43 80 00 00 	movabs $0x8043ab,%rdx
  801fb1:	00 00 00 
  801fb4:	be 1d 00 00 00       	mov    $0x1d,%esi
  801fb9:	48 bf c6 43 80 00 00 	movabs $0x8043c6,%rdi
  801fc0:	00 00 00 
  801fc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc8:	48 b9 de 03 80 00 00 	movabs $0x8003de,%rcx
  801fcf:	00 00 00 
  801fd2:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801fd4:	ba 07 00 00 00       	mov    $0x7,%edx
  801fd9:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fde:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe3:	48 b8 ee 1c 80 00 00 	movabs $0x801cee,%rax
  801fea:	00 00 00 
  801fed:	ff d0                	callq  *%rax

	addr = ROUNDDOWN(addr, PGSIZE);
  801fef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ff3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801ff7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ffb:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802001:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memmove(PFTEMP, addr, PGSIZE);
  802005:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802009:	ba 00 10 00 00       	mov    $0x1000,%edx
  80200e:	48 89 c6             	mov    %rax,%rsi
  802011:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802016:	48 b8 e3 16 80 00 00 	movabs $0x8016e3,%rax
  80201d:	00 00 00 
  802020:	ff d0                	callq  *%rax

	sys_page_map(0, (void *)PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W);
  802022:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802026:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80202c:	48 89 c1             	mov    %rax,%rcx
  80202f:	ba 00 00 00 00       	mov    $0x0,%edx
  802034:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802039:	bf 00 00 00 00       	mov    $0x0,%edi
  80203e:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  802045:	00 00 00 
  802048:	ff d0                	callq  *%rax
	sys_page_unmap(0, PFTEMP);
  80204a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80204f:	bf 00 00 00 00       	mov    $0x0,%edi
  802054:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  80205b:	00 00 00 
  80205e:	ff d0                	callq  *%rax
	//panic("pgfault not implemented");
}
  802060:	c9                   	leaveq 
  802061:	c3                   	retq   

0000000000802062 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802062:	55                   	push   %rbp
  802063:	48 89 e5             	mov    %rsp,%rbp
  802066:	48 83 ec 20          	sub    $0x20,%rsp
  80206a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80206d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uintptr_t)pn * PGSIZE);
  802070:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802073:	48 c1 e0 0c          	shl    $0xc,%rax
  802077:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	// note: modified for LAB 5, supporting PTE_SHARE
	if (uvpt[pn] & PTE_SHARE) {
  80207b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802082:	01 00 00 
  802085:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802088:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80208c:	25 00 04 00 00       	and    $0x400,%eax
  802091:	48 85 c0             	test   %rax,%rax
  802094:	74 55                	je     8020eb <duppage+0x89>
		if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL))) < 0)
  802096:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80209d:	01 00 00 
  8020a0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8020a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020a7:	25 07 0e 00 00       	and    $0xe07,%eax
  8020ac:	89 c6                	mov    %eax,%esi
  8020ae:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8020b2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020b9:	41 89 f0             	mov    %esi,%r8d
  8020bc:	48 89 c6             	mov    %rax,%rsi
  8020bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c4:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  8020cb:	00 00 00 
  8020ce:	ff d0                	callq  *%rax
  8020d0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8020d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8020d7:	79 08                	jns    8020e1 <duppage+0x7f>
			return r;
  8020d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020dc:	e9 e1 00 00 00       	jmpq   8021c2 <duppage+0x160>
		return 0;
  8020e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e6:	e9 d7 00 00 00       	jmpq   8021c2 <duppage+0x160>
	}

	// note: here we must set ~PTE_W and PTE_COW such that parent process can get correct pid
	if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  8020eb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020f2:	01 00 00 
  8020f5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8020f8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020fc:	25 05 06 00 00       	and    $0x605,%eax
  802101:	80 cc 08             	or     $0x8,%ah
  802104:	89 c6                	mov    %eax,%esi
  802106:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80210a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80210d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802111:	41 89 f0             	mov    %esi,%r8d
  802114:	48 89 c6             	mov    %rax,%rsi
  802117:	bf 00 00 00 00       	mov    $0x0,%edi
  80211c:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  802123:	00 00 00 
  802126:	ff d0                	callq  *%rax
  802128:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80212b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80212f:	79 08                	jns    802139 <duppage+0xd7>
		return r;
  802131:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802134:	e9 89 00 00 00       	jmpq   8021c2 <duppage+0x160>

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  802139:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802140:	01 00 00 
  802143:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802146:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80214a:	83 e0 02             	and    $0x2,%eax
  80214d:	48 85 c0             	test   %rax,%rax
  802150:	75 1b                	jne    80216d <duppage+0x10b>
  802152:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802159:	01 00 00 
  80215c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80215f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802163:	25 00 08 00 00       	and    $0x800,%eax
  802168:	48 85 c0             	test   %rax,%rax
  80216b:	74 50                	je     8021bd <duppage+0x15b>
		if ((r = sys_page_map(0, addr, 0, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  80216d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802174:	01 00 00 
  802177:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80217a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80217e:	25 05 06 00 00       	and    $0x605,%eax
  802183:	80 cc 08             	or     $0x8,%ah
  802186:	89 c1                	mov    %eax,%ecx
  802188:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80218c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802190:	41 89 c8             	mov    %ecx,%r8d
  802193:	48 89 d1             	mov    %rdx,%rcx
  802196:	ba 00 00 00 00       	mov    $0x0,%edx
  80219b:	48 89 c6             	mov    %rax,%rsi
  80219e:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a3:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  8021aa:	00 00 00 
  8021ad:	ff d0                	callq  *%rax
  8021af:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8021b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8021b6:	79 05                	jns    8021bd <duppage+0x15b>
			return r;
  8021b8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021bb:	eb 05                	jmp    8021c2 <duppage+0x160>
	//panic("duppage not implemented");
	return 0;
  8021bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021c2:	c9                   	leaveq 
  8021c3:	c3                   	retq   

00000000008021c4 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8021c4:	55                   	push   %rbp
  8021c5:	48 89 e5             	mov    %rsp,%rbp
  8021c8:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	int r;
	envid_t envid;
	int i, j, k, l, ptx = 0;
  8021cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	set_pgfault_handler(pgfault);
  8021d3:	48 bf 5b 1f 80 00 00 	movabs $0x801f5b,%rdi
  8021da:	00 00 00 
  8021dd:	48 b8 5a 3a 80 00 00 	movabs $0x803a5a,%rax
  8021e4:	00 00 00 
  8021e7:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8021e9:	b8 07 00 00 00       	mov    $0x7,%eax
  8021ee:	cd 30                	int    $0x30
  8021f0:	89 45 e0             	mov    %eax,-0x20(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8021f3:	8b 45 e0             	mov    -0x20(%rbp),%eax

	if ((envid = sys_exofork()) < 0)
  8021f6:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8021f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8021fd:	79 08                	jns    802207 <fork+0x43>
		return envid;
  8021ff:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802202:	e9 27 02 00 00       	jmpq   80242e <fork+0x26a>
	else if (envid == 0) {
  802207:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80220b:	75 46                	jne    802253 <fork+0x8f>
		thisenv = &envs[ENVX(sys_getenvid())];
  80220d:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  802214:	00 00 00 
  802217:	ff d0                	callq  *%rax
  802219:	25 ff 03 00 00       	and    $0x3ff,%eax
  80221e:	48 63 d0             	movslq %eax,%rdx
  802221:	48 89 d0             	mov    %rdx,%rax
  802224:	48 c1 e0 03          	shl    $0x3,%rax
  802228:	48 01 d0             	add    %rdx,%rax
  80222b:	48 c1 e0 05          	shl    $0x5,%rax
  80222f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802236:	00 00 00 
  802239:	48 01 c2             	add    %rax,%rdx
  80223c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802243:	00 00 00 
  802246:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802249:	b8 00 00 00 00       	mov    $0x0,%eax
  80224e:	e9 db 01 00 00       	jmpq   80242e <fork+0x26a>
	}

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802253:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802256:	ba 07 00 00 00       	mov    $0x7,%edx
  80225b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802260:	89 c7                	mov    %eax,%edi
  802262:	48 b8 ee 1c 80 00 00 	movabs $0x801cee,%rax
  802269:	00 00 00 
  80226c:	ff d0                	callq  *%rax
  80226e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802271:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802275:	79 08                	jns    80227f <fork+0xbb>
		return r;
  802277:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80227a:	e9 af 01 00 00       	jmpq   80242e <fork+0x26a>

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  80227f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802286:	e9 49 01 00 00       	jmpq   8023d4 <fork+0x210>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  80228b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80228e:	8d 90 ff ff ff 07    	lea    0x7ffffff(%rax),%edx
  802294:	85 c0                	test   %eax,%eax
  802296:	0f 48 c2             	cmovs  %edx,%eax
  802299:	c1 f8 1b             	sar    $0x1b,%eax
  80229c:	89 c2                	mov    %eax,%edx
  80229e:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8022a5:	01 00 00 
  8022a8:	48 63 d2             	movslq %edx,%rdx
  8022ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022af:	83 e0 01             	and    $0x1,%eax
  8022b2:	48 85 c0             	test   %rax,%rax
  8022b5:	75 0c                	jne    8022c3 <fork+0xff>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  8022b7:	81 45 ec 00 00 00 08 	addl   $0x8000000,-0x14(%rbp)
			continue;
  8022be:	e9 0d 01 00 00       	jmpq   8023d0 <fork+0x20c>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  8022c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8022ca:	e9 f4 00 00 00       	jmpq   8023c3 <fork+0x1ff>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  8022cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022d2:	8d 90 ff ff 03 00    	lea    0x3ffff(%rax),%edx
  8022d8:	85 c0                	test   %eax,%eax
  8022da:	0f 48 c2             	cmovs  %edx,%eax
  8022dd:	c1 f8 12             	sar    $0x12,%eax
  8022e0:	89 c2                	mov    %eax,%edx
  8022e2:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8022e9:	01 00 00 
  8022ec:	48 63 d2             	movslq %edx,%rdx
  8022ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f3:	83 e0 01             	and    $0x1,%eax
  8022f6:	48 85 c0             	test   %rax,%rax
  8022f9:	75 0c                	jne    802307 <fork+0x143>
				ptx += NPDENTRIES * NPTENTRIES;
  8022fb:	81 45 ec 00 00 04 00 	addl   $0x40000,-0x14(%rbp)
				continue;
  802302:	e9 b8 00 00 00       	jmpq   8023bf <fork+0x1fb>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  802307:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80230e:	e9 9f 00 00 00       	jmpq   8023b2 <fork+0x1ee>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  802313:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802316:	8d 90 ff 01 00 00    	lea    0x1ff(%rax),%edx
  80231c:	85 c0                	test   %eax,%eax
  80231e:	0f 48 c2             	cmovs  %edx,%eax
  802321:	c1 f8 09             	sar    $0x9,%eax
  802324:	89 c2                	mov    %eax,%edx
  802326:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80232d:	01 00 00 
  802330:	48 63 d2             	movslq %edx,%rdx
  802333:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802337:	83 e0 01             	and    $0x1,%eax
  80233a:	48 85 c0             	test   %rax,%rax
  80233d:	75 09                	jne    802348 <fork+0x184>
					ptx += NPTENTRIES;
  80233f:	81 45 ec 00 02 00 00 	addl   $0x200,-0x14(%rbp)
					continue;
  802346:	eb 66                	jmp    8023ae <fork+0x1ea>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  802348:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  80234f:	eb 54                	jmp    8023a5 <fork+0x1e1>
					if ((uvpt[ptx] & PTE_P) != 0)
  802351:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802358:	01 00 00 
  80235b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80235e:	48 63 d2             	movslq %edx,%rdx
  802361:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802365:	83 e0 01             	and    $0x1,%eax
  802368:	48 85 c0             	test   %rax,%rax
  80236b:	74 30                	je     80239d <fork+0x1d9>
						if (ptx != VPN(UXSTACKTOP - PGSIZE))
  80236d:	81 7d ec ff f7 0e 00 	cmpl   $0xef7ff,-0x14(%rbp)
  802374:	74 27                	je     80239d <fork+0x1d9>
							if ((r = duppage(envid, ptx)) < 0)
  802376:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802379:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80237c:	89 d6                	mov    %edx,%esi
  80237e:	89 c7                	mov    %eax,%edi
  802380:	48 b8 62 20 80 00 00 	movabs $0x802062,%rax
  802387:	00 00 00 
  80238a:	ff d0                	callq  *%rax
  80238c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80238f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802393:	79 08                	jns    80239d <fork+0x1d9>
								return r;
  802395:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802398:	e9 91 00 00 00       	jmpq   80242e <fork+0x26a>
					ptx++;
  80239d:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  8023a1:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8023a5:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
  8023ac:	7e a3                	jle    802351 <fork+0x18d>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  8023ae:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8023b2:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
  8023b9:	0f 8e 54 ff ff ff    	jle    802313 <fork+0x14f>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  8023bf:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8023c3:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
  8023ca:	0f 8e ff fe ff ff    	jle    8022cf <fork+0x10b>
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		return r;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  8023d0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023d8:	0f 84 ad fe ff ff    	je     80228b <fork+0xc7>
			}
		}
	}

	extern void _pgfault_upcall();
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8023de:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8023e1:	48 be c5 3a 80 00 00 	movabs $0x803ac5,%rsi
  8023e8:	00 00 00 
  8023eb:	89 c7                	mov    %eax,%edi
  8023ed:	48 b8 78 1e 80 00 00 	movabs $0x801e78,%rax
  8023f4:	00 00 00 
  8023f7:	ff d0                	callq  *%rax
  8023f9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8023fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802400:	79 05                	jns    802407 <fork+0x243>
		return r;
  802402:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802405:	eb 27                	jmp    80242e <fork+0x26a>
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802407:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80240a:	be 02 00 00 00       	mov    $0x2,%esi
  80240f:	89 c7                	mov    %eax,%edi
  802411:	48 b8 e3 1d 80 00 00 	movabs $0x801de3,%rax
  802418:	00 00 00 
  80241b:	ff d0                	callq  *%rax
  80241d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802420:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802424:	79 05                	jns    80242b <fork+0x267>
		return r;
  802426:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802429:	eb 03                	jmp    80242e <fork+0x26a>

	return envid;
  80242b:	8b 45 e8             	mov    -0x18(%rbp),%eax
	//panic("fork not implemented");
}
  80242e:	c9                   	leaveq 
  80242f:	c3                   	retq   

0000000000802430 <sfork>:

// Challenge!
int
sfork(void)
{
  802430:	55                   	push   %rbp
  802431:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802434:	48 ba d1 43 80 00 00 	movabs $0x8043d1,%rdx
  80243b:	00 00 00 
  80243e:	be a7 00 00 00       	mov    $0xa7,%esi
  802443:	48 bf c6 43 80 00 00 	movabs $0x8043c6,%rdi
  80244a:	00 00 00 
  80244d:	b8 00 00 00 00       	mov    $0x0,%eax
  802452:	48 b9 de 03 80 00 00 	movabs $0x8003de,%rcx
  802459:	00 00 00 
  80245c:	ff d1                	callq  *%rcx

000000000080245e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80245e:	55                   	push   %rbp
  80245f:	48 89 e5             	mov    %rsp,%rbp
  802462:	48 83 ec 08          	sub    $0x8,%rsp
  802466:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80246a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80246e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802475:	ff ff ff 
  802478:	48 01 d0             	add    %rdx,%rax
  80247b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80247f:	c9                   	leaveq 
  802480:	c3                   	retq   

0000000000802481 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802481:	55                   	push   %rbp
  802482:	48 89 e5             	mov    %rsp,%rbp
  802485:	48 83 ec 08          	sub    $0x8,%rsp
  802489:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80248d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802491:	48 89 c7             	mov    %rax,%rdi
  802494:	48 b8 5e 24 80 00 00 	movabs $0x80245e,%rax
  80249b:	00 00 00 
  80249e:	ff d0                	callq  *%rax
  8024a0:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8024a6:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8024aa:	c9                   	leaveq 
  8024ab:	c3                   	retq   

00000000008024ac <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8024ac:	55                   	push   %rbp
  8024ad:	48 89 e5             	mov    %rsp,%rbp
  8024b0:	48 83 ec 18          	sub    $0x18,%rsp
  8024b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024bf:	eb 6b                	jmp    80252c <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8024c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c4:	48 98                	cltq   
  8024c6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024cc:	48 c1 e0 0c          	shl    $0xc,%rax
  8024d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8024d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d8:	48 c1 e8 15          	shr    $0x15,%rax
  8024dc:	48 89 c2             	mov    %rax,%rdx
  8024df:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024e6:	01 00 00 
  8024e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024ed:	83 e0 01             	and    $0x1,%eax
  8024f0:	48 85 c0             	test   %rax,%rax
  8024f3:	74 21                	je     802516 <fd_alloc+0x6a>
  8024f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f9:	48 c1 e8 0c          	shr    $0xc,%rax
  8024fd:	48 89 c2             	mov    %rax,%rdx
  802500:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802507:	01 00 00 
  80250a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80250e:	83 e0 01             	and    $0x1,%eax
  802511:	48 85 c0             	test   %rax,%rax
  802514:	75 12                	jne    802528 <fd_alloc+0x7c>
			*fd_store = fd;
  802516:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80251a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80251e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802521:	b8 00 00 00 00       	mov    $0x0,%eax
  802526:	eb 1a                	jmp    802542 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802528:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80252c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802530:	7e 8f                	jle    8024c1 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802532:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802536:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80253d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802542:	c9                   	leaveq 
  802543:	c3                   	retq   

0000000000802544 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802544:	55                   	push   %rbp
  802545:	48 89 e5             	mov    %rsp,%rbp
  802548:	48 83 ec 20          	sub    $0x20,%rsp
  80254c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80254f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802553:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802557:	78 06                	js     80255f <fd_lookup+0x1b>
  802559:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80255d:	7e 07                	jle    802566 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80255f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802564:	eb 6c                	jmp    8025d2 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802566:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802569:	48 98                	cltq   
  80256b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802571:	48 c1 e0 0c          	shl    $0xc,%rax
  802575:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802579:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80257d:	48 c1 e8 15          	shr    $0x15,%rax
  802581:	48 89 c2             	mov    %rax,%rdx
  802584:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80258b:	01 00 00 
  80258e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802592:	83 e0 01             	and    $0x1,%eax
  802595:	48 85 c0             	test   %rax,%rax
  802598:	74 21                	je     8025bb <fd_lookup+0x77>
  80259a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80259e:	48 c1 e8 0c          	shr    $0xc,%rax
  8025a2:	48 89 c2             	mov    %rax,%rdx
  8025a5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025ac:	01 00 00 
  8025af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025b3:	83 e0 01             	and    $0x1,%eax
  8025b6:	48 85 c0             	test   %rax,%rax
  8025b9:	75 07                	jne    8025c2 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025c0:	eb 10                	jmp    8025d2 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8025c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025c6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025ca:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8025cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d2:	c9                   	leaveq 
  8025d3:	c3                   	retq   

00000000008025d4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8025d4:	55                   	push   %rbp
  8025d5:	48 89 e5             	mov    %rsp,%rbp
  8025d8:	48 83 ec 30          	sub    $0x30,%rsp
  8025dc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8025e0:	89 f0                	mov    %esi,%eax
  8025e2:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8025e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025e9:	48 89 c7             	mov    %rax,%rdi
  8025ec:	48 b8 5e 24 80 00 00 	movabs $0x80245e,%rax
  8025f3:	00 00 00 
  8025f6:	ff d0                	callq  *%rax
  8025f8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025fc:	48 89 d6             	mov    %rdx,%rsi
  8025ff:	89 c7                	mov    %eax,%edi
  802601:	48 b8 44 25 80 00 00 	movabs $0x802544,%rax
  802608:	00 00 00 
  80260b:	ff d0                	callq  *%rax
  80260d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802610:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802614:	78 0a                	js     802620 <fd_close+0x4c>
	    || fd != fd2)
  802616:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80261a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80261e:	74 12                	je     802632 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802620:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802624:	74 05                	je     80262b <fd_close+0x57>
  802626:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802629:	eb 05                	jmp    802630 <fd_close+0x5c>
  80262b:	b8 00 00 00 00       	mov    $0x0,%eax
  802630:	eb 69                	jmp    80269b <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802632:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802636:	8b 00                	mov    (%rax),%eax
  802638:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80263c:	48 89 d6             	mov    %rdx,%rsi
  80263f:	89 c7                	mov    %eax,%edi
  802641:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  802648:	00 00 00 
  80264b:	ff d0                	callq  *%rax
  80264d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802650:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802654:	78 2a                	js     802680 <fd_close+0xac>
		if (dev->dev_close)
  802656:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80265a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80265e:	48 85 c0             	test   %rax,%rax
  802661:	74 16                	je     802679 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802663:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802667:	48 8b 40 20          	mov    0x20(%rax),%rax
  80266b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80266f:	48 89 d7             	mov    %rdx,%rdi
  802672:	ff d0                	callq  *%rax
  802674:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802677:	eb 07                	jmp    802680 <fd_close+0xac>
		else
			r = 0;
  802679:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802680:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802684:	48 89 c6             	mov    %rax,%rsi
  802687:	bf 00 00 00 00       	mov    $0x0,%edi
  80268c:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  802693:	00 00 00 
  802696:	ff d0                	callq  *%rax
	return r;
  802698:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80269b:	c9                   	leaveq 
  80269c:	c3                   	retq   

000000000080269d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80269d:	55                   	push   %rbp
  80269e:	48 89 e5             	mov    %rsp,%rbp
  8026a1:	48 83 ec 20          	sub    $0x20,%rsp
  8026a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8026ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026b3:	eb 41                	jmp    8026f6 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8026b5:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026bc:	00 00 00 
  8026bf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026c2:	48 63 d2             	movslq %edx,%rdx
  8026c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026c9:	8b 00                	mov    (%rax),%eax
  8026cb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8026ce:	75 22                	jne    8026f2 <dev_lookup+0x55>
			*dev = devtab[i];
  8026d0:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026d7:	00 00 00 
  8026da:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026dd:	48 63 d2             	movslq %edx,%rdx
  8026e0:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8026e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026e8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f0:	eb 60                	jmp    802752 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8026f2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026f6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026fd:	00 00 00 
  802700:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802703:	48 63 d2             	movslq %edx,%rdx
  802706:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80270a:	48 85 c0             	test   %rax,%rax
  80270d:	75 a6                	jne    8026b5 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80270f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802716:	00 00 00 
  802719:	48 8b 00             	mov    (%rax),%rax
  80271c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802722:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802725:	89 c6                	mov    %eax,%esi
  802727:	48 bf e8 43 80 00 00 	movabs $0x8043e8,%rdi
  80272e:	00 00 00 
  802731:	b8 00 00 00 00       	mov    $0x0,%eax
  802736:	48 b9 17 06 80 00 00 	movabs $0x800617,%rcx
  80273d:	00 00 00 
  802740:	ff d1                	callq  *%rcx
	*dev = 0;
  802742:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802746:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80274d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802752:	c9                   	leaveq 
  802753:	c3                   	retq   

0000000000802754 <close>:

int
close(int fdnum)
{
  802754:	55                   	push   %rbp
  802755:	48 89 e5             	mov    %rsp,%rbp
  802758:	48 83 ec 20          	sub    $0x20,%rsp
  80275c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80275f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802763:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802766:	48 89 d6             	mov    %rdx,%rsi
  802769:	89 c7                	mov    %eax,%edi
  80276b:	48 b8 44 25 80 00 00 	movabs $0x802544,%rax
  802772:	00 00 00 
  802775:	ff d0                	callq  *%rax
  802777:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80277e:	79 05                	jns    802785 <close+0x31>
		return r;
  802780:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802783:	eb 18                	jmp    80279d <close+0x49>
	else
		return fd_close(fd, 1);
  802785:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802789:	be 01 00 00 00       	mov    $0x1,%esi
  80278e:	48 89 c7             	mov    %rax,%rdi
  802791:	48 b8 d4 25 80 00 00 	movabs $0x8025d4,%rax
  802798:	00 00 00 
  80279b:	ff d0                	callq  *%rax
}
  80279d:	c9                   	leaveq 
  80279e:	c3                   	retq   

000000000080279f <close_all>:

void
close_all(void)
{
  80279f:	55                   	push   %rbp
  8027a0:	48 89 e5             	mov    %rsp,%rbp
  8027a3:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8027a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027ae:	eb 15                	jmp    8027c5 <close_all+0x26>
		close(i);
  8027b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b3:	89 c7                	mov    %eax,%edi
  8027b5:	48 b8 54 27 80 00 00 	movabs $0x802754,%rax
  8027bc:	00 00 00 
  8027bf:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8027c1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027c5:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027c9:	7e e5                	jle    8027b0 <close_all+0x11>
		close(i);
}
  8027cb:	c9                   	leaveq 
  8027cc:	c3                   	retq   

00000000008027cd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8027cd:	55                   	push   %rbp
  8027ce:	48 89 e5             	mov    %rsp,%rbp
  8027d1:	48 83 ec 40          	sub    $0x40,%rsp
  8027d5:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8027d8:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8027db:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8027df:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027e2:	48 89 d6             	mov    %rdx,%rsi
  8027e5:	89 c7                	mov    %eax,%edi
  8027e7:	48 b8 44 25 80 00 00 	movabs $0x802544,%rax
  8027ee:	00 00 00 
  8027f1:	ff d0                	callq  *%rax
  8027f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027fa:	79 08                	jns    802804 <dup+0x37>
		return r;
  8027fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ff:	e9 70 01 00 00       	jmpq   802974 <dup+0x1a7>
	close(newfdnum);
  802804:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802807:	89 c7                	mov    %eax,%edi
  802809:	48 b8 54 27 80 00 00 	movabs $0x802754,%rax
  802810:	00 00 00 
  802813:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802815:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802818:	48 98                	cltq   
  80281a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802820:	48 c1 e0 0c          	shl    $0xc,%rax
  802824:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802828:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80282c:	48 89 c7             	mov    %rax,%rdi
  80282f:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  802836:	00 00 00 
  802839:	ff d0                	callq  *%rax
  80283b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80283f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802843:	48 89 c7             	mov    %rax,%rdi
  802846:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  80284d:	00 00 00 
  802850:	ff d0                	callq  *%rax
  802852:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802856:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80285a:	48 c1 e8 15          	shr    $0x15,%rax
  80285e:	48 89 c2             	mov    %rax,%rdx
  802861:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802868:	01 00 00 
  80286b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80286f:	83 e0 01             	and    $0x1,%eax
  802872:	48 85 c0             	test   %rax,%rax
  802875:	74 73                	je     8028ea <dup+0x11d>
  802877:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287b:	48 c1 e8 0c          	shr    $0xc,%rax
  80287f:	48 89 c2             	mov    %rax,%rdx
  802882:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802889:	01 00 00 
  80288c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802890:	83 e0 01             	and    $0x1,%eax
  802893:	48 85 c0             	test   %rax,%rax
  802896:	74 52                	je     8028ea <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289c:	48 c1 e8 0c          	shr    $0xc,%rax
  8028a0:	48 89 c2             	mov    %rax,%rdx
  8028a3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028aa:	01 00 00 
  8028ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028b1:	25 07 0e 00 00       	and    $0xe07,%eax
  8028b6:	89 c1                	mov    %eax,%ecx
  8028b8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c0:	41 89 c8             	mov    %ecx,%r8d
  8028c3:	48 89 d1             	mov    %rdx,%rcx
  8028c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8028cb:	48 89 c6             	mov    %rax,%rsi
  8028ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8028d3:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  8028da:	00 00 00 
  8028dd:	ff d0                	callq  *%rax
  8028df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e6:	79 02                	jns    8028ea <dup+0x11d>
			goto err;
  8028e8:	eb 57                	jmp    802941 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8028ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028ee:	48 c1 e8 0c          	shr    $0xc,%rax
  8028f2:	48 89 c2             	mov    %rax,%rdx
  8028f5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028fc:	01 00 00 
  8028ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802903:	25 07 0e 00 00       	and    $0xe07,%eax
  802908:	89 c1                	mov    %eax,%ecx
  80290a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80290e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802912:	41 89 c8             	mov    %ecx,%r8d
  802915:	48 89 d1             	mov    %rdx,%rcx
  802918:	ba 00 00 00 00       	mov    $0x0,%edx
  80291d:	48 89 c6             	mov    %rax,%rsi
  802920:	bf 00 00 00 00       	mov    $0x0,%edi
  802925:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  80292c:	00 00 00 
  80292f:	ff d0                	callq  *%rax
  802931:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802934:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802938:	79 02                	jns    80293c <dup+0x16f>
		goto err;
  80293a:	eb 05                	jmp    802941 <dup+0x174>

	return newfdnum;
  80293c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80293f:	eb 33                	jmp    802974 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802941:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802945:	48 89 c6             	mov    %rax,%rsi
  802948:	bf 00 00 00 00       	mov    $0x0,%edi
  80294d:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  802954:	00 00 00 
  802957:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802959:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80295d:	48 89 c6             	mov    %rax,%rsi
  802960:	bf 00 00 00 00       	mov    $0x0,%edi
  802965:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  80296c:	00 00 00 
  80296f:	ff d0                	callq  *%rax
	return r;
  802971:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802974:	c9                   	leaveq 
  802975:	c3                   	retq   

0000000000802976 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802976:	55                   	push   %rbp
  802977:	48 89 e5             	mov    %rsp,%rbp
  80297a:	48 83 ec 40          	sub    $0x40,%rsp
  80297e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802981:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802985:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802989:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80298d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802990:	48 89 d6             	mov    %rdx,%rsi
  802993:	89 c7                	mov    %eax,%edi
  802995:	48 b8 44 25 80 00 00 	movabs $0x802544,%rax
  80299c:	00 00 00 
  80299f:	ff d0                	callq  *%rax
  8029a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a8:	78 24                	js     8029ce <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ae:	8b 00                	mov    (%rax),%eax
  8029b0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029b4:	48 89 d6             	mov    %rdx,%rsi
  8029b7:	89 c7                	mov    %eax,%edi
  8029b9:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  8029c0:	00 00 00 
  8029c3:	ff d0                	callq  *%rax
  8029c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029cc:	79 05                	jns    8029d3 <read+0x5d>
		return r;
  8029ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d1:	eb 76                	jmp    802a49 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8029d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d7:	8b 40 08             	mov    0x8(%rax),%eax
  8029da:	83 e0 03             	and    $0x3,%eax
  8029dd:	83 f8 01             	cmp    $0x1,%eax
  8029e0:	75 3a                	jne    802a1c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8029e2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8029e9:	00 00 00 
  8029ec:	48 8b 00             	mov    (%rax),%rax
  8029ef:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029f5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029f8:	89 c6                	mov    %eax,%esi
  8029fa:	48 bf 07 44 80 00 00 	movabs $0x804407,%rdi
  802a01:	00 00 00 
  802a04:	b8 00 00 00 00       	mov    $0x0,%eax
  802a09:	48 b9 17 06 80 00 00 	movabs $0x800617,%rcx
  802a10:	00 00 00 
  802a13:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a1a:	eb 2d                	jmp    802a49 <read+0xd3>
	}
	if (!dev->dev_read)
  802a1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a20:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a24:	48 85 c0             	test   %rax,%rax
  802a27:	75 07                	jne    802a30 <read+0xba>
		return -E_NOT_SUPP;
  802a29:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a2e:	eb 19                	jmp    802a49 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a34:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a38:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a3c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a40:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a44:	48 89 cf             	mov    %rcx,%rdi
  802a47:	ff d0                	callq  *%rax
}
  802a49:	c9                   	leaveq 
  802a4a:	c3                   	retq   

0000000000802a4b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a4b:	55                   	push   %rbp
  802a4c:	48 89 e5             	mov    %rsp,%rbp
  802a4f:	48 83 ec 30          	sub    $0x30,%rsp
  802a53:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a5a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a65:	eb 49                	jmp    802ab0 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6a:	48 98                	cltq   
  802a6c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a70:	48 29 c2             	sub    %rax,%rdx
  802a73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a76:	48 63 c8             	movslq %eax,%rcx
  802a79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a7d:	48 01 c1             	add    %rax,%rcx
  802a80:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a83:	48 89 ce             	mov    %rcx,%rsi
  802a86:	89 c7                	mov    %eax,%edi
  802a88:	48 b8 76 29 80 00 00 	movabs $0x802976,%rax
  802a8f:	00 00 00 
  802a92:	ff d0                	callq  *%rax
  802a94:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802a97:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a9b:	79 05                	jns    802aa2 <readn+0x57>
			return m;
  802a9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aa0:	eb 1c                	jmp    802abe <readn+0x73>
		if (m == 0)
  802aa2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802aa6:	75 02                	jne    802aaa <readn+0x5f>
			break;
  802aa8:	eb 11                	jmp    802abb <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802aaa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aad:	01 45 fc             	add    %eax,-0x4(%rbp)
  802ab0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab3:	48 98                	cltq   
  802ab5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802ab9:	72 ac                	jb     802a67 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802abb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802abe:	c9                   	leaveq 
  802abf:	c3                   	retq   

0000000000802ac0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802ac0:	55                   	push   %rbp
  802ac1:	48 89 e5             	mov    %rsp,%rbp
  802ac4:	48 83 ec 40          	sub    $0x40,%rsp
  802ac8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802acb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802acf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ad3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ad7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ada:	48 89 d6             	mov    %rdx,%rsi
  802add:	89 c7                	mov    %eax,%edi
  802adf:	48 b8 44 25 80 00 00 	movabs $0x802544,%rax
  802ae6:	00 00 00 
  802ae9:	ff d0                	callq  *%rax
  802aeb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af2:	78 24                	js     802b18 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802af4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af8:	8b 00                	mov    (%rax),%eax
  802afa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802afe:	48 89 d6             	mov    %rdx,%rsi
  802b01:	89 c7                	mov    %eax,%edi
  802b03:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  802b0a:	00 00 00 
  802b0d:	ff d0                	callq  *%rax
  802b0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b16:	79 05                	jns    802b1d <write+0x5d>
		return r;
  802b18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1b:	eb 75                	jmp    802b92 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b21:	8b 40 08             	mov    0x8(%rax),%eax
  802b24:	83 e0 03             	and    $0x3,%eax
  802b27:	85 c0                	test   %eax,%eax
  802b29:	75 3a                	jne    802b65 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b2b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b32:	00 00 00 
  802b35:	48 8b 00             	mov    (%rax),%rax
  802b38:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b3e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b41:	89 c6                	mov    %eax,%esi
  802b43:	48 bf 23 44 80 00 00 	movabs $0x804423,%rdi
  802b4a:	00 00 00 
  802b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b52:	48 b9 17 06 80 00 00 	movabs $0x800617,%rcx
  802b59:	00 00 00 
  802b5c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b5e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b63:	eb 2d                	jmp    802b92 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b69:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b6d:	48 85 c0             	test   %rax,%rax
  802b70:	75 07                	jne    802b79 <write+0xb9>
		return -E_NOT_SUPP;
  802b72:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b77:	eb 19                	jmp    802b92 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b7d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b81:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b85:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b89:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b8d:	48 89 cf             	mov    %rcx,%rdi
  802b90:	ff d0                	callq  *%rax
}
  802b92:	c9                   	leaveq 
  802b93:	c3                   	retq   

0000000000802b94 <seek>:

int
seek(int fdnum, off_t offset)
{
  802b94:	55                   	push   %rbp
  802b95:	48 89 e5             	mov    %rsp,%rbp
  802b98:	48 83 ec 18          	sub    $0x18,%rsp
  802b9c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b9f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ba2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ba6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ba9:	48 89 d6             	mov    %rdx,%rsi
  802bac:	89 c7                	mov    %eax,%edi
  802bae:	48 b8 44 25 80 00 00 	movabs $0x802544,%rax
  802bb5:	00 00 00 
  802bb8:	ff d0                	callq  *%rax
  802bba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc1:	79 05                	jns    802bc8 <seek+0x34>
		return r;
  802bc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc6:	eb 0f                	jmp    802bd7 <seek+0x43>
	fd->fd_offset = offset;
  802bc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bcc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802bcf:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802bd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bd7:	c9                   	leaveq 
  802bd8:	c3                   	retq   

0000000000802bd9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802bd9:	55                   	push   %rbp
  802bda:	48 89 e5             	mov    %rsp,%rbp
  802bdd:	48 83 ec 30          	sub    $0x30,%rsp
  802be1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802be4:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802be7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802beb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bee:	48 89 d6             	mov    %rdx,%rsi
  802bf1:	89 c7                	mov    %eax,%edi
  802bf3:	48 b8 44 25 80 00 00 	movabs $0x802544,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	callq  *%rax
  802bff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c06:	78 24                	js     802c2c <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c0c:	8b 00                	mov    (%rax),%eax
  802c0e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c12:	48 89 d6             	mov    %rdx,%rsi
  802c15:	89 c7                	mov    %eax,%edi
  802c17:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	callq  *%rax
  802c23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c2a:	79 05                	jns    802c31 <ftruncate+0x58>
		return r;
  802c2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c2f:	eb 72                	jmp    802ca3 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c35:	8b 40 08             	mov    0x8(%rax),%eax
  802c38:	83 e0 03             	and    $0x3,%eax
  802c3b:	85 c0                	test   %eax,%eax
  802c3d:	75 3a                	jne    802c79 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c3f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802c46:	00 00 00 
  802c49:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c4c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c52:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c55:	89 c6                	mov    %eax,%esi
  802c57:	48 bf 40 44 80 00 00 	movabs $0x804440,%rdi
  802c5e:	00 00 00 
  802c61:	b8 00 00 00 00       	mov    $0x0,%eax
  802c66:	48 b9 17 06 80 00 00 	movabs $0x800617,%rcx
  802c6d:	00 00 00 
  802c70:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c77:	eb 2a                	jmp    802ca3 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c7d:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c81:	48 85 c0             	test   %rax,%rax
  802c84:	75 07                	jne    802c8d <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c86:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c8b:	eb 16                	jmp    802ca3 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c91:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c95:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c99:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802c9c:	89 ce                	mov    %ecx,%esi
  802c9e:	48 89 d7             	mov    %rdx,%rdi
  802ca1:	ff d0                	callq  *%rax
}
  802ca3:	c9                   	leaveq 
  802ca4:	c3                   	retq   

0000000000802ca5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802ca5:	55                   	push   %rbp
  802ca6:	48 89 e5             	mov    %rsp,%rbp
  802ca9:	48 83 ec 30          	sub    $0x30,%rsp
  802cad:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cb0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cb4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cb8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cbb:	48 89 d6             	mov    %rdx,%rsi
  802cbe:	89 c7                	mov    %eax,%edi
  802cc0:	48 b8 44 25 80 00 00 	movabs $0x802544,%rax
  802cc7:	00 00 00 
  802cca:	ff d0                	callq  *%rax
  802ccc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ccf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cd3:	78 24                	js     802cf9 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd9:	8b 00                	mov    (%rax),%eax
  802cdb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cdf:	48 89 d6             	mov    %rdx,%rsi
  802ce2:	89 c7                	mov    %eax,%edi
  802ce4:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  802ceb:	00 00 00 
  802cee:	ff d0                	callq  *%rax
  802cf0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf7:	79 05                	jns    802cfe <fstat+0x59>
		return r;
  802cf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfc:	eb 5e                	jmp    802d5c <fstat+0xb7>
	if (!dev->dev_stat)
  802cfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d02:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d06:	48 85 c0             	test   %rax,%rax
  802d09:	75 07                	jne    802d12 <fstat+0x6d>
		return -E_NOT_SUPP;
  802d0b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d10:	eb 4a                	jmp    802d5c <fstat+0xb7>
	stat->st_name[0] = 0;
  802d12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d16:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d19:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d1d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d24:	00 00 00 
	stat->st_isdir = 0;
  802d27:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d2b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d32:	00 00 00 
	stat->st_dev = dev;
  802d35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d39:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d3d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d48:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d4c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d50:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d54:	48 89 ce             	mov    %rcx,%rsi
  802d57:	48 89 d7             	mov    %rdx,%rdi
  802d5a:	ff d0                	callq  *%rax
}
  802d5c:	c9                   	leaveq 
  802d5d:	c3                   	retq   

0000000000802d5e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d5e:	55                   	push   %rbp
  802d5f:	48 89 e5             	mov    %rsp,%rbp
  802d62:	48 83 ec 20          	sub    $0x20,%rsp
  802d66:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d6a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d72:	be 00 00 00 00       	mov    $0x0,%esi
  802d77:	48 89 c7             	mov    %rax,%rdi
  802d7a:	48 b8 4c 2e 80 00 00 	movabs $0x802e4c,%rax
  802d81:	00 00 00 
  802d84:	ff d0                	callq  *%rax
  802d86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8d:	79 05                	jns    802d94 <stat+0x36>
		return fd;
  802d8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d92:	eb 2f                	jmp    802dc3 <stat+0x65>
	r = fstat(fd, stat);
  802d94:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d9b:	48 89 d6             	mov    %rdx,%rsi
  802d9e:	89 c7                	mov    %eax,%edi
  802da0:	48 b8 a5 2c 80 00 00 	movabs $0x802ca5,%rax
  802da7:	00 00 00 
  802daa:	ff d0                	callq  *%rax
  802dac:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802daf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db2:	89 c7                	mov    %eax,%edi
  802db4:	48 b8 54 27 80 00 00 	movabs $0x802754,%rax
  802dbb:	00 00 00 
  802dbe:	ff d0                	callq  *%rax
	return r;
  802dc0:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802dc3:	c9                   	leaveq 
  802dc4:	c3                   	retq   

0000000000802dc5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802dc5:	55                   	push   %rbp
  802dc6:	48 89 e5             	mov    %rsp,%rbp
  802dc9:	48 83 ec 10          	sub    $0x10,%rsp
  802dcd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802dd0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802dd4:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802ddb:	00 00 00 
  802dde:	8b 00                	mov    (%rax),%eax
  802de0:	85 c0                	test   %eax,%eax
  802de2:	75 1d                	jne    802e01 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802de4:	bf 01 00 00 00       	mov    $0x1,%edi
  802de9:	48 b8 b0 3c 80 00 00 	movabs $0x803cb0,%rax
  802df0:	00 00 00 
  802df3:	ff d0                	callq  *%rax
  802df5:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  802dfc:	00 00 00 
  802dff:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e01:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802e08:	00 00 00 
  802e0b:	8b 00                	mov    (%rax),%eax
  802e0d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e10:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e15:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802e1c:	00 00 00 
  802e1f:	89 c7                	mov    %eax,%edi
  802e21:	48 b8 18 3c 80 00 00 	movabs $0x803c18,%rax
  802e28:	00 00 00 
  802e2b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e31:	ba 00 00 00 00       	mov    $0x0,%edx
  802e36:	48 89 c6             	mov    %rax,%rsi
  802e39:	bf 00 00 00 00       	mov    $0x0,%edi
  802e3e:	48 b8 4f 3b 80 00 00 	movabs $0x803b4f,%rax
  802e45:	00 00 00 
  802e48:	ff d0                	callq  *%rax
}
  802e4a:	c9                   	leaveq 
  802e4b:	c3                   	retq   

0000000000802e4c <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e4c:	55                   	push   %rbp
  802e4d:	48 89 e5             	mov    %rsp,%rbp
  802e50:	48 83 ec 20          	sub    $0x20,%rsp
  802e54:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e58:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802e5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5f:	48 89 c7             	mov    %rax,%rdi
  802e62:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  802e69:	00 00 00 
  802e6c:	ff d0                	callq  *%rax
  802e6e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e73:	7e 0a                	jle    802e7f <open+0x33>
		return -E_BAD_PATH;
  802e75:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e7a:	e9 a5 00 00 00       	jmpq   802f24 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802e7f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e83:	48 89 c7             	mov    %rax,%rdi
  802e86:	48 b8 ac 24 80 00 00 	movabs $0x8024ac,%rax
  802e8d:	00 00 00 
  802e90:	ff d0                	callq  *%rax
  802e92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e99:	79 08                	jns    802ea3 <open+0x57>
		return r;
  802e9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e9e:	e9 81 00 00 00       	jmpq   802f24 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802ea3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea7:	48 89 c6             	mov    %rax,%rsi
  802eaa:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802eb1:	00 00 00 
  802eb4:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  802ebb:	00 00 00 
  802ebe:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802ec0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ec7:	00 00 00 
  802eca:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802ecd:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802ed3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed7:	48 89 c6             	mov    %rax,%rsi
  802eda:	bf 01 00 00 00       	mov    $0x1,%edi
  802edf:	48 b8 c5 2d 80 00 00 	movabs $0x802dc5,%rax
  802ee6:	00 00 00 
  802ee9:	ff d0                	callq  *%rax
  802eeb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ef2:	79 1d                	jns    802f11 <open+0xc5>
		fd_close(fd, 0);
  802ef4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef8:	be 00 00 00 00       	mov    $0x0,%esi
  802efd:	48 89 c7             	mov    %rax,%rdi
  802f00:	48 b8 d4 25 80 00 00 	movabs $0x8025d4,%rax
  802f07:	00 00 00 
  802f0a:	ff d0                	callq  *%rax
		return r;
  802f0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f0f:	eb 13                	jmp    802f24 <open+0xd8>
	}

	return fd2num(fd);
  802f11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f15:	48 89 c7             	mov    %rax,%rdi
  802f18:	48 b8 5e 24 80 00 00 	movabs $0x80245e,%rax
  802f1f:	00 00 00 
  802f22:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802f24:	c9                   	leaveq 
  802f25:	c3                   	retq   

0000000000802f26 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f26:	55                   	push   %rbp
  802f27:	48 89 e5             	mov    %rsp,%rbp
  802f2a:	48 83 ec 10          	sub    $0x10,%rsp
  802f2e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f36:	8b 50 0c             	mov    0xc(%rax),%edx
  802f39:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f40:	00 00 00 
  802f43:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f45:	be 00 00 00 00       	mov    $0x0,%esi
  802f4a:	bf 06 00 00 00       	mov    $0x6,%edi
  802f4f:	48 b8 c5 2d 80 00 00 	movabs $0x802dc5,%rax
  802f56:	00 00 00 
  802f59:	ff d0                	callq  *%rax
}
  802f5b:	c9                   	leaveq 
  802f5c:	c3                   	retq   

0000000000802f5d <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802f5d:	55                   	push   %rbp
  802f5e:	48 89 e5             	mov    %rsp,%rbp
  802f61:	48 83 ec 30          	sub    $0x30,%rsp
  802f65:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f69:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f6d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802f71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f75:	8b 50 0c             	mov    0xc(%rax),%edx
  802f78:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f7f:	00 00 00 
  802f82:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802f84:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f8b:	00 00 00 
  802f8e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f92:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802f96:	be 00 00 00 00       	mov    $0x0,%esi
  802f9b:	bf 03 00 00 00       	mov    $0x3,%edi
  802fa0:	48 b8 c5 2d 80 00 00 	movabs $0x802dc5,%rax
  802fa7:	00 00 00 
  802faa:	ff d0                	callq  *%rax
  802fac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802faf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fb3:	79 05                	jns    802fba <devfile_read+0x5d>
		return r;
  802fb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb8:	eb 26                	jmp    802fe0 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802fba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fbd:	48 63 d0             	movslq %eax,%rdx
  802fc0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fc4:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802fcb:	00 00 00 
  802fce:	48 89 c7             	mov    %rax,%rdi
  802fd1:	48 b8 e3 16 80 00 00 	movabs $0x8016e3,%rax
  802fd8:	00 00 00 
  802fdb:	ff d0                	callq  *%rax

	return r;
  802fdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802fe0:	c9                   	leaveq 
  802fe1:	c3                   	retq   

0000000000802fe2 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802fe2:	55                   	push   %rbp
  802fe3:	48 89 e5             	mov    %rsp,%rbp
  802fe6:	48 83 ec 30          	sub    $0x30,%rsp
  802fea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ff2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802ff6:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802ffd:	00 
  802ffe:	76 08                	jbe    803008 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  803000:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803007:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803008:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80300c:	8b 50 0c             	mov    0xc(%rax),%edx
  80300f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803016:	00 00 00 
  803019:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80301b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803022:	00 00 00 
  803025:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803029:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  80302d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803031:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803035:	48 89 c6             	mov    %rax,%rsi
  803038:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80303f:	00 00 00 
  803042:	48 b8 e3 16 80 00 00 	movabs $0x8016e3,%rax
  803049:	00 00 00 
  80304c:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80304e:	be 00 00 00 00       	mov    $0x0,%esi
  803053:	bf 04 00 00 00       	mov    $0x4,%edi
  803058:	48 b8 c5 2d 80 00 00 	movabs $0x802dc5,%rax
  80305f:	00 00 00 
  803062:	ff d0                	callq  *%rax
  803064:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803067:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80306b:	79 05                	jns    803072 <devfile_write+0x90>
		return r;
  80306d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803070:	eb 03                	jmp    803075 <devfile_write+0x93>

	return r;
  803072:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803075:	c9                   	leaveq 
  803076:	c3                   	retq   

0000000000803077 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803077:	55                   	push   %rbp
  803078:	48 89 e5             	mov    %rsp,%rbp
  80307b:	48 83 ec 20          	sub    $0x20,%rsp
  80307f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803083:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803087:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80308b:	8b 50 0c             	mov    0xc(%rax),%edx
  80308e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803095:	00 00 00 
  803098:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80309a:	be 00 00 00 00       	mov    $0x0,%esi
  80309f:	bf 05 00 00 00       	mov    $0x5,%edi
  8030a4:	48 b8 c5 2d 80 00 00 	movabs $0x802dc5,%rax
  8030ab:	00 00 00 
  8030ae:	ff d0                	callq  *%rax
  8030b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b7:	79 05                	jns    8030be <devfile_stat+0x47>
		return r;
  8030b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030bc:	eb 56                	jmp    803114 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8030be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030c2:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8030c9:	00 00 00 
  8030cc:	48 89 c7             	mov    %rax,%rdi
  8030cf:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  8030d6:	00 00 00 
  8030d9:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8030db:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030e2:	00 00 00 
  8030e5:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8030eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ef:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8030f5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030fc:	00 00 00 
  8030ff:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803105:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803109:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80310f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803114:	c9                   	leaveq 
  803115:	c3                   	retq   

0000000000803116 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803116:	55                   	push   %rbp
  803117:	48 89 e5             	mov    %rsp,%rbp
  80311a:	48 83 ec 10          	sub    $0x10,%rsp
  80311e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803122:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803125:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803129:	8b 50 0c             	mov    0xc(%rax),%edx
  80312c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803133:	00 00 00 
  803136:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803138:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80313f:	00 00 00 
  803142:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803145:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803148:	be 00 00 00 00       	mov    $0x0,%esi
  80314d:	bf 02 00 00 00       	mov    $0x2,%edi
  803152:	48 b8 c5 2d 80 00 00 	movabs $0x802dc5,%rax
  803159:	00 00 00 
  80315c:	ff d0                	callq  *%rax
}
  80315e:	c9                   	leaveq 
  80315f:	c3                   	retq   

0000000000803160 <remove>:

// Delete a file
int
remove(const char *path)
{
  803160:	55                   	push   %rbp
  803161:	48 89 e5             	mov    %rsp,%rbp
  803164:	48 83 ec 10          	sub    $0x10,%rsp
  803168:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80316c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803170:	48 89 c7             	mov    %rax,%rdi
  803173:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  80317a:	00 00 00 
  80317d:	ff d0                	callq  *%rax
  80317f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803184:	7e 07                	jle    80318d <remove+0x2d>
		return -E_BAD_PATH;
  803186:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80318b:	eb 33                	jmp    8031c0 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80318d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803191:	48 89 c6             	mov    %rax,%rsi
  803194:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80319b:	00 00 00 
  80319e:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  8031a5:	00 00 00 
  8031a8:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8031aa:	be 00 00 00 00       	mov    $0x0,%esi
  8031af:	bf 07 00 00 00       	mov    $0x7,%edi
  8031b4:	48 b8 c5 2d 80 00 00 	movabs $0x802dc5,%rax
  8031bb:	00 00 00 
  8031be:	ff d0                	callq  *%rax
}
  8031c0:	c9                   	leaveq 
  8031c1:	c3                   	retq   

00000000008031c2 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8031c2:	55                   	push   %rbp
  8031c3:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8031c6:	be 00 00 00 00       	mov    $0x0,%esi
  8031cb:	bf 08 00 00 00       	mov    $0x8,%edi
  8031d0:	48 b8 c5 2d 80 00 00 	movabs $0x802dc5,%rax
  8031d7:	00 00 00 
  8031da:	ff d0                	callq  *%rax
}
  8031dc:	5d                   	pop    %rbp
  8031dd:	c3                   	retq   

00000000008031de <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8031de:	55                   	push   %rbp
  8031df:	48 89 e5             	mov    %rsp,%rbp
  8031e2:	53                   	push   %rbx
  8031e3:	48 83 ec 38          	sub    $0x38,%rsp
  8031e7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8031eb:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8031ef:	48 89 c7             	mov    %rax,%rdi
  8031f2:	48 b8 ac 24 80 00 00 	movabs $0x8024ac,%rax
  8031f9:	00 00 00 
  8031fc:	ff d0                	callq  *%rax
  8031fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803201:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803205:	0f 88 bf 01 00 00    	js     8033ca <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80320b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80320f:	ba 07 04 00 00       	mov    $0x407,%edx
  803214:	48 89 c6             	mov    %rax,%rsi
  803217:	bf 00 00 00 00       	mov    $0x0,%edi
  80321c:	48 b8 ee 1c 80 00 00 	movabs $0x801cee,%rax
  803223:	00 00 00 
  803226:	ff d0                	callq  *%rax
  803228:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80322b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80322f:	0f 88 95 01 00 00    	js     8033ca <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803235:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803239:	48 89 c7             	mov    %rax,%rdi
  80323c:	48 b8 ac 24 80 00 00 	movabs $0x8024ac,%rax
  803243:	00 00 00 
  803246:	ff d0                	callq  *%rax
  803248:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80324b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80324f:	0f 88 5d 01 00 00    	js     8033b2 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803255:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803259:	ba 07 04 00 00       	mov    $0x407,%edx
  80325e:	48 89 c6             	mov    %rax,%rsi
  803261:	bf 00 00 00 00       	mov    $0x0,%edi
  803266:	48 b8 ee 1c 80 00 00 	movabs $0x801cee,%rax
  80326d:	00 00 00 
  803270:	ff d0                	callq  *%rax
  803272:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803275:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803279:	0f 88 33 01 00 00    	js     8033b2 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80327f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803283:	48 89 c7             	mov    %rax,%rdi
  803286:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  80328d:	00 00 00 
  803290:	ff d0                	callq  *%rax
  803292:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803296:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80329a:	ba 07 04 00 00       	mov    $0x407,%edx
  80329f:	48 89 c6             	mov    %rax,%rsi
  8032a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8032a7:	48 b8 ee 1c 80 00 00 	movabs $0x801cee,%rax
  8032ae:	00 00 00 
  8032b1:	ff d0                	callq  *%rax
  8032b3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032ba:	79 05                	jns    8032c1 <pipe+0xe3>
		goto err2;
  8032bc:	e9 d9 00 00 00       	jmpq   80339a <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032c5:	48 89 c7             	mov    %rax,%rdi
  8032c8:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  8032cf:	00 00 00 
  8032d2:	ff d0                	callq  *%rax
  8032d4:	48 89 c2             	mov    %rax,%rdx
  8032d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032db:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8032e1:	48 89 d1             	mov    %rdx,%rcx
  8032e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8032e9:	48 89 c6             	mov    %rax,%rsi
  8032ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8032f1:	48 b8 3e 1d 80 00 00 	movabs $0x801d3e,%rax
  8032f8:	00 00 00 
  8032fb:	ff d0                	callq  *%rax
  8032fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803300:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803304:	79 1b                	jns    803321 <pipe+0x143>
		goto err3;
  803306:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803307:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80330b:	48 89 c6             	mov    %rax,%rsi
  80330e:	bf 00 00 00 00       	mov    $0x0,%edi
  803313:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  80331a:	00 00 00 
  80331d:	ff d0                	callq  *%rax
  80331f:	eb 79                	jmp    80339a <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803321:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803325:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80332c:	00 00 00 
  80332f:	8b 12                	mov    (%rdx),%edx
  803331:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803333:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803337:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80333e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803342:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803349:	00 00 00 
  80334c:	8b 12                	mov    (%rdx),%edx
  80334e:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803350:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803354:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80335b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80335f:	48 89 c7             	mov    %rax,%rdi
  803362:	48 b8 5e 24 80 00 00 	movabs $0x80245e,%rax
  803369:	00 00 00 
  80336c:	ff d0                	callq  *%rax
  80336e:	89 c2                	mov    %eax,%edx
  803370:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803374:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803376:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80337a:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80337e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803382:	48 89 c7             	mov    %rax,%rdi
  803385:	48 b8 5e 24 80 00 00 	movabs $0x80245e,%rax
  80338c:	00 00 00 
  80338f:	ff d0                	callq  *%rax
  803391:	89 03                	mov    %eax,(%rbx)
	return 0;
  803393:	b8 00 00 00 00       	mov    $0x0,%eax
  803398:	eb 33                	jmp    8033cd <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  80339a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80339e:	48 89 c6             	mov    %rax,%rsi
  8033a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8033a6:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  8033ad:	00 00 00 
  8033b0:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8033b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033b6:	48 89 c6             	mov    %rax,%rsi
  8033b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8033be:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  8033c5:	00 00 00 
  8033c8:	ff d0                	callq  *%rax
    err:
	return r;
  8033ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8033cd:	48 83 c4 38          	add    $0x38,%rsp
  8033d1:	5b                   	pop    %rbx
  8033d2:	5d                   	pop    %rbp
  8033d3:	c3                   	retq   

00000000008033d4 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8033d4:	55                   	push   %rbp
  8033d5:	48 89 e5             	mov    %rsp,%rbp
  8033d8:	53                   	push   %rbx
  8033d9:	48 83 ec 28          	sub    $0x28,%rsp
  8033dd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033e1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8033e5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8033ec:	00 00 00 
  8033ef:	48 8b 00             	mov    (%rax),%rax
  8033f2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8033f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8033fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033ff:	48 89 c7             	mov    %rax,%rdi
  803402:	48 b8 32 3d 80 00 00 	movabs $0x803d32,%rax
  803409:	00 00 00 
  80340c:	ff d0                	callq  *%rax
  80340e:	89 c3                	mov    %eax,%ebx
  803410:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803414:	48 89 c7             	mov    %rax,%rdi
  803417:	48 b8 32 3d 80 00 00 	movabs $0x803d32,%rax
  80341e:	00 00 00 
  803421:	ff d0                	callq  *%rax
  803423:	39 c3                	cmp    %eax,%ebx
  803425:	0f 94 c0             	sete   %al
  803428:	0f b6 c0             	movzbl %al,%eax
  80342b:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80342e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803435:	00 00 00 
  803438:	48 8b 00             	mov    (%rax),%rax
  80343b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803441:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803444:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803447:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80344a:	75 05                	jne    803451 <_pipeisclosed+0x7d>
			return ret;
  80344c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80344f:	eb 4f                	jmp    8034a0 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803451:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803454:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803457:	74 42                	je     80349b <_pipeisclosed+0xc7>
  803459:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80345d:	75 3c                	jne    80349b <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80345f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803466:	00 00 00 
  803469:	48 8b 00             	mov    (%rax),%rax
  80346c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803472:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803475:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803478:	89 c6                	mov    %eax,%esi
  80347a:	48 bf 6b 44 80 00 00 	movabs $0x80446b,%rdi
  803481:	00 00 00 
  803484:	b8 00 00 00 00       	mov    $0x0,%eax
  803489:	49 b8 17 06 80 00 00 	movabs $0x800617,%r8
  803490:	00 00 00 
  803493:	41 ff d0             	callq  *%r8
	}
  803496:	e9 4a ff ff ff       	jmpq   8033e5 <_pipeisclosed+0x11>
  80349b:	e9 45 ff ff ff       	jmpq   8033e5 <_pipeisclosed+0x11>
}
  8034a0:	48 83 c4 28          	add    $0x28,%rsp
  8034a4:	5b                   	pop    %rbx
  8034a5:	5d                   	pop    %rbp
  8034a6:	c3                   	retq   

00000000008034a7 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8034a7:	55                   	push   %rbp
  8034a8:	48 89 e5             	mov    %rsp,%rbp
  8034ab:	48 83 ec 30          	sub    $0x30,%rsp
  8034af:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8034b2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8034b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8034b9:	48 89 d6             	mov    %rdx,%rsi
  8034bc:	89 c7                	mov    %eax,%edi
  8034be:	48 b8 44 25 80 00 00 	movabs $0x802544,%rax
  8034c5:	00 00 00 
  8034c8:	ff d0                	callq  *%rax
  8034ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034d1:	79 05                	jns    8034d8 <pipeisclosed+0x31>
		return r;
  8034d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d6:	eb 31                	jmp    803509 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8034d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034dc:	48 89 c7             	mov    %rax,%rdi
  8034df:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  8034e6:	00 00 00 
  8034e9:	ff d0                	callq  *%rax
  8034eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8034ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034f7:	48 89 d6             	mov    %rdx,%rsi
  8034fa:	48 89 c7             	mov    %rax,%rdi
  8034fd:	48 b8 d4 33 80 00 00 	movabs $0x8033d4,%rax
  803504:	00 00 00 
  803507:	ff d0                	callq  *%rax
}
  803509:	c9                   	leaveq 
  80350a:	c3                   	retq   

000000000080350b <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80350b:	55                   	push   %rbp
  80350c:	48 89 e5             	mov    %rsp,%rbp
  80350f:	48 83 ec 40          	sub    $0x40,%rsp
  803513:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803517:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80351b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80351f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803523:	48 89 c7             	mov    %rax,%rdi
  803526:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  80352d:	00 00 00 
  803530:	ff d0                	callq  *%rax
  803532:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803536:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80353a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80353e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803545:	00 
  803546:	e9 92 00 00 00       	jmpq   8035dd <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80354b:	eb 41                	jmp    80358e <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80354d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803552:	74 09                	je     80355d <devpipe_read+0x52>
				return i;
  803554:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803558:	e9 92 00 00 00       	jmpq   8035ef <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80355d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803561:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803565:	48 89 d6             	mov    %rdx,%rsi
  803568:	48 89 c7             	mov    %rax,%rdi
  80356b:	48 b8 d4 33 80 00 00 	movabs $0x8033d4,%rax
  803572:	00 00 00 
  803575:	ff d0                	callq  *%rax
  803577:	85 c0                	test   %eax,%eax
  803579:	74 07                	je     803582 <devpipe_read+0x77>
				return 0;
  80357b:	b8 00 00 00 00       	mov    $0x0,%eax
  803580:	eb 6d                	jmp    8035ef <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803582:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  803589:	00 00 00 
  80358c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80358e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803592:	8b 10                	mov    (%rax),%edx
  803594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803598:	8b 40 04             	mov    0x4(%rax),%eax
  80359b:	39 c2                	cmp    %eax,%edx
  80359d:	74 ae                	je     80354d <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80359f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035a7:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8035ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035af:	8b 00                	mov    (%rax),%eax
  8035b1:	99                   	cltd   
  8035b2:	c1 ea 1b             	shr    $0x1b,%edx
  8035b5:	01 d0                	add    %edx,%eax
  8035b7:	83 e0 1f             	and    $0x1f,%eax
  8035ba:	29 d0                	sub    %edx,%eax
  8035bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035c0:	48 98                	cltq   
  8035c2:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8035c7:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8035c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035cd:	8b 00                	mov    (%rax),%eax
  8035cf:	8d 50 01             	lea    0x1(%rax),%edx
  8035d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d6:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8035d8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035e1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8035e5:	0f 82 60 ff ff ff    	jb     80354b <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8035eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8035ef:	c9                   	leaveq 
  8035f0:	c3                   	retq   

00000000008035f1 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8035f1:	55                   	push   %rbp
  8035f2:	48 89 e5             	mov    %rsp,%rbp
  8035f5:	48 83 ec 40          	sub    $0x40,%rsp
  8035f9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035fd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803601:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803605:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803609:	48 89 c7             	mov    %rax,%rdi
  80360c:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  803613:	00 00 00 
  803616:	ff d0                	callq  *%rax
  803618:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80361c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803620:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803624:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80362b:	00 
  80362c:	e9 8e 00 00 00       	jmpq   8036bf <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803631:	eb 31                	jmp    803664 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803633:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803637:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80363b:	48 89 d6             	mov    %rdx,%rsi
  80363e:	48 89 c7             	mov    %rax,%rdi
  803641:	48 b8 d4 33 80 00 00 	movabs $0x8033d4,%rax
  803648:	00 00 00 
  80364b:	ff d0                	callq  *%rax
  80364d:	85 c0                	test   %eax,%eax
  80364f:	74 07                	je     803658 <devpipe_write+0x67>
				return 0;
  803651:	b8 00 00 00 00       	mov    $0x0,%eax
  803656:	eb 79                	jmp    8036d1 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803658:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  80365f:	00 00 00 
  803662:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803664:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803668:	8b 40 04             	mov    0x4(%rax),%eax
  80366b:	48 63 d0             	movslq %eax,%rdx
  80366e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803672:	8b 00                	mov    (%rax),%eax
  803674:	48 98                	cltq   
  803676:	48 83 c0 20          	add    $0x20,%rax
  80367a:	48 39 c2             	cmp    %rax,%rdx
  80367d:	73 b4                	jae    803633 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80367f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803683:	8b 40 04             	mov    0x4(%rax),%eax
  803686:	99                   	cltd   
  803687:	c1 ea 1b             	shr    $0x1b,%edx
  80368a:	01 d0                	add    %edx,%eax
  80368c:	83 e0 1f             	and    $0x1f,%eax
  80368f:	29 d0                	sub    %edx,%eax
  803691:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803695:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803699:	48 01 ca             	add    %rcx,%rdx
  80369c:	0f b6 0a             	movzbl (%rdx),%ecx
  80369f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036a3:	48 98                	cltq   
  8036a5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8036a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ad:	8b 40 04             	mov    0x4(%rax),%eax
  8036b0:	8d 50 01             	lea    0x1(%rax),%edx
  8036b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b7:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8036ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036c3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036c7:	0f 82 64 ff ff ff    	jb     803631 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8036cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8036d1:	c9                   	leaveq 
  8036d2:	c3                   	retq   

00000000008036d3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8036d3:	55                   	push   %rbp
  8036d4:	48 89 e5             	mov    %rsp,%rbp
  8036d7:	48 83 ec 20          	sub    $0x20,%rsp
  8036db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8036e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036e7:	48 89 c7             	mov    %rax,%rdi
  8036ea:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  8036f1:	00 00 00 
  8036f4:	ff d0                	callq  *%rax
  8036f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8036fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036fe:	48 be 7e 44 80 00 00 	movabs $0x80447e,%rsi
  803705:	00 00 00 
  803708:	48 89 c7             	mov    %rax,%rdi
  80370b:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  803712:	00 00 00 
  803715:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803717:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80371b:	8b 50 04             	mov    0x4(%rax),%edx
  80371e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803722:	8b 00                	mov    (%rax),%eax
  803724:	29 c2                	sub    %eax,%edx
  803726:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80372a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803730:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803734:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80373b:	00 00 00 
	stat->st_dev = &devpipe;
  80373e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803742:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803749:	00 00 00 
  80374c:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803753:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803758:	c9                   	leaveq 
  803759:	c3                   	retq   

000000000080375a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80375a:	55                   	push   %rbp
  80375b:	48 89 e5             	mov    %rsp,%rbp
  80375e:	48 83 ec 10          	sub    $0x10,%rsp
  803762:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803766:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80376a:	48 89 c6             	mov    %rax,%rsi
  80376d:	bf 00 00 00 00       	mov    $0x0,%edi
  803772:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  803779:	00 00 00 
  80377c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80377e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803782:	48 89 c7             	mov    %rax,%rdi
  803785:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  80378c:	00 00 00 
  80378f:	ff d0                	callq  *%rax
  803791:	48 89 c6             	mov    %rax,%rsi
  803794:	bf 00 00 00 00       	mov    $0x0,%edi
  803799:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  8037a0:	00 00 00 
  8037a3:	ff d0                	callq  *%rax
}
  8037a5:	c9                   	leaveq 
  8037a6:	c3                   	retq   

00000000008037a7 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8037a7:	55                   	push   %rbp
  8037a8:	48 89 e5             	mov    %rsp,%rbp
  8037ab:	48 83 ec 20          	sub    $0x20,%rsp
  8037af:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8037b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037b5:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8037b8:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8037bc:	be 01 00 00 00       	mov    $0x1,%esi
  8037c1:	48 89 c7             	mov    %rax,%rdi
  8037c4:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  8037cb:	00 00 00 
  8037ce:	ff d0                	callq  *%rax
}
  8037d0:	c9                   	leaveq 
  8037d1:	c3                   	retq   

00000000008037d2 <getchar>:

int
getchar(void)
{
  8037d2:	55                   	push   %rbp
  8037d3:	48 89 e5             	mov    %rsp,%rbp
  8037d6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8037da:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8037de:	ba 01 00 00 00       	mov    $0x1,%edx
  8037e3:	48 89 c6             	mov    %rax,%rsi
  8037e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8037eb:	48 b8 76 29 80 00 00 	movabs $0x802976,%rax
  8037f2:	00 00 00 
  8037f5:	ff d0                	callq  *%rax
  8037f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8037fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037fe:	79 05                	jns    803805 <getchar+0x33>
		return r;
  803800:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803803:	eb 14                	jmp    803819 <getchar+0x47>
	if (r < 1)
  803805:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803809:	7f 07                	jg     803812 <getchar+0x40>
		return -E_EOF;
  80380b:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803810:	eb 07                	jmp    803819 <getchar+0x47>
	return c;
  803812:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803816:	0f b6 c0             	movzbl %al,%eax
}
  803819:	c9                   	leaveq 
  80381a:	c3                   	retq   

000000000080381b <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80381b:	55                   	push   %rbp
  80381c:	48 89 e5             	mov    %rsp,%rbp
  80381f:	48 83 ec 20          	sub    $0x20,%rsp
  803823:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803826:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80382a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80382d:	48 89 d6             	mov    %rdx,%rsi
  803830:	89 c7                	mov    %eax,%edi
  803832:	48 b8 44 25 80 00 00 	movabs $0x802544,%rax
  803839:	00 00 00 
  80383c:	ff d0                	callq  *%rax
  80383e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803841:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803845:	79 05                	jns    80384c <iscons+0x31>
		return r;
  803847:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80384a:	eb 1a                	jmp    803866 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80384c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803850:	8b 10                	mov    (%rax),%edx
  803852:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803859:	00 00 00 
  80385c:	8b 00                	mov    (%rax),%eax
  80385e:	39 c2                	cmp    %eax,%edx
  803860:	0f 94 c0             	sete   %al
  803863:	0f b6 c0             	movzbl %al,%eax
}
  803866:	c9                   	leaveq 
  803867:	c3                   	retq   

0000000000803868 <opencons>:

int
opencons(void)
{
  803868:	55                   	push   %rbp
  803869:	48 89 e5             	mov    %rsp,%rbp
  80386c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803870:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803874:	48 89 c7             	mov    %rax,%rdi
  803877:	48 b8 ac 24 80 00 00 	movabs $0x8024ac,%rax
  80387e:	00 00 00 
  803881:	ff d0                	callq  *%rax
  803883:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803886:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80388a:	79 05                	jns    803891 <opencons+0x29>
		return r;
  80388c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80388f:	eb 5b                	jmp    8038ec <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803891:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803895:	ba 07 04 00 00       	mov    $0x407,%edx
  80389a:	48 89 c6             	mov    %rax,%rsi
  80389d:	bf 00 00 00 00       	mov    $0x0,%edi
  8038a2:	48 b8 ee 1c 80 00 00 	movabs $0x801cee,%rax
  8038a9:	00 00 00 
  8038ac:	ff d0                	callq  *%rax
  8038ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b5:	79 05                	jns    8038bc <opencons+0x54>
		return r;
  8038b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ba:	eb 30                	jmp    8038ec <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8038bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c0:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  8038c7:	00 00 00 
  8038ca:	8b 12                	mov    (%rdx),%edx
  8038cc:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8038ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8038d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038dd:	48 89 c7             	mov    %rax,%rdi
  8038e0:	48 b8 5e 24 80 00 00 	movabs $0x80245e,%rax
  8038e7:	00 00 00 
  8038ea:	ff d0                	callq  *%rax
}
  8038ec:	c9                   	leaveq 
  8038ed:	c3                   	retq   

00000000008038ee <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038ee:	55                   	push   %rbp
  8038ef:	48 89 e5             	mov    %rsp,%rbp
  8038f2:	48 83 ec 30          	sub    $0x30,%rsp
  8038f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803902:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803907:	75 07                	jne    803910 <devcons_read+0x22>
		return 0;
  803909:	b8 00 00 00 00       	mov    $0x0,%eax
  80390e:	eb 4b                	jmp    80395b <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803910:	eb 0c                	jmp    80391e <devcons_read+0x30>
		sys_yield();
  803912:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  803919:	00 00 00 
  80391c:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80391e:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  803925:	00 00 00 
  803928:	ff d0                	callq  *%rax
  80392a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80392d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803931:	74 df                	je     803912 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803933:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803937:	79 05                	jns    80393e <devcons_read+0x50>
		return c;
  803939:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80393c:	eb 1d                	jmp    80395b <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80393e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803942:	75 07                	jne    80394b <devcons_read+0x5d>
		return 0;
  803944:	b8 00 00 00 00       	mov    $0x0,%eax
  803949:	eb 10                	jmp    80395b <devcons_read+0x6d>
	*(char*)vbuf = c;
  80394b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80394e:	89 c2                	mov    %eax,%edx
  803950:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803954:	88 10                	mov    %dl,(%rax)
	return 1;
  803956:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80395b:	c9                   	leaveq 
  80395c:	c3                   	retq   

000000000080395d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80395d:	55                   	push   %rbp
  80395e:	48 89 e5             	mov    %rsp,%rbp
  803961:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803968:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80396f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803976:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80397d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803984:	eb 76                	jmp    8039fc <devcons_write+0x9f>
		m = n - tot;
  803986:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80398d:	89 c2                	mov    %eax,%edx
  80398f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803992:	29 c2                	sub    %eax,%edx
  803994:	89 d0                	mov    %edx,%eax
  803996:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803999:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80399c:	83 f8 7f             	cmp    $0x7f,%eax
  80399f:	76 07                	jbe    8039a8 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8039a1:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8039a8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039ab:	48 63 d0             	movslq %eax,%rdx
  8039ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b1:	48 63 c8             	movslq %eax,%rcx
  8039b4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8039bb:	48 01 c1             	add    %rax,%rcx
  8039be:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8039c5:	48 89 ce             	mov    %rcx,%rsi
  8039c8:	48 89 c7             	mov    %rax,%rdi
  8039cb:	48 b8 e3 16 80 00 00 	movabs $0x8016e3,%rax
  8039d2:	00 00 00 
  8039d5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8039d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039da:	48 63 d0             	movslq %eax,%rdx
  8039dd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8039e4:	48 89 d6             	mov    %rdx,%rsi
  8039e7:	48 89 c7             	mov    %rax,%rdi
  8039ea:	48 b8 a6 1b 80 00 00 	movabs $0x801ba6,%rax
  8039f1:	00 00 00 
  8039f4:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039f9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8039fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ff:	48 98                	cltq   
  803a01:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803a08:	0f 82 78 ff ff ff    	jb     803986 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803a0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a11:	c9                   	leaveq 
  803a12:	c3                   	retq   

0000000000803a13 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803a13:	55                   	push   %rbp
  803a14:	48 89 e5             	mov    %rsp,%rbp
  803a17:	48 83 ec 08          	sub    $0x8,%rsp
  803a1b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803a1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a24:	c9                   	leaveq 
  803a25:	c3                   	retq   

0000000000803a26 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803a26:	55                   	push   %rbp
  803a27:	48 89 e5             	mov    %rsp,%rbp
  803a2a:	48 83 ec 10          	sub    $0x10,%rsp
  803a2e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a32:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803a36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a3a:	48 be 8a 44 80 00 00 	movabs $0x80448a,%rsi
  803a41:	00 00 00 
  803a44:	48 89 c7             	mov    %rax,%rdi
  803a47:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  803a4e:	00 00 00 
  803a51:	ff d0                	callq  *%rax
	return 0;
  803a53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a58:	c9                   	leaveq 
  803a59:	c3                   	retq   

0000000000803a5a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803a5a:	55                   	push   %rbp
  803a5b:	48 89 e5             	mov    %rsp,%rbp
  803a5e:	48 83 ec 10          	sub    $0x10,%rsp
  803a62:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803a66:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803a6d:	00 00 00 
  803a70:	48 8b 00             	mov    (%rax),%rax
  803a73:	48 85 c0             	test   %rax,%rax
  803a76:	75 3a                	jne    803ab2 <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  803a78:	ba 07 00 00 00       	mov    $0x7,%edx
  803a7d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803a82:	bf 00 00 00 00       	mov    $0x0,%edi
  803a87:	48 b8 ee 1c 80 00 00 	movabs $0x801cee,%rax
  803a8e:	00 00 00 
  803a91:	ff d0                	callq  *%rax
  803a93:	85 c0                	test   %eax,%eax
  803a95:	75 1b                	jne    803ab2 <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803a97:	48 be c5 3a 80 00 00 	movabs $0x803ac5,%rsi
  803a9e:	00 00 00 
  803aa1:	bf 00 00 00 00       	mov    $0x0,%edi
  803aa6:	48 b8 78 1e 80 00 00 	movabs $0x801e78,%rax
  803aad:	00 00 00 
  803ab0:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803ab2:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803ab9:	00 00 00 
  803abc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803ac0:	48 89 10             	mov    %rdx,(%rax)
}
  803ac3:	c9                   	leaveq 
  803ac4:	c3                   	retq   

0000000000803ac5 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  803ac5:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  803ac8:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803acf:	00 00 00 
	call *%rax
  803ad2:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  803ad4:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  803ad7:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803ade:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  803adf:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  803ae6:	00 
	pushq %rbx		// push utf_rip into new stack
  803ae7:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  803ae8:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  803aef:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  803af2:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  803af6:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  803afa:	4c 8b 3c 24          	mov    (%rsp),%r15
  803afe:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803b03:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803b08:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803b0d:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803b12:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803b17:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803b1c:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803b21:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803b26:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803b2b:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803b30:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803b35:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803b3a:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803b3f:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803b44:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  803b48:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  803b4c:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  803b4d:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803b4e:	c3                   	retq   

0000000000803b4f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803b4f:	55                   	push   %rbp
  803b50:	48 89 e5             	mov    %rsp,%rbp
  803b53:	48 83 ec 30          	sub    $0x30,%rsp
  803b57:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b5b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b5f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803b63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b67:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803b6b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803b70:	75 0e                	jne    803b80 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  803b72:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803b79:	00 00 00 
  803b7c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  803b80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b84:	48 89 c7             	mov    %rax,%rdi
  803b87:	48 b8 17 1f 80 00 00 	movabs $0x801f17,%rax
  803b8e:	00 00 00 
  803b91:	ff d0                	callq  *%rax
  803b93:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803b96:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803b9a:	79 27                	jns    803bc3 <ipc_recv+0x74>
		if (from_env_store != NULL)
  803b9c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803ba1:	74 0a                	je     803bad <ipc_recv+0x5e>
			*from_env_store = 0;
  803ba3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ba7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  803bad:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803bb2:	74 0a                	je     803bbe <ipc_recv+0x6f>
			*perm_store = 0;
  803bb4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bb8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803bbe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803bc1:	eb 53                	jmp    803c16 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  803bc3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803bc8:	74 19                	je     803be3 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  803bca:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bd1:	00 00 00 
  803bd4:	48 8b 00             	mov    (%rax),%rax
  803bd7:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803bdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803be1:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  803be3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803be8:	74 19                	je     803c03 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803bea:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bf1:	00 00 00 
  803bf4:	48 8b 00             	mov    (%rax),%rax
  803bf7:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803bfd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c01:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  803c03:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c0a:	00 00 00 
  803c0d:	48 8b 00             	mov    (%rax),%rax
  803c10:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803c16:	c9                   	leaveq 
  803c17:	c3                   	retq   

0000000000803c18 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803c18:	55                   	push   %rbp
  803c19:	48 89 e5             	mov    %rsp,%rbp
  803c1c:	48 83 ec 30          	sub    $0x30,%rsp
  803c20:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c23:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803c26:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803c2a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803c2d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c31:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803c35:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803c3a:	75 10                	jne    803c4c <ipc_send+0x34>
		page = (void *)KERNBASE;
  803c3c:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803c43:	00 00 00 
  803c46:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803c4a:	eb 0e                	jmp    803c5a <ipc_send+0x42>
  803c4c:	eb 0c                	jmp    803c5a <ipc_send+0x42>
		sys_yield();
  803c4e:	48 b8 b0 1c 80 00 00 	movabs $0x801cb0,%rax
  803c55:	00 00 00 
  803c58:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803c5a:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803c5d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803c60:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c64:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c67:	89 c7                	mov    %eax,%edi
  803c69:	48 b8 c2 1e 80 00 00 	movabs $0x801ec2,%rax
  803c70:	00 00 00 
  803c73:	ff d0                	callq  *%rax
  803c75:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803c78:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  803c7c:	74 d0                	je     803c4e <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  803c7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803c82:	74 2a                	je     803cae <ipc_send+0x96>
		panic("error on ipc send procedure");
  803c84:	48 ba 91 44 80 00 00 	movabs $0x804491,%rdx
  803c8b:	00 00 00 
  803c8e:	be 49 00 00 00       	mov    $0x49,%esi
  803c93:	48 bf ad 44 80 00 00 	movabs $0x8044ad,%rdi
  803c9a:	00 00 00 
  803c9d:	b8 00 00 00 00       	mov    $0x0,%eax
  803ca2:	48 b9 de 03 80 00 00 	movabs $0x8003de,%rcx
  803ca9:	00 00 00 
  803cac:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  803cae:	c9                   	leaveq 
  803caf:	c3                   	retq   

0000000000803cb0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803cb0:	55                   	push   %rbp
  803cb1:	48 89 e5             	mov    %rsp,%rbp
  803cb4:	48 83 ec 14          	sub    $0x14,%rsp
  803cb8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803cbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803cc2:	eb 5e                	jmp    803d22 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803cc4:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ccb:	00 00 00 
  803cce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd1:	48 63 d0             	movslq %eax,%rdx
  803cd4:	48 89 d0             	mov    %rdx,%rax
  803cd7:	48 c1 e0 03          	shl    $0x3,%rax
  803cdb:	48 01 d0             	add    %rdx,%rax
  803cde:	48 c1 e0 05          	shl    $0x5,%rax
  803ce2:	48 01 c8             	add    %rcx,%rax
  803ce5:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803ceb:	8b 00                	mov    (%rax),%eax
  803ced:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803cf0:	75 2c                	jne    803d1e <ipc_find_env+0x6e>
			return envs[i].env_id;
  803cf2:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803cf9:	00 00 00 
  803cfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cff:	48 63 d0             	movslq %eax,%rdx
  803d02:	48 89 d0             	mov    %rdx,%rax
  803d05:	48 c1 e0 03          	shl    $0x3,%rax
  803d09:	48 01 d0             	add    %rdx,%rax
  803d0c:	48 c1 e0 05          	shl    $0x5,%rax
  803d10:	48 01 c8             	add    %rcx,%rax
  803d13:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803d19:	8b 40 08             	mov    0x8(%rax),%eax
  803d1c:	eb 12                	jmp    803d30 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803d1e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803d22:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803d29:	7e 99                	jle    803cc4 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803d2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d30:	c9                   	leaveq 
  803d31:	c3                   	retq   

0000000000803d32 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803d32:	55                   	push   %rbp
  803d33:	48 89 e5             	mov    %rsp,%rbp
  803d36:	48 83 ec 18          	sub    $0x18,%rsp
  803d3a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803d3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d42:	48 c1 e8 15          	shr    $0x15,%rax
  803d46:	48 89 c2             	mov    %rax,%rdx
  803d49:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803d50:	01 00 00 
  803d53:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d57:	83 e0 01             	and    $0x1,%eax
  803d5a:	48 85 c0             	test   %rax,%rax
  803d5d:	75 07                	jne    803d66 <pageref+0x34>
		return 0;
  803d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  803d64:	eb 53                	jmp    803db9 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803d66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d6a:	48 c1 e8 0c          	shr    $0xc,%rax
  803d6e:	48 89 c2             	mov    %rax,%rdx
  803d71:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d78:	01 00 00 
  803d7b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d7f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803d83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d87:	83 e0 01             	and    $0x1,%eax
  803d8a:	48 85 c0             	test   %rax,%rax
  803d8d:	75 07                	jne    803d96 <pageref+0x64>
		return 0;
  803d8f:	b8 00 00 00 00       	mov    $0x0,%eax
  803d94:	eb 23                	jmp    803db9 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803d96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d9a:	48 c1 e8 0c          	shr    $0xc,%rax
  803d9e:	48 89 c2             	mov    %rax,%rdx
  803da1:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803da8:	00 00 00 
  803dab:	48 c1 e2 04          	shl    $0x4,%rdx
  803daf:	48 01 d0             	add    %rdx,%rax
  803db2:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803db6:	0f b7 c0             	movzwl %ax,%eax
}
  803db9:	c9                   	leaveq 
  803dba:	c3                   	retq   
