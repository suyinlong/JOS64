
obj/user/writemotd.debug:     file format elf64-x86-64


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
  80003c:	e8 36 03 00 00       	callq  800377 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80004e:	89 bd ec fd ff ff    	mov    %edi,-0x214(%rbp)
  800054:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int rfd, wfd;
	char buf[512];
	int n, r;

	if ((rfd = open("/newmotd", O_RDONLY)) < 0)
  80005b:	be 00 00 00 00       	mov    $0x0,%esi
  800060:	48 bf 20 38 80 00 00 	movabs $0x803820,%rdi
  800067:	00 00 00 
  80006a:	48 b8 95 29 80 00 00 	movabs $0x802995,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	79 30                	jns    8000af <umain+0x6c>
		panic("open /newmotd: %e", rfd);
  80007f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800082:	89 c1                	mov    %eax,%ecx
  800084:	48 ba 29 38 80 00 00 	movabs $0x803829,%rdx
  80008b:	00 00 00 
  80008e:	be 0b 00 00 00       	mov    $0xb,%esi
  800093:	48 bf 3b 38 80 00 00 	movabs $0x80383b,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	49 b8 2a 04 80 00 00 	movabs $0x80042a,%r8
  8000a9:	00 00 00 
  8000ac:	41 ff d0             	callq  *%r8
	if ((wfd = open("/motd", O_RDWR)) < 0)
  8000af:	be 02 00 00 00       	mov    $0x2,%esi
  8000b4:	48 bf 4c 38 80 00 00 	movabs $0x80384c,%rdi
  8000bb:	00 00 00 
  8000be:	48 b8 95 29 80 00 00 	movabs $0x802995,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d1:	79 30                	jns    800103 <umain+0xc0>
		panic("open /motd: %e", wfd);
  8000d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d6:	89 c1                	mov    %eax,%ecx
  8000d8:	48 ba 52 38 80 00 00 	movabs $0x803852,%rdx
  8000df:	00 00 00 
  8000e2:	be 0d 00 00 00       	mov    $0xd,%esi
  8000e7:	48 bf 3b 38 80 00 00 	movabs $0x80383b,%rdi
  8000ee:	00 00 00 
  8000f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f6:	49 b8 2a 04 80 00 00 	movabs $0x80042a,%r8
  8000fd:	00 00 00 
  800100:	41 ff d0             	callq  *%r8
	cprintf("file descriptors %d %d\n", rfd, wfd);
  800103:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800109:	89 c6                	mov    %eax,%esi
  80010b:	48 bf 61 38 80 00 00 	movabs $0x803861,%rdi
  800112:	00 00 00 
  800115:	b8 00 00 00 00       	mov    $0x0,%eax
  80011a:	48 b9 63 06 80 00 00 	movabs $0x800663,%rcx
  800121:	00 00 00 
  800124:	ff d1                	callq  *%rcx
	if (rfd == wfd)
  800126:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800129:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  80012c:	75 2a                	jne    800158 <umain+0x115>
		panic("open /newmotd and /motd give same file descriptor");
  80012e:	48 ba 80 38 80 00 00 	movabs $0x803880,%rdx
  800135:	00 00 00 
  800138:	be 10 00 00 00       	mov    $0x10,%esi
  80013d:	48 bf 3b 38 80 00 00 	movabs $0x80383b,%rdi
  800144:	00 00 00 
  800147:	b8 00 00 00 00       	mov    $0x0,%eax
  80014c:	48 b9 2a 04 80 00 00 	movabs $0x80042a,%rcx
  800153:	00 00 00 
  800156:	ff d1                	callq  *%rcx

	cprintf("OLD MOTD\n===\n");
  800158:	48 bf b2 38 80 00 00 	movabs $0x8038b2,%rdi
  80015f:	00 00 00 
  800162:	b8 00 00 00 00       	mov    $0x0,%eax
  800167:	48 ba 63 06 80 00 00 	movabs $0x800663,%rdx
  80016e:	00 00 00 
  800171:	ff d2                	callq  *%rdx
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800173:	eb 1f                	jmp    800194 <umain+0x151>
		sys_cputs(buf, n);
  800175:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800178:	48 63 d0             	movslq %eax,%rdx
  80017b:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800182:	48 89 d6             	mov    %rdx,%rsi
  800185:	48 89 c7             	mov    %rax,%rdi
  800188:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  80018f:	00 00 00 
  800192:	ff d0                	callq  *%rax
	cprintf("file descriptors %d %d\n", rfd, wfd);
	if (rfd == wfd)
		panic("open /newmotd and /motd give same file descriptor");

	cprintf("OLD MOTD\n===\n");
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800194:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80019b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019e:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8001a3:	48 89 ce             	mov    %rcx,%rsi
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	48 b8 bf 24 80 00 00 	movabs $0x8024bf,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	callq  *%rax
  8001b4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8001b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8001bb:	7f b8                	jg     800175 <umain+0x132>
		sys_cputs(buf, n);
	cprintf("===\n");
  8001bd:	48 bf c0 38 80 00 00 	movabs $0x8038c0,%rdi
  8001c4:	00 00 00 
  8001c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cc:	48 ba 63 06 80 00 00 	movabs $0x800663,%rdx
  8001d3:	00 00 00 
  8001d6:	ff d2                	callq  *%rdx
	seek(wfd, 0);
  8001d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001db:	be 00 00 00 00       	mov    $0x0,%esi
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	48 b8 dd 26 80 00 00 	movabs $0x8026dd,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	callq  *%rax

	if ((r = ftruncate(wfd, 0)) < 0)
  8001ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f1:	be 00 00 00 00       	mov    $0x0,%esi
  8001f6:	89 c7                	mov    %eax,%edi
  8001f8:	48 b8 22 27 80 00 00 	movabs $0x802722,%rax
  8001ff:	00 00 00 
  800202:	ff d0                	callq  *%rax
  800204:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800207:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1fa>
		panic("truncate /motd: %e", r);
  80020d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba c5 38 80 00 00 	movabs $0x8038c5,%rdx
  800219:	00 00 00 
  80021c:	be 19 00 00 00       	mov    $0x19,%esi
  800221:	48 bf 3b 38 80 00 00 	movabs $0x80383b,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 2a 04 80 00 00 	movabs $0x80042a,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8

	cprintf("NEW MOTD\n===\n");
  80023d:	48 bf d8 38 80 00 00 	movabs $0x8038d8,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	48 ba 63 06 80 00 00 	movabs $0x800663,%rdx
  800253:	00 00 00 
  800256:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  800258:	eb 7b                	jmp    8002d5 <umain+0x292>
		sys_cputs(buf, n);
  80025a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80025d:	48 63 d0             	movslq %eax,%rdx
  800260:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800267:	48 89 d6             	mov    %rdx,%rsi
  80026a:	48 89 c7             	mov    %rax,%rdi
  80026d:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  800274:	00 00 00 
  800277:	ff d0                	callq  *%rax
		if ((r = write(wfd, buf, n)) != n)
  800279:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80027c:	48 63 d0             	movslq %eax,%rdx
  80027f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  800286:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800289:	48 89 ce             	mov    %rcx,%rsi
  80028c:	89 c7                	mov    %eax,%edi
  80028e:	48 b8 09 26 80 00 00 	movabs $0x802609,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8002a3:	74 30                	je     8002d5 <umain+0x292>
			panic("write /motd: %e", r);
  8002a5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a8:	89 c1                	mov    %eax,%ecx
  8002aa:	48 ba e6 38 80 00 00 	movabs $0x8038e6,%rdx
  8002b1:	00 00 00 
  8002b4:	be 1f 00 00 00       	mov    $0x1f,%esi
  8002b9:	48 bf 3b 38 80 00 00 	movabs $0x80383b,%rdi
  8002c0:	00 00 00 
  8002c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c8:	49 b8 2a 04 80 00 00 	movabs $0x80042a,%r8
  8002cf:	00 00 00 
  8002d2:	41 ff d0             	callq  *%r8

	if ((r = ftruncate(wfd, 0)) < 0)
		panic("truncate /motd: %e", r);

	cprintf("NEW MOTD\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  8002d5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8002dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002df:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8002e4:	48 89 ce             	mov    %rcx,%rsi
  8002e7:	89 c7                	mov    %eax,%edi
  8002e9:	48 b8 bf 24 80 00 00 	movabs $0x8024bf,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	callq  *%rax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8002fc:	0f 8f 58 ff ff ff    	jg     80025a <umain+0x217>
		sys_cputs(buf, n);
		if ((r = write(wfd, buf, n)) != n)
			panic("write /motd: %e", r);
	}
	cprintf("===\n");
  800302:	48 bf c0 38 80 00 00 	movabs $0x8038c0,%rdi
  800309:	00 00 00 
  80030c:	b8 00 00 00 00       	mov    $0x0,%eax
  800311:	48 ba 63 06 80 00 00 	movabs $0x800663,%rdx
  800318:	00 00 00 
  80031b:	ff d2                	callq  *%rdx

	if (n < 0)
  80031d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800321:	79 30                	jns    800353 <umain+0x310>
		panic("read /newmotd: %e", n);
  800323:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800326:	89 c1                	mov    %eax,%ecx
  800328:	48 ba f6 38 80 00 00 	movabs $0x8038f6,%rdx
  80032f:	00 00 00 
  800332:	be 24 00 00 00       	mov    $0x24,%esi
  800337:	48 bf 3b 38 80 00 00 	movabs $0x80383b,%rdi
  80033e:	00 00 00 
  800341:	b8 00 00 00 00       	mov    $0x0,%eax
  800346:	49 b8 2a 04 80 00 00 	movabs $0x80042a,%r8
  80034d:	00 00 00 
  800350:	41 ff d0             	callq  *%r8

	close(rfd);
  800353:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800356:	89 c7                	mov    %eax,%edi
  800358:	48 b8 9d 22 80 00 00 	movabs $0x80229d,%rax
  80035f:	00 00 00 
  800362:	ff d0                	callq  *%rax
	close(wfd);
  800364:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800367:	89 c7                	mov    %eax,%edi
  800369:	48 b8 9d 22 80 00 00 	movabs $0x80229d,%rax
  800370:	00 00 00 
  800373:	ff d0                	callq  *%rax
}
  800375:	c9                   	leaveq 
  800376:	c3                   	retq   

0000000000800377 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800377:	55                   	push   %rbp
  800378:	48 89 e5             	mov    %rsp,%rbp
  80037b:	48 83 ec 10          	sub    $0x10,%rsp
  80037f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800382:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = envs + ENVX(sys_getenvid());
  800386:	48 b8 be 1c 80 00 00 	movabs $0x801cbe,%rax
  80038d:	00 00 00 
  800390:	ff d0                	callq  *%rax
  800392:	48 98                	cltq   
  800394:	25 ff 03 00 00       	and    $0x3ff,%eax
  800399:	48 89 c2             	mov    %rax,%rdx
  80039c:	48 89 d0             	mov    %rdx,%rax
  80039f:	48 c1 e0 03          	shl    $0x3,%rax
  8003a3:	48 01 d0             	add    %rdx,%rax
  8003a6:	48 c1 e0 05          	shl    $0x5,%rax
  8003aa:	48 89 c2             	mov    %rax,%rdx
  8003ad:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8003b4:	00 00 00 
  8003b7:	48 01 c2             	add    %rax,%rdx
  8003ba:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003c1:	00 00 00 
  8003c4:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003cb:	7e 14                	jle    8003e1 <libmain+0x6a>
		binaryname = argv[0];
  8003cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d1:	48 8b 10             	mov    (%rax),%rdx
  8003d4:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8003db:	00 00 00 
  8003de:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003e8:	48 89 d6             	mov    %rdx,%rsi
  8003eb:	89 c7                	mov    %eax,%edi
  8003ed:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003f4:	00 00 00 
  8003f7:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003f9:	48 b8 07 04 80 00 00 	movabs $0x800407,%rax
  800400:	00 00 00 
  800403:	ff d0                	callq  *%rax
}
  800405:	c9                   	leaveq 
  800406:	c3                   	retq   

0000000000800407 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800407:	55                   	push   %rbp
  800408:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80040b:	48 b8 e8 22 80 00 00 	movabs $0x8022e8,%rax
  800412:	00 00 00 
  800415:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800417:	bf 00 00 00 00       	mov    $0x0,%edi
  80041c:	48 b8 7a 1c 80 00 00 	movabs $0x801c7a,%rax
  800423:	00 00 00 
  800426:	ff d0                	callq  *%rax
}
  800428:	5d                   	pop    %rbp
  800429:	c3                   	retq   

000000000080042a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80042a:	55                   	push   %rbp
  80042b:	48 89 e5             	mov    %rsp,%rbp
  80042e:	53                   	push   %rbx
  80042f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800436:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80043d:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800443:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80044a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800451:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800458:	84 c0                	test   %al,%al
  80045a:	74 23                	je     80047f <_panic+0x55>
  80045c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800463:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800467:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80046b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80046f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800473:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800477:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80047b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80047f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800486:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80048d:	00 00 00 
  800490:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800497:	00 00 00 
  80049a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80049e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004a5:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004ac:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004b3:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8004ba:	00 00 00 
  8004bd:	48 8b 18             	mov    (%rax),%rbx
  8004c0:	48 b8 be 1c 80 00 00 	movabs $0x801cbe,%rax
  8004c7:	00 00 00 
  8004ca:	ff d0                	callq  *%rax
  8004cc:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004d2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004d9:	41 89 c8             	mov    %ecx,%r8d
  8004dc:	48 89 d1             	mov    %rdx,%rcx
  8004df:	48 89 da             	mov    %rbx,%rdx
  8004e2:	89 c6                	mov    %eax,%esi
  8004e4:	48 bf 18 39 80 00 00 	movabs $0x803918,%rdi
  8004eb:	00 00 00 
  8004ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f3:	49 b9 63 06 80 00 00 	movabs $0x800663,%r9
  8004fa:	00 00 00 
  8004fd:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800500:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800507:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80050e:	48 89 d6             	mov    %rdx,%rsi
  800511:	48 89 c7             	mov    %rax,%rdi
  800514:	48 b8 b7 05 80 00 00 	movabs $0x8005b7,%rax
  80051b:	00 00 00 
  80051e:	ff d0                	callq  *%rax
	cprintf("\n");
  800520:	48 bf 3b 39 80 00 00 	movabs $0x80393b,%rdi
  800527:	00 00 00 
  80052a:	b8 00 00 00 00       	mov    $0x0,%eax
  80052f:	48 ba 63 06 80 00 00 	movabs $0x800663,%rdx
  800536:	00 00 00 
  800539:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80053b:	cc                   	int3   
  80053c:	eb fd                	jmp    80053b <_panic+0x111>

000000000080053e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80053e:	55                   	push   %rbp
  80053f:	48 89 e5             	mov    %rsp,%rbp
  800542:	48 83 ec 10          	sub    $0x10,%rsp
  800546:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800549:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80054d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800551:	8b 00                	mov    (%rax),%eax
  800553:	8d 48 01             	lea    0x1(%rax),%ecx
  800556:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80055a:	89 0a                	mov    %ecx,(%rdx)
  80055c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80055f:	89 d1                	mov    %edx,%ecx
  800561:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800565:	48 98                	cltq   
  800567:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80056b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80056f:	8b 00                	mov    (%rax),%eax
  800571:	3d ff 00 00 00       	cmp    $0xff,%eax
  800576:	75 2c                	jne    8005a4 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800578:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80057c:	8b 00                	mov    (%rax),%eax
  80057e:	48 98                	cltq   
  800580:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800584:	48 83 c2 08          	add    $0x8,%rdx
  800588:	48 89 c6             	mov    %rax,%rsi
  80058b:	48 89 d7             	mov    %rdx,%rdi
  80058e:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  800595:	00 00 00 
  800598:	ff d0                	callq  *%rax
		b->idx = 0;
  80059a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80059e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8005a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005a8:	8b 40 04             	mov    0x4(%rax),%eax
  8005ab:	8d 50 01             	lea    0x1(%rax),%edx
  8005ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005b2:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005b5:	c9                   	leaveq 
  8005b6:	c3                   	retq   

00000000008005b7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005b7:	55                   	push   %rbp
  8005b8:	48 89 e5             	mov    %rsp,%rbp
  8005bb:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005c2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005c9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8005d0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005d7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005de:	48 8b 0a             	mov    (%rdx),%rcx
  8005e1:	48 89 08             	mov    %rcx,(%rax)
  8005e4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005e8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005ec:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005f0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8005f4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005fb:	00 00 00 
	b.cnt = 0;
  8005fe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800605:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800608:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80060f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800616:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80061d:	48 89 c6             	mov    %rax,%rsi
  800620:	48 bf 3e 05 80 00 00 	movabs $0x80053e,%rdi
  800627:	00 00 00 
  80062a:	48 b8 16 0a 80 00 00 	movabs $0x800a16,%rax
  800631:	00 00 00 
  800634:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800636:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80063c:	48 98                	cltq   
  80063e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800645:	48 83 c2 08          	add    $0x8,%rdx
  800649:	48 89 c6             	mov    %rax,%rsi
  80064c:	48 89 d7             	mov    %rdx,%rdi
  80064f:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  800656:	00 00 00 
  800659:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80065b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800661:	c9                   	leaveq 
  800662:	c3                   	retq   

0000000000800663 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800663:	55                   	push   %rbp
  800664:	48 89 e5             	mov    %rsp,%rbp
  800667:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80066e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800675:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80067c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800683:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80068a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800691:	84 c0                	test   %al,%al
  800693:	74 20                	je     8006b5 <cprintf+0x52>
  800695:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800699:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80069d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8006a1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006a5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006a9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006ad:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006b1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006b5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8006bc:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006c3:	00 00 00 
  8006c6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006cd:	00 00 00 
  8006d0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006d4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006db:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006e2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8006e9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006f0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006f7:	48 8b 0a             	mov    (%rdx),%rcx
  8006fa:	48 89 08             	mov    %rcx,(%rax)
  8006fd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800701:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800705:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800709:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80070d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800714:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80071b:	48 89 d6             	mov    %rdx,%rsi
  80071e:	48 89 c7             	mov    %rax,%rdi
  800721:	48 b8 b7 05 80 00 00 	movabs $0x8005b7,%rax
  800728:	00 00 00 
  80072b:	ff d0                	callq  *%rax
  80072d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800733:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800739:	c9                   	leaveq 
  80073a:	c3                   	retq   

000000000080073b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80073b:	55                   	push   %rbp
  80073c:	48 89 e5             	mov    %rsp,%rbp
  80073f:	53                   	push   %rbx
  800740:	48 83 ec 38          	sub    $0x38,%rsp
  800744:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800748:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80074c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800750:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800753:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800757:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80075b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80075e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800762:	77 3b                	ja     80079f <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800764:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800767:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80076b:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80076e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800772:	ba 00 00 00 00       	mov    $0x0,%edx
  800777:	48 f7 f3             	div    %rbx
  80077a:	48 89 c2             	mov    %rax,%rdx
  80077d:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800780:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800783:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800787:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078b:	41 89 f9             	mov    %edi,%r9d
  80078e:	48 89 c7             	mov    %rax,%rdi
  800791:	48 b8 3b 07 80 00 00 	movabs $0x80073b,%rax
  800798:	00 00 00 
  80079b:	ff d0                	callq  *%rax
  80079d:	eb 1e                	jmp    8007bd <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80079f:	eb 12                	jmp    8007b3 <printnum+0x78>
			putch(padc, putdat);
  8007a1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007a5:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8007a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ac:	48 89 ce             	mov    %rcx,%rsi
  8007af:	89 d7                	mov    %edx,%edi
  8007b1:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b3:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8007b7:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8007bb:	7f e4                	jg     8007a1 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007bd:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c9:	48 f7 f1             	div    %rcx
  8007cc:	48 89 d0             	mov    %rdx,%rax
  8007cf:	48 ba 08 3b 80 00 00 	movabs $0x803b08,%rdx
  8007d6:	00 00 00 
  8007d9:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007dd:	0f be d0             	movsbl %al,%edx
  8007e0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e8:	48 89 ce             	mov    %rcx,%rsi
  8007eb:	89 d7                	mov    %edx,%edi
  8007ed:	ff d0                	callq  *%rax
}
  8007ef:	48 83 c4 38          	add    $0x38,%rsp
  8007f3:	5b                   	pop    %rbx
  8007f4:	5d                   	pop    %rbp
  8007f5:	c3                   	retq   

00000000008007f6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007f6:	55                   	push   %rbp
  8007f7:	48 89 e5             	mov    %rsp,%rbp
  8007fa:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800802:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;
	if (lflag >= 2)
  800805:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800809:	7e 52                	jle    80085d <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80080b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080f:	8b 00                	mov    (%rax),%eax
  800811:	83 f8 30             	cmp    $0x30,%eax
  800814:	73 24                	jae    80083a <getuint+0x44>
  800816:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80081e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800822:	8b 00                	mov    (%rax),%eax
  800824:	89 c0                	mov    %eax,%eax
  800826:	48 01 d0             	add    %rdx,%rax
  800829:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082d:	8b 12                	mov    (%rdx),%edx
  80082f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800832:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800836:	89 0a                	mov    %ecx,(%rdx)
  800838:	eb 17                	jmp    800851 <getuint+0x5b>
  80083a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800842:	48 89 d0             	mov    %rdx,%rax
  800845:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800849:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800851:	48 8b 00             	mov    (%rax),%rax
  800854:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800858:	e9 a3 00 00 00       	jmpq   800900 <getuint+0x10a>
	else if (lflag)
  80085d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800861:	74 4f                	je     8008b2 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800863:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800867:	8b 00                	mov    (%rax),%eax
  800869:	83 f8 30             	cmp    $0x30,%eax
  80086c:	73 24                	jae    800892 <getuint+0x9c>
  80086e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800872:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800876:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087a:	8b 00                	mov    (%rax),%eax
  80087c:	89 c0                	mov    %eax,%eax
  80087e:	48 01 d0             	add    %rdx,%rax
  800881:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800885:	8b 12                	mov    (%rdx),%edx
  800887:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80088a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088e:	89 0a                	mov    %ecx,(%rdx)
  800890:	eb 17                	jmp    8008a9 <getuint+0xb3>
  800892:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800896:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80089a:	48 89 d0             	mov    %rdx,%rax
  80089d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008a9:	48 8b 00             	mov    (%rax),%rax
  8008ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008b0:	eb 4e                	jmp    800900 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b6:	8b 00                	mov    (%rax),%eax
  8008b8:	83 f8 30             	cmp    $0x30,%eax
  8008bb:	73 24                	jae    8008e1 <getuint+0xeb>
  8008bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c9:	8b 00                	mov    (%rax),%eax
  8008cb:	89 c0                	mov    %eax,%eax
  8008cd:	48 01 d0             	add    %rdx,%rax
  8008d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d4:	8b 12                	mov    (%rdx),%edx
  8008d6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008dd:	89 0a                	mov    %ecx,(%rdx)
  8008df:	eb 17                	jmp    8008f8 <getuint+0x102>
  8008e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008e9:	48 89 d0             	mov    %rdx,%rax
  8008ec:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008f8:	8b 00                	mov    (%rax),%eax
  8008fa:	89 c0                	mov    %eax,%eax
  8008fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800900:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800904:	c9                   	leaveq 
  800905:	c3                   	retq   

0000000000800906 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800906:	55                   	push   %rbp
  800907:	48 89 e5             	mov    %rsp,%rbp
  80090a:	48 83 ec 1c          	sub    $0x1c,%rsp
  80090e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800912:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800915:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800919:	7e 52                	jle    80096d <getint+0x67>
		x=va_arg(*ap, long long);
  80091b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091f:	8b 00                	mov    (%rax),%eax
  800921:	83 f8 30             	cmp    $0x30,%eax
  800924:	73 24                	jae    80094a <getint+0x44>
  800926:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80092e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800932:	8b 00                	mov    (%rax),%eax
  800934:	89 c0                	mov    %eax,%eax
  800936:	48 01 d0             	add    %rdx,%rax
  800939:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093d:	8b 12                	mov    (%rdx),%edx
  80093f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800942:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800946:	89 0a                	mov    %ecx,(%rdx)
  800948:	eb 17                	jmp    800961 <getint+0x5b>
  80094a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800952:	48 89 d0             	mov    %rdx,%rax
  800955:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800959:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800961:	48 8b 00             	mov    (%rax),%rax
  800964:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800968:	e9 a3 00 00 00       	jmpq   800a10 <getint+0x10a>
	else if (lflag)
  80096d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800971:	74 4f                	je     8009c2 <getint+0xbc>
		x=va_arg(*ap, long);
  800973:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800977:	8b 00                	mov    (%rax),%eax
  800979:	83 f8 30             	cmp    $0x30,%eax
  80097c:	73 24                	jae    8009a2 <getint+0x9c>
  80097e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800982:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800986:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098a:	8b 00                	mov    (%rax),%eax
  80098c:	89 c0                	mov    %eax,%eax
  80098e:	48 01 d0             	add    %rdx,%rax
  800991:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800995:	8b 12                	mov    (%rdx),%edx
  800997:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80099a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099e:	89 0a                	mov    %ecx,(%rdx)
  8009a0:	eb 17                	jmp    8009b9 <getint+0xb3>
  8009a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009aa:	48 89 d0             	mov    %rdx,%rax
  8009ad:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009b9:	48 8b 00             	mov    (%rax),%rax
  8009bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009c0:	eb 4e                	jmp    800a10 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c6:	8b 00                	mov    (%rax),%eax
  8009c8:	83 f8 30             	cmp    $0x30,%eax
  8009cb:	73 24                	jae    8009f1 <getint+0xeb>
  8009cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d9:	8b 00                	mov    (%rax),%eax
  8009db:	89 c0                	mov    %eax,%eax
  8009dd:	48 01 d0             	add    %rdx,%rax
  8009e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e4:	8b 12                	mov    (%rdx),%edx
  8009e6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ed:	89 0a                	mov    %ecx,(%rdx)
  8009ef:	eb 17                	jmp    800a08 <getint+0x102>
  8009f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009f9:	48 89 d0             	mov    %rdx,%rax
  8009fc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a00:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a04:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a08:	8b 00                	mov    (%rax),%eax
  800a0a:	48 98                	cltq   
  800a0c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a14:	c9                   	leaveq 
  800a15:	c3                   	retq   

0000000000800a16 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a16:	55                   	push   %rbp
  800a17:	48 89 e5             	mov    %rsp,%rbp
  800a1a:	41 54                	push   %r12
  800a1c:	53                   	push   %rbx
  800a1d:	48 83 ec 60          	sub    $0x60,%rsp
  800a21:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a25:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a29:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a2d:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err, esc_color;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a31:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a35:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a39:	48 8b 0a             	mov    (%rdx),%rcx
  800a3c:	48 89 08             	mov    %rcx,(%rax)
  800a3f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a43:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a47:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a4b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		ch = *(unsigned char *) fmt++;
  800a4f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a53:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a57:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a5b:	0f b6 00             	movzbl (%rax),%eax
  800a5e:	0f b6 d8             	movzbl %al,%ebx
		while (ch != '%' && ch != '\033') {
  800a61:	eb 29                	jmp    800a8c <vprintfmt+0x76>
			if (ch == '\0')
  800a63:	85 db                	test   %ebx,%ebx
  800a65:	0f 84 ad 06 00 00    	je     801118 <vprintfmt+0x702>
				return;
			putch(ch, putdat);
  800a6b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a73:	48 89 d6             	mov    %rdx,%rsi
  800a76:	89 df                	mov    %ebx,%edi
  800a78:	ff d0                	callq  *%rax
			ch = *(unsigned char *) fmt++;
  800a7a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a7e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a82:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a86:	0f b6 00             	movzbl (%rax),%eax
  800a89:	0f b6 d8             	movzbl %al,%ebx
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		ch = *(unsigned char *) fmt++;
		while (ch != '%' && ch != '\033') {
  800a8c:	83 fb 25             	cmp    $0x25,%ebx
  800a8f:	74 05                	je     800a96 <vprintfmt+0x80>
  800a91:	83 fb 1b             	cmp    $0x1b,%ebx
  800a94:	75 cd                	jne    800a63 <vprintfmt+0x4d>
				return;
			putch(ch, putdat);
			ch = *(unsigned char *) fmt++;
		}

		if (ch == '\033') {
  800a96:	83 fb 1b             	cmp    $0x1b,%ebx
  800a99:	0f 85 ae 01 00 00    	jne    800c4d <vprintfmt+0x237>
			// set parsing status to 1, which will temporarily disable the char display sent to CGA
			// but will not affect serial and lpt
			color_parsing = 1;
  800a9f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800aa6:	00 00 00 
  800aa9:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
			// read Escape sequence
			putch(ch, putdat);
  800aaf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ab3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab7:	48 89 d6             	mov    %rdx,%rsi
  800aba:	89 df                	mov    %ebx,%edi
  800abc:	ff d0                	callq  *%rax
			putch('[', putdat);
  800abe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ac2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac6:	48 89 d6             	mov    %rdx,%rsi
  800ac9:	bf 5b 00 00 00       	mov    $0x5b,%edi
  800ace:	ff d0                	callq  *%rax
			// read number
			while (1) {
				esc_color = 0;
  800ad0:	41 bc 00 00 00 00    	mov    $0x0,%r12d
				ch = *(unsigned char *) ++fmt;
  800ad6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800adb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800adf:	0f b6 00             	movzbl (%rax),%eax
  800ae2:	0f b6 d8             	movzbl %al,%ebx
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800ae5:	eb 32                	jmp    800b19 <vprintfmt+0x103>
					putch(ch, putdat);
  800ae7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aeb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aef:	48 89 d6             	mov    %rdx,%rsi
  800af2:	89 df                	mov    %ebx,%edi
  800af4:	ff d0                	callq  *%rax
					esc_color *= 10;
  800af6:	44 89 e0             	mov    %r12d,%eax
  800af9:	c1 e0 02             	shl    $0x2,%eax
  800afc:	44 01 e0             	add    %r12d,%eax
  800aff:	01 c0                	add    %eax,%eax
  800b01:	41 89 c4             	mov    %eax,%r12d
					esc_color += ch - '0';
  800b04:	8d 43 d0             	lea    -0x30(%rbx),%eax
  800b07:	41 01 c4             	add    %eax,%r12d
					ch = *(unsigned char *) ++fmt;
  800b0a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800b0f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b13:	0f b6 00             	movzbl (%rax),%eax
  800b16:	0f b6 d8             	movzbl %al,%ebx
			// read number
			while (1) {
				esc_color = 0;
				ch = *(unsigned char *) ++fmt;
				// if encounter ';' or 'm', then we got our number
				while (ch != ';' && ch != 'm') {
  800b19:	83 fb 3b             	cmp    $0x3b,%ebx
  800b1c:	74 05                	je     800b23 <vprintfmt+0x10d>
  800b1e:	83 fb 6d             	cmp    $0x6d,%ebx
  800b21:	75 c4                	jne    800ae7 <vprintfmt+0xd1>
					esc_color += ch - '0';
					ch = *(unsigned char *) ++fmt;
				}

				// interpret number
				if (esc_color == 0)
  800b23:	45 85 e4             	test   %r12d,%r12d
  800b26:	75 15                	jne    800b3d <vprintfmt+0x127>
					color_flag = 0x07;
  800b28:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800b2f:	00 00 00 
  800b32:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800b38:	e9 dc 00 00 00       	jmpq   800c19 <vprintfmt+0x203>
				else if (esc_color >= 30 && esc_color <= 37) {
  800b3d:	41 83 fc 1d          	cmp    $0x1d,%r12d
  800b41:	7e 69                	jle    800bac <vprintfmt+0x196>
  800b43:	41 83 fc 25          	cmp    $0x25,%r12d
  800b47:	7f 63                	jg     800bac <vprintfmt+0x196>
					// foreground colors
					color_flag &= 0xf8;
  800b49:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800b50:	00 00 00 
  800b53:	8b 00                	mov    (%rax),%eax
  800b55:	25 f8 00 00 00       	and    $0xf8,%eax
  800b5a:	89 c2                	mov    %eax,%edx
  800b5c:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800b63:	00 00 00 
  800b66:	89 10                	mov    %edx,(%rax)
					esc_color -= 30;
  800b68:	41 83 ec 1e          	sub    $0x1e,%r12d
					color_flag |= color_fun(esc_color);
  800b6c:	44 89 e0             	mov    %r12d,%eax
  800b6f:	83 e0 04             	and    $0x4,%eax
  800b72:	c1 f8 02             	sar    $0x2,%eax
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	44 89 e0             	mov    %r12d,%eax
  800b7a:	83 e0 02             	and    $0x2,%eax
  800b7d:	09 c2                	or     %eax,%edx
  800b7f:	44 89 e0             	mov    %r12d,%eax
  800b82:	83 e0 01             	and    $0x1,%eax
  800b85:	c1 e0 02             	shl    $0x2,%eax
  800b88:	09 c2                	or     %eax,%edx
  800b8a:	41 89 d4             	mov    %edx,%r12d
  800b8d:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800b94:	00 00 00 
  800b97:	8b 00                	mov    (%rax),%eax
  800b99:	44 89 e2             	mov    %r12d,%edx
  800b9c:	09 c2                	or     %eax,%edx
  800b9e:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800ba5:	00 00 00 
  800ba8:	89 10                	mov    %edx,(%rax)
  800baa:	eb 6d                	jmp    800c19 <vprintfmt+0x203>
				}
				else if (esc_color >= 40 && esc_color <= 47) {
  800bac:	41 83 fc 27          	cmp    $0x27,%r12d
  800bb0:	7e 67                	jle    800c19 <vprintfmt+0x203>
  800bb2:	41 83 fc 2f          	cmp    $0x2f,%r12d
  800bb6:	7f 61                	jg     800c19 <vprintfmt+0x203>
					// background colors
					color_flag &= 0x8f;
  800bb8:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800bbf:	00 00 00 
  800bc2:	8b 00                	mov    (%rax),%eax
  800bc4:	25 8f 00 00 00       	and    $0x8f,%eax
  800bc9:	89 c2                	mov    %eax,%edx
  800bcb:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800bd2:	00 00 00 
  800bd5:	89 10                	mov    %edx,(%rax)
					esc_color -= 40;
  800bd7:	41 83 ec 28          	sub    $0x28,%r12d
					color_flag |= (color_fun(esc_color) << 4);
  800bdb:	44 89 e0             	mov    %r12d,%eax
  800bde:	83 e0 04             	and    $0x4,%eax
  800be1:	c1 f8 02             	sar    $0x2,%eax
  800be4:	89 c2                	mov    %eax,%edx
  800be6:	44 89 e0             	mov    %r12d,%eax
  800be9:	83 e0 02             	and    $0x2,%eax
  800bec:	09 c2                	or     %eax,%edx
  800bee:	44 89 e0             	mov    %r12d,%eax
  800bf1:	83 e0 01             	and    $0x1,%eax
  800bf4:	c1 e0 06             	shl    $0x6,%eax
  800bf7:	09 c2                	or     %eax,%edx
  800bf9:	41 89 d4             	mov    %edx,%r12d
  800bfc:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800c03:	00 00 00 
  800c06:	8b 00                	mov    (%rax),%eax
  800c08:	44 89 e2             	mov    %r12d,%edx
  800c0b:	09 c2                	or     %eax,%edx
  800c0d:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800c14:	00 00 00 
  800c17:	89 10                	mov    %edx,(%rax)
				}
				putch(ch, putdat);
  800c19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c21:	48 89 d6             	mov    %rdx,%rsi
  800c24:	89 df                	mov    %ebx,%edi
  800c26:	ff d0                	callq  *%rax

				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
  800c28:	83 fb 6d             	cmp    $0x6d,%ebx
  800c2b:	75 1b                	jne    800c48 <vprintfmt+0x232>
					fmt ++;
  800c2d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
  800c32:	90                   	nop
				}
			}

			// stop color parsing
			color_parsing = 0;
  800c33:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800c3a:	00 00 00 
  800c3d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
			continue;
  800c43:	e9 cb 04 00 00       	jmpq   801113 <vprintfmt+0x6fd>
				// if encounter 'm', escape sequence finish
				if (ch == 'm') {
					fmt ++;
					break;
				}
			}
  800c48:	e9 83 fe ff ff       	jmpq   800ad0 <vprintfmt+0xba>
			color_parsing = 0;
			continue;
		}

		// Process a %-escape sequence
		padc = ' ';
  800c4d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c51:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c58:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c5f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c66:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c6d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c71:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c75:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c79:	0f b6 00             	movzbl (%rax),%eax
  800c7c:	0f b6 d8             	movzbl %al,%ebx
  800c7f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c82:	83 f8 55             	cmp    $0x55,%eax
  800c85:	0f 87 5a 04 00 00    	ja     8010e5 <vprintfmt+0x6cf>
  800c8b:	89 c0                	mov    %eax,%eax
  800c8d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c94:	00 
  800c95:	48 b8 30 3b 80 00 00 	movabs $0x803b30,%rax
  800c9c:	00 00 00 
  800c9f:	48 01 d0             	add    %rdx,%rax
  800ca2:	48 8b 00             	mov    (%rax),%rax
  800ca5:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ca7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800cab:	eb c0                	jmp    800c6d <vprintfmt+0x257>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cad:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800cb1:	eb ba                	jmp    800c6d <vprintfmt+0x257>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cb3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800cba:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800cbd:	89 d0                	mov    %edx,%eax
  800cbf:	c1 e0 02             	shl    $0x2,%eax
  800cc2:	01 d0                	add    %edx,%eax
  800cc4:	01 c0                	add    %eax,%eax
  800cc6:	01 d8                	add    %ebx,%eax
  800cc8:	83 e8 30             	sub    $0x30,%eax
  800ccb:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800cce:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cd2:	0f b6 00             	movzbl (%rax),%eax
  800cd5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cd8:	83 fb 2f             	cmp    $0x2f,%ebx
  800cdb:	7e 0c                	jle    800ce9 <vprintfmt+0x2d3>
  800cdd:	83 fb 39             	cmp    $0x39,%ebx
  800ce0:	7f 07                	jg     800ce9 <vprintfmt+0x2d3>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ce2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ce7:	eb d1                	jmp    800cba <vprintfmt+0x2a4>
			goto process_precision;
  800ce9:	eb 58                	jmp    800d43 <vprintfmt+0x32d>

		case '*':
			precision = va_arg(aq, int);
  800ceb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cee:	83 f8 30             	cmp    $0x30,%eax
  800cf1:	73 17                	jae    800d0a <vprintfmt+0x2f4>
  800cf3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cf7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cfa:	89 c0                	mov    %eax,%eax
  800cfc:	48 01 d0             	add    %rdx,%rax
  800cff:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d02:	83 c2 08             	add    $0x8,%edx
  800d05:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d08:	eb 0f                	jmp    800d19 <vprintfmt+0x303>
  800d0a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d0e:	48 89 d0             	mov    %rdx,%rax
  800d11:	48 83 c2 08          	add    $0x8,%rdx
  800d15:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d19:	8b 00                	mov    (%rax),%eax
  800d1b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800d1e:	eb 23                	jmp    800d43 <vprintfmt+0x32d>

		case '.':
			if (width < 0)
  800d20:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d24:	79 0c                	jns    800d32 <vprintfmt+0x31c>
				width = 0;
  800d26:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d2d:	e9 3b ff ff ff       	jmpq   800c6d <vprintfmt+0x257>
  800d32:	e9 36 ff ff ff       	jmpq   800c6d <vprintfmt+0x257>

		case '#':
			altflag = 1;
  800d37:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d3e:	e9 2a ff ff ff       	jmpq   800c6d <vprintfmt+0x257>

		process_precision:
			if (width < 0)
  800d43:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d47:	79 12                	jns    800d5b <vprintfmt+0x345>
				width = precision, precision = -1;
  800d49:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d4c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d4f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d56:	e9 12 ff ff ff       	jmpq   800c6d <vprintfmt+0x257>
  800d5b:	e9 0d ff ff ff       	jmpq   800c6d <vprintfmt+0x257>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d60:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d64:	e9 04 ff ff ff       	jmpq   800c6d <vprintfmt+0x257>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d69:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d6c:	83 f8 30             	cmp    $0x30,%eax
  800d6f:	73 17                	jae    800d88 <vprintfmt+0x372>
  800d71:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d75:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d78:	89 c0                	mov    %eax,%eax
  800d7a:	48 01 d0             	add    %rdx,%rax
  800d7d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d80:	83 c2 08             	add    $0x8,%edx
  800d83:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d86:	eb 0f                	jmp    800d97 <vprintfmt+0x381>
  800d88:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d8c:	48 89 d0             	mov    %rdx,%rax
  800d8f:	48 83 c2 08          	add    $0x8,%rdx
  800d93:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d97:	8b 10                	mov    (%rax),%edx
  800d99:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d9d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800da1:	48 89 ce             	mov    %rcx,%rsi
  800da4:	89 d7                	mov    %edx,%edi
  800da6:	ff d0                	callq  *%rax
			break;
  800da8:	e9 66 03 00 00       	jmpq   801113 <vprintfmt+0x6fd>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800dad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db0:	83 f8 30             	cmp    $0x30,%eax
  800db3:	73 17                	jae    800dcc <vprintfmt+0x3b6>
  800db5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800db9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dbc:	89 c0                	mov    %eax,%eax
  800dbe:	48 01 d0             	add    %rdx,%rax
  800dc1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dc4:	83 c2 08             	add    $0x8,%edx
  800dc7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800dca:	eb 0f                	jmp    800ddb <vprintfmt+0x3c5>
  800dcc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dd0:	48 89 d0             	mov    %rdx,%rax
  800dd3:	48 83 c2 08          	add    $0x8,%rdx
  800dd7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ddb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ddd:	85 db                	test   %ebx,%ebx
  800ddf:	79 02                	jns    800de3 <vprintfmt+0x3cd>
				err = -err;
  800de1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800de3:	83 fb 10             	cmp    $0x10,%ebx
  800de6:	7f 16                	jg     800dfe <vprintfmt+0x3e8>
  800de8:	48 b8 80 3a 80 00 00 	movabs $0x803a80,%rax
  800def:	00 00 00 
  800df2:	48 63 d3             	movslq %ebx,%rdx
  800df5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800df9:	4d 85 e4             	test   %r12,%r12
  800dfc:	75 2e                	jne    800e2c <vprintfmt+0x416>
				printfmt(putch, putdat, "error %d", err);
  800dfe:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e06:	89 d9                	mov    %ebx,%ecx
  800e08:	48 ba 19 3b 80 00 00 	movabs $0x803b19,%rdx
  800e0f:	00 00 00 
  800e12:	48 89 c7             	mov    %rax,%rdi
  800e15:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1a:	49 b8 21 11 80 00 00 	movabs $0x801121,%r8
  800e21:	00 00 00 
  800e24:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e27:	e9 e7 02 00 00       	jmpq   801113 <vprintfmt+0x6fd>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e2c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e34:	4c 89 e1             	mov    %r12,%rcx
  800e37:	48 ba 22 3b 80 00 00 	movabs $0x803b22,%rdx
  800e3e:	00 00 00 
  800e41:	48 89 c7             	mov    %rax,%rdi
  800e44:	b8 00 00 00 00       	mov    $0x0,%eax
  800e49:	49 b8 21 11 80 00 00 	movabs $0x801121,%r8
  800e50:	00 00 00 
  800e53:	41 ff d0             	callq  *%r8
			break;
  800e56:	e9 b8 02 00 00       	jmpq   801113 <vprintfmt+0x6fd>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e5b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e5e:	83 f8 30             	cmp    $0x30,%eax
  800e61:	73 17                	jae    800e7a <vprintfmt+0x464>
  800e63:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e67:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e6a:	89 c0                	mov    %eax,%eax
  800e6c:	48 01 d0             	add    %rdx,%rax
  800e6f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e72:	83 c2 08             	add    $0x8,%edx
  800e75:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e78:	eb 0f                	jmp    800e89 <vprintfmt+0x473>
  800e7a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e7e:	48 89 d0             	mov    %rdx,%rax
  800e81:	48 83 c2 08          	add    $0x8,%rdx
  800e85:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e89:	4c 8b 20             	mov    (%rax),%r12
  800e8c:	4d 85 e4             	test   %r12,%r12
  800e8f:	75 0a                	jne    800e9b <vprintfmt+0x485>
				p = "(null)";
  800e91:	49 bc 25 3b 80 00 00 	movabs $0x803b25,%r12
  800e98:	00 00 00 
			if (width > 0 && padc != '-')
  800e9b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e9f:	7e 3f                	jle    800ee0 <vprintfmt+0x4ca>
  800ea1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ea5:	74 39                	je     800ee0 <vprintfmt+0x4ca>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ea7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800eaa:	48 98                	cltq   
  800eac:	48 89 c6             	mov    %rax,%rsi
  800eaf:	4c 89 e7             	mov    %r12,%rdi
  800eb2:	48 b8 cd 13 80 00 00 	movabs $0x8013cd,%rax
  800eb9:	00 00 00 
  800ebc:	ff d0                	callq  *%rax
  800ebe:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ec1:	eb 17                	jmp    800eda <vprintfmt+0x4c4>
					putch(padc, putdat);
  800ec3:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ec7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ecb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ecf:	48 89 ce             	mov    %rcx,%rsi
  800ed2:	89 d7                	mov    %edx,%edi
  800ed4:	ff d0                	callq  *%rax
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ed6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800eda:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ede:	7f e3                	jg     800ec3 <vprintfmt+0x4ad>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ee0:	eb 37                	jmp    800f19 <vprintfmt+0x503>
				if (altflag && (ch < ' ' || ch > '~'))
  800ee2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ee6:	74 1e                	je     800f06 <vprintfmt+0x4f0>
  800ee8:	83 fb 1f             	cmp    $0x1f,%ebx
  800eeb:	7e 05                	jle    800ef2 <vprintfmt+0x4dc>
  800eed:	83 fb 7e             	cmp    $0x7e,%ebx
  800ef0:	7e 14                	jle    800f06 <vprintfmt+0x4f0>
					putch('?', putdat);
  800ef2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efa:	48 89 d6             	mov    %rdx,%rsi
  800efd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800f02:	ff d0                	callq  *%rax
  800f04:	eb 0f                	jmp    800f15 <vprintfmt+0x4ff>
				else
					putch(ch, putdat);
  800f06:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f0e:	48 89 d6             	mov    %rdx,%rsi
  800f11:	89 df                	mov    %ebx,%edi
  800f13:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f15:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f19:	4c 89 e0             	mov    %r12,%rax
  800f1c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800f20:	0f b6 00             	movzbl (%rax),%eax
  800f23:	0f be d8             	movsbl %al,%ebx
  800f26:	85 db                	test   %ebx,%ebx
  800f28:	74 10                	je     800f3a <vprintfmt+0x524>
  800f2a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f2e:	78 b2                	js     800ee2 <vprintfmt+0x4cc>
  800f30:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f34:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f38:	79 a8                	jns    800ee2 <vprintfmt+0x4cc>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f3a:	eb 16                	jmp    800f52 <vprintfmt+0x53c>
				putch(' ', putdat);
  800f3c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f44:	48 89 d6             	mov    %rdx,%rsi
  800f47:	bf 20 00 00 00       	mov    $0x20,%edi
  800f4c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f4e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f52:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f56:	7f e4                	jg     800f3c <vprintfmt+0x526>
				putch(' ', putdat);
			break;
  800f58:	e9 b6 01 00 00       	jmpq   801113 <vprintfmt+0x6fd>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f5d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f61:	be 03 00 00 00       	mov    $0x3,%esi
  800f66:	48 89 c7             	mov    %rax,%rdi
  800f69:	48 b8 06 09 80 00 00 	movabs $0x800906,%rax
  800f70:	00 00 00 
  800f73:	ff d0                	callq  *%rax
  800f75:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7d:	48 85 c0             	test   %rax,%rax
  800f80:	79 1d                	jns    800f9f <vprintfmt+0x589>
				putch('-', putdat);
  800f82:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f86:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f8a:	48 89 d6             	mov    %rdx,%rsi
  800f8d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f92:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f98:	48 f7 d8             	neg    %rax
  800f9b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f9f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fa6:	e9 fb 00 00 00       	jmpq   8010a6 <vprintfmt+0x690>

		// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800fab:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800faf:	be 03 00 00 00       	mov    $0x3,%esi
  800fb4:	48 89 c7             	mov    %rax,%rdi
  800fb7:	48 b8 f6 07 80 00 00 	movabs $0x8007f6,%rax
  800fbe:	00 00 00 
  800fc1:	ff d0                	callq  *%rax
  800fc3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800fc7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fce:	e9 d3 00 00 00       	jmpq   8010a6 <vprintfmt+0x690>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq,3);
  800fd3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fd7:	be 03 00 00 00       	mov    $0x3,%esi
  800fdc:	48 89 c7             	mov    %rax,%rdi
  800fdf:	48 b8 06 09 80 00 00 	movabs $0x800906,%rax
  800fe6:	00 00 00 
  800fe9:	ff d0                	callq  *%rax
  800feb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800fef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff3:	48 85 c0             	test   %rax,%rax
  800ff6:	79 1d                	jns    801015 <vprintfmt+0x5ff>
				putch('-', putdat);
  800ff8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ffc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801000:	48 89 d6             	mov    %rdx,%rsi
  801003:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801008:	ff d0                	callq  *%rax
				num = -(long long) num;
  80100a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100e:	48 f7 d8             	neg    %rax
  801011:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 8;
  801015:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80101c:	e9 85 00 00 00       	jmpq   8010a6 <vprintfmt+0x690>

		// pointer
		case 'p':
			putch('0', putdat);
  801021:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801025:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801029:	48 89 d6             	mov    %rdx,%rsi
  80102c:	bf 30 00 00 00       	mov    $0x30,%edi
  801031:	ff d0                	callq  *%rax
			putch('x', putdat);
  801033:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801037:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80103b:	48 89 d6             	mov    %rdx,%rsi
  80103e:	bf 78 00 00 00       	mov    $0x78,%edi
  801043:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801045:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801048:	83 f8 30             	cmp    $0x30,%eax
  80104b:	73 17                	jae    801064 <vprintfmt+0x64e>
  80104d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801051:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801054:	89 c0                	mov    %eax,%eax
  801056:	48 01 d0             	add    %rdx,%rax
  801059:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80105c:	83 c2 08             	add    $0x8,%edx
  80105f:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801062:	eb 0f                	jmp    801073 <vprintfmt+0x65d>
				(uintptr_t) va_arg(aq, void *);
  801064:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801068:	48 89 d0             	mov    %rdx,%rax
  80106b:	48 83 c2 08          	add    $0x8,%rdx
  80106f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801073:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801076:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80107a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801081:	eb 23                	jmp    8010a6 <vprintfmt+0x690>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801083:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801087:	be 03 00 00 00       	mov    $0x3,%esi
  80108c:	48 89 c7             	mov    %rax,%rdi
  80108f:	48 b8 f6 07 80 00 00 	movabs $0x8007f6,%rax
  801096:	00 00 00 
  801099:	ff d0                	callq  *%rax
  80109b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80109f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010a6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8010ab:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8010ae:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8010b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010b5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010b9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010bd:	45 89 c1             	mov    %r8d,%r9d
  8010c0:	41 89 f8             	mov    %edi,%r8d
  8010c3:	48 89 c7             	mov    %rax,%rdi
  8010c6:	48 b8 3b 07 80 00 00 	movabs $0x80073b,%rax
  8010cd:	00 00 00 
  8010d0:	ff d0                	callq  *%rax
			break;
  8010d2:	eb 3f                	jmp    801113 <vprintfmt+0x6fd>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010d4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010d8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010dc:	48 89 d6             	mov    %rdx,%rsi
  8010df:	89 df                	mov    %ebx,%edi
  8010e1:	ff d0                	callq  *%rax
			break;
  8010e3:	eb 2e                	jmp    801113 <vprintfmt+0x6fd>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010e5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010e9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010ed:	48 89 d6             	mov    %rdx,%rsi
  8010f0:	bf 25 00 00 00       	mov    $0x25,%edi
  8010f5:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010f7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010fc:	eb 05                	jmp    801103 <vprintfmt+0x6ed>
  8010fe:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801103:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801107:	48 83 e8 01          	sub    $0x1,%rax
  80110b:	0f b6 00             	movzbl (%rax),%eax
  80110e:	3c 25                	cmp    $0x25,%al
  801110:	75 ec                	jne    8010fe <vprintfmt+0x6e8>
				/* do nothing */;
			break;
  801112:	90                   	nop
		}
	}
  801113:	e9 37 f9 ff ff       	jmpq   800a4f <vprintfmt+0x39>
    va_end(aq);
}
  801118:	48 83 c4 60          	add    $0x60,%rsp
  80111c:	5b                   	pop    %rbx
  80111d:	41 5c                	pop    %r12
  80111f:	5d                   	pop    %rbp
  801120:	c3                   	retq   

0000000000801121 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801121:	55                   	push   %rbp
  801122:	48 89 e5             	mov    %rsp,%rbp
  801125:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80112c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801133:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80113a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801141:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801148:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80114f:	84 c0                	test   %al,%al
  801151:	74 20                	je     801173 <printfmt+0x52>
  801153:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801157:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80115b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80115f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801163:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801167:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80116b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80116f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801173:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80117a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801181:	00 00 00 
  801184:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80118b:	00 00 00 
  80118e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801192:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801199:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011a0:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8011a7:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8011ae:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8011b5:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8011bc:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8011c3:	48 89 c7             	mov    %rax,%rdi
  8011c6:	48 b8 16 0a 80 00 00 	movabs $0x800a16,%rax
  8011cd:	00 00 00 
  8011d0:	ff d0                	callq  *%rax
	va_end(ap);
}
  8011d2:	c9                   	leaveq 
  8011d3:	c3                   	retq   

00000000008011d4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011d4:	55                   	push   %rbp
  8011d5:	48 89 e5             	mov    %rsp,%rbp
  8011d8:	48 83 ec 10          	sub    $0x10,%rsp
  8011dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8011df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8011e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e7:	8b 40 10             	mov    0x10(%rax),%eax
  8011ea:	8d 50 01             	lea    0x1(%rax),%edx
  8011ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f1:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f8:	48 8b 10             	mov    (%rax),%rdx
  8011fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ff:	48 8b 40 08          	mov    0x8(%rax),%rax
  801203:	48 39 c2             	cmp    %rax,%rdx
  801206:	73 17                	jae    80121f <sprintputch+0x4b>
		*b->buf++ = ch;
  801208:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120c:	48 8b 00             	mov    (%rax),%rax
  80120f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801213:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801217:	48 89 0a             	mov    %rcx,(%rdx)
  80121a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80121d:	88 10                	mov    %dl,(%rax)
}
  80121f:	c9                   	leaveq 
  801220:	c3                   	retq   

0000000000801221 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801221:	55                   	push   %rbp
  801222:	48 89 e5             	mov    %rsp,%rbp
  801225:	48 83 ec 50          	sub    $0x50,%rsp
  801229:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80122d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801230:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801234:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801238:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80123c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801240:	48 8b 0a             	mov    (%rdx),%rcx
  801243:	48 89 08             	mov    %rcx,(%rax)
  801246:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80124a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80124e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801252:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801256:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80125a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80125e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801261:	48 98                	cltq   
  801263:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801267:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80126b:	48 01 d0             	add    %rdx,%rax
  80126e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801272:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801279:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80127e:	74 06                	je     801286 <vsnprintf+0x65>
  801280:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801284:	7f 07                	jg     80128d <vsnprintf+0x6c>
		return -E_INVAL;
  801286:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128b:	eb 2f                	jmp    8012bc <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80128d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801291:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801295:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801299:	48 89 c6             	mov    %rax,%rsi
  80129c:	48 bf d4 11 80 00 00 	movabs $0x8011d4,%rdi
  8012a3:	00 00 00 
  8012a6:	48 b8 16 0a 80 00 00 	movabs $0x800a16,%rax
  8012ad:	00 00 00 
  8012b0:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8012b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8012b6:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8012b9:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8012bc:	c9                   	leaveq 
  8012bd:	c3                   	retq   

00000000008012be <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012be:	55                   	push   %rbp
  8012bf:	48 89 e5             	mov    %rsp,%rbp
  8012c2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8012c9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8012d0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8012d6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012dd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012e4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012eb:	84 c0                	test   %al,%al
  8012ed:	74 20                	je     80130f <snprintf+0x51>
  8012ef:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012f3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012f7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012fb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012ff:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801303:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801307:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80130b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80130f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801316:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80131d:	00 00 00 
  801320:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801327:	00 00 00 
  80132a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80132e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801335:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80133c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801343:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80134a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801351:	48 8b 0a             	mov    (%rdx),%rcx
  801354:	48 89 08             	mov    %rcx,(%rax)
  801357:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80135b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80135f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801363:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801367:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80136e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801375:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80137b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801382:	48 89 c7             	mov    %rax,%rdi
  801385:	48 b8 21 12 80 00 00 	movabs $0x801221,%rax
  80138c:	00 00 00 
  80138f:	ff d0                	callq  *%rax
  801391:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801397:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80139d:	c9                   	leaveq 
  80139e:	c3                   	retq   

000000000080139f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80139f:	55                   	push   %rbp
  8013a0:	48 89 e5             	mov    %rsp,%rbp
  8013a3:	48 83 ec 18          	sub    $0x18,%rsp
  8013a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8013ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013b2:	eb 09                	jmp    8013bd <strlen+0x1e>
		n++;
  8013b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013b8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c1:	0f b6 00             	movzbl (%rax),%eax
  8013c4:	84 c0                	test   %al,%al
  8013c6:	75 ec                	jne    8013b4 <strlen+0x15>
		n++;
	return n;
  8013c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013cb:	c9                   	leaveq 
  8013cc:	c3                   	retq   

00000000008013cd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013cd:	55                   	push   %rbp
  8013ce:	48 89 e5             	mov    %rsp,%rbp
  8013d1:	48 83 ec 20          	sub    $0x20,%rsp
  8013d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013e4:	eb 0e                	jmp    8013f4 <strnlen+0x27>
		n++;
  8013e6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013ea:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013ef:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013f4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8013f9:	74 0b                	je     801406 <strnlen+0x39>
  8013fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ff:	0f b6 00             	movzbl (%rax),%eax
  801402:	84 c0                	test   %al,%al
  801404:	75 e0                	jne    8013e6 <strnlen+0x19>
		n++;
	return n;
  801406:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801409:	c9                   	leaveq 
  80140a:	c3                   	retq   

000000000080140b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80140b:	55                   	push   %rbp
  80140c:	48 89 e5             	mov    %rsp,%rbp
  80140f:	48 83 ec 20          	sub    $0x20,%rsp
  801413:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801417:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80141b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80141f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801423:	90                   	nop
  801424:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801428:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80142c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801430:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801434:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801438:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80143c:	0f b6 12             	movzbl (%rdx),%edx
  80143f:	88 10                	mov    %dl,(%rax)
  801441:	0f b6 00             	movzbl (%rax),%eax
  801444:	84 c0                	test   %al,%al
  801446:	75 dc                	jne    801424 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801448:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80144c:	c9                   	leaveq 
  80144d:	c3                   	retq   

000000000080144e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80144e:	55                   	push   %rbp
  80144f:	48 89 e5             	mov    %rsp,%rbp
  801452:	48 83 ec 20          	sub    $0x20,%rsp
  801456:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80145a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80145e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801462:	48 89 c7             	mov    %rax,%rdi
  801465:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  80146c:	00 00 00 
  80146f:	ff d0                	callq  *%rax
  801471:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801474:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801477:	48 63 d0             	movslq %eax,%rdx
  80147a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80147e:	48 01 c2             	add    %rax,%rdx
  801481:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801485:	48 89 c6             	mov    %rax,%rsi
  801488:	48 89 d7             	mov    %rdx,%rdi
  80148b:	48 b8 0b 14 80 00 00 	movabs $0x80140b,%rax
  801492:	00 00 00 
  801495:	ff d0                	callq  *%rax
	return dst;
  801497:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80149b:	c9                   	leaveq 
  80149c:	c3                   	retq   

000000000080149d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80149d:	55                   	push   %rbp
  80149e:	48 89 e5             	mov    %rsp,%rbp
  8014a1:	48 83 ec 28          	sub    $0x28,%rsp
  8014a5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8014b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8014b9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8014c0:	00 
  8014c1:	eb 2a                	jmp    8014ed <strncpy+0x50>
		*dst++ = *src;
  8014c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014cb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014cf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014d3:	0f b6 12             	movzbl (%rdx),%edx
  8014d6:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014dc:	0f b6 00             	movzbl (%rax),%eax
  8014df:	84 c0                	test   %al,%al
  8014e1:	74 05                	je     8014e8 <strncpy+0x4b>
			src++;
  8014e3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014f5:	72 cc                	jb     8014c3 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014fb:	c9                   	leaveq 
  8014fc:	c3                   	retq   

00000000008014fd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014fd:	55                   	push   %rbp
  8014fe:	48 89 e5             	mov    %rsp,%rbp
  801501:	48 83 ec 28          	sub    $0x28,%rsp
  801505:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801509:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80150d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801511:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801515:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801519:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80151e:	74 3d                	je     80155d <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801520:	eb 1d                	jmp    80153f <strlcpy+0x42>
			*dst++ = *src++;
  801522:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801526:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80152a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80152e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801532:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801536:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80153a:	0f b6 12             	movzbl (%rdx),%edx
  80153d:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80153f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801544:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801549:	74 0b                	je     801556 <strlcpy+0x59>
  80154b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80154f:	0f b6 00             	movzbl (%rax),%eax
  801552:	84 c0                	test   %al,%al
  801554:	75 cc                	jne    801522 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801556:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155a:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80155d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801561:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801565:	48 29 c2             	sub    %rax,%rdx
  801568:	48 89 d0             	mov    %rdx,%rax
}
  80156b:	c9                   	leaveq 
  80156c:	c3                   	retq   

000000000080156d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80156d:	55                   	push   %rbp
  80156e:	48 89 e5             	mov    %rsp,%rbp
  801571:	48 83 ec 10          	sub    $0x10,%rsp
  801575:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801579:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80157d:	eb 0a                	jmp    801589 <strcmp+0x1c>
		p++, q++;
  80157f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801584:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801589:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158d:	0f b6 00             	movzbl (%rax),%eax
  801590:	84 c0                	test   %al,%al
  801592:	74 12                	je     8015a6 <strcmp+0x39>
  801594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801598:	0f b6 10             	movzbl (%rax),%edx
  80159b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159f:	0f b6 00             	movzbl (%rax),%eax
  8015a2:	38 c2                	cmp    %al,%dl
  8015a4:	74 d9                	je     80157f <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015aa:	0f b6 00             	movzbl (%rax),%eax
  8015ad:	0f b6 d0             	movzbl %al,%edx
  8015b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b4:	0f b6 00             	movzbl (%rax),%eax
  8015b7:	0f b6 c0             	movzbl %al,%eax
  8015ba:	29 c2                	sub    %eax,%edx
  8015bc:	89 d0                	mov    %edx,%eax
}
  8015be:	c9                   	leaveq 
  8015bf:	c3                   	retq   

00000000008015c0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8015c0:	55                   	push   %rbp
  8015c1:	48 89 e5             	mov    %rsp,%rbp
  8015c4:	48 83 ec 18          	sub    $0x18,%rsp
  8015c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8015d4:	eb 0f                	jmp    8015e5 <strncmp+0x25>
		n--, p++, q++;
  8015d6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015db:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015e0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8015e5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015ea:	74 1d                	je     801609 <strncmp+0x49>
  8015ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f0:	0f b6 00             	movzbl (%rax),%eax
  8015f3:	84 c0                	test   %al,%al
  8015f5:	74 12                	je     801609 <strncmp+0x49>
  8015f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015fb:	0f b6 10             	movzbl (%rax),%edx
  8015fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801602:	0f b6 00             	movzbl (%rax),%eax
  801605:	38 c2                	cmp    %al,%dl
  801607:	74 cd                	je     8015d6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801609:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80160e:	75 07                	jne    801617 <strncmp+0x57>
		return 0;
  801610:	b8 00 00 00 00       	mov    $0x0,%eax
  801615:	eb 18                	jmp    80162f <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801617:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161b:	0f b6 00             	movzbl (%rax),%eax
  80161e:	0f b6 d0             	movzbl %al,%edx
  801621:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801625:	0f b6 00             	movzbl (%rax),%eax
  801628:	0f b6 c0             	movzbl %al,%eax
  80162b:	29 c2                	sub    %eax,%edx
  80162d:	89 d0                	mov    %edx,%eax
}
  80162f:	c9                   	leaveq 
  801630:	c3                   	retq   

0000000000801631 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801631:	55                   	push   %rbp
  801632:	48 89 e5             	mov    %rsp,%rbp
  801635:	48 83 ec 0c          	sub    $0xc,%rsp
  801639:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80163d:	89 f0                	mov    %esi,%eax
  80163f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801642:	eb 17                	jmp    80165b <strchr+0x2a>
		if (*s == c)
  801644:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801648:	0f b6 00             	movzbl (%rax),%eax
  80164b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80164e:	75 06                	jne    801656 <strchr+0x25>
			return (char *) s;
  801650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801654:	eb 15                	jmp    80166b <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801656:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80165b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165f:	0f b6 00             	movzbl (%rax),%eax
  801662:	84 c0                	test   %al,%al
  801664:	75 de                	jne    801644 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801666:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166b:	c9                   	leaveq 
  80166c:	c3                   	retq   

000000000080166d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80166d:	55                   	push   %rbp
  80166e:	48 89 e5             	mov    %rsp,%rbp
  801671:	48 83 ec 0c          	sub    $0xc,%rsp
  801675:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801679:	89 f0                	mov    %esi,%eax
  80167b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80167e:	eb 13                	jmp    801693 <strfind+0x26>
		if (*s == c)
  801680:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801684:	0f b6 00             	movzbl (%rax),%eax
  801687:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80168a:	75 02                	jne    80168e <strfind+0x21>
			break;
  80168c:	eb 10                	jmp    80169e <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80168e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801693:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801697:	0f b6 00             	movzbl (%rax),%eax
  80169a:	84 c0                	test   %al,%al
  80169c:	75 e2                	jne    801680 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80169e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016a2:	c9                   	leaveq 
  8016a3:	c3                   	retq   

00000000008016a4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8016a4:	55                   	push   %rbp
  8016a5:	48 89 e5             	mov    %rsp,%rbp
  8016a8:	48 83 ec 18          	sub    $0x18,%rsp
  8016ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016b0:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8016b3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8016b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016bc:	75 06                	jne    8016c4 <memset+0x20>
		return v;
  8016be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c2:	eb 69                	jmp    80172d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8016c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c8:	83 e0 03             	and    $0x3,%eax
  8016cb:	48 85 c0             	test   %rax,%rax
  8016ce:	75 48                	jne    801718 <memset+0x74>
  8016d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d4:	83 e0 03             	and    $0x3,%eax
  8016d7:	48 85 c0             	test   %rax,%rax
  8016da:	75 3c                	jne    801718 <memset+0x74>
		c &= 0xFF;
  8016dc:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8016e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016e6:	c1 e0 18             	shl    $0x18,%eax
  8016e9:	89 c2                	mov    %eax,%edx
  8016eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016ee:	c1 e0 10             	shl    $0x10,%eax
  8016f1:	09 c2                	or     %eax,%edx
  8016f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016f6:	c1 e0 08             	shl    $0x8,%eax
  8016f9:	09 d0                	or     %edx,%eax
  8016fb:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8016fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801702:	48 c1 e8 02          	shr    $0x2,%rax
  801706:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801709:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80170d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801710:	48 89 d7             	mov    %rdx,%rdi
  801713:	fc                   	cld    
  801714:	f3 ab                	rep stos %eax,%es:(%rdi)
  801716:	eb 11                	jmp    801729 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801718:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80171c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80171f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801723:	48 89 d7             	mov    %rdx,%rdi
  801726:	fc                   	cld    
  801727:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801729:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80172d:	c9                   	leaveq 
  80172e:	c3                   	retq   

000000000080172f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80172f:	55                   	push   %rbp
  801730:	48 89 e5             	mov    %rsp,%rbp
  801733:	48 83 ec 28          	sub    $0x28,%rsp
  801737:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80173b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80173f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801743:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801747:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80174b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80174f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801753:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801757:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80175b:	0f 83 88 00 00 00    	jae    8017e9 <memmove+0xba>
  801761:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801765:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801769:	48 01 d0             	add    %rdx,%rax
  80176c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801770:	76 77                	jbe    8017e9 <memmove+0xba>
		s += n;
  801772:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801776:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80177a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801782:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801786:	83 e0 03             	and    $0x3,%eax
  801789:	48 85 c0             	test   %rax,%rax
  80178c:	75 3b                	jne    8017c9 <memmove+0x9a>
  80178e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801792:	83 e0 03             	and    $0x3,%eax
  801795:	48 85 c0             	test   %rax,%rax
  801798:	75 2f                	jne    8017c9 <memmove+0x9a>
  80179a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179e:	83 e0 03             	and    $0x3,%eax
  8017a1:	48 85 c0             	test   %rax,%rax
  8017a4:	75 23                	jne    8017c9 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8017a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017aa:	48 83 e8 04          	sub    $0x4,%rax
  8017ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017b2:	48 83 ea 04          	sub    $0x4,%rdx
  8017b6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017ba:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8017be:	48 89 c7             	mov    %rax,%rdi
  8017c1:	48 89 d6             	mov    %rdx,%rsi
  8017c4:	fd                   	std    
  8017c5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017c7:	eb 1d                	jmp    8017e6 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8017c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017cd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017d5:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017dd:	48 89 d7             	mov    %rdx,%rdi
  8017e0:	48 89 c1             	mov    %rax,%rcx
  8017e3:	fd                   	std    
  8017e4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017e6:	fc                   	cld    
  8017e7:	eb 57                	jmp    801840 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ed:	83 e0 03             	and    $0x3,%eax
  8017f0:	48 85 c0             	test   %rax,%rax
  8017f3:	75 36                	jne    80182b <memmove+0xfc>
  8017f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017f9:	83 e0 03             	and    $0x3,%eax
  8017fc:	48 85 c0             	test   %rax,%rax
  8017ff:	75 2a                	jne    80182b <memmove+0xfc>
  801801:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801805:	83 e0 03             	and    $0x3,%eax
  801808:	48 85 c0             	test   %rax,%rax
  80180b:	75 1e                	jne    80182b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80180d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801811:	48 c1 e8 02          	shr    $0x2,%rax
  801815:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801818:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80181c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801820:	48 89 c7             	mov    %rax,%rdi
  801823:	48 89 d6             	mov    %rdx,%rsi
  801826:	fc                   	cld    
  801827:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801829:	eb 15                	jmp    801840 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80182b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80182f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801833:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801837:	48 89 c7             	mov    %rax,%rdi
  80183a:	48 89 d6             	mov    %rdx,%rsi
  80183d:	fc                   	cld    
  80183e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801844:	c9                   	leaveq 
  801845:	c3                   	retq   

0000000000801846 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801846:	55                   	push   %rbp
  801847:	48 89 e5             	mov    %rsp,%rbp
  80184a:	48 83 ec 18          	sub    $0x18,%rsp
  80184e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801852:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801856:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80185a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80185e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801862:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801866:	48 89 ce             	mov    %rcx,%rsi
  801869:	48 89 c7             	mov    %rax,%rdi
  80186c:	48 b8 2f 17 80 00 00 	movabs $0x80172f,%rax
  801873:	00 00 00 
  801876:	ff d0                	callq  *%rax
}
  801878:	c9                   	leaveq 
  801879:	c3                   	retq   

000000000080187a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80187a:	55                   	push   %rbp
  80187b:	48 89 e5             	mov    %rsp,%rbp
  80187e:	48 83 ec 28          	sub    $0x28,%rsp
  801882:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801886:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80188a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80188e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801892:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801896:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80189a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80189e:	eb 36                	jmp    8018d6 <memcmp+0x5c>
		if (*s1 != *s2)
  8018a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018a4:	0f b6 10             	movzbl (%rax),%edx
  8018a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ab:	0f b6 00             	movzbl (%rax),%eax
  8018ae:	38 c2                	cmp    %al,%dl
  8018b0:	74 1a                	je     8018cc <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8018b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018b6:	0f b6 00             	movzbl (%rax),%eax
  8018b9:	0f b6 d0             	movzbl %al,%edx
  8018bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c0:	0f b6 00             	movzbl (%rax),%eax
  8018c3:	0f b6 c0             	movzbl %al,%eax
  8018c6:	29 c2                	sub    %eax,%edx
  8018c8:	89 d0                	mov    %edx,%eax
  8018ca:	eb 20                	jmp    8018ec <memcmp+0x72>
		s1++, s2++;
  8018cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018d1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018da:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018e2:	48 85 c0             	test   %rax,%rax
  8018e5:	75 b9                	jne    8018a0 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ec:	c9                   	leaveq 
  8018ed:	c3                   	retq   

00000000008018ee <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018ee:	55                   	push   %rbp
  8018ef:	48 89 e5             	mov    %rsp,%rbp
  8018f2:	48 83 ec 28          	sub    $0x28,%rsp
  8018f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018fa:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801901:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801905:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801909:	48 01 d0             	add    %rdx,%rax
  80190c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801910:	eb 15                	jmp    801927 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801912:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801916:	0f b6 10             	movzbl (%rax),%edx
  801919:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80191c:	38 c2                	cmp    %al,%dl
  80191e:	75 02                	jne    801922 <memfind+0x34>
			break;
  801920:	eb 0f                	jmp    801931 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801922:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801927:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80192b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80192f:	72 e1                	jb     801912 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801931:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801935:	c9                   	leaveq 
  801936:	c3                   	retq   

0000000000801937 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801937:	55                   	push   %rbp
  801938:	48 89 e5             	mov    %rsp,%rbp
  80193b:	48 83 ec 34          	sub    $0x34,%rsp
  80193f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801943:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801947:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80194a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801951:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801958:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801959:	eb 05                	jmp    801960 <strtol+0x29>
		s++;
  80195b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801960:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801964:	0f b6 00             	movzbl (%rax),%eax
  801967:	3c 20                	cmp    $0x20,%al
  801969:	74 f0                	je     80195b <strtol+0x24>
  80196b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196f:	0f b6 00             	movzbl (%rax),%eax
  801972:	3c 09                	cmp    $0x9,%al
  801974:	74 e5                	je     80195b <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801976:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197a:	0f b6 00             	movzbl (%rax),%eax
  80197d:	3c 2b                	cmp    $0x2b,%al
  80197f:	75 07                	jne    801988 <strtol+0x51>
		s++;
  801981:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801986:	eb 17                	jmp    80199f <strtol+0x68>
	else if (*s == '-')
  801988:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80198c:	0f b6 00             	movzbl (%rax),%eax
  80198f:	3c 2d                	cmp    $0x2d,%al
  801991:	75 0c                	jne    80199f <strtol+0x68>
		s++, neg = 1;
  801993:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801998:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80199f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019a3:	74 06                	je     8019ab <strtol+0x74>
  8019a5:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8019a9:	75 28                	jne    8019d3 <strtol+0x9c>
  8019ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019af:	0f b6 00             	movzbl (%rax),%eax
  8019b2:	3c 30                	cmp    $0x30,%al
  8019b4:	75 1d                	jne    8019d3 <strtol+0x9c>
  8019b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ba:	48 83 c0 01          	add    $0x1,%rax
  8019be:	0f b6 00             	movzbl (%rax),%eax
  8019c1:	3c 78                	cmp    $0x78,%al
  8019c3:	75 0e                	jne    8019d3 <strtol+0x9c>
		s += 2, base = 16;
  8019c5:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8019ca:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8019d1:	eb 2c                	jmp    8019ff <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8019d3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019d7:	75 19                	jne    8019f2 <strtol+0xbb>
  8019d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019dd:	0f b6 00             	movzbl (%rax),%eax
  8019e0:	3c 30                	cmp    $0x30,%al
  8019e2:	75 0e                	jne    8019f2 <strtol+0xbb>
		s++, base = 8;
  8019e4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019e9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8019f0:	eb 0d                	jmp    8019ff <strtol+0xc8>
	else if (base == 0)
  8019f2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019f6:	75 07                	jne    8019ff <strtol+0xc8>
		base = 10;
  8019f8:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a03:	0f b6 00             	movzbl (%rax),%eax
  801a06:	3c 2f                	cmp    $0x2f,%al
  801a08:	7e 1d                	jle    801a27 <strtol+0xf0>
  801a0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0e:	0f b6 00             	movzbl (%rax),%eax
  801a11:	3c 39                	cmp    $0x39,%al
  801a13:	7f 12                	jg     801a27 <strtol+0xf0>
			dig = *s - '0';
  801a15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a19:	0f b6 00             	movzbl (%rax),%eax
  801a1c:	0f be c0             	movsbl %al,%eax
  801a1f:	83 e8 30             	sub    $0x30,%eax
  801a22:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a25:	eb 4e                	jmp    801a75 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a2b:	0f b6 00             	movzbl (%rax),%eax
  801a2e:	3c 60                	cmp    $0x60,%al
  801a30:	7e 1d                	jle    801a4f <strtol+0x118>
  801a32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a36:	0f b6 00             	movzbl (%rax),%eax
  801a39:	3c 7a                	cmp    $0x7a,%al
  801a3b:	7f 12                	jg     801a4f <strtol+0x118>
			dig = *s - 'a' + 10;
  801a3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a41:	0f b6 00             	movzbl (%rax),%eax
  801a44:	0f be c0             	movsbl %al,%eax
  801a47:	83 e8 57             	sub    $0x57,%eax
  801a4a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a4d:	eb 26                	jmp    801a75 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a53:	0f b6 00             	movzbl (%rax),%eax
  801a56:	3c 40                	cmp    $0x40,%al
  801a58:	7e 48                	jle    801aa2 <strtol+0x16b>
  801a5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5e:	0f b6 00             	movzbl (%rax),%eax
  801a61:	3c 5a                	cmp    $0x5a,%al
  801a63:	7f 3d                	jg     801aa2 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a69:	0f b6 00             	movzbl (%rax),%eax
  801a6c:	0f be c0             	movsbl %al,%eax
  801a6f:	83 e8 37             	sub    $0x37,%eax
  801a72:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a75:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a78:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a7b:	7c 02                	jl     801a7f <strtol+0x148>
			break;
  801a7d:	eb 23                	jmp    801aa2 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a7f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a84:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a87:	48 98                	cltq   
  801a89:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a8e:	48 89 c2             	mov    %rax,%rdx
  801a91:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a94:	48 98                	cltq   
  801a96:	48 01 d0             	add    %rdx,%rax
  801a99:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a9d:	e9 5d ff ff ff       	jmpq   8019ff <strtol+0xc8>

	if (endptr)
  801aa2:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801aa7:	74 0b                	je     801ab4 <strtol+0x17d>
		*endptr = (char *) s;
  801aa9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801aad:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ab1:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801ab4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ab8:	74 09                	je     801ac3 <strtol+0x18c>
  801aba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801abe:	48 f7 d8             	neg    %rax
  801ac1:	eb 04                	jmp    801ac7 <strtol+0x190>
  801ac3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801ac7:	c9                   	leaveq 
  801ac8:	c3                   	retq   

0000000000801ac9 <strstr>:

char * strstr(const char *in, const char *str)
{
  801ac9:	55                   	push   %rbp
  801aca:	48 89 e5             	mov    %rsp,%rbp
  801acd:	48 83 ec 30          	sub    $0x30,%rsp
  801ad1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ad5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801ad9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801add:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ae1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801ae5:	0f b6 00             	movzbl (%rax),%eax
  801ae8:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801aeb:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801aef:	75 06                	jne    801af7 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801af1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af5:	eb 6b                	jmp    801b62 <strstr+0x99>

    len = strlen(str);
  801af7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801afb:	48 89 c7             	mov    %rax,%rdi
  801afe:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  801b05:	00 00 00 
  801b08:	ff d0                	callq  *%rax
  801b0a:	48 98                	cltq   
  801b0c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801b10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b14:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b18:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b1c:	0f b6 00             	movzbl (%rax),%eax
  801b1f:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801b22:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b26:	75 07                	jne    801b2f <strstr+0x66>
                return (char *) 0;
  801b28:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2d:	eb 33                	jmp    801b62 <strstr+0x99>
        } while (sc != c);
  801b2f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b33:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b36:	75 d8                	jne    801b10 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801b38:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b3c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b44:	48 89 ce             	mov    %rcx,%rsi
  801b47:	48 89 c7             	mov    %rax,%rdi
  801b4a:	48 b8 c0 15 80 00 00 	movabs $0x8015c0,%rax
  801b51:	00 00 00 
  801b54:	ff d0                	callq  *%rax
  801b56:	85 c0                	test   %eax,%eax
  801b58:	75 b6                	jne    801b10 <strstr+0x47>

    return (char *) (in - 1);
  801b5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b5e:	48 83 e8 01          	sub    $0x1,%rax
}
  801b62:	c9                   	leaveq 
  801b63:	c3                   	retq   

0000000000801b64 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b64:	55                   	push   %rbp
  801b65:	48 89 e5             	mov    %rsp,%rbp
  801b68:	53                   	push   %rbx
  801b69:	48 83 ec 48          	sub    $0x48,%rsp
  801b6d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b70:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b73:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b77:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b7b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b7f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b83:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b86:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b8a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b8e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b92:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b96:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b9a:	4c 89 c3             	mov    %r8,%rbx
  801b9d:	cd 30                	int    $0x30
  801b9f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if (check && ret > 0)
  801ba3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801ba7:	74 3e                	je     801be7 <syscall+0x83>
  801ba9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bae:	7e 37                	jle    801be7 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801bb0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bb4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bb7:	49 89 d0             	mov    %rdx,%r8
  801bba:	89 c1                	mov    %eax,%ecx
  801bbc:	48 ba e0 3d 80 00 00 	movabs $0x803de0,%rdx
  801bc3:	00 00 00 
  801bc6:	be 23 00 00 00       	mov    $0x23,%esi
  801bcb:	48 bf fd 3d 80 00 00 	movabs $0x803dfd,%rdi
  801bd2:	00 00 00 
  801bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bda:	49 b9 2a 04 80 00 00 	movabs $0x80042a,%r9
  801be1:	00 00 00 
  801be4:	41 ff d1             	callq  *%r9

	return ret;
  801be7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801beb:	48 83 c4 48          	add    $0x48,%rsp
  801bef:	5b                   	pop    %rbx
  801bf0:	5d                   	pop    %rbp
  801bf1:	c3                   	retq   

0000000000801bf2 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801bf2:	55                   	push   %rbp
  801bf3:	48 89 e5             	mov    %rsp,%rbp
  801bf6:	48 83 ec 20          	sub    $0x20,%rsp
  801bfa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bfe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c06:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c0a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c11:	00 
  801c12:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c18:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1e:	48 89 d1             	mov    %rdx,%rcx
  801c21:	48 89 c2             	mov    %rax,%rdx
  801c24:	be 00 00 00 00       	mov    $0x0,%esi
  801c29:	bf 00 00 00 00       	mov    $0x0,%edi
  801c2e:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  801c35:	00 00 00 
  801c38:	ff d0                	callq  *%rax
}
  801c3a:	c9                   	leaveq 
  801c3b:	c3                   	retq   

0000000000801c3c <sys_cgetc>:

int
sys_cgetc(void)
{
  801c3c:	55                   	push   %rbp
  801c3d:	48 89 e5             	mov    %rsp,%rbp
  801c40:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c44:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c4b:	00 
  801c4c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c52:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c58:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c5d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c62:	be 00 00 00 00       	mov    $0x0,%esi
  801c67:	bf 01 00 00 00       	mov    $0x1,%edi
  801c6c:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  801c73:	00 00 00 
  801c76:	ff d0                	callq  *%rax
}
  801c78:	c9                   	leaveq 
  801c79:	c3                   	retq   

0000000000801c7a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c7a:	55                   	push   %rbp
  801c7b:	48 89 e5             	mov    %rsp,%rbp
  801c7e:	48 83 ec 10          	sub    $0x10,%rsp
  801c82:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c88:	48 98                	cltq   
  801c8a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c91:	00 
  801c92:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c98:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ca3:	48 89 c2             	mov    %rax,%rdx
  801ca6:	be 01 00 00 00       	mov    $0x1,%esi
  801cab:	bf 03 00 00 00       	mov    $0x3,%edi
  801cb0:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  801cb7:	00 00 00 
  801cba:	ff d0                	callq  *%rax
}
  801cbc:	c9                   	leaveq 
  801cbd:	c3                   	retq   

0000000000801cbe <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801cbe:	55                   	push   %rbp
  801cbf:	48 89 e5             	mov    %rsp,%rbp
  801cc2:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801cc6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ccd:	00 
  801cce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cda:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cdf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce4:	be 00 00 00 00       	mov    $0x0,%esi
  801ce9:	bf 02 00 00 00       	mov    $0x2,%edi
  801cee:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  801cf5:	00 00 00 
  801cf8:	ff d0                	callq  *%rax
}
  801cfa:	c9                   	leaveq 
  801cfb:	c3                   	retq   

0000000000801cfc <sys_yield>:

void
sys_yield(void)
{
  801cfc:	55                   	push   %rbp
  801cfd:	48 89 e5             	mov    %rsp,%rbp
  801d00:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d0b:	00 
  801d0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d18:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d22:	be 00 00 00 00       	mov    $0x0,%esi
  801d27:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d2c:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  801d33:	00 00 00 
  801d36:	ff d0                	callq  *%rax
}
  801d38:	c9                   	leaveq 
  801d39:	c3                   	retq   

0000000000801d3a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d3a:	55                   	push   %rbp
  801d3b:	48 89 e5             	mov    %rsp,%rbp
  801d3e:	48 83 ec 20          	sub    $0x20,%rsp
  801d42:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d45:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d49:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d4c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d4f:	48 63 c8             	movslq %eax,%rcx
  801d52:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d59:	48 98                	cltq   
  801d5b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d62:	00 
  801d63:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d69:	49 89 c8             	mov    %rcx,%r8
  801d6c:	48 89 d1             	mov    %rdx,%rcx
  801d6f:	48 89 c2             	mov    %rax,%rdx
  801d72:	be 01 00 00 00       	mov    $0x1,%esi
  801d77:	bf 04 00 00 00       	mov    $0x4,%edi
  801d7c:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  801d83:	00 00 00 
  801d86:	ff d0                	callq  *%rax
}
  801d88:	c9                   	leaveq 
  801d89:	c3                   	retq   

0000000000801d8a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d8a:	55                   	push   %rbp
  801d8b:	48 89 e5             	mov    %rsp,%rbp
  801d8e:	48 83 ec 30          	sub    $0x30,%rsp
  801d92:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d99:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d9c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801da0:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801da4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801da7:	48 63 c8             	movslq %eax,%rcx
  801daa:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801dae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801db1:	48 63 f0             	movslq %eax,%rsi
  801db4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801db8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dbb:	48 98                	cltq   
  801dbd:	48 89 0c 24          	mov    %rcx,(%rsp)
  801dc1:	49 89 f9             	mov    %rdi,%r9
  801dc4:	49 89 f0             	mov    %rsi,%r8
  801dc7:	48 89 d1             	mov    %rdx,%rcx
  801dca:	48 89 c2             	mov    %rax,%rdx
  801dcd:	be 01 00 00 00       	mov    $0x1,%esi
  801dd2:	bf 05 00 00 00       	mov    $0x5,%edi
  801dd7:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  801dde:	00 00 00 
  801de1:	ff d0                	callq  *%rax
}
  801de3:	c9                   	leaveq 
  801de4:	c3                   	retq   

0000000000801de5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801de5:	55                   	push   %rbp
  801de6:	48 89 e5             	mov    %rsp,%rbp
  801de9:	48 83 ec 20          	sub    $0x20,%rsp
  801ded:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801df0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801df4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801df8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dfb:	48 98                	cltq   
  801dfd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e04:	00 
  801e05:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e0b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e11:	48 89 d1             	mov    %rdx,%rcx
  801e14:	48 89 c2             	mov    %rax,%rdx
  801e17:	be 01 00 00 00       	mov    $0x1,%esi
  801e1c:	bf 06 00 00 00       	mov    $0x6,%edi
  801e21:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  801e28:	00 00 00 
  801e2b:	ff d0                	callq  *%rax
}
  801e2d:	c9                   	leaveq 
  801e2e:	c3                   	retq   

0000000000801e2f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e2f:	55                   	push   %rbp
  801e30:	48 89 e5             	mov    %rsp,%rbp
  801e33:	48 83 ec 10          	sub    $0x10,%rsp
  801e37:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e3a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e3d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e40:	48 63 d0             	movslq %eax,%rdx
  801e43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e46:	48 98                	cltq   
  801e48:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e4f:	00 
  801e50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e5c:	48 89 d1             	mov    %rdx,%rcx
  801e5f:	48 89 c2             	mov    %rax,%rdx
  801e62:	be 01 00 00 00       	mov    $0x1,%esi
  801e67:	bf 08 00 00 00       	mov    $0x8,%edi
  801e6c:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  801e73:	00 00 00 
  801e76:	ff d0                	callq  *%rax
}
  801e78:	c9                   	leaveq 
  801e79:	c3                   	retq   

0000000000801e7a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e7a:	55                   	push   %rbp
  801e7b:	48 89 e5             	mov    %rsp,%rbp
  801e7e:	48 83 ec 20          	sub    $0x20,%rsp
  801e82:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e85:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e90:	48 98                	cltq   
  801e92:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e99:	00 
  801e9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ea0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ea6:	48 89 d1             	mov    %rdx,%rcx
  801ea9:	48 89 c2             	mov    %rax,%rdx
  801eac:	be 01 00 00 00       	mov    $0x1,%esi
  801eb1:	bf 09 00 00 00       	mov    $0x9,%edi
  801eb6:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  801ebd:	00 00 00 
  801ec0:	ff d0                	callq  *%rax
}
  801ec2:	c9                   	leaveq 
  801ec3:	c3                   	retq   

0000000000801ec4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ec4:	55                   	push   %rbp
  801ec5:	48 89 e5             	mov    %rsp,%rbp
  801ec8:	48 83 ec 20          	sub    $0x20,%rsp
  801ecc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ecf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ed3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ed7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eda:	48 98                	cltq   
  801edc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ee3:	00 
  801ee4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ef0:	48 89 d1             	mov    %rdx,%rcx
  801ef3:	48 89 c2             	mov    %rax,%rdx
  801ef6:	be 01 00 00 00       	mov    $0x1,%esi
  801efb:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f00:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  801f07:	00 00 00 
  801f0a:	ff d0                	callq  *%rax
}
  801f0c:	c9                   	leaveq 
  801f0d:	c3                   	retq   

0000000000801f0e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f0e:	55                   	push   %rbp
  801f0f:	48 89 e5             	mov    %rsp,%rbp
  801f12:	48 83 ec 20          	sub    $0x20,%rsp
  801f16:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f1d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f21:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f27:	48 63 f0             	movslq %eax,%rsi
  801f2a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f31:	48 98                	cltq   
  801f33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f37:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f3e:	00 
  801f3f:	49 89 f1             	mov    %rsi,%r9
  801f42:	49 89 c8             	mov    %rcx,%r8
  801f45:	48 89 d1             	mov    %rdx,%rcx
  801f48:	48 89 c2             	mov    %rax,%rdx
  801f4b:	be 00 00 00 00       	mov    $0x0,%esi
  801f50:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f55:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  801f5c:	00 00 00 
  801f5f:	ff d0                	callq  *%rax
}
  801f61:	c9                   	leaveq 
  801f62:	c3                   	retq   

0000000000801f63 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f63:	55                   	push   %rbp
  801f64:	48 89 e5             	mov    %rsp,%rbp
  801f67:	48 83 ec 10          	sub    $0x10,%rsp
  801f6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f73:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f7a:	00 
  801f7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f87:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f8c:	48 89 c2             	mov    %rax,%rdx
  801f8f:	be 01 00 00 00       	mov    $0x1,%esi
  801f94:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f99:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  801fa0:	00 00 00 
  801fa3:	ff d0                	callq  *%rax
}
  801fa5:	c9                   	leaveq 
  801fa6:	c3                   	retq   

0000000000801fa7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801fa7:	55                   	push   %rbp
  801fa8:	48 89 e5             	mov    %rsp,%rbp
  801fab:	48 83 ec 08          	sub    $0x8,%rsp
  801faf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801fb3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fb7:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801fbe:	ff ff ff 
  801fc1:	48 01 d0             	add    %rdx,%rax
  801fc4:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801fc8:	c9                   	leaveq 
  801fc9:	c3                   	retq   

0000000000801fca <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801fca:	55                   	push   %rbp
  801fcb:	48 89 e5             	mov    %rsp,%rbp
  801fce:	48 83 ec 08          	sub    $0x8,%rsp
  801fd2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801fd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fda:	48 89 c7             	mov    %rax,%rdi
  801fdd:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  801fe4:	00 00 00 
  801fe7:	ff d0                	callq  *%rax
  801fe9:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801fef:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ff3:	c9                   	leaveq 
  801ff4:	c3                   	retq   

0000000000801ff5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ff5:	55                   	push   %rbp
  801ff6:	48 89 e5             	mov    %rsp,%rbp
  801ff9:	48 83 ec 18          	sub    $0x18,%rsp
  801ffd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802001:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802008:	eb 6b                	jmp    802075 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80200a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80200d:	48 98                	cltq   
  80200f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802015:	48 c1 e0 0c          	shl    $0xc,%rax
  802019:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80201d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802021:	48 c1 e8 15          	shr    $0x15,%rax
  802025:	48 89 c2             	mov    %rax,%rdx
  802028:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80202f:	01 00 00 
  802032:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802036:	83 e0 01             	and    $0x1,%eax
  802039:	48 85 c0             	test   %rax,%rax
  80203c:	74 21                	je     80205f <fd_alloc+0x6a>
  80203e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802042:	48 c1 e8 0c          	shr    $0xc,%rax
  802046:	48 89 c2             	mov    %rax,%rdx
  802049:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802050:	01 00 00 
  802053:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802057:	83 e0 01             	and    $0x1,%eax
  80205a:	48 85 c0             	test   %rax,%rax
  80205d:	75 12                	jne    802071 <fd_alloc+0x7c>
			*fd_store = fd;
  80205f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802063:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802067:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80206a:	b8 00 00 00 00       	mov    $0x0,%eax
  80206f:	eb 1a                	jmp    80208b <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802071:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802075:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802079:	7e 8f                	jle    80200a <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80207b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80207f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802086:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80208b:	c9                   	leaveq 
  80208c:	c3                   	retq   

000000000080208d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80208d:	55                   	push   %rbp
  80208e:	48 89 e5             	mov    %rsp,%rbp
  802091:	48 83 ec 20          	sub    $0x20,%rsp
  802095:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802098:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80209c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8020a0:	78 06                	js     8020a8 <fd_lookup+0x1b>
  8020a2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8020a6:	7e 07                	jle    8020af <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8020a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020ad:	eb 6c                	jmp    80211b <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8020af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020b2:	48 98                	cltq   
  8020b4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020ba:	48 c1 e0 0c          	shl    $0xc,%rax
  8020be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8020c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020c6:	48 c1 e8 15          	shr    $0x15,%rax
  8020ca:	48 89 c2             	mov    %rax,%rdx
  8020cd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020d4:	01 00 00 
  8020d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020db:	83 e0 01             	and    $0x1,%eax
  8020de:	48 85 c0             	test   %rax,%rax
  8020e1:	74 21                	je     802104 <fd_lookup+0x77>
  8020e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020e7:	48 c1 e8 0c          	shr    $0xc,%rax
  8020eb:	48 89 c2             	mov    %rax,%rdx
  8020ee:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020f5:	01 00 00 
  8020f8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020fc:	83 e0 01             	and    $0x1,%eax
  8020ff:	48 85 c0             	test   %rax,%rax
  802102:	75 07                	jne    80210b <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802104:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802109:	eb 10                	jmp    80211b <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80210b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80210f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802113:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802116:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80211b:	c9                   	leaveq 
  80211c:	c3                   	retq   

000000000080211d <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80211d:	55                   	push   %rbp
  80211e:	48 89 e5             	mov    %rsp,%rbp
  802121:	48 83 ec 30          	sub    $0x30,%rsp
  802125:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802129:	89 f0                	mov    %esi,%eax
  80212b:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80212e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802132:	48 89 c7             	mov    %rax,%rdi
  802135:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  80213c:	00 00 00 
  80213f:	ff d0                	callq  *%rax
  802141:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802145:	48 89 d6             	mov    %rdx,%rsi
  802148:	89 c7                	mov    %eax,%edi
  80214a:	48 b8 8d 20 80 00 00 	movabs $0x80208d,%rax
  802151:	00 00 00 
  802154:	ff d0                	callq  *%rax
  802156:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802159:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80215d:	78 0a                	js     802169 <fd_close+0x4c>
	    || fd != fd2)
  80215f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802163:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802167:	74 12                	je     80217b <fd_close+0x5e>
		return (must_exist ? r : 0);
  802169:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80216d:	74 05                	je     802174 <fd_close+0x57>
  80216f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802172:	eb 05                	jmp    802179 <fd_close+0x5c>
  802174:	b8 00 00 00 00       	mov    $0x0,%eax
  802179:	eb 69                	jmp    8021e4 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80217b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80217f:	8b 00                	mov    (%rax),%eax
  802181:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802185:	48 89 d6             	mov    %rdx,%rsi
  802188:	89 c7                	mov    %eax,%edi
  80218a:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  802191:	00 00 00 
  802194:	ff d0                	callq  *%rax
  802196:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802199:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80219d:	78 2a                	js     8021c9 <fd_close+0xac>
		if (dev->dev_close)
  80219f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8021a7:	48 85 c0             	test   %rax,%rax
  8021aa:	74 16                	je     8021c2 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8021ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8021b4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021b8:	48 89 d7             	mov    %rdx,%rdi
  8021bb:	ff d0                	callq  *%rax
  8021bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021c0:	eb 07                	jmp    8021c9 <fd_close+0xac>
		else
			r = 0;
  8021c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8021c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021cd:	48 89 c6             	mov    %rax,%rsi
  8021d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d5:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  8021dc:	00 00 00 
  8021df:	ff d0                	callq  *%rax
	return r;
  8021e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021e4:	c9                   	leaveq 
  8021e5:	c3                   	retq   

00000000008021e6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8021e6:	55                   	push   %rbp
  8021e7:	48 89 e5             	mov    %rsp,%rbp
  8021ea:	48 83 ec 20          	sub    $0x20,%rsp
  8021ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8021f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021fc:	eb 41                	jmp    80223f <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8021fe:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802205:	00 00 00 
  802208:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80220b:	48 63 d2             	movslq %edx,%rdx
  80220e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802212:	8b 00                	mov    (%rax),%eax
  802214:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802217:	75 22                	jne    80223b <dev_lookup+0x55>
			*dev = devtab[i];
  802219:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802220:	00 00 00 
  802223:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802226:	48 63 d2             	movslq %edx,%rdx
  802229:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80222d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802231:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802234:	b8 00 00 00 00       	mov    $0x0,%eax
  802239:	eb 60                	jmp    80229b <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80223b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80223f:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802246:	00 00 00 
  802249:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80224c:	48 63 d2             	movslq %edx,%rdx
  80224f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802253:	48 85 c0             	test   %rax,%rax
  802256:	75 a6                	jne    8021fe <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802258:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80225f:	00 00 00 
  802262:	48 8b 00             	mov    (%rax),%rax
  802265:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80226b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80226e:	89 c6                	mov    %eax,%esi
  802270:	48 bf 10 3e 80 00 00 	movabs $0x803e10,%rdi
  802277:	00 00 00 
  80227a:	b8 00 00 00 00       	mov    $0x0,%eax
  80227f:	48 b9 63 06 80 00 00 	movabs $0x800663,%rcx
  802286:	00 00 00 
  802289:	ff d1                	callq  *%rcx
	*dev = 0;
  80228b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80228f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802296:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80229b:	c9                   	leaveq 
  80229c:	c3                   	retq   

000000000080229d <close>:

int
close(int fdnum)
{
  80229d:	55                   	push   %rbp
  80229e:	48 89 e5             	mov    %rsp,%rbp
  8022a1:	48 83 ec 20          	sub    $0x20,%rsp
  8022a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022a8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022af:	48 89 d6             	mov    %rdx,%rsi
  8022b2:	89 c7                	mov    %eax,%edi
  8022b4:	48 b8 8d 20 80 00 00 	movabs $0x80208d,%rax
  8022bb:	00 00 00 
  8022be:	ff d0                	callq  *%rax
  8022c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c7:	79 05                	jns    8022ce <close+0x31>
		return r;
  8022c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022cc:	eb 18                	jmp    8022e6 <close+0x49>
	else
		return fd_close(fd, 1);
  8022ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d2:	be 01 00 00 00       	mov    $0x1,%esi
  8022d7:	48 89 c7             	mov    %rax,%rdi
  8022da:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  8022e1:	00 00 00 
  8022e4:	ff d0                	callq  *%rax
}
  8022e6:	c9                   	leaveq 
  8022e7:	c3                   	retq   

00000000008022e8 <close_all>:

void
close_all(void)
{
  8022e8:	55                   	push   %rbp
  8022e9:	48 89 e5             	mov    %rsp,%rbp
  8022ec:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8022f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022f7:	eb 15                	jmp    80230e <close_all+0x26>
		close(i);
  8022f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022fc:	89 c7                	mov    %eax,%edi
  8022fe:	48 b8 9d 22 80 00 00 	movabs $0x80229d,%rax
  802305:	00 00 00 
  802308:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80230a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80230e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802312:	7e e5                	jle    8022f9 <close_all+0x11>
		close(i);
}
  802314:	c9                   	leaveq 
  802315:	c3                   	retq   

0000000000802316 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802316:	55                   	push   %rbp
  802317:	48 89 e5             	mov    %rsp,%rbp
  80231a:	48 83 ec 40          	sub    $0x40,%rsp
  80231e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802321:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802324:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802328:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80232b:	48 89 d6             	mov    %rdx,%rsi
  80232e:	89 c7                	mov    %eax,%edi
  802330:	48 b8 8d 20 80 00 00 	movabs $0x80208d,%rax
  802337:	00 00 00 
  80233a:	ff d0                	callq  *%rax
  80233c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80233f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802343:	79 08                	jns    80234d <dup+0x37>
		return r;
  802345:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802348:	e9 70 01 00 00       	jmpq   8024bd <dup+0x1a7>
	close(newfdnum);
  80234d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802350:	89 c7                	mov    %eax,%edi
  802352:	48 b8 9d 22 80 00 00 	movabs $0x80229d,%rax
  802359:	00 00 00 
  80235c:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80235e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802361:	48 98                	cltq   
  802363:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802369:	48 c1 e0 0c          	shl    $0xc,%rax
  80236d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802371:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802375:	48 89 c7             	mov    %rax,%rdi
  802378:	48 b8 ca 1f 80 00 00 	movabs $0x801fca,%rax
  80237f:	00 00 00 
  802382:	ff d0                	callq  *%rax
  802384:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802388:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238c:	48 89 c7             	mov    %rax,%rdi
  80238f:	48 b8 ca 1f 80 00 00 	movabs $0x801fca,%rax
  802396:	00 00 00 
  802399:	ff d0                	callq  *%rax
  80239b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80239f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a3:	48 c1 e8 15          	shr    $0x15,%rax
  8023a7:	48 89 c2             	mov    %rax,%rdx
  8023aa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023b1:	01 00 00 
  8023b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023b8:	83 e0 01             	and    $0x1,%eax
  8023bb:	48 85 c0             	test   %rax,%rax
  8023be:	74 73                	je     802433 <dup+0x11d>
  8023c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c4:	48 c1 e8 0c          	shr    $0xc,%rax
  8023c8:	48 89 c2             	mov    %rax,%rdx
  8023cb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023d2:	01 00 00 
  8023d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023d9:	83 e0 01             	and    $0x1,%eax
  8023dc:	48 85 c0             	test   %rax,%rax
  8023df:	74 52                	je     802433 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8023e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e5:	48 c1 e8 0c          	shr    $0xc,%rax
  8023e9:	48 89 c2             	mov    %rax,%rdx
  8023ec:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023f3:	01 00 00 
  8023f6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023fa:	25 07 0e 00 00       	and    $0xe07,%eax
  8023ff:	89 c1                	mov    %eax,%ecx
  802401:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802405:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802409:	41 89 c8             	mov    %ecx,%r8d
  80240c:	48 89 d1             	mov    %rdx,%rcx
  80240f:	ba 00 00 00 00       	mov    $0x0,%edx
  802414:	48 89 c6             	mov    %rax,%rsi
  802417:	bf 00 00 00 00       	mov    $0x0,%edi
  80241c:	48 b8 8a 1d 80 00 00 	movabs $0x801d8a,%rax
  802423:	00 00 00 
  802426:	ff d0                	callq  *%rax
  802428:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80242b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80242f:	79 02                	jns    802433 <dup+0x11d>
			goto err;
  802431:	eb 57                	jmp    80248a <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802433:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802437:	48 c1 e8 0c          	shr    $0xc,%rax
  80243b:	48 89 c2             	mov    %rax,%rdx
  80243e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802445:	01 00 00 
  802448:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80244c:	25 07 0e 00 00       	and    $0xe07,%eax
  802451:	89 c1                	mov    %eax,%ecx
  802453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802457:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80245b:	41 89 c8             	mov    %ecx,%r8d
  80245e:	48 89 d1             	mov    %rdx,%rcx
  802461:	ba 00 00 00 00       	mov    $0x0,%edx
  802466:	48 89 c6             	mov    %rax,%rsi
  802469:	bf 00 00 00 00       	mov    $0x0,%edi
  80246e:	48 b8 8a 1d 80 00 00 	movabs $0x801d8a,%rax
  802475:	00 00 00 
  802478:	ff d0                	callq  *%rax
  80247a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80247d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802481:	79 02                	jns    802485 <dup+0x16f>
		goto err;
  802483:	eb 05                	jmp    80248a <dup+0x174>

	return newfdnum;
  802485:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802488:	eb 33                	jmp    8024bd <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80248a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80248e:	48 89 c6             	mov    %rax,%rsi
  802491:	bf 00 00 00 00       	mov    $0x0,%edi
  802496:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  80249d:	00 00 00 
  8024a0:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8024a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024a6:	48 89 c6             	mov    %rax,%rsi
  8024a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ae:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  8024b5:	00 00 00 
  8024b8:	ff d0                	callq  *%rax
	return r;
  8024ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024bd:	c9                   	leaveq 
  8024be:	c3                   	retq   

00000000008024bf <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8024bf:	55                   	push   %rbp
  8024c0:	48 89 e5             	mov    %rsp,%rbp
  8024c3:	48 83 ec 40          	sub    $0x40,%rsp
  8024c7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024ca:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024ce:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024d2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024d6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024d9:	48 89 d6             	mov    %rdx,%rsi
  8024dc:	89 c7                	mov    %eax,%edi
  8024de:	48 b8 8d 20 80 00 00 	movabs $0x80208d,%rax
  8024e5:	00 00 00 
  8024e8:	ff d0                	callq  *%rax
  8024ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f1:	78 24                	js     802517 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f7:	8b 00                	mov    (%rax),%eax
  8024f9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024fd:	48 89 d6             	mov    %rdx,%rsi
  802500:	89 c7                	mov    %eax,%edi
  802502:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  802509:	00 00 00 
  80250c:	ff d0                	callq  *%rax
  80250e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802511:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802515:	79 05                	jns    80251c <read+0x5d>
		return r;
  802517:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251a:	eb 76                	jmp    802592 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80251c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802520:	8b 40 08             	mov    0x8(%rax),%eax
  802523:	83 e0 03             	and    $0x3,%eax
  802526:	83 f8 01             	cmp    $0x1,%eax
  802529:	75 3a                	jne    802565 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80252b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802532:	00 00 00 
  802535:	48 8b 00             	mov    (%rax),%rax
  802538:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80253e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802541:	89 c6                	mov    %eax,%esi
  802543:	48 bf 2f 3e 80 00 00 	movabs $0x803e2f,%rdi
  80254a:	00 00 00 
  80254d:	b8 00 00 00 00       	mov    $0x0,%eax
  802552:	48 b9 63 06 80 00 00 	movabs $0x800663,%rcx
  802559:	00 00 00 
  80255c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80255e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802563:	eb 2d                	jmp    802592 <read+0xd3>
	}
	if (!dev->dev_read)
  802565:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802569:	48 8b 40 10          	mov    0x10(%rax),%rax
  80256d:	48 85 c0             	test   %rax,%rax
  802570:	75 07                	jne    802579 <read+0xba>
		return -E_NOT_SUPP;
  802572:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802577:	eb 19                	jmp    802592 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802581:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802585:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802589:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80258d:	48 89 cf             	mov    %rcx,%rdi
  802590:	ff d0                	callq  *%rax
}
  802592:	c9                   	leaveq 
  802593:	c3                   	retq   

0000000000802594 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802594:	55                   	push   %rbp
  802595:	48 89 e5             	mov    %rsp,%rbp
  802598:	48 83 ec 30          	sub    $0x30,%rsp
  80259c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80259f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8025a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025ae:	eb 49                	jmp    8025f9 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8025b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b3:	48 98                	cltq   
  8025b5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025b9:	48 29 c2             	sub    %rax,%rdx
  8025bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025bf:	48 63 c8             	movslq %eax,%rcx
  8025c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025c6:	48 01 c1             	add    %rax,%rcx
  8025c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025cc:	48 89 ce             	mov    %rcx,%rsi
  8025cf:	89 c7                	mov    %eax,%edi
  8025d1:	48 b8 bf 24 80 00 00 	movabs $0x8024bf,%rax
  8025d8:	00 00 00 
  8025db:	ff d0                	callq  *%rax
  8025dd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8025e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8025e4:	79 05                	jns    8025eb <readn+0x57>
			return m;
  8025e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025e9:	eb 1c                	jmp    802607 <readn+0x73>
		if (m == 0)
  8025eb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8025ef:	75 02                	jne    8025f3 <readn+0x5f>
			break;
  8025f1:	eb 11                	jmp    802604 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8025f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025f6:	01 45 fc             	add    %eax,-0x4(%rbp)
  8025f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025fc:	48 98                	cltq   
  8025fe:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802602:	72 ac                	jb     8025b0 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802604:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802607:	c9                   	leaveq 
  802608:	c3                   	retq   

0000000000802609 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802609:	55                   	push   %rbp
  80260a:	48 89 e5             	mov    %rsp,%rbp
  80260d:	48 83 ec 40          	sub    $0x40,%rsp
  802611:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802614:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802618:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80261c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802620:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802623:	48 89 d6             	mov    %rdx,%rsi
  802626:	89 c7                	mov    %eax,%edi
  802628:	48 b8 8d 20 80 00 00 	movabs $0x80208d,%rax
  80262f:	00 00 00 
  802632:	ff d0                	callq  *%rax
  802634:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802637:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80263b:	78 24                	js     802661 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80263d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802641:	8b 00                	mov    (%rax),%eax
  802643:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802647:	48 89 d6             	mov    %rdx,%rsi
  80264a:	89 c7                	mov    %eax,%edi
  80264c:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  802653:	00 00 00 
  802656:	ff d0                	callq  *%rax
  802658:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265f:	79 05                	jns    802666 <write+0x5d>
		return r;
  802661:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802664:	eb 75                	jmp    8026db <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802666:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80266a:	8b 40 08             	mov    0x8(%rax),%eax
  80266d:	83 e0 03             	and    $0x3,%eax
  802670:	85 c0                	test   %eax,%eax
  802672:	75 3a                	jne    8026ae <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802674:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80267b:	00 00 00 
  80267e:	48 8b 00             	mov    (%rax),%rax
  802681:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802687:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80268a:	89 c6                	mov    %eax,%esi
  80268c:	48 bf 4b 3e 80 00 00 	movabs $0x803e4b,%rdi
  802693:	00 00 00 
  802696:	b8 00 00 00 00       	mov    $0x0,%eax
  80269b:	48 b9 63 06 80 00 00 	movabs $0x800663,%rcx
  8026a2:	00 00 00 
  8026a5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8026a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026ac:	eb 2d                	jmp    8026db <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8026ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b2:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026b6:	48 85 c0             	test   %rax,%rax
  8026b9:	75 07                	jne    8026c2 <write+0xb9>
		return -E_NOT_SUPP;
  8026bb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026c0:	eb 19                	jmp    8026db <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8026c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c6:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026ca:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8026ce:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026d2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026d6:	48 89 cf             	mov    %rcx,%rdi
  8026d9:	ff d0                	callq  *%rax
}
  8026db:	c9                   	leaveq 
  8026dc:	c3                   	retq   

00000000008026dd <seek>:

int
seek(int fdnum, off_t offset)
{
  8026dd:	55                   	push   %rbp
  8026de:	48 89 e5             	mov    %rsp,%rbp
  8026e1:	48 83 ec 18          	sub    $0x18,%rsp
  8026e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026e8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026eb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026f2:	48 89 d6             	mov    %rdx,%rsi
  8026f5:	89 c7                	mov    %eax,%edi
  8026f7:	48 b8 8d 20 80 00 00 	movabs $0x80208d,%rax
  8026fe:	00 00 00 
  802701:	ff d0                	callq  *%rax
  802703:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802706:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80270a:	79 05                	jns    802711 <seek+0x34>
		return r;
  80270c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80270f:	eb 0f                	jmp    802720 <seek+0x43>
	fd->fd_offset = offset;
  802711:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802715:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802718:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80271b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802720:	c9                   	leaveq 
  802721:	c3                   	retq   

0000000000802722 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802722:	55                   	push   %rbp
  802723:	48 89 e5             	mov    %rsp,%rbp
  802726:	48 83 ec 30          	sub    $0x30,%rsp
  80272a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80272d:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802730:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802734:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802737:	48 89 d6             	mov    %rdx,%rsi
  80273a:	89 c7                	mov    %eax,%edi
  80273c:	48 b8 8d 20 80 00 00 	movabs $0x80208d,%rax
  802743:	00 00 00 
  802746:	ff d0                	callq  *%rax
  802748:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80274b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80274f:	78 24                	js     802775 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802751:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802755:	8b 00                	mov    (%rax),%eax
  802757:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80275b:	48 89 d6             	mov    %rdx,%rsi
  80275e:	89 c7                	mov    %eax,%edi
  802760:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  802767:	00 00 00 
  80276a:	ff d0                	callq  *%rax
  80276c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80276f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802773:	79 05                	jns    80277a <ftruncate+0x58>
		return r;
  802775:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802778:	eb 72                	jmp    8027ec <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80277a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80277e:	8b 40 08             	mov    0x8(%rax),%eax
  802781:	83 e0 03             	and    $0x3,%eax
  802784:	85 c0                	test   %eax,%eax
  802786:	75 3a                	jne    8027c2 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802788:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80278f:	00 00 00 
  802792:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802795:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80279b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80279e:	89 c6                	mov    %eax,%esi
  8027a0:	48 bf 68 3e 80 00 00 	movabs $0x803e68,%rdi
  8027a7:	00 00 00 
  8027aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8027af:	48 b9 63 06 80 00 00 	movabs $0x800663,%rcx
  8027b6:	00 00 00 
  8027b9:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8027bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027c0:	eb 2a                	jmp    8027ec <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8027c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027c6:	48 8b 40 30          	mov    0x30(%rax),%rax
  8027ca:	48 85 c0             	test   %rax,%rax
  8027cd:	75 07                	jne    8027d6 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8027cf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027d4:	eb 16                	jmp    8027ec <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8027d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027da:	48 8b 40 30          	mov    0x30(%rax),%rax
  8027de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027e2:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8027e5:	89 ce                	mov    %ecx,%esi
  8027e7:	48 89 d7             	mov    %rdx,%rdi
  8027ea:	ff d0                	callq  *%rax
}
  8027ec:	c9                   	leaveq 
  8027ed:	c3                   	retq   

00000000008027ee <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8027ee:	55                   	push   %rbp
  8027ef:	48 89 e5             	mov    %rsp,%rbp
  8027f2:	48 83 ec 30          	sub    $0x30,%rsp
  8027f6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027f9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027fd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802801:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802804:	48 89 d6             	mov    %rdx,%rsi
  802807:	89 c7                	mov    %eax,%edi
  802809:	48 b8 8d 20 80 00 00 	movabs $0x80208d,%rax
  802810:	00 00 00 
  802813:	ff d0                	callq  *%rax
  802815:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802818:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80281c:	78 24                	js     802842 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80281e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802822:	8b 00                	mov    (%rax),%eax
  802824:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802828:	48 89 d6             	mov    %rdx,%rsi
  80282b:	89 c7                	mov    %eax,%edi
  80282d:	48 b8 e6 21 80 00 00 	movabs $0x8021e6,%rax
  802834:	00 00 00 
  802837:	ff d0                	callq  *%rax
  802839:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80283c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802840:	79 05                	jns    802847 <fstat+0x59>
		return r;
  802842:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802845:	eb 5e                	jmp    8028a5 <fstat+0xb7>
	if (!dev->dev_stat)
  802847:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284b:	48 8b 40 28          	mov    0x28(%rax),%rax
  80284f:	48 85 c0             	test   %rax,%rax
  802852:	75 07                	jne    80285b <fstat+0x6d>
		return -E_NOT_SUPP;
  802854:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802859:	eb 4a                	jmp    8028a5 <fstat+0xb7>
	stat->st_name[0] = 0;
  80285b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80285f:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802862:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802866:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80286d:	00 00 00 
	stat->st_isdir = 0;
  802870:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802874:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80287b:	00 00 00 
	stat->st_dev = dev;
  80287e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802882:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802886:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80288d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802891:	48 8b 40 28          	mov    0x28(%rax),%rax
  802895:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802899:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80289d:	48 89 ce             	mov    %rcx,%rsi
  8028a0:	48 89 d7             	mov    %rdx,%rdi
  8028a3:	ff d0                	callq  *%rax
}
  8028a5:	c9                   	leaveq 
  8028a6:	c3                   	retq   

00000000008028a7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8028a7:	55                   	push   %rbp
  8028a8:	48 89 e5             	mov    %rsp,%rbp
  8028ab:	48 83 ec 20          	sub    $0x20,%rsp
  8028af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8028b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028bb:	be 00 00 00 00       	mov    $0x0,%esi
  8028c0:	48 89 c7             	mov    %rax,%rdi
  8028c3:	48 b8 95 29 80 00 00 	movabs $0x802995,%rax
  8028ca:	00 00 00 
  8028cd:	ff d0                	callq  *%rax
  8028cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d6:	79 05                	jns    8028dd <stat+0x36>
		return fd;
  8028d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028db:	eb 2f                	jmp    80290c <stat+0x65>
	r = fstat(fd, stat);
  8028dd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e4:	48 89 d6             	mov    %rdx,%rsi
  8028e7:	89 c7                	mov    %eax,%edi
  8028e9:	48 b8 ee 27 80 00 00 	movabs $0x8027ee,%rax
  8028f0:	00 00 00 
  8028f3:	ff d0                	callq  *%rax
  8028f5:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8028f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028fb:	89 c7                	mov    %eax,%edi
  8028fd:	48 b8 9d 22 80 00 00 	movabs $0x80229d,%rax
  802904:	00 00 00 
  802907:	ff d0                	callq  *%rax
	return r;
  802909:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80290c:	c9                   	leaveq 
  80290d:	c3                   	retq   

000000000080290e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80290e:	55                   	push   %rbp
  80290f:	48 89 e5             	mov    %rsp,%rbp
  802912:	48 83 ec 10          	sub    $0x10,%rsp
  802916:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802919:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80291d:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802924:	00 00 00 
  802927:	8b 00                	mov    (%rax),%eax
  802929:	85 c0                	test   %eax,%eax
  80292b:	75 1d                	jne    80294a <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80292d:	bf 01 00 00 00       	mov    $0x1,%edi
  802932:	48 b8 04 37 80 00 00 	movabs $0x803704,%rax
  802939:	00 00 00 
  80293c:	ff d0                	callq  *%rax
  80293e:	48 ba 04 60 80 00 00 	movabs $0x806004,%rdx
  802945:	00 00 00 
  802948:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80294a:	48 b8 04 60 80 00 00 	movabs $0x806004,%rax
  802951:	00 00 00 
  802954:	8b 00                	mov    (%rax),%eax
  802956:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802959:	b9 07 00 00 00       	mov    $0x7,%ecx
  80295e:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802965:	00 00 00 
  802968:	89 c7                	mov    %eax,%edi
  80296a:	48 b8 6c 36 80 00 00 	movabs $0x80366c,%rax
  802971:	00 00 00 
  802974:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802976:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80297a:	ba 00 00 00 00       	mov    $0x0,%edx
  80297f:	48 89 c6             	mov    %rax,%rsi
  802982:	bf 00 00 00 00       	mov    $0x0,%edi
  802987:	48 b8 a3 35 80 00 00 	movabs $0x8035a3,%rax
  80298e:	00 00 00 
  802991:	ff d0                	callq  *%rax
}
  802993:	c9                   	leaveq 
  802994:	c3                   	retq   

0000000000802995 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802995:	55                   	push   %rbp
  802996:	48 89 e5             	mov    %rsp,%rbp
  802999:	48 83 ec 20          	sub    $0x20,%rsp
  80299d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029a1:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here
	struct Fd *fd;
	int r;

	if (strlen(path) >= MAXPATHLEN)
  8029a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a8:	48 89 c7             	mov    %rax,%rdi
  8029ab:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  8029b2:	00 00 00 
  8029b5:	ff d0                	callq  *%rax
  8029b7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8029bc:	7e 0a                	jle    8029c8 <open+0x33>
		return -E_BAD_PATH;
  8029be:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8029c3:	e9 a5 00 00 00       	jmpq   802a6d <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8029c8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8029cc:	48 89 c7             	mov    %rax,%rdi
  8029cf:	48 b8 f5 1f 80 00 00 	movabs $0x801ff5,%rax
  8029d6:	00 00 00 
  8029d9:	ff d0                	callq  *%rax
  8029db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e2:	79 08                	jns    8029ec <open+0x57>
		return r;
  8029e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e7:	e9 81 00 00 00       	jmpq   802a6d <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8029ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f0:	48 89 c6             	mov    %rax,%rsi
  8029f3:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8029fa:	00 00 00 
  8029fd:	48 b8 0b 14 80 00 00 	movabs $0x80140b,%rax
  802a04:	00 00 00 
  802a07:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802a09:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a10:	00 00 00 
  802a13:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802a16:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802a1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a20:	48 89 c6             	mov    %rax,%rsi
  802a23:	bf 01 00 00 00       	mov    $0x1,%edi
  802a28:	48 b8 0e 29 80 00 00 	movabs $0x80290e,%rax
  802a2f:	00 00 00 
  802a32:	ff d0                	callq  *%rax
  802a34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a3b:	79 1d                	jns    802a5a <open+0xc5>
		fd_close(fd, 0);
  802a3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a41:	be 00 00 00 00       	mov    $0x0,%esi
  802a46:	48 89 c7             	mov    %rax,%rdi
  802a49:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  802a50:	00 00 00 
  802a53:	ff d0                	callq  *%rax
		return r;
  802a55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a58:	eb 13                	jmp    802a6d <open+0xd8>
	}

	return fd2num(fd);
  802a5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a5e:	48 89 c7             	mov    %rax,%rdi
  802a61:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  802a68:	00 00 00 
  802a6b:	ff d0                	callq  *%rax
	//panic ("open not implemented");
}
  802a6d:	c9                   	leaveq 
  802a6e:	c3                   	retq   

0000000000802a6f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802a6f:	55                   	push   %rbp
  802a70:	48 89 e5             	mov    %rsp,%rbp
  802a73:	48 83 ec 10          	sub    $0x10,%rsp
  802a77:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802a7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a7f:	8b 50 0c             	mov    0xc(%rax),%edx
  802a82:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a89:	00 00 00 
  802a8c:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802a8e:	be 00 00 00 00       	mov    $0x0,%esi
  802a93:	bf 06 00 00 00       	mov    $0x6,%edi
  802a98:	48 b8 0e 29 80 00 00 	movabs $0x80290e,%rax
  802a9f:	00 00 00 
  802aa2:	ff d0                	callq  *%rax
}
  802aa4:	c9                   	leaveq 
  802aa5:	c3                   	retq   

0000000000802aa6 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802aa6:	55                   	push   %rbp
  802aa7:	48 89 e5             	mov    %rsp,%rbp
  802aaa:	48 83 ec 30          	sub    $0x30,%rsp
  802aae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ab2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ab6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802aba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802abe:	8b 50 0c             	mov    0xc(%rax),%edx
  802ac1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ac8:	00 00 00 
  802acb:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802acd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ad4:	00 00 00 
  802ad7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802adb:	48 89 50 08          	mov    %rdx,0x8(%rax)

	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802adf:	be 00 00 00 00       	mov    $0x0,%esi
  802ae4:	bf 03 00 00 00       	mov    $0x3,%edi
  802ae9:	48 b8 0e 29 80 00 00 	movabs $0x80290e,%rax
  802af0:	00 00 00 
  802af3:	ff d0                	callq  *%rax
  802af5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afc:	79 05                	jns    802b03 <devfile_read+0x5d>
		return r;
  802afe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b01:	eb 26                	jmp    802b29 <devfile_read+0x83>

	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802b03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b06:	48 63 d0             	movslq %eax,%rdx
  802b09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b0d:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802b14:	00 00 00 
  802b17:	48 89 c7             	mov    %rax,%rdi
  802b1a:	48 b8 2f 17 80 00 00 	movabs $0x80172f,%rax
  802b21:	00 00 00 
  802b24:	ff d0                	callq  *%rax

	return r;
  802b26:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802b29:	c9                   	leaveq 
  802b2a:	c3                   	retq   

0000000000802b2b <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802b2b:	55                   	push   %rbp
  802b2c:	48 89 e5             	mov    %rsp,%rbp
  802b2f:	48 83 ec 30          	sub    $0x30,%rsp
  802b33:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b37:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b3b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	if (n > sizeof(fsipcbuf.write.req_buf))
  802b3f:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802b46:	00 
  802b47:	76 08                	jbe    802b51 <devfile_write+0x26>
		n = sizeof(fsipcbuf.write.req_buf);
  802b49:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802b50:	00 

	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802b51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b55:	8b 50 0c             	mov    0xc(%rax),%edx
  802b58:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b5f:	00 00 00 
  802b62:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802b64:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802b6b:	00 00 00 
  802b6e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b72:	48 89 50 08          	mov    %rdx,0x8(%rax)

	memmove(fsipcbuf.write.req_buf, buf, n);
  802b76:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b7e:	48 89 c6             	mov    %rax,%rsi
  802b81:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802b88:	00 00 00 
  802b8b:	48 b8 2f 17 80 00 00 	movabs $0x80172f,%rax
  802b92:	00 00 00 
  802b95:	ff d0                	callq  *%rax

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802b97:	be 00 00 00 00       	mov    $0x0,%esi
  802b9c:	bf 04 00 00 00       	mov    $0x4,%edi
  802ba1:	48 b8 0e 29 80 00 00 	movabs $0x80290e,%rax
  802ba8:	00 00 00 
  802bab:	ff d0                	callq  *%rax
  802bad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb4:	79 05                	jns    802bbb <devfile_write+0x90>
		return r;
  802bb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb9:	eb 03                	jmp    802bbe <devfile_write+0x93>

	return r;
  802bbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802bbe:	c9                   	leaveq 
  802bbf:	c3                   	retq   

0000000000802bc0 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802bc0:	55                   	push   %rbp
  802bc1:	48 89 e5             	mov    %rsp,%rbp
  802bc4:	48 83 ec 20          	sub    $0x20,%rsp
  802bc8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bcc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802bd0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd4:	8b 50 0c             	mov    0xc(%rax),%edx
  802bd7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bde:	00 00 00 
  802be1:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802be3:	be 00 00 00 00       	mov    $0x0,%esi
  802be8:	bf 05 00 00 00       	mov    $0x5,%edi
  802bed:	48 b8 0e 29 80 00 00 	movabs $0x80290e,%rax
  802bf4:	00 00 00 
  802bf7:	ff d0                	callq  *%rax
  802bf9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bfc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c00:	79 05                	jns    802c07 <devfile_stat+0x47>
		return r;
  802c02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c05:	eb 56                	jmp    802c5d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802c07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c0b:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802c12:	00 00 00 
  802c15:	48 89 c7             	mov    %rax,%rdi
  802c18:	48 b8 0b 14 80 00 00 	movabs $0x80140b,%rax
  802c1f:	00 00 00 
  802c22:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802c24:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c2b:	00 00 00 
  802c2e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802c34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c38:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802c3e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c45:	00 00 00 
  802c48:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802c4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c52:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802c58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c5d:	c9                   	leaveq 
  802c5e:	c3                   	retq   

0000000000802c5f <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802c5f:	55                   	push   %rbp
  802c60:	48 89 e5             	mov    %rsp,%rbp
  802c63:	48 83 ec 10          	sub    $0x10,%rsp
  802c67:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c6b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802c6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c72:	8b 50 0c             	mov    0xc(%rax),%edx
  802c75:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c7c:	00 00 00 
  802c7f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802c81:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c88:	00 00 00 
  802c8b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802c8e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c91:	be 00 00 00 00       	mov    $0x0,%esi
  802c96:	bf 02 00 00 00       	mov    $0x2,%edi
  802c9b:	48 b8 0e 29 80 00 00 	movabs $0x80290e,%rax
  802ca2:	00 00 00 
  802ca5:	ff d0                	callq  *%rax
}
  802ca7:	c9                   	leaveq 
  802ca8:	c3                   	retq   

0000000000802ca9 <remove>:

// Delete a file
int
remove(const char *path)
{
  802ca9:	55                   	push   %rbp
  802caa:	48 89 e5             	mov    %rsp,%rbp
  802cad:	48 83 ec 10          	sub    $0x10,%rsp
  802cb1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802cb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cb9:	48 89 c7             	mov    %rax,%rdi
  802cbc:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  802cc3:	00 00 00 
  802cc6:	ff d0                	callq  *%rax
  802cc8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ccd:	7e 07                	jle    802cd6 <remove+0x2d>
		return -E_BAD_PATH;
  802ccf:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802cd4:	eb 33                	jmp    802d09 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802cd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cda:	48 89 c6             	mov    %rax,%rsi
  802cdd:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802ce4:	00 00 00 
  802ce7:	48 b8 0b 14 80 00 00 	movabs $0x80140b,%rax
  802cee:	00 00 00 
  802cf1:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802cf3:	be 00 00 00 00       	mov    $0x0,%esi
  802cf8:	bf 07 00 00 00       	mov    $0x7,%edi
  802cfd:	48 b8 0e 29 80 00 00 	movabs $0x80290e,%rax
  802d04:	00 00 00 
  802d07:	ff d0                	callq  *%rax
}
  802d09:	c9                   	leaveq 
  802d0a:	c3                   	retq   

0000000000802d0b <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802d0b:	55                   	push   %rbp
  802d0c:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802d0f:	be 00 00 00 00       	mov    $0x0,%esi
  802d14:	bf 08 00 00 00       	mov    $0x8,%edi
  802d19:	48 b8 0e 29 80 00 00 	movabs $0x80290e,%rax
  802d20:	00 00 00 
  802d23:	ff d0                	callq  *%rax
}
  802d25:	5d                   	pop    %rbp
  802d26:	c3                   	retq   

0000000000802d27 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802d27:	55                   	push   %rbp
  802d28:	48 89 e5             	mov    %rsp,%rbp
  802d2b:	53                   	push   %rbx
  802d2c:	48 83 ec 38          	sub    $0x38,%rsp
  802d30:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802d34:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802d38:	48 89 c7             	mov    %rax,%rdi
  802d3b:	48 b8 f5 1f 80 00 00 	movabs $0x801ff5,%rax
  802d42:	00 00 00 
  802d45:	ff d0                	callq  *%rax
  802d47:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d4a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d4e:	0f 88 bf 01 00 00    	js     802f13 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d58:	ba 07 04 00 00       	mov    $0x407,%edx
  802d5d:	48 89 c6             	mov    %rax,%rsi
  802d60:	bf 00 00 00 00       	mov    $0x0,%edi
  802d65:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  802d6c:	00 00 00 
  802d6f:	ff d0                	callq  *%rax
  802d71:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d74:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d78:	0f 88 95 01 00 00    	js     802f13 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802d7e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802d82:	48 89 c7             	mov    %rax,%rdi
  802d85:	48 b8 f5 1f 80 00 00 	movabs $0x801ff5,%rax
  802d8c:	00 00 00 
  802d8f:	ff d0                	callq  *%rax
  802d91:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d94:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d98:	0f 88 5d 01 00 00    	js     802efb <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d9e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802da2:	ba 07 04 00 00       	mov    $0x407,%edx
  802da7:	48 89 c6             	mov    %rax,%rsi
  802daa:	bf 00 00 00 00       	mov    $0x0,%edi
  802daf:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  802db6:	00 00 00 
  802db9:	ff d0                	callq  *%rax
  802dbb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802dbe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802dc2:	0f 88 33 01 00 00    	js     802efb <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802dc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dcc:	48 89 c7             	mov    %rax,%rdi
  802dcf:	48 b8 ca 1f 80 00 00 	movabs $0x801fca,%rax
  802dd6:	00 00 00 
  802dd9:	ff d0                	callq  *%rax
  802ddb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ddf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802de3:	ba 07 04 00 00       	mov    $0x407,%edx
  802de8:	48 89 c6             	mov    %rax,%rsi
  802deb:	bf 00 00 00 00       	mov    $0x0,%edi
  802df0:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  802df7:	00 00 00 
  802dfa:	ff d0                	callq  *%rax
  802dfc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802dff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e03:	79 05                	jns    802e0a <pipe+0xe3>
		goto err2;
  802e05:	e9 d9 00 00 00       	jmpq   802ee3 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e0a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e0e:	48 89 c7             	mov    %rax,%rdi
  802e11:	48 b8 ca 1f 80 00 00 	movabs $0x801fca,%rax
  802e18:	00 00 00 
  802e1b:	ff d0                	callq  *%rax
  802e1d:	48 89 c2             	mov    %rax,%rdx
  802e20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e24:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802e2a:	48 89 d1             	mov    %rdx,%rcx
  802e2d:	ba 00 00 00 00       	mov    $0x0,%edx
  802e32:	48 89 c6             	mov    %rax,%rsi
  802e35:	bf 00 00 00 00       	mov    $0x0,%edi
  802e3a:	48 b8 8a 1d 80 00 00 	movabs $0x801d8a,%rax
  802e41:	00 00 00 
  802e44:	ff d0                	callq  *%rax
  802e46:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802e49:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802e4d:	79 1b                	jns    802e6a <pipe+0x143>
		goto err3;
  802e4f:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  802e50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e54:	48 89 c6             	mov    %rax,%rsi
  802e57:	bf 00 00 00 00       	mov    $0x0,%edi
  802e5c:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  802e63:	00 00 00 
  802e66:	ff d0                	callq  *%rax
  802e68:	eb 79                	jmp    802ee3 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802e6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e6e:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802e75:	00 00 00 
  802e78:	8b 12                	mov    (%rdx),%edx
  802e7a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802e7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e80:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802e87:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e8b:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802e92:	00 00 00 
  802e95:	8b 12                	mov    (%rdx),%edx
  802e97:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802e99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e9d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802ea4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ea8:	48 89 c7             	mov    %rax,%rdi
  802eab:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  802eb2:	00 00 00 
  802eb5:	ff d0                	callq  *%rax
  802eb7:	89 c2                	mov    %eax,%edx
  802eb9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ebd:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802ebf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ec3:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802ec7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ecb:	48 89 c7             	mov    %rax,%rdi
  802ece:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  802ed5:	00 00 00 
  802ed8:	ff d0                	callq  *%rax
  802eda:	89 03                	mov    %eax,(%rbx)
	return 0;
  802edc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee1:	eb 33                	jmp    802f16 <pipe+0x1ef>

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  802ee3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ee7:	48 89 c6             	mov    %rax,%rsi
  802eea:	bf 00 00 00 00       	mov    $0x0,%edi
  802eef:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  802ef6:	00 00 00 
  802ef9:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  802efb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eff:	48 89 c6             	mov    %rax,%rsi
  802f02:	bf 00 00 00 00       	mov    $0x0,%edi
  802f07:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  802f0e:	00 00 00 
  802f11:	ff d0                	callq  *%rax
    err:
	return r;
  802f13:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802f16:	48 83 c4 38          	add    $0x38,%rsp
  802f1a:	5b                   	pop    %rbx
  802f1b:	5d                   	pop    %rbp
  802f1c:	c3                   	retq   

0000000000802f1d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802f1d:	55                   	push   %rbp
  802f1e:	48 89 e5             	mov    %rsp,%rbp
  802f21:	53                   	push   %rbx
  802f22:	48 83 ec 28          	sub    $0x28,%rsp
  802f26:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f2a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802f2e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802f35:	00 00 00 
  802f38:	48 8b 00             	mov    (%rax),%rax
  802f3b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802f41:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802f44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f48:	48 89 c7             	mov    %rax,%rdi
  802f4b:	48 b8 86 37 80 00 00 	movabs $0x803786,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
  802f57:	89 c3                	mov    %eax,%ebx
  802f59:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f5d:	48 89 c7             	mov    %rax,%rdi
  802f60:	48 b8 86 37 80 00 00 	movabs $0x803786,%rax
  802f67:	00 00 00 
  802f6a:	ff d0                	callq  *%rax
  802f6c:	39 c3                	cmp    %eax,%ebx
  802f6e:	0f 94 c0             	sete   %al
  802f71:	0f b6 c0             	movzbl %al,%eax
  802f74:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802f77:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802f7e:	00 00 00 
  802f81:	48 8b 00             	mov    (%rax),%rax
  802f84:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802f8a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802f8d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f90:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802f93:	75 05                	jne    802f9a <_pipeisclosed+0x7d>
			return ret;
  802f95:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f98:	eb 4f                	jmp    802fe9 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802f9a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f9d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802fa0:	74 42                	je     802fe4 <_pipeisclosed+0xc7>
  802fa2:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802fa6:	75 3c                	jne    802fe4 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802fa8:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802faf:	00 00 00 
  802fb2:	48 8b 00             	mov    (%rax),%rax
  802fb5:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802fbb:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802fbe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fc1:	89 c6                	mov    %eax,%esi
  802fc3:	48 bf 93 3e 80 00 00 	movabs $0x803e93,%rdi
  802fca:	00 00 00 
  802fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd2:	49 b8 63 06 80 00 00 	movabs $0x800663,%r8
  802fd9:	00 00 00 
  802fdc:	41 ff d0             	callq  *%r8
	}
  802fdf:	e9 4a ff ff ff       	jmpq   802f2e <_pipeisclosed+0x11>
  802fe4:	e9 45 ff ff ff       	jmpq   802f2e <_pipeisclosed+0x11>
}
  802fe9:	48 83 c4 28          	add    $0x28,%rsp
  802fed:	5b                   	pop    %rbx
  802fee:	5d                   	pop    %rbp
  802fef:	c3                   	retq   

0000000000802ff0 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802ff0:	55                   	push   %rbp
  802ff1:	48 89 e5             	mov    %rsp,%rbp
  802ff4:	48 83 ec 30          	sub    $0x30,%rsp
  802ff8:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ffb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802fff:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803002:	48 89 d6             	mov    %rdx,%rsi
  803005:	89 c7                	mov    %eax,%edi
  803007:	48 b8 8d 20 80 00 00 	movabs $0x80208d,%rax
  80300e:	00 00 00 
  803011:	ff d0                	callq  *%rax
  803013:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803016:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80301a:	79 05                	jns    803021 <pipeisclosed+0x31>
		return r;
  80301c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80301f:	eb 31                	jmp    803052 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803021:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803025:	48 89 c7             	mov    %rax,%rdi
  803028:	48 b8 ca 1f 80 00 00 	movabs $0x801fca,%rax
  80302f:	00 00 00 
  803032:	ff d0                	callq  *%rax
  803034:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803038:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80303c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803040:	48 89 d6             	mov    %rdx,%rsi
  803043:	48 89 c7             	mov    %rax,%rdi
  803046:	48 b8 1d 2f 80 00 00 	movabs $0x802f1d,%rax
  80304d:	00 00 00 
  803050:	ff d0                	callq  *%rax
}
  803052:	c9                   	leaveq 
  803053:	c3                   	retq   

0000000000803054 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803054:	55                   	push   %rbp
  803055:	48 89 e5             	mov    %rsp,%rbp
  803058:	48 83 ec 40          	sub    $0x40,%rsp
  80305c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803060:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803064:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803068:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80306c:	48 89 c7             	mov    %rax,%rdi
  80306f:	48 b8 ca 1f 80 00 00 	movabs $0x801fca,%rax
  803076:	00 00 00 
  803079:	ff d0                	callq  *%rax
  80307b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80307f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803083:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803087:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80308e:	00 
  80308f:	e9 92 00 00 00       	jmpq   803126 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803094:	eb 41                	jmp    8030d7 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803096:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80309b:	74 09                	je     8030a6 <devpipe_read+0x52>
				return i;
  80309d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030a1:	e9 92 00 00 00       	jmpq   803138 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8030a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030ae:	48 89 d6             	mov    %rdx,%rsi
  8030b1:	48 89 c7             	mov    %rax,%rdi
  8030b4:	48 b8 1d 2f 80 00 00 	movabs $0x802f1d,%rax
  8030bb:	00 00 00 
  8030be:	ff d0                	callq  *%rax
  8030c0:	85 c0                	test   %eax,%eax
  8030c2:	74 07                	je     8030cb <devpipe_read+0x77>
				return 0;
  8030c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c9:	eb 6d                	jmp    803138 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8030cb:	48 b8 fc 1c 80 00 00 	movabs $0x801cfc,%rax
  8030d2:	00 00 00 
  8030d5:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8030d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030db:	8b 10                	mov    (%rax),%edx
  8030dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e1:	8b 40 04             	mov    0x4(%rax),%eax
  8030e4:	39 c2                	cmp    %eax,%edx
  8030e6:	74 ae                	je     803096 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8030e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030f0:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8030f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f8:	8b 00                	mov    (%rax),%eax
  8030fa:	99                   	cltd   
  8030fb:	c1 ea 1b             	shr    $0x1b,%edx
  8030fe:	01 d0                	add    %edx,%eax
  803100:	83 e0 1f             	and    $0x1f,%eax
  803103:	29 d0                	sub    %edx,%eax
  803105:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803109:	48 98                	cltq   
  80310b:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803110:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803112:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803116:	8b 00                	mov    (%rax),%eax
  803118:	8d 50 01             	lea    0x1(%rax),%edx
  80311b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80311f:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803121:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80312a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80312e:	0f 82 60 ff ff ff    	jb     803094 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803134:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803138:	c9                   	leaveq 
  803139:	c3                   	retq   

000000000080313a <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80313a:	55                   	push   %rbp
  80313b:	48 89 e5             	mov    %rsp,%rbp
  80313e:	48 83 ec 40          	sub    $0x40,%rsp
  803142:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803146:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80314a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80314e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803152:	48 89 c7             	mov    %rax,%rdi
  803155:	48 b8 ca 1f 80 00 00 	movabs $0x801fca,%rax
  80315c:	00 00 00 
  80315f:	ff d0                	callq  *%rax
  803161:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803165:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803169:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80316d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803174:	00 
  803175:	e9 8e 00 00 00       	jmpq   803208 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80317a:	eb 31                	jmp    8031ad <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80317c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803180:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803184:	48 89 d6             	mov    %rdx,%rsi
  803187:	48 89 c7             	mov    %rax,%rdi
  80318a:	48 b8 1d 2f 80 00 00 	movabs $0x802f1d,%rax
  803191:	00 00 00 
  803194:	ff d0                	callq  *%rax
  803196:	85 c0                	test   %eax,%eax
  803198:	74 07                	je     8031a1 <devpipe_write+0x67>
				return 0;
  80319a:	b8 00 00 00 00       	mov    $0x0,%eax
  80319f:	eb 79                	jmp    80321a <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8031a1:	48 b8 fc 1c 80 00 00 	movabs $0x801cfc,%rax
  8031a8:	00 00 00 
  8031ab:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8031ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031b1:	8b 40 04             	mov    0x4(%rax),%eax
  8031b4:	48 63 d0             	movslq %eax,%rdx
  8031b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031bb:	8b 00                	mov    (%rax),%eax
  8031bd:	48 98                	cltq   
  8031bf:	48 83 c0 20          	add    $0x20,%rax
  8031c3:	48 39 c2             	cmp    %rax,%rdx
  8031c6:	73 b4                	jae    80317c <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8031c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031cc:	8b 40 04             	mov    0x4(%rax),%eax
  8031cf:	99                   	cltd   
  8031d0:	c1 ea 1b             	shr    $0x1b,%edx
  8031d3:	01 d0                	add    %edx,%eax
  8031d5:	83 e0 1f             	and    $0x1f,%eax
  8031d8:	29 d0                	sub    %edx,%eax
  8031da:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8031de:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8031e2:	48 01 ca             	add    %rcx,%rdx
  8031e5:	0f b6 0a             	movzbl (%rdx),%ecx
  8031e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031ec:	48 98                	cltq   
  8031ee:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8031f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f6:	8b 40 04             	mov    0x4(%rax),%eax
  8031f9:	8d 50 01             	lea    0x1(%rax),%edx
  8031fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803200:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803203:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803208:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80320c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803210:	0f 82 64 ff ff ff    	jb     80317a <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803216:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80321a:	c9                   	leaveq 
  80321b:	c3                   	retq   

000000000080321c <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80321c:	55                   	push   %rbp
  80321d:	48 89 e5             	mov    %rsp,%rbp
  803220:	48 83 ec 20          	sub    $0x20,%rsp
  803224:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803228:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80322c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803230:	48 89 c7             	mov    %rax,%rdi
  803233:	48 b8 ca 1f 80 00 00 	movabs $0x801fca,%rax
  80323a:	00 00 00 
  80323d:	ff d0                	callq  *%rax
  80323f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803243:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803247:	48 be a6 3e 80 00 00 	movabs $0x803ea6,%rsi
  80324e:	00 00 00 
  803251:	48 89 c7             	mov    %rax,%rdi
  803254:	48 b8 0b 14 80 00 00 	movabs $0x80140b,%rax
  80325b:	00 00 00 
  80325e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803260:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803264:	8b 50 04             	mov    0x4(%rax),%edx
  803267:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80326b:	8b 00                	mov    (%rax),%eax
  80326d:	29 c2                	sub    %eax,%edx
  80326f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803273:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803279:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80327d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803284:	00 00 00 
	stat->st_dev = &devpipe;
  803287:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80328b:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  803292:	00 00 00 
  803295:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80329c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032a1:	c9                   	leaveq 
  8032a2:	c3                   	retq   

00000000008032a3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8032a3:	55                   	push   %rbp
  8032a4:	48 89 e5             	mov    %rsp,%rbp
  8032a7:	48 83 ec 10          	sub    $0x10,%rsp
  8032ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8032af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032b3:	48 89 c6             	mov    %rax,%rsi
  8032b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8032bb:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  8032c2:	00 00 00 
  8032c5:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8032c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032cb:	48 89 c7             	mov    %rax,%rdi
  8032ce:	48 b8 ca 1f 80 00 00 	movabs $0x801fca,%rax
  8032d5:	00 00 00 
  8032d8:	ff d0                	callq  *%rax
  8032da:	48 89 c6             	mov    %rax,%rsi
  8032dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8032e2:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  8032e9:	00 00 00 
  8032ec:	ff d0                	callq  *%rax
}
  8032ee:	c9                   	leaveq 
  8032ef:	c3                   	retq   

00000000008032f0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8032f0:	55                   	push   %rbp
  8032f1:	48 89 e5             	mov    %rsp,%rbp
  8032f4:	48 83 ec 20          	sub    $0x20,%rsp
  8032f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8032fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032fe:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803301:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803305:	be 01 00 00 00       	mov    $0x1,%esi
  80330a:	48 89 c7             	mov    %rax,%rdi
  80330d:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  803314:	00 00 00 
  803317:	ff d0                	callq  *%rax
}
  803319:	c9                   	leaveq 
  80331a:	c3                   	retq   

000000000080331b <getchar>:

int
getchar(void)
{
  80331b:	55                   	push   %rbp
  80331c:	48 89 e5             	mov    %rsp,%rbp
  80331f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803323:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803327:	ba 01 00 00 00       	mov    $0x1,%edx
  80332c:	48 89 c6             	mov    %rax,%rsi
  80332f:	bf 00 00 00 00       	mov    $0x0,%edi
  803334:	48 b8 bf 24 80 00 00 	movabs $0x8024bf,%rax
  80333b:	00 00 00 
  80333e:	ff d0                	callq  *%rax
  803340:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803343:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803347:	79 05                	jns    80334e <getchar+0x33>
		return r;
  803349:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80334c:	eb 14                	jmp    803362 <getchar+0x47>
	if (r < 1)
  80334e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803352:	7f 07                	jg     80335b <getchar+0x40>
		return -E_EOF;
  803354:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803359:	eb 07                	jmp    803362 <getchar+0x47>
	return c;
  80335b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80335f:	0f b6 c0             	movzbl %al,%eax
}
  803362:	c9                   	leaveq 
  803363:	c3                   	retq   

0000000000803364 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803364:	55                   	push   %rbp
  803365:	48 89 e5             	mov    %rsp,%rbp
  803368:	48 83 ec 20          	sub    $0x20,%rsp
  80336c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80336f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803373:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803376:	48 89 d6             	mov    %rdx,%rsi
  803379:	89 c7                	mov    %eax,%edi
  80337b:	48 b8 8d 20 80 00 00 	movabs $0x80208d,%rax
  803382:	00 00 00 
  803385:	ff d0                	callq  *%rax
  803387:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80338a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80338e:	79 05                	jns    803395 <iscons+0x31>
		return r;
  803390:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803393:	eb 1a                	jmp    8033af <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803395:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803399:	8b 10                	mov    (%rax),%edx
  80339b:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8033a2:	00 00 00 
  8033a5:	8b 00                	mov    (%rax),%eax
  8033a7:	39 c2                	cmp    %eax,%edx
  8033a9:	0f 94 c0             	sete   %al
  8033ac:	0f b6 c0             	movzbl %al,%eax
}
  8033af:	c9                   	leaveq 
  8033b0:	c3                   	retq   

00000000008033b1 <opencons>:

int
opencons(void)
{
  8033b1:	55                   	push   %rbp
  8033b2:	48 89 e5             	mov    %rsp,%rbp
  8033b5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8033b9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8033bd:	48 89 c7             	mov    %rax,%rdi
  8033c0:	48 b8 f5 1f 80 00 00 	movabs $0x801ff5,%rax
  8033c7:	00 00 00 
  8033ca:	ff d0                	callq  *%rax
  8033cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033d3:	79 05                	jns    8033da <opencons+0x29>
		return r;
  8033d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d8:	eb 5b                	jmp    803435 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8033da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033de:	ba 07 04 00 00       	mov    $0x407,%edx
  8033e3:	48 89 c6             	mov    %rax,%rsi
  8033e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8033eb:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  8033f2:	00 00 00 
  8033f5:	ff d0                	callq  *%rax
  8033f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033fe:	79 05                	jns    803405 <opencons+0x54>
		return r;
  803400:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803403:	eb 30                	jmp    803435 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803409:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803410:	00 00 00 
  803413:	8b 12                	mov    (%rdx),%edx
  803415:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803417:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80341b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803422:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803426:	48 89 c7             	mov    %rax,%rdi
  803429:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  803430:	00 00 00 
  803433:	ff d0                	callq  *%rax
}
  803435:	c9                   	leaveq 
  803436:	c3                   	retq   

0000000000803437 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803437:	55                   	push   %rbp
  803438:	48 89 e5             	mov    %rsp,%rbp
  80343b:	48 83 ec 30          	sub    $0x30,%rsp
  80343f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803443:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803447:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80344b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803450:	75 07                	jne    803459 <devcons_read+0x22>
		return 0;
  803452:	b8 00 00 00 00       	mov    $0x0,%eax
  803457:	eb 4b                	jmp    8034a4 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803459:	eb 0c                	jmp    803467 <devcons_read+0x30>
		sys_yield();
  80345b:	48 b8 fc 1c 80 00 00 	movabs $0x801cfc,%rax
  803462:	00 00 00 
  803465:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803467:	48 b8 3c 1c 80 00 00 	movabs $0x801c3c,%rax
  80346e:	00 00 00 
  803471:	ff d0                	callq  *%rax
  803473:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803476:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80347a:	74 df                	je     80345b <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80347c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803480:	79 05                	jns    803487 <devcons_read+0x50>
		return c;
  803482:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803485:	eb 1d                	jmp    8034a4 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803487:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80348b:	75 07                	jne    803494 <devcons_read+0x5d>
		return 0;
  80348d:	b8 00 00 00 00       	mov    $0x0,%eax
  803492:	eb 10                	jmp    8034a4 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803494:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803497:	89 c2                	mov    %eax,%edx
  803499:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80349d:	88 10                	mov    %dl,(%rax)
	return 1;
  80349f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8034a4:	c9                   	leaveq 
  8034a5:	c3                   	retq   

00000000008034a6 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8034a6:	55                   	push   %rbp
  8034a7:	48 89 e5             	mov    %rsp,%rbp
  8034aa:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8034b1:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8034b8:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8034bf:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8034c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034cd:	eb 76                	jmp    803545 <devcons_write+0x9f>
		m = n - tot;
  8034cf:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8034d6:	89 c2                	mov    %eax,%edx
  8034d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034db:	29 c2                	sub    %eax,%edx
  8034dd:	89 d0                	mov    %edx,%eax
  8034df:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8034e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034e5:	83 f8 7f             	cmp    $0x7f,%eax
  8034e8:	76 07                	jbe    8034f1 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8034ea:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8034f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034f4:	48 63 d0             	movslq %eax,%rdx
  8034f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034fa:	48 63 c8             	movslq %eax,%rcx
  8034fd:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803504:	48 01 c1             	add    %rax,%rcx
  803507:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80350e:	48 89 ce             	mov    %rcx,%rsi
  803511:	48 89 c7             	mov    %rax,%rdi
  803514:	48 b8 2f 17 80 00 00 	movabs $0x80172f,%rax
  80351b:	00 00 00 
  80351e:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803520:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803523:	48 63 d0             	movslq %eax,%rdx
  803526:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80352d:	48 89 d6             	mov    %rdx,%rsi
  803530:	48 89 c7             	mov    %rax,%rdi
  803533:	48 b8 f2 1b 80 00 00 	movabs $0x801bf2,%rax
  80353a:	00 00 00 
  80353d:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80353f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803542:	01 45 fc             	add    %eax,-0x4(%rbp)
  803545:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803548:	48 98                	cltq   
  80354a:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803551:	0f 82 78 ff ff ff    	jb     8034cf <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803557:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80355a:	c9                   	leaveq 
  80355b:	c3                   	retq   

000000000080355c <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80355c:	55                   	push   %rbp
  80355d:	48 89 e5             	mov    %rsp,%rbp
  803560:	48 83 ec 08          	sub    $0x8,%rsp
  803564:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803568:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80356d:	c9                   	leaveq 
  80356e:	c3                   	retq   

000000000080356f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80356f:	55                   	push   %rbp
  803570:	48 89 e5             	mov    %rsp,%rbp
  803573:	48 83 ec 10          	sub    $0x10,%rsp
  803577:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80357b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80357f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803583:	48 be b2 3e 80 00 00 	movabs $0x803eb2,%rsi
  80358a:	00 00 00 
  80358d:	48 89 c7             	mov    %rax,%rdi
  803590:	48 b8 0b 14 80 00 00 	movabs $0x80140b,%rax
  803597:	00 00 00 
  80359a:	ff d0                	callq  *%rax
	return 0;
  80359c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035a1:	c9                   	leaveq 
  8035a2:	c3                   	retq   

00000000008035a3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8035a3:	55                   	push   %rbp
  8035a4:	48 89 e5             	mov    %rsp,%rbp
  8035a7:	48 83 ec 30          	sub    $0x30,%rsp
  8035ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  8035b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035bb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  8035bf:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8035c4:	75 0e                	jne    8035d4 <ipc_recv+0x31>
		page = (void *)KERNBASE;
  8035c6:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8035cd:	00 00 00 
  8035d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if ((r = sys_ipc_recv(page)) < 0) {
  8035d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d8:	48 89 c7             	mov    %rax,%rdi
  8035db:	48 b8 63 1f 80 00 00 	movabs $0x801f63,%rax
  8035e2:	00 00 00 
  8035e5:	ff d0                	callq  *%rax
  8035e7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8035ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8035ee:	79 27                	jns    803617 <ipc_recv+0x74>
		if (from_env_store != NULL)
  8035f0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8035f5:	74 0a                	je     803601 <ipc_recv+0x5e>
			*from_env_store = 0;
  8035f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035fb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store != NULL)
  803601:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803606:	74 0a                	je     803612 <ipc_recv+0x6f>
			*perm_store = 0;
  803608:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80360c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803612:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803615:	eb 53                	jmp    80366a <ipc_recv+0xc7>
	}

	if (from_env_store != NULL)
  803617:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80361c:	74 19                	je     803637 <ipc_recv+0x94>
		*from_env_store = thisenv->env_ipc_from;
  80361e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803625:	00 00 00 
  803628:	48 8b 00             	mov    (%rax),%rax
  80362b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803631:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803635:	89 10                	mov    %edx,(%rax)

	if (perm_store != NULL)
  803637:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80363c:	74 19                	je     803657 <ipc_recv+0xb4>
		*perm_store = thisenv->env_ipc_perm;
  80363e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803645:	00 00 00 
  803648:	48 8b 00             	mov    (%rax),%rax
  80364b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803651:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803655:	89 10                	mov    %edx,(%rax)

	return thisenv->env_ipc_value;
  803657:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80365e:	00 00 00 
  803661:	48 8b 00             	mov    (%rax),%rax
  803664:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
	//panic("ipc_recv not implemented");
	//return 0;
}
  80366a:	c9                   	leaveq 
  80366b:	c3                   	retq   

000000000080366c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80366c:	55                   	push   %rbp
  80366d:	48 89 e5             	mov    %rsp,%rbp
  803670:	48 83 ec 30          	sub    $0x30,%rsp
  803674:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803677:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80367a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80367e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int r;
	void *page = pg;
  803681:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803685:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (page == NULL)
  803689:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80368e:	75 10                	jne    8036a0 <ipc_send+0x34>
		page = (void *)KERNBASE;
  803690:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803697:	00 00 00 
  80369a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  80369e:	eb 0e                	jmp    8036ae <ipc_send+0x42>
  8036a0:	eb 0c                	jmp    8036ae <ipc_send+0x42>
		sys_yield();
  8036a2:	48 b8 fc 1c 80 00 00 	movabs $0x801cfc,%rax
  8036a9:	00 00 00 
  8036ac:	ff d0                	callq  *%rax
	void *page = pg;

	if (page == NULL)
		page = (void *)KERNBASE;

	while ((r = sys_ipc_try_send(to_env, val, page, perm)) == -E_IPC_NOT_RECV)
  8036ae:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8036b1:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8036b4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8036b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036bb:	89 c7                	mov    %eax,%edi
  8036bd:	48 b8 0e 1f 80 00 00 	movabs $0x801f0e,%rax
  8036c4:	00 00 00 
  8036c7:	ff d0                	callq  *%rax
  8036c9:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8036cc:	83 7d f4 f8          	cmpl   $0xfffffff8,-0xc(%rbp)
  8036d0:	74 d0                	je     8036a2 <ipc_send+0x36>
		sys_yield();

	if (r != 0)
  8036d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8036d6:	74 2a                	je     803702 <ipc_send+0x96>
		panic("error on ipc send procedure");
  8036d8:	48 ba b9 3e 80 00 00 	movabs $0x803eb9,%rdx
  8036df:	00 00 00 
  8036e2:	be 49 00 00 00       	mov    $0x49,%esi
  8036e7:	48 bf d5 3e 80 00 00 	movabs $0x803ed5,%rdi
  8036ee:	00 00 00 
  8036f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f6:	48 b9 2a 04 80 00 00 	movabs $0x80042a,%rcx
  8036fd:	00 00 00 
  803700:	ff d1                	callq  *%rcx
	//panic("ipc_send not implemented");
}
  803702:	c9                   	leaveq 
  803703:	c3                   	retq   

0000000000803704 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803704:	55                   	push   %rbp
  803705:	48 89 e5             	mov    %rsp,%rbp
  803708:	48 83 ec 14          	sub    $0x14,%rsp
  80370c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80370f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803716:	eb 5e                	jmp    803776 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803718:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80371f:	00 00 00 
  803722:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803725:	48 63 d0             	movslq %eax,%rdx
  803728:	48 89 d0             	mov    %rdx,%rax
  80372b:	48 c1 e0 03          	shl    $0x3,%rax
  80372f:	48 01 d0             	add    %rdx,%rax
  803732:	48 c1 e0 05          	shl    $0x5,%rax
  803736:	48 01 c8             	add    %rcx,%rax
  803739:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80373f:	8b 00                	mov    (%rax),%eax
  803741:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803744:	75 2c                	jne    803772 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803746:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80374d:	00 00 00 
  803750:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803753:	48 63 d0             	movslq %eax,%rdx
  803756:	48 89 d0             	mov    %rdx,%rax
  803759:	48 c1 e0 03          	shl    $0x3,%rax
  80375d:	48 01 d0             	add    %rdx,%rax
  803760:	48 c1 e0 05          	shl    $0x5,%rax
  803764:	48 01 c8             	add    %rcx,%rax
  803767:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80376d:	8b 40 08             	mov    0x8(%rax),%eax
  803770:	eb 12                	jmp    803784 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803772:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803776:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80377d:	7e 99                	jle    803718 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80377f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803784:	c9                   	leaveq 
  803785:	c3                   	retq   

0000000000803786 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803786:	55                   	push   %rbp
  803787:	48 89 e5             	mov    %rsp,%rbp
  80378a:	48 83 ec 18          	sub    $0x18,%rsp
  80378e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803796:	48 c1 e8 15          	shr    $0x15,%rax
  80379a:	48 89 c2             	mov    %rax,%rdx
  80379d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8037a4:	01 00 00 
  8037a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037ab:	83 e0 01             	and    $0x1,%eax
  8037ae:	48 85 c0             	test   %rax,%rax
  8037b1:	75 07                	jne    8037ba <pageref+0x34>
		return 0;
  8037b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8037b8:	eb 53                	jmp    80380d <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8037ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037be:	48 c1 e8 0c          	shr    $0xc,%rax
  8037c2:	48 89 c2             	mov    %rax,%rdx
  8037c5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8037cc:	01 00 00 
  8037cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8037d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037db:	83 e0 01             	and    $0x1,%eax
  8037de:	48 85 c0             	test   %rax,%rax
  8037e1:	75 07                	jne    8037ea <pageref+0x64>
		return 0;
  8037e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8037e8:	eb 23                	jmp    80380d <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8037ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ee:	48 c1 e8 0c          	shr    $0xc,%rax
  8037f2:	48 89 c2             	mov    %rax,%rdx
  8037f5:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8037fc:	00 00 00 
  8037ff:	48 c1 e2 04          	shl    $0x4,%rdx
  803803:	48 01 d0             	add    %rdx,%rax
  803806:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80380a:	0f b7 c0             	movzwl %ax,%eax
}
  80380d:	c9                   	leaveq 
  80380e:	c3                   	retq   
