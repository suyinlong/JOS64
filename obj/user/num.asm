
obj/user/num.debug:     file format elf64-x86-64


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
  80003c:	e8 97 02 00 00       	callq  8002d8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800052:	e9 da 00 00 00       	jmpq   800131 <num+0xee>
		if (bol) {
  800057:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80005e:	00 00 00 
  800061:	8b 00                	mov    (%rax),%eax
  800063:	85 c0                	test   %eax,%eax
  800065:	74 54                	je     8000bb <num+0x78>
			printf("%5d ", ++line);
  800067:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80006e:	00 00 00 
  800071:	8b 00                	mov    (%rax),%eax
  800073:	8d 50 01             	lea    0x1(%rax),%edx
  800076:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80007d:	00 00 00 
  800080:	89 10                	mov    %edx,(%rax)
  800082:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800089:	00 00 00 
  80008c:	8b 00                	mov    (%rax),%eax
  80008e:	89 c6                	mov    %eax,%esi
  800090:	48 bf 80 3a 80 00 00 	movabs $0x803a80,%rdi
  800097:	00 00 00 
  80009a:	b8 00 00 00 00       	mov    $0x0,%eax
  80009f:	48 ba d6 2e 80 00 00 	movabs $0x802ed6,%rdx
  8000a6:	00 00 00 
  8000a9:	ff d2                	callq  *%rdx
			bol = 0;
  8000ab:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000b2:	00 00 00 
  8000b5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if ((r = write(1, &c, 1)) != 1)
  8000bb:	48 8d 45 f3          	lea    -0xd(%rbp),%rax
  8000bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8000c4:	48 89 c6             	mov    %rax,%rsi
  8000c7:	bf 01 00 00 00       	mov    $0x1,%edi
  8000cc:	48 b8 6a 25 80 00 00 	movabs $0x80256a,%rax
  8000d3:	00 00 00 
  8000d6:	ff d0                	callq  *%rax
  8000d8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000db:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
  8000df:	74 38                	je     800119 <num+0xd6>
			panic("write error copying %s: %e", s, r);
  8000e1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000e8:	41 89 d0             	mov    %edx,%r8d
  8000eb:	48 89 c1             	mov    %rax,%rcx
  8000ee:	48 ba 85 3a 80 00 00 	movabs $0x803a85,%rdx
  8000f5:	00 00 00 
  8000f8:	be 13 00 00 00       	mov    $0x13,%esi
  8000fd:	48 bf a0 3a 80 00 00 	movabs $0x803aa0,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	49 b9 8b 03 80 00 00 	movabs $0x80038b,%r9
  800113:	00 00 00 
  800116:	41 ff d1             	callq  *%r9
		if (c == '\n')
  800119:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  80011d:	3c 0a                	cmp    $0xa,%al
  80011f:	75 10                	jne    800131 <num+0xee>
			bol = 1;
  800121:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800128:	00 00 00 
  80012b:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800131:	48 8d 4d f3          	lea    -0xd(%rbp),%rcx
  800135:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800138:	ba 01 00 00 00       	mov    $0x1,%edx
  80013d:	48 89 ce             	mov    %rcx,%rsi
  800140:	89 c7                	mov    %eax,%edi
  800142:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  800149:	00 00 00 
  80014c:	ff d0                	callq  *%rax
  80014e:	48 98                	cltq   
  800150:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800154:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800159:	0f 8f f8 fe ff ff    	jg     800057 <num+0x14>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  80015f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800164:	79 39                	jns    80019f <num+0x15c>
		panic("error reading %s: %e", s, n);
  800166:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80016a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80016e:	49 89 d0             	mov    %rdx,%r8
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba ab 3a 80 00 00 	movabs $0x803aab,%rdx
  80017b:	00 00 00 
  80017e:	be 18 00 00 00       	mov    $0x18,%esi
  800183:	48 bf a0 3a 80 00 00 	movabs $0x803aa0,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 8b 03 80 00 00 	movabs $0x80038b,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
}
  80019f:	c9                   	leaveq 
  8001a0:	c3                   	retq   

00000000008001a1 <umain>:

void
umain(int argc, char **argv)
{
  8001a1:	55                   	push   %rbp
  8001a2:	48 89 e5             	mov    %rsp,%rbp
  8001a5:	53                   	push   %rbx
  8001a6:	48 83 ec 28          	sub    $0x28,%rsp
  8001aa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8001ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int f, i;

	binaryname = "num";
  8001b1:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8001b8:	00 00 00 
  8001bb:	48 bb c0 3a 80 00 00 	movabs $0x803ac0,%rbx
  8001c2:	00 00 00 
  8001c5:	48 89 18             	mov    %rbx,(%rax)
	if (argc == 1)
  8001c8:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
  8001cc:	75 20                	jne    8001ee <umain+0x4d>
		num(0, "<stdin>");
  8001ce:	48 be c4 3a 80 00 00 	movabs $0x803ac4,%rsi
  8001d5:	00 00 00 
  8001d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001dd:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
  8001e9:	e9 d7 00 00 00       	jmpq   8002c5 <umain+0x124>
	else
		for (i = 1; i < argc; i++) {
  8001ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  8001f5:	e9 bf 00 00 00       	jmpq   8002b9 <umain+0x118>
			f = open(argv[i], O_RDONLY);
  8001fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001fd:	48 98                	cltq   
  8001ff:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800206:	00 
  800207:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80020b:	48 01 d0             	add    %rdx,%rax
  80020e:	48 8b 00             	mov    (%rax),%rax
  800211:	be 00 00 00 00       	mov    $0x0,%esi
  800216:	48 89 c7             	mov    %rax,%rdi
  800219:	48 b8 f6 28 80 00 00 	movabs $0x8028f6,%rax
  800220:	00 00 00 
  800223:	ff d0                	callq  *%rax
  800225:	89 45 e8             	mov    %eax,-0x18(%rbp)
			if (f < 0)
  800228:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80022c:	79 4b                	jns    800279 <umain+0xd8>
				panic("can't open %s: %e", argv[i], f);
  80022e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800231:	48 98                	cltq   
  800233:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80023a:	00 
  80023b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80023f:	48 01 d0             	add    %rdx,%rax
  800242:	48 8b 00             	mov    (%rax),%rax
  800245:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800248:	41 89 d0             	mov    %edx,%r8d
  80024b:	48 89 c1             	mov    %rax,%rcx
  80024e:	48 ba cc 3a 80 00 00 	movabs $0x803acc,%rdx
  800255:	00 00 00 
  800258:	be 27 00 00 00       	mov    $0x27,%esi
  80025d:	48 bf a0 3a 80 00 00 	movabs $0x803aa0,%rdi
  800264:	00 00 00 
  800267:	b8 00 00 00 00       	mov    $0x0,%eax
  80026c:	49 b9 8b 03 80 00 00 	movabs $0x80038b,%r9
  800273:	00 00 00 
  800276:	41 ff d1             	callq  *%r9
			else {
				num(f, argv[i]);
  800279:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027c:	48 98                	cltq   
  80027e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800285:	00 
  800286:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80028a:	48 01 d0             	add    %rdx,%rax
  80028d:	48 8b 10             	mov    (%rax),%rdx
  800290:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800293:	48 89 d6             	mov    %rdx,%rsi
  800296:	89 c7                	mov    %eax,%edi
  800298:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80029f:	00 00 00 
  8002a2:	ff d0                	callq  *%rax
				close(f);
  8002a4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002a7:	89 c7                	mov    %eax,%edi
  8002a9:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  8002b0:	00 00 00 
  8002b3:	ff d0                	callq  *%rax

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8002b5:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8002b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002bc:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  8002bf:	0f 8c 35 ff ff ff    	jl     8001fa <umain+0x59>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8002c5:	48 b8 68 03 80 00 00 	movabs $0x800368,%rax
  8002cc:	00 00 00 
  8002cf:	ff d0                	callq  *%rax
}
  8002d1:	48 83 c4 28          	add    $0x28,%rsp
  8002d5:	5b                   	pop    %rbx
  8002d6:	5d                   	pop    %rbp
  8002d7:	c3                   	retq   

00000000008002d8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d8:	55                   	push   %rbp
  8002d9:	48 89 e5             	mov    %rsp,%rbp
  8002dc:	48 83 ec 10          	sub    $0x10,%rsp
  8002e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8002e7:	48 b8 1f 1c 80 00 00 	movabs $0x801c1f,%rax
  8002ee:	00 00 00 
  8002f1:	ff d0                	callq  *%rax
  8002f3:	48 98                	cltq   
  8002f5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002fa:	48 89 c2             	mov    %rax,%rdx
  8002fd:	48 89 d0             	mov    %rdx,%rax
  800300:	48 c1 e0 03          	shl    $0x3,%rax
  800304:	48 01 d0             	add    %rdx,%rax
  800307:	48 c1 e0 05          	shl    $0x5,%rax
  80030b:	48 89 c2             	mov    %rax,%rdx
  80030e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800315:	00 00 00 
  800318:	48 01 c2             	add    %rax,%rdx
  80031b:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  800322:	00 00 00 
  800325:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800328:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80032c:	7e 14                	jle    800342 <libmain+0x6a>
		binaryname = argv[0];
  80032e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800332:	48 8b 10             	mov    (%rax),%rdx
  800335:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80033c:	00 00 00 
  80033f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800342:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800346:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800349:	48 89 d6             	mov    %rdx,%rsi
  80034c:	89 c7                	mov    %eax,%edi
  80034e:	48 b8 a1 01 80 00 00 	movabs $0x8001a1,%rax
  800355:	00 00 00 
  800358:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80035a:	48 b8 68 03 80 00 00 	movabs $0x800368,%rax
  800361:	00 00 00 
  800364:	ff d0                	callq  *%rax
}
  800366:	c9                   	leaveq 
  800367:	c3                   	retq   

0000000000800368 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800368:	55                   	push   %rbp
  800369:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80036c:	48 b8 49 22 80 00 00 	movabs $0x802249,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800378:	bf 00 00 00 00       	mov    $0x0,%edi
  80037d:	48 b8 db 1b 80 00 00 	movabs $0x801bdb,%rax
  800384:	00 00 00 
  800387:	ff d0                	callq  *%rax
}
  800389:	5d                   	pop    %rbp
  80038a:	c3                   	retq   

000000000080038b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80038b:	55                   	push   %rbp
  80038c:	48 89 e5             	mov    %rsp,%rbp
  80038f:	53                   	push   %rbx
  800390:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800397:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80039e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003a4:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003ab:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8003b2:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8003b9:	84 c0                	test   %al,%al
  8003bb:	74 23                	je     8003e0 <_panic+0x55>
  8003bd:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8003c4:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8003c8:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8003cc:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8003d0:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003d4:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003d8:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003dc:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003e0:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003e7:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003ee:	00 00 00 
  8003f1:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003f8:	00 00 00 
  8003fb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003ff:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800406:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80040d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800414:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  80041b:	00 00 00 
  80041e:	48 8b 18             	mov    (%rax),%rbx
  800421:	48 b8 1f 1c 80 00 00 	movabs $0x801c1f,%rax
  800428:	00 00 00 
  80042b:	ff d0                	callq  *%rax
  80042d:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800433:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80043a:	41 89 c8             	mov    %ecx,%r8d
  80043d:	48 89 d1             	mov    %rdx,%rcx
  800440:	48 89 da             	mov    %rbx,%rdx
  800443:	89 c6                	mov    %eax,%esi
  800445:	48 bf e8 3a 80 00 00 	movabs $0x803ae8,%rdi
  80044c:	00 00 00 
  80044f:	b8 00 00 00 00       	mov    $0x0,%eax
  800454:	49 b9 c4 05 80 00 00 	movabs $0x8005c4,%r9
  80045b:	00 00 00 
  80045e:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800461:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800468:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80046f:	48 89 d6             	mov    %rdx,%rsi
  800472:	48 89 c7             	mov    %rax,%rdi
  800475:	48 b8 18 05 80 00 00 	movabs $0x800518,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax
	cprintf("\n");
  800481:	48 bf 0b 3b 80 00 00 	movabs $0x803b0b,%rdi
  800488:	00 00 00 
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	48 ba c4 05 80 00 00 	movabs $0x8005c4,%rdx
  800497:	00 00 00 
  80049a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80049c:	cc                   	int3   
  80049d:	eb fd                	jmp    80049c <_panic+0x111>

000000000080049f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80049f:	55                   	push   %rbp
  8004a0:	48 89 e5             	mov    %rsp,%rbp
  8004a3:	48 83 ec 10          	sub    $0x10,%rsp
  8004a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8004ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004b2:	8b 00                	mov    (%rax),%eax
  8004b4:	8d 48 01             	lea    0x1(%rax),%ecx
  8004b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004bb:	89 0a                	mov    %ecx,(%rdx)
  8004bd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004c0:	89 d1                	mov    %edx,%ecx
  8004c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004c6:	48 98                	cltq   
  8004c8:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8004cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d0:	8b 00                	mov    (%rax),%eax
  8004d2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d7:	75 2c                	jne    800505 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8004d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004dd:	8b 00                	mov    (%rax),%eax
  8004df:	48 98                	cltq   
  8004e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004e5:	48 83 c2 08          	add    $0x8,%rdx
  8004e9:	48 89 c6             	mov    %rax,%rsi
  8004ec:	48 89 d7             	mov    %rdx,%rdi
  8004ef:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  8004f6:	00 00 00 
  8004f9:	ff d0                	callq  *%rax
		b->idx = 0;
  8004fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004ff:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800505:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800509:	8b 40 04             	mov    0x4(%rax),%eax
  80050c:	8d 50 01             	lea    0x1(%rax),%edx
  80050f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800513:	89 50 04             	mov    %edx,0x4(%rax)
}
  800516:	c9                   	leaveq 
  800517:	c3                   	retq   

0000000000800518 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800518:	55                   	push   %rbp
  800519:	48 89 e5             	mov    %rsp,%rbp
  80051c:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800523:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80052a:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800531:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800538:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80053f:	48 8b 0a             	mov    (%rdx),%rcx
  800542:	48 89 08             	mov    %rcx,(%rax)
  800545:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800549:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80054d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800551:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800555:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80055c:	00 00 00 
	b.cnt = 0;
  80055f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800566:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800569:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800570:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800577:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80057e:	48 89 c6             	mov    %rax,%rsi
  800581:	48 bf 9f 04 80 00 00 	movabs $0x80049f,%rdi
  800588:	00 00 00 
  80058b:	48 b8 77 09 80 00 00 	movabs $0x800977,%rax
  800592:	00 00 00 
  800595:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800597:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80059d:	48 98                	cltq   
  80059f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005a6:	48 83 c2 08          	add    $0x8,%rdx
  8005aa:	48 89 c6             	mov    %rax,%rsi
  8005ad:	48 89 d7             	mov    %rdx,%rdi
  8005b0:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  8005b7:	00 00 00 
  8005ba:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8005bc:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8005c2:	c9                   	leaveq 
  8005c3:	c3                   	retq   

00000000008005c4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005c4:	55                   	push   %rbp
  8005c5:	48 89 e5             	mov    %rsp,%rbp
  8005c8:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8005cf:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005d6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005dd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005e4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005eb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005f2:	84 c0                	test   %al,%al
  8005f4:	74 20                	je     800616 <cprintf+0x52>
  8005f6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005fa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005fe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800602:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800606:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80060a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80060e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800612:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800616:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80061d:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800624:	00 00 00 
  800627:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80062e:	00 00 00 
  800631:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800635:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80063c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800643:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80064a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800651:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800658:	48 8b 0a             	mov    (%rdx),%rcx
  80065b:	48 89 08             	mov    %rcx,(%rax)
  80065e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800662:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800666:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80066a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80066e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800675:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80067c:	48 89 d6             	mov    %rdx,%rsi
  80067f:	48 89 c7             	mov    %rax,%rdi
  800682:	48 b8 18 05 80 00 00 	movabs $0x800518,%rax
  800689:	00 00 00 
  80068c:	ff d0                	callq  *%rax
  80068e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800694:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80069a:	c9                   	leaveq 
  80069b:	c3                   	retq   

000000000080069c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80069c:	55                   	push   %rbp
  80069d:	48 89 e5             	mov    %rsp,%rbp
  8006a0:	53                   	push   %rbx
  8006a1:	48 83 ec 38          	sub    $0x38,%rsp
  8006a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8006b1:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8006b4:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8006b8:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006bc:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8006bf:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8006c3:	77 3b                	ja     800700 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006c5:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8006c8:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8006cc:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8006cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d8:	48 f7 f3             	div    %rbx
  8006db:	48 89 c2             	mov    %rax,%rdx
  8006de:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8006e1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006e4:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8006e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ec:	41 89 f9             	mov    %edi,%r9d
  8006ef:	48 89 c7             	mov    %rax,%rdi
  8006f2:	48 b8 9c 06 80 00 00 	movabs $0x80069c,%rax
  8006f9:	00 00 00 
  8006fc:	ff d0                	callq  *%rax
  8006fe:	eb 1e                	jmp    80071e <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800700:	eb 12                	jmp    800714 <printnum+0x78>
			putch(padc, putdat);
  800702:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800706:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800709:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070d:	48 89 ce             	mov    %rcx,%rsi
  800710:	89 d7                	mov    %edx,%edi
  800712:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800714:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800718:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80071c:	7f e4                	jg     800702 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80071e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800721:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800725:	ba 00 00 00 00       	mov    $0x0,%edx
  80072a:	48 f7 f1             	div    %rcx
  80072d:	48 89 d0             	mov    %rdx,%rax
  800730:	48 ba e8 3c 80 00 00 	movabs $0x803ce8,%rdx
  800737:	00 00 00 
  80073a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80073e:	0f be d0             	movsbl %al,%edx
  800741:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800749:	48 89 ce             	mov    %rcx,%rsi
  80074c:	89 d7                	mov    %edx,%edi
  80074e:	ff d0                	callq  *%rax
}
  800750:	48 83 c4 38          	add    $0x38,%rsp
  800754:	5b                   	pop    %rbx
  800755:	5d                   	pop    %rbp
  800756:	c3                   	retq   

0000000000800757 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800757:	55                   	push   %rbp
  800758:	48 89 e5             	mov    %rsp,%rbp
  80075b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80075f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800763:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800766:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80076a:	7e 52                	jle    8007be <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80076c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800770:	8b 00                	mov    (%rax),%eax
  800772:	83 f8 30             	cmp    $0x30,%eax
  800775:	73 24                	jae    80079b <getuint+0x44>
  800777:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80077f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800783:	8b 00                	mov    (%rax),%eax
  800785:	89 c0                	mov    %eax,%eax
  800787:	48 01 d0             	add    %rdx,%rax
  80078a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078e:	8b 12                	mov    (%rdx),%edx
  800790:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800793:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800797:	89 0a                	mov    %ecx,(%rdx)
  800799:	eb 17                	jmp    8007b2 <getuint+0x5b>
  80079b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007a3:	48 89 d0             	mov    %rdx,%rax
  8007a6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007b2:	48 8b 00             	mov    (%rax),%rax
  8007b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007b9:	e9 a3 00 00 00       	jmpq   800861 <getuint+0x10a>
	else if (lflag)
  8007be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007c2:	74 4f                	je     800813 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8007c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c8:	8b 00                	mov    (%rax),%eax
  8007ca:	83 f8 30             	cmp    $0x30,%eax
  8007cd:	73 24                	jae    8007f3 <getuint+0x9c>
  8007cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007db:	8b 00                	mov    (%rax),%eax
  8007dd:	89 c0                	mov    %eax,%eax
  8007df:	48 01 d0             	add    %rdx,%rax
  8007e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e6:	8b 12                	mov    (%rdx),%edx
  8007e8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ef:	89 0a                	mov    %ecx,(%rdx)
  8007f1:	eb 17                	jmp    80080a <getuint+0xb3>
  8007f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007fb:	48 89 d0             	mov    %rdx,%rax
  8007fe:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800802:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800806:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80080a:	48 8b 00             	mov    (%rax),%rax
  80080d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800811:	eb 4e                	jmp    800861 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800817:	8b 00                	mov    (%rax),%eax
  800819:	83 f8 30             	cmp    $0x30,%eax
  80081c:	73 24                	jae    800842 <getuint+0xeb>
  80081e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800822:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800826:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082a:	8b 00                	mov    (%rax),%eax
  80082c:	89 c0                	mov    %eax,%eax
  80082e:	48 01 d0             	add    %rdx,%rax
  800831:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800835:	8b 12                	mov    (%rdx),%edx
  800837:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80083a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083e:	89 0a                	mov    %ecx,(%rdx)
  800840:	eb 17                	jmp    800859 <getuint+0x102>
  800842:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800846:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80084a:	48 89 d0             	mov    %rdx,%rax
  80084d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800851:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800855:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800859:	8b 00                	mov    (%rax),%eax
  80085b:	89 c0                	mov    %eax,%eax
  80085d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800861:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800865:	c9                   	leaveq 
  800866:	c3                   	retq   

0000000000800867 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800867:	55                   	push   %rbp
  800868:	48 89 e5             	mov    %rsp,%rbp
  80086b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80086f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800873:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800876:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80087a:	7e 52                	jle    8008ce <getint+0x67>
		x=va_arg(*ap, long long);
  80087c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800880:	8b 00                	mov    (%rax),%eax
  800882:	83 f8 30             	cmp    $0x30,%eax
  800885:	73 24                	jae    8008ab <getint+0x44>
  800887:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80088f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800893:	8b 00                	mov    (%rax),%eax
  800895:	89 c0                	mov    %eax,%eax
  800897:	48 01 d0             	add    %rdx,%rax
  80089a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089e:	8b 12                	mov    (%rdx),%edx
  8008a0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a7:	89 0a                	mov    %ecx,(%rdx)
  8008a9:	eb 17                	jmp    8008c2 <getint+0x5b>
  8008ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008af:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008b3:	48 89 d0             	mov    %rdx,%rax
  8008b6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008be:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008c2:	48 8b 00             	mov    (%rax),%rax
  8008c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008c9:	e9 a3 00 00 00       	jmpq   800971 <getint+0x10a>
	else if (lflag)
  8008ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008d2:	74 4f                	je     800923 <getint+0xbc>
		x=va_arg(*ap, long);
  8008d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d8:	8b 00                	mov    (%rax),%eax
  8008da:	83 f8 30             	cmp    $0x30,%eax
  8008dd:	73 24                	jae    800903 <getint+0x9c>
  8008df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008eb:	8b 00                	mov    (%rax),%eax
  8008ed:	89 c0                	mov    %eax,%eax
  8008ef:	48 01 d0             	add    %rdx,%rax
  8008f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f6:	8b 12                	mov    (%rdx),%edx
  8008f8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ff:	89 0a                	mov    %ecx,(%rdx)
  800901:	eb 17                	jmp    80091a <getint+0xb3>
  800903:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800907:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80090b:	48 89 d0             	mov    %rdx,%rax
  80090e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800912:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800916:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80091a:	48 8b 00             	mov    (%rax),%rax
  80091d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800921:	eb 4e                	jmp    800971 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800923:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800927:	8b 00                	mov    (%rax),%eax
  800929:	83 f8 30             	cmp    $0x30,%eax
  80092c:	73 24                	jae    800952 <getint+0xeb>
  80092e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800932:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800936:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093a:	8b 00                	mov    (%rax),%eax
  80093c:	89 c0                	mov    %eax,%eax
  80093e:	48 01 d0             	add    %rdx,%rax
  800941:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800945:	8b 12                	mov    (%rdx),%edx
  800947:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80094a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094e:	89 0a                	mov    %ecx,(%rdx)
  800950:	eb 17                	jmp    800969 <getint+0x102>
  800952:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800956:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80095a:	48 89 d0             	mov    %rdx,%rax
  80095d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800961:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800965:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800969:	8b 00                	mov    (%rax),%eax
  80096b:	48 98                	cltq   
  80096d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800971:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800975:	c9                   	leaveq 
  800976:	c3                   	retq   

0000000000800977 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800977:	55                   	push   %rbp
  800978:	48 89 e5             	mov    %rsp,%rbp
  80097b:	41 54                	push   %r12
  80097d:	53                   	push   %rbx
  80097e:	48 83 ec 60          	sub    $0x60,%rsp
  800982:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800986:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80098a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80098e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800992:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800996:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80099a:	48 8b 0a             	mov    (%rdx),%rcx
  80099d:	48 89 08             	mov    %rcx,(%rax)
  8009a0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009a4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009a8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009ac:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  8009b0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009b4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009b8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009bc:	0f b6 00             	movzbl (%rax),%eax
  8009bf:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  8009c2:	eb 29                	jmp    8009ed <vprintfmt+0x76>
			if (ch == '\0')
  8009c4:	85 db                	test   %ebx,%ebx
  8009c6:	0f 84 ad 06 00 00    	je     801079 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  8009cc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009d0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d4:	48 89 d6             	mov    %rdx,%rsi
  8009d7:	89 df                	mov    %ebx,%edi
  8009d9:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  8009db:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009df:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009e3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009e7:	0f b6 00             	movzbl (%rax),%eax
  8009ea:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  8009ed:	83 fb 25             	cmp    $0x25,%ebx
  8009f0:	74 05                	je     8009f7 <vprintfmt+0x80>
  8009f2:	83 fb 1b             	cmp    $0x1b,%ebx
  8009f5:	75 cd                	jne    8009c4 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  8009f7:	83 fb 1b             	cmp    $0x1b,%ebx
  8009fa:	0f 85 ae 01 00 00    	jne    800bae <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  800a00:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  800a07:	00 00 00 
  800a0a:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  800a10:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a18:	48 89 d6             	mov    %rdx,%rsi
  800a1b:	89 df                	mov    %ebx,%edi
  800a1d:	ff d0                	callq  *%rax
			putch('[', putdat);
  800a1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a27:	48 89 d6             	mov    %rdx,%rsi
  800a2a:	bf 5b 00 00 00       	mov    $0x5b,%edi
  800a2f:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800a31:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800a37:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a3c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a40:	0f b6 00             	movzbl (%rax),%eax
  800a43:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800a46:	eb 32                	jmp    800a7a <vprintfmt+0x103>
					putch(ch, putdat);
  800a48:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a50:	48 89 d6             	mov    %rdx,%rsi
  800a53:	89 df                	mov    %ebx,%edi
  800a55:	ff d0                	callq  *%rax
					esc_color *= 10;
  800a57:	44 89 e0             	mov    %r12d,%eax
  800a5a:	c1 e0 02             	shl    $0x2,%eax
  800a5d:	44 01 e0             	add    %r12d,%eax
  800a60:	01 c0                	add    %eax,%eax
  800a62:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800a65:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800a68:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800a6b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a70:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a74:	0f b6 00             	movzbl (%rax),%eax
  800a77:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800a7a:	83 fb 3b             	cmp    $0x3b,%ebx
  800a7d:	74 05                	je     800a84 <vprintfmt+0x10d>
  800a7f:	83 fb 6d             	cmp    $0x6d,%ebx
  800a82:	75 c4                	jne    800a48 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800a84:	45 85 e4             	test   %r12d,%r12d
  800a87:	75 15                	jne    800a9e <vprintfmt+0x127>
					color_flag = 0x07;
  800a89:	48 b8 10 50 80 00 00 	movabs $0x805010,%rax
  800a90:	00 00 00 
  800a93:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800a99:	e9 dc 00 00 00       	jmpq   800b7a <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800a9e:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800aa2:	7e 69                	jle    800b0d <vprintfmt+0x196>
  800aa4:	41 83 fc 25          	cmp    $0x25,%r12d
  800aa8:	7f 63                	jg     800b0d <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800aaa:	48 b8 10 50 80 00 00 	movabs $0x805010,%rax
  800ab1:	00 00 00 
  800ab4:	8b 00                	mov    (%rax),%eax
  800ab6:	25 f8 00 00 00       	and    $0xf8,%eax
  800abb:	89 c2                	mov    %eax,%edx
  800abd:	48 b8 10 50 80 00 00 	movabs $0x805010,%rax
  800ac4:	00 00 00 
  800ac7:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800ac9:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800acd:	44 89 e0             	mov    %r12d,%eax
  800ad0:	83 e0 04             	and    $0x4,%eax
  800ad3:	c1 f8 02             	sar    $0x2,%eax
  800ad6:	89 c2                	mov    %eax,%edx
  800ad8:	44 89 e0             	mov    %r12d,%eax
  800adb:	83 e0 02             	and    $0x2,%eax
  800ade:	09 c2                	or     %eax,%edx
  800ae0:	44 89 e0             	mov    %r12d,%eax
  800ae3:	83 e0 01             	and    $0x1,%eax
  800ae6:	c1 e0 02             	shl    $0x2,%eax
  800ae9:	09 c2                	or     %eax,%edx
  800aeb:	41 89 d4             	mov    %edx,%r12d
  800aee:	48 b8 10 50 80 00 00 	movabs $0x805010,%rax
  800af5:	00 00 00 
  800af8:	8b 00                	mov    (%rax),%eax
  800afa:	44 89 e2             	mov    %r12d,%edx
  800afd:	09 c2                	or     %eax,%edx
  800aff:	48 b8 10 50 80 00 00 	movabs $0x805010,%rax
  800b06:	00 00 00 
  800b09:	89 10                	mov    %edx,(%rax)
  800b0b:	eb 6d                	jmp    800b7a <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800b0d:	41 83 fc 27          	cmp    $0x27,%r12d
  800b11:	7e 67                	jle    800b7a <vprintfmt+0x203>
  800b13:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800b17:	7f 61                	jg     800b7a <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800b19:	48 b8 10 50 80 00 00 	movabs $0x805010,%rax
  800b20:	00 00 00 
  800b23:	8b 00                	mov    (%rax),%eax
  800b25:	25 8f 00 00 00       	and    $0x8f,%eax
  800b2a:	89 c2                	mov    %eax,%edx
  800b2c:	48 b8 10 50 80 00 00 	movabs $0x805010,%rax
  800b33:	00 00 00 
  800b36:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800b38:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800b3c:	44 89 e0             	mov    %r12d,%eax
  800b3f:	83 e0 04             	and    $0x4,%eax
  800b42:	c1 f8 02             	sar    $0x2,%eax
  800b45:	89 c2                	mov    %eax,%edx
  800b47:	44 89 e0             	mov    %r12d,%eax
  800b4a:	83 e0 02             	and    $0x2,%eax
  800b4d:	09 c2                	or     %eax,%edx
  800b4f:	44 89 e0             	mov    %r12d,%eax
  800b52:	83 e0 01             	and    $0x1,%eax
  800b55:	c1 e0 06             	shl    $0x6,%eax
  800b58:	09 c2                	or     %eax,%edx
  800b5a:	41 89 d4             	mov    %edx,%r12d
  800b5d:	48 b8 10 50 80 00 00 	movabs $0x805010,%rax
  800b64:	00 00 00 
  800b67:	8b 00                	mov    (%rax),%eax
  800b69:	44 89 e2             	mov    %r12d,%edx
  800b6c:	09 c2                	or     %eax,%edx
  800b6e:	48 b8 10 50 80 00 00 	movabs $0x805010,%rax
  800b75:	00 00 00 
  800b78:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800b7a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b7e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b82:	48 89 d6             	mov    %rdx,%rsi
  800b85:	89 df                	mov    %ebx,%edi
  800b87:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800b89:	83 fb 6d             	cmp    $0x6d,%ebx
  800b8c:	75 1b                	jne    800ba9 <vprintfmt+0x232>
					fmt ++;
  800b8e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800b93:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800b94:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  800b9b:	00 00 00 
  800b9e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800ba4:	e9 cb 04 00 00       	jmpq   801074 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800ba9:	e9 83 fe ff ff       	jmpq   800a31 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800bae:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800bb2:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800bb9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800bc0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800bc7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bce:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bd2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800bd6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bda:	0f b6 00             	movzbl (%rax),%eax
  800bdd:	0f b6 d8             	movzbl %al,%ebx
  800be0:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800be3:	83 f8 55             	cmp    $0x55,%eax
  800be6:	0f 87 5a 04 00 00    	ja     801046 <vprintfmt+0x6cf>
  800bec:	89 c0                	mov    %eax,%eax
  800bee:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bf5:	00 
  800bf6:	48 b8 10 3d 80 00 00 	movabs $0x803d10,%rax
  800bfd:	00 00 00 
  800c00:	48 01 d0             	add    %rdx,%rax
  800c03:	48 8b 00             	mov    (%rax),%rax
  800c06:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c08:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c0c:	eb c0                	jmp    800bce <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c0e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c12:	eb ba                	jmp    800bce <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c14:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c1b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c1e:	89 d0                	mov    %edx,%eax
  800c20:	c1 e0 02             	shl    $0x2,%eax
  800c23:	01 d0                	add    %edx,%eax
  800c25:	01 c0                	add    %eax,%eax
  800c27:	01 d8                	add    %ebx,%eax
  800c29:	83 e8 30             	sub    $0x30,%eax
  800c2c:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c2f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c33:	0f b6 00             	movzbl (%rax),%eax
  800c36:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c39:	83 fb 2f             	cmp    $0x2f,%ebx
  800c3c:	7e 0c                	jle    800c4a <vprintfmt+0x2d3>
  800c3e:	83 fb 39             	cmp    $0x39,%ebx
  800c41:	7f 07                	jg     800c4a <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c43:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c48:	eb d1                	jmp    800c1b <vprintfmt+0x2a4>
			goto process_precision;
  800c4a:	eb 58                	jmp    800ca4 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800c4c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c4f:	83 f8 30             	cmp    $0x30,%eax
  800c52:	73 17                	jae    800c6b <vprintfmt+0x2f4>
  800c54:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c58:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c5b:	89 c0                	mov    %eax,%eax
  800c5d:	48 01 d0             	add    %rdx,%rax
  800c60:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c63:	83 c2 08             	add    $0x8,%edx
  800c66:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c69:	eb 0f                	jmp    800c7a <vprintfmt+0x303>
  800c6b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c6f:	48 89 d0             	mov    %rdx,%rax
  800c72:	48 83 c2 08          	add    $0x8,%rdx
  800c76:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c7a:	8b 00                	mov    (%rax),%eax
  800c7c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c7f:	eb 23                	jmp    800ca4 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800c81:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c85:	79 0c                	jns    800c93 <vprintfmt+0x31c>
				width = 0;
  800c87:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c8e:	e9 3b ff ff ff       	jmpq   800bce <vprintfmt+0x257>
  800c93:	e9 36 ff ff ff       	jmpq   800bce <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800c98:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c9f:	e9 2a ff ff ff       	jmpq   800bce <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800ca4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ca8:	79 12                	jns    800cbc <vprintfmt+0x345>
				width = precision, precision = -1;
  800caa:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cad:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800cb0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800cb7:	e9 12 ff ff ff       	jmpq   800bce <vprintfmt+0x257>
  800cbc:	e9 0d ff ff ff       	jmpq   800bce <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cc1:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800cc5:	e9 04 ff ff ff       	jmpq   800bce <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800cca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ccd:	83 f8 30             	cmp    $0x30,%eax
  800cd0:	73 17                	jae    800ce9 <vprintfmt+0x372>
  800cd2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cd6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd9:	89 c0                	mov    %eax,%eax
  800cdb:	48 01 d0             	add    %rdx,%rax
  800cde:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ce1:	83 c2 08             	add    $0x8,%edx
  800ce4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ce7:	eb 0f                	jmp    800cf8 <vprintfmt+0x381>
  800ce9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ced:	48 89 d0             	mov    %rdx,%rax
  800cf0:	48 83 c2 08          	add    $0x8,%rdx
  800cf4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cf8:	8b 10                	mov    (%rax),%edx
  800cfa:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cfe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d02:	48 89 ce             	mov    %rcx,%rsi
  800d05:	89 d7                	mov    %edx,%edi
  800d07:	ff d0                	callq  *%rax
			break;
  800d09:	e9 66 03 00 00       	jmpq   801074 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800d0e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d11:	83 f8 30             	cmp    $0x30,%eax
  800d14:	73 17                	jae    800d2d <vprintfmt+0x3b6>
  800d16:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d1a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d1d:	89 c0                	mov    %eax,%eax
  800d1f:	48 01 d0             	add    %rdx,%rax
  800d22:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d25:	83 c2 08             	add    $0x8,%edx
  800d28:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d2b:	eb 0f                	jmp    800d3c <vprintfmt+0x3c5>
  800d2d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d31:	48 89 d0             	mov    %rdx,%rax
  800d34:	48 83 c2 08          	add    $0x8,%rdx
  800d38:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d3c:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d3e:	85 db                	test   %ebx,%ebx
  800d40:	79 02                	jns    800d44 <vprintfmt+0x3cd>
				err = -err;
  800d42:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d44:	83 fb 10             	cmp    $0x10,%ebx
  800d47:	7f 16                	jg     800d5f <vprintfmt+0x3e8>
  800d49:	48 b8 60 3c 80 00 00 	movabs $0x803c60,%rax
  800d50:	00 00 00 
  800d53:	48 63 d3             	movslq %ebx,%rdx
  800d56:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d5a:	4d 85 e4             	test   %r12,%r12
  800d5d:	75 2e                	jne    800d8d <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800d5f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d63:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d67:	89 d9                	mov    %ebx,%ecx
  800d69:	48 ba f9 3c 80 00 00 	movabs $0x803cf9,%rdx
  800d70:	00 00 00 
  800d73:	48 89 c7             	mov    %rax,%rdi
  800d76:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7b:	49 b8 82 10 80 00 00 	movabs $0x801082,%r8
  800d82:	00 00 00 
  800d85:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d88:	e9 e7 02 00 00       	jmpq   801074 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d8d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d91:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d95:	4c 89 e1             	mov    %r12,%rcx
  800d98:	48 ba 02 3d 80 00 00 	movabs $0x803d02,%rdx
  800d9f:	00 00 00 
  800da2:	48 89 c7             	mov    %rax,%rdi
  800da5:	b8 00 00 00 00       	mov    $0x0,%eax
  800daa:	49 b8 82 10 80 00 00 	movabs $0x801082,%r8
  800db1:	00 00 00 
  800db4:	41 ff d0             	callq  *%r8
			break;
  800db7:	e9 b8 02 00 00       	jmpq   801074 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800dbc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dbf:	83 f8 30             	cmp    $0x30,%eax
  800dc2:	73 17                	jae    800ddb <vprintfmt+0x464>
  800dc4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800dc8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dcb:	89 c0                	mov    %eax,%eax
  800dcd:	48 01 d0             	add    %rdx,%rax
  800dd0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dd3:	83 c2 08             	add    $0x8,%edx
  800dd6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800dd9:	eb 0f                	jmp    800dea <vprintfmt+0x473>
  800ddb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ddf:	48 89 d0             	mov    %rdx,%rax
  800de2:	48 83 c2 08          	add    $0x8,%rdx
  800de6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dea:	4c 8b 20             	mov    (%rax),%r12
  800ded:	4d 85 e4             	test   %r12,%r12
  800df0:	75 0a                	jne    800dfc <vprintfmt+0x485>
				p = "(null)";
  800df2:	49 bc 05 3d 80 00 00 	movabs $0x803d05,%r12
  800df9:	00 00 00 
			if (width > 0 && padc != '-')
  800dfc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e00:	7e 3f                	jle    800e41 <vprintfmt+0x4ca>
  800e02:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e06:	74 39                	je     800e41 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e08:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e0b:	48 98                	cltq   
  800e0d:	48 89 c6             	mov    %rax,%rsi
  800e10:	4c 89 e7             	mov    %r12,%rdi
  800e13:	48 b8 2e 13 80 00 00 	movabs $0x80132e,%rax
  800e1a:	00 00 00 
  800e1d:	ff d0                	callq  *%rax
  800e1f:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e22:	eb 17                	jmp    800e3b <vprintfmt+0x4c4>
					putch(padc, putdat);
  800e24:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e28:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e30:	48 89 ce             	mov    %rcx,%rsi
  800e33:	89 d7                	mov    %edx,%edi
  800e35:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e37:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e3b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e3f:	7f e3                	jg     800e24 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e41:	eb 37                	jmp    800e7a <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800e43:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e47:	74 1e                	je     800e67 <vprintfmt+0x4f0>
  800e49:	83 fb 1f             	cmp    $0x1f,%ebx
  800e4c:	7e 05                	jle    800e53 <vprintfmt+0x4dc>
  800e4e:	83 fb 7e             	cmp    $0x7e,%ebx
  800e51:	7e 14                	jle    800e67 <vprintfmt+0x4f0>
					putch('?', putdat);
  800e53:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5b:	48 89 d6             	mov    %rdx,%rsi
  800e5e:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e63:	ff d0                	callq  *%rax
  800e65:	eb 0f                	jmp    800e76 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800e67:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e6f:	48 89 d6             	mov    %rdx,%rsi
  800e72:	89 df                	mov    %ebx,%edi
  800e74:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e76:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e7a:	4c 89 e0             	mov    %r12,%rax
  800e7d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e81:	0f b6 00             	movzbl (%rax),%eax
  800e84:	0f be d8             	movsbl %al,%ebx
  800e87:	85 db                	test   %ebx,%ebx
  800e89:	74 10                	je     800e9b <vprintfmt+0x524>
  800e8b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e8f:	78 b2                	js     800e43 <vprintfmt+0x4cc>
  800e91:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e95:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e99:	79 a8                	jns    800e43 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e9b:	eb 16                	jmp    800eb3 <vprintfmt+0x53c>
				putch(' ', putdat);
  800e9d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea5:	48 89 d6             	mov    %rdx,%rsi
  800ea8:	bf 20 00 00 00       	mov    $0x20,%edi
  800ead:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eaf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800eb3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800eb7:	7f e4                	jg     800e9d <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800eb9:	e9 b6 01 00 00       	jmpq   801074 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ebe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ec2:	be 03 00 00 00       	mov    $0x3,%esi
  800ec7:	48 89 c7             	mov    %rax,%rdi
  800eca:	48 b8 67 08 80 00 00 	movabs $0x800867,%rax
  800ed1:	00 00 00 
  800ed4:	ff d0                	callq  *%rax
  800ed6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800eda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ede:	48 85 c0             	test   %rax,%rax
  800ee1:	79 1d                	jns    800f00 <vprintfmt+0x589>
				putch('-', putdat);
  800ee3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eeb:	48 89 d6             	mov    %rdx,%rsi
  800eee:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ef3:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ef5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef9:	48 f7 d8             	neg    %rax
  800efc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f00:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f07:	e9 fb 00 00 00       	jmpq   801007 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f0c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f10:	be 03 00 00 00       	mov    $0x3,%esi
  800f15:	48 89 c7             	mov    %rax,%rdi
  800f18:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
  800f1f:	00 00 00 
  800f22:	ff d0                	callq  *%rax
  800f24:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f28:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f2f:	e9 d3 00 00 00       	jmpq   801007 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800f34:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f38:	be 03 00 00 00       	mov    $0x3,%esi
  800f3d:	48 89 c7             	mov    %rax,%rdi
  800f40:	48 b8 67 08 80 00 00 	movabs $0x800867,%rax
  800f47:	00 00 00 
  800f4a:	ff d0                	callq  *%rax
  800f4c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f54:	48 85 c0             	test   %rax,%rax
  800f57:	79 1d                	jns    800f76 <vprintfmt+0x5ff>
				putch('-', putdat);
  800f59:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f61:	48 89 d6             	mov    %rdx,%rsi
  800f64:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f69:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6f:	48 f7 d8             	neg    %rax
  800f72:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800f76:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f7d:	e9 85 00 00 00       	jmpq   801007 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800f82:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f86:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f8a:	48 89 d6             	mov    %rdx,%rsi
  800f8d:	bf 30 00 00 00       	mov    $0x30,%edi
  800f92:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f94:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f98:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f9c:	48 89 d6             	mov    %rdx,%rsi
  800f9f:	bf 78 00 00 00       	mov    $0x78,%edi
  800fa4:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800fa6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fa9:	83 f8 30             	cmp    $0x30,%eax
  800fac:	73 17                	jae    800fc5 <vprintfmt+0x64e>
  800fae:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800fb2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fb5:	89 c0                	mov    %eax,%eax
  800fb7:	48 01 d0             	add    %rdx,%rax
  800fba:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fbd:	83 c2 08             	add    $0x8,%edx
  800fc0:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fc3:	eb 0f                	jmp    800fd4 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800fc5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800fc9:	48 89 d0             	mov    %rdx,%rax
  800fcc:	48 83 c2 08          	add    $0x8,%rdx
  800fd0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800fd4:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fd7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800fdb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800fe2:	eb 23                	jmp    801007 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800fe4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fe8:	be 03 00 00 00       	mov    $0x3,%esi
  800fed:	48 89 c7             	mov    %rax,%rdi
  800ff0:	48 b8 57 07 80 00 00 	movabs $0x800757,%rax
  800ff7:	00 00 00 
  800ffa:	ff d0                	callq  *%rax
  800ffc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801000:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801007:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80100c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80100f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801012:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801016:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80101a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80101e:	45 89 c1             	mov    %r8d,%r9d
  801021:	41 89 f8             	mov    %edi,%r8d
  801024:	48 89 c7             	mov    %rax,%rdi
  801027:	48 b8 9c 06 80 00 00 	movabs $0x80069c,%rax
  80102e:	00 00 00 
  801031:	ff d0                	callq  *%rax
			break;
  801033:	eb 3f                	jmp    801074 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801035:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801039:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80103d:	48 89 d6             	mov    %rdx,%rsi
  801040:	89 df                	mov    %ebx,%edi
  801042:	ff d0                	callq  *%rax
			break;
  801044:	eb 2e                	jmp    801074 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801046:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80104a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80104e:	48 89 d6             	mov    %rdx,%rsi
  801051:	bf 25 00 00 00       	mov    $0x25,%edi
  801056:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801058:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80105d:	eb 05                	jmp    801064 <vprintfmt+0x6ed>
  80105f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801064:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801068:	48 83 e8 01          	sub    $0x1,%rax
  80106c:	0f b6 00             	movzbl (%rax),%eax
  80106f:	3c 25                	cmp    $0x25,%al
  801071:	75 ec                	jne    80105f <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  801073:	90                   	nop
		}
	}
  801074:	e9 37 f9 ff ff       	jmpq   8009b0 <vprintfmt+0x39>
    va_end(aq);
}
  801079:	48 83 c4 60          	add    $0x60,%rsp
  80107d:	5b                   	pop    %rbx
  80107e:	41 5c                	pop    %r12
  801080:	5d                   	pop    %rbp
  801081:	c3                   	retq   

0000000000801082 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801082:	55                   	push   %rbp
  801083:	48 89 e5             	mov    %rsp,%rbp
  801086:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80108d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801094:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80109b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010a2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010a9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010b0:	84 c0                	test   %al,%al
  8010b2:	74 20                	je     8010d4 <printfmt+0x52>
  8010b4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010b8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010bc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010c0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010c4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010c8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010cc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010d0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010d4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8010db:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8010e2:	00 00 00 
  8010e5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8010ec:	00 00 00 
  8010ef:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010f3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8010fa:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801101:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801108:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80110f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801116:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80111d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801124:	48 89 c7             	mov    %rax,%rdi
  801127:	48 b8 77 09 80 00 00 	movabs $0x800977,%rax
  80112e:	00 00 00 
  801131:	ff d0                	callq  *%rax
	va_end(ap);
}
  801133:	c9                   	leaveq 
  801134:	c3                   	retq   

0000000000801135 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801135:	55                   	push   %rbp
  801136:	48 89 e5             	mov    %rsp,%rbp
  801139:	48 83 ec 10          	sub    $0x10,%rsp
  80113d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801140:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801144:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801148:	8b 40 10             	mov    0x10(%rax),%eax
  80114b:	8d 50 01             	lea    0x1(%rax),%edx
  80114e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801152:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801155:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801159:	48 8b 10             	mov    (%rax),%rdx
  80115c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801160:	48 8b 40 08          	mov    0x8(%rax),%rax
  801164:	48 39 c2             	cmp    %rax,%rdx
  801167:	73 17                	jae    801180 <sprintputch+0x4b>
		*b->buf++ = ch;
  801169:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80116d:	48 8b 00             	mov    (%rax),%rax
  801170:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801174:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801178:	48 89 0a             	mov    %rcx,(%rdx)
  80117b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80117e:	88 10                	mov    %dl,(%rax)
}
  801180:	c9                   	leaveq 
  801181:	c3                   	retq   

0000000000801182 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801182:	55                   	push   %rbp
  801183:	48 89 e5             	mov    %rsp,%rbp
  801186:	48 83 ec 50          	sub    $0x50,%rsp
  80118a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80118e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801191:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801195:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801199:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80119d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8011a1:	48 8b 0a             	mov    (%rdx),%rcx
  8011a4:	48 89 08             	mov    %rcx,(%rax)
  8011a7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011ab:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011af:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011b3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011b7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011bb:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8011bf:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8011c2:	48 98                	cltq   
  8011c4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011c8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011cc:	48 01 d0             	add    %rdx,%rax
  8011cf:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8011d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8011da:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8011df:	74 06                	je     8011e7 <vsnprintf+0x65>
  8011e1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8011e5:	7f 07                	jg     8011ee <vsnprintf+0x6c>
		return -E_INVAL;
  8011e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ec:	eb 2f                	jmp    80121d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8011ee:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8011f2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8011f6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8011fa:	48 89 c6             	mov    %rax,%rsi
  8011fd:	48 bf 35 11 80 00 00 	movabs $0x801135,%rdi
  801204:	00 00 00 
  801207:	48 b8 77 09 80 00 00 	movabs $0x800977,%rax
  80120e:	00 00 00 
  801211:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801213:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801217:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80121a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80121d:	c9                   	leaveq 
  80121e:	c3                   	retq   

000000000080121f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80121f:	55                   	push   %rbp
  801220:	48 89 e5             	mov    %rsp,%rbp
  801223:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80122a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801231:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801237:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80123e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801245:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80124c:	84 c0                	test   %al,%al
  80124e:	74 20                	je     801270 <snprintf+0x51>
  801250:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801254:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801258:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80125c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801260:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801264:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801268:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80126c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801270:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801277:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80127e:	00 00 00 
  801281:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801288:	00 00 00 
  80128b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80128f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801296:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80129d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8012a4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8012ab:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8012b2:	48 8b 0a             	mov    (%rdx),%rcx
  8012b5:	48 89 08             	mov    %rcx,(%rax)
  8012b8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8012bc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8012c0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8012c4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8012c8:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8012cf:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8012d6:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8012dc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8012e3:	48 89 c7             	mov    %rax,%rdi
  8012e6:	48 b8 82 11 80 00 00 	movabs $0x801182,%rax
  8012ed:	00 00 00 
  8012f0:	ff d0                	callq  *%rax
  8012f2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8012f8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8012fe:	c9                   	leaveq 
  8012ff:	c3                   	retq   

0000000000801300 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801300:	55                   	push   %rbp
  801301:	48 89 e5             	mov    %rsp,%rbp
  801304:	48 83 ec 18          	sub    $0x18,%rsp
  801308:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80130c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801313:	eb 09                	jmp    80131e <strlen+0x1e>
		n++;
  801315:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801319:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80131e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801322:	0f b6 00             	movzbl (%rax),%eax
  801325:	84 c0                	test   %al,%al
  801327:	75 ec                	jne    801315 <strlen+0x15>
		n++;
	return n;
  801329:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80132c:	c9                   	leaveq 
  80132d:	c3                   	retq   

000000000080132e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80132e:	55                   	push   %rbp
  80132f:	48 89 e5             	mov    %rsp,%rbp
  801332:	48 83 ec 20          	sub    $0x20,%rsp
  801336:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80133a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80133e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801345:	eb 0e                	jmp    801355 <strnlen+0x27>
		n++;
  801347:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80134b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801350:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801355:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80135a:	74 0b                	je     801367 <strnlen+0x39>
  80135c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801360:	0f b6 00             	movzbl (%rax),%eax
  801363:	84 c0                	test   %al,%al
  801365:	75 e0                	jne    801347 <strnlen+0x19>
		n++;
	return n;
  801367:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80136a:	c9                   	leaveq 
  80136b:	c3                   	retq   

000000000080136c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80136c:	55                   	push   %rbp
  80136d:	48 89 e5             	mov    %rsp,%rbp
  801370:	48 83 ec 20          	sub    $0x20,%rsp
  801374:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801378:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80137c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801380:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801384:	90                   	nop
  801385:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801389:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80138d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801391:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801395:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801399:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80139d:	0f b6 12             	movzbl (%rdx),%edx
  8013a0:	88 10                	mov    %dl,(%rax)
  8013a2:	0f b6 00             	movzbl (%rax),%eax
  8013a5:	84 c0                	test   %al,%al
  8013a7:	75 dc                	jne    801385 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8013a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013ad:	c9                   	leaveq 
  8013ae:	c3                   	retq   

00000000008013af <strcat>:

char *
strcat(char *dst, const char *src)
{
  8013af:	55                   	push   %rbp
  8013b0:	48 89 e5             	mov    %rsp,%rbp
  8013b3:	48 83 ec 20          	sub    $0x20,%rsp
  8013b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8013bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c3:	48 89 c7             	mov    %rax,%rdi
  8013c6:	48 b8 00 13 80 00 00 	movabs $0x801300,%rax
  8013cd:	00 00 00 
  8013d0:	ff d0                	callq  *%rax
  8013d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8013d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013d8:	48 63 d0             	movslq %eax,%rdx
  8013db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013df:	48 01 c2             	add    %rax,%rdx
  8013e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013e6:	48 89 c6             	mov    %rax,%rsi
  8013e9:	48 89 d7             	mov    %rdx,%rdi
  8013ec:	48 b8 6c 13 80 00 00 	movabs $0x80136c,%rax
  8013f3:	00 00 00 
  8013f6:	ff d0                	callq  *%rax
	return dst;
  8013f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013fc:	c9                   	leaveq 
  8013fd:	c3                   	retq   

00000000008013fe <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8013fe:	55                   	push   %rbp
  8013ff:	48 89 e5             	mov    %rsp,%rbp
  801402:	48 83 ec 28          	sub    $0x28,%rsp
  801406:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80140a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80140e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801412:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801416:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80141a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801421:	00 
  801422:	eb 2a                	jmp    80144e <strncpy+0x50>
		*dst++ = *src;
  801424:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801428:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80142c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801430:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801434:	0f b6 12             	movzbl (%rdx),%edx
  801437:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801439:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80143d:	0f b6 00             	movzbl (%rax),%eax
  801440:	84 c0                	test   %al,%al
  801442:	74 05                	je     801449 <strncpy+0x4b>
			src++;
  801444:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801449:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80144e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801452:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801456:	72 cc                	jb     801424 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801458:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80145c:	c9                   	leaveq 
  80145d:	c3                   	retq   

000000000080145e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80145e:	55                   	push   %rbp
  80145f:	48 89 e5             	mov    %rsp,%rbp
  801462:	48 83 ec 28          	sub    $0x28,%rsp
  801466:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80146a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80146e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801476:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80147a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80147f:	74 3d                	je     8014be <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801481:	eb 1d                	jmp    8014a0 <strlcpy+0x42>
			*dst++ = *src++;
  801483:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801487:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80148b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80148f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801493:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801497:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80149b:	0f b6 12             	movzbl (%rdx),%edx
  80149e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014a0:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8014a5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014aa:	74 0b                	je     8014b7 <strlcpy+0x59>
  8014ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b0:	0f b6 00             	movzbl (%rax),%eax
  8014b3:	84 c0                	test   %al,%al
  8014b5:	75 cc                	jne    801483 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8014b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014bb:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8014be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c6:	48 29 c2             	sub    %rax,%rdx
  8014c9:	48 89 d0             	mov    %rdx,%rax
}
  8014cc:	c9                   	leaveq 
  8014cd:	c3                   	retq   

00000000008014ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014ce:	55                   	push   %rbp
  8014cf:	48 89 e5             	mov    %rsp,%rbp
  8014d2:	48 83 ec 10          	sub    $0x10,%rsp
  8014d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8014de:	eb 0a                	jmp    8014ea <strcmp+0x1c>
		p++, q++;
  8014e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014e5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ee:	0f b6 00             	movzbl (%rax),%eax
  8014f1:	84 c0                	test   %al,%al
  8014f3:	74 12                	je     801507 <strcmp+0x39>
  8014f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f9:	0f b6 10             	movzbl (%rax),%edx
  8014fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801500:	0f b6 00             	movzbl (%rax),%eax
  801503:	38 c2                	cmp    %al,%dl
  801505:	74 d9                	je     8014e0 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801507:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150b:	0f b6 00             	movzbl (%rax),%eax
  80150e:	0f b6 d0             	movzbl %al,%edx
  801511:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801515:	0f b6 00             	movzbl (%rax),%eax
  801518:	0f b6 c0             	movzbl %al,%eax
  80151b:	29 c2                	sub    %eax,%edx
  80151d:	89 d0                	mov    %edx,%eax
}
  80151f:	c9                   	leaveq 
  801520:	c3                   	retq   

0000000000801521 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801521:	55                   	push   %rbp
  801522:	48 89 e5             	mov    %rsp,%rbp
  801525:	48 83 ec 18          	sub    $0x18,%rsp
  801529:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80152d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801531:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801535:	eb 0f                	jmp    801546 <strncmp+0x25>
		n--, p++, q++;
  801537:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80153c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801541:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801546:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80154b:	74 1d                	je     80156a <strncmp+0x49>
  80154d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801551:	0f b6 00             	movzbl (%rax),%eax
  801554:	84 c0                	test   %al,%al
  801556:	74 12                	je     80156a <strncmp+0x49>
  801558:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155c:	0f b6 10             	movzbl (%rax),%edx
  80155f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801563:	0f b6 00             	movzbl (%rax),%eax
  801566:	38 c2                	cmp    %al,%dl
  801568:	74 cd                	je     801537 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80156a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80156f:	75 07                	jne    801578 <strncmp+0x57>
		return 0;
  801571:	b8 00 00 00 00       	mov    $0x0,%eax
  801576:	eb 18                	jmp    801590 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801578:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157c:	0f b6 00             	movzbl (%rax),%eax
  80157f:	0f b6 d0             	movzbl %al,%edx
  801582:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801586:	0f b6 00             	movzbl (%rax),%eax
  801589:	0f b6 c0             	movzbl %al,%eax
  80158c:	29 c2                	sub    %eax,%edx
  80158e:	89 d0                	mov    %edx,%eax
}
  801590:	c9                   	leaveq 
  801591:	c3                   	retq   

0000000000801592 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801592:	55                   	push   %rbp
  801593:	48 89 e5             	mov    %rsp,%rbp
  801596:	48 83 ec 0c          	sub    $0xc,%rsp
  80159a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80159e:	89 f0                	mov    %esi,%eax
  8015a0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015a3:	eb 17                	jmp    8015bc <strchr+0x2a>
		if (*s == c)
  8015a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a9:	0f b6 00             	movzbl (%rax),%eax
  8015ac:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015af:	75 06                	jne    8015b7 <strchr+0x25>
			return (char *) s;
  8015b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b5:	eb 15                	jmp    8015cc <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c0:	0f b6 00             	movzbl (%rax),%eax
  8015c3:	84 c0                	test   %al,%al
  8015c5:	75 de                	jne    8015a5 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8015c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015cc:	c9                   	leaveq 
  8015cd:	c3                   	retq   

00000000008015ce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015ce:	55                   	push   %rbp
  8015cf:	48 89 e5             	mov    %rsp,%rbp
  8015d2:	48 83 ec 0c          	sub    $0xc,%rsp
  8015d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015da:	89 f0                	mov    %esi,%eax
  8015dc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015df:	eb 13                	jmp    8015f4 <strfind+0x26>
		if (*s == c)
  8015e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e5:	0f b6 00             	movzbl (%rax),%eax
  8015e8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015eb:	75 02                	jne    8015ef <strfind+0x21>
			break;
  8015ed:	eb 10                	jmp    8015ff <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f8:	0f b6 00             	movzbl (%rax),%eax
  8015fb:	84 c0                	test   %al,%al
  8015fd:	75 e2                	jne    8015e1 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8015ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801603:	c9                   	leaveq 
  801604:	c3                   	retq   

0000000000801605 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801605:	55                   	push   %rbp
  801606:	48 89 e5             	mov    %rsp,%rbp
  801609:	48 83 ec 18          	sub    $0x18,%rsp
  80160d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801611:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801614:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801618:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80161d:	75 06                	jne    801625 <memset+0x20>
		return v;
  80161f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801623:	eb 69                	jmp    80168e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801625:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801629:	83 e0 03             	and    $0x3,%eax
  80162c:	48 85 c0             	test   %rax,%rax
  80162f:	75 48                	jne    801679 <memset+0x74>
  801631:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801635:	83 e0 03             	and    $0x3,%eax
  801638:	48 85 c0             	test   %rax,%rax
  80163b:	75 3c                	jne    801679 <memset+0x74>
		c &= 0xFF;
  80163d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801644:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801647:	c1 e0 18             	shl    $0x18,%eax
  80164a:	89 c2                	mov    %eax,%edx
  80164c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80164f:	c1 e0 10             	shl    $0x10,%eax
  801652:	09 c2                	or     %eax,%edx
  801654:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801657:	c1 e0 08             	shl    $0x8,%eax
  80165a:	09 d0                	or     %edx,%eax
  80165c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80165f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801663:	48 c1 e8 02          	shr    $0x2,%rax
  801667:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80166a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80166e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801671:	48 89 d7             	mov    %rdx,%rdi
  801674:	fc                   	cld    
  801675:	f3 ab                	rep stos %eax,%es:(%rdi)
  801677:	eb 11                	jmp    80168a <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801679:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80167d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801680:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801684:	48 89 d7             	mov    %rdx,%rdi
  801687:	fc                   	cld    
  801688:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80168a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80168e:	c9                   	leaveq 
  80168f:	c3                   	retq   

0000000000801690 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801690:	55                   	push   %rbp
  801691:	48 89 e5             	mov    %rsp,%rbp
  801694:	48 83 ec 28          	sub    $0x28,%rsp
  801698:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80169c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8016a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8016ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8016b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016bc:	0f 83 88 00 00 00    	jae    80174a <memmove+0xba>
  8016c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016ca:	48 01 d0             	add    %rdx,%rax
  8016cd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016d1:	76 77                	jbe    80174a <memmove+0xba>
		s += n;
  8016d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8016db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016df:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e7:	83 e0 03             	and    $0x3,%eax
  8016ea:	48 85 c0             	test   %rax,%rax
  8016ed:	75 3b                	jne    80172a <memmove+0x9a>
  8016ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f3:	83 e0 03             	and    $0x3,%eax
  8016f6:	48 85 c0             	test   %rax,%rax
  8016f9:	75 2f                	jne    80172a <memmove+0x9a>
  8016fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ff:	83 e0 03             	and    $0x3,%eax
  801702:	48 85 c0             	test   %rax,%rax
  801705:	75 23                	jne    80172a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801707:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80170b:	48 83 e8 04          	sub    $0x4,%rax
  80170f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801713:	48 83 ea 04          	sub    $0x4,%rdx
  801717:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80171b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80171f:	48 89 c7             	mov    %rax,%rdi
  801722:	48 89 d6             	mov    %rdx,%rsi
  801725:	fd                   	std    
  801726:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801728:	eb 1d                	jmp    801747 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80172a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801732:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801736:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80173a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173e:	48 89 d7             	mov    %rdx,%rdi
  801741:	48 89 c1             	mov    %rax,%rcx
  801744:	fd                   	std    
  801745:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801747:	fc                   	cld    
  801748:	eb 57                	jmp    8017a1 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80174a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80174e:	83 e0 03             	and    $0x3,%eax
  801751:	48 85 c0             	test   %rax,%rax
  801754:	75 36                	jne    80178c <memmove+0xfc>
  801756:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80175a:	83 e0 03             	and    $0x3,%eax
  80175d:	48 85 c0             	test   %rax,%rax
  801760:	75 2a                	jne    80178c <memmove+0xfc>
  801762:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801766:	83 e0 03             	and    $0x3,%eax
  801769:	48 85 c0             	test   %rax,%rax
  80176c:	75 1e                	jne    80178c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80176e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801772:	48 c1 e8 02          	shr    $0x2,%rax
  801776:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801779:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801781:	48 89 c7             	mov    %rax,%rdi
  801784:	48 89 d6             	mov    %rdx,%rsi
  801787:	fc                   	cld    
  801788:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80178a:	eb 15                	jmp    8017a1 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80178c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801790:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801794:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801798:	48 89 c7             	mov    %rax,%rdi
  80179b:	48 89 d6             	mov    %rdx,%rsi
  80179e:	fc                   	cld    
  80179f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8017a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017a5:	c9                   	leaveq 
  8017a6:	c3                   	retq   

00000000008017a7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8017a7:	55                   	push   %rbp
  8017a8:	48 89 e5             	mov    %rsp,%rbp
  8017ab:	48 83 ec 18          	sub    $0x18,%rsp
  8017af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8017bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017bf:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8017c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017c7:	48 89 ce             	mov    %rcx,%rsi
  8017ca:	48 89 c7             	mov    %rax,%rdi
  8017cd:	48 b8 90 16 80 00 00 	movabs $0x801690,%rax
  8017d4:	00 00 00 
  8017d7:	ff d0                	callq  *%rax
}
  8017d9:	c9                   	leaveq 
  8017da:	c3                   	retq   

00000000008017db <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8017db:	55                   	push   %rbp
  8017dc:	48 89 e5             	mov    %rsp,%rbp
  8017df:	48 83 ec 28          	sub    $0x28,%rsp
  8017e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8017ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8017f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8017ff:	eb 36                	jmp    801837 <memcmp+0x5c>
		if (*s1 != *s2)
  801801:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801805:	0f b6 10             	movzbl (%rax),%edx
  801808:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80180c:	0f b6 00             	movzbl (%rax),%eax
  80180f:	38 c2                	cmp    %al,%dl
  801811:	74 1a                	je     80182d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801813:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801817:	0f b6 00             	movzbl (%rax),%eax
  80181a:	0f b6 d0             	movzbl %al,%edx
  80181d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801821:	0f b6 00             	movzbl (%rax),%eax
  801824:	0f b6 c0             	movzbl %al,%eax
  801827:	29 c2                	sub    %eax,%edx
  801829:	89 d0                	mov    %edx,%eax
  80182b:	eb 20                	jmp    80184d <memcmp+0x72>
		s1++, s2++;
  80182d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801832:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801837:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80183f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801843:	48 85 c0             	test   %rax,%rax
  801846:	75 b9                	jne    801801 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801848:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184d:	c9                   	leaveq 
  80184e:	c3                   	retq   

000000000080184f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80184f:	55                   	push   %rbp
  801850:	48 89 e5             	mov    %rsp,%rbp
  801853:	48 83 ec 28          	sub    $0x28,%rsp
  801857:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80185b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80185e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801862:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801866:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80186a:	48 01 d0             	add    %rdx,%rax
  80186d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801871:	eb 15                	jmp    801888 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801873:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801877:	0f b6 10             	movzbl (%rax),%edx
  80187a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80187d:	38 c2                	cmp    %al,%dl
  80187f:	75 02                	jne    801883 <memfind+0x34>
			break;
  801881:	eb 0f                	jmp    801892 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801883:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801888:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80188c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801890:	72 e1                	jb     801873 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801892:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801896:	c9                   	leaveq 
  801897:	c3                   	retq   

0000000000801898 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801898:	55                   	push   %rbp
  801899:	48 89 e5             	mov    %rsp,%rbp
  80189c:	48 83 ec 34          	sub    $0x34,%rsp
  8018a0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018a4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018a8:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8018ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8018b2:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8018b9:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018ba:	eb 05                	jmp    8018c1 <strtol+0x29>
		s++;
  8018bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c5:	0f b6 00             	movzbl (%rax),%eax
  8018c8:	3c 20                	cmp    $0x20,%al
  8018ca:	74 f0                	je     8018bc <strtol+0x24>
  8018cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d0:	0f b6 00             	movzbl (%rax),%eax
  8018d3:	3c 09                	cmp    $0x9,%al
  8018d5:	74 e5                	je     8018bc <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018db:	0f b6 00             	movzbl (%rax),%eax
  8018de:	3c 2b                	cmp    $0x2b,%al
  8018e0:	75 07                	jne    8018e9 <strtol+0x51>
		s++;
  8018e2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018e7:	eb 17                	jmp    801900 <strtol+0x68>
	else if (*s == '-')
  8018e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ed:	0f b6 00             	movzbl (%rax),%eax
  8018f0:	3c 2d                	cmp    $0x2d,%al
  8018f2:	75 0c                	jne    801900 <strtol+0x68>
		s++, neg = 1;
  8018f4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801900:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801904:	74 06                	je     80190c <strtol+0x74>
  801906:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80190a:	75 28                	jne    801934 <strtol+0x9c>
  80190c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801910:	0f b6 00             	movzbl (%rax),%eax
  801913:	3c 30                	cmp    $0x30,%al
  801915:	75 1d                	jne    801934 <strtol+0x9c>
  801917:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191b:	48 83 c0 01          	add    $0x1,%rax
  80191f:	0f b6 00             	movzbl (%rax),%eax
  801922:	3c 78                	cmp    $0x78,%al
  801924:	75 0e                	jne    801934 <strtol+0x9c>
		s += 2, base = 16;
  801926:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80192b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801932:	eb 2c                	jmp    801960 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801934:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801938:	75 19                	jne    801953 <strtol+0xbb>
  80193a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193e:	0f b6 00             	movzbl (%rax),%eax
  801941:	3c 30                	cmp    $0x30,%al
  801943:	75 0e                	jne    801953 <strtol+0xbb>
		s++, base = 8;
  801945:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80194a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801951:	eb 0d                	jmp    801960 <strtol+0xc8>
	else if (base == 0)
  801953:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801957:	75 07                	jne    801960 <strtol+0xc8>
		base = 10;
  801959:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801960:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801964:	0f b6 00             	movzbl (%rax),%eax
  801967:	3c 2f                	cmp    $0x2f,%al
  801969:	7e 1d                	jle    801988 <strtol+0xf0>
  80196b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196f:	0f b6 00             	movzbl (%rax),%eax
  801972:	3c 39                	cmp    $0x39,%al
  801974:	7f 12                	jg     801988 <strtol+0xf0>
			dig = *s - '0';
  801976:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197a:	0f b6 00             	movzbl (%rax),%eax
  80197d:	0f be c0             	movsbl %al,%eax
  801980:	83 e8 30             	sub    $0x30,%eax
  801983:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801986:	eb 4e                	jmp    8019d6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801988:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80198c:	0f b6 00             	movzbl (%rax),%eax
  80198f:	3c 60                	cmp    $0x60,%al
  801991:	7e 1d                	jle    8019b0 <strtol+0x118>
  801993:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801997:	0f b6 00             	movzbl (%rax),%eax
  80199a:	3c 7a                	cmp    $0x7a,%al
  80199c:	7f 12                	jg     8019b0 <strtol+0x118>
			dig = *s - 'a' + 10;
  80199e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a2:	0f b6 00             	movzbl (%rax),%eax
  8019a5:	0f be c0             	movsbl %al,%eax
  8019a8:	83 e8 57             	sub    $0x57,%eax
  8019ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019ae:	eb 26                	jmp    8019d6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8019b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b4:	0f b6 00             	movzbl (%rax),%eax
  8019b7:	3c 40                	cmp    $0x40,%al
  8019b9:	7e 48                	jle    801a03 <strtol+0x16b>
  8019bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019bf:	0f b6 00             	movzbl (%rax),%eax
  8019c2:	3c 5a                	cmp    $0x5a,%al
  8019c4:	7f 3d                	jg     801a03 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8019c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ca:	0f b6 00             	movzbl (%rax),%eax
  8019cd:	0f be c0             	movsbl %al,%eax
  8019d0:	83 e8 37             	sub    $0x37,%eax
  8019d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8019d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019d9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8019dc:	7c 02                	jl     8019e0 <strtol+0x148>
			break;
  8019de:	eb 23                	jmp    801a03 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8019e0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019e5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8019e8:	48 98                	cltq   
  8019ea:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8019ef:	48 89 c2             	mov    %rax,%rdx
  8019f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019f5:	48 98                	cltq   
  8019f7:	48 01 d0             	add    %rdx,%rax
  8019fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8019fe:	e9 5d ff ff ff       	jmpq   801960 <strtol+0xc8>

	if (endptr)
  801a03:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a08:	74 0b                	je     801a15 <strtol+0x17d>
		*endptr = (char *) s;
  801a0a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a0e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a12:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a19:	74 09                	je     801a24 <strtol+0x18c>
  801a1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a1f:	48 f7 d8             	neg    %rax
  801a22:	eb 04                	jmp    801a28 <strtol+0x190>
  801a24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a28:	c9                   	leaveq 
  801a29:	c3                   	retq   

0000000000801a2a <strstr>:

char * strstr(const char *in, const char *str)
{
  801a2a:	55                   	push   %rbp
  801a2b:	48 89 e5             	mov    %rsp,%rbp
  801a2e:	48 83 ec 30          	sub    $0x30,%rsp
  801a32:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a36:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801a3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a3e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a42:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a46:	0f b6 00             	movzbl (%rax),%eax
  801a49:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801a4c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801a50:	75 06                	jne    801a58 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801a52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a56:	eb 6b                	jmp    801ac3 <strstr+0x99>

    len = strlen(str);
  801a58:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a5c:	48 89 c7             	mov    %rax,%rdi
  801a5f:	48 b8 00 13 80 00 00 	movabs $0x801300,%rax
  801a66:	00 00 00 
  801a69:	ff d0                	callq  *%rax
  801a6b:	48 98                	cltq   
  801a6d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801a71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a75:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a79:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a7d:	0f b6 00             	movzbl (%rax),%eax
  801a80:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801a83:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a87:	75 07                	jne    801a90 <strstr+0x66>
                return (char *) 0;
  801a89:	b8 00 00 00 00       	mov    $0x0,%eax
  801a8e:	eb 33                	jmp    801ac3 <strstr+0x99>
        } while (sc != c);
  801a90:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a94:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a97:	75 d8                	jne    801a71 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801a99:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a9d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801aa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa5:	48 89 ce             	mov    %rcx,%rsi
  801aa8:	48 89 c7             	mov    %rax,%rdi
  801aab:	48 b8 21 15 80 00 00 	movabs $0x801521,%rax
  801ab2:	00 00 00 
  801ab5:	ff d0                	callq  *%rax
  801ab7:	85 c0                	test   %eax,%eax
  801ab9:	75 b6                	jne    801a71 <strstr+0x47>

    return (char *) (in - 1);
  801abb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801abf:	48 83 e8 01          	sub    $0x1,%rax
}
  801ac3:	c9                   	leaveq 
  801ac4:	c3                   	retq   

0000000000801ac5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801ac5:	55                   	push   %rbp
  801ac6:	48 89 e5             	mov    %rsp,%rbp
  801ac9:	53                   	push   %rbx
  801aca:	48 83 ec 48          	sub    $0x48,%rsp
  801ace:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801ad1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801ad4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801ad8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801adc:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801ae0:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ae4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ae7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801aeb:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801aef:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801af3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801af7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801afb:	4c 89 c3             	mov    %r8,%rbx
  801afe:	cd 30                	int    $0x30
  801b00:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801b04:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b08:	74 3e                	je     801b48 <syscall+0x83>
  801b0a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b0f:	7e 37                	jle    801b48 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b11:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b15:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b18:	49 89 d0             	mov    %rdx,%r8
  801b1b:	89 c1                	mov    %eax,%ecx
  801b1d:	48 ba c0 3f 80 00 00 	movabs $0x803fc0,%rdx
  801b24:	00 00 00 
  801b27:	be 23 00 00 00       	mov    $0x23,%esi
  801b2c:	48 bf dd 3f 80 00 00 	movabs $0x803fdd,%rdi
  801b33:	00 00 00 
  801b36:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3b:	49 b9 8b 03 80 00 00 	movabs $0x80038b,%r9
  801b42:	00 00 00 
  801b45:	41 ff d1             	callq  *%r9

	return ret;
  801b48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b4c:	48 83 c4 48          	add    $0x48,%rsp
  801b50:	5b                   	pop    %rbx
  801b51:	5d                   	pop    %rbp
  801b52:	c3                   	retq   

0000000000801b53 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801b53:	55                   	push   %rbp
  801b54:	48 89 e5             	mov    %rsp,%rbp
  801b57:	48 83 ec 20          	sub    $0x20,%rsp
  801b5b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801b63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b67:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b6b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b72:	00 
  801b73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b7f:	48 89 d1             	mov    %rdx,%rcx
  801b82:	48 89 c2             	mov    %rax,%rdx
  801b85:	be 00 00 00 00       	mov    $0x0,%esi
  801b8a:	bf 00 00 00 00       	mov    $0x0,%edi
  801b8f:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  801b96:	00 00 00 
  801b99:	ff d0                	callq  *%rax
}
  801b9b:	c9                   	leaveq 
  801b9c:	c3                   	retq   

0000000000801b9d <sys_cgetc>:

int
sys_cgetc(void)
{
  801b9d:	55                   	push   %rbp
  801b9e:	48 89 e5             	mov    %rsp,%rbp
  801ba1:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801ba5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bac:	00 
  801bad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bb9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bbe:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc3:	be 00 00 00 00       	mov    $0x0,%esi
  801bc8:	bf 01 00 00 00       	mov    $0x1,%edi
  801bcd:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  801bd4:	00 00 00 
  801bd7:	ff d0                	callq  *%rax
}
  801bd9:	c9                   	leaveq 
  801bda:	c3                   	retq   

0000000000801bdb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801bdb:	55                   	push   %rbp
  801bdc:	48 89 e5             	mov    %rsp,%rbp
  801bdf:	48 83 ec 10          	sub    $0x10,%rsp
  801be3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801be6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be9:	48 98                	cltq   
  801beb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf2:	00 
  801bf3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c04:	48 89 c2             	mov    %rax,%rdx
  801c07:	be 01 00 00 00       	mov    $0x1,%esi
  801c0c:	bf 03 00 00 00       	mov    $0x3,%edi
  801c11:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  801c18:	00 00 00 
  801c1b:	ff d0                	callq  *%rax
}
  801c1d:	c9                   	leaveq 
  801c1e:	c3                   	retq   

0000000000801c1f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c1f:	55                   	push   %rbp
  801c20:	48 89 e5             	mov    %rsp,%rbp
  801c23:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c2e:	00 
  801c2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c40:	ba 00 00 00 00       	mov    $0x0,%edx
  801c45:	be 00 00 00 00       	mov    $0x0,%esi
  801c4a:	bf 02 00 00 00       	mov    $0x2,%edi
  801c4f:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  801c56:	00 00 00 
  801c59:	ff d0                	callq  *%rax
}
  801c5b:	c9                   	leaveq 
  801c5c:	c3                   	retq   

0000000000801c5d <sys_yield>:

void
sys_yield(void)
{
  801c5d:	55                   	push   %rbp
  801c5e:	48 89 e5             	mov    %rsp,%rbp
  801c61:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801c65:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c6c:	00 
  801c6d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c73:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c79:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c83:	be 00 00 00 00       	mov    $0x0,%esi
  801c88:	bf 0b 00 00 00       	mov    $0xb,%edi
  801c8d:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  801c94:	00 00 00 
  801c97:	ff d0                	callq  *%rax
}
  801c99:	c9                   	leaveq 
  801c9a:	c3                   	retq   

0000000000801c9b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801c9b:	55                   	push   %rbp
  801c9c:	48 89 e5             	mov    %rsp,%rbp
  801c9f:	48 83 ec 20          	sub    $0x20,%rsp
  801ca3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ca6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801caa:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801cad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cb0:	48 63 c8             	movslq %eax,%rcx
  801cb3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cba:	48 98                	cltq   
  801cbc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cc3:	00 
  801cc4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cca:	49 89 c8             	mov    %rcx,%r8
  801ccd:	48 89 d1             	mov    %rdx,%rcx
  801cd0:	48 89 c2             	mov    %rax,%rdx
  801cd3:	be 01 00 00 00       	mov    $0x1,%esi
  801cd8:	bf 04 00 00 00       	mov    $0x4,%edi
  801cdd:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  801ce4:	00 00 00 
  801ce7:	ff d0                	callq  *%rax
}
  801ce9:	c9                   	leaveq 
  801cea:	c3                   	retq   

0000000000801ceb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ceb:	55                   	push   %rbp
  801cec:	48 89 e5             	mov    %rsp,%rbp
  801cef:	48 83 ec 30          	sub    $0x30,%rsp
  801cf3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cf6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cfa:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801cfd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d01:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d05:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d08:	48 63 c8             	movslq %eax,%rcx
  801d0b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d12:	48 63 f0             	movslq %eax,%rsi
  801d15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1c:	48 98                	cltq   
  801d1e:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d22:	49 89 f9             	mov    %rdi,%r9
  801d25:	49 89 f0             	mov    %rsi,%r8
  801d28:	48 89 d1             	mov    %rdx,%rcx
  801d2b:	48 89 c2             	mov    %rax,%rdx
  801d2e:	be 01 00 00 00       	mov    $0x1,%esi
  801d33:	bf 05 00 00 00       	mov    $0x5,%edi
  801d38:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  801d3f:	00 00 00 
  801d42:	ff d0                	callq  *%rax
}
  801d44:	c9                   	leaveq 
  801d45:	c3                   	retq   

0000000000801d46 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801d46:	55                   	push   %rbp
  801d47:	48 89 e5             	mov    %rsp,%rbp
  801d4a:	48 83 ec 20          	sub    $0x20,%rsp
  801d4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801d55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d5c:	48 98                	cltq   
  801d5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d65:	00 
  801d66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d72:	48 89 d1             	mov    %rdx,%rcx
  801d75:	48 89 c2             	mov    %rax,%rdx
  801d78:	be 01 00 00 00       	mov    $0x1,%esi
  801d7d:	bf 06 00 00 00       	mov    $0x6,%edi
  801d82:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  801d89:	00 00 00 
  801d8c:	ff d0                	callq  *%rax
}
  801d8e:	c9                   	leaveq 
  801d8f:	c3                   	retq   

0000000000801d90 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801d90:	55                   	push   %rbp
  801d91:	48 89 e5             	mov    %rsp,%rbp
  801d94:	48 83 ec 10          	sub    $0x10,%rsp
  801d98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d9b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801d9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801da1:	48 63 d0             	movslq %eax,%rdx
  801da4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da7:	48 98                	cltq   
  801da9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db0:	00 
  801db1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dbd:	48 89 d1             	mov    %rdx,%rcx
  801dc0:	48 89 c2             	mov    %rax,%rdx
  801dc3:	be 01 00 00 00       	mov    $0x1,%esi
  801dc8:	bf 08 00 00 00       	mov    $0x8,%edi
  801dcd:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  801dd4:	00 00 00 
  801dd7:	ff d0                	callq  *%rax
}
  801dd9:	c9                   	leaveq 
  801dda:	c3                   	retq   

0000000000801ddb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ddb:	55                   	push   %rbp
  801ddc:	48 89 e5             	mov    %rsp,%rbp
  801ddf:	48 83 ec 20          	sub    $0x20,%rsp
  801de3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801de6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801dea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df1:	48 98                	cltq   
  801df3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dfa:	00 
  801dfb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e07:	48 89 d1             	mov    %rdx,%rcx
  801e0a:	48 89 c2             	mov    %rax,%rdx
  801e0d:	be 01 00 00 00       	mov    $0x1,%esi
  801e12:	bf 09 00 00 00       	mov    $0x9,%edi
  801e17:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  801e1e:	00 00 00 
  801e21:	ff d0                	callq  *%rax
}
  801e23:	c9                   	leaveq 
  801e24:	c3                   	retq   

0000000000801e25 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e25:	55                   	push   %rbp
  801e26:	48 89 e5             	mov    %rsp,%rbp
  801e29:	48 83 ec 20          	sub    $0x20,%rsp
  801e2d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e30:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801e34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e3b:	48 98                	cltq   
  801e3d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e44:	00 
  801e45:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e4b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e51:	48 89 d1             	mov    %rdx,%rcx
  801e54:	48 89 c2             	mov    %rax,%rdx
  801e57:	be 01 00 00 00       	mov    $0x1,%esi
  801e5c:	bf 0a 00 00 00       	mov    $0xa,%edi
  801e61:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  801e68:	00 00 00 
  801e6b:	ff d0                	callq  *%rax
}
  801e6d:	c9                   	leaveq 
  801e6e:	c3                   	retq   

0000000000801e6f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801e6f:	55                   	push   %rbp
  801e70:	48 89 e5             	mov    %rsp,%rbp
  801e73:	48 83 ec 20          	sub    $0x20,%rsp
  801e77:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e7e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801e82:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801e85:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e88:	48 63 f0             	movslq %eax,%rsi
  801e8b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e92:	48 98                	cltq   
  801e94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e9f:	00 
  801ea0:	49 89 f1             	mov    %rsi,%r9
  801ea3:	49 89 c8             	mov    %rcx,%r8
  801ea6:	48 89 d1             	mov    %rdx,%rcx
  801ea9:	48 89 c2             	mov    %rax,%rdx
  801eac:	be 00 00 00 00       	mov    $0x0,%esi
  801eb1:	bf 0c 00 00 00       	mov    $0xc,%edi
  801eb6:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  801ebd:	00 00 00 
  801ec0:	ff d0                	callq  *%rax
}
  801ec2:	c9                   	leaveq 
  801ec3:	c3                   	retq   

0000000000801ec4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ec4:	55                   	push   %rbp
  801ec5:	48 89 e5             	mov    %rsp,%rbp
  801ec8:	48 83 ec 10          	sub    $0x10,%rsp
  801ecc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ed0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ed4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801edb:	00 
  801edc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ee2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ee8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801eed:	48 89 c2             	mov    %rax,%rdx
  801ef0:	be 01 00 00 00       	mov    $0x1,%esi
  801ef5:	bf 0d 00 00 00       	mov    $0xd,%edi
  801efa:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  801f01:	00 00 00 
  801f04:	ff d0                	callq  *%rax
}
  801f06:	c9                   	leaveq 
  801f07:	c3                   	retq   

0000000000801f08 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801f08:	55                   	push   %rbp
  801f09:	48 89 e5             	mov    %rsp,%rbp
  801f0c:	48 83 ec 08          	sub    $0x8,%rsp
  801f10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f14:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f18:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801f1f:	ff ff ff 
  801f22:	48 01 d0             	add    %rdx,%rax
  801f25:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801f29:	c9                   	leaveq 
  801f2a:	c3                   	retq   

0000000000801f2b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801f2b:	55                   	push   %rbp
  801f2c:	48 89 e5             	mov    %rsp,%rbp
  801f2f:	48 83 ec 08          	sub    $0x8,%rsp
  801f33:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f3b:	48 89 c7             	mov    %rax,%rdi
  801f3e:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  801f45:	00 00 00 
  801f48:	ff d0                	callq  *%rax
  801f4a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801f50:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801f54:	c9                   	leaveq 
  801f55:	c3                   	retq   

0000000000801f56 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801f56:	55                   	push   %rbp
  801f57:	48 89 e5             	mov    %rsp,%rbp
  801f5a:	48 83 ec 18          	sub    $0x18,%rsp
  801f5e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f69:	eb 6b                	jmp    801fd6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801f6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f6e:	48 98                	cltq   
  801f70:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f76:	48 c1 e0 0c          	shl    $0xc,%rax
  801f7a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f82:	48 c1 e8 15          	shr    $0x15,%rax
  801f86:	48 89 c2             	mov    %rax,%rdx
  801f89:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f90:	01 00 00 
  801f93:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f97:	83 e0 01             	and    $0x1,%eax
  801f9a:	48 85 c0             	test   %rax,%rax
  801f9d:	74 21                	je     801fc0 <fd_alloc+0x6a>
  801f9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa3:	48 c1 e8 0c          	shr    $0xc,%rax
  801fa7:	48 89 c2             	mov    %rax,%rdx
  801faa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fb1:	01 00 00 
  801fb4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb8:	83 e0 01             	and    $0x1,%eax
  801fbb:	48 85 c0             	test   %rax,%rax
  801fbe:	75 12                	jne    801fd2 <fd_alloc+0x7c>
			*fd_store = fd;
  801fc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fc8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd0:	eb 1a                	jmp    801fec <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801fd2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fd6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801fda:	7e 8f                	jle    801f6b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801fdc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fe0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801fe7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801fec:	c9                   	leaveq 
  801fed:	c3                   	retq   

0000000000801fee <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801fee:	55                   	push   %rbp
  801fef:	48 89 e5             	mov    %rsp,%rbp
  801ff2:	48 83 ec 20          	sub    $0x20,%rsp
  801ff6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ff9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ffd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802001:	78 06                	js     802009 <fd_lookup+0x1b>
  802003:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802007:	7e 07                	jle    802010 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802009:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80200e:	eb 6c                	jmp    80207c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802010:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802013:	48 98                	cltq   
  802015:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80201b:	48 c1 e0 0c          	shl    $0xc,%rax
  80201f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802023:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802027:	48 c1 e8 15          	shr    $0x15,%rax
  80202b:	48 89 c2             	mov    %rax,%rdx
  80202e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802035:	01 00 00 
  802038:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80203c:	83 e0 01             	and    $0x1,%eax
  80203f:	48 85 c0             	test   %rax,%rax
  802042:	74 21                	je     802065 <fd_lookup+0x77>
  802044:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802048:	48 c1 e8 0c          	shr    $0xc,%rax
  80204c:	48 89 c2             	mov    %rax,%rdx
  80204f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802056:	01 00 00 
  802059:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80205d:	83 e0 01             	and    $0x1,%eax
  802060:	48 85 c0             	test   %rax,%rax
  802063:	75 07                	jne    80206c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802065:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80206a:	eb 10                	jmp    80207c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80206c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802070:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802074:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802077:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80207c:	c9                   	leaveq 
  80207d:	c3                   	retq   

000000000080207e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80207e:	55                   	push   %rbp
  80207f:	48 89 e5             	mov    %rsp,%rbp
  802082:	48 83 ec 30          	sub    $0x30,%rsp
  802086:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80208a:	89 f0                	mov    %esi,%eax
  80208c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80208f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802093:	48 89 c7             	mov    %rax,%rdi
  802096:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  80209d:	00 00 00 
  8020a0:	ff d0                	callq  *%rax
  8020a2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020a6:	48 89 d6             	mov    %rdx,%rsi
  8020a9:	89 c7                	mov    %eax,%edi
  8020ab:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  8020b2:	00 00 00 
  8020b5:	ff d0                	callq  *%rax
  8020b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020be:	78 0a                	js     8020ca <fd_close+0x4c>
	    || fd != fd2)
  8020c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020c4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8020c8:	74 12                	je     8020dc <fd_close+0x5e>
		return (must_exist ? r : 0);
  8020ca:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8020ce:	74 05                	je     8020d5 <fd_close+0x57>
  8020d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020d3:	eb 05                	jmp    8020da <fd_close+0x5c>
  8020d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020da:	eb 69                	jmp    802145 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8020dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020e0:	8b 00                	mov    (%rax),%eax
  8020e2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020e6:	48 89 d6             	mov    %rdx,%rsi
  8020e9:	89 c7                	mov    %eax,%edi
  8020eb:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  8020f2:	00 00 00 
  8020f5:	ff d0                	callq  *%rax
  8020f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020fe:	78 2a                	js     80212a <fd_close+0xac>
		if (dev->dev_close)
  802100:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802104:	48 8b 40 20          	mov    0x20(%rax),%rax
  802108:	48 85 c0             	test   %rax,%rax
  80210b:	74 16                	je     802123 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80210d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802111:	48 8b 40 20          	mov    0x20(%rax),%rax
  802115:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802119:	48 89 d7             	mov    %rdx,%rdi
  80211c:	ff d0                	callq  *%rax
  80211e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802121:	eb 07                	jmp    80212a <fd_close+0xac>
		else
			r = 0;
  802123:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80212a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80212e:	48 89 c6             	mov    %rax,%rsi
  802131:	bf 00 00 00 00       	mov    $0x0,%edi
  802136:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  80213d:	00 00 00 
  802140:	ff d0                	callq  *%rax
	return r;
  802142:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802145:	c9                   	leaveq 
  802146:	c3                   	retq   

0000000000802147 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802147:	55                   	push   %rbp
  802148:	48 89 e5             	mov    %rsp,%rbp
  80214b:	48 83 ec 20          	sub    $0x20,%rsp
  80214f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802152:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802156:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80215d:	eb 41                	jmp    8021a0 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80215f:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802166:	00 00 00 
  802169:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80216c:	48 63 d2             	movslq %edx,%rdx
  80216f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802173:	8b 00                	mov    (%rax),%eax
  802175:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802178:	75 22                	jne    80219c <dev_lookup+0x55>
			*dev = devtab[i];
  80217a:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802181:	00 00 00 
  802184:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802187:	48 63 d2             	movslq %edx,%rdx
  80218a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80218e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802192:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802195:	b8 00 00 00 00       	mov    $0x0,%eax
  80219a:	eb 60                	jmp    8021fc <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80219c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021a0:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8021a7:	00 00 00 
  8021aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021ad:	48 63 d2             	movslq %edx,%rdx
  8021b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b4:	48 85 c0             	test   %rax,%rax
  8021b7:	75 a6                	jne    80215f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8021b9:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8021c0:	00 00 00 
  8021c3:	48 8b 00             	mov    (%rax),%rax
  8021c6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021cc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021cf:	89 c6                	mov    %eax,%esi
  8021d1:	48 bf f0 3f 80 00 00 	movabs $0x803ff0,%rdi
  8021d8:	00 00 00 
  8021db:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e0:	48 b9 c4 05 80 00 00 	movabs $0x8005c4,%rcx
  8021e7:	00 00 00 
  8021ea:	ff d1                	callq  *%rcx
	*dev = 0;
  8021ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021f0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8021f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8021fc:	c9                   	leaveq 
  8021fd:	c3                   	retq   

00000000008021fe <close>:

int
close(int fdnum)
{
  8021fe:	55                   	push   %rbp
  8021ff:	48 89 e5             	mov    %rsp,%rbp
  802202:	48 83 ec 20          	sub    $0x20,%rsp
  802206:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802209:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80220d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802210:	48 89 d6             	mov    %rdx,%rsi
  802213:	89 c7                	mov    %eax,%edi
  802215:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  80221c:	00 00 00 
  80221f:	ff d0                	callq  *%rax
  802221:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802224:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802228:	79 05                	jns    80222f <close+0x31>
		return r;
  80222a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80222d:	eb 18                	jmp    802247 <close+0x49>
	else
		return fd_close(fd, 1);
  80222f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802233:	be 01 00 00 00       	mov    $0x1,%esi
  802238:	48 89 c7             	mov    %rax,%rdi
  80223b:	48 b8 7e 20 80 00 00 	movabs $0x80207e,%rax
  802242:	00 00 00 
  802245:	ff d0                	callq  *%rax
}
  802247:	c9                   	leaveq 
  802248:	c3                   	retq   

0000000000802249 <close_all>:

void
close_all(void)
{
  802249:	55                   	push   %rbp
  80224a:	48 89 e5             	mov    %rsp,%rbp
  80224d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802251:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802258:	eb 15                	jmp    80226f <close_all+0x26>
		close(i);
  80225a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80225d:	89 c7                	mov    %eax,%edi
  80225f:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  802266:	00 00 00 
  802269:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80226b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80226f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802273:	7e e5                	jle    80225a <close_all+0x11>
		close(i);
}
  802275:	c9                   	leaveq 
  802276:	c3                   	retq   

0000000000802277 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802277:	55                   	push   %rbp
  802278:	48 89 e5             	mov    %rsp,%rbp
  80227b:	48 83 ec 40          	sub    $0x40,%rsp
  80227f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802282:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802285:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802289:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80228c:	48 89 d6             	mov    %rdx,%rsi
  80228f:	89 c7                	mov    %eax,%edi
  802291:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802298:	00 00 00 
  80229b:	ff d0                	callq  *%rax
  80229d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a4:	79 08                	jns    8022ae <dup+0x37>
		return r;
  8022a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a9:	e9 70 01 00 00       	jmpq   80241e <dup+0x1a7>
	close(newfdnum);
  8022ae:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022b1:	89 c7                	mov    %eax,%edi
  8022b3:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  8022ba:	00 00 00 
  8022bd:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8022bf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022c2:	48 98                	cltq   
  8022c4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022ca:	48 c1 e0 0c          	shl    $0xc,%rax
  8022ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8022d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022d6:	48 89 c7             	mov    %rax,%rdi
  8022d9:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  8022e0:	00 00 00 
  8022e3:	ff d0                	callq  *%rax
  8022e5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8022e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ed:	48 89 c7             	mov    %rax,%rdi
  8022f0:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  8022f7:	00 00 00 
  8022fa:	ff d0                	callq  *%rax
  8022fc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802300:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802304:	48 c1 e8 15          	shr    $0x15,%rax
  802308:	48 89 c2             	mov    %rax,%rdx
  80230b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802312:	01 00 00 
  802315:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802319:	83 e0 01             	and    $0x1,%eax
  80231c:	48 85 c0             	test   %rax,%rax
  80231f:	74 73                	je     802394 <dup+0x11d>
  802321:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802325:	48 c1 e8 0c          	shr    $0xc,%rax
  802329:	48 89 c2             	mov    %rax,%rdx
  80232c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802333:	01 00 00 
  802336:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80233a:	83 e0 01             	and    $0x1,%eax
  80233d:	48 85 c0             	test   %rax,%rax
  802340:	74 52                	je     802394 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802342:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802346:	48 c1 e8 0c          	shr    $0xc,%rax
  80234a:	48 89 c2             	mov    %rax,%rdx
  80234d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802354:	01 00 00 
  802357:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80235b:	25 07 0e 00 00       	and    $0xe07,%eax
  802360:	89 c1                	mov    %eax,%ecx
  802362:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802366:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236a:	41 89 c8             	mov    %ecx,%r8d
  80236d:	48 89 d1             	mov    %rdx,%rcx
  802370:	ba 00 00 00 00       	mov    $0x0,%edx
  802375:	48 89 c6             	mov    %rax,%rsi
  802378:	bf 00 00 00 00       	mov    $0x0,%edi
  80237d:	48 b8 eb 1c 80 00 00 	movabs $0x801ceb,%rax
  802384:	00 00 00 
  802387:	ff d0                	callq  *%rax
  802389:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80238c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802390:	79 02                	jns    802394 <dup+0x11d>
			goto err;
  802392:	eb 57                	jmp    8023eb <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802394:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802398:	48 c1 e8 0c          	shr    $0xc,%rax
  80239c:	48 89 c2             	mov    %rax,%rdx
  80239f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023a6:	01 00 00 
  8023a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023ad:	25 07 0e 00 00       	and    $0xe07,%eax
  8023b2:	89 c1                	mov    %eax,%ecx
  8023b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023bc:	41 89 c8             	mov    %ecx,%r8d
  8023bf:	48 89 d1             	mov    %rdx,%rcx
  8023c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8023c7:	48 89 c6             	mov    %rax,%rsi
  8023ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8023cf:	48 b8 eb 1c 80 00 00 	movabs $0x801ceb,%rax
  8023d6:	00 00 00 
  8023d9:	ff d0                	callq  *%rax
  8023db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e2:	79 02                	jns    8023e6 <dup+0x16f>
		goto err;
  8023e4:	eb 05                	jmp    8023eb <dup+0x174>

	return newfdnum;
  8023e6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023e9:	eb 33                	jmp    80241e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8023eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ef:	48 89 c6             	mov    %rax,%rsi
  8023f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8023f7:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  8023fe:	00 00 00 
  802401:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802403:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802407:	48 89 c6             	mov    %rax,%rsi
  80240a:	bf 00 00 00 00       	mov    $0x0,%edi
  80240f:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  802416:	00 00 00 
  802419:	ff d0                	callq  *%rax
	return r;
  80241b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80241e:	c9                   	leaveq 
  80241f:	c3                   	retq   

0000000000802420 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802420:	55                   	push   %rbp
  802421:	48 89 e5             	mov    %rsp,%rbp
  802424:	48 83 ec 40          	sub    $0x40,%rsp
  802428:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80242b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80242f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802433:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802437:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80243a:	48 89 d6             	mov    %rdx,%rsi
  80243d:	89 c7                	mov    %eax,%edi
  80243f:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802446:	00 00 00 
  802449:	ff d0                	callq  *%rax
  80244b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80244e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802452:	78 24                	js     802478 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802454:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802458:	8b 00                	mov    (%rax),%eax
  80245a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80245e:	48 89 d6             	mov    %rdx,%rsi
  802461:	89 c7                	mov    %eax,%edi
  802463:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  80246a:	00 00 00 
  80246d:	ff d0                	callq  *%rax
  80246f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802472:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802476:	79 05                	jns    80247d <read+0x5d>
		return r;
  802478:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80247b:	eb 76                	jmp    8024f3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80247d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802481:	8b 40 08             	mov    0x8(%rax),%eax
  802484:	83 e0 03             	and    $0x3,%eax
  802487:	83 f8 01             	cmp    $0x1,%eax
  80248a:	75 3a                	jne    8024c6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80248c:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  802493:	00 00 00 
  802496:	48 8b 00             	mov    (%rax),%rax
  802499:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80249f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024a2:	89 c6                	mov    %eax,%esi
  8024a4:	48 bf 0f 40 80 00 00 	movabs $0x80400f,%rdi
  8024ab:	00 00 00 
  8024ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b3:	48 b9 c4 05 80 00 00 	movabs $0x8005c4,%rcx
  8024ba:	00 00 00 
  8024bd:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024c4:	eb 2d                	jmp    8024f3 <read+0xd3>
	}
	if (!dev->dev_read)
  8024c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ca:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024ce:	48 85 c0             	test   %rax,%rax
  8024d1:	75 07                	jne    8024da <read+0xba>
		return -E_NOT_SUPP;
  8024d3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024d8:	eb 19                	jmp    8024f3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8024da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024de:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024e2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024e6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024ea:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024ee:	48 89 cf             	mov    %rcx,%rdi
  8024f1:	ff d0                	callq  *%rax
}
  8024f3:	c9                   	leaveq 
  8024f4:	c3                   	retq   

00000000008024f5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8024f5:	55                   	push   %rbp
  8024f6:	48 89 e5             	mov    %rsp,%rbp
  8024f9:	48 83 ec 30          	sub    $0x30,%rsp
  8024fd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802500:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802504:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802508:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80250f:	eb 49                	jmp    80255a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802511:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802514:	48 98                	cltq   
  802516:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80251a:	48 29 c2             	sub    %rax,%rdx
  80251d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802520:	48 63 c8             	movslq %eax,%rcx
  802523:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802527:	48 01 c1             	add    %rax,%rcx
  80252a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80252d:	48 89 ce             	mov    %rcx,%rsi
  802530:	89 c7                	mov    %eax,%edi
  802532:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  802539:	00 00 00 
  80253c:	ff d0                	callq  *%rax
  80253e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802541:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802545:	79 05                	jns    80254c <readn+0x57>
			return m;
  802547:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80254a:	eb 1c                	jmp    802568 <readn+0x73>
		if (m == 0)
  80254c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802550:	75 02                	jne    802554 <readn+0x5f>
			break;
  802552:	eb 11                	jmp    802565 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802554:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802557:	01 45 fc             	add    %eax,-0x4(%rbp)
  80255a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80255d:	48 98                	cltq   
  80255f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802563:	72 ac                	jb     802511 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802565:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802568:	c9                   	leaveq 
  802569:	c3                   	retq   

000000000080256a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80256a:	55                   	push   %rbp
  80256b:	48 89 e5             	mov    %rsp,%rbp
  80256e:	48 83 ec 40          	sub    $0x40,%rsp
  802572:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802575:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802579:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80257d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802581:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802584:	48 89 d6             	mov    %rdx,%rsi
  802587:	89 c7                	mov    %eax,%edi
  802589:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802590:	00 00 00 
  802593:	ff d0                	callq  *%rax
  802595:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802598:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80259c:	78 24                	js     8025c2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80259e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a2:	8b 00                	mov    (%rax),%eax
  8025a4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025a8:	48 89 d6             	mov    %rdx,%rsi
  8025ab:	89 c7                	mov    %eax,%edi
  8025ad:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  8025b4:	00 00 00 
  8025b7:	ff d0                	callq  *%rax
  8025b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c0:	79 05                	jns    8025c7 <write+0x5d>
		return r;
  8025c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025c5:	eb 75                	jmp    80263c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025cb:	8b 40 08             	mov    0x8(%rax),%eax
  8025ce:	83 e0 03             	and    $0x3,%eax
  8025d1:	85 c0                	test   %eax,%eax
  8025d3:	75 3a                	jne    80260f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8025d5:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8025dc:	00 00 00 
  8025df:	48 8b 00             	mov    (%rax),%rax
  8025e2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025e8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025eb:	89 c6                	mov    %eax,%esi
  8025ed:	48 bf 2b 40 80 00 00 	movabs $0x80402b,%rdi
  8025f4:	00 00 00 
  8025f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fc:	48 b9 c4 05 80 00 00 	movabs $0x8005c4,%rcx
  802603:	00 00 00 
  802606:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802608:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80260d:	eb 2d                	jmp    80263c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80260f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802613:	48 8b 40 18          	mov    0x18(%rax),%rax
  802617:	48 85 c0             	test   %rax,%rax
  80261a:	75 07                	jne    802623 <write+0xb9>
		return -E_NOT_SUPP;
  80261c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802621:	eb 19                	jmp    80263c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802623:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802627:	48 8b 40 18          	mov    0x18(%rax),%rax
  80262b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80262f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802633:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802637:	48 89 cf             	mov    %rcx,%rdi
  80263a:	ff d0                	callq  *%rax
}
  80263c:	c9                   	leaveq 
  80263d:	c3                   	retq   

000000000080263e <seek>:

int
seek(int fdnum, off_t offset)
{
  80263e:	55                   	push   %rbp
  80263f:	48 89 e5             	mov    %rsp,%rbp
  802642:	48 83 ec 18          	sub    $0x18,%rsp
  802646:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802649:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80264c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802650:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802653:	48 89 d6             	mov    %rdx,%rsi
  802656:	89 c7                	mov    %eax,%edi
  802658:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  80265f:	00 00 00 
  802662:	ff d0                	callq  *%rax
  802664:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802667:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80266b:	79 05                	jns    802672 <seek+0x34>
		return r;
  80266d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802670:	eb 0f                	jmp    802681 <seek+0x43>
	fd->fd_offset = offset;
  802672:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802676:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802679:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80267c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802681:	c9                   	leaveq 
  802682:	c3                   	retq   

0000000000802683 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802683:	55                   	push   %rbp
  802684:	48 89 e5             	mov    %rsp,%rbp
  802687:	48 83 ec 30          	sub    $0x30,%rsp
  80268b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80268e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802691:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802695:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802698:	48 89 d6             	mov    %rdx,%rsi
  80269b:	89 c7                	mov    %eax,%edi
  80269d:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  8026a4:	00 00 00 
  8026a7:	ff d0                	callq  *%rax
  8026a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b0:	78 24                	js     8026d6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b6:	8b 00                	mov    (%rax),%eax
  8026b8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026bc:	48 89 d6             	mov    %rdx,%rsi
  8026bf:	89 c7                	mov    %eax,%edi
  8026c1:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  8026c8:	00 00 00 
  8026cb:	ff d0                	callq  *%rax
  8026cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d4:	79 05                	jns    8026db <ftruncate+0x58>
		return r;
  8026d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d9:	eb 72                	jmp    80274d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8026db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026df:	8b 40 08             	mov    0x8(%rax),%eax
  8026e2:	83 e0 03             	and    $0x3,%eax
  8026e5:	85 c0                	test   %eax,%eax
  8026e7:	75 3a                	jne    802723 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8026e9:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8026f0:	00 00 00 
  8026f3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8026f6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026fc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026ff:	89 c6                	mov    %eax,%esi
  802701:	48 bf 48 40 80 00 00 	movabs $0x804048,%rdi
  802708:	00 00 00 
  80270b:	b8 00 00 00 00       	mov    $0x0,%eax
  802710:	48 b9 c4 05 80 00 00 	movabs $0x8005c4,%rcx
  802717:	00 00 00 
  80271a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80271c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802721:	eb 2a                	jmp    80274d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802723:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802727:	48 8b 40 30          	mov    0x30(%rax),%rax
  80272b:	48 85 c0             	test   %rax,%rax
  80272e:	75 07                	jne    802737 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802730:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802735:	eb 16                	jmp    80274d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802737:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80273f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802743:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802746:	89 ce                	mov    %ecx,%esi
  802748:	48 89 d7             	mov    %rdx,%rdi
  80274b:	ff d0                	callq  *%rax
}
  80274d:	c9                   	leaveq 
  80274e:	c3                   	retq   

000000000080274f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80274f:	55                   	push   %rbp
  802750:	48 89 e5             	mov    %rsp,%rbp
  802753:	48 83 ec 30          	sub    $0x30,%rsp
  802757:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80275a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80275e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802762:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802765:	48 89 d6             	mov    %rdx,%rsi
  802768:	89 c7                	mov    %eax,%edi
  80276a:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  802771:	00 00 00 
  802774:	ff d0                	callq  *%rax
  802776:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802779:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80277d:	78 24                	js     8027a3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80277f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802783:	8b 00                	mov    (%rax),%eax
  802785:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802789:	48 89 d6             	mov    %rdx,%rsi
  80278c:	89 c7                	mov    %eax,%edi
  80278e:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  802795:	00 00 00 
  802798:	ff d0                	callq  *%rax
  80279a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80279d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a1:	79 05                	jns    8027a8 <fstat+0x59>
		return r;
  8027a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a6:	eb 5e                	jmp    802806 <fstat+0xb7>
	if (!dev->dev_stat)
  8027a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ac:	48 8b 40 28          	mov    0x28(%rax),%rax
  8027b0:	48 85 c0             	test   %rax,%rax
  8027b3:	75 07                	jne    8027bc <fstat+0x6d>
		return -E_NOT_SUPP;
  8027b5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027ba:	eb 4a                	jmp    802806 <fstat+0xb7>
	stat->st_name[0] = 0;
  8027bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027c0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8027c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027c7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8027ce:	00 00 00 
	stat->st_isdir = 0;
  8027d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027d5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8027dc:	00 00 00 
	stat->st_dev = dev;
  8027df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027e7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8027ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8027f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027fa:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8027fe:	48 89 ce             	mov    %rcx,%rsi
  802801:	48 89 d7             	mov    %rdx,%rdi
  802804:	ff d0                	callq  *%rax
}
  802806:	c9                   	leaveq 
  802807:	c3                   	retq   

0000000000802808 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802808:	55                   	push   %rbp
  802809:	48 89 e5             	mov    %rsp,%rbp
  80280c:	48 83 ec 20          	sub    $0x20,%rsp
  802810:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802814:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80281c:	be 00 00 00 00       	mov    $0x0,%esi
  802821:	48 89 c7             	mov    %rax,%rdi
  802824:	48 b8 f6 28 80 00 00 	movabs $0x8028f6,%rax
  80282b:	00 00 00 
  80282e:	ff d0                	callq  *%rax
  802830:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802833:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802837:	79 05                	jns    80283e <stat+0x36>
		return fd;
  802839:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80283c:	eb 2f                	jmp    80286d <stat+0x65>
	r = fstat(fd, stat);
  80283e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802842:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802845:	48 89 d6             	mov    %rdx,%rsi
  802848:	89 c7                	mov    %eax,%edi
  80284a:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  802851:	00 00 00 
  802854:	ff d0                	callq  *%rax
  802856:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802859:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80285c:	89 c7                	mov    %eax,%edi
  80285e:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  802865:	00 00 00 
  802868:	ff d0                	callq  *%rax
	return r;
  80286a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80286d:	c9                   	leaveq 
  80286e:	c3                   	retq   

000000000080286f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80286f:	55                   	push   %rbp
  802870:	48 89 e5             	mov    %rsp,%rbp
  802873:	48 83 ec 10          	sub    $0x10,%rsp
  802877:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80287a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80287e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802885:	00 00 00 
  802888:	8b 00                	mov    (%rax),%eax
  80288a:	85 c0                	test   %eax,%eax
  80288c:	75 1d                	jne    8028ab <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80288e:	bf 01 00 00 00       	mov    $0x1,%edi
  802893:	48 b8 69 39 80 00 00 	movabs $0x803969,%rax
  80289a:	00 00 00 
  80289d:	ff d0                	callq  *%rax
  80289f:	48 ba 08 60 80 00 00 	movabs $0x806008,%rdx
  8028a6:	00 00 00 
  8028a9:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8028ab:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8028b2:	00 00 00 
  8028b5:	8b 00                	mov    (%rax),%eax
  8028b7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8028ba:	b9 07 00 00 00       	mov    $0x7,%ecx
  8028bf:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8028c6:	00 00 00 
  8028c9:	89 c7                	mov    %eax,%edi
  8028cb:	48 b8 d1 38 80 00 00 	movabs $0x8038d1,%rax
  8028d2:	00 00 00 
  8028d5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8028d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028db:	ba 00 00 00 00       	mov    $0x0,%edx
  8028e0:	48 89 c6             	mov    %rax,%rsi
  8028e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8028e8:	48 b8 08 38 80 00 00 	movabs $0x803808,%rax
  8028ef:	00 00 00 
  8028f2:	ff d0                	callq  *%rax
}
  8028f4:	c9                   	leaveq 
  8028f5:	c3                   	retq   

00000000008028f6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8028f6:	55                   	push   %rbp
  8028f7:	48 89 e5             	mov    %rsp,%rbp
  8028fa:	48 83 ec 20          	sub    $0x20,%rsp
  8028fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802902:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802905:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802909:	48 89 c7             	mov    %rax,%rdi
  80290c:	48 b8 00 13 80 00 00 	movabs $0x801300,%rax
  802913:	00 00 00 
  802916:	ff d0                	callq  *%rax
  802918:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80291d:	7e 0a                	jle    802929 <open+0x33>
		return -E_BAD_PATH;
  80291f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802924:	e9 a5 00 00 00       	jmpq   8029ce <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802929:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80292d:	48 89 c7             	mov    %rax,%rdi
  802930:	48 b8 56 1f 80 00 00 	movabs $0x801f56,%rax
  802937:	00 00 00 
  80293a:	ff d0                	callq  *%rax
  80293c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80293f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802943:	79 08                	jns    80294d <open+0x57>
		return r;
  802945:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802948:	e9 81 00 00 00       	jmpq   8029ce <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80294d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802951:	48 89 c6             	mov    %rax,%rsi
  802954:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80295b:	00 00 00 
  80295e:	48 b8 6c 13 80 00 00 	movabs $0x80136c,%rax
  802965:	00 00 00 
  802968:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80296a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802971:	00 00 00 
  802974:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802977:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80297d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802981:	48 89 c6             	mov    %rax,%rsi
  802984:	bf 01 00 00 00       	mov    $0x1,%edi
  802989:	48 b8 6f 28 80 00 00 	movabs $0x80286f,%rax
  802990:	00 00 00 
  802993:	ff d0                	callq  *%rax
  802995:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802998:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80299c:	79 1d                	jns    8029bb <open+0xc5>
		fd_close(fd, 0);
  80299e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a2:	be 00 00 00 00       	mov    $0x0,%esi
  8029a7:	48 89 c7             	mov    %rax,%rdi
  8029aa:	48 b8 7e 20 80 00 00 	movabs $0x80207e,%rax
  8029b1:	00 00 00 
  8029b4:	ff d0                	callq  *%rax
		return r;
  8029b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b9:	eb 13                	jmp    8029ce <open+0xd8>
	}

	return fd2num(fd);
  8029bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029bf:	48 89 c7             	mov    %rax,%rdi
  8029c2:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  8029c9:	00 00 00 
  8029cc:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  8029ce:	c9                   	leaveq 
  8029cf:	c3                   	retq   

00000000008029d0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8029d0:	55                   	push   %rbp
  8029d1:	48 89 e5             	mov    %rsp,%rbp
  8029d4:	48 83 ec 10          	sub    $0x10,%rsp
  8029d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8029dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029e0:	8b 50 0c             	mov    0xc(%rax),%edx
  8029e3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029ea:	00 00 00 
  8029ed:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8029ef:	be 00 00 00 00       	mov    $0x0,%esi
  8029f4:	bf 06 00 00 00       	mov    $0x6,%edi
  8029f9:	48 b8 6f 28 80 00 00 	movabs $0x80286f,%rax
  802a00:	00 00 00 
  802a03:	ff d0                	callq  *%rax
}
  802a05:	c9                   	leaveq 
  802a06:	c3                   	retq   

0000000000802a07 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802a07:	55                   	push   %rbp
  802a08:	48 89 e5             	mov    %rsp,%rbp
  802a0b:	48 83 ec 30          	sub    $0x30,%rsp
  802a0f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a13:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a17:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802a1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a1f:	8b 50 0c             	mov    0xc(%rax),%edx
  802a22:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a29:	00 00 00 
  802a2c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802a2e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a35:	00 00 00 
  802a38:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a3c:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802a40:	be 00 00 00 00       	mov    $0x0,%esi
  802a45:	bf 03 00 00 00       	mov    $0x3,%edi
  802a4a:	48 b8 6f 28 80 00 00 	movabs $0x80286f,%rax
  802a51:	00 00 00 
  802a54:	ff d0                	callq  *%rax
  802a56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a5d:	79 05                	jns    802a64 <devfile_read+0x5d>
		return r;
  802a5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a62:	eb 26                	jmp    802a8a <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a67:	48 63 d0             	movslq %eax,%rdx
  802a6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a6e:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802a75:	00 00 00 
  802a78:	48 89 c7             	mov    %rax,%rdi
  802a7b:	48 b8 90 16 80 00 00 	movabs $0x801690,%rax
  802a82:	00 00 00 
  802a85:	ff d0                	callq  *%rax

	return r;
  802a87:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802a8a:	c9                   	leaveq 
  802a8b:	c3                   	retq   

0000000000802a8c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a8c:	55                   	push   %rbp
  802a8d:	48 89 e5             	mov    %rsp,%rbp
  802a90:	48 83 ec 30          	sub    $0x30,%rsp
  802a94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a98:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a9c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802aa0:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802aa7:	00 
  802aa8:	76 08                	jbe    802ab2 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802aaa:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802ab1:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802ab2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab6:	8b 50 0c             	mov    0xc(%rax),%edx
  802ab9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ac0:	00 00 00 
  802ac3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802ac5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802acc:	00 00 00 
  802acf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ad3:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  802ad7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802adb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802adf:	48 89 c6             	mov    %rax,%rsi
  802ae2:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802ae9:	00 00 00 
  802aec:	48 b8 90 16 80 00 00 	movabs $0x801690,%rax
  802af3:	00 00 00 
  802af6:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802af8:	be 00 00 00 00       	mov    $0x0,%esi
  802afd:	bf 04 00 00 00       	mov    $0x4,%edi
  802b02:	48 b8 6f 28 80 00 00 	movabs $0x80286f,%rax
  802b09:	00 00 00 
  802b0c:	ff d0                	callq  *%rax
  802b0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b15:	79 05                	jns    802b1c <devfile_write+0x90>
		return r;
  802b17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1a:	eb 03                	jmp    802b1f <devfile_write+0x93>

	return r;
  802b1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802b1f:	c9                   	leaveq 
  802b20:	c3                   	retq   

0000000000802b21 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b21:	55                   	push   %rbp
  802b22:	48 89 e5             	mov    %rsp,%rbp
  802b25:	48 83 ec 20          	sub    $0x20,%rsp
  802b29:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b2d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b35:	8b 50 0c             	mov    0xc(%rax),%edx
  802b38:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b3f:	00 00 00 
  802b42:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b44:	be 00 00 00 00       	mov    $0x0,%esi
  802b49:	bf 05 00 00 00       	mov    $0x5,%edi
  802b4e:	48 b8 6f 28 80 00 00 	movabs $0x80286f,%rax
  802b55:	00 00 00 
  802b58:	ff d0                	callq  *%rax
  802b5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b61:	79 05                	jns    802b68 <devfile_stat+0x47>
		return r;
  802b63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b66:	eb 56                	jmp    802bbe <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b6c:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802b73:	00 00 00 
  802b76:	48 89 c7             	mov    %rax,%rdi
  802b79:	48 b8 6c 13 80 00 00 	movabs $0x80136c,%rax
  802b80:	00 00 00 
  802b83:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b85:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b8c:	00 00 00 
  802b8f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b99:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b9f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ba6:	00 00 00 
  802ba9:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802baf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bb3:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802bb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bbe:	c9                   	leaveq 
  802bbf:	c3                   	retq   

0000000000802bc0 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802bc0:	55                   	push   %rbp
  802bc1:	48 89 e5             	mov    %rsp,%rbp
  802bc4:	48 83 ec 10          	sub    $0x10,%rsp
  802bc8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802bcc:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802bcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bd3:	8b 50 0c             	mov    0xc(%rax),%edx
  802bd6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bdd:	00 00 00 
  802be0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802be2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802be9:	00 00 00 
  802bec:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802bef:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802bf2:	be 00 00 00 00       	mov    $0x0,%esi
  802bf7:	bf 02 00 00 00       	mov    $0x2,%edi
  802bfc:	48 b8 6f 28 80 00 00 	movabs $0x80286f,%rax
  802c03:	00 00 00 
  802c06:	ff d0                	callq  *%rax
}
  802c08:	c9                   	leaveq 
  802c09:	c3                   	retq   

0000000000802c0a <remove>:

// Delete a file
int
remove(const char *path)
{
  802c0a:	55                   	push   %rbp
  802c0b:	48 89 e5             	mov    %rsp,%rbp
  802c0e:	48 83 ec 10          	sub    $0x10,%rsp
  802c12:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c1a:	48 89 c7             	mov    %rax,%rdi
  802c1d:	48 b8 00 13 80 00 00 	movabs $0x801300,%rax
  802c24:	00 00 00 
  802c27:	ff d0                	callq  *%rax
  802c29:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c2e:	7e 07                	jle    802c37 <remove+0x2d>
		return -E_BAD_PATH;
  802c30:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c35:	eb 33                	jmp    802c6a <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802c37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c3b:	48 89 c6             	mov    %rax,%rsi
  802c3e:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802c45:	00 00 00 
  802c48:	48 b8 6c 13 80 00 00 	movabs $0x80136c,%rax
  802c4f:	00 00 00 
  802c52:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c54:	be 00 00 00 00       	mov    $0x0,%esi
  802c59:	bf 07 00 00 00       	mov    $0x7,%edi
  802c5e:	48 b8 6f 28 80 00 00 	movabs $0x80286f,%rax
  802c65:	00 00 00 
  802c68:	ff d0                	callq  *%rax
}
  802c6a:	c9                   	leaveq 
  802c6b:	c3                   	retq   

0000000000802c6c <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c6c:	55                   	push   %rbp
  802c6d:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c70:	be 00 00 00 00       	mov    $0x0,%esi
  802c75:	bf 08 00 00 00       	mov    $0x8,%edi
  802c7a:	48 b8 6f 28 80 00 00 	movabs $0x80286f,%rax
  802c81:	00 00 00 
  802c84:	ff d0                	callq  *%rax
}
  802c86:	5d                   	pop    %rbp
  802c87:	c3                   	retq   

0000000000802c88 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802c88:	55                   	push   %rbp
  802c89:	48 89 e5             	mov    %rsp,%rbp
  802c8c:	48 83 ec 20          	sub    $0x20,%rsp
  802c90:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802c94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c98:	8b 40 0c             	mov    0xc(%rax),%eax
  802c9b:	85 c0                	test   %eax,%eax
  802c9d:	7e 67                	jle    802d06 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802c9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca3:	8b 40 04             	mov    0x4(%rax),%eax
  802ca6:	48 63 d0             	movslq %eax,%rdx
  802ca9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cad:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802cb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb5:	8b 00                	mov    (%rax),%eax
  802cb7:	48 89 ce             	mov    %rcx,%rsi
  802cba:	89 c7                	mov    %eax,%edi
  802cbc:	48 b8 6a 25 80 00 00 	movabs $0x80256a,%rax
  802cc3:	00 00 00 
  802cc6:	ff d0                	callq  *%rax
  802cc8:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802ccb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ccf:	7e 13                	jle    802ce4 <writebuf+0x5c>
			b->result += result;
  802cd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd5:	8b 50 08             	mov    0x8(%rax),%edx
  802cd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cdb:	01 c2                	add    %eax,%edx
  802cdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce1:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802ce4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce8:	8b 40 04             	mov    0x4(%rax),%eax
  802ceb:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802cee:	74 16                	je     802d06 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf9:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802cfd:	89 c2                	mov    %eax,%edx
  802cff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d03:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802d06:	c9                   	leaveq 
  802d07:	c3                   	retq   

0000000000802d08 <putch>:

static void
putch(int ch, void *thunk)
{
  802d08:	55                   	push   %rbp
  802d09:	48 89 e5             	mov    %rsp,%rbp
  802d0c:	48 83 ec 20          	sub    $0x20,%rsp
  802d10:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d13:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802d17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d1b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802d1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d23:	8b 40 04             	mov    0x4(%rax),%eax
  802d26:	8d 48 01             	lea    0x1(%rax),%ecx
  802d29:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d2d:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802d30:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d33:	89 d1                	mov    %edx,%ecx
  802d35:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d39:	48 98                	cltq   
  802d3b:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802d3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d43:	8b 40 04             	mov    0x4(%rax),%eax
  802d46:	3d 00 01 00 00       	cmp    $0x100,%eax
  802d4b:	75 1e                	jne    802d6b <putch+0x63>
		writebuf(b);
  802d4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d51:	48 89 c7             	mov    %rax,%rdi
  802d54:	48 b8 88 2c 80 00 00 	movabs $0x802c88,%rax
  802d5b:	00 00 00 
  802d5e:	ff d0                	callq  *%rax
		b->idx = 0;
  802d60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802d6b:	c9                   	leaveq 
  802d6c:	c3                   	retq   

0000000000802d6d <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802d6d:	55                   	push   %rbp
  802d6e:	48 89 e5             	mov    %rsp,%rbp
  802d71:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802d78:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802d7e:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802d85:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802d8c:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802d92:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802d98:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802d9f:	00 00 00 
	b.result = 0;
  802da2:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802da9:	00 00 00 
	b.error = 1;
  802dac:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802db3:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802db6:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802dbd:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802dc4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802dcb:	48 89 c6             	mov    %rax,%rsi
  802dce:	48 bf 08 2d 80 00 00 	movabs $0x802d08,%rdi
  802dd5:	00 00 00 
  802dd8:	48 b8 77 09 80 00 00 	movabs $0x800977,%rax
  802ddf:	00 00 00 
  802de2:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802de4:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802dea:	85 c0                	test   %eax,%eax
  802dec:	7e 16                	jle    802e04 <vfprintf+0x97>
		writebuf(&b);
  802dee:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802df5:	48 89 c7             	mov    %rax,%rdi
  802df8:	48 b8 88 2c 80 00 00 	movabs $0x802c88,%rax
  802dff:	00 00 00 
  802e02:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802e04:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802e0a:	85 c0                	test   %eax,%eax
  802e0c:	74 08                	je     802e16 <vfprintf+0xa9>
  802e0e:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802e14:	eb 06                	jmp    802e1c <vfprintf+0xaf>
  802e16:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802e1c:	c9                   	leaveq 
  802e1d:	c3                   	retq   

0000000000802e1e <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802e1e:	55                   	push   %rbp
  802e1f:	48 89 e5             	mov    %rsp,%rbp
  802e22:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802e29:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802e2f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802e36:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802e3d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802e44:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802e4b:	84 c0                	test   %al,%al
  802e4d:	74 20                	je     802e6f <fprintf+0x51>
  802e4f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802e53:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802e57:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802e5b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802e5f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802e63:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802e67:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802e6b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802e6f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802e76:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802e7d:	00 00 00 
  802e80:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802e87:	00 00 00 
  802e8a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802e8e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802e95:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802e9c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802ea3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802eaa:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802eb1:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802eb7:	48 89 ce             	mov    %rcx,%rsi
  802eba:	89 c7                	mov    %eax,%edi
  802ebc:	48 b8 6d 2d 80 00 00 	movabs $0x802d6d,%rax
  802ec3:	00 00 00 
  802ec6:	ff d0                	callq  *%rax
  802ec8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802ece:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802ed4:	c9                   	leaveq 
  802ed5:	c3                   	retq   

0000000000802ed6 <printf>:

int
printf(const char *fmt, ...)
{
  802ed6:	55                   	push   %rbp
  802ed7:	48 89 e5             	mov    %rsp,%rbp
  802eda:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802ee1:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802ee8:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802eef:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802ef6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802efd:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802f04:	84 c0                	test   %al,%al
  802f06:	74 20                	je     802f28 <printf+0x52>
  802f08:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802f0c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802f10:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802f14:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802f18:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802f1c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802f20:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802f24:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802f28:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802f2f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802f36:	00 00 00 
  802f39:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802f40:	00 00 00 
  802f43:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f47:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802f4e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802f55:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802f5c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802f63:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802f6a:	48 89 c6             	mov    %rax,%rsi
  802f6d:	bf 01 00 00 00       	mov    $0x1,%edi
  802f72:	48 b8 6d 2d 80 00 00 	movabs $0x802d6d,%rax
  802f79:	00 00 00 
  802f7c:	ff d0                	callq  *%rax
  802f7e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802f84:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802f8a:	c9                   	leaveq 
  802f8b:	c3                   	retq   

0000000000802f8c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802f8c:	55                   	push   %rbp
  802f8d:	48 89 e5             	mov    %rsp,%rbp
  802f90:	53                   	push   %rbx
  802f91:	48 83 ec 38          	sub    $0x38,%rsp
  802f95:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802f99:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802f9d:	48 89 c7             	mov    %rax,%rdi
  802fa0:	48 b8 56 1f 80 00 00 	movabs $0x801f56,%rax
  802fa7:	00 00 00 
  802faa:	ff d0                	callq  *%rax
  802fac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802faf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fb3:	0f 88 bf 01 00 00    	js     803178 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fbd:	ba 07 04 00 00       	mov    $0x407,%edx
  802fc2:	48 89 c6             	mov    %rax,%rsi
  802fc5:	bf 00 00 00 00       	mov    $0x0,%edi
  802fca:	48 b8 9b 1c 80 00 00 	movabs $0x801c9b,%rax
  802fd1:	00 00 00 
  802fd4:	ff d0                	callq  *%rax
  802fd6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fd9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fdd:	0f 88 95 01 00 00    	js     803178 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802fe3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802fe7:	48 89 c7             	mov    %rax,%rdi
  802fea:	48 b8 56 1f 80 00 00 	movabs $0x801f56,%rax
  802ff1:	00 00 00 
  802ff4:	ff d0                	callq  *%rax
  802ff6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ff9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ffd:	0f 88 5d 01 00 00    	js     803160 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803003:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803007:	ba 07 04 00 00       	mov    $0x407,%edx
  80300c:	48 89 c6             	mov    %rax,%rsi
  80300f:	bf 00 00 00 00       	mov    $0x0,%edi
  803014:	48 b8 9b 1c 80 00 00 	movabs $0x801c9b,%rax
  80301b:	00 00 00 
  80301e:	ff d0                	callq  *%rax
  803020:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803023:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803027:	0f 88 33 01 00 00    	js     803160 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80302d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803031:	48 89 c7             	mov    %rax,%rdi
  803034:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  80303b:	00 00 00 
  80303e:	ff d0                	callq  *%rax
  803040:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803044:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803048:	ba 07 04 00 00       	mov    $0x407,%edx
  80304d:	48 89 c6             	mov    %rax,%rsi
  803050:	bf 00 00 00 00       	mov    $0x0,%edi
  803055:	48 b8 9b 1c 80 00 00 	movabs $0x801c9b,%rax
  80305c:	00 00 00 
  80305f:	ff d0                	callq  *%rax
  803061:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803064:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803068:	79 05                	jns    80306f <pipe+0xe3>
		goto err2;
  80306a:	e9 d9 00 00 00       	jmpq   803148 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80306f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803073:	48 89 c7             	mov    %rax,%rdi
  803076:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  80307d:	00 00 00 
  803080:	ff d0                	callq  *%rax
  803082:	48 89 c2             	mov    %rax,%rdx
  803085:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803089:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80308f:	48 89 d1             	mov    %rdx,%rcx
  803092:	ba 00 00 00 00       	mov    $0x0,%edx
  803097:	48 89 c6             	mov    %rax,%rsi
  80309a:	bf 00 00 00 00       	mov    $0x0,%edi
  80309f:	48 b8 eb 1c 80 00 00 	movabs $0x801ceb,%rax
  8030a6:	00 00 00 
  8030a9:	ff d0                	callq  *%rax
  8030ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030b2:	79 1b                	jns    8030cf <pipe+0x143>
		goto err3;
  8030b4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8030b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b9:	48 89 c6             	mov    %rax,%rsi
  8030bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8030c1:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  8030c8:	00 00 00 
  8030cb:	ff d0                	callq  *%rax
  8030cd:	eb 79                	jmp    803148 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8030cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030d3:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8030da:	00 00 00 
  8030dd:	8b 12                	mov    (%rdx),%edx
  8030df:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8030e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030e5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8030ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030f0:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8030f7:	00 00 00 
  8030fa:	8b 12                	mov    (%rdx),%edx
  8030fc:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8030fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803102:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803109:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80310d:	48 89 c7             	mov    %rax,%rdi
  803110:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  803117:	00 00 00 
  80311a:	ff d0                	callq  *%rax
  80311c:	89 c2                	mov    %eax,%edx
  80311e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803122:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803124:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803128:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80312c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803130:	48 89 c7             	mov    %rax,%rdi
  803133:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  80313a:	00 00 00 
  80313d:	ff d0                	callq  *%rax
  80313f:	89 03                	mov    %eax,(%rbx)
	return 0;
  803141:	b8 00 00 00 00       	mov    $0x0,%eax
  803146:	eb 33                	jmp    80317b <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803148:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80314c:	48 89 c6             	mov    %rax,%rsi
  80314f:	bf 00 00 00 00       	mov    $0x0,%edi
  803154:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  80315b:	00 00 00 
  80315e:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803160:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803164:	48 89 c6             	mov    %rax,%rsi
  803167:	bf 00 00 00 00       	mov    $0x0,%edi
  80316c:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  803173:	00 00 00 
  803176:	ff d0                	callq  *%rax
    err:
	return r;
  803178:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80317b:	48 83 c4 38          	add    $0x38,%rsp
  80317f:	5b                   	pop    %rbx
  803180:	5d                   	pop    %rbp
  803181:	c3                   	retq   

0000000000803182 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803182:	55                   	push   %rbp
  803183:	48 89 e5             	mov    %rsp,%rbp
  803186:	53                   	push   %rbx
  803187:	48 83 ec 28          	sub    $0x28,%rsp
  80318b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80318f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803193:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  80319a:	00 00 00 
  80319d:	48 8b 00             	mov    (%rax),%rax
  8031a0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8031a6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8031a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031ad:	48 89 c7             	mov    %rax,%rdi
  8031b0:	48 b8 eb 39 80 00 00 	movabs $0x8039eb,%rax
  8031b7:	00 00 00 
  8031ba:	ff d0                	callq  *%rax
  8031bc:	89 c3                	mov    %eax,%ebx
  8031be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031c2:	48 89 c7             	mov    %rax,%rdi
  8031c5:	48 b8 eb 39 80 00 00 	movabs $0x8039eb,%rax
  8031cc:	00 00 00 
  8031cf:	ff d0                	callq  *%rax
  8031d1:	39 c3                	cmp    %eax,%ebx
  8031d3:	0f 94 c0             	sete   %al
  8031d6:	0f b6 c0             	movzbl %al,%eax
  8031d9:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8031dc:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8031e3:	00 00 00 
  8031e6:	48 8b 00             	mov    (%rax),%rax
  8031e9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8031ef:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8031f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031f5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8031f8:	75 05                	jne    8031ff <_pipeisclosed+0x7d>
			return ret;
  8031fa:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031fd:	eb 4f                	jmp    80324e <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8031ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803202:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803205:	74 42                	je     803249 <_pipeisclosed+0xc7>
  803207:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80320b:	75 3c                	jne    803249 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80320d:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  803214:	00 00 00 
  803217:	48 8b 00             	mov    (%rax),%rax
  80321a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803220:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803223:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803226:	89 c6                	mov    %eax,%esi
  803228:	48 bf 73 40 80 00 00 	movabs $0x804073,%rdi
  80322f:	00 00 00 
  803232:	b8 00 00 00 00       	mov    $0x0,%eax
  803237:	49 b8 c4 05 80 00 00 	movabs $0x8005c4,%r8
  80323e:	00 00 00 
  803241:	41 ff d0             	callq  *%r8
	}
  803244:	e9 4a ff ff ff       	jmpq   803193 <_pipeisclosed+0x11>
  803249:	e9 45 ff ff ff       	jmpq   803193 <_pipeisclosed+0x11>
}
  80324e:	48 83 c4 28          	add    $0x28,%rsp
  803252:	5b                   	pop    %rbx
  803253:	5d                   	pop    %rbp
  803254:	c3                   	retq   

0000000000803255 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803255:	55                   	push   %rbp
  803256:	48 89 e5             	mov    %rsp,%rbp
  803259:	48 83 ec 30          	sub    $0x30,%rsp
  80325d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803260:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803264:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803267:	48 89 d6             	mov    %rdx,%rsi
  80326a:	89 c7                	mov    %eax,%edi
  80326c:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  803273:	00 00 00 
  803276:	ff d0                	callq  *%rax
  803278:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80327b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80327f:	79 05                	jns    803286 <pipeisclosed+0x31>
		return r;
  803281:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803284:	eb 31                	jmp    8032b7 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80328a:	48 89 c7             	mov    %rax,%rdi
  80328d:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  803294:	00 00 00 
  803297:	ff d0                	callq  *%rax
  803299:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80329d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032a5:	48 89 d6             	mov    %rdx,%rsi
  8032a8:	48 89 c7             	mov    %rax,%rdi
  8032ab:	48 b8 82 31 80 00 00 	movabs $0x803182,%rax
  8032b2:	00 00 00 
  8032b5:	ff d0                	callq  *%rax
}
  8032b7:	c9                   	leaveq 
  8032b8:	c3                   	retq   

00000000008032b9 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8032b9:	55                   	push   %rbp
  8032ba:	48 89 e5             	mov    %rsp,%rbp
  8032bd:	48 83 ec 40          	sub    $0x40,%rsp
  8032c1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032c5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8032c9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8032cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032d1:	48 89 c7             	mov    %rax,%rdi
  8032d4:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  8032db:	00 00 00 
  8032de:	ff d0                	callq  *%rax
  8032e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8032e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032e8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8032ec:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8032f3:	00 
  8032f4:	e9 92 00 00 00       	jmpq   80338b <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8032f9:	eb 41                	jmp    80333c <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8032fb:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803300:	74 09                	je     80330b <devpipe_read+0x52>
				return i;
  803302:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803306:	e9 92 00 00 00       	jmpq   80339d <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80330b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80330f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803313:	48 89 d6             	mov    %rdx,%rsi
  803316:	48 89 c7             	mov    %rax,%rdi
  803319:	48 b8 82 31 80 00 00 	movabs $0x803182,%rax
  803320:	00 00 00 
  803323:	ff d0                	callq  *%rax
  803325:	85 c0                	test   %eax,%eax
  803327:	74 07                	je     803330 <devpipe_read+0x77>
				return 0;
  803329:	b8 00 00 00 00       	mov    $0x0,%eax
  80332e:	eb 6d                	jmp    80339d <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803330:	48 b8 5d 1c 80 00 00 	movabs $0x801c5d,%rax
  803337:	00 00 00 
  80333a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80333c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803340:	8b 10                	mov    (%rax),%edx
  803342:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803346:	8b 40 04             	mov    0x4(%rax),%eax
  803349:	39 c2                	cmp    %eax,%edx
  80334b:	74 ae                	je     8032fb <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80334d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803351:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803355:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803359:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80335d:	8b 00                	mov    (%rax),%eax
  80335f:	99                   	cltd   
  803360:	c1 ea 1b             	shr    $0x1b,%edx
  803363:	01 d0                	add    %edx,%eax
  803365:	83 e0 1f             	and    $0x1f,%eax
  803368:	29 d0                	sub    %edx,%eax
  80336a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80336e:	48 98                	cltq   
  803370:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803375:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803377:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80337b:	8b 00                	mov    (%rax),%eax
  80337d:	8d 50 01             	lea    0x1(%rax),%edx
  803380:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803384:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803386:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80338b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80338f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803393:	0f 82 60 ff ff ff    	jb     8032f9 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80339d:	c9                   	leaveq 
  80339e:	c3                   	retq   

000000000080339f <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80339f:	55                   	push   %rbp
  8033a0:	48 89 e5             	mov    %rsp,%rbp
  8033a3:	48 83 ec 40          	sub    $0x40,%rsp
  8033a7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033ab:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8033af:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8033b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033b7:	48 89 c7             	mov    %rax,%rdi
  8033ba:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  8033c1:	00 00 00 
  8033c4:	ff d0                	callq  *%rax
  8033c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8033ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8033d2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8033d9:	00 
  8033da:	e9 8e 00 00 00       	jmpq   80346d <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8033df:	eb 31                	jmp    803412 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8033e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033e9:	48 89 d6             	mov    %rdx,%rsi
  8033ec:	48 89 c7             	mov    %rax,%rdi
  8033ef:	48 b8 82 31 80 00 00 	movabs $0x803182,%rax
  8033f6:	00 00 00 
  8033f9:	ff d0                	callq  *%rax
  8033fb:	85 c0                	test   %eax,%eax
  8033fd:	74 07                	je     803406 <devpipe_write+0x67>
				return 0;
  8033ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803404:	eb 79                	jmp    80347f <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803406:	48 b8 5d 1c 80 00 00 	movabs $0x801c5d,%rax
  80340d:	00 00 00 
  803410:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803416:	8b 40 04             	mov    0x4(%rax),%eax
  803419:	48 63 d0             	movslq %eax,%rdx
  80341c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803420:	8b 00                	mov    (%rax),%eax
  803422:	48 98                	cltq   
  803424:	48 83 c0 20          	add    $0x20,%rax
  803428:	48 39 c2             	cmp    %rax,%rdx
  80342b:	73 b4                	jae    8033e1 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80342d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803431:	8b 40 04             	mov    0x4(%rax),%eax
  803434:	99                   	cltd   
  803435:	c1 ea 1b             	shr    $0x1b,%edx
  803438:	01 d0                	add    %edx,%eax
  80343a:	83 e0 1f             	and    $0x1f,%eax
  80343d:	29 d0                	sub    %edx,%eax
  80343f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803443:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803447:	48 01 ca             	add    %rcx,%rdx
  80344a:	0f b6 0a             	movzbl (%rdx),%ecx
  80344d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803451:	48 98                	cltq   
  803453:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803457:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80345b:	8b 40 04             	mov    0x4(%rax),%eax
  80345e:	8d 50 01             	lea    0x1(%rax),%edx
  803461:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803465:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803468:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80346d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803471:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803475:	0f 82 64 ff ff ff    	jb     8033df <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80347b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80347f:	c9                   	leaveq 
  803480:	c3                   	retq   

0000000000803481 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803481:	55                   	push   %rbp
  803482:	48 89 e5             	mov    %rsp,%rbp
  803485:	48 83 ec 20          	sub    $0x20,%rsp
  803489:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80348d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803491:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803495:	48 89 c7             	mov    %rax,%rdi
  803498:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  80349f:	00 00 00 
  8034a2:	ff d0                	callq  *%rax
  8034a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8034a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034ac:	48 be 86 40 80 00 00 	movabs $0x804086,%rsi
  8034b3:	00 00 00 
  8034b6:	48 89 c7             	mov    %rax,%rdi
  8034b9:	48 b8 6c 13 80 00 00 	movabs $0x80136c,%rax
  8034c0:	00 00 00 
  8034c3:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8034c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034c9:	8b 50 04             	mov    0x4(%rax),%edx
  8034cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034d0:	8b 00                	mov    (%rax),%eax
  8034d2:	29 c2                	sub    %eax,%edx
  8034d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034d8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8034de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034e2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8034e9:	00 00 00 
	stat->st_dev = &devpipe;
  8034ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034f0:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8034f7:	00 00 00 
  8034fa:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803501:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803506:	c9                   	leaveq 
  803507:	c3                   	retq   

0000000000803508 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803508:	55                   	push   %rbp
  803509:	48 89 e5             	mov    %rsp,%rbp
  80350c:	48 83 ec 10          	sub    $0x10,%rsp
  803510:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803514:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803518:	48 89 c6             	mov    %rax,%rsi
  80351b:	bf 00 00 00 00       	mov    $0x0,%edi
  803520:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  803527:	00 00 00 
  80352a:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80352c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803530:	48 89 c7             	mov    %rax,%rdi
  803533:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  80353a:	00 00 00 
  80353d:	ff d0                	callq  *%rax
  80353f:	48 89 c6             	mov    %rax,%rsi
  803542:	bf 00 00 00 00       	mov    $0x0,%edi
  803547:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  80354e:	00 00 00 
  803551:	ff d0                	callq  *%rax
}
  803553:	c9                   	leaveq 
  803554:	c3                   	retq   

0000000000803555 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803555:	55                   	push   %rbp
  803556:	48 89 e5             	mov    %rsp,%rbp
  803559:	48 83 ec 20          	sub    $0x20,%rsp
  80355d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803560:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803563:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803566:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80356a:	be 01 00 00 00       	mov    $0x1,%esi
  80356f:	48 89 c7             	mov    %rax,%rdi
  803572:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  803579:	00 00 00 
  80357c:	ff d0                	callq  *%rax
}
  80357e:	c9                   	leaveq 
  80357f:	c3                   	retq   

0000000000803580 <getchar>:

int
getchar(void)
{
  803580:	55                   	push   %rbp
  803581:	48 89 e5             	mov    %rsp,%rbp
  803584:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803588:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80358c:	ba 01 00 00 00       	mov    $0x1,%edx
  803591:	48 89 c6             	mov    %rax,%rsi
  803594:	bf 00 00 00 00       	mov    $0x0,%edi
  803599:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  8035a0:	00 00 00 
  8035a3:	ff d0                	callq  *%rax
  8035a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8035a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035ac:	79 05                	jns    8035b3 <getchar+0x33>
		return r;
  8035ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b1:	eb 14                	jmp    8035c7 <getchar+0x47>
	if (r < 1)
  8035b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035b7:	7f 07                	jg     8035c0 <getchar+0x40>
		return -E_EOF;
  8035b9:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8035be:	eb 07                	jmp    8035c7 <getchar+0x47>
	return c;
  8035c0:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8035c4:	0f b6 c0             	movzbl %al,%eax
}
  8035c7:	c9                   	leaveq 
  8035c8:	c3                   	retq   

00000000008035c9 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8035c9:	55                   	push   %rbp
  8035ca:	48 89 e5             	mov    %rsp,%rbp
  8035cd:	48 83 ec 20          	sub    $0x20,%rsp
  8035d1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8035d4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8035d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035db:	48 89 d6             	mov    %rdx,%rsi
  8035de:	89 c7                	mov    %eax,%edi
  8035e0:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  8035e7:	00 00 00 
  8035ea:	ff d0                	callq  *%rax
  8035ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035f3:	79 05                	jns    8035fa <iscons+0x31>
		return r;
  8035f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f8:	eb 1a                	jmp    803614 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8035fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035fe:	8b 10                	mov    (%rax),%edx
  803600:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803607:	00 00 00 
  80360a:	8b 00                	mov    (%rax),%eax
  80360c:	39 c2                	cmp    %eax,%edx
  80360e:	0f 94 c0             	sete   %al
  803611:	0f b6 c0             	movzbl %al,%eax
}
  803614:	c9                   	leaveq 
  803615:	c3                   	retq   

0000000000803616 <opencons>:

int
opencons(void)
{
  803616:	55                   	push   %rbp
  803617:	48 89 e5             	mov    %rsp,%rbp
  80361a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80361e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803622:	48 89 c7             	mov    %rax,%rdi
  803625:	48 b8 56 1f 80 00 00 	movabs $0x801f56,%rax
  80362c:	00 00 00 
  80362f:	ff d0                	callq  *%rax
  803631:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803634:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803638:	79 05                	jns    80363f <opencons+0x29>
		return r;
  80363a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80363d:	eb 5b                	jmp    80369a <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80363f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803643:	ba 07 04 00 00       	mov    $0x407,%edx
  803648:	48 89 c6             	mov    %rax,%rsi
  80364b:	bf 00 00 00 00       	mov    $0x0,%edi
  803650:	48 b8 9b 1c 80 00 00 	movabs $0x801c9b,%rax
  803657:	00 00 00 
  80365a:	ff d0                	callq  *%rax
  80365c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80365f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803663:	79 05                	jns    80366a <opencons+0x54>
		return r;
  803665:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803668:	eb 30                	jmp    80369a <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80366a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366e:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803675:	00 00 00 
  803678:	8b 12                	mov    (%rdx),%edx
  80367a:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80367c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803680:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803687:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80368b:	48 89 c7             	mov    %rax,%rdi
  80368e:	48 b8 08 1f 80 00 00 	movabs $0x801f08,%rax
  803695:	00 00 00 
  803698:	ff d0                	callq  *%rax
}
  80369a:	c9                   	leaveq 
  80369b:	c3                   	retq   

000000000080369c <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80369c:	55                   	push   %rbp
  80369d:	48 89 e5             	mov    %rsp,%rbp
  8036a0:	48 83 ec 30          	sub    $0x30,%rsp
  8036a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036ac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8036b0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8036b5:	75 07                	jne    8036be <devcons_read+0x22>
		return 0;
  8036b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8036bc:	eb 4b                	jmp    803709 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8036be:	eb 0c                	jmp    8036cc <devcons_read+0x30>
		sys_yield();
  8036c0:	48 b8 5d 1c 80 00 00 	movabs $0x801c5d,%rax
  8036c7:	00 00 00 
  8036ca:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8036cc:	48 b8 9d 1b 80 00 00 	movabs $0x801b9d,%rax
  8036d3:	00 00 00 
  8036d6:	ff d0                	callq  *%rax
  8036d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036df:	74 df                	je     8036c0 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8036e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036e5:	79 05                	jns    8036ec <devcons_read+0x50>
		return c;
  8036e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ea:	eb 1d                	jmp    803709 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8036ec:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8036f0:	75 07                	jne    8036f9 <devcons_read+0x5d>
		return 0;
  8036f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f7:	eb 10                	jmp    803709 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8036f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036fc:	89 c2                	mov    %eax,%edx
  8036fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803702:	88 10                	mov    %dl,(%rax)
	return 1;
  803704:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803709:	c9                   	leaveq 
  80370a:	c3                   	retq   

000000000080370b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80370b:	55                   	push   %rbp
  80370c:	48 89 e5             	mov    %rsp,%rbp
  80370f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803716:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80371d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803724:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80372b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803732:	eb 76                	jmp    8037aa <devcons_write+0x9f>
		m = n - tot;
  803734:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80373b:	89 c2                	mov    %eax,%edx
  80373d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803740:	29 c2                	sub    %eax,%edx
  803742:	89 d0                	mov    %edx,%eax
  803744:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803747:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80374a:	83 f8 7f             	cmp    $0x7f,%eax
  80374d:	76 07                	jbe    803756 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80374f:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803756:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803759:	48 63 d0             	movslq %eax,%rdx
  80375c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80375f:	48 63 c8             	movslq %eax,%rcx
  803762:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803769:	48 01 c1             	add    %rax,%rcx
  80376c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803773:	48 89 ce             	mov    %rcx,%rsi
  803776:	48 89 c7             	mov    %rax,%rdi
  803779:	48 b8 90 16 80 00 00 	movabs $0x801690,%rax
  803780:	00 00 00 
  803783:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803785:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803788:	48 63 d0             	movslq %eax,%rdx
  80378b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803792:	48 89 d6             	mov    %rdx,%rsi
  803795:	48 89 c7             	mov    %rax,%rdi
  803798:	48 b8 53 1b 80 00 00 	movabs $0x801b53,%rax
  80379f:	00 00 00 
  8037a2:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8037a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037a7:	01 45 fc             	add    %eax,-0x4(%rbp)
  8037aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ad:	48 98                	cltq   
  8037af:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8037b6:	0f 82 78 ff ff ff    	jb     803734 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8037bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8037bf:	c9                   	leaveq 
  8037c0:	c3                   	retq   

00000000008037c1 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8037c1:	55                   	push   %rbp
  8037c2:	48 89 e5             	mov    %rsp,%rbp
  8037c5:	48 83 ec 08          	sub    $0x8,%rsp
  8037c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8037cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037d2:	c9                   	leaveq 
  8037d3:	c3                   	retq   

00000000008037d4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8037d4:	55                   	push   %rbp
  8037d5:	48 89 e5             	mov    %rsp,%rbp
  8037d8:	48 83 ec 10          	sub    $0x10,%rsp
  8037dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8037e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e8:	48 be 92 40 80 00 00 	movabs $0x804092,%rsi
  8037ef:	00 00 00 
  8037f2:	48 89 c7             	mov    %rax,%rdi
  8037f5:	48 b8 6c 13 80 00 00 	movabs $0x80136c,%rax
  8037fc:	00 00 00 
  8037ff:	ff d0                	callq  *%rax
	return 0;
  803801:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803806:	c9                   	leaveq 
  803807:	c3                   	retq   

0000000000803808 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803808:	55                   	push   %rbp
  803809:	48 89 e5             	mov    %rsp,%rbp
  80380c:	48 83 ec 30          	sub    $0x30,%rsp
  803810:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803814:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803818:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  80381c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803820:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803824:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803829:	75 0e                	jne    803839 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  80382b:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803832:	00 00 00 
  803835:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  803839:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80383d:	48 89 c7             	mov    %rax,%rdi
  803840:	48 b8 c4 1e 80 00 00 	movabs $0x801ec4,%rax
  803847:	00 00 00 
  80384a:	ff d0                	callq  *%rax
  80384c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80384f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803853:	79 27                	jns    80387c <ipc_recv+0x74>
		if (from_env_store != NULL)
  803855:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80385a:	74 0a                	je     803866 <ipc_recv+0x5e>
			*from_env_store = 0;
  80385c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803860:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  803866:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80386b:	74 0a                	je     803877 <ipc_recv+0x6f>
			*perm_store = 0;
  80386d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803871:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803877:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80387a:	eb 53                	jmp    8038cf <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  80387c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803881:	74 19                	je     80389c <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  803883:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  80388a:	00 00 00 
  80388d:	48 8b 00             	mov    (%rax),%rax
  803890:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803896:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80389a:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  80389c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8038a1:	74 19                	je     8038bc <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  8038a3:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8038aa:	00 00 00 
  8038ad:	48 8b 00             	mov    (%rax),%rax
  8038b0:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8038b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ba:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  8038bc:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  8038c3:	00 00 00 
  8038c6:	48 8b 00             	mov    (%rax),%rax
  8038c9:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  8038cf:	c9                   	leaveq 
  8038d0:	c3                   	retq   

00000000008038d1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8038d1:	55                   	push   %rbp
  8038d2:	48 89 e5             	mov    %rsp,%rbp
  8038d5:	48 83 ec 30          	sub    $0x30,%rsp
  8038d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038dc:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8038df:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8038e3:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8038e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8038ee:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8038f3:	75 10                	jne    803905 <ipc_send+0x34>
		page = (void *)KERNBASE;
  8038f5:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8038fc:	00 00 00 
  8038ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803903:	eb 0e                	jmp    803913 <ipc_send+0x42>
  803905:	eb 0c                	jmp    803913 <ipc_send+0x42>
		sys_yield();
  803907:	48 b8 5d 1c 80 00 00 	movabs $0x801c5d,%rax
  80390e:	00 00 00 
  803911:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803913:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803916:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803919:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80391d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803920:	89 c7                	mov    %eax,%edi
  803922:	48 b8 6f 1e 80 00 00 	movabs $0x801e6f,%rax
  803929:	00 00 00 
  80392c:	ff d0                	callq  *%rax
  80392e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803931:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  803935:	74 d0                	je     803907 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  803937:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80393b:	74 2a                	je     803967 <ipc_send+0x96>
		panic("error on ipc send procedure");
  80393d:	48 ba 99 40 80 00 00 	movabs $0x804099,%rdx
  803944:	00 00 00 
  803947:	be 49 00 00 00       	mov    $0x49,%esi
  80394c:	48 bf b5 40 80 00 00 	movabs $0x8040b5,%rdi
  803953:	00 00 00 
  803956:	b8 00 00 00 00       	mov    $0x0,%eax
  80395b:	48 b9 8b 03 80 00 00 	movabs $0x80038b,%rcx
  803962:	00 00 00 
  803965:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  803967:	c9                   	leaveq 
  803968:	c3                   	retq   

0000000000803969 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803969:	55                   	push   %rbp
  80396a:	48 89 e5             	mov    %rsp,%rbp
  80396d:	48 83 ec 14          	sub    $0x14,%rsp
  803971:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803974:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80397b:	eb 5e                	jmp    8039db <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80397d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803984:	00 00 00 
  803987:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80398a:	48 63 d0             	movslq %eax,%rdx
  80398d:	48 89 d0             	mov    %rdx,%rax
  803990:	48 c1 e0 03          	shl    $0x3,%rax
  803994:	48 01 d0             	add    %rdx,%rax
  803997:	48 c1 e0 05          	shl    $0x5,%rax
  80399b:	48 01 c8             	add    %rcx,%rax
  80399e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8039a4:	8b 00                	mov    (%rax),%eax
  8039a6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8039a9:	75 2c                	jne    8039d7 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8039ab:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8039b2:	00 00 00 
  8039b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b8:	48 63 d0             	movslq %eax,%rdx
  8039bb:	48 89 d0             	mov    %rdx,%rax
  8039be:	48 c1 e0 03          	shl    $0x3,%rax
  8039c2:	48 01 d0             	add    %rdx,%rax
  8039c5:	48 c1 e0 05          	shl    $0x5,%rax
  8039c9:	48 01 c8             	add    %rcx,%rax
  8039cc:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8039d2:	8b 40 08             	mov    0x8(%rax),%eax
  8039d5:	eb 12                	jmp    8039e9 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8039d7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8039db:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8039e2:	7e 99                	jle    80397d <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8039e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039e9:	c9                   	leaveq 
  8039ea:	c3                   	retq   

00000000008039eb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8039eb:	55                   	push   %rbp
  8039ec:	48 89 e5             	mov    %rsp,%rbp
  8039ef:	48 83 ec 18          	sub    $0x18,%rsp
  8039f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8039f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039fb:	48 c1 e8 15          	shr    $0x15,%rax
  8039ff:	48 89 c2             	mov    %rax,%rdx
  803a02:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803a09:	01 00 00 
  803a0c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a10:	83 e0 01             	and    $0x1,%eax
  803a13:	48 85 c0             	test   %rax,%rax
  803a16:	75 07                	jne    803a1f <pageref+0x34>
		return 0;
  803a18:	b8 00 00 00 00       	mov    $0x0,%eax
  803a1d:	eb 53                	jmp    803a72 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803a1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a23:	48 c1 e8 0c          	shr    $0xc,%rax
  803a27:	48 89 c2             	mov    %rax,%rdx
  803a2a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803a31:	01 00 00 
  803a34:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a38:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803a3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a40:	83 e0 01             	and    $0x1,%eax
  803a43:	48 85 c0             	test   %rax,%rax
  803a46:	75 07                	jne    803a4f <pageref+0x64>
		return 0;
  803a48:	b8 00 00 00 00       	mov    $0x0,%eax
  803a4d:	eb 23                	jmp    803a72 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803a4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a53:	48 c1 e8 0c          	shr    $0xc,%rax
  803a57:	48 89 c2             	mov    %rax,%rdx
  803a5a:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803a61:	00 00 00 
  803a64:	48 c1 e2 04          	shl    $0x4,%rdx
  803a68:	48 01 d0             	add    %rdx,%rax
  803a6b:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803a6f:	0f b7 c0             	movzwl %ax,%eax
}
  803a72:	c9                   	leaveq 
  803a73:	c3                   	retq   
