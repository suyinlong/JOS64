
obj/user/icode.debug:     file format elf64-x86-64


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
  80003c:	e8 06 02 00 00       	callq  800247 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 81 ec 28 02 00 00 	sub    $0x228,%rsp
  80004f:	89 bd dc fd ff ff    	mov    %edi,-0x224(%rbp)
  800055:	48 89 b5 d0 fd ff ff 	mov    %rsi,-0x230(%rbp)
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80005c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800063:	00 00 00 
  800066:	48 bb e0 42 80 00 00 	movabs $0x8042e0,%rbx
  80006d:	00 00 00 
  800070:	48 89 18             	mov    %rbx,(%rax)

	cprintf("icode startup\n");
  800073:	48 bf e6 42 80 00 00 	movabs $0x8042e6,%rdi
  80007a:	00 00 00 
  80007d:	b8 00 00 00 00       	mov    $0x0,%eax
  800082:	48 ba 33 05 80 00 00 	movabs $0x800533,%rdx
  800089:	00 00 00 
  80008c:	ff d2                	callq  *%rdx

	cprintf("icode: open /motd\n");
  80008e:	48 bf f5 42 80 00 00 	movabs $0x8042f5,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 ba 33 05 80 00 00 	movabs $0x800533,%rdx
  8000a4:	00 00 00 
  8000a7:	ff d2                	callq  *%rdx
	if ((fd = open("/motd", O_RDONLY)) < 0)
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	48 bf 08 43 80 00 00 	movabs $0x804308,%rdi
  8000b5:	00 00 00 
  8000b8:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8000c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("icode: open /motd: %e", fd);
  8000cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 0e 43 80 00 00 	movabs $0x80430e,%rdx
  8000d9:	00 00 00 
  8000dc:	be 0f 00 00 00       	mov    $0xf,%esi
  8000e1:	48 bf 24 43 80 00 00 	movabs $0x804324,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 fa 02 80 00 00 	movabs $0x8002fa,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8

	cprintf("icode: read /motd\n");
  8000fd:	48 bf 31 43 80 00 00 	movabs $0x804331,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	48 ba 33 05 80 00 00 	movabs $0x800533,%rdx
  800113:	00 00 00 
  800116:	ff d2                	callq  *%rdx
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800118:	eb 1f                	jmp    800139 <umain+0xf6>
		sys_cputs(buf, n);
  80011a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80011d:	48 63 d0             	movslq %eax,%rdx
  800120:	48 8d 85 e0 fd ff ff 	lea    -0x220(%rbp),%rax
  800127:	48 89 d6             	mov    %rdx,%rsi
  80012a:	48 89 c7             	mov    %rax,%rdi
  80012d:	48 b8 c2 1a 80 00 00 	movabs $0x801ac2,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
	cprintf("icode: open /motd\n");
	if ((fd = open("/motd", O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800139:	48 8d 8d e0 fd ff ff 	lea    -0x220(%rbp),%rcx
  800140:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800143:	ba 00 02 00 00       	mov    $0x200,%edx
  800148:	48 89 ce             	mov    %rcx,%rsi
  80014b:	89 c7                	mov    %eax,%edi
  80014d:	48 b8 8f 23 80 00 00 	movabs $0x80238f,%rax
  800154:	00 00 00 
  800157:	ff d0                	callq  *%rax
  800159:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80015c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800160:	7f b8                	jg     80011a <umain+0xd7>
		sys_cputs(buf, n);

	cprintf("icode: close /motd\n");
  800162:	48 bf 44 43 80 00 00 	movabs $0x804344,%rdi
  800169:	00 00 00 
  80016c:	b8 00 00 00 00       	mov    $0x0,%eax
  800171:	48 ba 33 05 80 00 00 	movabs $0x800533,%rdx
  800178:	00 00 00 
  80017b:	ff d2                	callq  *%rdx
	close(fd);
  80017d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800180:	89 c7                	mov    %eax,%edi
  800182:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax

	cprintf("icode: spawn /init\n");
  80018e:	48 bf 58 43 80 00 00 	movabs $0x804358,%rdi
  800195:	00 00 00 
  800198:	b8 00 00 00 00       	mov    $0x0,%eax
  80019d:	48 ba 33 05 80 00 00 	movabs $0x800533,%rdx
  8001a4:	00 00 00 
  8001a7:	ff d2                	callq  *%rdx
	if ((r = spawnl("/sbin/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8001a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001af:	48 b9 6c 43 80 00 00 	movabs $0x80436c,%rcx
  8001b6:	00 00 00 
  8001b9:	48 ba 75 43 80 00 00 	movabs $0x804375,%rdx
  8001c0:	00 00 00 
  8001c3:	48 be 7e 43 80 00 00 	movabs $0x80437e,%rsi
  8001ca:	00 00 00 
  8001cd:	48 bf 83 43 80 00 00 	movabs $0x804383,%rdi
  8001d4:	00 00 00 
  8001d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dc:	49 b9 52 2f 80 00 00 	movabs $0x802f52,%r9
  8001e3:	00 00 00 
  8001e6:	41 ff d1             	callq  *%r9
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8001ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8001f0:	79 30                	jns    800222 <umain+0x1df>
		panic("icode: spawn /sbin/init: %e", r);
  8001f2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8001f5:	89 c1                	mov    %eax,%ecx
  8001f7:	48 ba 8e 43 80 00 00 	movabs $0x80438e,%rdx
  8001fe:	00 00 00 
  800201:	be 1a 00 00 00       	mov    $0x1a,%esi
  800206:	48 bf 24 43 80 00 00 	movabs $0x804324,%rdi
  80020d:	00 00 00 
  800210:	b8 00 00 00 00       	mov    $0x0,%eax
  800215:	49 b8 fa 02 80 00 00 	movabs $0x8002fa,%r8
  80021c:	00 00 00 
  80021f:	41 ff d0             	callq  *%r8

	cprintf("icode: exiting\n");
  800222:	48 bf aa 43 80 00 00 	movabs $0x8043aa,%rdi
  800229:	00 00 00 
  80022c:	b8 00 00 00 00       	mov    $0x0,%eax
  800231:	48 ba 33 05 80 00 00 	movabs $0x800533,%rdx
  800238:	00 00 00 
  80023b:	ff d2                	callq  *%rdx
}
  80023d:	48 81 c4 28 02 00 00 	add    $0x228,%rsp
  800244:	5b                   	pop    %rbx
  800245:	5d                   	pop    %rbp
  800246:	c3                   	retq   

0000000000800247 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800247:	55                   	push   %rbp
  800248:	48 89 e5             	mov    %rsp,%rbp
  80024b:	48 83 ec 10          	sub    $0x10,%rsp
  80024f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800252:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800256:	48 b8 8e 1b 80 00 00 	movabs $0x801b8e,%rax
  80025d:	00 00 00 
  800260:	ff d0                	callq  *%rax
  800262:	48 98                	cltq   
  800264:	25 ff 03 00 00       	and    $0x3ff,%eax
  800269:	48 89 c2             	mov    %rax,%rdx
  80026c:	48 89 d0             	mov    %rdx,%rax
  80026f:	48 c1 e0 03          	shl    $0x3,%rax
  800273:	48 01 d0             	add    %rdx,%rax
  800276:	48 c1 e0 05          	shl    $0x5,%rax
  80027a:	48 89 c2             	mov    %rax,%rdx
  80027d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800284:	00 00 00 
  800287:	48 01 c2             	add    %rax,%rdx
  80028a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800291:	00 00 00 
  800294:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800297:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80029b:	7e 14                	jle    8002b1 <libmain+0x6a>
		binaryname = argv[0];
  80029d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a1:	48 8b 10             	mov    (%rax),%rdx
  8002a4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002ab:	00 00 00 
  8002ae:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002b8:	48 89 d6             	mov    %rdx,%rsi
  8002bb:	89 c7                	mov    %eax,%edi
  8002bd:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002c4:	00 00 00 
  8002c7:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8002c9:	48 b8 d7 02 80 00 00 	movabs $0x8002d7,%rax
  8002d0:	00 00 00 
  8002d3:	ff d0                	callq  *%rax
}
  8002d5:	c9                   	leaveq 
  8002d6:	c3                   	retq   

00000000008002d7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002d7:	55                   	push   %rbp
  8002d8:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002db:	48 b8 b8 21 80 00 00 	movabs $0x8021b8,%rax
  8002e2:	00 00 00 
  8002e5:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8002e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8002ec:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  8002f3:	00 00 00 
  8002f6:	ff d0                	callq  *%rax
}
  8002f8:	5d                   	pop    %rbp
  8002f9:	c3                   	retq   

00000000008002fa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002fa:	55                   	push   %rbp
  8002fb:	48 89 e5             	mov    %rsp,%rbp
  8002fe:	53                   	push   %rbx
  8002ff:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800306:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80030d:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800313:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80031a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800321:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800328:	84 c0                	test   %al,%al
  80032a:	74 23                	je     80034f <_panic+0x55>
  80032c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800333:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800337:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80033b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80033f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800343:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800347:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80034b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80034f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800356:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80035d:	00 00 00 
  800360:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800367:	00 00 00 
  80036a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80036e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800375:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80037c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800383:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80038a:	00 00 00 
  80038d:	48 8b 18             	mov    (%rax),%rbx
  800390:	48 b8 8e 1b 80 00 00 	movabs $0x801b8e,%rax
  800397:	00 00 00 
  80039a:	ff d0                	callq  *%rax
  80039c:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003a2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003a9:	41 89 c8             	mov    %ecx,%r8d
  8003ac:	48 89 d1             	mov    %rdx,%rcx
  8003af:	48 89 da             	mov    %rbx,%rdx
  8003b2:	89 c6                	mov    %eax,%esi
  8003b4:	48 bf c8 43 80 00 00 	movabs $0x8043c8,%rdi
  8003bb:	00 00 00 
  8003be:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c3:	49 b9 33 05 80 00 00 	movabs $0x800533,%r9
  8003ca:	00 00 00 
  8003cd:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003d0:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003d7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003de:	48 89 d6             	mov    %rdx,%rsi
  8003e1:	48 89 c7             	mov    %rax,%rdi
  8003e4:	48 b8 87 04 80 00 00 	movabs $0x800487,%rax
  8003eb:	00 00 00 
  8003ee:	ff d0                	callq  *%rax
	cprintf("\n");
  8003f0:	48 bf eb 43 80 00 00 	movabs $0x8043eb,%rdi
  8003f7:	00 00 00 
  8003fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ff:	48 ba 33 05 80 00 00 	movabs $0x800533,%rdx
  800406:	00 00 00 
  800409:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80040b:	cc                   	int3   
  80040c:	eb fd                	jmp    80040b <_panic+0x111>

000000000080040e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80040e:	55                   	push   %rbp
  80040f:	48 89 e5             	mov    %rsp,%rbp
  800412:	48 83 ec 10          	sub    $0x10,%rsp
  800416:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800419:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80041d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800421:	8b 00                	mov    (%rax),%eax
  800423:	8d 48 01             	lea    0x1(%rax),%ecx
  800426:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042a:	89 0a                	mov    %ecx,(%rdx)
  80042c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80042f:	89 d1                	mov    %edx,%ecx
  800431:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800435:	48 98                	cltq   
  800437:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80043b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80043f:	8b 00                	mov    (%rax),%eax
  800441:	3d ff 00 00 00       	cmp    $0xff,%eax
  800446:	75 2c                	jne    800474 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800448:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044c:	8b 00                	mov    (%rax),%eax
  80044e:	48 98                	cltq   
  800450:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800454:	48 83 c2 08          	add    $0x8,%rdx
  800458:	48 89 c6             	mov    %rax,%rsi
  80045b:	48 89 d7             	mov    %rdx,%rdi
  80045e:	48 b8 c2 1a 80 00 00 	movabs $0x801ac2,%rax
  800465:	00 00 00 
  800468:	ff d0                	callq  *%rax
		b->idx = 0;
  80046a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80046e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800474:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800478:	8b 40 04             	mov    0x4(%rax),%eax
  80047b:	8d 50 01             	lea    0x1(%rax),%edx
  80047e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800482:	89 50 04             	mov    %edx,0x4(%rax)
}
  800485:	c9                   	leaveq 
  800486:	c3                   	retq   

0000000000800487 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800487:	55                   	push   %rbp
  800488:	48 89 e5             	mov    %rsp,%rbp
  80048b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800492:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800499:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8004a0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004a7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004ae:	48 8b 0a             	mov    (%rdx),%rcx
  8004b1:	48 89 08             	mov    %rcx,(%rax)
  8004b4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004b8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004bc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004c0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8004c4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004cb:	00 00 00 
	b.cnt = 0;
  8004ce:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004d5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8004d8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004df:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004e6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004ed:	48 89 c6             	mov    %rax,%rsi
  8004f0:	48 bf 0e 04 80 00 00 	movabs $0x80040e,%rdi
  8004f7:	00 00 00 
  8004fa:	48 b8 e6 08 80 00 00 	movabs $0x8008e6,%rax
  800501:	00 00 00 
  800504:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800506:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80050c:	48 98                	cltq   
  80050e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800515:	48 83 c2 08          	add    $0x8,%rdx
  800519:	48 89 c6             	mov    %rax,%rsi
  80051c:	48 89 d7             	mov    %rdx,%rdi
  80051f:	48 b8 c2 1a 80 00 00 	movabs $0x801ac2,%rax
  800526:	00 00 00 
  800529:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80052b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800531:	c9                   	leaveq 
  800532:	c3                   	retq   

0000000000800533 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800533:	55                   	push   %rbp
  800534:	48 89 e5             	mov    %rsp,%rbp
  800537:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80053e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800545:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80054c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800553:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80055a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800561:	84 c0                	test   %al,%al
  800563:	74 20                	je     800585 <cprintf+0x52>
  800565:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800569:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80056d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800571:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800575:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800579:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80057d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800581:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800585:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80058c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800593:	00 00 00 
  800596:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80059d:	00 00 00 
  8005a0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005a4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005ab:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005b2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8005b9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005c0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005c7:	48 8b 0a             	mov    (%rdx),%rcx
  8005ca:	48 89 08             	mov    %rcx,(%rax)
  8005cd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005d1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005d5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005d9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8005dd:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005e4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005eb:	48 89 d6             	mov    %rdx,%rsi
  8005ee:	48 89 c7             	mov    %rax,%rdi
  8005f1:	48 b8 87 04 80 00 00 	movabs $0x800487,%rax
  8005f8:	00 00 00 
  8005fb:	ff d0                	callq  *%rax
  8005fd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800603:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800609:	c9                   	leaveq 
  80060a:	c3                   	retq   

000000000080060b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80060b:	55                   	push   %rbp
  80060c:	48 89 e5             	mov    %rsp,%rbp
  80060f:	53                   	push   %rbx
  800610:	48 83 ec 38          	sub    $0x38,%rsp
  800614:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800618:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80061c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800620:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800623:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800627:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80062b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80062e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800632:	77 3b                	ja     80066f <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800634:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800637:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80063b:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80063e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800642:	ba 00 00 00 00       	mov    $0x0,%edx
  800647:	48 f7 f3             	div    %rbx
  80064a:	48 89 c2             	mov    %rax,%rdx
  80064d:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800650:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800653:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800657:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065b:	41 89 f9             	mov    %edi,%r9d
  80065e:	48 89 c7             	mov    %rax,%rdi
  800661:	48 b8 0b 06 80 00 00 	movabs $0x80060b,%rax
  800668:	00 00 00 
  80066b:	ff d0                	callq  *%rax
  80066d:	eb 1e                	jmp    80068d <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80066f:	eb 12                	jmp    800683 <printnum+0x78>
			putch(padc, putdat);
  800671:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800675:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800678:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067c:	48 89 ce             	mov    %rcx,%rsi
  80067f:	89 d7                	mov    %edx,%edi
  800681:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800683:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800687:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80068b:	7f e4                	jg     800671 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80068d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800690:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800694:	ba 00 00 00 00       	mov    $0x0,%edx
  800699:	48 f7 f1             	div    %rcx
  80069c:	48 89 d0             	mov    %rdx,%rax
  80069f:	48 ba c8 45 80 00 00 	movabs $0x8045c8,%rdx
  8006a6:	00 00 00 
  8006a9:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006ad:	0f be d0             	movsbl %al,%edx
  8006b0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b8:	48 89 ce             	mov    %rcx,%rsi
  8006bb:	89 d7                	mov    %edx,%edi
  8006bd:	ff d0                	callq  *%rax
}
  8006bf:	48 83 c4 38          	add    $0x38,%rsp
  8006c3:	5b                   	pop    %rbx
  8006c4:	5d                   	pop    %rbp
  8006c5:	c3                   	retq   

00000000008006c6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006c6:	55                   	push   %rbp
  8006c7:	48 89 e5             	mov    %rsp,%rbp
  8006ca:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8006d5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006d9:	7e 52                	jle    80072d <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006df:	8b 00                	mov    (%rax),%eax
  8006e1:	83 f8 30             	cmp    $0x30,%eax
  8006e4:	73 24                	jae    80070a <getuint+0x44>
  8006e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ea:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f2:	8b 00                	mov    (%rax),%eax
  8006f4:	89 c0                	mov    %eax,%eax
  8006f6:	48 01 d0             	add    %rdx,%rax
  8006f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fd:	8b 12                	mov    (%rdx),%edx
  8006ff:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800702:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800706:	89 0a                	mov    %ecx,(%rdx)
  800708:	eb 17                	jmp    800721 <getuint+0x5b>
  80070a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800712:	48 89 d0             	mov    %rdx,%rax
  800715:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800719:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800721:	48 8b 00             	mov    (%rax),%rax
  800724:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800728:	e9 a3 00 00 00       	jmpq   8007d0 <getuint+0x10a>
	else if (lflag)
  80072d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800731:	74 4f                	je     800782 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800737:	8b 00                	mov    (%rax),%eax
  800739:	83 f8 30             	cmp    $0x30,%eax
  80073c:	73 24                	jae    800762 <getuint+0x9c>
  80073e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800742:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074a:	8b 00                	mov    (%rax),%eax
  80074c:	89 c0                	mov    %eax,%eax
  80074e:	48 01 d0             	add    %rdx,%rax
  800751:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800755:	8b 12                	mov    (%rdx),%edx
  800757:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80075a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075e:	89 0a                	mov    %ecx,(%rdx)
  800760:	eb 17                	jmp    800779 <getuint+0xb3>
  800762:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800766:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80076a:	48 89 d0             	mov    %rdx,%rax
  80076d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800771:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800775:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800779:	48 8b 00             	mov    (%rax),%rax
  80077c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800780:	eb 4e                	jmp    8007d0 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800782:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800786:	8b 00                	mov    (%rax),%eax
  800788:	83 f8 30             	cmp    $0x30,%eax
  80078b:	73 24                	jae    8007b1 <getuint+0xeb>
  80078d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800791:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800795:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800799:	8b 00                	mov    (%rax),%eax
  80079b:	89 c0                	mov    %eax,%eax
  80079d:	48 01 d0             	add    %rdx,%rax
  8007a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a4:	8b 12                	mov    (%rdx),%edx
  8007a6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ad:	89 0a                	mov    %ecx,(%rdx)
  8007af:	eb 17                	jmp    8007c8 <getuint+0x102>
  8007b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007b9:	48 89 d0             	mov    %rdx,%rax
  8007bc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007c8:	8b 00                	mov    (%rax),%eax
  8007ca:	89 c0                	mov    %eax,%eax
  8007cc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007d4:	c9                   	leaveq 
  8007d5:	c3                   	retq   

00000000008007d6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d6:	55                   	push   %rbp
  8007d7:	48 89 e5             	mov    %rsp,%rbp
  8007da:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007e2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007e5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007e9:	7e 52                	jle    80083d <getint+0x67>
		x=va_arg(*ap, long long);
  8007eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ef:	8b 00                	mov    (%rax),%eax
  8007f1:	83 f8 30             	cmp    $0x30,%eax
  8007f4:	73 24                	jae    80081a <getint+0x44>
  8007f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800802:	8b 00                	mov    (%rax),%eax
  800804:	89 c0                	mov    %eax,%eax
  800806:	48 01 d0             	add    %rdx,%rax
  800809:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080d:	8b 12                	mov    (%rdx),%edx
  80080f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800812:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800816:	89 0a                	mov    %ecx,(%rdx)
  800818:	eb 17                	jmp    800831 <getint+0x5b>
  80081a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800822:	48 89 d0             	mov    %rdx,%rax
  800825:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800829:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800831:	48 8b 00             	mov    (%rax),%rax
  800834:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800838:	e9 a3 00 00 00       	jmpq   8008e0 <getint+0x10a>
	else if (lflag)
  80083d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800841:	74 4f                	je     800892 <getint+0xbc>
		x=va_arg(*ap, long);
  800843:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800847:	8b 00                	mov    (%rax),%eax
  800849:	83 f8 30             	cmp    $0x30,%eax
  80084c:	73 24                	jae    800872 <getint+0x9c>
  80084e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800852:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800856:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085a:	8b 00                	mov    (%rax),%eax
  80085c:	89 c0                	mov    %eax,%eax
  80085e:	48 01 d0             	add    %rdx,%rax
  800861:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800865:	8b 12                	mov    (%rdx),%edx
  800867:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80086a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086e:	89 0a                	mov    %ecx,(%rdx)
  800870:	eb 17                	jmp    800889 <getint+0xb3>
  800872:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800876:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80087a:	48 89 d0             	mov    %rdx,%rax
  80087d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800881:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800885:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800889:	48 8b 00             	mov    (%rax),%rax
  80088c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800890:	eb 4e                	jmp    8008e0 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800892:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800896:	8b 00                	mov    (%rax),%eax
  800898:	83 f8 30             	cmp    $0x30,%eax
  80089b:	73 24                	jae    8008c1 <getint+0xeb>
  80089d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a9:	8b 00                	mov    (%rax),%eax
  8008ab:	89 c0                	mov    %eax,%eax
  8008ad:	48 01 d0             	add    %rdx,%rax
  8008b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b4:	8b 12                	mov    (%rdx),%edx
  8008b6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008bd:	89 0a                	mov    %ecx,(%rdx)
  8008bf:	eb 17                	jmp    8008d8 <getint+0x102>
  8008c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008c9:	48 89 d0             	mov    %rdx,%rax
  8008cc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008d8:	8b 00                	mov    (%rax),%eax
  8008da:	48 98                	cltq   
  8008dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008e4:	c9                   	leaveq 
  8008e5:	c3                   	retq   

00000000008008e6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008e6:	55                   	push   %rbp
  8008e7:	48 89 e5             	mov    %rsp,%rbp
  8008ea:	41 54                	push   %r12
  8008ec:	53                   	push   %rbx
  8008ed:	48 83 ec 60          	sub    $0x60,%rsp
  8008f1:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008f5:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008f9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008fd:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800901:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800905:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800909:	48 8b 0a             	mov    (%rdx),%rcx
  80090c:	48 89 08             	mov    %rcx,(%rax)
  80090f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800913:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800917:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80091b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  80091f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800923:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800927:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80092b:	0f b6 00             	movzbl (%rax),%eax
  80092e:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  800931:	eb 29                	jmp    80095c <vprintfmt+0x76>
			if (ch == '\0')
  800933:	85 db                	test   %ebx,%ebx
  800935:	0f 84 ad 06 00 00    	je     800fe8 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  80093b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80093f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800943:	48 89 d6             	mov    %rdx,%rsi
  800946:	89 df                	mov    %ebx,%edi
  800948:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  80094a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80094e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800952:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800956:	0f b6 00             	movzbl (%rax),%eax
  800959:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  80095c:	83 fb 25             	cmp    $0x25,%ebx
  80095f:	74 05                	je     800966 <vprintfmt+0x80>
  800961:	83 fb 1b             	cmp    $0x1b,%ebx
  800964:	75 cd                	jne    800933 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800966:	83 fb 1b             	cmp    $0x1b,%ebx
  800969:	0f 85 ae 01 00 00    	jne    800b1d <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  80096f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800976:	00 00 00 
  800979:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  80097f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800983:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800987:	48 89 d6             	mov    %rdx,%rsi
  80098a:	89 df                	mov    %ebx,%edi
  80098c:	ff d0                	callq  *%rax
			putch('[', putdat);
  80098e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800992:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800996:	48 89 d6             	mov    %rdx,%rsi
  800999:	bf 5b 00 00 00       	mov    $0x5b,%edi
  80099e:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  8009a0:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  8009a6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8009ab:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009af:	0f b6 00             	movzbl (%rax),%eax
  8009b2:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8009b5:	eb 32                	jmp    8009e9 <vprintfmt+0x103>
					putch(ch, putdat);
  8009b7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009bb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009bf:	48 89 d6             	mov    %rdx,%rsi
  8009c2:	89 df                	mov    %ebx,%edi
  8009c4:	ff d0                	callq  *%rax
					esc_color *= 10;
  8009c6:	44 89 e0             	mov    %r12d,%eax
  8009c9:	c1 e0 02             	shl    $0x2,%eax
  8009cc:	44 01 e0             	add    %r12d,%eax
  8009cf:	01 c0                	add    %eax,%eax
  8009d1:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  8009d4:	8d 43 d0             	lea    -0x30(%rbx),%eax
  8009d7:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  8009da:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8009df:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009e3:	0f b6 00             	movzbl (%rax),%eax
  8009e6:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8009e9:	83 fb 3b             	cmp    $0x3b,%ebx
  8009ec:	74 05                	je     8009f3 <vprintfmt+0x10d>
  8009ee:	83 fb 6d             	cmp    $0x6d,%ebx
  8009f1:	75 c4                	jne    8009b7 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  8009f3:	45 85 e4             	test   %r12d,%r12d
  8009f6:	75 15                	jne    800a0d <vprintfmt+0x127>
					color_flag = 0x07;
  8009f8:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8009ff:	00 00 00 
  800a02:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800a08:	e9 dc 00 00 00       	jmpq   800ae9 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800a0d:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800a11:	7e 69                	jle    800a7c <vprintfmt+0x196>
  800a13:	41 83 fc 25          	cmp    $0x25,%r12d
  800a17:	7f 63                	jg     800a7c <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800a19:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800a20:	00 00 00 
  800a23:	8b 00                	mov    (%rax),%eax
  800a25:	25 f8 00 00 00       	and    $0xf8,%eax
  800a2a:	89 c2                	mov    %eax,%edx
  800a2c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800a33:	00 00 00 
  800a36:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800a38:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800a3c:	44 89 e0             	mov    %r12d,%eax
  800a3f:	83 e0 04             	and    $0x4,%eax
  800a42:	c1 f8 02             	sar    $0x2,%eax
  800a45:	89 c2                	mov    %eax,%edx
  800a47:	44 89 e0             	mov    %r12d,%eax
  800a4a:	83 e0 02             	and    $0x2,%eax
  800a4d:	09 c2                	or     %eax,%edx
  800a4f:	44 89 e0             	mov    %r12d,%eax
  800a52:	83 e0 01             	and    $0x1,%eax
  800a55:	c1 e0 02             	shl    $0x2,%eax
  800a58:	09 c2                	or     %eax,%edx
  800a5a:	41 89 d4             	mov    %edx,%r12d
  800a5d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800a64:	00 00 00 
  800a67:	8b 00                	mov    (%rax),%eax
  800a69:	44 89 e2             	mov    %r12d,%edx
  800a6c:	09 c2                	or     %eax,%edx
  800a6e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800a75:	00 00 00 
  800a78:	89 10                	mov    %edx,(%rax)
  800a7a:	eb 6d                	jmp    800ae9 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800a7c:	41 83 fc 27          	cmp    $0x27,%r12d
  800a80:	7e 67                	jle    800ae9 <vprintfmt+0x203>
  800a82:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800a86:	7f 61                	jg     800ae9 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800a88:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800a8f:	00 00 00 
  800a92:	8b 00                	mov    (%rax),%eax
  800a94:	25 8f 00 00 00       	and    $0x8f,%eax
  800a99:	89 c2                	mov    %eax,%edx
  800a9b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800aa2:	00 00 00 
  800aa5:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800aa7:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800aab:	44 89 e0             	mov    %r12d,%eax
  800aae:	83 e0 04             	and    $0x4,%eax
  800ab1:	c1 f8 02             	sar    $0x2,%eax
  800ab4:	89 c2                	mov    %eax,%edx
  800ab6:	44 89 e0             	mov    %r12d,%eax
  800ab9:	83 e0 02             	and    $0x2,%eax
  800abc:	09 c2                	or     %eax,%edx
  800abe:	44 89 e0             	mov    %r12d,%eax
  800ac1:	83 e0 01             	and    $0x1,%eax
  800ac4:	c1 e0 06             	shl    $0x6,%eax
  800ac7:	09 c2                	or     %eax,%edx
  800ac9:	41 89 d4             	mov    %edx,%r12d
  800acc:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800ad3:	00 00 00 
  800ad6:	8b 00                	mov    (%rax),%eax
  800ad8:	44 89 e2             	mov    %r12d,%edx
  800adb:	09 c2                	or     %eax,%edx
  800add:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800ae4:	00 00 00 
  800ae7:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800ae9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af1:	48 89 d6             	mov    %rdx,%rsi
  800af4:	89 df                	mov    %ebx,%edi
  800af6:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800af8:	83 fb 6d             	cmp    $0x6d,%ebx
  800afb:	75 1b                	jne    800b18 <vprintfmt+0x232>
					fmt ++;
  800afd:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800b02:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800b03:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800b0a:	00 00 00 
  800b0d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800b13:	e9 cb 04 00 00       	jmpq   800fe3 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800b18:	e9 83 fe ff ff       	jmpq   8009a0 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800b1d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b21:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b28:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b36:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b3d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b41:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b45:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b49:	0f b6 00             	movzbl (%rax),%eax
  800b4c:	0f b6 d8             	movzbl %al,%ebx
  800b4f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b52:	83 f8 55             	cmp    $0x55,%eax
  800b55:	0f 87 5a 04 00 00    	ja     800fb5 <vprintfmt+0x6cf>
  800b5b:	89 c0                	mov    %eax,%eax
  800b5d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b64:	00 
  800b65:	48 b8 f0 45 80 00 00 	movabs $0x8045f0,%rax
  800b6c:	00 00 00 
  800b6f:	48 01 d0             	add    %rdx,%rax
  800b72:	48 8b 00             	mov    (%rax),%rax
  800b75:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b77:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800b7b:	eb c0                	jmp    800b3d <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b7d:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800b81:	eb ba                	jmp    800b3d <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b83:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b8a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b8d:	89 d0                	mov    %edx,%eax
  800b8f:	c1 e0 02             	shl    $0x2,%eax
  800b92:	01 d0                	add    %edx,%eax
  800b94:	01 c0                	add    %eax,%eax
  800b96:	01 d8                	add    %ebx,%eax
  800b98:	83 e8 30             	sub    $0x30,%eax
  800b9b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b9e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ba2:	0f b6 00             	movzbl (%rax),%eax
  800ba5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ba8:	83 fb 2f             	cmp    $0x2f,%ebx
  800bab:	7e 0c                	jle    800bb9 <vprintfmt+0x2d3>
  800bad:	83 fb 39             	cmp    $0x39,%ebx
  800bb0:	7f 07                	jg     800bb9 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bb2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bb7:	eb d1                	jmp    800b8a <vprintfmt+0x2a4>
			goto process_precision;
  800bb9:	eb 58                	jmp    800c13 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800bbb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bbe:	83 f8 30             	cmp    $0x30,%eax
  800bc1:	73 17                	jae    800bda <vprintfmt+0x2f4>
  800bc3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bca:	89 c0                	mov    %eax,%eax
  800bcc:	48 01 d0             	add    %rdx,%rax
  800bcf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd2:	83 c2 08             	add    $0x8,%edx
  800bd5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bd8:	eb 0f                	jmp    800be9 <vprintfmt+0x303>
  800bda:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bde:	48 89 d0             	mov    %rdx,%rax
  800be1:	48 83 c2 08          	add    $0x8,%rdx
  800be5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800be9:	8b 00                	mov    (%rax),%eax
  800beb:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800bee:	eb 23                	jmp    800c13 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800bf0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bf4:	79 0c                	jns    800c02 <vprintfmt+0x31c>
				width = 0;
  800bf6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800bfd:	e9 3b ff ff ff       	jmpq   800b3d <vprintfmt+0x257>
  800c02:	e9 36 ff ff ff       	jmpq   800b3d <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800c07:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c0e:	e9 2a ff ff ff       	jmpq   800b3d <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800c13:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c17:	79 12                	jns    800c2b <vprintfmt+0x345>
				width = precision, precision = -1;
  800c19:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c1c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c1f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c26:	e9 12 ff ff ff       	jmpq   800b3d <vprintfmt+0x257>
  800c2b:	e9 0d ff ff ff       	jmpq   800b3d <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c30:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c34:	e9 04 ff ff ff       	jmpq   800b3d <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3c:	83 f8 30             	cmp    $0x30,%eax
  800c3f:	73 17                	jae    800c58 <vprintfmt+0x372>
  800c41:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c45:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c48:	89 c0                	mov    %eax,%eax
  800c4a:	48 01 d0             	add    %rdx,%rax
  800c4d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c50:	83 c2 08             	add    $0x8,%edx
  800c53:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c56:	eb 0f                	jmp    800c67 <vprintfmt+0x381>
  800c58:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c5c:	48 89 d0             	mov    %rdx,%rax
  800c5f:	48 83 c2 08          	add    $0x8,%rdx
  800c63:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c67:	8b 10                	mov    (%rax),%edx
  800c69:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c71:	48 89 ce             	mov    %rcx,%rsi
  800c74:	89 d7                	mov    %edx,%edi
  800c76:	ff d0                	callq  *%rax
			break;
  800c78:	e9 66 03 00 00       	jmpq   800fe3 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800c7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c80:	83 f8 30             	cmp    $0x30,%eax
  800c83:	73 17                	jae    800c9c <vprintfmt+0x3b6>
  800c85:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c89:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8c:	89 c0                	mov    %eax,%eax
  800c8e:	48 01 d0             	add    %rdx,%rax
  800c91:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c94:	83 c2 08             	add    $0x8,%edx
  800c97:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c9a:	eb 0f                	jmp    800cab <vprintfmt+0x3c5>
  800c9c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ca0:	48 89 d0             	mov    %rdx,%rax
  800ca3:	48 83 c2 08          	add    $0x8,%rdx
  800ca7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cab:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cad:	85 db                	test   %ebx,%ebx
  800caf:	79 02                	jns    800cb3 <vprintfmt+0x3cd>
				err = -err;
  800cb1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cb3:	83 fb 10             	cmp    $0x10,%ebx
  800cb6:	7f 16                	jg     800cce <vprintfmt+0x3e8>
  800cb8:	48 b8 40 45 80 00 00 	movabs $0x804540,%rax
  800cbf:	00 00 00 
  800cc2:	48 63 d3             	movslq %ebx,%rdx
  800cc5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800cc9:	4d 85 e4             	test   %r12,%r12
  800ccc:	75 2e                	jne    800cfc <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800cce:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cd2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd6:	89 d9                	mov    %ebx,%ecx
  800cd8:	48 ba d9 45 80 00 00 	movabs $0x8045d9,%rdx
  800cdf:	00 00 00 
  800ce2:	48 89 c7             	mov    %rax,%rdi
  800ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cea:	49 b8 f1 0f 80 00 00 	movabs $0x800ff1,%r8
  800cf1:	00 00 00 
  800cf4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cf7:	e9 e7 02 00 00       	jmpq   800fe3 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cfc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d04:	4c 89 e1             	mov    %r12,%rcx
  800d07:	48 ba e2 45 80 00 00 	movabs $0x8045e2,%rdx
  800d0e:	00 00 00 
  800d11:	48 89 c7             	mov    %rax,%rdi
  800d14:	b8 00 00 00 00       	mov    $0x0,%eax
  800d19:	49 b8 f1 0f 80 00 00 	movabs $0x800ff1,%r8
  800d20:	00 00 00 
  800d23:	41 ff d0             	callq  *%r8
			break;
  800d26:	e9 b8 02 00 00       	jmpq   800fe3 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d2b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2e:	83 f8 30             	cmp    $0x30,%eax
  800d31:	73 17                	jae    800d4a <vprintfmt+0x464>
  800d33:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d37:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d3a:	89 c0                	mov    %eax,%eax
  800d3c:	48 01 d0             	add    %rdx,%rax
  800d3f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d42:	83 c2 08             	add    $0x8,%edx
  800d45:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d48:	eb 0f                	jmp    800d59 <vprintfmt+0x473>
  800d4a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d4e:	48 89 d0             	mov    %rdx,%rax
  800d51:	48 83 c2 08          	add    $0x8,%rdx
  800d55:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d59:	4c 8b 20             	mov    (%rax),%r12
  800d5c:	4d 85 e4             	test   %r12,%r12
  800d5f:	75 0a                	jne    800d6b <vprintfmt+0x485>
				p = "(null)";
  800d61:	49 bc e5 45 80 00 00 	movabs $0x8045e5,%r12
  800d68:	00 00 00 
			if (width > 0 && padc != '-')
  800d6b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d6f:	7e 3f                	jle    800db0 <vprintfmt+0x4ca>
  800d71:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d75:	74 39                	je     800db0 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d77:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d7a:	48 98                	cltq   
  800d7c:	48 89 c6             	mov    %rax,%rsi
  800d7f:	4c 89 e7             	mov    %r12,%rdi
  800d82:	48 b8 9d 12 80 00 00 	movabs $0x80129d,%rax
  800d89:	00 00 00 
  800d8c:	ff d0                	callq  *%rax
  800d8e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d91:	eb 17                	jmp    800daa <vprintfmt+0x4c4>
					putch(padc, putdat);
  800d93:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d97:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9f:	48 89 ce             	mov    %rcx,%rsi
  800da2:	89 d7                	mov    %edx,%edi
  800da4:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800da6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800daa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dae:	7f e3                	jg     800d93 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800db0:	eb 37                	jmp    800de9 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800db2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800db6:	74 1e                	je     800dd6 <vprintfmt+0x4f0>
  800db8:	83 fb 1f             	cmp    $0x1f,%ebx
  800dbb:	7e 05                	jle    800dc2 <vprintfmt+0x4dc>
  800dbd:	83 fb 7e             	cmp    $0x7e,%ebx
  800dc0:	7e 14                	jle    800dd6 <vprintfmt+0x4f0>
					putch('?', putdat);
  800dc2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dca:	48 89 d6             	mov    %rdx,%rsi
  800dcd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800dd2:	ff d0                	callq  *%rax
  800dd4:	eb 0f                	jmp    800de5 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800dd6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dda:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dde:	48 89 d6             	mov    %rdx,%rsi
  800de1:	89 df                	mov    %ebx,%edi
  800de3:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800de5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800de9:	4c 89 e0             	mov    %r12,%rax
  800dec:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800df0:	0f b6 00             	movzbl (%rax),%eax
  800df3:	0f be d8             	movsbl %al,%ebx
  800df6:	85 db                	test   %ebx,%ebx
  800df8:	74 10                	je     800e0a <vprintfmt+0x524>
  800dfa:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800dfe:	78 b2                	js     800db2 <vprintfmt+0x4cc>
  800e00:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e04:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e08:	79 a8                	jns    800db2 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e0a:	eb 16                	jmp    800e22 <vprintfmt+0x53c>
				putch(' ', putdat);
  800e0c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e14:	48 89 d6             	mov    %rdx,%rsi
  800e17:	bf 20 00 00 00       	mov    $0x20,%edi
  800e1c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e1e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e22:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e26:	7f e4                	jg     800e0c <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800e28:	e9 b6 01 00 00       	jmpq   800fe3 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e2d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e31:	be 03 00 00 00       	mov    $0x3,%esi
  800e36:	48 89 c7             	mov    %rax,%rdi
  800e39:	48 b8 d6 07 80 00 00 	movabs $0x8007d6,%rax
  800e40:	00 00 00 
  800e43:	ff d0                	callq  *%rax
  800e45:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4d:	48 85 c0             	test   %rax,%rax
  800e50:	79 1d                	jns    800e6f <vprintfmt+0x589>
				putch('-', putdat);
  800e52:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5a:	48 89 d6             	mov    %rdx,%rsi
  800e5d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e62:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e68:	48 f7 d8             	neg    %rax
  800e6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e6f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e76:	e9 fb 00 00 00       	jmpq   800f76 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e7b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e7f:	be 03 00 00 00       	mov    $0x3,%esi
  800e84:	48 89 c7             	mov    %rax,%rdi
  800e87:	48 b8 c6 06 80 00 00 	movabs $0x8006c6,%rax
  800e8e:	00 00 00 
  800e91:	ff d0                	callq  *%rax
  800e93:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e97:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e9e:	e9 d3 00 00 00       	jmpq   800f76 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800ea3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ea7:	be 03 00 00 00       	mov    $0x3,%esi
  800eac:	48 89 c7             	mov    %rax,%rdi
  800eaf:	48 b8 d6 07 80 00 00 	movabs $0x8007d6,%rax
  800eb6:	00 00 00 
  800eb9:	ff d0                	callq  *%rax
  800ebb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec3:	48 85 c0             	test   %rax,%rax
  800ec6:	79 1d                	jns    800ee5 <vprintfmt+0x5ff>
				putch('-', putdat);
  800ec8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ecc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed0:	48 89 d6             	mov    %rdx,%rsi
  800ed3:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ed8:	ff d0                	callq  *%rax
				num = -(long long) num;
  800eda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ede:	48 f7 d8             	neg    %rax
  800ee1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800ee5:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800eec:	e9 85 00 00 00       	jmpq   800f76 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800ef1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef9:	48 89 d6             	mov    %rdx,%rsi
  800efc:	bf 30 00 00 00       	mov    $0x30,%edi
  800f01:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f03:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f0b:	48 89 d6             	mov    %rdx,%rsi
  800f0e:	bf 78 00 00 00       	mov    $0x78,%edi
  800f13:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f15:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f18:	83 f8 30             	cmp    $0x30,%eax
  800f1b:	73 17                	jae    800f34 <vprintfmt+0x64e>
  800f1d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f21:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f24:	89 c0                	mov    %eax,%eax
  800f26:	48 01 d0             	add    %rdx,%rax
  800f29:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f2c:	83 c2 08             	add    $0x8,%edx
  800f2f:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f32:	eb 0f                	jmp    800f43 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800f34:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f38:	48 89 d0             	mov    %rdx,%rax
  800f3b:	48 83 c2 08          	add    $0x8,%rdx
  800f3f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f43:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f46:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f4a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f51:	eb 23                	jmp    800f76 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f53:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f57:	be 03 00 00 00       	mov    $0x3,%esi
  800f5c:	48 89 c7             	mov    %rax,%rdi
  800f5f:	48 b8 c6 06 80 00 00 	movabs $0x8006c6,%rax
  800f66:	00 00 00 
  800f69:	ff d0                	callq  *%rax
  800f6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f6f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f76:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f7b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f7e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f81:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f85:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f8d:	45 89 c1             	mov    %r8d,%r9d
  800f90:	41 89 f8             	mov    %edi,%r8d
  800f93:	48 89 c7             	mov    %rax,%rdi
  800f96:	48 b8 0b 06 80 00 00 	movabs $0x80060b,%rax
  800f9d:	00 00 00 
  800fa0:	ff d0                	callq  *%rax
			break;
  800fa2:	eb 3f                	jmp    800fe3 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fa4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fa8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fac:	48 89 d6             	mov    %rdx,%rsi
  800faf:	89 df                	mov    %ebx,%edi
  800fb1:	ff d0                	callq  *%rax
			break;
  800fb3:	eb 2e                	jmp    800fe3 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fb5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fbd:	48 89 d6             	mov    %rdx,%rsi
  800fc0:	bf 25 00 00 00       	mov    $0x25,%edi
  800fc5:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fc7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fcc:	eb 05                	jmp    800fd3 <vprintfmt+0x6ed>
  800fce:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fd3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fd7:	48 83 e8 01          	sub    $0x1,%rax
  800fdb:	0f b6 00             	movzbl (%rax),%eax
  800fde:	3c 25                	cmp    $0x25,%al
  800fe0:	75 ec                	jne    800fce <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  800fe2:	90                   	nop
		}
	}
  800fe3:	e9 37 f9 ff ff       	jmpq   80091f <vprintfmt+0x39>
    va_end(aq);
}
  800fe8:	48 83 c4 60          	add    $0x60,%rsp
  800fec:	5b                   	pop    %rbx
  800fed:	41 5c                	pop    %r12
  800fef:	5d                   	pop    %rbp
  800ff0:	c3                   	retq   

0000000000800ff1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ff1:	55                   	push   %rbp
  800ff2:	48 89 e5             	mov    %rsp,%rbp
  800ff5:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ffc:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801003:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80100a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801011:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801018:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80101f:	84 c0                	test   %al,%al
  801021:	74 20                	je     801043 <printfmt+0x52>
  801023:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801027:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80102b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80102f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801033:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801037:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80103b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80103f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801043:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80104a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801051:	00 00 00 
  801054:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80105b:	00 00 00 
  80105e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801062:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801069:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801070:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801077:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80107e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801085:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80108c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801093:	48 89 c7             	mov    %rax,%rdi
  801096:	48 b8 e6 08 80 00 00 	movabs $0x8008e6,%rax
  80109d:	00 00 00 
  8010a0:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010a2:	c9                   	leaveq 
  8010a3:	c3                   	retq   

00000000008010a4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010a4:	55                   	push   %rbp
  8010a5:	48 89 e5             	mov    %rsp,%rbp
  8010a8:	48 83 ec 10          	sub    $0x10,%rsp
  8010ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b7:	8b 40 10             	mov    0x10(%rax),%eax
  8010ba:	8d 50 01             	lea    0x1(%rax),%edx
  8010bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c1:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c8:	48 8b 10             	mov    (%rax),%rdx
  8010cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010cf:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010d3:	48 39 c2             	cmp    %rax,%rdx
  8010d6:	73 17                	jae    8010ef <sprintputch+0x4b>
		*b->buf++ = ch;
  8010d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010dc:	48 8b 00             	mov    (%rax),%rax
  8010df:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010e7:	48 89 0a             	mov    %rcx,(%rdx)
  8010ea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010ed:	88 10                	mov    %dl,(%rax)
}
  8010ef:	c9                   	leaveq 
  8010f0:	c3                   	retq   

00000000008010f1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010f1:	55                   	push   %rbp
  8010f2:	48 89 e5             	mov    %rsp,%rbp
  8010f5:	48 83 ec 50          	sub    $0x50,%rsp
  8010f9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8010fd:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801100:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801104:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801108:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80110c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801110:	48 8b 0a             	mov    (%rdx),%rcx
  801113:	48 89 08             	mov    %rcx,(%rax)
  801116:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80111a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80111e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801122:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801126:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80112a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80112e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801131:	48 98                	cltq   
  801133:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801137:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80113b:	48 01 d0             	add    %rdx,%rax
  80113e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801142:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801149:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80114e:	74 06                	je     801156 <vsnprintf+0x65>
  801150:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801154:	7f 07                	jg     80115d <vsnprintf+0x6c>
		return -E_INVAL;
  801156:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115b:	eb 2f                	jmp    80118c <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80115d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801161:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801165:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801169:	48 89 c6             	mov    %rax,%rsi
  80116c:	48 bf a4 10 80 00 00 	movabs $0x8010a4,%rdi
  801173:	00 00 00 
  801176:	48 b8 e6 08 80 00 00 	movabs $0x8008e6,%rax
  80117d:	00 00 00 
  801180:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801182:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801186:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801189:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80118c:	c9                   	leaveq 
  80118d:	c3                   	retq   

000000000080118e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80118e:	55                   	push   %rbp
  80118f:	48 89 e5             	mov    %rsp,%rbp
  801192:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801199:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011a0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011a6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011ad:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011b4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011bb:	84 c0                	test   %al,%al
  8011bd:	74 20                	je     8011df <snprintf+0x51>
  8011bf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011c3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011c7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011cb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011cf:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011d3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011d7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011db:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8011df:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011e6:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011ed:	00 00 00 
  8011f0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011f7:	00 00 00 
  8011fa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011fe:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801205:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80120c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801213:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80121a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801221:	48 8b 0a             	mov    (%rdx),%rcx
  801224:	48 89 08             	mov    %rcx,(%rax)
  801227:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80122b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80122f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801233:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801237:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80123e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801245:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80124b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801252:	48 89 c7             	mov    %rax,%rdi
  801255:	48 b8 f1 10 80 00 00 	movabs $0x8010f1,%rax
  80125c:	00 00 00 
  80125f:	ff d0                	callq  *%rax
  801261:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801267:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80126d:	c9                   	leaveq 
  80126e:	c3                   	retq   

000000000080126f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80126f:	55                   	push   %rbp
  801270:	48 89 e5             	mov    %rsp,%rbp
  801273:	48 83 ec 18          	sub    $0x18,%rsp
  801277:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801282:	eb 09                	jmp    80128d <strlen+0x1e>
		n++;
  801284:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801288:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80128d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801291:	0f b6 00             	movzbl (%rax),%eax
  801294:	84 c0                	test   %al,%al
  801296:	75 ec                	jne    801284 <strlen+0x15>
		n++;
	return n;
  801298:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80129b:	c9                   	leaveq 
  80129c:	c3                   	retq   

000000000080129d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80129d:	55                   	push   %rbp
  80129e:	48 89 e5             	mov    %rsp,%rbp
  8012a1:	48 83 ec 20          	sub    $0x20,%rsp
  8012a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012b4:	eb 0e                	jmp    8012c4 <strnlen+0x27>
		n++;
  8012b6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ba:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012bf:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012c4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012c9:	74 0b                	je     8012d6 <strnlen+0x39>
  8012cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cf:	0f b6 00             	movzbl (%rax),%eax
  8012d2:	84 c0                	test   %al,%al
  8012d4:	75 e0                	jne    8012b6 <strnlen+0x19>
		n++;
	return n;
  8012d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012d9:	c9                   	leaveq 
  8012da:	c3                   	retq   

00000000008012db <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012db:	55                   	push   %rbp
  8012dc:	48 89 e5             	mov    %rsp,%rbp
  8012df:	48 83 ec 20          	sub    $0x20,%rsp
  8012e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8012f3:	90                   	nop
  8012f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801300:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801304:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801308:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80130c:	0f b6 12             	movzbl (%rdx),%edx
  80130f:	88 10                	mov    %dl,(%rax)
  801311:	0f b6 00             	movzbl (%rax),%eax
  801314:	84 c0                	test   %al,%al
  801316:	75 dc                	jne    8012f4 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801318:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80131c:	c9                   	leaveq 
  80131d:	c3                   	retq   

000000000080131e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80131e:	55                   	push   %rbp
  80131f:	48 89 e5             	mov    %rsp,%rbp
  801322:	48 83 ec 20          	sub    $0x20,%rsp
  801326:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80132a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80132e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801332:	48 89 c7             	mov    %rax,%rdi
  801335:	48 b8 6f 12 80 00 00 	movabs $0x80126f,%rax
  80133c:	00 00 00 
  80133f:	ff d0                	callq  *%rax
  801341:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801344:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801347:	48 63 d0             	movslq %eax,%rdx
  80134a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134e:	48 01 c2             	add    %rax,%rdx
  801351:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801355:	48 89 c6             	mov    %rax,%rsi
  801358:	48 89 d7             	mov    %rdx,%rdi
  80135b:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  801362:	00 00 00 
  801365:	ff d0                	callq  *%rax
	return dst;
  801367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80136b:	c9                   	leaveq 
  80136c:	c3                   	retq   

000000000080136d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80136d:	55                   	push   %rbp
  80136e:	48 89 e5             	mov    %rsp,%rbp
  801371:	48 83 ec 28          	sub    $0x28,%rsp
  801375:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801379:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80137d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801381:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801385:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801389:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801390:	00 
  801391:	eb 2a                	jmp    8013bd <strncpy+0x50>
		*dst++ = *src;
  801393:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801397:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80139b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80139f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013a3:	0f b6 12             	movzbl (%rdx),%edx
  8013a6:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013ac:	0f b6 00             	movzbl (%rax),%eax
  8013af:	84 c0                	test   %al,%al
  8013b1:	74 05                	je     8013b8 <strncpy+0x4b>
			src++;
  8013b3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013b8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013c5:	72 cc                	jb     801393 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013cb:	c9                   	leaveq 
  8013cc:	c3                   	retq   

00000000008013cd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013cd:	55                   	push   %rbp
  8013ce:	48 89 e5             	mov    %rsp,%rbp
  8013d1:	48 83 ec 28          	sub    $0x28,%rsp
  8013d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013e9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013ee:	74 3d                	je     80142d <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8013f0:	eb 1d                	jmp    80140f <strlcpy+0x42>
			*dst++ = *src++;
  8013f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013fe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801402:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801406:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80140a:	0f b6 12             	movzbl (%rdx),%edx
  80140d:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80140f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801414:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801419:	74 0b                	je     801426 <strlcpy+0x59>
  80141b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80141f:	0f b6 00             	movzbl (%rax),%eax
  801422:	84 c0                	test   %al,%al
  801424:	75 cc                	jne    8013f2 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801426:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142a:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80142d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801431:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801435:	48 29 c2             	sub    %rax,%rdx
  801438:	48 89 d0             	mov    %rdx,%rax
}
  80143b:	c9                   	leaveq 
  80143c:	c3                   	retq   

000000000080143d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80143d:	55                   	push   %rbp
  80143e:	48 89 e5             	mov    %rsp,%rbp
  801441:	48 83 ec 10          	sub    $0x10,%rsp
  801445:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801449:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80144d:	eb 0a                	jmp    801459 <strcmp+0x1c>
		p++, q++;
  80144f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801454:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801459:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145d:	0f b6 00             	movzbl (%rax),%eax
  801460:	84 c0                	test   %al,%al
  801462:	74 12                	je     801476 <strcmp+0x39>
  801464:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801468:	0f b6 10             	movzbl (%rax),%edx
  80146b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146f:	0f b6 00             	movzbl (%rax),%eax
  801472:	38 c2                	cmp    %al,%dl
  801474:	74 d9                	je     80144f <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801476:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147a:	0f b6 00             	movzbl (%rax),%eax
  80147d:	0f b6 d0             	movzbl %al,%edx
  801480:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801484:	0f b6 00             	movzbl (%rax),%eax
  801487:	0f b6 c0             	movzbl %al,%eax
  80148a:	29 c2                	sub    %eax,%edx
  80148c:	89 d0                	mov    %edx,%eax
}
  80148e:	c9                   	leaveq 
  80148f:	c3                   	retq   

0000000000801490 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801490:	55                   	push   %rbp
  801491:	48 89 e5             	mov    %rsp,%rbp
  801494:	48 83 ec 18          	sub    $0x18,%rsp
  801498:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80149c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014a4:	eb 0f                	jmp    8014b5 <strncmp+0x25>
		n--, p++, q++;
  8014a6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014ba:	74 1d                	je     8014d9 <strncmp+0x49>
  8014bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c0:	0f b6 00             	movzbl (%rax),%eax
  8014c3:	84 c0                	test   %al,%al
  8014c5:	74 12                	je     8014d9 <strncmp+0x49>
  8014c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cb:	0f b6 10             	movzbl (%rax),%edx
  8014ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d2:	0f b6 00             	movzbl (%rax),%eax
  8014d5:	38 c2                	cmp    %al,%dl
  8014d7:	74 cd                	je     8014a6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014d9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014de:	75 07                	jne    8014e7 <strncmp+0x57>
		return 0;
  8014e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e5:	eb 18                	jmp    8014ff <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014eb:	0f b6 00             	movzbl (%rax),%eax
  8014ee:	0f b6 d0             	movzbl %al,%edx
  8014f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f5:	0f b6 00             	movzbl (%rax),%eax
  8014f8:	0f b6 c0             	movzbl %al,%eax
  8014fb:	29 c2                	sub    %eax,%edx
  8014fd:	89 d0                	mov    %edx,%eax
}
  8014ff:	c9                   	leaveq 
  801500:	c3                   	retq   

0000000000801501 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801501:	55                   	push   %rbp
  801502:	48 89 e5             	mov    %rsp,%rbp
  801505:	48 83 ec 0c          	sub    $0xc,%rsp
  801509:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80150d:	89 f0                	mov    %esi,%eax
  80150f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801512:	eb 17                	jmp    80152b <strchr+0x2a>
		if (*s == c)
  801514:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801518:	0f b6 00             	movzbl (%rax),%eax
  80151b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80151e:	75 06                	jne    801526 <strchr+0x25>
			return (char *) s;
  801520:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801524:	eb 15                	jmp    80153b <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801526:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80152b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152f:	0f b6 00             	movzbl (%rax),%eax
  801532:	84 c0                	test   %al,%al
  801534:	75 de                	jne    801514 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801536:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153b:	c9                   	leaveq 
  80153c:	c3                   	retq   

000000000080153d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80153d:	55                   	push   %rbp
  80153e:	48 89 e5             	mov    %rsp,%rbp
  801541:	48 83 ec 0c          	sub    $0xc,%rsp
  801545:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801549:	89 f0                	mov    %esi,%eax
  80154b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80154e:	eb 13                	jmp    801563 <strfind+0x26>
		if (*s == c)
  801550:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801554:	0f b6 00             	movzbl (%rax),%eax
  801557:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80155a:	75 02                	jne    80155e <strfind+0x21>
			break;
  80155c:	eb 10                	jmp    80156e <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80155e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801563:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801567:	0f b6 00             	movzbl (%rax),%eax
  80156a:	84 c0                	test   %al,%al
  80156c:	75 e2                	jne    801550 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80156e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801572:	c9                   	leaveq 
  801573:	c3                   	retq   

0000000000801574 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801574:	55                   	push   %rbp
  801575:	48 89 e5             	mov    %rsp,%rbp
  801578:	48 83 ec 18          	sub    $0x18,%rsp
  80157c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801580:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801583:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801587:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80158c:	75 06                	jne    801594 <memset+0x20>
		return v;
  80158e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801592:	eb 69                	jmp    8015fd <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801598:	83 e0 03             	and    $0x3,%eax
  80159b:	48 85 c0             	test   %rax,%rax
  80159e:	75 48                	jne    8015e8 <memset+0x74>
  8015a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a4:	83 e0 03             	and    $0x3,%eax
  8015a7:	48 85 c0             	test   %rax,%rax
  8015aa:	75 3c                	jne    8015e8 <memset+0x74>
		c &= 0xFF;
  8015ac:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015b6:	c1 e0 18             	shl    $0x18,%eax
  8015b9:	89 c2                	mov    %eax,%edx
  8015bb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015be:	c1 e0 10             	shl    $0x10,%eax
  8015c1:	09 c2                	or     %eax,%edx
  8015c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015c6:	c1 e0 08             	shl    $0x8,%eax
  8015c9:	09 d0                	or     %edx,%eax
  8015cb:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8015ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d2:	48 c1 e8 02          	shr    $0x2,%rax
  8015d6:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015d9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e0:	48 89 d7             	mov    %rdx,%rdi
  8015e3:	fc                   	cld    
  8015e4:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015e6:	eb 11                	jmp    8015f9 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ef:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015f3:	48 89 d7             	mov    %rdx,%rdi
  8015f6:	fc                   	cld    
  8015f7:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8015f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015fd:	c9                   	leaveq 
  8015fe:	c3                   	retq   

00000000008015ff <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8015ff:	55                   	push   %rbp
  801600:	48 89 e5             	mov    %rsp,%rbp
  801603:	48 83 ec 28          	sub    $0x28,%rsp
  801607:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80160b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80160f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801613:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801617:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80161b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80161f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801623:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801627:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80162b:	0f 83 88 00 00 00    	jae    8016b9 <memmove+0xba>
  801631:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801635:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801639:	48 01 d0             	add    %rdx,%rax
  80163c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801640:	76 77                	jbe    8016b9 <memmove+0xba>
		s += n;
  801642:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801646:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80164a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801652:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801656:	83 e0 03             	and    $0x3,%eax
  801659:	48 85 c0             	test   %rax,%rax
  80165c:	75 3b                	jne    801699 <memmove+0x9a>
  80165e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801662:	83 e0 03             	and    $0x3,%eax
  801665:	48 85 c0             	test   %rax,%rax
  801668:	75 2f                	jne    801699 <memmove+0x9a>
  80166a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166e:	83 e0 03             	and    $0x3,%eax
  801671:	48 85 c0             	test   %rax,%rax
  801674:	75 23                	jne    801699 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801676:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167a:	48 83 e8 04          	sub    $0x4,%rax
  80167e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801682:	48 83 ea 04          	sub    $0x4,%rdx
  801686:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80168a:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80168e:	48 89 c7             	mov    %rax,%rdi
  801691:	48 89 d6             	mov    %rdx,%rsi
  801694:	fd                   	std    
  801695:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801697:	eb 1d                	jmp    8016b6 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801699:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a5:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ad:	48 89 d7             	mov    %rdx,%rdi
  8016b0:	48 89 c1             	mov    %rax,%rcx
  8016b3:	fd                   	std    
  8016b4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016b6:	fc                   	cld    
  8016b7:	eb 57                	jmp    801710 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016bd:	83 e0 03             	and    $0x3,%eax
  8016c0:	48 85 c0             	test   %rax,%rax
  8016c3:	75 36                	jne    8016fb <memmove+0xfc>
  8016c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c9:	83 e0 03             	and    $0x3,%eax
  8016cc:	48 85 c0             	test   %rax,%rax
  8016cf:	75 2a                	jne    8016fb <memmove+0xfc>
  8016d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d5:	83 e0 03             	and    $0x3,%eax
  8016d8:	48 85 c0             	test   %rax,%rax
  8016db:	75 1e                	jne    8016fb <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e1:	48 c1 e8 02          	shr    $0x2,%rax
  8016e5:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016f0:	48 89 c7             	mov    %rax,%rdi
  8016f3:	48 89 d6             	mov    %rdx,%rsi
  8016f6:	fc                   	cld    
  8016f7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016f9:	eb 15                	jmp    801710 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8016fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801703:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801707:	48 89 c7             	mov    %rax,%rdi
  80170a:	48 89 d6             	mov    %rdx,%rsi
  80170d:	fc                   	cld    
  80170e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801710:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801714:	c9                   	leaveq 
  801715:	c3                   	retq   

0000000000801716 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801716:	55                   	push   %rbp
  801717:	48 89 e5             	mov    %rsp,%rbp
  80171a:	48 83 ec 18          	sub    $0x18,%rsp
  80171e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801722:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801726:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80172a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80172e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801732:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801736:	48 89 ce             	mov    %rcx,%rsi
  801739:	48 89 c7             	mov    %rax,%rdi
  80173c:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  801743:	00 00 00 
  801746:	ff d0                	callq  *%rax
}
  801748:	c9                   	leaveq 
  801749:	c3                   	retq   

000000000080174a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80174a:	55                   	push   %rbp
  80174b:	48 89 e5             	mov    %rsp,%rbp
  80174e:	48 83 ec 28          	sub    $0x28,%rsp
  801752:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801756:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80175a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80175e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801762:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801766:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80176a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80176e:	eb 36                	jmp    8017a6 <memcmp+0x5c>
		if (*s1 != *s2)
  801770:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801774:	0f b6 10             	movzbl (%rax),%edx
  801777:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177b:	0f b6 00             	movzbl (%rax),%eax
  80177e:	38 c2                	cmp    %al,%dl
  801780:	74 1a                	je     80179c <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801782:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801786:	0f b6 00             	movzbl (%rax),%eax
  801789:	0f b6 d0             	movzbl %al,%edx
  80178c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801790:	0f b6 00             	movzbl (%rax),%eax
  801793:	0f b6 c0             	movzbl %al,%eax
  801796:	29 c2                	sub    %eax,%edx
  801798:	89 d0                	mov    %edx,%eax
  80179a:	eb 20                	jmp    8017bc <memcmp+0x72>
		s1++, s2++;
  80179c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017a1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017aa:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017b2:	48 85 c0             	test   %rax,%rax
  8017b5:	75 b9                	jne    801770 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017bc:	c9                   	leaveq 
  8017bd:	c3                   	retq   

00000000008017be <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017be:	55                   	push   %rbp
  8017bf:	48 89 e5             	mov    %rsp,%rbp
  8017c2:	48 83 ec 28          	sub    $0x28,%rsp
  8017c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017ca:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017d9:	48 01 d0             	add    %rdx,%rax
  8017dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017e0:	eb 15                	jmp    8017f7 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e6:	0f b6 10             	movzbl (%rax),%edx
  8017e9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017ec:	38 c2                	cmp    %al,%dl
  8017ee:	75 02                	jne    8017f2 <memfind+0x34>
			break;
  8017f0:	eb 0f                	jmp    801801 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017f2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017fb:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8017ff:	72 e1                	jb     8017e2 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801801:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801805:	c9                   	leaveq 
  801806:	c3                   	retq   

0000000000801807 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801807:	55                   	push   %rbp
  801808:	48 89 e5             	mov    %rsp,%rbp
  80180b:	48 83 ec 34          	sub    $0x34,%rsp
  80180f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801813:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801817:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80181a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801821:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801828:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801829:	eb 05                	jmp    801830 <strtol+0x29>
		s++;
  80182b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801830:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801834:	0f b6 00             	movzbl (%rax),%eax
  801837:	3c 20                	cmp    $0x20,%al
  801839:	74 f0                	je     80182b <strtol+0x24>
  80183b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183f:	0f b6 00             	movzbl (%rax),%eax
  801842:	3c 09                	cmp    $0x9,%al
  801844:	74 e5                	je     80182b <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801846:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184a:	0f b6 00             	movzbl (%rax),%eax
  80184d:	3c 2b                	cmp    $0x2b,%al
  80184f:	75 07                	jne    801858 <strtol+0x51>
		s++;
  801851:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801856:	eb 17                	jmp    80186f <strtol+0x68>
	else if (*s == '-')
  801858:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185c:	0f b6 00             	movzbl (%rax),%eax
  80185f:	3c 2d                	cmp    $0x2d,%al
  801861:	75 0c                	jne    80186f <strtol+0x68>
		s++, neg = 1;
  801863:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801868:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80186f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801873:	74 06                	je     80187b <strtol+0x74>
  801875:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801879:	75 28                	jne    8018a3 <strtol+0x9c>
  80187b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187f:	0f b6 00             	movzbl (%rax),%eax
  801882:	3c 30                	cmp    $0x30,%al
  801884:	75 1d                	jne    8018a3 <strtol+0x9c>
  801886:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188a:	48 83 c0 01          	add    $0x1,%rax
  80188e:	0f b6 00             	movzbl (%rax),%eax
  801891:	3c 78                	cmp    $0x78,%al
  801893:	75 0e                	jne    8018a3 <strtol+0x9c>
		s += 2, base = 16;
  801895:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80189a:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018a1:	eb 2c                	jmp    8018cf <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018a7:	75 19                	jne    8018c2 <strtol+0xbb>
  8018a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ad:	0f b6 00             	movzbl (%rax),%eax
  8018b0:	3c 30                	cmp    $0x30,%al
  8018b2:	75 0e                	jne    8018c2 <strtol+0xbb>
		s++, base = 8;
  8018b4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018b9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018c0:	eb 0d                	jmp    8018cf <strtol+0xc8>
	else if (base == 0)
  8018c2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018c6:	75 07                	jne    8018cf <strtol+0xc8>
		base = 10;
  8018c8:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d3:	0f b6 00             	movzbl (%rax),%eax
  8018d6:	3c 2f                	cmp    $0x2f,%al
  8018d8:	7e 1d                	jle    8018f7 <strtol+0xf0>
  8018da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018de:	0f b6 00             	movzbl (%rax),%eax
  8018e1:	3c 39                	cmp    $0x39,%al
  8018e3:	7f 12                	jg     8018f7 <strtol+0xf0>
			dig = *s - '0';
  8018e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e9:	0f b6 00             	movzbl (%rax),%eax
  8018ec:	0f be c0             	movsbl %al,%eax
  8018ef:	83 e8 30             	sub    $0x30,%eax
  8018f2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018f5:	eb 4e                	jmp    801945 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8018f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fb:	0f b6 00             	movzbl (%rax),%eax
  8018fe:	3c 60                	cmp    $0x60,%al
  801900:	7e 1d                	jle    80191f <strtol+0x118>
  801902:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801906:	0f b6 00             	movzbl (%rax),%eax
  801909:	3c 7a                	cmp    $0x7a,%al
  80190b:	7f 12                	jg     80191f <strtol+0x118>
			dig = *s - 'a' + 10;
  80190d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801911:	0f b6 00             	movzbl (%rax),%eax
  801914:	0f be c0             	movsbl %al,%eax
  801917:	83 e8 57             	sub    $0x57,%eax
  80191a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80191d:	eb 26                	jmp    801945 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80191f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801923:	0f b6 00             	movzbl (%rax),%eax
  801926:	3c 40                	cmp    $0x40,%al
  801928:	7e 48                	jle    801972 <strtol+0x16b>
  80192a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192e:	0f b6 00             	movzbl (%rax),%eax
  801931:	3c 5a                	cmp    $0x5a,%al
  801933:	7f 3d                	jg     801972 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801935:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801939:	0f b6 00             	movzbl (%rax),%eax
  80193c:	0f be c0             	movsbl %al,%eax
  80193f:	83 e8 37             	sub    $0x37,%eax
  801942:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801945:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801948:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80194b:	7c 02                	jl     80194f <strtol+0x148>
			break;
  80194d:	eb 23                	jmp    801972 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80194f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801954:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801957:	48 98                	cltq   
  801959:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80195e:	48 89 c2             	mov    %rax,%rdx
  801961:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801964:	48 98                	cltq   
  801966:	48 01 d0             	add    %rdx,%rax
  801969:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80196d:	e9 5d ff ff ff       	jmpq   8018cf <strtol+0xc8>

	if (endptr)
  801972:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801977:	74 0b                	je     801984 <strtol+0x17d>
		*endptr = (char *) s;
  801979:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80197d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801981:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801984:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801988:	74 09                	je     801993 <strtol+0x18c>
  80198a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80198e:	48 f7 d8             	neg    %rax
  801991:	eb 04                	jmp    801997 <strtol+0x190>
  801993:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801997:	c9                   	leaveq 
  801998:	c3                   	retq   

0000000000801999 <strstr>:

char * strstr(const char *in, const char *str)
{
  801999:	55                   	push   %rbp
  80199a:	48 89 e5             	mov    %rsp,%rbp
  80199d:	48 83 ec 30          	sub    $0x30,%rsp
  8019a1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019a5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8019a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019ad:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019b1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019b5:	0f b6 00             	movzbl (%rax),%eax
  8019b8:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8019bb:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019bf:	75 06                	jne    8019c7 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8019c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c5:	eb 6b                	jmp    801a32 <strstr+0x99>

    len = strlen(str);
  8019c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019cb:	48 89 c7             	mov    %rax,%rdi
  8019ce:	48 b8 6f 12 80 00 00 	movabs $0x80126f,%rax
  8019d5:	00 00 00 
  8019d8:	ff d0                	callq  *%rax
  8019da:	48 98                	cltq   
  8019dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8019e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019e8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019ec:	0f b6 00             	movzbl (%rax),%eax
  8019ef:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8019f2:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8019f6:	75 07                	jne    8019ff <strstr+0x66>
                return (char *) 0;
  8019f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fd:	eb 33                	jmp    801a32 <strstr+0x99>
        } while (sc != c);
  8019ff:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a03:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a06:	75 d8                	jne    8019e0 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801a08:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a14:	48 89 ce             	mov    %rcx,%rsi
  801a17:	48 89 c7             	mov    %rax,%rdi
  801a1a:	48 b8 90 14 80 00 00 	movabs $0x801490,%rax
  801a21:	00 00 00 
  801a24:	ff d0                	callq  *%rax
  801a26:	85 c0                	test   %eax,%eax
  801a28:	75 b6                	jne    8019e0 <strstr+0x47>

    return (char *) (in - 1);
  801a2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2e:	48 83 e8 01          	sub    $0x1,%rax
}
  801a32:	c9                   	leaveq 
  801a33:	c3                   	retq   

0000000000801a34 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801a34:	55                   	push   %rbp
  801a35:	48 89 e5             	mov    %rsp,%rbp
  801a38:	53                   	push   %rbx
  801a39:	48 83 ec 48          	sub    $0x48,%rsp
  801a3d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801a40:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801a43:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a47:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801a4b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801a4f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a53:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a56:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801a5a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801a5e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801a62:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801a66:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801a6a:	4c 89 c3             	mov    %r8,%rbx
  801a6d:	cd 30                	int    $0x30
  801a6f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801a73:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801a77:	74 3e                	je     801ab7 <syscall+0x83>
  801a79:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a7e:	7e 37                	jle    801ab7 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a80:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a84:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a87:	49 89 d0             	mov    %rdx,%r8
  801a8a:	89 c1                	mov    %eax,%ecx
  801a8c:	48 ba a0 48 80 00 00 	movabs $0x8048a0,%rdx
  801a93:	00 00 00 
  801a96:	be 23 00 00 00       	mov    $0x23,%esi
  801a9b:	48 bf bd 48 80 00 00 	movabs $0x8048bd,%rdi
  801aa2:	00 00 00 
  801aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  801aaa:	49 b9 fa 02 80 00 00 	movabs $0x8002fa,%r9
  801ab1:	00 00 00 
  801ab4:	41 ff d1             	callq  *%r9

	return ret;
  801ab7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801abb:	48 83 c4 48          	add    $0x48,%rsp
  801abf:	5b                   	pop    %rbx
  801ac0:	5d                   	pop    %rbp
  801ac1:	c3                   	retq   

0000000000801ac2 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801ac2:	55                   	push   %rbp
  801ac3:	48 89 e5             	mov    %rsp,%rbp
  801ac6:	48 83 ec 20          	sub    $0x20,%rsp
  801aca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ace:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801ad2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ada:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae1:	00 
  801ae2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aee:	48 89 d1             	mov    %rdx,%rcx
  801af1:	48 89 c2             	mov    %rax,%rdx
  801af4:	be 00 00 00 00       	mov    $0x0,%esi
  801af9:	bf 00 00 00 00       	mov    $0x0,%edi
  801afe:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801b05:	00 00 00 
  801b08:	ff d0                	callq  *%rax
}
  801b0a:	c9                   	leaveq 
  801b0b:	c3                   	retq   

0000000000801b0c <sys_cgetc>:

int
sys_cgetc(void)
{
  801b0c:	55                   	push   %rbp
  801b0d:	48 89 e5             	mov    %rsp,%rbp
  801b10:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801b14:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b1b:	00 
  801b1c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b22:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b28:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b32:	be 00 00 00 00       	mov    $0x0,%esi
  801b37:	bf 01 00 00 00       	mov    $0x1,%edi
  801b3c:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801b43:	00 00 00 
  801b46:	ff d0                	callq  *%rax
}
  801b48:	c9                   	leaveq 
  801b49:	c3                   	retq   

0000000000801b4a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801b4a:	55                   	push   %rbp
  801b4b:	48 89 e5             	mov    %rsp,%rbp
  801b4e:	48 83 ec 10          	sub    $0x10,%rsp
  801b52:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801b55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b58:	48 98                	cltq   
  801b5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b61:	00 
  801b62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b73:	48 89 c2             	mov    %rax,%rdx
  801b76:	be 01 00 00 00       	mov    $0x1,%esi
  801b7b:	bf 03 00 00 00       	mov    $0x3,%edi
  801b80:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801b87:	00 00 00 
  801b8a:	ff d0                	callq  *%rax
}
  801b8c:	c9                   	leaveq 
  801b8d:	c3                   	retq   

0000000000801b8e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801b8e:	55                   	push   %rbp
  801b8f:	48 89 e5             	mov    %rsp,%rbp
  801b92:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801b96:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b9d:	00 
  801b9e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801baa:	b9 00 00 00 00       	mov    $0x0,%ecx
  801baf:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb4:	be 00 00 00 00       	mov    $0x0,%esi
  801bb9:	bf 02 00 00 00       	mov    $0x2,%edi
  801bbe:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801bc5:	00 00 00 
  801bc8:	ff d0                	callq  *%rax
}
  801bca:	c9                   	leaveq 
  801bcb:	c3                   	retq   

0000000000801bcc <sys_yield>:

void
sys_yield(void)
{
  801bcc:	55                   	push   %rbp
  801bcd:	48 89 e5             	mov    %rsp,%rbp
  801bd0:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801bd4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bdb:	00 
  801bdc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bed:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf2:	be 00 00 00 00       	mov    $0x0,%esi
  801bf7:	bf 0b 00 00 00       	mov    $0xb,%edi
  801bfc:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801c03:	00 00 00 
  801c06:	ff d0                	callq  *%rax
}
  801c08:	c9                   	leaveq 
  801c09:	c3                   	retq   

0000000000801c0a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801c0a:	55                   	push   %rbp
  801c0b:	48 89 e5             	mov    %rsp,%rbp
  801c0e:	48 83 ec 20          	sub    $0x20,%rsp
  801c12:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c15:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c19:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801c1c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c1f:	48 63 c8             	movslq %eax,%rcx
  801c22:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c29:	48 98                	cltq   
  801c2b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c32:	00 
  801c33:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c39:	49 89 c8             	mov    %rcx,%r8
  801c3c:	48 89 d1             	mov    %rdx,%rcx
  801c3f:	48 89 c2             	mov    %rax,%rdx
  801c42:	be 01 00 00 00       	mov    $0x1,%esi
  801c47:	bf 04 00 00 00       	mov    $0x4,%edi
  801c4c:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801c53:	00 00 00 
  801c56:	ff d0                	callq  *%rax
}
  801c58:	c9                   	leaveq 
  801c59:	c3                   	retq   

0000000000801c5a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801c5a:	55                   	push   %rbp
  801c5b:	48 89 e5             	mov    %rsp,%rbp
  801c5e:	48 83 ec 30          	sub    $0x30,%rsp
  801c62:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c65:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c69:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c6c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c70:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801c74:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c77:	48 63 c8             	movslq %eax,%rcx
  801c7a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c81:	48 63 f0             	movslq %eax,%rsi
  801c84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c8b:	48 98                	cltq   
  801c8d:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c91:	49 89 f9             	mov    %rdi,%r9
  801c94:	49 89 f0             	mov    %rsi,%r8
  801c97:	48 89 d1             	mov    %rdx,%rcx
  801c9a:	48 89 c2             	mov    %rax,%rdx
  801c9d:	be 01 00 00 00       	mov    $0x1,%esi
  801ca2:	bf 05 00 00 00       	mov    $0x5,%edi
  801ca7:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801cae:	00 00 00 
  801cb1:	ff d0                	callq  *%rax
}
  801cb3:	c9                   	leaveq 
  801cb4:	c3                   	retq   

0000000000801cb5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801cb5:	55                   	push   %rbp
  801cb6:	48 89 e5             	mov    %rsp,%rbp
  801cb9:	48 83 ec 20          	sub    $0x20,%rsp
  801cbd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cc0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801cc4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ccb:	48 98                	cltq   
  801ccd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd4:	00 
  801cd5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cdb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce1:	48 89 d1             	mov    %rdx,%rcx
  801ce4:	48 89 c2             	mov    %rax,%rdx
  801ce7:	be 01 00 00 00       	mov    $0x1,%esi
  801cec:	bf 06 00 00 00       	mov    $0x6,%edi
  801cf1:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801cf8:	00 00 00 
  801cfb:	ff d0                	callq  *%rax
}
  801cfd:	c9                   	leaveq 
  801cfe:	c3                   	retq   

0000000000801cff <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801cff:	55                   	push   %rbp
  801d00:	48 89 e5             	mov    %rsp,%rbp
  801d03:	48 83 ec 10          	sub    $0x10,%rsp
  801d07:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d0a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801d0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d10:	48 63 d0             	movslq %eax,%rdx
  801d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d16:	48 98                	cltq   
  801d18:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d1f:	00 
  801d20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d2c:	48 89 d1             	mov    %rdx,%rcx
  801d2f:	48 89 c2             	mov    %rax,%rdx
  801d32:	be 01 00 00 00       	mov    $0x1,%esi
  801d37:	bf 08 00 00 00       	mov    $0x8,%edi
  801d3c:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801d43:	00 00 00 
  801d46:	ff d0                	callq  *%rax
}
  801d48:	c9                   	leaveq 
  801d49:	c3                   	retq   

0000000000801d4a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801d4a:	55                   	push   %rbp
  801d4b:	48 89 e5             	mov    %rsp,%rbp
  801d4e:	48 83 ec 20          	sub    $0x20,%rsp
  801d52:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d55:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801d59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d60:	48 98                	cltq   
  801d62:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d69:	00 
  801d6a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d70:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d76:	48 89 d1             	mov    %rdx,%rcx
  801d79:	48 89 c2             	mov    %rax,%rdx
  801d7c:	be 01 00 00 00       	mov    $0x1,%esi
  801d81:	bf 09 00 00 00       	mov    $0x9,%edi
  801d86:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801d8d:	00 00 00 
  801d90:	ff d0                	callq  *%rax
}
  801d92:	c9                   	leaveq 
  801d93:	c3                   	retq   

0000000000801d94 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801d94:	55                   	push   %rbp
  801d95:	48 89 e5             	mov    %rsp,%rbp
  801d98:	48 83 ec 20          	sub    $0x20,%rsp
  801d9c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d9f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801da3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801da7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801daa:	48 98                	cltq   
  801dac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db3:	00 
  801db4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dc0:	48 89 d1             	mov    %rdx,%rcx
  801dc3:	48 89 c2             	mov    %rax,%rdx
  801dc6:	be 01 00 00 00       	mov    $0x1,%esi
  801dcb:	bf 0a 00 00 00       	mov    $0xa,%edi
  801dd0:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801dd7:	00 00 00 
  801dda:	ff d0                	callq  *%rax
}
  801ddc:	c9                   	leaveq 
  801ddd:	c3                   	retq   

0000000000801dde <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801dde:	55                   	push   %rbp
  801ddf:	48 89 e5             	mov    %rsp,%rbp
  801de2:	48 83 ec 20          	sub    $0x20,%rsp
  801de6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801de9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ded:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801df1:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801df4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801df7:	48 63 f0             	movslq %eax,%rsi
  801dfa:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801dfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e01:	48 98                	cltq   
  801e03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e07:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e0e:	00 
  801e0f:	49 89 f1             	mov    %rsi,%r9
  801e12:	49 89 c8             	mov    %rcx,%r8
  801e15:	48 89 d1             	mov    %rdx,%rcx
  801e18:	48 89 c2             	mov    %rax,%rdx
  801e1b:	be 00 00 00 00       	mov    $0x0,%esi
  801e20:	bf 0c 00 00 00       	mov    $0xc,%edi
  801e25:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801e2c:	00 00 00 
  801e2f:	ff d0                	callq  *%rax
}
  801e31:	c9                   	leaveq 
  801e32:	c3                   	retq   

0000000000801e33 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801e33:	55                   	push   %rbp
  801e34:	48 89 e5             	mov    %rsp,%rbp
  801e37:	48 83 ec 10          	sub    $0x10,%rsp
  801e3b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801e3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e43:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e4a:	00 
  801e4b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e51:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e57:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e5c:	48 89 c2             	mov    %rax,%rdx
  801e5f:	be 01 00 00 00       	mov    $0x1,%esi
  801e64:	bf 0d 00 00 00       	mov    $0xd,%edi
  801e69:	48 b8 34 1a 80 00 00 	movabs $0x801a34,%rax
  801e70:	00 00 00 
  801e73:	ff d0                	callq  *%rax
}
  801e75:	c9                   	leaveq 
  801e76:	c3                   	retq   

0000000000801e77 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e77:	55                   	push   %rbp
  801e78:	48 89 e5             	mov    %rsp,%rbp
  801e7b:	48 83 ec 08          	sub    $0x8,%rsp
  801e7f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e83:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e87:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e8e:	ff ff ff 
  801e91:	48 01 d0             	add    %rdx,%rax
  801e94:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e98:	c9                   	leaveq 
  801e99:	c3                   	retq   

0000000000801e9a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e9a:	55                   	push   %rbp
  801e9b:	48 89 e5             	mov    %rsp,%rbp
  801e9e:	48 83 ec 08          	sub    $0x8,%rsp
  801ea2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ea6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eaa:	48 89 c7             	mov    %rax,%rdi
  801ead:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  801eb4:	00 00 00 
  801eb7:	ff d0                	callq  *%rax
  801eb9:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ebf:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ec3:	c9                   	leaveq 
  801ec4:	c3                   	retq   

0000000000801ec5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ec5:	55                   	push   %rbp
  801ec6:	48 89 e5             	mov    %rsp,%rbp
  801ec9:	48 83 ec 18          	sub    $0x18,%rsp
  801ecd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ed1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ed8:	eb 6b                	jmp    801f45 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801eda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801edd:	48 98                	cltq   
  801edf:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ee5:	48 c1 e0 0c          	shl    $0xc,%rax
  801ee9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801eed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ef1:	48 c1 e8 15          	shr    $0x15,%rax
  801ef5:	48 89 c2             	mov    %rax,%rdx
  801ef8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801eff:	01 00 00 
  801f02:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f06:	83 e0 01             	and    $0x1,%eax
  801f09:	48 85 c0             	test   %rax,%rax
  801f0c:	74 21                	je     801f2f <fd_alloc+0x6a>
  801f0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f12:	48 c1 e8 0c          	shr    $0xc,%rax
  801f16:	48 89 c2             	mov    %rax,%rdx
  801f19:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f20:	01 00 00 
  801f23:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f27:	83 e0 01             	and    $0x1,%eax
  801f2a:	48 85 c0             	test   %rax,%rax
  801f2d:	75 12                	jne    801f41 <fd_alloc+0x7c>
			*fd_store = fd;
  801f2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f37:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3f:	eb 1a                	jmp    801f5b <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f41:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f45:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f49:	7e 8f                	jle    801eda <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f56:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f5b:	c9                   	leaveq 
  801f5c:	c3                   	retq   

0000000000801f5d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f5d:	55                   	push   %rbp
  801f5e:	48 89 e5             	mov    %rsp,%rbp
  801f61:	48 83 ec 20          	sub    $0x20,%rsp
  801f65:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f68:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f6c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f70:	78 06                	js     801f78 <fd_lookup+0x1b>
  801f72:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f76:	7e 07                	jle    801f7f <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f78:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f7d:	eb 6c                	jmp    801feb <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f7f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f82:	48 98                	cltq   
  801f84:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f8a:	48 c1 e0 0c          	shl    $0xc,%rax
  801f8e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f96:	48 c1 e8 15          	shr    $0x15,%rax
  801f9a:	48 89 c2             	mov    %rax,%rdx
  801f9d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fa4:	01 00 00 
  801fa7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fab:	83 e0 01             	and    $0x1,%eax
  801fae:	48 85 c0             	test   %rax,%rax
  801fb1:	74 21                	je     801fd4 <fd_lookup+0x77>
  801fb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb7:	48 c1 e8 0c          	shr    $0xc,%rax
  801fbb:	48 89 c2             	mov    %rax,%rdx
  801fbe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc5:	01 00 00 
  801fc8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fcc:	83 e0 01             	and    $0x1,%eax
  801fcf:	48 85 c0             	test   %rax,%rax
  801fd2:	75 07                	jne    801fdb <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fd4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fd9:	eb 10                	jmp    801feb <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801fdb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fdf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fe3:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801feb:	c9                   	leaveq 
  801fec:	c3                   	retq   

0000000000801fed <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801fed:	55                   	push   %rbp
  801fee:	48 89 e5             	mov    %rsp,%rbp
  801ff1:	48 83 ec 30          	sub    $0x30,%rsp
  801ff5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ff9:	89 f0                	mov    %esi,%eax
  801ffb:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ffe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802002:	48 89 c7             	mov    %rax,%rdi
  802005:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  80200c:	00 00 00 
  80200f:	ff d0                	callq  *%rax
  802011:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802015:	48 89 d6             	mov    %rdx,%rsi
  802018:	89 c7                	mov    %eax,%edi
  80201a:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  802021:	00 00 00 
  802024:	ff d0                	callq  *%rax
  802026:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802029:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80202d:	78 0a                	js     802039 <fd_close+0x4c>
	    || fd != fd2)
  80202f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802033:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802037:	74 12                	je     80204b <fd_close+0x5e>
		return (must_exist ? r : 0);
  802039:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80203d:	74 05                	je     802044 <fd_close+0x57>
  80203f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802042:	eb 05                	jmp    802049 <fd_close+0x5c>
  802044:	b8 00 00 00 00       	mov    $0x0,%eax
  802049:	eb 69                	jmp    8020b4 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80204b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80204f:	8b 00                	mov    (%rax),%eax
  802051:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802055:	48 89 d6             	mov    %rdx,%rsi
  802058:	89 c7                	mov    %eax,%edi
  80205a:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  802061:	00 00 00 
  802064:	ff d0                	callq  *%rax
  802066:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802069:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80206d:	78 2a                	js     802099 <fd_close+0xac>
		if (dev->dev_close)
  80206f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802073:	48 8b 40 20          	mov    0x20(%rax),%rax
  802077:	48 85 c0             	test   %rax,%rax
  80207a:	74 16                	je     802092 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80207c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802080:	48 8b 40 20          	mov    0x20(%rax),%rax
  802084:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802088:	48 89 d7             	mov    %rdx,%rdi
  80208b:	ff d0                	callq  *%rax
  80208d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802090:	eb 07                	jmp    802099 <fd_close+0xac>
		else
			r = 0;
  802092:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802099:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80209d:	48 89 c6             	mov    %rax,%rsi
  8020a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a5:	48 b8 b5 1c 80 00 00 	movabs $0x801cb5,%rax
  8020ac:	00 00 00 
  8020af:	ff d0                	callq  *%rax
	return r;
  8020b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020b4:	c9                   	leaveq 
  8020b5:	c3                   	retq   

00000000008020b6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020b6:	55                   	push   %rbp
  8020b7:	48 89 e5             	mov    %rsp,%rbp
  8020ba:	48 83 ec 20          	sub    $0x20,%rsp
  8020be:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020cc:	eb 41                	jmp    80210f <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020ce:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020d5:	00 00 00 
  8020d8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020db:	48 63 d2             	movslq %edx,%rdx
  8020de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e2:	8b 00                	mov    (%rax),%eax
  8020e4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8020e7:	75 22                	jne    80210b <dev_lookup+0x55>
			*dev = devtab[i];
  8020e9:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020f0:	00 00 00 
  8020f3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020f6:	48 63 d2             	movslq %edx,%rdx
  8020f9:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8020fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802101:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802104:	b8 00 00 00 00       	mov    $0x0,%eax
  802109:	eb 60                	jmp    80216b <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80210b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80210f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802116:	00 00 00 
  802119:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80211c:	48 63 d2             	movslq %edx,%rdx
  80211f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802123:	48 85 c0             	test   %rax,%rax
  802126:	75 a6                	jne    8020ce <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802128:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80212f:	00 00 00 
  802132:	48 8b 00             	mov    (%rax),%rax
  802135:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80213b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80213e:	89 c6                	mov    %eax,%esi
  802140:	48 bf d0 48 80 00 00 	movabs $0x8048d0,%rdi
  802147:	00 00 00 
  80214a:	b8 00 00 00 00       	mov    $0x0,%eax
  80214f:	48 b9 33 05 80 00 00 	movabs $0x800533,%rcx
  802156:	00 00 00 
  802159:	ff d1                	callq  *%rcx
	*dev = 0;
  80215b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80215f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802166:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80216b:	c9                   	leaveq 
  80216c:	c3                   	retq   

000000000080216d <close>:

int
close(int fdnum)
{
  80216d:	55                   	push   %rbp
  80216e:	48 89 e5             	mov    %rsp,%rbp
  802171:	48 83 ec 20          	sub    $0x20,%rsp
  802175:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802178:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80217c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80217f:	48 89 d6             	mov    %rdx,%rsi
  802182:	89 c7                	mov    %eax,%edi
  802184:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  80218b:	00 00 00 
  80218e:	ff d0                	callq  *%rax
  802190:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802193:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802197:	79 05                	jns    80219e <close+0x31>
		return r;
  802199:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80219c:	eb 18                	jmp    8021b6 <close+0x49>
	else
		return fd_close(fd, 1);
  80219e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a2:	be 01 00 00 00       	mov    $0x1,%esi
  8021a7:	48 89 c7             	mov    %rax,%rdi
  8021aa:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  8021b1:	00 00 00 
  8021b4:	ff d0                	callq  *%rax
}
  8021b6:	c9                   	leaveq 
  8021b7:	c3                   	retq   

00000000008021b8 <close_all>:

void
close_all(void)
{
  8021b8:	55                   	push   %rbp
  8021b9:	48 89 e5             	mov    %rsp,%rbp
  8021bc:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021c7:	eb 15                	jmp    8021de <close_all+0x26>
		close(i);
  8021c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021cc:	89 c7                	mov    %eax,%edi
  8021ce:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  8021d5:	00 00 00 
  8021d8:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8021da:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021de:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021e2:	7e e5                	jle    8021c9 <close_all+0x11>
		close(i);
}
  8021e4:	c9                   	leaveq 
  8021e5:	c3                   	retq   

00000000008021e6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021e6:	55                   	push   %rbp
  8021e7:	48 89 e5             	mov    %rsp,%rbp
  8021ea:	48 83 ec 40          	sub    $0x40,%rsp
  8021ee:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8021f1:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021f4:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8021f8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021fb:	48 89 d6             	mov    %rdx,%rsi
  8021fe:	89 c7                	mov    %eax,%edi
  802200:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  802207:	00 00 00 
  80220a:	ff d0                	callq  *%rax
  80220c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80220f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802213:	79 08                	jns    80221d <dup+0x37>
		return r;
  802215:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802218:	e9 70 01 00 00       	jmpq   80238d <dup+0x1a7>
	close(newfdnum);
  80221d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802220:	89 c7                	mov    %eax,%edi
  802222:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  802229:	00 00 00 
  80222c:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80222e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802231:	48 98                	cltq   
  802233:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802239:	48 c1 e0 0c          	shl    $0xc,%rax
  80223d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802241:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802245:	48 89 c7             	mov    %rax,%rdi
  802248:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  80224f:	00 00 00 
  802252:	ff d0                	callq  *%rax
  802254:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80225c:	48 89 c7             	mov    %rax,%rdi
  80225f:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  802266:	00 00 00 
  802269:	ff d0                	callq  *%rax
  80226b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80226f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802273:	48 c1 e8 15          	shr    $0x15,%rax
  802277:	48 89 c2             	mov    %rax,%rdx
  80227a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802281:	01 00 00 
  802284:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802288:	83 e0 01             	and    $0x1,%eax
  80228b:	48 85 c0             	test   %rax,%rax
  80228e:	74 73                	je     802303 <dup+0x11d>
  802290:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802294:	48 c1 e8 0c          	shr    $0xc,%rax
  802298:	48 89 c2             	mov    %rax,%rdx
  80229b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022a2:	01 00 00 
  8022a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022a9:	83 e0 01             	and    $0x1,%eax
  8022ac:	48 85 c0             	test   %rax,%rax
  8022af:	74 52                	je     802303 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b5:	48 c1 e8 0c          	shr    $0xc,%rax
  8022b9:	48 89 c2             	mov    %rax,%rdx
  8022bc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022c3:	01 00 00 
  8022c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ca:	25 07 0e 00 00       	and    $0xe07,%eax
  8022cf:	89 c1                	mov    %eax,%ecx
  8022d1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d9:	41 89 c8             	mov    %ecx,%r8d
  8022dc:	48 89 d1             	mov    %rdx,%rcx
  8022df:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e4:	48 89 c6             	mov    %rax,%rsi
  8022e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ec:	48 b8 5a 1c 80 00 00 	movabs $0x801c5a,%rax
  8022f3:	00 00 00 
  8022f6:	ff d0                	callq  *%rax
  8022f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ff:	79 02                	jns    802303 <dup+0x11d>
			goto err;
  802301:	eb 57                	jmp    80235a <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802303:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802307:	48 c1 e8 0c          	shr    $0xc,%rax
  80230b:	48 89 c2             	mov    %rax,%rdx
  80230e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802315:	01 00 00 
  802318:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231c:	25 07 0e 00 00       	and    $0xe07,%eax
  802321:	89 c1                	mov    %eax,%ecx
  802323:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802327:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80232b:	41 89 c8             	mov    %ecx,%r8d
  80232e:	48 89 d1             	mov    %rdx,%rcx
  802331:	ba 00 00 00 00       	mov    $0x0,%edx
  802336:	48 89 c6             	mov    %rax,%rsi
  802339:	bf 00 00 00 00       	mov    $0x0,%edi
  80233e:	48 b8 5a 1c 80 00 00 	movabs $0x801c5a,%rax
  802345:	00 00 00 
  802348:	ff d0                	callq  *%rax
  80234a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80234d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802351:	79 02                	jns    802355 <dup+0x16f>
		goto err;
  802353:	eb 05                	jmp    80235a <dup+0x174>

	return newfdnum;
  802355:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802358:	eb 33                	jmp    80238d <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80235a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235e:	48 89 c6             	mov    %rax,%rsi
  802361:	bf 00 00 00 00       	mov    $0x0,%edi
  802366:	48 b8 b5 1c 80 00 00 	movabs $0x801cb5,%rax
  80236d:	00 00 00 
  802370:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802372:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802376:	48 89 c6             	mov    %rax,%rsi
  802379:	bf 00 00 00 00       	mov    $0x0,%edi
  80237e:	48 b8 b5 1c 80 00 00 	movabs $0x801cb5,%rax
  802385:	00 00 00 
  802388:	ff d0                	callq  *%rax
	return r;
  80238a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80238d:	c9                   	leaveq 
  80238e:	c3                   	retq   

000000000080238f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80238f:	55                   	push   %rbp
  802390:	48 89 e5             	mov    %rsp,%rbp
  802393:	48 83 ec 40          	sub    $0x40,%rsp
  802397:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80239a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80239e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023a2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023a6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023a9:	48 89 d6             	mov    %rdx,%rsi
  8023ac:	89 c7                	mov    %eax,%edi
  8023ae:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  8023b5:	00 00 00 
  8023b8:	ff d0                	callq  *%rax
  8023ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c1:	78 24                	js     8023e7 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c7:	8b 00                	mov    (%rax),%eax
  8023c9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023cd:	48 89 d6             	mov    %rdx,%rsi
  8023d0:	89 c7                	mov    %eax,%edi
  8023d2:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  8023d9:	00 00 00 
  8023dc:	ff d0                	callq  *%rax
  8023de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e5:	79 05                	jns    8023ec <read+0x5d>
		return r;
  8023e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ea:	eb 76                	jmp    802462 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8023ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f0:	8b 40 08             	mov    0x8(%rax),%eax
  8023f3:	83 e0 03             	and    $0x3,%eax
  8023f6:	83 f8 01             	cmp    $0x1,%eax
  8023f9:	75 3a                	jne    802435 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8023fb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802402:	00 00 00 
  802405:	48 8b 00             	mov    (%rax),%rax
  802408:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80240e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802411:	89 c6                	mov    %eax,%esi
  802413:	48 bf ef 48 80 00 00 	movabs $0x8048ef,%rdi
  80241a:	00 00 00 
  80241d:	b8 00 00 00 00       	mov    $0x0,%eax
  802422:	48 b9 33 05 80 00 00 	movabs $0x800533,%rcx
  802429:	00 00 00 
  80242c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80242e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802433:	eb 2d                	jmp    802462 <read+0xd3>
	}
	if (!dev->dev_read)
  802435:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802439:	48 8b 40 10          	mov    0x10(%rax),%rax
  80243d:	48 85 c0             	test   %rax,%rax
  802440:	75 07                	jne    802449 <read+0xba>
		return -E_NOT_SUPP;
  802442:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802447:	eb 19                	jmp    802462 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802449:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802451:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802455:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802459:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80245d:	48 89 cf             	mov    %rcx,%rdi
  802460:	ff d0                	callq  *%rax
}
  802462:	c9                   	leaveq 
  802463:	c3                   	retq   

0000000000802464 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802464:	55                   	push   %rbp
  802465:	48 89 e5             	mov    %rsp,%rbp
  802468:	48 83 ec 30          	sub    $0x30,%rsp
  80246c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80246f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802473:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802477:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80247e:	eb 49                	jmp    8024c9 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802480:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802483:	48 98                	cltq   
  802485:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802489:	48 29 c2             	sub    %rax,%rdx
  80248c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248f:	48 63 c8             	movslq %eax,%rcx
  802492:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802496:	48 01 c1             	add    %rax,%rcx
  802499:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80249c:	48 89 ce             	mov    %rcx,%rsi
  80249f:	89 c7                	mov    %eax,%edi
  8024a1:	48 b8 8f 23 80 00 00 	movabs $0x80238f,%rax
  8024a8:	00 00 00 
  8024ab:	ff d0                	callq  *%rax
  8024ad:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8024b0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024b4:	79 05                	jns    8024bb <readn+0x57>
			return m;
  8024b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024b9:	eb 1c                	jmp    8024d7 <readn+0x73>
		if (m == 0)
  8024bb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024bf:	75 02                	jne    8024c3 <readn+0x5f>
			break;
  8024c1:	eb 11                	jmp    8024d4 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024c6:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024cc:	48 98                	cltq   
  8024ce:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024d2:	72 ac                	jb     802480 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8024d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024d7:	c9                   	leaveq 
  8024d8:	c3                   	retq   

00000000008024d9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024d9:	55                   	push   %rbp
  8024da:	48 89 e5             	mov    %rsp,%rbp
  8024dd:	48 83 ec 40          	sub    $0x40,%rsp
  8024e1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024e4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024e8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024ec:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024f0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024f3:	48 89 d6             	mov    %rdx,%rsi
  8024f6:	89 c7                	mov    %eax,%edi
  8024f8:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  8024ff:	00 00 00 
  802502:	ff d0                	callq  *%rax
  802504:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802507:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250b:	78 24                	js     802531 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80250d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802511:	8b 00                	mov    (%rax),%eax
  802513:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802517:	48 89 d6             	mov    %rdx,%rsi
  80251a:	89 c7                	mov    %eax,%edi
  80251c:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  802523:	00 00 00 
  802526:	ff d0                	callq  *%rax
  802528:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80252f:	79 05                	jns    802536 <write+0x5d>
		return r;
  802531:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802534:	eb 75                	jmp    8025ab <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802536:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253a:	8b 40 08             	mov    0x8(%rax),%eax
  80253d:	83 e0 03             	and    $0x3,%eax
  802540:	85 c0                	test   %eax,%eax
  802542:	75 3a                	jne    80257e <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802544:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80254b:	00 00 00 
  80254e:	48 8b 00             	mov    (%rax),%rax
  802551:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802557:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80255a:	89 c6                	mov    %eax,%esi
  80255c:	48 bf 0b 49 80 00 00 	movabs $0x80490b,%rdi
  802563:	00 00 00 
  802566:	b8 00 00 00 00       	mov    $0x0,%eax
  80256b:	48 b9 33 05 80 00 00 	movabs $0x800533,%rcx
  802572:	00 00 00 
  802575:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802577:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80257c:	eb 2d                	jmp    8025ab <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80257e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802582:	48 8b 40 18          	mov    0x18(%rax),%rax
  802586:	48 85 c0             	test   %rax,%rax
  802589:	75 07                	jne    802592 <write+0xb9>
		return -E_NOT_SUPP;
  80258b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802590:	eb 19                	jmp    8025ab <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802592:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802596:	48 8b 40 18          	mov    0x18(%rax),%rax
  80259a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80259e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025a2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025a6:	48 89 cf             	mov    %rcx,%rdi
  8025a9:	ff d0                	callq  *%rax
}
  8025ab:	c9                   	leaveq 
  8025ac:	c3                   	retq   

00000000008025ad <seek>:

int
seek(int fdnum, off_t offset)
{
  8025ad:	55                   	push   %rbp
  8025ae:	48 89 e5             	mov    %rsp,%rbp
  8025b1:	48 83 ec 18          	sub    $0x18,%rsp
  8025b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025b8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025bb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025c2:	48 89 d6             	mov    %rdx,%rsi
  8025c5:	89 c7                	mov    %eax,%edi
  8025c7:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  8025ce:	00 00 00 
  8025d1:	ff d0                	callq  *%rax
  8025d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025da:	79 05                	jns    8025e1 <seek+0x34>
		return r;
  8025dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025df:	eb 0f                	jmp    8025f0 <seek+0x43>
	fd->fd_offset = offset;
  8025e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025e8:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8025eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f0:	c9                   	leaveq 
  8025f1:	c3                   	retq   

00000000008025f2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025f2:	55                   	push   %rbp
  8025f3:	48 89 e5             	mov    %rsp,%rbp
  8025f6:	48 83 ec 30          	sub    $0x30,%rsp
  8025fa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025fd:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802600:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802604:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802607:	48 89 d6             	mov    %rdx,%rsi
  80260a:	89 c7                	mov    %eax,%edi
  80260c:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  802613:	00 00 00 
  802616:	ff d0                	callq  *%rax
  802618:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80261f:	78 24                	js     802645 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802621:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802625:	8b 00                	mov    (%rax),%eax
  802627:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80262b:	48 89 d6             	mov    %rdx,%rsi
  80262e:	89 c7                	mov    %eax,%edi
  802630:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  802637:	00 00 00 
  80263a:	ff d0                	callq  *%rax
  80263c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80263f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802643:	79 05                	jns    80264a <ftruncate+0x58>
		return r;
  802645:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802648:	eb 72                	jmp    8026bc <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80264a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264e:	8b 40 08             	mov    0x8(%rax),%eax
  802651:	83 e0 03             	and    $0x3,%eax
  802654:	85 c0                	test   %eax,%eax
  802656:	75 3a                	jne    802692 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802658:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80265f:	00 00 00 
  802662:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802665:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80266b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80266e:	89 c6                	mov    %eax,%esi
  802670:	48 bf 28 49 80 00 00 	movabs $0x804928,%rdi
  802677:	00 00 00 
  80267a:	b8 00 00 00 00       	mov    $0x0,%eax
  80267f:	48 b9 33 05 80 00 00 	movabs $0x800533,%rcx
  802686:	00 00 00 
  802689:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80268b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802690:	eb 2a                	jmp    8026bc <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802696:	48 8b 40 30          	mov    0x30(%rax),%rax
  80269a:	48 85 c0             	test   %rax,%rax
  80269d:	75 07                	jne    8026a6 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80269f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026a4:	eb 16                	jmp    8026bc <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8026a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026aa:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026b2:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8026b5:	89 ce                	mov    %ecx,%esi
  8026b7:	48 89 d7             	mov    %rdx,%rdi
  8026ba:	ff d0                	callq  *%rax
}
  8026bc:	c9                   	leaveq 
  8026bd:	c3                   	retq   

00000000008026be <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026be:	55                   	push   %rbp
  8026bf:	48 89 e5             	mov    %rsp,%rbp
  8026c2:	48 83 ec 30          	sub    $0x30,%rsp
  8026c6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026c9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026cd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026d1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026d4:	48 89 d6             	mov    %rdx,%rsi
  8026d7:	89 c7                	mov    %eax,%edi
  8026d9:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  8026e0:	00 00 00 
  8026e3:	ff d0                	callq  *%rax
  8026e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ec:	78 24                	js     802712 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f2:	8b 00                	mov    (%rax),%eax
  8026f4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026f8:	48 89 d6             	mov    %rdx,%rsi
  8026fb:	89 c7                	mov    %eax,%edi
  8026fd:	48 b8 b6 20 80 00 00 	movabs $0x8020b6,%rax
  802704:	00 00 00 
  802707:	ff d0                	callq  *%rax
  802709:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80270c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802710:	79 05                	jns    802717 <fstat+0x59>
		return r;
  802712:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802715:	eb 5e                	jmp    802775 <fstat+0xb7>
	if (!dev->dev_stat)
  802717:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271b:	48 8b 40 28          	mov    0x28(%rax),%rax
  80271f:	48 85 c0             	test   %rax,%rax
  802722:	75 07                	jne    80272b <fstat+0x6d>
		return -E_NOT_SUPP;
  802724:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802729:	eb 4a                	jmp    802775 <fstat+0xb7>
	stat->st_name[0] = 0;
  80272b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80272f:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802732:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802736:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80273d:	00 00 00 
	stat->st_isdir = 0;
  802740:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802744:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80274b:	00 00 00 
	stat->st_dev = dev;
  80274e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802752:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802756:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80275d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802761:	48 8b 40 28          	mov    0x28(%rax),%rax
  802765:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802769:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80276d:	48 89 ce             	mov    %rcx,%rsi
  802770:	48 89 d7             	mov    %rdx,%rdi
  802773:	ff d0                	callq  *%rax
}
  802775:	c9                   	leaveq 
  802776:	c3                   	retq   

0000000000802777 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802777:	55                   	push   %rbp
  802778:	48 89 e5             	mov    %rsp,%rbp
  80277b:	48 83 ec 20          	sub    $0x20,%rsp
  80277f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802783:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802787:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278b:	be 00 00 00 00       	mov    $0x0,%esi
  802790:	48 89 c7             	mov    %rax,%rdi
  802793:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  80279a:	00 00 00 
  80279d:	ff d0                	callq  *%rax
  80279f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a6:	79 05                	jns    8027ad <stat+0x36>
		return fd;
  8027a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ab:	eb 2f                	jmp    8027dc <stat+0x65>
	r = fstat(fd, stat);
  8027ad:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b4:	48 89 d6             	mov    %rdx,%rsi
  8027b7:	89 c7                	mov    %eax,%edi
  8027b9:	48 b8 be 26 80 00 00 	movabs $0x8026be,%rax
  8027c0:	00 00 00 
  8027c3:	ff d0                	callq  *%rax
  8027c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cb:	89 c7                	mov    %eax,%edi
  8027cd:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  8027d4:	00 00 00 
  8027d7:	ff d0                	callq  *%rax
	return r;
  8027d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027dc:	c9                   	leaveq 
  8027dd:	c3                   	retq   

00000000008027de <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027de:	55                   	push   %rbp
  8027df:	48 89 e5             	mov    %rsp,%rbp
  8027e2:	48 83 ec 10          	sub    $0x10,%rsp
  8027e6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8027ed:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8027f4:	00 00 00 
  8027f7:	8b 00                	mov    (%rax),%eax
  8027f9:	85 c0                	test   %eax,%eax
  8027fb:	75 1d                	jne    80281a <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8027fd:	bf 01 00 00 00       	mov    $0x1,%edi
  802802:	48 b8 c0 41 80 00 00 	movabs $0x8041c0,%rax
  802809:	00 00 00 
  80280c:	ff d0                	callq  *%rax
  80280e:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  802815:	00 00 00 
  802818:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80281a:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802821:	00 00 00 
  802824:	8b 00                	mov    (%rax),%eax
  802826:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802829:	b9 07 00 00 00       	mov    $0x7,%ecx
  80282e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802835:	00 00 00 
  802838:	89 c7                	mov    %eax,%edi
  80283a:	48 b8 28 41 80 00 00 	movabs $0x804128,%rax
  802841:	00 00 00 
  802844:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802846:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284a:	ba 00 00 00 00       	mov    $0x0,%edx
  80284f:	48 89 c6             	mov    %rax,%rsi
  802852:	bf 00 00 00 00       	mov    $0x0,%edi
  802857:	48 b8 5f 40 80 00 00 	movabs $0x80405f,%rax
  80285e:	00 00 00 
  802861:	ff d0                	callq  *%rax
}
  802863:	c9                   	leaveq 
  802864:	c3                   	retq   

0000000000802865 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802865:	55                   	push   %rbp
  802866:	48 89 e5             	mov    %rsp,%rbp
  802869:	48 83 ec 20          	sub    $0x20,%rsp
  80286d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802871:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802878:	48 89 c7             	mov    %rax,%rdi
  80287b:	48 b8 6f 12 80 00 00 	movabs $0x80126f,%rax
  802882:	00 00 00 
  802885:	ff d0                	callq  *%rax
  802887:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80288c:	7e 0a                	jle    802898 <open+0x33>
		return -E_BAD_PATH;
  80288e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802893:	e9 a5 00 00 00       	jmpq   80293d <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802898:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80289c:	48 89 c7             	mov    %rax,%rdi
  80289f:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  8028a6:	00 00 00 
  8028a9:	ff d0                	callq  *%rax
  8028ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b2:	79 08                	jns    8028bc <open+0x57>
		return r;
  8028b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b7:	e9 81 00 00 00       	jmpq   80293d <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8028bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c0:	48 89 c6             	mov    %rax,%rsi
  8028c3:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8028ca:	00 00 00 
  8028cd:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  8028d4:	00 00 00 
  8028d7:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8028d9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028e0:	00 00 00 
  8028e3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8028e6:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8028ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f0:	48 89 c6             	mov    %rax,%rsi
  8028f3:	bf 01 00 00 00       	mov    $0x1,%edi
  8028f8:	48 b8 de 27 80 00 00 	movabs $0x8027de,%rax
  8028ff:	00 00 00 
  802902:	ff d0                	callq  *%rax
  802904:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802907:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290b:	79 1d                	jns    80292a <open+0xc5>
		fd_close(fd, 0);
  80290d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802911:	be 00 00 00 00       	mov    $0x0,%esi
  802916:	48 89 c7             	mov    %rax,%rdi
  802919:	48 b8 ed 1f 80 00 00 	movabs $0x801fed,%rax
  802920:	00 00 00 
  802923:	ff d0                	callq  *%rax
		return r;
  802925:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802928:	eb 13                	jmp    80293d <open+0xd8>
	}

	return fd2num(fd);
  80292a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80292e:	48 89 c7             	mov    %rax,%rdi
  802931:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  802938:	00 00 00 
  80293b:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  80293d:	c9                   	leaveq 
  80293e:	c3                   	retq   

000000000080293f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80293f:	55                   	push   %rbp
  802940:	48 89 e5             	mov    %rsp,%rbp
  802943:	48 83 ec 10          	sub    $0x10,%rsp
  802947:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80294b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80294f:	8b 50 0c             	mov    0xc(%rax),%edx
  802952:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802959:	00 00 00 
  80295c:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80295e:	be 00 00 00 00       	mov    $0x0,%esi
  802963:	bf 06 00 00 00       	mov    $0x6,%edi
  802968:	48 b8 de 27 80 00 00 	movabs $0x8027de,%rax
  80296f:	00 00 00 
  802972:	ff d0                	callq  *%rax
}
  802974:	c9                   	leaveq 
  802975:	c3                   	retq   

0000000000802976 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802976:	55                   	push   %rbp
  802977:	48 89 e5             	mov    %rsp,%rbp
  80297a:	48 83 ec 30          	sub    $0x30,%rsp
  80297e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802982:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802986:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80298a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80298e:	8b 50 0c             	mov    0xc(%rax),%edx
  802991:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802998:	00 00 00 
  80299b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80299d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029a4:	00 00 00 
  8029a7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029ab:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8029af:	be 00 00 00 00       	mov    $0x0,%esi
  8029b4:	bf 03 00 00 00       	mov    $0x3,%edi
  8029b9:	48 b8 de 27 80 00 00 	movabs $0x8027de,%rax
  8029c0:	00 00 00 
  8029c3:	ff d0                	callq  *%rax
  8029c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029cc:	79 05                	jns    8029d3 <devfile_read+0x5d>
		return r;
  8029ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d1:	eb 26                	jmp    8029f9 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8029d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d6:	48 63 d0             	movslq %eax,%rdx
  8029d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029dd:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8029e4:	00 00 00 
  8029e7:	48 89 c7             	mov    %rax,%rdi
  8029ea:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  8029f1:	00 00 00 
  8029f4:	ff d0                	callq  *%rax

	return r;
  8029f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8029f9:	c9                   	leaveq 
  8029fa:	c3                   	retq   

00000000008029fb <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8029fb:	55                   	push   %rbp
  8029fc:	48 89 e5             	mov    %rsp,%rbp
  8029ff:	48 83 ec 30          	sub    $0x30,%rsp
  802a03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a0b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802a0f:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802a16:	00 
  802a17:	76 08                	jbe    802a21 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802a19:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802a20:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a25:	8b 50 0c             	mov    0xc(%rax),%edx
  802a28:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a2f:	00 00 00 
  802a32:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802a34:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a3b:	00 00 00 
  802a3e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a42:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  802a46:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a4e:	48 89 c6             	mov    %rax,%rsi
  802a51:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802a58:	00 00 00 
  802a5b:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  802a62:	00 00 00 
  802a65:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802a67:	be 00 00 00 00       	mov    $0x0,%esi
  802a6c:	bf 04 00 00 00       	mov    $0x4,%edi
  802a71:	48 b8 de 27 80 00 00 	movabs $0x8027de,%rax
  802a78:	00 00 00 
  802a7b:	ff d0                	callq  *%rax
  802a7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a84:	79 05                	jns    802a8b <devfile_write+0x90>
		return r;
  802a86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a89:	eb 03                	jmp    802a8e <devfile_write+0x93>

	return r;
  802a8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802a8e:	c9                   	leaveq 
  802a8f:	c3                   	retq   

0000000000802a90 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a90:	55                   	push   %rbp
  802a91:	48 89 e5             	mov    %rsp,%rbp
  802a94:	48 83 ec 20          	sub    $0x20,%rsp
  802a98:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a9c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802aa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa4:	8b 50 0c             	mov    0xc(%rax),%edx
  802aa7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aae:	00 00 00 
  802ab1:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ab3:	be 00 00 00 00       	mov    $0x0,%esi
  802ab8:	bf 05 00 00 00       	mov    $0x5,%edi
  802abd:	48 b8 de 27 80 00 00 	movabs $0x8027de,%rax
  802ac4:	00 00 00 
  802ac7:	ff d0                	callq  *%rax
  802ac9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802acc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad0:	79 05                	jns    802ad7 <devfile_stat+0x47>
		return r;
  802ad2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad5:	eb 56                	jmp    802b2d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ad7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802adb:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ae2:	00 00 00 
  802ae5:	48 89 c7             	mov    %rax,%rdi
  802ae8:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  802aef:	00 00 00 
  802af2:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802af4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802afb:	00 00 00 
  802afe:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b08:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b0e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b15:	00 00 00 
  802b18:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b1e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b22:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b2d:	c9                   	leaveq 
  802b2e:	c3                   	retq   

0000000000802b2f <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b2f:	55                   	push   %rbp
  802b30:	48 89 e5             	mov    %rsp,%rbp
  802b33:	48 83 ec 10          	sub    $0x10,%rsp
  802b37:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b3b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b42:	8b 50 0c             	mov    0xc(%rax),%edx
  802b45:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b4c:	00 00 00 
  802b4f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b51:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b58:	00 00 00 
  802b5b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b5e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b61:	be 00 00 00 00       	mov    $0x0,%esi
  802b66:	bf 02 00 00 00       	mov    $0x2,%edi
  802b6b:	48 b8 de 27 80 00 00 	movabs $0x8027de,%rax
  802b72:	00 00 00 
  802b75:	ff d0                	callq  *%rax
}
  802b77:	c9                   	leaveq 
  802b78:	c3                   	retq   

0000000000802b79 <remove>:

// Delete a file
int
remove(const char *path)
{
  802b79:	55                   	push   %rbp
  802b7a:	48 89 e5             	mov    %rsp,%rbp
  802b7d:	48 83 ec 10          	sub    $0x10,%rsp
  802b81:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b89:	48 89 c7             	mov    %rax,%rdi
  802b8c:	48 b8 6f 12 80 00 00 	movabs $0x80126f,%rax
  802b93:	00 00 00 
  802b96:	ff d0                	callq  *%rax
  802b98:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b9d:	7e 07                	jle    802ba6 <remove+0x2d>
		return -E_BAD_PATH;
  802b9f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ba4:	eb 33                	jmp    802bd9 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ba6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802baa:	48 89 c6             	mov    %rax,%rsi
  802bad:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802bb4:	00 00 00 
  802bb7:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  802bbe:	00 00 00 
  802bc1:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802bc3:	be 00 00 00 00       	mov    $0x0,%esi
  802bc8:	bf 07 00 00 00       	mov    $0x7,%edi
  802bcd:	48 b8 de 27 80 00 00 	movabs $0x8027de,%rax
  802bd4:	00 00 00 
  802bd7:	ff d0                	callq  *%rax
}
  802bd9:	c9                   	leaveq 
  802bda:	c3                   	retq   

0000000000802bdb <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802bdb:	55                   	push   %rbp
  802bdc:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802bdf:	be 00 00 00 00       	mov    $0x0,%esi
  802be4:	bf 08 00 00 00       	mov    $0x8,%edi
  802be9:	48 b8 de 27 80 00 00 	movabs $0x8027de,%rax
  802bf0:	00 00 00 
  802bf3:	ff d0                	callq  *%rax
}
  802bf5:	5d                   	pop    %rbp
  802bf6:	c3                   	retq   

0000000000802bf7 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802bf7:	55                   	push   %rbp
  802bf8:	48 89 e5             	mov    %rsp,%rbp
  802bfb:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  802c02:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802c09:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802c10:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802c17:	be 00 00 00 00       	mov    $0x0,%esi
  802c1c:	48 89 c7             	mov    %rax,%rdi
  802c1f:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  802c26:	00 00 00 
  802c29:	ff d0                	callq  *%rax
  802c2b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802c2e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802c32:	79 08                	jns    802c3c <spawn+0x45>
		return r;
  802c34:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c37:	e9 14 03 00 00       	jmpq   802f50 <spawn+0x359>
	fd = r;
  802c3c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c3f:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802c42:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802c49:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802c4d:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802c54:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802c57:	ba 00 02 00 00       	mov    $0x200,%edx
  802c5c:	48 89 ce             	mov    %rcx,%rsi
  802c5f:	89 c7                	mov    %eax,%edi
  802c61:	48 b8 64 24 80 00 00 	movabs $0x802464,%rax
  802c68:	00 00 00 
  802c6b:	ff d0                	callq  *%rax
  802c6d:	3d 00 02 00 00       	cmp    $0x200,%eax
  802c72:	75 0d                	jne    802c81 <spawn+0x8a>
	    || elf->e_magic != ELF_MAGIC) {
  802c74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c78:	8b 00                	mov    (%rax),%eax
  802c7a:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802c7f:	74 43                	je     802cc4 <spawn+0xcd>
		close(fd);
  802c81:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802c84:	89 c7                	mov    %eax,%edi
  802c86:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  802c8d:	00 00 00 
  802c90:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802c92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c96:	8b 00                	mov    (%rax),%eax
  802c98:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802c9d:	89 c6                	mov    %eax,%esi
  802c9f:	48 bf 50 49 80 00 00 	movabs $0x804950,%rdi
  802ca6:	00 00 00 
  802ca9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cae:	48 b9 33 05 80 00 00 	movabs $0x800533,%rcx
  802cb5:	00 00 00 
  802cb8:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802cba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802cbf:	e9 8c 02 00 00       	jmpq   802f50 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802cc4:	b8 07 00 00 00       	mov    $0x7,%eax
  802cc9:	cd 30                	int    $0x30
  802ccb:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802cce:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802cd1:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802cd4:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802cd8:	79 08                	jns    802ce2 <spawn+0xeb>
		return r;
  802cda:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cdd:	e9 6e 02 00 00       	jmpq   802f50 <spawn+0x359>
	child = r;
  802ce2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ce5:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802ce8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ceb:	25 ff 03 00 00       	and    $0x3ff,%eax
  802cf0:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802cf7:	00 00 00 
  802cfa:	48 63 d0             	movslq %eax,%rdx
  802cfd:	48 89 d0             	mov    %rdx,%rax
  802d00:	48 c1 e0 03          	shl    $0x3,%rax
  802d04:	48 01 d0             	add    %rdx,%rax
  802d07:	48 c1 e0 05          	shl    $0x5,%rax
  802d0b:	48 01 c8             	add    %rcx,%rax
  802d0e:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802d15:	48 89 c6             	mov    %rax,%rsi
  802d18:	b8 18 00 00 00       	mov    $0x18,%eax
  802d1d:	48 89 d7             	mov    %rdx,%rdi
  802d20:	48 89 c1             	mov    %rax,%rcx
  802d23:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802d26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d2a:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d2e:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802d35:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802d3c:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802d43:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802d4a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d4d:	48 89 ce             	mov    %rcx,%rsi
  802d50:	89 c7                	mov    %eax,%edi
  802d52:	48 b8 ba 31 80 00 00 	movabs $0x8031ba,%rax
  802d59:	00 00 00 
  802d5c:	ff d0                	callq  *%rax
  802d5e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d61:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d65:	79 08                	jns    802d6f <spawn+0x178>
		return r;
  802d67:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d6a:	e9 e1 01 00 00       	jmpq   802f50 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802d6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d73:	48 8b 40 20          	mov    0x20(%rax),%rax
  802d77:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802d7e:	48 01 d0             	add    %rdx,%rax
  802d81:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802d85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d8c:	e9 a3 00 00 00       	jmpq   802e34 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  802d91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d95:	8b 00                	mov    (%rax),%eax
  802d97:	83 f8 01             	cmp    $0x1,%eax
  802d9a:	74 05                	je     802da1 <spawn+0x1aa>
			continue;
  802d9c:	e9 8a 00 00 00       	jmpq   802e2b <spawn+0x234>
		perm = PTE_P | PTE_U;
  802da1:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802da8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dac:	8b 40 04             	mov    0x4(%rax),%eax
  802daf:	83 e0 02             	and    $0x2,%eax
  802db2:	85 c0                	test   %eax,%eax
  802db4:	74 04                	je     802dba <spawn+0x1c3>
			perm |= PTE_W;
  802db6:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802dba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbe:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802dc2:	41 89 c1             	mov    %eax,%r9d
  802dc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc9:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802dcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd1:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802dd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd9:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802ddd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802de0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802de3:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802de6:	89 3c 24             	mov    %edi,(%rsp)
  802de9:	89 c7                	mov    %eax,%edi
  802deb:	48 b8 63 34 80 00 00 	movabs $0x803463,%rax
  802df2:	00 00 00 
  802df5:	ff d0                	callq  *%rax
  802df7:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802dfa:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802dfe:	79 2b                	jns    802e2b <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802e00:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802e01:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e04:	89 c7                	mov    %eax,%edi
  802e06:	48 b8 4a 1b 80 00 00 	movabs $0x801b4a,%rax
  802e0d:	00 00 00 
  802e10:	ff d0                	callq  *%rax
	close(fd);
  802e12:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802e15:	89 c7                	mov    %eax,%edi
  802e17:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  802e1e:	00 00 00 
  802e21:	ff d0                	callq  *%rax
	return r;
  802e23:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e26:	e9 25 01 00 00       	jmpq   802f50 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802e2b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802e2f:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802e34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e38:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802e3c:	0f b7 c0             	movzwl %ax,%eax
  802e3f:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802e42:	0f 8f 49 ff ff ff    	jg     802d91 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802e48:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802e4b:	89 c7                	mov    %eax,%edi
  802e4d:	48 b8 6d 21 80 00 00 	movabs $0x80216d,%rax
  802e54:	00 00 00 
  802e57:	ff d0                	callq  *%rax
	fd = -1;
  802e59:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802e60:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e63:	89 c7                	mov    %eax,%edi
  802e65:	48 b8 4f 36 80 00 00 	movabs $0x80364f,%rax
  802e6c:	00 00 00 
  802e6f:	ff d0                	callq  *%rax
  802e71:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e74:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e78:	79 30                	jns    802eaa <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  802e7a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e7d:	89 c1                	mov    %eax,%ecx
  802e7f:	48 ba 6a 49 80 00 00 	movabs $0x80496a,%rdx
  802e86:	00 00 00 
  802e89:	be 82 00 00 00       	mov    $0x82,%esi
  802e8e:	48 bf 80 49 80 00 00 	movabs $0x804980,%rdi
  802e95:	00 00 00 
  802e98:	b8 00 00 00 00       	mov    $0x0,%eax
  802e9d:	49 b8 fa 02 80 00 00 	movabs $0x8002fa,%r8
  802ea4:	00 00 00 
  802ea7:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802eaa:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802eb1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802eb4:	48 89 d6             	mov    %rdx,%rsi
  802eb7:	89 c7                	mov    %eax,%edi
  802eb9:	48 b8 4a 1d 80 00 00 	movabs $0x801d4a,%rax
  802ec0:	00 00 00 
  802ec3:	ff d0                	callq  *%rax
  802ec5:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802ec8:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802ecc:	79 30                	jns    802efe <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  802ece:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ed1:	89 c1                	mov    %eax,%ecx
  802ed3:	48 ba 8c 49 80 00 00 	movabs $0x80498c,%rdx
  802eda:	00 00 00 
  802edd:	be 85 00 00 00       	mov    $0x85,%esi
  802ee2:	48 bf 80 49 80 00 00 	movabs $0x804980,%rdi
  802ee9:	00 00 00 
  802eec:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef1:	49 b8 fa 02 80 00 00 	movabs $0x8002fa,%r8
  802ef8:	00 00 00 
  802efb:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802efe:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f01:	be 02 00 00 00       	mov    $0x2,%esi
  802f06:	89 c7                	mov    %eax,%edi
  802f08:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  802f0f:	00 00 00 
  802f12:	ff d0                	callq  *%rax
  802f14:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f17:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f1b:	79 30                	jns    802f4d <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  802f1d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f20:	89 c1                	mov    %eax,%ecx
  802f22:	48 ba a6 49 80 00 00 	movabs $0x8049a6,%rdx
  802f29:	00 00 00 
  802f2c:	be 88 00 00 00       	mov    $0x88,%esi
  802f31:	48 bf 80 49 80 00 00 	movabs $0x804980,%rdi
  802f38:	00 00 00 
  802f3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f40:	49 b8 fa 02 80 00 00 	movabs $0x8002fa,%r8
  802f47:	00 00 00 
  802f4a:	41 ff d0             	callq  *%r8

	return child;
  802f4d:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802f50:	c9                   	leaveq 
  802f51:	c3                   	retq   

0000000000802f52 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802f52:	55                   	push   %rbp
  802f53:	48 89 e5             	mov    %rsp,%rbp
  802f56:	41 55                	push   %r13
  802f58:	41 54                	push   %r12
  802f5a:	53                   	push   %rbx
  802f5b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802f62:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  802f69:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  802f70:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  802f77:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  802f7e:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  802f85:	84 c0                	test   %al,%al
  802f87:	74 26                	je     802faf <spawnl+0x5d>
  802f89:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  802f90:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  802f97:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  802f9b:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  802f9f:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  802fa3:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  802fa7:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  802fab:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  802faf:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802fb6:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  802fbd:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  802fc0:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  802fc7:	00 00 00 
  802fca:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  802fd1:	00 00 00 
  802fd4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802fd8:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  802fdf:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  802fe6:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while (va_arg(vl, void *) != NULL)
  802fed:	eb 07                	jmp    802ff6 <spawnl+0xa4>
		argc++;
  802fef:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  802ff6:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802ffc:	83 f8 30             	cmp    $0x30,%eax
  802fff:	73 23                	jae    803024 <spawnl+0xd2>
  803001:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803008:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80300e:	89 c0                	mov    %eax,%eax
  803010:	48 01 d0             	add    %rdx,%rax
  803013:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803019:	83 c2 08             	add    $0x8,%edx
  80301c:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803022:	eb 15                	jmp    803039 <spawnl+0xe7>
  803024:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  80302b:	48 89 d0             	mov    %rdx,%rax
  80302e:	48 83 c2 08          	add    $0x8,%rdx
  803032:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803039:	48 8b 00             	mov    (%rax),%rax
  80303c:	48 85 c0             	test   %rax,%rax
  80303f:	75 ae                	jne    802fef <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803041:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803047:	83 c0 02             	add    $0x2,%eax
  80304a:	48 89 e2             	mov    %rsp,%rdx
  80304d:	48 89 d3             	mov    %rdx,%rbx
  803050:	48 63 d0             	movslq %eax,%rdx
  803053:	48 83 ea 01          	sub    $0x1,%rdx
  803057:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  80305e:	48 63 d0             	movslq %eax,%rdx
  803061:	49 89 d4             	mov    %rdx,%r12
  803064:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  80306a:	48 63 d0             	movslq %eax,%rdx
  80306d:	49 89 d2             	mov    %rdx,%r10
  803070:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803076:	48 98                	cltq   
  803078:	48 c1 e0 03          	shl    $0x3,%rax
  80307c:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803080:	b8 10 00 00 00       	mov    $0x10,%eax
  803085:	48 83 e8 01          	sub    $0x1,%rax
  803089:	48 01 d0             	add    %rdx,%rax
  80308c:	bf 10 00 00 00       	mov    $0x10,%edi
  803091:	ba 00 00 00 00       	mov    $0x0,%edx
  803096:	48 f7 f7             	div    %rdi
  803099:	48 6b c0 10          	imul   $0x10,%rax,%rax
  80309d:	48 29 c4             	sub    %rax,%rsp
  8030a0:	48 89 e0             	mov    %rsp,%rax
  8030a3:	48 83 c0 07          	add    $0x7,%rax
  8030a7:	48 c1 e8 03          	shr    $0x3,%rax
  8030ab:	48 c1 e0 03          	shl    $0x3,%rax
  8030af:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  8030b6:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8030bd:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  8030c4:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  8030c7:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8030cd:	8d 50 01             	lea    0x1(%rax),%edx
  8030d0:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8030d7:	48 63 d2             	movslq %edx,%rdx
  8030da:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  8030e1:	00 

	va_start(vl, arg0);
  8030e2:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8030e9:	00 00 00 
  8030ec:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8030f3:	00 00 00 
  8030f6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030fa:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803101:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803108:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for (i = 0; i < argc; i++)
  80310f:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803116:	00 00 00 
  803119:	eb 63                	jmp    80317e <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  80311b:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803121:	8d 70 01             	lea    0x1(%rax),%esi
  803124:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80312a:	83 f8 30             	cmp    $0x30,%eax
  80312d:	73 23                	jae    803152 <spawnl+0x200>
  80312f:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803136:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80313c:	89 c0                	mov    %eax,%eax
  80313e:	48 01 d0             	add    %rdx,%rax
  803141:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803147:	83 c2 08             	add    $0x8,%edx
  80314a:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803150:	eb 15                	jmp    803167 <spawnl+0x215>
  803152:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803159:	48 89 d0             	mov    %rdx,%rax
  80315c:	48 83 c2 08          	add    $0x8,%rdx
  803160:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803167:	48 8b 08             	mov    (%rax),%rcx
  80316a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803171:	89 f2                	mov    %esi,%edx
  803173:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  803177:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  80317e:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803184:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  80318a:	77 8f                	ja     80311b <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  80318c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803193:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  80319a:	48 89 d6             	mov    %rdx,%rsi
  80319d:	48 89 c7             	mov    %rax,%rdi
  8031a0:	48 b8 f7 2b 80 00 00 	movabs $0x802bf7,%rax
  8031a7:	00 00 00 
  8031aa:	ff d0                	callq  *%rax
  8031ac:	48 89 dc             	mov    %rbx,%rsp
}
  8031af:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  8031b3:	5b                   	pop    %rbx
  8031b4:	41 5c                	pop    %r12
  8031b6:	41 5d                	pop    %r13
  8031b8:	5d                   	pop    %rbp
  8031b9:	c3                   	retq   

00000000008031ba <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8031ba:	55                   	push   %rbp
  8031bb:	48 89 e5             	mov    %rsp,%rbp
  8031be:	48 83 ec 50          	sub    $0x50,%rsp
  8031c2:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8031c5:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8031c9:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8031cd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8031d4:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  8031d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8031dc:	eb 33                	jmp    803211 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  8031de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031e1:	48 98                	cltq   
  8031e3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8031ea:	00 
  8031eb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8031ef:	48 01 d0             	add    %rdx,%rax
  8031f2:	48 8b 00             	mov    (%rax),%rax
  8031f5:	48 89 c7             	mov    %rax,%rdi
  8031f8:	48 b8 6f 12 80 00 00 	movabs $0x80126f,%rax
  8031ff:	00 00 00 
  803202:	ff d0                	callq  *%rax
  803204:	83 c0 01             	add    $0x1,%eax
  803207:	48 98                	cltq   
  803209:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80320d:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803211:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803214:	48 98                	cltq   
  803216:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80321d:	00 
  80321e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803222:	48 01 d0             	add    %rdx,%rax
  803225:	48 8b 00             	mov    (%rax),%rax
  803228:	48 85 c0             	test   %rax,%rax
  80322b:	75 b1                	jne    8031de <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80322d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803231:	48 f7 d8             	neg    %rax
  803234:	48 05 00 10 40 00    	add    $0x401000,%rax
  80323a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  80323e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803242:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803246:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80324a:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  80324e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803251:	83 c2 01             	add    $0x1,%edx
  803254:	c1 e2 03             	shl    $0x3,%edx
  803257:	48 63 d2             	movslq %edx,%rdx
  80325a:	48 f7 da             	neg    %rdx
  80325d:	48 01 d0             	add    %rdx,%rax
  803260:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803264:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803268:	48 83 e8 10          	sub    $0x10,%rax
  80326c:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803272:	77 0a                	ja     80327e <init_stack+0xc4>
		return -E_NO_MEM;
  803274:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803279:	e9 e3 01 00 00       	jmpq   803461 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80327e:	ba 07 00 00 00       	mov    $0x7,%edx
  803283:	be 00 00 40 00       	mov    $0x400000,%esi
  803288:	bf 00 00 00 00       	mov    $0x0,%edi
  80328d:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  803294:	00 00 00 
  803297:	ff d0                	callq  *%rax
  803299:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80329c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032a0:	79 08                	jns    8032aa <init_stack+0xf0>
		return r;
  8032a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032a5:	e9 b7 01 00 00       	jmpq   803461 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8032aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8032b1:	e9 8a 00 00 00       	jmpq   803340 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  8032b6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032b9:	48 98                	cltq   
  8032bb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032c2:	00 
  8032c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032c7:	48 01 c2             	add    %rax,%rdx
  8032ca:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8032cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032d3:	48 01 c8             	add    %rcx,%rax
  8032d6:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8032dc:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  8032df:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032e2:	48 98                	cltq   
  8032e4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032eb:	00 
  8032ec:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8032f0:	48 01 d0             	add    %rdx,%rax
  8032f3:	48 8b 10             	mov    (%rax),%rdx
  8032f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032fa:	48 89 d6             	mov    %rdx,%rsi
  8032fd:	48 89 c7             	mov    %rax,%rdi
  803300:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  803307:	00 00 00 
  80330a:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  80330c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80330f:	48 98                	cltq   
  803311:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803318:	00 
  803319:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80331d:	48 01 d0             	add    %rdx,%rax
  803320:	48 8b 00             	mov    (%rax),%rax
  803323:	48 89 c7             	mov    %rax,%rdi
  803326:	48 b8 6f 12 80 00 00 	movabs $0x80126f,%rax
  80332d:	00 00 00 
  803330:	ff d0                	callq  *%rax
  803332:	48 98                	cltq   
  803334:	48 83 c0 01          	add    $0x1,%rax
  803338:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80333c:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803340:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803343:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803346:	0f 8c 6a ff ff ff    	jl     8032b6 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80334c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80334f:	48 98                	cltq   
  803351:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803358:	00 
  803359:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80335d:	48 01 d0             	add    %rdx,%rax
  803360:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803367:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  80336e:	00 
  80336f:	74 35                	je     8033a6 <init_stack+0x1ec>
  803371:	48 b9 c0 49 80 00 00 	movabs $0x8049c0,%rcx
  803378:	00 00 00 
  80337b:	48 ba e6 49 80 00 00 	movabs $0x8049e6,%rdx
  803382:	00 00 00 
  803385:	be f1 00 00 00       	mov    $0xf1,%esi
  80338a:	48 bf 80 49 80 00 00 	movabs $0x804980,%rdi
  803391:	00 00 00 
  803394:	b8 00 00 00 00       	mov    $0x0,%eax
  803399:	49 b8 fa 02 80 00 00 	movabs $0x8002fa,%r8
  8033a0:	00 00 00 
  8033a3:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8033a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033aa:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8033ae:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8033b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033b7:	48 01 c8             	add    %rcx,%rax
  8033ba:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8033c0:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  8033c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033c7:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8033cb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033ce:	48 98                	cltq   
  8033d0:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8033d3:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  8033d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033dc:	48 01 d0             	add    %rdx,%rax
  8033df:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8033e5:	48 89 c2             	mov    %rax,%rdx
  8033e8:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8033ec:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8033ef:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8033f2:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8033f8:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8033fd:	89 c2                	mov    %eax,%edx
  8033ff:	be 00 00 40 00       	mov    $0x400000,%esi
  803404:	bf 00 00 00 00       	mov    $0x0,%edi
  803409:	48 b8 5a 1c 80 00 00 	movabs $0x801c5a,%rax
  803410:	00 00 00 
  803413:	ff d0                	callq  *%rax
  803415:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803418:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80341c:	79 02                	jns    803420 <init_stack+0x266>
		goto error;
  80341e:	eb 28                	jmp    803448 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803420:	be 00 00 40 00       	mov    $0x400000,%esi
  803425:	bf 00 00 00 00       	mov    $0x0,%edi
  80342a:	48 b8 b5 1c 80 00 00 	movabs $0x801cb5,%rax
  803431:	00 00 00 
  803434:	ff d0                	callq  *%rax
  803436:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803439:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80343d:	79 02                	jns    803441 <init_stack+0x287>
		goto error;
  80343f:	eb 07                	jmp    803448 <init_stack+0x28e>

	return 0;
  803441:	b8 00 00 00 00       	mov    $0x0,%eax
  803446:	eb 19                	jmp    803461 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803448:	be 00 00 40 00       	mov    $0x400000,%esi
  80344d:	bf 00 00 00 00       	mov    $0x0,%edi
  803452:	48 b8 b5 1c 80 00 00 	movabs $0x801cb5,%rax
  803459:	00 00 00 
  80345c:	ff d0                	callq  *%rax
	return r;
  80345e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803461:	c9                   	leaveq 
  803462:	c3                   	retq   

0000000000803463 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  803463:	55                   	push   %rbp
  803464:	48 89 e5             	mov    %rsp,%rbp
  803467:	48 83 ec 50          	sub    $0x50,%rsp
  80346b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80346e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803472:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803476:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803479:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80347d:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803481:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803485:	25 ff 0f 00 00       	and    $0xfff,%eax
  80348a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80348d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803491:	74 21                	je     8034b4 <map_segment+0x51>
		va -= i;
  803493:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803496:	48 98                	cltq   
  803498:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  80349c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349f:	48 98                	cltq   
  8034a1:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8034a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a8:	48 98                	cltq   
  8034aa:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8034ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034b1:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8034b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034bb:	e9 79 01 00 00       	jmpq   803639 <map_segment+0x1d6>
		if (i >= filesz) {
  8034c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c3:	48 98                	cltq   
  8034c5:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8034c9:	72 3c                	jb     803507 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8034cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ce:	48 63 d0             	movslq %eax,%rdx
  8034d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034d5:	48 01 d0             	add    %rdx,%rax
  8034d8:	48 89 c1             	mov    %rax,%rcx
  8034db:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8034de:	8b 55 10             	mov    0x10(%rbp),%edx
  8034e1:	48 89 ce             	mov    %rcx,%rsi
  8034e4:	89 c7                	mov    %eax,%edi
  8034e6:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  8034ed:	00 00 00 
  8034f0:	ff d0                	callq  *%rax
  8034f2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8034f5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034f9:	0f 89 33 01 00 00    	jns    803632 <map_segment+0x1cf>
				return r;
  8034ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803502:	e9 46 01 00 00       	jmpq   80364d <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803507:	ba 07 00 00 00       	mov    $0x7,%edx
  80350c:	be 00 00 40 00       	mov    $0x400000,%esi
  803511:	bf 00 00 00 00       	mov    $0x0,%edi
  803516:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  80351d:	00 00 00 
  803520:	ff d0                	callq  *%rax
  803522:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803525:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803529:	79 08                	jns    803533 <map_segment+0xd0>
				return r;
  80352b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80352e:	e9 1a 01 00 00       	jmpq   80364d <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803533:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803536:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803539:	01 c2                	add    %eax,%edx
  80353b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80353e:	89 d6                	mov    %edx,%esi
  803540:	89 c7                	mov    %eax,%edi
  803542:	48 b8 ad 25 80 00 00 	movabs $0x8025ad,%rax
  803549:	00 00 00 
  80354c:	ff d0                	callq  *%rax
  80354e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803551:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803555:	79 08                	jns    80355f <map_segment+0xfc>
				return r;
  803557:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80355a:	e9 ee 00 00 00       	jmpq   80364d <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80355f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803566:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803569:	48 98                	cltq   
  80356b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80356f:	48 29 c2             	sub    %rax,%rdx
  803572:	48 89 d0             	mov    %rdx,%rax
  803575:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803579:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80357c:	48 63 d0             	movslq %eax,%rdx
  80357f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803583:	48 39 c2             	cmp    %rax,%rdx
  803586:	48 0f 47 d0          	cmova  %rax,%rdx
  80358a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80358d:	be 00 00 40 00       	mov    $0x400000,%esi
  803592:	89 c7                	mov    %eax,%edi
  803594:	48 b8 64 24 80 00 00 	movabs $0x802464,%rax
  80359b:	00 00 00 
  80359e:	ff d0                	callq  *%rax
  8035a0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8035a3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035a7:	79 08                	jns    8035b1 <map_segment+0x14e>
				return r;
  8035a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035ac:	e9 9c 00 00 00       	jmpq   80364d <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8035b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b4:	48 63 d0             	movslq %eax,%rdx
  8035b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035bb:	48 01 d0             	add    %rdx,%rax
  8035be:	48 89 c2             	mov    %rax,%rdx
  8035c1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035c4:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8035c8:	48 89 d1             	mov    %rdx,%rcx
  8035cb:	89 c2                	mov    %eax,%edx
  8035cd:	be 00 00 40 00       	mov    $0x400000,%esi
  8035d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8035d7:	48 b8 5a 1c 80 00 00 	movabs $0x801c5a,%rax
  8035de:	00 00 00 
  8035e1:	ff d0                	callq  *%rax
  8035e3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8035e6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035ea:	79 30                	jns    80361c <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8035ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035ef:	89 c1                	mov    %eax,%ecx
  8035f1:	48 ba fb 49 80 00 00 	movabs $0x8049fb,%rdx
  8035f8:	00 00 00 
  8035fb:	be 24 01 00 00       	mov    $0x124,%esi
  803600:	48 bf 80 49 80 00 00 	movabs $0x804980,%rdi
  803607:	00 00 00 
  80360a:	b8 00 00 00 00       	mov    $0x0,%eax
  80360f:	49 b8 fa 02 80 00 00 	movabs $0x8002fa,%r8
  803616:	00 00 00 
  803619:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  80361c:	be 00 00 40 00       	mov    $0x400000,%esi
  803621:	bf 00 00 00 00       	mov    $0x0,%edi
  803626:	48 b8 b5 1c 80 00 00 	movabs $0x801cb5,%rax
  80362d:	00 00 00 
  803630:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803632:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803639:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80363c:	48 98                	cltq   
  80363e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803642:	0f 82 78 fe ff ff    	jb     8034c0 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803648:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80364d:	c9                   	leaveq 
  80364e:	c3                   	retq   

000000000080364f <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  80364f:	55                   	push   %rbp
  803650:	48 89 e5             	mov    %rsp,%rbp
  803653:	48 83 ec 50          	sub    $0x50,%rsp
  803657:	89 7d bc             	mov    %edi,-0x44(%rbp)
	// LAB 5: Your code here.
	// note: just copied and modified from lib/fork.c, function envid_t fork(void)
	void *addr;
	int r;
	pte_t i, j, k, l, ptx = 0;
  80365a:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803661:	00 

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  803662:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803669:	00 
  80366a:	e9 62 01 00 00       	jmpq   8037d1 <copy_shared_pages+0x182>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  80366f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803673:	48 c1 e8 1b          	shr    $0x1b,%rax
  803677:	48 89 c2             	mov    %rax,%rdx
  80367a:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803681:	01 00 00 
  803684:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803688:	83 e0 01             	and    $0x1,%eax
  80368b:	48 85 c0             	test   %rax,%rax
  80368e:	75 0d                	jne    80369d <copy_shared_pages+0x4e>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  803690:	48 81 45 d8 00 00 00 	addq   $0x8000000,-0x28(%rbp)
  803697:	08 
			continue;
  803698:	e9 2f 01 00 00       	jmpq   8037cc <copy_shared_pages+0x17d>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  80369d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8036a4:	00 
  8036a5:	e9 14 01 00 00       	jmpq   8037be <copy_shared_pages+0x16f>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  8036aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036ae:	48 c1 e8 12          	shr    $0x12,%rax
  8036b2:	48 89 c2             	mov    %rax,%rdx
  8036b5:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8036bc:	01 00 00 
  8036bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036c3:	83 e0 01             	and    $0x1,%eax
  8036c6:	48 85 c0             	test   %rax,%rax
  8036c9:	75 0d                	jne    8036d8 <copy_shared_pages+0x89>
				ptx += NPDENTRIES * NPTENTRIES;
  8036cb:	48 81 45 d8 00 00 04 	addq   $0x40000,-0x28(%rbp)
  8036d2:	00 
				continue;
  8036d3:	e9 e1 00 00 00       	jmpq   8037b9 <copy_shared_pages+0x16a>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  8036d8:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8036df:	00 
  8036e0:	e9 c6 00 00 00       	jmpq   8037ab <copy_shared_pages+0x15c>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  8036e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036e9:	48 c1 e8 09          	shr    $0x9,%rax
  8036ed:	48 89 c2             	mov    %rax,%rdx
  8036f0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8036f7:	01 00 00 
  8036fa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036fe:	83 e0 01             	and    $0x1,%eax
  803701:	48 85 c0             	test   %rax,%rax
  803704:	75 0d                	jne    803713 <copy_shared_pages+0xc4>
					ptx += NPTENTRIES;
  803706:	48 81 45 d8 00 02 00 	addq   $0x200,-0x28(%rbp)
  80370d:	00 
					continue;
  80370e:	e9 93 00 00 00       	jmpq   8037a6 <copy_shared_pages+0x157>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  803713:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  80371a:	00 
  80371b:	eb 7b                	jmp    803798 <copy_shared_pages+0x149>
					if ((uvpt[ptx] & PTE_SHARE) != 0) {
  80371d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803724:	01 00 00 
  803727:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80372b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80372f:	25 00 04 00 00       	and    $0x400,%eax
  803734:	48 85 c0             	test   %rax,%rax
  803737:	74 55                	je     80378e <copy_shared_pages+0x13f>
						addr = (void *)(ptx * PGSIZE);
  803739:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80373d:	48 c1 e0 0c          	shl    $0xc,%rax
  803741:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
						if ((r = sys_page_map(0, addr, child, addr, uvpt[ptx] & PTE_SYSCALL)) < 0)
  803745:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80374c:	01 00 00 
  80374f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803753:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803757:	25 07 0e 00 00       	and    $0xe07,%eax
  80375c:	89 c6                	mov    %eax,%esi
  80375e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803762:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803765:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803769:	41 89 f0             	mov    %esi,%r8d
  80376c:	48 89 c6             	mov    %rax,%rsi
  80376f:	bf 00 00 00 00       	mov    $0x0,%edi
  803774:	48 b8 5a 1c 80 00 00 	movabs $0x801c5a,%rax
  80377b:	00 00 00 
  80377e:	ff d0                	callq  *%rax
  803780:	89 45 cc             	mov    %eax,-0x34(%rbp)
  803783:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803787:	79 05                	jns    80378e <copy_shared_pages+0x13f>
							return r;
  803789:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80378c:	eb 53                	jmp    8037e1 <copy_shared_pages+0x192>
					}
					ptx++;
  80378e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  803793:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  803798:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  80379f:	00 
  8037a0:	0f 86 77 ff ff ff    	jbe    80371d <copy_shared_pages+0xce>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  8037a6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8037ab:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  8037b2:	00 
  8037b3:	0f 86 2c ff ff ff    	jbe    8036e5 <copy_shared_pages+0x96>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  8037b9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  8037be:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  8037c5:	00 
  8037c6:	0f 86 de fe ff ff    	jbe    8036aa <copy_shared_pages+0x5b>
	int r;
	pte_t i, j, k, l, ptx = 0;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  8037cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037d1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8037d6:	0f 84 93 fe ff ff    	je     80366f <copy_shared_pages+0x20>
				}
			}
		}
	}

	return 0;
  8037dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037e1:	c9                   	leaveq 
  8037e2:	c3                   	retq   

00000000008037e3 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8037e3:	55                   	push   %rbp
  8037e4:	48 89 e5             	mov    %rsp,%rbp
  8037e7:	53                   	push   %rbx
  8037e8:	48 83 ec 38          	sub    $0x38,%rsp
  8037ec:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8037f0:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8037f4:	48 89 c7             	mov    %rax,%rdi
  8037f7:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  8037fe:	00 00 00 
  803801:	ff d0                	callq  *%rax
  803803:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803806:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80380a:	0f 88 bf 01 00 00    	js     8039cf <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803810:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803814:	ba 07 04 00 00       	mov    $0x407,%edx
  803819:	48 89 c6             	mov    %rax,%rsi
  80381c:	bf 00 00 00 00       	mov    $0x0,%edi
  803821:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  803828:	00 00 00 
  80382b:	ff d0                	callq  *%rax
  80382d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803830:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803834:	0f 88 95 01 00 00    	js     8039cf <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80383a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80383e:	48 89 c7             	mov    %rax,%rdi
  803841:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  803848:	00 00 00 
  80384b:	ff d0                	callq  *%rax
  80384d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803850:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803854:	0f 88 5d 01 00 00    	js     8039b7 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80385a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80385e:	ba 07 04 00 00       	mov    $0x407,%edx
  803863:	48 89 c6             	mov    %rax,%rsi
  803866:	bf 00 00 00 00       	mov    $0x0,%edi
  80386b:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  803872:	00 00 00 
  803875:	ff d0                	callq  *%rax
  803877:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80387a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80387e:	0f 88 33 01 00 00    	js     8039b7 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803884:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803888:	48 89 c7             	mov    %rax,%rdi
  80388b:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  803892:	00 00 00 
  803895:	ff d0                	callq  *%rax
  803897:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80389b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80389f:	ba 07 04 00 00       	mov    $0x407,%edx
  8038a4:	48 89 c6             	mov    %rax,%rsi
  8038a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8038ac:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  8038b3:	00 00 00 
  8038b6:	ff d0                	callq  *%rax
  8038b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038bf:	79 05                	jns    8038c6 <pipe+0xe3>
		goto err2;
  8038c1:	e9 d9 00 00 00       	jmpq   80399f <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038ca:	48 89 c7             	mov    %rax,%rdi
  8038cd:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  8038d4:	00 00 00 
  8038d7:	ff d0                	callq  *%rax
  8038d9:	48 89 c2             	mov    %rax,%rdx
  8038dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038e0:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8038e6:	48 89 d1             	mov    %rdx,%rcx
  8038e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8038ee:	48 89 c6             	mov    %rax,%rsi
  8038f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8038f6:	48 b8 5a 1c 80 00 00 	movabs $0x801c5a,%rax
  8038fd:	00 00 00 
  803900:	ff d0                	callq  *%rax
  803902:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803905:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803909:	79 1b                	jns    803926 <pipe+0x143>
		goto err3;
  80390b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  80390c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803910:	48 89 c6             	mov    %rax,%rsi
  803913:	bf 00 00 00 00       	mov    $0x0,%edi
  803918:	48 b8 b5 1c 80 00 00 	movabs $0x801cb5,%rax
  80391f:	00 00 00 
  803922:	ff d0                	callq  *%rax
  803924:	eb 79                	jmp    80399f <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803926:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80392a:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803931:	00 00 00 
  803934:	8b 12                	mov    (%rdx),%edx
  803936:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803938:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80393c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803943:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803947:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80394e:	00 00 00 
  803951:	8b 12                	mov    (%rdx),%edx
  803953:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803955:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803959:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803960:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803964:	48 89 c7             	mov    %rax,%rdi
  803967:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  80396e:	00 00 00 
  803971:	ff d0                	callq  *%rax
  803973:	89 c2                	mov    %eax,%edx
  803975:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803979:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80397b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80397f:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803983:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803987:	48 89 c7             	mov    %rax,%rdi
  80398a:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  803991:	00 00 00 
  803994:	ff d0                	callq  *%rax
  803996:	89 03                	mov    %eax,(%rbx)
	return 0;
  803998:	b8 00 00 00 00       	mov    $0x0,%eax
  80399d:	eb 33                	jmp    8039d2 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  80399f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039a3:	48 89 c6             	mov    %rax,%rsi
  8039a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8039ab:	48 b8 b5 1c 80 00 00 	movabs $0x801cb5,%rax
  8039b2:	00 00 00 
  8039b5:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8039b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039bb:	48 89 c6             	mov    %rax,%rsi
  8039be:	bf 00 00 00 00       	mov    $0x0,%edi
  8039c3:	48 b8 b5 1c 80 00 00 	movabs $0x801cb5,%rax
  8039ca:	00 00 00 
  8039cd:	ff d0                	callq  *%rax
    err:
	return r;
  8039cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8039d2:	48 83 c4 38          	add    $0x38,%rsp
  8039d6:	5b                   	pop    %rbx
  8039d7:	5d                   	pop    %rbp
  8039d8:	c3                   	retq   

00000000008039d9 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8039d9:	55                   	push   %rbp
  8039da:	48 89 e5             	mov    %rsp,%rbp
  8039dd:	53                   	push   %rbx
  8039de:	48 83 ec 28          	sub    $0x28,%rsp
  8039e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8039ea:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039f1:	00 00 00 
  8039f4:	48 8b 00             	mov    (%rax),%rax
  8039f7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8039fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803a00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a04:	48 89 c7             	mov    %rax,%rdi
  803a07:	48 b8 42 42 80 00 00 	movabs $0x804242,%rax
  803a0e:	00 00 00 
  803a11:	ff d0                	callq  *%rax
  803a13:	89 c3                	mov    %eax,%ebx
  803a15:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a19:	48 89 c7             	mov    %rax,%rdi
  803a1c:	48 b8 42 42 80 00 00 	movabs $0x804242,%rax
  803a23:	00 00 00 
  803a26:	ff d0                	callq  *%rax
  803a28:	39 c3                	cmp    %eax,%ebx
  803a2a:	0f 94 c0             	sete   %al
  803a2d:	0f b6 c0             	movzbl %al,%eax
  803a30:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803a33:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a3a:	00 00 00 
  803a3d:	48 8b 00             	mov    (%rax),%rax
  803a40:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a46:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803a49:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a4c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803a4f:	75 05                	jne    803a56 <_pipeisclosed+0x7d>
			return ret;
  803a51:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a54:	eb 4f                	jmp    803aa5 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803a56:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a59:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803a5c:	74 42                	je     803aa0 <_pipeisclosed+0xc7>
  803a5e:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803a62:	75 3c                	jne    803aa0 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803a64:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a6b:	00 00 00 
  803a6e:	48 8b 00             	mov    (%rax),%rax
  803a71:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803a77:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a7a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a7d:	89 c6                	mov    %eax,%esi
  803a7f:	48 bf 1d 4a 80 00 00 	movabs $0x804a1d,%rdi
  803a86:	00 00 00 
  803a89:	b8 00 00 00 00       	mov    $0x0,%eax
  803a8e:	49 b8 33 05 80 00 00 	movabs $0x800533,%r8
  803a95:	00 00 00 
  803a98:	41 ff d0             	callq  *%r8
	}
  803a9b:	e9 4a ff ff ff       	jmpq   8039ea <_pipeisclosed+0x11>
  803aa0:	e9 45 ff ff ff       	jmpq   8039ea <_pipeisclosed+0x11>
}
  803aa5:	48 83 c4 28          	add    $0x28,%rsp
  803aa9:	5b                   	pop    %rbx
  803aaa:	5d                   	pop    %rbp
  803aab:	c3                   	retq   

0000000000803aac <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803aac:	55                   	push   %rbp
  803aad:	48 89 e5             	mov    %rsp,%rbp
  803ab0:	48 83 ec 30          	sub    $0x30,%rsp
  803ab4:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ab7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803abb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803abe:	48 89 d6             	mov    %rdx,%rsi
  803ac1:	89 c7                	mov    %eax,%edi
  803ac3:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  803aca:	00 00 00 
  803acd:	ff d0                	callq  *%rax
  803acf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ad2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ad6:	79 05                	jns    803add <pipeisclosed+0x31>
		return r;
  803ad8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803adb:	eb 31                	jmp    803b0e <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803add:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ae1:	48 89 c7             	mov    %rax,%rdi
  803ae4:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  803aeb:	00 00 00 
  803aee:	ff d0                	callq  *%rax
  803af0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803af4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803af8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803afc:	48 89 d6             	mov    %rdx,%rsi
  803aff:	48 89 c7             	mov    %rax,%rdi
  803b02:	48 b8 d9 39 80 00 00 	movabs $0x8039d9,%rax
  803b09:	00 00 00 
  803b0c:	ff d0                	callq  *%rax
}
  803b0e:	c9                   	leaveq 
  803b0f:	c3                   	retq   

0000000000803b10 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b10:	55                   	push   %rbp
  803b11:	48 89 e5             	mov    %rsp,%rbp
  803b14:	48 83 ec 40          	sub    $0x40,%rsp
  803b18:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b1c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b20:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803b24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b28:	48 89 c7             	mov    %rax,%rdi
  803b2b:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  803b32:	00 00 00 
  803b35:	ff d0                	callq  *%rax
  803b37:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b43:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b4a:	00 
  803b4b:	e9 92 00 00 00       	jmpq   803be2 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803b50:	eb 41                	jmp    803b93 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803b52:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803b57:	74 09                	je     803b62 <devpipe_read+0x52>
				return i;
  803b59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b5d:	e9 92 00 00 00       	jmpq   803bf4 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803b62:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b6a:	48 89 d6             	mov    %rdx,%rsi
  803b6d:	48 89 c7             	mov    %rax,%rdi
  803b70:	48 b8 d9 39 80 00 00 	movabs $0x8039d9,%rax
  803b77:	00 00 00 
  803b7a:	ff d0                	callq  *%rax
  803b7c:	85 c0                	test   %eax,%eax
  803b7e:	74 07                	je     803b87 <devpipe_read+0x77>
				return 0;
  803b80:	b8 00 00 00 00       	mov    $0x0,%eax
  803b85:	eb 6d                	jmp    803bf4 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803b87:	48 b8 cc 1b 80 00 00 	movabs $0x801bcc,%rax
  803b8e:	00 00 00 
  803b91:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803b93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b97:	8b 10                	mov    (%rax),%edx
  803b99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b9d:	8b 40 04             	mov    0x4(%rax),%eax
  803ba0:	39 c2                	cmp    %eax,%edx
  803ba2:	74 ae                	je     803b52 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803ba4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ba8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803bac:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803bb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb4:	8b 00                	mov    (%rax),%eax
  803bb6:	99                   	cltd   
  803bb7:	c1 ea 1b             	shr    $0x1b,%edx
  803bba:	01 d0                	add    %edx,%eax
  803bbc:	83 e0 1f             	and    $0x1f,%eax
  803bbf:	29 d0                	sub    %edx,%eax
  803bc1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bc5:	48 98                	cltq   
  803bc7:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803bcc:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803bce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd2:	8b 00                	mov    (%rax),%eax
  803bd4:	8d 50 01             	lea    0x1(%rax),%edx
  803bd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bdb:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803bdd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803be2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803be6:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803bea:	0f 82 60 ff ff ff    	jb     803b50 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803bf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803bf4:	c9                   	leaveq 
  803bf5:	c3                   	retq   

0000000000803bf6 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803bf6:	55                   	push   %rbp
  803bf7:	48 89 e5             	mov    %rsp,%rbp
  803bfa:	48 83 ec 40          	sub    $0x40,%rsp
  803bfe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c02:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c06:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803c0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c0e:	48 89 c7             	mov    %rax,%rdi
  803c11:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  803c18:	00 00 00 
  803c1b:	ff d0                	callq  *%rax
  803c1d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c21:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c25:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803c29:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803c30:	00 
  803c31:	e9 8e 00 00 00       	jmpq   803cc4 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c36:	eb 31                	jmp    803c69 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803c38:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c40:	48 89 d6             	mov    %rdx,%rsi
  803c43:	48 89 c7             	mov    %rax,%rdi
  803c46:	48 b8 d9 39 80 00 00 	movabs $0x8039d9,%rax
  803c4d:	00 00 00 
  803c50:	ff d0                	callq  *%rax
  803c52:	85 c0                	test   %eax,%eax
  803c54:	74 07                	je     803c5d <devpipe_write+0x67>
				return 0;
  803c56:	b8 00 00 00 00       	mov    $0x0,%eax
  803c5b:	eb 79                	jmp    803cd6 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803c5d:	48 b8 cc 1b 80 00 00 	movabs $0x801bcc,%rax
  803c64:	00 00 00 
  803c67:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c6d:	8b 40 04             	mov    0x4(%rax),%eax
  803c70:	48 63 d0             	movslq %eax,%rdx
  803c73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c77:	8b 00                	mov    (%rax),%eax
  803c79:	48 98                	cltq   
  803c7b:	48 83 c0 20          	add    $0x20,%rax
  803c7f:	48 39 c2             	cmp    %rax,%rdx
  803c82:	73 b4                	jae    803c38 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803c84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c88:	8b 40 04             	mov    0x4(%rax),%eax
  803c8b:	99                   	cltd   
  803c8c:	c1 ea 1b             	shr    $0x1b,%edx
  803c8f:	01 d0                	add    %edx,%eax
  803c91:	83 e0 1f             	and    $0x1f,%eax
  803c94:	29 d0                	sub    %edx,%eax
  803c96:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c9a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803c9e:	48 01 ca             	add    %rcx,%rdx
  803ca1:	0f b6 0a             	movzbl (%rdx),%ecx
  803ca4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ca8:	48 98                	cltq   
  803caa:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803cae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cb2:	8b 40 04             	mov    0x4(%rax),%eax
  803cb5:	8d 50 01             	lea    0x1(%rax),%edx
  803cb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cbc:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803cbf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803cc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cc8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ccc:	0f 82 64 ff ff ff    	jb     803c36 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803cd2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803cd6:	c9                   	leaveq 
  803cd7:	c3                   	retq   

0000000000803cd8 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803cd8:	55                   	push   %rbp
  803cd9:	48 89 e5             	mov    %rsp,%rbp
  803cdc:	48 83 ec 20          	sub    $0x20,%rsp
  803ce0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ce4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ce8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cec:	48 89 c7             	mov    %rax,%rdi
  803cef:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  803cf6:	00 00 00 
  803cf9:	ff d0                	callq  *%rax
  803cfb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803cff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d03:	48 be 30 4a 80 00 00 	movabs $0x804a30,%rsi
  803d0a:	00 00 00 
  803d0d:	48 89 c7             	mov    %rax,%rdi
  803d10:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  803d17:	00 00 00 
  803d1a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803d1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d20:	8b 50 04             	mov    0x4(%rax),%edx
  803d23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d27:	8b 00                	mov    (%rax),%eax
  803d29:	29 c2                	sub    %eax,%edx
  803d2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d2f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803d35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d39:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803d40:	00 00 00 
	stat->st_dev = &devpipe;
  803d43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d47:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803d4e:	00 00 00 
  803d51:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803d58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d5d:	c9                   	leaveq 
  803d5e:	c3                   	retq   

0000000000803d5f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803d5f:	55                   	push   %rbp
  803d60:	48 89 e5             	mov    %rsp,%rbp
  803d63:	48 83 ec 10          	sub    $0x10,%rsp
  803d67:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803d6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d6f:	48 89 c6             	mov    %rax,%rsi
  803d72:	bf 00 00 00 00       	mov    $0x0,%edi
  803d77:	48 b8 b5 1c 80 00 00 	movabs $0x801cb5,%rax
  803d7e:	00 00 00 
  803d81:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803d83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d87:	48 89 c7             	mov    %rax,%rdi
  803d8a:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  803d91:	00 00 00 
  803d94:	ff d0                	callq  *%rax
  803d96:	48 89 c6             	mov    %rax,%rsi
  803d99:	bf 00 00 00 00       	mov    $0x0,%edi
  803d9e:	48 b8 b5 1c 80 00 00 	movabs $0x801cb5,%rax
  803da5:	00 00 00 
  803da8:	ff d0                	callq  *%rax
}
  803daa:	c9                   	leaveq 
  803dab:	c3                   	retq   

0000000000803dac <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803dac:	55                   	push   %rbp
  803dad:	48 89 e5             	mov    %rsp,%rbp
  803db0:	48 83 ec 20          	sub    $0x20,%rsp
  803db4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803db7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dba:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803dbd:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803dc1:	be 01 00 00 00       	mov    $0x1,%esi
  803dc6:	48 89 c7             	mov    %rax,%rdi
  803dc9:	48 b8 c2 1a 80 00 00 	movabs $0x801ac2,%rax
  803dd0:	00 00 00 
  803dd3:	ff d0                	callq  *%rax
}
  803dd5:	c9                   	leaveq 
  803dd6:	c3                   	retq   

0000000000803dd7 <getchar>:

int
getchar(void)
{
  803dd7:	55                   	push   %rbp
  803dd8:	48 89 e5             	mov    %rsp,%rbp
  803ddb:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ddf:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803de3:	ba 01 00 00 00       	mov    $0x1,%edx
  803de8:	48 89 c6             	mov    %rax,%rsi
  803deb:	bf 00 00 00 00       	mov    $0x0,%edi
  803df0:	48 b8 8f 23 80 00 00 	movabs $0x80238f,%rax
  803df7:	00 00 00 
  803dfa:	ff d0                	callq  *%rax
  803dfc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803dff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e03:	79 05                	jns    803e0a <getchar+0x33>
		return r;
  803e05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e08:	eb 14                	jmp    803e1e <getchar+0x47>
	if (r < 1)
  803e0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e0e:	7f 07                	jg     803e17 <getchar+0x40>
		return -E_EOF;
  803e10:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803e15:	eb 07                	jmp    803e1e <getchar+0x47>
	return c;
  803e17:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803e1b:	0f b6 c0             	movzbl %al,%eax
}
  803e1e:	c9                   	leaveq 
  803e1f:	c3                   	retq   

0000000000803e20 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803e20:	55                   	push   %rbp
  803e21:	48 89 e5             	mov    %rsp,%rbp
  803e24:	48 83 ec 20          	sub    $0x20,%rsp
  803e28:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e2b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e2f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e32:	48 89 d6             	mov    %rdx,%rsi
  803e35:	89 c7                	mov    %eax,%edi
  803e37:	48 b8 5d 1f 80 00 00 	movabs $0x801f5d,%rax
  803e3e:	00 00 00 
  803e41:	ff d0                	callq  *%rax
  803e43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e4a:	79 05                	jns    803e51 <iscons+0x31>
		return r;
  803e4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e4f:	eb 1a                	jmp    803e6b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803e51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e55:	8b 10                	mov    (%rax),%edx
  803e57:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803e5e:	00 00 00 
  803e61:	8b 00                	mov    (%rax),%eax
  803e63:	39 c2                	cmp    %eax,%edx
  803e65:	0f 94 c0             	sete   %al
  803e68:	0f b6 c0             	movzbl %al,%eax
}
  803e6b:	c9                   	leaveq 
  803e6c:	c3                   	retq   

0000000000803e6d <opencons>:

int
opencons(void)
{
  803e6d:	55                   	push   %rbp
  803e6e:	48 89 e5             	mov    %rsp,%rbp
  803e71:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803e75:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803e79:	48 89 c7             	mov    %rax,%rdi
  803e7c:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  803e83:	00 00 00 
  803e86:	ff d0                	callq  *%rax
  803e88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e8f:	79 05                	jns    803e96 <opencons+0x29>
		return r;
  803e91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e94:	eb 5b                	jmp    803ef1 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803e96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e9a:	ba 07 04 00 00       	mov    $0x407,%edx
  803e9f:	48 89 c6             	mov    %rax,%rsi
  803ea2:	bf 00 00 00 00       	mov    $0x0,%edi
  803ea7:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  803eae:	00 00 00 
  803eb1:	ff d0                	callq  *%rax
  803eb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eba:	79 05                	jns    803ec1 <opencons+0x54>
		return r;
  803ebc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ebf:	eb 30                	jmp    803ef1 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803ec1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ec5:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803ecc:	00 00 00 
  803ecf:	8b 12                	mov    (%rdx),%edx
  803ed1:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803ed3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ed7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803ede:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee2:	48 89 c7             	mov    %rax,%rdi
  803ee5:	48 b8 77 1e 80 00 00 	movabs $0x801e77,%rax
  803eec:	00 00 00 
  803eef:	ff d0                	callq  *%rax
}
  803ef1:	c9                   	leaveq 
  803ef2:	c3                   	retq   

0000000000803ef3 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ef3:	55                   	push   %rbp
  803ef4:	48 89 e5             	mov    %rsp,%rbp
  803ef7:	48 83 ec 30          	sub    $0x30,%rsp
  803efb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803eff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f03:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803f07:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f0c:	75 07                	jne    803f15 <devcons_read+0x22>
		return 0;
  803f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  803f13:	eb 4b                	jmp    803f60 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803f15:	eb 0c                	jmp    803f23 <devcons_read+0x30>
		sys_yield();
  803f17:	48 b8 cc 1b 80 00 00 	movabs $0x801bcc,%rax
  803f1e:	00 00 00 
  803f21:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803f23:	48 b8 0c 1b 80 00 00 	movabs $0x801b0c,%rax
  803f2a:	00 00 00 
  803f2d:	ff d0                	callq  *%rax
  803f2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f36:	74 df                	je     803f17 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803f38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f3c:	79 05                	jns    803f43 <devcons_read+0x50>
		return c;
  803f3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f41:	eb 1d                	jmp    803f60 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803f43:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803f47:	75 07                	jne    803f50 <devcons_read+0x5d>
		return 0;
  803f49:	b8 00 00 00 00       	mov    $0x0,%eax
  803f4e:	eb 10                	jmp    803f60 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803f50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f53:	89 c2                	mov    %eax,%edx
  803f55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f59:	88 10                	mov    %dl,(%rax)
	return 1;
  803f5b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803f60:	c9                   	leaveq 
  803f61:	c3                   	retq   

0000000000803f62 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f62:	55                   	push   %rbp
  803f63:	48 89 e5             	mov    %rsp,%rbp
  803f66:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803f6d:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803f74:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803f7b:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f89:	eb 76                	jmp    804001 <devcons_write+0x9f>
		m = n - tot;
  803f8b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803f92:	89 c2                	mov    %eax,%edx
  803f94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f97:	29 c2                	sub    %eax,%edx
  803f99:	89 d0                	mov    %edx,%eax
  803f9b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803f9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fa1:	83 f8 7f             	cmp    $0x7f,%eax
  803fa4:	76 07                	jbe    803fad <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803fa6:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803fad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fb0:	48 63 d0             	movslq %eax,%rdx
  803fb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb6:	48 63 c8             	movslq %eax,%rcx
  803fb9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803fc0:	48 01 c1             	add    %rax,%rcx
  803fc3:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803fca:	48 89 ce             	mov    %rcx,%rsi
  803fcd:	48 89 c7             	mov    %rax,%rdi
  803fd0:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  803fd7:	00 00 00 
  803fda:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803fdc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fdf:	48 63 d0             	movslq %eax,%rdx
  803fe2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803fe9:	48 89 d6             	mov    %rdx,%rsi
  803fec:	48 89 c7             	mov    %rax,%rdi
  803fef:	48 b8 c2 1a 80 00 00 	movabs $0x801ac2,%rax
  803ff6:	00 00 00 
  803ff9:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ffb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ffe:	01 45 fc             	add    %eax,-0x4(%rbp)
  804001:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804004:	48 98                	cltq   
  804006:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80400d:	0f 82 78 ff ff ff    	jb     803f8b <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804013:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804016:	c9                   	leaveq 
  804017:	c3                   	retq   

0000000000804018 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804018:	55                   	push   %rbp
  804019:	48 89 e5             	mov    %rsp,%rbp
  80401c:	48 83 ec 08          	sub    $0x8,%rsp
  804020:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804024:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804029:	c9                   	leaveq 
  80402a:	c3                   	retq   

000000000080402b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80402b:	55                   	push   %rbp
  80402c:	48 89 e5             	mov    %rsp,%rbp
  80402f:	48 83 ec 10          	sub    $0x10,%rsp
  804033:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804037:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80403b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80403f:	48 be 3c 4a 80 00 00 	movabs $0x804a3c,%rsi
  804046:	00 00 00 
  804049:	48 89 c7             	mov    %rax,%rdi
  80404c:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  804053:	00 00 00 
  804056:	ff d0                	callq  *%rax
	return 0;
  804058:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80405d:	c9                   	leaveq 
  80405e:	c3                   	retq   

000000000080405f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80405f:	55                   	push   %rbp
  804060:	48 89 e5             	mov    %rsp,%rbp
  804063:	48 83 ec 30          	sub    $0x30,%rsp
  804067:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80406b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80406f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  804073:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804077:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  80407b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804080:	75 0e                	jne    804090 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  804082:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  804089:	00 00 00 
  80408c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  804090:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804094:	48 89 c7             	mov    %rax,%rdi
  804097:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  80409e:	00 00 00 
  8040a1:	ff d0                	callq  *%rax
  8040a3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8040a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8040aa:	79 27                	jns    8040d3 <ipc_recv+0x74>
		if (from_env_store != NULL)
  8040ac:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8040b1:	74 0a                	je     8040bd <ipc_recv+0x5e>
			*from_env_store = 0;
  8040b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040b7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  8040bd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040c2:	74 0a                	je     8040ce <ipc_recv+0x6f>
			*perm_store = 0;
  8040c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040c8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8040ce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8040d1:	eb 53                	jmp    804126 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  8040d3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8040d8:	74 19                	je     8040f3 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  8040da:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8040e1:	00 00 00 
  8040e4:	48 8b 00             	mov    (%rax),%rax
  8040e7:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8040ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040f1:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  8040f3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040f8:	74 19                	je     804113 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  8040fa:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804101:	00 00 00 
  804104:	48 8b 00             	mov    (%rax),%rax
  804107:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80410d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804111:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  804113:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80411a:	00 00 00 
  80411d:	48 8b 00             	mov    (%rax),%rax
  804120:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  804126:	c9                   	leaveq 
  804127:	c3                   	retq   

0000000000804128 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804128:	55                   	push   %rbp
  804129:	48 89 e5             	mov    %rsp,%rbp
  80412c:	48 83 ec 30          	sub    $0x30,%rsp
  804130:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804133:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804136:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80413a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  80413d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804141:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  804145:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80414a:	75 10                	jne    80415c <ipc_send+0x34>
		page = (void *)KERNBASE;
  80414c:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  804153:	00 00 00 
  804156:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  80415a:	eb 0e                	jmp    80416a <ipc_send+0x42>
  80415c:	eb 0c                	jmp    80416a <ipc_send+0x42>
		sys_yield();
  80415e:	48 b8 cc 1b 80 00 00 	movabs $0x801bcc,%rax
  804165:	00 00 00 
  804168:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  80416a:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80416d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804170:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804174:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804177:	89 c7                	mov    %eax,%edi
  804179:	48 b8 de 1d 80 00 00 	movabs $0x801dde,%rax
  804180:	00 00 00 
  804183:	ff d0                	callq  *%rax
  804185:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804188:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  80418c:	74 d0                	je     80415e <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  80418e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  804192:	74 2a                	je     8041be <ipc_send+0x96>
		panic("error on ipc send procedure");
  804194:	48 ba 43 4a 80 00 00 	movabs $0x804a43,%rdx
  80419b:	00 00 00 
  80419e:	be 49 00 00 00       	mov    $0x49,%esi
  8041a3:	48 bf 5f 4a 80 00 00 	movabs $0x804a5f,%rdi
  8041aa:	00 00 00 
  8041ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8041b2:	48 b9 fa 02 80 00 00 	movabs $0x8002fa,%rcx
  8041b9:	00 00 00 
  8041bc:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  8041be:	c9                   	leaveq 
  8041bf:	c3                   	retq   

00000000008041c0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8041c0:	55                   	push   %rbp
  8041c1:	48 89 e5             	mov    %rsp,%rbp
  8041c4:	48 83 ec 14          	sub    $0x14,%rsp
  8041c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8041cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041d2:	eb 5e                	jmp    804232 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8041d4:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8041db:	00 00 00 
  8041de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041e1:	48 63 d0             	movslq %eax,%rdx
  8041e4:	48 89 d0             	mov    %rdx,%rax
  8041e7:	48 c1 e0 03          	shl    $0x3,%rax
  8041eb:	48 01 d0             	add    %rdx,%rax
  8041ee:	48 c1 e0 05          	shl    $0x5,%rax
  8041f2:	48 01 c8             	add    %rcx,%rax
  8041f5:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8041fb:	8b 00                	mov    (%rax),%eax
  8041fd:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804200:	75 2c                	jne    80422e <ipc_find_env+0x6e>
			return envs[i].env_id;
  804202:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804209:	00 00 00 
  80420c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80420f:	48 63 d0             	movslq %eax,%rdx
  804212:	48 89 d0             	mov    %rdx,%rax
  804215:	48 c1 e0 03          	shl    $0x3,%rax
  804219:	48 01 d0             	add    %rdx,%rax
  80421c:	48 c1 e0 05          	shl    $0x5,%rax
  804220:	48 01 c8             	add    %rcx,%rax
  804223:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804229:	8b 40 08             	mov    0x8(%rax),%eax
  80422c:	eb 12                	jmp    804240 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80422e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804232:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804239:	7e 99                	jle    8041d4 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80423b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804240:	c9                   	leaveq 
  804241:	c3                   	retq   

0000000000804242 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804242:	55                   	push   %rbp
  804243:	48 89 e5             	mov    %rsp,%rbp
  804246:	48 83 ec 18          	sub    $0x18,%rsp
  80424a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80424e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804252:	48 c1 e8 15          	shr    $0x15,%rax
  804256:	48 89 c2             	mov    %rax,%rdx
  804259:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804260:	01 00 00 
  804263:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804267:	83 e0 01             	and    $0x1,%eax
  80426a:	48 85 c0             	test   %rax,%rax
  80426d:	75 07                	jne    804276 <pageref+0x34>
		return 0;
  80426f:	b8 00 00 00 00       	mov    $0x0,%eax
  804274:	eb 53                	jmp    8042c9 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804276:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80427a:	48 c1 e8 0c          	shr    $0xc,%rax
  80427e:	48 89 c2             	mov    %rax,%rdx
  804281:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804288:	01 00 00 
  80428b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80428f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804293:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804297:	83 e0 01             	and    $0x1,%eax
  80429a:	48 85 c0             	test   %rax,%rax
  80429d:	75 07                	jne    8042a6 <pageref+0x64>
		return 0;
  80429f:	b8 00 00 00 00       	mov    $0x0,%eax
  8042a4:	eb 23                	jmp    8042c9 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8042a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042aa:	48 c1 e8 0c          	shr    $0xc,%rax
  8042ae:	48 89 c2             	mov    %rax,%rdx
  8042b1:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8042b8:	00 00 00 
  8042bb:	48 c1 e2 04          	shl    $0x4,%rdx
  8042bf:	48 01 d0             	add    %rdx,%rax
  8042c2:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8042c6:	0f b7 c0             	movzwl %ax,%eax
}
  8042c9:	c9                   	leaveq 
  8042ca:	c3                   	retq   
