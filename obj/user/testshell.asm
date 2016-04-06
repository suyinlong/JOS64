
obj/user/testshell.debug:     file format elf64-x86-64


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
  80003c:	e8 f5 07 00 00       	callq  800836 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  800052:	bf 00 00 00 00       	mov    $0x0,%edi
  800057:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  80005e:	00 00 00 
  800061:	ff d0                	callq  *%rax
	close(1);
  800063:	bf 01 00 00 00       	mov    $0x1,%edi
  800068:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  80006f:	00 00 00 
  800072:	ff d0                	callq  *%rax
	opencons();
  800074:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
	opencons();
  800080:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  800087:	00 00 00 
  80008a:	ff d0                	callq  *%rax

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80008c:	be 00 00 00 00       	mov    $0x0,%esi
  800091:	48 bf a0 4c 80 00 00 	movabs $0x804ca0,%rdi
  800098:	00 00 00 
  80009b:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8000ae:	79 30                	jns    8000e0 <umain+0x9d>
		panic("open testshell.sh: %e", rfd);
  8000b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000b3:	89 c1                	mov    %eax,%ecx
  8000b5:	48 ba ad 4c 80 00 00 	movabs $0x804cad,%rdx
  8000bc:	00 00 00 
  8000bf:	be 13 00 00 00       	mov    $0x13,%esi
  8000c4:	48 bf c3 4c 80 00 00 	movabs $0x804cc3,%rdi
  8000cb:	00 00 00 
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  8000da:	00 00 00 
  8000dd:	41 ff d0             	callq  *%r8
	if ((wfd = pipe(pfds)) < 0)
  8000e0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8000e4:	48 89 c7             	mov    %rax,%rdi
  8000e7:	48 b8 d5 42 80 00 00 	movabs $0x8042d5,%rax
  8000ee:	00 00 00 
  8000f1:	ff d0                	callq  *%rax
  8000f3:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8000fa:	79 30                	jns    80012c <umain+0xe9>
		panic("pipe: %e", wfd);
  8000fc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ff:	89 c1                	mov    %eax,%ecx
  800101:	48 ba d4 4c 80 00 00 	movabs $0x804cd4,%rdx
  800108:	00 00 00 
  80010b:	be 15 00 00 00       	mov    $0x15,%esi
  800110:	48 bf c3 4c 80 00 00 	movabs $0x804cc3,%rdi
  800117:	00 00 00 
  80011a:	b8 00 00 00 00       	mov    $0x0,%eax
  80011f:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  800126:	00 00 00 
  800129:	41 ff d0             	callq  *%r8
	wfd = pfds[1];
  80012c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80012f:	89 45 f0             	mov    %eax,-0x10(%rbp)

	cprintf("running sh -x < testshell.sh | cat\n");
  800132:	48 bf e0 4c 80 00 00 	movabs $0x804ce0,%rdi
  800139:	00 00 00 
  80013c:	b8 00 00 00 00       	mov    $0x0,%eax
  800141:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  800148:	00 00 00 
  80014b:	ff d2                	callq  *%rdx
	if ((r = fork()) < 0)
  80014d:	48 b8 cf 26 80 00 00 	movabs $0x8026cf,%rax
  800154:	00 00 00 
  800157:	ff d0                	callq  *%rax
  800159:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80015c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800160:	79 30                	jns    800192 <umain+0x14f>
		panic("fork: %e", r);
  800162:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800165:	89 c1                	mov    %eax,%ecx
  800167:	48 ba 04 4d 80 00 00 	movabs $0x804d04,%rdx
  80016e:	00 00 00 
  800171:	be 1a 00 00 00       	mov    $0x1a,%esi
  800176:	48 bf c3 4c 80 00 00 	movabs $0x804cc3,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  80018c:	00 00 00 
  80018f:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800192:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800196:	0f 85 fb 00 00 00    	jne    800297 <umain+0x254>
		dup(rfd, 0);
  80019c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	89 c7                	mov    %eax,%edi
  8001a6:	48 b8 d8 2c 80 00 00 	movabs $0x802cd8,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
		dup(wfd, 1);
  8001b2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001b5:	be 01 00 00 00       	mov    $0x1,%esi
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 d8 2c 80 00 00 	movabs $0x802cd8,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		close(rfd);
  8001c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
		close(wfd);
  8001d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
		if ((r = spawnl("/bin/sh", "sh", "-x", 0)) < 0)
  8001ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ef:	48 ba 0d 4d 80 00 00 	movabs $0x804d0d,%rdx
  8001f6:	00 00 00 
  8001f9:	48 be 10 4d 80 00 00 	movabs $0x804d10,%rsi
  800200:	00 00 00 
  800203:	48 bf 13 4d 80 00 00 	movabs $0x804d13,%rdi
  80020a:	00 00 00 
  80020d:	b8 00 00 00 00       	mov    $0x0,%eax
  800212:	49 b8 44 3a 80 00 00 	movabs $0x803a44,%r8
  800219:	00 00 00 
  80021c:	41 ff d0             	callq  *%r8
  80021f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800222:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800226:	79 30                	jns    800258 <umain+0x215>
			panic("spawn: %e", r);
  800228:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80022b:	89 c1                	mov    %eax,%ecx
  80022d:	48 ba 1b 4d 80 00 00 	movabs $0x804d1b,%rdx
  800234:	00 00 00 
  800237:	be 21 00 00 00       	mov    $0x21,%esi
  80023c:	48 bf c3 4c 80 00 00 	movabs $0x804cc3,%rdi
  800243:	00 00 00 
  800246:	b8 00 00 00 00       	mov    $0x0,%eax
  80024b:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  800252:	00 00 00 
  800255:	41 ff d0             	callq  *%r8
		close(0);
  800258:	bf 00 00 00 00       	mov    $0x0,%edi
  80025d:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
		close(1);
  800269:	bf 01 00 00 00       	mov    $0x1,%edi
  80026e:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  800275:	00 00 00 
  800278:	ff d0                	callq  *%rax
		wait(r);
  80027a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027d:	89 c7                	mov    %eax,%edi
  80027f:	48 b8 9e 48 80 00 00 	movabs $0x80489e,%rax
  800286:	00 00 00 
  800289:	ff d0                	callq  *%rax
		exit();
  80028b:	48 b8 c6 08 80 00 00 	movabs $0x8008c6,%rax
  800292:	00 00 00 
  800295:	ff d0                	callq  *%rax
	}
	close(rfd);
  800297:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029a:	89 c7                	mov    %eax,%edi
  80029c:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
	close(wfd);
  8002a8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002ab:	89 c7                	mov    %eax,%edi
  8002ad:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  8002b4:	00 00 00 
  8002b7:	ff d0                	callq  *%rax

	rfd = pfds[0];
  8002b9:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002bc:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002bf:	be 00 00 00 00       	mov    $0x0,%esi
  8002c4:	48 bf 25 4d 80 00 00 	movabs $0x804d25,%rdi
  8002cb:	00 00 00 
  8002ce:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  8002d5:	00 00 00 
  8002d8:	ff d0                	callq  *%rax
  8002da:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e1:	79 30                	jns    800313 <umain+0x2d0>
		panic("open testshell.key for reading: %e", kfd);
  8002e3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002e6:	89 c1                	mov    %eax,%ecx
  8002e8:	48 ba 38 4d 80 00 00 	movabs $0x804d38,%rdx
  8002ef:	00 00 00 
  8002f2:	be 2c 00 00 00       	mov    $0x2c,%esi
  8002f7:	48 bf c3 4c 80 00 00 	movabs $0x804cc3,%rdi
  8002fe:	00 00 00 
  800301:	b8 00 00 00 00       	mov    $0x0,%eax
  800306:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  80030d:	00 00 00 
  800310:	41 ff d0             	callq  *%r8

	nloff = 0;
  800313:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (off=0;; off++) {
  80031a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		n1 = read(rfd, &c1, 1);
  800321:	48 8d 4d df          	lea    -0x21(%rbp),%rcx
  800325:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800328:	ba 01 00 00 00       	mov    $0x1,%edx
  80032d:	48 89 ce             	mov    %rcx,%rsi
  800330:	89 c7                	mov    %eax,%edi
  800332:	48 b8 81 2e 80 00 00 	movabs $0x802e81,%rax
  800339:	00 00 00 
  80033c:	ff d0                	callq  *%rax
  80033e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		n2 = read(kfd, &c2, 1);
  800341:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
  800345:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800348:	ba 01 00 00 00       	mov    $0x1,%edx
  80034d:	48 89 ce             	mov    %rcx,%rsi
  800350:	89 c7                	mov    %eax,%edi
  800352:	48 b8 81 2e 80 00 00 	movabs $0x802e81,%rax
  800359:	00 00 00 
  80035c:	ff d0                	callq  *%rax
  80035e:	89 45 e0             	mov    %eax,-0x20(%rbp)
		if (n1 < 0)
  800361:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800365:	79 30                	jns    800397 <umain+0x354>
			panic("reading testshell.out: %e", n1);
  800367:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036a:	89 c1                	mov    %eax,%ecx
  80036c:	48 ba 5b 4d 80 00 00 	movabs $0x804d5b,%rdx
  800373:	00 00 00 
  800376:	be 33 00 00 00       	mov    $0x33,%esi
  80037b:	48 bf c3 4c 80 00 00 	movabs $0x804cc3,%rdi
  800382:	00 00 00 
  800385:	b8 00 00 00 00       	mov    $0x0,%eax
  80038a:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  800391:	00 00 00 
  800394:	41 ff d0             	callq  *%r8
		if (n2 < 0)
  800397:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80039b:	79 30                	jns    8003cd <umain+0x38a>
			panic("reading testshell.key: %e", n2);
  80039d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003a0:	89 c1                	mov    %eax,%ecx
  8003a2:	48 ba 75 4d 80 00 00 	movabs $0x804d75,%rdx
  8003a9:	00 00 00 
  8003ac:	be 35 00 00 00       	mov    $0x35,%esi
  8003b1:	48 bf c3 4c 80 00 00 	movabs $0x804cc3,%rdi
  8003b8:	00 00 00 
  8003bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c0:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  8003c7:	00 00 00 
  8003ca:	41 ff d0             	callq  *%r8
		if (n1 == 0 && n2 == 0)
  8003cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8003d1:	75 08                	jne    8003db <umain+0x398>
  8003d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003d7:	75 02                	jne    8003db <umain+0x398>
			break;
  8003d9:	eb 4b                	jmp    800426 <umain+0x3e3>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8003db:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003df:	75 12                	jne    8003f3 <umain+0x3b0>
  8003e1:	83 7d e0 01          	cmpl   $0x1,-0x20(%rbp)
  8003e5:	75 0c                	jne    8003f3 <umain+0x3b0>
  8003e7:	0f b6 55 df          	movzbl -0x21(%rbp),%edx
  8003eb:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  8003ef:	38 c2                	cmp    %al,%dl
  8003f1:	74 19                	je     80040c <umain+0x3c9>
			wrong(rfd, kfd, nloff);
  8003f3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8003f6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8003f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8003fc:	89 ce                	mov    %ecx,%esi
  8003fe:	89 c7                	mov    %eax,%edi
  800400:	48 b8 44 04 80 00 00 	movabs $0x800444,%rax
  800407:	00 00 00 
  80040a:	ff d0                	callq  *%rax
		if (c1 == '\n')
  80040c:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  800410:	3c 0a                	cmp    $0xa,%al
  800412:	75 09                	jne    80041d <umain+0x3da>
			nloff = off+1;
  800414:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800417:	83 c0 01             	add    $0x1,%eax
  80041a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	rfd = pfds[0];
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
  80041d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
			wrong(rfd, kfd, nloff);
		if (c1 == '\n')
			nloff = off+1;
	}
  800421:	e9 fb fe ff ff       	jmpq   800321 <umain+0x2de>
	cprintf("shell ran correctly\n");
  800426:	48 bf 8f 4d 80 00 00 	movabs $0x804d8f,%rdi
  80042d:	00 00 00 
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
  800435:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  80043c:	00 00 00 
  80043f:	ff d2                	callq  *%rdx
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800441:	cc                   	int3   

	breakpoint();
}
  800442:	c9                   	leaveq 
  800443:	c3                   	retq   

0000000000800444 <wrong>:

void
wrong(int rfd, int kfd, int off)
{
  800444:	55                   	push   %rbp
  800445:	48 89 e5             	mov    %rsp,%rbp
  800448:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  80044c:	89 7d 8c             	mov    %edi,-0x74(%rbp)
  80044f:	89 75 88             	mov    %esi,-0x78(%rbp)
  800452:	89 55 84             	mov    %edx,-0x7c(%rbp)
	char buf[100];
	int n;

	seek(rfd, off);
  800455:	8b 55 84             	mov    -0x7c(%rbp),%edx
  800458:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80045b:	89 d6                	mov    %edx,%esi
  80045d:	89 c7                	mov    %eax,%edi
  80045f:	48 b8 9f 30 80 00 00 	movabs $0x80309f,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
	seek(kfd, off);
  80046b:	8b 55 84             	mov    -0x7c(%rbp),%edx
  80046e:	8b 45 88             	mov    -0x78(%rbp),%eax
  800471:	89 d6                	mov    %edx,%esi
  800473:	89 c7                	mov    %eax,%edi
  800475:	48 b8 9f 30 80 00 00 	movabs $0x80309f,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax

	cprintf("shell produced incorrect output.\n");
  800481:	48 bf a8 4d 80 00 00 	movabs $0x804da8,%rdi
  800488:	00 00 00 
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  800497:	00 00 00 
  80049a:	ff d2                	callq  *%rdx
	cprintf("expected:\n===\n");
  80049c:	48 bf ca 4d 80 00 00 	movabs $0x804dca,%rdi
  8004a3:	00 00 00 
  8004a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ab:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  8004b2:	00 00 00 
  8004b5:	ff d2                	callq  *%rdx
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004b7:	eb 1c                	jmp    8004d5 <wrong+0x91>
		sys_cputs(buf, n);
  8004b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004bc:	48 63 d0             	movslq %eax,%rdx
  8004bf:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004c3:	48 89 d6             	mov    %rdx,%rsi
  8004c6:	48 89 c7             	mov    %rax,%rdi
  8004c9:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004d5:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  8004d9:	8b 45 88             	mov    -0x78(%rbp),%eax
  8004dc:	ba 63 00 00 00       	mov    $0x63,%edx
  8004e1:	48 89 ce             	mov    %rcx,%rsi
  8004e4:	89 c7                	mov    %eax,%edi
  8004e6:	48 b8 81 2e 80 00 00 	movabs $0x802e81,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
  8004f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004f9:	7f be                	jg     8004b9 <wrong+0x75>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8004fb:	48 bf d9 4d 80 00 00 	movabs $0x804dd9,%rdi
  800502:	00 00 00 
  800505:	b8 00 00 00 00       	mov    $0x0,%eax
  80050a:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  800511:	00 00 00 
  800514:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800516:	eb 1c                	jmp    800534 <wrong+0xf0>
		sys_cputs(buf, n);
  800518:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80051b:	48 63 d0             	movslq %eax,%rdx
  80051e:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800522:	48 89 d6             	mov    %rdx,%rsi
  800525:	48 89 c7             	mov    %rax,%rdi
  800528:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  80052f:	00 00 00 
  800532:	ff d0                	callq  *%rax
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800534:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  800538:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80053b:	ba 63 00 00 00       	mov    $0x63,%edx
  800540:	48 89 ce             	mov    %rcx,%rsi
  800543:	89 c7                	mov    %eax,%edi
  800545:	48 b8 81 2e 80 00 00 	movabs $0x802e81,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
  800551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800558:	7f be                	jg     800518 <wrong+0xd4>
		sys_cputs(buf, n);
	cprintf("===\n");
  80055a:	48 bf e7 4d 80 00 00 	movabs $0x804de7,%rdi
  800561:	00 00 00 
  800564:	b8 00 00 00 00       	mov    $0x0,%eax
  800569:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  800570:	00 00 00 
  800573:	ff d2                	callq  *%rdx
	exit();
  800575:	48 b8 c6 08 80 00 00 	movabs $0x8008c6,%rax
  80057c:	00 00 00 
  80057f:	ff d0                	callq  *%rax
}
  800581:	c9                   	leaveq 
  800582:	c3                   	retq   

0000000000800583 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800583:	55                   	push   %rbp
  800584:	48 89 e5             	mov    %rsp,%rbp
  800587:	48 83 ec 20          	sub    $0x20,%rsp
  80058b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80058e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800591:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800594:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800598:	be 01 00 00 00       	mov    $0x1,%esi
  80059d:	48 89 c7             	mov    %rax,%rdi
  8005a0:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  8005a7:	00 00 00 
  8005aa:	ff d0                	callq  *%rax
}
  8005ac:	c9                   	leaveq 
  8005ad:	c3                   	retq   

00000000008005ae <getchar>:

int
getchar(void)
{
  8005ae:	55                   	push   %rbp
  8005af:	48 89 e5             	mov    %rsp,%rbp
  8005b2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8005b6:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8005ba:	ba 01 00 00 00       	mov    $0x1,%edx
  8005bf:	48 89 c6             	mov    %rax,%rsi
  8005c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8005c7:	48 b8 81 2e 80 00 00 	movabs $0x802e81,%rax
  8005ce:	00 00 00 
  8005d1:	ff d0                	callq  *%rax
  8005d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8005d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005da:	79 05                	jns    8005e1 <getchar+0x33>
		return r;
  8005dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005df:	eb 14                	jmp    8005f5 <getchar+0x47>
	if (r < 1)
  8005e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005e5:	7f 07                	jg     8005ee <getchar+0x40>
		return -E_EOF;
  8005e7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8005ec:	eb 07                	jmp    8005f5 <getchar+0x47>
	return c;
  8005ee:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8005f2:	0f b6 c0             	movzbl %al,%eax
}
  8005f5:	c9                   	leaveq 
  8005f6:	c3                   	retq   

00000000008005f7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8005f7:	55                   	push   %rbp
  8005f8:	48 89 e5             	mov    %rsp,%rbp
  8005fb:	48 83 ec 20          	sub    $0x20,%rsp
  8005ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800602:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800606:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800609:	48 89 d6             	mov    %rdx,%rsi
  80060c:	89 c7                	mov    %eax,%edi
  80060e:	48 b8 4f 2a 80 00 00 	movabs $0x802a4f,%rax
  800615:	00 00 00 
  800618:	ff d0                	callq  *%rax
  80061a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80061d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800621:	79 05                	jns    800628 <iscons+0x31>
		return r;
  800623:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800626:	eb 1a                	jmp    800642 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062c:	8b 10                	mov    (%rax),%edx
  80062e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800635:	00 00 00 
  800638:	8b 00                	mov    (%rax),%eax
  80063a:	39 c2                	cmp    %eax,%edx
  80063c:	0f 94 c0             	sete   %al
  80063f:	0f b6 c0             	movzbl %al,%eax
}
  800642:	c9                   	leaveq 
  800643:	c3                   	retq   

0000000000800644 <opencons>:

int
opencons(void)
{
  800644:	55                   	push   %rbp
  800645:	48 89 e5             	mov    %rsp,%rbp
  800648:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80064c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800650:	48 89 c7             	mov    %rax,%rdi
  800653:	48 b8 b7 29 80 00 00 	movabs $0x8029b7,%rax
  80065a:	00 00 00 
  80065d:	ff d0                	callq  *%rax
  80065f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800662:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800666:	79 05                	jns    80066d <opencons+0x29>
		return r;
  800668:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80066b:	eb 5b                	jmp    8006c8 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80066d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800671:	ba 07 04 00 00       	mov    $0x407,%edx
  800676:	48 89 c6             	mov    %rax,%rsi
  800679:	bf 00 00 00 00       	mov    $0x0,%edi
  80067e:	48 b8 f9 21 80 00 00 	movabs $0x8021f9,%rax
  800685:	00 00 00 
  800688:	ff d0                	callq  *%rax
  80068a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80068d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800691:	79 05                	jns    800698 <opencons+0x54>
		return r;
  800693:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800696:	eb 30                	jmp    8006c8 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800698:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8006a3:	00 00 00 
  8006a6:	8b 12                	mov    (%rdx),%edx
  8006a8:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8006aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ae:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8006b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b9:	48 89 c7             	mov    %rax,%rdi
  8006bc:	48 b8 69 29 80 00 00 	movabs $0x802969,%rax
  8006c3:	00 00 00 
  8006c6:	ff d0                	callq  *%rax
}
  8006c8:	c9                   	leaveq 
  8006c9:	c3                   	retq   

00000000008006ca <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8006ca:	55                   	push   %rbp
  8006cb:	48 89 e5             	mov    %rsp,%rbp
  8006ce:	48 83 ec 30          	sub    $0x30,%rsp
  8006d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8006de:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8006e3:	75 07                	jne    8006ec <devcons_read+0x22>
		return 0;
  8006e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ea:	eb 4b                	jmp    800737 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8006ec:	eb 0c                	jmp    8006fa <devcons_read+0x30>
		sys_yield();
  8006ee:	48 b8 bb 21 80 00 00 	movabs $0x8021bb,%rax
  8006f5:	00 00 00 
  8006f8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8006fa:	48 b8 fb 20 80 00 00 	movabs $0x8020fb,%rax
  800701:	00 00 00 
  800704:	ff d0                	callq  *%rax
  800706:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800709:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80070d:	74 df                	je     8006ee <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80070f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800713:	79 05                	jns    80071a <devcons_read+0x50>
		return c;
  800715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800718:	eb 1d                	jmp    800737 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80071a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80071e:	75 07                	jne    800727 <devcons_read+0x5d>
		return 0;
  800720:	b8 00 00 00 00       	mov    $0x0,%eax
  800725:	eb 10                	jmp    800737 <devcons_read+0x6d>
	*(char*)vbuf = c;
  800727:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80072a:	89 c2                	mov    %eax,%edx
  80072c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800730:	88 10                	mov    %dl,(%rax)
	return 1;
  800732:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800737:	c9                   	leaveq 
  800738:	c3                   	retq   

0000000000800739 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800739:	55                   	push   %rbp
  80073a:	48 89 e5             	mov    %rsp,%rbp
  80073d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800744:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80074b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800752:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800759:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800760:	eb 76                	jmp    8007d8 <devcons_write+0x9f>
		m = n - tot;
  800762:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800769:	89 c2                	mov    %eax,%edx
  80076b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80076e:	29 c2                	sub    %eax,%edx
  800770:	89 d0                	mov    %edx,%eax
  800772:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  800775:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800778:	83 f8 7f             	cmp    $0x7f,%eax
  80077b:	76 07                	jbe    800784 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80077d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  800784:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800787:	48 63 d0             	movslq %eax,%rdx
  80078a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80078d:	48 63 c8             	movslq %eax,%rcx
  800790:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800797:	48 01 c1             	add    %rax,%rcx
  80079a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007a1:	48 89 ce             	mov    %rcx,%rsi
  8007a4:	48 89 c7             	mov    %rax,%rdi
  8007a7:	48 b8 ee 1b 80 00 00 	movabs $0x801bee,%rax
  8007ae:	00 00 00 
  8007b1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8007b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007b6:	48 63 d0             	movslq %eax,%rdx
  8007b9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007c0:	48 89 d6             	mov    %rdx,%rsi
  8007c3:	48 89 c7             	mov    %rax,%rdi
  8007c6:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  8007cd:	00 00 00 
  8007d0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8007d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007d5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8007d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007db:	48 98                	cltq   
  8007dd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8007e4:	0f 82 78 ff ff ff    	jb     800762 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8007ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007ed:	c9                   	leaveq 
  8007ee:	c3                   	retq   

00000000008007ef <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8007ef:	55                   	push   %rbp
  8007f0:	48 89 e5             	mov    %rsp,%rbp
  8007f3:	48 83 ec 08          	sub    $0x8,%rsp
  8007f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800800:	c9                   	leaveq 
  800801:	c3                   	retq   

0000000000800802 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800802:	55                   	push   %rbp
  800803:	48 89 e5             	mov    %rsp,%rbp
  800806:	48 83 ec 10          	sub    $0x10,%rsp
  80080a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80080e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800816:	48 be f1 4d 80 00 00 	movabs $0x804df1,%rsi
  80081d:	00 00 00 
  800820:	48 89 c7             	mov    %rax,%rdi
  800823:	48 b8 ca 18 80 00 00 	movabs $0x8018ca,%rax
  80082a:	00 00 00 
  80082d:	ff d0                	callq  *%rax
	return 0;
  80082f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800834:	c9                   	leaveq 
  800835:	c3                   	retq   

0000000000800836 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800836:	55                   	push   %rbp
  800837:	48 89 e5             	mov    %rsp,%rbp
  80083a:	48 83 ec 10          	sub    $0x10,%rsp
  80083e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800841:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800845:	48 b8 7d 21 80 00 00 	movabs $0x80217d,%rax
  80084c:	00 00 00 
  80084f:	ff d0                	callq  *%rax
  800851:	48 98                	cltq   
  800853:	25 ff 03 00 00       	and    $0x3ff,%eax
  800858:	48 89 c2             	mov    %rax,%rdx
  80085b:	48 89 d0             	mov    %rdx,%rax
  80085e:	48 c1 e0 03          	shl    $0x3,%rax
  800862:	48 01 d0             	add    %rdx,%rax
  800865:	48 c1 e0 05          	shl    $0x5,%rax
  800869:	48 89 c2             	mov    %rax,%rdx
  80086c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800873:	00 00 00 
  800876:	48 01 c2             	add    %rax,%rdx
  800879:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800880:	00 00 00 
  800883:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800886:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80088a:	7e 14                	jle    8008a0 <libmain+0x6a>
		binaryname = argv[0];
  80088c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800890:	48 8b 10             	mov    (%rax),%rdx
  800893:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
  80089a:	00 00 00 
  80089d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8008a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008a7:	48 89 d6             	mov    %rdx,%rsi
  8008aa:	89 c7                	mov    %eax,%edi
  8008ac:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8008b3:	00 00 00 
  8008b6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8008b8:	48 b8 c6 08 80 00 00 	movabs $0x8008c6,%rax
  8008bf:	00 00 00 
  8008c2:	ff d0                	callq  *%rax
}
  8008c4:	c9                   	leaveq 
  8008c5:	c3                   	retq   

00000000008008c6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008c6:	55                   	push   %rbp
  8008c7:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8008ca:	48 b8 aa 2c 80 00 00 	movabs $0x802caa,%rax
  8008d1:	00 00 00 
  8008d4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8008d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8008db:	48 b8 39 21 80 00 00 	movabs $0x802139,%rax
  8008e2:	00 00 00 
  8008e5:	ff d0                	callq  *%rax
}
  8008e7:	5d                   	pop    %rbp
  8008e8:	c3                   	retq   

00000000008008e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008e9:	55                   	push   %rbp
  8008ea:	48 89 e5             	mov    %rsp,%rbp
  8008ed:	53                   	push   %rbx
  8008ee:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8008f5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8008fc:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800902:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800909:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800910:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800917:	84 c0                	test   %al,%al
  800919:	74 23                	je     80093e <_panic+0x55>
  80091b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800922:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800926:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80092a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80092e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800932:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800936:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80093a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80093e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800945:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80094c:	00 00 00 
  80094f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800956:	00 00 00 
  800959:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80095d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800964:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80096b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800972:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
  800979:	00 00 00 
  80097c:	48 8b 18             	mov    (%rax),%rbx
  80097f:	48 b8 7d 21 80 00 00 	movabs $0x80217d,%rax
  800986:	00 00 00 
  800989:	ff d0                	callq  *%rax
  80098b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800991:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800998:	41 89 c8             	mov    %ecx,%r8d
  80099b:	48 89 d1             	mov    %rdx,%rcx
  80099e:	48 89 da             	mov    %rbx,%rdx
  8009a1:	89 c6                	mov    %eax,%esi
  8009a3:	48 bf 08 4e 80 00 00 	movabs $0x804e08,%rdi
  8009aa:	00 00 00 
  8009ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b2:	49 b9 22 0b 80 00 00 	movabs $0x800b22,%r9
  8009b9:	00 00 00 
  8009bc:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8009bf:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8009c6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8009cd:	48 89 d6             	mov    %rdx,%rsi
  8009d0:	48 89 c7             	mov    %rax,%rdi
  8009d3:	48 b8 76 0a 80 00 00 	movabs $0x800a76,%rax
  8009da:	00 00 00 
  8009dd:	ff d0                	callq  *%rax
	cprintf("\n");
  8009df:	48 bf 2b 4e 80 00 00 	movabs $0x804e2b,%rdi
  8009e6:	00 00 00 
  8009e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ee:	48 ba 22 0b 80 00 00 	movabs $0x800b22,%rdx
  8009f5:	00 00 00 
  8009f8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8009fa:	cc                   	int3   
  8009fb:	eb fd                	jmp    8009fa <_panic+0x111>

00000000008009fd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8009fd:	55                   	push   %rbp
  8009fe:	48 89 e5             	mov    %rsp,%rbp
  800a01:	48 83 ec 10          	sub    $0x10,%rsp
  800a05:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a08:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800a0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a10:	8b 00                	mov    (%rax),%eax
  800a12:	8d 48 01             	lea    0x1(%rax),%ecx
  800a15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a19:	89 0a                	mov    %ecx,(%rdx)
  800a1b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a1e:	89 d1                	mov    %edx,%ecx
  800a20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a24:	48 98                	cltq   
  800a26:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800a2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a2e:	8b 00                	mov    (%rax),%eax
  800a30:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a35:	75 2c                	jne    800a63 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800a37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a3b:	8b 00                	mov    (%rax),%eax
  800a3d:	48 98                	cltq   
  800a3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a43:	48 83 c2 08          	add    $0x8,%rdx
  800a47:	48 89 c6             	mov    %rax,%rsi
  800a4a:	48 89 d7             	mov    %rdx,%rdi
  800a4d:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  800a54:	00 00 00 
  800a57:	ff d0                	callq  *%rax
		b->idx = 0;
  800a59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a5d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800a63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a67:	8b 40 04             	mov    0x4(%rax),%eax
  800a6a:	8d 50 01             	lea    0x1(%rax),%edx
  800a6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a71:	89 50 04             	mov    %edx,0x4(%rax)
}
  800a74:	c9                   	leaveq 
  800a75:	c3                   	retq   

0000000000800a76 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800a76:	55                   	push   %rbp
  800a77:	48 89 e5             	mov    %rsp,%rbp
  800a7a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800a81:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800a88:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800a8f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800a96:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800a9d:	48 8b 0a             	mov    (%rdx),%rcx
  800aa0:	48 89 08             	mov    %rcx,(%rax)
  800aa3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800aa7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800aab:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800aaf:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800ab3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800aba:	00 00 00 
	b.cnt = 0;
  800abd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800ac4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800ac7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800ace:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800ad5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800adc:	48 89 c6             	mov    %rax,%rsi
  800adf:	48 bf fd 09 80 00 00 	movabs $0x8009fd,%rdi
  800ae6:	00 00 00 
  800ae9:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  800af0:	00 00 00 
  800af3:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800af5:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800afb:	48 98                	cltq   
  800afd:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800b04:	48 83 c2 08          	add    $0x8,%rdx
  800b08:	48 89 c6             	mov    %rax,%rsi
  800b0b:	48 89 d7             	mov    %rdx,%rdi
  800b0e:	48 b8 b1 20 80 00 00 	movabs $0x8020b1,%rax
  800b15:	00 00 00 
  800b18:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800b1a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800b20:	c9                   	leaveq 
  800b21:	c3                   	retq   

0000000000800b22 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b22:	55                   	push   %rbp
  800b23:	48 89 e5             	mov    %rsp,%rbp
  800b26:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800b2d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800b34:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800b3b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b42:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b49:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b50:	84 c0                	test   %al,%al
  800b52:	74 20                	je     800b74 <cprintf+0x52>
  800b54:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b58:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b5c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b60:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b64:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b68:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b6c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b70:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b74:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800b7b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800b82:	00 00 00 
  800b85:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800b8c:	00 00 00 
  800b8f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b93:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800b9a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ba1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800ba8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800baf:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800bb6:	48 8b 0a             	mov    (%rdx),%rcx
  800bb9:	48 89 08             	mov    %rcx,(%rax)
  800bbc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bc0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bc4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bc8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800bcc:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800bd3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bda:	48 89 d6             	mov    %rdx,%rsi
  800bdd:	48 89 c7             	mov    %rax,%rdi
  800be0:	48 b8 76 0a 80 00 00 	movabs $0x800a76,%rax
  800be7:	00 00 00 
  800bea:	ff d0                	callq  *%rax
  800bec:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800bf2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800bf8:	c9                   	leaveq 
  800bf9:	c3                   	retq   

0000000000800bfa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bfa:	55                   	push   %rbp
  800bfb:	48 89 e5             	mov    %rsp,%rbp
  800bfe:	53                   	push   %rbx
  800bff:	48 83 ec 38          	sub    $0x38,%rsp
  800c03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800c0b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800c0f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800c12:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800c16:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c1a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800c1d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800c21:	77 3b                	ja     800c5e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c23:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800c26:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800c2a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800c2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c31:	ba 00 00 00 00       	mov    $0x0,%edx
  800c36:	48 f7 f3             	div    %rbx
  800c39:	48 89 c2             	mov    %rax,%rdx
  800c3c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800c3f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800c42:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800c46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c4a:	41 89 f9             	mov    %edi,%r9d
  800c4d:	48 89 c7             	mov    %rax,%rdi
  800c50:	48 b8 fa 0b 80 00 00 	movabs $0x800bfa,%rax
  800c57:	00 00 00 
  800c5a:	ff d0                	callq  *%rax
  800c5c:	eb 1e                	jmp    800c7c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c5e:	eb 12                	jmp    800c72 <printnum+0x78>
			putch(padc, putdat);
  800c60:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800c64:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800c67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c6b:	48 89 ce             	mov    %rcx,%rsi
  800c6e:	89 d7                	mov    %edx,%edi
  800c70:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c72:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800c76:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800c7a:	7f e4                	jg     800c60 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c7c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800c7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c83:	ba 00 00 00 00       	mov    $0x0,%edx
  800c88:	48 f7 f1             	div    %rcx
  800c8b:	48 89 d0             	mov    %rdx,%rax
  800c8e:	48 ba 08 50 80 00 00 	movabs $0x805008,%rdx
  800c95:	00 00 00 
  800c98:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800c9c:	0f be d0             	movsbl %al,%edx
  800c9f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800ca3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca7:	48 89 ce             	mov    %rcx,%rsi
  800caa:	89 d7                	mov    %edx,%edi
  800cac:	ff d0                	callq  *%rax
}
  800cae:	48 83 c4 38          	add    $0x38,%rsp
  800cb2:	5b                   	pop    %rbx
  800cb3:	5d                   	pop    %rbp
  800cb4:	c3                   	retq   

0000000000800cb5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cb5:	55                   	push   %rbp
  800cb6:	48 89 e5             	mov    %rsp,%rbp
  800cb9:	48 83 ec 1c          	sub    $0x1c,%rsp
  800cbd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800cc1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800cc4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800cc8:	7e 52                	jle    800d1c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800cca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cce:	8b 00                	mov    (%rax),%eax
  800cd0:	83 f8 30             	cmp    $0x30,%eax
  800cd3:	73 24                	jae    800cf9 <getuint+0x44>
  800cd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cd9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce1:	8b 00                	mov    (%rax),%eax
  800ce3:	89 c0                	mov    %eax,%eax
  800ce5:	48 01 d0             	add    %rdx,%rax
  800ce8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cec:	8b 12                	mov    (%rdx),%edx
  800cee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cf1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cf5:	89 0a                	mov    %ecx,(%rdx)
  800cf7:	eb 17                	jmp    800d10 <getuint+0x5b>
  800cf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cfd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d01:	48 89 d0             	mov    %rdx,%rax
  800d04:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d08:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d0c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d10:	48 8b 00             	mov    (%rax),%rax
  800d13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d17:	e9 a3 00 00 00       	jmpq   800dbf <getuint+0x10a>
	else if (lflag)
  800d1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800d20:	74 4f                	je     800d71 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800d22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d26:	8b 00                	mov    (%rax),%eax
  800d28:	83 f8 30             	cmp    $0x30,%eax
  800d2b:	73 24                	jae    800d51 <getuint+0x9c>
  800d2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d31:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d39:	8b 00                	mov    (%rax),%eax
  800d3b:	89 c0                	mov    %eax,%eax
  800d3d:	48 01 d0             	add    %rdx,%rax
  800d40:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d44:	8b 12                	mov    (%rdx),%edx
  800d46:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d49:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d4d:	89 0a                	mov    %ecx,(%rdx)
  800d4f:	eb 17                	jmp    800d68 <getuint+0xb3>
  800d51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d55:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d59:	48 89 d0             	mov    %rdx,%rax
  800d5c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d64:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d68:	48 8b 00             	mov    (%rax),%rax
  800d6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d6f:	eb 4e                	jmp    800dbf <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800d71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d75:	8b 00                	mov    (%rax),%eax
  800d77:	83 f8 30             	cmp    $0x30,%eax
  800d7a:	73 24                	jae    800da0 <getuint+0xeb>
  800d7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d80:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d88:	8b 00                	mov    (%rax),%eax
  800d8a:	89 c0                	mov    %eax,%eax
  800d8c:	48 01 d0             	add    %rdx,%rax
  800d8f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d93:	8b 12                	mov    (%rdx),%edx
  800d95:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d98:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d9c:	89 0a                	mov    %ecx,(%rdx)
  800d9e:	eb 17                	jmp    800db7 <getuint+0x102>
  800da0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800da8:	48 89 d0             	mov    %rdx,%rax
  800dab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800daf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800db3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800db7:	8b 00                	mov    (%rax),%eax
  800db9:	89 c0                	mov    %eax,%eax
  800dbb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800dbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800dc3:	c9                   	leaveq 
  800dc4:	c3                   	retq   

0000000000800dc5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dc5:	55                   	push   %rbp
  800dc6:	48 89 e5             	mov    %rsp,%rbp
  800dc9:	48 83 ec 1c          	sub    $0x1c,%rsp
  800dcd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dd1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800dd4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800dd8:	7e 52                	jle    800e2c <getint+0x67>
		x=va_arg(*ap, long long);
  800dda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dde:	8b 00                	mov    (%rax),%eax
  800de0:	83 f8 30             	cmp    $0x30,%eax
  800de3:	73 24                	jae    800e09 <getint+0x44>
  800de5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ded:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df1:	8b 00                	mov    (%rax),%eax
  800df3:	89 c0                	mov    %eax,%eax
  800df5:	48 01 d0             	add    %rdx,%rax
  800df8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dfc:	8b 12                	mov    (%rdx),%edx
  800dfe:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e01:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e05:	89 0a                	mov    %ecx,(%rdx)
  800e07:	eb 17                	jmp    800e20 <getint+0x5b>
  800e09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e0d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e11:	48 89 d0             	mov    %rdx,%rax
  800e14:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e18:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e1c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e20:	48 8b 00             	mov    (%rax),%rax
  800e23:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e27:	e9 a3 00 00 00       	jmpq   800ecf <getint+0x10a>
	else if (lflag)
  800e2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800e30:	74 4f                	je     800e81 <getint+0xbc>
		x=va_arg(*ap, long);
  800e32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e36:	8b 00                	mov    (%rax),%eax
  800e38:	83 f8 30             	cmp    $0x30,%eax
  800e3b:	73 24                	jae    800e61 <getint+0x9c>
  800e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e41:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e49:	8b 00                	mov    (%rax),%eax
  800e4b:	89 c0                	mov    %eax,%eax
  800e4d:	48 01 d0             	add    %rdx,%rax
  800e50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e54:	8b 12                	mov    (%rdx),%edx
  800e56:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e59:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e5d:	89 0a                	mov    %ecx,(%rdx)
  800e5f:	eb 17                	jmp    800e78 <getint+0xb3>
  800e61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e65:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e69:	48 89 d0             	mov    %rdx,%rax
  800e6c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e70:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e74:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e78:	48 8b 00             	mov    (%rax),%rax
  800e7b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e7f:	eb 4e                	jmp    800ecf <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800e81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e85:	8b 00                	mov    (%rax),%eax
  800e87:	83 f8 30             	cmp    $0x30,%eax
  800e8a:	73 24                	jae    800eb0 <getint+0xeb>
  800e8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e90:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e98:	8b 00                	mov    (%rax),%eax
  800e9a:	89 c0                	mov    %eax,%eax
  800e9c:	48 01 d0             	add    %rdx,%rax
  800e9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ea3:	8b 12                	mov    (%rdx),%edx
  800ea5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ea8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eac:	89 0a                	mov    %ecx,(%rdx)
  800eae:	eb 17                	jmp    800ec7 <getint+0x102>
  800eb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800eb8:	48 89 d0             	mov    %rdx,%rax
  800ebb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ebf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ec3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ec7:	8b 00                	mov    (%rax),%eax
  800ec9:	48 98                	cltq   
  800ecb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ecf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ed3:	c9                   	leaveq 
  800ed4:	c3                   	retq   

0000000000800ed5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ed5:	55                   	push   %rbp
  800ed6:	48 89 e5             	mov    %rsp,%rbp
  800ed9:	41 54                	push   %r12
  800edb:	53                   	push   %rbx
  800edc:	48 83 ec 60          	sub    $0x60,%rsp
  800ee0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800ee4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ee8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800eec:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ef0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ef4:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800ef8:	48 8b 0a             	mov    (%rdx),%rcx
  800efb:	48 89 08             	mov    %rcx,(%rax)
  800efe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f02:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f06:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f0a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  800f0e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f12:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f16:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f1a:	0f b6 00             	movzbl (%rax),%eax
  800f1d:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  800f20:	eb 29                	jmp    800f4b <vprintfmt+0x76>
			if (ch == '\0')
  800f22:	85 db                	test   %ebx,%ebx
  800f24:	0f 84 ad 06 00 00    	je     8015d7 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  800f2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f32:	48 89 d6             	mov    %rdx,%rsi
  800f35:	89 df                	mov    %ebx,%edi
  800f37:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  800f39:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f3d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f41:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f45:	0f b6 00             	movzbl (%rax),%eax
  800f48:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  800f4b:	83 fb 25             	cmp    $0x25,%ebx
  800f4e:	74 05                	je     800f55 <vprintfmt+0x80>
  800f50:	83 fb 1b             	cmp    $0x1b,%ebx
  800f53:	75 cd                	jne    800f22 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800f55:	83 fb 1b             	cmp    $0x1b,%ebx
  800f58:	0f 85 ae 01 00 00    	jne    80110c <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  800f5e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800f65:	00 00 00 
  800f68:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  800f6e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f72:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f76:	48 89 d6             	mov    %rdx,%rsi
  800f79:	89 df                	mov    %ebx,%edi
  800f7b:	ff d0                	callq  *%rax
			putch('[', putdat);
  800f7d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f81:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f85:	48 89 d6             	mov    %rdx,%rsi
  800f88:	bf 5b 00 00 00       	mov    $0x5b,%edi
  800f8d:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800f8f:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800f95:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800f9a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f9e:	0f b6 00             	movzbl (%rax),%eax
  800fa1:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800fa4:	eb 32                	jmp    800fd8 <vprintfmt+0x103>
					putch(ch, putdat);
  800fa6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800faa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fae:	48 89 d6             	mov    %rdx,%rsi
  800fb1:	89 df                	mov    %ebx,%edi
  800fb3:	ff d0                	callq  *%rax
					esc_color *= 10;
  800fb5:	44 89 e0             	mov    %r12d,%eax
  800fb8:	c1 e0 02             	shl    $0x2,%eax
  800fbb:	44 01 e0             	add    %r12d,%eax
  800fbe:	01 c0                	add    %eax,%eax
  800fc0:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800fc3:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800fc6:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800fc9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800fce:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fd2:	0f b6 00             	movzbl (%rax),%eax
  800fd5:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800fd8:	83 fb 3b             	cmp    $0x3b,%ebx
  800fdb:	74 05                	je     800fe2 <vprintfmt+0x10d>
  800fdd:	83 fb 6d             	cmp    $0x6d,%ebx
  800fe0:	75 c4                	jne    800fa6 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800fe2:	45 85 e4             	test   %r12d,%r12d
  800fe5:	75 15                	jne    800ffc <vprintfmt+0x127>
					color_flag = 0x07;
  800fe7:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800fee:	00 00 00 
  800ff1:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800ff7:	e9 dc 00 00 00       	jmpq   8010d8 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800ffc:	41 83 fc 1d          	cmp    $0x1d,%r12d
  801000:	7e 69                	jle    80106b <vprintfmt+0x196>
  801002:	41 83 fc 25          	cmp    $0x25,%r12d
  801006:	7f 63                	jg     80106b <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  801008:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80100f:	00 00 00 
  801012:	8b 00                	mov    (%rax),%eax
  801014:	25 f8 00 00 00       	and    $0xf8,%eax
  801019:	89 c2                	mov    %eax,%edx
  80101b:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801022:	00 00 00 
  801025:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  801027:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  80102b:	44 89 e0             	mov    %r12d,%eax
  80102e:	83 e0 04             	and    $0x4,%eax
  801031:	c1 f8 02             	sar    $0x2,%eax
  801034:	89 c2                	mov    %eax,%edx
  801036:	44 89 e0             	mov    %r12d,%eax
  801039:	83 e0 02             	and    $0x2,%eax
  80103c:	09 c2                	or     %eax,%edx
  80103e:	44 89 e0             	mov    %r12d,%eax
  801041:	83 e0 01             	and    $0x1,%eax
  801044:	c1 e0 02             	shl    $0x2,%eax
  801047:	09 c2                	or     %eax,%edx
  801049:	41 89 d4             	mov    %edx,%r12d
  80104c:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801053:	00 00 00 
  801056:	8b 00                	mov    (%rax),%eax
  801058:	44 89 e2             	mov    %r12d,%edx
  80105b:	09 c2                	or     %eax,%edx
  80105d:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801064:	00 00 00 
  801067:	89 10                	mov    %edx,(%rax)
  801069:	eb 6d                	jmp    8010d8 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  80106b:	41 83 fc 27          	cmp    $0x27,%r12d
  80106f:	7e 67                	jle    8010d8 <vprintfmt+0x203>
  801071:	41 83 fc 2f          	cmp    $0x2f,%r12d
  801075:	7f 61                	jg     8010d8 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  801077:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80107e:	00 00 00 
  801081:	8b 00                	mov    (%rax),%eax
  801083:	25 8f 00 00 00       	and    $0x8f,%eax
  801088:	89 c2                	mov    %eax,%edx
  80108a:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801091:	00 00 00 
  801094:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  801096:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  80109a:	44 89 e0             	mov    %r12d,%eax
  80109d:	83 e0 04             	and    $0x4,%eax
  8010a0:	c1 f8 02             	sar    $0x2,%eax
  8010a3:	89 c2                	mov    %eax,%edx
  8010a5:	44 89 e0             	mov    %r12d,%eax
  8010a8:	83 e0 02             	and    $0x2,%eax
  8010ab:	09 c2                	or     %eax,%edx
  8010ad:	44 89 e0             	mov    %r12d,%eax
  8010b0:	83 e0 01             	and    $0x1,%eax
  8010b3:	c1 e0 06             	shl    $0x6,%eax
  8010b6:	09 c2                	or     %eax,%edx
  8010b8:	41 89 d4             	mov    %edx,%r12d
  8010bb:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8010c2:	00 00 00 
  8010c5:	8b 00                	mov    (%rax),%eax
  8010c7:	44 89 e2             	mov    %r12d,%edx
  8010ca:	09 c2                	or     %eax,%edx
  8010cc:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8010d3:	00 00 00 
  8010d6:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  8010d8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010dc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010e0:	48 89 d6             	mov    %rdx,%rsi
  8010e3:	89 df                	mov    %ebx,%edi
  8010e5:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  8010e7:	83 fb 6d             	cmp    $0x6d,%ebx
  8010ea:	75 1b                	jne    801107 <vprintfmt+0x232>
					fmt ++;
  8010ec:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  8010f1:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  8010f2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8010f9:	00 00 00 
  8010fc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  801102:	e9 cb 04 00 00       	jmpq   8015d2 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  801107:	e9 83 fe ff ff       	jmpq   800f8f <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  80110c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801110:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801117:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80111e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801125:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80112c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801130:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801134:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801138:	0f b6 00             	movzbl (%rax),%eax
  80113b:	0f b6 d8             	movzbl %al,%ebx
  80113e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  801141:	83 f8 55             	cmp    $0x55,%eax
  801144:	0f 87 5a 04 00 00    	ja     8015a4 <vprintfmt+0x6cf>
  80114a:	89 c0                	mov    %eax,%eax
  80114c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801153:	00 
  801154:	48 b8 30 50 80 00 00 	movabs $0x805030,%rax
  80115b:	00 00 00 
  80115e:	48 01 d0             	add    %rdx,%rax
  801161:	48 8b 00             	mov    (%rax),%rax
  801164:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  801166:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80116a:	eb c0                	jmp    80112c <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80116c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  801170:	eb ba                	jmp    80112c <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801172:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  801179:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80117c:	89 d0                	mov    %edx,%eax
  80117e:	c1 e0 02             	shl    $0x2,%eax
  801181:	01 d0                	add    %edx,%eax
  801183:	01 c0                	add    %eax,%eax
  801185:	01 d8                	add    %ebx,%eax
  801187:	83 e8 30             	sub    $0x30,%eax
  80118a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80118d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801191:	0f b6 00             	movzbl (%rax),%eax
  801194:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801197:	83 fb 2f             	cmp    $0x2f,%ebx
  80119a:	7e 0c                	jle    8011a8 <vprintfmt+0x2d3>
  80119c:	83 fb 39             	cmp    $0x39,%ebx
  80119f:	7f 07                	jg     8011a8 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011a1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011a6:	eb d1                	jmp    801179 <vprintfmt+0x2a4>
			goto process_precision;
  8011a8:	eb 58                	jmp    801202 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  8011aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011ad:	83 f8 30             	cmp    $0x30,%eax
  8011b0:	73 17                	jae    8011c9 <vprintfmt+0x2f4>
  8011b2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8011b6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011b9:	89 c0                	mov    %eax,%eax
  8011bb:	48 01 d0             	add    %rdx,%rax
  8011be:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011c1:	83 c2 08             	add    $0x8,%edx
  8011c4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8011c7:	eb 0f                	jmp    8011d8 <vprintfmt+0x303>
  8011c9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011cd:	48 89 d0             	mov    %rdx,%rax
  8011d0:	48 83 c2 08          	add    $0x8,%rdx
  8011d4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8011d8:	8b 00                	mov    (%rax),%eax
  8011da:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8011dd:	eb 23                	jmp    801202 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  8011df:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011e3:	79 0c                	jns    8011f1 <vprintfmt+0x31c>
				width = 0;
  8011e5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8011ec:	e9 3b ff ff ff       	jmpq   80112c <vprintfmt+0x257>
  8011f1:	e9 36 ff ff ff       	jmpq   80112c <vprintfmt+0x257>

		case '#':
			altflag = 1;
  8011f6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8011fd:	e9 2a ff ff ff       	jmpq   80112c <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  801202:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801206:	79 12                	jns    80121a <vprintfmt+0x345>
				width = precision, precision = -1;
  801208:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80120b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80120e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801215:	e9 12 ff ff ff       	jmpq   80112c <vprintfmt+0x257>
  80121a:	e9 0d ff ff ff       	jmpq   80112c <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80121f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801223:	e9 04 ff ff ff       	jmpq   80112c <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801228:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80122b:	83 f8 30             	cmp    $0x30,%eax
  80122e:	73 17                	jae    801247 <vprintfmt+0x372>
  801230:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801234:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801237:	89 c0                	mov    %eax,%eax
  801239:	48 01 d0             	add    %rdx,%rax
  80123c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80123f:	83 c2 08             	add    $0x8,%edx
  801242:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801245:	eb 0f                	jmp    801256 <vprintfmt+0x381>
  801247:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80124b:	48 89 d0             	mov    %rdx,%rax
  80124e:	48 83 c2 08          	add    $0x8,%rdx
  801252:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801256:	8b 10                	mov    (%rax),%edx
  801258:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80125c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801260:	48 89 ce             	mov    %rcx,%rsi
  801263:	89 d7                	mov    %edx,%edi
  801265:	ff d0                	callq  *%rax
			break;
  801267:	e9 66 03 00 00       	jmpq   8015d2 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  80126c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80126f:	83 f8 30             	cmp    $0x30,%eax
  801272:	73 17                	jae    80128b <vprintfmt+0x3b6>
  801274:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801278:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80127b:	89 c0                	mov    %eax,%eax
  80127d:	48 01 d0             	add    %rdx,%rax
  801280:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801283:	83 c2 08             	add    $0x8,%edx
  801286:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801289:	eb 0f                	jmp    80129a <vprintfmt+0x3c5>
  80128b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80128f:	48 89 d0             	mov    %rdx,%rax
  801292:	48 83 c2 08          	add    $0x8,%rdx
  801296:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80129a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80129c:	85 db                	test   %ebx,%ebx
  80129e:	79 02                	jns    8012a2 <vprintfmt+0x3cd>
				err = -err;
  8012a0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8012a2:	83 fb 10             	cmp    $0x10,%ebx
  8012a5:	7f 16                	jg     8012bd <vprintfmt+0x3e8>
  8012a7:	48 b8 80 4f 80 00 00 	movabs $0x804f80,%rax
  8012ae:	00 00 00 
  8012b1:	48 63 d3             	movslq %ebx,%rdx
  8012b4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8012b8:	4d 85 e4             	test   %r12,%r12
  8012bb:	75 2e                	jne    8012eb <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  8012bd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8012c1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012c5:	89 d9                	mov    %ebx,%ecx
  8012c7:	48 ba 19 50 80 00 00 	movabs $0x805019,%rdx
  8012ce:	00 00 00 
  8012d1:	48 89 c7             	mov    %rax,%rdi
  8012d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d9:	49 b8 e0 15 80 00 00 	movabs $0x8015e0,%r8
  8012e0:	00 00 00 
  8012e3:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8012e6:	e9 e7 02 00 00       	jmpq   8015d2 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8012eb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8012ef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012f3:	4c 89 e1             	mov    %r12,%rcx
  8012f6:	48 ba 22 50 80 00 00 	movabs $0x805022,%rdx
  8012fd:	00 00 00 
  801300:	48 89 c7             	mov    %rax,%rdi
  801303:	b8 00 00 00 00       	mov    $0x0,%eax
  801308:	49 b8 e0 15 80 00 00 	movabs $0x8015e0,%r8
  80130f:	00 00 00 
  801312:	41 ff d0             	callq  *%r8
			break;
  801315:	e9 b8 02 00 00       	jmpq   8015d2 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80131a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80131d:	83 f8 30             	cmp    $0x30,%eax
  801320:	73 17                	jae    801339 <vprintfmt+0x464>
  801322:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801326:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801329:	89 c0                	mov    %eax,%eax
  80132b:	48 01 d0             	add    %rdx,%rax
  80132e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801331:	83 c2 08             	add    $0x8,%edx
  801334:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801337:	eb 0f                	jmp    801348 <vprintfmt+0x473>
  801339:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80133d:	48 89 d0             	mov    %rdx,%rax
  801340:	48 83 c2 08          	add    $0x8,%rdx
  801344:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801348:	4c 8b 20             	mov    (%rax),%r12
  80134b:	4d 85 e4             	test   %r12,%r12
  80134e:	75 0a                	jne    80135a <vprintfmt+0x485>
				p = "(null)";
  801350:	49 bc 25 50 80 00 00 	movabs $0x805025,%r12
  801357:	00 00 00 
			if (width > 0 && padc != '-')
  80135a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80135e:	7e 3f                	jle    80139f <vprintfmt+0x4ca>
  801360:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801364:	74 39                	je     80139f <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  801366:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801369:	48 98                	cltq   
  80136b:	48 89 c6             	mov    %rax,%rsi
  80136e:	4c 89 e7             	mov    %r12,%rdi
  801371:	48 b8 8c 18 80 00 00 	movabs $0x80188c,%rax
  801378:	00 00 00 
  80137b:	ff d0                	callq  *%rax
  80137d:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801380:	eb 17                	jmp    801399 <vprintfmt+0x4c4>
					putch(padc, putdat);
  801382:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801386:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80138a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80138e:	48 89 ce             	mov    %rcx,%rsi
  801391:	89 d7                	mov    %edx,%edi
  801393:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801395:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801399:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80139d:	7f e3                	jg     801382 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80139f:	eb 37                	jmp    8013d8 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  8013a1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8013a5:	74 1e                	je     8013c5 <vprintfmt+0x4f0>
  8013a7:	83 fb 1f             	cmp    $0x1f,%ebx
  8013aa:	7e 05                	jle    8013b1 <vprintfmt+0x4dc>
  8013ac:	83 fb 7e             	cmp    $0x7e,%ebx
  8013af:	7e 14                	jle    8013c5 <vprintfmt+0x4f0>
					putch('?', putdat);
  8013b1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013b5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013b9:	48 89 d6             	mov    %rdx,%rsi
  8013bc:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8013c1:	ff d0                	callq  *%rax
  8013c3:	eb 0f                	jmp    8013d4 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  8013c5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013c9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013cd:	48 89 d6             	mov    %rdx,%rsi
  8013d0:	89 df                	mov    %ebx,%edi
  8013d2:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013d4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8013d8:	4c 89 e0             	mov    %r12,%rax
  8013db:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8013df:	0f b6 00             	movzbl (%rax),%eax
  8013e2:	0f be d8             	movsbl %al,%ebx
  8013e5:	85 db                	test   %ebx,%ebx
  8013e7:	74 10                	je     8013f9 <vprintfmt+0x524>
  8013e9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8013ed:	78 b2                	js     8013a1 <vprintfmt+0x4cc>
  8013ef:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8013f3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8013f7:	79 a8                	jns    8013a1 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013f9:	eb 16                	jmp    801411 <vprintfmt+0x53c>
				putch(' ', putdat);
  8013fb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013ff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801403:	48 89 d6             	mov    %rdx,%rsi
  801406:	bf 20 00 00 00       	mov    $0x20,%edi
  80140b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80140d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801411:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801415:	7f e4                	jg     8013fb <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  801417:	e9 b6 01 00 00       	jmpq   8015d2 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80141c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801420:	be 03 00 00 00       	mov    $0x3,%esi
  801425:	48 89 c7             	mov    %rax,%rdi
  801428:	48 b8 c5 0d 80 00 00 	movabs $0x800dc5,%rax
  80142f:	00 00 00 
  801432:	ff d0                	callq  *%rax
  801434:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801438:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80143c:	48 85 c0             	test   %rax,%rax
  80143f:	79 1d                	jns    80145e <vprintfmt+0x589>
				putch('-', putdat);
  801441:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801445:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801449:	48 89 d6             	mov    %rdx,%rsi
  80144c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801451:	ff d0                	callq  *%rax
				num = -(long long) num;
  801453:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801457:	48 f7 d8             	neg    %rax
  80145a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80145e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801465:	e9 fb 00 00 00       	jmpq   801565 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80146a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80146e:	be 03 00 00 00       	mov    $0x3,%esi
  801473:	48 89 c7             	mov    %rax,%rdi
  801476:	48 b8 b5 0c 80 00 00 	movabs $0x800cb5,%rax
  80147d:	00 00 00 
  801480:	ff d0                	callq  *%rax
  801482:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801486:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80148d:	e9 d3 00 00 00       	jmpq   801565 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  801492:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801496:	be 03 00 00 00       	mov    $0x3,%esi
  80149b:	48 89 c7             	mov    %rax,%rdi
  80149e:	48 b8 c5 0d 80 00 00 	movabs $0x800dc5,%rax
  8014a5:	00 00 00 
  8014a8:	ff d0                	callq  *%rax
  8014aa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8014ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b2:	48 85 c0             	test   %rax,%rax
  8014b5:	79 1d                	jns    8014d4 <vprintfmt+0x5ff>
				putch('-', putdat);
  8014b7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014bb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014bf:	48 89 d6             	mov    %rdx,%rsi
  8014c2:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8014c7:	ff d0                	callq  *%rax
				num = -(long long) num;
  8014c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014cd:	48 f7 d8             	neg    %rax
  8014d0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  8014d4:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8014db:	e9 85 00 00 00       	jmpq   801565 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  8014e0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014e4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014e8:	48 89 d6             	mov    %rdx,%rsi
  8014eb:	bf 30 00 00 00       	mov    $0x30,%edi
  8014f0:	ff d0                	callq  *%rax
			putch('x', putdat);
  8014f2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014f6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014fa:	48 89 d6             	mov    %rdx,%rsi
  8014fd:	bf 78 00 00 00       	mov    $0x78,%edi
  801502:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801504:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801507:	83 f8 30             	cmp    $0x30,%eax
  80150a:	73 17                	jae    801523 <vprintfmt+0x64e>
  80150c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801510:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801513:	89 c0                	mov    %eax,%eax
  801515:	48 01 d0             	add    %rdx,%rax
  801518:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80151b:	83 c2 08             	add    $0x8,%edx
  80151e:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801521:	eb 0f                	jmp    801532 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  801523:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801527:	48 89 d0             	mov    %rdx,%rax
  80152a:	48 83 c2 08          	add    $0x8,%rdx
  80152e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801532:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801535:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801539:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801540:	eb 23                	jmp    801565 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801542:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801546:	be 03 00 00 00       	mov    $0x3,%esi
  80154b:	48 89 c7             	mov    %rax,%rdi
  80154e:	48 b8 b5 0c 80 00 00 	movabs $0x800cb5,%rax
  801555:	00 00 00 
  801558:	ff d0                	callq  *%rax
  80155a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80155e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801565:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80156a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80156d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801570:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801574:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801578:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80157c:	45 89 c1             	mov    %r8d,%r9d
  80157f:	41 89 f8             	mov    %edi,%r8d
  801582:	48 89 c7             	mov    %rax,%rdi
  801585:	48 b8 fa 0b 80 00 00 	movabs $0x800bfa,%rax
  80158c:	00 00 00 
  80158f:	ff d0                	callq  *%rax
			break;
  801591:	eb 3f                	jmp    8015d2 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801593:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801597:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80159b:	48 89 d6             	mov    %rdx,%rsi
  80159e:	89 df                	mov    %ebx,%edi
  8015a0:	ff d0                	callq  *%rax
			break;
  8015a2:	eb 2e                	jmp    8015d2 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8015a4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015a8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015ac:	48 89 d6             	mov    %rdx,%rsi
  8015af:	bf 25 00 00 00       	mov    $0x25,%edi
  8015b4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8015b6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015bb:	eb 05                	jmp    8015c2 <vprintfmt+0x6ed>
  8015bd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015c2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8015c6:	48 83 e8 01          	sub    $0x1,%rax
  8015ca:	0f b6 00             	movzbl (%rax),%eax
  8015cd:	3c 25                	cmp    $0x25,%al
  8015cf:	75 ec                	jne    8015bd <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  8015d1:	90                   	nop
		}
	}
  8015d2:	e9 37 f9 ff ff       	jmpq   800f0e <vprintfmt+0x39>
    va_end(aq);
}
  8015d7:	48 83 c4 60          	add    $0x60,%rsp
  8015db:	5b                   	pop    %rbx
  8015dc:	41 5c                	pop    %r12
  8015de:	5d                   	pop    %rbp
  8015df:	c3                   	retq   

00000000008015e0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8015e0:	55                   	push   %rbp
  8015e1:	48 89 e5             	mov    %rsp,%rbp
  8015e4:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8015eb:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8015f2:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8015f9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801600:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801607:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80160e:	84 c0                	test   %al,%al
  801610:	74 20                	je     801632 <printfmt+0x52>
  801612:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801616:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80161a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80161e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801622:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801626:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80162a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80162e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801632:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801639:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801640:	00 00 00 
  801643:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80164a:	00 00 00 
  80164d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801651:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801658:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80165f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801666:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80166d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801674:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80167b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801682:	48 89 c7             	mov    %rax,%rdi
  801685:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  80168c:	00 00 00 
  80168f:	ff d0                	callq  *%rax
	va_end(ap);
}
  801691:	c9                   	leaveq 
  801692:	c3                   	retq   

0000000000801693 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801693:	55                   	push   %rbp
  801694:	48 89 e5             	mov    %rsp,%rbp
  801697:	48 83 ec 10          	sub    $0x10,%rsp
  80169b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80169e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8016a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a6:	8b 40 10             	mov    0x10(%rax),%eax
  8016a9:	8d 50 01             	lea    0x1(%rax),%edx
  8016ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b0:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8016b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b7:	48 8b 10             	mov    (%rax),%rdx
  8016ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016be:	48 8b 40 08          	mov    0x8(%rax),%rax
  8016c2:	48 39 c2             	cmp    %rax,%rdx
  8016c5:	73 17                	jae    8016de <sprintputch+0x4b>
		*b->buf++ = ch;
  8016c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016cb:	48 8b 00             	mov    (%rax),%rax
  8016ce:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8016d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016d6:	48 89 0a             	mov    %rcx,(%rdx)
  8016d9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8016dc:	88 10                	mov    %dl,(%rax)
}
  8016de:	c9                   	leaveq 
  8016df:	c3                   	retq   

00000000008016e0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8016e0:	55                   	push   %rbp
  8016e1:	48 89 e5             	mov    %rsp,%rbp
  8016e4:	48 83 ec 50          	sub    $0x50,%rsp
  8016e8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8016ec:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8016ef:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8016f3:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8016f7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8016fb:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8016ff:	48 8b 0a             	mov    (%rdx),%rcx
  801702:	48 89 08             	mov    %rcx,(%rax)
  801705:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801709:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80170d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801711:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801715:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801719:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80171d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801720:	48 98                	cltq   
  801722:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801726:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80172a:	48 01 d0             	add    %rdx,%rax
  80172d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801731:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801738:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80173d:	74 06                	je     801745 <vsnprintf+0x65>
  80173f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801743:	7f 07                	jg     80174c <vsnprintf+0x6c>
		return -E_INVAL;
  801745:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80174a:	eb 2f                	jmp    80177b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80174c:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801750:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801754:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801758:	48 89 c6             	mov    %rax,%rsi
  80175b:	48 bf 93 16 80 00 00 	movabs $0x801693,%rdi
  801762:	00 00 00 
  801765:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  80176c:	00 00 00 
  80176f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801771:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801775:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801778:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80177b:	c9                   	leaveq 
  80177c:	c3                   	retq   

000000000080177d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80177d:	55                   	push   %rbp
  80177e:	48 89 e5             	mov    %rsp,%rbp
  801781:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801788:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80178f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801795:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80179c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8017a3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8017aa:	84 c0                	test   %al,%al
  8017ac:	74 20                	je     8017ce <snprintf+0x51>
  8017ae:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8017b2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8017b6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8017ba:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8017be:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8017c2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8017c6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8017ca:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8017ce:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8017d5:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8017dc:	00 00 00 
  8017df:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8017e6:	00 00 00 
  8017e9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8017ed:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8017f4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8017fb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801802:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801809:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801810:	48 8b 0a             	mov    (%rdx),%rcx
  801813:	48 89 08             	mov    %rcx,(%rax)
  801816:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80181a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80181e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801822:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801826:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80182d:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801834:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80183a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801841:	48 89 c7             	mov    %rax,%rdi
  801844:	48 b8 e0 16 80 00 00 	movabs $0x8016e0,%rax
  80184b:	00 00 00 
  80184e:	ff d0                	callq  *%rax
  801850:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801856:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80185c:	c9                   	leaveq 
  80185d:	c3                   	retq   

000000000080185e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80185e:	55                   	push   %rbp
  80185f:	48 89 e5             	mov    %rsp,%rbp
  801862:	48 83 ec 18          	sub    $0x18,%rsp
  801866:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80186a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801871:	eb 09                	jmp    80187c <strlen+0x1e>
		n++;
  801873:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801877:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80187c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801880:	0f b6 00             	movzbl (%rax),%eax
  801883:	84 c0                	test   %al,%al
  801885:	75 ec                	jne    801873 <strlen+0x15>
		n++;
	return n;
  801887:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80188a:	c9                   	leaveq 
  80188b:	c3                   	retq   

000000000080188c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80188c:	55                   	push   %rbp
  80188d:	48 89 e5             	mov    %rsp,%rbp
  801890:	48 83 ec 20          	sub    $0x20,%rsp
  801894:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801898:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80189c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8018a3:	eb 0e                	jmp    8018b3 <strnlen+0x27>
		n++;
  8018a5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018a9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018ae:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8018b3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8018b8:	74 0b                	je     8018c5 <strnlen+0x39>
  8018ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018be:	0f b6 00             	movzbl (%rax),%eax
  8018c1:	84 c0                	test   %al,%al
  8018c3:	75 e0                	jne    8018a5 <strnlen+0x19>
		n++;
	return n;
  8018c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8018c8:	c9                   	leaveq 
  8018c9:	c3                   	retq   

00000000008018ca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018ca:	55                   	push   %rbp
  8018cb:	48 89 e5             	mov    %rsp,%rbp
  8018ce:	48 83 ec 20          	sub    $0x20,%rsp
  8018d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8018da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8018e2:	90                   	nop
  8018e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018eb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8018ef:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8018f3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8018f7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8018fb:	0f b6 12             	movzbl (%rdx),%edx
  8018fe:	88 10                	mov    %dl,(%rax)
  801900:	0f b6 00             	movzbl (%rax),%eax
  801903:	84 c0                	test   %al,%al
  801905:	75 dc                	jne    8018e3 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801907:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80190b:	c9                   	leaveq 
  80190c:	c3                   	retq   

000000000080190d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80190d:	55                   	push   %rbp
  80190e:	48 89 e5             	mov    %rsp,%rbp
  801911:	48 83 ec 20          	sub    $0x20,%rsp
  801915:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801919:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80191d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801921:	48 89 c7             	mov    %rax,%rdi
  801924:	48 b8 5e 18 80 00 00 	movabs $0x80185e,%rax
  80192b:	00 00 00 
  80192e:	ff d0                	callq  *%rax
  801930:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801933:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801936:	48 63 d0             	movslq %eax,%rdx
  801939:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80193d:	48 01 c2             	add    %rax,%rdx
  801940:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801944:	48 89 c6             	mov    %rax,%rsi
  801947:	48 89 d7             	mov    %rdx,%rdi
  80194a:	48 b8 ca 18 80 00 00 	movabs $0x8018ca,%rax
  801951:	00 00 00 
  801954:	ff d0                	callq  *%rax
	return dst;
  801956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80195a:	c9                   	leaveq 
  80195b:	c3                   	retq   

000000000080195c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80195c:	55                   	push   %rbp
  80195d:	48 89 e5             	mov    %rsp,%rbp
  801960:	48 83 ec 28          	sub    $0x28,%rsp
  801964:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801968:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80196c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801970:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801974:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801978:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80197f:	00 
  801980:	eb 2a                	jmp    8019ac <strncpy+0x50>
		*dst++ = *src;
  801982:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801986:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80198a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80198e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801992:	0f b6 12             	movzbl (%rdx),%edx
  801995:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801997:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80199b:	0f b6 00             	movzbl (%rax),%eax
  80199e:	84 c0                	test   %al,%al
  8019a0:	74 05                	je     8019a7 <strncpy+0x4b>
			src++;
  8019a2:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019a7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8019b4:	72 cc                	jb     801982 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8019b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019ba:	c9                   	leaveq 
  8019bb:	c3                   	retq   

00000000008019bc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8019bc:	55                   	push   %rbp
  8019bd:	48 89 e5             	mov    %rsp,%rbp
  8019c0:	48 83 ec 28          	sub    $0x28,%rsp
  8019c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8019d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8019d8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8019dd:	74 3d                	je     801a1c <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8019df:	eb 1d                	jmp    8019fe <strlcpy+0x42>
			*dst++ = *src++;
  8019e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019e5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019e9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019ed:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8019f1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8019f5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8019f9:	0f b6 12             	movzbl (%rdx),%edx
  8019fc:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019fe:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801a03:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a08:	74 0b                	je     801a15 <strlcpy+0x59>
  801a0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a0e:	0f b6 00             	movzbl (%rax),%eax
  801a11:	84 c0                	test   %al,%al
  801a13:	75 cc                	jne    8019e1 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801a15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a19:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801a1c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a24:	48 29 c2             	sub    %rax,%rdx
  801a27:	48 89 d0             	mov    %rdx,%rax
}
  801a2a:	c9                   	leaveq 
  801a2b:	c3                   	retq   

0000000000801a2c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a2c:	55                   	push   %rbp
  801a2d:	48 89 e5             	mov    %rsp,%rbp
  801a30:	48 83 ec 10          	sub    $0x10,%rsp
  801a34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a38:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801a3c:	eb 0a                	jmp    801a48 <strcmp+0x1c>
		p++, q++;
  801a3e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a43:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a4c:	0f b6 00             	movzbl (%rax),%eax
  801a4f:	84 c0                	test   %al,%al
  801a51:	74 12                	je     801a65 <strcmp+0x39>
  801a53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a57:	0f b6 10             	movzbl (%rax),%edx
  801a5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a5e:	0f b6 00             	movzbl (%rax),%eax
  801a61:	38 c2                	cmp    %al,%dl
  801a63:	74 d9                	je     801a3e <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a69:	0f b6 00             	movzbl (%rax),%eax
  801a6c:	0f b6 d0             	movzbl %al,%edx
  801a6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a73:	0f b6 00             	movzbl (%rax),%eax
  801a76:	0f b6 c0             	movzbl %al,%eax
  801a79:	29 c2                	sub    %eax,%edx
  801a7b:	89 d0                	mov    %edx,%eax
}
  801a7d:	c9                   	leaveq 
  801a7e:	c3                   	retq   

0000000000801a7f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a7f:	55                   	push   %rbp
  801a80:	48 89 e5             	mov    %rsp,%rbp
  801a83:	48 83 ec 18          	sub    $0x18,%rsp
  801a87:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a8f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801a93:	eb 0f                	jmp    801aa4 <strncmp+0x25>
		n--, p++, q++;
  801a95:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801a9a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a9f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801aa4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801aa9:	74 1d                	je     801ac8 <strncmp+0x49>
  801aab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aaf:	0f b6 00             	movzbl (%rax),%eax
  801ab2:	84 c0                	test   %al,%al
  801ab4:	74 12                	je     801ac8 <strncmp+0x49>
  801ab6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aba:	0f b6 10             	movzbl (%rax),%edx
  801abd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ac1:	0f b6 00             	movzbl (%rax),%eax
  801ac4:	38 c2                	cmp    %al,%dl
  801ac6:	74 cd                	je     801a95 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801ac8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801acd:	75 07                	jne    801ad6 <strncmp+0x57>
		return 0;
  801acf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad4:	eb 18                	jmp    801aee <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801ad6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ada:	0f b6 00             	movzbl (%rax),%eax
  801add:	0f b6 d0             	movzbl %al,%edx
  801ae0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ae4:	0f b6 00             	movzbl (%rax),%eax
  801ae7:	0f b6 c0             	movzbl %al,%eax
  801aea:	29 c2                	sub    %eax,%edx
  801aec:	89 d0                	mov    %edx,%eax
}
  801aee:	c9                   	leaveq 
  801aef:	c3                   	retq   

0000000000801af0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801af0:	55                   	push   %rbp
  801af1:	48 89 e5             	mov    %rsp,%rbp
  801af4:	48 83 ec 0c          	sub    $0xc,%rsp
  801af8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801afc:	89 f0                	mov    %esi,%eax
  801afe:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b01:	eb 17                	jmp    801b1a <strchr+0x2a>
		if (*s == c)
  801b03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b07:	0f b6 00             	movzbl (%rax),%eax
  801b0a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b0d:	75 06                	jne    801b15 <strchr+0x25>
			return (char *) s;
  801b0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b13:	eb 15                	jmp    801b2a <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b15:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b1e:	0f b6 00             	movzbl (%rax),%eax
  801b21:	84 c0                	test   %al,%al
  801b23:	75 de                	jne    801b03 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801b25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2a:	c9                   	leaveq 
  801b2b:	c3                   	retq   

0000000000801b2c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b2c:	55                   	push   %rbp
  801b2d:	48 89 e5             	mov    %rsp,%rbp
  801b30:	48 83 ec 0c          	sub    $0xc,%rsp
  801b34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b38:	89 f0                	mov    %esi,%eax
  801b3a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b3d:	eb 13                	jmp    801b52 <strfind+0x26>
		if (*s == c)
  801b3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b43:	0f b6 00             	movzbl (%rax),%eax
  801b46:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b49:	75 02                	jne    801b4d <strfind+0x21>
			break;
  801b4b:	eb 10                	jmp    801b5d <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b4d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b56:	0f b6 00             	movzbl (%rax),%eax
  801b59:	84 c0                	test   %al,%al
  801b5b:	75 e2                	jne    801b3f <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801b5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b61:	c9                   	leaveq 
  801b62:	c3                   	retq   

0000000000801b63 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b63:	55                   	push   %rbp
  801b64:	48 89 e5             	mov    %rsp,%rbp
  801b67:	48 83 ec 18          	sub    $0x18,%rsp
  801b6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b6f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801b72:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801b76:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b7b:	75 06                	jne    801b83 <memset+0x20>
		return v;
  801b7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b81:	eb 69                	jmp    801bec <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801b83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b87:	83 e0 03             	and    $0x3,%eax
  801b8a:	48 85 c0             	test   %rax,%rax
  801b8d:	75 48                	jne    801bd7 <memset+0x74>
  801b8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b93:	83 e0 03             	and    $0x3,%eax
  801b96:	48 85 c0             	test   %rax,%rax
  801b99:	75 3c                	jne    801bd7 <memset+0x74>
		c &= 0xFF;
  801b9b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801ba2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ba5:	c1 e0 18             	shl    $0x18,%eax
  801ba8:	89 c2                	mov    %eax,%edx
  801baa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bad:	c1 e0 10             	shl    $0x10,%eax
  801bb0:	09 c2                	or     %eax,%edx
  801bb2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bb5:	c1 e0 08             	shl    $0x8,%eax
  801bb8:	09 d0                	or     %edx,%eax
  801bba:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801bbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc1:	48 c1 e8 02          	shr    $0x2,%rax
  801bc5:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801bc8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bcc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bcf:	48 89 d7             	mov    %rdx,%rdi
  801bd2:	fc                   	cld    
  801bd3:	f3 ab                	rep stos %eax,%es:(%rdi)
  801bd5:	eb 11                	jmp    801be8 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801bd7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bdb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bde:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801be2:	48 89 d7             	mov    %rdx,%rdi
  801be5:	fc                   	cld    
  801be6:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801be8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801bec:	c9                   	leaveq 
  801bed:	c3                   	retq   

0000000000801bee <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801bee:	55                   	push   %rbp
  801bef:	48 89 e5             	mov    %rsp,%rbp
  801bf2:	48 83 ec 28          	sub    $0x28,%rsp
  801bf6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bfa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bfe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801c02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c06:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801c0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c0e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801c12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c16:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c1a:	0f 83 88 00 00 00    	jae    801ca8 <memmove+0xba>
  801c20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c24:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c28:	48 01 d0             	add    %rdx,%rax
  801c2b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c2f:	76 77                	jbe    801ca8 <memmove+0xba>
		s += n;
  801c31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c35:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801c39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c3d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801c41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c45:	83 e0 03             	and    $0x3,%eax
  801c48:	48 85 c0             	test   %rax,%rax
  801c4b:	75 3b                	jne    801c88 <memmove+0x9a>
  801c4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c51:	83 e0 03             	and    $0x3,%eax
  801c54:	48 85 c0             	test   %rax,%rax
  801c57:	75 2f                	jne    801c88 <memmove+0x9a>
  801c59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c5d:	83 e0 03             	and    $0x3,%eax
  801c60:	48 85 c0             	test   %rax,%rax
  801c63:	75 23                	jne    801c88 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801c65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c69:	48 83 e8 04          	sub    $0x4,%rax
  801c6d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c71:	48 83 ea 04          	sub    $0x4,%rdx
  801c75:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801c79:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801c7d:	48 89 c7             	mov    %rax,%rdi
  801c80:	48 89 d6             	mov    %rdx,%rsi
  801c83:	fd                   	std    
  801c84:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801c86:	eb 1d                	jmp    801ca5 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801c88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c8c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801c90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c94:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801c98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c9c:	48 89 d7             	mov    %rdx,%rdi
  801c9f:	48 89 c1             	mov    %rax,%rcx
  801ca2:	fd                   	std    
  801ca3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ca5:	fc                   	cld    
  801ca6:	eb 57                	jmp    801cff <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801ca8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cac:	83 e0 03             	and    $0x3,%eax
  801caf:	48 85 c0             	test   %rax,%rax
  801cb2:	75 36                	jne    801cea <memmove+0xfc>
  801cb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cb8:	83 e0 03             	and    $0x3,%eax
  801cbb:	48 85 c0             	test   %rax,%rax
  801cbe:	75 2a                	jne    801cea <memmove+0xfc>
  801cc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cc4:	83 e0 03             	and    $0x3,%eax
  801cc7:	48 85 c0             	test   %rax,%rax
  801cca:	75 1e                	jne    801cea <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801ccc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd0:	48 c1 e8 02          	shr    $0x2,%rax
  801cd4:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801cd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cdb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cdf:	48 89 c7             	mov    %rax,%rdi
  801ce2:	48 89 d6             	mov    %rdx,%rsi
  801ce5:	fc                   	cld    
  801ce6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801ce8:	eb 15                	jmp    801cff <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801cea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cf2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801cf6:	48 89 c7             	mov    %rax,%rdi
  801cf9:	48 89 d6             	mov    %rdx,%rsi
  801cfc:	fc                   	cld    
  801cfd:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801cff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d03:	c9                   	leaveq 
  801d04:	c3                   	retq   

0000000000801d05 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d05:	55                   	push   %rbp
  801d06:	48 89 e5             	mov    %rsp,%rbp
  801d09:	48 83 ec 18          	sub    $0x18,%rsp
  801d0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d15:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801d19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d1d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d25:	48 89 ce             	mov    %rcx,%rsi
  801d28:	48 89 c7             	mov    %rax,%rdi
  801d2b:	48 b8 ee 1b 80 00 00 	movabs $0x801bee,%rax
  801d32:	00 00 00 
  801d35:	ff d0                	callq  *%rax
}
  801d37:	c9                   	leaveq 
  801d38:	c3                   	retq   

0000000000801d39 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d39:	55                   	push   %rbp
  801d3a:	48 89 e5             	mov    %rsp,%rbp
  801d3d:	48 83 ec 28          	sub    $0x28,%rsp
  801d41:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d45:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d49:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801d4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d51:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801d55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d59:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801d5d:	eb 36                	jmp    801d95 <memcmp+0x5c>
		if (*s1 != *s2)
  801d5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d63:	0f b6 10             	movzbl (%rax),%edx
  801d66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d6a:	0f b6 00             	movzbl (%rax),%eax
  801d6d:	38 c2                	cmp    %al,%dl
  801d6f:	74 1a                	je     801d8b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801d71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d75:	0f b6 00             	movzbl (%rax),%eax
  801d78:	0f b6 d0             	movzbl %al,%edx
  801d7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d7f:	0f b6 00             	movzbl (%rax),%eax
  801d82:	0f b6 c0             	movzbl %al,%eax
  801d85:	29 c2                	sub    %eax,%edx
  801d87:	89 d0                	mov    %edx,%eax
  801d89:	eb 20                	jmp    801dab <memcmp+0x72>
		s1++, s2++;
  801d8b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d90:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801d95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d99:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801d9d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801da1:	48 85 c0             	test   %rax,%rax
  801da4:	75 b9                	jne    801d5f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801da6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dab:	c9                   	leaveq 
  801dac:	c3                   	retq   

0000000000801dad <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dad:	55                   	push   %rbp
  801dae:	48 89 e5             	mov    %rsp,%rbp
  801db1:	48 83 ec 28          	sub    $0x28,%rsp
  801db5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801db9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801dbc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801dc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dc4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801dc8:	48 01 d0             	add    %rdx,%rax
  801dcb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801dcf:	eb 15                	jmp    801de6 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd5:	0f b6 10             	movzbl (%rax),%edx
  801dd8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ddb:	38 c2                	cmp    %al,%dl
  801ddd:	75 02                	jne    801de1 <memfind+0x34>
			break;
  801ddf:	eb 0f                	jmp    801df0 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801de1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801de6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dea:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801dee:	72 e1                	jb     801dd1 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801df0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801df4:	c9                   	leaveq 
  801df5:	c3                   	retq   

0000000000801df6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801df6:	55                   	push   %rbp
  801df7:	48 89 e5             	mov    %rsp,%rbp
  801dfa:	48 83 ec 34          	sub    $0x34,%rsp
  801dfe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e02:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801e06:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801e09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801e10:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801e17:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e18:	eb 05                	jmp    801e1f <strtol+0x29>
		s++;
  801e1a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e23:	0f b6 00             	movzbl (%rax),%eax
  801e26:	3c 20                	cmp    $0x20,%al
  801e28:	74 f0                	je     801e1a <strtol+0x24>
  801e2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2e:	0f b6 00             	movzbl (%rax),%eax
  801e31:	3c 09                	cmp    $0x9,%al
  801e33:	74 e5                	je     801e1a <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801e35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e39:	0f b6 00             	movzbl (%rax),%eax
  801e3c:	3c 2b                	cmp    $0x2b,%al
  801e3e:	75 07                	jne    801e47 <strtol+0x51>
		s++;
  801e40:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e45:	eb 17                	jmp    801e5e <strtol+0x68>
	else if (*s == '-')
  801e47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e4b:	0f b6 00             	movzbl (%rax),%eax
  801e4e:	3c 2d                	cmp    $0x2d,%al
  801e50:	75 0c                	jne    801e5e <strtol+0x68>
		s++, neg = 1;
  801e52:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e57:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e5e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e62:	74 06                	je     801e6a <strtol+0x74>
  801e64:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801e68:	75 28                	jne    801e92 <strtol+0x9c>
  801e6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e6e:	0f b6 00             	movzbl (%rax),%eax
  801e71:	3c 30                	cmp    $0x30,%al
  801e73:	75 1d                	jne    801e92 <strtol+0x9c>
  801e75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e79:	48 83 c0 01          	add    $0x1,%rax
  801e7d:	0f b6 00             	movzbl (%rax),%eax
  801e80:	3c 78                	cmp    $0x78,%al
  801e82:	75 0e                	jne    801e92 <strtol+0x9c>
		s += 2, base = 16;
  801e84:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801e89:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801e90:	eb 2c                	jmp    801ebe <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801e92:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e96:	75 19                	jne    801eb1 <strtol+0xbb>
  801e98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e9c:	0f b6 00             	movzbl (%rax),%eax
  801e9f:	3c 30                	cmp    $0x30,%al
  801ea1:	75 0e                	jne    801eb1 <strtol+0xbb>
		s++, base = 8;
  801ea3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ea8:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801eaf:	eb 0d                	jmp    801ebe <strtol+0xc8>
	else if (base == 0)
  801eb1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801eb5:	75 07                	jne    801ebe <strtol+0xc8>
		base = 10;
  801eb7:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ebe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec2:	0f b6 00             	movzbl (%rax),%eax
  801ec5:	3c 2f                	cmp    $0x2f,%al
  801ec7:	7e 1d                	jle    801ee6 <strtol+0xf0>
  801ec9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ecd:	0f b6 00             	movzbl (%rax),%eax
  801ed0:	3c 39                	cmp    $0x39,%al
  801ed2:	7f 12                	jg     801ee6 <strtol+0xf0>
			dig = *s - '0';
  801ed4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed8:	0f b6 00             	movzbl (%rax),%eax
  801edb:	0f be c0             	movsbl %al,%eax
  801ede:	83 e8 30             	sub    $0x30,%eax
  801ee1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ee4:	eb 4e                	jmp    801f34 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801ee6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eea:	0f b6 00             	movzbl (%rax),%eax
  801eed:	3c 60                	cmp    $0x60,%al
  801eef:	7e 1d                	jle    801f0e <strtol+0x118>
  801ef1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef5:	0f b6 00             	movzbl (%rax),%eax
  801ef8:	3c 7a                	cmp    $0x7a,%al
  801efa:	7f 12                	jg     801f0e <strtol+0x118>
			dig = *s - 'a' + 10;
  801efc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f00:	0f b6 00             	movzbl (%rax),%eax
  801f03:	0f be c0             	movsbl %al,%eax
  801f06:	83 e8 57             	sub    $0x57,%eax
  801f09:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f0c:	eb 26                	jmp    801f34 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801f0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f12:	0f b6 00             	movzbl (%rax),%eax
  801f15:	3c 40                	cmp    $0x40,%al
  801f17:	7e 48                	jle    801f61 <strtol+0x16b>
  801f19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1d:	0f b6 00             	movzbl (%rax),%eax
  801f20:	3c 5a                	cmp    $0x5a,%al
  801f22:	7f 3d                	jg     801f61 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801f24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f28:	0f b6 00             	movzbl (%rax),%eax
  801f2b:	0f be c0             	movsbl %al,%eax
  801f2e:	83 e8 37             	sub    $0x37,%eax
  801f31:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801f34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f37:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801f3a:	7c 02                	jl     801f3e <strtol+0x148>
			break;
  801f3c:	eb 23                	jmp    801f61 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801f3e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f43:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f46:	48 98                	cltq   
  801f48:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801f4d:	48 89 c2             	mov    %rax,%rdx
  801f50:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f53:	48 98                	cltq   
  801f55:	48 01 d0             	add    %rdx,%rax
  801f58:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801f5c:	e9 5d ff ff ff       	jmpq   801ebe <strtol+0xc8>

	if (endptr)
  801f61:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801f66:	74 0b                	je     801f73 <strtol+0x17d>
		*endptr = (char *) s;
  801f68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f6c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f70:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801f73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f77:	74 09                	je     801f82 <strtol+0x18c>
  801f79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f7d:	48 f7 d8             	neg    %rax
  801f80:	eb 04                	jmp    801f86 <strtol+0x190>
  801f82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801f86:	c9                   	leaveq 
  801f87:	c3                   	retq   

0000000000801f88 <strstr>:

char * strstr(const char *in, const char *str)
{
  801f88:	55                   	push   %rbp
  801f89:	48 89 e5             	mov    %rsp,%rbp
  801f8c:	48 83 ec 30          	sub    $0x30,%rsp
  801f90:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f94:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801f98:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f9c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801fa0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801fa4:	0f b6 00             	movzbl (%rax),%eax
  801fa7:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801faa:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801fae:	75 06                	jne    801fb6 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801fb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb4:	eb 6b                	jmp    802021 <strstr+0x99>

    len = strlen(str);
  801fb6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fba:	48 89 c7             	mov    %rax,%rdi
  801fbd:	48 b8 5e 18 80 00 00 	movabs $0x80185e,%rax
  801fc4:	00 00 00 
  801fc7:	ff d0                	callq  *%rax
  801fc9:	48 98                	cltq   
  801fcb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801fcf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801fd7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801fdb:	0f b6 00             	movzbl (%rax),%eax
  801fde:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801fe1:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801fe5:	75 07                	jne    801fee <strstr+0x66>
                return (char *) 0;
  801fe7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fec:	eb 33                	jmp    802021 <strstr+0x99>
        } while (sc != c);
  801fee:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801ff2:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801ff5:	75 d8                	jne    801fcf <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801ff7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ffb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801fff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802003:	48 89 ce             	mov    %rcx,%rsi
  802006:	48 89 c7             	mov    %rax,%rdi
  802009:	48 b8 7f 1a 80 00 00 	movabs $0x801a7f,%rax
  802010:	00 00 00 
  802013:	ff d0                	callq  *%rax
  802015:	85 c0                	test   %eax,%eax
  802017:	75 b6                	jne    801fcf <strstr+0x47>

    return (char *) (in - 1);
  802019:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80201d:	48 83 e8 01          	sub    $0x1,%rax
}
  802021:	c9                   	leaveq 
  802022:	c3                   	retq   

0000000000802023 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  802023:	55                   	push   %rbp
  802024:	48 89 e5             	mov    %rsp,%rbp
  802027:	53                   	push   %rbx
  802028:	48 83 ec 48          	sub    $0x48,%rsp
  80202c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80202f:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802032:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802036:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80203a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80203e:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802042:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802045:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802049:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80204d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802051:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802055:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802059:	4c 89 c3             	mov    %r8,%rbx
  80205c:	cd 30                	int    $0x30
  80205e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  802062:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802066:	74 3e                	je     8020a6 <syscall+0x83>
  802068:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80206d:	7e 37                	jle    8020a6 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80206f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802073:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802076:	49 89 d0             	mov    %rdx,%r8
  802079:	89 c1                	mov    %eax,%ecx
  80207b:	48 ba e0 52 80 00 00 	movabs $0x8052e0,%rdx
  802082:	00 00 00 
  802085:	be 23 00 00 00       	mov    $0x23,%esi
  80208a:	48 bf fd 52 80 00 00 	movabs $0x8052fd,%rdi
  802091:	00 00 00 
  802094:	b8 00 00 00 00       	mov    $0x0,%eax
  802099:	49 b9 e9 08 80 00 00 	movabs $0x8008e9,%r9
  8020a0:	00 00 00 
  8020a3:	41 ff d1             	callq  *%r9

	return ret;
  8020a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8020aa:	48 83 c4 48          	add    $0x48,%rsp
  8020ae:	5b                   	pop    %rbx
  8020af:	5d                   	pop    %rbp
  8020b0:	c3                   	retq   

00000000008020b1 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8020b1:	55                   	push   %rbp
  8020b2:	48 89 e5             	mov    %rsp,%rbp
  8020b5:	48 83 ec 20          	sub    $0x20,%rsp
  8020b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8020c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020c9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020d0:	00 
  8020d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020dd:	48 89 d1             	mov    %rdx,%rcx
  8020e0:	48 89 c2             	mov    %rax,%rdx
  8020e3:	be 00 00 00 00       	mov    $0x0,%esi
  8020e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8020ed:	48 b8 23 20 80 00 00 	movabs $0x802023,%rax
  8020f4:	00 00 00 
  8020f7:	ff d0                	callq  *%rax
}
  8020f9:	c9                   	leaveq 
  8020fa:	c3                   	retq   

00000000008020fb <sys_cgetc>:

int
sys_cgetc(void)
{
  8020fb:	55                   	push   %rbp
  8020fc:	48 89 e5             	mov    %rsp,%rbp
  8020ff:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802103:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80210a:	00 
  80210b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802111:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802117:	b9 00 00 00 00       	mov    $0x0,%ecx
  80211c:	ba 00 00 00 00       	mov    $0x0,%edx
  802121:	be 00 00 00 00       	mov    $0x0,%esi
  802126:	bf 01 00 00 00       	mov    $0x1,%edi
  80212b:	48 b8 23 20 80 00 00 	movabs $0x802023,%rax
  802132:	00 00 00 
  802135:	ff d0                	callq  *%rax
}
  802137:	c9                   	leaveq 
  802138:	c3                   	retq   

0000000000802139 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802139:	55                   	push   %rbp
  80213a:	48 89 e5             	mov    %rsp,%rbp
  80213d:	48 83 ec 10          	sub    $0x10,%rsp
  802141:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802144:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802147:	48 98                	cltq   
  802149:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802150:	00 
  802151:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802157:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80215d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802162:	48 89 c2             	mov    %rax,%rdx
  802165:	be 01 00 00 00       	mov    $0x1,%esi
  80216a:	bf 03 00 00 00       	mov    $0x3,%edi
  80216f:	48 b8 23 20 80 00 00 	movabs $0x802023,%rax
  802176:	00 00 00 
  802179:	ff d0                	callq  *%rax
}
  80217b:	c9                   	leaveq 
  80217c:	c3                   	retq   

000000000080217d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80217d:	55                   	push   %rbp
  80217e:	48 89 e5             	mov    %rsp,%rbp
  802181:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802185:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80218c:	00 
  80218d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802193:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802199:	b9 00 00 00 00       	mov    $0x0,%ecx
  80219e:	ba 00 00 00 00       	mov    $0x0,%edx
  8021a3:	be 00 00 00 00       	mov    $0x0,%esi
  8021a8:	bf 02 00 00 00       	mov    $0x2,%edi
  8021ad:	48 b8 23 20 80 00 00 	movabs $0x802023,%rax
  8021b4:	00 00 00 
  8021b7:	ff d0                	callq  *%rax
}
  8021b9:	c9                   	leaveq 
  8021ba:	c3                   	retq   

00000000008021bb <sys_yield>:

void
sys_yield(void)
{
  8021bb:	55                   	push   %rbp
  8021bc:	48 89 e5             	mov    %rsp,%rbp
  8021bf:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8021c3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021ca:	00 
  8021cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e1:	be 00 00 00 00       	mov    $0x0,%esi
  8021e6:	bf 0b 00 00 00       	mov    $0xb,%edi
  8021eb:	48 b8 23 20 80 00 00 	movabs $0x802023,%rax
  8021f2:	00 00 00 
  8021f5:	ff d0                	callq  *%rax
}
  8021f7:	c9                   	leaveq 
  8021f8:	c3                   	retq   

00000000008021f9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8021f9:	55                   	push   %rbp
  8021fa:	48 89 e5             	mov    %rsp,%rbp
  8021fd:	48 83 ec 20          	sub    $0x20,%rsp
  802201:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802204:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802208:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80220b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80220e:	48 63 c8             	movslq %eax,%rcx
  802211:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802215:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802218:	48 98                	cltq   
  80221a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802221:	00 
  802222:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802228:	49 89 c8             	mov    %rcx,%r8
  80222b:	48 89 d1             	mov    %rdx,%rcx
  80222e:	48 89 c2             	mov    %rax,%rdx
  802231:	be 01 00 00 00       	mov    $0x1,%esi
  802236:	bf 04 00 00 00       	mov    $0x4,%edi
  80223b:	48 b8 23 20 80 00 00 	movabs $0x802023,%rax
  802242:	00 00 00 
  802245:	ff d0                	callq  *%rax
}
  802247:	c9                   	leaveq 
  802248:	c3                   	retq   

0000000000802249 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802249:	55                   	push   %rbp
  80224a:	48 89 e5             	mov    %rsp,%rbp
  80224d:	48 83 ec 30          	sub    $0x30,%rsp
  802251:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802254:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802258:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80225b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80225f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802263:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802266:	48 63 c8             	movslq %eax,%rcx
  802269:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80226d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802270:	48 63 f0             	movslq %eax,%rsi
  802273:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802277:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80227a:	48 98                	cltq   
  80227c:	48 89 0c 24          	mov    %rcx,(%rsp)
  802280:	49 89 f9             	mov    %rdi,%r9
  802283:	49 89 f0             	mov    %rsi,%r8
  802286:	48 89 d1             	mov    %rdx,%rcx
  802289:	48 89 c2             	mov    %rax,%rdx
  80228c:	be 01 00 00 00       	mov    $0x1,%esi
  802291:	bf 05 00 00 00       	mov    $0x5,%edi
  802296:	48 b8 23 20 80 00 00 	movabs $0x802023,%rax
  80229d:	00 00 00 
  8022a0:	ff d0                	callq  *%rax
}
  8022a2:	c9                   	leaveq 
  8022a3:	c3                   	retq   

00000000008022a4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8022a4:	55                   	push   %rbp
  8022a5:	48 89 e5             	mov    %rsp,%rbp
  8022a8:	48 83 ec 20          	sub    $0x20,%rsp
  8022ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8022b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ba:	48 98                	cltq   
  8022bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022c3:	00 
  8022c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022d0:	48 89 d1             	mov    %rdx,%rcx
  8022d3:	48 89 c2             	mov    %rax,%rdx
  8022d6:	be 01 00 00 00       	mov    $0x1,%esi
  8022db:	bf 06 00 00 00       	mov    $0x6,%edi
  8022e0:	48 b8 23 20 80 00 00 	movabs $0x802023,%rax
  8022e7:	00 00 00 
  8022ea:	ff d0                	callq  *%rax
}
  8022ec:	c9                   	leaveq 
  8022ed:	c3                   	retq   

00000000008022ee <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8022ee:	55                   	push   %rbp
  8022ef:	48 89 e5             	mov    %rsp,%rbp
  8022f2:	48 83 ec 10          	sub    $0x10,%rsp
  8022f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022f9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8022fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022ff:	48 63 d0             	movslq %eax,%rdx
  802302:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802305:	48 98                	cltq   
  802307:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80230e:	00 
  80230f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802315:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80231b:	48 89 d1             	mov    %rdx,%rcx
  80231e:	48 89 c2             	mov    %rax,%rdx
  802321:	be 01 00 00 00       	mov    $0x1,%esi
  802326:	bf 08 00 00 00       	mov    $0x8,%edi
  80232b:	48 b8 23 20 80 00 00 	movabs $0x802023,%rax
  802332:	00 00 00 
  802335:	ff d0                	callq  *%rax
}
  802337:	c9                   	leaveq 
  802338:	c3                   	retq   

0000000000802339 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802339:	55                   	push   %rbp
  80233a:	48 89 e5             	mov    %rsp,%rbp
  80233d:	48 83 ec 20          	sub    $0x20,%rsp
  802341:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802344:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802348:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80234c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80234f:	48 98                	cltq   
  802351:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802358:	00 
  802359:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80235f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802365:	48 89 d1             	mov    %rdx,%rcx
  802368:	48 89 c2             	mov    %rax,%rdx
  80236b:	be 01 00 00 00       	mov    $0x1,%esi
  802370:	bf 09 00 00 00       	mov    $0x9,%edi
  802375:	48 b8 23 20 80 00 00 	movabs $0x802023,%rax
  80237c:	00 00 00 
  80237f:	ff d0                	callq  *%rax
}
  802381:	c9                   	leaveq 
  802382:	c3                   	retq   

0000000000802383 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802383:	55                   	push   %rbp
  802384:	48 89 e5             	mov    %rsp,%rbp
  802387:	48 83 ec 20          	sub    $0x20,%rsp
  80238b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80238e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802392:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802396:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802399:	48 98                	cltq   
  80239b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023a2:	00 
  8023a3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023af:	48 89 d1             	mov    %rdx,%rcx
  8023b2:	48 89 c2             	mov    %rax,%rdx
  8023b5:	be 01 00 00 00       	mov    $0x1,%esi
  8023ba:	bf 0a 00 00 00       	mov    $0xa,%edi
  8023bf:	48 b8 23 20 80 00 00 	movabs $0x802023,%rax
  8023c6:	00 00 00 
  8023c9:	ff d0                	callq  *%rax
}
  8023cb:	c9                   	leaveq 
  8023cc:	c3                   	retq   

00000000008023cd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8023cd:	55                   	push   %rbp
  8023ce:	48 89 e5             	mov    %rsp,%rbp
  8023d1:	48 83 ec 20          	sub    $0x20,%rsp
  8023d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8023dc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8023e0:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8023e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023e6:	48 63 f0             	movslq %eax,%rsi
  8023e9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f0:	48 98                	cltq   
  8023f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023f6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023fd:	00 
  8023fe:	49 89 f1             	mov    %rsi,%r9
  802401:	49 89 c8             	mov    %rcx,%r8
  802404:	48 89 d1             	mov    %rdx,%rcx
  802407:	48 89 c2             	mov    %rax,%rdx
  80240a:	be 00 00 00 00       	mov    $0x0,%esi
  80240f:	bf 0c 00 00 00       	mov    $0xc,%edi
  802414:	48 b8 23 20 80 00 00 	movabs $0x802023,%rax
  80241b:	00 00 00 
  80241e:	ff d0                	callq  *%rax
}
  802420:	c9                   	leaveq 
  802421:	c3                   	retq   

0000000000802422 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802422:	55                   	push   %rbp
  802423:	48 89 e5             	mov    %rsp,%rbp
  802426:	48 83 ec 10          	sub    $0x10,%rsp
  80242a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80242e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802432:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802439:	00 
  80243a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802440:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802446:	b9 00 00 00 00       	mov    $0x0,%ecx
  80244b:	48 89 c2             	mov    %rax,%rdx
  80244e:	be 01 00 00 00       	mov    $0x1,%esi
  802453:	bf 0d 00 00 00       	mov    $0xd,%edi
  802458:	48 b8 23 20 80 00 00 	movabs $0x802023,%rax
  80245f:	00 00 00 
  802462:	ff d0                	callq  *%rax
}
  802464:	c9                   	leaveq 
  802465:	c3                   	retq   

0000000000802466 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802466:	55                   	push   %rbp
  802467:	48 89 e5             	mov    %rsp,%rbp
  80246a:	48 83 ec 30          	sub    $0x30,%rsp
  80246e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802472:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802476:	48 8b 00             	mov    (%rax),%rax
  802479:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  80247d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802481:	48 8b 40 08          	mov    0x8(%rax),%rax
  802485:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[VPN(addr)] & PTE_COW)))
  802488:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80248b:	83 e0 02             	and    $0x2,%eax
  80248e:	85 c0                	test   %eax,%eax
  802490:	74 23                	je     8024b5 <pgfault+0x4f>
  802492:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802496:	48 c1 e8 0c          	shr    $0xc,%rax
  80249a:	48 89 c2             	mov    %rax,%rdx
  80249d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024a4:	01 00 00 
  8024a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024ab:	25 00 08 00 00       	and    $0x800,%eax
  8024b0:	48 85 c0             	test   %rax,%rax
  8024b3:	75 2a                	jne    8024df <pgfault+0x79>
		panic("fail check at fork pgfault");
  8024b5:	48 ba 0b 53 80 00 00 	movabs $0x80530b,%rdx
  8024bc:	00 00 00 
  8024bf:	be 1d 00 00 00       	mov    $0x1d,%esi
  8024c4:	48 bf 26 53 80 00 00 	movabs $0x805326,%rdi
  8024cb:	00 00 00 
  8024ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d3:	48 b9 e9 08 80 00 00 	movabs $0x8008e9,%rcx
  8024da:	00 00 00 
  8024dd:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8024df:	ba 07 00 00 00       	mov    $0x7,%edx
  8024e4:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8024e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ee:	48 b8 f9 21 80 00 00 	movabs $0x8021f9,%rax
  8024f5:	00 00 00 
  8024f8:	ff d0                	callq  *%rax

	addr = ROUNDDOWN(addr, PGSIZE);
  8024fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024fe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802502:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802506:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80250c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	memmove(PFTEMP, addr, PGSIZE);
  802510:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802514:	ba 00 10 00 00       	mov    $0x1000,%edx
  802519:	48 89 c6             	mov    %rax,%rsi
  80251c:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802521:	48 b8 ee 1b 80 00 00 	movabs $0x801bee,%rax
  802528:	00 00 00 
  80252b:	ff d0                	callq  *%rax

	sys_page_map(0, (void *)PFTEMP, 0, addr, PTE_P | PTE_U | PTE_W);
  80252d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802531:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802537:	48 89 c1             	mov    %rax,%rcx
  80253a:	ba 00 00 00 00       	mov    $0x0,%edx
  80253f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802544:	bf 00 00 00 00       	mov    $0x0,%edi
  802549:	48 b8 49 22 80 00 00 	movabs $0x802249,%rax
  802550:	00 00 00 
  802553:	ff d0                	callq  *%rax
	sys_page_unmap(0, PFTEMP);
  802555:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80255a:	bf 00 00 00 00       	mov    $0x0,%edi
  80255f:	48 b8 a4 22 80 00 00 	movabs $0x8022a4,%rax
  802566:	00 00 00 
  802569:	ff d0                	callq  *%rax
	//panic("pgfault not implemented");
}
  80256b:	c9                   	leaveq 
  80256c:	c3                   	retq   

000000000080256d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80256d:	55                   	push   %rbp
  80256e:	48 89 e5             	mov    %rsp,%rbp
  802571:	48 83 ec 20          	sub    $0x20,%rsp
  802575:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802578:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;

	// LAB 4: Your code here.
	void *addr = (void *)((uintptr_t)pn * PGSIZE);
  80257b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80257e:	48 c1 e0 0c          	shl    $0xc,%rax
  802582:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	// note: modified for LAB 5, supporting PTE_SHARE
	if (uvpt[pn] & PTE_SHARE) {
  802586:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80258d:	01 00 00 
  802590:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802593:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802597:	25 00 04 00 00       	and    $0x400,%eax
  80259c:	48 85 c0             	test   %rax,%rax
  80259f:	74 55                	je     8025f6 <duppage+0x89>
		if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL))) < 0)
  8025a1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025a8:	01 00 00 
  8025ab:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8025b7:	89 c6                	mov    %eax,%esi
  8025b9:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8025bd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8025c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025c4:	41 89 f0             	mov    %esi,%r8d
  8025c7:	48 89 c6             	mov    %rax,%rsi
  8025ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8025cf:	48 b8 49 22 80 00 00 	movabs $0x802249,%rax
  8025d6:	00 00 00 
  8025d9:	ff d0                	callq  *%rax
  8025db:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8025de:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8025e2:	79 08                	jns    8025ec <duppage+0x7f>
			return r;
  8025e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025e7:	e9 e1 00 00 00       	jmpq   8026cd <duppage+0x160>
		return 0;
  8025ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f1:	e9 d7 00 00 00       	jmpq   8026cd <duppage+0x160>
	}

	// note: here we must set ~PTE_W and PTE_COW such that parent process can get correct pid
	if ((r = sys_page_map(0, addr, envid, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  8025f6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025fd:	01 00 00 
  802600:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802603:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802607:	25 05 06 00 00       	and    $0x605,%eax
  80260c:	80 cc 08             	or     $0x8,%ah
  80260f:	89 c6                	mov    %eax,%esi
  802611:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802615:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802618:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80261c:	41 89 f0             	mov    %esi,%r8d
  80261f:	48 89 c6             	mov    %rax,%rsi
  802622:	bf 00 00 00 00       	mov    $0x0,%edi
  802627:	48 b8 49 22 80 00 00 	movabs $0x802249,%rax
  80262e:	00 00 00 
  802631:	ff d0                	callq  *%rax
  802633:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802636:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80263a:	79 08                	jns    802644 <duppage+0xd7>
		return r;
  80263c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80263f:	e9 89 00 00 00       	jmpq   8026cd <duppage+0x160>

	if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  802644:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80264b:	01 00 00 
  80264e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802651:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802655:	83 e0 02             	and    $0x2,%eax
  802658:	48 85 c0             	test   %rax,%rax
  80265b:	75 1b                	jne    802678 <duppage+0x10b>
  80265d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802664:	01 00 00 
  802667:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80266a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80266e:	25 00 08 00 00       	and    $0x800,%eax
  802673:	48 85 c0             	test   %rax,%rax
  802676:	74 50                	je     8026c8 <duppage+0x15b>
		if ((r = sys_page_map(0, addr, 0, addr, (uvpt[pn] & PTE_SYSCALL & ~PTE_W) | PTE_COW)) < 0)
  802678:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80267f:	01 00 00 
  802682:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802685:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802689:	25 05 06 00 00       	and    $0x605,%eax
  80268e:	80 cc 08             	or     $0x8,%ah
  802691:	89 c1                	mov    %eax,%ecx
  802693:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802697:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80269b:	41 89 c8             	mov    %ecx,%r8d
  80269e:	48 89 d1             	mov    %rdx,%rcx
  8026a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a6:	48 89 c6             	mov    %rax,%rsi
  8026a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ae:	48 b8 49 22 80 00 00 	movabs $0x802249,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	callq  *%rax
  8026ba:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8026bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8026c1:	79 05                	jns    8026c8 <duppage+0x15b>
			return r;
  8026c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8026c6:	eb 05                	jmp    8026cd <duppage+0x160>
	//panic("duppage not implemented");
	return 0;
  8026c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026cd:	c9                   	leaveq 
  8026ce:	c3                   	retq   

00000000008026cf <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8026cf:	55                   	push   %rbp
  8026d0:	48 89 e5             	mov    %rsp,%rbp
  8026d3:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	int r;
	envid_t envid;
	int i, j, k, l, ptx = 0;
  8026d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	set_pgfault_handler(pgfault);
  8026de:	48 bf 66 24 80 00 00 	movabs $0x802466,%rdi
  8026e5:	00 00 00 
  8026e8:	48 b8 3b 49 80 00 00 	movabs $0x80493b,%rax
  8026ef:	00 00 00 
  8026f2:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8026f4:	b8 07 00 00 00       	mov    $0x7,%eax
  8026f9:	cd 30                	int    $0x30
  8026fb:	89 45 e0             	mov    %eax,-0x20(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8026fe:	8b 45 e0             	mov    -0x20(%rbp),%eax

	if ((envid = sys_exofork()) < 0)
  802701:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802704:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802708:	79 08                	jns    802712 <fork+0x43>
		return envid;
  80270a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80270d:	e9 27 02 00 00       	jmpq   802939 <fork+0x26a>
	else if (envid == 0) {
  802712:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802716:	75 46                	jne    80275e <fork+0x8f>
		thisenv = &envs[ENVX(sys_getenvid())];
  802718:	48 b8 7d 21 80 00 00 	movabs $0x80217d,%rax
  80271f:	00 00 00 
  802722:	ff d0                	callq  *%rax
  802724:	25 ff 03 00 00       	and    $0x3ff,%eax
  802729:	48 63 d0             	movslq %eax,%rdx
  80272c:	48 89 d0             	mov    %rdx,%rax
  80272f:	48 c1 e0 03          	shl    $0x3,%rax
  802733:	48 01 d0             	add    %rdx,%rax
  802736:	48 c1 e0 05          	shl    $0x5,%rax
  80273a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802741:	00 00 00 
  802744:	48 01 c2             	add    %rax,%rdx
  802747:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80274e:	00 00 00 
  802751:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802754:	b8 00 00 00 00       	mov    $0x0,%eax
  802759:	e9 db 01 00 00       	jmpq   802939 <fork+0x26a>
	}

	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80275e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802761:	ba 07 00 00 00       	mov    $0x7,%edx
  802766:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80276b:	89 c7                	mov    %eax,%edi
  80276d:	48 b8 f9 21 80 00 00 	movabs $0x8021f9,%rax
  802774:	00 00 00 
  802777:	ff d0                	callq  *%rax
  802779:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80277c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802780:	79 08                	jns    80278a <fork+0xbb>
		return r;
  802782:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802785:	e9 af 01 00 00       	jmpq   802939 <fork+0x26a>

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  80278a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802791:	e9 49 01 00 00       	jmpq   8028df <fork+0x210>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  802796:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802799:	8d 90 ff ff ff 07    	lea    0x7ffffff(%rax),%edx
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	0f 48 c2             	cmovs  %edx,%eax
  8027a4:	c1 f8 1b             	sar    $0x1b,%eax
  8027a7:	89 c2                	mov    %eax,%edx
  8027a9:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8027b0:	01 00 00 
  8027b3:	48 63 d2             	movslq %edx,%rdx
  8027b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027ba:	83 e0 01             	and    $0x1,%eax
  8027bd:	48 85 c0             	test   %rax,%rax
  8027c0:	75 0c                	jne    8027ce <fork+0xff>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  8027c2:	81 45 ec 00 00 00 08 	addl   $0x8000000,-0x14(%rbp)
			continue;
  8027c9:	e9 0d 01 00 00       	jmpq   8028db <fork+0x20c>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  8027ce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8027d5:	e9 f4 00 00 00       	jmpq   8028ce <fork+0x1ff>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  8027da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027dd:	8d 90 ff ff 03 00    	lea    0x3ffff(%rax),%edx
  8027e3:	85 c0                	test   %eax,%eax
  8027e5:	0f 48 c2             	cmovs  %edx,%eax
  8027e8:	c1 f8 12             	sar    $0x12,%eax
  8027eb:	89 c2                	mov    %eax,%edx
  8027ed:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8027f4:	01 00 00 
  8027f7:	48 63 d2             	movslq %edx,%rdx
  8027fa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027fe:	83 e0 01             	and    $0x1,%eax
  802801:	48 85 c0             	test   %rax,%rax
  802804:	75 0c                	jne    802812 <fork+0x143>
				ptx += NPDENTRIES * NPTENTRIES;
  802806:	81 45 ec 00 00 04 00 	addl   $0x40000,-0x14(%rbp)
				continue;
  80280d:	e9 b8 00 00 00       	jmpq   8028ca <fork+0x1fb>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  802812:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  802819:	e9 9f 00 00 00       	jmpq   8028bd <fork+0x1ee>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  80281e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802821:	8d 90 ff 01 00 00    	lea    0x1ff(%rax),%edx
  802827:	85 c0                	test   %eax,%eax
  802829:	0f 48 c2             	cmovs  %edx,%eax
  80282c:	c1 f8 09             	sar    $0x9,%eax
  80282f:	89 c2                	mov    %eax,%edx
  802831:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802838:	01 00 00 
  80283b:	48 63 d2             	movslq %edx,%rdx
  80283e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802842:	83 e0 01             	and    $0x1,%eax
  802845:	48 85 c0             	test   %rax,%rax
  802848:	75 09                	jne    802853 <fork+0x184>
					ptx += NPTENTRIES;
  80284a:	81 45 ec 00 02 00 00 	addl   $0x200,-0x14(%rbp)
					continue;
  802851:	eb 66                	jmp    8028b9 <fork+0x1ea>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  802853:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  80285a:	eb 54                	jmp    8028b0 <fork+0x1e1>
					if ((uvpt[ptx] & PTE_P) != 0)
  80285c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802863:	01 00 00 
  802866:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802869:	48 63 d2             	movslq %edx,%rdx
  80286c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802870:	83 e0 01             	and    $0x1,%eax
  802873:	48 85 c0             	test   %rax,%rax
  802876:	74 30                	je     8028a8 <fork+0x1d9>
						if (ptx != VPN(UXSTACKTOP - PGSIZE))
  802878:	81 7d ec ff f7 0e 00 	cmpl   $0xef7ff,-0x14(%rbp)
  80287f:	74 27                	je     8028a8 <fork+0x1d9>
							if ((r = duppage(envid, ptx)) < 0)
  802881:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802884:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802887:	89 d6                	mov    %edx,%esi
  802889:	89 c7                	mov    %eax,%edi
  80288b:	48 b8 6d 25 80 00 00 	movabs $0x80256d,%rax
  802892:	00 00 00 
  802895:	ff d0                	callq  *%rax
  802897:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80289a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80289e:	79 08                	jns    8028a8 <fork+0x1d9>
								return r;
  8028a0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8028a3:	e9 91 00 00 00       	jmpq   802939 <fork+0x26a>
					ptx++;
  8028a8:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  8028ac:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8028b0:	81 7d f0 ff 01 00 00 	cmpl   $0x1ff,-0x10(%rbp)
  8028b7:	7e a3                	jle    80285c <fork+0x18d>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  8028b9:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8028bd:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%rbp)
  8028c4:	0f 8e 54 ff ff ff    	jle    80281e <fork+0x14f>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  8028ca:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8028ce:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
  8028d5:	0f 8e ff fe ff ff    	jle    8027da <fork+0x10b>
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		return r;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  8028db:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e3:	0f 84 ad fe ff ff    	je     802796 <fork+0xc7>
			}
		}
	}

	extern void _pgfault_upcall();
	if ((r = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0)
  8028e9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8028ec:	48 be a6 49 80 00 00 	movabs $0x8049a6,%rsi
  8028f3:	00 00 00 
  8028f6:	89 c7                	mov    %eax,%edi
  8028f8:	48 b8 83 23 80 00 00 	movabs $0x802383,%rax
  8028ff:	00 00 00 
  802902:	ff d0                	callq  *%rax
  802904:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802907:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80290b:	79 05                	jns    802912 <fork+0x243>
		return r;
  80290d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802910:	eb 27                	jmp    802939 <fork+0x26a>
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802912:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802915:	be 02 00 00 00       	mov    $0x2,%esi
  80291a:	89 c7                	mov    %eax,%edi
  80291c:	48 b8 ee 22 80 00 00 	movabs $0x8022ee,%rax
  802923:	00 00 00 
  802926:	ff d0                	callq  *%rax
  802928:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80292b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80292f:	79 05                	jns    802936 <fork+0x267>
		return r;
  802931:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802934:	eb 03                	jmp    802939 <fork+0x26a>

	return envid;
  802936:	8b 45 e8             	mov    -0x18(%rbp),%eax
	//panic("fork not implemented");
}
  802939:	c9                   	leaveq 
  80293a:	c3                   	retq   

000000000080293b <sfork>:

// Challenge!
int
sfork(void)
{
  80293b:	55                   	push   %rbp
  80293c:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80293f:	48 ba 31 53 80 00 00 	movabs $0x805331,%rdx
  802946:	00 00 00 
  802949:	be a7 00 00 00       	mov    $0xa7,%esi
  80294e:	48 bf 26 53 80 00 00 	movabs $0x805326,%rdi
  802955:	00 00 00 
  802958:	b8 00 00 00 00       	mov    $0x0,%eax
  80295d:	48 b9 e9 08 80 00 00 	movabs $0x8008e9,%rcx
  802964:	00 00 00 
  802967:	ff d1                	callq  *%rcx

0000000000802969 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802969:	55                   	push   %rbp
  80296a:	48 89 e5             	mov    %rsp,%rbp
  80296d:	48 83 ec 08          	sub    $0x8,%rsp
  802971:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802975:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802979:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802980:	ff ff ff 
  802983:	48 01 d0             	add    %rdx,%rax
  802986:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80298a:	c9                   	leaveq 
  80298b:	c3                   	retq   

000000000080298c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80298c:	55                   	push   %rbp
  80298d:	48 89 e5             	mov    %rsp,%rbp
  802990:	48 83 ec 08          	sub    $0x8,%rsp
  802994:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802998:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80299c:	48 89 c7             	mov    %rax,%rdi
  80299f:	48 b8 69 29 80 00 00 	movabs $0x802969,%rax
  8029a6:	00 00 00 
  8029a9:	ff d0                	callq  *%rax
  8029ab:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8029b1:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8029b5:	c9                   	leaveq 
  8029b6:	c3                   	retq   

00000000008029b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8029b7:	55                   	push   %rbp
  8029b8:	48 89 e5             	mov    %rsp,%rbp
  8029bb:	48 83 ec 18          	sub    $0x18,%rsp
  8029bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8029c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029ca:	eb 6b                	jmp    802a37 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8029cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029cf:	48 98                	cltq   
  8029d1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8029d7:	48 c1 e0 0c          	shl    $0xc,%rax
  8029db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8029df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e3:	48 c1 e8 15          	shr    $0x15,%rax
  8029e7:	48 89 c2             	mov    %rax,%rdx
  8029ea:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029f1:	01 00 00 
  8029f4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029f8:	83 e0 01             	and    $0x1,%eax
  8029fb:	48 85 c0             	test   %rax,%rax
  8029fe:	74 21                	je     802a21 <fd_alloc+0x6a>
  802a00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a04:	48 c1 e8 0c          	shr    $0xc,%rax
  802a08:	48 89 c2             	mov    %rax,%rdx
  802a0b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a12:	01 00 00 
  802a15:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a19:	83 e0 01             	and    $0x1,%eax
  802a1c:	48 85 c0             	test   %rax,%rax
  802a1f:	75 12                	jne    802a33 <fd_alloc+0x7c>
			*fd_store = fd;
  802a21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a29:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a2c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a31:	eb 1a                	jmp    802a4d <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802a33:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a37:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a3b:	7e 8f                	jle    8029cc <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802a3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a41:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802a48:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802a4d:	c9                   	leaveq 
  802a4e:	c3                   	retq   

0000000000802a4f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802a4f:	55                   	push   %rbp
  802a50:	48 89 e5             	mov    %rsp,%rbp
  802a53:	48 83 ec 20          	sub    $0x20,%rsp
  802a57:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a5a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802a5e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a62:	78 06                	js     802a6a <fd_lookup+0x1b>
  802a64:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802a68:	7e 07                	jle    802a71 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802a6a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a6f:	eb 6c                	jmp    802add <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802a71:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a74:	48 98                	cltq   
  802a76:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a7c:	48 c1 e0 0c          	shl    $0xc,%rax
  802a80:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802a84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a88:	48 c1 e8 15          	shr    $0x15,%rax
  802a8c:	48 89 c2             	mov    %rax,%rdx
  802a8f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a96:	01 00 00 
  802a99:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a9d:	83 e0 01             	and    $0x1,%eax
  802aa0:	48 85 c0             	test   %rax,%rax
  802aa3:	74 21                	je     802ac6 <fd_lookup+0x77>
  802aa5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aa9:	48 c1 e8 0c          	shr    $0xc,%rax
  802aad:	48 89 c2             	mov    %rax,%rdx
  802ab0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ab7:	01 00 00 
  802aba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802abe:	83 e0 01             	and    $0x1,%eax
  802ac1:	48 85 c0             	test   %rax,%rax
  802ac4:	75 07                	jne    802acd <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802ac6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802acb:	eb 10                	jmp    802add <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802acd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ad1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ad5:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802ad8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802add:	c9                   	leaveq 
  802ade:	c3                   	retq   

0000000000802adf <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802adf:	55                   	push   %rbp
  802ae0:	48 89 e5             	mov    %rsp,%rbp
  802ae3:	48 83 ec 30          	sub    $0x30,%rsp
  802ae7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802aeb:	89 f0                	mov    %esi,%eax
  802aed:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802af0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802af4:	48 89 c7             	mov    %rax,%rdi
  802af7:	48 b8 69 29 80 00 00 	movabs $0x802969,%rax
  802afe:	00 00 00 
  802b01:	ff d0                	callq  *%rax
  802b03:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b07:	48 89 d6             	mov    %rdx,%rsi
  802b0a:	89 c7                	mov    %eax,%edi
  802b0c:	48 b8 4f 2a 80 00 00 	movabs $0x802a4f,%rax
  802b13:	00 00 00 
  802b16:	ff d0                	callq  *%rax
  802b18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b1f:	78 0a                	js     802b2b <fd_close+0x4c>
	    || fd != fd2)
  802b21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b25:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802b29:	74 12                	je     802b3d <fd_close+0x5e>
		return (must_exist ? r : 0);
  802b2b:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802b2f:	74 05                	je     802b36 <fd_close+0x57>
  802b31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b34:	eb 05                	jmp    802b3b <fd_close+0x5c>
  802b36:	b8 00 00 00 00       	mov    $0x0,%eax
  802b3b:	eb 69                	jmp    802ba6 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802b3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b41:	8b 00                	mov    (%rax),%eax
  802b43:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b47:	48 89 d6             	mov    %rdx,%rsi
  802b4a:	89 c7                	mov    %eax,%edi
  802b4c:	48 b8 a8 2b 80 00 00 	movabs $0x802ba8,%rax
  802b53:	00 00 00 
  802b56:	ff d0                	callq  *%rax
  802b58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5f:	78 2a                	js     802b8b <fd_close+0xac>
		if (dev->dev_close)
  802b61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b65:	48 8b 40 20          	mov    0x20(%rax),%rax
  802b69:	48 85 c0             	test   %rax,%rax
  802b6c:	74 16                	je     802b84 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802b6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b72:	48 8b 40 20          	mov    0x20(%rax),%rax
  802b76:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b7a:	48 89 d7             	mov    %rdx,%rdi
  802b7d:	ff d0                	callq  *%rax
  802b7f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b82:	eb 07                	jmp    802b8b <fd_close+0xac>
		else
			r = 0;
  802b84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802b8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b8f:	48 89 c6             	mov    %rax,%rsi
  802b92:	bf 00 00 00 00       	mov    $0x0,%edi
  802b97:	48 b8 a4 22 80 00 00 	movabs $0x8022a4,%rax
  802b9e:	00 00 00 
  802ba1:	ff d0                	callq  *%rax
	return r;
  802ba3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ba6:	c9                   	leaveq 
  802ba7:	c3                   	retq   

0000000000802ba8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802ba8:	55                   	push   %rbp
  802ba9:	48 89 e5             	mov    %rsp,%rbp
  802bac:	48 83 ec 20          	sub    $0x20,%rsp
  802bb0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bb3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802bb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bbe:	eb 41                	jmp    802c01 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802bc0:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  802bc7:	00 00 00 
  802bca:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802bcd:	48 63 d2             	movslq %edx,%rdx
  802bd0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bd4:	8b 00                	mov    (%rax),%eax
  802bd6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802bd9:	75 22                	jne    802bfd <dev_lookup+0x55>
			*dev = devtab[i];
  802bdb:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  802be2:	00 00 00 
  802be5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802be8:	48 63 d2             	movslq %edx,%rdx
  802beb:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802bef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bf3:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802bf6:	b8 00 00 00 00       	mov    $0x0,%eax
  802bfb:	eb 60                	jmp    802c5d <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802bfd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c01:	48 b8 60 70 80 00 00 	movabs $0x807060,%rax
  802c08:	00 00 00 
  802c0b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c0e:	48 63 d2             	movslq %edx,%rdx
  802c11:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c15:	48 85 c0             	test   %rax,%rax
  802c18:	75 a6                	jne    802bc0 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802c1a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802c21:	00 00 00 
  802c24:	48 8b 00             	mov    (%rax),%rax
  802c27:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c2d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802c30:	89 c6                	mov    %eax,%esi
  802c32:	48 bf 48 53 80 00 00 	movabs $0x805348,%rdi
  802c39:	00 00 00 
  802c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c41:	48 b9 22 0b 80 00 00 	movabs $0x800b22,%rcx
  802c48:	00 00 00 
  802c4b:	ff d1                	callq  *%rcx
	*dev = 0;
  802c4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c51:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802c58:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802c5d:	c9                   	leaveq 
  802c5e:	c3                   	retq   

0000000000802c5f <close>:

int
close(int fdnum)
{
  802c5f:	55                   	push   %rbp
  802c60:	48 89 e5             	mov    %rsp,%rbp
  802c63:	48 83 ec 20          	sub    $0x20,%rsp
  802c67:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c6a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c6e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c71:	48 89 d6             	mov    %rdx,%rsi
  802c74:	89 c7                	mov    %eax,%edi
  802c76:	48 b8 4f 2a 80 00 00 	movabs $0x802a4f,%rax
  802c7d:	00 00 00 
  802c80:	ff d0                	callq  *%rax
  802c82:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c89:	79 05                	jns    802c90 <close+0x31>
		return r;
  802c8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8e:	eb 18                	jmp    802ca8 <close+0x49>
	else
		return fd_close(fd, 1);
  802c90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c94:	be 01 00 00 00       	mov    $0x1,%esi
  802c99:	48 89 c7             	mov    %rax,%rdi
  802c9c:	48 b8 df 2a 80 00 00 	movabs $0x802adf,%rax
  802ca3:	00 00 00 
  802ca6:	ff d0                	callq  *%rax
}
  802ca8:	c9                   	leaveq 
  802ca9:	c3                   	retq   

0000000000802caa <close_all>:

void
close_all(void)
{
  802caa:	55                   	push   %rbp
  802cab:	48 89 e5             	mov    %rsp,%rbp
  802cae:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802cb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802cb9:	eb 15                	jmp    802cd0 <close_all+0x26>
		close(i);
  802cbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cbe:	89 c7                	mov    %eax,%edi
  802cc0:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  802cc7:	00 00 00 
  802cca:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802ccc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802cd0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802cd4:	7e e5                	jle    802cbb <close_all+0x11>
		close(i);
}
  802cd6:	c9                   	leaveq 
  802cd7:	c3                   	retq   

0000000000802cd8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802cd8:	55                   	push   %rbp
  802cd9:	48 89 e5             	mov    %rsp,%rbp
  802cdc:	48 83 ec 40          	sub    $0x40,%rsp
  802ce0:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802ce3:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802ce6:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802cea:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802ced:	48 89 d6             	mov    %rdx,%rsi
  802cf0:	89 c7                	mov    %eax,%edi
  802cf2:	48 b8 4f 2a 80 00 00 	movabs $0x802a4f,%rax
  802cf9:	00 00 00 
  802cfc:	ff d0                	callq  *%rax
  802cfe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d05:	79 08                	jns    802d0f <dup+0x37>
		return r;
  802d07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d0a:	e9 70 01 00 00       	jmpq   802e7f <dup+0x1a7>
	close(newfdnum);
  802d0f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d12:	89 c7                	mov    %eax,%edi
  802d14:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  802d1b:	00 00 00 
  802d1e:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802d20:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d23:	48 98                	cltq   
  802d25:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802d2b:	48 c1 e0 0c          	shl    $0xc,%rax
  802d2f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802d33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d37:	48 89 c7             	mov    %rax,%rdi
  802d3a:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  802d41:	00 00 00 
  802d44:	ff d0                	callq  *%rax
  802d46:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802d4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d4e:	48 89 c7             	mov    %rax,%rdi
  802d51:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  802d58:	00 00 00 
  802d5b:	ff d0                	callq  *%rax
  802d5d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802d61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d65:	48 c1 e8 15          	shr    $0x15,%rax
  802d69:	48 89 c2             	mov    %rax,%rdx
  802d6c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802d73:	01 00 00 
  802d76:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d7a:	83 e0 01             	and    $0x1,%eax
  802d7d:	48 85 c0             	test   %rax,%rax
  802d80:	74 73                	je     802df5 <dup+0x11d>
  802d82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d86:	48 c1 e8 0c          	shr    $0xc,%rax
  802d8a:	48 89 c2             	mov    %rax,%rdx
  802d8d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d94:	01 00 00 
  802d97:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d9b:	83 e0 01             	and    $0x1,%eax
  802d9e:	48 85 c0             	test   %rax,%rax
  802da1:	74 52                	je     802df5 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802da3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da7:	48 c1 e8 0c          	shr    $0xc,%rax
  802dab:	48 89 c2             	mov    %rax,%rdx
  802dae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802db5:	01 00 00 
  802db8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dbc:	25 07 0e 00 00       	and    $0xe07,%eax
  802dc1:	89 c1                	mov    %eax,%ecx
  802dc3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802dc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dcb:	41 89 c8             	mov    %ecx,%r8d
  802dce:	48 89 d1             	mov    %rdx,%rcx
  802dd1:	ba 00 00 00 00       	mov    $0x0,%edx
  802dd6:	48 89 c6             	mov    %rax,%rsi
  802dd9:	bf 00 00 00 00       	mov    $0x0,%edi
  802dde:	48 b8 49 22 80 00 00 	movabs $0x802249,%rax
  802de5:	00 00 00 
  802de8:	ff d0                	callq  *%rax
  802dea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ded:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df1:	79 02                	jns    802df5 <dup+0x11d>
			goto err;
  802df3:	eb 57                	jmp    802e4c <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802df5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802df9:	48 c1 e8 0c          	shr    $0xc,%rax
  802dfd:	48 89 c2             	mov    %rax,%rdx
  802e00:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e07:	01 00 00 
  802e0a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e0e:	25 07 0e 00 00       	and    $0xe07,%eax
  802e13:	89 c1                	mov    %eax,%ecx
  802e15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e19:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e1d:	41 89 c8             	mov    %ecx,%r8d
  802e20:	48 89 d1             	mov    %rdx,%rcx
  802e23:	ba 00 00 00 00       	mov    $0x0,%edx
  802e28:	48 89 c6             	mov    %rax,%rsi
  802e2b:	bf 00 00 00 00       	mov    $0x0,%edi
  802e30:	48 b8 49 22 80 00 00 	movabs $0x802249,%rax
  802e37:	00 00 00 
  802e3a:	ff d0                	callq  *%rax
  802e3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e43:	79 02                	jns    802e47 <dup+0x16f>
		goto err;
  802e45:	eb 05                	jmp    802e4c <dup+0x174>

	return newfdnum;
  802e47:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e4a:	eb 33                	jmp    802e7f <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802e4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e50:	48 89 c6             	mov    %rax,%rsi
  802e53:	bf 00 00 00 00       	mov    $0x0,%edi
  802e58:	48 b8 a4 22 80 00 00 	movabs $0x8022a4,%rax
  802e5f:	00 00 00 
  802e62:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802e64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e68:	48 89 c6             	mov    %rax,%rsi
  802e6b:	bf 00 00 00 00       	mov    $0x0,%edi
  802e70:	48 b8 a4 22 80 00 00 	movabs $0x8022a4,%rax
  802e77:	00 00 00 
  802e7a:	ff d0                	callq  *%rax
	return r;
  802e7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e7f:	c9                   	leaveq 
  802e80:	c3                   	retq   

0000000000802e81 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802e81:	55                   	push   %rbp
  802e82:	48 89 e5             	mov    %rsp,%rbp
  802e85:	48 83 ec 40          	sub    $0x40,%rsp
  802e89:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e8c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e90:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e94:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e98:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e9b:	48 89 d6             	mov    %rdx,%rsi
  802e9e:	89 c7                	mov    %eax,%edi
  802ea0:	48 b8 4f 2a 80 00 00 	movabs $0x802a4f,%rax
  802ea7:	00 00 00 
  802eaa:	ff d0                	callq  *%rax
  802eac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eaf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eb3:	78 24                	js     802ed9 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802eb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb9:	8b 00                	mov    (%rax),%eax
  802ebb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ebf:	48 89 d6             	mov    %rdx,%rsi
  802ec2:	89 c7                	mov    %eax,%edi
  802ec4:	48 b8 a8 2b 80 00 00 	movabs $0x802ba8,%rax
  802ecb:	00 00 00 
  802ece:	ff d0                	callq  *%rax
  802ed0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ed3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed7:	79 05                	jns    802ede <read+0x5d>
		return r;
  802ed9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802edc:	eb 76                	jmp    802f54 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802ede:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee2:	8b 40 08             	mov    0x8(%rax),%eax
  802ee5:	83 e0 03             	and    $0x3,%eax
  802ee8:	83 f8 01             	cmp    $0x1,%eax
  802eeb:	75 3a                	jne    802f27 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802eed:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802ef4:	00 00 00 
  802ef7:	48 8b 00             	mov    (%rax),%rax
  802efa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f00:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f03:	89 c6                	mov    %eax,%esi
  802f05:	48 bf 67 53 80 00 00 	movabs $0x805367,%rdi
  802f0c:	00 00 00 
  802f0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f14:	48 b9 22 0b 80 00 00 	movabs $0x800b22,%rcx
  802f1b:	00 00 00 
  802f1e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802f20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f25:	eb 2d                	jmp    802f54 <read+0xd3>
	}
	if (!dev->dev_read)
  802f27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f2b:	48 8b 40 10          	mov    0x10(%rax),%rax
  802f2f:	48 85 c0             	test   %rax,%rax
  802f32:	75 07                	jne    802f3b <read+0xba>
		return -E_NOT_SUPP;
  802f34:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f39:	eb 19                	jmp    802f54 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802f3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802f43:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f47:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f4b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802f4f:	48 89 cf             	mov    %rcx,%rdi
  802f52:	ff d0                	callq  *%rax
}
  802f54:	c9                   	leaveq 
  802f55:	c3                   	retq   

0000000000802f56 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802f56:	55                   	push   %rbp
  802f57:	48 89 e5             	mov    %rsp,%rbp
  802f5a:	48 83 ec 30          	sub    $0x30,%rsp
  802f5e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f61:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f65:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802f69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802f70:	eb 49                	jmp    802fbb <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802f72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f75:	48 98                	cltq   
  802f77:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f7b:	48 29 c2             	sub    %rax,%rdx
  802f7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f81:	48 63 c8             	movslq %eax,%rcx
  802f84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f88:	48 01 c1             	add    %rax,%rcx
  802f8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f8e:	48 89 ce             	mov    %rcx,%rsi
  802f91:	89 c7                	mov    %eax,%edi
  802f93:	48 b8 81 2e 80 00 00 	movabs $0x802e81,%rax
  802f9a:	00 00 00 
  802f9d:	ff d0                	callq  *%rax
  802f9f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802fa2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802fa6:	79 05                	jns    802fad <readn+0x57>
			return m;
  802fa8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fab:	eb 1c                	jmp    802fc9 <readn+0x73>
		if (m == 0)
  802fad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802fb1:	75 02                	jne    802fb5 <readn+0x5f>
			break;
  802fb3:	eb 11                	jmp    802fc6 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802fb5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fb8:	01 45 fc             	add    %eax,-0x4(%rbp)
  802fbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fbe:	48 98                	cltq   
  802fc0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802fc4:	72 ac                	jb     802f72 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802fc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802fc9:	c9                   	leaveq 
  802fca:	c3                   	retq   

0000000000802fcb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802fcb:	55                   	push   %rbp
  802fcc:	48 89 e5             	mov    %rsp,%rbp
  802fcf:	48 83 ec 40          	sub    $0x40,%rsp
  802fd3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802fd6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802fda:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802fde:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802fe2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802fe5:	48 89 d6             	mov    %rdx,%rsi
  802fe8:	89 c7                	mov    %eax,%edi
  802fea:	48 b8 4f 2a 80 00 00 	movabs $0x802a4f,%rax
  802ff1:	00 00 00 
  802ff4:	ff d0                	callq  *%rax
  802ff6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ff9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ffd:	78 24                	js     803023 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802fff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803003:	8b 00                	mov    (%rax),%eax
  803005:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803009:	48 89 d6             	mov    %rdx,%rsi
  80300c:	89 c7                	mov    %eax,%edi
  80300e:	48 b8 a8 2b 80 00 00 	movabs $0x802ba8,%rax
  803015:	00 00 00 
  803018:	ff d0                	callq  *%rax
  80301a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80301d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803021:	79 05                	jns    803028 <write+0x5d>
		return r;
  803023:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803026:	eb 75                	jmp    80309d <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803028:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302c:	8b 40 08             	mov    0x8(%rax),%eax
  80302f:	83 e0 03             	and    $0x3,%eax
  803032:	85 c0                	test   %eax,%eax
  803034:	75 3a                	jne    803070 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803036:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80303d:	00 00 00 
  803040:	48 8b 00             	mov    (%rax),%rax
  803043:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803049:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80304c:	89 c6                	mov    %eax,%esi
  80304e:	48 bf 83 53 80 00 00 	movabs $0x805383,%rdi
  803055:	00 00 00 
  803058:	b8 00 00 00 00       	mov    $0x0,%eax
  80305d:	48 b9 22 0b 80 00 00 	movabs $0x800b22,%rcx
  803064:	00 00 00 
  803067:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803069:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80306e:	eb 2d                	jmp    80309d <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803070:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803074:	48 8b 40 18          	mov    0x18(%rax),%rax
  803078:	48 85 c0             	test   %rax,%rax
  80307b:	75 07                	jne    803084 <write+0xb9>
		return -E_NOT_SUPP;
  80307d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803082:	eb 19                	jmp    80309d <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  803084:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803088:	48 8b 40 18          	mov    0x18(%rax),%rax
  80308c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803090:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803094:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803098:	48 89 cf             	mov    %rcx,%rdi
  80309b:	ff d0                	callq  *%rax
}
  80309d:	c9                   	leaveq 
  80309e:	c3                   	retq   

000000000080309f <seek>:

int
seek(int fdnum, off_t offset)
{
  80309f:	55                   	push   %rbp
  8030a0:	48 89 e5             	mov    %rsp,%rbp
  8030a3:	48 83 ec 18          	sub    $0x18,%rsp
  8030a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030aa:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8030ad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030b4:	48 89 d6             	mov    %rdx,%rsi
  8030b7:	89 c7                	mov    %eax,%edi
  8030b9:	48 b8 4f 2a 80 00 00 	movabs $0x802a4f,%rax
  8030c0:	00 00 00 
  8030c3:	ff d0                	callq  *%rax
  8030c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030cc:	79 05                	jns    8030d3 <seek+0x34>
		return r;
  8030ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d1:	eb 0f                	jmp    8030e2 <seek+0x43>
	fd->fd_offset = offset;
  8030d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030da:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8030dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030e2:	c9                   	leaveq 
  8030e3:	c3                   	retq   

00000000008030e4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8030e4:	55                   	push   %rbp
  8030e5:	48 89 e5             	mov    %rsp,%rbp
  8030e8:	48 83 ec 30          	sub    $0x30,%rsp
  8030ec:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030ef:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030f2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030f6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8030f9:	48 89 d6             	mov    %rdx,%rsi
  8030fc:	89 c7                	mov    %eax,%edi
  8030fe:	48 b8 4f 2a 80 00 00 	movabs $0x802a4f,%rax
  803105:	00 00 00 
  803108:	ff d0                	callq  *%rax
  80310a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80310d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803111:	78 24                	js     803137 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803113:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803117:	8b 00                	mov    (%rax),%eax
  803119:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80311d:	48 89 d6             	mov    %rdx,%rsi
  803120:	89 c7                	mov    %eax,%edi
  803122:	48 b8 a8 2b 80 00 00 	movabs $0x802ba8,%rax
  803129:	00 00 00 
  80312c:	ff d0                	callq  *%rax
  80312e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803131:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803135:	79 05                	jns    80313c <ftruncate+0x58>
		return r;
  803137:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313a:	eb 72                	jmp    8031ae <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80313c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803140:	8b 40 08             	mov    0x8(%rax),%eax
  803143:	83 e0 03             	and    $0x3,%eax
  803146:	85 c0                	test   %eax,%eax
  803148:	75 3a                	jne    803184 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80314a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803151:	00 00 00 
  803154:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803157:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80315d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803160:	89 c6                	mov    %eax,%esi
  803162:	48 bf a0 53 80 00 00 	movabs $0x8053a0,%rdi
  803169:	00 00 00 
  80316c:	b8 00 00 00 00       	mov    $0x0,%eax
  803171:	48 b9 22 0b 80 00 00 	movabs $0x800b22,%rcx
  803178:	00 00 00 
  80317b:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80317d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803182:	eb 2a                	jmp    8031ae <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803184:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803188:	48 8b 40 30          	mov    0x30(%rax),%rax
  80318c:	48 85 c0             	test   %rax,%rax
  80318f:	75 07                	jne    803198 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803191:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803196:	eb 16                	jmp    8031ae <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803198:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80319c:	48 8b 40 30          	mov    0x30(%rax),%rax
  8031a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031a4:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8031a7:	89 ce                	mov    %ecx,%esi
  8031a9:	48 89 d7             	mov    %rdx,%rdi
  8031ac:	ff d0                	callq  *%rax
}
  8031ae:	c9                   	leaveq 
  8031af:	c3                   	retq   

00000000008031b0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8031b0:	55                   	push   %rbp
  8031b1:	48 89 e5             	mov    %rsp,%rbp
  8031b4:	48 83 ec 30          	sub    $0x30,%rsp
  8031b8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8031bb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031bf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031c3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031c6:	48 89 d6             	mov    %rdx,%rsi
  8031c9:	89 c7                	mov    %eax,%edi
  8031cb:	48 b8 4f 2a 80 00 00 	movabs $0x802a4f,%rax
  8031d2:	00 00 00 
  8031d5:	ff d0                	callq  *%rax
  8031d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031de:	78 24                	js     803204 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031e4:	8b 00                	mov    (%rax),%eax
  8031e6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031ea:	48 89 d6             	mov    %rdx,%rsi
  8031ed:	89 c7                	mov    %eax,%edi
  8031ef:	48 b8 a8 2b 80 00 00 	movabs $0x802ba8,%rax
  8031f6:	00 00 00 
  8031f9:	ff d0                	callq  *%rax
  8031fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803202:	79 05                	jns    803209 <fstat+0x59>
		return r;
  803204:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803207:	eb 5e                	jmp    803267 <fstat+0xb7>
	if (!dev->dev_stat)
  803209:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80320d:	48 8b 40 28          	mov    0x28(%rax),%rax
  803211:	48 85 c0             	test   %rax,%rax
  803214:	75 07                	jne    80321d <fstat+0x6d>
		return -E_NOT_SUPP;
  803216:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80321b:	eb 4a                	jmp    803267 <fstat+0xb7>
	stat->st_name[0] = 0;
  80321d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803221:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803224:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803228:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80322f:	00 00 00 
	stat->st_isdir = 0;
  803232:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803236:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80323d:	00 00 00 
	stat->st_dev = dev;
  803240:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803244:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803248:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80324f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803253:	48 8b 40 28          	mov    0x28(%rax),%rax
  803257:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80325b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80325f:	48 89 ce             	mov    %rcx,%rsi
  803262:	48 89 d7             	mov    %rdx,%rdi
  803265:	ff d0                	callq  *%rax
}
  803267:	c9                   	leaveq 
  803268:	c3                   	retq   

0000000000803269 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803269:	55                   	push   %rbp
  80326a:	48 89 e5             	mov    %rsp,%rbp
  80326d:	48 83 ec 20          	sub    $0x20,%rsp
  803271:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803275:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803279:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80327d:	be 00 00 00 00       	mov    $0x0,%esi
  803282:	48 89 c7             	mov    %rax,%rdi
  803285:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  80328c:	00 00 00 
  80328f:	ff d0                	callq  *%rax
  803291:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803294:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803298:	79 05                	jns    80329f <stat+0x36>
		return fd;
  80329a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80329d:	eb 2f                	jmp    8032ce <stat+0x65>
	r = fstat(fd, stat);
  80329f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8032a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a6:	48 89 d6             	mov    %rdx,%rsi
  8032a9:	89 c7                	mov    %eax,%edi
  8032ab:	48 b8 b0 31 80 00 00 	movabs $0x8031b0,%rax
  8032b2:	00 00 00 
  8032b5:	ff d0                	callq  *%rax
  8032b7:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8032ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032bd:	89 c7                	mov    %eax,%edi
  8032bf:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  8032c6:	00 00 00 
  8032c9:	ff d0                	callq  *%rax
	return r;
  8032cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8032ce:	c9                   	leaveq 
  8032cf:	c3                   	retq   

00000000008032d0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8032d0:	55                   	push   %rbp
  8032d1:	48 89 e5             	mov    %rsp,%rbp
  8032d4:	48 83 ec 10          	sub    $0x10,%rsp
  8032d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8032df:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8032e6:	00 00 00 
  8032e9:	8b 00                	mov    (%rax),%eax
  8032eb:	85 c0                	test   %eax,%eax
  8032ed:	75 1d                	jne    80330c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8032ef:	bf 01 00 00 00       	mov    $0x1,%edi
  8032f4:	48 b8 91 4b 80 00 00 	movabs $0x804b91,%rax
  8032fb:	00 00 00 
  8032fe:	ff d0                	callq  *%rax
  803300:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  803307:	00 00 00 
  80330a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80330c:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803313:	00 00 00 
  803316:	8b 00                	mov    (%rax),%eax
  803318:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80331b:	b9 07 00 00 00       	mov    $0x7,%ecx
  803320:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803327:	00 00 00 
  80332a:	89 c7                	mov    %eax,%edi
  80332c:	48 b8 f9 4a 80 00 00 	movabs $0x804af9,%rax
  803333:	00 00 00 
  803336:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803338:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333c:	ba 00 00 00 00       	mov    $0x0,%edx
  803341:	48 89 c6             	mov    %rax,%rsi
  803344:	bf 00 00 00 00       	mov    $0x0,%edi
  803349:	48 b8 30 4a 80 00 00 	movabs $0x804a30,%rax
  803350:	00 00 00 
  803353:	ff d0                	callq  *%rax
}
  803355:	c9                   	leaveq 
  803356:	c3                   	retq   

0000000000803357 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803357:	55                   	push   %rbp
  803358:	48 89 e5             	mov    %rsp,%rbp
  80335b:	48 83 ec 20          	sub    $0x20,%rsp
  80335f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803363:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  803366:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80336a:	48 89 c7             	mov    %rax,%rdi
  80336d:	48 b8 5e 18 80 00 00 	movabs $0x80185e,%rax
  803374:	00 00 00 
  803377:	ff d0                	callq  *%rax
  803379:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80337e:	7e 0a                	jle    80338a <open+0x33>
		return -E_BAD_PATH;
  803380:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803385:	e9 a5 00 00 00       	jmpq   80342f <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80338a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80338e:	48 89 c7             	mov    %rax,%rdi
  803391:	48 b8 b7 29 80 00 00 	movabs $0x8029b7,%rax
  803398:	00 00 00 
  80339b:	ff d0                	callq  *%rax
  80339d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033a4:	79 08                	jns    8033ae <open+0x57>
		return r;
  8033a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a9:	e9 81 00 00 00       	jmpq   80342f <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8033ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033b2:	48 89 c6             	mov    %rax,%rsi
  8033b5:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8033bc:	00 00 00 
  8033bf:	48 b8 ca 18 80 00 00 	movabs $0x8018ca,%rax
  8033c6:	00 00 00 
  8033c9:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8033cb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033d2:	00 00 00 
  8033d5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8033d8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8033de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033e2:	48 89 c6             	mov    %rax,%rsi
  8033e5:	bf 01 00 00 00       	mov    $0x1,%edi
  8033ea:	48 b8 d0 32 80 00 00 	movabs $0x8032d0,%rax
  8033f1:	00 00 00 
  8033f4:	ff d0                	callq  *%rax
  8033f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033fd:	79 1d                	jns    80341c <open+0xc5>
		fd_close(fd, 0);
  8033ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803403:	be 00 00 00 00       	mov    $0x0,%esi
  803408:	48 89 c7             	mov    %rax,%rdi
  80340b:	48 b8 df 2a 80 00 00 	movabs $0x802adf,%rax
  803412:	00 00 00 
  803415:	ff d0                	callq  *%rax
		return r;
  803417:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341a:	eb 13                	jmp    80342f <open+0xd8>
	}

	return fd2num(fd);
  80341c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803420:	48 89 c7             	mov    %rax,%rdi
  803423:	48 b8 69 29 80 00 00 	movabs $0x802969,%rax
  80342a:	00 00 00 
  80342d:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  80342f:	c9                   	leaveq 
  803430:	c3                   	retq   

0000000000803431 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803431:	55                   	push   %rbp
  803432:	48 89 e5             	mov    %rsp,%rbp
  803435:	48 83 ec 10          	sub    $0x10,%rsp
  803439:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80343d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803441:	8b 50 0c             	mov    0xc(%rax),%edx
  803444:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80344b:	00 00 00 
  80344e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803450:	be 00 00 00 00       	mov    $0x0,%esi
  803455:	bf 06 00 00 00       	mov    $0x6,%edi
  80345a:	48 b8 d0 32 80 00 00 	movabs $0x8032d0,%rax
  803461:	00 00 00 
  803464:	ff d0                	callq  *%rax
}
  803466:	c9                   	leaveq 
  803467:	c3                   	retq   

0000000000803468 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803468:	55                   	push   %rbp
  803469:	48 89 e5             	mov    %rsp,%rbp
  80346c:	48 83 ec 30          	sub    $0x30,%rsp
  803470:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803474:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803478:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80347c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803480:	8b 50 0c             	mov    0xc(%rax),%edx
  803483:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80348a:	00 00 00 
  80348d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80348f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803496:	00 00 00 
  803499:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80349d:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8034a1:	be 00 00 00 00       	mov    $0x0,%esi
  8034a6:	bf 03 00 00 00       	mov    $0x3,%edi
  8034ab:	48 b8 d0 32 80 00 00 	movabs $0x8032d0,%rax
  8034b2:	00 00 00 
  8034b5:	ff d0                	callq  *%rax
  8034b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034be:	79 05                	jns    8034c5 <devfile_read+0x5d>
		return r;
  8034c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c3:	eb 26                	jmp    8034eb <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8034c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c8:	48 63 d0             	movslq %eax,%rdx
  8034cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034cf:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8034d6:	00 00 00 
  8034d9:	48 89 c7             	mov    %rax,%rdi
  8034dc:	48 b8 ee 1b 80 00 00 	movabs $0x801bee,%rax
  8034e3:	00 00 00 
  8034e6:	ff d0                	callq  *%rax

	return r;
  8034e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8034eb:	c9                   	leaveq 
  8034ec:	c3                   	retq   

00000000008034ed <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8034ed:	55                   	push   %rbp
  8034ee:	48 89 e5             	mov    %rsp,%rbp
  8034f1:	48 83 ec 30          	sub    $0x30,%rsp
  8034f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  803501:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803508:	00 
  803509:	76 08                	jbe    803513 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  80350b:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803512:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803513:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803517:	8b 50 0c             	mov    0xc(%rax),%edx
  80351a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803521:	00 00 00 
  803524:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803526:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80352d:	00 00 00 
  803530:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803534:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  803538:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80353c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803540:	48 89 c6             	mov    %rax,%rsi
  803543:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  80354a:	00 00 00 
  80354d:	48 b8 ee 1b 80 00 00 	movabs $0x801bee,%rax
  803554:	00 00 00 
  803557:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803559:	be 00 00 00 00       	mov    $0x0,%esi
  80355e:	bf 04 00 00 00       	mov    $0x4,%edi
  803563:	48 b8 d0 32 80 00 00 	movabs $0x8032d0,%rax
  80356a:	00 00 00 
  80356d:	ff d0                	callq  *%rax
  80356f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803572:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803576:	79 05                	jns    80357d <devfile_write+0x90>
		return r;
  803578:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80357b:	eb 03                	jmp    803580 <devfile_write+0x93>

	return r;
  80357d:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803580:	c9                   	leaveq 
  803581:	c3                   	retq   

0000000000803582 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803582:	55                   	push   %rbp
  803583:	48 89 e5             	mov    %rsp,%rbp
  803586:	48 83 ec 20          	sub    $0x20,%rsp
  80358a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80358e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803596:	8b 50 0c             	mov    0xc(%rax),%edx
  803599:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035a0:	00 00 00 
  8035a3:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8035a5:	be 00 00 00 00       	mov    $0x0,%esi
  8035aa:	bf 05 00 00 00       	mov    $0x5,%edi
  8035af:	48 b8 d0 32 80 00 00 	movabs $0x8032d0,%rax
  8035b6:	00 00 00 
  8035b9:	ff d0                	callq  *%rax
  8035bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035c2:	79 05                	jns    8035c9 <devfile_stat+0x47>
		return r;
  8035c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c7:	eb 56                	jmp    80361f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8035c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035cd:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8035d4:	00 00 00 
  8035d7:	48 89 c7             	mov    %rax,%rdi
  8035da:	48 b8 ca 18 80 00 00 	movabs $0x8018ca,%rax
  8035e1:	00 00 00 
  8035e4:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8035e6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035ed:	00 00 00 
  8035f0:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8035f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035fa:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803600:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803607:	00 00 00 
  80360a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803610:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803614:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80361a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80361f:	c9                   	leaveq 
  803620:	c3                   	retq   

0000000000803621 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803621:	55                   	push   %rbp
  803622:	48 89 e5             	mov    %rsp,%rbp
  803625:	48 83 ec 10          	sub    $0x10,%rsp
  803629:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80362d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803630:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803634:	8b 50 0c             	mov    0xc(%rax),%edx
  803637:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80363e:	00 00 00 
  803641:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803643:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80364a:	00 00 00 
  80364d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803650:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803653:	be 00 00 00 00       	mov    $0x0,%esi
  803658:	bf 02 00 00 00       	mov    $0x2,%edi
  80365d:	48 b8 d0 32 80 00 00 	movabs $0x8032d0,%rax
  803664:	00 00 00 
  803667:	ff d0                	callq  *%rax
}
  803669:	c9                   	leaveq 
  80366a:	c3                   	retq   

000000000080366b <remove>:

// Delete a file
int
remove(const char *path)
{
  80366b:	55                   	push   %rbp
  80366c:	48 89 e5             	mov    %rsp,%rbp
  80366f:	48 83 ec 10          	sub    $0x10,%rsp
  803673:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803677:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80367b:	48 89 c7             	mov    %rax,%rdi
  80367e:	48 b8 5e 18 80 00 00 	movabs $0x80185e,%rax
  803685:	00 00 00 
  803688:	ff d0                	callq  *%rax
  80368a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80368f:	7e 07                	jle    803698 <remove+0x2d>
		return -E_BAD_PATH;
  803691:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803696:	eb 33                	jmp    8036cb <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803698:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80369c:	48 89 c6             	mov    %rax,%rsi
  80369f:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8036a6:	00 00 00 
  8036a9:	48 b8 ca 18 80 00 00 	movabs $0x8018ca,%rax
  8036b0:	00 00 00 
  8036b3:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8036b5:	be 00 00 00 00       	mov    $0x0,%esi
  8036ba:	bf 07 00 00 00       	mov    $0x7,%edi
  8036bf:	48 b8 d0 32 80 00 00 	movabs $0x8032d0,%rax
  8036c6:	00 00 00 
  8036c9:	ff d0                	callq  *%rax
}
  8036cb:	c9                   	leaveq 
  8036cc:	c3                   	retq   

00000000008036cd <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8036cd:	55                   	push   %rbp
  8036ce:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8036d1:	be 00 00 00 00       	mov    $0x0,%esi
  8036d6:	bf 08 00 00 00       	mov    $0x8,%edi
  8036db:	48 b8 d0 32 80 00 00 	movabs $0x8032d0,%rax
  8036e2:	00 00 00 
  8036e5:	ff d0                	callq  *%rax
}
  8036e7:	5d                   	pop    %rbp
  8036e8:	c3                   	retq   

00000000008036e9 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8036e9:	55                   	push   %rbp
  8036ea:	48 89 e5             	mov    %rsp,%rbp
  8036ed:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  8036f4:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  8036fb:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803702:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  803709:	be 00 00 00 00       	mov    $0x0,%esi
  80370e:	48 89 c7             	mov    %rax,%rdi
  803711:	48 b8 57 33 80 00 00 	movabs $0x803357,%rax
  803718:	00 00 00 
  80371b:	ff d0                	callq  *%rax
  80371d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803720:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803724:	79 08                	jns    80372e <spawn+0x45>
		return r;
  803726:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803729:	e9 14 03 00 00       	jmpq   803a42 <spawn+0x359>
	fd = r;
  80372e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803731:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803734:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  80373b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80373f:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  803746:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803749:	ba 00 02 00 00       	mov    $0x200,%edx
  80374e:	48 89 ce             	mov    %rcx,%rsi
  803751:	89 c7                	mov    %eax,%edi
  803753:	48 b8 56 2f 80 00 00 	movabs $0x802f56,%rax
  80375a:	00 00 00 
  80375d:	ff d0                	callq  *%rax
  80375f:	3d 00 02 00 00       	cmp    $0x200,%eax
  803764:	75 0d                	jne    803773 <spawn+0x8a>
	    || elf->e_magic != ELF_MAGIC) {
  803766:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80376a:	8b 00                	mov    (%rax),%eax
  80376c:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803771:	74 43                	je     8037b6 <spawn+0xcd>
		close(fd);
  803773:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803776:	89 c7                	mov    %eax,%edi
  803778:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  80377f:	00 00 00 
  803782:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803784:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803788:	8b 00                	mov    (%rax),%eax
  80378a:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  80378f:	89 c6                	mov    %eax,%esi
  803791:	48 bf c8 53 80 00 00 	movabs $0x8053c8,%rdi
  803798:	00 00 00 
  80379b:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a0:	48 b9 22 0b 80 00 00 	movabs $0x800b22,%rcx
  8037a7:	00 00 00 
  8037aa:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  8037ac:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8037b1:	e9 8c 02 00 00       	jmpq   803a42 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8037b6:	b8 07 00 00 00       	mov    $0x7,%eax
  8037bb:	cd 30                	int    $0x30
  8037bd:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8037c0:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8037c3:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8037c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8037ca:	79 08                	jns    8037d4 <spawn+0xeb>
		return r;
  8037cc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8037cf:	e9 6e 02 00 00       	jmpq   803a42 <spawn+0x359>
	child = r;
  8037d4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8037d7:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8037da:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8037dd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8037e2:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8037e9:	00 00 00 
  8037ec:	48 63 d0             	movslq %eax,%rdx
  8037ef:	48 89 d0             	mov    %rdx,%rax
  8037f2:	48 c1 e0 03          	shl    $0x3,%rax
  8037f6:	48 01 d0             	add    %rdx,%rax
  8037f9:	48 c1 e0 05          	shl    $0x5,%rax
  8037fd:	48 01 c8             	add    %rcx,%rax
  803800:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  803807:	48 89 c6             	mov    %rax,%rsi
  80380a:	b8 18 00 00 00       	mov    $0x18,%eax
  80380f:	48 89 d7             	mov    %rdx,%rdi
  803812:	48 89 c1             	mov    %rax,%rcx
  803815:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803818:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80381c:	48 8b 40 18          	mov    0x18(%rax),%rax
  803820:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803827:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  80382e:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803835:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  80383c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80383f:	48 89 ce             	mov    %rcx,%rsi
  803842:	89 c7                	mov    %eax,%edi
  803844:	48 b8 ac 3c 80 00 00 	movabs $0x803cac,%rax
  80384b:	00 00 00 
  80384e:	ff d0                	callq  *%rax
  803850:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803853:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803857:	79 08                	jns    803861 <spawn+0x178>
		return r;
  803859:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80385c:	e9 e1 01 00 00       	jmpq   803a42 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803861:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803865:	48 8b 40 20          	mov    0x20(%rax),%rax
  803869:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  803870:	48 01 d0             	add    %rdx,%rax
  803873:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803877:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80387e:	e9 a3 00 00 00       	jmpq   803926 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  803883:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803887:	8b 00                	mov    (%rax),%eax
  803889:	83 f8 01             	cmp    $0x1,%eax
  80388c:	74 05                	je     803893 <spawn+0x1aa>
			continue;
  80388e:	e9 8a 00 00 00       	jmpq   80391d <spawn+0x234>
		perm = PTE_P | PTE_U;
  803893:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80389a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389e:	8b 40 04             	mov    0x4(%rax),%eax
  8038a1:	83 e0 02             	and    $0x2,%eax
  8038a4:	85 c0                	test   %eax,%eax
  8038a6:	74 04                	je     8038ac <spawn+0x1c3>
			perm |= PTE_W;
  8038a8:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  8038ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b0:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8038b4:	41 89 c1             	mov    %eax,%r9d
  8038b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bb:	4c 8b 40 20          	mov    0x20(%rax),%r8
  8038bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038c3:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8038c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038cb:	48 8b 70 10          	mov    0x10(%rax),%rsi
  8038cf:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8038d2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8038d5:	8b 7d ec             	mov    -0x14(%rbp),%edi
  8038d8:	89 3c 24             	mov    %edi,(%rsp)
  8038db:	89 c7                	mov    %eax,%edi
  8038dd:	48 b8 55 3f 80 00 00 	movabs $0x803f55,%rax
  8038e4:	00 00 00 
  8038e7:	ff d0                	callq  *%rax
  8038e9:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8038ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8038f0:	79 2b                	jns    80391d <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  8038f2:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8038f3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8038f6:	89 c7                	mov    %eax,%edi
  8038f8:	48 b8 39 21 80 00 00 	movabs $0x802139,%rax
  8038ff:	00 00 00 
  803902:	ff d0                	callq  *%rax
	close(fd);
  803904:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803907:	89 c7                	mov    %eax,%edi
  803909:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  803910:	00 00 00 
  803913:	ff d0                	callq  *%rax
	return r;
  803915:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803918:	e9 25 01 00 00       	jmpq   803a42 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80391d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803921:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  803926:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80392a:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  80392e:	0f b7 c0             	movzwl %ax,%eax
  803931:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803934:	0f 8f 49 ff ff ff    	jg     803883 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  80393a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80393d:	89 c7                	mov    %eax,%edi
  80393f:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  803946:	00 00 00 
  803949:	ff d0                	callq  *%rax
	fd = -1;
  80394b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  803952:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803955:	89 c7                	mov    %eax,%edi
  803957:	48 b8 41 41 80 00 00 	movabs $0x804141,%rax
  80395e:	00 00 00 
  803961:	ff d0                	callq  *%rax
  803963:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803966:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80396a:	79 30                	jns    80399c <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  80396c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80396f:	89 c1                	mov    %eax,%ecx
  803971:	48 ba e2 53 80 00 00 	movabs $0x8053e2,%rdx
  803978:	00 00 00 
  80397b:	be 82 00 00 00       	mov    $0x82,%esi
  803980:	48 bf f8 53 80 00 00 	movabs $0x8053f8,%rdi
  803987:	00 00 00 
  80398a:	b8 00 00 00 00       	mov    $0x0,%eax
  80398f:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  803996:	00 00 00 
  803999:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80399c:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8039a3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8039a6:	48 89 d6             	mov    %rdx,%rsi
  8039a9:	89 c7                	mov    %eax,%edi
  8039ab:	48 b8 39 23 80 00 00 	movabs $0x802339,%rax
  8039b2:	00 00 00 
  8039b5:	ff d0                	callq  *%rax
  8039b7:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8039ba:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8039be:	79 30                	jns    8039f0 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  8039c0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8039c3:	89 c1                	mov    %eax,%ecx
  8039c5:	48 ba 04 54 80 00 00 	movabs $0x805404,%rdx
  8039cc:	00 00 00 
  8039cf:	be 85 00 00 00       	mov    $0x85,%esi
  8039d4:	48 bf f8 53 80 00 00 	movabs $0x8053f8,%rdi
  8039db:	00 00 00 
  8039de:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e3:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  8039ea:	00 00 00 
  8039ed:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8039f0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8039f3:	be 02 00 00 00       	mov    $0x2,%esi
  8039f8:	89 c7                	mov    %eax,%edi
  8039fa:	48 b8 ee 22 80 00 00 	movabs $0x8022ee,%rax
  803a01:	00 00 00 
  803a04:	ff d0                	callq  *%rax
  803a06:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803a09:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803a0d:	79 30                	jns    803a3f <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  803a0f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a12:	89 c1                	mov    %eax,%ecx
  803a14:	48 ba 1e 54 80 00 00 	movabs $0x80541e,%rdx
  803a1b:	00 00 00 
  803a1e:	be 88 00 00 00       	mov    $0x88,%esi
  803a23:	48 bf f8 53 80 00 00 	movabs $0x8053f8,%rdi
  803a2a:	00 00 00 
  803a2d:	b8 00 00 00 00       	mov    $0x0,%eax
  803a32:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  803a39:	00 00 00 
  803a3c:	41 ff d0             	callq  *%r8

	return child;
  803a3f:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  803a42:	c9                   	leaveq 
  803a43:	c3                   	retq   

0000000000803a44 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803a44:	55                   	push   %rbp
  803a45:	48 89 e5             	mov    %rsp,%rbp
  803a48:	41 55                	push   %r13
  803a4a:	41 54                	push   %r12
  803a4c:	53                   	push   %rbx
  803a4d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803a54:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803a5b:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803a62:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803a69:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803a70:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  803a77:	84 c0                	test   %al,%al
  803a79:	74 26                	je     803aa1 <spawnl+0x5d>
  803a7b:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  803a82:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803a89:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803a8d:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803a91:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  803a95:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803a99:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803a9d:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803aa1:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803aa8:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803aaf:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803ab2:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803ab9:	00 00 00 
  803abc:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803ac3:	00 00 00 
  803ac6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803aca:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803ad1:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803ad8:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while (va_arg(vl, void *) != NULL)
  803adf:	eb 07                	jmp    803ae8 <spawnl+0xa4>
		argc++;
  803ae1:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while (va_arg(vl, void *) != NULL)
  803ae8:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803aee:	83 f8 30             	cmp    $0x30,%eax
  803af1:	73 23                	jae    803b16 <spawnl+0xd2>
  803af3:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803afa:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803b00:	89 c0                	mov    %eax,%eax
  803b02:	48 01 d0             	add    %rdx,%rax
  803b05:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803b0b:	83 c2 08             	add    $0x8,%edx
  803b0e:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803b14:	eb 15                	jmp    803b2b <spawnl+0xe7>
  803b16:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803b1d:	48 89 d0             	mov    %rdx,%rax
  803b20:	48 83 c2 08          	add    $0x8,%rdx
  803b24:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803b2b:	48 8b 00             	mov    (%rax),%rax
  803b2e:	48 85 c0             	test   %rax,%rax
  803b31:	75 ae                	jne    803ae1 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803b33:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803b39:	83 c0 02             	add    $0x2,%eax
  803b3c:	48 89 e2             	mov    %rsp,%rdx
  803b3f:	48 89 d3             	mov    %rdx,%rbx
  803b42:	48 63 d0             	movslq %eax,%rdx
  803b45:	48 83 ea 01          	sub    $0x1,%rdx
  803b49:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803b50:	48 63 d0             	movslq %eax,%rdx
  803b53:	49 89 d4             	mov    %rdx,%r12
  803b56:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803b5c:	48 63 d0             	movslq %eax,%rdx
  803b5f:	49 89 d2             	mov    %rdx,%r10
  803b62:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803b68:	48 98                	cltq   
  803b6a:	48 c1 e0 03          	shl    $0x3,%rax
  803b6e:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803b72:	b8 10 00 00 00       	mov    $0x10,%eax
  803b77:	48 83 e8 01          	sub    $0x1,%rax
  803b7b:	48 01 d0             	add    %rdx,%rax
  803b7e:	bf 10 00 00 00       	mov    $0x10,%edi
  803b83:	ba 00 00 00 00       	mov    $0x0,%edx
  803b88:	48 f7 f7             	div    %rdi
  803b8b:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803b8f:	48 29 c4             	sub    %rax,%rsp
  803b92:	48 89 e0             	mov    %rsp,%rax
  803b95:	48 83 c0 07          	add    $0x7,%rax
  803b99:	48 c1 e8 03          	shr    $0x3,%rax
  803b9d:	48 c1 e0 03          	shl    $0x3,%rax
  803ba1:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803ba8:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803baf:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  803bb6:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803bb9:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803bbf:	8d 50 01             	lea    0x1(%rax),%edx
  803bc2:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803bc9:	48 63 d2             	movslq %edx,%rdx
  803bcc:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803bd3:	00 

	va_start(vl, arg0);
  803bd4:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803bdb:	00 00 00 
  803bde:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803be5:	00 00 00 
  803be8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803bec:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803bf3:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803bfa:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for (i = 0; i < argc; i++)
  803c01:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  803c08:	00 00 00 
  803c0b:	eb 63                	jmp    803c70 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  803c0d:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803c13:	8d 70 01             	lea    0x1(%rax),%esi
  803c16:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803c1c:	83 f8 30             	cmp    $0x30,%eax
  803c1f:	73 23                	jae    803c44 <spawnl+0x200>
  803c21:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803c28:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803c2e:	89 c0                	mov    %eax,%eax
  803c30:	48 01 d0             	add    %rdx,%rax
  803c33:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803c39:	83 c2 08             	add    $0x8,%edx
  803c3c:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803c42:	eb 15                	jmp    803c59 <spawnl+0x215>
  803c44:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  803c4b:	48 89 d0             	mov    %rdx,%rax
  803c4e:	48 83 c2 08          	add    $0x8,%rdx
  803c52:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803c59:	48 8b 08             	mov    (%rax),%rcx
  803c5c:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803c63:	89 f2                	mov    %esi,%edx
  803c65:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for (i = 0; i < argc; i++)
  803c69:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803c70:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803c76:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803c7c:	77 8f                	ja     803c0d <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803c7e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803c85:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803c8c:	48 89 d6             	mov    %rdx,%rsi
  803c8f:	48 89 c7             	mov    %rax,%rdi
  803c92:	48 b8 e9 36 80 00 00 	movabs $0x8036e9,%rax
  803c99:	00 00 00 
  803c9c:	ff d0                	callq  *%rax
  803c9e:	48 89 dc             	mov    %rbx,%rsp
}
  803ca1:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803ca5:	5b                   	pop    %rbx
  803ca6:	41 5c                	pop    %r12
  803ca8:	41 5d                	pop    %r13
  803caa:	5d                   	pop    %rbp
  803cab:	c3                   	retq   

0000000000803cac <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803cac:	55                   	push   %rbp
  803cad:	48 89 e5             	mov    %rsp,%rbp
  803cb0:	48 83 ec 50          	sub    $0x50,%rsp
  803cb4:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803cb7:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803cbb:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803cbf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803cc6:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803cc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803cce:	eb 33                	jmp    803d03 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803cd0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803cd3:	48 98                	cltq   
  803cd5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803cdc:	00 
  803cdd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803ce1:	48 01 d0             	add    %rdx,%rax
  803ce4:	48 8b 00             	mov    (%rax),%rax
  803ce7:	48 89 c7             	mov    %rax,%rdi
  803cea:	48 b8 5e 18 80 00 00 	movabs $0x80185e,%rax
  803cf1:	00 00 00 
  803cf4:	ff d0                	callq  *%rax
  803cf6:	83 c0 01             	add    $0x1,%eax
  803cf9:	48 98                	cltq   
  803cfb:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803cff:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803d03:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803d06:	48 98                	cltq   
  803d08:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803d0f:	00 
  803d10:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803d14:	48 01 d0             	add    %rdx,%rax
  803d17:	48 8b 00             	mov    (%rax),%rax
  803d1a:	48 85 c0             	test   %rax,%rax
  803d1d:	75 b1                	jne    803cd0 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803d1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d23:	48 f7 d8             	neg    %rax
  803d26:	48 05 00 10 40 00    	add    $0x401000,%rax
  803d2c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803d30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d34:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803d38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d3c:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803d40:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803d43:	83 c2 01             	add    $0x1,%edx
  803d46:	c1 e2 03             	shl    $0x3,%edx
  803d49:	48 63 d2             	movslq %edx,%rdx
  803d4c:	48 f7 da             	neg    %rdx
  803d4f:	48 01 d0             	add    %rdx,%rax
  803d52:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803d56:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d5a:	48 83 e8 10          	sub    $0x10,%rax
  803d5e:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803d64:	77 0a                	ja     803d70 <init_stack+0xc4>
		return -E_NO_MEM;
  803d66:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803d6b:	e9 e3 01 00 00       	jmpq   803f53 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803d70:	ba 07 00 00 00       	mov    $0x7,%edx
  803d75:	be 00 00 40 00       	mov    $0x400000,%esi
  803d7a:	bf 00 00 00 00       	mov    $0x0,%edi
  803d7f:	48 b8 f9 21 80 00 00 	movabs $0x8021f9,%rax
  803d86:	00 00 00 
  803d89:	ff d0                	callq  *%rax
  803d8b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d92:	79 08                	jns    803d9c <init_stack+0xf0>
		return r;
  803d94:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d97:	e9 b7 01 00 00       	jmpq   803f53 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803d9c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803da3:	e9 8a 00 00 00       	jmpq   803e32 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803da8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803dab:	48 98                	cltq   
  803dad:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803db4:	00 
  803db5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803db9:	48 01 c2             	add    %rax,%rdx
  803dbc:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803dc1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dc5:	48 01 c8             	add    %rcx,%rax
  803dc8:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803dce:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803dd1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803dd4:	48 98                	cltq   
  803dd6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803ddd:	00 
  803dde:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803de2:	48 01 d0             	add    %rdx,%rax
  803de5:	48 8b 10             	mov    (%rax),%rdx
  803de8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dec:	48 89 d6             	mov    %rdx,%rsi
  803def:	48 89 c7             	mov    %rax,%rdi
  803df2:	48 b8 ca 18 80 00 00 	movabs $0x8018ca,%rax
  803df9:	00 00 00 
  803dfc:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803dfe:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e01:	48 98                	cltq   
  803e03:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803e0a:	00 
  803e0b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803e0f:	48 01 d0             	add    %rdx,%rax
  803e12:	48 8b 00             	mov    (%rax),%rax
  803e15:	48 89 c7             	mov    %rax,%rdi
  803e18:	48 b8 5e 18 80 00 00 	movabs $0x80185e,%rax
  803e1f:	00 00 00 
  803e22:	ff d0                	callq  *%rax
  803e24:	48 98                	cltq   
  803e26:	48 83 c0 01          	add    $0x1,%rax
  803e2a:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803e2e:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803e32:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e35:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803e38:	0f 8c 6a ff ff ff    	jl     803da8 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803e3e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803e41:	48 98                	cltq   
  803e43:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803e4a:	00 
  803e4b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e4f:	48 01 d0             	add    %rdx,%rax
  803e52:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803e59:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803e60:	00 
  803e61:	74 35                	je     803e98 <init_stack+0x1ec>
  803e63:	48 b9 38 54 80 00 00 	movabs $0x805438,%rcx
  803e6a:	00 00 00 
  803e6d:	48 ba 5e 54 80 00 00 	movabs $0x80545e,%rdx
  803e74:	00 00 00 
  803e77:	be f1 00 00 00       	mov    $0xf1,%esi
  803e7c:	48 bf f8 53 80 00 00 	movabs $0x8053f8,%rdi
  803e83:	00 00 00 
  803e86:	b8 00 00 00 00       	mov    $0x0,%eax
  803e8b:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  803e92:	00 00 00 
  803e95:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803e98:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e9c:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803ea0:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803ea5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ea9:	48 01 c8             	add    %rcx,%rax
  803eac:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803eb2:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803eb5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803eb9:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803ebd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ec0:	48 98                	cltq   
  803ec2:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803ec5:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803eca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ece:	48 01 d0             	add    %rdx,%rax
  803ed1:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803ed7:	48 89 c2             	mov    %rax,%rdx
  803eda:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803ede:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803ee1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803ee4:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803eea:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803eef:	89 c2                	mov    %eax,%edx
  803ef1:	be 00 00 40 00       	mov    $0x400000,%esi
  803ef6:	bf 00 00 00 00       	mov    $0x0,%edi
  803efb:	48 b8 49 22 80 00 00 	movabs $0x802249,%rax
  803f02:	00 00 00 
  803f05:	ff d0                	callq  *%rax
  803f07:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f0a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f0e:	79 02                	jns    803f12 <init_stack+0x266>
		goto error;
  803f10:	eb 28                	jmp    803f3a <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803f12:	be 00 00 40 00       	mov    $0x400000,%esi
  803f17:	bf 00 00 00 00       	mov    $0x0,%edi
  803f1c:	48 b8 a4 22 80 00 00 	movabs $0x8022a4,%rax
  803f23:	00 00 00 
  803f26:	ff d0                	callq  *%rax
  803f28:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f2f:	79 02                	jns    803f33 <init_stack+0x287>
		goto error;
  803f31:	eb 07                	jmp    803f3a <init_stack+0x28e>

	return 0;
  803f33:	b8 00 00 00 00       	mov    $0x0,%eax
  803f38:	eb 19                	jmp    803f53 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  803f3a:	be 00 00 40 00       	mov    $0x400000,%esi
  803f3f:	bf 00 00 00 00       	mov    $0x0,%edi
  803f44:	48 b8 a4 22 80 00 00 	movabs $0x8022a4,%rax
  803f4b:	00 00 00 
  803f4e:	ff d0                	callq  *%rax
	return r;
  803f50:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803f53:	c9                   	leaveq 
  803f54:	c3                   	retq   

0000000000803f55 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  803f55:	55                   	push   %rbp
  803f56:	48 89 e5             	mov    %rsp,%rbp
  803f59:	48 83 ec 50          	sub    $0x50,%rsp
  803f5d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803f60:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f64:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803f68:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803f6b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803f6f:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803f73:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f77:	25 ff 0f 00 00       	and    $0xfff,%eax
  803f7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f83:	74 21                	je     803fa6 <map_segment+0x51>
		va -= i;
  803f85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f88:	48 98                	cltq   
  803f8a:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803f8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f91:	48 98                	cltq   
  803f93:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803f97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f9a:	48 98                	cltq   
  803f9c:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803fa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa3:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803fa6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fad:	e9 79 01 00 00       	jmpq   80412b <map_segment+0x1d6>
		if (i >= filesz) {
  803fb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb5:	48 98                	cltq   
  803fb7:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803fbb:	72 3c                	jb     803ff9 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803fbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc0:	48 63 d0             	movslq %eax,%rdx
  803fc3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fc7:	48 01 d0             	add    %rdx,%rax
  803fca:	48 89 c1             	mov    %rax,%rcx
  803fcd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803fd0:	8b 55 10             	mov    0x10(%rbp),%edx
  803fd3:	48 89 ce             	mov    %rcx,%rsi
  803fd6:	89 c7                	mov    %eax,%edi
  803fd8:	48 b8 f9 21 80 00 00 	movabs $0x8021f9,%rax
  803fdf:	00 00 00 
  803fe2:	ff d0                	callq  *%rax
  803fe4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803fe7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803feb:	0f 89 33 01 00 00    	jns    804124 <map_segment+0x1cf>
				return r;
  803ff1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ff4:	e9 46 01 00 00       	jmpq   80413f <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803ff9:	ba 07 00 00 00       	mov    $0x7,%edx
  803ffe:	be 00 00 40 00       	mov    $0x400000,%esi
  804003:	bf 00 00 00 00       	mov    $0x0,%edi
  804008:	48 b8 f9 21 80 00 00 	movabs $0x8021f9,%rax
  80400f:	00 00 00 
  804012:	ff d0                	callq  *%rax
  804014:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804017:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80401b:	79 08                	jns    804025 <map_segment+0xd0>
				return r;
  80401d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804020:	e9 1a 01 00 00       	jmpq   80413f <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  804025:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804028:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80402b:	01 c2                	add    %eax,%edx
  80402d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804030:	89 d6                	mov    %edx,%esi
  804032:	89 c7                	mov    %eax,%edi
  804034:	48 b8 9f 30 80 00 00 	movabs $0x80309f,%rax
  80403b:	00 00 00 
  80403e:	ff d0                	callq  *%rax
  804040:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804043:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804047:	79 08                	jns    804051 <map_segment+0xfc>
				return r;
  804049:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80404c:	e9 ee 00 00 00       	jmpq   80413f <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  804051:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  804058:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80405b:	48 98                	cltq   
  80405d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804061:	48 29 c2             	sub    %rax,%rdx
  804064:	48 89 d0             	mov    %rdx,%rax
  804067:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80406b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80406e:	48 63 d0             	movslq %eax,%rdx
  804071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804075:	48 39 c2             	cmp    %rax,%rdx
  804078:	48 0f 47 d0          	cmova  %rax,%rdx
  80407c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80407f:	be 00 00 40 00       	mov    $0x400000,%esi
  804084:	89 c7                	mov    %eax,%edi
  804086:	48 b8 56 2f 80 00 00 	movabs $0x802f56,%rax
  80408d:	00 00 00 
  804090:	ff d0                	callq  *%rax
  804092:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804095:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804099:	79 08                	jns    8040a3 <map_segment+0x14e>
				return r;
  80409b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80409e:	e9 9c 00 00 00       	jmpq   80413f <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8040a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a6:	48 63 d0             	movslq %eax,%rdx
  8040a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040ad:	48 01 d0             	add    %rdx,%rax
  8040b0:	48 89 c2             	mov    %rax,%rdx
  8040b3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8040b6:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8040ba:	48 89 d1             	mov    %rdx,%rcx
  8040bd:	89 c2                	mov    %eax,%edx
  8040bf:	be 00 00 40 00       	mov    $0x400000,%esi
  8040c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8040c9:	48 b8 49 22 80 00 00 	movabs $0x802249,%rax
  8040d0:	00 00 00 
  8040d3:	ff d0                	callq  *%rax
  8040d5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8040d8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8040dc:	79 30                	jns    80410e <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8040de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040e1:	89 c1                	mov    %eax,%ecx
  8040e3:	48 ba 73 54 80 00 00 	movabs $0x805473,%rdx
  8040ea:	00 00 00 
  8040ed:	be 24 01 00 00       	mov    $0x124,%esi
  8040f2:	48 bf f8 53 80 00 00 	movabs $0x8053f8,%rdi
  8040f9:	00 00 00 
  8040fc:	b8 00 00 00 00       	mov    $0x0,%eax
  804101:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  804108:	00 00 00 
  80410b:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  80410e:	be 00 00 40 00       	mov    $0x400000,%esi
  804113:	bf 00 00 00 00       	mov    $0x0,%edi
  804118:	48 b8 a4 22 80 00 00 	movabs $0x8022a4,%rax
  80411f:	00 00 00 
  804122:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  804124:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80412b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80412e:	48 98                	cltq   
  804130:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804134:	0f 82 78 fe ff ff    	jb     803fb2 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  80413a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80413f:	c9                   	leaveq 
  804140:	c3                   	retq   

0000000000804141 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  804141:	55                   	push   %rbp
  804142:	48 89 e5             	mov    %rsp,%rbp
  804145:	48 83 ec 50          	sub    $0x50,%rsp
  804149:	89 7d bc             	mov    %edi,-0x44(%rbp)
	// LAB 5: Your code here.
	// note: just copied and modified from lib/fork.c, function envid_t fork(void)
	void *addr;
	int r;
	pte_t i, j, k, l, ptx = 0;
  80414c:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  804153:	00 

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  804154:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80415b:	00 
  80415c:	e9 62 01 00 00       	jmpq   8042c3 <copy_shared_pages+0x182>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  804161:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804165:	48 c1 e8 1b          	shr    $0x1b,%rax
  804169:	48 89 c2             	mov    %rax,%rdx
  80416c:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  804173:	01 00 00 
  804176:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80417a:	83 e0 01             	and    $0x1,%eax
  80417d:	48 85 c0             	test   %rax,%rax
  804180:	75 0d                	jne    80418f <copy_shared_pages+0x4e>
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
  804182:	48 81 45 d8 00 00 00 	addq   $0x8000000,-0x28(%rbp)
  804189:	08 
			continue;
  80418a:	e9 2f 01 00 00       	jmpq   8042be <copy_shared_pages+0x17d>
		}

		for (j = 0; j < NPDENTRIES; j++) {
  80418f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  804196:	00 
  804197:	e9 14 01 00 00       	jmpq   8042b0 <copy_shared_pages+0x16f>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
  80419c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041a0:	48 c1 e8 12          	shr    $0x12,%rax
  8041a4:	48 89 c2             	mov    %rax,%rdx
  8041a7:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8041ae:	01 00 00 
  8041b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041b5:	83 e0 01             	and    $0x1,%eax
  8041b8:	48 85 c0             	test   %rax,%rax
  8041bb:	75 0d                	jne    8041ca <copy_shared_pages+0x89>
				ptx += NPDENTRIES * NPTENTRIES;
  8041bd:	48 81 45 d8 00 00 04 	addq   $0x40000,-0x28(%rbp)
  8041c4:	00 
				continue;
  8041c5:	e9 e1 00 00 00       	jmpq   8042ab <copy_shared_pages+0x16a>
			}

			for (k = 0; k < NPDENTRIES; k++) {
  8041ca:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8041d1:	00 
  8041d2:	e9 c6 00 00 00       	jmpq   80429d <copy_shared_pages+0x15c>
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
  8041d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041db:	48 c1 e8 09          	shr    $0x9,%rax
  8041df:	48 89 c2             	mov    %rax,%rdx
  8041e2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8041e9:	01 00 00 
  8041ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041f0:	83 e0 01             	and    $0x1,%eax
  8041f3:	48 85 c0             	test   %rax,%rax
  8041f6:	75 0d                	jne    804205 <copy_shared_pages+0xc4>
					ptx += NPTENTRIES;
  8041f8:	48 81 45 d8 00 02 00 	addq   $0x200,-0x28(%rbp)
  8041ff:	00 
					continue;
  804200:	e9 93 00 00 00       	jmpq   804298 <copy_shared_pages+0x157>
				}

				for (l = 0; l < NPTENTRIES; l++) {
  804205:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  80420c:	00 
  80420d:	eb 7b                	jmp    80428a <copy_shared_pages+0x149>
					if ((uvpt[ptx] & PTE_SHARE) != 0) {
  80420f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804216:	01 00 00 
  804219:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80421d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804221:	25 00 04 00 00       	and    $0x400,%eax
  804226:	48 85 c0             	test   %rax,%rax
  804229:	74 55                	je     804280 <copy_shared_pages+0x13f>
						addr = (void *)(ptx * PGSIZE);
  80422b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80422f:	48 c1 e0 0c          	shl    $0xc,%rax
  804233:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
						if ((r = sys_page_map(0, addr, child, addr, uvpt[ptx] & PTE_SYSCALL)) < 0)
  804237:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80423e:	01 00 00 
  804241:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804245:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804249:	25 07 0e 00 00       	and    $0xe07,%eax
  80424e:	89 c6                	mov    %eax,%esi
  804250:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  804254:	8b 55 bc             	mov    -0x44(%rbp),%edx
  804257:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80425b:	41 89 f0             	mov    %esi,%r8d
  80425e:	48 89 c6             	mov    %rax,%rsi
  804261:	bf 00 00 00 00       	mov    $0x0,%edi
  804266:	48 b8 49 22 80 00 00 	movabs $0x802249,%rax
  80426d:	00 00 00 
  804270:	ff d0                	callq  *%rax
  804272:	89 45 cc             	mov    %eax,-0x34(%rbp)
  804275:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  804279:	79 05                	jns    804280 <copy_shared_pages+0x13f>
							return r;
  80427b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80427e:	eb 53                	jmp    8042d3 <copy_shared_pages+0x192>
					}
					ptx++;
  804280:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
				if ((uvpd[ptx / NPTENTRIES] & PTE_P) == 0) {
					ptx += NPTENTRIES;
					continue;
				}

				for (l = 0; l < NPTENTRIES; l++) {
  804285:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80428a:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  804291:	00 
  804292:	0f 86 77 ff ff ff    	jbe    80420f <copy_shared_pages+0xce>
			if ((uvpde[ptx / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
				ptx += NPDENTRIES * NPTENTRIES;
				continue;
			}

			for (k = 0; k < NPDENTRIES; k++) {
  804298:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80429d:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  8042a4:	00 
  8042a5:	0f 86 2c ff ff ff    	jbe    8041d7 <copy_shared_pages+0x96>
		if ((uvpml4e[ptx / NPDPENTRIES / NPDENTRIES / NPTENTRIES] & PTE_P) == 0) {
			ptx += NPDPENTRIES * NPDENTRIES * NPTENTRIES;
			continue;
		}

		for (j = 0; j < NPDENTRIES; j++) {
  8042ab:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  8042b0:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  8042b7:	00 
  8042b8:	0f 86 de fe ff ff    	jbe    80419c <copy_shared_pages+0x5b>
	int r;
	pte_t i, j, k, l, ptx = 0;

	// note: pml4e, pdpe, pde, pte tables are all mapped to linear space such that one can goto
	// each pte by a specific index, space for empty (not present) entries are reserved recursively
	for (i = 0; i < VPML4E(UTOP); i++) {
  8042be:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042c3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8042c8:	0f 84 93 fe ff ff    	je     804161 <copy_shared_pages+0x20>
				}
			}
		}
	}

	return 0;
  8042ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042d3:	c9                   	leaveq 
  8042d4:	c3                   	retq   

00000000008042d5 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8042d5:	55                   	push   %rbp
  8042d6:	48 89 e5             	mov    %rsp,%rbp
  8042d9:	53                   	push   %rbx
  8042da:	48 83 ec 38          	sub    $0x38,%rsp
  8042de:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8042e2:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8042e6:	48 89 c7             	mov    %rax,%rdi
  8042e9:	48 b8 b7 29 80 00 00 	movabs $0x8029b7,%rax
  8042f0:	00 00 00 
  8042f3:	ff d0                	callq  *%rax
  8042f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042fc:	0f 88 bf 01 00 00    	js     8044c1 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804302:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804306:	ba 07 04 00 00       	mov    $0x407,%edx
  80430b:	48 89 c6             	mov    %rax,%rsi
  80430e:	bf 00 00 00 00       	mov    $0x0,%edi
  804313:	48 b8 f9 21 80 00 00 	movabs $0x8021f9,%rax
  80431a:	00 00 00 
  80431d:	ff d0                	callq  *%rax
  80431f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804322:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804326:	0f 88 95 01 00 00    	js     8044c1 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80432c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804330:	48 89 c7             	mov    %rax,%rdi
  804333:	48 b8 b7 29 80 00 00 	movabs $0x8029b7,%rax
  80433a:	00 00 00 
  80433d:	ff d0                	callq  *%rax
  80433f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804342:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804346:	0f 88 5d 01 00 00    	js     8044a9 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80434c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804350:	ba 07 04 00 00       	mov    $0x407,%edx
  804355:	48 89 c6             	mov    %rax,%rsi
  804358:	bf 00 00 00 00       	mov    $0x0,%edi
  80435d:	48 b8 f9 21 80 00 00 	movabs $0x8021f9,%rax
  804364:	00 00 00 
  804367:	ff d0                	callq  *%rax
  804369:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80436c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804370:	0f 88 33 01 00 00    	js     8044a9 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804376:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80437a:	48 89 c7             	mov    %rax,%rdi
  80437d:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  804384:	00 00 00 
  804387:	ff d0                	callq  *%rax
  804389:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80438d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804391:	ba 07 04 00 00       	mov    $0x407,%edx
  804396:	48 89 c6             	mov    %rax,%rsi
  804399:	bf 00 00 00 00       	mov    $0x0,%edi
  80439e:	48 b8 f9 21 80 00 00 	movabs $0x8021f9,%rax
  8043a5:	00 00 00 
  8043a8:	ff d0                	callq  *%rax
  8043aa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043b1:	79 05                	jns    8043b8 <pipe+0xe3>
		goto err2;
  8043b3:	e9 d9 00 00 00       	jmpq   804491 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8043b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043bc:	48 89 c7             	mov    %rax,%rdi
  8043bf:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  8043c6:	00 00 00 
  8043c9:	ff d0                	callq  *%rax
  8043cb:	48 89 c2             	mov    %rax,%rdx
  8043ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043d2:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8043d8:	48 89 d1             	mov    %rdx,%rcx
  8043db:	ba 00 00 00 00       	mov    $0x0,%edx
  8043e0:	48 89 c6             	mov    %rax,%rsi
  8043e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8043e8:	48 b8 49 22 80 00 00 	movabs $0x802249,%rax
  8043ef:	00 00 00 
  8043f2:	ff d0                	callq  *%rax
  8043f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043fb:	79 1b                	jns    804418 <pipe+0x143>
		goto err3;
  8043fd:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8043fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804402:	48 89 c6             	mov    %rax,%rsi
  804405:	bf 00 00 00 00       	mov    $0x0,%edi
  80440a:	48 b8 a4 22 80 00 00 	movabs $0x8022a4,%rax
  804411:	00 00 00 
  804414:	ff d0                	callq  *%rax
  804416:	eb 79                	jmp    804491 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804418:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80441c:	48 ba c0 70 80 00 00 	movabs $0x8070c0,%rdx
  804423:	00 00 00 
  804426:	8b 12                	mov    (%rdx),%edx
  804428:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80442a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80442e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804435:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804439:	48 ba c0 70 80 00 00 	movabs $0x8070c0,%rdx
  804440:	00 00 00 
  804443:	8b 12                	mov    (%rdx),%edx
  804445:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804447:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80444b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804452:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804456:	48 89 c7             	mov    %rax,%rdi
  804459:	48 b8 69 29 80 00 00 	movabs $0x802969,%rax
  804460:	00 00 00 
  804463:	ff d0                	callq  *%rax
  804465:	89 c2                	mov    %eax,%edx
  804467:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80446b:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80446d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804471:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804475:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804479:	48 89 c7             	mov    %rax,%rdi
  80447c:	48 b8 69 29 80 00 00 	movabs $0x802969,%rax
  804483:	00 00 00 
  804486:	ff d0                	callq  *%rax
  804488:	89 03                	mov    %eax,(%rbx)
	return 0;
  80448a:	b8 00 00 00 00       	mov    $0x0,%eax
  80448f:	eb 33                	jmp    8044c4 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  804491:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804495:	48 89 c6             	mov    %rax,%rsi
  804498:	bf 00 00 00 00       	mov    $0x0,%edi
  80449d:	48 b8 a4 22 80 00 00 	movabs $0x8022a4,%rax
  8044a4:	00 00 00 
  8044a7:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8044a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044ad:	48 89 c6             	mov    %rax,%rsi
  8044b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8044b5:	48 b8 a4 22 80 00 00 	movabs $0x8022a4,%rax
  8044bc:	00 00 00 
  8044bf:	ff d0                	callq  *%rax
    err:
	return r;
  8044c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8044c4:	48 83 c4 38          	add    $0x38,%rsp
  8044c8:	5b                   	pop    %rbx
  8044c9:	5d                   	pop    %rbp
  8044ca:	c3                   	retq   

00000000008044cb <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8044cb:	55                   	push   %rbp
  8044cc:	48 89 e5             	mov    %rsp,%rbp
  8044cf:	53                   	push   %rbx
  8044d0:	48 83 ec 28          	sub    $0x28,%rsp
  8044d4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8044d8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8044dc:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8044e3:	00 00 00 
  8044e6:	48 8b 00             	mov    (%rax),%rax
  8044e9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8044ef:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8044f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044f6:	48 89 c7             	mov    %rax,%rdi
  8044f9:	48 b8 13 4c 80 00 00 	movabs $0x804c13,%rax
  804500:	00 00 00 
  804503:	ff d0                	callq  *%rax
  804505:	89 c3                	mov    %eax,%ebx
  804507:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80450b:	48 89 c7             	mov    %rax,%rdi
  80450e:	48 b8 13 4c 80 00 00 	movabs $0x804c13,%rax
  804515:	00 00 00 
  804518:	ff d0                	callq  *%rax
  80451a:	39 c3                	cmp    %eax,%ebx
  80451c:	0f 94 c0             	sete   %al
  80451f:	0f b6 c0             	movzbl %al,%eax
  804522:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804525:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80452c:	00 00 00 
  80452f:	48 8b 00             	mov    (%rax),%rax
  804532:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804538:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80453b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80453e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804541:	75 05                	jne    804548 <_pipeisclosed+0x7d>
			return ret;
  804543:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804546:	eb 4f                	jmp    804597 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804548:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80454b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80454e:	74 42                	je     804592 <_pipeisclosed+0xc7>
  804550:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804554:	75 3c                	jne    804592 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804556:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80455d:	00 00 00 
  804560:	48 8b 00             	mov    (%rax),%rax
  804563:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804569:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80456c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80456f:	89 c6                	mov    %eax,%esi
  804571:	48 bf 95 54 80 00 00 	movabs $0x805495,%rdi
  804578:	00 00 00 
  80457b:	b8 00 00 00 00       	mov    $0x0,%eax
  804580:	49 b8 22 0b 80 00 00 	movabs $0x800b22,%r8
  804587:	00 00 00 
  80458a:	41 ff d0             	callq  *%r8
	}
  80458d:	e9 4a ff ff ff       	jmpq   8044dc <_pipeisclosed+0x11>
  804592:	e9 45 ff ff ff       	jmpq   8044dc <_pipeisclosed+0x11>
}
  804597:	48 83 c4 28          	add    $0x28,%rsp
  80459b:	5b                   	pop    %rbx
  80459c:	5d                   	pop    %rbp
  80459d:	c3                   	retq   

000000000080459e <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80459e:	55                   	push   %rbp
  80459f:	48 89 e5             	mov    %rsp,%rbp
  8045a2:	48 83 ec 30          	sub    $0x30,%rsp
  8045a6:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8045a9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8045ad:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8045b0:	48 89 d6             	mov    %rdx,%rsi
  8045b3:	89 c7                	mov    %eax,%edi
  8045b5:	48 b8 4f 2a 80 00 00 	movabs $0x802a4f,%rax
  8045bc:	00 00 00 
  8045bf:	ff d0                	callq  *%rax
  8045c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045c8:	79 05                	jns    8045cf <pipeisclosed+0x31>
		return r;
  8045ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045cd:	eb 31                	jmp    804600 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8045cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045d3:	48 89 c7             	mov    %rax,%rdi
  8045d6:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  8045dd:	00 00 00 
  8045e0:	ff d0                	callq  *%rax
  8045e2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8045e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8045ee:	48 89 d6             	mov    %rdx,%rsi
  8045f1:	48 89 c7             	mov    %rax,%rdi
  8045f4:	48 b8 cb 44 80 00 00 	movabs $0x8044cb,%rax
  8045fb:	00 00 00 
  8045fe:	ff d0                	callq  *%rax
}
  804600:	c9                   	leaveq 
  804601:	c3                   	retq   

0000000000804602 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804602:	55                   	push   %rbp
  804603:	48 89 e5             	mov    %rsp,%rbp
  804606:	48 83 ec 40          	sub    $0x40,%rsp
  80460a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80460e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804612:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804616:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80461a:	48 89 c7             	mov    %rax,%rdi
  80461d:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  804624:	00 00 00 
  804627:	ff d0                	callq  *%rax
  804629:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80462d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804631:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804635:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80463c:	00 
  80463d:	e9 92 00 00 00       	jmpq   8046d4 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804642:	eb 41                	jmp    804685 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804644:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804649:	74 09                	je     804654 <devpipe_read+0x52>
				return i;
  80464b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80464f:	e9 92 00 00 00       	jmpq   8046e6 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804654:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80465c:	48 89 d6             	mov    %rdx,%rsi
  80465f:	48 89 c7             	mov    %rax,%rdi
  804662:	48 b8 cb 44 80 00 00 	movabs $0x8044cb,%rax
  804669:	00 00 00 
  80466c:	ff d0                	callq  *%rax
  80466e:	85 c0                	test   %eax,%eax
  804670:	74 07                	je     804679 <devpipe_read+0x77>
				return 0;
  804672:	b8 00 00 00 00       	mov    $0x0,%eax
  804677:	eb 6d                	jmp    8046e6 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804679:	48 b8 bb 21 80 00 00 	movabs $0x8021bb,%rax
  804680:	00 00 00 
  804683:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804685:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804689:	8b 10                	mov    (%rax),%edx
  80468b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80468f:	8b 40 04             	mov    0x4(%rax),%eax
  804692:	39 c2                	cmp    %eax,%edx
  804694:	74 ae                	je     804644 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804696:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80469a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80469e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8046a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046a6:	8b 00                	mov    (%rax),%eax
  8046a8:	99                   	cltd   
  8046a9:	c1 ea 1b             	shr    $0x1b,%edx
  8046ac:	01 d0                	add    %edx,%eax
  8046ae:	83 e0 1f             	and    $0x1f,%eax
  8046b1:	29 d0                	sub    %edx,%eax
  8046b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046b7:	48 98                	cltq   
  8046b9:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8046be:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8046c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046c4:	8b 00                	mov    (%rax),%eax
  8046c6:	8d 50 01             	lea    0x1(%rax),%edx
  8046c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046cd:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8046cf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8046d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046d8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8046dc:	0f 82 60 ff ff ff    	jb     804642 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8046e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8046e6:	c9                   	leaveq 
  8046e7:	c3                   	retq   

00000000008046e8 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8046e8:	55                   	push   %rbp
  8046e9:	48 89 e5             	mov    %rsp,%rbp
  8046ec:	48 83 ec 40          	sub    $0x40,%rsp
  8046f0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8046f4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8046f8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8046fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804700:	48 89 c7             	mov    %rax,%rdi
  804703:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  80470a:	00 00 00 
  80470d:	ff d0                	callq  *%rax
  80470f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804713:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804717:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80471b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804722:	00 
  804723:	e9 8e 00 00 00       	jmpq   8047b6 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804728:	eb 31                	jmp    80475b <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80472a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80472e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804732:	48 89 d6             	mov    %rdx,%rsi
  804735:	48 89 c7             	mov    %rax,%rdi
  804738:	48 b8 cb 44 80 00 00 	movabs $0x8044cb,%rax
  80473f:	00 00 00 
  804742:	ff d0                	callq  *%rax
  804744:	85 c0                	test   %eax,%eax
  804746:	74 07                	je     80474f <devpipe_write+0x67>
				return 0;
  804748:	b8 00 00 00 00       	mov    $0x0,%eax
  80474d:	eb 79                	jmp    8047c8 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80474f:	48 b8 bb 21 80 00 00 	movabs $0x8021bb,%rax
  804756:	00 00 00 
  804759:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80475b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80475f:	8b 40 04             	mov    0x4(%rax),%eax
  804762:	48 63 d0             	movslq %eax,%rdx
  804765:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804769:	8b 00                	mov    (%rax),%eax
  80476b:	48 98                	cltq   
  80476d:	48 83 c0 20          	add    $0x20,%rax
  804771:	48 39 c2             	cmp    %rax,%rdx
  804774:	73 b4                	jae    80472a <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804776:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80477a:	8b 40 04             	mov    0x4(%rax),%eax
  80477d:	99                   	cltd   
  80477e:	c1 ea 1b             	shr    $0x1b,%edx
  804781:	01 d0                	add    %edx,%eax
  804783:	83 e0 1f             	and    $0x1f,%eax
  804786:	29 d0                	sub    %edx,%eax
  804788:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80478c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804790:	48 01 ca             	add    %rcx,%rdx
  804793:	0f b6 0a             	movzbl (%rdx),%ecx
  804796:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80479a:	48 98                	cltq   
  80479c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8047a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047a4:	8b 40 04             	mov    0x4(%rax),%eax
  8047a7:	8d 50 01             	lea    0x1(%rax),%edx
  8047aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047ae:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8047b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8047b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047ba:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8047be:	0f 82 64 ff ff ff    	jb     804728 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8047c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8047c8:	c9                   	leaveq 
  8047c9:	c3                   	retq   

00000000008047ca <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8047ca:	55                   	push   %rbp
  8047cb:	48 89 e5             	mov    %rsp,%rbp
  8047ce:	48 83 ec 20          	sub    $0x20,%rsp
  8047d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8047d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8047da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047de:	48 89 c7             	mov    %rax,%rdi
  8047e1:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  8047e8:	00 00 00 
  8047eb:	ff d0                	callq  *%rax
  8047ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8047f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047f5:	48 be a8 54 80 00 00 	movabs $0x8054a8,%rsi
  8047fc:	00 00 00 
  8047ff:	48 89 c7             	mov    %rax,%rdi
  804802:	48 b8 ca 18 80 00 00 	movabs $0x8018ca,%rax
  804809:	00 00 00 
  80480c:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80480e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804812:	8b 50 04             	mov    0x4(%rax),%edx
  804815:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804819:	8b 00                	mov    (%rax),%eax
  80481b:	29 c2                	sub    %eax,%edx
  80481d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804821:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804827:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80482b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804832:	00 00 00 
	stat->st_dev = &devpipe;
  804835:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804839:	48 b9 c0 70 80 00 00 	movabs $0x8070c0,%rcx
  804840:	00 00 00 
  804843:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80484a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80484f:	c9                   	leaveq 
  804850:	c3                   	retq   

0000000000804851 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804851:	55                   	push   %rbp
  804852:	48 89 e5             	mov    %rsp,%rbp
  804855:	48 83 ec 10          	sub    $0x10,%rsp
  804859:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80485d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804861:	48 89 c6             	mov    %rax,%rsi
  804864:	bf 00 00 00 00       	mov    $0x0,%edi
  804869:	48 b8 a4 22 80 00 00 	movabs $0x8022a4,%rax
  804870:	00 00 00 
  804873:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804875:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804879:	48 89 c7             	mov    %rax,%rdi
  80487c:	48 b8 8c 29 80 00 00 	movabs $0x80298c,%rax
  804883:	00 00 00 
  804886:	ff d0                	callq  *%rax
  804888:	48 89 c6             	mov    %rax,%rsi
  80488b:	bf 00 00 00 00       	mov    $0x0,%edi
  804890:	48 b8 a4 22 80 00 00 	movabs $0x8022a4,%rax
  804897:	00 00 00 
  80489a:	ff d0                	callq  *%rax
}
  80489c:	c9                   	leaveq 
  80489d:	c3                   	retq   

000000000080489e <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80489e:	55                   	push   %rbp
  80489f:	48 89 e5             	mov    %rsp,%rbp
  8048a2:	48 83 ec 20          	sub    $0x20,%rsp
  8048a6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8048a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8048ad:	75 35                	jne    8048e4 <wait+0x46>
  8048af:	48 b9 af 54 80 00 00 	movabs $0x8054af,%rcx
  8048b6:	00 00 00 
  8048b9:	48 ba ba 54 80 00 00 	movabs $0x8054ba,%rdx
  8048c0:	00 00 00 
  8048c3:	be 09 00 00 00       	mov    $0x9,%esi
  8048c8:	48 bf cf 54 80 00 00 	movabs $0x8054cf,%rdi
  8048cf:	00 00 00 
  8048d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8048d7:	49 b8 e9 08 80 00 00 	movabs $0x8008e9,%r8
  8048de:	00 00 00 
  8048e1:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8048e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048e7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8048ec:	48 63 d0             	movslq %eax,%rdx
  8048ef:	48 89 d0             	mov    %rdx,%rax
  8048f2:	48 c1 e0 03          	shl    $0x3,%rax
  8048f6:	48 01 d0             	add    %rdx,%rax
  8048f9:	48 c1 e0 05          	shl    $0x5,%rax
  8048fd:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804904:	00 00 00 
  804907:	48 01 d0             	add    %rdx,%rax
  80490a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80490e:	eb 0c                	jmp    80491c <wait+0x7e>
		sys_yield();
  804910:	48 b8 bb 21 80 00 00 	movabs $0x8021bb,%rax
  804917:	00 00 00 
  80491a:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80491c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804920:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804926:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804929:	75 0e                	jne    804939 <wait+0x9b>
  80492b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80492f:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804935:	85 c0                	test   %eax,%eax
  804937:	75 d7                	jne    804910 <wait+0x72>
		sys_yield();
}
  804939:	c9                   	leaveq 
  80493a:	c3                   	retq   

000000000080493b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80493b:	55                   	push   %rbp
  80493c:	48 89 e5             	mov    %rsp,%rbp
  80493f:	48 83 ec 10          	sub    $0x10,%rsp
  804943:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804947:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  80494e:	00 00 00 
  804951:	48 8b 00             	mov    (%rax),%rax
  804954:	48 85 c0             	test   %rax,%rax
  804957:	75 3a                	jne    804993 <set_pgfault_handler+0x58>
		// First time through!
		// LAB 4: Your code here.
		if (sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W) == 0)
  804959:	ba 07 00 00 00       	mov    $0x7,%edx
  80495e:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804963:	bf 00 00 00 00       	mov    $0x0,%edi
  804968:	48 b8 f9 21 80 00 00 	movabs $0x8021f9,%rax
  80496f:	00 00 00 
  804972:	ff d0                	callq  *%rax
  804974:	85 c0                	test   %eax,%eax
  804976:	75 1b                	jne    804993 <set_pgfault_handler+0x58>
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  804978:	48 be a6 49 80 00 00 	movabs $0x8049a6,%rsi
  80497f:	00 00 00 
  804982:	bf 00 00 00 00       	mov    $0x0,%edi
  804987:	48 b8 83 23 80 00 00 	movabs $0x802383,%rax
  80498e:	00 00 00 
  804991:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804993:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  80499a:	00 00 00 
  80499d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8049a1:	48 89 10             	mov    %rdx,(%rax)
}
  8049a4:	c9                   	leaveq 
  8049a5:	c3                   	retq   

00000000008049a6 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  8049a6:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  8049a9:	48 a1 08 a0 80 00 00 	movabs 0x80a008,%rax
  8049b0:	00 00 00 
	call *%rax
  8049b3:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movq %rsp, %rax		// backup stack pointer - rsp
  8049b5:	48 89 e0             	mov    %rsp,%rax

	movq 0x88(%rsp), %rbx	// read utf_rip into register
  8049b8:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8049bf:	00 
	movq 0x98(%rsp), %rsp	// read utf_rsp into register
  8049c0:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  8049c7:	00 
	pushq %rbx		// push utf_rip into new stack
  8049c8:	53                   	push   %rbx
	movq %rsp, 0x98(%rax)	// update utf_rsp after push utf_rip
  8049c9:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

	movq %rax, %rsp		// restore stack pointer - rsp
  8049d0:	48 89 c4             	mov    %rax,%rsp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $0x8, %rsp		// skip uint64_t utf_fault_va
  8049d3:	48 83 c4 08          	add    $0x8,%rsp
	addq $0x8, %rsp		// skip uint64_t utf_err
  8049d7:	48 83 c4 08          	add    $0x8,%rsp
	POPA_			// restore utf_regs
  8049db:	4c 8b 3c 24          	mov    (%rsp),%r15
  8049df:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8049e4:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8049e9:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8049ee:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8049f3:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8049f8:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8049fd:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804a02:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804a07:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804a0c:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804a11:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804a16:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804a1b:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804a20:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804a25:	48 83 c4 78          	add    $0x78,%rsp
	addq $0x8, %rsp		// skip uintptr_t utf_rip
  804a29:	48 83 c4 08          	add    $0x8,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfq			// restore uint64_t utf_eflags
  804a2d:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp		// restore uintptr_t utf_rsp
  804a2e:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  804a2f:	c3                   	retq   

0000000000804a30 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804a30:	55                   	push   %rbp
  804a31:	48 89 e5             	mov    %rsp,%rbp
  804a34:	48 83 ec 30          	sub    $0x30,%rsp
  804a38:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804a3c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804a40:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  804a44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a48:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  804a4c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804a51:	75 0e                	jne    804a61 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  804a53:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  804a5a:	00 00 00 
  804a5d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  804a61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a65:	48 89 c7             	mov    %rax,%rdi
  804a68:	48 b8 22 24 80 00 00 	movabs $0x802422,%rax
  804a6f:	00 00 00 
  804a72:	ff d0                	callq  *%rax
  804a74:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804a77:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  804a7b:	79 27                	jns    804aa4 <ipc_recv+0x74>
		if (from_env_store != NULL)
  804a7d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804a82:	74 0a                	je     804a8e <ipc_recv+0x5e>
			*from_env_store = 0;
  804a84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a88:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  804a8e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804a93:	74 0a                	je     804a9f <ipc_recv+0x6f>
			*perm_store = 0;
  804a95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a99:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804a9f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804aa2:	eb 53                	jmp    804af7 <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  804aa4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804aa9:	74 19                	je     804ac4 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  804aab:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804ab2:	00 00 00 
  804ab5:	48 8b 00             	mov    (%rax),%rax
  804ab8:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804abe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ac2:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  804ac4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804ac9:	74 19                	je     804ae4 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  804acb:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804ad2:	00 00 00 
  804ad5:	48 8b 00             	mov    (%rax),%rax
  804ad8:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804ade:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ae2:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  804ae4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804aeb:	00 00 00 
  804aee:	48 8b 00             	mov    (%rax),%rax
  804af1:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  804af7:	c9                   	leaveq 
  804af8:	c3                   	retq   

0000000000804af9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804af9:	55                   	push   %rbp
  804afa:	48 89 e5             	mov    %rsp,%rbp
  804afd:	48 83 ec 30          	sub    $0x30,%rsp
  804b01:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804b04:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804b07:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804b0b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  804b0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b12:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  804b16:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804b1b:	75 10                	jne    804b2d <ipc_send+0x34>
		page = (void *)KERNBASE;
  804b1d:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  804b24:	00 00 00 
  804b27:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  804b2b:	eb 0e                	jmp    804b3b <ipc_send+0x42>
  804b2d:	eb 0c                	jmp    804b3b <ipc_send+0x42>
		sys_yield();
  804b2f:	48 b8 bb 21 80 00 00 	movabs $0x8021bb,%rax
  804b36:	00 00 00 
  804b39:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  804b3b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804b3e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804b41:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804b45:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804b48:	89 c7                	mov    %eax,%edi
  804b4a:	48 b8 cd 23 80 00 00 	movabs $0x8023cd,%rax
  804b51:	00 00 00 
  804b54:	ff d0                	callq  *%rax
  804b56:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804b59:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  804b5d:	74 d0                	je     804b2f <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  804b5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  804b63:	74 2a                	je     804b8f <ipc_send+0x96>
		panic("error on ipc send procedure");
  804b65:	48 ba da 54 80 00 00 	movabs $0x8054da,%rdx
  804b6c:	00 00 00 
  804b6f:	be 49 00 00 00       	mov    $0x49,%esi
  804b74:	48 bf f6 54 80 00 00 	movabs $0x8054f6,%rdi
  804b7b:	00 00 00 
  804b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  804b83:	48 b9 e9 08 80 00 00 	movabs $0x8008e9,%rcx
  804b8a:	00 00 00 
  804b8d:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  804b8f:	c9                   	leaveq 
  804b90:	c3                   	retq   

0000000000804b91 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804b91:	55                   	push   %rbp
  804b92:	48 89 e5             	mov    %rsp,%rbp
  804b95:	48 83 ec 14          	sub    $0x14,%rsp
  804b99:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  804b9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804ba3:	eb 5e                	jmp    804c03 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804ba5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804bac:	00 00 00 
  804baf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bb2:	48 63 d0             	movslq %eax,%rdx
  804bb5:	48 89 d0             	mov    %rdx,%rax
  804bb8:	48 c1 e0 03          	shl    $0x3,%rax
  804bbc:	48 01 d0             	add    %rdx,%rax
  804bbf:	48 c1 e0 05          	shl    $0x5,%rax
  804bc3:	48 01 c8             	add    %rcx,%rax
  804bc6:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804bcc:	8b 00                	mov    (%rax),%eax
  804bce:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804bd1:	75 2c                	jne    804bff <ipc_find_env+0x6e>
			return envs[i].env_id;
  804bd3:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804bda:	00 00 00 
  804bdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804be0:	48 63 d0             	movslq %eax,%rdx
  804be3:	48 89 d0             	mov    %rdx,%rax
  804be6:	48 c1 e0 03          	shl    $0x3,%rax
  804bea:	48 01 d0             	add    %rdx,%rax
  804bed:	48 c1 e0 05          	shl    $0x5,%rax
  804bf1:	48 01 c8             	add    %rcx,%rax
  804bf4:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804bfa:	8b 40 08             	mov    0x8(%rax),%eax
  804bfd:	eb 12                	jmp    804c11 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804bff:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804c03:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804c0a:	7e 99                	jle    804ba5 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  804c0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804c11:	c9                   	leaveq 
  804c12:	c3                   	retq   

0000000000804c13 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804c13:	55                   	push   %rbp
  804c14:	48 89 e5             	mov    %rsp,%rbp
  804c17:	48 83 ec 18          	sub    $0x18,%rsp
  804c1b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804c1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c23:	48 c1 e8 15          	shr    $0x15,%rax
  804c27:	48 89 c2             	mov    %rax,%rdx
  804c2a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804c31:	01 00 00 
  804c34:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c38:	83 e0 01             	and    $0x1,%eax
  804c3b:	48 85 c0             	test   %rax,%rax
  804c3e:	75 07                	jne    804c47 <pageref+0x34>
		return 0;
  804c40:	b8 00 00 00 00       	mov    $0x0,%eax
  804c45:	eb 53                	jmp    804c9a <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804c47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c4b:	48 c1 e8 0c          	shr    $0xc,%rax
  804c4f:	48 89 c2             	mov    %rax,%rdx
  804c52:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804c59:	01 00 00 
  804c5c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c60:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804c64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c68:	83 e0 01             	and    $0x1,%eax
  804c6b:	48 85 c0             	test   %rax,%rax
  804c6e:	75 07                	jne    804c77 <pageref+0x64>
		return 0;
  804c70:	b8 00 00 00 00       	mov    $0x0,%eax
  804c75:	eb 23                	jmp    804c9a <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804c77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c7b:	48 c1 e8 0c          	shr    $0xc,%rax
  804c7f:	48 89 c2             	mov    %rax,%rdx
  804c82:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804c89:	00 00 00 
  804c8c:	48 c1 e2 04          	shl    $0x4,%rdx
  804c90:	48 01 d0             	add    %rdx,%rax
  804c93:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804c97:	0f b7 c0             	movzwl %ax,%eax
}
  804c9a:	c9                   	leaveq 
  804c9b:	c3                   	retq   
