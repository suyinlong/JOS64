
obj/user/cat.debug:     file format elf64-x86-64


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
  80003c:	e8 08 02 00 00       	callq  800249 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800052:	eb 68                	jmp    8000bc <cat+0x79>
		if ((r = write(1, buf, n)) != n)
  800054:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800058:	48 89 c2             	mov    %rax,%rdx
  80005b:	48 be 20 60 80 00 00 	movabs $0x806020,%rsi
  800062:	00 00 00 
  800065:	bf 01 00 00 00       	mov    $0x1,%edi
  80006a:	48 b8 db 24 80 00 00 	movabs $0x8024db,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800079:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80007c:	48 98                	cltq   
  80007e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800082:	74 38                	je     8000bc <cat+0x79>
			panic("write error copying %s: %e", s, r);
  800084:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800087:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80008b:	41 89 d0             	mov    %edx,%r8d
  80008e:	48 89 c1             	mov    %rax,%rcx
  800091:	48 ba 00 3a 80 00 00 	movabs $0x803a00,%rdx
  800098:	00 00 00 
  80009b:	be 0d 00 00 00       	mov    $0xd,%esi
  8000a0:	48 bf 1b 3a 80 00 00 	movabs $0x803a1b,%rdi
  8000a7:	00 00 00 
  8000aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000af:	49 b9 fc 02 80 00 00 	movabs $0x8002fc,%r9
  8000b6:	00 00 00 
  8000b9:	41 ff d1             	callq  *%r9
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  8000bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000bf:	ba 00 20 00 00       	mov    $0x2000,%edx
  8000c4:	48 be 20 60 80 00 00 	movabs $0x806020,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 91 23 80 00 00 	movabs $0x802391,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	48 98                	cltq   
  8000de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8000e2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000e7:	0f 8f 67 ff ff ff    	jg     800054 <cat+0x11>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000ed:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000f2:	79 39                	jns    80012d <cat+0xea>
		panic("error reading %s: %e", s, n);
  8000f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000fc:	49 89 d0             	mov    %rdx,%r8
  8000ff:	48 89 c1             	mov    %rax,%rcx
  800102:	48 ba 26 3a 80 00 00 	movabs $0x803a26,%rdx
  800109:	00 00 00 
  80010c:	be 0f 00 00 00       	mov    $0xf,%esi
  800111:	48 bf 1b 3a 80 00 00 	movabs $0x803a1b,%rdi
  800118:	00 00 00 
  80011b:	b8 00 00 00 00       	mov    $0x0,%eax
  800120:	49 b9 fc 02 80 00 00 	movabs $0x8002fc,%r9
  800127:	00 00 00 
  80012a:	41 ff d1             	callq  *%r9
}
  80012d:	c9                   	leaveq 
  80012e:	c3                   	retq   

000000000080012f <umain>:

void
umain(int argc, char **argv)
{
  80012f:	55                   	push   %rbp
  800130:	48 89 e5             	mov    %rsp,%rbp
  800133:	53                   	push   %rbx
  800134:	48 83 ec 28          	sub    $0x28,%rsp
  800138:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80013b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int f, i;

	binaryname = "cat";
  80013f:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800146:	00 00 00 
  800149:	48 bb 3b 3a 80 00 00 	movabs $0x803a3b,%rbx
  800150:	00 00 00 
  800153:	48 89 18             	mov    %rbx,(%rax)
	if (argc == 1)
  800156:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
  80015a:	75 20                	jne    80017c <umain+0x4d>
		cat(0, "<stdin>");
  80015c:	48 be 3f 3a 80 00 00 	movabs $0x803a3f,%rsi
  800163:	00 00 00 
  800166:	bf 00 00 00 00       	mov    $0x0,%edi
  80016b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800172:	00 00 00 
  800175:	ff d0                	callq  *%rax
  800177:	e9 c6 00 00 00       	jmpq   800242 <umain+0x113>
	else
		for (i = 1; i < argc; i++) {
  80017c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  800183:	e9 ae 00 00 00       	jmpq   800236 <umain+0x107>
			f = open(argv[i], O_RDONLY);
  800188:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80018b:	48 98                	cltq   
  80018d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800194:	00 
  800195:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800199:	48 01 d0             	add    %rdx,%rax
  80019c:	48 8b 00             	mov    (%rax),%rax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	48 89 c7             	mov    %rax,%rdi
  8001a7:	48 b8 67 28 80 00 00 	movabs $0x802867,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	callq  *%rax
  8001b3:	89 45 e8             	mov    %eax,-0x18(%rbp)
			if (f < 0)
  8001b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8001ba:	79 3a                	jns    8001f6 <umain+0xc7>
				printf("can't open %s: %e\n", argv[i], f);
  8001bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001bf:	48 98                	cltq   
  8001c1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8001c8:	00 
  8001c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8001cd:	48 01 d0             	add    %rdx,%rax
  8001d0:	48 8b 00             	mov    (%rax),%rax
  8001d3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8001d6:	48 89 c6             	mov    %rax,%rsi
  8001d9:	48 bf 47 3a 80 00 00 	movabs $0x803a47,%rdi
  8001e0:	00 00 00 
  8001e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e8:	48 b9 47 2e 80 00 00 	movabs $0x802e47,%rcx
  8001ef:	00 00 00 
  8001f2:	ff d1                	callq  *%rcx
  8001f4:	eb 3c                	jmp    800232 <umain+0x103>
			else {
				cat(f, argv[i]);
  8001f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800202:	00 
  800203:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800207:	48 01 d0             	add    %rdx,%rax
  80020a:	48 8b 10             	mov    (%rax),%rdx
  80020d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800210:	48 89 d6             	mov    %rdx,%rsi
  800213:	89 c7                	mov    %eax,%edi
  800215:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80021c:	00 00 00 
  80021f:	ff d0                	callq  *%rax
				close(f);
  800221:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800224:	89 c7                	mov    %eax,%edi
  800226:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800232:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800236:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800239:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  80023c:	0f 8c 46 ff ff ff    	jl     800188 <umain+0x59>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  800242:	48 83 c4 28          	add    $0x28,%rsp
  800246:	5b                   	pop    %rbx
  800247:	5d                   	pop    %rbp
  800248:	c3                   	retq   

0000000000800249 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800249:	55                   	push   %rbp
  80024a:	48 89 e5             	mov    %rsp,%rbp
  80024d:	48 83 ec 10          	sub    $0x10,%rsp
  800251:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800254:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800258:	48 b8 90 1b 80 00 00 	movabs $0x801b90,%rax
  80025f:	00 00 00 
  800262:	ff d0                	callq  *%rax
  800264:	48 98                	cltq   
  800266:	25 ff 03 00 00       	and    $0x3ff,%eax
  80026b:	48 89 c2             	mov    %rax,%rdx
  80026e:	48 89 d0             	mov    %rdx,%rax
  800271:	48 c1 e0 03          	shl    $0x3,%rax
  800275:	48 01 d0             	add    %rdx,%rax
  800278:	48 c1 e0 05          	shl    $0x5,%rax
  80027c:	48 89 c2             	mov    %rax,%rdx
  80027f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800286:	00 00 00 
  800289:	48 01 c2             	add    %rax,%rdx
  80028c:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800293:	00 00 00 
  800296:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800299:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80029d:	7e 14                	jle    8002b3 <libmain+0x6a>
		binaryname = argv[0];
  80029f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a3:	48 8b 10             	mov    (%rax),%rdx
  8002a6:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8002ad:	00 00 00 
  8002b0:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ba:	48 89 d6             	mov    %rdx,%rsi
  8002bd:	89 c7                	mov    %eax,%edi
  8002bf:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  8002c6:	00 00 00 
  8002c9:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8002cb:	48 b8 d9 02 80 00 00 	movabs $0x8002d9,%rax
  8002d2:	00 00 00 
  8002d5:	ff d0                	callq  *%rax
}
  8002d7:	c9                   	leaveq 
  8002d8:	c3                   	retq   

00000000008002d9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002d9:	55                   	push   %rbp
  8002da:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002dd:	48 b8 ba 21 80 00 00 	movabs $0x8021ba,%rax
  8002e4:	00 00 00 
  8002e7:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8002e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8002ee:	48 b8 4c 1b 80 00 00 	movabs $0x801b4c,%rax
  8002f5:	00 00 00 
  8002f8:	ff d0                	callq  *%rax
}
  8002fa:	5d                   	pop    %rbp
  8002fb:	c3                   	retq   

00000000008002fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002fc:	55                   	push   %rbp
  8002fd:	48 89 e5             	mov    %rsp,%rbp
  800300:	53                   	push   %rbx
  800301:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800308:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80030f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800315:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80031c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800323:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80032a:	84 c0                	test   %al,%al
  80032c:	74 23                	je     800351 <_panic+0x55>
  80032e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800335:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800339:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80033d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800341:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800345:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800349:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80034d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800351:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800358:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80035f:	00 00 00 
  800362:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800369:	00 00 00 
  80036c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800370:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800377:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80037e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800385:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80038c:	00 00 00 
  80038f:	48 8b 18             	mov    (%rax),%rbx
  800392:	48 b8 90 1b 80 00 00 	movabs $0x801b90,%rax
  800399:	00 00 00 
  80039c:	ff d0                	callq  *%rax
  80039e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003a4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003ab:	41 89 c8             	mov    %ecx,%r8d
  8003ae:	48 89 d1             	mov    %rdx,%rcx
  8003b1:	48 89 da             	mov    %rbx,%rdx
  8003b4:	89 c6                	mov    %eax,%esi
  8003b6:	48 bf 68 3a 80 00 00 	movabs $0x803a68,%rdi
  8003bd:	00 00 00 
  8003c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c5:	49 b9 35 05 80 00 00 	movabs $0x800535,%r9
  8003cc:	00 00 00 
  8003cf:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003d2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003d9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003e0:	48 89 d6             	mov    %rdx,%rsi
  8003e3:	48 89 c7             	mov    %rax,%rdi
  8003e6:	48 b8 89 04 80 00 00 	movabs $0x800489,%rax
  8003ed:	00 00 00 
  8003f0:	ff d0                	callq  *%rax
	cprintf("\n");
  8003f2:	48 bf 8b 3a 80 00 00 	movabs $0x803a8b,%rdi
  8003f9:	00 00 00 
  8003fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800401:	48 ba 35 05 80 00 00 	movabs $0x800535,%rdx
  800408:	00 00 00 
  80040b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80040d:	cc                   	int3   
  80040e:	eb fd                	jmp    80040d <_panic+0x111>

0000000000800410 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800410:	55                   	push   %rbp
  800411:	48 89 e5             	mov    %rsp,%rbp
  800414:	48 83 ec 10          	sub    $0x10,%rsp
  800418:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80041b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80041f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800423:	8b 00                	mov    (%rax),%eax
  800425:	8d 48 01             	lea    0x1(%rax),%ecx
  800428:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042c:	89 0a                	mov    %ecx,(%rdx)
  80042e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800431:	89 d1                	mov    %edx,%ecx
  800433:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800437:	48 98                	cltq   
  800439:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80043d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800441:	8b 00                	mov    (%rax),%eax
  800443:	3d ff 00 00 00       	cmp    $0xff,%eax
  800448:	75 2c                	jne    800476 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80044a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044e:	8b 00                	mov    (%rax),%eax
  800450:	48 98                	cltq   
  800452:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800456:	48 83 c2 08          	add    $0x8,%rdx
  80045a:	48 89 c6             	mov    %rax,%rsi
  80045d:	48 89 d7             	mov    %rdx,%rdi
  800460:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  800467:	00 00 00 
  80046a:	ff d0                	callq  *%rax
		b->idx = 0;
  80046c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800470:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800476:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047a:	8b 40 04             	mov    0x4(%rax),%eax
  80047d:	8d 50 01             	lea    0x1(%rax),%edx
  800480:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800484:	89 50 04             	mov    %edx,0x4(%rax)
}
  800487:	c9                   	leaveq 
  800488:	c3                   	retq   

0000000000800489 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800489:	55                   	push   %rbp
  80048a:	48 89 e5             	mov    %rsp,%rbp
  80048d:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800494:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80049b:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8004a2:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004a9:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004b0:	48 8b 0a             	mov    (%rdx),%rcx
  8004b3:	48 89 08             	mov    %rcx,(%rax)
  8004b6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004ba:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004be:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004c2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8004c6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004cd:	00 00 00 
	b.cnt = 0;
  8004d0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004d7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8004da:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004e1:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004e8:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004ef:	48 89 c6             	mov    %rax,%rsi
  8004f2:	48 bf 10 04 80 00 00 	movabs $0x800410,%rdi
  8004f9:	00 00 00 
  8004fc:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  800503:	00 00 00 
  800506:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800508:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80050e:	48 98                	cltq   
  800510:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800517:	48 83 c2 08          	add    $0x8,%rdx
  80051b:	48 89 c6             	mov    %rax,%rsi
  80051e:	48 89 d7             	mov    %rdx,%rdi
  800521:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  800528:	00 00 00 
  80052b:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80052d:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800533:	c9                   	leaveq 
  800534:	c3                   	retq   

0000000000800535 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800535:	55                   	push   %rbp
  800536:	48 89 e5             	mov    %rsp,%rbp
  800539:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800540:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800547:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80054e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800555:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80055c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800563:	84 c0                	test   %al,%al
  800565:	74 20                	je     800587 <cprintf+0x52>
  800567:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80056b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80056f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800573:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800577:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80057b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80057f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800583:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800587:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80058e:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800595:	00 00 00 
  800598:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80059f:	00 00 00 
  8005a2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005a6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005ad:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005b4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8005bb:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005c2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005c9:	48 8b 0a             	mov    (%rdx),%rcx
  8005cc:	48 89 08             	mov    %rcx,(%rax)
  8005cf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005d3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005d7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005db:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8005df:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005e6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005ed:	48 89 d6             	mov    %rdx,%rsi
  8005f0:	48 89 c7             	mov    %rax,%rdi
  8005f3:	48 b8 89 04 80 00 00 	movabs $0x800489,%rax
  8005fa:	00 00 00 
  8005fd:	ff d0                	callq  *%rax
  8005ff:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800605:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80060b:	c9                   	leaveq 
  80060c:	c3                   	retq   

000000000080060d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80060d:	55                   	push   %rbp
  80060e:	48 89 e5             	mov    %rsp,%rbp
  800611:	53                   	push   %rbx
  800612:	48 83 ec 38          	sub    $0x38,%rsp
  800616:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80061a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80061e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800622:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800625:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800629:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80062d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800630:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800634:	77 3b                	ja     800671 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800636:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800639:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80063d:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800640:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800644:	ba 00 00 00 00       	mov    $0x0,%edx
  800649:	48 f7 f3             	div    %rbx
  80064c:	48 89 c2             	mov    %rax,%rdx
  80064f:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800652:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800655:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800659:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065d:	41 89 f9             	mov    %edi,%r9d
  800660:	48 89 c7             	mov    %rax,%rdi
  800663:	48 b8 0d 06 80 00 00 	movabs $0x80060d,%rax
  80066a:	00 00 00 
  80066d:	ff d0                	callq  *%rax
  80066f:	eb 1e                	jmp    80068f <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800671:	eb 12                	jmp    800685 <printnum+0x78>
			putch(padc, putdat);
  800673:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800677:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80067a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067e:	48 89 ce             	mov    %rcx,%rsi
  800681:	89 d7                	mov    %edx,%edi
  800683:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800685:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800689:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80068d:	7f e4                	jg     800673 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80068f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800692:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800696:	ba 00 00 00 00       	mov    $0x0,%edx
  80069b:	48 f7 f1             	div    %rcx
  80069e:	48 89 d0             	mov    %rdx,%rax
  8006a1:	48 ba 68 3c 80 00 00 	movabs $0x803c68,%rdx
  8006a8:	00 00 00 
  8006ab:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006af:	0f be d0             	movsbl %al,%edx
  8006b2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ba:	48 89 ce             	mov    %rcx,%rsi
  8006bd:	89 d7                	mov    %edx,%edi
  8006bf:	ff d0                	callq  *%rax
}
  8006c1:	48 83 c4 38          	add    $0x38,%rsp
  8006c5:	5b                   	pop    %rbx
  8006c6:	5d                   	pop    %rbp
  8006c7:	c3                   	retq   

00000000008006c8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006c8:	55                   	push   %rbp
  8006c9:	48 89 e5             	mov    %rsp,%rbp
  8006cc:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  8006d7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006db:	7e 52                	jle    80072f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e1:	8b 00                	mov    (%rax),%eax
  8006e3:	83 f8 30             	cmp    $0x30,%eax
  8006e6:	73 24                	jae    80070c <getuint+0x44>
  8006e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ec:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f4:	8b 00                	mov    (%rax),%eax
  8006f6:	89 c0                	mov    %eax,%eax
  8006f8:	48 01 d0             	add    %rdx,%rax
  8006fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ff:	8b 12                	mov    (%rdx),%edx
  800701:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800704:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800708:	89 0a                	mov    %ecx,(%rdx)
  80070a:	eb 17                	jmp    800723 <getuint+0x5b>
  80070c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800710:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800714:	48 89 d0             	mov    %rdx,%rax
  800717:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80071b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800723:	48 8b 00             	mov    (%rax),%rax
  800726:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80072a:	e9 a3 00 00 00       	jmpq   8007d2 <getuint+0x10a>
	else if (lflag)
  80072f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800733:	74 4f                	je     800784 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800735:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800739:	8b 00                	mov    (%rax),%eax
  80073b:	83 f8 30             	cmp    $0x30,%eax
  80073e:	73 24                	jae    800764 <getuint+0x9c>
  800740:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800744:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074c:	8b 00                	mov    (%rax),%eax
  80074e:	89 c0                	mov    %eax,%eax
  800750:	48 01 d0             	add    %rdx,%rax
  800753:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800757:	8b 12                	mov    (%rdx),%edx
  800759:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80075c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800760:	89 0a                	mov    %ecx,(%rdx)
  800762:	eb 17                	jmp    80077b <getuint+0xb3>
  800764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800768:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80076c:	48 89 d0             	mov    %rdx,%rax
  80076f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800773:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800777:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80077b:	48 8b 00             	mov    (%rax),%rax
  80077e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800782:	eb 4e                	jmp    8007d2 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800784:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800788:	8b 00                	mov    (%rax),%eax
  80078a:	83 f8 30             	cmp    $0x30,%eax
  80078d:	73 24                	jae    8007b3 <getuint+0xeb>
  80078f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800793:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800797:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079b:	8b 00                	mov    (%rax),%eax
  80079d:	89 c0                	mov    %eax,%eax
  80079f:	48 01 d0             	add    %rdx,%rax
  8007a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a6:	8b 12                	mov    (%rdx),%edx
  8007a8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007af:	89 0a                	mov    %ecx,(%rdx)
  8007b1:	eb 17                	jmp    8007ca <getuint+0x102>
  8007b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007bb:	48 89 d0             	mov    %rdx,%rax
  8007be:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ca:	8b 00                	mov    (%rax),%eax
  8007cc:	89 c0                	mov    %eax,%eax
  8007ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007d6:	c9                   	leaveq 
  8007d7:	c3                   	retq   

00000000008007d8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d8:	55                   	push   %rbp
  8007d9:	48 89 e5             	mov    %rsp,%rbp
  8007dc:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007e4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007e7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007eb:	7e 52                	jle    80083f <getint+0x67>
		x=va_arg(*ap, long long);
  8007ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f1:	8b 00                	mov    (%rax),%eax
  8007f3:	83 f8 30             	cmp    $0x30,%eax
  8007f6:	73 24                	jae    80081c <getint+0x44>
  8007f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800800:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800804:	8b 00                	mov    (%rax),%eax
  800806:	89 c0                	mov    %eax,%eax
  800808:	48 01 d0             	add    %rdx,%rax
  80080b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080f:	8b 12                	mov    (%rdx),%edx
  800811:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800814:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800818:	89 0a                	mov    %ecx,(%rdx)
  80081a:	eb 17                	jmp    800833 <getint+0x5b>
  80081c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800820:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800824:	48 89 d0             	mov    %rdx,%rax
  800827:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80082b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800833:	48 8b 00             	mov    (%rax),%rax
  800836:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80083a:	e9 a3 00 00 00       	jmpq   8008e2 <getint+0x10a>
	else if (lflag)
  80083f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800843:	74 4f                	je     800894 <getint+0xbc>
		x=va_arg(*ap, long);
  800845:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800849:	8b 00                	mov    (%rax),%eax
  80084b:	83 f8 30             	cmp    $0x30,%eax
  80084e:	73 24                	jae    800874 <getint+0x9c>
  800850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800854:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800858:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085c:	8b 00                	mov    (%rax),%eax
  80085e:	89 c0                	mov    %eax,%eax
  800860:	48 01 d0             	add    %rdx,%rax
  800863:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800867:	8b 12                	mov    (%rdx),%edx
  800869:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80086c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800870:	89 0a                	mov    %ecx,(%rdx)
  800872:	eb 17                	jmp    80088b <getint+0xb3>
  800874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800878:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80087c:	48 89 d0             	mov    %rdx,%rax
  80087f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800883:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800887:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80088b:	48 8b 00             	mov    (%rax),%rax
  80088e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800892:	eb 4e                	jmp    8008e2 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800894:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800898:	8b 00                	mov    (%rax),%eax
  80089a:	83 f8 30             	cmp    $0x30,%eax
  80089d:	73 24                	jae    8008c3 <getint+0xeb>
  80089f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ab:	8b 00                	mov    (%rax),%eax
  8008ad:	89 c0                	mov    %eax,%eax
  8008af:	48 01 d0             	add    %rdx,%rax
  8008b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b6:	8b 12                	mov    (%rdx),%edx
  8008b8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008bf:	89 0a                	mov    %ecx,(%rdx)
  8008c1:	eb 17                	jmp    8008da <getint+0x102>
  8008c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008cb:	48 89 d0             	mov    %rdx,%rax
  8008ce:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008da:	8b 00                	mov    (%rax),%eax
  8008dc:	48 98                	cltq   
  8008de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008e6:	c9                   	leaveq 
  8008e7:	c3                   	retq   

00000000008008e8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008e8:	55                   	push   %rbp
  8008e9:	48 89 e5             	mov    %rsp,%rbp
  8008ec:	41 54                	push   %r12
  8008ee:	53                   	push   %rbx
  8008ef:	48 83 ec 60          	sub    $0x60,%rsp
  8008f3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008f7:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008fb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008ff:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800903:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800907:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80090b:	48 8b 0a             	mov    (%rdx),%rcx
  80090e:	48 89 08             	mov    %rcx,(%rax)
  800911:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800915:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800919:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80091d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  800921:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800925:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800929:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80092d:	0f b6 00             	movzbl (%rax),%eax
  800930:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  800933:	eb 29                	jmp    80095e <vprintfmt+0x76>
			if (ch == '\0')
  800935:	85 db                	test   %ebx,%ebx
  800937:	0f 84 ad 06 00 00    	je     800fea <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  80093d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800941:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800945:	48 89 d6             	mov    %rdx,%rsi
  800948:	89 df                	mov    %ebx,%edi
  80094a:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  80094c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800950:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800954:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800958:	0f b6 00             	movzbl (%rax),%eax
  80095b:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  80095e:	83 fb 25             	cmp    $0x25,%ebx
  800961:	74 05                	je     800968 <vprintfmt+0x80>
  800963:	83 fb 1b             	cmp    $0x1b,%ebx
  800966:	75 cd                	jne    800935 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800968:	83 fb 1b             	cmp    $0x1b,%ebx
  80096b:	0f 85 ae 01 00 00    	jne    800b1f <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  800971:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800978:	00 00 00 
  80097b:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  800981:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800985:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800989:	48 89 d6             	mov    %rdx,%rsi
  80098c:	89 df                	mov    %ebx,%edi
  80098e:	ff d0                	callq  *%rax
			putch('[', putdat);
  800990:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800994:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800998:	48 89 d6             	mov    %rdx,%rsi
  80099b:	bf 5b 00 00 00       	mov    $0x5b,%edi
  8009a0:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  8009a2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  8009a8:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8009ad:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009b1:	0f b6 00             	movzbl (%rax),%eax
  8009b4:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8009b7:	eb 32                	jmp    8009eb <vprintfmt+0x103>
					putch(ch, putdat);
  8009b9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009bd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c1:	48 89 d6             	mov    %rdx,%rsi
  8009c4:	89 df                	mov    %ebx,%edi
  8009c6:	ff d0                	callq  *%rax
					esc_color *= 10;
  8009c8:	44 89 e0             	mov    %r12d,%eax
  8009cb:	c1 e0 02             	shl    $0x2,%eax
  8009ce:	44 01 e0             	add    %r12d,%eax
  8009d1:	01 c0                	add    %eax,%eax
  8009d3:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  8009d6:	8d 43 d0             	lea    -0x30(%rbx),%eax
  8009d9:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  8009dc:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8009e1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009e5:	0f b6 00             	movzbl (%rax),%eax
  8009e8:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  8009eb:	83 fb 3b             	cmp    $0x3b,%ebx
  8009ee:	74 05                	je     8009f5 <vprintfmt+0x10d>
  8009f0:	83 fb 6d             	cmp    $0x6d,%ebx
  8009f3:	75 c4                	jne    8009b9 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  8009f5:	45 85 e4             	test   %r12d,%r12d
  8009f8:	75 15                	jne    800a0f <vprintfmt+0x127>
					color_flag = 0x07;
  8009fa:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800a01:	00 00 00 
  800a04:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800a0a:	e9 dc 00 00 00       	jmpq   800aeb <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800a0f:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800a13:	7e 69                	jle    800a7e <vprintfmt+0x196>
  800a15:	41 83 fc 25          	cmp    $0x25,%r12d
  800a19:	7f 63                	jg     800a7e <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800a1b:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800a22:	00 00 00 
  800a25:	8b 00                	mov    (%rax),%eax
  800a27:	25 f8 00 00 00       	and    $0xf8,%eax
  800a2c:	89 c2                	mov    %eax,%edx
  800a2e:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800a35:	00 00 00 
  800a38:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800a3a:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800a3e:	44 89 e0             	mov    %r12d,%eax
  800a41:	83 e0 04             	and    $0x4,%eax
  800a44:	c1 f8 02             	sar    $0x2,%eax
  800a47:	89 c2                	mov    %eax,%edx
  800a49:	44 89 e0             	mov    %r12d,%eax
  800a4c:	83 e0 02             	and    $0x2,%eax
  800a4f:	09 c2                	or     %eax,%edx
  800a51:	44 89 e0             	mov    %r12d,%eax
  800a54:	83 e0 01             	and    $0x1,%eax
  800a57:	c1 e0 02             	shl    $0x2,%eax
  800a5a:	09 c2                	or     %eax,%edx
  800a5c:	41 89 d4             	mov    %edx,%r12d
  800a5f:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800a66:	00 00 00 
  800a69:	8b 00                	mov    (%rax),%eax
  800a6b:	44 89 e2             	mov    %r12d,%edx
  800a6e:	09 c2                	or     %eax,%edx
  800a70:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800a77:	00 00 00 
  800a7a:	89 10                	mov    %edx,(%rax)
  800a7c:	eb 6d                	jmp    800aeb <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800a7e:	41 83 fc 27          	cmp    $0x27,%r12d
  800a82:	7e 67                	jle    800aeb <vprintfmt+0x203>
  800a84:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800a88:	7f 61                	jg     800aeb <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800a8a:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800a91:	00 00 00 
  800a94:	8b 00                	mov    (%rax),%eax
  800a96:	25 8f 00 00 00       	and    $0x8f,%eax
  800a9b:	89 c2                	mov    %eax,%edx
  800a9d:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800aa4:	00 00 00 
  800aa7:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800aa9:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800aad:	44 89 e0             	mov    %r12d,%eax
  800ab0:	83 e0 04             	and    $0x4,%eax
  800ab3:	c1 f8 02             	sar    $0x2,%eax
  800ab6:	89 c2                	mov    %eax,%edx
  800ab8:	44 89 e0             	mov    %r12d,%eax
  800abb:	83 e0 02             	and    $0x2,%eax
  800abe:	09 c2                	or     %eax,%edx
  800ac0:	44 89 e0             	mov    %r12d,%eax
  800ac3:	83 e0 01             	and    $0x1,%eax
  800ac6:	c1 e0 06             	shl    $0x6,%eax
  800ac9:	09 c2                	or     %eax,%edx
  800acb:	41 89 d4             	mov    %edx,%r12d
  800ace:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800ad5:	00 00 00 
  800ad8:	8b 00                	mov    (%rax),%eax
  800ada:	44 89 e2             	mov    %r12d,%edx
  800add:	09 c2                	or     %eax,%edx
  800adf:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800ae6:	00 00 00 
  800ae9:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800aeb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af3:	48 89 d6             	mov    %rdx,%rsi
  800af6:	89 df                	mov    %ebx,%edi
  800af8:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800afa:	83 fb 6d             	cmp    $0x6d,%ebx
  800afd:	75 1b                	jne    800b1a <vprintfmt+0x232>
					fmt ++;
  800aff:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800b04:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800b05:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800b0c:	00 00 00 
  800b0f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800b15:	e9 cb 04 00 00       	jmpq   800fe5 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800b1a:	e9 83 fe ff ff       	jmpq   8009a2 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800b1f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b23:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b2a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b31:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b38:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b3f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b43:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b47:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b4b:	0f b6 00             	movzbl (%rax),%eax
  800b4e:	0f b6 d8             	movzbl %al,%ebx
  800b51:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b54:	83 f8 55             	cmp    $0x55,%eax
  800b57:	0f 87 5a 04 00 00    	ja     800fb7 <vprintfmt+0x6cf>
  800b5d:	89 c0                	mov    %eax,%eax
  800b5f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b66:	00 
  800b67:	48 b8 90 3c 80 00 00 	movabs $0x803c90,%rax
  800b6e:	00 00 00 
  800b71:	48 01 d0             	add    %rdx,%rax
  800b74:	48 8b 00             	mov    (%rax),%rax
  800b77:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b79:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800b7d:	eb c0                	jmp    800b3f <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b7f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800b83:	eb ba                	jmp    800b3f <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b85:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b8c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b8f:	89 d0                	mov    %edx,%eax
  800b91:	c1 e0 02             	shl    $0x2,%eax
  800b94:	01 d0                	add    %edx,%eax
  800b96:	01 c0                	add    %eax,%eax
  800b98:	01 d8                	add    %ebx,%eax
  800b9a:	83 e8 30             	sub    $0x30,%eax
  800b9d:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ba0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ba4:	0f b6 00             	movzbl (%rax),%eax
  800ba7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800baa:	83 fb 2f             	cmp    $0x2f,%ebx
  800bad:	7e 0c                	jle    800bbb <vprintfmt+0x2d3>
  800baf:	83 fb 39             	cmp    $0x39,%ebx
  800bb2:	7f 07                	jg     800bbb <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bb4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bb9:	eb d1                	jmp    800b8c <vprintfmt+0x2a4>
			goto process_precision;
  800bbb:	eb 58                	jmp    800c15 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800bbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc0:	83 f8 30             	cmp    $0x30,%eax
  800bc3:	73 17                	jae    800bdc <vprintfmt+0x2f4>
  800bc5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcc:	89 c0                	mov    %eax,%eax
  800bce:	48 01 d0             	add    %rdx,%rax
  800bd1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd4:	83 c2 08             	add    $0x8,%edx
  800bd7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bda:	eb 0f                	jmp    800beb <vprintfmt+0x303>
  800bdc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be0:	48 89 d0             	mov    %rdx,%rax
  800be3:	48 83 c2 08          	add    $0x8,%rdx
  800be7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800beb:	8b 00                	mov    (%rax),%eax
  800bed:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800bf0:	eb 23                	jmp    800c15 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800bf2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bf6:	79 0c                	jns    800c04 <vprintfmt+0x31c>
				width = 0;
  800bf8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800bff:	e9 3b ff ff ff       	jmpq   800b3f <vprintfmt+0x257>
  800c04:	e9 36 ff ff ff       	jmpq   800b3f <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800c09:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c10:	e9 2a ff ff ff       	jmpq   800b3f <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800c15:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c19:	79 12                	jns    800c2d <vprintfmt+0x345>
				width = precision, precision = -1;
  800c1b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c1e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c21:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c28:	e9 12 ff ff ff       	jmpq   800b3f <vprintfmt+0x257>
  800c2d:	e9 0d ff ff ff       	jmpq   800b3f <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c32:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c36:	e9 04 ff ff ff       	jmpq   800b3f <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c3b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3e:	83 f8 30             	cmp    $0x30,%eax
  800c41:	73 17                	jae    800c5a <vprintfmt+0x372>
  800c43:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c47:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c4a:	89 c0                	mov    %eax,%eax
  800c4c:	48 01 d0             	add    %rdx,%rax
  800c4f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c52:	83 c2 08             	add    $0x8,%edx
  800c55:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c58:	eb 0f                	jmp    800c69 <vprintfmt+0x381>
  800c5a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c5e:	48 89 d0             	mov    %rdx,%rax
  800c61:	48 83 c2 08          	add    $0x8,%rdx
  800c65:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c69:	8b 10                	mov    (%rax),%edx
  800c6b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c73:	48 89 ce             	mov    %rcx,%rsi
  800c76:	89 d7                	mov    %edx,%edi
  800c78:	ff d0                	callq  *%rax
			break;
  800c7a:	e9 66 03 00 00       	jmpq   800fe5 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800c7f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c82:	83 f8 30             	cmp    $0x30,%eax
  800c85:	73 17                	jae    800c9e <vprintfmt+0x3b6>
  800c87:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c8b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8e:	89 c0                	mov    %eax,%eax
  800c90:	48 01 d0             	add    %rdx,%rax
  800c93:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c96:	83 c2 08             	add    $0x8,%edx
  800c99:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c9c:	eb 0f                	jmp    800cad <vprintfmt+0x3c5>
  800c9e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ca2:	48 89 d0             	mov    %rdx,%rax
  800ca5:	48 83 c2 08          	add    $0x8,%rdx
  800ca9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cad:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800caf:	85 db                	test   %ebx,%ebx
  800cb1:	79 02                	jns    800cb5 <vprintfmt+0x3cd>
				err = -err;
  800cb3:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cb5:	83 fb 10             	cmp    $0x10,%ebx
  800cb8:	7f 16                	jg     800cd0 <vprintfmt+0x3e8>
  800cba:	48 b8 e0 3b 80 00 00 	movabs $0x803be0,%rax
  800cc1:	00 00 00 
  800cc4:	48 63 d3             	movslq %ebx,%rdx
  800cc7:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ccb:	4d 85 e4             	test   %r12,%r12
  800cce:	75 2e                	jne    800cfe <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800cd0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cd4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd8:	89 d9                	mov    %ebx,%ecx
  800cda:	48 ba 79 3c 80 00 00 	movabs $0x803c79,%rdx
  800ce1:	00 00 00 
  800ce4:	48 89 c7             	mov    %rax,%rdi
  800ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cec:	49 b8 f3 0f 80 00 00 	movabs $0x800ff3,%r8
  800cf3:	00 00 00 
  800cf6:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cf9:	e9 e7 02 00 00       	jmpq   800fe5 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cfe:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d06:	4c 89 e1             	mov    %r12,%rcx
  800d09:	48 ba 82 3c 80 00 00 	movabs $0x803c82,%rdx
  800d10:	00 00 00 
  800d13:	48 89 c7             	mov    %rax,%rdi
  800d16:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1b:	49 b8 f3 0f 80 00 00 	movabs $0x800ff3,%r8
  800d22:	00 00 00 
  800d25:	41 ff d0             	callq  *%r8
			break;
  800d28:	e9 b8 02 00 00       	jmpq   800fe5 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d2d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d30:	83 f8 30             	cmp    $0x30,%eax
  800d33:	73 17                	jae    800d4c <vprintfmt+0x464>
  800d35:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d3c:	89 c0                	mov    %eax,%eax
  800d3e:	48 01 d0             	add    %rdx,%rax
  800d41:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d44:	83 c2 08             	add    $0x8,%edx
  800d47:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d4a:	eb 0f                	jmp    800d5b <vprintfmt+0x473>
  800d4c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d50:	48 89 d0             	mov    %rdx,%rax
  800d53:	48 83 c2 08          	add    $0x8,%rdx
  800d57:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d5b:	4c 8b 20             	mov    (%rax),%r12
  800d5e:	4d 85 e4             	test   %r12,%r12
  800d61:	75 0a                	jne    800d6d <vprintfmt+0x485>
				p = "(null)";
  800d63:	49 bc 85 3c 80 00 00 	movabs $0x803c85,%r12
  800d6a:	00 00 00 
			if (width > 0 && padc != '-')
  800d6d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d71:	7e 3f                	jle    800db2 <vprintfmt+0x4ca>
  800d73:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d77:	74 39                	je     800db2 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d79:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d7c:	48 98                	cltq   
  800d7e:	48 89 c6             	mov    %rax,%rsi
  800d81:	4c 89 e7             	mov    %r12,%rdi
  800d84:	48 b8 9f 12 80 00 00 	movabs $0x80129f,%rax
  800d8b:	00 00 00 
  800d8e:	ff d0                	callq  *%rax
  800d90:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d93:	eb 17                	jmp    800dac <vprintfmt+0x4c4>
					putch(padc, putdat);
  800d95:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d99:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800da1:	48 89 ce             	mov    %rcx,%rsi
  800da4:	89 d7                	mov    %edx,%edi
  800da6:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800da8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dac:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800db0:	7f e3                	jg     800d95 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800db2:	eb 37                	jmp    800deb <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800db4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800db8:	74 1e                	je     800dd8 <vprintfmt+0x4f0>
  800dba:	83 fb 1f             	cmp    $0x1f,%ebx
  800dbd:	7e 05                	jle    800dc4 <vprintfmt+0x4dc>
  800dbf:	83 fb 7e             	cmp    $0x7e,%ebx
  800dc2:	7e 14                	jle    800dd8 <vprintfmt+0x4f0>
					putch('?', putdat);
  800dc4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dcc:	48 89 d6             	mov    %rdx,%rsi
  800dcf:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800dd4:	ff d0                	callq  *%rax
  800dd6:	eb 0f                	jmp    800de7 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800dd8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ddc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de0:	48 89 d6             	mov    %rdx,%rsi
  800de3:	89 df                	mov    %ebx,%edi
  800de5:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800de7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800deb:	4c 89 e0             	mov    %r12,%rax
  800dee:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800df2:	0f b6 00             	movzbl (%rax),%eax
  800df5:	0f be d8             	movsbl %al,%ebx
  800df8:	85 db                	test   %ebx,%ebx
  800dfa:	74 10                	je     800e0c <vprintfmt+0x524>
  800dfc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e00:	78 b2                	js     800db4 <vprintfmt+0x4cc>
  800e02:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e06:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e0a:	79 a8                	jns    800db4 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e0c:	eb 16                	jmp    800e24 <vprintfmt+0x53c>
				putch(' ', putdat);
  800e0e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e16:	48 89 d6             	mov    %rdx,%rsi
  800e19:	bf 20 00 00 00       	mov    $0x20,%edi
  800e1e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e20:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e24:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e28:	7f e4                	jg     800e0e <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800e2a:	e9 b6 01 00 00       	jmpq   800fe5 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e2f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e33:	be 03 00 00 00       	mov    $0x3,%esi
  800e38:	48 89 c7             	mov    %rax,%rdi
  800e3b:	48 b8 d8 07 80 00 00 	movabs $0x8007d8,%rax
  800e42:	00 00 00 
  800e45:	ff d0                	callq  *%rax
  800e47:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4f:	48 85 c0             	test   %rax,%rax
  800e52:	79 1d                	jns    800e71 <vprintfmt+0x589>
				putch('-', putdat);
  800e54:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5c:	48 89 d6             	mov    %rdx,%rsi
  800e5f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e64:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6a:	48 f7 d8             	neg    %rax
  800e6d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e71:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e78:	e9 fb 00 00 00       	jmpq   800f78 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e7d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e81:	be 03 00 00 00       	mov    $0x3,%esi
  800e86:	48 89 c7             	mov    %rax,%rdi
  800e89:	48 b8 c8 06 80 00 00 	movabs $0x8006c8,%rax
  800e90:	00 00 00 
  800e93:	ff d0                	callq  *%rax
  800e95:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e99:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ea0:	e9 d3 00 00 00       	jmpq   800f78 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800ea5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ea9:	be 03 00 00 00       	mov    $0x3,%esi
  800eae:	48 89 c7             	mov    %rax,%rdi
  800eb1:	48 b8 d8 07 80 00 00 	movabs $0x8007d8,%rax
  800eb8:	00 00 00 
  800ebb:	ff d0                	callq  *%rax
  800ebd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ec1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec5:	48 85 c0             	test   %rax,%rax
  800ec8:	79 1d                	jns    800ee7 <vprintfmt+0x5ff>
				putch('-', putdat);
  800eca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ece:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed2:	48 89 d6             	mov    %rdx,%rsi
  800ed5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800eda:	ff d0                	callq  *%rax
				num = -(long long) num;
  800edc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee0:	48 f7 d8             	neg    %rax
  800ee3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800ee7:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800eee:	e9 85 00 00 00       	jmpq   800f78 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800ef3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efb:	48 89 d6             	mov    %rdx,%rsi
  800efe:	bf 30 00 00 00       	mov    $0x30,%edi
  800f03:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f0d:	48 89 d6             	mov    %rdx,%rsi
  800f10:	bf 78 00 00 00       	mov    $0x78,%edi
  800f15:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f17:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f1a:	83 f8 30             	cmp    $0x30,%eax
  800f1d:	73 17                	jae    800f36 <vprintfmt+0x64e>
  800f1f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f23:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f26:	89 c0                	mov    %eax,%eax
  800f28:	48 01 d0             	add    %rdx,%rax
  800f2b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f2e:	83 c2 08             	add    $0x8,%edx
  800f31:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f34:	eb 0f                	jmp    800f45 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800f36:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f3a:	48 89 d0             	mov    %rdx,%rax
  800f3d:	48 83 c2 08          	add    $0x8,%rdx
  800f41:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f45:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f48:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f4c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f53:	eb 23                	jmp    800f78 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f55:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f59:	be 03 00 00 00       	mov    $0x3,%esi
  800f5e:	48 89 c7             	mov    %rax,%rdi
  800f61:	48 b8 c8 06 80 00 00 	movabs $0x8006c8,%rax
  800f68:	00 00 00 
  800f6b:	ff d0                	callq  *%rax
  800f6d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f71:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f78:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f7d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f80:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f83:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f87:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f8f:	45 89 c1             	mov    %r8d,%r9d
  800f92:	41 89 f8             	mov    %edi,%r8d
  800f95:	48 89 c7             	mov    %rax,%rdi
  800f98:	48 b8 0d 06 80 00 00 	movabs $0x80060d,%rax
  800f9f:	00 00 00 
  800fa2:	ff d0                	callq  *%rax
			break;
  800fa4:	eb 3f                	jmp    800fe5 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fa6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800faa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fae:	48 89 d6             	mov    %rdx,%rsi
  800fb1:	89 df                	mov    %ebx,%edi
  800fb3:	ff d0                	callq  *%rax
			break;
  800fb5:	eb 2e                	jmp    800fe5 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fb7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fbb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fbf:	48 89 d6             	mov    %rdx,%rsi
  800fc2:	bf 25 00 00 00       	mov    $0x25,%edi
  800fc7:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fc9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fce:	eb 05                	jmp    800fd5 <vprintfmt+0x6ed>
  800fd0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fd5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fd9:	48 83 e8 01          	sub    $0x1,%rax
  800fdd:	0f b6 00             	movzbl (%rax),%eax
  800fe0:	3c 25                	cmp    $0x25,%al
  800fe2:	75 ec                	jne    800fd0 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  800fe4:	90                   	nop
		}
	}
  800fe5:	e9 37 f9 ff ff       	jmpq   800921 <vprintfmt+0x39>
    va_end(aq);
}
  800fea:	48 83 c4 60          	add    $0x60,%rsp
  800fee:	5b                   	pop    %rbx
  800fef:	41 5c                	pop    %r12
  800ff1:	5d                   	pop    %rbp
  800ff2:	c3                   	retq   

0000000000800ff3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ff3:	55                   	push   %rbp
  800ff4:	48 89 e5             	mov    %rsp,%rbp
  800ff7:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ffe:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801005:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80100c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801013:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80101a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801021:	84 c0                	test   %al,%al
  801023:	74 20                	je     801045 <printfmt+0x52>
  801025:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801029:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80102d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801031:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801035:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801039:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80103d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801041:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801045:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80104c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801053:	00 00 00 
  801056:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80105d:	00 00 00 
  801060:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801064:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80106b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801072:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801079:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801080:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801087:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80108e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801095:	48 89 c7             	mov    %rax,%rdi
  801098:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  80109f:	00 00 00 
  8010a2:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010a4:	c9                   	leaveq 
  8010a5:	c3                   	retq   

00000000008010a6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010a6:	55                   	push   %rbp
  8010a7:	48 89 e5             	mov    %rsp,%rbp
  8010aa:	48 83 ec 10          	sub    $0x10,%rsp
  8010ae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b9:	8b 40 10             	mov    0x10(%rax),%eax
  8010bc:	8d 50 01             	lea    0x1(%rax),%edx
  8010bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c3:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ca:	48 8b 10             	mov    (%rax),%rdx
  8010cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010d5:	48 39 c2             	cmp    %rax,%rdx
  8010d8:	73 17                	jae    8010f1 <sprintputch+0x4b>
		*b->buf++ = ch;
  8010da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010de:	48 8b 00             	mov    (%rax),%rax
  8010e1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8010e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010e9:	48 89 0a             	mov    %rcx,(%rdx)
  8010ec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010ef:	88 10                	mov    %dl,(%rax)
}
  8010f1:	c9                   	leaveq 
  8010f2:	c3                   	retq   

00000000008010f3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010f3:	55                   	push   %rbp
  8010f4:	48 89 e5             	mov    %rsp,%rbp
  8010f7:	48 83 ec 50          	sub    $0x50,%rsp
  8010fb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8010ff:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801102:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801106:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80110a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80110e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801112:	48 8b 0a             	mov    (%rdx),%rcx
  801115:	48 89 08             	mov    %rcx,(%rax)
  801118:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80111c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801120:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801124:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801128:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80112c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801130:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801133:	48 98                	cltq   
  801135:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801139:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80113d:	48 01 d0             	add    %rdx,%rax
  801140:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801144:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80114b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801150:	74 06                	je     801158 <vsnprintf+0x65>
  801152:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801156:	7f 07                	jg     80115f <vsnprintf+0x6c>
		return -E_INVAL;
  801158:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115d:	eb 2f                	jmp    80118e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80115f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801163:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801167:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80116b:	48 89 c6             	mov    %rax,%rsi
  80116e:	48 bf a6 10 80 00 00 	movabs $0x8010a6,%rdi
  801175:	00 00 00 
  801178:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  80117f:	00 00 00 
  801182:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801184:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801188:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80118b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80118e:	c9                   	leaveq 
  80118f:	c3                   	retq   

0000000000801190 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801190:	55                   	push   %rbp
  801191:	48 89 e5             	mov    %rsp,%rbp
  801194:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80119b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011a2:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011a8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011af:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011b6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011bd:	84 c0                	test   %al,%al
  8011bf:	74 20                	je     8011e1 <snprintf+0x51>
  8011c1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011c5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011c9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011cd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011d1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011d5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011d9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011dd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8011e1:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8011e8:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8011ef:	00 00 00 
  8011f2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011f9:	00 00 00 
  8011fc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801200:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801207:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80120e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801215:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80121c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801223:	48 8b 0a             	mov    (%rdx),%rcx
  801226:	48 89 08             	mov    %rcx,(%rax)
  801229:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80122d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801231:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801235:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801239:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801240:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801247:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80124d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801254:	48 89 c7             	mov    %rax,%rdi
  801257:	48 b8 f3 10 80 00 00 	movabs $0x8010f3,%rax
  80125e:	00 00 00 
  801261:	ff d0                	callq  *%rax
  801263:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801269:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80126f:	c9                   	leaveq 
  801270:	c3                   	retq   

0000000000801271 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801271:	55                   	push   %rbp
  801272:	48 89 e5             	mov    %rsp,%rbp
  801275:	48 83 ec 18          	sub    $0x18,%rsp
  801279:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80127d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801284:	eb 09                	jmp    80128f <strlen+0x1e>
		n++;
  801286:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80128a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80128f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801293:	0f b6 00             	movzbl (%rax),%eax
  801296:	84 c0                	test   %al,%al
  801298:	75 ec                	jne    801286 <strlen+0x15>
		n++;
	return n;
  80129a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80129d:	c9                   	leaveq 
  80129e:	c3                   	retq   

000000000080129f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80129f:	55                   	push   %rbp
  8012a0:	48 89 e5             	mov    %rsp,%rbp
  8012a3:	48 83 ec 20          	sub    $0x20,%rsp
  8012a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012b6:	eb 0e                	jmp    8012c6 <strnlen+0x27>
		n++;
  8012b8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012bc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012c1:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012c6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012cb:	74 0b                	je     8012d8 <strnlen+0x39>
  8012cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d1:	0f b6 00             	movzbl (%rax),%eax
  8012d4:	84 c0                	test   %al,%al
  8012d6:	75 e0                	jne    8012b8 <strnlen+0x19>
		n++;
	return n;
  8012d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012db:	c9                   	leaveq 
  8012dc:	c3                   	retq   

00000000008012dd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012dd:	55                   	push   %rbp
  8012de:	48 89 e5             	mov    %rsp,%rbp
  8012e1:	48 83 ec 20          	sub    $0x20,%rsp
  8012e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8012ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8012f5:	90                   	nop
  8012f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012fe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801302:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801306:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80130a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80130e:	0f b6 12             	movzbl (%rdx),%edx
  801311:	88 10                	mov    %dl,(%rax)
  801313:	0f b6 00             	movzbl (%rax),%eax
  801316:	84 c0                	test   %al,%al
  801318:	75 dc                	jne    8012f6 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80131a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80131e:	c9                   	leaveq 
  80131f:	c3                   	retq   

0000000000801320 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801320:	55                   	push   %rbp
  801321:	48 89 e5             	mov    %rsp,%rbp
  801324:	48 83 ec 20          	sub    $0x20,%rsp
  801328:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80132c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801330:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801334:	48 89 c7             	mov    %rax,%rdi
  801337:	48 b8 71 12 80 00 00 	movabs $0x801271,%rax
  80133e:	00 00 00 
  801341:	ff d0                	callq  *%rax
  801343:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801346:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801349:	48 63 d0             	movslq %eax,%rdx
  80134c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801350:	48 01 c2             	add    %rax,%rdx
  801353:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801357:	48 89 c6             	mov    %rax,%rsi
  80135a:	48 89 d7             	mov    %rdx,%rdi
  80135d:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  801364:	00 00 00 
  801367:	ff d0                	callq  *%rax
	return dst;
  801369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80136d:	c9                   	leaveq 
  80136e:	c3                   	retq   

000000000080136f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80136f:	55                   	push   %rbp
  801370:	48 89 e5             	mov    %rsp,%rbp
  801373:	48 83 ec 28          	sub    $0x28,%rsp
  801377:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80137b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80137f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801383:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801387:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80138b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801392:	00 
  801393:	eb 2a                	jmp    8013bf <strncpy+0x50>
		*dst++ = *src;
  801395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801399:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80139d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013a1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013a5:	0f b6 12             	movzbl (%rdx),%edx
  8013a8:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013ae:	0f b6 00             	movzbl (%rax),%eax
  8013b1:	84 c0                	test   %al,%al
  8013b3:	74 05                	je     8013ba <strncpy+0x4b>
			src++;
  8013b5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013c7:	72 cc                	jb     801395 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013cd:	c9                   	leaveq 
  8013ce:	c3                   	retq   

00000000008013cf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013cf:	55                   	push   %rbp
  8013d0:	48 89 e5             	mov    %rsp,%rbp
  8013d3:	48 83 ec 28          	sub    $0x28,%rsp
  8013d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8013eb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013f0:	74 3d                	je     80142f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8013f2:	eb 1d                	jmp    801411 <strlcpy+0x42>
			*dst++ = *src++;
  8013f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801400:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801404:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801408:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80140c:	0f b6 12             	movzbl (%rdx),%edx
  80140f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801411:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801416:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80141b:	74 0b                	je     801428 <strlcpy+0x59>
  80141d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801421:	0f b6 00             	movzbl (%rax),%eax
  801424:	84 c0                	test   %al,%al
  801426:	75 cc                	jne    8013f4 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801428:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80142f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801433:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801437:	48 29 c2             	sub    %rax,%rdx
  80143a:	48 89 d0             	mov    %rdx,%rax
}
  80143d:	c9                   	leaveq 
  80143e:	c3                   	retq   

000000000080143f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80143f:	55                   	push   %rbp
  801440:	48 89 e5             	mov    %rsp,%rbp
  801443:	48 83 ec 10          	sub    $0x10,%rsp
  801447:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80144b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80144f:	eb 0a                	jmp    80145b <strcmp+0x1c>
		p++, q++;
  801451:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801456:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80145b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145f:	0f b6 00             	movzbl (%rax),%eax
  801462:	84 c0                	test   %al,%al
  801464:	74 12                	je     801478 <strcmp+0x39>
  801466:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146a:	0f b6 10             	movzbl (%rax),%edx
  80146d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801471:	0f b6 00             	movzbl (%rax),%eax
  801474:	38 c2                	cmp    %al,%dl
  801476:	74 d9                	je     801451 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801478:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147c:	0f b6 00             	movzbl (%rax),%eax
  80147f:	0f b6 d0             	movzbl %al,%edx
  801482:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801486:	0f b6 00             	movzbl (%rax),%eax
  801489:	0f b6 c0             	movzbl %al,%eax
  80148c:	29 c2                	sub    %eax,%edx
  80148e:	89 d0                	mov    %edx,%eax
}
  801490:	c9                   	leaveq 
  801491:	c3                   	retq   

0000000000801492 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801492:	55                   	push   %rbp
  801493:	48 89 e5             	mov    %rsp,%rbp
  801496:	48 83 ec 18          	sub    $0x18,%rsp
  80149a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80149e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014a2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014a6:	eb 0f                	jmp    8014b7 <strncmp+0x25>
		n--, p++, q++;
  8014a8:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014ad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014b2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014bc:	74 1d                	je     8014db <strncmp+0x49>
  8014be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c2:	0f b6 00             	movzbl (%rax),%eax
  8014c5:	84 c0                	test   %al,%al
  8014c7:	74 12                	je     8014db <strncmp+0x49>
  8014c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cd:	0f b6 10             	movzbl (%rax),%edx
  8014d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d4:	0f b6 00             	movzbl (%rax),%eax
  8014d7:	38 c2                	cmp    %al,%dl
  8014d9:	74 cd                	je     8014a8 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014db:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014e0:	75 07                	jne    8014e9 <strncmp+0x57>
		return 0;
  8014e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e7:	eb 18                	jmp    801501 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ed:	0f b6 00             	movzbl (%rax),%eax
  8014f0:	0f b6 d0             	movzbl %al,%edx
  8014f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f7:	0f b6 00             	movzbl (%rax),%eax
  8014fa:	0f b6 c0             	movzbl %al,%eax
  8014fd:	29 c2                	sub    %eax,%edx
  8014ff:	89 d0                	mov    %edx,%eax
}
  801501:	c9                   	leaveq 
  801502:	c3                   	retq   

0000000000801503 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801503:	55                   	push   %rbp
  801504:	48 89 e5             	mov    %rsp,%rbp
  801507:	48 83 ec 0c          	sub    $0xc,%rsp
  80150b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80150f:	89 f0                	mov    %esi,%eax
  801511:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801514:	eb 17                	jmp    80152d <strchr+0x2a>
		if (*s == c)
  801516:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151a:	0f b6 00             	movzbl (%rax),%eax
  80151d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801520:	75 06                	jne    801528 <strchr+0x25>
			return (char *) s;
  801522:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801526:	eb 15                	jmp    80153d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801528:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80152d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801531:	0f b6 00             	movzbl (%rax),%eax
  801534:	84 c0                	test   %al,%al
  801536:	75 de                	jne    801516 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801538:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153d:	c9                   	leaveq 
  80153e:	c3                   	retq   

000000000080153f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80153f:	55                   	push   %rbp
  801540:	48 89 e5             	mov    %rsp,%rbp
  801543:	48 83 ec 0c          	sub    $0xc,%rsp
  801547:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80154b:	89 f0                	mov    %esi,%eax
  80154d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801550:	eb 13                	jmp    801565 <strfind+0x26>
		if (*s == c)
  801552:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801556:	0f b6 00             	movzbl (%rax),%eax
  801559:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80155c:	75 02                	jne    801560 <strfind+0x21>
			break;
  80155e:	eb 10                	jmp    801570 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801560:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801565:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801569:	0f b6 00             	movzbl (%rax),%eax
  80156c:	84 c0                	test   %al,%al
  80156e:	75 e2                	jne    801552 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801574:	c9                   	leaveq 
  801575:	c3                   	retq   

0000000000801576 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801576:	55                   	push   %rbp
  801577:	48 89 e5             	mov    %rsp,%rbp
  80157a:	48 83 ec 18          	sub    $0x18,%rsp
  80157e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801582:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801585:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801589:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80158e:	75 06                	jne    801596 <memset+0x20>
		return v;
  801590:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801594:	eb 69                	jmp    8015ff <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801596:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159a:	83 e0 03             	and    $0x3,%eax
  80159d:	48 85 c0             	test   %rax,%rax
  8015a0:	75 48                	jne    8015ea <memset+0x74>
  8015a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a6:	83 e0 03             	and    $0x3,%eax
  8015a9:	48 85 c0             	test   %rax,%rax
  8015ac:	75 3c                	jne    8015ea <memset+0x74>
		c &= 0xFF;
  8015ae:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015b8:	c1 e0 18             	shl    $0x18,%eax
  8015bb:	89 c2                	mov    %eax,%edx
  8015bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015c0:	c1 e0 10             	shl    $0x10,%eax
  8015c3:	09 c2                	or     %eax,%edx
  8015c5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015c8:	c1 e0 08             	shl    $0x8,%eax
  8015cb:	09 d0                	or     %edx,%eax
  8015cd:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8015d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d4:	48 c1 e8 02          	shr    $0x2,%rax
  8015d8:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015db:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e2:	48 89 d7             	mov    %rdx,%rdi
  8015e5:	fc                   	cld    
  8015e6:	f3 ab                	rep stos %eax,%es:(%rdi)
  8015e8:	eb 11                	jmp    8015fb <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015ea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015f1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015f5:	48 89 d7             	mov    %rdx,%rdi
  8015f8:	fc                   	cld    
  8015f9:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8015fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015ff:	c9                   	leaveq 
  801600:	c3                   	retq   

0000000000801601 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801601:	55                   	push   %rbp
  801602:	48 89 e5             	mov    %rsp,%rbp
  801605:	48 83 ec 28          	sub    $0x28,%rsp
  801609:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80160d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801611:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801615:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801619:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80161d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801621:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801625:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801629:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80162d:	0f 83 88 00 00 00    	jae    8016bb <memmove+0xba>
  801633:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801637:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80163b:	48 01 d0             	add    %rdx,%rax
  80163e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801642:	76 77                	jbe    8016bb <memmove+0xba>
		s += n;
  801644:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801648:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80164c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801650:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801654:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801658:	83 e0 03             	and    $0x3,%eax
  80165b:	48 85 c0             	test   %rax,%rax
  80165e:	75 3b                	jne    80169b <memmove+0x9a>
  801660:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801664:	83 e0 03             	and    $0x3,%eax
  801667:	48 85 c0             	test   %rax,%rax
  80166a:	75 2f                	jne    80169b <memmove+0x9a>
  80166c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801670:	83 e0 03             	and    $0x3,%eax
  801673:	48 85 c0             	test   %rax,%rax
  801676:	75 23                	jne    80169b <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801678:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167c:	48 83 e8 04          	sub    $0x4,%rax
  801680:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801684:	48 83 ea 04          	sub    $0x4,%rdx
  801688:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80168c:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801690:	48 89 c7             	mov    %rax,%rdi
  801693:	48 89 d6             	mov    %rdx,%rsi
  801696:	fd                   	std    
  801697:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801699:	eb 1d                	jmp    8016b8 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80169b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a7:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016af:	48 89 d7             	mov    %rdx,%rdi
  8016b2:	48 89 c1             	mov    %rax,%rcx
  8016b5:	fd                   	std    
  8016b6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016b8:	fc                   	cld    
  8016b9:	eb 57                	jmp    801712 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016bf:	83 e0 03             	and    $0x3,%eax
  8016c2:	48 85 c0             	test   %rax,%rax
  8016c5:	75 36                	jne    8016fd <memmove+0xfc>
  8016c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016cb:	83 e0 03             	and    $0x3,%eax
  8016ce:	48 85 c0             	test   %rax,%rax
  8016d1:	75 2a                	jne    8016fd <memmove+0xfc>
  8016d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d7:	83 e0 03             	and    $0x3,%eax
  8016da:	48 85 c0             	test   %rax,%rax
  8016dd:	75 1e                	jne    8016fd <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e3:	48 c1 e8 02          	shr    $0x2,%rax
  8016e7:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016f2:	48 89 c7             	mov    %rax,%rdi
  8016f5:	48 89 d6             	mov    %rdx,%rsi
  8016f8:	fc                   	cld    
  8016f9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016fb:	eb 15                	jmp    801712 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8016fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801701:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801705:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801709:	48 89 c7             	mov    %rax,%rdi
  80170c:	48 89 d6             	mov    %rdx,%rsi
  80170f:	fc                   	cld    
  801710:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801712:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801716:	c9                   	leaveq 
  801717:	c3                   	retq   

0000000000801718 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801718:	55                   	push   %rbp
  801719:	48 89 e5             	mov    %rsp,%rbp
  80171c:	48 83 ec 18          	sub    $0x18,%rsp
  801720:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801724:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801728:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80172c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801730:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801734:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801738:	48 89 ce             	mov    %rcx,%rsi
  80173b:	48 89 c7             	mov    %rax,%rdi
  80173e:	48 b8 01 16 80 00 00 	movabs $0x801601,%rax
  801745:	00 00 00 
  801748:	ff d0                	callq  *%rax
}
  80174a:	c9                   	leaveq 
  80174b:	c3                   	retq   

000000000080174c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80174c:	55                   	push   %rbp
  80174d:	48 89 e5             	mov    %rsp,%rbp
  801750:	48 83 ec 28          	sub    $0x28,%rsp
  801754:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801758:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80175c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801764:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801768:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80176c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801770:	eb 36                	jmp    8017a8 <memcmp+0x5c>
		if (*s1 != *s2)
  801772:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801776:	0f b6 10             	movzbl (%rax),%edx
  801779:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177d:	0f b6 00             	movzbl (%rax),%eax
  801780:	38 c2                	cmp    %al,%dl
  801782:	74 1a                	je     80179e <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801784:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801788:	0f b6 00             	movzbl (%rax),%eax
  80178b:	0f b6 d0             	movzbl %al,%edx
  80178e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801792:	0f b6 00             	movzbl (%rax),%eax
  801795:	0f b6 c0             	movzbl %al,%eax
  801798:	29 c2                	sub    %eax,%edx
  80179a:	89 d0                	mov    %edx,%eax
  80179c:	eb 20                	jmp    8017be <memcmp+0x72>
		s1++, s2++;
  80179e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017a3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ac:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017b4:	48 85 c0             	test   %rax,%rax
  8017b7:	75 b9                	jne    801772 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017be:	c9                   	leaveq 
  8017bf:	c3                   	retq   

00000000008017c0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017c0:	55                   	push   %rbp
  8017c1:	48 89 e5             	mov    %rsp,%rbp
  8017c4:	48 83 ec 28          	sub    $0x28,%rsp
  8017c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017cc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017cf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017db:	48 01 d0             	add    %rdx,%rax
  8017de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017e2:	eb 15                	jmp    8017f9 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e8:	0f b6 10             	movzbl (%rax),%edx
  8017eb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017ee:	38 c2                	cmp    %al,%dl
  8017f0:	75 02                	jne    8017f4 <memfind+0x34>
			break;
  8017f2:	eb 0f                	jmp    801803 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017f4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017fd:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801801:	72 e1                	jb     8017e4 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801803:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801807:	c9                   	leaveq 
  801808:	c3                   	retq   

0000000000801809 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801809:	55                   	push   %rbp
  80180a:	48 89 e5             	mov    %rsp,%rbp
  80180d:	48 83 ec 34          	sub    $0x34,%rsp
  801811:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801815:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801819:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80181c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801823:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80182a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80182b:	eb 05                	jmp    801832 <strtol+0x29>
		s++;
  80182d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801832:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801836:	0f b6 00             	movzbl (%rax),%eax
  801839:	3c 20                	cmp    $0x20,%al
  80183b:	74 f0                	je     80182d <strtol+0x24>
  80183d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801841:	0f b6 00             	movzbl (%rax),%eax
  801844:	3c 09                	cmp    $0x9,%al
  801846:	74 e5                	je     80182d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801848:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184c:	0f b6 00             	movzbl (%rax),%eax
  80184f:	3c 2b                	cmp    $0x2b,%al
  801851:	75 07                	jne    80185a <strtol+0x51>
		s++;
  801853:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801858:	eb 17                	jmp    801871 <strtol+0x68>
	else if (*s == '-')
  80185a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185e:	0f b6 00             	movzbl (%rax),%eax
  801861:	3c 2d                	cmp    $0x2d,%al
  801863:	75 0c                	jne    801871 <strtol+0x68>
		s++, neg = 1;
  801865:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80186a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801871:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801875:	74 06                	je     80187d <strtol+0x74>
  801877:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80187b:	75 28                	jne    8018a5 <strtol+0x9c>
  80187d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801881:	0f b6 00             	movzbl (%rax),%eax
  801884:	3c 30                	cmp    $0x30,%al
  801886:	75 1d                	jne    8018a5 <strtol+0x9c>
  801888:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188c:	48 83 c0 01          	add    $0x1,%rax
  801890:	0f b6 00             	movzbl (%rax),%eax
  801893:	3c 78                	cmp    $0x78,%al
  801895:	75 0e                	jne    8018a5 <strtol+0x9c>
		s += 2, base = 16;
  801897:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80189c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018a3:	eb 2c                	jmp    8018d1 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018a5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018a9:	75 19                	jne    8018c4 <strtol+0xbb>
  8018ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018af:	0f b6 00             	movzbl (%rax),%eax
  8018b2:	3c 30                	cmp    $0x30,%al
  8018b4:	75 0e                	jne    8018c4 <strtol+0xbb>
		s++, base = 8;
  8018b6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018bb:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018c2:	eb 0d                	jmp    8018d1 <strtol+0xc8>
	else if (base == 0)
  8018c4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018c8:	75 07                	jne    8018d1 <strtol+0xc8>
		base = 10;
  8018ca:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d5:	0f b6 00             	movzbl (%rax),%eax
  8018d8:	3c 2f                	cmp    $0x2f,%al
  8018da:	7e 1d                	jle    8018f9 <strtol+0xf0>
  8018dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e0:	0f b6 00             	movzbl (%rax),%eax
  8018e3:	3c 39                	cmp    $0x39,%al
  8018e5:	7f 12                	jg     8018f9 <strtol+0xf0>
			dig = *s - '0';
  8018e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018eb:	0f b6 00             	movzbl (%rax),%eax
  8018ee:	0f be c0             	movsbl %al,%eax
  8018f1:	83 e8 30             	sub    $0x30,%eax
  8018f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018f7:	eb 4e                	jmp    801947 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8018f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fd:	0f b6 00             	movzbl (%rax),%eax
  801900:	3c 60                	cmp    $0x60,%al
  801902:	7e 1d                	jle    801921 <strtol+0x118>
  801904:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801908:	0f b6 00             	movzbl (%rax),%eax
  80190b:	3c 7a                	cmp    $0x7a,%al
  80190d:	7f 12                	jg     801921 <strtol+0x118>
			dig = *s - 'a' + 10;
  80190f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801913:	0f b6 00             	movzbl (%rax),%eax
  801916:	0f be c0             	movsbl %al,%eax
  801919:	83 e8 57             	sub    $0x57,%eax
  80191c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80191f:	eb 26                	jmp    801947 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801921:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801925:	0f b6 00             	movzbl (%rax),%eax
  801928:	3c 40                	cmp    $0x40,%al
  80192a:	7e 48                	jle    801974 <strtol+0x16b>
  80192c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801930:	0f b6 00             	movzbl (%rax),%eax
  801933:	3c 5a                	cmp    $0x5a,%al
  801935:	7f 3d                	jg     801974 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801937:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193b:	0f b6 00             	movzbl (%rax),%eax
  80193e:	0f be c0             	movsbl %al,%eax
  801941:	83 e8 37             	sub    $0x37,%eax
  801944:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801947:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80194a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80194d:	7c 02                	jl     801951 <strtol+0x148>
			break;
  80194f:	eb 23                	jmp    801974 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801951:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801956:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801959:	48 98                	cltq   
  80195b:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801960:	48 89 c2             	mov    %rax,%rdx
  801963:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801966:	48 98                	cltq   
  801968:	48 01 d0             	add    %rdx,%rax
  80196b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80196f:	e9 5d ff ff ff       	jmpq   8018d1 <strtol+0xc8>

	if (endptr)
  801974:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801979:	74 0b                	je     801986 <strtol+0x17d>
		*endptr = (char *) s;
  80197b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80197f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801983:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801986:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80198a:	74 09                	je     801995 <strtol+0x18c>
  80198c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801990:	48 f7 d8             	neg    %rax
  801993:	eb 04                	jmp    801999 <strtol+0x190>
  801995:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801999:	c9                   	leaveq 
  80199a:	c3                   	retq   

000000000080199b <strstr>:

char * strstr(const char *in, const char *str)
{
  80199b:	55                   	push   %rbp
  80199c:	48 89 e5             	mov    %rsp,%rbp
  80199f:	48 83 ec 30          	sub    $0x30,%rsp
  8019a3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019a7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8019ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019af:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019b3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019b7:	0f b6 00             	movzbl (%rax),%eax
  8019ba:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8019bd:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019c1:	75 06                	jne    8019c9 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8019c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c7:	eb 6b                	jmp    801a34 <strstr+0x99>

    len = strlen(str);
  8019c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019cd:	48 89 c7             	mov    %rax,%rdi
  8019d0:	48 b8 71 12 80 00 00 	movabs $0x801271,%rax
  8019d7:	00 00 00 
  8019da:	ff d0                	callq  *%rax
  8019dc:	48 98                	cltq   
  8019de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8019e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019ee:	0f b6 00             	movzbl (%rax),%eax
  8019f1:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8019f4:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8019f8:	75 07                	jne    801a01 <strstr+0x66>
                return (char *) 0;
  8019fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ff:	eb 33                	jmp    801a34 <strstr+0x99>
        } while (sc != c);
  801a01:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a05:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a08:	75 d8                	jne    8019e2 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801a0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a16:	48 89 ce             	mov    %rcx,%rsi
  801a19:	48 89 c7             	mov    %rax,%rdi
  801a1c:	48 b8 92 14 80 00 00 	movabs $0x801492,%rax
  801a23:	00 00 00 
  801a26:	ff d0                	callq  *%rax
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	75 b6                	jne    8019e2 <strstr+0x47>

    return (char *) (in - 1);
  801a2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a30:	48 83 e8 01          	sub    $0x1,%rax
}
  801a34:	c9                   	leaveq 
  801a35:	c3                   	retq   

0000000000801a36 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801a36:	55                   	push   %rbp
  801a37:	48 89 e5             	mov    %rsp,%rbp
  801a3a:	53                   	push   %rbx
  801a3b:	48 83 ec 48          	sub    $0x48,%rsp
  801a3f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801a42:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801a45:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a49:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801a4d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801a51:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a55:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a58:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801a5c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801a60:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801a64:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801a68:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801a6c:	4c 89 c3             	mov    %r8,%rbx
  801a6f:	cd 30                	int    $0x30
  801a71:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801a75:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801a79:	74 3e                	je     801ab9 <syscall+0x83>
  801a7b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a80:	7e 37                	jle    801ab9 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a82:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a86:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a89:	49 89 d0             	mov    %rdx,%r8
  801a8c:	89 c1                	mov    %eax,%ecx
  801a8e:	48 ba 40 3f 80 00 00 	movabs $0x803f40,%rdx
  801a95:	00 00 00 
  801a98:	be 23 00 00 00       	mov    $0x23,%esi
  801a9d:	48 bf 5d 3f 80 00 00 	movabs $0x803f5d,%rdi
  801aa4:	00 00 00 
  801aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  801aac:	49 b9 fc 02 80 00 00 	movabs $0x8002fc,%r9
  801ab3:	00 00 00 
  801ab6:	41 ff d1             	callq  *%r9

	return ret;
  801ab9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801abd:	48 83 c4 48          	add    $0x48,%rsp
  801ac1:	5b                   	pop    %rbx
  801ac2:	5d                   	pop    %rbp
  801ac3:	c3                   	retq   

0000000000801ac4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801ac4:	55                   	push   %rbp
  801ac5:	48 89 e5             	mov    %rsp,%rbp
  801ac8:	48 83 ec 20          	sub    $0x20,%rsp
  801acc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ad0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801ad4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801adc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae3:	00 
  801ae4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af0:	48 89 d1             	mov    %rdx,%rcx
  801af3:	48 89 c2             	mov    %rax,%rdx
  801af6:	be 00 00 00 00       	mov    $0x0,%esi
  801afb:	bf 00 00 00 00       	mov    $0x0,%edi
  801b00:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  801b07:	00 00 00 
  801b0a:	ff d0                	callq  *%rax
}
  801b0c:	c9                   	leaveq 
  801b0d:	c3                   	retq   

0000000000801b0e <sys_cgetc>:

int
sys_cgetc(void)
{
  801b0e:	55                   	push   %rbp
  801b0f:	48 89 e5             	mov    %rsp,%rbp
  801b12:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801b16:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b1d:	00 
  801b1e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b24:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b34:	be 00 00 00 00       	mov    $0x0,%esi
  801b39:	bf 01 00 00 00       	mov    $0x1,%edi
  801b3e:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  801b45:	00 00 00 
  801b48:	ff d0                	callq  *%rax
}
  801b4a:	c9                   	leaveq 
  801b4b:	c3                   	retq   

0000000000801b4c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801b4c:	55                   	push   %rbp
  801b4d:	48 89 e5             	mov    %rsp,%rbp
  801b50:	48 83 ec 10          	sub    $0x10,%rsp
  801b54:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801b57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5a:	48 98                	cltq   
  801b5c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b63:	00 
  801b64:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b6a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b70:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b75:	48 89 c2             	mov    %rax,%rdx
  801b78:	be 01 00 00 00       	mov    $0x1,%esi
  801b7d:	bf 03 00 00 00       	mov    $0x3,%edi
  801b82:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  801b89:	00 00 00 
  801b8c:	ff d0                	callq  *%rax
}
  801b8e:	c9                   	leaveq 
  801b8f:	c3                   	retq   

0000000000801b90 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801b90:	55                   	push   %rbp
  801b91:	48 89 e5             	mov    %rsp,%rbp
  801b94:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801b98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b9f:	00 
  801ba0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bac:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bb1:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb6:	be 00 00 00 00       	mov    $0x0,%esi
  801bbb:	bf 02 00 00 00       	mov    $0x2,%edi
  801bc0:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  801bc7:	00 00 00 
  801bca:	ff d0                	callq  *%rax
}
  801bcc:	c9                   	leaveq 
  801bcd:	c3                   	retq   

0000000000801bce <sys_yield>:

void
sys_yield(void)
{
  801bce:	55                   	push   %rbp
  801bcf:	48 89 e5             	mov    %rsp,%rbp
  801bd2:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801bd6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bdd:	00 
  801bde:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bea:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bef:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf4:	be 00 00 00 00       	mov    $0x0,%esi
  801bf9:	bf 0b 00 00 00       	mov    $0xb,%edi
  801bfe:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  801c05:	00 00 00 
  801c08:	ff d0                	callq  *%rax
}
  801c0a:	c9                   	leaveq 
  801c0b:	c3                   	retq   

0000000000801c0c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801c0c:	55                   	push   %rbp
  801c0d:	48 89 e5             	mov    %rsp,%rbp
  801c10:	48 83 ec 20          	sub    $0x20,%rsp
  801c14:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c17:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c1b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801c1e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c21:	48 63 c8             	movslq %eax,%rcx
  801c24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c2b:	48 98                	cltq   
  801c2d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c34:	00 
  801c35:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c3b:	49 89 c8             	mov    %rcx,%r8
  801c3e:	48 89 d1             	mov    %rdx,%rcx
  801c41:	48 89 c2             	mov    %rax,%rdx
  801c44:	be 01 00 00 00       	mov    $0x1,%esi
  801c49:	bf 04 00 00 00       	mov    $0x4,%edi
  801c4e:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  801c55:	00 00 00 
  801c58:	ff d0                	callq  *%rax
}
  801c5a:	c9                   	leaveq 
  801c5b:	c3                   	retq   

0000000000801c5c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801c5c:	55                   	push   %rbp
  801c5d:	48 89 e5             	mov    %rsp,%rbp
  801c60:	48 83 ec 30          	sub    $0x30,%rsp
  801c64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c6b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c6e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c72:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801c76:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c79:	48 63 c8             	movslq %eax,%rcx
  801c7c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c83:	48 63 f0             	movslq %eax,%rsi
  801c86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c8d:	48 98                	cltq   
  801c8f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c93:	49 89 f9             	mov    %rdi,%r9
  801c96:	49 89 f0             	mov    %rsi,%r8
  801c99:	48 89 d1             	mov    %rdx,%rcx
  801c9c:	48 89 c2             	mov    %rax,%rdx
  801c9f:	be 01 00 00 00       	mov    $0x1,%esi
  801ca4:	bf 05 00 00 00       	mov    $0x5,%edi
  801ca9:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  801cb0:	00 00 00 
  801cb3:	ff d0                	callq  *%rax
}
  801cb5:	c9                   	leaveq 
  801cb6:	c3                   	retq   

0000000000801cb7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801cb7:	55                   	push   %rbp
  801cb8:	48 89 e5             	mov    %rsp,%rbp
  801cbb:	48 83 ec 20          	sub    $0x20,%rsp
  801cbf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cc2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801cc6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ccd:	48 98                	cltq   
  801ccf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd6:	00 
  801cd7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cdd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce3:	48 89 d1             	mov    %rdx,%rcx
  801ce6:	48 89 c2             	mov    %rax,%rdx
  801ce9:	be 01 00 00 00       	mov    $0x1,%esi
  801cee:	bf 06 00 00 00       	mov    $0x6,%edi
  801cf3:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  801cfa:	00 00 00 
  801cfd:	ff d0                	callq  *%rax
}
  801cff:	c9                   	leaveq 
  801d00:	c3                   	retq   

0000000000801d01 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801d01:	55                   	push   %rbp
  801d02:	48 89 e5             	mov    %rsp,%rbp
  801d05:	48 83 ec 10          	sub    $0x10,%rsp
  801d09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d0c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801d0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d12:	48 63 d0             	movslq %eax,%rdx
  801d15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d18:	48 98                	cltq   
  801d1a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d21:	00 
  801d22:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d28:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d2e:	48 89 d1             	mov    %rdx,%rcx
  801d31:	48 89 c2             	mov    %rax,%rdx
  801d34:	be 01 00 00 00       	mov    $0x1,%esi
  801d39:	bf 08 00 00 00       	mov    $0x8,%edi
  801d3e:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  801d45:	00 00 00 
  801d48:	ff d0                	callq  *%rax
}
  801d4a:	c9                   	leaveq 
  801d4b:	c3                   	retq   

0000000000801d4c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801d4c:	55                   	push   %rbp
  801d4d:	48 89 e5             	mov    %rsp,%rbp
  801d50:	48 83 ec 20          	sub    $0x20,%rsp
  801d54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801d5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d62:	48 98                	cltq   
  801d64:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d6b:	00 
  801d6c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d72:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d78:	48 89 d1             	mov    %rdx,%rcx
  801d7b:	48 89 c2             	mov    %rax,%rdx
  801d7e:	be 01 00 00 00       	mov    $0x1,%esi
  801d83:	bf 09 00 00 00       	mov    $0x9,%edi
  801d88:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  801d8f:	00 00 00 
  801d92:	ff d0                	callq  *%rax
}
  801d94:	c9                   	leaveq 
  801d95:	c3                   	retq   

0000000000801d96 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801d96:	55                   	push   %rbp
  801d97:	48 89 e5             	mov    %rsp,%rbp
  801d9a:	48 83 ec 20          	sub    $0x20,%rsp
  801d9e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801da1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801da5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801da9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dac:	48 98                	cltq   
  801dae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db5:	00 
  801db6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dbc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dc2:	48 89 d1             	mov    %rdx,%rcx
  801dc5:	48 89 c2             	mov    %rax,%rdx
  801dc8:	be 01 00 00 00       	mov    $0x1,%esi
  801dcd:	bf 0a 00 00 00       	mov    $0xa,%edi
  801dd2:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  801dd9:	00 00 00 
  801ddc:	ff d0                	callq  *%rax
}
  801dde:	c9                   	leaveq 
  801ddf:	c3                   	retq   

0000000000801de0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801de0:	55                   	push   %rbp
  801de1:	48 89 e5             	mov    %rsp,%rbp
  801de4:	48 83 ec 20          	sub    $0x20,%rsp
  801de8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801deb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801def:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801df3:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801df6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801df9:	48 63 f0             	movslq %eax,%rsi
  801dfc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e03:	48 98                	cltq   
  801e05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e09:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e10:	00 
  801e11:	49 89 f1             	mov    %rsi,%r9
  801e14:	49 89 c8             	mov    %rcx,%r8
  801e17:	48 89 d1             	mov    %rdx,%rcx
  801e1a:	48 89 c2             	mov    %rax,%rdx
  801e1d:	be 00 00 00 00       	mov    $0x0,%esi
  801e22:	bf 0c 00 00 00       	mov    $0xc,%edi
  801e27:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  801e2e:	00 00 00 
  801e31:	ff d0                	callq  *%rax
}
  801e33:	c9                   	leaveq 
  801e34:	c3                   	retq   

0000000000801e35 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801e35:	55                   	push   %rbp
  801e36:	48 89 e5             	mov    %rsp,%rbp
  801e39:	48 83 ec 10          	sub    $0x10,%rsp
  801e3d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801e41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e45:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e4c:	00 
  801e4d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e53:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e59:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e5e:	48 89 c2             	mov    %rax,%rdx
  801e61:	be 01 00 00 00       	mov    $0x1,%esi
  801e66:	bf 0d 00 00 00       	mov    $0xd,%edi
  801e6b:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
  801e72:	00 00 00 
  801e75:	ff d0                	callq  *%rax
}
  801e77:	c9                   	leaveq 
  801e78:	c3                   	retq   

0000000000801e79 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e79:	55                   	push   %rbp
  801e7a:	48 89 e5             	mov    %rsp,%rbp
  801e7d:	48 83 ec 08          	sub    $0x8,%rsp
  801e81:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e85:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e89:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e90:	ff ff ff 
  801e93:	48 01 d0             	add    %rdx,%rax
  801e96:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e9a:	c9                   	leaveq 
  801e9b:	c3                   	retq   

0000000000801e9c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e9c:	55                   	push   %rbp
  801e9d:	48 89 e5             	mov    %rsp,%rbp
  801ea0:	48 83 ec 08          	sub    $0x8,%rsp
  801ea4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ea8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eac:	48 89 c7             	mov    %rax,%rdi
  801eaf:	48 b8 79 1e 80 00 00 	movabs $0x801e79,%rax
  801eb6:	00 00 00 
  801eb9:	ff d0                	callq  *%rax
  801ebb:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ec1:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ec5:	c9                   	leaveq 
  801ec6:	c3                   	retq   

0000000000801ec7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ec7:	55                   	push   %rbp
  801ec8:	48 89 e5             	mov    %rsp,%rbp
  801ecb:	48 83 ec 18          	sub    $0x18,%rsp
  801ecf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ed3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801eda:	eb 6b                	jmp    801f47 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801edc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801edf:	48 98                	cltq   
  801ee1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ee7:	48 c1 e0 0c          	shl    $0xc,%rax
  801eeb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801eef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ef3:	48 c1 e8 15          	shr    $0x15,%rax
  801ef7:	48 89 c2             	mov    %rax,%rdx
  801efa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f01:	01 00 00 
  801f04:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f08:	83 e0 01             	and    $0x1,%eax
  801f0b:	48 85 c0             	test   %rax,%rax
  801f0e:	74 21                	je     801f31 <fd_alloc+0x6a>
  801f10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f14:	48 c1 e8 0c          	shr    $0xc,%rax
  801f18:	48 89 c2             	mov    %rax,%rdx
  801f1b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f22:	01 00 00 
  801f25:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f29:	83 e0 01             	and    $0x1,%eax
  801f2c:	48 85 c0             	test   %rax,%rax
  801f2f:	75 12                	jne    801f43 <fd_alloc+0x7c>
			*fd_store = fd;
  801f31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f39:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f41:	eb 1a                	jmp    801f5d <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f43:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f47:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f4b:	7e 8f                	jle    801edc <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f51:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f58:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f5d:	c9                   	leaveq 
  801f5e:	c3                   	retq   

0000000000801f5f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f5f:	55                   	push   %rbp
  801f60:	48 89 e5             	mov    %rsp,%rbp
  801f63:	48 83 ec 20          	sub    $0x20,%rsp
  801f67:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f6a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f6e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f72:	78 06                	js     801f7a <fd_lookup+0x1b>
  801f74:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f78:	7e 07                	jle    801f81 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f7f:	eb 6c                	jmp    801fed <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f81:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f84:	48 98                	cltq   
  801f86:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f8c:	48 c1 e0 0c          	shl    $0xc,%rax
  801f90:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f98:	48 c1 e8 15          	shr    $0x15,%rax
  801f9c:	48 89 c2             	mov    %rax,%rdx
  801f9f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fa6:	01 00 00 
  801fa9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fad:	83 e0 01             	and    $0x1,%eax
  801fb0:	48 85 c0             	test   %rax,%rax
  801fb3:	74 21                	je     801fd6 <fd_lookup+0x77>
  801fb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb9:	48 c1 e8 0c          	shr    $0xc,%rax
  801fbd:	48 89 c2             	mov    %rax,%rdx
  801fc0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc7:	01 00 00 
  801fca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fce:	83 e0 01             	and    $0x1,%eax
  801fd1:	48 85 c0             	test   %rax,%rax
  801fd4:	75 07                	jne    801fdd <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fd6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fdb:	eb 10                	jmp    801fed <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801fdd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fe1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fe5:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801fe8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fed:	c9                   	leaveq 
  801fee:	c3                   	retq   

0000000000801fef <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801fef:	55                   	push   %rbp
  801ff0:	48 89 e5             	mov    %rsp,%rbp
  801ff3:	48 83 ec 30          	sub    $0x30,%rsp
  801ff7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ffb:	89 f0                	mov    %esi,%eax
  801ffd:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802000:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802004:	48 89 c7             	mov    %rax,%rdi
  802007:	48 b8 79 1e 80 00 00 	movabs $0x801e79,%rax
  80200e:	00 00 00 
  802011:	ff d0                	callq  *%rax
  802013:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802017:	48 89 d6             	mov    %rdx,%rsi
  80201a:	89 c7                	mov    %eax,%edi
  80201c:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  802023:	00 00 00 
  802026:	ff d0                	callq  *%rax
  802028:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80202b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80202f:	78 0a                	js     80203b <fd_close+0x4c>
	    || fd != fd2)
  802031:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802035:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802039:	74 12                	je     80204d <fd_close+0x5e>
		return (must_exist ? r : 0);
  80203b:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80203f:	74 05                	je     802046 <fd_close+0x57>
  802041:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802044:	eb 05                	jmp    80204b <fd_close+0x5c>
  802046:	b8 00 00 00 00       	mov    $0x0,%eax
  80204b:	eb 69                	jmp    8020b6 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80204d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802051:	8b 00                	mov    (%rax),%eax
  802053:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802057:	48 89 d6             	mov    %rdx,%rsi
  80205a:	89 c7                	mov    %eax,%edi
  80205c:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  802063:	00 00 00 
  802066:	ff d0                	callq  *%rax
  802068:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80206b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80206f:	78 2a                	js     80209b <fd_close+0xac>
		if (dev->dev_close)
  802071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802075:	48 8b 40 20          	mov    0x20(%rax),%rax
  802079:	48 85 c0             	test   %rax,%rax
  80207c:	74 16                	je     802094 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80207e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802082:	48 8b 40 20          	mov    0x20(%rax),%rax
  802086:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80208a:	48 89 d7             	mov    %rdx,%rdi
  80208d:	ff d0                	callq  *%rax
  80208f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802092:	eb 07                	jmp    80209b <fd_close+0xac>
		else
			r = 0;
  802094:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80209b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80209f:	48 89 c6             	mov    %rax,%rsi
  8020a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a7:	48 b8 b7 1c 80 00 00 	movabs $0x801cb7,%rax
  8020ae:	00 00 00 
  8020b1:	ff d0                	callq  *%rax
	return r;
  8020b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020b6:	c9                   	leaveq 
  8020b7:	c3                   	retq   

00000000008020b8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020b8:	55                   	push   %rbp
  8020b9:	48 89 e5             	mov    %rsp,%rbp
  8020bc:	48 83 ec 20          	sub    $0x20,%rsp
  8020c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020ce:	eb 41                	jmp    802111 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020d0:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8020d7:	00 00 00 
  8020da:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020dd:	48 63 d2             	movslq %edx,%rdx
  8020e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e4:	8b 00                	mov    (%rax),%eax
  8020e6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8020e9:	75 22                	jne    80210d <dev_lookup+0x55>
			*dev = devtab[i];
  8020eb:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8020f2:	00 00 00 
  8020f5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020f8:	48 63 d2             	movslq %edx,%rdx
  8020fb:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8020ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802103:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802106:	b8 00 00 00 00       	mov    $0x0,%eax
  80210b:	eb 60                	jmp    80216d <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80210d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802111:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802118:	00 00 00 
  80211b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80211e:	48 63 d2             	movslq %edx,%rdx
  802121:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802125:	48 85 c0             	test   %rax,%rax
  802128:	75 a6                	jne    8020d0 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80212a:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802131:	00 00 00 
  802134:	48 8b 00             	mov    (%rax),%rax
  802137:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80213d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802140:	89 c6                	mov    %eax,%esi
  802142:	48 bf 70 3f 80 00 00 	movabs $0x803f70,%rdi
  802149:	00 00 00 
  80214c:	b8 00 00 00 00       	mov    $0x0,%eax
  802151:	48 b9 35 05 80 00 00 	movabs $0x800535,%rcx
  802158:	00 00 00 
  80215b:	ff d1                	callq  *%rcx
	*dev = 0;
  80215d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802161:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802168:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80216d:	c9                   	leaveq 
  80216e:	c3                   	retq   

000000000080216f <close>:

int
close(int fdnum)
{
  80216f:	55                   	push   %rbp
  802170:	48 89 e5             	mov    %rsp,%rbp
  802173:	48 83 ec 20          	sub    $0x20,%rsp
  802177:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80217a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80217e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802181:	48 89 d6             	mov    %rdx,%rsi
  802184:	89 c7                	mov    %eax,%edi
  802186:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  80218d:	00 00 00 
  802190:	ff d0                	callq  *%rax
  802192:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802195:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802199:	79 05                	jns    8021a0 <close+0x31>
		return r;
  80219b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80219e:	eb 18                	jmp    8021b8 <close+0x49>
	else
		return fd_close(fd, 1);
  8021a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a4:	be 01 00 00 00       	mov    $0x1,%esi
  8021a9:	48 89 c7             	mov    %rax,%rdi
  8021ac:	48 b8 ef 1f 80 00 00 	movabs $0x801fef,%rax
  8021b3:	00 00 00 
  8021b6:	ff d0                	callq  *%rax
}
  8021b8:	c9                   	leaveq 
  8021b9:	c3                   	retq   

00000000008021ba <close_all>:

void
close_all(void)
{
  8021ba:	55                   	push   %rbp
  8021bb:	48 89 e5             	mov    %rsp,%rbp
  8021be:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021c9:	eb 15                	jmp    8021e0 <close_all+0x26>
		close(i);
  8021cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ce:	89 c7                	mov    %eax,%edi
  8021d0:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  8021d7:	00 00 00 
  8021da:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8021dc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021e0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021e4:	7e e5                	jle    8021cb <close_all+0x11>
		close(i);
}
  8021e6:	c9                   	leaveq 
  8021e7:	c3                   	retq   

00000000008021e8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021e8:	55                   	push   %rbp
  8021e9:	48 89 e5             	mov    %rsp,%rbp
  8021ec:	48 83 ec 40          	sub    $0x40,%rsp
  8021f0:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8021f3:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021f6:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8021fa:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021fd:	48 89 d6             	mov    %rdx,%rsi
  802200:	89 c7                	mov    %eax,%edi
  802202:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  802209:	00 00 00 
  80220c:	ff d0                	callq  *%rax
  80220e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802211:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802215:	79 08                	jns    80221f <dup+0x37>
		return r;
  802217:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80221a:	e9 70 01 00 00       	jmpq   80238f <dup+0x1a7>
	close(newfdnum);
  80221f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802222:	89 c7                	mov    %eax,%edi
  802224:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  80222b:	00 00 00 
  80222e:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802230:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802233:	48 98                	cltq   
  802235:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80223b:	48 c1 e0 0c          	shl    $0xc,%rax
  80223f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802243:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802247:	48 89 c7             	mov    %rax,%rdi
  80224a:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  802251:	00 00 00 
  802254:	ff d0                	callq  *%rax
  802256:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80225a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80225e:	48 89 c7             	mov    %rax,%rdi
  802261:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  802268:	00 00 00 
  80226b:	ff d0                	callq  *%rax
  80226d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802271:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802275:	48 c1 e8 15          	shr    $0x15,%rax
  802279:	48 89 c2             	mov    %rax,%rdx
  80227c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802283:	01 00 00 
  802286:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80228a:	83 e0 01             	and    $0x1,%eax
  80228d:	48 85 c0             	test   %rax,%rax
  802290:	74 73                	je     802305 <dup+0x11d>
  802292:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802296:	48 c1 e8 0c          	shr    $0xc,%rax
  80229a:	48 89 c2             	mov    %rax,%rdx
  80229d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022a4:	01 00 00 
  8022a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ab:	83 e0 01             	and    $0x1,%eax
  8022ae:	48 85 c0             	test   %rax,%rax
  8022b1:	74 52                	je     802305 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b7:	48 c1 e8 0c          	shr    $0xc,%rax
  8022bb:	48 89 c2             	mov    %rax,%rdx
  8022be:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022c5:	01 00 00 
  8022c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022cc:	25 07 0e 00 00       	and    $0xe07,%eax
  8022d1:	89 c1                	mov    %eax,%ecx
  8022d3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022db:	41 89 c8             	mov    %ecx,%r8d
  8022de:	48 89 d1             	mov    %rdx,%rcx
  8022e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e6:	48 89 c6             	mov    %rax,%rsi
  8022e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ee:	48 b8 5c 1c 80 00 00 	movabs $0x801c5c,%rax
  8022f5:	00 00 00 
  8022f8:	ff d0                	callq  *%rax
  8022fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802301:	79 02                	jns    802305 <dup+0x11d>
			goto err;
  802303:	eb 57                	jmp    80235c <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802305:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802309:	48 c1 e8 0c          	shr    $0xc,%rax
  80230d:	48 89 c2             	mov    %rax,%rdx
  802310:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802317:	01 00 00 
  80231a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231e:	25 07 0e 00 00       	and    $0xe07,%eax
  802323:	89 c1                	mov    %eax,%ecx
  802325:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802329:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80232d:	41 89 c8             	mov    %ecx,%r8d
  802330:	48 89 d1             	mov    %rdx,%rcx
  802333:	ba 00 00 00 00       	mov    $0x0,%edx
  802338:	48 89 c6             	mov    %rax,%rsi
  80233b:	bf 00 00 00 00       	mov    $0x0,%edi
  802340:	48 b8 5c 1c 80 00 00 	movabs $0x801c5c,%rax
  802347:	00 00 00 
  80234a:	ff d0                	callq  *%rax
  80234c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80234f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802353:	79 02                	jns    802357 <dup+0x16f>
		goto err;
  802355:	eb 05                	jmp    80235c <dup+0x174>

	return newfdnum;
  802357:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80235a:	eb 33                	jmp    80238f <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80235c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802360:	48 89 c6             	mov    %rax,%rsi
  802363:	bf 00 00 00 00       	mov    $0x0,%edi
  802368:	48 b8 b7 1c 80 00 00 	movabs $0x801cb7,%rax
  80236f:	00 00 00 
  802372:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802374:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802378:	48 89 c6             	mov    %rax,%rsi
  80237b:	bf 00 00 00 00       	mov    $0x0,%edi
  802380:	48 b8 b7 1c 80 00 00 	movabs $0x801cb7,%rax
  802387:	00 00 00 
  80238a:	ff d0                	callq  *%rax
	return r;
  80238c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80238f:	c9                   	leaveq 
  802390:	c3                   	retq   

0000000000802391 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802391:	55                   	push   %rbp
  802392:	48 89 e5             	mov    %rsp,%rbp
  802395:	48 83 ec 40          	sub    $0x40,%rsp
  802399:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80239c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023a0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023a4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023a8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023ab:	48 89 d6             	mov    %rdx,%rsi
  8023ae:	89 c7                	mov    %eax,%edi
  8023b0:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  8023b7:	00 00 00 
  8023ba:	ff d0                	callq  *%rax
  8023bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c3:	78 24                	js     8023e9 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c9:	8b 00                	mov    (%rax),%eax
  8023cb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023cf:	48 89 d6             	mov    %rdx,%rsi
  8023d2:	89 c7                	mov    %eax,%edi
  8023d4:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  8023db:	00 00 00 
  8023de:	ff d0                	callq  *%rax
  8023e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e7:	79 05                	jns    8023ee <read+0x5d>
		return r;
  8023e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ec:	eb 76                	jmp    802464 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8023ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f2:	8b 40 08             	mov    0x8(%rax),%eax
  8023f5:	83 e0 03             	and    $0x3,%eax
  8023f8:	83 f8 01             	cmp    $0x1,%eax
  8023fb:	75 3a                	jne    802437 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8023fd:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802404:	00 00 00 
  802407:	48 8b 00             	mov    (%rax),%rax
  80240a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802410:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802413:	89 c6                	mov    %eax,%esi
  802415:	48 bf 8f 3f 80 00 00 	movabs $0x803f8f,%rdi
  80241c:	00 00 00 
  80241f:	b8 00 00 00 00       	mov    $0x0,%eax
  802424:	48 b9 35 05 80 00 00 	movabs $0x800535,%rcx
  80242b:	00 00 00 
  80242e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802430:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802435:	eb 2d                	jmp    802464 <read+0xd3>
	}
	if (!dev->dev_read)
  802437:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80243b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80243f:	48 85 c0             	test   %rax,%rax
  802442:	75 07                	jne    80244b <read+0xba>
		return -E_NOT_SUPP;
  802444:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802449:	eb 19                	jmp    802464 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80244b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802453:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802457:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80245b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80245f:	48 89 cf             	mov    %rcx,%rdi
  802462:	ff d0                	callq  *%rax
}
  802464:	c9                   	leaveq 
  802465:	c3                   	retq   

0000000000802466 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802466:	55                   	push   %rbp
  802467:	48 89 e5             	mov    %rsp,%rbp
  80246a:	48 83 ec 30          	sub    $0x30,%rsp
  80246e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802471:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802475:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802479:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802480:	eb 49                	jmp    8024cb <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802482:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802485:	48 98                	cltq   
  802487:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80248b:	48 29 c2             	sub    %rax,%rdx
  80248e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802491:	48 63 c8             	movslq %eax,%rcx
  802494:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802498:	48 01 c1             	add    %rax,%rcx
  80249b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80249e:	48 89 ce             	mov    %rcx,%rsi
  8024a1:	89 c7                	mov    %eax,%edi
  8024a3:	48 b8 91 23 80 00 00 	movabs $0x802391,%rax
  8024aa:	00 00 00 
  8024ad:	ff d0                	callq  *%rax
  8024af:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8024b2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024b6:	79 05                	jns    8024bd <readn+0x57>
			return m;
  8024b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024bb:	eb 1c                	jmp    8024d9 <readn+0x73>
		if (m == 0)
  8024bd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024c1:	75 02                	jne    8024c5 <readn+0x5f>
			break;
  8024c3:	eb 11                	jmp    8024d6 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024c8:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ce:	48 98                	cltq   
  8024d0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024d4:	72 ac                	jb     802482 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8024d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024d9:	c9                   	leaveq 
  8024da:	c3                   	retq   

00000000008024db <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024db:	55                   	push   %rbp
  8024dc:	48 89 e5             	mov    %rsp,%rbp
  8024df:	48 83 ec 40          	sub    $0x40,%rsp
  8024e3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024ea:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024ee:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024f2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024f5:	48 89 d6             	mov    %rdx,%rsi
  8024f8:	89 c7                	mov    %eax,%edi
  8024fa:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  802501:	00 00 00 
  802504:	ff d0                	callq  *%rax
  802506:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802509:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250d:	78 24                	js     802533 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80250f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802513:	8b 00                	mov    (%rax),%eax
  802515:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802519:	48 89 d6             	mov    %rdx,%rsi
  80251c:	89 c7                	mov    %eax,%edi
  80251e:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  802525:	00 00 00 
  802528:	ff d0                	callq  *%rax
  80252a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802531:	79 05                	jns    802538 <write+0x5d>
		return r;
  802533:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802536:	eb 75                	jmp    8025ad <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253c:	8b 40 08             	mov    0x8(%rax),%eax
  80253f:	83 e0 03             	and    $0x3,%eax
  802542:	85 c0                	test   %eax,%eax
  802544:	75 3a                	jne    802580 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802546:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80254d:	00 00 00 
  802550:	48 8b 00             	mov    (%rax),%rax
  802553:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802559:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80255c:	89 c6                	mov    %eax,%esi
  80255e:	48 bf ab 3f 80 00 00 	movabs $0x803fab,%rdi
  802565:	00 00 00 
  802568:	b8 00 00 00 00       	mov    $0x0,%eax
  80256d:	48 b9 35 05 80 00 00 	movabs $0x800535,%rcx
  802574:	00 00 00 
  802577:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802579:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80257e:	eb 2d                	jmp    8025ad <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802580:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802584:	48 8b 40 18          	mov    0x18(%rax),%rax
  802588:	48 85 c0             	test   %rax,%rax
  80258b:	75 07                	jne    802594 <write+0xb9>
		return -E_NOT_SUPP;
  80258d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802592:	eb 19                	jmp    8025ad <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802598:	48 8b 40 18          	mov    0x18(%rax),%rax
  80259c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025a0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025a4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025a8:	48 89 cf             	mov    %rcx,%rdi
  8025ab:	ff d0                	callq  *%rax
}
  8025ad:	c9                   	leaveq 
  8025ae:	c3                   	retq   

00000000008025af <seek>:

int
seek(int fdnum, off_t offset)
{
  8025af:	55                   	push   %rbp
  8025b0:	48 89 e5             	mov    %rsp,%rbp
  8025b3:	48 83 ec 18          	sub    $0x18,%rsp
  8025b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025ba:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025bd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025c4:	48 89 d6             	mov    %rdx,%rsi
  8025c7:	89 c7                	mov    %eax,%edi
  8025c9:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  8025d0:	00 00 00 
  8025d3:	ff d0                	callq  *%rax
  8025d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025dc:	79 05                	jns    8025e3 <seek+0x34>
		return r;
  8025de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e1:	eb 0f                	jmp    8025f2 <seek+0x43>
	fd->fd_offset = offset;
  8025e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025ea:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8025ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f2:	c9                   	leaveq 
  8025f3:	c3                   	retq   

00000000008025f4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025f4:	55                   	push   %rbp
  8025f5:	48 89 e5             	mov    %rsp,%rbp
  8025f8:	48 83 ec 30          	sub    $0x30,%rsp
  8025fc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025ff:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802602:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802606:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802609:	48 89 d6             	mov    %rdx,%rsi
  80260c:	89 c7                	mov    %eax,%edi
  80260e:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  802615:	00 00 00 
  802618:	ff d0                	callq  *%rax
  80261a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802621:	78 24                	js     802647 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802623:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802627:	8b 00                	mov    (%rax),%eax
  802629:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80262d:	48 89 d6             	mov    %rdx,%rsi
  802630:	89 c7                	mov    %eax,%edi
  802632:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  802639:	00 00 00 
  80263c:	ff d0                	callq  *%rax
  80263e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802641:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802645:	79 05                	jns    80264c <ftruncate+0x58>
		return r;
  802647:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264a:	eb 72                	jmp    8026be <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80264c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802650:	8b 40 08             	mov    0x8(%rax),%eax
  802653:	83 e0 03             	and    $0x3,%eax
  802656:	85 c0                	test   %eax,%eax
  802658:	75 3a                	jne    802694 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80265a:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802661:	00 00 00 
  802664:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802667:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80266d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802670:	89 c6                	mov    %eax,%esi
  802672:	48 bf c8 3f 80 00 00 	movabs $0x803fc8,%rdi
  802679:	00 00 00 
  80267c:	b8 00 00 00 00       	mov    $0x0,%eax
  802681:	48 b9 35 05 80 00 00 	movabs $0x800535,%rcx
  802688:	00 00 00 
  80268b:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80268d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802692:	eb 2a                	jmp    8026be <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802698:	48 8b 40 30          	mov    0x30(%rax),%rax
  80269c:	48 85 c0             	test   %rax,%rax
  80269f:	75 07                	jne    8026a8 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8026a1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026a6:	eb 16                	jmp    8026be <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8026a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ac:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026b4:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8026b7:	89 ce                	mov    %ecx,%esi
  8026b9:	48 89 d7             	mov    %rdx,%rdi
  8026bc:	ff d0                	callq  *%rax
}
  8026be:	c9                   	leaveq 
  8026bf:	c3                   	retq   

00000000008026c0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026c0:	55                   	push   %rbp
  8026c1:	48 89 e5             	mov    %rsp,%rbp
  8026c4:	48 83 ec 30          	sub    $0x30,%rsp
  8026c8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026cb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026cf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026d3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026d6:	48 89 d6             	mov    %rdx,%rsi
  8026d9:	89 c7                	mov    %eax,%edi
  8026db:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  8026e2:	00 00 00 
  8026e5:	ff d0                	callq  *%rax
  8026e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ee:	78 24                	js     802714 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f4:	8b 00                	mov    (%rax),%eax
  8026f6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026fa:	48 89 d6             	mov    %rdx,%rsi
  8026fd:	89 c7                	mov    %eax,%edi
  8026ff:	48 b8 b8 20 80 00 00 	movabs $0x8020b8,%rax
  802706:	00 00 00 
  802709:	ff d0                	callq  *%rax
  80270b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80270e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802712:	79 05                	jns    802719 <fstat+0x59>
		return r;
  802714:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802717:	eb 5e                	jmp    802777 <fstat+0xb7>
	if (!dev->dev_stat)
  802719:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802721:	48 85 c0             	test   %rax,%rax
  802724:	75 07                	jne    80272d <fstat+0x6d>
		return -E_NOT_SUPP;
  802726:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80272b:	eb 4a                	jmp    802777 <fstat+0xb7>
	stat->st_name[0] = 0;
  80272d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802731:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802734:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802738:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80273f:	00 00 00 
	stat->st_isdir = 0;
  802742:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802746:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80274d:	00 00 00 
	stat->st_dev = dev;
  802750:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802754:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802758:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80275f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802763:	48 8b 40 28          	mov    0x28(%rax),%rax
  802767:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80276b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80276f:	48 89 ce             	mov    %rcx,%rsi
  802772:	48 89 d7             	mov    %rdx,%rdi
  802775:	ff d0                	callq  *%rax
}
  802777:	c9                   	leaveq 
  802778:	c3                   	retq   

0000000000802779 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802779:	55                   	push   %rbp
  80277a:	48 89 e5             	mov    %rsp,%rbp
  80277d:	48 83 ec 20          	sub    $0x20,%rsp
  802781:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802785:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278d:	be 00 00 00 00       	mov    $0x0,%esi
  802792:	48 89 c7             	mov    %rax,%rdi
  802795:	48 b8 67 28 80 00 00 	movabs $0x802867,%rax
  80279c:	00 00 00 
  80279f:	ff d0                	callq  *%rax
  8027a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a8:	79 05                	jns    8027af <stat+0x36>
		return fd;
  8027aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ad:	eb 2f                	jmp    8027de <stat+0x65>
	r = fstat(fd, stat);
  8027af:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b6:	48 89 d6             	mov    %rdx,%rsi
  8027b9:	89 c7                	mov    %eax,%edi
  8027bb:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  8027c2:	00 00 00 
  8027c5:	ff d0                	callq  *%rax
  8027c7:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cd:	89 c7                	mov    %eax,%edi
  8027cf:	48 b8 6f 21 80 00 00 	movabs $0x80216f,%rax
  8027d6:	00 00 00 
  8027d9:	ff d0                	callq  *%rax
	return r;
  8027db:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027de:	c9                   	leaveq 
  8027df:	c3                   	retq   

00000000008027e0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027e0:	55                   	push   %rbp
  8027e1:	48 89 e5             	mov    %rsp,%rbp
  8027e4:	48 83 ec 10          	sub    $0x10,%rsp
  8027e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8027ef:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  8027f6:	00 00 00 
  8027f9:	8b 00                	mov    (%rax),%eax
  8027fb:	85 c0                	test   %eax,%eax
  8027fd:	75 1d                	jne    80281c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8027ff:	bf 01 00 00 00       	mov    $0x1,%edi
  802804:	48 b8 da 38 80 00 00 	movabs $0x8038da,%rax
  80280b:	00 00 00 
  80280e:	ff d0                	callq  *%rax
  802810:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  802817:	00 00 00 
  80281a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80281c:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802823:	00 00 00 
  802826:	8b 00                	mov    (%rax),%eax
  802828:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80282b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802830:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802837:	00 00 00 
  80283a:	89 c7                	mov    %eax,%edi
  80283c:	48 b8 42 38 80 00 00 	movabs $0x803842,%rax
  802843:	00 00 00 
  802846:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802848:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284c:	ba 00 00 00 00       	mov    $0x0,%edx
  802851:	48 89 c6             	mov    %rax,%rsi
  802854:	bf 00 00 00 00       	mov    $0x0,%edi
  802859:	48 b8 79 37 80 00 00 	movabs $0x803779,%rax
  802860:	00 00 00 
  802863:	ff d0                	callq  *%rax
}
  802865:	c9                   	leaveq 
  802866:	c3                   	retq   

0000000000802867 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802867:	55                   	push   %rbp
  802868:	48 89 e5             	mov    %rsp,%rbp
  80286b:	48 83 ec 20          	sub    $0x20,%rsp
  80286f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802873:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  802876:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287a:	48 89 c7             	mov    %rax,%rdi
  80287d:	48 b8 71 12 80 00 00 	movabs $0x801271,%rax
  802884:	00 00 00 
  802887:	ff d0                	callq  *%rax
  802889:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80288e:	7e 0a                	jle    80289a <open+0x33>
		return -E_BAD_PATH;
  802890:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802895:	e9 a5 00 00 00       	jmpq   80293f <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80289a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80289e:	48 89 c7             	mov    %rax,%rdi
  8028a1:	48 b8 c7 1e 80 00 00 	movabs $0x801ec7,%rax
  8028a8:	00 00 00 
  8028ab:	ff d0                	callq  *%rax
  8028ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b4:	79 08                	jns    8028be <open+0x57>
		return r;
  8028b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b9:	e9 81 00 00 00       	jmpq   80293f <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8028be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c2:	48 89 c6             	mov    %rax,%rsi
  8028c5:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8028cc:	00 00 00 
  8028cf:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  8028d6:	00 00 00 
  8028d9:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8028db:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028e2:	00 00 00 
  8028e5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8028e8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8028ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f2:	48 89 c6             	mov    %rax,%rsi
  8028f5:	bf 01 00 00 00       	mov    $0x1,%edi
  8028fa:	48 b8 e0 27 80 00 00 	movabs $0x8027e0,%rax
  802901:	00 00 00 
  802904:	ff d0                	callq  *%rax
  802906:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802909:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290d:	79 1d                	jns    80292c <open+0xc5>
		fd_close(fd, 0);
  80290f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802913:	be 00 00 00 00       	mov    $0x0,%esi
  802918:	48 89 c7             	mov    %rax,%rdi
  80291b:	48 b8 ef 1f 80 00 00 	movabs $0x801fef,%rax
  802922:	00 00 00 
  802925:	ff d0                	callq  *%rax
		return r;
  802927:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292a:	eb 13                	jmp    80293f <open+0xd8>
	}

	return fd2num(fd);
  80292c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802930:	48 89 c7             	mov    %rax,%rdi
  802933:	48 b8 79 1e 80 00 00 	movabs $0x801e79,%rax
  80293a:	00 00 00 
  80293d:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  80293f:	c9                   	leaveq 
  802940:	c3                   	retq   

0000000000802941 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802941:	55                   	push   %rbp
  802942:	48 89 e5             	mov    %rsp,%rbp
  802945:	48 83 ec 10          	sub    $0x10,%rsp
  802949:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80294d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802951:	8b 50 0c             	mov    0xc(%rax),%edx
  802954:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80295b:	00 00 00 
  80295e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802960:	be 00 00 00 00       	mov    $0x0,%esi
  802965:	bf 06 00 00 00       	mov    $0x6,%edi
  80296a:	48 b8 e0 27 80 00 00 	movabs $0x8027e0,%rax
  802971:	00 00 00 
  802974:	ff d0                	callq  *%rax
}
  802976:	c9                   	leaveq 
  802977:	c3                   	retq   

0000000000802978 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802978:	55                   	push   %rbp
  802979:	48 89 e5             	mov    %rsp,%rbp
  80297c:	48 83 ec 30          	sub    $0x30,%rsp
  802980:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802984:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802988:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80298c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802990:	8b 50 0c             	mov    0xc(%rax),%edx
  802993:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80299a:	00 00 00 
  80299d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80299f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029a6:	00 00 00 
  8029a9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029ad:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8029b1:	be 00 00 00 00       	mov    $0x0,%esi
  8029b6:	bf 03 00 00 00       	mov    $0x3,%edi
  8029bb:	48 b8 e0 27 80 00 00 	movabs $0x8027e0,%rax
  8029c2:	00 00 00 
  8029c5:	ff d0                	callq  *%rax
  8029c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ce:	79 05                	jns    8029d5 <devfile_read+0x5d>
		return r;
  8029d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d3:	eb 26                	jmp    8029fb <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8029d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d8:	48 63 d0             	movslq %eax,%rdx
  8029db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029df:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8029e6:	00 00 00 
  8029e9:	48 89 c7             	mov    %rax,%rdi
  8029ec:	48 b8 01 16 80 00 00 	movabs $0x801601,%rax
  8029f3:	00 00 00 
  8029f6:	ff d0                	callq  *%rax

	return r;
  8029f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8029fb:	c9                   	leaveq 
  8029fc:	c3                   	retq   

00000000008029fd <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8029fd:	55                   	push   %rbp
  8029fe:	48 89 e5             	mov    %rsp,%rbp
  802a01:	48 83 ec 30          	sub    $0x30,%rsp
  802a05:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a09:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a0d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802a11:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802a18:	00 
  802a19:	76 08                	jbe    802a23 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802a1b:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802a22:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a27:	8b 50 0c             	mov    0xc(%rax),%edx
  802a2a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a31:	00 00 00 
  802a34:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802a36:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a3d:	00 00 00 
  802a40:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a44:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  802a48:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a50:	48 89 c6             	mov    %rax,%rsi
  802a53:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802a5a:	00 00 00 
  802a5d:	48 b8 01 16 80 00 00 	movabs $0x801601,%rax
  802a64:	00 00 00 
  802a67:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802a69:	be 00 00 00 00       	mov    $0x0,%esi
  802a6e:	bf 04 00 00 00       	mov    $0x4,%edi
  802a73:	48 b8 e0 27 80 00 00 	movabs $0x8027e0,%rax
  802a7a:	00 00 00 
  802a7d:	ff d0                	callq  *%rax
  802a7f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a82:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a86:	79 05                	jns    802a8d <devfile_write+0x90>
		return r;
  802a88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a8b:	eb 03                	jmp    802a90 <devfile_write+0x93>

	return r;
  802a8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802a90:	c9                   	leaveq 
  802a91:	c3                   	retq   

0000000000802a92 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a92:	55                   	push   %rbp
  802a93:	48 89 e5             	mov    %rsp,%rbp
  802a96:	48 83 ec 20          	sub    $0x20,%rsp
  802a9a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a9e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802aa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa6:	8b 50 0c             	mov    0xc(%rax),%edx
  802aa9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ab0:	00 00 00 
  802ab3:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ab5:	be 00 00 00 00       	mov    $0x0,%esi
  802aba:	bf 05 00 00 00       	mov    $0x5,%edi
  802abf:	48 b8 e0 27 80 00 00 	movabs $0x8027e0,%rax
  802ac6:	00 00 00 
  802ac9:	ff d0                	callq  *%rax
  802acb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ace:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad2:	79 05                	jns    802ad9 <devfile_stat+0x47>
		return r;
  802ad4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad7:	eb 56                	jmp    802b2f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ad9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802add:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802ae4:	00 00 00 
  802ae7:	48 89 c7             	mov    %rax,%rdi
  802aea:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  802af1:	00 00 00 
  802af4:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802af6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802afd:	00 00 00 
  802b00:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b06:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b0a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b10:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b17:	00 00 00 
  802b1a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b24:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b2f:	c9                   	leaveq 
  802b30:	c3                   	retq   

0000000000802b31 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b31:	55                   	push   %rbp
  802b32:	48 89 e5             	mov    %rsp,%rbp
  802b35:	48 83 ec 10          	sub    $0x10,%rsp
  802b39:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b3d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b44:	8b 50 0c             	mov    0xc(%rax),%edx
  802b47:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b4e:	00 00 00 
  802b51:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b53:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b5a:	00 00 00 
  802b5d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b60:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b63:	be 00 00 00 00       	mov    $0x0,%esi
  802b68:	bf 02 00 00 00       	mov    $0x2,%edi
  802b6d:	48 b8 e0 27 80 00 00 	movabs $0x8027e0,%rax
  802b74:	00 00 00 
  802b77:	ff d0                	callq  *%rax
}
  802b79:	c9                   	leaveq 
  802b7a:	c3                   	retq   

0000000000802b7b <remove>:

// Delete a file
int
remove(const char *path)
{
  802b7b:	55                   	push   %rbp
  802b7c:	48 89 e5             	mov    %rsp,%rbp
  802b7f:	48 83 ec 10          	sub    $0x10,%rsp
  802b83:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802b87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b8b:	48 89 c7             	mov    %rax,%rdi
  802b8e:	48 b8 71 12 80 00 00 	movabs $0x801271,%rax
  802b95:	00 00 00 
  802b98:	ff d0                	callq  *%rax
  802b9a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b9f:	7e 07                	jle    802ba8 <remove+0x2d>
		return -E_BAD_PATH;
  802ba1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ba6:	eb 33                	jmp    802bdb <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ba8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bac:	48 89 c6             	mov    %rax,%rsi
  802baf:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802bb6:	00 00 00 
  802bb9:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  802bc0:	00 00 00 
  802bc3:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802bc5:	be 00 00 00 00       	mov    $0x0,%esi
  802bca:	bf 07 00 00 00       	mov    $0x7,%edi
  802bcf:	48 b8 e0 27 80 00 00 	movabs $0x8027e0,%rax
  802bd6:	00 00 00 
  802bd9:	ff d0                	callq  *%rax
}
  802bdb:	c9                   	leaveq 
  802bdc:	c3                   	retq   

0000000000802bdd <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802bdd:	55                   	push   %rbp
  802bde:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802be1:	be 00 00 00 00       	mov    $0x0,%esi
  802be6:	bf 08 00 00 00       	mov    $0x8,%edi
  802beb:	48 b8 e0 27 80 00 00 	movabs $0x8027e0,%rax
  802bf2:	00 00 00 
  802bf5:	ff d0                	callq  *%rax
}
  802bf7:	5d                   	pop    %rbp
  802bf8:	c3                   	retq   

0000000000802bf9 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802bf9:	55                   	push   %rbp
  802bfa:	48 89 e5             	mov    %rsp,%rbp
  802bfd:	48 83 ec 20          	sub    $0x20,%rsp
  802c01:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802c05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c09:	8b 40 0c             	mov    0xc(%rax),%eax
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	7e 67                	jle    802c77 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802c10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c14:	8b 40 04             	mov    0x4(%rax),%eax
  802c17:	48 63 d0             	movslq %eax,%rdx
  802c1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1e:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802c22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c26:	8b 00                	mov    (%rax),%eax
  802c28:	48 89 ce             	mov    %rcx,%rsi
  802c2b:	89 c7                	mov    %eax,%edi
  802c2d:	48 b8 db 24 80 00 00 	movabs $0x8024db,%rax
  802c34:	00 00 00 
  802c37:	ff d0                	callq  *%rax
  802c39:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802c3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c40:	7e 13                	jle    802c55 <writebuf+0x5c>
			b->result += result;
  802c42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c46:	8b 50 08             	mov    0x8(%rax),%edx
  802c49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4c:	01 c2                	add    %eax,%edx
  802c4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c52:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802c55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c59:	8b 40 04             	mov    0x4(%rax),%eax
  802c5c:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802c5f:	74 16                	je     802c77 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802c61:	b8 00 00 00 00       	mov    $0x0,%eax
  802c66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c6a:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802c6e:	89 c2                	mov    %eax,%edx
  802c70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c74:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802c77:	c9                   	leaveq 
  802c78:	c3                   	retq   

0000000000802c79 <putch>:

static void
putch(int ch, void *thunk)
{
  802c79:	55                   	push   %rbp
  802c7a:	48 89 e5             	mov    %rsp,%rbp
  802c7d:	48 83 ec 20          	sub    $0x20,%rsp
  802c81:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802c88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c8c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802c90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c94:	8b 40 04             	mov    0x4(%rax),%eax
  802c97:	8d 48 01             	lea    0x1(%rax),%ecx
  802c9a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c9e:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802ca1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ca4:	89 d1                	mov    %edx,%ecx
  802ca6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802caa:	48 98                	cltq   
  802cac:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802cb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cb4:	8b 40 04             	mov    0x4(%rax),%eax
  802cb7:	3d 00 01 00 00       	cmp    $0x100,%eax
  802cbc:	75 1e                	jne    802cdc <putch+0x63>
		writebuf(b);
  802cbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cc2:	48 89 c7             	mov    %rax,%rdi
  802cc5:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  802ccc:	00 00 00 
  802ccf:	ff d0                	callq  *%rax
		b->idx = 0;
  802cd1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802cdc:	c9                   	leaveq 
  802cdd:	c3                   	retq   

0000000000802cde <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802cde:	55                   	push   %rbp
  802cdf:	48 89 e5             	mov    %rsp,%rbp
  802ce2:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802ce9:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802cef:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802cf6:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802cfd:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802d03:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802d09:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802d10:	00 00 00 
	b.result = 0;
  802d13:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802d1a:	00 00 00 
	b.error = 1;
  802d1d:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802d24:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802d27:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802d2e:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802d35:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802d3c:	48 89 c6             	mov    %rax,%rsi
  802d3f:	48 bf 79 2c 80 00 00 	movabs $0x802c79,%rdi
  802d46:	00 00 00 
  802d49:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  802d50:	00 00 00 
  802d53:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802d55:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802d5b:	85 c0                	test   %eax,%eax
  802d5d:	7e 16                	jle    802d75 <vfprintf+0x97>
		writebuf(&b);
  802d5f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802d66:	48 89 c7             	mov    %rax,%rdi
  802d69:	48 b8 f9 2b 80 00 00 	movabs $0x802bf9,%rax
  802d70:	00 00 00 
  802d73:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802d75:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802d7b:	85 c0                	test   %eax,%eax
  802d7d:	74 08                	je     802d87 <vfprintf+0xa9>
  802d7f:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802d85:	eb 06                	jmp    802d8d <vfprintf+0xaf>
  802d87:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802d8d:	c9                   	leaveq 
  802d8e:	c3                   	retq   

0000000000802d8f <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802d8f:	55                   	push   %rbp
  802d90:	48 89 e5             	mov    %rsp,%rbp
  802d93:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802d9a:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802da0:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802da7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802dae:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802db5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802dbc:	84 c0                	test   %al,%al
  802dbe:	74 20                	je     802de0 <fprintf+0x51>
  802dc0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802dc4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802dc8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802dcc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802dd0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802dd4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802dd8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802ddc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802de0:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802de7:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802dee:	00 00 00 
  802df1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802df8:	00 00 00 
  802dfb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802dff:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802e06:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802e0d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802e14:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802e1b:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802e22:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802e28:	48 89 ce             	mov    %rcx,%rsi
  802e2b:	89 c7                	mov    %eax,%edi
  802e2d:	48 b8 de 2c 80 00 00 	movabs $0x802cde,%rax
  802e34:	00 00 00 
  802e37:	ff d0                	callq  *%rax
  802e39:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802e3f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802e45:	c9                   	leaveq 
  802e46:	c3                   	retq   

0000000000802e47 <printf>:

int
printf(const char *fmt, ...)
{
  802e47:	55                   	push   %rbp
  802e48:	48 89 e5             	mov    %rsp,%rbp
  802e4b:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802e52:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802e59:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802e60:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802e67:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802e6e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802e75:	84 c0                	test   %al,%al
  802e77:	74 20                	je     802e99 <printf+0x52>
  802e79:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802e7d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802e81:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802e85:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802e89:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802e8d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802e91:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802e95:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802e99:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802ea0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802ea7:	00 00 00 
  802eaa:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802eb1:	00 00 00 
  802eb4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802eb8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802ebf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802ec6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802ecd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802ed4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802edb:	48 89 c6             	mov    %rax,%rsi
  802ede:	bf 01 00 00 00       	mov    $0x1,%edi
  802ee3:	48 b8 de 2c 80 00 00 	movabs $0x802cde,%rax
  802eea:	00 00 00 
  802eed:	ff d0                	callq  *%rax
  802eef:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802ef5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802efb:	c9                   	leaveq 
  802efc:	c3                   	retq   

0000000000802efd <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802efd:	55                   	push   %rbp
  802efe:	48 89 e5             	mov    %rsp,%rbp
  802f01:	53                   	push   %rbx
  802f02:	48 83 ec 38          	sub    $0x38,%rsp
  802f06:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802f0a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802f0e:	48 89 c7             	mov    %rax,%rdi
  802f11:	48 b8 c7 1e 80 00 00 	movabs $0x801ec7,%rax
  802f18:	00 00 00 
  802f1b:	ff d0                	callq  *%rax
  802f1d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f20:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f24:	0f 88 bf 01 00 00    	js     8030e9 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f2e:	ba 07 04 00 00       	mov    $0x407,%edx
  802f33:	48 89 c6             	mov    %rax,%rsi
  802f36:	bf 00 00 00 00       	mov    $0x0,%edi
  802f3b:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  802f42:	00 00 00 
  802f45:	ff d0                	callq  *%rax
  802f47:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f4a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f4e:	0f 88 95 01 00 00    	js     8030e9 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802f54:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802f58:	48 89 c7             	mov    %rax,%rdi
  802f5b:	48 b8 c7 1e 80 00 00 	movabs $0x801ec7,%rax
  802f62:	00 00 00 
  802f65:	ff d0                	callq  *%rax
  802f67:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f6e:	0f 88 5d 01 00 00    	js     8030d1 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f74:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f78:	ba 07 04 00 00       	mov    $0x407,%edx
  802f7d:	48 89 c6             	mov    %rax,%rsi
  802f80:	bf 00 00 00 00       	mov    $0x0,%edi
  802f85:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  802f8c:	00 00 00 
  802f8f:	ff d0                	callq  *%rax
  802f91:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f94:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f98:	0f 88 33 01 00 00    	js     8030d1 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802f9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fa2:	48 89 c7             	mov    %rax,%rdi
  802fa5:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  802fac:	00 00 00 
  802faf:	ff d0                	callq  *%rax
  802fb1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fb5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fb9:	ba 07 04 00 00       	mov    $0x407,%edx
  802fbe:	48 89 c6             	mov    %rax,%rsi
  802fc1:	bf 00 00 00 00       	mov    $0x0,%edi
  802fc6:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  802fcd:	00 00 00 
  802fd0:	ff d0                	callq  *%rax
  802fd2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fd5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fd9:	79 05                	jns    802fe0 <pipe+0xe3>
		goto err2;
  802fdb:	e9 d9 00 00 00       	jmpq   8030b9 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fe0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fe4:	48 89 c7             	mov    %rax,%rdi
  802fe7:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  802fee:	00 00 00 
  802ff1:	ff d0                	callq  *%rax
  802ff3:	48 89 c2             	mov    %rax,%rdx
  802ff6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ffa:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803000:	48 89 d1             	mov    %rdx,%rcx
  803003:	ba 00 00 00 00       	mov    $0x0,%edx
  803008:	48 89 c6             	mov    %rax,%rsi
  80300b:	bf 00 00 00 00       	mov    $0x0,%edi
  803010:	48 b8 5c 1c 80 00 00 	movabs $0x801c5c,%rax
  803017:	00 00 00 
  80301a:	ff d0                	callq  *%rax
  80301c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80301f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803023:	79 1b                	jns    803040 <pipe+0x143>
		goto err3;
  803025:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803026:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80302a:	48 89 c6             	mov    %rax,%rsi
  80302d:	bf 00 00 00 00       	mov    $0x0,%edi
  803032:	48 b8 b7 1c 80 00 00 	movabs $0x801cb7,%rax
  803039:	00 00 00 
  80303c:	ff d0                	callq  *%rax
  80303e:	eb 79                	jmp    8030b9 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803040:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803044:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  80304b:	00 00 00 
  80304e:	8b 12                	mov    (%rdx),%edx
  803050:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803052:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803056:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80305d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803061:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  803068:	00 00 00 
  80306b:	8b 12                	mov    (%rdx),%edx
  80306d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80306f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803073:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80307a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80307e:	48 89 c7             	mov    %rax,%rdi
  803081:	48 b8 79 1e 80 00 00 	movabs $0x801e79,%rax
  803088:	00 00 00 
  80308b:	ff d0                	callq  *%rax
  80308d:	89 c2                	mov    %eax,%edx
  80308f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803093:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803095:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803099:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80309d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030a1:	48 89 c7             	mov    %rax,%rdi
  8030a4:	48 b8 79 1e 80 00 00 	movabs $0x801e79,%rax
  8030ab:	00 00 00 
  8030ae:	ff d0                	callq  *%rax
  8030b0:	89 03                	mov    %eax,(%rbx)
	return 0;
  8030b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b7:	eb 33                	jmp    8030ec <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8030b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030bd:	48 89 c6             	mov    %rax,%rsi
  8030c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8030c5:	48 b8 b7 1c 80 00 00 	movabs $0x801cb7,%rax
  8030cc:	00 00 00 
  8030cf:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8030d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030d5:	48 89 c6             	mov    %rax,%rsi
  8030d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8030dd:	48 b8 b7 1c 80 00 00 	movabs $0x801cb7,%rax
  8030e4:	00 00 00 
  8030e7:	ff d0                	callq  *%rax
    err:
	return r;
  8030e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8030ec:	48 83 c4 38          	add    $0x38,%rsp
  8030f0:	5b                   	pop    %rbx
  8030f1:	5d                   	pop    %rbp
  8030f2:	c3                   	retq   

00000000008030f3 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8030f3:	55                   	push   %rbp
  8030f4:	48 89 e5             	mov    %rsp,%rbp
  8030f7:	53                   	push   %rbx
  8030f8:	48 83 ec 28          	sub    $0x28,%rsp
  8030fc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803100:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803104:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80310b:	00 00 00 
  80310e:	48 8b 00             	mov    (%rax),%rax
  803111:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803117:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80311a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80311e:	48 89 c7             	mov    %rax,%rdi
  803121:	48 b8 5c 39 80 00 00 	movabs $0x80395c,%rax
  803128:	00 00 00 
  80312b:	ff d0                	callq  *%rax
  80312d:	89 c3                	mov    %eax,%ebx
  80312f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803133:	48 89 c7             	mov    %rax,%rdi
  803136:	48 b8 5c 39 80 00 00 	movabs $0x80395c,%rax
  80313d:	00 00 00 
  803140:	ff d0                	callq  *%rax
  803142:	39 c3                	cmp    %eax,%ebx
  803144:	0f 94 c0             	sete   %al
  803147:	0f b6 c0             	movzbl %al,%eax
  80314a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80314d:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803154:	00 00 00 
  803157:	48 8b 00             	mov    (%rax),%rax
  80315a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803160:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803163:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803166:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803169:	75 05                	jne    803170 <_pipeisclosed+0x7d>
			return ret;
  80316b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80316e:	eb 4f                	jmp    8031bf <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803170:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803173:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803176:	74 42                	je     8031ba <_pipeisclosed+0xc7>
  803178:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80317c:	75 3c                	jne    8031ba <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80317e:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803185:	00 00 00 
  803188:	48 8b 00             	mov    (%rax),%rax
  80318b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803191:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803194:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803197:	89 c6                	mov    %eax,%esi
  803199:	48 bf f3 3f 80 00 00 	movabs $0x803ff3,%rdi
  8031a0:	00 00 00 
  8031a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a8:	49 b8 35 05 80 00 00 	movabs $0x800535,%r8
  8031af:	00 00 00 
  8031b2:	41 ff d0             	callq  *%r8
	}
  8031b5:	e9 4a ff ff ff       	jmpq   803104 <_pipeisclosed+0x11>
  8031ba:	e9 45 ff ff ff       	jmpq   803104 <_pipeisclosed+0x11>
}
  8031bf:	48 83 c4 28          	add    $0x28,%rsp
  8031c3:	5b                   	pop    %rbx
  8031c4:	5d                   	pop    %rbp
  8031c5:	c3                   	retq   

00000000008031c6 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8031c6:	55                   	push   %rbp
  8031c7:	48 89 e5             	mov    %rsp,%rbp
  8031ca:	48 83 ec 30          	sub    $0x30,%rsp
  8031ce:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031d1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031d5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031d8:	48 89 d6             	mov    %rdx,%rsi
  8031db:	89 c7                	mov    %eax,%edi
  8031dd:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  8031e4:	00 00 00 
  8031e7:	ff d0                	callq  *%rax
  8031e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031f0:	79 05                	jns    8031f7 <pipeisclosed+0x31>
		return r;
  8031f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f5:	eb 31                	jmp    803228 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8031f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031fb:	48 89 c7             	mov    %rax,%rdi
  8031fe:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  803205:	00 00 00 
  803208:	ff d0                	callq  *%rax
  80320a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80320e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803212:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803216:	48 89 d6             	mov    %rdx,%rsi
  803219:	48 89 c7             	mov    %rax,%rdi
  80321c:	48 b8 f3 30 80 00 00 	movabs $0x8030f3,%rax
  803223:	00 00 00 
  803226:	ff d0                	callq  *%rax
}
  803228:	c9                   	leaveq 
  803229:	c3                   	retq   

000000000080322a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80322a:	55                   	push   %rbp
  80322b:	48 89 e5             	mov    %rsp,%rbp
  80322e:	48 83 ec 40          	sub    $0x40,%rsp
  803232:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803236:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80323a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80323e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803242:	48 89 c7             	mov    %rax,%rdi
  803245:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  80324c:	00 00 00 
  80324f:	ff d0                	callq  *%rax
  803251:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803255:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803259:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80325d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803264:	00 
  803265:	e9 92 00 00 00       	jmpq   8032fc <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80326a:	eb 41                	jmp    8032ad <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80326c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803271:	74 09                	je     80327c <devpipe_read+0x52>
				return i;
  803273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803277:	e9 92 00 00 00       	jmpq   80330e <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80327c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803280:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803284:	48 89 d6             	mov    %rdx,%rsi
  803287:	48 89 c7             	mov    %rax,%rdi
  80328a:	48 b8 f3 30 80 00 00 	movabs $0x8030f3,%rax
  803291:	00 00 00 
  803294:	ff d0                	callq  *%rax
  803296:	85 c0                	test   %eax,%eax
  803298:	74 07                	je     8032a1 <devpipe_read+0x77>
				return 0;
  80329a:	b8 00 00 00 00       	mov    $0x0,%eax
  80329f:	eb 6d                	jmp    80330e <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8032a1:	48 b8 ce 1b 80 00 00 	movabs $0x801bce,%rax
  8032a8:	00 00 00 
  8032ab:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8032ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b1:	8b 10                	mov    (%rax),%edx
  8032b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b7:	8b 40 04             	mov    0x4(%rax),%eax
  8032ba:	39 c2                	cmp    %eax,%edx
  8032bc:	74 ae                	je     80326c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8032be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032c6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8032ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ce:	8b 00                	mov    (%rax),%eax
  8032d0:	99                   	cltd   
  8032d1:	c1 ea 1b             	shr    $0x1b,%edx
  8032d4:	01 d0                	add    %edx,%eax
  8032d6:	83 e0 1f             	and    $0x1f,%eax
  8032d9:	29 d0                	sub    %edx,%eax
  8032db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032df:	48 98                	cltq   
  8032e1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8032e6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8032e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ec:	8b 00                	mov    (%rax),%eax
  8032ee:	8d 50 01             	lea    0x1(%rax),%edx
  8032f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8032f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8032fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803300:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803304:	0f 82 60 ff ff ff    	jb     80326a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80330a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80330e:	c9                   	leaveq 
  80330f:	c3                   	retq   

0000000000803310 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803310:	55                   	push   %rbp
  803311:	48 89 e5             	mov    %rsp,%rbp
  803314:	48 83 ec 40          	sub    $0x40,%rsp
  803318:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80331c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803320:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803324:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803328:	48 89 c7             	mov    %rax,%rdi
  80332b:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  803332:	00 00 00 
  803335:	ff d0                	callq  *%rax
  803337:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80333b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80333f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803343:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80334a:	00 
  80334b:	e9 8e 00 00 00       	jmpq   8033de <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803350:	eb 31                	jmp    803383 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803352:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803356:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80335a:	48 89 d6             	mov    %rdx,%rsi
  80335d:	48 89 c7             	mov    %rax,%rdi
  803360:	48 b8 f3 30 80 00 00 	movabs $0x8030f3,%rax
  803367:	00 00 00 
  80336a:	ff d0                	callq  *%rax
  80336c:	85 c0                	test   %eax,%eax
  80336e:	74 07                	je     803377 <devpipe_write+0x67>
				return 0;
  803370:	b8 00 00 00 00       	mov    $0x0,%eax
  803375:	eb 79                	jmp    8033f0 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803377:	48 b8 ce 1b 80 00 00 	movabs $0x801bce,%rax
  80337e:	00 00 00 
  803381:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803383:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803387:	8b 40 04             	mov    0x4(%rax),%eax
  80338a:	48 63 d0             	movslq %eax,%rdx
  80338d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803391:	8b 00                	mov    (%rax),%eax
  803393:	48 98                	cltq   
  803395:	48 83 c0 20          	add    $0x20,%rax
  803399:	48 39 c2             	cmp    %rax,%rdx
  80339c:	73 b4                	jae    803352 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80339e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a2:	8b 40 04             	mov    0x4(%rax),%eax
  8033a5:	99                   	cltd   
  8033a6:	c1 ea 1b             	shr    $0x1b,%edx
  8033a9:	01 d0                	add    %edx,%eax
  8033ab:	83 e0 1f             	and    $0x1f,%eax
  8033ae:	29 d0                	sub    %edx,%eax
  8033b0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033b4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8033b8:	48 01 ca             	add    %rcx,%rdx
  8033bb:	0f b6 0a             	movzbl (%rdx),%ecx
  8033be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033c2:	48 98                	cltq   
  8033c4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8033c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033cc:	8b 40 04             	mov    0x4(%rax),%eax
  8033cf:	8d 50 01             	lea    0x1(%rax),%edx
  8033d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033d6:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8033d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8033de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033e2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8033e6:	0f 82 64 ff ff ff    	jb     803350 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8033ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8033f0:	c9                   	leaveq 
  8033f1:	c3                   	retq   

00000000008033f2 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8033f2:	55                   	push   %rbp
  8033f3:	48 89 e5             	mov    %rsp,%rbp
  8033f6:	48 83 ec 20          	sub    $0x20,%rsp
  8033fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803406:	48 89 c7             	mov    %rax,%rdi
  803409:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  803410:	00 00 00 
  803413:	ff d0                	callq  *%rax
  803415:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803419:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80341d:	48 be 06 40 80 00 00 	movabs $0x804006,%rsi
  803424:	00 00 00 
  803427:	48 89 c7             	mov    %rax,%rdi
  80342a:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  803431:	00 00 00 
  803434:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803436:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80343a:	8b 50 04             	mov    0x4(%rax),%edx
  80343d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803441:	8b 00                	mov    (%rax),%eax
  803443:	29 c2                	sub    %eax,%edx
  803445:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803449:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80344f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803453:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80345a:	00 00 00 
	stat->st_dev = &devpipe;
  80345d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803461:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  803468:	00 00 00 
  80346b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803472:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803477:	c9                   	leaveq 
  803478:	c3                   	retq   

0000000000803479 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803479:	55                   	push   %rbp
  80347a:	48 89 e5             	mov    %rsp,%rbp
  80347d:	48 83 ec 10          	sub    $0x10,%rsp
  803481:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803485:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803489:	48 89 c6             	mov    %rax,%rsi
  80348c:	bf 00 00 00 00       	mov    $0x0,%edi
  803491:	48 b8 b7 1c 80 00 00 	movabs $0x801cb7,%rax
  803498:	00 00 00 
  80349b:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80349d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034a1:	48 89 c7             	mov    %rax,%rdi
  8034a4:	48 b8 9c 1e 80 00 00 	movabs $0x801e9c,%rax
  8034ab:	00 00 00 
  8034ae:	ff d0                	callq  *%rax
  8034b0:	48 89 c6             	mov    %rax,%rsi
  8034b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8034b8:	48 b8 b7 1c 80 00 00 	movabs $0x801cb7,%rax
  8034bf:	00 00 00 
  8034c2:	ff d0                	callq  *%rax
}
  8034c4:	c9                   	leaveq 
  8034c5:	c3                   	retq   

00000000008034c6 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8034c6:	55                   	push   %rbp
  8034c7:	48 89 e5             	mov    %rsp,%rbp
  8034ca:	48 83 ec 20          	sub    $0x20,%rsp
  8034ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8034d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034d4:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8034d7:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8034db:	be 01 00 00 00       	mov    $0x1,%esi
  8034e0:	48 89 c7             	mov    %rax,%rdi
  8034e3:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  8034ea:	00 00 00 
  8034ed:	ff d0                	callq  *%rax
}
  8034ef:	c9                   	leaveq 
  8034f0:	c3                   	retq   

00000000008034f1 <getchar>:

int
getchar(void)
{
  8034f1:	55                   	push   %rbp
  8034f2:	48 89 e5             	mov    %rsp,%rbp
  8034f5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8034f9:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8034fd:	ba 01 00 00 00       	mov    $0x1,%edx
  803502:	48 89 c6             	mov    %rax,%rsi
  803505:	bf 00 00 00 00       	mov    $0x0,%edi
  80350a:	48 b8 91 23 80 00 00 	movabs $0x802391,%rax
  803511:	00 00 00 
  803514:	ff d0                	callq  *%rax
  803516:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803519:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80351d:	79 05                	jns    803524 <getchar+0x33>
		return r;
  80351f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803522:	eb 14                	jmp    803538 <getchar+0x47>
	if (r < 1)
  803524:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803528:	7f 07                	jg     803531 <getchar+0x40>
		return -E_EOF;
  80352a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80352f:	eb 07                	jmp    803538 <getchar+0x47>
	return c;
  803531:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803535:	0f b6 c0             	movzbl %al,%eax
}
  803538:	c9                   	leaveq 
  803539:	c3                   	retq   

000000000080353a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80353a:	55                   	push   %rbp
  80353b:	48 89 e5             	mov    %rsp,%rbp
  80353e:	48 83 ec 20          	sub    $0x20,%rsp
  803542:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803545:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803549:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80354c:	48 89 d6             	mov    %rdx,%rsi
  80354f:	89 c7                	mov    %eax,%edi
  803551:	48 b8 5f 1f 80 00 00 	movabs $0x801f5f,%rax
  803558:	00 00 00 
  80355b:	ff d0                	callq  *%rax
  80355d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803560:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803564:	79 05                	jns    80356b <iscons+0x31>
		return r;
  803566:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803569:	eb 1a                	jmp    803585 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80356b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80356f:	8b 10                	mov    (%rax),%edx
  803571:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803578:	00 00 00 
  80357b:	8b 00                	mov    (%rax),%eax
  80357d:	39 c2                	cmp    %eax,%edx
  80357f:	0f 94 c0             	sete   %al
  803582:	0f b6 c0             	movzbl %al,%eax
}
  803585:	c9                   	leaveq 
  803586:	c3                   	retq   

0000000000803587 <opencons>:

int
opencons(void)
{
  803587:	55                   	push   %rbp
  803588:	48 89 e5             	mov    %rsp,%rbp
  80358b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80358f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803593:	48 89 c7             	mov    %rax,%rdi
  803596:	48 b8 c7 1e 80 00 00 	movabs $0x801ec7,%rax
  80359d:	00 00 00 
  8035a0:	ff d0                	callq  *%rax
  8035a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035a9:	79 05                	jns    8035b0 <opencons+0x29>
		return r;
  8035ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ae:	eb 5b                	jmp    80360b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8035b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035b4:	ba 07 04 00 00       	mov    $0x407,%edx
  8035b9:	48 89 c6             	mov    %rax,%rsi
  8035bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8035c1:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  8035c8:	00 00 00 
  8035cb:	ff d0                	callq  *%rax
  8035cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035d4:	79 05                	jns    8035db <opencons+0x54>
		return r;
  8035d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d9:	eb 30                	jmp    80360b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8035db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035df:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8035e6:	00 00 00 
  8035e9:	8b 12                	mov    (%rdx),%edx
  8035eb:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8035ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8035f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035fc:	48 89 c7             	mov    %rax,%rdi
  8035ff:	48 b8 79 1e 80 00 00 	movabs $0x801e79,%rax
  803606:	00 00 00 
  803609:	ff d0                	callq  *%rax
}
  80360b:	c9                   	leaveq 
  80360c:	c3                   	retq   

000000000080360d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80360d:	55                   	push   %rbp
  80360e:	48 89 e5             	mov    %rsp,%rbp
  803611:	48 83 ec 30          	sub    $0x30,%rsp
  803615:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803619:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80361d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803621:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803626:	75 07                	jne    80362f <devcons_read+0x22>
		return 0;
  803628:	b8 00 00 00 00       	mov    $0x0,%eax
  80362d:	eb 4b                	jmp    80367a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80362f:	eb 0c                	jmp    80363d <devcons_read+0x30>
		sys_yield();
  803631:	48 b8 ce 1b 80 00 00 	movabs $0x801bce,%rax
  803638:	00 00 00 
  80363b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80363d:	48 b8 0e 1b 80 00 00 	movabs $0x801b0e,%rax
  803644:	00 00 00 
  803647:	ff d0                	callq  *%rax
  803649:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80364c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803650:	74 df                	je     803631 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803652:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803656:	79 05                	jns    80365d <devcons_read+0x50>
		return c;
  803658:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80365b:	eb 1d                	jmp    80367a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80365d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803661:	75 07                	jne    80366a <devcons_read+0x5d>
		return 0;
  803663:	b8 00 00 00 00       	mov    $0x0,%eax
  803668:	eb 10                	jmp    80367a <devcons_read+0x6d>
	*(char*)vbuf = c;
  80366a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366d:	89 c2                	mov    %eax,%edx
  80366f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803673:	88 10                	mov    %dl,(%rax)
	return 1;
  803675:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80367a:	c9                   	leaveq 
  80367b:	c3                   	retq   

000000000080367c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80367c:	55                   	push   %rbp
  80367d:	48 89 e5             	mov    %rsp,%rbp
  803680:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803687:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80368e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803695:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80369c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8036a3:	eb 76                	jmp    80371b <devcons_write+0x9f>
		m = n - tot;
  8036a5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8036ac:	89 c2                	mov    %eax,%edx
  8036ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b1:	29 c2                	sub    %eax,%edx
  8036b3:	89 d0                	mov    %edx,%eax
  8036b5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8036b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036bb:	83 f8 7f             	cmp    $0x7f,%eax
  8036be:	76 07                	jbe    8036c7 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8036c0:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8036c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036ca:	48 63 d0             	movslq %eax,%rdx
  8036cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d0:	48 63 c8             	movslq %eax,%rcx
  8036d3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8036da:	48 01 c1             	add    %rax,%rcx
  8036dd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8036e4:	48 89 ce             	mov    %rcx,%rsi
  8036e7:	48 89 c7             	mov    %rax,%rdi
  8036ea:	48 b8 01 16 80 00 00 	movabs $0x801601,%rax
  8036f1:	00 00 00 
  8036f4:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8036f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036f9:	48 63 d0             	movslq %eax,%rdx
  8036fc:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803703:	48 89 d6             	mov    %rdx,%rsi
  803706:	48 89 c7             	mov    %rax,%rdi
  803709:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  803710:	00 00 00 
  803713:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803715:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803718:	01 45 fc             	add    %eax,-0x4(%rbp)
  80371b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80371e:	48 98                	cltq   
  803720:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803727:	0f 82 78 ff ff ff    	jb     8036a5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80372d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803730:	c9                   	leaveq 
  803731:	c3                   	retq   

0000000000803732 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803732:	55                   	push   %rbp
  803733:	48 89 e5             	mov    %rsp,%rbp
  803736:	48 83 ec 08          	sub    $0x8,%rsp
  80373a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80373e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803743:	c9                   	leaveq 
  803744:	c3                   	retq   

0000000000803745 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803745:	55                   	push   %rbp
  803746:	48 89 e5             	mov    %rsp,%rbp
  803749:	48 83 ec 10          	sub    $0x10,%rsp
  80374d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803751:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803755:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803759:	48 be 12 40 80 00 00 	movabs $0x804012,%rsi
  803760:	00 00 00 
  803763:	48 89 c7             	mov    %rax,%rdi
  803766:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  80376d:	00 00 00 
  803770:	ff d0                	callq  *%rax
	return 0;
  803772:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803777:	c9                   	leaveq 
  803778:	c3                   	retq   

0000000000803779 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803779:	55                   	push   %rbp
  80377a:	48 89 e5             	mov    %rsp,%rbp
  80377d:	48 83 ec 30          	sub    $0x30,%rsp
  803781:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803785:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803789:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  80378d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803791:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803795:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80379a:	75 0e                	jne    8037aa <ipc_recv+0x31>
		page = (void *)KERNBASE;
  80379c:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8037a3:	00 00 00 
  8037a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  8037aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ae:	48 89 c7             	mov    %rax,%rdi
  8037b1:	48 b8 35 1e 80 00 00 	movabs $0x801e35,%rax
  8037b8:	00 00 00 
  8037bb:	ff d0                	callq  *%rax
  8037bd:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8037c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8037c4:	79 27                	jns    8037ed <ipc_recv+0x74>
		if (from_env_store != NULL)
  8037c6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8037cb:	74 0a                	je     8037d7 <ipc_recv+0x5e>
			*from_env_store = 0;
  8037cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037d1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  8037d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8037dc:	74 0a                	je     8037e8 <ipc_recv+0x6f>
			*perm_store = 0;
  8037de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037e2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8037e8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037eb:	eb 53                	jmp    803840 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  8037ed:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8037f2:	74 19                	je     80380d <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  8037f4:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8037fb:	00 00 00 
  8037fe:	48 8b 00             	mov    (%rax),%rax
  803801:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803807:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80380b:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  80380d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803812:	74 19                	je     80382d <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803814:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80381b:	00 00 00 
  80381e:	48 8b 00             	mov    (%rax),%rax
  803821:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803827:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80382b:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  80382d:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803834:	00 00 00 
  803837:	48 8b 00             	mov    (%rax),%rax
  80383a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803840:	c9                   	leaveq 
  803841:	c3                   	retq   

0000000000803842 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803842:	55                   	push   %rbp
  803843:	48 89 e5             	mov    %rsp,%rbp
  803846:	48 83 ec 30          	sub    $0x30,%rsp
  80384a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80384d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803850:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803854:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803857:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80385b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  80385f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803864:	75 10                	jne    803876 <ipc_send+0x34>
		page = (void *)KERNBASE;
  803866:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  80386d:	00 00 00 
  803870:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803874:	eb 0e                	jmp    803884 <ipc_send+0x42>
  803876:	eb 0c                	jmp    803884 <ipc_send+0x42>
		sys_yield();
  803878:	48 b8 ce 1b 80 00 00 	movabs $0x801bce,%rax
  80387f:	00 00 00 
  803882:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803884:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803887:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80388a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80388e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803891:	89 c7                	mov    %eax,%edi
  803893:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  80389a:	00 00 00 
  80389d:	ff d0                	callq  *%rax
  80389f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8038a2:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  8038a6:	74 d0                	je     803878 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  8038a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8038ac:	74 2a                	je     8038d8 <ipc_send+0x96>
		panic("error on ipc send procedure");
  8038ae:	48 ba 19 40 80 00 00 	movabs $0x804019,%rdx
  8038b5:	00 00 00 
  8038b8:	be 49 00 00 00       	mov    $0x49,%esi
  8038bd:	48 bf 35 40 80 00 00 	movabs $0x804035,%rdi
  8038c4:	00 00 00 
  8038c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8038cc:	48 b9 fc 02 80 00 00 	movabs $0x8002fc,%rcx
  8038d3:	00 00 00 
  8038d6:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  8038d8:	c9                   	leaveq 
  8038d9:	c3                   	retq   

00000000008038da <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8038da:	55                   	push   %rbp
  8038db:	48 89 e5             	mov    %rsp,%rbp
  8038de:	48 83 ec 14          	sub    $0x14,%rsp
  8038e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8038e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8038ec:	eb 5e                	jmp    80394c <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8038ee:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8038f5:	00 00 00 
  8038f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038fb:	48 63 d0             	movslq %eax,%rdx
  8038fe:	48 89 d0             	mov    %rdx,%rax
  803901:	48 c1 e0 03          	shl    $0x3,%rax
  803905:	48 01 d0             	add    %rdx,%rax
  803908:	48 c1 e0 05          	shl    $0x5,%rax
  80390c:	48 01 c8             	add    %rcx,%rax
  80390f:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803915:	8b 00                	mov    (%rax),%eax
  803917:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80391a:	75 2c                	jne    803948 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80391c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803923:	00 00 00 
  803926:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803929:	48 63 d0             	movslq %eax,%rdx
  80392c:	48 89 d0             	mov    %rdx,%rax
  80392f:	48 c1 e0 03          	shl    $0x3,%rax
  803933:	48 01 d0             	add    %rdx,%rax
  803936:	48 c1 e0 05          	shl    $0x5,%rax
  80393a:	48 01 c8             	add    %rcx,%rax
  80393d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803943:	8b 40 08             	mov    0x8(%rax),%eax
  803946:	eb 12                	jmp    80395a <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803948:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80394c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803953:	7e 99                	jle    8038ee <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803955:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80395a:	c9                   	leaveq 
  80395b:	c3                   	retq   

000000000080395c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80395c:	55                   	push   %rbp
  80395d:	48 89 e5             	mov    %rsp,%rbp
  803960:	48 83 ec 18          	sub    $0x18,%rsp
  803964:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803968:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80396c:	48 c1 e8 15          	shr    $0x15,%rax
  803970:	48 89 c2             	mov    %rax,%rdx
  803973:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80397a:	01 00 00 
  80397d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803981:	83 e0 01             	and    $0x1,%eax
  803984:	48 85 c0             	test   %rax,%rax
  803987:	75 07                	jne    803990 <pageref+0x34>
		return 0;
  803989:	b8 00 00 00 00       	mov    $0x0,%eax
  80398e:	eb 53                	jmp    8039e3 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803990:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803994:	48 c1 e8 0c          	shr    $0xc,%rax
  803998:	48 89 c2             	mov    %rax,%rdx
  80399b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8039a2:	01 00 00 
  8039a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039a9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8039ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039b1:	83 e0 01             	and    $0x1,%eax
  8039b4:	48 85 c0             	test   %rax,%rax
  8039b7:	75 07                	jne    8039c0 <pageref+0x64>
		return 0;
  8039b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8039be:	eb 23                	jmp    8039e3 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8039c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039c4:	48 c1 e8 0c          	shr    $0xc,%rax
  8039c8:	48 89 c2             	mov    %rax,%rdx
  8039cb:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8039d2:	00 00 00 
  8039d5:	48 c1 e2 04          	shl    $0x4,%rdx
  8039d9:	48 01 d0             	add    %rdx,%rax
  8039dc:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8039e0:	0f b7 c0             	movzwl %ax,%eax
}
  8039e3:	c9                   	leaveq 
  8039e4:	c3                   	retq   
