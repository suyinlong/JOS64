
obj/user/lsfd.debug:     file format elf64-x86-64


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
  80003c:	e8 7c 01 00 00       	callq  8001bd <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: lsfd [-1]\n");
  800047:	48 bf 40 3c 80 00 00 	movabs $0x803c40,%rdi
  80004e:	00 00 00 
  800051:	b8 00 00 00 00       	mov    $0x0,%eax
  800056:	48 ba 95 03 80 00 00 	movabs $0x800395,%rdx
  80005d:	00 00 00 
  800060:	ff d2                	callq  *%rdx
	exit();
  800062:	48 b8 4d 02 80 00 00 	movabs $0x80024d,%rax
  800069:	00 00 00 
  80006c:	ff d0                	callq  *%rax
}
  80006e:	5d                   	pop    %rbp
  80006f:	c3                   	retq   

0000000000800070 <umain>:

void
umain(int argc, char **argv)
{
  800070:	55                   	push   %rbp
  800071:	48 89 e5             	mov    %rsp,%rbp
  800074:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80007b:	89 bd 3c ff ff ff    	mov    %edi,-0xc4(%rbp)
  800081:	48 89 b5 30 ff ff ff 	mov    %rsi,-0xd0(%rbp)
	int i, usefprint = 0;
  800088:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  80008f:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  800096:	48 8b 8d 30 ff ff ff 	mov    -0xd0(%rbp),%rcx
  80009d:	48 8d 85 3c ff ff ff 	lea    -0xc4(%rbp),%rax
  8000a4:	48 89 ce             	mov    %rcx,%rsi
  8000a7:	48 89 c7             	mov    %rax,%rdi
  8000aa:	48 b8 d9 1c 80 00 00 	movabs $0x801cd9,%rax
  8000b1:	00 00 00 
  8000b4:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  8000b6:	eb 1b                	jmp    8000d3 <umain+0x63>
		if (i == '1')
  8000b8:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  8000bc:	75 09                	jne    8000c7 <umain+0x57>
			usefprint = 1;
  8000be:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
  8000c5:	eb 0c                	jmp    8000d3 <umain+0x63>
		else
			usage();
  8000c7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ce:	00 00 00 
  8000d1:	ff d0                	callq  *%rax
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8000d3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 3d 1d 80 00 00 	movabs $0x801d3d,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000f0:	79 c6                	jns    8000b8 <umain+0x48>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8000f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000f9:	e9 b3 00 00 00       	jmpq   8001b1 <umain+0x141>
		if (fstat(i, &st) >= 0) {
  8000fe:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800105:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800108:	48 89 d6             	mov    %rdx,%rsi
  80010b:	89 c7                	mov    %eax,%edi
  80010d:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
  800119:	85 c0                	test   %eax,%eax
  80011b:	0f 88 8c 00 00 00    	js     8001ad <umain+0x13d>
			if (usefprint)
  800121:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800125:	74 4a                	je     800171 <umain+0x101>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  80012b:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80012f:	8b 7d e0             	mov    -0x20(%rbp),%edi
  800132:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800135:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80013c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80013f:	48 89 0c 24          	mov    %rcx,(%rsp)
  800143:	41 89 f9             	mov    %edi,%r9d
  800146:	41 89 f0             	mov    %esi,%r8d
  800149:	48 89 d1             	mov    %rdx,%rcx
  80014c:	89 c2                	mov    %eax,%edx
  80014e:	48 be 58 3c 80 00 00 	movabs $0x803c58,%rsi
  800155:	00 00 00 
  800158:	bf 01 00 00 00       	mov    $0x1,%edi
  80015d:	b8 00 00 00 00       	mov    $0x0,%eax
  800162:	49 ba d4 2e 80 00 00 	movabs $0x802ed4,%r10
  800169:	00 00 00 
  80016c:	41 ff d2             	callq  *%r10
  80016f:	eb 3c                	jmp    8001ad <umain+0x13d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  800175:	48 8b 78 08          	mov    0x8(%rax),%rdi
  800179:	8b 75 e0             	mov    -0x20(%rbp),%esi
  80017c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80017f:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800189:	49 89 f9             	mov    %rdi,%r9
  80018c:	41 89 f0             	mov    %esi,%r8d
  80018f:	89 c6                	mov    %eax,%esi
  800191:	48 bf 58 3c 80 00 00 	movabs $0x803c58,%rdi
  800198:	00 00 00 
  80019b:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a0:	49 ba 95 03 80 00 00 	movabs $0x800395,%r10
  8001a7:	00 00 00 
  8001aa:	41 ff d2             	callq  *%r10
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8001ad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001b1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8001b5:	0f 8e 43 ff ff ff    	jle    8000fe <umain+0x8e>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  8001bb:	c9                   	leaveq 
  8001bc:	c3                   	retq   

00000000008001bd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001bd:	55                   	push   %rbp
  8001be:	48 89 e5             	mov    %rsp,%rbp
  8001c1:	48 83 ec 10          	sub    $0x10,%rsp
  8001c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  8001cc:	48 b8 f0 19 80 00 00 	movabs $0x8019f0,%rax
  8001d3:	00 00 00 
  8001d6:	ff d0                	callq  *%rax
  8001d8:	48 98                	cltq   
  8001da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001df:	48 89 c2             	mov    %rax,%rdx
  8001e2:	48 89 d0             	mov    %rdx,%rax
  8001e5:	48 c1 e0 03          	shl    $0x3,%rax
  8001e9:	48 01 d0             	add    %rdx,%rax
  8001ec:	48 c1 e0 05          	shl    $0x5,%rax
  8001f0:	48 89 c2             	mov    %rax,%rdx
  8001f3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001fa:	00 00 00 
  8001fd:	48 01 c2             	add    %rax,%rdx
  800200:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800207:	00 00 00 
  80020a:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80020d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800211:	7e 14                	jle    800227 <libmain+0x6a>
		binaryname = argv[0];
  800213:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800217:	48 8b 10             	mov    (%rax),%rdx
  80021a:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800221:	00 00 00 
  800224:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800227:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80022b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80022e:	48 89 d6             	mov    %rdx,%rsi
  800231:	89 c7                	mov    %eax,%edi
  800233:	48 b8 70 00 80 00 00 	movabs $0x800070,%rax
  80023a:	00 00 00 
  80023d:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80023f:	48 b8 4d 02 80 00 00 	movabs $0x80024d,%rax
  800246:	00 00 00 
  800249:	ff d0                	callq  *%rax
}
  80024b:	c9                   	leaveq 
  80024c:	c3                   	retq   

000000000080024d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80024d:	55                   	push   %rbp
  80024e:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800251:	48 b8 ff 22 80 00 00 	movabs $0x8022ff,%rax
  800258:	00 00 00 
  80025b:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80025d:	bf 00 00 00 00       	mov    $0x0,%edi
  800262:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  800269:	00 00 00 
  80026c:	ff d0                	callq  *%rax
}
  80026e:	5d                   	pop    %rbp
  80026f:	c3                   	retq   

0000000000800270 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800270:	55                   	push   %rbp
  800271:	48 89 e5             	mov    %rsp,%rbp
  800274:	48 83 ec 10          	sub    $0x10,%rsp
  800278:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80027b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80027f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800283:	8b 00                	mov    (%rax),%eax
  800285:	8d 48 01             	lea    0x1(%rax),%ecx
  800288:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80028c:	89 0a                	mov    %ecx,(%rdx)
  80028e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800291:	89 d1                	mov    %edx,%ecx
  800293:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800297:	48 98                	cltq   
  800299:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80029d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a1:	8b 00                	mov    (%rax),%eax
  8002a3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a8:	75 2c                	jne    8002d6 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  8002aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ae:	8b 00                	mov    (%rax),%eax
  8002b0:	48 98                	cltq   
  8002b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002b6:	48 83 c2 08          	add    $0x8,%rdx
  8002ba:	48 89 c6             	mov    %rax,%rsi
  8002bd:	48 89 d7             	mov    %rdx,%rdi
  8002c0:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  8002c7:	00 00 00 
  8002ca:	ff d0                	callq  *%rax
		b->idx = 0;
  8002cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8002d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002da:	8b 40 04             	mov    0x4(%rax),%eax
  8002dd:	8d 50 01             	lea    0x1(%rax),%edx
  8002e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e4:	89 50 04             	mov    %edx,0x4(%rax)
}
  8002e7:	c9                   	leaveq 
  8002e8:	c3                   	retq   

00000000008002e9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002e9:	55                   	push   %rbp
  8002ea:	48 89 e5             	mov    %rsp,%rbp
  8002ed:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8002f4:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8002fb:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800302:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800309:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800310:	48 8b 0a             	mov    (%rdx),%rcx
  800313:	48 89 08             	mov    %rcx,(%rax)
  800316:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80031a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80031e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800322:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800326:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80032d:	00 00 00 
	b.cnt = 0;
  800330:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800337:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80033a:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800341:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800348:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80034f:	48 89 c6             	mov    %rax,%rsi
  800352:	48 bf 70 02 80 00 00 	movabs $0x800270,%rdi
  800359:	00 00 00 
  80035c:	48 b8 48 07 80 00 00 	movabs $0x800748,%rax
  800363:	00 00 00 
  800366:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800368:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80036e:	48 98                	cltq   
  800370:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800377:	48 83 c2 08          	add    $0x8,%rdx
  80037b:	48 89 c6             	mov    %rax,%rsi
  80037e:	48 89 d7             	mov    %rdx,%rdi
  800381:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  800388:	00 00 00 
  80038b:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80038d:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800393:	c9                   	leaveq 
  800394:	c3                   	retq   

0000000000800395 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800395:	55                   	push   %rbp
  800396:	48 89 e5             	mov    %rsp,%rbp
  800399:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003a0:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003a7:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003ae:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003b5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003bc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003c3:	84 c0                	test   %al,%al
  8003c5:	74 20                	je     8003e7 <cprintf+0x52>
  8003c7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8003cb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8003cf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8003d3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8003d7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8003db:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8003df:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8003e3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8003e7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8003ee:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8003f5:	00 00 00 
  8003f8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003ff:	00 00 00 
  800402:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800406:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80040d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800414:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80041b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800422:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800429:	48 8b 0a             	mov    (%rdx),%rcx
  80042c:	48 89 08             	mov    %rcx,(%rax)
  80042f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800433:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800437:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80043b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80043f:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800446:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80044d:	48 89 d6             	mov    %rdx,%rsi
  800450:	48 89 c7             	mov    %rax,%rdi
  800453:	48 b8 e9 02 80 00 00 	movabs $0x8002e9,%rax
  80045a:	00 00 00 
  80045d:	ff d0                	callq  *%rax
  80045f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800465:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80046b:	c9                   	leaveq 
  80046c:	c3                   	retq   

000000000080046d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80046d:	55                   	push   %rbp
  80046e:	48 89 e5             	mov    %rsp,%rbp
  800471:	53                   	push   %rbx
  800472:	48 83 ec 38          	sub    $0x38,%rsp
  800476:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80047a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80047e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800482:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800485:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800489:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80048d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800490:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800494:	77 3b                	ja     8004d1 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800496:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800499:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80049d:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a9:	48 f7 f3             	div    %rbx
  8004ac:	48 89 c2             	mov    %rax,%rdx
  8004af:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004b2:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004b5:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bd:	41 89 f9             	mov    %edi,%r9d
  8004c0:	48 89 c7             	mov    %rax,%rdi
  8004c3:	48 b8 6d 04 80 00 00 	movabs $0x80046d,%rax
  8004ca:	00 00 00 
  8004cd:	ff d0                	callq  *%rax
  8004cf:	eb 1e                	jmp    8004ef <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004d1:	eb 12                	jmp    8004e5 <printnum+0x78>
			putch(padc, putdat);
  8004d3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004d7:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8004da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004de:	48 89 ce             	mov    %rcx,%rsi
  8004e1:	89 d7                	mov    %edx,%edi
  8004e3:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004e5:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8004e9:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8004ed:	7f e4                	jg     8004d3 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ef:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fb:	48 f7 f1             	div    %rcx
  8004fe:	48 89 d0             	mov    %rdx,%rax
  800501:	48 ba 68 3e 80 00 00 	movabs $0x803e68,%rdx
  800508:	00 00 00 
  80050b:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80050f:	0f be d0             	movsbl %al,%edx
  800512:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800516:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051a:	48 89 ce             	mov    %rcx,%rsi
  80051d:	89 d7                	mov    %edx,%edi
  80051f:	ff d0                	callq  *%rax
}
  800521:	48 83 c4 38          	add    $0x38,%rsp
  800525:	5b                   	pop    %rbx
  800526:	5d                   	pop    %rbp
  800527:	c3                   	retq   

0000000000800528 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800528:	55                   	push   %rbp
  800529:	48 89 e5             	mov    %rsp,%rbp
  80052c:	48 83 ec 1c          	sub    $0x1c,%rsp
  800530:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800534:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800537:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80053b:	7e 52                	jle    80058f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80053d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800541:	8b 00                	mov    (%rax),%eax
  800543:	83 f8 30             	cmp    $0x30,%eax
  800546:	73 24                	jae    80056c <getuint+0x44>
  800548:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800554:	8b 00                	mov    (%rax),%eax
  800556:	89 c0                	mov    %eax,%eax
  800558:	48 01 d0             	add    %rdx,%rax
  80055b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055f:	8b 12                	mov    (%rdx),%edx
  800561:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800564:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800568:	89 0a                	mov    %ecx,(%rdx)
  80056a:	eb 17                	jmp    800583 <getuint+0x5b>
  80056c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800570:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800574:	48 89 d0             	mov    %rdx,%rax
  800577:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80057b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80057f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800583:	48 8b 00             	mov    (%rax),%rax
  800586:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80058a:	e9 a3 00 00 00       	jmpq   800632 <getuint+0x10a>
	else if (lflag)
  80058f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800593:	74 4f                	je     8005e4 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800599:	8b 00                	mov    (%rax),%eax
  80059b:	83 f8 30             	cmp    $0x30,%eax
  80059e:	73 24                	jae    8005c4 <getuint+0x9c>
  8005a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ac:	8b 00                	mov    (%rax),%eax
  8005ae:	89 c0                	mov    %eax,%eax
  8005b0:	48 01 d0             	add    %rdx,%rax
  8005b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b7:	8b 12                	mov    (%rdx),%edx
  8005b9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c0:	89 0a                	mov    %ecx,(%rdx)
  8005c2:	eb 17                	jmp    8005db <getuint+0xb3>
  8005c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005cc:	48 89 d0             	mov    %rdx,%rax
  8005cf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005db:	48 8b 00             	mov    (%rax),%rax
  8005de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005e2:	eb 4e                	jmp    800632 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8005e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e8:	8b 00                	mov    (%rax),%eax
  8005ea:	83 f8 30             	cmp    $0x30,%eax
  8005ed:	73 24                	jae    800613 <getuint+0xeb>
  8005ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fb:	8b 00                	mov    (%rax),%eax
  8005fd:	89 c0                	mov    %eax,%eax
  8005ff:	48 01 d0             	add    %rdx,%rax
  800602:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800606:	8b 12                	mov    (%rdx),%edx
  800608:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80060b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060f:	89 0a                	mov    %ecx,(%rdx)
  800611:	eb 17                	jmp    80062a <getuint+0x102>
  800613:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800617:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80061b:	48 89 d0             	mov    %rdx,%rax
  80061e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800622:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800626:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80062a:	8b 00                	mov    (%rax),%eax
  80062c:	89 c0                	mov    %eax,%eax
  80062e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800632:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800636:	c9                   	leaveq 
  800637:	c3                   	retq   

0000000000800638 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800638:	55                   	push   %rbp
  800639:	48 89 e5             	mov    %rsp,%rbp
  80063c:	48 83 ec 1c          	sub    $0x1c,%rsp
  800640:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800644:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800647:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80064b:	7e 52                	jle    80069f <getint+0x67>
		x=va_arg(*ap, long long);
  80064d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800651:	8b 00                	mov    (%rax),%eax
  800653:	83 f8 30             	cmp    $0x30,%eax
  800656:	73 24                	jae    80067c <getint+0x44>
  800658:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800664:	8b 00                	mov    (%rax),%eax
  800666:	89 c0                	mov    %eax,%eax
  800668:	48 01 d0             	add    %rdx,%rax
  80066b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066f:	8b 12                	mov    (%rdx),%edx
  800671:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800674:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800678:	89 0a                	mov    %ecx,(%rdx)
  80067a:	eb 17                	jmp    800693 <getint+0x5b>
  80067c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800680:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800684:	48 89 d0             	mov    %rdx,%rax
  800687:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80068b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800693:	48 8b 00             	mov    (%rax),%rax
  800696:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80069a:	e9 a3 00 00 00       	jmpq   800742 <getint+0x10a>
	else if (lflag)
  80069f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006a3:	74 4f                	je     8006f4 <getint+0xbc>
		x=va_arg(*ap, long);
  8006a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a9:	8b 00                	mov    (%rax),%eax
  8006ab:	83 f8 30             	cmp    $0x30,%eax
  8006ae:	73 24                	jae    8006d4 <getint+0x9c>
  8006b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bc:	8b 00                	mov    (%rax),%eax
  8006be:	89 c0                	mov    %eax,%eax
  8006c0:	48 01 d0             	add    %rdx,%rax
  8006c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c7:	8b 12                	mov    (%rdx),%edx
  8006c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d0:	89 0a                	mov    %ecx,(%rdx)
  8006d2:	eb 17                	jmp    8006eb <getint+0xb3>
  8006d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006dc:	48 89 d0             	mov    %rdx,%rax
  8006df:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006eb:	48 8b 00             	mov    (%rax),%rax
  8006ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006f2:	eb 4e                	jmp    800742 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8006f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f8:	8b 00                	mov    (%rax),%eax
  8006fa:	83 f8 30             	cmp    $0x30,%eax
  8006fd:	73 24                	jae    800723 <getint+0xeb>
  8006ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800703:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800707:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070b:	8b 00                	mov    (%rax),%eax
  80070d:	89 c0                	mov    %eax,%eax
  80070f:	48 01 d0             	add    %rdx,%rax
  800712:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800716:	8b 12                	mov    (%rdx),%edx
  800718:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80071b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071f:	89 0a                	mov    %ecx,(%rdx)
  800721:	eb 17                	jmp    80073a <getint+0x102>
  800723:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800727:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80072b:	48 89 d0             	mov    %rdx,%rax
  80072e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800732:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800736:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80073a:	8b 00                	mov    (%rax),%eax
  80073c:	48 98                	cltq   
  80073e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800742:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800746:	c9                   	leaveq 
  800747:	c3                   	retq   

0000000000800748 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800748:	55                   	push   %rbp
  800749:	48 89 e5             	mov    %rsp,%rbp
  80074c:	41 54                	push   %r12
  80074e:	53                   	push   %rbx
  80074f:	48 83 ec 60          	sub    $0x60,%rsp
  800753:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800757:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80075b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80075f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800763:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800767:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80076b:	48 8b 0a             	mov    (%rdx),%rcx
  80076e:	48 89 08             	mov    %rcx,(%rax)
  800771:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800775:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800779:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80077d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  800781:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800785:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800789:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80078d:	0f b6 00             	movzbl (%rax),%eax
  800790:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  800793:	eb 29                	jmp    8007be <vprintfmt+0x76>
			if (ch == '\0')
  800795:	85 db                	test   %ebx,%ebx
  800797:	0f 84 ad 06 00 00    	je     800e4a <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  80079d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007a1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007a5:	48 89 d6             	mov    %rdx,%rsi
  8007a8:	89 df                	mov    %ebx,%edi
  8007aa:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  8007ac:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007b0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007b4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007b8:	0f b6 00             	movzbl (%rax),%eax
  8007bb:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  8007be:	83 fb 25             	cmp    $0x25,%ebx
  8007c1:	74 05                	je     8007c8 <vprintfmt+0x80>
  8007c3:	83 fb 1b             	cmp    $0x1b,%ebx
  8007c6:	75 cd                	jne    800795 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  8007c8:	83 fb 1b             	cmp    $0x1b,%ebx
  8007cb:	0f 85 ae 01 00 00    	jne    80097f <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  8007d1:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8007d8:	00 00 00 
  8007db:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  8007e1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007e5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007e9:	48 89 d6             	mov    %rdx,%rsi
  8007ec:	89 df                	mov    %ebx,%edi
  8007ee:	ff d0                	callq  *%rax
			putch('[', putdat);
  8007f0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007f4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007f8:	48 89 d6             	mov    %rdx,%rsi
  8007fb:	bf 5b 00 00 00       	mov    $0x5b,%edi
  800800:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800802:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800808:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80080d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800811:	0f b6 00             	movzbl (%rax),%eax
  800814:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800817:	eb 32                	jmp    80084b <vprintfmt+0x103>
					putch(ch, putdat);
  800819:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80081d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800821:	48 89 d6             	mov    %rdx,%rsi
  800824:	89 df                	mov    %ebx,%edi
  800826:	ff d0                	callq  *%rax
					esc_color *= 10;
  800828:	44 89 e0             	mov    %r12d,%eax
  80082b:	c1 e0 02             	shl    $0x2,%eax
  80082e:	44 01 e0             	add    %r12d,%eax
  800831:	01 c0                	add    %eax,%eax
  800833:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800836:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800839:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  80083c:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800841:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800845:	0f b6 00             	movzbl (%rax),%eax
  800848:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  80084b:	83 fb 3b             	cmp    $0x3b,%ebx
  80084e:	74 05                	je     800855 <vprintfmt+0x10d>
  800850:	83 fb 6d             	cmp    $0x6d,%ebx
  800853:	75 c4                	jne    800819 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800855:	45 85 e4             	test   %r12d,%r12d
  800858:	75 15                	jne    80086f <vprintfmt+0x127>
					color_flag = 0x07;
  80085a:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800861:	00 00 00 
  800864:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  80086a:	e9 dc 00 00 00       	jmpq   80094b <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  80086f:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800873:	7e 69                	jle    8008de <vprintfmt+0x196>
  800875:	41 83 fc 25          	cmp    $0x25,%r12d
  800879:	7f 63                	jg     8008de <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  80087b:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800882:	00 00 00 
  800885:	8b 00                	mov    (%rax),%eax
  800887:	25 f8 00 00 00       	and    $0xf8,%eax
  80088c:	89 c2                	mov    %eax,%edx
  80088e:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800895:	00 00 00 
  800898:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  80089a:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  80089e:	44 89 e0             	mov    %r12d,%eax
  8008a1:	83 e0 04             	and    $0x4,%eax
  8008a4:	c1 f8 02             	sar    $0x2,%eax
  8008a7:	89 c2                	mov    %eax,%edx
  8008a9:	44 89 e0             	mov    %r12d,%eax
  8008ac:	83 e0 02             	and    $0x2,%eax
  8008af:	09 c2                	or     %eax,%edx
  8008b1:	44 89 e0             	mov    %r12d,%eax
  8008b4:	83 e0 01             	and    $0x1,%eax
  8008b7:	c1 e0 02             	shl    $0x2,%eax
  8008ba:	09 c2                	or     %eax,%edx
  8008bc:	41 89 d4             	mov    %edx,%r12d
  8008bf:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8008c6:	00 00 00 
  8008c9:	8b 00                	mov    (%rax),%eax
  8008cb:	44 89 e2             	mov    %r12d,%edx
  8008ce:	09 c2                	or     %eax,%edx
  8008d0:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8008d7:	00 00 00 
  8008da:	89 10                	mov    %edx,(%rax)
  8008dc:	eb 6d                	jmp    80094b <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  8008de:	41 83 fc 27          	cmp    $0x27,%r12d
  8008e2:	7e 67                	jle    80094b <vprintfmt+0x203>
  8008e4:	41 83 fc 2f          	cmp    $0x2f,%r12d
  8008e8:	7f 61                	jg     80094b <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  8008ea:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8008f1:	00 00 00 
  8008f4:	8b 00                	mov    (%rax),%eax
  8008f6:	25 8f 00 00 00       	and    $0x8f,%eax
  8008fb:	89 c2                	mov    %eax,%edx
  8008fd:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800904:	00 00 00 
  800907:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800909:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  80090d:	44 89 e0             	mov    %r12d,%eax
  800910:	83 e0 04             	and    $0x4,%eax
  800913:	c1 f8 02             	sar    $0x2,%eax
  800916:	89 c2                	mov    %eax,%edx
  800918:	44 89 e0             	mov    %r12d,%eax
  80091b:	83 e0 02             	and    $0x2,%eax
  80091e:	09 c2                	or     %eax,%edx
  800920:	44 89 e0             	mov    %r12d,%eax
  800923:	83 e0 01             	and    $0x1,%eax
  800926:	c1 e0 06             	shl    $0x6,%eax
  800929:	09 c2                	or     %eax,%edx
  80092b:	41 89 d4             	mov    %edx,%r12d
  80092e:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800935:	00 00 00 
  800938:	8b 00                	mov    (%rax),%eax
  80093a:	44 89 e2             	mov    %r12d,%edx
  80093d:	09 c2                	or     %eax,%edx
  80093f:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800946:	00 00 00 
  800949:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  80094b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80094f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800953:	48 89 d6             	mov    %rdx,%rsi
  800956:	89 df                	mov    %ebx,%edi
  800958:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  80095a:	83 fb 6d             	cmp    $0x6d,%ebx
  80095d:	75 1b                	jne    80097a <vprintfmt+0x232>
					fmt ++;
  80095f:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800964:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800965:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80096c:	00 00 00 
  80096f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800975:	e9 cb 04 00 00       	jmpq   800e45 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  80097a:	e9 83 fe ff ff       	jmpq   800802 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  80097f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800983:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80098a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800991:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800998:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80099f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009a3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009a7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009ab:	0f b6 00             	movzbl (%rax),%eax
  8009ae:	0f b6 d8             	movzbl %al,%ebx
  8009b1:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8009b4:	83 f8 55             	cmp    $0x55,%eax
  8009b7:	0f 87 5a 04 00 00    	ja     800e17 <vprintfmt+0x6cf>
  8009bd:	89 c0                	mov    %eax,%eax
  8009bf:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009c6:	00 
  8009c7:	48 b8 90 3e 80 00 00 	movabs $0x803e90,%rax
  8009ce:	00 00 00 
  8009d1:	48 01 d0             	add    %rdx,%rax
  8009d4:	48 8b 00             	mov    (%rax),%rax
  8009d7:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009d9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009dd:	eb c0                	jmp    80099f <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009df:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009e3:	eb ba                	jmp    80099f <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009ec:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009ef:	89 d0                	mov    %edx,%eax
  8009f1:	c1 e0 02             	shl    $0x2,%eax
  8009f4:	01 d0                	add    %edx,%eax
  8009f6:	01 c0                	add    %eax,%eax
  8009f8:	01 d8                	add    %ebx,%eax
  8009fa:	83 e8 30             	sub    $0x30,%eax
  8009fd:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a00:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a04:	0f b6 00             	movzbl (%rax),%eax
  800a07:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a0a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a0d:	7e 0c                	jle    800a1b <vprintfmt+0x2d3>
  800a0f:	83 fb 39             	cmp    $0x39,%ebx
  800a12:	7f 07                	jg     800a1b <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a14:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a19:	eb d1                	jmp    8009ec <vprintfmt+0x2a4>
			goto process_precision;
  800a1b:	eb 58                	jmp    800a75 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800a1d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a20:	83 f8 30             	cmp    $0x30,%eax
  800a23:	73 17                	jae    800a3c <vprintfmt+0x2f4>
  800a25:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a29:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2c:	89 c0                	mov    %eax,%eax
  800a2e:	48 01 d0             	add    %rdx,%rax
  800a31:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a34:	83 c2 08             	add    $0x8,%edx
  800a37:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a3a:	eb 0f                	jmp    800a4b <vprintfmt+0x303>
  800a3c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a40:	48 89 d0             	mov    %rdx,%rax
  800a43:	48 83 c2 08          	add    $0x8,%rdx
  800a47:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a4b:	8b 00                	mov    (%rax),%eax
  800a4d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a50:	eb 23                	jmp    800a75 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800a52:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a56:	79 0c                	jns    800a64 <vprintfmt+0x31c>
				width = 0;
  800a58:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a5f:	e9 3b ff ff ff       	jmpq   80099f <vprintfmt+0x257>
  800a64:	e9 36 ff ff ff       	jmpq   80099f <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800a69:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a70:	e9 2a ff ff ff       	jmpq   80099f <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800a75:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a79:	79 12                	jns    800a8d <vprintfmt+0x345>
				width = precision, precision = -1;
  800a7b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a7e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a81:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a88:	e9 12 ff ff ff       	jmpq   80099f <vprintfmt+0x257>
  800a8d:	e9 0d ff ff ff       	jmpq   80099f <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a92:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a96:	e9 04 ff ff ff       	jmpq   80099f <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9e:	83 f8 30             	cmp    $0x30,%eax
  800aa1:	73 17                	jae    800aba <vprintfmt+0x372>
  800aa3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aa7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aaa:	89 c0                	mov    %eax,%eax
  800aac:	48 01 d0             	add    %rdx,%rax
  800aaf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ab2:	83 c2 08             	add    $0x8,%edx
  800ab5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ab8:	eb 0f                	jmp    800ac9 <vprintfmt+0x381>
  800aba:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800abe:	48 89 d0             	mov    %rdx,%rax
  800ac1:	48 83 c2 08          	add    $0x8,%rdx
  800ac5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ac9:	8b 10                	mov    (%rax),%edx
  800acb:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800acf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad3:	48 89 ce             	mov    %rcx,%rsi
  800ad6:	89 d7                	mov    %edx,%edi
  800ad8:	ff d0                	callq  *%rax
			break;
  800ada:	e9 66 03 00 00       	jmpq   800e45 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800adf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae2:	83 f8 30             	cmp    $0x30,%eax
  800ae5:	73 17                	jae    800afe <vprintfmt+0x3b6>
  800ae7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aeb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aee:	89 c0                	mov    %eax,%eax
  800af0:	48 01 d0             	add    %rdx,%rax
  800af3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af6:	83 c2 08             	add    $0x8,%edx
  800af9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800afc:	eb 0f                	jmp    800b0d <vprintfmt+0x3c5>
  800afe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b02:	48 89 d0             	mov    %rdx,%rax
  800b05:	48 83 c2 08          	add    $0x8,%rdx
  800b09:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b0d:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b0f:	85 db                	test   %ebx,%ebx
  800b11:	79 02                	jns    800b15 <vprintfmt+0x3cd>
				err = -err;
  800b13:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b15:	83 fb 10             	cmp    $0x10,%ebx
  800b18:	7f 16                	jg     800b30 <vprintfmt+0x3e8>
  800b1a:	48 b8 e0 3d 80 00 00 	movabs $0x803de0,%rax
  800b21:	00 00 00 
  800b24:	48 63 d3             	movslq %ebx,%rdx
  800b27:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b2b:	4d 85 e4             	test   %r12,%r12
  800b2e:	75 2e                	jne    800b5e <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800b30:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b34:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b38:	89 d9                	mov    %ebx,%ecx
  800b3a:	48 ba 79 3e 80 00 00 	movabs $0x803e79,%rdx
  800b41:	00 00 00 
  800b44:	48 89 c7             	mov    %rax,%rdi
  800b47:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4c:	49 b8 53 0e 80 00 00 	movabs $0x800e53,%r8
  800b53:	00 00 00 
  800b56:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b59:	e9 e7 02 00 00       	jmpq   800e45 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b5e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b66:	4c 89 e1             	mov    %r12,%rcx
  800b69:	48 ba 82 3e 80 00 00 	movabs $0x803e82,%rdx
  800b70:	00 00 00 
  800b73:	48 89 c7             	mov    %rax,%rdi
  800b76:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7b:	49 b8 53 0e 80 00 00 	movabs $0x800e53,%r8
  800b82:	00 00 00 
  800b85:	41 ff d0             	callq  *%r8
			break;
  800b88:	e9 b8 02 00 00       	jmpq   800e45 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b8d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b90:	83 f8 30             	cmp    $0x30,%eax
  800b93:	73 17                	jae    800bac <vprintfmt+0x464>
  800b95:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b99:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b9c:	89 c0                	mov    %eax,%eax
  800b9e:	48 01 d0             	add    %rdx,%rax
  800ba1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ba4:	83 c2 08             	add    $0x8,%edx
  800ba7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800baa:	eb 0f                	jmp    800bbb <vprintfmt+0x473>
  800bac:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb0:	48 89 d0             	mov    %rdx,%rax
  800bb3:	48 83 c2 08          	add    $0x8,%rdx
  800bb7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bbb:	4c 8b 20             	mov    (%rax),%r12
  800bbe:	4d 85 e4             	test   %r12,%r12
  800bc1:	75 0a                	jne    800bcd <vprintfmt+0x485>
				p = "(null)";
  800bc3:	49 bc 85 3e 80 00 00 	movabs $0x803e85,%r12
  800bca:	00 00 00 
			if (width > 0 && padc != '-')
  800bcd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bd1:	7e 3f                	jle    800c12 <vprintfmt+0x4ca>
  800bd3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800bd7:	74 39                	je     800c12 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bd9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bdc:	48 98                	cltq   
  800bde:	48 89 c6             	mov    %rax,%rsi
  800be1:	4c 89 e7             	mov    %r12,%rdi
  800be4:	48 b8 ff 10 80 00 00 	movabs $0x8010ff,%rax
  800beb:	00 00 00 
  800bee:	ff d0                	callq  *%rax
  800bf0:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bf3:	eb 17                	jmp    800c0c <vprintfmt+0x4c4>
					putch(padc, putdat);
  800bf5:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800bf9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bfd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c01:	48 89 ce             	mov    %rcx,%rsi
  800c04:	89 d7                	mov    %edx,%edi
  800c06:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c08:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c10:	7f e3                	jg     800bf5 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c12:	eb 37                	jmp    800c4b <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800c14:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c18:	74 1e                	je     800c38 <vprintfmt+0x4f0>
  800c1a:	83 fb 1f             	cmp    $0x1f,%ebx
  800c1d:	7e 05                	jle    800c24 <vprintfmt+0x4dc>
  800c1f:	83 fb 7e             	cmp    $0x7e,%ebx
  800c22:	7e 14                	jle    800c38 <vprintfmt+0x4f0>
					putch('?', putdat);
  800c24:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2c:	48 89 d6             	mov    %rdx,%rsi
  800c2f:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c34:	ff d0                	callq  *%rax
  800c36:	eb 0f                	jmp    800c47 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800c38:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c40:	48 89 d6             	mov    %rdx,%rsi
  800c43:	89 df                	mov    %ebx,%edi
  800c45:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c47:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c4b:	4c 89 e0             	mov    %r12,%rax
  800c4e:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c52:	0f b6 00             	movzbl (%rax),%eax
  800c55:	0f be d8             	movsbl %al,%ebx
  800c58:	85 db                	test   %ebx,%ebx
  800c5a:	74 10                	je     800c6c <vprintfmt+0x524>
  800c5c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c60:	78 b2                	js     800c14 <vprintfmt+0x4cc>
  800c62:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c66:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c6a:	79 a8                	jns    800c14 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c6c:	eb 16                	jmp    800c84 <vprintfmt+0x53c>
				putch(' ', putdat);
  800c6e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c72:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c76:	48 89 d6             	mov    %rdx,%rsi
  800c79:	bf 20 00 00 00       	mov    $0x20,%edi
  800c7e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c80:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c84:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c88:	7f e4                	jg     800c6e <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800c8a:	e9 b6 01 00 00       	jmpq   800e45 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c8f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c93:	be 03 00 00 00       	mov    $0x3,%esi
  800c98:	48 89 c7             	mov    %rax,%rdi
  800c9b:	48 b8 38 06 80 00 00 	movabs $0x800638,%rax
  800ca2:	00 00 00 
  800ca5:	ff d0                	callq  *%rax
  800ca7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800cab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800caf:	48 85 c0             	test   %rax,%rax
  800cb2:	79 1d                	jns    800cd1 <vprintfmt+0x589>
				putch('-', putdat);
  800cb4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cb8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cbc:	48 89 d6             	mov    %rdx,%rsi
  800cbf:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800cc4:	ff d0                	callq  *%rax
				num = -(long long) num;
  800cc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cca:	48 f7 d8             	neg    %rax
  800ccd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800cd1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cd8:	e9 fb 00 00 00       	jmpq   800dd8 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800cdd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ce1:	be 03 00 00 00       	mov    $0x3,%esi
  800ce6:	48 89 c7             	mov    %rax,%rdi
  800ce9:	48 b8 28 05 80 00 00 	movabs $0x800528,%rax
  800cf0:	00 00 00 
  800cf3:	ff d0                	callq  *%rax
  800cf5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cf9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d00:	e9 d3 00 00 00       	jmpq   800dd8 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800d05:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d09:	be 03 00 00 00       	mov    $0x3,%esi
  800d0e:	48 89 c7             	mov    %rax,%rdi
  800d11:	48 b8 38 06 80 00 00 	movabs $0x800638,%rax
  800d18:	00 00 00 
  800d1b:	ff d0                	callq  *%rax
  800d1d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d25:	48 85 c0             	test   %rax,%rax
  800d28:	79 1d                	jns    800d47 <vprintfmt+0x5ff>
				putch('-', putdat);
  800d2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d32:	48 89 d6             	mov    %rdx,%rsi
  800d35:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d3a:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d40:	48 f7 d8             	neg    %rax
  800d43:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  800d47:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d4e:	e9 85 00 00 00       	jmpq   800dd8 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  800d53:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5b:	48 89 d6             	mov    %rdx,%rsi
  800d5e:	bf 30 00 00 00       	mov    $0x30,%edi
  800d63:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d65:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d69:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d6d:	48 89 d6             	mov    %rdx,%rsi
  800d70:	bf 78 00 00 00       	mov    $0x78,%edi
  800d75:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d77:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d7a:	83 f8 30             	cmp    $0x30,%eax
  800d7d:	73 17                	jae    800d96 <vprintfmt+0x64e>
  800d7f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d83:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d86:	89 c0                	mov    %eax,%eax
  800d88:	48 01 d0             	add    %rdx,%rax
  800d8b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d8e:	83 c2 08             	add    $0x8,%edx
  800d91:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d94:	eb 0f                	jmp    800da5 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  800d96:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d9a:	48 89 d0             	mov    %rdx,%rax
  800d9d:	48 83 c2 08          	add    $0x8,%rdx
  800da1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800da5:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800da8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800dac:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800db3:	eb 23                	jmp    800dd8 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800db5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800db9:	be 03 00 00 00       	mov    $0x3,%esi
  800dbe:	48 89 c7             	mov    %rax,%rdi
  800dc1:	48 b8 28 05 80 00 00 	movabs $0x800528,%rax
  800dc8:	00 00 00 
  800dcb:	ff d0                	callq  *%rax
  800dcd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800dd1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800dd8:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ddd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800de0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800de3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800de7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800deb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800def:	45 89 c1             	mov    %r8d,%r9d
  800df2:	41 89 f8             	mov    %edi,%r8d
  800df5:	48 89 c7             	mov    %rax,%rdi
  800df8:	48 b8 6d 04 80 00 00 	movabs $0x80046d,%rax
  800dff:	00 00 00 
  800e02:	ff d0                	callq  *%rax
			break;
  800e04:	eb 3f                	jmp    800e45 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e06:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0e:	48 89 d6             	mov    %rdx,%rsi
  800e11:	89 df                	mov    %ebx,%edi
  800e13:	ff d0                	callq  *%rax
			break;
  800e15:	eb 2e                	jmp    800e45 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e17:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1f:	48 89 d6             	mov    %rdx,%rsi
  800e22:	bf 25 00 00 00       	mov    $0x25,%edi
  800e27:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e29:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e2e:	eb 05                	jmp    800e35 <vprintfmt+0x6ed>
  800e30:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e35:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e39:	48 83 e8 01          	sub    $0x1,%rax
  800e3d:	0f b6 00             	movzbl (%rax),%eax
  800e40:	3c 25                	cmp    $0x25,%al
  800e42:	75 ec                	jne    800e30 <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  800e44:	90                   	nop
		}
	}
  800e45:	e9 37 f9 ff ff       	jmpq   800781 <vprintfmt+0x39>
    va_end(aq);
}
  800e4a:	48 83 c4 60          	add    $0x60,%rsp
  800e4e:	5b                   	pop    %rbx
  800e4f:	41 5c                	pop    %r12
  800e51:	5d                   	pop    %rbp
  800e52:	c3                   	retq   

0000000000800e53 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e53:	55                   	push   %rbp
  800e54:	48 89 e5             	mov    %rsp,%rbp
  800e57:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e5e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e65:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e6c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e73:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e7a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e81:	84 c0                	test   %al,%al
  800e83:	74 20                	je     800ea5 <printfmt+0x52>
  800e85:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e89:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e8d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e91:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e95:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e99:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e9d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ea1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ea5:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800eac:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800eb3:	00 00 00 
  800eb6:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ebd:	00 00 00 
  800ec0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ec4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ecb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ed2:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ed9:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ee0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ee7:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800eee:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ef5:	48 89 c7             	mov    %rax,%rdi
  800ef8:	48 b8 48 07 80 00 00 	movabs $0x800748,%rax
  800eff:	00 00 00 
  800f02:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f04:	c9                   	leaveq 
  800f05:	c3                   	retq   

0000000000800f06 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f06:	55                   	push   %rbp
  800f07:	48 89 e5             	mov    %rsp,%rbp
  800f0a:	48 83 ec 10          	sub    $0x10,%rsp
  800f0e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f19:	8b 40 10             	mov    0x10(%rax),%eax
  800f1c:	8d 50 01             	lea    0x1(%rax),%edx
  800f1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f23:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f2a:	48 8b 10             	mov    (%rax),%rdx
  800f2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f31:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f35:	48 39 c2             	cmp    %rax,%rdx
  800f38:	73 17                	jae    800f51 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f3e:	48 8b 00             	mov    (%rax),%rax
  800f41:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f49:	48 89 0a             	mov    %rcx,(%rdx)
  800f4c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f4f:	88 10                	mov    %dl,(%rax)
}
  800f51:	c9                   	leaveq 
  800f52:	c3                   	retq   

0000000000800f53 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f53:	55                   	push   %rbp
  800f54:	48 89 e5             	mov    %rsp,%rbp
  800f57:	48 83 ec 50          	sub    $0x50,%rsp
  800f5b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f5f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f62:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f66:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f6a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f6e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f72:	48 8b 0a             	mov    (%rdx),%rcx
  800f75:	48 89 08             	mov    %rcx,(%rax)
  800f78:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f7c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f80:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f84:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f88:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f8c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f90:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f93:	48 98                	cltq   
  800f95:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f99:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f9d:	48 01 d0             	add    %rdx,%rax
  800fa0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fa4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fab:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800fb0:	74 06                	je     800fb8 <vsnprintf+0x65>
  800fb2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800fb6:	7f 07                	jg     800fbf <vsnprintf+0x6c>
		return -E_INVAL;
  800fb8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fbd:	eb 2f                	jmp    800fee <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800fbf:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800fc3:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800fc7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800fcb:	48 89 c6             	mov    %rax,%rsi
  800fce:	48 bf 06 0f 80 00 00 	movabs $0x800f06,%rdi
  800fd5:	00 00 00 
  800fd8:	48 b8 48 07 80 00 00 	movabs $0x800748,%rax
  800fdf:	00 00 00 
  800fe2:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800fe4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fe8:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800feb:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800fee:	c9                   	leaveq 
  800fef:	c3                   	retq   

0000000000800ff0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ff0:	55                   	push   %rbp
  800ff1:	48 89 e5             	mov    %rsp,%rbp
  800ff4:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ffb:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801002:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801008:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80100f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801016:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80101d:	84 c0                	test   %al,%al
  80101f:	74 20                	je     801041 <snprintf+0x51>
  801021:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801025:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801029:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80102d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801031:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801035:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801039:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80103d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801041:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801048:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80104f:	00 00 00 
  801052:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801059:	00 00 00 
  80105c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801060:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801067:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80106e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801075:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80107c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801083:	48 8b 0a             	mov    (%rdx),%rcx
  801086:	48 89 08             	mov    %rcx,(%rax)
  801089:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80108d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801091:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801095:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801099:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010a0:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010a7:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010ad:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010b4:	48 89 c7             	mov    %rax,%rdi
  8010b7:	48 b8 53 0f 80 00 00 	movabs $0x800f53,%rax
  8010be:	00 00 00 
  8010c1:	ff d0                	callq  *%rax
  8010c3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8010c9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8010cf:	c9                   	leaveq 
  8010d0:	c3                   	retq   

00000000008010d1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010d1:	55                   	push   %rbp
  8010d2:	48 89 e5             	mov    %rsp,%rbp
  8010d5:	48 83 ec 18          	sub    $0x18,%rsp
  8010d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010e4:	eb 09                	jmp    8010ef <strlen+0x1e>
		n++;
  8010e6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010ea:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f3:	0f b6 00             	movzbl (%rax),%eax
  8010f6:	84 c0                	test   %al,%al
  8010f8:	75 ec                	jne    8010e6 <strlen+0x15>
		n++;
	return n;
  8010fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010fd:	c9                   	leaveq 
  8010fe:	c3                   	retq   

00000000008010ff <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010ff:	55                   	push   %rbp
  801100:	48 89 e5             	mov    %rsp,%rbp
  801103:	48 83 ec 20          	sub    $0x20,%rsp
  801107:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80110b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80110f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801116:	eb 0e                	jmp    801126 <strnlen+0x27>
		n++;
  801118:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80111c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801121:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801126:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80112b:	74 0b                	je     801138 <strnlen+0x39>
  80112d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801131:	0f b6 00             	movzbl (%rax),%eax
  801134:	84 c0                	test   %al,%al
  801136:	75 e0                	jne    801118 <strnlen+0x19>
		n++;
	return n;
  801138:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80113b:	c9                   	leaveq 
  80113c:	c3                   	retq   

000000000080113d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80113d:	55                   	push   %rbp
  80113e:	48 89 e5             	mov    %rsp,%rbp
  801141:	48 83 ec 20          	sub    $0x20,%rsp
  801145:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801149:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80114d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801151:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801155:	90                   	nop
  801156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80115e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801162:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801166:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80116a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80116e:	0f b6 12             	movzbl (%rdx),%edx
  801171:	88 10                	mov    %dl,(%rax)
  801173:	0f b6 00             	movzbl (%rax),%eax
  801176:	84 c0                	test   %al,%al
  801178:	75 dc                	jne    801156 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80117a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80117e:	c9                   	leaveq 
  80117f:	c3                   	retq   

0000000000801180 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801180:	55                   	push   %rbp
  801181:	48 89 e5             	mov    %rsp,%rbp
  801184:	48 83 ec 20          	sub    $0x20,%rsp
  801188:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80118c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801190:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801194:	48 89 c7             	mov    %rax,%rdi
  801197:	48 b8 d1 10 80 00 00 	movabs $0x8010d1,%rax
  80119e:	00 00 00 
  8011a1:	ff d0                	callq  *%rax
  8011a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011a9:	48 63 d0             	movslq %eax,%rdx
  8011ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b0:	48 01 c2             	add    %rax,%rdx
  8011b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011b7:	48 89 c6             	mov    %rax,%rsi
  8011ba:	48 89 d7             	mov    %rdx,%rdi
  8011bd:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  8011c4:	00 00 00 
  8011c7:	ff d0                	callq  *%rax
	return dst;
  8011c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8011cd:	c9                   	leaveq 
  8011ce:	c3                   	retq   

00000000008011cf <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011cf:	55                   	push   %rbp
  8011d0:	48 89 e5             	mov    %rsp,%rbp
  8011d3:	48 83 ec 28          	sub    $0x28,%rsp
  8011d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011eb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011f2:	00 
  8011f3:	eb 2a                	jmp    80121f <strncpy+0x50>
		*dst++ = *src;
  8011f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011fd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801201:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801205:	0f b6 12             	movzbl (%rdx),%edx
  801208:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80120a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80120e:	0f b6 00             	movzbl (%rax),%eax
  801211:	84 c0                	test   %al,%al
  801213:	74 05                	je     80121a <strncpy+0x4b>
			src++;
  801215:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80121a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80121f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801223:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801227:	72 cc                	jb     8011f5 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80122d:	c9                   	leaveq 
  80122e:	c3                   	retq   

000000000080122f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80122f:	55                   	push   %rbp
  801230:	48 89 e5             	mov    %rsp,%rbp
  801233:	48 83 ec 28          	sub    $0x28,%rsp
  801237:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80123b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80123f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801243:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801247:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80124b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801250:	74 3d                	je     80128f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801252:	eb 1d                	jmp    801271 <strlcpy+0x42>
			*dst++ = *src++;
  801254:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801258:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80125c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801260:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801264:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801268:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80126c:	0f b6 12             	movzbl (%rdx),%edx
  80126f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801271:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801276:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80127b:	74 0b                	je     801288 <strlcpy+0x59>
  80127d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801281:	0f b6 00             	movzbl (%rax),%eax
  801284:	84 c0                	test   %al,%al
  801286:	75 cc                	jne    801254 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801288:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80128f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801293:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801297:	48 29 c2             	sub    %rax,%rdx
  80129a:	48 89 d0             	mov    %rdx,%rax
}
  80129d:	c9                   	leaveq 
  80129e:	c3                   	retq   

000000000080129f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80129f:	55                   	push   %rbp
  8012a0:	48 89 e5             	mov    %rsp,%rbp
  8012a3:	48 83 ec 10          	sub    $0x10,%rsp
  8012a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012af:	eb 0a                	jmp    8012bb <strcmp+0x1c>
		p++, q++;
  8012b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bf:	0f b6 00             	movzbl (%rax),%eax
  8012c2:	84 c0                	test   %al,%al
  8012c4:	74 12                	je     8012d8 <strcmp+0x39>
  8012c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ca:	0f b6 10             	movzbl (%rax),%edx
  8012cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d1:	0f b6 00             	movzbl (%rax),%eax
  8012d4:	38 c2                	cmp    %al,%dl
  8012d6:	74 d9                	je     8012b1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012dc:	0f b6 00             	movzbl (%rax),%eax
  8012df:	0f b6 d0             	movzbl %al,%edx
  8012e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e6:	0f b6 00             	movzbl (%rax),%eax
  8012e9:	0f b6 c0             	movzbl %al,%eax
  8012ec:	29 c2                	sub    %eax,%edx
  8012ee:	89 d0                	mov    %edx,%eax
}
  8012f0:	c9                   	leaveq 
  8012f1:	c3                   	retq   

00000000008012f2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012f2:	55                   	push   %rbp
  8012f3:	48 89 e5             	mov    %rsp,%rbp
  8012f6:	48 83 ec 18          	sub    $0x18,%rsp
  8012fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801302:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801306:	eb 0f                	jmp    801317 <strncmp+0x25>
		n--, p++, q++;
  801308:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80130d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801312:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801317:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80131c:	74 1d                	je     80133b <strncmp+0x49>
  80131e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801322:	0f b6 00             	movzbl (%rax),%eax
  801325:	84 c0                	test   %al,%al
  801327:	74 12                	je     80133b <strncmp+0x49>
  801329:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132d:	0f b6 10             	movzbl (%rax),%edx
  801330:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801334:	0f b6 00             	movzbl (%rax),%eax
  801337:	38 c2                	cmp    %al,%dl
  801339:	74 cd                	je     801308 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80133b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801340:	75 07                	jne    801349 <strncmp+0x57>
		return 0;
  801342:	b8 00 00 00 00       	mov    $0x0,%eax
  801347:	eb 18                	jmp    801361 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801349:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134d:	0f b6 00             	movzbl (%rax),%eax
  801350:	0f b6 d0             	movzbl %al,%edx
  801353:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801357:	0f b6 00             	movzbl (%rax),%eax
  80135a:	0f b6 c0             	movzbl %al,%eax
  80135d:	29 c2                	sub    %eax,%edx
  80135f:	89 d0                	mov    %edx,%eax
}
  801361:	c9                   	leaveq 
  801362:	c3                   	retq   

0000000000801363 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801363:	55                   	push   %rbp
  801364:	48 89 e5             	mov    %rsp,%rbp
  801367:	48 83 ec 0c          	sub    $0xc,%rsp
  80136b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80136f:	89 f0                	mov    %esi,%eax
  801371:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801374:	eb 17                	jmp    80138d <strchr+0x2a>
		if (*s == c)
  801376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137a:	0f b6 00             	movzbl (%rax),%eax
  80137d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801380:	75 06                	jne    801388 <strchr+0x25>
			return (char *) s;
  801382:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801386:	eb 15                	jmp    80139d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801388:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80138d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801391:	0f b6 00             	movzbl (%rax),%eax
  801394:	84 c0                	test   %al,%al
  801396:	75 de                	jne    801376 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801398:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80139d:	c9                   	leaveq 
  80139e:	c3                   	retq   

000000000080139f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80139f:	55                   	push   %rbp
  8013a0:	48 89 e5             	mov    %rsp,%rbp
  8013a3:	48 83 ec 0c          	sub    $0xc,%rsp
  8013a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ab:	89 f0                	mov    %esi,%eax
  8013ad:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013b0:	eb 13                	jmp    8013c5 <strfind+0x26>
		if (*s == c)
  8013b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b6:	0f b6 00             	movzbl (%rax),%eax
  8013b9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013bc:	75 02                	jne    8013c0 <strfind+0x21>
			break;
  8013be:	eb 10                	jmp    8013d0 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c9:	0f b6 00             	movzbl (%rax),%eax
  8013cc:	84 c0                	test   %al,%al
  8013ce:	75 e2                	jne    8013b2 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8013d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013d4:	c9                   	leaveq 
  8013d5:	c3                   	retq   

00000000008013d6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013d6:	55                   	push   %rbp
  8013d7:	48 89 e5             	mov    %rsp,%rbp
  8013da:	48 83 ec 18          	sub    $0x18,%rsp
  8013de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013e2:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013e5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013e9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ee:	75 06                	jne    8013f6 <memset+0x20>
		return v;
  8013f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f4:	eb 69                	jmp    80145f <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fa:	83 e0 03             	and    $0x3,%eax
  8013fd:	48 85 c0             	test   %rax,%rax
  801400:	75 48                	jne    80144a <memset+0x74>
  801402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801406:	83 e0 03             	and    $0x3,%eax
  801409:	48 85 c0             	test   %rax,%rax
  80140c:	75 3c                	jne    80144a <memset+0x74>
		c &= 0xFF;
  80140e:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801415:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801418:	c1 e0 18             	shl    $0x18,%eax
  80141b:	89 c2                	mov    %eax,%edx
  80141d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801420:	c1 e0 10             	shl    $0x10,%eax
  801423:	09 c2                	or     %eax,%edx
  801425:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801428:	c1 e0 08             	shl    $0x8,%eax
  80142b:	09 d0                	or     %edx,%eax
  80142d:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801430:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801434:	48 c1 e8 02          	shr    $0x2,%rax
  801438:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80143b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80143f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801442:	48 89 d7             	mov    %rdx,%rdi
  801445:	fc                   	cld    
  801446:	f3 ab                	rep stos %eax,%es:(%rdi)
  801448:	eb 11                	jmp    80145b <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80144a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80144e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801451:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801455:	48 89 d7             	mov    %rdx,%rdi
  801458:	fc                   	cld    
  801459:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80145b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80145f:	c9                   	leaveq 
  801460:	c3                   	retq   

0000000000801461 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801461:	55                   	push   %rbp
  801462:	48 89 e5             	mov    %rsp,%rbp
  801465:	48 83 ec 28          	sub    $0x28,%rsp
  801469:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80146d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801471:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801475:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801479:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80147d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801481:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801485:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801489:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80148d:	0f 83 88 00 00 00    	jae    80151b <memmove+0xba>
  801493:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801497:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80149b:	48 01 d0             	add    %rdx,%rax
  80149e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014a2:	76 77                	jbe    80151b <memmove+0xba>
		s += n;
  8014a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a8:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b0:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b8:	83 e0 03             	and    $0x3,%eax
  8014bb:	48 85 c0             	test   %rax,%rax
  8014be:	75 3b                	jne    8014fb <memmove+0x9a>
  8014c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c4:	83 e0 03             	and    $0x3,%eax
  8014c7:	48 85 c0             	test   %rax,%rax
  8014ca:	75 2f                	jne    8014fb <memmove+0x9a>
  8014cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d0:	83 e0 03             	and    $0x3,%eax
  8014d3:	48 85 c0             	test   %rax,%rax
  8014d6:	75 23                	jne    8014fb <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014dc:	48 83 e8 04          	sub    $0x4,%rax
  8014e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014e4:	48 83 ea 04          	sub    $0x4,%rdx
  8014e8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014ec:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014f0:	48 89 c7             	mov    %rax,%rdi
  8014f3:	48 89 d6             	mov    %rdx,%rsi
  8014f6:	fd                   	std    
  8014f7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014f9:	eb 1d                	jmp    801518 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ff:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801503:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801507:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80150b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150f:	48 89 d7             	mov    %rdx,%rdi
  801512:	48 89 c1             	mov    %rax,%rcx
  801515:	fd                   	std    
  801516:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801518:	fc                   	cld    
  801519:	eb 57                	jmp    801572 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80151b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151f:	83 e0 03             	and    $0x3,%eax
  801522:	48 85 c0             	test   %rax,%rax
  801525:	75 36                	jne    80155d <memmove+0xfc>
  801527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152b:	83 e0 03             	and    $0x3,%eax
  80152e:	48 85 c0             	test   %rax,%rax
  801531:	75 2a                	jne    80155d <memmove+0xfc>
  801533:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801537:	83 e0 03             	and    $0x3,%eax
  80153a:	48 85 c0             	test   %rax,%rax
  80153d:	75 1e                	jne    80155d <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80153f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801543:	48 c1 e8 02          	shr    $0x2,%rax
  801547:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80154a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801552:	48 89 c7             	mov    %rax,%rdi
  801555:	48 89 d6             	mov    %rdx,%rsi
  801558:	fc                   	cld    
  801559:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80155b:	eb 15                	jmp    801572 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80155d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801561:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801565:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801569:	48 89 c7             	mov    %rax,%rdi
  80156c:	48 89 d6             	mov    %rdx,%rsi
  80156f:	fc                   	cld    
  801570:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801572:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801576:	c9                   	leaveq 
  801577:	c3                   	retq   

0000000000801578 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801578:	55                   	push   %rbp
  801579:	48 89 e5             	mov    %rsp,%rbp
  80157c:	48 83 ec 18          	sub    $0x18,%rsp
  801580:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801584:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801588:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80158c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801590:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801598:	48 89 ce             	mov    %rcx,%rsi
  80159b:	48 89 c7             	mov    %rax,%rdi
  80159e:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  8015a5:	00 00 00 
  8015a8:	ff d0                	callq  *%rax
}
  8015aa:	c9                   	leaveq 
  8015ab:	c3                   	retq   

00000000008015ac <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015ac:	55                   	push   %rbp
  8015ad:	48 89 e5             	mov    %rsp,%rbp
  8015b0:	48 83 ec 28          	sub    $0x28,%rsp
  8015b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015bc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8015d0:	eb 36                	jmp    801608 <memcmp+0x5c>
		if (*s1 != *s2)
  8015d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d6:	0f b6 10             	movzbl (%rax),%edx
  8015d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015dd:	0f b6 00             	movzbl (%rax),%eax
  8015e0:	38 c2                	cmp    %al,%dl
  8015e2:	74 1a                	je     8015fe <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8015e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e8:	0f b6 00             	movzbl (%rax),%eax
  8015eb:	0f b6 d0             	movzbl %al,%edx
  8015ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f2:	0f b6 00             	movzbl (%rax),%eax
  8015f5:	0f b6 c0             	movzbl %al,%eax
  8015f8:	29 c2                	sub    %eax,%edx
  8015fa:	89 d0                	mov    %edx,%eax
  8015fc:	eb 20                	jmp    80161e <memcmp+0x72>
		s1++, s2++;
  8015fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801603:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801608:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801610:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801614:	48 85 c0             	test   %rax,%rax
  801617:	75 b9                	jne    8015d2 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801619:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161e:	c9                   	leaveq 
  80161f:	c3                   	retq   

0000000000801620 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801620:	55                   	push   %rbp
  801621:	48 89 e5             	mov    %rsp,%rbp
  801624:	48 83 ec 28          	sub    $0x28,%rsp
  801628:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80162c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80162f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801633:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801637:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80163b:	48 01 d0             	add    %rdx,%rax
  80163e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801642:	eb 15                	jmp    801659 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801648:	0f b6 10             	movzbl (%rax),%edx
  80164b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80164e:	38 c2                	cmp    %al,%dl
  801650:	75 02                	jne    801654 <memfind+0x34>
			break;
  801652:	eb 0f                	jmp    801663 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801654:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801659:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80165d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801661:	72 e1                	jb     801644 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801663:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801667:	c9                   	leaveq 
  801668:	c3                   	retq   

0000000000801669 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801669:	55                   	push   %rbp
  80166a:	48 89 e5             	mov    %rsp,%rbp
  80166d:	48 83 ec 34          	sub    $0x34,%rsp
  801671:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801675:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801679:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80167c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801683:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80168a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80168b:	eb 05                	jmp    801692 <strtol+0x29>
		s++;
  80168d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801692:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801696:	0f b6 00             	movzbl (%rax),%eax
  801699:	3c 20                	cmp    $0x20,%al
  80169b:	74 f0                	je     80168d <strtol+0x24>
  80169d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a1:	0f b6 00             	movzbl (%rax),%eax
  8016a4:	3c 09                	cmp    $0x9,%al
  8016a6:	74 e5                	je     80168d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ac:	0f b6 00             	movzbl (%rax),%eax
  8016af:	3c 2b                	cmp    $0x2b,%al
  8016b1:	75 07                	jne    8016ba <strtol+0x51>
		s++;
  8016b3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016b8:	eb 17                	jmp    8016d1 <strtol+0x68>
	else if (*s == '-')
  8016ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016be:	0f b6 00             	movzbl (%rax),%eax
  8016c1:	3c 2d                	cmp    $0x2d,%al
  8016c3:	75 0c                	jne    8016d1 <strtol+0x68>
		s++, neg = 1;
  8016c5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016d1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016d5:	74 06                	je     8016dd <strtol+0x74>
  8016d7:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8016db:	75 28                	jne    801705 <strtol+0x9c>
  8016dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e1:	0f b6 00             	movzbl (%rax),%eax
  8016e4:	3c 30                	cmp    $0x30,%al
  8016e6:	75 1d                	jne    801705 <strtol+0x9c>
  8016e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ec:	48 83 c0 01          	add    $0x1,%rax
  8016f0:	0f b6 00             	movzbl (%rax),%eax
  8016f3:	3c 78                	cmp    $0x78,%al
  8016f5:	75 0e                	jne    801705 <strtol+0x9c>
		s += 2, base = 16;
  8016f7:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016fc:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801703:	eb 2c                	jmp    801731 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801705:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801709:	75 19                	jne    801724 <strtol+0xbb>
  80170b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170f:	0f b6 00             	movzbl (%rax),%eax
  801712:	3c 30                	cmp    $0x30,%al
  801714:	75 0e                	jne    801724 <strtol+0xbb>
		s++, base = 8;
  801716:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80171b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801722:	eb 0d                	jmp    801731 <strtol+0xc8>
	else if (base == 0)
  801724:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801728:	75 07                	jne    801731 <strtol+0xc8>
		base = 10;
  80172a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801731:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801735:	0f b6 00             	movzbl (%rax),%eax
  801738:	3c 2f                	cmp    $0x2f,%al
  80173a:	7e 1d                	jle    801759 <strtol+0xf0>
  80173c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801740:	0f b6 00             	movzbl (%rax),%eax
  801743:	3c 39                	cmp    $0x39,%al
  801745:	7f 12                	jg     801759 <strtol+0xf0>
			dig = *s - '0';
  801747:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174b:	0f b6 00             	movzbl (%rax),%eax
  80174e:	0f be c0             	movsbl %al,%eax
  801751:	83 e8 30             	sub    $0x30,%eax
  801754:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801757:	eb 4e                	jmp    8017a7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801759:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175d:	0f b6 00             	movzbl (%rax),%eax
  801760:	3c 60                	cmp    $0x60,%al
  801762:	7e 1d                	jle    801781 <strtol+0x118>
  801764:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801768:	0f b6 00             	movzbl (%rax),%eax
  80176b:	3c 7a                	cmp    $0x7a,%al
  80176d:	7f 12                	jg     801781 <strtol+0x118>
			dig = *s - 'a' + 10;
  80176f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801773:	0f b6 00             	movzbl (%rax),%eax
  801776:	0f be c0             	movsbl %al,%eax
  801779:	83 e8 57             	sub    $0x57,%eax
  80177c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80177f:	eb 26                	jmp    8017a7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801781:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801785:	0f b6 00             	movzbl (%rax),%eax
  801788:	3c 40                	cmp    $0x40,%al
  80178a:	7e 48                	jle    8017d4 <strtol+0x16b>
  80178c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801790:	0f b6 00             	movzbl (%rax),%eax
  801793:	3c 5a                	cmp    $0x5a,%al
  801795:	7f 3d                	jg     8017d4 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801797:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179b:	0f b6 00             	movzbl (%rax),%eax
  80179e:	0f be c0             	movsbl %al,%eax
  8017a1:	83 e8 37             	sub    $0x37,%eax
  8017a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017aa:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017ad:	7c 02                	jl     8017b1 <strtol+0x148>
			break;
  8017af:	eb 23                	jmp    8017d4 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8017b1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017b6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017b9:	48 98                	cltq   
  8017bb:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017c0:	48 89 c2             	mov    %rax,%rdx
  8017c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017c6:	48 98                	cltq   
  8017c8:	48 01 d0             	add    %rdx,%rax
  8017cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8017cf:	e9 5d ff ff ff       	jmpq   801731 <strtol+0xc8>

	if (endptr)
  8017d4:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8017d9:	74 0b                	je     8017e6 <strtol+0x17d>
		*endptr = (char *) s;
  8017db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017df:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017e3:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017ea:	74 09                	je     8017f5 <strtol+0x18c>
  8017ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017f0:	48 f7 d8             	neg    %rax
  8017f3:	eb 04                	jmp    8017f9 <strtol+0x190>
  8017f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017f9:	c9                   	leaveq 
  8017fa:	c3                   	retq   

00000000008017fb <strstr>:

char * strstr(const char *in, const char *str)
{
  8017fb:	55                   	push   %rbp
  8017fc:	48 89 e5             	mov    %rsp,%rbp
  8017ff:	48 83 ec 30          	sub    $0x30,%rsp
  801803:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801807:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80180b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80180f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801813:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801817:	0f b6 00             	movzbl (%rax),%eax
  80181a:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  80181d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801821:	75 06                	jne    801829 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801823:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801827:	eb 6b                	jmp    801894 <strstr+0x99>

    len = strlen(str);
  801829:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80182d:	48 89 c7             	mov    %rax,%rdi
  801830:	48 b8 d1 10 80 00 00 	movabs $0x8010d1,%rax
  801837:	00 00 00 
  80183a:	ff d0                	callq  *%rax
  80183c:	48 98                	cltq   
  80183e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801842:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801846:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80184a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80184e:	0f b6 00             	movzbl (%rax),%eax
  801851:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801854:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801858:	75 07                	jne    801861 <strstr+0x66>
                return (char *) 0;
  80185a:	b8 00 00 00 00       	mov    $0x0,%eax
  80185f:	eb 33                	jmp    801894 <strstr+0x99>
        } while (sc != c);
  801861:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801865:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801868:	75 d8                	jne    801842 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  80186a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80186e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801872:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801876:	48 89 ce             	mov    %rcx,%rsi
  801879:	48 89 c7             	mov    %rax,%rdi
  80187c:	48 b8 f2 12 80 00 00 	movabs $0x8012f2,%rax
  801883:	00 00 00 
  801886:	ff d0                	callq  *%rax
  801888:	85 c0                	test   %eax,%eax
  80188a:	75 b6                	jne    801842 <strstr+0x47>

    return (char *) (in - 1);
  80188c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801890:	48 83 e8 01          	sub    $0x1,%rax
}
  801894:	c9                   	leaveq 
  801895:	c3                   	retq   

0000000000801896 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801896:	55                   	push   %rbp
  801897:	48 89 e5             	mov    %rsp,%rbp
  80189a:	53                   	push   %rbx
  80189b:	48 83 ec 48          	sub    $0x48,%rsp
  80189f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018a2:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018a5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018a9:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018ad:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018b1:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018b5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018b8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018bc:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018c0:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018c4:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018c8:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8018cc:	4c 89 c3             	mov    %r8,%rbx
  8018cf:	cd 30                	int    $0x30
  8018d1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  8018d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8018d9:	74 3e                	je     801919 <syscall+0x83>
  8018db:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018e0:	7e 37                	jle    801919 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018e6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018e9:	49 89 d0             	mov    %rdx,%r8
  8018ec:	89 c1                	mov    %eax,%ecx
  8018ee:	48 ba 40 41 80 00 00 	movabs $0x804140,%rdx
  8018f5:	00 00 00 
  8018f8:	be 23 00 00 00       	mov    $0x23,%esi
  8018fd:	48 bf 5d 41 80 00 00 	movabs $0x80415d,%rdi
  801904:	00 00 00 
  801907:	b8 00 00 00 00       	mov    $0x0,%eax
  80190c:	49 b9 be 38 80 00 00 	movabs $0x8038be,%r9
  801913:	00 00 00 
  801916:	41 ff d1             	callq  *%r9

	return ret;
  801919:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80191d:	48 83 c4 48          	add    $0x48,%rsp
  801921:	5b                   	pop    %rbx
  801922:	5d                   	pop    %rbp
  801923:	c3                   	retq   

0000000000801924 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801924:	55                   	push   %rbp
  801925:	48 89 e5             	mov    %rsp,%rbp
  801928:	48 83 ec 20          	sub    $0x20,%rsp
  80192c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801930:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801934:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801938:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80193c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801943:	00 
  801944:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80194a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801950:	48 89 d1             	mov    %rdx,%rcx
  801953:	48 89 c2             	mov    %rax,%rdx
  801956:	be 00 00 00 00       	mov    $0x0,%esi
  80195b:	bf 00 00 00 00       	mov    $0x0,%edi
  801960:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  801967:	00 00 00 
  80196a:	ff d0                	callq  *%rax
}
  80196c:	c9                   	leaveq 
  80196d:	c3                   	retq   

000000000080196e <sys_cgetc>:

int
sys_cgetc(void)
{
  80196e:	55                   	push   %rbp
  80196f:	48 89 e5             	mov    %rsp,%rbp
  801972:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801976:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197d:	00 
  80197e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801984:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80198f:	ba 00 00 00 00       	mov    $0x0,%edx
  801994:	be 00 00 00 00       	mov    $0x0,%esi
  801999:	bf 01 00 00 00       	mov    $0x1,%edi
  80199e:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  8019a5:	00 00 00 
  8019a8:	ff d0                	callq  *%rax
}
  8019aa:	c9                   	leaveq 
  8019ab:	c3                   	retq   

00000000008019ac <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019ac:	55                   	push   %rbp
  8019ad:	48 89 e5             	mov    %rsp,%rbp
  8019b0:	48 83 ec 10          	sub    $0x10,%rsp
  8019b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ba:	48 98                	cltq   
  8019bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c3:	00 
  8019c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d5:	48 89 c2             	mov    %rax,%rdx
  8019d8:	be 01 00 00 00       	mov    $0x1,%esi
  8019dd:	bf 03 00 00 00       	mov    $0x3,%edi
  8019e2:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  8019e9:	00 00 00 
  8019ec:	ff d0                	callq  *%rax
}
  8019ee:	c9                   	leaveq 
  8019ef:	c3                   	retq   

00000000008019f0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019f0:	55                   	push   %rbp
  8019f1:	48 89 e5             	mov    %rsp,%rbp
  8019f4:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ff:	00 
  801a00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a11:	ba 00 00 00 00       	mov    $0x0,%edx
  801a16:	be 00 00 00 00       	mov    $0x0,%esi
  801a1b:	bf 02 00 00 00       	mov    $0x2,%edi
  801a20:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  801a27:	00 00 00 
  801a2a:	ff d0                	callq  *%rax
}
  801a2c:	c9                   	leaveq 
  801a2d:	c3                   	retq   

0000000000801a2e <sys_yield>:

void
sys_yield(void)
{
  801a2e:	55                   	push   %rbp
  801a2f:	48 89 e5             	mov    %rsp,%rbp
  801a32:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a36:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3d:	00 
  801a3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a4f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a54:	be 00 00 00 00       	mov    $0x0,%esi
  801a59:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a5e:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  801a65:	00 00 00 
  801a68:	ff d0                	callq  *%rax
}
  801a6a:	c9                   	leaveq 
  801a6b:	c3                   	retq   

0000000000801a6c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a6c:	55                   	push   %rbp
  801a6d:	48 89 e5             	mov    %rsp,%rbp
  801a70:	48 83 ec 20          	sub    $0x20,%rsp
  801a74:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a77:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a7b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a81:	48 63 c8             	movslq %eax,%rcx
  801a84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8b:	48 98                	cltq   
  801a8d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a94:	00 
  801a95:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a9b:	49 89 c8             	mov    %rcx,%r8
  801a9e:	48 89 d1             	mov    %rdx,%rcx
  801aa1:	48 89 c2             	mov    %rax,%rdx
  801aa4:	be 01 00 00 00       	mov    $0x1,%esi
  801aa9:	bf 04 00 00 00       	mov    $0x4,%edi
  801aae:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  801ab5:	00 00 00 
  801ab8:	ff d0                	callq  *%rax
}
  801aba:	c9                   	leaveq 
  801abb:	c3                   	retq   

0000000000801abc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801abc:	55                   	push   %rbp
  801abd:	48 89 e5             	mov    %rsp,%rbp
  801ac0:	48 83 ec 30          	sub    $0x30,%rsp
  801ac4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801acb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ace:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ad2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ad6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ad9:	48 63 c8             	movslq %eax,%rcx
  801adc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ae0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ae3:	48 63 f0             	movslq %eax,%rsi
  801ae6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aed:	48 98                	cltq   
  801aef:	48 89 0c 24          	mov    %rcx,(%rsp)
  801af3:	49 89 f9             	mov    %rdi,%r9
  801af6:	49 89 f0             	mov    %rsi,%r8
  801af9:	48 89 d1             	mov    %rdx,%rcx
  801afc:	48 89 c2             	mov    %rax,%rdx
  801aff:	be 01 00 00 00       	mov    $0x1,%esi
  801b04:	bf 05 00 00 00       	mov    $0x5,%edi
  801b09:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  801b10:	00 00 00 
  801b13:	ff d0                	callq  *%rax
}
  801b15:	c9                   	leaveq 
  801b16:	c3                   	retq   

0000000000801b17 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b17:	55                   	push   %rbp
  801b18:	48 89 e5             	mov    %rsp,%rbp
  801b1b:	48 83 ec 20          	sub    $0x20,%rsp
  801b1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2d:	48 98                	cltq   
  801b2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b36:	00 
  801b37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b43:	48 89 d1             	mov    %rdx,%rcx
  801b46:	48 89 c2             	mov    %rax,%rdx
  801b49:	be 01 00 00 00       	mov    $0x1,%esi
  801b4e:	bf 06 00 00 00       	mov    $0x6,%edi
  801b53:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  801b5a:	00 00 00 
  801b5d:	ff d0                	callq  *%rax
}
  801b5f:	c9                   	leaveq 
  801b60:	c3                   	retq   

0000000000801b61 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b61:	55                   	push   %rbp
  801b62:	48 89 e5             	mov    %rsp,%rbp
  801b65:	48 83 ec 10          	sub    $0x10,%rsp
  801b69:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b6c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b72:	48 63 d0             	movslq %eax,%rdx
  801b75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b78:	48 98                	cltq   
  801b7a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b81:	00 
  801b82:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b88:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b8e:	48 89 d1             	mov    %rdx,%rcx
  801b91:	48 89 c2             	mov    %rax,%rdx
  801b94:	be 01 00 00 00       	mov    $0x1,%esi
  801b99:	bf 08 00 00 00       	mov    $0x8,%edi
  801b9e:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  801ba5:	00 00 00 
  801ba8:	ff d0                	callq  *%rax
}
  801baa:	c9                   	leaveq 
  801bab:	c3                   	retq   

0000000000801bac <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801bac:	55                   	push   %rbp
  801bad:	48 89 e5             	mov    %rsp,%rbp
  801bb0:	48 83 ec 20          	sub    $0x20,%rsp
  801bb4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bbb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc2:	48 98                	cltq   
  801bc4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bcb:	00 
  801bcc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd8:	48 89 d1             	mov    %rdx,%rcx
  801bdb:	48 89 c2             	mov    %rax,%rdx
  801bde:	be 01 00 00 00       	mov    $0x1,%esi
  801be3:	bf 09 00 00 00       	mov    $0x9,%edi
  801be8:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  801bef:	00 00 00 
  801bf2:	ff d0                	callq  *%rax
}
  801bf4:	c9                   	leaveq 
  801bf5:	c3                   	retq   

0000000000801bf6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bf6:	55                   	push   %rbp
  801bf7:	48 89 e5             	mov    %rsp,%rbp
  801bfa:	48 83 ec 20          	sub    $0x20,%rsp
  801bfe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0c:	48 98                	cltq   
  801c0e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c15:	00 
  801c16:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c1c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c22:	48 89 d1             	mov    %rdx,%rcx
  801c25:	48 89 c2             	mov    %rax,%rdx
  801c28:	be 01 00 00 00       	mov    $0x1,%esi
  801c2d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c32:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  801c39:	00 00 00 
  801c3c:	ff d0                	callq  *%rax
}
  801c3e:	c9                   	leaveq 
  801c3f:	c3                   	retq   

0000000000801c40 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c40:	55                   	push   %rbp
  801c41:	48 89 e5             	mov    %rsp,%rbp
  801c44:	48 83 ec 20          	sub    $0x20,%rsp
  801c48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c4b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c4f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c53:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c56:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c59:	48 63 f0             	movslq %eax,%rsi
  801c5c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c63:	48 98                	cltq   
  801c65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c69:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c70:	00 
  801c71:	49 89 f1             	mov    %rsi,%r9
  801c74:	49 89 c8             	mov    %rcx,%r8
  801c77:	48 89 d1             	mov    %rdx,%rcx
  801c7a:	48 89 c2             	mov    %rax,%rdx
  801c7d:	be 00 00 00 00       	mov    $0x0,%esi
  801c82:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c87:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  801c8e:	00 00 00 
  801c91:	ff d0                	callq  *%rax
}
  801c93:	c9                   	leaveq 
  801c94:	c3                   	retq   

0000000000801c95 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c95:	55                   	push   %rbp
  801c96:	48 89 e5             	mov    %rsp,%rbp
  801c99:	48 83 ec 10          	sub    $0x10,%rsp
  801c9d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ca1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cac:	00 
  801cad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cbe:	48 89 c2             	mov    %rax,%rdx
  801cc1:	be 01 00 00 00       	mov    $0x1,%esi
  801cc6:	bf 0d 00 00 00       	mov    $0xd,%edi
  801ccb:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  801cd2:	00 00 00 
  801cd5:	ff d0                	callq  *%rax
}
  801cd7:	c9                   	leaveq 
  801cd8:	c3                   	retq   

0000000000801cd9 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801cd9:	55                   	push   %rbp
  801cda:	48 89 e5             	mov    %rsp,%rbp
  801cdd:	48 83 ec 18          	sub    $0x18,%rsp
  801ce1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ce5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ce9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  801ced:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cf1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cf5:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  801cf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cfc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d00:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801d04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d08:	8b 00                	mov    (%rax),%eax
  801d0a:	83 f8 01             	cmp    $0x1,%eax
  801d0d:	7e 13                	jle    801d22 <argstart+0x49>
  801d0f:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  801d14:	74 0c                	je     801d22 <argstart+0x49>
  801d16:	48 b8 6b 41 80 00 00 	movabs $0x80416b,%rax
  801d1d:	00 00 00 
  801d20:	eb 05                	jmp    801d27 <argstart+0x4e>
  801d22:	b8 00 00 00 00       	mov    $0x0,%eax
  801d27:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d2b:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  801d2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d33:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801d3a:	00 
}
  801d3b:	c9                   	leaveq 
  801d3c:	c3                   	retq   

0000000000801d3d <argnext>:

int
argnext(struct Argstate *args)
{
  801d3d:	55                   	push   %rbp
  801d3e:	48 89 e5             	mov    %rsp,%rbp
  801d41:	48 83 ec 20          	sub    $0x20,%rsp
  801d45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  801d49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d4d:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801d54:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801d55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d59:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d5d:	48 85 c0             	test   %rax,%rax
  801d60:	75 0a                	jne    801d6c <argnext+0x2f>
		return -1;
  801d62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801d67:	e9 25 01 00 00       	jmpq   801e91 <argnext+0x154>

	if (!*args->curarg) {
  801d6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d70:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d74:	0f b6 00             	movzbl (%rax),%eax
  801d77:	84 c0                	test   %al,%al
  801d79:	0f 85 d7 00 00 00    	jne    801e56 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801d7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d83:	48 8b 00             	mov    (%rax),%rax
  801d86:	8b 00                	mov    (%rax),%eax
  801d88:	83 f8 01             	cmp    $0x1,%eax
  801d8b:	0f 84 ef 00 00 00    	je     801e80 <argnext+0x143>
		    || args->argv[1][0] != '-'
  801d91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d95:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d99:	48 83 c0 08          	add    $0x8,%rax
  801d9d:	48 8b 00             	mov    (%rax),%rax
  801da0:	0f b6 00             	movzbl (%rax),%eax
  801da3:	3c 2d                	cmp    $0x2d,%al
  801da5:	0f 85 d5 00 00 00    	jne    801e80 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  801dab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801daf:	48 8b 40 08          	mov    0x8(%rax),%rax
  801db3:	48 83 c0 08          	add    $0x8,%rax
  801db7:	48 8b 00             	mov    (%rax),%rax
  801dba:	48 83 c0 01          	add    $0x1,%rax
  801dbe:	0f b6 00             	movzbl (%rax),%eax
  801dc1:	84 c0                	test   %al,%al
  801dc3:	0f 84 b7 00 00 00    	je     801e80 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801dc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dcd:	48 8b 40 08          	mov    0x8(%rax),%rax
  801dd1:	48 83 c0 08          	add    $0x8,%rax
  801dd5:	48 8b 00             	mov    (%rax),%rax
  801dd8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ddc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de0:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801de4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de8:	48 8b 00             	mov    (%rax),%rax
  801deb:	8b 00                	mov    (%rax),%eax
  801ded:	83 e8 01             	sub    $0x1,%eax
  801df0:	48 98                	cltq   
  801df2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801df9:	00 
  801dfa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dfe:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e02:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801e06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e0a:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e0e:	48 83 c0 08          	add    $0x8,%rax
  801e12:	48 89 ce             	mov    %rcx,%rsi
  801e15:	48 89 c7             	mov    %rax,%rdi
  801e18:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  801e1f:	00 00 00 
  801e22:	ff d0                	callq  *%rax
		(*args->argc)--;
  801e24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e28:	48 8b 00             	mov    (%rax),%rax
  801e2b:	8b 10                	mov    (%rax),%edx
  801e2d:	83 ea 01             	sub    $0x1,%edx
  801e30:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801e32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e36:	48 8b 40 10          	mov    0x10(%rax),%rax
  801e3a:	0f b6 00             	movzbl (%rax),%eax
  801e3d:	3c 2d                	cmp    $0x2d,%al
  801e3f:	75 15                	jne    801e56 <argnext+0x119>
  801e41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e45:	48 8b 40 10          	mov    0x10(%rax),%rax
  801e49:	48 83 c0 01          	add    $0x1,%rax
  801e4d:	0f b6 00             	movzbl (%rax),%eax
  801e50:	84 c0                	test   %al,%al
  801e52:	75 02                	jne    801e56 <argnext+0x119>
			goto endofargs;
  801e54:	eb 2a                	jmp    801e80 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  801e56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e5a:	48 8b 40 10          	mov    0x10(%rax),%rax
  801e5e:	0f b6 00             	movzbl (%rax),%eax
  801e61:	0f b6 c0             	movzbl %al,%eax
  801e64:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  801e67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e6b:	48 8b 40 10          	mov    0x10(%rax),%rax
  801e6f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e77:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  801e7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e7e:	eb 11                	jmp    801e91 <argnext+0x154>

    endofargs:
	args->curarg = 0;
  801e80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e84:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801e8b:	00 
	return -1;
  801e8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801e91:	c9                   	leaveq 
  801e92:	c3                   	retq   

0000000000801e93 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  801e93:	55                   	push   %rbp
  801e94:	48 89 e5             	mov    %rsp,%rbp
  801e97:	48 83 ec 10          	sub    $0x10,%rsp
  801e9b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801e9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea3:	48 8b 40 18          	mov    0x18(%rax),%rax
  801ea7:	48 85 c0             	test   %rax,%rax
  801eaa:	74 0a                	je     801eb6 <argvalue+0x23>
  801eac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eb0:	48 8b 40 18          	mov    0x18(%rax),%rax
  801eb4:	eb 13                	jmp    801ec9 <argvalue+0x36>
  801eb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eba:	48 89 c7             	mov    %rax,%rdi
  801ebd:	48 b8 cb 1e 80 00 00 	movabs $0x801ecb,%rax
  801ec4:	00 00 00 
  801ec7:	ff d0                	callq  *%rax
}
  801ec9:	c9                   	leaveq 
  801eca:	c3                   	retq   

0000000000801ecb <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  801ecb:	55                   	push   %rbp
  801ecc:	48 89 e5             	mov    %rsp,%rbp
  801ecf:	53                   	push   %rbx
  801ed0:	48 83 ec 18          	sub    $0x18,%rsp
  801ed4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  801ed8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801edc:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ee0:	48 85 c0             	test   %rax,%rax
  801ee3:	75 0a                	jne    801eef <argnextvalue+0x24>
		return 0;
  801ee5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eea:	e9 c8 00 00 00       	jmpq   801fb7 <argnextvalue+0xec>
	if (*args->curarg) {
  801eef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef3:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ef7:	0f b6 00             	movzbl (%rax),%eax
  801efa:	84 c0                	test   %al,%al
  801efc:	74 27                	je     801f25 <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  801efe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f02:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801f06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f0a:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  801f0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f12:	48 bb 6b 41 80 00 00 	movabs $0x80416b,%rbx
  801f19:	00 00 00 
  801f1c:	48 89 58 10          	mov    %rbx,0x10(%rax)
  801f20:	e9 8a 00 00 00       	jmpq   801faf <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  801f25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f29:	48 8b 00             	mov    (%rax),%rax
  801f2c:	8b 00                	mov    (%rax),%eax
  801f2e:	83 f8 01             	cmp    $0x1,%eax
  801f31:	7e 64                	jle    801f97 <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  801f33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f37:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f3b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801f3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f43:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801f47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4b:	48 8b 00             	mov    (%rax),%rax
  801f4e:	8b 00                	mov    (%rax),%eax
  801f50:	83 e8 01             	sub    $0x1,%eax
  801f53:	48 98                	cltq   
  801f55:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801f5c:	00 
  801f5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f61:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f65:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801f69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f6d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f71:	48 83 c0 08          	add    $0x8,%rax
  801f75:	48 89 ce             	mov    %rcx,%rsi
  801f78:	48 89 c7             	mov    %rax,%rdi
  801f7b:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  801f82:	00 00 00 
  801f85:	ff d0                	callq  *%rax
		(*args->argc)--;
  801f87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f8b:	48 8b 00             	mov    (%rax),%rax
  801f8e:	8b 10                	mov    (%rax),%edx
  801f90:	83 ea 01             	sub    $0x1,%edx
  801f93:	89 10                	mov    %edx,(%rax)
  801f95:	eb 18                	jmp    801faf <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  801f97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f9b:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801fa2:	00 
		args->curarg = 0;
  801fa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa7:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801fae:	00 
	}
	return (char*) args->argvalue;
  801faf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb3:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  801fb7:	48 83 c4 18          	add    $0x18,%rsp
  801fbb:	5b                   	pop    %rbx
  801fbc:	5d                   	pop    %rbp
  801fbd:	c3                   	retq   

0000000000801fbe <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801fbe:	55                   	push   %rbp
  801fbf:	48 89 e5             	mov    %rsp,%rbp
  801fc2:	48 83 ec 08          	sub    $0x8,%rsp
  801fc6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801fca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fce:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801fd5:	ff ff ff 
  801fd8:	48 01 d0             	add    %rdx,%rax
  801fdb:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801fdf:	c9                   	leaveq 
  801fe0:	c3                   	retq   

0000000000801fe1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801fe1:	55                   	push   %rbp
  801fe2:	48 89 e5             	mov    %rsp,%rbp
  801fe5:	48 83 ec 08          	sub    $0x8,%rsp
  801fe9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801fed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ff1:	48 89 c7             	mov    %rax,%rdi
  801ff4:	48 b8 be 1f 80 00 00 	movabs $0x801fbe,%rax
  801ffb:	00 00 00 
  801ffe:	ff d0                	callq  *%rax
  802000:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802006:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80200a:	c9                   	leaveq 
  80200b:	c3                   	retq   

000000000080200c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80200c:	55                   	push   %rbp
  80200d:	48 89 e5             	mov    %rsp,%rbp
  802010:	48 83 ec 18          	sub    $0x18,%rsp
  802014:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802018:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80201f:	eb 6b                	jmp    80208c <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802021:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802024:	48 98                	cltq   
  802026:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80202c:	48 c1 e0 0c          	shl    $0xc,%rax
  802030:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802034:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802038:	48 c1 e8 15          	shr    $0x15,%rax
  80203c:	48 89 c2             	mov    %rax,%rdx
  80203f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802046:	01 00 00 
  802049:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80204d:	83 e0 01             	and    $0x1,%eax
  802050:	48 85 c0             	test   %rax,%rax
  802053:	74 21                	je     802076 <fd_alloc+0x6a>
  802055:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802059:	48 c1 e8 0c          	shr    $0xc,%rax
  80205d:	48 89 c2             	mov    %rax,%rdx
  802060:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802067:	01 00 00 
  80206a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80206e:	83 e0 01             	and    $0x1,%eax
  802071:	48 85 c0             	test   %rax,%rax
  802074:	75 12                	jne    802088 <fd_alloc+0x7c>
			*fd_store = fd;
  802076:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80207a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80207e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802081:	b8 00 00 00 00       	mov    $0x0,%eax
  802086:	eb 1a                	jmp    8020a2 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802088:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80208c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802090:	7e 8f                	jle    802021 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802092:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802096:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80209d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8020a2:	c9                   	leaveq 
  8020a3:	c3                   	retq   

00000000008020a4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8020a4:	55                   	push   %rbp
  8020a5:	48 89 e5             	mov    %rsp,%rbp
  8020a8:	48 83 ec 20          	sub    $0x20,%rsp
  8020ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8020b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8020b7:	78 06                	js     8020bf <fd_lookup+0x1b>
  8020b9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8020bd:	7e 07                	jle    8020c6 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8020bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020c4:	eb 6c                	jmp    802132 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8020c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020c9:	48 98                	cltq   
  8020cb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020d1:	48 c1 e0 0c          	shl    $0xc,%rax
  8020d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8020d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020dd:	48 c1 e8 15          	shr    $0x15,%rax
  8020e1:	48 89 c2             	mov    %rax,%rdx
  8020e4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020eb:	01 00 00 
  8020ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020f2:	83 e0 01             	and    $0x1,%eax
  8020f5:	48 85 c0             	test   %rax,%rax
  8020f8:	74 21                	je     80211b <fd_lookup+0x77>
  8020fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020fe:	48 c1 e8 0c          	shr    $0xc,%rax
  802102:	48 89 c2             	mov    %rax,%rdx
  802105:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80210c:	01 00 00 
  80210f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802113:	83 e0 01             	and    $0x1,%eax
  802116:	48 85 c0             	test   %rax,%rax
  802119:	75 07                	jne    802122 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80211b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802120:	eb 10                	jmp    802132 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802122:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802126:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80212a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80212d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802132:	c9                   	leaveq 
  802133:	c3                   	retq   

0000000000802134 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802134:	55                   	push   %rbp
  802135:	48 89 e5             	mov    %rsp,%rbp
  802138:	48 83 ec 30          	sub    $0x30,%rsp
  80213c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802140:	89 f0                	mov    %esi,%eax
  802142:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802145:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802149:	48 89 c7             	mov    %rax,%rdi
  80214c:	48 b8 be 1f 80 00 00 	movabs $0x801fbe,%rax
  802153:	00 00 00 
  802156:	ff d0                	callq  *%rax
  802158:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80215c:	48 89 d6             	mov    %rdx,%rsi
  80215f:	89 c7                	mov    %eax,%edi
  802161:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802168:	00 00 00 
  80216b:	ff d0                	callq  *%rax
  80216d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802170:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802174:	78 0a                	js     802180 <fd_close+0x4c>
	    || fd != fd2)
  802176:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80217a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80217e:	74 12                	je     802192 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802180:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802184:	74 05                	je     80218b <fd_close+0x57>
  802186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802189:	eb 05                	jmp    802190 <fd_close+0x5c>
  80218b:	b8 00 00 00 00       	mov    $0x0,%eax
  802190:	eb 69                	jmp    8021fb <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802192:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802196:	8b 00                	mov    (%rax),%eax
  802198:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80219c:	48 89 d6             	mov    %rdx,%rsi
  80219f:	89 c7                	mov    %eax,%edi
  8021a1:	48 b8 fd 21 80 00 00 	movabs $0x8021fd,%rax
  8021a8:	00 00 00 
  8021ab:	ff d0                	callq  *%rax
  8021ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021b4:	78 2a                	js     8021e0 <fd_close+0xac>
		if (dev->dev_close)
  8021b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ba:	48 8b 40 20          	mov    0x20(%rax),%rax
  8021be:	48 85 c0             	test   %rax,%rax
  8021c1:	74 16                	je     8021d9 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8021c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8021cb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021cf:	48 89 d7             	mov    %rdx,%rdi
  8021d2:	ff d0                	callq  *%rax
  8021d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021d7:	eb 07                	jmp    8021e0 <fd_close+0xac>
		else
			r = 0;
  8021d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8021e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021e4:	48 89 c6             	mov    %rax,%rsi
  8021e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ec:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  8021f3:	00 00 00 
  8021f6:	ff d0                	callq  *%rax
	return r;
  8021f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021fb:	c9                   	leaveq 
  8021fc:	c3                   	retq   

00000000008021fd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8021fd:	55                   	push   %rbp
  8021fe:	48 89 e5             	mov    %rsp,%rbp
  802201:	48 83 ec 20          	sub    $0x20,%rsp
  802205:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802208:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80220c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802213:	eb 41                	jmp    802256 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802215:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80221c:	00 00 00 
  80221f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802222:	48 63 d2             	movslq %edx,%rdx
  802225:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802229:	8b 00                	mov    (%rax),%eax
  80222b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80222e:	75 22                	jne    802252 <dev_lookup+0x55>
			*dev = devtab[i];
  802230:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802237:	00 00 00 
  80223a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80223d:	48 63 d2             	movslq %edx,%rdx
  802240:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802244:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802248:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80224b:	b8 00 00 00 00       	mov    $0x0,%eax
  802250:	eb 60                	jmp    8022b2 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802252:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802256:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80225d:	00 00 00 
  802260:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802263:	48 63 d2             	movslq %edx,%rdx
  802266:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80226a:	48 85 c0             	test   %rax,%rax
  80226d:	75 a6                	jne    802215 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80226f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802276:	00 00 00 
  802279:	48 8b 00             	mov    (%rax),%rax
  80227c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802282:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802285:	89 c6                	mov    %eax,%esi
  802287:	48 bf 70 41 80 00 00 	movabs $0x804170,%rdi
  80228e:	00 00 00 
  802291:	b8 00 00 00 00       	mov    $0x0,%eax
  802296:	48 b9 95 03 80 00 00 	movabs $0x800395,%rcx
  80229d:	00 00 00 
  8022a0:	ff d1                	callq  *%rcx
	*dev = 0;
  8022a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022a6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8022ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8022b2:	c9                   	leaveq 
  8022b3:	c3                   	retq   

00000000008022b4 <close>:

int
close(int fdnum)
{
  8022b4:	55                   	push   %rbp
  8022b5:	48 89 e5             	mov    %rsp,%rbp
  8022b8:	48 83 ec 20          	sub    $0x20,%rsp
  8022bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022bf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022c6:	48 89 d6             	mov    %rdx,%rsi
  8022c9:	89 c7                	mov    %eax,%edi
  8022cb:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  8022d2:	00 00 00 
  8022d5:	ff d0                	callq  *%rax
  8022d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022de:	79 05                	jns    8022e5 <close+0x31>
		return r;
  8022e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e3:	eb 18                	jmp    8022fd <close+0x49>
	else
		return fd_close(fd, 1);
  8022e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e9:	be 01 00 00 00       	mov    $0x1,%esi
  8022ee:	48 89 c7             	mov    %rax,%rdi
  8022f1:	48 b8 34 21 80 00 00 	movabs $0x802134,%rax
  8022f8:	00 00 00 
  8022fb:	ff d0                	callq  *%rax
}
  8022fd:	c9                   	leaveq 
  8022fe:	c3                   	retq   

00000000008022ff <close_all>:

void
close_all(void)
{
  8022ff:	55                   	push   %rbp
  802300:	48 89 e5             	mov    %rsp,%rbp
  802303:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802307:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80230e:	eb 15                	jmp    802325 <close_all+0x26>
		close(i);
  802310:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802313:	89 c7                	mov    %eax,%edi
  802315:	48 b8 b4 22 80 00 00 	movabs $0x8022b4,%rax
  80231c:	00 00 00 
  80231f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802321:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802325:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802329:	7e e5                	jle    802310 <close_all+0x11>
		close(i);
}
  80232b:	c9                   	leaveq 
  80232c:	c3                   	retq   

000000000080232d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80232d:	55                   	push   %rbp
  80232e:	48 89 e5             	mov    %rsp,%rbp
  802331:	48 83 ec 40          	sub    $0x40,%rsp
  802335:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802338:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80233b:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80233f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802342:	48 89 d6             	mov    %rdx,%rsi
  802345:	89 c7                	mov    %eax,%edi
  802347:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  80234e:	00 00 00 
  802351:	ff d0                	callq  *%rax
  802353:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802356:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80235a:	79 08                	jns    802364 <dup+0x37>
		return r;
  80235c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235f:	e9 70 01 00 00       	jmpq   8024d4 <dup+0x1a7>
	close(newfdnum);
  802364:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802367:	89 c7                	mov    %eax,%edi
  802369:	48 b8 b4 22 80 00 00 	movabs $0x8022b4,%rax
  802370:	00 00 00 
  802373:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802375:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802378:	48 98                	cltq   
  80237a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802380:	48 c1 e0 0c          	shl    $0xc,%rax
  802384:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802388:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80238c:	48 89 c7             	mov    %rax,%rdi
  80238f:	48 b8 e1 1f 80 00 00 	movabs $0x801fe1,%rax
  802396:	00 00 00 
  802399:	ff d0                	callq  *%rax
  80239b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80239f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a3:	48 89 c7             	mov    %rax,%rdi
  8023a6:	48 b8 e1 1f 80 00 00 	movabs $0x801fe1,%rax
  8023ad:	00 00 00 
  8023b0:	ff d0                	callq  *%rax
  8023b2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8023b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ba:	48 c1 e8 15          	shr    $0x15,%rax
  8023be:	48 89 c2             	mov    %rax,%rdx
  8023c1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023c8:	01 00 00 
  8023cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023cf:	83 e0 01             	and    $0x1,%eax
  8023d2:	48 85 c0             	test   %rax,%rax
  8023d5:	74 73                	je     80244a <dup+0x11d>
  8023d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023db:	48 c1 e8 0c          	shr    $0xc,%rax
  8023df:	48 89 c2             	mov    %rax,%rdx
  8023e2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023e9:	01 00 00 
  8023ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023f0:	83 e0 01             	and    $0x1,%eax
  8023f3:	48 85 c0             	test   %rax,%rax
  8023f6:	74 52                	je     80244a <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8023f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fc:	48 c1 e8 0c          	shr    $0xc,%rax
  802400:	48 89 c2             	mov    %rax,%rdx
  802403:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80240a:	01 00 00 
  80240d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802411:	25 07 0e 00 00       	and    $0xe07,%eax
  802416:	89 c1                	mov    %eax,%ecx
  802418:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80241c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802420:	41 89 c8             	mov    %ecx,%r8d
  802423:	48 89 d1             	mov    %rdx,%rcx
  802426:	ba 00 00 00 00       	mov    $0x0,%edx
  80242b:	48 89 c6             	mov    %rax,%rsi
  80242e:	bf 00 00 00 00       	mov    $0x0,%edi
  802433:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  80243a:	00 00 00 
  80243d:	ff d0                	callq  *%rax
  80243f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802442:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802446:	79 02                	jns    80244a <dup+0x11d>
			goto err;
  802448:	eb 57                	jmp    8024a1 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80244a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80244e:	48 c1 e8 0c          	shr    $0xc,%rax
  802452:	48 89 c2             	mov    %rax,%rdx
  802455:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80245c:	01 00 00 
  80245f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802463:	25 07 0e 00 00       	and    $0xe07,%eax
  802468:	89 c1                	mov    %eax,%ecx
  80246a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80246e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802472:	41 89 c8             	mov    %ecx,%r8d
  802475:	48 89 d1             	mov    %rdx,%rcx
  802478:	ba 00 00 00 00       	mov    $0x0,%edx
  80247d:	48 89 c6             	mov    %rax,%rsi
  802480:	bf 00 00 00 00       	mov    $0x0,%edi
  802485:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  80248c:	00 00 00 
  80248f:	ff d0                	callq  *%rax
  802491:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802498:	79 02                	jns    80249c <dup+0x16f>
		goto err;
  80249a:	eb 05                	jmp    8024a1 <dup+0x174>

	return newfdnum;
  80249c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80249f:	eb 33                	jmp    8024d4 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8024a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a5:	48 89 c6             	mov    %rax,%rsi
  8024a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ad:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  8024b4:	00 00 00 
  8024b7:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8024b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024bd:	48 89 c6             	mov    %rax,%rsi
  8024c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8024c5:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  8024cc:	00 00 00 
  8024cf:	ff d0                	callq  *%rax
	return r;
  8024d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024d4:	c9                   	leaveq 
  8024d5:	c3                   	retq   

00000000008024d6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8024d6:	55                   	push   %rbp
  8024d7:	48 89 e5             	mov    %rsp,%rbp
  8024da:	48 83 ec 40          	sub    $0x40,%rsp
  8024de:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024e1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024e5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024e9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024ed:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024f0:	48 89 d6             	mov    %rdx,%rsi
  8024f3:	89 c7                	mov    %eax,%edi
  8024f5:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  8024fc:	00 00 00 
  8024ff:	ff d0                	callq  *%rax
  802501:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802504:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802508:	78 24                	js     80252e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80250a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80250e:	8b 00                	mov    (%rax),%eax
  802510:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802514:	48 89 d6             	mov    %rdx,%rsi
  802517:	89 c7                	mov    %eax,%edi
  802519:	48 b8 fd 21 80 00 00 	movabs $0x8021fd,%rax
  802520:	00 00 00 
  802523:	ff d0                	callq  *%rax
  802525:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802528:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80252c:	79 05                	jns    802533 <read+0x5d>
		return r;
  80252e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802531:	eb 76                	jmp    8025a9 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802537:	8b 40 08             	mov    0x8(%rax),%eax
  80253a:	83 e0 03             	and    $0x3,%eax
  80253d:	83 f8 01             	cmp    $0x1,%eax
  802540:	75 3a                	jne    80257c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802542:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802549:	00 00 00 
  80254c:	48 8b 00             	mov    (%rax),%rax
  80254f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802555:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802558:	89 c6                	mov    %eax,%esi
  80255a:	48 bf 8f 41 80 00 00 	movabs $0x80418f,%rdi
  802561:	00 00 00 
  802564:	b8 00 00 00 00       	mov    $0x0,%eax
  802569:	48 b9 95 03 80 00 00 	movabs $0x800395,%rcx
  802570:	00 00 00 
  802573:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802575:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80257a:	eb 2d                	jmp    8025a9 <read+0xd3>
	}
	if (!dev->dev_read)
  80257c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802580:	48 8b 40 10          	mov    0x10(%rax),%rax
  802584:	48 85 c0             	test   %rax,%rax
  802587:	75 07                	jne    802590 <read+0xba>
		return -E_NOT_SUPP;
  802589:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80258e:	eb 19                	jmp    8025a9 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802590:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802594:	48 8b 40 10          	mov    0x10(%rax),%rax
  802598:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80259c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025a0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025a4:	48 89 cf             	mov    %rcx,%rdi
  8025a7:	ff d0                	callq  *%rax
}
  8025a9:	c9                   	leaveq 
  8025aa:	c3                   	retq   

00000000008025ab <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8025ab:	55                   	push   %rbp
  8025ac:	48 89 e5             	mov    %rsp,%rbp
  8025af:	48 83 ec 30          	sub    $0x30,%rsp
  8025b3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8025be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025c5:	eb 49                	jmp    802610 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8025c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ca:	48 98                	cltq   
  8025cc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025d0:	48 29 c2             	sub    %rax,%rdx
  8025d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d6:	48 63 c8             	movslq %eax,%rcx
  8025d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025dd:	48 01 c1             	add    %rax,%rcx
  8025e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025e3:	48 89 ce             	mov    %rcx,%rsi
  8025e6:	89 c7                	mov    %eax,%edi
  8025e8:	48 b8 d6 24 80 00 00 	movabs $0x8024d6,%rax
  8025ef:	00 00 00 
  8025f2:	ff d0                	callq  *%rax
  8025f4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8025f7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8025fb:	79 05                	jns    802602 <readn+0x57>
			return m;
  8025fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802600:	eb 1c                	jmp    80261e <readn+0x73>
		if (m == 0)
  802602:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802606:	75 02                	jne    80260a <readn+0x5f>
			break;
  802608:	eb 11                	jmp    80261b <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80260a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80260d:	01 45 fc             	add    %eax,-0x4(%rbp)
  802610:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802613:	48 98                	cltq   
  802615:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802619:	72 ac                	jb     8025c7 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80261b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80261e:	c9                   	leaveq 
  80261f:	c3                   	retq   

0000000000802620 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802620:	55                   	push   %rbp
  802621:	48 89 e5             	mov    %rsp,%rbp
  802624:	48 83 ec 40          	sub    $0x40,%rsp
  802628:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80262b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80262f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802633:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802637:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80263a:	48 89 d6             	mov    %rdx,%rsi
  80263d:	89 c7                	mov    %eax,%edi
  80263f:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802646:	00 00 00 
  802649:	ff d0                	callq  *%rax
  80264b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80264e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802652:	78 24                	js     802678 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802658:	8b 00                	mov    (%rax),%eax
  80265a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80265e:	48 89 d6             	mov    %rdx,%rsi
  802661:	89 c7                	mov    %eax,%edi
  802663:	48 b8 fd 21 80 00 00 	movabs $0x8021fd,%rax
  80266a:	00 00 00 
  80266d:	ff d0                	callq  *%rax
  80266f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802672:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802676:	79 05                	jns    80267d <write+0x5d>
		return r;
  802678:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267b:	eb 75                	jmp    8026f2 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80267d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802681:	8b 40 08             	mov    0x8(%rax),%eax
  802684:	83 e0 03             	and    $0x3,%eax
  802687:	85 c0                	test   %eax,%eax
  802689:	75 3a                	jne    8026c5 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80268b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802692:	00 00 00 
  802695:	48 8b 00             	mov    (%rax),%rax
  802698:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80269e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026a1:	89 c6                	mov    %eax,%esi
  8026a3:	48 bf ab 41 80 00 00 	movabs $0x8041ab,%rdi
  8026aa:	00 00 00 
  8026ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b2:	48 b9 95 03 80 00 00 	movabs $0x800395,%rcx
  8026b9:	00 00 00 
  8026bc:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8026be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026c3:	eb 2d                	jmp    8026f2 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8026c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026cd:	48 85 c0             	test   %rax,%rax
  8026d0:	75 07                	jne    8026d9 <write+0xb9>
		return -E_NOT_SUPP;
  8026d2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026d7:	eb 19                	jmp    8026f2 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8026d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026dd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026e1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8026e5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026e9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026ed:	48 89 cf             	mov    %rcx,%rdi
  8026f0:	ff d0                	callq  *%rax
}
  8026f2:	c9                   	leaveq 
  8026f3:	c3                   	retq   

00000000008026f4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8026f4:	55                   	push   %rbp
  8026f5:	48 89 e5             	mov    %rsp,%rbp
  8026f8:	48 83 ec 18          	sub    $0x18,%rsp
  8026fc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026ff:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802702:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802706:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802709:	48 89 d6             	mov    %rdx,%rsi
  80270c:	89 c7                	mov    %eax,%edi
  80270e:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802715:	00 00 00 
  802718:	ff d0                	callq  *%rax
  80271a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80271d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802721:	79 05                	jns    802728 <seek+0x34>
		return r;
  802723:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802726:	eb 0f                	jmp    802737 <seek+0x43>
	fd->fd_offset = offset;
  802728:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80272c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80272f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802732:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802737:	c9                   	leaveq 
  802738:	c3                   	retq   

0000000000802739 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802739:	55                   	push   %rbp
  80273a:	48 89 e5             	mov    %rsp,%rbp
  80273d:	48 83 ec 30          	sub    $0x30,%rsp
  802741:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802744:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802747:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80274b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80274e:	48 89 d6             	mov    %rdx,%rsi
  802751:	89 c7                	mov    %eax,%edi
  802753:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  80275a:	00 00 00 
  80275d:	ff d0                	callq  *%rax
  80275f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802762:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802766:	78 24                	js     80278c <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802768:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276c:	8b 00                	mov    (%rax),%eax
  80276e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802772:	48 89 d6             	mov    %rdx,%rsi
  802775:	89 c7                	mov    %eax,%edi
  802777:	48 b8 fd 21 80 00 00 	movabs $0x8021fd,%rax
  80277e:	00 00 00 
  802781:	ff d0                	callq  *%rax
  802783:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802786:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278a:	79 05                	jns    802791 <ftruncate+0x58>
		return r;
  80278c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278f:	eb 72                	jmp    802803 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802791:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802795:	8b 40 08             	mov    0x8(%rax),%eax
  802798:	83 e0 03             	and    $0x3,%eax
  80279b:	85 c0                	test   %eax,%eax
  80279d:	75 3a                	jne    8027d9 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80279f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8027a6:	00 00 00 
  8027a9:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8027ac:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027b2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027b5:	89 c6                	mov    %eax,%esi
  8027b7:	48 bf c8 41 80 00 00 	movabs $0x8041c8,%rdi
  8027be:	00 00 00 
  8027c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c6:	48 b9 95 03 80 00 00 	movabs $0x800395,%rcx
  8027cd:	00 00 00 
  8027d0:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8027d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027d7:	eb 2a                	jmp    802803 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8027d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027dd:	48 8b 40 30          	mov    0x30(%rax),%rax
  8027e1:	48 85 c0             	test   %rax,%rax
  8027e4:	75 07                	jne    8027ed <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8027e6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027eb:	eb 16                	jmp    802803 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8027ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f1:	48 8b 40 30          	mov    0x30(%rax),%rax
  8027f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027f9:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8027fc:	89 ce                	mov    %ecx,%esi
  8027fe:	48 89 d7             	mov    %rdx,%rdi
  802801:	ff d0                	callq  *%rax
}
  802803:	c9                   	leaveq 
  802804:	c3                   	retq   

0000000000802805 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802805:	55                   	push   %rbp
  802806:	48 89 e5             	mov    %rsp,%rbp
  802809:	48 83 ec 30          	sub    $0x30,%rsp
  80280d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802810:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802814:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802818:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80281b:	48 89 d6             	mov    %rdx,%rsi
  80281e:	89 c7                	mov    %eax,%edi
  802820:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  802827:	00 00 00 
  80282a:	ff d0                	callq  *%rax
  80282c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80282f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802833:	78 24                	js     802859 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802835:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802839:	8b 00                	mov    (%rax),%eax
  80283b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80283f:	48 89 d6             	mov    %rdx,%rsi
  802842:	89 c7                	mov    %eax,%edi
  802844:	48 b8 fd 21 80 00 00 	movabs $0x8021fd,%rax
  80284b:	00 00 00 
  80284e:	ff d0                	callq  *%rax
  802850:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802853:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802857:	79 05                	jns    80285e <fstat+0x59>
		return r;
  802859:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80285c:	eb 5e                	jmp    8028bc <fstat+0xb7>
	if (!dev->dev_stat)
  80285e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802862:	48 8b 40 28          	mov    0x28(%rax),%rax
  802866:	48 85 c0             	test   %rax,%rax
  802869:	75 07                	jne    802872 <fstat+0x6d>
		return -E_NOT_SUPP;
  80286b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802870:	eb 4a                	jmp    8028bc <fstat+0xb7>
	stat->st_name[0] = 0;
  802872:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802876:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802879:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80287d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802884:	00 00 00 
	stat->st_isdir = 0;
  802887:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80288b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802892:	00 00 00 
	stat->st_dev = dev;
  802895:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802899:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80289d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8028a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a8:	48 8b 40 28          	mov    0x28(%rax),%rax
  8028ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028b0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8028b4:	48 89 ce             	mov    %rcx,%rsi
  8028b7:	48 89 d7             	mov    %rdx,%rdi
  8028ba:	ff d0                	callq  *%rax
}
  8028bc:	c9                   	leaveq 
  8028bd:	c3                   	retq   

00000000008028be <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8028be:	55                   	push   %rbp
  8028bf:	48 89 e5             	mov    %rsp,%rbp
  8028c2:	48 83 ec 20          	sub    $0x20,%rsp
  8028c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8028ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d2:	be 00 00 00 00       	mov    $0x0,%esi
  8028d7:	48 89 c7             	mov    %rax,%rdi
  8028da:	48 b8 ac 29 80 00 00 	movabs $0x8029ac,%rax
  8028e1:	00 00 00 
  8028e4:	ff d0                	callq  *%rax
  8028e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ed:	79 05                	jns    8028f4 <stat+0x36>
		return fd;
  8028ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f2:	eb 2f                	jmp    802923 <stat+0x65>
	r = fstat(fd, stat);
  8028f4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028fb:	48 89 d6             	mov    %rdx,%rsi
  8028fe:	89 c7                	mov    %eax,%edi
  802900:	48 b8 05 28 80 00 00 	movabs $0x802805,%rax
  802907:	00 00 00 
  80290a:	ff d0                	callq  *%rax
  80290c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80290f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802912:	89 c7                	mov    %eax,%edi
  802914:	48 b8 b4 22 80 00 00 	movabs $0x8022b4,%rax
  80291b:	00 00 00 
  80291e:	ff d0                	callq  *%rax
	return r;
  802920:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802923:	c9                   	leaveq 
  802924:	c3                   	retq   

0000000000802925 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802925:	55                   	push   %rbp
  802926:	48 89 e5             	mov    %rsp,%rbp
  802929:	48 83 ec 10          	sub    $0x10,%rsp
  80292d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802930:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802934:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  80293b:	00 00 00 
  80293e:	8b 00                	mov    (%rax),%eax
  802940:	85 c0                	test   %eax,%eax
  802942:	75 1d                	jne    802961 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802944:	bf 01 00 00 00       	mov    $0x1,%edi
  802949:	48 b8 33 3b 80 00 00 	movabs $0x803b33,%rax
  802950:	00 00 00 
  802953:	ff d0                	callq  *%rax
  802955:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  80295c:	00 00 00 
  80295f:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802961:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802968:	00 00 00 
  80296b:	8b 00                	mov    (%rax),%eax
  80296d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802970:	b9 07 00 00 00       	mov    $0x7,%ecx
  802975:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80297c:	00 00 00 
  80297f:	89 c7                	mov    %eax,%edi
  802981:	48 b8 9b 3a 80 00 00 	movabs $0x803a9b,%rax
  802988:	00 00 00 
  80298b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80298d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802991:	ba 00 00 00 00       	mov    $0x0,%edx
  802996:	48 89 c6             	mov    %rax,%rsi
  802999:	bf 00 00 00 00       	mov    $0x0,%edi
  80299e:	48 b8 d2 39 80 00 00 	movabs $0x8039d2,%rax
  8029a5:	00 00 00 
  8029a8:	ff d0                	callq  *%rax
}
  8029aa:	c9                   	leaveq 
  8029ab:	c3                   	retq   

00000000008029ac <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8029ac:	55                   	push   %rbp
  8029ad:	48 89 e5             	mov    %rsp,%rbp
  8029b0:	48 83 ec 20          	sub    $0x20,%rsp
  8029b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029b8:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  8029bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029bf:	48 89 c7             	mov    %rax,%rdi
  8029c2:	48 b8 d1 10 80 00 00 	movabs $0x8010d1,%rax
  8029c9:	00 00 00 
  8029cc:	ff d0                	callq  *%rax
  8029ce:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8029d3:	7e 0a                	jle    8029df <open+0x33>
		return -E_BAD_PATH;
  8029d5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8029da:	e9 a5 00 00 00       	jmpq   802a84 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8029df:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8029e3:	48 89 c7             	mov    %rax,%rdi
  8029e6:	48 b8 0c 20 80 00 00 	movabs $0x80200c,%rax
  8029ed:	00 00 00 
  8029f0:	ff d0                	callq  *%rax
  8029f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f9:	79 08                	jns    802a03 <open+0x57>
		return r;
  8029fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029fe:	e9 81 00 00 00       	jmpq   802a84 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802a03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a07:	48 89 c6             	mov    %rax,%rsi
  802a0a:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802a11:	00 00 00 
  802a14:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  802a1b:	00 00 00 
  802a1e:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802a20:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a27:	00 00 00 
  802a2a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802a2d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802a33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a37:	48 89 c6             	mov    %rax,%rsi
  802a3a:	bf 01 00 00 00       	mov    $0x1,%edi
  802a3f:	48 b8 25 29 80 00 00 	movabs $0x802925,%rax
  802a46:	00 00 00 
  802a49:	ff d0                	callq  *%rax
  802a4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a52:	79 1d                	jns    802a71 <open+0xc5>
		fd_close(fd, 0);
  802a54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a58:	be 00 00 00 00       	mov    $0x0,%esi
  802a5d:	48 89 c7             	mov    %rax,%rdi
  802a60:	48 b8 34 21 80 00 00 	movabs $0x802134,%rax
  802a67:	00 00 00 
  802a6a:	ff d0                	callq  *%rax
		return r;
  802a6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6f:	eb 13                	jmp    802a84 <open+0xd8>
	}

	return fd2num(fd);
  802a71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a75:	48 89 c7             	mov    %rax,%rdi
  802a78:	48 b8 be 1f 80 00 00 	movabs $0x801fbe,%rax
  802a7f:	00 00 00 
  802a82:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802a84:	c9                   	leaveq 
  802a85:	c3                   	retq   

0000000000802a86 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802a86:	55                   	push   %rbp
  802a87:	48 89 e5             	mov    %rsp,%rbp
  802a8a:	48 83 ec 10          	sub    $0x10,%rsp
  802a8e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802a92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a96:	8b 50 0c             	mov    0xc(%rax),%edx
  802a99:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aa0:	00 00 00 
  802aa3:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802aa5:	be 00 00 00 00       	mov    $0x0,%esi
  802aaa:	bf 06 00 00 00       	mov    $0x6,%edi
  802aaf:	48 b8 25 29 80 00 00 	movabs $0x802925,%rax
  802ab6:	00 00 00 
  802ab9:	ff d0                	callq  *%rax
}
  802abb:	c9                   	leaveq 
  802abc:	c3                   	retq   

0000000000802abd <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802abd:	55                   	push   %rbp
  802abe:	48 89 e5             	mov    %rsp,%rbp
  802ac1:	48 83 ec 30          	sub    $0x30,%rsp
  802ac5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ac9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802acd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802ad1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad5:	8b 50 0c             	mov    0xc(%rax),%edx
  802ad8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802adf:	00 00 00 
  802ae2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802ae4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aeb:	00 00 00 
  802aee:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802af2:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802af6:	be 00 00 00 00       	mov    $0x0,%esi
  802afb:	bf 03 00 00 00       	mov    $0x3,%edi
  802b00:	48 b8 25 29 80 00 00 	movabs $0x802925,%rax
  802b07:	00 00 00 
  802b0a:	ff d0                	callq  *%rax
  802b0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b13:	79 05                	jns    802b1a <devfile_read+0x5d>
		return r;
  802b15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b18:	eb 26                	jmp    802b40 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802b1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1d:	48 63 d0             	movslq %eax,%rdx
  802b20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b24:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802b2b:	00 00 00 
  802b2e:	48 89 c7             	mov    %rax,%rdi
  802b31:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  802b38:	00 00 00 
  802b3b:	ff d0                	callq  *%rax

	return r;
  802b3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802b40:	c9                   	leaveq 
  802b41:	c3                   	retq   

0000000000802b42 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802b42:	55                   	push   %rbp
  802b43:	48 89 e5             	mov    %rsp,%rbp
  802b46:	48 83 ec 30          	sub    $0x30,%rsp
  802b4a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b4e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b52:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802b56:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802b5d:	00 
  802b5e:	76 08                	jbe    802b68 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802b60:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802b67:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802b68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b6c:	8b 50 0c             	mov    0xc(%rax),%edx
  802b6f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b76:	00 00 00 
  802b79:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802b7b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b82:	00 00 00 
  802b85:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b89:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  802b8d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b95:	48 89 c6             	mov    %rax,%rsi
  802b98:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802b9f:	00 00 00 
  802ba2:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  802ba9:	00 00 00 
  802bac:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802bae:	be 00 00 00 00       	mov    $0x0,%esi
  802bb3:	bf 04 00 00 00       	mov    $0x4,%edi
  802bb8:	48 b8 25 29 80 00 00 	movabs $0x802925,%rax
  802bbf:	00 00 00 
  802bc2:	ff d0                	callq  *%rax
  802bc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bcb:	79 05                	jns    802bd2 <devfile_write+0x90>
		return r;
  802bcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd0:	eb 03                	jmp    802bd5 <devfile_write+0x93>

	return r;
  802bd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802bd5:	c9                   	leaveq 
  802bd6:	c3                   	retq   

0000000000802bd7 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802bd7:	55                   	push   %rbp
  802bd8:	48 89 e5             	mov    %rsp,%rbp
  802bdb:	48 83 ec 20          	sub    $0x20,%rsp
  802bdf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802be3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802be7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802beb:	8b 50 0c             	mov    0xc(%rax),%edx
  802bee:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bf5:	00 00 00 
  802bf8:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802bfa:	be 00 00 00 00       	mov    $0x0,%esi
  802bff:	bf 05 00 00 00       	mov    $0x5,%edi
  802c04:	48 b8 25 29 80 00 00 	movabs $0x802925,%rax
  802c0b:	00 00 00 
  802c0e:	ff d0                	callq  *%rax
  802c10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c17:	79 05                	jns    802c1e <devfile_stat+0x47>
		return r;
  802c19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1c:	eb 56                	jmp    802c74 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802c1e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c22:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802c29:	00 00 00 
  802c2c:	48 89 c7             	mov    %rax,%rdi
  802c2f:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  802c36:	00 00 00 
  802c39:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802c3b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c42:	00 00 00 
  802c45:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802c4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c4f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802c55:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c5c:	00 00 00 
  802c5f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802c65:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c69:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802c6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c74:	c9                   	leaveq 
  802c75:	c3                   	retq   

0000000000802c76 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802c76:	55                   	push   %rbp
  802c77:	48 89 e5             	mov    %rsp,%rbp
  802c7a:	48 83 ec 10          	sub    $0x10,%rsp
  802c7e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c82:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802c85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c89:	8b 50 0c             	mov    0xc(%rax),%edx
  802c8c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c93:	00 00 00 
  802c96:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802c98:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c9f:	00 00 00 
  802ca2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802ca5:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802ca8:	be 00 00 00 00       	mov    $0x0,%esi
  802cad:	bf 02 00 00 00       	mov    $0x2,%edi
  802cb2:	48 b8 25 29 80 00 00 	movabs $0x802925,%rax
  802cb9:	00 00 00 
  802cbc:	ff d0                	callq  *%rax
}
  802cbe:	c9                   	leaveq 
  802cbf:	c3                   	retq   

0000000000802cc0 <remove>:

// Delete a file
int
remove(const char *path)
{
  802cc0:	55                   	push   %rbp
  802cc1:	48 89 e5             	mov    %rsp,%rbp
  802cc4:	48 83 ec 10          	sub    $0x10,%rsp
  802cc8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802ccc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cd0:	48 89 c7             	mov    %rax,%rdi
  802cd3:	48 b8 d1 10 80 00 00 	movabs $0x8010d1,%rax
  802cda:	00 00 00 
  802cdd:	ff d0                	callq  *%rax
  802cdf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ce4:	7e 07                	jle    802ced <remove+0x2d>
		return -E_BAD_PATH;
  802ce6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ceb:	eb 33                	jmp    802d20 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ced:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cf1:	48 89 c6             	mov    %rax,%rsi
  802cf4:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802cfb:	00 00 00 
  802cfe:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  802d05:	00 00 00 
  802d08:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802d0a:	be 00 00 00 00       	mov    $0x0,%esi
  802d0f:	bf 07 00 00 00       	mov    $0x7,%edi
  802d14:	48 b8 25 29 80 00 00 	movabs $0x802925,%rax
  802d1b:	00 00 00 
  802d1e:	ff d0                	callq  *%rax
}
  802d20:	c9                   	leaveq 
  802d21:	c3                   	retq   

0000000000802d22 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802d22:	55                   	push   %rbp
  802d23:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802d26:	be 00 00 00 00       	mov    $0x0,%esi
  802d2b:	bf 08 00 00 00       	mov    $0x8,%edi
  802d30:	48 b8 25 29 80 00 00 	movabs $0x802925,%rax
  802d37:	00 00 00 
  802d3a:	ff d0                	callq  *%rax
}
  802d3c:	5d                   	pop    %rbp
  802d3d:	c3                   	retq   

0000000000802d3e <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802d3e:	55                   	push   %rbp
  802d3f:	48 89 e5             	mov    %rsp,%rbp
  802d42:	48 83 ec 20          	sub    $0x20,%rsp
  802d46:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802d4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d4e:	8b 40 0c             	mov    0xc(%rax),%eax
  802d51:	85 c0                	test   %eax,%eax
  802d53:	7e 67                	jle    802dbc <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802d55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d59:	8b 40 04             	mov    0x4(%rax),%eax
  802d5c:	48 63 d0             	movslq %eax,%rdx
  802d5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d63:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802d67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d6b:	8b 00                	mov    (%rax),%eax
  802d6d:	48 89 ce             	mov    %rcx,%rsi
  802d70:	89 c7                	mov    %eax,%edi
  802d72:	48 b8 20 26 80 00 00 	movabs $0x802620,%rax
  802d79:	00 00 00 
  802d7c:	ff d0                	callq  *%rax
  802d7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802d81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d85:	7e 13                	jle    802d9a <writebuf+0x5c>
			b->result += result;
  802d87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d8b:	8b 50 08             	mov    0x8(%rax),%edx
  802d8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d91:	01 c2                	add    %eax,%edx
  802d93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d97:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802d9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9e:	8b 40 04             	mov    0x4(%rax),%eax
  802da1:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802da4:	74 16                	je     802dbc <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802da6:	b8 00 00 00 00       	mov    $0x0,%eax
  802dab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802daf:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802db3:	89 c2                	mov    %eax,%edx
  802db5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db9:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802dbc:	c9                   	leaveq 
  802dbd:	c3                   	retq   

0000000000802dbe <putch>:

static void
putch(int ch, void *thunk)
{
  802dbe:	55                   	push   %rbp
  802dbf:	48 89 e5             	mov    %rsp,%rbp
  802dc2:	48 83 ec 20          	sub    $0x20,%rsp
  802dc6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dc9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802dcd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dd1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802dd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dd9:	8b 40 04             	mov    0x4(%rax),%eax
  802ddc:	8d 48 01             	lea    0x1(%rax),%ecx
  802ddf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802de3:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802de6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802de9:	89 d1                	mov    %edx,%ecx
  802deb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802def:	48 98                	cltq   
  802df1:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802df5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802df9:	8b 40 04             	mov    0x4(%rax),%eax
  802dfc:	3d 00 01 00 00       	cmp    $0x100,%eax
  802e01:	75 1e                	jne    802e21 <putch+0x63>
		writebuf(b);
  802e03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e07:	48 89 c7             	mov    %rax,%rdi
  802e0a:	48 b8 3e 2d 80 00 00 	movabs $0x802d3e,%rax
  802e11:	00 00 00 
  802e14:	ff d0                	callq  *%rax
		b->idx = 0;
  802e16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802e21:	c9                   	leaveq 
  802e22:	c3                   	retq   

0000000000802e23 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802e23:	55                   	push   %rbp
  802e24:	48 89 e5             	mov    %rsp,%rbp
  802e27:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802e2e:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802e34:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802e3b:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802e42:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802e48:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802e4e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802e55:	00 00 00 
	b.result = 0;
  802e58:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802e5f:	00 00 00 
	b.error = 1;
  802e62:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802e69:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802e6c:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802e73:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802e7a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802e81:	48 89 c6             	mov    %rax,%rsi
  802e84:	48 bf be 2d 80 00 00 	movabs $0x802dbe,%rdi
  802e8b:	00 00 00 
  802e8e:	48 b8 48 07 80 00 00 	movabs $0x800748,%rax
  802e95:	00 00 00 
  802e98:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802e9a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802ea0:	85 c0                	test   %eax,%eax
  802ea2:	7e 16                	jle    802eba <vfprintf+0x97>
		writebuf(&b);
  802ea4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802eab:	48 89 c7             	mov    %rax,%rdi
  802eae:	48 b8 3e 2d 80 00 00 	movabs $0x802d3e,%rax
  802eb5:	00 00 00 
  802eb8:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802eba:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802ec0:	85 c0                	test   %eax,%eax
  802ec2:	74 08                	je     802ecc <vfprintf+0xa9>
  802ec4:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802eca:	eb 06                	jmp    802ed2 <vfprintf+0xaf>
  802ecc:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802ed2:	c9                   	leaveq 
  802ed3:	c3                   	retq   

0000000000802ed4 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802ed4:	55                   	push   %rbp
  802ed5:	48 89 e5             	mov    %rsp,%rbp
  802ed8:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802edf:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802ee5:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802eec:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802ef3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802efa:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802f01:	84 c0                	test   %al,%al
  802f03:	74 20                	je     802f25 <fprintf+0x51>
  802f05:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802f09:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802f0d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802f11:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802f15:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802f19:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802f1d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802f21:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802f25:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802f2c:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802f33:	00 00 00 
  802f36:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802f3d:	00 00 00 
  802f40:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f44:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802f4b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802f52:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802f59:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802f60:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802f67:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802f6d:	48 89 ce             	mov    %rcx,%rsi
  802f70:	89 c7                	mov    %eax,%edi
  802f72:	48 b8 23 2e 80 00 00 	movabs $0x802e23,%rax
  802f79:	00 00 00 
  802f7c:	ff d0                	callq  *%rax
  802f7e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802f84:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802f8a:	c9                   	leaveq 
  802f8b:	c3                   	retq   

0000000000802f8c <printf>:

int
printf(const char *fmt, ...)
{
  802f8c:	55                   	push   %rbp
  802f8d:	48 89 e5             	mov    %rsp,%rbp
  802f90:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802f97:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802f9e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802fa5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802fac:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802fb3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802fba:	84 c0                	test   %al,%al
  802fbc:	74 20                	je     802fde <printf+0x52>
  802fbe:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802fc2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802fc6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802fca:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802fce:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802fd2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802fd6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802fda:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802fde:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802fe5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802fec:	00 00 00 
  802fef:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802ff6:	00 00 00 
  802ff9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802ffd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803004:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80300b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  803012:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803019:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803020:	48 89 c6             	mov    %rax,%rsi
  803023:	bf 01 00 00 00       	mov    $0x1,%edi
  803028:	48 b8 23 2e 80 00 00 	movabs $0x802e23,%rax
  80302f:	00 00 00 
  803032:	ff d0                	callq  *%rax
  803034:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80303a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803040:	c9                   	leaveq 
  803041:	c3                   	retq   

0000000000803042 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803042:	55                   	push   %rbp
  803043:	48 89 e5             	mov    %rsp,%rbp
  803046:	53                   	push   %rbx
  803047:	48 83 ec 38          	sub    $0x38,%rsp
  80304b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80304f:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803053:	48 89 c7             	mov    %rax,%rdi
  803056:	48 b8 0c 20 80 00 00 	movabs $0x80200c,%rax
  80305d:	00 00 00 
  803060:	ff d0                	callq  *%rax
  803062:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803065:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803069:	0f 88 bf 01 00 00    	js     80322e <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80306f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803073:	ba 07 04 00 00       	mov    $0x407,%edx
  803078:	48 89 c6             	mov    %rax,%rsi
  80307b:	bf 00 00 00 00       	mov    $0x0,%edi
  803080:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  803087:	00 00 00 
  80308a:	ff d0                	callq  *%rax
  80308c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80308f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803093:	0f 88 95 01 00 00    	js     80322e <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803099:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80309d:	48 89 c7             	mov    %rax,%rdi
  8030a0:	48 b8 0c 20 80 00 00 	movabs $0x80200c,%rax
  8030a7:	00 00 00 
  8030aa:	ff d0                	callq  *%rax
  8030ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030af:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030b3:	0f 88 5d 01 00 00    	js     803216 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030bd:	ba 07 04 00 00       	mov    $0x407,%edx
  8030c2:	48 89 c6             	mov    %rax,%rsi
  8030c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8030ca:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  8030d1:	00 00 00 
  8030d4:	ff d0                	callq  *%rax
  8030d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030dd:	0f 88 33 01 00 00    	js     803216 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8030e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030e7:	48 89 c7             	mov    %rax,%rdi
  8030ea:	48 b8 e1 1f 80 00 00 	movabs $0x801fe1,%rax
  8030f1:	00 00 00 
  8030f4:	ff d0                	callq  *%rax
  8030f6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030fe:	ba 07 04 00 00       	mov    $0x407,%edx
  803103:	48 89 c6             	mov    %rax,%rsi
  803106:	bf 00 00 00 00       	mov    $0x0,%edi
  80310b:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  803112:	00 00 00 
  803115:	ff d0                	callq  *%rax
  803117:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80311a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80311e:	79 05                	jns    803125 <pipe+0xe3>
		goto err2;
  803120:	e9 d9 00 00 00       	jmpq   8031fe <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803125:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803129:	48 89 c7             	mov    %rax,%rdi
  80312c:	48 b8 e1 1f 80 00 00 	movabs $0x801fe1,%rax
  803133:	00 00 00 
  803136:	ff d0                	callq  *%rax
  803138:	48 89 c2             	mov    %rax,%rdx
  80313b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80313f:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803145:	48 89 d1             	mov    %rdx,%rcx
  803148:	ba 00 00 00 00       	mov    $0x0,%edx
  80314d:	48 89 c6             	mov    %rax,%rsi
  803150:	bf 00 00 00 00       	mov    $0x0,%edi
  803155:	48 b8 bc 1a 80 00 00 	movabs $0x801abc,%rax
  80315c:	00 00 00 
  80315f:	ff d0                	callq  *%rax
  803161:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803164:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803168:	79 1b                	jns    803185 <pipe+0x143>
		goto err3;
  80316a:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  80316b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80316f:	48 89 c6             	mov    %rax,%rsi
  803172:	bf 00 00 00 00       	mov    $0x0,%edi
  803177:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  80317e:	00 00 00 
  803181:	ff d0                	callq  *%rax
  803183:	eb 79                	jmp    8031fe <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803185:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803189:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  803190:	00 00 00 
  803193:	8b 12                	mov    (%rdx),%edx
  803195:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803197:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80319b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8031a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031a6:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8031ad:	00 00 00 
  8031b0:	8b 12                	mov    (%rdx),%edx
  8031b2:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8031b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031b8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8031bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031c3:	48 89 c7             	mov    %rax,%rdi
  8031c6:	48 b8 be 1f 80 00 00 	movabs $0x801fbe,%rax
  8031cd:	00 00 00 
  8031d0:	ff d0                	callq  *%rax
  8031d2:	89 c2                	mov    %eax,%edx
  8031d4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8031d8:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8031da:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8031de:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8031e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031e6:	48 89 c7             	mov    %rax,%rdi
  8031e9:	48 b8 be 1f 80 00 00 	movabs $0x801fbe,%rax
  8031f0:	00 00 00 
  8031f3:	ff d0                	callq  *%rax
  8031f5:	89 03                	mov    %eax,(%rbx)
	return 0;
  8031f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8031fc:	eb 33                	jmp    803231 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8031fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803202:	48 89 c6             	mov    %rax,%rsi
  803205:	bf 00 00 00 00       	mov    $0x0,%edi
  80320a:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  803211:	00 00 00 
  803214:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803216:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80321a:	48 89 c6             	mov    %rax,%rsi
  80321d:	bf 00 00 00 00       	mov    $0x0,%edi
  803222:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  803229:	00 00 00 
  80322c:	ff d0                	callq  *%rax
    err:
	return r;
  80322e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803231:	48 83 c4 38          	add    $0x38,%rsp
  803235:	5b                   	pop    %rbx
  803236:	5d                   	pop    %rbp
  803237:	c3                   	retq   

0000000000803238 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803238:	55                   	push   %rbp
  803239:	48 89 e5             	mov    %rsp,%rbp
  80323c:	53                   	push   %rbx
  80323d:	48 83 ec 28          	sub    $0x28,%rsp
  803241:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803245:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803249:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803250:	00 00 00 
  803253:	48 8b 00             	mov    (%rax),%rax
  803256:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80325c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80325f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803263:	48 89 c7             	mov    %rax,%rdi
  803266:	48 b8 b5 3b 80 00 00 	movabs $0x803bb5,%rax
  80326d:	00 00 00 
  803270:	ff d0                	callq  *%rax
  803272:	89 c3                	mov    %eax,%ebx
  803274:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803278:	48 89 c7             	mov    %rax,%rdi
  80327b:	48 b8 b5 3b 80 00 00 	movabs $0x803bb5,%rax
  803282:	00 00 00 
  803285:	ff d0                	callq  *%rax
  803287:	39 c3                	cmp    %eax,%ebx
  803289:	0f 94 c0             	sete   %al
  80328c:	0f b6 c0             	movzbl %al,%eax
  80328f:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803292:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803299:	00 00 00 
  80329c:	48 8b 00             	mov    (%rax),%rax
  80329f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8032a5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8032a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032ab:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8032ae:	75 05                	jne    8032b5 <_pipeisclosed+0x7d>
			return ret;
  8032b0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032b3:	eb 4f                	jmp    803304 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8032b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032b8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8032bb:	74 42                	je     8032ff <_pipeisclosed+0xc7>
  8032bd:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8032c1:	75 3c                	jne    8032ff <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8032c3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8032ca:	00 00 00 
  8032cd:	48 8b 00             	mov    (%rax),%rax
  8032d0:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8032d6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8032d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032dc:	89 c6                	mov    %eax,%esi
  8032de:	48 bf f3 41 80 00 00 	movabs $0x8041f3,%rdi
  8032e5:	00 00 00 
  8032e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ed:	49 b8 95 03 80 00 00 	movabs $0x800395,%r8
  8032f4:	00 00 00 
  8032f7:	41 ff d0             	callq  *%r8
	}
  8032fa:	e9 4a ff ff ff       	jmpq   803249 <_pipeisclosed+0x11>
  8032ff:	e9 45 ff ff ff       	jmpq   803249 <_pipeisclosed+0x11>
}
  803304:	48 83 c4 28          	add    $0x28,%rsp
  803308:	5b                   	pop    %rbx
  803309:	5d                   	pop    %rbp
  80330a:	c3                   	retq   

000000000080330b <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80330b:	55                   	push   %rbp
  80330c:	48 89 e5             	mov    %rsp,%rbp
  80330f:	48 83 ec 30          	sub    $0x30,%rsp
  803313:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803316:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80331a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80331d:	48 89 d6             	mov    %rdx,%rsi
  803320:	89 c7                	mov    %eax,%edi
  803322:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  803329:	00 00 00 
  80332c:	ff d0                	callq  *%rax
  80332e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803331:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803335:	79 05                	jns    80333c <pipeisclosed+0x31>
		return r;
  803337:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80333a:	eb 31                	jmp    80336d <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80333c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803340:	48 89 c7             	mov    %rax,%rdi
  803343:	48 b8 e1 1f 80 00 00 	movabs $0x801fe1,%rax
  80334a:	00 00 00 
  80334d:	ff d0                	callq  *%rax
  80334f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803353:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803357:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80335b:	48 89 d6             	mov    %rdx,%rsi
  80335e:	48 89 c7             	mov    %rax,%rdi
  803361:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  803368:	00 00 00 
  80336b:	ff d0                	callq  *%rax
}
  80336d:	c9                   	leaveq 
  80336e:	c3                   	retq   

000000000080336f <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80336f:	55                   	push   %rbp
  803370:	48 89 e5             	mov    %rsp,%rbp
  803373:	48 83 ec 40          	sub    $0x40,%rsp
  803377:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80337b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80337f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803383:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803387:	48 89 c7             	mov    %rax,%rdi
  80338a:	48 b8 e1 1f 80 00 00 	movabs $0x801fe1,%rax
  803391:	00 00 00 
  803394:	ff d0                	callq  *%rax
  803396:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80339a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80339e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8033a2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8033a9:	00 
  8033aa:	e9 92 00 00 00       	jmpq   803441 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8033af:	eb 41                	jmp    8033f2 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8033b1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8033b6:	74 09                	je     8033c1 <devpipe_read+0x52>
				return i;
  8033b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033bc:	e9 92 00 00 00       	jmpq   803453 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8033c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033c9:	48 89 d6             	mov    %rdx,%rsi
  8033cc:	48 89 c7             	mov    %rax,%rdi
  8033cf:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  8033d6:	00 00 00 
  8033d9:	ff d0                	callq  *%rax
  8033db:	85 c0                	test   %eax,%eax
  8033dd:	74 07                	je     8033e6 <devpipe_read+0x77>
				return 0;
  8033df:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e4:	eb 6d                	jmp    803453 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8033e6:	48 b8 2e 1a 80 00 00 	movabs $0x801a2e,%rax
  8033ed:	00 00 00 
  8033f0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8033f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f6:	8b 10                	mov    (%rax),%edx
  8033f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033fc:	8b 40 04             	mov    0x4(%rax),%eax
  8033ff:	39 c2                	cmp    %eax,%edx
  803401:	74 ae                	je     8033b1 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803403:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803407:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80340b:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80340f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803413:	8b 00                	mov    (%rax),%eax
  803415:	99                   	cltd   
  803416:	c1 ea 1b             	shr    $0x1b,%edx
  803419:	01 d0                	add    %edx,%eax
  80341b:	83 e0 1f             	and    $0x1f,%eax
  80341e:	29 d0                	sub    %edx,%eax
  803420:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803424:	48 98                	cltq   
  803426:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80342b:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80342d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803431:	8b 00                	mov    (%rax),%eax
  803433:	8d 50 01             	lea    0x1(%rax),%edx
  803436:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80343a:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80343c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803441:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803445:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803449:	0f 82 60 ff ff ff    	jb     8033af <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80344f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803453:	c9                   	leaveq 
  803454:	c3                   	retq   

0000000000803455 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803455:	55                   	push   %rbp
  803456:	48 89 e5             	mov    %rsp,%rbp
  803459:	48 83 ec 40          	sub    $0x40,%rsp
  80345d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803461:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803465:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803469:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80346d:	48 89 c7             	mov    %rax,%rdi
  803470:	48 b8 e1 1f 80 00 00 	movabs $0x801fe1,%rax
  803477:	00 00 00 
  80347a:	ff d0                	callq  *%rax
  80347c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803480:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803484:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803488:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80348f:	00 
  803490:	e9 8e 00 00 00       	jmpq   803523 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803495:	eb 31                	jmp    8034c8 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803497:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80349b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80349f:	48 89 d6             	mov    %rdx,%rsi
  8034a2:	48 89 c7             	mov    %rax,%rdi
  8034a5:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  8034ac:	00 00 00 
  8034af:	ff d0                	callq  *%rax
  8034b1:	85 c0                	test   %eax,%eax
  8034b3:	74 07                	je     8034bc <devpipe_write+0x67>
				return 0;
  8034b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ba:	eb 79                	jmp    803535 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8034bc:	48 b8 2e 1a 80 00 00 	movabs $0x801a2e,%rax
  8034c3:	00 00 00 
  8034c6:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8034c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034cc:	8b 40 04             	mov    0x4(%rax),%eax
  8034cf:	48 63 d0             	movslq %eax,%rdx
  8034d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034d6:	8b 00                	mov    (%rax),%eax
  8034d8:	48 98                	cltq   
  8034da:	48 83 c0 20          	add    $0x20,%rax
  8034de:	48 39 c2             	cmp    %rax,%rdx
  8034e1:	73 b4                	jae    803497 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8034e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e7:	8b 40 04             	mov    0x4(%rax),%eax
  8034ea:	99                   	cltd   
  8034eb:	c1 ea 1b             	shr    $0x1b,%edx
  8034ee:	01 d0                	add    %edx,%eax
  8034f0:	83 e0 1f             	and    $0x1f,%eax
  8034f3:	29 d0                	sub    %edx,%eax
  8034f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8034f9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8034fd:	48 01 ca             	add    %rcx,%rdx
  803500:	0f b6 0a             	movzbl (%rdx),%ecx
  803503:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803507:	48 98                	cltq   
  803509:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80350d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803511:	8b 40 04             	mov    0x4(%rax),%eax
  803514:	8d 50 01             	lea    0x1(%rax),%edx
  803517:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80351b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80351e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803523:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803527:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80352b:	0f 82 64 ff ff ff    	jb     803495 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803531:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803535:	c9                   	leaveq 
  803536:	c3                   	retq   

0000000000803537 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803537:	55                   	push   %rbp
  803538:	48 89 e5             	mov    %rsp,%rbp
  80353b:	48 83 ec 20          	sub    $0x20,%rsp
  80353f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803543:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803547:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80354b:	48 89 c7             	mov    %rax,%rdi
  80354e:	48 b8 e1 1f 80 00 00 	movabs $0x801fe1,%rax
  803555:	00 00 00 
  803558:	ff d0                	callq  *%rax
  80355a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80355e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803562:	48 be 06 42 80 00 00 	movabs $0x804206,%rsi
  803569:	00 00 00 
  80356c:	48 89 c7             	mov    %rax,%rdi
  80356f:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  803576:	00 00 00 
  803579:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80357b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80357f:	8b 50 04             	mov    0x4(%rax),%edx
  803582:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803586:	8b 00                	mov    (%rax),%eax
  803588:	29 c2                	sub    %eax,%edx
  80358a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80358e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803594:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803598:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80359f:	00 00 00 
	stat->st_dev = &devpipe;
  8035a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035a6:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8035ad:	00 00 00 
  8035b0:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8035b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035bc:	c9                   	leaveq 
  8035bd:	c3                   	retq   

00000000008035be <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8035be:	55                   	push   %rbp
  8035bf:	48 89 e5             	mov    %rsp,%rbp
  8035c2:	48 83 ec 10          	sub    $0x10,%rsp
  8035c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8035ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ce:	48 89 c6             	mov    %rax,%rsi
  8035d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8035d6:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  8035dd:	00 00 00 
  8035e0:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8035e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035e6:	48 89 c7             	mov    %rax,%rdi
  8035e9:	48 b8 e1 1f 80 00 00 	movabs $0x801fe1,%rax
  8035f0:	00 00 00 
  8035f3:	ff d0                	callq  *%rax
  8035f5:	48 89 c6             	mov    %rax,%rsi
  8035f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8035fd:	48 b8 17 1b 80 00 00 	movabs $0x801b17,%rax
  803604:	00 00 00 
  803607:	ff d0                	callq  *%rax
}
  803609:	c9                   	leaveq 
  80360a:	c3                   	retq   

000000000080360b <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80360b:	55                   	push   %rbp
  80360c:	48 89 e5             	mov    %rsp,%rbp
  80360f:	48 83 ec 20          	sub    $0x20,%rsp
  803613:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803616:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803619:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80361c:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803620:	be 01 00 00 00       	mov    $0x1,%esi
  803625:	48 89 c7             	mov    %rax,%rdi
  803628:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  80362f:	00 00 00 
  803632:	ff d0                	callq  *%rax
}
  803634:	c9                   	leaveq 
  803635:	c3                   	retq   

0000000000803636 <getchar>:

int
getchar(void)
{
  803636:	55                   	push   %rbp
  803637:	48 89 e5             	mov    %rsp,%rbp
  80363a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80363e:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803642:	ba 01 00 00 00       	mov    $0x1,%edx
  803647:	48 89 c6             	mov    %rax,%rsi
  80364a:	bf 00 00 00 00       	mov    $0x0,%edi
  80364f:	48 b8 d6 24 80 00 00 	movabs $0x8024d6,%rax
  803656:	00 00 00 
  803659:	ff d0                	callq  *%rax
  80365b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80365e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803662:	79 05                	jns    803669 <getchar+0x33>
		return r;
  803664:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803667:	eb 14                	jmp    80367d <getchar+0x47>
	if (r < 1)
  803669:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80366d:	7f 07                	jg     803676 <getchar+0x40>
		return -E_EOF;
  80366f:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803674:	eb 07                	jmp    80367d <getchar+0x47>
	return c;
  803676:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80367a:	0f b6 c0             	movzbl %al,%eax
}
  80367d:	c9                   	leaveq 
  80367e:	c3                   	retq   

000000000080367f <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80367f:	55                   	push   %rbp
  803680:	48 89 e5             	mov    %rsp,%rbp
  803683:	48 83 ec 20          	sub    $0x20,%rsp
  803687:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80368a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80368e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803691:	48 89 d6             	mov    %rdx,%rsi
  803694:	89 c7                	mov    %eax,%edi
  803696:	48 b8 a4 20 80 00 00 	movabs $0x8020a4,%rax
  80369d:	00 00 00 
  8036a0:	ff d0                	callq  *%rax
  8036a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a9:	79 05                	jns    8036b0 <iscons+0x31>
		return r;
  8036ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ae:	eb 1a                	jmp    8036ca <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8036b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b4:	8b 10                	mov    (%rax),%edx
  8036b6:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8036bd:	00 00 00 
  8036c0:	8b 00                	mov    (%rax),%eax
  8036c2:	39 c2                	cmp    %eax,%edx
  8036c4:	0f 94 c0             	sete   %al
  8036c7:	0f b6 c0             	movzbl %al,%eax
}
  8036ca:	c9                   	leaveq 
  8036cb:	c3                   	retq   

00000000008036cc <opencons>:

int
opencons(void)
{
  8036cc:	55                   	push   %rbp
  8036cd:	48 89 e5             	mov    %rsp,%rbp
  8036d0:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8036d4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8036d8:	48 89 c7             	mov    %rax,%rdi
  8036db:	48 b8 0c 20 80 00 00 	movabs $0x80200c,%rax
  8036e2:	00 00 00 
  8036e5:	ff d0                	callq  *%rax
  8036e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ee:	79 05                	jns    8036f5 <opencons+0x29>
		return r;
  8036f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f3:	eb 5b                	jmp    803750 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8036f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f9:	ba 07 04 00 00       	mov    $0x407,%edx
  8036fe:	48 89 c6             	mov    %rax,%rsi
  803701:	bf 00 00 00 00       	mov    $0x0,%edi
  803706:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  80370d:	00 00 00 
  803710:	ff d0                	callq  *%rax
  803712:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803715:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803719:	79 05                	jns    803720 <opencons+0x54>
		return r;
  80371b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80371e:	eb 30                	jmp    803750 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803720:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803724:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  80372b:	00 00 00 
  80372e:	8b 12                	mov    (%rdx),%edx
  803730:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803732:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803736:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80373d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803741:	48 89 c7             	mov    %rax,%rdi
  803744:	48 b8 be 1f 80 00 00 	movabs $0x801fbe,%rax
  80374b:	00 00 00 
  80374e:	ff d0                	callq  *%rax
}
  803750:	c9                   	leaveq 
  803751:	c3                   	retq   

0000000000803752 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803752:	55                   	push   %rbp
  803753:	48 89 e5             	mov    %rsp,%rbp
  803756:	48 83 ec 30          	sub    $0x30,%rsp
  80375a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80375e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803762:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803766:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80376b:	75 07                	jne    803774 <devcons_read+0x22>
		return 0;
  80376d:	b8 00 00 00 00       	mov    $0x0,%eax
  803772:	eb 4b                	jmp    8037bf <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803774:	eb 0c                	jmp    803782 <devcons_read+0x30>
		sys_yield();
  803776:	48 b8 2e 1a 80 00 00 	movabs $0x801a2e,%rax
  80377d:	00 00 00 
  803780:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803782:	48 b8 6e 19 80 00 00 	movabs $0x80196e,%rax
  803789:	00 00 00 
  80378c:	ff d0                	callq  *%rax
  80378e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803791:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803795:	74 df                	je     803776 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803797:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80379b:	79 05                	jns    8037a2 <devcons_read+0x50>
		return c;
  80379d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a0:	eb 1d                	jmp    8037bf <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8037a2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8037a6:	75 07                	jne    8037af <devcons_read+0x5d>
		return 0;
  8037a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ad:	eb 10                	jmp    8037bf <devcons_read+0x6d>
	*(char*)vbuf = c;
  8037af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b2:	89 c2                	mov    %eax,%edx
  8037b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037b8:	88 10                	mov    %dl,(%rax)
	return 1;
  8037ba:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8037bf:	c9                   	leaveq 
  8037c0:	c3                   	retq   

00000000008037c1 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8037c1:	55                   	push   %rbp
  8037c2:	48 89 e5             	mov    %rsp,%rbp
  8037c5:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8037cc:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8037d3:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8037da:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8037e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8037e8:	eb 76                	jmp    803860 <devcons_write+0x9f>
		m = n - tot;
  8037ea:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8037f1:	89 c2                	mov    %eax,%edx
  8037f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f6:	29 c2                	sub    %eax,%edx
  8037f8:	89 d0                	mov    %edx,%eax
  8037fa:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8037fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803800:	83 f8 7f             	cmp    $0x7f,%eax
  803803:	76 07                	jbe    80380c <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803805:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80380c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80380f:	48 63 d0             	movslq %eax,%rdx
  803812:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803815:	48 63 c8             	movslq %eax,%rcx
  803818:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80381f:	48 01 c1             	add    %rax,%rcx
  803822:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803829:	48 89 ce             	mov    %rcx,%rsi
  80382c:	48 89 c7             	mov    %rax,%rdi
  80382f:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  803836:	00 00 00 
  803839:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80383b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80383e:	48 63 d0             	movslq %eax,%rdx
  803841:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803848:	48 89 d6             	mov    %rdx,%rsi
  80384b:	48 89 c7             	mov    %rax,%rdi
  80384e:	48 b8 24 19 80 00 00 	movabs $0x801924,%rax
  803855:	00 00 00 
  803858:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80385a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80385d:	01 45 fc             	add    %eax,-0x4(%rbp)
  803860:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803863:	48 98                	cltq   
  803865:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80386c:	0f 82 78 ff ff ff    	jb     8037ea <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803872:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803875:	c9                   	leaveq 
  803876:	c3                   	retq   

0000000000803877 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803877:	55                   	push   %rbp
  803878:	48 89 e5             	mov    %rsp,%rbp
  80387b:	48 83 ec 08          	sub    $0x8,%rsp
  80387f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803883:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803888:	c9                   	leaveq 
  803889:	c3                   	retq   

000000000080388a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80388a:	55                   	push   %rbp
  80388b:	48 89 e5             	mov    %rsp,%rbp
  80388e:	48 83 ec 10          	sub    $0x10,%rsp
  803892:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803896:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80389a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389e:	48 be 12 42 80 00 00 	movabs $0x804212,%rsi
  8038a5:	00 00 00 
  8038a8:	48 89 c7             	mov    %rax,%rdi
  8038ab:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  8038b2:	00 00 00 
  8038b5:	ff d0                	callq  *%rax
	return 0;
  8038b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038bc:	c9                   	leaveq 
  8038bd:	c3                   	retq   

00000000008038be <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8038be:	55                   	push   %rbp
  8038bf:	48 89 e5             	mov    %rsp,%rbp
  8038c2:	53                   	push   %rbx
  8038c3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8038ca:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8038d1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8038d7:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8038de:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8038e5:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8038ec:	84 c0                	test   %al,%al
  8038ee:	74 23                	je     803913 <_panic+0x55>
  8038f0:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8038f7:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8038fb:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8038ff:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803903:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803907:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80390b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80390f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803913:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80391a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803921:	00 00 00 
  803924:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80392b:	00 00 00 
  80392e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803932:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803939:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803940:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803947:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80394e:	00 00 00 
  803951:	48 8b 18             	mov    (%rax),%rbx
  803954:	48 b8 f0 19 80 00 00 	movabs $0x8019f0,%rax
  80395b:	00 00 00 
  80395e:	ff d0                	callq  *%rax
  803960:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803966:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80396d:	41 89 c8             	mov    %ecx,%r8d
  803970:	48 89 d1             	mov    %rdx,%rcx
  803973:	48 89 da             	mov    %rbx,%rdx
  803976:	89 c6                	mov    %eax,%esi
  803978:	48 bf 20 42 80 00 00 	movabs $0x804220,%rdi
  80397f:	00 00 00 
  803982:	b8 00 00 00 00       	mov    $0x0,%eax
  803987:	49 b9 95 03 80 00 00 	movabs $0x800395,%r9
  80398e:	00 00 00 
  803991:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803994:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80399b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8039a2:	48 89 d6             	mov    %rdx,%rsi
  8039a5:	48 89 c7             	mov    %rax,%rdi
  8039a8:	48 b8 e9 02 80 00 00 	movabs $0x8002e9,%rax
  8039af:	00 00 00 
  8039b2:	ff d0                	callq  *%rax
	cprintf("\n");
  8039b4:	48 bf 43 42 80 00 00 	movabs $0x804243,%rdi
  8039bb:	00 00 00 
  8039be:	b8 00 00 00 00       	mov    $0x0,%eax
  8039c3:	48 ba 95 03 80 00 00 	movabs $0x800395,%rdx
  8039ca:	00 00 00 
  8039cd:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8039cf:	cc                   	int3   
  8039d0:	eb fd                	jmp    8039cf <_panic+0x111>

00000000008039d2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8039d2:	55                   	push   %rbp
  8039d3:	48 89 e5             	mov    %rsp,%rbp
  8039d6:	48 83 ec 30          	sub    $0x30,%rsp
  8039da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8039e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8039ee:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8039f3:	75 0e                	jne    803a03 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  8039f5:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8039fc:	00 00 00 
  8039ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  803a03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a07:	48 89 c7             	mov    %rax,%rdi
  803a0a:	48 b8 95 1c 80 00 00 	movabs $0x801c95,%rax
  803a11:	00 00 00 
  803a14:	ff d0                	callq  *%rax
  803a16:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803a19:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803a1d:	79 27                	jns    803a46 <ipc_recv+0x74>
		if (from_env_store != NULL)
  803a1f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803a24:	74 0a                	je     803a30 <ipc_recv+0x5e>
			*from_env_store = 0;
  803a26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a2a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  803a30:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a35:	74 0a                	je     803a41 <ipc_recv+0x6f>
			*perm_store = 0;
  803a37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a3b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803a41:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a44:	eb 53                	jmp    803a99 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  803a46:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803a4b:	74 19                	je     803a66 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  803a4d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803a54:	00 00 00 
  803a57:	48 8b 00             	mov    (%rax),%rax
  803a5a:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803a60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a64:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  803a66:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a6b:	74 19                	je     803a86 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  803a6d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803a74:	00 00 00 
  803a77:	48 8b 00             	mov    (%rax),%rax
  803a7a:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803a80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a84:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  803a86:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803a8d:	00 00 00 
  803a90:	48 8b 00             	mov    (%rax),%rax
  803a93:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  803a99:	c9                   	leaveq 
  803a9a:	c3                   	retq   

0000000000803a9b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a9b:	55                   	push   %rbp
  803a9c:	48 89 e5             	mov    %rsp,%rbp
  803a9f:	48 83 ec 30          	sub    $0x30,%rsp
  803aa3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803aa6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803aa9:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803aad:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803ab0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ab4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803ab8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803abd:	75 10                	jne    803acf <ipc_send+0x34>
		page = (void *)KERNBASE;
  803abf:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803ac6:	00 00 00 
  803ac9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803acd:	eb 0e                	jmp    803add <ipc_send+0x42>
  803acf:	eb 0c                	jmp    803add <ipc_send+0x42>
		sys_yield();
  803ad1:	48 b8 2e 1a 80 00 00 	movabs $0x801a2e,%rax
  803ad8:	00 00 00 
  803adb:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  803add:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803ae0:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803ae3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803ae7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803aea:	89 c7                	mov    %eax,%edi
  803aec:	48 b8 40 1c 80 00 00 	movabs $0x801c40,%rax
  803af3:	00 00 00 
  803af6:	ff d0                	callq  *%rax
  803af8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803afb:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  803aff:	74 d0                	je     803ad1 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  803b01:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803b05:	74 2a                	je     803b31 <ipc_send+0x96>
		panic("error on ipc send procedure");
  803b07:	48 ba 45 42 80 00 00 	movabs $0x804245,%rdx
  803b0e:	00 00 00 
  803b11:	be 49 00 00 00       	mov    $0x49,%esi
  803b16:	48 bf 61 42 80 00 00 	movabs $0x804261,%rdi
  803b1d:	00 00 00 
  803b20:	b8 00 00 00 00       	mov    $0x0,%eax
  803b25:	48 b9 be 38 80 00 00 	movabs $0x8038be,%rcx
  803b2c:	00 00 00 
  803b2f:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  803b31:	c9                   	leaveq 
  803b32:	c3                   	retq   

0000000000803b33 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803b33:	55                   	push   %rbp
  803b34:	48 89 e5             	mov    %rsp,%rbp
  803b37:	48 83 ec 14          	sub    $0x14,%rsp
  803b3b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803b3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b45:	eb 5e                	jmp    803ba5 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803b47:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b4e:	00 00 00 
  803b51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b54:	48 63 d0             	movslq %eax,%rdx
  803b57:	48 89 d0             	mov    %rdx,%rax
  803b5a:	48 c1 e0 03          	shl    $0x3,%rax
  803b5e:	48 01 d0             	add    %rdx,%rax
  803b61:	48 c1 e0 05          	shl    $0x5,%rax
  803b65:	48 01 c8             	add    %rcx,%rax
  803b68:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803b6e:	8b 00                	mov    (%rax),%eax
  803b70:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b73:	75 2c                	jne    803ba1 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803b75:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b7c:	00 00 00 
  803b7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b82:	48 63 d0             	movslq %eax,%rdx
  803b85:	48 89 d0             	mov    %rdx,%rax
  803b88:	48 c1 e0 03          	shl    $0x3,%rax
  803b8c:	48 01 d0             	add    %rdx,%rax
  803b8f:	48 c1 e0 05          	shl    $0x5,%rax
  803b93:	48 01 c8             	add    %rcx,%rax
  803b96:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803b9c:	8b 40 08             	mov    0x8(%rax),%eax
  803b9f:	eb 12                	jmp    803bb3 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803ba1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803ba5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803bac:	7e 99                	jle    803b47 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803bae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bb3:	c9                   	leaveq 
  803bb4:	c3                   	retq   

0000000000803bb5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803bb5:	55                   	push   %rbp
  803bb6:	48 89 e5             	mov    %rsp,%rbp
  803bb9:	48 83 ec 18          	sub    $0x18,%rsp
  803bbd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803bc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bc5:	48 c1 e8 15          	shr    $0x15,%rax
  803bc9:	48 89 c2             	mov    %rax,%rdx
  803bcc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803bd3:	01 00 00 
  803bd6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bda:	83 e0 01             	and    $0x1,%eax
  803bdd:	48 85 c0             	test   %rax,%rax
  803be0:	75 07                	jne    803be9 <pageref+0x34>
		return 0;
  803be2:	b8 00 00 00 00       	mov    $0x0,%eax
  803be7:	eb 53                	jmp    803c3c <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803be9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bed:	48 c1 e8 0c          	shr    $0xc,%rax
  803bf1:	48 89 c2             	mov    %rax,%rdx
  803bf4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803bfb:	01 00 00 
  803bfe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c02:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c0a:	83 e0 01             	and    $0x1,%eax
  803c0d:	48 85 c0             	test   %rax,%rax
  803c10:	75 07                	jne    803c19 <pageref+0x64>
		return 0;
  803c12:	b8 00 00 00 00       	mov    $0x0,%eax
  803c17:	eb 23                	jmp    803c3c <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c1d:	48 c1 e8 0c          	shr    $0xc,%rax
  803c21:	48 89 c2             	mov    %rax,%rdx
  803c24:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c2b:	00 00 00 
  803c2e:	48 c1 e2 04          	shl    $0x4,%rdx
  803c32:	48 01 d0             	add    %rdx,%rax
  803c35:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c39:	0f b7 c0             	movzwl %ax,%eax
}
  803c3c:	c9                   	leaveq 
  803c3d:	c3                   	retq   
